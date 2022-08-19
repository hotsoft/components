{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clHttpHeader;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clUtils, clHeaderFieldList;

type
  TclHttpEntityHeader = class(TPersistent)
  private
    FCacheControl: string;
    FProxyConnection: string;
    FConnection: string;
    FContentEncoding: string;
    FLastModified: string;
    FContentType: string;
    FContentLanguage: string;
    FContentVersion: string;
    FContentLength: string;
    FExpires: string;
    FDate: string;
    FExtraFields: TStrings;
    FTransferEncoding: string;
    FBoundary: string;
    FUpdateCount: Integer;
    FKnownFields: TStrings;
    FOnChanged: TNotifyEvent;
    FCharSet: string;
    
    procedure SetCacheControl(const Value: string);
    procedure SetConnection(const Value: string);
    procedure SetContentEncoding(const Value: string);
    procedure SetContentLanguage(const Value: string);
    procedure SetContentLength(const Value: string);
    procedure SetContentType(const Value: string);
    procedure SetContentVersion(const Value: string);
    procedure SetDate(const Value: string);
    procedure SetExpires(const Value: string);
    procedure SetExtraFields(const Value: TStrings);
    procedure SetLastModified(const Value: string);
    procedure SetProxyConnection(const Value: string);
    procedure SetTransferEncoding(const Value: string);
    procedure SetBoundary(const Value: string);
    procedure Changed;
    procedure DoStringListChanged(Sender: TObject);
    procedure SetCharSet(const Value: string);
  protected
    procedure SetListChangedEvent(AList: TStrings);
    procedure RegisterField(const AField: string);
    procedure RegisterFields; virtual;
    procedure InternalParseHeader(AFieldList: TclHeaderFieldList); virtual;
    procedure InternalAssignHeader(AFieldList: TclHeaderFieldList); virtual;
    procedure ParseContentType(AFieldList: TclHeaderFieldList); virtual;
    procedure AssignContentType(AFieldList: TclHeaderFieldList); virtual;
    procedure DoCreate; virtual;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; virtual;
    procedure Assign(Source: TPersistent); override;
    procedure ParseHeader(AHeader: TStrings);
    procedure AssignHeader(AHeader: TStrings);
    procedure Update;
    procedure BeginUpdate;
    procedure EndUpdate;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  published
    property Boundary: string read FBoundary write SetBoundary;
    property CharSet: string read FCharSet write SetCharSet; 
    property CacheControl: string read FCacheControl write SetCacheControl;
    property Connection: string read FConnection write SetConnection;
    property ContentEncoding: string read FContentEncoding write SetContentEncoding;
    property ContentLanguage: string read FContentLanguage write SetContentLanguage;
    property ContentLength: string read FContentLength write SetContentLength;
    property ContentType: string read FContentType write SetContentType;
    property ContentVersion: string read FContentVersion write SetContentVersion;
    property Date: string read FDate write SetDate;
    property Expires: string read FExpires write SetExpires;
    property LastModified: string read FLastModified write SetLastModified;
    property ProxyConnection: string read FProxyConnection write SetProxyConnection;
    property TransferEncoding: string read FTransferEncoding write SetTransferEncoding;
    property ExtraFields: TStrings read FExtraFields write SetExtraFields;
  end;

  TclHttpRequestHeader = class(TclHttpEntityHeader)
  private
    FReferer: string;
    FAcceptEncoding: string;
    FAccept: string;
    FUserAgent: string;
    FAcceptLanguage: string;
    FAcceptCharSet: string;
    FAuthorization: string;
    FProxyAuthorization: string;
    FRange: string;
    FHost: string;
    
    procedure SetAccept(const Value: string);
    procedure SetAcceptCharSet(const Value: string);
    procedure SetAcceptEncoding(const Value: string);
    procedure SetAcceptLanguage(const Value: string);
    procedure SetAuthorization(const Value: string);
    procedure SetReferer(const Value: string);
    procedure SetUserAgent(const Value: string);
    procedure SetProxyAuthorization(const Value: string);
    procedure SetHost(const Value: string);
    procedure SetRange(const Value: string);
  protected
    procedure RegisterFields; override;
    procedure InternalParseHeader(AFieldList: TclHeaderFieldList); override;
    procedure InternalAssignHeader(AFieldList: TclHeaderFieldList); override;
  public
    procedure Clear; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Accept: string read FAccept write SetAccept;
    property AcceptCharSet: string read FAcceptCharSet write SetAcceptCharSet;
    property AcceptEncoding: string read FAcceptEncoding write SetAcceptEncoding;
    property AcceptLanguage: string read FAcceptLanguage write SetAcceptLanguage;
    property Authorization: string read FAuthorization write SetAuthorization;
    property Host: string read FHost write SetHost;
    property ProxyAuthorization: string read FProxyAuthorization write SetProxyAuthorization;
    property Range: string read FRange write SetRange;
    property Referer: string read FReferer write SetReferer;
    property UserAgent: string read FUserAgent write SetUserAgent;
  end;

  TclHttpResponseHeader = class(TclHttpEntityHeader)
  private
    FAge: string;
    FAcceptRanges: string;
    FRetryAfter: string;
    FAuthenticate: TStrings;
    FAllow: string;
    FProxyAuthenticate: TStrings;
    FContentRange: string;
    FETag: string;
    FServer: string;
    FLocation: string;
    FContentDisposition: string;
    
    procedure SetAcceptRanges(const Value: string);
    procedure SetAge(const Value: string);
    procedure SetAllow(const Value: string);
    procedure SetAuthenticate(const Value: TStrings);
    procedure SetContentRange(const Value: string);
    procedure SetETag(const Value: string);
    procedure SetLocation(const Value: string);
    procedure SetProxyAuthenticate(const Value: TStrings);
    procedure SetRetryAfter(const Value: string);
    procedure SetServer(const Value: string);
    procedure GetAuthChallenge(AFieldList: TclHeaderFieldList; const AuthFieldName: string; AuthChallenge: TStrings);
    procedure SetAuthChallenge(AFieldList: TclHeaderFieldList; const AuthFieldName: string; AuthChallenge: TStrings);
    procedure SetContentDisposition(const Value: string);
  protected
    procedure RegisterFields; override;
    procedure InternalParseHeader(AFieldList: TclHeaderFieldList); override;
    procedure InternalAssignHeader(AFieldList: TclHeaderFieldList); override;
    procedure DoCreate; override;
  public
    destructor Destroy; override;
    procedure Clear; override;
    procedure Assign(Source: TPersistent); override;
  published
    property AcceptRanges: string read FAcceptRanges write SetAcceptRanges;
    property Age: string read FAge write SetAge;
    property Allow: string read FAllow write SetAllow;
    property Authenticate: TStrings read FAuthenticate write SetAuthenticate;
    property ContentRange: string read FContentRange write SetContentRange;
    property ContentDisposition: string read FContentDisposition write SetContentDisposition;
    property ETag: string read FETag write SetETag;
    property Location: string read FLocation write SetLocation;
    property ProxyAuthenticate: TStrings read FProxyAuthenticate write SetProxyAuthenticate;
    property RetryAfter: string read FRetryAfter write SetRetryAfter;
    property Server: string read FServer write SetServer;
  end;

implementation

{ TclHttpEntityHeader }

procedure TclHttpEntityHeader.Assign(Source: TPersistent);
var
  Src: TclHttpEntityHeader;
begin
  BeginUpdate();
  try
    if (Source is TclHttpEntityHeader) then
    begin
      Src := (Source as TclHttpEntityHeader);
      Boundary := Src.Boundary;
      CharSet := Src.CharSet;
      CacheControl := Src.CacheControl;
      Connection := Src.Connection;
      ContentEncoding := Src.ContentEncoding;
      ContentLanguage := Src.ContentLanguage;
      ContentLength := Src.ContentLength;
      ContentType := Src.ContentType;
      ContentVersion := Src.ContentVersion;
      Date := Src.Date;
      Expires := Src.Expires;
      LastModified := Src.LastModified;
      ProxyConnection := Src.ProxyConnection;
      TransferEncoding := Src.TransferEncoding;
      ExtraFields := Src.ExtraFields;
    end else
    begin
      inherited Assign(Source);
    end;
  finally
    EndUpdate();
  end;
end;

procedure TclHttpEntityHeader.AssignContentType(AFieldList: TclHeaderFieldList);
begin
  AFieldList.AddField('Content-Type', ContentType);

  if (ContentType <> '') then
  begin
    AFieldList.AddFieldItem('Content-Type', 'boundary', Boundary);
    AFieldList.AddFieldItem('Content-Type', 'charset', CharSet);
  end;
end;

procedure TclHttpEntityHeader.AssignHeader(AHeader: TStrings);
var
  fieldList: TclHeaderFieldList;
begin
  fieldList := nil;
  AHeader.BeginUpdate();
  try
    fieldList := TclHeaderFieldList.Create();
    fieldList.Parse(0, AHeader);

    InternalAssignHeader(fieldList);
  finally
    fieldList.Free();
    AHeader.EndUpdate();
  end;
end;

procedure TclHttpEntityHeader.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TclHttpEntityHeader.Changed;
begin
  if Assigned(OnChanged) then
  begin
    OnChanged(Self);
  end;
end;

procedure TclHttpEntityHeader.Clear;
begin
  BeginUpdate();
  try
    Boundary := '';
    CharSet := '';
    CacheControl := '';
    Connection := '';
    ContentEncoding := '';
    ContentLanguage := '';
    ContentLength := '';
    ContentType := '';
    ContentVersion := '';
    Date := '';
    Expires := '';
    LastModified := '';
    ProxyConnection := '';
    TransferEncoding := '';
    ExtraFields.Clear();
  finally
    EndUpdate();
  end;
end;

constructor TclHttpEntityHeader.Create;
begin
  inherited Create();
  DoCreate();
  RegisterFields();
  Clear();
end;

destructor TclHttpEntityHeader.Destroy;
begin
  FExtraFields.Free();
  FKnownFields.Free();
  inherited Destroy();
end;

procedure TclHttpEntityHeader.DoCreate;
begin
  FKnownFields := TStringList.Create();
  FExtraFields := TStringList.Create();
  SetListChangedEvent(FExtraFields);
end;

procedure TclHttpEntityHeader.DoStringListChanged(Sender: TObject);
begin
  Update();
end;

procedure TclHttpEntityHeader.EndUpdate;
begin
  if (FUpdateCount > 0) then
  begin
    Dec(FUpdateCount);
    Update();
  end;
end;

procedure TclHttpEntityHeader.InternalAssignHeader(AFieldList: TclHeaderFieldList);
begin
  AFieldList.AddField('Content-Encoding', ContentEncoding);
  AFieldList.AddField('Content-Language', ContentLanguage);
  AFieldList.AddField('Content-Length', ContentLength);
  AFieldList.AddField('Content-Version', ContentVersion);

  AssignContentType(AFieldList);

  AFieldList.AddField('Date', Date);
  AFieldList.AddField('Expires', Expires);
  AFieldList.AddField('LastModified', LastModified);
  AFieldList.AddField('Transfer-Encoding', TransferEncoding);
  AFieldList.AddField('Cache-Control', CacheControl);
  AFieldList.AddField('Connection', Connection);
  AFieldList.AddField('Proxy-Connection', ProxyConnection);

  AFieldList.AddFields(ExtraFields);
end;

procedure TclHttpEntityHeader.InternalParseHeader(AFieldList: TclHeaderFieldList);
begin
  CacheControl := AFieldList.GetFieldValue('Cache-Control');
  Connection := AFieldList.GetFieldValue('Connection');
  ContentEncoding := AFieldList.GetFieldValue('Content-Encoding');
  ContentLanguage := AFieldList.GetFieldValue('Content-Language');
  ContentLength := AFieldList.GetFieldValue('Content-Length');
  ContentVersion := AFieldList.GetFieldValue('Content-Version');
  Date := AFieldList.GetFieldValue('Date');
  Expires := AFieldList.GetFieldValue('Expires');
  LastModified := AFieldList.GetFieldValue('Last-Modified');
  ProxyConnection := AFieldList.GetFieldValue('Proxy-Connection');
  TransferEncoding := AFieldList.GetFieldValue('Transfer-Encoding');
  
  ParseContentType(AFieldList);
end;

procedure TclHttpEntityHeader.ParseContentType(AFieldList: TclHeaderFieldList);
var
  s: string;
begin
  s := AFieldList.GetFieldValue('Content-Type');
  ContentType := AFieldList.GetFieldValueItem(s, '');
  Boundary := AFieldList.GetFieldValueItem(s, 'boundary');
  CharSet := AFieldList.GetFieldValueItem(s, 'charset');
end;

procedure TclHttpEntityHeader.ParseHeader(AHeader: TStrings);
var
  i: Integer;
  FieldList: TclHeaderFieldList;
begin
  FieldList := nil;
  BeginUpdate();
  try
    Clear();

    FieldList := TclHeaderFieldList.Create();
    FieldList.Parse(0, AHeader);

    InternalParseHeader(FieldList);

    for i := 0 to FieldList.FieldList.Count - 1 do
    begin
      if (FindInStrings(FKnownFields, FieldList.FieldList[i]) < 0) then
      begin
        ExtraFields.Add(FieldList.GetFieldName(i) + ': ' + FieldList.GetFieldValue(i));
      end;
    end;
  finally
    FieldList.Free();
    EndUpdate();
  end;
end;

procedure TclHttpEntityHeader.RegisterField(const AField: string);
begin
  if (FindInStrings(FKnownFields, AField) < 0) then
  begin
    FKnownFields.Add(AField);
  end;
end;

procedure TclHttpEntityHeader.RegisterFields;
begin
  RegisterField('Cache-Control');
  RegisterField('Connection');
  RegisterField('Content-Encoding');
  RegisterField('Content-Language');
  RegisterField('Content-Length');
  RegisterField('Content-Type');
  RegisterField('Content-Version');
  RegisterField('Date');
  RegisterField('Expires');
  RegisterField('Last-Modified');
  RegisterField('Proxy-Connection');
  RegisterField('Transfer-Encoding');
end;

procedure TclHttpEntityHeader.SetBoundary(const Value: string);
begin
  if (FBoundary <> Value) then
  begin
    FBoundary := Value;
    Update();
    FBoundary := Value;
  end;
end;

procedure TclHttpEntityHeader.SetCacheControl(const Value: string);
begin
  if (FCacheControl <> Value) then
  begin
    FCacheControl := Value;
    Update();
  end;
end;

procedure TclHttpEntityHeader.SetCharSet(const Value: string);
begin
  if (FCharSet <> Value) then
  begin
    FCharSet := Value;
    Update();
  end;
end;

procedure TclHttpEntityHeader.SetConnection(const Value: string);
begin
  if (FConnection <> Value) then
  begin
    FConnection := Value;
    Update();
  end;
end;

procedure TclHttpEntityHeader.SetContentEncoding(const Value: string);
begin
  if (FContentEncoding <> Value) then
  begin
    FContentEncoding := Value;
    Update();
  end;
end;

procedure TclHttpEntityHeader.SetContentLanguage(const Value: string);
begin
  if (FContentLanguage <> Value) then
  begin
    FContentLanguage := Value;
    Update();
  end;
end;

procedure TclHttpEntityHeader.SetContentLength(const Value: string);
begin
  if (FContentLength <> Value) then
  begin
    FContentLength := Value;
    Update();
  end;
end;

procedure TclHttpEntityHeader.SetContentType(const Value: string);
begin
  if (FContentType <> Value) then
  begin
    FContentType := Value;
    Update();
  end;
end;

procedure TclHttpEntityHeader.SetContentVersion(const Value: string);
begin
  if (FContentVersion <> Value) then
  begin
    FContentVersion := Value;
    Update();
  end;
end;

procedure TclHttpEntityHeader.SetDate(const Value: string);
begin
  if (FDate <> Value) then
  begin
    FDate := Value;
    Update();
  end;
end;

procedure TclHttpEntityHeader.SetExpires(const Value: string);
begin
  if (FExpires <> Value) then
  begin
    FExpires := Value;
    Update();
  end;
end;

procedure TclHttpEntityHeader.SetExtraFields(const Value: TStrings);
begin
  FExtraFields.Assign(Value);
end;

procedure TclHttpEntityHeader.SetLastModified(const Value: string);
begin
  if (FLastModified <> Value) then
  begin
    FLastModified := Value;
    Update();
  end;
end;

procedure TclHttpEntityHeader.SetListChangedEvent(AList: TStrings);
begin
  (AList as TStringList).OnChange := DoStringListChanged;
end;

procedure TclHttpEntityHeader.SetProxyConnection(const Value: string);
begin
  if (FProxyConnection <> Value) then
  begin
    FProxyConnection := Value;
    Update();
  end;
end;

procedure TclHttpEntityHeader.SetTransferEncoding(const Value: string);
begin
  if (FTransferEncoding <> Value) then
  begin
    FTransferEncoding := Value;
    Update();
  end;
end;

procedure TclHttpEntityHeader.Update;
begin
  if (FUpdateCount = 0) then
  begin
    Changed();
  end;
end;

{ TclHttpRequestHeader }

procedure TclHttpRequestHeader.Assign(Source: TPersistent);
var
  Src: TclHttpRequestHeader;
begin
  BeginUpdate();
  try
    inherited Assign(Source);

    if (Source is TclHttpRequestHeader) then
    begin
      Src := (Source as TclHttpRequestHeader);
      Accept := Src.Accept;
      AcceptCharSet := Src.AcceptCharSet;
      AcceptEncoding := Src.AcceptEncoding;
      AcceptLanguage := Src.AcceptLanguage;
      Authorization := Src.Authorization;
      Host := Src.Host;
      ProxyAuthorization := Src.ProxyAuthorization;
      Range := Src.Range;
      Referer := Src.Referer;
      UserAgent := Src.UserAgent;
    end;
  finally
    EndUpdate();
  end;
end;

procedure TclHttpRequestHeader.InternalAssignHeader(AFieldList: TclHeaderFieldList);
begin
  AFieldList.AddField('Accept', Accept);
  AFieldList.AddField('Accept-Charset', AcceptCharSet);
  AFieldList.AddField('Accept-Encoding', AcceptEncoding);
  AFieldList.AddField('Accept-Language', AcceptLanguage);
  AFieldList.AddField('Range', Range);
  AFieldList.AddField('Referer', Referer);
  AFieldList.AddField('Host', Host);
  AFieldList.AddField('User-Agent', UserAgent);
  AFieldList.AddField('Authorization', Authorization);
  AFieldList.AddField('Proxy-Authorization', ProxyAuthorization);

  inherited InternalAssignHeader(AFieldList);
end;

procedure TclHttpRequestHeader.Clear;
begin
  BeginUpdate();
  try
    inherited Clear();
    Accept := '*/*';
    AcceptCharSet := '';
    AcceptEncoding := '';
    AcceptLanguage := '';
    Authorization := '';
    Host := '';
    ProxyAuthorization := '';
    Range := '';
    Referer := '';
    UserAgent := '';
  finally
    EndUpdate();
  end;
end;

procedure TclHttpRequestHeader.SetAccept(const Value: string);
begin
  if (FAccept <> Value) then
  begin
    FAccept := Value;
    Update();
  end;
end;

procedure TclHttpRequestHeader.SetAcceptCharSet(const Value: string);
begin
  if (FAcceptCharSet <> Value) then
  begin
    FAcceptCharSet := Value;
    Update();
  end;
end;

procedure TclHttpRequestHeader.SetAcceptEncoding(const Value: string);
begin
  if (FAcceptEncoding <> Value) then
  begin
    FAcceptEncoding := Value;
    Update();
  end;
end;

procedure TclHttpRequestHeader.SetAcceptLanguage(const Value: string);
begin
  if (FAcceptLanguage <> Value) then
  begin
    FAcceptLanguage := Value;
    Update();
  end;
end;

procedure TclHttpRequestHeader.SetAuthorization(const Value: string);
begin
  if (FAuthorization <> Value) then
  begin
    FAuthorization := Value;
    Update();
  end;
end;

procedure TclHttpRequestHeader.SetHost(const Value: string);
begin
  if (FHost <> Value) then
  begin
    FHost := Value;
    Update();
  end;
end;

procedure TclHttpRequestHeader.SetProxyAuthorization(const Value: string);
begin
  if (FProxyAuthorization <> Value) then
  begin
    FProxyAuthorization := Value;
    Update();
  end;
end;

procedure TclHttpRequestHeader.SetRange(const Value: string);
begin
  if (FRange <> Value) then
  begin
    FRange := Value;
    Update();
  end;
end;

procedure TclHttpRequestHeader.SetReferer(const Value: string);
begin
  if (FReferer <> Value) then
  begin
    FReferer := Value;
    Update();
  end;
end;

procedure TclHttpRequestHeader.SetUserAgent(const Value: string);
begin
  if (FUserAgent <> Value) then
  begin
    FUserAgent := Value;
    Update();
  end;
end;

procedure TclHttpRequestHeader.InternalParseHeader(AFieldList: TclHeaderFieldList);
begin
  inherited InternalParseHeader(AFieldList);

  Accept := AFieldList.GetFieldValue('Accept');
  AcceptCharSet := AFieldList.GetFieldValue('Accept-Charset');
  AcceptEncoding := AFieldList.GetFieldValue('Accept-Encoding');
  AcceptLanguage := AFieldList.GetFieldValue('Accept-Language');
  Authorization := AFieldList.GetFieldValue('Authorization');
  Host := AFieldList.GetFieldValue('Host');
  ProxyAuthorization := AFieldList.GetFieldValue('Proxy-Authorization');
  Range := AFieldList.GetFieldValue('Range');
  Referer := AFieldList.GetFieldValue('Referer');
  UserAgent := AFieldList.GetFieldValue('User-Agent');
end;

procedure TclHttpRequestHeader.RegisterFields;
begin
  inherited RegisterFields();

  RegisterField('Accept');
  RegisterField('Accept-Charset');
  RegisterField('Accept-Encoding');
  RegisterField('Accept-Language');
  RegisterField('Authorization');
  RegisterField('Host');
  RegisterField('Proxy-Authorization');
  RegisterField('Range');
  RegisterField('Referer');
  RegisterField('User-Agent');
end;

{ TclHttpResponseHeader }

procedure TclHttpResponseHeader.Assign(Source: TPersistent);
var
  Src: TclHttpResponseHeader;
begin
  BeginUpdate();
  try
    inherited Assign(Source);

    if (Source is TclHttpResponseHeader) then
    begin
      Src := (Source as TclHttpResponseHeader);
      AcceptRanges := Src.AcceptRanges;
      Age := Src.Age;
      Allow := Src.Allow;
      Authenticate := Src.Authenticate;
      ContentRange := Src.ContentRange;
      ContentDisposition := Src.ContentDisposition;
      ETag := Src.ETag;
      Location := Src.Location;
      ProxyAuthenticate := Src.ProxyAuthenticate;
      RetryAfter := Src.RetryAfter;
      Server := Src.Server;
    end;
  finally
    EndUpdate();
  end;
end;

procedure TclHttpResponseHeader.Clear;
begin
  BeginUpdate();
  try
    inherited Clear();
    AcceptRanges := '';
    Age := '';
    Allow := '';
    Authenticate.Clear();
    ContentRange := '';
    ETag := '';
    Location := '';
    ContentDisposition := '';
    ProxyAuthenticate.Clear();
    RetryAfter := '';
    Server := '';
  finally
    EndUpdate();
  end;
end;

destructor TclHttpResponseHeader.Destroy;
begin
  FProxyAuthenticate.Free();
  FAuthenticate.Free();
  inherited Destroy();
end;

procedure TclHttpResponseHeader.InternalAssignHeader(AFieldList: TclHeaderFieldList);
begin
  AFieldList.AddField('Allow', Allow);
  AFieldList.AddField('Accept-Ranges', AcceptRanges);
  AFieldList.AddField('Age', Age);
  AFieldList.AddField('Content-Range', ContentRange);
  AFieldList.AddField('Content-Disposition', ContentDisposition);
  AFieldList.AddField('ETag', ETag);
  AFieldList.AddField('Location', Location);
  AFieldList.AddField('Retry-After', RetryAfter);
  AFieldList.AddField('Server', Server);

  SetAuthChallenge(AFieldList, 'WWW-Authenticate', Authenticate);
  SetAuthChallenge(AFieldList, 'Proxy-Authenticate', ProxyAuthenticate);

  inherited InternalAssignHeader(AFieldList);
end;

procedure TclHttpResponseHeader.GetAuthChallenge(AFieldList: TclHeaderFieldList;
  const AuthFieldName: string; AuthChallenge: TStrings);
var
  i: Integer;
begin
  AuthChallenge.Clear();
  for i := 0 to AFieldList.FieldList.Count - 1 do
  begin
    if SameText(AuthFieldName, AFieldList.FieldList[i]) then
    begin
      AuthChallenge.Add(AFieldList.GetFieldValue(i));
    end;
  end;
end;

procedure TclHttpResponseHeader.SetAuthChallenge(AFieldList: TclHeaderFieldList;
  const AuthFieldName: string; AuthChallenge: TStrings);
var
  i: Integer;
begin
  for i := 0 to AuthChallenge.Count - 1 do
  begin
    AFieldList.AddField(AuthFieldName, AuthChallenge[i]);
  end;
end;

procedure TclHttpResponseHeader.InternalParseHeader(AFieldList: TclHeaderFieldList);
begin
  inherited InternalParseHeader(AFieldList);

  AcceptRanges := AFieldList.GetFieldValue('Accept-Ranges');
  Age := AFieldList.GetFieldValue('Age');
  Allow := AFieldList.GetFieldValue('Allow');
  ContentRange := AFieldList.GetFieldValue('Content-Range');
  ContentDisposition := AFieldList.GetFieldValue('Content-Disposition');
  ETag := AFieldList.GetFieldValue('ETag');
  Location := AFieldList.GetFieldValue('Location');
  RetryAfter := AFieldList.GetFieldValue('Retry-After');
  Server := AFieldList.GetFieldValue('Server');

  GetAuthChallenge(AFieldList, 'WWW-Authenticate', Authenticate);
  GetAuthChallenge(AFieldList, 'Proxy-Authenticate', ProxyAuthenticate);
end;

procedure TclHttpResponseHeader.RegisterFields;
begin
  inherited RegisterFields();

  RegisterField('Accept-Ranges');
  RegisterField('Age');
  RegisterField('Allow');
  RegisterField('WWW-Authenticate');
  RegisterField('Content-Range');
  RegisterField('Content-Disposition');
  RegisterField('ETag');
  RegisterField('Location');
  RegisterField('Proxy-Authenticate');
  RegisterField('Retry-After');
  RegisterField('Server');
end;

procedure TclHttpResponseHeader.SetAcceptRanges(const Value: string);
begin
  if (FAcceptRanges <> Value) then
  begin
    FAcceptRanges := Value;
    Update();
  end;
end;

procedure TclHttpResponseHeader.SetAge(const Value: string);
begin
  if (FAge <> Value) then
  begin
    FAge := Value;
    Update();
  end;
end;

procedure TclHttpResponseHeader.SetAllow(const Value: string);
begin
  if (FAllow <> Value) then
  begin
    FAllow := Value;
    Update();
  end;
end;

procedure TclHttpResponseHeader.SetAuthenticate(const Value: TStrings);
begin
  FAuthenticate.Assign(Value);
end;

procedure TclHttpResponseHeader.SetContentDisposition(const Value: string);
begin
  if (FContentDisposition <> Value) then
  begin
    FContentDisposition := Value;
    Update();
  end;
end;

procedure TclHttpResponseHeader.SetContentRange(const Value: string);
begin
  if (FContentRange <> Value) then
  begin
    FContentRange := Value;
    Update();
  end;
end;

procedure TclHttpResponseHeader.SetETag(const Value: string);
begin
  if (FETag <> Value) then
  begin
    FETag := Value;
    Update();
  end;
end;

procedure TclHttpResponseHeader.SetLocation(const Value: string);
begin
  if (FLocation <> Value) then
  begin
    FLocation := Value;
    Update();
  end;
end;

procedure TclHttpResponseHeader.SetProxyAuthenticate(const Value: TStrings);
begin
  FProxyAuthenticate.Assign(Value);
end;

procedure TclHttpResponseHeader.SetRetryAfter(const Value: string);
begin
  if (FRetryAfter <> Value) then
  begin
    FRetryAfter := Value;
    Update();
  end;
end;

procedure TclHttpResponseHeader.SetServer(const Value: string);
begin
  if (FServer <> Value) then
  begin
    FServer := Value;
    Update();
  end;
end;

procedure TclHttpResponseHeader.DoCreate;
begin
  inherited DoCreate();
  FAuthenticate := TStringList.Create();
  FProxyAuthenticate := TStringList.Create();
  SetListChangedEvent(FAuthenticate);
  SetListChangedEvent(FProxyAuthenticate);
end;

end.

