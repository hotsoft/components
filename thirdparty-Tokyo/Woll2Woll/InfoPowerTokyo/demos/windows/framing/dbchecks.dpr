program dbchecks;

uses
  Forms,
  dbchecku in 'dbchecku.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TCustomFramingForm, CustomFramingForm);
  Application.Run;
end.
