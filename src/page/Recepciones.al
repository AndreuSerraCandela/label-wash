page 50102 "Recepciones Mercancía"
{
    PageType = list;
    SourceTable = "Purchase Header";
    CardPageId = "Recepción Mercancía";
    UsageCategory = Lists;
    ModifyAllowed = false;
    ApplicationArea = All;
    SourceTableView = where("Document Type" = CONST(Order), Recepcion = CONST(true));
    Layout
    {
        area(Content)
        {
            repeater(Recepciones)
            {
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer No.';
                    Importance = Additional;
                    NotBlank = true;
                    ToolTip = 'Specifies the number of the customer who will receive the products and be billed by default.';

                    trigger OnValidate()
                    begin
                        //IsSalesLinesEditable := Rec.SalesLinesEditable();
                        //Rec.SelltoCustomerNoOnAfterValidate(Rec, xRec);
                        CurrPage.Update();
                    end;
                }
                field("Bill-to Customer Name"; Rec."Bill-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Nombre Cliente';
                    ShowMandatory = true;
                    ToolTip = 'Specifies the name of the customer who will receive the products and be billed by default.';

                    AboutTitle = 'Who are you selling to?';
                    AboutText = 'You can choose existing customers, or add new customers when you create orders. Orders can automatically choose special prices and discounts that you have set for each customer.';



                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        exit(Rec.LookupBillToCustomerName(Text));
                    end;
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    ApplicationArea = VAT;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s VAT registration number for customers.';
                    Visible = false;
                }

                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
                    Visible = false;
                }

                field("Bill-to Address"; Rec."Bill-to Address")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Address';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the address where the customer is located.';
                }
                field("Bill-to Address 2"; Rec."Bill-to Address 2")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Address 2';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies additional address information.';
                }
                field("Bill-to City"; Rec."Bill-to City")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'City';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the city of the customer on the sales document.';
                }

                field("Bill-to County"; Rec."Bill-to County")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'County';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the state, province or county of the address.';
                }
                field("Bill-to Post Code"; Rec."Bill-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Post Code';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the postal code.';
                }
                field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Country/Region Code';
                    Importance = Additional;
                    QuickEntry = false;
                    ToolTip = 'Specifies the country or region of the address.';


                }
                field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Contact No.';
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the contact person that the sales document will be sent to.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if not Rec.BilltoContactLookup() then
                            exit(false);
                        Text := Rec."Bill-to Contact No.";
                        CurrPage.Update();
                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        if Rec.GetFilter("Bill-to Contact No.") = xRec."Bill-to Contact No." then
                            if Rec."Bill-to Contact No." <> xRec."Bill-to Contact No." then
                                Rec.SetRange("Bill-to Contact No.");
                        if Rec."Bill-to Contact No." <> xRec."Bill-to Contact No." then
                            CurrPage.Update();
                    end;
                }
                field("Bill-to Phone No."; Rec."Bill-to Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Phone No.';
                    Importance = Additional;
                    ToolTip = 'Specifies the telephone number of the contact person that the sales document will be sent to.';
                }
                field("Bill-to E-Mail"; Rec."Bill-to E-Mail")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Email';
                    Importance = Additional;
                    ToolTip = 'Specifies the email address of the contact person that the sales document will be sent to.';
                }

                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Fecha Recepción Mercacía"; Rec."Order Date") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { }
            }
        }
    }
}