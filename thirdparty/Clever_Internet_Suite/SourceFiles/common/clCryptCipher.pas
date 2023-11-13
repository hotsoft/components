{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCryptCipher;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows, Contnrs,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows, System.Contnrs,
{$ENDIF}
  clCryptAPI, clUtils, clWUtils, clConfig;

type
  TclCryptMethod = (cmEncrypt, cmDecrypt);

  TclCipher = class(TclConfigObject)
  public
    function GetIVSize(): Integer; virtual; abstract;
    function GetBlockSize(): Integer; virtual; abstract;
    procedure Init(AMethod: TclCryptMethod; const AKey, AIV: TclByteArray); virtual; abstract;
    procedure Update(const ABuffer: TclByteArray; AStart, ALen: Integer); virtual; abstract;
  end;

  TclCryptApiCipher = class(TclCipher)
  private
    FMethod: TclCryptMethod;
    FContext: HCRYPTPROV;
    FKey: HCRYPTKEY;
    FCSPPtr: PclChar;

    function GetCSPPtr: PclChar;
    procedure Clear;
  protected
    function GetCipherMode: Integer; virtual; abstract;
    function GetAlgorithm: ALG_ID; virtual; abstract;
    function GetCSP: string; virtual; abstract;
    function GetProviderType: Integer; virtual; abstract;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Init(AMethod: TclCryptMethod; const AKey, AIV: TclByteArray); override;
    procedure Update(const ABuffer: TclByteArray; AStart, ALen: Integer); override;
  end;

  TclTripleDesCbc = class(TclCryptApiCipher)
  protected
    function GetCipherMode: Integer; override;
    function GetAlgorithm: ALG_ID; override;
    function GetCSP: string; override;
    function GetProviderType: Integer; override;
  public
    function GetIVSize(): Integer; override;
    function GetBlockSize(): Integer; override;
  end;

  TclAesCbcBase = class(TclCryptApiCipher)
  protected
    function GetCipherMode: Integer; override;
    function GetCSP: string; override;
    function GetProviderType: Integer; override;
  end;

  TclAes128Cbc = class(TclAesCbcBase)
  protected
    function GetAlgorithm: ALG_ID; override;
  public
    function GetIVSize(): Integer; override;
    function GetBlockSize(): Integer; override;
  end;

  TclAes192Cbc = class(TclAesCbcBase)
  protected
    function GetAlgorithm: ALG_ID; override;
  public
    function GetIVSize(): Integer; override;
    function GetBlockSize(): Integer; override;
  end;

  TclAes256Cbc = class(TclAesCbcBase)
  protected
    function GetAlgorithm: ALG_ID; override;
  public
    function GetIVSize(): Integer; override;
    function GetBlockSize(): Integer; override;
  end;

  TclAesCtrBase = class(TclCipher)
  private
    FMethod: TclCryptMethod;
    FContext: HCRYPTPROV;
    FKey: HCRYPTKEY;
    FCSPPtr: PclChar;
    FCounter: TclByteArray;
    FXorMask: TQueue;

    function GetCSPPtr: PclChar;
    procedure Clear;
    function NeedMoreXorMaskBytes: Boolean;
    procedure EncryptCounter;
    procedure IncrementCounter;
  protected
    function GetAlgorithm: ALG_ID; virtual; abstract;
    function GetCSP: string; virtual;
    function GetProviderType: Integer; virtual;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Init(AMethod: TclCryptMethod; const AKey, AIV: TclByteArray); override;
    procedure Update(const ABuffer: TclByteArray; AStart, ALen: Integer); override;
  end;

  TclAes128Ctr = class(TclAesCtrBase)
  protected
    function GetAlgorithm: ALG_ID; override;
  public
    function GetIVSize(): Integer; override;
    function GetBlockSize(): Integer; override;
  end;

  TclAes192Ctr = class(TclAesCtrBase)
  protected
    function GetAlgorithm: ALG_ID; override;
  public
    function GetIVSize(): Integer; override;
    function GetBlockSize(): Integer; override;
  end;

  TclAes256Ctr = class(TclAesCtrBase)
  protected
    function GetAlgorithm: ALG_ID; override;
  public
    function GetIVSize(): Integer; override;
    function GetBlockSize(): Integer; override;
  end;

implementation

uses
  clCryptUtils;

{ TclTripleDesCbc }

function TclTripleDesCbc.GetAlgorithm: ALG_ID;
begin
  Result := CALG_3DES;
end;

function TclTripleDesCbc.GetBlockSize: Integer;
begin
  Result := 24;
end;

function TclTripleDesCbc.GetCipherMode: Integer;
begin
  Result := CRYPT_MODE_CBC;
end;

function TclTripleDesCbc.GetCSP: string;
begin
  Result := MS_ENHANCED_PROV;
end;

function TclTripleDesCbc.GetIVSize: Integer;
begin
  Result := 8;
end;

function TclTripleDesCbc.GetProviderType: Integer;
begin
  Result := PROV_RSA_FULL;
end;

{ TclCryptApiCipher }

procedure TclCryptApiCipher.Clear;
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

constructor TclCryptApiCipher.Create;
begin
  inherited Create();

  FContext := nil;
  FKey := nil;
end;

destructor TclCryptApiCipher.Destroy;
begin
  Clear();
  inherited Destroy();
end;

function TclCryptApiCipher.GetCSPPtr: PclChar;
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

procedure TclCryptApiCipher.Init(AMethod: TclCryptMethod; const AKey, AIV: TclByteArray);
var
  keyBlob: TclCryptData;
  keyBlobLen, len: Integer;
  iv, key: TclByteArray;
  blobHdr: PBLOBHEADER;
  blobData: PCRYPTOAPI_BLOB;
  dw: DWORD;
begin
  Clear();

  len := Length(AIV);
  if (len > GetIVSize()) then
  begin
    len := GetIVSize();
  end;
  iv := System.Copy(AIV, 0, len);

  len := Length(AKey);
  if (len > GetBlockSize()) then
  begin
    len := GetBlockSize();
  end;
  key := System.Copy(AKey, 0, len);
  FMethod := AMethod;

  if not CryptAcquireContext(@FContext, nil, GetCSPPtr(), GetProviderType(), CRYPT_VERIFYCONTEXT) then
  begin
    RaiseCryptError('CryptAcquireContext');
  end;

  keyBlobLen := SizeOf(BLOBHEADER) + SizeOf(DWORD) + GetBlockSize();
  keyBlob := TclCryptData.Create(keyBlobLen);
  try
    blobHdr := PBLOBHEADER(keyBlob.Data);
    blobHdr.bType := PLAINTEXTKEYBLOB;
    blobHdr.bVersion := CUR_BLOB_VERSION;
    blobHdr.reserved := 0;
    blobHdr.aiKeyAlg := GetAlgorithm();

    blobData := PCRYPTOAPI_BLOB(TclIntPtr(keyBlob.Data) + SizeOf(BLOBHEADER));
    blobData.cbData := GetBlockSize();

    System.Move(key[0], blobData.pbData, GetBlockSize());

    if not CryptImportKey(FContext, keyBlob.Data, keyBlob.DataSize, nil, 0, @FKey) then
    begin
      RaiseCryptError('CryptImportKey');
    end;

    dw := GetCipherMode();
    if not CryptSetKeyParam(FKey, KP_MODE, @dw, 0) then
    begin
      RaiseCryptError('CryptSetKeyParam');
    end;

    if not CryptSetKeyParam(FKey, KP_IV, Pointer(iv), 0) then
    begin
      RaiseCryptError('CryptSetKeyParam');
    end;
  finally
    keyBlob.Free();
  end;
end;

procedure TclCryptApiCipher.Update(const ABuffer: TclByteArray; AStart, ALen: Integer);
var
  dw: DWORD;
begin
  dw := DWORD(ALen);
  if (FMethod = cmEncrypt) then
  begin
    if not CryptEncrypt(FKey, nil, 0, 0, Pointer(TclIntPtr(ABuffer) + AStart), @dw, DWORD(ALen)) then
    begin
      RaiseCryptError('CryptEncrypt');
    end;
  end else
  begin
    if not CryptDecrypt(FKey, nil, 0, 0, Pointer(TclIntPtr(ABuffer) + AStart), @dw) then
    begin
      RaiseCryptError('CryptDecrypt');
    end;
  end;
end;

{ TclAes128Cbc }

function TclAes128Cbc.GetAlgorithm: ALG_ID;
begin
  Result := CALG_AES_128;
end;

function TclAes128Cbc.GetBlockSize: Integer;
begin
  Result := 16;
end;

function TclAes128Cbc.GetIVSize: Integer;
begin
  Result := 16;
end;

{ TclAes192Cbc }

function TclAes192Cbc.GetAlgorithm: ALG_ID;
begin
  Result := CALG_AES_192;
end;

function TclAes192Cbc.GetBlockSize: Integer;
begin
  Result := 24;
end;

function TclAes192Cbc.GetIVSize: Integer;
begin
  Result := 16;
end;

{ TclAes256Cbc }

function TclAes256Cbc.GetAlgorithm: ALG_ID;
begin
  Result := CALG_AES_256;
end;

function TclAes256Cbc.GetBlockSize: Integer;
begin
  Result := 32;
end;

function TclAes256Cbc.GetIVSize: Integer;
begin
  Result := 16;
end;

{ TclAesCbcBase }

function TclAesCbcBase.GetCipherMode: Integer;
begin
  Result := CRYPT_MODE_CBC;
end;

function TclAesCbcBase.GetCSP: string;
begin
  Result := MS_ENH_RSA_AES_PROV;
end;

function TclAesCbcBase.GetProviderType: Integer;
begin
  Result := PROV_RSA_AES;
end;

{ TclAesCtrBase }

procedure TclAesCtrBase.Clear;
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

  while FXorMask.Count > 0 do
  begin
    FXorMask.Pop();
  end;
end;

constructor TclAesCtrBase.Create;
begin
  inherited Create();

  FXorMask := TQueue.Create();
  FContext := nil;
  FKey := nil;
end;

destructor TclAesCtrBase.Destroy;
begin
  Clear();

  FXorMask.Free();
  inherited Destroy();
end;

function TclAesCtrBase.GetCSP: string;
begin
  Result := MS_ENH_RSA_AES_PROV;
end;

function TclAesCtrBase.GetCSPPtr: PclChar;
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

function TclAesCtrBase.GetProviderType: Integer;
begin
  Result := PROV_RSA_AES;
end;

procedure TclAesCtrBase.Init(AMethod: TclCryptMethod; const AKey, AIV: TclByteArray);
var
  keyBlob: TclCryptData;
  keyBlobLen, len: Integer;
  iv, key: TclByteArray;
  blobHdr: PBLOBHEADER;
  blobData: PCRYPTOAPI_BLOB;
  dw: DWORD;
begin
  Clear();

  len := Length(AIV);
  if (len > GetIVSize()) then
  begin
    len := GetIVSize();
  end;
  iv := System.Copy(AIV, 0, len);

  len := Length(AKey);
  if (len > GetBlockSize()) then
  begin
    len := GetBlockSize();
  end;
  key := System.Copy(AKey, 0, len);

  FMethod := AMethod;
  FCounter := iv;

  if not CryptAcquireContext(@FContext, nil, GetCSPPtr(), GetProviderType(), CRYPT_VERIFYCONTEXT) then
  begin
    RaiseCryptError('CryptAcquireContext');
  end;

  keyBlobLen := SizeOf(BLOBHEADER) + SizeOf(DWORD) + GetBlockSize();
  keyBlob := TclCryptData.Create(keyBlobLen);
  try
    blobHdr := PBLOBHEADER(keyBlob.Data);
    blobHdr.bType := PLAINTEXTKEYBLOB;
    blobHdr.bVersion := CUR_BLOB_VERSION;
    blobHdr.reserved := 0;
    blobHdr.aiKeyAlg := GetAlgorithm();

    blobData := PCRYPTOAPI_BLOB(TclIntPtr(keyBlob.Data) + SizeOf(BLOBHEADER));
    blobData.cbData := GetBlockSize();

    System.Move(key[0], blobData.pbData, GetBlockSize());

    if not CryptImportKey(FContext, keyBlob.Data, keyBlob.DataSize, nil, CRYPT_NO_SALT, @FKey) then
    begin
      RaiseCryptError('CryptImportKey');
    end;

    dw := CRYPT_MODE_ECB;
    if not CryptSetKeyParam(FKey, KP_MODE, @dw, 0) then
    begin
      RaiseCryptError('CryptSetKeyParam');
    end;
  finally
    keyBlob.Free();
  end;
end;

procedure TclAesCtrBase.Update(const ABuffer: TclByteArray; AStart, ALen: Integer);
var
  i: Integer;
  mask: Byte;
begin
  if (ALen > Length(ABuffer)) then
  begin
    RaiseCryptError(CryptInvalidArgument, CryptInvalidArgumentCode);
  end;

  for i := 0 to ALen - 1 do
  begin
    if NeedMoreXorMaskBytes() then
    begin
      EncryptCounter();
    end;

    mask := Byte(FXorMask.Pop());

    ABuffer[AStart + i] := Byte(ABuffer[AStart + i] xor mask);
  end;
end;

function TclAesCtrBase.NeedMoreXorMaskBytes: Boolean;
begin
  Result := (FXorMask.Count = 0);
end;

procedure TclAesCtrBase.EncryptCounter;
var
  i: Integer;
  dw: DWORD;
  counterModeBlock: TclByteArray;
begin
  SetLength(counterModeBlock, Length(FCounter));
  System.Move(FCounter[0], counterModeBlock[0], Length(counterModeBlock));

  dw := DWORD(Length(counterModeBlock));
  if not CryptEncrypt(FKey, nil, 0, 0, Pointer(TclIntPtr(counterModeBlock)), @dw, DWORD(Length(counterModeBlock))) then
  begin
    RaiseCryptError('CryptEncrypt');
  end;

  IncrementCounter();

  for i := 0 to Length(counterModeBlock) - 1 do
  begin
    FXorMask.Push(Pointer(counterModeBlock[i]));
  end;
end;

procedure TclAesCtrBase.IncrementCounter;
var
  i: Integer;
begin
  for i := Length(FCounter) - 1 downto 0 do
  begin
    if (FCounter[i] < 255) then
    begin
      FCounter[i] := FCounter[i] + 1;
    end else
    begin
      FCounter[i] := 0;
    end;

    if (FCounter[i] <> 0) then
    begin
      Break;
    end;
  end;
end;

{ TclAes128Ctr }

function TclAes128Ctr.GetAlgorithm: ALG_ID;
begin
  Result := CALG_AES_128;
end;

function TclAes128Ctr.GetBlockSize: Integer;
begin
  Result := 16;
end;

function TclAes128Ctr.GetIVSize: Integer;
begin
  Result := 16;
end;

{ TclAes192Ctr }

function TclAes192Ctr.GetAlgorithm: ALG_ID;
begin
  Result := CALG_AES_192;
end;

function TclAes192Ctr.GetBlockSize: Integer;
begin
  Result := 24;
end;

function TclAes192Ctr.GetIVSize: Integer;
begin
  Result := 16;
end;

{ TclAes256Ctr }

function TclAes256Ctr.GetAlgorithm: ALG_ID;
begin
  Result := CALG_AES_256;
end;

function TclAes256Ctr.GetBlockSize: Integer;
begin
  Result := 32;
end;

function TclAes256Ctr.GetIVSize: Integer;
begin
  Result := 16;
end;

end.
