program prjcustom;

uses
  Forms,
  lkcustom in 'lkcustom.pas' {CustomComboForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TCustomComboForm, CustomComboForm);
  Application.Run;
end.
