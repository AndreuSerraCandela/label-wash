tableextension 50116 SalesInvLineExt extends "Sales Invoice Line" //113
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
        // modify("Unit Volume")
        // {
        //     DecimalPalces= 3:3;
        // }
    }

}