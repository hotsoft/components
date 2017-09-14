program pcheckbox;

uses
  Forms,
  checkboxu in 'checkboxu.pas' {CheckBoxDemo};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TCheckBoxDemo, CheckBoxDemo);
  Application.Run;
end.
