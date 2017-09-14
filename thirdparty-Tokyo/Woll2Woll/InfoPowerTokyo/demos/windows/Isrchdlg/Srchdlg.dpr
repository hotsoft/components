program Srchdlg;

uses
  Forms,
  Isearch in 'ISEARCH.PAS' {SearchForm};

{$R *.RES}

begin
  Application.CreateForm(TSearchForm, SearchForm);
  Application.Run;
end.
