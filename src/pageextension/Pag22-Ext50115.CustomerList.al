pageextension 50115 CustomerList extends "Customer List" //22
{
    layout
    {
        addafter(Name)
        {
            field(Temporales; Rec.Temporal)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Temporales field.', Comment = '%';
            }

            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s VAT registration number for customers in EU countries/regions.';
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