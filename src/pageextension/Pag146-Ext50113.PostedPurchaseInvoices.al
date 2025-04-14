pageextension 50113 "Posted Purchase Invoices" extends "Posted Purchase Invoices" //146
{
    layout
    {
        addafter("Vendor Invoice No.")
        {

            field("Vendor Order No."; Rec."Vendor Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor''s order number.';
            }
        }
        addafter("Posting Date")
        {

            field("Tipo factura"; Rec."Tipo factura")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tipo factura field.', Comment = '%';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}