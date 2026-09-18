/// <summary>
/// PageExtension ReminderLevelsServitec (ID 50508) extends Page Reminder Levels.
/// </summary>
pageextension 60128 ReminderLevelsServitec extends "Reminder Levels"
{
    layout
    {
        addafter("Add. Fee per Line Description")
        {
            field("PDF adjunto cargado"; HasReminderLevelPdf)
            {
                ApplicationArea = All;
                Caption = 'PDF adjunto cargado';
                Editable = false;
                ToolTip = 'Indica si el nivel de recordatorio tiene un PDF adjunto para añadirlo al informe.';
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("Importar PDF adjunto")
            {
                ApplicationArea = All;
                Caption = 'Importar PDF adjunto';
                Image = Import;
                ToolTip = 'Importa el PDF que se añadirá al informe para este nivel de recordatorio.';

                trigger OnAction()
                begin
                    ImportReminderLevelPdf();
                end;
            }

            action("Descargar PDF adjunto")
            {
                ApplicationArea = All;
                Caption = 'Descargar PDF adjunto';
                Image = Export;
                ToolTip = 'Descarga el PDF adjunto configurado para este nivel de recordatorio.';

                trigger OnAction()
                begin
                    DownloadReminderLevelPdf();
                end;
            }

            action("Eliminar PDF adjunto")
            {
                ApplicationArea = All;
                Caption = 'Eliminar PDF adjunto';
                Image = Delete;
                ToolTip = 'Elimina el PDF adjunto configurado para este nivel de recordatorio.';

                trigger OnAction()
                begin
                    DeleteReminderLevelPdf();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetHasReminderLevelPdf();
    end;

    local procedure ImportReminderLevelPdf()
    var
        PdfInStream: InStream;
        PdfOutStream: OutStream;
        FileName: Text;
    begin
        Rec.TestField("Reminder Terms Code");
        Rec.TestField("No.");

        if not UploadIntoStream(ImportPdfTitleLbl, '', PdfFileFilterLbl, FileName, PdfInStream) then
            exit;

        Rec."PDF Adjunto".CreateOutStream(PdfOutStream);
        CopyStream(PdfOutStream, PdfInStream);
        Rec.Modify(true);
        SetHasReminderLevelPdf();
        CurrPage.Update(false);
    end;

    local procedure DownloadReminderLevelPdf()
    var
        PdfInStream: InStream;
        FileName: Text;
    begin
        Rec.CalcFields("PDF Adjunto");
        if not Rec."PDF Adjunto".HasValue() then
            Error(NoPdfErr);

        FileName := StrSubstNo(PdfFileNameLbl, Rec."Reminder Terms Code", Rec."No.");
        Rec."PDF Adjunto".CreateInStream(PdfInStream);
        DownloadFromStream(PdfInStream, '', '', PdfFileFilterLbl, FileName);
    end;

    local procedure DeleteReminderLevelPdf()
    begin
        Rec.CalcFields("PDF Adjunto");
        if not Rec."PDF Adjunto".HasValue() then
            exit;

        if not Confirm(DeletePdfQst, false) then
            exit;

        Clear(Rec."PDF Adjunto");
        Rec.Modify(true);
        SetHasReminderLevelPdf();
        CurrPage.Update(false);
    end;

    local procedure SetHasReminderLevelPdf()
    begin
        Rec.CalcFields("PDF Adjunto");
        HasReminderLevelPdf := Rec."PDF Adjunto".HasValue();
    end;

    var
        HasReminderLevelPdf: Boolean;
        ImportPdfTitleLbl: Label 'Seleccionar PDF adjunto';
        PdfFileFilterLbl: Label 'PDF files (*.pdf)|*.pdf', Locked = true;
        PdfFileNameLbl: Label 'Recordatorio_%1_Nivel_%2.pdf', Locked = true;
        NoPdfErr: Label 'Este nivel de recordatorio no tiene PDF adjunto.';
        DeletePdfQst: Label '¿Quieres eliminar el PDF adjunto de este nivel de recordatorio?';
}
