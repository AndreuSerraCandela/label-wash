pageextension 60136 PostedPurchaseInvoice extends "Posted Purchase Invoice"
{
    layout
    {
        addafter("Posting Date")
        {
            field("Fecha de operación"; Rec."Fecha de operación")
            {
                ApplicationArea = All;
                ToolTip = 'Especifica la fecha de operación de la factura.';
            }
        }
    }
}
