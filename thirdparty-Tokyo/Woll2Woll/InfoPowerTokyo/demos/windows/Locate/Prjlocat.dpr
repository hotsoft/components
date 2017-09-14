program Prjlocat;

uses
  Forms,
  Demoloc in 'DEMOLOC.PAS' {Locate};

{$R *.RES}

begin
  Application.CreateForm(TLocate, Locate);
  Application.Run;
end.
