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

    var
        myInt: Integer;
}