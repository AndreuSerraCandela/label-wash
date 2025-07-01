pageextension 50119 GeneralLedgerEntries extends "General Ledger Entries" //20
{
    layout
    {
        addafter("Entry No.")
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