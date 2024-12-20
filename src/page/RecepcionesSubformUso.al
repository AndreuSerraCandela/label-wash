
page 50147 "Subform Uso"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type" = filter(Order), Type = filter(Item));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;

                field("No."; Rec."No.")
                {
                    ApplicationArea = Suite;
                    ShowMandatory = not IsCommentLine;
                    ToolTip = 'Specifies what you are buying, such as a product or a fixed asset. You’ll see different lists of things to choose from depending on your choice in the Type field.';

                    trigger OnValidate()
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate();

                        UpdateTypeText();
                        DeltaUpdateTotals();

                        CurrPage.Update();
                    end;
                }
                field("Item Reference No."; Rec."Item Reference No.")
                {
                    AccessByPermission = tabledata "Item Reference" = R;
                    ApplicationArea = Suite, ItemReferences;
                    QuickEntry = false;
                    ToolTip = 'Specifies the referenced item number.';
                    Visible = ItemReferenceVisible;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemReferenceMgt: Codeunit "Item Reference Management";
                    begin
                        PurchaseHeader.Get(Rec."Document Type", Rec."Document No.");
                        ItemReferenceMgt.PurchaseReferenceNoLookUp(Rec, PurchaseHeader);
                        InsertExtendedText(false);
                        NoOnAfterValidate();
                        DeltaUpdateTotals();
                        CurrPage.Update();
                    end;

                    trigger OnValidate()
                    begin
                        InsertExtendedText(false);
                        NoOnAfterValidate();
                        DeltaUpdateTotals();
                        CurrPage.Update();
                    end;
                }

                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies the variant of the item on the line.';
                    ShowMandatory = VariantCodeMandatory;
                    Visible = false;

                    trigger OnValidate()
                    var
                        Item: Record "Item";
                    begin
                        DeltaUpdateTotals();
                        if Rec."Variant Code" = '' then
                            VariantCodeMandatory := Item.IsVariantMandatory(Rec.Type = Rec.Type::Item, Rec."No.");
                    end;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the vendor''s VAT specification to link transactions made for this vendor with the appropriate general ledger account according to the VAT posting setup.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Describes what is being purchased. The suggested text comes from the item itself. You can change it to suit your needs for this document. If you change it here, the source of the text will not change. If the line''s Type field is set to Comment, you can use this field to write the comment, and leave the other fields empty.';

                    trigger OnValidate()
                    begin
                        Rec.RestoreLookupSelection();

                        if Rec."No." = xRec."No." then
                            exit;

                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        NoOnAfterValidate();
                        DeltaUpdateTotals();
                    end;

                    trigger OnAfterLookup(Selected: RecordRef)
                    begin
                        Rec.SaveLookupSelection(Selected);
                    end;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies information in addition to the description.';
                    Visible = false;
                }
                field("From-Location Code"; Rec."From-Location Code")
                {
                    ApplicationArea = Location;
                    Editable = not IsBlankNumber;
                    Enabled = not IsBlankNumber;
                }

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    Editable = not IsBlankNumber;
                    Enabled = not IsBlankNumber;
                    ToolTip = 'Specifies a code for the location where you want the items to be placed when they are received.';

                    trigger OnValidate()
                    begin
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        DeltaUpdateTotals();
                    end;
                }

                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    Editable = not IsBlankNumber;
                    Enabled = not IsBlankNumber;
                    ShowMandatory = (Rec.Type <> Rec.Type::" ") and (Rec."No." <> '');
                    ToolTip = 'Specifies the quantity of what you''re buying. The number is based on the unit chosen in the Unit of Measure Code field.';

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                        SetItemChargeFieldsStyle();
                        if PurchasesPayablesSetup."Calc. Inv. Discount" and (Rec.Quantity = 0) then
                            CurrPage.Update(false);
                    end;
                }


                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the unit of measure.';
                    Visible = false;
                }
                field("Indirect Cost %"; Rec."Indirect Cost %")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
                    Visible = false;
                }
                field("Outstanding Quantity"; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many units on the order line have not yet been received.';
                    // Editable = true;
                }

                field("Qty. to Receive"; Rec."Qty. to Receive")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity of items that remains to be received.';
                }
                field("Quantity Received"; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how many units of the item on the line have been posted as received.';

                }

                field("Qty. Rcd. Not Invoiced"; Rec."Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Qty. Rcd. Not Invoiced field.', Comment = '%';

                }

                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';
                }


                field("Cantidad a Usar"; Rec."Cantidad a Tratar")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;


                    trigger OnValidate()
                    begin
                        SetItemChargeFieldsStyle();
                    end;
                }
                field("Cantidad Usada"; Rec."Cantidad Tratada")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies how many units of the item on the line have been posted as invoiced.';

                    // trigger OnDrillDown()
                    // var
                    //     PurchInvLine: Record "Purch. Inv. Line";
                    // begin
                    //     PurchInvLine.SetCurrentKey("Document No.", "No.", "Expected Receipt Date");
                    //     PurchInvLine.SetRange("Order No.", Rec."Document No.");
                    //     PurchInvLine.SetRange("Order Line No.", Rec."Line No.");
                    //     PurchInvLine.SetFilter(Quantity, '<>%1', 0);
                    //     PAGE.RunModal(0, PurchInvLine);
                    // end;
                }
                field("Cantidad a Merma"; Rec."Cantidad a Merma Uso")
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    ToolTip = 'Specifies the quantity of the item that is lost or wasted during the production process. The quantity is based on the unit chosen in the Unit of Measure Code field.';

                    trigger OnValidate()
                    begin
                        SetItemChargeFieldsStyle();
                    end;
                }
                field("Requested Receipt Date"; Rec."Requested Receipt Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested receipt date. If you do not need delivery on a specific date, you can leave the field blank.';
                    Visible = false;
                }
                field("Promised Receipt Date"; Rec."Promised Receipt Date")
                {
                    ApplicationArea = OrderPromising;
                    ToolTip = 'Specifies the date that the vendor has promised to deliver the order.';
                    Visible = true;
                }
                field("Planned Receipt Date"; Rec."Planned Receipt Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date when the item is planned to arrive in inventory. Forward calculation: planned receipt date = order date + vendor lead time (per the vendor calendar and rounded to the next working day in first the vendor calendar and then the location calendar). If no vendor calendar exists, then: planned receipt date = order date + vendor lead time (per the location calendar). Backward calculation: order date = planned receipt date - vendor lead time (per the vendor calendar and rounded to the previous working day in first the vendor calendar and then the location calendar). If no vendor calendar exists, then: order date = planned receipt date - vendor lead time (per the location calendar).';
                }
                field("Expected Receipt Date"; Rec."Expected Receipt Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date when the order was created.';
                    Visible = false;
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';
                    Visible = false;
                }
                field("Planning Flexibility"; Rec."Planning Flexibility")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies whether the supply represented by this line is considered by the planning system when calculating action messages.';
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible1;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible2;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = DimVisible3;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(3, ShortcutDimCode[3]);


                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = DimVisible4;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(4, ShortcutDimCode[4]);


                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = DimVisible5;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(5, ShortcutDimCode[5]);


                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = DimVisible6;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(6, ShortcutDimCode[6]);


                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = DimVisible7;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(7, ShortcutDimCode[7]);


                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = DimVisible8;

                    trigger OnValidate()
                    begin
                        Rec.ValidateShortcutDimCode(8, ShortcutDimCode[8]);


                    end;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the document number.';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of this line.';
                    Visible = false;
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    Caption = 'Unit Gross Weight';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the gross weight of one unit of the item. In the purchase statistics window, the gross weight on the line is included in the total gross weight of all the lines for the particular purchase document.';
                    Visible = false;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    Caption = 'Unit Net Weight';
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the net weight of one unit of the item. In the purchase statistics window, the net weight on the line is included in the total net weight of all the lines for the particular purchase document.';
                    Visible = false;
                }
                field("Unit Volume"; Rec."Unit Volume")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the volume of one unit of the item. In the purchase statistics window, the volume of one unit of the item on the line is included in the total volume of all the lines for the particular purchase document.';
                    Visible = false;
                }
                field("Units per Parcel"; Rec."Units per Parcel")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of units per parcel of the item. In the purchase statistics window, the number of units per parcel on the line helps to determine the total number of units for all the lines for the particular purchase document.';
                    Visible = false;
                }
                field("FA Posting Date"; Rec."FA Posting Date")
                {
                    ApplicationArea = FixedAssets;
                    ToolTip = 'Specifies the FA posting date if you have selected Fixed Asset in the Type field for this line.';
                    Visible = false;
                }
                field("Attached to Line No."; Rec."Attached to Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the line number to which this purchase line is attached.';
                    Visible = false;
                }
                field("Attached Lines Count"; Rec."Attached Lines Count")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of non-inventory product lines attached to the purchase line.';
                    Visible = AttachingLinesEnabled;
                }
            }
            // group(Control43)
            // {
            //     ShowCaption = false;
            //     group(Control37)
            //     {
            //         ShowCaption = false;
            //         field(AmountBeforeDiscount; TotalPurchaseLine."Line Amount")
            //         {
            //             ApplicationArea = Suite;
            //             AutoFormatExpression = Currency.Code;
            //             AutoFormatType = 1;
            //             CaptionClass = DocumentTotals.GetTotalLineAmountWithVATAndCurrencyCaption(Currency.Code, TotalPurchaseHeader."Prices Including VAT");
            //             Caption = 'Subtotal Excl. VAT';
            //             Editable = false;
            //             ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document.';

            //             trigger OnValidate()
            //             begin
            //                 DocumentTotals.PurchaseDocTotalsNotUpToDate();
            //             end;
            //         }
            //         field("Invoice Discount Amount"; InvoiceDiscountAmount)
            //         {
            //             ApplicationArea = Suite;
            //             AutoFormatExpression = Currency.Code;
            //             AutoFormatType = 1;
            //             CaptionClass = DocumentTotals.GetInvoiceDiscAmountWithVATAndCurrencyCaption(Rec.FieldCaption("Inv. Discount Amount"), Currency.Code);
            //             Caption = 'Invoice Discount Amount';
            //             Editable = InvDiscAmountEditable;
            //             ToolTip = 'Specifies a discount amount that is deducted from the value of the Total Incl. VAT field, based on purchase lines where the Allow Invoice Disc. field is selected. You can enter or change the amount manually.';

            //             trigger OnValidate()
            //             begin
            //                 ValidateInvoiceDiscountAmount();
            //                 DocumentTotals.PurchaseDocTotalsNotUpToDate();
            //             end;
            //         }
            //         field("Invoice Disc. Pct."; InvoiceDiscountPct)
            //         {
            //             ApplicationArea = Suite;
            //             Caption = 'Invoice Discount %';
            //             DecimalPlaces = 0 : 3;
            //             Editable = InvDiscAmountEditable;
            //             ToolTip = 'Specifies a discount percentage that is applied to the invoice, based on purchase lines where the Allow Invoice Disc. field is selected. The percentage and criteria are defined in the Vendor Invoice Discounts page, but you can enter or change the percentage manually.';

            //             trigger OnValidate()
            //             begin
            //                 AmountWithDiscountAllowed := DocumentTotals.CalcTotalPurchAmountOnlyDiscountAllowed(Rec);
            //                 InvoiceDiscountAmount := Round(AmountWithDiscountAllowed * InvoiceDiscountPct / 100, Currency."Amount Rounding Precision");
            //                 ValidateInvoiceDiscountAmount();
            //                 DocumentTotals.PurchaseDocTotalsNotUpToDate();
            //             end;
            //         }
            //     }
            //     group(Control19)
            //     {
            //         ShowCaption = false;
            //         field("Total Amount Excl. VAT"; TotalPurchaseLine.Amount)
            //         {
            //             ApplicationArea = Suite;
            //             AutoFormatExpression = Currency.Code;
            //             AutoFormatType = 1;
            //             CaptionClass = DocumentTotals.GetTotalExclVATCaption(Currency.Code);
            //             Caption = 'Total Amount Excl. VAT';
            //             DrillDown = false;
            //             Editable = false;
            //             ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
            //         }
            //         field("Total VAT Amount"; VATAmount)
            //         {
            //             ApplicationArea = Suite;
            //             AutoFormatExpression = Currency.Code;
            //             AutoFormatType = 1;
            //             CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
            //             Caption = 'Total VAT';
            //             Editable = false;
            //             ToolTip = 'Specifies the sum of VAT amounts on all lines in the document.';
            //         }
            //         field("Total Amount Incl. VAT"; TotalPurchaseLine."Amount Including VAT")
            //         {
            //             ApplicationArea = Suite;
            //             AutoFormatExpression = Currency.Code;
            //             AutoFormatType = 1;
            //             CaptionClass = DocumentTotals.GetTotalInclVATCaption(Currency.Code);
            //             Caption = 'Total Amount Incl. VAT';
            //             Editable = false;
            //             ToolTip = 'Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
            //         }
            //     }
            // }
        }
    }

    actions
    {
        area(processing)
        {
            action(SelectMultiItems)
            {
                AccessByPermission = TableData Item = R;
                ApplicationArea = Basic, Suite;
                Caption = 'Select items';
                Ellipsis = true;
                Image = NewItem;
                ToolTip = 'Add two or more items from the full list of your inventory items.';

                trigger OnAction()
                begin
                    Rec.SelectMultipleItems();
                end;
            }
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                // group("Item Availability by")
                // {
                //     Caption = 'Item Availability by';
                //     Image = ItemAvailability;
                //     Enabled = Rec.Type = Rec.Type::Item;
                //     action("Event")
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'Event';
                //         Image = "Event";
                //         ToolTip = 'View how the actual and the projected available balance of an item will develop over time according to supply and demand events.';

                //         trigger OnAction()
                //         begin
                //             ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByEvent())
                //         end;
                //     }
                //     action(Period)
                //     {
                //         ApplicationArea = Basic, Suite;
                //         Caption = 'Period';
                //         Image = Period;
                //         ToolTip = 'Show the projected quantity of the item over time according to time periods, such as day, week, or month.';

                //         trigger OnAction()
                //         begin
                //             ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByPeriod())
                //         end;
                //     }
                //     action(Variant)
                //     {
                //         ApplicationArea = Planning;
                //         Caption = 'Variant';
                //         Image = ItemVariant;
                //         ToolTip = 'View or edit the item''s variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.';

                //         trigger OnAction()
                //         begin
                //             ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByVariant())
                //         end;
                //     }
                //     action(Location)
                //     {
                //         AccessByPermission = TableData Location = R;
                //         ApplicationArea = Location;
                //         Caption = 'Location';
                //         Image = Warehouse;
                //         ToolTip = 'View the actual and projected quantity of the item per location.';

                //         trigger OnAction()
                //         begin
                //             ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByLocation())
                //         end;
                //     }
                //     action(Lot)
                //     {
                //         ApplicationArea = ItemTracking;
                //         Caption = 'Lot';
                //         Image = LotInfo;
                //         RunObject = Page "Item Availability by Lot No.";
                //         RunPageLink = "No." = field("No."),
                //             "Location Filter" = field("Location Code"),
                //             "Variant Filter" = field("Variant Code");
                //         ToolTip = 'View the current and projected quantity of the item in each lot.';
                //     }
                //     action("BOM Level")
                //     {
                //         AccessByPermission = TableData "BOM Buffer" = R;
                //         ApplicationArea = Assembly;
                //         Caption = 'BOM Level';
                //         Image = BOMLevel;
                //         ToolTip = 'View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.';

                //         trigger OnAction()
                //         begin
                //             ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec, ItemAvailFormsMgt.ByBOM())
                //         end;
                //     }
                // }
                // action("Reservation Entries")
                // {
                //     AccessByPermission = TableData Item = R;
                //     ApplicationArea = Reservation;
                //     Caption = 'Reservation Entries';
                //     Image = ReservationLedger;
                //     Enabled = Rec.Type = Rec.Type::Item;
                //     ToolTip = 'View all reservation entries for the selected item. This action is available only for lines that contain an item.';

                //     trigger OnAction()
                //     begin
                //         Rec.ShowReservationEntries(true);
                //     end;
                // }
                // action("Item Tracking Lines")
                // {
                //     ApplicationArea = ItemTracking;
                //     Caption = 'Item &Tracking Lines';
                //     Image = ItemTrackingLines;
                //     ShortCutKey = 'Ctrl+Alt+I';
                //     Enabled = Rec.Type = Rec.Type::Item;
                //     ToolTip = 'View or edit serial and lot numbers for the selected item. This action is available only for lines that contain an item.';

                //     trigger OnAction()
                //     begin
                //         Rec.OpenItemTrackingLines();
                //     end;
                // }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.';

                    trigger OnAction()
                    begin
                        Rec.ShowLineComments();
                    end;
                }
                // action(ItemChargeAssignment)
                // {
                //     AccessByPermission = TableData "Item Charge" = R;
                //     ApplicationArea = ItemCharges;
                //     Caption = 'Item Charge &Assignment';
                //     Image = ItemCosts;
                //     Enabled = Rec.Type = Rec.Type::"Charge (Item)";
                //     ToolTip = 'Record additional direct costs, for example for freight. This action is available only for Charge (Item) line types.';

                //     trigger OnAction()
                //     begin
                //         Rec.ShowItemChargeAssgnt();
                //         SetItemChargeFieldsStyle();
                //     end;
                // }
                //                 action(DocumentLineTracking)
                //                 {
                //                     ApplicationArea = Basic, Suite;
                //                     Caption = 'Document &Line Tracking';
                //                     ToolTip = 'View related open, posted, or archived documents or document lines.';

                //                     trigger OnAction()
                //                     begin
                //                         ShowDocumentLineTracking();
                //                     end;
                //                 }
                //                 action(DeferralSchedule)
                //                 {
                //                     ApplicationArea = Suite;
                //                     Caption = 'Deferral Schedule';
                //                     Enabled = Rec."Deferral Code" <> '';
                //                     Image = PaymentPeriod;
                //                     ToolTip = 'View or edit the deferral schedule that governs how revenue made with this purchase document is deferred to different accounting periods when the document is posted.';

                //                     trigger OnAction()
                //                     begin
                //                         Rec.ShowDeferralSchedule();
                //                     end;
                //                 }
                //                 action(RedistributeAccAllocations)
                //                 {
                //                     ApplicationArea = All;
                //                     Caption = 'Redistribute Account Allocations';
                //                     Image = EditList;
                // #pragma warning disable AA0219
                //                     ToolTip = 'Use this action to redistribute the account allocations for this line.';
                // #pragma warning restore AA0219

                //                     trigger OnAction()
                //                     var
                //                         AllocAccManualOverride: Page "Redistribute Acc. Allocations";
                //                     begin
                //                         if ((Rec."Type" <> Rec."Type"::"Allocation Account") and (Rec."Selected Alloc. Account No." = '')) then
                //                             Error(ActionOnlyAllowedForAllocationAccountsErr);

                //                         AllocAccManualOverride.SetParentSystemId(Rec.SystemId);
                //                         AllocAccManualOverride.SetParentTableId(Database::"Purchase Line");
                //                         AllocAccManualOverride.RunModal();
                //                     end;
                //                 }
                //                 action(ReplaceAllocationAccountWithLines)
                //                 {
                //                     ApplicationArea = All;
                //                     Caption = 'Generate lines from Allocation Account Line';
                //                     Image = CreateLinesFromJob;
                // #pragma warning disable AA0219
                //                     ToolTip = 'Use this action to replace the Allocation Account line with the actual lines that would be generated from the line itself.';
                // #pragma warning restore AA0219

                //                     trigger OnAction()
                //                     var
                //                         PurchaseAllocAccMgt: Codeunit "Purchase Alloc. Acc. Mgt.";
                //                     begin
                //                         if ((Rec."Type" <> Rec."Type"::"Allocation Account") and (Rec."Selected Alloc. Account No." = '')) then
                //                             Error(ActionOnlyAllowedForAllocationAccountsErr);

                //                         PurchaseAllocAccMgt.CreateLinesFromAllocationAccountLine(Rec);
                //                         Rec.Delete();
                //                         CurrPage.Update(false);
                //                     end;
                //                 }
                action(DocAttach)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctiones';
                Image = "Action";
                // action("E&xplode BOM")
                // {
                //     AccessByPermission = TableData "BOM Component" = R;
                //     ApplicationArea = Suite;
                //     Caption = 'E&xplode BOM';
                //     Image = ExplodeBOM;
                //     Enabled = Rec.Type = Rec.Type::Item;
                //     ToolTip = 'Add a line for each component on the bill of materials for the selected item. For example, this is useful for selling the parent item as a kit. CAUTION: The line for the parent item will be deleted and only its description will display. To undo this action, delete the component lines and add a line for the parent item again. This action is available only for lines that contain an item.';

                //     trigger OnAction()
                //     begin
                //         ExplodeBOM();
                //     end;
                // }
                action("Insert Ext. Texts")
                {
                    AccessByPermission = TableData "Extended Text Header" = R;
                    ApplicationArea = Suite;
                    Caption = 'Insertar &Texts Adicionales';
                    Image = Text;
                    ToolTip = 'Insert the extended item description that is set up for the item that is being processed on the line.';

                    trigger OnAction()
                    begin
                        InsertExtendedText(true);
                    end;
                }
                // action("Attach to Inventory Item Line")
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Attach to inventory item line';
                //     Image = Allocations;
                //     Visible = AttachingLinesEnabled;
                //     Enabled = AttachToInvtItemEnabled;
                //     ToolTip = 'Attach the selected non-inventory product lines to a inventory item line in this purchase order.';

                //     trigger OnAction()
                //     var
                //         SelectedPurchLine: Record "Purchase Line";
                //     begin
                //         CurrPage.SetSelectionFilter(SelectedPurchLine);
                //         Rec.AttachToInventoryItemLine(SelectedPurchLine);
                //     end;
                // }
                // action(Reserve)
                // {
                //     ApplicationArea = Reservation;
                //     Caption = '&Reserve';
                //     Ellipsis = true;
                //     Image = Reserve;
                //     Enabled = Rec.Type = Rec.Type::Item;
                //     ToolTip = 'Reserve the quantity of the selected item that is required on the document line from which you opened this page. This action is available only for lines that contain an item.';

                //     trigger OnAction()
                //     begin
                //         Rec.Find();
                //         Rec.ShowReservation();
                //     end;
                // }
                // action(OrderTracking)
                // {
                //     ApplicationArea = Suite;
                //     Caption = 'Order &Tracking';
                //     Image = OrderTracking;
                //     Enabled = Rec.Type = Rec.Type::Item;
                //     ToolTip = 'Track the connection of a supply to its corresponding demand for the selected item. This can help you find the original demand that created a specific production order or purchase order. This action is available only for lines that contain an item.';

                //     trigger OnAction()
                //     begin
                //         ShowTracking();
                //     end;
                // }
            }
            // group("O&rder")
            // {
            //     Caption = 'Re&cepción';
            //     Image = "Order";
            //     // group("Dr&op Shipment")
            //     // {
            //     //     Caption = 'Dr&op Shipment';
            //     //     Image = Delivery;
            //     //     action("Sales &Order")
            //     //     {
            //     //         AccessByPermission = TableData "Sales Shipment Header" = R;
            //     //         ApplicationArea = Suite;
            //     //         Caption = 'Sales &Order';
            //     //         Image = Document;
            //     //         ToolTip = 'View the sales order that is the source of the line. This applies only to drop shipments and special orders.';

            //     //         trigger OnAction()
            //     //         begin
            //     //             OpenSalesOrderForm();
            //     //         end;
            //     //     }
            //     // }
            //     // group("Speci&al Order")
            //     // {
            //     //     Caption = 'Speci&al Order';
            //     //     Image = SpecialOrder;
            //     //     action(Action1901038504)
            //     //     {
            //     //         AccessByPermission = TableData "Sales Shipment Header" = R;
            //     //         ApplicationArea = Suite;
            //     //         Caption = 'Sales &Order';
            //     //         Image = Document;
            //     //         ToolTip = 'View the sales order that is the source of the line. This applies only to drop shipments and special orders.';

            //     //         trigger OnAction()
            //     //         begin
            //     //             OpenSpecOrderSalesOrderForm();
            //     //         end;
            //     //     }
            //     // }
            //     // action(BlanketOrder)
            //     // {
            //     //     ApplicationArea = Suite;
            //     //     Caption = 'Blanket Order';
            //     //     Image = BlanketOrder;
            //     //     ToolTip = 'View the blanket purchase order.';

            //     //     trigger OnAction()
            //     //     var
            //     //         PurchaseHeader: Record "Purchase Header";
            //     //         BlanketPurchaseOrder: Page "Blanket Purchase Order";
            //     //     begin
            //     //         Rec.TestField("Blanket Order No.");
            //     //         PurchaseHeader.SetRange("No.", Rec."Blanket Order No.");
            //     //         if not PurchaseHeader.IsEmpty() then begin
            //     //             BlanketPurchaseOrder.SetTableView(PurchaseHeader);
            //     //             BlanketPurchaseOrder.Editable := false;
            //     //             BlanketPurchaseOrder.Run();
            //     //         end;
            //     //     end;
            //     // }
            // }
            // group(Errors)
            // {
            //     Caption = 'Issues';
            //     Image = ErrorLog;
            //     Visible = BackgroundErrorCheck;
            //     ShowAs = SplitButton;

            //     action(ShowLinesWithErrors)
            //     {
            //         ApplicationArea = Basic, Suite;
            //         Caption = 'Show Lines with Issues';
            //         Image = Error;
            //         Visible = BackgroundErrorCheck;
            //         Enabled = not ShowAllLinesEnabled;
            //         ToolTip = 'View a list of purchase lines that have issues before you post the document.';

            //         trigger OnAction()
            //         begin
            //             Rec.SwitchLinesWithErrorsFilter(ShowAllLinesEnabled);
            //         end;
            //     }
            //     action(ShowAllLines)
            //     {
            //         ApplicationArea = Basic, Suite;
            //         Caption = 'Show All Lines';
            //         Image = ExpandAll;
            //         Visible = BackgroundErrorCheck;
            //         Enabled = ShowAllLinesEnabled;
            //         ToolTip = 'View all purchase lines, including lines with and without issues.';

            //         trigger OnAction()
            //         begin
            //             Rec.SwitchLinesWithErrorsFilter(ShowAllLinesEnabled);
            //         end;
            //     }
            // }
            group("Page")
            {
                Caption = 'Página';

                action(EditInExcel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Editar en Excel';
                    Image = Excel;
                    Visible = IsSaaSExcelAddinEnabled;
                    ToolTip = 'Send the data in the sub page to an Excel file for analysis or editing';
                    AccessByPermission = System "Allow Action Export To Excel" = X;

                    trigger OnAction()
                    var
                        EditinExcel: Codeunit "Edit in Excel";
                        EditinExcelFilters: Codeunit "Edit in Excel Filters";
                    begin
                        EditinExcelFilters.AddField('Document_No', Enum::"Edit in Excel Filter Type"::Equal, Rec."Document No.", Enum::"Edit in Excel Edm Type"::"Edm.String");

                        EditinExcel.EditPageInExcel(
                            'Purchase_Order_Line',
                            Page::"Purchase Order Subform",
                            EditinExcelFilters,
                            StrSubstNo(ExcelFileNameTxt, Rec."Document No."));
                    end;

                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        GetTotalsPurchaseHeader();
        CalculateTotals();
        UpdateEditableOnRow();
        UpdateTypeText();
        SetItemChargeFieldsStyle();
    end;

    trigger OnAfterGetRecord()
    var
        Item: Record "Item";
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        UpdateTypeText();
        SetItemChargeFieldsStyle();
        if Rec."Variant Code" = '' then
            VariantCodeMandatory := Item.IsVariantMandatory(Rec.Type = Rec.Type::Item, Rec."No.");
    end;

    trigger OnDeleteRecord(): Boolean
    var
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        IsHandled: Boolean;
        Result: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit(Result);

        if (Rec.Quantity <> 0) and Rec.ItemExists(Rec."No.") then begin
            Commit();
            if not PurchLineReserve.DeleteLineConfirm(Rec) then
                exit(false);
            PurchLineReserve.DeleteLine(Rec);
        end;
        DocumentTotals.PurchaseDocTotalsNotUpToDate();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        DocumentTotals.PurchaseCheckAndClearTotals(Rec, xRec, TotalPurchaseLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        exit(Rec.Find(Which));
    end;

    trigger OnInit()
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
    begin
        PurchasesPayablesSetup.Get();
        InventorySetup.Get();
        TempOptionLookupBuffer.FillLookupBuffer(TempOptionLookupBuffer."Lookup Type"::Purchases);
        IsFoundation := ApplicationAreaMgmtFacade.IsFoundationEnabled();
        Currency.InitRoundingPrecision();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        DocumentTotals.PurchaseCheckIfDocumentChanged(Rec, xRec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.InitType();
        SetDefaultType();

        Clear(ShortcutDimCode);
        UpdateTypeText();
    end;

    trigger OnOpenPage()
    var
        AllocationAccountMgt: Codeunit "Allocation Account Mgt.";
    begin
        UseAllocationAccountNumber := AllocationAccountMgt.UseAllocationAccountNoField();
        SetOpenPage();

        SetDimensionsVisibility();
        SetOverReceiptControlsVisibility();
        SetItemReferenceVisibility();
    end;

    var
        PurchaseHeader: Record "Purchase Header";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        InventorySetup: Record "Inventory Setup";
        TempOptionLookupBuffer: Record "Option Lookup Buffer" temporary;
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the purchase order has been invoiced.';
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        DocumentTotals: Codeunit "Document Totals";
        AmountWithDiscountAllowed: Decimal;
        TypeAsText: Text[30];
        ItemChargeStyleExpression: Text;
        ItemChargeToHandleStyleExpression: Text;
        VariantCodeMandatory: Boolean;
        BackgroundErrorCheck: Boolean;
        ShowAllLinesEnabled: Boolean;
        IsFoundation: Boolean;
        IsSaaSExcelAddinEnabled: Boolean;
        AttachingLinesEnabled: Boolean;
        ShowNonDedVATInLines: Boolean;
        UpdateInvDiscountQst: Label 'One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?';
        CurrPageIsEditable: Boolean;
        SuppressTotals: Boolean;
        UseAllocationAccountNumber: Boolean;
        ActionOnlyAllowedForAllocationAccountsErr: Label 'This action is only available for lines that have Allocation Account set as Type.';
        ExcelFileNameTxt: Label 'Purchase Order %1 - Lines', Comment = '%1 = document number, ex. 10000';

    protected var
        Currency: Record Currency;
        TotalPurchaseHeader: Record "Purchase Header";
        TotalPurchaseLine: Record "Purchase Line";
        ShortcutDimCode: array[8] of Code[20];
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        VATAmount: Decimal;
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;
        IsBlankNumber: Boolean;
        IsCommentLine: Boolean;
        OverReceiptAllowed: Boolean;
        ItemReferenceVisible: Boolean;
        AttachToInvtItemEnabled: Boolean;
        InvDiscAmountEditable: Boolean;

    local procedure SetOpenPage()
    var
        ServerSetting: Codeunit "Server Setting";
        DocumentErrorsMgt: Codeunit "Document Errors Mgt.";
        NonDeductibleVAT: Codeunit "Non-Deductible VAT";
    begin

        IsSaaSExcelAddinEnabled := ServerSetting.GetIsSaasExcelAddinEnabled();
        SuppressTotals := CurrentClientType() = ClientType::ODataV4;
        BackgroundErrorCheck := DocumentErrorsMgt.BackgroundValidationEnabled();
        AttachingLinesEnabled :=
            PurchasesPayablesSetup."Auto Post Non-Invt. via Whse." = PurchasesPayablesSetup."Auto Post Non-Invt. via Whse."::"Attached/Assigned";
        ShowNonDedVATInLines := NonDeductibleVAT.ShowNonDeductibleVATInLines();
    end;

    procedure ApproveCalcInvDisc()
    begin
        CODEUNIT.Run(CODEUNIT::"Purch.-Disc. (Yes/No)", Rec);
        DocumentTotals.PurchaseDocTotalsNotUpToDate();
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if SuppressTotals then
            exit;

        PurchaseHeader.Get(Rec."Document Type", Rec."Document No.");
        if PurchaseHeader.InvoicedLineExists() then
            if not ConfirmManagement.GetResponseOrDefault(UpdateInvDiscountQst, true) then
                exit;

        DocumentTotals.PurchaseDocTotalsNotUpToDate();
        PurchCalcDiscByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, PurchaseHeader);
        CurrPage.Update(false);
    end;

    local procedure ExplodeBOM()
    begin
        if Rec."Prepmt. Amt. Inv." <> 0 then
            Error(Text001);
        CODEUNIT.Run(CODEUNIT::"Purch.-Explode BOM", Rec);
        DocumentTotals.PurchaseDocTotalsNotUpToDate();
    end;

    local procedure OpenSalesOrderForm()
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        Rec.TestField("Sales Order No.");
        SalesHeader.SetRange("No.", Rec."Sales Order No.");
        SalesOrder.SetTableView(SalesHeader);
        SalesOrder.Editable := false;
        SalesOrder.Run();
    end;

    procedure InsertExtendedText(Unconditionally: Boolean)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        if TransferExtendedText.PurchCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SaveRecord();
            TransferExtendedText.InsertPurchExtText(Rec);
        end;
        if TransferExtendedText.MakeUpdate() then
            UpdateForm(true);
    end;

    procedure ShowTracking()
    var
        TrackingForm: Page "Order Tracking";
    begin
        TrackingForm.SetPurchLine(Rec);
        TrackingForm.RunModal();
    end;

    protected procedure OpenSpecOrderSalesOrderForm()
    var
        SalesHeader: Record "Sales Header";
        SalesOrder: Page "Sales Order";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        if IsHandled then
            exit;

        Rec.TestField("Special Order Sales No.");
        SalesHeader.SetRange("No.", Rec."Special Order Sales No.");
        SalesOrder.SetTableView(SalesHeader);
        SalesOrder.Editable := false;
        SalesOrder.Run();
    end;

    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    procedure NoOnAfterValidate()
    begin
        UpdateEditableOnRow();
        InsertExtendedText(false);
        if (Rec.Type = Rec.Type::"Charge (Item)") and (Rec."No." <> xRec."No.") and
           (xRec."No." <> '')
        then
            CurrPage.SaveRecord();


    end;

    procedure ShowDocumentLineTracking()
    var
        DocumentLineTrackingPage: Page "Document Line Tracking";
    begin
        Clear(DocumentLineTrackingPage);
        DocumentLineTrackingPage.SetSourceDoc(
            "Document Line Source Type"::"Purchase Order", Rec."Document No.", Rec."Line No.", Rec."Blanket Order No.", Rec."Blanket Order Line No.", '', 0);
        DocumentLineTrackingPage.RunModal();
    end;

    procedure RedistributeTotalsOnAfterValidate()
    begin
        if SuppressTotals then
            exit;

        CurrPage.SaveRecord();

        DocumentTotals.PurchaseRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalPurchaseLine);
        CurrPage.Update(false);
    end;

    local procedure GetTotalsPurchaseHeader()
    begin
        DocumentTotals.GetTotalPurchaseHeaderAndCurrency(Rec, TotalPurchaseHeader, Currency);
    end;

    procedure ClearTotalPurchaseHeader();
    begin
        Clear(TotalPurchaseHeader);
    end;

    procedure CalculateTotals()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        if SuppressTotals then
            exit;

        DocumentTotals.PurchaseCheckIfDocumentChanged(Rec, xRec);
        DocumentTotals.CalculatePurchaseSubPageTotals(
          TotalPurchaseHeader, TotalPurchaseLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        DocumentTotals.RefreshPurchaseLine(Rec);
    end;

    procedure DeltaUpdateTotals()
    begin
        if SuppressTotals then
            exit;


        DocumentTotals.PurchaseDeltaUpdateTotals(Rec, xRec, TotalPurchaseLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        CheckSendLineInvoiceDiscountResetNotification();
    end;

    procedure ForceTotalsCalculation()
    begin
        DocumentTotals.PurchaseDocTotalsNotUpToDate();
    end;

    local procedure CheckSendLineInvoiceDiscountResetNotification()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        if Rec."Line Amount" <> xRec."Line Amount" then
            Rec.SendLineInvoiceDiscountResetNotification();
    end;

    procedure UpdateEditableOnRow()
    begin
        IsCommentLine := Rec.Type = Rec.Type::" ";
        IsBlankNumber := IsCommentLine;
        if AttachingLinesEnabled then
            AttachToInvtItemEnabled := not Rec.IsInventoriableItem();

        CurrPageIsEditable := CurrPage.Editable;
        InvDiscAmountEditable :=
            CurrPageIsEditable and not PurchasesPayablesSetup."Calc. Inv. Discount" and
            (TotalPurchaseHeader.Status = TotalPurchaseHeader.Status::Open);


    end;

    procedure UpdateTypeText()
    var
        RecRef: RecordRef;
    begin
        if not IsFoundation then
            exit;



        RecRef.GetTable(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.Field(Rec.FieldNo(Type)));
    end;

    local procedure SetItemChargeFieldsStyle()
    begin
        ItemChargeStyleExpression := '';
        ItemChargeToHandleStyleExpression := '';
        if Rec.AssignedItemCharge() then begin
            if Rec."Qty. To Assign" <> (Rec.Quantity - Rec."Qty. Assigned") then
                ItemChargeStyleExpression := 'Unfavorable';
            if Rec."Item Charge Qty. to Handle" <> Rec."Qty. to Invoice" then
                ItemChargeToHandleStyleExpression := 'Unfavorable';
        end;
    end;

    local procedure SetItemReferenceVisibility()
    var
        ItemReference: Record "Item Reference";
    begin
        ItemReferenceVisible := not ItemReference.IsEmpty();
    end;

    local procedure SetDimensionsVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimMgt.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimMgt);


    end;

    local procedure SetDefaultType()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;

        if IsHandled then
            exit;

        if xRec."Document No." = '' then
            Rec.Type := Rec.Type::Item;
    end;

    local procedure SetOverReceiptControlsVisibility()
    var
        OverReceiptMgt: Codeunit "Over-Receipt Mgt.";
    begin
        OverReceiptAllowed := OverReceiptMgt.IsOverReceiptAllowed();
    end;


}

