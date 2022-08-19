{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSmtpServer;

interface

{$I clVer.inc}
{$IFDEF DELPHI6}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, WinSock, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.WinSock, Winapi.Windows,
{$ENDIF}
  clTcpServer, clTcpServerTls, clTcpCommandServer, clSocket, clUserMgr, clMailUtils, clEncoder,
  clSspi, clSspiAuth, clMailUserMgr, clSocketUtils;

type
  TclSmtpConnectionState = (csSmtpConnect, csSmtpHelo, csSmtpMail, csSmtpRcpt, csSmtpData);

  TclSmtpMailFromAction = (mfAccept, mfReject);

  TclSmtpMailDataAction = (mdOk, mdMailBoxFull, mdSystemFull, mdProcessingError, mdTransactionFailed);
  
  TclSmtpRcptToAction = (rtAddressOk, rtRelayDenied, rtBadAddress, rtForward, rtNotForward,
    rtTooManyAddresses, rtDisabled);

  EclSmtpServerError = class(EclTcpCommandServerError)
  end;

  TclSmtpCommandConnection = class(TclCommandConnection)
  private
    FConnectionState: TclSmtpConnectionState;
    FHostName: string;
    FUserName: string;
    FIsEHLO: Boolean;
    FIsAuthorized: Boolean;
    FCramMD5Key: string;
    FNTLMAuth: TclNtAuthServerSspi;
    FMailFrom: string;
    FRcptToList: TStrings;

    procedure Reset;
    procedure InitParams;
    procedure AssignNtlm(Auth: TclNtAuthServerSspi);
  protected
    procedure DoDestroy; override;
  public
    constructor Create;
    
    property ConnectionState: TclSmtpConnectionState read FConnectionState;
    property HostName: string read FHostName;
    property UserName: string read FUserName;
    property IsEHLO: Boolean read FIsEHLO;
    property IsAuthorized: Boolean read FIsAuthorized;
    property MailFrom: string read FMailFrom;
    property RcptToList: TStrings read FRcptToList;
  end;

  TclSmtpCommandHandler = procedure (AConnection: TclSmtpCommandConnection;
    const ACommand: string; AParameters: TclTcpCommandParams) of object;

  TclSmtpCommandInfo = class(TclTcpCommandInfo)
  private
    FHandler: TclSmtpCommandHandler;
  protected
    procedure Execute(AConnection: TclCommandConnection; AParams: TclTcpCommandParams); override;
  public
    constructor Create(const AName: string; AHandler: TclSmtpCommandHandler);
  end;

  TclSmtpAuthenticateEvent = procedure (Sender: TObject; AConnection: TclSmtpCommandConnection;
    var Account: TclMailUserAccountItem; const AUserName: string; var IsAuthorized, Handled: Boolean) of object;

  TclSmtpMailFromEvent = procedure (Sender: TObject; AConnection: TclSmtpCommandConnection;
    const AMailFrom: string; var Action: TclSmtpMailFromAction) of object;

  TclSmtpRecipientToEvent = procedure (Sender: TObject; AConnection: TclSmtpCommandConnection;
    const ARcptTo: string; var AForwardTo: string; var Action: TclSmtpRcptToAction) of object;

  TclSmtpMessageDeliveredEvent = procedure (Sender: TObject; AConnection: TclSmtpCommandConnection;
    const AMailFrom, ARecipient: string; Account: TclMailUserAccountItem; AMessage: TStrings;
    var Action: TclSmtpMailDataAction) of object;
    
  TclSmtpMessageReceivedEvent = procedure (Sender: TObject; AConnection: TclSmtpCommandConnection;
    const AMailFrom: string; ARecipients, AMessage: TStrings; var Action: TclSmtpMailDataAction) of object;

  TclSmtpConnectionEvent = procedure (Sender: TObject; AConnection: TclSmtpCommandConnection) of object;

  TclSmtpServer = class(TclTcpCommandServer)
  private
    FUserAccounts: TclMailUserAccountList;
    FUseAuth: Boolean;
    FSaslFlags: TclServerSaslFlags;
    FMaxRecipients: Integer;
    FHelpText: TStrings;
    FExtensions: TStrings;
    FHostName: string;
    
    FOnAuthenticate: TclSmtpAuthenticateEvent;
    FOnReset: TclSmtpConnectionEvent;
    FOnMailFrom: TclSmtpMailFromEvent;
    FOnRecipientTo: TclSmtpRecipientToEvent;
    FOnMessageReceived: TclSmtpMessageReceivedEvent;
    FOnMessageDelivered: TclSmtpMessageDeliveredEvent;
    FOnMessageRelayed: TclSmtpMessageReceivedEvent;
    FOnStateChanged: TclSmtpConnectionEvent;
    
    procedure HandleNullCommand(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleEHLO(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleHELO(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleAUTH(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleNOOP(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleQUIT(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleRSET(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleSTARTTLS(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleHELP(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleMAIL(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleRCPT(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleDATA(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleLogin(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleCramMD5(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleNtlm(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleMessage(AConnection: TclSmtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);

    procedure RaiseBadSequenceError(const ACommand: string);
    procedure RaiseSyntaxError(const ACommand: string);
    procedure RaiseSmtpError(const ACommand, AMessage: string; ACode: Integer);

    procedure SetHelpText(const Value: TStrings);
    procedure SetExtensions(const Value: TStrings);
    procedure SetUserAccounts(const Value: TclMailUserAccountList);
    function GetCaseInsensitive: Boolean;
    procedure SetCaseInsensitive(const Value: Boolean);

    procedure CheckAuthorized(AConnection: TclSmtpCommandConnection;
      const ACommand: string; IsAuthorized: boolean);
    function LoginAuthenticate(AConnection: TclSmtpCommandConnection;
      Account: TclMailUserAccountItem; const AUserName, APassword: string): Boolean;
    function CramMD5Authenticate(AConnection: TclSmtpCommandConnection;
      Account: TclMailUserAccountItem; const AUserName, AKey, AHash: string): Boolean;
    function NtlmAuthenticate(AConnection: TclSmtpCommandConnection;
      Account: TclMailUserAccountItem; const AUserName: string): Boolean;
    procedure CheckAuthAbort(AConnection: TclSmtpCommandConnection; const AData: string);
    function IsRoutedMail(const AEmail: string): Boolean;
    function GetMessageID(AMessage: TStrings): string;
    function GetHostName: string;
    function GetHostIP(AConnection: TclSmtpCommandConnection): string;
    procedure GetExtensions(AConnection: TclSmtpCommandConnection; AList: TStrings);
    procedure CheckState(AConnection: TclSmtpCommandConnection; const ACommand: string;
      ACheckState: TclSmtpConnectionState);
    procedure ChangeState(AConnection: TclSmtpCommandConnection; ANewState: TclSmtpConnectionState);
    procedure CheckTlsMode(AConnection: TclSmtpCommandConnection; const ACommand: string);
    procedure FillDefaultHelpText;
    function ProcessRelayed(AConnection: TclSmtpCommandConnection; AMessage: TStrings): TclSmtpMailDataAction;
    function ProcessDelivered(AConnection: TclSmtpCommandConnection; AMessage: TStrings): TclSmtpMailDataAction;
    function GetAuthData(AConnection: TclSmtpCommandConnection; const AData: string): string;
  protected
    procedure GetCommands; override;
    function GetNullCommand(AParameters: TclTcpCommandParams): TclTcpCommandInfo; override;
    procedure ProcessUnhandledError(AConnection: TclCommandConnection;
      AParameters: TclTcpCommandParams; E: Exception); override;
    procedure ProcessMaxDataSizeError(AConnection: TclCommandConnection; var Handled: Boolean); override;
    procedure DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean); override;
    function CreateDefaultConnection: TclUserConnection; override;
    procedure DoDestroy; override;

    function GenCramMD5Key: string; virtual;
    function GenMessageID: string; virtual;

    procedure DoAuthenticate(AConnection: TclSmtpCommandConnection; var Account: TclMailUserAccountItem;
      const AUserName: string; var IsAuthorized, Handled: Boolean); virtual;
    procedure DoMailFrom(AConnection: TclSmtpCommandConnection;
      const AMailFrom: string; var Action: TclSmtpMailFromAction); virtual;
    procedure DoRecipientTo(AConnection: TclSmtpCommandConnection;
      const ARcptTo: string; var AForwardTo: string; var Action: TclSmtpRcptToAction); virtual;

    procedure DoMessageReceived(AConnection: TclSmtpCommandConnection; const AMailFrom: string;
      ARecipients: TStrings; AMessage: TStrings; var Action: TclSmtpMailDataAction); virtual;
    procedure DoMessageDelivered(AConnection: TclSmtpCommandConnection; const AMailFrom, ARecipient: string;
      Account: TclMailUserAccountItem; AMessage: TStrings; var Action: TclSmtpMailDataAction); virtual;
    procedure DoMessageRelayed(AConnection: TclSmtpCommandConnection; const AMailFrom: string;
      ARecipients: TStrings; AMessage: TStrings; var Action: TclSmtpMailDataAction); virtual;

    procedure DoStateChanged(AConnection: TclSmtpCommandConnection); virtual;
    procedure DoReset(AConnection: TclSmtpCommandConnection); virtual;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Port default DefaultSmtpPort;
    property UserAccounts: TclMailUserAccountList read FUserAccounts write SetUserAccounts;
    property CaseInsensitive: Boolean read GetCaseInsensitive write SetCaseInsensitive default True;
    property UseAuth: Boolean read FUseAuth write FUseAuth default True;
    property SaslFlags: TclServerSaslFlags read FSaslFlags write FSaslFlags default [ssUseLogin, ssUseCramMD5, ssUseNTLM];
    property MaxRecipients: Integer read FMaxRecipients write FMaxRecipients default 100;
    property HelpText: TStrings read FHelpText write SetHelpText;
    property Extensions: TStrings read FExtensions write SetExtensions;
    property HostName: string read FHostName write FHostName;
    
    property OnAuthenticate: TclSmtpAuthenticateEvent read FOnAuthenticate write FOnAuthenticate;
    property OnMailFrom: TclSmtpMailFromEvent read FOnMailFrom write FOnMailFrom;
    property OnRecipientTo: TclSmtpRecipientToEvent read FOnRecipientTo write FOnRecipientTo;

    property OnMessageReceived: TclSmtpMessageReceivedEvent read FOnMessageReceived write FOnMessageReceived;
    property OnMessageDelivered: TclSmtpMessageDeliveredEvent read FOnMessageDelivered write FOnMessageDelivered;
    property OnMessageRelayed: TclSmtpMessageReceivedEvent read FOnMessageRelayed write FOnMessageRelayed;

    property OnStateChanged: TclSmtpConnectionEvent read FOnStateChanged write FOnStateChanged;
    property OnReset: TclSmtpConnectionEvent read FOnReset write FOnReset; 
  end;

implementation

uses
  clEmailAddress, clCryptMac, clUtils, clTlsSocket, clMailHeader;

{ TclSmtpServer }

constructor TclSmtpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FUserAccounts := TclMailUserAccountList.Create(Self, TclMailUserAccountItem);
  FHelpText := TStringList.Create();
  FExtensions := TStringList.Create();

  Port := DefaultSmtpPort;
  ServerName := 'Clever Internet Suite SMTP service';
  CaseInsensitive := True;
  UseAuth := True;
  SaslFlags := [ssUseLogin, ssUseCramMD5, ssUseNTLM];
  MaxRecipients := 100;
  FHostName := '';

  FillDefaultHelpText();
end;

function TclSmtpServer.CreateDefaultConnection: TclUserConnection;
begin
  Result := TclSmtpCommandConnection.Create();
end;

procedure TclSmtpServer.DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean);
begin
{$IFDEF DEMO}
{$IFNDEF STANDALONEDEMO}
  if FindWindow('TAppBuilder', nil) = 0 then
  begin
    MessageBox(0, 'This demo version can be run under Delphi/C++Builder IDE only. ' + 
      'Please visit www.clevercomponents.com to purchase your ' +
      'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    ExitProcess(1);
  end;
{$ENDIF}
{$ENDIF}

  inherited DoAcceptConnection(AConnection, Handled);
  if Handled then Exit;
  
  SendResponse(AConnection as TclCommandConnection, '', '220 ' + GetHostName() + ' ' + ServerName);
end;

procedure TclSmtpServer.GetCommands;
begin
  Commands.Add(TclSmtpCommandInfo.Create('EHLO', HandleEHLO));
  Commands.Add(TclSmtpCommandInfo.Create('HELO', HandleHELO));
  Commands.Add(TclSmtpCommandInfo.Create('AUTH', HandleAUTH));
  Commands.Add(TclSmtpCommandInfo.Create('NOOP', HandleNOOP));
  Commands.Add(TclSmtpCommandInfo.Create('QUIT', HandleQUIT));
  Commands.Add(TclSmtpCommandInfo.Create('RSET', HandleRSET));
  Commands.Add(TclSmtpCommandInfo.Create('MAIL', HandleMAIL));
  Commands.Add(TclSmtpCommandInfo.Create('RCPT', HandleRCPT));
  Commands.Add(TclSmtpCommandInfo.Create('DATA', HandleDATA));
  Commands.Add(TclSmtpCommandInfo.Create('HELP', HandleHELP));
  Commands.Add(TclSmtpCommandInfo.Create('STARTTLS', HandleSTARTTLS));
end;

procedure TclSmtpServer.GetExtensions(AConnection: TclSmtpCommandConnection; AList: TStrings);
var
  i: Integer;
  s: string;
begin
  if UseAuth then
  begin
    s := '';
    if (ssUseLogin in SaslFlags) then
    begin
      s := s + 'LOGIN ';
    end;
    if (ssUseCramMD5 in SaslFlags) then
    begin
      s := s + 'CRAM-MD5 ';
    end;
    if (ssUseNTLM in SaslFlags) then
    begin
      s := s + 'NTLM ';
    end;
    if (s <> '') then
    begin
      s := system.Copy(s, 1, Length(s) - 1);
    end;

    if (s <> '') then
    begin
      AList.Add('250-AUTH ' + s);
      AList.Add('250-AUTH=' + s);
    end;
  end;

  if (UseTLS <> stNone) and (not AConnection.IsTls) then
  begin
    AList.Add('250-STARTTLS');
  end;

  for i := 0 to Extensions.Count - 1 do
  begin
    AList.Add('250-' + Extensions[i]);
  end;
end;

function TclSmtpServer.GetHostIP(AConnection: TclSmtpCommandConnection): string;
begin
  Result := LocalBinding;
  if (Result = '') then
  begin
    Result := AConnection.NetworkStream.IP;
  end;
end;

function TclSmtpServer.GetHostName: string;
begin
  Result := HostName;
  if (Result = '') then
  begin
    Result := TclHostResolver.GetLocalHost();
  end;
end;

procedure TclSmtpServer.RaiseBadSequenceError(const ACommand: string);
begin
  RaiseSmtpError(ACommand, 'Bad sequence of commands', 503);
end;

procedure TclSmtpServer.HandleEHLO(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  s: string;
  list: TStrings;
begin
  CheckState(AConnection, ACommand, csSmtpConnect);

  s := Trim(AParameters.Parameters);
  if (s = '') then
  begin
    RaiseSmtpError(ACommand, 'EHLO requires domain address', 501);
  end;

  AConnection.FHostName := s;
  ChangeState(AConnection, csSmtpHelo);
  AConnection.FIsEHLO := True;

  if(not UseAuth) then
  begin
    AConnection.FIsAuthorized := True;
  end;

  list := TStringList.Create();
  try
    list.Add(Format('250-%s Hello %s, pleased to meet you', [GetHostName(), AConnection.HostName]));

    GetExtensions(AConnection, list);

    if (MaxDataSize > 0) then
    begin
      s := '250 SIZE ' + IntToStr(MaxDataSize);
    end else
    begin
      s := '250 HELP';
    end;

    SendMultipleLines(AConnection, list, s);
  except
    list.Free();
    raise;
  end;
end;

procedure TclSmtpServer.HandleHELO(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  s: string;
begin
  CheckState(AConnection, ACommand, csSmtpConnect);

  s := Trim(AParameters.Parameters);
  if (s = '') then
  begin
    RaiseSmtpError(ACommand, 'HELO requires domain address', 501);
  end;

  AConnection.FHostName := s;
  ChangeState(AConnection, csSmtpHelo);
  if (not UseAuth) then
  begin
    AConnection.FIsAuthorized := True;
  end;

  SendResponse(AConnection, ACommand, '250 %s Hello %s, pleased to meet you',
    [GetHostName(), AConnection.HostName]);
end;

procedure TclSmtpServer.CheckAuthAbort(AConnection: TclSmtpCommandConnection; const AData: string);
begin
  if (Trim(AData) = '*') then
  begin
    AConnection.InitParams();
    AConnection.FConnectionState := csSmtpHelo;
    RaiseSmtpError('AUTH', 'Authentication aborted', 501);
  end;
end;

procedure TclSmtpServer.CheckAuthorized(AConnection: TclSmtpCommandConnection;
  const ACommand: string; IsAuthorized: boolean);
begin
  if (Guard <> nil) then
  begin
    IsAuthorized := Guard.Login(AConnection.UserName, IsAuthorized, AConnection.PeerIP, Port);
  end;

  if (not IsAuthorized) then
  begin
    AConnection.InitParams();
    AConnection.FConnectionState := csSmtpHelo;
    RaiseSmtpError(ACommand, 'Authentication failed', 535);
  end;
end;

procedure TclSmtpServer.CheckState(AConnection: TclSmtpCommandConnection;
  const ACommand: string; ACheckState: TclSmtpConnectionState);
begin
  if (AConnection.ConnectionState <> ACheckState) then
  begin
    RaiseBadSequenceError(ACommand);
  end;
end;

procedure TclSmtpServer.DoMessageDelivered(AConnection: TclSmtpCommandConnection; const AMailFrom, ARecipient: string;
  Account: TclMailUserAccountItem; AMessage: TStrings; var Action: TclSmtpMailDataAction);
begin
  if Assigned(OnMessageDelivered) then
  begin
    OnMessageDelivered(Self, AConnection, AMailFrom, ARecipient, Account, AMessage, Action);
  end;
end;

procedure TclSmtpServer.DoMessageReceived(AConnection: TclSmtpCommandConnection; const AMailFrom: string;
  ARecipients: TStrings; AMessage: TStrings; var Action: TclSmtpMailDataAction);
begin
  if Assigned(OnMessageReceived) then
  begin
    OnMessageReceived(Self, AConnection, AMailFrom, ARecipients, AMessage, Action);
  end;
end;

procedure TclSmtpServer.DoMessageRelayed(AConnection: TclSmtpCommandConnection; const AMailFrom: string;
  ARecipients, AMessage: TStrings; var Action: TclSmtpMailDataAction);
begin
  if Assigned(OnMessageRelayed) then
  begin
    OnMessageRelayed(Self, AConnection, AMailFrom, ARecipients, AMessage, Action);
  end;
end;

procedure TclSmtpServer.DoAuthenticate(AConnection: TclSmtpCommandConnection;
  var Account: TclMailUserAccountItem; const AUserName: string; var IsAuthorized, Handled: Boolean);
begin
  if Assigned(OnAuthenticate) then
  begin
    OnAuthenticate(Self, AConnection, Account, AUserName, IsAuthorized, Handled);
  end;
end;

function TclSmtpServer.LoginAuthenticate(AConnection: TclSmtpCommandConnection;
  Account: TclMailUserAccountItem; const AUserName, APassword: string): Boolean;
var
  handled: Boolean;
begin
  handled := False;
  Result := False;
  DoAuthenticate(AConnection, Account, AUserName, Result, handled);
  if (not handled) and (Account <> nil) then
  begin
    Result := Account.Authenticate(APassword);
  end;
end;

function TclSmtpServer.CramMD5Authenticate(AConnection: TclSmtpCommandConnection;
  Account: TclMailUserAccountItem; const AUserName, AKey, AHash: string): Boolean;
var
  handled: Boolean;
  calculated: string;
begin
  handled := False;
  Result := False;
  DoAuthenticate(AConnection, Account, AUserName, Result, handled);
  if (not handled) and (Account <> nil) then
  begin
    calculated := HMAC_MD5(AKey, Account.Password);
    Result := (calculated = AHash);
  end;
end;

function TclSmtpServer.GenCramMD5Key: string;
begin
  Result := GenerateCramMD5Key(GetHostName());
end;

function TclSmtpServer.GenMessageID: string;
begin
  Result := GenerateMessageID(GetHostName());
end;

procedure TclSmtpServer.HandleAUTH(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  method: string;
  s: string;
  paramList: TStrings;
begin
  CheckTlsMode(AConnection, ACommand);
  if AConnection.IsAuthorized or (not AConnection.IsEHLO) then
  begin
    RaiseBadSequenceError(ACommand);
  end;

  if (not UseAuth) then
  begin
    RaiseBadSequenceError(ACommand);
  end;

  paramList := TStringList.Create();
  try
    ExtractQuotedWords(AParameters.Parameters, paramList);
    if (paramList.Count = 0) then
    begin
      RaiseSmtpError(ACommand, 'Unrecognized authentication type', 504);
    end;

    method := UpperCase(paramList[0]);
    if (method = 'LOGIN') and (ssUseLogin in SaslFlags) then
    begin
      AcceptLines(AConnection, TclSmtpCommandInfo.Create(ACommand, HandleLogin));

      if (paramList.Count > 1) then
      begin
        HandleLogin(AConnection, 'LOGIN', TclTcpCommandParams.Create('LOGIN', paramList[1]));
      end else
      begin
        s := TclEncoder.EncodeToString('Username:', cmBase64);
        SendResponse(AConnection, ACommand, '334 ' + s);
      end;
    end else
    if (method = 'CRAM-MD5') and (ssUseCramMD5 in SaslFlags) then
    begin
      AcceptLines(AConnection, TclSmtpCommandInfo.Create(ACommand, HandleCramMD5));

      AConnection.FCramMD5Key := GenCramMD5Key();
      s := TclEncoder.EncodeToString(AConnection.FCramMD5Key, cmBase64);
      SendResponse(AConnection, ACommand, '334 ' + s);
    end else
    if (method = 'NTLM') and (ssUseNTLM in SaslFlags) then
    begin
      AConnection.AssignNtlm(TclNtAuthServerSspi.Create());
      AcceptLines(AConnection, TclSmtpCommandInfo.Create(ACommand, HandleNtlm));

      if (paramList.Count > 1) then
      begin
        HandleNtlm(AConnection, 'NTLM', TclTcpCommandParams.Create('NTLM', paramList[1]));
      end else
      begin
        SendResponse(AConnection, ACommand, '334');
      end;
    end else
    begin
      RaiseSmtpError(ACommand, 'Unrecognized authentication type', 504);
    end;
  finally
    paramList.Free();
  end;
end;

procedure TclSmtpServer.HandleNOOP(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
begin
  SendResponse(AConnection, ACommand, '250 OK');
end;

procedure TclSmtpServer.HandleQUIT(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
begin
  try
    SendResponseAndClose(AConnection, ACommand, '221 ' + GetHostName() + ' closing connection');
  except
    on EclSocketError do ;
  end;
end;

procedure TclSmtpServer.HandleRCPT(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  ind: Integer;
  name, email, forwardTo: string;
  action: TclSmtpRcptToAction;
  isRouted: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);
  if not (AConnection.ConnectionState in [csSmtpMail, csSmtpRcpt]) then
  begin
    RaiseBadSequenceError(ACommand);
  end;
  
  ind := system.Pos('TO:', UpperCase(AParameters.Parameters));
  if (ind = 0) then
  begin
    RaiseSyntaxError(ACommand);
  end;
  GetEmailAddressParts(system.Copy(AParameters.Parameters, ind + Length('TO:'), 1000), name, email);

  if (email <> '') then
  begin
    action := rtAddressOk;
    isRouted := IsRoutedMail(email);
    if (AConnection.RcptToList.Count >= MaxRecipients) then
    begin
      action := rtTooManyAddresses;
    end else
    if isRouted then
    begin
      action := rtRelayDenied;
    end else
    if (UserAccounts.AccountByEmail(email) = nil) and (not AConnection.IsAuthorized) then
    begin
      action := rtRelayDenied;
    end;
  end else
  begin
    action := rtBadAddress;
  end;

  DoRecipientTo(AConnection, email, forwardTo, action);

  case action of
    rtAddressOk:
      begin
        ChangeState(AConnection, csSmtpRcpt);
        AConnection.FRcptToList.Add(email);
        SendResponse(AConnection, ACommand, '250 <%s> Recipient ok', [email]);
      end;
    rtForward:
      begin
        ChangeState(AConnection, csSmtpRcpt);
        AConnection.FRcptToList.Add(forwardTo);
        SendResponse(AConnection, ACommand, '250 <%s> Recipient ok', [email]);
      end;
    rtRelayDenied: RaiseSmtpError(ACommand, Format('<%s> Relay denied', [email]), 550);
    rtNotForward: RaiseSmtpError(ACommand, Format('<%s> User not local; please try <%s>', [email, forwardTo]), 551);
    rtTooManyAddresses: RaiseSmtpError(ACommand, 'Too many recipients', 452);
    rtDisabled: RaiseSmtpError(ACommand, Format('<%s> Account disabled', [email]), 550);
  else
    RaiseSmtpError(ACommand, Format('<%s> Invalid address', [email]), 500);
  end;
end;

function TclSmtpServer.IsRoutedMail(const AEmail: string): Boolean;
var
  i, cnt: Integer;
begin
  cnt := 0;
  for i := 1 to Length(AEmail) do
  begin
    if (AEmail[i] = '@') then
    begin
      Inc(cnt);
    end;
    if (cnt > 1) then
    begin
      Result := True;
      Exit;
    end;
  end;

  Result := False;
end;

procedure TclSmtpServer.HandleMAIL(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  ind: Integer;
  name, email: string;
  action: TclSmtpMailFromAction;
  isRouted: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckState(AConnection, ACommand, csSmtpHelo);

  ind := system.Pos('FROM:', UpperCase(AParameters.Parameters));
  if (ind = 0) then
  begin
    RaiseSyntaxError(ACommand);
  end;
  GetEmailAddressParts(system.Copy(AParameters.Parameters, ind + Length('FROM:'), 1000), name, email);

  action := mfAccept;
  isRouted := IsRoutedMail(email);
  if isRouted then
  begin
    action := mfReject;
  end;

  DoMailFrom(AConnection, email, action);

  if (action = mfAccept) then
  begin
    ChangeState(AConnection, csSmtpMail);
    AConnection.FMailFrom := email;
    SendResponse(AConnection, ACommand, '250 <%s> Sender ok', [email]);
  end else
  if isRouted then
  begin
    RaiseSmtpError(ACommand, 'This server does not accept routed mail', 553);
  end else
  begin
    RaiseSmtpError(ACommand, Format('<%s> Sender not permitted', [email]), 553);
  end;
end;

procedure TclSmtpServer.HandleDATA(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
begin
  CheckTlsMode(AConnection, ACommand);
  CheckState(AConnection, ACommand, csSmtpRcpt);
  ChangeState(AConnection, csSmtpData);

  AcceptMultipleLines(AConnection, TclSmtpCommandInfo.Create(ACommand, HandleMessage));
  SendResponse(AConnection, ACommand, '354 Start mail input, end with <CRLF>.<CRLF>');
end;

procedure TclSmtpServer.HandleRSET(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
begin
  CheckTlsMode(AConnection, ACommand);
  AConnection.Reset();
  if (AConnection.ConnectionState <> csSmtpConnect) then
  begin
    ChangeState(AConnection, csSmtpHelo);
  end;
  DoReset(AConnection);
  SendResponse(AConnection, ACommand, '250 Reset state');
end;

procedure TclSmtpServer.SetUserAccounts(const Value: TclMailUserAccountList);
begin
  FUserAccounts.Assign(Value);
end;

function TclSmtpServer.GetCaseInsensitive: Boolean;
begin
  Result := FUserAccounts.CaseInsensitive;
end;

procedure TclSmtpServer.SetCaseInsensitive(const Value: Boolean);
begin
  FUserAccounts.CaseInsensitive := Value;
end;

procedure TclSmtpServer.SetExtensions(const Value: TStrings);
begin
  FExtensions.Assign(Value);
end;

procedure TclSmtpServer.RaiseSmtpError(const ACommand, AMessage: string; ACode: Integer);
begin
  raise EclSmtpServerError.Create(ACommand, Format('%d %s', [ACode, AMessage]), ACode);
end;

procedure TclSmtpServer.RaiseSyntaxError(const ACommand: string);
begin
  RaiseSmtpError(ACommand, 'Syntax error in parameters or arguments', 501);
end;

procedure TclSmtpServer.DoMailFrom(AConnection: TclSmtpCommandConnection;
  const AMailFrom: string; var Action: TclSmtpMailFromAction);
begin
  if Assigned(OnMailFrom) then
  begin
    OnMailFrom(Self, AConnection, AMailFrom, Action);
  end;
end;

procedure TclSmtpServer.DoRecipientTo(AConnection: TclSmtpCommandConnection;
  const ARcptTo: string; var AForwardTo: string; var Action: TclSmtpRcptToAction);
begin
  if Assigned(OnRecipientTo) then
  begin
    OnRecipientTo(Self, AConnection, ARcptTo, AForwardTo, Action);
  end;
end;

procedure TclSmtpServer.DoReset(AConnection: TclSmtpCommandConnection);
begin
  if Assigned(OnReset) then
  begin
    OnReset(Self, AConnection);
  end;
end;

procedure TclSmtpServer.DoDestroy;
begin
  FExtensions.Free();
  FHelpText.Free();
  FUserAccounts.Free();
  inherited DoDestroy();
end;

function TclSmtpServer.GetMessageID(AMessage: TStrings): string;
var
  fieldList: TclMailHeaderFieldList;
begin
  fieldList := TclMailHeaderFieldList.Create('', cmNone, DefaultCharsPerLine);
  try
    fieldList.Parse(0, AMessage);
    Result := fieldList.GetFieldValue('Message-ID');
  finally
    fieldList.Free();
  end;
end;

procedure TclSmtpServer.ChangeState(AConnection: TclSmtpCommandConnection; ANewState: TclSmtpConnectionState);
begin
  if (AConnection.ConnectionState <> ANewState) then
  begin
    AConnection.FConnectionState := ANewState;
    DoStateChanged(AConnection);
  end;
end;

procedure TclSmtpServer.DoStateChanged(AConnection: TclSmtpCommandConnection);
begin
  if Assigned(OnStateChanged) then
  begin
    OnStateChanged(Self, AConnection);
  end;
end;

function TclSmtpServer.GetNullCommand(AParameters: TclTcpCommandParams): TclTcpCommandInfo;
begin
  Result := TclSmtpCommandInfo.Create(AParameters.Command, HandleNullCommand);
end;

procedure TclSmtpServer.HandleNullCommand(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
begin
  RaiseSmtpError(ACommand, 'Syntax error, command unrecognized: ' + ACommand, 500);
end;

function TclSmtpServer.GetAuthData(AConnection: TclSmtpCommandConnection; const AData: string): string;
begin
  Result := '';
  try
    CheckAuthAbort(AConnection, AData);
    Result := TclEncoder.Decode(Trim(AData), cmBase64);
  except
    on EclEncoderError do
    begin
      CheckAuthAbort(AConnection, '*');
    end;
  end;
end;

procedure TclSmtpServer.HandleLogin(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  data: string;
  isAuthorized: Boolean;
begin
  try
    data := GetAuthData(AConnection, AParameters.Parameters);

    if (AConnection.UserName = '') then
    begin
      AConnection.FUserName := data;
      data := TclEncoder.EncodeToString('Password:', cmBase64);
      SendResponse(AConnection, ACommand, '334 ' + data);
    end else
    begin
      isAuthorized := LoginAuthenticate(AConnection, UserAccounts.AccountByUserName(AConnection.UserName),
        AConnection.UserName, data);
      CheckAuthorized(AConnection, ACommand, isAuthorized);

      AConnection.FIsAuthorized := True;
      AcceptCommands(AConnection);
      SendResponse(AConnection, ACommand, '235 Authentication successful');
    end;
  except
    AcceptCommands(AConnection);
    raise;
  end;
end;

procedure TclSmtpServer.HandleCramMD5(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  data: string;
  isAuthorized: Boolean;
begin
  try
    data := GetAuthData(AConnection, AParameters.Parameters);

    if (WordCount(data, [' ']) <> 2) then
    begin
      CheckAuthAbort(AConnection, '*');
    end;

    AConnection.FUserName := ExtractWord(1, data, [' ']);
    data := ExtractWord(2, data, [' ']);

    isAuthorized := CramMD5Authenticate(AConnection, UserAccounts.AccountByUserName(AConnection.UserName),
      AConnection.UserName, AConnection.FCramMD5Key, data);
    CheckAuthorized(AConnection, ACommand, isAuthorized);

    AConnection.FIsAuthorized := True;
    AcceptCommands(AConnection);
    SendResponse(AConnection, ACommand, '235 Authentication successful');
  except
    AcceptCommands(AConnection);
    raise;
  end;
end;

procedure TclSmtpServer.HandleNtlm(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  buf: TStream;
  challenge: string;
  isAuthorized: Boolean;
begin
  try
    CheckAuthAbort(AConnection, AParameters.Parameters);

    buf := TMemoryStream.Create();
    try
      try
        TclEncoder.Decode(AParameters.Parameters, buf, cmBase64);

        buf.Position := 0;

        if AConnection.FNTLMAuth.GenChallenge('NTLM', buf, nil) then
        begin
          AConnection.FNTLMAuth.ImpersonateUser();
          try
            AConnection.FUserName := GetCurrentThreadUser();

            isAuthorized := NtlmAuthenticate(AConnection,
              UserAccounts.AccountByUserName(AConnection.UserName), AConnection.UserName);
            CheckAuthorized(AConnection, ACommand, isAuthorized);
          finally
            AConnection.FNTLMAuth.RevertUser();
          end;

          AConnection.FIsAuthorized := True;
          AcceptCommands(AConnection);
          SendResponse(AConnection, ACommand, '235 Authentication successful');
        end else
        begin
          challenge := TclEncoder.EncodeToString(buf, cmBase64);
          SendResponse(AConnection, ACommand, '334 ' + challenge);
        end;
      except
        on EclEncoderError do
        begin
          CheckAuthAbort(AConnection, '*');
        end;
        on EclSspiError do
        begin
          CheckAuthAbort(AConnection, '*');
        end;
      end;
    finally
      buf.Free();
    end;
  except
    AcceptCommands(AConnection);
    raise;
  end;
end;

function TclSmtpServer.ProcessRelayed(AConnection: TclSmtpCommandConnection; AMessage: TStrings): TclSmtpMailDataAction;
var
  i: Integer;
  list: TStrings;
  s: string;
begin
  list := TStringList.Create();
  try
    Result := mdOk;
    i := 0;
    while (i < AConnection.RcptToList.Count) do
    begin
      s := AConnection.RcptToList[i];
      if (UserAccounts.AccountByEmail(s) = nil) then
      begin
        list.Add(s);
      end;
      Inc(i);
    end;

    if (list.Count > 0) then
    begin
      DoMessageRelayed(AConnection, AConnection.MailFrom, list, AMessage, Result);
    end;
  finally
    list.Free();
  end;
end;

function TclSmtpServer.ProcessDelivered(AConnection: TclSmtpCommandConnection; AMessage: TStrings): TclSmtpMailDataAction;
var
  i: Integer;
  recipient: string;
  account: TclMailUserAccountItem;
begin
  Result := mdOk;
  i := 0;
  while (i < AConnection.RcptToList.Count) and (Result = mdOk) do
  begin
    recipient := AConnection.RcptToList[i];
    account := UserAccounts.AccountByEmail(recipient);
    if (account <> nil) then
    begin
      DoMessageDelivered(AConnection, AConnection.MailFrom, recipient, account, AMessage, Result);
    end;
    Inc(i);
  end;
end;

procedure TclSmtpServer.ProcessMaxDataSizeError(AConnection: TclCommandConnection; var Handled: Boolean);
begin
  Handled := True;
  AcceptCommands(AConnection);
  SendResponse(AConnection, '', '552 Requested action aborted: exceeded storage allocation');
end;

procedure TclSmtpServer.HandleMessage(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  action: TclSmtpMailDataAction;
  msg: TStrings;
  messageID: string;
begin
  AcceptCommands(AConnection);
  try
    ChangeState(AConnection, csSmtpHelo);

    msg := AParameters.RawData;

    msg.Insert(0, Format('Received: from %s [%s]', [AConnection.HostName, AConnection.PeerIP]));
    msg.Insert(1, Format(#9'by %s [%s];', [GetHostName(), GetHostIP(AConnection)]));
    msg.Insert(2, #9 + DateTimeToMimeTime(Now()));

    messageID := GetMessageID(msg);
    if (messageID = '') then
    begin
      messageID := GenMessageID();
      msg.Insert(3, 'Message-ID: ' + messageID);
    end;

    action := mdOk;
    DoMessageReceived(AConnection, AConnection.MailFrom, AConnection.RcptToList, msg, action);

    if (action = mdOk) then
    begin
      action := ProcessRelayed(AConnection, msg);

      if (action = mdOk) then
      begin
        msg.Insert(0, 'Return-path: <' + AConnection.MailFrom + '>');
        action := ProcessDelivered(AConnection, msg);
      end;
    end;

    case action of
      mdOk: SendResponse(AConnection, ACommand, '250 Ok');
      mdMailBoxFull: RaiseSmtpError(ACommand, 'Requested mail action aborted: exceeded storage allocation', 552);
      mdSystemFull: RaiseSmtpError(ACommand, 'Requested action not taken: insufficient system storage', 452);
      mdProcessingError: RaiseSmtpError(ACommand, 'Requested action aborted: error in processing', 451);
    else
      RaiseSmtpError(ACommand, 'Transaction failed', 554);
    end;
  finally
    AConnection.Reset();
  end;
end;

procedure TclSmtpServer.ProcessUnhandledError(AConnection: TclCommandConnection;
  AParameters: TclTcpCommandParams; E: Exception);
begin
  SendResponse(AConnection, AParameters.Command, '451 Requested action aborted: unknown server error');
end;

procedure TclSmtpServer.HandleSTARTTLS(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
begin
  if (UseTLS = stNone) then
  begin
    RaiseSmtpError(ACommand, 'TLS not available', 454);
  end;
  if (UseTLS = stImplicit) or AConnection.IsTls then
  begin
    RaiseSmtpError(ACommand, 'connection is already secured', 454);
  end;

  AConnection.InitParams();
  StartTls(AConnection);

  SendResponse(AConnection, ACommand, '220 please start a TLS connection');
end;

procedure TclSmtpServer.CheckTlsMode(AConnection: TclSmtpCommandConnection; const ACommand: string);
begin
  if (UseTLS = stExplicitRequire) and (not AConnection.IsTls) then
  begin
    RaiseSmtpError(ACommand, 'Must issue a STARTTLS command first', 530);
  end;
end;

procedure TclSmtpServer.HandleHELP(AConnection: TclSmtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  i: Integer;
  list: TStrings;
begin
  list := TStringList.Create();
  try
    list.Assign(HelpText);
    for i := 0 to list.Count - 1 do
    begin
      list[i] := '214-' + list[i];
    end;
    SendMultipleLines(AConnection, list, '214 End Of Help');
  except
    list.Free();
    raise;
  end;
end;

procedure TclSmtpServer.SetHelpText(const Value: TStrings);
begin
  FHelpText.Assign(Value);
end;

procedure TclSmtpServer.FillDefaultHelpText;
begin
  HelpText.Add('Commands Supported:');
  HelpText.Add('HELO EHLO AUTH HELP QUIT MAIL NOOP RSET RCPT DATA STARTTLS');
end;

function TclSmtpServer.NtlmAuthenticate(AConnection: TclSmtpCommandConnection;
  Account: TclMailUserAccountItem; const AUserName: string): Boolean;
var
  handled: Boolean;
begin
  handled := False;
  Result := True;
  DoAuthenticate(AConnection, Account, AUserName, Result, handled);
end;

{ TclSmtpCommandConnection }

procedure TclSmtpCommandConnection.AssignNtlm(Auth: TclNtAuthServerSspi);
begin
  FNTLMAuth.Free();
  FNTLMAuth := Auth;
end;

constructor TclSmtpCommandConnection.Create;
begin
  inherited Create();
  FRcptToList := TStringList.Create();
  InitParams();
end;

procedure TclSmtpCommandConnection.Reset;
begin
  FMailFrom := '';
  FRcptToList.Clear();
end;

procedure TclSmtpCommandConnection.DoDestroy;
begin
  AssignNtlm(nil);
  FRcptToList.Free();
  inherited DoDestroy();
end;

procedure TclSmtpCommandConnection.InitParams;
begin
  FHostName := '';
  FIsAuthorized := False;
  FUserName := '';
  FCramMD5Key := '';
  FConnectionState := csSmtpConnect;
end;

{ TclSmtpCommandInfo }

constructor TclSmtpCommandInfo.Create(const AName: string; AHandler: TclSmtpCommandHandler);
begin
  inherited Create(AName);
  FHandler := AHandler;
end;

procedure TclSmtpCommandInfo.Execute(AConnection: TclCommandConnection; AParams: TclTcpCommandParams);
begin
  FHandler(AConnection as TclSmtpCommandConnection, Name, AParams);
end;

end.
