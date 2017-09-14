program PGridExpand;

uses
  Forms,
  gridexpand in 'gridexpand.pas' {GridExpandForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TGridExpandForm, GridExpandForm);
  Application.Run;
end.
