page 60149 "Retrocesión Temporalidad"
{
    PageType = StandardDialog;
    Caption = 'Retroceder temporalidad';
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'Datos de retrocesión';
                field("Fecha retrocesión"; FechaRetrocesion)
                {
                    ApplicationArea = All;
                    Caption = 'Fecha de retrocesión';
                    ToolTip = 'Fecha en la que se registrará la retrocesión de temporalidad.';
                }
                field("Importe a retroceder"; ImporteRetroceder)
                {
                    ApplicationArea = All;
                    Caption = 'Importe a retroceder';
                    ToolTip = 'Importe de temporalidad que desea retroceder en este apunte.';
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = Action::OK then begin
            if ImporteRetroceder <= 0 then
                Error(ImporteDebeSerPositivoErr);
            if ImporteRetroceder > GetImportePendiente() then
                Error(ImporteMayorQuePendienteErr, GetImportePendiente());
        end;
        exit(true);
    end;

    procedure SetGLEntry(GLEntry: Record "G/L Entry")
    begin
        SourceGLEntry := GLEntry;
        FechaRetrocesion := GLEntry."Posting Date";
        ImporteRetroceder := GetImportePendiente();
    end;

    local procedure GetImportePendiente(): Decimal
    begin
        exit(Abs(SourceGLEntry.Amount) - SourceGLEntry."Importe retrocedido");
    end;

    procedure GetValues(var FechaRetrocesionOut: Date; var ImporteRetrocederOut: Decimal)
    begin
        FechaRetrocesionOut := FechaRetrocesion;
        ImporteRetrocederOut := ImporteRetroceder;
    end;

    var
        SourceGLEntry: Record "G/L Entry";
        FechaRetrocesion: Date;
        ImporteRetroceder: Decimal;
        ImporteDebeSerPositivoErr: Label 'El importe a retroceder debe ser mayor que cero.';
        ImporteMayorQuePendienteErr: Label 'El importe no puede ser mayor que el pendiente de retroceder (%1).';
}
