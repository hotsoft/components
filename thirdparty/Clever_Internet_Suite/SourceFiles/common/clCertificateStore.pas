{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCertificateStore;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clCertificate, clCertificateKey, clCryptAPI, clCryptUtils, clUtils, clWUtils;

type
  TclRevocationFlags = (rfNone, rfCheckEndOnly, rfCheckAll, rfExcludeRoot);

  TclCertificateStoreLocation = (slCurrentUser, slLocalMachine);

  TclCertificateImportFlag = (ifMakeExportable, ifStrongProtection, ifMachineKeyset, ifUserKeyset);
  TclCertificateImportFlags = set of TclCertificateImportFlag;

  TclGetCertificateEvent = procedure (Sender: TObject; var ACertificate: TclCertificate;
    AExtraCerts: TclCertificateList; var Handled: Boolean) of object;

  TclCertificateVerifiedEvent = procedure (Sender: TObject; ACertificate: TclCertificate;
    ATrustStatus, ATrustInfo: Integer) of object;

  TclCertificateStore = class(TComponent)
  private
    FList: TclCertificateList;
    FStoreHandle: HCERTSTORE;
    FStoreName: string;
    FStoreLocation: TclCertificateStoreLocation;
    FCSP: string;
    FKeyName: string;
    FKeyLength: Integer;
    FKeyType: TclCertificateKeyType;
    FValidFrom: TDateTime;
    FValidTo: TDateTime;
    FCRLFlags: TclRevocationFlags;
    FOnCertificateVerified: TclCertificateVerifiedEvent;
    FKeyUsage: Integer;
    FEnhancedKeyUsage: TStrings;
    FProviderType: Integer;
    FCSPPtr: PclChar;

    function GetCSP: PclChar;
    function GetItems: TclCertificateList;
    procedure InternalLoad(hStore: HCERTSTORE; ARemoveDuplicates: Boolean);
    function InternalImportCER(const ABytes: TclByteArray): TclCertificate;
    function InternalExportCER(ACertificate: TclCertificate): TclByteArray;
    function InternalSignCSR(AIssuer: TclCertificate; ARequest: TclByteArray;
      ASerialNumber: Integer): TclCertificate;
    function InternalCreateSigned(AIssuer: TclCertificate; ASubject: PCRYPT_DATA_BLOB;
      ASerialNumber: Integer; AExtensions: PCERT_EXTENSION; AExtensionCount: Integer): TclCertificate;
    function InternalExportKey(const AName: string): TclByteArray;
    procedure InternalImportKey(const AName: string; const ABytes: TclByteArray);

    procedure CreateContext(var context: HCRYPTPROV; var key: HCRYPTKEY);
    function GetKeyTypeInt: Integer;
    function GenerateKey(AContext: HCRYPTPROV; AKeySpec: DWORD): HCRYPTKEY;
    function GenerateSubject(const ASubject: string): TclCryptData;
    function GetPublicKeyInfo(AContext: HCRYPTPROV; Alg: DWORD): TclCryptData;
    function GetSerialNumber(ASerialNumber: Integer): Integer;
    procedure GetCertificatePrivateKey(ACertificate: PCCERT_CONTEXT;
      var AContext: HCRYPTPROV; var Alg: Integer);
    function SignAndEncodeRequest(AContext: HCRYPTPROV; Alg: DWORD;
      AReqInfo: PCERT_REQUEST_INFO; ASigAlg: PCRYPT_ALGORITHM_IDENTIFIER): TclCryptData;
    function SignAndEncodeCert(AContext: HCRYPTPROV; Alg: DWORD; ACertInfo: PCERT_INFO): TclCryptData;
    procedure SaveCSR(AEncodedRequest: TclByteArray; AStream: TStream; ABase64Encode: Boolean);
    procedure FillCertInfo(ACertInfo: PCERT_INFO; ASubject: PCRYPT_DATA_BLOB; AIssuer: PCRYPT_DATA_BLOB);
    procedure GetCertificateChain(hStore: HCERTSTORE; ACertificate: TclCertificate; var ATrustStatus, ATrustInfo: Integer);
    function GetExtensions: TclCertificateExtensions;
    procedure SetEnhancedKeyUsage(const Value: TStrings);
    function GetExtensionAttribute(AReqInfo: PCERT_REQUEST_INFO): TclCryptData;
    procedure SetCSP(const Value: string);
  protected
    procedure DoCertificateVerified(ACertificate: TclCertificate; ATrustStatus, ATrustInfo: Integer); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Open(const AStoreName: string); overload;
    procedure Open(const AStoreName: string; AStoreLocation: TclCertificateStoreLocation); overload;
    procedure Open(AStoreHandle: HCERTSTORE); overload;
    procedure Close;

    function CreateSelfSigned(const ASubject: string; ASerialNumber: Integer): TclCertificate;
    function CreateSigned(AIssuer: TclCertificate; const ASubject: string; ASerialNumber: Integer): TclCertificate;

    procedure CreateCSR(const ASubject, ARequestFile: string); overload;
    procedure CreateCSR(const ASubject: string; ARequest: TStream; ABase64Encode: Boolean); overload;
    function SignCSR(AIssuer: TclCertificate; const ARequestFile: string; ASerialNumber: Integer): TclCertificate; overload;
    function SignCSR(AIssuer: TclCertificate; ARequest: TStream; ASerialNumber: Integer): TclCertificate; overload;

    procedure ImportFromPFX(const AFileName, APassword: string); overload;
    procedure ImportFromPFX(const AFileName, APassword: string; AFlags: TclCertificateImportFlags); overload;
    procedure ImportFromPFX(AStream: TStream; const APassword: string; AFlags: TclCertificateImportFlags); overload;

    procedure ImportFromCER(const AFileName: string); overload;
    procedure ImportFromCER(AStream: TStream); overload;

    procedure ImportSignedCSR(const AFileName: string); overload;
    procedure ImportSignedCSR(AStream: TStream); overload;

    procedure ImportFromMessage(const AFileName: string); overload;
    procedure ImportFromMessage(AStream: TStream); overload;
    procedure ImportFromMessage(const AData: TclCryptData); overload;

    procedure ExportToPFX(ACertificate: TclCertificate; const AFileName, APassword: string); overload;
    procedure ExportToPFX(ACertificate: TclCertificate; const AFileName, APassword: string; AIncludeAll: Boolean); overload;
    procedure ExportToPFX(ACertificate: TclCertificate; AStream: TStream; const APassword: string; AIncludeAll: Boolean); overload;

    procedure ExportToCER(ACertificate: TclCertificate; const AFileName: string); overload;
    procedure ExportToCER(ACertificate: TclCertificate; AStream: TStream; ABase64Encode: Boolean); overload;

    function Verify(ACertificate: TclCertificate; var ATrustStatus, ATrustInfo: Integer): Boolean; overload;
    function Verify(ACertificate: TclCertificate): Boolean; overload;

    procedure Install(ACertificate: TclCertificate);
    procedure Uninstall(ACertificate: TclCertificate);
    function IsInstalled(ACertificate: TclCertificate): Boolean;

    function CertificateByEmail(const AEmail: string): TclCertificate;
    function CertificateByIssuedTo(const AIssuedTo: string): TclCertificate;
    function CertificateBySerialNo(const ASerialNumber, AIssuer: string): TclCertificate;
    function CertificateByThumbprint(const AThumbprint: string): TclCertificate;
    function CertificateBySKI(const ASubjectKeyIdentifier: string): TclCertificate;

    function FindByEmail(const AEmail: string): TclCertificate; overload;
    function FindByEmail(const AEmail: string; ARequirePrivateKey: Boolean): TclCertificate; overload;
    function FindByIssuedTo(const AIssuedTo: string): TclCertificate; overload;
    function FindByIssuedTo(const AIssuedTo: string; ARequirePrivateKey: Boolean): TclCertificate; overload;
    function FindBySerialNo(const ASerialNumber, AIssuer: string): TclCertificate; overload;
    function FindBySerialNo(const ASerialNumber, AIssuer: string; ARequirePrivateKey: Boolean): TclCertificate; overload;
    function FindByThumbprint(const AThumbprint: string): TclCertificate; overload;
    function FindByThumbprint(const AThumbprint: string; ARequirePrivateKey: Boolean): TclCertificate; overload;
    function FindBySKI(const ASubjectKeyIdentifier: string): TclCertificate; overload;
    function FindBySKI(const ASubjectKeyIdentifier: string; ARequirePrivateKey: Boolean): TclCertificate; overload;

    procedure CreateKey(const AName: string);
    procedure DeleteKey(const AName: string);
    procedure GetKeyList(AList: TStrings);
    function KeyExists(const AName: string): Boolean;
    function GetKey(const AName: string): TclCertificateKey;

    procedure ExportKey(const AName: string; AStream: TStream; ABase64Encode: Boolean); overload;
    procedure ExportKey(const AName, AFileName: string); overload;

    procedure ImportKey(const AName: string; AStream: TStream); overload;
    procedure ImportKey(const AName, AFileName: string); overload;

    property Items: TclCertificateList read GetItems;
    property StoreHandle: HCERTSTORE read FStoreHandle;
  published
    property StoreName: string read FStoreName write FStoreName;
    property StoreLocation: TclCertificateStoreLocation read FStoreLocation write FStoreLocation default slCurrentUser;
    property CSP: string read FCSP write SetCSP;
    property ProviderType: Integer read FProviderType write FProviderType default PROV_RSA_FULL;
    property KeyName: string read FKeyName write FKeyName;
    property KeyLength: Integer read FKeyLength write FKeyLength default 1024;
    property KeyType: TclCertificateKeyType read FKeyType write FKeyType default ktKeyExchange;
    property ValidFrom: TDateTime read FValidFrom write FValidFrom;
    property ValidTo: TDateTime read FValidTo write FValidTo;
    property CRLFlags: TclRevocationFlags read FCRLFlags write FCRLFlags default rfNone;
    property KeyUsage: Integer read FKeyUsage write FKeyUsage default 0;
    property EnhancedKeyUsage: TStrings read FEnhancedKeyUsage write SetEnhancedKeyUsage;

    property OnCertificateVerified: TclCertificateVerifiedEvent read FOnCertificateVerified write FOnCertificateVerified;
  end;

function GetStoreLocationInt(AStoreLocation: TclCertificateStoreLocation): Integer;
function GetCertificateImportFlagsInt(AFlags: TclCertificateImportFlags): Integer;

implementation

uses
  clCryptEncoder, clEncoder, clTranslator{$IFDEF LOGGER}, clLogger{$ENDIF};

function GetStoreLocationInt(AStoreLocation: TclCertificateStoreLocation): Integer;
const
  location: array[TclCertificateStoreLocation] of DWORD = ($00010000, $00020000);
begin
  Result := location[AStoreLocation];
end;

function GetCertificateImportFlagsInt(AFlags: TclCertificateImportFlags): Integer;
begin
  Result := 0;
  if (ifMakeExportable in AFlags) then
  begin
    Result := Result or $00000001;
  end;
  if (ifStrongProtection in AFlags) then
  begin
    Result := Result or $00000002;
  end;
  if (ifMachineKeyset in AFlags) then
  begin
    Result := Result or $00000020;
  end;
  if (ifUserKeyset in AFlags) then
  begin
    Result := Result or $00001000;
  end;
end;

{ TclCertificateStore }

procedure TclCertificateStore.Close;
begin
  FList.Clear();
  if (FStoreHandle <> nil) then
  begin
    CertCloseStore(FStoreHandle, 0);
    FStoreHandle := nil;
  end;
end;

constructor TclCertificateStore.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FList := TclCertificateList.Create(True);
  FEnhancedKeyUsage := TStringList.Create();

  FKeyUsage := 0;
  FStoreHandle := nil;
  FStoreName := 'MY';
  FStoreLocation := slCurrentUser;
  FCSP := DefaultProvider;
  FProviderType := DefaultProviderType;
  FKeyLength := 1024;
  FKeyName := '';
  FKeyType := ktKeyExchange;
  FValidFrom := Date();
  FValidTo := Date() + 365;
  FCRLFlags := rfNone;
end;

procedure TclCertificateStore.CreateCSR(const ASubject, ARequestFile: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(ARequestFile, fmCreate);
  try
    CreateCSR(ASubject, stream, True);
  finally
    stream.Free();
  end;
end;

procedure TclCertificateStore.CreateContext(var context: HCRYPTPROV; var key: HCRYPTKEY);
begin
  if (KeyName = '') then
  begin
    KeyName := IntToStr(Integer(GetTickCount()));
    if not CryptAcquireContext(@context, PclChar(GetTclString(KeyName)), GetCSP(), ProviderType, CRYPT_NEWKEYSET) then
    begin
      RaiseCryptError('CryptAcquireContext');
    end;

    key := GenerateKey(context, GetKeyTypeInt());
  end else
  begin
    if not CryptAcquireContext(@context, PclChar(GetTclString(KeyName)), GetCSP(), ProviderType, 0) then
    begin
      RaiseCryptError('CryptAcquireContext');
    end;

    key := nil;
    if not CryptGetUserKey(context, GetKeyTypeInt(), @key) then
    begin
      key := nil;
    end;
  end;
end;

procedure TclCertificateStore.CreateCSR(const ASubject: string;
  ARequest: TStream; ABase64Encode: Boolean);
var
  context: HCRYPTPROV;
  key: HCRYPTKEY;
  subj, keyInfo: TclCryptData;
  reqInfo: CERT_REQUEST_INFO;
  sigAlg: CRYPT_ALGORITHM_IDENTIFIER;
  encodedRequest: TclCryptData;
  extensions: TclCertificateExtensions;
  Attrib: CRYPT_ATTRIBUTE;
  AttrBlob: CRYPT_ATTR_BLOB;
  Exts: CERT_EXTENSIONS;
begin
  ZeroMemory(@Exts, Sizeof(Exts));
  ZeroMemory(@Attrib, Sizeof(Attrib));
  ZeroMemory(@AttrBlob, Sizeof(AttrBlob));

  context := nil;
  key := nil;
  try
    CreateContext(context, key);

    subj := nil;
    keyInfo := nil;
    encodedRequest := nil;
    extensions := nil;
    try
      subj := GenerateSubject(ASubject);

      ZeroMemory(@reqInfo, sizeof(reqInfo));

      reqInfo.dwVersion := Integer(cvVersion3);
      reqInfo.Subject.cbData := subj.DataSize;
      reqInfo.Subject.pbData := subj.Data;

      keyInfo := GetPublicKeyInfo(context, GetKeyTypeInt());

      reqInfo.SubjectPublicKeyInfo := PCERT_PUBLIC_KEY_INFO(keyInfo.Data)^;

      ZeroMemory(@sigAlg, sizeof(sigAlg));
      sigAlg.pszObjId := szOID_RSA_SHA1RSA;
      sigAlg.Parameters.cbData := 0;

      extensions := GetExtensions();
      if (extensions <> nil) then
      begin
        Attrib.pszObjId := szOID_CERT_EXTENSIONS;
        Attrib.cValue := 1;
        Attrib.rgValue := @AttrBlob;

        reqInfo.cAttribute := 1;
        reqInfo.rgAttribute := @Attrib;

        Exts.rgExtension := extensions.Extension;
        Exts.cExtension := extensions.Count;

        if not CryptEncodeObject(DefaultEncoding, szOID_CERT_EXTENSIONS, @Exts, nil, @AttrBlob.cbData) then
        begin
          RaiseCryptError('CryptEncodeObject');
        end;

        GetMem(AttrBlob.pbData, AttrBlob.cbData);
        ZeroMemory(AttrBlob.pbData, AttrBlob.cbData);
        if not CryptEncodeObject(DefaultEncoding, szOID_CERT_EXTENSIONS, @Exts, AttrBlob.pbData, @AttrBlob.cbData) then
        begin
          RaiseCryptError('CryptEncodeObject');
        end;
      end;

      encodedRequest := SignAndEncodeRequest(context, GetKeyTypeInt(), @reqInfo, @sigAlg);
      SaveCSR(encodedRequest.ToBytes(), ARequest, ABase64Encode);
    finally
      encodedRequest.Free();
      if (AttrBlob.pbData <> nil) then
      begin
        FreeMem(AttrBlob.pbData);
      end;
      extensions.Free();
      keyInfo.Free();
      subj.Free();
    end;
  finally
    if (key <> nil) then
    begin
      CryptDestroyKey(key);
    end;
    if (context <> nil) then
    begin
      CryptReleaseContext(context, 0);
    end;
  end;
end;

procedure TclCertificateStore.CreateKey(const AName: string);
var
  context: HCRYPTPROV;
  key: HCRYPTKEY;
begin
  context := nil;
  key := nil;
  try
    if (not CryptAcquireContext(@context, PclChar(GetTclString(AName)), GetCSP(), ProviderType, 0))
      and (not CryptAcquireContext(@context, PclChar(GetTclString(AName)), GetCSP(), ProviderType, CRYPT_NEWKEYSET)) then
    begin
      RaiseCryptError('CryptAcquireContext');
    end;

    if CryptGetUserKey(context, GetKeyTypeInt(), @key) then
    begin
      RaiseCryptError(KeyExistsError, KeyExistsErrorCode);
    end;

    key := GenerateKey(context, GetKeyTypeInt());
  finally
    if (key <> nil) then
    begin
      CryptDestroyKey(key);
    end;
    if (context <> nil) then
    begin
      CryptReleaseContext(context, 0);
    end;
  end;
end;

procedure TclCertificateStore.SetCSP(const Value: string);
begin
  if (FCSP <> Value) then
  begin
    FCSP := Value;
    FreeMem(FCSPPtr);
    FCSPPtr := nil;
  end;
end;

procedure TclCertificateStore.SetEnhancedKeyUsage(const Value: TStrings);
begin
  FEnhancedKeyUsage.Assign(Value);
end;

function TclCertificateStore.GetExtensions: TclCertificateExtensions;
begin
  Result := nil;

  if (KeyUsage > 0) then
  begin
    if (Result = nil) then
    begin
      Result := TclCertificateExtensions.Create();
    end;
    Result.Add(TclKeyUsageExtension.Create(KeyUsage));
  end;

  if (EnhancedKeyUsage.Count > 0) then
  begin
    if (Result = nil) then
    begin
      Result := TclCertificateExtensions.Create();
    end;
    Result.Add(TclEnhancedKeyUsageExtension.Create(EnhancedKeyUsage));
  end;
end;

function TclCertificateStore.CreateSelfSigned(const ASubject: string;
  ASerialNumber: Integer): TclCertificate;
var
  context: HCRYPTPROV;
  key: HCRYPTKEY;
  subj, serialData, keyInfo, encodedCert: TclCryptData;
  certInfo: CERT_INFO;
  subjBlob: CRYPT_DATA_BLOB;
  extensions: TclCertificateExtensions;
begin
  context := nil;
  key := nil;
  subj := nil;
  serialData := nil;
  keyInfo := nil;
  encodedCert := nil;
  extensions := nil;
  try
    CreateContext(context, key);

    subj := GenerateSubject(ASubject);

    ZeroMemory(@certInfo, sizeof(certInfo));

    ASerialNumber := GetSerialNumber(ASerialNumber);
    serialData := TclCryptData.Create(SizeOf(ASerialNumber));
    CopyMemory(serialData.Data, @ASerialNumber, serialData.DataSize);

    certInfo.SerialNumber.pbData := serialData.Data;
    certInfo.SerialNumber.cbData := serialData.DataSize;

    subjBlob.cbData := subj.DataSize;
    subjBlob.pbData := subj.Data;

    FillCertInfo(@certInfo, @subjBlob, @subjBlob);

    keyInfo := GetPublicKeyInfo(context, GetKeyTypeInt());

    certInfo.SubjectPublicKeyInfo := PCERT_PUBLIC_KEY_INFO(keyInfo.Data)^;

    extensions := GetExtensions();
    if (extensions <> nil) then
    begin
      certInfo.rgExtension := extensions.Extension;
      certInfo.cExtension := extensions.Count;
    end;

    encodedCert := SignAndEncodeCert(context, GetKeyTypeInt(), @certInfo);

    Result := TclCertificate.Create(encodedCert.Data, encodedCert.DataSize);
    try
      Result.SetPrivateKey(KeyName, CSP, ProviderType, GetKeyTypeInt());
    except
      Result.Free();
      raise;
    end;
  finally
    encodedCert.Free();
    extensions.Free();
    keyInfo.Free();
    serialData.Free();
    subj.Free();
    if (key <> nil) then
    begin
      CryptDestroyKey(key);
    end;
    if (context <> nil) then
    begin
      CryptReleaseContext(context, 0);
    end;
  end;
end;

function TclCertificateStore.CreateSigned(AIssuer: TclCertificate;
  const ASubject: string; ASerialNumber: Integer): TclCertificate;
var
  subj: TclCryptData;
  subjBlob: CRYPT_DATA_BLOB; 
  extensions: TclCertificateExtensions;
begin
  subj := nil;
  extensions := nil;
  try
    subj := GenerateSubject(ASubject);
    extensions := GetExtensions();

    subjBlob.cbData := subj.DataSize;
    subjBlob.pbData := subj.Data;

    if (extensions <> nil) then
    begin
      Result := InternalCreateSigned(AIssuer, @subjBlob, ASerialNumber, extensions.Extension, extensions.Count);
    end else
    begin
      Result := InternalCreateSigned(AIssuer, @subjBlob, ASerialNumber, nil, 0);
    end;
  finally
    extensions.Free();
    subj.Free();
  end;
end;

procedure TclCertificateStore.DeleteKey(const AName: string);
var
  context: HCRYPTPROV;
begin
  context := nil;
  try
    if not CryptAcquireContext(@context, PclChar(GetTclString(AName)), GetCSP(), ProviderType, CRYPT_DELETEKEYSET) then
    begin
      RaiseCryptError('CryptAcquireContext');
    end;
  finally
    if (context <> nil) then
    begin
      CryptReleaseContext(context, 0);
    end;
  end;
end;

destructor TclCertificateStore.Destroy;
begin
  SetCSP('');
  Close();
  FEnhancedKeyUsage.Free();
  FList.Free();
  inherited Destroy();
end;

procedure TclCertificateStore.DoCertificateVerified(ACertificate: TclCertificate;
  ATrustStatus, ATrustInfo: Integer);
begin
  if Assigned(OnCertificateVerified) then
  begin
    OnCertificateVerified(Self, ACertificate, ATrustStatus, ATrustInfo);
  end;
end;

procedure TclCertificateStore.Open(const AStoreName: string);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Open(' + AStoreName + ')');{$ENDIF}
  Close();
  FStoreName := AStoreName;
  FStoreLocation := slCurrentUser;
  FStoreHandle := CertOpenSystemStore(nil, PclChar(GetTclString(StoreName)));
  if (FStoreHandle <> nil) then
  begin
    InternalLoad(FStoreHandle, False);
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Open'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Open', E); raise; end; end;{$ENDIF}
end;

procedure TclCertificateStore.Open(const AStoreName: string;
  AStoreLocation: TclCertificateStoreLocation);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Open(' + AStoreName + ', ' + IntToStr(Integer(AStoreLocation)) + ')');{$ENDIF}
  Close();
  FStoreName := AStoreName;
  FStoreLocation := AStoreLocation;

  FStoreHandle := CertOpenStore(CERT_STORE_PROV_SYSTEM, DefaultEncoding,
    nil, GetStoreLocationInt(StoreLocation), PWideChar(WideString(FStoreName)));
  if (FStoreHandle <> nil) then
  begin
    InternalLoad(FStoreHandle, False);
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Open'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Open', E); raise; end; end;{$ENDIF}
end;

procedure TclCertificateStore.Open(AStoreHandle: HCERTSTORE);
begin
  Close();
  FStoreName := '';
  FStoreLocation := slCurrentUser;
  FStoreHandle := AStoreHandle;
  if (FStoreHandle <> nil) then
  begin
    InternalLoad(FStoreHandle, False);
  end;
end;

function TclCertificateStore.CertificateByEmail(const AEmail: string): TclCertificate;
begin
  Result := FindByEmail(AEmail);
  if (Result = nil) then
  begin
    RaiseCryptError(CertificateNotFound, CertificateNotFoundCode);
  end;
end;

function TclCertificateStore.CertificateByIssuedTo(const AIssuedTo: string): TclCertificate;
begin
  Result := FindByIssuedTo(AIssuedTo);
  if (Result = nil) then
  begin
    RaiseCryptError(CertificateNotFound, CertificateNotFoundCode);
  end;
end;

function TclCertificateStore.CertificateBySerialNo(const ASerialNumber, AIssuer: string): TclCertificate;
begin
  Result := FindBySerialNo(ASerialNumber, AIssuer);
  if (Result = nil) then
  begin
    RaiseCryptError(CertificateNotFound, CertificateNotFoundCode);
  end;
end;

function TclCertificateStore.CertificateBySKI(const ASubjectKeyIdentifier: string): TclCertificate;
begin
  Result := FindBySKI(ASubjectKeyIdentifier);
  if (Result = nil) then
  begin
    RaiseCryptError(CertificateNotFound, CertificateNotFoundCode);
  end;
end;

function TclCertificateStore.CertificateByThumbprint(const AThumbprint: string): TclCertificate;
begin
  Result := FindByThumbprint(AThumbprint);
  if (Result = nil) then
  begin
    RaiseCryptError(CertificateNotFound, CertificateNotFoundCode);
  end;
end;

procedure TclCertificateStore.ImportFromCER(const AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    ImportFromCER(stream);
  finally
    stream.Free();
  end;
end;

procedure TclCertificateStore.ImportFromCER(AStream: TStream);
var
  buf: TclByteArray;
  len: Integer;
begin
  len := AStream.Size - AStream.Position;
  SetLength(buf, len);
  if (len > 0) then
  begin
    AStream.Read(buf[0], len);
  end;

  InternalImportCER(TclCryptEncoder.DecodeBytes(buf));
end;

procedure TclCertificateStore.ImportFromMessage(AStream: TStream);
var
  data: TclCryptData;
begin
  data := TclCryptData.Create();
  try
    data.FromStream(AStream);
    ImportFromMessage(data);
  finally
    data.Free();
  end;
end;

procedure TclCertificateStore.ImportFromMessage(const AData: TclCryptData);
var
  hStore: HCERTSTORE;
begin
  hStore := CryptGetMessageCertificates(DefaultEncoding, nil, 0, AData.Data, AData.DataSize);
  if (hStore = nil) then
  begin
    RaiseCryptError('CryptGetMessageCertificates');
  end;

  try
    InternalLoad(hStore, True);
  finally
    CertCloseStore(hStore, 0);
  end;
end;

procedure TclCertificateStore.ImportFromMessage(const AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    ImportFromMessage(stream);
  finally
    stream.Free();
  end;
end;

procedure TclCertificateStore.ImportFromPFX(AStream: TStream;
  const APassword: string; AFlags: TclCertificateImportFlags);
var
  PFX: CRYPT_DATA_BLOB;
  data: TclCryptData;
  psw: PWideChar;
  hStore: HCERTSTORE;
begin
  data := TclCryptData.Create();
  try
    data.FromStream(AStream);

    PFX.cbData := data.DataSize;
    PFX.pbData := data.Data;
    psw := PWideChar(WideString(APassword));

    hStore := PFXImportCertStore(@PFX, psw, GetCertificateImportFlagsInt(AFlags));
    if (hStore = nil) and (APassword = '') then
    begin
      hStore := PFXImportCertStore(@PFX, nil, GetCertificateImportFlagsInt(AFlags));
    end;
    if (hStore = nil) then
    begin
      RaiseCryptError('PFXImportCertStore');
    end;

    try
      InternalLoad(hStore, True);
    finally
      CertCloseStore(hStore, 0);
    end;
  finally
    data.Free();
  end;
end;

procedure TclCertificateStore.ImportFromPFX(const AFileName, APassword: string; AFlags: TclCertificateImportFlags);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    ImportFromPFX(stream, APassword, AFlags);
  finally
    stream.Free();
  end;
end;

procedure TclCertificateStore.ImportKey(const AName, AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    ImportKey(AName, stream);
  finally
    stream.Free();
  end;
end;

procedure TclCertificateStore.ImportKey(const AName: string; AStream: TStream);
var
  buf: TclByteArray;
  len: Integer;
begin
  len := AStream.Size - AStream.Position;
  SetLength(buf, len);
  if (len > 0) then
  begin
    AStream.Read(buf[0], len);
  end;
  InternalImportKey(AName, TclCryptEncoder.DecodeBytes(buf));
end;

procedure TclCertificateStore.ImportSignedCSR(const AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    ImportSignedCSR(stream);
  finally
    stream.Free();
  end;
end;

procedure TclCertificateStore.ImportSignedCSR(AStream: TStream);
var
  cert: TclCertificate;
  buf: TclByteArray;
  len: Integer;
begin
  len := AStream.Size - AStream.Position;
  SetLength(buf, len);
  if (len > 0) then
  begin
    AStream.Read(buf[0], len);
  end;

  cert := InternalImportCER(TclCryptEncoder.DecodeBytes(buf));
  cert.SetPrivateKey(KeyName, CSP, ProviderType, GetKeyTypeInt());
end;

procedure TclCertificateStore.ImportFromPFX(const AFileName, APassword: string);
begin
  ImportFromPFX(AFileName, APassword, [ifMakeExportable]);
end;

function TclCertificateStore.InternalCreateSigned(AIssuer: TclCertificate; ASubject: PCRYPT_DATA_BLOB;
  ASerialNumber: Integer; AExtensions: PCERT_EXTENSION; AExtensionCount: Integer): TclCertificate;
var
  context, issuerCtx: HCRYPTPROV;
  key: HCRYPTKEY;
  serialData, keyInfo, encodedCert: TclCryptData;
  certInfo: CERT_INFO;
  issuerKeySpec: Integer;
begin
  context := nil;
  key := nil;
  serialData := nil;
  keyInfo := nil;
  encodedCert := nil;
  try
    CreateContext(context, key);

    ZeroMemory(@certInfo, sizeof(certInfo));

    ASerialNumber := GetSerialNumber(ASerialNumber);
    serialData := TclCryptData.Create(SizeOf(ASerialNumber));
    CopyMemory(serialData.Data, @ASerialNumber, serialData.DataSize);

    certInfo.SerialNumber.pbData := serialData.Data;
    certInfo.SerialNumber.cbData := serialData.DataSize;

    FillCertInfo(@certInfo, ASubject, @AIssuer.Context.pCertInfo.Subject);

    keyInfo := GetPublicKeyInfo(context, GetKeyTypeInt());

    certInfo.SubjectPublicKeyInfo := PCERT_PUBLIC_KEY_INFO(keyInfo.Data)^;

    issuerCtx := nil;
    issuerKeySpec := 0;
    GetCertificatePrivateKey(AIssuer.Context, issuerCtx, issuerKeySpec);

    certInfo.rgExtension := AExtensions;
    certInfo.cExtension := AExtensionCount;

    encodedCert := SignAndEncodeCert(issuerCtx, issuerKeySpec, @certInfo);

    Result := TclCertificate.Create(encodedCert.Data, encodedCert.DataSize);
    try
      Result.SetPrivateKey(KeyName, CSP, ProviderType, GetKeyTypeInt());
    except
      Result.Free();
      raise;
    end;
  finally
    encodedCert.Free();
    keyInfo.Free();
    serialData.Free();
    if (key <> nil) then
    begin
      CryptDestroyKey(key);
    end;
    if (context <> nil) then
    begin
      CryptReleaseContext(context, 0);
    end;
  end;
end;

function TclCertificateStore.InternalExportCER(ACertificate: TclCertificate): TclByteArray;
begin
  SetLength(Result, ACertificate.Context.cbCertEncoded);
  System.Move(ACertificate.Context.pbCertEncoded^, Result[0], Length(Result));
end;

function TclCertificateStore.InternalExportKey(const AName: string): TclByteArray;
var
  context: HCRYPTPROV;
  hKey: HCRYPTKEY;
  data: TclCryptData;
  len: Integer;
begin
{$IFNDEF DELPHI2005}Result := nil;{$ENDIF}
  context := nil;
  try
    if not CryptAcquireContext(@context, PclChar(GetTclString(AName)), GetCSP(), ProviderType, 0) then
    begin
      RaiseCryptError('CryptAcquireContext');
    end;

    hKey := nil;
    try
      if not CryptGetUserKey(context, GetKeyTypeInt(), @hKey) then
      begin
        RaiseCryptError('CryptGetUserKey');
      end;

      if not CryptExportKey(hKey, nil, PRIVATEKEYBLOB, 0, nil, @len) then
      begin
        RaiseCryptError('CryptExportKey');
      end;

      data := TclCryptData.Create(len);
      try
        if not CryptExportKey(hKey, nil, PRIVATEKEYBLOB, 0, data.Data, @len) then
        begin
          RaiseCryptError('CryptExportKey');
        end;
        data.Reduce(len);

        Result := data.ToBytes();
      finally
        data.Free();
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

function TclCertificateStore.InternalImportCER(const ABytes: TclByteArray): TclCertificate;
var
  data: TclCryptData;
begin
  data := TclCryptData.Create();
  try
    data.FromBytes(ABytes);

    Result := TclCertificate.Create(data.Data, data.DataSize);
    Items.Add(Result);
  finally
    data.Free();
  end;
end;

procedure TclCertificateStore.InternalImportKey(const AName: string; const ABytes: TclByteArray);
var
  context: HCRYPTPROV;
  hKey, hNewKey: HCRYPTKEY;
  data: TclCryptData;
begin
  context := nil;
  hKey := nil;
  hNewKey := nil;
  try
    if (not CryptAcquireContext(@context, PclChar(GetTclString(AName)), GetCSP(), ProviderType, 0))
      and (not CryptAcquireContext(@context, PclChar(GetTclString(AName)), GetCSP(), ProviderType, CRYPT_NEWKEYSET)) then
    begin
      RaiseCryptError('CryptAcquireContext');
    end;

    if CryptGetUserKey(context, GetKeyTypeInt(), @hKey) then
    begin
      RaiseCryptError(KeyExistsError, KeyExistsErrorCode);
    end;

    data := TclCryptData.Create();
    try
      data.FromBytes(ABytes);

      if not CryptImportKey(context, data.Data, data.DataSize, hKey, CRYPT_EXPORTABLE, @hNewKey) then
      begin
        RaiseCryptError('CryptImportKey');
      end;
    finally
      data.Free();
    end;
  finally
    if (hNewKey <> nil) then
    begin
      CryptDestroyKey(hNewKey);
    end;
    if (hKey <> nil) then
    begin
      CryptDestroyKey(hKey);
    end;
    if (context <> nil) then
    begin
      CryptReleaseContext(context, 0);
    end;
  end;
end;

procedure TclCertificateStore.InternalLoad(hStore: HCERTSTORE; ARemoveDuplicates: Boolean);
var
  hCertContext: PCCERT_CONTEXT;
  cert: TclCertificate;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'InternalLoad');{$ENDIF}
  hCertContext := nil;
  repeat
    hCertContext := CertEnumCertificatesInStore(hStore, hCertContext);
    if (hCertContext <> nil) then
    begin
      cert := TclCertificate.Create(hCertContext);
      try
        if (ARemoveDuplicates and (FindBySerialNo(cert.SerialNumber, cert.IssuedBy) <> nil)) then
        begin
          FreeAndNil(cert);
        end;

        if (cert <> nil) then
        begin
          Items.Add(cert);
        end;
      except
        cert.Free();
        raise;
      end;
    end;
  until (hCertContext = nil);
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'InternalLoad'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'InternalLoad', E); raise; end; end;{$ENDIF}
end;

function TclCertificateStore.GetExtensionAttribute(AReqInfo: PCERT_REQUEST_INFO): TclCryptData;
var
  i, j: Integer;
  pAttr: PCRYPT_ATTRIBUTE;
  pEncodedExt: PCRYPT_ATTR_BLOB;
  cbStruct: DWORD;
begin
  Result := nil;
  
  for i := 0 to Integer(AReqInfo.cAttribute) - 1 do
  begin
    pAttr := PCRYPT_ATTRIBUTE(TclIntPtr(AReqInfo.rgAttribute) + i * SizeOf(CRYPT_ATTRIBUTE));
    if (string(pAttr.pszObjId) = szOID_CERT_EXTENSIONS) then
    begin
      for j := 0 to pAttr.cValue - 1 do
      begin
        pEncodedExt := PCRYPT_ATTR_BLOB(TclIntPtr(pAttr.rgValue) + j * SizeOf(CRYPT_ATTR_BLOB));

        Result := TclCryptData.Create();
        try
          if not (CryptDecodeObject(DefaultEncoding, szOID_CERT_EXTENSIONS, pEncodedExt.pbData, pEncodedExt.cbData, 0, nil, @cbStruct)) then
          begin
            RaiseCryptError('CryptDecodeObject');
          end;

          Result.Allocate(cbStruct);
          if not (CryptDecodeObject(DefaultEncoding, szOID_CERT_EXTENSIONS, pEncodedExt.pbData, pEncodedExt.cbData, 0, Result.Data, @cbStruct)) then
          begin
            RaiseCryptError('CryptDecodeObject');
          end;

          Result.Reduce(cbStruct);
        except
          Result.Free();
          raise;
        end;

        Break;
      end;

      Break;
    end;
  end;
end;

function TclCertificateStore.InternalSignCSR(AIssuer: TclCertificate;
  ARequest: TclByteArray; ASerialNumber: Integer): TclCertificate;
var
  pRequest: TclCryptData;
  cbStructInfo: DWORD;
  pReqInfo: PCERT_REQUEST_INFO;
  context: HCRYPTPROV;
  key: HCRYPTKEY;
  extensions: TclCertificateExtensions;
  reqExtensions: TclCryptData;
  pReqExts: PCERT_EXTENSIONS;
begin
  pRequest := nil;
  extensions := nil;
  reqExtensions := nil;
  try
    pRequest := TclCryptData.Create();

    pRequest.FromBytes(ARequest);

    cbStructInfo := 0;
    if not CryptDecodeObject(DefaultEncoding, X509_CERT_REQUEST_TO_BE_SIGNED,
      pRequest.Data, pRequest.DataSize, 0, nil, @cbStructInfo) then
    begin
      RaiseCryptError('CryptDecodeObject');
    end;

    GetMem(pReqInfo, cbStructInfo);
    try
      CryptDecodeObject(DefaultEncoding, X509_CERT_REQUEST_TO_BE_SIGNED,
        pRequest.Data, pRequest.DataSize, 0, pReqInfo, @cbStructInfo);

      context := nil;
      key := nil;
      try
        CreateContext(context, key);

        if not CryptVerifyCertificateSignature(context, DefaultEncoding,
          pRequest.Data, pRequest.DataSize, @pReqInfo.SubjectPublicKeyInfo) then
        begin
          RaiseCryptError('CryptVerifyCertificateSignature');
        end;

        extensions := GetExtensions();
        if (extensions <> nil) then
        begin
          Result := InternalCreateSigned(AIssuer, @pReqInfo.Subject, ASerialNumber, extensions.Extension, extensions.Count);
        end else
        begin
          reqExtensions := GetExtensionAttribute(pReqInfo);
          if (reqExtensions <> nil) then
          begin
            pReqExts := PCERT_EXTENSIONS(reqExtensions.Data);
            Result := InternalCreateSigned(AIssuer, @pReqInfo.Subject, ASerialNumber, pReqExts.rgExtension, pReqExts.cExtension);
          end else
          begin
            Result := InternalCreateSigned(AIssuer, @pReqInfo.Subject, ASerialNumber, nil, 0);
          end;
        end;
      finally
        if (key <> nil) then
        begin
          CryptDestroyKey(key);
        end;
        if (context <> nil) then
        begin
          CryptReleaseContext(context, 0);
        end;
      end;
    finally
      FreeMem(pReqInfo);
    end;
  finally
    reqExtensions.Free();
    extensions.Free();
    pRequest.Free();
  end;
end;

procedure TclCertificateStore.Install(ACertificate: TclCertificate);
var
  hStore, hPersistStore: HCERTSTORE;
begin
  hPersistStore := nil;
  hStore := FStoreHandle;
  try
    if (hStore = nil) then
    begin
      hPersistStore := CertOpenStore(CERT_STORE_PROV_SYSTEM, DefaultEncoding, nil,
        GetStoreLocationInt(StoreLocation), PWideChar(WideString(FStoreName)));
      hStore := hPersistStore;
    end;
    if (hStore = nil)
      or (not CertAddCertificateContextToStore(hStore, ACertificate.Context, CERT_STORE_ADD_NEW, nil)) then
    begin
      RaiseCryptError('CertAddCertificateContextToStore');
    end;
  finally
    if (hPersistStore <> nil) then
    begin
      CertCloseStore(hPersistStore, CERT_CLOSE_STORE_FORCE_FLAG);
    end;
  end;
end;

procedure TclCertificateStore.Uninstall(ACertificate: TclCertificate);
begin
  if not CertDeleteCertificateFromStore(CertDuplicateCertificateContext(ACertificate.Context)) then
  begin
    RaiseCryptError('CertDeleteCertificateFromStore');
  end;
end;

function TclCertificateStore.Verify(ACertificate: TclCertificate; var ATrustStatus, ATrustInfo: Integer): Boolean;
var
  hStore: HCERTSTORE;
begin
  hStore := CertOpenStore(CERT_STORE_PROV_MEMORY, 0, nil, 0, nil);
  if (hStore = nil) then
  begin
    RaiseCryptError('CertOpenStore');
  end;

  try
    GetCertificateChain(hStore, ACertificate, ATrustStatus, ATrustInfo);
    Result := (ATrustStatus = 0);
  finally
    CertCloseStore(hStore, 0);
  end;
end;

function TclCertificateStore.Verify(ACertificate: TclCertificate): Boolean;
var
  trustStatus, trustInfo: Integer;
begin
  trustStatus := 0;
  trustInfo := 0;
  Result := Verify(ACertificate, trustStatus, trustInfo);
end;

function TclCertificateStore.IsInstalled(ACertificate: TclCertificate): Boolean;
var
  cont: PCCERT_CONTEXT;
  hStore, hPersistStore: HCERTSTORE;
begin
  hPersistStore := nil;
  hStore := FStoreHandle;
  try
    if (hStore = nil) then
    begin
      hPersistStore := CertOpenStore(CERT_STORE_PROV_SYSTEM, DefaultEncoding, nil,
        GetStoreLocationInt(StoreLocation), PWideChar(WideString(FStoreName)));
      hStore := hPersistStore;
    end;
    if (hStore = nil) then
    begin
      RaiseCryptError('CertOpenStore');
    end;

    cont := CertGetSubjectCertificateFromStore(hStore, DefaultEncoding, ACertificate.Context.pCertInfo);
      
    Result := (cont <> nil);
    
    if Result then
    begin
      CertFreeCertificateContext(cont);
    end;
  finally
    if (hPersistStore <> nil) then
    begin
      CertCloseStore(hPersistStore, 0);
    end;
  end;
end;

function TclCertificateStore.KeyExists(const AName: string): Boolean;
var
  context: HCRYPTPROV;
  key: HCRYPTKEY;
begin
  context := nil;
  key := nil;
  try
    Result := CryptAcquireContext(@context, PclChar(GetTclString(AName)), GetCSP(), ProviderType, 0);
    if Result then
    begin
      Result := CryptGetUserKey(context, GetKeyTypeInt(), @key)
    end;
  finally
    if (key <> nil) then
    begin
      CryptDestroyKey(key);
    end;
    if (context <> nil) then
    begin
      CryptReleaseContext(context, 0);
    end;
  end;
end;

function TclCertificateStore.GenerateKey(AContext: HCRYPTPROV; AKeySpec: DWORD): HCRYPTKEY;
var
  flags: DWORD;
begin
  flags := (KeyLength shl $10) or 1;
  Result := nil;
  if not CryptGenKey(AContext, AKeySpec, flags, @Result) then
  begin
    RaiseCryptError('CryptGenKey');
  end;
end;

function TclCertificateStore.GenerateSubject(const ASubject: string): TclCryptData;
var
  subjSize: DWORD;
  p: PWideChar;
begin
  Result := TclCryptData.Create();
  try
    p := PWideChar(WideString(ASubject));

    if not CertStrToName(DefaultEncoding, p, CERT_X500_NAME_STR, nil, nil, @subjSize, nil) then
    begin
      RaiseCryptError('CertStrToName');
    end;
    Result.Allocate(subjSize);

    if not CertStrToName(DefaultEncoding, p, CERT_X500_NAME_STR, nil, Result.Data, @subjSize, nil) then
    begin
      RaiseCryptError('CertStrToName');
    end;
    Result.Reduce(subjSize);
  except
    Result.Free();
    raise;
  end;
end;

function TclCertificateStore.GetItems: TclCertificateList;
begin
  Result := FList;
end;

function TclCertificateStore.GetKey(const AName: string): TclCertificateKey;
begin
  Result := TclCertificateKey.Create(AName, CSP, ProviderType);
end;

procedure TclCertificateStore.GetKeyList(AList: TStrings);
var
  context: HCRYPTPROV;
  len, isFirst: DWORD;
  data: TclCryptData;
  s: TclString;
  keyName: string;
begin
  context := nil;
  try
    if not CryptAcquireContext(@context, nil, GetCSP(), ProviderType, CRYPT_VERIFYCONTEXT) then
    begin
      RaiseCryptError('CryptAcquireContext');
    end;

    AList.Clear();

    isFirst := CRYPT_FIRST;
    len := 0;
    if CryptGetProvParam(context, PP_ENUMCONTAINERS, nil, @len, isFirst) then
    begin
      data := TclCryptData.Create(len);
      try
        len := data.DataSize;
        while CryptGetProvParam(context, PP_ENUMCONTAINERS, data.Data, @len, isFirst) do
        begin
          isFirst := CRYPT_NEXT;

          s := GetTclString(PclChar(data.Data));
          keyName := string(s);

          AList.Add(keyName);
        end;
      finally
        data.Free();
      end;
    end;
  finally
    if (context <> nil) then
    begin
      CryptReleaseContext(context, 0);
    end;
  end;
end;

function TclCertificateStore.GetKeyTypeInt: Integer;
begin
  Result := clCertificateKey.GetKeyTypeInt(KeyType);
end;

function TclCertificateStore.GetSerialNumber(ASerialNumber: Integer): Integer;
begin
  Result := ASerialNumber;
  if (Result <= 0) then
  begin
    Result := Integer(GetTickCount());
  end;
end;

function TclCertificateStore.GetPublicKeyInfo(AContext: HCRYPTPROV; Alg: DWORD): TclCryptData;
var
  keyInfoSize: DWORD;
begin
  Result := TclCryptData.Create();
  try
    if not CryptExportPublicKeyInfo(AContext, Alg, DefaultEncoding,
      nil, @keyInfoSize) then
    begin
      RaiseCryptError('CryptExportPublicKeyInfo');
    end;

    Result.Allocate(keyInfoSize);
    if not CryptExportPublicKeyInfo(AContext, Alg, DefaultEncoding,
      PCERT_PUBLIC_KEY_INFO(Result.Data), @keyInfoSize) then
    begin
      RaiseCryptError('CryptExportPublicKeyInfo');
    end;
    Result.Reduce(keyInfoSize);
  except
    Result.Free();
    raise;
  end;
end;

procedure TclCertificateStore.SaveCSR(AEncodedRequest: TclByteArray;
  AStream: TStream; ABase64Encode: Boolean);
var
  buf: TclByteArray;
begin
  buf := AEncodedRequest;

  if ABase64Encode then
  begin
    buf := TclCryptEncoder.EncodeToBytes(buf, dtCertificateRequest);
  end;

  if (Length(buf) > 0) then
  begin
    AStream.Write(buf[0], Length(buf));
  end;
end;

function TclCertificateStore.SignAndEncodeCert(AContext: HCRYPTPROV; Alg: DWORD;
  ACertInfo: PCERT_INFO): TclCryptData;
var
  encodedSize: DWORD;
begin
  Result := TclCryptData.Create();
  try
    if not CryptSignAndEncodeCertificate(AContext, Alg, X509_ASN_ENCODING, X509_CERT_TO_BE_SIGNED,
      ACertInfo, @ACertInfo.SignatureAlgorithm, nil, nil, @encodedSize) then
    begin
      RaiseCryptError('CryptSignAndEncodeCertificate');
    end;

    Result.Allocate(encodedSize);

    if not CryptSignAndEncodeCertificate(AContext, Alg, X509_ASN_ENCODING, X509_CERT_TO_BE_SIGNED,
      ACertInfo, @ACertInfo.SignatureAlgorithm, nil, Result.Data, @encodedSize) then
    begin
      RaiseCryptError('CryptSignAndEncodeCertificate');
    end;

    Result.Reduce(encodedSize);
  except
    Result.Free();
    raise;
  end;
end;

function TclCertificateStore.SignAndEncodeRequest(AContext: HCRYPTPROV;
  Alg: DWORD; AReqInfo: PCERT_REQUEST_INFO; ASigAlg: PCRYPT_ALGORITHM_IDENTIFIER): TclCryptData;
var
  encodedSize: DWORD;
begin
  Result := TclCryptData.Create();
  try
    if not CryptSignAndEncodeCertificate(AContext, Alg, X509_ASN_ENCODING, X509_CERT_REQUEST_TO_BE_SIGNED,
      AReqInfo, ASigAlg, nil, nil, @encodedSize) then
    begin
      RaiseCryptError('CryptSignAndEncodeCertificate');
    end;

    Result.Allocate(encodedSize);

    if not CryptSignAndEncodeCertificate(AContext, Alg, X509_ASN_ENCODING, X509_CERT_REQUEST_TO_BE_SIGNED,
      AReqInfo, ASigAlg, nil, Result.Data, @encodedSize) then
    begin
      RaiseCryptError('CryptSignAndEncodeCertificate');
    end;

    Result.Reduce(encodedSize);
  except
    Result.Free();
    raise;
  end;
end;

function TclCertificateStore.SignCSR(AIssuer: TclCertificate;
  const ARequestFile: string; ASerialNumber: Integer): TclCertificate;
var
  stream: TStream;
begin
  stream := TFileStream.Create(ARequestFile, fmOpenRead or fmShareDenyWrite);
  try
    Result := SignCSR(AIssuer, stream, ASerialNumber);
  finally
    stream.Free();
  end;
end;

function TclCertificateStore.SignCSR(AIssuer: TclCertificate; ARequest: TStream;
  ASerialNumber: Integer): TclCertificate;
var
  buf: TclByteArray;
  len: Integer;
begin
  len := ARequest.Size - ARequest.Position;
  SetLength(buf, len);
  if (len > 0) then
  begin
    ARequest.Read(buf[0], len);
  end;

  Result := InternalSignCSR(AIssuer, TclCryptEncoder.DecodeBytes(buf), ASerialNumber);
end;

procedure TclCertificateStore.ExportToCER(ACertificate: TclCertificate;
  const AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmCreate);
  try
    ExportToCER(ACertificate, stream, True);
  finally
    stream.Free();
  end;
end;

procedure TclCertificateStore.ExportKey(const AName: string; AStream: TStream; ABase64Encode: Boolean);
var
  buf: TclByteArray;
begin
  buf := InternalExportKey(AName);

  if ABase64Encode then
  begin
    buf := TclCryptEncoder.EncodeToBytes(buf, dtRsaPrivateKey);
  end;

  if (Length(buf) > 0) then
  begin
    AStream.Write(buf[0], Length(buf));
  end;
end;

procedure TclCertificateStore.ExportKey(const AName, AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmCreate);
  try
    ExportKey(AName, stream, True);
  finally
    stream.Free();
  end;
end;

procedure TclCertificateStore.ExportToCER(ACertificate: TclCertificate;
  AStream: TStream; ABase64Encode: Boolean);
var
  buf: TclByteArray;
begin
  buf := InternalExportCER(ACertificate);

  if ABase64Encode then
  begin
    buf := TclCryptEncoder.EncodeToBytes(buf, dtCertificate);
  end;

  if (Length(buf) > 0) then
  begin
    AStream.Write(buf[0], Length(buf));
  end;
end;

procedure TclCertificateStore.ExportToPFX(ACertificate: TclCertificate;
  AStream: TStream; const APassword: string; AIncludeAll: Boolean);
var
  i, trustStatus, trustInfo: Integer;
  hStore: HCERTSTORE;
  pfxBlob: CRYPT_DATA_BLOB;
  pfx: TclCryptData;
  psw: PWideChar;
begin
  hStore := nil;
  pfx := nil;
  try
    hStore := CertOpenStore(CERT_STORE_PROV_MEMORY, 0, nil, 0, nil);
    if (hStore = nil) then
    begin
      RaiseCryptError('CertOpenStore');
    end;

    if (ACertificate <> nil) then
    begin
      if AIncludeAll then
      begin
        trustStatus := 0;
        trustInfo := 0;
        GetCertificateChain(hStore, ACertificate, trustStatus, trustInfo);
      end else
      begin
        if not CertAddCertificateContextToStore(hStore, ACertificate.Context, CERT_STORE_ADD_NEW, nil) then
        begin
          RaiseCryptError('CertAddCertificateContextToStore');
        end;
      end;
    end else
    begin
      for i := 0 to Items.Count - 1 do
      begin
        if not CertAddCertificateContextToStore(hStore, Items[i].Context, CERT_STORE_ADD_NEW, nil) then
        begin
          RaiseCryptError('CertAddCertificateContextToStore');
        end;
      end;
    end;

    pfx := TclCryptData.Create();
    pfxBlob.cbData := 0;
    pfxBlob.pbData := nil;
    psw := PWideChar(WideString(APassword));
    if not PFXExportCertStoreEx(hStore, @pfxBlob, psw, nil, EXPORT_PRIVATE_KEYS) then
    begin
      RaiseCryptError('PFXExportCertStoreEx');
    end;

    pfx.Allocate(pfxBlob.cbData);
    pfxBlob.pbData := pfx.Data;
    if not PFXExportCertStoreEx(hStore, @pfxBlob, psw, nil, EXPORT_PRIVATE_KEYS) then
    begin
      RaiseCryptError('PFXExportCertStoreEx');
    end;
    pfx.Reduce(pfxBlob.cbData);

    pfx.ToStream(AStream);
  finally
    pfx.Free();
    if (hStore <> nil) then
    begin
      CertCloseStore(hStore, 0);
    end;
  end;
end;

procedure TclCertificateStore.ExportToPFX(ACertificate: TclCertificate; const AFileName, APassword: string; AIncludeAll: Boolean);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmCreate);
  try
    ExportToPFX(ACertificate, stream, APassword, AIncludeAll);
  finally
    stream.Free();
  end;
end;

procedure TclCertificateStore.FillCertInfo(ACertInfo: PCERT_INFO; ASubject, AIssuer: PCRYPT_DATA_BLOB);
  function GetCertDate(ADate: TDateTime): TFileTime;
  var
    sDate: TSystemTime;
  begin
    DateTimeToSystemTime(LocalTimeToGlobalTime(ADate), sDate);
    SystemTimeToFileTime(sDate, Result);
  end;

begin
  ACertInfo.NotBefore := GetCertDate(ValidFrom);
  ACertInfo.NotAfter := GetCertDate(ValidTo);

  ACertInfo.Subject.cbData := ASubject.cbData;
  ACertInfo.Subject.pbData := ASubject.pbData;

  ACertInfo.Issuer.cbData := AIssuer.cbData;
  ACertInfo.Issuer.pbData := AIssuer.pbData;

  ACertInfo.dwVersion := Integer(cvVersion3);
  ACertInfo.SignatureAlgorithm.pszObjId := szOID_RSA_SHA1RSA;
end;

function TclCertificateStore.FindByEmail(const AEmail: string): TclCertificate;
begin
  Result := FindByEmail(AEmail, False);
end;

function TclCertificateStore.FindByEmail(const AEmail: string; ARequirePrivateKey: Boolean): TclCertificate;
var
  i: Integer;
begin
  for i := 0 to Items.Count -1 do
  begin
    Result := Items[i];
    if ((not ARequirePrivateKey) or (Result.PrivateKey <> ''))
      and SameText(Result.Email, AEmail) then
    begin
      Exit;
    end;
  end;
  Result := nil;
end;

function TclCertificateStore.FindByIssuedTo(const AIssuedTo: string; ARequirePrivateKey: Boolean): TclCertificate;
var
  i: Integer;
begin
  for i := 0 to Items.Count -1 do
  begin
    Result := Items[i];
    if ((not ARequirePrivateKey) or (Result.PrivateKey <> ''))
      and SameText(Result.IssuedTo, AIssuedTo) then
    begin
      Exit;
    end;
  end;
  Result := nil;
end;

function TclCertificateStore.FindBySerialNo(const ASerialNumber, AIssuer: string; ARequirePrivateKey: Boolean): TclCertificate;
var
  i: Integer;
begin
  for i := 0 to Items.Count -1 do
  begin
    Result := Items[i];
    if ((not ARequirePrivateKey) or (Result.PrivateKey <> ''))
      and ((AIssuer = '') or SameText(Result.IssuedBy, AIssuer))
      and SameText(Result.SerialNumber, ASerialNumber) then
    begin
      Exit;
    end;
  end;
  Result := nil;
end;

function TclCertificateStore.FindBySKI(const ASubjectKeyIdentifier: string): TclCertificate;
begin
  Result := FindBySKI(ASubjectKeyIdentifier, False);
end;

function TclCertificateStore.FindBySKI(const ASubjectKeyIdentifier: string; ARequirePrivateKey: Boolean): TclCertificate;
var
  i: Integer;
begin
  for i := 0 to Items.Count -1 do
  begin
    Result := Items[i];
    if ((not ARequirePrivateKey) or (Result.PrivateKey <> ''))
      and SameText(Result.SubjectKeyIdentifier, ASubjectKeyIdentifier) then
    begin
      Exit;
    end;
  end;
  Result := nil;
end;

function TclCertificateStore.FindByThumbprint(const AThumbprint: string): TclCertificate;
begin
  Result := FindByThumbprint(AThumbprint, False);
end;

function TclCertificateStore.FindByThumbprint(const AThumbprint: string; ARequirePrivateKey: Boolean): TclCertificate;
var
  i: Integer;
begin
  for i := 0 to Items.Count -1 do
  begin
    Result := Items[i];
    if ((not ARequirePrivateKey) or (Result.PrivateKey <> ''))
      and SameText(Result.Thumbprint, AThumbprint) then
    begin
      Exit;
    end;
  end;
  Result := nil;
end;

function TclCertificateStore.FindByIssuedTo(const AIssuedTo: string): TclCertificate;
begin
  Result := FindByIssuedTo(AIssuedTo, False);
end;

function TclCertificateStore.FindBySerialNo(const ASerialNumber, AIssuer: string): TclCertificate;
begin
  Result := FindBySerialNo(ASerialNumber, AIssuer, False);
end;

procedure TclCertificateStore.GetCertificateChain(hStore: HCERTSTORE; ACertificate: TclCertificate; var ATrustStatus, ATrustInfo: Integer);
const
  revFlags: array[TclRevocationFlags] of DWORD = (0, $10000000, $20000000, $40000000);
var
  pChainContext: PCCERT_CHAIN_CONTEXT;
  ChainPara: CERT_CHAIN_PARA;
  pChain: PCERT_SIMPLE_CHAIN;
  pElement: PCERT_CHAIN_ELEMENT;
  i, j: Integer;
  certInChain: TclCertificate;
  p: Pointer; 
begin
  pChainContext := nil;
  try
    ZeroMemory(@ChainPara, sizeof(ChainPara));
    ChainPara.cbSize := sizeof(ChainPara);

    if not CertGetCertificateChain(0, ACertificate.Context, nil,
      ACertificate.Context.hCertStore, @ChainPara, revFlags[CRLFlags], nil, @pChainContext) then
    begin
      RaiseCryptError('CertGetCertificateChain');
    end;

    for i := pChainContext.cChain - 1 downto 0 do
    begin
      p := Pointer(TclIntPtr(pChainContext.rgpChain) + i * SizeOf(PCERT_SIMPLE_CHAIN));
      pChain := PCERT_SIMPLE_CHAIN(p^);

      for j := pChain.cElement - 1 downto 0 do
      begin
        p := Pointer(TclIntPtr(pChain.rgpElement) + j * SizeOf(PCERT_CHAIN_ELEMENT));
        pElement := PCERT_CHAIN_ELEMENT(p^);

        if not CertAddCertificateContextToStore(hStore, pElement.pCertContext, CERT_STORE_ADD_NEW, nil) then
        begin
          RaiseCryptError('CertAddCertificateContextToStore');
        end;

        certInChain := TclCertificate.Create(pElement.pCertContext);
        try
          DoCertificateVerified(certInChain, pElement.TrustStatus.dwErrorStatus,
            pElement.TrustStatus.dwInfoStatus);
        finally
          certInChain.Free();
        end;
      end;
    end;

    ATrustStatus := pChainContext.TrustStatus.dwErrorStatus;
    ATrustInfo := pChainContext.TrustStatus.dwInfoStatus;
  finally
    if (pChainContext <> nil) then
    begin
      CertFreeCertificateChain(pChainContext);
    end;
  end;
end;

procedure TclCertificateStore.GetCertificatePrivateKey(
  ACertificate: PCCERT_CONTEXT; var AContext: HCRYPTPROV; var Alg: Integer);
var
  callerFree: BOOL;
begin
	callerFree := False;
  if not CryptAcquireCertificatePrivateKey(ACertificate, CRYPT_ACQUIRE_CACHE_FLAG, nil, @AContext, @Alg, @callerFree) then
  begin
    RaiseCryptError('CryptAcquireCertificatePrivateKey');
  end;
end;

function TclCertificateStore.GetCSP: PclChar;
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

procedure TclCertificateStore.ExportToPFX(ACertificate: TclCertificate;
  const AFileName, APassword: string);
begin
  ExportToPFX(ACertificate, AFileName, APassword, False);
end;

end.
