{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clEmailValidator;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,{$IFDEF DEMO} Forms, Windows, clEncoder, clCertificate, clMailMessage,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils,{$IFDEF DEMO} Vcl.Forms, Winapi.Windows, clEncoder, clCertificate, clMailMessage,{$ENDIF}
{$ENDIF}
  clDnsQuery, clTcpClient, clSmtp, clSocketUtils, clUtils;

type
  TclEmailValidationLevel = ( vlBlacklist, vlSyntax, vlDomain, vlSmtp, vlMailbox );
  TclEmailValidationResult = (vrInvalid, vrBlacklistOk, vrSyntaxOk, vrDomainOk, vrSmtpOk, vrMailboxOk);

  EclEmailValidatorError = class(Exception);

  TclValidatorBase = class
  private
    FNext: TclValidatorBase;
  protected
    function ValidateEmail(const AEmailToValidate: string; AErrors: TclErrorList): TclEmailValidationResult; virtual; abstract;
  public
    constructor Create(ANext: TclValidatorBase);
    destructor Destroy; override;

    function Validate(const AEmailToValidate: string; AErrors: TclErrorList): TclEmailValidationResult;
  end;

  TclBlacklistValidator = class(TclValidatorBase)
  private
    FBlackList: TStrings;
  protected
    function ValidateEmail(const AEmailToValidate: string; AErrors: TclErrorList): TclEmailValidationResult; override;
  public
    constructor Create(ANext: TclValidatorBase; ABlackList: TStrings);
  end;

  TclSyntaxValidator = class(TclValidatorBase)
  private
    FPattern: string;
  protected
    function ValidateEmail(const AEmailToValidate: string; AErrors: TclErrorList): TclEmailValidationResult; override;
  public
    constructor Create(ANext: TclValidatorBase; const APattern: string);
  end;

  TclDomainValidator = class(TclValidatorBase)
  private
    FDns: TclDnsQuery;
  protected
    function ValidateEmail(const AEmailToValidate: string; AErrors: TclErrorList): TclEmailValidationResult; override;
  public
    constructor Create(ANext: TclValidatorBase; ADns: TclDnsQuery);

    property Dns: TclDnsQuery read FDns;
  end;

  TclEmailValidatorClient = class(TclCustomSmtp)
  protected
    procedure OpenSession; override;
    procedure CloseSession; override;
  public
    procedure ValidateMailbox(const AEmailFrom, AEmailToValidate: string);
    procedure Hello;
    procedure Quit;
  end;

  TclSmtpValidator = class(TclDomainValidator)
  private
    FClient: TclEmailValidatorClient;
  protected
    function ValidateServer(const AEmailToValidate, AServer: string; AErrors: TclErrorList): TclEmailValidationResult; virtual;
    function ValidateEmail(const AEmailToValidate: string; AErrors: TclErrorList): TclEmailValidationResult; override;
  public
    constructor Create(ANext: TclValidatorBase; ADns: TclDnsQuery; AClient: TclEmailValidatorClient);

    property Client: TclEmailValidatorClient read FClient;
  end;

  TclMailboxValidator = class(TclSmtpValidator)
  private
    FEmailFrom: string;
  protected
    function ValidateServer(const AEmailToValidate, AServer: string; AErrors: TclErrorList): TclEmailValidationResult; override;
  public
    constructor Create(ANext: TclValidatorBase; ADns: TclDnsQuery;
      AClient: TclEmailValidatorClient; const AEmailFrom: string);
  end;

  TclCreateValidatorEvent = procedure (Sender: TObject; const AEmailToValidate: string;
    AValidationLevel: TclEmailValidationLevel; var AValidator: TclValidatorBase) of object;

  TclEmailValidator = class(TComponent)
  private
    FOnCreateValidator: TclCreateValidatorEvent;
    FBlackList: TStrings;
    FSyntaxPattern: string;
    FEmailFrom: string;
    FValidationLevel: TclEmailValidationLevel;
    FSmtpClient: TclEmailValidatorClient;
    FDns: TclDnsQuery;
    FErrors: TclErrorList;
    
    procedure SetBlackList(const Value: TStrings);
    function GetHostName: string;
    procedure SetHostName(const Value: string);
    function GetTimeOut: Integer;
    procedure SetTimeOut(const Value: Integer);
    function GetDnsServer: string;
    procedure SetDnsServer(const Value: string);
    function GetValidator(const AEmail: string): TclValidatorBase;
  protected
    procedure DoCreateValidator(const AEmailToValidate: string;
      AValidationLevel: TclEmailValidationLevel; var AValidator: TclValidatorBase); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Validate(const AEmail: string): TclEmailValidationResult;

    property Dns: TclDnsQuery read FDns;
    property SmtpClient: TclEmailValidatorClient read FSmtpClient;
    property Errors: TclErrorList read FErrors;
  published
    property ValidationLevel: TclEmailValidationLevel read FValidationLevel write FValidationLevel default vlSmtp;
    property DnsServer: string read GetDnsServer write SetDnsServer;
    property TimeOut: Integer read GetTimeOut write SetTimeOut default 60000;
    property HostName: string read GetHostName write SetHostName;
    property EmailFrom: string read FEmailFrom write FEmailFrom;
    property SyntaxPattern: string read FSyntaxPattern write FSyntaxPattern;
    property BlackList: TStrings read FBlackList write SetBlackList;
     
    property OnCreateValidator: TclCreateValidatorEvent read FOnCreateValidator write FOnCreateValidator;
  end;

const
  DefaultSyntaxPattern = '\w+(([-]*|[+.])\w+)*@\w+(([-]*|[.])\w+)*\.\w+(([-]*|[.])\w+)*';

resourcestring
  cEmailInvalid = 'Email must not be empty';

implementation

uses
  clSocket, clSspi, clRegex, clMailUtils, clIdnTranslator;

{ TclValidatorBase }

constructor TclValidatorBase.Create(ANext: TclValidatorBase);
begin
  inherited Create();
  FNext := ANext;
end;

destructor TclValidatorBase.Destroy;
begin
  FNext.Free();
  inherited Destroy();
end;

function TclValidatorBase.Validate(const AEmailToValidate: string; AErrors: TclErrorList): TclEmailValidationResult;
var
  nextResult: TclEmailValidationResult;
begin
  Result := ValidateEmail(AEmailToValidate, AErrors);

  if (vrInvalid <> result) and (FNext <> nil) then
  begin
    nextResult := FNext.Validate(AEmailToValidate, AErrors);

    if (vrInvalid <> nextResult) then
    begin
      Result := nextResult;
    end;
  end;
end;

{ TclBlacklistValidator }

constructor TclBlacklistValidator.Create(ANext: TclValidatorBase; ABlackList: TStrings);
begin
  inherited Create(ANext);
  FBlackList := ABlackList;
end;

function TclBlacklistValidator.ValidateEmail(const AEmailToValidate: string; AErrors: TclErrorList): TclEmailValidationResult;
begin
  if FBlackList.IndexOf(AEmailToValidate) > -1 then
  begin
    Result := vrInvalid;
  end else
  begin
    Result := vrBlacklistOk;
  end;
end;

{ TclSyntaxValidator }

constructor TclSyntaxValidator.Create(ANext: TclValidatorBase; const APattern: string);
begin
  inherited Create(ANext);
  FPattern := APattern;
end;

function TclSyntaxValidator.ValidateEmail(const AEmailToValidate: string; AErrors: TclErrorList): TclEmailValidationResult;
begin
  if TclRegEx.ExactMatch(AEmailToValidate, FPattern, [rxoIgnoreCase])
    or TclRegEx.ExactMatch(GetIdnEmail(AEmailToValidate), FPattern, [rxoIgnoreCase]) then
  begin
    Result := vrSyntaxOk;
  end else
  begin
    Result := vrInvalid;
  end;
end;

{ TclDomainValidator }

constructor TclDomainValidator.Create(ANext: TclValidatorBase; ADns: TclDnsQuery);
begin
  inherited Create(ANext);
  FDns := ADns;
end;

function TclDomainValidator.ValidateEmail(const AEmailToValidate: string; AErrors: TclErrorList): TclEmailValidationResult;
begin
  try
    Dns.ResolveMX(AEmailToValidate);

    if (Dns.MailServers.Count > 0) then
    begin
      Result := vrDomainOk;
    end else
    begin
      Result := vrInvalid;
    end;
  except
    on E: EclSocketError do
    begin
      Result := vrInvalid;
      AErrors.AddError(E.Message, E.ErrorCode);
    end;
  end;
end;

{ TclEmailValidatorClient }

procedure TclEmailValidatorClient.CloseSession;
begin
end;

procedure TclEmailValidatorClient.Hello;
begin
  SendHelo();
end;

procedure TclEmailValidatorClient.OpenSession;
begin
end;

procedure TclEmailValidatorClient.Quit;
begin
  SendQuit();
end;

procedure TclEmailValidatorClient.ValidateMailbox(const AEmailFrom,
  AEmailToValidate: string);
var
  list: TStrings;
  from: string;
begin
  SendReset();

  from := AEmailFrom;
  if (Trim(from) = '') then
  begin
    from := AEmailToValidate;
  end;
  if (from = '') then
  begin
    raise EclEmailValidatorError.Create(cEmailInvalid);
  end;

  SendMailFrom(from);

  list := TStringList.Create();
  try
    list.Add(AEmailToValidate);
    SendRecipients(list);
  finally
    list.Free();
  end;
end;

{ TclSmtpValidator }

constructor TclSmtpValidator.Create(ANext: TclValidatorBase; ADns: TclDnsQuery;
  AClient: TclEmailValidatorClient);
begin
  inherited Create(ANext, ADns);
  FClient := AClient;
end;

function TclSmtpValidator.ValidateEmail(const AEmailToValidate: string; AErrors: TclErrorList): TclEmailValidationResult;
var
  i: Integer;
begin
  Result := inherited ValidateEmail(AEmailToValidate, AErrors);

  if (Result = vrInvalid) then Exit;

  for i := 0 to Dns.MailServers.Count - 1 do
  begin
    Result := ValidateServer(AEmailToValidate, Dns.MailServers[i].Name, AErrors);
    if (Result <> vrInvalid) then Exit;
  end;

  Result := vrInvalid;
end;

function TclSmtpValidator.ValidateServer(const AEmailToValidate, AServer: string; AErrors: TclErrorList): TclEmailValidationResult;
begin
  Result := vrInvalid;
  try
    try
      Client.Server := AServer;
      Client.Open();
      Result := vrSmtpOk;
    except
      on E: EclSspiError do
      begin
        AErrors.AddError(E.Message, E.ErrorCode);
      end;
      on E: EclSocketError do
      begin
        AErrors.AddError(E.Message, E.ErrorCode);
      end;
    end;
  finally
    Client.Close();
  end;
end;

{ TclMailboxValidator }

constructor TclMailboxValidator.Create(ANext: TclValidatorBase;
  ADns: TclDnsQuery; AClient: TclEmailValidatorClient; const AEmailFrom: string);
begin
  inherited Create(ANext, ADns, AClient);
  FEmailFrom := AEmailFrom;
end;

function TclMailboxValidator.ValidateServer(const AEmailToValidate, AServer: string; AErrors: TclErrorList): TclEmailValidationResult;
begin
  Result := vrInvalid;
  try
    try
      Client.Server := AServer;
      Client.Open();
      Result := vrSmtpOk;
      Client.Hello();

      try
        Client.ValidateMailbox(FEmailFrom, AEmailToValidate);
        Result := vrMailboxOk;
      finally
        Client.Quit();
      end;
    except
      on E: EclSspiError do
      begin
        AErrors.AddError(E.Message, E.ErrorCode);
      end;
      on E: EclSocketError do
      begin
        AErrors.AddError(E.Message, E.ErrorCode);
      end;
    end;
  finally
    Client.Close();
  end;
end;

{ TclEmailValidator }

constructor TclEmailValidator.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FErrors := TclErrorList.Create();

  FBlackList := TStringList.Create();
  FSmtpClient := TclEmailValidatorClient.Create(nil);
  FDns := TclDnsQuery.Create(nil);

  FSyntaxPattern := DefaultSyntaxPattern;
  FValidationLevel := vlSmtp;
end;

destructor TclEmailValidator.Destroy;
begin
  FDns.Free();
  FSmtpClient.Free();
  FBlackList.Free();
  FErrors.Free();

  inherited Destroy();
end;

procedure TclEmailValidator.DoCreateValidator(const AEmailToValidate: string;
  AValidationLevel: TclEmailValidationLevel; var AValidator: TclValidatorBase);
begin
  if Assigned(OnCreateValidator) then
  begin
    OnCreateValidator(Self, AEmailToValidate, AValidationLevel, AValidator);
  end;
end;

function TclEmailValidator.GetDnsServer: string;
begin
  Result := Dns.Server;
end;

function TclEmailValidator.GetHostName: string;
begin
  Result := SmtpClient.HostName;
end;

function TclEmailValidator.GetTimeOut: Integer;
begin
  Result := SmtpClient.TimeOut;
end;

function TclEmailValidator.GetValidator(const AEmail: string): TclValidatorBase;
begin
  Result := nil;
  DoCreateValidator(AEmail, ValidationLevel, Result);
  if (Result <> nil) then Exit;

  case ValidationLevel of
    vlBlacklist:
      begin
        Result := TclBlacklistValidator.Create(Result, BlackList);
      end;
    vlSyntax:
      begin
        Result := TclSyntaxValidator.Create(Result, SyntaxPattern);
        Result := TclBlacklistValidator.Create(Result, BlackList);
      end;
    vlDomain:
      begin
        Result := TclDomainValidator.Create(Result, Dns);
        Result := TclSyntaxValidator.Create(Result, SyntaxPattern);
        Result := TclBlacklistValidator.Create(Result, BlackList);
      end;
    vlSmtp:
      begin
        Result := TclSmtpValidator.Create(Result, Dns, SmtpClient);
        Result := TclSyntaxValidator.Create(Result, SyntaxPattern);
        Result := TclBlacklistValidator.Create(Result, BlackList);
      end;
    vlMailbox:
      begin
        Result := TclMailboxValidator.Create(Result, Dns, SmtpClient, EmailFrom);
        Result := TclSyntaxValidator.Create(Result, SyntaxPattern);
        Result := TclBlacklistValidator.Create(Result, BlackList);
      end
    else
      Assert(False, 'Not Implemented');
  end;
end;

procedure TclEmailValidator.SetBlackList(const Value: TStrings);
begin
  FBlackList.Assign(Value);
end;

procedure TclEmailValidator.SetDnsServer(const Value: string);
begin
  Dns.Server := Value;
end;

procedure TclEmailValidator.SetHostName(const Value: string);
begin
  SmtpClient.HostName := Value;
end;

procedure TclEmailValidator.SetTimeOut(const Value: Integer);
begin
  SmtpClient.TimeOut := Value;
end;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

function TclEmailValidator.Validate(const AEmail: string): TclEmailValidationResult;
var
  validator: TclValidatorBase;
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
    if (not IsDemoDisplayed)
      and (not IsSmtpDemoDisplayed) and (not IsEncoderDemoDisplayed)
      and (not IsCertDemoDisplayed) and (not IsMailMessageDemoDisplayed)
      and (not IsDnsDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsDemoDisplayed := True;
    IsSmtpDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsMailMessageDemoDisplayed := True;
    IsDnsDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  FErrors.Clear();
  validator := GetValidator(AEmail);
  try
    Result := validator.Validate(AEmail, FErrors);
  finally
    validator.Free();
  end;
end;

end.

