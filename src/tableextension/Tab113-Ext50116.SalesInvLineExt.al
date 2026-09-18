tableextension 60116 SalesInvLineExt extends "Sales Invoice Line" //113
{
    fields
    {
        field(60101; "Pedido Compra"; Code[20])
        {
            Caption = 'Pedido Compra';
            DataClassification = ToBeClassified;
        }
        //linea
        field(60102; "Linea Pedido Compra"; Integer)
        {
            Caption = 'Linea Pedido Compra';
            DataClassification = ToBeClassified;
        }
        field(60151; "Part Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        // modify("Unit Volume")
        // {
        //     DecimalPalces= 3:3;
        // }
    }

}