codeunit 60138 "Cambiar desc. mov. proy."
{
    Access = Public;
    Permissions = tabledata "Job Ledger Entry" = m;

    procedure CambiarDescripcion(EntryNo: Integer; NuevaDescripcion: Text[100])
    var
        JobLedgerEntry: Record "Job Ledger Entry";
    begin
        ComprobarPermiso();
        JobLedgerEntry.Get(EntryNo);
        if JobLedgerEntry.Description = NuevaDescripcion then
            exit;
        JobLedgerEntry.Description := NuevaDescripcion;
        JobLedgerEntry.Modify(false);
    end;

    local procedure ComprobarPermiso()
    var
        ExpandedPermission: Record "Expanded Permission";
        UserPermissions: Codeunit "User Permissions";
    begin
        ExpandedPermission := UserPermissions.GetEffectivePermission(ExpandedPermission."Object Type"::Codeunit, Codeunit::"Cambiar desc. mov. proy.");
        if not (ExpandedPermission."Execute Permission" in [ExpandedPermission."Execute Permission"::Yes, ExpandedPermission."Execute Permission"::Indirect]) then
            Error(SinPermisoErr);
    end;

    var
        SinPermisoErr: Label 'No tiene permiso para modificar la descripción de los movimientos de proyecto.';
}
