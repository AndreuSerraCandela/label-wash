pageextension 50117 GeneralJournal extends "General Journal" //39
{
    layout
    {
        addafter(Description)
        {

            field(Temporal; Rec.Temporal)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Temporal field.', Comment = '%';
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