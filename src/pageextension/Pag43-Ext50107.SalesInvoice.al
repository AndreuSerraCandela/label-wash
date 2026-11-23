pageextension 60107 SalesInvoice extends "Sales Invoice" //43
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
        addafter("Your Reference")
        {

            field("Albaran No."; Rec."Albaran No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Albaran No. field.', Comment = '%';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}