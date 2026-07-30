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
            field("Alias remesa divisa"; Rec."Alias remesa divisa")
            {
                ApplicationArea = All;
                ToolTip = 'Alias corto usado en los ficheros de remesa en divisa.';
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