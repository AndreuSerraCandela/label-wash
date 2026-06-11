tableextension 50122 MoVContabilidad extends "G/L Entry" //17
{
    fields
    {
        field(50100; Temporal; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Temporal';
        }
        field(50101; "Importe retrocedido"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Importe retrocedido';
            DecimalPlaces = 2 : 2;
            MinValue = 0;
        }
        field(50102; "Ret. Temporal"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Ret. temporal';
        }
    }
}