program pgridmaster;

uses
  Forms,
  gridmasterdetail in 'gridmasterdetail.pas' {MasterDetailGridForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMasterDetailGridForm, MasterDetailGridForm);
  Application.Run;
end.
