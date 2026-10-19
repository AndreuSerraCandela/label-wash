pageextension 60131 SalesReceivablesSetupExt extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(General)
        {
            field("Reminder CC E-Mail"; Rec."Reminder CC E-Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Especifica la dirección de correo que recibirá una copia de todos los recordatorios enviados por correo electrónico.';
            }
        }
    }
}
