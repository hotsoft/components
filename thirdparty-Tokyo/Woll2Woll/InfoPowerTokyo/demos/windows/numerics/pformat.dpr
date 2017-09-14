program pformat;

uses
  Forms,
  formatu in 'formatu.pas' {FormatForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormatForm, FormatForm);
  Application.Run;
end.
