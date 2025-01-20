pageextension 50106 PostedPurchaseRcptSubform extends "Posted Purchase Rcpt. Subform" //137
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addlast("F&unctions")
        {

            action("DesUso")
            {
                ApplicationArea = Suite;
                Caption = 'DesUso';
                Image = Undo;
                ToolTip = 'Cancel the quantity posting on the selected posted receipt line. A corrective line is inserted under the selected receipt line. If the quantity was received in a warehouse receipt, then a corrective line is inserted in the posted warehouse receipt. The Quantity Received and Qty. Rcd. Not Invoiced fields on the related purchase order are set to zero.';

                trigger OnAction()
                begin
                    UndoReceiptLine();
                end;
            }
        }
        modify("&Undo Receipt")
        {
            Visible = false;
        }
    }

    var
        myInt: Integer;

        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";


    procedure UndoReceiptLine()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.Copy(Rec);
        CurrPage.SetSelectionFilter(PurchRcptLine);
        CODEUNIT.Run(CODEUNIT::"Undo Purchase Receipt Line", PurchRcptLine);
        DesUso(PurchRcptLine."Document No.", PurchRcptLine."Line No.");
    end;



    local procedure DesUso(DocumentNo: Code[20]; nline: Integer)
    var
        location: Record Location;
        ItemJnlLine: Record "Item Journal Line";
        OriginalItemJnlLine: Record "Item Journal Line";
        TempWhseJnlLine: Record "Warehouse Journal Line" temporary;
        TempWhseTrackingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecificationChargeAssmt: Record "Tracking Specification" temporary;
        TempReservationEntry: Record "Reservation Entry" temporary;
        PostWhseJnlLine: Boolean;
        CheckApplToItemEntry: Boolean;
        PostJobConsumptionBeforePurch: Boolean;
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        IsHandled: Boolean;
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ItemLedgShptEntryNo: Integer;
        CantidadaUsar: Decimal;
        CantidadaUsarBase: Decimal;
        ConfInv: Record "inventory posting setup";
        ConfInvT: Record "inventory posting setup";
        ConfInvM: Record "inventory posting setup";
    begin
        Clear(ItemJnlLine);

        PurchRcptHeader.Get(DocumentNo);


        PurchRcptLine.SetRange("Document No.", PurchRcptHeader."No.");
        PurchRcptLine.SetRange("Line No.", nline); //deshago una linea especifica
        if PurchRcptLine.FindFirst() then begin
            //  repeat

            ItemJnlLine.Init();
            PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, PurchRcptLine."Order No.");
            ItemJnlLine.CopyFromPurchHeader(PurchaseHeader);
            PurchaseLine.Get(PurchaseHeader."Document Type"::Order, PurchaseHeader."No.", PurchRcptLine."Order Line No.");
            ItemJnlLine.CopyFromPurchLine(PurchaseLine);
            ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
            ItemJnlLine."Item Shpt. Entry No." := 0;//ItemLedgShptEntryNo;
            ItemJnlLine."Document No." := PurchRcptLine."Document No.";
            ItemJnlLine."Posting Date" := PurchRcptHeader."Posting Date";
            // ItemJnlLine.Quantity := PurchRcptLine."Qty. Rcd. Not Invoiced";
            ItemJnlLine.Quantity := PurchRcptLine.Quantity;
            //ItemJnlLine."Quantity (Base)" := PurchRcptLine."Qty. Rcd. Not Invoiced" * PurchaseLine."Qty. per Unit of Measure";
            ItemJnlLine."Quantity (Base)" := PurchRcptLine."Quantity (Base)";
            if PurchaseLine."From-Location Code" <> '' then
                ItemJnlLine.Validate("Location Code", PurchaseLine."From-Location Code")
            else
                ItemJnlLine.Validate("Location Code", PurchaseHeader.AlmacenCliente(PurchaseHeader."Bill-to Customer No.", Recepcion::"Recepción", false));
            // ItemJnlLine."Invoiced Quantity" := 0;
            ItemJnlLine."Invoiced Quantity" := PurchRcptLine."Quantity Invoiced";
            ItemJnlLine."Invoiced Qty. (Base)" := PurchRcptLine."Qty. Invoiced (Base)";
            //ItemJnlLine."Invoiced Qty. (Base)" := 0;
            if ItemJnlLine.Quantity <> 0 Then
                RunItemJnlPostLine(ItemJnlLine);
            //  PurchRcptLine."Qty. Rcd. Not Invoiced" := 0;
            //PurchRcptLine.Modify();
            //until PurchRcptLine.Next() = 0;

        end;

    end;


    local procedure RunItemJnlPostLine(var ItemJnlLineToPost: Record "Item Journal Line")
    begin
        ItemJnlPostLine.RunWithCheck(ItemJnlLineToPost);
    end;
}
/*
action("&Undo Receipt")
                {
                    ApplicationArea = Suite;
                    Caption = '&Undo Receipt';
                    Image = Undo;
                    ToolTip = 'Cancel the quantity posting on the selected posted receipt line. A corrective line is inserted under the selected receipt line. If the quantity was received in a warehouse receipt, then a corrective line is inserted in the posted warehouse receipt. The Quantity Received and Qty. Rcd. Not Invoiced fields on the related purchase order are set to zero.';

                    trigger OnAction()
                    begin
                        UndoReceiptLine();
                    end;
                }
*/
