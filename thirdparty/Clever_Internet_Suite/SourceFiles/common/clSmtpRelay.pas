{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSmtpRelay;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,{$IFDEF DEMO} Windows, Forms, clCertificate, clEncoder, clMailMessage,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils,{$IFDEF DEMO} Winapi.Windows, Vcl.Forms, clCertificate, clEncoder, clMailMessage,{$ENDIF}
{$ENDIF}
  clSmtp, clDnsQuery, clMailUtils, clSocketUtils;

type
  TclSmtpRelayStatus = class
  private
    FIsSent: Boolean;
    FResponseCode: Integer;
    FResponseText: string;
    FMailServer: string;
    FDomain: string;
    FErrorCode: Integer;
    FErrorText: string;
  public
    property Domain: string read FDomain;
    property MailServer: string read FMailServer;
    property ResponseCode: Integer read FResponseCode;
    property ErrorCode: Integer read FErrorCode;
    property ErrorText: string read FErrorText;
    property ResponseText: string read FResponseText;
    property IsSent: Boolean read FIsSent;
  end;
  
  TclSmtpRelayStatusList = class
  private
    FList: TList;
    procedure Clear;
    procedure Add(AItem: TclSmtpRelayStatus);
    function GetCount: Integer;
    function GetItem(Index: Integer): TclSmtpRelayStatus;
  public
    constructor Create;
    destructor Destroy; override;
    property Items[Index: Integer]: TclSmtpRelayStatus read GetItem; default;
    property Count: Integer read GetCount;
  end;

  TclResolveMXEvent = procedure (Sender: TObject; const ADomain: string;
    AMxList: TStrings; var Handled: Boolean) of object;
  TclConnectMXEvent = procedure (Sender: TObject; const ADomain, AMailServer: string) of object;
  TclRelayMessageEvent = procedure (Sender: TObject; const ADomain: string;
    ARecipients: TStrings; ARelayStatus: TclSmtpRelayStatus) of object;

  TclSmtpRelay = class(TclSmtp)
  private
    FDns: TclDnsQuery;
    FStatusList: TclSmtpRelayStatusList;
    FOnConnectMX: TclConnectMXEvent;
    FOnDisconnectMX: TclConnectMXEvent;
    FOnRelayMessage: TclRelayMessageEvent;
    FOnResolveMX: TclResolveMXEvent;
    FIsAborted: Boolean;

    procedure SetDnsServer(const Value: string);
    function GetDnsServer: string;
    procedure ExtractDomains(AMailToList, ADomains: TStrings);
    procedure ResolveMX(const ADomain: string; AMXList: TStrings;
      AStatus: TclSmtpRelayStatus);
    function ConnectMX(const ADomain, AMXServer: string;
      AStatus: TclSmtpRelayStatus): Boolean;
    procedure SendMx(const ADomain, AMailFrom: string; AMailData,
      AMailToList: TStrings; AStatus: TclSmtpRelayStatus);
    procedure DisconnectMX(const ADomain, AMXServer: string);
  protected
    procedure DoDestroy; override;
    procedure SendMessage(const AMailFrom: string; AMailData, AMailToList: TStrings); override;
    
    procedure DoResolveMX(const ADomain: string; AMxList: TStrings; var Handled: Boolean); dynamic;
    procedure DoConnectMX(const ADomain, AMailServer: string); dynamic;
    procedure DoDisconnectMX(const ADomain, AMailServer: string); dynamic;
    procedure DoRelayMessage(const ADomain: string; ARecipients: TStrings;
      ARelayStatus: TclSmtpRelayStatus); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Abort;
    
    property StatusList: TclSmtpRelayStatusList read FStatusList;
    property IsAborted: Boolean read FIsAborted;
    property Dns: TclDnsQuery read FDns;
  published
    property DnsServer: string read GetDnsServer write SetDnsServer;

    property OnResolveMX: TclResolveMXEvent read FOnResolveMX write FOnResolveMX;
    property OnConnectMX: TclConnectMXEvent read FOnConnectMX write FOnConnectMX;
    property OnDisconnectMX: TclConnectMXEvent read FOnDisconnectMX write FOnDisconnectMX;
    property OnRelayMessage: TclRelayMessageEvent read FOnRelayMessage write FOnRelayMessage;
  end;

implementation

uses
  clSocket, clEmailAddress, clTcpClient, clSspi;

{ TclSmtpRelay }

constructor TclSmtpRelay.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FStatusList := TclSmtpRelayStatusList.Create();
  FDns := TclDnsQuery.Create(nil);
  FDns.IsRecursiveDesired := True;
end;

procedure TclSmtpRelay.DoConnectMX(const ADomain, AMailServer: string);
begin
  if Assigned(OnConnectMX) then
  begin
    OnConnectMX(Self, ADomain, AMailServer);
  end;
end;

procedure TclSmtpRelay.DoDisconnectMX(const ADomain, AMailServer: string);
begin
  if Assigned(OnDisconnectMX) then
  begin
    OnDisconnectMX(Self, ADomain, AMailServer);
  end;
end;

procedure TclSmtpRelay.DoRelayMessage(const ADomain: string;
  ARecipients: TStrings; ARelayStatus: TclSmtpRelayStatus);
begin
  if Assigned(OnRelayMessage) then
  begin
    OnRelayMessage(Self, ADomain, ARecipients, ARelayStatus);
  end;
end;

procedure TclSmtpRelay.DoResolveMX(const ADomain: string;
  AMxList: TStrings; var Handled: Boolean);
begin
  if Assigned(OnResolveMX) then
  begin
    OnResolveMX(Self, ADomain, AMxList, Handled);
  end;
end;

procedure TclSmtpRelay.ExtractDomains(AMailToList, ADomains: TStrings);
  function GetEmailDomain(const AEmail: string): string;
  var
    ind: Integer;
    s: string;
  begin
    GetEmailAddressParts(AEmail, s, Result);
    ind := system.Pos('@', Result);
    if (ind > 0) then
    begin
      system.Delete(Result, 1, ind);
    end;
  end;

var
  i: Integer;
  domain: string;
begin
  ADomains.Clear();
  for i := 0 to AMailToList.Count - 1 do
  begin
    domain := LowerCase(GetEmailDomain(AMailToList[i]));
    if (ADomains.IndexOf(domain) < 0) then
    begin
      ADomains.Add(domain);
    end;
  end;
end;

procedure TclSmtpRelay.ResolveMX(const ADomain: string; AMXList: TStrings;
  AStatus: TclSmtpRelayStatus);
var
  i: Integer;
  handled: Boolean;
  hostInfo: TclHostInfo;
begin
  try
    AStatus.FDomain := ADomain;

    AMXList.Clear();
    handled := False;
    DoResolveMX(ADomain, AMXList, handled);

    if not handled then
    begin
      FDns.ResolveMX(ADomain);

      for i := 0 to FDns.MailServers.Count - 1 do
      begin
        AMXList.Add(FDns.MailServers[i].Name);
      end;

      if (AMXList.Count = 0) then
      begin
        hostInfo := FDns.ResolveIP(ADomain);
        if (hostInfo <> nil) then
        begin
          AMXList.Add(hostInfo.IPAddress);
        end;
      end;
    end;
  except
    on E: EclSocketError do
    begin
      AStatus.FErrorCode := E.ErrorCode;
      AStatus.FErrorText := E.Message;
    end;
  end;
end;

function TclSmtpRelay.ConnectMX(const ADomain, AMXServer: string;
  AStatus: TclSmtpRelayStatus): Boolean;
begin
  Assert(not Active);

  AStatus.FMailServer := AMXServer;
  Server := AMXServer;
  try
    Open();
    DoConnectMX(ADomain, AMXServer);
  except
    on E: EclSspiError do
    begin
      AStatus.FErrorCode := E.ErrorCode;
      AStatus.FErrorText := E.Message;
      AStatus.FResponseCode := LastResponseCode;
      AStatus.FResponseText := Trim(Response.Text);
      Close();
    end;
    on E: EclSocketError do
    begin
      AStatus.FErrorCode := E.ErrorCode;
      AStatus.FErrorText := E.Message;
      AStatus.FResponseCode := LastResponseCode;
      AStatus.FResponseText := Trim(Response.Text);
      Close();
    end;
  end;
  Result := Active;
end;

procedure TclSmtpRelay.DisconnectMX(const ADomain, AMXServer: string);
begin
  Close();
  DoDisconnectMX(ADomain, AMXServer);
end;

procedure TclSmtpRelay.SendMx(const ADomain, AMailFrom: string;
  AMailData, AMailToList: TStrings; AStatus: TclSmtpRelayStatus);
var
  i: Integer;
  recipients: TStrings;
begin
  recipients := TStringList.Create();
  try
    for i := 0 to AMailToList.Count - 1 do
    begin
      if (system.Pos('@' + ADomain, LowerCase(AMailToList[i])) > 0) then
      begin
        recipients.Add(AMailToList[i]);
      end;
    end;
    try
      inherited SendMessage(AMailFrom, AMailData, recipients);
      AStatus.FIsSent := True;
    except
      on E: EclSspiError do
      begin
        AStatus.FErrorCode := E.ErrorCode;
        AStatus.FErrorText := E.Message;
      end;
      on E: EclSocketError do
      begin
        AStatus.FErrorCode := E.ErrorCode;
        AStatus.FErrorText := E.Message;
      end;
    end;
    AStatus.FResponseCode := LastResponseCode;
    AStatus.FResponseText := Trim(Response.Text);

    DoRelayMessage(ADomain, recipients, AStatus);
  finally
    recipients.Free();
  end;
end;

procedure TclSmtpRelay.SendMessage(const AMailFrom: string; AMailData, AMailToList: TStrings);
var
  i, k: Integer;
  status: TclSmtpRelayStatus;
  domains, mxServers: TStrings;
begin
{$IFDEF DEMO}
{$IFNDEF STANDALONEDEMO}
  if FindWindow('TAppBuilder', nil) = 0 then
  begin
    MessageBox(0, 'This demo version can be run under Delphi/C++Builder IDE only. ' +
      'Please visit www.clevercomponents.com to purchase your ' +
      'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    ExitProcess(1);
  end else
{$ENDIF}
  begin
{$IFNDEF IDEDEMO}
    if (not IsSmtpDemoDisplayed) and (not IsEncoderDemoDisplayed)
      and (not IsCertDemoDisplayed) and (not IsMailMessageDemoDisplayed)
      and (not IsDnsDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsSmtpDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsMailMessageDemoDisplayed := True;
    IsDnsDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  FIsAborted := False;
  FStatusList.Clear();
  Close();
  domains := nil;
  mxServers := nil;
  try
    domains := TStringList.Create();
    mxServers := TStringList.Create();

    ExtractDomains(AMailToList, domains);

    for i := 0 to domains.Count - 1 do
    begin
      if IsAborted then Exit;
      status := TclSmtpRelayStatus.Create();
      StatusList.Add(status);
      ResolveMX(domains[i], mxServers, status);

      for k := 0 to mxServers.Count - 1 do
      begin
        if IsAborted then Exit;
        if ConnectMX(domains[i], mxServers[k], status) then
        begin
          if IsAborted then Exit;
          
          SendMx(domains[i], AMailFrom, AMailData, AMailToList, status);
          DisconnectMX(domains[i], mxServers[k]);
          Break;
        end;
      end;
    end;
  finally
    mxServers.Free();
    domains.Free();
  end;
end;

procedure TclSmtpRelay.SetDnsServer(const Value: string);
begin
  if (FDns.Server <> Value) then
  begin
    FDns.Server := Value;
    Changed();
  end;
end;

function TclSmtpRelay.GetDnsServer: string;
begin
  Result := FDns.Server;
end;

procedure TclSmtpRelay.Abort;
begin
  FIsAborted := True;
  Close();
end;

procedure TclSmtpRelay.DoDestroy;
begin
  FDns.Free();
  FStatusList.Free();

  inherited DoDestroy();
end;

{ TclSmtpRelayStatusList }

procedure TclSmtpRelayStatusList.Add(AItem: TclSmtpRelayStatus);
begin
  FList.Add(AItem);
end;

procedure TclSmtpRelayStatusList.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Items[i].Free();
  end;
  FList.Clear();
end;

constructor TclSmtpRelayStatusList.Create;
begin
  inherited Create();
  FList := TList.Create();
end;

destructor TclSmtpRelayStatusList.Destroy;
begin
  Clear();
  FList.Free();
  inherited Destroy();
end;

function TclSmtpRelayStatusList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclSmtpRelayStatusList.GetItem(Index: Integer): TclSmtpRelayStatus;
begin
  Result := TclSmtpRelayStatus(FList[Index]);
end;

end.

