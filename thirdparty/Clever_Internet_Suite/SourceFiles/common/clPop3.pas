{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clPop3;

interface

{$I clVer.inc}

{$IFDEF DELPHI6}
  {$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,{$IFDEF DEMO} Forms, Windows, clCertificate,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils,{$IFDEF DEMO} Vcl.Forms, Winapi.Windows, clCertificate,{$ENDIF}
{$ENDIF}
  clMC, clTcpClient, clTcpCommandClient, clMailMessage, clMailUtils;

type
  TclPop3 = class(TclCustomMail)
  private
    FMessageCount: Integer;
    FMailBoxSize: Int64;
    FCurrentMessage: Integer;
    FTimeStamp: string;
    
    procedure GetTimeStamp;
    procedure GetMailBoxInfo;
    procedure InitMailBoxInfo;
    procedure GetUIDLs(AUIDLs: TStrings);
    function GetDigest: string;
    procedure USER;
    procedure PASS;
    procedure QUIT;
    procedure RETR;
    procedure STAT;
    procedure DELE;
    procedure UIDL;
    procedure APOP;
    procedure TOP;
    procedure LIST;
    function GetMessageCount: Integer;
    procedure Authenticate;
    procedure NtlmAuthenticate;
    procedure CramMD5Authenticate;
    function GetMailBoxSize: Int64;
  protected
    function GetDefaultPort: Integer; override;
    function GetResponseCode(const AResponse: string): Integer; override;
    procedure OpenSession; override;
    procedure CloseSession; override;
    procedure SendKeepAlive; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure StartTls; override;
    procedure Retrieve(AIndex: Integer); overload;
    procedure Retrieve(AIndex: Integer; AMessage: TclMailMessage); overload;
    procedure RetrieveHeader(AIndex: Integer); overload;
    procedure RetrieveHeader(AIndex: Integer; AMessage: TclMailMessage); overload;
    procedure Delete(AIndex: Integer);
    procedure Reset;
    procedure Noop;
    function GetSize(AIndex: Integer): Int64;
    procedure GetUIDList(AUIDList: TStrings);
    function GetUID(AIndex: Integer): string;
    property MessageCount: Integer read GetMessageCount;
    property MailBoxSize: Int64 read GetMailBoxSize;
    property CurrentMessage: Integer read FCurrentMessage;
  published
    property Port default DefaultPop3Port;
  end;

const
  POP3_OK = 10;
  POP3_ERR = 20;
  POP3_CONTINUE = 30;
  POP3_DOT = SOCKET_DOT_RESPONSE;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsPop3DemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

implementation

uses
  clUtils, clCryptHash, clCryptMac, clSspiAuth, clEncoder, clSocket;

{ TclPop3 }

constructor TclPop3.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  InitMailBoxInfo();
  FCurrentMessage := -1;
  FTimeStamp := '';
end;

function TclPop3.GetResponseCode(const AResponse: string): Integer;
begin
  Result := SOCKET_WAIT_RESPONSE;

  if (System.Pos('+ ', AResponse) = 1) or ('+' = Trim(AResponse)) then
  begin
    Result := POP3_CONTINUE;
    Exit;
  end;

  if (system.Pos('+OK', AResponse) = 1) then
  begin
    Result := POP3_OK;
  end else
  if (system.Pos('-ERR', AResponse) = 1) then
  begin
    Result := POP3_ERR;
  end else
  if AResponse = '.' then
  begin
    Result := POP3_DOT;
  end;
end;

procedure TclPop3.USER;
begin
  SendCommandSync('USER %s', [POP3_OK], [UserName]);
end;

procedure TclPop3.PASS;
begin
  SendCommandSync('PASS %s', [POP3_OK], [PassWord]);
end;

procedure TclPop3.QUIT;
begin
  SendSilentCommand('QUIT', [POP3_OK]);
end;

procedure TclPop3.STAT;
begin
  SendCommandSync('STAT', [POP3_OK]);
end;

procedure TclPop3.RETR;
begin
  SendCommandSync('RETR %d', [POP3_OK], [FCurrentMessage]);
end;

procedure TclPop3.TOP;
begin
  SendCommandSync('TOP %d 0', [POP3_OK], [FCurrentMessage]);
end;

procedure TclPop3.DELE;
begin
  SendCommandSync('DELE %d', [POP3_OK], [FCurrentMessage]);
end;

procedure TclPop3.UIDL;
begin
  SendCommandSync('UIDL', [POP3_OK]);
end;

procedure TclPop3.LIST;
begin
  SendCommandSync('LIST %d', [POP3_OK], [FCurrentMessage]);
end;

procedure TclPop3.APOP;
begin
  SendCommandSync('APOP %s %s', [POP3_OK], [UserName, GetDigest()]);
end;

procedure TclPop3.CramMD5Authenticate;
var
  resp, DecodedResponse: string;
begin
  SendCommandSync('AUTH CRAM-MD5', [POP3_OK, POP3_CONTINUE]);
  resp := Copy(Response.Text, 3, MaxInt);
  DecodedResponse := TclEncoder.Decode(resp, cmBase64);
  DecodedResponse := HMAC_MD5(DecodedResponse, Password);
  DecodedResponse := UserName + ' ' + DecodedResponse;
  resp := TclEncoder.EncodeToString(DecodedResponse, cmBase64);
  SendCommandSync(resp, [POP3_OK]);
end;

procedure TclPop3.Noop;
begin
  SendCommandSync('NOOP', [POP3_OK]);
end;

procedure TclPop3.NtlmAuthenticate;
var
  sspi: TclNtAuthClientSspi;
  encoder: TclEncoder;
  buf: TStream;
  authIdentity: TclAuthIdentity;
  challenge: string;
begin
  SendCommandSync('AUTH NTLM', [POP3_OK, POP3_CONTINUE]);

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
      SendCommandSync(challenge, [POP3_CONTINUE]);

      challenge := system.Copy(Response.Text, 3, MaxInt);
      buf.Size := 0;
      encoder.Decode(challenge, buf);
      buf.Position := 0;
    end;

    if (buf.Size > 0) then
    begin
      buf.Position := 0;
      challenge := encoder.Encode(buf);
      SendCommandSync(challenge, [POP3_OK]);
    end;
  finally
    authIdentity.Free();
    buf.Free();
    encoder.Free();
    sspi.Free();
  end;
end;

procedure TclPop3.Authenticate;
begin
  SendCommandSync('AUTH', [POP3_OK, POP3_ERR]);
  if (LastResponseCode = POP3_OK) then
  begin
    WaitMultipleLines(0);
    if FindInStrings(Response, 'NTLM') > -1 then
    begin
      NtlmAuthenticate();
    end else
    if FindInStrings(Response, 'CRAM-MD5') > -1 then
    begin
      CramMD5Authenticate();
    end else
    if SaslOnly then
    begin
      raise EclTcpClientError.Create(AuthMethodInvalid, AuthMethodInvalidCode);
    end else
    begin
      APOP();
    end;
  end else
  if SaslOnly then
  begin
    raise EclTcpClientError.Create(AuthMethodInvalid, AuthMethodInvalidCode);
  end else
  begin
    APOP();
  end;
end;

procedure TclPop3.GetTimeStamp;
var
  s: string;
  P1, P2: Integer;
begin
  FTimeStamp := '';
  s := Response.Text;
  P1 := Pos('<', s);
  P2 := Pos('>', s);
  if (P1 > 0) and (P2 > 0) and (P1 < P2) then
  begin
    FTimeStamp := Copy(s, P1, P2 - P1 + 1);
  end;
end;

procedure TclPop3.GetMailBoxInfo;
var
  s: string;
  nn, mm: string;
begin
  STAT();

  s := Response.Text;
  if (WordCount(s, [' ']) = 3) then
  begin
    nn := Trim(ExtractWord(2, s, [' ']));
    mm := Trim(ExtractWord(3, s, [' ']));

    FMessageCount := StrToIntDef(nn, 0);
    FMailBoxSize := StrToInt64Def(mm, 0);
  end else
  begin
    InitMailBoxInfo();
  end;
end;

procedure TclPop3.GetUIDLs(AUIDLs: TStrings);
var
  i, ind: Integer;
  UIDLStr: string;
begin
  AUIDLs.Clear();
  for i := 0 to Response.Count - 1 do
  begin
    UIDLStr := Response[i];
    ind := system.Pos(#32, UIDLStr);
    if (ind > 0) and (StrToIntDef(system.Copy(UIDLStr, 1, ind - 1), 0) > 0) then
    begin
      UIDLStr := system.Copy(UIDLStr, ind + 1, Length(UIDLStr));
      AUIDLs.Add(Trim(UIDLStr));
    end;
  end;
end;

function TclPop3.GetDigest: string;
begin
  Result := '';
  if (FTimeStamp <> '') then
  begin
    Result := MD5(FTimeStamp + Password);
  end;
end;

procedure TclPop3.OpenSession;
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
    if (not IsPop3DemoDisplayed) and (not IsEncoderDemoDisplayed)
      and (not IsCertDemoDisplayed) and (not IsMailMessageDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsPop3DemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsMailMessageDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  InitMailBoxInfo();
  
  WaitResponse([POP3_OK]);
  GetTimeStamp();

  ExplicitStartTls();

  if UseSasl then
  begin
    Authenticate();
  end else
  begin
    USER();
    PASS();
  end;
end;

procedure TclPop3.CloseSession;
begin
  QUIT();
end;

function TclPop3.GetMailBoxSize: Int64;
begin
  if (FMailBoxSize < 0) then
  begin
    GetMailBoxInfo();
  end;
  Result := FMailBoxSize;
end;

function TclPop3.GetMessageCount: Integer;
begin
  if (FMessageCount < 0) then
  begin
    GetMailBoxInfo();
  end;
  Result := FMessageCount;
end;

procedure TclPop3.Delete(AIndex: Integer);
begin
  FCurrentMessage := AIndex;
  DELE();
  Dec(FMessageCount);
end;

procedure TclPop3.GetUIDList(AUIDList: TStrings);
begin
  UIDL();
  WaitMultipleLines(0);
  GetUIDLs(AUIDList);
end;

procedure TclPop3.RetrieveHeader(AIndex: Integer);
begin
  RetrieveHeader(AIndex, MailMessage);
end;

procedure TclPop3.RetrieveHeader(AIndex: Integer; AMessage: TclMailMessage);
begin
  FCurrentMessage := AIndex;
  TOP();
  WaitMultipleLines(0);

  if (AMessage <> nil) then
  begin
    AMessage.HeaderSource := Response;
  end;
end;

procedure TclPop3.Retrieve(AIndex: Integer);
begin
  Retrieve(AIndex, MailMessage);
end;

procedure TclPop3.Retrieve(AIndex: Integer; AMessage: TclMailMessage);
var
  size: Int64;
begin
  FCurrentMessage := AIndex;

  size := 0;
  if Assigned(OnProgress) then
  begin
    size := GetSize(FCurrentMessage);
  end;
  
  RETR();
  WaitMultipleLines(size);

  if (AMessage <> nil) then
  begin
    AMessage.MessageSource := Response;
  end;
end;

function TclPop3.GetSize(AIndex: Integer): Int64;
var
  s: string;
begin
  FCurrentMessage := AIndex;
  LIST();
  s := Response.Text;
  s := StringReplace(s, Chr(10), '', []);
  s := StringReplace(s, Chr(13), '', []);
  s := Copy(s, Pos(' ', s) + 1, 100);
  s := Copy(s, Pos(' ', s) + 1, 100);
  Result := StrToInt64Def(s, 0);
end;

procedure TclPop3.InitMailBoxInfo;
begin
  FMessageCount := -1;
  FMailBoxSize := -1;
end;

procedure TclPop3.Reset;
begin
  InitMailBoxInfo();
  SendCommandSync('RSET', [POP3_OK]);
end;

function TclPop3.GetUID(AIndex: Integer): string;
begin
  SendCommandSync('UIDL %d', [POP3_OK], [AIndex]);
  Result := Trim(Response.Text);
  if (WordCount(Result, [' ']) = 3) then
  begin
    Result := ExtractWord(3, Result, [' ']);
  end else
  begin
    Result := '';
  end;
end;

procedure TclPop3.SendKeepAlive;
begin
  Noop();
end;

procedure TclPop3.StartTls;
begin
  SendCommandSync('STLS', [POP3_OK]);
  inherited StartTls();
end;

function TclPop3.GetDefaultPort: Integer;
begin
  Result := DefaultPop3Port;
end;

end.

