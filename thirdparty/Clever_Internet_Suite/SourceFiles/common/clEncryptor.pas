{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clEncryptor;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clUtils, clWUtils, clCryptUtils, clCryptAPI, clCertificateStore, clCertificate{$IFDEF LOGGER}, clLogger{$ENDIF};

type
  TclEncryptor = class(TComponent)
  private
    FSignAlgorithm: string;
    FSignStore: string;
    FEncryptCertificate: string;
    FEncodingType: Integer;
    FEncryptAlgorithm: string;
    FEncryptStore: string;
    FSignCertificate: string;
    FCertificateStore: TclCertificateStore;
    FExtractCertificates: Boolean;
    FOnProgress: TclProgressEvent;
    FExtractedCertificates: TclCertificateStore;

    procedure CheckCertificate(ACertificate: TclCertificate);
    procedure CheckCertificates(ACertificates: TclCertificateList);
    function FindCertificate(AStore: TclCertificateStore;
      const ACertificate: string; ARequirePrivateKey: Boolean): TclCertificate;
  protected
    function GetCertificateStore(const AStoreName: string): TclCertificateStore; virtual;
    function GetCertificate(const AStoreName, ACertificate: string; ARequirePrivateKey: Boolean): TclCertificate; virtual;
    function GetExtractedCertificate: TclCertificate; virtual;
    procedure DoProgress(ABytesProceed, ATotalBytes: Int64); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Close; virtual;

    procedure Sign(const ASourceFile, ADestinationFile: string; ADetachedSignature: Boolean); overload;
    procedure Sign(ASource, ADestination: TStream; ADetachedSignature: Boolean); overload;
    procedure Sign(ASource, ADestination: TStream; ADetachedSignature, AIncludeCertificate: Boolean;
      ACertificate: TclCertificate; ACertificates: TclCertificateList); overload;
    function Sign(const AData: TclCryptData; ADetachedSignature, AIncludeCertificate: Boolean;
      ACertificate: TclCertificate; ACertificates: TclCertificateList): TclCryptData; overload;
    function Sign(const AData: TclCryptData; ADetachedSignature, AIncludeCertificate: Boolean;
      ACertificate: TclCertificate): TclCryptData; overload;

    procedure VerifyEnveloped(const ASourceFile, ADestinationFile: string); overload;
    procedure VerifyEnveloped(ASource, ADestination: TStream); overload;
    procedure VerifyEnveloped(ASource, ADestination: TStream; ACertificate: TclCertificate); overload;
    function VerifyEnveloped(const AData: TclCryptData; ACertificate: TclCertificate): TclCryptData; overload;

    procedure VerifyDetached(const ASourceFile, ASignatureFile: string); overload;
    procedure VerifyDetached(ASource, ASignature: TStream); overload;
    procedure VerifyDetached(ASource, ASignature: TStream; ACertificate: TclCertificate); overload;
    procedure VerifyDetached(const AData, ASignature: TclCryptData; ACertificate: TclCertificate); overload;

    procedure Encrypt(const ASourceFile, ADestinationFile: string); overload;
    procedure Encrypt(ASource, ADestination: TStream); overload;
    procedure Encrypt(ASource, ADestination: TStream; ACertificates: TclCertificateList); overload;
    function Encrypt(const AData: TclCryptData; ACertificates: TclCertificateList): TclCryptData; overload;
    function Encrypt(const AData: TclCryptData; ACertificate: TclCertificate): TclCryptData; overload;

    procedure Decrypt(const ASourceFile, ADestinationFile: string); overload;
    procedure Decrypt(ASource, ADestination: TStream); overload;
    procedure Decrypt(ASource, ADestination: TStream; ACertificate: TclCertificate); overload;
    function Decrypt(const AData: TclCryptData; ACertificate: TclCertificate): TclCryptData; overload;

    property ExtractedCertificates: TclCertificateStore read FExtractedCertificates;
  published
    property SignStore: string read FSignStore write FSignStore;
    property EncryptStore: string read FEncryptStore write FEncryptStore;

    property SignCertificate: string read FSignCertificate write FSignCertificate;
    property EncryptCertificate: string read FEncryptCertificate write FEncryptCertificate;

    property SignAlgorithm: string read FSignAlgorithm write FSignAlgorithm;
    property EncryptAlgorithm: string read FEncryptAlgorithm write FEncryptAlgorithm;

    property EncodingType: Integer read FEncodingType write FEncodingType default DefaultEncoding;

    property ExtractCertificates: Boolean read FExtractCertificates write FExtractCertificates default True;

    property OnProgress: TclProgressEvent read FOnProgress write FOnProgress;
  end;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsEncryptorDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

implementation

{ TclEncryptor }

procedure TclEncryptor.CheckCertificates(ACertificates: TclCertificateList);
begin
  if (ACertificates.Count = 0) then
  begin
    RaiseCryptError(CertificateNotFound, CertificateNotFoundCode);
  end;
end;

procedure TclEncryptor.CheckCertificate(ACertificate: TclCertificate);
begin
  if (ACertificate = nil) then
  begin
    RaiseCryptError(CertificateNotFound, CertificateNotFoundCode);
  end;
end;

procedure TclEncryptor.Close;
begin
  if (FCertificateStore <> nil) then
  begin
    FCertificateStore.Close();
  end;
  ExtractedCertificates.Close();
end;

constructor TclEncryptor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FExtractedCertificates := TclCertificateStore.Create(nil);
  FExtractedCertificates.StoreName := 'addressbook';

  FCertificateStore := nil;
  FEncodingType := DefaultEncoding;
  FSignAlgorithm := szOID_RSA_SHA1RSA;
  FEncryptAlgorithm := szOID_RSA_RC2CBC;
  FExtractCertificates := True;
end;

function TclEncryptor.Decrypt(const AData: TclCryptData; ACertificate: TclCertificate): TclCryptData;
var
  decryptPara: CRYPT_DECRYPT_MESSAGE_PARA;
  cbDecrypted: DWORD;
  rghCertStore: array[0..0] of HCERTSTORE;
  hStore: HCERTSTORE;
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
    if (not IsEncryptorDemoDisplayed) and (not IsCertDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsEncryptorDemoDisplayed := True;
    IsCertDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Decrypt');{$ENDIF}
  if ExtractCertificates then
  begin
    ExtractedCertificates.ImportFromMessage(AData);
  end;

  CheckCertificate(ACertificate);

  Result := TclCryptData.Create();
  try
    ZeroMemory(@decryptPara, SizeOf(decryptPara));
    decryptPara.cbSize := SizeOf(decryptPara);
    decryptPara.dwMsgAndCertEncodingType := FEncodingType;
    decryptPara.rghCertStore := @rghCertStore[0];
    decryptPara.cCertStore := 1;
    cbDecrypted := 0;

    hStore := CertOpenStore(CERT_STORE_PROV_MEMORY, 0, nil, 0, nil);
    try
      if (hStore = nil)
        or (not CertAddCertificateContextToStore(hStore, ACertificate.Context, CERT_STORE_ADD_NEW, nil)) then
      begin
        RaiseCryptError('CertAddCertificateContextToStore');
      end;
      rghCertStore[0] := hStore;
      if CryptDecryptMessage(@decryptPara, AData.Data, AData.DataSize, nil, @cbDecrypted, nil) then
      begin
        Result.Allocate(cbDecrypted);
        if CryptDecryptMessage(@decryptPara, AData.Data, AData.DataSize, Result.Data, @cbDecrypted, nil) then
        begin
          Result.Reduce(cbDecrypted);
          Exit;
        end;
      end;

      RaiseCryptError('Decrypt');
    finally
      if (hStore <> nil) then
      begin
        CertCloseStore(hStore, 0);
      end;
    end;
  except
    Result.Free();
    raise;
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Decrypt'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Decrypt', E); raise; end; end;{$ENDIF}
end;

procedure TclEncryptor.Decrypt(ASource, ADestination: TStream; ACertificate: TclCertificate);
var
  srcData, dstData: TclCryptData;
  sourceSize, sourceStart: Integer;
begin
  sourceSize := ASource.Size - ASource.Position;
  sourceStart := ASource.Position;
  DoProgress(ASource.Position - sourceStart, sourceSize);

  srcData := nil;
  dstData := nil;
  try
    srcData := TclCryptData.Create();
    srcData.Allocate(ASource.Size - ASource.Position);

    ASource.Read(srcData.Data^, srcData.DataSize);

    dstData := Decrypt(srcData, ACertificate);
    ADestination.Write(dstData.Data^, dstData.DataSize);
  finally
    dstData.Free();
    srcData.Free();
  end;

  DoProgress(ASource.Position - sourceStart, sourceSize);
end;

procedure TclEncryptor.Decrypt(ASource, ADestination: TStream);
begin
  Decrypt(ASource, ADestination, GetCertificate(EncryptStore, EncryptCertificate, True));
end;

procedure TclEncryptor.Decrypt(const ASourceFile, ADestinationFile: string);
var
  src, dst: TStream;
begin
  src := nil;
  dst := nil;
  try
    src := TFileStream.Create(ASourceFile, fmOpenRead or fmShareDenyWrite);
    dst := TFileStream.Create(ADestinationFile, fmCreate);

    Decrypt(src, dst);
  finally
    dst.Free();
    src.Free();
  end;
end;

destructor TclEncryptor.Destroy;
begin
  Close();
  FreeAndNil(FCertificateStore);
  FExtractedCertificates.Free();

  inherited Destroy();
end;

procedure TclEncryptor.DoProgress(ABytesProceed, ATotalBytes: Int64);
begin
  if Assigned(FOnProgress) then
  begin
    FOnProgress(Self, ABytesProceed, ATotalBytes);
  end;
end;

function TclEncryptor.Encrypt(const AData: TclCryptData; ACertificate: TclCertificate): TclCryptData;
var
  list: TclCertificateList;
begin
  list := TclCertificateList.Create(False);
  try
    list.Add(ACertificate);
    Result := Encrypt(AData, list);
  finally
    list.Free();
  end;
end;

procedure TclEncryptor.Encrypt(const ASourceFile, ADestinationFile: string);
var
  src, dst: TStream;
begin
  src := nil;
  dst := nil;
  try
    src := TFileStream.Create(ASourceFile, fmOpenRead or fmShareDenyWrite);
    dst := TFileStream.Create(ADestinationFile, fmCreate);

    Encrypt(src, dst);
  finally
    dst.Free();
    src.Free();
  end;
end;

procedure TclEncryptor.Encrypt(ASource, ADestination: TStream);
var
  list: TclCertificateList;
  cert: TclCertificate;
begin
  list := TclCertificateList.Create(False);
  try
    cert := GetCertificate(EncryptStore, EncryptCertificate, False);
    list.Add(cert);
    Encrypt(ASource, ADestination, list);
  finally
    list.Free();
  end;
end;

procedure TclEncryptor.Encrypt(ASource, ADestination: TStream; ACertificates: TclCertificateList);
var
  srcData, dstData: TclCryptData;
  sourceSize, sourceStart: Integer;
begin
  sourceSize := ASource.Size - ASource.Position;
  sourceStart := ASource.Position;
  DoProgress(ASource.Position - sourceStart, sourceSize);

  srcData := nil;
  dstData := nil;
  try
    srcData := TclCryptData.Create();
    srcData.Allocate(ASource.Size - ASource.Position);

    ASource.Read(srcData.Data^, srcData.DataSize);

    dstData := Encrypt(srcData, ACertificates);
    ADestination.Write(dstData.Data^, dstData.DataSize);
  finally
    dstData.Free();
    srcData.Free();
  end;

  DoProgress(ASource.Position - sourceStart, sourceSize);
end;

function TclEncryptor.FindCertificate(AStore: TclCertificateStore;
  const ACertificate: string; ARequirePrivateKey: Boolean): TclCertificate;
begin
  Result := AStore.FindByEmail(ACertificate, ARequirePrivateKey);
  if (Result = nil) then
  begin
    Result := AStore.FindByIssuedTo(ACertificate, ARequirePrivateKey);
  end;
  if (Result = nil) then
  begin
    Result := AStore.FindBySerialNo(ACertificate, '', ARequirePrivateKey);
  end;
end;

function TclEncryptor.GetCertificate(const AStoreName, ACertificate: string; ARequirePrivateKey: Boolean): TclCertificate;
begin
  if (AStoreName <> '') and (ACertificate <> '') then
  begin
    Result := FindCertificate(GetCertificateStore(AStoreName), ACertificate, ARequirePrivateKey);
  end else
  begin
    Result := nil;
  end;
end;

function TclEncryptor.GetCertificateStore(const AStoreName: string): TclCertificateStore;
begin
  if (FCertificateStore = nil) then
  begin
    FCertificateStore := TclCertificateStore.Create(nil);
    FCertificateStore.Open(AStoreName);
  end;
  Result := FCertificateStore;

  if (Result.StoreName <> AStoreName) then
  begin
    Result.Open(AStoreName);
  end;
end;

function TclEncryptor.GetExtractedCertificate: TclCertificate;
begin
  Result := FindCertificate(ExtractedCertificates, SignCertificate, False);

  if (Result = nil) and (ExtractedCertificates.Items.Count > 0) then
  begin
    Result := ExtractedCertificates.Items[0];
  end;
end;

function TclEncryptor.Sign(const AData: TclCryptData; ADetachedSignature, AIncludeCertificate: Boolean;
  ACertificate: TclCertificate; ACertificates: TclCertificateList): TclCryptData;
var
  data: array[0..0] of PByte;
  msgCert: PCCERT_CONTEXT;
  dwDataSizeArray: array[0..0] of DWORD;
  sigParams: CRYPT_SIGN_MESSAGE_PARA;
  cbSignedBlob: DWORD;
  p: ^PCCERT_CONTEXT;
  i, cnt: Integer;
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
    if (not IsEncryptorDemoDisplayed) and (not IsCertDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsEncryptorDemoDisplayed := True;
    IsCertDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  CheckCertificate(ACertificate);

{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Sign');{$ENDIF}
  Result := TclCryptData.Create();
  try
    ZeroMemory(@sigParams, SizeOf(CRYPT_SIGN_MESSAGE_PARA));
    sigParams.cbSize := SizeOf(CRYPT_SIGN_MESSAGE_PARA);
    sigParams.dwMsgEncodingType := FEncodingType;
    sigParams.pSigningCert := ACertificate.Context;
    sigParams.HashAlgorithm.pszObjId := PclChar(GetTclString(FSignAlgorithm));

    if (ACertificates <> nil) then
    begin
      cnt := ACertificates.Count;
    end else
    begin
      cnt := 0;
    end;

    GetMem(msgCert, SizeOf(PCCERT_CONTEXT) * (cnt + 1));
    try
      if AIncludeCertificate then
      begin
        p := Pointer(TclIntPtr(msgCert) + SizeOf(PCCERT_CONTEXT) * 0);
        p^ := ACertificate.Context;

        for i := 0 to cnt - 1 do
        begin
          p := Pointer(TclIntPtr(msgCert) + SizeOf(PCCERT_CONTEXT) * (i + 1));
          p^ := ACertificates[i].Context;
        end;

        sigParams.cMsgCert := cnt + 1;
        sigParams.rgpMsgCert := msgCert;
      end;

      data[0] := AData.Data;
      dwDataSizeArray[0] := AData.DataSize;
      cbSignedBlob := 0;
      if CryptSignMessage(@sigParams, ADetachedSignature, 1, @data[0], @dwDataSizeArray[0], nil, @cbSignedBlob) then
      begin
        Result.Allocate(cbSignedBlob);
        if CryptSignMessage(@sigParams, ADetachedSignature, 1, @data[0], @dwDataSizeArray[0], Result.Data, @cbSignedBlob) then
        begin
          Result.Reduce(cbSignedBlob);
          Exit;
        end;
      end;

      RaiseCryptError('Sign');
    finally
      FreeMem(msgCert);
    end;
  except
    Result.Free();
    raise;
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Sign'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Sign', E); raise; end; end;{$ENDIF}
end;

function TclEncryptor.Sign(const AData: TclCryptData; ADetachedSignature, AIncludeCertificate: Boolean;
  ACertificate: TclCertificate): TclCryptData;
begin
  Result := Sign(AData, ADetachedSignature, AIncludeCertificate, ACertificate, nil);
end;

procedure TclEncryptor.Sign(const ASourceFile, ADestinationFile: string; ADetachedSignature: Boolean);
var
  src, dst: TStream;
begin
  src := nil;
  dst := nil;
  try
    src := TFileStream.Create(ASourceFile, fmOpenRead or fmShareDenyWrite);
    dst := TFileStream.Create(ADestinationFile, fmCreate);

    Sign(src, dst, ADetachedSignature);
  finally
    dst.Free();
    src.Free();
  end;
end;

procedure TclEncryptor.Sign(ASource, ADestination: TStream; ADetachedSignature: Boolean);
begin
  Sign(ASource, ADestination, ADetachedSignature, True, GetCertificate(SignStore, SignCertificate, True), nil);
end;

procedure TclEncryptor.Sign(ASource, ADestination: TStream; ADetachedSignature,
  AIncludeCertificate: Boolean; ACertificate: TclCertificate; ACertificates: TclCertificateList);
var
  srcData, dstData: TclCryptData;
  sourceSize, sourceStart: Integer;
begin
  sourceSize := ASource.Size - ASource.Position;
  sourceStart := ASource.Position;
  DoProgress(ASource.Position - sourceStart, sourceSize);

  srcData := nil;
  dstData := nil;
  try
    srcData := TclCryptData.Create();
    srcData.Allocate(ASource.Size - ASource.Position);

    ASource.Read(srcData.Data^, srcData.DataSize);

    dstData := Sign(srcData, ADetachedSignature, AIncludeCertificate, ACertificate, ACertificates);
    ADestination.Write(dstData.Data^, dstData.DataSize);
  finally
    dstData.Free();
    srcData.Free();
  end;

  DoProgress(ASource.Position - sourceStart, sourceSize);
end;

function GetSignerCertificate(pvGetArg: PVOID;
  dwCertEncodingType: DWORD; pSignerId: PCERT_INFO;
  hMsgCertStore: HCERTSTORE): PCCERT_CONTEXT; stdcall;
begin
  Result := CertDuplicateCertificateContext(PCCERT_CONTEXT(pvGetArg));
end;

procedure TclEncryptor.VerifyDetached(const AData, ASignature: TclCryptData; ACertificate: TclCertificate);
var
  verifyPara: CRYPT_VERIFY_MESSAGE_PARA;
  rgpbToBeSigned: array[0..0] of PBYTE;
  rgcbToBeSigned: array[0..0] of DWORD;
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
    if (not IsEncryptorDemoDisplayed) and (not IsCertDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsEncryptorDemoDisplayed := True;
    IsCertDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'VerifyDetached');{$ENDIF}
  if ExtractCertificates then
  begin
    ExtractedCertificates.ImportFromMessage(ASignature);
  end;

  if (ACertificate = nil) then
  begin
    ACertificate := GetExtractedCertificate();
  end;

  CheckCertificate(ACertificate);

  ZeroMemory(@verifyPara, SizeOf(verifyPara));
  verifyPara.cbSize := SizeOf(verifyPara);
  verifyPara.dwMsgAndCertEncodingType := FEncodingType;
  verifyPara.pfnGetSignerCertificate := GetSignerCertificate;
  verifyPara.pvGetArg := ACertificate.Context;
  rgpbToBeSigned[0] := AData.Data;
  rgcbToBeSigned[0] := AData.DataSize;
  if not CryptVerifyDetachedMessageSignature(@verifyPara,
    0, ASignature.Data, ASignature.DataSize, 1, @rgpbToBeSigned[0], @rgcbToBeSigned[0], nil) then
  begin
    RaiseCryptError('CryptVerifyDetachedMessageSignature');
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'VerifyDetached'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'VerifyDetached', E); raise; end; end;{$ENDIF}
end;

procedure TclEncryptor.VerifyEnveloped(const ASourceFile, ADestinationFile: string);
var
  src, dst: TStream;
begin
  src := nil;
  dst := nil;
  try
    src := TFileStream.Create(ASourceFile, fmOpenRead or fmShareDenyWrite);
    dst := TFileStream.Create(ADestinationFile, fmCreate);

    VerifyEnveloped(src, dst);
  finally
    dst.Free();
    src.Free();
  end;
end;

procedure TclEncryptor.VerifyEnveloped(ASource, ADestination: TStream);
begin
  VerifyEnveloped(ASource, ADestination, GetCertificate(SignStore, SignCertificate, False));
end;

procedure TclEncryptor.VerifyEnveloped(ASource, ADestination: TStream; ACertificate: TclCertificate);
var
  srcData, dstData: TclCryptData;
  sourceSize, sourceStart: Integer;
begin
  sourceSize := ASource.Size - ASource.Position;
  sourceStart := ASource.Position;
  DoProgress(ASource.Position - sourceStart, sourceSize);

  srcData := nil;
  dstData := nil;
  try
    srcData := TclCryptData.Create();
    srcData.Allocate(ASource.Size - ASource.Position);

    ASource.Read(srcData.Data^, srcData.DataSize);

    dstData := VerifyEnveloped(srcData, ACertificate);
    ADestination.Write(dstData.Data^, dstData.DataSize);
  finally
    dstData.Free();
    srcData.Free();
  end;

  DoProgress(ASource.Position - sourceStart, sourceSize);
end;

procedure TclEncryptor.VerifyDetached(ASource, ASignature: TStream; ACertificate: TclCertificate);
var
  srcData, sigData: TclCryptData;
  sourceSize, sourceStart: Integer;
begin
  sourceSize := ASource.Size - ASource.Position;
  sourceStart := ASource.Position;
  DoProgress(ASource.Position - sourceStart, sourceSize);

  srcData := nil;
  sigData := nil;
  try
    srcData := TclCryptData.Create();
    srcData.Allocate(ASource.Size - ASource.Position);
    ASource.Read(srcData.Data^, srcData.DataSize);

    sigData := TclCryptData.Create();
    sigData.Allocate(ASignature.Size - ASignature.Position);
    ASignature.Read(sigData.Data^, sigData.DataSize);

    VerifyDetached(srcData, sigData, ACertificate);
  finally
    sigData.Free();
    srcData.Free();
  end;

  DoProgress(ASource.Position - sourceStart, sourceSize);
end;

procedure TclEncryptor.VerifyDetached(ASource, ASignature: TStream);
begin
  VerifyDetached(ASource, ASignature, GetCertificate(SignStore, SignCertificate, False));
end;

procedure TclEncryptor.VerifyDetached(const ASourceFile, ASignatureFile: string);
var
  src, sig: TStream;
begin
  src := nil;
  sig := nil;
  try
    src := TFileStream.Create(ASourceFile, fmOpenRead or fmShareDenyWrite);
    sig := TFileStream.Create(ASignatureFile, fmOpenRead or fmShareDenyWrite);

    VerifyDetached(src, sig);
  finally
    sig.Free();
    src.Free();
  end;
end;

function TclEncryptor.VerifyEnveloped(const AData: TclCryptData; ACertificate: TclCertificate): TclCryptData;
var
  verifyPara: CRYPT_VERIFY_MESSAGE_PARA;
  cbVerified: DWORD;
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
    if (not IsEncryptorDemoDisplayed) and (not IsCertDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsEncryptorDemoDisplayed := True;
    IsCertDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'VerifyEnveloped');{$ENDIF}
  if ExtractCertificates then
  begin
    ExtractedCertificates.ImportFromMessage(AData);
  end;

  if (ACertificate = nil) then
  begin
    ACertificate := GetExtractedCertificate();
  end;

  CheckCertificate(ACertificate);

  Result := TclCryptData.Create();
  try
    ZeroMemory(@verifyPara, SizeOf(verifyPara));
    verifyPara.cbSize := SizeOf(verifyPara);
    verifyPara.dwMsgAndCertEncodingType := FEncodingType;
    verifyPara.pfnGetSignerCertificate := GetSignerCertificate;
    verifyPara.pvGetArg := ACertificate.Context;
    cbVerified := 0;
    if CryptVerifyMessageSignature(@verifyPara, 0, AData.Data, AData.DataSize, nil, @cbVerified, nil) then
    begin
      Result.Allocate(cbVerified);
      if CryptVerifyMessageSignature(@verifyPara, 0, AData.Data, AData.DataSize, Result.Data, @cbVerified, nil) then
      begin
        Result.Reduce(cbVerified);
        Exit;
      end;
    end;

    RaiseCryptError('VerifyEnveloped');
  except
    Result.Free();
    raise;
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'VerifyEnveloped'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'VerifyEnveloped', E); raise; end; end;{$ENDIF}
end;

function TclEncryptor.Encrypt(const AData: TclCryptData; ACertificates: TclCertificateList): TclCryptData;
var
  i: Integer;
  encryptPara: CRYPT_ENCRYPT_MESSAGE_PARA;
  cbEncrypted: DWORD;
  gpRecipientCerts: PCCERT_CONTEXT;
  p: ^PCCERT_CONTEXT;
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
    if (not IsEncryptorDemoDisplayed) and (not IsCertDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsEncryptorDemoDisplayed := True;
    IsCertDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  CheckCertificates(ACertificates);

  Result := TclCryptData.Create();
  try
    ZeroMemory(@encryptPara, SizeOf(encryptPara));
    encryptPara.cbSize := SizeOf(encryptPara);
    encryptPara.dwMsgEncodingType := FEncodingType;
    encryptPara.ContentEncryptionAlgorithm.pszObjId := PclChar(GetTclString(FEncryptAlgorithm));

    GetMem(gpRecipientCerts, SizeOf(PCCERT_CONTEXT) * ACertificates.Count);
    try
      for i := 0 to ACertificates.Count - 1 do
      begin
        p := Pointer(TclIntPtr(gpRecipientCerts) + SizeOf(PCCERT_CONTEXT) * i);
        p^ := ACertificates[i].Context;
      end;

      cbEncrypted := 0;
      if CryptEncryptMessage(@encryptPara, ACertificates.Count, gpRecipientCerts, AData.Data, AData.DataSize, nil, @cbEncrypted) then
      begin
        Result.Allocate(cbEncrypted);
        if CryptEncryptMessage(@encryptPara, ACertificates.Count, gpRecipientCerts, AData.Data, AData.DataSize, Result.Data, @cbEncrypted) then
        begin
          Result.Reduce(cbEncrypted);
          Exit;
        end;
      end;
    finally
      FreeMem(gpRecipientCerts);
    end;

    RaiseCryptError('Encrypt');
  except
    Result.Free();
    raise;
  end;
end;

end.
