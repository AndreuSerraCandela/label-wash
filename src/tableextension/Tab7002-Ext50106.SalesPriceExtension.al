tableextension 60106 SalesPriceExtension extends "Sales Price" //7002
{
    fields
    {
        field(60107; "Precio de Tartamiento"; Decimal)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 3 : 3;
        }

    }
}
tableextension 60107 SalesLinePriceExtension extends "Price List Line"
{
    fields
    {
        field(60108; "Precio de Uso"; Decimal)
        {
            DecimalPlaces = 3 : 3;
            DataClassification = CustomerContent;
        }

    }
}