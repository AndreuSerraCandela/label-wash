codeunit 50102 EventosVarios
{
    trigger OnRun()
    begin

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforeUpdateRecurringAmt', '', false, false)]
    local procedure OnBeforeUpdateRecurringAmt(var GenJnlLine2: Record "Gen. Journal Line"; var Updated: Boolean; var IsHandled: Boolean; var GLEntry: Record "G/L Entry"; var GLAccount: Record "G/L Account"; var GenJnlAllocation: Record "Gen. Jnl. Allocation")
    begin
        GLEntry.Temporal := GenJnlLine2.Temporal;
    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterGLFinishPosting', '', false, false)]
    // procedure OnAfterGLFinishPosting(GLEntry: Record "G/L Entry"; var GenJnlLine: Record "Gen. Journal Line"; var IsTransactionConsistent: Boolean; FirstTransactionNo: Integer; var GLRegister: Record "G/L Register"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    // begin

    //     GLEntry.Temporal := GenJnlLine.Temporal;
    // end;


    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', false, false)]

    local procedure OnAfterCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry.Temporal := GenJournalLine.Temporal;
    end;

    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GLEntry: Record "G/L Entry";
}