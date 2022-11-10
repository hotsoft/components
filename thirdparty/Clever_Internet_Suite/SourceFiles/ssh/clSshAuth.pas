{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSshAuth;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes,
{$ELSE}
  System.Classes,
{$ENDIF}
  clSshUserIdentity, clSshUserKey, clSshPacket, clConfig, clUtils;

type
  TclSshAuthResult = (sarWork, sarSuccess, sarFail);

  TclSshShowBannerEvent = procedure(Sender: TObject; const AMessage, ALanguage: string) of object;

  TclSshUserAuth = class(TclConfigObject)
  private
    FMethods: string;
    FIdentity: TclSshUserIdentity;
    FSessionId: TclByteArray;
    FConfig: TclConfig;
  protected
    procedure SetMethods(const Value: string);
    function InitAuth: TclPacket; virtual; abstract;
    function ContinueAuth(AInput: TclPacket; var AOutput: TclPacket): TclSshAuthResult; virtual; abstract;
    function CanAuthenticate: Boolean; virtual; abstract;
    procedure ShowBanner(AInput: TclPacket);
    function AuthFailure(AInput: TclPacket): string;
  public
    constructor Create; override;

    function Init(AConfig: TclConfig; AIdentity: TclSshUserIdentity; const ASessionId: TclByteArray): Boolean;

    function Authenticate(AInput: TclPacket; var AOutput: TclPacket): TclSshAuthResult;

    property Config: TclConfig read FConfig;
    property Identity: TclSshUserIdentity read FIdentity;
    property SessionId: TclByteArray read FSessionId;

    property Methods: string read FMethods;
  end;

  TclUserAuthNone = class(TclSshUserAuth)
  protected
    function InitAuth: TclPacket; override;
    function ContinueAuth(AInput: TclPacket; var AOutput: TclPacket): TclSshAuthResult; override;
    function CanAuthenticate: Boolean; override;
  end;

  TclUserAuthPassword = class(TclSshUserAuth)
  protected
    function InitAuth: TclPacket; override;
    function ContinueAuth(AInput: TclPacket; var AOutput: TclPacket): TclSshAuthResult; override;
    function CanAuthenticate: Boolean; override;
  end;

  TclUserAuthPublicKeySha1 = class(TclSshUserAuth)
  private
    FKeyExchange: Boolean;

    function PublicKeyExchange(AInput: TclPacket; var AOutput: TclPacket): TclSshAuthResult;
    function PublicKeyAuth(AInput: TclPacket; var AOutput: TclPacket): TclSshAuthResult;

    function GetPublicKeyBlob: TclByteArray;
    function GetSignature(const AData: TclByteArray): TclByteArray;
  protected
    function InitAuth: TclPacket; override;
    function ContinueAuth(AInput: TclPacket; var AOutput: TclPacket): TclSshAuthResult; override;
    function CanAuthenticate: Boolean; override;
  end;

implementation

uses
  clCryptSignature, clTranslator, clSshUtils;

{ TclSshUserAuth }

function TclSshUserAuth.Authenticate(AInput: TclPacket; var AOutput: TclPacket): TclSshAuthResult;
begin
  if (AInput = nil) then
  begin
    AOutput := InitAuth();
    Result := sarWork;
  end else
  begin
    Result := ContinueAuth(AInput, AOutput);
  end;
end;

constructor TclSshUserAuth.Create;
begin
  inherited Create();

  FMethods := '';
  FIdentity := nil;
  FSessionId := nil;
  FConfig := nil;
end;

function TclSshUserAuth.Init(AConfig: TclConfig; AIdentity: TclSshUserIdentity; const ASessionId: TclByteArray): Boolean;
begin
  FConfig := AConfig;
  FIdentity := AIdentity;
  FSessionId := ASessionId;

  Result := CanAuthenticate();
end;

procedure TclSshUserAuth.SetMethods(const Value: string);
begin
  FMethods := Value;
end;

procedure TclSshUserAuth.ShowBanner(AInput: TclPacket);
var
  _message, _lang: TclByteArray;
  msg, lang: string;
begin
  Assert(AInput.Buffer[5] = SSH_MSG_USERAUTH_BANNER);

  AInput.GetInt();
  AInput.GetByte();
  AInput.GetByte();

  _message := AInput.GetString();
  _lang := AInput.GetString();
  msg := TclTranslator.GetString(_message, 'utf-8');
  lang := TclTranslator.GetString(_lang, 'utf-8');
  Identity.ShowBanner(msg, lang);
end;

function TclSshUserAuth.AuthFailure(AInput: TclPacket): string;
begin
  AInput.GetInt();
  AInput.GetByte();
  AInput.GetByte();

  Result := TclTranslator.GetString(AInput.GetString());
  AInput.GetByte();//TODO returns partial_success; probably, throw exception if partial_success == false
end;

{ TclUserAuthNone }

function TclUserAuthNone.CanAuthenticate: Boolean;
begin
  Result := True;
end;

function TclUserAuthNone.ContinueAuth(AInput: TclPacket; var AOutput: TclPacket): TclSshAuthResult;
var
  _username: TclByteArray;
begin
{$IFNDEF DELPHI2005}_username := nil;{$ENDIF}
  Result := sarWork;
  AOutput := nil;

  if (AInput.Buffer[5] = SSH_MSG_SERVICE_ACCEPT) then
  begin
    _username := TclTranslator.GetBytes(Identity.GetUserName(), 'utf-8');
    try
      AOutput := TclPacket.Create();

      AOutput.Reset();
      AOutput.PutByte(SSH_MSG_USERAUTH_REQUEST);
      AOutput.PutString(_username);
      AOutput.PutString(TclTranslator.GetBytes('ssh-connection'));
      AOutput.PutString(TclTranslator.GetBytes('none'));
    except
      AOutput.Free();
      raise;
    end;
  end else
  if (AInput.Buffer[5] = SSH_MSG_USERAUTH_SUCCESS) then
  begin
    Result := sarSuccess;
  end else
  if (AInput.Buffer[5] = SSH_MSG_USERAUTH_BANNER) then
  begin
    ShowBanner(AInput);
  end else
  if (AInput.Buffer[5] = SSH_MSG_USERAUTH_FAILURE) then
  begin
    SetMethods(AuthFailure(AInput));
    Result := sarFail;
  end else
  begin
    raise EclSshError.Create(UserAuthError, AInput.Buffer[5]);
  end;
end;

function TclUserAuthNone.InitAuth: TclPacket;
begin
  Result := nil;
  try
    Result := TclPacket.Create();

    Result.Reset();
    Result.PutByte(SSH_MSG_SERVICE_REQUEST);
    Result.PutString(TclTranslator.GetBytes('ssh-userauth'));
  except
    Result.Free();
    raise;
  end;
end;

{ TclUserAuthPassword }

function TclUserAuthPassword.CanAuthenticate: Boolean;
begin
  Result := (Identity.GetUserName() <> '') and (Identity.GetPassword() <> '');
end;

function TclUserAuthPassword.ContinueAuth(AInput: TclPacket; var AOutput: TclPacket): TclSshAuthResult;
begin
  Result := sarWork;
  AOutput := nil;

  if (AInput.Buffer[5] = SSH_MSG_USERAUTH_SUCCESS) then
  begin
    Result := sarSuccess;
  end else
  if (AInput.Buffer[5] = SSH_MSG_USERAUTH_BANNER) then
  begin
    ShowBanner(AInput);
  end else
  if (AInput.Buffer[5] = SSH_MSG_USERAUTH_FAILURE) then
  begin
    SetMethods(AuthFailure(AInput));
    Result := sarFail;
  end else
  begin
    try
      AOutput := TclPacket.Create();

      AOutput.Reset();
      AOutput.PutByte(SSH_MSG_USERAUTH_REQUEST);
      AOutput.PutString(TclTranslator.GetBytes(Identity.GetUserName(), 'utf-8'));
      AOutput.PutString(TclTranslator.GetBytes('ssh-connection'));
      AOutput.PutString(TclTranslator.GetBytes('password'));
      AOutput.PutByte(0);
      AOutput.PutString(TclTranslator.GetBytes(Identity.GetPassword(), 'utf-8'));
    except
      AOutput.Free();
      raise;
    end;
  end;
end;

function TclUserAuthPassword.InitAuth: TclPacket;
begin
  Result := nil;
  try
    Result := TclPacket.Create();

    Result.Reset();
    Result.PutByte(SSH_MSG_USERAUTH_REQUEST);
    Result.PutString(TclTranslator.GetBytes(Identity.GetUserName(), 'utf-8'));
    Result.PutString(TclTranslator.GetBytes('ssh-connection'));
    Result.PutString(TclTranslator.GetBytes('password'));
    Result.PutByte(0);
    Result.PutString(TclTranslator.GetBytes(Identity.GetPassword(), 'utf-8'));
  except
    Result.Free();
    raise;
  end;
end;

{ TclUserAuthPublicKeySha1 }

function TclUserAuthPublicKeySha1.CanAuthenticate: Boolean;
begin
  Result := (Identity.GetUserKey().GetPrivateKey() <> nil);
end;

function TclUserAuthPublicKeySha1.ContinueAuth(AInput: TclPacket; var AOutput: TclPacket): TclSshAuthResult;
begin
  if (FKeyExchange) then
  begin
    Result := PublicKeyExchange(AInput, AOutput);
  end else
  begin
    Result := PublicKeyAuth(AInput, AOutput);
  end;
end;

function TclUserAuthPublicKeySha1.GetPublicKeyBlob: TclByteArray;
var
  key: TclRsaKey;
  packet: TclPacket;
  m, e: TclByteArray;
begin
  m := nil;
  e := nil;

  key := nil;
  packet := nil;
  try
    key := Config.CreateInstance('rsa-key') as TclRsaKey;
    key.Init();

    key.SetRsaPrivateKey(Identity.GetUserKey().GetPrivateKey());

    key.GetPublicKeyParams(m, e);

    m := FoldBytesWithZero(m);

    if (Length(e) > 0) and ((e[0] and $80) <> 0) then
    begin
      e := FoldBytesWithZero(e);
    end;

    packet := TclPacket.Create(Length('ssh-rsa') + 4 + Length(e) + 4 + Length(m) + 4);

    packet.PutString(TclTranslator.GetBytes('ssh-rsa'));
    packet.PutString(e);
    packet.PutString(m);

    Result := packet.Buffer;
  finally
    packet.Free();
    key.Free();
  end;
end;

function TclUserAuthPublicKeySha1.GetSignature(const AData: TclByteArray): TclByteArray;
var
  key: TclRsaKey;
  signature: TclSignatureRsa;
  packet: TclPacket;
begin
  signature := nil;
  key := nil;
  packet := nil;
  try
    signature := Config.CreateInstance('ssh-rsa') as TclSignatureRsa;
    signature.Init();

    key := Config.CreateInstance('rsa-key') as TclRsaKey;
    key.Init();
    key.SetRsaPrivateKey(Identity.GetUserKey().GetPrivateKey());

    signature.SetPrivateKey(key);

    signature.Update(AData, 0, Length(AData));

    Result := signature.Sign();

    packet := TclPacket.Create(Length('ssh-rsa') + 4 + Length(Result) + 4);

    packet.PutString(TclTranslator.GetBytes('ssh-rsa'));
    packet.PutString(Result);

    Result := packet.Buffer;
  finally
    packet.Free();
    key.Free();
    signature.Free();
  end;
end;

function TclUserAuthPublicKeySha1.InitAuth: TclPacket;
var
  pubKeyBlob: TclByteArray;
begin
  FKeyExchange := True;

  pubKeyBlob := GetPublicKeyBlob();

  Result := nil;
  try
    Result := TclPacket.Create();

    Result.Reset();
    Result.PutByte(SSH_MSG_USERAUTH_REQUEST);
    Result.PutString(TclTranslator.GetBytes(Identity.GetUserName(), 'utf-8'));
    Result.PutString(TclTranslator.GetBytes('ssh-connection'));
    Result.PutString(TclTranslator.GetBytes('publickey'));
    Result.PutByte(0);
    Result.PutString(TclTranslator.GetBytes('ssh-rsa', 'utf-8'));
    Result.PutString(pubKeyBlob);
  except
    Result.Free();
    raise;
  end;
end;

function TclUserAuthPublicKeySha1.PublicKeyAuth(AInput: TclPacket; var AOutput: TclPacket): TclSshAuthResult;
begin
  Result := sarWork;
  AOutput := nil;

  if (AInput.Buffer[5] = SSH_MSG_USERAUTH_SUCCESS) then
  begin
    Result := sarSuccess;
  end else
  if (AInput.Buffer[5] = SSH_MSG_USERAUTH_BANNER) then
  begin
    ShowBanner(AInput);
  end else
  if (AInput.Buffer[5] = SSH_MSG_USERAUTH_FAILURE) then
  begin
    AuthFailure(AInput);
    Result := sarFail;
  end else
  begin
    raise EclSshError.Create(UserAuthError, AInput.Buffer[5]);
  end;
end;

function TclUserAuthPublicKeySha1.PublicKeyExchange(AInput: TclPacket; var AOutput: TclPacket): TclSshAuthResult;
var
  sidLen, ind: Integer;
  pubKeyBlob, sid, tmp, signature: TclByteArray;
begin
{$IFNDEF DELPHI2005}pubKeyBlob := nil; sid := nil; tmp := nil; signature := nil;{$ENDIF}
  Result := sarWork;
  AOutput := nil;

  if (AInput.Buffer[5] = SSH_MSG_USERAUTH_PK_OK) then
  begin
    try
      AOutput := TclPacket.Create();

      pubKeyBlob := GetPublicKeyBlob();

      AOutput.Reset();
      AOutput.PutByte(SSH_MSG_USERAUTH_REQUEST);
      AOutput.PutString(TclTranslator.GetBytes(Identity.GetUserName(), 'utf-8'));
      AOutput.PutString(TclTranslator.GetBytes('ssh-connection'));
      AOutput.PutString(TclTranslator.GetBytes('publickey'));
      AOutput.PutByte(1);
      AOutput.PutString(TclTranslator.GetBytes('ssh-rsa', 'utf-8'));
      AOutput.PutString(pubKeyBlob);

      sid := SessionId;
      sidlen := Length(sid);
      SetLength(tmp, 4 + sidlen + AOutput.GetIndex() - 5);

      ind := 0;
      ByteArrayWriteDWord(sidlen, tmp, ind);

      System.Move(sid[0], tmp[4], sidlen);
      System.Move(AOutput.Buffer[5], tmp[4 + sidlen], AOutput.GetIndex() - 5);

      signature := GetSignature(tmp);
      AOutput.PutString(signature);

      FKeyExchange := False;
    except
      AOutput.Free();
      raise;
    end;
  end else
  if (AInput.Buffer[5] = SSH_MSG_USERAUTH_FAILURE) then
  begin
    AuthFailure(AInput);
    Result := sarFail;
  end else
  if (AInput.Buffer[5] = SSH_MSG_USERAUTH_BANNER) then
  begin
    ShowBanner(AInput);
  end else
  begin
    raise EclSshError.Create(UserAuthError, AInput.Buffer[5]);
  end;
end;

end.
