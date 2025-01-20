pageextension 50111 PostedSalesCreditMemo extends "Posted Sales Credit Memo" //134
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