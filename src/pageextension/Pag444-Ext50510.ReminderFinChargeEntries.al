/// <summary>
/// PageExtension RemFinChargeEntriesServ (ID 50510) extends Page Reminder/Fin. Charge Entries.
/// </summary>
pageextension 60148 RemFinChargeEntriesServ extends "Reminder/Fin. Charge Entries"
{
    actions
    {
        addlast(processing)
        {
            action("Cancelar mov. recordatorio")
            {
                ApplicationArea = All;
                Caption = 'Cancelar mov. recordatorio';
                Image = Cancel;
                ToolTip = 'Marca como cancelados los movimientos de recordatorio seleccionados y recalcula el último nivel emitido del movimiento de cliente.';

                trigger OnAction()
                var
                    SelectedReminderEntry: Record "Reminder/Fin. Charge Entry";
                    ReminderEntryMgt: Codeunit EventosVarios;
                    CanceledEntries: Integer;
                    SkippedEntries: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedReminderEntry);
                    if SelectedReminderEntry.IsEmpty() then
                        exit;

                    if not Confirm(CancelReminderEntriesQst, false, SelectedReminderEntry.Count()) then
                        exit;

                    CanceledEntries := ReminderEntryMgt.CancelReminderEntries(SelectedReminderEntry, SkippedEntries);
                    Message(ProcessResultMsg, CanceledEntries, SkippedEntries);
                    CurrPage.Update(false);
                end;
            }

            action("Eliminar mov. recordatorio")
            {
                ApplicationArea = All;
                Caption = 'Eliminar mov. recordatorio';
                Image = Delete;
                ToolTip = 'Elimina los movimientos de recordatorio seleccionados y recalcula el último nivel emitido del movimiento de cliente.';

                trigger OnAction()
                var
                    SelectedReminderEntry: Record "Reminder/Fin. Charge Entry";
                    ReminderEntryMgt: Codeunit EventosVarios;
                    DeletedEntries: Integer;
                    SkippedEntries: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedReminderEntry);
                    if SelectedReminderEntry.IsEmpty() then
                        exit;

                    if not Confirm(DeleteReminderEntriesQst, false, SelectedReminderEntry.Count()) then
                        exit;

                    DeletedEntries := ReminderEntryMgt.DeleteReminderEntries(SelectedReminderEntry, SkippedEntries);
                    Message(ProcessResultMsg, DeletedEntries, SkippedEntries);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        CancelReminderEntriesQst: Label '¿Quieres cancelar %1 movimiento(s) de recordatorio seleccionado(s)? Se recalculará el último nivel emitido en los movimientos de cliente.';
        DeleteReminderEntriesQst: Label '¿Quieres eliminar %1 movimiento(s) de recordatorio seleccionado(s)? Esta acción borra los movimientos seleccionados y recalcula el último nivel emitido en los movimientos de cliente.';
        ProcessResultMsg: Label 'Procesados: %1. Omitidos: %2.';
}
