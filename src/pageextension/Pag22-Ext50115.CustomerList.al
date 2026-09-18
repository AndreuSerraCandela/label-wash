pageextension 60115 CustomerList extends "Customer List" //22
{
    layout
    {
        addafter(Name)
        {
            field(Temporales; Rec.Temporal)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Temporales field.', Comment = '%';
            }

            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the customer''s VAT registration number for customers in EU countries/regions.';
            }
        }

    }

    actions
    {
        addlast(FinanceReports)
        {
            // action(CustomerDimBalanceMatrix)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Matriz saldo periodo por dimensión';
            //     Image = ShowMatrix;
            //     Promoted = true;
            //     PromotedCategory = Report;
            //     PromotedOnly = true;
            //     ToolTip = 'Muestra el saldo periodo de los clientes desglosado por valores de dimensión.';

            //     trigger OnAction()
            //     var
            //         CustomerDimBalanceMatrix: Page "Customer Dim. Balance Matrix";
            //     begin
            //         CustomerDimBalanceMatrix.SetTotalsFilters(
            //             Rec.GetFilter("Date Filter"),
            //             Rec.GetFilter("Global Dimension 1 Filter"),
            //             Rec.GetFilter("Global Dimension 2 Filter"),
            //             Rec.GetFilter("Currency Filter"));
            //         CustomerDimBalanceMatrix.Run();
            //     end;
            // }
            action(CustomerGLDimBalanceMatrix)
            {
                ApplicationArea = All;
                Caption = 'Matriz saldo periodo contabilidad por dimensión';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Report;
                PromotedOnly = true;
                ToolTip = 'Muestra el saldo periodo de movimientos de contabilidad por cliente (Nº origen) desglosado por valores de dimensión.';

                trigger OnAction()
                var
                    CustomerGLDimBalanceMatrix: Page "Customer GL Balance Matrix";
                begin
                    CustomerGLDimBalanceMatrix.SetTotalsFilters(
                        Rec.GetFilter("Date Filter"),
                        Rec.GetFilter("Global Dimension 1 Filter"),
                        Rec.GetFilter("Global Dimension 2 Filter"),
                        Rec.GetFilter("Currency Filter"),
                        '');
                    CustomerGLDimBalanceMatrix.Run();
                end;
            }
        }
    }
}
