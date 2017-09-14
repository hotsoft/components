program pradio;

uses
  Forms,
  radiou in 'radiou.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TRadioDemoForm, RadioDemoForm);
  Application.Run;
end.
