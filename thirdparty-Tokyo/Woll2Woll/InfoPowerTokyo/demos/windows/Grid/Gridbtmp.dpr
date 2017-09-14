program Gridbtmp;

uses
  Forms,
  Grdbitmp in 'GRDBITMP.PAS' {Form1};

{$R *.RES}

begin
  Application.CreateForm(TBitmapForm, BitmapForm);
  Application.Run;
end.
