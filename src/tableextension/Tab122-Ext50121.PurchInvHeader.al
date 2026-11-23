tableextension 60121 "Purch. Inv. Header" extends "Purch. Inv. Header" //122
{
    fields
    {
        // Add changes to table fields here
        field(60100; "Tipo factura"; Enum "Tipo factura")
        {
            DataClassification = ToBeClassified;
        }
        field(60130; "Fecha de operación"; Date)
        {
            Caption = 'Fecha de operación';
            DataClassification = CustomerContent;
            ToolTip = 'Especifica la fecha de operación de la factura.';
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