pageextension 50101 SalesPriceExt extends "Sales Prices"
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
pageextension 50102 SalesLinePriceExt extends "Price List Lines"
{
    layout
    {
        addafter("Unit Price")
        {
            field("Precio de Uso"; Rec."Precio de Uso")
            {
                ApplicationArea = All;
                ToolTip = 'Precio de Uso';

            }
        }
    }
}