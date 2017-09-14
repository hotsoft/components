program DittoDemo;

uses
  Forms,
  dittou in 'dittou.pas' {DittoForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDittoForm, DittoForm);
  Application.Run;
end.
