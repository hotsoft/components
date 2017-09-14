program prcdvw2;

uses
  Forms,
  rcdvw2 in 'rcdvw2.pas' {RecordViewCustomForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TRecordViewCustomForm, RecordViewCustomForm);
  Application.Run;
end.
