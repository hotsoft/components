{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clHttpUtils;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes;
{$ELSE}
  System.Classes;
{$ENDIF}

const
  DefaultHttpPort = 80;
  DefaultHttpProxyPort = 8080;

type  
  TclAuthorizationType = (atBasic, atAutoDetect);

  TclHttpVersion = (hvHttp1_0, hvHttp1_1);

  TclHttpProxySettings = class(TPersistent)
  protected
    FAuthorizationType: TclAuthorizationType;
    FUserName: string;
    FPassword: string;
    FServer: string;
    FPort: Integer;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
  published
    property  AuthorizationType: TclAuthorizationType read FAuthorizationType write FAuthorizationType default atAutoDetect;
    property  UserName: string read FUserName write FUserName;
    property  Password: string read FPassword write FPassword;
    property  Server: string read FServer write FServer;
    property  Port: Integer read FPort write FPort default DefaultHttpProxyPort;
  end;

resourcestring
  DefaultInternetAgent = 'Mozilla/4.0 (compatible; Clever Internet Suite)';

implementation

{ TclHttpProxySettings }

procedure TclHttpProxySettings.Assign(Source: TPersistent);
var
  Src: TclHttpProxySettings;
begin
  if (Source is TclHttpProxySettings) then
  begin
    Src := (Source as TclHttpProxySettings);
    AuthorizationType  := Src.AuthorizationType;
    UserName := Src.UserName;
    Password := Src.Password;
    Server := Src.Server;
    Port := Src.Port;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclHttpProxySettings.Clear;
begin
  FAuthorizationType := atAutoDetect;
  FPort := DefaultHttpProxyPort;
  FUserName := '';
  FPassword := '';
  FServer := '';
end;

constructor TclHttpProxySettings.Create;
begin
  inherited Create();
  Clear();
end;

end.
