codeunit 50101 SubcrpcionesCompra
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasePurchaseDoc', '', false, false)]
    procedure OnBeforeReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; var SkipCheckReleaseRestrictions: Boolean; var IsHandled: Boolean; SkipWhseRequestOperations: Boolean)
    var
        TLableError: Label 'No se puede Lanzar este documento por el con tipo de factura %1';

    begin
        if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice then
            if PurchaseHeader."Tipo factura" = PurchaseHeader."Tipo factura"::Proforma then
                Error(TLableError, PurchaseHeader."Tipo factura");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-post", 'OnBeforePostPurchaseDoc', '', false, false)]
    procedure OnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean; var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line"; var IsHandled: Boolean)
    var
        TLableError: Label 'No se puede registrar la factura con tipo de factura %1';
    begin
        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) then begin
            if (PurchaseHeader."Tipo factura" = PurchaseHeader."Tipo factura"::Proforma) then
                Error(TLableError, PurchaseHeader."Tipo factura");
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterDocumentReady', '', false, false)]
    local procedure OnAfterDocumentReady(ObjectId: Integer; ObjectPayload: JsonObject; DocumentStream: InStream; var TargetStream: OutStream; var Success: Boolean)
    var
        ReminderLevel: Record "Reminder Level";
        Base64Convert: Codeunit "Base64 Convert";
        ReminderTermsCode: Code[10];
        ReminderLevelNo: Integer;
        DocumentPdfBase64: Text;
        ReminderLevelPdfBase64: Text;
        MergedPdfBase64: Text;
    begin
        if Success then
            exit;

        if not IsPdfDocument(ObjectPayload) then
            exit;

        if not TryGetReminderLevel(ObjectPayload, ReminderTermsCode, ReminderLevelNo) then
            exit;

        if not ReminderLevel.Get(ReminderTermsCode, ReminderLevelNo) then
            exit;

        ReminderLevelPdfBase64 := GetReminderLevelPdfBase64(ReminderLevel);
        if ReminderLevelPdfBase64 = '' then
            exit;

        DocumentPdfBase64 := Base64Convert.ToBase64(DocumentStream);
        if DocumentPdfBase64 = '' then
            exit;

        if not TryMergePdfs(DocumentPdfBase64, ReminderLevelPdfBase64, MergedPdfBase64) then
            exit;

        if MergedPdfBase64 = '' then
            exit;

        Base64Convert.FromBase64(MergedPdfBase64, TargetStream);
        Success := true;
    end;

    local procedure IsPdfDocument(ObjectPayload: JsonObject): Boolean
    var
        DocumentTypeToken: JsonToken;
    begin
        if not ObjectPayload.Get('documenttype', DocumentTypeToken) then
            exit(true);

        exit(LowerCase(DocumentTypeToken.AsValue().AsText()) = 'application/pdf');
    end;

    local procedure TryGetReminderLevel(ObjectPayload: JsonObject; var ReminderTermsCode: Code[10]; var ReminderLevelNo: Integer): Boolean
    var
        FilterViews: JsonArray;
        FilterViewsToken: JsonToken;
        FilterViewToken: JsonToken;
        FilterViewObject: JsonObject;
        TableIdToken: JsonToken;
        ViewToken: JsonToken;
        TableId: Integer;
        ViewText: Text;
        I: Integer;
    begin
        if not ObjectPayload.Get('filterviews', FilterViewsToken) then
            exit(false);

        FilterViews := FilterViewsToken.AsArray();
        for I := 0 to FilterViews.Count() - 1 do begin
            FilterViews.Get(I, FilterViewToken);
            FilterViewObject := FilterViewToken.AsObject();

            if FilterViewObject.Get('tableid', TableIdToken) and FilterViewObject.Get('view', ViewToken) then begin
                TableId := TableIdToken.AsValue().AsInteger();
                ViewText := ViewToken.AsValue().AsText();

                case TableId of
                    Database::"Reminder Header":
                        if GetLevelFromReminderHeader(ViewText, ReminderTermsCode, ReminderLevelNo) then
                            exit(true);
                    Database::"Issued Reminder Header":
                        if GetLevelFromIssuedReminderHeader(ViewText, ReminderTermsCode, ReminderLevelNo) then
                            exit(true);
                end;
            end;
        end;

        exit(false);
    end;

    local procedure GetLevelFromReminderHeader(ViewText: Text; var ReminderTermsCode: Code[10]; var ReminderLevelNo: Integer): Boolean
    var
        ReminderHeader: Record "Reminder Header";
    begin
        ReminderHeader.SetView(ViewText);
        if not ReminderHeader.FindFirst() then
            exit(false);

        ReminderTermsCode := ReminderHeader."Reminder Terms Code";
        ReminderLevelNo := ReminderHeader."Reminder Level";
        exit((ReminderTermsCode <> '') and (ReminderLevelNo <> 0));
    end;

    local procedure GetLevelFromIssuedReminderHeader(ViewText: Text; var ReminderTermsCode: Code[10]; var ReminderLevelNo: Integer): Boolean
    var
        IssuedReminderHeader: Record "Issued Reminder Header";
    begin
        IssuedReminderHeader.SetView(ViewText);
        if not IssuedReminderHeader.FindFirst() then
            exit(false);

        ReminderTermsCode := IssuedReminderHeader."Reminder Terms Code";
        ReminderLevelNo := IssuedReminderHeader."Reminder Level";
        exit((ReminderTermsCode <> '') and (ReminderLevelNo <> 0));
    end;

    local procedure GetReminderLevelPdfBase64(var ReminderLevel: Record "Reminder Level"): Text
    var
        PdfInStream: InStream;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        ReminderLevel.CalcFields("PDF Adjunto");
        if not ReminderLevel."PDF Adjunto".HasValue() then
            exit('');

        ReminderLevel."PDF Adjunto".CreateInStream(PdfInStream);
        exit(Base64Convert.ToBase64(PdfInStream));
    end;

    [TryFunction]
    local procedure TryMergePdfs(BasePdf: Text; AttachmentPdf: Text; var MergedPdf: Text)
    begin
        MergedPdf := MergePdfs(BasePdf, AttachmentPdf);
    end;

    local procedure MergePdfs(BasePdf: Text; AttachmentPdf: Text): Text
    var
        CompanyInformation: Record "Company Information";
        RequestType: Option Get,Patch,Put,Post,Delete;
        Payload: Text;
        ResponseText: Text;
        UrlPdf: Text;
        JsonObj: JsonObject;
        ResponseJson: JsonObject;
        PdfToken: JsonToken;
    begin
        CompanyInformation.Get();
        UrlPdf := CompanyInformation."Url Pdf";
        if UrlPdf = '' then
            UrlPdf := DefaultPdfServiceUrlLbl;

        JsonObj.Add('pdf1', BasePdf);
        JsonObj.Add('pdf2', AttachmentPdf);
        JsonObj.WriteTo(Payload);

        ResponseText := RestApi(UrlPdf, RequestType::Post, Payload);
        if ResponseText = '' then
            exit('');

        if not ResponseJson.ReadFrom(ResponseText) then
            exit('');

        if ResponseJson.Get('pdf', PdfToken) then
            exit(PdfToken.AsValue().AsText());
    end;

    local procedure RestApi(Url: Text; RequestType: Option Get,Patch,Put,Post,Delete; Payload: Text): Text
    var
        Ok: Boolean;
        Client: HttpClient;
        RequestContent: HttpContent;
        ResponseMessage: HttpResponseMessage;
        RequestMessage: HttpRequestMessage;
        ResponseText: Text;
        ContentHeaders: HttpHeaders;
    begin
        case RequestType of
            RequestType::Get:
                Ok := Client.Get(Url, ResponseMessage);
            RequestType::Patch:
                begin
                    RequestContent.WriteFrom(Payload);
                    RequestContent.GetHeaders(ContentHeaders);
                    ContentHeaders.Clear();
                    ContentHeaders.Add('Content-Type', 'application/json-patch+json');

                    RequestMessage.Content := RequestContent;
                    RequestMessage.SetRequestUri(Url);
                    RequestMessage.Method := 'PATCH';

                    Ok := Client.Send(RequestMessage, ResponseMessage);
                end;
            RequestType::Put:
                begin
                    RequestContent.WriteFrom(Payload);
                    RequestContent.GetHeaders(ContentHeaders);
                    ContentHeaders.Clear();
                    ContentHeaders.Add('Content-Type', 'application/json');

                    Ok := Client.Put(Url, RequestContent, ResponseMessage);
                end;
            RequestType::Post:
                begin
                    RequestContent.WriteFrom(Payload);
                    RequestContent.GetHeaders(ContentHeaders);
                    ContentHeaders.Clear();
                    ContentHeaders.Add('Content-Type', 'application/json');

                    Ok := Client.Post(Url, RequestContent, ResponseMessage);
                end;
            RequestType::Delete:
                Ok := Client.Delete(Url, ResponseMessage);
        end;

        if not Ok then
            exit('');

        if not ResponseMessage.IsSuccessStatusCode() then
            exit('');

        ResponseMessage.Content().ReadAs(ResponseText);
        exit(ResponseText);
    end;

    var
        DefaultPdfServiceUrlLbl: Label 'https://gateway.malla.es/pdf', Locked = true;


}