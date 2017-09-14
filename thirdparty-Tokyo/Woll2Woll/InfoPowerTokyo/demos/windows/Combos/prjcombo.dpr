program prjcombo;

uses
  Forms,
  combos in 'combos.pas' {LookupForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TLookupForm, LookupForm);
  Application.Run;
end.
