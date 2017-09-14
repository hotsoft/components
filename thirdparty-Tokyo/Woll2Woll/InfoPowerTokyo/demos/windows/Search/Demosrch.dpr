program Demosrch;

uses
  Forms,
  Search in 'SEARCH.PAS' {IncrSearch};

{$R *.RES}

begin
  Application.CreateForm(TIncrSearch, IncrSearch);
  Application.Run;
end.
