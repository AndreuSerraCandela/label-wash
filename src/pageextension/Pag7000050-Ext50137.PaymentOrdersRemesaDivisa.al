pageextension 60137 PaymentOrdersRemesaDivisa extends "Payment Orders"
{
    actions
    {
        addlast(processing)
        {
            group(RemesaDivisa)
            {
                Caption = 'Remesa divisa';
                Image = ExportFile;

                action(ExportRemesaDivisa1)
                {
                    ApplicationArea = All;
                    Caption = 'Remesa divisa formato 1';
                    Image = ExportToExcel;
                    ToolTip = 'Genera el Excel de remesa en divisa con columnas ALIAS, IMPORTE, CONCEPTO, IBAN, SWIFT, etc.';

                    trigger OnAction()
                    var
                        ExportarRemesaDivisa: Codeunit EventosVarios;
                    begin
                        ExportarRemesaDivisa.ExportarFormato1PaymentOrder(Rec);
                    end;
                }
                action(ExportRemesaDivisa2)
                {
                    ApplicationArea = All;
                    Caption = 'Remesa divisa formato 2';
                    Image = ExportToExcel;
                    ToolTip = 'Genera el Excel de remesa en divisa con datos de dirección del beneficiario.';

                    trigger OnAction()
                    var
                        ExportarRemesaDivisa: Codeunit EventosVarios;
                    begin
                        ExportarRemesaDivisa.ExportarFormato2PaymentOrder(Rec);
                    end;
                }
            }
        }
    }
}
