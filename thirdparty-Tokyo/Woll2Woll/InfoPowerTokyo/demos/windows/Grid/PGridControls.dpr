program PGridControls;

uses
  Forms,
  gridcontrols in 'gridcontrols.pas' {GridControlsForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TGridControlsForm, GridControlsForm);
  Application.Run;
end.
