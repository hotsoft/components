{
  Clever Internet Suite
  Copyright (C) 2017 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCryptEncoder;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clUtils, clConfig, clCryptDataHeader;

type
  TclCryptDataType = (dtNone,
    dtPemFormat, dtRsaPrivateKey, dtRsaPublicKey, dtPublicKeyInfo, dtCertificate, dtCertificateRequest, dtNewCertificateRequest,
    dtSsh2Format, dtSsh2EncryptedPrivateKey, dtSsh2PrivateKey, dtSsh2PublicKey);

  TclCryptEncoder = class(TComponent)
  private
    FConfig: TclConfig;
    FHeader: TclCryptDataHeader;
    FDataType: TclCryptDataType;
    FDataTypeName: string;
    FCharsPerLine: Integer;
    FPassPhrase: string;

    procedure SetDataType(const Value: TclCryptDataType);
    procedure SetDataTypeName(const Value: string);
    procedure SetHeader(const Value: TclCryptDataHeader);
    function GetEncodingFormat: TclCryptEncodingFormat;
    function GetDefaultCharsPerLine(AEncodingFormat: TclCryptEncodingFormat): Integer;

    function ExtractEncodingFormat(ASource: string): TclCryptEncodingFormat;
    function ExtractDataType(const ASource: string; AEncodingFormat: TclCryptEncodingFormat): TclCryptDataType;
    function ExtractDataTypeName(const ASource: string; ADataType: TclCryptDataType): string;
    procedure ParseDataType(const ASource: string);
    function GetHeaderBegin: string;
    function GetHeaderEnd: string;
    function DecryptData(const ASource: TclByteArray): TclByteArray;
    function EncryptData(const ASource: TclByteArray): TclByteArray;
  protected
    function CreateConfig: TclConfig; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function EncodeToBytes(const ASource: TclByteArray; ADataType: TclCryptDataType): TclByteArray; overload;
    class function DecodeBytes(const ASource: TclByteArray): TclByteArray;

    class function EncodeToString(const ASource: TclByteArray; ADataType: TclCryptDataType): string;
    class function DecodeString(const ASource: string): TclByteArray;

    procedure Clear;

    procedure EncodeToFile(const ASource: TclByteArray; const ADestinationFile: string);
    function DecodeFile(const ASourceFile: string): TclByteArray;

    procedure Encode(const ASource: TclByteArray; ADestination: TStream); overload;
    function Decode(ASource: TStream): TclByteArray; overload;

    function EncodeToBytes(const ASource: TclByteArray): TclByteArray; overload;
    function Decode(const ASource: TclByteArray): TclByteArray; overload;

    function Encode(const ASource: TclByteArray): string; overload;
    function Decode(const ASource: string): TclByteArray; overload;

    property EncodingFormat: TclCryptEncodingFormat read GetEncodingFormat;
    property Config: TclConfig read FConfig;
  published
    property CharsPerLine: Integer read FCharsPerLine write FCharsPerLine default 64;

    property DataType: TclCryptDataType read FDataType write SetDataType default dtNone;
    property DataTypeName: string read FDataTypeName write SetDataTypeName;
    property Header: TclCryptDataHeader read FHeader write SetHeader;

    property PassPhrase: string read FPassPhrase write FPassPhrase;
  end;

  TclCryptEncoderConfig = class(TclConfig)
  public
    constructor Create;
  end;

implementation

uses
  clTranslator, clEncoder, clHeaderFieldList, clCryptUtils, clCryptHash, clCryptCipher, clCryptPemEncryptor;

const
  DefaultCharsPerLine = 64;

  CRLF = #13#10;
  BEGINLexem = 'BEGIN ';
  ENDLexem = 'END ';

  PemHeaderPrefix = '-----';
  PemHeaderPostfix = '-----';

  Ssh2HeaderPrefix = '---- ';
  Ssh2HeaderPostfix = ' ----';

  HeaderPrefix: array[TclCryptEncodingFormat] of string = ('', PemHeaderPrefix, Ssh2HeaderPrefix);

  HeaderPostfix: array[TclCryptEncodingFormat] of string = ('', PemHeaderPostfix, Ssh2HeaderPostfix);
  
  DataHeader: array[TclCryptDataType] of string =
    ('',
     '', 'RSA PRIVATE KEY', 'RSA PUBLIC KEY', 'PUBLIC KEY', 'CERTIFICATE', 'CERTIFICATE REQUEST', 'NEW CERTIFICATE REQUEST',
     '', 'SSH2 ENCRYPTED PRIVATE KEY', 'SSH2 PRIVATE KEY', 'SSH2 PUBLIC KEY');

  DataEncoding: array[TclCryptDataType] of TclCryptEncodingFormat = 
    (efNone,
     efPem, efPem, efPem, efPem, efPem, efPem, efPem,
     efSsh2, efSsh2, efSsh2, efSsh2);

{ TclCryptEncoder }

class function TclCryptEncoder.DecodeBytes(const ASource: TclByteArray): TclByteArray;
var
  encoder: TclCryptEncoder;
begin
  encoder := TclCryptEncoder.Create(nil);
  try
    Result := encoder.Decode(ASource);
  finally
    encoder.Free();
  end;
end;

class function TclCryptEncoder.DecodeString(const ASource: string): TclByteArray;
var
  encoder: TclCryptEncoder;
begin
  encoder := TclCryptEncoder.Create(nil);
  try
    Result := encoder.Decode(ASource);
  finally
    encoder.Free();
  end;
end;

class function TclCryptEncoder.EncodeToBytes(const ASource: TclByteArray;
  ADataType: TclCryptDataType): TclByteArray;
var
  encoder: TclCryptEncoder;
begin
  encoder := TclCryptEncoder.Create(nil);
  try
    encoder.DataType := ADataType;
    Result := encoder.EncodeToBytes(ASource);
  finally
    encoder.Free();
  end;
end;

class function TclCryptEncoder.EncodeToString(const ASource: TclByteArray; ADataType: TclCryptDataType): string;
var
  encoder: TclCryptEncoder;
begin
  encoder := TclCryptEncoder.Create(nil);
  try
    encoder.DataType := ADataType;
    Result := encoder.Encode(ASource);
  finally
    encoder.Free();
  end;
end;

function TclCryptEncoder.ExtractEncodingFormat(ASource: string): TclCryptEncodingFormat;
begin
  if (System.Pos(PemHeaderPrefix + BEGINLexem, ASource) > 0) then
  begin
    Result := efPem;
  end else
  if (System.Pos(Ssh2HeaderPrefix + BEGINLexem, ASource) > 0) then
  begin
    Result := efSsh2;
  end else
  begin
    Result := efNone;
  end;
end;

function TclCryptEncoder.ExtractDataType(const ASource: string; AEncodingFormat: TclCryptEncodingFormat): TclCryptDataType;
var
  i: TclCryptDataType;
  ind: Integer;
  prefix, postfix: string;
begin
  prefix := HeaderPrefix[AEncodingFormat];
  postfix := HeaderPostfix[AEncodingFormat];

  for i := Low(TclCryptDataType) to High(TclCryptDataType) do
  begin
    ind := System.Pos(prefix + BEGINLexem + DataHeader[i] + postfix, ASource);
    if (ind > 0) and (System.Pos(prefix + ENDLexem + DataHeader[i] + postfix, ASource) > ind) then
    begin
      Result := i;
      Exit;
    end;
  end;

  if (AEncodingFormat = efPem) then
  begin
    Result := dtPemFormat;
  end else
  if (AEncodingFormat = efSsh2) then
  begin
    Result := dtSsh2Format;
  end else
  begin
    Result := dtNone;
  end;
end;

function TclCryptEncoder.ExtractDataTypeName(const ASource: string; ADataType: TclCryptDataType): string;
var
  indPrefix, indPostfix, prefixLen: Integer;
  name, prefix, postfix: string;
begin
  Result := '';

  prefix := HeaderPrefix[DataEncoding[ADataType]];
  postfix := HeaderPostfix[DataEncoding[ADataType]];

  indPrefix := TextPos(prefix + BEGINLexem, ASource);
  if (indPrefix > 0) then
  begin
    prefixLen := Length(prefix + BEGINLexem);

    indPostfix := TextPos(postfix, ASource, indPrefix + prefixLen);
    if (indPrefix < indPostfix) then
    begin
      name := System.Copy(ASource, indPrefix + prefixLen, indPostfix - indPrefix - prefixLen);

      if (System.Pos(prefix + ENDLexem + name + postfix, ASource) > 0) then
      begin
        Result := name;
      end;
    end;
  end;
end;

procedure TclCryptEncoder.ParseDataType(const ASource: string);
var
  encodingFormat: TclCryptEncodingFormat;
begin
  Clear();

  encodingFormat := ExtractEncodingFormat(ASource);
  if (encodingFormat <> efNone) then
  begin
    FDataType := ExtractDataType(ASource, encodingFormat);
  end;

  FDataTypeName := DataHeader[FDataType];
  if ((FDataType <> dtNone) and (FDataTypeName = '')) then
  begin
    FDataTypeName := ExtractDataTypeName(ASource, FDataType);
  end;

  if (FDataTypeName = '') then
  begin
    FDataType := dtNone;
  end;

  FCharsPerLine := GetDefaultCharsPerLine(encodingFormat);
end;

function TclCryptEncoder.GetDefaultCharsPerLine(AEncodingFormat: TclCryptEncodingFormat): Integer;
begin
  if (AEncodingFormat = efPem) then
  begin
    Result := 64;
  end else
  if (AEncodingFormat = efSsh2) then
  begin
    Result := 72;
  end else
  begin
    Result := DefaultCharsPerLine;
  end;
end;

function TclCryptEncoder.GetEncodingFormat: TclCryptEncodingFormat;
begin
  Result := DataEncoding[DataType];
end;

function TclCryptEncoder.GetHeaderBegin: string;
begin
  Result := HeaderPrefix[EncodingFormat] + BEGINLexem + DataTypeName + HeaderPostfix[EncodingFormat];
end;

function TclCryptEncoder.GetHeaderEnd: string;
begin
  Result := HeaderPrefix[EncodingFormat] + ENDLexem + DataTypeName + HeaderPostfix[EncodingFormat];
end;

procedure TclCryptEncoder.Clear;
begin
  FDataType := dtNone;
  FDataTypeName := '';
  FHeader.Clear();
  FCharsPerLine := GetDefaultCharsPerLine(EncodingFormat);
end;

constructor TclCryptEncoder.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FConfig := CreateConfig();
  FHeader := TclCryptDataHeader.Create();
  Clear();
  FCharsPerLine := DefaultCharsPerLine;
end;

function TclCryptEncoder.CreateConfig: TclConfig;
begin
  Result := TclCryptEncoderConfig.Create();
end;

function TclCryptEncoder.DecodeFile(const ASourceFile: string): TclByteArray;
var
  src: TStream;
begin
{$IFNDEF DELPHI2005}Result := nil;{$ENDIF}
  src := TFileStream.Create(ASourceFile, fmOpenRead or fmShareDenyWrite);
  try
    Result := Decode(src);
  finally
    src.Free();
  end;
end;

function TclCryptEncoder.Decode(ASource: TStream): TclByteArray;
var
  buf: TclByteArray;
  len: Integer;
begin
  len := ASource.Size - ASource.Position;
  SetLength(buf, len);
  ASource.Read(buf[0], len);
  Result := Decode(buf);
end;

function TclCryptEncoder.Decode(const ASource: TclByteArray): TclByteArray;
var
  s: string;
begin
  s := TclTranslator.GetString(ASource);
  ParseDataType(s);
  if (DataType = dtNone) then
  begin
    Result := ASource;
  end else
  begin
    Result := Decode(s);
  end;
end;

function TclCryptEncoder.DecryptData(const ASource: TclByteArray): TclByteArray;
var
  encryptor: TclRsaKeyPemEncryptor;
begin
  Result := ASource;

  if (PassPhrase <> '') and (DataType = dtRsaPrivateKey) then
  begin
    encryptor := TclRsaKeyPemEncryptor.Create(FConfig);
    try
      Result := encryptor.Decrypt(Header, ASource, PassPhrase);
    finally
      encryptor.Free();
    end;
  end else
  if (PassPhrase <> '') and (DataType = dtSsh2EncryptedPrivateKey) then
  begin
    RaiseCryptError('The SSH key decryption is not implemented', -1);
  end;
end;

function TclCryptEncoder.Decode(const ASource: string): TclByteArray;
var
  ind: Integer;
  data, sigBegin, sigEnd: string;
begin
  ParseDataType(ASource);

  if (DataType = dtNone) then
  begin
    Result := TclTranslator.GetBytes(ASource);
    Exit;
  end;

  sigBegin := GetHeaderBegin();
  sigEnd := GetHeaderEnd();

  data := ASource;

  ind := TextPos(sigBegin, data, 1);
  System.Delete(data, 1, ind - 1 + Length(sigBegin));

  ind := TextPos(sigEnd, data, 1);
  Delete(data, ind, Length(data));

  data := Header.Parse(data, EncodingFormat);

  Result := TclEncoder.DecodeBytes(data, cmBase64);

  Result := DecryptData(Result);
end;

destructor TclCryptEncoder.Destroy;
begin
  FHeader.Free();
  FConfig.Free();

  inherited Destroy();
end;

procedure TclCryptEncoder.EncodeToFile(const ASource: TclByteArray; const ADestinationFile: string);
var
  dst: TStream;
begin
  dst := TFileStream.Create(ADestinationFile, fmCreate);
  try
    Encode(ASource, dst);
  finally
    dst.Free();
  end;
end;

procedure TclCryptEncoder.Encode(const ASource: TclByteArray; ADestination: TStream);
var
  buf: TclByteArray;
begin
  buf := EncodeToBytes(ASource);
  if (buf <> nil) and (Length(buf) > 0) then
  begin
    ADestination.Write(buf[0], Length(buf));
  end;
end;

function TclCryptEncoder.EncodeToBytes(const ASource: TclByteArray): TclByteArray;
begin
  Result := TclTranslator.GetBytes(Encode(ASource), '');
end;

function TclCryptEncoder.EncryptData(const ASource: TclByteArray): TclByteArray;
begin
  Result := ASource;

  if (PassPhrase <> '') and (DataType = dtRsaPrivateKey) then
  begin
    RaiseCryptError('The key encryption is not implemented', -1);
  end else
  if (PassPhrase <> '') and (DataType = dtSsh2EncryptedPrivateKey) then
  begin
    RaiseCryptError('The key encryption is not implemented', -1);
  end;
end;

function TclCryptEncoder.Encode(const ASource: TclByteArray): string;
var
  encoder: TclEncoder;
  data: TclByteArray;
begin
{$IFNDEF DELPHI2005}data := nil;{$ENDIF}
  if (DataType = dtNone) then
  begin
    Result := TclTranslator.GetString(ASource, '');
  end else
  begin
    data := EncryptData(ASource);

    encoder := TclEncoder.Create(nil);
    try
      encoder.CharsPerLine := CharsPerLine;
      encoder.EncodeMethod := cmBase64;

      Result := Header.Build(EncodingFormat, CharsPerLine);

      Result := Result + encoder.EncodeBytes(data);

      if (RTextPos(CRLF, Result) <> Length(Result) - 1) then
      begin
        Result := Result + CRLF;
      end;
      Result :=
        GetHeaderBegin() + CRLF +
        Result +
        GetHeaderEnd() + CRLF;
    finally
      encoder.Free();
    end;
  end;
end;

procedure TclCryptEncoder.SetDataType(const Value: TclCryptDataType);
begin
  FDataType := Value;
  if not (csLoading in ComponentState) then
  begin
    FDataTypeName := DataHeader[FDataType];
    FCharsPerLine := GetDefaultCharsPerLine(EncodingFormat);
  end;
end;

procedure TclCryptEncoder.SetDataTypeName(const Value: string);
begin
  FDataTypeName := Value;
  if not (csLoading in ComponentState) then
  begin
    FDataType := dtNone;
    FCharsPerLine := GetDefaultCharsPerLine(EncodingFormat);
  end;
end;

procedure TclCryptEncoder.SetHeader(const Value: TclCryptDataHeader);
begin
  FHeader.Assign(Value);
end;

{ TclCryptEncoderConfig }

constructor TclCryptEncoderConfig.Create;
begin
  inherited Create();

  SetType('md5', TclMd5);
  SetType('3des-cbc', TclTripleDesCbc);
end;

end.
