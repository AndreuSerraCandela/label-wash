/// <summary>
/// Report Sales - Invoice Servitec (ID 50000).
/// </summary>
Report 50100 "Notas Recepcion Servitec"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/layout/NotaRecepcion.rdlc';
    Permissions = TableData 7190 = rimd;
    Caption = 'Notas Recepcion Servitec';



    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            DataItemTableView = SORTING("No.");

            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";

            column(NoAlbaran; NoAlbaran) { }
            column(No_SalesInvoiceHeader;
            "No.")
            { }

            column(PaymentTermsDescription;
            PaymentTerms.Description)
            { }

            column(ShipmentMethodDescription;
            ShipmentMethod.Description)
            { }

            column(PaymentMethodDescription;
            PaymentMethod.Description)
            { }

            column(PmtTermsDescCaption;
            PmtTermsDescCaptionLbl)
            { }

            column(ShpMethodDescCaption;
            ShpMethodDescCaptionLbl)
            { }

            column(PmtMethodDescCaption;
            PmtMethodDescCaptionLbl)
            { }

            column(NumeroCuentaenFactura;
            '')
            { }

            column(SWIFT;
            '')
            { }

            column(DocDateCaption;
            DocDateCaptionLbl)
            { }

            column(HomePageCaption;
            HomePageCaptionLbl)
            { }

            column(EmailCaption;
            EmailCaptionLbl)
            { }

            column(ExternalDocumentNo;
            Format(PurchaseHeader.Recepcion))
            { }

            column(NoDocExtLblCaption;
            NoDocExtLbl)
            { }

            column(NoCtaAccLblCaption;
            NoCtaAccLbl)
            { }


            dataItem(CopyLoop; integer)
            {
                DataItemTableView = SORTING(Number);


                dataItem(PageLoop; integer)
                {
                    DataItemTableView = SORTING(Number)
                                 WHERE(Number = CONST(1));
                    column(CompanyInfo2Picture
                ; CompanyInfo2.Picture)
                    { }

                    column(CompanyInfo1Picture
                ; CompanyInfo1.Picture)
                    { }

                    column(CompanyInfo3Picture
                ; CompanyInfo3.Picture)
                    { }

                    column(DocumentCaption
                ; STRSUBSTNO(DocumentCaption, CopyText))
                    { }

                    column(CustAddr1
                ; CustAddr[1])
                    { }

                    column(CompanyAddr1
                ; CompanyAddr[1])
                    { }

                    column(CustAddr2
                ; CustAddr[2])
                    { }

                    column(CompanyAddr2
                ; CompanyAddr[2])
                    { }

                    column(CustAddr3
                ; CustAddr[3])
                    { }

                    column(CompanyAddr3
                ; CompanyAddr[3])
                    { }

                    column(CustAddr4
                ; CustAddr[4])
                    { }

                    column(CompanyAddr4
                ; CompanyAddr[4])
                    { }

                    column(CustAddr5
                ; CustAddr[5])
                    { }

                    column(CompanyInfoPhoneNo
                ; CompanyInfo."Phone No.")
                    { }

                    column(CustAddr6
                ; CustAddr[6])
                    { }

                    column(CompanyInfoVATRegistrationNo
                ; CompanyInfo."VAT Registration No.")
                    { }

                    column(CompanyInfoHomePage
                ; CompanyInfo."Home Page")
                    { }

                    column(CompanyInfoEmail
                ; CompanyInfo."E-Mail")
                    { }

                    column(CompanyInfoGiroNo
                ; CompanyInfo."Giro No.")
                    { }

                    column(CompanyInfoBankName
                ; CompanyInfo."Bank Name")
                    { }

                    column(CompanyInfoBankAccountNo
                ; CompanyInfo."Bank Account No.")
                    { }

                    column(BilltoCustNo_SalesInvHdr
                ; PurchaseHeader."Bill-to Customer No.")
                    { }

                    column(PostingDate_SalesInvHdr
                ; FORMAT(PurchaseHeader."Posting Date"))
                    { }

                    column(VATNoText
                ; VATNoText)
                    { }

                    column(VATRegNo_SalesInvHeader
                ; PurchaseHeader."VAT Registration No.")
                    { }

                    column(DueDate_SalesInvHeader
                ; FORMAT(PurchaseHeader."Due Date"))
                    { }

                    column(SalesPersonText
                ; SalesPersonText)
                    { }

                    column(SalesPurchPersonName
                ; SalesPurchPerson.Name)
                    { }

                    column(No_SalesInvoiceHeader1
                ; PurchaseHeader."Bill-to Name")
                    { }

                    column(ReferenceText
                ; ReferenceText)
                    { }

                    column(YourReference_SalesInvHdr
                ; PurchaseHeader."Your Reference")
                    { }

                    column(OrderNoText
                ; OrderNoText)
                    { }

                    column(OrderNo_SalesInvHeader
                ; PurchaseHeader."No.")
                    { }

                    column(CustAddr7
                ; CustAddr[7])
                    { }

                    column(CustAddr8
                ; CustAddr[8])
                    { }

                    column(CompanyAddr5
                ; CompanyAddr[5])
                    { }

                    column(CompanyAddr6
                ; CompanyAddr[6])
                    { }

                    column(DocDate_SalesInvoiceHdr
                ; FORMAT(PurchaseHeader."Document Date", 0, 4))
                    { }

                    column(PricesInclVAT_SalesInvHdr
                ; PurchaseHeader."Prices Including VAT")
                    { }

                    column(OutputNo
                ; OutputNo)
                    { }

                    column(PricesInclVATYesNo
                ; FORMAT(PurchaseHeader."Prices Including VAT"))
                    { }

                    column(PageCaption
                ; STRSUBSTNO(Text005, ''))
                    { }

                    column(PhoneNoCaption
                ; PhoneNoCaptionLbl)
                    { }

                    column(VATRegNoCaption
                ; VATRegNoCaptionLbl)
                    { }

                    column(GiroNoCaption
                ; GiroNoCaptionLbl)
                    { }

                    column(BankNameCaption
                ; BankNameCaptionLbl)
                    { }

                    column(BankAccNoCaption
                ; BankAccNoCaptionLbl)
                    { }

                    column(DueDateCaption
                ; DueDateCaptionLbl)
                    { }

                    column(InvoiceNoCaption
                ; InvoiceNoCaptionLbl)
                    { }

                    column(PostingDateCaption
                ; PostingDateCaptionLbl)
                    { }

                    column(BilltoCustNo_SalesInvHdrCaption
                ; PurchaseHeader.FIELDCAPTION("Bill-to Customer No."))
                    { }

                    column(PricesInclVAT_SalesInvHdrCaption
                ; PurchaseHeader.FIELDCAPTION("Prices Including VAT"))
                    { }

                    column(CompShip1; CompanyInfo."Ship-to Address") { }
                    column(CompShip2; CompanyInfo."Ship-to City") { }
                    column(CompShip3; CompanyInfo."Ship-to Post Code") { }

                    column(ShpCaptionLbl2; ShpCaptionLbl2) { }

                    dataItem(DimensionLoop1; integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));

                        DataItemLinkReference = PurchaseHeader;

                        column(DimText; DimText) { }

                        column(Number_DimensionLoop1; Number) { }

                        column(HdrDimsCaption; HdrDimsCaptionLbl) { }
                        trigger OnPreDataItem()
                        BEGIN
                            IF NOT ShowInternalInfo THEN
                                CurrReport.BREAK;
                        END;

                        trigger OnAfterGetRecord()
                        BEGIN
                            IF Number = 1 THEN BEGIN
                                IF NOT DimSetEntry1.FINDSET THEN
                                    CurrReport.BREAK;
                            END ELSE
                                IF NOT Continue THEN
                                    CurrReport.BREAK;

                            CLEAR(DimText);
                            Continue := FALSE;
                            REPEAT
                                OldDimText := DimText;
                                IF DimText = '' THEN
                                    DimText := STRSUBSTNO('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                ELSE
                                    DimText :=
                                        STRSUBSTNO(
                                        '%1, %2 %3', DimText,
                                        DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                    DimText := OldDimText;
                                    Continue := TRUE;
                                    EXIT;
                                END;
                            UNTIL DimSetEntry1.NEXT = 0;
                        END;
                    }

                    dataItem("Sales Invoice Line"; "Purchase Line")
                    {
                        DataItemTableView = SORTING("Document No.", "Line No.");

                        DataItemLinkReference = PurchaseHeader;
                        DataItemLink = "Document No." = FIELD("No."), "Document Type" = FIELD("Document Type");

                        column(GetCarteraInvoice;
                        GetCarteraInvoice)
                        { }

                        column(LineAmt_SalesInvoiceLine;
                        "Line Amount")
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(Description_SalesInvLine;
                        Description)
                        { }

                        column(No_SalesInvoiceLine;
                        "No.")
                        { }

                        column(Quantity_SalesInvoiceLine;
                        "Quantity Received")
                        { }

                        column(UOM_SalesInvoiceLine;
                        "Unit of Measure")
                        { }

                        column(UnitPrice_SalesInvLine;
                        "Direct Unit Cost")
                        {
                            AutoFormatType = 2;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }


                        column(LineDisc_SalesInvoiceLine;
                        "Line Discount %")
                        { }

                        column(VATIdent_SalesInvLine;
                        "VAT Identifier")
                        { }

                        column(PostedShipmentDate;
                        FORMAT(PostedShipmentDate))
                        { }

                        column(Type_SalesInvoiceLine;
                        FORMAT("Sales Invoice Line".Type))
                        { }

                        column(InvDiscountAmount;
                        -"Inv. Discount Amount")
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(TotalSubTotal;
                        TotalSubTotal)
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(TotalInvoiceDiscountAmount;
                        TotalInvoiceDiscountAmount)
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(TotalAmount;
                        TotalAmount)
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(TotalGivenAmount;
                        TotalGivenAmount)
                        { }

                        column(SalesInvoiceLineAmount;
                        Amount)
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(AmountIncludingVATAmount;
                        "Amount Including VAT" - Amount)
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(Amount_SalesInvoiceLineIncludingVAT;
                        "Amount Including VAT")
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(VATAmtLineVATAmtText;
                        VATAmountLine.VATAmountText)
                        { }

                        column(TotalExclVATText;
                        TotalExclVATText)
                        { }

                        column(TotalInclVATText;
                        TotalInclVATText)
                        { }

                        column(TotalAmountInclVAT;
                        TotalAmountInclVAT)
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(TotalAmountVAT;
                        TotalAmountVAT)
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(VATBaseDisc_SalesInvHdr;
                        PurchaseHeader."VAT Base Discount %")
                        {
                            AutoFormatType = 1;
                        }

                        column(TotalPaymentDiscountOnVAT;
                        TotalPaymentDiscountOnVAT)
                        {
                            AutoFormatType = 1;
                        }

                        column(VATAmtLineVATCalcType;
                        VATAmountLine."VAT Calculation Type")
                        { }

                        column(LineNo_SalesInvoiceLine;
                        "Line No.")
                        { }

                        column(PmtinvfromdebtpaidtoFactCompCaption;
                        PmtinvfromdebtpaidtoFactCompCaptionLbl)
                        { }

                        column(UnitPriceCaption;
                        UnitPriceCaptionLbl)
                        { }

                        column(DiscountCaption;
                        DiscountCaptionLbl)
                        { }

                        column(AmtCaption;
                        AmtCaptionLbl)
                        { }

                        column(PostedShpDateCaption;
                        PostedShpDateCaptionLbl)
                        { }

                        column(InvDiscAmtCaption;
                        InvDiscAmtCaptionLbl)
                        { }

                        column(SubtotalCaption;
                        SubtotalCaptionLbl)
                        { }

                        column(PmtDiscGivenAmtCaption;
                        PmtDiscGivenAmtCaptionLbl)
                        { }

                        column(PmtDiscVATCaption;
                        PmtDiscVATCaptionLbl)
                        { }

                        column(Description_SalesInvLineCaption;
                        FIELDCAPTION(Description))
                        { }

                        column(No_SalesInvoiceLineCaption;
                        FIELDCAPTION("No."))
                        { }

                        column(Quantity_SalesInvoiceLineCaption;
                        FIELDCAPTION(Quantity))
                        { }

                        column(UOM_SalesInvoiceLineCaption;
                        FIELDCAPTION("Unit of Measure"))
                        { }

                        column(VATIdent_SalesInvLineCaption;
                        FIELDCAPTION("VAT Identifier"))
                        { }


                        dataItem("Sales Shipment Buffer"; Integer)
                        {
                            DataItemTableView = SORTING(Number);


                            column(PostingDate_SalesShipmentBuffer; FORMAT(SalesShipmentBuffer."Posting Date")) { }

                            column(Quantity_SalesShipmentBuffer; SalesShipmentBuffer.Quantity)
                            { DecimalPlaces = 0 : 5; }


                            trigger OnPreDataItem()
                            BEGIN
                                SalesShipmentBuffer.SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
                                SalesShipmentBuffer.SETRANGE("Line No.", "Sales Invoice Line"."Line No.");

                                SETRANGE(Number, 1, SalesShipmentBuffer.COUNT);
                            END;

                            trigger OnAfterGetRecord()
                            BEGIN
                                IF Number = 1 THEN
                                    SalesShipmentBuffer.FIND('-')
                                ELSE
                                    SalesShipmentBuffer.NEXT;
                            END;

                        }

                        dataItem(DimensionLoop2; Integer)
                        {
                            DataItemTableView = SORTING(Number)
                                            WHERE(Number = FILTER(1 ..));


                            column(DimText1; DimText) { }
                            column(ShpCaption; ShpCaptionLbl) { }

                            column(LineDimsCaption; LineDimsCaptionLbl) { }
                            trigger OnPreDataItem()
                            BEGIN
                                IF NOT ShowInternalInfo THEN
                                    CurrReport.BREAK;

                                DimSetEntry2.SETRANGE("Dimension Set ID", "Sales Invoice Line"."Dimension Set ID");
                            END;

                            trigger OnAfterGetRecord()
                            BEGIN
                                IF Number = 1 THEN BEGIN
                                    IF NOT DimSetEntry2.FINDSET THEN
                                        CurrReport.BREAK;
                                END ELSE
                                    IF NOT Continue THEN
                                        CurrReport.BREAK;

                                CLEAR(DimText);
                                Continue := FALSE;
                                REPEAT
                                    OldDimText := DimText;
                                    IF DimText = '' THEN
                                        DimText := STRSUBSTNO('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    ELSE
                                        DimText :=
                                            STRSUBSTNO(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    IF STRLEN(DimText) > MAXSTRLEN(OldDimText) THEN BEGIN
                                        DimText := OldDimText;
                                        Continue := TRUE;
                                        EXIT;
                                    END;
                                UNTIL DimSetEntry2.NEXT = 0;
                            END;
                        }

                        dataItem(AsmLoop; Integer)
                        {
                            DataItemTableView = SORTING(Number);

                            column(TempPostedAsmLineUOMCode; GetUOMText(TempPostedAsmLine."Unit of Measure Code"))
                            {
                                // DecimalPlaces = 0 : 5; 
                            }

                            column(TempPostedAsmLineQuantity; TempPostedAsmLine.Quantity) { DecimalPlaces = 0 : 5; }

                            column(TempPostedAsmLineVariantCode; BlanksForIndent + TempPostedAsmLine."Variant Code")
                            {
                                //DecimalPlaces = 0 : 5; 
                            }

                            column(TempPostedAsmLineDescrip; BlanksForIndent + TempPostedAsmLine.Description)
                            { }

                            column(TempPostedAsmLineNo; BlanksForIndent + TempPostedAsmLine."No.") { }
                            trigger OnPreDataItem()
                            BEGIN
                                CLEAR(TempPostedAsmLine);
                                IF NOT DisplayAssemblyInformation THEN
                                    CurrReport.BREAK;
                                CollectAsmInformation;
                                CLEAR(TempPostedAsmLine);
                                SETRANGE(Number, 1, TempPostedAsmLine.COUNT);
                            END;

                            trigger OnAfterGetRecord()
                            BEGIN
                                IF Number = 1 THEN
                                    TempPostedAsmLine.FINDSET
                                ELSE
                                    TempPostedAsmLine.NEXT;
                            END;
                        }

                        trigger OnPreDataItem()
                        BEGIN
                            VATAmountLine.DELETEALL;
                            SalesShipmentBuffer.RESET;
                            SalesShipmentBuffer.DELETEALL;
                            FirstValueEntryNo := 0;
                            MoreLines := FIND('+');
                            WHILE MoreLines AND (Description = '') AND ("No." = '') AND (Quantity = 0) AND (Amount = 0) DO
                                MoreLines := NEXT(-1) <> 0;
                            IF NOT MoreLines THEN
                                CurrReport.BREAK;
                            SETRANGE("Line No.", 0, "Line No.");
                            CurrReport.CREATETOTALS("Line Amount", Amount, "Amount Including VAT", "Inv. Discount Amount", "Pmt. Discount Amount");
                        END;

                        trigger OnAfterGetRecord()
                        BEGIN
                            PostedShipmentDate := 0D;
                            IF Quantity <> 0 THEN
                                PostedShipmentDate := FindPostedShipmentDate;

                            IF (Type = Type::"G/L Account") AND (NOT ShowInternalInfo) THEN
                                "No." := '';

                            IF VATPostingSetup.GET("Sales Invoice Line"."VAT Bus. Posting Group", "Sales Invoice Line"."VAT Prod. Posting Group") THEN BEGIN
                                VATAmountLine.INIT;
                                VATAmountLine."VAT Identifier" := VATPostingSetup."VAT Identifier";
                                VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                                VATAmountLine."Tax Group Code" := "Tax Group Code";
                                VATAmountLine."VAT %" := VATPostingSetup."VAT %";
                                VATAmountLine."EC %" := VATPostingSetup."EC %";
                                VATAmountLine."VAT Base" := "Sales Invoice Line".Amount;
                                VATAmountLine."Amount Including VAT" := "Sales Invoice Line"."Amount Including VAT";
                                VATAmountLine."Line Amount" := "Line Amount";
                                VATAmountLine."Pmt. Discount Amount" := "Pmt. Discount Amount";
                                IF "Allow Invoice Disc." THEN
                                    VATAmountLine."Inv. Disc. Base Amount" := "Line Amount";
                                VATAmountLine."Invoice Discount Amount" := "Inv. Discount Amount";
                                VATAmountLine.SetCurrencyCode(PurchaseHeader."Currency Code");
                                VATAmountLine."VAT Difference" := "VAT Difference";
                                VATAmountLine."EC Difference" := "EC Difference";
                                IF PurchaseHeader."Prices Including VAT" THEN
                                    VATAmountLine."Prices Including VAT" := TRUE;
                                VATAmountLine.InsertLine;

                                TotalSubTotal += "Line Amount";
                                TotalInvoiceDiscountAmount -= "Inv. Discount Amount";
                                TotalAmount += Amount;
                                TotalAmountVAT += "Amount Including VAT" - Amount;
                                TotalAmountInclVAT += "Amount Including VAT";
                                TotalGivenAmount -= "Pmt. Discount Amount";
                                TotalPaymentDiscountOnVAT += -("Line Amount" - "Inv. Discount Amount" - "Pmt. Discount Amount" - "Amount Including VAT");
                            END;
                        END;
                    }

                    dataItem(VATCounter; integer)
                    {
                        DataItemTableView = SORTING(Number);

                        column(VATAmountLineVATBase;
                        VATAmountLine."VAT Base")
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(VATAmountLineVATAmount;
                        VATAmountLine."VAT Amount")
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(VATAmountLineLineAmount;
                        VATAmountLine."Line Amount")
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(VATAmtLineInvDiscBaseAmt;
                        VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(VATAmtLineInvDiscountAmt;
                        VATAmountLine."Invoice Discount Amount" + VATAmountLine."Pmt. Discount Amount")
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(VATAmtLineECAmount;
                        VATAmountLine."EC Amount")
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(VATAmountLineVAT;
                        VATAmountLine."VAT %")
                        { DecimalPlaces = 0 : 6; }

                        column(VATAmtLineVATIdentifier;
                        VATAmountLine."VAT Identifier")
                        { }

                        column(VATAmountLineEC;
                        VATAmountLine."EC %")
                        {
                            AutoFormatType = 1;
                            AutoFormatExpression = PurchaseHeader."Currency Code";
                        }

                        column(VATAmtLineVATCaption;
                        VATAmtLineVATCaptionLbl)
                        { }

                        column(VATECBaseCaption;
                        VATECBaseCaptionLbl)
                        { }

                        column(VATAmountCaption;
                        VATAmountCaptionLbl)
                        { }

                        column(VATAmtSpecCaption;
                        VATAmtSpecCaptionLbl)
                        { }

                        column(VATIdentCaption;
                        VATIdentCaptionLbl)
                        { }

                        column(InvDiscBaseAmtCaption;
                        InvDiscBaseAmtCaptionLbl)
                        { }

                        column(LineAmtCaption1;
                        LineAmtCaption1Lbl)
                        { }

                        column(InvPmtDiscCaption;
                        InvPmtDiscCaptionLbl)
                        { }

                        column(ECAmtCaption;
                        ECAmtCaptionLbl)
                        { }

                        column(ECCaption;
                        ECCaptionLbl)
                        { }

                        column(TotalCaption;
                        TotalCaptionLbl)
                        { }

                        trigger OnPreDataItem()
                        BEGIN
                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            CurrReport.CREATETOTALS(
                                VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                                VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount",
                                VATAmountLine."EC Amount", VATAmountLine."Pmt. Discount Amount");
                        END;

                        trigger OnAfterGetRecord()
                        BEGIN
                            VATAmountLine.GetLine(Number);
                            IF VATAmountLine."VAT Amount" = 0 THEN
                                VATAmountLine."VAT %" := 0;
                            IF VATAmountLine."EC Amount" = 0 THEN
                                VATAmountLine."EC %" := 0;
                        END;
                    }

                    dataItem(VatCounterLCY; integer)
                    {
                        DataItemTableView = SORTING(Number);



                        column(VALSpecLCYHeader; VALSpecLCYHeader) { }

                        column(VALExchRate; VALExchRate) { }

                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }

                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }

                        column(VATAmountLineVAT1; VATAmountLine."VAT %") { DecimalPlaces = 0 : 5; }

                        column(VATAmtLineVATIdentifier1; VATAmountLine."VAT Identifier") { }

                        column(VALVATBaseLCYCaption1; VALVATBaseLCYCaption1Lbl) { }
                        trigger OnPreDataItem()
                        BEGIN
                            IF (NOT GLSetup."Print VAT specification in LCY") OR
                                (PurchaseHeader."Currency Code" = '')
                            THEN
                                CurrReport.BREAK;

                            SETRANGE(Number, 1, VATAmountLine.COUNT);
                            CurrReport.CREATETOTALS(VALVATBaseLCY, VALVATAmountLCY);

                            IF GLSetup."LCY Code" = '' THEN
                                VALSpecLCYHeader := Text007 + Text008
                            ELSE
                                VALSpecLCYHeader := Text007 + FORMAT(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency(PurchaseHeader."Posting Date", PurchaseHeader."Currency Code", 1);
                            CalculatedExchRate := ROUND(1 / PurchaseHeader."Currency Factor" * CurrExchRate."Exchange Rate Amount", 0.000001);
                            VALExchRate := STRSUBSTNO(Text009, CalculatedExchRate, CurrExchRate."Exchange Rate Amount");
                        END;

                        trigger OnAfterGetRecord()
                        BEGIN
                            VATAmountLine.GetLine(Number);

                            VALVATBaseLCY := ROUND(VATAmountLine."VAT Base" / PurchaseHeader."Currency Factor");
                            VALVATAmountLCY := ROUND(VATAmountLine."VAT Amount" / PurchaseHeader."Currency Factor");
                        END;
                    }

                    dataItem(Total; integer)
                    {
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number = CONST(1));
                    }

                    dataItem(Total2; Integer)
                    {
                        DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));


                        column(SelltoCustNo_SalesInvHdr; PurchaseHeader."Sell-to Customer No.") { }

                        column(ShipToAddr1; ShipToAddr[1]) { }

                        column(ShipToAddr2; ShipToAddr[2]) { }

                        column(ShipToAddr3; ShipToAddr[3]) { }

                        column(ShipToAddr4; ShipToAddr[4]) { }

                        column(ShipToAddr5; ShipToAddr[5]) { }

                        column(ShipToAddr6; ShipToAddr[6]) { }

                        column(ShipToAddr7; ShipToAddr[7]) { }

                        column(ShipToAddr8; ShipToAddr[8]) { }

                        column(ShiptoAddressCaption; ShiptoAddressCaptionLbl) { }

                        column(SelltoCustNo_SalesInvHdrCaption; PurchaseHeader.FIELDCAPTION("Sell-to Customer No.")) { }
                        trigger OnPreDataItem()
                        BEGIN
                            IF NOT ShowShippingAddr THEN
                                CurrReport.BREAK;
                        END;
                    }
                }
                trigger OnPreDataItem()
                BEGIN
                    NoOfLoops := ABS(NoOfCopies) + Cust."Invoice Copies" + 1;
                    IF NoOfLoops <= 0 THEN
                        NoOfLoops := 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                END;

                trigger OnAfterGetRecord()
                var
                    SalesINvoice: Record "Sales Invoice Header" temporary;
                BEGIN
                    IF Number > 1 THEN BEGIN
                        CopyText := Text003;
                        OutputNo += 1;
                    END;
                    CurrReport.PAGENO := 1;

                    TotalSubTotal := 0;
                    TotalInvoiceDiscountAmount := 0;
                    TotalAmount := 0;
                    TotalAmountVAT := 0;
                    TotalAmountInclVAT := 0;
                    TotalGivenAmount := 0;
                    TotalPaymentDiscountOnVAT := 0;

                END;

                trigger OnPostDataItem()
                BEGIN
                    IF NOT CurrReport.PREVIEW THEN
                        SalesInvCountPrinted.RUN(PurchaseHeader);
                END;
            }
            trigger OnAfterGetRecord()
            var
                SalesInvoice: Record "Sales Invoice Header" temporary;
                ShipCustAdr: Record "Ship-to Address";
            BEGIN
                If "Language Code" = '' Then "Language Code" := 'ESP';
                CurrReport.LANGUAGE := LanguageMgt.GetLanguageID("Language Code");

                IF RespCenter.GET("Responsibility Center") THEN BEGIN
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                END ELSE BEGIN
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                END;

                DimSetEntry1.SETRANGE("Dimension Set ID", "Dimension Set ID");

                OrderNoText := '';
                SalesPurchPerson.INIT;
                SalesPersonText := '';
                IF "Your Reference" = '' THEN
                    ReferenceText := ''
                ELSE
                    ReferenceText := FIELDCAPTION("Your Reference");
                IF "VAT Registration No." = '' THEN
                    VATNoText := ''
                ELSE
                    VATNoText := FIELDCAPTION("VAT Registration No.");
                IF "Currency Code" = '' THEN BEGIN
                    GLSetup.TESTFIELD("LCY Code");
                    TotalText := STRSUBSTNO(Text001, GLSetup."LCY Code");
                    TotalInclVATText := STRSUBSTNO(Text1100000, GLSetup."LCY Code");
                    TotalExclVATText := STRSUBSTNO(Text1100001, GLSetup."LCY Code");
                END ELSE BEGIN
                    TotalText := STRSUBSTNO(Text001, "Currency Code");
                    TotalInclVATText := STRSUBSTNO(Text1100000, "Currency Code");
                    TotalExclVATText := STRSUBSTNO(Text1100001, "Currency Code");
                END;
                // SalesInvoice."Bill-to Customer No." := "Sales Invoice Header"."Bill-to Customer No.";
                // SalesInvoice."Bill-to Address" := "Sales Invoice Header"."Bill-to Address";
                // SalesInvoice."Bill-to Contact No." := "Sales Invoice Header"."Bill-to Contact No.";
                // SalesInvoice."Bill-to Name" := "Sales Invoice Header"."Bill-to Name";
                // SalesInvoice."Bill-to Name 2" := "Sales Invoice Header"."Bill-to Name 2";
                // SalesInvoice."Bill-to Post Code" := "Sales Invoice Header"."Bill-to Post Code";
                // SalesInvoice."Bill-to City" := "Sales Invoice Header"."Bill-to City";
                // SalesInvoice."Bill-to County" := "Sales Invoice Header"."Bill-to County";
                // SalesInvoice."Bill-to Country/Region Code" := "Sales Invoice Header"."Bill-to Country/Region Code";
                IF NOT Cust.GET("Bill-to Customer No.") THEN
                    CLEAR(Cust);
                if ShipCustAdr.GET("Bill-to Customer No.", cUST."Ship-to Code") THEN begin
                    iF ShipCustAdr.Name <> '' THEN
                        Cust."Name" := ShipCustAdr.Name;
                    IF ShipCustAdr."Name 2" <> '' THEN
                        Cust."Name 2" := ShipCustAdr."Name 2";
                    IF ShipCustAdr.Address <> '' THEN
                        Cust.Address := ShipCustAdr.Address;
                    IF ShipCustAdr."Address 2" <> '' THEN
                        Cust."Address 2" := ShipCustAdr."Address 2";
                    IF ShipCustAdr.City <> '' THEN
                        Cust.City := ShipCustAdr.City;
                    IF ShipCustAdr.County <> '' THEN
                        Cust.County := ShipCustAdr.County;
                    IF ShipCustAdr."Post Code" <> '' THEN
                        Cust."Post Code" := ShipCustAdr."Post Code";
                    IF ShipCustAdr."Country/Region Code" <> '' THEN
                        Cust."Country/Region Code" := ShipCustAdr."Country/Region Code";
                    IF ShipCustAdr."Phone No." <> '' THEN
                        Cust."Phone No." := ShipCustAdr."Phone No.";
                end;


                If Salesinvoice."Bill-to Name" = '' THEN
                    SalesInvoice."Bill-to Name" := Cust.Name;
                IF Salesinvoice."Bill-to Name 2" = '' THEN
                    SalesInvoice."Bill-to Name 2" := Cust."Name 2";
                IF Salesinvoice."Bill-to Post Code" = '' THEN
                    SalesInvoice."Bill-to Post Code" := Cust."Post Code";
                IF Salesinvoice."Bill-to City" = '' THEN
                    SalesInvoice."Bill-to City" := Cust.City;
                IF Salesinvoice."Bill-to County" = '' THEN
                    SalesInvoice."Bill-to County" := Cust.County;
                IF Salesinvoice."Bill-to Country/Region Code" = '' THEN
                    SalesInvoice."Bill-to Country/Region Code" := Cust."Country/Region Code";
                If SalesInvoice."Bill-to Address" = '' THEN
                    SalesInvoice."Bill-to Address" := Cust.Address;
                If SalesInvoice."Bill-to Address 2" = '' THEN
                    SalesInvoice."Bill-to Address 2" := Cust."Address 2";

                SalesInvoice."Sell-to Customer No." := SalesInvoice."Bill-to Customer No.";
                SalesInvoice."sell-to Address" := SalesInvoice."Bill-to Address";
                SalesInvoice."Sell-to Customer Name" := SalesInvoice."Bill-to Name";
                SalesInvoice."Sell-to Customer Name 2" := SalesInvoice."Bill-to Name 2";
                SalesInvoice."Sell-to Post Code" := SalesInvoice."Bill-to Post Code";
                SalesInvoice."Sell-to City" := SalesInvoice."Bill-to City";
                SalesInvoice."Sell-to County" := SalesInvoice."Bill-to County";
                SalesInvoice."Sell-to Country/Region Code" := SalesInvoice."Bill-to Country/Region Code";
                SalesInvoice."VAT Registration No." := Cust."VAT Registration No.";
                FormatAddr.SalesInvBillTo(CustAddr, SalesInvoice);
                IF NOT Cust.GET("Bill-to Customer No.") THEN
                    CLEAR(Cust);

                IF "Payment Terms Code" = '' THEN
                    PaymentTerms.INIT
                ELSE BEGIN
                    PaymentTerms.GET("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                END;

                IF "Payment Method Code" = '' THEN
                    PaymentMethod.INIT
                ELSE
                    PaymentMethod.GET("Payment Method Code");
                IF "Shipment Method Code" = '' THEN
                    ShipmentMethod.INIT
                ELSE BEGIN
                    ShipmentMethod.GET("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                END;
                FormatAddr.SalesInvShipTo(ShipToAddr, CustAddr, SalesInvoice);
                ShowShippingAddr := False;
                FOR i := 1 TO ARRAYLEN(ShipToAddr) DO
                    IF ShipToAddr[i] <> CustAddr[i] THEN
                        ShowShippingAddr := TRUE;


                AlbaranCompra.SetRange("Order No.", PurchaseHeader."No.");
                if AlbaranCompra.FindLast() then
                    NoAlbaran := AlbaranCompra."No.";

                // IF LogInteraction THEN
                //     IF NOT CurrReport.PREVIEW THEN BEGIN
                //         IF "Bill-to Contact No." <> '' THEN
                //             SegManagement.LogDocument(
                //                 4, "No.", 0, 0, DATABASE::Contact, "Bill-to Contact No.", "Salesperson Code",
                //                 "Campaign No.", "Posting Description", '')
                //         ELSE
                //             SegManagement.LogDocument(
                //                 4, "No.", 0, 0, DATABASE::Customer, "Bill-to Customer No.", "Salesperson Code",
                //                 "Campaign No.", "Posting Description", '');
                //     END;
            END;

        }

    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                Group(Opciones)
                {

                    field("Nº copias";
                    NoOfCopies)
                    {
                        ApplicationArea = All;
                    }

                    field("Mostrar información interna"; ShowInternalInfo) { ApplicationArea = All; }

                    field("Log interacción"; LogInteraction) { Enabled = LogInteractionEnable; ApplicationArea = All; }


                    field("Mostrar componentes del ensamblado"; DisplayAssemblyInformation) { ApplicationArea = All; }
                }
            }
        }
        trigger OnInit()
        BEGIN
            LogInteractionEnable := TRUE;
        END;

        trigger OnOpenPage()
        BEGIN
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        END;


    }

    VAR
        NoAlbaran: Code[20];
        AlbaranCompra: Record "Purch. Rcpt. Header";
        //= AlbaranCompra."No.";

        Text000: TextConst ENU = 'Salesperson', ESP = 'Vendedor';
        Text001: TextConst ENU = 'Total %1', ESP = 'Total %1';
        Text002: TextConst ENU = 'Total %1 Incl. VAT', ESP = 'Total %1 IVA incl.';
        Text003: TextConst ENU = 'COPY', ESP = 'COPIA';
        Text004: TextConst ENU = 'Invoice %1', ESP = 'FACTURA %1';
        Text005: TextConst ENU = 'Page %1', ESP = 'Pág. %1';
        Text006: TextConst ENU = 'Total %1 Excl. VAT', ESP = 'Total %1 IVA excl.';
        GLSetup: Record 98;
        ShipmentMethod: Record 10;
        PaymentTerms: Record 3;
        SalesPurchPerson: Record 13;
        CompanyInfo: Record 79;
        CompanyInfo1: Record 79;
        CompanyInfo2: Record 79;
        CompanyInfo3: Record 79;
        SalesSetup: Record 311;
        Cust: Record 18;
        VATAmountLine: Record 290 TEMPORARY;
        DimSetEntry1: Record 480;
        DimSetEntry2: Record 480;
        RespCenter: Record 5714;
        // Language: Codeunit Language;
        LanguageMgt: Codeunit Language;
        CurrExchRate: Record 330;
        TempPostedAsmLine: Record 911 TEMPORARY;
        SalesInvCountPrinted: Codeunit "Purch.Header-Printed";
        FormatAddr: Codeunit 365;
        SegManagement: Codeunit 5051;
        SalesShipmentBuffer: Record 7190 TEMPORARY;
        PostedShipmentDate: Date;
        CustAddr: ARRAY[8] OF Text[50];
        ShipToAddr: ARRAY[8] OF Text[50];
        CompanyAddr: ARRAY[8] OF Text[50];
        OrderNoText: Text[80];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        i: Integer;
        NextEntryNo: Integer;
        FirstValueEntryNo: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: TextConst ENU = '"VAT Amount Specification in "', ESP = '"Especificar importe IVA en "';
        Text008: TextConst ENU = 'Local Currency', ESP = 'Divisa local';
        VALExchRate: Text[50];
        Text009: TextConst ENU = 'Exchange rate: %1/%2', ESP = 'Tipo cambio: %1/%2';
        CalculatedExchRate: Decimal;
        Text010: TextConst ENU = 'Sales - Prepayment Invoice %1', ESP = 'Ventas - Factura prepago %1';
        OutputNo: Integer;
        TotalSubTotal: Decimal;
        TotalAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalAmountVAT: Decimal;
        TotalInvoiceDiscountAmount: Decimal;
        TotalPaymentDiscountOnVAT: Decimal;
        Text1100000: TextConst ENU = 'Total %1 Incl. VAT', ESP = 'Total %1 IVA incl.';
        Text1100001: TextConst ENU = 'Total %1 Excl. VAT', ESP = 'Total %1 IVA excl.';
        VATPostingSetup: Record 325;
        PaymentMethod: Record 289;
        TotalGivenAmount: Decimal;
        LogInteractionEnable: Boolean;// INDATASET;
        DisplayAssemblyInformation: Boolean;
        PhoneNoCaptionLbl: TextConst ENU = 'Phone No.', ESP = 'Nº teléfono';
        VATRegNoCaptionLbl: TextConst ENU = 'VAT Registration No.', ESP = 'CIF/NIF';
        GiroNoCaptionLbl: TextConst ENU = 'Giro No.', ESP = 'Nº giro postal';
        BankNameCaptionLbl: TextConst ENU = 'Bank', ESP = 'Banco';
        BankAccNoCaptionLbl: TextConst ENU = 'Account No.', ESP = 'Nº cuenta';
        DueDateCaptionLbl: TextConst ENU = 'Due Date', ESP = 'Fecha vencimiento';
        InvoiceNoCaptionLbl: TextConst ENU = 'Invoice No.', ESP = 'Nº factura';
        PostingDateCaptionLbl: TextConst ENU = 'Posting Date', ESP = 'Fecha registro';
        HdrDimsCaptionLbl: TextConst ENU = 'Header Dimensions', ESP = 'Dimensiones cabecera';
        PmtinvfromdebtpaidtoFactCompCaptionLbl: TextConst ENU = 'The payment of this invoice, in order to be released from the debt, has to be paid to the Factoring Company.', ESP = 'Para que se libere de la deuda, el pago de esta factura se debe realizar a la compa¤ía Factoring.';
        UnitPriceCaptionLbl: TextConst ENU = 'Unit Price', ESP = 'Precio venta';
        DiscountCaptionLbl: TextConst ENU = 'Discount %', ESP = '% Descuento';
        AmtCaptionLbl: TextConst ENU = 'Amount', ESP = 'Importe';
        PostedShpDateCaptionLbl: TextConst ENU = 'Posted Shipment Date', ESP = 'Fecha envío registrada';
        InvDiscAmtCaptionLbl: TextConst ENU = 'Invoice Discount Amount', ESP = 'Importe descuento factura';
        SubtotalCaptionLbl: TextConst ENU = 'Subtotal', ESP = 'Subtotal';
        PmtDiscGivenAmtCaptionLbl: TextConst ENU = 'Payment Disc Given Amount', ESP = 'Importe descuento pago';
        PmtDiscVATCaptionLbl: TextConst ENU = 'Payment Discount on VAT', ESP = 'Descuento P.P. sobre IVA';
        ShpCaptionLbl: TextConst ENU = 'Shipment', ESP = 'Envío';
        ShpCaptionLbl2: TextConst ENU = 'Shipment No.', ESP = 'No. Albarán';
        LineDimsCaptionLbl: TextConst ENU = 'Line Dimensions', ESP = 'Dimensiones línea';
        VATAmtLineVATCaptionLbl: TextConst ENU = 'VAT %', ESP = '% IVA';
        VATECBaseCaptionLbl: TextConst ENU = 'VAT Base', ESP = 'Base IVA';
        VATAmountCaptionLbl: TextConst ENU = 'VAT Amount', ESP = 'Importe IVA';
        VATAmtSpecCaptionLbl: TextConst ENU = 'VAT Amount Specification', ESP = 'Especificación importe IVA';
        VATIdentCaptionLbl: TextConst ENU = 'VAT Identifier', ESP = 'Identific. IVA';
        InvDiscBaseAmtCaptionLbl: TextConst ENU = 'Invoice Discount Base Amount', ESP = 'Importe base descuento factura';
        LineAmtCaption1Lbl: TextConst ENU = 'Line Amount', ESP = 'Importe línea';
        InvPmtDiscCaptionLbl: TextConst ENU = 'Invoice and Payment Discounts', ESP = 'Descuentos facturas y pagos';
        ECAmtCaptionLbl: TextConst ENU = 'EC Amount', ESP = 'Importe RE';
        ECCaptionLbl: TextConst ENU = 'EC %', ESP = '% RE';
        TotalCaptionLbl: TextConst ENU = 'Total', ESP = 'Total';
        VALVATBaseLCYCaption1Lbl: TextConst ENU = 'VAT Base', ESP = 'Base IVA';
        ShiptoAddressCaptionLbl: TextConst ENU = 'Ship-to Address', ESP = 'Envío a-Dirección';
        PmtTermsDescCaptionLbl: TextConst ENU = 'Payment Terms', ESP = 'Vencimiento';
        ShpMethodDescCaptionLbl: TextConst ENU = 'Shipment Method', ESP = 'Condiciones envío';
        PmtMethodDescCaptionLbl: TextConst ENU = 'Payment Method', ESP = 'Forma pago';
        DocDateCaptionLbl: TextConst ENU = 'Document Date', ESP = 'Fecha emisión documento';
        HomePageCaptionLbl: TextConst ENU = 'Home Page', ESP = 'Página Web';
        EmailCaptionLbl: TextConst ENU = 'E-Mail', ESP = 'Correo electrónico';
        NoDocExtLbl: TextConst ENU = 'External Reference', ESP = 'No. documento Externo';
        NoCtaAccLbl: TextConst ENU = 'Account  Number', ESP = 'No. Cuenta Banco';


    trigger OnInitReport()
    BEGIN
        GLSetup.GET;
        CompanyInfo.GET;
        SalesSetup.GET;

        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                BEGIN
                    CompanyInfo3.GET;
                    CompanyInfo3.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Center:
                BEGIN
                    CompanyInfo1.GET;
                    CompanyInfo1.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Right:
                BEGIN
                    CompanyInfo2.GET;
                    CompanyInfo2.CALCFIELDS(Picture);
                END;
        END;
    END;

    trigger OnPreReport()
    BEGIN
        IF NOT CurrReport.USEREQUESTPAGE THEN
            InitLogInteraction;
    END;

    PROCEDURE InitLogInteraction();
    BEGIN
        //  LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
        LogInteraction := SegManagement.FindInteractionTemplateCode(Enum::"Interaction Log Entry Document Type"::"Purch. Rcpt.") <> '';
    END;

    PROCEDURE FindPostedShipmentDate(): Date;
    VAR
        SalesShipmentHeader: Record 110;
        SalesShipmentBuffer2: Record 7190 TEMPORARY;
    BEGIN
        NextEntryNo := 1;
        EXIT(PurchaseHeader."Posting Date");


    END;

    PROCEDURE GenerateBufferFromValueEntry(SalesInvoiceLine2: Record 113);
    VAR
        ValueEntry: Record 5802;
        ItemLedgerEntry: Record 32;
        TotalQuantity: Decimal;
        Quantity: Decimal;
    BEGIN
        TotalQuantity := SalesInvoiceLine2."Quantity (Base)";
        ValueEntry.SETCURRENTKEY("Document No.");
        ValueEntry.SETRANGE("Document No.", SalesInvoiceLine2."Document No.");
        ValueEntry.SETRANGE("Posting Date", PurchaseHeader."Posting Date");
        ValueEntry.SETRANGE("Item Charge No.", '');
        ValueEntry.SETFILTER("Entry No.", '%1..', FirstValueEntryNo);
        IF ValueEntry.FIND('-') THEN
            REPEAT
                IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN BEGIN
                    IF SalesInvoiceLine2."Qty. per Unit of Measure" <> 0 THEN
                        Quantity := ValueEntry."Invoiced Quantity" / SalesInvoiceLine2."Qty. per Unit of Measure"
                    ELSE
                        Quantity := ValueEntry."Invoiced Quantity";
                    AddBufferEntry(
                      SalesInvoiceLine2,
                      -Quantity,
                      ItemLedgerEntry."Posting Date");
                    TotalQuantity := TotalQuantity + ValueEntry."Invoiced Quantity";
                END;
                FirstValueEntryNo := ValueEntry."Entry No." + 1;
            UNTIL (ValueEntry.NEXT = 0) OR (TotalQuantity = 0);
    END;

    PROCEDURE CorrectShipment(VAR SalesShipmentLine: Record 111);
    VAR
        SalesInvoiceLine: Record 113;
    BEGIN
        SalesInvoiceLine.SETCURRENTKEY("Shipment No.", "Shipment Line No.");
        SalesInvoiceLine.SETRANGE("Shipment No.", SalesShipmentLine."Document No.");
        SalesInvoiceLine.SETRANGE("Shipment Line No.", SalesShipmentLine."Line No.");
        IF SalesInvoiceLine.FIND('-') THEN
            REPEAT
                SalesShipmentLine.Quantity := SalesShipmentLine.Quantity - SalesInvoiceLine.Quantity;
            UNTIL SalesInvoiceLine.NEXT = 0;
    END;

    PROCEDURE AddBufferEntry(SalesInvoiceLine: Record 113; QtyOnShipment: Decimal; PostingDate: Date);
    BEGIN
        SalesShipmentBuffer.SETRANGE("Document No.", SalesInvoiceLine."Document No.");
        SalesShipmentBuffer.SETRANGE("Line No.", SalesInvoiceLine."Line No.");
        SalesShipmentBuffer.SETRANGE("Posting Date", PostingDate);
        IF SalesShipmentBuffer.FIND('-') THEN BEGIN
            SalesShipmentBuffer.Quantity := SalesShipmentBuffer.Quantity + QtyOnShipment;
            SalesShipmentBuffer.MODIFY;
            EXIT;
        END;

        WITH SalesShipmentBuffer DO BEGIN
            "Document No." := SalesInvoiceLine."Document No.";
            "Line No." := SalesInvoiceLine."Line No.";
            "Entry No." := NextEntryNo;
            Type := SalesInvoiceLine.Type;
            "No." := SalesInvoiceLine."No.";
            Quantity := QtyOnShipment;
            "Posting Date" := PostingDate;
            INSERT;
            NextEntryNo := NextEntryNo + 1
        END;
    END;

    LOCAL PROCEDURE DocumentCaption(): Text[250];
    BEGIN
        EXIT(Text004);
    END;

    PROCEDURE GetCarteraInvoice(): Boolean;
    VAR
        CustLedgEntry: Record 21;
    BEGIN
        WITH CustLedgEntry DO BEGIN
            SETCURRENTKEY("Document No.", "Document Type", "Customer No.");
            SETRANGE("Document Type", "Document Type"::Invoice);
            SETRANGE("Document No.", PurchaseHeader."No.");
            SETRANGE("Customer No.", PurchaseHeader."Bill-to Customer No.");
            SETRANGE("Posting Date", PurchaseHeader."Posting Date");
            IF FIND('-') THEN
                IF CustLedgEntry."Document Situation" = CustLedgEntry."Document Situation"::" " THEN
                    EXIT(FALSE)
                ELSE
                    EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END;
    END;

    PROCEDURE InitializeRequest(NewNoOfCopies: Integer; NewShowInternalInfo: Boolean; NewLogInteraction: Boolean; DisplayAsmInfo: Boolean);
    BEGIN
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        DisplayAssemblyInformation := DisplayAsmInfo;
    END;

    PROCEDURE CollectAsmInformation();
    VAR
        ValueEntry: Record 5802;
        ItemLedgerEntry: Record 32;
        PostedAsmHeader: Record 910;
        PostedAsmLine: Record 911;
        SalesShipmentLine: Record 111;
    BEGIN
        TempPostedAsmLine.DELETEALL;
        IF "Sales Invoice Line".Type <> "Sales Invoice Line".Type::Item THEN
            EXIT;
        WITH ValueEntry DO BEGIN
            SETCURRENTKEY("Document No.");
            SETRANGE("Document No.", "Sales Invoice Line"."Document No.");
            SETRANGE("Document Type", "Document Type"::"Sales Invoice");
            SETRANGE("Document Line No.", "Sales Invoice Line"."Line No.");
            IF NOT FINDSET THEN
                EXIT;
        END;
        REPEAT
            IF ItemLedgerEntry.GET(ValueEntry."Item Ledger Entry No.") THEN BEGIN
                IF ItemLedgerEntry."Document Type" = ItemLedgerEntry."Document Type"::"Sales Shipment" THEN BEGIN
                    SalesShipmentLine.GET(ItemLedgerEntry."Document No.", ItemLedgerEntry."Document Line No.");
                    IF SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) THEN BEGIN
                        PostedAsmLine.SETRANGE("Document No.", PostedAsmHeader."No.");
                        IF PostedAsmLine.FINDSET THEN
                            REPEAT
                                TreatAsmLineBuffer(PostedAsmLine);
                            UNTIL PostedAsmLine.NEXT = 0;
                    END;
                END;
            END;
        UNTIL ValueEntry.NEXT = 0;
    END;

    PROCEDURE TreatAsmLineBuffer(PostedAsmLine: Record 911);
    BEGIN
        CLEAR(TempPostedAsmLine);
        TempPostedAsmLine.SETRANGE(Type, PostedAsmLine.Type);
        TempPostedAsmLine.SETRANGE("No.", PostedAsmLine."No.");
        TempPostedAsmLine.SETRANGE("Variant Code", PostedAsmLine."Variant Code");
        TempPostedAsmLine.SETRANGE(Description, PostedAsmLine.Description);
        TempPostedAsmLine.SETRANGE("Unit of Measure Code", PostedAsmLine."Unit of Measure Code");
        IF TempPostedAsmLine.FINDFIRST THEN BEGIN
            TempPostedAsmLine.Quantity += PostedAsmLine.Quantity;
            TempPostedAsmLine.MODIFY;
        END ELSE BEGIN
            CLEAR(TempPostedAsmLine);
            TempPostedAsmLine := PostedAsmLine;
            TempPostedAsmLine.INSERT;
        END;
    END;

    PROCEDURE GetUOMText(UOMCode: Code[10]): Text[10];
    VAR
        UnitOfMeasure: Record 204;
    BEGIN
        IF NOT UnitOfMeasure.GET(UOMCode) THEN
            EXIT(UOMCode);
        EXIT(UnitOfMeasure.Description);
    END;

    PROCEDURE BlanksForIndent(): Text[10];
    BEGIN
        EXIT(PADSTR('', 2, ' '));
    END;

}

