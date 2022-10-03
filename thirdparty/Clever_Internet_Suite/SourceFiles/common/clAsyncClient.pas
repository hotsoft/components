{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clAsyncClient;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  {$IFDEF DEMO}Forms, {$ENDIF}Messages, Windows, Classes, WinSock, SysUtils,
{$ELSE}
  {$IFDEF DEMO}Vcl.Forms, {$ENDIF}Winapi.Messages, Winapi.Windows, System.Classes, Winapi.WinSock, System.SysUtils,
{$ENDIF}
  clSocket, clUtils, clSspiTls, clTlsSocket, clSocketUtils, clIpAddress,
  clCertificateStore, clCertificate, clWUtils;

type
  TclAsyncAction = (aaConnect, aaDisconnect, aaRead, aaWrite);

  TclAsyncConnection = class(TclConnection)
  public
    function ReadData(AData: TStream): Boolean; override;
    function WriteData(AData: TStream): Boolean; override;
  end;

  TclAsyncErrorEvent = procedure (Sender: TObject; AsyncAction: TclAsyncAction; AErrorCode: Integer; const AMessage: string) of object;
  
  TclAsyncClient = class(TComponent)
  private
    FServer: string;
    FPort: Integer;
    FLocalBinding: string;
    FConnection: TclAsyncConnection;
    FTimeOut: Integer;
    FWindowHandle: HWND;
    FSocketType: Integer;
    FSocketProtocol: Integer;
    FUseTLS: Boolean;
    FCertificateFlags: TclCertificateVerifyFlags;
    FTLSFlags: TclTlsFlags;
    FIsClosed: Boolean;

    FOnRead: TNotifyEvent;
    FOnWrite: TNotifyEvent;
    FOnConnect: TNotifyEvent;
    FOnConnecting: TNotifyEvent;
    FOnDisconnect: TNotifyEvent;
    FOnChanged: TNotifyEvent;
    FOnVerifyServer: TclVerifyPeerEvent;
    FOnGetCertificate: TclGetCertificateEvent;
    FOnAsyncError: TclAsyncErrorEvent;

    function GetBatchSize: Integer;
    function GetBitsPerSec: Integer;
    procedure SetBatchSize(const Value: Integer);
    procedure SetBitsPerSec(const Value: Integer);
    function GetActive: Boolean;
    procedure WaitForCompletion;
    procedure WndProc(var Message: TMessage);
    procedure HandleConnect(AErrorCode: Integer);
    procedure HandleRead(AErrorCode: Integer);
    procedure HandleWrite(AErrorCode: Integer);
    procedure HandleClose(AErrorCode: Integer);
    procedure HandleAsyncError(AsyncAction: TclAsyncAction; AErrorCode: Integer);
    procedure SetServer(const Value: string);
    procedure SetPort_(const Value: Integer);
    procedure SetLocalBinding(const Value: string);
    procedure SetTimeOut(const Value: Integer);
    procedure SetSocketType(const Value: Integer);
    procedure SetSocketProtocol(const Value: Integer);
    procedure SetUseTLS(const Value: Boolean);
    procedure SetCertificateFlags(const Value: TclCertificateVerifyFlags);
    procedure SetTLSFlags(const Value: TclTlsFlags);

    procedure GetCertificate(Sender: TObject; var ACertificate: TclCertificate;
      AExtraCerts: TclCertificateList; var Handled: Boolean);
    procedure VerifyServer(Sender: TObject; ACertificate: TclCertificate; const AStatusText: string; AStatusCode:
      Integer; var AVerified: Boolean);
    procedure SelectEvent(ASocket: TclSocket; lEvent: Integer);
  protected
    procedure DoDestroy; virtual;
    procedure Changed; virtual;
    procedure DoConnect; virtual;
    procedure DoConnecting; virtual;
    procedure DoDisconnect; virtual;
    procedure DoRead; virtual;
    procedure DoWrite; virtual;
    procedure DoAsyncError(AsyncAction: TclAsyncAction; AErrorCode: Integer; const AMessage: string); virtual;
    procedure DoGetCertificate(var ACertificate: TclCertificate; AExtraCerts: TclCertificateList; var Handled: Boolean); virtual;
    procedure DoVerifyServer(ACertificate: TclCertificate; const AStatusText: string;
      AStatusCode: Integer; var AVerified: Boolean); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open;
    procedure Close;
    function ReadData(AData: TStream): TclNetworkStreamAction;
    function WriteData(AData: TStream): TclNetworkStreamAction;
    procedure AssignTlsStream();

    property Connection: TclAsyncConnection read FConnection;
    property Active: Boolean read GetActive;
  published
    property Server: string read FServer write SetServer;
    property Port: Integer read FPort write SetPort_;
    property LocalBinding: string read FLocalBinding write SetLocalBinding;
    property BatchSize: Integer read GetBatchSize write SetBatchSize default 8192;
    property BitsPerSec: Integer read GetBitsPerSec write SetBitsPerSec default 0;
    property TimeOut: Integer read FTimeOut write SetTimeOut default 60000;
    property SocketType: Integer read FSocketType write SetSocketType default SOCK_STREAM;
    property SocketProtocol: Integer read FSocketProtocol write SetSocketProtocol default IPPROTO_TCP;
    property UseTLS: Boolean read FUseTLS write SetUseTLS default False;
    property CertificateFlags: TclCertificateVerifyFlags read FCertificateFlags write SetCertificateFlags default [];
    property TLSFlags: TclTlsFlags read FTLSFlags write SetTLSFlags default [tfUseTLS];

    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnConnect: TNotifyEvent read FOnConnect write FOnConnect;
    property OnConnecting: TNotifyEvent read FOnConnecting write FOnConnecting;
    property OnDisconnect: TNotifyEvent read FOnDisconnect write FOnDisconnect;
    property OnRead: TNotifyEvent read FOnRead write FOnRead;
    property OnWrite: TNotifyEvent read FOnWrite write FOnWrite;
    property OnAsyncError: TclAsyncErrorEvent read FOnAsyncError write FOnAsyncError;
    property OnGetCertificate: TclGetCertificateEvent read FOnGetCertificate write FOnGetCertificate;
    property OnVerifyServer: TclVerifyPeerEvent read FOnVerifyServer write FOnVerifyServer;
  end;
  
implementation

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

const
  CL_SOCKETEVENT = WM_USER + 2111;

{ TclAsyncClient }

constructor TclAsyncClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FWindowHandle := 0;
  StartupSocket();
  FConnection := TclAsyncConnection.Create();
  BatchSize := 8192;
  BitsPerSec := 0;
  TimeOut := 60000;
  FSocketType := SOCK_STREAM;
  FSocketProtocol := IPPROTO_TCP;
  FIsClosed := True;
end;

destructor TclAsyncClient.Destroy;
begin
  Close();
  WaitForCompletion();
  DoDestroy();
  FConnection.Free();
  CleanupSocket();
  if (FWindowHandle <> 0) then
  begin
    DeallocateWindow(FWindowHandle);
  end;
  inherited Destroy();
end;

procedure TclAsyncClient.WaitForCompletion;
var
  Msg: TMsg;
begin
  while PeekMessage(Msg, 0, 0, 0, PM_REMOVE) do
  begin
    DispatchMessage(Msg);
  end;
end;

procedure TclAsyncClient.WndProc(var Message: TMessage);
var
  errorCode: Integer;
begin
  if (Message.Msg <> CL_SOCKETEVENT) or (TSocket(Message.wParam) <> Connection.Socket.Socket) then Exit;

  errorCode := HIWORD(Message.lParam);
  case LOWORD(Message.lParam) of
    FD_CONNECT: HandleConnect(errorCode);
    FD_READ: HandleRead(errorCode);
    FD_WRITE: HandleWrite(errorCode);
    FD_CLOSE: HandleClose(errorCode);
  end;
end;

function TclAsyncClient.WriteData(AData: TStream): TclNetworkStreamAction;
begin
  Connection.WriteData(AData);
  Result := Connection.NetworkStream.NextAction;
end;

procedure TclAsyncClient.DoConnect;
begin
  if Assigned(OnConnect) then
  begin
    OnConnect(Self);
  end;
end;

procedure TclAsyncClient.DoConnecting;
begin
  if Assigned(OnConnecting) then
  begin
    OnConnecting(Self);
  end;
end;

procedure TclAsyncClient.DoDestroy;
begin
end;

procedure TclAsyncClient.DoDisconnect;
begin
  if Assigned(OnDisconnect) then
  begin
    OnDisconnect(Self);
  end;
end;

procedure TclAsyncClient.DoAsyncError(AsyncAction: TclAsyncAction; AErrorCode: Integer; const AMessage: string);
begin
  if Assigned(OnAsyncError) then
  begin
    OnAsyncError(Self, AsyncAction, AErrorCode, AMessage);
  end;
end;

procedure TclAsyncClient.DoGetCertificate(var ACertificate: TclCertificate; AExtraCerts: TclCertificateList; var Handled: Boolean);
begin
  if Assigned(OnGetCertificate) then
  begin
    OnGetCertificate(Self, ACertificate, AExtraCerts, Handled);
  end;
end;

procedure TclAsyncClient.DoRead;
begin
  if Assigned(OnRead) then
  begin
    OnRead(Self);
  end;
end;

procedure TclAsyncClient.DoVerifyServer(ACertificate: TclCertificate; const AStatusText: string;
  AStatusCode: Integer; var AVerified: Boolean);
begin
  if Assigned(OnVerifyServer) then
  begin
    OnVerifyServer(Self, ACertificate, AStatusText, AStatusCode, AVerified);
  end;
end;

procedure TclAsyncClient.DoWrite;
begin
  if Assigned(OnWrite) then
  begin
    OnWrite(Self);
  end;
end;

function TclAsyncClient.GetActive: Boolean;
begin
  Result := Connection.Active;
end;

function TclAsyncClient.GetBatchSize: Integer;
begin
  Result := Connection.BatchSize;
end;

function TclAsyncClient.GetBitsPerSec: Integer;
begin
  Result := Connection.BitsPerSec;
end;

procedure TclAsyncClient.GetCertificate(Sender: TObject; var ACertificate: TclCertificate;
  AExtraCerts: TclCertificateList; var Handled: Boolean);
begin
  DoGetCertificate(ACertificate, AExtraCerts, Handled);
end;

procedure TclAsyncClient.HandleClose(AErrorCode: Integer);
begin
  if not FIsClosed then
  begin
    FIsClosed := True;

    Connection.Close(False);

    if (AErrorCode = 0) then
    begin
      DoDisconnect();
    end else
    begin
      HandleAsyncError(aaDisconnect, AErrorCode);
    end;
  end;
end;

procedure TclAsyncClient.HandleConnect(AErrorCode: Integer);
begin
  if (AErrorCode = 0) then
  begin
    Connection.SetActive(True);

    repeat
      case Connection.NetworkStream.NextAction of
        saWrite: WriteData(nil)
      else
        Break;
      end;
    until False;

    DoConnect();
  end else
  begin
    try
      Connection.Close(False);
    except
      on EclSocketError do;
    end;
    HandleAsyncError(aaConnect, AErrorCode);
  end;
end;

procedure TclAsyncClient.HandleAsyncError(AsyncAction: TclAsyncAction; AErrorCode: Integer);
begin
  DoAsyncError(AsyncAction, AErrorCode, GetWSAErrorText(AErrorCode));
end;

procedure TclAsyncClient.HandleRead(AErrorCode: Integer);
begin
  if (AErrorCode = 0) then
  begin
    DoRead();
  end else
  begin
    HandleAsyncError(aaRead, AErrorCode);
  end;
end;

procedure TclAsyncClient.HandleWrite(AErrorCode: Integer);
begin
  if (AErrorCode = 0) then
  begin
    DoWrite();
  end else
  begin
    HandleAsyncError(aaWrite, AErrorCode);
  end;
end;

procedure TclAsyncClient.SelectEvent(ASocket: TclSocket; lEvent: Integer);
var
  res: Integer;
begin
  res := WSAAsyncSelect(ASocket.Socket, FWindowHandle, CL_SOCKETEVENT, lEvent);
  if (res = SOCKET_ERROR) then
  begin
    RaiseSocketError(WSAGetLastError());
  end;
end;

procedure TclAsyncClient.SetBatchSize(const Value: Integer);
begin
  if (Connection.BatchSize <> Value) then
  begin
    Connection.BatchSize := Value;
    Changed();
  end;
end;

procedure TclAsyncClient.SetBitsPerSec(const Value: Integer);
begin
  if (Connection.BitsPerSec <> Value) then
  begin
    Connection.BitsPerSec := Value;
    Changed();
  end;
end;

procedure TclAsyncClient.SetCertificateFlags(const Value: TclCertificateVerifyFlags);
begin
  if (FCertificateFlags <> Value) then
  begin
    FCertificateFlags := Value;
    Changed();
  end;
end;

procedure TclAsyncClient.SetLocalBinding(const Value: string);
begin
  if (FLocalBinding <> Value) then
  begin
    FLocalBinding := Value;
    Changed();
  end;
end;

procedure TclAsyncClient.SetPort_(const Value: Integer);
begin
  if (FPort <> Value) then
  begin
    FPort := Value;
    Changed();
  end;
end;

procedure TclAsyncClient.SetServer(const Value: string);
begin
  if (FServer <> Value) then
  begin
    FServer := Value;
    Changed();
  end;
end;

procedure TclAsyncClient.SetSocketProtocol(const Value: Integer);
begin
  if (FSocketProtocol <> Value) then
  begin
    FSocketProtocol := Value;
    Changed();
  end;
end;

procedure TclAsyncClient.SetSocketType(const Value: Integer);
begin
  if (FSocketType <> Value) then
  begin
    FSocketType := Value;
    Changed();
  end;
end;

procedure TclAsyncClient.SetTimeOut(const Value: Integer);
begin
  if (FTimeOut <> Value) then
  begin
    FTimeOut := Value;
    Changed();
  end;
end;

procedure TclAsyncClient.SetTLSFlags(const Value: TclTlsFlags);
begin
  if (FTLSFlags <> Value) then
  begin
    FTLSFlags := Value;
    Changed();
  end;
end;

procedure TclAsyncClient.SetUseTLS(const Value: Boolean);
begin
  if (FUseTLS <> Value) then
  begin
    FUseTLS := Value;
    Changed();
  end;
end;

procedure TclAsyncClient.VerifyServer(Sender: TObject; ACertificate: TclCertificate; const AStatusText: string;
  AStatusCode: Integer; var AVerified: Boolean);
begin
  DoVerifyServer(ACertificate, AStatusText, AStatusCode, AVerified);
end;

procedure TclAsyncClient.Open;
var
  addr, bindAddr: TclIPAddress;
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
    if (not IsDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  FIsClosed := False;

  if (FWindowHandle = 0) then
  begin
    FWindowHandle := AllocateWindow(WndProc);
  end;
  if (FWindowHandle = 0) then
  begin
    RaiseSocketError(clGetLastError());
  end;

  if UseTLS then
  begin
    AssignTlsStream();
  end else
  begin
    Connection.NetworkStream := TclNetworkStream.Create();
  end;

  addr := nil;
  bindAddr := nil;
  try
    addr := TclIPAddress.CreateIpAddress(TclHostResolver.GetIPAddress(Server));
    Connection.CreateSocket(addr.AddressFamily, SocketType, SocketProtocol);

    SelectEvent(Connection.Socket, FD_CONNECT or FD_CLOSE or FD_READ or FD_WRITE);

    if (Trim(LocalBinding) <> '') then
    begin
      bindAddr := TclIPAddress.CreateBindingIpAddress(LocalBinding, addr.AddressFamily);
      Connection.NetworkStream.Bind(bindAddr, 0);
    end;

    DoConnecting();
    Connection.NetworkStream.Connect(addr, Port);
  finally
    bindAddr.Free();
    addr.Free();
  end;
end;

function TclAsyncClient.ReadData(AData: TStream): TclNetworkStreamAction;
begin
  SelectEvent(Connection.Socket, FD_CONNECT or FD_CLOSE or FD_WRITE);
  try
    Connection.ReadData(AData);
    Result := Connection.NetworkStream.NextAction;
  finally
    SelectEvent(Connection.Socket, FD_CONNECT or FD_CLOSE or FD_READ or FD_WRITE);
  end;
end;

procedure TclAsyncClient.AssignTlsStream();
var
  tlsStream: TclTlsNetworkStream;
begin
  tlsStream := TclTlsNetworkStream.Create();
  Connection.NetworkStream := tlsStream;
  tlsStream.CertificateFlags := CertificateFlags;
  tlsStream.TLSFlags := TLSFlags;
  tlsStream.TargetName := Server;
  tlsStream.OnGetCertificate := GetCertificate;
  tlsStream.OnVerifyPeer := VerifyServer;
end;

procedure TclAsyncClient.Changed;
begin
  if Assigned(OnChanged) then
  begin
    OnChanged(Self);
  end;
end;

procedure TclAsyncClient.Close;
var
  wasActive: Boolean;
  action: TclNetworkStreamAction;
begin
  action := saNone;
  wasActive := Active;

  Connection.Close(True);

  if wasActive then
  begin
    action := Connection.NetworkStream.NextAction;
  end;

  if (action = saWrite) then
  begin
    action := WriteData(nil);
  end;

  if (action = saNone) then
  begin
    HandleClose(0);
  end;
end;

{ TclAsyncConnection }

function TclAsyncConnection.ReadData(AData: TStream): Boolean;
begin
  Result := NetworkStream.Read(AData);
end;

function TclAsyncConnection.WriteData(AData: TStream): Boolean;
begin
  Result := NetworkStream.Write(AData);
end;

end.
