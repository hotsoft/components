program Plkquery;

uses
  Forms,
  Lkquery in 'LKQUERY.PAS' {TableQueryForm};

{$R *.RES}

begin
  Application.CreateForm(TTableQueryForm, TableQueryForm);
  Application.Run;
end.
