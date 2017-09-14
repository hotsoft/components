program Prjfltev;

uses
  Forms,
  Fltevent in 'FLTEVENT.PAS' {FilterEventForm};

{$R *.RES}

begin
  Application.CreateForm(TFilterEventForm, FilterEventForm);
  Application.Run;
end.
