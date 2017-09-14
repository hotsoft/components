program Packprj;

uses
  Forms,
  Packdlgs in 'PACKDLGS.PAS' {GetTablesForm},
  Packtest in 'PACKTEST.PAS' {PackMain};

{$R *.RES}

begin
  Application.CreateForm(TPackMain, PackMain);
  Application.Run;
end.
