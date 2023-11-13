{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCertificateKey;

interface

{$I clVer.inc}

type
  TclCertificateKeyType = (ktKeyExchange, ktSignature);

  TclCertificateKey = class
  private
    FLength: Integer;
    FName: string;
    FKeyType: TclCertificateKeyType;
    FAlgorithm: string;
    FAlgorithmName: string;
  protected
    procedure Load(const AName, ACSP: string; AProviderType: Integer); virtual;
  public
    constructor Create(const AName, ACSP: string; AProviderType: Integer);

    property Name: string read FName;
    property KeyType: TclCertificateKeyType read FKeyType;
    property Length: Integer read FLength;
    property Algorithm: string read FAlgorithm;
    property AlgorithmName: string read FAlgorithmName;
  end;

function GetKeyTypeInt(AKeyType: TclCertificateKeyType): Integer;

implementation

uses
{$IFNDEF DELPHIXE2}
  Windows,
{$ELSE}
  Winapi.Windows,
{$ENDIF}
  clCryptAPI, clCryptUtils, clUtils, clWUtils;

function GetKeyTypeInt(AKeyType: TclCertificateKeyType): Integer;
const
  types: array[TclCertificateKeyType] of Integer = (1, 2);
begin
  Result := types[AKeyType];
end;

{ TclCertificateKey }

constructor TclCertificateKey.Create(const AName, ACSP: string; AProviderType: Integer);
begin
  inherited Create();
  Load(AName, ACSP, AProviderType);
end;

procedure TclCertificateKey.Load(const AName, ACSP: string; AProviderType: Integer);
var
  context: HCRYPTPROV;
  hKey: HCRYPTKEY;
  data: TclCryptData;
  len: Integer;
  pOidInfo: PCCRYPT_OID_INFO;
  s: string;
begin
  FName := AName;

  context := nil;
  try
    if not CryptAcquireContext(@context, PclChar(GetTclString(AName)), PclChar(GetTclString(ACSP)), AProviderType, 0) then
    begin
      RaiseCryptError('CryptAcquireContext');
    end;

    hKey := nil;
    try
      if CryptGetUserKey(context, AT_KEYEXCHANGE, @hKey) then
      begin
        FKeyType := ktKeyExchange;
      end else
      if CryptGetUserKey(context, AT_SIGNATURE, @hKey) then
      begin
        FKeyType := ktSignature;
      end;

      if (hKey <> nil) then
      begin
        data := TclCryptData.Create(256);
        try
          len := data.DataSize;
          if CryptGetKeyParam(hKey, KP_ALGID, data.Data,  @len, 0) then
          begin
            pOidInfo := CryptFindOIDInfo(CRYPT_OID_INFO_ALGID_KEY, data.Data, 0);
            if (pOidInfo <> nil) then
            begin
              s := GetString_(pOidInfo.pszOID);
              FAlgorithm := system.Copy(s, 1, system.Length(s));
              s := string(WideString(pOidInfo.pwszName));
              FAlgorithmName := system.Copy(s, 1, system.Length(s));
            end;
          end;

          len := data.DataSize;
          if CryptGetKeyParam(hKey, KP_KEYLEN, data.Data, @len, 0) then
          begin
            if (len >= 4) then
            begin
              FLength := DWORD(Pointer(data.Data)^);
            end;
          end;
        finally
          data.Free();
        end;
      end;
    finally
      if (hKey <> nil) then
      begin
        CryptDestroyKey(hKey);
      end;
    end;
  finally
    if (context <> nil) then
    begin
      CryptReleaseContext(context, 0);
    end;
  end;
end;

end.
