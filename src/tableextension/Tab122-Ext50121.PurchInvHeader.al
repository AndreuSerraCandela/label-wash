tableextension 50121 "Purch. Inv. Header" extends "Purch. Inv. Header" //122
{
    fields
    {
        // Add changes to table fields here
        field(50200; "Tipo factura"; Enum "Tipo factura")
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