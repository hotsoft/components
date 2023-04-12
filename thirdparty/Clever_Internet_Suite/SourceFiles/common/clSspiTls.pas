{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSspiTls;

interface

{$I clVer.inc}
uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clSspi, clCryptAPI, clCertificate, clWUtils;

type
  TclCertificateVerifyFlag = (cfIgnoreCommonNameInvalid, cfIgnoreDateInvalid, cfIgnoreUnknownAuthority,
    cfIgnoreRevocation, cfIgnoreWrongUsage);
  TclCertificateVerifyFlags = set of TclCertificateVerifyFlag;

  TclTlsFlag = (tfUseSSL2, tfUseSSL3, tfUseTLS, tfUseTLS11, tfUseTLS12);
  TclTlsFlags = set of TclTlsFlag;

  TclSspiReturnCode = (rcOK, rcError,
    rcReAuthNeeded, rcAuthContinueNeeded, rcAuthDataNeeded, rcAuthMoreDataNeeded,
    rcCompleteNeeded, rcContinueNeeded, rcClosingNeeded,
    rcMoreDataNeeded, rcEncodeNeeded, rcContinueAndMoreDataNeeded, rcCredentialNeeded);

{$IFDEF LOGGER}
const
  clSspiReturnCodes: array[TclSspiReturnCode] of string = ('rcOK', 'rcError',
    'rcReAuthNeeded', 'rcAuthContinueNeeded', 'rcAuthDataNeeded', 'rcAuthMoreDataNeeded',
    'rcCompleteNeeded', 'rcContinueNeeded', 'rcClosingNeeded',
    'rcMoreDataNeeded', 'rcEncodeNeeded', 'rcContinueAndMoreDataNeeded', 'rcCredentialNeeded');
{$ENDIF}

type
  TclTlsSspi = class(TclSspi)
  private
    FPackageNo: Integer;
    FCredHandle: TCredHandle;
    FCtxtHandle: TCtxtHandle;
    FStreamSizes: TSecPkgContext_StreamSizes;
    FStatusCode: SECURITY_STATUS;
    FPeerCertificate: TclCertificate;
    FCertified: Boolean;
    FCertificateFlags: TclCertificateVerifyFlags;
    FTLSFlags: TclTlsFlags;
    FCSP: string;
    FCSPPtr: PclChar;

    function GetCSP: PclChar;
    function GetStreamSizes: TSecPkgContext_StreamSizes;
    function GetPackageNo: Integer;
    procedure EnumerateSecurityPackages(var APackagesCount: Cardinal; var APackageInfoArray: PSecPkgInfo);
    procedure SetCSP(const Value: string);
  protected
    procedure FreeSChannelCred(var ASecData: TSChannel_Cred);
    procedure FreePeerCertificate;
    procedure DeleteContext;
    procedure DeleteCredentials;
    function GenCredentials(ACertificates: TclCertificateList;
      AllowEmptyCred: Boolean; var ASecData: TSChannel_Cred; ACredentialUse: Cardinal): Boolean;
    function GetPackageName: PclChar;
  public
    constructor Create;
    destructor Destroy; override;
    
    function EndSession(ABuffer: TStream): TclSspiReturnCode; virtual; abstract;
    function GenContext(ABuffer: TStream; ACertificates: TclCertificateList;
      AllowEmptyCred: Boolean): TclSspiReturnCode; virtual; abstract;

    function Encrypt(ASource, ADestination: TStream; ASourceSize: Integer): TclSspiReturnCode;
    function Decrypt(ASource, ADestination, AExtraBuffer: TStream): TclSspiReturnCode;

    property CredHandle: TCredHandle read FCredHandle;
    property CtxtHandle: TCtxtHandle read FCtxtHandle;
    property StreamSizes: TSecPkgContext_StreamSizes read GetStreamSizes;
    property PeerCertificate: TclCertificate read FPeerCertificate;
    property Certified: Boolean read FCertified;
    property StatusCode: SECURITY_STATUS read FStatusCode;
    property CertificateFlags: TclCertificateVerifyFlags read FCertificateFlags write FCertificateFlags;
    property TLSFlags: TclTlsFlags read FTLSFlags write FTLSFlags;
    property CSP: string read FCSP write SetCSP;
  end;

  TclTlsClientSspi = class(TclTlsSspi)
  private
    FTargetName: string;
    FNewConversation: Boolean;

    function VerifyServerCertificate: Boolean;
    function ContinueConversation(var ASecData: TSChannel_Cred; ABuffer: TStream;
      ACertificates: TclCertificateList; AllowEmptyCred: Boolean): TclSspiReturnCode;
    function NewConversation(var ASecData: TSChannel_Cred; ABuffer: TStream): TclSspiReturnCode;
  public
    constructor Create;
    function EndSession(ABuffer: TStream): TclSspiReturnCode; override;
    function GenContext(ABuffer: TStream; ACertificates: TclCertificateList;
      AllowEmptyCred: Boolean): TclSspiReturnCode; override;

    property TargetName: string read FTargetName write FTargetName;
  end;

  TclTlsServerSspi = class(TclTlsSspi)
  private
    FNewConversation: Boolean;
    FRequireClientCertificate: Boolean;

    procedure GetClientCertificate;
  public
    constructor Create;
    function EndSession(ABuffer: TStream): TclSspiReturnCode; override;
    function GenContext(ABuffer: TStream; ACertificates: TclCertificateList;
      AllowEmptyCred: Boolean): TclSspiReturnCode; override;

    property RequireClientCertificate: Boolean
      read FRequireClientCertificate write FRequireClientCertificate;
  end;

const
  PACKAGE_NAMES: array[0..3] of PclChar = (
    'Microsoft Unified Security Protocol Provider',
    'Microsoft SSL 3.0',
    'NTLM',
    'Negotiate');

function CheckSspiError(AErrorCode: SECURITY_STATUS): TclSspiReturnCode; overload;
function CheckSspiError(AErrorCode, ADefaultError: SECURITY_STATUS): TclSspiReturnCode; overload;
procedure SetSspiErrorIf(ACondition: Boolean; AErrorCode, ADefaultError: SECURITY_STATUS);

implementation

uses
 clUtils{$IFDEF LOGGER},clLogger{$ENDIF}{$IFDEF DELPHIXE4}, System.AnsiStrings{$ENDIF};

{$IFDEF DELPHIXE4}
function StrComp(const Str1, Str2: PclChar): Integer;
begin
  Result := System.AnsiStrings.StrComp(Str1, Str2);
end;
{$ENDIF}

function CheckSspiError(AErrorCode: SECURITY_STATUS): TclSspiReturnCode;
begin
  Result := CheckSspiError(AErrorCode, AErrorCode);
end;

function CheckSspiError(AErrorCode, ADefaultError: SECURITY_STATUS): TclSspiReturnCode;
begin
  case AErrorCode of
    SEC_E_INCOMPLETE_MESSAGE: Result := rcMoreDataNeeded;
    SEC_I_CONTINUE_NEEDED:    Result := rcContinueNeeded;
    SEC_I_COMPLETE_NEEDED:    Result := rcCompleteNeeded;
    SEC_I_RENEGOTIATE:        Result := rcReAuthNeeded;
    SEC_I_END_SESSION:        Result := rcClosingNeeded;
    SEC_E_OK:                 Result := rcOK;
  else
    begin
      Result := rcError;
      RaiseSspiError(AErrorCode, ADefaultError);
    end;
  end;
end;

procedure SetSspiErrorIf(ACondition: Boolean; AErrorCode, ADefaultError: SECURITY_STATUS);
begin
  if ACondition then
  begin
    CheckSspiError(AErrorCode, ADefaultError);
  end;
end;

{ TclTlsSspi }

function TclTlsSspi.GetStreamSizes: TSecPkgContext_StreamSizes;
var
  scRet: SECURITY_STATUS;
begin
  if (FStreamSizes.cbHeader = 0) then
  begin
    scRet := FunctionTable.QueryContextAttributes(@FCtxtHandle, SECPKG_ATTR_STREAM_SIZES, @FStreamSizes);
    SetSspiErrorIf(scRet <> SEC_E_OK, scRet, SSPI_E_QueryPackageInfoFailed);
  end;
  Result := FStreamSizes;
end;

procedure TclTlsSspi.SetCSP(const Value: string);
begin
  if (FCSP <> Value) then
  begin
    FCSP := Value;
    FreeMem(FCSPPtr);
    FCSPPtr := nil;
  end;
end;

function TclTlsSspi.GetCSP: PclChar;
var
  s: TclString;
  len: Integer;
begin
  Result := FCSPPtr;
  if (Result <> nil) then Exit;

  if (Trim(CSP) <> '') then
  begin
    s := GetTclString(CSP);
    len := Length(s);
    GetMem(FCSPPtr, len + SizeOf(TclChar));
    system.Move(PclChar(s)^, FCSPPtr^, len);
    FCSPPtr[len] := #0;
  end;
  Result := FCSPPtr;
end;

function TclTlsSspi.GetPackageName: PclChar;
begin
  if (Trim(CSP) <> '') then
  begin
    Result := GetCSP();
  end else
  begin
    Result := PACKAGE_NAMES[FPackageNo];
  end;
end;

function TclTlsSspi.GetPackageNo: Integer;
var
  I, J: Integer;
  PackagesCount: Cardinal;
  PackageInfoArray: PSecPkgInfo;
begin
  EnumerateSecurityPackages(PackagesCount, PackageInfoArray);
  try
    Result := Length(PACKAGE_NAMES);
    for J := 0 to PackagesCount - 1 do
    begin
      for I := 0 to Length(PACKAGE_NAMES) - 1 do
      begin
        if (StrComp(PSecPkgInfo(TclIntPtr(PackageInfoArray) + SizeOf(TSecPkgInfo) * J).Name,
          PACKAGE_NAMES[I]) = 0) then
        begin
          if (I < Result) then Result := I;
          Break;
        end;
      end;
    end;
  finally
    FunctionTable.FreeContextBuffer(PackageInfoArray);
  end;
  SetSspiErrorIf(Result >= Length(PACKAGE_NAMES), SSPI_E_PackageNotFound, SSPI_E_PackageNotFound);
end;

function TclTlsSspi.Encrypt(ASource, ADestination: TStream; ASourceSize: Integer): TclSspiReturnCode;
var
  oldDstPos: Int64;
  i, batchSize, srcCurPos, cbMessage, toWrite: Integer;
  batch, pStart: PclChar;
  buffers: array[0..3] of TSecBuffer;
  msg: TSecBufferDesc;
begin
{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, 'EncryptMessage', ASource, ASource.Position);
{$ENDIF}

  Result := rcOk;

  oldDstPos := ADestination.Position;

  batchSize := ASourceSize;
  if (batchSize > Integer(StreamSizes.cbMaximumMessage)) then
  begin
    batchSize := Integer(StreamSizes.cbMaximumMessage);
  end;
  batchSize := batchSize + Integer(StreamSizes.cbHeader) + Integer(StreamSizes.cbTrailer);

  GetMem(batch, batchSize);
  try
    srcCurPos := 0;

    msg.ulVersion := SECBUFFER_VERSION;
    msg.cBuffers := 4;
    msg.pBuffers := @buffers;

    while(srcCurPos < ASourceSize) do
    begin
      cbMessage := ASourceSize - srcCurPos;
      if (cbMessage > Integer(StreamSizes.cbMaximumMessage)) then
      begin
        cbMessage := Integer(StreamSizes.cbMaximumMessage);
      end;

      buffers[0].cbBuffer := StreamSizes.cbHeader;
      buffers[0].BufferType := SECBUFFER_STREAM_HEADER;
      buffers[0].pvBuffer := batch;

      buffers[1].cbBuffer := cbMessage;
      buffers[1].BufferType := SECBUFFER_DATA;
      buffers[1].pvBuffer := PclChar(TclIntPtr(batch) + Integer(StreamSizes.cbHeader));

      buffers[2].cbBuffer := StreamSizes.cbTrailer;
      buffers[2].BufferType := SECBUFFER_STREAM_TRAILER;
      buffers[2].pvBuffer := PclChar(TclIntPtr(batch) + Integer(StreamSizes.cbHeader) + cbMessage);

      buffers[3].cbBuffer := 0;
      buffers[3].BufferType := SECBUFFER_EMPTY;
      buffers[3].pvBuffer := nil;

      ASource.Read(buffers[1].pvBuffer^, cbMessage);
      srcCurPos := srcCurPos + cbMessage;

      if (Win32Platform <> VER_PLATFORM_WIN32_WINDOWS) then
      begin
        FStatusCode := FunctionTable.EncryptMessage(@FCtxtHandle, nil, @msg, 0);
      end else
      begin
        FStatusCode := FunctionTable.SealMessage(@FCtxtHandle, nil, @msg, 0);
      end;

{$IFDEF LOGGER}
    clPutLogMessage(Self, edInside, 'EncryptMessage');
{$ENDIF}

      Result := CheckSspiError(FStatusCode);

      toWrite := 0;
      pStart := nil;
      for i := 0 to 2 do
      begin
        if (buffers[i].pvBuffer <> nil) then
        begin
          if (pStart = nil) then
          begin
            pStart := buffers[i].pvBuffer;
          end;
          toWrite := toWrite + Integer(buffers[i].cbBuffer);
        end;
      end;
      if (pStart <> nil) and (toWrite > 0) then
      begin
        ADestination.Write(pStart^, toWrite);
      end;
    end;
  finally
    FreeMem(batch);
    if (ASource.Position >= ASourceSize) then
    begin
      ASource.Position := ASource.Position - ASourceSize;
    end;
    ADestination.Position := oldDstPos;
  end;
end;

function TclTlsSspi.Decrypt(ASource, ADestination, AExtraBuffer: TStream): TclSspiReturnCode;
var
  i, size: Integer;
  pbBuffPtr, pbIoBuffer: PclChar;
  cbIoBufferSize: Cardinal;
  Msg: TSecBufferDesc;
  Buffers: array[0..3] of TSecBuffer;
  HasDecodedData,
  InExtraLoop: Boolean;
begin
  InExtraLoop := False;
  HasDecodedData := False;
{$IFNDEF DELPHIX101}
  Result := rcOk;
{$ENDIF}
  size := ASource.Size - ASource.Position;
  GetMem(pbIoBuffer, size);
  try
    pbBuffPtr := pbIoBuffer;

    ASource.Read(pbIoBuffer^, size);
    ASource.Position := ASource.Position - size;

    cbIoBufferSize := size;
    repeat
      if (cbIoBufferSize < 6) then
      begin
        if HasDecodedData then
        begin
          AExtraBuffer.Size := 0;
          AExtraBuffer.Write(pbBuffPtr^, cbIoBufferSize);
          AExtraBuffer.Position := AExtraBuffer.Position - Integer(cbIoBufferSize);

          Result := rcContinueAndMoreDataNeeded;
        end else
        begin
          Result := rcMoreDataNeeded;
        end;
        break;
      end;
      Buffers[0].pvBuffer     := pbBuffPtr;
      Buffers[0].cbBuffer     := cbIoBufferSize;
      Buffers[0].BufferType   := SECBUFFER_DATA;

      Buffers[1].BufferType   := SECBUFFER_EMPTY;
      Buffers[2].BufferType   := SECBUFFER_EMPTY;
      Buffers[3].BufferType   := SECBUFFER_EMPTY;

      Msg.ulVersion       := SECBUFFER_VERSION;
      Msg.cBuffers        := Length(Buffers);
      Msg.pBuffers        := @Buffers;

      if (Win32Platform <> VER_PLATFORM_WIN32_WINDOWS) then
      begin
        FStatusCode := FunctionTable.DecryptMessage(@FCtxtHandle, @Msg, 0, nil);
      end else
      begin
        FStatusCode := FunctionTable.UnSealMessage(@FCtxtHandle, @Msg, 0, nil);
      end;

{$IFDEF LOGGER}
    clPutLogMessage(Self, edInside, 'DecryptMessage');
{$ENDIF}

      Result := CheckSspiError(FStatusCode);

      for i := Low(Buffers) to High(Buffers) do
      begin
        case Buffers[i].BufferType of
          SECBUFFER_DATA:
            begin
              if (Result = rcMoreDataNeeded) or (Result = rcClosingNeeded) then
              begin
                AExtraBuffer.Size := 0;
                AExtraBuffer.Write(Buffers[i].pvBuffer^, Buffers[i].cbBuffer);
                AExtraBuffer.Position := AExtraBuffer.Position - Integer(Buffers[i].cbBuffer);

                if (Result <> rcClosingNeeded) then
                begin
                  Result := rcContinueAndMoreDataNeeded;
                end;
              end else
              begin
                HasDecodedData := True;
                ADestination.Write(Buffers[i].pvBuffer^, Buffers[i].cbBuffer);
{$IFDEF LOGGER}
    clPutLogMessage(Self, edInside, 'DecryptMessage : ADestination.Write', Buffers[i].pvBuffer, Buffers[i].cbBuffer);
{$ENDIF}
              end;
              InExtraLoop := False;
            end;
          SECBUFFER_EXTRA:
            begin
              cbIoBufferSize := Buffers[i].cbBuffer;
              pbBuffPtr := Buffers[i].pvBuffer;
              InExtraLoop := True;
            end;
          SECBUFFER_MISSING:
            begin
              if HasDecodedData then
              begin
                AExtraBuffer.Size := 0;
                AExtraBuffer.Write(pbBuffPtr^, cbIoBufferSize);
{$IFDEF LOGGER}
    clPutLogMessage(Self, edInside, 'DecryptMessage : AExtraBuffer.Write', pbBuffPtr, cbIoBufferSize);
{$ENDIF}
                AExtraBuffer.Position := AExtraBuffer.Position - Integer(cbIoBufferSize);

                Result := rcContinueAndMoreDataNeeded;
              end else
              begin
                Result := rcMoreDataNeeded;
              end;
              InExtraLoop := False;
              break;
            end;
        end;
      end;
    until not InExtraLoop;
  finally
    FreeMem(pbIoBuffer);
  end;
end;

procedure TclTlsSspi.EnumerateSecurityPackages(var APackagesCount: Cardinal;
  var APackageInfoArray: PSecPkgInfo);
var
  ss: SECURITY_STATUS;
begin
  ss := FunctionTable.EnumerateSecurityPackages(APackagesCount, PSecPkgInfo(APackageInfoArray));
  SetSspiErrorIf(ss < SEC_E_OK, ss, SSPI_E_QueryPackageInfoFailed);
end;

procedure TclTlsSspi.DeleteContext;
begin
  if ((FCtxtHandle.dwLower <> 0) or (FCtxtHandle.dwUpper <> 0)) then
  begin
    FunctionTable.DeleteSecurityContext(@FCtxtHandle);
    FCtxtHandle.dwLower := 0;
    FCtxtHandle.dwUpper := 0;
  end;
end;

procedure TclTlsSspi.DeleteCredentials;
begin
  if ((FCredHandle.dwLower <> 0) or (FCredHandle.dwUpper <> 0)) then
  begin
    FunctionTable.FreeCredentialHandle(@FCredHandle);
    FCredHandle.dwLower := 0;
    FCredHandle.dwUpper := 0;
  end;
end;

constructor TclTlsSspi.Create;
begin
  inherited Create();
  FPackageNo := GetPackageNo();
  TLSFlags :=  [tfUseTLS];
end;

function TclTlsSspi.GenCredentials(ACertificates: TclCertificateList;
  AllowEmptyCred: Boolean; var ASecData: TSChannel_Cred; ACredentialUse: Cardinal): Boolean;
var
  i: Integer;
  p: ^PCCERT_CONTEXT;
  tsExpiry: TTimeStamp;
begin
  DeleteCredentials();

  if AllowEmptyCred then
  begin
    Result := True;
  end else
  begin
    Result := (ACertificates.Count > 0);
    if not Result then Exit;
  end;

  if (ACertificates.Count > 0) then
  begin
    ASecData.cCreds := ACertificates.Count;
    FreeSChannelCred(ASecData);
    GetMem(ASecData.paCred, SizeOf(PCCERT_CONTEXT) * ACertificates.Count);

    for i := 0 to ACertificates.Count - 1 do
    begin
      p := Pointer(TclIntPtr(ASecData.paCred) + SizeOf(PCCERT_CONTEXT) * i);
      p^ := ACertificates[i].Context;
    end;
  end;

  FStatusCode := FunctionTable.AcquireCredentialsHandle(
      nil,                   // use the default principal
      GetPackageName(),
      ACredentialUse,
      nil,                   // use the default LOGON id
      @ASecData,
      nil,                   // no callback function needed to get a key
      nil,                   // no callback function arguments needed
      @FCredHandle,
      @tsExpiry);

{$IFDEF LOGGER}
    clPutLogMessage(Self, edInside, 'AcquireCredentialsHandle, package name: %s', nil, [GetString_(GetPackageName())]);
{$ENDIF}
      
  SetSspiErrorIf(FStatusCode < SEC_E_OK, FStatusCode, SSPI_E_AcquireFailed);
end;

procedure TclTlsSspi.FreePeerCertificate;
begin
  FPeerCertificate.Free();
  FPeerCertificate := nil;
end;

procedure TclTlsSspi.FreeSChannelCred(var ASecData: TSChannel_Cred);
begin
  if (ASecData.paCred <> nil) then
  begin
    FreeMem(ASecData.paCred);
    ASecData.paCred := nil;
  end;
end;

destructor TclTlsSspi.Destroy;
begin
  FreePeerCertificate();
  DeleteContext();
  DeleteCredentials();
  inherited Destroy();
end;

{ TclTlsClientSspi }

constructor TclTlsClientSspi.Create;
begin
  inherited Create();
  FTargetName := FloatToStr(Now);
  FCertified := False;
  FNewConversation := True;
end;

function TclTlsClientSspi.EndSession(ABuffer: TStream): TclSspiReturnCode;
var
  OutBuffer: TSecBufferDesc;
  OutBuffers: array[0..1] of TSecBuffer;
  dwSSPIFlags, dwSSPIOutFlags: DWORD;
  tsExpiry: TTimeStamp;
  dwType: Cardinal;
begin
  FNewConversation := True;
  FCertified := False;

  if ((FCtxtHandle.dwLower = 0) and (FCtxtHandle.dwUpper = 0)) then
  begin
    DeleteContext();
    DeleteCredentials();
    Result := rcOk;
    Exit;
  end;
  
  dwType := SCHANNEL_SHUTDOWN;
  dwSSPIFlags := ISC_REQ_SEQUENCE_DETECT + ISC_REQ_REPLAY_DETECT +
      ISC_REQ_CONFIDENTIALITY + ISC_REQ_EXTENDED_ERROR +
      ISC_REQ_ALLOCATE_MEMORY + ISC_REQ_STREAM;

  OutBuffer.ulVersion := SECBUFFER_VERSION;
  OutBuffer.cBuffers := 1;
  OutBuffer.pBuffers := @OutBuffers;

  OutBuffers[0].cbBuffer := sizeof(dwType);
  OutBuffers[0].BufferType := SECBUFFER_TOKEN;
  OutBuffers[0].pvBuffer := @dwType;

  FStatusCode := FunctionTable.ApplyControlToken(@FCtxtHandle, @OutBuffer);
  CheckSspiError(FStatusCode);

  OutBuffers[0].pvBuffer   := nil;
  OutBuffers[0].BufferType := SECBUFFER_TOKEN;
  OutBuffers[0].cbBuffer   := 0;

  OutBuffer.cBuffers       := 1;
  OutBuffer.pBuffers       := @OutBuffers;
  OutBuffer.ulVersion      := SECBUFFER_VERSION;

  try
    FStatusCode := FunctionTable.InitializeSecurityContext(
                  @FCredHandle,
                  @FCtxtHandle,
                  nil,
                  dwSSPIFlags,
                  0,
                  0,
                  nil,
                  0,
                  @FCtxtHandle,
                  @OutBuffer,
                  @dwSSPIOutFlags,
                  @tsExpiry);

{$IFDEF LOGGER}
    clPutLogMessage(Self, edInside, 'InitializeSecurityContext');
{$ENDIF}

    Result := CheckSspiError(FStatusCode);

    if ((OutBuffers[0].pvBuffer <> nil) and (OutBuffers[0].cbBuffer <> 0)) then
    begin
      ABuffer.Size := 0;
      ABuffer.Write(OutBuffers[0].pvBuffer^, OutBuffers[0].cbBuffer);
      ABuffer.Position := 0;
      Result := rcCompleteNeeded;
    end;
  finally
    if (OutBuffers[0].pvBuffer <> nil) then
    begin
      FunctionTable.FreeContextBuffer(OutBuffers[0].pvBuffer);
    end;
    DeleteContext();
    DeleteCredentials();
  end;
end;

function TclTlsClientSspi.GenContext(ABuffer: TStream;
  ACertificates: TclCertificateList; AllowEmptyCred: Boolean): TclSspiReturnCode;
var
  secData: TSChannel_Cred;
begin
  ZeroMemory(@secData, Sizeof(secData));
  try
    secData.dwVersion := SCHANNEL_CRED_VERSION;
    secData.dwFlags :=  SCH_CRED_MANUAL_CRED_VALIDATION + SCH_CRED_NO_DEFAULT_CREDS;

    secData.grbitEnabledProtocols := 0;
    if (tfUseSSL2 in TLSFlags) and (not (tfUseTLS12 in TLSFlags)) then
    begin
      secData.grbitEnabledProtocols := secData.grbitEnabledProtocols or SP_PROT_SSL2_CLIENT;
    end;
    if (tfUseSSL3 in TLSFlags) then
    begin
      secData.grbitEnabledProtocols := secData.grbitEnabledProtocols or SP_PROT_SSL3_CLIENT;
    end;
    if (tfUseTLS in TLSFlags) then
    begin
      secData.grbitEnabledProtocols := secData.grbitEnabledProtocols or SP_PROT_TLS1_CLIENT;
    end;
    if (tfUseTLS11 in TLSFlags) then
    begin
      secData.grbitEnabledProtocols := secData.grbitEnabledProtocols or SP_PROT_TLS1_1_CLIENT;
    end;
    if (tfUseTLS12 in TLSFlags) then
    begin
      secData.grbitEnabledProtocols := secData.grbitEnabledProtocols or SP_PROT_TLS1_2_CLIENT;
    end;

    if (FStatusCode = SEC_I_INCOMPLETE_CREDENTIALS) then
    begin
      if not GenCredentials(ACertificates, AllowEmptyCred, secData, SECPKG_CRED_OUTBOUND) then
      begin
        Result := rcCredentialNeeded;
        Exit;
      end;
    end;

    FStatusCode := SEC_I_CONTINUE_NEEDED;

    if FNewConversation then
    begin
      FNewConversation := False;
      Result := NewConversation(secData, ABuffer);
    end else
    begin
      Result := ContinueConversation(secData, ABuffer, ACertificates, AllowEmptyCred);
    end;

    if not FCertified and (Result in [rcOK, rcEncodeNeeded]) then
    begin
      FCertified := VerifyServerCertificate();
    end;
  finally
    FreeSChannelCred(secData);
  end;
end;

function TclTlsClientSspi.NewConversation(var ASecData: TSChannel_Cred; ABuffer: TStream): TclSspiReturnCode;
var
  OutBuffer: TSecBufferDesc;
  OutBuffers: array[0..1] of TSecBuffer;
  dwSSPIFlags, dwSSPIOutFlags: DWORD;
  tsExpiry: TTimeStamp;
  s: TclString;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'NewConversation');{$ENDIF}

  dwSSPIFlags := ISC_REQ_SEQUENCE_DETECT + ISC_REQ_REPLAY_DETECT +
      ISC_REQ_CONFIDENTIALITY + ISC_REQ_EXTENDED_ERROR +
      ISC_REQ_ALLOCATE_MEMORY + ISC_REQ_STREAM;

  DeleteCredentials();
  FStatusCode := FunctionTable.AcquireCredentialsHandle(
      nil,                   // use the default principal
      GetPackageName(),
      SECPKG_CRED_OUTBOUND,
      nil,                   // use the default LOGON id
      @ASecData,
      nil,                   // no callback function needed to get a key
      nil,                   // no callback function arguments needed
      @FCredHandle,
      @tsExpiry);

{$IFDEF LOGGER}
   clPutLogMessage(Self, edInside, 'AcquireCredentialsHandle, package name: %s', nil, [GetString_(GetPackageName())]);
{$ENDIF}

  SetSspiErrorIf(FStatusCode < SEC_E_OK, FStatusCode, SSPI_E_AcquireFailed);

  OutBuffer.ulVersion := SECBUFFER_VERSION;
  OutBuffer.cBuffers := 1;
  OutBuffer.pBuffers := @OutBuffers;

  OutBuffers[0].cbBuffer := 0;
  OutBuffers[0].BufferType := SECBUFFER_TOKEN;
  OutBuffers[0].pvBuffer := nil;

  try
    s := GetTclString(TargetName);
    FStatusCode := FunctionTable.InitializeSecurityContext(
           @FCredHandle,
           nil,
           PclChar(s),
           dwSSPIFlags,
           0,
           0,
           nil,
           0,
           @FCtxtHandle,
           @OutBuffer,
           @dwSSPIOutFlags,
           @tsExpiry
      );

{$IFDEF LOGGER}
    clPutLogMessage(Self, edInside, 'InitializeSecurityContext');
{$ENDIF}

    CheckSspiError(FStatusCode);

    ABuffer.Size := 0;
    ABuffer.Write(OutBuffers[0].pvBuffer^, OutBuffers[0].cbBuffer);
    ABuffer.Position := 0;
{$IFDEF LOGGER}
    clPutLogMessage(Self, edInside, 'NewConversation, OutBuffers[0].pvBuffer', OutBuffers[0].pvBuffer, OutBuffers[0].cbBuffer);
    clPutLogMessage(Self, edInside, 'NewConversation, after InitializeSecurityContext dwSSPIOutFlags = $%x', nil, [dwSSPIOutFlags]);
{$ENDIF}

    Result := rcAuthContinueNeeded;
  finally
    if (OutBuffers[0].pvBuffer <> nil) then
    begin
      FunctionTable.FreeContextBuffer(OutBuffers[0].pvBuffer);
    end;
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'NewConversation'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'NewConversation', E); raise; end; end;{$ENDIF}
end;

function TclTlsClientSspi.ContinueConversation(var ASecData: TSChannel_Cred;
  ABuffer: TStream; ACertificates: TclCertificateList; AllowEmptyCred: Boolean): TclSspiReturnCode;
var
  InBuffer: TSecBufferDesc;
  InBuffers: array[0..1] of TSecBuffer;
  OutBuffer: TSecBufferDesc;
  OutBuffers: array[0..1] of TSecBuffer;
  dwSSPIFlags, dwSSPIOutFlags: DWORD;
  tsExpiry: TTimeStamp;
  NeedToRead: Boolean;
  buf: PclChar;
  size: Integer;
  s: TclString;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'ContinueConversation');{$ENDIF}
{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, 'ContinueConversation, ABuffer.Position = %d, ABuffer.Size = %d', nil, [ABuffer.Position, ABuffer.Size]);
{$ENDIF}

  NeedToRead := False;
  Result := rcError;

  dwSSPIFlags := ISC_REQ_SEQUENCE_DETECT + ISC_REQ_REPLAY_DETECT +
      ISC_REQ_CONFIDENTIALITY + ISC_REQ_EXTENDED_ERROR +
      ISC_REQ_ALLOCATE_MEMORY + ISC_REQ_STREAM;

  buf := nil;
  try
    while ((FStatusCode = SEC_I_CONTINUE_NEEDED)
        or (FStatusCode = SEC_E_INCOMPLETE_MESSAGE)
        or (FStatusCode = SEC_I_INCOMPLETE_CREDENTIALS)) do
    begin
{$IFDEF LOGGER}
      clPutLogMessage(Self, edInside, 'ContinueConversation, under while FStatusCode = $%x', nil, [Integer(FStatusCode)]);
{$ENDIF}

      if (ABuffer.Size = 0) or (FStatusCode = SEC_E_INCOMPLETE_MESSAGE) then
      begin
        if NeedToRead then
        begin
          Result := rcAuthMoreDataNeeded;
          Break;
        end else
        begin
          NeedToRead := True;
        end;
      end;

      OutBuffer.ulVersion := SECBUFFER_VERSION;
      OutBuffer.cBuffers := 2;
      OutBuffer.pBuffers := @OutBuffers;

      OutBuffers[0].cbBuffer := 0;
      OutBuffers[0].BufferType := SECBUFFER_TOKEN;
      OutBuffers[0].pvBuffer := nil;

      OutBuffers[1].cbBuffer := 0;
      OutBuffers[1].BufferType := SECBUFFER_EMPTY;
      OutBuffers[1].pvBuffer := nil;

      InBuffer.ulVersion := SECBUFFER_VERSION;
      InBuffer.cBuffers := 2;
      InBuffer.pBuffers := @InBuffers;

      FreeMem(buf);
      buf := nil;
      size := ABuffer.Size - ABuffer.Position;
      if (size > 0) then
      begin
        GetMem(buf, size);
        ABuffer.Read(buf^, size);
        ABuffer.Position := ABuffer.Position - size;
      end;

      InBuffers[0].cbBuffer := size;
      InBuffers[0].BufferType := SECBUFFER_TOKEN;
      InBuffers[0].pvBuffer := buf;

{$IFDEF LOGGER}
      clPutLogMessage(Self, edInside, 'ContinueConversation, InBuffers[0].pvBuffer', InBuffers[0].pvBuffer, InBuffers[0].cbBuffer);
{$ENDIF}

      InBuffers[1].cbBuffer := 0;
      InBuffers[1].BufferType := SECBUFFER_EMPTY;
      InBuffers[1].pvBuffer := nil;

      s := GetTclString(TargetName);
      FStatusCode := FunctionTable.InitializeSecurityContext(
           @FCredHandle,
           @FCtxtHandle,
           PclChar(s),
           dwSSPIFlags,
           0,
           0,
           @InBuffer,
           0,
           @FCtxtHandle,
           @OutBuffer,
           @dwSSPIOutFlags,
           @tsExpiry
      );

{$IFDEF LOGGER}
      clPutLogMessage(Self, edInside, 'InitializeSecurityContext');

      clPutLogMessage(Self, edInside, 'ContinueConversation, after InitializeSecurityContext FStatusCode = $%x', nil, [Integer(FStatusCode)]);
      clPutLogMessage(Self, edInside, 'ContinueConversation, OutBuffers[0].pvBuffer', OutBuffers[0].pvBuffer, OutBuffers[0].cbBuffer);

      if (InBuffers[1].BufferType = SECBUFFER_EXTRA) then
      begin
        clPutLogMessage(Self, edInside, 'ContinueConversation, InBuffers[1] = SECBUFFER_EXTRA (' + IntToStr(InBuffers[1].cbBuffer));
      end else
      begin
        clPutLogMessage(Self, edInside, 'ContinueConversation, InBuffers[1] = no extra data');
      end;
      
      clPutLogMessage(Self, edInside, 'ContinueConversation, after InitializeSecurityContext dwSSPIOutFlags = $%x', nil, [dwSSPIOutFlags]);
{$ENDIF}

      if (FStatusCode = SEC_E_OK) or (FStatusCode = SEC_I_CONTINUE_NEEDED)
        or (FAILED(FStatusCode) and ((dwSSPIOutFlags and ISC_RET_EXTENDED_ERROR) <> 0)) then
      begin
        if (OutBuffers[0].cbBuffer <> 0) and (OutBuffers[0].pvBuffer <> nil) then
        begin
          ABuffer.Size := 0;
          ABuffer.Write(OutBuffers[0].pvBuffer^, OutBuffers[0].cbBuffer);
          ABuffer.Position := 0;

          FunctionTable.FreeContextBuffer(OutBuffers[0].pvBuffer);
          OutBuffers[0].pvBuffer := nil;

          Result := rcAuthContinueNeeded;
{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, 'ContinueConversation, inside if (FStatusCode = SEC_E_OK) or..., ABuffer.Position = %d, ABuffer.Size = %d', nil, [ABuffer.Position, ABuffer.Size]);
{$ENDIF}
          Break;
        end;
      end;
      if (FStatusCode = SEC_E_INCOMPLETE_MESSAGE) then
      begin
        Result := rcAuthMoreDataNeeded;
        Break;
      end;
      if (FStatusCode = SEC_E_OK) then
      begin
        Result := rcOk;
        if (InBuffers[1].BufferType = SECBUFFER_EXTRA) then
        begin
          ABuffer.Position := ABuffer.Size - Integer(InBuffers[1].cbBuffer);
          Result := rcEncodeNeeded;
        end;
        Break;
      end;
      if (FStatusCode = SEC_I_INCOMPLETE_CREDENTIALS) then
      begin
        if not GenCredentials(ACertificates, AllowEmptyCred, ASecData, SECPKG_CRED_OUTBOUND) then
        begin
          Result := rcCredentialNeeded;
        end;
        NeedToRead := False;
        FStatusCode := SEC_I_INCOMPLETE_CREDENTIALS;
        if (Result = rcCredentialNeeded) then
        begin
         Break;
        end else
        begin
          continue;
        end;
      end;

      CheckSspiError(FStatusCode);

      if (InBuffers[1].BufferType = SECBUFFER_EXTRA) then
      begin
        ABuffer.Position := ABuffer.Size - Integer(InBuffers[1].cbBuffer);
      end else
      begin
        ABuffer.Size := 0;
      end;
    end;
  finally
    FreeMem(buf);
  end;
{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, 'ContinueConversation, before end, ABuffer.Position = %d, ABuffer.Size = %d', nil, [ABuffer.Position, ABuffer.Size]);
{$ENDIF}
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'ContinueConversation'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'ContinueConversation', E); raise; end; end;{$ENDIF}
end;

function TclTlsClientSspi.VerifyServerCertificate: Boolean;
const
  SECURITY_FLAG_IGNORE_REVOCATION             = $00000080;
  SECURITY_FLAG_IGNORE_UNKNOWN_CA             = $00000100;
  SECURITY_FLAG_IGNORE_WRONG_USAGE            = $00000200;
  SECURITY_FLAG_IGNORE_CERT_CN_INVALID        = $00001000;
  SECURITY_FLAG_IGNORE_CERT_DATE_INVALID      = $00002000;

var
  polHttps: HTTPSPolicyCallbackData;
  PolicyPara: CERT_CHAIN_POLICY_PARA;
  PolicyStatus: CERT_CHAIN_POLICY_STATUS;
  ChainPara: CERT_CHAIN_PARA;
  pChainContext: PCCERT_CHAIN_CONTEXT;
  remoteCertContext: PCCERT_CONTEXT;
  pwszServerName: PWCHAR;
  cchServerName: DWORD;
begin
  FreePeerCertificate();
  Result := True;
  cchServerName := MultiByteToWideChar(CP_ACP, 0, PclChar(GetTclString(TargetName)), -1, nil, 0);
  GetMem(pwszServerName, cchServerName * sizeof(WCHAR));
  try
    SetSspiErrorIf(pwszServerName = nil, SEC_E_OUTOFMEMORY, SEC_E_OUTOFMEMORY);

    MultiByteToWideChar(CP_ACP, 0, PclChar(GetTclString(TargetName)), -1, pwszServerName, cchServerName);

    ZeroMemory(@ChainPara, sizeof(ChainPara));
    ChainPara.cbSize := sizeof(ChainPara);

    FStatusCode := FunctionTable.QueryContextAttributes(@FCtxtHandle,
                                    SECPKG_ATTR_REMOTE_CERT_CONTEXT,
                                    @remoteCertContext);
    CheckSspiError(FStatusCode);

    FPeerCertificate := TclCertificate.Create(remoteCertContext);

    pChainContext := nil;
    try
      SetSspiErrorIf(
        not CertGetCertificateChain(
          0,
          remoteCertContext,
          nil,
          remoteCertContext^.hCertStore,
          @ChainPara,
          0,
          nil,
          @pChainContext),
        SECURITY_STATUS(GetLastError()),
        SSPI_E_WhileVerify);

      ZeroMemory(@polHttps, sizeof(HTTPSPolicyCallbackData));
      polHttps.cbSize := sizeof(HTTPSPolicyCallbackData);
      polHttps.dwAuthType := AUTHTYPE_SERVER;
      polHttps.fdwChecks := 0;

      if cfIgnoreCommonNameInvalid in CertificateFlags then
        polHttps.fdwChecks := polHttps.fdwChecks or SECURITY_FLAG_IGNORE_CERT_CN_INVALID;
      if cfIgnoreDateInvalid in CertificateFlags then
        polHttps.fdwChecks := polHttps.fdwChecks or SECURITY_FLAG_IGNORE_CERT_DATE_INVALID;
      if cfIgnoreUnknownAuthority in CertificateFlags then
        polHttps.fdwChecks := polHttps.fdwChecks or SECURITY_FLAG_IGNORE_UNKNOWN_CA;
      if cfIgnoreRevocation in CertificateFlags then
        polHttps.fdwChecks := polHttps.fdwChecks or SECURITY_FLAG_IGNORE_REVOCATION;
      if cfIgnoreWrongUsage in CertificateFlags then
        polHttps.fdwChecks := polHttps.fdwChecks or SECURITY_FLAG_IGNORE_WRONG_USAGE;

      polHttps.pwszServerName := pwszServerName;

      ZeroMemory(@PolicyPara, sizeof(PolicyPara));
      PolicyPara.cbSize := sizeof(PolicyPara);
      PolicyPara.pvExtraPolicyPara := @polHttps;

      ZeroMemory(@PolicyStatus, sizeof(PolicyStatus));
      PolicyStatus.cbSize := sizeof(PolicyStatus);

      SetSspiErrorIf(
        not CertVerifyCertificateChainPolicy(
          CERT_CHAIN_POLICY_SSL,
          pChainContext,
          @PolicyPara,
          @PolicyStatus),
        SECURITY_STATUS(GetLastError()),
        SSPI_E_WhileVerify);

      if (PolicyStatus.dwError <> 0) then
      begin
        FStatusCode := Longint(PolicyStatus.dwError);
        Result := False;
      end;
    finally
      if (pChainContext <> nil) then
      begin
        CertFreeCertificateChain(pChainContext);
      end;
      if (remoteCertContext <> nil) then CertFreeCertificateContext(remoteCertContext);
    end;
  finally
    FreeMem(pwszServerName);
  end;
end;

{ TclTlsServerSspi }

constructor TclTlsServerSspi.Create;
begin
  inherited Create();
  FNewConversation := True;
  FRequireClientCertificate := False;
end;

function TclTlsServerSspi.EndSession(ABuffer: TStream): TclSspiReturnCode;
var
  OutBuffer: TSecBufferDesc;
  OutBuffers: array[0..1] of TSecBuffer;
  dwSSPIFlags, dwSSPIOutFlags: DWORD;
  tsExpiry: TTimeStamp;
  dwType: Cardinal;
begin
  FNewConversation := True;
  FCertified := False;

  if ((FCtxtHandle.dwLower = 0) and (FCtxtHandle.dwUpper = 0)) then
  begin
    DeleteContext();
    DeleteCredentials();
    Result := rcOk;
    Exit;
  end;
  
  dwType := SCHANNEL_SHUTDOWN;
  dwSSPIFlags := ASC_REQ_SEQUENCE_DETECT + ASC_REQ_REPLAY_DETECT +
      ASC_REQ_CONFIDENTIALITY + ASC_REQ_EXTENDED_ERROR +
      ASC_REQ_ALLOCATE_MEMORY + ASC_REQ_STREAM;

  OutBuffer.ulVersion := SECBUFFER_VERSION;
  OutBuffer.cBuffers := 1;
  OutBuffer.pBuffers := @OutBuffers;

  OutBuffers[0].cbBuffer := sizeof(dwType);
  OutBuffers[0].BufferType := SECBUFFER_TOKEN;
  OutBuffers[0].pvBuffer := @dwType;

  FStatusCode := FunctionTable.ApplyControlToken(@FCtxtHandle, @OutBuffer);
  CheckSspiError(FStatusCode);


  OutBuffers[0].pvBuffer   := nil;
  OutBuffers[0].BufferType := SECBUFFER_TOKEN;
  OutBuffers[0].cbBuffer   := 0;

  OutBuffer.cBuffers       := 1;
  OutBuffer.pBuffers       := @OutBuffers;
  OutBuffer.ulVersion      := SECBUFFER_VERSION;

  try
    FStatusCode := FunctionTable.AcceptSecurityContext(
           @FCredHandle,
           @FCtxtHandle,
           nil,
           dwSSPIFlags,
           0,
           nil,
           @OutBuffer,
           @dwSSPIOutFlags,
           @tsExpiry
      );

    Result := CheckSspiError(FStatusCode);

    if ((OutBuffers[0].pvBuffer <> nil) and (OutBuffers[0].cbBuffer <> 0)) then
    begin
      ABuffer.Size := 0;
      ABuffer.Write(OutBuffers[0].pvBuffer^, OutBuffers[0].cbBuffer);
      ABuffer.Position := 0;
      Result := rcCompleteNeeded;
    end;
  finally
    if (OutBuffers[0].pvBuffer <> nil) then
    begin
      FunctionTable.FreeContextBuffer(OutBuffers[0].pvBuffer);
    end;
    DeleteContext();
    DeleteCredentials();
  end;
end;

function TclTlsServerSspi.GenContext(ABuffer: TStream;
  ACertificates: TclCertificateList; AllowEmptyCred: Boolean): TclSspiReturnCode;
var
  InBuffer: TSecBufferDesc;
  InBuffers: array[0..1] of TSecBuffer;
  OutBuffer: TSecBufferDesc;
  OutBuffers: array[0..1] of TSecBuffer;
  dwSSPIFlags, dwSSPIOutFlags: DWORD;
  tsExpiry: TTimeStamp;
  pCtxt: PCtxtHandle;
  secData: TSChannel_Cred;
  buf: PclChar;
begin
  ZeroMemory(@secData, Sizeof(secData));
  try
    secData.dwVersion := SCHANNEL_CRED_VERSION;
    secData.dwFlags := 0;

    secData.grbitEnabledProtocols := 0;
    if (tfUseSSL2 in TLSFlags) and (not (tfUseTLS12 in TLSFlags)) then
    begin
      secData.grbitEnabledProtocols := secData.grbitEnabledProtocols or SP_PROT_SSL2_SERVER;
    end;
    if (tfUseSSL3 in TLSFlags) then
    begin
      secData.grbitEnabledProtocols := secData.grbitEnabledProtocols or SP_PROT_SSL3_SERVER;
    end;
    if (tfUseTLS in TLSFlags) then
    begin
      secData.grbitEnabledProtocols := secData.grbitEnabledProtocols or SP_PROT_TLS1_SERVER;
    end;
    if (tfUseTLS11 in TLSFlags) then
    begin
      secData.grbitEnabledProtocols := secData.grbitEnabledProtocols or SP_PROT_TLS1_1_SERVER;
    end;
    if (tfUseTLS12 in TLSFlags) then
    begin
      secData.grbitEnabledProtocols := secData.grbitEnabledProtocols or SP_PROT_TLS1_2_SERVER;
    end;

    if FNewConversation then
    begin
      if not GenCredentials(ACertificates, AllowEmptyCred, secData, SECPKG_CRED_INBOUND) then
      begin
        Result := rcCredentialNeeded;
        Exit;
      end;
    end;

    OutBuffer.ulVersion := SECBUFFER_VERSION;
    OutBuffer.cBuffers := 1;
    OutBuffer.pBuffers := @OutBuffers;

    OutBuffers[0].cbBuffer := 0;
    OutBuffers[0].BufferType := SECBUFFER_TOKEN;
    OutBuffers[0].pvBuffer := nil;

    buf := nil;
    try
      FStatusCode := SEC_I_CONTINUE_NEEDED;

      dwSSPIFlags := ASC_REQ_SEQUENCE_DETECT + ASC_REQ_REPLAY_DETECT +
          ASC_REQ_CONFIDENTIALITY + ASC_REQ_EXTENDED_ERROR +
          ASC_REQ_ALLOCATE_MEMORY + ASC_REQ_STREAM;

			if RequireClientCertificate then
      begin
				dwSSPIFlags := dwSSPIFlags or ASC_REQ_MUTUAL_AUTH;
      end;

      InBuffer.ulVersion := SECBUFFER_VERSION;
      InBuffer.cBuffers := 1;
      InBuffer.pBuffers := @InBuffers;

      if (ABuffer.Size > 0) then
      begin
        GetMem(buf, ABuffer.Size);
        ABuffer.Position := 0;
        ABuffer.Read(buf^, ABuffer.Size);
      end;

      InBuffers[0].cbBuffer := ABuffer.Size;
      InBuffers[0].BufferType := SECBUFFER_TOKEN;
      InBuffers[0].pvBuffer := buf;

      pCtxt := nil;
      if not FNewConversation then
      begin
        pCtxt := @FCtxtHandle;
      end;

      FStatusCode := FunctionTable.AcceptSecurityContext(
             @FCredHandle,
             pCtxt,
             @InBuffer,
             dwSSPIFlags,
             0,
             @FCtxtHandle,
             @OutBuffer,
             @dwSSPIOutFlags,
             @tsExpiry
        );

      CheckSspiError(FStatusCode);

      if (FStatusCode = SEC_I_COMPLETE_NEEDED)
          or (FStatusCode = SEC_I_COMPLETE_AND_CONTINUE) then
      begin
        FStatusCode := FunctionTable.CompleteAuthToken(@FCtxtHandle, @OutBuffer);
        CheckSspiError(FStatusCode);
      end;

      ABuffer.Size := 0;
      ABuffer.Write(OutBuffers[0].pvBuffer^, OutBuffers[0].cbBuffer);
      ABuffer.Position := 0;
    finally
      if (OutBuffers[0].pvBuffer <> nil) then
      begin
        FunctionTable.FreeContextBuffer(OutBuffers[0].pvBuffer);
      end;
      FreeMem(buf);
    end;
    FNewConversation := False;

    if (SEC_I_CONTINUE_NEEDED = FStatusCode)
      or (SEC_I_COMPLETE_AND_CONTINUE = FStatusCode) then
    begin
      Result := rcAuthContinueNeeded;
    end else
    begin
      if RequireClientCertificate and (not FCertified) then
      begin
        GetClientCertificate();
      end;
      Result := rcOk;
      FCertified := True;
    end;
  finally
    FreeSChannelCred(secData);
  end;
end;

procedure TclTlsServerSspi.GetClientCertificate;
var
  remoteCertContext: PCCERT_CONTEXT;
begin
  remoteCertContext := nil;
  try
    FStatusCode := FunctionTable.QueryContextAttributes(@FCtxtHandle,
                                    SECPKG_ATTR_REMOTE_CERT_CONTEXT,
                                    @remoteCertContext);
    CheckSspiError(FStatusCode);

    FPeerCertificate := TclCertificate.Create(remoteCertContext);
  finally
    if (remoteCertContext <> nil) then CertFreeCertificateContext(remoteCertContext);
  end;
end;

end.
