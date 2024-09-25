pageextension 50103 PurxOrderListEx0 extends "Purchase List"
{
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.Setrange(Recepcion, Recepcion::" ");
    end;
}
pageextension 50104 PurxOrderListEx1 extends "Purchase Order List"
{
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.Setrange(Recepcion, Recepcion::" ");
    end;
}