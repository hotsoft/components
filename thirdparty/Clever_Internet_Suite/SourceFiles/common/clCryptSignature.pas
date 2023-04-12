{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCryptSignature;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clUtils, clCryptAPI, clWUtils, clConfig;

type
  TclSignature = class(TclConfigObject)
  public
    procedure Init; virtual; abstract;
    procedure Update(const ABuffer: TclByteArray; AStart, ALen: Integer); virtual; abstract;
    procedure Verify(const ASignature: TclByteArray); virtual; abstract;
    function Sign: TclByteArray; virtual; abstract;
  end;

  TclRsaKey = class(TclConfigObject)
  private
    FKeyLength: Integer;
    FKeyType: Integer;
  public
    procedure Init; virtual; abstract;
    procedure GenerateKey; virtual; abstract;

    function GetRsaPrivateKey: TclByteArray; virtual; abstract;
    function GetRsaPublicKey: TclByteArray; virtual; abstract;
    function GetPublicKeyInfo: TclByteArray; virtual; abstract;

    procedure SetRsaPrivateKey(const AKey: TclByteArray); virtual; abstract;
    procedure SetRsaPublicKey(const AKey: TclByteArray); virtual; abstract;
    procedure SetPublicKeyInfo(const AKey: TclByteArray); virtual; abstract;
    procedure SetPublicKeyParams(const AModulus, AExponent: TclByteArray); virtual; abstract;
    procedure GetPublicKeyParams(var AModulus, AExponent: TclByteArray); virtual; abstract;

    property KeyLength: Integer read FKeyLength write FKeyLength;
    property KeyType: Integer read FKeyType write FKeyType;
  end;

  TclSignatureRsa = class(TclSignature)
  public
    procedure SetPrivateKey(AKey: TclRsaKey); virtual; abstract;
    procedure SetPublicKey(AKey: TclRsaKey); virtual; abstract;
  end;

  TclCryptApiRsaKey = class(TclRsaKey)
  private
    FContext: HCRYPTPROV;
    FKey: HCRYPTKEY;
    FCSPPtr: PclChar;

    procedure Clear;
    function GetCSPPtr: PclChar;
    function GetExponent(AE: TclByteArray): DWORD;
  protected
    procedure LoadKeyInfo;
    function GetCSP: string; virtual;
    function GetProviderType: Integer; virtual;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Init; override;
    procedure GenerateKey; override;

    function GetRsaPrivateKey: TclByteArray; override;
    function GetRsaPublicKey: TclByteArray; override;
    function GetPublicKeyInfo: TclByteArray; override;

    procedure SetRsaPrivateKey(const AKey: TclByteArray); override;
    procedure SetRsaPublicKey(const AKey: TclByteArray); override;
    procedure SetPublicKeyInfo(const AKey: TclByteArray); override;
    procedure SetPublicKeyParams(const AModulus, AExponent: TclByteArray); override;
    procedure GetPublicKeyParams(var AModulus, AExponent: TclByteArray); override;
  end;

  TclCryptApiSignatureRsa = class(TclSignatureRsa)
  private
    FContext: HCRYPTPROV;
    FKey: HCRYPTKEY;
    FHash: HCRYPTHASH;
    FCSPPtr: PclChar;
    FKeyType: Integer;

    procedure Clear;
    function GetCSPPtr: PclChar;
  protected
    function GetHashAlgorithm: ALG_ID; virtual; abstract;
    function GetCSP: string; virtual; abstract;
    function GetProviderType: Integer; virtual; abstract;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Init; override;

    procedure SetPrivateKey(AKey: TclRsaKey); override;
    procedure SetPublicKey(AKey: TclRsaKey); override;

    procedure Update(const ABuffer: TclByteArray; AStart, ALen: Integer); override;
    procedure Verify(const ASignature: TclByteArray); override;
    function Sign: TclByteArray; override;
  end;

  TclSignatureRsaSha1 = class(TclCryptApiSignatureRsa)
  protected
    function GetHashAlgorithm: ALG_ID; override;
    function GetCSP: string; override;
    function GetProviderType: Integer; override;
  end;

  TclSignatureRsaSha256 = class(TclCryptApiSignatureRsa)
  protected
    function GetHashAlgorithm: ALG_ID; override;
    function GetCSP: string; override;
    function GetProviderType: Integer; override;
  end;

implementation

uses
  clCryptUtils, clEncoder, clTranslator;

{ TclSignatureRsa }

procedure TclCryptApiSignatureRsa.Clear;
begin
  if (FKey <> nil) then
  begin
    CryptDestroyKey(FKey);
    FKey := nil;
  end;

  if (FHash <> nil) then
  begin
    CryptDestroyHash(FHash);
    FHash := nil;
  end;

  if (FContext <> nil) then
  begin
    CryptReleaseContext(FContext, 0);
    FContext := nil;
  end;

  FreeMem(FCSPPtr);
  FCSPPtr := nil;
end;

constructor TclCryptApiSignatureRsa.Create;
begin
  inherited Create();

  FContext := nil;
  FHash := nil;
  FKey := nil;
  FKeyType := AT_KEYEXCHANGE;
end;

destructor TclCryptApiSignatureRsa.Destroy;
begin
  Clear();

  inherited Destroy();
end;

function TclCryptApiSignatureRsa.GetCSPPtr: PclChar;
var
  s: TclString;
  len: Integer;
begin
  Result := FCSPPtr;
  if (Result <> nil) then Exit;

  if (Trim(GetCSP()) <> '') then
  begin
    s := GetTclString(GetCSP());
    len := Length(s);
    GetMem(FCSPPtr, len + SizeOf(TclChar));
    system.Move(PclChar(s)^, FCSPPtr^, len);
    FCSPPtr[len] := #0;
  end;
  Result := FCSPPtr;
end;

procedure TclCryptApiSignatureRsa.Init;
begin
  Clear();

  if not CryptAcquireContext(@FContext, nil, GetCSPPtr(), GetProviderType(), CRYPT_VERIFYCONTEXT) then
  begin
    RaiseCryptError('CryptAcquireContext');
  end;

  if not CryptCreateHash(FContext, GetHashAlgorithm(), nil, 0, @FHash) then
  begin
    RaiseCryptError('CryptCreateHash');
  end;
end;

procedure TclCryptApiSignatureRsa.SetPrivateKey(AKey: TclRsaKey);
var
  key: TclByteArray;
  der, keyBlob: TclCryptData;
  size: DWORD;
begin
  Assert(FContext <> nil);

  FKeyType := AKey.KeyType;

  key := AKey.GetRsaPrivateKey();

  if (key = nil) then
  begin
    RaiseCryptError(CryptKeyRequired, CryptKeyRequiredCode);
  end;

  if (FKey <> nil) then
  begin
    CryptDestroyKey(FKey);
    FKey := nil;
  end;

  der := nil;
  keyBlob := nil;
  try
    der := TclCryptData.Create();
    der.FromBytes(key);

    size := 0;
    if not CryptDecodeObjectEx(DefaultEncoding, PKCS_RSA_PRIVATE_KEY, der.Data, der.DataSize, 0, nil, nil, @size) then
    begin
      RaiseCryptError('CryptDecodeObjectEx');
    end;

    keyBlob := TclCryptData.Create(size);

    if not CryptDecodeObjectEx(DefaultEncoding, PKCS_RSA_PRIVATE_KEY, der.Data, der.DataSize, 0, nil, keyBlob.Data, @size) then
    begin
      RaiseCryptError('CryptDecodeObjectEx');
    end;

    keyBlob.Reduce(size);

    if not CryptImportKey(FContext, keyBlob.Data, keyBlob.DataSize, nil, 0, @FKey) then
    begin
      RaiseCryptError('CryptImportKey');
    end;
  finally
    keyBlob.Free();
    der.Free();
  end;
end;

procedure TclCryptApiSignatureRsa.SetPublicKey(AKey: TclRsaKey);
var
  key: TclByteArray;
  der, keyBlob: TclCryptData;
  size: DWORD;
begin
  Assert(FContext <> nil);

  FKeyType := AKey.KeyType;

  key := AKey.GetRsaPublicKey();

  if (key = nil) then
  begin
    RaiseCryptError(CryptKeyRequired, CryptKeyRequiredCode);
  end;

  if (FKey <> nil) then
  begin
    CryptDestroyKey(FKey);
    FKey := nil;
  end;

  der := nil;
  keyBlob := nil;
  try
    der := TclCryptData.Create();
    der.FromBytes(key);

    size := 0;
    if not CryptDecodeObjectEx(DefaultEncoding, RSA_CSP_PUBLICKEYBLOB, der.Data, der.DataSize, 0, nil, nil, @size) then
    begin
      RaiseCryptError('CryptDecodeObjectEx');
    end;

    keyBlob := TclCryptData.Create(size);

    if not CryptDecodeObjectEx(DefaultEncoding, RSA_CSP_PUBLICKEYBLOB, der.Data, der.DataSize, 0, nil, keyBlob.Data, @size) then
    begin
      RaiseCryptError('CryptDecodeObjectEx');
    end;

    keyBlob.Reduce(size);

    if not CryptImportKey(FContext, keyBlob.Data, keyBlob.DataSize, nil, 0, @FKey) then
    begin
      RaiseCryptError('CryptImportKey');
    end;
  finally
    keyBlob.Free();
    der.Free();
  end;
end;

function TclCryptApiSignatureRsa.Sign: TclByteArray;
var
  sig: TclCryptData;
  size: DWORD;
begin
  Assert(FHash <> nil);

  sig := nil;
  try
    size := 0;
    if (not CryptSignHash(FHash, FKeyType, nil, 0, nil, @size)) then
    begin
      RaiseCryptError('CryptSignHash');
    end;

    sig := TclCryptData.Create(size);

    if (not CryptSignHash(FHash, FKeyType, nil, 0, sig.Data, @size)) then
    begin
      RaiseCryptError('CryptSignHash');
    end;

    sig.Reduce(size);

    Result := sig.ToBytes();

    Result := ReversedBytes(Result);
  finally
    sig.Free();
  end;
end;

procedure TclCryptApiSignatureRsa.Update(const ABuffer: TclByteArray; AStart, ALen: Integer);
begin
  Assert(FHash <> nil);

  if not CryptHashData(FHash, Pointer(TclIntPtr(ABuffer) + AStart), ALen, 0) then
  begin
    RaiseCryptError('CryptHashData');
  end;
end;

procedure TclCryptApiSignatureRsa.Verify(const ASignature: TclByteArray);
var
  sig: TclCryptData;
  sigBytes: TclByteArray;
begin
  Assert(FHash <> nil);

  if (FKey = nil) then
  begin
    RaiseCryptError(CryptKeyRequired, CryptKeyRequiredCode);
  end;

  sig := TclCryptData.Create();
  try
    sigBytes := ReversedBytes(ASignature);

    sig.FromBytes(sigBytes);

    if (not CryptVerifySignature(FHash, sig.Data, sig.DataSize, FKey, nil, 0)) then
    begin
      RaiseCryptError('CryptVerifySignature');
    end;
  finally
    sig.Free();
  end;
end;

{ TclSignatureRsaSha1 }

function TclSignatureRsaSha1.GetHashAlgorithm: ALG_ID;
begin
  Result := CALG_SHA1;
end;

function TclSignatureRsaSha1.GetCSP: string;
begin
  Result := MS_ENHANCED_PROV;
end;

function TclSignatureRsaSha1.GetProviderType: Integer;
begin
  Result := PROV_RSA_FULL;
end;

{ TclSignatureRsaSha256 }

function TclSignatureRsaSha256.GetHashAlgorithm: ALG_ID;
begin
  Result := CALG_SHA_256;
end;

function TclSignatureRsaSha256.GetCSP: string;
begin
  Result := MS_ENH_RSA_AES_PROV;
end;

function TclSignatureRsaSha256.GetProviderType: Integer;
begin
  Result := PROV_RSA_AES;
end;

{ TclRsaKey }

procedure TclCryptApiRsaKey.Clear;
begin
  if (FKey <> nil) then
  begin
    CryptDestroyKey(FKey);
    FKey := nil;
  end;

  if (FContext <> nil) then
  begin
    CryptReleaseContext(FContext, 0);
    FContext := nil;
  end;

  FreeMem(FCSPPtr);
  FCSPPtr := nil;
end;

constructor TclCryptApiRsaKey.Create;
begin
  inherited Create();

  FContext := nil;
  FKey := nil;
  FKeyLength := 1024;
  FKeyType := AT_KEYEXCHANGE;
end;

destructor TclCryptApiRsaKey.Destroy;
begin
  Clear();

  inherited Destroy();
end;

procedure TclCryptApiRsaKey.GenerateKey;
var
  flags: DWORD;
begin
  Assert(FContext <> nil);

  if (FKey <> nil) then
  begin
    CryptDestroyKey(FKey);
    FKey := nil;
  end;

  flags := (KeyLength shl $10) or 1;
  if not CryptGenKey(FContext, KeyType, flags, @FKey) then
  begin
    RaiseCryptError('CryptGenKey');
  end;
end;

function TclCryptApiRsaKey.GetCSP: string;
begin
  Result := MS_ENHANCED_PROV;
end;

function TclCryptApiRsaKey.GetCSPPtr: PclChar;
var
  s: TclString;
  len: Integer;
begin
  Result := FCSPPtr;
  if (Result <> nil) then Exit;

  if (Trim(GetCSP()) <> '') then
  begin
    s := GetTclString(GetCSP());
    len := Length(s);
    GetMem(FCSPPtr, len + SizeOf(TclChar));
    system.Move(PclChar(s)^, FCSPPtr^, len);
    FCSPPtr[len] := #0;
  end;
  Result := FCSPPtr;
end;

function TclCryptApiRsaKey.GetExponent(AE: TclByteArray): DWORD;
var
  len, ind: Integer;
begin
  Result := 0;

  len := Length(AE);
  if (len = 1) then
  begin
    Result := AE[0];
  end else
  if (len = 2) then
  begin
    ind := 0;
    Result := ByteArrayReadWord(AE, ind);
  end else
  if (len = 3) then
  begin
    ind := 0;
    Result := AE[ind] shl 16;
    Inc(ind);
    Result := Result or ByteArrayReadWord(AE, ind);
  end else
  if (len > 3) then
  begin
    ind := 0;
    Result := ByteArrayReadDWord(AE, ind);
  end;
end;

function TclCryptApiRsaKey.GetRsaPrivateKey: TclByteArray;
var
  key, der: TclCryptData;
  len: DWORD;
begin
  if (FKey = nil) then
  begin
    RaiseCryptError(CryptKeyRequired, CryptKeyRequiredCode);
  end;

  len := 0;
  if not CryptExportKey(FKey, nil, PRIVATEKEYBLOB, 0, nil, @len) then
  begin
    RaiseCryptError('CryptExportKey');
  end;

  key := nil;
  der := nil;
  try
    key := TclCryptData.Create(len);

    if not CryptExportKey(FKey, nil, PRIVATEKEYBLOB, 0, key.Data, @len) then
    begin
      RaiseCryptError('CryptExportKey');
    end;
    key.Reduce(len);

    len := 0;
    if not CryptEncodeObjectEx(DefaultEncoding,
      PKCS_RSA_PRIVATE_KEY, key.Data, 0, nil, nil, @len) then
    begin
      RaiseCryptError('CryptEncodeObjectEx');
    end;

    der := TclCryptData.Create(len);

    if not CryptEncodeObjectEx(DefaultEncoding,
      PKCS_RSA_PRIVATE_KEY, key.Data, 0, nil, der.Data, @len) then
    begin
      RaiseCryptError('CryptEncodeObjectEx');
    end;
    der.Reduce(len);

    Result := der.ToBytes();
  finally
    der.Free();
    key.Free();
  end;
end;

function TclCryptApiRsaKey.GetProviderType: Integer;
begin
  Result := PROV_RSA_FULL;
end;

function TclCryptApiRsaKey.GetRsaPublicKey: TclByteArray;
var
  len: DWORD;
  key, der: TclCryptData;
begin
  if (FKey = nil) then
  begin
    RaiseCryptError(CryptKeyRequired, CryptKeyRequiredCode);
  end;

  len := 0;
  if not CryptExportKey(FKey, nil, PUBLICKEYBLOB, 0, nil, @len) then
  begin
    RaiseCryptError('CryptExportKey');
  end;

  key := nil;
  der := nil;
  try
    key := TclCryptData.Create(len);

    if not CryptExportKey(FKey, nil, PUBLICKEYBLOB, 0, key.Data, @len) then
    begin
      RaiseCryptError('CryptExportKey');
    end;

    len := 0;
    if not CryptEncodeObjectEx(DefaultEncoding,
      RSA_CSP_PUBLICKEYBLOB, key.Data, 0, nil, nil, @len) then
    begin
      RaiseCryptError('CryptEncodeObjectEx');
    end;

    der := TclCryptData.Create(len);

    if not CryptEncodeObjectEx(DefaultEncoding,
      RSA_CSP_PUBLICKEYBLOB, key.Data, 0, nil, der.Data, @len) then
    begin
      RaiseCryptError('CryptEncodeObjectEx');
    end;
    der.Reduce(len);

    Result := der.ToBytes();
  finally
    der.Free();
    key.Free();
  end;
end;

function TclCryptApiRsaKey.GetPublicKeyInfo: TclByteArray;
const
  params: array[0..1] of Byte = (5, 0);
var
  len: DWORD;
  key, keyInfo, der: TclCryptData;
  pki: PCERT_PUBLIC_KEY_INFO;
begin
  if (FKey = nil) then
  begin
    RaiseCryptError(CryptKeyRequired, CryptKeyRequiredCode);
  end;

  key := nil;
  keyInfo := nil;
  der := nil;
  try
    key := TclCryptData.Create();

    key.FromBytes(GetRsaPublicKey());

    keyInfo := TclCryptData.Create(SizeOf(CERT_PUBLIC_KEY_INFO));

    pki := PCERT_PUBLIC_KEY_INFO(keyInfo.Data);

    pki.Algorithm.pszObjId := szOID_RSA_RSA;
    pki.Algorithm.Parameters.cbData := 2;
    pki.Algorithm.Parameters.pbData := @params;
    pki.PublicKey.cbData := key.DataSize;
    pki.PublicKey.pbData := key.Data;
    pki.PublicKey.cUnusedBits := 0;

    len := 0;
    if not CryptEncodeObjectEx(DefaultEncoding,
      X509_PUBLIC_KEY_INFO, keyInfo.Data, 0, nil, nil, @len) then
    begin
      RaiseCryptError('CryptEncodeObjectEx');
    end;

    der := TclCryptData.Create(len);

    if not CryptEncodeObjectEx(DefaultEncoding,
      X509_PUBLIC_KEY_INFO, keyInfo.Data, 0, nil, der.Data, @len) then
    begin
      RaiseCryptError('CryptEncodeObjectEx');
    end;
    der.Reduce(len);

    Result := der.ToBytes();
  finally
    der.Free();
    keyInfo.Free();
    key.Free();
  end;
end;

procedure TclCryptApiRsaKey.GetPublicKeyParams(var AModulus, AExponent: TclByteArray);
var
  len: DWORD;
  ind: Integer;
  rsaPubK: PRSAPUBKEY;
  keyBlob: TclCryptData;
  modulus: PByte;
begin
  AModulus := nil;
  AExponent := nil;

  if (FKey = nil) then
  begin
    RaiseCryptError(CryptKeyRequired, CryptKeyRequiredCode);
  end;

  len := 0;
  if not CryptExportKey(FKey, nil, PUBLICKEYBLOB, 0, nil, @len) then
  begin
    RaiseCryptError('CryptExportKey');
  end;

  keyBlob := TclCryptData.Create(len);
  try
    if not CryptExportKey(FKey, nil, PUBLICKEYBLOB, 0, keyBlob.Data, @len) then
    begin
      RaiseCryptError('CryptExportKey');
    end;

    rsaPubK := PRSAPUBKEY(TclIntPtr(keyBlob.Data) + SizeOf(BLOBHEADER));

    SetLength(AExponent, 4);
    ind := 0;
    ByteArrayWriteDWord(rsaPubK.pubexp, AExponent, ind);
    AExponent := UnfoldBytesWithZero(AExponent);

    modulus := PByte(TclIntPtr(keyBlob.Data) + SizeOf(BLOBHEADER) + SizeOf(RSAPUBKEY));
    SetLength(AModulus, rsaPubK.bitlen div 8);
    System.Move(modulus^, AModulus[0], Length(AModulus));

    AModulus := ReversedBytes(AModulus);
  finally
    keyBlob.Free();
  end;
end;

procedure TclCryptApiRsaKey.Init;
begin
  Clear();

  if not CryptAcquireContext(@FContext, nil, GetCSPPtr(), GetProviderType(), CRYPT_VERIFYCONTEXT) then
  begin
    RaiseCryptError('CryptAcquireContext');
  end;
end;

procedure TclCryptApiRsaKey.LoadKeyInfo;
var
  hKey: HCRYPTKEY;
  data: TclCryptData;
  len: Integer;
begin
  hKey := nil;
  try
    if CryptGetUserKey(FContext, AT_KEYEXCHANGE, @hKey) then
    begin
      FKeyType := AT_KEYEXCHANGE;
    end else
    if CryptGetUserKey(FContext, AT_SIGNATURE, @hKey) then
    begin
      FKeyType := AT_SIGNATURE;
    end;
  finally
    if (hKey <> nil) then
    begin
      CryptDestroyKey(hKey);
    end;
  end;

  data := TclCryptData.Create(256);
  try
    len := data.DataSize;
    if CryptGetKeyParam(FKey, KP_KEYLEN, data.Data, @len, 0) then
    begin
      if (len >= 4) then
      begin
        FKeyLength := DWORD(Pointer(data.Data)^);
      end;
    end;
  finally
    data.Free();
  end;
end;

procedure TclCryptApiRsaKey.SetPublicKeyInfo(const AKey: TclByteArray);
var
  der, keyBlob: TclCryptData;
  size: DWORD;
begin
  Assert(FContext <> nil);

  if (AKey = nil) then
  begin
    RaiseCryptError(CryptKeyRequired, CryptKeyRequiredCode);
  end;

  if (FKey <> nil) then
  begin
    CryptDestroyKey(FKey);
    FKey := nil;
  end;

  der := nil;
  keyBlob := nil;
  try
    der := TclCryptData.Create();
    der.FromBytes(AKey);

    size := 0;
    if not CryptDecodeObjectEx(DefaultEncoding, X509_PUBLIC_KEY_INFO, der.Data, der.DataSize, 0, nil, nil, @size) then
    begin
      RaiseCryptError('CryptDecodeObjectEx');
    end;

    keyBlob := TclCryptData.Create(size);

    if not CryptDecodeObjectEx(DefaultEncoding, X509_PUBLIC_KEY_INFO, der.Data, der.DataSize, 0, nil, keyBlob.Data, @size) then
    begin
      RaiseCryptError('CryptDecodeObjectEx');
    end;

    keyBlob.Reduce(size);

    if not CryptImportPublicKeyInfoEx(FContext, DefaultEncoding,
      PCERT_PUBLIC_KEY_INFO(keyBlob.Data), 0, 0, nil, @FKey) then
    begin
      RaiseCryptError('CryptImportPublicKeyInfoEx');
    end;
  finally
    keyBlob.Free();
    der.Free();
  end;

  LoadKeyInfo();
end;

procedure TclCryptApiRsaKey.SetPublicKeyParams(const AModulus, AExponent: TclByteArray);
var
  keyBlob: TclCryptData;
  keyBlobLen: Integer;
  blobHdr: PBLOBHEADER;
  rsaPubK: PRSAPUBKEY;
  modulus: PByte;
  unfoldedModulus: TclByteArray;
begin
  unfoldedModulus := UnfoldBytesWithZero(AModulus);

  Assert(FContext <> nil);

  if (FKey <> nil) then
  begin
    CryptDestroyKey(FKey);
    FKey := nil;
  end;

  keyBlobLen := SizeOf(BLOBHEADER) + SizeOf(RSAPUBKEY) + Length(unfoldedModulus);

  keyBlob := TclCryptData.Create(keyBlobLen);
  try
    blobHdr := PBLOBHEADER(keyBlob.Data);
    blobHdr.bType := PUBLICKEYBLOB;
    blobHdr.bVersion := CUR_BLOB_VERSION;
    blobHdr.reserved := 0;
    blobHdr.aiKeyAlg := CALG_RSA_KEYX;

    rsaPubK := PRSAPUBKEY(TclIntPtr(keyBlob.Data) + SizeOf(BLOBHEADER));
    rsaPubK.magic := $31415352; //for RSA1
    rsaPubK.bitlen := Length(unfoldedModulus) * 8;
    rsaPubK.pubexp := GetExponent(AExponent);

    modulus := PByte(TclIntPtr(keyBlob.Data) + SizeOf(BLOBHEADER) + SizeOf(RSAPUBKEY));

    unfoldedModulus := ReversedBytes(unfoldedModulus);
    System.Move(unfoldedModulus[0], modulus^, Length(unfoldedModulus));

    if not CryptImportKey(FContext, keyBlob.Data, keyBlob.DataSize, nil, 0, @FKey) then
    begin
      RaiseCryptError('CryptImportKey');
    end;
  finally
    keyBlob.Free();
  end;
end;

procedure TclCryptApiRsaKey.SetRsaPrivateKey(const AKey: TclByteArray);
var
  der, keyBlob: TclCryptData;
  size: DWORD;
begin
  Assert(FContext <> nil);

  if (AKey = nil) then
  begin
    RaiseCryptError(CryptKeyRequired, CryptKeyRequiredCode);
  end;

  if (FKey <> nil) then
  begin
    CryptDestroyKey(FKey);
    FKey := nil;
  end;

  der := nil;
  keyBlob := nil;
  try
    der := TclCryptData.Create();
    der.FromBytes(AKey);

    size := 0;
    if not CryptDecodeObjectEx(DefaultEncoding, PKCS_RSA_PRIVATE_KEY, der.Data, der.DataSize, 0, nil, nil, @size) then
    begin
      RaiseCryptError('CryptDecodeObjectEx');
    end;

    keyBlob := TclCryptData.Create(size);

    if not CryptDecodeObjectEx(DefaultEncoding, PKCS_RSA_PRIVATE_KEY, der.Data, der.DataSize, 0, nil, keyBlob.Data, @size) then
    begin
      RaiseCryptError('CryptDecodeObjectEx');
    end;

    keyBlob.Reduce(size);

    if not CryptImportKey(FContext, keyBlob.Data, keyBlob.DataSize, nil, CRYPT_EXPORTABLE, @FKey) then
    begin
      RaiseCryptError('CryptImportKey');
    end;
  finally
    keyBlob.Free();
    der.Free();
  end;

  LoadKeyInfo();
end;

procedure TclCryptApiRsaKey.SetRsaPublicKey(const AKey: TclByteArray);
var
  der, keyBlob: TclCryptData;
  size: DWORD;
begin
  Assert(FContext <> nil);

  if (AKey = nil) then
  begin
    RaiseCryptError(CryptKeyRequired, CryptKeyRequiredCode);
  end;

  if (FKey <> nil) then
  begin
    CryptDestroyKey(FKey);
    FKey := nil;
  end;

  der := nil;
  keyBlob := nil;
  try
    der := TclCryptData.Create();
    der.FromBytes(AKey);

    size := 0;
    if not CryptDecodeObjectEx(DefaultEncoding, RSA_CSP_PUBLICKEYBLOB, der.Data, der.DataSize, 0, nil, nil, @size) then
    begin
      RaiseCryptError('CryptDecodeObjectEx');
    end;

    keyBlob := TclCryptData.Create(size);

    if not CryptDecodeObjectEx(DefaultEncoding, RSA_CSP_PUBLICKEYBLOB, der.Data, der.DataSize, 0, nil, keyBlob.Data, @size) then
    begin
      RaiseCryptError('CryptDecodeObjectEx');
    end;

    keyBlob.Reduce(size);

    if not CryptImportKey(FContext, keyBlob.Data, keyBlob.DataSize, nil, CRYPT_EXPORTABLE, @FKey) then
    begin
      RaiseCryptError('CryptImportKey');
    end;
  finally
    keyBlob.Free();
    der.Free();
  end;

  LoadKeyInfo();
end;

end.
