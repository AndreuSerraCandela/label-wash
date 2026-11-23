pageextension 60114 PurchaseInvoice extends "Purchase Invoice" //51
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
        addafter(Status)
        {
            field("Tipo factura"; Rec."Tipo factura")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tipo factura field.', Comment = '%';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
        c: Codeunit "Release Purchase Document";
}