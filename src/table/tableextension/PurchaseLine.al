tableextension 50105 PurchaseLineExtension extends "Purchase Line"
{
    fields
    {
        field(50200; "Cantidad a Tratar"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                ItemEntry: Record "Item Ledger Entry";
                PurchaseHeader: Record "Purchase Header";
            begin
                If Not PurchaseHeader.Get("Document Type", "Document No.") then
                    PurchaseHeader.Init();
                VereificarCantidad("No.", "Cantidad a Tratar", "From-Location Code", "Location Code");
                Validate("Qty. to Receive", "Cantidad a Tratar" + "Cantidad a Merma");
                "Cantidad a Tratar Base" := CalcBaseQty("Cantidad a Tratar", FieldCaption("Cantidad a Tratar"), FieldCaption("Cantidad a Tratar Base"));
                "Cantidad a facturar Tratada" := "Cantidad a Tratar" + "Cantidad a Merma";
            end;

        }
        field(50225; "Cantidad a facturada Tratada"; Decimal)
        {
            DataClassification = CustomerContent;



        }
        field(50226; "Cantidad a facturada Uso"; Decimal)
        {
            DataClassification = CustomerContent;



        }
        field(50227; "Cantidad a facturar Tratada"; Decimal)
        {
            DataClassification = CustomerContent;



        }
        field(50228; "Cantidad a facturar Uso"; Decimal)
        {
            DataClassification = CustomerContent;



        }

        field(50199; "From-Location Code"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = "Location";
            Caption = 'Almacen origen';
        }
        field(50208; "Cantidad a uso Base"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50209; "Cantidad a Uso"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                VereificarCantidad("No.", "Cantidad a Uso", "From-Location Code", "Location Code");
                "Cantidad a uso Base" := CalcBaseQty("Cantidad a Uso", FieldCaption("Cantidad a Uso"), FieldCaption("Cantidad a Uso Base"));
                "Cantidad a facturar Uso" := "Cantidad a Uso";
            end;

        }
        field(50215; "Cantidad a Merma Uso"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Cantidad a Uso", Quantity - "Cantidad Usada" - "Cantidad a Merma Uso");
                "Cant. a Merma Base Uso" := CalcBaseQty("Cantidad a Merma Uso", FieldCaption("Cantidad a Merma Uso"), FieldCaption("Cant. a Merma Base Uso"));

            end;

        }
        field(50216; "Cant. a Merma Base Uso"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50201; "Cantidad a Tratar Base"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50205; "Cantidad a Merma"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Cantidad a Tratar", Quantity - "Cantidad Tratada" - "Cantidad a Merma");
                "Cantidad a Merma Base" := CalcBaseQty("Cantidad a Merma", FieldCaption("Cantidad a Merma"), FieldCaption("Cantidad a Merma Base"));
                "Cantidad a facturar Tratada" := "Cantidad a Tratar" + "Cantidad a Merma";

            end;

        }
        field(50206; "Cantidad a Merma Base"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(50202; "Cantidad Tratada"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Cantidad Tratada Base" := CalcBaseQty("Cantidad Tratada", FieldCaption("Cantidad Tratada"), FieldCaption("Cantidad Tratada Base"));
            end;
        }
        field(50210; "Cantidad Usada Base"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50211; "Cantidad Usada"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Cantidad Usada Base" := CalcBaseQty("Cantidad Usada", FieldCaption("Cantidad Usada"), FieldCaption("Cantidad Usada Base"));
            end;
        }
        field(50203; "Cantidad Tratada Base"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50204; "Precio X Producto"; DECIMAL)
        {
            DataClassification = CustomerContent;
            DecimalPlaces = 3 : 3;
            trigger OnValidate()
            begin
                validate("Direct unit cost", "Precio X Producto");

            end;
        }
        field(50207; "Precio Tratamiento"; DECIMAL)
        {
            DecimalPlaces = 3 : 3;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                validate("Direct unit cost", "Precio X Producto");

            end;

        }
        modify("Qty. to Receive")
        {
            trigger OnAfterValidate()
            var
                PurchaseHeader: Record "Purchase Header";
            begin
                if PurchaseHeader.Get("Document Type", "Document No.") then begin
                    If PurchaseHeader.Recepcion = Recepcion::Tratamiento then begin
                        "Cantidad a Tratar" := "Qty. to Receive" - "Cantidad a Merma";
                        "Cantidad a Tratar Base" := CalcBaseQty("Cantidad a Tratar", FieldCaption("Cantidad a Tratar"), FieldCaption("Cantidad a Tratar Base"));

                    end;
                    If PurchaseHeader.Recepcion = Recepcion::Uso then begin
                        "Cantidad a Uso" := "Qty. to Receive";
                        "Cantidad a uso Base" := CalcBaseQty("Qty. to Receive", FieldCaption("Qty. to Receive"), FieldCaption("Cantidad a uso Base"));
                    end;
                    if PurchaseHeader.Recepcion <> Recepcion::" " Then begin
                        GetPriceCalculationHandler(PriceType::Sale, PurchaseHeader, PriceCalculation);
                        PriceCalculation.ApplyDiscount();
                        ApplyPrice(FieldNo(Quantity), PriceCalculation);

                    end;
                end;
            end;
        }
        modify("quantity")
        {
            trigger OnAfterValidate()
            var
                PurchaseHeader: Record "Purchase Header";
            begin
                if PurchaseHeader.Get("Document Type", "Document No.") then begin
                    if PurchaseHeader.Recepcion <> Recepcion::" " Then begin
                        GetPriceCalculationHandler(PriceType::Sale, PurchaseHeader, PriceCalculation);
                        PriceCalculation.ApplyDiscount();
                        ApplyPrice(FieldNo(Quantity), PriceCalculation);
                        Validate("Precio X Producto");
                    end;
                end;
                if PurchaseHeader.Recepcion = Recepcion::Tratamiento then begin
                    VereificarCantidad("No.", Quantity, "From-Location Code", "Location Code");
                end;
                if PurchaseHeader.Recepcion = Recepcion::Uso then begin
                    VereificarCantidad("No.", Quantity, "from-Location Code", "Location Code");
                end;
            end;
        }
        field(50212; "No Avisar"; Boolean)
        {
            ObsoleteReason = 'No se usa';
            ObsoleteState = Removed;
            DataClassification = CustomerContent;
        }

    }
    var
        PriceCalculation: Interface "Price Calculation";
        PriceType: Enum "Price Type";
        SalesHeader: Record "Sales Header";
        "From-LocationCode": Code[10];
        SalesLine: Record "Sales Line";

    procedure GetPriceCalculationHandler(PriceType: Enum "Price Type"; PurchHeader: Record "Purchase Header"; var PriceCalculation: Interface "Price Calculation")
    var
        PriceCalculationMgt: codeunit "Price Calculation Mgt.";
        LineWithPrice: Interface "Line With Price";

    begin
        SalesHeader."No." := PurchHeader."No.";
        SalesHeader."Document Type" := PurchHeader."Document Type";
        SalesHeader."Bill-to Customer No." := PurchHeader."Bill-to Customer No.";
        SalesHeader."Order Date" := PurchHeader."Order Date";
        If SalesHeader.Insert() Then;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := Rec."Line No.";
        SalesLine."Type" := Rec.Type;
        SalesLine."No." := Rec."No.";
        SalesLine."Variant Code" := Rec."Variant Code";
        SalesLine."Unit of Measure Code" := Rec."Unit of Measure Code";
        SalesLine."Qty. per Unit of Measure" := Rec."Qty. per Unit of Measure";
        SalesLine."Qty. Rounding Precision" := Rec."Qty. Rounding Precision";
        SalesLine."Qty. Rounding Precision (Base)" := Rec."Qty. Rounding Precision (Base)";
        SalesLine.Quantity := Rec.Quantity;
        SalesLine."Quantity (Base)" := Rec."Quantity (Base)";
        SalesLine."Sell-to Customer No." := SalesHeader."Bill-to Customer No.";

        GetLineWithSalesPrice(LineWithPrice);
        LineWithPrice.SetLine(PriceType, SalesHeader, SalesLine);
        PriceCalculationMgt.GetHandler(LineWithPrice, PriceCalculation);
        SalesHeader.Delete();
    end;

    procedure ApplyPrice(CalledByFieldNo: Integer; var PriceCalculation: Interface "Price Calculation")
    begin
        PriceCalculation.ApplyPrice(CalledByFieldNo);
        GetLineWithCalculatedPrice(PriceCalculation);

    end;

    local procedure GetLineWithCalculatedPrice(var PriceCalculation: Interface "Price Calculation")
    var
        Line: Variant;
    begin
        PriceCalculation.GetLine(Line);
        SalesLine := Line;
        Rec."Precio X Producto" := SalesLine."Unit Price";
        Rec."Precio Tratamiento" := salesline."Unit Volume";
        if SalesLine.Get(Rec."Document Type", Rec."Document No.", Rec."Line No.") then
            SalesLine.Delete();


    end;

    procedure GetLineWithSalesPrice(var LineWithPrice: Interface "Line With Price")
    var
        SalesLinePrice: Codeunit "Sales Line - Price";
    begin
        LineWithPrice := SalesLinePrice;

    end;

    local procedure CalcBaseQty(Qty: Decimal; FromFieldName: Text; ToFieldName: Text): Decimal
    var
        UOMMgt: Codeunit "Unit of Measure Management";
    begin
        exit(UOMMgt.CalcBaseQty(
            "No.", "Variant Code", "Unit of Measure Code", Qty, "Qty. per Unit of Measure", "Qty. Rounding Precision (Base)", FieldCaption("Qty. Rounding Precision"), FromFieldName, ToFieldName));
    end;

    local procedure VereificarCantidad(Producto: Code[20]; pQuantity: Decimal; FromCode: Code[10]; ToCode: Code[20])
    var
        ItemLegderEntry: Record "Item Ledger Entry";
        AlmacenUso: Code[20];

    begin
        if FromCode = '' then FromCode := "From-LocationCode";

        AlmacenUso := FromCode;
        ItemLegderEntry.SetCurrentKey("Item No.", Positive, "Location Code");
        ItemLegderEntry.SetRange("Item No.", Producto);
        ItemLegderEntry.SetRange("Location Code", AlmacenUso);
        If ItemLegderEntry.FindSet() then begin
            ItemLegderEntry.CalcSums("Quantity");
            if ItemLegderEntry.Quantity < 0 Then exit;
            if ItemLegderEntry.Quantity < pQuantity then
                Error('La cantidad a tratar es mayor a la cantidad en almacen %1', AlmacenUso);
        end else
            if pQuantity <> 0 then
                Error('No se encontro el producto en almacen %1', AlmacenUso);
    end;

    procedure formlocationcode(fLocationCode: Code[10])
    begin
        "From-LocationCode" := fLocationCode;
    end;
}