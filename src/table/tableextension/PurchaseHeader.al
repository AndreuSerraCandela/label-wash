tableextension 50100 PurchaseHeaderExtension extends "Purchase Header"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                Validate("Location Code", AlmacenCliente("Bill-to Customer No.", Recepcion, false));

            end;
        }
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                if "Location Code" <> '' Then exit;
                if Recepcion = Recepcion::"Recepción" then begin
                    Validate("Location Code", AlmacenCliente("Bill-to Customer No.", Recepcion::"Recepción", false));
                end;
                if Recepcion = Recepcion::Tratamiento then begin
                    Validate("Location Code", AlmacenCliente("Bill-to Customer No.", Recepcion::Tratamiento, false));
                end;
                if Recepcion = Recepcion::Uso then begin
                    Validate("Location Code", AlmacenCliente("Bill-to Customer No.", Recepcion::Uso, false));
                end;
            end;
        }

        field(50000; Recepcion; Enum Recepcion) { }
        field(50104; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Cód Cliente';
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            var
                Location: Record Location;
                PurchSetup: Record "Purchases & Payables Setup";
            begin
                TestStatusOpen();
                If StrLen("Bill-to Customer No.") > 8 then
                    Error('El código del cliente no debe exceder los 8 caracteres');
                GetCust("Bill-to Customer No.");
                SetBillToCustomerAddressFieldsFromCustomer(Cust);
                PurchSetup.Get();
                If PurchSetup."Proveedor Tratamientos" = '' Then Error('No se ha definido un proveedor por defecto para este sistema');
                if purchsetup."Recepcion Tratamientos" = '' then Error('No se ha definido una serie de recepción por defecto para este sistema');
                if purchsetup."Recepciones Tratamientos" = '' then Error('No se ha definido una serie para los albaranes por defecto para este sistema');

                Validate("Buy-from Vendor No.", PurchSetup."Proveedor Tratamientos");
                validate("no. series", purchsetup."Recepcion Tratamientos");
                validate("Receiving No. Series", purchsetup."Recepciones Tratamientos");
                "Payment Method Code" := Cust."Payment Method Code";
                "Payment Terms Code" := Cust."Payment Terms Code";
                If Cust."Location Code" <> '' then Validate("Location Code", Cust."Location Code");
                if Cust."Location Code" = '' then begin
                    If Not Location.Get("Bill-to Customer No." + 'R') then
                        If Confirm('No se ha definido un almacén para el cliente, desea crear uno?') then begin
                            Location.Code := "Bill-to Customer No." + 'R';
                            Location.Name := "Bill-to Name";
                            Location.Insert(true);
                            Validate("Location Code", Location."Code");
                            Cust."Location Code" := Location."Code";
                            Cust.Modify(true);
                        end else
                            Error('No se puede continuar sin un almacén definido para el cliente');
                end;


            end;
        }
        field(50015; "Bill-to Name"; Text[100])
        {
            Caption = 'Bill-to Name';
            TableRelation = Customer.Name;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                Customer: Record Customer;
            begin
                if "Bill-to Customer No." <> '' then
                    Customer.Get("Bill-to Customer No.");

                if Customer.SelectCustomer(Customer) then begin
                    xRec := Rec;
                    "Bill-to Name" := Customer.Name;
                    Validate("Bill-to Customer No.", Customer."No.");
                end;
            end;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                Validate("Bill-to Customer No.", Customer.GetCustNo("Bill-to Name"));
            end;
        }
        field(50016; "Bill-to Name 2"; Text[50])
        {
            Caption = 'Bill-to Name 2';
        }
        field(50017; "Bill-to Address"; Text[100])
        {
            Caption = 'Bill-to Address';


        }
        field(50018; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';


        }
        field(50019; "Bill-to City"; Text[30])
        {
            Caption = 'Bill-to City';
            TableRelation = if ("Bill-to Country/Region Code" = const('')) "Post Code".City
            else
            if ("Bill-to Country/Region Code" = filter(<> '')) "Post Code".City where("Country/Region Code" = field("Bill-to Country/Region Code"));
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code");


            end;

            trigger OnValidate()
            var
                IsHandled: Boolean;
            begin
                IsHandled := false;
                PostCode.ValidateCity(
                        "Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);

            end;
        }
        field(50110; "Bill-to Contact"; Text[100])
        {
            Caption = 'Bill-to Contact';

            trigger OnLookup()
            var
                Contact: Record Contact;
            begin
                Contact.FilterGroup(2);
                LookupContact("Bill-to Customer No.", "Bill-to Contact No.", Contact);
                if PAGE.RunModal(0, Contact) = ACTION::LookupOK then
                    Validate("Bill-to Contact No.", Contact."No.");
                Contact.FilterGroup(0);
            end;


        }
        field(50053; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                if "Bill-to Customer No." <> '' then
                    if Cont.Get("Bill-to Contact No.") then
                        Cont.SetRange("Company No.", Cont."Company No.")
                    else
                        if ContBusinessRelation.FindByRelation(ContBusinessRelation."Link to Table"::Customer, "Bill-to Customer No.") then
                            Cont.SetRange("Company No.", ContBusinessRelation."Contact No.")
                        else
                            Cont.SetRange("No.", '');

                if "Bill-to Contact No." <> '' then
                    if Cont.Get("Bill-to Contact No.") then;
                if PAGE.RunModal(0, Cont) = ACTION::LookupOK then begin
                    xRec := Rec;
                    Validate("Bill-to Contact No.", Cont."No.");
                end;
            end;

            trigger OnValidate()
            var
                Cont: Record Contact;
                Confirmed: Boolean;
            begin
                TestStatusOpen();

                if "Bill-to Contact No." <> '' then
                    if Cont.Get("Bill-to Contact No.") then
                        Cont.CheckIfPrivacyBlockedGeneric();

                if ("Bill-to Contact No." <> xRec."Bill-to Contact No.") and
                   (xRec."Bill-to Contact No." <> '')
                then begin
                    if GetHideValidationDialog() or (not GuiAllowed) then
                        Confirmed := true
                    else
                        Confirmed := Confirm(ConfirmChangeQst, false, FieldCaption("Bill-to Contact No."));
                    if Not Confirmed then begin
                        "Bill-to Contact No." := xRec."Bill-to Contact No.";
                        exit;
                    end;
                end;

                if ("Bill-to Customer No." <> '') and ("Bill-to Contact No." <> '') then
                    CheckContactRelatedToCustomerCompany("Bill-to Contact No.", "Bill-to Customer No.", CurrFieldNo);

                UpdateBillToCust("Bill-to Contact No.");
            end;
        }
        field(50185; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = "Post Code";
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                PostCode.LookupPostCode("Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code");


            end;

            trigger OnValidate()
            var
            begin
                PostCode.ValidatePostCode(
                        "Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);

            end;
        }
        field(50186; "Bill-to County"; Text[30])
        {
            CaptionClass = '5,3,' + "Bill-to Country/Region Code";
            Caption = 'Bill-to County';


        }
        field(50187; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Bill-to Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            var
                FormatAddress: Codeunit "Format Address";
            begin
                if not FormatAddress.UseCounty(Rec."Bill-to Country/Region Code") then
                    "Bill-to County" := '';

            end;
        }
        field(50188; "Bill-to Phone No."; Text[30])
        {
            Caption = 'Teléfono';
        }
        field(50189; "Bill-to E-Mail"; Text[80])
        {
            Caption = 'Contacto';
            TableRelation = Contact;
        }
    }


    local procedure GetCust(BilltoCustomerNo: Code[20])
    begin
        Cust.Get(BilltoCustomerNo);
    end;

    procedure SetBillToCustomerAddressFieldsFromCustomer(var BillToCustomer: Record Customer)
    begin
        "Bill-to Name" := BillToCustomer.Name;
        "Bill-to Name 2" := BillToCustomer."Name 2";
        "Bill-to Address" := BillToCustomer.Address;
        "Bill-to Address 2" := BillToCustomer."Address 2";
        "Bill-to Contact No." := BillToCustomer."Primary Contact No.";
        "Bill-to City" := BillToCustomer.City;
        "Bill-to E-Mail" := BillToCustomer."E-Mail";
        "Bill-to Post Code" := BillToCustomer."Post Code";
        "Bill-to County" := BillToCustomer.County;
        "Bill-to Phone No." := BillToCustomer."Phone No.";
        "Bill-to Country/Region Code" := BillToCustomer."Country/Region Code";
        "Bill-to Contact" := BillToCustomer.Contact;
        "Payment Terms Code" := BillToCustomer."Payment Terms Code";
        "Prepmt. Payment Terms Code" := BillToCustomer."Payment Terms Code";

        "Payment Method Code" := BillToCustomer."Payment Method Code";

        if ("VAT Bus. Posting Group" <> '') and ("VAT Bus. Posting Group" <> BillToCustomer."VAT Bus. Posting Group") then
            Validate("VAT Bus. Posting Group", BillToCustomer."VAT Bus. Posting Group")
        else
            "VAT Bus. Posting Group" := BillToCustomer."VAT Bus. Posting Group";
        "VAT Country/Region Code" := BillToCustomer."Country/Region Code";
        "VAT Registration No." := BillToCustomer."VAT Registration No.";
        "Gen. Bus. Posting Group" := BillToCustomer."Gen. Bus. Posting Group";
        "Currency Code" := BillToCustomer."Currency Code";
        "Prices Including VAT" := BillToCustomer."Prices Including VAT";
        "Price Calculation Method" := BillToCustomer.GetPriceCalculationMethod();
        "Invoice Disc. Code" := BillToCustomer."Invoice Disc. Code";
        "Language Code" := BillToCustomer."Language Code";
        "Format Region" := BillToCustomer."Format Region";
        if "Document Type" in ["Document Type"::Order, "Document Type"::Quote] then
            "Prepayment %" := BillToCustomer."Prepayment %";
        "Tax Area Code" := BillToCustomer."Tax Area Code";
        if ("Ship-to Code" = '') or ("Sell-to Customer No." <> BillToCustomer."No.") then
            "Tax Liable" := BillToCustomer."Tax Liable";

    end;

    procedure LookupContact(CustomerNo: Code[20]; ContactNo: Code[20]; var Contact: Record Contact)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        FilterByContactCompany: Boolean;
    begin

        if ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Customer, CustomerNo) then
            Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.")
        else
            if "Document Type" = "Document Type"::Quote then
                FilterByContactCompany := true
            else
                Contact.SetRange("Company No.", '');
        if ContactNo <> '' then
            if Contact.Get(ContactNo) then
                if FilterByContactCompany then
                    Contact.SetRange("Company No.", Contact."Company No.");
    end;

    local procedure CheckContactRelatedToCustomerCompany(ContactNo: Code[20]; CustomerNo: Code[20]; CurrFieldNo: Integer);
    var
        Contact: Record Contact;
        ContBusRel: Record "Contact Business Relation";
    begin

        Contact.Get(ContactNo);
        if ContBusRel.FindByRelation(ContBusRel."Link to Table"::Customer, CustomerNo) then
            if (ContBusRel."Contact No." <> Contact."Company No.") and (ContBusRel."Contact No." <> Contact."No.") then
                Error(Text038, Contact."No.", Contact.Name, CustomerNo);
    end;

    local procedure UpdateBillToCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Cont: Record Contact;
        SearchContact: Record Contact;
        CustomerTempl: Record "Customer Templ.";
        ContactBusinessRelationFound: Boolean;
    begin
        if not Cont.Get(ContactNo) then begin
            "Bill-to Contact" := '';
            exit;
        end;
        "Bill-to Contact No." := Cont."No.";

        UpdateBillToCustContact(Cont);

        if Cont.Type = Cont.Type::Person then
            ContactBusinessRelationFound := ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer, Cont."No.");
        if not ContactBusinessRelationFound then begin
            ContactBusinessRelationFound :=
                    ContBusinessRelation.FindByContact(ContBusinessRelation."Link to Table"::Customer, Cont."Company No.");
        end;


        if ContactBusinessRelationFound then begin
            if "Bill-to Customer No." = '' then begin
                Validate("Bill-to Customer No.", ContBusinessRelation."No.");

            end else
                CheckCustomerContactRelation(Cont, "Bill-to Customer No.", ContBusinessRelation."No.");
        end else begin
            if "Document Type" = "Document Type"::Quote then begin
                if not GetContactAsCompany(Cont, SearchContact) then
                    SearchContact := Cont;
                "Bill-to Name" := SearchContact."Company Name";
                "Bill-to Name 2" := SearchContact."Name 2";
                "Bill-to Address" := SearchContact.Address;
                "Bill-to Address 2" := SearchContact."Address 2";
                "Bill-to City" := SearchContact.City;
                "Bill-to Post Code" := SearchContact."Post Code";
                "Bill-to County" := SearchContact.County;
                "Bill-to Country/Region Code" := SearchContact."Country/Region Code";
                "VAT Registration No." := SearchContact."VAT Registration No.";
                Validate("Currency Code", SearchContact."Currency Code");
                "Language Code" := SearchContact."Language Code";
                "Format Region" := SearchContact."Format Region";


            end else begin
                Error(ContactIsNotRelatedToAnyCostomerErr, Cont."No.", Cont.Name);
            end;
        end;


    end;

    local procedure UpdateBillToCustContact(Cont: Record Contact)
    var
        Customer: Record Customer;
    begin
        if Customer.Get("Bill-to Customer No.") and (Cont.Type = Cont.Type::Company) then
            "Bill-to Contact" := Customer.Contact
        else
            if Cont.Type = Cont.Type::Company then
                "Bill-to Contact" := ''
            else
                "Bill-to Contact" := Cont.Name;
    end;

    local procedure CheckCustomerContactRelation(Cont: Record Contact; CustomerNo: Code[20]; ContBusinessRelationNo: Code[20])
    begin

        if (CustomerNo <> '') and (CustomerNo <> ContBusinessRelationNo) then
            Error(Text037, Cont."No.", Cont.Name, CustomerNo);
    end;

    protected procedure GetContactAsCompany(Contact: Record Contact; var SearchContact: Record Contact): Boolean;
    begin
        if Contact."Company No." <> '' then
            exit(SearchContact.Get(Contact."Company No."));
    end;

    procedure LookupBillToCustomerName(var CustomerName: Text): Boolean
    var
        Customer: Record Customer;
        LookupStateManager: Codeunit "Lookup State Manager";
        RecVariant: Variant;
        SearchCustomerName: Text;
    begin
        SearchCustomerName := CustomerName;
        Customer.SetFilter("Date Filter", GetFilter("Date Filter"));
        if "Sell-to Customer No." <> '' then
            Customer.Get("Sell-to Customer No.");

        if Customer.SelectCustomer(Customer) then begin
            if Rec."Bill-to Name" = Customer.Name then
                CustomerName := SearchCustomerName
            else
                CustomerName := Customer.Name;
            RecVariant := Customer;
            LookupStateManager.SaveRecord(RecVariant);
            exit(true);
        end;
    end;

    procedure BilltoContactLookup(): Boolean
    var
        Contact: Record Contact;
        ContactBusinessRelation: Record "Contact Business Relation";
        IsHandled: Boolean;
    begin
        if "Bill-to Customer No." <> '' then
            if Contact.Get("Bill-to Contact No.") then
                Contact.SetRange("Company No.", Contact."Company No.")
            else
                if ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Customer, "Bill-to Customer No.") then
                    Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.")
                else
                    Contact.SetRange("No.", '');

        if "Bill-to Contact No." <> '' then
            if Contact.Get("Bill-to Contact No.") then;
        if Page.RunModal(0, Contact) = Action::LookupOK then begin
            xRec := Rec;
            CurrFieldNo := FieldNo("Bill-to Contact No.");
            Validate("Bill-to Contact No.", Contact."No.");
            exit(true);
        end;
        exit(false);
    end;

    Procedure AlmacenCliente(Cliente: Code[20]; Tipo: Enum Recepcion; Merma: Boolean): Text
    var
        Cust: Record Customer;
        LocationCode: Code[10];
    begin
        Cust.Get(Cliente);
        LocationCode := Cust."Location Code";
        Cust."Location Code" := Copystr(Cust."Location Code", 1, StrLen(Cust."Location Code") - 1);
        If Merma then
            exit(Cust."Location Code" + 'M');
        case Tipo of
            Recepcion::"Recepción":
                exit(LocationCode);
            Recepcion::Tratamiento:
                exit(Cust."Location Code" + 'T');
            Recepcion::Uso:
                exit(Cust."Location Code" + 'U');
        end;
    end;

    var
        Cust: Record Customer;
        PostCode: Record "Post Code";
        Text037: Label 'El Contacto %1 %2 no está relacionado con el cliente %3.';
        ConfirmChangeQst: Label '¿Quiere cambiar %1?', Comment = '%1 = a Field Caption like Currency Code';
        Text038: Label 'El Contacto %1 %2 está relacionado con una empresa diferente al cliente %3.';
        ContactIsNotRelatedToAnyCostomerErr: Label 'El Contacto %1 %2 no está relacionado con un cliente.';
}