permissionset 60138 MODDESCMOVPROY
{
    Access = Public;
    Assignable = true;
    Caption = 'Modificar descripción de movimientos de proyecto';
    Permissions =
        tabledata "Job Ledger Entry" = R,
        codeunit "Cambiar desc. mov. proy." = X,
        page "Cambiar desc. mov. proy." = X;
}
