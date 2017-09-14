program BuildTee;

uses
  Forms,
{$IFDEF Win64}
  ppChrt in 'ppChrt.pas',
  ppChrtDP in 'ppChrtDP.pas',
  ppChrtUI in 'ppChrtUI.pas';
{$ELSE}
  ppChReg in 'ppChReg.pas';
{$ENDIF}

{$R *.RES}

begin
  Application.Initialize;
  Application.Run;
end.
