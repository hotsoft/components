{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clFirewallUtils;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes;
{$ELSE}
  System.Classes;
{$ENDIF}

const
  DefaultFirewallPort = 1080;
  
type
  TclFirewallType = (ftSocks4, ftSocks5);

  TclFirewallSettings = class(TPersistent)
  private
    FPort: Integer;
    FPassword: string;
    FFirewallType: TclFirewallType;
    FUserName: string;
    FServer: string;
    FNeedResolveIP: Boolean;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
  published
    property FirewallType: TclFirewallType read FFirewallType write FFirewallType default ftSocks4;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
    property Server: string read FServer write FServer;
    property Port: Integer read FPort write FPort default DefaultFirewallPort;
    property NeedResolveIP: Boolean read FNeedResolveIP write FNeedResolveIP default True;
  end;

implementation

{ TclFirewallSettings }

procedure TclFirewallSettings.Assign(Source: TPersistent);
var
  Src: TclFirewallSettings;
begin
  if (Source is TclFirewallSettings) then
  begin
    Src := (Source as TclFirewallSettings);
    FirewallType  := Src.FirewallType;
    UserName := Src.UserName;
    Password := Src.Password;
    Server := Src.Server;
    Port := Src.Port;
    NeedResolveIP := Src.NeedResolveIP;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclFirewallSettings.Clear;
begin
  FFirewallType := ftSocks4;
  FPort := DefaultFirewallPort;
  FUserName := '';
  FPassword := '';
  FServer := '';
  FNeedResolveIP := True;
end;

constructor TclFirewallSettings.Create;
begin
  inherited Create;
  Clear();
end;

end.
