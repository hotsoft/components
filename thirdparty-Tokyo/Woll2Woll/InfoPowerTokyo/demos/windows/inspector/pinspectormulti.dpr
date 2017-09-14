program pinspectormulti;

uses
  Forms,
  inspectormulti in 'inspectormulti.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMultiInspectorForm, MultiInspectorForm);
  Application.Run;
end.
