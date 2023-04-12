{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clDkim;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,{$IFDEF DEMO} Forms, Windows,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils,{$IFDEF DEMO} Vcl.Forms, Winapi.Windows,{$ENDIF}
{$ENDIF}
  clUtils, clHeaderFieldList, clConfig, clCryptSignature, clCryptHash, clDkimSignature,
  clDkimCanonicalizer, clEncoder, clDnsQuery, clDkimKey;

type
  TclDkimDnsRecord = class
  private
    FName: string;
    FValue: string;

    function GetRecordType: string;
  public
    constructor Create(const AName, AValue: string);

    property Name: string read FName;
    property Value: string read FValue;
    property RecordType: string read GetRecordType;
  end;

  TclDkimDnsSettings = class(TPersistent)
  private
    FServiceType: TclDkimKeyServiceTypes;
    FNotes: string;
    FAcceptableHashAlgorithms: TStrings;
    FFlags: TclDkimKeyFlags;

    procedure SetAcceptableHashAlgorithms(const Value: TStrings);
  public
    constructor Create;
    destructor Destroy; override;
  published
    property AcceptableHashAlgorithms: TStrings read FAcceptableHashAlgorithms write SetAcceptableHashAlgorithms;
    property Notes: string read FNotes write FNotes;
    property ServiceType: TclDkimKeyServiceTypes read FServiceType write FServiceType;
    property Flags: TclDkimKeyFlags read FFlags write FFlags;
  end;

  TclDkimVerifyMode = (dvmVerifyUntilFail, dvmVerifyUntilSuccess, dvmVerifyAll);

  TclDkimGetPublicKeyEvent = procedure (Sender: TObject; ASignature: TclDkimSignature; var AKey: TclByteArray) of object;

  TclDkimKeyEvent = procedure (Sender: TObject; ASignature: TclDkimSignature; AKey: TclDkimKey) of object;

  TclDkimVerifyEvent = procedure (Sender: TObject; ASignature: TclDkimSignature; AMessage: TStrings;
    AVerifyStatus: TclDkimSignatureVerifyStatus) of object;

  TclDkimSignEvent = procedure (Sender: TObject; ASignature: TclDkimSignature; AMessage: TStrings) of object;

  TclDkim = class(TComponent)
  private
    FSignatureTimestamp: TDateTime;
    FDomain: string;
    FUserIdentity: string;
    FBodyLength: Integer;
    FSignatures: TclDkimSignatureList;
    FPublicKeyLocation: string;
    FSignatureAlgorithm: string;
    FCopiedHeaderFields: TStrings;
    FSignatureExpiration: TDateTime;
    FSignedHeaderFields: TStrings;
    FCanonicalization: string;
    FSelector: string;
    FConfig: TclConfig;
    FCharsPerLine: Integer;
    FVerifyMode: TclDkimVerifyMode;

    FKey: TclRsaKey;

    FDnsSettings: TclDkimDnsSettings;
    FDnsRecord: TclDkimDnsRecord;
    FDns: TclDnsQuery;

    FOnGetPublicKey: TclDkimGetPublicKeyEvent;
    FOnVerify: TclDkimVerifyEvent;
    FOnSign: TclDkimSignEvent;
    FOnKeyReceived: TclDkimKeyEvent;
    FOnKeyRevoked: TclDkimKeyEvent;

    procedure SetCopiedHeaderFields(const Value: TStrings);
    procedure SetSignedHeaderFields(const Value: TStrings);
    procedure GetCopiedHeaderField(AFieldList: TclHeaderFieldList; const AName: string; AHeaderFields: TStrings);
    procedure SetDnsSettings(const Value: TclDkimDnsSettings);
    function SetDnsRecord(ARecord: TclDkimDnsRecord): TclDkimDnsRecord;
    procedure VerifySignatureValue(ASignature: TclDkimSignature; AFieldList: TclHeaderFieldList; AFieldIndex: Integer);
    procedure VerifySignatureValueByKey(ASignature: TclDkimSignature; const AKey: TclByteArray;
      AFieldList: TclHeaderFieldList; AFieldIndex: Integer);
    procedure VerifyBodyHash(ASignature: TclDkimSignature; AFieldList: TclHeaderFieldList);
    procedure GetPublicKeyFromDns(ASignature: TclDkimSignature; AKeyList: TclDkimKeyList);
  protected
    function GetDnsRecordName(const ASelector, ADomain: string): string;
    procedure BuildCopiedHeaderFields(AMessage, AHeaderFields: TStrings);
    function CalculateBodyHash(AMessage: TStrings; ASignature: TclDkimSignature): TclByteArray;
    function CalculateSignature(ASigner: TclSignatureRsa; AMessage: TStrings; ASignature: TclDkimSignature): TclByteArray;
    procedure VerifySignature(AFieldList: TclHeaderFieldList; AFieldIndex: Integer);
    function GetPublicKey(ASignature: TclDkimSignature): TclDkimKeyList;
    function InternalGenerateDnsRecord(const AKey: TclByteArray): TclDkimDnsRecord;

    function GetConfig: TclConfig;
    function GetKey: TclRsaKey;

    function CreateSigner: TclSignatureRsa;
    function CreateHash(const Algorithm: string): TclHash;
    function CreateCanonicalizer(const Algorithm: string): TclDkimCanonicalizer;
    function CreateVerifier(const Algorithm: string): TclSignatureRsa;

    function CreateConfig: TclConfig; virtual;
    procedure AddSignedHeaderFields; virtual;
    function AddSignature: TclDkimSignature; virtual;

    procedure DoGetPublicKey(ASignature: TclDkimSignature; var AKey: TclByteArray); virtual;
    procedure DoVerify(ASignature: TclDkimSignature; AMessage: TStrings; AVerifyStatus: TclDkimSignatureVerifyStatus); virtual;
    procedure DoSign(ASignature: TclDkimSignature; AMessage: TStrings); virtual;
    procedure DoKeyReceived(ASignature: TclDkimSignature; AKey: TclDkimKey); virtual;
    procedure DoKeyRevoked(ASignature: TclDkimSignature; AKey: TclDkimKey); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Sign(AMessage: TStrings); virtual;
    procedure Verify(AMessage: TStrings); virtual;

    procedure ImportPrivateKey(const AKey: TclByteArray); overload;
    procedure ImportPrivateKey(AStream: TStream); overload;
    procedure ImportPrivateKey(AStrings: TStrings); overload;
    procedure ImportPrivateKey(const AFileName: string); overload;

    function ExportPrivateKey: TclByteArray; overload;
    procedure ExportPrivateKey(AStream: TStream); overload;
    procedure ExportPrivateKey(AStrings: TStrings); overload;
    procedure ExportPrivateKey(const AFileName: string); overload;

    function ExportPublicKey: TclByteArray; overload;
    procedure ExportPublicKey(AStream: TStream); overload;
    procedure ExportPublicKey(AStrings: TStrings); overload;
    procedure ExportPublicKey(const AFileName: string); overload;

    procedure Close;
    procedure GenerateSigningKey(AKeyLength: Integer = 1024);

    function GenerateDnsRecord: TclDkimDnsRecord; overload;
    function GenerateDnsRecord(const AKey: TclByteArray): TclDkimDnsRecord; overload;
    function GenerateDnsRecord(AKey: TStream): TclDkimDnsRecord; overload;
    function GenerateDnsRecord(AKey: TStrings): TclDkimDnsRecord; overload;
    function GenerateDnsRecord(const AKeyFileName: string): TclDkimDnsRecord; overload;

    function GenerateDnsRevokeKeyRecord: TclDkimDnsRecord;

    property Dns: TclDnsQuery read FDns;
    property DnsRecord: TclDkimDnsRecord read FDnsRecord;
    property Signatures: TclDkimSignatureList read FSignatures;

    property Config: TclConfig read FConfig;
  published
    property DnsSettings: TclDkimDnsSettings read FDnsSettings write SetDnsSettings;

    property SignatureAlgorithm: string read FSignatureAlgorithm write FSignatureAlgorithm;
    property Canonicalization: string read FCanonicalization write FCanonicalization;
    property Domain: string read FDomain write FDomain;
    property Selector: string read FSelector write FSelector;
    property SignedHeaderFields: TStrings read FSignedHeaderFields write SetSignedHeaderFields;

    property BodyLength: Integer read FBodyLength write FBodyLength default 0;
    property UserIdentity: string read FUserIdentity write FUserIdentity;
    property PublicKeyLocation: string read FPublicKeyLocation write FPublicKeyLocation;
    property SignatureTimestamp: TDateTime read FSignatureTimestamp write FSignatureTimestamp;
    property SignatureExpiration: TDateTime read FSignatureExpiration write FSignatureExpiration;
    property CopiedHeaderFields: TStrings read FCopiedHeaderFields write SetCopiedHeaderFields;

    property CharsPerLine: Integer read FCharsPerLine write FCharsPerLine default DefaultCharsPerLine;
    property VerifyMode: TclDkimVerifyMode read FVerifyMode write FVerifyMode default dvmVerifyUntilFail;

    property OnGetPublicKey: TclDkimGetPublicKeyEvent read FOnGetPublicKey write FOnGetPublicKey;
    property OnVerify: TclDkimVerifyEvent read FOnVerify write FOnVerify;
    property OnSign: TclDkimSignEvent read FOnSign write FOnSign;
    property OnKeyReceived: TclDkimKeyEvent read FOnKeyReceived write FOnKeyReceived;
    property OnKeyRevoked: TclDkimKeyEvent read FOnKeyRevoked write FOnKeyRevoked;
  end;

const
  cDkimDnsKeyNamespace = '_domainkey';

implementation

uses
  clDkimConfig, clDkimUtils, clCryptAPI, clCryptUtils, clCryptEncoder, clTranslator, clDnsMessage
  {$IFDEF DEMO}, clCertificate, clMailMessage, clSmtp, clPop3{$ENDIF};

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

{ TclDkim }

procedure TclDkim.Close;
begin
  FreeAndNil(FKey);
  FreeAndNil(FDnsRecord);

  Signatures.Clear();
end;

function TclDkim.AddSignature: TclDkimSignature;
begin
  Result := FSignatures.Add(TclDkimSignature.Create());

  Result.Version := 1;
  Result.SignatureAlgorithm := SignatureAlgorithm;
  Result.Canonicalization := Canonicalization;
  Result.Domain := Domain;
  Result.Selector := Selector;
  Result.SignedHeaderFields := SignedHeaderFields;

  Result.BodyLength := BodyLength;
  Result.UserIdentity := UserIdentity;
  Result.PublicKeyLocation := PublicKeyLocation;
  Result.SignatureTimestamp := SignatureTimestamp;
  Result.SignatureExpiration := SignatureExpiration;
end;

procedure TclDkim.AddSignedHeaderFields;
begin
  FSignedHeaderFields.Clear();
  FSignedHeaderFields.Add('Date');
  FSignedHeaderFields.Add('From');
  FSignedHeaderFields.Add('To');
  FSignedHeaderFields.Add('Subject');
  FSignedHeaderFields.Add('MIME-Version');
  FSignedHeaderFields.Add('Content-Type');
end;

constructor TclDkim.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDns := TclDnsQuery.Create(nil);
  FDns.IsRecursiveDesired := True;

  FDnsSettings := TclDkimDnsSettings.Create();
  FSignatures := TclDkimSignatureList.Create();
  FSignedHeaderFields := TStringList.Create();
  FCopiedHeaderFields := TStringList.Create();

  FSignatureAlgorithm := 'rsa-sha256';
  FCanonicalization := '';
  FDomain := '';
  FSelector := '';

  AddSignedHeaderFields();

  FBodyLength := 0;
  FUserIdentity := '';
  FPublicKeyLocation := 'dns/txt';
  FSignatureTimestamp := 0;
  FSignatureExpiration := 0;

  FCharsPerLine := DefaultCharsPerLine;
  FVerifyMode := dvmVerifyUntilFail;

  FConfig := nil;
  FKey := nil;
  FDnsRecord := nil;
end;

function TclDkim.CreateConfig: TclConfig;
begin
  Result := TclDkimConfig.Create();
end;

destructor TclDkim.Destroy;
begin
  Close();

  FConfig.Free();
  FCopiedHeaderFields.Free();
  FSignedHeaderFields.Free();
  FSignatures.Free();
  FDnsSettings.Free();
  FDns.Free();

  inherited Destroy();
end;

function TclDkim.GetDnsRecordName(const ASelector, ADomain: string): string;
begin
  Result := ASelector + '.' + cDkimDnsKeyNamespace + '.' + ADomain;
end;

function TclDkim.GenerateDnsRecord(const AKey: TclByteArray): TclDkimDnsRecord;
begin
  if (AKey = nil) or (Length(AKey) = 0) then
  begin
    raise EclDkimError.Create(DkimKeyRequired, DkimKeyRequiredCode);
  end;

  Result := InternalGenerateDnsRecord(AKey);
end;

function TclDkim.GenerateDnsRecord: TclDkimDnsRecord;
begin
  Result := GenerateDnsRecord(GetKey().GetPublicKeyInfo());
end;

function TclDkim.GenerateDnsRecord(AKey: TStream): TclDkimDnsRecord;
var
  buf: TclByteArray;
  len: Integer;
begin
  len := Integer(AKey.Size - AKey.Position);
  if (len <= 0) then
  begin
    raise EclDkimError.Create(DkimKeyRequired, DkimKeyRequiredCode);
  end;

  SetLength(buf, len);
  AKey.Read(buf[0], Length(buf));
  Result := GenerateDnsRecord(TclCryptEncoder.DecodeString(TclTranslator.GetString(buf)));
end;

function TclDkim.GenerateDnsRecord(const AKeyFileName: string): TclDkimDnsRecord;
var
  stream: TStream;
begin
  stream := TFileStream.Create(AKeyFileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := GenerateDnsRecord(stream);
  finally
    stream.Free();
  end;
end;

function TclDkim.GenerateDnsRecord(AKey: TStrings): TclDkimDnsRecord;
var
  stream: TStream;
begin
  stream := TMemoryStream.Create();
  try
    AKey.SaveToStream(stream);
    stream.Position := 0;
    Result := GenerateDnsRecord(stream);
  finally
    stream.Free();
  end;
end;

function TclDkim.GenerateDnsRevokeKeyRecord: TclDkimDnsRecord;
begin
  Result := InternalGenerateDnsRecord(nil);
end;

procedure TclDkim.GenerateSigningKey(AKeyLength: Integer);
var
  key: TclRsaKey;
begin
  Close();

  key := GetKey();
  key.KeyLength := AKeyLength;
  key.KeyType := AT_KEYEXCHANGE;

  key.GenerateKey();
end;

function TclDkim.GetConfig: TclConfig;
begin
  if (FConfig = nil) then
  begin
    FConfig := CreateConfig();
  end;
  Result := FConfig;
end;

procedure TclDkim.GetCopiedHeaderField(AFieldList: TclHeaderFieldList; const AName: string; AHeaderFields: TStrings);
var
  i, ind: Integer;
begin
  ind := AFieldList.GetFieldIndex(AName);
  if (ind < 0) then Exit;

  for i := AFieldList.GetFieldStart(ind) to AFieldList.GetFieldEnd(ind) do
  begin
    AHeaderFields.Add(AFieldList.Source[i]);
  end;
end;

procedure TclDkim.BuildCopiedHeaderFields(AMessage, AHeaderFields: TStrings);
var
  i: Integer;
  fieldList: TclHeaderFieldList;
begin
  fieldList := TclDkimHeaderFieldList.Create();
  try
    fieldList.Parse(0, AMessage);

    AHeaderFields.Clear();

    for i := 0 to CopiedHeaderFields.Count - 1 do
    begin
      GetCopiedHeaderField(fieldList, CopiedHeaderFields[i], AHeaderFields);
    end;
  finally
    fieldList.Free();
  end;
end;

function TclDkim.CreateHash(const Algorithm: string): TclHash;
begin
  Result := GetConfig().CreateInstance(Algorithm) as TclHash;
end;

function TclDkim.CreateVerifier(const Algorithm: string): TclSignatureRsa;
begin
  Result := GetConfig().CreateInstance(Algorithm) as TclSignatureRsa;
end;

function TclDkim.CreateCanonicalizer(const Algorithm: string): TclDkimCanonicalizer;
begin
  Result := GetConfig().CreateInstance(Algorithm) as TclDkimCanonicalizer;
end;

function TclDkim.GetKey: TclRsaKey;
begin
  if (FKey = nil) then
  begin
    FKey := GetConfig().CreateInstance('rsa') as TclRsaKey;
    FKey.Init();
  end;
  Result := FKey;
end;

function TclDkim.CreateSigner: TclSignatureRsa;
begin
  Result := GetConfig().CreateInstance(SignatureAlgorithm) as TclSignatureRsa;
end;

procedure TclDkim.ImportPrivateKey(const AKey: TclByteArray);
begin
  Close();
  GetKey().SetRsaPrivateKey(AKey);
end;

procedure TclDkim.ImportPrivateKey(const AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    ImportPrivateKey(stream);
  finally
    stream.Free();
  end;
end;

procedure TclDkim.ImportPrivateKey(AStrings: TStrings);
var
  stream: TStream;
begin
  stream := TMemoryStream.Create();
  try
    AStrings.SaveToStream(stream);
    stream.Position := 0;
    ImportPrivateKey(stream);
  finally
    stream.Free();
  end;
end;

function TclDkim.InternalGenerateDnsRecord(const AKey: TclByteArray): TclDkimDnsRecord;
var
  dkimKey: TclDkimKey;
begin
  if (Selector = '') then
  begin
    raise EclDkimError.Create(DkimSelectorRequired, DkimSelectorRequiredCode);
  end;

  if (Domain = '') then
  begin
    raise EclDkimError.Create(DkimDomainRequired, DkimDomainRequiredCode);
  end;

  dkimKey := TclDkimKey.Create();
  try
    dkimKey.Version := 'DKIM1';
    dkimKey.KeyType := 'rsa';

    dkimKey.AcceptableHashAlgorithms := DnsSettings.AcceptableHashAlgorithms;
    dkimKey.Notes := DnsSettings.Notes;
    dkimKey.ServiceType := DnsSettings.ServiceType;
    dkimKey.Flags := DnsSettings.Flags;

    if (AKey <> nil) and (Length(AKey) > 0) then
    begin
      dkimKey.PublicKey := TclEncoder.EncodeBytesToString(AKey, cmBase64);
    end;

    Result := SetDnsRecord(TclDkimDnsRecord.Create(GetDnsRecordName(Selector, Domain), dkimKey.Build()));
  finally
    dkimKey.Free();
  end;
end;

procedure TclDkim.ImportPrivateKey(AStream: TStream);
var
  buf: TclByteArray;
  len: Integer;
begin
  len := Integer(AStream.Size - AStream.Position);
  if (len > 0) then
  begin
    SetLength(buf, len);
    AStream.Read(buf[0], Length(buf));
    ImportPrivateKey(TclCryptEncoder.DecodeString(TclTranslator.GetString(buf)));
  end;
end;

function TclDkim.ExportPrivateKey: TclByteArray;
begin
  Result := GetKey().GetRsaPrivateKey();
end;

function TclDkim.ExportPublicKey: TclByteArray;
begin
  Result := GetKey().GetPublicKeyInfo();
end;

procedure TclDkim.SetCopiedHeaderFields(const Value: TStrings);
begin
  FCopiedHeaderFields.Assign(Value);
end;

function TclDkim.SetDnsRecord(ARecord: TclDkimDnsRecord): TclDkimDnsRecord;
begin
  FreeAndNil(FDnsRecord);
  FDnsRecord := ARecord;
  Result := FDnsRecord;
end;

procedure TclDkim.SetDnsSettings(const Value: TclDkimDnsSettings);
begin
  FDnsSettings.Assign(Value);
end;

procedure TclDkim.SetSignedHeaderFields(const Value: TStrings);
begin
  FSignedHeaderFields.Assign(Value);
end;

function TclDkim.CalculateBodyHash(AMessage: TStrings; ASignature: TclDkimSignature): TclByteArray;
var
  hash: TclHash;
  canon: TclDkimCanonicalizer;
  buf: TclByteArray;
  canonicalBody: string;
begin
  hash := nil;
  canon := nil;
  try
    hash := CreateHash(ASignature.HashAlgorithm);
    hash.Init();

    canon := CreateCanonicalizer(ASignature.BodyCanonicalization);

    canonicalBody := canon.CanonicalizeBody(AMessage);

    if (ASignature.BodyLength > 0) then
    begin
      canonicalBody := System.Copy(canonicalBody, 1, ASignature.BodyLength);
    end;

    buf := TclTranslator.GetBytes(canonicalBody, 'us-ascii');
    hash.Update(buf, 0, Length(buf)); //TODO make a loop with small buffer

    Result := hash.Digest();
  finally
    canon.Free();
    hash.Free();
  end;
end;

function TclDkim.CalculateSignature(ASigner: TclSignatureRsa; AMessage: TStrings; ASignature: TclDkimSignature): TclByteArray;
var
  canon: TclDkimCanonicalizer;
  buf: TclByteArray;
  canonlicalHeader: string;
begin
  canon := CreateCanonicalizer(ASignature.HeaderCanonicalization);
  try
    canonlicalHeader := canon.CanonicalizeHeader(AMessage, ASignature.SignedHeaderFields);
    buf := TclTranslator.GetBytes(canonlicalHeader, 'us-ascii');
    ASigner.Update(buf, 0, Length(buf));

    canonlicalHeader := canon.CanonicalizeHeader(AMessage, cDkimSignatureField);
    canonlicalHeader := Trim(canonlicalHeader);
    buf := TclTranslator.GetBytes(canonlicalHeader, 'us-ascii');
    ASigner.Update(buf, 0, Length(buf));

    Result := ASigner.Sign();
  finally
    canon.Free();
  end;
end;

procedure TclDkim.DoSign(ASignature: TclDkimSignature; AMessage: TStrings);
begin
  if Assigned(OnSign) then
  begin
    OnSign(Self, ASignature, AMessage);
  end;
end;

procedure TclDkim.Sign(AMessage: TStrings);
var
  sig: TclDkimSignature;
  signer: TclSignatureRsa;
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
    if (not IsDemoDisplayed)
      and (not IsSmtpDemoDisplayed) and (not IsEncoderDemoDisplayed)
      and (not IsCertDemoDisplayed) and (not IsMailMessageDemoDisplayed)
      and (not IsDnsDemoDisplayed) and (not IsPop3DemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsDemoDisplayed := True;
    IsSmtpDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsMailMessageDemoDisplayed := True;
    IsDnsDemoDisplayed := True;
    IsPop3DemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  signer := CreateSigner();
  try
    signer.Init();
    signer.SetPrivateKey(GetKey());

    FSignatures.Clear();
    sig := AddSignature();

    BuildCopiedHeaderFields(AMessage, sig.CopiedHeaderFields);

    sig.BodyHash := TclEncoder.EncodeBytesToString(CalculateBodyHash(AMessage, sig), cmBase64);

    sig.Build(AMessage, CharsPerLine);

    sig.Signature := TclEncoder.EncodeBytesToString(CalculateSignature(signer, AMessage, sig), cmBase64);

    sig.AssignSignature(AMessage, CharsPerLine);

    DoSign(sig, AMessage);
  finally
    signer.Free();
  end;
end;

procedure TclDkim.DoGetPublicKey(ASignature: TclDkimSignature; var AKey: TclByteArray);
begin
  if Assigned(OnGetPublicKey) then
  begin
    OnGetPublicKey(Self, ASignature, AKey);
  end;
end;

procedure TclDkim.DoKeyReceived(ASignature: TclDkimSignature; AKey: TclDkimKey);
begin
  if Assigned(OnKeyReceived) then
  begin
    OnKeyReceived(Self, ASignature, AKey);
  end;
end;

procedure TclDkim.DoKeyRevoked(ASignature: TclDkimSignature; AKey: TclDkimKey);
begin
  if Assigned(OnKeyRevoked) then
  begin
    OnKeyRevoked(Self, ASignature, AKey);
  end;
end;

procedure TclDkim.GetPublicKeyFromDns(ASignature: TclDkimSignature; AKeyList: TclDkimKeyList);
var
  i: Integer;
begin
  Dns.ResolveTXT(GetDnsRecordName(ASignature.Selector, ASignature.Domain));

  for i := 0 to Dns.Response.Answers.Count - 1 do
  begin
    if (Dns.Response.Answers[i] is TclDnsTXTRecord) then
    begin
      AKeyList.Add(TclDkimKey.Create()).Parse(TclDnsTXTRecord(Dns.Response.Answers[i]).Text);
    end;
  end;
end;

function TclDkim.GetPublicKey(ASignature: TclDkimSignature): TclDkimKeyList;
var
  key: TclByteArray;
begin
  Result := TclDkimKeyList.Create();
  try
    key := nil;
    DoGetPublicKey(ASignature, key);

    if (key <> nil) then
    begin
      Result.Add(TclDkimKey.Create()).PublicKey := TclEncoder.EncodeBytes(key, cmBase64);
    end else
    begin
      GetPublicKeyFromDns(ASignature, Result);
    end;
  except
    Result.Free();
    raise;
  end;
end;

procedure TclDkim.DoVerify(ASignature: TclDkimSignature; AMessage: TStrings; AVerifyStatus: TclDkimSignatureVerifyStatus);
begin
  if Assigned(OnVerify) then
  begin
    OnVerify(Self, ASignature, AMessage, AVerifyStatus);
  end;
end;

procedure TclDkim.VerifyBodyHash(ASignature: TclDkimSignature; AFieldList: TclHeaderFieldList);
begin
  if not ByteArrayEquals(CalculateBodyHash(AFieldList.Source, ASignature), TclEncoder.DecodeBytes(ASignature.BodyHash, cmBase64)) then
  begin
    raise EclDkimError.Create(DkimVerifyBodyHashFailed, DkimVerifyBodyHashFailedCode);
  end;
end;

procedure TclDkim.VerifySignatureValueByKey(ASignature: TclDkimSignature; const AKey: TclByteArray;
  AFieldList: TclHeaderFieldList; AFieldIndex: Integer);
var
  key: TclRsaKey;
  verifier: TclSignatureRsa;
  canon: TclDkimCanonicalizer;
  buf: TclByteArray;
  sigField: TStrings;
  fieldList: TclDkimHeaderFieldList;
  canonicalHeader, s, sigValueFieldItem: string;
begin
  key := nil;
  verifier := nil;
  canon := nil;
  sigField := nil;
  fieldList := nil;
  try
    key := GetConfig().CreateInstance('rsa') as TclRsaKey;
    key.Init();
    key.SetPublicKeyInfo(AKey);

    verifier := CreateVerifier(ASignature.SignatureAlgorithm);
    verifier.Init();
    verifier.SetPublicKey(key);

    canon := CreateCanonicalizer(ASignature.HeaderCanonicalization);

    canonicalHeader := canon.CanonicalizeHeader(AFieldList.Source, ASignature.SignedHeaderFields);
    buf := TclTranslator.GetBytes(canonicalHeader, 'us-ascii');
    verifier.Update(buf, 0, Length(buf));

    sigField := TStringList.Create();
    AFieldList.GetFieldSource(AFieldIndex, sigField);

    fieldList := TclDkimHeaderFieldList.Create();
    fieldList.Parse(0, sigField);
    fieldList.ClearFieldItem(0, 'b');

    canonicalHeader := canon.CanonicalizeHeader(sigField, cDkimSignatureField);
    s := Trim(canonicalHeader);
    sigValueFieldItem := TclDkimHeaderFieldList.GetItemNameValuePair('b', '');
    if (RTextPos(sigValueFieldItem, s) = Length(s) - Length(sigValueFieldItem) + 1) then
    begin
      canonicalHeader := s;
    end;

    buf := TclTranslator.GetBytes(canonicalHeader, 'us-ascii');
    verifier.Update(buf, 0, Length(buf));

    verifier.Verify(TclEncoder.DecodeBytes(ASignature.Signature, cmBase64));
  finally
    fieldList.Free();
    sigField.Free();
    canon.Free();
    verifier.Free();
    key.Free();
  end;
end;

procedure TclDkim.VerifySignatureValue(ASignature: TclDkimSignature;
  AFieldList: TclHeaderFieldList; AFieldIndex: Integer);
var
  key: TclDkimKey;
  keyList: TclDkimKeyList;
  i: Integer;
  lastError: Exception;
begin
  keyList := GetPublicKey(ASignature);
  try
    if (keyList.Count = 0) then
    begin
      raise EclDkimError.Create(DkimKeyRequired, DkimKeyRequiredCode);
    end;

    lastError := nil;
    for i := 0 to keyList.Count - 1 do
    begin
      FreeAndNil(lastError);
      key := keyList[i];
  //TODO check DNS key flags, see section 6.1.2. of http://www.ietf.org/rfc/rfc6376.txt
      if (key.Version <> '') and (key.Version <> 'DKIM1') then
      begin
        lastError := EclDkimError.Create(DkimInvalidKey, DkimInvalidKeyCode);
      end else
      if (key.AcceptableHashAlgorithms.Count > 0) and (key.AcceptableHashAlgorithms.IndexOf(ASignature.HashAlgorithm) < 0) then
      begin
        lastError := EclDkimError.Create(DkimInvalidKey, DkimInvalidKeyCode);
      end else
      if (key.KeyType <> '') and (key.KeyType <> 'rsa') then
      begin
        lastError := EclDkimError.Create(DkimInvalidKey, DkimInvalidKeyCode);
      end else
      if (key.PublicKey = '') then
      begin
        DoKeyRevoked(ASignature, key);
        lastError := EclDkimError.Create(DkimKeyRevoked, DkimKeyRevokedCode);
      end else
      begin
        try
          VerifySignatureValueByKey(ASignature, TclEncoder.DecodeBytes(key.PublicKey, cmBase64), AFieldList, AFieldIndex);
          DoKeyReceived(ASignature, key);
          Break;
        except
          on E: EclCryptError do
          begin
            lastError := EclCryptError.Create(E.Message, E.ErrorCode);
          end;
          on E: EclDkimError do
          begin
            lastError := EclDkimError.Create(E.Message, E.ErrorCode);
          end;
          on E: Exception do
          begin
            lastError := Exception.Create(E.Message);
          end;
        end;
      end;
    end;
    if (lastError <> nil) then raise lastError;
  finally
    keyList.Free();
  end;
end;

procedure TclDkim.VerifySignature(AFieldList: TclHeaderFieldList; AFieldIndex: Integer);
var
  sig: TclDkimSignature;
begin
  sig := FSignatures.Add(TclDkimSignature.Create());
  try
    try
      sig.Parse(AFieldList.GetFieldValue(AFieldIndex));

      if (sig.Version <> 1) then
      begin
        raise EclDkimError.Create(DkimInvalidVersion, DkimInvalidVersionCode);
      end;

      VerifyBodyHash(sig, AFieldList);

      VerifySignatureValue(sig, AFieldList, AFieldIndex);

      sig.Status.SetVerified();
    except
      on E: EclCryptError do
      begin
        sig.Status.SetFailed(E.Message, E.ErrorCode);
        raise;
      end;
      on E: EclDkimError do
      begin
        sig.Status.SetFailed(E.Message, E.ErrorCode);
        raise;
      end;
      on E: Exception do
      begin
        sig.Status.SetFailed(E.Message, -1);
        raise;
      end;
    end;
  finally
    DoVerify(sig, AFieldList.Source, sig.Status);
  end;
end;

procedure TclDkim.Verify(AMessage: TStrings);
var
  i: Integer;
  fieldList: TclHeaderFieldList;
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
    if (not IsDemoDisplayed)
      and (not IsSmtpDemoDisplayed) and (not IsEncoderDemoDisplayed)
      and (not IsCertDemoDisplayed) and (not IsMailMessageDemoDisplayed)
      and (not IsDnsDemoDisplayed) and (not IsPop3DemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsDemoDisplayed := True;
    IsSmtpDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsMailMessageDemoDisplayed := True;
    IsDnsDemoDisplayed := True;
    IsPop3DemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  FSignatures.Clear();

  fieldList := TclDkimHeaderFieldList.Create();
  try
    fieldList.Parse(0, AMessage);

    for i := 0 to fieldList.FieldList.Count - 1 do
    begin
      if SameText(cDkimSignatureField, fieldList.FieldList[i]) then
      begin
        try
          VerifySignature(fieldList, i);

          if (VerifyMode = dvmVerifyUntilSuccess) then
          begin
            Break;
          end;
        except
          if (VerifyMode = dvmVerifyUntilFail) then
          begin
            raise;
          end;
        end;
      end;
    end;
  finally
    fieldList.Free();
  end;
end;

procedure TclDkim.ExportPrivateKey(AStream: TStream);
var
  pem: string;
  buf: TclByteArray;
begin
  pem := TclCryptEncoder.EncodeToString(ExportPrivateKey(), dtRsaPrivateKey);
  buf := TclTranslator.GetBytes(pem);
  if (Length(buf) > 0) then
  begin
    AStream.Write(buf[0], Length(buf));
  end;
end;

procedure TclDkim.ExportPrivateKey(const AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmCreate);
  try
    ExportPrivateKey(stream);
  finally
    stream.Free();
  end;
end;

procedure TclDkim.ExportPrivateKey(AStrings: TStrings);
var
  stream: TStream;
begin
  stream := TMemoryStream.Create();
  try
    ExportPrivateKey(stream);
    stream.Position := 0;
    AStrings.LoadFromStream(stream);
  finally
    stream.Free();
  end;
end;

procedure TclDkim.ExportPublicKey(const AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmCreate);
  try
    ExportPublicKey(stream);
  finally
    stream.Free();
  end;
end;

procedure TclDkim.ExportPublicKey(AStrings: TStrings);
var
  stream: TStream;
begin
  stream := TMemoryStream.Create();
  try
    ExportPublicKey(stream);
    stream.Position := 0;
    AStrings.LoadFromStream(stream);
  finally
    stream.Free();
  end;
end;

procedure TclDkim.ExportPublicKey(AStream: TStream);
var
  pem: string;
  buf: TclByteArray;
begin
  pem := TclCryptEncoder.EncodeToString(ExportPublicKey(), dtPublicKeyInfo);
  buf := TclTranslator.GetBytes(pem);
  if (Length(buf) > 0) then
  begin
    AStream.Write(buf[0], Length(buf));
  end;
end;

{ TclDkimDnsRecord }

constructor TclDkimDnsRecord.Create(const AName, AValue: string);
begin
  inherited Create();

  FName := AName;
  FValue := AValue;
end;

function TclDkimDnsRecord.GetRecordType: string;
begin
  Result := 'TXT';
end;

{ TclDkimDnsSettings }

constructor TclDkimDnsSettings.Create;
begin
  inherited Create();
  FAcceptableHashAlgorithms := TStringList.Create();
end;

destructor TclDkimDnsSettings.Destroy;
begin
  FAcceptableHashAlgorithms.Free();
  inherited Destroy();
end;

procedure TclDkimDnsSettings.SetAcceptableHashAlgorithms(const Value: TStrings);
begin
  FAcceptableHashAlgorithms.Assign(Value);
end;

end.
