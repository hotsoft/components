program Plkdtl;

uses
  Forms,
  Lkdtl in 'LKDTL.PAS' {DetailComboForm};

{$R *.RES}

begin
  Application.CreateForm(TDetailComboForm, DetailComboForm);
  Application.Run;
end.
