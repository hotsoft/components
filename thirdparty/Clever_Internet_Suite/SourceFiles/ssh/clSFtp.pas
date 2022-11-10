{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSFtp;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,{$IFDEF DEMO}Forms, Windows,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils,{$IFDEF DEMO}Vcl.Forms, Winapi.Windows,{$ENDIF}
{$ENDIF}
  clSocket, clTcpClient, clUtils, clSshSocket, clSshPacket, clConfig,
  clSshConfig, clTranslator, clSFtpUtils, clSshUserKey, clSshUserIdentity, clSshAuth;

type
  TclSFtpCommandEvent = procedure(Sender: TObject; AFxpCommand: Integer; ABuffer: TStream) of object;
  TclSFtpDirectoryListingEvent = procedure(Sender: TObject; const AFileName: string; AFileAttrs: TclSFtpFileAttrs) of object;

  TclSFtp = class(TclTcpClient)
  private
    FConfig: TclConfig;

    FRootDir: string;
    FCurrentDir: string;
    FServerVersion: Integer;
    FSshAgent: string;
    FPassword: string;
    FUserName: string;
    FUserKey: TclSshUserKey;
    FIdentity: TclSshUserIdentity;
    FRequestId: Integer;
    FResponseType: Integer;
    FStatusCode: Integer;
    FFileAttributes: TclSFtpFileAttrs;

    FPacket: TclPacket;

    FOnSendCommand: TclSFtpCommandEvent;
    FOnReceiveResponse: TclSFtpCommandEvent;
    FOnProgress: TclProgressEvent;
    FOnVerifyServer: TclVerifySshPeerEvent;
    FOnDirectoryListing: TclSFtpDirectoryListingEvent;
    FOnShowBanner: TclSshShowBannerEvent;

    procedure PutHEAD(AType: Byte; ALength: Integer);
    procedure SendINIT;
    procedure SendPathCommand(AFxp: Byte; const APath: TclByteArray; ASilent: Boolean); overload;
    procedure SendPathCommand(AFxp: Byte; const APath1, APath2: TclByteArray); overload;
    procedure SendREALPATH(const APath: TclByteArray);
    procedure SendOPEN(const APath: TclByteArray; AMode: Integer);
    procedure SendREAD(const AHandle: TclByteArray; AOffset: Int64; ALength: Integer);
    procedure SendWRITE(const AHandle: TclByteArray; AOffset: Int64; const AData: TclByteArray; AStart, ALength: Integer);
    procedure SendCLOSE(const APath: TclByteArray);
    procedure SendMKDIR(const APath: TclByteArray);
    procedure SendRMDIR(const APath: TclByteArray);
    procedure SendREMOVE(const APath: TclByteArray);
    procedure SendSTAT(const APath: TclByteArray; ASilent: Boolean);
    procedure SendSETSTAT(const APath: TclByteArray; Attr: TclSFtpFileAttrs);
    procedure SendREADLINK(const ALinkPath: TclByteArray);
    procedure SendOPENDIR(const APath: TclByteArray);
    procedure SendREADDIR(const APath: TclByteArray);
    procedure SendRENAME(const AOldPath, ANewPath: TclByteArray);
    procedure SendSYMLINK(const ALinkPath, ATargetPath: TclByteArray);

    function ReadPacket(ASource: TStream; APacket: TclPacket): Integer;
    procedure SetPassword(const Value: string);
    procedure SetUserName(const Value: string);
    procedure VerifyServer(Sender: TObject; const AHost, AKeyType, AFingerPrint, AHostKey: string; var AVerified: Boolean);
    procedure SetSshAgent(const Value: string);
    function GetFullPath(const APath: string): string;
    function GetResponse: Integer;
    procedure CheckError;
    function GetFileSizeIfNeed(const AFileName: string): Int64;
    function GetFileSizeSilent(const AFileName: string): Int64;
    procedure InternalPutData(ASource: TStream; const ADestinationFile: string; AOffset, ASize: Int64; AMode: Integer);
    procedure SetUserKey(const Value: TclSshUserKey);
    procedure DoChanged(Sender: TObject);
  protected
    function WritePacket(APack: TclPacket; AFxp: Integer; ASilent: Boolean): Integer;

    function CreateConfig: TclConfig; virtual;

    procedure OpenChannel; virtual;
    procedure CloseChannel; virtual;

    procedure DoSendCommand(AFxpCommand: Integer; ABuffer: TStream); dynamic;
    procedure DoReceiveResponse(AFxpCommand: Integer; ABuffer: TStream); dynamic;
    procedure DoProgress(ABytesProceed, ATotalBytes: Int64); dynamic;
    procedure DoVerifyServer(const AHost, AKeyType, AFingerPrint, AHostKey: string; var AVerified: Boolean); dynamic;
    procedure DoDirectoryListing(const AFileName: string; AFileAttrs: TclSFtpFileAttrs); dynamic;
    procedure DoShowBanner(const AMessage, ALanguage: string); dynamic;

    function GetNetworkStream: TclNetworkStream; override;
    procedure InternalOpen; override;
    procedure InternalClose(ANotifyPeer: Boolean); override;
    function GetDefaultPort: Integer; override;
    procedure DoDestroy; override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure ChangeCurrentDir(const ANewDir: string);
    procedure ChangeToParentDir;

    procedure GetFile(const ASourceFile, ADestinationFile: string); overload;
    procedure GetFile(const ASourceFile: string; ADestination: TStream); overload;
    procedure GetFile(const ASourceFile: string; ADestination: TStream; APosition, ASize: Int64); overload;

    procedure PutFile(const ASourceFile, ADestinationFile: string); overload;
    procedure PutFile(ASource: TStream; const ADestinationFile: string); overload;
    procedure PutFile(ASource: TStream; const ADestinationFile: string; APosition, ASize: Int64); overload;
    procedure AppendFile(ASource: TStream; const ADestinationFile: string);

    procedure MakeDir(const ANewDir: string);
    procedure RemoveDir(const ADir: string);

    procedure Delete(const AFileName: string);
    function FileExists(const AFileName: string): Boolean;
    procedure Rename(const ACurrentName, ANewName: string);

    function GetFileAttributes(const AFileName: string): TclSFtpFileAttrs;
    function GetFilePermissions(const AFileName: string): TclSFtpFilePermissions;
    function GetFileSize(const AFileName: string): Int64;
    procedure SetFileAttributes(const AFileName: string; Attr: TclSFtpFileAttrs);
    procedure SetFilePermissions(const AFileName: string; APermissions: TclSFtpFilePermissions);

    procedure MakeLink(const ALinkName, ATargetName: string);
    function ReadLink(const ALinkName: string): string;

    procedure GetList(AList: TStrings; const AFilePath: string = ''; ADetails: Boolean = True);
    procedure DirectoryListing(const AFilePath: string = '');

    property CurrentDir: string read FCurrentDir;
    property RootDir: string read FRootDir;
    property ServerVersion: Integer read FServerVersion;
    property FileAttributes: TclSFtpFileAttrs read FFileAttributes;

    property Config: TclConfig read FConfig;
  published
    property Port default DefaultSFtpPort;
    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;
    property UserKey: TclSshUserKey read FUserKey write SetUserKey;
    property SshAgent: string read FSshAgent write SetSshAgent;

    property OnSendCommand: TclSFtpCommandEvent read FOnSendCommand write FOnSendCommand;
    property OnReceiveResponse: TclSFtpCommandEvent read FOnReceiveResponse write FOnReceiveResponse;
    property OnProgress: TclProgressEvent read FOnProgress write FOnProgress;
    property OnVerifyServer: TclVerifySshPeerEvent read FOnVerifyServer write FOnVerifyServer;
    property OnDirectoryListing: TclSFtpDirectoryListingEvent read FOnDirectoryListing write FOnDirectoryListing;
    property OnShowBanner: TclSshShowBannerEvent read FOnShowBanner write FOnShowBanner;
  end;

implementation

uses
  clSshUtils;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

type
  TclSFtpUserIdentity = class(TclSshUserIdentity)
  private
    FOwner: TclSFtp;
  public
    constructor Create(AOwner: TclSFtp);

    function GetUserName: string; override;
    function GetPassword: string; override;
    function GetUserKey: TclSshUserKey; override;

    procedure ShowBanner(const AMessage, ALanguage: string); override;
  end;

{ TclSFtp }

procedure TclSFtp.GetFile(const ASourceFile, ADestinationFile: string);
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

function TclSFtp.GetFileSizeSilent(const AFileName: string): Int64;
var
  path: string;
  attrs: TclSFtpFileAttrs;
begin
  Result := -1;
  path := GetFullPath(AFileName);

  SendSTAT(TclTranslator.GetBytes(path), True);
  if (FResponseType = SSH_FXP_ATTRS) then
  begin
    FPacket.GetInt();
    attrs := TclSFtpFileAttrs.Create(FPacket);
    try
      Result := attrs.Size;
    finally
      attrs.Free();
    end;
  end;
end;

function TclSFtp.GetFileSize(const AFileName: string): Int64;
begin
  Result := GetFileAttributes(AFileName).Size;
end;

function TclSFtp.GetFileSizeIfNeed(const AFileName: string): Int64;
begin
  Result := -1;
  if Assigned(OnProgress) then
  begin
    Result := GetFileSizeSilent(AFileName);
  end;
end;

procedure TclSFtp.GetFile(const ASourceFile: string; ADestination: TStream);
begin
  GetFile(ASourceFile, ADestination, -1, GetFileSizeIfNeed(ASourceFile));
end;

function TclSFtp.GetFullPath(const APath: string): string;
begin
  Result := APath;

  if (System.Pos('/', Result) <> 1) then
  begin
    if (CurrentDir <> '/') then
    begin
      Result := '/' + Result;
    end;
    Result := CurrentDir + Result;
  end;
end;

procedure TclSFtp.DirectoryListing(const AFilePath: string);
var
  list: TStrings;
begin
  list := TStringList.Create();
  try
    GetList(list, AFilePath, True);
  finally
    list.Free();
  end;
end;

procedure TclSFtp.GetList(AList: TStrings; const AFilePath: string; ADetails: Boolean);
var
  path, nameStr: string;
  handle, fileName, longName: TclByteArray;
  count: Integer;
  attrs: TclSFtpFileAttrs;
begin
{$IFNDEF DELPHI2005}handle := nil; fileName := nil; longName := nil;{$ENDIF}
  path := GetFullPath(AFilePath);

  SendOPENDIR(TclTranslator.GetBytes(path));
  if (FResponseType <> SSH_FXP_STATUS) and (FResponseType <> SSH_FXP_HANDLE) then
  begin
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;
  FPacket.GetInt();

  handle := FPacket.GetString();

  AList.Clear();

  repeat
    SendREADDIR(handle);
    if (FResponseType <> SSH_FXP_STATUS) and (FResponseType <> SSH_FXP_NAME) then
    begin
      raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
    end;
    if (FResponseType = SSH_FXP_STATUS) and (FStatusCode = SSH_FX_EOF) then
    begin
      Break;
    end;

    FPacket.GetInt();
    count := FPacket.GetInt();

    while (count > 0) do
    begin
      fileName := FPacket.GetString();
      nameStr := TclTranslator.GetString(fileName);
      longName := FPacket.GetString();
      if (ADetails) then
      begin
        AList.Add(TclTranslator.GetString(longName));
      end else
      begin
        AList.Add(nameStr);
      end;

      attrs := TclSFtpFileAttrs.Create(FPacket);
      try
        DoDirectoryListing(nameStr, attrs);
        Dec(count);
      finally
        attrs.Free();
      end;
    end;
  until False;

  SendCLOSE(handle);
end;

procedure TclSFtp.AppendFile(ASource: TStream; const ADestinationFile: string);
begin
  InternalPutData(ASource, ADestinationFile, GetFileSizeSilent(ADestinationFile), -1, SSH_FXF_WRITE or SSH_FXF_CREAT);
end;

procedure TclSFtp.ChangeCurrentDir(const ANewDir: string);
var
  path: string;
  str: TclByteArray;
begin
{$IFNDEF DELPHI2005}str := nil;{$ENDIF}
  path := GetFullPath(ANewDir);

  SendREALPATH(TclTranslator.GetBytes(path));
  if (FResponseType <> SSH_FXP_NAME) then
  begin
    raise EclSFtpClientError.Create(SFtpPathError, SFtpPathErrorCode);
  end;

  FPacket.GetInt();
  FPacket.GetInt();
  str := FPacket.GetString();

  FCurrentDir := TclTranslator.GetString(str);
  if (FCurrentDir <> '/') then
  begin
    FCurrentDir := RemoveTrailingBackSlash(FCurrentDir, '/');
  end;
end;

procedure TclSFtp.ChangeToParentDir;
begin
  ChangeCurrentDir('..');
end;

procedure TclSFtp.CheckError;
var
  msg: TclByteArray;
begin
{$IFNDEF DELPHI2005}msg := nil;{$ENDIF}
  if (FResponseType = SSH_FXP_STATUS) then
  begin
    if ((FStatusCode <> SSH_FX_OK) and (FStatusCode <> SSH_FX_EOF)) then
    begin
      if (ServerVersion >= 3) then
      begin
        msg := FPacket.GetString();
        raise EclSFtpClientError.Create(TclTranslator.GetString(msg), FStatusCode);
      end;
      raise EclSFtpClientError.Create(SFtpError, FStatusCode);
    end;
  end;
end;

function TclSFtp.GetResponse: Integer;
begin
  Result := FPacket.GetInt();
  FResponseType := FPacket.GetByte();
  FStatusCode := 0;

  if (FResponseType = SSH_FXP_STATUS) then
  begin
    FPacket.GetInt();//request-id
    FStatusCode := FPacket.GetInt();
  end;
end;

procedure TclSFtp.CloseChannel;
begin
end;

constructor TclSFtp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FConfig := CreateConfig();

  FIdentity := TclSFtpUserIdentity.Create(Self);

  FUserKey := TclSshUserKey.Create();
  FUserKey.OnChanged := DoChanged;

  FPacket := TclPacket.Create();
  FRequestId := 0;

  FRootDir := '';
  FCurrentDir := '';
  FServerVersion := 0;
  FSshAgent := DefaultSshAgent;

  FFileAttributes := nil;
end;

function TclSFtp.CreateConfig: TclConfig;
begin
  Result := TclSshConfig.Create();
end;

procedure TclSFtp.VerifyServer(Sender: TObject; const AHost, AKeyType,
  AFingerPrint, AHostKey: string; var AVerified: Boolean);
begin
  DoVerifyServer(AHost, AKeyType, AFingerPrint, AHostKey, AVerified);
end;

function TclSFtp.WritePacket(APack: TclPacket; AFxp: Integer; ASilent: Boolean): Integer;
var
  ms: TStream;
begin
  ms := TMemoryStream.Create();
  try
    ms.Write(APack.Buffer[0], APack.GetIndex());
    ms.Seek(0, soBeginning);
    Connection.WriteData(ms);
    Assert(ms.Position >= ms.Size - 1);
    DoSendCommand(AFxp, ms);

    ms.Size := 0;
    while ((ms.Size <= 0) or Connection.NetworkStream.HasReadData) do
    begin
      Connection.ReadData(ms);
    end;
    DoReceiveResponse(AFxp, ms);
    ReadPacket(ms, FPacket);

    Result := GetResponse();
    if (not ASilent) then
    begin
      CheckError();
    end;
  finally
    ms.Free();
  end;
end;

procedure TclSFtp.Delete(const AFileName: string);
var
  path: string;
begin
  path := GetFullPath(AFileName);

  SendREMOVE(TclTranslator.GetBytes(path));
  if (FResponseType <> SSH_FXP_STATUS) then
  begin
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;
end;

procedure TclSFtp.DoChanged(Sender: TObject);
begin
  Changed();
end;

procedure TclSFtp.DoDestroy;
begin
  FFileAttributes.Free();
  FPacket.Free();
  FUserKey.Free();
  FIdentity.Free();
  FConfig.Free();

  inherited DoDestroy();
end;

procedure TclSFtp.DoDirectoryListing(const AFileName: string; AFileAttrs: TclSFtpFileAttrs);
begin
  if Assigned(OnDirectoryListing) then
  begin
    OnDirectoryListing(Self, AFileName, AFileAttrs);
  end;
end;

procedure TclSFtp.DoProgress(ABytesProceed, ATotalBytes: Int64);
begin
  if Assigned(OnProgress) then
  begin
    OnProgress(Self, ABytesProceed, ATotalBytes);
  end;
end;

procedure TclSFtp.DoReceiveResponse(AFxpCommand: Integer; ABuffer: TStream);
begin
  if Assigned(OnReceiveResponse) then
  begin
    OnReceiveResponse(Self, AFxpCommand, ABuffer);
  end;
end;

procedure TclSFtp.DoSendCommand(AFxpCommand: Integer; ABuffer: TStream);
begin
  if Assigned(OnSendCommand) then
  begin
    OnSendCommand(Self, AFxpCommand, ABuffer);
  end;
end;

procedure TclSFtp.DoShowBanner(const AMessage, ALanguage: string);
begin
  if Assigned(OnShowBanner) then
  begin
    OnShowBanner(Self, AMessage, ALanguage);
  end;
end;

procedure TclSFtp.DoVerifyServer(const AHost, AKeyType, AFingerPrint, AHostKey: string; var AVerified: Boolean);
begin
  if Assigned(OnVerifyServer) then
  begin
    OnVerifyServer(Self, AHost, AKeyType, AFingerPrint, AHostKey, AVerified);
  end;
end;

function TclSFtp.FileExists(const AFileName: string): Boolean;
var
  path: string;
begin
  path := GetFullPath(AFileName);

  SendSTAT(TclTranslator.GetBytes(path), True);
  if (FResponseType = SSH_FXP_ATTRS) then
  begin
    Result := True;
  end else
  if (FResponseType = SSH_FXP_STATUS) and (FStatusCode = SSH_FX_NO_SUCH_FILE) then
  begin
    Result := False;
  end else
  begin
    CheckError();
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;
end;

function TclSFtp.GetDefaultPort: Integer;
begin
  Result := DefaultSFtpPort;
end;

function TclSFtp.GetNetworkStream: TclNetworkStream;
var
  ns: TclSshNetworkStream;
begin
  ns := TclSshNetworkStream.Create(FConfig);
  ns.SshAgent := SshAgent;
  ns.Identity := FIdentity;
  ns.TargetName := Server;
  ns.ChannelType := 'session';
  ns.SubSystem := 'sftp';
  ns.OnVerifyPeer := VerifyServer;
  Result := ns;
end;

procedure TclSFtp.InternalClose(ANotifyPeer: Boolean);
begin
  try
    if Active and not InProgress then
    begin
      CloseChannel();
    end;
  finally
    inherited InternalClose(ANotifyPeer);
  end;
end;

procedure TclSFtp.InternalOpen;
begin
  inherited InternalOpen();
  OpenChannel();
end;

procedure TclSFtp.InternalPutData(ASource: TStream;
  const ADestinationFile: string; AOffset, ASize: Int64; AMode: Integer);
var
  destFile: string;
  handle, data: TclByteArray;
  bufSize, toPut, i: Integer;
  count, offset, sourceSize: Int64;
begin
{$IFNDEF DELPHI2005}handle := nil; data := nil;{$ENDIF}
  destFile := GetFullPath(ADestinationFile);

  SendOPEN(TclTranslator.GetBytes(destFile), AMode);
  if (FResponseType <> SSH_FXP_STATUS) and (FResponseType <> SSH_FXP_HANDLE) then
  begin
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;

  FPacket.GetInt();
  handle := FPacket.GetString();

  bufSize := BatchSize;
  SetLength(data, bufSize);

  count := 0;
  sourceSize := ASource.Size;
  offset := AOffset;

  DoProgress(offset, sourceSize);
  repeat
    toPut := bufSize;
    if ((ASize > 0) and ((ASize - count) < toPut)) then
    begin
      toPut := ASize - count;
    end;
    if (toPut <= 0) then
    begin
      Break;
    end;

    i := ASource.Read(data[0], toPut);
    if (i <= 0) then
    begin
      Break;
    end;

    if ((ASize > 0) and (count >= ASize)) then
    begin
      Break;
    end;

    SendWRITE(handle, offset, data, 0, i);
    if (FResponseType <> SSH_FXP_STATUS) then
    begin
      Break;
    end;
    if (FResponseType = SSH_FXP_STATUS) and (FStatusCode <> SSH_FX_OK) then
    begin
      Break;
    end;

    offset := offset + i;
    count := count + i;

    DoProgress(offset, sourceSize);
  until False;

  SendCLOSE(handle);
  if (FResponseType <> SSH_FXP_STATUS) then
  begin
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;
end;

procedure TclSFtp.MakeDir(const ANewDir: string);
var
  path: string;
begin
  path := GetFullPath(ANewDir);

  SendMKDIR(TclTranslator.GetBytes(path));
  if (FResponseType <> SSH_FXP_STATUS) then
  begin
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;
end;

procedure TclSFtp.MakeLink(const ALinkName, ATargetName: string);
var
  linkPath, targetPath: string;
begin
  if (FServerVersion < 2) then
  begin
    raise EclSFtpClientError.Create(SFtpOldVersionError, SFtpOldVersionErrorCode);
  end;

  linkPath := GetFullPath(ALinkName);
  targetPath := GetFullPath(ATargetName);

  SendSYMLINK(TclTranslator.GetBytes(linkPath), TclTranslator.GetBytes(targetPath));
  if (FResponseType <> SSH_FXP_STATUS) then
  begin
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;
end;

procedure TclSFtp.OpenChannel;
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

  SendINIT();
  if (FResponseType <> SSH_FXP_VERSION) then
  begin
    raise EclSFtpClientError.Create(SFtpVersionError, SFtpVersionErrorCode);
  end;

  FServerVersion := FPacket.GetInt();
  FResponseType := 0;
  FStatusCode := 0;

  ChangeCurrentDir('.');

  FRootDir := FCurrentDir;
end;

procedure TclSFtp.PutFile(const ASourceFile, ADestinationFile: string);
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

procedure TclSFtp.PutFile(ASource: TStream; const ADestinationFile: string);
begin
  PutFile(ASource, ADestinationFile, -1, -1);
end;

procedure TclSFtp.PutFile(ASource: TStream; const ADestinationFile: string; APosition, ASize: Int64);
var
  mode: Integer;
  offset: Int64;
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

  mode := SSH_FXF_WRITE or SSH_FXF_CREAT;
  if (APosition < 0) then
  begin
    mode := mode or SSH_FXF_TRUNC;
  end;

  offset := 0;
  if (APosition > 0) then
  begin
    offset := APosition;
  end;
  ASource.Position := offset;

  InternalPutData(ASource, ADestinationFile, offset, ASize, mode);
end;

procedure TclSFtp.PutHEAD(AType: Byte; ALength: Integer);
begin
  FPacket.PutByte(SSH_MSG_CHANNEL_DATA);
  FPacket.PutInt((TclSshNetworkStream(Connection.NetworkStream)).RecipientId);
  FPacket.PutInt(ALength + 4);
  FPacket.PutInt(ALength);
  FPacket.PutByte(AType);
end;

function TclSFtp.ReadPacket(ASource: TStream; APacket: TclPacket): Integer;
begin
  APacket.Init();
  ASource.Position := 0;
  Result := ASource.Read(APacket.Buffer[0], ASource.Size);
end;

function TclSFtp.ReadLink(const ALinkName: string): string;
var
  linkPath: string;
  fileName: TclByteArray;
begin
{$IFNDEF DELPHI2005}fileName := nil;{$ENDIF}
  if (FServerVersion < 2) then
  begin
    raise EclSFtpClientError.Create(SFtpOldVersionError, SFtpOldVersionErrorCode);
  end;

  linkPath := GetFullPath(ALinkName);

  SendREADLINK(TclTranslator.GetBytes(linkPath));
  if ((FResponseType <> SSH_FXP_STATUS) and (FResponseType <> SSH_FXP_NAME)) then
  begin
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;

  FPacket.GetInt();
  FPacket.GetInt();
  fileName := FPacket.GetString();
  Result := TclTranslator.GetString(fileName);
end;

procedure TclSFtp.RemoveDir(const ADir: string);
var
  path: string;
begin
  path := GetFullPath(ADir);

  SendRMDIR(TclTranslator.GetBytes(path));
  if (FResponseType <> SSH_FXP_STATUS) then
  begin
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;
end;

procedure TclSFtp.Rename(const ACurrentName, ANewName: string);
var
  oldPath, newPath: string;
begin
  if (FServerVersion < 2) then
  begin
    raise EclSFtpClientError.Create(SFtpOldVersionError, SFtpOldVersionErrorCode);
  end;

  oldPath := GetFullPath(ACurrentName);
  newPath := GetFullPath(ANewName);

  SendRENAME(TclTranslator.GetBytes(oldPath), TclTranslator.GetBytes(newPath));
  if (FResponseType <> SSH_FXP_STATUS) then
  begin
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;
end;

procedure TclSFtp.SendCLOSE(const APath: TclByteArray);
begin
  SendPathCommand(SSH_FXP_CLOSE, APath, False);
end;

procedure TclSFtp.SendINIT;
begin
  CheckConnected();
  FPacket.Reset();
  PutHEAD(SSH_FXP_INIT, 5);
  FPacket.PutInt(SFtpClientVersion);
  WritePacket(FPacket, SSH_FXP_INIT, True);
end;

procedure TclSFtp.SendMKDIR(const APath: TclByteArray);
begin
  CheckConnected();
  FPacket.Reset();
  PutHEAD(SSH_FXP_MKDIR, 9 + Length(APath) + 4);
  FPacket.PutInt(FRequestId);
  Inc(FRequestId);
  FPacket.PutString(APath);
  FPacket.PutInt(0);
  WritePacket(FPacket, SSH_FXP_MKDIR, False);
end;

procedure TclSFtp.SendOPEN(const APath: TclByteArray; AMode: Integer);
begin
  CheckConnected();
  FPacket.Reset();
  PutHEAD(SSH_FXP_OPEN, 17 + Length(APath));
  FPacket.PutInt(FRequestId);
  Inc(FRequestId);
  FPacket.PutString(APath);
  FPacket.PutInt(AMode);
  FPacket.PutInt(0);
  WritePacket(FPacket, SSH_FXP_OPEN, False);
end;

procedure TclSFtp.SendOPENDIR(const APath: TclByteArray);
begin
  SendPathCommand(SSH_FXP_OPENDIR, APath, False);
end;

procedure TclSFtp.SendPathCommand(AFxp: Byte; const APath: TclByteArray; ASilent: Boolean);
begin
  CheckConnected();
  FPacket.Reset();
  PutHEAD(AFxp, 9 + Length(APath));
  FPacket.PutInt(FRequestId);
  Inc(FRequestId);
  FPacket.PutString(APath);
  WritePacket(FPacket, AFxp, ASilent);
end;

procedure TclSFtp.SendPathCommand(AFxp: Byte; const APath1, APath2: TclByteArray);
begin
  CheckConnected();
  FPacket.Reset();
  PutHEAD(AFxp, 13 + Length(APath1) + Length(APath2));
  FPacket.PutInt(FRequestId);
  Inc(FRequestId);
  FPacket.PutString(APath1);
  FPacket.PutString(APath2);
  WritePacket(FPacket, AFxp, False);
end;

procedure TclSFtp.SendREAD(const AHandle: TclByteArray; AOffset: Int64; ALength: Integer);
begin
  FPacket.Reset();
  PutHEAD(SSH_FXP_READ, 21 + Length(AHandle));
  FPacket.PutInt(FRequestId);
  Inc(FRequestId);
  FPacket.PutString(AHandle);
  FPacket.PutLong(AOffset);
  FPacket.PutInt(ALength);

  WritePacket(FPacket, SSH_FXP_READ, False);
end;

procedure TclSFtp.SendREADDIR(const APath: TclByteArray);
begin
  FPacket.Reset();
  PutHEAD(SSH_FXP_READDIR, 9 + Length(APath));
  FPacket.PutInt(FRequestId);
  Inc(FRequestId);
  FPacket.PutString(APath);

  WritePacket(FPacket, SSH_FXP_READDIR, False);
end;

procedure TclSFtp.SendREADLINK(const ALinkPath: TclByteArray);
begin
  SendPathCommand(SSH_FXP_READLINK, ALinkPath, False);
end;

procedure TclSFtp.SendREALPATH(const APath: TclByteArray);
begin
  SendPathCommand(SSH_FXP_REALPATH, APath, False);
end;

procedure TclSFtp.SendREMOVE(const APath: TclByteArray);
begin
  SendPathCommand(SSH_FXP_REMOVE, APath, False);
end;

procedure TclSFtp.SendRENAME(const AOldPath, ANewPath: TclByteArray);
begin
  SendPathCommand(SSH_FXP_RENAME, AOldPath, ANewPath);
end;

procedure TclSFtp.SendRMDIR(const APath: TclByteArray);
begin
  SendPathCommand(SSH_FXP_RMDIR, APath, False);
end;

procedure TclSFtp.SendSETSTAT(const APath: TclByteArray; Attr: TclSFtpFileAttrs);
begin
  CheckConnected();
  FPacket.Reset();
  PutHEAD(SSH_FXP_SETSTAT, 9 + Length(APath) + attr.SavedLength());
  FPacket.PutInt(FRequestId);
  Inc(FRequestId);
  FPacket.PutString(APath);
  Attr.Save(FPacket);
  WritePacket(FPacket, SSH_FXP_SETSTAT, False);
end;

procedure TclSFtp.SendSTAT(const APath: TclByteArray; ASilent: Boolean);
begin
  SendPathCommand(SSH_FXP_STAT, APath, ASilent);
end;

procedure TclSFtp.SendSYMLINK(const ALinkPath, ATargetPath: TclByteArray);
begin
  SendPathCommand(SSH_FXP_SYMLINK, ALinkPath, ATargetPath);
end;

procedure TclSFtp.SendWRITE(const AHandle: TclByteArray; AOffset: Int64;
  const AData: TclByteArray; AStart, ALength: Integer);
begin
  FPacket.Reset();
  PutHEAD(SSH_FXP_WRITE, 21 + Length(AHandle) + ALength);
  FPacket.PutInt(FRequestId);
  Inc(FRequestId);
  FPacket.PutString(AHandle);
  FPacket.PutLong(AOffset);
  FPacket.PutString(AData, AStart, ALength);

  WritePacket(FPacket, SSH_FXP_WRITE, False);
end;

procedure TclSFtp.SetFileAttributes(const AFileName: string; Attr: TclSFtpFileAttrs);
var
  path: string;
begin
  path := GetFullPath(AFileName);

  SendSETSTAT(TclTranslator.GetBytes(path), Attr);
  if (FResponseType <> SSH_FXP_STATUS) then
  begin
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;
end;

procedure TclSFtp.SetFilePermissions(const AFileName: string; APermissions: TclSFtpFilePermissions);
var
  attrs: TclSFtpFileAttrs;
begin
  attrs := TclSFtpFileAttrs.Create();
  try
    attrs.SetPermissions(APermissions);
    SetFileAttributes(AFileName, attrs);
  finally
    attrs.Free();
  end;
end;

procedure TclSFtp.SetPassword(const Value: string);
begin
  if (FPassword <> Value) then
  begin
    FPassword := Value;
    Changed();
  end;
end;

procedure TclSFtp.SetSshAgent(const Value: string);
begin
  if (FSshAgent <> Value) then
  begin
    FSshAgent := Value;
    Changed();
  end;
end;

procedure TclSFtp.SetUserKey(const Value: TclSshUserKey);
begin
  FUserKey.Assign(Value);
  Changed();
end;

procedure TclSFtp.SetUserName(const Value: string);
begin
  if (FUserName <> Value) then
  begin
    FUserName := Value;
    Changed();
  end;
end;

procedure TclSFtp.GetFile(const ASourceFile: string; ADestination: TStream; APosition, ASize: Int64);
var
  len, offset, count: Int64;
  bufSize, toGet: Integer;
  sourceFile: string;
  handle, data: TclByteArray;
  data_start, data_len: TclIntArray;
begin
{$IFNDEF DELPHI2005}handle := nil; data := nil; data_start := nil; data_len := nil;{$ENDIF}

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

  len := APosition + ASize;
  if (len < 0) then
  begin
    len := 0;
  end;
  if (len < APosition) then
  begin
    len := APosition;
  end;

  if (ADestination.Size < len) then
  begin
    ADestination.Size := len;
  end;
  if (APosition > -1) then
  begin
    ADestination.Position := APosition;
  end;

  sourceFile := GetFullPath(ASourceFile);

  SendOPEN(TclTranslator.GetBytes(sourceFile), SSH_FXF_READ);
  if (FResponseType <> SSH_FXP_STATUS) and (FResponseType <> SSH_FXP_HANDLE) then
  begin
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;

  FPacket.GetInt();
  handle := FPacket.GetString();

  data := nil;
  SetLength(data_start, 1);
  SetLength(data_len, 1);

  offset := 0;
  count := 0;

  if (APosition > -1) then
  begin
    offset := offset + APosition;
  end;

  bufSize := BatchSize;

  DoProgress(offset, ASize);
  while ((ASize < 0) or (count < ASize)) do
  begin
    toGet := bufSize;
    if ((ASize > 0) and ((ASize - count) < toGet)) then
    begin
      toGet := ASize - count;
    end;

    SendREAD(handle, offset, toGet);
    if (FResponseType <> SSH_FXP_STATUS) and (FResponseType <> SSH_FXP_DATA) then
    begin
      Break;
    end;
    if (FResponseType = SSH_FXP_STATUS) and (FStatusCode = SSH_FX_EOF) then
    begin
      Break;
    end;

    FPacket.GetInt();
    data := FPacket.GetString(data_start, data_len);
    ADestination.Write(data[data_start[0]], data_len[0]);
    offset := offset + data_len[0];
    count := count + data_len[0];

    DoProgress(offset, ASize);
  end;

  SendCLOSE(handle);
  if (FResponseType <> SSH_FXP_STATUS) then
  begin
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;
end;

function TclSFtp.GetFileAttributes(const AFileName: string): TclSFtpFileAttrs;
var
  path: string;
begin
  if (FFileAttributes = nil) then
  begin
    FFileAttributes := TclSFtpFileAttrs.Create();
  end;

  path := GetFullPath(AFileName);

  SendSTAT(TclTranslator.GetBytes(path), False);
  if (FResponseType <> SSH_FXP_ATTRS) then
  begin
    raise EclSFtpClientError.Create(EclSFtpClientError.GetSFtpStatusText(SSH_FX_FAILURE), SSH_FX_FAILURE);
  end;
  FPacket.GetInt();
  FFileAttributes.Load(FPacket);

  Result := FFileAttributes;
end;

function TclSFtp.GetFilePermissions(const AFileName: string): TclSFtpFilePermissions;
begin
  Result := GetFileAttributes(AFileName).Permissions;
end;

{ TclSFtpUserIdentity }

constructor TclSFtpUserIdentity.Create(AOwner: TclSFtp);
begin
  inherited Create();
  FOwner := AOwner;
end;

function TclSFtpUserIdentity.GetPassword: string;
begin
  Result := FOwner.Password;
end;

function TclSFtpUserIdentity.GetUserKey: TclSshUserKey;
begin
  Result := FOwner.UserKey;
end;

function TclSFtpUserIdentity.GetUserName: string;
begin
  Result := FOwner.UserName;
end;

procedure TclSFtpUserIdentity.ShowBanner(const AMessage, ALanguage: string);
begin
  FOwner.DoShowBanner(AMessage, ALanguage);
end;

end.
