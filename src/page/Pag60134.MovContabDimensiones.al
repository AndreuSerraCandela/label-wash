page 60134 "Mov. contab. dimensiones"
{
    ApplicationArea = All;
    Caption = 'Dimensiones en movimientos de contabilidad';
    PageType = ListPart;
    SourceTable = "Mov. contab. dimensión";
    SourceTableView = sorting(Orden, "Dimension Code");

    layout
    {
        area(Content)
        {
            repeater(Lineas)
            {
                field(Orden; Rec.Orden)
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica la posición de la columna en Movimientos de contabilidad, incluidas las dos dimensiones globales. El número más bajo aparece más a la izquierda.';
                }
                field("Dimension Code"; Rec."Dimension Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica la dimensión que se muestra en esa columna.';
                }
                field(Mostrar; Rec.Mostrar)
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica si la dimensión se muestra en Movimientos de contabilidad. Como máximo pueden marcarse ocho.';
                }
                field("Dimension Name"; Rec."Dimension Name")
                {
                    ApplicationArea = All;
                    DrillDown = false;
                    ToolTip = 'Especifica el nombre de la dimensión.';
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        Ultima: Record "Mov. contab. dimensión";
    begin
        Ultima.SetCurrentKey(Orden);
        if Ultima.FindLast() then
            Rec.Orden := Ultima.Orden + 1
        else
            Rec.Orden := 1;
        Rec.Mostrar := true;
    end;

    trigger OnOpenPage()
    begin
        Rec.EnsureDefaults();
    end;
}
