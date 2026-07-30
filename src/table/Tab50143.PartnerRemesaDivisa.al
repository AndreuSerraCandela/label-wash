table 50143 "Partner Remesa Divisa"
{
    Caption = 'Partner Remesa Divisa';
    TableType = Temporary;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; Alias; Code[20])
        {
            Caption = 'Alias';
        }
        field(3; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(4; IBAN; Text[50])
        {
            Caption = 'IBAN';
        }
        field(5; "SWIFT Code"; Code[20])
        {
            Caption = 'SWIFT Code';
        }
        field(6; Address; Text[250])
        {
            Caption = 'Address';
        }
        field(7; County; Text[30])
        {
            Caption = 'County';
        }
        field(8; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
        }
        field(9; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}
