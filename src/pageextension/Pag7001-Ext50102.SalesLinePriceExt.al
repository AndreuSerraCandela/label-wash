pageextension 50102 SalesLinePriceExt extends "Price List Lines" //7001
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