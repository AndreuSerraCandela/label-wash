pageextension 50110 PostedSalesInvSubform extends "Posted Sales Invoice Subform" //133
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