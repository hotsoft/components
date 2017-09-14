program prjDataInspector;

uses
  Forms,
  DataInspectorU in 'DataInspectorU.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDataInspectorDemo, DataInspectorDemo);
  Application.Run;
end.
