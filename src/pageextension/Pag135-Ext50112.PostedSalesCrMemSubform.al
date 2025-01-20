pageextension 50112 PostedSalesCrMemSubform extends "Posted Sales Cr. Memo Subform" //135
{
    layout
    {
        addafter(Description)
        {

            field("Part Number"; Rec."Part Number")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Part Number field.', Comment = '%';
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