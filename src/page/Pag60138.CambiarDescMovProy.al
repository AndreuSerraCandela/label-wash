page 60138 "Cambiar desc. mov. proy."
{
    Caption = 'Cambiar descripción';
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            field(Descripcion; Descripcion)
            {
                ApplicationArea = All;
                Caption = 'Descripción';
                ToolTip = 'Especifica la descripción del movimiento de proyecto.';
            }
        }
    }

    procedure SetDescripcion(DescripcionActual: Text[100])
    begin
        Descripcion := DescripcionActual;
    end;

    procedure GetDescripcion(): Text[100]
    begin
        exit(Descripcion);
    end;

    var
        Descripcion: Text[100];
}
