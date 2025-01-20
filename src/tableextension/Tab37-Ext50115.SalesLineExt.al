tableextension 50115 SalesLineExt extends "Sales Line" //37
{
    fields
    {
        field(50001; "Pedido Compra"; Code[20])
        {
            Caption = 'Pedido Compra';
            DataClassification = ToBeClassified;
        }
        //linea
        field(50002; "Linea Pedido Compra"; Integer)
        {
            Caption = 'Linea Pedido Compra';
            DataClassification = ToBeClassified;
        }
        field(50051; "Part Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

}
