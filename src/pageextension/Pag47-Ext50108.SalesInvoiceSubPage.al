pageextension 50108 SalesInvoiceSubPage extends "Sales Invoice Subform" //47
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