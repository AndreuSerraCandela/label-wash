tableextension 50106 SalesPriceExtension extends "Sales Price"
{
    fields
    {
        field(50107; "Precio de Tartamiento"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 3 : 3;
        }

    }
}
tableextension 50107 SalesLinePriceExtension extends "Price List Line"
{
    fields
    {
        field(50108; "Precio de Uso"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            DataClassification = CustomerContent;
        }

    }
}