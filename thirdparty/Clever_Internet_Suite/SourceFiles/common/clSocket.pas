{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSocket;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows, WinSock, Messages,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows, Winapi.WinSock, Winapi.Messages,
{$ENDIF}
  clWinSock2, clIpAddress, clUtils, clSocketUtils;

type
  TclNetworkStreamAction = (saNone, saRead, saWrite);
  
  TclConnection = class;

  TclNetworkStream = class
  private
    FConnection: TclConnection;
    FSleepEvent: THandle;
    FNextAction: TclNetworkStreamAction;
    FIP: string;
    FPort: Integer;
    FPeerIP: string;
    FPeerPort: Integer;
    FHasReadData: Boolean;
    FBytesProceed: Int64;
    FNeedClose: Boolean;

    procedure DoSleep(ADataSize: Integer);
    function DoRecv(s: TSocket; var Buf; len, flags: Integer): Integer;
    function DoSend(s: TSocket; var Buf; len, flags: Integer): Integer;
    function DoRecvFrom(s: TSocket; var Buf; len, flags: Integer; from: PSockAddrGen; var fromlen: Integer): Integer;
    function DoSendTo(s: TSocket; var Buf; len, flags: Integer; addrto: PSockAddrGen; tolen: Integer): Integer;
    function GetConnection: TclConnection;
    function NeedStop: Boolean;
    procedure FillLocalInfo;
    procedure FillPeerInfo(Addr: TclIPAddress);
  protected
    function GetBatchSize: Integer; virtual;

    property NeedClose: Boolean read FNeedClose write FNeedClose;
  public
    constructor Create;
    destructor Destroy; override;

    class procedure CreateEndPoint(Addr: TclIPAddress; APort: Integer);

    procedure SetConnection(AConnection: TclConnection); virtual;
    procedure Assign(ASource: TclNetworkStream); virtual;
    function Connect(Addr_: TclIPAddress; APort: Integer): Boolean; virtual;
    procedure ConnectEnd; virtual;
    procedure SetPeerInfo(const AIP: string; APort: Integer);
    procedure Bind(Addr_: TclIPAddress; APort: Integer); overload; virtual;
    procedure Bind(Addr_: TclIPAddress; APortBegin, APortEnd: Integer); overload; virtual;
    procedure Broadcast; virtual;
    procedure Listen; virtual;
    procedure Accept; virtual;
    procedure AcceptEnd; virtual;
    procedure Close(ANotifyPeer: Boolean); virtual;
    procedure StreamReady; virtual;
    function Read(AData: TStream): Boolean; virtual;
    function Write(AData: TStream): Boolean; virtual;
    function ReadFrom(AData: TStream; Addr: TclIPAddress; var APort: Integer): Boolean; virtual;
    function WriteTo(AData: TStream; Addr: TclIPAddress; APort: Integer): Boolean; virtual;
    function ReadBuf(var ABuffer; ALength: Integer): Integer; virtual;
    function WriteBuf(var ABuffer; ALength: Integer): Integer; virtual;

    function GetReadBatchSize: Integer; virtual;
    function GetWriteBatchSize: Integer; virtual;

    function IsProceedLimit: Boolean; virtual;
    procedure InitProgress; virtual;
    procedure UpdateProgress(ABytesProceed: Int64); virtual;
    procedure InitClientSession; virtual;
    procedure InitServerSession; virtual;
    procedure ClearNextAction;
    procedure SetNextAction(Action: TclNetworkStreamAction);

    property Connection: TclConnection read GetConnection;
    property NextAction: TclNetworkStreamAction read FNextAction;
    property HasReadData: Boolean read FHasReadData write FHasReadData;
    property PeerIP: string read FPeerIP;
    property PeerPort: Integer read FPeerPort;
    property IP: string read FIP;
    property Port: Integer read FPort;
    property BytesProceed: Int64 read FBytesProceed;
  end;

  TclSocket = class
  private
    FAddressFamily: Integer;
    FSocket: TSocket;
  public
    constructor Create;

    procedure Close; virtual;
    procedure SetSocket(ASocket: TSocket; AddressFamily: Integer); virtual;

    property Socket: TSocket read FSocket;
    property AddressFamily: Integer read FAddressFamily;
  end;

  TclConnection = class
  private
    FSocket: TclSocket;
    FBatchSize: Integer;
    FBitsPerSec: Integer;
    FIsAborted: Boolean;
    FNetworkStream: TclNetworkStream;
    FActive_: Boolean;
    FTotalBytesProceed: Int64;
    FTotalBytes: Int64;
    FBytesToProceed: Int64;
    FOnProgress: TclProgressEvent;
    FOnReady: TNotifyEvent;
    FIP: string;
    FPort: Integer;
    FPeerIP: string;
    FPeerPort: Integer;

    function GetNetworkStream: TclNetworkStream;
    procedure SetNetworkStream(const Value: TclNetworkStream);
    procedure UpdateProgress(ABytesProceed: Int64);
  protected
    procedure DoDestroy; virtual;
    procedure DoProgress(ABytesProceed, ATotalBytes: Int64); virtual;
    procedure DoReady; virtual;
    procedure SetActive(Value: Boolean);
    procedure SetAborted(Value: Boolean);
  public
    constructor Create;
    destructor Destroy; override;

    procedure CreateSocket(AddrFamily, AStruct, AProtocol: Integer);
    procedure InitProgress(ABytesProceed, ATotalBytes: Int64);
    procedure Close(ANotifyPeer: Boolean); virtual;
    procedure CloseEnd;
    procedure CloseSession(ANotifyPeer: Boolean);
    function ReadData(AData: TStream): Boolean; virtual; abstract;
    function WriteData(AData: TStream): Boolean; virtual; abstract;
    function ReadBuf(var ABuffer; ALength: Integer): Integer;
    function WriteBuf(var ABuffer; ALength: Integer): Integer;
    procedure DispatchNextAction; virtual;
    procedure Abort; virtual;
    
    property NetworkStream: TclNetworkStream read GetNetworkStream write SetNetworkStream;
    property IsAborted: Boolean read FIsAborted;
    property Active: Boolean read FActive_;
    property Socket: TclSocket read FSocket;
    property BatchSize: Integer read FBatchSize write FBatchSize;
    property BitsPerSec: Integer read FBitsPerSec write FBitsPerSec;
    property BytesProceed: Int64 read FTotalBytesProceed;
    property BytesToProceed: Int64 read FBytesToProceed write FBytesToProceed;
    property IP: string read FIP;
    property Port: Integer read FPort;
    property PeerIP: string read FPeerIP;
    property PeerPort: Integer read FPeerPort;

    property OnProgress: TclProgressEvent read FOnProgress write FOnProgress;
    property OnReady: TNotifyEvent read FOnReady write FOnReady;
  end;

  TclSyncConnection = class(TclConnection)
  private
    FTimeOut: Integer;
    FSocketEvent: THandle;
    FAbortEvent: THandle;
    FTimeOutTicks: Integer;
    FLocalBinding: string;

    procedure InitTimeOutTicks;
  protected
    procedure SelectSocketEvent(lNetworkEvents: DWORD);
    procedure DoDestroy; override;
  public
    constructor Create;
    procedure Abort; override;

    procedure WriteString(const AString: string); overload;
    procedure WriteString(const AString, ACharSet: string); overload;
    function ReadString: string; overload;
    function ReadString(const ACharSet: string): string; overload;
    procedure WriteBytes(const AData: TclByteArray);
    function ReadBytes: TclByteArray;
    property TimeOut: Integer read FTimeOut write FTimeOut;
    property SocketEvent: THandle read FSocketEvent;
    property LocalBinding: string read FLocalBinding write FLocalBinding;
  end;

  TclTcpConnection = class(TclSyncConnection)
  private
    FIsReadUntilClose: Boolean;
    
    procedure InternalReadData(AData: TStream);
    procedure InternalWriteData(AData: TStream);
  public
    procedure DispatchNextAction; override;
    function ReadData(AData: TStream): Boolean; override;
    function WriteData(AData: TStream): Boolean; override;
    property IsReadUntilClose: Boolean read FIsReadUntilClose write FIsReadUntilClose;
  end;

  TclUdpConnection = class(TclSyncConnection)
  public
    function ReadData(AData: TStream): Boolean; override;
    function WriteData(AData: TStream): Boolean; override;
    procedure Broadcast;
  end;

  TclTcpClientConnection = class(TclTcpConnection)
  public
    procedure Open(const AIP: string; APort: Integer);
    procedure OpenSession;
  end;

  TclTcpListenConnection = class;

  TclTcpServerConnection = class(TclTcpConnection)
  public
    function Listen(APort: Integer): Integer; overload;
    function Listen(APortBegin, APortEnd: Integer): Integer; overload;
    procedure Accept; overload;
    procedure Accept(AListenConnection: TclTcpListenConnection); overload;
    procedure OpenSession;
  end;

  TclTcpListenConnection = class(TclSyncConnection)
  public
    function Listen(APort: Integer): Integer; overload;
    function Listen(APortBegin, APortEnd: Integer): Integer; overload;
    procedure Accept(AUserConnection: TclTcpServerConnection);
    function ReadData(AData: TStream): Boolean; override;
    function WriteData(AData: TStream): Boolean; override;
  end;

  TclUdpClientConnection = class(TclUdpConnection)
  public
    procedure Open(const AIP: string; APort: Integer);
  end;

  TclUdpServerConnection = class(TclUdpConnection)
  public
    procedure Listen(APort: Integer);
  end;

  TclHostResolver = class
  public
    class function GetIPAddress(const AHostName: string): string;
    class procedure GetIPAddressList(const AHostName: string; AList: TStrings);
    class function GetLocalHost: string;

    function ResolveIP(const AHostName: string): string; virtual; abstract;
    procedure ResolveIPList(const AHostName: string; AList: TStrings); virtual; abstract;
  end;

  TclHostResolver4 = class(TclHostResolver)
  private
    FAsyncError: Integer;
    FLookupHandle: THandle;
    FCompleted: THandle;
    FIsAborted: Boolean;

    function GetHostEntry(const AHostName: string; ATimeOut: Integer): PHostEnt;
    function GetHostIP(const AHostName: string; ATimeOut: Integer): string;
    procedure WndProc(var Message: TMessage);
    procedure DestroyWindowHandle(AWndHandle: HWND);
  public
    function ResolveIP(const AHostName: string): string; override;
    procedure ResolveIPList(const AHostName: string; AList: TStrings); override;
    procedure Abort;
  end;

  TclHostResolver6 = class(TclHostResolver)
  private
    function GetHostIP(const AHostName: string): string;
  public
    function ResolveIP(const AHostName: string): string; override;
    procedure ResolveIPList(const AHostName: string; AList: TStrings); override;
  end;

function WaitForEvent(AEvent, AbortEvent: THandle; ATimeOutTicks, ATimeOut: Integer): Boolean;
procedure StartupSocket;
procedure CleanupSocket;

implementation

uses
  clTranslator, clWUtils{$IFDEF LOGGER}, clLogger{$ENDIF};

procedure StartupSocket;
var
  wsaData: TWSAData;
  res: Integer;
begin
  res := WSAStartup($202, wsaData);
  if (res <> 0) then
  begin
    RaiseSocketError(WSAGetLastError());
  end;
end;

procedure CleanupSocket;
begin
  WSACleanup();
end;

function WaitForEvent(AEvent, AbortEvent: THandle; ATimeOutTicks, ATimeOut: Integer): Boolean;
var
  res, eventCount: DWORD;
  Msg: TMsg;
  events: array[0..1] of THandle;
begin
  events[0] := AEvent;
  events[1] := AbortEvent;

  eventCount := 1;
  if (AbortEvent <> 0) then
  begin
    Inc(eventCount);
  end;

  res := MsgWaitForMultipleObjects(eventCount, events, FALSE, DWORD(ATimeOut), QS_ALLEVENTS);
  if (WAIT_FAILED = res) then
  begin
    RaiseSocketError(WSAGetLastError());
  end else
  if (WAIT_TIMEOUT = res) then
  begin
    RaiseSocketError(TimeoutOccurred, TimeoutOccurredCode);
  end else
  if ((WAIT_OBJECT_0 + eventCount) = res) then
  begin
    while PeekMessage(Msg, 0, 0, 0, PM_REMOVE) do
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
      if (ATimeOut <> -1) and (Integer(GetTickCount()) - ATimeOutTicks > ATimeOut) then
      begin
        RaiseSocketError(TimeoutOccurred, TimeoutOccurredCode);
      end;
    end;
    if (ATimeOut <> -1) and (Integer(GetTickCount()) - ATimeOutTicks > ATimeOut) then
    begin
      RaiseSocketError(TimeoutOccurred, TimeoutOccurredCode);
    end;
  end;
  Result := (res = WAIT_OBJECT_0);
end;

{ TclConnection }

constructor TclConnection.Create;
begin
  inherited Create();

  FSocket := TclSocket.Create();
  FBatchSize := 8192;
  FBytesToProceed := -1;
end;

destructor TclConnection.Destroy;
begin
  try
    Close(False);
    CloseEnd();
  except
    on EclSocketError do ;
  end;
  DoDestroy();
  inherited Destroy();
end;

procedure TclConnection.UpdateProgress(ABytesProceed: Int64);
begin
  FTotalBytesProceed := FTotalBytesProceed + ABytesProceed;
  DoProgress(FTotalBytesProceed, FTotalBytes);
end;

function TclConnection.WriteBuf(var ABuffer; ALength: Integer): Integer;
begin
  Result := NetworkStream.WriteBuf(ABuffer, ALength);
end;

procedure TclConnection.Close(ANotifyPeer: Boolean);
var
  action: TclNetworkStreamAction;
begin
  action := saNone;
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, Format('(%d) Close', [Integer(Socket)]));{$ENDIF}
  try
    CloseSession(ANotifyPeer);

    if Active then
    begin
      action := NetworkStream.NextAction;
    end;
  finally
    if (not ANotifyPeer) or (action = saNone) then
    begin
      CloseEnd();
    end;
  end;
end;

procedure TclConnection.CloseEnd;
begin
  SetActive(False);
  FSocket.Close();
end;

procedure TclConnection.Abort;
begin
  SetAborted(True);
end;

procedure TclConnection.DoDestroy;
begin
  FSocket.Free();
  NetworkStream := nil;
end;

procedure TclConnection.DoProgress(ABytesProceed, ATotalBytes: Int64);
begin
  if Assigned(OnProgress) then
  begin
    OnProgress(Self, ABytesProceed, ATotalBytes);
  end;
end;

function TclConnection.ReadBuf(var ABuffer; ALength: Integer): Integer;
begin
  Result := NetworkStream.ReadBuf(ABuffer, ALength);
end;

procedure TclConnection.SetActive(Value: Boolean);
begin
  FActive_ := Value;
end;

procedure TclConnection.SetAborted(Value: Boolean);
begin
  FIsAborted := Value;
end;

procedure TclConnection.SetNetworkStream(const Value: TclNetworkStream);
begin
  if (FNetworkStream = Value) then Exit;

  if (FNetworkStream <> nil) and (Value <> nil) then
  begin
    Value.Assign(FNetworkStream);
  end;
  
  FNetworkStream.Free();
  FNetworkStream := Value;

  if (FNetworkStream <> nil) then
  begin
    FNetworkStream.SetConnection(Self);
  end;
end;

function TclConnection.GetNetworkStream: TclNetworkStream;
begin
  if (FNetworkStream = nil) then
  begin
    raise EclSocketError.Create(InvalidNetworkStream, InvalidNetworkStreamCode);
  end;
  Result := FNetworkStream;
end;

procedure TclConnection.DoReady;
begin
  if Assigned(OnReady) then
  begin
    OnReady(Self);
  end;
end;

procedure TclConnection.InitProgress(ABytesProceed, ATotalBytes: Int64);
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InitProgress, ABytesProceed=%d, ATotalBytes=%d', nil, [ABytesProceed, ATotalBytes]);{$ENDIF}
  FTotalBytesProceed := ABytesProceed;
  NetworkStream.InitProgress();
  FTotalBytes := ATotalBytes;
end;

procedure TclConnection.CreateSocket(AddrFamily, AStruct, AProtocol: Integer);
begin
  SetAborted(False);
  Assert(FSocket.Socket = INVALID_SOCKET);
  FSocket.SetSocket({$IFDEF DELPHIXE2}Winapi.{$ENDIF}WinSock.socket(AddrFamily, AStruct, AProtocol), AddrFamily);
  if (FSocket.Socket = INVALID_SOCKET) then
  begin
    RaiseSocketError(WSAGetLastError());
  end;
end;

procedure TclConnection.CloseSession(ANotifyPeer: Boolean);
begin
  if Active then
  begin
    NetworkStream.Close(ANotifyPeer);
    if ANotifyPeer then
    begin
      DispatchNextAction();
    end;
  end;
end;

procedure TclConnection.DispatchNextAction;
begin
end;

{ TclTcpClientConnection }

procedure TclTcpClientConnection.Open(const AIP: string; APort: Integer);
var
  res: Integer;
  networkEvents: TWSANetworkEvents;
  isReadIntilCloseOld: Boolean;
  addr, bindAddr: TclIPAddress;
begin
  addr := nil;
  bindAddr := nil;
  try
    addr := TclIPAddress.CreateIpAddress(AIP);

    isReadIntilCloseOld := IsReadUntilClose;
    IsReadUntilClose := False;

    CreateSocket(addr.AddressFamily, SOCK_STREAM, IPPROTO_TCP);
    SelectSocketEvent(FD_CONNECT);

    if (Trim(LocalBinding) <> '') then
    begin
      bindAddr := TclIPAddress.CreateBindingIpAddress(LocalBinding, addr.AddressFamily);
      NetworkStream.Bind(bindAddr, 0);
    end;

    if not NetworkStream.Connect(addr, APort) then
    begin
      InitTimeOutTicks();

      repeat
        if WaitForEvent(SocketEvent, FAbortEvent, FTimeOutTicks, TimeOut) then
        begin
          res := WSAEnumNetworkEvents(Socket.Socket, SocketEvent, @networkEvents);
          if (res = SOCKET_ERROR) then
          begin
            RaiseSocketError(WSAGetLastError());
          end;
          if ((networkEvents.lNetworkEvents and FD_CONNECT) > 0) then
          begin
            if (networkEvents.iErrorCode[FD_CONNECT_BIT] <> 0) then
            begin
              RaiseSocketError(networkEvents.iErrorCode[FD_CONNECT_BIT]);
            end;
            Break;
          end;
        end;
      until IsAborted;
    end;

    SelectSocketEvent(FD_READ or FD_CLOSE or FD_WRITE);

    if IsAborted then
    begin
      Close(False);
    end else
    begin
      SetActive(True);
      DispatchNextAction();
      if not Active then
      begin
        RaiseSocketError(ConnectionClosed, ConnectionClosedCode);
      end;
      NetworkStream.ConnectEnd();
      NetworkStream.StreamReady();
    end;

    IsReadUntilClose := isReadIntilCloseOld;
  finally
    bindAddr.Free();
    addr.Free();
  end;
end;

procedure TclTcpClientConnection.OpenSession;
var
  isReadIntilCloseOld: Boolean;
begin
  if not Active then
  begin
    RaiseSocketError(ConnectionClosed, ConnectionClosedCode);
  end;

  isReadIntilCloseOld := IsReadUntilClose;
  IsReadUntilClose := False;

  NetworkStream.InitClientSession();

  if IsAborted then
  begin
    Close(False);
  end else
  begin
    DispatchNextAction();
    NetworkStream.StreamReady();
  end;
  
  IsReadUntilClose := isReadIntilCloseOld;
end;

{ TclTcpServerConnection }

function TclTcpServerConnection.Listen(APort: Integer): Integer;
var
  bindAddr: TclIpAddress;
begin
  bindAddr := TclIPAddress.CreateBindingIpAddress(LocalBinding);
  try
    CreateSocket(bindAddr.AddressFamily, SOCK_STREAM, IPPROTO_TCP);

    NetworkStream.Bind(bindAddr, APort);
    NetworkStream.Listen();
    Result := NetworkStream.Port;
  finally
    bindAddr.Free();
  end;
end;

procedure TclTcpServerConnection.Accept;
var
  sock: TSocket;
  res: Integer;
  networkEvents: TWSANetworkEvents;
  isReadIntilCloseOld: Boolean;
begin
  isReadIntilCloseOld := IsReadUntilClose;
  try
    IsReadUntilClose := False;

    SelectSocketEvent(FD_ACCEPT);

    InitTimeOutTicks();

    repeat
      if WaitForEvent(SocketEvent, FAbortEvent, FTimeOutTicks, TimeOut) then
      begin
        res := WSAEnumNetworkEvents(Socket.Socket, SocketEvent, @networkEvents);
        if (res = SOCKET_ERROR) then
        begin
          RaiseSocketError(WSAGetLastError());
        end;
        if ((networkEvents.lNetworkEvents and FD_ACCEPT) > 0) then
        begin
          if (networkEvents.iErrorCode[FD_ACCEPT_BIT] <> 0) then
          begin
            RaiseSocketError(networkEvents.iErrorCode[FD_ACCEPT_BIT]);
          end;
          Break;
        end;
      end;
    until IsAborted;

    if IsAborted then
    begin
      Close(False);
    end else
    begin
      sock := Socket.Socket;
      NetworkStream.Accept();
      {$IFDEF DELPHIXE2}Winapi.{$ENDIF}WinSock.closesocket(sock);

      SelectSocketEvent(FD_READ or FD_CLOSE or FD_WRITE);

      SetActive(True);
      DispatchNextAction();
      if not Active then
      begin
        RaiseSocketError(ConnectionClosed, ConnectionClosedCode);
      end;
      NetworkStream.AcceptEnd();
      NetworkStream.StreamReady();
    end;
  finally
    IsReadUntilClose := isReadIntilCloseOld;
  end;
end;

procedure TclTcpServerConnection.Accept(AListenConnection: TclTcpListenConnection);
var
  isReadIntilCloseOld: Boolean;
begin
  isReadIntilCloseOld := IsReadUntilClose;
  try
    IsReadUntilClose := False;
    SetAborted(False);

    Socket.Close();
    Socket.SetSocket(AListenConnection.Socket.Socket, AListenConnection.Socket.AddressFamily);
    NetworkStream.Accept();
    SelectSocketEvent(FD_READ or FD_CLOSE or FD_WRITE);

    SetActive(True);

    DispatchNextAction();

    if not Active then
    begin
      RaiseSocketError(ConnectionClosed, ConnectionClosedCode);
    end;

    NetworkStream.AcceptEnd();
    NetworkStream.StreamReady();
  finally
    IsReadUntilClose := isReadIntilCloseOld;
  end;
end;

function TclTcpServerConnection.Listen(APortBegin, APortEnd: Integer): Integer;
var
  bindAddr: TclIpAddress;
begin
  bindAddr := TclIPAddress.CreateBindingIpAddress(LocalBinding);
  try
    CreateSocket(bindAddr.AddressFamily, SOCK_STREAM, IPPROTO_TCP);
    NetworkStream.Bind(bindAddr, APortBegin, APortEnd);
    NetworkStream.Listen();
    Result := NetworkStream.Port;
  finally
    bindAddr.Free();
  end;
end;

procedure TclTcpServerConnection.OpenSession;
var
  isReadIntilCloseOld: Boolean;
begin
  Assert(Active);
  
  isReadIntilCloseOld := IsReadUntilClose;
  IsReadUntilClose := False;

  NetworkStream.InitServerSession();

  if IsAborted then
  begin
    Close(False);
  end else
  begin
    DispatchNextAction();
    NetworkStream.StreamReady();
  end;
  
  IsReadUntilClose := isReadIntilCloseOld;
end;

{ TclSyncConnection }

constructor TclSyncConnection.Create;
begin
  inherited Create();
  FAbortEvent := CreateEvent(nil, False, False, nil);
  FSocketEvent := WSACreateEvent();
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'FSocketEvent created');{$ENDIF}
  if (FSocketEvent = WSA_INVALID_EVENT) then
  begin
    RaiseSocketError(WSAGetLastError());
  end;
  TimeOut := 5000;
end;

procedure TclSyncConnection.DoDestroy;
begin
  if (FSocketEvent <> WSA_INVALID_EVENT) then
  begin
    WSACloseEvent(FSocketEvent);
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'FSocketEvent closed');{$ENDIF}
  end;
  CloseHandle(FAbortEvent);
  inherited DoDestroy();
end;

procedure TclSyncConnection.InitTimeOutTicks;
begin
  FTimeOutTicks := Integer(GetTickCount());
end;

procedure TclSyncConnection.WriteString(const AString: string);
begin
  WriteString(AString, '');
end;

procedure TclSyncConnection.SelectSocketEvent(lNetworkEvents: DWORD);
var
  res: Integer;
begin
  res := WSAEventSelect(Socket.Socket, SocketEvent, lNetworkEvents);
  if (res = SOCKET_ERROR) then
  begin
    RaiseSocketError(WSAGetLastError());
  end;
end;

procedure TclSyncConnection.WriteBytes(const AData: TclByteArray);
var
  data: TStream;
begin
  data := TMemoryStream.Create();
  try
    if (Length(AData) > 0) then
    begin
      data.Write(AData[0], Length(AData));
    end;
    data.Position := 0;
    WriteData(data);
    Assert(data.Position >= (data.Size - 1));
  finally
    data.Free();
  end;
end;

procedure TclSyncConnection.WriteString(const AString, ACharSet: string);
var
  data: TStream;
  buffer: TclByteArray;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  data := TMemoryStream.Create();
  try
    if (AString <> '') then
    begin
      buffer := TclTranslator.GetBytes(AString, ACharSet);
      data.WriteBuffer(buffer[0], Length(buffer));
      data.Position := 0;
    end;
    WriteData(data);
    Assert(data.Position >= (data.Size - 1));
  finally
    data.Free();
  end;
end;

function TclSyncConnection.ReadBytes: TclByteArray;
var
  data: TStream;
begin
  data := TMemoryStream.Create();
  try
    InitProgress(0, 0);
    ReadData(data);

    SetLength(Result, data.Size);
    if (data.Size > 0) then
    begin
      data.Position := 0;
      data.Read(Result[0], data.Size);
    end;
  finally
    data.Free();
  end;
end;

function TclSyncConnection.ReadString(const ACharSet: string): string;
var
  data: TStream;
  size: Integer;
  buffer: TclByteArray;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  data := TMemoryStream.Create();
  try
    InitProgress(0, 0);
    ReadData(data);
    data.Position := 0;

    size := data.Size - data.Position;

    if (size > 0) then
    begin
      SetLength(buffer, size);
      data.Read(buffer[0], size);
      Result := TclTranslator.GetString(buffer, 0, size, ACharSet);
    end else
    begin
      Result := '';
    end;
  finally
    data.Free();
  end;
end;

function TclSyncConnection.ReadString: string;
begin
  Result := ReadString('');
end;

procedure TclSyncConnection.Abort;
begin
  inherited Abort();
  SetEvent(FAbortEvent);
end;

{ TclUdpClientConnection }

procedure TclUdpClientConnection.Open(const AIP: string; APort: Integer);
var
  addr, bindAddr: TclIPAddress;
begin
  addr := nil;
  bindAddr := nil;
  try
    addr := TclIPAddress.CreateIpAddress(AIP);
    CreateSocket(addr.AddressFamily, SOCK_DGRAM, IPPROTO_UDP);

    if (Trim(LocalBinding) <> '') then
    begin
      bindAddr := TclIPAddress.CreateBindingIpAddress(LocalBinding, addr.AddressFamily);
      NetworkStream.Bind(bindAddr, 0);
    end;
    NetworkStream.SetPeerInfo(AIP, APort);

    SelectSocketEvent(FD_READ or FD_WRITE);
    SetActive(True);

    NetworkStream.StreamReady();
  finally
    bindAddr.Free();
    addr.Free();
  end;
end;

{ TclNetworkStream }

procedure TclNetworkStream.FillLocalInfo;
var
  addr: TclIPAddress;
  res, len: Integer;
begin
  if (not Connection.Active) then Exit;
  
  addr := TclIPAddress.CreateNone(Connection.Socket.AddressFamily);
  try
    len := addr.AddressLength;
    res := getsockname_gen(Connection.Socket.Socket, addr.Address, len);
    if (res = SOCKET_ERROR) then
    begin
      RaiseSocketError(WSAGetLastError());
    end;

    FIP := addr.ToString();
    FPort := addr.Port;
    Connection.FIP := FIP;
    Connection.FPort := FPort;
  finally
    addr.Free();
  end;
end;

procedure TclNetworkStream.FillPeerInfo(Addr: TclIPAddress);
begin
  SetPeerInfo(Addr.ToString(), Addr.Port);
end;

procedure TclNetworkStream.Accept;
var
  client_addr: TclIPAddress;
  len: Integer;
begin
  NeedClose := False;
  ClearNextAction();
  InitServerSession();

  client_addr := TclIPAddress.CreateNone(Connection.Socket.AddressFamily);
  try
    len := client_addr.AddressLength;
    Connection.Socket.SetSocket(accept_gen(Connection.Socket.Socket, client_addr.Address, len), Connection.Socket.AddressFamily);
    if (Connection.Socket.Socket = INVALID_SOCKET) then
    begin
      RaiseSocketError(WSAGetLastError());
    end;

    FillPeerInfo(client_addr);
  finally
    client_addr.Free();
  end;
end;

procedure TclNetworkStream.Close(ANotifyPeer: Boolean);
begin
  ClearNextAction();
end;

constructor TclNetworkStream.Create;
begin
  inherited Create();
  FSleepEvent := CreateEvent(nil, False, False, nil);
end;

destructor TclNetworkStream.Destroy;
begin
  if (FSleepEvent <> INVALID_HANDLE_VALUE) then
  begin
    CloseHandle(FSleepEvent);
    FSleepEvent := INVALID_HANDLE_VALUE;
  end;
  inherited Destroy();
end;

function TclNetworkStream.DoRecv(s: TSocket; var Buf; len, flags: Integer): Integer;
begin
  Result := {$IFDEF DELPHIXE2}Winapi.{$ENDIF}WinSock.recv(s, Buf, len, flags);
  DoSleep(len);
end;

function TclNetworkStream.DoRecvFrom(s: TSocket; var Buf; len, flags: Integer; from: PSockAddrGen;
  var fromlen: Integer): Integer;
begin
  Result := recvfrom_gen(s, Buf, len, flags, from, fromlen);
  DoSleep(len);
end;

function TclNetworkStream.DoSend(s: TSocket; var Buf; len, flags: Integer): Integer;
begin
  Result := {$IFDEF DELPHIXE2}Winapi.{$ENDIF}WinSock.send(s, Buf, len, flags);
  DoSleep(len);
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'DoSend');{$ENDIF}
end;

function TclNetworkStream.DoSendTo(s: TSocket; var Buf; len, flags: Integer; addrto: PSockAddrGen; tolen: Integer): Integer;
begin
  Result := sendto_gen(s, Buf, len, flags, addrto, tolen);
  DoSleep(len);
end;

procedure TclNetworkStream.DoSleep(ADataSize: Integer);
var
  Msg: TMsg;
  res: DWORD;
  events: array[0..0] of THandle;
  sleepTicks: DWORD;
  err, milliseconds: Integer;
begin
  if Connection.BitsPerSec <= 0 then Exit;

  milliseconds := (ADataSize * 8 * 1000) div Connection.BitsPerSec;

  err := WSAGetLastError();
  try
    events[0] := FSleepEvent;
    sleepTicks := GetTickCount();
    repeat
      res := MsgWaitForMultipleObjects(1, events, FALSE, DWORD(milliseconds), QS_ALLEVENTS);
      case res of
        WAIT_TIMEOUT,
        WAIT_OBJECT_0:
          begin
            Break;
          end;
        WAIT_OBJECT_0 + 1:
          begin
            while PeekMessage(Msg, 0, 0, 0, PM_REMOVE) do
            begin
              TranslateMessage(Msg);
              DispatchMessage(Msg);
              if Integer(GetTickCount() - sleepTicks) > milliseconds then
              begin
                Break;
              end;
            end;
            if Integer(GetTickCount() - sleepTicks) > milliseconds then
            begin
              Break;
            end;
          end;
      end;
    until False;
  finally
    SetLastError(err);
  end;
end;

function TclNetworkStream.GetConnection: TclConnection;
begin
  Assert(FConnection <> nil);
  Result := FConnection;
end;

function TclNetworkStream.GetReadBatchSize: Integer;
begin
  Result := GetBatchSize();
end;

function TclNetworkStream.GetWriteBatchSize: Integer;
begin
  Result := GetBatchSize();
end;

function TclNetworkStream.IsProceedLimit: Boolean;
begin
  Result := (Connection.BytesToProceed > -1) and (Connection.BytesToProceed <= BytesProceed);
end;

function TclNetworkStream.GetBatchSize: Integer;
begin
  if (Connection.BatchSize < 1) then
  begin
    RaiseSocketError(InvalidBatchSize, InvalidBatchSizeCode);
  end;

  Result := Connection.BatchSize;
  if (Connection.BytesToProceed > -1)
    and (Connection.BytesToProceed >= BytesProceed) and ((Connection.BytesToProceed - BytesProceed) < Result) then
  begin
    Result := (Connection.BytesToProceed - BytesProceed);
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'GetBatchSize, Connection.BatchSize=%d, Connection.BytesToProceed=%d, BytesProceed=%d, Connection.FTotalBytesProceed=%d', nil, [Connection.BatchSize, Connection.BytesToProceed, BytesProceed, Connection.FTotalBytesProceed]);{$ENDIF}
end;

class procedure TclNetworkStream.CreateEndPoint(Addr: TclIPAddress; APort: Integer);
begin
  Addr.SetPort(APort);
end;

procedure TclNetworkStream.Bind(Addr_: TclIPAddress; APort: Integer);
var
  res: Integer;
begin
  CreateEndPoint(Addr_, APort);

  res := bind_gen(Connection.Socket.Socket, Addr_.Address, Addr_.AddressLength);
  if (res = SOCKET_ERROR) then
  begin
    RaiseSocketError(WSAGetLastError());
  end;
end;

procedure TclNetworkStream.Bind(Addr_: TclIPAddress; APortBegin, APortEnd: Integer);
var
  i: Integer;
  res: Integer;
begin
  if ((APortBegin <= 0) or (APortBegin > APortEnd)) then
  begin
    raise EclSocketError.Create(InvalidPort, InvalidPortCode);
  end;

  for i := APortBegin to APortEnd do
  begin
    CreateEndPoint(Addr_, i);

    res := bind_gen(Connection.Socket.Socket, Addr_.Address, Addr_.AddressLength);
    if (res = 0) then Break;

    res := WSAGetLastError();
    if ((res <> 10048) and (res <> 10013)) or (i = APortEnd) then
    begin
      RaiseSocketError(WSAGetLastError());
    end;
  end;
end;

procedure TclNetworkStream.Broadcast;
var
  res: Integer;
  optVal: Integer;
begin
  if (AF_INET6 = Connection.Socket.AddressFamily) then
  begin
    RaiseSocketError(InvalidAddressFamily, InvalidAddressFamilyCode);
  end;
  
  optVal := 1;

  res := {$IFDEF DELPHIXE2}Winapi.{$ENDIF}WinSock.setsockopt(Connection.Socket.Socket, SOL_SOCKET, SO_BROADCAST, PclChar(@optVal), SizeOf(optVal));
  if (res = SOCKET_ERROR) then
  begin
    RaiseSocketError(WSAGetLastError());
  end;
end;

procedure TclNetworkStream.Listen;
var
  addr: TclIPAddress;
  res, useNonblock, saLen: Integer;
begin
  NeedClose := False;
  ClearNextAction();

  useNonblock := 1;
  {$IFDEF DELPHIXE2}Winapi.{$ENDIF}WinSock.ioctlsocket(Connection.Socket.Socket, FIONBIO, useNonblock);

  res := {$IFDEF DELPHIXE2}Winapi.{$ENDIF}WinSock.listen(Connection.Socket.Socket, 1);
  if (res = SOCKET_ERROR) then
  begin
    RaiseSocketError(WSAGetLastError());
  end;

  addr := TclIPAddress.CreateNone(Connection.Socket.AddressFamily);
  try
    saLen := addr.AddressLength;
    res := getsockname_gen(Connection.Socket.Socket, addr.Address, saLen);
    if (res = SOCKET_ERROR) then
    begin
      RaiseSocketError(WSAGetLastError());
    end;

    FPort := addr.Port;
  finally
    addr.Free();
  end;
end;

function TclNetworkStream.NeedStop: Boolean;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edEnter, 'NeedStop');{$ENDIF}
  Result := Connection.IsAborted or IsProceedLimit();
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'NeedStop, Result=%d', nil, [Integer(Result)]);{$ENDIF}
end;

function TclNetworkStream.Connect(Addr_: TclIPAddress; APort: Integer): Boolean;
var
  res: Integer;
begin
  NeedClose := False;
  ClearNextAction();
  InitClientSession();

  CreateEndPoint(Addr_, APort);

  res := connect_gen(Connection.Socket.Socket, Addr_.Address, Addr_.AddressLength);

  Result := (res <> SOCKET_ERROR);
  if not Result and (WSAGetLastError() <> WSAEWOULDBLOCK) then
  begin
    RaiseSocketError(WSAGetLastError());
  end;

  FillPeerInfo(Addr_);
end;

procedure TclNetworkStream.ConnectEnd;
begin
  FillLocalInfo();
end;

function TclNetworkStream.Read(AData: TStream): Boolean;
var
  bytesRead, toRead, cnt: Integer;
  buf: PclChar;
begin
  ClearNextAction();
  Result := True;

  if (AData = nil) then Exit;

  toRead := 0;
  buf := nil;
  try
    repeat
      cnt := GetReadBatchSize();
      if (cnt > toRead) then
      begin
        if (cnt <= 0) then Exit;

        toRead := cnt;
        FreeMem(buf);
        GetMem(buf, toRead);
        if (buf = nil) then
        begin
          RaiseSocketError(clGetLastError());
        end;
      end;
      bytesRead := DoRecv(Connection.Socket.Socket, buf^, cnt, 0);
      Result := (bytesRead <> SOCKET_ERROR);
      if not Result and (WSAGetLastError() <> WSAEWOULDBLOCK) then
      begin
        RaiseSocketError(WSAGetLastError());
      end;
      
      if Result and (bytesRead > 0) then
      begin
        AData.Write(buf^, bytesRead);
        UpdateProgress(bytesRead);
      end;

      if (bytesRead = 0) then
      begin
        NeedClose := True;
      end;
    until (not Result) or (not (bytesRead > 0)) or NeedStop();

  finally
    FreeMem(buf);
  end;
end;

function TclNetworkStream.ReadBuf(var ABuffer; ALength: Integer): Integer;
begin
  Result := DoRecv(Connection.Socket.Socket, ABuffer, ALength, 0);
end;

function TclNetworkStream.ReadFrom(AData: TStream; Addr: TclIPAddress; var APort: Integer): Boolean;
var
  bytesRead, toRead: Integer;
  buf: PclChar;
  len: Integer;
begin
  ClearNextAction();
  Result := True;

  if (AData = nil) then Exit;

  toRead := GetReadBatchSize();
  if (toRead <= 0) then Exit;

  GetMem(buf, toRead);
  if (buf = nil) then
  begin
    RaiseSocketError(clGetLastError());
  end;
  try
    len := Addr.AddressLength;
    bytesRead := DoRecvFrom(Connection.Socket.Socket, buf^, toRead, 0, Addr.Address, len);
    Result := (bytesRead <> SOCKET_ERROR);
    if not Result and (WSAGetLastError() <> WSAEWOULDBLOCK) then
    begin
      RaiseSocketError(WSAGetLastError());
    end;
      
    if Result and (bytesRead > 0) then
    begin
      AData.Write(buf^, bytesRead);
      UpdateProgress(bytesRead);
    end;

    FillLocalInfo();
    FillPeerInfo(Addr);

    APort := PeerPort;
  finally
    FreeMem(buf);
  end;
end;

procedure TclNetworkStream.UpdateProgress(ABytesProceed: Int64);
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'UpdateProgress, FBytesProceed=%d, ABytesProceed=%d', nil, [FBytesProceed, ABytesProceed]);{$ENDIF}
  FBytesProceed := FBytesProceed + ABytesProceed;
  Connection.UpdateProgress(ABytesProceed);
end;

function TclNetworkStream.Write(AData: TStream): Boolean;
var
  buf: PclChar;
  written, toWrite: Integer;
  total: Int64;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Write');{$ENDIF}
  ClearNextAction();
  Result := True;

  if (AData = nil) or (AData.Size - AData.Position = 0) then Exit;

  toWrite := GetWriteBatchSize();
  if (toWrite <= 0) then Exit;

  GetMem(buf, toWrite);
  if (buf = nil) then
  begin
    RaiseSocketError(clGetLastError());
  end;
  try
    total := AData.Position;
    repeat
      toWrite := GetWriteBatchSize();
      if (toWrite > (AData.Size - total)) then
      begin
        toWrite := (AData.Size - total);
      end;
      AData.Read(buf^, toWrite);

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, Format('(%d) Write', [Connection.Socket.Socket]));{$ENDIF}
      written := DoSend(Connection.Socket.Socket, buf^, toWrite, 0);
      Result := (written <> SOCKET_ERROR);
      if not Result and (WSAGetLastError() <> WSAEWOULDBLOCK) then
      begin
        RaiseSocketError(WSAGetLastError());
      end;

      if Result then
      begin
        total := total + written;
        if (written < toWrite) then
        begin
          AData.Position := AData.Position - toWrite + written;
        end;
        UpdateProgress(written);
      end else
      begin
        AData.Position := AData.Position - toWrite;
        total := AData.Size;
      end;
    until (not Result) or (not (total < AData.Size)) or NeedStop();
  finally
    FreeMem(buf);
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Write'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Write', E); raise; end; end;{$ENDIF}
end;

function TclNetworkStream.WriteBuf(var ABuffer; ALength: Integer): Integer;
begin
  Result := DoSend(Connection.Socket.Socket, ABuffer, ALength, 0);
end;

function TclNetworkStream.WriteTo(AData: TStream; Addr: TclIPAddress; APort: Integer): Boolean;
var
  buf: PclChar;
  written, toWrite, curPos: Integer;
begin
  ClearNextAction();
  Result := True;

  if (AData = nil) or (AData.Size - AData.Position = 0) then Exit;

  toWrite := GetWriteBatchSize();
  if (toWrite <= 0) then Exit;

  CreateEndPoint(Addr, APort);
  
  GetMem(buf, toWrite);
  if (buf = nil) then
  begin
    RaiseSocketError(clGetLastError());
  end;
  try
    curPos := AData.Position;
    toWrite := GetWriteBatchSize();
    if (toWrite > (AData.Size - curPos)) then
    begin
      toWrite := (AData.Size - curPos);
    end;
    AData.Read(buf^, toWrite);

    written := DoSendTo(Connection.Socket.Socket, buf^, toWrite, 0, Addr.Address, Addr.AddressLength);
    Result := (written <> SOCKET_ERROR);
    if not Result and (WSAGetLastError() <> WSAEWOULDBLOCK) then
    begin
      RaiseSocketError(WSAGetLastError());
    end;

    if Result then
    begin
      if (written < toWrite) then
      begin
        AData.Position := AData.Position - toWrite + written;
      end;
      UpdateProgress(written);
    end else
    begin
      AData.Position := AData.Position - toWrite;
    end;

    FillLocalInfo();
    FillPeerInfo(Addr);
  finally
    FreeMem(buf)
  end;
end;

procedure TclNetworkStream.ClearNextAction;
begin
  FNextAction := saNone;
end;

procedure TclNetworkStream.InitProgress;
begin
  FBytesProceed := 0;
end;

procedure TclNetworkStream.SetConnection(AConnection: TclConnection);
begin
  FConnection := AConnection;
end;

procedure TclNetworkStream.SetNextAction(Action: TclNetworkStreamAction);
begin
  if (FNextAction = saNone) then
  begin
    FNextAction := Action;
  end;
end;

procedure TclNetworkStream.SetPeerInfo(const AIP: string; APort: Integer);
begin
  FPeerIP := AIP;
  FPeerPort := APort;

  Connection.FPeerIP := FPeerIP;
  Connection.FPeerPort := FPeerPort;
end;

procedure TclNetworkStream.StreamReady;
begin
  Connection.DoReady();
end;

procedure TclNetworkStream.InitClientSession;
begin
end;

procedure TclNetworkStream.InitServerSession;
begin
end;

procedure TclNetworkStream.AcceptEnd;
begin
  FillLocalInfo();
end;

procedure TclNetworkStream.Assign(ASource: TclNetworkStream);
begin
  FPeerIP := ASource.PeerIP;
  FPeerPort := ASource.PeerPort;
  FIP := ASource.IP;
  FPort := ASource.Port;
  FHasReadData := ASource.HasReadData;
end;

{ TclTcpConnection }

procedure TclTcpConnection.DispatchNextAction;
begin
  case NetworkStream.NextAction of
    saRead: ReadData(nil);
    saWrite: WriteData(nil);
  end;
end;

procedure TclTcpConnection.InternalReadData(AData: TStream);
var
  res: Integer;
  networkEvents: TWSANetworkEvents;
  needClose: Boolean;
{$IFDEF LOGGER}
  oldSize: Int64;
{$ENDIF}
begin
  InitTimeOutTicks();

{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, 'InternalReadData begin, NextAction = %d', nil, [Integer(NetworkStream.NextAction)]);
  oldSize := 0;
  if (AData <> nil) then
  begin
    oldSize := AData.Size;
  end;
  try
{$ENDIF}
  if NetworkStream.HasReadData then
  begin
    NetworkStream.HasReadData := False;
    NetworkStream.Read(AData);
{$IFDEF LOGGER}
    if (AData <> nil) then
    begin
      clPutLogMessage(Self, edInside, 'InternalReadData: HasReadData', AData, oldSize);
    end;
{$ENDIF}

    if NetworkStream.NeedClose then
    begin
      {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalReadData inside HasReadData - NetworkStream.NeedClose');{$ENDIF}
      Close(False);
      Exit;
    end;

    if (not IsReadUntilClose) or (not Active) then
    begin
      if not Active then
      begin
        NetworkStream.ClearNextAction();
      end;
      
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalReadData: HasReadData - Exit');{$ENDIF}
      Exit;
    end;
  end;

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalReadData: before repeat-until');{$ENDIF}
  needClose := False;
  repeat
    if not Active then
    begin
      RaiseSocketError(WSAENOTSOCK);
    end;

    if WaitForEvent(SocketEvent, FAbortEvent, FTimeOutTicks, TimeOut) then
    begin
      res := WSAEnumNetworkEvents(Socket.Socket, SocketEvent, @networkEvents);
      if (res = SOCKET_ERROR) then
      begin
        RaiseSocketError(WSAGetLastError());
      end;

      if ((networkEvents.lNetworkEvents and FD_CLOSE) > 0) then
      begin
        if (networkEvents.iErrorCode[FD_CLOSE_BIT] <> 0) then
        begin
          RaiseSocketError(networkEvents.iErrorCode[FD_CLOSE_BIT]);
        end;
        {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalReadData inside repeat-until, FD_CLOSE');{$ENDIF}
        needClose := True;
      end;

      if ((networkEvents.lNetworkEvents and FD_READ) > 0) then
      begin
        if (networkEvents.iErrorCode[FD_READ_BIT] <> 0) then
        begin
          RaiseSocketError(networkEvents.iErrorCode[FD_READ_BIT]);
        end;
        {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalReadData inside repeat-until, before NetworkStream.Read');{$ENDIF}
        {$IFDEF LOGGER}
          res := Integer(NetworkStream.Read(AData));
        {$ELSE}
          NetworkStream.Read(AData);
        {$ENDIF}
        {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalReadData inside repeat-until, after NetworkStream.Read, %d', nil, [res]);{$ENDIF}

        if needClose then
        begin
          {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalReadData inside repeat-until, after NetworkStream.Read, needClose = True');{$ENDIF}
          Close(False);
          Break;
        end;

        if not IsReadUntilClose then
        begin
          Break;
        end;
        InitTimeOutTicks();
      end;

      {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalReadData inside repeat-until, needClose = %d', nil, [Integer(needClose)]);{$ENDIF}

      if needClose then
      begin
        {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalReadData inside repeat-until, needClose = True');{$ENDIF}
        Close(False);
        Break;
      end;

      if NetworkStream.NeedClose then
      begin
        {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalReadData inside NetworkStream.NeedClose');{$ENDIF}
        Close(False);
        Break;
      end;
    end;
  until NetworkStream.NeedStop();

{$IFDEF LOGGER}
  finally
    if (AData <> nil) and ((AData.Size - oldSize) > 0) then
    begin
      clPutLogMessage(Self, edInside, 'InternalReadData, received data', AData, oldSize);
    end;
    clPutLogMessage(Self, edInside, 'InternalReadData end, NextAction = %d', nil, [Integer(NetworkStream.NextAction)]);
  end;
{$ENDIF}
end;

procedure TclTcpConnection.InternalWriteData(AData: TStream);
var
  res: Integer;
  networkEvents: TWSANetworkEvents;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'InternalWriteData');{$ENDIF}
  InitTimeOutTicks();

  if NetworkStream.Write(AData) then Exit;

  repeat
    if WaitForEvent(SocketEvent, FAbortEvent, FTimeOutTicks, TimeOut) then
    begin
      res := WSAEnumNetworkEvents(Socket.Socket, SocketEvent, @networkEvents);
      if (res = SOCKET_ERROR) then
      begin
        RaiseSocketError(WSAGetLastError());
      end;

      if ((networkEvents.lNetworkEvents and FD_READ) > 0) then
      begin
        if (networkEvents.iErrorCode[FD_READ_BIT] <> 0) then
        begin
          RaiseSocketError(networkEvents.iErrorCode[FD_READ_BIT]);
        end;
        NetworkStream.HasReadData := True;
      end;

      if ((networkEvents.lNetworkEvents and FD_WRITE) > 0) then
      begin
        if (networkEvents.iErrorCode[FD_WRITE_BIT] <> 0) then
        begin
          RaiseSocketError(networkEvents.iErrorCode[FD_WRITE_BIT]);
        end;
        InitTimeOutTicks();

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalWriteData before second NetworkStream.Write');{$ENDIF}
        if NetworkStream.Write(AData) then Break;
      end;

      if ((networkEvents.lNetworkEvents and FD_CLOSE) > 0) then
      begin
        if (networkEvents.iErrorCode[FD_CLOSE_BIT] <> 0) then
        begin
          RaiseSocketError(networkEvents.iErrorCode[FD_CLOSE_BIT]);
        end;
        Close(False);
        Break;
      end;
    end;
  until NetworkStream.NeedStop();
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'InternalWriteData'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'InternalWriteData', E); raise; end; end;{$ENDIF}
end;

function TclTcpConnection.ReadData(AData: TStream): Boolean;
begin
  InternalReadData(AData);
  repeat
    case NetworkStream.NextAction of
      saRead: InternalReadData(AData);
      saWrite: WriteData(nil);
    else
      Break;
    end;
  until False;

  Result := True;
end;

function TclTcpConnection.WriteData(AData: TStream): Boolean;
begin
  InternalWriteData(AData);
  repeat
    case NetworkStream.NextAction of
      saRead: ReadData(nil);
      saWrite: InternalWriteData(nil)
    else
      Break;
    end;
  until False;

  Result := True;
end;

{ TclUdpServerConnection }

procedure TclUdpServerConnection.Listen(APort: Integer);
var
  bindAddr: TclIpAddress;
begin
  bindAddr := TclIPAddress.CreateBindingIpAddress(LocalBinding);
  try
    CreateSocket(bindAddr.AddressFamily, SOCK_DGRAM, IPPROTO_UDP);

    NetworkStream.Bind(bindAddr, APort);

    SelectSocketEvent(FD_READ or FD_WRITE);
    SetActive(True);

    NetworkStream.StreamReady();
  finally
    bindAddr.Free();
  end;
end;

{ TclUdpConnection }

procedure TclUdpConnection.Broadcast;
begin
  NetworkStream.Broadcast();
end;

function TclUdpConnection.ReadData(AData: TStream): Boolean;
var
  res: Integer;
  networkEvents: TWSANetworkEvents;
  port: Integer;
  addr: TclIPAddress;
begin
  addr := TclIPAddress.CreateNone(Socket.AddressFamily);
  try
    Result := True;

    InitTimeOutTicks();

    if NetworkStream.HasReadData then
    begin
      NetworkStream.HasReadData := False;
      NetworkStream.ReadFrom(AData, addr, port);
      Exit;
    end;

    repeat
      if not Active then
      begin
        RaiseSocketError(WSAENOTSOCK);
      end;

      if WaitForEvent(SocketEvent, FAbortEvent, FTimeOutTicks, TimeOut) then
      begin
        res := WSAEnumNetworkEvents(Socket.Socket, SocketEvent, @networkEvents);
        if (res = SOCKET_ERROR) then
        begin
          RaiseSocketError(WSAGetLastError());
        end;
        if ((networkEvents.lNetworkEvents and FD_READ) > 0) then
        begin
          if (networkEvents.iErrorCode[FD_READ_BIT] <> 0) then
          begin
            RaiseSocketError(networkEvents.iErrorCode[FD_READ_BIT]);
          end;
          NetworkStream.ReadFrom(AData, addr, port);
          Break;
        end;
      end;
    until NetworkStream.NeedStop();
  finally
    addr.Free();
  end;
end;

function TclUdpConnection.WriteData(AData: TStream): Boolean;
var
  res: Integer;
  networkEvents: TWSANetworkEvents;
  peerAddr: TclIPAddress;
begin
  peerAddr := TclIPAddress.CreateIpAddress(PeerIP);
  try
    Result := True;

    InitTimeOutTicks();

    if NetworkStream.WriteTo(AData, peerAddr, PeerPort) then Exit;

    repeat
      if WaitForEvent(SocketEvent, FAbortEvent, FTimeOutTicks, TimeOut) then
      begin
        res := WSAEnumNetworkEvents(Socket.Socket, SocketEvent, @networkEvents);
        if (res = SOCKET_ERROR) then
        begin
          RaiseSocketError(WSAGetLastError());
        end;

        if ((networkEvents.lNetworkEvents and FD_READ) > 0) then
        begin
          if (networkEvents.iErrorCode[FD_READ_BIT] <> 0) then
          begin
            RaiseSocketError(networkEvents.iErrorCode[FD_READ_BIT]);
          end;
          NetworkStream.HasReadData := True;
        end;

        if ((networkEvents.lNetworkEvents and FD_WRITE) > 0) then
        begin
          if (networkEvents.iErrorCode[FD_WRITE_BIT] <> 0) then
          begin
            RaiseSocketError(networkEvents.iErrorCode[FD_WRITE_BIT]);
          end;
          InitTimeOutTicks();

          if NetworkStream.WriteTo(AData, peerAddr, PeerPort) then Break;
        end;
      end;
    until NetworkStream.NeedStop();
  finally
    peerAddr.Free();
  end;
end;

const
  CL_SOCKETEVENT = WM_USER + 2110;

type
  TclLookupComplete = record
    Msg: Cardinal;
    LookupHandle: THandle;
    AsyncBufLen: Word;
    AsyncError: Word;
    Result: LRESULT;
  end;

{ TclHostResolver }

class function TclHostResolver.GetIPAddress(const AHostName: string): string;
var
  resolver: TclHostResolver;
begin
  resolver := nil;
  try
    if IsIpV6Available() then
    begin
      resolver := TclHostResolver6.Create();
    end else
    begin
      resolver := TclHostResolver4.Create();
    end;

    Result := resolver.ResolveIP(AHostName);
  finally
    resolver.Free();
  end;
end;

class procedure TclHostResolver.GetIPAddressList(const AHostName: string; AList: TStrings);
var
  resolver: TclHostResolver;
begin
  resolver := nil;
  try
    if IsIpV6Available() then
    begin
      resolver := TclHostResolver6.Create();
    end else
    begin
      resolver := TclHostResolver4.Create();
    end;

    resolver.ResolveIPList(AHostName, AList);
  finally
    resolver.Free();
  end;
end;

class function TclHostResolver.GetLocalHost: string;
var
  LocalName: array[0..255] of TclChar;
begin
  Result := '';
  if gethostname(LocalName, SizeOf(LocalName)) = 0 then
    Result := string(LocalName);
end;

{ TclHostResolver4 }

procedure TclHostResolver4.WndProc(var Message: TMessage);
begin
  if (Message.Msg = CL_SOCKETEVENT)
    and (TclLookupComplete(Message).LookupHandle = FLookupHandle) then
  begin
    FAsyncError := TclLookupComplete(Message).AsyncError;
    SetEvent(FCompleted);
  end;
end;

procedure TclHostResolver4.DestroyWindowHandle(AWndHandle: HWND);
var
  lpMsg: TMsg;
begin
  while PeekMessage(lpMsg, AWndHandle, 0, 0, PM_REMOVE) do;
  DeallocateWindow(AWndHandle);
end;

function TclHostResolver4.GetHostEntry(const AHostName: string; ATimeOut: Integer): PHostEnt;
var
  wndHandle: HWND;
  hostData: PclChar;
begin
  Result := AllocMem(MAXGETHOSTSTRUCT);
  try
    FCompleted := CreateEvent(nil, False, False, nil);
    wndHandle := AllocateWindow(WndProc);
    try
      FAsyncError := 0;
      hostData := PclChar(Result);
      FLookupHandle := WSAAsyncGetHostByName(wndHandle, CL_SOCKETEVENT, PclChar(GetTclString(AHostName)), hostData, MAXGETHOSTSTRUCT);
      if (FLookupHandle = 0) then
      begin
        RaiseSocketError(WSAGetLastError());
      end;

      FIsAborted := False;
      repeat
        try
          if WaitForEvent(FCompleted, 0, Integer(GetTickCount()), ATimeOut) then Break;
        except
          WSACancelAsyncRequest(FLookupHandle);
          FLookupHandle := 0;
          raise;
        end;
      until FIsAborted;
      FLookupHandle := 0;

      if (FAsyncError <> 0) then
      begin
        RaiseSocketError(FAsyncError);
      end;
    finally
      DestroyWindowHandle(wndHandle);
      CloseHandle(FCompleted);
    end;
  except
    FreeMem(Result);
    raise;
  end;
end;

function TclHostResolver4.GetHostIP(const AHostName: string; ATimeOut: Integer): string;
var
  hostEnt: PHostEnt;
  addrList: PclChar;
begin
  hostEnt := GetHostEntry(AHostName, ATimeOut);
  try
    if (hostEnt^.h_addr_list <> nil) then
    begin
      addrList := hostEnt^.h_addr_list^;
      Result := Format('%d.%d.%d.%d',
        [Ord(addrList[0]), Ord(addrList[1]), Ord(addrList[2]), Ord(addrList[3])]);
    end else
    begin
      Result := '';
    end;
  finally
    FreeMem(hostEnt);
  end;
end;

function TclHostResolver4.ResolveIP(const AHostName: string): string;
begin
  Result := AHostName;
  if not TclIPAddress.IsHostIP(Result) then
  begin
    Result := GetHostIP(Result, 5000);
  end;
end;

procedure TclHostResolver4.ResolveIPList(const AHostName: string; AList: TStrings);
var
  hostEnt: PHostEnt;
  addrList: Pointer;
  addr: PclChar;
begin
  AList.Clear();
  
  hostEnt := GetHostEntry(AHostName, 5000);
  try
    if (hostEnt^.h_addrtype <> AF_INET) or (hostEnt^.h_length <> 4) then Exit;

    addrList := hostEnt^.h_addr_list;
    addr := PclChar(addrList^);
    while (addr <> nil) and (not FIsAborted) do
    begin
      AList.Add(Format('%d.%d.%d.%d',
        [Ord(addr[0]), Ord(addr[1]), Ord(addr[2]), Ord(addr[3])]));

      addrList := PclChar(TclIntPtr(addrList) + SizeOf(Pointer));
      addr := PclChar(addrList^);
    end;
  finally
    FreeMem(hostEnt);
  end;
end;

procedure TclHostResolver4.Abort;
begin
  FIsAborted := True;
  if (FLookupHandle <> 0) then
  begin
    WSACancelAsyncRequest(FLookupHandle);
  end;
end;

{ TclHostResolver6 }

function TclHostResolver6.GetHostIP(const AHostName: string): string;
var
  res: Integer;
  hints: Taddrinfo;
  addrinf, next: Paddrinfo;
begin
  addrinf := nil;
  try
    ZeroMemory(@hints, SizeOf(hints));
    hints.ai_family := AF_UNSPEC;

    res := getaddrinfo(PclChar(GetTclString(AHostName)), nil, @hints, @addrinf);
    if (res <> 0) then
    begin
      RaiseSocketError(res);
    end;

    Result := '';
    next := addrinf;
    while (next <> nil) do
    begin
      if IsIpV6Preferred and (next.ai_family = AF_INET6) then
      begin
        Result := TclIPAddress6.AddrToStr(next.ai_addr.AddressIn6Old.sin6_addr);
        Break;
      end else
      if (not IsIpV6Preferred) and (next.ai_family = AF_INET) then
      begin
        Result := TclIPAddress4.AddrToStr(next.ai_addr.Address.sin_addr);
        Break;
      end;

      next := next.ai_next;
    end;

    if (Result = '') then
    begin
      if (addrinf.ai_family = AF_INET) then
      begin
        Result := TclIPAddress4.AddrToStr(addrinf.ai_addr.Address.sin_addr);
      end else
      if (addrinf.ai_family = AF_INET6) then
      begin
        Result := TclIPAddress6.AddrToStr(addrinf.ai_addr.AddressIn6Old.sin6_addr);
      end;
    end;
  finally
    freeaddrinfo(addrinf);
  end;
end;

function TclHostResolver6.ResolveIP(const AHostName: string): string;
begin
  Result := AHostName;
  if not TclIPAddress.IsHostIP(Result) then
  begin
    Result := GetHostIP(Result);
  end;
end;

procedure TclHostResolver6.ResolveIPList(const AHostName: string; AList: TStrings);
var
  res: Integer;
  hints: Taddrinfo;
  addrinf, next: Paddrinfo;
begin
  AList.Clear();

  addrinf := nil;
  try
    ZeroMemory(@hints, SizeOf(hints));
    hints.ai_family := AF_UNSPEC;

    res := getaddrinfo(PclChar(GetTclString(AHostName)), nil, @hints, @addrinf);
    if (res <> 0) then
    begin
      RaiseSocketError(res);
    end;

    next := addrinf;
    while (next <> nil) do
    begin
      if (next.ai_family = AF_INET6) then
      begin
        AList.Add(TclIPAddress6.AddrToStr(next.ai_addr.AddressIn6Old.sin6_addr));
      end else
      if (next.ai_family = AF_INET) then
      begin
        AList.Add(TclIPAddress4.AddrToStr(next.ai_addr.Address.sin_addr));
      end;

      next := next.ai_next;
    end;
  finally
    freeaddrinfo(addrinf);
  end;
end;

{ TclSocket }

procedure TclSocket.Close;
begin
  if (FSocket <> INVALID_SOCKET) then
  begin
    shutdown(FSocket, SD_BOTH);
    try
      closesocket(FSocket);
    finally
      FSocket := INVALID_SOCKET;
    end;
  end;
  FAddressFamily := AF_UNSPEC;
end;

constructor TclSocket.Create;
begin
  inherited Create();

  FSocket := INVALID_SOCKET;
  FAddressFamily := AF_UNSPEC;
end;

procedure TclSocket.SetSocket(ASocket: TSocket; AddressFamily: Integer);
begin
  FSocket := ASocket;
  FAddressFamily := AddressFamily;
end;

{ TclTcpListenConnection }

procedure TclTcpListenConnection.Accept(AUserConnection: TclTcpServerConnection);
var
  res: Integer;
  networkEvents: TWSANetworkEvents;
begin
  SelectSocketEvent(FD_ACCEPT);

  InitTimeOutTicks();

  repeat
    if WaitForEvent(SocketEvent, FAbortEvent, FTimeOutTicks, TimeOut) then
    begin
      res := WSAEnumNetworkEvents(Socket.Socket, SocketEvent, @networkEvents);
      if (res = SOCKET_ERROR) then
      begin
        RaiseSocketError(WSAGetLastError());
      end;
      if ((networkEvents.lNetworkEvents and FD_ACCEPT) > 0) then
      begin
        if (networkEvents.iErrorCode[FD_ACCEPT_BIT] <> 0) then
        begin
          RaiseSocketError(networkEvents.iErrorCode[FD_ACCEPT_BIT]);
        end;
        Break;
      end;
    end;
  until IsAborted;

  if IsAborted then
  begin
    Close(False);
  end else
  begin
    AUserConnection.Accept(Self);
  end;
end;

function TclTcpListenConnection.Listen(APort: Integer): Integer;
var
  bindAddr: TclIpAddress;
begin
  bindAddr := TclIPAddress.CreateBindingIpAddress(LocalBinding);
  try
    CreateSocket(bindAddr.AddressFamily, SOCK_STREAM, IPPROTO_TCP);

    NetworkStream.Bind(bindAddr, APort);
    NetworkStream.Listen();

    Result := NetworkStream.Port;

    SetActive(True);
  finally
    bindAddr.Free();
  end;
end;

function TclTcpListenConnection.Listen(APortBegin, APortEnd: Integer): Integer;
var
  bindAddr: TclIpAddress;
begin
  bindAddr := TclIPAddress.CreateBindingIpAddress(LocalBinding);
  try
    CreateSocket(bindAddr.AddressFamily, SOCK_STREAM, IPPROTO_TCP);
    NetworkStream.Bind(bindAddr, APortBegin, APortEnd);
    NetworkStream.Listen();

    Result := NetworkStream.Port;

    SetActive(True);
  finally
    bindAddr.Free();
  end;
end;

function TclTcpListenConnection.ReadData(AData: TStream): Boolean;
begin
  Result := False;
end;

function TclTcpListenConnection.WriteData(AData: TStream): Boolean;
begin
  Result := False;
end;

end.
