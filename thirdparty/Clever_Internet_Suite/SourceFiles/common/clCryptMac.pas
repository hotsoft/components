{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCryptMac;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clCryptAPI, clUtils, clWUtils, clConfig;

type
  TclMac = class(TclConfigObject)
  public
    procedure Init(const AKey: TclByteArray; AStart, ALen: Integer); overload; virtual; abstract;
    procedure Init(const AKey: TclByteArray); overload; virtual; abstract;
    function GetBlockSize: Integer; virtual; abstract;
    procedure Update(const ABuffer: TclByteArray; AStart, ALen: Integer); overload; virtual; abstract;
    procedure Update(const AValue: Integer); overload; virtual; abstract;
    function Digest: TclByteArray; virtual; abstract;
  end;

  TclCryptApiHmac = class(TclMac)
  private
    FContext: HCRYPTPROV;
    FHash: HCRYPTHASH;
    FCSPPtr: PclChar;
    FIPad: TclByteArray;
    FOPad: TclByteArray;

    procedure CreateHash;
    procedure DestroyHash;
    function GetHashValue: TclByteArray;
    procedure Clear;
    function GetCSPPtr: PclChar;
  protected
    function GetHashAlgorithm: ALG_ID; virtual; abstract;
    function GetCSP: string; virtual; abstract;
    function GetProviderType: Integer; virtual; abstract;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Init(const AKey: TclByteArray; AStart, ALen: Integer); overload; override;
    procedure Init(const AKey: TclByteArray); overload; override;
    procedure Update(const ABuffer: TclByteArray; AStart, ALen: Integer); overload; override;
    procedure Update(const AValue: Integer); overload; override;
    function Digest: TclByteArray; override;
  end;

  TclHmacMd5 = class(TclCryptApiHmac)
  protected
    function GetHashAlgorithm: ALG_ID; override;
    function GetCSP: string; override;
    function GetProviderType: Integer; override;
  public
    function GetBlockSize: Integer; override;
  end;

  TclHmacSha1 = class(TclCryptApiHmac)
  protected
    function GetHashAlgorithm: ALG_ID; override;
    function GetCSP: string; override;
    function GetProviderType: Integer; override;
  public
    function GetBlockSize: Integer; override;
  end;

  TclHmacSha256 = class(TclCryptApiHmac)
  protected
    function GetHashAlgorithm: ALG_ID; override;
    function GetCSP: string; override;
    function GetProviderType: Integer; override;
  public
    function GetBlockSize: Integer; override;
  end;

function HMAC_MD5(const Text, Key: string): string;

implementation

uses
  clCryptUtils, clTranslator;

function HMAC_MD5(const Text, Key: string): string;
var
  mac: TclMac;
  k, b: TclByteArray;
begin
{$IFNDEF DELPHI2005}k := nil; b := nil;{$ENDIF}
  if (Text = '') or (Key = '') then
  begin
    Result := '';
    Exit;
  end;

  mac := TclHmacMd5.Create();
  try
    k := TclTranslator.GetBytes(Key);
    b := TclTranslator.GetBytes(Text);

    mac.Init(k);
    mac.Update(b, 0, Length(b));
    Result := LowerCase(BytesToHex(mac.Digest()));
  finally
    mac.Free();
  end;
end;

{ TclCryptApiHmac }

procedure TclCryptApiHmac.Clear;
begin
  DestroyHash();

  if (FContext <> nil) then
  begin
    CryptReleaseContext(FContext, 0);
    FContext := nil;
  end;

  FreeMem(FCSPPtr);
  FCSPPtr := nil;

  FIPad := nil;
  FOPad := nil;
end;

constructor TclCryptApiHmac.Create;
begin
  inherited Create();

  FContext := nil;
  FHash := nil;
  FIPad := nil;
  FOPad := nil;
end;

procedure TclCryptApiHmac.CreateHash;
begin
  Assert(FHash = nil);

  if not CryptCreateHash(FContext, GetHashAlgorithm(), nil, 0, @FHash) then
  begin
    RaiseCryptError('CryptCreateHash');
  end;
end;

destructor TclCryptApiHmac.Destroy;
begin
  Clear();
  inherited Destroy();
end;

procedure TclCryptApiHmac.DestroyHash;
begin
  if (FHash <> nil) then
  begin
    CryptDestroyHash(FHash);
    FHash := nil;
  end;
end;

function TclCryptApiHmac.Digest: TclByteArray;
begin
  Result := GetHashValue();

  DestroyHash();

  CreateHash();

  Update(FOPad, 0, Length(FOPad));

  Update(Result, 0, Length(Result));

  Result := GetHashValue();

  DestroyHash();
end;

function TclCryptApiHmac.GetCSPPtr: PclChar;
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

function TclCryptApiHmac.GetHashValue: TclByteArray;
var
  dig: TclCryptData;
  hashSize: DWORD;
begin
  Assert(FHash <> nil);

  dig := TclCryptData.Create(GetBlockSize());
  try
    hashSize := GetBlockSize();
    if not CryptGetHashParam(FHash, HP_HASHVAL, dig.Data, @hashSize, 0) then
    begin
      RaiseCryptError('CryptGetHashParam');
    end;

    dig.Reduce(hashSize);

    SetLength(Result, dig.DataSize);
    System.Move(dig.Data^, Result[0], dig.DataSize);
  finally
    dig.Free();
  end;
end;

procedure TclCryptApiHmac.Init(const AKey: TclByteArray);
begin
  Init(AKey, 0, Length(AKey));
end;

procedure TclCryptApiHmac.Init(const AKey: TclByteArray; AStart, ALen: Integer);
var
  encodedKey, buf: TclByteArray;
  i: Integer;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  Clear();

  if not CryptAcquireContext(@FContext, nil, GetCSPPtr(), GetProviderType(), CRYPT_VERIFYCONTEXT) then
  begin
    RaiseCryptError('CryptAcquireContext');
  end;

  SetLength(encodedKey, 64);
  for i := 0 to Length(encodedKey) - 1 do
  begin
    encodedKey[i] := 0;
  end;

  if (ALen > Length(AKey) - AStart) then
  begin
    ALen := Length(AKey) - AStart;
  end;

  if (ALen > 64) then
  begin
    CreateHash();

    Update(AKey, AStart, ALen);

    buf := GetHashValue();

    System.Move(buf[0], encodedKey[0], Length(buf));

    DestroyHash();
  end else
  begin
    System.Move(AKey[AStart], encodedKey[0], ALen);
  end;

  SetLength(FIPad, 64);
  for i := 0 to Length(FIPad) - 1 do
  begin
    FIPad[i] := encodedKey[i] xor $36;
  end;

  SetLength(FOPad, 64);
  for i := 0 to Length(FOPad) - 1 do
  begin
    FOPad[i] := encodedKey[i] xor $5c;
  end;
end;

procedure TclCryptApiHmac.Update(const AValue: Integer);
var
  buf: TclByteArray;
  ind: Integer;
begin
  SetLength(buf, 4);
  ind := 0;
  ByteArrayWriteDWord(AValue, buf, ind);
  Update(buf, 0, 4);
end;

procedure TclCryptApiHmac.Update(const ABuffer: TclByteArray; AStart, ALen: Integer);
begin
  if (FHash = nil) then
  begin
    CreateHash();
    Update(FIPad, 0, Length(FIPad));
  end;

  if not CryptHashData(FHash, Pointer(TclIntPtr(ABuffer) + AStart), ALen, 0) then
  begin
    RaiseCryptError('CryptHashData');
  end;
end;

{ TclHmacMd5 }

function TclHmacMd5.GetBlockSize: Integer;
begin
  Result := 16;
end;

function TclHmacMd5.GetCSP: string;
begin
  Result := MS_DEF_PROV;
end;

function TclHmacMd5.GetHashAlgorithm: ALG_ID;
begin
  Result := CALG_MD5;
end;

function TclHmacMd5.GetProviderType: Integer;
begin
  Result := PROV_RSA_FULL;
end;

{ TclHmacSha1 }

function TclHmacSha1.GetBlockSize: Integer;
begin
  Result := 20;
end;

function TclHmacSha1.GetCSP: string;
begin
  Result := MS_DEF_PROV;
end;

function TclHmacSha1.GetHashAlgorithm: ALG_ID;
begin
  Result := CALG_SHA1;
end;

function TclHmacSha1.GetProviderType: Integer;
begin
  Result := PROV_RSA_FULL;
end;

{ TclHmacSha256 }

function TclHmacSha256.GetBlockSize: Integer;
begin
  Result := 32;
end;

function TclHmacSha256.GetCSP: string;
begin
  Result := MS_ENH_RSA_AES_PROV;
end;

function TclHmacSha256.GetHashAlgorithm: ALG_ID;
begin
  Result := CALG_SHA_256;
end;

function TclHmacSha256.GetProviderType: Integer;
begin
  Result := PROV_RSA_AES;
end;

end.
