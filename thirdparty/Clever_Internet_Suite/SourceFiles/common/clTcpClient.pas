{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clTcpClient;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows, Messages, SyncObjs, SysUtils, WinSock,{$IFDEF DEMO} Forms,{$ENDIF}
{$ELSE}
  System.Classes, Winapi.Windows, Winapi.Messages, System.SyncObjs, System.SysUtils, Winapi.WinSock,{$IFDEF DEMO} Vcl.Forms,{$ENDIF}
{$ENDIF}
  clSocket, clFirewallUtils, clSocks, clWUtils, clSocketUtils, clUtils;

type
  EclTcpClientError = class(EclSocketError);

  TclTcpClient = class(TComponent)
  private
    FConnection: TclTcpClientConnection;
    FServer: string;
    FPort: Integer;
    FInProgress: Boolean;
    FFirewallSettings: TclFirewallSettings;
    FKeepAlive: Integer;
    FTimerHwnd: HWND;
    FAccessor: TCriticalSection;
    FTimerEnabled: Boolean;

    FOnChanged: TNotifyEvent;
    FOnClose: TNotifyEvent;
    FOnOpen: TNotifyEvent;

    procedure SetServer(const Value: string);
    procedure SetPort_(const Value: Integer);
    procedure SetBatchSize(const Value: Integer);
    procedure SetTimeOut(const Value: Integer);
    procedure SetBitsPerSec(const Value: Integer);
    function GetBatchSize: Integer;
    function GetBitsPerSec: Integer;
    function GetTimeOut: Integer;
    function GetActive: Boolean;
    procedure SetFirewallSettings(const Value: TclFirewallSettings);
    procedure SetLocalBinding(const Value: string);
    function GetLocalBinding: string;
    procedure SetKeepAlive(const Value: Integer);
    procedure StartKeepAliveTimer;
    procedure StopKeepAliveTimer;
    procedure KeepAliveCallback;
    procedure WndProc(var Message: TMessage);
  protected
    procedure CheckConnected;
    function GetFirewallStream(ABaseStream: TclNetworkStream; const ATargetServer: string; ATargetPort: Integer): TclSocksNetworkStream;
    function GetNetworkStream: TclNetworkStream; virtual;

    function GetDefaultPort: Integer; virtual; abstract;

    procedure OpenConnection(const AServer: string; APort: Integer); virtual;
    procedure InternalOpen; virtual;
    procedure InternalClose(ANotifyPeer: Boolean); virtual;
    procedure DoDestroy; virtual;
    procedure SendKeepAlive; virtual;

    procedure Changed; dynamic;
    procedure DoOpen; dynamic;
    procedure DoClose; dynamic;

    property InProgress: Boolean read FInProgress write FInProgress;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open;
    procedure Close;

    property Connection: TclTcpClientConnection read FConnection;
    property Active: Boolean read GetActive;
  published    
    property Server: string read FServer write SetServer;
    property Port: Integer read FPort write SetPort_;
    property LocalBinding: string read GetLocalBinding write SetLocalBinding;
    property BatchSize: Integer read GetBatchSize write SetBatchSize default 8192;
    property TimeOut: Integer read GetTimeOut write SetTimeOut default 60000;
    property BitsPerSec: Integer read GetBitsPerSec write SetBitsPerSec default 0;
    property KeepAlive: Integer read FKeepAlive write SetKeepAlive default 0;
    property FirewallSettings: TclFirewallSettings read FFirewallSettings write SetFirewallSettings;

    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
  end;

resourcestring
  FirewallInvalid = 'Unsupported firewall type';

const
  FirewallInvalidCode = -101;

procedure RaiseTcpClientError(const AErrorMessage: string; AErrorCode: Integer);

implementation

{$IFDEF LOGGER}
uses
  clLogger;
{$ENDIF}

procedure RaiseTcpClientError(const AErrorMessage: string; AErrorCode: Integer);
begin
  raise EclTcpClientError.Create(AErrorMessage, AErrorCode);
end;
  
{ TclTcpClient }

procedure TclTcpClient.Changed;
begin
  if Assigned(FOnChanged) then
  begin
    FOnChanged(Self);
  end;
end;

procedure TclTcpClient.CheckConnected;
begin
  Assert(FConnection <> nil);
  if not Active then
  begin
    RaiseSocketError(ConnectionClosed, ConnectionClosedCode);
  end;
end;

procedure TclTcpClient.Close;
var
  wasActive: Boolean;
begin
  StopKeepAliveTimer();
  wasActive := Active;
  InternalClose(True);
  if wasActive then
  begin
    DoClose();
  end;
end;

constructor TclTcpClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  StartupSocket();
  FFirewallSettings := TclFirewallSettings.Create();
  FConnection := TclTcpClientConnection.Create();
  BatchSize := 8192;
  TimeOut := 60000;
  BitsPerSec := 0;
  FKeepAlive := 0;
  FPort := GetDefaultPort();
  FTimerHwnd := 0;
  FAccessor := TCriticalSection.Create();
  FTimerEnabled := False;
end;

destructor TclTcpClient.Destroy;
begin
  Close();
  DoDestroy();
  if (FTimerHwnd <> 0) then
  begin
    DeallocateWindow(FTimerHwnd);
    FTimerHwnd := 0;
  end;

  FAccessor.Free();
  FConnection.Free();
  FFirewallSettings.Free();
  CleanupSocket();
  inherited Destroy();
end;

procedure TclTcpClient.DoClose;
begin
  if Assigned(OnClose) then
  begin
    OnClose(Self);
  end;
end;

procedure TclTcpClient.DoDestroy;
begin
end;

procedure TclTcpClient.DoOpen;
begin
  if Assigned(OnOpen) then
  begin
    OnOpen(Self);
  end;
end;

procedure TclTcpClient.InternalClose(ANotifyPeer: Boolean);
begin
  FConnection.Abort();
  FConnection.Close(ANotifyPeer);
end;

procedure TclTcpClient.InternalOpen;
begin
{$IFDEF DEMO}
{$IFNDEF STANDALONEDEMO}
  if FindWindow('TAppBuilder', nil) = 0 then
  begin
    MessageBox(0, 'This demo version can be run under Delphi/C++Builder IDE only. ' +
      'Please visit www.clevercomponents.com to purchase your ' +
      'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    ExitProcess(1);
  end;
{$ENDIF}
{$ENDIF}

  if (BatchSize < 1) then
  begin
    RaiseSocketError(InvalidBatchSize, InvalidBatchSizeCode);
  end;
  OpenConnection(Server, Port);
end;

procedure TclTcpClient.KeepAliveCallback;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'KeepAliveCallback');{$ENDIF}
  try
    try
      StopKeepAliveTimer();
      SendKeepAlive();
    except
    end;
  finally
    StartKeepAliveTimer();
  end;
end;

procedure TclTcpClient.Open;
begin
  if Active then Exit;
  try
    InternalOpen();
    StartKeepAliveTimer();
    DoOpen();
  except
    InProgress := True;
    try
      StopKeepAliveTimer();
      InternalClose(False);
    except
      on EclSocketError do ;
    end;
    InProgress := False;

    raise;
  end;
end;

procedure TclTcpClient.SendKeepAlive;
begin
end;

procedure TclTcpClient.SetBatchSize(const Value: Integer);
begin
  if (BatchSize <> Value) then
  begin
    Connection.BatchSize := Value;
    Changed();
  end;
end;

procedure TclTcpClient.SetPort_(const Value: Integer);
begin
  if (FPort <> Value) then
  begin
    FPort := Value;
    Changed();
  end;
end;

procedure TclTcpClient.SetServer(const Value: string);
begin
  if (FServer <> Value) then
  begin
    FServer := Value;
    Changed();
  end;
end;

procedure TclTcpClient.SetTimeOut(const Value: Integer);
begin
  if (TimeOut <> Value) then
  begin
    Connection.TimeOut := Value;
    Changed();
  end;
end;

procedure TclTcpClient.SetBitsPerSec(const Value: Integer);
begin
  if (BitsPerSec <> Value) then
  begin
    Connection.BitsPerSec := Value;
    Changed();
  end;
end;

function TclTcpClient.GetBatchSize: Integer;
begin
  Result := Connection.BatchSize;
end;

function TclTcpClient.GetBitsPerSec: Integer;
begin
  Result := Connection.BitsPerSec;
end;

function TclTcpClient.GetTimeOut: Integer;
begin
  Result := Connection.TimeOut;
end;

function TclTcpClient.GetActive: Boolean;
begin
  Result := Connection.Active;
end;

function TclTcpClient.GetLocalBinding: string;
begin
  Result := Connection.LocalBinding;
end;

function TclTcpClient.GetNetworkStream: TclNetworkStream;
begin
  Result := TclNetworkStream.Create();
end;

function TclTcpClient.GetFirewallStream(ABaseStream: TclNetworkStream; const ATargetServer: string; ATargetPort: Integer): TclSocksNetworkStream;
begin
  Result := nil;
  try
    case FirewallSettings.FirewallType of
      ftSocks4: Result := TclSocks4NetworkStream.Create(ABaseStream);
      ftSocks5: Result := TclSocks5NetworkStream.Create(ABaseStream)
    else
      begin
        Result := nil;
        RaiseTcpClientError(FirewallInvalid, FirewallInvalidCode);
      end;
    end;

    Result.TargetPort := ATargetPort;
    Result.UserName := FirewallSettings.UserName;
    Result.Password := FirewallSettings.Password;
    if FirewallSettings.NeedResolveIP then
    begin
      Result.TargetServer := ATargetServer;
    end else
    begin
      Result.TargetServer := TclHostResolver.GetIPAddress(ATargetServer);
    end;
  except
    Result.Free();
    raise;
  end;
end;

procedure TclTcpClient.OpenConnection(const AServer: string; APort: Integer);
var
  stream: TclNetworkStream;
begin
  Connection.NetworkStream := nil;
  stream := GetNetworkStream();

  if (FirewallSettings.Server <> '') then
  begin
    Connection.NetworkStream := GetFirewallStream(stream, AServer, APort);
    Connection.Open(TclHostResolver.GetIPAddress(FirewallSettings.Server), FirewallSettings.Port);
  end else
  begin
    Connection.NetworkStream := stream;
    Connection.Open(TclHostResolver.GetIPAddress(AServer), APort);
  end;
end;

procedure TclTcpClient.StartKeepAliveTimer;
begin
  FAccessor.Enter();
  try
    if (KeepAlive > 0) then
    begin
      if (FTimerHwnd = 0) then
      begin
        FTimerHwnd := AllocateWindow(WndProc);
        if (FTimerHwnd = 0) then
        begin
          RaiseSocketError(clGetLastError());
        end;
      end;
      
      if (SetTimer(FTimerHwnd, 1, KeepAlive, nil) = 0) then
      begin
        RaiseSocketError(clGetLastError());
      end;
      FTimerEnabled := True;
    end;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclTcpClient.StopKeepAliveTimer;
begin
  FAccessor.Enter();
  try
    if (FTimerHwnd <> 0) and FTimerEnabled then
    begin
      KillTimer(FTimerHwnd, 1);
      FTimerEnabled := False;
    end;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclTcpClient.WndProc(var Message: TMessage);
begin
  if (Message.Msg = WM_TIMER) then
  begin
    KeepAliveCallback();
  end;
end;

procedure TclTcpClient.SetFirewallSettings(const Value: TclFirewallSettings);
begin
  FFirewallSettings.Assign(Value);
end;

procedure TclTcpClient.SetKeepAlive(const Value: Integer);
begin
  if (FKeepAlive <> Value) then
  begin
    FKeepAlive := Value;
    Changed();
  end;
end;

procedure TclTcpClient.SetLocalBinding(const Value: string);
begin
  if (LocalBinding <> Value) then
  begin
    Connection.LocalBinding := Value;
    Changed();
  end;
end;

end.
