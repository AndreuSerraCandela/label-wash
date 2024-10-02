tableextension 50105 PurchaseLineExtension extends "Purchase Line"
{
    fields
    {
        field(50100; "Cantidad a Tratar"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                ItemEntry: Record "Item Ledger Entry";
                PurchaseHeader: Record "Purchase Header";
            begin
                If Not PurchaseHeader.Get("Document Type", "Document No.") then
                    PurchaseHeader.Init();
                if Not "No Avisar" Then
                    VereificarCantdadaTratar("No.", Quantity, "Location Code", PurchaseHeader."Bill-to Customer No.");
                Validate("Qty. to Receive", "Cantidad a Tratar" + "Cantidad a Merma");
                "Cantidad a Tratar Base" := CalcBaseQty("Cantidad a Tratar", FieldCaption("Cantidad a Tratar"), FieldCaption("Cantidad a Tratar Base"));

            end;

        }
        field(50108; "Cantidad a uso Base"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50109; "Cantidad a Uso"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Cantidad a uso Base" := CalcBaseQty("Cantidad a Uso", FieldCaption("Cantidad a Uso"), FieldCaption("Cantidad a Uso Base"));
            end;

        }
        field(50101; "Cantidad a Tratar Base"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50105; "Cantidad a Merma"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                Validate("Cantidad a Tratar", Quantity - "Cantidad Tratada" - "Cantidad a Merma");
                "Cantidad a Merma Base" := CalcBaseQty("Cantidad a Tratar", FieldCaption("Cantidad a Tratar"), FieldCaption("Cantidad a Tratar Base"));

            end;

        }
        field(50106; "Cantidad a Merma Base"; Decimal)
        {
            DataClassification = CustomerContent;
        }

        field(50102; "Cantidad Tratada"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Cantidad Tratada Base" := CalcBaseQty("Cantidad Tratada", FieldCaption("Cantidad Tratada"), FieldCaption("Cantidad Tratada Base"));
            end;
        }
        field(50110; "Cantidad Usada Base"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50111; "Cantidad Usada"; Decimal)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                "Cantidad Usada Base" := CalcBaseQty("Cantidad Usada", FieldCaption("Cantidad Usada"), FieldCaption("Cantidad Usada Base"));
            end;
        }
        field(50103; "Cantidad Tratada Base"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50104; "Precio X Producto"; DECIMAL)
        {
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                validate("Direct unit cost", "Precio X Producto");

            end;
        }
        field(50107; "Precio Tratamiento"; DECIMAL)
        {
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
                    if Not "No Avisar" Then
                        VereificarCantdadaTratar("No.", Quantity, "Location Code", PurchaseHeader."Bill-to Customer No.");
                end;
            end;
        }
        field(50112; "No Avisar"; Boolean)
        {
            DataClassification = CustomerContent;
        }

    }
    var
        PriceCalculation: Interface "Price Calculation";
        PriceType: Enum "Price Type";
        SalesHeader: Record "Sales Header";
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

    local procedure VereificarCantdadaTratar(Producto: Code[20]; pQuantity: Decimal; LocationCode: Code[10]; Cliente: Code[20])
    var
        ItemLegderEntry: Record "Item Ledger Entry";
        AlmacenUso: Code[20];
    begin

        AlmacenUso := Cliente + 'U';
        ItemLegderEntry.SetCurrentKey("Item No.", Positive, "Location Code");
        ItemLegderEntry.SetRange("Item No.", Producto);
        ItemLegderEntry.SetRange("Location Code", AlmacenUso);
        If ItemLegderEntry.FindSet() then begin
            ItemLegderEntry.CalcSums("Quantity");
            if ItemLegderEntry.Quantity < pQuantity then
                Error('La cantidad a tratar es mayor a la cantidad en almacen de uso');
        end else
            Error('No se encontro el producto en almacen de uso');
    end;
}