pageextension 50120 CustomerdCard extends "Customer Card" //21
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