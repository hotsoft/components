{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clUdpServer;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows, WinSock, Messages, SyncObjs,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows, Winapi.WinSock, Winapi.Messages, System.SyncObjs,
{$ENDIF}
  clWinSock2, clThreadPool, clSocket, clServerGuard, clSocketUtils, clIpAddress, clUtils
  {$IFDEF DEMO}, clEncoder, clCertificate{$ENDIF}{$IFDEF LOGGER}, clLogger{$ENDIF};

type
  TclUdpUserConnection = class;
  TclUdpServer = class;

  TclUdpServerErrorEvent = procedure (Sender: TObject; E: Exception) of object;
  TclUdpCreateConnectionEvent = procedure (Sender: TObject; var AConnection: TclUdpUserConnection) of object;
  TclUdpConnectionDataEvent = procedure (Sender: TObject; AConnection: TclUdpUserConnection; AData: TStream) of object;

  EclUdpServerError = class(EclSocketError)
  end;

  TclUdpUserConnection = class(TclUdpConnection)
  private
    FOwner: TclUdpServer;
  public
    procedure Open(ALocalBindAddress: TclIPAddress; APort: Integer; const APeerIP: string; APeerPort: Integer);
    function WriteData(AData: TStream): Boolean; override;
  end;

  TclUdpListenConnection = class(TclConnection)
  private
    FAccessor: TCriticalSection;
  protected
    procedure DoDestroy; override;
  public
    constructor Create;

    procedure Open(const ALocalBindingIP: string; APort: Integer);
    procedure Close(ANotifyPeer: Boolean); override;
    function ReadData(AData: TStream): Boolean; override;
    function WriteData(AData: TStream): Boolean; override;
    procedure BeginWork;
    procedure EndWork;
  end;

  TclUdpServerThread = class(TThread)
  private
    FStopEvent: THandle;
    FWindowHandle: HWND;
    FServer: TclUdpServer;
    FServerConnection: TclUdpListenConnection;

    procedure DispatchMessages;
    procedure WndProc(var Message: TMessage);
    procedure ReadConnection;
    procedure OpenServerConnection;
    procedure CloseServerConnection;
    procedure SelectEvent(ASocket: TclSocket; lEvent: Integer);
  protected
    procedure Execute; override;
  public
    constructor Create(AServer: TclUdpServer);
    procedure Stop;
  end;

  TclUdpServer = class(TComponent)
  private
    FStartedEvent: THandle;
    FServerThread: TclUdpServerThread;
    FServerName: string;
    FPort: Integer;
    FDatagramSize: Integer;
    FBitsPerSec: Integer;
    FGuard: TclServerGuard;
    FLocalBinding: string;
    FWorkerThreadPool: TclThreadPool;
    FIsStart: Boolean;
    FStartError: string;
    FStartErrorCode: Integer;

    FOnStart: TNotifyEvent;
    FOnStop: TNotifyEvent;
    FOnServerError: TclUdpServerErrorEvent;
    FOnCreateConnection: TclUdpCreateConnectionEvent;
    FOnReadPacket: TclUdpConnectionDataEvent;
    FOnWritePacket: TclUdpConnectionDataEvent;

    procedure ReadConnection_(AConnection: TclUdpListenConnection);
    procedure ServerThreadTerminated;
    function GetMaxThreadCount: Integer;
    function GetMinThreadCount: Integer;
    procedure SetMaxThreadCount(const Value: Integer);
    procedure SetMinThreadCount(const Value: Integer);
    function GetActive: Boolean;
    procedure SetGuard(const Value: TclServerGuard);
    procedure InternalStart;
  protected
    procedure ReadConnection(AConnection: TclUdpListenConnection; AData: TStream); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoServerError(E: Exception); virtual;
    procedure DoCreateConnection(var AConnection: TclUdpUserConnection); virtual;
    procedure DoReadPacket(AConnection: TclUdpUserConnection; AData: TStream); virtual;
    procedure DoWritePacket(AConnection: TclUdpUserConnection; AData: TStream); virtual;
    procedure DoStart; virtual;
    procedure DoStop; virtual;

    function CreateNewConnection: TclUdpUserConnection;
    function CreateDefaultConnection: TclUdpUserConnection; virtual; abstract;
    procedure DoDestroy; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start;
    procedure Stop;

    property Active: Boolean read GetActive;
  published
    property ServerName: string read FServerName write FServerName;
    property Port: Integer read FPort write FPort;
    property DatagramSize: Integer read FDatagramSize write FDatagramSize default 8192;
    property MinThreadCount: Integer read GetMinThreadCount write SetMinThreadCount default 1;
    property MaxThreadCount: Integer read GetMaxThreadCount write SetMaxThreadCount default 5;
    property BitsPerSec: Integer read FBitsPerSec write FBitsPerSec default 0;
    property LocalBinding: string read FLocalBinding write FLocalBinding; 
    property Guard: TclServerGuard read FGuard write SetGuard;

    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnStop: TNotifyEvent read FOnStop write FOnStop;
    property OnServerError: TclUdpServerErrorEvent read FOnServerError write FOnServerError;
    property OnCreateConnection: TclUdpCreateConnectionEvent read FOnCreateConnection write FOnCreateConnection;
    property OnReadPacket: TclUdpConnectionDataEvent read FOnReadPacket write FOnReadPacket;
    property OnWritePacket: TclUdpConnectionDataEvent read FOnWritePacket write FOnWritePacket;
  end;

resourcestring
  UdpStartError = 'An unknown error occured during starting the server';
  UdpServerStartedError = 'The server is already started';
  UdpServerStoppedError = 'The server is not started';
  UdpConnectionBlocked = 'Connection is blocked';

const
  UdpStartErrorCode = -299;
  UdpServerStartedErrorCode = -300;
  UdpServerStoppedErrorCode = -301;
  UdpConnectionBlockedCode = -302;

implementation

const
  CL_SOCKETEVENT = WM_USER + 2111;

{ TclUdpServer }

constructor TclUdpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  StartupSocket();
  FWorkerThreadPool := TclThreadPool.Create(nil);

  MinThreadCount := 1;
  MaxThreadCount := 5;

  FDatagramSize := 8192;
end;

destructor TclUdpServer.Destroy;
begin
  Stop();
  DoDestroy();
  FWorkerThreadPool.Free();
  CleanupSocket();

  inherited Destroy();
end;

procedure TclUdpServer.DoDestroy;
begin
end;

procedure TclUdpServer.DoReadPacket(AConnection: TclUdpUserConnection; AData: TStream);
begin
  if Assigned(OnReadPacket) then
  begin
    OnReadPacket(Self, AConnection, AData);
  end;
end;

procedure TclUdpServer.DoServerError(E: Exception);
begin
  if Assigned(OnServerError) then
  begin
    OnServerError(Self, E);
  end;
end;

procedure TclUdpServer.DoStart;
begin
  if Assigned(OnStart) then
  begin
    OnStart(Self);
  end;
end;

procedure TclUdpServer.DoStop;
begin
  if Assigned(OnStop) then
  begin
    OnStop(Self);
  end;
end;

type
  TclUdpServerWorkItem = class(TclWorkItem)
  private
    FServer: TclUdpServer;
    FConnection: TclUdpListenConnection;
    FData: TStream;
  protected
    procedure Execute(AThread: TThread); override;
  public
    constructor Create(AServer: TclUdpServer; AConnection: TclUdpListenConnection; AData: TStream);
    destructor Destroy; override;
  end;

procedure TclUdpServer.DoWritePacket(AConnection: TclUdpUserConnection; AData: TStream);
begin
  if Assigned(OnWritePacket) then
  begin
    OnWritePacket(Self, AConnection, AData);
  end;
end;

function TclUdpServer.CreateNewConnection: TclUdpUserConnection;
begin
  Result := nil;
  DoCreateConnection(Result);

  if (Result = nil) then
  begin
    Result := CreateDefaultConnection();
  end;

  Result.FOwner := Self;
  Result.BatchSize := DatagramSize;
  Result.BitsPerSec := BitsPerSec;
  Result.NetworkStream := TclNetworkStream.Create();
end;

procedure TclUdpServer.DoCreateConnection(var AConnection: TclUdpUserConnection);
begin
  if Assigned(OnCreateConnection) then
  begin
    OnCreateConnection(Self, AConnection);
  end;
end;

{ TclUdpServerWorkItem }

constructor TclUdpServerWorkItem.Create(AServer: TclUdpServer; AConnection: TclUdpListenConnection; AData: TStream);
begin
  inherited Create();

  FServer := AServer;
  FConnection := AConnection;
  FData := AData;
end;

destructor TclUdpServerWorkItem.Destroy;
begin
  FData.Free();
  inherited Destroy();
end;

procedure TclUdpServerWorkItem.Execute(AThread: TThread);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Execute');{$ENDIF}
  Assert(FServer <> nil);
  Assert(FConnection <> nil);
  Assert(FData <> nil);
  try
    FConnection.InitProgress(0, 0);
    FServer.ReadConnection(FConnection, FData);
  except
    on E: Exception do
    begin
      FServer.DoServerError(E);
    end;
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Execute'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Execute', E); raise; end; end;{$ENDIF}
end;

function TclUdpServer.GetActive: Boolean;
begin
  Result := (FServerThread <> nil);
end;

function TclUdpServer.GetMaxThreadCount: Integer;
begin
  Result := FWorkerThreadPool.MaxThreadCount;
end;

function TclUdpServer.GetMinThreadCount: Integer;
begin
  Result := FWorkerThreadPool.MinThreadCount;
end;

procedure TclUdpServer.SetGuard(const Value: TclServerGuard);
begin
  if (FGuard <> Value) then
  begin
    if (FGuard <> nil) then
    begin
      FGuard.RemoveFreeNotification(Self);
    end;
    FGuard := Value;
    if (FGuard <> nil) then
    begin
      FGuard.FreeNotification(Self);
    end;
  end;
end;

procedure TclUdpServer.SetMaxThreadCount(const Value: Integer);
begin
  FWorkerThreadPool.MaxThreadCount := Value;
end;

procedure TclUdpServer.SetMinThreadCount(const Value: Integer);
begin
  FWorkerThreadPool.MinThreadCount := Value;
end;

procedure TclUdpServer.InternalStart;
begin
  FIsStart := True;
  try
    FStartedEvent := CreateEvent(nil, False, False, nil);
    if (FStartedEvent = 0) then
    begin
      RaiseSocketError(clGetLastError());
    end;
    try
    {$IFDEF DELPHI2010}
      FServerThread.Start();
    {$ELSE}
      FServerThread.Resume();
    {$ENDIF}
      WaitForSingleObject(FStartedEvent, INFINITE);
    finally
      CloseHandle(FStartedEvent);
      FStartedEvent := 0;
    end;
  finally
    FIsStart := False;
  end;
end;

procedure TclUdpServer.Start;
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
    if (not IsCertDemoDisplayed) and (not IsEncoderDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsCertDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Start');{$ENDIF}
  if Active then
  begin
    raise EclUdpServerError.Create(UdpServerStartedError, UdpServerStartedErrorCode);
  end;

  FServerThread := TclUdpServerThread.Create(Self);

  FStartError := '';
  FStartErrorCode := 0;

  InternalStart();

  if (FStartError <> '') or (FStartErrorCode <> 0) then
  begin
    if (FStartError = '') then
    begin
      FStartError := UdpStartError;
    end;
    if (FStartErrorCode = 0) then
    begin
      FStartErrorCode := UdpStartErrorCode;
    end;
    raise EclUdpServerError.Create(FStartError, FStartErrorCode);
  end;

{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Start'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Start', E); raise; end; end;{$ENDIF}
end;

procedure TclUdpServer.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) then Exit;
  if (AComponent = FGuard) then
  begin
    FGuard := nil;
  end;
end;

procedure TclUdpServer.ReadConnection(AConnection: TclUdpListenConnection; AData: TStream);
var
  newConnection: TclUdpUserConnection;
  addr: TclIPAddress;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'ReadConnection');{$ENDIF}
  if (Guard <> nil) then
  begin
    if (not Guard.Connect(AConnection.PeerIP, Port)) then
    begin
      raise EclUdpServerError.Create(UdpConnectionBlocked, UdpConnectionBlockedCode);
    end;
  end;

  AData.Position := 0;

  newConnection := nil;
  addr := nil;
  try
    newConnection := CreateNewConnection();
    addr := TclIPAddress.CreateBindingIpAddress(LocalBinding, AConnection.Socket.AddressFamily);

    newConnection.Open(addr, Port, AConnection.PeerIP, AConnection.PeerPort);
    DoReadPacket(newConnection, AData);
  finally
    addr.Free();
    newConnection.Free();
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'ReadConnection'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'ReadConnection', E); raise; end; end;{$ENDIF}
end;

procedure TclUdpServer.ReadConnection_(AConnection: TclUdpListenConnection);
var
  stream: TStream;
begin
  if (AConnection = nil) then Exit;

  stream := TMemoryStream.Create();
  try
    AConnection.ReadData(stream);

    FWorkerThreadPool.QueueWorkItem(TclUdpServerWorkItem.Create(Self, AConnection, stream));
  except
    on E: Exception do
    begin
      stream.Free();
      DoServerError(E);
    end;
  end;
end;

procedure TclUdpServer.Stop;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Stop');{$ENDIF}
  if (Active) then
  begin
    FWorkerThreadPool.Stop();
    FServerThread.Stop();
    DoStop();
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Stop'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Stop', E); raise; end; end;{$ENDIF}
end;

procedure TclUdpServer.ServerThreadTerminated;
begin
  FServerThread := nil;
end;

{ TclUdpServerThread }

constructor TclUdpServerThread.Create(AServer: TclUdpServer);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FServer := AServer;
end;

procedure TclUdpServerThread.DispatchMessages;
var
  msg: TMsg;
begin
  while PeekMessage(msg, 0, 0, 0, PM_REMOVE) do
  begin
    DispatchMessage(msg);
  end;
end;

procedure TclUdpServerThread.Execute;
var
  dwResult: DWORD;
begin
  try
    FStopEvent := 0;
    FWindowHandle := 0;
    FServerConnection := nil;
    try
      OpenServerConnection();

      Assert(FServer <> nil);

      SetEvent(FServer.FStartedEvent);
      FServer.DoStart();

      repeat
        dwResult := MsgWaitForMultipleObjects(1, FStopEvent, FALSE, INFINITE, QS_ALLEVENTS or QS_ALLINPUT);
        case dwResult of
          WAIT_OBJECT_0 + 1: DispatchMessages();
        end;
      until dwResult = WAIT_OBJECT_0;
    finally
      Assert(FServer <> nil);

      FServer.ServerThreadTerminated();
      CloseServerConnection();
    end;
  except
    on E: Exception do
    begin
      Assert(FServer <> nil);
      if FServer.FIsStart then
      begin
        FServer.FStartError := E.Message;
        if (E is EclSocketError) then
        begin
          FServer.FStartErrorCode := (E as EclSocketError).ErrorCode;
        end;
      end;

      FServer.DoServerError(E);
    end;
  end;
  if (FServer.FStartedEvent <> 0) then
  begin
    SetEvent(FServer.FStartedEvent);
  end;
end;

procedure TclUdpServerThread.CloseServerConnection;
begin
  FServerConnection.Free();
  FServerConnection := nil;

  if (FWindowHandle <> 0) then
  begin
    DeallocateWindow(FWindowHandle);
  end;

  if (FStopEvent > 0) then
  begin
    CloseHandle(FStopEvent);
    FStopEvent := 0;
  end;
end;

procedure TclUdpServerThread.OpenServerConnection;
begin
  if (FServer.Port <= 0) then
  begin
    raise EclSocketError.Create(InvalidPort, InvalidPortCode);
  end;

  FStopEvent := CreateEvent(nil, False, False, nil);
  if (FStopEvent = 0) then
  begin
    RaiseSocketError(clGetLastError());
  end;

  FWindowHandle := AllocateWindow(WndProc);
  if (FWindowHandle = 0) then
  begin
    RaiseSocketError(clGetLastError());
  end;

  FServerConnection := TclUdpListenConnection.Create();
  FServerConnection.BatchSize := FServer.DatagramSize;
  FServerConnection.BitsPerSec := FServer.BitsPerSec;
  FServerConnection.NetworkStream := TclNetworkStream.Create();

  FServerConnection.Open(FServer.LocalBinding, FServer.Port);

  SelectEvent(FServerConnection.Socket, FD_READ);
end;

procedure TclUdpServerThread.ReadConnection;
begin
  Assert(FServer <> nil);
  FServer.ReadConnection_(FServerConnection);
end;

procedure TclUdpServerThread.Stop;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'Stop');{$ENDIF}
  SetEvent(FStopEvent);
  WaitForSingleObject(Handle, INFINITE);
end;

procedure TclUdpServerThread.SelectEvent(ASocket: TclSocket; lEvent: Integer);
var
  res: Integer;
begin
  res := WSAAsyncSelect(ASocket.Socket, FWindowHandle, CL_SOCKETEVENT, lEvent);
  if (res = SOCKET_ERROR) then
  begin
    RaiseSocketError(WSAGetLastError());
  end;
end;

procedure TclUdpServerThread.WndProc(var Message: TMessage);
begin
  if (Message.Msg = CL_SOCKETEVENT) then
  begin
    case LOWORD(Message.lParam) of
      FD_READ: ReadConnection();
    end;
  end;
end;

{ TclUdpListenConnection }

procedure TclUdpListenConnection.BeginWork;
begin
  FAccessor.Enter();
end;

procedure TclUdpListenConnection.Close(ANotifyPeer: Boolean);
begin
  BeginWork();
  try
    inherited Close(ANotifyPeer);
  finally
    EndWork();
  end;
end;

constructor TclUdpListenConnection.Create;
begin
  inherited Create();
 
  FAccessor := TCriticalSection.Create();
end;

procedure TclUdpListenConnection.DoDestroy;
begin
  FAccessor.Free();
  
  inherited DoDestroy();
end;

procedure TclUdpListenConnection.EndWork;
begin
  FAccessor.Leave();
end;

procedure TclUdpListenConnection.Open(const ALocalBindingIP: string; APort: Integer);
var
  serverAddr: TclIPAddress;
begin
  serverAddr := TclIPAddress.CreateBindingIpAddress(ALocalBindingIP);
  try
    CreateSocket(serverAddr.AddressFamily, SOCK_DGRAM, IPPROTO_UDP);

    {$IFDEF DELPHIXE2}Winapi.{$ENDIF}WinSock.setsockopt(Socket.Socket, SOL_SOCKET, SO_REUSEADDR, '1', 1);

    NetworkStream.Bind(serverAddr, APort);

    SetActive(True);
    NetworkStream.StreamReady();
  finally
    serverAddr.Free();
  end;
end;

function TclUdpListenConnection.ReadData(AData: TStream): Boolean;
var
  port: Integer;
  addr: TclIpAddress;
begin
  addr := nil;
  BeginWork();
  try
    addr := TclIpAddress.CreateNone(Socket.AddressFamily);
    Result := NetworkStream.ReadFrom(AData, addr, port);
  finally
    EndWork();
    addr.Free();
  end;
end;

function TclUdpListenConnection.WriteData(AData: TStream): Boolean;
begin
  Result := True;
end;

{ TclUdpUserConnection }

procedure TclUdpUserConnection.Open(ALocalBindAddress: TclIPAddress; APort: Integer; const APeerIP: string; APeerPort: Integer);
begin
  NetworkStream.SetPeerInfo(APeerIP, APeerPort);
  
  CreateSocket(ALocalBindAddress.AddressFamily, SOCK_DGRAM, IPPROTO_UDP);

  {$IFDEF DELPHIXE2}Winapi.{$ENDIF}WinSock.setsockopt(Socket.Socket, SOL_SOCKET, SO_REUSEADDR, '1', 1);

  NetworkStream.Bind(ALocalBindAddress, APort);

  SetActive(True);
  NetworkStream.StreamReady();
end;

function TclUdpUserConnection.WriteData(AData: TStream): Boolean;
begin
  Result := inherited WriteData(AData);
  FOwner.DoWritePacket(Self, AData);
end;

end.
