{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCookieManager;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SyncObjs,
{$ELSE}
  System.Classes, System.SyncObjs,
{$ENDIF}
  clHeaderFieldList, clWUtils;

type
  TclCookieFormat = (cfNetscape, cfRFC2109, cfRFC2965);

  TclCookieItem = class(TCollectionItem)
  private
    FSecure: Boolean;
    FValue: string;
    FExpires: TDateTime;
    FName: string;
    FDomain: string;
    FPath: string;
    FCookieData: string;
    FDiscard: Boolean;
    FMaxAge: Int64;
    FVersion: Integer;
    FPort: string;
    FCommentURL: string;
    FComment: string;
    FFormat: TclCookieFormat;
    
    procedure SetMaxAge(const Value: Int64);
    function GetIsPersistent: Boolean;
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    procedure Load(AStream: TStream); virtual;
    procedure Save(AStream: TStream); virtual;

    property Format: TclCookieFormat read FFormat write FFormat;
    
    property Name: string read FName write FName;
    property Value: string read FValue write FValue;
    property Expires: TDateTime read FExpires write FExpires;
    property Domain: string read FDomain write FDomain;
    property Path: string read FPath write FPath;
    property Secure: Boolean read FSecure write FSecure;
    
    property Comment: string read FComment write FComment;
    property MaxAge: Int64 read FMaxAge write SetMaxAge;
    property Version: Integer read FVersion write FVersion;

    property CommentURL: string read FCommentURL write FCommentURL;
    property Discard: Boolean read FDiscard write FDiscard;
    property Port: string read FPort write FPort;
    
    property CookieData: string read FCookieData write FCookieData;

    property IsPersistent: Boolean read GetIsPersistent;
  end;

  TclCookieList = class;
  
  TclCompareCookies = function(AList: TclCookieList; Index1, Index2: Integer): Integer of object;

  TclCookieList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TclCookieItem;
    procedure SetItem(Index: Integer; const Value: TclCookieItem);
    procedure RemoveCookies(AFieldList: TclHeaderFieldList);
    function GetExpires(AFieldList: TclHeaderFieldList; const ACookieData: string): string;
    function CheckLexem(const ASource, ALexem: string): Boolean;
    procedure InternalSort(L, R: Integer; ACompare: TclCompareCookies);
    procedure ExchangeItems(Index1, Index2: Integer);
    function CompareCookies(AList: TclCookieList; Index1, Index2: Integer): Integer;
  protected
    function BuildRequestCookie(ACookieItem: TclCookieItem): string; virtual;
    procedure ParseResponseCookie(AFieldList: TclHeaderFieldList; AFieldIndex: Integer;
      const ADomain, APath: string; APort: Integer); virtual;
  public
    procedure SetRequestCookies(ARequestHeader: TStrings); virtual;
    procedure GetResponseCookies(AResponseHeader: TStrings; const ADomain, APath: string; APort: Integer); virtual;
    procedure Sort;
    function Add: TclCookieItem; overload;
    function Add(const AName, AValue, AUrl: string): TclCookieItem; overload;
    function Add(const AName, AValue, ADomain, APath: string): TclCookieItem; overload;
    function CookieByName(const AName: string; AStartFrom: Integer = 0): TclCookieItem;
    procedure Load(AStream: TStream); virtual;
    procedure Save(AStream: TStream); virtual;
    
    property Items[Index: Integer]: TclCookieItem read GetItem write SetItem; default;
  end;

  TclCookieEvent = procedure (Sender: TObject; ACookie: TclCookieItem; var Allow: Boolean) of object;
  TclUpdateCookieEvent = procedure (Sender: TObject; AOldCookie, ANewCookie: TclCookieItem;
    var Allow: Boolean) of object;
  TclAcceptCookieEvent = procedure (Sender: TObject; ACookie: TclCookieItem;
    const ADomain, APath: string; APort: Integer; ASecure: Boolean; var Allow: Boolean) of object;

  TclCookieManager = class(TComponent)
  private
    FCookies: TclCookieList;
    FAccessor: TCriticalSection;
    FOnAddCookie: TclCookieEvent;
    FOnDeleteCookie: TclCookieEvent;
    FOnUpdateCookie: TclUpdateCookieEvent;
    FOnAcceptCookie: TclAcceptCookieEvent;
    
    function GetCookie: TclCookieList;
    procedure InternalCleanup;
    function IsExpired(ACookie: TclCookieItem): Boolean;
    function FindCookie(ATemplate: TclCookieItem): TclCookieItem;
    procedure DeleteCookie(ACookie: TclCookieItem);
    procedure AddCookie(ACookie: TclCookieItem);
    procedure UpdateCookie(AOldCookie, ANewCookie: TclCookieItem);
    function IsMatch(ACookie: TclCookieItem; const ADomain, APath: string; APort: Integer; ASecure: Boolean): Boolean;
    function IsDomainMatch(const ACookieDomain, AUrlDomain: string): Boolean;
    function IsPathMatch(const ACookiePath, AUrlPath: string): Boolean;
    function IsPortMatch(const ACookiePort: string; AUrlPort: Integer): Boolean;
  protected
    procedure DoAddCookie(ACookie: TclCookieItem; var Allow: Boolean); virtual;
    procedure DoDeleteCookie(ACookie: TclCookieItem; var Allow: Boolean); virtual;
    procedure DoUpdateCookie(AOldCookie, ANewCookie: TclCookieItem; var Allow: Boolean); virtual;
    procedure DoAcceptCookie(ACookie: TclCookieItem; const ADomain, APath: string;
      APort: Integer; ASecure: Boolean; var Accept: Boolean); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AddCookies(ACookies: TclCookieList);
    procedure GetCookies(ACookies: TclCookieList; const ADomain, APath: string; APort: Integer; ASecure: Boolean);
    procedure Clear;
    procedure ClearExpired;
    procedure ClearNonPersistent;
    procedure BeginUpdate;
    procedure EndUpdate;

    property Cookies: TclCookieList read GetCookie;
  published
    property OnAddCookie: TclCookieEvent read FOnAddCookie write FOnAddCookie;
    property OnDeleteCookie: TclCookieEvent read FOnDeleteCookie write FOnDeleteCookie;
    property OnUpdateCookie: TclUpdateCookieEvent read FOnUpdateCookie write FOnUpdateCookie;
    property OnAcceptCookie: TclAcceptCookieEvent read FOnAcceptCookie write FOnAcceptCookie;
  end;

function NormalizeDomain(const ADomain: string): string;
function NormalizePath(const APath: string): string;

implementation

uses
{$IFNDEF DELPHIXE2}
  SysUtils,
{$ELSE}
  System.SysUtils,
{$ENDIF}
  clUtils, clUriUtils, clSocket, clHttpHeader;

function NormalizeDomain(const ADomain: string): string;
begin
  Result := Trim(ADomain);
  if (Result <> '') and (Result[1] <> '.') then
  begin
    Result := '.' + Result;
  end;
end;

function NormalizePath(const APath: string): string;
begin
  Result := Trim(APath);
  if (Result = '') then
  begin
    Result := '/';
  end;
end;

{ TclCookieList }

function TclCookieList.Add: TclCookieItem;
begin
  Result := TclCookieItem(inherited Add());
end;

function TclCookieList.GetItem(Index: Integer): TclCookieItem;
begin
  Result := TclCookieItem(inherited GetItem(Index));
end;

procedure TclCookieList.GetResponseCookies(AResponseHeader: TStrings;
  const ADomain, APath: string; APort: Integer);
var
  i: Integer;
  fieldList: TclHeaderFieldList;
begin
  Clear();

  fieldList := TclHeaderFieldList.Create();
  try
    fieldList.Parse(0, AResponseHeader);

    for i := 0 to fieldList.FieldList.Count - 1 do
    begin
      if SameText('set-cookie', fieldList.FieldList[i]) or SameText('set-cookie2', fieldList.FieldList[i]) then
      begin
        ParseResponseCookie(fieldList, i, ADomain, APath, APort);
      end;
    end;
  finally
    fieldList.Free();
  end;
end;

procedure TclCookieList.Save(AStream: TStream);
var
  i: Integer;
  writer: TWriter;
begin
  writer := TWriter.Create(AStream, 1024);
  try
    writer.WriteInteger(Count);
  finally
    writer.Free();
  end;

  for i := 0 to Count - 1 do
  begin
    Items[i].Save(AStream);
  end;
end;

procedure TclCookieList.SetItem(Index: Integer; const Value: TclCookieItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TclCookieList.RemoveCookies(AFieldList: TclHeaderFieldList);
var
  i: Integer;
begin
  for i := AFieldList.FieldList.Count - 1 downto 0 do
  begin
    if SameText('cookie', AFieldList.FieldList[i]) then
    begin
      AFieldList.RemoveField(i);
    end;
  end;
end;

procedure TclCookieList.SetRequestCookies(ARequestHeader: TStrings);
const
  cookieDelimiter = '; ';
var
  i: Integer;
  s: string;
  fieldList: TclHeaderFieldList;
begin
  fieldList := TclHeaderFieldList.Create();
  try
    fieldList.Parse(0, ARequestHeader);

    RemoveCookies(fieldList);

    s := '';
    for i := 0 to Count - 1 do
    begin
      s := s + BuildRequestCookie(Items[i]) + cookieDelimiter;
    end;
    if (s <> '') then
    begin
      SetLength(s, Length(s) - Length(cookieDelimiter));
    end;
    fieldList.AddField('Cookie', s);
  finally
    fieldList.Free();
  end;
end;

function TclCookieList.BuildRequestCookie(ACookieItem: TclCookieItem): string;
begin
  Result := ACookieItem.Name + '=' + ACookieItem.Value;
end;

function TclCookieList.GetExpires(AFieldList: TclHeaderFieldList; const ACookieData: string): string;
const
  lexem = 'expires=';
var
  ind: Integer;
begin
  ind := system.Pos(lexem, LowerCase(ACookieData));
  if (ind > 0) then
  begin
    Result := system.Copy(ACookieData, ind + Length(lexem), Length(ACookieData));
    Result := StringReplace(Result, ',', '==', [rfReplaceAll]);
    Result := AFieldList.GetFieldValueItem(Result, '');
    Result := StringReplace(Result, '==', ',', [rfReplaceAll]);
    Result := StringReplace(Result, '-', ' ', [rfReplaceAll]);
  end else
  begin
    Result := '';
  end;
end;

procedure TclCookieList.ParseResponseCookie(AFieldList: TclHeaderFieldList; AFieldIndex: Integer;
  const ADomain, APath: string; APort: Integer);
var
  ind: Integer;
  item: TclCookieItem;
  s, cookieHeader, cookieData: string;
begin
  cookieHeader := AFieldList.FieldList[AFieldIndex];
  cookieData := AFieldList.GetFieldValue(AFieldIndex);

  if (cookieData = '') then Exit;

  item := Add();

  ind := system.Pos('=', cookieData);
  if (ind > 0) then
  begin
    item.Name := Trim(system.Copy(cookieData, 1, ind - 1));
    item.Value := AFieldList.GetFieldValueItem(cookieData, LowerCase(item.Name));

    s := GetExpires(AFieldList, cookieData);
    if (s <> '') then
    begin
      try
        item.Expires := MimeTimeToDateTime(s);
      except
      end;
    end;
    item.Domain := AFieldList.GetFieldValueItem(cookieData, 'domain');
    item.Path := AFieldList.GetFieldValueItem(cookieData, 'path');
    item.Secure := CheckLexem(cookieData, 'secure');

    item.Comment := AFieldList.GetFieldValueItem(cookieData, 'comment');
    item.MaxAge := StrToInt64Def(AFieldList.GetFieldValueItem(cookieData, 'max-age'), -1);
    item.Version := StrToIntDef(AFieldList.GetFieldValueItem(cookieData, 'version'), 0);

    item.CommentURL := AFieldList.GetFieldValueItem(cookieData, 'commenturl');
    item.Port := AFieldList.GetFieldValueItem(cookieData, 'port');
    item.Discard := CheckLexem(cookieData, 'discard');

    if (item.Port = '') and CheckLexem(cookieData, 'port') then
    begin
      item.Port := IntToStr(APort);
    end;
  end else
  begin
    item.Name := cookieData;
  end;

  item.CookieData := cookieData;

  if SameText('set-cookie2', cookieHeader) then
  begin
    item.Format := cfRFC2965;
  end else
  if (item.Version = 1) then
  begin
    item.Format := cfRFC2109;
  end;

  if (item.Domain = '') then
  begin
    item.Domain := ADomain;
  end;
  item.Domain := NormalizeDomain(item.Domain);

  if (item.Path = '') then
  begin
    item.Path := APath;
  end;
  item.Path := NormalizePath(item.Path);
end;

function TclCookieList.CheckLexem(const ASource, ALexem: string): Boolean;
  function IsDelimiter(AChar: Char): Boolean;
  begin
    Result := CharInSet(AChar, [' ', ',', ';', #10, #9]);
  end;
  
var
  ind: Integer;
begin
  ind := system.Pos(ALexem, LowerCase(ASource));
  Result := ind > 0;
  if (Result) then
  begin
    Result := IsDelimiter(ASource[ind - 1]);
  end;
  if (Result and (ind + Length(ALexem) < Length(ASource))) then
  begin
    Result := IsDelimiter(ASource[ind + Length(ALexem) + 1]);
  end;
end;

function TclCookieList.CookieByName(const AName: string; AStartFrom: Integer): TclCookieItem;
var
  i: Integer;
begin
  for i := AStartFrom to Count - 1 do
  begin
    Result := Items[i];
    if SameText(Result.Name, AName) then Exit;
  end;
  Result := nil;
end;

function TclCookieList.Add(const AName, AValue, ADomain, APath: string): TclCookieItem;
begin
  Result := Add();
  Result.Name := AName;
  Result.Value := AValue;
  Result.Domain := ADomain;
  Result.Path := APath;
end;

function TclCookieList.CompareCookies(AList: TclCookieList; Index1, Index2: Integer): Integer;
begin
  Result := CompareText(AList[Index1].Name, AList[Index2].Name);
  if (Result = 0) then
  begin
    Result := CompareText(AList[Index2].Path, AList[Index1].Path);
  end;
end;

procedure TclCookieList.Sort;
begin
  BeginUpdate();
  try
    if (Count > 0) then
    begin
      InternalSort(0, Count - 1, CompareCookies);
    end;
  finally
    EndUpdate();
  end;
end;

procedure TclCookieList.InternalSort(L, R: Integer; ACompare: TclCompareCookies);
var
  i, j, p: Integer;
begin
  repeat
    i := L;
    j := R;
    p := (L + R) shr 1;
    repeat
      while ACompare(Self, i, p) < 0 do Inc(i);
      while ACompare(Self, j, p) > 0 do Dec(j);
      if (i <= j) then
      begin
        ExchangeItems(i, j);
        if (p = i) then
        begin
          p := j;
        end else
        if (p = j) then
        begin
          p := i;
        end;
        Inc(i);
        Dec(j);
      end;
    until (i > j);
    if (L < j) then
    begin
      InternalSort(L, j, ACompare);
    end;
    L := i;
  until (i >= R);
end;

procedure TclCookieList.Load(AStream: TStream);
var
  i, cnt: Integer;
  reader: TReader;
begin
  Clear();

  reader := TReader.Create(AStream, 1024);
  try
    cnt := reader.ReadInteger();
  finally
    reader.Free();
  end;

  for i := 0 to cnt - 1 do
  begin
    Add().Load(AStream);
  end;
end;

procedure TclCookieList.ExchangeItems(Index1, Index2: Integer);
var
  item1, item2: TclCookieItem;
begin
  item1 := Items[Index1];
  item2 := Items[Index2];

  item1.Index := Index2;
  item2.Index := Index1;
end;

function TclCookieList.Add(const AName, AValue, AUrl: string): TclCookieItem;
var
  host: string;
  parser: TclUrlParser;
begin
  parser := TclUrlParser.Create();
  try
    parser.Parse(AUrl);
    host := parser.Host;
    if SameText(host, 'localhost') then
    begin
      host := 'local';
    end;
    host := NormalizeDomain(host);
    Result := Add(AName, AValue, host, NormalizePath(parser.AbsolutePath));
  finally
    parser.Free();
  end;
end;

{ TclCookieItem }

procedure TclCookieItem.Assign(Source: TPersistent);
var
  item: TclCookieItem;
begin
  if (Source is TclCookieItem) then
  begin
    item := (Source as TclCookieItem);

    FFormat := item.Format;

    FName := item.Name;
    FValue := item.Value;
    FExpires := item.Expires;
    FDomain := item.Domain;
    FPath := item.Path;
    FSecure := item.Secure;

    FComment := item.Comment;
    FMaxAge := item.MaxAge;
    FVersion := item.Version;

    FCommentURL := item.CommentURL;
    FDiscard := item.Discard;
    FPort := item.Port;

    FCookieData := item.CookieData;
  end else
  begin
    inherited Assign(Source);
  end;
end;

constructor TclCookieItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FExpires := -1;
  FMaxAge := -1;
end;

function TclCookieItem.GetIsPersistent: Boolean;
begin
  Result := (Expires > 0) or (Expires < -1);
end;

procedure TclCookieItem.Load(AStream: TStream);
var
  reader: TReader;
begin
  reader := TReader.Create(AStream, 1024);
  try
    FFormat := TclCookieFormat(reader.ReadInteger());
    FName := reader.ReadString();
    FValue := reader.ReadString();
    FExpires := reader.ReadDate();
    FDomain := reader.ReadString();
    FPath := reader.ReadString();
    FSecure := reader.ReadBoolean();

    FComment := reader.ReadString();
    FMaxAge := reader.ReadInteger();
    FVersion := reader.ReadInteger();

    FCommentURL := reader.ReadString();
    FDiscard := reader.ReadBoolean();
    FPort := reader.ReadString();

    FCookieData := reader.ReadString();
  finally
    reader.Free();
  end;
end;

procedure TclCookieItem.Save(AStream: TStream);
var
  writer: TWriter;
begin
  writer := TWriter.Create(AStream, 1024);
  try
    writer.WriteInteger(Integer(FFormat));
    writer.WriteString(FName);
    writer.WriteString(FValue);
    writer.WriteDate(FExpires);
    writer.WriteString(FDomain);
    writer.WriteString(FPath);
    writer.WriteBoolean(FSecure);

    writer.WriteString(FComment);
    writer.WriteInteger(FMaxAge);
    writer.WriteInteger(FVersion);

    writer.WriteString(FCommentURL);
    writer.WriteBoolean(FDiscard);
    writer.WriteString(FPort);

    writer.WriteString(FCookieData);
  finally
    writer.Free();
  end;
end;

procedure TclCookieItem.SetMaxAge(const Value: Int64);
begin
  if (FMaxAge <> Value) then
  begin
    FMaxAge := Value;
    if (FMaxAge > 0) and (FExpires < 0) then
    begin
      FExpires := Now() + FMaxAge * 1000 / MSecsPerDay;
    end;
  end;
end;

{ TclCookieManager }

procedure TclCookieManager.AddCookies(ACookies: TclCookieList);
var
  i: Integer;
  item: TclCookieItem;
begin
  BeginUpdate();
  try
    InternalCleanup();
    
    for i := 0 to ACookies.Count - 1 do
    begin
      item := FindCookie(ACookies[i]);
      if (item <> nil) then
      begin
        if IsExpired(ACookies[i]) then
        begin
          DeleteCookie(item);
        end else
        begin
          UpdateCookie(item, ACookies[i]);
        end;
      end else
      begin
        AddCookie(ACookies[i]);
      end;
    end;
  finally
    EndUpdate();
  end;
end;

constructor TclCookieManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAccessor := TCriticalSection.Create();
  FCookies := TclCookieList.Create(Self, TclCookieItem);
end;

destructor TclCookieManager.Destroy;
begin
  FCookies.Free();
  FAccessor.Free();

  inherited Destroy();
end;

function TclCookieManager.GetCookie: TclCookieList;
begin
  Result := FCookies;
end;

procedure TclCookieManager.InternalCleanup;
var
  i: Integer;
  item: TclCookieItem;
begin
  for i := Cookies.Count - 1 downto 0 do
  begin
    item := Cookies[i];
    if IsExpired(item) then
    begin
      DeleteCookie(item);
    end;
  end;
end;

function TclCookieManager.IsExpired(ACookie: TclCookieItem): Boolean;
begin
  Result := ACookie.MaxAge = 0;
  if Result then Exit;

  Result := ((ACookie.Expires > 0) or (ACookie.Expires < -1)) and (ACookie.Expires < Now());
end;

function TclCookieManager.FindCookie(ATemplate: TclCookieItem): TclCookieItem;
var
  i: Integer;
begin
  for i := 0 to Cookies.Count - 1 do
  begin
    Result := Cookies[i];

    if SameText(Result.Name, ATemplate.Name) and SameText(Result.Domain, ATemplate.Domain)
      and SameText(Result.Path, ATemplate.Path) then Exit;
  end;
  Result := nil;
end;

procedure TclCookieManager.DeleteCookie(ACookie: TclCookieItem);
var
  accept: Boolean;
begin
  accept := True;
  DoDeleteCookie(ACookie, accept);
  if accept then
  begin
    ACookie.Free();
  end;
end;

procedure TclCookieManager.AddCookie(ACookie: TclCookieItem);
var
  accept: Boolean;
begin
  accept := True;
  DoAddCookie(ACookie, accept);
  if accept then
  begin
    Cookies.Add().Assign(ACookie);
  end;
end;

procedure TclCookieManager.UpdateCookie(AOldCookie, ANewCookie: TclCookieItem);
var
  accept: Boolean;
begin
  accept := True;
  DoUpdateCookie(AOldCookie, ANewCookie, accept);
  if accept then
  begin
    AOldCookie.Assign(ANewCookie);
  end;
end;

procedure TclCookieManager.GetCookies(ACookies: TclCookieList;
  const ADomain, APath: string; APort: Integer; ASecure: Boolean);
var
  i: Integer;
begin
  BeginUpdate();
  ACookies.BeginUpdate();
  try
    InternalCleanup();

    ACookies.Clear();

    for i := 0 to Cookies.Count - 1 do
    begin
      if IsMatch(Cookies[i], ADomain, APath, APort, ASecure) then
      begin
        ACookies.Add().Assign(Cookies[i]);
      end;
    end;

    ACookies.Sort();
  finally
    ACookies.EndUpdate();
    EndUpdate();
  end;
end;

function TclCookieManager.IsDomainMatch(const ACookieDomain, AUrlDomain: string): Boolean;
var
  ind: Integer;
  cDomain, uDomain: string;
begin
  cDomain := LowerCase(NormalizeDomain(ACookieDomain));
  uDomain := LowerCase(NormalizeDomain(AUrlDomain));

  Result := (cDomain = '.local');

  if not Result then
  begin
    Result := (cDomain = uDomain);

    if not Result then
    begin
      Result := (RTextPos(cDomain, uDomain) > 0);
    end;

    if Result then
    begin
      Result := False;
      
      if (Length(cDomain) > 1) then
      begin
        ind := TextPos('.', cDomain, 2);
        Result := ((ind = 0) or (ind > 2)) and (ind < Length(cDomain));
      end;
    end;
  end;
end;

function TclCookieManager.IsPathMatch(const ACookiePath, AUrlPath: string): Boolean;
var
  cPath, uPath: string;
begin
  cPath := LowerCase(NormalizePath(ACookiePath));
  uPath := LowerCase(NormalizePath(AUrlPath));

  Result := (system.Pos(cPath, uPath) > 0);
end;

function TclCookieManager.IsPortMatch(const ACookiePort: string; AUrlPort: Integer): Boolean;
var
  i: Integer;
  uPort: string;
begin
  if (ACookiePort = '') then
  begin
    Result := True;
    Exit;
  end;

  uPort := IntToStr(AUrlPort);

  for i := 1 to WordCount(ACookiePort, [',']) do
  begin
    Result := (ExtractWord(i, ACookiePort, [',']) = uPort);
    if Result then Exit;
  end;

  Result := False;
end;

function TclCookieManager.IsMatch(ACookie: TclCookieItem; const ADomain, APath: string;
  APort: Integer; ASecure: Boolean): Boolean;
begin
  Result := IsDomainMatch(ACookie.Domain, ADomain) and IsPathMatch(ACookie.Path, APath)
    and IsPortMatch(ACookie.Port, APort);

  if Result and ACookie.Secure then
  begin
    Result := ASecure;
  end;

  DoAcceptCookie(ACookie, ADomain, APath, APort, ASecure, Result);
end;

procedure TclCookieManager.BeginUpdate;
begin
  FAccessor.Enter();
  Cookies.BeginUpdate();
end;

procedure TclCookieManager.EndUpdate;
begin
  Cookies.EndUpdate();
  FAccessor.Leave();
end;

procedure TclCookieManager.Clear;
var
  i: Integer;
begin
  BeginUpdate();
  try
    for i := Cookies.Count - 1 downto 0 do
    begin
      DeleteCookie(Cookies[i]);
    end;
  finally
    EndUpdate();
  end;
end;

procedure TclCookieManager.ClearExpired;
begin
  BeginUpdate();
  try
    InternalCleanup();
  finally
    EndUpdate();
  end;
end;

procedure TclCookieManager.ClearNonPersistent;
var
  i: Integer;
  item: TclCookieItem;
begin
  BeginUpdate();
  try
    for i := Cookies.Count - 1 downto 0 do
    begin
      item := Cookies[i];
      if not ((item.Expires > 0) or (item.Expires < -1)) then
      begin
        DeleteCookie(item);
      end;
    end;
  finally
    EndUpdate();
  end;
end;

procedure TclCookieManager.DoAddCookie(ACookie: TclCookieItem; var Allow: Boolean);
begin
  if Assigned(OnAddCookie) then
  begin
    OnAddCookie(Self, ACookie, Allow);
  end;
end;

procedure TclCookieManager.DoDeleteCookie(ACookie: TclCookieItem; var Allow: Boolean);
begin
  if Assigned(OnDeleteCookie) then
  begin
    OnDeleteCookie(Self, ACookie, Allow);
  end;
end;

procedure TclCookieManager.DoUpdateCookie(AOldCookie, ANewCookie: TclCookieItem; var Allow: Boolean);
begin
  if Assigned(OnUpdateCookie) then
  begin
    OnUpdateCookie(Self, AOldCookie, ANewCookie, Allow);
  end;
end;

procedure TclCookieManager.DoAcceptCookie(ACookie: TclCookieItem; const ADomain, APath: string;
  APort: Integer; ASecure: Boolean; var Accept: Boolean);
begin
  if Assigned(OnAcceptCookie) then
  begin
    OnAcceptCookie(Self, ACookie, ADomain, APath, APort, ASecure, Accept);
  end;
end;

end.
