{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCryptUtils;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clUtils, clCryptAPI, clWUtils;
  
type
  EclCryptError = class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean = False);
    property ErrorCode: Integer read FErrorCode;
  end;

  TclCryptData = class(TclBinaryData)
  protected
    procedure DeallocateMem(var P: PByte); override;
    procedure AllocateMem(var P: PByte; ASize: Integer); override;
  end;

function GetCryptErrorText(AErrorCode: DWORD; const ADefaultMsg: string): string;
procedure RaiseCryptError(const ADefaultMsg: string); overload;
procedure RaiseCryptError(const AErrorMsg: string; AErrorCode: Integer); overload;

resourcestring
  CertificateRequired = 'A certificate is required to complete the operation';
  CertificateNotFound = 'The specified certificate not found';
  KeyExistsError = 'A key with such name already exists';
  CryptKeyRequired = 'A key is required to complete the operation';
  CryptInvalidArgument = 'Invalid argument';
  UnknownKeyFormat = 'Unknown key format';

const
  CertificateRequiredCode = -1;
  CertificateNotFoundCode = -2;
  KeyExistsErrorCode = -3;
  CryptKeyRequiredCode = -4;
  CryptInvalidArgumentCode = -7;
  UnknownKeyFormatCode = -8;

  DefaultEncoding = X509_ASN_ENCODING or PKCS_7_ASN_ENCODING;
  DefaultProvider = MS_DEF_PROV;
  DefaultProviderType = PROV_RSA_FULL;

implementation

function GetCryptErrorText(AErrorCode: DWORD; const ADefaultMsg: string): string;
var
  Len: Integer;
  Buffer: array[0..255] of Char;
begin
  Len := FormatMessage(FORMAT_MESSAGE_FROM_HMODULE or FORMAT_MESSAGE_FROM_SYSTEM,
    Pointer(GetModuleHandle('crypt32.dll')), AErrorCode, 0, Buffer, SizeOf(Buffer), nil);

  while (Len > 0) and CharInSet(Buffer[Len - 1], [#0..#32, '.']) do Dec(Len);

  SetString(Result, Buffer, Len);
  if (Trim(Result) = '') then
  begin
    Result := Format('%s error - %d', [ADefaultMsg, AErrorCode]);
  end;
end;

procedure RaiseCryptError(const ADefaultMsg: string);
var
  code: DWORD;
begin
  code := GetLastError();
  raise EclCryptError.Create(GetCryptErrorText(code, ADefaultMsg), Integer(code));
end;

procedure RaiseCryptError(const AErrorMsg: string; AErrorCode: Integer);
begin
  raise EclCryptError.Create(AErrorMsg, AErrorCode);
end;

{ EclCryptError }

constructor EclCryptError.Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorMsg);
  FErrorCode := AErrorCode;
end;

{ TclCryptData }

procedure TclCryptData.AllocateMem(var P: PByte; ASize: Integer);
begin
  inherited AllocateMem(P, ASize);
  //CryptMemAlloc
end;

procedure TclCryptData.DeallocateMem(var P: PByte);
begin
  inherited DeallocateMem(P);
  //CryptMemFree
end;

end.
