unit TMSSplash;

interface

uses
  ToolsApi, Windows, Classes, Graphics;

{$R TMSSPLASH.RES}

function GetTMSPackVersion:string;

implementation

const
  VERNUM = '6.9.1.1';

function GetTMSPackVersion:string;
begin
  Result := VERNUM;
end;

procedure AddSplash;
var
  bmp: TBitmap;

begin
  bmp := TBitmap.Create;
  bmp.LoadFromResourceName(HInstance, 'TMSSPLASH');
  {$IFDEF VER170}
  SplashScreenServices.AddPluginBitmap('TMS Component Pack Pro for Delphi 2005 ' + VERNUM,bmp.Handle,false,'Registered','');
  {$ENDIF}
  {$IFDEF VER180}
  {$IFNDEF VER185}
  SplashScreenServices.AddPluginBitmap('TMS Component Pack Pro for Delphi 2006 ' + VERNUM,bmp.Handle,false,'Registered','');
  {$ENDIF}
  {$IFDEF VER185}
  SplashScreenServices.AddPluginBitmap('TMS Component Pack Pro for Delphi 2007 ' + VERNUM,bmp.Handle,false,'Registered','');
  {$ENDIF}
  {$ENDIF}
  {$IFDEF VER200}
  SplashScreenServices.AddPluginBitmap('TMS Component Pack Pro for Delphi 2009 ' + VERNUM,bmp.Handle,false,'Registered','');
  {$ENDIF}
  {$IFDEF VER210}
  SplashScreenServices.AddPluginBitmap('TMS Component Pack Pro for RAD Studio 2010 ' + VERNUM,bmp.Handle,false,'Registered','');
  {$ENDIF}
  {$IFDEF VER220}
  SplashScreenServices.AddPluginBitmap('TMS Component Pack Pro for RAD Studio XE ' + VERNUM,bmp.Handle,false,'Registered','');
  {$ENDIF}
  {$IFDEF VER230}
  SplashScreenServices.AddPluginBitmap('TMS Component Pack Pro for RAD Studio XE2 ' + VERNUM,bmp.Handle,false,'Registered','');
  {$ENDIF}
  {$IFDEF VER240}
  SplashScreenServices.AddPluginBitmap('TMS Component Pack Pro for RAD Studio XE3 ' + VERNUM,bmp.Handle,false,'Registered','');
  {$ENDIF}
  {$IFDEF VER250}
  SplashScreenServices.AddPluginBitmap('TMS Component Pack Pro for RAD Studio XE4 ' + VERNUM,bmp.Handle,false,'Registered','');
  {$ENDIF}
  bmp.Free;
end;

begin
  AddSplash;
end.
