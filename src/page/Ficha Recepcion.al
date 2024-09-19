page 50100 "Recepción Mercancía"
{
    PageType = Card;
    SourceTable = "Purchase Header";
    Layout
    {
        area(Content)
        {
            group(General)
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
                    ApplicationArea = All;
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
                group("Bill-to")
                {
                    Caption = 'Bill-to';
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
                    group(Control123)
                    {
                        ShowCaption = false;
                        field("Bill-to County"; Rec."Bill-to County")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'County';
                            Importance = Additional;
                            QuickEntry = false;
                            ToolTip = 'Specifies the state, province or county of the address.';
                        }
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
                }
                field("No."; Rec."No.") { ApplicationArea = All; }
                field("Fecha Recepción Mercacía"; Rec."Order Date") { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = all; }
            }
            part(LineasRecepcion; "Subform Recepcion")
            {
                ApplicationArea = Suite;
                SubPageLink = "Document No." = field("No.");
                UpdatePropagation = Both;
            }
        }

    }
    //Crear acciones
    actions
    {
        area(Processing)
        {
            action("&Facturar Tratamiento")
            {
                ApplicationArea = All;
                Caption = 'Facturar Tratamiento';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Facturar Tratamiento';
                Image = Invoice;
                trigger OnAction()
                begin
                    Facturar();
                end;
            }
            action("&Facturar envio")
            {
                ApplicationArea = All;
                Caption = 'Facturar Recepción';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Facturar Recepcion';
                Image = "Invoicing-Save";
                trigger OnAction()
                begin
                    FacturarRecepcion();
                end;
            }
            action("&Recibir")
            {
                ApplicationArea = All;
                Caption = '&Recibir';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Recibir';
                Image = Receipt;
                trigger OnAction()
                begin
                    Recibir(CODEUNIT::"Purch.-Post (Yes/No)", Enum::"Navigate After Posting"::"New Document");
                end;
            }
            action(Tratar)
            {
                ApplicationArea = All;
                Caption = 'Tratar';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Anular';
                Image = Share;
                trigger OnAction()
                begin
                    Trata();
                end;
            }
        }
        area(Navigation)
        {
            action(Receipts)
            {
                ApplicationArea = Suite;
                Caption = 'Receipts';
                Image = PostedReceipts;
                RunObject = Page "Posted Purchase Receipts";
                RunPageLink = "Order No." = field("No.");
                RunPageView = sorting("Order No.");
                ToolTip = 'View a list of posted purchase receipts for the order.';
            }
        }
    }

    internal procedure Recibir(PostingCodeunitID: Integer; Navigate: Enum "Navigate After Posting")
    var
        PurchaseHeader: Record "Purchase Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
        IsScheduledPosting: Boolean;
        DocumentIsPosted: Boolean;
    begin
        LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);
        Rec.Invoice := false;
        Rec.Receive := true;
        Rec.SendToPosting(PostingCodeunitID);

        IsScheduledPosting := Rec."Job Queue Status" = Rec."Job Queue Status"::"Scheduled for Posting";
        DocumentIsPosted := (not PurchaseHeader.Get(Rec."Document Type", Rec."No.")) or IsScheduledPosting;

        if IsScheduledPosting then
            CurrPage.Close();
        CurrPage.Update(false);


        if PostingCodeunitID <> CODEUNIT::"Purch.-Post (Yes/No)" then
            exit;

        case Navigate of
            Enum::"Navigate After Posting"::"Posted Document":
                begin
                    if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode()) then
                        ShowPostedConfirmationMessage();

                    if IsScheduledPosting or DocumentIsPosted then
                        CurrPage.Close();
                end;
            Enum::"Navigate After Posting"::"New Document":
                if DocumentIsPosted then begin
                    Clear(PurchaseHeader);
                    PurchaseHeader.Init();
                    PurchaseHeader.Validate("Document Type", PurchaseHeader."Document Type"::Order);
                    PurchaseHeader.Insert(true);
                    PAGE.Run(PAGE::"Purchase Order", PurchaseHeader);
                end;
        end;
    end;

    local procedure ShowPostedConfirmationMessage()
    var
        OrderPurchaseHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
        ICFeedback: Codeunit "IC Feedback";
    begin
        if not OrderPurchaseHeader.Get(Rec."Document Type", Rec."No.") then begin
            PurchInvHeader.SetRange("No.", Rec."Last Posting No.");
            if PurchInvHeader.FindFirst() then begin
                ICFeedback.ShowIntercompanyMessage(Rec, Enum::"IC Transaction Document Type"::Order);
                if InstructionMgt.ShowConfirm(StrSubstNo(OpenPostedPurchaseOrderQst, PurchInvHeader."No."),
                     InstructionMgt.ShowPostedConfirmationMessageCode())
                then
                    InstructionMgt.ShowPostedDocument(PurchInvHeader, Page::"Purchase Order");
            end;
        end;
    end;

    local procedure Trata()
    var
        location: Record Location;
        ItemJnlLine: Record "Item Journal Line";
        OriginalItemJnlLine: Record "Item Journal Line";
        TempWhseJnlLine: Record "Warehouse Journal Line" temporary;
        TempWhseTrackingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecificationChargeAssmt: Record "Tracking Specification" temporary;
        TempReservationEntry: Record "Reservation Entry" temporary;
        PostWhseJnlLine: Boolean;
        CheckApplToItemEntry: Boolean;
        PostJobConsumptionBeforePurch: Boolean;
        IsHandled: Boolean;
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        ItemLedgShptEntryNo: Integer;
        CantidadaTratar: Decimal;
        CantidadaTratarBase: Decimal;
        ConfInv: Record "inventory posting setup";
        ConfInvT: Record "inventory posting setup";
        ConfInvM: Record "inventory posting setup";
    begin

        PurchHeader.Get(Rec."Document Type", Rec."No.");
        If Not Location.Get(Rec."Location Code" + 'T') Then begin
            location.Init();
            location."Code" := Rec."Location Code" + 'T';
            location."Name" := Rec."Location Code" + 'T';
            location.Insert();
            ConfInv.SetRange("Location Code", Rec."Location Code");
            if ConfInv.FindSet() then
                repeat
                    ConfInvT := ConfInv;
                    ConfInvT."Location Code" := Rec."Location Code" + 'T';
                    If ConfInvT.Insert() Then;
                until ConfInv.Next() = 0;
        end;

        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindFirst() then
            repeat

                ItemJnlLine.Init();
                ItemJnlLine.CopyFromPurchHeader(PurchHeader);
                ItemJnlLine.CopyFromPurchLine(PurchLine);
                ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Negative Adjmt.";
                ItemJnlLine."Item Shpt. Entry No." := 0;//ItemLedgShptEntryNo;
                ItemJnlLine."Document No." := PurchHeader."No.";
                ItemJnlLine."Posting Date" := Today;
                ItemJnlLine.Quantity := -PurchLine."Cantidad a Tratar";
                ItemJnlLine."Quantity (Base)" := -PurchLine."Cantidad a Tratar Base";
                CantidadaTratar := PurchLine."Cantidad a Tratar";
                CantidadaTratarBase := PurchLine."Cantidad a Tratar Base";
                PurchLine.Validate("Cantidad Tratada", PurchLine."Cantidad Tratada" + PurchLine."Cantidad a Tratar" + PurchLine."Cantidad a Merma");
                PurchLine.Validate("Cantidad a Tratar", 0);
                PurchLine.Validate("Cantidad a Merma", 0);
                ItemJnlLine.Validate("Location Code", Rec."Location Code");
                ItemJnlLine."Invoiced Quantity" := 0;
                ItemJnlLine."Invoiced Qty. (Base)" := 0;
                RunItemJnlPostLine(ItemJnlLine);
                ItemJnlLine."Location Code" := Rec."Location Code" + 'T';
                ItemJnlLine."Entry Type" := ItemJnlLine."Entry Type"::"Positive Adjmt.";
                ItemJnlLine."Item Shpt. Entry No." := 0;//ItemLedgShptEntryNo;
                ItemJnlLine.Quantity := CantidadaTratar;
                ItemJnlLine."Quantity (Base)" := CantidadaTratarBase;
                RunItemJnlPostLine(ItemJnlLine);
                PurchLine.Modify();
            until PurchLine.Next() = 0;



    end;

    local procedure RunItemJnlPostLine(var ItemJnlLineToPost: Record "Item Journal Line")
    begin
        ItemJnlPostLine.RunWithCheck(ItemJnlLineToPost);
    end;

    local procedure Facturar()
    var
        PurchLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ConfGrupos: Record 252;
    begin
        SalesHeader.Init();
        PurchHeader.Get(Rec."Document Type", Rec."No.");
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."Bill-to Customer No." := PurchHeader."Bill-to Customer No.";
        SalesHeader."Order Date" := PurchHeader."Order Date";
        SalesHeader.Validate("Order Date", Rec."Order Date");
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", PurchHeader."Bill-to Customer No.");
        SalesHeader.Modify(true);
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindSet() then
            repeat
                SalesLine.Init();
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := PurchLine."Line No.";
                iF PurchLine.Type = PurchLine.TYPE::Item then begin
                    SalesLine.Type := SalesLine.TYPE::"G/L Account";
                    ConfGrupos.get(PurchHeader."Gen. Bus. Posting Group", PurchLine."Gen. Prod. Posting Group");
                    ConfGrupos.TestField("Sales Account");
                    SalesLine."No." := ConfGrupos."Sales Account";
                end else begin
                    SalesLine."Type" := PurchLine."Type";
                    SalesLine."No." := PurchLine."No.";
                    SalesLine."Variant Code" := PurchLine."Variant Code";
                end;

                SalesLine."Quantity" := PurchLine."Cantidad a Tratar";
                SalesLine."Quantity (Base)" := PurchLine."Cantidad a Tratar Base";
                SalesLine."Unit of Measure" := PurchLine."Unit of Measure";
                SalesLine.vALIDATE("Unit Price", PurchLine."Precio X Producto");
                SalesLine.Description := PurchLine.Description;
                SalesLine.Insert(true);
            until PurchLine.Next() = 0;

    end;

    local procedure FacturarRecepcion()
    var
        PurchLine: Record "Purchase Line";
        PurchHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        ConfGrupos: Record 252;
    begin
        SalesHeader.Init();
        PurchHeader.Get(Rec."Document Type", Rec."No.");
        SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
        SalesHeader."Bill-to Customer No." := PurchHeader."Bill-to Customer No.";
        SalesHeader."Order Date" := PurchHeader."Order Date";
        SalesHeader.Validate("Order Date", Rec."Order Date");
        SalesHeader.Insert(true);
        SalesHeader.Validate("Sell-to Customer No.", PurchHeader."Bill-to Customer No.");
        SalesHeader.Modify(true);
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        PurchLine.SetFilter("Qty. Rcd. Not Invoiced", '<>%1', 0);
        If not PurchLine.FindSet() then
            Error('Compruebe si ha recibido la mercancía, y si no la ha facturado');
        if PurchLine.FindSet() then
            repeat
                SalesLine.Init();
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := PurchLine."Line No.";
                iF PurchLine.Type = PurchLine.TYPE::Item then begin
                    SalesLine.Type := SalesLine.TYPE::"G/L Account";
                    ConfGrupos.get(PurchHeader."Gen. Bus. Posting Group", PurchLine."Gen. Prod. Posting Group");
                    ConfGrupos.TestField("Sales Account");
                    SalesLine."No." := ConfGrupos."Sales Account";
                end else begin
                    SalesLine."Type" := PurchLine."Type";
                    SalesLine."No." := PurchLine."No.";
                    SalesLine."Variant Code" := PurchLine."Variant Code";
                end;

                SalesLine."Quantity" := PurchLine."Qty. Rcd. Not Invoiced";
                PurchLine."Quantity Invoiced" += PurchLine."Qty. Rcd. Not Invoiced";
                PurchLine."Qty. Rcd. Not Invoiced" := 0;
                SalesLine."Quantity (Base)" := PurchLine."Qty. Rcd. Not Invoiced (Base)";
                PurchLine."Qty. Invoiced (Base)" += PurchLine."Qty. Rcd. Not Invoiced (Base)";
                PurchLine."Qty. Rcd. Not Invoiced (Base)" := 0;
                SalesLine."Unit of Measure" := PurchLine."Unit of Measure";
                SalesLine.vALIDATE("Unit Price", PurchLine."Precio X Producto");
                SalesLine.Description := PurchLine.Description;
                SalesLine.Insert(true);
            until PurchLine.Next() = 0;

    end;

    var
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        OpenPostedPurchaseOrderQst: Label 'El Recibo se ha registrado con el numero %1 y. se ha movidoa la ventana de albaranes, quiere verlo?', Comment = '%1 = posted document number';

}