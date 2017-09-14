program Prjqbe;

uses
  Forms,
  Qbe in 'QBE.PAS' {QBEForm};

{$R *.RES}

begin
  Application.CreateForm(TQBEForm, QBEForm);
  Application.Run;
end.
