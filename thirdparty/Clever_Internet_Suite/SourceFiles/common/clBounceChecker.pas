{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clBounceChecker;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes,
{$ELSE}
  System.Classes,
{$ENDIF}
  clPop3, clSmtp;

type
  TclBounceReason = (brNone, brTemporaryFailed, brBlocked, brFailed, brUnknown);
  TclBounceDeleteFlag = (dfTemporaryFailed, dfBlocked, dfFailed, dfUnknown,	dfAll);
  TclBounceDeleteFlags = set of TclBounceDeleteFlag;

  TclValidationMessageEvent = procedure (Sender: TObject; AMessage: TStrings;
    const AEmailToValidate: string; var AEmailFrom, ASubject, ABody: string) of object;
  TclCheckingSignatureEvent = procedure (Sender: TObject; AMessage, ASignatures: TStrings;
    var IsFound, Handled: Boolean) of object;
  TclCheckingBouncedEvent = procedure (Sender: TObject; AMessage: TStrings;
    const AEmailToValidate: string; var ABounceReason: TclBounceReason; var Handled: Boolean) of object;
  TclMessageCheckedEvent = procedure (Sender: TObject; AMessage: TStrings;
    AMessageNo: Integer; ABounceReason: TclBounceReason) of object;
  TclValidationSentEvent = procedure (Sender: TObject; const AEmailToValidate: string) of object;

  TclBounceCheckResults = class
  private
    FTemporaryFailed: TStrings;
    FBlocked: TStrings;
    FAll: TStrings;
    FUnknownReason: TStrings;
    FFailed: TStrings;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear; virtual;

    property TemporaryFailed: TStrings read FTemporaryFailed;
    property Blocked: TStrings read FBlocked;
    property Failed: TStrings read FFailed;
    property UnknownReason: TStrings read FUnknownReason;
    property All: TStrings read FAll;
  end;

  TclBounceCheckSignatures = class(TPersistent)
  private
    FTemporaryFailed: TStrings;
    FBlocked: TStrings;
    FFailed: TStrings;

    procedure SetBlocked(const Value: TStrings);
    procedure SetFailed(const Value: TStrings);
    procedure SetTemporaryFailed(const Value: TStrings);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; virtual;
  published
    property TemporaryFailed: TStrings read FTemporaryFailed write SetTemporaryFailed;
    property Blocked: TStrings read FBlocked write SetBlocked;
    property Failed: TStrings read FFailed write SetFailed;
  end;
  
  TclBounceChecker = class(TComponent)
  private
    FCheckTopLines: Integer;
    FCheckSignatures: Boolean;
    FCurrentMessage: Integer;
    FSignatures: TclBounceCheckSignatures;
    FBouncedEmails: TclBounceCheckResults;
    FDeleteMessages: TclBounceDeleteFlags;
    FAborted: Boolean;

    FOnCheckingBounced: TclCheckingBouncedEvent;
    FOnMessageChecked: TclMessageCheckedEvent;
    FOnCheckingSignature: TclCheckingSignatureEvent;
    FOnGetValidationMessage: TclValidationMessageEvent;
    FOnValidationSent: TclValidationSentEvent;

    procedure SetSignatures(const Value: TclBounceCheckSignatures);
    procedure GenValidationMessage(const AEmailToValidate, AEmailFrom, ASubject,
      ABody: string; AMessage: TStrings);
  protected
    procedure DoCheckingBounced(AMessage: TStrings; const AEmailToValidate: string;
      var ABounceReason: TclBounceReason; var Handled: Boolean); virtual;
    procedure DoMessageChecked(AMessage: TStrings; AMessageNo: Integer;
      ABounceReason: TclBounceReason); virtual;
    procedure DoCheckingSignature(AMessage, ASignatures: TStrings; var IsFound, Handled: Boolean); virtual;
    procedure DoGetValidationMessage(AMessage: TStrings; const AEmailToValidate: string;
      var AEmailFrom, ASubject, ABody: string); virtual;
    procedure DoValidationSent(const AEmailToValidate: string); virtual;

    procedure InitSignatures; virtual;
    function CheckSignature(ASignatures, AMessage: TStrings): Boolean; virtual;
    function CheckMessage(const AEmailToValidate: string; AMessage: TStrings): TclBounceReason; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    
    function CheckBounced(AEmailsToValidate, AMessage: TStrings): TclBounceReason; overload;
    function CheckBounced(AEmailsToValidate: TStrings;
      const APopServer, AUserName, APassword: string): Boolean; overload;
    function CheckBounced(AEmailsToValidate: TStrings; APop: TclPop3): Boolean; overload;
    function CheckBounced(AEmailsToValidate: TStrings; APop: TclPop3;
      AStartFromMessage: Integer): Boolean; overload;
    procedure Send(AEmailsToValidate: TStrings; const AEmailFrom: string); overload;
    procedure Send(AEmailsToValidate: TStrings; const AEmailFrom: string; ASmtp: TclSmtp); overload;
    procedure Abort;
    procedure Clear;

    property BouncedEmails: TclBounceCheckResults read FBouncedEmails;
    property CurrentMessage: Integer read FCurrentMessage;
  published
    property Signatures: TclBounceCheckSignatures read FSignatures write SetSignatures;
    property CheckSignatures: Boolean read FCheckSignatures write FCheckSignatures default True;
    property DeleteMessages: TclBounceDeleteFlags read FDeleteMessages write FDeleteMessages default [];
    property CheckTopLines: Integer read FCheckTopLines write FCheckTopLines default 80;

    property OnGetValidationMessage: TclValidationMessageEvent read FOnGetValidationMessage write FOnGetValidationMessage;
    property OnCheckingSignature: TclCheckingSignatureEvent read FOnCheckingSignature write FOnCheckingSignature;
    property OnCheckingBounced: TclCheckingBouncedEvent read FOnCheckingBounced write FOnCheckingBounced;
    property OnMessageChecked: TclMessageCheckedEvent read FOnMessageChecked write FOnMessageChecked;
    property OnValidationSent: TclValidationSentEvent read FOnValidationSent write FOnValidationSent;
  end;

const
  DefaultValidationSubject = '[No Subject]';
  DefaultValidationBody = 'This is an attempt to verify your email address.';
  DefaultValidationHeader = 'X-BounceCheck';

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

  
implementation

uses
{$IFNDEF DELPHIXE2}
  SysUtils{$IFDEF DEMO}, Forms, Windows, clCertificate, clDnsQuery{$ENDIF},
{$ELSE}
  System.SysUtils{$IFDEF DEMO}, Vcl.Forms, Winapi.Windows, clCertificate, clDnsQuery{$ENDIF},
{$ENDIF}
  clMailMessage, clSmtpRelay, clHeaderFieldList, clMailHeader, clEncoder;

{ TclBounceChecker }

procedure TclBounceChecker.Abort;
begin
  FAborted := True;
end;

function TclBounceChecker.CheckBounced(AEmailsToValidate: TStrings;
  const APopServer, AUserName, APassword: string): Boolean;
var
  pop: TclPop3;
begin
  pop := TclPop3.Create(nil);
  try
    pop.Server := APopServer;
    pop.UserName := AUserName;
    pop.Password := APassword;

    Result := CheckBounced(AEmailsToValidate, pop);
  finally
    pop.Free();
  end;
end;

function TclBounceChecker.CheckBounced(AEmailsToValidate, AMessage: TStrings): TclBounceReason;
var
  i: Integer;
  reason: TclBounceReason;
  email: string;
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
    if (not IsDemoDisplayed) and (not IsPop3DemoDisplayed)
      and (not IsSmtpDemoDisplayed) and (not IsEncoderDemoDisplayed)
      and (not IsCertDemoDisplayed) and (not IsMailMessageDemoDisplayed)
      and (not IsDnsDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsDemoDisplayed := True;
    IsPop3DemoDisplayed := True;
    IsSmtpDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsMailMessageDemoDisplayed := True;
    IsDnsDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  Result := brNone;

  for i := 0 to AEmailsToValidate.Count - 1 do
  begin
    email := AEmailsToValidate[i];
    reason := CheckMessage(email, AMessage);

    case reason of
      brTemporaryFailed: BouncedEmails.TemporaryFailed.Add(email);
      brBlocked: BouncedEmails.Blocked.Add(email);
      brFailed: BouncedEmails.Failed.Add(email);
      brUnknown: BouncedEmails.UnknownReason.Add(email);
    end;

    if (reason <> brNone) then
    begin
      Result := reason;
      BouncedEmails.All.Add(email);
    end;
  end;

  DoMessageChecked(AMessage, CurrentMessage, Result);
end;

function TclBounceChecker.CheckBounced(AEmailsToValidate: TStrings; APop: TclPop3): Boolean;
begin
  Result := CheckBounced(AEmailsToValidate, APop, 1);
end;

function TclBounceChecker.CheckBounced(AEmailsToValidate: TStrings;
  APop: TclPop3; AStartFromMessage: Integer): Boolean;
var
  i, msgCount: Integer;
  wasActive: Boolean;
  reason: TclBounceReason;
begin
  FAborted := False;
  Result := True;

  wasActive := APop.Active;
  APop.Open();
  try
    msgCount := APop.MessageCount;
    for i := AStartFromMessage to msgCount do
    begin
      if FAborted then Break;

      FCurrentMessage := i;

      APop.Retrieve(i);
      reason := CheckBounced(AEmailsToValidate, APop.Response);

      if FAborted then Break;

      if ((reason <> brNone) and (dfAll in DeleteMessages)) then
      begin
        APop.Delete(i);
      end else
      if ((reason = brTemporaryFailed) and (dfTemporaryFailed in DeleteMessages)) then
      begin
        APop.Delete(i);
      end else
      if ((reason = brBlocked) and (dfBlocked in DeleteMessages)) then
      begin
        APop.Delete(i);
      end else
      if ((reason = brFailed) and (dfFailed in DeleteMessages)) then
      begin
        APop.Delete(i);
      end else
      if ((reason = brUnknown) and (dfUnknown in DeleteMessages)) then
      begin
        APop.Delete(i);
      end;

      if (reason <> brNone) then
      begin
        Result := False;
      end;
    end;
  finally
    if not wasActive then
    begin
      APop.Close();
    end;
  end;
end;

function TclBounceChecker.CheckMessage(const AEmailToValidate: string; AMessage: TStrings): TclBounceReason;
var
  handled: Boolean;
  i, cnt: Integer;
  eml: string;
begin
  handled := False;
  DoCheckingBounced(AMessage, AEmailToValidate, Result, handled);

  if handled then Exit;

  Result := brNone;
  eml := LowerCase(AEmailToValidate);

  cnt := CheckTopLines;
  if (cnt < 1) or (cnt > AMessage.Count) then
  begin
    cnt := AMessage.Count;
  end;
  
  for i := 0 to cnt - 1 do
  begin
    if (System.Pos(eml, LowerCase(AMessage[i])) > 0) then
    begin
      if (CheckSignatures and CheckSignature(Signatures.TemporaryFailed, AMessage)) then
      begin
        Result := brTemporaryFailed;
      end else
      if (CheckSignatures and CheckSignature(Signatures.Blocked, AMessage)) then
      begin
        Result := brBlocked;
      end else
      if (CheckSignatures and CheckSignature(Signatures.Failed, AMessage)) then
      begin
        Result := brFailed;
      end else
      begin
        Result := brUnknown;
      end;
      Break;
    end;
  end;
end;

function TclBounceChecker.CheckSignature(ASignatures, AMessage: TStrings): Boolean;
var
  handled: Boolean;
  i, j, cnt: Integer;
begin
  handled := False;
  DoCheckingSignature(AMessage, ASignatures, Result, handled);

  if handled then Exit;

  if (ASignatures.Count = 0) then
  begin
    Result := False;
    Exit;
  end;

  cnt := CheckTopLines;
  if (cnt < 1) or (cnt > AMessage.Count) then
  begin
    cnt := AMessage.Count;
  end;

  for i := 0 to cnt - 1 do
  begin
    for j := 0 to ASignatures.Count - 1 do
    begin
      if (System.Pos(LowerCase(ASignatures[j]), LowerCase(AMessage[i])) > 0) then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;

  Result := False;
end;

procedure TclBounceChecker.Clear;
begin
  FCurrentMessage := 0;
  BouncedEmails.Clear();
end;

constructor TclBounceChecker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  FBouncedEmails := TclBounceCheckResults.Create();
  FSignatures := TclBounceCheckSignatures.Create();
  FCheckSignatures := True;
  FCheckTopLines := 80;
  FDeleteMessages := [];

  InitSignatures();
  Clear();
end;

destructor TclBounceChecker.Destroy;
begin
  FSignatures.Free();
  FBouncedEmails.Free();

  inherited Destroy();
end;

procedure TclBounceChecker.DoCheckingBounced(AMessage: TStrings;
  const AEmailToValidate: string; var ABounceReason: TclBounceReason; var Handled: Boolean);
begin
  if Assigned(OnCheckingBounced) then
  begin
    OnCheckingBounced(Self, AMessage, AEmailToValidate, ABounceReason, Handled);
  end;
end;

procedure TclBounceChecker.DoCheckingSignature(AMessage, ASignatures: TStrings;
  var IsFound, Handled: Boolean);
begin
  if Assigned(OnCheckingSignature) then
  begin
    OnCheckingSignature(Self, AMessage, ASignatures, IsFound, Handled);
  end;
end;

procedure TclBounceChecker.DoGetValidationMessage(AMessage: TStrings;
  const AEmailToValidate: string; var AEmailFrom, ASubject, ABody: string);
begin
  if Assigned(OnGetValidationMessage) then
  begin
    OnGetValidationMessage(Self, AMessage, AEmailToValidate, AEmailFrom, ASubject, ABody);
  end;
end;

procedure TclBounceChecker.DoMessageChecked(AMessage: TStrings;
  AMessageNo: Integer; ABounceReason: TclBounceReason);
begin
  if Assigned(OnMessageChecked) then
  begin
    OnMessageChecked(Self, AMessage, AMessageNo, ABounceReason);
  end;
end;

procedure TclBounceChecker.DoValidationSent(const AEmailToValidate: string);
begin
  if Assigned(OnValidationSent) then
  begin
    OnValidationSent(Self, AEmailToValidate);
  end;
end;

procedure TclBounceChecker.GenValidationMessage(const AEmailToValidate,
  AEmailFrom, ASubject, ABody: string; AMessage: TStrings);
var
  msg: TclMailMessage;
begin
  msg := TclMailMessage.Create(nil);
  try
    msg.BuildMessage(ABody, '');

    msg.Subject := ASubject;
    msg.From.FullAddress := AEmailFrom;
    msg.ToList.Add(AEmailToValidate);
    msg.ExtraFields.Add(TclHeaderFieldList.GetNameValuePair(DefaultValidationHeader, AEmailToValidate));

    AMessage.Assign(msg.MessageSource);
  finally
    msg.Free();
  end;
end;

procedure TclBounceChecker.InitSignatures;
  procedure InitTemporaryFailed(ASignatures: TStrings);
  begin
    ASignatures.Add('attempts to connect to the recipients mail server');
    ASignatures.Add('SERVICE NOT AVAILABLE');
    ASignatures.Add('451 Resources temporarily not available');
    ASignatures.Add('421 Too many');
    ASignatures.Add('Temporary error');
    ASignatures.Add('552 Quota violation');
    ASignatures.Add('disk quota exceeded');
    ASignatures.Add('non-fatal error');
  end;

  procedure InitBlocked(ASignatures: TStrings);
  begin
    ASignatures.Add('Access from ip address');
    ASignatures.Add('IP address is administratively disabled');
    ASignatures.Add('421 Message temporarily deferred');
    ASignatures.Add('550 relaying denied');
    ASignatures.Add('554 5.7.1 Rejected');
    ASignatures.Add('553 user doesn''t accept mail from you');
    ASignatures.Add('You are required to register');
    ASignatures.Add('content rejected');
  end;

  procedure InitFailed(ASignatures: TStrings);
  begin
    ASignatures.Add('Mailbox is inactive');
    ASignatures.Add('550 message to verify they are valid');
    ASignatures.Add('recipient rejected');
    ASignatures.Add('User unknown');
    ASignatures.Add('mailbox unavailable');
    ASignatures.Add('unknown user account');
    ASignatures.Add('recipient never logged onto their free AIM');
    ASignatures.Add('550 5.1.1 unknown or illegal alias');
    ASignatures.Add('550 No such user');
    ASignatures.Add('550 Invalid recipient');
    ASignatures.Add('550 username');
    ASignatures.Add('No such user');
    ASignatures.Add('550 That e-mail address does not exist');
    ASignatures.Add('550 Recipient Rejected: Account Inactive');
    ASignatures.Add('account has been disabled');
    ASignatures.Add('bad destination mailbox address');
    ASignatures.Add('no mailbox here by that name');
    ASignatures.Add('permanent error');
    ASignatures.Add('permanent fatal errors');
    ASignatures.Add('mail receiving disabled');
    ASignatures.Add('address was not found');
  end;

begin
  Signatures.Clear();

  InitTemporaryFailed(Signatures.TemporaryFailed);
  InitBlocked(Signatures.Blocked);
  InitFailed(Signatures.Failed);
end;

procedure TclBounceChecker.Send(AEmailsToValidate: TStrings; const AEmailFrom: string);
var
  relay: TclSmtpRelay;
begin
  relay := TclSmtpRelay.Create(nil);
  try
    Send(AEmailsToValidate, AEmailFrom, relay);
  finally
    relay.Free();
  end;
end;

procedure TclBounceChecker.Send(AEmailsToValidate: TStrings;
  const AEmailFrom: string; ASmtp: TclSmtp);
var
  i: Integer;
  msg: TStrings;
  email, emailFrom, subj, body: string;
begin
  FAborted := False;

  msg := TStringList.Create();
  try
    for i := 0 to AEmailsToValidate.Count - 1 do
    begin
      if FAborted then Break;

      msg.Clear();
      email := AEmailsToValidate[i];
      emailFrom := AEmailFrom;
      subj := DefaultValidationSubject;
      body := DefaultValidationBody;

      DoGetValidationMessage(msg, email, emailFrom, subj, body);

      if (msg.Count = 0) then
      begin
        GenValidationMessage(email, emailFrom, subj, body, msg);
      end;

      ASmtp.Send(msg);

      DoValidationSent(email);
    end;
  finally
    msg.Free();
  end;
end;

procedure TclBounceChecker.SetSignatures(const Value: TclBounceCheckSignatures);
begin
  FSignatures.Assign(Value);
end;

{ TclBounceCheckSignatures }

procedure TclBounceCheckSignatures.Assign(Source: TPersistent);
var
  src: TclBounceCheckSignatures;
begin
  if (Source is TclBounceCheckSignatures) then
  begin
    src := TclBounceCheckSignatures(Source);
    TemporaryFailed := src.TemporaryFailed;
    Blocked := src.Blocked;
    Failed := src.Failed;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclBounceCheckSignatures.Clear;
begin
  FTemporaryFailed.Clear();
  FBlocked.Clear();
  FFailed.Clear();
end;

constructor TclBounceCheckSignatures.Create;
begin
  inherited Create();
  FTemporaryFailed := TStringList.Create();
  FBlocked := TStringList.Create();
  FFailed := TStringList.Create();
end;

destructor TclBounceCheckSignatures.Destroy;
begin
  FFailed.Free();
  FBlocked.Free();
  FTemporaryFailed.Free();
  inherited Destroy();
end;

procedure TclBounceCheckSignatures.SetBlocked(const Value: TStrings);
begin
  FBlocked.Assign(Value);
end;

procedure TclBounceCheckSignatures.SetFailed(const Value: TStrings);
begin
  FFailed.Assign(Value);
end;

procedure TclBounceCheckSignatures.SetTemporaryFailed(const Value: TStrings);
begin
  FTemporaryFailed.Assign(Value);
end;

{ TclBounceCheckResults }

procedure TclBounceCheckResults.Clear;
begin
  FTemporaryFailed.Clear();
  FBlocked.Clear();
  FFailed.Clear();
  FUnknownReason.Clear();
  FAll.Clear();
end;

constructor TclBounceCheckResults.Create;
begin
  inherited Create();

  FTemporaryFailed := TStringList.Create();
  FBlocked := TStringList.Create();
  FFailed := TStringList.Create();
  FUnknownReason := TStringList.Create();
  FAll := TStringList.Create();
end;

destructor TclBounceCheckResults.Destroy;
begin
  FAll.Free();
  FUnknownReason.Free();
  FFailed.Free();
  FBlocked.Free();
  FTemporaryFailed.Free();

  inherited Destroy();
end;

end.

