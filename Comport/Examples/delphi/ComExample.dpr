program ComExample;

uses
  Forms,
  ComMainForm in 'ComMainForm.pas' {Form1},
  ConstantesUn in '..\..\..\..\labexpress\DM\ConstantesUn.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'TComPort ver. 2.10 example';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
