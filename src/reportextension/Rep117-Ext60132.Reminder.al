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
}
