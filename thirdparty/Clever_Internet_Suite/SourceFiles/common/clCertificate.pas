{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCertificate;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Contnrs, Windows,
{$ELSE}
  System.Classes, System.SysUtils, System.Contnrs, Winapi.Windows,
{$ENDIF}
  clCryptAPI, clCryptUtils, clCertificateKey, clWUtils, clTranslator;

type
  TclCertificateVersion = (cvVersion1, cvVersion2, cvVersion3);

  TclCertificateList = class;
  
  TclCertificate = class
  private
    FCertContext: PCCERT_CONTEXT;
    FIssuedTo: string;
    FEmail: string;
    FIssuedBy: string;
    FValidTo: TDateTime;
    FValidFrom: TDateTime;
    FSerialNumber: string;
    FFriendlyName: string;
    FVersion: TclCertificateVersion;
    FPrivateKey: string;
    FPublicKeyAlgorithm: string;
    FPublicKeyAlgorithmName: string;
    FSubject: string;
    FSignatureAlgorithm: string;
    FSignatureAlgorithmName: string;
    FUsage: string;
    FThumbprint: string;
    FSubjectKeyIdentifier: string;
    
    function GetIsServerAuthentication: Boolean;
    function GetIsClientAuthentication: Boolean;
    function GetIsCodeSigning: Boolean;
    function GetIsSecureEmail: Boolean;
    function CheckUsage(const AOID: string): Boolean;
    procedure SetFriendlyName(const Value: string);
    procedure SetUsageFlags(AFlags: TStrings);
    function GetUsageFlags: string;
    function GetEMailFromSubject: string;
    function GetEMailFromAltSubject: string;
    function GetFriendlyName: string;
    function GetDecodedName(AType, AFlags: Integer): string;
    function GetSerialNumber(ABlob: CRYPTOAPI_BLOB): string;
    function GetOidInfo(const AOID: string): string;
    function GetSubjectString: string;
    function GetPrivateKey: string;
    function GetThumbprint: string;
    function GetSubjectKeyIdentifier: string;
    procedure GetCertInfo;
    procedure SetUsage(const Value: string);
  public
    constructor Create(ACertContext: PCCERT_CONTEXT); overload;
    constructor Create(AEncoded: PByte; ALength: Integer); overload;
    destructor Destroy; override;

    procedure SetPrivateKey(const AName, ACSP: string; AProviderType: Integer; AKeyType: TclCertificateKeyType); overload;
    procedure SetPrivateKey(const AName, ACSP: string; AProviderType, AKeyType: Integer); overload;

    property Context: PCCERT_CONTEXT read FCertContext;
    property IssuedTo: string read FIssuedTo;
    property IssuedBy: string read FIssuedBy;
    property Email: string read FEmail;
    property ValidFrom: TDateTime read FValidFrom;
    property ValidTo: TDateTime read FValidTo;
    property SerialNumber: string read FSerialNumber;
    property IsServerAuthentication: Boolean read GetIsServerAuthentication;
    property IsClientAuthentication: Boolean read GetIsClientAuthentication;
    property IsCodeSigning: Boolean read GetIsCodeSigning;
    property IsSecureEmail: Boolean read GetIsSecureEmail;
    property Version: TclCertificateVersion read FVersion;
    property SignatureAlgorithm: string read FSignatureAlgorithm;
    property SignatureAlgorithmName: string read FSignatureAlgorithmName;
    property PublicKeyAlgorithm: string read FPublicKeyAlgorithm;
    property PublicKeyAlgorithmName: string read FPublicKeyAlgorithmName;
    property Subject: string read FSubject;
    property PrivateKey: string read FPrivateKey;
    property Thumbprint: string read FThumbprint;
    property SubjectKeyIdentifier: string read FSubjectKeyIdentifier;

    property Usage: string read FUsage write SetUsage;
    property FriendlyName: string read FFriendlyName write SetFriendlyName;
  end;

  TclCertificateList = class
  private
    FOwnsObjects: Boolean;
    FList: TList;
    function GetItem(Index: Integer): TclCertificate;
    function GetCount: Integer;
  public
    constructor Create(AOwnsObjects: Boolean);
    destructor Destroy; override;
    procedure Add(ACertificate: TclCertificate);
    function AddFrom(ACertificate: TclCertificate): TclCertificate;
    procedure Delete(Index: Integer);
    procedure Remove(ACertificate: TclCertificate);
    procedure Clear;
    property Items[Index: Integer]: TclCertificate read GetItem; default;
    property Count: Integer read GetCount;
    property OwnsObjects: Boolean read FOwnsObjects;
  end;

  TclCertificateExtension = class
  private
    FExtValue: TclCryptData;
    procedure ClearValue;
  public
    destructor Destroy; override;

    procedure GetExtension(AExtension: PCERT_EXTENSION); virtual; abstract;
    procedure AssignValue(AValue: PCRYPTOAPI_BLOB; AStructType: PAnsiChar; AStructure: Pointer);
  end;

  TclKeyUsageExtension = class(TclCertificateExtension)
  private
    FUsage: Integer;
  public
    constructor Create(AUsage: Integer);

    procedure GetExtension(AExtension: PCERT_EXTENSION); override;
  end;

  TclEnhancedKeyUsageExtension = class(TclCertificateExtension)
  private
    FUsage: TStrings;
  public
    constructor Create(AUsage: TStrings);

    procedure GetExtension(AExtension: PCERT_EXTENSION); override;
  end;

  TclCertificateExtensions = class
  private
    FList: TObjectList;
    FrgExtension: TclCryptData;
    
    function GetExtension: PCERT_EXTENSION;
    function GetCount: Integer;
    procedure Init;
    function GetItems(Index: Integer): TclCertificateExtension;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(AItem: TclCertificateExtension);
    procedure Clear;

    property Items[Index: Integer]: TclCertificateExtension read GetItems;
    property Count: Integer read GetCount;
    property Extension: PCERT_EXTENSION read GetExtension;
  end;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsCertDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}
  
implementation

uses
{$IFNDEF DELPHIXE2}
  {$IFDEF DEMO}Forms,{$ENDIF}
{$ELSE}
  {$IFDEF DEMO}Vcl.Forms,{$ENDIF}
{$ENDIF}
  clEncoder, clUtils{$IFDEF LOGGER}, clLogger{$ENDIF};


{ TclCertificate }

constructor TclCertificate.Create(ACertContext: PCCERT_CONTEXT);
begin
  inherited Create();
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Create');{$ENDIF}
  FCertContext := CertDuplicateCertificateContext(ACertContext);
  GetCertInfo();
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Create'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Create', E); raise; end; end;{$ENDIF}
end;

function TclCertificate.GetSerialNumber(ABlob: CRYPTOAPI_BLOB): string;
var
  i: Integer;
  p: Pointer;
begin
  Result := '';
  for i := ABlob.cbData - 1 downto 0 do
  begin
    p := Pointer(TclIntPtr(ABlob.pbData) + i);
    Result := Result + IntToHex(Byte(p^), 2);
  end;
end;

procedure TclCertificate.GetCertInfo();
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
    if (not IsCertDemoDisplayed) and (not IsEncoderDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsCertDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  FIssuedTo := GetDecodedName(CERT_NAME_SIMPLE_DISPLAY_TYPE, 0);
  FIssuedBy := GetDecodedName(CERT_NAME_SIMPLE_DISPLAY_TYPE, CERT_NAME_ISSUER_FLAG);

  FEmail := GetEMailFromSubject();
  if (FEmail = '') then
  begin
    FEmail := GetEMailFromAltSubject();
  end;

  FSerialNumber := GetSerialNumber(FCertContext^.pCertInfo.SerialNumber);

  FValidFrom := ConvertFileTimeToDateTime(FCertContext^.pCertInfo.NotBefore);
  FValidTo := ConvertFileTimeToDateTime(FCertContext^.pCertInfo.NotAfter);

  FFriendlyName := GetFriendlyName();

  FUsage := GetUsageFlags();

  if (FCertContext^.pCertInfo.dwVersion <= DWORD(cvVersion3)) then
  begin
    FVersion := TclCertificateVersion(FCertContext^.pCertInfo.dwVersion);
  end;

  FSignatureAlgorithm := GetString_(FCertContext^.pCertInfo.SignatureAlgorithm.pszObjId);
  FSignatureAlgorithmName := GetOidInfo(FSignatureAlgorithm);

  FPublicKeyAlgorithm := GetString_(FCertContext^.pCertInfo.SubjectPublicKeyInfo.Algorithm.pszObjId);
  FPublicKeyAlgorithmName := GetOidInfo(FPublicKeyAlgorithm);

  FSubject := GetSubjectString();

  FPrivateKey := GetPrivateKey();

  FThumbprint := GetThumbprint();

  FSubjectKeyIdentifier := GetSubjectKeyIdentifier();
end;

function TclCertificate.GetDecodedName(AType, AFlags: Integer): string;
var
  len: Integer;
  p: TclCryptData;
begin
  Result := '';

  len := CertGetNameString(FCertContext, AType, AFlags, nil, nil, 0);

  if (len < 1) then Exit;
  
  p := TclCryptData.Create(len * 2);
  try
    CertGetNameString(FCertContext, AType, AFlags, nil, PWideChar(p.Data), len);
    Result := string(p.ToWideString());
  finally
    p.Free();
  end;
end;

destructor TclCertificate.Destroy;
begin
  CertFreeCertificateContext(FCertContext);
  inherited Destroy();
end;

function TclCertificate.GetEMailFromAltSubject: string;
var
  i: Integer;
  pCertExtension: PCERT_EXTENSION;
  pStruct: Pointer;
  cbStruct: DWORD;
  pInfo: PCERT_ALT_NAME_INFO;
  pEntry: PCERT_ALT_NAME_ENTRY;
begin
  Assert(FCertContext <> nil);
  Assert(FCertContext.pCertInfo <> nil);
  Result := '';
  if (FCertContext.pCertInfo <> nil) then
  begin
    pCertExtension := CertFindExtension(szOID_SUBJECT_ALT_NAME2,
      FCertContext.pCertInfo.cExtension, FCertContext.pCertInfo.rgExtension);

    if (pCertExtension <> nil) then
    begin
      cbStruct := 0;
      if (CryptDecodeObject(DefaultEncoding, szOID_SUBJECT_ALT_NAME2,
        pCertExtension.Value.pbData, pCertExtension.Value.cbData, 0, nil, @cbStruct)) then
      begin
        GetMem(pStruct, cbStruct);
        CryptDecodeObject(DefaultEncoding, szOID_SUBJECT_ALT_NAME2,
          pCertExtension.Value.pbData, pCertExtension.Value.cbData, 0, pStruct, @cbStruct);

        pInfo := PCERT_ALT_NAME_INFO(pStruct);
        for i := 0 to pInfo.cAltEntry - 1 do
        begin
          pEntry := PCERT_ALT_NAME_ENTRY(TclIntPtr(pInfo.rgAltEntry) + i * SizeOf(CERT_ALT_NAME_ENTRY));
          if (pEntry.dwAltNameChoice = CERT_ALT_NAME_RFC822_NAME) then
          begin
            Result := string(WideString(pEntry.pwszRfc822Name));
            Break;
          end;
        end;
        FreeMem(pStruct);
      end;
    end;
  end;
end;

function TclCertificate.GetEMailFromSubject: string;
var
  i, j: Integer;
  pStruct: Pointer;
  cbStruct: DWORD;
  pInfo: PCERT_NAME_INFO;
  pEntry: PCERT_RDN;
  pRDNAttr: PCERT_RDN_ATTR;
  buf: PclChar;
begin
  Assert(FCertContext <> nil);
  Assert(FCertContext.pCertInfo <> nil);
  Result := '';
  if (FCertContext.pCertInfo <> nil) then
  begin
    cbStruct := 0;
    if (CryptDecodeObject(DefaultEncoding, X509_NAME,
      FCertContext.pCertInfo.Subject.pbData, FCertContext.pCertInfo.Subject.cbData,
      0, nil, @cbStruct)) then
    begin
      GetMem(pStruct, cbStruct);
      CryptDecodeObject(DefaultEncoding, X509_NAME,
        FCertContext.pCertInfo.Subject.pbData, FCertContext.pCertInfo.Subject.cbData,
        0, pStruct, @cbStruct);

      pInfo := PCERT_NAME_INFO(pStruct);
      for i := 0 to pInfo.cRDN - 1 do
      begin
        pEntry := PCERT_RDN(TclIntPtr(pInfo.rgRDN) + i * SizeOf(CERT_RDN));
        for j := 0 to pEntry.cRDNAttr - 1 do
        begin
          pRDNAttr := PCERT_RDN_ATTR(TclIntPtr(pEntry.rgRDNAttr) + j * SizeOf(CERT_RDN_ATTR));
          if (SameText(GetString_(pRDNAttr.pszObjId), szOID_RSA_emailAddr)) then
          begin
            if (pRDNAttr.Value.cbData > 0) then
            begin
              GetMem(buf, pRDNAttr.Value.cbData);
              try
                System.Move(pRDNAttr.Value.pbData^, Pointer(buf)^, pRDNAttr.Value.cbData);
                Result := TclTranslator.GetString(buf, pRDNAttr.Value.cbData, 'us-ascii');
              finally
                FreeMem(buf);
              end;
            end else
            begin
              Result := '';
            end;
            Break;
          end;
        end;
        if (Result <> '') then Break;
      end;
      FreeMem(pStruct);
    end;
  end;
end;

function TclCertificate.GetFriendlyName: string;
var
  cbSize: DWORD;
  buf: TclCryptData;
begin
  Result := '';
  cbSize := 0;
  if not CertGetCertificateContextProperty(FCertContext,
    CERT_FRIENDLY_NAME_PROP_ID, nil, @cbSize) then Exit;
  if (cbSize < 1) then Exit;

  buf := TclCryptData.Create(cbSize);
  try
    CertGetCertificateContextProperty(FCertContext, CERT_FRIENDLY_NAME_PROP_ID, buf.Data, @cbSize);
    Result := string(buf.ToWideString());
  finally
    buf.Free();
  end;
end;

function TclCertificate.GetIsClientAuthentication: Boolean;
begin
  Result := CheckUsage(szOID_PKIX_KP_CLIENT_AUTH);
end;

function TclCertificate.GetIsCodeSigning: Boolean;
begin
  Result := CheckUsage(szOID_PKIX_KP_CODE_SIGNING);
end;

function TclCertificate.GetIsSecureEmail: Boolean;
begin
  Result := CheckUsage(szOID_PKIX_KP_EMAIL_PROTECTION);
end;

function TclCertificate.GetIsServerAuthentication: Boolean;
begin
  Result := CheckUsage(szOID_PKIX_KP_SERVER_AUTH);
end;

function TclCertificate.GetOidInfo(const AOID: string): string;
var
  pOidInfo: PCCRYPT_OID_INFO;
  s: string;
begin
  Result := AOID;

  pOidInfo := CryptFindOIDInfo(CRYPT_OID_INFO_OID_KEY, PclChar(GetTclString(AOID)), 0);

  if (pOidInfo <> nil) then
  begin
    s := string(WideString(pOidInfo.pwszName));
    Result := system.Copy(s, 1, Length(s));
  end;
end;

function TclCertificate.GetPrivateKey: string;
var
  cbSize: DWORD;
  pInfo: TclCryptData;
begin
  Result := '';
  cbSize := 0;
  if not CertGetCertificateContextProperty(FCertContext,
    CERT_KEY_PROV_INFO_PROP_ID, nil, @cbSize) then Exit;
  if (cbSize < 1) then Exit;

  pInfo := TclCryptData.Create(cbSize);
  try
    CertGetCertificateContextProperty(FCertContext,
      CERT_KEY_PROV_INFO_PROP_ID, pInfo.Data, @cbSize);
    Result := system.Copy(string(WideString(PCRYPT_KEY_PROV_INFO(pInfo.Data).pwszContainerName)), 1, cbSize);
  finally
    pInfo.Free();
  end;
end;

function TclCertificate.GetSubjectKeyIdentifier: string;
var
  pCertExtension: PCERT_EXTENSION;
  pStruct: Pointer;
  cbStruct: DWORD;
  pb: PCRYPT_DATA_BLOB;
begin
  Assert(FCertContext <> nil);
  Assert(FCertContext.pCertInfo <> nil);
  Result := '';
  if (FCertContext.pCertInfo <> nil) then
  begin
    pCertExtension := CertFindExtension(szOID_SUBJECT_KEY_IDENTIFIER,
      FCertContext.pCertInfo.cExtension, FCertContext.pCertInfo.rgExtension);

    if (pCertExtension <> nil) then
    begin
      cbStruct := 0;
      if (CryptDecodeObject(DefaultEncoding, szOID_SUBJECT_KEY_IDENTIFIER,
        pCertExtension.Value.pbData, pCertExtension.Value.cbData, 0, nil, @cbStruct)) then
      begin
        GetMem(pStruct, cbStruct);
        try
          CryptDecodeObject(DefaultEncoding, szOID_SUBJECT_KEY_IDENTIFIER,
            pCertExtension.Value.pbData, pCertExtension.Value.cbData, 0, pStruct, @cbStruct);

          pb := PCRYPT_DATA_BLOB(pStruct);
          Result := BytesToHex(pb.pbData, pb.cbData);
        finally
          FreeMem(pStruct);
        end;
      end;
    end;
  end;
end;

function TclCertificate.GetSubjectString: string;
var
  len: Integer;
  buf: TclCryptData;
begin
  Result := '';

  len := CertNameToStr(Context.dwCertEncodingType, @Context.pCertInfo.Subject,
    CERT_X500_NAME_STR or CERT_NAME_STR_NO_PLUS_FLAG, nil, 0);

  if (len < 1) then Exit;

  buf := TclCryptData.Create(len * 2);
  try
    CertNameToStr(Context.dwCertEncodingType, @Context.pCertInfo.Subject,
      CERT_X500_NAME_STR or CERT_NAME_STR_NO_PLUS_FLAG, PWideChar(buf.Data), len);
    Result := string(buf.ToWideString());
  finally
    buf.Free();
  end;
end;

function TclCertificate.GetThumbprint: string;
var
  cbSize: DWORD;
  pInfo: TclCryptData;
begin
  Result := '';
  cbSize := 0;
  if not CertGetCertificateContextProperty(FCertContext,
    CERT_HASH_PROP_ID, nil, @cbSize) then Exit;
  if (cbSize < 1) then Exit;

  pInfo := TclCryptData.Create(cbSize);
  try
    CertGetCertificateContextProperty(FCertContext, CERT_HASH_PROP_ID, pInfo.Data, @cbSize);
    Result := BytesToHex(pInfo.Data, cbSize);
  finally
    pInfo.Free();
  end;
end;

procedure TclCertificate.SetUsageFlags(AFlags: TStrings);
  function GetTotalLen(AList: TStrings): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 0 to AList.Count - 1 do
    begin
      Result := Result + Length(AList[i]) + 1;
    end;
  end;

var
  i: Integer;
  usageInfo: CERT_ENHKEY_USAGE;
  pIdentifiers, pFlags: TclCryptData;
  pi, pf: PclChar;
  s: TclString;
begin
  usageInfo.cUsageIdentifier := AFlags.Count;

  pIdentifiers := nil;
  pFlags := nil;
  try
    pIdentifiers := TclCryptData.Create(AFlags.Count * SizeOf(Pointer));
    usageInfo.rgpszUsageIdentifier := pIdentifiers.Data;

    pFlags := TclCryptData.Create(GetTotalLen(AFlags));
    pf := PclChar(pFlags.Data);
    pi := PclChar(usageInfo.rgpszUsageIdentifier);
    for i := 0 to AFlags.Count - 1 do
    begin
      system.Move(pf, pi^, SizeOf(pf));

      s := GetTclString(AFlags[i]) + #0;
      system.Move(Pointer(s)^, pf^, Length(s));
      pf := pf + Length(s);
      pi := pi + SizeOf(Pointer);
    end;

    if not CertSetEnhancedKeyUsage(Context, @usageInfo) then
    begin
      RaiseCryptError('CertSetEnhancedKeyUsage');
    end;
  finally
    pFlags.Free();
    pIdentifiers.Free();
  end;
end;

function TclCertificate.GetUsageFlags: string;
var
  i: Integer;
  cbSize: DWORD;
  pUsage: TclCryptData;
  usageInfo: PCERT_ENHKEY_USAGE;
  p: Pointer;
  pc: PclChar;
  s: string;
begin
  Result := '';
  cbSize := 0;

  if (not CertGetEnhancedKeyUsage(Context, 0, nil, @cbSize)) or (cbSize = 0) then
  begin
    if (GetLastError() = CRYPT_E_NOT_FOUND) then Exit;
    RaiseCryptError('CertGetEnhancedKeyUsage');
  end;

  pUsage := TclCryptData.Create(cbSize);
  try
    CertGetEnhancedKeyUsage(Context, 0, PCERT_ENHKEY_USAGE(pUsage.Data), @cbSize);
    usageInfo := PCERT_ENHKEY_USAGE(pUsage.Data);

    for i := 0 to Integer(usageInfo.cUsageIdentifier) - 1 do
    begin
      p := Pointer(TclIntPtr(usageInfo.rgpszUsageIdentifier) + i * SizeOf(Pointer));
      pc := PclChar(p^);
      if (Length(pc) > 0) then
      begin
        s := TclTranslator.GetString(pc, Length(pc), 'us-ascii');
        Result := Result + s + ',';
      end;
    end;

    if (Result <> '') then
    begin
      SetLength(Result, Length(Result) - 1);
    end;
  finally
    pUsage.Free();
  end;
end;

procedure TclCertificate.SetFriendlyName(const Value: string);
var
  nameBlob: CRYPT_DATA_BLOB;
  ws: WideString;
begin
  if (FFriendlyName = Value) then Exit;

  FFriendlyName := Value;

  ws := WideString(FFriendlyName);

  nameBlob.cbData := (Length(ws) + 1) * 2;
  nameBlob.pbData := Pointer(ws);

  if not CertSetCertificateContextProperty(Context, CERT_FRIENDLY_NAME_PROP_ID, 0, @nameBlob) then
  begin
    RaiseCryptError('CertSetCertificateContextProperty');
  end;
end;

procedure TclCertificate.SetPrivateKey(const AName, ACSP: string; AProviderType: Integer; AKeyType: TclCertificateKeyType);
begin
  SetPrivateKey(AName, ACSP, AProviderType, GetKeyTypeInt(AKeyType));
end;

procedure TclCertificate.SetPrivateKey(const AName, ACSP: string; AProviderType, AKeyType: Integer);
var
  info: CRYPT_KEY_PROV_INFO;
begin
  info.pwszContainerName := PWideChar(WideString(AName));
  info.pwszProvName := PWideChar(WideString(ACSP));
  info.dwProvType := AProviderType;
  info.dwFlags := 0;
  info.cProvParam := 0;
  info.rgProvParam := nil;
  info.dwKeySpec := AKeyType;
  if not CertSetCertificateContextProperty(Context, CERT_KEY_PROV_INFO_PROP_ID,
    0, @info) then
  begin
    RaiseCryptError('CertSetCertificateContextProperty');
  end;
end;

procedure TclCertificate.SetUsage(const Value: string);
var
  s: string;
  list: TStrings;
begin
  if (FUsage = Value) then Exit;
  FUsage := Value;

  s := StringReplace(FUsage, ',', #13#10, [rfReplaceAll]);
  s := StringReplace(s, ';', #13#10, [rfReplaceAll]);

  list := TStringList.Create();
  try
    list.Text := s;
    SetUsageFlags(list);
  finally
    list.Free();
  end;
end;

function TclCertificate.CheckUsage(const AOID: string): Boolean;
begin
  Result := (Usage = '') or (system.Pos(AOID, Usage) > 0);
end;

constructor TclCertificate.Create(AEncoded: PByte; ALength: Integer);
begin
  inherited Create();
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'CreateFromBinary');{$ENDIF}
  FCertContext := CertCreateCertificateContext(DefaultEncoding,
    AEncoded, ALength);
  FCertContext := CertDuplicateCertificateContext(FCertContext);
  if (FCertContext = nil) then
  begin
    RaiseCryptError('CertDuplicateCertificateContext');
  end;
  GetCertInfo();
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'CreateFromBinary'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'CreateFromBinary', E); raise; end; end;{$ENDIF}
end;

{ TclCertificateList }

procedure TclCertificateList.Add(ACertificate: TclCertificate);
begin
  FList.Add(ACertificate);
end;

function TclCertificateList.AddFrom(ACertificate: TclCertificate): TclCertificate;
begin
  Result := TclCertificate.Create(ACertificate.Context);
  Add(Result);
end;

procedure TclCertificateList.Clear;
var
  i: Integer;
begin
  if FOwnsObjects then
  begin
    for i := 0 to Count - 1 do
    begin
      Items[i].Free();
    end;
  end;
  FList.Clear();
end;

constructor TclCertificateList.Create(AOwnsObjects: Boolean);
begin
  inherited Create();
  FList := TList.Create();
  FOwnsObjects := AOwnsObjects;
end;

procedure TclCertificateList.Delete(Index: Integer);
begin
  if FOwnsObjects then
  begin
    Items[Index].Free();
  end;
  FList.Delete(Index);
end;

destructor TclCertificateList.Destroy;
begin
  Clear();
  FList.Free();
  inherited Destroy();
end;

function TclCertificateList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclCertificateList.GetItem(Index: Integer): TclCertificate;
begin
  Result := TclCertificate(FList[Index]);
end;

procedure TclCertificateList.Remove(ACertificate: TclCertificate);
begin
  Delete(FList.IndexOf(ACertificate));
end;

{ TclCertificateExtensions }

procedure TclCertificateExtensions.Add(AItem: TclCertificateExtension);
begin
  Init();
  FList.Add(AItem);
end;

procedure TclCertificateExtensions.Clear;
begin
  Init();
  FList.Clear();
end;

constructor TclCertificateExtensions.Create;
begin
  inherited Create();
  FList := TObjectList.Create(True);
  FrgExtension := nil;
end;

destructor TclCertificateExtensions.Destroy;
begin
  Clear();
  FList.Free();
  inherited Destroy();
end;

function TclCertificateExtensions.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclCertificateExtensions.GetExtension: PCERT_EXTENSION;
var
  i: Integer;
begin
  Init();
  Result := nil;

  if (Count > 0) then
  begin
    FrgExtension := TclCryptData.Create(Count * Sizeof(CERT_EXTENSION));

    for i := 0 to Count - 1 do
    begin
      Items[i].GetExtension(PCERT_EXTENSION(TclIntPtr(FrgExtension.Data) + i * Sizeof(CERT_EXTENSION)));
    end;
    
    Result := PCERT_EXTENSION(FrgExtension.Data);
  end;
end;

function TclCertificateExtensions.GetItems(Index: Integer): TclCertificateExtension;
begin
  Result := TclCertificateExtension(FList[Index]);
end;

procedure TclCertificateExtensions.Init;
begin
  FrgExtension.Free();
  FrgExtension := nil;
end;

{ TclKeyUsageExtension }

constructor TclKeyUsageExtension.Create(AUsage: Integer);
begin
  inherited Create();
  FUsage := AUsage;
end;

procedure TclKeyUsageExtension.GetExtension(AExtension: PCERT_EXTENSION);
var
  KeyUsage: CRYPT_BIT_BLOB;
begin
  ZeroMemory(@KeyUsage, Sizeof(KeyUsage));

  KeyUsage.cbData := 1;
  GetMem(KeyUsage.pbData, KeyUsage.cbData);
  try
    KeyUsage.pbData^ := FUsage;

    AExtension.pszObjId := szOID_KEY_USAGE;
    AExtension.fCritical := True;

    AssignValue(@AExtension.Value, X509_KEY_USAGE, @KeyUsage);
  finally
    FreeMem(KeyUsage.pbData);
  end;
end;

{ TclEnhancedKeyUsageExtension }

constructor TclEnhancedKeyUsageExtension.Create(AUsage: TStrings);
begin
  inherited Create();
  FUsage := AUsage;
end;

procedure TclEnhancedKeyUsageExtension.GetExtension(AExtension: PCERT_EXTENSION);
var
  i: Integer;
  EnhKeyUsage: CERT_ENHKEY_USAGE;
  p: ^PclChar;
  oidList: TList;
  s: TclString;
  buf: PclChar;
begin
  ZeroMemory(@EnhKeyUsage, Sizeof(EnhKeyUsage));

  EnhKeyUsage.cUsageIdentifier := FUsage.Count;
  GetMem(EnhKeyUsage.rgpszUsageIdentifier, SizeOf(PclChar) * EnhKeyUsage.cUsageIdentifier);
  try
    oidList := TList.Create();
    try
      for i := 0 to EnhKeyUsage.cUsageIdentifier - 1 do
      begin
        p := Pointer(TclIntPtr(EnhKeyUsage.rgpszUsageIdentifier) + i * SizeOf(PclChar));
        s := GetTclString(FUsage[i]);

        GetMem(buf, Length(s) + 1);
        oidList.Add(buf);
        system.Move(Pointer(s)^, buf^, Length(s));
        buf[Length(s)] := #0;
        p^ := buf;
      end;

      AExtension.pszObjId := szOID_ENHANCED_KEY_USAGE;
      AExtension.fCritical := False;

      AssignValue(@AExtension.Value, X509_ENHANCED_KEY_USAGE, @EnhKeyUsage);
    finally
      for i := oidList.Count - 1 downto 0 do
      begin
        FreeMem(oidList[i]);
      end;
      oidList.Free();
    end;
  finally
    FreeMem(EnhKeyUsage.rgpszUsageIdentifier);
  end;
end;

{ TclCertificateExtension }

procedure TclCertificateExtension.ClearValue;
begin
  FExtValue.Free();
  FExtValue := nil;
end;

destructor TclCertificateExtension.Destroy;
begin
  ClearValue();
  inherited Destroy();
end;

procedure TclCertificateExtension.AssignValue(AValue: PCRYPTOAPI_BLOB; AStructType: PAnsiChar; AStructure: Pointer);
var
  size: DWORD;
begin
  ClearValue();

  if not CryptEncodeObject(DefaultEncoding, AStructType, AStructure, nil, @size) then
  begin
    RaiseCryptError('CryptEncodeObject');
  end;

  FExtValue := TclCryptData.Create(size);
  AValue.cbData := size;
  AValue.pbData := FExtValue.Data;
  ZeroMemory(AValue.pbData, AValue.cbData);

  if not CryptEncodeObject(DefaultEncoding, AStructType, AStructure, AValue.pbData, @size) then
  begin
    RaiseCryptError('CryptEncodeObject');
  end;

  FExtValue.Reduce(size);
end;

end.
