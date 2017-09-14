program Gridlook;

uses
  Forms,
  GrdLook in 'GRDLOOK.PAS' {GridDemo};

{$R *.RES}

begin
  Application.CreateForm(TGridDemo, GridDemo);
  Application.Run;
end.
