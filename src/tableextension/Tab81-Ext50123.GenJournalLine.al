tableextension 60123 GenJournalLine extends "Gen. Journal Line" //81
{
    fields
    {
        field(60100; Temporal; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Temporal';
        }
        field(60102; "Ret. Temporal"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Ret. temporal';
        }
    }
}