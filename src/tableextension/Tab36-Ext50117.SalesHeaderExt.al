tableextension 60117 SalesHeaderExt extends "Sales Header" //36
{
    fields
    {
        field(60101; "Proceso Facturación"; Guid)
        {
            DataClassification = ToBeClassified;
        }
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
        //linea

    }

}