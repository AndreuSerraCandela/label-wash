tableextension 60118 SalesInvoiceHeader extends "Sales Invoice Header" //112
{
    fields
    {
        field(60150; "Albaran No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(60130; "Fecha de operación"; Date)
        {
            Caption = 'Fecha de operación';
            DataClassification = CustomerContent;
            ToolTip = 'Especifica la fecha de operación de la factura.';
        }

    }

}