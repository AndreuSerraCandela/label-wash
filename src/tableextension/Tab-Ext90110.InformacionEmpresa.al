/// <summary>
/// TableExtension InformacionEmpresa (ID 90110) extends Record Company Information.
/// </summary>
tableextension 60110 InformacionEmpresa extends "Company Information"
{
    fields
    {

        field(90031; "Url Pdf"; Text[250])
        {
            Caption = 'Url Pdf';
            DataClassification = CustomerContent;
        }
    }
}
