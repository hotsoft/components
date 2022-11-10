{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clImap4;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clMC, clTcpCommandClient, clMailMessage, clTcpClient, clImapUtils, clMailUtils, clSocketUtils;

type
  EclImap4Error = class(EclTcpClientError);

  TclImap4 = class(TclCustomMail)
  private
    FCommandTag: Integer;
    FMailBoxSeparator: Char;
    FCurrentMailBox: TclImap4MailBoxInfo;
    FCurrentMessage: Integer;
    FConnectionState: TclImap4ConnectionState;
    FAutoReconnect: Boolean;
    FIsTaggedCommand: Boolean;
    FTotalBytesToReceive: Integer;
    FIsFetchCommand: Boolean;

    class procedure RaiseError(const AMessage: string; AErrorCode: Integer);
    function GetNextCommandTag: string;
    function GetLastCommandTag: string;
    procedure SetAutoReconnect(const Value: Boolean);
    procedure OpenImapSession;
    procedure Login;
    procedure Logout;
    procedure Authenticate;
    procedure NtlmAuthenticate;
    procedure CramMD5Authenticate;
    procedure OAuthAuthenticate;
    procedure ParseMailBoxes(AList: TStrings; const ACommand: string);
    procedure ParseSelectedMailBox(const AName: string);
    procedure ParseSearchMessages(AList: TStrings);
    function ParseMessageSize(const AMessageId: string; AIsUid: Boolean): Int64;
    function ParseMessageUid(AIndex: Integer): string;
    function ParseMessageFlags(const AMessageId: string; AIsUid: Boolean): TclMailMessageFlags;
    procedure ParseMessage(const AMessageId: string; AMessage: TclMailMessage; AIsUid, AIsHeader: Boolean);
    function GetMessageId(const ACommand, AResponseLine: string; AIsUid: Boolean): string;
    procedure CheckMessageValid(AIndex: Integer);
    procedure CheckUidValid(const AUid: string);
    procedure CheckConnection(AStates: array of TclImap4ConnectionState);
    procedure DoDataProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
    function ExtractAppendUID(const AResponse: string): string;
    procedure CheckFetchCommand(const ACommand: string);
  protected
    function GetDefaultPort: Integer; override;
    function GetResponseCode(const AResponse: string): Integer; override;
    procedure OpenSession; override;
    procedure CloseSession; override;
    procedure SendKeepAlive; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure StartTls; override;
    procedure WaitResponse(const AOkResponses: array of Integer); override;
    procedure SendTaggedCommand(const ACommand: string; const AOkResponses: array of Integer); overload;
    procedure SendTaggedCommand(const ACommand: string; const AOkResponses: array of Integer;
      const Args: array of const); overload;

    procedure Noop;
    procedure GetCapability(AList: TStrings);
    procedure SelectMailBox(const AName: string);
    procedure ExamineMailBox(const AName: string);
    procedure CreateMailBox(const AName: string);
    procedure DeleteMailBox(const AName: string);
    procedure RenameMailBox(const ACurrentName, ANewName: string);
    procedure SubscribeMailBox(const AName: string);
    procedure UnsubscribeMailBox(const AName: string);
    procedure GetMailBoxes(AList: TStrings); overload;
    procedure GetMailBoxes(AList: TStrings; const ACriteria: string); overload;
    procedure GetMailBoxes(AList: TStrings; const AReferenceName, ACriteria: string); overload;
    procedure GetSubscribedMailBoxes(AList: TStrings); overload;
    procedure GetSubscribedMailBoxes(AList: TStrings; const ACriteria: string); overload;
    procedure GetSubscribedMailBoxes(AList: TStrings; const AReferenceName, ACriteria: string); overload;

    procedure SearchMessages(const ASearchCriteria: string; AMessageList: TStrings);
    procedure UidSearchMessages(const ASearchCriteria: string; AMessageList: TStrings);
    function GetMessageFlags(AIndex: Integer): TclMailMessageFlags;
    function UidGetMessageFlags(const AUid: string): TclMailMessageFlags;
    procedure SetMessageFlags(AIndex: Integer; AMethod: TclSetFlagsMethod; AFlags: TclMailMessageFlags);
    procedure UidSetMessageFlags(const AUid: string; AMethod: TclSetFlagsMethod; AFlags: TclMailMessageFlags);
    procedure DeleteMessage(AIndex: Integer);
    procedure UidDeleteMessage(const AUid: string);
    procedure PurgeMessages;
    procedure CopyMessage(AIndex: Integer; const ADestMailBox: string);
    procedure UidCopyMessage(const AUid, ADestMailBox: string);
    procedure CopyMessages(const AMessageSet, ADestMailBox: string);
    procedure UidCopyMessages(const AMessageSet, ADestMailBox: string);
    function GetMessageSize(AIndex: Integer): Int64;
    function UidGetMessageSize(const AUid: string): Int64;
    function GetMessageUid(AIndex: Integer): string;

    function AppendMessage(const AMailBoxName: string; AFlags: TclMailMessageFlags): string; overload;
    function AppendMessage(const AMailBoxName: string; AMessage: TclMailMessage;
      AFlags: TclMailMessageFlags): string; overload;
    function AppendMessage(const AMailBoxName: string; AMessage: TStrings;
      AFlags: TclMailMessageFlags): string; overload;
    procedure RetrieveMessage(AIndex: Integer); overload;
    procedure RetrieveMessage(AIndex: Integer; AMessage: TclMailMessage); overload;
    procedure UidRetrieveMessage(const AUid: string; AMessage: TclMailMessage);
    procedure RetrieveHeader(AIndex: Integer); overload;
    procedure RetrieveHeader(AIndex: Integer; AMessage: TclMailMessage); overload;
    procedure UidRetrieveHeader(const AUid: string; AMessage: TclMailMessage);

    property CurrentMailBox: TclImap4MailBoxInfo read FCurrentMailBox;
    property MailBoxSeparator: Char read FMailBoxSeparator;
    property CurrentMessage: Integer read FCurrentMessage;
    property ConnectionState: TclImap4ConnectionState read FConnectionState;
    property LastCommandTag: string read GetLastCommandTag;
  published
    property AutoReconnect: Boolean read FAutoReconnect write SetAutoReconnect default False;
    property Port default DefaultImapPort;
  end;

resourcestring
  MailboxNameInvalid = 'Mailbox name is invalid, it must not be empty or begin with mailbox separator';
  ArgumentInvalid = 'Function arguments are invalid';
  MailMessageNoInvalid = 'Message number is invalid, must be greater than 0';
  MailMessageUidInvalid = 'Message UID is invalid, must be numeric and greater than 0';
  ConnectionStateInvalid = 'The command is not valid in this state';

const
  IMAP_OK = 10;
  IMAP_NO = 20;
  IMAP_BAD = 30;
  IMAP_PREAUTH = 40;
  IMAP_BYE = 50;
  IMAP_CONTINUE = 60;

  MailboxNameInvalidCode = -200;
  ArgumentInvalidCode = -201;
  MailMessageNoInvalidCode = -202;
  MailMessageUidInvalidCode = -203;
  ConnectionStateInvalidCode = -204;

implementation

uses 
  clUtils, clCryptMac, clSocket, clSspiAuth, clEncoder
{$IFNDEF DELPHIXE2}
  {$IFDEF DEMO}, Forms, Windows, clCertificate{$ENDIF};
{$ELSE}
  {$IFDEF DEMO}, Vcl.Forms, Winapi.Windows, clCertificate{$ENDIF};
{$ENDIF}

const
  SetMethodLexem: array[TclSetFlagsMethod] of string = ('', '+', '-');

{ TclImap4 }

constructor TclImap4.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCurrentMailBox := TclImap4MailBoxInfo.Create();
  FConnectionState := csNonAuthenticated;
  FAutoReconnect := False;
  FIsTaggedCommand := False;
  FIsFetchCommand := False;
  FMailBoxSeparator := '/';
end;

procedure TclImap4.CloseSession;
begin
  Logout();
end;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

procedure TclImap4.OpenSession;
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
    if (not IsDemoDisplayed) and (not IsEncoderDemoDisplayed)
      and (not IsCertDemoDisplayed) and (not IsMailMessageDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsMailMessageDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  WaitResponse([IMAP_OK, IMAP_PREAUTH]);

  FCommandTag := 0;
  ExplicitStartTls();

  OpenImapSession();
end;

procedure TclImap4.Login;
begin
  if (Password <> '') then
  begin
    SendTaggedCommand('LOGIN "%s" "%s"', [IMAP_OK], [UserName, Password]);
  end else
  begin
    SendTaggedCommand('LOGIN "%s"', [IMAP_OK], [UserName]);
  end;
end;

procedure TclImap4.CramMD5Authenticate;
var
  respLine, challenge: string;
begin
  SendTaggedCommand('AUTHENTICATE CRAM-MD5', [IMAP_CONTINUE]);

  respLine := Copy(Response.Text, 3, MaxInt);
  challenge := TclEncoder.Decode(respLine, cmBase64);
  respLine := UserName + ' ' + HMAC_MD5(challenge, Password);
  respLine := TclEncoder.EncodeToString(respLine, cmBase64);

  SendCommandSync(respLine, [IMAP_OK]);
end;

procedure TclImap4.NtlmAuthenticate;
var
  sspi: TclNtAuthClientSspi;
  encoder: TclEncoder;
  buf: TStream;
  authIdentity: TclAuthIdentity;
  challenge: string;
begin
  SendTaggedCommand('AUTHENTICATE NTLM', [IMAP_CONTINUE]);

  sspi := nil;
  encoder := nil;
  buf := nil;
  authIdentity := nil;
  try
    sspi := TclNtAuthClientSspi.Create();
    encoder := TclEncoder.Create(nil);
    encoder.SuppressCrlf := True;
    encoder.EncodeMethod := cmBase64;

    buf := TMemoryStream.Create();

    if (UserName <> '') then
    begin
      authIdentity := TclAuthIdentity.Create(UserName, Password);
    end;

    while not sspi.GenChallenge('NTLM', buf, Server, authIdentity) do
    begin
      buf.Position := 0;
      challenge := encoder.Encode(buf);
      SendCommandSync(challenge, [IMAP_CONTINUE]);

      challenge := system.Copy(Response.Text, 3, MaxInt);
      buf.Size := 0;
      encoder.Decode(challenge, buf);
      buf.Position := 0;
    end;

    if (buf.Size > 0) then
    begin
      buf.Position := 0;
      challenge := encoder.Encode(buf);
      SendCommandSync(challenge, [IMAP_OK]);
    end;
  finally
    authIdentity.Free();
    buf.Free();
    encoder.Free();
    sspi.Free();
  end;
end;

procedure TclImap4.GetCapability(AList: TStrings);
const
  lexem = '* CAPABILITY ';
var
  i: Integer;
  s: string;
begin
  SendTaggedCommand('CAPABILITY', [IMAP_OK]);
  AList.Clear();
  for i := 0 to Response.Count - 1 do
  begin
    s := Response[i];
    if (System.Pos(lexem, UpperCase(s)) = 1) then
    begin
      s := system.Copy(s, Length(lexem) + 1, Length(s));
      s := StringReplace(s, ' ', #13#10, [rfReplaceAll]);
      AddTextStr(AList, s, False);
    end;
  end;
end;

procedure TclImap4.OAuthAuthenticate;
begin
  SendTaggedCommand('AUTHENTICATE XOAUTH2 %s', [IMAP_OK, IMAP_CONTINUE], [GetOAuthChallenge()]);
  if (LastResponseCode <> IMAP_OK) then
  begin
    SendCommandSync('', [0]);
  end;
end;

procedure TclImap4.Authenticate;
var
  list: TStrings;
begin
  list := TStringList.Create();
  try
    GetCapability(list);
    if (Authorization <> '')
      and (FindInStrings(list, 'AUTH=XOAUTH2') > -1) and (FindInStrings(list, 'SASL-IR') > -1) then
    begin
      OAuthAuthenticate();
    end else
    if FindInStrings(list, 'AUTH=NTLM') > -1 then
    begin
      NtlmAuthenticate();
    end else
    if FindInStrings(list, 'AUTH=CRAM-MD5') > -1 then
    begin
      CramMD5Authenticate();
    end else
    if SaslOnly then
    begin
      RaiseError(AuthMethodInvalid, AuthMethodInvalidCode);
    end else
    begin
      Login();
    end;
  finally
    list.Free();
  end;
end;

procedure TclImap4.OpenImapSession;
begin
  FCommandTag := 0;
  if (LastResponseCode = IMAP_OK) then
  begin
    if UseSasl then
    begin
      Authenticate();
    end else
    begin
      Login();
    end;
    FConnectionState := csAuthenticated;
  end else
  if (LastResponseCode = IMAP_PREAUTH) then
  begin
    FConnectionState := csAuthenticated;
  end;
end;

function TclImap4.GetNextCommandTag: string;
begin
  Inc(FCommandTag);
  Result := GetLastCommandTag();
end;

procedure TclImap4.SelectMailBox(const AName: string);
begin
  CheckConnection([csAuthenticated, csSelected]);
  try
    SendTaggedCommand('SELECT "%s"', [IMAP_OK], [AName]);
    ParseSelectedMailBox(AName);
    FConnectionState := csSelected;
  except
    on E: EclSocketError do
    begin
      FCurrentMailBox.Clear();
      FConnectionState := csAuthenticated;
      raise;
    end;
  end;
end;

procedure TclImap4.SendTaggedCommand(const ACommand: string; const AOkResponses: array of Integer);
begin
  CheckFetchCommand(ACommand);
  FIsTaggedCommand := True;
  try
    SendCommandSync(GetNextCommandTag() + #32 + ACommand, AOkResponses);
  finally
    FIsFetchCommand := False;
    FIsTaggedCommand := False;
  end;
end;

procedure TclImap4.CreateMailBox(const AName: string);
begin
  if (Trim(AName) = '') or (Trim(AName)[1] = MailBoxSeparator) then
  begin
    RaiseError(MailboxNameInvalid, MailboxNameInvalidCode);
  end;
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('CREATE "%s"', [IMAP_OK], [AName]);
end;

procedure TclImap4.DeleteMailBox(const AName: string);
begin
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('DELETE "%s"', [IMAP_OK], [AName]);
end;

procedure TclImap4.RenameMailBox(const ACurrentName, ANewName: string);
begin
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('RENAME "%s" "%s"', [IMAP_OK], [ACurrentName, ANewName]);
end;

procedure TclImap4.GetMailBoxes(AList: TStrings);
begin
  GetMailBoxes(AList, '', '*');
end;

procedure TclImap4.GetMailBoxes(AList: TStrings; const AReferenceName, ACriteria: string);
begin
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('LIST "' + AReferenceName + '" "' + ACriteria + '"', [IMAP_OK]);
  ParseMailBoxes(AList, 'LIST');
end;

function TclImap4.GetMessageFlags(AIndex: Integer): TclMailMessageFlags;
begin
  CheckMessageValid(AIndex);
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('FETCH %d (FLAGS)', [IMAP_OK], [AIndex]);
  Result := ParseMessageFlags(IntToStr(AIndex), False);
  FCurrentMessage := AIndex;
end;

function TclImap4.AppendMessage(const AMailBoxName: string; AFlags: TclMailMessageFlags): string;
begin
  Result := AppendMessage(AMailBoxName, MailMessage, AFlags);
end;

function TclImap4.AppendMessage(const AMailBoxName: string; AMessage: TclMailMessage;
  AFlags: TclMailMessageFlags): string;
begin
  if (AMessage = nil) then
  begin
    RaiseError(ArgumentInvalid, ArgumentInvalidCode);
  end;
  Result := AppendMessage(AMailBoxName, AMessage.MessageSource, AFlags);
end;

procedure TclImap4.CopyMessage(AIndex: Integer;
  const ADestMailBox: string);
begin
  CheckMessageValid(AIndex);
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('COPY %d "%s"', [IMAP_OK], [AIndex, ADestMailBox]);
  FCurrentMessage := AIndex;
end;

procedure TclImap4.CopyMessages(const AMessageSet, ADestMailBox: string);
begin
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('COPY %s "%s"', [IMAP_OK], [AMessageSet, ADestMailBox]);
  FCurrentMessage := 0;
end;

procedure TclImap4.DeleteMessage(AIndex: Integer);
begin
  SetMessageFlags(AIndex, fmAdd, [mfDeleted]);
end;

procedure TclImap4.ParseMailBoxes(AList: TStrings; const ACommand: string);
var
  i: Integer;
  s: string;
begin
  AList.Clear();
  for i := 0 to Response.Count - 1 do
  begin
    if (System.Pos(Format('* %s ', [UpperCase(ACommand)]), UpperCase(Response[i])) = 1) then
    begin
      ParseMailboxInfo(Response[i], FMailBoxSeparator, s);
      if (s <> '') then
      begin
        AList.Add(s);
      end;
    end;
  end;
end;

procedure TclImap4.GetMailBoxes(AList: TStrings; const ACriteria: string);
begin
  GetMailBoxes(AList, '', ACriteria);
end;

function TclImap4.GetMessageSize(AIndex: Integer): Int64;
begin
  CheckMessageValid(AIndex);
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('FETCH %d (RFC822.SIZE)', [IMAP_OK], [AIndex]);
  Result := ParseMessageSize(IntToStr(AIndex), False);
  FCurrentMessage := AIndex;
end;

procedure TclImap4.GetSubscribedMailBoxes(AList: TStrings; const ACriteria: string);
begin
  GetSubscribedMailBoxes(AList, '', ACriteria);
end;

procedure TclImap4.RetrieveHeader(AIndex: Integer; AMessage: TclMailMessage);
begin
  CheckMessageValid(AIndex);
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('FETCH %d (BODY.PEEK[HEADER])', [IMAP_OK], [AIndex]);
  ParseMessage(IntToStr(AIndex), AMessage, False, True);
  FCurrentMessage := AIndex;
end;

procedure TclImap4.RetrieveHeader(AIndex: Integer);
begin
  RetrieveHeader(AIndex, MailMessage);
end;

procedure TclImap4.RetrieveMessage(AIndex: Integer);
begin
  RetrieveMessage(AIndex, MailMessage);
end;

procedure TclImap4.RetrieveMessage(AIndex: Integer; AMessage: TclMailMessage);
begin
  CheckMessageValid(AIndex);
  CheckConnection([csAuthenticated, csSelected]);

  FTotalBytesToReceive := 0;
  if Assigned(OnProgress) then
  begin
    FTotalBytesToReceive := GetMessageSize(AIndex);
  end;

  try
    SendTaggedCommand('FETCH %d (BODY.PEEK[])', [IMAP_OK], [AIndex]);
  finally
    FTotalBytesToReceive := 0;
  end;
  
  ParseMessage(IntToStr(AIndex), AMessage, False, False);
  FCurrentMessage := AIndex;
end;

procedure TclImap4.WaitResponse(const AOkResponses: array of Integer);
begin
  if (FTotalBytesToReceive > 0) then
  begin
    Connection.OnProgress := DoDataProgress;
    Connection.InitProgress(0, FTotalBytesToReceive);
  end;

  try
    inherited WaitResponse(AOkResponses);
    DoProgress(FTotalBytesToReceive, FTotalBytesToReceive);
  finally
    Connection.OnProgress := nil;
  end;
end;

procedure TclImap4.DoDataProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
begin
  DoProgress(ABytesProceed, ATotalBytes);
end;

procedure TclImap4.SearchMessages(const ASearchCriteria: string;
  AMessageList: TStrings);
begin
  CheckConnection([csSelected]);
  SendTaggedCommand('SEARCH %s', [IMAP_OK], [ASearchCriteria]);
  ParseSearchMessages(AMessageList);
end;

procedure TclImap4.SetMessageFlags(AIndex: Integer; AMethod: TclSetFlagsMethod; AFlags: TclMailMessageFlags);
var
  cmd: string;
begin
  CheckMessageValid(AIndex);
  CheckConnection([csAuthenticated, csSelected]);
  cmd := GetStrByImapMessageFlags(AFlags);
  SendTaggedCommand('STORE %d %sFLAGS.SILENT (%s)', [IMAP_OK], [AIndex, SetMethodLexem[AMethod], cmd]);
  FCurrentMessage := AIndex;
end;

procedure TclImap4.SubscribeMailBox(const AName: string);
begin
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('SUBSCRIBE "%s"', [IMAP_OK], [AName]);
end;

procedure TclImap4.UnsubscribeMailBox(const AName: string);
begin
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('UNSUBSCRIBE "%s"', [IMAP_OK], [AName]);
end;

procedure TclImap4.SetAutoReconnect(const Value: Boolean);
begin
  if (FAutoReconnect <> Value) then
  begin
    FAutoReconnect := Value;
    Changed();
  end;
end;

function TclImap4.GetResponseCode(const AResponse: string): Integer;
var
  s: string;
  ind: Integer;
begin
  Result := SOCKET_WAIT_RESPONSE;
  if (AResponse = '') then Exit;

  if (not FIsFetchCommand) and ((System.Pos('+ ', AResponse) = 1) or ('+' = Trim(AResponse))) then
  begin
    Result := IMAP_CONTINUE;
    Exit;
  end;

  ind := System.Pos(' ', AResponse);
  if (ind < 2) or (ind > Length(AResponse) - 1) then Exit;

  s := Trim(System.Copy(AResponse, ind + 1, Length(AResponse)));
  ind := System.Pos(' ', s);
  if (ind < 1) then
  begin
    ind := Length(s);
  end;

  if FIsTaggedCommand
    and (System.Pos(UpperCase(LastCommandTag), UpperCase(AResponse)) <> 1) then Exit;

  s := Trim(System.Copy(s, 1, ind));
  if (s = 'OK') then
  begin
    Result := IMAP_OK;
  end else
  if (s = 'NO') then
  begin
    Result := IMAP_NO;
  end else
  if (s = 'BAD') then
  begin
    Result := IMAP_BAD;
  end else
  if (s = 'PREAUTH') then
  begin
    Result := IMAP_PREAUTH;
  end else
  if (s = 'BYE') then
  begin
    Result := IMAP_BYE;
  end;
end;

procedure TclImap4.GetSubscribedMailBoxes(AList: TStrings);
begin
  GetSubscribedMailBoxes(AList, '', '*');
end;

procedure TclImap4.GetSubscribedMailBoxes(AList: TStrings; const AReferenceName, ACriteria: string);
begin
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('LSUB "' + AReferenceName + '" "' + ACriteria + '"', [IMAP_OK]);
  ParseMailBoxes(AList, 'LSUB');
end;

class procedure TclImap4.RaiseError(const AMessage: string; AErrorCode: Integer);
begin
  raise EclImap4Error.Create(AMessage, AErrorCode);
end;

procedure TclImap4.Logout;
begin
  if (ConnectionState in [csAuthenticated, csSelected]) then
  begin
    try
      SendTaggedCommand('LOGOUT', [IMAP_OK]);
    except
      on EclSocketError do ;
    end;
  end;
  FConnectionState := csNonAuthenticated;
end;

procedure TclImap4.CheckConnection(AStates: array of TclImap4ConnectionState);
begin
  if not IsInState(ConnectionState, AStates) then
  begin
    if AutoReconnect then
    begin
      if not Active then
      begin
        Open();
      end else
      begin
        OpenImapSession();
      end;
    end else
    begin
      RaiseError(ConnectionStateInvalid, ConnectionStateInvalidCode);
    end;
  end;
end;

destructor TclImap4.Destroy;
begin
  FCurrentMailBox.Free();
  inherited Destroy();
end;

procedure TclImap4.ParseSelectedMailBox(const AName: string);
  function GetLexemPos(const ALexem, AText: string; var APos: Integer): Boolean;
  begin
    APos := System.Pos(ALexem, AText);
    Result := APos > 0;
  end;

var
  i, ind: Integer;
  responseStr: string;
begin
  CurrentMailBox.Clear();
  CurrentMailBox.Name := AName;
  
  for i := 0 to Response.Count - 1 do
  begin
    responseStr := UpperCase(Response[i]);
    if GetLexemPos('EXISTS', responseStr, ind) then
    begin
      CurrentMailBox.ExistsMessages := StrToIntDef(Trim(System.Copy(responseStr, 3, ind - 3)), 0);
    end else
    if not GetLexemPos('FLAGS', responseStr, ind)
      and GetLexemPos('RECENT', responseStr, ind) then
    begin
      CurrentMailBox.RecentMessages := StrToIntDef(Trim(System.Copy(responseStr, 3, ind - 3)), 0);
    end else
    if GetLexemPos('[UNSEEN', responseStr, ind) then
    begin
      CurrentMailBox.FirstUnseen := StrToIntDef(Trim(System.Copy(responseStr, ind + Length('[UNSEEN'),
        System.Pos(']', responseStr) - ind - Length('[UNSEEN'))), 0);
    end else
    if GetLexemPos('[READ-WRITE]', responseStr, ind) then
    begin
      CurrentMailBox.ReadOnly := False;
    end else
    if GetLexemPos('[READ-ONLY]', responseStr, ind) then
    begin
      CurrentMailBox.ReadOnly := True;
    end else
    if not GetLexemPos('[PERMANENTFLAGS', responseStr, ind)
      and GetLexemPos('FLAGS', responseStr, ind) then
    begin
      CurrentMailBox.Flags := GetImapMessageFlagsByStr(System.Copy(responseStr, ind, clUtils.TextPos(')', responseStr, ind) - ind));
    end else
    if GetLexemPos('[PERMANENTFLAGS', responseStr, ind) then
    begin
      CurrentMailBox.ChangeableFlags := GetImapMessageFlagsByStr(System.Copy(responseStr, ind, clUtils.TextPos(')', responseStr, ind) - ind));
    end;
    if GetLexemPos('[UIDVALIDITY', responseStr, ind) then
    begin
      ind := ind + Length('[UIDVALIDITY');
      CurrentMailBox.UIDValidity := Trim(System.Copy(responseStr, ind, clUtils.TextPos(']', responseStr, ind) - ind));
    end;
  end;
end;

procedure TclImap4.ParseSearchMessages(AList: TStrings);
const
  lexem = '* SEARCH';
var
  i: Integer;
begin
  AList.Clear();
  for i := 0 to Response.Count - 1 do
  begin
    if (System.Pos(lexem, UpperCase(Response[i])) = 1) then
    begin
      AList.Text := Trim(StringReplace(
        System.Copy(Response[i], Length(lexem) + 1, MaxInt), ' ', #13#10, [rfReplaceAll]));
      Break;
    end;
  end;
end;

function TclImap4.ParseMessageSize(const AMessageId: string; AIsUid: Boolean): Int64;
var
  i, ind: Integer;
  responseStr: string;
begin
  Result := 0;
  for i := 0 to Response.Count - 1 do
  begin
    responseStr := UpperCase(Response[i]);
    if (GetMessageId('FETCH', responseStr, AIsUid) = AMessageId) then
    begin
      ind := System.Pos('RFC822.SIZE ', responseStr);
      if (ind > 0) then
      begin
        Result := StrToInt64Def(Trim(ExtractNumeric(responseStr, ind + Length('RFC822.SIZE '))), 0);
      end;
      Break;
    end;
  end;
end;

function TclImap4.ParseMessageFlags(const AMessageId: string; AIsUid: Boolean): TclMailMessageFlags;
var
  i, ind: Integer;
  responseStr: string;
begin
  Result := [];
  for i := 0 to Response.Count - 1 do
  begin
    responseStr := UpperCase(Response[i]);
    if (GetMessageId('FETCH', responseStr, AIsUid) = AMessageId) then
    begin
      ind := System.Pos('FLAGS', responseStr);
      if (ind > 0) then
      begin
        Result := GetImapMessageFlagsByStr(System.Copy(responseStr, ind, clUtils.TextPos(')', responseStr, ind) - ind));
      end;
      Break;
    end;
  end;
end;

procedure TclImap4.PurgeMessages;
begin
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('CLOSE', [IMAP_OK]);
  FCurrentMailBox.Clear();
  FConnectionState := csAuthenticated;
end;

procedure TclImap4.ParseMessage(const AMessageId: string; AMessage: TclMailMessage; AIsUid, AIsHeader: Boolean);
var
  i: Integer;
  msgSize, size: Int64;
begin
  if (Response.Count < 4) then Exit;

  while (Response.Count > 0) do
  begin
    if (GetMessageId('FETCH', Response[0], AIsUid) = AMessageId) then Break;
    Response.Delete(0);
  end;

  msgSize := ExtractMessageSize(Response[0]);
  if (msgSize = 0) then Exit;

  Response.Delete(0);

  i := 0;
  size := 0;
  while (i < Response.Count) do
  begin
    size := size + Length(Response[i]) + Length(#13#10);
    if (size <= msgSize) then
    begin
      Inc(i);
    end else
    if (Length(Response[i]) > 0) and ((size - msgSize) < (Length(Response[i]) + Length(#13#10))) then
    begin
      Response[i] := system.Copy(Response[i], 1, Length(Response[i]) + Length(#13#10) - (size - msgSize));
      Inc(i);
    end else
    begin
      Response.Delete(i);
    end;
  end;

  if (AMessage <> nil) then
  begin
    if (AIsHeader) then
    begin
      AMessage.HeaderSource := Response;
    end else
    begin
      AMessage.MessageSource := Response;
    end;
  end;
end;

function TclImap4.GetMessageId(const ACommand, AResponseLine: string; AIsUid: Boolean): string;
var
  ind: Integer;
begin
  ind := System.Pos(#32 + ACommand, UpperCase(AResponseLine));
  Result := '0';
  if (ind < 4) then Exit;
  if AIsUid then
  begin
    ind := clUtils.TextPos('UID ', AResponseLine, ind);
    if (ind > 0) then
    begin
      Result := ExtractNumeric(AResponseLine, ind + Length('UID '));
    end;
  end else
  begin
    Result := IntToStr(StrToIntDef(Trim(System.Copy(AResponseLine, 2, ind - 1)), 0));
  end;
end;

procedure TclImap4.CheckMessageValid(AIndex: Integer);
begin
  if (AIndex < 1) then
  begin
    RaiseError(MailMessageNoInvalid, MailMessageNoInvalidCode);
  end;
end;

function TclImap4.GetLastCommandTag: string;
begin
  Result := Format('a%.4d', [FCommandTag]);
end;

procedure TclImap4.SendKeepAlive;
begin
  Noop();
end;

procedure TclImap4.CheckFetchCommand(const ACommand: string);
begin
  FIsFetchCommand := (System.Pos('FETCH ', UpperCase(ACommand)) > 0);
end;

procedure TclImap4.SendTaggedCommand(const ACommand: string;
  const AOkResponses: array of Integer; const Args: array of const);
begin
  CheckFetchCommand(ACommand);
  FIsTaggedCommand := True;
  try
    SendCommandSync(GetNextCommandTag() + #32 + ACommand, AOkResponses, Args);
  finally
    FIsFetchCommand := False;
    FIsTaggedCommand := False;
  end;
end;

procedure TclImap4.UidDeleteMessage(const AUid: string);
begin
  UidSetMessageFlags(AUid, fmAdd, [mfDeleted]);
end;

procedure TclImap4.UidCopyMessage(const AUid, ADestMailBox: string);
begin
  CheckUidValid(AUid);
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('UID COPY %s "%s"', [IMAP_OK], [AUid, ADestMailBox]);
  FCurrentMessage := 0;
end;

procedure TclImap4.UidCopyMessages(const AMessageSet, ADestMailBox: string);
begin
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('UID COPY %s "%s"', [IMAP_OK], [AMessageSet, ADestMailBox]);
  FCurrentMessage := 0;
end;

procedure TclImap4.UidSetMessageFlags(const AUid: string; AMethod: TclSetFlagsMethod; AFlags: TclMailMessageFlags);
var
  cmd: string;
begin
  CheckUidValid(AUid);
  CheckConnection([csAuthenticated, csSelected]);
  cmd := GetStrByImapMessageFlags(AFlags);
  SendTaggedCommand('UID STORE %s %sFLAGS.SILENT (%s)', [IMAP_OK], [AUid, SetMethodLexem[AMethod], cmd]);
  FCurrentMessage := 0;
end;

function TclImap4.UidGetMessageFlags(const AUid: string): TclMailMessageFlags;
begin
  CheckUidValid(AUid);
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('UID FETCH %s (FLAGS)', [IMAP_OK], [AUid]);
  Result := ParseMessageFlags(AUid, True);
  FCurrentMessage := 0;
end;

function TclImap4.UidGetMessageSize(const AUid: string): Int64;
begin
  CheckUidValid(AUid);
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('UID FETCH %s (RFC822.SIZE)', [IMAP_OK], [AUid]);
  Result := ParseMessageSize(AUid, True);
  FCurrentMessage := 0;
end;

procedure TclImap4.UidRetrieveMessage(const AUid: string;
  AMessage: TclMailMessage);
begin
  CheckUidValid(AUid);
  CheckConnection([csAuthenticated, csSelected]);

  FTotalBytesToReceive := 0;
  if Assigned(OnProgress) then
  begin
    FTotalBytesToReceive := UidGetMessageSize(AUid);
  end;

  try
    SendTaggedCommand('UID FETCH %s (BODY.PEEK[])', [IMAP_OK], [AUid]);
  finally
    FTotalBytesToReceive := 0;
  end;

  ParseMessage(AUid, AMessage, True, False);
  FCurrentMessage := 0;
end;

procedure TclImap4.UidRetrieveHeader(const AUid: string;
  AMessage: TclMailMessage);
begin
  CheckUidValid(AUid);
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('UID FETCH %s (BODY.PEEK[HEADER])', [IMAP_OK], [AUid]);
  ParseMessage(AUid, AMessage, True, True);
  FCurrentMessage := 0;
end;

procedure TclImap4.CheckUidValid(const AUid: string);
begin
  if (AUid = '') then
  begin
    RaiseError(MailMessageUidInvalid, MailMessageUidInvalidCode);
  end;
  if StrToIntDef(AUid, 0) < 1 then
  begin
    RaiseError(MailMessageUidInvalid, MailMessageUidInvalidCode);
  end;
end;

procedure TclImap4.UidSearchMessages(const ASearchCriteria: string; AMessageList: TStrings);
begin
  CheckConnection([csSelected]);
  SendTaggedCommand('UID SEARCH %s', [IMAP_OK], [ASearchCriteria]);
  ParseSearchMessages(AMessageList);
end;

function TclImap4.GetMessageUid(AIndex: Integer): string;
begin
  CheckMessageValid(AIndex);
  CheckConnection([csAuthenticated, csSelected]);
  SendTaggedCommand('FETCH %d (UID)', [IMAP_OK], [AIndex]);
  Result := ParseMessageUid(AIndex);
  FCurrentMessage := AIndex;
end;

function TclImap4.ParseMessageUid(AIndex: Integer): string;
begin
  if (Response.Count > 0) and
    (GetMessageId('FETCH', Response[0], False) = IntToStr(AIndex)) then
  begin
    Result := GetMessageId('FETCH', Response[0], True);
  end else
  begin
    Result := '';
  end;
end;

function TclImap4.AppendMessage(const AMailBoxName: string;
  AMessage: TStrings; AFlags: TclMailMessageFlags): string;
var
  flags: string;
begin
  if (Trim(AMailBoxName) = '') then
  begin
    RaiseError(ArgumentInvalid, ArgumentInvalidCode);
  end;
  CheckConnection([csAuthenticated, csSelected]);
  flags := GetStrByImapMessageFlags(AFlags);
  if (flags <> '') then
  begin
    flags := Format('(%s) ', [flags]);
  end;

  SendTaggedCommand('APPEND "%s" %s{%d}', [IMAP_CONTINUE], [AMailBoxName, flags, Length(AMessage.Text)]);

  SendMultipleLines(AMessage, #13#10);
  WaitResponse([IMAP_OK]);

  Result := ExtractAppendUID(Response[0]);
end;

function TclImap4.ExtractAppendUID(const AResponse: string): string;
var
  ind: Integer;
  s: string;
begin
  Result := '';

  ind := clUtils.TextPos('APPENDUID ', UpperCase(AResponse));
  if (ind > 0) then
  begin
    s := system.Copy(AResponse, ind + Length('APPENDUID '), 1000);

    if (WordCount(s, [#32, ']']) > 1) then
    begin
      Result := Trim(ExtractWord(2, s, [#32, ']']));
    end;
  end;
end;

procedure TclImap4.ExamineMailBox(const AName: string);
begin
  CheckConnection([csAuthenticated, csSelected]);
  try
    SendTaggedCommand('EXAMINE "%s"', [IMAP_OK], [AName]);
    ParseSelectedMailBox(AName);
    FConnectionState := csSelected;
  except
    on E: EclSocketError do
    begin
      FCurrentMailBox.Clear();
      FConnectionState := csAuthenticated;
      raise;
    end;
  end;
end;

procedure TclImap4.Noop;
begin
  SendTaggedCommand('NOOP', [IMAP_OK]);
end;

procedure TclImap4.StartTls;
begin
  SendTaggedCommand('STARTTLS', [IMAP_OK]);
  inherited StartTls();
end;

function TclImap4.GetDefaultPort: Integer;
begin
  Result := DefaultImapPort;
end;

end.
