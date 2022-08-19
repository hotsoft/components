{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clPop3Server;

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
  Classes, SysUtils, WinSock, Windows, SyncObjs, Contnrs,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.WinSock, Winapi.Windows, System.SyncObjs, System.Contnrs,
{$ENDIF}
  clTcpServer, clTcpServerTls, clTcpCommandServer, clSocket, clUserMgr, clMailUtils, clSspi,
  clSspiAuth, clMailUserMgr, clSocketUtils;

type
  TclPop3ConnectionState = (csPop3Authorization, csPop3Transaction, csPop3Update);
  TclPop3AuthMode = (pmUsePOPAuth, pmUseSASL, pmUseBoth);

  EclPop3ServerError = class(EclTcpCommandServerError)
  end;

  TclPop3MessageItem = class
  private
    FIsDeleted: Boolean;
    FSize: Integer;
    FUID: string;
  public
    constructor Create(const AUID: string; ASize: Integer);

    property UID: string read FUID write FUID;
    property Size: Integer read FSize write FSize;
    property IsDeleted: Boolean read FIsDeleted write FIsDeleted;
  end;

  TclPop3MessageList = class
  private
    FList: TObjectList;
    
    function GetItem(Index: Integer): TclPop3MessageItem;
    function GetActiveSize: Int64;
    function GetActiveCount: Integer;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(AItem: TclPop3MessageItem);
    procedure Delete(Index: Integer);
    procedure Clear;

    function MessageExists(AMessageNo: Integer): Boolean;
    procedure MarkDeleted(AMessageNo: Integer);
    procedure Reset;

    property Items[Index: Integer]: TclPop3MessageItem read GetItem; default;
    property Count: Integer read GetCount;
    property ActiveSize: Int64 read GetActiveSize;
    property ActiveCount: Integer read GetActiveCount;
  end;

  TclPop3CommandConnection = class(TclCommandConnection)
  private
    FConnectionState: TclPop3ConnectionState;
    FTimeStamp: string;
    FUserName: string;
    FCramMD5Key: string;
    FNTLMAuth: TclNtAuthServerSspi;
    FMailBox: TclPop3MessageList;

    procedure AssignNtlm(Auth: TclNtAuthServerSspi);
    procedure InitParams;
  protected
    procedure DoDestroy; override;
  public
    constructor Create;

    property ConnectionState: TclPop3ConnectionState read FConnectionState;
    property TimeStamp: string read FTimeStamp;
    property UserName: string read FUserName;
    property MailBox: TclPop3MessageList read FMailBox;
  end;

  TclPop3CommandHandler = procedure (AConnection: TclPop3CommandConnection;
    const ACommand: string; AParameters: TclTcpCommandParams) of object;

  TclPop3CommandInfo = class(TclTcpCommandInfo)
  private
    FHandler: TclPop3CommandHandler;
  protected
    procedure Execute(AConnection: TclCommandConnection; AParams: TclTcpCommandParams); override;
  public
    constructor Create(const AName: string; AHandler: TclPop3CommandHandler);
  end;

  TclPop3AuthenticateEvent = procedure (Sender: TObject; AConnection: TclPop3CommandConnection;
    var Account: TclMailUserAccountItem; const AUserName: string; var IsAuthorized, Handled: Boolean) of object;

  TclPop3MailBoxEvent = procedure (Sender: TObject; AConnection: TclPop3CommandConnection;
    AMailBox: TclPop3MessageList) of object;

  TclPop3RetrieveEvent = procedure (Sender: TObject; AConnection: TclPop3CommandConnection;
    AMessageNo: Integer; AMessage: TStrings; var Success: Boolean) of object;

  TclPop3DeleteEvent = procedure (Sender: TObject; AConnection: TclPop3CommandConnection;
    AMessageNo: Integer; var ACanDelete: Boolean) of object;

  TclPop3ConnectionEvent = procedure (Sender: TObject; AConnection: TclPop3CommandConnection) of object;

  TclPop3Server = class(TclTcpCommandServer)
  private
    FUserAccounts: TclMailUserAccountList;
    FUseAuth: TclPop3AuthMode;
    FSaslFlags: TclServerSaslFlags;
    FHelpText: TStrings;
    FHostName: string;
    
    FOnAuthenticate: TclPop3AuthenticateEvent;
    FOnMailBoxInfo: TclPop3MailBoxEvent;
    FOnRetrieve: TclPop3RetrieveEvent;
    FOnDelete: TclPop3DeleteEvent;
    FOnStateChanged: TclPop3ConnectionEvent;
    FOnReset: TclPop3ConnectionEvent;
    
    procedure HandleNullCommand(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleUSER(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandlePASS(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleAPOP(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleAUTH(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleQUIT(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleNOOP(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleSTAT(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleRETR(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleTOP(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleDELE(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleRSET(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleLIST(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleUIDL(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleSTLS(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleHELP(AConnection: TclPop3CommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);

    procedure HandleCramMD5(AConnection: TclPop3CommandConnection;
      const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleNtlm(AConnection: TclPop3CommandConnection;
      const ACommand: string; AParameters: TclTcpCommandParams);

    procedure CheckAuthorized(AConnection: TclPop3CommandConnection;
      const ACommand: string; IsAuthorized: boolean);
    function GetAuthData(AConnection: TclPop3CommandConnection; const AData: string): string;
    procedure CheckAuthAbort(AConnection: TclPop3CommandConnection; const AParams: string);
    procedure CheckTlsMode(AConnection: TclPop3CommandConnection; const ACommand: string);
    procedure CheckConnectionState(AConnection: TclPop3CommandConnection;
      const ACommand: string; ACheckState: TclPop3ConnectionState);

    procedure RaisePopError(const ACommand, AMessage: string); overload;
    procedure RaisePopError(const ACommand, AMessage: string; ANeedClose: Boolean); overload;
    procedure RaiseSyntaxError(const ACommand: string);
    procedure RaiseNotFoundError(const ACommand: string);
    
    procedure SetUserAccounts(const Value: TclMailUserAccountList);
    function GetCaseInsensitive: Boolean;
    procedure SetCaseInsensitive(const Value: Boolean);

    function LoginAuthenticate(AConnection: TclPop3CommandConnection;
      Account: TclMailUserAccountItem; const AUserName, APassword: string): Boolean;
    function PopAuthenticate(AConnection: TclPop3CommandConnection;
      Account: TclMailUserAccountItem; const AUserName, ADigest: string): Boolean;
    function CramMD5Authenticate(AConnection: TclPop3CommandConnection;
      Account: TclMailUserAccountItem; const AUserName, AKey, AHash: string): Boolean;
    function NtlmAuthenticate(AConnection: TclPop3CommandConnection;
      Account: TclMailUserAccountItem; const AUserName: string): Boolean;

    procedure ChangeState(AConnection: TclPop3CommandConnection;
      const ACommand: string; ANewState: TclPop3ConnectionState);
    function GetConnectionByUser(const AUserName: string): TclPop3CommandConnection;
    function GetHostName: string;
    function CollectMailBoxInfo(AConnection: TclPop3CommandConnection; const AFormat: string): string;
    procedure CollectActiveMessages(AConnection: TclPop3CommandConnection; AList: TStrings);
    procedure CollectActiveMessageUids(AConnection: TclPop3CommandConnection; AList: TStrings);
    procedure FillDefaultHelpText;

    procedure SetHelpText(const Value: TStrings);
  protected
    procedure GetCommands; override;
    function GetNullCommand(AParameters: TclTcpCommandParams): TclTcpCommandInfo; override;
    procedure ProcessUnhandledError(AConnection: TclCommandConnection;
      AParameters: TclTcpCommandParams; E: Exception); override;
    procedure DoCloseConnection(AConnection: TclUserConnection); override;
    procedure DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean); override;
    function CreateDefaultConnection: TclUserConnection; override;
    procedure DoDestroy; override;

    function GenTimeStamp: string; virtual;
    function GenCramMD5Key: string; virtual;

    procedure DoAuthenticate(AConnection: TclPop3CommandConnection; var Account: TclMailUserAccountItem;
      const AUserName: string; var IsAuthorized, Handled: Boolean); virtual;
    procedure DoMailBoxInfo(AConnection: TclPop3CommandConnection;
      AMailBox: TclPop3MessageList); virtual;
    procedure DoRetrieve(AConnection: TclPop3CommandConnection;
      AMessageNo: Integer; AMessage: TStrings; var Success: Boolean); virtual;
    procedure DoDelete(AConnection: TclPop3CommandConnection; AMessageNo: Integer;
      var ACanDelete: Boolean); virtual;
    procedure DoStateChanged(AConnection: TclPop3CommandConnection); virtual;
    procedure DoReset(AConnection: TclPop3CommandConnection); virtual;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Port default DefaultPop3Port;
    property UseAuth: TclPop3AuthMode read FUseAuth write FUseAuth default pmUseBoth;
    property SaslFlags: TclServerSaslFlags read FSaslFlags write FSaslFlags default [ssUseCramMD5, ssUseNTLM];
    property UserAccounts: TclMailUserAccountList read FUserAccounts write SetUserAccounts;
    property CaseInsensitive: Boolean read GetCaseInsensitive write SetCaseInsensitive default True;
    property HelpText: TStrings read FHelpText write SetHelpText;
    property HostName: string read FHostName write FHostName;

    property OnAuthenticate: TclPop3AuthenticateEvent read FOnAuthenticate write FOnAuthenticate;
    property OnMailBoxInfo: TclPop3MailBoxEvent read FOnMailBoxInfo write FOnMailBoxInfo;
    property OnRetrieve: TclPop3RetrieveEvent read FOnRetrieve write FOnRetrieve;
    property OnDelete: TclPop3DeleteEvent read FOnDelete write FOnDelete;
    property OnStateChanged: TclPop3ConnectionEvent read FOnStateChanged write FOnStateChanged;
    property OnReset: TclPop3ConnectionEvent read FOnReset write FOnReset;
  end;

const
  OkResponse = '+OK';
  ErrResponse = '-ERR';
  cMailBoxInfoFormat = '%d messages (%d octets)';
  
implementation

uses
  clTlsSocket, clUtils, clCryptHash, clCryptMac, clEncoder;

{ TclPop3Server }

constructor TclPop3Server.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FUserAccounts := TclMailUserAccountList.Create(Self, TclMailUserAccountItem);
  FHelpText := TStringList.Create();
  Port := DefaultPop3Port;
  ServerName := 'Clever Internet Suite POP3 service';
  CaseInsensitive := True;
  FUseAuth := pmUseBoth;
  SaslFlags := [ssUseCramMD5, ssUseNTLM];
  FHostName := '';

  FillDefaultHelpText();
end;

function TclPop3Server.CreateDefaultConnection: TclUserConnection;
begin
  Result := TclPop3CommandConnection.Create();
end;

procedure TclPop3Server.DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean);
var
  command: TclPop3CommandConnection;
  banner: string;
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

  command := (AConnection as TclPop3CommandConnection);
  command.FTimeStamp := GenTimeStamp();
  banner := OkResponse + ' ' + ServerName + ' ready';

  if (UseAuth in [pmUsePOPAuth, pmUseBoth]) then
  begin
    banner := banner + ' ' + command.TimeStamp;
  end;

  SendResponse(command, '', banner);
end;

procedure TclPop3Server.GetCommands;
begin
  Commands.Add(TclPop3CommandInfo.Create('USER', HandleUSER));
  Commands.Add(TclPop3CommandInfo.Create('PASS', HandlePASS));
  Commands.Add(TclPop3CommandInfo.Create('APOP', HandleAPOP));
  Commands.Add(TclPop3CommandInfo.Create('AUTH', HandleAUTH));
  Commands.Add(TclPop3CommandInfo.Create('NOOP', HandleNOOP));
  Commands.Add(TclPop3CommandInfo.Create('QUIT', HandleQUIT));
  Commands.Add(TclPop3CommandInfo.Create('RSET', HandleRSET));
  Commands.Add(TclPop3CommandInfo.Create('STAT', HandleSTAT));
  Commands.Add(TclPop3CommandInfo.Create('RETR', HandleRETR));
  Commands.Add(TclPop3CommandInfo.Create('TOP', HandleTOP));
  Commands.Add(TclPop3CommandInfo.Create('DELE', HandleDELE));
  Commands.Add(TclPop3CommandInfo.Create('LIST', HandleLIST));
  Commands.Add(TclPop3CommandInfo.Create('UIDL', HandleUIDL));
  Commands.Add(TclPop3CommandInfo.Create('STLS', HandleSTLS));
  Commands.Add(TclPop3CommandInfo.Create('HELP', HandleHELP));
end;

procedure TclPop3Server.CheckConnectionState(AConnection: TclPop3CommandConnection;
  const ACommand: string; ACheckState: TclPop3ConnectionState);
const
  states: array[TclPop3ConnectionState] of string = ('AUTHORIZATION', 'TRANSACTION', 'UPDATE');
begin
  if (AConnection.ConnectionState <> ACheckState) then
  begin
    RaisePopError(ACommand, 'that command is valid only in the ' + states[ACheckState] + ' state!');
  end;
end;

procedure TclPop3Server.HandleUSER(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
begin
  CheckTlsMode(AConnection, ACommand);
  CheckConnectionState(AConnection, ACommand, csPop3Authorization);
  if not (UseAuth in [pmUsePOPAuth, pmUseBoth]) then
  begin
    RaiseSyntaxError(ACommand);
  end;
  AConnection.FUserName := AParameters.Parameters;
  SendResponse(AConnection, ACommand, OkResponse + ' please send the PASS');
end;

procedure TclPop3Server.HandlePASS(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  isAuthorized: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckConnectionState(AConnection, ACommand, csPop3Authorization);
  if not (UseAuth in [pmUsePOPAuth, pmUseBoth]) then
  begin
    RaiseSyntaxError(ACommand);
  end;

  isAuthorized := LoginAuthenticate(AConnection,
    UserAccounts.AccountByUserName(AConnection.UserName), AConnection.UserName, AParameters.Parameters);
  CheckAuthorized(AConnection, ACommand, isAuthorized);

  ChangeState(AConnection, ACommand, csPop3Transaction);
  SendResponse(AConnection, ACommand, OkResponse + ' ' + CollectMailBoxInfo(AConnection, cMailBoxInfoFormat));
end;

procedure TclPop3Server.HandleAPOP(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  digest: string;
  isAuthorized: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckConnectionState(AConnection, ACommand, csPop3Authorization);
  if not (UseAuth in [pmUsePOPAuth, pmUseBoth]) then
  begin
    RaiseSyntaxError(ACommand);
  end;

  digest := Trim(AParameters.Parameters);
  if (WordCount(digest, [' ']) <> 2) then
  begin
    RaiseSyntaxError(ACommand);
  end;

  AConnection.FUserName := ExtractWord(1, digest, [' ']);
  digest := ExtractWord(2, digest, [' ']);

  isAuthorized := PopAuthenticate(AConnection, UserAccounts.AccountByUserName(AConnection.UserName),
    AConnection.UserName, digest);
  CheckAuthorized(AConnection, ACommand, isAuthorized);

  ChangeState(AConnection, ACommand, csPop3Transaction);
  SendResponse(AConnection, ACommand, OkResponse + ' ' + CollectMailBoxInfo(AConnection, cMailBoxInfoFormat));
end;

function TclPop3Server.LoginAuthenticate(AConnection: TclPop3CommandConnection;
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

function TclPop3Server.PopAuthenticate(AConnection: TclPop3CommandConnection;
  Account: TclMailUserAccountItem; const AUserName, ADigest: string): Boolean;
var
  handled: Boolean;
  calculated: string;
begin
  handled := False;
  Result := False;
  DoAuthenticate(AConnection, Account, AUserName, Result, handled);
  if (not handled) and (Account <> nil) then
  begin
    calculated := MD5(AConnection.TimeStamp + Account.Password);
    Result := (calculated = ADigest);
  end;
end;

procedure TclPop3Server.DoAuthenticate(AConnection: TclPop3CommandConnection;
  var Account: TclMailUserAccountItem; const AUserName: string; var IsAuthorized, Handled: Boolean);
begin
  if Assigned(OnAuthenticate) then
  begin
    OnAuthenticate(Self, AConnection, Account, AUserName, IsAuthorized, Handled);
  end;
end;

procedure TclPop3Server.HandleNOOP(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
begin
  CheckTlsMode(AConnection, ACommand);
  CheckConnectionState(AConnection, ACommand, csPop3Transaction);
  SendResponse(AConnection, ACommand, OkResponse);
end;

procedure TclPop3Server.HandleQUIT(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
begin
  try
    if (AConnection.ConnectionState = csPop3Transaction) then
    begin
      ChangeState(AConnection, ACommand, csPop3Update);
    end;
    SendResponseAndClose(AConnection, ACommand, OkResponse + ' ' + ServerName + ' connection closed');
  except
    on EclSocketError do ;
  end;
end;

procedure TclPop3Server.HandleRSET(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
begin
  CheckTlsMode(AConnection, ACommand);
  CheckConnectionState(AConnection, ACommand, csPop3Transaction);
  AConnection.MailBox.Reset();

  DoReset(AConnection);
  SendResponse(AConnection, ACommand, OkResponse);
end;

procedure TclPop3Server.HandleSTAT(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
begin
  CheckTlsMode(AConnection, ACommand);
  CheckConnectionState(AConnection, ACommand, csPop3Transaction);
  SendResponse(AConnection, ACommand, '%s %d %d',
    [OkResponse, AConnection.MailBox.ActiveCount, AConnection.MailBox.ActiveSize]);
end;

procedure TclPop3Server.HandleRETR(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  messageNo: Integer;
  msg: TStrings;
  success: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckConnectionState(AConnection, ACommand, csPop3Transaction);

  messageNo := StrToIntDef(Trim(AParameters.Parameters), 0);

  if not AConnection.MailBox.MessageExists(messageNo) then
  begin
    RaiseNotFoundError(ACommand);
  end;                             

  msg := TStringList.Create();
  try
    success := True;
    DoRetrieve(AConnection, messageNo, msg, success);
    if not success then
    begin
      RaiseNotFoundError(ACommand);
    end;

    SendResponse(AConnection, ACommand, OkResponse + ' %d', [GetStringsSize(msg)]);
    SendMultipleLines(AConnection, msg, '.');
  except
    msg.Free();
    raise;
  end;
end;

procedure TclPop3Server.HandleTOP(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  messageNo, lines, i: Integer;
  msg: TStrings;
  params: string;
  success: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckConnectionState(AConnection, ACommand, csPop3Transaction);

  params := Trim(AParameters.Parameters);

  if (WordCount(params, [#32]) < 2) then
  begin
    RaiseSyntaxError(ACommand);
  end;

  messageNo := StrToIntDef(ExtractWord(1, params, [#32]), 0);
  lines := StrToIntDef(ExtractWord(2, params, [#32]), 0);

  if not AConnection.MailBox.MessageExists(messageNo) then
  begin
    RaiseNotFoundError(ACommand);
  end;

  msg := TStringList.Create();
  try
    success := True;
    DoRetrieve(AConnection, messageNo, msg, success);
    if not success then
    begin
      RaiseNotFoundError(ACommand);
    end;

    for i := 0 to msg.Count - 1 do
    begin
      Inc(lines);
      if (msg[i] = '') then Break;
    end;

    SendResponse(AConnection, ACommand, OkResponse);
    SendMultipleLines(AConnection, msg, '.', lines);
  except
    msg.Free();
    raise;
  end;
end;

procedure TclPop3Server.HandleDELE(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  messageNo: Integer;
  canDelete: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckConnectionState(AConnection, ACommand, csPop3Transaction);

  messageNo := StrToIntDef(Trim(AParameters.Parameters), 0);
  canDelete := True;

  if not AConnection.MailBox.MessageExists(messageNo) then
  begin
    RaiseNotFoundError(ACommand);
  end;
  
  DoDelete(AConnection, messageNo, canDelete);
  if not canDelete then
  begin
    RaiseNotFoundError(ACommand);
  end;

  AConnection.MailBox.MarkDeleted(messageNo);

  SendResponse(AConnection, ACommand, '%s message %d deleted', [OkResponse, messageNo]);
end;

procedure TclPop3Server.HandleLIST(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  messageNo: Integer;
  list: TStrings;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckConnectionState(AConnection, ACommand, csPop3Transaction);

  messageNo := StrToIntDef(Trim(AParameters.Parameters), 0);

  if (messageNo > 0) then
  begin
    if not AConnection.MailBox.MessageExists(messageNo) then
    begin
      RaiseNotFoundError(ACommand);
    end;

    SendResponse(AConnection, ACommand, '%s %d %d',
      [OkResponse, messageNo, AConnection.MailBox[messageNo - 1].Size]);
  end else
  begin
    SendResponse(AConnection, ACommand, '%s %d %d',
      [OkResponse, AConnection.MailBox.ActiveCount, AConnection.MailBox.ActiveSize]);

    list := TStringList.Create();
    try
      CollectActiveMessages(AConnection, list);
      SendMultipleLines(AConnection, list, '.');
    except
      list.Free();
      raise;
    end;
  end;
end;

procedure TclPop3Server.HandleUIDL(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  messageNo: Integer;
  list: TStrings;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckConnectionState(AConnection, ACommand, csPop3Transaction);

  messageNo := StrToIntDef(Trim(AParameters.Parameters), 0);

  if (messageNo > 0) then
  begin
    if not AConnection.MailBox.MessageExists(messageNo) then
    begin
      RaiseNotFoundError(ACommand);
    end;
    SendResponse(AConnection, ACommand, '%s %d %s',
      [OkResponse, messageNo, AConnection.MailBox[messageNo - 1].UID]);
  end else
  begin
    SendResponse(AConnection, ACommand, OkResponse);

    list := TStringList.Create();
    try
      CollectActiveMessageUids(AConnection, list);
      SendMultipleLines(AConnection, list, '.');
    except
      list.Free();
      raise;
    end;
  end;
end;

procedure TclPop3Server.CollectActiveMessages(AConnection: TclPop3CommandConnection; AList: TStrings);
var
  i: Integer;
begin
  AList.Clear();
  for i := 0 to AConnection.MailBox.Count - 1 do
  begin
    if (not AConnection.MailBox[i].IsDeleted) then
    begin
      AList.Add(Format('%d %d', [i + 1, AConnection.MailBox[i].Size]));
    end;
  end;
end;

procedure TclPop3Server.CollectActiveMessageUids(AConnection: TclPop3CommandConnection; AList: TStrings);
var
  i: Integer;
begin
  AList.Clear();
  for i := 0 to AConnection.MailBox.Count - 1 do
  begin
    if (not AConnection.MailBox[i].IsDeleted) then
    begin
      AList.Add(Format('%d %s', [i + 1, AConnection.MailBox[i].UID]));
    end;
  end;
end;

procedure TclPop3Server.SetUserAccounts(const Value: TclMailUserAccountList);
begin
  FUserAccounts.Assign(Value);
end;

function TclPop3Server.GetAuthData(AConnection: TclPop3CommandConnection; const AData: string): string;
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

function TclPop3Server.GetCaseInsensitive: Boolean;
begin
  Result := FUserAccounts.CaseInsensitive;
end;

procedure TclPop3Server.SetCaseInsensitive(const Value: Boolean);
begin
  FUserAccounts.CaseInsensitive := Value;
end;

procedure TclPop3Server.RaiseSyntaxError(const ACommand: string);
begin
  RaisePopError(ACommand, 'Invalid command');
end;

procedure TclPop3Server.DoDestroy;
begin
  FHelpText.Free();
  FUserAccounts.Free();
  inherited DoDestroy();
end;

function TclPop3Server.GenTimeStamp: string;
begin
  Result := GenerateMessageID(GetHostName());
end;

procedure TclPop3Server.DoMailBoxInfo(AConnection: TclPop3CommandConnection;
  AMailBox: TclPop3MessageList);
begin
  if Assigned(OnMailBoxInfo) then
  begin
    OnMailBoxInfo(Self, AConnection, AMailBox);
  end;
end;

function TclPop3Server.CollectMailBoxInfo(AConnection: TclPop3CommandConnection;
  const AFormat: string): string;
begin
  DoMailBoxInfo(AConnection, AConnection.MailBox);
  Result := Format(AFormat, [AConnection.MailBox.ActiveCount, AConnection.MailBox.ActiveSize]);
end;

procedure TclPop3Server.RaiseNotFoundError(const ACommand: string);
begin
  RaisePopError(ACommand, 'no such message');
end;

procedure TclPop3Server.RaisePopError(const ACommand, AMessage: string;
  ANeedClose: Boolean);
begin
  raise EclPop3ServerError.Create(ACommand, ErrResponse + ' ' + AMessage, -1, ANeedClose);
end;

procedure TclPop3Server.RaisePopError(const ACommand, AMessage: string);
begin
  raise EclPop3ServerError.Create(ACommand, ErrResponse + ' ' + AMessage, -1);
end;

procedure TclPop3Server.DoRetrieve(AConnection: TclPop3CommandConnection;
  AMessageNo: Integer; AMessage: TStrings; var Success: Boolean);
begin
  if Assigned(OnRetrieve) then
  begin
    OnRetrieve(Self, AConnection, AMessageNo, AMessage, Success);
  end;
end;

procedure TclPop3Server.DoDelete(AConnection: TclPop3CommandConnection;
  AMessageNo: Integer; var ACanDelete: Boolean);
begin
  if Assigned(OnDelete) then
  begin
    OnDelete(Self, AConnection, AMessageNo, ACanDelete);
  end;
end;

procedure TclPop3Server.DoStateChanged(AConnection: TclPop3CommandConnection);
begin
  if Assigned(OnStateChanged) then
  begin
    OnStateChanged(Self, AConnection);
  end;
end;

procedure TclPop3Server.DoCloseConnection(AConnection: TclUserConnection);
var
  command: TclPop3CommandConnection;
begin
  inherited DoCloseConnection(AConnection);
  command := AConnection as TclPop3CommandConnection;
  ChangeState(command, '', csPop3Authorization);
end;

procedure TclPop3Server.DoReset(AConnection: TclPop3CommandConnection);
begin
  if Assigned(OnReset) then
  begin
    OnReset(Self, AConnection);
  end;
end;

function TclPop3Server.GetConnectionByUser(const AUserName: string): TclPop3CommandConnection;
var
  i: Integer;
begin
  for i := 0 to ConnectionCount - 1 do
  begin
    Result := (Connections[i] as TclPop3CommandConnection);
    if SameText(Result.UserName, AUserName)
      and (Result.ConnectionState = csPop3Transaction) then
    begin
      Exit;
    end;
  end;
  Result := nil;
end;

function TclPop3Server.GetHostName: string;
begin
  Result := HostName;
  if (Result = '') then
  begin
    Result := TclHostResolver.GetLocalHost();
  end;
end;

procedure TclPop3Server.ChangeState(AConnection: TclPop3CommandConnection;
  const ACommand: string; ANewState: TclPop3ConnectionState);
begin
  BeginWork();
  try
    if (AConnection.ConnectionState <> ANewState) then
    begin
      if (ANewState = csPop3Transaction) and (GetConnectionByUser(AConnection.UserName) <> nil) then
      begin
        RaisePopError(ACommand, 'maildrop already locked', True);
      end;
      AConnection.FConnectionState := ANewState;
      DoStateChanged(AConnection);
    end;
  finally
    EndWork();
  end;
end;

procedure TclPop3Server.HandleNullCommand(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
begin
  RaiseSyntaxError(ACommand);
end;

function TclPop3Server.GetNullCommand(AParameters: TclTcpCommandParams): TclTcpCommandInfo;
begin
  Result := TclPop3CommandInfo.Create(AParameters.Command, HandleNullCommand);
end;

procedure TclPop3Server.ProcessUnhandledError(AConnection: TclCommandConnection;
  AParameters: TclTcpCommandParams; E: Exception);
begin
  SendResponse(AConnection, AParameters.Command, ErrResponse + ' access denied ');
end;

procedure TclPop3Server.HandleSTLS(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
begin
  if (UseTLS = stNone) or (UseTLS = stImplicit) or AConnection.IsTls then
  begin
    RaiseSyntaxError(ACommand);
  end;

  AConnection.InitParams();
  StartTls(AConnection);
  
  SendResponse(AConnection, ACommand, OkResponse + ' start TLS negotiation');
end;

procedure TclPop3Server.CheckTlsMode(AConnection: TclPop3CommandConnection; const ACommand: string);
begin
  if (UseTLS = stExplicitRequire) and (not AConnection.IsTls) then
  begin
    RaisePopError(ACommand, 'Must issue a STLS command first');
  end;
end;

procedure TclPop3Server.HandleHELP(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  helpStr: string;
begin
  helpStr := HelpText.Text;
  helpStr := StringReplace(helpStr, #13#10, ', ', [rfReplaceAll]);
  helpStr := Trim(helpStr);
  if (helpStr <> '') and (helpStr[Length(helpStr)] = ',') then
  begin
    helpStr := ' ' + system.Copy(helpStr, 1, Length(helpStr) - 1);
  end;

  SendResponse(AConnection, ACommand, OkResponse + helpStr);
end;

procedure TclPop3Server.SetHelpText(const Value: TStrings);
begin
  FHelpText.Assign(Value);
end;

procedure TclPop3Server.FillDefaultHelpText;
begin
  HelpText.Add('Valid commands: USER');
  HelpText.Add('PASS');
  HelpText.Add('APOP');
  HelpText.Add('AUTH');
  HelpText.Add('QUIT');
  HelpText.Add('NOOP');
  HelpText.Add('HELP');
  HelpText.Add('STAT');
  HelpText.Add('RETR');
  HelpText.Add('TOP');
  HelpText.Add('DELE');
  HelpText.Add('RSET');
  HelpText.Add('LIST');
  HelpText.Add('UIDL');
  HelpText.Add('STLS');
end;

procedure TclPop3Server.HandleAUTH(AConnection: TclPop3CommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  method, s: string;
  list: TStrings;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckConnectionState(AConnection, ACommand, csPop3Authorization);

  if not (UseAuth in [pmUseSASL, pmUseBoth]) then
  begin
    RaiseSyntaxError(ACommand);
  end;

  method := UpperCase(Trim(AParameters.Parameters));

  if (method = '') then
  begin
    list := TStringList.Create();
    try
      if (ssUseNTLM in SaslFlags) then
      begin
        list.Add('NTLM');
      end;
      if (ssUseCramMD5 in SaslFlags) then
      begin
        list.Add('CRAM-MD5');
      end;
      SendResponse(AConnection, ACommand, OkResponse);
      SendMultipleLines(AConnection, list, '.');
    except
      list.Free();
      raise;
    end;
  end else
  if (method = 'CRAM-MD5') and (ssUseCramMD5 in SaslFlags) then
  begin
    AConnection.FCramMD5Key := GenCramMD5Key();
    s := TclEncoder.EncodeToString(AConnection.FCramMD5Key, cmBase64);

    AcceptLines(AConnection, TclPop3CommandInfo.Create(ACommand, HandleCramMD5));
    SendResponse(AConnection, ACommand, '+ ' + s);
  end else
  if (method = 'NTLM') and (ssUseNTLM in SaslFlags) then
  begin
    AConnection.AssignNtlm(TclNtAuthServerSspi.Create());

    AcceptLines(AConnection, TclPop3CommandInfo.Create(ACommand, HandleNtlm));
    SendResponse(AConnection, ACommand, '+ OK'); //NTLM + OK
  end else
  begin
    RaiseSyntaxError(ACommand);
  end;
end;

procedure TclPop3Server.HandleNtlm(AConnection: TclPop3CommandConnection;
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

          ChangeState(AConnection, ACommand, csPop3Transaction);
          AcceptCommands(AConnection);
          SendResponse(AConnection, ACommand, OkResponse + ' ' + CollectMailBoxInfo(AConnection, cMailBoxInfoFormat));
        end else
        begin
          challenge := TclEncoder.EncodeToString(buf, cmBase64);
          SendResponse(AConnection, ACommand, '+ ' + challenge);
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

procedure TclPop3Server.HandleCramMD5(AConnection: TclPop3CommandConnection;
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

    ChangeState(AConnection, ACommand, csPop3Transaction);
    AcceptCommands(AConnection);
    SendResponse(AConnection, ACommand, OkResponse + ' ' + CollectMailBoxInfo(AConnection, cMailBoxInfoFormat));
  except
    AcceptCommands(AConnection);
    raise;
  end;
end;

procedure TclPop3Server.CheckAuthAbort(AConnection: TclPop3CommandConnection; const AParams: string);
begin
  if (Trim(AParams) = '*') then
  begin
    AConnection.InitParams();
    RaisePopError('AUTH', 'authentication aborted');
  end;
end;

procedure TclPop3Server.CheckAuthorized(AConnection: TclPop3CommandConnection;
  const ACommand: string; IsAuthorized: boolean);
begin
  if (Guard <> nil) then
  begin
    IsAuthorized := Guard.Login(AConnection.UserName, IsAuthorized, AConnection.PeerIP, Port);
  end;

  if (not IsAuthorized) then
  begin
    AConnection.InitParams();
    RaisePopError(ACommand, 'incorrect password or account name');
  end;
end;

function TclPop3Server.GenCramMD5Key: string;
begin
  Result := GenerateCramMD5Key(GetHostName());
end;

function TclPop3Server.CramMD5Authenticate(
  AConnection: TclPop3CommandConnection; Account: TclMailUserAccountItem;
  const AUserName, AKey, AHash: string): Boolean;
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

function TclPop3Server.NtlmAuthenticate(
  AConnection: TclPop3CommandConnection; Account: TclMailUserAccountItem; const AUserName: string): Boolean;
var
  handled: Boolean;
begin
  handled := False;
  Result := True;
  DoAuthenticate(AConnection, Account, AUserName, Result, handled);
end;

{ TclPop3MessageList }

procedure TclPop3MessageList.Add(AItem: TclPop3MessageItem);
begin
  FList.Add(AItem);
end;

function TclPop3MessageList.GetItem(Index: Integer): TclPop3MessageItem;
begin
  Result := TclPop3MessageItem(FList[Index]);
end;

function TclPop3MessageList.GetActiveSize: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
  begin
    if (not Items[i].IsDeleted) then
    begin
      Result := Result + Items[i].Size;
    end;
  end;
end;

function TclPop3MessageList.GetCount: Integer;
begin
  Result := FList.Count;
end;

procedure TclPop3MessageList.Clear;
begin
  FList.Clear();
end;

constructor TclPop3MessageList.Create;
begin
  inherited Create();
  FList := TObjectList.Create(True);
end;

procedure TclPop3MessageList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TclPop3MessageList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function TclPop3MessageList.GetActiveCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
  begin
    if (not Items[i].IsDeleted) then
    begin
      Inc(Result);
    end;
  end;
end;

function TclPop3MessageList.MessageExists(AMessageNo: Integer): Boolean;
begin
  Result := (AMessageNo > 0) and (AMessageNo <= Count) and (not Items[AMessageNo - 1].IsDeleted);
end;

procedure TclPop3MessageList.MarkDeleted(AMessageNo: Integer);
begin
  Items[AMessageNo - 1].IsDeleted := True;
end;

procedure TclPop3MessageList.Reset;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Items[i].IsDeleted := False;
  end;
end;

{ TclPop3MessageItem }

{ TclPop3CommandConnection }

procedure TclPop3CommandConnection.AssignNtlm(Auth: TclNtAuthServerSspi);
begin
  FNTLMAuth.Free();
  FNTLMAuth := Auth;
end;

constructor TclPop3CommandConnection.Create;
begin
  inherited Create();
  FMailBox := TclPop3MessageList.Create();
  InitParams();
end;

procedure TclPop3CommandConnection.DoDestroy;
begin
  AssignNtlm(nil);
  FMailBox.Free();
  inherited DoDestroy();
end;

procedure TclPop3CommandConnection.InitParams;
begin
  FConnectionState := csPop3Authorization;
  FTimeStamp := '';
  FUserName := '';
  FCramMD5Key := '';
  FMailBox.Clear();
end;

{ TclPop3CommandInfo }

constructor TclPop3CommandInfo.Create(const AName: string; AHandler: TclPop3CommandHandler);
begin
  inherited Create(AName);
  FHandler := AHandler;
end;

procedure TclPop3CommandInfo.Execute(AConnection: TclCommandConnection; AParams: TclTcpCommandParams);
begin
  FHandler(AConnection as TclPop3CommandConnection, Name, AParams);
end;

{ TclPop3MessageItem }

constructor TclPop3MessageItem.Create(const AUID: string; ASize: Integer);
begin
  inherited Create();
  FUID := AUID;
  FSize := ASize;
  FIsDeleted := False;
end;

end.
