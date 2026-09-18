pageextension 60119 GeneralLedgerEntries extends "General Ledger Entries" //20
{
    layout
    {
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
}