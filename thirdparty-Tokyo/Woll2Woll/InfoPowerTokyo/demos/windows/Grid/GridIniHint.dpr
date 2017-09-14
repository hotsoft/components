program GridIniHint;

uses
  Forms,
  GrdIniHint in 'GrdIniHint.pas' {GridHintIniDemo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TGridHintIniDemo, GridHintIniDemo);
  Application.Run;
end.
