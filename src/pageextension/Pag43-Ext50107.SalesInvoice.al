pageextension 50107 SalesInvoice extends "Sales Invoice" //43
{
    layout
    {
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