pageextension 50127 GeneralLedgerSetupPageExt extends "General Ledger Setup"
{
    layout
    {
        addlast(General)
        {
            group(Temporalidad)
            {
                Caption = 'Temporalidad';

                field("Descr. retroces. temporalidad"; Rec."Descr. retroces. temporalidad")
                {
                    ApplicationArea = All;
                    ToolTip = 'Plantilla de descripción para apuntes de retrocesión. Marcadores: %Description, %Document No.';
                }
                field("Sufijo nº doc. retrocesión"; Rec."Sufijo nº doc. retrocesión")
                {
                    ApplicationArea = All;
                    ToolTip = 'Sufijo añadido al nº de documento del apunte original (por ejemplo -R).';
                }
                field("Documento Nuevo"; Rec."Documento Nuevo")
                {
                    ApplicationArea = All;
                    ToolTip = 'Si se activa, se crea un nuevo documento para el apunte de retrocesión.';
                }
                field("Seie Documento Nuevo"; Rec."Seie Documento Nuevo")
                {
                    ApplicationArea = All;
                    ToolTip = 'Serie de documentos para el apunte de retrocesión.';
                }
                field("Sin sufijo nº doc. retrocesión"; Rec."Sin sufijo nº doc. retrocesión")
                {
                    ApplicationArea = All;
                    ToolTip = 'Si se activa, no se añade ningún sufijo al nº de documento del apunte original al generar la retrocesión.';
                }
                field("Sin descripción retrocesión"; Rec."Sin descripción retrocesión")
                {
                    ApplicationArea = All;
                    ToolTip = 'Si se activa, no se añade ninguna descripción al apunte de retrocesión.';
                }
            }
        }
    }
}
