{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSoapMessage;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Windows, Classes, SysUtils, Variants, msxml,
{$ELSE}
  Winapi.Windows, System.Classes, System.SysUtils, System.Variants, Winapi.msxml,
{$ENDIF}
  clCertificate, clCertificateStore, clCryptUtils, clHttpRequest, clCryptAPI,
  clSoapSecurity, clUtils, clHeaderFieldList, clHttpHeader, clWUtils;

type
  TclGetSoapSigningCertificateEvent = procedure (Sender: TObject; AKeyInfo: TclXmlKeyInfo; var ACertificate: TclCertificate;
    AExtraCerts: TclCertificateList; var Handled: Boolean) of object;

  TclGetSoapEncryptionCertificateEvent = procedure (Sender: TObject; AKeyInfo: TclXmlKeyInfo; var ACertificate: TclCertificate;
    AExtraCerts: TclCertificateList; var AStoreName: string; var AStoreLocation: TclCertificateStoreLocation;
    var Handled: Boolean) of object;

  TclSoapVersion = (svSoap1_1, svSoap1_2);

  TclSoapSecurityInfo = class(TCollectionItem)
  private
    FKeyReferenceID: string;
    FKeyID: string;
    FID: string;
    FKeySecurityTokenReferenceID: string;
    FKeyClassName: string;

    procedure SetID(const Value: string);
    procedure SetKeyID(const Value: string);
    procedure SetKeyReferenceID(const Value: string);
    procedure SetKeySecurityTokenReferenceID(const Value: string);
    procedure SetKeyClassName(const Value: string);
    function GetKeyClassType: TclXmlKeyInfoClass;
  protected
    procedure Update; virtual;
    function GenerateKeyReferenceID(AConfig: TclXmlSecurityConfig): string; virtual;
    procedure DoCreate; virtual;
    procedure DoPropertyChanged(Sender: TObject);
  public
    constructor Create(Collection: TCollection); override;

    procedure Assign(Source: TPersistent); override;
    procedure Clear; virtual;

    procedure AssignKeyInfo(AKeyInfo: TclXmlKeyInfo); virtual;
    function CreateKeyInfo(AConfig: TclXmlSecurityConfig): TclXmlKeyInfo; virtual;
  published
    property ID: string read FID write SetID;
    property KeyClassName: string read FKeyClassName write SetKeyClassName;
    property KeyID: string read FKeyID write SetKeyID;
    property KeySecurityTokenReferenceID: string read FKeySecurityTokenReferenceID write SetKeySecurityTokenReferenceID;
    property KeyReferenceID: string read FKeyReferenceID write SetKeyReferenceID;
  end;

  TclSoapEncryptedKeyInfo = class(TclSoapSecurityInfo)
  private
    FEncryptionMethod: string;
    FReferences: TclXmlEncryptReferenceList;
    FOnChange: TNotifyEvent;
    FOwner: TPersistent;

    procedure SetEncryptionMethod(const Value: string);
    procedure SetReferences(const Value: TclXmlEncryptReferenceList);
  protected
    function GetOwner: TPersistent; override;
    procedure Update; override;
    procedure DoCreate; override;
  public
    constructor Create(Collection: TCollection); overload; override;
    constructor Create(Collection: TCollection; AOwner: TPersistent); reintroduce; overload;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;

    procedure AssignEncryptedKeyInfo(AEncryptedKey: TclXmlEncryptedKey); virtual;
    function CreateEncryptedKey(AEncryptReferences: TclXmlEncryptReferenceList;
      AConfig: TclXmlSecurityConfig): TclXmlEncryptedKey; virtual;
  published
    property EncryptionMethod: string read FEncryptionMethod write SetEncryptionMethod;
    property References: TclXmlEncryptReferenceList read FReferences write SetReferences;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TclSoapSignatureInfo = class(TclSoapSecurityInfo)
  private
    FSignatureMethod: string;
    FCanonicalizationMethod: string;
    FReferences: TclXmlSignReferenceList;

    procedure SetCanonicalizationMethod(const Value: string);
    procedure SetSignatureMethod(const Value: string);
    procedure SetReferences(const Value: TclXmlSignReferenceList);
  protected
    procedure DoCreate; override;
  public
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;

    procedure AssignSignatureInfo(ASignature: TclXmlSignature); virtual;
    function CreateSignature(AConfig: TclXmlSecurityConfig): TclXmlSignature; virtual;
  published
    property CanonicalizationMethod: string read FCanonicalizationMethod write SetCanonicalizationMethod;
    property SignatureMethod: string read FSignatureMethod write SetSignatureMethod;
    property References: TclXmlSignReferenceList read FReferences write SetReferences;
  end;

  TclSoapSignatureList = class(TOwnedCollection)
  private
    FOnChange: TNotifyEvent;

    function GetItem(Index: Integer): TclSoapSignatureInfo;
    procedure SetItem(Index: Integer; const Value: TclSoapSignatureInfo);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add: TclSoapSignatureInfo;
    function ItemById(const AID: string): TclSoapSignatureInfo;

    property Items[Index: Integer]: TclSoapSignatureInfo read GetItem write SetItem; default;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TclSoapTimestamp = class(TPersistent)
  private
    FExpires: string;
    FCreated: string;
    FID: string;
    FConfig: TclXmlSecurityConfig;
    FOnChange: TNotifyEvent;

    procedure SetCreated(const Value: string);
    procedure SetExpires(const Value: string);
    procedure SetID(const Value: string);
  protected
    procedure Update; virtual;
  public
    constructor Create(AConfig: TclXmlSecurityConfig);
    procedure Assign(Source: TPersistent); override;
    procedure Clear; virtual;

    procedure Build(const ARoot: IXMLDOMNode); virtual;
    procedure Parse(const ASecurity: IXMLDOMNode); virtual;

    property Config: TclXmlSecurityConfig read FConfig;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  published
    property ID: string read FID write SetID;
    property Created: string read FCreated write SetCreated;
    property Expires: string read FExpires write SetExpires;
  end;

  TclSoapAddressItem = class(TCollectionItem)
  private
    FName: string;
    FID: string;
    FValue: string;

    procedure SetID(const Value: string);
    procedure SetName(const Value: string);
    procedure SetValue(const AValue: string);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Name: string read FName write SetName;
    property ID: string read FID write SetID;
    property Value: string read FValue write SetValue;
  end;

  TclSoapAddressList = class(TOwnedCollection)
  private
    FOnChange: TNotifyEvent;
    FConfig: TclXmlSecurityConfig;

    function GetItem(Index: Integer): TclSoapAddressItem;
    procedure SetItem(Index: Integer; const Value: TclSoapAddressItem);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TPersistent; ItemClass: TCollectionItemClass; AConfig: TclXmlSecurityConfig);

    function Add: TclSoapAddressItem;
    function AddItem(const AName, AID, AValue: string): TclSoapAddressItem;
    function ItemByName(const AName: string): TclSoapAddressItem;
    function ItemById(const AID: string): TclSoapAddressItem;

    procedure Build(const ARoot: IXMLDOMNode); virtual;
    procedure Parse(const ARoot: IXMLDOMNode); virtual;

    property Items[Index: Integer]: TclSoapAddressItem read GetItem write SetItem; default;
    property Config: TclXmlSecurityConfig read FConfig;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TclSoapMessageHeader = class(TclHttpRequestHeader)
  private
    FStart: string;
    FSoapAction: string;
    FSubType: string;

    procedure SetSoapAction(const Value: string);
    procedure SetStart(const Value: string);
    procedure SetSubType(const Value: string);
  protected
    procedure RegisterFields; override;
    procedure InternalParseHeader(AFieldList: TclHeaderFieldList); override;
    procedure InternalAssignHeader(AFieldList: TclHeaderFieldList); override;
    procedure ParseContentType(AFieldList: TclHeaderFieldList); override;
    procedure AssignContentType(AFieldList: TclHeaderFieldList); override;
  public
    procedure Clear; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Start: string read FStart write SetStart;
    property SubType: string read FSubType write SetSubType;
    property SoapAction: string read FSoapAction write SetSoapAction;
  end;

  TclSoapMessage = class;

  TclSoapMessageItem = class(TclHttpRequestItem)
  private
    FContentID: string;
    FContentType: string;
    FContentLocation: string;
    FContentTransferEncoding: string;
    FExtraFields: TStrings;
    FCharSet: string;
    FKnownFields: TStrings;

    procedure SetContentID(const Value: string);
    procedure SetContentLocation(const Value: string);
    procedure SetContentTransferEncoding(const Value: string);
    procedure SetContentType(const Value: string);
    procedure SetCharSet(const Value: string);
    procedure SetExtraFields(const Value: TStrings);
    procedure ListChangeEvent(Sender: TObject);
    function GetHeader: TStream;
    procedure ParseExtraFields(AFieldList: TclHeaderFieldList);
    function GetSoapMessage: TclSoapMessage;
  protected
    function GetDataStream: TStream; override;
    procedure ReadData(Reader: TReader); override;
    procedure WriteData(Writer: TWriter); override;
    procedure ParseHeader(AFieldList: TclHeaderFieldList); override;
    function GetCharSet: string; override;
    procedure RegisterField(const AField: string);
    procedure RegisterFields; virtual;
  public
    constructor Create(AOwner: TclHttpRequestItemList); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    property SoapMessage: TclSoapMessage read GetSoapMessage;
    property ContentType: string read FContentType write SetContentType;
    property CharSet: string read FCharSet write SetCharSet;
    property ContentID: string read FContentID write SetContentID;
    property ContentLocation: string read FContentLocation write SetContentLocation;
    property ContentTransferEncoding: string read FContentTransferEncoding write SetContentTransferEncoding;
    property ExtraFields: TStrings read FExtraFields write SetExtraFields;
  end;

  TclXmlItem = class(TclSoapMessageItem)
  private
    FXmlData: string;
    procedure SetXmlData(const Value: string);
  protected
    procedure ReadData(Reader: TReader); override;
    procedure WriteData(Writer: TWriter); override;
    procedure AddData(const AData: TclByteArray; AIndex, ACount: Integer); override;
    procedure AfterAddData; override;
    function GetDataStream: TStream; override;
  public
    procedure Assign(Source: TPersistent); override;

    property XmlData: string read FXmlData write SetXmlData;
  end;

  TclAttachmentItem = class(TclSoapMessageItem)
  protected
    procedure AddData(const AData: TclByteArray; AIndex, ACount: Integer); override;
    procedure AfterAddData; override;
    function GetDataStream: TStream; override;
  end;

  TclSoapMessage = class(TclHttpRequest)
  private
    FSecurityConfig: TclXmlSecurityConfig;
    FCertificates: TclCertificateStore;
    FInternalCertStore: TclCertificateStore;
    FEncodingStyle: string;
    FNamespaces: TclSoapNameSpaceList;
    FTimestamp: TclSoapTimestamp;
    FAddressing: TclSoapAddressList;
    FBodyID: string;
    FSignatures: TclSoapSignatureList;
    FEncryptedKey: TclSoapEncryptedKeyInfo;

    FOnGetEncryptionCertificate: TclGetSoapEncryptionCertificateEvent;
    FOnGetSigningCertificate: TclGetSoapSigningCertificateEvent;
    FSoapVersion: TclSoapVersion;

    procedure DoPropertyChanged(Sender: TObject);
    function GetNameSpace(ANode: IXMLDOMNode): string;
    procedure GetSigningCertificate(AKeyInfo: TclXmlKeyInfo; var ACertificate: TclCertificate;
      var AStoreName: string; var AStoreLocation: TclCertificateStoreLocation);
    procedure GetEncryptionCertificate(AKeyInfo: TclXmlKeyInfo; var ACertificate: TclCertificate;
      var AStoreName: string; var AStoreLocation: TclCertificateStoreLocation);

    procedure CheckRequestExists;
    function GetHeader: TclSoapMessageHeader;
    procedure SetHeader(const Value: TclSoapMessageHeader);
    procedure SetEncodingStyle(const Value: string);
    procedure SetNamespaces(const Value: TclSoapNameSpaceList);
    function AddWsdlEnvelope(const AMessage: string): string;
    procedure SetTimestamp(const Value: TclSoapTimestamp);
    function GetIsSecured(const ANodeName: string): Boolean;
    function GetIsSigned: Boolean;
    function GetIsEncrypted: Boolean;
    procedure SetAddressing(const Value: TclSoapAddressList);
    procedure SetBodyID(const Value: string);
    procedure SetSecurityConfig(const Value: TclXmlSecurityConfig);
    procedure SetEncryptedKey(const Value: TclSoapEncryptedKeyInfo);
    procedure SetSignatures(const Value: TclSoapSignatureList);
    procedure SetSoapVersion(const Value: TclSoapVersion);

    function GetIdName(const ANamespace: string): string;

    procedure CreateSignatures(const ADom: IXMLDOMDocument);
    procedure CreateSignature(ASignature: TclXmlSignature; const ADom: IXMLDOMDocument);
    procedure VerifySignatures(const ASecurity: IXMLDOMNode; const ADom: IXMLDOMDocument);
    procedure VerifySignature(ASignature: TclXmlSignature; const ADom: IXMLDOMDocument);
    procedure AssignBodyIdIfNeed(const ADom: IXMLDOMDocument);
    procedure ExtractBodyId(const ADom: IXMLDOMDocument);

    procedure DecryptSessionKey(ASessionKey: TclXmlEncryptedKey);
    procedure EncryptSessionKey(ASessionKey: TclXmlEncryptedKey; const ASecurity: IXMLDOMNode);

    function GetInternalCertStore: TclCertificateStore;
    procedure CheckSoapVersion;
  protected
    function ParseSoapVersion(const AEnvelope: string): TclSoapVersion; virtual;
    function CreateHeader: TclHttpRequestHeader; override;
    function CreateItem(AFieldList: TclHeaderFieldList): TclHttpRequestItem; override;
    procedure CreateSingleItem(AStream: TStream); override;
    function GetContentType: string; override;
    procedure InitHeader; override;
    procedure DoGetSigningCertificate(AKeyInfo: TclXmlKeyInfo; var ACertificate: TclCertificate; AExtraCerts: TclCertificateList; var Handled: Boolean); dynamic;
    procedure DoGetEncryptionCertificate(AKeyInfo: TclXmlKeyInfo; var ACertificate: TclCertificate; AExtraCerts: TclCertificateList;
       var AStoreName: string; var AStoreLocation: TclCertificateStoreLocation; var Handled: Boolean); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure BuildSoapMessage(const AEnvelope: string); overload;
    procedure BuildSoapMessage(const AEnvelope, ASoapAction: string); overload;

    procedure BuildSoapMessage(AEnvelope: TStrings); overload;
    procedure BuildSoapMessage(AEnvelope: TStrings; const ASoapAction: string); overload;

    procedure BuildSoapMessage(AEnvelope: IXMLDOMDocument); overload;
    procedure BuildSoapMessage(AEnvelope: IXMLDOMDocument; const ASoapAction: string); overload;

    procedure BuildSoapWSDL(const AMethodURI, AMethod: string; AParamNames, AParamValues: TStrings); overload;
    procedure BuildSoapWSDL(const AMethodURI, AMethod: string; AParamNames, AParamValues, AParamAttrs: TStrings); overload;
    procedure BuildSoapWSDL(const AMethodURI, AMethod: string; const AParamNames, AParamValues: array of string); overload;
    procedure BuildSoapWSDL(const AMethodURI, AMethod: string; const AParamNames, AParamValues, AParamAttrs: array of string); overload;

    function AddXmlData(const AXmlData: string): TclXmlItem;
    function AddAttachment: TclAttachmentItem;
    procedure Sign;
    procedure Verify;
    procedure Clear; override;
    procedure Encrypt;
    procedure Decrypt;


    property IsSigned: Boolean read GetIsSigned;
    property IsEncrypted: Boolean read GetIsEncrypted;
    property Certificates: TclCertificateStore read FCertificates;
  published
    property Header: TclSoapMessageHeader read GetHeader write SetHeader;
    property Timestamp: TclSoapTimestamp read FTimestamp write SetTimestamp;
    property Addressing: TclSoapAddressList read FAddressing write SetAddressing;
    property BodyID: string read FBodyID write SetBodyID;

    property Signatures: TclSoapSignatureList read FSignatures write SetSignatures;
    property EncryptedKey: TclSoapEncryptedKeyInfo read FEncryptedKey write SetEncryptedKey;

    property Namespaces: TclSoapNameSpaceList read FNamespaces write SetNamespaces;
    property EncodingStyle: string read FEncodingStyle write SetEncodingStyle;
    property SoapVersion: TclSoapVersion read FSoapVersion write SetSoapVersion default svSoap1_2;

    property SecurityConfig: TclXmlSecurityConfig read FSecurityConfig write SetSecurityConfig;

    property OnGetSigningCertificate: TclGetSoapSigningCertificateEvent read FOnGetSigningCertificate write FOnGetSigningCertificate;
    property OnGetEncryptionCertificate: TclGetSoapEncryptionCertificateEvent read FOnGetEncryptionCertificate write FOnGetEncryptionCertificate;
  end;

implementation

uses
{$IFNDEF DELPHIXE2}
  {$IFDEF DEMO}Forms, clEncryptor, clHtmlParser, {$ENDIF}
{$ELSE}
  {$IFDEF DEMO}Vcl.Forms, clEncryptor, clHtmlParser, {$ENDIF}
{$ENDIF}
  clEncoder, clXmlUtils, clTranslator, clStreams, clSoapUtils, clCryptRandom,
  clXmlCanonicalizer20010315Excl, clXmlCanonicalizerUtils
  {$IFDEF LOGGER}, clLogger{$ENDIF};

const
  cSoapHeaderContentType: array[TclSoapVersion] of string = ('text/xml', 'application/soap+xml');
  cEnvelopeNameSpaceName: array[TclSoapVersion] of string = (envelopeNameSpaceName, soap12NameSpaceName);

{ TclSoapSecurityInfo }

procedure TclSoapSecurityInfo.Assign(Source: TPersistent);
var
  src: TclSoapSecurityInfo;
begin
  if (Source is TclSoapSecurityInfo) then
  begin
    src := (Source as TclSoapSecurityInfo);

    KeyReferenceID := src.KeyReferenceID;
    KeyID := src.KeyID;
    ID := src.ID;
    KeySecurityTokenReferenceID := src.KeySecurityTokenReferenceID;
    KeyClassName := src.KeyClassName;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclSoapSecurityInfo.AssignKeyInfo(AKeyInfo: TclXmlKeyInfo);
begin
  if (AKeyInfo = nil) then
  begin
    KeyClassName := '';
    Exit;
  end;

  KeyID := AKeyInfo.ID;
  KeySecurityTokenReferenceID := AKeyInfo.SecurityTokenReferenceID;
  KeyClassName := AKeyInfo.ClassName;

  if (AKeyInfo is TclXmlX509KeyInfo) then
  begin
    KeyReferenceID := UriReference2Id(TclXmlX509KeyInfo(AKeyInfo).URI);
  end;
end;

procedure TclSoapSecurityInfo.Clear;
begin
  KeyReferenceID := '';
  KeyID := '';
  ID := '';
  KeySecurityTokenReferenceID := '';
  KeyClassName := '';
end;

constructor TclSoapSecurityInfo.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  DoCreate();
  Clear();
end;

function TclSoapSecurityInfo.CreateKeyInfo(AConfig: TclXmlSecurityConfig): TclXmlKeyInfo;
begin
  if (FKeyClassName = '') then
  begin
    Result := nil;
    Exit;
  end;

  Result := GetKeyClassType().Create(AConfig);

  Result.ID := KeyID;
  Result.SecurityTokenReferenceID := KeySecurityTokenReferenceID;

  if (Result is TclXmlX509KeyInfo) then
  begin
    if (KeyReferenceID = '') then
    begin
      KeyReferenceID := GenerateKeyReferenceID(AConfig);
    end;

    TclXmlX509KeyInfo(Result).URI := Id2UriReference(KeyReferenceID);
  end;
end;

procedure TclSoapSecurityInfo.DoCreate;
begin
end;

procedure TclSoapSecurityInfo.DoPropertyChanged(Sender: TObject);
begin
  Update();
end;

function TclSoapSecurityInfo.GenerateKeyReferenceID(AConfig: TclXmlSecurityConfig): string;
var
  buf: TclByteArray;
begin
  buf := GenerateRandomData(16, AConfig.CSP, AConfig.ProviderType);
  Result := 'X509-' + UpperCase(BytesToHex(buf));
end;

function TclSoapSecurityInfo.GetKeyClassType: TclXmlKeyInfoClass;
var
  i: Integer;
begin
  for i := 0 to TclXmlKeyInfo.RegisteredKeyInfo.Count - 1 do
  begin
    Result := TclXmlKeyInfoClass(TclXmlKeyInfo.RegisteredKeyInfo[i]);
    if (FKeyClassName = Result.ClassName) then
    begin
      Exit;
    end;
  end;
  raise EclSoapMessageError.Create(SoapUnknownKeyClassType, SoapUnknownKeyClassTypeCode);
end;

procedure TclSoapSecurityInfo.SetID(const Value: string);
begin
  if (FID <> Value) then
  begin
    FID := Value;
    Update();
  end;
end;

procedure TclSoapSecurityInfo.SetKeyClassName(const Value: string);
begin
  if (FKeyClassName <> Value) then
  begin
    FKeyClassName := Value;
    Update();
  end;
end;

procedure TclSoapSecurityInfo.SetKeyID(const Value: string);
begin
  if (FKeyID <> Value) then
  begin
    FKeyID := Value;
    Update();
  end;
end;

procedure TclSoapSecurityInfo.SetKeyReferenceID(const Value: string);
begin
  if (FKeyReferenceID <> Value) then
  begin
    FKeyReferenceID := Value;
    Update();
  end;
end;

procedure TclSoapSecurityInfo.SetKeySecurityTokenReferenceID(const Value: string);
begin
  if (FKeySecurityTokenReferenceID <> Value) then
  begin
    FKeySecurityTokenReferenceID := Value;
    Update();
  end;
end;

procedure TclSoapSecurityInfo.Update;
begin
  Changed(False);
end;

{ TclSoapEncryptedKeyInfo }

procedure TclSoapEncryptedKeyInfo.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if (Source is TclSoapEncryptedKeyInfo) then
  begin
    EncryptionMethod := (Source as TclSoapEncryptedKeyInfo).EncryptionMethod;
    References := (Source as TclSoapEncryptedKeyInfo).References;
  end;
end;

procedure TclSoapEncryptedKeyInfo.AssignEncryptedKeyInfo(AEncryptedKey: TclXmlEncryptedKey);
begin
  Clear();

  ID := AEncryptedKey.ID;
  EncryptionMethod := AEncryptedKey.EncryptionMethod;
  References := AEncryptedKey.ReferenceList;
  AssignKeyInfo(AEncryptedKey.KeyInfo);
end;

procedure TclSoapEncryptedKeyInfo.Clear;
begin
  inherited Clear();

  KeyClassName := TclXmlSKIKeyInfo.ClassName;
  EncryptionMethod := RSA_OAEP_MGF1P_AlgorithmName;
  References.Clear();
end;

constructor TclSoapEncryptedKeyInfo.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FOwner := nil;
end;

constructor TclSoapEncryptedKeyInfo.Create(Collection: TCollection; AOwner: TPersistent);
begin
  inherited Create(Collection);
  FOwner := AOwner;
end;

function TclSoapEncryptedKeyInfo.CreateEncryptedKey(AEncryptReferences: TclXmlEncryptReferenceList;
  AConfig: TclXmlSecurityConfig): TclXmlEncryptedKey;
begin
  Result := TclXmlEncryptedKey.CreateInstance(EncryptionMethod, AEncryptReferences, AConfig);
  try
    Result.ID := ID;
    Result.EncryptionMethod := EncryptionMethod;

    Result.KeyInfo := CreateKeyInfo(AConfig);
  except
    Result.Free();
    raise;
  end;
end;

destructor TclSoapEncryptedKeyInfo.Destroy;
begin
  FReferences.Free();
  inherited Destroy();
end;

procedure TclSoapEncryptedKeyInfo.DoCreate;
begin
  inherited DoCreate();

  FReferences := TclXmlEncryptReferenceList.Create(Self, TclXmlEncryptReference);
  FReferences.OnChange := DoPropertyChanged;
end;

function TclSoapEncryptedKeyInfo.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TclSoapEncryptedKeyInfo.SetEncryptionMethod(const Value: string);
begin
  if (FEncryptionMethod <> Value) then
  begin
    FEncryptionMethod := Value;
    Update();
  end;
end;

procedure TclSoapEncryptedKeyInfo.SetReferences(const Value: TclXmlEncryptReferenceList);
begin
  FReferences.Assign(Value);
end;

procedure TclSoapEncryptedKeyInfo.Update;
begin
  inherited Update();

  if Assigned(OnChange) then
  begin
    OnChange(Self);
  end;
end;

{ TclSoapSignatureInfo }

procedure TclSoapSignatureInfo.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if (Source is TclSoapSignatureInfo) then
  begin
    CanonicalizationMethod := (Source as TclSoapSignatureInfo).CanonicalizationMethod;
    SignatureMethod := (Source as TclSoapSignatureInfo).SignatureMethod;
    References := (Source as TclSoapSignatureInfo).References;
  end;
end;

procedure TclSoapSignatureInfo.AssignSignatureInfo(ASignature: TclXmlSignature);
begin
  Clear();

  ID := ASignature.ID;
  SignatureMethod := ASignature.SignatureMethod;
  CanonicalizationMethod := ASignature.CanonicalizationMethod;
  References := ASignature.ReferenceList;
  AssignKeyInfo(ASignature.KeyInfo);
end;

procedure TclSoapSignatureInfo.Clear;
begin
  inherited Clear();

  KeyClassName := TclXmlX509KeyInfo.ClassName;
  CanonicalizationMethod := ALGO_ID_C14N_EXCL_OMIT_COMMENTS;
  SignatureMethod := RSA_SHA1_AlgorithmName;
  References.Clear();
end;

function TclSoapSignatureInfo.CreateSignature(AConfig: TclXmlSecurityConfig): TclXmlSignature;
begin
  Result := TclXmlSignature.CreateInstance(SignatureMethod, References, AConfig);
  try
    Result.ID := ID;
    Result.CanonicalizationMethod := CanonicalizationMethod;

    Result.KeyInfo := CreateKeyInfo(AConfig);
  except
    Result.Free();
    raise;
  end;
end;

destructor TclSoapSignatureInfo.Destroy;
begin
  FReferences.Free();
  inherited Destroy();
end;

procedure TclSoapSignatureInfo.DoCreate;
begin
  inherited DoCreate();

  FReferences := TclXmlSignReferenceList.Create(Self, TclXmlSignReference);
  FReferences.OnChange := DoPropertyChanged;
end;

procedure TclSoapSignatureInfo.SetCanonicalizationMethod(const Value: string);
begin
  if (FCanonicalizationMethod <> Value) then
  begin
    FCanonicalizationMethod := Value;
    Update();
  end;
end;

procedure TclSoapSignatureInfo.SetReferences(const Value: TclXmlSignReferenceList);
begin
  FReferences.Assign(Value);
end;

procedure TclSoapSignatureInfo.SetSignatureMethod(const Value: string);
begin
  if (FSignatureMethod <> Value) then
  begin
    FSignatureMethod := Value;
    Update();
  end;
end;

{ TclSoapMessage }

procedure TclSoapMessage.BuildSoapMessage(AEnvelope: TStrings; const ASoapAction: string);
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
    if (not IsHttpRequestDemoDisplayed) and (not IsCertDemoDisplayed)
      and (not IsEncoderDemoDisplayed) and (not IsEncryptorDemoDisplayed)
      and (not IsHtmlDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpRequestDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  SafeClear();
  AddXmlData(AEnvelope.Text).CharSet := Header.CharSet;
  Header.ContentType := cSoapHeaderContentType[SoapVersion];
  if (SoapVersion = svSoap1_1) then
  begin
    Header.SoapAction := ASoapAction;
  end;
end;

constructor TclSoapMessage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  InitSoapSecurity();

  FSecurityConfig := TclXmlSecurityConfig.Create(Self);
  FSecurityConfig.OnChange := DoPropertyChanged;

  FEncryptedKey := TclSoapEncryptedKeyInfo.Create(nil, Self);
  FEncryptedKey.OnChange := DoPropertyChanged;

  FSignatures := TclSoapSignatureList.Create(Self, TclSoapSignatureInfo);
  FSignatures.OnChange := DoPropertyChanged;

  FAddressing := TclSoapAddressList.Create(Self, TclSoapAddressItem, SecurityConfig);
  FAddressing.OnChange := DoPropertyChanged;

  FTimestamp := TclSoapTimestamp.Create(SecurityConfig);
  FTimestamp.OnChange := DoPropertyChanged;

  FCertificates := TclCertificateStore.Create(nil);
  FCertificates.StoreName := 'addressbook';

  FNamespaces := TclSoapNameSpaceList.Create(Self, TclSoapNameSpace);
  FNamespaces.OnChange := DoPropertyChanged;

  FEncodingStyle := DefaultEncodingStyle;
  FSoapVersion := svSoap1_2;
end;

procedure TclSoapMessage.Decrypt;
var
  dom: IXMLDOMDocument;
  headerNode, security: IXMLDOMNode;
  sessionKey: TclXmlEncryptedKey;
  ref: TclXmlEncryptReferenceList;
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
    if (not IsHttpRequestDemoDisplayed) and (not IsCertDemoDisplayed)
      and (not IsEncoderDemoDisplayed) and (not IsEncryptorDemoDisplayed)
      and (not IsHtmlDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpRequestDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  if not IsEncrypted then
  begin
    raise EclSoapMessageError.Create(SoapMessageNotEncrypted, SoapMessageNotEncryptedCode);
  end;

  CheckSoapVersion();

  dom := CoDOMDocument.Create();
  dom.validateOnParse := False;
  dom.preserveWhiteSpace := True;
  dom.loadXML(XmlCrlfEncode(WideString(TclXmlItem(Self.Items[0]).XmlData)));
  if (not dom.parsed) then
  begin
    raise EclSoapMessageError.Create(dom.parseError.reason, dom.parseError.errorCode);
  end;

  headerNode := GetNodeByName(dom.documentElement, 'Header');
  if (headerNode = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  security := GetNodeByName(headerNode, 'Security');
  if (security = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  ExtractBodyId(dom);

  FAddressing.Parse(headerNode);

  FTimestamp.Parse(security);

  ref := nil;
  sessionKey := nil;
  try
    ref := TclXmlEncryptReferenceList.Create(nil, TclXmlEncryptReference);
    sessionKey := TclXmlEncryptedKey.Parse(security, ref, SecurityConfig);

    DecryptSessionKey(sessionKey);

    TclXmlItem(Self.Items[0]).XmlData := sessionKey.Decrypt(dom, Header.CharSet);

    EncryptedKey.AssignEncryptedKeyInfo(sessionKey);
  finally
    ref.Free();
    sessionKey.Free();
  end;

  if (not IsSigned) then
  begin
    RemoveNode(security);
  end;
end;

procedure TclSoapMessage.DecryptSessionKey(ASessionKey: TclXmlEncryptedKey);
var
  cert, msgCert: TclCertificate;
  storeName: string;
  storeLocation: TclCertificateStoreLocation;
begin
  cert := nil;
  msgCert := nil;
  storeName := 'MY';
  storeLocation := slCurrentUser;
  GetEncryptionCertificate(ASessionKey.KeyInfo, cert, storeName, storeLocation);

  if (ASessionKey.KeyInfo <> nil) then
  begin
    GetInternalCertStore().Open(storeName, storeLocation);
    msgCert := ASessionKey.KeyInfo.GetCertificate(GetInternalCertStore());
    if (msgCert <> nil) and (Certificates.FindBySerialNo(msgCert.SerialNumber, msgCert.IssuedBy) = nil) then
    begin
      Certificates.Items.Add(msgCert);
    end;
  end;

  if (cert = nil) then
  begin
    cert := msgCert;
  end;

  ASessionKey.DecryptSessionKey(cert, storeName, storeLocation);
end;

destructor TclSoapMessage.Destroy;
begin
  FNamespaces.Free();
  FCertificates.Free();
  FTimestamp.Free();
  FAddressing.Free();
  FInternalCertStore.Free();
  FSignatures.Free();
  FEncryptedKey.Free();
  FSecurityConfig.Free();

  inherited Destroy();
end;

procedure TclSoapMessage.DoPropertyChanged(Sender: TObject);
begin
  BeginUpdate();
  EndUpdate();
end;

procedure TclSoapMessage.SetSoapVersion(const Value: TclSoapVersion);
begin
  if (FSoapVersion <> Value) then
  begin
    BeginUpdate();
    FSoapVersion := Value;
    EndUpdate();
  end;
end;

procedure TclSoapMessage.SetTimestamp(const Value: TclSoapTimestamp);
begin
  FTimestamp.Assign(Value);
  BeginUpdate();
  EndUpdate();
end;

procedure TclSoapMessage.CheckRequestExists;
begin
  if (Self.Items.Count = 0) or (not (Self.Items[0] is TclSoapMessageItem))
    or (TclXmlItem(Self.Items[0]).XmlData = '') then
  begin
    raise EclSoapMessageError.Create(RequestEmpty, RequestEmptyCode);
  end;
end;

procedure TclSoapMessage.Encrypt;
var
  dom: IXMLDOMDocument;
  envelope, headerNode, security: IXMLDOMNode;
  sessionKey: TclXmlEncryptedKey;
  wsseNameSpace, wsuNameSpace, wsaNameSpace: string;
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
    if (not IsHttpRequestDemoDisplayed) and (not IsCertDemoDisplayed)
      and (not IsEncoderDemoDisplayed) and (not IsEncryptorDemoDisplayed)
      and (not IsHtmlDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpRequestDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  if (EncryptedKey.References.Count = 0) then
  begin
    raise EclSoapMessageError.Create(ReferencesEmpty, ReferencesEmptyCode);
  end;
  if IsEncrypted then
  begin
    raise EclSoapMessageError.Create(SoapMessageEncrypted, SoapMessageEncryptedCode);
  end;

  CheckSoapVersion();

  dom := CoDOMDocument.Create();
  dom.validateOnParse := False;
  dom.preserveWhiteSpace := True;

  dom.loadXML(XmlCrlfEncode(WideString(TclXmlItem(Self.Items[0]).XmlData))); //TODO WideString typecast
  //use value from GetXmlCharSet() to convert/typecast correctly
  if (not dom.parsed) then
  begin
    raise EclSoapMessageError.Create(dom.parseError.reason, dom.parseError.errorCode);
  end;

  AssignBodyIdIfNeed(dom);

  headerNode := GetNodeByName(dom.documentElement, 'Header');
  if (headerNode = nil) then
  begin
    envelope := dom.documentElement;
    if (envelope = nil) or (envelope.baseName <> 'Envelope') then
    begin
      raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
    end;

    headerNode := dom.createElement(GetSoapNodeName(GetNameSpace(dom.lastChild), 'Header'));
    envelope.insertBefore(headerNode, envelope.firstChild);
  end;

  wsuNameSpace := SecurityConfig.Namespaces.GetPrefix(wsuNameSpaceName);

  if (GetAttributeValue(headerNode, GetSoapNamespace(wsuNameSpace)) = '') then
  begin
    SetAttributeValue(headerNode, GetSoapNamespace(wsuNameSpace), wsuNameSpaceName);
  end;

  wsaNameSpace := SecurityConfig.Namespaces.GetPrefix(wsaNameSpaceName);

  if (FAddressing.Count > 0) and (GetAttributeValue(headerNode, GetSoapNamespace(wsaNameSpace)) = '') then
  begin
    SetAttributeValue(headerNode, GetSoapNamespace(wsaNameSpace), wsaNameSpaceName);
  end;

  security := GetNodeByName(headerNode, 'Security');
  if (security = nil) then
  begin
    wsseNameSpace := SecurityConfig.Namespaces.GetPrefix(wsseNameSpaceName);
    security := dom.createElement(GetSoapNodeName(wsseNameSpace, 'Security'));
    headerNode.appendChild(security);
    SetAttributeValue(security, GetSoapNamespace(wsseNameSpace), wsseNameSpaceName);
  end;

  FAddressing.Build(headerNode);

  FTimestamp.Build(security);

  sessionKey := EncryptedKey.CreateEncryptedKey(EncryptedKey.References, SecurityConfig);
  try
    EncryptSessionKey(sessionKey, security);

    sessionKey.Encrypt(dom, Header.CharSet);
  finally
    sessionKey.Free();
  end;

  TclXmlItem(Self.Items[0]).XmlData := string(XmlCrlfDecode(dom.xml));
end;

procedure TclSoapMessage.EncryptSessionKey(ASessionKey: TclXmlEncryptedKey; const ASecurity: IXMLDOMNode);
var
  cert: TclCertificate;
  storeName: string;
  storeLocation: TclCertificateStoreLocation;
begin
  cert := nil;
  storeName := 'addressbook';
  storeLocation := slCurrentUser;
  GetEncryptionCertificate(ASessionKey.KeyInfo, cert, storeName, storeLocation);

  if (cert = nil) then
  begin
    raise EclSoapMessageError.Create(CertificateRequired, CertificateRequiredCode);
  end;

  ASessionKey.EncryptSessionKey(cert, storeName, storeLocation, ASecurity);
end;

procedure TclSoapMessage.ExtractBodyId(const ADom: IXMLDOMDocument);
var
  body: IXMLDOMNode;
begin
  body := GetNodeByName(ADom.documentElement, 'Body');
  if (body <> nil) then
  begin
    FBodyID := GetAttributeValue(body, GetIdName(SecurityConfig.Namespaces.GetPrefix(wsuNameSpaceName)));
    if (FBodyID = '') then
    begin
      FBodyID := GetAttributeValue(body, SecurityConfig.IdName);
    end;
  end;
end;

procedure TclSoapMessage.AssignBodyIdIfNeed(const ADom: IXMLDOMDocument);
var
  body: IXMLDOMNode;
  wsuNameSpace: string;
begin
  if (BodyID <> '') then
  begin
    body := GetNodeByName(ADom.documentElement, 'Body');
    if (body <> nil) then
    begin
      wsuNameSpace := SecurityConfig.Namespaces.GetPrefix(wsuNameSpaceName);

      if (GetAttributeValue(body, GetSoapNamespace(wsuNameSpace)) = '') then
      begin
        SetAttributeValue(body, GetSoapNamespace(wsuNameSpace), wsuNameSpaceName);
      end;

      if (GetAttributeValue(body, GetIdName(wsuNameSpace)) = '') then
      begin
        SetAttributeValue(body, GetIdName(wsuNameSpace), BodyID);
      end;
    end;
  end;
end;

procedure TclSoapMessage.Sign;
var
  dom: IXMLDOMDocument;
  envelope, headerNode, security: IXMLDOMNode;
  wsseNameSpace, wsuNameSpace, wsaNameSpace: string;
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
    if (not IsHttpRequestDemoDisplayed) and (not IsCertDemoDisplayed)
      and (not IsEncoderDemoDisplayed) and (not IsEncryptorDemoDisplayed)
      and (not IsHtmlDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpRequestDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  if (Signatures.Count = 0) then
  begin
    raise EclSoapMessageError.Create(SignaturesEmpty, SignaturesEmptyCode);
  end;

  CheckSoapVersion();

  dom := CoDOMDocument.Create();
  dom.validateOnParse := False;
  dom.preserveWhiteSpace := True;

  dom.loadXML(XmlCrlfEncode(WideString(TclXmlItem(Self.Items[0]).XmlData))); //TODO WideString typecast
  //use value from GetXmlCharSet() to convert/typecast correctly
  if (not dom.parsed) then
  begin
    raise EclSoapMessageError.Create(dom.parseError.reason, dom.parseError.errorCode);
  end;

  AssignBodyIdIfNeed(dom);

  headerNode := GetNodeByName(dom.documentElement, 'Header');
  if (headerNode = nil) then
  begin
    envelope := dom.documentElement;
    if (envelope = nil) or (envelope.baseName <> 'Envelope') then
    begin
      raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
    end;

    headerNode := dom.createElement(GetSoapNodeName(GetNameSpace(dom.lastChild), 'Header'));
    envelope.insertBefore(headerNode, envelope.firstChild);
  end;

  wsuNameSpace := SecurityConfig.Namespaces.GetPrefix(wsuNameSpaceName);

  if (GetAttributeValue(headerNode, GetSoapNamespace(wsuNameSpace)) = '') then
  begin
    SetAttributeValue(headerNode, GetSoapNamespace(wsuNameSpace), wsuNameSpaceName);
  end;

  wsaNameSpace := SecurityConfig.Namespaces.GetPrefix(wsaNameSpaceName);

  if (FAddressing.Count > 0) and (GetAttributeValue(headerNode, GetSoapNamespace(wsaNameSpace)) = '') then
  begin
    SetAttributeValue(headerNode, GetSoapNamespace(wsaNameSpace), wsaNameSpaceName);
  end;

  security := GetNodeByName(headerNode, 'Security');
  if (security = nil) then
  begin
    wsseNameSpace := SecurityConfig.Namespaces.GetPrefix(wsseNameSpaceName);
    security := dom.createElement(GetSoapNodeName(wsseNameSpace, 'Security'));
    headerNode.appendChild(security);
    SetAttributeValue(security, GetSoapNamespace(wsseNameSpace), wsseNameSpaceName);
  end;

  FAddressing.Build(headerNode);

  FTimestamp.Build(security);

  CreateSignatures(dom);

  TclXmlItem(Self.Items[0]).XmlData := string(XmlCrlfDecode(dom.xml));
end;

procedure TclSoapMessage.CreateSignatures(const ADom: IXMLDOMDocument);
var
  i: Integer;
  sig: TclXmlSignature;
  sigInfo: TclSoapSignatureInfo;
begin
  for i := 0 to Signatures.Count - 1 do
  begin
    sigInfo := Signatures[i];

    if (sigInfo.References.Count = 0) then
    begin
      raise EclSoapMessageError.Create(ReferencesEmpty, ReferencesEmptyCode);
    end;

    if (Signatures.Count > 1) and (sigInfo.ID = '') then
    begin
      raise EclSoapMessageError.Create(SignatureIdEmpty, SignatureIdEmptyCode);
    end;

    sig := sigInfo.CreateSignature(SecurityConfig);
    try
      CreateSignature(sig, ADom);
    finally
      sig.Free();
    end;
  end;
end;

procedure TclSoapMessage.VerifySignature(ASignature: TclXmlSignature; const ADom: IXMLDOMDocument);
var
  cert, msgCert: TclCertificate;
  storeName: string;
  storeLocation: TclCertificateStoreLocation;
begin
  cert := nil;
  msgCert := nil;
  storeName := 'addressbook';
  storeLocation := slCurrentUser;
  GetSigningCertificate(ASignature.KeyInfo, cert, storeName, storeLocation);

  if (ASignature.KeyInfo <> nil) then
  begin
    GetInternalCertStore().Open(storeName, storeLocation);
    msgCert := ASignature.KeyInfo.GetCertificate(GetInternalCertStore());
    if (msgCert <> nil) and (Certificates.FindBySerialNo(msgCert.SerialNumber, msgCert.IssuedBy) = nil) then
    begin
      Certificates.Items.Add(msgCert);
    end;
  end;

  if (cert = nil) then
  begin
    cert := msgCert;
  end;

  ASignature.Verify(cert, ADom);
end;

procedure TclSoapMessage.Verify;
var
  dom: IXMLDOMDocument;
  security, headerNode: IXMLDOMNode;
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
    if (not IsHttpRequestDemoDisplayed) and (not IsCertDemoDisplayed)
      and (not IsEncoderDemoDisplayed) and (not IsEncryptorDemoDisplayed)
      and (not IsHtmlDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpRequestDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  if not IsSigned then
  begin
    raise EclSoapMessageError.Create(SoapMessageNotSigned, SoapMessageNotSignedCode);
  end;

  CheckSoapVersion();

  dom := CoDOMDocument.Create();
  dom.validateOnParse := False;
  dom.preserveWhiteSpace := True;
  dom.loadXML(XmlCrlfEncode(WideString(TclXmlItem(Self.Items[0]).XmlData))); //TODO WideString typecast
  //use value from GetXmlCharSet(dom) to convert/typecast correctly
  if (not dom.parsed) then
  begin
    raise EclSoapMessageError.Create(dom.parseError.reason, dom.parseError.errorCode);
  end;

  headerNode := GetNodeByName(dom.documentElement, 'Header');
  if (headerNode = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  security := GetNodeByName(headerNode, 'Security');
  if (security = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  ExtractBodyId(dom);

  FAddressing.Parse(headerNode);

  FTimestamp.Parse(security);

  VerifySignatures(security, dom);

  if (not IsEncrypted) then
  begin
    RemoveNode(security);
  end;

  TclXmlItem(Self.Items[0]).XmlData := string(XmlCrlfDecode(dom.xml));
end;

procedure TclSoapMessage.VerifySignatures(const ASecurity: IXMLDOMNode; const ADom: IXMLDOMDocument);
var
  list: IXMLDOMNodeList;
  node: IXMLDomNode;
  sig: TclXmlSignature;
  ref: TclXmlSignReferenceList;
begin
  list := ASecurity.childNodes;
  if (list = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  node := list.nextNode;
  while (node <> nil) do
  begin
    if (node.baseName = 'Signature') then
    begin
      ref := nil;
      sig := nil;
      try
        ref := TclXmlSignReferenceList.Create(nil, TclXmlSignReference);
        sig := TclXmlSignature.Parse(ASecurity, node, ref, SecurityConfig);

        Signatures.Add().AssignSignatureInfo(sig);

        VerifySignature(sig, ADom);
      finally
        ref.Free();
        sig.Free();
      end;
    end;
    node := list.nextNode;
  end;
  node := nil;
end;

procedure TclSoapMessage.GetSigningCertificate(AKeyInfo: TclXmlKeyInfo; var ACertificate: TclCertificate;
  var AStoreName: string; var AStoreLocation: TclCertificateStoreLocation);
var
  handled: Boolean;
  list: TclCertificateList;
begin
  ACertificate := nil;
  handled := False;
  list := TclCertificateList.Create(False);
  try
    DoGetSigningCertificate(AKeyInfo, ACertificate, list, handled);
  finally
    list.Free();
  end;
end;

procedure TclSoapMessage.DoGetEncryptionCertificate(AKeyInfo: TclXmlKeyInfo; var ACertificate: TclCertificate; AExtraCerts: TclCertificateList;
  var AStoreName: string; var AStoreLocation: TclCertificateStoreLocation; var Handled: Boolean);
begin
  if Assigned(OnGetEncryptionCertificate) then
  begin
    OnGetEncryptionCertificate(Self, AKeyInfo, ACertificate, AExtraCerts, AStoreName, AStoreLocation, Handled);
  end;
end;

procedure TclSoapMessage.DoGetSigningCertificate(AKeyInfo: TclXmlKeyInfo; var ACertificate: TclCertificate; AExtraCerts: TclCertificateList; var Handled: Boolean);
begin
  if Assigned(OnGetSigningCertificate) then
  begin
    OnGetSigningCertificate(Self, AKeyInfo, ACertificate, AExtraCerts, Handled);
  end;
end;

function TclSoapMessage.GetNameSpace(ANode: IXMLDOMNode): string;
var
  ind: Integer;
begin
  Result := '';
  if (ANode = nil) then Exit;

  ind := Pos(':', ANode.nodeName);
  if (ind > 0) then
  begin
    Result := Copy(ANode.nodeName, 1, ind - 1);
  end;
end;

procedure TclSoapMessage.GetEncryptionCertificate(AKeyInfo: TclXmlKeyInfo; var ACertificate: TclCertificate;
  var AStoreName: string; var AStoreLocation: TclCertificateStoreLocation);
var
  handled: Boolean;
  list: TclCertificateList;
begin
  handled := False;
  list := TclCertificateList.Create(False);
  try
    DoGetEncryptionCertificate(AKeyInfo, ACertificate, list, AStoreName, AStoreLocation, handled);
  finally
    list.Free();
  end;
end;

procedure TclSoapMessage.BuildSoapMessage(AEnvelope: IXMLDOMDocument; const ASoapAction: string);
var
  src: TStrings;
begin
  src := TStringList.Create();
  try
    src.Text := string(AEnvelope.xml); //TODO use value from GetXmlCharSet(AEnvelope) to convert/typecast correctly
    BuildSoapMessage(src, ASoapAction);
  finally
    src.Free();
  end;
end;

procedure TclSoapMessage.BuildSoapMessage(AEnvelope: IXMLDOMDocument);
begin
  BuildSoapMessage(AEnvelope, '');
end;

procedure TclSoapMessage.BuildSoapMessage(AEnvelope: TStrings);
begin
  BuildSoapMessage(AEnvelope, '');
end;

procedure TclSoapMessage.BuildSoapMessage(const AEnvelope: string);
begin
  BuildSoapMessage(AEnvelope, '');
end;

function TclSoapMessage.AddWsdlEnvelope(const AMessage: string): string;
var
  ns: TclSoapNameSpaceList;
  wsuNameSpace, envNameSpace, envNsName: string;
begin
  ns := TclSoapNameSpaceList.Create(nil, TclSoapNameSpace);
  try
    envNsName := cEnvelopeNameSpaceName[SoapVersion];
    envNameSpace := SecurityConfig.Namespaces.GetPrefix(envNsName);
    ns.AddNameSpace(GetSoapNamespace(envNameSpace), envNsName);

    Result := '<?xml version="1.0"' + GetAttributeText(' encoding', Header.CharSet) + '?>'
      + '<' + GetSoapNodeName(envNameSpace, 'Envelope');

    if (SoapVersion = svSoap1_1) then
    begin
      Result := Result + GetAttributeText(' ' + GetSoapNodeName(envNameSpace, 'encodingStyle'), EncodingStyle);
    end;

    Result := Result + ns.ToString() + Namespaces.ToString() + '>' + '<' + GetSoapNodeName(envNameSpace, 'Body');

    if (BodyID <> '') then
    begin
      wsuNameSpace := SecurityConfig.Namespaces.GetPrefix(wsuNameSpaceName);

      ns.Clear();
      ns.AddNameSpace(GetSoapNamespace(wsuNameSpace), wsuNameSpaceName);

      Result := Result + ns.ToString() + GetAttributeText(' ' + GetIdName(wsuNameSpace), BodyID);
    end;

    Result := Result + '>' + AMessage + '</' + GetSoapNodeName(envNameSpace, 'Body') + '>'
      + '</' + GetSoapNodeName(envNameSpace, 'Envelope') + '>';
  finally
    ns.Free();
  end;
end;

procedure TclSoapMessage.BuildSoapWSDL(const AMethodURI, AMethod: string;
  AParamNames, AParamValues, AParamAttrs: TStrings);
var
  i: Integer;
  soapXml, attr: string;
begin
  if (AMethod = '') then
  begin
    raise EclSoapMessageError.Create(ParameterSetError, ParameterSetErrorCode);
  end;

  if (AParamNames.Count <> AParamNames.Count) then
  begin
    raise EclSoapMessageError.Create(ParameterSetError, ParameterSetErrorCode);
  end;

  if (AParamAttrs <> nil) and (AParamNames.Count <> AParamAttrs.Count) then
  begin
    raise EclSoapMessageError.Create(ParameterSetError, ParameterSetErrorCode);
  end;

  soapXml := '<m:' + AMethod + ' ' + GetAttributeText('xmlns:m', AMethodURI) + '>';

  for i := 0 to AParamNames.Count - 1 do
  begin
    attr := '';
    if (AParamAttrs <> nil) and (AParamAttrs[i] <> '') then
    begin
      attr := ' ' + AParamAttrs[i];
    end;
    
    soapXml := soapXml + '<' + AParamNames[i] + attr + '>' + AParamValues[i] + '</' + AParamNames[i] + '>';
  end;

  soapXml := soapXml + '</m:' + AMethod + '>';

  soapXml := AddWsdlEnvelope(soapXml);

  BuildSoapMessage(soapXml, AMethodURI + Id2UriReference(AMethod));
end;

procedure TclSoapMessage.BuildSoapWSDL(const AMethodURI, AMethod: string;
  const AParamNames, AParamValues, AParamAttrs: array of string);
var
  i: Integer;
  names, vals, attrs: TStrings;
begin
  names := nil;
  vals := nil;
  attrs := nil;
  try
    names := TStringList.Create();
    vals := TStringList.Create();

    for i := Low(AParamNames) to High(AParamNames) do
    begin
      names.Add(AParamNames[i]);
    end;

    for i := Low(AParamValues) to High(AParamValues) do
    begin
      vals.Add(AParamValues[i]);
    end;

    if (Length(AParamAttrs) > 0) then
    begin
      attrs := TStringList.Create();

      for i := Low(AParamAttrs) to High(AParamAttrs) do
      begin
        attrs.Add(AParamAttrs[i]);
      end;
    end;

    BuildSoapWSDL(AMethodURI, AMethod, names, vals, attrs);
  finally
    attrs.Free();
    vals.Free();
    names.Free();
  end;
end;

procedure TclSoapMessage.BuildSoapWSDL(const AMethodURI, AMethod: string;
  AParamNames, AParamValues: TStrings);
begin
  BuildSoapWSDL(AMethodURI, AMethod, AParamNames, AParamValues, nil);
end;

procedure TclSoapMessage.BuildSoapWSDL(const AMethodURI, AMethod: string;
  const AParamNames, AParamValues: array of string);
begin
  BuildSoapWSDL(AMethodURI, AMethod, AParamNames, AParamValues, []);
end;

function TclSoapMessage.GetIdName(const ANamespace: string): string;
begin
  Result := GetSoapNodeName(ANamespace, SecurityConfig.IdName);
end;

function TclSoapMessage.GetInternalCertStore: TclCertificateStore;
begin
  if (FInternalCertStore = nil) then
  begin
    FInternalCertStore := TclCertificateStore.Create(nil);
  end;
  Result := FInternalCertStore;
end;

function TclSoapMessage.GetIsEncrypted: Boolean;
begin
  Result := GetIsSecured('EncryptedKey');
end;

function TclSoapMessage.GetIsSecured(const ANodeName: string): Boolean;
var
  dom: IXMLDOMDocument;
  head, security: IXMLDOMNode;
begin
  Result := False;

  CheckRequestExists();
  dom := CoDOMDocument.Create();
  dom.loadXML(TclXmlItem(Self.Items[0]).XmlData);
  if (not dom.parsed) then
  begin
    Exit;
  end;

  head := GetNodeByName(dom.documentElement, 'Header');
  if (head <> nil) then
  begin
    security := GetNodeByName(head, 'Security');
    if (security <> nil) then
    begin
      Result := (GetNodeByName(security, ANodeName) <> nil);
    end;
  end;
end;

function TclSoapMessage.GetIsSigned: Boolean;
begin
  Result := GetIsSecured('Signature');
end;

procedure TclSoapMessage.SetSecurityConfig(const Value: TclXmlSecurityConfig);
begin
  FSecurityConfig.Assign(Value);
end;

procedure TclSoapMessage.SetNamespaces(const Value: TclSoapNameSpaceList);
begin
  FNamespaces.Assign(Value);
end;

procedure TclSoapMessage.Clear;
begin
  BeginUpdate();
  try
    Addressing.Clear();
    Timestamp.Clear();
    Namespaces.Clear();

    SoapVersion := svSoap1_2;
    BodyID := '';
    Signatures.Clear();
    EncryptedKey.Clear();
    Certificates.Close();

    inherited Clear();
  finally
    EndUpdate();
  end;
end;

procedure TclSoapMessage.SetSignatures(const Value: TclSoapSignatureList);
begin
  FSignatures.Assign(Value);
end;

procedure TclSoapMessage.BuildSoapMessage(const AEnvelope, ASoapAction: string);
var
  env: TStrings;
begin
  env := TStringList.Create();
  try
    env.Text := AEnvelope;
    BuildSoapMessage(env, ASoapAction);
  finally
    env.Free();
  end;
end;

function TclSoapMessage.CreateItem(AFieldList: TclHeaderFieldList): TclHttpRequestItem;
var
  contentType: string;
begin
  if SameText(Header.ContentType, 'multipart/related') then
  begin
    contentType := AFieldList.GetFieldValue('Content-Type');
    if (SameText(AFieldList.GetFieldValueItem(contentType, ''), cSoapHeaderContentType[svSoap1_1])
        or SameText(AFieldList.GetFieldValueItem(contentType, ''), cSoapHeaderContentType[svSoap1_2]))
      and SameText(Header.Start, AFieldList.GetFieldValue('Content-ID')) then
    begin
      Result := AddXmlData('');
    end else
    begin
      Result := AddAttachment();
    end;
  end else
  begin
    Result := inherited CreateItem(AFieldList);
  end;
end;

procedure TclSoapMessage.CreateSingleItem(AStream: TStream);
var
  buf: TclByteArray;
  s: string;
  item: TclXmlItem;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  if (Header.ContentType = '')
    or (system.Pos('multipart/related', LowerCase(Header.ContentType)) > 0)
    or (system.Pos(cSoapHeaderContentType[svSoap1_1], LowerCase(Header.ContentType)) > 0)
    or (system.Pos(cSoapHeaderContentType[svSoap1_2], LowerCase(Header.ContentType)) > 0) then
  begin
    s := '';
    if (AStream.Size > 0) then
    begin
      SetLength(buf, AStream.Size);
      AStream.Read(buf[0], AStream.Size);
      s := TclTranslator.GetString(buf, 0, Length(buf), Header.CharSet);
    end;

    item := AddXmlData(s);
    item.CharSet := Header.CharSet;
    item.AfterAddData();
  end else
  begin
    inherited CreateSingleItem(AStream);
  end;
end;

procedure TclSoapMessage.CreateSignature(ASignature: TclXmlSignature; const ADom: IXMLDOMDocument);
var
  cert: TclCertificate;
  storeName: string;
  storeLocation: TclCertificateStoreLocation;
begin
  cert := nil;
  storeName := 'MY';
  storeLocation := slCurrentUser;
  GetSigningCertificate(ASignature.KeyInfo, cert, storeName, storeLocation);
  if (cert = nil) then
  begin
    raise EclSoapMessageError.Create(CertificateRequired, CertificateRequiredCode);
  end;

  ASignature.Sign(cert, ADom);
end;

function TclSoapMessage.GetContentType: string;
var
  i: Integer;
  isXmlData: Boolean;
  requestTypes: array[Boolean] of string;
begin
  requestTypes[False] := cSoapHeaderContentType[SoapVersion];
  requestTypes[True] := 'multipart/related';

  isXmlData := False;
  for i := 0 to Items.Count - 1 do
  begin
    if (Items[i] is TclSoapMessageItem) then
    begin
      isXmlData := True;
    end;
  end;
  if isXmlData then
  begin
    Result := requestTypes[Items.Count > 1];
  end else
  begin
    Result := inherited GetContentType();
  end;
end;

function TclSoapMessage.AddXmlData(const AXmlData: string): TclXmlItem;
begin
  BeginUpdate();
  try
    SoapVersion := ParseSoapVersion(AXmlData);
    Result := Items.Add(TclXmlItem) as TclXmlItem;
    Result.XmlData := AXmlData;
  finally
    EndUpdate();
  end;
end;

function TclSoapMessage.AddAttachment: TclAttachmentItem;
begin
  Result := Items.Add(TclAttachmentItem) as TclAttachmentItem;
end;

function TclSoapMessage.CreateHeader: TclHttpRequestHeader;
begin
  Result := TclSoapMessageHeader.Create();
end;

function TclSoapMessage.GetHeader: TclSoapMessageHeader;
begin
  Result := inherited Header as TclSoapMessageHeader;
end;

procedure TclSoapMessage.SetAddressing(const Value: TclSoapAddressList);
begin
  FAddressing.Assign(Value);
end;

procedure TclSoapMessage.SetBodyID(const Value: string);
begin
  if (FBodyID <> Value) then
  begin
    BeginUpdate();
    FBodyID := Value;
    EndUpdate();
  end;
end;

procedure TclSoapMessage.SetEncodingStyle(const Value: string);
begin
  if (FEncodingStyle <> Value) then
  begin
    BeginUpdate();
    FEncodingStyle := Value;
    EndUpdate();
  end;
end;

procedure TclSoapMessage.SetEncryptedKey(const Value: TclSoapEncryptedKeyInfo);
begin
  FEncryptedKey.Assign(Value);
end;

procedure TclSoapMessage.SetHeader(const Value: TclSoapMessageHeader);
begin
  inherited Header := Value;
end;

procedure TclSoapMessage.InitHeader;
begin
  inherited InitHeader();
  if (Items.Count > 1) and (Items[0] is TclSoapMessageItem) then
  begin
    if (Header.Start = '') then
    begin
      Header.Start := (Items[0] as TclSoapMessageItem).ContentID;
    end;

    if (Header.SubType = '') then
    begin
      Header.SubType := (Items[0] as TclSoapMessageItem).ContentType;
    end;
  end;
end;

function TclSoapMessage.ParseSoapVersion(const AEnvelope: string): TclSoapVersion;
begin
  if (System.Pos(soap12NameSpaceName, AEnvelope) > 0) then
  begin
    Result := svSoap1_2;
  end else
  begin
    Result := svSoap1_1;
  end;
end;

procedure TclSoapMessage.CheckSoapVersion;
begin
  if (SoapVersion <> ParseSoapVersion(TclXmlItem(Self.Items[0]).XmlData)) then
  begin
    EclSoapMessageError.Create(SoapVersionError, SoapVersionErrorCode);
  end;
end;

{ TclSoapMessageItem }

procedure TclSoapMessageItem.Assign(Source: TPersistent);
var
  Src: TclSoapMessageItem;
begin
  BeginUpdate();
  try
    if (Source is TclSoapMessageItem) then
    begin
      Src := (Source as TclSoapMessageItem);

      ContentType := Src.ContentType;
      CharSet := Src.CharSet;
      ContentID := Src.ContentID;
      ContentLocation := Src.ContentLocation;
      ContentTransferEncoding := Src.ContentTransferEncoding;
      ExtraFields := Src.ExtraFields;
    end;
    inherited Assign(Source);
  finally
    EndUpdate();
  end;
end;

procedure TclSoapMessageItem.ListChangeEvent(Sender: TObject);
begin
  Update();
end;

constructor TclSoapMessageItem.Create(AOwner: TclHttpRequestItemList);
begin
  inherited Create(AOwner);
  FKnownFields := TStringList.Create();

  FExtraFields := TStringList.Create();
  TStringList(FExtraFields).OnChange := ListChangeEvent;

  RegisterFields();
  
  ContentType := 'text/xml';
end;

destructor TclSoapMessageItem.Destroy;
begin
  FExtraFields.Free();
  FKnownFields.Free();
  inherited Destroy();
end;

function TclSoapMessageItem.GetHeader: TStream;
var
  list: TStrings;
  fieldList: TclHeaderFieldList;
begin
  list := nil;
  fieldList := nil;
  try
    list := TStringList.Create();
    fieldList := TclHeaderFieldList.Create();
    fieldList.Parse(0, list);

    fieldList.AddField('Content-Type', ContentType);
    if (ContentType <> '') then
    begin
      fieldList.AddFieldItem('Content-Type', 'charset', CharSet);
    end;

    fieldList.AddField('Content-ID', ContentID);
    fieldList.AddField('Content-Location', ContentLocation);
    fieldList.AddField('Content-Transfer-Encoding', ContentTransferEncoding);
    fieldList.AddFields(ExtraFields);
    fieldList.AddEndOfHeader();

    Result := TMemoryStream.Create();
    TclStringsUtils.SaveStrings(list, Result, CharSet);
    Result.Position := 0;
  finally
    fieldList.Free();
    list.Free();
  end;
end;

function TclSoapMessageItem.GetSoapMessage: TclSoapMessage;
begin
  Result := (Request as TclSoapMessage);
end;

function TclSoapMessageItem.GetCharSet: string;
begin
  Result := CharSet;
  if (Result = '') then
  begin
    Result := inherited GetCharSet();
  end;
end;

function TclSoapMessageItem.GetDataStream: TStream;
begin
  if (Request.IsMultiPartContent) then
  begin
    Result := GetHeader();
  end else
  begin
    Result := TclNullStream.Create();
  end;
end;

procedure TclSoapMessageItem.SetContentID(const Value: string);
begin
  if (FContentID <> Value) then
  begin
    FContentID := Value;
    Update();
  end;
end;

procedure TclSoapMessageItem.SetContentLocation(const Value: string);
begin
  if (FContentLocation <> Value) then
  begin
    FContentLocation := Value;
    Update();
  end;
end;

procedure TclSoapMessageItem.SetContentTransferEncoding(
  const Value: string);
begin
  if (FContentTransferEncoding <> Value) then
  begin
    FContentTransferEncoding := Value;
    Update();
  end;
end;

procedure TclSoapMessageItem.SetContentType(const Value: string);
begin
  if (FContentType <> Value) then
  begin
    FContentType := Value;
    Update();
  end;
end;

procedure TclSoapMessageItem.SetExtraFields(const Value: TStrings);
begin
  FExtraFields.Assign(Value);
end;

procedure TclSoapMessageItem.SetCharSet(const Value: string);
begin
  if (FCharSet <> Value) then
  begin
    FCharSet := Value;
    Update();
  end;
end;

procedure TclSoapMessageItem.ReadData(Reader: TReader);
begin
  BeginUpdate();
  try
    inherited ReadData(Reader);
    ContentType := Reader.ReadString();
    CharSet := Reader.ReadString();
    ContentID := Reader.ReadString();
    ContentLocation := Reader.ReadString();
    ContentTransferEncoding := Reader.ReadString();
    ExtraFields.Text := Reader.ReadString();
  finally
    EndUpdate();
  end;
end;

procedure TclSoapMessageItem.WriteData(Writer: TWriter);
begin
  inherited WriteData(Writer);
  Writer.WriteString(ContentType);
  Writer.WriteString(CharSet);
  Writer.WriteString(ContentID);
  Writer.WriteString(ContentLocation);
  Writer.WriteString(ContentTransferEncoding);
  Writer.WriteString(ExtraFields.Text);
end;

procedure TclSoapMessageItem.ParseHeader(AFieldList: TclHeaderFieldList);
var
  s: string;
begin
  BeginUpdate();
  try
    inherited ParseHeader(AFieldList);

    s := AFieldList.GetFieldValue('Content-Type');
    ContentType := AFieldList.GetFieldValueItem(s, '');
    CharSet := AFieldList.GetFieldValueItem(s, 'charset');

    ContentID := AFieldList.GetFieldValue('Content-ID');
    ContentLocation := AFieldList.GetFieldValue('Content-Location');
    ContentTransferEncoding := AFieldList.GetFieldValue('Content-Transfer-Encoding');

    ParseExtraFields(AFieldList);
  finally
    EndUpdate();
  end;
end;

procedure TclSoapMessageItem.ParseExtraFields(AFieldList: TclHeaderFieldList);
var
  i: Integer;
begin
  ExtraFields.Clear();
  for i := 0 to AFieldList.FieldList.Count - 1 do
  begin
    if (FindInStrings(FKnownFields, AFieldList.FieldList[i]) < 0) then
    begin
      ExtraFields.Add(AFieldList.GetFieldName(i) + ': ' + AFieldList.GetFieldValue(i));
    end;
  end;
end;

procedure TclSoapMessageItem.RegisterField(const AField: string);
begin
  if (FindInStrings(FKnownFields, AField) < 0) then
  begin
    FKnownFields.Add(AField);
  end;
end;

procedure TclSoapMessageItem.RegisterFields;
begin
  RegisterField('Content-Type');
  RegisterField('Content-ID');
  RegisterField('Content-Location');
  RegisterField('Content-Transfer-Encoding');
end;

{ TclAttachmentItem }

procedure TclAttachmentItem.AddData(const AData: TclByteArray; AIndex, ACount: Integer);
var
  stream: TStream;
begin
  stream := SoapMessage.DataStream;
  if (stream = nil) then
  begin
    SoapMessage.DoSaveData(Self, stream);
  end;
  if (stream <> nil) then
  begin
    stream.Write(AData[AIndex], ACount);
  end;
  SoapMessage.DataStream := stream;
end;

procedure TclAttachmentItem.AfterAddData;
begin
  if (not (Request is TclSoapMessage)) then Exit;
  if (SoapMessage.DataStream <> nil) and Assigned(SoapMessage.OnDataAdded) then
  begin
    SoapMessage.DataStream.Position := 0;
    SoapMessage.DoDataAdded(Self, SoapMessage.DataStream);
  end;
end;

function TclAttachmentItem.GetDataStream: TStream;
var
  stream: TStream;
begin
  Result := TclMultiStream.Create();
  try
    TclMultiStream(Result).AddStream(inherited GetDataStream());

    stream := nil;
    SoapMessage.DoLoadData(Self, stream);

    if (stream <> nil) then
    begin
      stream.Position := 0;
      TclMultiStream(Result).AddStream(stream);
    end;
  except
    Result.Free();
    raise;
  end;
end;

{ TclSoapMessageHeader }

procedure TclSoapMessageHeader.Assign(Source: TPersistent);
var
  Src: TclSoapMessageHeader;
begin
  BeginUpdate();
  try
    inherited Assign(Source);

    if (Source is TclSoapMessageHeader) then
    begin
      Src := (Source as TclSoapMessageHeader);
      Start := Src.Start;
      SubType := Src.SubType;
      SoapAction := Src.SoapAction;
    end;
  finally
    EndUpdate();
  end;
end;

procedure TclSoapMessageHeader.AssignContentType(AFieldList: TclHeaderFieldList);
begin
  AFieldList.AddField('Content-Type', ContentType);
  if (ContentType <> '') then
  begin
    AFieldList.AddFieldItem('Content-Type', 'boundary', Boundary);
    AFieldList.AddFieldItem('Content-Type', 'charset', CharSet);
    AFieldList.AddFieldItem('Content-Type', 'type', SubType);
    AFieldList.AddFieldItem('Content-Type', 'start', Start);
  end;
end;

procedure TclSoapMessageHeader.Clear;
begin
  BeginUpdate();
  try
    inherited Clear();
    Start := '';
    SubType := '';
    SoapAction := '';
    CharSet := 'utf-8';
  finally
    EndUpdate();
  end;
end;

procedure TclSoapMessageHeader.InternalAssignHeader(AFieldList: TclHeaderFieldList);
begin
  inherited InternalAssignHeader(AFieldList);
  AFieldList.AddField('SOAPAction', SoapAction);
end;

procedure TclSoapMessageHeader.InternalParseHeader(AFieldList: TclHeaderFieldList);
begin
  inherited InternalParseHeader(AFieldList);
  SoapAction := AFieldList.GetFieldValue('SOAPAction');
end;

procedure TclSoapMessageHeader.ParseContentType(AFieldList: TclHeaderFieldList);
var
  s: string;
begin
  inherited ParseContentType(AFieldList);
  s := AFieldList.GetFieldValue('Content-Type');
  Start := AFieldList.GetFieldValueItem(s, 'start');
  SubType := AFieldList.GetFieldValueItem(s, 'type');
end;

procedure TclSoapMessageHeader.RegisterFields;
begin
  inherited RegisterFields();
  RegisterField('SOAPAction');
end;

procedure TclSoapMessageHeader.SetSoapAction(const Value: string);
begin
  if (FSoapAction <> Value) then
  begin
    FSoapAction := Value;
    Update();
  end;
end;

procedure TclSoapMessageHeader.SetStart(const Value: string);
begin
  if (FStart <> Value) then
  begin
    FStart := Value;
    Update();
  end;
end;

procedure TclSoapMessageHeader.SetSubType(const Value: string);
begin
  if (FSubType <> Value) then
  begin
    FSubType := Value;
    Update();
  end;
end;

{ TclXmlItem }

procedure TclXmlItem.AddData(const AData: TclByteArray; AIndex, ACount: Integer);
begin
  XmlData := XmlData + TclTranslator.GetString(AData, AIndex, ACount, CharSet);
end;

procedure TclXmlItem.AfterAddData;
var
  stream: TStream;
  buffer: TclByteArray;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  if Assigned(SoapMessage.OnDataAdded) then
  begin
    stream := TMemoryStream.Create();
    try
      if (XmlData <> '') then
      begin
        buffer := TclTranslator.GetBytes(XmlData, CharSet);
        stream.WriteBuffer(buffer[0], Length(buffer));
        stream.Position := 0;
      end;
      SoapMessage.DoDataAdded(Self, stream);
    finally
      stream.Free();
    end;
  end;
end;

procedure TclXmlItem.Assign(Source: TPersistent);
begin
  BeginUpdate();
  try
    if (Source is TclXmlItem) then
    begin
      XmlData := (Source as TclXmlItem).XmlData;
    end;
    inherited Assign(Source);
  finally
    EndUpdate();
  end;
end;

function TclXmlItem.GetDataStream: TStream;
var
  data: TStream;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'GetDataStream');{$ENDIF}
  Result := TclMultiStream.Create();
  try
    TclMultiStream(Result).AddStream(inherited GetDataStream());
    data := TMemoryStream.Create();
    TclMultiStream(Result).AddStream(data);

    buf := TclTranslator.GetBytes(XmlData, CharSet);
    if (Length(buf) > 0) then
    begin
      data.Write(buf[0], Length(buf));
    end;
    data.Position := 0;
  except
    Result.Free();
    raise;
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'GetDataStream'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'GetDataStream', E); raise; end; end;{$ENDIF}
end;

procedure TclXmlItem.ReadData(Reader: TReader);
begin
  BeginUpdate();
  try
    inherited ReadData(Reader);
    XmlData := Reader.ReadString();
  finally
    EndUpdate();
  end;
end;

procedure TclXmlItem.SetXmlData(const Value: string);
begin
  if (FXmlData <> Value) then
  begin
    FXmlData := Value;
    Update();
  end;
end;

procedure TclXmlItem.WriteData(Writer: TWriter);
begin
  inherited WriteData(Writer);
  Writer.WriteString(XmlData);
end;

{ TclSoapTimestamp }

procedure TclSoapTimestamp.Assign(Source: TPersistent);
var
  src: TclSoapTimestamp;
begin
  if (Source is TclSoapTimestamp) then
  begin
    src := (Source as TclSoapTimestamp);

    FExpires := src.Expires;
    FCreated := src.Created;
    FID := src.ID;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclSoapTimestamp.Build(const ARoot: IXMLDOMNode);
var
  timestamp: IXMLDOMNode;
  wsuNameSpace: string;
begin
  if (Expires = '') and (Created = '') and (ID = '') then Exit;

  if (GetNodeByName(ARoot, 'Timestamp', wsuNameSpaceName) <> nil) then Exit;

  wsuNameSpace := Config.Namespaces.GetPrefix(wsuNameSpaceName);

  timestamp := ARoot.ownerDocument.createElement(GetSoapNodeName(wsuNameSpace, 'Timestamp'));
  ARoot.appendChild(timestamp);

  if (ID <> '') then
  begin
    SetAttributeValue(timestamp, GetSoapNodeName(wsuNameSpace, Config.IdName), ID);
  end;

  AddNodeValue(timestamp, GetSoapNodeName(wsuNameSpace, 'Created'), Created);
  AddNodeValue(timestamp, GetSoapNodeName(wsuNameSpace, 'Expires'), Expires);
end;

procedure TclSoapTimestamp.Parse(const ASecurity: IXMLDOMNode);
var
  timestamp: IXMLDOMNode;
begin
  Clear();

  timestamp := GetNodeByName(ASecurity, 'Timestamp');
  if (timestamp = nil) then Exit;

  FID := GetAttributeValue(timestamp, GetSoapNodeName(Config.Namespaces.GetPrefix(wsuNameSpaceName), Config.IdName));
  FCreated := GetNodeValueByName(timestamp, 'Created');
  FExpires := GetNodeValueByName(timestamp, 'Expires');
end;

procedure TclSoapTimestamp.SetCreated(const Value: string);
begin
  if (FCreated <> Value) then
  begin
    FCreated := Value;
    Update();
  end;
end;

procedure TclSoapTimestamp.SetExpires(const Value: string);
begin
  if (FExpires <> Value) then
  begin
    FExpires := Value;
    Update();
  end;
end;

procedure TclSoapTimestamp.SetID(const Value: string);
begin
  if (FID <> Value) then
  begin
    FID := Value;
    Update();
  end;
end;

procedure TclSoapTimestamp.Update;
begin
  if Assigned(OnChange) then
  begin
    OnChange(Self);
  end;
end;

procedure TclSoapTimestamp.Clear;
begin
  FExpires := '';
  FCreated := '';
  FID := '';
end;

constructor TclSoapTimestamp.Create(AConfig: TclXmlSecurityConfig);
begin
  inherited Create();

  FConfig := AConfig;
  Clear();
end;

{ TclSoapAddressList }

function TclSoapAddressList.Add: TclSoapAddressItem;
begin
  Result := TclSoapAddressItem(inherited Add());
end;

function TclSoapAddressList.AddItem(const AName, AID, AValue: string): TclSoapAddressItem;
begin
  Result := Add();
  Result.Name := AName;
  Result.ID := AID;
  Result.Value := AValue;
end;

procedure TclSoapAddressList.Build(const ARoot: IXMLDOMNode);
var
  i: Integer;
  node: IXMLDOMNode;
  item: TclSoapAddressItem;
  wsu, wsa: string;
begin
  if (Count = 0) then Exit;

  wsu := Config.Namespaces.GetPrefix(wsuNameSpaceName);
  wsa := Config.Namespaces.GetPrefix(wsaNameSpaceName);

  for i := 0 to Count - 1 do
  begin
    item := Items[i];

    if (GetNodeByName(ARoot, item.Name, wsaNameSpaceName) <> nil) then Break;

    node := ARoot.ownerDocument.createElement(GetSoapNodeName(wsa, item.Name));
    ARoot.appendChild(node);

    if (item.ID <> '') then
    begin
      SetAttributeValue(node, GetSoapNodeName(wsu, Config.IdName), item.ID);
    end;

    if (item.Value <> '') then
    begin
      SetNodeText(node, item.Value);
    end;
  end;
end;

constructor TclSoapAddressList.Create(AOwner: TPersistent;
  ItemClass: TCollectionItemClass; AConfig: TclXmlSecurityConfig);
begin
  inherited Create(AOwner, ItemClass);

  FConfig := AConfig;
end;

function TclSoapAddressList.GetItem(Index: Integer): TclSoapAddressItem;
begin
  Result := TclSoapAddressItem(inherited GetItem(Index));
end;

function TclSoapAddressList.ItemById(const AID: string): TclSoapAddressItem;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if (Result.ID = AID) then Exit;
  end;
  Result := nil;
end;

function TclSoapAddressList.ItemByName(const AName: string): TclSoapAddressItem;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if (Result.Name = AName) then Exit;
  end;
  Result := nil;
end;

procedure TclSoapAddressList.Parse(const ARoot: IXMLDOMNode);
var
  list: IXMLDOMNodeList;
  node: IXMLDomNode;
  item: TclSoapAddressItem;
begin
  Clear();

  list := ARoot.childNodes;
  if (list = nil) then Exit;

  node := list.nextNode;
  while (node <> nil) do
  begin
    if SameText(node.namespaceURI, wsaNameSpaceName) then
    begin
      item := Add();
      item.Name := node.baseName;
      item.ID := GetAttributeValue(node, GetSoapNodeName(Config.Namespaces.GetPrefix(wsuNameSpaceName), Config.IdName));
      item.Value := GetNodeText(node);
    end;
    node := list.nextNode;
  end;
end;

procedure TclSoapAddressList.SetItem(Index: Integer; const Value: TclSoapAddressItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TclSoapAddressList.Update(Item: TCollectionItem);
begin
  inherited Update(Item);

  if Assigned(OnChange) then
  begin
    OnChange(Self);
  end;
end;

{ TclSoapAddressItem }

procedure TclSoapAddressItem.Assign(Source: TPersistent);
var
  src: TclSoapAddressItem;
begin
  if (Source is TclSoapAddressItem) then
  begin
    src := TclSoapAddressItem(Source);
    Name := src.Name;
    ID := src.ID;
    Value := src.Value;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclSoapAddressItem.SetID(const Value: string);
begin
  if (FID <> Value) then
  begin
    FID := Value;
    Changed(False);
  end;
end;

procedure TclSoapAddressItem.SetName(const Value: string);
begin
  if (FName <> Value) then
  begin
    FName := Value;
    Changed(False);
  end;
end;

procedure TclSoapAddressItem.SetValue(const AValue: string);
begin
  if (FValue <> AValue) then
  begin
    FValue := AValue;
    Changed(False);
  end;
end;

{ TclSoapSignatureList }

function TclSoapSignatureList.Add: TclSoapSignatureInfo;
begin
  Result := TclSoapSignatureInfo(inherited Add());
end;

function TclSoapSignatureList.GetItem(Index: Integer): TclSoapSignatureInfo;
begin
  Result := TclSoapSignatureInfo(inherited GetItem(Index));
end;

function TclSoapSignatureList.ItemById(const AID: string): TclSoapSignatureInfo;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if (Result.ID = AID) then Exit;
  end;
  Result := nil;
end;

procedure TclSoapSignatureList.SetItem(Index: Integer; const Value: TclSoapSignatureInfo);
begin
  inherited SetItem(Index, Value);
end;

procedure TclSoapSignatureList.Update(Item: TCollectionItem);
begin
  inherited Update(Item);

  if Assigned(OnChange) then
  begin
    OnChange(Self);
  end;
end;

end.

