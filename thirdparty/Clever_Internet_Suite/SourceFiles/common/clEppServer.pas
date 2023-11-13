{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clEppServer;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows, msxml, ActiveX,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows, Winapi.msxml, Winapi.ActiveX,
{$ENDIF}
  clUtils, clTcpServer, clTcpServerTls, clThreadPool, clUserMgr, clTcpCommandServer, clEppUtils;

type
  EclEppServerError = class(EclTcpCommandServerError);

  TclEppCommandConnection = class(TclUserConnectionTls)
  private
    FRequest: TStrings;
    FRequestLength: Integer;
    FReadBytes: Integer;
    FIsAuthorized: Boolean;
    FUserName: string;
    FClientTransactionId: string;
    FLastTransactionId: Integer;
    
    function GetLastTransactionId: string;
  protected
    function GetNextTransactionId: string;
    procedure InitRequest(ARequestLength: Integer);
    function AddRequest(ARequest: TStream): Boolean;
    procedure Reset; virtual;
    procedure DoDestroy; override;
  public
    constructor Create;

    property Request: TStrings read FRequest;
    property IsAuthorized: Boolean read FIsAuthorized;
    property UserName: string read FUserName;
    property LastTransactionId: string read GetLastTransactionId;
    property ClientTransactionId: string read FClientTransactionId;
  end;

  TclEppAuthenticateEvent = procedure (Sender: TObject; AConnection: TclEppCommandConnection;
    var Account: TclUserAccountItem; const AUserName, APassword: string; var IsAuthorized, Handled: Boolean) of object;
  TclEppConnectionEvent = procedure (Sender: TObject; AConnection: TclEppCommandConnection) of object;
  TclEppCommandEvent = procedure (Sender: TObject; AConnection: TclEppCommandConnection; const ACommand: IXMLDomNode;
    var Handled: Boolean) of object;
  TclEppResponseEvent = procedure (Sender: TObject; AConnection: TclEppCommandConnection; AResponse: TStrings) of object;
    
  TclEppServer = class(TclTcpServerTls)
  private
    FVersion: string;
    FManagedExtensions: TStrings;
    FUserAccounts: TclUserAccountList;
    FPurpose: string;
    FRecipient: string;
    FAccess: string;
    FRetention: string;
    FManagedObjects: TStrings;
    FResponseLanguages: TStrings;

    FOnSendResponse: TclEppResponseEvent;
    FOnReceiveRequest: TclEppConnectionEvent;
    FOnAuthenticate: TclEppAuthenticateEvent;
    FOnReceiveCommand: TclEppCommandEvent;
    
    function GetCaseInsensitive: Boolean;
    procedure SetCaseInsensitive(const Value: Boolean);
    procedure SetManagedExtensions(const Value: TStrings);
    procedure SetManagedObjects(const Value: TStrings);
    procedure SetResponseLanguages(const Value: TStrings);
    procedure SetUserAccounts(const Value: TclUserAccountList);

    function Authenticate(AConnection: TclEppCommandConnection; Account: TclUserAccountItem;
      const AUserName, APassword: string): Boolean;
    procedure CheckAuthorized(AConnection: TclEppCommandConnection; IsAuthorized: Boolean);
    function GetResponseTitle: string;
    function GetResponseLanguages: string;
    function GetManagedServices: string;
    function GetServerDate: string;
    procedure HandleGreeting(AConnection: TclEppCommandConnection);
    procedure HandleLogin(AConnection: TclEppCommandConnection; const ACommand: IXMLDomNode);
    procedure HandleLogout(AConnection: TclEppCommandConnection; const ACommand: IXMLDomNode);
  protected
    procedure ProcessRequest(AConnection: TclEppCommandConnection; ARequest: TStream); virtual;
    procedure ProcessCommand(AConnection: TclEppCommandConnection; const ACommand: IXMLDomNode); virtual;
    procedure ProcessUnhandledError(AConnection: TclEppCommandConnection; E: Exception); virtual;

    procedure DoAuthenticate(AConnection: TclEppCommandConnection; var Account: TclUserAccountItem;
      const AUserName, APassword: string; var IsAuthorized, Handled: Boolean); virtual;
    procedure DoReceiveRequest(AConnection: TclEppCommandConnection); virtual;
    procedure DoReceiveCommand(AConnection: TclEppCommandConnection; const ACommand: IXMLDomNode; var Handled: Boolean); virtual;
    procedure DoSendResponse(AConnection: TclEppCommandConnection; AResponse: TStrings); virtual;

    function CreateDefaultConnection: TclUserConnection; override;
    procedure DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean); override;
    procedure DoReadConnection(AConnection: TclUserConnection; AData: TStream); override;
    procedure DoDestroy; override;
    function CreateThreadPool: TclThreadPool; override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure SendResponse(AConnection: TclEppCommandConnection; AResponse: TStrings);
    procedure SendResponseAndClose(AConnection: TclEppCommandConnection; AResponse: TStrings);
    function GetResponseStatus(AStatusCode: Integer; const AStatusText: string): string;
    function GetTransactionInfo(AConnection: TclEppCommandConnection): string;
  published
    property Port default DefaultEppPort;

    property UserAccounts: TclUserAccountList read FUserAccounts write SetUserAccounts;
    property CaseInsensitive: Boolean read GetCaseInsensitive write SetCaseInsensitive default True;
    property ManagedObjects: TStrings read FManagedObjects write SetManagedObjects;
    property ManagedExtensions: TStrings read FManagedExtensions write SetManagedExtensions;
    property ResponseLanguages: TStrings read FResponseLanguages write SetResponseLanguages;
    property Version: string read FVersion write FVersion;
    property Access: string read FAccess write FAccess;
    property Purpose: string read FPurpose write FPurpose;
    property Recipient: string read FRecipient write FRecipient;
    property Retention: string read FRetention write FRetention;

    property OnAuthenticate: TclEppAuthenticateEvent read FOnAuthenticate write FOnAuthenticate;
    property OnReceiveRequest: TclEppConnectionEvent read FOnReceiveRequest write FOnReceiveRequest;
    property OnReceiveCommand: TclEppCommandEvent read FOnReceiveCommand write FOnReceiveCommand;
    property OnSendResponse: TclEppResponseEvent read FOnSendResponse write FOnSendResponse;
  end;

resourcestring
  cCommandCompleted = 'Command completed successfully';
  cCommandCompletedEndSession = 'Command completed successfully; ending session';
  cUnimplementedCommand = 'Unimplemented command';
  cAuthenticationError = 'Authentication error';
  cCommandFailed = 'Command failed';
  cCommandUseError = 'Command use error';

const
  cServerTransactionPrefix = 'svtr';
  cCommandCompletedCode = 1000;
  cCommandCompletedEndSessionCode = 1500;
  cUnimplementedCommandCode = 2101;
  cAuthenticationErrorCode = 2200;
  cCommandFailedCode = 2400;
  cCommandUseErrorCode = 2002;

implementation

uses
  clXmlUtils;

{ TclEppServer }

function TclEppServer.Authenticate(AConnection: TclEppCommandConnection; Account: TclUserAccountItem;
  const AUserName, APassword: string): Boolean;
var
  handled: Boolean;
begin
  handled := False;
  Result := False;
  DoAuthenticate(AConnection, Account, AUserName, APassword, Result, handled);
  if (not handled) and (Account <> nil) then
  begin
    Result := Account.Authenticate(APassword);
  end;
end;

procedure TclEppServer.CheckAuthorized(AConnection: TclEppCommandConnection; IsAuthorized: Boolean);
begin
  if (Guard <> nil) then
  begin
    IsAuthorized := Guard.Login(AConnection.UserName, IsAuthorized, AConnection.PeerIP, Port);
  end;

  if (not IsAuthorized) then
  begin
    raise EclEppServerError.Create('login', cAuthenticationError, cAuthenticationErrorCode);
  end;
end;

constructor TclEppServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  FUserAccounts := TclUserAccountList.Create(Self, TclUserAccountItem);
  CaseInsensitive := True;
  Port := DefaultEppPort;
  ServerName := 'Clever Internet Suite EPP service';

  FManagedObjects := TStringList.Create();
  FManagedExtensions := TStringList.Create();
  FResponseLanguages := TStringList.Create();
  FResponseLanguages.Add('en');

  FVersion := '1.0';
  FAccess := '<all/>';
  FPurpose := '<admin/><other/><prov/>';
  FRecipient := '<ours/><public/><unrelated/>';
  FRetention := '<indefinite/>';
end;

function TclEppServer.CreateDefaultConnection: TclUserConnection;
begin
  Result := TclEppCommandConnection.Create();
end;

function TclEppServer.CreateThreadPool: TclThreadPool;
begin
  Result := inherited CreateThreadPool();
  Result.InitializeCOM := True;
end;

procedure TclEppServer.DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean);
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

  try
    HandleGreeting(TclEppCommandConnection(AConnection));
  except
    on E: Exception do
    begin
      ProcessUnhandledError(TclEppCommandConnection(AConnection), E);
      raise;
    end;
  end;
end;

procedure TclEppServer.DoAuthenticate(AConnection: TclEppCommandConnection; var Account: TclUserAccountItem;
  const AUserName, APassword: string; var IsAuthorized, Handled: Boolean);
begin
  if Assigned(OnAuthenticate) then
  begin
    OnAuthenticate(Self, AConnection, Account, AUserName, APassword, IsAuthorized, Handled);
  end;
end;

procedure TclEppServer.DoDestroy;
begin
  FResponseLanguages.Free();
  FManagedExtensions.Free();
  FManagedObjects.Free();
  FUserAccounts.Free();

  inherited DoDestroy();
end;

procedure TclEppServer.DoReadConnection(AConnection: TclUserConnection; AData: TStream);
var
  connection: TclEppCommandConnection;
  response: TStrings;
begin
  inherited DoReadConnection(AConnection, AData);

  connection := TclEppCommandConnection(AConnection);
  try
    ProcessRequest(connection, AData);
  except
    on E: EclTcpCommandServerError do
    begin
      response := TStringList.Create();
      try
        response.Add(GetResponseTitle());
        response.Add('<response>');
        response.Add(GetResponseStatus(E.ErrorCode, E.Message));
        response.Add(GetTransactionInfo(connection));
        response.Add('</response>');
        response.Add('</epp>');

        if (E.NeedClose) then
        begin
          SendResponseAndClose(connection, response);
        end else
        begin
          SendResponse(connection, response);
        end;
      finally
        response.Free();
      end;
    end;
    on EAbort do ;
    on E: Exception do
    begin
      ProcessUnhandledError(connection, E);
      raise;
    end;
  end;
end;

procedure TclEppServer.DoReceiveCommand(AConnection: TclEppCommandConnection; const ACommand: IXMLDomNode; var Handled: Boolean);
begin
  if Assigned(OnReceiveCommand) then
  begin
    OnReceiveCommand(Self, AConnection, ACommand, Handled);
  end;
end;

procedure TclEppServer.DoReceiveRequest(AConnection: TclEppCommandConnection);
begin
  if Assigned(OnReceiveRequest) then
  begin
    OnReceiveRequest(Self, AConnection);
  end;
end;

procedure TclEppServer.DoSendResponse(AConnection: TclEppCommandConnection; AResponse: TStrings);
begin
  if Assigned(OnSendResponse) then
  begin
    OnSendResponse(Self, AConnection, AResponse);
  end;
end;

function TclEppServer.GetCaseInsensitive: Boolean;
begin
  Result := FUserAccounts.CaseInsensitive;
end;

function TclEppServer.GetManagedServices: string;
var
  i: Integer;
begin
  if (ManagedObjects.Count < 1) then
  begin
    raise EclEppServerError.Create('greeting', cCommandFailed, cCommandFailedCode);
  end;

  Result := '';

  for i := 0 to ManagedObjects.Count - 1 do
  begin
    Result := Result + '<objURI>' + ManagedObjects[i] + '</objURI>';
  end;

  if (ManagedExtensions.Count > 0) then
  begin
    Result := Result + '<svcExtension>';
    for i := 0 to ManagedExtensions.Count - 1 do
    begin
      Result := Result + '<extURI>' + ManagedExtensions[i] + '</extURI>';
    end;
    Result := Result + '</svcExtension>';
  end;
end;

function TclEppServer.GetResponseLanguages: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to ResponseLanguages.Count - 1 do
  begin
    Result := Result + '<lang>' + ResponseLanguages[i] + '</lang>';
  end;
end;

function TclEppServer.GetResponseStatus(AStatusCode: Integer; const AStatusText: string): string;
begin
  Result := Format('<result code="%d">', [AStatusCode]);
  Result := Result + '<msg>' + AStatusText + '</msg>';
  Result := Result + '</result>';
end;

function TclEppServer.GetResponseTitle: string;
begin
  Result := '<?xml version="1.0" encoding="UTF-8" standalone="no"?>';
  Result := Result + '<epp xmlns="urn:ietf:params:xml:ns:epp-1.0" ';
  Result := Result + 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ';
  Result := Result + 'xsi:schemaLocation="urn:ietf:params:xml:ns:epp-1.0 epp-1.0.xsd">';
end;

function TclEppServer.GetServerDate: string;
begin
  Result := FormatDateTime('yyyy-mm-dd"T"hh:nn:ss"Z"', LocalTimeToGlobalTime(Now()));
end;

function TclEppServer.GetTransactionInfo(AConnection: TclEppCommandConnection): string;
begin
  Result := '<trID>';
  Result := Result + '<clTRID>' + AConnection.ClientTransactionId + '</clTRID>';
  Result := Result + AConnection.GetNextTransactionId();
  Result := Result + '</trID>';
end;

procedure TclEppServer.HandleGreeting(AConnection: TclEppCommandConnection);
var
  ms: TMemoryStream;
  response: TStrings;
begin
  ms := nil;
  response := nil;
  try
    ms := TMemoryStream.Create();
    response := TStringList.Create();

    response.Add(GetResponseTitle());
    response.Add('<greeting>');
    response.Add('<svID>' + ServerName + '</svID>');
    response.Add('<svDate>' + GetServerDate() + '</svDate>');
    response.Add('<svcMenu>');
    response.Add('<version>' + Version + '</version>');
    response.Add(GetResponseLanguages());
    response.Add(GetManagedServices());
    response.Add('</svcMenu>');
    response.Add('<dcp>');
    response.Add('<access>' + Access + '</access>');
    response.Add('<statement>');
    response.Add('<purpose>' + Purpose + '</purpose>');
    response.Add('<recipient>' + Recipient + '</recipient>');
    response.Add('<retention>' + Retention + '</retention>');
    response.Add('</statement>');
    response.Add('</dcp>');
    response.Add('</greeting>');
    response.Add('</epp>');

    SendResponse(AConnection, response);
  finally
    response.Free();
    ms.Free();
  end;
end;

procedure TclEppServer.HandleLogin(AConnection: TclEppCommandConnection; const ACommand: IXMLDomNode);
var
  loginNode: IXMLDomNode;
  password: string;
  isAuthorized: Boolean;
  response: TStrings;
begin
  loginNode := GetNodeByName(ACommand, 'login');
  AConnection.FUserName := GetNodeValueByName(loginNode, 'clID');
  password := GetNodeValueByName(loginNode, 'pw');
  isAuthorized := Authenticate(AConnection, UserAccounts.AccountByUserName(AConnection.UserName), AConnection.UserName, password);
  CheckAuthorized(AConnection, isAuthorized);

  AConnection.FIsAuthorized := True;

  response := TStringList.Create();
  try
    response.Add(GetResponseTitle());
    response.Add('<response>');
    response.Add(GetResponseStatus(cCommandCompletedCode, cCommandCompleted));
    response.Add(GetTransactionInfo(AConnection));
    response.Add('</response>');
    response.Add('</epp>');

    SendResponse(AConnection, response);
  finally
    response.Free();
  end;
end;

procedure TclEppServer.HandleLogout(AConnection: TclEppCommandConnection; const ACommand: IXMLDomNode);
var
  response: TStrings;
begin
  if (not AConnection.IsAuthorized) then
  begin
    raise EclEppServerError.Create('logout', cCommandUseError, cCommandUseErrorCode);
  end;

  response := TStringList.Create();
  try
    response.Add(GetResponseTitle());
    response.Add('<response>');
    response.Add(GetResponseStatus(cCommandCompletedEndSessionCode, cCommandCompletedEndSession));
    response.Add(GetTransactionInfo(AConnection));
    response.Add('</response>');
    response.Add('</epp>');

    SendResponse(AConnection, response);
  finally
    response.Free();
  end;
end;

procedure TclEppServer.ProcessCommand(AConnection: TclEppCommandConnection; const ACommand: IXMLDomNode);
var
  handled: Boolean;
begin
  AConnection.FClientTransactionId := GetNodeValueByName(ACommand, 'clTRID');

  handled := False;
  DoReceiveCommand(AConnection, ACommand, handled);

  if (not handled) then
  begin
    if (GetNodeByName(ACommand, 'login') <> nil) then
    begin
      HandleLogin(AConnection, ACommand);
    end else
    if (GetNodeByName(ACommand, 'logout') <> nil) then
    begin
      HandleLogout(AConnection, ACommand);
    end else
    begin
      raise EclEppServerError.Create('unknown', cUnimplementedCommand, cUnimplementedCommandCode);
    end;
  end;
end;

procedure TclEppServer.ProcessRequest(AConnection: TclEppCommandConnection; ARequest: TStream);
var
  doc: IXMLDomDocument;
  command: IXMLDomNode;
begin
  if (AConnection.AddRequest(ARequest)) then
  begin
    DoReceiveRequest(AConnection);

    doc := CoDOMDocument.Create();
    doc.loadXML(WideString(AConnection.Request.Text));
    if (not doc.parsed) then
    begin
      raise EclEppServerError.Create('unknown', doc.parseError.reason, doc.parseError.errorCode);
    end;

    command := GetNodeByName(doc.documentElement, 'command');
    if (command <> nil) then
    begin
      ProcessCommand(AConnection, command);
    end else
    if (GetNodeByName(doc.documentElement, 'hello') <> nil) then
    begin
      HandleGreeting(AConnection);
    end else
    begin
      raise EclEppServerError.Create('unknown', cUnimplementedCommand, cUnimplementedCommandCode);
    end;
  end;
end;

procedure TclEppServer.ProcessUnhandledError(AConnection: TclEppCommandConnection; E: Exception);
var
  response: TStrings;
begin
  response := TStringList.Create();
  try
    response.Add(GetResponseTitle());
    response.Add('<response>');
    response.Add(GetResponseStatus(cCommandFailedCode, E.Message));
    response.Add(GetTransactionInfo(AConnection));
    response.Add('</response>');
    response.Add('</epp>');
    SendResponse(AConnection, response);
  finally
    response.Free();
  end;
end;

procedure TclEppServer.SendResponse(AConnection: TclEppCommandConnection; AResponse: TStrings);
var
  ms: TMemoryStream;
  utils: TclStringsUtils;
begin
  ms := nil;
  utils := nil;
  try
    ms := TMemoryStream.Create();
    utils := TclStringsUtils.Create(AResponse, 'UTF-8');

    EppWriteInt32(ms, DWORD(utils.GetStringsSize() + 4));

    utils.SaveStrings(ms);

    ms.Position := 0;
    AConnection.WriteData(ms);
  finally
    utils.Free();
    ms.Free();
  end;

  DoSendResponse(AConnection, AResponse);
end;

procedure TclEppServer.SendResponseAndClose(AConnection: TclEppCommandConnection; AResponse: TStrings);
var
  ms: TMemoryStream;
  utils: TclStringsUtils;
begin
  ms := nil;
  utils := nil;
  try
    ms := TMemoryStream.Create();
    utils := TclStringsUtils.Create(AResponse, 'UTF-8');

    EppWriteInt32(ms, DWORD(utils.GetStringsSize() + 4));

    utils.SaveStrings(ms);

    ms.Position := 0;
    AConnection.WriteDataAndClose(ms);
  finally
    utils.Free();
    ms.Free();
  end;

  DoSendResponse(AConnection, AResponse);
end;

procedure TclEppServer.SetCaseInsensitive(const Value: Boolean);
begin
  FUserAccounts.CaseInsensitive := Value;
end;

procedure TclEppServer.SetManagedExtensions(const Value: TStrings);
begin
  FManagedExtensions.Assign(Value);
end;

procedure TclEppServer.SetManagedObjects(const Value: TStrings);
begin
  FManagedObjects.Assign(Value);
end;

procedure TclEppServer.SetResponseLanguages(const Value: TStrings);
begin
  FResponseLanguages.Assign(Value);
end;

procedure TclEppServer.SetUserAccounts(const Value: TclUserAccountList);
begin
  FUserAccounts.Assign(Value);
end;

{ TclEppCommandConnection }

function TclEppCommandConnection.AddRequest(ARequest: TStream): Boolean;
var
  utils: TclStringsUtils;
begin
  Result := False;

  if (ARequest.Size < 1) then Exit;

  ARequest.Position := 0;
  if (FRequestLength = 0) then
  begin
    InitRequest(EppReadInt32(ARequest));
    FReadBytes := ARequest.Size;
    Request.Clear();
  end else
  begin
    FReadBytes := FReadBytes + ARequest.Size;
  end;

  utils := TclStringsUtils.Create(Request, 'UTF-8');
  try
    utils.BatchSize := BatchSize;
    utils.AddTextStream(ARequest, True);
  finally
    utils.Free();
  end;
  if (FReadBytes >= FRequestLength) then
  begin
    FRequestLength := 0;
    Result := True;
  end;
end;

constructor TclEppCommandConnection.Create;
begin
  inherited Create();
  FRequest := TStringList.Create();
  Reset();
end;

procedure TclEppCommandConnection.DoDestroy;
begin
  FRequest.Free();
  inherited DoDestroy();
end;

function TclEppCommandConnection.GetLastTransactionId: string;
begin
  Result := cServerTransactionPrefix + IntToStr(FLastTransactionId);
end;

function TclEppCommandConnection.GetNextTransactionId: string;
begin
  Inc(FLastTransactionId);
  Result := '<svTRID>' + cServerTransactionPrefix + IntToStr(FLastTransactionId) + '</svTRID>';
end;

procedure TclEppCommandConnection.InitRequest(ARequestLength: Integer);
begin
  FRequest.Clear();
  FRequestLength := ARequestLength;
  FReadBytes := 0;
end;

procedure TclEppCommandConnection.Reset;
begin
  InitRequest(0);
  FIsAuthorized := False;
  FUserName := '';
  FLastTransactionId := 0;
end;

end.
