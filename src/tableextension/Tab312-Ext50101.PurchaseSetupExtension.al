tableextension 60101 "Purchase Setup Extension" extends "Purchases & Payables Setup" //312
{
    fields
    {
        field(60100; "Proveedor Tratamientos"; Text[50])
        {
            Caption = 'Proveedor Tratamientos';
            TableRelation = Vendor;
        }
        field(60101; "Recepcion Tratamientos"; Code[20])
        {
            Caption = 'Serie recepción Tratamientos';
            TableRelation = "No. Series";
        }
        field(60102; "Recepciones Tratamientos"; Code[20])
        {
            Caption = 'Serie recepcines Tratamientos';
            TableRelation = "No. Series";
        }
    }
}