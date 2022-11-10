{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSMimeMessage;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows{$IFDEF DEMO}, Forms{$ENDIF},
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows{$IFDEF DEMO}, Vcl.Forms{$ENDIF},
{$ENDIF}
  clMailMessage, clCertificate, clCertificateStore, clEncryptor, clCryptUtils,
  clCryptAPI, clEncoder, clEmailAddress, clTranslator, clWUtils, clMailHeader;

type
  EclSMimeError = class(EclCryptError);

  TclSMimeBody = class(TclMessageBody)
  private
    FSource: TStrings;
    FBoundary: string;
    
    procedure SetSource(const Value: TStrings);
    procedure SetBoundary(const Value: string);
    function GetHeader: TStrings;
    procedure SetHeader(const Value: TStrings);
  protected
    procedure ReadData(Reader: TReader); override;
    procedure WriteData(Writer: TWriter); override;
    procedure AssignBodyHeader(AFieldList: TclMailHeaderFieldList); override;
    procedure ParseBodyHeader(AFieldList: TclMailHeaderFieldList); override;
    function GetSourceStream: TStream; override;
    function GetDestinationStream: TStream; override;
    procedure BeforeDataAdded(AData: TStream); override; 
    procedure DataAdded(AData: TStream); override;
    procedure DecodeData(ASource, ADestination: TStream); override;
    procedure EncodeData(ASource, ADestination: TStream); override;
    procedure DoCreate; override;
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear(); override;
    
    property Header: TStrings read GetHeader write SetHeader;
    property Source: TStrings read FSource write SetSource;
    property Boundary: string read FBoundary write SetBoundary;
  end;

  TclEnvelopedBody = class(TclAttachmentBody)
  private
    FData: TclCryptData;
    
    procedure SetData(const Value: TclCryptData);
  protected
    function GetSourceStream: TStream; override;
    function GetDestinationStream: TStream; override;
    procedure DataAdded(AData: TStream); override;
    procedure DoCreate; override;
  public
    destructor Destroy; override;
    procedure Clear(); override;
    
    property Data: TclCryptData read FData write SetData;
  end;

  TclSMimeMessage = class(TclMailMessage)
  private
    FSMimeContentType: string;
    FIsDetachedSignature: Boolean;
    FIsIncludeCertificate: Boolean;
    FCertificates: TclCertificateStore;
    FInternalCertStore: TclCertificateStore;
    FIsSecuring: Boolean;
    FEncryptor: TclEncryptor;

    FOnGetEncryptionCertificate: TclGetCertificateEvent;
    FOnGetSigningCertificate: TclGetCertificateEvent;
    
    procedure SetSMimeContentType(const Value: string);
    function GetIsEncrypted: Boolean;
    function GetIsSigned: Boolean;
    procedure SetIsDetachedSignature(const Value: Boolean);
    procedure SetIsIncludeCertificate(const Value: Boolean);

    procedure SignDetached(ACertificate: TclCertificate; AddonCerts: TclCertificateList);
    procedure SignEnveloped(ACertificate: TclCertificate; AddonCerts: TclCertificateList);
    procedure VerifyDetached;
    procedure VerifyEnveloped;
    procedure InternalVerify;
    procedure InternalDecrypt;

    function GetVerifyCertificate(const AStoreName: string): TclCertificate;
    function GetDecryptCertificate(const AStoreName: string): TclCertificate;
    function GetSignCertificates(const AStoreName: string; AddonCerts: TclCertificateList): TclCertificate;
    procedure GetEncryptCertificates(const AStoreName: string; ACerts: TclCertificateList);
    function GetRecipientCertificate(const AStoreName: string; AEmailList: TclEmailAddressList): TclCertificate;
    function GetEmailCertificate(const AFullEmail, AStoreName: string; ARequirePrivateKey: Boolean): TclCertificate;
  protected
    procedure DoGetSigningCertificate(var ACertificate: TclCertificate; AExtraCerts: TclCertificateList; var Handled: Boolean); dynamic;
    procedure DoGetEncryptionCertificate(var ACertificate: TclCertificate; AExtraCerts: TclCertificateList; var Handled: Boolean); dynamic;

    procedure ParseContentType(AFieldList: TclMailHeaderFieldList); override;
    procedure AssignContentType(AFieldList: TclMailHeaderFieldList); override;
    function GetIsMultiPartContent: Boolean; override;
    function CreateBody(ABodies: TclMessageBodies; const AContentType, ADisposition: string): TclMessageBody; override;
    function CreateSingleBody(ASource: TStrings; ABodies: TclMessageBodies): TclMessageBody; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Clear; override;
    procedure Sign;
    procedure Verify;
    procedure Encrypt;
    procedure Decrypt;
    procedure DecryptAndVerify;
    
    property IsEncrypted: Boolean read GetIsEncrypted;
    property IsSigned: Boolean read GetIsSigned;
    property Certificates: TclCertificateStore read FCertificates;
  published
    property IsDetachedSignature: Boolean read FIsDetachedSignature write SetIsDetachedSignature default True;
    property IsIncludeCertificate: Boolean read FIsIncludeCertificate write SetIsIncludeCertificate default True;
    property SMimeContentType: string read FSMimeContentType write SetSMimeContentType;

    property OnGetSigningCertificate: TclGetCertificateEvent read FOnGetSigningCertificate write FOnGetSigningCertificate;
    property OnGetEncryptionCertificate: TclGetCertificateEvent read FOnGetEncryptionCertificate write FOnGetEncryptionCertificate;
  end;

resourcestring
  MessageSigned = 'The message is already signed';
  MessageNotSigned = 'The message is not signed';
  MessageEncrypted = 'The message is already encrypted';
  MessageNotEncrypted = 'The message is not encrypted';

const
  MessageSignedCode = -12;
  MessageNotSignedCode = -13;
  MessageEncryptedCode = -14;
  MessageNotEncryptedCode = -15;

implementation

uses
  clUtils{$IFDEF LOGGER}, clLogger{$ENDIF};

{ TclSMimeMessage }

procedure TclSMimeMessage.AssignContentType(AFieldList: TclMailHeaderFieldList);
begin
  if IsEncrypted or (IsSigned and not IsDetachedSignature) then
  begin
    AFieldList.AddField('Content-Type', ContentType);
    AFieldList.AddFieldItem('Content-Type', 'smime-type', SMimeContentType);
    AFieldList.AddQuotedFieldItem('Content-Type', 'boundary', Boundary);
    AFieldList.AddQuotedFieldItem('Content-Type', 'name', 'smime.p7m');

    AFieldList.AddField('Content-Disposition', 'attachment');
    AFieldList.AddQuotedFieldItem('Content-Disposition', 'filename', 'smime.p7m');
  end else
  if (IsSigned and IsDetachedSignature) then
  begin
    AFieldList.AddField('Content-Type', ContentType);
    AFieldList.AddQuotedFieldItem('Content-Type', 'boundary', Boundary);
    AFieldList.AddQuotedFieldItem('Content-Type', 'protocol', 'application/x-pkcs7-signature');
    AFieldList.AddFieldItem('Content-Type', 'micalg', 'SHA1'); //TODO possible replace with sha-1 according to RFC5751 and synchronize with encryptor.SignAlgorithm
  end else
  begin
    inherited AssignContentType(AFieldList);
  end;
end;

procedure TclSMimeMessage.Clear;
begin
  BeginUpdate();
  try
    if not FIsSecuring then
    begin
      Certificates.Close();
    end;
    SMimeContentType := '';
    inherited Clear();
  finally
    EndUpdate();
  end;
end;

constructor TclSMimeMessage.Create(AOwner: TComponent);
begin
  FCertificates := TclCertificateStore.Create(nil);
  FCertificates.StoreName := 'addressbook';
  FEncryptor := TclEncryptor.Create(nil);
  FEncryptor.ExtractCertificates := False;

  inherited Create(AOwner);

  FIsDetachedSignature := True;
  FIsIncludeCertificate := True;
  FIsSecuring := False;
end;

procedure TclSMimeMessage.Decrypt;
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
    if (not IsMailMessageDemoDisplayed) and (not IsEncoderDemoDisplayed)
      and (not IsCertDemoDisplayed) and (not IsEncryptorDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsMailMessageDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  InternalDecrypt();
end;

procedure TclSMimeMessage.DecryptAndVerify;
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
    if (not IsMailMessageDemoDisplayed) and (not IsEncoderDemoDisplayed)
      and (not IsCertDemoDisplayed) and (not IsEncryptorDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsMailMessageDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'DecryptAndVerify');{$ENDIF}
  repeat
    if IsEncrypted then
    begin
      InternalDecrypt();
    end else
    if IsSigned then
    begin
      InternalVerify();
    end else
    begin
      Break;
    end;
  until False;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'DecryptAndVerify'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'DecryptAndVerify', E); raise; end; end;{$ENDIF}
end;

procedure TclSMimeMessage.Encrypt;
var
  certs: TclCertificateList;
  srcData, encData: TclCryptData;
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
    if (not IsMailMessageDemoDisplayed) and (not IsEncoderDemoDisplayed)
      and (not IsCertDemoDisplayed) and (not IsEncryptorDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsMailMessageDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Encrypt');{$ENDIF}

  if IsEncrypted then
  begin
    raise EclSMimeError.Create(MessageEncrypted, MessageEncryptedCode);
  end;
  FIsSecuring := True;
  srcData := nil;
  certs := nil;
  BeginUpdate();
  try
    certs := TclCertificateList.Create(False);
    
    GetEncryptCertificates('addressbook', certs);

    srcData := TclCryptData.Create();
    srcData.FromStrings(MessageSource);
    encData := FEncryptor.Encrypt(srcData, certs);
    try
      Bodies.Clear();
      TclEnvelopedBody.Create(Bodies).Data := encData;
    except
      encData.Free();
      raise;
    end;
    ContentType := 'application/x-pkcs7-mime';
    SMimeContentType := 'enveloped-data';
    Encoding := cmBase64;
  finally
    srcData.Free();
    certs.Free();
    EndUpdate();
    FIsSecuring := False;
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Encrypt'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Encrypt', E); raise; end; end;{$ENDIF}
end;

function TclSMimeMessage.GetDecryptCertificate(const AStoreName: string): TclCertificate;
var
  handled: Boolean;
  list: TclCertificateList;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'GetDecryptCertificate, storename: %s', nil, [AStoreName]);{$ENDIF}
  Result := nil;
  handled := False;

  list := TclCertificateList.Create(False);
  try
    DoGetEncryptionCertificate(Result, list, handled);
    if (Result = nil) then
    begin
      Result := GetRecipientCertificate(AStoreName, ToList);
    end;
    if (Result = nil) then
    begin
      Result := GetRecipientCertificate(AStoreName, CcList);
    end;
    if (Result = nil) then
    begin
      Result := GetRecipientCertificate(AStoreName, BccList);
    end;
  finally
    list.Free();
  end;
  if (Result = nil) then
  begin
    raise EclSMimeError.Create(CertificateRequired, CertificateRequiredCode);
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'GetDecryptCertificate'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'GetDecryptCertificate', E); raise; end; end;{$ENDIF}
end;

function TclSMimeMessage.GetEmailCertificate(const AFullEmail, AStoreName: string; ARequirePrivateKey: Boolean): TclCertificate;

var
  name, email: string;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'GetEmailCertificate, email: %s, store: %s', nil, [AFullEmail, AStoreName]);{$ENDIF}
  GetEmailAddressParts(AFullEmail, name, email);
  Result := Certificates.FindByEmail(email, ARequirePrivateKey);
  if (Result = nil) then
  begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'GetEmailCertificate before FInternalCertStore');{$ENDIF}
    if (FInternalCertStore = nil) then
    begin
      FInternalCertStore := TclCertificateStore.Create(nil);
    end;
    FInternalCertStore.Open(AStoreName);
    Result := FInternalCertStore.FindByEmail(email, ARequirePrivateKey);
  end;

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'GetEmailCertificate before return, Result: %d', nil, [Integer(Result)]);{$ENDIF}

{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'GetEmailCertificate'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'GetEmailCertificate', E); raise; end; end;{$ENDIF}
end;

function TclSMimeMessage.GetRecipientCertificate(const AStoreName: string; AEmailList: TclEmailAddressList): TclCertificate;
var
  i: Integer;
begin
  for i := 0 to AEmailList.Count - 1 do
  begin
    Result := GetEmailCertificate(AEmailList[i].Email, AStoreName, True);
    if (Result <> nil) then Exit;
  end;
  Result := nil;
end;

function TclSMimeMessage.GetSignCertificates(const AStoreName: string; AddonCerts: TclCertificateList): TclCertificate;
var
  handled: Boolean;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'GetSignCertificates, storename: %s, AddonCerts %d', nil, [AStoreName, AddonCerts.Count]);{$ENDIF}
  Result := nil;
  handled := False;
  DoGetSigningCertificate(Result, AddonCerts, handled);
  if (Result = nil) then
  begin
    Result := GetEmailCertificate(From.Email, AStoreName, True);
  end;
  if (Result = nil) then
  begin
    raise EclSMimeError.Create(CertificateRequired, CertificateRequiredCode);
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'GetSignCertificates'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'GetSignCertificates', E); raise; end; end;{$ENDIF}
end;

function TclSMimeMessage.GetVerifyCertificate(const AStoreName: string): TclCertificate;
var
  handled: Boolean;
  list: TclCertificateList;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'GetVerifyCertificate, storename: %s', nil, [AStoreName]);{$ENDIF}
  Result := nil;
  handled := False;

  list := TclCertificateList.Create(False);
  try
    DoGetSigningCertificate(Result, list, handled);
    if (Result = nil) then
    begin
      Result := GetEmailCertificate(From.Email, AStoreName, False);
    end;
  finally
    list.Free();
  end;
  if (Result = nil) then
  begin
    raise EclSMimeError.Create(CertificateRequired, CertificateRequiredCode);
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'GetVerifyCertificate'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'GetVerifyCertificate', E); raise; end; end;{$ENDIF}
end;

function TclSMimeMessage.GetIsEncrypted: Boolean;
begin
  Result := (Pos('pkcs7-mime', LowerCase(ContentType)) > 0)
    and (not SameText(SMimeContentType, 'signed-data'));
end;

function TclSMimeMessage.GetIsMultiPartContent: Boolean;
begin
  Result := inherited GetIsMultiPartContent() and not IsEncrypted;
  if IsParse then
  begin
    Result := Result and not (IsSigned and (LowerCase(ContentType) <> 'multipart/signed'));
  end else
  begin
    Result := Result and not (IsSigned and not IsDetachedSignature);
  end;
end;

function TclSMimeMessage.GetIsSigned: Boolean;
begin
  Result := SameText(ContentType, 'multipart/signed')
    or ((Pos('pkcs7-mime', LowerCase(ContentType)) > 0) and SameText(SMimeContentType, 'signed-data'));
end;

function TclSMimeMessage.CreateSingleBody(ASource: TStrings; ABodies: TclMessageBodies): TclMessageBody;
begin
  if IsEncrypted or (IsSigned and (LowerCase(ContentType) <> 'multipart/signed')) then
  begin
    Result := TclEnvelopedBody.Create(ABodies);
  end else
  begin
    Result := inherited CreateSingleBody(ASource, ABodies);
  end;
end;

procedure TclSMimeMessage.ParseContentType(AFieldList: TclMailHeaderFieldList);
var
  s: string;
begin
  inherited ParseContentType(AFieldList);
  s := AFieldList.GetFieldValue('Content-Type');
  SMimeContentType := AFieldList.GetFieldValueItem(s, 'smime-type');
end;

procedure TclSMimeMessage.SetIsDetachedSignature(const Value: Boolean);
begin
  if (FIsDetachedSignature <> Value) then
  begin
    FIsDetachedSignature := Value;
    Update();
  end;
end;

procedure TclSMimeMessage.SetIsIncludeCertificate(const Value: Boolean);
begin
  if (FIsIncludeCertificate <> Value) then
  begin
    FIsIncludeCertificate := Value;
    Update();
  end;
end;

procedure TclSMimeMessage.SetSMimeContentType(const Value: string);
begin
  if (FSMimeContentType <> Value) then
  begin
    FSMimeContentType := Value;
    Update();
  end;
end;

procedure TclSMimeMessage.SignEnveloped(ACertificate: TclCertificate; AddonCerts: TclCertificateList);
var
  srcData, signedData: TclCryptData;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'SignEnveloped');{$ENDIF}
  srcData := TclCryptData.Create('us-ascii');
  try
    srcData.FromStrings(MessageSource);

    signedData := FEncryptor.Sign(srcData, IsDetachedSignature, IsIncludeCertificate, ACertificate, AddonCerts);
    try
      Bodies.Clear();
      TclEnvelopedBody.Create(Bodies).Data := signedData;
    except
      signedData.Free();
      raise;
    end;

    ContentType := 'application/x-pkcs7-mime';
    SMimeContentType := 'signed-data';
    Encoding := cmBase64;
  finally
    srcData.Free();
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'SignEnveloped'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'SignEnveloped', E); raise; end; end;{$ENDIF}
end;

procedure TclSMimeMessage.SignDetached(ACertificate: TclCertificate; AddonCerts: TclCertificateList);
var
  i, ind: Integer;
  srcData, signedData: TclCryptData;
  oldIncludeRFC822: Boolean;
  srcStrings: TStrings;
  FieldList: TclMailHeaderFieldList;
  cryptBody: TclSMimeBody;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'SignDetached');{$ENDIF}
  srcData := nil;
  srcStrings := nil;
  FieldList := nil;
  oldIncludeRFC822 := IncludeRFC822Header;
  try
    srcData := TclCryptData.Create('us-ascii');
    srcStrings := TStringList.Create();
    IncludeRFC822Header := False;
    InternalAssignHeader(srcStrings);
    InternalAssignBodies(srcStrings);

    srcStrings.Add('');
    srcData.FromStrings(srcStrings);
    srcStrings.Delete(srcStrings.Count - 1);

    signedData := FEncryptor.Sign(srcData, IsDetachedSignature, IsIncludeCertificate, ACertificate, AddonCerts);
    try
      Bodies.Clear();

      cryptBody := TclSMimeBody.Create(Bodies);

      FieldList := TclMailHeaderFieldList.Create(CharSet, GetHeaderEncoding(), CharsPerLine);
      FieldList.Parse(0, srcStrings);
      cryptBody.ParseBodyHeader(FieldList);

      ind := ParseAllHeaders(0, srcStrings, cryptBody.Header);
      ParseExtraFields(cryptBody.Header, cryptBody.KnownFields, cryptBody.ExtraFields);
      for i := ind + 1 to srcStrings.Count - 1 do
      begin
        cryptBody.Source.Add(srcStrings[i]);
      end;

      TclEnvelopedBody.Create(Bodies).Data := signedData;
    except
      signedData.Free();
      raise;
    end;
  finally
    IncludeRFC822Header := oldIncludeRFC822;
    FieldList.Free();
    srcStrings.Free();
    srcData.Free();
  end;

  ContentType := 'multipart/signed';
  SMimeContentType := '';
  Encoding := cmNone;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'SignDetached'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'SignDetached', E); raise; end; end;{$ENDIF}
end;

procedure TclSMimeMessage.Sign;
var
  addonCerts: TclCertificateList;
  cert: TclCertificate;
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
    if (not IsMailMessageDemoDisplayed) and (not IsEncoderDemoDisplayed)
      and (not IsCertDemoDisplayed) and (not IsEncryptorDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsMailMessageDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Sign');{$ENDIF}

  if IsSigned then
  begin
    raise EclSMimeError.Create(MessageSigned, MessageSignedCode);
  end;
  FIsSecuring := True;
  BeginUpdate();
  addonCerts := nil;
  try
    addonCerts := TclCertificateList.Create(False);

    cert := GetSignCertificates('MY', addonCerts);
    if IsDetachedSignature then
    begin
      SignDetached(cert, addonCerts);
    end else
    begin
      SignEnveloped(cert, addonCerts);
    end;
  finally
    addonCerts.Free();
    EndUpdate();
    FIsSecuring := False;
  end;

{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Sign'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Sign', E); raise; end; end;{$ENDIF}
end;

procedure TclSMimeMessage.Verify;
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
    if (not IsMailMessageDemoDisplayed) and (not IsEncoderDemoDisplayed)
      and (not IsCertDemoDisplayed) and (not IsEncryptorDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsMailMessageDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  InternalVerify();
end;

function TclSMimeMessage.CreateBody(ABodies: TclMessageBodies; const AContentType, ADisposition: string): TclMessageBody;
begin
  if IsSigned then
  begin
    if (LowerCase(ADisposition) = 'attachment')
      and (system.Pos('-signature', LowerCase(AContentType)) > 1) then
    begin
      Result := TclEnvelopedBody.Create(ABodies);
    end else
    begin
      Result := TclSMimeBody.Create(ABodies);
    end;
  end else
  begin
    Result := inherited CreateBody(ABodies, AContentType, ADisposition);
  end;
end;

procedure TclSMimeMessage.VerifyDetached;
var
  cert: TclCertificate;
  msg: TStrings;
  mimeBody: TclSMimeBody;
  srcData: TclCryptData;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'VerifyDetached');{$ENDIF}
  srcData := nil;
  msg := nil;
  try
    srcData := TclCryptData.Create('us-ascii');
    msg := TStringList.Create();
    Assert(Bodies.Count = 2);

    mimeBody := (Bodies[0] as TclSMimeBody);
    msg.AddStrings(mimeBody.Header);
    msg.Add('');
    msg.AddStrings(mimeBody.Source);

    srcData.FromStrings(msg);

    Certificates.ImportFromMessage((Bodies[1] as TclEnvelopedBody).Data);

    cert := GetVerifyCertificate('addressbook');
    FEncryptor.VerifyDetached(srcData, (Bodies[1] as TclEnvelopedBody).Data, cert);

    ContentType := mimeBody.ContentType;
    SetBoundary(mimeBody.Boundary);

    Bodies.Clear();
    ParseBodies(msg);
  finally
    msg.Free();
    srcData.Free();
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'VerifyDetached'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'VerifyDetached', E); raise; end; end;{$ENDIF}
end;

procedure TclSMimeMessage.VerifyEnveloped;
var
  cert: TclCertificate;
  verified: TclCryptData;
  source: TStrings;
  fieldList: TclMailHeaderFieldList;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'VerifyEnveloped');{$ENDIF}
  verified := nil;
  source := nil;
  fieldList := nil;
  try
    Assert(Bodies.Count = 1);

    Certificates.ImportFromMessage((Bodies[0] as TclEnvelopedBody).Data);
    cert := GetVerifyCertificate('addressbook');

    verified := FEncryptor.VerifyEnveloped((Bodies[0] as TclEnvelopedBody).Data, cert);

    source := TStringList.Create();

    verified.CharSet := 'us-ascii';
    source.Text := verified.ToString();

    fieldList := TclMailHeaderFieldList.Create(CharSet, GetHeaderEncoding(), CharsPerLine);

    fieldList.Parse(0, source);

    ParseMimeHeader(fieldList);

    Bodies.Clear();
    ParseBodies(source);
  finally
    fieldList.Free();
    source.Free();
    verified.Free();
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'VerifyEnveloped'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'VerifyEnveloped', E); raise; end; end;{$ENDIF}
end;

destructor TclSMimeMessage.Destroy;
begin
  inherited Destroy();

  FInternalCertStore.Free();
  FEncryptor.Free();
  FCertificates.Free();
end;

procedure TclSMimeMessage.DoGetEncryptionCertificate(var ACertificate: TclCertificate;
  AExtraCerts: TclCertificateList; var Handled: Boolean);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'DoGetEncryptionCertificate');{$ENDIF}
  if Assigned(OnGetEncryptionCertificate) then
  begin
    OnGetEncryptionCertificate(Self, ACertificate, AExtraCerts, Handled);
{$IFDEF LOGGER}clPutLogMessage(Self, edEnter, 'DoGetEncryptionCertificate - event exists, cert: %d, handled: %d', nil, [Integer(ACertificate), Integer(Handled)]);{$ENDIF}
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'DoGetEncryptionCertificate'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'DoGetEncryptionCertificate', E); raise; end; end;{$ENDIF}
end;

procedure TclSMimeMessage.DoGetSigningCertificate(var ACertificate: TclCertificate;
  AExtraCerts: TclCertificateList; var Handled: Boolean);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'DoGetSigningCertificate');{$ENDIF}
  if Assigned(OnGetSigningCertificate) then
  begin
    OnGetSigningCertificate(Self, ACertificate, AExtraCerts, Handled);
{$IFDEF LOGGER}clPutLogMessage(Self, edEnter, 'DoGetSigningCertificate - event exists, cert: %d, handled: %d', nil, [Integer(ACertificate), Integer(Handled)]);{$ENDIF}
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'DoGetSigningCertificate'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'DoGetSigningCertificate', E); raise; end; end;{$ENDIF}
end;

procedure TclSMimeMessage.InternalDecrypt;
var
  cert: TclCertificate;
  decrypted: TclCryptData;
  source: TStrings;
  fieldList: TclMailHeaderFieldList;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'InternalDecrypt');{$ENDIF}
  if not IsEncrypted then
  begin
    raise EclSMimeError.Create(MessageNotEncrypted, MessageNotEncryptedCode);
  end;
  FIsSecuring := True;
  decrypted := nil;
  source := nil;
  fieldList := nil;
  BeginUpdate();
  try
    Assert(Bodies.Count = 1);

    Certificates.ImportFromMessage((Bodies[0] as TclEnvelopedBody).Data);
    cert := GetDecryptCertificate('MY');

    decrypted := FEncryptor.Decrypt((Bodies[0] as TclEnvelopedBody).Data, cert);

    source := TStringList.Create();

    decrypted.CharSet := 'us-ascii';
    source.Text := decrypted.ToString();

    fieldList := TclMailHeaderFieldList.Create(CharSet, GetHeaderEncoding(), CharsPerLine);

    fieldList.Parse(0, source);

    ParseMimeHeader(fieldList);

    Bodies.Clear();
    ParseBodies(source);
  finally
    fieldList.Free();
    source.Free();
    decrypted.Free();
    EndUpdate();
    FIsSecuring := False;
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'InternalDecrypt'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'InternalDecrypt', E); raise; end; end;{$ENDIF}
end;

procedure TclSMimeMessage.InternalVerify;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'InternalVerify');{$ENDIF}
  if not IsSigned then
  begin
    raise EclSMimeError.Create(MessageNotSigned, MessageNotSignedCode);
  end;
  FIsSecuring := True;
  BeginUpdate();
  try
    if (LowerCase(ContentType) = 'multipart/signed') then
    begin
      VerifyDetached();
    end else
    begin
      VerifyEnveloped();
    end;
  finally
    EndUpdate();
    FIsSecuring := False;
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'InternalVerify'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'InternalVerify', E); raise; end; end;{$ENDIF}
end;

procedure TclSMimeMessage.GetEncryptCertificates(const AStoreName: string; ACerts: TclCertificateList);

  procedure FillRecipientCerts(ACerts: TclCertificateList; const AStoreName: string; AEmailList: TclEmailAddressList);
  var
    i: Integer;
    cert: TclCertificate;
  begin
    for i := 0 to AEmailList.Count - 1 do
    begin
      cert := GetEmailCertificate(AEmailList[i].Email, AStoreName, False);
      if (cert = nil) then
      begin
        raise EclSMimeError.Create(CertificateNotFound, CertificateNotFoundCode);
      end;
      ACerts.Add(cert);
    end;
  end;

var
  handled: Boolean;
  cert: TclCertificate;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'GetEncryptCertificates: ' + AStoreName);{$ENDIF}
  handled := False;
  cert := nil;
  DoGetEncryptionCertificate(cert, ACerts, handled);
  if (cert = nil) then
  begin
    FillRecipientCerts(ACerts, AStoreName, ToList);
    FillRecipientCerts(ACerts, AStoreName, CcList);
    FillRecipientCerts(ACerts, AStoreName, BccList);
  end else
  begin
    ACerts.Add(cert);
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'GetEncryptCertificates, certcount: %d', nil, [ACerts.Count]);{$ENDIF}
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'GetEncryptCertificates'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'GetEncryptCertificates', E); raise; end; end;{$ENDIF}
end;

{ TclEnvelopedBody }

procedure TclEnvelopedBody.Clear;
begin
  inherited Clear();

  FileName := 'smime.p7s';
  ContentType := 'application/x-pkcs7-signature';
  Encoding := cmBase64;
end;

procedure TclEnvelopedBody.DataAdded(AData: TStream);
begin
  AData.Position := 0;
  Data.FromStream(AData);

  inherited DataAdded(AData);
end;

destructor TclEnvelopedBody.Destroy;
begin
  FData.Free();
  inherited Destroy();
end;

procedure TclEnvelopedBody.DoCreate;
begin
  inherited DoCreate();
  FData := TclCryptData.Create();
end;

function TclEnvelopedBody.GetDestinationStream: TStream;
begin
  Result := TMemoryStream.Create();
end;

function TclEnvelopedBody.GetSourceStream: TStream;
begin
  Result := TMemoryStream.Create();
  try
    Data.ToStream(Result);
    Result.Position := 0;
  except
    Result.Free();
    raise;
  end;
end;

procedure TclEnvelopedBody.SetData(const Value: TclCryptData);
begin
  FData.Free();
  FData := Value;
  GetMailMessage().Update();
end;

{ TclSMimeBody }

procedure TclSMimeBody.Assign(Source: TPersistent);
begin
  GetMailMessage().BeginUpdate();
  try
    if (Source is TclSMimeBody) then
    begin
      Source.Assign((Source as TclSMimeBody).Source);
      Boundary := (Source as TclSMimeBody).Boundary;
    end;
    inherited Assign(Source);
  finally
    GetMailMessage().EndUpdate();
  end;
end;

procedure TclSMimeBody.AssignBodyHeader(AFieldList: TclMailHeaderFieldList);
begin
  AFieldList.AddFields(Header);
  if (Header.Count > 0) then Exit;

  AFieldList.AddField('Content-Type', ContentType);

  if (ContentType <> '') and (Boundary <> '') then
  begin
    AFieldList.AddQuotedFieldItem('Content-Type', 'boundary', Boundary);
  end;

  AFieldList.AddFields(ExtraFields);
end;

procedure TclSMimeBody.BeforeDataAdded(AData: TStream);
begin
end;

procedure TclSMimeBody.Clear;
begin
  inherited Clear();
  Source.Clear();
  Boundary := '';
end;

procedure TclSMimeBody.DataAdded(AData: TStream);
var
  buf: TclByteArray;
begin
  SetLength(buf, AData.Size);

  AData.Position := 0;
  AData.Read(buf[0], AData.Size);
  AddTextStr(FSource, TclTranslator.GetString(buf, 'us-ascii'));

  inherited DataAdded(AData);
end;

procedure TclSMimeBody.DecodeData(ASource, ADestination: TStream);
begin
  ADestination.CopyFrom(ASource, ASource.Size)
end;

destructor TclSMimeBody.Destroy;
begin
  FSource.Free();
  inherited Destroy();
end;

procedure TclSMimeBody.DoCreate;
begin
  inherited DoCreate();
  FSource := TStringList.Create();
  SetListChangedEvent(FSource as TStringList);
  SetListChangedEvent(Header as TStringList);
end;

procedure TclSMimeBody.EncodeData(ASource, ADestination: TStream);
begin
  ADestination.CopyFrom(ASource, ASource.Size)
end;

function TclSMimeBody.GetDestinationStream: TStream;
begin
  Result := TMemoryStream.Create();
end;

function TclSMimeBody.GetHeader: TStrings;
begin
  Result := RawHeader;
end;

function TclSMimeBody.GetSourceStream: TStream;
var
  size: Integer;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}

  Result := TMemoryStream.Create();
  try
    buf := TclTranslator.GetBytes(FSource.Text, 'us-ascii');

    size := Length(buf);
    if (size - Length(#13#10) > 0) then
    begin
      size := size - Length(#13#10);
    end;

    if (size > 0) then
    begin
      Result.WriteBuffer(buf[0], size);
      Result.Position := 0;
    end;
  except
    Result.Free();
    raise;
  end;
end;

procedure TclSMimeBody.ParseBodyHeader(AFieldList: TclMailHeaderFieldList);
var
  s: string;
begin
  inherited ParseBodyHeader(AFieldList);
  s := AFieldList.GetFieldValue('Content-Type');
  Boundary := AFieldList.GetFieldValueItem(s, 'boundary');
end;

procedure TclSMimeBody.ReadData(Reader: TReader);
begin
  Source.Text := Reader.ReadString();
  Boundary := Reader.ReadString();
  inherited ReadData(Reader);
end;

procedure TclSMimeBody.SetBoundary(const Value: string);
begin
  if (FBoundary <> Value) then
  begin
    FBoundary := Value;
    GetMailMessage().Update();
  end;
end;

procedure TclSMimeBody.SetHeader(const Value: TStrings);
begin
  RawHeader.Assign(Value);
  GetMailMessage().Update();
end;

procedure TclSMimeBody.SetSource(const Value: TStrings);
begin
  FSource.Assign(Value);
end;

procedure TclSMimeBody.WriteData(Writer: TWriter);
begin
  Writer.WriteString(Source.Text);
  Writer.WriteString(Boundary);
  inherited WriteData(Writer);
end;

end.
