{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSmtpFileHandler;

interface

{$I clVer.inc}
{$IFDEF DELPHI6}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows, SysUtils, SyncObjs,
{$ELSE}
  System.Classes, Winapi.Windows, System.SysUtils, System.SyncObjs,
{$ENDIF}
  clSmtpServer, clMailUserMgr;

type
  TclSmtpFileHandler = class(TComponent)
  private
    FServer: TclSmtpServer;
    FAccessor: TCriticalSection;
    FMailBoxDir: string;
    FRelayDir: string;
    FCounter: Integer;
    
    procedure DoMessageRelayed(Sender: TObject; AConnection: TclSmtpCommandConnection;
      const AMailFrom: string; ARecipients: TStrings; AMessage: TStrings; var Action: TclSmtpMailDataAction);
    procedure DoMessageDelivered(Sender: TObject; AConnection: TclSmtpCommandConnection;
      const AMailFrom, ARecipient: string; Account: TclMailUserAccountItem; AMessage: TStrings;
      var Action: TclSmtpMailDataAction);
    function GenMessageFileName(const APath: string): string;
    function GetMailBoxPath(const AUserName: string): string;

    procedure SetServer(const Value: TclSmtpServer);
    procedure SetMailBoxDir(const Value: string);
    procedure SetRelayDir(const Value: string);
    procedure SetCounter(const Value: Integer);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CleanEventHandlers; virtual;
    procedure InitEventHandlers; virtual;
    property Accessor: TCriticalSection read FAccessor;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Server: TclSmtpServer read FServer write SetServer;
    property MailBoxDir: string read FMailBoxDir write SetMailBoxDir;
    property RelayDir: string read FRelayDir write SetRelayDir;
    property Counter: Integer read FCounter write SetCounter default 1;
  end;

var
  cMessageFileExt: string = '.MSG';
  cEnvelopeFileExt: string = '.ENV';

implementation

uses
  clUtils;
  
{ TclSmtpFileHandler }

procedure TclSmtpFileHandler.CleanEventHandlers;
begin
  Server.OnMessageRelayed := nil;
  Server.OnMessageDelivered := nil;
end;

constructor TclSmtpFileHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAccessor := TCriticalSection.Create();
  FCounter := 1;
end;

destructor TclSmtpFileHandler.Destroy;
begin
  FAccessor.Free();
  inherited Destroy();
end;

procedure TclSmtpFileHandler.DoMessageDelivered(Sender: TObject; AConnection: TclSmtpCommandConnection;
  const AMailFrom, ARecipient: string; Account: TclMailUserAccountItem; AMessage: TStrings; var Action: TclSmtpMailDataAction);
var
  path: string;
begin
  try
    Assert(Account <> nil);
    path := GetMailBoxPath(Account.UserName);

    FAccessor.Enter();
    try
      ForceFileDirectories(path);

      TclStringsUtils.SaveStrings(AMessage, GenMessageFileName(path) + cMessageFileExt, '');
    finally
      FAccessor.Leave();
    end;

    Action := mdOk;
  except
    Action := mdProcessingError;
  end;
end;

procedure TclSmtpFileHandler.DoMessageRelayed(Sender: TObject; AConnection: TclSmtpCommandConnection;
  const AMailFrom: string; ARecipients: TStrings; AMessage: TStrings; var Action: TclSmtpMailDataAction);
var
  path: string;
  envelope: TStrings;
begin
  try
    path := AddTrailingBackSlash(RelayDir);

    FAccessor.Enter();
    try
      ForceFileDirectories(path);
      path := GenMessageFileName(path);

      TclStringsUtils.SaveStrings(AMessage, path + cMessageFileExt, '');

      envelope := nil;
      try
        envelope := TStringList.Create();
        envelope.Add(AMailFrom);
        envelope.AddStrings(ARecipients);

        TclStringsUtils.SaveStrings(envelope, path + cEnvelopeFileExt, '');
      finally
        envelope.Free();
      end;
    finally
      FAccessor.Leave();
    end;

    Action := mdOk;
  except
    Action := mdProcessingError;
  end;
end;

function TclSmtpFileHandler.GenMessageFileName(const APath: string): string;
var
  i: Integer;
begin
  FAccessor.Enter();
  try
    Inc(FCounter);

    Result := APath + Format('MAIL%.8d', [Counter]);
    i := 0;
    while (FileExists(Result)) do
    begin
      Result := APath + Format('MAIL%.8d%d', [Counter, i]);
      Inc(i);
    end;
  finally
    FAccessor.Leave();
  end;
end;

function TclSmtpFileHandler.GetMailBoxPath(const AUserName: string): string;
begin
  Result := AddTrailingBackSlash(MailBoxDir) + AddTrailingBackSlash(AUserName);
end;

procedure TclSmtpFileHandler.InitEventHandlers;
begin
  Server.OnMessageRelayed := DoMessageRelayed;
  Server.OnMessageDelivered := DoMessageDelivered;
end;

procedure TclSmtpFileHandler.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) then Exit;
  if (AComponent = FServer) then
  begin
    CleanEventHandlers();
    FServer := nil;
  end;
end;

procedure TclSmtpFileHandler.SetCounter(const Value: Integer);
begin
  FAccessor.Enter();
  try
    FCounter := Value;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclSmtpFileHandler.SetMailBoxDir(const Value: string);
begin
  FAccessor.Enter();
  try
    FMailBoxDir := Value;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclSmtpFileHandler.SetRelayDir(const Value: string);
begin
  FAccessor.Enter();
  try
    FRelayDir := Value;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclSmtpFileHandler.SetServer(const Value: TclSmtpServer);
begin
  if (FServer <> Value) then
  begin
    if (FServer <> nil) then
    begin
      FServer.RemoveFreeNotification(Self);
      CleanEventHandlers();
    end;
    FServer := Value;
    if (FServer <> nil) then
    begin
      FServer.FreeNotification(Self);
      InitEventHandlers();
    end;
  end;
end;

end.
