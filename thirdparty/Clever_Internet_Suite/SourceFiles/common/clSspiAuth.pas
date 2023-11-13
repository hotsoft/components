{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSspiAuth;

interface

{$I clVer.inc}
uses
{$IFNDEF DELPHIXE2}
  Classes, Windows, SysUtils,
{$ELSE}
  System.Classes, Winapi.Windows, System.SysUtils,
{$ENDIF}
  clSspi, clWUtils{$IFDEF LOGGER}, clLogger{$ENDIF};

type
  PSEC_WINNT_AUTH_IDENTITY = ^TSEC_WINNT_AUTH_IDENTITY;
  TSEC_WINNT_AUTH_IDENTITY = record
    User: PclChar;
    UserLength: DWORD;
    Domain: PclChar;
    DomainLength: DWORD;
    Password: PclChar;
    PasswordLength: DWORD;
    Flags: DWORD;
  end;

  TclAuthIdentity = class
  private
    FUser: string;
    FPassword: string;
    FDomain: string;
    FIdentity: TSEC_WINNT_AUTH_IDENTITY;
    function GetIdentity: PSEC_WINNT_AUTH_IDENTITY;
    procedure Clear;
  public
    constructor Create(const AUser, ADomain, APassword: string); overload;
    constructor Create(const AUser, APassword: string); overload;
    destructor Destroy; override;
    property User: string read FUser;
    property Domain: string read FDomain;
    property Password: string read FPassword;
    property Identity: PSEC_WINNT_AUTH_IDENTITY read GetIdentity;
  end;

  
  TclNtAuthSspi = class(TclSspi)
  protected
    FCredHandle: TCredHandle;
    FCtxtHandle: TCtxtHandle;
    procedure GenCredentialHandle(const APackage: string;
      ACredentialUse: DWORD; AuthIdentity: TclAuthIdentity);
    procedure DeleteSecHandles;
  public
    constructor Create;
    destructor Destroy; override;

    property CredHandle: TCredHandle read FCredHandle;
    property CtxtHandle: TCtxtHandle read FCtxtHandle;
  end;

  TclNtAuthClientSspi = class(TclNtAuthSspi)
  public
    function GenChallenge(const APackage: string; ABuffer: TStream;
      const ATargetName: string; AuthIdentity: TclAuthIdentity): Boolean;
  end;

  TclNtAuthServerSspi = class(TclNtAuthSspi)
  private
    FNewConversation: Boolean;
  public
    constructor Create;
    function GenChallenge(const APackage: string; ABuffer: TStream;
      AuthIdentity: TclAuthIdentity): Boolean;
    procedure ImpersonateUser;
    procedure RevertUser;
  end;

const
  SEC_WINNT_AUTH_IDENTITY_ANSI = 1;
  {$EXTERNALSYM SEC_WINNT_AUTH_IDENTITY_ANSI}
  SEC_WINNT_AUTH_IDENTITY_UNICODE = 2;
  {$EXTERNALSYM SEC_WINNT_AUTH_IDENTITY_UNICODE}

implementation

{ TclAuthIdentity }

constructor TclAuthIdentity.Create(const AUser, ADomain, APassword: string);
begin
  inherited Create();

  FUser := AUser;
  FDomain := ADomain;
  FPassword := APassword;

  ZeroMemory(@FIdentity, SizeOf(FIdentity));
  Clear();
end;

procedure TclAuthIdentity.Clear;
begin
  FreeMem(FIdentity.User);
  FIdentity.User := nil;
  FIdentity.UserLength := 0;

  FreeMem(FIdentity.Domain);
  FIdentity.Domain := nil;
  FIdentity.DomainLength := 0;

  FreeMem(FIdentity.Password);
  FIdentity.Password := nil;
  FIdentity.PasswordLength := 0;
{$IFDEF DELPHI2009}
  FIdentity.Flags := SEC_WINNT_AUTH_IDENTITY_ANSI;
//  FIdentity.Flags := SEC_WINNT_AUTH_IDENTITY_UNICODE; it is necessary to move the securityfunction table to unicode
{$ELSE}
  FIdentity.Flags := SEC_WINNT_AUTH_IDENTITY_ANSI;
{$ENDIF}
end;

function TclAuthIdentity.GetIdentity: PSEC_WINNT_AUTH_IDENTITY;
  function AssignIdentityStr(const AIdentityStr: string): PclChar;
  var
    s: TclString;
    len: Integer;
  begin
    s := GetTclString(AIdentityStr);
    len := Length(s);
    GetMem(Result, len + SizeOf(TclChar));
    system.Move(PclChar(s)^, Result^, len);
    Result[len] := #0;
  end;

begin
  Result := @FIdentity;

  Clear();
  if Length(User) > 0 then
  begin
    FIdentity.User := AssignIdentityStr(User);
    FIdentity.UserLength := Length(User);
  end;
  if Length(Domain) > 0 then
  begin
    FIdentity.Domain := AssignIdentityStr(Domain);
    FIdentity.DomainLength := Length(Domain);
  end;
  if Length(Password) > 0 then
  begin
    FIdentity.Password := AssignIdentityStr(Password);
    FIdentity.PasswordLength := Length(Password);
  end;
end;

constructor TclAuthIdentity.Create(const AUser, APassword: string);
var
  ind: Integer;
begin
  inherited Create();

  ind := system.Pos('\', AUser);
  if (ind = 0) then
  begin
    ind := system.Pos('/', AUser);
  end;
  if (ind > 0) then
  begin
    FUser := system.Copy(AUser, ind + 1, Length(AUser));
    FDomain := system.Copy(AUser, 1, ind - 1);
  end else
  begin
    FUser := AUser;
    FDomain := '';
  end;
  FPassword := APassword;

  ZeroMemory(@FIdentity, SizeOf(FIdentity));
  Clear();
end;

destructor TclAuthIdentity.Destroy;
begin
  Clear();
  inherited Destroy();
end;

{ TclNtAuthSspi }

procedure TclNtAuthSspi.DeleteSecHandles;
begin
  if ((FCtxtHandle.dwLower <> 0) or (FCtxtHandle.dwUpper <> 0)) then
  begin
    FunctionTable.DeleteSecurityContext(@FCtxtHandle);
  end;
  FCtxtHandle.dwLower := 0;
  FCtxtHandle.dwUpper := 0;

  if ((FCredHandle.dwLower <> 0) or (FCredHandle.dwUpper <> 0)) then
  begin
    FunctionTable.FreeCredentialHandle(@FCredHandle);
  end;
  FCredHandle.dwLower := 0;
  FCredHandle.dwUpper := 0;
end;

procedure TclNtAuthSspi.GenCredentialHandle(const APackage: string;
  ACredentialUse: DWORD; AuthIdentity: TclAuthIdentity);
var
  statusCode: SECURITY_STATUS;
  authData: PSEC_WINNT_AUTH_IDENTITY;
  tsExpiry: TTimeStamp;
begin
  authData := nil;
  if (AuthIdentity <> nil) then
  begin
    authData := AuthIdentity.Identity;
  end;
  statusCode := FunctionTable.AcquireCredentialsHandle(
    nil, PclChar(GetTclString(APackage)), ACredentialUse, nil, authData, nil, nil, @FCredHandle, @tsExpiry);

  if (statusCode <> SEC_E_OK) then
  begin
    RaiseSspiError(statusCode);
  end;
end;

constructor TclNtAuthSspi.Create;
begin
  inherited Create();
  DeleteSecHandles();
end;

destructor TclNtAuthSspi.Destroy;
begin
  DeleteSecHandles();
  inherited Destroy();
end;

{ TclNtAuthClientSspi }

function TclNtAuthClientSspi.GenChallenge(const APackage: string;
  ABuffer: TStream; const ATargetName: string;
  AuthIdentity: TclAuthIdentity): Boolean;
var
  statusCode: SECURITY_STATUS;
  flags, outFlags: DWORD;
  inBuffer: TSecBufferDesc;
  inBuffers: array[0..0] of TSecBuffer;
  outBuffer: TSecBufferDesc;
  outBuffers: array[0..0] of TSecBuffer;
  buf: PclChar;
  bufSize: Integer;
  pInBuffer: PSecBufferDesc;
  pCtxt: PCtxtHandle;
  tsExpiry: TTimeStamp;
begin
  flags := ISC_REQ_DELEGATE + ISC_REQ_MUTUAL_AUTH + ISC_REQ_REPLAY_DETECT +
    ISC_REQ_SEQUENCE_DETECT + ISC_REQ_CONFIDENTIALITY + ISC_REQ_CONNECTION +
    ISC_REQ_INTEGRITY + ISC_REQ_ALLOCATE_MEMORY;

  outBuffer.ulVersion := SECBUFFER_VERSION;
  outBuffer.cBuffers := 1;
  outBuffer.pBuffers := @outBuffers;

  outBuffers[0].cbBuffer := 0;
  outBuffers[0].BufferType := SECBUFFER_TOKEN;
  outBuffers[0].pvBuffer := nil;

  buf := nil;
  try
    bufSize := ABuffer.Size - ABuffer.Position;
    
    if (bufSize > 0) then
    begin
      inBuffer.ulVersion := SECBUFFER_VERSION;
      inBuffer.cBuffers := 1;
      inBuffer.pBuffers := @inBuffers;

      GetMem(buf, bufSize);
      ABuffer.Read(buf^, bufSize);

      inBuffers[0].cbBuffer := bufSize;
      inBuffers[0].BufferType := SECBUFFER_TOKEN;
      inBuffers[0].pvBuffer := buf;

      pInBuffer := @inBuffer;
      pCtxt := @FCtxtHandle;
    end else
    begin
      DeleteSecHandles();
      GenCredentialHandle(APackage, SECPKG_CRED_OUTBOUND, AuthIdentity);

      pInBuffer := nil;
      pCtxt := nil;
    end;

    statusCode := FunctionTable.InitializeSecurityContext(
      @FCredHandle, pCtxt, PclChar(GetTclString(ATargetName)), flags, 0, 0,
      pInBuffer, 0, @FCtxtHandle, @outBuffer, @outFlags, @tsExpiry);

    Result := (statusCode = SEC_E_OK) or (statusCode = SEC_I_COMPLETE_NEEDED);

    if (statusCode = SEC_I_COMPLETE_AND_CONTINUE) or (statusCode = SEC_I_COMPLETE_NEEDED) then
    begin
      statusCode := FunctionTable.CompleteAuthToken(pCtxt, @outBuffer);
      if (statusCode <> SEC_E_OK) then
      begin
        RaiseSspiError(statusCode);
      end;
    end;

    if (statusCode <> SEC_E_OK) and (statusCode <> SEC_I_CONTINUE_NEEDED) then
    begin
      RaiseSspiError(statusCode);
    end;

    if (outBuffers[0].pvBuffer <> nil) then
    begin
      ABuffer.Size := 0;
      ABuffer.Write(outBuffers[0].pvBuffer^, outBuffers[0].cbBuffer);
      ABuffer.Position := 0;
    end;
  finally
    if (outBuffers[0].pvBuffer <> nil) then
    begin
      FunctionTable.FreeContextBuffer(outBuffers[0].pvBuffer);
    end;
    FreeMem(buf);
  end;
end;

{ TclNtAuthServerSspi }

constructor TclNtAuthServerSspi.Create;
begin
  inherited Create();
  FNewConversation := True;
end;

function TclNtAuthServerSspi.GenChallenge(const APackage: string;
  ABuffer: TStream; AuthIdentity: TclAuthIdentity): Boolean;
var
  statusCode: SECURITY_STATUS;
  flags, outFlags: DWORD;
  inBuffer: TSecBufferDesc;
  inBuffers: array[0..0] of TSecBuffer;
  outBuffer: TSecBufferDesc;
  outBuffers: array[0..0] of TSecBuffer;
  buf: PclChar;
  bufSize: Integer;
  pInBuffer: PSecBufferDesc;
  pCtxt: PCtxtHandle;
  tsExpiry: TTimeStamp;
begin
  {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'GenChallenge', ABuffer, 0);{$ENDIF}
  flags := ASC_REQ_DELEGATE + ASC_REQ_MUTUAL_AUTH + ASC_REQ_REPLAY_DETECT +
    ASC_REQ_SEQUENCE_DETECT + ASC_REQ_CONFIDENTIALITY + ASC_REQ_CONNECTION +
    ASC_REQ_INTEGRITY + ASC_REQ_ALLOCATE_MEMORY;

  outBuffer.ulVersion := SECBUFFER_VERSION;
  outBuffer.cBuffers := 1;
  outBuffer.pBuffers := @outBuffers;

  outBuffers[0].cbBuffer := 0;
  outBuffers[0].BufferType := SECBUFFER_TOKEN;
  outBuffers[0].pvBuffer := nil;

  buf := nil;
  try
    bufSize := ABuffer.Size - ABuffer.Position;

    if (bufSize > 0) then
    begin
      inBuffer.ulVersion := SECBUFFER_VERSION;
      inBuffer.cBuffers := 1;
      inBuffer.pBuffers := @inBuffers;

      GetMem(buf, bufSize);
      ABuffer.Read(buf^, bufSize);

      inBuffers[0].cbBuffer := bufSize;
      inBuffers[0].BufferType := SECBUFFER_TOKEN;
      inBuffers[0].pvBuffer := buf;

      pInBuffer := @inBuffer;
    end else
    begin
      pInBuffer := nil;
    end;

    if FNewConversation then
    begin
      DeleteSecHandles();
      GenCredentialHandle(APackage, SECPKG_CRED_INBOUND, AuthIdentity);
      pCtxt := nil;
      FNewConversation := False;
    end else
    begin
      pCtxt := @FCtxtHandle;
    end;

    statusCode := FunctionTable.AcceptSecurityContext(
      @FCredHandle, pCtxt, pInBuffer, flags, 0, @FCtxtHandle, @outBuffer, @outFlags, @tsExpiry);

    Result := (statusCode = SEC_E_OK) or (statusCode = SEC_I_COMPLETE_NEEDED);
      
    if (statusCode = SEC_I_COMPLETE_AND_CONTINUE) or (statusCode = SEC_I_COMPLETE_NEEDED) then
    begin
      statusCode := FunctionTable.CompleteAuthToken(pCtxt, @outBuffer);
      if (statusCode <> SEC_E_OK) then
      begin
        RaiseSspiError(statusCode);
      end;
    end;

    if (statusCode <> SEC_E_OK) and (statusCode <> SEC_I_CONTINUE_NEEDED) then
    begin
      RaiseSspiError(statusCode);
    end;

    if (outBuffers[0].pvBuffer <> nil) then
    begin
      ABuffer.Size := 0;
      ABuffer.Write(outBuffers[0].pvBuffer^, outBuffers[0].cbBuffer);
      ABuffer.Position := 0;
    end;
  finally
    if (outBuffers[0].pvBuffer <> nil) then
    begin
      FunctionTable.FreeContextBuffer(outBuffers[0].pvBuffer);
    end;
    FreeMem(buf);
  end;
end;

procedure TclNtAuthServerSspi.ImpersonateUser;
var
  statusCode: SECURITY_STATUS;
begin
  statusCode := FunctionTable.ImpersonateSecurityContext(@FCtxtHandle);
  if (statusCode <> SEC_E_OK) then
  begin
    RaiseSspiError(statusCode);
  end;
end;

procedure TclNtAuthServerSspi.RevertUser;
var
  statusCode: SECURITY_STATUS;
begin
  statusCode := FunctionTable.RevertSecurityContext(@FCtxtHandle);
  if (statusCode <> SEC_E_OK) then
  begin
    RaiseSspiError(statusCode);
  end;
end;

end.
