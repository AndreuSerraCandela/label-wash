table 60133 "Mov. contab. dimensión"
{
    Caption = 'Dimensión en movimientos de contabilidad';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Dimension Code"; Code[20])
        {
            Caption = 'Cód. dimensión';
            NotBlank = true;
            TableRelation = Dimension;
            ToolTip = 'Especifica la dimensión que puede mostrarse como columna en Movimientos de contabilidad.';
        }
        field(2; Orden; Integer)
        {
            Caption = 'Orden';
            MinValue = 0;
            ToolTip = 'Especifica la posición de la columna. El número más bajo aparece más a la izquierda.';
        }
        field(3; Mostrar; Boolean)
        {
            Caption = 'Mostrar';
            InitValue = true;
            ToolTip = 'Especifica si la dimensión se muestra como columna en Movimientos de contabilidad.';

            trigger OnValidate()
            var
                Otras: Record "Mov. contab. dimensión";
            begin
                if not Mostrar then
                    exit;
                Otras.SetRange(Mostrar, true);
                Otras.SetFilter("Dimension Code", '<>%1', "Dimension Code");
                if Otras.Count() >= MaxColumnasVisibles() then
                    Error(MaxColumnasErr, MaxColumnasVisibles());
            end;
        }
        field(4; "Dimension Name"; Text[50])
        {
            CalcFormula = lookup(Dimension.Name where(Code = field("Dimension Code")));
            Caption = 'Nombre';
            Editable = false;
            FieldClass = FlowField;
            ToolTip = 'Especifica el nombre de la dimensión.';
        }
    }

    keys
    {
        key(PK; "Dimension Code")
        {
            Clustered = true;
        }
        key(Orden; Orden, "Dimension Code")
        {
        }
    }

    trigger OnInsert()
    var
        Ultima: Record "Mov. contab. dimensión";
    begin
        if Orden <> 0 then
            exit;
        Ultima.SetCurrentKey(Orden);
        if Ultima.FindLast() then
            Orden := Ultima.Orden + 1
        else
            Orden := 1;
    end;

    procedure EnsureDefaults()
    var
        GLSetup: Record "General Ledger Setup";
        AccesoDirecto: Integer;
        CodigoDimension: Code[20];
    begin
        if not GLSetup.Get() then
            exit;
        for AccesoDirecto := 1 to 8 do begin
            CodigoDimension := ShortcutDimensionCode(GLSetup, AccesoDirecto);
            if CodigoDimension <> '' then
                InsertDefault(CodigoDimension, AccesoDirecto);
        end;
    end;

    local procedure InsertDefault(CodigoDimension: Code[20]; OrdenInicial: Integer)
    var
        Nueva: Record "Mov. contab. dimensión";
    begin
        if Nueva.Get(CodigoDimension) then
            exit;
        Nueva.Init();
        Nueva."Dimension Code" := CodigoDimension;
        Nueva.Orden := OrdenInicial;
        Nueva.Mostrar := true;
        Nueva.Insert(true);
    end;

    local procedure ShortcutDimensionCode(GLSetup: Record "General Ledger Setup"; AccesoDirecto: Integer): Code[20]
    begin
        case AccesoDirecto of
            1:
                if GLSetup."Shortcut Dimension 1 Code" <> '' then
                    exit(GLSetup."Shortcut Dimension 1 Code")
                else
                    exit(GLSetup."Global Dimension 1 Code");
            2:
                if GLSetup."Shortcut Dimension 2 Code" <> '' then
                    exit(GLSetup."Shortcut Dimension 2 Code")
                else
                    exit(GLSetup."Global Dimension 2 Code");
            3:
                exit(GLSetup."Shortcut Dimension 3 Code");
            4:
                exit(GLSetup."Shortcut Dimension 4 Code");
            5:
                exit(GLSetup."Shortcut Dimension 5 Code");
            6:
                exit(GLSetup."Shortcut Dimension 6 Code");
            7:
                exit(GLSetup."Shortcut Dimension 7 Code");
            8:
                exit(GLSetup."Shortcut Dimension 8 Code");
        end;
    end;

    local procedure MaxColumnasVisibles(): Integer
    begin
        exit(8);
    end;

    var
        MaxColumnasErr: Label 'Solo se pueden mostrar %1 dimensiones en Movimientos de contabilidad.';
}
