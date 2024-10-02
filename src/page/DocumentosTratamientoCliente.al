page 50102 "Mercancía Clientes"
{
    PageType = list;
    SourceTable = "Purchase Header";
    //CardPageId = "Recepción Mercancía";
    UsageCategory = Lists;
    ModifyAllowed = false;
    ApplicationArea = All;
    SourceTableView = where("Document Type" = CONST(Order), Recepcion = filter(<> Recepcion::" "));
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
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(Editar)
            {
                ApplicationArea = All;
                Caption = 'Editar';
                Image = Edit;
                RunPageMode = Edit;
                trigger OnAction()
                begin
                    case Rec.Recepcion of
                        Recepcion::"Recepción":
                            Page.Run(pAGE::"Recepción Mercancía", Rec);
                        Recepcion::Uso:
                            Page.Run(pAGE::"Uso Mercancía", Rec);
                        Recepcion::Tratamiento:
                            Page.Run(pAGE::"Tratamiento Mercancía", Rec);
                    end;
                end;
            }
        }
        area(Processing)
        {

            action("Recepcion mercancia Nueva")
            {
                ApplicationArea = All;
                Caption = 'Recepcion mercancia Nueva';
                Image = Receipt;
                RunObject = Page "Recepción Mercancía";
                RunPageMode = Create;

            }

            action("Envio Para uso desde Cliente")
            {
                ApplicationArea = All;
                Caption = 'Envio Para uso desde Cliente';
                Image = WarehouseRegisters;
                trigger OnAction()
                var

                    ItemJnlLine: Record "Item Ledger Entry";
                    PurchHeader: Record "Purchase Header";
                    Linea: Integer;
                    PageLineas: Page "Lineas Recepcion";
                    PruchSetup: Record "Purchases & Payables Setup";
                    Location: Record Location;
                    ConfInv: Record "Inventory Posting Setup";
                    ConfInvT: Record "Inventory Posting Setup";
                    PurchLine: Record "Purchase Line";
                begin
                    PruchSetup.Get();

                    ItemJnlLine.SetRange("Location Code", Rec."Bill-to Customer No." + 'R');
                    If ItemJnlLine.FindSet() then begin
                        InitPurch(PurchHeader, Rec);
                        PurchHeader.Recepcion := Recepcion::Uso;
                        PurchHeader."No. Series" := PruchSetup."Recepcion Tratamientos";
                        PurchHeader.Validate("Bill-to Customer No.", Rec."Bill-to Customer No.");
                        PurchHeader."Receiving No. Series" := PruchSetup."Recepciones Tratamientos";
                        PurchHeader."Location Code" := Rec."Bill-to Customer No." + 'U';
                        PurchHeader."No." := '';
                        PurchHeader.Insert(true);

                        If Not Location.Get(Rec."Bill-to Customer No." + 'U') Then begin
                            location.Init();
                            location."Code" := Rec."Bill-to Customer No." + 'U';
                            location."Name" := Rec."Bill-to Customer No." + 'U';
                            location.Insert();
                            ConfInv.SetRange("Location Code", Rec."Bill-to Customer No." + 'R');
                            if ConfInv.FindSet() then
                                repeat
                                    ConfInvT := ConfInv;
                                    ConfInvT."Location Code" := Rec."Bill-to Customer No." + 'U';
                                    If ConfInvT.Insert() Then;
                                until ConfInv.Next() = 0;
                        end;
                        repeat

                            PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                            PurchLine.SetRange("Document No.", PurchHeader."No.");
                            PurchLine.SetRange("No.", ItemJnlLine."Item No.");
                            if PurchLine.FindFirst() then begin
                                PurchLine.Validate(Quantity, PurchLine.Quantity + ItemJnlLine.Quantity);
                                PurchLine.Modify();
                            end else begin
                                PurchLine.Init();
                                PurchLine."Document Type" := PurchHeader."Document Type";
                                PurchLine."Document No." := PurchHeader."No.";
                                Linea += 10000;
                                PurchLine."Line No." := Linea;
                                PurchLine."Type" := PurchLine.Type::Item;

                                PurchLine.Insert(true);
                                PurchLine.Validate("No.", ItemJnlLine."Item No.");
                                PurchLine.Validate(Quantity, ItemJnlLine.Quantity);
                                PurchLine.Modify();
                            end;
                        until ItemJnlLine.Next() = 0;
                    end;
                    Commit();
                    Page.Run(pAGE::"Uso Mercancía", PurchHeader);

                end;
            }
            action("Recepcion para tratar")
            {
                ApplicationArea = All;
                Caption = 'Recepcion para tratar';
                Image = Recalculate;
                trigger OnAction()
                var

                    ItemJnlLine: Record "Item Ledger Entry";
                    PurchHeader: Record "Purchase Header";
                    Linea: Integer;
                    PageLineas: Page "Lineas Recepcion";
                    PruchSetup: Record "Purchases & Payables Setup";
                    Location: Record Location;
                    ConfInv: Record "Inventory Posting Setup";
                    ConfInvT: Record "Inventory Posting Setup";
                    PurchLine: Record "Purchase Line";
                begin
                    PruchSetup.Get();

                    ItemJnlLine.SetRange("Location Code", Rec."Bill-to Customer No." + 'U');
                    If ItemJnlLine.FindSet() then begin
                        InitPurch(PurchHeader, Rec);
                        PurchHeader.Recepcion := Recepcion::Tratamiento;
                        PurchHeader."No. Series" := PruchSetup."Recepcion Tratamientos";
                        PurchHeader."Receiving No. Series" := PruchSetup."Recepciones Tratamientos";
                        PurchHeader.Validate("Bill-to Customer No.", Rec."Bill-to Customer No.");
                        PurchHeader."Location Code" := Rec."Bill-to Customer No." + 'T';
                        PurchHeader."No." := '';
                        PurchHeader.Insert(true);

                        If Not Location.Get(Rec."Bill-to Customer No." + 'T') Then begin
                            location.Init();
                            location."Code" := Rec."Bill-to Customer No." + 'T';
                            location."Name" := Rec."Bill-to Customer No." + 'T';
                            location.Insert();
                            ConfInv.SetRange("Location Code", Rec."Bill-to Customer No." + 'U');
                            if ConfInv.FindSet() then
                                repeat
                                    ConfInvT := ConfInv;
                                    ConfInvT."Location Code" := Rec."Bill-to Customer No." + 'T';
                                    If ConfInvT.Insert() Then;
                                until ConfInv.Next() = 0;
                        end;
                        If Not Location.Get(Rec."Bill-to Customer No." + 'M') Then begin
                            location.Init();
                            location."Code" := Rec."Bill-to Customer No." + 'M';
                            location."Name" := Rec."Bill-to Customer No." + 'M';
                            location.Insert();
                            ConfInv.SetRange("Location Code", Rec."Bill-to Customer No." + 'U');
                            if ConfInv.FindSet() then
                                repeat
                                    ConfInvT := ConfInv;
                                    ConfInvT."Location Code" := Rec."Bill-to Customer No." + 'M';
                                    If ConfInvT.Insert() Then;
                                until ConfInv.Next() = 0;
                        end;
                        repeat

                            PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                            PurchLine.SetRange("Document No.", PurchHeader."No.");
                            PurchLine.SetRange("No.", ItemJnlLine."Item No.");
                            if PurchLine.FindFirst() then begin
                                PurchLine."No Avisar" := true;
                                PurchLine.Validate(Quantity, PurchLine.Quantity + ItemJnlLine.Quantity);
                                PurchLine.Modify();
                            end else begin
                                PurchLine.Init();
                                PurchLine."Document Type" := PurchHeader."Document Type";
                                PurchLine."Document No." := PurchHeader."No.";
                                Linea += 10000;
                                PurchLine."Line No." := Linea;
                                PurchLine."Type" := PurchLine.Type::Item;
                                PurchLine."No Avisar" := true;
                                PurchLine.Insert(true);
                                PurchLine.Validate("No.", ItemJnlLine."Item No.");
                                PurchLine."No Avisar" := true;
                                PurchLine.Validate(Quantity, ItemJnlLine.Quantity);
                                PurchLine.Modify();

                            end;
                        until ItemJnlLine.Next() = 0;
                        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                        PurchLine.SetRange("Document No.", PurchHeader."No.");
                        PurchLine.SetRange("No.");
                        PurchLine.ModifyAll("No Avisar", false);
                    end;
                    Commit();
                    Page.Run(pAGE::"Tratamiento Mercancía", PurchHeader);

                end;
            }
            action("Envio Para uso desde Tratamiento")
            {
                ApplicationArea = All;
                Caption = 'Envio Para uso desde Tratamiento';
                Image = WageLines;
                trigger OnAction()
                var

                    ItemJnlLine: Record "Item Ledger Entry";
                    PurchHeader: Record "Purchase Header";
                    Linea: Integer;
                    PageLineas: Page "Lineas Recepcion";
                    PruchSetup: Record "Purchases & Payables Setup";
                    Location: Record Location;
                    ConfInv: Record "Inventory Posting Setup";
                    ConfInvT: Record "Inventory Posting Setup";
                    PurchLine: Record "Purchase Line";
                begin
                    PruchSetup.Get();

                    ItemJnlLine.SetRange("Location Code", Rec."Bill-to Customer No." + 'T');
                    If ItemJnlLine.FindSet() then begin
                        InitPurch(PurchHeader, Rec);
                        PurchHeader.Recepcion := Recepcion::Uso;
                        PurchHeader.Validate("Bill-to Customer No.", Rec."Bill-to Customer No.");
                        PurchHeader."No. Series" := PruchSetup."Recepcion Tratamientos";
                        PurchHeader."Receiving No. Series" := PruchSetup."Recepciones Tratamientos";
                        PurchHeader."Location Code" := Rec."Bill-to Customer No." + 'U';
                        PurchHeader."No." := '';
                        PurchHeader.Insert(true);

                        If Not Location.Get(Rec."Bill-to Customer No." + 'U') Then begin
                            location.Init();
                            location."Code" := Rec."Bill-to Customer No." + 'U';
                            location."Name" := Rec."Bill-to Customer No." + 'U';
                            location.Insert();
                            ConfInv.SetRange("Location Code", Rec."Bill-to Customer No." + 'R');
                            if ConfInv.FindSet() then
                                repeat
                                    ConfInvT := ConfInv;
                                    ConfInvT."Location Code" := Rec."Bill-to Customer No." + 'U';
                                    If ConfInvT.Insert() Then;
                                until ConfInv.Next() = 0;
                        end;
                        repeat

                            PurchLine.SetRange("Document Type", PurchHeader."Document Type");
                            PurchLine.SetRange("Document No.", PurchHeader."No.");
                            PurchLine.SetRange("No.", ItemJnlLine."Item No.");
                            if PurchLine.FindFirst() then begin
                                PurchLine.Validate(Quantity, PurchLine.Quantity + ItemJnlLine.Quantity);
                                PurchLine.Modify();
                            end else begin
                                PurchLine.Init();
                                PurchLine."Document Type" := PurchHeader."Document Type";
                                PurchLine."Document No." := PurchHeader."No.";
                                Linea += 10000;
                                PurchLine."Line No." := Linea;
                                PurchLine."Type" := PurchLine.Type::Item;

                                PurchLine.Insert(true);
                                PurchLine.Validate("No.", ItemJnlLine."Item No.");
                                PurchLine.Validate(Quantity, ItemJnlLine.Quantity);
                                PurchLine.Modify();

                            end;
                        until ItemJnlLine.Next() = 0;
                    end;
                    Commit();
                    Page.Run(pAGE::"Uso Mercancía", PurchHeader);

                end;
            }
            // action("&Facturar")
            // {
            //     ApplicationArea = All;
            //     Caption = 'Facturar';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     ToolTip = 'Facturar Recepcion';
            //     Image = Invoice;
            //     trigger OnAction()
            //     begin
            //         Facturar();
            //     end;
            // }
        }
        area(Promoted)
        {
            actionref(Edit_Ref; Editar) { }
            actionref(Recepcion_mercancia_Nueva_Ref; "Recepcion mercancia Nueva") { }
            actionref(Envio_Para_uso_desde_Cliente_Ref; "Envio Para uso desde Cliente") { }
            actionref(Recepcion_para_tratar_Ref; "Recepcion para tratar") { }
            actionref(Envio_Para_uso_desde_Tratamiento_Ref; "Envio Para uso desde Tratamiento") { }
        }
    }
    var
        PurchLineTemp: Record "Purchase Line" temporary;
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";

    // local procedure Facturar()
    // var
    //     PurchHeader: Record "Purchase Header";
    //     SalesHeader: Record "Sales Header";
    //     SalesLine: Record "Sales Line";
    //     ConfGrupos: Record 252;
    // begin
    //     If Not PurchLineTemp.FindSet() then
    //         error('Debe reclasificar los productos antes de facturar');
    //     SalesHeader.Init();
    //     PurchHeader.Get(Rec."Document Type", Rec."No.");
    //     SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
    //     SalesHeader."Bill-to Customer No." := PurchHeader."Bill-to Customer No.";
    //     SalesHeader."Order Date" := PurchHeader."Order Date";
    //     SalesHeader.Validate("Order Date", Rec."Order Date");
    //     SalesHeader.Insert(true);
    //     SalesHeader.Validate("Sell-to Customer No.", PurchHeader."Bill-to Customer No.");
    //     SalesHeader.Modify(true);
    //     if PurchLineTemp.FindSet() then
    //         repeat
    //             SalesLine.Init();
    //             SalesLine."Document Type" := SalesHeader."Document Type";
    //             SalesLine."Document No." := SalesHeader."No.";
    //             SalesLine."Line No." := PurchLineTemp."Line No.";
    //             iF PurchLineTemp.Type = PurchLineTemp.TYPE::Item then begin
    //                 SalesLine.Type := SalesLine.TYPE::"G/L Account";
    //                 ConfGrupos.get(PurchHeader."Gen. Bus. Posting Group", PurchLineTemp."Gen. Prod. Posting Group");
    //                 ConfGrupos.TestField("Sales Account");
    //                 SalesLine."No." := ConfGrupos."Sales Account";
    //             end else begin
    //                 SalesLine."Type" := PurchLineTemp."Type";
    //                 SalesLine."No." := PurchLineTemp."No.";
    //                 SalesLine."Variant Code" := PurchLineTemp."Variant Code";
    //             end;

    //             SalesLine."Quantity" := PurchLineTemp."Cantidad a Tratar";
    //             SalesLine."Quantity (Base)" := PurchLineTemp."Cantidad a Tratar Base";
    //             SalesLine."Unit of Measure" := PurchLineTemp."Unit of Measure";
    //             SalesLine.vALIDATE("Unit Price", PurchLineTemp."Precio X Producto");
    //             SalesLine.Description := PurchLinetemp.Description;
    //             SalesLine.Insert(true);
    //         until PurchLineTemp.Next() = 0;

    // end;

    // local procedure RunItemJnlPostLine(var ItemJnlLineToPost: Record "Item Journal Line")
    // begin
    //     ItemJnlPostLine.RunWithCheck(ItemJnlLineToPost);
    // end;

    local procedure InitPurch(var PurchHeader: Record "Purchase Header"; Rec: Record "Purchase Header")
    begin
        PurchHeader.InitFromPurchHeader(Rec);
        PurchHeader."Document Type" := Rec."Document Type";
        PurchHeader."No. Series" := Rec."No. Series";
        PurchHeader."Receiving No. Series" := Rec."Receiving No. Series";
        PurchHeader."Buy-from Vendor No." := Rec."Buy-from Vendor No.";
        PurchHeader."Pay-to Vendor No." := Rec."Buy-from Vendor No.";
        PurchHeader."Bill-to Customer No." := Rec."Bill-to Customer No.";
        PurchHeader."Bill-to Address" := Rec."Bill-to Address";
        PurchHeader."Bill-to Address 2" := Rec."Bill-to Address 2";
        PurchHeader."Bill-to City" := Rec."Bill-to City";
        PurchHeader."Bill-to County" := Rec."Bill-to County";
        PurchHeader."Bill-to Post Code" := Rec."Bill-to Post Code";
        PurchHeader."Bill-to Country/Region Code" := Rec."Bill-to Country/Region Code";
        PurchHeader."Bill-to Contact No." := Rec."Bill-to Contact No.";
        PurchHeader."Bill-to Phone No." := Rec."Bill-to Phone No.";
        PurchHeader."Bill-to E-Mail" := Rec."Bill-to E-Mail";
        PurchHeader."Bill-to Name" := Rec."Bill-to Name";
        PurchHeader."VAT Registration No." := Rec."VAT Registration No.";
        PurchHeader."Bill-to Name 2" := Rec."Bill-to Name 2";

    end;
}