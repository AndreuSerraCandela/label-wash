pageextension 60130 PaymentPracticeDataListExt extends "Payment Practice Data List" //686
{
    layout
    {
        addbefore("Invoice Entry No.")
        {
            field("Source Type"; Rec."Source Type")
            {
                ApplicationArea = All;
                ToolTip = 'Indica si el registro corresponde a un cliente, un proveedor o ambos.';
            }
            field("CV No."; Rec."CV No.")
            {
                ApplicationArea = All;
                DrillDown = true;
                ToolTip = 'Código del cliente o proveedor asociado a la factura.';

                trigger OnDrillDown()
                begin
                    DrillDownCV();
                end;
            }
            field(CVName; CVName)
            {
                ApplicationArea = All;
                Caption = 'Nombre cliente/proveedor';
                Editable = false;
                ToolTip = 'Nombre del cliente o proveedor asociado a la factura.';
            }
            field(InvoiceDocumentNo; InvoiceDocumentNo)
            {
                ApplicationArea = All;
                Caption = 'Nº documento';
                DrillDown = true;
                Editable = false;
                ToolTip = 'Número de documento del movimiento cliente/proveedor de la factura.';

                trigger OnDrillDown()
                begin
                    DrillDownInvoiceEntry();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CVName := GetCVName();
        InvoiceDocumentNo := GetInvoiceDocumentNo();
    end;

    local procedure GetCVName(): Text[100]
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        if Rec."CV No." = '' then
            exit('');

        case Rec."Source Type" of
            Rec."Source Type"::Customer:
                if Customer.Get(Rec."CV No.") then
                    exit(Customer.Name);
            Rec."Source Type"::Vendor:
                if Vendor.Get(Rec."CV No.") then
                    exit(Vendor.Name);
            Rec."Source Type"::"Vendor+Customer":
                begin
                    if Customer.Get(Rec."CV No.") then
                        exit(Customer.Name);
                    if Vendor.Get(Rec."CV No.") then
                        exit(Vendor.Name);
                end;
        end;
    end;

    local procedure GetInvoiceDocumentNo(): Code[20]
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendorLedgEntry: Record "Vendor Ledger Entry";
    begin
        if Rec."Invoice Entry No." = 0 then
            exit('');

        case Rec."Source Type" of
            Rec."Source Type"::Customer:
                if CustLedgEntry.Get(Rec."Invoice Entry No.") then
                    exit(CustLedgEntry."Document No.");
            Rec."Source Type"::Vendor:
                if VendorLedgEntry.Get(Rec."Invoice Entry No.") then
                    exit(VendorLedgEntry."Document No.");
            Rec."Source Type"::"Vendor+Customer":
                begin
                    if CustLedgEntry.Get(Rec."Invoice Entry No.") then
                        exit(CustLedgEntry."Document No.");
                    if VendorLedgEntry.Get(Rec."Invoice Entry No.") then
                        exit(VendorLedgEntry."Document No.");
                end;
        end;
    end;

    local procedure DrillDownInvoiceEntry()
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendorLedgEntry: Record "Vendor Ledger Entry";
    begin
        if Rec."Invoice Entry No." = 0 then
            exit;

        case Rec."Source Type" of
            Rec."Source Type"::Customer:
                if CustLedgEntry.Get(Rec."Invoice Entry No.") then
                    PAGE.Run(PAGE::"Customer Ledger Entries", CustLedgEntry);
            Rec."Source Type"::Vendor:
                if VendorLedgEntry.Get(Rec."Invoice Entry No.") then
                    PAGE.Run(PAGE::"Vendor Ledger Entries", VendorLedgEntry);
            Rec."Source Type"::"Vendor+Customer":
                begin
                    if CustLedgEntry.Get(Rec."Invoice Entry No.") then
                        PAGE.Run(PAGE::"Customer Ledger Entries", CustLedgEntry)
                    else
                        if VendorLedgEntry.Get(Rec."Invoice Entry No.") then
                            PAGE.Run(PAGE::"Vendor Ledger Entries", VendorLedgEntry);
                end;
        end;
    end;

    local procedure DrillDownCV()
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        if Rec."CV No." = '' then
            exit;

        case Rec."Source Type" of
            Rec."Source Type"::Customer:
                if Customer.Get(Rec."CV No.") then
                    PAGE.Run(PAGE::"Customer Card", Customer);
            Rec."Source Type"::Vendor:
                if Vendor.Get(Rec."CV No.") then
                    PAGE.Run(PAGE::"Vendor Card", Vendor);
            Rec."Source Type"::"Vendor+Customer":
                begin
                    if Customer.Get(Rec."CV No.") then
                        PAGE.Run(PAGE::"Customer Card", Customer)
                    else
                        if Vendor.Get(Rec."CV No.") then
                            PAGE.Run(PAGE::"Vendor Card", Vendor);
                end;
        end;
    end;

    var
        CVName: Text[100];
        InvoiceDocumentNo: Code[20];
}
