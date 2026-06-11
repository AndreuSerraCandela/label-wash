codeunit 50102 EventosVarios
{
    Permissions = tableData "G/L Entry" = RIMD;
    trigger OnRun()
    begin

    end;

    procedure RetrocederTemporalidad(var GLEntry: Record "G/L Entry")
    var
        RetrocesionTemporalidadPage: Page "Retrocesión Temporalidad";
        FechaRetrocesion: Date;
        ImporteRetroceder: Decimal;
    begin
        ValidarApunteParaOperacionTemporal(GLEntry);
        GLEntry.TestField(Temporal, true);
        if GetImportePendienteRetroceder(GLEntry) <= 0 then
            Error(ImporteTotalRetrocedidoErr);

        RetrocesionTemporalidadPage.SetGLEntry(GLEntry);
        if RetrocesionTemporalidadPage.RunModal() <> Action::OK then
            exit;

        RetrocesionTemporalidadPage.GetValues(FechaRetrocesion, ImporteRetroceder);

        if EsRetrocesionSinAsiento(GLEntry, FechaRetrocesion, ImporteRetroceder) then
            FinalizarRetrocesion(GLEntry, ImporteRetroceder, true)
        else
            CrearApuntesRetrocesion(GLEntry, FechaRetrocesion, ImporteRetroceder);
    end;

    internal procedure MarcarComoTemporal(var GLEntry: Record "G/L Entry")
    begin
        ValidarApunteParaOperacionTemporal(GLEntry);
        if GLEntry.Temporal then
            Error(ApunteYaTemporalErr);

        GLEntry.Temporal := true;
        GLEntry.Modify(true);
        Message(MarcaPuestaMsg);
    end;

    local procedure ValidarApunteParaOperacionTemporal(GLEntry: Record "G/L Entry")
    begin
        if GLEntry."Ret. Temporal" then
            Error(ApunteRetTemporalErr);
    end;

    local procedure GetImportePendienteRetroceder(GLEntry: Record "G/L Entry"): Decimal
    begin
        exit(Abs(GLEntry.Amount) - GLEntry."Importe retrocedido");
    end;


    local procedure EsRetrocesionSinAsiento(GLEntry: Record "G/L Entry"; FechaRetrocesion: Date; ImporteRetroceder: Decimal): Boolean
    begin
        exit(
            (GLEntry."Importe retrocedido" = 0) and
            (ImporteRetroceder = Abs(GLEntry.Amount)) and
            (FechaRetrocesion = GLEntry."Posting Date"));
    end;

    local procedure FinalizarRetrocesion(var GLEntry: Record "G/L Entry"; ImporteRetroceder: Decimal; QuitarMarca: Boolean)
    begin
        GLEntry."Importe retrocedido" += ImporteRetroceder;
        if QuitarMarca then
            GLEntry.Temporal := false;
        GLEntry.Modify(true);

        if QuitarMarca then
            Message(MarcaQuitadaMsg)
        else
            Message(ImporteRetrocedidoActualizadoMsg, GLEntry."Importe retrocedido");
    end;

    local procedure CrearApuntesRetrocesion(GLEntry: Record "G/L Entry"; FechaRetrocesion: Date; ImporteRetroceder: Decimal)
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        DocNo: Code[20];
        NextLineNo: Integer;
        SignFactor: Integer;
        AmountTemporalFalse: Decimal;
        AmountTemporalTrue: Decimal;
    begin
        GetGenJnlTemplateAndBatch(JournalTemplateName, JournalBatchName);

        SignFactor := 1;
        if GLEntry.Amount < 0 then
            SignFactor := -1;

        AmountTemporalFalse := ImporteRetroceder * SignFactor;
        AmountTemporalTrue := -AmountTemporalFalse;

        DocNo := GetNoDocumentoRetrocesion(GLEntry);
        NextLineNo := GetNextGenJnlLineNo(JournalTemplateName, JournalBatchName);

        InitGenJnlLineFromGLEntry(
            GenJnlLine, GLEntry, JournalTemplateName, JournalBatchName, NextLineNo, FechaRetrocesion, DocNo, AmountTemporalFalse, false);
        GenJnlLine.Insert(true);

        InitGenJnlLineFromGLEntry(
            GenJnlLine, GLEntry, JournalTemplateName, JournalBatchName, NextLineNo + 10000, FechaRetrocesion, DocNo, AmountTemporalTrue, true);
        GenJnlLine.Insert(true);

        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        GenJnlLine.SetRange("Document No.", DocNo);
        if GenJnlLine.FindSet() then
            GenJnlPost.Run(GenJnlLine);

        GLEntry.Get(GLEntry."Entry No.");
        FinalizarRetrocesion(GLEntry, ImporteRetroceder, false);

        Message(ApuntesRegistradosMsg, DocNo);
    end;

    local procedure GetGenJnlTemplateAndBatch(var JournalTemplateName: Code[10]; var JournalBatchName: Code[10])
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        GenJnlTemplate.SetRange(Type, GenJnlTemplate.Type::General);
        GenJnlTemplate.SetRange(Recurring, false);
        if not GenJnlTemplate.FindFirst() then
            Error(NoGenJnlTemplateErr);

        GenJnlBatch.SetRange("Journal Template Name", GenJnlTemplate.Name);
        if not GenJnlBatch.FindFirst() then
            Error(NoGenJnlBatchErr, GenJnlTemplate.Name);

        JournalTemplateName := GenJnlTemplate.Name;
        JournalBatchName := GenJnlBatch.Name;
    end;

    local procedure InitGenJnlLineFromGLEntry(var GenJnlLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry"; JournalTemplateName: Code[10]; JournalBatchName: Code[10]; LineNo: Integer; PostingDate: Date; DocNo: Code[20]; Amount: Decimal; Temporal: Boolean)
    begin
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        GenJnlLine."Line No." := LineNo;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."Document Date" := PostingDate;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
        GenJnlLine.Description := GetDescripcionRetrocesion(GLEntry);
        GenJnlLine."Job No." := GLEntry."Job No.";
        GenJnlLine."Business Unit Code" := GLEntry."Business Unit Code";
        GenJnlLine."Gen. Posting Type" := GLEntry."Gen. Posting Type";
        GenJnlLine."Gen. Bus. Posting Group" := GLEntry."Gen. Bus. Posting Group";
        GenJnlLine."Gen. Prod. Posting Group" := GLEntry."Gen. Prod. Posting Group";
        GenJnlLine."VAT Bus. Posting Group" := GLEntry."VAT Bus. Posting Group";
        GenJnlLine."VAT Prod. Posting Group" := GLEntry."VAT Prod. Posting Group";
        GenJnlLine.Temporal := Temporal;
        GenJnlLine."Ret. Temporal" := true;
        GenJnlLine.Validate("Account No.", GLEntry."G/L Account No.");
        GenJnlLine.Validate(Amount, Amount);
        AsignarOrigenDesdeMovContabilidad(GenJnlLine, GLEntry);
        CopiarDimensionesDesdeMovContabilidad(GLEntry, GenJnlLine);
    end;

    local procedure GetNoDocumentoRetrocesion(GLEntry: Record "G/L Entry"): Code[20]
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        Sufijo: Code[10];
        DocNo: Code[20];
        GestSerie: Codeunit "No. Series";
    begin
        if GeneralLedgerSetup.Get() then
            Sufijo := GeneralLedgerSetup."Sufijo nº doc. retrocesión";
        if GeneralLedgerSetup."Sin sufijo nº doc. retrocesión" then
            Sufijo := '';
        If (Sufijo = '') and (not GeneralLedgerSetup."Sin sufijo nº doc. retrocesión") then
            Sufijo := '-R';
        if GeneralLedgerSetup."Documento Nuevo" then begin
            DocNo := GestSerie.GetNextNo(GeneralLedgerSetup."Seie Documento Nuevo", Today);
            exit(DocNo);
        end;
        exit(CopyStr(GLEntry."Document No." + Sufijo, 1, MaxStrLen(GLEntry."Document No.")));
    end;

    local procedure GetDescripcionRetrocesion(GLEntry: Record "G/L Entry"): Text[100]
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        Plantilla: Text;
    begin
        if GeneralLedgerSetup.Get() then
            Plantilla := GeneralLedgerSetup."Descr. retroces. temporalidad";
        if GeneralLedgerSetup."Sin descripción retrocesión" then
            exit(GLEntry.Description);
        if Plantilla = '' then
            Plantilla := 'Retrocesión temporalidad %Description';

        Plantilla := SustituirMarcador(Plantilla, '%Description', GLEntry.Description);
        Plantilla := SustituirMarcador(Plantilla, '%Document No.', GLEntry."Document No.");

        exit(CopyStr(Plantilla, 1, 100));
    end;

    local procedure SustituirMarcador(Texto: Text; Marcador: Text; Valor: Text): Text
    var
        Posicion: Integer;
        LongitudMarcador: Integer;
    begin
        if Marcador = '' then
            exit(Texto);

        LongitudMarcador := StrLen(Marcador);
        Posicion := StrPos(Texto, Marcador);
        while Posicion > 0 do begin
            Texto := CopyStr(Texto, 1, Posicion - 1) + Valor + CopyStr(Texto, Posicion + LongitudMarcador);
            Posicion := StrPos(Texto, Marcador);
        end;

        exit(Texto);
    end;

    local procedure AsignarOrigenDesdeMovContabilidad(var GenJnlLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry")
    begin
        if GLEntry."Source Type" = GLEntry."Source Type"::" " then
            exit;

        GenJnlLine.Validate("Source Type", GLEntry."Source Type");
        if GLEntry."Source No." <> '' then
            GenJnlLine.Validate("Source No.", GLEntry."Source No.");
    end;

    local procedure CopiarDimensionesDesdeMovContabilidad(GLEntry: Record "G/L Entry"; var GenJnlLine: Record "Gen. Journal Line")
    var
        FromDimSetEntry: Record "Dimension Set Entry";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        DimMgt: Codeunit DimensionManagement;
    begin
        if GLEntry."Dimension Set ID" = 0 then
            exit;

        FromDimSetEntry.SetRange("Dimension Set ID", GLEntry."Dimension Set ID");
        if FromDimSetEntry.FindSet() then
            repeat
                TempDimSetEntry := FromDimSetEntry;
                TempDimSetEntry."Dimension Set ID" := 0;
                TempDimSetEntry.Insert();
            until FromDimSetEntry.Next() = 0;

        GenJnlLine."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
    end;

    local procedure GetNextGenJnlLineNo(JournalTemplateName: Code[10]; JournalBatchName: Code[10]): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindLast() then
            exit(GenJnlLine."Line No." + 10000);

        exit(10000);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforeUpdateRecurringAmt', '', false, false)]
    local procedure OnBeforeUpdateRecurringAmt(var GenJnlLine2: Record "Gen. Journal Line"; var Updated: Boolean; var IsHandled: Boolean; var GLEntry: Record "G/L Entry"; var GLAccount: Record "G/L Account"; var GenJnlAllocation: Record "Gen. Jnl. Allocation")
    begin
        CopiarCamposTemporalidadDesdeDiario(GLEntry, GenJnlLine2);
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        CopiarCamposTemporalidadDesdeDiario(GLEntry, GenJournalLine);
    end;

    local procedure CopiarCamposTemporalidadDesdeDiario(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry.Temporal := GenJournalLine.Temporal;
        GLEntry."Ret. Temporal" := GenJournalLine."Ret. Temporal";
    end;

    var
        MarcaQuitadaMsg: Label 'Se ha quitado la marca de temporalidad del apunte.';
        MarcaPuestaMsg: Label 'Se ha marcado el apunte como temporal.';
        ImporteRetrocedidoActualizadoMsg: Label 'Se ha actualizado el importe retrocedido acumulado a %1.';
        ApuntesRegistradosMsg: Label 'Se han registrado los apuntes de retrocesión con el documento %1.';
        NoGenJnlTemplateErr: Label 'No se ha encontrado una sección de diario general para registrar la retrocesión.';
        NoGenJnlBatchErr: Label 'No se ha encontrado un nombre de diario para la sección %1.';
        ApunteRetTemporalErr: Label 'No se puede operar sobre apuntes generados por retrocesión de temporalidad.';
        ImporteTotalRetrocedidoErr: Label 'Ya se ha retrocedido el importe total del apunte.';
        ApunteYaTemporalErr: Label 'El apunte ya está marcado como temporal.';
}
