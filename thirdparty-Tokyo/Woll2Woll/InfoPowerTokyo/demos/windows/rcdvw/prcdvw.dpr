program prcdvw;

uses
  Forms,
  rcdvw in 'rcdvw.pas' {RecordViewDemoForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TRecordViewDemoForm, RecordViewDemoForm);
  Application.Run;
end.
