tableextension 50125 Vendor extends Vendor //23
{
    fields
    {
        field(50100; Temporal; Decimal)
        {
            AutoFormatType = 1;
            //   CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where("Customer No." = field("No."),
            //                                                                      "Initial Entry Global Dim. 1" = field("Global Dimension 1 Filter"),
            //  "Initial Entry Global Dim. 2" = field("Global Dimension 2 Filter"),
            //  "Currency Code" = field("Currency Filter"),
            //  "Excluded from calculation" = const(false)));
            CalcFormula = sum("G/L Entry".Amount where("Source Type" = filter(Vendor),
                                          "Source No." = field("No."), Temporal = filter(true)));
            Caption = 'Temporales';
            Editable = false;
            FieldClass = FlowField;

        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}