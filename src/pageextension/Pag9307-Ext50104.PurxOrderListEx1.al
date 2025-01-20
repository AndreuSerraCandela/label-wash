pageextension 50104 PurxOrderListEx1 extends "Purchase Order List" //9307
{
    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);
        Rec.Setrange(Recepcion, Recepcion::" ");
    end;
}