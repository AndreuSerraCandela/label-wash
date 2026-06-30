/// <summary>
/// Page Reminder Diagnosis (ID 90144).
/// </summary>
page 50124 "Reminder Diagnosis"
{
    ApplicationArea = All;
    Caption = 'Diagnóstico recordatorios';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "Reminder Diagnosis Line";
    SourceTableTemporary = true;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            group(Opciones)
            {
                Caption = 'Opciones';

                field(DiagnosticDocumentDate; DiagnosticDocumentDate)
                {
                    ApplicationArea = All;
                    Caption = 'Fecha documento';
                    ToolTip = 'Especifica la fecha documento que se usará para evaluar vencimientos y periodos de gracia.';
                }
                field(DiagnosticPostingDate; DiagnosticPostingDate)
                {
                    ApplicationArea = All;
                    Caption = 'Fecha registro';
                    ToolTip = 'Especifica la fecha registro usada para convertir importes en divisa a divisa local al comparar el importe mínimo.';
                }
                field(OnlyOverdueEntries; OnlyOverdueEntries)
                {
                    ApplicationArea = All;
                    Caption = 'Solo movs. con importes vencidos';
                    ToolTip = 'Indica si el diagnóstico debe aplicar la misma opción de Business Central para incluir solo movimientos vencidos.';
                }
                field(IncludeEntriesOnHold; IncludeEntriesOnHold)
                {
                    ApplicationArea = All;
                    Caption = 'Incluir movimientos en espera';
                    ToolTip = 'Indica si el diagnóstico debe considerar movimientos con el campo En espera informado.';
                }
            }

            repeater(Lines)
            {
                Caption = 'Documentos pendientes';

                field("Diagnostic Result"; Rec."Diagnostic Result")
                {
                    ApplicationArea = All;
                    StyleExpr = ResultStyle;
                    ToolTip = 'Indica si el movimiento es incluible, condicionado o no incluido.';
                }
                field("Reason"; Rec.Reason)
                {
                    ApplicationArea = All;
                    StyleExpr = ResultStyle;
                    ToolTip = 'Especifica la causa principal por la que el movimiento no se incluye o queda condicionado.';
                }
                field("Details"; Rec.Details)
                {
                    ApplicationArea = All;
                    ToolTip = 'Muestra información adicional del diagnóstico.';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el número de movimiento de cliente.';
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el número de cliente.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el nombre del cliente.';
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el tipo de documento del movimiento.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el número de documento.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica la fecha de vencimiento del movimiento.';
                }
                field("Reminder Due Date"; Rec."Reminder Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica la fecha base que Business Central usa para evaluar el siguiente recordatorio.';
                }
                field("Grace Period"; Rec."Grace Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el periodo de gracia del nivel de recordatorio calculado.';
                }
                field("Grace Due Date"; Rec."Grace Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica la fecha resultante de sumar el periodo de gracia a la fecha base.';
                }
                field("Reminder Terms Code"; Rec."Reminder Terms Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el código de términos de recordatorio del cliente.';
                }
                field("Last Issued Reminder Level"; Rec."Last Issued Reminder Level")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el último nivel de recordatorio emitido para el movimiento.';
                }
                field("Next Reminder Level"; Rec."Next Reminder Level")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el nivel de recordatorio calculado para el siguiente recordatorio.';
                }
                field("Open Reminder No."; Rec."Open Reminder No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el recordatorio abierto que ya existe para el cliente y divisa, si lo hay.';
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el importe pendiente del movimiento.';
                }
                field("Remaining Amt. (LCY)"; Rec."Remaining Amt. (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el importe pendiente en divisa local.';
                }
                field("Candidate Amount (LCY)"; Rec."Candidate Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el total candidato aproximado en divisa local para cliente y divisa.';
                }
                field("Minimum Amount (LCY)"; Rec."Minimum Amount (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica el importe mínimo de los términos de recordatorio.';
                }
                field("On Hold"; Rec."On Hold")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica si el movimiento está marcado en espera.';
                }
                field(Positive; Rec.Positive)
                {
                    ApplicationArea = All;
                    ToolTip = 'Indica si el movimiento es positivo.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica la fecha de registro del movimiento.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica la fecha documento del movimiento.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica la divisa del movimiento.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Actualizar diagnóstico")
            {
                ApplicationArea = All;
                Caption = 'Actualizar diagnóstico';
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Recalcula el diagnóstico de documentos pendientes de recordatorio.';

                trigger OnAction()
                begin
                    RefreshDiagnosis();
                end;
            }

            action("Abrir mov. cliente")
            {
                ApplicationArea = All;
                Caption = 'Abrir mov. cliente';
                Image = Navigate;
                ToolTip = 'Abre el movimiento de cliente seleccionado.';

                trigger OnAction()
                var
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    if CustLedgerEntry.Get(Rec."Entry No.") then
                        Page.Run(Page::"Customer Ledger Entries", CustLedgerEntry);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetResultStyle();
    end;

    trigger OnOpenPage()
    begin
        DiagnosticDocumentDate := WorkDate();
        DiagnosticPostingDate := WorkDate();
        OnlyOverdueEntries := true;
        RefreshDiagnosis();
    end;

    local procedure RefreshDiagnosis()
    var
        ReminderDiagnosisMgt: Codeunit EventosVarios;
    begin
        ReminderDiagnosisMgt.BuildDiagnosis(Rec, DiagnosticDocumentDate, DiagnosticPostingDate, OnlyOverdueEntries, IncludeEntriesOnHold);
        CurrPage.Update(false);
    end;

    local procedure SetResultStyle()
    begin
        case Rec."Diagnostic Result" of
            'Incluible':
                ResultStyle := 'Favorable';
            'Condicionado':
                ResultStyle := 'Ambiguous';
            else
                ResultStyle := 'Unfavorable';
        end;
    end;

    var
        DiagnosticDocumentDate: Date;
        DiagnosticPostingDate: Date;
        OnlyOverdueEntries: Boolean;
        IncludeEntriesOnHold: Boolean;
        ResultStyle: Text;
}
