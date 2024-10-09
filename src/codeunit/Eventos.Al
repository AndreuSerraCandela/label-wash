codeunit 50100 EventosTratamientos
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)
    begin
        if PurchaseHeader.Recepcion <> Recepcion::" " Then begin
            PurchaseHeader.Receive := true;
            PurchaseHeader.Invoice := false;
            HideDialog := true;
        end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Line - Price", 'OnAfterSetPrice', '', false, false)]
    local procedure OnAfterSetPrice(var SalesLine: Record "Sales Line"; PriceListLine: Record "Price List Line"; AmountType: Enum "Price Amount Type"; var SalesHeader: Record "Sales Header")
    begin
        If PriceListLine."Precio de Uso" <> 0 Then
            SalesLine."Unit Volume" := PriceListLine."Precio de Uso";

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnFindSalesLinePriceOnItemTypeOnAfterSetUnitPrice', '', false, false)]
    local procedure OnFindSalesLinePriceOnItemTypeOnAfterSetUnitPrice(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var TempSalesPrice: Record "Sales Price" temporary; CalledByFieldNo: Integer; FoundSalesPrice: Boolean)
    begin
        if TempSalesPrice."Precio de Tartamiento" <> 0 Then
            SalesLine."Unit Volume" := TempSalesPrice."Precio de Tartamiento";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterUpdatePurchLineBeforePost', '', false, false)]
    local procedure OnAfterUpdatePurchLineBeforePost(var PurchaseLine: Record "Purchase Line"; WhseShip: Boolean; WhseReceive: Boolean; PurchaseHeader: Record "Purchase Header"; RoundingLineInserted: Boolean)
    begin
        if PurchaseHeader.Recepcion = Recepcion::Tratamiento then begin
            PurchaseLine."Qty. to Receive" := PurchaseLine."Cantidad a Tratar";
            PurchaseLine."Qty. to Receive (Base)" := PurchaseLine."Cantidad a Tratar Base";
            PurchaseLine.Modify();

        end;
        If PurchaseHeader.Recepcion = Recepcion::Uso then begin
            PurchaseLine."Qty. to Receive" := PurchaseLine."Cantidad a Uso";
            PurchaseLine."Qty. to Receive (Base)" := PurchaseLine."Cantidad a Uso Base";
            PurchaseLine.Modify();
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry"; WhseShip: Boolean; WhseReceiv: Boolean; PreviewMode: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
    begin
        If SalesInvHdrNo = '' then
            exit;
        SalesInvoiceLine.SetRange("Document No.", SalesInvHdrNo);
        If SalesInvoiceLine.FindFirst() Then
            repeat
                PurchaseLine.SetRange("Document No.", SalesInvoiceLine."Pedido Compra");
                PurchaseLine.SetRange("Line No.", SalesInvoiceLine."Linea Pedido Compra");
                If PurchaseLine.FindFirst() Then begin
                    PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
                    case PurchaseHeader.Recepcion Of
                        Recepcion::Tratamiento:
                            begin
                                PurchaseLine."Cantidad a facturar Tratada" := 0;
                                PurchaseLine."Cantidad a facturada Tratada" += SalesInvoiceLine."Quantity";
                                PurchaseLine.Modify();
                            end;
                        Recepcion::Uso:
                            begin
                                PurchaseLine."Cantidad a facturar Uso" := 0;
                                PurchaseLine."Cantidad a facturada Uso" += SalesInvoiceLine."Quantity";
                                PurchaseLine.Modify();
                            end;
                    end;

                end;
            until SalesInvoiceLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");

        if PurchaseHeader.Recepcion = Recepcion::Tratamiento then begin
            if PurchaseLine.FindSet() then
                repeat

                    PurchaseLine."Quantity Received" := PurchaseLine."Cantidad a Tratar" + PurchaseLine."Cantidad a Merma";
                    PurchaseLine."Qty. Received (Base)" := PurchaseLine."Quantity Received" * PurchaseLine."Qty. per Unit of Measure";
                    PurchaseLine."Qty. Rcd. Not Invoiced" := PurchaseLine."Quantity Received";
                    PurchaseLine."Qty. Rcd. Not Invoiced (Base)" := PurchaseLine."Qty. Received (Base)";

                    PurchaseLine."Qty. to Receive" := PurchaseLine.Quantity - PurchaseLine."Quantity Received";
                    PurchaseLine."Qty. to Receive (Base)" := PurchaseLine."Quantity (Base)" - PurchaseLine."Qty. Received (Base)";
                    PurchaseLine."Cantidad Tratada" := PurchaseLine."Cantidad a tratar";
                    PurchaseLine."Cantidad Tratada Base" := PurchaseLine."Cantidad a tratar Base";
                    PurchaseLine."Cantidad a Tratar" := PurchaseLine."Qty. to Receive";
                    PurchaseLine."Cantidad a Tratar Base" := PurchaseLine."Qty. to Receive (Base)";
                    PurchaseLine."Cantidad a facturar Tratada" := PurchaseLine."Cantidad a tratar" + PurchaseLine."Cantidad a Merma";
                    //PurchaseLine."Cantidad a Merma" := 0;
                    //PurchaseLine."Cantidad a Merma Base" := 0;
                    PurchaseLine.Modify();
                until PurchaseLine.Next() = 0;

        end;
        if PurchaseHeader.Recepcion = Recepcion::Uso then begin
            if PurchaseLine.FindSet() then
                repeat
                    PurchaseLine."Quantity Received" := PurchaseLine."Cantidad a Tratar" + PurchaseLine."Cantidad a Merma Uso";
                    PurchaseLine."Qty. Received (Base)" := PurchaseLine."Quantity Received" * PurchaseLine."Qty. per Unit of Measure";
                    PurchaseLine."Qty. Rcd. Not Invoiced" := PurchaseLine."Quantity Received";
                    PurchaseLine."Qty. Rcd. Not Invoiced (Base)" := PurchaseLine."Qty. Received (Base)";

                    PurchaseLine."Qty. to Receive" := PurchaseLine.Quantity - PurchaseLine."Quantity Received";
                    PurchaseLine."Qty. to Receive (Base)" := PurchaseLine."Quantity (Base)" - PurchaseLine."Qty. Received (Base)";
                    PurchaseLine."Cantidad Usada" := PurchaseLine."Cantidad a uso";
                    PurchaseLine."Cantidad Usada Base" := PurchaseLine."Cantidad a uso Base";
                    PurchaseLine."Cantidad a Uso" := PurchaseLine."Qty. to Receive";
                    PurchaseLine."Cantidad a uso Base" := PurchaseLine."Qty. to Receive (Base)";
                    PurchaseLine."Cantidad a facturar Uso" := PurchaseLine."Cantidad a uso";
                    PurchaseLine.Modify();
                until PurchaseLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnBeforeGetConditionalCardPageID', '', false, false)]
    local procedure OnBeforeGetConditionalCardPageID(RecRef: RecordRef; var CardPageID: Integer; var IsHandled: Boolean);
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        If RecRef.Number = 38 Then begin
            If Recepcion.FromInteger(Recref.Field(PurchaseHeader.FieldNo(Recepcion)).Value) = Recepcion::Tratamiento then
                CardPageID := Page::"Tratamiento Mercancía";
            If Recepcion.FromInteger(Recref.Field(PurchaseHeader.FieldNo(Recepcion)).Value) = Recepcion::Uso then
                CardPageID := Page::"Uso Mercancía";
            If Recepcion.FromInteger(Recref.Field(PurchaseHeader.FieldNo(Recepcion)).Value) = Recepcion::"Recepción" then
                CardPageID := Page::"Recepción Mercancía";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeValidateEmptySellToCustomerAndLocation', '', false, false)]
    local procedure OnBeforeValidateEmptySellToCustomerAndLocation(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor; var IsHandled: Boolean; var xPurchaseHeader: Record "Purchase Header")
    begin
        IsHandled := PurchaseHeader.Recepcion <> Recepcion::" ";
    end;

}