reportextension 60132 ReminderAviactionExt extends Reminder
{
    dataset
    {
        add("Issued Reminder Line")
        {
            column(AviactionOverdue; ("Due Date" <> 0D) and ("Due Date" < "Issued Reminder Header"."Document Date"))
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        // El diseño estándar omite el bloque "Movimientos pendientes no vencidos"
        // salvo que la opción de la request page esté marcada. El recordatorio ya
        // contiene esas líneas; aquí se fuerzan siempre en la impresión y en el correo.
        ShowNotDueAmounts := true;
    end;
}
