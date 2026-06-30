/// <summary>
/// TableExtension ReminderLevel (ID 90141) extends Record Reminder Level.
/// </summary>
tableextension 50141 ReminderLevel extends "Reminder Level"
{
    fields
    {
        field(90000; "PDF Adjunto"; Blob)
        {
            Caption = 'PDF adjunto';
            DataClassification = CustomerContent;
        }
    }
}
