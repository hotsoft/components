program pexportdemo;

uses
  Forms,
  exportdemou in 'exportdemou.pas' {ExportForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TExportForm, ExportForm);
  Application.Run;
end.
