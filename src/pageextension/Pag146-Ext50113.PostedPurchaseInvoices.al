pageextension 60113 "Posted Purchase Invoices" extends "Posted Purchase Invoices" //146
{
    layout
    {
        addafter("Vendor Invoice No.")
        {

            field("Vendor Order No."; Rec."Vendor Order No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the vendor''s order number.';
            }
        }
        addafter("Posting Date")
        {

            field("Tipo factura"; Rec."Tipo factura")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tipo factura field.', Comment = '%';
            }
            field(HasDocumentAttachments; HasDocumentAttachments)
            {
                ApplicationArea = All;
                Caption = 'Tiene adjuntos';
                Editable = false;
                ToolTip = 'Indica si la factura registrada tiene adjuntos (Document Attachment) en la cabecera o en las líneas.';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        HasDocumentAttachments := InvoiceHasDocumentAttachments();
    end;

    local procedure InvoiceHasDocumentAttachments(): Boolean
    var
        DocumentAttachment: Record "Document Attachment";
        DocumentAttachmentMgmt: Codeunit "Document Attachment Mgmt";
        PurchInvHeaderRecRef: RecordRef;
    begin
        PurchInvHeaderRecRef.GetTable(Rec);
        DocumentAttachment.Reset();
        DocumentAttachmentMgmt.SetDocumentAttachmentRelatedFiltersForRecRef(DocumentAttachment, PurchInvHeaderRecRef);
        exit(not DocumentAttachment.IsEmpty);
    end;



    var
        HasDocumentAttachments: Boolean;
}