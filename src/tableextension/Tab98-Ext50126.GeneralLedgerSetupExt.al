tableextension 50126 GeneralLedgerSetupExt extends "General Ledger Setup"
{
    fields
    {
        field(50100; "Descr. retroces. temporalidad"; Text[250])
        {
            Caption = 'Descripción retrocesión temporalidad';
            DataClassification = ToBeClassified;
            InitValue = 'Retrocesión temporalidad %Description';
            ToolTip = 'Plantilla de descripción. Use %Description para la descripción del apunte o %Document No. para el nº de documento.';
        }
        field(50101; "Sufijo nº doc. retrocesión"; Code[10])
        {
            Caption = 'Sufijo nº documento retrocesión';
            DataClassification = ToBeClassified;
            InitValue = '-R';
            ToolTip = 'Sufijo que se añade al nº de documento del apunte original al generar la retrocesión. Ejemplo: -R';
        }
        //sin sufujo
        field(50102; "Sin sufijo nº doc. retrocesión"; Boolean)
        {
            Caption = 'Sin sufijo nº documento retrocesión';
            DataClassification = ToBeClassified;
            InitValue = false;
            ToolTip = 'Si se activa, no se añade ningún sufijo al nº de documento del apunte original al generar la retrocesión.';
        }
        //sin descripcion
        field(50103; "Sin descripción retrocesión"; Boolean)
        {
            Caption = 'Sin descripción retrocesión';
            DataClassification = ToBeClassified;
            InitValue = false;
            ToolTip = 'Si se activa, no se añade ninguna descripción al apunte de retrocesión.';
        }
        //documento nuevo
        field(50104; "Documento Nuevo"; Boolean)
        {
            Caption = 'Documento nuevo';
            DataClassification = ToBeClassified;
            InitValue = false;
            ToolTip = 'Si se activa, se crea un nuevo documento para el apunte de retrocesión.';
        }
        //serie documento nuevo
        field(50105; "Seie Documento Nuevo"; Code[20])
        {
            Caption = 'Serie documento nuevo';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
            ToolTip = 'Serie de documentos para el apunte de retrocesión.';
        }

    }
}
