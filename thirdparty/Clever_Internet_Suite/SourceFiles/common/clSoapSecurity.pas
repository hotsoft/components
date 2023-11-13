{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSoapSecurity;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Windows, Classes, SysUtils, msxml, SyncObjs,
{$ELSE}
  Winapi.Windows, System.Classes, System.SysUtils, Winapi.msxml, System.SyncObjs,
{$ENDIF}
  clCertificate, clCertificateStore, clCryptRandom, clCryptUtils, clUtils, clCryptAPI, clWUtils,
  clXmlCanonicalizerUtils, clXmlCanonicalizer20010315Excl;

type
  TclSignatureStyle = (ssDotNet, ssJava);

  TclPaddingMode = (pmNone, pmZeros, pmPKCS7, pmANSIX923, pmISO10126);

  TclXmlSecurityAlgorithm = class(TCollectionItem)
  private
    FName: string;
    FIdentifier: Integer;

    procedure SetIdentifier(const Value: Integer);
    procedure SetName(const Value: string);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Name: string read FName write SetName;
    property Identifier: Integer read FIdentifier write SetIdentifier;
  end;

  TclXmlSecurityAlgorithmList = class(TOwnedCollection)
  private
    FOnChange: TNotifyEvent;

    function GetItem(Index: Integer): TclXmlSecurityAlgorithm;
    procedure SetItem(Index: Integer; const Value: TclXmlSecurityAlgorithm);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add: TclXmlSecurityAlgorithm;
    function AddAlgorithm(const AName: string; AIdentifier: Integer): TclXmlSecurityAlgorithm;
    function GetIdentifier(const Algorithm: string): Integer;
    function GetAlgorithm(const Algorithm: string): TclXmlSecurityAlgorithm;

    property Items[Index: Integer]: TclXmlSecurityAlgorithm read GetItem write SetItem; default;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TclXmlEncryptionAlgorithm = class(TclXmlSecurityAlgorithm)
  private
    FKeySize: Integer;

    procedure SetKeySize(const Value: Integer);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property KeySize: Integer read FKeySize write SetKeySize;
  end;

  TclXmlEncryptionAlgorithmList = class(TclXmlSecurityAlgorithmList)
  private
    function GetEncryptionItem(Index: Integer): TclXmlEncryptionAlgorithm;
    procedure SetEncryptionItem(Index: Integer; const Value: TclXmlEncryptionAlgorithm);
  public
    function Add: TclXmlEncryptionAlgorithm;
    function AddAlgorithm(const AName: string; AIdentifier, AKeySize: Integer): TclXmlEncryptionAlgorithm;
    function GetAlgorithm(const Algorithm: string): TclXmlEncryptionAlgorithm;

    property Items[Index: Integer]: TclXmlEncryptionAlgorithm read GetEncryptionItem write SetEncryptionItem; default;
  end;

  TclSoapNameSpace = class(TCollectionItem)
  private
    FPrefix: string;
    FNameSpace: string;

    procedure SetNameSpace(const Value: string);
    procedure SetPrefix(const Value: string);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Prefix: string read FPrefix write SetPrefix;
    property NameSpace: string read FNameSpace write SetNameSpace;
  end;

  TclSoapNameSpaceList = class(TOwnedCollection)
  private
    FOnChange: TNotifyEvent;

    function GetItem(Index: Integer): TclSoapNameSpace;
    procedure SetItem(Index: Integer; const Value: TclSoapNameSpace);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add: TclSoapNameSpace;
    function AddNameSpace(const APrefix, ANameSpace: string): TclSoapNameSpace;
    function ItemByNameSpace(const ANameSpace: string): TclSoapNameSpace;
    function GetPrefix(const ANameSpace: string): string;
{$IFDEF DELPHI2009}
    function ToString: string; override;
{$ELSE}
    function ToString: string; virtual;
{$ENDIF}

    property Items[Index: Integer]: TclSoapNameSpace read GetItem write SetItem; default;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TclXmlSecurityConfig = class(TPersistent)
  private
    FIdName: string;
    FPaddingMode: TclPaddingMode;
    FProviderType: Integer;
    FCSP: string;
    FSignatureStyle: TclSignatureStyle;
    FOnChange: TNotifyEvent;
    FHashAlgorithms: TclXmlSecurityAlgorithmList;
    FCryptAlgorithms: TclXmlEncryptionAlgorithmList;
    FNamespaces: TclSoapNameSpaceList;
    FCSPPtr: PclChar;
    FOwner: TPersistent;

    procedure SetCSP(const Value: string);
    procedure SetIdName(const Value: string);
    procedure SetPaddingMode(const Value: TclPaddingMode);
    procedure SetProviderType(const Value: Integer);
    procedure SetSignatureStyle(const Value: TclSignatureStyle);
    procedure SetCryptAlgorithms(const Value: TclXmlEncryptionAlgorithmList);
    procedure SetHashAlgorithms(const Value: TclXmlSecurityAlgorithmList);
    procedure SetNamespaces(const Value: TclSoapNameSpaceList);
  protected
    function GetOwner: TPersistent; override;
    procedure Update; virtual;
    procedure AssignDefaultAlgorithms; virtual;
    procedure AssignDefaultNamespaces; virtual;
  public
    constructor Create(AOwner: TPersistent);
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    function GetCSP: PclChar;
  published
    property IdName: string read FIdName write SetIdName;
    property PaddingMode: TclPaddingMode read FPaddingMode write SetPaddingMode default pmISO10126;
    property CSP: string read FCSP write SetCSP;
    property ProviderType: Integer read FProviderType write SetProviderType default PROV_RSA_FULL;
    property HashAlgorithms: TclXmlSecurityAlgorithmList read FHashAlgorithms write SetHashAlgorithms;
    property CryptAlgorithms: TclXmlEncryptionAlgorithmList read FCryptAlgorithms write SetCryptAlgorithms;
    property SignatureStyle: TclSignatureStyle read FSignatureStyle write SetSignatureStyle default ssJava;
    property Namespaces: TclSoapNameSpaceList read FNamespaces write SetNamespaces;

    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TclXmlKeyInfoClass = class of TclXmlKeyInfo;

  TclXmlKeyInfo = class
  private
    FID: string;
    FSecurityTokenReferenceID: string;
    FConfig: TclXmlSecurityConfig;
    FNamespaces: TclNameSpaceSymbTable;

    function GetIdName: string;
    procedure InitNamespaces(const AOwnerNode: IXMLDOMNode);
  protected
    function DoParse(const AKeyInfo, ASecurity: IXMLDOMNode): Boolean; virtual;
    procedure AddNamespaceIfNeed(const ANode: IXMLDOMNode; const APrefix, AUri: string);
  public
    class function Parse(const AKeyInfo, ASecurity: IXMLDOMNode; AConfig: TclXmlSecurityConfig): TclXmlKeyInfo;
    class procedure RegisterKeyInfo(AKeyInfoClass: TclXmlKeyInfoClass);
    class function RegisteredKeyInfo: TList;

    constructor Create(AConfig: TclXmlSecurityConfig); virtual;
    destructor Destroy; override;

    function Build(const AOwnerNode, ASecurity: IXMLDOMNode): IXMLDOMNode; virtual;

    function GetCertificate(AStore: TclCertificateStore): TclCertificate; virtual; abstract;
    procedure AssignCertificate(ACertificate: TclCertificate); virtual; abstract;

    property Config: TclXmlSecurityConfig read FConfig;
    property ID: string read FID write FID;
    property SecurityTokenReferenceID: string read FSecurityTokenReferenceID write FSecurityTokenReferenceID;
  end;

  TclXmlThumbprintKeyInfo = class(TclXmlKeyInfo)
  private
    FThumbprint: string;
  protected
    function DoParse(const AKeyInfo, ASecurity: IXMLDOMNode): Boolean; override;
  public
    function Build(const AOwnerNode, ASecurity: IXMLDOMNode): IXMLDOMNode; override;

    function GetCertificate(AStore: TclCertificateStore): TclCertificate; override;
    procedure AssignCertificate(ACertificate: TclCertificate); override;

    property Thumbprint: string read FThumbprint write FThumbprint;
  end;

  TclXmlSKIKeyInfo = class(TclXmlKeyInfo)
  private
    FSubjectKeyIdentifier: string;
  protected
    function DoParse(const AKeyInfo, ASecurity: IXMLDOMNode): Boolean; override;
  public
    function Build(const AOwnerNode, ASecurity: IXMLDOMNode): IXMLDOMNode; override;

    function GetCertificate(AStore: TclCertificateStore): TclCertificate; override;
    procedure AssignCertificate(ACertificate: TclCertificate); override;

    property SubjectKeyIdentifier: string read FSubjectKeyIdentifier write FSubjectKeyIdentifier;
  end;

  TclXmlX509KeyInfo = class(TclXmlKeyInfo)
  private
    FEncodedCertificate: string;
    FURI: string;

    function BuildBinarySecurityToken(const ASecurity: IXMLDOMNode): IXMLDOMNode;
  protected
    function DoParse(const AKeyInfo, ASecurity: IXMLDOMNode): Boolean; override;
  public
    function Build(const AOwnerNode, ASecurity: IXMLDOMNode): IXMLDOMNode; override;

    function GetCertificate(AStore: TclCertificateStore): TclCertificate; override;
    procedure AssignCertificate(ACertificate: TclCertificate); override;

    property URI: string read FURI write FURI;
    property EncodedCertificate: string read FEncodedCertificate write FEncodedCertificate;
  end;

  TclXmlEncryptedKeyInfo = class(TclXmlKeyInfo)
  private
    FURI: string;
  protected
    function DoParse(const AKeyInfo, ASecurity: IXMLDOMNode): Boolean; override;
  public
    function Build(const AOwnerNode, ASecurity: IXMLDOMNode): IXMLDOMNode; override;

    function GetCertificate(AStore: TclCertificateStore): TclCertificate; override;
    procedure AssignCertificate(ACertificate: TclCertificate); override;

    property URI: string read FURI write FURI;
  end;

  TclXmlEncryptReference = class(TCollectionItem)
  private
    FEncryptionMethod: string;
    FURI: string;
    FEncryptedDataURI: string;
    FEncryptionType: string;

    procedure SetEncryptionMethod(const Value: string);
    procedure SetURI(const Value: string);
    procedure SetEncryptedDataURI(const Value: string);
    procedure SetEncryptionType(const Value: string);
  public
    constructor Create(Collection: TCollection); override;

    procedure Assign(Source: TPersistent); override;
  published
    property URI: string read FURI write SetURI;
    property EncryptedDataURI: string read FEncryptedDataURI write SetEncryptedDataURI;
    property EncryptionMethod: string read FEncryptionMethod write SetEncryptionMethod;
    property EncryptionType: string read FEncryptionType write SetEncryptionType;
  end;

  TclXmlEncryptReferenceList = class(TOwnedCollection)
  private
    FOnChange: TNotifyEvent;

    function GetItem(Index: Integer): TclXmlEncryptReference;
    procedure SetItem(Index: Integer; const Value: TclXmlEncryptReference);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add: TclXmlEncryptReference; overload;
    function Add(const AURI: string): TclXmlEncryptReference; overload;
    function Add(const AURI, AEncryptionMethod: string): TclXmlEncryptReference; overload;

    property Items[Index: Integer]: TclXmlEncryptReference read GetItem write SetItem; default;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TclXmlEncryptedKeyClass = class of TclXmlEncryptedKey;

  TclXmlEncryptedKey = class
  private
    FReferenceList: TclXmlEncryptReferenceList;
    FSessionKey: TclCryptData;
    FEncryptionMethod: string;
    FKeyInfo: TclXmlKeyInfo;
    FID: string;
    FConfig: TclXmlSecurityConfig;
    FCipherValue: string;
    FEncryptedKey: IXMLDOMNode;

    function ParseEncryptedData(const AData: IXMLDOMNode; AReferenceItem: TclXmlEncryptReference): string;
    procedure ParseEncryptedKey(const AEncryptedKey: IXMLDOMNode);
    procedure ParseReferenceList(const AEncryptedKey: IXMLDOMNode);
    procedure ParseKeyInfo(const AEncryptedKey, ASecurity: IXMLDOMNode);
    procedure SetKeyInfo(const Value: TclXmlKeyInfo);
    procedure SetSessionKey(Value: TclCryptData);
    procedure CheckReferenceList;
    procedure CreateSessionKey;
    function GetSessionKeySize: Integer;
    procedure BuildKeyInfo(ACertificate: TclCertificate; const ASignature, ASecurity: IXMLDOMNode);
    procedure BuildReferenceItem(AReferenceItem: TclXmlEncryptReference;
      const AOwnerNode: IXMLDOMNode);
    procedure BuildReferenceList(const AOwnerNode: IXMLDOMNode);
    procedure BuildEncryptedKey(const AEncKeyNode: IXMLDOMNode);
    function IsContent(const AEncryptionType: string): Boolean;
    procedure BuildKeyInfoReference(const AOwnerNode: IXMLDOMNode);
    function BuildEncryptedData(const AData: IXMLDOMNode; AReferenceItem: TclXmlEncryptReference): IXMLDOMNode;
  protected
    function DoParse(const ASecurity: IXMLDOMNode): Boolean; virtual;
    function DoSelectReferenceData(const AURI: string; const AEnvelope: IXMLDOMDocument): IXMLDOMNode; virtual;
    procedure DoDecryptSessionKey(ACertificate: TclCertificate; const AStoreName: string;
      AStoreLocation: TclCertificateStoreLocation); virtual; abstract;
    function DoEncryptSessionKey(ACertificate: TclCertificate; const AStoreName: string;
      AStoreLocation: TclCertificateStoreLocation): string; virtual; abstract;
    function SupportsMethod(const ASignatureMethod: string): Boolean; virtual; abstract;
    function GenerateEncryptedDataURI: string; virtual;
    function GetXmlToEncrypt(const AData: IXMLDOMNode; AReferenceItem: TclXmlEncryptReference): WideString; virtual;
  public
    class function Parse(const ASecurity: IXMLDOMNode;
      AReferenceList: TclXmlEncryptReferenceList; AConfig: TclXmlSecurityConfig): TclXmlEncryptedKey;
    class procedure RegisterEncryptedKey(AEncryptedKeyClass: TclXmlEncryptedKeyClass);
    class function RegisteredEncryptedKeys: TList;
    class function CreateInstance(const AEncryptionMethod: string;
      AReferenceList: TclXmlEncryptReferenceList; AConfig: TclXmlSecurityConfig): TclXmlEncryptedKey;

    constructor Create(AReferenceList: TclXmlEncryptReferenceList; AConfig: TclXmlSecurityConfig); virtual;
    destructor Destroy; override;

    procedure EncryptSessionKey(ACertificate: TclCertificate; const AStoreName: string;
      AStoreLocation: TclCertificateStoreLocation; const ASecurity: IXMLDOMNode);
    procedure DecryptSessionKey(ACertificate: TclCertificate; const AStoreName: string;
      AStoreLocation: TclCertificateStoreLocation);

    function Decrypt(const AEnvelope: IXMLDOMDocument; const ACharSet: string): string; virtual;
    procedure Encrypt(const AEnvelope: IXMLDOMDocument; const ACharSet: string); virtual;

    procedure Clear(); virtual;

    property ID: string read FID write FID;
    property EncryptionMethod: string read FEncryptionMethod write FEncryptionMethod;
    property CipherValue: string read FCipherValue write FCipherValue;
    property KeyInfo: TclXmlKeyInfo read FKeyInfo write SetKeyInfo;
    property SessionKey: TclCryptData read FSessionKey write SetSessionKey;
    property SessionKeySize: Integer read GetSessionKeySize;
    property ReferenceList: TclXmlEncryptReferenceList read FReferenceList;
    property Config: TclXmlSecurityConfig read FConfig;
  end;

  TclXmlEncryptedKeyRSA = class(TclXmlEncryptedKey)
  private
    function IsOAEP: Boolean;
  protected
    procedure DoDecryptSessionKey(ACertificate: TclCertificate; const AStoreName: string;
      AStoreLocation: TclCertificateStoreLocation); override;
    function DoEncryptSessionKey(ACertificate: TclCertificate; const AStoreName: string;
      AStoreLocation: TclCertificateStoreLocation): string; override;
    function SupportsMethod(const AEncryptionMethod: string): Boolean; override;
  end;

  TclXmlEncryptedDataClass = class of TclXmlEncryptedData;

  TclXmlEncryptedData = class
  private
    FEncryptionMethod: string;
    FDecryptedData: TclCryptData;
    FConfig: TclXmlSecurityConfig;

    procedure SetDecryptedData(const Value: TclCryptData);
  protected
    function DoEncrypt(ASessionKey: TclCryptData): string; virtual; abstract;
    procedure DoDecrypt(const AData: string; ASessionKey: TclCryptData; const ACharSet: string); virtual; abstract;
    procedure DepadBlock(AData: TclCryptData);
    function PadBlock(AData: TclCryptData): TclCryptData;
    function GetBlockSize: Integer; virtual; abstract;
    function GetKeySize: Integer; virtual;
    function SupportsMethod(const AEncryptionMethod: string): Boolean; virtual; abstract;
  public
    class function DecryptData(const AEncryptionMethod, AData: string; ASessionKey: TclCryptData;
      const ACharSet: string; AConfig: TclXmlSecurityConfig): TclXmlEncryptedData;
    class procedure RegisterEncryptedData(AEncryptedDataClass: TclXmlEncryptedDataClass);
    class function RegisteredEncryptedData: TList;
    class function CreateInstance(const AEncryptionMethod: string; AConfig: TclXmlSecurityConfig): TclXmlEncryptedData;

    function EncryptData(const AData: string; ASessionKey: TclCryptData; const ACharSet: string): string;

    constructor Create(AConfig: TclXmlSecurityConfig); virtual;
    destructor Destroy; override;

    procedure Clear; virtual;

    function CreateSessionKey: TclCryptData; virtual; abstract;

    property Config: TclXmlSecurityConfig read FConfig;

    property EncryptionMethod: string read FEncryptionMethod write FEncryptionMethod;

    property DecryptedData: TclCryptData read FDecryptedData write SetDecryptedData;
    property BlockSize: Integer read GetBlockSize;
    property KeySize: Integer read GetKeySize;
  end;

  TclXmlEncryptedDataAES = class(TclXmlEncryptedData)
  private
    function GetKeyAlgorithm: DWORD;
    function GetCipherMode: DWORD;
    procedure ImportKeyData(hProvider: HCRYPTPROV; Algid: ALG_ID;
      pbKeyData: PBYTE; cbKeyData: DWORD; phKey: PHCRYPTKEY);
  protected
    function DoEncrypt(ASessionKey: TclCryptData): string; override;
    procedure DoDecrypt(const AData: string; ASessionKey: TclCryptData; const ACharSet: string); override;
    function GetBlockSize: Integer; override;
    function GetKeySize: Integer; override;
    function SupportsMethod(const AEncryptionMethod: string): Boolean; override;
    function CreateIV: TclCryptData; virtual;
  public
    function CreateSessionKey: TclCryptData; override;
  end;

  TclXmlEncryptedDataList = class
  private
    FList: TStrings;

    function GetData(Index: Integer): TclXmlEncryptedData;
    function GetID(Index: Integer): string;
    function GetCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure Add(const AID: string; AData: TclXmlEncryptedData);
    procedure Delete(Index: Integer);

    property ID[Index: Integer]: string read GetID;
    property Data[Index: Integer]: TclXmlEncryptedData read GetData;
    property Count: Integer read GetCount;
  end;

  TclXmlTransformInfo = class(TCollectionItem)
  private
    FParameters: string;
    FAlgorithm: string;

    procedure SetAlgorithm(const Value: string);
    procedure SetParameters(const Value: string);
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Algorithm: string read FAlgorithm write SetAlgorithm;
    property Parameters: string read FParameters write SetParameters;
  end;

  TclXmlTransformInfoList = class(TOwnedCollection)
  private
    FOnChange: TNotifyEvent;

    function GetItem(Index: Integer): TclXmlTransformInfo;
    procedure SetItem(Index: Integer; const Value: TclXmlTransformInfo);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add: TclXmlTransformInfo; overload;
    function Add(const Algorithm: string): TclXmlTransformInfo; overload;
    function Add(const Algorithm, AParameters: string): TclXmlTransformInfo; overload;

    property Items[Index: Integer]: TclXmlTransformInfo read GetItem write SetItem; default;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TclXmlSignReference = class(TCollectionItem)
  private
    FDigestMethod: string;
    FDigestValue: string;
    FURI: string;
    FTransforms: TclXmlTransformInfoList;

    procedure DoTransformsChanged(Sender: TObject);
    procedure SetDigestMethod(const Value: string);
    procedure SetDigestValue(const Value: string);
    procedure SetTransforms(const Value: TclXmlTransformInfoList);
    procedure SetURI(const Value: string);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;

    property DigestValue: string read FDigestValue write SetDigestValue;
  published
    property URI: string read FURI write SetURI;
    property DigestMethod: string read FDigestMethod write SetDigestMethod;
    property Transforms: TclXmlTransformInfoList read FTransforms write SetTransforms;
  end;

  TclXmlSignReferenceList = class(TOwnedCollection)
  private
    FOnChange: TNotifyEvent;

    function GetItem(Index: Integer): TclXmlSignReference;
    procedure SetItem(Index: Integer; const Value: TclXmlSignReference);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    function Add: TclXmlSignReference; overload;
    function Add(const AURI: string): TclXmlSignReference; overload;

    property Items[Index: Integer]: TclXmlSignReference read GetItem write SetItem; default;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TclXmlSignatureClass = class of TclXmlSignature;

  TclXmlSignature = class
  private
    FConfig: TclXmlSecurityConfig;
    FSignatureValue: string;
    FID: string;
    FKeyInfo: TclXmlKeyInfo;
    FSignatureMethod: string;
    FReferenceList: TclXmlSignReferenceList;
    FCanonicalizationMethod: string;
    FSignedInfo: IXMLDOMNode;
    FSignature: IXMLDOMNode;

    procedure SetKeyInfo(const Value: TclXmlKeyInfo);

    procedure VerifyReferenceDigests(const AEnvelope: IXMLDOMDocument);

    procedure ParseSignature(const ASignature, ASignedInfo: IXMLDOMNode);
    procedure ParseTransforms(const AReferenceNode: IXMLDOMNode; AReferenceItem: TclXmlSignReference);
    procedure ParseReferenceItem(const AReferenceNode: IXMLDOMNode; AReferenceItem: TclXmlSignReference);
    procedure ParseReferenceList(const ASignedInfo: IXMLDOMNode);
    procedure ParseKeyInfo(const ASignature, ASecurity: IXMLDOMNode);

    function BuildSignedInfo(const ASignature: IXMLDOMNode): IXMLDOMNode;
    procedure BuildTransforms(AReferenceItem: TclXmlSignReference; const ARefNode: IXMLDOMNode);
    procedure BuildReferenceItem(AReferenceItem: TclXmlSignReference;
      const AOwnerNode: IXMLDOMNode; const AEnvelope: IXMLDOMDocument);
    procedure BuildReferenceList(const AOwnerNode: IXMLDOMNode; const AEnvelope: IXMLDOMDocument);
    procedure BuildKeyInfo(ACertificate: TclCertificate; const ASignature, ASecurity: IXMLDOMNode);
  protected
    function DoParse(const ASecurity, ASignature: IXMLDOMNode): Boolean; virtual;
    function DoSelectReferenceData(const AURI: string; const AEnvelope: IXMLDOMDocument): IXMLDOMNode; virtual;
    procedure DoVerifySignature(ACertificate: TclCertificate; const ASignedInfo: IXMLDOMNode); virtual; abstract;
    procedure DoVerifyReferenceDigest(AReferenceItem: TclXmlSignReference; const AEnvelope: IXMLDOMDocument); virtual;
    procedure DoCreateReferenceDigest(AReferenceItem: TclXmlSignReference; const AEnvelope: IXMLDOMDocument); virtual;
    procedure DoCreateSignature(ACertificate: TclCertificate; const ASignedInfo: IXMLDOMNode); virtual; abstract;
    function SupportsMethod(const ASignatureMethod: string): Boolean; virtual; abstract;
  public
    class function Parse(const ASecurity, ASignature: IXMLDOMNode;
      AReferenceList: TclXmlSignReferenceList; AConfig: TclXmlSecurityConfig): TclXmlSignature;
    class procedure RegisterSignature(ASignatureClass: TclXmlSignatureClass);
    class function RegisteredSignatures: TList;
    class function CreateInstance(const ASignatureMethod: string;
      AReferenceList: TclXmlSignReferenceList; AConfig: TclXmlSecurityConfig): TclXmlSignature;

    constructor Create(AReferenceList: TclXmlSignReferenceList; AConfig: TclXmlSecurityConfig); virtual;
    destructor Destroy; override;

    procedure Verify(ACertificate: TclCertificate; const AEnvelope: IXMLDOMDocument);
    procedure Sign(ACertificate: TclCertificate; const AEnvelope: IXMLDOMDocument);

    procedure Clear(); virtual;

    property KeyInfo: TclXmlKeyInfo read FKeyInfo write SetKeyInfo;
    property SignatureValue: string read FSignatureValue write FSignatureValue;

    property ID: string read FID write FID;
    property CanonicalizationMethod: string read FCanonicalizationMethod write FCanonicalizationMethod;
    property SignatureMethod: string read FSignatureMethod write FSignatureMethod;
    property ReferenceList: TclXmlSignReferenceList read FReferenceList;

    property Config: TclXmlSecurityConfig read FConfig;
  end;

  TclXmlSignatureRSA = class(TclXmlSignature)
  private
    procedure VerifySignatureValue(ACertificate: TclCertificate; const AData, ASignature: TclByteArray);
    procedure VerifySignature(ACertificate: TclCertificate; const AData: IXMLDOMNode; const ASignature: string);

    function GetSignatureValue(ACertificate: TclCertificate; const AXml: TclByteArray): TclByteArray;
    function CreateSignature(ACertificate: TclCertificate; const AData: IXMLDOMNode): string;
  protected
    procedure DoVerifySignature(ACertificate: TclCertificate; const ASignedInfo: IXMLDOMNode); override;
    procedure DoCreateSignature(ACertificate: TclCertificate; const ASignedInfo: IXMLDOMNode); override;
    function SupportsMethod(const ASignatureMethod: string): Boolean; override;
  end;

  TclXmlTransformData = class
  private
    FNode: IXMLDOMNode;
    FBytes: TclByteArray;

    procedure SetBytes(const Value: TclByteArray);
    procedure SetNode(const Value: IXMLDOMNode);
  public
    property Node: IXMLDOMNode read FNode write SetNode;
    property Bytes: TclByteArray read FBytes write SetBytes;
  end;

  TclXmlTransformClass = class of TclXmlTransform;

  TclXmlTransform = class
  private
    FConfig: TclXmlSecurityConfig;
  protected
    function DoTransform(const Algorithm, AParameters: string; AData: TclXmlTransformData): Boolean; virtual; abstract;
  public
    class procedure Transform(const Algorithm, AParameters: string;
      AData: TclXmlTransformData; AConfig: TclXmlSecurityConfig); overload;
    class procedure Transform(ATransformInfo: TclXmlTransformInfo;
      AData: TclXmlTransformData; AConfig: TclXmlSecurityConfig); overload;

    class procedure RegisterTransform(ATransformClass: TclXmlTransformClass);
    class function RegisteredTransforms: TList;

    constructor Create(AConfig: TclXmlSecurityConfig); virtual;

    property Config: TclXmlSecurityConfig read FConfig;
  end;

  TclXmlTransformC14nExcl = class(TclXmlTransform)
  protected
    function DoTransform(const Algorithm, AParameters: string; AData: TclXmlTransformData): Boolean; override;
  end;

  TclXmlDigest = class
  private
    FConfig: TclXmlSecurityConfig;

    function GetDigestValue(const AXml: TclByteArray; AlgId: Integer): TclByteArray;
    procedure VerifyDigestValue(const ADigestMethod: string; const AXml: TclByteArray; const ADigestValue: string);
    procedure ApplyTransforms(ATransforms: TclXmlTransformInfoList; AData: TclXmlTransformData);
  public
    constructor Create(AConfig: TclXmlSecurityConfig);
    procedure Verify(ASignReference: TclXmlSignReference; const AData: IXMLDOMNode); virtual;
    procedure CreateDigest(ASignReference: TclXmlSignReference; const AData: IXMLDOMNode); virtual;

    property Config: TclXmlSecurityConfig read FConfig;
  end;

procedure InitSoapSecurity;

implementation

uses
  clCryptExt, clSoapUtils, clEncoder, clXmlUtils, clTranslator;

var
  RegXmlKeyInfo: TList = nil;
  RegXmlEncryptedData: TList = nil;
  RegXmlEncryptedKeys: TList = nil;
  RegXmlSignatures: TList = nil;
  RegXmlTransforms: TList = nil;

  InitAccessor: TCriticalSection = nil;
  SoapSecurityInitialized: Boolean = false;

procedure InitSoapSecurity;
begin
  InitAccessor.Enter();
  try
    if not SoapSecurityInitialized then
    begin
      TclXmlKeyInfo.RegisterKeyInfo(TclXmlSKIKeyInfo);
      TclXmlKeyInfo.RegisterKeyInfo(TclXmlX509KeyInfo);
      TclXmlKeyInfo.RegisterKeyInfo(TclXmlThumbprintKeyInfo);
      TclXmlKeyInfo.RegisterKeyInfo(TclXmlEncryptedKeyInfo);

      TclXmlEncryptedKey.RegisterEncryptedKey(TclXmlEncryptedKeyRSA);

      TclXmlEncryptedData.RegisterEncryptedData(TclXmlEncryptedDataAES);

      TclXmlSignature.RegisterSignature(TclXmlSignatureRSA);

      TclXmlTransform.RegisterTransform(TclXmlTransformC14nExcl);

      SoapSecurityInitialized := True;
    end;
  finally
    InitAccessor.Leave();
  end;
end;

{ TclXmlEncryptor }

procedure TclXmlEncryptedKey.Clear;
begin
  ID := '';
  EncryptionMethod := '';
  CipherValue := '';

  SessionKey := nil;
  KeyInfo := nil;
  ReferenceList.Clear();
end;

constructor TclXmlEncryptedKey.Create(AReferenceList: TclXmlEncryptReferenceList; AConfig: TclXmlSecurityConfig);
begin
  inherited Create();

  FReferenceList := AReferenceList;
  FConfig := AConfig;
end;

class function TclXmlEncryptedKey.CreateInstance(const AEncryptionMethod: string;
  AReferenceList: TclXmlEncryptReferenceList; AConfig: TclXmlSecurityConfig): TclXmlEncryptedKey;
var
  i: Integer;
begin
  Result := nil;

  for i := 0 to RegisteredEncryptedKeys().Count - 1 do
  begin
    Result := TclXmlEncryptedKeyClass(RegisteredEncryptedKeys()[i]).Create(AReferenceList, AConfig);
    try
      if Result.SupportsMethod(AEncryptionMethod) then
      begin
        Result.EncryptionMethod := AEncryptionMethod;
        Break;
      end;
      FreeAndNil(Result);
    except
      Result.Free();
      raise;
    end;
  end;

  if (Result = nil) then
  begin
    raise EclSoapMessageError.Create(EncryptionMethodError, EncryptionMethodErrorCode);
  end;
end;

procedure TclXmlEncryptedKey.BuildEncryptedKey(const AEncKeyNode: IXMLDOMNode);
var
  node: IXMLDOMNode;
begin
  node := AEncKeyNode.ownerDocument.createElement(GetSoapNodeName(Config.Namespaces.GetPrefix(xencNameSpaceName), 'EncryptionMethod'));
  AEncKeyNode.appendChild(node);
  SetAttributeValue(node, 'Algorithm', EncryptionMethod);
end;

procedure TclXmlEncryptedKey.BuildKeyInfo(ACertificate: TclCertificate;
  const ASignature, ASecurity: IXMLDOMNode);
begin
  if (KeyInfo <> nil) then
  begin
    KeyInfo.AssignCertificate(ACertificate);
    KeyInfo.Build(ASignature, ASecurity);
  end;
end;

procedure TclXmlEncryptedKey.BuildReferenceItem(AReferenceItem: TclXmlEncryptReference;
  const AOwnerNode: IXMLDOMNode);
var
  refNode: IXMLDOMNode;
begin
  refNode := AOwnerNode.ownerDocument.createElement(GetSoapNodeName(Config.Namespaces.GetPrefix(xencNameSpaceName), 'DataReference'));
  AOwnerNode.appendChild(refNode);

  if (AReferenceItem.EncryptedDataURI = '') then
  begin
    AReferenceItem.EncryptedDataURI := GenerateEncryptedDataURI();
  end;

  SetAttributeValue(refNode, 'URI', AReferenceItem.EncryptedDataURI);
end;

procedure TclXmlEncryptedKey.BuildReferenceList(const AOwnerNode: IXMLDOMNode);
var
  i: Integer;
  refListNode: IXMLDOMNode;
begin
  refListNode := AOwnerNode.ownerDocument.createElement(GetSoapNodeName(Config.Namespaces.GetPrefix(xencNameSpaceName), 'ReferenceList'));
  AOwnerNode.appendChild(refListNode);

  for i := 0 to ReferenceList.Count - 1 do
  begin
    BuildReferenceItem(ReferenceList[i], refListNode);
  end;
end;

procedure TclXmlEncryptedKey.CheckReferenceList;
var
  i: Integer;
  encMethod: string;
begin
  encMethod := '';

  for i := 0 to ReferenceList.Count - 1 do
  begin
    if (encMethod = '') then
    begin
      encMethod := ReferenceList[i].EncryptionMethod;
    end;
    if (encMethod <> ReferenceList[i].EncryptionMethod) then
    begin
      raise EclSoapMessageError.Create(MultipleEncryptKeysError, MultipleEncryptKeysErrorCode);
    end;
  end;

  if (encMethod = '') then
  begin
    raise EclSoapMessageError.Create(EncryptionMethodError, EncryptionMethodErrorCode);
  end;
end;

procedure TclXmlEncryptedKey.CreateSessionKey;
var
  encData: TclXmlEncryptedData;
begin
  CheckReferenceList();

  encData := TclXmlEncryptedData.CreateInstance(ReferenceList[0].EncryptionMethod, Config);
  try
    SessionKey := encData.CreateSessionKey();
  finally
    encData.Free();
  end;
end;

function TclXmlEncryptedKey.Decrypt(const AEnvelope: IXMLDOMDocument; const ACharSet: string): string;
var
  i: Integer;
  data, container: IXMLDOMNode;
  decData: TclXmlEncryptedData;
  decDataList: TclXmlEncryptedDataList;
  cipherValue: string;
begin
  decDataList := TclXmlEncryptedDataList.Create();
  try
    for i := 0 to ReferenceList.Count - 1 do
    begin
      data := DoSelectReferenceData(ReferenceList[i].EncryptedDataURI, AEnvelope);

      container := AEnvelope.createElement(data.nodeName);
      container.text := GetAttributeText(Config.IdName, UriReference2Id(ReferenceList[i].EncryptedDataURI));

      cipherValue := ParseEncryptedData(data, ReferenceList[i]);

      decData := TclXmlEncryptedData.DecryptData(ReferenceList[i].EncryptionMethod, cipherValue, Self.SessionKey, ACharSet, Config);
      decDataList.Add(string(container.xml), decData);

      data.parentNode.replaceChild(container, data);
    end;

    Result := string(XmlCrlfDecode(AEnvelope.xml));

    for i := 0 to decDataList.Count - 1 do
    begin
      decData := decDataList.Data[i];
      Result := StringReplace(Result, decDataList.ID[i], decData.DecryptedData.ToString(), []);
    end;
  finally
    decDataList.Free();
  end;
end;

procedure TclXmlEncryptedKey.DecryptSessionKey(ACertificate: TclCertificate;
  const AStoreName: string; AStoreLocation: TclCertificateStoreLocation);
begin
  RemoveNode(FEncryptedKey);
  DoDecryptSessionKey(ACertificate, AStoreName, AStoreLocation);
end;

destructor TclXmlEncryptedKey.Destroy;
begin
  SessionKey := nil;
  KeyInfo := nil;

  inherited Destroy();
end;

function TclXmlEncryptedKey.DoParse(const ASecurity: IXMLDOMNode): Boolean;
begin
  Clear();

  if (ASecurity = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  FEncryptedKey := GetNodeByName(ASecurity, 'EncryptedKey');
  if (FEncryptedKey = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  ParseEncryptedKey(FEncryptedKey);
  ParseReferenceList(FEncryptedKey);
  ParseKeyInfo(FEncryptedKey, ASecurity);

  Result := SupportsMethod(EncryptionMethod);
end;

function TclXmlEncryptedKey.DoSelectReferenceData(const AURI: string; const AEnvelope: IXMLDOMDocument): IXMLDOMNode;
var
  s: string;
begin
  s := UriReference2Id(AURI);

  Result := AEnvelope.selectSingleNode('//*[@' + GetAttributeText(GetSoapNodeName(Config.Namespaces.GetPrefix(wsuNameSpaceName), Config.IdName), s) + ']');
  if (Result = nil) then
  begin
    Result := AEnvelope.selectSingleNode('//*[@' + GetAttributeText(Config.IdName, s) + ']');
    if (Result = nil) then
    begin
      raise EclSoapMessageError.Create(SoapDataNotFound, SoapDataNotFoundCode);
    end;
  end;
end;

procedure TclXmlEncryptedKey.BuildKeyInfoReference(const AOwnerNode: IXMLDOMNode);
var
  encKeyInfo: TclXmlEncryptedKeyInfo;
begin
  if (KeyInfo <> nil) and (ID <> '') then
  begin
    encKeyInfo := TclXmlEncryptedKeyInfo.Create(Config);
    try
      encKeyInfo.URI := Id2UriReference(ID);
      encKeyInfo.Build(AOwnerNode, nil);
    finally
      encKeyInfo.Free();
    end;
  end;
end;

function TclXmlEncryptedKey.BuildEncryptedData(const AData: IXMLDOMNode; AReferenceItem: TclXmlEncryptReference): IXMLDOMNode;
var
  node: IXMLDOMNode;
  xencNameSpace: string;
begin
  xencNameSpace := Config.Namespaces.GetPrefix(xencNameSpaceName);

  Result := AData.ownerDocument.createElement(GetSoapNodeName(xencNameSpace, 'EncryptedData'));
  AData.appendChild(Result);

  SetAttributeValue(Result, Config.IdName, UriReference2Id(AReferenceItem.EncryptedDataURI));

  SetAttributeValue(Result, GetSoapNamespace(xencNameSpace), xencNameSpaceName);

  SetAttributeValue(Result, 'Type', AReferenceItem.EncryptionType);

  node := Result.ownerDocument.createElement(GetSoapNodeName(xencNameSpace, 'EncryptionMethod'));
  Result.appendChild(node);
  SetAttributeValue(node, 'Algorithm', AReferenceItem.EncryptionMethod);
end;

function TclXmlEncryptedKey.GetXmlToEncrypt(const AData: IXMLDOMNode; AReferenceItem: TclXmlEncryptReference): WideString;
var
  node: IXMLDOMNode;
begin
  if IsContent(AReferenceItem.EncryptionType) then
  begin
    Result := '';
    node := AData.childNodes.nextNode;
    while (node <> nil) do
    begin
      Result := Result + node.xml;
      RemoveNode(node);
      node := AData.childNodes.nextNode;
    end;
  end else
  begin
    Result := AData.xml;
  end;
end;

procedure TclXmlEncryptedKey.Encrypt(const AEnvelope: IXMLDOMDocument; const ACharSet: string);
var
  i: Integer;
  data, encDataNode, cipherDataNode: IXMLDOMNode;
  refItem: TclXmlEncryptReference;
  encData: TclXmlEncryptedData;
  cipherValue: string;
  dataXml: WideString;
  xencNameSpace: string;
begin
  for i := 0 to ReferenceList.Count - 1 do
  begin
    refItem := ReferenceList[i];
    data := DoSelectReferenceData(refItem.URI, AEnvelope);

    dataXml := GetXmlToEncrypt(data, refItem);

    encDataNode := BuildEncryptedData(data, refItem);

    BuildKeyInfoReference(encDataNode);

    encData := TclXmlEncryptedData.CreateInstance(refItem.EncryptionMethod, Config);
    try
      cipherValue := encData.EncryptData(string(dataXml), SessionKey, ACharSet);

      xencNameSpace := Config.Namespaces.GetPrefix(xencNameSpaceName);

      cipherDataNode := encDataNode.ownerDocument.createElement(GetSoapNodeName(xencNameSpace, 'CipherData'));
      encDataNode.appendChild(cipherDataNode);

      AddNodeValue(cipherDataNode, GetSoapNodeName(xencNameSpace, 'CipherValue'), cipherValue);
    finally
      encData.Free();
    end;
  end;
end;

procedure TclXmlEncryptedKey.EncryptSessionKey(ACertificate: TclCertificate; const AStoreName: string;
  AStoreLocation: TclCertificateStoreLocation; const ASecurity: IXMLDOMNode);
var
  encKeyNode, cipherDataNode: IXMLDOMNode;
  xencNameSpace: string;
begin
  CreateSessionKey();

  if (ASecurity = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  xencNameSpace := Config.Namespaces.GetPrefix(xencNameSpaceName);

  encKeyNode := ASecurity.ownerDocument.createElement(GetSoapNodeName(xencNameSpace, 'EncryptedKey'));
  ASecurity.appendChild(encKeyNode);

  SetAttributeValue(encKeyNode, GetSoapNamespace(xencNameSpace), xencNameSpaceName);
  SetAttributeValue(encKeyNode, Config.IdName, ID);

  BuildEncryptedKey(encKeyNode);

  BuildKeyInfo(ACertificate, encKeyNode, ASecurity);

  DoEncryptSessionKey(ACertificate, AStoreName, AStoreLocation);

  cipherDataNode := ASecurity.ownerDocument.createElement(GetSoapNodeName(xencNameSpace, 'CipherData'));
  encKeyNode.appendChild(cipherDataNode);

  AddNodeValue(cipherDataNode, GetSoapNodeName(xencNameSpace, 'CipherValue'), CipherValue);

  BuildReferenceList(encKeyNode);
end;

function TclXmlEncryptedKey.GenerateEncryptedDataURI: string;
var
  buf: TclByteArray;
begin
  buf := GenerateRandomData(16, Config.CSP, Config.ProviderType);
  Result := '#ED-' + UpperCase(BytesToHex(buf));
end;

function TclXmlEncryptedKey.GetSessionKeySize: Integer;
var
  encData: TclXmlEncryptedData;
begin
  CheckReferenceList();

  encData := TclXmlEncryptedData.CreateInstance(ReferenceList[0].EncryptionMethod, Config);
  try
    Result := encData.KeySize;
  finally
    encData.Free();
  end;
end;

function TclXmlEncryptedKey.IsContent(const AEncryptionType: string): Boolean;
begin
  Result := (System.Pos('Content', AEncryptionType) > 0);
end;

class function TclXmlEncryptedKey.Parse(const ASecurity: IXMLDOMNode;
  AReferenceList: TclXmlEncryptReferenceList; AConfig: TclXmlSecurityConfig): TclXmlEncryptedKey;
var
  i: Integer;
begin
  Result := nil;

  for i := 0 to RegisteredEncryptedKeys().Count - 1 do
  begin
    Result := TclXmlEncryptedKeyClass(RegisteredEncryptedKeys()[i]).Create(AReferenceList, AConfig);
    try
      if Result.DoParse(ASecurity) then
      begin
        Break;
      end;
      FreeAndNil(Result);
    except
      Result.Free();
      raise;
    end;
  end;

  if (Result = nil) then
  begin
    raise EclSoapMessageError.Create(EncryptionMethodError, EncryptionMethodErrorCode);
  end;
end;

function TclXmlEncryptedKey.ParseEncryptedData(const AData: IXMLDOMNode; AReferenceItem: TclXmlEncryptReference): string;
var
  node: IXMLDOMNode;
  wsuNameSpace: string;
begin
  AReferenceItem.EncryptionType := GetAttributeValue(AData, 'Type');

  node := GetNodeByName(AData, 'EncryptionMethod');
  if (node <> nil) then
  begin
    AReferenceItem.EncryptionMethod := GetAttributeValue(node, 'Algorithm');
  end;

  wsuNameSpace := Config.Namespaces.GetPrefix(wsuNameSpaceName);

  if IsContent(AReferenceItem.EncryptionType) then
  begin
    if (AData.parentNode <> nil) then
    begin
      AReferenceItem.URI := Id2UriReference(GetAttributeValue(AData.parentNode, GetSoapNodeName(wsuNameSpace, Config.IdName)));
    end;
  end else
  begin
    AReferenceItem.URI := Id2UriReference(GetAttributeValue(AData, GetSoapNodeName(wsuNameSpace, Config.IdName)));
  end;

  node := GetNodeByName(AData, 'CipherData');
  if (node = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;
  Result := GetNodeValueByName(node, 'CipherValue');
end;

procedure TclXmlEncryptedKey.ParseEncryptedKey(const AEncryptedKey: IXMLDOMNode);
var
  encMethod, cipherData: IXMLDOMNode;
begin
  ID := GetAttributeValue(AEncryptedKey, Config.IdName);

  encMethod := GetNodeByName(AEncryptedKey, 'EncryptionMethod');
  if (encMethod <> nil) then
  begin
    EncryptionMethod := GetAttributeValue(encMethod, 'Algorithm');
  end;

  cipherData := GetNodeByName(AEncryptedKey, 'CipherData');
  if (cipherData <> nil) then
  begin
    CipherValue := GetNodeValueByName(cipherData, 'CipherValue');
  end;
end;

procedure TclXmlEncryptedKey.ParseKeyInfo(const AEncryptedKey, ASecurity: IXMLDOMNode);
var
  ki: IXMLDOMNode;
begin
  ki := GetNodeByName(AEncryptedKey, 'KeyInfo');
  KeyInfo := TclXmlKeyInfo.Parse(ki, ASecurity, FConfig);
end;

procedure TclXmlEncryptedKey.ParseReferenceList(const AEncryptedKey: IXMLDOMNode);
var
  list: IXMLDomNodeList;
  refList, dataRef: IXMLDomNode;
  refItem: TclXmlEncryptReference;
begin
  refList := GetNodeByName(AEncryptedKey, 'ReferenceList');
  if (refList = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  list := refList.childNodes;
  if (list = nil) then Exit;

  dataRef := list.nextNode;
  while (dataRef <> nil) do
  begin
    if (dataRef.baseName = 'DataReference') then
    begin
      refItem := FReferenceList.Add();
      refItem.EncryptedDataURI := GetAttributeValue(dataRef, 'URI');
    end;
    dataRef := list.nextNode;
  end;
  dataRef := nil;
end;

class function TclXmlEncryptedKey.RegisteredEncryptedKeys: TList;
begin
  if (RegXmlEncryptedKeys = nil) then
  begin
    RegXmlEncryptedKeys := TList.Create();
  end;
  Result := RegXmlEncryptedKeys;
end;

class procedure TclXmlEncryptedKey.RegisterEncryptedKey(AEncryptedKeyClass: TclXmlEncryptedKeyClass);
begin
  RegisteredEncryptedKeys().Add(AEncryptedKeyClass);
end;

procedure TclXmlEncryptedKey.SetKeyInfo(const Value: TclXmlKeyInfo);
begin
  FKeyInfo.Free();
  FKeyInfo := Value;
end;

procedure TclXmlEncryptedKey.SetSessionKey(Value: TclCryptData);
begin
  FSessionKey.Free();
  FSessionKey := Value;
end;

{ TclXmlThumbprintKeyInfo }

procedure TclXmlThumbprintKeyInfo.AssignCertificate(ACertificate: TclCertificate);
begin
  FThumbprint := ACertificate.Thumbprint;
end;

function TclXmlThumbprintKeyInfo.Build(const AOwnerNode, ASecurity: IXMLDOMNode): IXMLDOMNode;
var
  tokenReference, keyId: IXMLDOMNode;
  encValue: string;
  b: TclByteArray;
begin
{$IFNDEF DELPHI2005}b := nil;{$ENDIF}
  Result := inherited Build(AOwnerNode, ASecurity);

  tokenReference := GetNodeByName(Result, 'SecurityTokenReference');

  keyId := tokenReference.ownerDocument.createElement(GetSoapNodeName(Config.Namespaces.GetPrefix(wsseNameSpaceName), 'KeyIdentifier'));
  tokenReference.appendChild(keyId);

  SetAttributeValue(keyId, 'ValueType', X509ThumbprintIdentifier);
  SetAttributeValue(keyId, 'EncodingType', Base64BinaryXmlEncoding);

  b := HexToBytes(Thumbprint);
  encValue := TclEncoder.EncodeBytes(b, cmBase64);

  SetNodeText(keyId, encValue);
end;

function TclXmlThumbprintKeyInfo.DoParse(const AKeyInfo, ASecurity: IXMLDOMNode): Boolean;
var
  tokenReference, keyId: IXMLDOMNode;
  encValue: string;
  b: TclByteArray;
begin
{$IFNDEF DELPHI2005}b := nil;{$ENDIF}
  Result := inherited DoParse(AKeyInfo, ASecurity);
  if (not Result) then Exit;

  Result := False;

  tokenReference := GetNodeByName(AKeyInfo, 'SecurityTokenReference');
  if (tokenReference = nil) then Exit;

  keyId := GetNodeByName(tokenReference, 'KeyIdentifier');
  if (keyId = nil) then Exit;

  if (GetAttributeValue(keyId, 'ValueType') <> X509ThumbprintIdentifier) then Exit;

  if (GetAttributeValue(keyId, 'EncodingType') <> Base64BinaryXmlEncoding) then Exit;

  encValue := GetNodeText(keyId);
  b := TclEncoder.DecodeBytes(encValue, cmBase64);
  FThumbprint := BytesToHex(b);
  Result := True;
end;

function TclXmlThumbprintKeyInfo.GetCertificate(AStore: TclCertificateStore): TclCertificate;
begin
  Result := AStore.FindByThumbprint(Thumbprint);
  if (Result <> nil) then
  begin
    Result := TclCertificate.Create(Result.Context);
  end;
end;

{ TclXmlX509KeyInfo }

function TclXmlX509KeyInfo.BuildBinarySecurityToken(const ASecurity: IXMLDOMNode): IXMLDOMNode;
var
  ns: TclNameSpaceSymbTable;
  wsseNameSpace, wsuNameSpace: string;
begin
  ns := TclNameSpaceSymbTable.Create();
  try
    wsseNameSpace := Config.Namespaces.GetPrefix(wsseNameSpaceName);
    wsuNameSpace := Config.Namespaces.GetPrefix(wsuNameSpaceName);

    Result := ASecurity.ownerDocument.createElement(GetSoapNodeName(wsseNameSpace, 'BinarySecurityToken'));
    ASecurity.appendChild(Result);
    ns.GetParentNameSpaces(Result as IXMLDOMElement);

    if (ns.GetMappingWithoutRendered(wsseNameSpace) = nil) then
    begin
      SetAttributeValue(Result, GetSoapNamespace(wsseNameSpace), wsseNameSpaceName);
    end;

    if (URI <> '') and (ns.GetMappingWithoutRendered(wsuNameSpace) = nil) then
    begin
      SetAttributeValue(Result, GetSoapNamespace(wsuNameSpace), wsuNameSpaceName);
    end;

    SetAttributeValue(Result, GetSoapNodeName(wsuNameSpace, GetIdName()), UriReference2Id(URI));
    SetAttributeValue(Result, 'ValueType', X509CertificateIdentifier);
    SetAttributeValue(Result, 'EncodingType', Base64BinaryXmlEncoding);

    SetNodeText(Result, EncodedCertificate);
  finally
    ns.Free();
  end;
end;

procedure TclXmlX509KeyInfo.AssignCertificate(ACertificate: TclCertificate);
var
  certValue: TclString;
begin
  SetLength(certValue, ACertificate.Context.cbCertEncoded);
  system.Move(ACertificate.Context.pbCertEncoded^, Pointer(certValue)^, ACertificate.Context.cbCertEncoded);

  FEncodedCertificate := TclEncoder.Encode(string(certValue), cmBase64);//TODO unicode
end;

function TclXmlX509KeyInfo.Build(const AOwnerNode, ASecurity: IXMLDOMNode): IXMLDOMNode;
var
  tokenReference, keyRef: IXMLDOMNode;
begin
  if (ASecurity = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  Result := inherited Build(AOwnerNode, ASecurity);

  tokenReference := GetNodeByName(Result, 'SecurityTokenReference');

  keyRef := tokenReference.ownerDocument.createElement(GetSoapNodeName(Config.Namespaces.GetPrefix(wsseNameSpaceName), 'Reference'));
  tokenReference.appendChild(keyRef);

  SetAttributeValue(keyRef, 'ValueType', X509CertificateIdentifier);
  SetAttributeValue(keyRef, 'URI', URI);

  BuildBinarySecurityToken(ASecurity);
end;

function TclXmlX509KeyInfo.DoParse(const AKeyInfo, ASecurity: IXMLDOMNode): Boolean;
var
  tokenReference, reference, binarySecToken: IXMLDOMNode;
begin
  Result := inherited DoParse(AKeyInfo, ASecurity) and (ASecurity <> nil);
  if (not Result) then Exit;

  Result := False;

  tokenReference := GetNodeByName(AKeyInfo, 'SecurityTokenReference');
  if (tokenReference = nil) then Exit;

  reference := GetNodeByName(tokenReference, 'Reference');
  if (reference = nil) then Exit;

  if (GetAttributeValue(reference, 'ValueType') <> X509CertificateIdentifier) then Exit;

  FURI := GetAttributeValue(reference, 'URI');

  binarySecToken := ASecurity.selectSingleNode('//*[@' + GetSoapNodeName(Config.Namespaces.GetPrefix(wsuNameSpaceName),
    GetAttributeText(Config.IdName, UriReference2Id(URI))) + ']');

  if (GetAttributeValue(binarySecToken, 'ValueType') <> X509CertificateIdentifier) then Exit;

  if (GetAttributeValue(binarySecToken, 'EncodingType') <> Base64BinaryXmlEncoding) then Exit;

  FEncodedCertificate := GetNodeText(binarySecToken);
  FEncodedCertificate := StringReplace(FEncodedCertificate, #32, '', [rfReplaceAll]);

  Result := True;
end;

function TclXmlX509KeyInfo.GetCertificate(AStore: TclCertificateStore): TclCertificate;
var
  buf: PByte;
  stream: TStream;
begin
  Result := nil;
  stream := nil;
  buf := nil;
  try
    stream := TMemoryStream.Create();
    TclEncoder.Decode(FEncodedCertificate, stream, cmBase64);

    if (stream.Size > 0) then
    begin
      GetMem(buf, stream.Size);
      stream.Position := 0;
      stream.Read(buf^, stream.Size);

      Result := TclCertificate.Create(buf, stream.Size);
    end;
  finally
    FreeMem(buf);
    stream.Free();
  end;
end;

{ TclXmlKeyInfo }

procedure TclXmlKeyInfo.AddNamespaceIfNeed(const ANode: IXMLDOMNode; const APrefix, AUri: string);
begin
  if (FNamespaces.GetMappingWithoutRendered(APrefix) = nil) then
  begin
    SetAttributeValue(ANode, GetSoapNamespace(APrefix), AUri);
  end;
end;

function TclXmlKeyInfo.Build(const AOwnerNode, ASecurity: IXMLDOMNode): IXMLDOMNode;
var
  tokenReference: IXMLDOMNode;
  dsNameSpace, wsseNameSpace, wsuNameSpace: string;
begin
  if (AOwnerNode = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  dsNameSpace := Config.Namespaces.GetPrefix(dsNameSpaceName);

  Result := AOwnerNode.ownerDocument.createElement(GetSoapNodeName(dsNameSpace, 'KeyInfo'));
  AOwnerNode.appendChild(Result);

  InitNamespaces(Result);

  AddNamespaceIfNeed(Result, dsNameSpace, dsNameSpaceName);

  SetAttributeValue(Result, Config.IdName, ID);

  wsseNameSpace := Config.Namespaces.GetPrefix(wsseNameSpaceName);

  tokenReference := AOwnerNode.ownerDocument.createElement(GetSoapNodeName(wsseNameSpace, 'SecurityTokenReference'));
  Result.appendChild(tokenReference);
  AddNamespaceIfNeed(tokenReference, wsseNameSpace, wsseNameSpaceName);

  if (SecurityTokenReferenceID <> '') then
  begin
    wsuNameSpace := Config.Namespaces.GetPrefix(wsuNameSpaceName);
    SetAttributeValue(tokenReference, GetSoapNodeName(wsuNameSpace, Config.IdName), SecurityTokenReferenceID);
    AddNamespaceIfNeed(tokenReference, wsuNameSpace, wsuNameSpaceName);
  end;
end;

constructor TclXmlKeyInfo.Create(AConfig: TclXmlSecurityConfig);
begin
  inherited Create();

  FConfig := AConfig;
  FNamespaces := nil;
end;

destructor TclXmlKeyInfo.Destroy;
begin
  FNamespaces.Free();
  inherited Destroy();
end;

function TclXmlKeyInfo.DoParse(const AKeyInfo, ASecurity: IXMLDOMNode): Boolean;
var
  tokenReference: IXMLDOMNode;
begin
  Result := (AKeyInfo <> nil);
  if (not Result) then Exit;

  ID := GetAttributeValue(AKeyInfo, Config.IdName);

  tokenReference := GetNodeByName(AKeyInfo, 'SecurityTokenReference');
  if (tokenReference <> nil) then
  begin
    SecurityTokenReferenceID := GetAttributeValue(tokenReference,
      GetSoapNodeName(Config.Namespaces.GetPrefix(wsuNameSpaceName), Config.IdName));
  end;
end;

function TclXmlKeyInfo.GetIdName: string;
begin
  Result := FConfig.IdName;
end;

procedure TclXmlKeyInfo.InitNamespaces(const AOwnerNode: IXMLDOMNode);
begin
 FreeAndNil(FNamespaces);
 FNamespaces := TclNameSpaceSymbTable.Create();
 FNamespaces.GetParentNameSpaces(AOwnerNode as IXMLDOMElement);
end;

class function TclXmlKeyInfo.Parse(const AKeyInfo, ASecurity: IXMLDOMNode; AConfig: TclXmlSecurityConfig): TclXmlKeyInfo;
var
  i: Integer;
begin
  Result := nil;

  for i := 0 to RegisteredKeyInfo().Count - 1 do
  begin
    Result := TclXmlKeyInfoClass(RegisteredKeyInfo()[i]).Create(AConfig);
    try
      if Result.DoParse(AKeyInfo, ASecurity) then
      begin
        Break;
      end;
      FreeAndNil(Result);
    except
      Result.Free();
      raise;
    end;
  end;
end;

class function TclXmlKeyInfo.RegisteredKeyInfo: TList;
begin
  if (RegXmlKeyInfo = nil) then
  begin
    RegXmlKeyInfo := TList.Create();
  end;
  Result := RegXmlKeyInfo;
end;

class procedure TclXmlKeyInfo.RegisterKeyInfo(AKeyInfoClass: TclXmlKeyInfoClass);
begin
  RegisteredKeyInfo().Add(AKeyInfoClass);
end;

{ TclXmlSKIKeyInfo }

procedure TclXmlSKIKeyInfo.AssignCertificate(ACertificate: TclCertificate);
begin
  FSubjectKeyIdentifier := ACertificate.SubjectKeyIdentifier;
end;

function TclXmlSKIKeyInfo.Build(const AOwnerNode, ASecurity: IXMLDOMNode): IXMLDOMNode;
var
  tokenReference, keyId: IXMLDOMNode;
  encValue: string;
  b: TclByteArray;
begin
{$IFNDEF DELPHI2005}b := nil;{$ENDIF}
  Result := inherited Build(AOwnerNode, ASecurity);

  tokenReference := GetNodeByName(Result, 'SecurityTokenReference');

  keyId := tokenReference.ownerDocument.createElement(GetSoapNodeName(Config.Namespaces.GetPrefix(wsseNameSpaceName), 'KeyIdentifier'));
  tokenReference.appendChild(keyId);

  SetAttributeValue(keyId, 'ValueType', X509SubjectKeyIdentifier);
  SetAttributeValue(keyId, 'EncodingType', Base64BinaryXmlEncoding);

  b := HexToBytes(SubjectKeyIdentifier);
  encValue := TclEncoder.EncodeBytes(b, cmBase64);

  SetNodeText(keyId, encValue);
end;

function TclXmlSKIKeyInfo.DoParse(const AKeyInfo, ASecurity: IXMLDOMNode): Boolean;
var
  tokenReference, keyId: IXMLDOMNode;
  encValue: string;
  b: TclByteArray;
begin
{$IFNDEF DELPHI2005}b := nil;{$ENDIF}
  Result := inherited DoParse(AKeyInfo, ASecurity);
  if (not Result) then Exit;

  Result := False;

  tokenReference := GetNodeByName(AKeyInfo, 'SecurityTokenReference');
  if (tokenReference = nil) then Exit;

  keyId := GetNodeByName(tokenReference, 'KeyIdentifier');
  if (keyId = nil) then Exit;

  if (GetAttributeValue(keyId, 'ValueType') <> X509SubjectKeyIdentifier) then Exit;

  if (GetAttributeValue(keyId, 'EncodingType') <> Base64BinaryXmlEncoding) then Exit;

  encValue := GetNodeText(keyId);
  b := TclEncoder.DecodeBytes(encValue, cmBase64);
  FSubjectKeyIdentifier := BytesToHex(b);
  Result := True;
end;

function TclXmlSKIKeyInfo.GetCertificate(AStore: TclCertificateStore): TclCertificate;
begin
  Result := AStore.FindBySKI(SubjectKeyIdentifier);
  if (Result <> nil) then
  begin
    Result := TclCertificate.Create(Result.Context);
  end;
end;

{ TclXmlEncryptedData }

procedure TclXmlEncryptedData.Clear;
begin
  FEncryptionMethod := '';
  DecryptedData := nil;
end;

constructor TclXmlEncryptedData.Create(AConfig: TclXmlSecurityConfig);
begin
  inherited Create();
  FConfig := AConfig;
end;

class function TclXmlEncryptedData.CreateInstance(const AEncryptionMethod: string; AConfig: TclXmlSecurityConfig): TclXmlEncryptedData;
var
  i: Integer;
begin
  Result := nil;

  for i := 0 to RegisteredEncryptedData().Count - 1 do
  begin
    Result := TclXmlEncryptedDataClass(RegisteredEncryptedData()[i]).Create(AConfig);
    try
      if Result.SupportsMethod(AEncryptionMethod) then
      begin
        Result.EncryptionMethod := AEncryptionMethod;
        Break;
      end;
      FreeAndNil(Result);
    except
      Result.Free();
      raise;
    end;
  end;

  if (Result = nil) then
  begin
    raise EclSoapMessageError.Create(EncryptionMethodError, EncryptionMethodErrorCode);
  end;
end;

class function TclXmlEncryptedData.DecryptData(const AEncryptionMethod, AData: string; ASessionKey: TclCryptData;
  const ACharSet: string; AConfig: TclXmlSecurityConfig): TclXmlEncryptedData;
begin
  Result := TclXmlEncryptedData.CreateInstance(AEncryptionMethod, AConfig);
  try
    Result.DoDecrypt(AData, ASessionKey, ACharSet);
  except
    Result.Free();
    raise;
  end;
end;

procedure TclXmlEncryptedData.DepadBlock(AData: TclCryptData);
var
  num: Integer;
  i: Integer;
begin
  case Config.PaddingMode of
    pmNone, pmZeros:
    begin
      num := 0;
    end;

    pmPKCS7:
    begin
      num := AData.DataBytes[AData.DataSize - 1];
      if ((num <= 0) or (num > BlockSize)) then
      begin
        raise EclSoapMessageError.Create(SoapDecryptFailed, SoapDecryptFailedCode);
      end;
      for i := AData.DataSize - num to AData.DataSize - 1 do
      begin
        if (AData.DataBytes[i] <> num) then
        begin
          raise EclSoapMessageError.Create(SoapDecryptFailed, SoapDecryptFailedCode);
        end;
      end;
    end;

    pmANSIX923:
    begin
      num := AData.DataBytes[AData.DataSize - 1];
      if ((num <= 0) or (num > BlockSize)) then
      begin
        raise EclSoapMessageError.Create(SoapDecryptFailed, SoapDecryptFailedCode);
      end;
      for i := AData.DataSize - num to AData.DataSize - 2 do
      begin
        if (AData.DataBytes[i] <> 0) then
        begin
          raise EclSoapMessageError.Create(SoapDecryptFailed, SoapDecryptFailedCode);
        end;
      end;
    end;

    pmISO10126:
    begin
      num := AData.DataBytes[AData.DataSize - 1];
      if ((num <= 0) or (num > BlockSize)) then
      begin
        raise EclSoapMessageError.Create(SoapDecryptFailed, SoapDecryptFailedCode);
      end;
    end else
    begin
      raise EclSoapMessageError.Create(SoapDecryptFailed, SoapDecryptFailedCode);
    end;
  end;

  AData.Reduce(AData.DataSize - num);
end;

destructor TclXmlEncryptedData.Destroy;
begin
  DecryptedData := nil;

  inherited Destroy();
end;

function TclXmlEncryptedData.EncryptData(const AData: string; ASessionKey: TclCryptData; const ACharSet: string): string;
begin
  if (AData = '') then
  begin
    raise EclSoapMessageError.Create(SoapDataError, SoapDataErrorCode);
  end;

  DecryptedData := TclCryptData.Create(ACharSet);
  DecryptedData.FromString(AData);

  Result := DoEncrypt(ASessionKey);
end;

function TclXmlEncryptedData.GetKeySize: Integer;
var
  alg: TclXmlEncryptionAlgorithm;
begin
  alg := Config.CryptAlgorithms.GetAlgorithm(EncryptionMethod);
  if (alg <> nil) then
  begin
    Result := alg.KeySize;
  end else
  begin
    Result := 0;
  end;
end;

function TclXmlEncryptedData.PadBlock(AData: TclCryptData): TclCryptData;
var
  num: Integer;
  i: Integer;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  Result := nil;
  try
    num := BlockSize - (AData.DataSize mod BlockSize);
    case Config.PaddingMode of
      pmNone:
      begin
        if ((AData.DataSize mod BlockSize) <> 0) then
        begin
          raise EclSoapMessageError.Create(SoapEncryptFailed, SoapEncryptFailedCode);
        end;
        Result := TclCryptData.Create(AData.DataSize);
      end;

      pmPKCS7:
      begin
        Result := TclCryptData.Create(AData.DataSize + num);
        for i := Result.DataSize - num to Result.DataSize -1 do
        begin
          Result.DataBytes[i] := num;
        end;
      end;

      pmZeros:
      begin
        if (num = BlockSize) then
        begin
          num := 0;
        end;
        Result := TclCryptData.Create(AData.DataSize + num);

        for i := Result.DataSize - num to Result.DataSize -1 do
        begin
          Result.DataBytes[i] := 0;
        end;
      end;

      pmANSIX923:
      begin
        Result := TclCryptData.Create(AData.DataSize + num);
        Result.DataBytes[Result.DataSize - 1] := num;
      end;

      pmISO10126:
      begin
        Result := TclCryptData.Create(AData.DataSize + num);
        buf := GenerateRandomData(num - 1, Config.CSP, Config.ProviderType);

        for i := 0 to Length(buf) - 1 do
        begin
          Result.DataBytes[i + Result.DataSize - num] := buf[i];
        end;
        Result.DataBytes[Result.DataSize - 1] := num;
      end else
      begin
        raise EclSoapMessageError.Create(SoapEncryptFailed, SoapEncryptFailedCode);
      end;
    end;

    System.Move(AData.Data^, Result.Data^, AData.DataSize);
  except
    Result.Free();
    raise;
  end;
end;

class function TclXmlEncryptedData.RegisteredEncryptedData: TList;
begin
  if (RegXmlEncryptedData = nil) then
  begin
    RegXmlEncryptedData := TList.Create();
  end;
  Result := RegXmlEncryptedData;
end;

class procedure TclXmlEncryptedData.RegisterEncryptedData(AEncryptedDataClass: TclXmlEncryptedDataClass);
begin
  RegisteredEncryptedData().Add(AEncryptedDataClass);
end;

procedure TclXmlEncryptedData.SetDecryptedData(const Value: TclCryptData);
begin
  FDecryptedData.Free();
  FDecryptedData := Value;
end;

{ TclXmlEncryptedDataAES }

function TclXmlEncryptedDataAES.CreateIV: TclCryptData;
begin
  if (BlockSize = 0) then
  begin
    raise EclSoapMessageError.Create(EncryptBlockSizeError, EncryptBlockSizeErrorCode);
  end;

  Result := TclCryptData.Create(BlockSize);
  try
    GenerateRandomData(Result, BlockSize, Config.CSP, Config.ProviderType);
  except
    Result.Free();
    raise;
  end;
end;

function TclXmlEncryptedDataAES.CreateSessionKey: TclCryptData;
begin
  if (KeySize = 0) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  Result := TclCryptData.Create(KeySize);
  try
    GenerateRandomData(Result, KeySize, Config.CSP, Config.ProviderType);
  except
    Result.Free();
    raise;
  end;
end;

procedure TclXmlEncryptedDataAES.DoDecrypt(const AData: string; ASessionKey: TclCryptData; const ACharSet: string);
var
  encStream: TStream;
  context: HCRYPTPROV;
  sessionKey: HCRYPTKEY;
  dwDataLen, dwMode: DWORD;
  ivData: TclCryptData;
  pCSP: PclChar;
  provType: Integer;
begin
  if (AData = '') then
  begin
    raise EclSoapMessageError.Create(SoapDataError, SoapDataErrorCode);
  end;

  encStream := nil;
  context := nil;
  sessionKey := nil;
  ivData := nil;
  try
    encStream := TMemoryStream.Create();
    TclEncoder.Decode(AData, encStream, cmBase64);

    encStream.Position := 0;
    ivData := TclCryptData.Create();
    ivData.FromStream(encStream, BlockSize);

    DecryptedData := TclCryptData.Create(ACharSet);

    DecryptedData.FromStream(encStream);

    pCSP := Config.GetCSP();
    if (pCSP <> nil) then
    begin
      provType := Config.ProviderType;
    end else
    begin
      pCSP := MS_ENH_RSA_AES_PROV;
      provType := PROV_RSA_AES;
    end;

    if not CryptAcquireContext(@context, nil, pCSP, provType, CRYPT_VERIFYCONTEXT) then
    begin
      RaiseCryptError('CryptAcquireContext');
    end;

    if (ASessionKey.DataSize <> KeySize) then
    begin
      raise EclSoapMessageError.Create(EncryptKeySizeError, EncryptKeySizeErrorCode);
    end;

    ImportKeyData(context, GetKeyAlgorithm(), ASessionKey.Data, ASessionKey.DataSize, @sessionKey);

    dwMode := GetCipherMode();
    if (dwMode <> 0) then
    begin
      if not CryptSetKeyParam(sessionKey, KP_MODE, @dwMode, 0) then
      begin
        RaiseCryptError('CryptSetKeyParam');
      end;
    end;

    if not CryptSetKeyParam(sessionKey, KP_IV, ivData.Data, 0) then
    begin
      RaiseCryptError('CryptSetKeyParam');
    end;

    dwDataLen := DecryptedData.DataSize;
    if not CryptDecrypt(sessionKey, nil, 0, 0, DecryptedData.Data, @dwDataLen) then
    begin
      RaiseCryptError('CryptDecrypt');
    end;

    DepadBlock(DecryptedData);
  finally
    if (sessionKey <> nil) then
    begin
      CryptDestroyKey(sessionKey);
    end;

    if (context <> nil) then
    begin
      CryptReleaseContext(context, 0);
    end;

    ivData.Free();
    encStream.Free();
  end;
end;

function TclXmlEncryptedDataAES.DoEncrypt(ASessionKey: TclCryptData): string;
var
  pCSP: PclChar;
  provType: Integer;
  context: HCRYPTPROV;
  sessionKey: HCRYPTKEY;
  dwDataLen, dwMode: DWORD;
  ivData: TclCryptData;
  encStream: TStream;
begin
  if (DecryptedData = nil) or (DecryptedData.DataSize = 0) then
  begin
    raise EclSoapMessageError.Create(SoapDataError, SoapDataErrorCode);
  end;

  context := nil;
  sessionKey := nil;
  ivData := nil;
  encStream := nil;
  try
    pCSP := Config.GetCSP();
    if (pCSP <> nil) then
    begin
      provType := Config.ProviderType;
    end else
    begin
      pCSP := MS_ENH_RSA_AES_PROV;
      provType := PROV_RSA_AES;
    end;

    if not CryptAcquireContext(@context, nil, pCSP, provType, CRYPT_VERIFYCONTEXT) then
    begin
      RaiseCryptError('CryptAcquireContext');
    end;

    if (ASessionKey.DataSize <> KeySize) then
    begin
      raise EclSoapMessageError.Create(EncryptKeySizeError, EncryptKeySizeErrorCode);
    end;

    ImportKeyData(context, GetKeyAlgorithm(), ASessionKey.Data, ASessionKey.DataSize, @sessionKey);

    dwMode := GetCipherMode();
    if (dwMode <> 0) then
    begin
      if not CryptSetKeyParam(sessionKey, KP_MODE, @dwMode, 0) then
      begin
        RaiseCryptError('CryptSetKeyParam');
      end;
    end;

    ivData := CreateIV();

    if not CryptSetKeyParam(sessionKey, KP_IV, ivData.Data, 0) then
    begin
      RaiseCryptError('CryptSetKeyParam');
    end;

    DecryptedData := PadBlock(DecryptedData);

    dwDataLen := DecryptedData.DataSize;
    if not CryptEncrypt(sessionKey, nil, 0, 0, DecryptedData.Data, @dwDataLen, dwDataLen) then
    begin
      RaiseCryptError('CryptDecrypt');
    end;

    encStream := TMemoryStream.Create();

    ivData.ToStream(encStream);
    DecryptedData.ToStream(encStream);
    DecryptedData := nil;

    encStream.Position := 0;
    Result := TclEncoder.Encode(encStream, cmBase64);
  finally
    encStream.Free();
    ivData.Free();
    if (sessionKey <> nil) then
    begin
      CryptDestroyKey(sessionKey);
    end;

    if (context <> nil) then
    begin
      CryptReleaseContext(context, 0);
    end;
  end;
end;

function TclXmlEncryptedDataAES.GetBlockSize: Integer;
begin
  Result := $10;
end;

function TclXmlEncryptedDataAES.GetCipherMode: DWORD;
begin
  if (System.Pos('cbc', EncryptionMethod) > 0) then
  begin
    Result := CRYPT_MODE_CBC;
  end else
  if (System.Pos('ecb', EncryptionMethod) > 0) then
  begin
    Result := CRYPT_MODE_ECB;
  end else
  if (System.Pos('ofb', EncryptionMethod) > 0) then
  begin
    Result := CRYPT_MODE_OFB;
  end else
  if (System.Pos('cfb', EncryptionMethod) > 0) then
  begin
    Result := CRYPT_MODE_CFB;
  end else
  if (System.Pos('cts', EncryptionMethod) > 0) then
  begin
    Result := CRYPT_MODE_CTS;
  end else
  begin
    Result := 0;
  end;
end;

function TclXmlEncryptedDataAES.GetKeyAlgorithm: DWORD;
begin
  Result := Config.CryptAlgorithms.GetIdentifier(EncryptionMethod);
  if (Result = 0) then
  begin
    Result := CALG_AES;
  end;
end;

function TclXmlEncryptedDataAES.GetKeySize: Integer;
begin
  Result := inherited GetKeySize();
  if (Result = 0) then
  begin
    Result := 128 div 8;
  end;
end;

procedure TclXmlEncryptedDataAES.ImportKeyData(hProvider: HCRYPTPROV;
  Algid: ALG_ID; pbKeyData: PBYTE; cbKeyData: DWORD; phKey: PHCRYPTKEY);
var
  cbData, cbHeaderLen, cbKeyLen, dwDataLen: DWORD;
  pAlgid: PByte;
  pbData: PByte;
  hImpKey: HCRYPTKEY;
  pBlob: PBLOBHEADER;
begin
  hImpKey := nil;
  if (not CryptGetUserKey(hProvider, AT_KEYEXCHANGE, @hImpKey)) then
  begin
    if (clGetLastError() <> NTE_NO_KEY) then
    begin
      RaiseCryptError('CryptGetUserKey');
    end;
    if (not CryptGenKey(hProvider, AT_KEYEXCHANGE, (1024 shl 16), @hImpKey)) then
    begin
      RaiseCryptError('CryptGetUserKey');
    end;
  end;
  try
    cbData := cbKeyData;
    cbHeaderLen := SizeOf(BLOBHEADER) + SizeOf(ALG_ID);

    if (not CryptEncrypt(hImpKey, nil, 1, 0, nil, @cbData, cbData)) then
    begin
      RaiseCryptError('CryptEncrypt');
    end;

    GetMem(pbData, cbData + cbHeaderLen);
    try
      CopyMemory(Pointer(TclIntPtr(pbData) + Integer(cbHeaderLen)), pbKeyData, cbKeyData);
      cbKeyLen := cbKeyData;

      if (not CryptEncrypt(hImpKey, nil, 1, 0, Pointer(TclIntPtr(pbData) + Integer(cbHeaderLen)), @cbKeyLen, cbData)) then
      begin
        RaiseCryptError('CryptEncrypt');
      end;

      pBlob := PBLOBHEADER(pbData);
      pAlgid := PByte(TclIntPtr(pbData) + SizeOf(BLOBHEADER));
      pBlob.bType := SIMPLEBLOB;
      pBlob.bVersion := CUR_BLOB_VERSION;
      pBlob.reserved := 0;
      pBlob.aiKeyAlg := Algid;
      dwDataLen := SizeOf(ALG_ID);
      if (not CryptGetKeyParam(hImpKey, KP_ALGID, pAlgid, @dwDataLen, 0)) then
      begin
        RaiseCryptError('CryptGetKeyParam');
      end;

      if not CryptImportKey(hProvider, pbData, cbData + cbHeaderLen, hImpKey, 0, phKey) then
      begin
        RaiseCryptError('CryptImportKey');
      end;
    finally
      FreeMem(pbData);
    end;
  finally
    CryptDestroyKey(hImpKey);
  end;
end;

function TclXmlEncryptedDataAES.SupportsMethod(const AEncryptionMethod: string): Boolean;
begin
  Result := (System.Pos('aes', AEncryptionMethod) > 0);
end;

{ TclXmlEncryptedDataList }

procedure TclXmlEncryptedDataList.Add(const AID: string; AData: TclXmlEncryptedData);
begin
  FList.AddObject(AID, AData);
end;

procedure TclXmlEncryptedDataList.Clear;
begin
  while (FList.Count > 0) do
  begin
    FList.Objects[FList.Count - 1].Free();
    FList.Delete(FList.Count - 1);
  end;
end;

constructor TclXmlEncryptedDataList.Create;
begin
  inherited Create();
  FList := TStringList.Create();
end;

procedure TclXmlEncryptedDataList.Delete(Index: Integer);
begin
  FList.Objects[Index].Free();
  FList.Delete(Index);
end;

destructor TclXmlEncryptedDataList.Destroy;
begin
  Clear();
  FList.Free();

  inherited Destroy();
end;

function TclXmlEncryptedDataList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclXmlEncryptedDataList.GetData(Index: Integer): TclXmlEncryptedData;
begin
  Result := TclXmlEncryptedData(FList.Objects[Index]);
end;

function TclXmlEncryptedDataList.GetID(Index: Integer): string;
begin
  Result := FList[Index];
end;

{ TclXmlSecurityAlgorithmList }

function TclXmlSecurityAlgorithmList.Add: TclXmlSecurityAlgorithm;
begin
  Result := TclXmlSecurityAlgorithm(inherited Add());
end;

function TclXmlSecurityAlgorithmList.AddAlgorithm(const AName: string; AIdentifier: Integer): TclXmlSecurityAlgorithm;
begin
  Result := Add();
  Result.Name := AName;
  Result.Identifier := AIdentifier;
end;

function TclXmlSecurityAlgorithmList.GetAlgorithm(const Algorithm: string): TclXmlSecurityAlgorithm;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    if (System.Pos(Items[i].Name, Algorithm) > 0) then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
  Result := nil;
end;

function TclXmlSecurityAlgorithmList.GetIdentifier(const Algorithm: string): Integer;
var
  alg: TclXmlSecurityAlgorithm;
begin
  alg := GetAlgorithm(Algorithm);
  if (alg <> nil) then
  begin
    Result := alg.Identifier;
  end else
  begin
    Result := 0;
  end;
end;

function TclXmlSecurityAlgorithmList.GetItem(Index: Integer): TclXmlSecurityAlgorithm;
begin
  Result := TclXmlSecurityAlgorithm(inherited GetItem(Index));
end;

procedure TclXmlSecurityAlgorithmList.SetItem(Index: Integer; const Value: TclXmlSecurityAlgorithm);
begin
  inherited SetItem(Index, Value);
end;

procedure TclXmlSecurityAlgorithmList.Update(Item: TCollectionItem);
begin
  inherited Update(Item);

  if Assigned(OnChange) then
  begin
    OnChange(Self);
  end;
end;

{ TclXmlSecurityAlgorithm }

procedure TclXmlSecurityAlgorithm.Assign(Source: TPersistent);
begin
  if (Source is TclXmlSecurityAlgorithm) then
  begin
    FName := TclXmlSecurityAlgorithm(Source).Name;
    FIdentifier := TclXmlSecurityAlgorithm(Source).Identifier;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclXmlSecurityAlgorithm.SetIdentifier(const Value: Integer);
begin
  if (FIdentifier <> Value) then
  begin
    FIdentifier := Value;
    Changed(False);
  end;
end;

procedure TclXmlSecurityAlgorithm.SetName(const Value: string);
begin
  if (FName <> Value) then
  begin
    FName := Value;
    Changed(False);
  end;
end;

{ TclSoapNameSpace }

procedure TclSoapNameSpace.Assign(Source: TPersistent);
begin
  if (Source is TclSoapNameSpace) then
  begin
    Prefix := TclSoapNameSpace(Source).Prefix;
    NameSpace := TclSoapNameSpace(Source).NameSpace;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclSoapNameSpace.SetNameSpace(const Value: string);
begin
  if (FNameSpace <> Value) then
  begin
    FNameSpace := Value;
    Changed(False);
  end;
end;

procedure TclSoapNameSpace.SetPrefix(const Value: string);
begin
  if (FPrefix <> Value) then
  begin
    FPrefix := Value;
    Changed(False);
  end;
end;

{ TclSoapNameSpaceList }

function TclSoapNameSpaceList.Add: TclSoapNameSpace;
begin
  Result := TclSoapNameSpace(inherited Add());
end;

function TclSoapNameSpaceList.AddNameSpace(const APrefix, ANameSpace: string): TclSoapNameSpace;
begin
  Result := Add();
  Result.Prefix := APrefix;
  Result.NameSpace := ANameSpace;
end;

function TclSoapNameSpaceList.GetItem(Index: Integer): TclSoapNameSpace;
begin
  Result := TclSoapNameSpace(inherited GetItem(Index));
end;

function TclSoapNameSpaceList.ItemByNameSpace(const ANameSpace: string): TclSoapNameSpace;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if (Result.NameSpace = ANameSpace) then Exit;
  end;
  Result := nil;
end;

function TclSoapNameSpaceList.GetPrefix(const ANameSpace: string): string;
var
  item: TclSoapNameSpace;
begin
  item := ItemByNameSpace(ANameSpace);
  if (item <> nil) then
  begin
    Result := item.Prefix;
  end else
  begin
    Result := '';
  end;
end;

procedure TclSoapNameSpaceList.SetItem(Index: Integer; const Value: TclSoapNameSpace);
begin
  inherited SetItem(Index, Value);
end;

function TclSoapNameSpaceList.ToString: string;
var
  i: Integer;
  item: TclSoapNameSpace;
begin
  Result := '';

  for i := 0 to Count - 1 do
  begin
    item := Items[i];
    Result := Result + GetAttributeText(' ' + item.Prefix, item.NameSpace);
  end;
end;

procedure TclSoapNameSpaceList.Update(Item: TCollectionItem);
begin
  inherited Update(Item);

  if Assigned(OnChange) then
  begin
    OnChange(Self);
  end;
end;

{ TclXmlSecurityConfig }

procedure TclXmlSecurityConfig.Assign(Source: TPersistent);
var
  src: TclXmlSecurityConfig;
begin
  if (Source is TclXmlSecurityConfig) then
  begin
    src := (Source as TclXmlSecurityConfig);

    FIdName := Src.IdName;
    FPaddingMode := Src.PaddingMode;
    FProviderType := Src.ProviderType;
    FCSP := Src.CSP;
    CryptAlgorithms := Src.CryptAlgorithms;
    HashAlgorithms := Src.HashAlgorithms;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclXmlSecurityConfig.AssignDefaultAlgorithms;
begin
  HashAlgorithms.AddAlgorithm('md2', CALG_MD2);
  HashAlgorithms.AddAlgorithm('md5', CALG_MD5);
  HashAlgorithms.AddAlgorithm('sha1', CALG_SHA1);

  CryptAlgorithms.AddAlgorithm('aes256', CALG_AES_256, 256 div 8);
  CryptAlgorithms.AddAlgorithm('aes192', CALG_AES_192, 192 div 8);
  CryptAlgorithms.AddAlgorithm('aes128', CALG_AES_128, 128 div 8);
end;

procedure TclXmlSecurityConfig.AssignDefaultNamespaces;
begin
  Namespaces.AddNameSpace('env', soap12NameSpaceName);
  Namespaces.AddNameSpace('soapenv', envelopeNameSpaceName);
  Namespaces.AddNameSpace('ds', dsNameSpaceName);
  Namespaces.AddNameSpace('wsse', wsseNameSpaceName);
  Namespaces.AddNameSpace('wsu', wsuNameSpaceName);
  Namespaces.AddNameSpace('wsa', wsaNameSpaceName);
  Namespaces.AddNameSpace('xenc', xencNameSpaceName);
  Namespaces.AddNameSpace('wsse11', wsse11NameSpaceName);
end;

constructor TclXmlSecurityConfig.Create(AOwner: TPersistent);
begin
  inherited Create();

  FOwner := AOwner;

  FHashAlgorithms := TclXmlSecurityAlgorithmList.Create(Self, TclXmlSecurityAlgorithm);
  FCryptAlgorithms := TclXmlEncryptionAlgorithmList.Create(Self, TclXmlEncryptionAlgorithm);
  FNamespaces := TclSoapNameSpaceList.Create(Self, TclSoapNameSpace);

  FIdName := DefaultIdName;
  FPaddingMode := pmISO10126;
  FProviderType := PROV_RSA_FULL;
  FCSP := '';
  FSignatureStyle := ssJava;

  AssignDefaultAlgorithms();
  AssignDefaultNamespaces();
end;

destructor TclXmlSecurityConfig.Destroy;
begin
  FreeMem(FCSPPtr);
  FCSPPtr := nil;

  FNamespaces.Free();
  FCryptAlgorithms.Free();
  FHashAlgorithms.Free();

  inherited Destroy();
end;

function TclXmlSecurityConfig.GetCSP: PclChar;
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

function TclXmlSecurityConfig.GetOwner: TPersistent;
begin
  Result := FOwner;
end;

procedure TclXmlSecurityConfig.SetCryptAlgorithms(const Value: TclXmlEncryptionAlgorithmList);
begin
  FCryptAlgorithms.Assign(Value);
end;

procedure TclXmlSecurityConfig.SetCSP(const Value: string);
begin
  if (FCSP <> Value) then
  begin
    FCSP := Value;
    FreeMem(FCSPPtr);
    FCSPPtr := nil;
    Update();
  end;
end;

procedure TclXmlSecurityConfig.SetHashAlgorithms(const Value: TclXmlSecurityAlgorithmList);
begin
  FHashAlgorithms.Assign(Value);
end;

procedure TclXmlSecurityConfig.SetIdName(const Value: string);
begin
  if (FIdName <> Value) then
  begin
    FIdName := Value;
    Update();
  end;
end;

procedure TclXmlSecurityConfig.SetNamespaces(const Value: TclSoapNameSpaceList);
begin
  FNamespaces.Assign(Value);
end;

procedure TclXmlSecurityConfig.SetPaddingMode(const Value: TclPaddingMode);
begin
  if (FPaddingMode <> Value) then
  begin
    FPaddingMode := Value;
    Update();
  end;
end;

procedure TclXmlSecurityConfig.SetProviderType(const Value: Integer);
begin
  if (FProviderType <> Value) then
  begin
    FProviderType := Value;
    Update();
  end;
end;

procedure TclXmlSecurityConfig.SetSignatureStyle(const Value: TclSignatureStyle);
begin
  if (FSignatureStyle <> Value) then
  begin
    FSignatureStyle := Value;
    Update();
  end;
end;

procedure TclXmlSecurityConfig.Update;
begin
  if Assigned(OnChange) then
  begin
    OnChange(Self);
  end;
end;

{ TclXmlEncryptedKeyRSA }

procedure TclXmlEncryptedKeyRSA.DoDecryptSessionKey(ACertificate: TclCertificate;
  const AStoreName: string; AStoreLocation: TclCertificateStoreLocation);
var
  keyData, key: TclByteArray;
  keyLen, res: Integer;
  oaep: Boolean;
begin
{$IFNDEF DELPHI2005}keyData := nil; key := nil;{$ENDIF}
  if (ACertificate = nil) then
  begin
    raise EclSoapMessageError.Create(CertificateRequired, CertificateRequiredCode);
  end;

  if (CipherValue = '') then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  oaep := IsOAEP();

  keyData := TclEncoder.DecodeBytes(CipherValue, cmBase64);

  keyLen := SessionKeySize;
  SetLength(key, keyLen);
  res := RsaDecryptKeyExchange(PWideChar(WideString(ACertificate.Thumbprint)), PWideChar(WideString(AStoreName)),
    GetStoreLocationInt(AStoreLocation), keyData, Length(keyData), key, keyLen, oaep);
  if (res = 0) then
  begin
    raise EclSoapMessageError.Create(SoapDecryptFailed, SoapDecryptFailedCode);
  end;

  if (res <> keyLen) then
  begin
    keyLen := res;
    SetLength(key, keyLen);
    res := RsaDecryptKeyExchange(PWideChar(WideString(ACertificate.Thumbprint)), PWideChar(WideString(AStoreName)),
      GetStoreLocationInt(AStoreLocation), keyData, Length(keyData), key, keyLen, oaep);
    if (res = 0) then
    begin
      raise EclSoapMessageError.Create(SoapDecryptFailed, SoapDecryptFailedCode);
    end;
  end;

  SessionKey := TclCryptData.Create();
  SessionKey.FromBytes(key);
end;

function TclXmlEncryptedKeyRSA.DoEncryptSessionKey(ACertificate: TclCertificate;
  const AStoreName: string; AStoreLocation: TclCertificateStoreLocation): string;
var
  keyData, key: TclByteArray;
  keyLen, res: Integer;
  oaep: Boolean;
begin
{$IFNDEF DELPHI2005}keyData := nil; key := nil;{$ENDIF}
  if (ACertificate = nil) then
  begin
    raise EclSoapMessageError.Create(CertificateRequired, CertificateRequiredCode);
  end;

  if (SessionKey = nil) or (SessionKey.DataSize = 0) or (SessionKeySize = 0) then
  begin
    raise EclSoapMessageError.Create(EncryptKeySizeError, EncryptKeySizeErrorCode);
  end;

  oaep := IsOAEP();

  keyData := SessionKey.ToBytes();

  keyLen := SessionKeySize * 4;
  SetLength(key, keyLen);

  res := RsaEncryptKeyExchange(PWideChar(WideString(ACertificate.Thumbprint)), PWideChar(WideString(AStoreName)),
    GetStoreLocationInt(AStoreLocation), keyData, Length(keyData), key, keyLen, oaep);
  if (res = 0) then
  begin
    raise EclSoapMessageError.Create(SoapEncryptFailed, SoapEncryptFailedCode);
  end;

  if (res <> keyLen) then
  begin
    keyLen := res;
    SetLength(key, keyLen);
    res := RsaEncryptKeyExchange(PWideChar(WideString(ACertificate.Thumbprint)), PWideChar(WideString(AStoreName)),
      GetStoreLocationInt(AStoreLocation), keyData, Length(keyData), key, keyLen, oaep);
    if (res = 0) then
    begin
      raise EclSoapMessageError.Create(SoapEncryptFailed, SoapEncryptFailedCode);
    end;
  end;

  CipherValue := TclEncoder.EncodeBytesToString(key, cmBase64);
end;

function TclXmlEncryptedKeyRSA.IsOAEP: Boolean;
begin
  Result := (System.Pos('oaep', EncryptionMethod) > 0);
end;

function TclXmlEncryptedKeyRSA.SupportsMethod(const AEncryptionMethod: string): Boolean;
begin
  Result := (System.Pos('rsa', AEncryptionMethod) > 0);
end;

{ TclXmlSignReference }

procedure TclXmlSignReference.Assign(Source: TPersistent);
var
  src: TclXmlSignReference;
begin
  if (Source is TclXmlSignReference) then
  begin
    src := TclXmlSignReference(Source);

    FDigestValue := src.DigestValue;
    FURI := src.URI;
    FDigestMethod := src.DigestMethod;
    Transforms := src.Transforms;
  end else
  begin
    inherited Assign(Source);
  end;
end;

constructor TclXmlSignReference.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  FTransforms := TclXmlTransformInfoList.Create(Self, TclXmlTransformInfo);
  FTransforms.OnChange := DoTransformsChanged;

  FTransforms.Add(ALGO_ID_C14N_EXCL_OMIT_COMMENTS, '');
  FDigestMethod := SHA1_AlgorithmName;
end;

destructor TclXmlSignReference.Destroy;
begin
  FTransforms.Free();

  inherited Destroy();
end;

procedure TclXmlSignReference.DoTransformsChanged(Sender: TObject);
begin
  Changed(False);
end;

procedure TclXmlSignReference.SetDigestMethod(const Value: string);
begin
  if (FDigestMethod <> Value) then
  begin
    FDigestMethod := Value;
    Changed(False);
  end;
end;

procedure TclXmlSignReference.SetDigestValue(const Value: string);
begin
  if (FDigestValue <> Value) then
  begin
    FDigestValue := Value;
    Changed(False);
  end;
end;

procedure TclXmlSignReference.SetTransforms(const Value: TclXmlTransformInfoList);
begin
  FTransforms.Assign(Value);
end;

procedure TclXmlSignReference.SetURI(const Value: string);
begin
  if (FURI <> Value) then
  begin
    FURI := Value;
    Changed(False);
  end;
end;

{ TclXmlSignReferenceList }

function TclXmlSignReferenceList.Add: TclXmlSignReference;
begin
  Result := TclXmlSignReference(inherited Add());
end;

function TclXmlSignReferenceList.Add(const AURI: string): TclXmlSignReference;
begin
  Result := Add();
  Result.URI := AURI;
end;

function TclXmlSignReferenceList.GetItem(Index: Integer): TclXmlSignReference;
begin
  Result := TclXmlSignReference(inherited GetItem(Index));
end;

procedure TclXmlSignReferenceList.SetItem(Index: Integer; const Value: TclXmlSignReference);
begin
  inherited SetItem(Index, Value);
end;

procedure TclXmlSignReferenceList.Update(Item: TCollectionItem);
begin
  inherited Update(Item);

  if Assigned(OnChange) then
  begin
    OnChange(Self);
  end;
end;

{ TclXmlEncryptReference }

procedure TclXmlEncryptReference.Assign(Source: TPersistent);
var
  src: TclXmlEncryptReference;
begin
  if (Source is TclXmlEncryptReference) then
  begin
    src := TclXmlEncryptReference(Source);

    FURI := src.URI;
    FEncryptedDataURI := src.EncryptedDataURI;
    FEncryptionMethod := src.EncryptionMethod;
    FEncryptionType := src.EncryptionType;
  end else
  begin
    inherited Assign(Source);
  end;
end;

constructor TclXmlEncryptReference.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  FEncryptionMethod := AES_256_CBC_AlgorithmName;
  FEncryptionType := EncryptionTypeContent;
end;

procedure TclXmlEncryptReference.SetEncryptedDataURI(const Value: string);
begin
  if (FEncryptedDataURI <> Value) then
  begin
    FEncryptedDataURI := Value;
    Changed(False);
  end;
end;

procedure TclXmlEncryptReference.SetEncryptionMethod(const Value: string);
begin
  if (FEncryptionMethod <> Value) then
  begin
    FEncryptionMethod := Value;
    Changed(False);
  end;
end;

procedure TclXmlEncryptReference.SetEncryptionType(const Value: string);
begin
  if (FEncryptionType <> Value) then
  begin
    FEncryptionType := Value;
    Changed(False);
  end;
end;

procedure TclXmlEncryptReference.SetURI(const Value: string);
begin
  if (FURI <> Value) then
  begin
    FURI := Value;
    Changed(False);
  end;
end;

{ TclXmlEncryptReferenceList }

function TclXmlEncryptReferenceList.Add: TclXmlEncryptReference;
begin
  Result := TclXmlEncryptReference(inherited Add());
end;

function TclXmlEncryptReferenceList.Add(const AURI: string): TclXmlEncryptReference;
begin
  Result := Add();
  Result.URI := AURI;
end;

function TclXmlEncryptReferenceList.Add(const AURI, AEncryptionMethod: string): TclXmlEncryptReference;
begin
  Result := Add();
  Result.URI := AURI;
  Result.EncryptionMethod := AEncryptionMethod;
end;

function TclXmlEncryptReferenceList.GetItem(Index: Integer): TclXmlEncryptReference;
begin
  Result := TclXmlEncryptReference(inherited GetItem(Index));
end;

procedure TclXmlEncryptReferenceList.SetItem(Index: Integer; const Value: TclXmlEncryptReference);
begin
  inherited SetItem(Index, Value);
end;

procedure TclXmlEncryptReferenceList.Update(Item: TCollectionItem);
begin
  inherited Update(Item);

  if Assigned(OnChange) then
  begin
    OnChange(Self);
  end;
end;

{ TclXmlSignature }

procedure TclXmlSignature.BuildKeyInfo(ACertificate: TclCertificate; const ASignature, ASecurity: IXMLDOMNode);
begin
  if (KeyInfo <> nil) then
  begin
    KeyInfo.AssignCertificate(ACertificate);
    KeyInfo.Build(ASignature, ASecurity);
  end;
end;

procedure TclXmlSignature.BuildReferenceItem(AReferenceItem: TclXmlSignReference;
  const AOwnerNode: IXMLDOMNode; const AEnvelope: IXMLDOMDocument);
var
  node, refNode: IXMLDOMNode;
  dsNameSpace: string;
begin
  dsNameSpace := Config.Namespaces.GetPrefix(dsNameSpaceName);
  refNode := AEnvelope.createElement(GetSoapNodeName(dsNameSpace, 'Reference'));
  AOwnerNode.appendChild(refNode);

  SetAttributeValue(refNode, 'URI', AReferenceItem.URI);

  BuildTransforms(AReferenceItem, refNode);

  node := AEnvelope.createElement(GetSoapNodeName(dsNameSpace, 'DigestMethod'));
  refNode.appendChild(node);
  SetAttributeValue(node, 'Algorithm', AReferenceItem.DigestMethod);

  DoCreateReferenceDigest(AReferenceItem, AEnvelope);

  AddNodeValue(refNode, GetSoapNodeName(dsNameSpace, 'DigestValue'), AReferenceItem.DigestValue);
end;

procedure TclXmlSignature.BuildReferenceList(const AOwnerNode: IXMLDOMNode; const AEnvelope: IXMLDOMDocument);
var
  i: Integer;
begin
  for i := 0 to ReferenceList.Count - 1 do
  begin
    BuildReferenceItem(ReferenceList[i], AOwnerNode, AEnvelope);
  end;
end;

function TclXmlSignature.BuildSignedInfo(const ASignature: IXMLDOMNode): IXMLDOMNode;
var
  node: IXMLDOMNode;
  dsNameSpace: string;
begin
  dsNameSpace := Config.Namespaces.GetPrefix(dsNameSpaceName);
  Result := ASignature.ownerDocument.createElement(GetSoapNodeName(dsNameSpace, 'SignedInfo'));
  ASignature.appendChild(Result);

  node := ASignature.ownerDocument.createElement(GetSoapNodeName(dsNameSpace, 'CanonicalizationMethod'));
  Result.appendChild(node);
  SetAttributeValue(node, 'Algorithm', CanonicalizationMethod);

  node := ASignature.ownerDocument.createElement(GetSoapNodeName(dsNameSpace, 'SignatureMethod'));
  Result.appendChild(node);
  SetAttributeValue(node, 'Algorithm', SignatureMethod);
end;

procedure TclXmlSignature.BuildTransforms(AReferenceItem: TclXmlSignReference; const ARefNode: IXMLDOMNode);
var
  i: Integer;
  node, transforms: IXMLDOMNode;
  dsNameSpace: string;
begin
  dsNameSpace := Config.Namespaces.GetPrefix(dsNameSpaceName);
  transforms := ARefNode.ownerDocument.createElement(GetSoapNodeName(dsNameSpace, 'Transforms'));
  ARefNode.appendChild(transforms);

  for i := 0 to AReferenceItem.Transforms.Count - 1 do
  begin
    node := ARefNode.ownerDocument.createElement(GetSoapNodeName(dsNameSpace, 'Transform'));
    transforms.appendChild(node);

    SetAttributeValue(node, 'Algorithm', AReferenceItem.Transforms[i].Algorithm);
    //TODO AReferenceItem.Transforms[i].Parameters
  end;
end;

procedure TclXmlSignature.Clear;
begin
  ID := '';
  SignatureMethod := '';
  SignatureValue := '';
  CanonicalizationMethod := '';

  KeyInfo := nil;
  ReferenceList.Clear();
end;

constructor TclXmlSignature.Create(AReferenceList: TclXmlSignReferenceList; AConfig: TclXmlSecurityConfig);
begin
  inherited Create();

  FReferenceList := AReferenceList;
  FConfig := AConfig;
end;

class function TclXmlSignature.CreateInstance(const ASignatureMethod: string;
  AReferenceList: TclXmlSignReferenceList; AConfig: TclXmlSecurityConfig): TclXmlSignature;
var
  i: Integer;
begin
  Result := nil;

  for i := 0 to RegisteredSignatures().Count - 1 do
  begin
    Result := TclXmlSignatureClass(RegisteredSignatures()[i]).Create(AReferenceList, AConfig);
    try
      if Result.SupportsMethod(ASignatureMethod) then
      begin
        Result.SignatureMethod := ASignatureMethod;
        Break;
      end;
      FreeAndNil(Result);
    except
      Result.Free();
      raise;
    end;
  end;

  if (Result = nil) then
  begin
    raise EclSoapMessageError.Create(SignatureMethodError, SignatureMethodErrorCode);
  end;
end;

destructor TclXmlSignature.Destroy;
begin
  KeyInfo := nil;

  inherited Destroy();
end;

procedure TclXmlSignature.DoCreateReferenceDigest(AReferenceItem: TclXmlSignReference; const AEnvelope: IXMLDOMDocument);
var
  digest: TclXmlDigest;
begin
  digest := TclXmlDigest.Create(Config);
  try
    digest.CreateDigest(AReferenceItem, DoSelectReferenceData(AReferenceItem.URI, AEnvelope));
  finally
    digest.Free();
  end;
end;

function TclXmlSignature.DoParse(const ASecurity, ASignature: IXMLDOMNode): Boolean;
begin
  Clear();

  if (ASecurity = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  FSignature := ASignature;
  if (FSignature = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  FSignedInfo := GetNodeByName(FSignature, 'SignedInfo');
  if (FSignedInfo = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  ParseSignature(FSignature, FSignedInfo);
  ParseReferenceList(FSignedInfo);
  ParseKeyInfo(FSignature, ASecurity);

  Result := SupportsMethod(SignatureMethod);
end;

function TclXmlSignature.DoSelectReferenceData(const AURI: string; const AEnvelope: IXMLDOMDocument): IXMLDOMNode;
var
  s: string;
begin
  s := UriReference2Id(AURI);

  Result := AEnvelope.selectSingleNode('//*[@' + GetAttributeText(GetSoapNodeName(Config.Namespaces.GetPrefix(wsuNameSpaceName), Config.IdName), s) + ']');
  if (Result = nil) then
  begin
    Result := AEnvelope.selectSingleNode('//*[@' + GetAttributeText(Config.IdName, s) + ']');
    if (Result = nil) then
    begin
      raise EclSoapMessageError.Create(SoapDataNotFound, SoapDataNotFoundCode);
    end;
  end;
end;

procedure TclXmlSignature.DoVerifyReferenceDigest(AReferenceItem: TclXmlSignReference; const AEnvelope: IXMLDOMDocument);
var
  digest: TclXmlDigest;
begin
  digest := TclXmlDigest.Create(Config);
  try
    digest.Verify(AReferenceItem, DoSelectReferenceData(AReferenceItem.URI, AEnvelope));
  finally
    digest.Free();
  end;
end;

class function TclXmlSignature.Parse(const ASecurity, ASignature: IXMLDOMNode;
  AReferenceList: TclXmlSignReferenceList; AConfig: TclXmlSecurityConfig): TclXmlSignature;
var
  i: Integer;
begin
  Result := nil;

  for i := 0 to RegisteredSignatures().Count - 1 do
  begin
    Result := TclXmlSignatureClass(RegisteredSignatures()[i]).Create(AReferenceList, AConfig);
    try
      if Result.DoParse(ASecurity, ASignature) then
      begin
        Break;
      end;
      FreeAndNil(Result);
    except
      Result.Free();
      raise;
    end;
  end;

  if (Result = nil) then
  begin
    raise EclSoapMessageError.Create(SignatureMethodError, SignatureMethodErrorCode);
  end;
end;

procedure TclXmlSignature.ParseKeyInfo(const ASignature, ASecurity: IXMLDOMNode);
var
  ki: IXMLDOMNode;
begin
  ki := GetNodeByName(ASignature, 'KeyInfo');
  KeyInfo := TclXmlKeyInfo.Parse(ki, ASecurity, FConfig);
end;

procedure TclXmlSignature.ParseReferenceItem(const AReferenceNode: IXMLDOMNode; AReferenceItem: TclXmlSignReference);
var
  node: IXMLDOMNode;
begin
  AReferenceItem.URI := GetAttributeValue(AReferenceNode, 'URI');

  node := GetNodeByName(AReferenceNode, 'DigestMethod');
  if (node <> nil) then
  begin
    AReferenceItem.DigestMethod := GetAttributeValue(node, 'Algorithm');
  end;
  AReferenceItem.DigestValue := GetNodeValueByName(AReferenceNode, 'DigestValue');

  ParseTransforms(AReferenceNode, AReferenceItem);
end;

procedure TclXmlSignature.ParseReferenceList(const ASignedInfo: IXMLDOMNode);
var
  list: IXMLDomNodeList;
  refNode: IXMLDomNode;
  refItem: TclXmlSignReference;
begin
  list := ASignedInfo.childNodes;
  if (list = nil) then Exit;

  refNode := list.nextNode;
  while (refNode <> nil) do
  begin
    if (refNode.baseName = 'Reference') then
    begin
      refItem := FReferenceList.Add();
      ParseReferenceItem(refNode, refItem);
    end;
    refNode := list.nextNode;
  end;
  refNode := nil;
end;

procedure TclXmlSignature.ParseSignature(const ASignature, ASignedInfo: IXMLDOMNode);
var
  node: IXMLDOMNode;
begin
  ID := GetAttributeValue(ASignature, Config.IdName);
  SignatureValue := GetNodeValueByName(ASignature, 'SignatureValue');

  node := GetNodeByName(ASignedInfo, 'CanonicalizationMethod');
  if (node <> nil) then
  begin
    CanonicalizationMethod := GetAttributeValue(node, 'Algorithm');
  end;

  node := GetNodeByName(ASignedInfo, 'SignatureMethod');
  if (node <> nil) then
  begin
    SignatureMethod := GetAttributeValue(node, 'Algorithm');
  end;
end;

procedure TclXmlSignature.ParseTransforms(const AReferenceNode: IXMLDOMNode; AReferenceItem: TclXmlSignReference);
var
  node, transforms: IXMLDOMNode;
  list: IXMLDomNodeList;
begin
  AReferenceItem.Transforms.Clear();

  transforms := GetNodeByName(AReferenceNode, 'Transforms');
  if (transforms <> nil) then
  begin
    list := transforms.childNodes;
    if (list <> nil) then
    begin
      node := list.nextNode;
      while (node <> nil) do
      begin
        if (node.baseName = 'Transform') then
        begin
          if (node.firstChild <> nil) then
          begin
            AReferenceItem.Transforms.Add(GetAttributeValue(node, 'Algorithm'), string(node.firstChild.xml));
          end else
          begin
            AReferenceItem.Transforms.Add(GetAttributeValue(node, 'Algorithm'));
          end;
        end;
        node := list.nextNode;
      end;
    end;
  end;
end;

class function TclXmlSignature.RegisteredSignatures: TList;
begin
  if (RegXmlSignatures = nil) then
  begin
    RegXmlSignatures := TList.Create();
  end;
  Result := RegXmlSignatures;
end;

class procedure TclXmlSignature.RegisterSignature(ASignatureClass: TclXmlSignatureClass);
begin
  RegisteredSignatures().Add(ASignatureClass);
end;

procedure TclXmlSignature.SetKeyInfo(const Value: TclXmlKeyInfo);
begin
  FKeyInfo.Free();
  FKeyInfo := Value;
end;

procedure TclXmlSignature.Sign(ACertificate: TclCertificate; const AEnvelope: IXMLDOMDocument);
var
  head, sec, sig, signedInfo: IXMLDOMNode;
  dsNameSpace: string;
begin
  AEnvelope.loadXML(AEnvelope.xml);
  if (not AEnvelope.parsed) then
  begin
    raise EclSoapMessageError.Create(AEnvelope.parseError.reason, AEnvelope.parseError.errorCode);
  end;

  head := GetNodeByName(AEnvelope.documentElement, 'Header');
  if (head = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;
  sec := GetNodeByName(head, 'Security');
  if (sec = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  dsNameSpace := Config.Namespaces.GetPrefix(dsNameSpaceName);
  sig := AEnvelope.createElement(GetSoapNodeName(dsNameSpace, 'Signature'));
  sec.appendChild(sig);

  SetAttributeValue(sig, GetSoapNamespace(dsNameSpace), dsNameSpaceName);
  SetAttributeValue(sig, Config.IdName, ID);

  signedInfo := BuildSignedInfo(sig);

  BuildReferenceList(signedInfo, AEnvelope);

  AEnvelope.loadXML(AEnvelope.xml);
  if (not AEnvelope.parsed) then
  begin
    raise EclSoapMessageError.Create(AEnvelope.parseError.reason, AEnvelope.parseError.errorCode);
  end;

  head := GetNodeByName(AEnvelope.documentElement, 'Header');
  sec := GetNodeByName(head, 'Security');
  if (ID <> '') then
  begin
    sig := GetNodeByAttributeName(sec, Config.IdName, ID);
  end else
  begin
    sig := GetNodeByName(sec, 'Signature');
  end;
  signedInfo := GetNodeByName(sig, 'SignedInfo');

  DoCreateSignature(ACertificate, signedInfo);

  AddNodeValue(sig, GetSoapNodeName(dsNameSpace, 'SignatureValue'), SignatureValue);

  BuildKeyInfo(ACertificate, sig, sec);
end;

procedure TclXmlSignature.Verify(ACertificate: TclCertificate; const AEnvelope: IXMLDOMDocument);
begin
  DoVerifySignature(ACertificate, FSignedInfo);
  VerifyReferenceDigests(AEnvelope);
  RemoveNode(FSignature);
end;

procedure TclXmlSignature.VerifyReferenceDigests(const AEnvelope: IXMLDOMDocument);
var
  i: Integer;
begin
  for i := 0 to ReferenceList.Count - 1 do
  begin
    DoVerifyReferenceDigest(ReferenceList[i], AEnvelope);
  end;
end;

{ TclXmlSignatureRSA }

function TclXmlSignatureRSA.CreateSignature(ACertificate: TclCertificate; const AData: IXMLDOMNode): string;
var
  sig: TclByteArray;
  data: TclXmlTransformData;
begin
{$IFNDEF DELPHI2005}sig := nil;{$ENDIF}
  data := TclXmlTransformData.Create();
  try
    data.Node := AData;

    TclXmlTransform.Transform(CanonicalizationMethod, '', data, Config);

    data.Bytes := XmlCrlfDecode(data.Bytes);

    sig := GetSignatureValue(ACertificate, data.Bytes);

    if (Config.SignatureStyle = ssJava) then
    begin
      sig := ReversedBytes(sig);
    end;

    Result := TclEncoder.EncodeBytesToString(sig, cmBase64);
  finally
    data.Free();
  end;
end;

procedure TclXmlSignatureRSA.DoCreateSignature(ACertificate: TclCertificate; const ASignedInfo: IXMLDOMNode);
begin
  if (ACertificate = nil) then
  begin
    raise EclSoapMessageError.Create(CertificateRequired, CertificateRequiredCode);
  end;

  if (ASignedInfo = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  SignatureValue := CreateSignature(ACertificate, ASignedInfo);
end;

procedure TclXmlSignatureRSA.DoVerifySignature(ACertificate: TclCertificate; const ASignedInfo: IXMLDOMNode);
begin
  if (ACertificate = nil) then
  begin
    raise EclSoapMessageError.Create(CertificateRequired, CertificateRequiredCode);
  end;

  if (SignatureValue = '') then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  if (ASignedInfo = nil) then
  begin
    raise EclSoapMessageError.Create(SoapFormatError, SoapFormatErrorCode);
  end;

  VerifySignature(ACertificate, ASignedInfo, SignatureValue);
end;

function TclXmlSignatureRSA.GetSignatureValue(ACertificate: TclCertificate; const AXml: TclByteArray): TclByteArray;
var
  context: HCRYPTPROV;
  hash: HCRYPTHASH;
  sigData: TclCryptData;
  sigSize, keySpec: DWORD;
  callerFree: BOOL;
begin
  context := nil;
  keySpec := 0;
  callerFree := FALSE;

  if (not CryptAcquireCertificatePrivateKey(ACertificate.Context,
    CRYPT_ACQUIRE_COMPARE_KEY_FLAG, nil, @context, @keySpec, @callerFree)) or (not callerFree) then
  begin
    RaiseCryptError('CryptAcquireCertificatePrivateKey');
  end;
  try
    if not CryptCreateHash(context, Config.HashAlgorithms.GetIdentifier(SignatureMethod), nil, 0, @hash) then
    begin
      RaiseCryptError('CryptCreateHash');
    end;
    sigData := TclCryptData.Create();
    try
      if not CryptHashData(hash, PByte(AXml), Length(AXml), 0) then
      begin
        RaiseCryptError('CryptHashData');
      end;
      if not CryptSignHash(hash, keySpec, nil, 0, nil, @sigSize) then
      begin
        RaiseCryptError('CryptSignHash');
      end;
      if (sigSize <= 0) then
      begin
        raise EclSoapMessageError.Create(HashSizeInvalidError, HashSizeInvalidErrorCode);
      end;
      sigData.Allocate(sigSize);
      if not CryptSignHash(hash, keySpec, nil, 0, sigData.Data, @sigSize) then
      begin
        RaiseCryptError('CryptSignHash');
      end;
      SetLength(Result, sigSize);
      system.Move(sigData.Data^, Result[0], sigSize);
    finally
      sigData.Free();
      CryptDestroyHash(hash);
    end;
  finally
    CryptReleaseContext(context, 0);
  end;
end;

function TclXmlSignatureRSA.SupportsMethod(const ASignatureMethod: string): Boolean;
begin
  Result := (System.Pos('rsa', ASignatureMethod) > 0);
end;

procedure TclXmlSignatureRSA.VerifySignatureValue(ACertificate: TclCertificate;
  const AData, ASignature: TclByteArray);
var
  context: HCRYPTPROV;
  hash: HCRYPTHASH;
  key: HCRYPTKEY;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  if not CryptAcquireContext(@context, nil, Config.GetCSP(), Config.ProviderType, CRYPT_VERIFYCONTEXT) then
  begin
    RaiseCryptError('CryptAcquireContext');
  end;
  try
    if not CryptImportPublicKeyInfoEx(context, DefaultEncoding,
      @ACertificate.Context.pCertInfo.SubjectPublicKeyInfo, 0, 0, nil, @key) then
    begin
      RaiseCryptError('CryptImportPublicKeyInfoEx');
    end;
    try
      if not CryptCreateHash(context, Config.HashAlgorithms.GetIdentifier(SignatureMethod), nil, 0, @hash) then
      begin
        RaiseCryptError('CryptCreateHash');
      end;
      try
        if not CryptHashData(hash, PByte(AData), Length(AData), 0) then
        begin
          RaiseCryptError('CryptHashData');
        end;

        if not CryptVerifySignature(hash, PByte(ASignature), Length(ASignature), key, nil, 0) then
        begin
          buf := ReversedBytes(ASignature);
          if not CryptVerifySignature(hash, PByte(buf), Length(buf), key, nil, 0) then
          begin
            RaiseCryptError('CryptVerifySignature');
          end;
        end;
      finally
        CryptDestroyHash(hash);
      end;
    finally
      CryptDestroyKey(key);
    end;
  finally
    CryptReleaseContext(context, 0);
  end;
end;

procedure TclXmlSignatureRSA.VerifySignature(ACertificate: TclCertificate;
  const AData: IXMLDOMNode; const ASignature: string);
var
  encodedSig: string;
  sig: TclByteArray;
  data: TclXmlTransformData;
begin
{$IFNDEF DELPHI2005}sig := nil;{$ENDIF}
  data := TclXmlTransformData.Create();
  try
    encodedSig := StringReplace(ASignature, #32, '', [rfReplaceAll]);
    encodedSig := StringReplace(encodedSig, #10, #13#10, [rfReplaceAll]);

    sig := TclEncoder.DecodeBytes(encodedSig, cmBase64);

    data.Node := AData;

    TclXmlTransform.Transform(CanonicalizationMethod, '', data, Config);

    data.Bytes := XmlCrlfDecode(data.Bytes);
    VerifySignatureValue(ACertificate, data.Bytes, sig);
  finally
    data.Free();
  end;
end;

{ TclXmlTransformInfo }

procedure TclXmlTransformInfo.Assign(Source: TPersistent);
begin
  if (Source is TclXmlTransformInfo) then
  begin
    FAlgorithm := TclXmlTransformInfo(Source).Algorithm;
    FParameters := TclXmlTransformInfo(Source).Parameters;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclXmlTransformInfo.SetAlgorithm(const Value: string);
begin
  if (FAlgorithm <> Value) then
  begin
    FAlgorithm := Value;
    Changed(False);
  end;
end;

procedure TclXmlTransformInfo.SetParameters(const Value: string);
begin
  if (FParameters <> Value) then
  begin
    FParameters := Value;
    Changed(False);
  end;
end;

{ TclXmlTransformInfoList }

function TclXmlTransformInfoList.Add(const Algorithm, AParameters: string): TclXmlTransformInfo;
begin
  Result := Add();
  Result.Algorithm := Algorithm;
  Result.Parameters := AParameters;
end;

function TclXmlTransformInfoList.Add: TclXmlTransformInfo;
begin
  Result := TclXmlTransformInfo(inherited Add());
end;

function TclXmlTransformInfoList.Add(const Algorithm: string): TclXmlTransformInfo;
begin
  Result := Add();
  Result.Algorithm := Algorithm;
end;

function TclXmlTransformInfoList.GetItem(Index: Integer): TclXmlTransformInfo;
begin
  Result := TclXmlTransformInfo(inherited GetItem(Index));
end;

procedure TclXmlTransformInfoList.SetItem(Index: Integer; const Value: TclXmlTransformInfo);
begin
  inherited SetItem(Index, Value);
end;

procedure TclXmlTransformInfoList.Update(Item: TCollectionItem);
begin
  inherited Update(Item);

  if Assigned(OnChange) then
  begin
    OnChange(Self);
  end;
end;

{ TclXmlTransform }

constructor TclXmlTransform.Create(AConfig: TclXmlSecurityConfig);
begin
  inherited Create();

  FConfig := AConfig;
end;

class function TclXmlTransform.RegisteredTransforms: TList;
begin
  if (RegXmlTransforms = nil) then
  begin
    RegXmlTransforms := TList.Create();
  end;
  Result := RegXmlTransforms;
end;

class procedure TclXmlTransform.RegisterTransform(ATransformClass: TclXmlTransformClass);
begin
  RegisteredTransforms().Add(ATransformClass);
end;

class procedure TclXmlTransform.Transform(const Algorithm, AParameters: string;
  AData: TclXmlTransformData; AConfig: TclXmlSecurityConfig);
var
  i: Integer;
  transform: TclXmlTransform;
  res: Boolean;
begin
  res := False;

  for i := 0 to RegisteredTransforms().Count - 1 do
  begin
    transform := TclXmlTransformClass(RegisteredTransforms()[i]).Create(AConfig);
    try
      res := transform.DoTransform(Algorithm, AParameters, AData);
      if res then
      begin
        Break;
      end;
    finally
      transform.Free();
    end;
  end;

  if (not res) then
  begin
    raise EclSoapMessageError.Create(SoapTransformAlgorithmError, SoapTransformAlgorithmErrorCode);
  end;
end;

class procedure TclXmlTransform.Transform(ATransformInfo: TclXmlTransformInfo;
  AData: TclXmlTransformData; AConfig: TclXmlSecurityConfig);
begin
  Transform(ATransformInfo.Algorithm, ATransformInfo.Parameters, AData, AConfig);
end;

{ TclXmlTransformC14nExcl }

function TclXmlTransformC14nExcl.DoTransform(const Algorithm, AParameters: string; AData: TclXmlTransformData): Boolean;
var
  c14n: TclCanonicalizer20010315Excl;
begin
  Result := False;

  if (AData.Node = nil) then Exit;

  c14n := nil;
  try
    if (Algorithm = ALGO_ID_C14N_EXCL_OMIT_COMMENTS) then
    begin
      c14n := TclCanonicalizer20010315ExclOmitComments.Create();
    end else
    if (Algorithm = ALGO_ID_C14N_EXCL_WITH_COMMENTS) then
    begin
      c14n := TclCanonicalizer20010315ExclWithComments.Create();
    end;

    if (c14n <> nil) then
    begin
      AData.Bytes := c14n.EngineCanonicalizeSubTree(AData.Node);
      Result := True;
    end;
  finally
    c14n.Free();
  end;
end;

{ TclXmlTransformData }

procedure TclXmlTransformData.SetBytes(const Value: TclByteArray);
begin
  FBytes := Value;
  FNode := nil;
end;

procedure TclXmlTransformData.SetNode(const Value: IXMLDOMNode);
begin
  FNode := Value;
  SetLength(FBytes, 0);
end;

{ TclXmlDigest }

procedure TclXmlDigest.ApplyTransforms(ATransforms: TclXmlTransformInfoList; AData: TclXmlTransformData);
var
  i: Integer;
begin
  for i := 0 to ATransforms.Count - 1 do
  begin
    TclXmlTransform.Transform(ATransforms[i].Algorithm, ATransforms[i].Parameters, AData, Config);
  end;

  if (Length(AData.Bytes) = 0) and (AData.Node <> nil) then
  begin
    AData.Bytes := TclTranslator.GetUtf8Bytes(AData.Node.xml);
  end;
end;

constructor TclXmlDigest.Create(AConfig: TclXmlSecurityConfig);
begin
  inherited Create();
  FConfig := AConfig;
end;

procedure TclXmlDigest.CreateDigest(ASignReference: TclXmlSignReference; const AData: IXMLDOMNode);
var
  data: TclXmlTransformData;
  calculated: TclByteArray;
begin
{$IFNDEF DELPHI2005}calculated := nil;{$ENDIF}
  data := TclXmlTransformData.Create();
  try
    data.Node := AData;

    ApplyTransforms(ASignReference.Transforms, data);

    data.Bytes := XmlCrlfDecode(data.Bytes);

    calculated := GetDigestValue(data.Bytes, Config.HashAlgorithms.GetIdentifier(ASignReference.DigestMethod));

    ASignReference.DigestValue := TclEncoder.EncodeBytes(calculated, cmBase64);
  finally
    data.Free();
  end;
end;

function TclXmlDigest.GetDigestValue(const AXml: TclByteArray; AlgId: Integer): TclByteArray;
var
  context: HCRYPTPROV;
  hash: HCRYPTHASH;
  data: TclCryptData;
  hashSize, dwordSize: DWORD;
begin
  if not CryptAcquireContext(@context, nil, Config.GetCSP(), Config.ProviderType, CRYPT_VERIFYCONTEXT) then
  begin
    RaiseCryptError('CryptAcquireContext');
  end;
  try
    if not CryptCreateHash(context, AlgId, nil, 0, @hash) then
    begin
      RaiseCryptError('CryptCreateHash');
    end;
    data := TclCryptData.Create();
    try
      if not CryptHashData(hash, PByte(AXml), Length(AXml), 0) then
      begin
        RaiseCryptError('CryptHashData');
      end;
      dwordSize := SizeOf(DWORD);
      if not CryptGetHashParam(hash, HP_HASHSIZE, @hashSize, @dwordSize, 0) then
      begin
        RaiseCryptError('CryptGetHashParam');
      end;
      if (hashSize <= 0) then
      begin
        raise EclSoapMessageError.Create(HashSizeInvalidError, HashSizeInvalidErrorCode);
      end;
      data.Allocate(hashSize);
      if not CryptGetHashParam(hash, HP_HASHVAL, data.Data, @hashSize, 0) then
      begin
        RaiseCryptError('CryptGetHashParam');
      end;
      SetLength(Result, data.DataSize);
      system.Move(data.Data^, Result[0], data.DataSize);
    finally
      data.Free();
      CryptDestroyHash(hash);
    end;
  finally
    CryptReleaseContext(context, 0);
  end;
end;

procedure TclXmlDigest.Verify(ASignReference: TclXmlSignReference; const AData: IXMLDOMNode);
var
  data: TclXmlTransformData;
begin
  data := TclXmlTransformData.Create();
  try
    data.Node := AData;

    ApplyTransforms(ASignReference.Transforms, data);

    data.Bytes := XmlCrlfDecode(data.Bytes);

    VerifyDigestValue(ASignReference.DigestMethod, data.Bytes, ASignReference.DigestValue);
  finally
    data.Free();
  end;
end;

procedure TclXmlDigest.VerifyDigestValue(const ADigestMethod: string; const AXml: TclByteArray; const ADigestValue: string);
var
  encodedDig: string;
  digest, calculated: TclByteArray;
begin
{$IFNDEF DELPHI2005}digest := nil; calculated := nil;{$ENDIF}
  encodedDig := StringReplace(ADigestValue, #32, '', [rfReplaceAll]);

  digest := TclEncoder.DecodeBytes(encodedDig, cmBase64);

  calculated := GetDigestValue(AXml, Config.HashAlgorithms.GetIdentifier(ADigestMethod));
  if not ByteArrayEquals(calculated, digest) then
  begin
    raise EclSoapMessageError.Create(VerifyDigestFailed, VerifyDigestFailedCode);
  end;
end;

{ TclXmlEncryptionAlgorithm }

procedure TclXmlEncryptionAlgorithm.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if (Source is TclXmlEncryptionAlgorithm) then
  begin
    FKeySize := TclXmlEncryptionAlgorithm(Source).KeySize;
  end;
end;

procedure TclXmlEncryptionAlgorithm.SetKeySize(const Value: Integer);
begin
  if (FKeySize <> Value) then
  begin
    FKeySize := Value;
    Changed(False);
  end;
end;

{ TclXmlEncryptionAlgorithmList }

function TclXmlEncryptionAlgorithmList.Add: TclXmlEncryptionAlgorithm;
begin
  Result := TclXmlEncryptionAlgorithm(inherited Add());
end;

function TclXmlEncryptionAlgorithmList.AddAlgorithm(const AName: string;
  AIdentifier, AKeySize: Integer): TclXmlEncryptionAlgorithm;
begin
  Result := Add();
  Result.Name := AName;
  Result.Identifier := AIdentifier;
  Result.KeySize := AKeySize;
end;

function TclXmlEncryptionAlgorithmList.GetAlgorithm(const Algorithm: string): TclXmlEncryptionAlgorithm;
begin
  Result := TclXmlEncryptionAlgorithm(inherited GetAlgorithm(Algorithm));
end;

function TclXmlEncryptionAlgorithmList.GetEncryptionItem(Index: Integer): TclXmlEncryptionAlgorithm;
begin
  Result := TclXmlEncryptionAlgorithm(inherited GetItem(Index));
end;

procedure TclXmlEncryptionAlgorithmList.SetEncryptionItem(Index: Integer; const Value: TclXmlEncryptionAlgorithm);
begin
  inherited SetItem(Index, Value);
end;

{ TclXmlEncryptedKeyInfo }

procedure TclXmlEncryptedKeyInfo.AssignCertificate(ACertificate: TclCertificate);
begin
  raise EclSoapMessageError.Create(EncryptKeyCertificateError, EncryptKeyCertificateErrorCode);
end;

function TclXmlEncryptedKeyInfo.Build(const AOwnerNode, ASecurity: IXMLDOMNode): IXMLDOMNode;
var
  tokenReference, keyRef: IXMLDOMNode;
  wsse11NameSpace: string;
begin
  Result := inherited Build(AOwnerNode, ASecurity);

  tokenReference := GetNodeByName(Result, 'SecurityTokenReference');

  wsse11NameSpace := Config.Namespaces.GetPrefix(wsse11NameSpaceName);

  AddNamespaceIfNeed(tokenReference, wsse11NameSpace, wsse11NameSpaceName);

  SetAttributeValue(tokenReference, GetSoapNodeName(wsse11NameSpace, 'TokenType'), EncryptedKeyIdentifier);

  keyRef := tokenReference.ownerDocument.createElement(GetSoapNodeName(Config.Namespaces.GetPrefix(wsseNameSpaceName), 'Reference'));
  tokenReference.appendChild(keyRef);

  SetAttributeValue(keyRef, 'URI', URI);
end;

function TclXmlEncryptedKeyInfo.DoParse(const AKeyInfo, ASecurity: IXMLDOMNode): Boolean;
var
  tokenReference, reference: IXMLDOMNode;
begin
  Result := inherited DoParse(AKeyInfo, ASecurity);
  if (not Result) then Exit;

  Result := False;

  tokenReference := GetNodeByName(AKeyInfo, 'SecurityTokenReference');
  if (tokenReference = nil) then Exit;

  if (GetAttributeValueByName(tokenReference, 'TokenType') <> EncryptedKeyIdentifier) then Exit;

  reference := GetNodeByName(tokenReference, 'Reference');
  if (reference = nil) then Exit;

  FURI := GetAttributeValue(reference, 'URI');

  Result := True;
end;

function TclXmlEncryptedKeyInfo.GetCertificate(AStore: TclCertificateStore): TclCertificate;
begin
  raise EclSoapMessageError.Create(EncryptKeyCertificateError, EncryptKeyCertificateErrorCode);
end;

initialization
  InitAccessor := TCriticalSection.Create();

finalization
  RegXmlKeyInfo.Free();
  RegXmlEncryptedData.Free();
  RegXmlEncryptedKeys.Free();
  RegXmlSignatures.Free();
  RegXmlTransforms.Free();
  InitAccessor.Free();

end.

