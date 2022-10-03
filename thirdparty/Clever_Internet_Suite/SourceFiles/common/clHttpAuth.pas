{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clHttpAuth;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Contnrs, SysUtils, Windows, SyncObjs,
{$ELSE}
  System.Classes, System.Contnrs, System.SysUtils, Winapi.Windows, System.SyncObjs,
{$ENDIF}
  clUriUtils, clSspiAuth;

type
  //TODO test for multithreading, probably add accessor to all authentication methods
  TclHttpAuthorization = class
  private
    FStartNewConnection: Boolean;
    FAuthValue: string;
  protected
    function GetSupportedAuthMethod(AuthChallenge: TStrings; const AMethod: string): string;
    procedure SetStartNewConnection(Value: Boolean);
    procedure SetAuthValue(const AValue: string);

    procedure DoAuthorize(AUrl: TclUrlParser; const AMethod, AUserName, APassword: string;
      AuthChallenge: TStrings; AContext: TObject); virtual; abstract;
  public
    class function Authorize(AUrl: TclUrlParser; const AMethod, AUserName, APassword: string;
      AuthChallenge: TStrings; AContext: TObject): TclHttpAuthorization;
    class procedure RegisterAuthorization(Authorization: TclHttpAuthorization);
    class function RegisteredAuthorizations: TObjectList;

    property StartNewConnection: Boolean read FStartNewConnection;
    property AuthValue: string read FAuthValue;
  end;

  TclHttpBasicAuthorization = class(TclHttpAuthorization)
  private
    function BuildAuthorizationString(const AUser, APassword: string): string;
  protected
    procedure DoAuthorize(AUrl: TclUrlParser; const AMethod, AUserName, APassword: string;
      AuthChallenge: TStrings; AContext: TObject); override;
  end;

  TclDigestChallenge = class
  private
    FStale: Boolean;
    FRealm: string;
    FAlgorithm: string;
    FQopOptions: string;
    FNonce: string;
    FDomain: string;
    FOpaque: string;
    FNonceCount: Integer;
    FUserName: string;
    FClientNonce: string;
    FResponse: string;
    FUri: string;
    FMethod: string;
    FCharSet: string;
  public
    procedure Parse(const AChallenge: string);
    function BuildAuthorization: string;

    property Realm: string read FRealm write FRealm;
    property Domain: string read FDomain write FDomain;
    property Nonce: string read FNonce write FNonce;
    property Opaque: string read FOpaque write FOpaque;
    property Stale: Boolean read FStale write FStale;
    property Algorithm: string read FAlgorithm write FAlgorithm;
    property QopOptions: string read FQopOptions write FQopOptions;
    property UserName: string read FUserName write FUserName;
    property Uri: string read FUri write FUri;
    property ClientNonce: string read FClientNonce write FClientNonce;
    property NonceCount: Integer read FNonceCount write FNonceCount;
    property Response: string read FResponse write FResponse;
    property Method: string read FMethod write FMethod;
    property CharSet: string read FCharSet write FCharSet;
  end;

  TclHttpDigestAuthorization = class(TclHttpAuthorization)
  private
    function BuildAuthorizationString(AUrl: TclUrlParser; const AMethod, AChallenge,
      AUserName, APassword: string): string;
    function CreateNonce: string;
    function CreateResponse(AChallenge: TclDigestChallenge; const AUserName, APassword: string): string;
    function ComputeData(AChallenge: TclDigestChallenge): string;
    function ComputeSectret(AChallenge: TclDigestChallenge;
      const AUserName, APassword: string): string;
  protected
    procedure DoAuthorize(AUrl: TclUrlParser; const AMethod, AUserName, APassword: string;
      AuthChallenge: TStrings; AContext: TObject); override;
  end;

  TclHttpNtlmAuthorization = class(TclHttpAuthorization)
  private
    FSessions: TStrings;
    FAccessor: TCriticalSection;
    
    function BuildAuthorizationString(ASession: TclNtAuthClientSspi;
      AUrl: TclUrlParser; const APackage, AChallenge, AUserName, APassword: string;
      var ACompleted: Boolean): string;
  protected
    procedure DoAuthorize(AUrl: TclUrlParser; const AMethod, AUserName, APassword: string;
      AuthChallenge: TStrings; AContext: TObject); override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure CloseSessions;
  end;

implementation

uses
  clEncoder, clHeaderFieldList, clCryptHash, clHttpHeader;

var
  RegAuthorizations: TObjectList = nil;

{ TclHttpAuthorization }

class function TclHttpAuthorization.Authorize(AUrl: TclUrlParser; const AMethod, AUserName, APassword: string;
  AuthChallenge: TStrings; AContext: TObject): TclHttpAuthorization;
var
  i: Integer;
begin
  for i := RegisteredAuthorizations().Count - 1 downto 0 do
  begin
    Result := TclHttpAuthorization(RegisteredAuthorizations()[i]);
    Result.DoAuthorize(AUrl, AMethod, AUserName, APassword, AuthChallenge, AContext);

    if (Result.AuthValue <> '') then
    begin
      Exit;
    end;
  end;
  Result := nil;
end;

class procedure TclHttpAuthorization.RegisterAuthorization(Authorization: TclHttpAuthorization);
begin
  RegisteredAuthorizations().Add(Authorization);
end;

class function TclHttpAuthorization.RegisteredAuthorizations: TObjectList;
begin
  if (RegAuthorizations = nil) then
  begin
    RegAuthorizations := TObjectList.Create();
  end;
  Result := RegAuthorizations;
end;

function TclHttpAuthorization.GetSupportedAuthMethod(AuthChallenge: TStrings;
  const AMethod: string): string;
var
  i: Integer;
  s: string;
begin
  s := LowerCase(AMethod);
  for i := 0 to AuthChallenge.Count - 1 do
  begin
    if (system.Pos(s, LowerCase(AuthChallenge[i])) > 0) then
    begin
      Result := AuthChallenge[i];
      Exit;
    end;
  end;
  Result := '';
end;

procedure TclHttpAuthorization.SetAuthValue(const AValue: string);
begin
  FAuthValue := AValue;
end;

procedure TclHttpAuthorization.SetStartNewConnection(Value: Boolean);
begin
  FStartNewConnection := Value;
end;

{ TclHttpBasicAuthorization }

procedure TclHttpBasicAuthorization.DoAuthorize(AUrl: TclUrlParser;
  const AMethod, AUserName, APassword: string; AuthChallenge: TStrings; AContext: TObject);
var
  res: string;
begin
  res := GetSupportedAuthMethod(AuthChallenge, 'basic');
  if (res <> '') then
  begin
    res := BuildAuthorizationString(AUserName, APassword);
  end;
  SetAuthValue(res);
end;

function TclHttpBasicAuthorization.BuildAuthorizationString(const AUser, APassword: string): string;
var
  s: string;
begin
  SetStartNewConnection(True);
  Result := '';

  if (AUser = '') and (APassword = '') then Exit;
  
  s := AUser;
  if (s <> '') then
  begin
    s := s + ':';
  end;
  s := s + APassword;
  Result := TclEncoder.EncodeToString(s, cmBase64);
  Result := 'Basic ' + Result;
end;

{ TclHttpDigestAuthorization }

procedure TclHttpDigestAuthorization.DoAuthorize(AUrl: TclUrlParser;
  const AMethod, AUserName, APassword: string; AuthChallenge: TStrings; AContext: TObject);
var
  res: string;
begin
  res := GetSupportedAuthMethod(AuthChallenge, 'digest');
  if (res <> '') then
  begin
    res := BuildAuthorizationString(AUrl, AMethod, res, AUserName, APassword);
  end;
  SetAuthValue(res);
end;

function TclHttpDigestAuthorization.CreateNonce: string;
var
  y, mm, d, h, m, s, ms: Word;
begin
  DecodeTime(Now(), h, m, s, ms);
  DecodeDate(Date(), y, mm, d);
  Result := IntToHex(mm, 2) + IntToHex(d, 2) + IntToHex(h, 2) + IntToHex(m, 2);
  Result := Result + IntToHex(s, 2) + IntToHex(ms, 4);
  Result := Result + IntToHex(Integer(GetTickCount()), 8) + IntToHex(Integer(GetTickCount()) + 1, 8);
  Result := 'ab' + LowerCase(Result);
end;

function TclHttpDigestAuthorization.ComputeSectret(AChallenge: TclDigestChallenge;
  const AUserName, APassword: string): string;
begin
  Result := '';

  if (AUserName = '') then Exit;

  if (AChallenge.Algorithm = '') or SameText('md5', AChallenge.Algorithm) then
  begin
    Result := AUserName + ':' + AChallenge.Realm + ':' + APassword;
  end else
  if SameText('md5-sess', AChallenge.Algorithm) then
  begin
    Result := AUserName + ':' + AChallenge.Realm + ':' + APassword;
    Result := MD5(Result) + ':' + AChallenge.Nonce + ':' + AChallenge.ClientNonce;
  end;
end;

function TclHttpDigestAuthorization.ComputeData(AChallenge: TclDigestChallenge): string;
var
  options: TStrings;
begin
  Result := AChallenge.Method + ':' + AChallenge.Uri;

  options := TStringList.Create();
  try
    options.Text := StringReplace(LowerCase(AChallenge.QopOptions), ',', #13#10, [rfReplaceAll]);
    if (options.IndexOf('auth') > -1) then
    begin
      AChallenge.QopOptions := 'auth';
    end;
  finally
    options.Free();
  end;
end;

function TclHttpDigestAuthorization.CreateResponse(AChallenge: TclDigestChallenge;
  const AUserName, APassword: string): string;
var
  secret, data: string;
begin
  secret := ComputeSectret(AChallenge, AUserName, APassword);
  data := ComputeData(AChallenge);
  if (secret = '') or (data = '') then
  begin
    Result := '';
    Exit;
  end;

  secret := MD5(secret);
  data := MD5(data);

  Result := AChallenge.Nonce + ':';
  if (AChallenge.QopOptions <> '') then
  begin
    Result := Result + IntToHex(AChallenge.NonceCount, 8) + ':'
      + AChallenge.ClientNonce + ':' + AChallenge.QopOptions + ':';
  end;
  Result := Result + data;
  
  Result := MD5(secret + ':' + Result);
end;

function TclHttpDigestAuthorization.BuildAuthorizationString(AUrl: TclUrlParser;
  const AMethod, AChallenge, AUserName, APassword: string): string;
var
  challenge: TclDigestChallenge;
begin
  Result := '';

  if (AUserName = '') then Exit;

  challenge := TclDigestChallenge.Create();
  try
    challenge.Parse(AChallenge);

    if (challenge.QopOptions <> '') then
    begin
      if (challenge.ClientNonce = '') or challenge.Stale then
      begin
        challenge.ClientNonce := CreateNonce();
        challenge.NonceCount := 1;
      end else
      begin
        challenge.NonceCount := challenge.NonceCount + 1;
      end;
    end;
    challenge.Method := AMethod;
    challenge.UserName := AUserName;
    challenge.Uri := AUrl.AbsolutePath;
    
    //TODO utf-8 support
    challenge.Response := CreateResponse(challenge, AUserName, APassword);

    if (challenge.Response <> '') then
    begin
      Result := challenge.BuildAuthorization();
    end;
  finally
    challenge.Free();
  end;
end;

{ TclDigestChallenge }

function TclDigestChallenge.BuildAuthorization: string;
const
  authField = 'authfield';
var
  fieldList: TclHeaderFieldList;
  src: TStrings;
begin
  fieldList := nil;
  src := nil;
  try
    fieldList := TclHeaderFieldList.Create();
    fieldList.CharsPerLine := 0;
    fieldList.ItemDelimiter := ',';

    src := TStringList.Create();
    fieldList.Parse(0, src);

    fieldList.AddEmptyField(authField);

    fieldList.AddQuotedFieldItem(authField, 'username', UserName);
    fieldList.AddQuotedFieldItem(authField, 'realm', Realm);

    if (QopOptions <> '') then
    begin
      fieldList.AddQuotedFieldItem(authField, 'qop', QopOptions);
      fieldList.AddQuotedFieldItem(authField, 'algorithm', Algorithm);
    end;

    fieldList.AddQuotedFieldItem(authField, 'uri', Uri);
    fieldList.AddQuotedFieldItem(authField, 'nonce', Nonce);

    if (QopOptions <> '') then
    begin
      fieldList.AddFieldItem(authField, 'nc', IntToHex(NonceCount, 8));
      fieldList.AddQuotedFieldItem(authField, 'cnonce', ClientNonce);
    end;

    fieldList.AddQuotedFieldItem(authField, 'opaque', Opaque);
    fieldList.AddQuotedFieldItem(authField, 'response', Response);

    Result := 'Digest ' + fieldList.GetFieldValue(authField);
  finally
    src.Free();
    fieldList.Free();
  end;
end;

procedure TclDigestChallenge.Parse(const AChallenge: string);
var
  s: string;
  fieldList: TclHeaderFieldList;
begin
  fieldList := TclHeaderFieldList.Create();
  try
    FCharSet := fieldList.GetFieldValueItem(AChallenge, 'charset');
    //TODO utf-8 support
    FRealm := fieldList.GetFieldValueItem(AChallenge, 'realm');
    FDomain := fieldList.GetFieldValueItem(AChallenge, 'domain');
    FNonce := fieldList.GetFieldValueItem(AChallenge, 'nonce');
    FOpaque := fieldList.GetFieldValueItem(AChallenge, 'opaque');
    FStale := SameText('true', fieldList.GetFieldValueItem(AChallenge, 'stale'));
    FAlgorithm := fieldList.GetFieldValueItem(AChallenge, 'algorithm');
    FQopOptions := fieldList.GetFieldValueItem(AChallenge, 'qop');
    FUserName := fieldList.GetFieldValueItem(AChallenge, 'username');
    FUri := fieldList.GetFieldValueItem(AChallenge, 'uri');
    FClientNonce := fieldList.GetFieldValueItem(AChallenge, 'cnonce');
    s := fieldList.GetFieldValueItem(AChallenge, 'nc');
    if (s <> '') then
    begin
      s := '$' + s;
    end;
    FNonceCount := StrToIntDef(s, 0);
    FResponse := fieldList.GetFieldValueItem(AChallenge, 'response');
  finally
    fieldList.Free();
  end;
end;

{ TclHttpNtlmAuthorization }

procedure TclHttpNtlmAuthorization.DoAuthorize(AUrl: TclUrlParser;
  const AMethod, AUserName, APassword: string; AuthChallenge: TStrings; AContext: TObject);
var
  ind: Integer;
  sspiSession: TclNtAuthClientSspi;
  completed: Boolean;
  res, package: string;
begin
  package := 'Negotiate';
  res := GetSupportedAuthMethod(AuthChallenge, package);
  if (res = '') then
  begin
    package := 'NTLM';
    res := GetSupportedAuthMethod(AuthChallenge, package);
  end;
  if (res = '') then
  begin
    SetAuthValue('');
    Exit;
  end;

  FAccessor.Enter();
  try
    ind := FSessions.IndexOf(IntToStr(Integer(AContext)));
    if (ind < 0) then
    begin
      sspiSession := TclNtAuthClientSspi.Create();
      FSessions.AddObject(IntToStr(Integer(AContext)), sspiSession);
    end else
    begin
      sspiSession := TclNtAuthClientSspi(FSessions.Objects[ind]);
    end;

    completed := False;
    res := BuildAuthorizationString(sspiSession, AUrl, package, res, AUserName, APassword, completed);
    if completed then
    begin
      sspiSession.Free();
      if (ind < 0) then
      begin
        ind := FSessions.Count - 1;
      end;
      FSessions.Delete(ind);
    end;
  finally
    SetAuthValue(res);
    FAccessor.Leave();
  end;
end;

function TclHttpNtlmAuthorization.BuildAuthorizationString(ASession: TclNtAuthClientSspi;
   AUrl: TclUrlParser; const APackage, AChallenge, AUserName, APassword: string;
   var ACompleted: Boolean): string;
var
  ind: Integer;
  inputChallenge: string;
  encoder: TclEncoder;
  buf: TStream;
  authIdentity: TclAuthIdentity;
begin
  ACompleted := True;
  Result := '';
  inputChallenge := Trim(AChallenge);
  ind := system.Pos(UpperCase(APackage), UpperCase(inputChallenge));

  if (ind <> 1) then Exit;
  inputChallenge := Trim(system.Copy(inputChallenge, Length(APackage) + 1, Length(inputChallenge)));

  SetStartNewConnection(inputChallenge = '');
  
  encoder := nil;
  buf := nil;
  authIdentity := nil;
  try
    encoder := TclEncoder.Create(nil);
    encoder.SuppressCrlf := True;
    encoder.EncodeMethod := cmBase64;
    buf := TMemoryStream.Create();

    encoder.Decode(inputChallenge, buf);
    buf.Position := 0;

    if (AUserName <> '') then
    begin
      authIdentity := TclAuthIdentity.Create(AUserName, APassword);
    end;

    ACompleted := ASession.GenChallenge(APackage, buf, 'HTTP/' + AUrl.Host, authIdentity);

    buf.Position := 0;
    Result := encoder.Encode(buf);
    Result := APackage + ' ' + Result;
  finally
    authIdentity.Free();
    buf.Free();
    encoder.Free();
  end;
end;

constructor TclHttpNtlmAuthorization.Create;
begin
  inherited Create();
  FAccessor := TCriticalSection.Create();
  FSessions := TStringList.Create();
end;

destructor TclHttpNtlmAuthorization.Destroy;
begin
  CloseSessions();
  FSessions.Free();
  FAccessor.Free();
  inherited Destroy();
end;

procedure TclHttpNtlmAuthorization.CloseSessions;
var
  i: Integer;
begin
  FAccessor.Enter();
  try
    for i := FSessions.Count - 1 downto 0 do
    begin
      FSessions.Objects[i].Free();
    end;
    FSessions.Clear();
  finally
    FAccessor.Leave();
  end;
end;

initialization
  TclHttpAuthorization.RegisterAuthorization(TclHttpBasicAuthorization.Create());
  TclHttpAuthorization.RegisterAuthorization(TclHttpDigestAuthorization.Create());
  TclHttpAuthorization.RegisterAuthorization(TclHttpNtlmAuthorization.Create());

finalization
  RegAuthorizations.Free();

end.
