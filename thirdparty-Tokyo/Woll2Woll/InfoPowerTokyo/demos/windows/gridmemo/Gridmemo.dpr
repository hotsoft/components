program Gridmemo;

uses
  Forms,
  Grdmemo in 'GRDMEMO.PAS' {GridMemoApp};

{$R *.RES}

begin
  Application.CreateForm(TGridMemoApp, GridMemoApp);
  Application.Run;
end.
