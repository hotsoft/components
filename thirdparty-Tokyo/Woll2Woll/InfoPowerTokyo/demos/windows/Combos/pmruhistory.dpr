program pmruhistory;

uses
  Forms,
  combodemou in 'combodemou.pas' {ComboDemoForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TComboDemoForm, ComboDemoForm);
  Application.Run;
end.
