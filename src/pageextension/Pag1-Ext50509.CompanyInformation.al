/// <summary>
/// PageExtension CompanyInformationServitec (ID 50509) extends Page Company Information.
/// </summary>
pageextension 60129 CompanyInformationServitec extends "Company Information"
{
    layout
    {
        addlast(Content)
        {
            group("Servicio PDF")
            {
                Caption = 'Servicio PDF';

                field("Url Pdf"; Rec."Url Pdf")
                {
                    ApplicationArea = All;
                    ToolTip = 'Especifica la URL del servicio que une el PDF del informe con el PDF adjunto. Si se deja en blanco se usará el servicio por defecto.';
                }
            }
        }
    }
}
