tableextension 60130 SalesReceivablesSetupExt extends "Sales & Receivables Setup"
{
    fields
    {
        field(60100; "Reminder CC E-Mail"; Text[250])
        {
            Caption = 'Correo CC recordatorios';
            DataClassification = CustomerContent;
            ExtendedDatatype = EMail;
            ToolTip = 'Especifica la dirección de correo que recibirá una copia de todos los recordatorios enviados por correo electrónico.';
        }
    }
}
