program Prjmulti;

uses
  Forms,
  Multi in 'MULTI.PAS' {Form1};

{$R *.RES}

begin
  Application.CreateForm(TMultiSelectForm, MultiSelectForm);
  Application.Run;
end.
