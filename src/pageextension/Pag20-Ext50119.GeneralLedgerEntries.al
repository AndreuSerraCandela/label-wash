pageextension 60119 GeneralLedgerEntries extends "General Ledger Entries" //20
{
    layout
    {
        addafter("Global Dimension 2 Code")
        {
            field("Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,3';
                Editable = false;
                Visible = Dim3Visible;
                ToolTip = 'Código de la dimensión acceso directo 3 definida en la configuración contable.';
            }
            field("Dimension 4 Code"; Rec."Shortcut Dimension 4 Code")
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,4';
                Editable = false;
                Visible = Dim4Visible;
                ToolTip = 'Código de la dimensión acceso directo 4 definida en la configuración contable.';
            }
            field("Dimension 5 Code"; Rec."Shortcut Dimension 5 Code")
            {
                ApplicationArea = Dimensions;
                CaptionClass = '1,2,5';
                Editable = false;
                Visible = Dim5Visible;
                ToolTip = 'Código de la dimensión acceso directo 5 definida en la configuración contable.';
            }
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
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();
        Dim3Visible := GeneralLedgerSetup."Shortcut Dimension 3 Code" <> '';
        Dim4Visible := GeneralLedgerSetup."Shortcut Dimension 4 Code" <> '';
        Dim5Visible := GeneralLedgerSetup."Shortcut Dimension 5 Code" <> '';
    end;

    var
        Dim3Visible: Boolean;
        Dim4Visible: Boolean;
        Dim5Visible: Boolean;
}