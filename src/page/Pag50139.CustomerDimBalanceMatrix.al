page 60139 "Customer Dim. Balance Matrix"
{
    //ApplicationArea = All;
    Caption = 'Matriz saldo periodo clientes';
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Customer;
    //UsageCategory = ReportsAndAnalysis;

    layout
    {
        area(content)
        {
            group(Filtros)
            {
                Caption = 'Filtros de totales';

                field(DimensionCode; DimensionCode)
                {
                    ApplicationArea = All;
                    Caption = 'Dimensión columnas';
                    TableRelation = Dimension.Code;
                    ToolTip = 'Dimensión cuyos valores se mostrarán como columnas de la matriz.';

                    trigger OnValidate()
                    begin
                        InitMatrixColumns();
                        CurrPage.Update(false);
                    end;
                }
                field(DimensionValueFilter; DimensionValueFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Filtro valores dimensión';
                    ToolTip = 'Filtro sobre los valores de dimensión que aparecen como columnas.';

                    trigger OnValidate()
                    begin
                        InitMatrixColumns();
                        CurrPage.Update(false);
                    end;
                }
                field(DateFilterText; DateFilterText)
                {
                    ApplicationArea = All;
                    Caption = 'Filtro fecha';
                    ToolTip = 'Filtro de fecha de registro para el saldo periodo (igual que en totales de clientes).';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field(GlobalDim1FilterText; GlobalDim1FilterText)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,3,1';
                    ToolTip = 'Filtro de dimensión global 1 para el saldo periodo.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field(GlobalDim2FilterText; GlobalDim2FilterText)
                {
                    ApplicationArea = All;
                    CaptionClass = '1,3,2';
                    ToolTip = 'Filtro de dimensión global 2 para el saldo periodo.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field(CurrencyFilterText; CurrencyFilterText)
                {
                    ApplicationArea = All;
                    Caption = 'Filtro divisa';
                    ToolTip = 'Filtro de divisa para el saldo periodo.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
            }
            repeater(Lines)
            {
                Editable = false;
                ShowCaption = false;

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    ToolTip = 'Código del cliente. Pulse para abrir la ficha.';

                    trigger OnDrillDown()
                    begin
                        PAGE.Run(PAGE::"Customer Card", Rec);
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Nombre del cliente.';
                }
                field(TotalPeriodBalance; TotalPeriodBalance)
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    Caption = 'Saldo periodo total';
                    DrillDown = true;
                    ToolTip = 'Saldo periodo del cliente con los filtros de totales, sin filtrar por columna de dimensión.';

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(0);
                    end;
                }
                field(Field1; MATRIX_CellData[1])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[1];
                    DrillDown = true;
                    Visible = Field1Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(1);
                    end;
                }
                field(Field2; MATRIX_CellData[2])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[2];
                    DrillDown = true;
                    Visible = Field2Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(2);
                    end;
                }
                field(Field3; MATRIX_CellData[3])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[3];
                    DrillDown = true;
                    Visible = Field3Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(3);
                    end;
                }
                field(Field4; MATRIX_CellData[4])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[4];
                    DrillDown = true;
                    Visible = Field4Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(4);
                    end;
                }
                field(Field5; MATRIX_CellData[5])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[5];
                    DrillDown = true;
                    Visible = Field5Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(5);
                    end;
                }
                field(Field6; MATRIX_CellData[6])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[6];
                    DrillDown = true;
                    Visible = Field6Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(6);
                    end;
                }
                field(Field7; MATRIX_CellData[7])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[7];
                    DrillDown = true;
                    Visible = Field7Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(7);
                    end;
                }
                field(Field8; MATRIX_CellData[8])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[8];
                    DrillDown = true;
                    Visible = Field8Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(8);
                    end;
                }
                field(Field9; MATRIX_CellData[9])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[9];
                    DrillDown = true;
                    Visible = Field9Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(9);
                    end;
                }
                field(Field10; MATRIX_CellData[10])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[10];
                    DrillDown = true;
                    Visible = Field10Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(10);
                    end;
                }
                field(Field11; MATRIX_CellData[11])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[11];
                    DrillDown = true;
                    Visible = Field11Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(11);
                    end;
                }
                field(Field12; MATRIX_CellData[12])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[12];
                    DrillDown = true;
                    Visible = Field12Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(12);
                    end;
                }
                field(Field13; MATRIX_CellData[13])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[13];
                    DrillDown = true;
                    Visible = Field13Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(13);
                    end;
                }
                field(Field14; MATRIX_CellData[14])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[14];
                    DrillDown = true;
                    Visible = Field14Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(14);
                    end;
                }
                field(Field15; MATRIX_CellData[15])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[15];
                    DrillDown = true;
                    Visible = Field15Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(15);
                    end;
                }
                field(Field16; MATRIX_CellData[16])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[16];
                    DrillDown = true;
                    Visible = Field16Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(16);
                    end;
                }
                field(Field17; MATRIX_CellData[17])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[17];
                    DrillDown = true;
                    Visible = Field17Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(17);
                    end;
                }
                field(Field18; MATRIX_CellData[18])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[18];
                    DrillDown = true;
                    Visible = Field18Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(18);
                    end;
                }
                field(Field19; MATRIX_CellData[19])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[19];
                    DrillDown = true;
                    Visible = Field19Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(19);
                    end;
                }
                field(Field20; MATRIX_CellData[20])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[20];
                    DrillDown = true;
                    Visible = Field20Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(20);
                    end;
                }
                field(Field21; MATRIX_CellData[21])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[21];
                    DrillDown = true;
                    Visible = Field21Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(21);
                    end;
                }
                field(Field22; MATRIX_CellData[22])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[22];
                    DrillDown = true;
                    Visible = Field22Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(22);
                    end;
                }
                field(Field23; MATRIX_CellData[23])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[23];
                    DrillDown = true;
                    Visible = Field23Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(23);
                    end;
                }
                field(Field24; MATRIX_CellData[24])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[24];
                    DrillDown = true;
                    Visible = Field24Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(24);
                    end;
                }
                field(Field25; MATRIX_CellData[25])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[25];
                    DrillDown = true;
                    Visible = Field25Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(25);
                    end;
                }
                field(Field26; MATRIX_CellData[26])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[26];
                    DrillDown = true;
                    Visible = Field26Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(26);
                    end;
                }
                field(Field27; MATRIX_CellData[27])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[27];
                    DrillDown = true;
                    Visible = Field27Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(27);
                    end;
                }
                field(Field28; MATRIX_CellData[28])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[28];
                    DrillDown = true;
                    Visible = Field28Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(28);
                    end;
                }
                field(Field29; MATRIX_CellData[29])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[29];
                    DrillDown = true;
                    Visible = Field29Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(29);
                    end;
                }
                field(Field30; MATRIX_CellData[30])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[30];
                    DrillDown = true;
                    Visible = Field30Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(30);
                    end;
                }
                field(Field31; MATRIX_CellData[31])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[31];
                    DrillDown = true;
                    Visible = Field31Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(31);
                    end;
                }
                field(Field32; MATRIX_CellData[32])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[32];
                    DrillDown = true;
                    Visible = Field32Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(32);
                    end;
                }
                field(Field33; MATRIX_CellData[33])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[33];
                    DrillDown = true;
                    Visible = Field33Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(33);
                    end;
                }
                field(Field34; MATRIX_CellData[34])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[34];
                    DrillDown = true;
                    Visible = Field34Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(34);
                    end;
                }
                field(Field35; MATRIX_CellData[35])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[35];
                    DrillDown = true;
                    Visible = Field35Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(35);
                    end;
                }
                field(Field36; MATRIX_CellData[36])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[36];
                    DrillDown = true;
                    Visible = Field36Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(36);
                    end;
                }
                field(Field37; MATRIX_CellData[37])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[37];
                    DrillDown = true;
                    Visible = Field37Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(37);
                    end;
                }
                field(Field38; MATRIX_CellData[38])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[38];
                    DrillDown = true;
                    Visible = Field38Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(38);
                    end;
                }
                field(Field39; MATRIX_CellData[39])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[39];
                    DrillDown = true;
                    Visible = Field39Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(39);
                    end;
                }
                field(Field40; MATRIX_CellData[40])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[40];
                    DrillDown = true;
                    Visible = Field40Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(40);
                    end;
                }
                field(Field41; MATRIX_CellData[41])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[41];
                    DrillDown = true;
                    Visible = Field41Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(41);
                    end;
                }
                field(Field42; MATRIX_CellData[42])
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    BlankZero = true;
                    CaptionClass = '3,' + MATRIX_ColumnCaptions[42];
                    DrillDown = true;
                    Visible = Field42Visible;

                    trigger OnDrillDown()
                    begin
                        DrillDownMatrixCell(42);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PreviousSet)
            {
                ApplicationArea = All;
                Caption = 'Columnas anteriores';
                Image = PreviousSet;
                ToolTip = 'Muestra el conjunto anterior de columnas de dimensión.';

                trigger OnAction()
                begin
                    MATRIX_StepColumns("Matrix Page Step Type"::Previous);
                end;
            }
            action(NextSet)
            {
                ApplicationArea = All;
                Caption = 'Columnas siguientes';
                Image = NextSet;
                ToolTip = 'Muestra el conjunto siguiente de columnas de dimensión.';

                trigger OnAction()
                begin
                    MATRIX_StepColumns("Matrix Page Step Type"::Next);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        GeneralLedgerSetup.Get();
        if DimensionCode = '' then
            DimensionCode := GeneralLedgerSetup."Global Dimension 1 Code";

        InitMatrixColumns();
    end;

    trigger OnAfterGetRecord()
    var
        ColumnIndex: Integer;
    begin
        TotalPeriodBalance :=
            EventosVarios.GetCustomerPeriodBalanceTotalLCY(
                Rec."No.", DateFilterText, GlobalDim1FilterText, GlobalDim2FilterText, CurrencyFilterText);

        Clear(MATRIX_CellData);
        if DimensionCode = '' then
            exit;

        for ColumnIndex := 1 to MATRIX_NoOfColumns do
            if MATRIX_ColumnCodes[ColumnIndex] <> '' then
                MATRIX_CellData[ColumnIndex] :=
                    EventosVarios.GetCustomerPeriodBalanceLCY(
                        Rec."No.",
                        DimensionCode,
                        MATRIX_ColumnCodes[ColumnIndex],
                        DateFilterText,
                        GlobalDim1FilterText,
                        GlobalDim2FilterText,
                        CurrencyFilterText);
    end;

    procedure SetTotalsFilters(NewDateFilter: Text; NewGlobalDim1Filter: Text; NewGlobalDim2Filter: Text; NewCurrencyFilter: Text)
    begin
        DateFilterText := CopyStr(NewDateFilter, 1, MaxStrLen(DateFilterText));
        GlobalDim1FilterText := CopyStr(NewGlobalDim1Filter, 1, MaxStrLen(GlobalDim1FilterText));
        GlobalDim2FilterText := CopyStr(NewGlobalDim2Filter, 1, MaxStrLen(GlobalDim2FilterText));
        CurrencyFilterText := CopyStr(NewCurrencyFilter, 1, MaxStrLen(CurrencyFilterText));
    end;

    local procedure InitMatrixColumns()
    begin
        MATRIX_NoOfColumns := ArrayLen(MATRIX_CellData);
        MatrixMgt.SetDimColumnSet(
            DimensionCode,
            DimensionValueFilter,
            "Matrix Page Step Type"::Initial.AsInteger(),
            MATRIX_PrimKeyFirstCol,
            MATRIX_CaptionFirstCol,
            MATRIX_CaptionLastCol,
            MATRIX_NoOfColumns);
        MATRIX_GenerateColumnCaptions();
        SetColumnVisibility();
    end;

    local procedure MATRIX_StepColumns(SetWanted: Enum "Matrix Page Step Type")
    begin
        MatrixMgt.SetDimColumnSet(
            DimensionCode,
            DimensionValueFilter,
            SetWanted.AsInteger(),
            MATRIX_PrimKeyFirstCol,
            MATRIX_CaptionFirstCol,
            MATRIX_CaptionLastCol,
            MATRIX_NoOfColumns);
        MATRIX_GenerateColumnCaptions();
        SetColumnVisibility();
        CurrPage.Update(false);
    end;

    local procedure MATRIX_GenerateColumnCaptions()
    var
        DimensionValue: Record "Dimension Value";
        ColumnIndex: Integer;
        CurrentColumnCode: Code[20];
    begin
        Clear(MATRIX_ColumnCaptions);
        Clear(MATRIX_ColumnCodes);

        if DimensionCode = '' then
            exit;

        CurrentColumnCode := MATRIX_CaptionFirstCol;
        for ColumnIndex := 1 to MATRIX_NoOfColumns do begin
            if CurrentColumnCode = '' then
                break;

            if DimensionValue.Get(DimensionCode, CurrentColumnCode) then
                MATRIX_ColumnCaptions[ColumnIndex] := DimensionValue.Code + ' - ' + DimensionValue.Name
            else
                MATRIX_ColumnCaptions[ColumnIndex] := CurrentColumnCode;

            MATRIX_ColumnCodes[ColumnIndex] := CurrentColumnCode;

            if CurrentColumnCode = MATRIX_CaptionLastCol then
                break;

            if not GetNextDimensionValue(DimensionValue, CurrentColumnCode) then
                break;
        end;
    end;

    local procedure GetNextDimensionValue(var DimensionValue: Record "Dimension Value"; var CurrentColumnCode: Code[20]): Boolean
    begin
        DimensionValue.SetRange("Dimension Code", DimensionCode);
        if DimensionValueFilter <> '' then
            DimensionValue.SetFilter(Code, DimensionValueFilter);
        DimensionValue.Get(DimensionCode, CurrentColumnCode);
        if DimensionValue.Next() = 0 then begin
            CurrentColumnCode := '';
            exit(false);
        end;
        CurrentColumnCode := DimensionValue.Code;
        exit(true);
    end;

    local procedure SetColumnVisibility()
    begin
        Field1Visible := MATRIX_ColumnCaptions[1] <> '';
        Field2Visible := MATRIX_ColumnCaptions[2] <> '';
        Field3Visible := MATRIX_ColumnCaptions[3] <> '';
        Field4Visible := MATRIX_ColumnCaptions[4] <> '';
        Field5Visible := MATRIX_ColumnCaptions[5] <> '';
        Field6Visible := MATRIX_ColumnCaptions[6] <> '';
        Field7Visible := MATRIX_ColumnCaptions[7] <> '';
        Field8Visible := MATRIX_ColumnCaptions[8] <> '';
        Field9Visible := MATRIX_ColumnCaptions[9] <> '';
        Field10Visible := MATRIX_ColumnCaptions[10] <> '';
        Field11Visible := MATRIX_ColumnCaptions[11] <> '';
        Field12Visible := MATRIX_ColumnCaptions[12] <> '';
        Field13Visible := MATRIX_ColumnCaptions[13] <> '';
        Field14Visible := MATRIX_ColumnCaptions[14] <> '';
        Field15Visible := MATRIX_ColumnCaptions[15] <> '';
        Field16Visible := MATRIX_ColumnCaptions[16] <> '';
        Field17Visible := MATRIX_ColumnCaptions[17] <> '';
        Field18Visible := MATRIX_ColumnCaptions[18] <> '';
        Field19Visible := MATRIX_ColumnCaptions[19] <> '';
        Field20Visible := MATRIX_ColumnCaptions[20] <> '';
        Field21Visible := MATRIX_ColumnCaptions[21] <> '';
        Field22Visible := MATRIX_ColumnCaptions[22] <> '';
        Field23Visible := MATRIX_ColumnCaptions[23] <> '';
        Field24Visible := MATRIX_ColumnCaptions[24] <> '';
        Field25Visible := MATRIX_ColumnCaptions[25] <> '';
        Field26Visible := MATRIX_ColumnCaptions[26] <> '';
        Field27Visible := MATRIX_ColumnCaptions[27] <> '';
        Field28Visible := MATRIX_ColumnCaptions[28] <> '';
        Field29Visible := MATRIX_ColumnCaptions[29] <> '';
        Field30Visible := MATRIX_ColumnCaptions[30] <> '';
        Field31Visible := MATRIX_ColumnCaptions[31] <> '';
        Field32Visible := MATRIX_ColumnCaptions[32] <> '';
        Field33Visible := MATRIX_ColumnCaptions[33] <> '';
        Field34Visible := MATRIX_ColumnCaptions[34] <> '';
        Field35Visible := MATRIX_ColumnCaptions[35] <> '';
        Field36Visible := MATRIX_ColumnCaptions[36] <> '';
        Field37Visible := MATRIX_ColumnCaptions[37] <> '';
        Field38Visible := MATRIX_ColumnCaptions[38] <> '';
        Field39Visible := MATRIX_ColumnCaptions[39] <> '';
        Field40Visible := MATRIX_ColumnCaptions[40] <> '';
        Field41Visible := MATRIX_ColumnCaptions[41] <> '';
        Field42Visible := MATRIX_ColumnCaptions[42] <> '';
    end;

    local procedure DrillDownMatrixCell(ColumnIndex: Integer)
    begin
        if ColumnIndex = 0 then
            EventosVarios.DrillDownCustomerPeriodBalance(
                Rec."No.", '', '',
                DateFilterText, GlobalDim1FilterText, GlobalDim2FilterText, CurrencyFilterText)
        else
            EventosVarios.DrillDownCustomerPeriodBalance(
                Rec."No.", DimensionCode, MATRIX_ColumnCodes[ColumnIndex],
                DateFilterText, GlobalDim1FilterText, GlobalDim2FilterText, CurrencyFilterText);
    end;

    var
        EventosVarios: Codeunit EventosVarios;
        MatrixMgt: Codeunit "Matrix Management";
        DimensionCode: Code[20];
        DimensionValueFilter: Text;
        DateFilterText: Text;
        GlobalDim1FilterText: Text;
        GlobalDim2FilterText: Text;
        CurrencyFilterText: Text;
        TotalPeriodBalance: Decimal;
        MATRIX_NoOfColumns: Integer;
        MATRIX_CellData: array[42] of Decimal;
        MATRIX_ColumnCaptions: array[42] of Text[250];
        MATRIX_ColumnCodes: array[42] of Code[20];
        MATRIX_PrimKeyFirstCol: Text[1024];
        MATRIX_CaptionFirstCol: Text[1024];
        MATRIX_CaptionLastCol: Text[1024];
        Field1Visible: Boolean;
        Field2Visible: Boolean;
        Field3Visible: Boolean;
        Field4Visible: Boolean;
        Field5Visible: Boolean;
        Field6Visible: Boolean;
        Field7Visible: Boolean;
        Field8Visible: Boolean;
        Field9Visible: Boolean;
        Field10Visible: Boolean;
        Field11Visible: Boolean;
        Field12Visible: Boolean;
        Field13Visible: Boolean;
        Field14Visible: Boolean;
        Field15Visible: Boolean;
        Field16Visible: Boolean;
        Field17Visible: Boolean;
        Field18Visible: Boolean;
        Field19Visible: Boolean;
        Field20Visible: Boolean;
        Field21Visible: Boolean;
        Field22Visible: Boolean;
        Field23Visible: Boolean;
        Field24Visible: Boolean;
        Field25Visible: Boolean;
        Field26Visible: Boolean;
        Field27Visible: Boolean;
        Field28Visible: Boolean;
        Field29Visible: Boolean;
        Field30Visible: Boolean;
        Field31Visible: Boolean;
        Field32Visible: Boolean;
        Field33Visible: Boolean;
        Field34Visible: Boolean;
        Field35Visible: Boolean;
        Field36Visible: Boolean;
        Field37Visible: Boolean;
        Field38Visible: Boolean;
        Field39Visible: Boolean;
        Field40Visible: Boolean;
        Field41Visible: Boolean;
        Field42Visible: Boolean;
}
