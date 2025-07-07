pageextension 50121 VendorCard extends "Vendor Card" //26
{
    layout
    {
        addafter("Balance (LCY)")
        {


            field(Temporal; Rec.Temporal)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Temporales field.', Comment = '%';
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