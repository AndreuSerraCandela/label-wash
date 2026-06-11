tableextension 50123 GenJournalLine extends "Gen. Journal Line" //81
{
    fields
    {
        field(50100; Temporal; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Temporal';
        }
        field(50102; "Ret. Temporal"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Ret. temporal';
        }
    }
}