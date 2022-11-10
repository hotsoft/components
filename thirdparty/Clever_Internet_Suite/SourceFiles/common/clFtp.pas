{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clFtp;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  SysUtils, Classes, SyncObjs,
{$ELSE}
  System.SysUtils, System.Classes, System.SyncObjs,
{$ENDIF}
  clTcpClient, clTcpClientTls, clTcpCommandClient, clUtils, clFtpUtils, clSocket, clCertificate,
  clSocketUtils, clTranslator;

type
  EclFtpError = class(EclTcpClientError);

  TclDirectoryListingEvent = procedure(Sender: TObject; AFileInfo: TclFtpFileInfo;
    const Source: string) of object;

  TclFtpFileNameEncoding = (feAutoDetect, feUseUtf8, feUseCharSet);

  TclFtp = class(TclTcpCommandClient)
  private
    FPassiveMode: Boolean;
    FTransferMode: TclFtpTransferMode;
    FTransferStructure: TclFtpTransferStructure;
    FTransferType: TclFtpTransferType;
    FDataConnection: TclTcpConnection;
    FProxySettings: TclFtpProxySettings;
    FDataAccessor: TCriticalSection;
    FResourcePos: Int64;
    FResponsePos: Integer;
    FDataProtection: Boolean;
    FDataPortBegin: Integer;
    FDataPortEnd: Integer;

    FOnCustomFtpProxy : TNotifyEvent;
    FOnDirectoryListing: TclDirectoryListingEvent;
    FExtensions: TStrings;
    FDataHost: string;
    FFileNameEncoding: TclFtpFileNameEncoding;
    FUtf8Allowed: Boolean;

    procedure BeginAccess;
    procedure EndAccess;
    function GetCurrentDir: string;
    procedure SetPassiveMode(const Value: Boolean);
    procedure SetDataProtection(const Value: Boolean);
    procedure SetTransferMode(const Value: TclFtpTransferMode);
    procedure SetTransferStructure(const Value: TclFtpTransferStructure);
    procedure SetProxySettings(const Value: TclFtpProxySettings);
    procedure SetTransferType(const Value: TclFtpTransferType);
    procedure SetDataPortBegin(const Value: Integer);
    procedure SetDataPortEnd(const Value: Integer);
    procedure SetDataHost(const Value: string);
    procedure SetFileNameEncoding(const Value: TclFtpFileNameEncoding);

    function ParseFileSize: Int64;
    function ParseFileDate: TDateTime;
    function GetFtpHost: string;
    function GetLoginPassword: string;
    procedure DoDataProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
    procedure ParseDirectoryListing(AList: TStrings);
    procedure SetDataPortMode(const AServer: string; ADataPort: Integer);
    procedure SetTransferParams;
    procedure SetPositionIfNeed;
    procedure WaitingMultipleResponses(const AOkResponses: array of Integer);
    procedure ClearResponse;
    procedure SetDataPassiveMode(var AHost: string; var ADataPort: Integer);
    procedure ParsePassiveModeResponse(var AHost: string; var ADataPort: Integer);
    procedure OpenServerConnection(ADataConnection: TclTcpServerConnection; var ADataHost: string; var ADataPort: Integer);
    procedure InternalGetData(const ACommand: string; ADestination: TStream; AMaxReadSize, ADataSize: Int64);
    procedure InternalPutData(const ACommand: string; ASource: TStream; AMaxWriteSize: Int64);
    procedure InternalFxpOperation(const APutMethod, ASourceFile, ADestinationFile: string;
      ASourceSite, ADestinationSite: TclFtp);
    function GetFileSizeIfNeed(const AFileName: string): Int64;
    procedure GetExtensions;
  protected
    procedure DoDestroy; override;
    procedure InitPassiveConnection(ADataConnection: TclTcpConnection; ADataSize: Int64;
      const ATargetServer: string; ATargetPort: Integer); virtual;
    procedure InitPortConnection(ADataConnection: TclTcpConnection; ADataSize: Int64); virtual;
    procedure SetUtf8Allowed(Value: Boolean); virtual;
    function GetDefaultPort: Integer; override;
    function GetResponseCode(const AResponse: string): Integer; override;
    procedure OpenConnection(const AServer: string; APort: Integer); override;
    procedure OpenSession; override;
    procedure CloseSession; override;
    procedure InternalSendCommandSync(const ACommand: string; const AOkResponses: array of Integer); override;
    procedure SendKeepAlive; override;
    procedure SetUseTLS(const Value: TclClientTlsMode); override;
    function GetWriteCharSet(const AText: string): string; override;
    function GetReadCharSet(AStream: TStream): string; override;

    procedure DoCustomFtpProxy; dynamic;
    procedure DoDirectoryListing(AFileInfo: TclFtpFileInfo; const Source: string); dynamic;
  public
    constructor Create(AOwner: TComponent); override;

    procedure StartTls; override;
    procedure GetList(AList: TStrings; const AParam: string = ''; ADetails: Boolean = True);
    procedure DirectoryListing(const AParam: string = '');
    procedure GetHelp(AHelp: TStrings; const ACommand: string = '');
    function GetFileSize(const AFileName: string): Int64;
    function FileExists(const AFileName: string): Boolean;
    function GetFileDate(const AFileName: string): TDateTime;

    procedure GetFile(const ASourceFile, ADestinationFile: string); overload;
    procedure GetFile(const ASourceFile: string; ADestination: TStream); overload;
    procedure GetFile(const ASourceFile: string; ADestination: TStream; APosition, ASize: Int64); overload;

    procedure PutFile(const ASourceFile, ADestinationFile: string); overload;
    procedure PutFile(ASource: TStream; const ADestinationFile: string); overload;
    procedure PutFile(ASource: TStream; const ADestinationFile: string; APosition, ASize: Int64); overload;
    procedure AppendFile(ASource: TStream; const ADestinationFile: string);
    procedure PutUniqueFile(ASource: TStream);

    procedure FxpGetFile(const ASourceFile, ADestinationFile: string; ADestinationSite: TclFtp);
    procedure FxpPutFile(const ASourceFile, ADestinationFile: string; ASourceSite: TclFtp);
    procedure FxpAppendFile(const ASourceFile, ADestinationFile: string; ASourceSite: TclFtp);
    procedure FxpPutUniqueFile(const ASourceFile: string; ASourceSite: TclFtp);

    procedure Rename(const ACurrentName, ANewName: string);
    procedure Delete(const AFileName: string);
    procedure ChangeCurrentDir(const ANewDir: string);
    procedure ChangeToParentDir;
    procedure MakeDir(const ANewDir: string);
    procedure RemoveDir(const ADir: string);
    procedure Abort;
    procedure Noop;
    procedure SetFilePermissions(const AFileName: string; AOwner, AGroup, AOther: TclFtpFilePermissions);

    property DataAccessor: TCriticalSection read FDataAccessor write FDataAccessor;
    property CurrentDir: string read GetCurrentDir;
    property Extensions: TStrings read FExtensions;
    property Utf8Allowed: Boolean read FUtf8Allowed;
  published
    property Port default DefaultFtpPort;
    property TransferMode: TclFtpTransferMode read FTransferMode write SetTransferMode default tmStream;
    property TransferStructure: TclFtpTransferStructure read FTransferStructure
      write SetTransferStructure default tsFile;
    property PassiveMode: Boolean read FPassiveMode write SetPassiveMode default False;
    property TransferType: TclFtpTransferType read FTransferType write SetTransferType default ttBinary;
    property ProxySettings: TclFtpProxySettings read FProxySettings write SetProxySettings;
    property DataProtection: Boolean read FDataProtection write SetDataProtection default False;
    property DataPortBegin: Integer read FDataPortBegin write SetDataPortBegin default 0;
    property DataPortEnd: Integer read FDataPortEnd write SetDataPortEnd default 0;
    property DataHost: string read FDataHost write SetDataHost;
    property FileNameEncoding: TclFtpFileNameEncoding read FFileNameEncoding write SetFileNameEncoding default feAutoDetect;

    property OnCustomFtpProxy: TNotifyEvent read FOnCustomFtpProxy write FOnCustomFtpProxy;
    property OnDirectoryListing: TclDirectoryListingEvent read FOnDirectoryListing write FOnDirectoryListing;
  end;

resourcestring
  CustomFtpProxyRequired = 'The OnCustomFtpProxy event handler required';

const
  CustomFtpProxyRequiredCode = -200;
  
implementation

uses
{$IFNDEF DELPHIXE2}
  {$IFDEF DEMO}Forms, Windows,{$ENDIF}
{$ELSE}
  {$IFDEF DEMO}Vcl.Forms, Winapi.Windows,{$ENDIF}
{$ENDIF}
  clIPAddress, clTlsSocket{$IFDEF LOGGER}, clLogger{$ENDIF};

const
  Modes: array[TclFtpTransferMode] of string = ('B', 'C', 'S', 'Z');
  Structures: array[TclFtpTransferStructure] of string = ('F', 'R', 'P');
  TransferTypes: array[TclFtpTransferType] of string = ('A', 'I');
  ProtectionLevels: array[Boolean] of string = ('C', 'P');

{ TclFtp }

constructor TclFtp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FProxySettings := TclFtpProxySettings.Create();
  FExtensions := TStringList.Create();
  
  FTransferMode := tmStream;
  FTransferStructure := tsFile;
  FPassiveMode := False;
  FTransferType := ttBinary;
  FDataProtection := False;
  FDataPortBegin := 0;
  FDataPortEnd := 0;

  FFileNameEncoding := feAutoDetect;
  FUtf8Allowed := False;
end;

function TclFtp.GetReadCharSet(AStream: TStream): string;
begin
  Result := inherited GetReadCharSet(AStream);

  if (Utf8Allowed) then
  begin
    case FileNameEncoding of
      feAutoDetect:
        begin
          if TclTranslator.IsUtf8(AStream) then
          begin
            Result := 'UTF-8';
          end;
        end;
      feUseUtf8: Result := 'UTF-8';
    end;
  end;
end;

function TclFtp.GetWriteCharSet(const AText: string): string;
begin
  Result := inherited GetWriteCharSet(AText);

  if (Utf8Allowed) then
  begin
    case FileNameEncoding of
      feAutoDetect: Result := 'UTF-8';
      feUseUtf8: Result := 'UTF-8';
    end;
  end;
end;

function TclFtp.GetResponseCode(const AResponse: string): Integer;
var
  code: string;
begin
  if (Length(AResponse) > 3) and (AResponse[4] = '-') then
  begin
    Result := SOCKET_WAIT_RESPONSE;
  end else
  if (Length(AResponse) > 2) then
  begin
    code := System.Copy(AResponse, 1, 3);
    code := StringReplace(code, #32, 'z', [rfReplaceAll]);
    code := StringReplace(code, #9, 'z', [rfReplaceAll]);
    code := StringReplace(code, #13#10, 'z', [rfReplaceAll]);
    Result := StrToIntDef(code, SOCKET_WAIT_RESPONSE);
  end else
  begin
    Result := SOCKET_WAIT_RESPONSE;
  end;
end;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

procedure TclFtp.OpenConnection(const AServer: string; APort: Integer);
begin
  if ((ProxySettings.ProxyType <> ptNone) and (ProxySettings.Server <> '')) then
  begin
    inherited OpenConnection(ProxySettings.Server, ProxySettings.Port);
  end else
  begin
    inherited OpenConnection(AServer, APort);
  end;
end;

procedure TclFtp.StartTls;
begin
  SendCommandSync('AUTH TLS', [234]);
  inherited StartTls();
end;

procedure TclFtp.OpenSession;
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
    if (not IsDemoDisplayed) and (not IsCertDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsDemoDisplayed := True;
    IsCertDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  FExtensions.Clear();
  
  WaitResponse([220]);

  //TODO will not work when connecting to ssl server via proxy
  ExplicitStartTls();
  
  case ProxySettings.ProxyType of
    ptNone:
      begin
        SendCommandSync('USER %s', [230, 232, 331], [UserName]);
        if (LastResponseCode = 331) then
        begin
          SendCommandSync('PASS %s', [230], [Password]);
        end;
      end;
    ptUserSite:
      begin
        if (ProxySettings.UserName <> '') then
        begin
          SendCommandSync('USER %s', [230, 331], [ProxySettings.UserName]);
          if (LastResponseCode = 331) then
          begin
            SendCommandSync('PASS %s', [230], [ProxySettings.Password]);
          end;
        end;
        SendCommandSync('USER %s@%s', [230, 232, 331], [UserName, GetFtpHost()]);
        if (LastResponseCode = 331) then
        begin
          SendCommandSync('PASS %s', [230], [GetLoginPassword()]);
        end;
      end;
    ptSite:
      begin
        if (ProxySettings.UserName <> '') then
        begin
          SendCommandSync('USER %s', [230, 331], [ProxySettings.UserName]);
          if (LastResponseCode = 331) then
          begin
            SendCommandSync('PASS %s', [230], [ProxySettings.Password]);
          end;
        end;
        SendCommandSync('SITE %s', [220], [GetFtpHost()]);
        SendCommandSync('USER %s', [230, 232, 331], [UserName]);
        if (LastResponseCode = 331) then
        begin
          SendCommandSync('PASS %s', [230], [GetLoginPassword()]);
        end;
      end;
    ptOpen:
      begin
        if (ProxySettings.UserName <> '') then
        begin
          SendCommandSync('USER %s', [230, 331], [ProxySettings.UserName]);
          if (LastResponseCode = 331) then
          begin
            SendCommandSync('PASS %s', [230], [GetLoginPassword()]);
          end;
        end;
        SendCommandSync('OPEN %s', [220], [GetFtpHost()]);
        SendCommandSync('USER %s', [230, 232, 331], [UserName]);
        if (LastResponseCode = 331) then
        begin
          SendCommandSync('PASS %s', [230], [GetLoginPassword()]);
        end;
      end;
    ptUserPass:
      begin
        SendCommandSync('USER %s@%s@%s', [230, 232, 331], [UserName, ProxySettings.UserName, GetFtpHost()]);
        if (LastResponseCode = 331) then
        begin
          if (ProxySettings.Password <> '') then
          begin
            SendCommandSync('PASS %s@%s', [230], [GetLoginPassword(), ProxySettings.Password]);
          end else
          begin
             SendCommandSync('PASS %s', [230], [GetLoginPassword()]);
          end;
        end;
      end;
    ptTransparent:
      begin
        if (ProxySettings.UserName <> '') then
        begin
          SendCommandSync('USER %s', [230, 331], [ProxySettings.UserName]);
          if (LastResponseCode = 331) then
          begin
            SendCommandSync('PASS %s', [230], [ProxySettings.Password]);
          end;
        end;
        SendCommandSync('USER %s', [230, 232, 331], [UserName]);
        if (LastResponseCode = 331) then
        begin
          SendCommandSync('PASS %s', [230], [GetLoginPassword()]);
        end;
      end;
    ptAccount:
      begin
        SendCommandSync('USER %s', [230, 232, 331], [UserName]);
        if (LastResponseCode = 331) then
        begin
          SendCommandSync('PASS %s', [230, 330], [Password]);
        end;
        if (ProxySettings.Password <> '') then
        begin
          SendCommandSync('ACCT %s', [230], [ProxySettings.Password]);
        end;
      end;
    ptCustomProxy:
      begin
        DoCustomFtpProxy();
      end;
  end;

  GetExtensions();
end;

procedure TclFtp.SetUtf8Allowed(Value: Boolean);
begin
  FUtf8Allowed := Value;
end;

procedure TclFtp.CloseSession;
begin
  FExtensions.Clear();
  SetUtf8Allowed(False);
  SendSilentCommand('QUIT', [220, 221]);
end;

procedure TclFtp.GetHelp(AHelp: TStrings; const ACommand: string);
var
  s: string;
begin
  s := Trim(ACommand);
  if (s <> '') then
  begin
    s := ' ' + s;
  end;
  
  SendCommandSync('HELP' + s, [211, 214]);
  AHelp.Assign(Response);
  if (AHelp.Count > 0) and (System.Pos('HELP', AHelp[AHelp.Count - 1]) > 0) then
  begin
    AHelp.Delete(AHelp.Count - 1);
  end;
end;

procedure TclFtp.ChangeCurrentDir(const ANewDir: string);
begin
  SendCommandSync('CWD %s', [200, 250], [ANewDir]);
end;

procedure TclFtp.ChangeToParentDir;
begin
  SendCommandSync('CDUP', [200, 250]);
end;

procedure TclFtp.MakeDir(const ANewDir: string);
begin
  SendCommandSync('MKD %s', [257, 250], [ANewDir]);
end;

procedure TclFtp.RemoveDir(const ADir: string);
begin
  SendCommandSync('RMD %s', [250], [ADir]);
end;

procedure TclFtp.ParseDirectoryListing(AList: TStrings);
var
  i: Integer;
  info: TclFtpFileInfo;
begin
  info := TclFtpFileInfo.Create();
  try
    for i := 0 to AList.Count - 1 do
    begin
      info.Parse(AList[i]);
      DoDirectoryListing(info, AList[i]);
    end;
  finally
    info.Free();
  end;
end;

procedure TclFtp.GetList(AList: TStrings; const AParam: string;
  ADetails: Boolean);
var
  s: string;
  stream: TStream;
begin
  stream := TMemoryStream.Create();
  try
    FResourcePos := 0;

    s := Trim(AParam);
    if (s <> '') then
    begin
      s := ' ' + s;
    end;

    if (ADetails) then
    begin
      InternalGetData('LIST' + s, stream, -1, 0);
    end else
    begin
      InternalGetData('NLST' + s, stream, -1, 0);
    end;

    stream.Position := 0;
    TclStringsUtils.LoadStrings(stream, AList, GetReadCharSet(stream));
  finally
    stream.Free();
  end;
end;

function TclFtp.GetCurrentDir: string;
var
  ind: Integer;
  s: string;
begin
  Result := '';
  SendCommandSync('PWD', [257]);
  ind := System.Pos('"', Response.Text);
  if (ind > 0) then
  begin
    s := System.Copy(Response.Text, ind + 1, 1000);
    ind := System.Pos('"', s);
    if (ind > 0) then
    begin
      Result := System.Copy(s, 1, ind - 1);
    end;
  end;
end;

procedure TclFtp.SetPassiveMode(const Value: Boolean);
begin
  if (FPassiveMode <> Value) then
  begin
    FPassiveMode := Value;
    Changed();
  end;
end;

procedure TclFtp.SetTransferMode(const Value: TclFtpTransferMode);
begin
  if (FTransferMode <> Value) then
  begin
    FTransferMode := Value;
    Changed();
  end;
end;

procedure TclFtp.SetTransferStructure(
  const Value: TclFtpTransferStructure);
begin
  if (FTransferStructure <> Value) then
  begin
    FTransferStructure := Value;
    Changed();
  end;
end;

procedure TclFtp.SetDataPortBegin(const Value: Integer);
begin
  if (FDataPortBegin <> Value) then
  begin
    FDataPortBegin := Value;
    Changed();
  end;
end;

procedure TclFtp.SetDataPortEnd(const Value: Integer);
begin
  if (FDataPortEnd <> Value) then
  begin
    FDataPortEnd := Value;
    Changed();
  end;
end;

procedure TclFtp.SetDataPortMode(const AServer: string; ADataPort: Integer);
begin
  SendCommandSync('PORT ' + GetFtpHostStr(AServer, ADataPort), [200]);
end;

procedure TclFtp.SetTransferParams;
begin
  SendSilentCommand('MODE %s', [200, 500, 502], [Modes[TransferMode]]);
  SendSilentCommand('STRU %s', [200, 500, 502], [Structures[TransferStructure]]);
  SendSilentCommand('TYPE %s', [200, 500, 502], [TransferTypes[TransferType]]);

  if (UseTLS <> ctNone) then
  begin
    SendSilentCommand('PBSZ 0', [200]);
    SendSilentCommand('PROT %s', [200], [ProtectionLevels[DataProtection]]);
  end;
end;

procedure TclFtp.InitPassiveConnection(ADataConnection: TclTcpConnection; ADataSize: Int64;
  const ATargetServer: string; ATargetPort: Integer);
var
  stream: TclNetworkStream;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'InitPassiveConnection');{$ENDIF}
  if (UseTLS <> ctNone) and DataProtection then
  begin
    stream := GetTlsStream();
  end else
  begin
    stream := TclNetworkStream.Create();
  end;

  if (FirewallSettings.Server <> '') then
  begin
    ADataConnection.NetworkStream := GetFirewallStream(stream, ATargetServer, ATargetPort);
  end else
  begin
    ADataConnection.NetworkStream := stream;
  end;

  ADataConnection.TimeOut := TimeOut;
  ADataConnection.BatchSize := BatchSize;
  ADataConnection.BitsPerSec := BitsPerSec;
  ADataConnection.IsReadUntilClose := True;
  ADataConnection.OnProgress := DoDataProgress;
  ADataConnection.InitProgress(FResourcePos, ADataSize);
  ADataConnection.LocalBinding := Connection.IP;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'InitPassiveConnection'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'InitPassiveConnection', E); raise; end; end;{$ENDIF}
end;

procedure TclFtp.InitPortConnection(ADataConnection: TclTcpConnection; ADataSize: Int64);
begin
  if (UseTLS <> ctNone) and DataProtection then
  begin
    ADataConnection.NetworkStream := GetTlsStream();
  end else
  begin
    ADataConnection.NetworkStream := TclNetworkStream.Create();
  end;

  ADataConnection.TimeOut := TimeOut;
  ADataConnection.BatchSize := BatchSize;
  ADataConnection.BitsPerSec := BitsPerSec;
  ADataConnection.IsReadUntilClose := True;
  ADataConnection.OnProgress := DoDataProgress;
  ADataConnection.InitProgress(FResourcePos, ADataSize);
  ADataConnection.LocalBinding := Connection.IP;
end;

procedure TclFtp.DoDataProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
begin
  DoProgress(ABytesProceed, ATotalBytes);
end;

procedure TclFtp.DoDestroy;
begin
  FExtensions.Free();
  FProxySettings.Free();

  inherited DoDestroy();
end;

procedure TclFtp.SetPositionIfNeed;
begin
  if (FResourcePos > 0) then
  begin
    SendCommandSync('REST %d', [350], [FResourcePos]);
  end;
end;

procedure TclFtp.OpenServerConnection(ADataConnection: TclTcpServerConnection; var ADataHost: string; var ADataPort: Integer);
begin
  if (DataPortBegin = 0) or (DataPortEnd = 0) then
  begin
    ADataPort := ADataConnection.Listen(0);
  end else
  begin
    ADataPort := ADataConnection.Listen(DataPortBegin, DataPortEnd);
  end;

  ADataHost := DataHost;
  if (ADataHost = '') then
  begin
    ADataHost := ADataConnection.LocalBinding;
  end;
end;

procedure TclFtp.InternalGetData(const ACommand: string; ADestination: TStream; AMaxReadSize, ADataSize: Int64);
var
  dataIP: string;
  dataPort: Integer;
begin
  SetTransferParams();
  try
    if PassiveMode then
    begin
      FDataConnection := TclTcpClientConnection.Create();

      SetDataPassiveMode(dataIP, dataPort);
      InitPassiveConnection(FDataConnection, ADataSize, dataIP, dataPort);

      SetPositionIfNeed();

      ClearResponse();
      SendCommand(ACommand);

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalGetData before opening the data connection');{$ENDIF}

      try
        if (FirewallSettings.Server <> '') then
        begin
          TclTcpClientConnection(FDataConnection).Open(TclHostResolver.GetIPAddress(FirewallSettings.Server), FirewallSettings.Port);
        end else
        begin
          TclTcpClientConnection(FDataConnection).Open(dataIP, dataPort);
        end;
      finally
        WaitingMultipleResponses([125, 150, 154]);
      end;
    end else
    begin
      FDataConnection := TclTcpServerConnection.Create();
      InitPortConnection(FDataConnection, ADataSize);

      OpenServerConnection(TclTcpServerConnection(FDataConnection), dataIP, dataPort);

      SetDataPortMode(dataIP, dataPort);

      SetPositionIfNeed();

      ClearResponse();
      SendCommand(ACommand);
      WaitingMultipleResponses([125, 150, 154]);
      TclTcpServerConnection(FDataConnection).Accept();
    end;

{$IFDEF LOGGER}
  if not FDataConnection.Active then
    clPutLogMessage(Self, edInside, 'InternalGetData: FDataConnection.Active = False');
{$ENDIF}
    if FDataConnection.Active or FDataConnection.NetworkStream.HasReadData then
    begin
      BeginAccess();
      try
        ADestination.Position := FResourcePos;
        FDataConnection.BytesToProceed := AMaxReadSize;
        FDataConnection.ReadData(ADestination);
        FResourcePos := ADestination.Position;
      finally
        EndAccess();
      end;
    end;

    if not FDataConnection.IsAborted and (AMaxReadSize > -1) then
    begin
      SendCommand('ABOR');
    end;

    if FDataConnection.Active then
    begin
      FDataConnection.Close(True);
    end;

    WaitingMultipleResponses([225, 226, 250, 426, 450]);
    if (FDataConnection.IsAborted and (LastResponseCode = 226)) then
    begin
      WaitingMultipleResponses([225, 226]);
    end else
    if (LastResponseCode = 426) or (LastResponseCode = 450) then
    begin
      WaitingMultipleResponses([225, 226]);
    end;
  finally
    FDataConnection.Free();
    FDataConnection := nil;
  end;
end;

procedure TclFtp.GetFile(const ASourceFile: string; ADestination: TStream);
begin
  BeginAccess();
  try
    FResourcePos := ADestination.Position;
  finally
    EndAccess();
  end;
  InternalGetData(Format('RETR %s', [ASourceFile]), ADestination, -1, GetFileSizeIfNeed(ASourceFile));
end;

procedure TclFtp.PutFile(ASource: TStream; const ADestinationFile: string);
begin
  FResourcePos := 0;
  InternalPutData('STOR ' + ADestinationFile, ASource, -1);
end;

procedure TclFtp.AppendFile(ASource: TStream; const ADestinationFile: string);
begin
  FResourcePos := 0;
  InternalPutData('APPE ' + ADestinationFile, ASource, -1);
end;

procedure TclFtp.PutUniqueFile(ASource: TStream);
begin
  FResourcePos := 0;
  InternalPutData('STOU', ASource, -1);
end;

procedure TclFtp.Rename(const ACurrentName, ANewName: string);
begin
  SendCommandSync('RNFR %s', [350], [ACurrentName]);
  SendCommandSync('RNTO %s', [250], [ANewName]);
end;

procedure TclFtp.Delete(const AFileName: string);
begin
  SendCommandSync('DELE %s', [250], [AFileName]);
end;

function TclFtp.GetFileSize(const AFileName: string): Int64;
begin
  SendCommandSync('TYPE %s', [200], [TransferTypes[TransferType]]);
  SendCommandSync('SIZE %s', [213], [AFileName]);
  Result := ParseFileSize();
end;

function TclFtp.ParseFileSize: Int64;
var
  s: string;
begin
  s := Trim(Copy(Response.Text, 4, 1000));
  Result := StrToInt64Def(s, -1);
end;

procedure TclFtp.InternalPutData(const ACommand: string; ASource: TStream; AMaxWriteSize: Int64);
var
  dataIP: string;
  dataPort: Integer;
begin
  SetTransferParams();
  try
    if PassiveMode then
    begin
      FDataConnection := TclTcpClientConnection.Create();

      SetDataPassiveMode(dataIP, dataPort);
      InitPassiveConnection(FDataConnection, ASource.Size, dataIP, dataPort);

      SetPositionIfNeed();

      ClearResponse();
      SendCommand(ACommand);

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'InternalPutData before opening the data connection');{$ENDIF}

      try
        if (FirewallSettings.Server <> '') then
        begin
          TclTcpClientConnection(FDataConnection).Open(TclHostResolver.GetIPAddress(FirewallSettings.Server), FirewallSettings.Port);
        end else
        begin
          TclTcpClientConnection(FDataConnection).Open(dataIP, dataPort);
        end;
      finally
        WaitingMultipleResponses([110, 125, 150]);
      end;
    end else
    begin
      FDataConnection := TclTcpServerConnection.Create();
      InitPortConnection(FDataConnection, ASource.Size);

      OpenServerConnection(TclTcpServerConnection(FDataConnection), dataIP, dataPort);

      SetDataPortMode(dataIP, dataPort);

      SetPositionIfNeed();

      ClearResponse();
      SendCommand(ACommand);
      WaitingMultipleResponses([110, 125, 150]);
      TclTcpServerConnection(FDataConnection).Accept();
    end;

{$IFDEF LOGGER}
  if not FDataConnection.Active then
    clPutLogMessage(Self, edInside, 'InternalGetData: FDataConnection.Active = False');
{$ENDIF}

    if FDataConnection.Active then
    begin
      BeginAccess();
      try
        ASource.Position := FResourcePos;
        FDataConnection.BytesToProceed := AMaxWriteSize;
        FDataConnection.WriteData(ASource);
        FResourcePos := ASource.Position;
      finally
        EndAccess();
      end;

      FDataConnection.Close(True);
    end;

    WaitingMultipleResponses([225, 226, 250, 426, 450]);
    if (FDataConnection.IsAborted and (LastResponseCode = 226)) then
    begin
      WaitingMultipleResponses([226, 225]);
    end else
    if (LastResponseCode = 426) or (LastResponseCode = 450) then
    begin
      WaitingMultipleResponses([226, 225]);
    end;
  finally
    FDataConnection.Free();
    FDataConnection := nil;
  end;
end;

procedure TclFtp.SendKeepAlive;
begin
  Noop();
end;

procedure TclFtp.SetDataHost(const Value: string);
begin
  if (FDataHost <> Value) then
  begin
    FDataHost := Value;
    Changed();
  end;
end;

procedure TclFtp.SetDataPassiveMode(var AHost: string; var ADataPort: Integer);
var
  ip: string;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'SetDataPassiveMode');{$ENDIF}
  SendCommandSync('PASV', [227]);
  ParsePassiveModeResponse(AHost, ADataPort);

  if TclIPAddress4.IsPrivateUseIP(AHost) then
  begin
    try
      if ((ProxySettings.ProxyType <> ptNone) and (ProxySettings.Server <> '')) then
      begin
        ip := TclHostResolver.GetIPAddress(ProxySettings.Server);
        {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'SetDataPassiveMode, GetIPAddress(ProxySettings.Server)');{$ENDIF}
      end else
      begin
        ip := TclHostResolver.GetIPAddress(Server);
        {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'SetDataPassiveMode, GetIPAddress(Server)');{$ENDIF}
      end;

      if not TclIPAddress4.IsPrivateUseIP(ip) then
      begin
        AHost := ip;
      end;
    except
    {$IFNDEF LOGGER}
      on EclSocketError do;
    {$ELSE}
      on E: EclSocketError do
      begin
        clPutLogMessage(Self, edInside, 'SetDataPassiveMode socket error: %d', nil, [E.ErrorCode]);
      end;
    {$ENDIF}
    end;
  end;

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'SetDataPassiveMode, host: %s, port: %d', nil, [AHost, ADataPort]);{$ENDIF}

{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'SetDataPassiveMode'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'SetDataPassiveMode', E); raise; end; end;{$ENDIF}
end;

procedure TclFtp.ParsePassiveModeResponse(var AHost: string; var ADataPort: Integer);
var
  ind: Integer;
  s: string;
begin
  s := Trim(Response.Text);
  ind := TextPos('(', s);
  if (ind < 1) then
  begin
    ind := RTextPos(#32, s);
  end;
  s := system.Copy(s, ind + 1, 1000);
  ind := TextPos(')', s);
  if (ind > 0) then
  begin
    system.Delete(s, ind, 1000);
  end;

  ParseFtpHostStr(s, AHost, ADataPort);

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ParsePassiveModeResponse, host: %s, port: %d', nil, [AHost, ADataPort]);{$ENDIF}
end;

procedure TclFtp.SetTransferType(const Value: TclFtpTransferType);
begin
  if (FTransferType <> Value) then
  begin
    FTransferType := Value;
    Changed();
  end;
end;

procedure TclFtp.GetFile(const ASourceFile: string; ADestination: TStream; APosition, ASize: Int64);
begin
  BeginAccess();
  try
    if (ADestination.Size < (APosition + ASize)) then
    begin
      ADestination.Size := (APosition + ASize);
    end;
    FResourcePos := APosition;
  finally
    EndAccess();
  end;
  InternalGetData(Format('RETR %s', [ASourceFile]), ADestination, ASize, GetFileSizeIfNeed(ASourceFile));
end;

function TclFtp.ParseFileDate: TDateTime;
var
  datestr: string;
  y, m, d, h, n, s: Word;
  tt: TDateTime;
begin
  datestr := Trim(Copy(Response.Text, 4, 1000));

  if (Length(datestr) < 14) then
  begin
    Result := 0;
    Exit;
  end;

  y := StrToIntDef(Copy(datestr, 1, 4), 1980);
  m := StrToIntDef(Copy(datestr, 5, 2), 1);
  d := StrToIntDef(Copy(datestr, 7, 2), 1);
  h := StrToIntDef(Copy(datestr, 9, 2), 0);
  n := StrToIntDef(Copy(datestr, 11, 2), 0);
  s := StrToIntDef(Copy(datestr, 13, 2), 0);

  if not TryEncodeDate(y, m, d, Result) then
  begin
    Result := 0;
  end;
  if TryEncodeTime(h, n, s, 0, tt) then
  begin
    Result := Result + tt;
  end;
end;

function TclFtp.GetFileDate(const AFileName: string): TDateTime;
begin
  SendCommandSync('MDTM %s', [213], [AFileName]);
  Result := ParseFileDate();
end;

procedure TclFtp.GetFile(const ASourceFile, ADestinationFile: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(ADestinationFile, fmCreate);
  try
    GetFile(ASourceFile, stream);
  finally
    stream.Free();
  end;
end;

procedure TclFtp.Abort;
begin
  //check for FXP mode
  if Active and (FDataConnection <> nil) then
  begin
    SendCommand('ABOR');
    FDataConnection.Abort();
  end;
end;

procedure TclFtp.PutFile(ASource: TStream; const ADestinationFile: string; APosition, ASize: Int64);
const
  cmd: array[Boolean] of string = ('STOR ', 'APPE ');
begin
  FResourcePos := APosition;
  InternalPutData(cmd[(APosition > 0)] + ADestinationFile, ASource, ASize);
end;

procedure TclFtp.PutFile(const ASourceFile, ADestinationFile: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(ASourceFile, fmOpenRead or fmShareDenyWrite);
  try
    PutFile(stream, ADestinationFile);
  finally
    stream.Free();
  end;
end;

function TclFtp.FileExists(const AFileName: string): Boolean;
  function GetFtpFileName(const AFullName: string): string;
  var
    ind: Integer;
  begin
    ind := LastDelimiter('/\', AFullName);
    Result := system.Copy(AFullName, ind + 1, MaxInt);
  end;

var
  list: TStrings;
begin
  try
    SendCommandSync('TYPE %s', [200], [TransferTypes[TransferType]]);
    SendCommandSync('SIZE %s', [213, 550], [AFileName]);

    Result := (LastResponseCode <> 550);
  except
    on EclSocketError do
    begin
      list := TStringList.Create();
      try
        GetList(list, AFileName, False);
        Result := SameText(Trim(GetFtpFileName(list.Text)), Trim(GetFtpFileName(AFileName)));
      finally
        list.Free();
      end;
    end;
  end;
end;

procedure TclFtp.SetProxySettings(const Value: TclFtpProxySettings);
begin
  FProxySettings.Assign(Value);
end;

function TclFtp.GetFtpHost: string;
begin
  if (Port = DefaultFtpPort) then
  begin
    Result := Server;
  end else
  begin
    Result := Server + ':' + IntToStr(Port);
  end;
end;

function TclFtp.GetLoginPassword: string;
begin
  Result := Password;
end;

procedure TclFtp.DoCustomFtpProxy;
begin
  if Assigned(OnCustomFtpProxy) then
  begin
    OnCustomFtpProxy(Self);
  end else
  begin
    raise EclSocketError.Create(CustomFtpProxyRequired, CustomFtpProxyRequiredCode);
  end;
end;

procedure TclFtp.Noop;
begin
  SendCommandSync('NOOP', [200]);
end;

procedure TclFtp.DoDirectoryListing(AFileInfo: TclFtpFileInfo; const Source: string);
begin
  if Assigned(OnDirectoryListing) then
  begin
    OnDirectoryListing(Self, AFileInfo, Source);
  end;
end;

procedure TclFtp.DirectoryListing(const AParam: string);
var
  list: TStrings;
begin
  list := TStringList.Create();
  try
    GetList(list, AParam, True);
    ParseDirectoryListing(list);
  finally
    list.Free();
  end;
end;

procedure TclFtp.BeginAccess;
begin
  if (DataAccessor <> nil) then
  begin
    DataAccessor.Enter();
  end;
end;

procedure TclFtp.EndAccess;
begin
  if (DataAccessor <> nil) then
  begin
    DataAccessor.Leave();
  end;
end;

procedure TclFtp.FxpAppendFile(const ASourceFile, ADestinationFile: string;
  ASourceSite: TclFtp);
begin
  InternalFxpOperation('APPE', ASourceFile, ADestinationFile, ASourceSite, Self);
end;

procedure TclFtp.InternalFxpOperation(const APutMethod, ASourceFile, ADestinationFile: string;
  ASourceSite, ADestinationSite: TclFtp);
var
  cmd, dataIP: string;
  dataPort: Integer;
begin
  Assert(ASourceSite <> ADestinationSite);
  
  ASourceSite.SetTransferParams();
  ADestinationSite.SetTransferParams();

  if PassiveMode then
  begin
    ASourceSite.SetDataPassiveMode(dataIP, dataPort);
    ADestinationSite.SetDataPortMode(dataIP, dataPort);
  end else
  begin
    ADestinationSite.SetDataPassiveMode(dataIP, dataPort);
    ASourceSite.SetDataPortMode(dataIP, dataPort);
  end;

  ASourceSite.ClearResponse();
  ASourceSite.SendCommand('RETR ' + ASourceFile);
  ASourceSite.WaitingMultipleResponses([125, 150, 154]);

  cmd := ADestinationFile;
  if (cmd <> '') then
  begin
    cmd := #32 + cmd;
  end;
  cmd := APutMethod + cmd;
  ADestinationSite.ClearResponse();
  ADestinationSite.SendCommand(cmd);
  ADestinationSite.WaitingMultipleResponses([110, 125, 150]);

  ASourceSite.WaitingMultipleResponses([225, 226, 250, 426, 450]);

  if (ASourceSite.LastResponseCode = 426) or (ASourceSite.LastResponseCode = 450) then
  begin
    ASourceSite.WaitingMultipleResponses([225, 226]);
  end;

  ADestinationSite.WaitingMultipleResponses([225, 226, 250, 426, 450]);

  if (ADestinationSite.LastResponseCode = 426) or (ADestinationSite.LastResponseCode = 450) then
  begin
    ADestinationSite.WaitingMultipleResponses([225, 226]);
  end;
end;

procedure TclFtp.FxpGetFile(const ASourceFile, ADestinationFile: string;
  ADestinationSite: TclFtp);
begin
  InternalFxpOperation('STOR', ASourceFile, ADestinationFile, Self, ADestinationSite);
end;

procedure TclFtp.FxpPutFile(const ASourceFile, ADestinationFile: string;
  ASourceSite: TclFtp);
begin
  InternalFxpOperation('STOR', ASourceFile, ADestinationFile, ASourceSite, Self);
end;

procedure TclFtp.FxpPutUniqueFile(const ASourceFile: string; ASourceSite: TclFtp);
begin
  InternalFxpOperation('STOU', ASourceFile, '', ASourceSite, Self);
end;

function TclFtp.GetFileSizeIfNeed(const AFileName: string): Int64;
begin
  Result := 0;
  if Assigned(OnProgress) then
  begin
    try
      Result := GetFileSize(AFileName);
    except
      on EclSocketError do ;
    end;
  end;
end;

procedure TclFtp.SetUseTLS(const Value: TclClientTlsMode);
begin
  if (UseTLS <> Value) then
  begin
    if not (csLoading in ComponentState) then
    begin
      if (Value <> ctNone) then
      begin
        PassiveMode := True;
        DataProtection := True;
      end;
    end;
    
    inherited SetUseTLS(Value);
  end;
end;

function TclFtp.GetDefaultPort: Integer;
begin
  Result := DefaultFtpPort;
end;

procedure TclFtp.GetExtensions;
var
  i: Integer;
  s: string;
begin
  FExtensions.Clear();

  SendSilentCommand('FEAT', [211]);

  if (LastResponseCode = 211) then
  begin
    for i := 1 to Response.Count - 1 do
    begin
      s := Response[i];
      if (Pos('END', UpperCase(s)) > 0) then Break;
      FExtensions.Add(Trim(s));
    end;
  end;

  SetUtf8Allowed(FindInStrings(FExtensions, 'UTF8') > -1);
end;

procedure TclFtp.SetDataProtection(const Value: Boolean);
begin
  if (FDataProtection <> Value) then
  begin
    FDataProtection := Value;
    Changed();
  end;
end;

procedure TclFtp.SetFileNameEncoding(const Value: TclFtpFileNameEncoding);
begin
  if (FFileNameEncoding <> Value) then
  begin
    FFileNameEncoding := Value;
    Changed();
  end;
end;

procedure TclFtp.SetFilePermissions(const AFileName: string; AOwner,
  AGroup, AOther: TclFtpFilePermissions);
var
  perm: string;
begin
  perm := Format('%d%d%d',
    [GetFtpFilePermissionsInt(AOwner), GetFtpFilePermissionsInt(AGroup), GetFtpFilePermissionsInt(AOther)]);
  SendCommandSync('SITE CHMOD %s %s', [200], [perm, AFileName]);
end;

procedure TclFtp.InternalSendCommandSync(const ACommand: string;
  const AOkResponses: array of Integer);
var
  i: Integer;
  okResps: array of Integer;
begin
  SetLength(okResps, SizeOf(AOkResponses) + 1);
  okResps[0] := 225;

  for i := Low(AOkResponses) to High(AOkResponses) do
  begin
    okResps[i + 1] := AOkResponses[i];
  end;

  ClearResponse();
  SendCommand(ACommand);

  WaitingMultipleResponses(okResps);
  if (LastResponseCode = 225) then
  begin
    WaitingMultipleResponses(AOkResponses);
  end;
end;

procedure TclFtp.ClearResponse;
begin
  Response.Clear();
  FResponsePos := 0;
end;

procedure TclFtp.WaitingMultipleResponses(const AOkResponses: array of Integer);
var
  ind: Integer;
begin
  if (Response.Count > FResponsePos) then
  begin
    ind := ParseResponse(FResponsePos, AOkResponses);

    if (ind > -1) then
    begin
      FResponsePos := ind + 1;
    end else
    begin
      if not ((Length(AOkResponses) = 1) and (AOkResponses[Low(AOkResponses)] = SOCKET_DOT_RESPONSE))
        and (LastResponseCode <> SOCKET_WAIT_RESPONSE) then
      begin
        raise EclFtpError.Create(Trim(Response.Text), LastResponseCode);
      end;
      
      FResponsePos := InternalWaitResponse(FResponsePos, AOkResponses) + 1;
      DoReceiveResponse(Response);
    end;
  end else
  begin
    FResponsePos := InternalWaitResponse(FResponsePos, AOkResponses) + 1;
    DoReceiveResponse(Response);
  end;
end;

end.

