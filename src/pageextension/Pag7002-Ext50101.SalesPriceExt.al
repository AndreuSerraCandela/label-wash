pageextension 50101 SalesPriceExt extends "Sales Prices" //7002
{
    layout
    {
        addafter("Unit Price")
        {
            field("Precio de Tratamiento"; Rec."Precio de Tartamiento")
            {
                ApplicationArea = All;
                ToolTip = 'Precio de Tratamiento';

            }
        }
    }
}
