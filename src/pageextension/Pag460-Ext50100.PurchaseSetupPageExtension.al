pageextension 60100 "Purchase Setup Page Extension" Extends "Purchases & Payables Setup" //460
{
    layout
    {
        addlast(General)
        {
            field("Proveedor Tratamientos"; Rec."Proveedor Tratamientos")
            {
                ApplicationArea = All;
                Caption = 'Proveedor Tratamientos';
                ToolTip = 'Proveedor Tratamientos';

            }
        }
        addlast("Number Series")
        {
            field("Serie Pedidos Recepción Tratamientos"; Rec."Recepcion Tratamientos")
            {
                ApplicationArea = All;
                Caption = 'Serie recepción Tratamientos';

            }
            field("Serie Recepción Tratamientos"; Rec."Recepciones Tratamientos")
            {
                ApplicationArea = All;
                Caption = 'Serie recepción Tratamientos';

            }
        }
    }
}