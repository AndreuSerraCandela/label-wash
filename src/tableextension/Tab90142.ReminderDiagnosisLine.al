/// <summary>
/// Table Reminder Diagnosis Line (ID 90142).
/// </summary>
table 50142 "Reminder Diagnosis Line"
{
    Caption = 'Diagnóstico recordatorio';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Nº mov.';
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Nº cliente';
        }
        field(3; "Customer Name"; Text[100])
        {
            Caption = 'Nombre cliente';
        }
        field(4; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Tipo documento';
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Nº documento';
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Fecha registro';
        }
        field(7; "Document Date"; Date)
        {
            Caption = 'Fecha documento';
        }
        field(8; "Due Date"; Date)
        {
            Caption = 'Fecha vencimiento';
        }
        field(9; "Currency Code"; Code[10])
        {
            Caption = 'Divisa';
        }
        field(10; "Remaining Amount"; Decimal)
        {
            AutoFormatExpression = Rec."Currency Code";
            AutoFormatType = 1;
            Caption = 'Importe pendiente';
        }
        field(11; "Remaining Amt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Importe pendiente DL';
        }
        field(12; "On Hold"; Code[3])
        {
            Caption = 'En espera';
        }
        field(13; Positive; Boolean)
        {
            Caption = 'Positivo';
        }
        field(14; "Reminder Terms Code"; Code[10])
        {
            Caption = 'Términos recordatorio';
        }
        field(15; "Last Issued Reminder Level"; Integer)
        {
            Caption = 'Último nivel emitido';
        }
        field(16; "Next Reminder Level"; Integer)
        {
            Caption = 'Nivel calculado';
        }
        field(17; "Reminder Due Date"; Date)
        {
            Caption = 'Fecha base recordatorio';
        }
        field(18; "Grace Period"; DateFormula)
        {
            Caption = 'Periodo gracia';
        }
        field(19; "Grace Due Date"; Date)
        {
            Caption = 'Vencimiento con gracia';
        }
        field(20; "Open Reminder No."; Code[20])
        {
            Caption = 'Recordatorio abierto';
        }
        field(21; "Diagnostic Result"; Text[30])
        {
            Caption = 'Resultado';
        }
        field(22; "Include Candidate"; Boolean)
        {
            Caption = 'Candidato';
        }
        field(23; "Reason"; Text[250])
        {
            Caption = 'Motivo';
        }
        field(24; "Details"; Text[250])
        {
            Caption = 'Detalle';
        }
        field(25; "Candidate Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Total candidato DL';
        }
        field(26; "Minimum Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Importe mínimo DL';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Customer; "Customer No.", "Currency Code", "Document No.")
        {
        }
    }
}
