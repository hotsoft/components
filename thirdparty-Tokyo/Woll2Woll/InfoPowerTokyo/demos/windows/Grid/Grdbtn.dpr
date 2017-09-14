program Grdbtn;

uses
  Forms,
  Grdbttn in 'GRDBTTN.PAS' {BtnGridForm};

{$R *.RES}

begin
  Application.CreateForm(TBtnGridForm, BtnGridForm);
  Application.Run;
end.
