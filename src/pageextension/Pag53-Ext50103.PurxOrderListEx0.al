pageextension 50103 PurxOrderListEx0 extends "Purchase List" //53
{
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.Setrange(Recepcion, Recepcion::" ");
    end;
}
