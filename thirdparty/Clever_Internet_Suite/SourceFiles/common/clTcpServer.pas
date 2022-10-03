{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clTcpServer;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, SyncObjs, Windows, WinSock, Messages,
{$ELSE}
  System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows, Winapi.WinSock, Winapi.Messages,
{$ENDIF}
  clSocket, clWinSock2, clThreadPool, clServerGuard, clIpAddress, clSocketUtils;

type
  TclTcpServerThread = class;
  TclUserConnection = class;
  TclTcpServer = class;

  TclServerErrorEvent = procedure (Sender: TObject; AConnection: TclUserConnection; E: Exception) of object;
  TclConnectionEvent = procedure (Sender: TObject; AConnection: TclUserConnection) of object;
  TclAcceptConnectionEvent = procedure (Sender: TObject; AConnection: TclUserConnection; var Handled: Boolean) of object;
  TclCreateConnectionEvent = procedure (Sender: TObject; var AConnection: TclUserConnection) of object;
  TclConnectionDataEvent = procedure (Sender: TObject; AConnection: TclUserConnection;
    AData: TStream) of object;

  EclTcpServerError = class(EclSocketError)
  end;

  IclUserConnection_ = interface(IUnknown)
    ['{70D8FE27-4DC5-4B22-9286-D47259446CD0}']
    function Get_Connection: TclUserConnection; stdcall;
    property Connection: TclUserConnection read Get_Connection;
  end;

  TclUserConnection = class(TclConnection, IclUserConnection_)
  private
    FRefCount: Integer;
    FAccessor: TCriticalSection;
    FWriteStream: TStream;
    FData: Pointer;
    FNeedClose: Boolean;
    FTimeTicks: DWORD;

  protected
    function Get_Connection: TclUserConnection; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
    procedure DoDestroy; override;
  public
    constructor Create;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class function NewInstance: TObject; override;

    procedure UpdateTimeTicks;
    procedure Close(ANotifyPeer: Boolean); override;
    function ReadData(AData: TStream): Boolean; override;
    function WriteData(AData: TStream): Boolean; override;
    procedure WriteDataAndClose(AData: TStream);
    procedure Accept;
    procedure AcceptDone;
    procedure OpenSession;
    procedure BeginWork;
    procedure EndWork;

    property TimeTicks: DWORD read FTimeTicks;
    property Data: Pointer read FData write FData;
  end;

  TclTcpServerThread = class(TThread)
  private
    FStopEvent: THandle;
    FStartedEvent: THandle;
    FConnections: IInterfaceList;
    FWindowHandle: HWND;
    FServerSocket: TclSocket;
    FServer: TclTcpServer;
    FTimerEnabled: Boolean;
    FIsStart: Boolean;
    FStartError: string;
    FStartErrorCode: Integer;

    procedure DispatchMessages;
    procedure WndProc(var Message: TMessage);
    procedure ClearConnections;
    procedure OpenServerSocket;
    procedure CloseServerSocket;
    procedure AcceptConnection;
    procedure ReadConnection(AConnection: IclUserConnection_);
    procedure WriteConnection(AConnection: IclUserConnection_);
    procedure CloseConnection(AConnection: IclUserConnection_);
    function FindConnection(ASocket: TSocket): IclUserConnection_;
    function GetConnection(Index: Integer): IclUserConnection_;
    procedure SelectEvent(ASocket: TclSocket; lEvent: Integer);
    procedure BeginWork;
    procedure EndWork;
    procedure InternalStartSessionTimer(ANextPeriod: DWORD);
    procedure StartSessionTimer;
    procedure StopSessionTimer;
    procedure SessionTimerCallback;
  protected
    procedure Execute; override;
  public
    constructor Create(AServer: TclTcpServer);
    procedure Start;
    procedure Stop;
  end;

  TclTcpServer = class(TComponent)
  private
    FAccessor: TCriticalSection;
    FPort: Integer;
    FServerThread: TclTcpServerThread;
    FBatchSize: Integer;
    FWorkerThreadPool: TclThreadPool;
    FServerName: string;
    FBitsPerSec: Integer;
    FLocalBinding: string;
    FMaxConnectionQueue: Integer;
    FStopping: Boolean;
    FSessionTimeOut: Integer;
    FGuard: TclServerGuard;

    FOnStart: TNotifyEvent;
    FOnStop: TNotifyEvent;
    FOnServerError: TclServerErrorEvent;
    FOnAcceptConnection: TclAcceptConnectionEvent;
    FOnCloseConnection: TclConnectionEvent;
    FOnCreateConnection: TclCreateConnectionEvent;
    FOnReadConnection: TclConnectionDataEvent;
    FOnWriteConnection: TclConnectionEvent;

    procedure AcceptConnection_(AConnection: IclUserConnection_);
    procedure ReadConnection_(AConnection: IclUserConnection_);
    procedure WriteConnection_(AConnection: IclUserConnection_);
    function GetMaxThreadCount: Integer;
    function GetMinThreadCount: Integer;
    procedure SetMaxThreadCount(const Value: Integer);
    procedure SetMinThreadCount(const Value: Integer);
    function GetConnection(Index: Integer): TclUserConnection;
    function GetConnectionCount: Integer;
    function GetActive: Boolean;
    procedure InternalStop;
    procedure AcceptConnectionDone(Sender: TObject);
    procedure SetSessionTimeOut(const Value: Integer);
    procedure SetGuard(const Value: TclServerGuard);
  protected
    procedure CloseConnection_(AConnection: IclUserConnection_);
    procedure ReadData(AConnection: TclUserConnection; AData: TStream);
    procedure ReadConnection(AConnection: TclUserConnection); virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoServerError(AConnection: TclUserConnection; E: Exception); virtual;
    procedure DoCreateConnection(var AConnection: TclUserConnection); virtual;
    procedure DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean); virtual;
    procedure DoCloseConnection(AConnection: TclUserConnection); virtual;
    procedure DoReadConnection(AConnection: TclUserConnection; AData: TStream); virtual;
    procedure DoWriteConnection(AConnection: TclUserConnection); virtual;
    procedure DoStart; virtual;
    procedure DoStop; virtual;

    procedure DoDestroy; virtual;
    function CreateNewConnection: TclUserConnection; virtual;
    function CreateDefaultConnection: TclUserConnection; virtual; abstract;
    function CreateThreadPool: TclThreadPool; virtual;
    procedure AssignNetworkStream(AConnection: TclUserConnection); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure CloseConnection(AConnection: TclUserConnection);
    procedure Start;
    procedure Stop;
    procedure BeginWork;
    procedure EndWork;

    property Connections[Index: Integer]: TclUserConnection read GetConnection;
    property ConnectionCount: Integer read GetConnectionCount;
    property Active: Boolean read GetActive;
  published
    property ServerName: string read FServerName write FServerName;
    property Port: Integer read FPort write FPort;
    property BatchSize: Integer read FBatchSize write FBatchSize default 8192;
    property MaxConnectionQueue: Integer read FMaxConnectionQueue write FMaxConnectionQueue default 100;
    property MinThreadCount: Integer read GetMinThreadCount write SetMinThreadCount default 1;
    property MaxThreadCount: Integer read GetMaxThreadCount write SetMaxThreadCount default 5;
    property BitsPerSec: Integer read FBitsPerSec write FBitsPerSec default 0;
    property LocalBinding: string read FLocalBinding write FLocalBinding;
    property SessionTimeOut: Integer read FSessionTimeOut write SetSessionTimeOut default 600000;
    property Guard: TclServerGuard read FGuard write SetGuard;

    property OnStart: TNotifyEvent read FOnStart write FOnStart;
    property OnStop: TNotifyEvent read FOnStop write FOnStop;
    property OnServerError: TclServerErrorEvent read FOnServerError write FOnServerError;
    property OnCreateConnection: TclCreateConnectionEvent read FOnCreateConnection write FOnCreateConnection;
    property OnAcceptConnection: TclAcceptConnectionEvent read FOnAcceptConnection write FOnAcceptConnection;
    property OnCloseConnection: TclConnectionEvent read FOnCloseConnection write FOnCloseConnection;
    property OnReadConnection: TclConnectionDataEvent read FOnReadConnection write FOnReadConnection;
    property OnWriteConnection: TclConnectionEvent read FOnWriteConnection write FOnWriteConnection;
  end;

resourcestring
  StartError = 'An unknown error occured during starting the server';
  ServerStartedError = 'The server is already started';
  ServerStoppedError = 'The server is not started';
  ConnectionBlocked = 'Connection is blocked';
  CreateConnectionError = 'Connection is not created';


const
  StartErrorCode = -299;
  ServerStartedErrorCode = -300;
  ServerStoppedErrorCode = -301;
  ConnectionBlockedCode = -302;
  CreateConnectionErrorCode = -303;

  MinSessionTimeout = 5000;

implementation

uses
  clUtils{$IFDEF DEMO}, clCertificate, clEncoder{$ENDIF}{$IFDEF LOGGER}, clLogger{$ENDIF};

const
  CL_SOCKETEVENT = WM_USER + 2110;

{ TclTcpServer }

procedure TclTcpServer.AcceptConnectionDone(Sender: TObject);
var
  handled: Boolean;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'AcceptConnectionDone');{$ENDIF}
  handled := False;
  DoAcceptConnection(Sender as TclUserConnection, handled);
  (Sender as TclUserConnection).OnReady := nil;
end;

procedure TclTcpServer.AssignNetworkStream(AConnection: TclUserConnection);
begin
  AConnection.NetworkStream := TclNetworkStream.Create();
end;

procedure TclTcpServer.AcceptConnection_(AConnection: IclUserConnection_);
var
  conn: TclUserConnection;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'AcceptConnection_');{$ENDIF}
  conn := AConnection.Connection;

  AssignNetworkStream(conn);

  conn.BatchSize := BatchSize;
  conn.BitsPerSec := BitsPerSec;
  conn.OnReady := AcceptConnectionDone;

  conn.Accept();

  if (Guard <> nil) then
  begin
    if (not Guard.Connect(conn.PeerIP, Port)) then
    begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'AcceptConnection_ not Guard.Connect');{$ENDIF}
      raise EclTcpServerError.Create(ConnectionBlocked, ConnectionBlockedCode);
    end;
  end;

  FServerThread.SelectEvent(conn.Socket, FD_READ + FD_WRITE + FD_CLOSE);

  conn.AcceptDone();
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'AcceptConnection_'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'AcceptConnection_', E); raise; end; end;{$ENDIF}
end;

procedure TclTcpServer.BeginWork;
begin
  FAccessor.Enter();
end;

procedure TclTcpServer.CloseConnection_(AConnection: IclUserConnection_);
begin
  if (not Active) then
  begin
    raise EclTcpServerError.Create(ServerStoppedError, ServerStoppedErrorCode);
  end;
  FServerThread.CloseConnection(AConnection);
end;

procedure TclTcpServer.CloseConnection(AConnection: TclUserConnection);
begin
  CloseConnection_(IclUserConnection_(AConnection));
end;

constructor TclTcpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAccessor := TCriticalSection.Create();

  StartupSocket();
  FWorkerThreadPool := CreateThreadPool();

  FMaxConnectionQueue := 100;
  MinThreadCount := 1;
  MaxThreadCount := 5;

  FBatchSize := 8192;
  FSessionTimeOut := 600000;
end;

destructor TclTcpServer.Destroy;
begin
  Stop();
  DoDestroy();
  CleanupSocket();
  inherited Destroy();
end;

procedure TclTcpServer.DoDestroy;
begin
  FWorkerThreadPool.Free();
  FAccessor.Free();
end;

procedure TclTcpServer.DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean);
begin
  if Assigned(OnAcceptConnection) then
  begin
    OnAcceptConnection(Self, AConnection, Handled);
  end;
end;

procedure TclTcpServer.DoCloseConnection(AConnection: TclUserConnection);
begin
  if Assigned(OnCloseConnection) then
  begin
    OnCloseConnection(Self, AConnection);
  end;
end;

procedure TclTcpServer.DoReadConnection(AConnection: TclUserConnection; AData: TStream);
begin
  if Assigned(OnReadConnection) then
  begin
    OnReadConnection(Self, AConnection, AData);
  end;
end;

procedure TclTcpServer.DoServerError(AConnection: TclUserConnection; E: Exception);
begin
  if Assigned(OnServerError) then
  begin
    OnServerError(Self, AConnection, E);
  end;
end;

procedure TclTcpServer.DoStart;
begin
  if Assigned(OnStart) then
  begin
    OnStart(Self);
  end;
end;

procedure TclTcpServer.DoStop;
begin
  if Assigned(OnStop) then
  begin
    OnStop(Self);
  end;
end;

type
  TclTcpServerOperation = (soServerRead, soServerWrite);

  TclTcpServerWorkItem = class(TclWorkItem)
  private
    FServer: TclTcpServer;
    FConnection: IclUserConnection_;
    FOperation: TclTcpServerOperation;
    procedure DoRead;
    procedure DoWrite;
  protected
    procedure Execute(AThread: TThread); override;
  public
    constructor Create(AServer: TclTcpServer; AConnection: IclUserConnection_; AOperation: TclTcpServerOperation);
  end;

procedure TclTcpServer.DoWriteConnection(AConnection: TclUserConnection);
begin
  if Assigned(OnWriteConnection) then
  begin
    OnWriteConnection(Self, AConnection);
  end;
end;

procedure TclTcpServer.EndWork;
begin
  FAccessor.Leave();
end;

function TclTcpServer.GetConnection(Index: Integer): TclUserConnection;
begin
  if (not Active) then
  begin
    raise EclTcpServerError.Create(ServerStoppedError, ServerStoppedErrorCode);
  end;
  Result := FServerThread.GetConnection(Index).Connection;
end;

function TclTcpServer.GetConnectionCount: Integer;
begin
  if (not Active) then
  begin
    raise EclTcpServerError.Create(ServerStoppedError, ServerStoppedErrorCode);
  end;
  Result := FServerThread.FConnections.Count;
end;

function TclTcpServer.GetActive: Boolean;
begin
  Result := (FServerThread <> nil);
end;

function TclTcpServer.CreateNewConnection: TclUserConnection;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'CreateNewConnection');{$ENDIF}
  Result := nil;
  DoCreateConnection(Result);
  if (Result = nil) then
  begin
    Result := CreateDefaultConnection();
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'CreateNewConnection'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'CreateNewConnection', E); raise; end; end;{$ENDIF}
end;

function TclTcpServer.CreateThreadPool: TclThreadPool;
begin
  Result := TclThreadPool.Create(nil);
end;

procedure TclTcpServer.DoCreateConnection(var AConnection: TclUserConnection);
begin
  if Assigned(OnCreateConnection) then
  begin
    OnCreateConnection(Self, AConnection);
  end;
end;

{ TclTcpServerWorkItem }

constructor TclTcpServerWorkItem.Create(AServer: TclTcpServer;
  AConnection: IclUserConnection_; AOperation: TclTcpServerOperation);
begin
  inherited Create();
  FServer := AServer;
  FConnection := AConnection;
  FOperation := AOperation;
end;

procedure TclTcpServerWorkItem.DoRead;
begin
  if FConnection.Connection.Active then
  begin
    FServer.ReadConnection(FConnection.Connection);
  end;
end;

procedure TclTcpServerWorkItem.DoWrite;
var
  needClose: Boolean;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, Format('(%d) DoWrite', [FConnection.Connection.Socket.Socket]));{$ENDIF}
  FConnection.Connection.BeginWork();
  try
    FConnection.Connection.WriteData(nil);
    FServer.DoWriteConnection(FConnection.Connection);
    needClose := FConnection.Connection.FNeedClose;
  finally
    FConnection.Connection.EndWork();
  end;

  if needClose then
  begin
    FServer.FServerThread.CloseConnection(FConnection);
  end;

{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'DoWrite'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'DoWrite', E); raise; end; end;{$ENDIF}
end;          

procedure TclTcpServerWorkItem.Execute(AThread: TThread);
begin
  Assert(FServer <> nil);
  try
    FConnection.Connection.InitProgress(0, 0);
    case FOperation of
      soServerRead: DoRead();
      soServerWrite: DoWrite();
    end;
  except
    on E: Exception do
    begin
      try
        FServer.DoServerError(FConnection.Connection, E);
      except
        on Ex: Exception do
        begin
          FServer.DoServerError(nil, Ex);
        end;
      end;
    end;
  end;
end;

function TclTcpServer.GetMaxThreadCount: Integer;
begin
  Result := FWorkerThreadPool.MaxThreadCount;
end;

function TclTcpServer.GetMinThreadCount: Integer;
begin
  Result := FWorkerThreadPool.MinThreadCount;
end;

procedure TclTcpServer.ReadConnection_(AConnection: IclUserConnection_);
begin
  if (AConnection = nil) or FStopping then Exit;
  {$IFDEF LOGGER}clPutLogMessage(Self, edInside, Format('(%d) ReadConnection_ before QueueWorkItem', [AConnection.Connection.Socket.Socket]));{$ENDIF}
  FWorkerThreadPool.QueueWorkItem(TclTcpServerWorkItem.Create(Self, AConnection, soServerRead));
end;

procedure TclTcpServer.ReadData(AConnection: TclUserConnection; AData: TStream);
begin
  FServerThread.SelectEvent(AConnection.Socket, FD_WRITE + FD_CLOSE);
  try
    AConnection.ReadData(AData);
  finally
    FServerThread.SelectEvent(AConnection.Socket, FD_READ + FD_WRITE + FD_CLOSE);
  end;
end;

procedure TclTcpServer.WriteConnection_(AConnection: IclUserConnection_);
begin
  if (AConnection = nil) or FStopping then Exit;
  {$IFDEF LOGGER}clPutLogMessage(Self, edInside, Format('(%d) WriteConnection_ before QueueWorkItem', [AConnection.Connection.Socket.Socket]));{$ENDIF}
  FWorkerThreadPool.QueueWorkItem(TclTcpServerWorkItem.Create(Self, AConnection, soServerWrite));
end;

procedure TclTcpServer.SetMaxThreadCount(const Value: Integer);
begin
  FWorkerThreadPool.MaxThreadCount := Value;
end;

procedure TclTcpServer.SetMinThreadCount(const Value: Integer);
begin
  FWorkerThreadPool.MinThreadCount := Value;
end;

procedure TclTcpServer.SetGuard(const Value: TclServerGuard);
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

procedure TclTcpServer.SetSessionTimeOut(const Value: Integer);
begin
  if ((Value >= MinSessionTimeout) or (Value < 1)) then
  begin
    FSessionTimeOut := Value;
  end;
end;

procedure TclTcpServer.Start;
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

  if Active then
  begin
    raise EclTcpServerError.Create(ServerStartedError, ServerStartedErrorCode);
  end;

  FServerThread := TclTcpServerThread.Create(Self);
  try
    FServerThread.Start();
  except
    InternalStop();
    raise;
  end;

  DoStart();
end;

procedure TclTcpServer.ReadConnection(AConnection: TclUserConnection);
var
  readStream: TStream;
begin
  readStream := TMemoryStream.Create();
  try
    AConnection.BeginWork();
    try
      ReadData(AConnection, readStream);
      readStream.Position := 0;
      DoReadConnection(AConnection, readStream);
    finally
      AConnection.EndWork();
    end;
  finally
    readStream.Free();
  end;
end;

procedure TclTcpServer.InternalStop;
begin
  FStopping := True;
  try
    FWorkerThreadPool.Stop();
    FServerThread.Stop();
    FServerThread.Free();
    FServerThread := nil;
  finally
    FStopping := False;
  end;
end;

procedure TclTcpServer.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) then Exit;
  if (AComponent = FGuard) then
  begin
    FGuard := nil;
  end;
end;

procedure TclTcpServer.Stop;
begin
  if (FServerThread = nil) then Exit;
  InternalStop();
  DoStop();
end;

{ TclTcpServerThread }

constructor TclTcpServerThread.Create(AServer: TclTcpServer);
begin
  inherited Create(True);
  FServer := AServer;
  FTimerEnabled := False;
end;

procedure TclTcpServerThread.EndWork;
begin
  FServer.EndWork();
end;

procedure TclTcpServerThread.Execute;
var
  dwResult: DWORD;
begin
  try
    FStopEvent := 0;
    FConnections := nil;
    FWindowHandle := 0;
    FServerSocket := TclSocket.Create();
    try
      try
        OpenServerSocket();
        StartSessionTimer();
        SetEvent(FStartedEvent);

        repeat
          dwResult := MsgWaitForMultipleObjects(1, FStopEvent, FALSE, INFINITE, QS_ALLEVENTS or QS_ALLINPUT);
          case dwResult of
            WAIT_OBJECT_0 + 1: DispatchMessages();
          end;
        until dwResult = WAIT_OBJECT_0;

      finally
        StopSessionTimer();
        CloseServerSocket();
      end;
    finally
      FreeAndNil(FServerSocket);
    end;
  except
    on E: Exception do
    begin
      Assert(FServer <> nil);

      if FIsStart then
      begin
        FStartError := E.Message;
        if (E is EclSocketError) then
        begin
          FStartErrorCode := (E as EclSocketError).ErrorCode;
        end;
      end;

      FServer.DoServerError(nil, E);
    end;
  end;
  if (FStartedEvent <> 0) then
  begin
    SetEvent(FStartedEvent);
  end;
end;

procedure TclTcpServerThread.CloseConnection(AConnection: IclUserConnection_);
var
  found: Boolean;
begin
  if (AConnection = nil) then Exit;

  found := False;
  BeginWork();
  try
    if (FConnections.IndexOf(AConnection) > -1) then
    begin
      FConnections.Remove(AConnection);
      found := True;
    end;
  finally
    EndWork();
  end;

  if found then
  begin
    AConnection.Connection.Abort();
    {$IFDEF LOGGER}clPutLogMessage(Self, edInside, Format('(%d) CloseConnection before Connection.Close(True)', [AConnection.Connection.Socket.Socket]));{$ENDIF}
    AConnection.Connection.Close(True);
    FServer.DoCloseConnection(AConnection.Connection);
  end;
end;

procedure TclTcpServerThread.ReadConnection(AConnection: IclUserConnection_);
begin
  Assert(FServer <> nil);
  FServer.ReadConnection_(AConnection);
end;

procedure TclTcpServerThread.AcceptConnection;
var
  iconn: IclUserConnection_;
begin
  Assert(FServer <> nil);
  iconn := FServer.CreateNewConnection();
  try
    if (iconn = nil) then
    begin
      raise EclTcpServerError.Create(CreateConnectionError, CreateConnectionErrorCode);
    end;
    BeginWork();
    try
      FConnections.Add(iconn);
    finally
      EndWork();
    end;
    iconn.Connection.Socket.SetSocket(FServerSocket.Socket, FServerSocket.AddressFamily);
    FServer.AcceptConnection_(iconn);
  except
    on E: Exception do
    begin
      FServer.DoServerError(iconn.Connection, E);
      try
        CloseConnection(iconn);
      except
        on Ex: Exception do
        begin
          FServer.DoServerError(iconn.Connection, Ex);
        end;
      end;
    end;
  end;
end;

procedure TclTcpServerThread.BeginWork;
begin
  FServer.BeginWork();
end;

procedure TclTcpServerThread.CloseServerSocket;
begin
  FServerSocket.Close();

  if (FWindowHandle <> 0) then
  begin
    DeallocateWindow(FWindowHandle);
  end;
  
  ClearConnections();
  FConnections := nil;
  if (FStopEvent > 0) then
  begin
    CloseHandle(FStopEvent);
    FStopEvent := 0;
  end;
end;

procedure TclTcpServerThread.OpenServerSocket;
var
  srv_address: TclIPAddress;
  res: Integer;
begin
  if (FServer.Port <= 0) then
  begin
    RaiseSocketError(InvalidPort, InvalidPortCode);
  end;

  FStopEvent := CreateEvent(nil, False, False, nil);
  if (FStopEvent = 0) then
  begin
    RaiseSocketError(clGetLastError());
  end;

  FConnections := TInterfaceList.Create();
  FWindowHandle := AllocateWindow(WndProc);
  if (FWindowHandle = 0) then
  begin
    RaiseSocketError(clGetLastError());
  end;

  srv_address := TclIPAddress.CreateBindingIpAddress(FServer.LocalBinding);
  try
    FServerSocket.SetSocket(socket(srv_address.AddressFamily, SOCK_STREAM, IPPROTO_TCP), srv_address.AddressFamily);
    if (FServerSocket.Socket = INVALID_SOCKET) then
    begin
      RaiseSocketError(WSAGetLastError());
    end;

    TclNetworkStream.CreateEndPoint(srv_address, FServer.Port);

    res := bind_gen(FServerSocket.Socket, srv_address.Address, srv_address.AddressLength);
    if (res = SOCKET_ERROR) then
    begin
      RaiseSocketError(WSAGetLastError());
    end;
  finally
    srv_address.Free();
  end;

  SelectEvent(FServerSocket, FD_ACCEPT);

  res := listen(FServerSocket.Socket, FServer.MaxConnectionQueue);
  if (res = SOCKET_ERROR) then
  begin
    RaiseSocketError(WSAGetLastError());
  end;
end;

function TclTcpServerThread.FindConnection(ASocket: TSocket): IclUserConnection_;
var
  i: Integer;
begin
  BeginWork();
  try
    for i := 0 to FConnections.Count - 1 do
    begin
      Result := (FConnections[i] as IclUserConnection_);
      if (Result.Connection.Socket.Socket = ASocket) then Exit;
    end;
    Result := nil;
  finally
    EndWork();
  end;
end;

function TclTcpServerThread.GetConnection(Index: Integer): IclUserConnection_;
begin
  BeginWork();
  try
    Result := (FConnections[Index] as IclUserConnection_);
  finally
    EndWork();
  end;
end;

procedure TclTcpServerThread.InternalStartSessionTimer(ANextPeriod: DWORD);
begin
  if (SetTimer(FWindowHandle, 1, ANextPeriod, nil) = 0) then
  begin
    RaiseSocketError(clGetLastError());
  end;
  FTimerEnabled := True;
end;

procedure TclTcpServerThread.ClearConnections;
var
  conn: IclUserConnection_;
begin
  while FConnections.Count > 0 do
  begin
    BeginWork();
    try
  {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ClearConnections, %d', nil, [FConnections.Count]);{$ENDIF}
      conn := (FConnections.Last as IclUserConnection_);
      FConnections.Remove(conn);
    finally
      EndWork();
    end;

    conn.Connection.Abort();
    conn.Connection.Close(False);
    FServer.DoCloseConnection(conn.Connection);
  end;
end;

procedure TclTcpServerThread.WndProc(var Message: TMessage);
begin
  if (Message.Msg = CL_SOCKETEVENT) then
  begin
    case LOWORD(Message.lParam) of
      FD_ACCEPT: AcceptConnection();
      FD_READ: ReadConnection(FindConnection(TSocket(Message.wParam)));
      FD_WRITE: WriteConnection(FindConnection(TSocket(Message.wParam)));
      FD_CLOSE: CloseConnection(FindConnection(TSocket(Message.wParam)));
    end;
  end else
  if (Message.Msg = WM_TIMER) then
  begin
    SessionTimerCallback();
  end;
end;

procedure TclTcpServerThread.DispatchMessages;
var
  msg: TMsg;
begin
  while PeekMessage(msg, 0, 0, 0, PM_REMOVE) do
  begin
    DispatchMessage(msg);
  end;
end;

procedure TclTcpServerThread.Stop;
begin
  SetEvent(FStopEvent);
  WaitForSingleObject(Handle, INFINITE);
end;

procedure TclTcpServerThread.StopSessionTimer;
begin
  BeginWork();
  try
    if FTimerEnabled then
    begin
      KillTimer(FWindowHandle, 1);
      FTimerEnabled := False;
    end;
  finally
    EndWork();
  end;
end;

procedure TclTcpServerThread.WriteConnection(AConnection: IclUserConnection_);
begin
  Assert(FServer <> nil);
  FServer.WriteConnection_(AConnection);
end;

procedure TclTcpServerThread.Start;
begin
  FIsStart := True;
  try
    FStartError := '';
    FStartErrorCode := 0;

    FStartedEvent := CreateEvent(nil, False, False, nil);
    if (FStartedEvent = 0) then
    begin
      RaiseSocketError(clGetLastError());
    end;
    try
    {$IFDEF DELPHI2010}
      inherited Start();
    {$ELSE}
      Resume();
    {$ENDIF}
      while not WaitForEvent(FStartedEvent, 0, 0, -1) do;
    finally
      CloseHandle(FStartedEvent);
      FStartedEvent := 0;
    end;

    if (FStartError <> '') or (FStartErrorCode <> 0) then
    begin
      if (FStartError = '') then
      begin
        FStartError := StartError;
      end;
      if (FStartErrorCode = 0) then
      begin
        FStartErrorCode := StartErrorCode;
      end;
      raise EclTcpServerError.Create(FStartError, FStartErrorCode);
    end;
  finally
    FIsStart := False;
  end;
end;

procedure TclTcpServerThread.StartSessionTimer;
begin
  BeginWork();
  try
    StopSessionTimer();
    if (FServer.SessionTimeOut > 0) then
    begin
      InternalStartSessionTimer(FServer.SessionTimeOut);
    end;
  finally
    EndWork();
  end;
end;

procedure TclTcpServerThread.SelectEvent(ASocket: TclSocket; lEvent: Integer);
var
  res: Integer;
begin
  res := WSAAsyncSelect(ASocket.Socket, FWindowHandle, CL_SOCKETEVENT, lEvent);
  if (res = SOCKET_ERROR) then
  begin
    RaiseSocketError(WSAGetLastError());
  end;
end;

procedure TclTcpServerThread.SessionTimerCallback;
var
  i: Integer;
  nextCheckPeriod, currentTicks, idleTime: DWORD;
  connection: IclUserConnection_;
  list: TInterfaceList;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'SessionTimerCallback');{$ENDIF}
  StopSessionTimer();

  if (FServer.SessionTimeOut < 1) then
  begin
    Exit;
  end;

  list := TInterfaceList.Create();
  try
    BeginWork();
    try
      nextCheckPeriod := FServer.SessionTimeOut;
      currentTicks := GetTickCount();

      for i := FConnections.Count - 1 downto 0 do
      begin
        connection := GetConnection(i);
        idleTime := currentTicks - connection.Connection.TimeTicks;
        if ((idleTime > MinSessionTimeout) and (idleTime > DWORD(FServer.SessionTimeOut))) then
        begin
  {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'SessionTimerCallback add to list');{$ENDIF}
          list.Add(connection);
        end else
        if ((DWORD(FServer.SessionTimeOut) - idleTime) < nextCheckPeriod) then
        begin
          nextCheckPeriod := DWORD(FServer.SessionTimeOut) - idleTime;
        end;
      end;

      InternalStartSessionTimer(nextCheckPeriod);
    finally
      EndWork();
    end;

    for i := 0 to list.Count - 1 do
    begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'SessionTimerCallback.CloseConnection');{$ENDIF}
      try
        CloseConnection(list[i] as IclUserConnection_);
      except
        on EclSocketError do;
        on E: Exception do
        begin
          FServer.DoServerError((list[i] as IclUserConnection_).Connection, E);
        end;
      end;
    end;
  finally
    list.Free();
  end;
end;

{ TclUserConnection }

procedure TclUserConnection.Accept;
begin
  NetworkStream.Accept();
  SetActive(True);
  NetworkStream.AcceptEnd();
end;

procedure TclUserConnection.AcceptDone;
begin
  NetworkStream.StreamReady();
end;

procedure TclUserConnection.AfterConstruction;
begin
// Release the constructor's implicit refcount
  InterlockedDecrement(FRefCount);
end;

procedure TclUserConnection.BeforeDestruction;
begin
{$IFDEF DELPHI6}
  if FRefCount <> 0 then
    System.Error(reInvalidPtr);
{$ELSE}
  if FRefCount <> 0 then
    raise Exception.Create('Invalid pointer');
{$ENDIF}
end;

procedure TclUserConnection.BeginWork;
begin
  FAccessor.Enter();
end;

procedure TclUserConnection.Close(ANotifyPeer: Boolean);
begin
  BeginWork();
  try
    inherited Close(ANotifyPeer);
  finally
    EndWork();
  end;
end;

constructor TclUserConnection.Create;
begin
  inherited Create();

  FAccessor := TCriticalSection.Create();
  FWriteStream := TMemoryStream.Create();

  FNeedClose := False;

  UpdateTimeTicks();
end;

class function TclUserConnection.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  TclUserConnection(Result).FRefCount := 1;
end;

procedure TclUserConnection.DoDestroy;
begin
  FWriteStream.Free();
  FAccessor.Free();
  inherited DoDestroy();
end;

procedure TclUserConnection.EndWork;
begin
  FAccessor.Leave();
end;

function TclUserConnection._AddRef: Integer;
begin
  Result := InterlockedIncrement(FRefCount);
end;

function TclUserConnection._Release: Integer;
begin
  Result := InterlockedDecrement(FRefCount);
  if Result = 0 then
    Destroy;
end;

function TclUserConnection.WriteData(AData: TStream): Boolean;
var
  oldPos: Int64;
begin
  Result := True;
  
  BeginWork();
  try
    UpdateTimeTicks();

    if (AData <> nil) and (AData.Size - AData.Position > 0) then
    begin
      oldPos := FWriteStream.Position;
      FWriteStream.Seek(0, soEnd);
      FWriteStream.CopyFrom(AData, AData.Size - AData.Position);
      FWriteStream.Position := oldPos;
    end;

    if (FWriteStream.Size > 0) then
    begin
      Result := NetworkStream.Write(FWriteStream);

      if Result then
      begin
        FWriteStream.Size := 0;
        FWriteStream.Position := 0;
      end;
    end;

  finally
    EndWork();
  end;
end;

procedure TclUserConnection.WriteDataAndClose(AData: TStream);
begin
  BeginWork();
  try
    UpdateTimeTicks();
    
    FNeedClose := True;
    WriteData(AData);
  finally
    EndWork();
  end;
end;

function TclUserConnection.Get_Connection: TclUserConnection;
begin
  Result := Self;
end;

procedure TclUserConnection.OpenSession;
begin
  NetworkStream.InitServerSession();
end;

function TclUserConnection.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := 0
  else
    Result := E_NOINTERFACE;
end;

function TclUserConnection.ReadData(AData: TStream): Boolean;
begin
  BeginWork();
  try
    UpdateTimeTicks();
    Result := NetworkStream.Read(AData);
  finally
    EndWork();
  end;
end;

procedure TclUserConnection.UpdateTimeTicks;
begin
  FTimeTicks := GetTickCount();
end;

end.
