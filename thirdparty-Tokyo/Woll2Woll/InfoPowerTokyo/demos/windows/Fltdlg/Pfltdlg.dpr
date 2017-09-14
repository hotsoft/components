program Pfltdlg;

uses
  Forms,
  Filtdlg in 'FILTDLG.PAS' {FilterDialogForm};

{$R *.RES}

begin
  Application.CreateForm(TFilterDialogForm, FilterDialogForm);
  Application.Run;
end.
