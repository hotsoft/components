{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSocks;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, WinSock,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.WinSock,
{$ENDIF}
  clSocket, clSocketUtils, clUtils, clIpAddress;

type
  TclSocksConnectionState = (csHello, csAuthenticate, csCommand, csOpenSession, csData);

  EclSocksFirewallError = class(EclSocketError);

  TclSocksNetworkStream = class(TclNetworkStream)
  private
    FTargetPort: Integer;
    FTargetServer: string;
    FReadBuffer: TStream;
    FUserName: string;
    FPassword: string;
    FState: TclSocksConnectionState;
    FBaseStream: TclNetworkStream;
  protected
    procedure ByteArrayWriteIP(const AValue: string; var ADestination: TclByteArray; var AIndex: Integer);
    procedure ByteArrayWriteString(const AValue: string; var ADestination: TclByteArray; var AIndex: Integer);
    procedure ByteArrayWriteStringVar(const AValue: string; var ADestination: TclByteArray; var AIndex: Integer);
    procedure BuildCommand(var ACommand: TclByteArray); virtual; abstract;
    function ParseResponse(const ACommand: TclByteArray): Boolean; virtual; abstract;
    function GetBytesToRead: Integer; virtual; abstract;

    property State: TclSocksConnectionState read FState write FState;
  public
    constructor Create(ABaseStream: TclNetworkStream);
    destructor Destroy; override;

    procedure SetConnection(AConnection: TclConnection); override;
    procedure Assign(ASource: TclNetworkStream); override;
    function Connect(Addr_: TclIPAddress; APort: Integer): Boolean; override;
    procedure ConnectEnd; override;
    procedure Close(ANotifyPeer: Boolean); override;
    procedure StreamReady; override;
    function Read(AData: TStream): Boolean; override;
    function Write(AData: TStream): Boolean; override;

    function GetReadBatchSize: Integer; override;
    function GetWriteBatchSize: Integer; override;

    procedure UpdateProgress(ABytesProceed: Int64); override;
    procedure InitClientSession; override;

    procedure Broadcast; override;
    procedure Listen; override;
    procedure Accept; override;
    procedure InitServerSession; override;
    function ReadFrom(AData: TStream; Addr: TclIPAddress; var APort: Integer): Boolean; override;
    function WriteTo(AData: TStream; Addr: TclIPAddress; APort: Integer): Boolean; override;

    property BaseStream: TclNetworkStream read FBaseStream;
    property TargetServer: string read FTargetServer write FTargetServer;
    property TargetPort: Integer read FTargetPort write FTargetPort;
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
  end;

  TclSocks4NetworkStream = class(TclSocksNetworkStream)
  private
    function GetSocksErrorMessage(AErrorCode: Integer): string;
  protected
    procedure BuildCommand(var ACommand: TclByteArray); override;
    function ParseResponse(const ACommand: TclByteArray): Boolean; override;
    function GetBytesToRead: Integer; override;
  end;

  TclSocks5NetworkStream = class(TclSocksNetworkStream)
  private
    FBytesToRead: Integer;
    
    procedure BuildAuthenticate(var ACommand: TclByteArray);
    procedure BuildConnect(var ACommand: TclByteArray);
    procedure BuildHello(var ACommand: TclByteArray);
    function ParseAuthenticate(const ACommand: TclByteArray): Boolean;
    function ParseCommand(const ACommand: TclByteArray): Boolean;
    function ParseHello(const ACommand: TclByteArray): Boolean;
    function GetSocksErrorMessage(AErrorCode: Integer): string;
  protected
    procedure BuildCommand(var ACommand: TclByteArray); override;
    function ParseResponse(const ACommand: TclByteArray): Boolean; override;
    function GetBytesToRead: Integer; override;
  public
    function Connect(Addr_: TclIPAddress; APort: Integer): Boolean; override;
  end;

resourcestring
  cSocksUnknown = 'Unknown SOCKS error occured';

  cSocks4RequestOk = 'Request granted';
  cSocks4RequestFail = 'SOCKS error: request rejected or failed';
  cSocks4IdentdConnectFail = 'SOCKS error: request rejected becasue SOCKS server cannot connect to identd on the client';
  cSocks4IdentdDiffer = 'SOCKS error: request rejected because the client program and identd report different user-ids';

  cSocks5AuthError = 'SOCKS error: authentication failed';
  cSocks5AuthMethodError = 'SOCKS error: No acceptable authentication methods';
  cSocks5Succeeded = 'Succeeded';
  cSocks5Failure = 'General SOCKS server failure';
  cSocks5Denied = 'SOCKS error: connection not allowed by ruleset';
  cSocks5NetworkError = 'SOCKS error: Network unreachable';
  cSocks5HostError = 'SOCKS error: Host unreachable';
  cSocks5ConnectionError = 'SOCKS error: Connection refused';
  cSocks5Timeout = 'SOCKS error: TTL expired';
  cSocks5CommandError = 'SOCKS error: Command not supported';
  cSocks5AddressError = 'SOCKS error: Address type not supported';

implementation

{ TclSocksNetworkStream }

procedure TclSocksNetworkStream.Accept;
begin
  Assert(False, 'Not implemented');
end;

procedure TclSocksNetworkStream.Assign(ASource: TclNetworkStream);
var
  src: TclSocksNetworkStream;
begin
  inherited Assign(ASource);
  if (ASource is TclSocksNetworkStream) then
  begin
    src := ASource as TclSocksNetworkStream;
    FTargetServer := src.TargetServer;
    FTargetPort := src.TargetPort;
    FUserName := src.UserName;
    FPassword := src.Password;
  end;
end;

procedure TclSocksNetworkStream.SetConnection(AConnection: TclConnection);
begin
  inherited SetConnection(AConnection);
  BaseStream.SetConnection(AConnection);
end;

procedure TclSocksNetworkStream.StreamReady;
begin
  if (State = csOpenSession) then
  begin
    State := csData;
    InitClientSession();
  end else
  if (State = csData) then
  begin
    BaseStream.StreamReady();
  end;
end;

procedure TclSocksNetworkStream.UpdateProgress(ABytesProceed: Int64);
begin
  if (State = csData) then
  begin
    BaseStream.UpdateProgress(ABytesProceed);
  end;
end;

procedure TclSocksNetworkStream.Broadcast;
begin
  Assert(False, 'Not implemented');
end;

procedure TclSocksNetworkStream.ByteArrayWriteIP(const AValue: string;
  var ADestination: TclByteArray; var AIndex: Integer);
var
  i: Integer;
begin
  for i := 1 to WordCount(AValue, ['.']) do
  begin
    ADestination[AIndex] := Byte(StrToIntDef(ExtractWord(i, AValue, ['.']), 0));
    Inc(AIndex);
  end;
end;

procedure TclSocksNetworkStream.ByteArrayWriteString(const AValue: string;
  var ADestination: TclByteArray; var AIndex: Integer);
var
  i: Integer;
begin
  for i := 1 to Length(AValue) do
  begin
    ADestination[AIndex] := Ord(AValue[i]);
    Inc(AIndex);
  end;

  ADestination[AIndex] := 0;
  Inc(AIndex);
end;

procedure TclSocksNetworkStream.ByteArrayWriteStringVar(const AValue: string;
  var ADestination: TclByteArray; var AIndex: Integer);
var
  i: Integer;
begin
  ADestination[AIndex] := Length(AValue);
  Inc(AIndex);

  for i := 1 to Length(AValue) do
  begin
    ADestination[AIndex] := Ord(AValue[i]);
    Inc(AIndex);
  end;
end;

procedure TclSocksNetworkStream.Close(ANotifyPeer: Boolean);
begin
  inherited Close(ANotifyPeer);
  BaseStream.Close(ANotifyPeer);
end;

function TclSocksNetworkStream.Connect(Addr_: TclIPAddress; APort: Integer): Boolean;
begin
  FState := csHello;
  Result := inherited Connect(Addr_, APort);
end;

procedure TclSocksNetworkStream.ConnectEnd;
begin
  inherited ConnectEnd();
  BaseStream.ConnectEnd();
end;

constructor TclSocksNetworkStream.Create(ABaseStream: TclNetworkStream);
begin
  inherited Create();

  FReadBuffer := TMemoryStream.Create();
  FBaseStream := ABaseStream;
  FState := csHello;
  FReadBuffer.Size := 0;
  SetNextAction(saWrite);
end;

destructor TclSocksNetworkStream.Destroy;
begin
  FBaseStream.Free();
  FReadBuffer.Free();
  
  inherited Destroy();
end;

function TclSocksNetworkStream.GetReadBatchSize: Integer;
begin
  if (State = csData) then
  begin
    Result := BaseStream.GetReadBatchSize();
  end else
  begin
    Result := inherited GetReadBatchSize();
  end;
end;

function TclSocksNetworkStream.GetWriteBatchSize: Integer;
begin
  if (State = csData) then
  begin
    Result := BaseStream.GetWriteBatchSize();
  end else
  begin
    Result := inherited GetWriteBatchSize();
  end;
end;

procedure TclSocksNetworkStream.Listen;
begin
  Assert(False, 'Not implemented');
end;

procedure TclSocksNetworkStream.InitClientSession;
begin
  if (State = csData) then
  begin
    ClearNextAction();
    BaseStream.InitClientSession();
    SetNextAction(BaseStream.NextAction);
  end else
  begin
    FState := csHello;
    FReadBuffer.Size := 0;
    SetNextAction(saWrite);
  end;
end;

procedure TclSocksNetworkStream.InitServerSession;
begin
  Assert(False, 'Not implemented');
end;

function TclSocksNetworkStream.Read(AData: TStream): Boolean;
var
  len: Integer;
  cmd: TclByteArray;
begin
{$IFNDEF DELPHI2005}cmd := nil;{$ENDIF}
  if (State = csData) then
  begin
    ClearNextAction();
    Result := BaseStream.Read(AData);
    SetNextAction(BaseStream.NextAction);
  end else
  begin
    len := GetBytesToRead() - FReadBuffer.Size;

    InitProgress();
    Connection.BytesToProceed := len;
    FReadBuffer.Seek(0, soEnd);
    try
      Result := inherited Read(FReadBuffer);
      HasReadData := Result;
    finally
      Connection.BytesToProceed := -1;
    end;

    SetLength(cmd, len);
    FReadBuffer.Position := 0;
    if (len > 0) then
    begin
      len := FReadBuffer.Read(cmd[0], len);
      SetLength(cmd, len);
    end;
    if ParseResponse(cmd) then
    begin
      FReadBuffer.Size := 0;
    end;
  end;
end;

function TclSocksNetworkStream.ReadFrom(AData: TStream; Addr: TclIPAddress;
  var APort: Integer): Boolean;
begin
  Assert(False, 'Not implemented');
  Result := False;
end;

function TclSocksNetworkStream.Write(AData: TStream): Boolean;
var
  cmdStream: TStream;
  cmd: TclByteArray;
begin
{$IFNDEF DELPHI2005}cmd := nil;{$ENDIF}
  if (State = csData) then
  begin
    ClearNextAction();
    Result := BaseStream.Write(AData);
    SetNextAction(BaseStream.NextAction);
  end else
  begin
    cmdStream := TMemoryStream.Create();
    try
      BuildCommand(cmd);

      Assert(Length(cmd) > 0);
      cmdStream.Write(cmd[0], Length(cmd));
      cmdStream.Position := 0;
      InitProgress();
      Result := inherited Write(cmdStream);
    finally
      cmdStream.Free();
    end;
    SetNextAction(saRead);
  end;
end;

function TclSocksNetworkStream.WriteTo(AData: TStream; Addr: TclIPAddress;
  APort: Integer): Boolean;
begin
  Assert(False, 'Not implemented');
  Result := False;
end;

{ TclSocks4NetworkStream }

procedure TclSocks4NetworkStream.BuildCommand(var ACommand: TclByteArray);
var
  ind: Integer;
begin
  SetLength(ACommand, 1024);

  ind := 0;
  ACommand[ind] := 4; //VER
  Inc(ind);
  ACommand[ind] := 1; //CONNECT
  Inc(ind);

  ByteArrayWriteWord(TargetPort, ACommand, ind);

  if not TclIPAddress4.IsHostIP(TargetServer) then
  begin
    ByteArrayWriteIP('0.0.0.1', ACommand, ind);
  end else
  begin
    ByteArrayWriteIP(TargetServer, ACommand, ind);
  end;
  ByteArrayWriteString(UserName, ACommand, ind);

  if not TclIPAddress4.IsHostIP(TargetServer) then
  begin
    ByteArrayWriteString(TargetServer, ACommand, ind);
  end;
  
  SetLength(ACommand, ind);
end;

function TclSocks4NetworkStream.GetBytesToRead: Integer;
begin
  Result := 8;
end;

function TclSocks4NetworkStream.GetSocksErrorMessage(AErrorCode: Integer): string;
begin
  case AErrorCode of
    90: Result := cSocks4RequestOk;
    91: Result := cSocks4RequestFail;
    92: Result := cSocks4IdentdConnectFail;
    93: Result := cSocks4IdentdDiffer
    else Result := cSocksUnknown;
  end;
end;

function TclSocks4NetworkStream.ParseResponse(const ACommand: TclByteArray): Boolean;
var
  len: Integer;
begin
  Result := True;  
  len := Length(ACommand);
  if(len < 8) then
  begin
    Result := False;  
    SetNextAction(saRead);
  end else
  if ((ACommand[0] <> 0) or (ACommand[1] <> 90)) then
  begin
    raise EclSocksFirewallError.Create(GetSocksErrorMessage(ACommand[1]), ACommand[1]);
  end else
  begin
    State := csOpenSession;
    StreamReady();
  end;
end;

{ TclSocks5NetworkStream }

procedure TclSocks5NetworkStream.BuildHello(var ACommand: TclByteArray);
var
  ind: Integer;
begin
  SetLength(ACommand, 1024);
  ind := 0;
  ACommand[ind] := 5; //VER
  Inc(ind);
  ACommand[ind] := 1; //NMETHODS
  Inc(ind);

  if (UserName <> '') then
  begin
    ACommand[ind] := 2; //USERNAME/PASSWORD
    Inc(ind);
  end else
  begin
    ACommand[ind] := 0; //NO AUTH
    Inc(ind);
  end;

  SetLength(ACommand, ind);
  FBytesToRead := 2;
end;

function TclSocks5NetworkStream.Connect(Addr_: TclIPAddress; APort: Integer): Boolean;
begin
  FBytesToRead := 0;
  Result := inherited Connect(Addr_, APort);
end;

procedure TclSocks5NetworkStream.BuildAuthenticate(var ACommand: TclByteArray);
var
  ind: Integer;
begin
  SetLength(ACommand, 1024);
  ind := 0;
  ACommand[ind] := 1; //VER
  Inc(ind);

  ByteArrayWriteStringVar(UserName, ACommand, ind);
  ByteArrayWriteStringVar(Password, ACommand, ind);

  SetLength(ACommand, ind);
  FBytesToRead := 2;
end;

procedure TclSocks5NetworkStream.BuildConnect(var ACommand: TclByteArray);
var
  ind: Integer;
begin
  SetLength(ACommand, 1024);
  ind := 0;
  ACommand[ind] := 5; //VER
  Inc(ind);
  ACommand[ind] := 1; //CONNECT
  Inc(ind);
  ACommand[ind] := 0; //RSV
  Inc(ind);

  if not TclIPAddress4.IsHostIP(TargetServer) then//TODO ipv6 support
  begin
    ACommand[ind] := 3; //DOMAIN
    Inc(ind);
    ByteArrayWriteStringVar(TargetServer, ACommand, ind);
  end else
  begin
    ACommand[ind] := 1; //IP
    Inc(ind);
    ByteArrayWriteIP(TargetServer, ACommand, ind);
  end;

  ByteArrayWriteWord(TargetPort, ACommand, ind);

  SetLength(ACommand, ind);
  FBytesToRead := 10;
end;

procedure TclSocks5NetworkStream.BuildCommand(var ACommand: TclByteArray);
begin
  case FState of
    csHello: BuildHello(ACommand);
    csAuthenticate: BuildAuthenticate(ACommand);
    csCommand: BuildConnect(ACommand)
  else
    Assert(False);
  end;
end;

function TclSocks5NetworkStream.GetBytesToRead: Integer;
begin
  Result := FBytesToRead;
end;

function TclSocks5NetworkStream.GetSocksErrorMessage(AErrorCode: Integer): string;
begin
  case AErrorCode of
    0: Result := cSocks5Succeeded;
    1: Result := cSocks5Failure;
    2: Result := cSocks5Denied;
    3: Result := cSocks5NetworkError;
    4: Result := cSocks5HostError;
    5: Result := cSocks5ConnectionError;
    6: Result := cSocks5Timeout;
    7: Result := cSocks5CommandError;
    8: Result := cSocks5AddressError
  else
    Result := cSocksUnknown;
  end;
end;

function TclSocks5NetworkStream.ParseHello(const ACommand: TclByteArray): Boolean;
var
  len: Integer;
begin
  Result := True;
  len := Length(ACommand);
  if(len < GetBytesToRead()) then
  begin
    Result := False;
    SetNextAction(saRead);
  end else
  if ((ACommand[0] = 5) and (ACommand[1] = 0)) then
  begin
    State := csCommand;
    SetNextAction(saWrite);
  end else
  if ((ACommand[0] = 5) and (ACommand[1] = 2)) then
  begin
    State := csAuthenticate;
    SetNextAction(saWrite);
  end else
  begin
    raise EclSocksFirewallError.Create(cSocks5AuthMethodError, ACommand[1]);
  end;
end;

function TclSocks5NetworkStream.ParseAuthenticate(const ACommand: TclByteArray): Boolean;
var
  len: Integer;
begin
  Result := True;
  len := Length(ACommand);
  if(len < GetBytesToRead()) then
  begin
    Result := False;
    SetNextAction(saRead);
  end else
  if ((ACommand[0] = 1) and (ACommand[1] = 0)) then
  begin
    State := csCommand;
    SetNextAction(saWrite);
  end else
  begin
    raise EclSocksFirewallError.Create(cSocks5AuthError, ACommand[1]);
  end;
end;

function TclSocks5NetworkStream.ParseCommand(const ACommand: TclByteArray): Boolean;
var
  len: Integer;
begin
  Result := True;
  len := Length(ACommand);
  if(len < GetBytesToRead()) then
  begin
    Result := False;
    SetNextAction(saRead);
  end else
  if ((ACommand[0] <> 5) or (ACommand[1] <> 0)) then
  begin
    raise EclSocksFirewallError.Create(GetSocksErrorMessage(ACommand[1]), ACommand[1]);
  end else
  begin
    Assert(ACommand[3] = 1);
    State := csOpenSession;
    StreamReady();
  end;
end;

function TclSocks5NetworkStream.ParseResponse(const ACommand: TclByteArray): Boolean;
begin
  Result := True;
  case FState of
    csHello: Result := ParseHello(ACommand);
    csAuthenticate: Result := ParseAuthenticate(ACommand);
    csCommand: Result := ParseCommand(ACommand)
  else
    Assert(False);
  end;
end;

end.
