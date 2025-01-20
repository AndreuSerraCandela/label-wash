pageextension 50105 ItemLedgerEntriesExt extends "Item Ledger Entries" //38
{
    layout
    {
        modify("Source No.")
        {
            Visible = not Mercancia;

        }
        modify("Entry Type")
        {
            Visible = not Mercancia;

        }
        addafter("Posting Date")
        {
            field(Tipo; TipoMov())
            {
                ApplicationArea = All;
                Visible = Mercancia;
            }
        }
        addafter("Location Code")
        {
            field(Cliente; Cliente())
            {
                ApplicationArea = All;
                Visible = Mercancia;
            }
        }
    }
    var
        Mercancia: Boolean;

    procedure TipoMov(): Enum Recepcion
    Var
        PurchaseHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        If PurchRcptHeader.Get(Rec."Document No.") then
            If PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, PurchRcptHeader."Order No.") then
                Exit(PurchaseHeader.Recepcion);
    end;

    procedure Cliente(): Text[50]
    Var
        PurchaseHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        If PurchRcptHeader.Get(Rec."Document No.") then
            If PurchaseHeader.Get(PurchaseHeader."Document Type"::Order, PurchRcptHeader."Order No.") then
                Exit(PurchaseHeader."Bill-to Name");
    end;

    procedure LLamadoDesdeMercancia()
    begin
        Mercancia := true;
    end;

}