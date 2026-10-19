codeunit 60102 EventosVarios
{
    Permissions = tableData "G/L Entry" = RIMD,
     tabledata "Cust. Ledger Entry" = rm,
                  tabledata "Reminder/Fin. Charge Entry" = rimd;

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

    procedure BuildDiagnosis(var TempReminderDiagnosisLine: Record "Reminder Diagnosis Line" temporary; DocumentDate: Date; PostingDate: Date; OnlyOverdueEntries: Boolean; IncludeEntriesOnHold: Boolean)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        TempReminderDiagnosisLine.Reset();
        TempReminderDiagnosisLine.DeleteAll();

        CustLedgerEntry.SetCurrentKey("Customer No.", Open, Positive, "Due Date", "Currency Code");
        CustLedgerEntry.SetRange(Open, true);

        if CustLedgerEntry.FindSet() then
            repeat
                InsertDiagnosisLine(TempReminderDiagnosisLine, CustLedgerEntry, DocumentDate, PostingDate, OnlyOverdueEntries, IncludeEntriesOnHold);
            until CustLedgerEntry.Next() = 0;
    end;

    local procedure InsertDiagnosisLine(var TempReminderDiagnosisLine: Record "Reminder Diagnosis Line" temporary; var CustLedgerEntry: Record "Cust. Ledger Entry"; DocumentDate: Date; PostingDate: Date; OnlyOverdueEntries: Boolean; IncludeEntriesOnHold: Boolean)
    var
        Customer: Record Customer;
        ReminderTerms: Record "Reminder Terms";
        ReminderLevel: Record "Reminder Level";
        NextReminderLevel: Integer;
        ReminderDueDate: Date;
        GraceDueDate: Date;
        CandidateAmountLCY: Decimal;
    begin
        CustLedgerEntry.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");

        TempReminderDiagnosisLine.Init();
        TempReminderDiagnosisLine."Entry No." := CustLedgerEntry."Entry No.";
        TempReminderDiagnosisLine."Customer No." := CustLedgerEntry."Customer No.";
        TempReminderDiagnosisLine."Customer Name" := CustLedgerEntry."Customer Name";
        TempReminderDiagnosisLine."Document Type" := CustLedgerEntry."Document Type";
        TempReminderDiagnosisLine."Document No." := CustLedgerEntry."Document No.";
        TempReminderDiagnosisLine."Posting Date" := CustLedgerEntry."Posting Date";
        TempReminderDiagnosisLine."Document Date" := CustLedgerEntry."Document Date";
        TempReminderDiagnosisLine."Due Date" := CustLedgerEntry."Due Date";
        TempReminderDiagnosisLine."Currency Code" := CustLedgerEntry."Currency Code";
        TempReminderDiagnosisLine."Remaining Amount" := CustLedgerEntry."Remaining Amount";
        TempReminderDiagnosisLine."Remaining Amt. (LCY)" := CustLedgerEntry."Remaining Amt. (LCY)";
        TempReminderDiagnosisLine."On Hold" := CustLedgerEntry."On Hold";
        TempReminderDiagnosisLine.Positive := CustLedgerEntry.Positive;
        TempReminderDiagnosisLine."Last Issued Reminder Level" := CustLedgerEntry."Last Issued Reminder Level";

        if DocumentDate = 0D then begin
            SetResult(TempReminderDiagnosisLine, false, BlockedResultLbl, NoDocumentDateLbl, '');
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        if CustLedgerEntry."Remaining Amount" = 0 then begin
            SetResult(TempReminderDiagnosisLine, false, BlockedResultLbl, NoRemainingAmountLbl, '');
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        if not Customer.Get(CustLedgerEntry."Customer No.") then begin
            SetResult(TempReminderDiagnosisLine, false, BlockedResultLbl, CustomerNotFoundLbl, '');
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        TempReminderDiagnosisLine."Reminder Terms Code" := Customer."Reminder Terms Code";

        if Customer."Reminder Terms Code" = '' then begin
            SetResult(TempReminderDiagnosisLine, false, BlockedResultLbl, NoReminderTermsLbl, '');
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        if Customer.Blocked = Customer.Blocked::All then begin
            SetResult(TempReminderDiagnosisLine, false, BlockedResultLbl, CustomerBlockedLbl, '');
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        if not ReminderTerms.Get(Customer."Reminder Terms Code") then begin
            SetResult(TempReminderDiagnosisLine, false, BlockedResultLbl, ReminderTermsNotFoundLbl, Customer."Reminder Terms Code");
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        if not HasReminderLevels(ReminderTerms.Code) then begin
            SetResult(TempReminderDiagnosisLine, false, BlockedResultLbl, NoReminderLevelsLbl, ReminderTerms.Code);
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        if (CustLedgerEntry."On Hold" <> '') and not IncludeEntriesOnHold then begin
            SetResult(TempReminderDiagnosisLine, false, BlockedResultLbl, EntryOnHoldLbl, CustLedgerEntry."On Hold");
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        GetNextReminderData(CustLedgerEntry, NextReminderLevel, ReminderDueDate);
        TempReminderDiagnosisLine."Next Reminder Level" := NextReminderLevel;
        TempReminderDiagnosisLine."Reminder Due Date" := ReminderDueDate;

        if (ReminderTerms."Max. No. of Reminders" > 0) and (NextReminderLevel > ReminderTerms."Max. No. of Reminders") then begin
            SetResult(TempReminderDiagnosisLine, false, BlockedResultLbl, MaxReminderLevelLbl, Format(ReminderTerms."Max. No. of Reminders"));
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        if not ReminderLevel.Get(ReminderTerms.Code, NextReminderLevel) then begin
            SetResult(TempReminderDiagnosisLine, false, BlockedResultLbl, ReminderLevelNotFoundLbl, StrSubstNo(LevelDetailsLbl, ReminderTerms.Code, NextReminderLevel));
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        TempReminderDiagnosisLine."Grace Period" := ReminderLevel."Grace Period";
        GraceDueDate := CalcDate(ReminderLevel."Grace Period", ReminderDueDate);
        TempReminderDiagnosisLine."Grace Due Date" := GraceDueDate;

        if (GraceDueDate >= DocumentDate) and OnlyOverdueEntries and not IsPaymentOrRefund(CustLedgerEntry) then begin
            SetResult(
                TempReminderDiagnosisLine, false, BlockedResultLbl, GracePeriodNotExpiredLbl,
                StrSubstNo(GraceDetailsLbl, Format(GraceDueDate), Format(DocumentDate)));
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        CandidateAmountLCY :=
            CalculateCandidateAmountLCY(CustLedgerEntry."Customer No.", CustLedgerEntry."Currency Code", ReminderTerms, DocumentDate, PostingDate, OnlyOverdueEntries, IncludeEntriesOnHold);
        TempReminderDiagnosisLine."Candidate Amount (LCY)" := CandidateAmountLCY;
        TempReminderDiagnosisLine."Minimum Amount (LCY)" := ReminderTerms."Minimum Amount (LCY)";

        if CandidateAmountLCY < ReminderTerms."Minimum Amount (LCY)" then begin
            SetResult(
                TempReminderDiagnosisLine, false, BlockedResultLbl, MinimumAmountLbl,
                StrSubstNo(MinimumAmountDetailsLbl, Format(CandidateAmountLCY), Format(ReminderTerms."Minimum Amount (LCY)")));
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        TempReminderDiagnosisLine."Open Reminder No." := GetOpenReminderNo(CustLedgerEntry."Customer No.", CustLedgerEntry."Currency Code");
        if TempReminderDiagnosisLine."Open Reminder No." <> '' then begin
            SetResult(TempReminderDiagnosisLine, true, ConditionalResultLbl, OpenReminderLbl, TempReminderDiagnosisLine."Open Reminder No.");
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        if not CustLedgerEntry.Positive then begin
            SetResult(TempReminderDiagnosisLine, true, ConditionalResultLbl, NotPositiveLbl, '');
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        if GraceDueDate >= DocumentDate then begin
            SetResult(TempReminderDiagnosisLine, true, ConditionalResultLbl, NotDueButCanBeAddedLbl, '');
            TempReminderDiagnosisLine.Insert();
            exit;
        end;

        SetResult(TempReminderDiagnosisLine, true, CandidateResultLbl, IncludedCandidateLbl, '');
        TempReminderDiagnosisLine.Insert();
    end;

    local procedure GetNextReminderData(var CustLedgerEntry: Record "Cust. Ledger Entry"; var NextReminderLevel: Integer; var ReminderDueDate: Date)
    var
        ReminderEntry: Record "Reminder/Fin. Charge Entry";
    begin
        if CustLedgerEntry."Last Issued Reminder Level" > 0 then begin
            ReminderEntry.SetCurrentKey("Customer Entry No.", Type);
            ReminderEntry.SetRange("Customer Entry No.", CustLedgerEntry."Entry No.");
            ReminderEntry.SetRange(Type, ReminderEntry.Type::Reminder);
            ReminderEntry.SetRange("Reminder Level", CustLedgerEntry."Last Issued Reminder Level");
            ReminderEntry.SetRange(Canceled, false);
            if ReminderEntry.FindLast() then begin
                ReminderDueDate := ReminderEntry."Due Date";
                NextReminderLevel := ReminderEntry."Reminder Level" + 1;
                exit;
            end;
        end;

        ReminderDueDate := CustLedgerEntry."Due Date";
        NextReminderLevel := 1;
    end;

    local procedure CalculateCandidateAmountLCY(CustomerNo: Code[20]; CurrencyCode: Code[10]; ReminderTerms: Record "Reminder Terms"; DocumentDate: Date; PostingDate: Date; OnlyOverdueEntries: Boolean; IncludeEntriesOnHold: Boolean): Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ReminderLevel: Record "Reminder Level";
        NextReminderLevel: Integer;
        ReminderDueDate: Date;
        GraceDueDate: Date;
        CandidateAmount: Decimal;
    begin
        CustLedgerEntry.SetCurrentKey("Customer No.", Open, Positive, "Due Date", "Currency Code");
        CustLedgerEntry.SetRange("Customer No.", CustomerNo);
        CustLedgerEntry.SetRange(Open, true);
        CustLedgerEntry.SetRange("Currency Code", CurrencyCode);

        if CustLedgerEntry.FindSet() then
            repeat
                if ((CustLedgerEntry."On Hold" = '') or IncludeEntriesOnHold) then begin
                    GetNextReminderData(CustLedgerEntry, NextReminderLevel, ReminderDueDate);
                    if ((ReminderTerms."Max. No. of Reminders" = 0) or (NextReminderLevel <= ReminderTerms."Max. No. of Reminders")) and
                       ReminderLevel.Get(ReminderTerms.Code, NextReminderLevel)
                    then begin
                        GraceDueDate := CalcDate(ReminderLevel."Grace Period", ReminderDueDate);
                        if (GraceDueDate < DocumentDate) or (not OnlyOverdueEntries) or IsPaymentOrRefund(CustLedgerEntry) then begin
                            CustLedgerEntry.CalcFields("Remaining Amount");
                            CandidateAmount += CustLedgerEntry."Remaining Amount";
                        end;
                    end;
                end;
            until CustLedgerEntry.Next() = 0;

        exit(CustAmountLCY(CurrencyCode, CandidateAmount, PostingDate));
    end;

    local procedure CustAmountLCY(CurrencyCode: Code[10]; Amount: Decimal; PostingDate: Date): Decimal
    var
        CurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        if CurrencyCode <> '' then
            exit(
                CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                    PostingDate, CurrencyCode, Amount,
                    CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode)));

        exit(Amount);
    end;

    local procedure GetOpenReminderNo(CustomerNo: Code[20]; CurrencyCode: Code[10]): Code[20]
    var
        ReminderHeader: Record "Reminder Header";
    begin
        ReminderHeader.SetCurrentKey("Customer No.", "Currency Code");
        ReminderHeader.SetRange("Customer No.", CustomerNo);
        ReminderHeader.SetRange("Currency Code", CurrencyCode);
        if ReminderHeader.FindFirst() then
            exit(ReminderHeader."No.");
    end;

    local procedure HasReminderLevels(ReminderTermsCode: Code[10]): Boolean
    var
        ReminderLevel: Record "Reminder Level";
    begin
        ReminderLevel.SetRange("Reminder Terms Code", ReminderTermsCode);
        exit(not ReminderLevel.IsEmpty());
    end;

    local procedure IsPaymentOrRefund(var CustLedgerEntry: Record "Cust. Ledger Entry"): Boolean
    begin
        exit(CustLedgerEntry."Document Type" in [CustLedgerEntry."Document Type"::Payment, CustLedgerEntry."Document Type"::Refund]);
    end;

    local procedure SetResult(var ReminderDiagnosisLine: Record "Reminder Diagnosis Line"; IncludeCandidate: Boolean; DiagnosticResult: Text[30]; Reason: Text; Details: Text)
    begin
        ReminderDiagnosisLine."Include Candidate" := IncludeCandidate;
        ReminderDiagnosisLine."Diagnostic Result" := DiagnosticResult;
        ReminderDiagnosisLine.Reason := CopyStr(Reason, 1, MaxStrLen(ReminderDiagnosisLine.Reason));
        ReminderDiagnosisLine.Details := CopyStr(Details, 1, MaxStrLen(ReminderDiagnosisLine.Details));
    end;

    var
        BlockedResultLbl: Label 'No incluido';
        CandidateResultLbl: Label 'Incluible';
        ConditionalResultLbl: Label 'Condicionado';
        NoDocumentDateLbl: Label 'No hay fecha documento de diagnóstico.';
        NoRemainingAmountLbl: Label 'El movimiento no tiene importe pendiente.';
        CustomerNotFoundLbl: Label 'No se encuentra el cliente del movimiento.';
        NoReminderTermsLbl: Label 'El cliente no tiene código de términos de recordatorio.';
        CustomerBlockedLbl: Label 'El cliente está bloqueado para todo.';
        ReminderTermsNotFoundLbl: Label 'No se encuentra el código de términos de recordatorio.';
        NoReminderLevelsLbl: Label 'El código de términos de recordatorio no tiene niveles configurados.';
        EntryOnHoldLbl: Label 'El movimiento está en espera y no se ha marcado incluir movimientos en espera.';
        MaxReminderLevelLbl: Label 'El movimiento ya supera el número máximo de recordatorios.';
        ReminderLevelNotFoundLbl: Label 'No existe el nivel de recordatorio calculado.';
        GracePeriodNotExpiredLbl: Label 'No ha vencido el periodo de gracia para la fecha documento indicada.';
        MinimumAmountLbl: Label 'El total candidato no alcanza el importe mínimo de los términos.';
        OpenReminderLbl: Label 'Ya existe un recordatorio abierto para este cliente y divisa; Crear recordatorios no crea otro.';
        NotPositiveLbl: Label 'El movimiento no es positivo; solo se añade si otro movimiento positivo crea el recordatorio.';
        NotDueButCanBeAddedLbl: Label 'No está vencido, pero puede añadirse si no se limita a importes vencidos.';
        IncludedCandidateLbl: Label 'El movimiento cumple las condiciones principales para incluirse.';
        LevelDetailsLbl: Label 'Términos %1, nivel %2.';
        GraceDetailsLbl: Label 'Vencimiento con gracia %1; fecha documento %2.';
        MinimumAmountDetailsLbl: Label 'Total candidato DL %1; mínimo DL %2.';

    procedure CancelReminderEntries(var ReminderFinChargeEntry: Record "Reminder/Fin. Charge Entry"; var SkippedEntries: Integer): Integer
    var
        ReminderFinChargeEntryToCancel: Record "Reminder/Fin. Charge Entry";
        CanceledEntries: Integer;
    begin
        ReminderFinChargeEntryToCancel.Copy(ReminderFinChargeEntry);
        if ReminderFinChargeEntryToCancel.FindSet(true) then
            repeat
                if CanCancelReminderEntry(ReminderFinChargeEntryToCancel) then begin
                    ReminderFinChargeEntryToCancel.Canceled := true;
                    ReminderFinChargeEntryToCancel.Modify();
                    UpdateCustomerLedgerEntryLastReminderLevel(ReminderFinChargeEntryToCancel."Customer Entry No.");
                    CanceledEntries += 1;
                end else
                    SkippedEntries += 1;
            until ReminderFinChargeEntryToCancel.Next() = 0;

        exit(CanceledEntries);
    end;

    procedure DeleteReminderEntries(var ReminderFinChargeEntry: Record "Reminder/Fin. Charge Entry"; var SkippedEntries: Integer): Integer
    var
        ReminderFinChargeEntryToDelete: Record "Reminder/Fin. Charge Entry";
        CustomerEntryNo: Integer;
        DeletedEntries: Integer;
    begin
        ReminderFinChargeEntryToDelete.Copy(ReminderFinChargeEntry);
        if ReminderFinChargeEntryToDelete.FindSet(true) then
            repeat
                if ReminderFinChargeEntryToDelete.Type = ReminderFinChargeEntryToDelete.Type::Reminder then begin
                    CustomerEntryNo := ReminderFinChargeEntryToDelete."Customer Entry No.";
                    ReminderFinChargeEntryToDelete.Delete();
                    UpdateCustomerLedgerEntryLastReminderLevel(CustomerEntryNo);
                    DeletedEntries += 1;
                end else
                    SkippedEntries += 1;
            until ReminderFinChargeEntryToDelete.Next() = 0;

        exit(DeletedEntries);
    end;

    local procedure CanCancelReminderEntry(var ReminderFinChargeEntry: Record "Reminder/Fin. Charge Entry"): Boolean
    begin
        exit((ReminderFinChargeEntry.Type = ReminderFinChargeEntry.Type::Reminder) and not ReminderFinChargeEntry.Canceled);
    end;

    local procedure UpdateCustomerLedgerEntryLastReminderLevel(CustomerEntryNo: Integer)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        if CustomerEntryNo = 0 then
            exit;

        if not CustLedgerEntry.Get(CustomerEntryNo) then
            exit;

        CustLedgerEntry."Last Issued Reminder Level" := GetLastReminderLevel(CustomerEntryNo);
        CustLedgerEntry.Modify();
    end;

    local procedure GetLastReminderLevel(CustomerEntryNo: Integer): Integer
    var
        ReminderFinChargeEntry: Record "Reminder/Fin. Charge Entry";
    begin
        ReminderFinChargeEntry.SetCurrentKey("Customer Entry No.", "Reminder Level");
        ReminderFinChargeEntry.SetRange("Customer Entry No.", CustomerEntryNo);
        ReminderFinChargeEntry.SetRange(Type, ReminderFinChargeEntry.Type::Reminder);
        ReminderFinChargeEntry.SetRange(Canceled, false);
        if ReminderFinChargeEntry.FindLast() then
            exit(ReminderFinChargeEntry."Reminder Level");
        exit(0);
    end;


    procedure ExportarFormato1PaymentOrder(var PaymentOrder: Record "Payment Order")
    begin
        PaymentOrder.TestField("No.");
        ExportarFormato1(PaymentOrder."No.", PaymentOrder."Posting Date", PaymentOrder."No.", "Cartera Document Type"::Payable);
    end;

    procedure ExportarFormato2PaymentOrder(var PaymentOrder: Record "Payment Order")
    begin
        PaymentOrder.TestField("No.");
        ExportarFormato2(PaymentOrder."No.", PaymentOrder."Posting Date", PaymentOrder."No.", "Cartera Document Type"::Payable);
    end;

    local procedure ExportarFormato1(HeaderNo: Code[20]; PostingDate: Date; FileLabel: Code[20]; CarteraType: Enum "Cartera Document Type")
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        CarteraDoc: Record "Cartera Doc.";
        RowNo: Integer;
    begin
        RowNo := 1;
        AddTextCell(ExcelBuffer, RowNo, 1, 'ALIAS', true);
        AddTextCell(ExcelBuffer, RowNo, 2, 'IMPORTE', true);
        AddTextCell(ExcelBuffer, RowNo, 3, 'CONCEPTO', true);
        AddTextCell(ExcelBuffer, RowNo, 4, 'NOMBRE', true);
        AddTextCell(ExcelBuffer, RowNo, 5, 'BIC/SWIFT', true);
        AddTextCell(ExcelBuffer, RowNo, 6, 'TIPO TRANSFERENCIA', true);
        AddTextCell(ExcelBuffer, RowNo, 7, 'DIVISA', true);
        AddTextCell(ExcelBuffer, RowNo, 8, 'GASTOS', true);
        AddTextCell(ExcelBuffer, RowNo, 9, 'CUENTA DESTINO (IBAN)', true);

        if not FindCarteraDocuments(CarteraDoc, HeaderNo, CarteraType) then
            Error(SinDocumentosErr, HeaderNo);

        repeat
            RowNo += 1;
            AddLineFormato1(ExcelBuffer, CarteraDoc, RowNo);
        until CarteraDoc.Next() = 0;

        DownloadExcel(ExcelBuffer, StrSubstNo('Remesa Divisa_1 %1', FormatFileDate(PostingDate, FileLabel)));
    end;

    local procedure ExportarFormato2(HeaderNo: Code[20]; PostingDate: Date; FileLabel: Code[20]; CarteraType: Enum "Cartera Document Type")
    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        CarteraDoc: Record "Cartera Doc.";
        RowNo: Integer;
    begin
        RowNo := 1;
        AddTextCell(ExcelBuffer, RowNo, 1, 'ALIAS', true);
        AddTextCell(ExcelBuffer, RowNo, 2, 'NOMBRE BENEFICIARIO', true);
        AddTextCell(ExcelBuffer, RowNo, 3, 'IBAN', true);
        AddTextCell(ExcelBuffer, RowNo, 4, 'DIRECCIÓN BENEFICIARIO', true);
        AddTextCell(ExcelBuffer, RowNo, 5, 'PROVINCIA', true);
        AddTextCell(ExcelBuffer, RowNo, 6, 'CÓDIGO POSTAL', true);
        AddTextCell(ExcelBuffer, RowNo, 7, 'PAÍS BENEFICIARIO', true);
        AddTextCell(ExcelBuffer, RowNo, 8, 'IMPORTE', true);
        AddTextCell(ExcelBuffer, RowNo, 9, 'GASTOS', true);
        AddTextCell(ExcelBuffer, RowNo, 10, 'Tipo Transferencia', true);
        AddTextCell(ExcelBuffer, RowNo, 11, 'RESIDENTE', true);
        AddTextCell(ExcelBuffer, RowNo, 12, 'SWIFT', true);
        AddTextCell(ExcelBuffer, RowNo, 13, 'DIVISA', true);

        if not FindCarteraDocuments(CarteraDoc, HeaderNo, CarteraType) then
            Error(SinDocumentosErr, HeaderNo);

        repeat
            RowNo += 1;
            AddLineFormato2(ExcelBuffer, CarteraDoc, RowNo);
        until CarteraDoc.Next() = 0;

        DownloadExcel(ExcelBuffer, StrSubstNo('Remesa Divisa_2 %1', FormatFileDate(PostingDate, FileLabel)));
    end;

    local procedure FindCarteraDocuments(var CarteraDoc: Record "Cartera Doc."; HeaderNo: Code[20]; CarteraType: Enum "Cartera Document Type"): Boolean
    begin
        CarteraDoc.Reset();
        CarteraDoc.SetRange(Type, CarteraType);
        CarteraDoc.SetRange("Collection Agent", CarteraDoc."Collection Agent"::Bank);
        CarteraDoc.SetRange("Bill Gr./Pmt. Order No.", HeaderNo);
        exit(CarteraDoc.FindSet());
    end;

    local procedure AddLineFormato1(var ExcelBuffer: Record "Excel Buffer" temporary; CarteraDoc: Record "Cartera Doc."; RowNo: Integer)
    var
        PartnerLine: Record "Partner Remesa Divisa" temporary;
        Setup: Record "General Ledger Setup";
    begin
        LoadPartnerLine(CarteraDoc, PartnerLine);
        GetSetup(Setup);

        AddTextCell(ExcelBuffer, RowNo, 1, PartnerLine.Alias, false);
        AddNumberCell(ExcelBuffer, RowNo, 2, CarteraDoc."Remaining Amount");
        AddTextCell(ExcelBuffer, RowNo, 3, GetConcepto(CarteraDoc), false);
        AddTextCell(ExcelBuffer, RowNo, 4, PartnerLine.Name, false);
        AddTextCell(ExcelBuffer, RowNo, 5, PartnerLine."SWIFT Code", false);
        AddTextCell(ExcelBuffer, RowNo, 6, Setup."Tipo transfer. remesa divisa", false);
        AddTextCell(ExcelBuffer, RowNo, 7, GetCurrencyCode(CarteraDoc), false);
        AddIntegerCell(ExcelBuffer, RowNo, 8, Setup."Gastos remesa divisa");
        AddTextCell(ExcelBuffer, RowNo, 9, PartnerLine.IBAN, false);
    end;

    local procedure AddLineFormato2(var ExcelBuffer: Record "Excel Buffer" temporary; CarteraDoc: Record "Cartera Doc."; RowNo: Integer)
    var
        PartnerLine: Record "Partner Remesa Divisa" temporary;
        Setup: Record "General Ledger Setup";
    begin
        LoadPartnerLine(CarteraDoc, PartnerLine);
        GetSetup(Setup);

        AddTextCell(ExcelBuffer, RowNo, 1, PartnerLine.Alias, false);
        AddTextCell(ExcelBuffer, RowNo, 2, PartnerLine.Name, false);
        AddTextCell(ExcelBuffer, RowNo, 3, PartnerLine.IBAN, false);
        AddTextCell(ExcelBuffer, RowNo, 4, PartnerLine.Address, false);
        AddTextCell(ExcelBuffer, RowNo, 5, PartnerLine.County, false);
        AddTextCell(ExcelBuffer, RowNo, 6, PartnerLine."Post Code", false);
        AddTextCell(ExcelBuffer, RowNo, 7, PartnerLine."Country/Region Code", false);
        AddNumberCell(ExcelBuffer, RowNo, 8, CarteraDoc."Remaining Amount");
        AddIntegerCell(ExcelBuffer, RowNo, 9, Setup."Gastos remesa divisa");
        AddTextCell(ExcelBuffer, RowNo, 10, Setup."Tipo transfer. remesa divisa", false);
        AddTextCell(ExcelBuffer, RowNo, 11, Setup."Residente remesa divisa", false);
        AddTextCell(ExcelBuffer, RowNo, 12, PartnerLine."SWIFT Code", false);
        AddTextCell(ExcelBuffer, RowNo, 13, GetCurrencyCode(CarteraDoc), false);
    end;

    local procedure LoadPartnerLine(CarteraDoc: Record "Cartera Doc."; var PartnerLine: Record "Partner Remesa Divisa" temporary)
    var
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";

    begin
        PartnerLine.Init();
        PartnerLine."Entry No." := CarteraDoc."Entry No.";

        Vendor.Get(CarteraDoc."Account No.");
        PartnerLine.Alias := GetVendorAlias(Vendor);
        PartnerLine.Name := Vendor.Name;
        PartnerLine.Address := BuildAddress(Vendor.Address, Vendor."Address 2", Vendor.City);
        PartnerLine.County := Vendor.County;
        PartnerLine."Post Code" := Vendor."Post Code";
        PartnerLine."Country/Region Code" := Vendor."Country/Region Code";
        GetVendorBankAccount(CarteraDoc, VendorBankAccount);
        PartnerLine.IBAN := GetBankAccountNo(VendorBankAccount.IBAN, VendorBankAccount."Bank Account No.");
        PartnerLine."SWIFT Code" := VendorBankAccount."SWIFT Code";

        PartnerLine.Insert();
    end;

    local procedure GetVendorAlias(Vendor: Record Vendor): Code[20]
    begin
        if Vendor."Alias remesa divisa" <> '' then
            exit(Vendor."Alias remesa divisa");

        if Vendor."Search Name" <> '' then
            exit(CopyStr(Vendor."Search Name", 1, MaxStrLen(Vendor."Alias remesa divisa")));

        exit(CopyStr(Vendor.Name, 1, MaxStrLen(Vendor."Alias remesa divisa")));
    end;


    local procedure GetVendorBankAccount(CarteraDoc: Record "Cartera Doc."; var VendorBankAccount: Record "Vendor Bank Account")
    begin
        VendorBankAccount.SetRange("Vendor No.", CarteraDoc."Account No.");
        if CarteraDoc."Cust./Vendor Bank Acc. Code" <> '' then
            VendorBankAccount.SetRange(Code, CarteraDoc."Cust./Vendor Bank Acc. Code")
        else
            VendorBankAccount.SetRange("Use For Electronic Payments", true);

        if not VendorBankAccount.FindFirst() then begin
            VendorBankAccount.SetRange("Use For Electronic Payments");
            if not VendorBankAccount.FindFirst() then
                Error(SinCuentaBancariaErr, CarteraDoc."Account No.");
        end;
    end;



    local procedure GetBankAccountNo(IBAN: Code[50]; BankAccountNo: Text[30]): Text[50]
    begin
        if IBAN <> '' then
            exit(DelChr(IBAN, '=', ' '));

        exit(BankAccountNo);
    end;

    local procedure BuildAddress(Address: Text[100]; Address2: Text[50]; City: Text[30]): Text[250]
    var
        Result: Text;
    begin
        Result := DelChr(Address, '<>', ' ');
        if Address2 <> '' then
            if Result <> '' then
                Result += ', ' + Address2
            else
                Result := Address2;
        if City <> '' then
            if Result <> '' then
                Result += ', ' + City
            else
                Result := City;

        exit(CopyStr(Result, 1, 250));
    end;

    local procedure GetConcepto(CarteraDoc: Record "Cartera Doc."): Text[250]
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";

    begin
        if VendorLedgerEntry.Get(CarteraDoc."Entry No.") then
            if VendorLedgerEntry."External Document No." <> '' then
                exit(VendorLedgerEntry."External Document No.");

        exit(CarteraDoc."Document No.");
    end;

    local procedure GetCurrencyCode(CarteraDoc: Record "Cartera Doc."): Code[10]
    begin
        if CarteraDoc."Currency Code" <> '' then
            exit(CarteraDoc."Currency Code");

        exit('');
    end;

    local procedure GetSetup(var GeneralLedgerSetup: Record "General Ledger Setup")
    begin
        if not GeneralLedgerSetup.Get() then
            GeneralLedgerSetup.Init();

        if GeneralLedgerSetup."Tipo transfer. remesa divisa" = '' then
            GeneralLedgerSetup."Tipo transfer. remesa divisa" := 'OTRA';
        if GeneralLedgerSetup."Residente remesa divisa" = '' then
            GeneralLedgerSetup."Residente remesa divisa" := 'N';
        if GeneralLedgerSetup."Gastos remesa divisa" = 0 then
            GeneralLedgerSetup."Gastos remesa divisa" := 3;
    end;

    local procedure AddTextCell(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColNo: Integer; Value: Text; Bold: Boolean)
    begin
        ExcelBuffer.Init();
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColNo);
        ExcelBuffer."Cell Value as Text" := CopyStr(Value, 1, MaxStrLen(ExcelBuffer."Cell Value as Text"));
        ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Text;
        ExcelBuffer.Bold := Bold;
        ExcelBuffer.Insert();
    end;

    local procedure AddNumberCell(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColNo: Integer; Value: Decimal)
    begin
        ExcelBuffer.Init();
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColNo);
        ExcelBuffer."Cell Value as Text" := Format(Value, 0, '<Precision,2:8><Standard Format,0>');
        ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Number;
        ExcelBuffer.Insert();
    end;

    local procedure AddIntegerCell(var ExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer; ColNo: Integer; Value: Integer)
    begin
        ExcelBuffer.Init();
        ExcelBuffer.Validate("Row No.", RowNo);
        ExcelBuffer.Validate("Column No.", ColNo);
        ExcelBuffer."Cell Value as Text" := Format(Value);
        ExcelBuffer."Cell Type" := ExcelBuffer."Cell Type"::Number;
        ExcelBuffer.Insert();
    end;

    local procedure DownloadExcel(var ExcelBuffer: Record "Excel Buffer" temporary; FriendlyName: Text)
    begin
        ExcelBuffer.CreateNewBook('Remesa Divisa');
        ExcelBuffer.WriteSheet('Remesa Divisa', CompanyName, UserId);
        ExcelBuffer.CloseBook();
        ExcelBuffer.SetFriendlyFilename(FriendlyName);
        ExcelBuffer.OpenExcel();
    end;

    local procedure FormatFileDate(PostingDate: Date; HeaderNo: Code[20]): Text
    begin
        if PostingDate <> 0D then
            exit(Format(PostingDate, 0, '<Day,2>.<Month,2>.<Year4>'));

        exit(HeaderNo);
    end;

    procedure GetCustomerPeriodBalanceLCY(
        CustomerNo: Code[20];
        DimensionCode: Code[20];
        DimensionValueCode: Code[20];
        DateFilter: Text;
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
        CurrencyFilter: Text): Decimal
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        if (CustomerNo = '') or (DimensionCode = '') or (DimensionValueCode = '') then
            exit(0);

        SetCustomerPeriodBalanceFilters(
            DetailedCustLedgEntry, CustomerNo, DimensionCode, DimensionValueCode,
            DateFilter, GlobalDim1Filter, GlobalDim2Filter, CurrencyFilter);
        DetailedCustLedgEntry.CalcSums("Amount (LCY)");
        exit(DetailedCustLedgEntry."Amount (LCY)");
    end;

    procedure GetCustomerPeriodBalanceTotalLCY(
        CustomerNo: Code[20];
        DateFilter: Text;
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
        CurrencyFilter: Text): Decimal
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        if CustomerNo = '' then
            exit(0);

        SetCustomerPeriodBalanceFilters(
            DetailedCustLedgEntry, CustomerNo, '', '',
            DateFilter, GlobalDim1Filter, GlobalDim2Filter, CurrencyFilter);
        DetailedCustLedgEntry.CalcSums("Amount (LCY)");
        exit(DetailedCustLedgEntry."Amount (LCY)");
    end;

    procedure DrillDownCustomerPeriodBalance(
        CustomerNo: Code[20];
        DimensionCode: Code[20];
        DimensionValueCode: Code[20];
        DateFilter: Text;
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
        CurrencyFilter: Text)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        if CustomerNo = '' then
            exit;

        SetCustomerLedgerEntryFilters(
            CustLedgEntry, CustomerNo, DimensionCode, DimensionValueCode,
            DateFilter, GlobalDim1Filter, GlobalDim2Filter, CurrencyFilter);
        PAGE.Run(PAGE::"Customer Ledger Entries", CustLedgEntry);
    end;

    local procedure SetCustomerLedgerEntryFilters(
        var CustLedgEntry: Record "Cust. Ledger Entry";
        CustomerNo: Code[20];
        DimensionCode: Code[20];
        DimensionValueCode: Code[20];
        DateFilter: Text;
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
        CurrencyFilter: Text)
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        CustLedgEntry.Reset();
        CustLedgEntry.SetRange("Customer No.", CustomerNo);
        ApplyCustomerMatrixTotalsFiltersToCLE(CustLedgEntry, DateFilter, GlobalDim1Filter, GlobalDim2Filter, CurrencyFilter);

        if (DimensionCode = '') or (DimensionValueCode = '') then
            exit;

        GeneralLedgerSetup.Get();
        if IsCustomerMatrixGlobalDimension(DimensionCode, 1, GeneralLedgerSetup) then begin
            CustLedgEntry.SetRange("Global Dimension 1 Code", DimensionValueCode);
            exit;
        end;

        if IsCustomerMatrixGlobalDimension(DimensionCode, 2, GeneralLedgerSetup) then begin
            CustLedgEntry.SetRange("Global Dimension 2 Code", DimensionValueCode);
            exit;
        end;

        SetCustomerMatrixColumnDimFilter(CustLedgEntry, DimensionCode, DimensionValueCode, GeneralLedgerSetup);
    end;

    local procedure SetCustomerPeriodBalanceFilters(
        var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustomerNo: Code[20];
        DimensionCode: Code[20];
        DimensionValueCode: Code[20];
        DateFilter: Text;
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
        CurrencyFilter: Text)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        GeneralLedgerSetup: Record "General Ledger Setup";
        EntryNoFilter: Text;
    begin
        DetailedCustLedgEntry.Reset();
        DetailedCustLedgEntry.SetRange("Customer No.", CustomerNo);
        ApplyCustomerMatrixTotalsFilters(DetailedCustLedgEntry, DateFilter, GlobalDim1Filter, GlobalDim2Filter, CurrencyFilter);

        if (DimensionCode = '') or (DimensionValueCode = '') then
            exit;

        GeneralLedgerSetup.Get();
        if IsCustomerMatrixGlobalDimension(DimensionCode, 1, GeneralLedgerSetup) then begin
            DetailedCustLedgEntry.SetRange("Initial Entry Global Dim. 1", DimensionValueCode);
            exit;
        end;

        if IsCustomerMatrixGlobalDimension(DimensionCode, 2, GeneralLedgerSetup) then begin
            DetailedCustLedgEntry.SetRange("Initial Entry Global Dim. 2", DimensionValueCode);
            exit;
        end;

        CustLedgEntry.Reset();
        CustLedgEntry.SetRange("Customer No.", CustomerNo);
        SetCustomerMatrixColumnDimFilter(CustLedgEntry, DimensionCode, DimensionValueCode, GeneralLedgerSetup);
        if CustLedgEntry.FindSet() then
            repeat
                EntryNoFilter := AppendIntegerToFilter(EntryNoFilter, CustLedgEntry."Entry No.");
            until CustLedgEntry.Next() = 0
        else
            EntryNoFilter := '0';

        DetailedCustLedgEntry.SetFilter("Cust. Ledger Entry No.", EntryNoFilter);
    end;

    local procedure ApplyCustomerMatrixTotalsFilters(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; DateFilter: Text; GlobalDim1Filter: Text; GlobalDim2Filter: Text; CurrencyFilter: Text)
    begin
        if DateFilter <> '' then
            DetailedCustLedgEntry.SetFilter("Posting Date", DateFilter);
        if GlobalDim1Filter <> '' then
            DetailedCustLedgEntry.SetFilter("Initial Entry Global Dim. 1", GlobalDim1Filter);
        if GlobalDim2Filter <> '' then
            DetailedCustLedgEntry.SetFilter("Initial Entry Global Dim. 2", GlobalDim2Filter);
        if CurrencyFilter <> '' then
            DetailedCustLedgEntry.SetFilter("Currency Code", CurrencyFilter);
    end;

    local procedure ApplyCustomerMatrixTotalsFiltersToCLE(var CustLedgEntry: Record "Cust. Ledger Entry"; DateFilter: Text; GlobalDim1Filter: Text; GlobalDim2Filter: Text; CurrencyFilter: Text)
    begin
        if DateFilter <> '' then
            CustLedgEntry.SetFilter("Posting Date", DateFilter);
        if GlobalDim1Filter <> '' then
            CustLedgEntry.SetFilter("Global Dimension 1 Code", GlobalDim1Filter);
        if GlobalDim2Filter <> '' then
            CustLedgEntry.SetFilter("Global Dimension 2 Code", GlobalDim2Filter);
        if CurrencyFilter <> '' then
            CustLedgEntry.SetFilter("Currency Code", CurrencyFilter);
    end;

    local procedure SetCustomerMatrixColumnDimFilter(var CustLedgEntry: Record "Cust. Ledger Entry"; DimensionCode: Code[20]; DimensionValueCode: Code[20]; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        DimensionSetIdFilter: Text;
    begin
        case DimensionCode of
            GeneralLedgerSetup."Shortcut Dimension 3 Code":
                CustLedgEntry.SetRange("Shortcut Dimension 3 Code", DimensionValueCode);
            GeneralLedgerSetup."Shortcut Dimension 4 Code":
                CustLedgEntry.SetRange("Shortcut Dimension 4 Code", DimensionValueCode);
            GeneralLedgerSetup."Shortcut Dimension 5 Code":
                CustLedgEntry.SetRange("Shortcut Dimension 5 Code", DimensionValueCode);
            GeneralLedgerSetup."Shortcut Dimension 6 Code":
                CustLedgEntry.SetRange("Shortcut Dimension 6 Code", DimensionValueCode);
            GeneralLedgerSetup."Shortcut Dimension 7 Code":
                CustLedgEntry.SetRange("Shortcut Dimension 7 Code", DimensionValueCode);
            GeneralLedgerSetup."Shortcut Dimension 8 Code":
                CustLedgEntry.SetRange("Shortcut Dimension 8 Code", DimensionValueCode);
            else begin
                DimensionSetEntry.Reset();
                DimensionSetEntry.SetRange("Dimension Code", DimensionCode);
                DimensionSetEntry.SetRange("Dimension Value Code", DimensionValueCode);
                if DimensionSetEntry.FindSet() then
                    repeat
                        DimensionSetIdFilter := AppendIntegerToFilter(DimensionSetIdFilter, DimensionSetEntry."Dimension Set ID");
                    until DimensionSetEntry.Next() = 0
                else
                    DimensionSetIdFilter := '0';

                CustLedgEntry.SetFilter("Dimension Set ID", DimensionSetIdFilter);
            end;
        end;
    end;

    local procedure IsCustomerMatrixGlobalDimension(DimensionCode: Code[20]; GlobalDimensionNo: Integer; GeneralLedgerSetup: Record "General Ledger Setup"): Boolean
    begin
        case GlobalDimensionNo of
            1:
                exit(DimensionCode = GeneralLedgerSetup."Global Dimension 1 Code");
            2:
                exit(DimensionCode = GeneralLedgerSetup."Global Dimension 2 Code");
        end;
    end;

    local procedure AppendIntegerToFilter(CurrentFilter: Text; Value: Integer): Text
    begin
        if CurrentFilter = '' then
            exit(Format(Value));

        exit(CurrentFilter + '|' + Format(Value));
    end;

    procedure GetCustomerGLPeriodBalanceLCY(
        CustomerNo: Code[20];
        GLAccountFilter: Text;
        DimensionCode: Code[20];
        DimensionValueCode: Code[20];
        DateFilter: Text;
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
        CurrencyFilter: Text): Decimal
    var
        GLEntry: Record "G/L Entry";
    begin
        if (CustomerNo = '') or (DimensionCode = '') or (DimensionValueCode = '') then
            exit(0);

        SetGLEntryCustomerMatrixFilters(
            GLEntry, CustomerNo, GLAccountFilter, DimensionCode, DimensionValueCode,
            DateFilter, GlobalDim1Filter, GlobalDim2Filter, CurrencyFilter);
        GLEntry.CalcSums(Amount);
        exit(GLEntry.Amount);
    end;

    procedure GetCustomerGLPeriodBalanceTotalLCY(
        CustomerNo: Code[20];
        GLAccountFilter: Text;
        DateFilter: Text;
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
        CurrencyFilter: Text): Decimal
    var
        GLEntry: Record "G/L Entry";
    begin
        if CustomerNo = '' then
            exit(0);

        SetGLEntryCustomerMatrixFilters(
            GLEntry, CustomerNo, GLAccountFilter, '', '',
            DateFilter, GlobalDim1Filter, GlobalDim2Filter, CurrencyFilter);
        GLEntry.CalcSums(Amount);
        exit(GLEntry.Amount);
    end;

    procedure DrillDownCustomerGLPeriodBalance(
        CustomerNo: Code[20];
        GLAccountFilter: Text;
        DimensionCode: Code[20];
        DimensionValueCode: Code[20];
        DateFilter: Text;
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
        CurrencyFilter: Text)
    var
        GLEntry: Record "G/L Entry";
    begin
        if CustomerNo = '' then
            exit;

        SetGLEntryCustomerMatrixFilters(
            GLEntry, CustomerNo, GLAccountFilter, DimensionCode, DimensionValueCode,
            DateFilter, GlobalDim1Filter, GlobalDim2Filter, CurrencyFilter);
        PAGE.Run(PAGE::"General Ledger Entries", GLEntry);
    end;

    local procedure SetGLEntryCustomerMatrixFilters(
        var GLEntry: Record "G/L Entry";
        CustomerNo: Code[20];
        GLAccountFilter: Text;
        DimensionCode: Code[20];
        DimensionValueCode: Code[20];
        DateFilter: Text;
        GlobalDim1Filter: Text;
        GlobalDim2Filter: Text;
        CurrencyFilter: Text)
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GLEntry.Reset();
        GLEntry.SetRange("Source Type", GLEntry."Source Type"::Customer);
        GLEntry.SetRange("Source No.", CustomerNo);
        if GLAccountFilter <> '' then
            GLEntry.SetFilter("G/L Account No.", GLAccountFilter);
        ApplyCustomerMatrixTotalsFiltersToGLEntry(GLEntry, DateFilter, GlobalDim1Filter, GlobalDim2Filter, CurrencyFilter);

        if (DimensionCode = '') or (DimensionValueCode = '') then
            exit;

        GeneralLedgerSetup.Get();
        if IsCustomerMatrixGlobalDimension(DimensionCode, 1, GeneralLedgerSetup) then begin
            GLEntry.SetRange("Global Dimension 1 Code", DimensionValueCode);
            exit;
        end;

        if IsCustomerMatrixGlobalDimension(DimensionCode, 2, GeneralLedgerSetup) then begin
            GLEntry.SetRange("Global Dimension 2 Code", DimensionValueCode);
            exit;
        end;

        SetGLMatrixColumnDimFilter(GLEntry, DimensionCode, DimensionValueCode, GeneralLedgerSetup);
    end;

    local procedure ApplyCustomerMatrixTotalsFiltersToGLEntry(var GLEntry: Record "G/L Entry"; DateFilter: Text; GlobalDim1Filter: Text; GlobalDim2Filter: Text; CurrencyFilter: Text)
    begin
        if DateFilter <> '' then
            GLEntry.SetFilter("Posting Date", DateFilter);
        if GlobalDim1Filter <> '' then
            GLEntry.SetFilter("Global Dimension 1 Code", GlobalDim1Filter);
        if GlobalDim2Filter <> '' then
            GLEntry.SetFilter("Global Dimension 2 Code", GlobalDim2Filter);
        if CurrencyFilter <> '' then
            GLEntry.SetFilter("Source Currency Code", CurrencyFilter);
    end;

    local procedure SetGLMatrixColumnDimFilter(var GLEntry: Record "G/L Entry"; DimensionCode: Code[20]; DimensionValueCode: Code[20]; GeneralLedgerSetup: Record "General Ledger Setup")
    var
        DimensionSetEntry: Record "Dimension Set Entry";
        DimensionSetIdFilter: Text;
    begin
        case DimensionCode of
            GeneralLedgerSetup."Shortcut Dimension 3 Code":
                GLEntry.SetRange("Shortcut Dimension 3 Code", DimensionValueCode);
            GeneralLedgerSetup."Shortcut Dimension 4 Code":
                GLEntry.SetRange("Shortcut Dimension 4 Code", DimensionValueCode);
            GeneralLedgerSetup."Shortcut Dimension 5 Code":
                GLEntry.SetRange("Shortcut Dimension 5 Code", DimensionValueCode);
            GeneralLedgerSetup."Shortcut Dimension 6 Code":
                GLEntry.SetRange("Shortcut Dimension 6 Code", DimensionValueCode);
            GeneralLedgerSetup."Shortcut Dimension 7 Code":
                GLEntry.SetRange("Shortcut Dimension 7 Code", DimensionValueCode);
            GeneralLedgerSetup."Shortcut Dimension 8 Code":
                GLEntry.SetRange("Shortcut Dimension 8 Code", DimensionValueCode);
            else begin
                DimensionSetEntry.Reset();
                DimensionSetEntry.SetRange("Dimension Code", DimensionCode);
                DimensionSetEntry.SetRange("Dimension Value Code", DimensionValueCode);
                if DimensionSetEntry.FindSet() then
                    repeat
                        DimensionSetIdFilter := AppendIntegerToFilter(DimensionSetIdFilter, DimensionSetEntry."Dimension Set ID");
                    until DimensionSetEntry.Next() = 0
                else
                    DimensionSetIdFilter := '0';

                GLEntry.SetFilter("Dimension Set ID", DimensionSetIdFilter);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reminder-Make", 'OnAfterSet', '', false, false)]
    local procedure ReminderMakeOnAfterSet(var Cust: Record Customer; var CustLedgEntry: Record "Cust. Ledger Entry"; var ReminderHeaderReq: Record "Reminder Header"; var OverdueEntriesOnly: Boolean; var IncludeEntriesOnHold: Boolean; var CustLedgEntryLinefeeOn: Record "Cust. Ledger Entry")
    begin
        OverdueEntriesOnly := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reminder-Make", 'OnMakeReminderOnBeforeCustLedgEntryFindSet', '', false, false)]
    local procedure ReminderMakeOnBeforeCustLedgEntryFindSet(var CustLedgEntry: Record "Cust. Ledger Entry"; Cust: Record Customer; ReminderHeader: Record "Reminder Header"; MaxReminderLevel: Integer; var OverdueEntriesOnly: Boolean)
    begin
        OverdueEntriesOnly := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnBeforeGetEmailSubject', '', false, false)]
    local procedure DocumentMailingOnBeforeGetEmailSubject(PostedDocNo: Code[20]; EmailDocumentName: Text[250]; ReportUsage: Integer; var EmailSubject: Text[250]; var IsHandled: Boolean)
    var
        IssuedReminderHeader: Record "Issued Reminder Header";
    begin
        if ReportUsage <> "Report Selection Usage"::Reminder.AsInteger() then
            exit;
        if not IssuedReminderHeader.Get(PostedDocNo) then
            exit;

        EmailSubject := CopyStr(IssuedReminderHeader."Customer No." + ' - Statement of account', 1, MaxStrLen(EmailSubject));
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnBeforeSendEmail', '', false, false)]
    local procedure DocumentMailingOnBeforeSendEmail(var TempEmailItem: Record "Email Item" temporary; var IsFromPostedDoc: Boolean; var PostedDocNo: Code[20]; var HideDialog: Boolean; var ReportUsage: Integer; var EmailSentSuccesfully: Boolean; var IsHandled: Boolean; EmailDocName: Text[250]; SenderUserID: Code[50]; EmailScenario: Enum "Email Scenario")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        if ReportUsage <> "Report Selection Usage"::Reminder.AsInteger() then
            exit;

        SalesReceivablesSetup.Get();
        if SalesReceivablesSetup."Reminder CC E-Mail" <> '' then
            TempEmailItem."Send CC" :=
                CopyStr(
                    AppendEmailAddress(TempEmailItem."Send CC", SalesReceivablesSetup."Reminder CC E-Mail"),
                    1,
                    MaxStrLen(TempEmailItem."Send CC"));

        TempEmailItem.SetBodyText('');
    end;

    local procedure AppendEmailAddress(CurrentAddresses: Text; NewAddress: Text): Text
    begin
        if CurrentAddresses = '' then
            exit(NewAddress);
        exit(CurrentAddresses + ';' + NewAddress);
    end;

    var
        SinDocumentosErr: Label 'No hay documentos de cartera asociados al número %1.';
        SinCuentaBancariaErr: Label 'No se ha encontrado cuenta bancaria para la cuenta %1.';
}
