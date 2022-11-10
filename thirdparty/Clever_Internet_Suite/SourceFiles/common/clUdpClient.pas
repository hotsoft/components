{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clUdpClient;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, WinSock,{$IFDEF DEMO} Forms, Windows,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils, Winapi.WinSock,{$IFDEF DEMO} Vcl.Forms, Winapi.Windows,{$ENDIF}
{$ENDIF}
  clSocket;

type
  TclUdpPacketEvent = procedure (Sender: TObject; AData: TStream) of object;

  TclUdpClient = class(TComponent)
  private
    FServer: string;
    FPort: Integer;
    FConnection: TclUdpClientConnection;
    FOnChanged: TNotifyEvent;
    FOnSendPacket: TclUdpPacketEvent;
    FOnReceivePacket: TclUdpPacketEvent;
    FCharSet: string;
    
    procedure SetServer(const Value: string);
    procedure SetPort_(const Value: Integer);
    procedure SetDatagramSize(const Value: Integer);
    procedure SetTimeOut(const Value: Integer);
    procedure SetBitsPerSec(const Value: Integer);
    function GetDatagramSize: Integer;
    function GetBitsPerSec: Integer;
    function GetTimeOut: Integer;
    function GetLocalBinding: string;
    procedure SetLocalBinding(const Value: string);
    procedure SetCharSet(const Value: string);
  protected
    procedure OpenConnection(const AServer: string; APort: Integer); virtual;

    procedure DoDestroy; virtual;
    procedure Changed; dynamic;
    procedure DoReceivePacket(AData: TStream); dynamic;
    procedure DoSendPacket(AData: TStream); dynamic;

    function GetDefaultPort: Integer; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Open;
    procedure Close;
    procedure SendPacket(AData: TStream); overload;
    procedure ReceivePacket(AData: TStream); overload;
    procedure SendPacket(const AData: string); overload;
    function ReceivePacket: string; overload;

    property Connection: TclUdpClientConnection read FConnection;
  published
    property Server: string read FServer write SetServer;
    property Port: Integer read FPort write SetPort_;
    property DatagramSize: Integer read GetDatagramSize write SetDatagramSize default 8192;
    property TimeOut: Integer read GetTimeOut write SetTimeOut default 5000;
    property BitsPerSec: Integer read GetBitsPerSec write SetBitsPerSec default 0;
    property LocalBinding: string read GetLocalBinding write SetLocalBinding;
    property CharSet: string read FCharSet write SetCharSet;

    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnReceivePacket: TclUdpPacketEvent read FOnReceivePacket write FOnReceivePacket;
    property OnSendPacket: TclUdpPacketEvent read FOnSendPacket write FOnSendPacket;
  end;

implementation

uses
  clTranslator, clUtils{$IFDEF LOGGER}, clLogger{$ENDIF};

{ TclUdpClient }

procedure TclUdpClient.Changed;
begin
  if Assigned(FOnChanged) then
  begin
    FOnChanged(Self);
  end;
end;

constructor TclUdpClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  StartupSocket();
  FConnection := TclUdpClientConnection.Create();
  FConnection.NetworkStream := TclNetworkStream.Create();
  DatagramSize := 8192;
  TimeOut := 5000;
  BitsPerSec := 0;
  Port := GetDefaultPort();
end;

destructor TclUdpClient.Destroy;
begin
  DoDestroy();
  FConnection.Free();
  CleanupSocket();
  inherited Destroy();
end;

procedure TclUdpClient.DoDestroy;
begin
end;

procedure TclUdpClient.SetDatagramSize(const Value: Integer);
begin
  if (DatagramSize <> Value) then
  begin
    Connection.BatchSize := Value;
    Changed();
  end;
end;

procedure TclUdpClient.SetLocalBinding(const Value: string);
begin
  if (LocalBinding <> Value) then
  begin
    Connection.LocalBinding := Value;
    Changed();
  end;
end;

procedure TclUdpClient.SetPort_(const Value: Integer);
begin
  if (FPort <> Value) then
  begin
    FPort := Value;
    Changed();
  end;
end;

procedure TclUdpClient.SetServer(const Value: string);
begin
  if (FServer <> Value) then
  begin
    FServer := Value;
    Changed();
  end;
end;

procedure TclUdpClient.SetTimeOut(const Value: Integer);
begin
  if (TimeOut <> Value) then
  begin
    Connection.TimeOut := Value;
    Changed();
  end;
end;

procedure TclUdpClient.SetBitsPerSec(const Value: Integer);
begin
  if (BitsPerSec <> Value) then
  begin
    Connection.BitsPerSec := Value;
    Changed();
  end;
end;

procedure TclUdpClient.SetCharSet(const Value: string);
begin
  if (FCharSet <> Value) then
  begin
    FCharSet := Value;
    Changed();
  end;
end;

function TclUdpClient.GetDatagramSize: Integer;
begin
  Result := Connection.BatchSize;
end;

function TclUdpClient.GetLocalBinding: string;
begin
  Result := Connection.LocalBinding;
end;

function TclUdpClient.GetBitsPerSec: Integer;
begin
  Result := Connection.BitsPerSec;
end;

function TclUdpClient.GetTimeOut: Integer;
begin
  Result := Connection.TimeOut;
end;

procedure TclUdpClient.OpenConnection(const AServer: string; APort: Integer);
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

  Connection.Open(TclHostResolver.GetIPAddress(AServer), APort);
end;

procedure TclUdpClient.Open;
begin
  OpenConnection(Server, Port);
end;

procedure TclUdpClient.Close;
begin
  Connection.Close(False);
end;

procedure TclUdpClient.ReceivePacket(AData: TStream);
begin
  Connection.ReadData(AData);
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ReceivePacket(%d)', nil, [AData.Size]);{$ENDIF}
  DoReceivePacket(AData);
end;

procedure TclUdpClient.SendPacket(AData: TStream);
begin
  Connection.WriteData(AData);
  DoSendPacket(AData);
end;

procedure TclUdpClient.DoReceivePacket(AData: TStream);
begin
  if Assigned(OnReceivePacket) then
  begin
    OnReceivePacket(Self, AData);
  end;
end;

procedure TclUdpClient.DoSendPacket(AData: TStream);
begin
  if Assigned(OnSendPacket) then
  begin
    OnSendPacket(Self, AData);
  end;
end;

function TclUdpClient.ReceivePacket: string;
var
  stream: TStream;
  size: Integer;
  buffer: TclByteArray;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  stream := TMemoryStream.Create();
  try
    ReceivePacket(stream);
    stream.Position := 0;

    size := stream.Size - stream.Position;

    if (size > 0) then
    begin
      SetLength(buffer, size);
      stream.Read(buffer[0], size);
      Result := TclTranslator.GetString(buffer, 0, size, CharSet);
    end else
    begin
      Result := '';
    end;
  finally
    stream.Free();
  end;
end;

procedure TclUdpClient.SendPacket(const AData: string);
var
  stream: TStream;
  buffer: TclByteArray;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  stream := TMemoryStream.Create();
  try
    if (AData <> '') then
    begin
      buffer := TclTranslator.GetBytes(AData, CharSet);
      stream.WriteBuffer(buffer[0], Length(buffer));
      stream.Position := 0;
    end;
    SendPacket(stream);
  finally
    stream.Free();
  end;
end;

end.
