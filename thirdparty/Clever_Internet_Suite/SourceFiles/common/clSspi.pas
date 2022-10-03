{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSspi;

interface

{$I clVer.inc}
uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clCryptAPI, clSocket, clWUtils;
 
type
  EclSSPIError = class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean = False);
    property ErrorCode: Integer read FErrorCode;
  end;

type  
  TSecHandle = record
{$IFDEF DELPHIXE2}
    dwLower: size_t;
    dwUpper: size_t;
{$ELSE}
    dwLower: Cardinal;
    dwUpper: Cardinal;
{$ENDIF}
  end;
  PSecHandle = TSecHandle;

  TCredHandle = TSecHandle;
  PCredHandle = ^TSecHandle;
  TCtxtHandle = TSecHandle;
  PCtxtHandle = ^TSecHandle;

  PLUID = PLargeInteger;

  PCardinal = ^Cardinal;
  PTimeStamp = ^TTimeStamp;

  SECURITY_STATUS = HRESULT;

  PSecBuffer = ^TSecBuffer;
  TSecBuffer = record
    cbBuffer: Cardinal;             // Size of the buffer, in bytes
    BufferType: Cardinal;           // Type of the buffer (below)
    pvBuffer: Pointer;              // Pointer to the buffer
  end;

  PSecBufferDesc = ^TSecBufferDesc;
  TSecBufferDesc = record
    ulVersion: Cardinal;            // Version number
    cBuffers: Cardinal;             // Number of buffers
    pBuffers: PSecBuffer;           // Pointer to array of buffers
  end;

  PSecPkgInfo = ^TSecPkgInfo;
  TSecPkgInfo = record
    fCapabilities: Cardinal;        // capability of bit mask
    wVersion: Word;                 // version of driver
    wRPCID: Word;                   // identifier for RPC run time
    cbMaxToken: Cardinal;           // size of authentication token
    Name: PclChar;                    // text name
    Comment: PclChar;                 // comment
  end;
  PSecPkgInfoArray = ^TSecPkgInfoArray;
  TSecPkgInfoArray = array[0..0] of TSecPkgInfo;

  PSecPkgContext_Sizes = ^TSecPkgContext_Sizes;
  TSecPkgContext_Sizes = record
    cbMaxToken: Cardinal;
    cbMaxSignature: Cardinal;
    cbBlockSize: Cardinal;
    cbSecurityTrailer: Cardinal;
  end;

  PSecPkgContext_StreamSizes = ^TSecPkgContext_StreamSizes;
  TSecPkgContext_StreamSizes = record
    cbHeader: Cardinal;
    cbTrailer: Cardinal;
    cbMaximumMessage: Cardinal;
    cBuffers: Cardinal;
    cbBlockSize: Cardinal;
  end;

  PSecPkgCred_SupportedAlgs = ^TSecPkgCred_SupportedAlgs;
  TSecPkgCred_SupportedAlgs = record
    cSupportedAlgs: Cardinal;
    palgSupportedAlgs: Pointer;
  end;
  
  PSChannel_Cred = ^TSChannel_Cred;
  TSChannel_Cred = record
    dwVersion: Cardinal;
    cCreds: Cardinal;
    paCred: Pointer; //PCCERT_CONTEXT *
    hRootStore: Cardinal; //HCERTSTORE
    cMappers: Pointer;
    aphMappers: Pointer; // struct _HMAPPER **
    cSupportedAlgs: Cardinal;
    palgSupportedAlgs: Pointer; //
    grbitEnabledProtocols: Cardinal;
    dwMinimumCipherStrength: Cardinal;
    dwMaximumCipherStrength: Cardinal;
    dwSessionLifespan: Cardinal;
    dwFlags: Cardinal;
    reserved: Cardinal;
  end;

  PSecPkgContext_IssuerListInfoEx = ^TSecPkgContext_IssuerListInfoEx;
  TSecPkgContext_IssuerListInfoEx = record
    aIssuers: array[0..0] of CERT_NAME_BLOB;
    cIssuers: Cardinal;
  end;

  PEnumerateSecurityPackages = ^TEnumerateSecurityPackages;
  TEnumerateSecurityPackages = function(
    var pcPackages: Cardinal;       // receives the number of packages
    var ppPackageInfo: PSecPkgInfo  // receives array of information
  ): SECURITY_STATUS; stdcall;

  TQueryCredentialsAttributes = function(
    phCredential: PCredHandle;  // credential to query
    ulAttribute: Cardinal;      // attribute to query
    pBuffer: Pointer        // buffer that receives attributes
  ): SECURITY_STATUS; stdcall;

  TQuerySecurityPackageInfo = function(
    pszPackageName: PclChar;          // name of package
    var ppPackageInfo: PSecPkgInfo  // receives package information
  ): SECURITY_STATUS; stdcall;

  TFreeContextBuffer = function(
    pvContextBuffer: Pointer        // buffer to free
  ): SECURITY_STATUS; stdcall;

  TDeleteSecurityContext = function(
    phContext: PCtxtHandle         // handle of the context to delete
  ): SECURITY_STATUS; stdcall;

  TApplyControlToken = function(
    phContext: PCtxtHandle; // handle of the context to modify
    pInput: PSecBufferDesc  // input token to apply
  ): SECURITY_STATUS; stdcall;

  TQueryContextAttributes = function(
    phContext: PCtxtHandle;        // handle of the context to query
    ulAttribute: Cardinal;         // attribute to query
    pBuffer: Pointer              // buffer for attributes
  ): SECURITY_STATUS; stdcall;

  TImpersonateSecurityContext = function(
    phContext: PCtxtHandle // handle of the context to impersonate
  ): SECURITY_STATUS; stdcall;

  TRevertSecurityContext = function(
    phContext: PCtxtHandle // handle of the context being impersonated
  ): SECURITY_STATUS; stdcall;
  
  TFreeCredentialHandle = function(
    phContext: PCredHandle          // handle of the credential to delete
  ): SECURITY_STATUS; stdcall;

  TAcquireCredentialsHandle = function(
    pszPrincipal: PclChar;              // name of principal
    pszPackage: PclChar;                // name of package
    fCredentialUse: Cardinal;         // flags indicating use
    pvLogonID: PLUID;                 // pointer to logon identifier
    pAuthData: Pointer;               // package-specific data
    pGetKeyFn: Pointer;               // pointer to GetKey function
    pvGetKeyArgument: Pointer;        // value to pass to GetKey
    phCredential: PCredHandle;    // credential handle
    ptsExpiry: PTimeStamp         // lifetime of the returned credentials
  ): SECURITY_STATUS; stdcall;

  TInitializeSecurityContext = function(
    phCredential: PCredHandle;      // handle to the credentials
    phContext: PCtxtHandle;     // handle of partially formed context
    pszTargetName: PclChar;           // name of the target of the context
    fContextReq: Cardinal;          // required context attributes
    Reserved1: Cardinal;            // reserved; must be zero
    TargetDataRep: Cardinal;        // data representation on the target
    pInput: PSecBufferDesc;     // pointer to the input buffers
    Reserved2: Cardinal;            // reserved; must be zero
    phNewContext: PCtxtHandle;  // receives the new context handle
    pOutput: PSecBufferDesc;    // pointer to the output buffers
    pfContextAttr: PCardinal;    // receives the context attributes
    ptsExpiry: PTimeStamp       // receives the life span of the security context
  ): SECURITY_STATUS; stdcall;

  TAcceptSecurityContext = function(
    phCredential: PCredHandle;      // handle to the credentials
    phContext: PCtxtHandle;     // handle of partially formed context
    pInput: PSecBufferDesc;     // pointer to the input buffers
    fContextReq: Cardinal;          // required context attributes
    fTargetDataRep: Cardinal;
    phNewContext: PCtxtHandle;  // receives the new context handle
    pOutput: PSecBufferDesc;    // pointer to the output buffers
    pfContextAttr: PCardinal;    // receives the context attributes
    ptsExpiry: PTimeStamp       // receives the life span of the security context
  ): SECURITY_STATUS; stdcall;
  
  TCompleteAuthToken = function(
    phContext: PCtxtHandle;         // handle of the context to complete
    pToken: PSecBufferDesc          // token to complete
  ): SECURITY_STATUS; stdcall;

  TEncryptMessage = function(
    phContext: PCtxtHandle;    // context to use
    fQOP: PCardinal;           // quality of protection
    pMessage: PSecBufferDesc;  // buffer containing the message to encrypt
    MessageSeqNo: Cardinal    // expected sequence number
  ): SECURITY_STATUS; stdcall;

  TDecryptMessage = function(
    phContext: PCtxtHandle;    // context to use
    pMessage: PSecBufferDesc;  // buffer containing the message to decrypt
    MessageSeqNo: Cardinal;    // expected sequence number
    pfQOP: PCardinal           // quality of protection
  ): SECURITY_STATUS; stdcall;

  PSecurityFunctionTable = ^TSecurityFunctionTable;
  TSecurityFunctionTable = record
    dwVersion: Cardinal;
    EnumerateSecurityPackages: TEnumerateSecurityPackages;
    QueryCredentialsAttributes: TQueryCredentialsAttributes;
    AcquireCredentialsHandle: TAcquireCredentialsHandle;
    FreeCredentialHandle: TFreeCredentialHandle;
    SspiLogonUserA: Pointer;
    InitializeSecurityContext: TInitializeSecurityContext;
    AcceptSecurityContext: TAcceptSecurityContext;
    CompleteAuthToken: TCompleteAuthToken;
    DeleteSecurityContext: TDeleteSecurityContext;
    ApplyControlToken: TApplyControlToken;
    QueryContextAttributes: TQueryContextAttributes;
    ImpersonateSecurityContext: TImpersonateSecurityContext;
    RevertSecurityContext: TRevertSecurityContext;
    MakeSignature: Pointer;
    VerifySignature: Pointer;
    FreeContextBuffer: TFreeContextBuffer;
    QuerySecurityPackageInfo: TQuerySecurityPackageInfo;
    SealMessage: TEncryptMessage;
    UnSealMessage: TDecryptMessage;
    ExportSecurityContext: Pointer;
    ImportSecurityContextA: Pointer;
    Reserved7: Pointer;
    Reserved8: Pointer;
    QuerySecurityContextToken: Pointer;
    EncryptMessage: TEncryptMessage;  // alias of SealMessage
    DecryptMessage: TDecryptMessage;  // alias of UnSealMessage
  end;

  PInitSecurityInterface = ^TInitSecurityInterface;
  TInitSecurityInterface = function: PSecurityFunctionTable; stdcall;

type
  TclSspi = class
  private
    FDLLHandle: THandle;
    FFunctionTable: PSecurityFunctionTable;
    procedure InitFunctionTable;
    function GetFunctionTable: PSecurityFunctionTable;
  public
    constructor Create;
    destructor Destroy; override;
    property FunctionTable: PSecurityFunctionTable read GetFunctionTable;
  end;

const
  HEAP_NO_SERIALIZE        =       $00000001;
  {$EXTERNALSYM HEAP_NO_SERIALIZE}
  HEAP_GENERATE_EXCEPTIONS =       $00000004;
  {$EXTERNALSYM HEAP_GENERATE_EXCEPTIONS}

  SCHANNEL_SHUTDOWN           = 1;
  {$EXTERNALSYM SCHANNEL_SHUTDOWN}
  SCHANNEL_CRED_VERSION       = 4;
  {$EXTERNALSYM SCHANNEL_CRED_VERSION}

  // SChannel credentials

  SCH_CRED_NO_SYSTEM_MAPPER                    = $00000002;
  {$EXTERNALSYM SCH_CRED_NO_SYSTEM_MAPPER}
  SCH_CRED_NO_SERVERNAME_CHECK                 = $00000004;
  {$EXTERNALSYM SCH_CRED_NO_SERVERNAME_CHECK}
  SCH_CRED_MANUAL_CRED_VALIDATION              = $00000008;
  {$EXTERNALSYM SCH_CRED_MANUAL_CRED_VALIDATION}
  SCH_CRED_NO_DEFAULT_CREDS                    = $00000010;
  {$EXTERNALSYM SCH_CRED_NO_DEFAULT_CREDS}
  SCH_CRED_AUTO_CRED_VALIDATION                = $00000020;
  {$EXTERNALSYM SCH_CRED_AUTO_CRED_VALIDATION}
  SCH_CRED_USE_DEFAULT_CREDS                   = $00000040;
  {$EXTERNALSYM SCH_CRED_USE_DEFAULT_CREDS}

  SCH_CRED_REVOCATION_CHECK_END_CERT           = $00000100;
  {$EXTERNALSYM SCH_CRED_REVOCATION_CHECK_END_CERT}
  SCH_CRED_REVOCATION_CHECK_CHAIN              = $00000200;
  {$EXTERNALSYM SCH_CRED_REVOCATION_CHECK_CHAIN}
  SCH_CRED_REVOCATION_CHECK_CHAIN_EXCLUDE_ROOT = $00000400;
  {$EXTERNALSYM SCH_CRED_REVOCATION_CHECK_CHAIN_EXCLUDE_ROOT}
  SCH_CRED_IGNORE_NO_REVOCATION_CHECK          = $00000800;
  {$EXTERNALSYM SCH_CRED_IGNORE_NO_REVOCATION_CHECK}
  SCH_CRED_IGNORE_REVOCATION_OFFLINE           = $00001000;
  {$EXTERNALSYM SCH_CRED_IGNORE_REVOCATION_OFFLINE}

  // flag/identifiers for protocols
  SP_PROT_PCT1_SERVER             = $00000001;
  {$EXTERNALSYM SP_PROT_PCT1_SERVER}
  SP_PROT_PCT1_CLIENT             = $00000002;
  {$EXTERNALSYM SP_PROT_PCT1_CLIENT}
  SP_PROT_PCT1                    = SP_PROT_PCT1_SERVER + SP_PROT_PCT1_CLIENT;
  {$EXTERNALSYM SP_PROT_PCT1}

  SP_PROT_SSL2_SERVER             = $00000004;
  {$EXTERNALSYM SP_PROT_SSL2_SERVER}
  SP_PROT_SSL2_CLIENT             = $00000008;
  {$EXTERNALSYM SP_PROT_SSL2_CLIENT}
  SP_PROT_SSL2                    = SP_PROT_SSL2_SERVER + SP_PROT_SSL2_CLIENT;
  {$EXTERNALSYM SP_PROT_SSL2}

  SP_PROT_SSL3_SERVER             = $00000010;
  {$EXTERNALSYM SP_PROT_SSL3_SERVER}
  SP_PROT_SSL3_CLIENT             = $00000020;
  {$EXTERNALSYM SP_PROT_SSL3_CLIENT}
  SP_PROT_SSL3                    = SP_PROT_SSL3_SERVER + SP_PROT_SSL3_CLIENT;
  {$EXTERNALSYM SP_PROT_SSL3}

  SP_PROT_TLS1_SERVER             = $00000040;
  {$EXTERNALSYM SP_PROT_TLS1_SERVER}
  SP_PROT_TLS1_CLIENT             = $00000080;
  {$EXTERNALSYM SP_PROT_TLS1_CLIENT}
  SP_PROT_TLS1                    = SP_PROT_TLS1_SERVER + SP_PROT_TLS1_CLIENT;
  {$EXTERNALSYM SP_PROT_TLS1}

  SP_PROT_TLS1_1_SERVER             = $00000100;
  {$EXTERNALSYM SP_PROT_TLS1_1_SERVER}
  SP_PROT_TLS1_1_CLIENT             = $00000200;
  {$EXTERNALSYM SP_PROT_TLS1_1_CLIENT}
  SP_PROT_TLS1_2_SERVER             = $00000400;
  {$EXTERNALSYM SP_PROT_TLS1_2_SERVER}
  SP_PROT_TLS1_2_CLIENT             = $00000800;
  {$EXTERNALSYM SP_PROT_TLS1_2_CLIENT}

  SP_PROT_SSL3TLS1_CLIENTS        = SP_PROT_TLS1_CLIENT + SP_PROT_SSL3_CLIENT;
  {$EXTERNALSYM SP_PROT_SSL3TLS1_CLIENTS}
  SP_PROT_SSL3TLS1_SERVERS        = SP_PROT_TLS1_SERVER + SP_PROT_SSL3_SERVER;
  {$EXTERNALSYM SP_PROT_SSL3TLS1_SERVERS}
  SP_PROT_SSL3TLS1                = SP_PROT_SSL3 + SP_PROT_TLS1;
  {$EXTERNALSYM SP_PROT_SSL3TLS1}

  SP_PROT_UNI_SERVER              = $40000000;
  {$EXTERNALSYM SP_PROT_UNI_SERVER}
  SP_PROT_UNI_CLIENT              = $80000000;
  {$EXTERNALSYM SP_PROT_UNI_CLIENT}
  SP_PROT_UNI                     = SP_PROT_UNI_SERVER + SP_PROT_UNI_CLIENT;
  {$EXTERNALSYM SP_PROT_UNI}

  SP_PROT_ALL                     = $ffffffff;
  {$EXTERNALSYM SP_PROT_ALL}
  SP_PROT_NONE                    = $0;
  {$EXTERNALSYM SP_PROT_NONE}
  SP_PROT_CLIENTS                 = SP_PROT_PCT1_CLIENT + SP_PROT_SSL2_CLIENT + SP_PROT_SSL3_CLIENT + SP_PROT_UNI_CLIENT + SP_PROT_TLS1_CLIENT;
  {$EXTERNALSYM SP_PROT_CLIENTS}
  SP_PROT_SERVERS                 = SP_PROT_PCT1_SERVER + SP_PROT_SSL2_SERVER + SP_PROT_SSL3_SERVER + SP_PROT_UNI_SERVER + SP_PROT_TLS1_SERVER;
  {$EXTERNALSYM SP_PROT_SERVERS}

  // internal errors
  SSPI_E_LoadLibrary                = -1;
  SSPI_E_FuncTableInit              = -2;
  SSPI_E_SecPackage                 = -3;
  SSPI_E_AcquireFailed              = -4;
  SSPI_E_PackageNotFound            = -5;
  SSPI_E_QueryPackageInfoFailed     = -6;
  SSPI_E_QueryLocalCertificate      = -9;
  SSPI_E_WhileVerify                 = -11;
  SSPI_E_NOT_SUPPORTED               = -12;
  // errors and warnings codes

  SEC_E_DECRYPT_FAILURE    = SECURITY_STATUS($80090330);
  {$EXTERNALSYM SEC_E_DECRYPT_FAILURE}
  SEC_E_ALGORITHM_MISMATCH    = SECURITY_STATUS($80090331);
  {$EXTERNALSYM SEC_E_ALGORITHM_MISMATCH}

  SEC_E_OK                    = SECURITY_STATUS($00000000);
  {$EXTERNALSYM SEC_E_OK}
  SEC_E_OUTOFMEMORY           = SECURITY_STATUS($00000014);
  {$EXTERNALSYM SEC_E_OUTOFMEMORY}
  SEC_I_RENEGOTIATE           = SECURITY_STATUS($00090321);
  {$EXTERNALSYM SEC_I_RENEGOTIATE}
  SEC_E_INVALID_HANDLE        = SECURITY_STATUS($80090301);
  {$EXTERNALSYM SEC_E_INVALID_HANDLE}
  SEC_E_UNSUPPORTED_FUNCTION  = SECURITY_STATUS($80090302);
  {$EXTERNALSYM SEC_E_UNSUPPORTED_FUNCTION}
  SEC_E_TARGET_UNKNOWN        = SECURITY_STATUS($80090303);
  {$EXTERNALSYM SEC_E_TARGET_UNKNOWN}
  SEC_E_INTERNAL_ERROR        = SECURITY_STATUS($80090304);
  {$EXTERNALSYM SEC_E_INTERNAL_ERROR}
  SEC_E_SECPKG_NOT_FOUND      = SECURITY_STATUS($80090305);
  {$EXTERNALSYM SEC_E_SECPKG_NOT_FOUND}
  SEC_E_NOT_OWNER             = SECURITY_STATUS($80090306);
  {$EXTERNALSYM SEC_E_NOT_OWNER}
  SEC_E_CANNOT_INSTALL        = SECURITY_STATUS($80090307);
  {$EXTERNALSYM SEC_E_CANNOT_INSTALL}
  SEC_E_INVALID_TOKEN         = SECURITY_STATUS($80090308);
  {$EXTERNALSYM SEC_E_INVALID_TOKEN}
  SEC_E_CANNOT_PACK           = SECURITY_STATUS($80090309);
  {$EXTERNALSYM SEC_E_CANNOT_PACK}
  SEC_E_QOP_NOT_SUPPORTED     = SECURITY_STATUS($8009030A);
  {$EXTERNALSYM SEC_E_QOP_NOT_SUPPORTED}
  SEC_E_NO_IMPERSONATION      = SECURITY_STATUS($8009030B);
  {$EXTERNALSYM SEC_E_NO_IMPERSONATION}
  SEC_E_LOGON_DENIED          = SECURITY_STATUS($8009030C);
  {$EXTERNALSYM SEC_E_LOGON_DENIED}
  SEC_E_UNKNOWN_CREDENTIALS   = SECURITY_STATUS($8009030D);
  {$EXTERNALSYM SEC_E_UNKNOWN_CREDENTIALS}
  SEC_E_NO_CREDENTIALS        = SECURITY_STATUS($8009030E);
  {$EXTERNALSYM SEC_E_NO_CREDENTIALS}
  SEC_E_MESSAGE_ALTERED       = SECURITY_STATUS($8009030F);
  {$EXTERNALSYM SEC_E_MESSAGE_ALTERED}
  SEC_E_OUT_OF_SEQUENCE       = SECURITY_STATUS($80090310);
  {$EXTERNALSYM SEC_E_OUT_OF_SEQUENCE}
  SEC_E_NO_AUTHENTICATING_AUTHORITY = SECURITY_STATUS($80090311);
  {$EXTERNALSYM SEC_E_NO_AUTHENTICATING_AUTHORITY}

  SEC_I_CONTINUE_NEEDED       = SECURITY_STATUS($00090312);
  {$EXTERNALSYM SEC_I_CONTINUE_NEEDED}
  SEC_I_COMPLETE_NEEDED       = SECURITY_STATUS($00090313);
  {$EXTERNALSYM SEC_I_COMPLETE_NEEDED}
  SEC_I_COMPLETE_AND_CONTINUE = SECURITY_STATUS($00090314);
  {$EXTERNALSYM SEC_I_COMPLETE_AND_CONTINUE}
  SEC_I_LOCAL_LOGON           = SECURITY_STATUS($00090315);
  {$EXTERNALSYM SEC_I_LOCAL_LOGON}
  SEC_E_BAD_PKGID             = SECURITY_STATUS($80090316);
  {$EXTERNALSYM SEC_E_BAD_PKGID}

  SEC_I_END_SESSION           = SECURITY_STATUS($00090317);
  {$EXTERNALSYM SEC_I_END_SESSION}

  SEC_E_INCOMPLETE_MESSAGE    = SECURITY_STATUS($80090318);
  {$EXTERNALSYM SEC_E_INCOMPLETE_MESSAGE}
  SEC_I_INCOMPLETE_CREDENTIALS = SECURITY_STATUS($00090320);
  {$EXTERNALSYM SEC_I_INCOMPLETE_CREDENTIALS}

  TRUST_E_CERT_SIGNATURE       = SECURITY_STATUS($80096004);
  {$EXTERNALSYM TRUST_E_CERT_SIGNATURE}
  CERT_E_EXPIRED               = SECURITY_STATUS($800B0101);
  {$EXTERNALSYM CERT_E_EXPIRED}
  CERT_E_VALIDITYPERIODNESTING = SECURITY_STATUS($800B0102);
  {$EXTERNALSYM CERT_E_VALIDITYPERIODNESTING}
  CERT_E_ROLE                  = SECURITY_STATUS($800B0103);
  {$EXTERNALSYM CERT_E_ROLE}
  CERT_E_PATHLENCONST          = SECURITY_STATUS($800B0104);
  {$EXTERNALSYM CERT_E_PATHLENCONST}
  CERT_E_CRITICAL              = SECURITY_STATUS($800B0105);
  {$EXTERNALSYM CERT_E_CRITICAL}
  CERT_E_PURPOSE               = SECURITY_STATUS($800B0106);
  {$EXTERNALSYM CERT_E_PURPOSE}
  CERT_E_ISSUERCHAINING        = SECURITY_STATUS($800B0107);
  {$EXTERNALSYM CERT_E_ISSUERCHAINING}
  CERT_E_MALFORMED             = SECURITY_STATUS($800B0108);
  {$EXTERNALSYM CERT_E_MALFORMED}
  CERT_E_UNTRUSTEDROOT         = SECURITY_STATUS($800B0109);
  {$EXTERNALSYM CERT_E_UNTRUSTEDROOT}
  CERT_E_CHAINING              = SECURITY_STATUS($800B010A);
  {$EXTERNALSYM CERT_E_CHAINING}
  TRUST_E_FAIL                 = SECURITY_STATUS($800B010B);
  {$EXTERNALSYM TRUST_E_FAIL}
  CERT_E_REVOKED               = SECURITY_STATUS($800B010C);
  {$EXTERNALSYM CERT_E_REVOKED}
  CERT_E_UNTRUSTEDTESTROOT     = SECURITY_STATUS($800B010D);
  {$EXTERNALSYM CERT_E_UNTRUSTEDTESTROOT}
  CERT_E_REVOCATION_FAILURE    = SECURITY_STATUS($800B010E);
  {$EXTERNALSYM CERT_E_REVOCATION_FAILURE}
  CERT_E_CN_NO_MATCH           = SECURITY_STATUS($800B010F);
  {$EXTERNALSYM CERT_E_CN_NO_MATCH}
  CERT_E_WRONG_USAGE           = SECURITY_STATUS($800B0110);
  {$EXTERNALSYM CERT_E_WRONG_USAGE}

  SECBUFFER_VERSION           = 0;
  {$EXTERNALSYM SECBUFFER_VERSION}

  SECBUFFER_EMPTY             = 0;   // Undefined, replaced by provider
  {$EXTERNALSYM SECBUFFER_EMPTY}
  SECBUFFER_DATA              = 1;   // Packet data
  {$EXTERNALSYM SECBUFFER_DATA}
  SECBUFFER_TOKEN             = 2;   // Security token
  {$EXTERNALSYM SECBUFFER_TOKEN}
  SECBUFFER_PKG_PARAMS        = 3;   // Package specific parameters
  {$EXTERNALSYM SECBUFFER_PKG_PARAMS}
  SECBUFFER_MISSING           = 4;   // Missing Data indicator
  {$EXTERNALSYM SECBUFFER_MISSING}
  SECBUFFER_EXTRA             = 5;   // Extra data
  {$EXTERNALSYM SECBUFFER_EXTRA}
  SECBUFFER_STREAM_TRAILER    = 6;   // Security Trailer
  {$EXTERNALSYM SECBUFFER_STREAM_TRAILER}
  SECBUFFER_STREAM_HEADER     = 7;   // Security Header
  {$EXTERNALSYM SECBUFFER_STREAM_HEADER}
  SECBUFFER_NEGOTIATION_INFO  = 8;   // Hints from the negotiation pkg
  {$EXTERNALSYM SECBUFFER_NEGOTIATION_INFO}

  ISC_REQ_DELEGATE                = $00000001;
  {$EXTERNALSYM ISC_REQ_DELEGATE}
  ISC_REQ_MUTUAL_AUTH             = $00000002;
  {$EXTERNALSYM ISC_REQ_MUTUAL_AUTH}
  ISC_REQ_REPLAY_DETECT           = $00000004;
  {$EXTERNALSYM ISC_REQ_REPLAY_DETECT}
  ISC_REQ_SEQUENCE_DETECT         = $00000008;
  {$EXTERNALSYM ISC_REQ_SEQUENCE_DETECT}
  ISC_REQ_CONFIDENTIALITY         = $00000010;
  {$EXTERNALSYM ISC_REQ_CONFIDENTIALITY}
  ISC_REQ_USE_SESSION_KEY         = $00000020;
  {$EXTERNALSYM ISC_REQ_USE_SESSION_KEY}
  ISC_REQ_PROMPT_FOR_CREDS        = $00000040;
  {$EXTERNALSYM ISC_REQ_PROMPT_FOR_CREDS}
  ISC_REQ_USE_SUPPLIED_CREDS      = $00000080;
  {$EXTERNALSYM ISC_REQ_USE_SUPPLIED_CREDS}
  ISC_REQ_ALLOCATE_MEMORY         = $00000100;
  {$EXTERNALSYM ISC_REQ_ALLOCATE_MEMORY}
  ISC_REQ_USE_DCE_STYLE           = $00000200;
  {$EXTERNALSYM ISC_REQ_USE_DCE_STYLE}
  ISC_REQ_DATAGRAM                = $00000400;
  {$EXTERNALSYM ISC_REQ_DATAGRAM}
  ISC_REQ_CONNECTION              = $00000800;
  {$EXTERNALSYM ISC_REQ_CONNECTION}
  ISC_REQ_CALL_LEVEL              = $00001000;
  {$EXTERNALSYM ISC_REQ_CALL_LEVEL}
  ISC_REQ_EXTENDED_ERROR          = $00004000;
  {$EXTERNALSYM ISC_REQ_EXTENDED_ERROR}
  ISC_REQ_STREAM                  = $00008000;
  {$EXTERNALSYM ISC_REQ_STREAM}
  ISC_REQ_INTEGRITY               = $00010000;
  {$EXTERNALSYM ISC_REQ_INTEGRITY}
  ISC_REQ_IDENTIFY                = $00020000;
  {$EXTERNALSYM ISC_REQ_IDENTIFY}
  ISC_REQ_NULL_SESSION            = $00040000;
  {$EXTERNALSYM ISC_REQ_NULL_SESSION}

  ISC_RET_DELEGATE                = $00000001;
  {$EXTERNALSYM ISC_RET_DELEGATE}
  ISC_RET_MUTUAL_AUTH             = $00000002;
  {$EXTERNALSYM ISC_RET_MUTUAL_AUTH}
  ISC_RET_REPLAY_DETECT           = $00000004;
  {$EXTERNALSYM ISC_RET_REPLAY_DETECT}
  ISC_RET_SEQUENCE_DETECT         = $00000008;
  {$EXTERNALSYM ISC_RET_SEQUENCE_DETECT}
  ISC_RET_CONFIDENTIALITY         = $00000010;
  {$EXTERNALSYM ISC_RET_CONFIDENTIALITY}
  ISC_RET_USE_SESSION_KEY         = $00000020;
  {$EXTERNALSYM ISC_RET_USE_SESSION_KEY}
  ISC_RET_USED_COLLECTED_CREDS    = $00000040;
  {$EXTERNALSYM ISC_RET_USED_COLLECTED_CREDS}
  ISC_RET_USED_SUPPLIED_CREDS     = $00000080;
  {$EXTERNALSYM ISC_RET_USED_SUPPLIED_CREDS}
  ISC_RET_ALLOCATED_MEMORY        = $00000100;
  {$EXTERNALSYM ISC_RET_ALLOCATED_MEMORY}
  ISC_RET_USED_DCE_STYLE          = $00000200;
  {$EXTERNALSYM ISC_RET_USED_DCE_STYLE}
  ISC_RET_DATAGRAM                = $00000400;
  {$EXTERNALSYM ISC_RET_DATAGRAM}
  ISC_RET_CONNECTION              = $00000800;
  {$EXTERNALSYM ISC_RET_CONNECTION}
  ISC_RET_INTERMEDIATE_RETURN     = $00001000;
  {$EXTERNALSYM ISC_RET_INTERMEDIATE_RETURN}
  ISC_RET_CALL_LEVEL              = $00002000;
  {$EXTERNALSYM ISC_RET_CALL_LEVEL}
  ISC_RET_EXTENDED_ERROR          = $00004000;
  {$EXTERNALSYM ISC_RET_EXTENDED_ERROR}
  ISC_RET_STREAM                  = $00008000;
  {$EXTERNALSYM ISC_RET_STREAM}
  ISC_RET_INTEGRITY               = $00010000;
  {$EXTERNALSYM ISC_RET_INTEGRITY}
  ISC_RET_IDENTIFY                = $00020000;
  {$EXTERNALSYM ISC_RET_IDENTIFY}
  ISC_RET_NULL_SESSION            = $00040000;
  {$EXTERNALSYM ISC_RET_NULL_SESSION}
  ISC_RET_MANUAL_CRED_VALIDATION  = $00080000;
  {$EXTERNALSYM ISC_RET_MANUAL_CRED_VALIDATION}
  ISC_RET_RESERVED1               = $00100000;
  {$EXTERNALSYM ISC_RET_RESERVED1}
  ISC_RET_FRAGMENT_ONLY           = $00200000;
  {$EXTERNALSYM ISC_RET_FRAGMENT_ONLY}

  ASC_REQ_DELEGATE                = $00000001;
  {$EXTERNALSYM ASC_REQ_DELEGATE}
  ASC_REQ_MUTUAL_AUTH             = $00000002;
  {$EXTERNALSYM ASC_REQ_MUTUAL_AUTH}
  ASC_REQ_REPLAY_DETECT           = $00000004;
  {$EXTERNALSYM ASC_REQ_REPLAY_DETECT}
  ASC_REQ_SEQUENCE_DETECT         = $00000008;
  {$EXTERNALSYM ASC_REQ_SEQUENCE_DETECT}
  ASC_REQ_CONFIDENTIALITY         = $00000010;
  {$EXTERNALSYM ASC_REQ_CONFIDENTIALITY}
  ASC_REQ_USE_SESSION_KEY         = $00000020;
  {$EXTERNALSYM ASC_REQ_USE_SESSION_KEY}
  ASC_REQ_ALLOCATE_MEMORY         = $00000100;
  {$EXTERNALSYM ASC_REQ_ALLOCATE_MEMORY}
  ASC_REQ_USE_DCE_STYLE           = $00000200;
  {$EXTERNALSYM ASC_REQ_USE_DCE_STYLE}
  ASC_REQ_DATAGRAM                = $00000400;
  {$EXTERNALSYM ASC_REQ_DATAGRAM}
  ASC_REQ_CONNECTION              = $00000800;
  {$EXTERNALSYM ASC_REQ_CONNECTION}
  ASC_REQ_CALL_LEVEL              = $00001000;
  {$EXTERNALSYM ASC_REQ_CALL_LEVEL}
  ASC_REQ_EXTENDED_ERROR          = $00008000;
  {$EXTERNALSYM ASC_REQ_EXTENDED_ERROR}
  ASC_REQ_STREAM                  = $00010000;
  {$EXTERNALSYM ASC_REQ_STREAM}
  ASC_REQ_INTEGRITY               = $00020000;
  {$EXTERNALSYM ASC_REQ_INTEGRITY}
  ASC_REQ_LICENSING               = $00040000;
  {$EXTERNALSYM ASC_REQ_LICENSING}
  ASC_REQ_IDENTIFY                = $00080000;
  {$EXTERNALSYM ASC_REQ_IDENTIFY}
  ASC_REQ_ALLOW_NULL_SESSION      = $00100000;
  {$EXTERNALSYM ASC_REQ_ALLOW_NULL_SESSION}
  ASC_REQ_ALLOW_NON_USER_LOGONS   = $00200000;
  {$EXTERNALSYM ASC_REQ_ALLOW_NON_USER_LOGONS}
  ASC_REQ_ALLOW_CONTEXT_REPLAY    = $00400000;
  {$EXTERNALSYM ASC_REQ_ALLOW_CONTEXT_REPLAY}
  ASC_REQ_FRAGMENT_TO_FIT         = $00800000;
  {$EXTERNALSYM ASC_REQ_FRAGMENT_TO_FIT}
  ASC_REQ_FRAGMENT_SUPPLIED       = $00002000;
  {$EXTERNALSYM ASC_REQ_FRAGMENT_SUPPLIED}
  ASC_REQ_NO_TOKEN                = $01000000;
  {$EXTERNALSYM ASC_REQ_NO_TOKEN}

  ASC_RET_DELEGATE                = $00000001;
  {$EXTERNALSYM ASC_RET_DELEGATE}
  ASC_RET_MUTUAL_AUTH             = $00000002;
  {$EXTERNALSYM ASC_RET_MUTUAL_AUTH}
  ASC_RET_REPLAY_DETECT           = $00000004;
  {$EXTERNALSYM ASC_RET_REPLAY_DETECT}
  ASC_RET_SEQUENCE_DETECT         = $00000008;
  {$EXTERNALSYM ASC_RET_SEQUENCE_DETECT}
  ASC_RET_CONFIDENTIALITY         = $00000010;
  {$EXTERNALSYM ASC_RET_CONFIDENTIALITY}
  ASC_RET_USE_SESSION_KEY         = $00000020;
  {$EXTERNALSYM ASC_RET_USE_SESSION_KEY}
  ASC_RET_ALLOCATED_MEMORY        = $00000100;
  {$EXTERNALSYM ASC_RET_ALLOCATED_MEMORY}
  ASC_RET_USED_DCE_STYLE          = $00000200;
  {$EXTERNALSYM ASC_RET_USED_DCE_STYLE}
  ASC_RET_DATAGRAM                = $00000400;
  {$EXTERNALSYM ASC_RET_DATAGRAM}
  ASC_RET_CONNECTION              = $00000800;
  {$EXTERNALSYM ASC_RET_CONNECTION}
  ASC_RET_CALL_LEVEL              = $00002000; // skipped 1000 to be like ISC_
  {$EXTERNALSYM ASC_RET_CALL_LEVEL}
  ASC_RET_THIRD_LEG_FAILED        = $00004000;
  {$EXTERNALSYM ASC_RET_THIRD_LEG_FAILED}
  ASC_RET_EXTENDED_ERROR          = $00008000;
  {$EXTERNALSYM ASC_RET_EXTENDED_ERROR}
  ASC_RET_STREAM                  = $00010000;
  {$EXTERNALSYM ASC_RET_STREAM}
  ASC_RET_INTEGRITY               = $00020000;
  {$EXTERNALSYM ASC_RET_INTEGRITY}
  ASC_RET_LICENSING               = $00040000;
  {$EXTERNALSYM ASC_RET_LICENSING}
  ASC_RET_IDENTIFY                = $00080000;
  {$EXTERNALSYM ASC_RET_IDENTIFY}
  ASC_RET_NULL_SESSION            = $00100000;
  {$EXTERNALSYM ASC_RET_NULL_SESSION}
  ASC_RET_ALLOW_NON_USER_LOGONS   = $00200000;
  {$EXTERNALSYM ASC_RET_ALLOW_NON_USER_LOGONS}
  ASC_RET_ALLOW_CONTEXT_REPLAY    = $00400000;
  {$EXTERNALSYM ASC_RET_ALLOW_CONTEXT_REPLAY}
  ASC_RET_FRAGMENT_ONLY           = $00800000;
  {$EXTERNALSYM ASC_RET_FRAGMENT_ONLY}
  ASC_RET_NO_TOKEN                = $01000000;
  {$EXTERNALSYM ASC_RET_NO_TOKEN}

  // Data Representation Constant:
  SECURITY_NATIVE_DREP        = $00000010;
  {$EXTERNALSYM SECURITY_NATIVE_DREP}
  SECURITY_NETWORK_DREP       = $00000000;
  {$EXTERNALSYM SECURITY_NETWORK_DREP}

  // Credential Use Flags
  SECPKG_CRED_INBOUND         = $00000001;
  {$EXTERNALSYM SECPKG_CRED_INBOUND}
  SECPKG_CRED_OUTBOUND        = $00000002;
  {$EXTERNALSYM SECPKG_CRED_OUTBOUND}
  SECPKG_CRED_BOTH            = $00000003;
  {$EXTERNALSYM SECPKG_CRED_BOTH}

 //  Security Context Attributes:

  SECPKG_ATTR_SIZES           = $00000000;
  {$EXTERNALSYM SECPKG_ATTR_SIZES}
  SECPKG_ATTR_NAMES           = $00000001;
  {$EXTERNALSYM SECPKG_ATTR_NAMES}
  SECPKG_ATTR_LIFESPAN        = $00000002;
  {$EXTERNALSYM SECPKG_ATTR_LIFESPAN}
  SECPKG_ATTR_DCE_INFO        = $00000003;
  {$EXTERNALSYM SECPKG_ATTR_DCE_INFO}
  SECPKG_ATTR_STREAM_SIZES    = $00000004;
  {$EXTERNALSYM SECPKG_ATTR_STREAM_SIZES}
  SECPKG_ATTR_KEY_INFO        = $00000005;
  {$EXTERNALSYM SECPKG_ATTR_KEY_INFO}
  SECPKG_ATTR_AUTHORITY       = $00000006;
  {$EXTERNALSYM SECPKG_ATTR_AUTHORITY}
  SECPKG_ATTR_PROTO_INFO      = $00000007;
  {$EXTERNALSYM SECPKG_ATTR_PROTO_INFO}
  SECPKG_ATTR_PASSWORD_EXPIRY = $00000008;
  {$EXTERNALSYM SECPKG_ATTR_PASSWORD_EXPIRY}
  SECPKG_ATTR_SESSION_KEY     = $00000009;
  {$EXTERNALSYM SECPKG_ATTR_SESSION_KEY}
  SECPKG_ATTR_PACKAGE_INFO    = $00000010;
  {$EXTERNALSYM SECPKG_ATTR_PACKAGE_INFO}

// QueryContextAttributes/QueryCredentialsAttribute extensions

  SECPKG_ATTR_REMOTE_CERT_CONTEXT  = $53;  // returns PCCERT_CONTEXT
  {$EXTERNALSYM SECPKG_ATTR_REMOTE_CERT_CONTEXT}
  SECPKG_ATTR_LOCAL_CERT_CONTEXT   = $54;  // returns PCCERT_CONTEXT
  {$EXTERNALSYM SECPKG_ATTR_LOCAL_CERT_CONTEXT}
  SECPKG_ATTR_ROOT_STORE           = $55;  // returns HCERTCONTEXT to the root store
  {$EXTERNALSYM SECPKG_ATTR_ROOT_STORE}
  SECPKG_ATTR_SUPPORTED_ALGS       = $56;  // returns SecPkgCred_SupportedAlgs
  {$EXTERNALSYM SECPKG_ATTR_SUPPORTED_ALGS}
  SECPKG_ATTR_CIPHER_STRENGTHS     = $57;  // returns SecPkgCred_CipherStrengths
  {$EXTERNALSYM SECPKG_ATTR_CIPHER_STRENGTHS}
  SECPKG_ATTR_SUPPORTED_PROTOCOLS  = $58;  // returns SecPkgCred_SupportedProtocols
  {$EXTERNALSYM SECPKG_ATTR_SUPPORTED_PROTOCOLS}
  SECPKG_ATTR_ISSUER_LIST_EX       = $59;  // returns SecPkgContext_IssuerListInfoEx
  {$EXTERNALSYM SECPKG_ATTR_ISSUER_LIST_EX}
  SECPKG_ATTR_CONNECTION_INFO      = $5a;  // returns SecPkgContext_ConnectionInfo
  {$EXTERNALSYM SECPKG_ATTR_CONNECTION_INFO}

  CERT_CHAIN_FIND_BY_ISSUER       = 1;
  {$EXTERNALSYM CERT_CHAIN_FIND_BY_ISSUER}

  DLL_NAMES: array[0..2] of PChar = ('security.dll', 'schannel.dll', 'secur32.dll');

  SECURITY_ENTRYPOINTA = 'InitSecurityInterfaceA';
  {$EXTERNALSYM SECURITY_ENTRYPOINTA}
  SECURITY_ENTRYPOINTW = 'InitSecurityInterfaceW';
  {$EXTERNALSYM SECURITY_ENTRYPOINTW}
  SECURITY_ENTRYPOINT  = SECURITY_ENTRYPOINTA;
  {$EXTERNALSYM SECURITY_ENTRYPOINT}

resourcestring
  SSPIErrorDECRYPT_FAILURE = 'The specified data could not be decrypted';
  SSPIErrorALGORITHM_MISMATCH = 'The client and server cannot communicate because they do not possess a common algorithm';
  SclSimpleNotSupported = 'Not supported';
  SSPIErrorLoadLibrary = 'Could not load the dll (schannel.dll, security.dll or secur32.dll)';
  SSPIErrorFuncTableInit = 'Could not get security initialization routine';
  SSPIErrorSecPackage = 'Could not initialize the security package';
  SSPIErrorAcquireFailed = 'AcquireCredentials failed';
  SSPIErrorPackageNotFound = 'None of needed security package was found';
  SSPIErrorQueryPackageInfoFailed = 'Could not query package information';
  SSPIErrorQueryLocalCertificate = 'Error querying local certificate';
  SSPIErrorWhileTrustPerforming = 'Error occured when authenticating server credentials';
  SSPIErrorINVALIDHANDLE         = 'The handle specified is invalid';
  SSPIErrorUNSUPPORTED_FUNCTION  = 'The function requested is not supported';
  SSPIErrorTARGET_UNKNOWN        = 'The specified target is unknown or unreachable';
  SSPIErrorINTERNAL_ERROR        = 'The Local Security Authority cannot be contacted';
  SSPIErrorSECPKG_NOT_FOUND      = 'The requested security package does not exist';
  SSPIErrorNOT_OWNER             = 'The caller is not the owner of the desired credentials';
  SSPIErrorCANNOT_INSTALL        = 'The security package failed to initialize, and cannot be installed';
  SSPIErrorINVALID_TOKEN         = 'The token supplied to the function is invalid';
  SSPIErrorCANNOT_PACK           = 'The security package is not able to marshall the logon buffer, so the logon attempt has failed';
  SSPIErrorQOP_NOT_SUPPORTED     = 'The per-message Quality of Protection is not supported by the security package';
  SSPIErrorNO_IMPERSONATION      = 'The security context does not allow impersonation of the client';
  SSPIErrorLOGON_DENIED          = 'The logon attempt failed';
  SSPIErrorUNKNOWN_CREDENTIALS   = 'The credentials supplied to the package were not recognized';
  SSPIErrorNO_CREDENTIALS        = 'No credentials are available in the security package';
  SSPIErrorMESSAGE_ALTERED       = 'The message supplied for verification has been altered';
  SSPIErrorOUT_OF_SEQUENCE       = 'The message supplied for verification is out of sequence';
  SSPIErrorNO_AUTHENTICATING_AUTHORITY
                                 = 'No authority could be contacted for authentication';
  SSPIErrorBAD_PKGID             = 'The requested security package does not exist';
  SSPIErrorOUTOFMEMORY           = 'Out of memory';
  SSPIErrorUnknownError          = 'The unknown error was occured: %x';
  SSPIErrorCERTSIGNATURE         = 'The signature of the certificate cannot be verified';
  SSPIErrorCERTEXPIRED           = 'A required certificate is not within its validity ' +
    'period when verifying against the current system clock or the timestamp in the signed file';
  SSPIErrorCERTVALIDITYPERIODNESTING ='The validity periods of the certification chain do not ' +
    'nest correctly';
  SSPIErrorCERTROLE              = 'A certificate that can only be used as an end-entity '+
    'is being used as a CA or visa versa';
  SSPIErrorCERTPATHLENCONST      = 'A path length constraint in the certification chain has been violated';
  SSPIErrorCERTCRITICAL          = 'A certificate contains an unknown extension that is marked ''critical''';
  SSPIErrorCERTPURPOSE           = 'A certificate being used for a purpose other than the ones specified by its CA';
  SSPIErrorCERTISSUERCHAINING    = 'A parent of a given certificate in fact did not issue that child certificate';
  SSPIErrorCERTMALFORMED         = 'A certificate is missing or has an empty value for an important field, such as a subject or issuer name';
  SSPIErrorCERTUNTRUSTEDROOT     = 'A certificate chain processed correctly, but terminated in a root certificate which is not trusted by the trust provider';
  SSPIErrorCERTCHAINING          = 'An internal certificate chaining error has occurred';
  SSPIErrorCERTFAIL              = 'Generic trust failure';
  SSPIErrorCERTREVOKED           = 'A certificate was explicitly revoked by its issuer';
  SSPIErrorCERTUNTRUSTEDTESTROOT = 'The certification path terminates with the test root which is not trusted with the current policy settings';
  SSPIErrorCERTREVOCATION_FAILURE= 'The revocation process could not continue - the certificate(s) could not be checked';
  SSPIErrorCERTCN_NO_MATCH       = 'The certificate''s CN name does not match the passed value';
  SSPIErrorCERTWRONG_USAGE       = 'The certificate is not valid for the requested usage';

function GetSspiErrorMessage(AErrorCode: SECURITY_STATUS): string; overload;
procedure GetSspiErrorMessage(AErrorCode: SECURITY_STATUS; var AMessage: string; var AFound: Boolean); overload;
procedure RaiseSspiError(AErrorCode: SECURITY_STATUS); overload;
procedure RaiseSspiError(AErrorCode, ADefaultError: SECURITY_STATUS); overload;

implementation

function GetSspiErrorMessage(AErrorCode: SECURITY_STATUS): string;
var
  found: Boolean;
begin
  GetSspiErrorMessage(AErrorCode, Result, found);
end;

procedure GetSspiErrorMessage(AErrorCode: SECURITY_STATUS; var AMessage: string; var AFound: Boolean);
begin
  AFound := True;

  case AErrorCode of
    SEC_E_DECRYPT_FAILURE:             AMessage := SSPIErrorDECRYPT_FAILURE;
    SEC_E_ALGORITHM_MISMATCH:          AMessage := SSPIErrorALGORITHM_MISMATCH;
    SSPI_E_NOT_SUPPORTED:              AMessage := SclSimpleNotSupported;
    SEC_E_INVALID_HANDLE:              AMessage := SSPIErrorINVALIDHANDLE;
    SEC_E_UNSUPPORTED_FUNCTION:        AMessage := SSPIErrorUNSUPPORTED_FUNCTION;
    SEC_E_TARGET_UNKNOWN:              AMessage := SSPIErrorTARGET_UNKNOWN;
    SEC_E_INTERNAL_ERROR:              AMessage := SSPIErrorINTERNAL_ERROR;
    SEC_E_SECPKG_NOT_FOUND:            AMessage := SSPIErrorSECPKG_NOT_FOUND;
    SEC_E_NOT_OWNER:                   AMessage := SSPIErrorNOT_OWNER;
    SEC_E_CANNOT_INSTALL:              AMessage := SSPIErrorCANNOT_INSTALL;
    SEC_E_INVALID_TOKEN:               AMessage := SSPIErrorINVALID_TOKEN;
    SEC_E_CANNOT_PACK:                 AMessage := SSPIErrorCANNOT_PACK;
    SEC_E_QOP_NOT_SUPPORTED:           AMessage := SSPIErrorQOP_NOT_SUPPORTED;
    SEC_E_NO_IMPERSONATION:            AMessage := SSPIErrorNO_IMPERSONATION;
    SEC_E_LOGON_DENIED:                AMessage := SSPIErrorLOGON_DENIED;
    SEC_E_UNKNOWN_CREDENTIALS:         AMessage := SSPIErrorUNKNOWN_CREDENTIALS;
    SEC_E_NO_CREDENTIALS:              AMessage := SSPIErrorNO_CREDENTIALS;
    SEC_E_MESSAGE_ALTERED:             AMessage := SSPIErrorMESSAGE_ALTERED;
    SEC_E_OUT_OF_SEQUENCE:             AMessage := SSPIErrorOUT_OF_SEQUENCE;
    SEC_E_NO_AUTHENTICATING_AUTHORITY: AMessage := SSPIErrorNO_AUTHENTICATING_AUTHORITY;
    SEC_E_BAD_PKGID:                   AMessage := SSPIErrorBAD_PKGID;
    SEC_E_OUTOFMEMORY:                 AMessage := SSPIErrorOUTOFMEMORY;
    SSPI_E_WhileVerify:                AMessage := SSPIErrorWhileTrustPerforming;
    SSPI_E_LoadLibrary:                AMessage := SSPIErrorLoadLibrary;
    SSPI_E_FuncTableInit:              AMessage := SSPIErrorFuncTableInit;
    SSPI_E_SecPackage:                 AMessage := SSPIErrorSecPackage;
    SSPI_E_AcquireFailed:              AMessage := SSPIErrorAcquireFailed;
    SSPI_E_PackageNotFound:            AMessage := SSPIErrorPackageNotFound;
    SSPI_E_QueryPackageInfoFailed:     AMessage := SSPIErrorQueryPackageInfoFailed;
    SSPI_E_QueryLocalCertificate:      AMessage := SSPIErrorQueryLocalCertificate;
    TRUST_E_CERT_SIGNATURE:            AMessage := SSPIErrorCERTSIGNATURE;
    CERT_E_EXPIRED:                    AMessage := SSPIErrorCERTEXPIRED;
    CERT_E_VALIDITYPERIODNESTING:      AMessage := SSPIErrorCERTVALIDITYPERIODNESTING;
    CERT_E_ROLE:                       AMessage := SSPIErrorCERTROLE;
    CERT_E_PATHLENCONST:               AMessage := SSPIErrorCERTPATHLENCONST;
    CERT_E_CRITICAL:                   AMessage := SSPIErrorCERTCRITICAL;
    CERT_E_PURPOSE:                    AMessage := SSPIErrorCERTPURPOSE;
    CERT_E_ISSUERCHAINING:             AMessage := SSPIErrorCERTISSUERCHAINING;
    CERT_E_MALFORMED:                  AMessage := SSPIErrorCERTMALFORMED;
    CERT_E_UNTRUSTEDROOT:              AMessage := SSPIErrorCERTUNTRUSTEDROOT;
    CERT_E_CHAINING:                   AMessage := SSPIErrorCERTCHAINING;
    TRUST_E_FAIL:                      AMessage := SSPIErrorCERTFAIL;
    CERT_E_REVOKED:                    AMessage := SSPIErrorCERTREVOKED;
    CERT_E_UNTRUSTEDTESTROOT:          AMessage := SSPIErrorCERTUNTRUSTEDTESTROOT;
    CERT_E_REVOCATION_FAILURE:         AMessage := SSPIErrorCERTREVOCATION_FAILURE;
    CERT_E_CN_NO_MATCH:                AMessage := SSPIErrorCERTCN_NO_MATCH;
    CERT_E_WRONG_USAGE:                AMessage := SSPIErrorCERTWRONG_USAGE;
  else
    begin
      AMessage := Format(SSPIErrorUnknownError, [AErrorCode]);
      AFound := False;
    end;
  end;
end;

procedure RaiseSspiError(AErrorCode: SECURITY_STATUS);
begin
  RaiseSspiError(AErrorCode, AErrorCode);
end;

procedure RaiseSspiError(AErrorCode, ADefaultError: SECURITY_STATUS);
var
  msg: string;
  found: Boolean;
begin
  GetSspiErrorMessage(AErrorCode, msg, found);

  if (found) then
  begin
    raise EclSSPIError.Create(msg, AErrorCode);
  end;

  raise EclSSPIError.Create(GetSspiErrorMessage(ADefaultError), AErrorCode);
end;

{ TclSspi }

constructor TclSspi.Create;
begin
  inherited Create();
  FDLLHandle := 0;
  FFunctionTable := nil;
end;

destructor TclSspi.Destroy;
begin
  if (FDLLHandle <> 0) then
  begin
    FreeLibrary(FDLLHandle);
  end;
  inherited Destroy();
end;

function TclSspi.GetFunctionTable: PSecurityFunctionTable;
begin
  if (FFunctionTable = nil) then
  begin
    InitFunctionTable();
  end;
  Result := FFunctionTable;
end;

procedure TclSspi.InitFunctionTable;
var
  ind: Integer;
  InitSecurityInterface: PInitSecurityInterface;
begin
  ind := 0;
  FDLLHandle := LoadLibrary(DLL_NAMES[ind]);
  if (FDLLHandle <= HINSTANCE_ERROR) then
  begin
    Inc(ind);
    FDLLHandle := LoadLibrary(DLL_NAMES[ind]);
    if (FDLLHandle <= HINSTANCE_ERROR) then
    begin
      Inc(ind);
      FDLLHandle := LoadLibrary(DLL_NAMES[ind]);
      if (FDLLHandle <= HINSTANCE_ERROR) then
      begin
        RaiseSspiError(SSPI_E_LoadLibrary);
      end;
    end;
  end;

  InitSecurityInterface := GetProcAddress(FDLLHandle, SECURITY_ENTRYPOINT);
  if (InitSecurityInterface = nil) then
  begin
    RaiseSspiError(SSPI_E_SecPackage);
  end;

  FFunctionTable := TInitSecurityInterface(InitSecurityInterface);
  if (FFunctionTable = nil) then
  begin
    RaiseSspiError(SSPI_E_FuncTableInit);
  end;
end;

{ EclSSPIError }

constructor EclSSPIError.Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorMsg);
  FErrorCode := AErrorCode;
end;

end.
