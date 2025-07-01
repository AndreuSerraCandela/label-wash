tableextension 50122 MoVContabilidad extends "G/L Entry" //17
{
    fields
    {
        field(50100; Temporal; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}