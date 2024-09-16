codeunit 50100 EventosTratamientos
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)
    begin
        if PurchaseHeader.Recepcion Then begin
            PurchaseHeader.Receive := true;
            PurchaseHeader.Invoice := false;
            HideDialog := true;
        end
    end;
}