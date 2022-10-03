{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clOAuth;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Dialogs, ShellAPI, Windows,{$IFDEF DEMO} Forms, clEncoder, clEncryptor, clCertificate, clHtmlParser,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils, Vcl.Dialogs, Winapi.ShellAPI, Winapi.Windows,
  {$IFDEF DEMO} Vcl.Forms, clEncoder, clEncryptor, clCertificate, clHtmlParser,{$ENDIF}
{$ENDIF}
  clHttp, clHttpRequest, clJson, clSimpleHttpServer, clHttpUtils, clUriUtils{$IFDEF LOGGER}, clLogger{$ENDIF};

type
  EclOAuthError = class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean = False);
    property ErrorCode: Integer read FErrorCode;
  end;

  TclAuthorizationFlowType = (afAuthCodeFlow, afImplicitGrantFlow, afClientCredentialsFlow, afUserPasswordFlow, afRefreshTokenFlow);

  TclAuthorizationEndPointType = (apEnterCodeForm, apLocalWebServer, apWebApplication);

  TclOAuthTokenEndPoint = (tpUsePost, tpUseGet);

  TclAuthorizationResponseType = (rtAuthCode, rtAuthToken, rtExtension);

  TclOAuth = class;

  TclOAuthToken = class
  private
    FRefreshToken: string;
    FTokenType: string;
    FAccessToken: string;
    FExpiresIn: string;
    FScope: string;
  protected
    function GetAuthorization: string; virtual;
  public
    procedure Parse(AResponse: TclJSONBase); virtual;
    procedure Clear; virtual;
    function ToJson: TclJSONObject; virtual;
{$IFDEF DELPHI2009}
    function ToString: string; override;
{$ELSE}
    function ToString: string; virtual;
{$ENDIF}

    property AccessToken: string read FAccessToken write FAccessToken;
    property TokenType: string read FTokenType write FTokenType;
    property ExpiresIn: string read FExpiresIn write FExpiresIn;
    property RefreshToken: string read FRefreshToken write FRefreshToken;
    property Scope: string read FScope write FScope;

    property Authorization: string read GetAuthorization;
  end;

  TclOAuthAuthorizationEndPoint = class
  private
    FOAuth: TclOAuth;
    FRedirectUrl: string;
  protected
    procedure LaunchBrowser(const AUrl: string);
  public
    function Authorize(AResponseType: TclAuthorizationResponseType): TclJSONObject; overload; virtual; abstract;
    function Authorize(const ARequestUri: string): TclJSONObject; overload; virtual; abstract;
    function GetAuthorizationUrl(AResponseType: TclAuthorizationResponseType): string;

    property RedirectUrl: string read FRedirectUrl write FRedirectUrl;
    property OAuth: TclOAuth read FOAuth write FOAuth;
  end;

  TclOAuthAuthorizationFlow = class
  private
    FOAuth: TclOAuth;
    FAuthorizationEndPoint: TclOAuthAuthorizationEndPoint;
  protected
    procedure CheckOAuthError(AHttp: TclHttp; AResponse: TStrings);
    function CreateToken: TclOAuthToken;
    function SendTokenRequest(AHttp: TclHttp; ARequest: TclHttpRequest): TclJSONBase;
  public
    function RequestToken: TclOAuthToken; overload; virtual; abstract;
    function RequestToken(const ARequestUri: string): TclOAuthToken; overload; virtual;
    function GetAuthorizationUrl: string; virtual;

    property OAuth: TclOAuth read FOAuth write FOAuth;
    property AuthorizationEndPoint: TclOAuthAuthorizationEndPoint read FAuthorizationEndPoint write FAuthorizationEndPoint;
  end;

  TclOAuthRedirectEvent = procedure(Sender: TObject; var ARedirectUrl: string) of object;
  TclLaunchBrowserEvent = procedure(Sender: TObject; const AUrl: string; var Handled: Boolean) of object;
  TclShowEnterCodeFormEvent = procedure(Sender: TObject; var AuthorizationCode: string; var Handled: Boolean) of object;
  TclCreateAuthorizationFlowEvent = procedure(Sender: TObject; AuthFlowType: TclAuthorizationFlowType; var AuthFlow: TclOAuthAuthorizationFlow) of object;
  TclCreateAuthorizationEndPointEvent = procedure(Sender: TObject; AuthEndPointType: TclAuthorizationEndPointType; var AuthEndPoint: TclOAuthAuthorizationEndPoint) of object;
  TclCreateOAuthTokenEvent = procedure(Sender: TObject; var AuthToken: TclOAuthToken) of object;

  TclOAuthCodeFlow = class(TclOAuthAuthorizationFlow)
  private
    function SendAuthCodeTokenRequest(AuthResponse: TclJSONObject; const ARedirectUrl: string): TclJSONBase;
    function GetAuthorizationToken(AuthResponse: TclJSONObject): TclOAuthToken;
  public
    function RequestToken: TclOAuthToken; overload; override;
    function RequestToken(const ARequestUri: string): TclOAuthToken; overload; override;
    function GetAuthorizationUrl: string; override;
  end;

  TclImplicitGrantFlow = class(TclOAuthAuthorizationFlow)
  public
    function RequestToken: TclOAuthToken; overload; override;
    function RequestToken(const ARequestUri: string): TclOAuthToken; overload; override;
    function GetAuthorizationUrl: string; override;
  end;

  TclRefreshTokenFlow = class(TclOAuthAuthorizationFlow)
  private
    function GetRefreshToken: TclJSONBase;
  public
    function RequestToken: TclOAuthToken; override;
  end;

  TclClientCredentialsFlow = class(TclOAuthAuthorizationFlow)
  protected
    function GetAuthToken: TclJSONBase; virtual;
  public
    function RequestToken: TclOAuthToken; override;
  end;

  TclUserPasswordFlow = class(TclClientCredentialsFlow)
  protected
    function GetAuthToken: TclJSONBase; override;
  end;

  TclEnterCodeFormEndPoint = class(TclOAuthAuthorizationEndPoint)
  private
    function ShowEnterCodeForm: string;
    function BuildAuthInfo(AResponseType: TclAuthorizationResponseType; const AuthResponse: string): TclJSONObject;
  public
    function Authorize(AResponseType: TclAuthorizationResponseType): TclJSONObject; overload; override;
    function Authorize(const ARequestUri: string): TclJSONObject; overload; override;
  end;

  TclLocalWebServerEndPoint = class(TclOAuthAuthorizationEndPoint)
  private
    function ExtractUrlPart(const AUrl: string; ADelimiter: Char): string;
    function ParseAuthResult(const ARequestUri: string): TclJSONObject;
    function AcceptRedirect(AServer: TclSimpleHttpServer): TclJSONObject;
    function GetRedirectUrl(const AUrl: string; APort: Integer): string;
  public
    function Authorize(AResponseType: TclAuthorizationResponseType): TclJSONObject; overload; override;
    function Authorize(const ARequestUri: string): TclJSONObject; overload; override;
  end;

  TclWebApplicationEndPoint = class(TclLocalWebServerEndPoint)
  public
    function Authorize(AResponseType: TclAuthorizationResponseType): TclJSONObject; overload; override;
  end;

  TclOAuth = class(TComponent)
  private
    FAuthUrl: string;
    FScope: string;
    FClientID: string;
    FTokenUrl: string;
    FAuthorizationFlow: TclAuthorizationFlowType;
    FAuthorizationEndPoint: TclAuthorizationEndPointType;
    FClientSecret: string;
    FRedirectUrl: string;
    FToken: TclOAuthToken;
    FHttpClient: TclHttp;
    FOwnHttpClient: TclHttp;
    FRequest: TclHttpRequest;
    FOwnRequest: TclHttpRequest;
    FUserAgent: string;
    FEnterCodeFormCaption: string;
    FState: string;
    FLocalWebServerPort: Integer;
    FHttpServer: TclSimpleHttpServer;
    FOwnHttpServer: TclSimpleHttpServer;
    FSuccessHtmlResponse: string;
    FFailedHtmlResponse: string;
    FPassword: string;
    FUserName: string;

    FOnRedirect: TclOAuthRedirectEvent;
    FOnCreateAuthorizationFlow: TclCreateAuthorizationFlowEvent;
    FOnShowEnterCodeForm: TclShowEnterCodeFormEvent;
    FOnLaunchBrowser: TclLaunchBrowserEvent;
    FOnCreateAuthorizationEndPoint: TclCreateAuthorizationEndPointEvent;
    FOnCreateToken: TclCreateOAuthTokenEvent;
    FTokenEndPoint: TclOAuthTokenEndPoint;
    FEscapeRedirectUrl: Boolean;

    procedure SetAuthUrl(const Value: string);
    procedure SetClientID(const Value: string);
    procedure SetClientSecret(const Value: string);
    procedure SetAuthorizationFlow(const Value: TclAuthorizationFlowType);
    procedure SetRedirectUrl(const Value: string);
    procedure SetScope(const Value: string);
    procedure SetTokenUrl(const Value: string);
    procedure SetAuthorizationEndPoint(const Value: TclAuthorizationEndPointType);

    function CreateAuthEndPoint(AuthEndPointType: TclAuthorizationEndPointType): TclOAuthAuthorizationEndPoint;
    function CreateAuthFlow(AuthFlowType: TclAuthorizationFlowType): TclOAuthAuthorizationFlow;
    procedure SetHttpClient(const Value: TclHttp);
    procedure SetRequest(const Value: TclHttpRequest);
    procedure SetState(const Value: string);
    procedure SetHttpServer(const Value: TclSimpleHttpServer);
    procedure SetPassword(const Value: string);
    procedure SetUserName(const Value: string);
    procedure SetTokenEndPoint(const Value: TclOAuthTokenEndPoint);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure DoRedirect(var ARedirectUrl: string); virtual;
    procedure DoLaunchBrowser(const AUrl: string; var Handled: Boolean); virtual;
    procedure DoShowEnterCodeForm(var AuthorizationCode: string; var Handled: Boolean); virtual;
    procedure DoCreateAuthorizationFlow(AuthFlowType: TclAuthorizationFlowType; var AuthFlow: TclOAuthAuthorizationFlow); virtual;
    procedure DoCreateAuthorizationEndPoint(AuthEndPointType: TclAuthorizationEndPointType; var AuthEndPoint: TclOAuthAuthorizationEndPoint); virtual;
    procedure DoCreateToken(var AuthToken: TclOAuthToken); virtual;

    procedure RequestAuthorization(AuthFlowType: TclAuthorizationFlowType); virtual;

    function GetHttpClient: TclHttp;
    function GetRequest: TclHttpRequest;
    function GetHttpServer: TclSimpleHttpServer;
    function GetToken: TclOAuthToken;

    procedure ClearToken;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetAuthorization: string; overload;
    function GetAuthorization(const ARequestUri: string): string; overload;
    function GetAuthorizationUrl: string;
    function RefreshAuthorization: string; overload;
    function RefreshAuthorization(AToken: TclOAuthToken): string; overload;
    procedure Close; virtual;

    procedure SetToken(AToken: TclOAuthToken); overload;
    procedure SetToken(AToken: TclJSONBase); overload;
    procedure SetToken(const AToken: string); overload;

    property Token: TclOAuthToken read FToken;
  published
    property HttpClient: TclHttp read FHttpClient write SetHttpClient;
    property Request: TclHttpRequest read FRequest write SetRequest;
    property HttpServer: TclSimpleHttpServer read FHttpServer write SetHttpServer;

    property UserAgent: string read FUserAgent write FUserAgent;
    property EnterCodeFormCaption: string read FEnterCodeFormCaption write FEnterCodeFormCaption;
    property LocalWebServerPort: Integer read FLocalWebServerPort write FLocalWebServerPort default 0;
    property SuccessHtmlResponse: string read FSuccessHtmlResponse write FSuccessHtmlResponse;
    property FailedHtmlResponse: string read FFailedHtmlResponse write FFailedHtmlResponse;
    property EscapeRedirectUrl: Boolean read FEscapeRedirectUrl write FEscapeRedirectUrl default True;

    property AuthorizationFlow: TclAuthorizationFlowType read FAuthorizationFlow write SetAuthorizationFlow default afAuthCodeFlow;
    property AuthorizationEndPoint: TclAuthorizationEndPointType read FAuthorizationEndPoint write SetAuthorizationEndPoint default apLocalWebServer;
    property TokenEndPoint: TclOAuthTokenEndPoint read FTokenEndPoint write SetTokenEndPoint default tpUsePost;

    property AuthUrl: string read FAuthUrl write SetAuthUrl;
    property TokenUrl: string read FTokenUrl write SetTokenUrl;
    property RedirectUrl: string read FRedirectUrl write SetRedirectUrl;

    property ClientID: string read FClientID write SetClientID;
    property ClientSecret: string read FClientSecret write SetClientSecret;
    property Scope: string read FScope write SetScope;
    property State: string read FState write SetState;
    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;

    property OnRedirect: TclOAuthRedirectEvent read FOnRedirect write FOnRedirect;
    property OnLaunchBrowser: TclLaunchBrowserEvent read FOnLaunchBrowser write FOnLaunchBrowser;
    property OnShowEnterCodeForm: TclShowEnterCodeFormEvent read FOnShowEnterCodeForm write FOnShowEnterCodeForm;
    property OnCreateAuthorizationFlow: TclCreateAuthorizationFlowEvent read FOnCreateAuthorizationFlow write FOnCreateAuthorizationFlow;
    property OnCreateAuthorizationEndPoint: TclCreateAuthorizationEndPointEvent read FOnCreateAuthorizationEndPoint write FOnCreateAuthorizationEndPoint;
    property OnCreateToken: TclCreateOAuthTokenEvent read FOnCreateToken write FOnCreateToken;
  end;

resourcestring
  DefaultOAuthAgent = 'CleverComponents OAUTH 2.0';
  DefaultEnterCodeFormCaption = 'Enter Authorization Code';
  DefaultSuccessHtmlResponse = '<html><body><h3 style="color:green;margin:30px">OAuth Authorization Successful!</h3></body></html>';
  DefaultFailedHtmlResponse = '<html><body><h3 style="color:red;margin:30px">OAuth Authorization Failed!</h3></body></html>';

  CreateAuthorizationEndPointError = 'Cannot create authorization end point';
  CreateAuthorizationFlowError = 'Cannot create authorization flow';
  CreateOAuthTokenError = 'Cannot create OAuth token';
  ParseOAuthTokenError = 'OAuth JSON response is invalid';
  AuthorizationCodeError = 'Athorization code is invalid';
  RefreshFailed = 'Refresh token failed. You must first authenticate';

const
  CreateAuthorizationEndPointErrorCode = -10;
  CreateAuthorizationFlowErrorCode = -11;
  CreateOAuthTokenErrorCode = -12;
  ParseOAuthTokenErrorCode = -13;
  AuthorizationCodeErrorCode = -14;
  RefreshFailedCode = -15;

implementation

{ TclOAuth }

procedure TclOAuth.ClearToken;
begin
  FreeAndNil(FToken);
end;

procedure TclOAuth.Close;
begin
  GetHttpClient().Close();
  GetHttpServer().Close();

  ClearToken();
end;

constructor TclOAuth.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAuthorizationFlow := afAuthCodeFlow;
  FAuthorizationEndPoint := apLocalWebServer;
  FUserAgent := DefaultOAuthAgent;
  FEnterCodeFormCaption := DefaultEnterCodeFormCaption;
  FLocalWebServerPort := 0;
  FSuccessHtmlResponse := DefaultSuccessHtmlResponse;
  FFailedHtmlResponse := DefaultFailedHtmlResponse;
  FTokenEndPoint := tpUsePost;
  FEscapeRedirectUrl := True;
end;

function TclOAuth.CreateAuthEndPoint(AuthEndPointType: TclAuthorizationEndPointType): TclOAuthAuthorizationEndPoint;
begin
  Result := nil;
  DoCreateAuthorizationEndPoint(AuthEndPointType, Result);
  if (Result <> nil) then Exit;

  case AuthEndPointType of
    apEnterCodeForm: Result := TclEnterCodeFormEndPoint.Create();
    apLocalWebServer: Result := TclLocalWebServerEndPoint.Create();
    apWebApplication: Result := TclWebApplicationEndPoint.Create();
  end;

  if (Result = nil) then
  begin
    raise EclOAuthError.Create(CreateAuthorizationEndPointError, CreateAuthorizationEndPointErrorCode);
  end;
end;

function TclOAuth.CreateAuthFlow(AuthFlowType: TclAuthorizationFlowType): TclOAuthAuthorizationFlow;
begin
  Result := nil;
  DoCreateAuthorizationFlow(AuthFlowType, Result);
  if (Result <> nil) then Exit;

  case AuthFlowType of
    afAuthCodeFlow: Result := TclOAuthCodeFlow.Create();
    afImplicitGrantFlow: Result := TclImplicitGrantFlow.Create();
    afRefreshTokenFlow: Result := TclRefreshTokenFlow.Create();
    afClientCredentialsFlow: Result := TclClientCredentialsFlow.Create();
    afUserPasswordFlow: Result := TclUserPasswordFlow.Create();
  end;

  if (Result = nil) then
  begin
    raise EclOAuthError.Create(CreateAuthorizationFlowError, CreateAuthorizationFlowErrorCode);
  end;
end;

destructor TclOAuth.Destroy;
begin
  Close();
  FreeAndNil(FOwnHttpClient);
  FreeAndNil(FOwnRequest);
  FreeAndNil(FOwnHttpServer);

  inherited Destroy();
end;

procedure TclOAuth.DoCreateAuthorizationEndPoint(AuthEndPointType: TclAuthorizationEndPointType; var AuthEndPoint: TclOAuthAuthorizationEndPoint);
begin
  if Assigned(OnCreateAuthorizationEndPoint) then
  begin
    OnCreateAuthorizationEndPoint(Self, AuthEndPointType, AuthEndPoint);
  end;
end;

procedure TclOAuth.DoCreateAuthorizationFlow(AuthFlowType: TclAuthorizationFlowType; var AuthFlow: TclOAuthAuthorizationFlow);
begin
  if Assigned(OnCreateAuthorizationFlow) then
  begin
    OnCreateAuthorizationFlow(Self, AuthFlowType, AuthFlow);
  end;
end;

procedure TclOAuth.DoCreateToken(var AuthToken: TclOAuthToken);
begin
  if Assigned(OnCreateToken) then
  begin
    OnCreateToken(Self, AuthToken);
  end;
end;

procedure TclOAuth.DoLaunchBrowser(const AUrl: string; var Handled: Boolean);
begin
  if Assigned(OnLaunchBrowser) then
  begin
    OnLaunchBrowser(Self, AUrl, Handled);
  end;
end;

procedure TclOAuth.DoRedirect(var ARedirectUrl: string);
begin
  if Assigned(OnRedirect) then
  begin
    OnRedirect(Self, ARedirectUrl);
  end;
end;

procedure TclOAuth.DoShowEnterCodeForm(var AuthorizationCode: string; var Handled: Boolean);
begin
  if Assigned(OnShowEnterCodeForm) then
  begin
    OnShowEnterCodeForm(Self, AuthorizationCode, Handled);
  end;
end;

function TclOAuth.GetAuthorization: string;
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
    IsHttpDemoDisplayed := True;
    IsHttpRequestDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  if (Token <> nil) then
  begin
    Result := Token.Authorization;
    Exit;
  end;

  RequestAuthorization(AuthorizationFlow);

  Result := Token.Authorization;
end;

function TclOAuth.GetAuthorization(const ARequestUri: string): string;
var
  end_point: TclOAuthAuthorizationEndPoint;
  flow: TclOAuthAuthorizationFlow;
begin
  flow := nil;
  end_point := nil;
  try
    flow := CreateAuthFlow(AuthorizationFlow);
    flow.OAuth := Self;

    end_point := CreateAuthEndPoint(AuthorizationEndPoint);
    end_point.OAuth := Self;

    flow.AuthorizationEndPoint := end_point;

    SetToken(flow.RequestToken(ARequestUri));

    if (FToken = nil) then
    begin
      raise EclOAuthError.Create(CreateOAuthTokenError, CreateOAuthTokenErrorCode);
    end;

    Result := Token.Authorization;
  finally
    end_point.Free();
    flow.Free();
  end;
end;

function TclOAuth.GetAuthorizationUrl: string;
var
  end_point: TclOAuthAuthorizationEndPoint;
  flow: TclOAuthAuthorizationFlow;
begin
  flow := nil;
  end_point := nil;
  try
    flow := CreateAuthFlow(AuthorizationFlow);
    flow.OAuth := Self;

    end_point := CreateAuthEndPoint(AuthorizationEndPoint);
    end_point.OAuth := Self;

    flow.AuthorizationEndPoint := end_point;

    Result := flow.GetAuthorizationUrl();
  finally
    end_point.Free();
    flow.Free();
  end;
end;

function TclOAuth.GetHttpClient: TclHttp;
begin
  Result := FHttpClient;
  if (Result = nil) then
  begin
    if (FOwnHttpClient = nil) then
    begin
      FOwnHttpClient := TclHttp.Create(nil);
      FOwnHttpClient.UserAgent := UserAgent;
    end;
    Result := FOwnHttpClient;
  end;
end;

function TclOAuth.GetHttpServer: TclSimpleHttpServer;
begin
  Result := FHttpServer;
  if (Result = nil) then
  begin
    if (FOwnHttpServer = nil) then
    begin
      FOwnHttpServer := TclSimpleHttpServer.Create(nil);
      FOwnHttpServer.ServerName := UserAgent;
      FOwnHttpServer.ResponseVersion := hvHttp1_1;
      FOwnHttpServer.KeepConnection := False;
      FOwnHttpServer.ResponseHeader.ContentType := 'text/html';
    end;
    Result := FOwnHttpServer;
  end;
end;

function TclOAuth.GetRequest: TclHttpRequest;
begin
  Result := FRequest;
  if (Result = nil) then
  begin
    if (FOwnRequest = nil) then
    begin
      FOwnRequest := TclHttpRequest.Create(nil);
      FOwnRequest.Header.CharSet := 'utf-8';
    end;
    Result := FOwnRequest;
  end;
end;

function TclOAuth.GetToken: TclOAuthToken;
begin
  Result := nil;
  DoCreateToken(Result);

  if (Result = nil) then
  begin
    Result := TclOAuthToken.Create();
  end;
end;

procedure TclOAuth.SetToken(AToken: TclJSONBase);
begin
  SetToken(GetToken());
  try
    Token.Parse(AToken);
  except
    ClearToken();
    raise;
  end;
end;

procedure TclOAuth.SetToken(const AToken: string);
var
  json: TclJSONBase;
begin
  json := TclJSONBase.Parse(AToken);
  try
    SetToken(json);
  finally
    json.Free();
  end;
end;

procedure TclOAuth.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (AComponent = FHttpClient) and (Operation = opRemove) then
  begin
    FHttpClient := nil;
  end else
  if (AComponent = FRequest) and (Operation = opRemove) then
  begin
    FRequest := nil;
  end else
  if (AComponent = FHttpServer) and (Operation = opRemove) then
  begin
    FHttpServer := nil;
  end;
end;

function TclOAuth.RefreshAuthorization: string;
var
  refresh_token: string;
begin
  if (Token = nil) then
  begin
    raise EclOAuthError.Create(RefreshFailed, RefreshFailedCode);
  end;

  refresh_token := Token.RefreshToken;

  RequestAuthorization(afRefreshTokenFlow);

  if (Token.RefreshToken = '') then
  begin
    Token.RefreshToken := refresh_token;
  end;

  Result := Token.Authorization;
end;

function TclOAuth.RefreshAuthorization(AToken: TclOAuthToken): string;
begin
  SetToken(AToken);
  Result := RefreshAuthorization();
end;

procedure TclOAuth.RequestAuthorization(AuthFlowType: TclAuthorizationFlowType);
var
  end_point: TclOAuthAuthorizationEndPoint;
  flow: TclOAuthAuthorizationFlow;
begin
  flow := nil;
  end_point := nil;
  try
    flow := CreateAuthFlow(AuthFlowType);
    flow.OAuth := Self;

    end_point := CreateAuthEndPoint(AuthorizationEndPoint);
    end_point.OAuth := Self;

    flow.AuthorizationEndPoint := end_point;

    SetToken(flow.RequestToken());

    if (FToken = nil) then
    begin
      raise EclOAuthError.Create(CreateOAuthTokenError, CreateOAuthTokenErrorCode);
    end;
  finally
    end_point.Free();
    flow.Free();
  end;
end;

procedure TclOAuth.SetAuthUrl(const Value: string);
begin
  if (FAuthUrl <> Value) then
  begin
    FAuthUrl := Value;
    Close();
  end;
end;

procedure TclOAuth.SetClientID(const Value: string);
begin
  if (FClientID <> Value) then
  begin
    FClientID := Value;
    Close();
  end;
end;

procedure TclOAuth.SetClientSecret(const Value: string);
begin
  if (FClientSecret <> Value) then
  begin
    FClientSecret := Value;
    Close();
  end;
end;

procedure TclOAuth.SetHttpClient(const Value: TclHttp);
begin
  if (FHttpClient <> Value) then
  begin
    if (FHttpClient <> nil) then
    begin
      FHttpClient.RemoveFreeNotification(Self);
    end;
    FHttpClient := Value;
    if (FHttpClient <> nil) then
    begin
      FHttpClient.FreeNotification(Self);
    end;
  end;
  FreeAndNil(FOwnHttpClient);
end;

procedure TclOAuth.SetHttpServer(const Value: TclSimpleHttpServer);
begin
  if (FHttpServer <> Value) then
  begin
    if (FHttpServer <> nil) then
    begin
      FHttpServer.RemoveFreeNotification(Self);
    end;
    FHttpServer := Value;
    if (FHttpServer <> nil) then
    begin
      FHttpServer.FreeNotification(Self);
    end;
  end;
  FreeAndNil(FOwnHttpServer);
end;

procedure TclOAuth.SetPassword(const Value: string);
begin
  if (FPassword <> Value) then
  begin
    FPassword := Value;
    Close();
  end;
end;

procedure TclOAuth.SetAuthorizationEndPoint(const Value: TclAuthorizationEndPointType);
begin
  if (FAuthorizationEndPoint <> Value) then
  begin
    FAuthorizationEndPoint := Value;
    Close();
  end;
end;

procedure TclOAuth.SetAuthorizationFlow(const Value: TclAuthorizationFlowType);
begin
  if (FAuthorizationFlow <> Value) then
  begin
    FAuthorizationFlow := Value;
    Close();
  end;
end;

procedure TclOAuth.SetRedirectUrl(const Value: string);
begin
  if (FRedirectUrl <> Value) then
  begin
    FRedirectUrl := Value;
    Close();
  end;
end;

procedure TclOAuth.SetRequest(const Value: TclHttpRequest);
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
  FreeAndNil(FOwnRequest);
end;

procedure TclOAuth.SetScope(const Value: string);
begin
  if (FScope <> Value) then
  begin
    FScope := Value;
    Close();
  end;
end;

procedure TclOAuth.SetState(const Value: string);
begin
  if (FState <> Value) then
  begin
    FState := Value;
    Close();
  end;
end;

procedure TclOAuth.SetToken(AToken: TclOAuthToken);
begin
  ClearToken();
  FToken := AToken;
end;

procedure TclOAuth.SetTokenEndPoint(const Value: TclOAuthTokenEndPoint);
begin
  if (FTokenEndPoint <> Value) then
  begin
    FTokenEndPoint := Value;
    Close();
  end;
end;

procedure TclOAuth.SetTokenUrl(const Value: string);
begin
  if (FTokenUrl <> Value) then
  begin
    FTokenUrl := Value;
    Close();
  end;
end;

procedure TclOAuth.SetUserName(const Value: string);
begin
  if (FUserName <> Value) then
  begin
    FUserName := Value;
    Close();
  end;
end;

{ TclOAuthToken }

function TclOAuthToken.ToJson: TclJSONObject;
begin
  Result := TclJSONObject.Create();
  try
    Result.AddMember('refresh_token', TclJSONString.Create(FRefreshToken));
    Result.AddMember('token_type', TclJSONString.Create(FTokenType));
    Result.AddMember('access_token', TclJSONString.Create(FAccessToken));
    Result.AddMember('expires_in', TclJSONValue.Create(FExpiresIn));
    Result.AddMember('scope', TclJSONString.Create(FScope));
  except
    Result.Free();
    raise;
  end;
end;

function TclOAuthToken.ToString: string;
var
  json: TclJSONBase;
begin
  json := ToJson();
  try
    Result := json.GetJSONString();
  finally
    json.Free();
  end;
end;

procedure TclOAuthToken.Clear;
begin
  FRefreshToken := '';
  FTokenType := '';
  FAccessToken := '';
  FExpiresIn := '';
  FScope := '';
end;

function TclOAuthToken.GetAuthorization: string;
begin
  if SameText(TokenType, 'bearer') then
  begin
    Result := 'Bearer ' + AccessToken;
  end else
  begin
    Result := 'OAuth ' + AccessToken;
  end;
end;

procedure TclOAuthToken.Parse(AResponse: TclJSONBase);
var
  obj: TclJSONObject;
begin
  Clear();

  if not (AResponse is TclJSONObject) then
  begin
    raise EclOAuthError.Create(ParseOAuthTokenError, ParseOAuthTokenErrorCode);
  end;

  obj := (AResponse as TclJSONObject);

  FRefreshToken := obj.ValueByName('refresh_token');
  FTokenType := obj.ValueByName('token_type');
  FAccessToken := obj.ValueByName('access_token');
  FExpiresIn := obj.ValueByName('expires_in');
  FScope := obj.ValueByName('scope');
end;

{ TclOAuthCodeFlow }

function TclOAuthCodeFlow.SendAuthCodeTokenRequest(AuthResponse: TclJSONObject; const ARedirectUrl: string): TclJSONBase;
var
  http: TclHttp;
  req: TclHttpRequest;
  item: TclFormFieldRequestItem;
begin
  http := OAuth.GetHttpClient();
  Assert(http <> nil);

  req := OAuth.GetRequest();
  Assert(req <> nil);

  req.Clear();
  req.AddFormFieldIfNeed('grant_type', 'authorization_code');
  req.AddFormFieldIfNeed('code', AuthResponse.ValueByName('code'));
  req.AddFormFieldIfNeed('client_id', OAuth.ClientID);
  req.AddFormFieldIfNeed('client_secret', OAuth.ClientSecret);

  item := req.AddFormFieldIfNeed('redirect_uri', ARedirectUrl);
  if (item <> nil) then
  begin
    item.Canonicalized := OAuth.EscapeRedirectUrl;
  end;

  Result := SendTokenRequest(http, req);
end;

function TclOAuthCodeFlow.GetAuthorizationUrl: string;
begin
  Assert(OAuth <> nil);
  Assert(AuthorizationEndPoint <> nil);

  Result := AuthorizationEndPoint.GetAuthorizationUrl(rtAuthCode);
end;

function TclOAuthCodeFlow.GetAuthorizationToken(AuthResponse: TclJSONObject): TclOAuthToken;
var
  token_resp: TclJSONBase;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'GetAuthorizationToken');{$ENDIF}

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'GetAuthorizationToken, AuthResponse: ' + AuthResponse.GetJSONString());{$ENDIF}
  Result := CreateToken();
  try
    token_resp := SendAuthCodeTokenRequest(AuthResponse, AuthorizationEndPoint.RedirectUrl);
    try
      Result.Parse(token_resp);
    finally
      token_resp.Free();
    end;
  except
    Result.Free();
    raise;
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'GetAuthorizationToken'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'GetAuthorizationToken', E); raise; end; end;{$ENDIF}
end;

function TclOAuthCodeFlow.RequestToken(const ARequestUri: string): TclOAuthToken;
var
  auth_resp: TclJSONObject;
begin
  Assert(OAuth <> nil);
  Assert(AuthorizationEndPoint <> nil);

  auth_resp := AuthorizationEndPoint.Authorize(ARequestUri);
  try
    Result := GetAuthorizationToken(auth_resp);
  finally
    auth_resp.Free();
  end;
end;

function TclOAuthCodeFlow.RequestToken: TclOAuthToken;
var
  auth_resp: TclJSONObject;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'RequestToken');{$ENDIF}
  Assert(OAuth <> nil);
  Assert(AuthorizationEndPoint <> nil);

  auth_resp := AuthorizationEndPoint.Authorize(rtAuthCode);
  try
    Result := GetAuthorizationToken(auth_resp);
  finally
    auth_resp.Free();
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'RequestToken'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'RequestToken', E); raise; end; end;{$ENDIF}
end;

{ TclEnterCodeFormEndPoint }

function TclEnterCodeFormEndPoint.Authorize(const ARequestUri: string): TclJSONObject;
begin
  Result := nil;
  Assert(False);
end;

function TclEnterCodeFormEndPoint.BuildAuthInfo(AResponseType: TclAuthorizationResponseType;
  const AuthResponse: string): TclJSONObject;
const
  cJsonResponseTypeName: array[TclAuthorizationResponseType] of string = ('code', 'access_token', 'extension');

var
  pair: TclJSONPair;
begin
  Result := TclJSONObject.Create();
  try
    pair := TclJSONPair.Create();
    Result.AddMember(pair);

    pair.Name := cJsonResponseTypeName[AResponseType];
    pair.Value := TclJSONString.Create(AuthResponse);
  except
    Result.Free();
    raise;
  end;
end;

function TclEnterCodeFormEndPoint.Authorize(AResponseType: TclAuthorizationResponseType): TclJSONObject;
var
  auth_url: string;
begin
  Assert(OAuth <> nil);

  RedirectUrl := OAuth.RedirectUrl;
  auth_url := GetAuthorizationUrl(AResponseType);
  LaunchBrowser(auth_url);
  Result := BuildAuthInfo(AResponseType, ShowEnterCodeForm());
end;

function TclEnterCodeFormEndPoint.ShowEnterCodeForm: string;
var
  handled: Boolean;
begin
  Result := '';
  handled := False;
  OAuth.DoShowEnterCodeForm(Result, handled);

  if (not handled) then
  begin
    Result := InputBox(OAuth.EnterCodeFormCaption, OAuth.EnterCodeFormCaption, Result);
  end;

  Result := Trim(Result);

  if (Result = '') then
  begin
    raise EclOAuthError.Create(AuthorizationCodeError, AuthorizationCodeErrorCode);
  end;
end;

{ TclImplicitGrantFlow }

function TclImplicitGrantFlow.GetAuthorizationUrl: string;
begin
  Assert(OAuth <> nil);
  Assert(AuthorizationEndPoint <> nil);

  Result := AuthorizationEndPoint.GetAuthorizationUrl(rtAuthToken);
end;

function TclImplicitGrantFlow.RequestToken: TclOAuthToken;
var
  token_response: TclJSONObject;
begin
  Assert(OAuth <> nil);
  Assert(AuthorizationEndPoint <> nil);

  Result := CreateToken();
  try
    token_response := AuthorizationEndPoint.Authorize(rtAuthToken);
    try
      Result.Parse(token_response);
    finally
      token_response.Free();
    end;
  except
    Result.Free();
    raise;
  end;
end;

function TclImplicitGrantFlow.RequestToken(const ARequestUri: string): TclOAuthToken;
var
  token_response: TclJSONObject;
begin
  Assert(OAuth <> nil);
  Assert(AuthorizationEndPoint <> nil);

  Result := CreateToken();
  try
    token_response := AuthorizationEndPoint.Authorize(ARequestUri);
    try
      Result.Parse(token_response);
    finally
      token_response.Free();
    end;
  except
    Result.Free();
    raise;
  end;
end;

{ TclOAuthAuthorizationFlow }

procedure TclOAuthAuthorizationFlow.CheckOAuthError(AHttp: TclHttp; AResponse: TStrings);
var
  json: TclJSONBase;
  error, error_description: string;
begin
  if (AHttp.StatusCode < 400) then Exit;

  if (system.Pos('json', AHttp.ResponseHeader.ContentType) < 1) then
  begin
    raise EclHttpError.Create(AHttp.StatusText, AHttp.StatusCode, AResponse.Text);
  end;

  json := TclJSONBase.Parse(AResponse.Text);
  try
    if not (json is TclJSONObject) then
    begin
      raise EclHttpError.Create(AHttp.StatusText, AHttp.StatusCode, AResponse.Text);
    end;

    error_description := Trim((json as TclJSONObject).ValueByName('error_description'));
    if (error_description = '') then
    begin
      error_description := AResponse.Text;
    end;
    error := Trim((json as TclJSONObject).ValueByName('error'));

    raise EclHttpError.Create(error, AHttp.StatusCode, error_description);
  finally
    json.Free();
  end;
end;

function TclOAuthAuthorizationFlow.CreateToken: TclOAuthToken;
begin
  Result := OAuth.GetToken();
end;

function TclOAuthAuthorizationFlow.GetAuthorizationUrl: string;
begin
  Result := '';
  Assert(False);
end;

function TclOAuthAuthorizationFlow.RequestToken(const ARequestUri: string): TclOAuthToken;
begin
  Result := nil;
  Assert(False);
end;

function TclOAuthAuthorizationFlow.SendTokenRequest(AHttp: TclHttp; ARequest: TclHttpRequest): TclJSONBase;
var
  resp: TStrings;
begin
  resp := TStringList.Create();
  try
    AHttp.SilentHTTP := True;

    case OAuth.TokenEndPoint of
      tpUsePost: AHttp.Post(OAuth.TokenUrl, ARequest, resp);
      tpUseGet:  AHttp.Get(OAuth.TokenUrl, ARequest, resp)
    else
      Assert(False);
    end;

    CheckOAuthError(AHttp, resp);

    Result := TclJSONBase.Parse(resp.Text);
  finally
    resp.Free();
  end;
end;

{ TclLocalWebServerEndPoint }

function TclLocalWebServerEndPoint.Authorize(const ARequestUri: string): TclJSONObject;
var
  error, error_description: string;
begin
  Result := ParseAuthResult(ARequestUri);
  try
    error := Trim(Result.ValueByName('error'));
    if (error <> '') then
    begin
      error_description := Trim(Result.ValueByName('error_description'));
      raise EclHttpError.Create(error, 401, error_description);
    end;
  except
    Result.Free();
    raise;
  end;
end;

function TclLocalWebServerEndPoint.ExtractUrlPart(const AUrl: string; ADelimiter: Char): string;
var
  ind: Integer;
begin
  Result := AUrl;
  ind := system.Pos(ADelimiter, Result);
  if (ind > 0) then
  begin
    Result := system.Copy(Result, ind + 1, MaxInt);
  end;
end;

function TclLocalWebServerEndPoint.ParseAuthResult(const ARequestUri: string): TclJSONObject;
var
  req: TclHttpRequest;
  i: Integer;
  stream: TStream;
  item: TclHttpRequestItem;
  pair: TclJSONPair;
  auth: string;
begin
  req := OAuth.GetRequest();
  Assert(req <> nil);

  auth := ExtractUrlPart(ARequestUri, '?');
  auth := ExtractUrlPart(auth, '#');

  Result := TclJSONObject.Create();
  try
    stream := TStringStream.Create(auth);
    try
      req.RequestStream := stream;
    finally
      stream.Free();
    end;

    for i := 0 to req.Items.Count - 1 do
    begin
      item := req.Items[i];
      if (item is TclFormFieldRequestItem) then
      begin
        pair := TclJSONPair.Create();
        Result.AddMember(pair);

        pair.Name := (item as TclFormFieldRequestItem).FieldName;
        pair.Value := TclJSONString.Create((item as TclFormFieldRequestItem).FieldValue);
      end;
    end;
  except
    Result.Free();
    raise;
  end;
end;

function TclLocalWebServerEndPoint.GetRedirectUrl(const AUrl: string; APort: Integer): string;
var
  portStr: string;
  uri: TclUrlParser;
begin
  portStr := ':' + IntToStr(APort);
  Result := AUrl;

  if (Pos(portStr, Result) < 1) then
  begin
    uri := TclUrlParser.Create();
    try
      uri.Parse(AUrl, '');
      Result := StringReplace(Result, uri.Host, uri.Host + portStr, []);
    finally
      uri.Free();
    end;
  end;

  OAuth.DoRedirect(Result);
end;

function TclLocalWebServerEndPoint.Authorize(AResponseType: TclAuthorizationResponseType): TclJSONObject;
var
  server: TclSimpleHttpServer;
  auth_url: string;
  listen_port: Integer;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Authorize');{$ENDIF}
  Assert(OAuth <> nil);
  server := OAuth.GetHttpServer();
  Assert(server <> nil);

  listen_port := server.Listen(OAuth.LocalWebServerPort);

  RedirectUrl := GetRedirectUrl(OAuth.RedirectUrl, listen_port);

  auth_url := GetAuthorizationUrl(AResponseType);

  LaunchBrowser(auth_url);

  Result := AcceptRedirect(server);
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Authorize'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Authorize', E); raise; end; end;{$ENDIF}
end;

function TclLocalWebServerEndPoint.AcceptRedirect(AServer: TclSimpleHttpServer): TclJSONObject;
var
  error, error_description: string;
  i: Integer;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'AcceptRedirect');{$ENDIF}

  for i := 0 to 2 do
  begin
    AServer.AcceptRequest();
    {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'AcceptRedirect, accepted, requestUri: ' + AServer.RequestUri);{$ENDIF}

    Result := ParseAuthResult(AServer.RequestUri);
    try
    {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'AcceptRedirect, result parsed');{$ENDIF}
      error := Trim(Result.ValueByName('error'));
      if (error <> '') then
      begin
        error_description := Trim(Result.ValueByName('error_description'));
    {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'AcceptRedirect, 401 error: ' + error_description);{$ENDIF}
        AServer.SendResponse(401, error, OAuth.FailedHtmlResponse);

        raise EclHttpError.Create(error, 401, error_description);
      end else
      if (Trim(Result.ValueByName('code')) <> '') or (Trim(Result.ValueByName('access_token')) <> '') then
      begin
    {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'AcceptRedirect, 200 OK');{$ENDIF}
        AServer.SendResponse(200, 'OK', OAuth.SuccessHtmlResponse);

        Break;
      end else
      begin
    {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'AcceptRedirect, 404 error');{$ENDIF}
        AServer.SendResponse(404, 'Not found', OAuth.FailedHtmlResponse);
      end;
    except
      Result.Free();
      raise;
    end;
  end;

{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'AcceptRedirect'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'AcceptRedirect', E); raise; end; end;{$ENDIF}
end;

{ TclOAuthAuthorizationEndPoint }

function TclOAuthAuthorizationEndPoint.GetAuthorizationUrl(AResponseType: TclAuthorizationResponseType): string;
const
  cOAuthResponseTypeName: array[TclAuthorizationResponseType] of string = ('code', 'token', '');

var
  req: TclHttpRequest;
  item: TclFormFieldRequestItem;
begin
  Assert(OAuth <> nil);
  req := OAuth.GetRequest();
  Assert(req <> nil);

  req.Clear();
  req.AddFormFieldIfNeed('response_type', cOAuthResponseTypeName[AResponseType]);
  req.AddFormFieldIfNeed('client_id', OAuth.ClientID);

  item := req.AddFormFieldIfNeed('redirect_uri', RedirectUrl);
  if (item <> nil) then
  begin
    item.Canonicalized := OAuth.EscapeRedirectUrl;
  end;

  req.AddFormFieldIfNeed('scope', OAuth.Scope);
  req.AddFormFieldIfNeed('state', OAuth.State);

  Result := OAuth.AuthUrl + '?' + Trim(req.RequestSource.Text);
end;

procedure TclOAuthAuthorizationEndPoint.LaunchBrowser(const AUrl: string);
var
  handled: Boolean;
begin
  Assert(OAuth <> nil);

  handled := False;
  OAuth.DoLaunchBrowser(AUrl, handled);

  if (not handled) then
  begin
    ShellExecute(0, 'open', PChar(AUrl), nil, nil, SW_SHOWNORMAL);
  end;
end;

{ TclRefreshTokenFlow }

function TclRefreshTokenFlow.GetRefreshToken: TclJSONBase;
var
  http: TclHttp;
  req: TclHttpRequest;
begin
  http := OAuth.GetHttpClient();
  Assert(http <> nil);

  req := OAuth.GetRequest();
  Assert(req <> nil);

  Assert(OAuth.Token <> nil);

  req.Clear();
  req.AddFormFieldIfNeed('grant_type', 'refresh_token');
  req.AddFormFieldIfNeed('refresh_token', OAuth.Token.RefreshToken);
  req.AddFormFieldIfNeed('client_id', OAuth.ClientID);
  req.AddFormFieldIfNeed('client_secret', OAuth.ClientSecret);
  req.AddFormFieldIfNeed('scope', OAuth.Scope);

  Result := SendTokenRequest(http, req);
end;

function TclRefreshTokenFlow.RequestToken: TclOAuthToken;
var
  token_resp: TclJSONBase;
begin
  Assert(OAuth <> nil);

  Result := CreateToken();
  try
    token_resp := GetRefreshToken();
    try
      Result.Parse(token_resp);
    finally
      token_resp.Free();
    end;
  except
    Result.Free();
    raise;
  end;
end;

{ TclClientCredentialsFlow }


function TclClientCredentialsFlow.GetAuthToken: TclJSONBase;
var
  http: TclHttp;
  req: TclHttpRequest;
begin
  http := OAuth.GetHttpClient();
  Assert(http <> nil);

  req := OAuth.GetRequest();
  Assert(req <> nil);

  req.Clear();
  req.AddFormFieldIfNeed('grant_type', 'client_credentials');
  req.AddFormFieldIfNeed('scope', OAuth.Scope);

  http.UserName := OAuth.UserName;
  http.Password := OAuth.Password;

  Result := SendTokenRequest(http, req);
end;

function TclClientCredentialsFlow.RequestToken: TclOAuthToken;
var
  token_resp: TclJSONBase;
begin
  Assert(OAuth <> nil);

  Result := CreateToken();
  try
    token_resp := GetAuthToken();
    try
      Result.Parse(token_resp);
    finally
      token_resp.Free();
    end;
  except
    Result.Free();
    raise;
  end;
end;

{ TclUserPasswordFlow }

{ TclUserPasswordFlow }

function TclUserPasswordFlow.GetAuthToken: TclJSONBase;
var
  http: TclHttp;
  req: TclHttpRequest;
begin
  http := OAuth.GetHttpClient();
  Assert(http <> nil);

  req := OAuth.GetRequest();
  Assert(req <> nil);

  req.Clear();
  req.AddFormFieldIfNeed('grant_type', 'password');
  req.AddFormFieldIfNeed('username', OAuth.UserName);
  req.AddFormFieldIfNeed('password', OAuth.Password);
  req.AddFormFieldIfNeed('scope', OAuth.Scope);

  http.UserName := OAuth.UserName;
  http.Password := OAuth.Password;

  Result := SendTokenRequest(http, req);
end;

{ EclOAuthError }

constructor EclOAuthError.Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorMsg);
  FErrorCode := AErrorCode;
end;

{ TclWebApplicationEndPoint }

function TclWebApplicationEndPoint.Authorize(AResponseType: TclAuthorizationResponseType): TclJSONObject;
begin
  Assert(False);
  Result := nil;
end;

end.
