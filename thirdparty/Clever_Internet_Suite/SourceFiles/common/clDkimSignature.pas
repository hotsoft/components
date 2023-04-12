{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clDkimSignature;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Contnrs, DateUtils,
{$ELSE}
  System.Classes, System.SysUtils, System.Contnrs, System.DateUtils,
{$ENDIF}
  clHeaderFieldList;

type
  TclDkimVerifyStatus = (dssNone, dssVerified, dssFailed);

  TclDkimSignatureVerifyStatus = class
  private
    FErrorText: string;
    FStatus: TclDkimVerifyStatus;
    FErrorCode: Integer;

    procedure SetStatus(AStatus: TclDkimVerifyStatus; const AErrorText: string; AErrorCode: Integer);
  public
    constructor Create;

    procedure Clear;
    procedure SetVerified;
    procedure SetFailed(const AErrorText: string; AErrorCode: Integer);

    property Status: TclDkimVerifyStatus read FStatus;
    property ErrorCode: Integer read FErrorCode;
    property ErrorText: string read FErrorText;
  end;

  TclDkimSignature = class
  private
    FVersion: Integer;
    FSignatureTimestamp: TDateTime;
    FDomain: string;
    FUserIdentity: string;
    FBodyLength: Integer;
    FBodyHash: string;
    FPublicKeyLocation: string;
    FSignatureAlgorithm: string;
    FCopiedHeaderFields: TStrings;
    FSignature: string;
    FSignatureExpiration: TDateTime;
    FSignedHeaderFields: TStrings;
    FCanonicalization: string;
    FSelector: string;
    FStatus: TclDkimSignatureVerifyStatus;

    procedure Add(AFieldList: TclHeaderFieldList; const AName, AValue: string);
    procedure AddVersion(AFieldList: TclHeaderFieldList);
    procedure AddNotNull(AFieldList: TclHeaderFieldList; const AName, AValue: string);
    procedure AddBodyLength(AFieldList: TclHeaderFieldList);
    procedure AddDate(AFieldList: TclHeaderFieldList; const AName: string; AValue: TDateTime);

    procedure CheckTimestamp;
    function GetDomain: string;
    function GetUserIdentity: string;
    function GetCopiedHeaderFields: string;
    function GetSignedHeaderFields: string;

    function ParseVersion(const AValue: string): Integer;
    function ParseBodyLength(const AValue: string): Integer;
    function ParseDate(const AValue: string): TDateTime;
    function ParseNotNull(const AValue: string): string;
    procedure ParseCopiedHeaderFields(const AValue: string);
    procedure ParseSignedHeaderFields(const AValue: string);
    procedure SetCopiedHeaderFields(const Value: TStrings);
    procedure SetSignedHeaderFields(const Value: TStrings);
    function GetCanonicalization(IsHeader: Boolean): string;
    function GetHashAlgorithm: string;
    function GetBodyCanonicalization: string;
    function GetHeaderCanonicalization: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Parse(AMessage: TStrings); overload;
    procedure Parse(const ADkimSignatureField: string); overload; virtual;
    procedure Build(AMessage: TStrings; ACharsPerLine: Integer); virtual;
    procedure AssignSignature(AMessage: TStrings; ACharsPerLine: Integer); virtual;
    procedure Clear; virtual;

    property Status: TclDkimSignatureVerifyStatus read FStatus;

    property Version: Integer read FVersion write FVersion;

    property SignatureAlgorithm: string read FSignatureAlgorithm write FSignatureAlgorithm;
    property Canonicalization: string read FCanonicalization write FCanonicalization;
    property Domain: string read FDomain write FDomain;
    property Selector: string read FSelector write FSelector;
    property SignedHeaderFields: TStrings read FSignedHeaderFields write SetSignedHeaderFields;

    property BodyLength: Integer read FBodyLength write FBodyLength;
    property UserIdentity: string read FUserIdentity write FUserIdentity;
    property PublicKeyLocation: string read FPublicKeyLocation write FPublicKeyLocation;
    property SignatureTimestamp: TDateTime read FSignatureTimestamp write FSignatureTimestamp;
    property SignatureExpiration: TDateTime read FSignatureExpiration write FSignatureExpiration;
    property CopiedHeaderFields: TStrings read FCopiedHeaderFields write SetCopiedHeaderFields;

    property Signature: string read FSignature write FSignature;
    property BodyHash: string read FBodyHash write FBodyHash;

    property HeaderCanonicalization: string read GetHeaderCanonicalization;
    property BodyCanonicalization: string read GetBodyCanonicalization;
    property HashAlgorithm: string read GetHashAlgorithm;
  end;

  TclDkimSignatureList = class
  private
    FList: TObjectList;

    function GetCount: Integer;
    function GetItem(Index: Integer): TclDkimSignature;
  public
    constructor Create;
    destructor Destroy; override;

    function Add(AItem: TclDkimSignature): TclDkimSignature;
    procedure Delete(Index: Integer);
    procedure Clear;

    property Items[Index: Integer]: TclDkimSignature read GetItem; default;
    property Count: Integer read GetCount;
  end;

const
  cDkimSignatureField = 'DKIM-Signature';

implementation

uses
  clUtils, clWUtils, clDkimUtils, clMailUtils, clIdnTranslator;

{ TclDkimSignature }

procedure TclDkimSignature.AddVersion(AFieldList: TclHeaderFieldList);
begin
  if (Version < 0) then
  begin
    raise EclDkimError.Create(DkimInvalidSignatureParameters, DkimInvalidSignatureParametersCode);
  end;
  Add(AFieldList, 'v', IntToStr(Version));
end;

procedure TclDkimSignature.AssignSignature(AMessage: TStrings; ACharsPerLine: Integer);
var
  fieldList: TclDkimHeaderFieldList;
begin
  if (Trim(Signature) = '') then
  begin
    raise EclDkimError.Create(DkimInvalidSignatureParameters, DkimInvalidSignatureParametersCode);
  end;

  fieldList := TclDkimHeaderFieldList.Create();
  try
    fieldList.CharsPerLine := ACharsPerLine;
    fieldList.Parse(0, AMessage);
    fieldList.RemoveFieldItem(cDkimSignatureField, 'b');
    fieldList.AddFieldItem(cDkimSignatureField, 'b', Signature, True);
  finally
    fieldList.Free();
  end;
end;

procedure TclDkimSignature.AddNotNull(AFieldList: TclHeaderFieldList; const AName, AValue: string);
begin
  if (Trim(AValue) = '') then
  begin
    raise EclDkimError.Create(DkimInvalidSignatureParameters, DkimInvalidSignatureParametersCode);
  end;
  Add(AFieldList, AName, AValue);
end;

procedure TclDkimSignature.Add(AFieldList: TclHeaderFieldList; const AName, AValue: string);
begin
  AFieldList.AddFieldItem(cDkimSignatureField, AName, AValue);
end;

procedure TclDkimSignature.AddBodyLength(AFieldList: TclHeaderFieldList);
begin
  if (BodyLength > 0) then
  begin
    Add(AFieldList, 'l', IntToStr(BodyLength));
  end;
end;

procedure TclDkimSignature.AddDate(AFieldList: TclHeaderFieldList; const AName: string; AValue: TDateTime);
var
  d: TDateTime;
  sec: Int64;
begin
  if (AValue > 0) then
  begin
    d := LocalTimeToGlobalTime(AValue);
    sec := SecondsBetween(d, EncodeDate(1970, 1, 1));
    Add(AFieldList, AName, IntToStr(sec));
  end;
end;

procedure TclDkimSignature.CheckTimestamp;
begin
  if (SignatureTimestamp > 0) and (SignatureExpiration > 0) and (SignatureTimestamp >= SignatureExpiration) then
  begin
    raise EclDkimError.Create(DkimInvalidSignatureParameters, DkimInvalidSignatureParametersCode);
  end;
end;

function TclDkimSignature.GetDomain: string;
begin
  Result := Domain;

  if (Trim(Result) <> '') then
  begin
    Result := TclIdnTranslator.GetAscii(Result);
  end;
end;

function TclDkimSignature.GetHashAlgorithm: string;
begin
  if (WordCount(SignatureAlgorithm, ['-']) <> 2) then
  begin
    raise EclDkimError.Create(DkimInvalidSignatureAlgorihm, DkimInvalidSignatureAlgorihmCode);
  end;
  Result := ExtractWord(2, SignatureAlgorithm, ['-']);
end;

function TclDkimSignature.GetHeaderCanonicalization: string;
begin
  Result := GetCanonicalization(True);
end;

function TclDkimSignature.GetUserIdentity: string;
begin
  Result := UserIdentity;

  if (Trim(Result) <> '') then
  begin
    Result := TclDkimQuotedPrintableEncoder.Encode(GetIdnEmail(Result));
  end;
end;

function TclDkimSignature.GetBodyCanonicalization: string;
begin
  Result := GetCanonicalization(False);
end;

function TclDkimSignature.GetCanonicalization(IsHeader: Boolean): string;
const
  section: array[Boolean] of Integer = (2, 1);
begin
  Result := 'simple';

  case WordCount(Canonicalization, ['/']) of
    1: Result := Canonicalization;
    2: Result := ExtractWord(section[IsHeader], Canonicalization, ['/']);
  end;
end;

function TclDkimSignature.GetCopiedHeaderFields: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to CopiedHeaderFields.Count - 1 do
  begin
    if not ((CopiedHeaderFields[i] <> '') and CharInSet(CopiedHeaderFields[i][1], [#9, #32])) then
    begin
      Result := Result + '|';
    end else
    begin
      Result := Result + #13#10;
    end;
    Result := Result + CopiedHeaderFields[i];
  end;
  if (Length(Result) > 0) then
  begin
    System.Delete(Result, 1, 1);
  end;

  if (Trim(Result) <> '') then
  begin
    Result := TclDkimQuotedPrintableEncoder.Encode(Result);
  end;
end;

procedure TclDkimSignature.Build(AMessage: TStrings; ACharsPerLine: Integer);
var
  fieldList: TclDkimHeaderFieldList;
begin
  fieldList := TclDkimHeaderFieldList.Create();
  try
    fieldList.CharsPerLine := ACharsPerLine;
    fieldList.Parse(0, AMessage);

    fieldList.InsertEmptyField(0, cDkimSignatureField);

    AddVersion(fieldList);

    AddNotNull(fieldList, 'a', SignatureAlgorithm);
    AddNotNull(fieldList, 'd', GetDomain());
    AddNotNull(fieldList, 's', Selector);
    Add(fieldList, 'c', Canonicalization);
    AddBodyLength(fieldList);
    Add(fieldList, 'q', PublicKeyLocation);
    Add(fieldList, 'i', GetUserIdentity());

    CheckTimestamp();

    AddDate(fieldList, 't', SignatureTimestamp);
    AddDate(fieldList, 'x', SignatureExpiration);

    AddNotNull(fieldList, 'h', GetSignedHeaderFields());
    Add(fieldList, 'z', GetCopiedHeaderFields());
    AddNotNull(fieldList, 'bh', BodyHash);

    fieldList.AddEmptyFieldItem(cDkimSignatureField, 'b', True);
  finally
    fieldList.Free();
  end;
end;

procedure TclDkimSignature.Clear;
begin
  FVersion := 0;

  FSignatureAlgorithm := '';
  FCanonicalization := '';
  FDomain := '';
  FSelector := '';
  FSignedHeaderFields.Clear();

  FBodyLength := 0;
  FUserIdentity := '';
  FPublicKeyLocation := '';
  FSignatureTimestamp := 0;
  FSignatureExpiration := 0;
  FCopiedHeaderFields.Clear();

  FSignature := '';
  FBodyHash := '';

  FStatus.Clear();
end;

constructor TclDkimSignature.Create;
begin
  inherited Create();

  FSignedHeaderFields := TStringList.Create();
  FCopiedHeaderFields := TStringList.Create();
  FStatus := TclDkimSignatureVerifyStatus.Create();

  Clear();
end;

destructor TclDkimSignature.Destroy;
begin
  FStatus.Free();
  FCopiedHeaderFields.Free();
  FSignedHeaderFields.Free();

  inherited Destroy();
end;

function TclDkimSignature.ParseVersion(const AValue: string): Integer;
begin
  Result := StrToIntDef(Trim(AValue), 0);
  if (Result = 0) then
  begin
    raise EclDkimError.Create(DkimInvalidFormat, DkimInvalidFormatCode);
  end;
end;

procedure TclDkimSignature.SetCopiedHeaderFields(const Value: TStrings);
begin
  FCopiedHeaderFields.Assign(Value);
end;

procedure TclDkimSignature.SetSignedHeaderFields(const Value: TStrings);
begin
  FSignedHeaderFields.Assign(Value);
end;

function TclDkimSignature.ParseNotNull(const AValue: string): string;
begin
  Result := Trim(AValue);
  if (Result = '') then
  begin
    raise EclDkimError.Create(DkimInvalidFormat, DkimInvalidFormatCode);
  end;
end;

function TclDkimSignature.GetSignedHeaderFields: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to SignedHeaderFields.Count - 1 do
  begin
    Result := Result + SignedHeaderFields[i] + ':';
  end;
  if (Length(Result) > 0) then
  begin
    System.Delete(Result, Length(Result), 1);
  end;
end;

function TclDkimSignature.ParseBodyLength(const AValue: string): Integer;
begin
  if (Trim(AValue) = '') then
  begin
    Result := 0;
    Exit;
  end;

  Result := StrToIntDef(Trim(AValue), -1);
  if (Result < 0) then
  begin
    raise EclDkimError.Create(DkimInvalidFormat, DkimInvalidFormatCode);
  end;
end;

function TclDkimSignature.ParseDate(const AValue: string): TDateTime;
var
  s: string;
  d: Int64;
begin
  Result := 0;

  s := Trim(AValue);
  if (s = '') then Exit;

  d := StrToInt64Def(System.Copy(s, 1, 12), 0);
  if (d = 0) then Exit;

  Result := IncSecond(EncodeDate(1970, 1, 1), d);
  Result := GlobalTimeToLocalTime(Result);
end;

procedure TclDkimSignature.ParseCopiedHeaderFields(const AValue: string);
var
  list: TStrings;
  i: Integer;
begin
  CopiedHeaderFields.Clear();

  list := TStringList.Create();
  try
    SplitText(AValue, list, '|');

    for i := 0 to list.Count - 1 do
    begin
      AddTextStr(CopiedHeaderFields, TclDkimQuotedPrintableEncoder.Decode(list[i]));
    end;
  finally
    list.Free();
  end;
end;

procedure TclDkimSignature.ParseSignedHeaderFields(const AValue: string);
begin
  SplitText(ParseNotNull(AValue), SignedHeaderFields, ':');
end;

procedure TclDkimSignature.Parse(AMessage: TStrings);
var
  fieldList: TclHeaderFieldList;
begin
  fieldList := TclDkimHeaderFieldList.Create();
  try
    fieldList.Parse(0, AMessage);
    Parse(fieldList.GetFieldValue(cDkimSignatureField));
  finally
    fieldList.Free();
  end;
end;

procedure TclDkimSignature.Parse(const ADkimSignatureField: string);
var
  fieldList: TclHeaderFieldList;
begin
  fieldList := TclDkimHeaderFieldList.Create();
  try
    FVersion := ParseVersion(fieldList.GetFieldValueItem(ADkimSignatureField, 'v'));

    FSignatureAlgorithm := ParseNotNull(fieldList.GetFieldValueItem(ADkimSignatureField, 'a'));
    FCanonicalization := fieldList.GetFieldValueItem(ADkimSignatureField, 'c');
    FDomain := ParseNotNull(fieldList.GetFieldValueItem(ADkimSignatureField, 'd'));
    FSelector := ParseNotNull(fieldList.GetFieldValueItem(ADkimSignatureField, 's'));
    ParseSignedHeaderFields(fieldList.GetFieldValueItem(ADkimSignatureField, 'h'));

    FBodyLength := ParseBodyLength(fieldList.GetFieldValueItem(ADkimSignatureField, 'l'));
    FUserIdentity := TclDkimQuotedPrintableEncoder.Decode(fieldList.GetFieldValueItem(ADkimSignatureField, 'i'));
    FPublicKeyLocation := fieldList.GetFieldValueItem(ADkimSignatureField, 'q');
    FSignatureTimestamp := ParseDate(fieldList.GetFieldValueItem(ADkimSignatureField, 't'));
    FSignatureExpiration := ParseDate(fieldList.GetFieldValueItem(ADkimSignatureField, 'x'));
    ParseCopiedHeaderFields(fieldList.GetFieldValueItem(ADkimSignatureField, 'z'));

    FSignature := fieldList.GetFieldValueItem(ADkimSignatureField, 'b');
    FBodyHash := fieldList.GetFieldValueItem(ADkimSignatureField, 'bh');
  finally
    fieldList.Free();
  end;
end;

{ TclDkimSignatureList }

function TclDkimSignatureList.Add(AItem: TclDkimSignature): TclDkimSignature;
begin
  FList.Add(AItem);
  Result := AItem;
end;

procedure TclDkimSignatureList.Clear;
begin
  FList.Clear();
end;

constructor TclDkimSignatureList.Create;
begin
  inherited Create();
  FList := TObjectList.Create(True);
end;

procedure TclDkimSignatureList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TclDkimSignatureList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function TclDkimSignatureList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclDkimSignatureList.GetItem(Index: Integer): TclDkimSignature;
begin
  Result := TclDkimSignature(FList[Index]);
end;

{ TclDkimSignatureVerifyStatus }

procedure TclDkimSignatureVerifyStatus.Clear;
begin
  SetStatus(dssNone, '', 0);
end;

constructor TclDkimSignatureVerifyStatus.Create;
begin
  inherited Create();
  Clear();
end;

procedure TclDkimSignatureVerifyStatus.SetVerified;
begin
  SetStatus(dssVerified, '', 0);
end;

procedure TclDkimSignatureVerifyStatus.SetFailed(const AErrorText: string; AErrorCode: Integer);
begin
  SetStatus(dssFailed, AErrorText, AErrorCode);
end;

procedure TclDkimSignatureVerifyStatus.SetStatus(AStatus: TclDkimVerifyStatus;
  const AErrorText: string; AErrorCode: Integer);
begin
  FStatus := AStatus;
  FErrorText := AErrorText;
  FErrorCode := AErrorCode;
end;

end.
