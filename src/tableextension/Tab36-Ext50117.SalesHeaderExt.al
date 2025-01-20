tableextension 50117 SalesHeaderExt extends "Sales Header" //36
{
    fields
    {
        field(50001; "Proceso Facturación"; Guid)
        {
            DataClassification = ToBeClassified;
        }
        field(50050; "Albaran No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        //linea

    }

}