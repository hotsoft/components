{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSmtp;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows, SysUtils, Contnrs, {$IFDEF DEMO} Forms, clCertificate,{$ENDIF}
{$ELSE}
  System.Classes, Winapi.Windows, System.SysUtils, System.Contnrs, {$IFDEF DEMO} Vcl.Forms, clCertificate,{$ENDIF}
{$ENDIF}
  clMC, clTcpCommandClient, clMailMessage, clMailUtils, clTcpClient, clEmailAddress, clMailHeader;

type
  EclSmtpError = class(EclTcpClientError);

  TclFailedRecipient = class
  private
    FError: string;
    FRecipient: string;
    FErrorCode: Integer;
  public
    constructor Create(const ARecipient, AError: string; AErrorCode: Integer);

    property Recipient: string read FRecipient;
    property Error: string read FError;
    property ErrorCode: Integer read FErrorCode;
  end;

  TclFailedRecipientList = class
  private
    FList: TObjectList;

    function GetCount: Integer;
    function GetText: string;
    function GetItem(Index: Integer): TclFailedRecipient;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Add(AItem: TclFailedRecipient);
    procedure Clear;
    property Items[Index: Integer]: TclFailedRecipient read GetItem; default;
    property Count: Integer read GetCount;
    property Text: string read GetText;
  end;

  TclCustomSmtp = class(TclCustomMail)
  private
    FExtensions: TStrings;
    FAuthMethods: TStrings;
    FFailedRecipients: TclFailedRecipientList;
    FUseEHLO: Boolean;
    FMailAgent: string;
    FHostName: string;
    FMaxMessageSize: Int64;
    FSkipFailedRecipients: Boolean;

    procedure GetExtensions;
    procedure GetAuthExtensions;
    procedure GetAuthMethods(const AuthExtension: string);
    procedure GetMaxMessageSize;
    function GetLocalHostName: string;
    procedure SetUseEHLO(const Value: Boolean);
    procedure SetMailAgent(const Value: string);
    procedure SetHostName(const Value: string);
    procedure SetSkipFailedRecipients(const Value: Boolean);
    procedure HELO(const AOkResponses: array of Integer);
    procedure EHLO(const AOkResponses: array of Integer);
    procedure AUTH;
    procedure CramMD5Authenticate;
    procedure LoginAuthenticate;
    procedure NtlmAuthenticate;
    procedure OAuthAuthenticate;
  protected
    procedure SendHelo; virtual;
    procedure SendMailFrom(const AMailFrom: string); virtual;
    procedure SendRecipients(AMailToList: TStrings); virtual;
    procedure SendData(AMailData: TStrings); virtual;
    procedure SendQuit; virtual;
    procedure SendReset; virtual;
    procedure SendNoop; virtual;
    procedure SendMessage(const AMailFrom: string; AMailData, AMailToList: TStrings); virtual;
    function GenMessageID: string; virtual;

    function GetDefaultPort: Integer; override;
    function GetResponseCode(const AResponse: string): Integer; override;
    procedure DoDestroy; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure StartTls; override;
    
    property AuthMethods: TStrings read FAuthMethods;
    property Extensions: TStrings read FExtensions;
    property MaxMessageSize: Int64 read FMaxMessageSize;
    property FailedRecipients: TclFailedRecipientList read FFailedRecipients; 
  published
    property UseEHLO: Boolean read FUseEHLO write SetUseEHLO default True;
    property MailAgent: string read FMailAgent write SetMailAgent;
    property HostName: string read FHostName write SetHostName;
    property SkipFailedRecipients: Boolean read FSkipFailedRecipients write SetSkipFailedRecipients default False;
    property Port default DefaultSmtpPort;
  end;

  TclSmtp = class(TclCustomSmtp)
  private
    FMailFrom: string;
    FMailToList: TStrings;
    FMailData: TStrings;

    procedure SetMailToList(AValue: TStrings);
    procedure SetMailData(AValue: TStrings);
    procedure SetMailFrom(const Value: string);
    procedure DoStringsChanged(Sender: TObject);
  protected
    procedure OpenSession; override;
    procedure CloseSession; override;
    procedure DoDestroy; override;
    procedure SendKeepAlive; override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Send; overload;
    procedure Send(AMessage: TclMailMessage); overload;
    procedure Send(AMessage: TStrings); overload;
    procedure Reset;
    procedure Noop;
  published
    property MailFrom: string read FMailFrom write SetMailFrom;
    property MailToList: TStrings read FMailToList write SetMailToList;
    property MailData: TStrings read FMailData write SetMailData;
  end;

resourcestring
  DataListInvalid = 'The data list is empty';
  RcptListInvalid = 'The recipient list is empty';
  RecipientsFailed = 'There are recipients that failed to receive the message';

const
  DataListInvalidCode = -200;
  RcptListInvalidCode = -201;
  RecipientsFailedCode = -202;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsSmtpDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}
  
implementation

uses
  clEncoder, clUtils, clCryptMac, clSocket, clSspiAuth{$IFDEF LOGGER}, clLogger{$ENDIF};

{ TclCustomSmtp }

constructor TclCustomSmtp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FExtensions := TStringList.Create();
  FAuthMethods := TStringList.Create();
  FFailedRecipients := TclFailedRecipientList.Create();

  FUseEHLO := True;
  FMailAgent := DefaultMailAgent;
  FSkipFailedRecipients := False;
end;

function TclCustomSmtp.GetResponseCode(const AResponse: string): Integer;
begin
  if (Pos('-', AResponse) = 4) then
  begin
    Result := SOCKET_WAIT_RESPONSE;
  end else
  begin
    Result := StrToIntDef(Copy(AResponse, 1, 3), SOCKET_WAIT_RESPONSE);
  end;
end;

procedure TclCustomSmtp.GetExtensions;
var
  i: Integer;
  Extension: string;
begin
  FExtensions.Clear;
  for i := 1 to Response.Count - 1 do
  begin
    Extension := Response[i];
    if (Pos('-', Extension) = 4) or (Pos(' ', Extension) = 4) then
    begin
      Extension := Copy(Extension, 5, MaxInt);
      FExtensions.Add(Extension);
    end;
  end;
end;

function TclCustomSmtp.GetLocalHostName: string;
begin
  if (Trim(HostName) <> '') then
  begin
    Result := HostName;
  end else
  begin
    Result := TclHostResolver.GetLocalHost();
  end;
end;

procedure TclCustomSmtp.GetMaxMessageSize;
var
  s: string;
begin
  FMaxMessageSize := 0;

  if (Response.Count > 0) then
  begin
    s := UpperCase(Trim(Response[Response.Count - 1]));

    if (WordCount(s, [#32]) > 2) and (ExtractWord(2, s, [#32]) = 'SIZE') then
    begin
      FMaxMessageSize := StrToInt64Def(ExtractWord(3, s, [#32]), 0);
    end;
  end;
end;

procedure TclCustomSmtp.GetAuthExtensions;
var
  I: Integer;
  Extension: string;
begin
  FAuthMethods.Clear();
  for I := 0 to FExtensions.Count - 1 do
  begin
    Extension := FExtensions[I];
    if (Pos('AUTH', Extension) = 1) then
    begin
      Extension := Copy(Extension, 6, MaxInt);
      GetAuthMethods(Extension);
    end;
  end;
end;

procedure TclCustomSmtp.GetAuthMethods(const AuthExtension: string);
var
  I: Integer;
  AuthMethod: string;
begin
  for I := 1 to WordCount(AuthExtension, [' ']) do
  begin
    AuthMethod := ExtractWord(I, AuthExtension, [' ']);

    if (FAuthMethods.IndexOf(AuthMethod) < 0) then
    begin
      FAuthMethods.Add(AuthMethod);
    end;
  end;
end;

procedure TclCustomSmtp.HELO(const AOkResponses: array of Integer);
begin
  FExtensions.Clear();
  FAuthMethods.Clear();
  FFailedRecipients.Clear();
  FMaxMessageSize := 0;

  SendCommandSync('HELO %s', AOkResponses, [GetLocalHostName()]);
  GetMaxMessageSize();
end;

procedure TclCustomSmtp.SendMailFrom(const AMailFrom: string);
var
  name, email: string;
begin
  GetEmailAddressParts(AMailFrom, name, email);
  SendCommandSync('MAIL FROM: <%s>', [250], [GetIdnEmail(email)]);
end;

procedure TclCustomSmtp.SendRecipients(AMailToList: TStrings);
var
  i: Integer;
  name, email: string;
  validRecipient: Boolean;
begin
  FFailedRecipients.Clear();
  validRecipient := False;

  if (AMailToList.Count = 0) then
  begin
    raise EclSmtpError.Create(RcptListInvalid, RcptListInvalidCode);
  end;
  i := 0;
  while (i < AMailToList.Count) do
  begin
    GetEmailAddressParts(AMailToList[i], name, email);
    try
      SendCommandSync('RCPT TO: <%s>', [250], [GetIdnEmail(email)]);
      validRecipient := True;
    except
      on E: EclTcpClientError do
      begin
        if (SkipFailedRecipients) then
        begin
          FFailedRecipients.Add(TclFailedRecipient.Create(AMailToList[i], E.Message, E.ErrorCode));
        end else
        begin
          raise;
        end;
      end;
    end;
    Inc(i);
  end;

  if (not validRecipient) then
  begin
    raise EclSmtpError.Create(RecipientsFailed, RecipientsFailedCode);
  end;
end;

procedure TclCustomSmtp.SendReset;
begin
  SendCommandSync('RSET', [250]);
end;

procedure TclCustomSmtp.SendData(AMailData: TStrings);
begin
  if (AMailData.Count = 0) then
  begin
    raise EclSmtpError.Create(DataListInvalid, DataListInvalidCode);
  end;
  SendCommandSync('DATA', [354]);
  SendMultipleLines(AMailData, '.');
  WaitResponse([250, 354]);
end;

procedure TclCustomSmtp.SendHelo;
begin
  WaitResponse([220]);

  if UseEHLO then
  begin
    EHLO([250, 530]);

    if ExplicitStartTls() then
    begin
      EHLO([250]);
    end;
    AUTH();
  end else
  begin
    HELO([250, 530]);

    if ExplicitStartTls() then
    begin
      HELO([250]);
    end;
  end;
end;

procedure TclCustomSmtp.SendQuit;
begin
  SendSilentCommand('QUIT', [221]);
end;

procedure TclCustomSmtp.EHLO(const AOkResponses: array of Integer);
begin
  FExtensions.Clear();
  FAuthMethods.Clear();
  FFailedRecipients.Clear();
  FMaxMessageSize := 0;

  SendCommandSync('EHLO %s', AOkResponses, [GetLocalHostName()]);
  GetExtensions();
  GetAuthExtensions();
  GetMaxMessageSize();
end;

procedure TclCustomSmtp.NtlmAuthenticate;
var
  sspi: TclNtAuthClientSspi;
  encoder: TclEncoder;
  buf: TStream;
  authIdentity: TclAuthIdentity;
  challenge: string;
begin
  SendCommandSync('AUTH NTLM', [334]);

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
      SendCommandSync(challenge, [334]);

      challenge := system.Copy(Response.Text, Length('334 ') + 1, MaxInt);
      buf.Size := 0;
      encoder.Decode(challenge, buf);
      buf.Position := 0;
    end;

    if (buf.Size > 0) then
    begin
      buf.Position := 0;
      challenge := encoder.Encode(buf);
      SendCommandSync(challenge, [235]);
    end;
  finally
    authIdentity.Free();
    buf.Free();
    encoder.Free();
    sspi.Free();
  end;
end;

procedure TclCustomSmtp.OAuthAuthenticate;
begin
  SendCommandSync('AUTH %s %s', [235, 334], ['XOAUTH2', GetOAuthChallenge()]);
  if (LastResponseCode <> 235) then
  begin
    SendCommandSync('', [0]);
  end;
end;

procedure TclCustomSmtp.CramMD5Authenticate;
var
  respLine, DecodedResponse: string;
begin
  SendCommandSync('AUTH %s', [334], ['CRAM-MD5']);
  respLine := Trim(Response.Text);
  respLine := Copy(respLine, 5, MaxInt);
  DecodedResponse := TclEncoder.Decode(respLine, cmBase64);
  DecodedResponse := HMAC_MD5(DecodedResponse, PassWord);
  DecodedResponse := UserName + ' ' + DecodedResponse;
  respLine := TclEncoder.EncodeToString(DecodedResponse, cmBase64);
  SendCommandSync(respLine, [235]);
end;

procedure TclCustomSmtp.LoginAuthenticate;
begin
  SendCommandSync('AUTH %s', [334], ['LOGIN']);
  SendCommandSync(TclEncoder.EncodeToString(UserName, cmBase64), [334]);
  SendCommandSync(TclEncoder.EncodeToString(Password, cmBase64), [235]);
end;

procedure TclCustomSmtp.AUTH;
begin
  if (UserName = '') and (Password = '') and (Authorization = '') then Exit;

  if (Pos('AUTH', Extensions.Text) < 1) then
  begin
    if (UseSasl and SaslOnly) then
    begin
      raise EclSmtpError.Create(AuthMethodInvalid, AuthMethodInvalidCode);
    end;
    Exit;
  end;

  if UseSasl then
  begin
    if (Authorization <> '')
      and ((FindInStrings(AuthMethods, 'XOAUTH2') > -1) or (FindInStrings(AuthMethods, 'OAUTHBEARER') > -1)) then
    begin
      OAuthAuthenticate();
    end else
    if FindInStrings(AuthMethods, 'NTLM') > -1 then
    begin
      NtlmAuthenticate();
    end else
    if FindInStrings(AuthMethods, 'CRAM-MD5') > -1 then
    begin
      CramMD5Authenticate();
    end else
    if SaslOnly then
    begin
      raise EclSmtpError.Create(AuthMethodInvalid, AuthMethodInvalidCode);
    end else
    begin
      LoginAuthenticate();
    end;
  end else
  begin
    LoginAuthenticate();
  end;
end;

procedure TclCustomSmtp.SendMessage(const AMailFrom: string; AMailData, AMailToList: TStrings);
var
  fieldList: TclMailHeaderFieldList;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'SendMessage');{$ENDIF}

  fieldList := TclMailHeaderFieldList.Create(DefaultCharSet, cmNone, DefaultCharsPerLine);
  try
    fieldList.Parse(0, AMailData);
    fieldList.AddFieldIfNotExist('X-Mailer', MailAgent);
    fieldList.AddFieldIfNotExist('Message-ID', GenMessageID());
    fieldList.RemoveField('bcc');
  finally
    fieldList.Free();
  end;

  SendMailFrom(AMailFrom);
  SendRecipients(AMailToList);
  SendData(AMailData);

  if (FFailedRecipients.Count > 0) then
  begin
    raise EclSmtpError.Create(RecipientsFailed, RecipientsFailedCode);
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'SendMessage'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'SendMessage', E); raise; end; end;{$ENDIF}
end;

procedure TclCustomSmtp.SendNoop;
begin
  SendCommandSync('NOOP', [250]);
end;

procedure TclCustomSmtp.SetUseEHLO(const Value: Boolean);
begin
  if (FUseEHLO <> Value) then
  begin
    FUseEHLO := Value;
    Changed();
  end;
end;

procedure TclCustomSmtp.DoDestroy;
begin
  FFailedRecipients.Free();
  FExtensions.Free();
  FAuthMethods.Free();
  inherited DoDestroy();
end;

function TclCustomSmtp.GenMessageID: string;
begin
  Result := GenerateMessageID(GetLocalHostName());
end;

procedure TclCustomSmtp.StartTls;
begin
  SendCommandSync('STARTTLS', [220]);
  inherited StartTls();
end;

function TclCustomSmtp.GetDefaultPort: Integer;
begin
  Result := DefaultSmtpPort;
end;

procedure TclCustomSmtp.SetHostName(const Value: string);
begin
  if (FHostName <> Value) then
  begin
    FHostName := Value;
    Changed();
  end;
end;

procedure TclCustomSmtp.SetMailAgent(const Value: string);
begin
  if (FMailAgent <> Value) then
  begin
    FMailAgent := Value;
    Changed();
  end;
end;

procedure TclCustomSmtp.SetSkipFailedRecipients(const Value: Boolean);
begin
  if (FSkipFailedRecipients <> Value) then
  begin
    FSkipFailedRecipients := Value;
    Changed();
  end;
end;

{ TclSmtp }

procedure TclSmtp.CloseSession;
begin
  SendQuit();
end;

constructor TclSmtp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMailFrom := '';
  FMailToList := TStringList.Create();
  TStringList(FMailToList).OnChange := DoStringsChanged;
  FMailData := TStringList.Create();
  TStringList(FMailData).OnChange := DoStringsChanged;
end;

procedure TclSmtp.DoDestroy;
begin
  FMailToList.Free();
  FMailData.Free();
  inherited DoDestroy();
end;

procedure TclSmtp.DoStringsChanged(Sender: TObject);
begin
  Changed();
end;

procedure TclSmtp.Noop;
begin
  SendNoop();
end;

procedure TclSmtp.OpenSession;
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
      and (not IsCertDemoDisplayed) and (not IsMailMessageDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsSmtpDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsMailMessageDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  SendHelo();
end;

procedure TclSmtp.Reset;
begin
  SendReset();
end;

procedure TclSmtp.Send;
begin
  Send(MailMessage);
end;

procedure TclSmtp.Send(AMessage: TclMailMessage);
var
  rcpt: TStrings;
  from: string;
begin
  rcpt := TStringList.Create();
  try
    rcpt.Assign(MailToList);

    from := MailFrom;

    if (MailData.Count = 0) and (AMessage <> nil) then
    begin
      if (from = '') then
      begin
        from := AMessage.From.FullAddress;
      end;

      if (rcpt.Count = 0) then
      begin
        AMessage.ToList.GetEmailList(rcpt, False);
        AMessage.CCList.GetEmailList(rcpt, False);
        AMessage.BCCList.GetEmailList(rcpt, False);
      end;

      AMessage.MessageID := GenMessageID();

      SendMessage(from, AMessage.MessageSource, rcpt);
    end else
    begin
      SendMessage(from, MailData, rcpt); //TODO replace it with Semd(MailData) this is necessary for parsing of recipients
    end;
  finally
    rcpt.Free();
  end;
end;

procedure TclSmtp.Send(AMessage: TStrings);
var
  rcpt: TStrings;
  msg: TclMailMessage;
  from: string;
begin
  rcpt := nil;
  msg := nil;
  try
    rcpt := TStringList.Create();
    msg := TclMailMessage.Create(nil);
    msg.HeaderSource := AMessage;

    from := MailFrom;
    if (from = '') then
    begin
      from := msg.From.FullAddress;
    end;

    rcpt.Assign(MailToList);
    if (rcpt.Count = 0) then
    begin
      msg.ToList.GetEmailList(rcpt, False);
      msg.CCList.GetEmailList(rcpt, False);
      msg.BCCList.GetEmailList(rcpt, False);
    end;

    SendMessage(from, AMessage, rcpt);
  finally
    msg.Free();
    rcpt.Free();
  end;
end;

procedure TclSmtp.SendKeepAlive;
begin
  Noop();
end;

procedure TclSmtp.SetMailData(AValue: TStrings);
begin
  FMailData.Assign(AValue);
end;

procedure TclSmtp.SetMailFrom(const Value: string);
begin
  if (FMailFrom <> Value) then
  begin
    FMailFrom := Value;
    Changed();
  end;
end;

procedure TclSmtp.SetMailToList(AValue: TStrings);
begin
  FMailToList.Assign(AValue);
end;

{ TclFailedRecipientList }

procedure TclFailedRecipientList.Add(AItem: TclFailedRecipient);
begin
  FList.Add(AItem);
end;

procedure TclFailedRecipientList.Clear;
begin
  FList.Clear();
end;

constructor TclFailedRecipientList.Create;
begin
  inherited Create();
  FList := TObjectList.Create(True);
end;

destructor TclFailedRecipientList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function TclFailedRecipientList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclFailedRecipientList.GetItem(Index: Integer): TclFailedRecipient;
begin
  Result := TclFailedRecipient(FList[Index]);
end;

function TclFailedRecipientList.GetText: string;
var
  i: Integer;
  item: TclFailedRecipient;
begin
  Result := '';

  for i := 0 to Count - 1 do
  begin
    item := GetItem(i);
    Result := Result + item.Recipient + ': (' + IntToStr(item.ErrorCode) + ') ' + item.Error + #13#10;
  end;
end;

{ TclFailedRecipient }

constructor TclFailedRecipient.Create(const ARecipient, AError: string; AErrorCode: Integer);
begin
  inherited Create();

  FError := AError;
  FRecipient := ARecipient;
  FErrorCode := AErrorCode;
end;

end.

