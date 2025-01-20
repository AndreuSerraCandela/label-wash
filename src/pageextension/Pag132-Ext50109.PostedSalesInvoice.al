pageextension 50109 PostedSalesInvoice extends "Posted Sales Invoice" //132
{
    layout
    {
        addafter("Posting Date")
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