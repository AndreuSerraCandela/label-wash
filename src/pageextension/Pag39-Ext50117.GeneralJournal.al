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
        addafter("Currency Code")
        {
            field("Currency Factor"; Rec."Currency Factor")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the relationship between the additional reporting currency and the local currency. Amounts are recorded in both LCY and the additional reporting currency, using the relevant exchange rate and the currency factor.';
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