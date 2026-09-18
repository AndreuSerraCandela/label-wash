tableextension 60115 SalesLineExt extends "Sales Line" //37
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
    }

}
