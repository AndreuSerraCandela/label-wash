pageextension 60138 JobLedgerEntries extends "Job Ledger Entries"
{
    actions
    {
        addlast("F&unctions")
        {
            action(CambiarDescripcion)
            {
                ApplicationArea = All;
                Caption = 'Cambiar descripción';
                Image = Edit;
                ToolTip = 'Cambia la descripción del movimiento de proyecto seleccionado.';
                AccessByPermission = codeunit "Cambiar desc. mov. proy." = X;

                trigger OnAction()
                var
                    CambiarDescMovProy: Codeunit "Cambiar desc. mov. proy.";
                    CambiarDescDialogo: Page "Cambiar desc. mov. proy.";
                    NuevaDescripcion: Text[100];
                begin
                    Rec.TestField("Entry No.");
                    NuevaDescripcion := Rec.Description;
                    CambiarDescDialogo.SetDescripcion(NuevaDescripcion);
                    if CambiarDescDialogo.RunModal() <> Action::OK then
                        exit;
                    CambiarDescMovProy.CambiarDescripcion(Rec."Entry No.", CambiarDescDialogo.GetDescripcion());
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
