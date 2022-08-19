{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clHttp;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows, SysUtils, Contnrs, WinSock,{$IFDEF DEMO} Forms, clEncoder, clEncryptor, clCertificate, clHtmlParser,{$ENDIF}
{$ELSE}
  System.Classes, Winapi.Windows, System.SysUtils, System.Contnrs, Winapi.WinSock,{$IFDEF DEMO} Vcl.Forms, clEncoder, clEncryptor, clCertificate, clHtmlParser,{$ENDIF}
{$ENDIF}
  clTcpClient, clTcpClientTls, clSocket, clHttpUtils, clUriUtils, clCookieManager, clHttpHeader,
  clHttpRequest, clHttpAuth, clSspiTls, clWUtils, clSocketUtils, clUtils, clHeaderFieldList;

type
  EclHttpError = class(EclTcpClientError)
  private
    FResponseText: string;
  public
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; const AResponseText: string);
    property ResponseText: string read FResponseText;
  end;

  TclHttpRequestEvent = procedure (Sender: TObject; const AMethod, AUrl: string;
    ARequestHeader: TStrings) of object;

  TclHttpHeaderEvent = procedure (Sender: TObject; const AMethod, AUrl: string;
    AResponseHeader: TStrings; ACookies: TclCookieList; var Cancel: Boolean) of object;

  TclHttpResponseEvent = procedure (Sender: TObject; const AMethod, AUrl: string;
    AResponseHeader: TStrings; ACookies: TclCookieList) of object;

  TclHttpRedirectEvent = procedure (Sender: TObject; ARequestHeader: TStrings;
    AStatusCode: Integer; AResponseHeader: TclHttpResponseHeader; AResponseText: TStrings;
    var AMethod: string; var CanRedirect, Handled: Boolean) of object;

  TclHttpTunnelStatus = (htNone, htConnect, htTunnel);

  TclHttp = class(TclTcpClientTls)
  private
    FCharSet: string;
    FUrl: TclUrlParser;
    FHttpVersion: TclHttpVersion;
    FUserName: string;
    FPassword: string;
    FStatusCode: Integer;
    FStatusText: string;
    FUserAgent: string;
    FAuthorizationType: TclAuthorizationType;
    FKeepConnection: Boolean;
    FAllowCaching: Boolean;
    FAllowRedirects: Boolean;
    FProxySettings: TclHttpProxySettings;
    FMaxRedirects: Integer;
    FMaxAuthRetries: Integer;
    FCookieManager: TclCookieManager;
    FOwnCookieManager: TclCookieManager;
    FAllowCookies: Boolean;
    FAllowCompression: Boolean;
    FRequest: TclHttpRequest;
    FResponseHeader: TclHttpResponseHeader;
    FMethod: string;
    FResponseVersion: TclHttpVersion;
    FOwnRequest: TclHttpRequest;
    FProgressHandled: Boolean;
    FResponseCookies: TclCookieList;
    FOldProxyServer: string;
    FOldProxyPort: Integer;
    FSilentHTTP: Boolean;
    FAuthorization: string;

    FOnSendRequest: TclHttpRequestEvent;
    FOnReceiveResponse: TclHttpResponseEvent;
    FOnRedirect: TclHttpRedirectEvent;
    FOnSendProgress: TclProgressEvent;
    FOnReceiveProgress: TclProgressEvent;
    FOnReceiveHeader: TclHttpHeaderEvent;
    FExpect100Continue: Boolean;

    procedure SetHttpVersion(const Value: TclHttpVersion);
    procedure SetPassword(const Value: string);
    procedure SetUserName(const Value: string);
    procedure InitConnection(ATunnelStatus: TclHttpTunnelStatus);
    procedure PrepareRequestHeader(ATunnelStatus: TclHttpTunnelStatus; ARequestHeader: TStrings; ARequestBody: TStream);
    procedure WriteRequestHeader(ATunnelStatus: TclHttpTunnelStatus;
      ARequestHeader: TStrings; ARequestBody: TStream);
    procedure WriteRequestData(ARequestBody: TStream);
    procedure ReadResponseBody(AResponseHeader: TStrings;
      AExtraSize: Int64; AExtraData, AResponseBody: TStream);
    function ReadResponseHeader(AResponseHeader: TStrings; ARawData: TStream): Boolean;
    function GetResponseLength: Int64;
    function GetKeepAlive: Boolean;
    function GetTunnelStatus: TclHttpTunnelStatus;
    function ExtractStatusCode(ABuffer: TclByteArray; var ADataPos: Integer): Integer;
    function ExtractStatusText(ABuffer: TclByteArray; var ADataPos: Integer): string;
    function ExtractResponseVersion(ABuffer: TclByteArray; var ADataPos: Integer): TclHttpVersion;
    function BasicAuthorization(const AUserName, APassword, AuthorizationField: string; ARequestHeader: TStrings): Boolean;
    function Authorize(const AUserName, APassword, AuthorizationField: string;
      AuthChallenge, ARequestHeader: TStrings; var AStartNewConnection: Boolean): Boolean;
    function Redirect(ARequestHeader, AResponseText: TStrings; var AMethod: string): Boolean;
    procedure RaiseHttpError(AStatusCode: Integer; AResponseHeader, AResponseText: TStrings);
    procedure ReadResponseText(AResponseHeader: TStrings; AExtraSize: Int64; AExtraData: TStream; AResponseText: TStrings);
    procedure LoadResponseStream(AResponseText: TStrings; AResponseBody: TStream);
    procedure ReadResponseStream(AResponseHeader: TStrings; AExtraSize: Int64; AExtraData, AResponseBody: TStream);
    procedure RemoveHeaderTrailer(AHeader: TStrings);
    procedure RemoveRequestLine(AHeader: TStrings);
    procedure SetUserAgent(const Value: string);
    procedure SetAuthorizationType(const Value: TclAuthorizationType);
    procedure SetAllowCaching(const Value: Boolean);
    procedure SetKeepConnection(const Value: Boolean);
    procedure SetAllowRedirects(const Value: Boolean);
    procedure SetProxySettings(const Value: TclHttpProxySettings);
    procedure SetMaxAuthRetries(const Value: Integer);
    procedure SetMaxRedirects(const Value: Integer);
    procedure SetAllowCookies(const Value: Boolean);
    procedure SetAllowCompression(const Value: Boolean);
    function IsUseProxy: Boolean;
    procedure ReadCookies(AResponseHeader: TStrings);
    procedure SetRequest(const Value: TclHttpRequest);
    procedure DoDataSendProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
    procedure DoDataReceiveProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
    function GetUserName_: string;
    function GetPassword: string;
    procedure SetAuthorizationField(const AFieldName, AFieldValue: string; ARequestHeader: TStrings);
    function GetResourcePath: string;
    procedure InternalSendRequest(const AMethod: string; ARequestHeader: TStrings;
      ARequestBody: TStream; AResponseHeader: TStrings; AResponseBody: TStream);
    procedure InitProgress(ABytesProceed, ATotalBytes: Int64);
    procedure ConnectProxy;
    procedure SetCookieManager(const Value: TclCookieManager);
    function GetCookieManager: TclCookieManager;
    procedure SetRequestCookies(ARequestHeader: TStrings);
    procedure SetSilentHTTP(const Value: Boolean);
    procedure SetAuthorization(const Value: string);
    procedure SetExpect100Continue(const Value: Boolean);
    procedure SetCharSet(const Value: string);
  protected
    function GetResponseCharSet: string;
    function GetRequest: TclHttpRequest;
    procedure InternalGet(const AUrl: string; ARequest: TclHttpRequest; AResponseHeader: TStrings; ADestination: TStream); virtual;
    procedure InternalHead(const AUrl: string; AResponseHeader: TStrings); virtual;
    procedure InternalPut(const AUrl, AContentType: string; ASource: TStream; AResponseHeader: TStrings; AResponseBody: TStream); virtual;
    procedure InternalPost(const AUrl: string; ARequest: TclHttpRequest; AResponseHeader: TStrings; AResponseBody: TStream); virtual;
    procedure InternalDelete(const AUrl: string; AResponseHeader: TStrings; AResponseBody: TStream); virtual;
    function GetRedirectMethod(AStatusCode: Integer; const AMethod: string): string; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoDestroy; override;
    function GetDefaultPort: Integer; override;
    procedure OpenConnection(const AServer: string; APort: Integer); override;
    
    procedure DoSendRequest(const AMethod, AUrl: string; ARequestHeader: TStrings); dynamic;
    procedure DoReceiveHeader(const AMethod, AUrl: string;
      AResponseHeader: TStrings; ACookies: TclCookieList; var Cancel: Boolean); dynamic;
    procedure DoReceiveResponse(const AMethod, AUrl: string;
      AResponseHeader: TStrings; ACookies: TclCookieList); dynamic;
    procedure DoSendProgress(ABytesProceed, ATotalBytes: Int64); dynamic;
    procedure DoReceiveProgress(ABytesProceed, ATotalBytes: Int64); dynamic;
    procedure DoRedirect(ARequestHeader: TStrings; AStatusCode: Integer;
      AResponseHeader: TclHttpResponseHeader; AResponseText: TStrings;
      var AMethod: string; var CanRedirect, Handled: Boolean); dynamic;
  public
    constructor Create(AOwner: TComponent); override;

    procedure SendRequest(const AMethod, AUrl: string; ARequestHeader: TStrings;
      ARequestBody: TStream; AResponseHeader: TStrings; AResponseBody: TStream); overload;
    procedure SendRequest(const AMethod, AUrl: string;
      ARequest: TclHttpRequest; AResponseHeader: TStrings; AResponseBody: TStream); overload;

    procedure SendRequest(const AMethod, AUrl: string; ARequestHeader: TStrings;
      ARequestBody: TStream; AResponseBody: TStream); overload;
    procedure SendRequest(const AMethod, AUrl: string;
      ARequest: TclHttpRequest; AResponseBody: TStream); overload;

    procedure Get(const AUrl: string; ADestination: TStream); overload;
    procedure Get(const AUrl: string; ADestination: TStrings); overload;
    procedure Get(const AUrl: string; AResponseHeader: TStrings; AResponseBody: TStream); overload;
    procedure Get(const AUrl: string; ARequest: TclHttpRequest; ADestination: TStream); overload;
    procedure Get(const AUrl: string; ARequest: TclHttpRequest; ADestination: TStrings); overload;
    procedure Get(const AUrl: string; ARequest: TclHttpRequest; AResponseHeader: TStrings; AResponseBody: TStream); overload;

    procedure Head(const AUrl: string); overload;
    procedure Head(const AUrl: string; AResponseHeader: TStrings); overload;

    procedure Put(const AUrl, AContentType: string; ASource: TStream); overload;
    procedure Put(const AUrl, AContentType: string; ASource: TStrings); overload;
    procedure Put(const AUrl, AContentType: string; ASource, AResponseBody: TStream); overload;
    procedure Put(const AUrl, AContentType: string; ASource: TStream; AResponseBody: TStrings); overload;
    procedure Put(const AUrl, AContentType: string; ASource, AResponseBody: TStrings); overload;
    procedure Put(const AUrl, AContentType: string; ASource: TStream; AResponseHeader: TStrings; AResponseBody: TStrings); overload;

    procedure Put(const AUrl: string; ASource: TStream); overload;
    procedure Put(const AUrl: string; ASource: TStrings); overload;
    procedure Put(const AUrl: string; ASource, AResponseBody: TStream); overload;
    procedure Put(const AUrl: string; ASource: TStream; AResponseBody: TStrings); overload;
    procedure Put(const AUrl: string; ASource, AResponseBody: TStrings); overload;
    procedure Put(const AUrl: string; ASource: TStream; AResponseHeader: TStrings; AResponseBody: TStrings); overload;

    procedure Post(const AUrl: string; AResponseBody: TStream); overload;
    procedure Post(const AUrl: string; AResponseBody: TStrings); overload;
    procedure Post(const AUrl: string; ARequest: TclHttpRequest; AResponseBody: TStream); overload;
    procedure Post(const AUrl: string; ARequest: TclHttpRequest; AResponseBody: TStrings); overload;
    procedure Post(const AUrl: string; ARequest: TclHttpRequest; AResponseHeader: TStrings; AResponseBody: TStream); overload;

    procedure Delete(const AUrl: string); overload;
    procedure Delete(const AUrl: string; AResponseHeader: TStrings); overload;
    procedure Delete(const AUrl: string; AResponseHeader, AResponseBody: TStrings); overload;
    procedure Delete(const AUrl: string; AResponseHeader: TStrings; AResponseBody: TStream); overload;
    procedure Delete(const AUrl: string; AResponseBody: TStream); overload;

    property Url: TclUrlParser read FUrl;
    property StatusCode: Integer read FStatusCode;
    property StatusText: string read FStatusText;
    property ResponseVersion: TclHttpVersion read FResponseVersion;
    property ResponseHeader: TclHttpResponseHeader read FResponseHeader;
    property ResponseCookies: TclCookieList read FResponseCookies;
  published
    property Request: TclHttpRequest read FRequest write SetRequest;
    property HttpVersion: TclHttpVersion read FHttpVersion write SetHttpVersion default hvHttp1_1;

    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;
    property Authorization: string read FAuthorization write SetAuthorization;

    property AuthorizationType: TclAuthorizationType read FAuthorizationType write SetAuthorizationType default atAutoDetect;
    property UserAgent: string read FUserAgent write SetUserAgent;
    property KeepConnection: Boolean read FKeepConnection write SetKeepConnection default True;
    property AllowCaching: Boolean read FAllowCaching write SetAllowCaching default True;
    property AllowRedirects: Boolean read FAllowRedirects write SetAllowRedirects default True;
    property AllowCookies: Boolean read FAllowCookies write SetAllowCookies default True;
    property AllowCompression: Boolean read FAllowCompression write SetAllowCompression default True;
    property ProxySettings: TclHttpProxySettings read FProxySettings write SetProxySettings;
    property MaxRedirects: Integer read FMaxRedirects write SetMaxRedirects default 15;
    property MaxAuthRetries: Integer read FMaxAuthRetries write SetMaxAuthRetries default 5;
    property CookieManager: TclCookieManager read FCookieManager write SetCookieManager;
    property Port default DefaultHttpPort;
    property TLSFlags default [tfUseSSL3, tfUseTLS, tfUseTLS11, tfUseTLS12];
    property SilentHTTP: Boolean read FSilentHTTP write SetSilentHTTP default False;
    property Expect100Continue: Boolean read FExpect100Continue write SetExpect100Continue default False;
    property CharSet: string read FCharSet write SetCharSet;

    property OnSendRequest: TclHttpRequestEvent read FOnSendRequest write FOnSendRequest;
    property OnReceiveHeader: TclHttpHeaderEvent read FOnReceiveHeader write FOnReceiveHeader;
    property OnReceiveResponse: TclHttpResponseEvent read FOnReceiveResponse write FOnReceiveResponse;
    property OnSendProgress: TclProgressEvent read FOnSendProgress write FOnSendProgress;
    property OnReceiveProgress: TclProgressEvent read FOnReceiveProgress write FOnReceiveProgress;
    property OnRedirect: TclHttpRedirectEvent read FOnRedirect write FOnRedirect;
  end;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsHttpDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

implementation

uses
  clZLibStreams, clTranslator, clStreams{$IFDEF LOGGER}, clLogger{$ENDIF};

const
  httpVersions: array[TclHttpVersion] of string = ('HTTP/1.0', 'HTTP/1.1');
  cacheFields: array[TclHttpVersion] of string = ('Pragma', 'Cache-Control');
  connFields: array[Boolean] of string = ('Connection', 'Proxy-Connection');
  
{ TclHttp }

constructor TclHttp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  FResponseHeader := TclHttpResponseHeader.Create();
  FResponseCookies := TclCookieList.Create(nil, TclCookieItem);
  FProxySettings := TclHttpProxySettings.Create();
  FUrl := TclUrlParser.Create();
  
  TLSFlags := [tfUseSSL3, tfUseTLS, tfUseTLS11, tfUseTLS12];
  FHttpVersion := hvHttp1_1;
  FAuthorizationType := atAutoDetect;
  FUserAgent := DefaultInternetAgent;
  FKeepConnection := True;
  FAllowCaching := True;
  FAllowRedirects := True;
  FAllowCookies := True;
  FAllowCompression := True;
  FMaxRedirects := 15;
  FMaxAuthRetries := 5;
  FSilentHTTP := False;
  FExpect100Continue := False;
end;

procedure TclHttp.DoDestroy;
begin
  FOwnRequest.Free();
  FOwnCookieManager.Free();
  FUrl.Free();
  FProxySettings.Free();
  FResponseCookies.Free();
  FResponseHeader.Free();

  inherited DoDestroy();
end;

procedure TclHttp.ConnectProxy;
var
  reqHdr, respHdr: TStrings;
  nullBody: TStream;
  oldCompression: Boolean;
  oldCookies: Boolean;
  oldVersion: TclHttpVersion;
  oldMethod: string;
begin
  reqHdr := nil;
  respHdr := nil;
  nullBody := nil;
  oldCompression := AllowCompression;
  oldCookies := AllowCookies;
  oldVersion := HttpVersion;
  oldMethod := FMethod;
  try
    reqHdr := TStringList.Create();
    respHdr := TStringList.Create();
    nullBody := TclNullStream.Create();

    HttpVersion := hvHttp1_0;
    KeepConnection := True;
    AllowCompression := False;
    AllowCaching := False;
    AllowCookies := False;

    InternalSendRequest('CONNECT', reqHdr, nullBody, respHdr, nullBody);
  finally
    FMethod := oldMethod;
    HttpVersion := oldVersion;
    AllowCookies := oldCookies;
    AllowCompression := oldCompression;
    nullBody.Free();
    respHdr.Free();
    reqHdr.Free();
  end;
end;

procedure TclHttp.InitConnection(ATunnelStatus: TclHttpTunnelStatus);
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
    if (not IsHttpDemoDisplayed) and (not IsHttpRequestDemoDisplayed)
      and (not IsEncoderDemoDisplayed) and (not IsCertDemoDisplayed)
      and (not IsHtmlDemoDisplayed) and (not IsEncryptorDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpDemoDisplayed := True;
    IsHttpRequestDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'InitConnection');{$ENDIF}

  if IsUseProxy() then
  begin
    if (FOldProxyServer <> ProxySettings.Server) or (FOldProxyPort <> ProxySettings.Port) then
    begin
      Close();
    end;

    FOldProxyServer := ProxySettings.Server;
    FOldProxyPort := ProxySettings.Port;
  end;

  if (Url.Host <> '') and (Url.Host <> '*') then
  begin
    if (Server <> Url.Host) or (Port <> Url.Port) then
    begin
      Close();
    end;

    Server := Url.Host;
    Port := Url.Port;
  end;

  if IsUseProxy() then
  begin
    if (Url.UrlType = utHTTPS) and (ATunnelStatus <> htConnect) then
    begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InitConnection ConnectProxy');{$ENDIF}
      ConnectProxy();
      StartTls();
    end else
    begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InitConnection TunnelProxy');{$ENDIF}
      UseTLS := ctNone;
    end;
  end else
  begin
    if (Url.UrlType = utHTTPS) then
    begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InitConnection HTTPS');{$ENDIF}
      UseTLS := ctImplicit;
    end else
    begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InitConnection HTTP');{$ENDIF}
      UseTLS := ctNone;
    end;
  end;

  Open();
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'InitConnection'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'InitConnection', E); raise; end; end;{$ENDIF}
end;

procedure TclHttp.PrepareRequestHeader(ATunnelStatus: TclHttpTunnelStatus;
  ARequestHeader: TStrings; ARequestBody: TStream);

  function GetPortIfNeed(APort: Integer): string;
  begin
    if (APort <> 80) and (APort <> 443) then
    begin
      Result := Format(':%d', [APort]);
    end else
    begin
      Result := '';
    end;
  end;

var
  fieldList: TclHeaderFieldList;
  path, host, contentLength: string;
  requestSize: Int64;
begin
  requestSize := ARequestBody.Size - ARequestBody.Position;

  RemoveRequestLine(ARequestHeader);
  RemoveHeaderTrailer(ARequestHeader);

  if IsUseProxy() then
  begin
    case ATunnelStatus of
      htConnect: path := Format('%s:%d', [Url.Host, Url.Port]);
      htTunnel: path := Url.AbsolutePath;
    else
      path := Url.AbsoluteUri;
    end;
  end else
  begin
    path := Url.AbsolutePath;
  end;
  if (path = '') then
  begin
    path := '/';
  end;
  ARequestHeader.Insert(0, Format('%s %s %s', [FMethod, path, httpVersions[HttpVersion]]));

  fieldList := TclHeaderFieldList.Create();
  try
    fieldList.Parse(0, ARequestHeader);
    fieldList.RemoveField('Host');

    if AllowCompression then
    begin
      fieldList.AddFieldIfNotExist('Accept-Encoding', 'gzip');
    end;

    if (Url.Host <> '') then
    begin
      host := Url.Host + GetPortIfNeed(Url.Port);
    end else
    begin
      host := Server + GetPortIfNeed(Port);
    end;
    fieldList.AddField('Host', host);

    fieldList.AddFieldIfNotExist('User-Agent', UserAgent);

    contentLength := fieldList.GetFieldValue('Content-Length');
    if ((StrToInt64Def(contentLength, 0) > 0) and (requestSize = 0)) then
    begin
      fieldList.RemoveField('Content-Length');
      fieldList.RemoveField('Content-Type');
    end else
    if ((contentLength = '') and ((ATunnelStatus = htConnect) or (requestSize > 0))) then
    begin
      fieldList.AddField('Content-Length', IntToStr(requestSize));
    end else
    if ((contentLength = '') and (requestSize = 0) and SameText('POST', FMethod)) then
    begin
      fieldList.AddField('Content-Length', '0');
    end;

    if not AllowCaching then
    begin
      fieldList.AddFieldIfNotExist(cacheFields[HttpVersion], 'no-cache');
    end;

    if KeepConnection then
    begin
      fieldList.AddFieldIfNotExist(connFields[IsUseProxy()], 'Keep-Alive');
    end;

    fieldList.RemoveField('Expect');
    if (Expect100Continue and (requestSize > 0)) then
    begin
      fieldList.AddField('Expect', '100-continue');
    end;

    SetRequestCookies(ARequestHeader);

    ARequestHeader.Add('');
  finally
    fieldList.Free();
  end;
end;

procedure TclHttp.SetRequestCookies(ARequestHeader: TStrings);
var
  cookies: TclCookieList;
begin
  if AllowCookies then
  begin
    cookies := TclCookieList.Create(nil, TclCookieItem);
    try
      GetCookieManager().GetCookies(cookies, Url.Host, Url.AbsolutePath, Url.Port, Url.UrlType = utHTTPS);
      cookies.SetRequestCookies(ARequestHeader);
    finally
      cookies.Free();
    end;
  end;
end;

procedure TclHttp.SetSilentHTTP(const Value: Boolean);
begin
  if (FSilentHTTP <> Value) then
  begin
    FSilentHTTP := Value;
    Changed();
  end;
end;

function TclHttp.GetTunnelStatus: TclHttpTunnelStatus;
begin
  if IsUseProxy() and (Url.UrlType = utHTTPS) then
  begin
    if SameText('CONNECT', FMethod) then
    begin
      Result := htConnect;
    end else
    begin
      Result := htTunnel;
    end;
  end else
  begin
    Result := htNone;
  end;
end;

procedure TclHttp.WriteRequestHeader(ATunnelStatus: TclHttpTunnelStatus;
  ARequestHeader: TStrings; ARequestBody: TStream);
begin
  InitConnection(ATunnelStatus);

  PrepareRequestHeader(ATunnelStatus, ARequestHeader, ARequestBody);
  Connection.WriteString(ARequestHeader.Text, 'us-ascii');
end;

procedure TclHttp.WriteRequestData(ARequestBody: TStream);
begin
  if (ARequestBody.Size > 0) then
  begin
    InitProgress(ARequestBody.Position, ARequestBody.Size);
    Connection.OnProgress := DoDataSendProgress;
    try
      Connection.WriteData(ARequestBody);
      if not FProgressHandled then
      begin
        DoSendProgress(ARequestBody.Size, ARequestBody.Size);
      end;
    finally
      Connection.OnProgress := nil;
    end;
  end;
end;

function TclHttp.ExtractStatusCode(ABuffer: TclByteArray; var ADataPos: Integer): Integer;
var
  ind: Integer;
  s: string;
  lexem: TclByteArray;
begin
  SetLength(lexem, 1);
  lexem[0] := 32;

  Result := 0;
  ind := BytesPos(lexem, ABuffer, ADataPos, Length(ABuffer));
  if (ind > -1) then
  begin
    s := TclTranslator.GetString(ABuffer, ADataPos, ind - ADataPos, 'us-ascii');
    ADataPos := ind;
    Result := StrToIntDef(s, 0);
  end;
end;

function TclHttp.ExtractStatusText(ABuffer: TclByteArray; var ADataPos: Integer): string;
var
  ind: Integer;
  lexem: TclByteArray;
begin
  SetLength(lexem, 1);
  lexem[0] := 10;

  ind := BytesPos(lexem, ABuffer, ADataPos, Length(ABuffer));
  if (ind <= 0) then
  begin
    ind := Length(ABuffer);
  end;
  Result := Trim(TclTranslator.GetString(ABuffer, ADataPos, ind - ADataPos, 'us-ascii'));
  ADataPos := ind;
end;

function TclHttp.ExtractResponseVersion(ABuffer: TclByteArray; var ADataPos: Integer): TclHttpVersion;
var
  ind: Integer;
  s: string;
  lexem: TclByteArray;
begin
  SetLength(lexem, 1);
  lexem[0] := 32;

  Result := HttpVersion;
  ind := BytesPos(lexem, ABuffer, ADataPos, Length(ABuffer));
  if (ind > -1) then
  begin
    s := Trim(UpperCase(TclTranslator.GetString(ABuffer, 0, ind - ADataPos, 'us-ascii')));
    ADataPos := ind;
    for Result := Low(TclHttpVersion) to High(TclHttpVersion) do
    begin
      if (httpVersions[Result] = s) then
      begin
        Exit;
      end;
    end;
    Result := HttpVersion;
  end;
end;

function TclHttp.ReadResponseHeader(AResponseHeader: TStrings; ARawData: TStream): Boolean;

  procedure LoadTextFromStream(AStream: TStream; ACount: Integer; AList: TStrings);
  var
    buf: TclByteArray;
  begin
    Assert(ACount > 0);
    SetLength(buf, ACount);
    AStream.Read(buf[0], ACount);
    AList.Text := TclTranslator.GetString(buf, 0, ACount, 'us-ascii');
  end;

  function GetRawBuffer(AStream: TStream): TclByteArray;
  var
    oldPos: Int64;
  begin
    oldPos := AStream.Position;
    try
      AStream.Position := 0;
      SetLength(Result, AStream.Size);
      if (Length(Result) > 0) then
      begin
        AStream.Read(Result[0], Length(Result));
      end;
    finally
      AStream.Position := oldPos;
    end;
  end;

var
  ind, hdrStart, statusLineInd, eofLength: Integer;
  oldBytesToProceed: Int64;
  EndOfHeader, EndOfHeader2, rawBuffer: TclByteArray;
begin
{$IFNDEF DELPHI2005}rawBuffer := nil;{$ENDIF}
  SetLength(EndOfHeader, 4);
  EndOfHeader[0] := $D; EndOfHeader[1] := $A;   EndOfHeader[2] := $D; EndOfHeader[3] := $A;
  SetLength(EndOfHeader2, 2);
  EndOfHeader2[0] := $A; EndOfHeader2[1] := $A;

{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'ReadResponseHeader');{$ENDIF}
  ARawData.Size := 0;
  hdrStart := 0;
  FStatusCode := 0;
  FStatusText := '';
  FResponseVersion := HttpVersion;

  Connection.IsReadUntilClose := False;
  oldBytesToProceed := Connection.BytesToProceed;
  Connection.InitProgress(0, 0);
  Connection.BytesToProceed := BatchSize;
  repeat
    try
      Connection.ReadData(ARawData);
    finally
      Connection.BytesToProceed := oldBytesToProceed;
    end;
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ReadResponseHeader, after ReadData, Connection.BytesProceed=%d', nil, [Connection.BytesProceed]);{$ENDIF}

    rawBuffer := GetRawBuffer(ARawData);

    repeat
      ind := BytesPos(EndOfHeader, rawBuffer, hdrStart, Length(rawBuffer));
      eofLength := Length(EndOfHeader);
      if(ind < 0) then
      begin
        ind := BytesPos(EndOfHeader2, rawBuffer, hdrStart, Length(rawBuffer));
        eofLength := Length(EndOfHeader2);
      end;
      if (ind > 0) then
      begin
        statusLineInd := hdrStart;
        FResponseVersion := ExtractResponseVersion(rawBuffer, statusLineInd);
        Inc(statusLineInd);
        FStatusCode := ExtractStatusCode(rawBuffer, statusLineInd);
        Inc(statusLineInd);
        FStatusText := ExtractStatusText(rawBuffer, statusLineInd);
        if (FStatusCode = 100) then
        begin
          hdrStart := ind + eofLength;
        end else
        begin
          Break;
        end;
      end else
      begin
        Break;
      end;
    until False;
  until (FStatusCode <> 0) and (FStatusCode <> 100);

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ReadResponseHeader, after loop');{$ENDIF}

  ARawData.Position := hdrStart;
  LoadTextFromStream(ARawData, ind + eofLength - hdrStart, AResponseHeader);
  ResponseHeader.ParseHeader(AResponseHeader);
  ReadCookies(AResponseHeader);

  Result := False;
  DoReceiveHeader(FMethod, Url.AbsoluteUri, AResponseHeader, FResponseCookies, Result);
  Result := not Result;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'ReadResponseHeader'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'ReadResponseHeader', E); raise; end; end;{$ENDIF}
end;

procedure TclHttp.LoadResponseStream(AResponseText: TStrings; AResponseBody: TStream);
begin
  if (AResponseBody <> nil) then
  begin
    TclStringsUtils.SaveStrings(AResponseText, AResponseBody, GetResponseCharSet());
  end;
end;

procedure TclHttp.ReadResponseStream(AResponseHeader: TStrings; AExtraSize: Int64; AExtraData, AResponseBody: TStream);
var
  nullResp: TStream;
begin
  if (SameText('HEAD', FMethod)) then
  begin
    Exit;
  end;

  nullResp := nil;
  try
    if (AResponseBody = nil) then
    begin
      nullResp := TclNullStream.Create();
      AResponseBody := nullResp;
    end;

    ReadResponseBody(AResponseHeader, AExtraSize, AExtraData, AResponseBody);
  finally
    nullResp.Free();
  end;
end;

procedure TclHttp.ReadResponseBody(AResponseHeader: TStrings;
  AExtraSize: Int64; AExtraData, AResponseBody: TStream);
var
  totalSize, bodySize, oldProceed: Int64;
  chunkedBody: TclChunkedStream;
  dest, compressor: TStream;
begin
  {$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'ReadResponseBody');{$ENDIF}

  compressor := nil;
  Connection.OnProgress := DoDataReceiveProgress;
  try
    if (system.Pos('gzip', LowerCase(ResponseHeader.ContentEncoding)) > 0) then
    begin
      compressor := TclGZipInflateStream.Create(AResponseBody);
      dest := compressor;
    end else
    begin
      dest := AResponseBody;
    end;

    if SameText('chunked', ResponseHeader.TransferEncoding) then
    begin
      chunkedBody := TclChunkedStream.Create(dest);
      try
        if (AExtraSize > 0) then
        begin
          chunkedBody.CopyFrom(AExtraData, AExtraSize);
        end;

        InitProgress(AExtraSize, -1);

        if Active then
        begin
          while not chunkedBody.IsCompleted do
          begin
            Connection.ReadData(chunkedBody);
          end;
        end;
        if not FProgressHandled then
        begin
          DoReceiveProgress(Connection.BytesProceed, -1);
        end;
      finally
        chunkedBody.Free();
      end;
    end else
    begin
      if (AExtraSize > 0) then
      begin
        dest.CopyFrom(AExtraData, AExtraSize);
      end;

      bodySize := GetResponseLength();
      totalSize := bodySize;
      InitProgress(AExtraSize, totalSize);
      if (bodySize < 0) then
      begin
        if Active then
        begin
          Connection.IsReadUntilClose := True;
          Connection.ReadData(dest);
          {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ReadResponseBody IsReadUntilClose');{$ENDIF}
        end;
      end else
      begin
        oldProceed := Connection.BytesProceed;
        bodySize := bodySize - AExtraSize;
        if Active then
        begin
          {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ReadResponseBody before while, %d ', nil, [bodySize]);{$ENDIF}
          while ((Connection.BytesProceed - oldProceed) < bodySize) do
          begin
            Connection.ReadData(dest);
            {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ReadResponseBody after ReadData, %d ', nil, [Connection.BytesProceed]);{$ENDIF}
          end;
        end;
      end;
      if not FProgressHandled then
      begin
        DoReceiveProgress(totalSize, totalSize);
      end;
    end;
  finally
    Connection.OnProgress := nil;
    compressor.Free();
{$IFDEF LOGGER} clPutLogMessage(Self, edInside, 'ReadResponseBody, received response', AResponseBody, 0);{$ENDIF}
  end;

  DoReceiveResponse(FMethod, Url.AbsoluteUri, AResponseHeader, FResponseCookies);

  {$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'ReadResponseBody'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'ReadResponseBody', E); raise; end; end;{$ENDIF}
end;

procedure TclHttp.ReadResponseText(AResponseHeader: TStrings;
  AExtraSize: Int64; AExtraData: TStream; AResponseText: TStrings);
var
  rawData: TStream;
begin
  if (SameText('HEAD', FMethod)) then
  begin
    AResponseText.Clear();
    Exit;
  end;

  rawData := TMemoryStream.Create();
  try
    ReadResponseBody(AResponseHeader, AExtraSize, AExtraData, rawData);
    rawData.Position := 0;
    TclStringsUtils.LoadStrings(rawData, AResponseText, GetResponseCharSet());
  finally
    rawData.Free();
  end;
end;

function TclHttp.GetResponseCharSet: string;
begin
  Result := ResponseHeader.CharSet;
  if (Result = '') then
  begin
    Result := CharSet;
  end;
end;

function TclHttp.GetResponseLength: Int64;
begin
  if ((StatusCode = 204) and (ResponseHeader.ContentLength = '')) then
  begin
    Result := 0;
  end else
  if SameText('CONNECT', FMethod) and (StatusCode = 200) then
  begin
    Result := 0;
  end else
  if SameText('HEAD', FMethod) or (StatusCode = 304) then
  begin
    Result := 0;
  end else
  if ((HttpVersion = hvHttp1_0) or (ResponseVersion = hvHttp1_0))
    and (ResponseHeader.ContentLength = '') then
  begin
    Result := -1;
  end else
  if (ResponseHeader.ContentLength = '') and ((StatusCode and 200) = 200) then
  begin
    Result := -1;
  end else
  begin
    Result := StrToInt64Def(Trim(ResponseHeader.ContentLength), 0);
  end;
end;

function TclHttp.GetKeepAlive: Boolean;
begin
  if (HttpVersion = hvHttp1_1) and (ResponseVersion = hvHttp1_1) then
  begin
    if IsUseProxy() then
    begin
      Result := not SameText('close', ResponseHeader.ProxyConnection);
    end else
    begin
      Result := not SameText('close', ResponseHeader.Connection);
    end;
{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, 'GetKeepAlive inside if, Result: ' + IntToStr(Integer(Result)));
{$ENDIF}
  end else
  begin
    if IsUseProxy() then
    begin
      Result := SameText('Keep-Alive', ResponseHeader.ProxyConnection);
    end else
    begin
      Result := SameText('Keep-Alive', ResponseHeader.Connection);
    end;
{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, 'GetKeepAlive inside else, Result: ' + IntToStr(Integer(Result)));
{$ENDIF}
  end;
  Result := Result and KeepConnection;
end;

procedure TclHttp.RemoveHeaderTrailer(AHeader: TStrings);
begin
  while (AHeader.Count > 0) and (AHeader[AHeader.Count - 1] = '') do
  begin
    AHeader.Delete(AHeader.Count - 1);
  end;
end;

procedure TclHttp.RemoveRequestLine(AHeader: TStrings);
var
  space, colon: Integer;
begin
  if (AHeader.Count > 0) then
  begin
    space := system.Pos(#32, AHeader[0]);
    colon := system.Pos(':', AHeader[0]);
    if (space <> 0) then
    begin
      if (colon = 0) or (space < colon) then
      begin
        AHeader.Delete(0);
      end;
    end;
  end;
end;

function TclHttp.BasicAuthorization(const AUserName, APassword, AuthorizationField: string;
  ARequestHeader: TStrings): Boolean;
var
  authChallenge: TStrings;
  oldKeepConnection, temp: Boolean;
begin
  oldKeepConnection := KeepConnection;
  authChallenge := TStringList.Create();
  try
    authChallenge.Add('Basic');
    Result := Authorize(AUserName, APassword, AuthorizationField, authChallenge, ARequestHeader, temp);
  finally
    authChallenge.Free();
    KeepConnection := oldKeepConnection;
  end;
end;

procedure TclHttp.SetAuthorizationField(const AFieldName, AFieldValue: string;
  ARequestHeader: TStrings);
var
  fieldList: TclHeaderFieldList;
begin
  RemoveHeaderTrailer(ARequestHeader);
  fieldList := TclHeaderFieldList.Create();
  try
    fieldList.Parse(0, ARequestHeader);
    fieldList.RemoveField(AFieldName);
    fieldList.AddField(AFieldName, AFieldValue);
  finally
    fieldList.Free();
  end;
end;

function TclHttp.Authorize(const AUserName, APassword,
  AuthorizationField: string; AuthChallenge, ARequestHeader: TStrings;
  var AStartNewConnection: Boolean): Boolean;
var
  auth: TclHttpAuthorization;
begin
  AStartNewConnection := False;
  auth := TclHttpAuthorization.Authorize(Url, FMethod, AUserName, APassword, AuthChallenge, Self);
  Result := (auth <> nil);
  if Result then
  begin
    AStartNewConnection := auth.StartNewConnection;
    SetAuthorizationField(AuthorizationField, auth.AuthValue, ARequestHeader);
    KeepConnection := True;
  end;
end;

procedure TclHttp.Delete(const AUrl: string; AResponseHeader: TStrings);
begin
  InternalDelete(AUrl, AResponseHeader, nil);
end;

procedure TclHttp.DoRedirect(ARequestHeader: TStrings; AStatusCode: Integer;
  AResponseHeader: TclHttpResponseHeader; AResponseText: TStrings; var AMethod: string;
  var CanRedirect, Handled: Boolean);
begin
  if Assigned(OnRedirect) then
  begin
    OnRedirect(Self, ARequestHeader, AStatusCode,
      AResponseHeader, AResponseText, AMethod, CanRedirect, Handled);
  end;
end;

function TclHttp.GetResourcePath: string;
var
  ind: Integer;
begin
  Result := LowerCase(Url.AbsoluteUri);
  ind := LastDelimiter('/', Result);
  Result := system.Copy(Result, 1, ind);
  ind := Length(Result);
  if (ind > 0) and (Result[ind] <> '/') then
  begin
    Result := Result + '/';
  end;
end;

function TclHttp.GetRedirectMethod(AStatusCode: Integer; const AMethod: string): string;
begin
  if (StatusCode = 302) or (StatusCode = 303) then
  begin
    Result := 'GET';
  end else
  begin
    Result := AMethod;
  end;
end;

function TclHttp.GetRequest: TclHttpRequest;
begin
  Result := Request;
  if (Result = nil) then
  begin
    if (FOwnRequest = nil) then
    begin
      FOwnRequest := TclHttpRequest.Create(nil);
    end;
    Result := FOwnRequest;

    Result.Clear();
  end;

  if (CharSet <> '') then
  begin
    Result.Header.CharSet := CharSet;
  end;
end;

function TclHttp.Redirect(ARequestHeader, AResponseText: TStrings;
  var AMethod: string): Boolean;
var
  location: string;
  handled: Boolean;
  oldPath: string;
  fieldList: TclHeaderFieldList;
begin
  location := ResponseHeader.Location;

  Result := False;
  handled := False;

  oldPath := GetResourcePath();

  DoRedirect(ARequestHeader, StatusCode, ResponseHeader, AResponseText, AMethod, Result, handled);

  if not handled and (location <> '') then
  begin
    Result := (Url.Parse(Url.CombineUrl(location, Url.AbsoluteUri, CharSet), CharSet) <> '');
    if Result then
    begin
      AMethod := GetRedirectMethod(StatusCode, AMethod);

      if (system.Pos(oldPath, GetResourcePath()) <> 1) then
      begin
        fieldList := TclHeaderFieldList.Create();
        try
          fieldList.Parse(0, ARequestHeader);
          fieldList.RemoveField('Authorization');
        finally
          fieldList.Free();
        end;
      end;
    end;
  end;
end;

procedure TclHttp.RaiseHttpError(AStatusCode: Integer; AResponseHeader, AResponseText: TStrings);
var
  msg: string;
begin
  msg := '';
  if (AResponseHeader.Count > 0) then
  begin
    msg := AResponseHeader[0];
  end;
  raise EclHttpError.Create(msg, AStatusCode, AResponseText.Text);
end;

procedure TclHttp.ReadCookies(AResponseHeader: TStrings);
begin
  FResponseCookies.GetResponseCookies(AResponseHeader, Url.Host, Url.AbsolutePath, Url.Port);
  if AllowCookies then
  begin
    GetCookieManager().AddCookies(FResponseCookies);
  end;
end;

procedure TclHttp.InternalSendRequest(const AMethod: string;
  ARequestHeader: TStrings; ARequestBody: TStream;
  AResponseHeader: TStrings; AResponseBody: TStream);
var
  extraSize: Int64;
  redirects, authRetries, proxyRetries: Integer;
  rawData: TStream;
  reqHeader, respText: TStrings;
  needClose, startNewConnection: Boolean;
  requestPos: Int64;
  nullBody: TStream;
  newMethod: string;
  tunnelStatus: TclHttpTunnelStatus;
  wasActive: Boolean;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'SendRequest, TimeOut: %d', nil, [TimeOut]);{$ENDIF}
  reqHeader := nil;
  rawData := nil;
  respText := nil;
  nullBody := nil;
  try
    reqHeader := TStringList.Create();
    rawData := TMemoryStream.Create();
    respText := TStringList.Create();

    reqHeader.Assign(ARequestHeader);

    FMethod := AMethod;

    if (AuthorizationType = atBasic) then
    begin
      BasicAuthorization(GetUserName_(), GetPassword(), 'Authorization', reqHeader);
    end else
    if (Authorization <> '') then
    begin
      SetAuthorizationField('Authorization', Authorization, reqHeader);
    end;

    if IsUseProxy() and (ProxySettings.AuthorizationType = atBasic) then
    begin
      BasicAuthorization(ProxySettings.UserName, ProxySettings.Password,
        'Proxy-Authorization', reqHeader);
    end;

    requestPos := ARequestBody.Position;
    needClose := False;
    redirects := 0;
    authRetries := 0;
    proxyRetries := 0;
    tunnelStatus := htNone;
    try
      repeat
        tunnelStatus := GetTunnelStatus();
        wasActive := Active;
        try
          ARequestBody.Position := requestPos;

          WriteRequestHeader(tunnelStatus, reqHeader, ARequestBody);

          WriteRequestData(ARequestBody);

          DoSendRequest(FMethod, Url.AbsoluteUri, reqHeader);

          if not ReadResponseHeader(AResponseHeader, rawData) then
          begin
            needClose := True;
            Break;
          end;
        except
          on E: EclSocketError do
          begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalSendRequest, re-open the connection, error code: %d', E, [E.ErrorCode]);{$ENDIF}
            if (not wasActive) or
              ((E.ErrorCode <> 10053) and (E.ErrorCode <> 10038)) then raise;
            Close();
            continue;
          end;
        end;

        extraSize := rawData.Size - rawData.Position;
        needClose := not GetKeepAlive();

        if ((StatusCode div 100 ) = 3) and (StatusCode <> 304) and (StatusCode <> 305) then
        begin
          Inc(redirects);
          ReadResponseText(AResponseHeader, extraSize, rawData, respText);

          if (MaxRedirects > 0) and (redirects > MaxRedirects) then
          begin
            if SilentHTTP then
            begin
              LoadResponseStream(respText, AResponseBody);
              Break;
            end else
            begin
              RaiseHttpError(StatusCode, AResponseHeader, respText);
            end;
          end;

          newMethod := FMethod;
          if not (AllowRedirects and Redirect(reqHeader, respText, newMethod)) then
          begin
            if SilentHTTP then
            begin
              LoadResponseStream(respText, AResponseBody);
              Break;
            end else
            begin
              RaiseHttpError(StatusCode, AResponseHeader, respText);
            end;
          end;

          if SameText('GET', newMethod) then
          begin
            if (nullBody = nil) then
            begin
              nullBody := TclNullStream.Create();
            end;
            ARequestBody := nullBody;
          end;

          {$IFDEF LOGGER}
            clPutLogMessage(Self, edInside, 'SendRequest new Method: '
              + newMethod + '; old Method: ' + FMethod + '; need clode: ' + IntToStr(Integer(needClose)));
          {$ENDIF}
          FMethod := newMethod;

          if IsUseProxy() then
          begin
            needClose := True;
          end;
        end else
        if (StatusCode = 401) then
        begin
          Inc(authRetries);
          ReadResponseText(AResponseHeader, extraSize, rawData, respText);

          if (Authorization <> '')
            or ((MaxAuthRetries > 0) and (authRetries > MaxAuthRetries)) then
          begin
            if SilentHTTP then
            begin
              LoadResponseStream(respText, AResponseBody);
              Break;
            end else
            begin
              RaiseHttpError(StatusCode, AResponseHeader, respText);
            end;
          end;

          if not Authorize(GetUserName_(), GetPassword(),
            'Authorization', ResponseHeader.Authenticate, reqHeader, startNewConnection) then
          begin
            if SilentHTTP then
            begin
              LoadResponseStream(respText, AResponseBody);
              Break;
            end else
            begin
              RaiseHttpError(StatusCode, AResponseHeader, respText);
            end;
          end;

          if (authRetries = 1) and startNewConnection then
          begin
            needClose := True;
          end;
        end else
        if (StatusCode = 407) then
        begin
          Inc(proxyRetries);
          ReadResponseText(AResponseHeader, extraSize, rawData, respText);

          if (MaxAuthRetries > 0) and (proxyRetries > MaxAuthRetries) then
          begin
            if SilentHTTP then
            begin
              LoadResponseStream(respText, AResponseBody);
              Break;
            end else
            begin
              RaiseHttpError(StatusCode, AResponseHeader, respText);
            end;
          end;

          if not Authorize(ProxySettings.UserName, ProxySettings.Password,
            'Proxy-Authorization', ResponseHeader.ProxyAuthenticate, reqHeader, startNewConnection) then
          begin
            if SilentHTTP then
            begin
              LoadResponseStream(respText, AResponseBody);
              Break;
            end else
            begin
              RaiseHttpError(StatusCode, AResponseHeader, respText);
            end;
          end;

          if (proxyRetries = 1) and startNewConnection then
          begin
            needClose := True;
          end;
        end else
        if (StatusCode >= 400) then
        begin
          if SilentHTTP then
          begin
            ReadResponseStream(AResponseHeader, extraSize, rawData, AResponseBody);
            Break;
          end else
          begin
            ReadResponseText(AResponseHeader, extraSize, rawData, respText);
            RaiseHttpError(StatusCode, AResponseHeader, respText);
          end;
        end else
        begin
          ReadResponseStream(AResponseHeader, extraSize, rawData, AResponseBody);
          Break;
        end;

        if needClose then
        begin
          Close();
        end;
      until False;

    finally
      if needClose and (tunnelStatus <> htConnect) then
      begin
        Close();
      end;
    end;
  finally
    nullBody.Free();
    respText.Free();
    rawData.Free();
    reqHeader.Free();
  end;
end;

procedure TclHttp.SendRequest(const AMethod, AUrl: string; ARequestHeader: TStrings;
  ARequestBody: TStream; AResponseHeader: TStrings; AResponseBody: TStream);
var
  reqHeader, respHeader: TStrings;
  nullBody: TStream;
begin
  reqHeader := nil;
  respHeader := nil;
  nullBody := nil;
  try
    if (ARequestHeader = nil) then
    begin
      reqHeader := TStringList.Create();
      ARequestHeader := reqHeader;
    end;

    if (AResponseHeader = nil) then
    begin
      respHeader := TStringList.Create();
      AResponseHeader := respHeader;
    end;

    if (ARequestBody = nil) then
    begin
      if (nullBody = nil) then
      begin
        nullBody := TclNullStream.Create();
      end;
      ARequestBody := nullBody;
    end;

    if (AResponseBody = nil) then
    begin
      if (nullBody = nil) then
      begin
        nullBody := TclNullStream.Create();
      end;
      AResponseBody := nullBody;
    end;

    Url.Parse(AUrl, CharSet);
    InternalSendRequest(AMethod, ARequestHeader, ARequestBody, AResponseHeader, AResponseBody);
  finally
    nullBody.Free();
    respHeader.Free();
    reqHeader.Free();
  end;
end;

procedure TclHttp.SetHttpVersion(const Value: TclHttpVersion);
begin
  if (FHttpVersion <> Value) then
  begin
    FHttpVersion := Value;
    Changed();
  end;
end;

procedure TclHttp.SetPassword(const Value: string);
begin
  if (FPassword <> Value) then
  begin
    FPassword := Value;
    Changed();
  end;
end;

procedure TclHttp.SetUserName(const Value: string);
begin
  if (FUserName <> Value) then
  begin
    FUserName := Value;
    Changed();
  end;
end;

procedure TclHttp.SetUserAgent(const Value: string);
begin
  if (FUserAgent <> Value) then
  begin
    FUserAgent := Value;
    Changed();
  end;
end;

procedure TclHttp.SetAuthorizationType(const Value: TclAuthorizationType);
begin
  if (FAuthorizationType <> Value) then
  begin
    FAuthorizationType := Value;
    Changed();
  end;
end;

procedure TclHttp.SendRequest(const AMethod, AUrl: string;
  ARequestHeader: TStrings; ARequestBody, AResponseBody: TStream);
begin
  SendRequest(AMethod, AUrl, ARequestHeader, ARequestBody, nil, AResponseBody);
end;

procedure TclHttp.SendRequest(const AMethod, AUrl: string;
  ARequest: TclHttpRequest; AResponseBody: TStream);
begin
  SendRequest(AMethod, AUrl, ARequest, nil, AResponseBody);
end;

procedure TclHttp.SetAllowCaching(const Value: Boolean);
begin
  if (FAllowCaching <> Value) then
  begin
    FAllowCaching := Value;
    Changed();
  end;
end;

procedure TclHttp.SetKeepConnection(const Value: Boolean);
begin
  if (FKeepConnection <> Value) then
  begin
    FKeepConnection := Value;
    Changed();
  end;
end;

procedure TclHttp.SetAllowRedirects(const Value: Boolean);
begin
  if (FAllowRedirects <> Value) then
  begin
    FAllowRedirects := Value;
    Changed();
  end;
end;

procedure TclHttp.SetProxySettings(const Value: TclHttpProxySettings);
begin
  FProxySettings.Assign(Value);
end;

procedure TclHttp.SetMaxAuthRetries(const Value: Integer);
begin
  if (FMaxAuthRetries <> Value) then
  begin
    FMaxAuthRetries := Value;
    Changed();
  end;
end;

procedure TclHttp.SetMaxRedirects(const Value: Integer);
begin
  if (FMaxRedirects <> Value) then
  begin
    FMaxRedirects := Value;
    Changed();
  end;
end;

procedure TclHttp.SetAuthorization(const Value: string);
begin
  if (FAuthorization <> Value) then
  begin
    FAuthorization := Value;
    Changed();
  end;
end;

function TclHttp.IsUseProxy: Boolean;
begin
  Result := (ProxySettings.Server <> '');
end;

procedure TclHttp.SetAllowCookies(const Value: Boolean);
begin
  if (FAllowCookies <> Value) then
  begin
    FAllowCookies := Value;
    Changed();
  end;
end;

procedure TclHttp.DoReceiveResponse(const AMethod, AUrl: string;
  AResponseHeader: TStrings; ACookies: TclCookieList);
begin
  if Assigned(OnReceiveResponse) then
  begin
    OnReceiveResponse(Self, AMethod, AUrl, AResponseHeader, ACookies);
  end;
end;

procedure TclHttp.DoSendRequest(const AMethod, AUrl: string; ARequestHeader: TStrings);
begin
  if Assigned(OnSendRequest) then
  begin
    OnSendRequest(Self, AMethod, AUrl, ARequestHeader);
  end;
end;

procedure TclHttp.SetAllowCompression(const Value: Boolean);
begin
  if (FAllowCompression <> Value) then
  begin
    FAllowCompression := Value;
    Changed();
  end;
end;

procedure TclHttp.SetRequest(const Value: TclHttpRequest);
begin
  if (FRequest <> Value) then
  begin
    if (FRequest <> nil) then
    begin
      FRequest.RemoveFreeNotification(Self);
    end;
    FRequest := Value;
    if (FRequest <> nil) then
    begin
      FRequest.FreeNotification(Self);
    end;
  end;
end;

procedure TclHttp.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) then Exit;
  if (AComponent = FRequest) then
  begin
    FRequest := nil;
  end;
  if (AComponent = FCookieManager) then
  begin
    FCookieManager := nil;
  end;
end;

procedure TclHttp.Delete(const AUrl: string);
begin
  InternalDelete(AUrl, nil, nil);
end;

procedure TclHttp.Get(const AUrl: string; ADestination: TStream);
begin
  InternalGet(AUrl, nil, nil, ADestination);
end;

procedure TclHttp.Head(const AUrl: string);
begin
  InternalHead(AUrl, nil);
end;

procedure TclHttp.Post(const AUrl: string; ARequest: TclHttpRequest; AResponseBody: TStream);
begin
  InternalPost(AUrl, ARequest, nil, AResponseBody);
end;

procedure TclHttp.Post(const AUrl: string; AResponseBody: TStream);
begin
  Post(AUrl, Request, AResponseBody);
end;

procedure TclHttp.Put(const AUrl: string; ASource: TStream);
begin
  Put(AUrl, '', ASource);
end;

procedure TclHttp.SendRequest(const AMethod, AUrl: string;
  ARequest: TclHttpRequest; AResponseHeader: TStrings; AResponseBody: TStream);
var
  stream: TStream;
  reqHeader: TStrings;
begin
  reqHeader := ARequest.HeaderSource;
  stream := ARequest.RequestStream;
  try
    SendRequest(AMethod, AUrl, reqHeader, stream, AResponseHeader, AResponseBody);
  finally
    stream.Free();
  end;
end;

procedure TclHttp.DoSendProgress(ABytesProceed, ATotalBytes: Int64);
begin
  FProgressHandled := True;
  if Assigned(OnSendProgress) then
  begin
    OnSendProgress(Self, ABytesProceed, ATotalBytes);
  end;
end;

procedure TclHttp.DoReceiveHeader(const AMethod, AUrl: string;
  AResponseHeader: TStrings; ACookies: TclCookieList; var Cancel: Boolean);
begin
  if Assigned(OnReceiveHeader) then
  begin
    OnReceiveHeader(Self, AMethod, AUrl, AResponseHeader, ACookies, Cancel);
  end;
end;

procedure TclHttp.DoReceiveProgress(ABytesProceed, ATotalBytes: Int64);
begin
  FProgressHandled := True;
  if Assigned(OnReceiveProgress) then
  begin
    OnReceiveProgress(Self, ABytesProceed, ATotalBytes);
  end;
end;

procedure TclHttp.InitProgress(ABytesProceed, ATotalBytes: Int64);
begin
  FProgressHandled := False;
  Connection.InitProgress(ABytesProceed, ATotalBytes);
end;

procedure TclHttp.DoDataSendProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
begin
  DoSendProgress(ABytesProceed, ATotalBytes);
end;

procedure TclHttp.DoDataReceiveProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
begin
  DoReceiveProgress(ABytesProceed, ATotalBytes);
end;

function TclHttp.GetPassword: string;
begin
  Result := Password;
  if (Result = '') then
  begin
    Result := Url.Password;
  end;
end;

function TclHttp.GetUserName_: string;
begin
  Result := UserName;
  if (Result = '') then
  begin
    Result := Url.UserName;
  end;
end;

procedure TclHttp.Head(const AUrl: string; AResponseHeader: TStrings);
begin
  InternalHead(AUrl, AResponseHeader);
end;

function TclHttp.GetDefaultPort: Integer;
begin
  Result := DefaultHttpPort;
end;

procedure TclHttp.Get(const AUrl: string; ADestination: TStrings);
var
  dest: TStream;
begin
  dest := TMemoryStream.Create();
  try
    Get(AUrl, dest);

    dest.Position := 0;

    TclStringsUtils.LoadStrings(dest, ADestination, GetResponseCharSet());
  finally
    dest.Free();
  end;
end;

procedure TclHttp.Post(const AUrl: string; AResponseBody: TStrings);
var
  dest: TStream;
begin
  dest := TMemoryStream.Create();
  try
    Post(AUrl, dest);

    dest.Position := 0;
    TclStringsUtils.LoadStrings(dest, AResponseBody, GetResponseCharSet());
  finally
    dest.Free();
  end;
end;

procedure TclHttp.OpenConnection(const AServer: string; APort: Integer);
begin
  if IsUseProxy() then
  begin
    inherited OpenConnection(ProxySettings.Server, ProxySettings.Port);
  end else
  begin
    inherited OpenConnection(AServer, APort);
  end;
end;

procedure TclHttp.Put(const AUrl: string; ASource, AResponseBody: TStream);
begin
  Put(AUrl, '', ASource, AResponseBody);
end;

procedure TclHttp.Put(const AUrl: string; ASource: TStream; AResponseBody: TStrings);
begin
  Put(AUrl, '', ASource, AResponseBody);
end;

procedure TclHttp.SetCharSet(const Value: string);
begin
  if (FCharSet <> Value) then
  begin
    FCharSet := Value;
    Changed();
  end;
end;

procedure TclHttp.SetCookieManager(const Value: TclCookieManager);
begin
  if (FCookieManager <> Value) then
  begin
    if (FCookieManager <> nil) then
    begin
      FCookieManager.RemoveFreeNotification(Self);
    end;
    FCookieManager := Value;
    if (FCookieManager <> nil) then
    begin
      FCookieManager.FreeNotification(Self);
    end;

    FOwnCookieManager.Free();
    FOwnCookieManager := nil;
  end;
end;

procedure TclHttp.SetExpect100Continue(const Value: Boolean);
begin
  if (FExpect100Continue <> Value) then
  begin
    FExpect100Continue := Value;
    Changed();
  end;
end;

procedure TclHttp.Get(const AUrl: string; AResponseHeader: TStrings; AResponseBody: TStream);
begin
  InternalGet(AUrl, nil, AResponseHeader, AResponseBody);
end;

procedure TclHttp.Get(const AUrl: string; ARequest: TclHttpRequest; ADestination: TStream);
begin
  InternalGet(AUrl, ARequest, nil, ADestination);
end;

procedure TclHttp.Get(const AUrl: string; ARequest: TclHttpRequest; ADestination: TStrings);
var
  dest: TStream;
begin
  dest := TMemoryStream.Create();
  try
    Get(AUrl, ARequest, dest);

    dest.Position := 0;
    TclStringsUtils.LoadStrings(dest, ADestination, GetResponseCharSet());
  finally
    dest.Free();
  end;
end;

procedure TclHttp.Get(const AUrl: string; ARequest: TclHttpRequest; AResponseHeader: TStrings; AResponseBody: TStream);
begin
  InternalGet(AUrl, ARequest, AResponseHeader, AResponseBody);
end;

function TclHttp.GetCookieManager: TclCookieManager;
begin
  Result := CookieManager;
  if (Result = nil) then
  begin
    if (FOwnCookieManager = nil) then
    begin
      FOwnCookieManager := TclCookieManager.Create(nil);
    end;
    Result := FOwnCookieManager;
  end;
end;

procedure TclHttp.InternalGet(const AUrl: string; ARequest: TclHttpRequest; AResponseHeader: TStrings; ADestination: TStream);
var
  s: string;
  req: TclHttpRequest;
begin
  req := ARequest;
  if (req = nil) then
  begin
    req := GetRequest();
  end;

  s := Trim(req.RequestSource.Text);
  if (s <> '') then
  begin
    s := '?' + s; 
  end;
  s := AUrl + s;

  SendRequest('GET', s, req.HeaderSource, nil, AResponseHeader, ADestination);
end;

procedure TclHttp.InternalHead(const AUrl: string; AResponseHeader: TStrings);
begin
  SendRequest('HEAD', AUrl, GetRequest(), AResponseHeader, nil);
end;

procedure TclHttp.InternalPut(const AUrl, AContentType: string; ASource: TStream; AResponseHeader: TStrings; AResponseBody: TStream);
var
  req: TclHttpRequest;
begin
  req := GetRequest();
  req.Header.Accept := '';

  if (AContentType <> '') then
  begin
    req.Header.ContentType := AContentType;
  end;

  SendRequest('PUT', AUrl, req.HeaderSource, ASource, AResponseHeader, AResponseBody);
end;

procedure TclHttp.InternalPost(const AUrl: string; ARequest: TclHttpRequest; AResponseHeader: TStrings; AResponseBody: TStream);
var
  req: TclHttpRequest;
begin
  req := ARequest;
  if (req = nil) then
  begin
    req := GetRequest();
  end;

  SendRequest('POST', AUrl, req, AResponseHeader, AResponseBody);
end;

procedure TclHttp.InternalDelete(const AUrl: string; AResponseHeader: TStrings; AResponseBody: TStream);
begin
  SendRequest('DELETE', AUrl, GetRequest(), AResponseHeader, AResponseBody);
end;

procedure TclHttp.Post(const AUrl: string; ARequest: TclHttpRequest; AResponseBody: TStrings);
var
  dest: TStream;
begin
  dest := TMemoryStream.Create();
  try
    Post(AUrl, ARequest, dest);

    dest.Position := 0;
    TclStringsUtils.LoadStrings(dest, AResponseBody, GetResponseCharSet());
  finally
    dest.Free();
  end;
end;

procedure TclHttp.Put(const AUrl: string; ASource: TStrings);
begin
  Put(AUrl, '', ASource);
end;

procedure TclHttp.Put(const AUrl: string; ASource, AResponseBody: TStrings);
begin
  Put(AUrl, '', ASource, AResponseBody);
end;

procedure TclHttp.Put(const AUrl: string; ASource: TStream; AResponseHeader, AResponseBody: TStrings);
begin
  Put(AUrl, '', ASource, AResponseHeader, AResponseBody);
end;

procedure TclHttp.Post(const AUrl: string; ARequest: TclHttpRequest; AResponseHeader: TStrings; AResponseBody: TStream);
begin
  InternalPost(AUrl, ARequest, AResponseHeader, AResponseBody);
end;

procedure TclHttp.Put(const AUrl, AContentType: string; ASource, AResponseBody: TStream);
begin
  InternalPut(AUrl, AContentType, ASource, nil, AResponseBody);
end;

procedure TclHttp.Put(const AUrl, AContentType: string; ASource: TStrings);
var
  src: TStream;
begin
  src := TMemoryStream.Create();
  try
    TclStringsUtils.SaveStrings(ASource, src, CharSet);
    src.Position := 0;
    Put(AUrl, AContentType, src);
  finally
    src.Free();
  end;
end;

procedure TclHttp.Put(const AUrl, AContentType: string; ASource: TStream);
var
  dst: TStream;
begin
  dst := TclNullStream.Create();
  try
    Put(AUrl, AContentType, ASource, dst);
  finally
    dst.Free();
  end;
end;

procedure TclHttp.Put(const AUrl, AContentType: string; ASource: TStream;
  AResponseHeader, AResponseBody: TStrings);
var
  dst: TStream;
begin
  dst := TMemoryStream.Create();
  try
    InternalPut(AUrl, AContentType, ASource, AResponseHeader, dst);
    dst.Position := 0;
    TclStringsUtils.LoadStrings(dst, AResponseBody, GetResponseCharSet());
  finally
    dst.Free();
  end;
end;

procedure TclHttp.Put(const AUrl, AContentType: string; ASource, AResponseBody: TStrings);
var
  src: TStream;
begin
  src := TMemoryStream.Create();
  try
    TclStringsUtils.SaveStrings(ASource, src, CharSet);
    src.Position := 0;
    Put(AUrl, AContentType, src, AResponseBody);
  finally
    src.Free();
  end;
end;

procedure TclHttp.Put(const AUrl, AContentType: string; ASource: TStream; AResponseBody: TStrings);
var
  dst: TStream;
begin
  dst := TMemoryStream.Create();
  try
    Put(AUrl, AContentType, ASource, dst);
    dst.Position := 0;
    TclStringsUtils.LoadStrings(dst, AResponseBody, GetResponseCharSet());
  finally
    dst.Free();
  end;
end;

procedure TclHttp.Delete(const AUrl: string; AResponseHeader, AResponseBody: TStrings);
var
  responseBody: TStream;
begin
  responseBody := TMemoryStream.Create();
  try
    InternalDelete(AUrl, AResponseHeader, responseBody);
    responseBody.Position := 0;
    TclStringsUtils.LoadStrings(responseBody, AResponseBody, GetResponseCharSet());
  finally
    responseBody.Free();
  end;
end;

procedure TclHttp.Delete(const AUrl: string; AResponseHeader: TStrings; AResponseBody: TStream);
begin
  InternalDelete(AUrl, AResponseHeader, AResponseBody);
end;

procedure TclHttp.Delete(const AUrl: string; AResponseBody: TStream);
begin
  InternalDelete(AUrl, nil, AResponseBody);
end;

{ EclHttpError }

constructor EclHttpError.Create(const AErrorMsg: string;
  AErrorCode: Integer; const AResponseText: string);
begin
  inherited Create(AErrorMsg, AErrorCode);
  FResponseText := AResponseText;
end;

end.

