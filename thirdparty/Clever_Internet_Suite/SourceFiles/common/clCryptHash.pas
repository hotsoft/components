{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCryptHash;

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
  TclHash = class(TclConfigObject)
  public
    procedure Init; virtual; abstract;
    function GetBlockSize: Integer; virtual; abstract;
    procedure Update(const ABuffer: TclByteArray; AStart, ALen: Integer); virtual; abstract;
    function Digest: TclByteArray; virtual; abstract;
  end;

  TclCryptApiHash = class(TclHash)
  private
    FContext: HCRYPTPROV;
    FHash: HCRYPTHASH;
    FBlockSize: Integer;
    FCSPPtr: PclChar;

    procedure Clear;
    function GetCSPPtr: PclChar;
  protected
    function GetAlgorithm: ALG_ID; virtual; abstract;
    function GetCSP: string; virtual; abstract;
    function GetProviderType: Integer; virtual; abstract;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Init; override;
    function GetBlockSize: Integer; override;
    procedure Update(const ABuffer: TclByteArray; AStart, ALen: Integer); override;
    function Digest: TclByteArray; override;
  end;

  TclMd5 = class(TclCryptApiHash)
  protected
    function GetAlgorithm: ALG_ID; override;
    function GetCSP: string; override;
    function GetProviderType: Integer; override;
  end;

  TclSha1 = class(TclCryptApiHash)
  protected
    function GetAlgorithm: ALG_ID; override;
    function GetCSP: string; override;
    function GetProviderType: Integer; override;
  end;

  TclSha256 = class(TclCryptApiHash)
  protected
    function GetAlgorithm: ALG_ID; override;
    function GetCSP: string; override;
    function GetProviderType: Integer; override;
  end;

function MD5(const Value: string): string;

implementation

uses
  clCryptUtils, clTranslator;

function MD5(const Value: string): string;
var
  hash: TclMd5;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  if (Value = '') then
  begin
    Result := '';
    Exit;
  end;

  hash := TclMd5.Create();
  try
    hash.Init();
    buf := TclTranslator.GetBytes(Value);
    hash.Update(buf, 0, Length(buf));

    Result := LowerCase(BytesToHex(hash.Digest()));
  finally
    hash.Free();
  end;
end;

{ TclCryptApiHash }

procedure TclCryptApiHash.Clear;
begin
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

constructor TclCryptApiHash.Create;
begin
  inherited Create();

  FContext := nil;
  FHash := nil;
end;

destructor TclCryptApiHash.Destroy;
begin
  Clear();

  inherited Destroy();
end;

function TclCryptApiHash.Digest: TclByteArray;
var
  dig: TclCryptData;
  hashSize: DWORD;
begin
  Assert(FHash <> nil);

  dig := TclCryptData.Create(FBlockSize);
  try
    hashSize := FBlockSize;
    if not CryptGetHashParam(FHash, HP_HASHVAL, dig.Data, @hashSize, 0) then
    begin
      RaiseCryptError('CryptGetHashParam');
    end;

    SetLength(Result, dig.DataSize);
    System.Move(dig.Data^, Result[0], dig.DataSize);
  finally
    dig.Free();
  end;

  Init();
end;

function TclCryptApiHash.GetBlockSize: Integer;
begin
  Result := FBlockSize;
end;

function TclCryptApiHash.GetCSPPtr: PclChar;
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

procedure TclCryptApiHash.Init;
var
  hashSize, dwordSize: DWORD;
begin
  Clear();

  if not CryptAcquireContext(@FContext, nil, GetCSPPtr(), GetProviderType(), CRYPT_VERIFYCONTEXT) then
  begin
    RaiseCryptError('CryptAcquireContext');
  end;

  if not CryptCreateHash(FContext, GetAlgorithm(), nil, 0, @FHash) then
  begin
    RaiseCryptError('CryptCreateHash');
  end;

  dwordSize := SizeOf(DWORD);
  if not CryptGetHashParam(FHash, HP_HASHSIZE, @hashSize, @dwordSize, 0) then
  begin
    RaiseCryptError('CryptGetHashParam');
  end;
  FBlockSize := hashSize;
end;

procedure TclCryptApiHash.Update(const ABuffer: TclByteArray; AStart, ALen: Integer);
begin
  Assert(FHash <> nil);

  if not CryptHashData(FHash, Pointer(TclIntPtr(ABuffer) + AStart), ALen, 0) then
  begin
    RaiseCryptError('CryptHashData');
  end;
end;

{ TclSha1 }

function TclSha1.GetAlgorithm: ALG_ID;
begin
  Result := CALG_SHA1;
end;

function TclSha1.GetCSP: string;
begin
  Result := MS_DEF_PROV;
end;

function TclSha1.GetProviderType: Integer;
begin
  Result := PROV_RSA_FULL;
end;

{ TclSha256 }

function TclSha256.GetAlgorithm: ALG_ID;
begin
  Result := CALG_SHA_256;
end;

function TclSha256.GetCSP: string;
begin
  Result := MS_ENH_RSA_AES_PROV;
end;

function TclSha256.GetProviderType: Integer;
begin
  Result := PROV_RSA_AES;
end;

{ TclMd5 }

function TclMd5.GetAlgorithm: ALG_ID;
begin
  Result := CALG_MD5;
end;

function TclMd5.GetCSP: string;
begin
  Result := MS_DEF_PROV;
end;

function TclMd5.GetProviderType: Integer;
begin
  Result := PROV_RSA_FULL;
end;

end.
