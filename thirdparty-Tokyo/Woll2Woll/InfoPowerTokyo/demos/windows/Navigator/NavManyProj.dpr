program NavManyProj;

uses
  Forms,
  NavMany in 'NavMany.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TNavigatorForm1, NavigatorForm1);
  Application.Run;
end.
