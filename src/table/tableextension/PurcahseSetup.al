tableextension 50101 "Purchase Setup Extension" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50100; "Proveedor Tratamientos"; Text[50])
        {
            Caption = 'Proveedor Tratamientos';
            TableRelation = Vendor;
        }
        field(50101; "Recepcion Tratamientos"; Code[20])
        {
            Caption = 'Serie recepción Tratamientos';
            TableRelation = "No. Series";
        }
        field(50102; "Recepciones Tratamientos"; Code[20])
        {
            Caption = 'Serie recepcines Tratamientos';
            TableRelation = "No. Series";
        }
    }
}