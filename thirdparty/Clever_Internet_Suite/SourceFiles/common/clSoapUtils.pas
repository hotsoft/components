{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSoapUtils;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clXmlCanonicalizerUtils, clUtils, clCryptRandom;

type
  EclSoapMessageError = class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean = False);
    property ErrorCode: Integer read FErrorCode;
  end;

function GetSoapNodeName(const ANamespace, AName: string): string;
function GetSoapNamespace(const ANamespace: string): string;
function GenerateUniqueID: string;

const
  dsNameSpaceName = 'http://www.w3.org/2000/09/xmldsig#';
  wsseNameSpaceName = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd';
  wsuNameSpaceName = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd';
  wsaNameSpaceName = 'http://www.w3.org/2005/08/addressing';
  xencNameSpaceName = 'http://www.w3.org/2001/04/xmlenc#';
  wsse11NameSpaceName = 'http://docs.oasis-open.org/wss/oasis-wss-wssecurity-secext-1.1.xsd';

  envelopeNameSpaceName = 'http://schemas.xmlsoap.org/soap/envelope/';
  soap12NameSpaceName = 'http://www.w3.org/2003/05/soap-envelope';

  X509ThumbprintIdentifier = 'http://docs.oasis-open.org/wss/2005/xx/oasis-2005xx-wss-soap-message-security-1.1#X509ThumbprintSHA1';
  X509SubjectKeyIdentifier = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509SubjectKeyIdentifier';
  X509CertificateIdentifier = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-x509-token-profile-1.0#X509v3';
  EncryptedKeyIdentifier = 'http://docs.oasis-open.org/wss/oasis-wss-soap-message-security-1.1#EncryptedKey';
  Base64BinaryXmlEncoding = 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary';

  SHA1_AlgorithmName = 'http://www.w3.org/2000/09/xmldsig#sha1';
  RSA_OAEP_MGF1P_AlgorithmName = 'http://www.w3.org/2001/04/xmlenc#rsa-oaep-mgf1p';
  AES_256_CBC_AlgorithmName = 'http://www.w3.org/2001/04/xmlenc#aes256-cbc';
  RSA_SHA1_AlgorithmName = 'http://www.w3.org/2000/09/xmldsig#rsa-sha1';

  EncryptionTypeContent = 'http://www.w3.org/2001/04/xmlenc#Content';

  DefaultEncodingStyle = 'http://schemas.xmlsoap.org/soap/encoding/';
  DefaultIdName = 'Id';
  DefaultX509TokenReference = 'X509TokenReference';
  DefaultX509Token = 'X509Token';
  DefaultX509KeyId = 'X509KeyId';

resourcestring
  SoapDataNotFound = 'Can not find the specified SOAP data';
  SoapFormatError = 'SOAP message format error';
  GetNameSpaceFailed = 'Unable to obtain the namespace for the envelope node';
  RequestEmpty = 'The xml data is not specified in the SOAP request object';
  ReferencesEmpty = 'The SOAP References are not defined for the SOAP request object';
  VerifyDigestFailed = 'Digest values differ';
  VerifySignatureFailed = 'Signature is invalid';
  ParameterSetError = 'The parameter set is invalid';
  CanonicalizeMethodError = 'Unsupported canonicalization method';
  HashSizeInvalidError = 'Hash size error';
  SignaturesEmpty = 'The SOAP Signatures are not defined for the SOAP request object';
  SignatureIdEmpty = 'The SOAP Signature ID is not defined';

  SoapMessageNotSigned = 'The message is not signed';
  SoapMessageEncrypted = 'The message is already encrypted';
  SoapMessageNotEncrypted = 'The message is not encrypted';

  SoapDecryptFailed = 'SOAP decrypt failed';
  SoapEncryptFailed = 'SOAP encrypt failed';
  EncryptionMethodError = 'The encryption method is not supported';
  MultipleEncryptKeysError = 'Multiple encryption keys are not supported';
  SoapDataError = 'The specified SOAP data is empty';
  EncryptBlockSizeError = 'The encryption block size is invalid';
  EncryptKeySizeError = 'The encryption key size is invalid';

  SignatureMethodError = 'The signature method is not supported';
  SoapTransformAlgorithmError = 'The SOAP transform algorithm is not supported';

  EncryptKeyCertificateError = 'The assigning/getting the certificate is not allowed for this encrypted key type';

  SoapVersionError = 'The SOAP version is invalid';
  SoapUnknownKeyClassType = 'The key class type is not registered';

const
  SoapDataNotFoundCode = -10;
  SoapFormatErrorCode = -11;
  GetNameSpaceFailedCode = -12;
  RequestEmptyCode = -13;
  ReferencesEmptyCode = -14;
  VerifyDigestFailedCode = -15;
  VerifySignatureFailedCode = -16;
  ParameterSetErrorCode = -17;
  CanonicalizeMethodErrorCode = -18;
  HashSizeInvalidErrorCode = -19;
  SignaturesEmptyCode = -20;
  SignatureIdEmptyCode = -21;

  SoapMessageNotSignedCode = -32;
  SoapMessageEncryptedCode = -33;
  SoapMessageNotEncryptedCode = -34;

  SoapDecryptFailedCode = -41;
  SoapEncryptFailedCode = -42;
  EncryptionMethodErrorCode = -43;
  MultipleEncryptKeysErrorCode = -44;
  SoapDataErrorCode = -45;
  EncryptBlockSizeErrorCode = -46;
  EncryptKeySizeErrorCode = -47;

  SignatureMethodErrorCode = -48;
  SoapTransformAlgorithmErrorCode = -49;

  EncryptKeyCertificateErrorCode = -50;

  SoapVersionErrorCode = -51;
  SoapUnknownKeyClassTypeCode = -52;

implementation

function GenerateUniqueID: string;
var
  buf: TclByteArray;
begin
  buf := GenerateRandomData(16);
  Result := UpperCase(BytesToHex(buf));
end;

function GetSoapNodeName(const ANamespace, AName: string): string;
begin
  if (ANamespace <> '') then
  begin
    Result := ANamespace + ':' + AName;
  end else
  begin
    Result := AName;
  end;
end;

function GetSoapNamespace(const ANamespace: string): string;
begin
  if (ANamespace <> '') then
  begin
    Result :=  'xmlns:' + ANamespace;
  end else
  begin
    Result := '';
    Assert(False);
  end;
end;

{ EclSoapMessageError }

constructor EclSoapMessageError.Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorMsg);
  FErrorCode := AErrorCode;
end;

end.
