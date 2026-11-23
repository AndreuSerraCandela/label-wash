pageextension 60119 GeneralLedgerEntries extends "General Ledger Entries" //20
{
    layout
    {
        addafter("Global Dimension 2 Code")
        {
            field(DimensionColumna1; DimensionValor1)
            {
                ApplicationArea = Dimensions;
                CaptionClass = DimensionTitulo1;
                Editable = false;
                Visible = DimensionVisible1;
                ToolTip = 'Valor de la primera dimensión marcada en Configuración de contabilidad.';
            }
            field(DimensionColumna2; DimensionValor2)
            {
                ApplicationArea = Dimensions;
                CaptionClass = DimensionTitulo2;
                Editable = false;
                Visible = DimensionVisible2;
                ToolTip = 'Valor de la segunda dimensión marcada en Configuración de contabilidad.';
            }
            field(DimensionColumna3; DimensionValor3)
            {
                ApplicationArea = Dimensions;
                CaptionClass = DimensionTitulo3;
                Editable = false;
                Visible = DimensionVisible3;
                ToolTip = 'Valor de la tercera dimensión marcada en Configuración de contabilidad.';
            }
            field(DimensionColumna4; DimensionValor4)
            {
                ApplicationArea = Dimensions;
                CaptionClass = DimensionTitulo4;
                Editable = false;
                Visible = DimensionVisible4;
                ToolTip = 'Valor de la cuarta dimensión marcada en Configuración de contabilidad.';
            }
            field(DimensionColumna5; DimensionValor5)
            {
                ApplicationArea = Dimensions;
                CaptionClass = DimensionTitulo5;
                Editable = false;
                Visible = DimensionVisible5;
                ToolTip = 'Valor de la quinta dimensión marcada en Configuración de contabilidad.';
            }
            field(DimensionColumna6; DimensionValor6)
            {
                ApplicationArea = Dimensions;
                CaptionClass = DimensionTitulo6;
                Editable = false;
                Visible = DimensionVisible6;
                ToolTip = 'Valor de la sexta dimensión marcada en Configuración de contabilidad.';
            }
            field(DimensionColumna7; DimensionValor7)
            {
                ApplicationArea = Dimensions;
                CaptionClass = DimensionTitulo7;
                Editable = false;
                Visible = DimensionVisible7;
                ToolTip = 'Valor de la séptima dimensión marcada en Configuración de contabilidad.';
            }
            field(DimensionColumna8; DimensionValor8)
            {
                ApplicationArea = Dimensions;
                CaptionClass = DimensionTitulo8;
                Editable = false;
                Visible = DimensionVisible8;
                ToolTip = 'Valor de la octava dimensión marcada en Configuración de contabilidad.';
            }
        }
        modify("Global Dimension 1 Code")
        {
            Visible = false;
        }
        modify("Global Dimension 2 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 3 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 4 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 5 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 6 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 7 Code")
        {
            Visible = false;
        }
        modify("Shortcut Dimension 8 Code")
        {
            Visible = false;
        }
        addafter("Entry No.")
        {

            field(Temporal; Rec.Temporal)
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Indica si el apunte está marcado como temporal.';
            }
            field("Importe retrocedido"; Rec."Importe retrocedido")
            {
                ApplicationArea = All;
                Visible = False;
                Editable = false;
                ToolTip = 'Importe acumulado retrocedido en este apunte.';
            }
            field("Ret. Temporal"; Rec."Ret. Temporal")
            {
                ApplicationArea = All;
                Visible = False;
                Editable = false;
                ToolTip = 'Indica que el apunte se ha generado por una retrocesión de temporalidad.';
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            action(RetrocederTemporalidad)
            {
                ApplicationArea = All;
                Caption = 'Retroceder temporalidad';
                Image = Undo;
                ToolTip = 'Retrocede la temporalidad del apunte seleccionado, total o parcialmente.';
                Enabled = Rec.Temporal and (not Rec."Ret. Temporal") and (Rec."Importe retrocedido" < Abs(Rec.Amount));

                trigger OnAction()
                var
                    EventosVarios: Codeunit EventosVarios;
                begin
                    EventosVarios.RetrocederTemporalidad(Rec);
                    CurrPage.Update(false);
                end;
            }
            //Marcar Como Temporal
            action(MarcarComoTemporal)
            {
                ApplicationArea = All;
                Caption = 'Marcar como temporal';
                Image = Undo;
                ToolTip = 'Marca el apunte seleccionado como temporal.';
                Enabled = (not Rec.Temporal) and (not Rec."Ret. Temporal");
                trigger OnAction()
                var
                    EventosVarios: Codeunit EventosVarios;
                begin
                    EventosVarios.MarcarComoTemporal(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CargarDimensionesConfiguradas();
    end;

    trigger OnAfterGetRecord()
    begin
        DimensionValor1 := ValorDimension(DimensionCodigo1);
        DimensionValor2 := ValorDimension(DimensionCodigo2);
        DimensionValor3 := ValorDimension(DimensionCodigo3);
        DimensionValor4 := ValorDimension(DimensionCodigo4);
        DimensionValor5 := ValorDimension(DimensionCodigo5);
        DimensionValor6 := ValorDimension(DimensionCodigo6);
        DimensionValor7 := ValorDimension(DimensionCodigo7);
        DimensionValor8 := ValorDimension(DimensionCodigo8);
    end;

    local procedure CargarDimensionesConfiguradas()
    var
        MovContabDimension: Record "Mov. contab. dimensión";
        Posicion: Integer;
    begin
        MovContabDimension.EnsureDefaults();
        MovContabDimension.SetCurrentKey(Orden, "Dimension Code");
        MovContabDimension.SetRange(Mostrar, true);
        if MovContabDimension.FindSet() then
            repeat
                Posicion += 1;
                AsignarDimension(Posicion, MovContabDimension."Dimension Code");
            until (MovContabDimension.Next() = 0) or (Posicion >= 8);
    end;

    local procedure AsignarDimension(Posicion: Integer; CodigoDimension: Code[20])
    var
        Titulo: Text;
    begin
        Titulo := '1,5,' + CodigoDimension;
        case Posicion of
            1:
                begin
                    DimensionCodigo1 := CodigoDimension;
                    DimensionTitulo1 := Titulo;
                    DimensionVisible1 := true;
                end;
            2:
                begin
                    DimensionCodigo2 := CodigoDimension;
                    DimensionTitulo2 := Titulo;
                    DimensionVisible2 := true;
                end;
            3:
                begin
                    DimensionCodigo3 := CodigoDimension;
                    DimensionTitulo3 := Titulo;
                    DimensionVisible3 := true;
                end;
            4:
                begin
                    DimensionCodigo4 := CodigoDimension;
                    DimensionTitulo4 := Titulo;
                    DimensionVisible4 := true;
                end;
            5:
                begin
                    DimensionCodigo5 := CodigoDimension;
                    DimensionTitulo5 := Titulo;
                    DimensionVisible5 := true;
                end;
            6:
                begin
                    DimensionCodigo6 := CodigoDimension;
                    DimensionTitulo6 := Titulo;
                    DimensionVisible6 := true;
                end;
            7:
                begin
                    DimensionCodigo7 := CodigoDimension;
                    DimensionTitulo7 := Titulo;
                    DimensionVisible7 := true;
                end;
            8:
                begin
                    DimensionCodigo8 := CodigoDimension;
                    DimensionTitulo8 := Titulo;
                    DimensionVisible8 := true;
                end;
        end;
    end;

    local procedure ValorDimension(CodigoDimension: Code[20]): Code[20]
    var
        DimensionSetEntry: Record "Dimension Set Entry";
    begin
        if CodigoDimension = '' then
            exit('');
        if DimensionSetEntry.Get(Rec."Dimension Set ID", CodigoDimension) then
            exit(DimensionSetEntry."Dimension Value Code");
    end;

    var
        DimensionCodigo1: Code[20];
        DimensionCodigo2: Code[20];
        DimensionCodigo3: Code[20];
        DimensionCodigo4: Code[20];
        DimensionCodigo5: Code[20];
        DimensionCodigo6: Code[20];
        DimensionCodigo7: Code[20];
        DimensionCodigo8: Code[20];
        DimensionValor1: Code[20];
        DimensionValor2: Code[20];
        DimensionValor3: Code[20];
        DimensionValor4: Code[20];
        DimensionValor5: Code[20];
        DimensionValor6: Code[20];
        DimensionValor7: Code[20];
        DimensionValor8: Code[20];
        DimensionTitulo1: Text;
        DimensionTitulo2: Text;
        DimensionTitulo3: Text;
        DimensionTitulo4: Text;
        DimensionTitulo5: Text;
        DimensionTitulo6: Text;
        DimensionTitulo7: Text;
        DimensionTitulo8: Text;
        DimensionVisible1: Boolean;
        DimensionVisible2: Boolean;
        DimensionVisible3: Boolean;
        DimensionVisible4: Boolean;
        DimensionVisible5: Boolean;
        DimensionVisible6: Boolean;
        DimensionVisible7: Boolean;
        DimensionVisible8: Boolean;
}