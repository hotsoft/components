{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clFtpServer;

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
  Classes, Windows, SysUtils, WinSock, SyncObjs,
{$ELSE}
  System.Classes, Winapi.Windows, System.SysUtils, Winapi.WinSock, System.SyncObjs,
{$ENDIF}
  clUtils, clTcpServer, clTcpServerTls, clSocket, clFtpUtils, clUserMgr, clCertificate,
  clTcpCommandServer, clSocketUtils;

type
  EclFtpServerError = class(EclTcpCommandServerError);

  TclFtpFileTransferStatus  = (tsSuccess, tsFail, tsAbort);

  TclFtpServerPermission = (spMakeDir, spRemoveDir, spChangeDir, spDownload, spUpload, spRename, spDelete, spAll);
  TclFtpServerPermissions = set of TclFtpServerPermission;

  TclFtpCommandConnection = class(TclCommandConnection)
  private
    FIsAuthorized: Boolean;
    FCurrentDir: string;
    FDataPosition: Int64;
    FCurrentName: string;
    FDataConnection: TclTcpConnection;
    FDataConnectionAccess: TCriticalSection;
    FTransferMode: TclFtpTransferMode;
    FTransferStructure: TclFtpTransferStructure;
    FTransferType: TclFtpTransferType;
    FUserName: string;
    FRootDir: string;
    FPassiveMode: Boolean;
    FDataPort: Integer;
    FDataIP: string;
    FDataProtection: Boolean;
    FDataBitsPerSec: Integer;
    FPermissions: TclFtpServerPermissions;

    procedure AssignDataConnection(AConnection: TclTcpConnection);
    procedure DoOnProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
  protected
    procedure DoDestroy; override;
  public
    constructor Create;
    procedure InitParams;

    property IsAuthorized: Boolean read FIsAuthorized;
    property CurrentDir: string read FCurrentDir;
    property RootDir: string read FRootDir;
    property DataPosition: Int64 read FDataPosition;
    property CurrentName: string read FCurrentName;
    property DataConnection: TclTcpConnection read FDataConnection;
    property TransferMode: TclFtpTransferMode read FTransferMode;
    property TransferStructure: TclFtpTransferStructure read FTransferStructure;
    property TransferType: TclFtpTransferType read FTransferType;
    property UserName: string read FUserName;
    property Permissions: TclFtpServerPermissions read FPermissions write FPermissions;
    property DataIP: string read FDataIP;
    property DataPort: Integer read FDataPort;
    property PassiveMode: Boolean read FPassiveMode;
    property DataProtection: Boolean read FDataProtection;
    property DataBitsPerSec: Integer read FDataBitsPerSec write FDataBitsPerSec;
  end;

  TclFtpUserAccountItem = class(TclUserAccountItem)
  private
    FPermissions: TclFtpServerPermissions;
    FRootDir: string;
    FBitsPerSec: Integer;

    procedure SetRootDir(const Value: string);
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
  published
    property Permissions: TclFtpServerPermissions read FPermissions write FPermissions default [spAll];
    property RootDir: string read FRootDir write SetRootDir;
    property BitsPerSec: Integer  read FBitsPerSec write FBitsPerSec default 0;
  end;

  TclFtpUserAccountList = class(TclUserAccountList)
  private
    function GetItem(Index: Integer): TclFtpUserAccountItem;
    procedure SetItem(Index: Integer; const Value: TclFtpUserAccountItem);
  public
    function Add: TclFtpUserAccountItem;
    property Items[Index: Integer]: TclFtpUserAccountItem read GetItem write SetItem; default;
    function AccountByUserName(const AUserName: string): TclFtpUserAccountItem;
  end;

  TclFtpCommandHandler = procedure (AConnection: TclFtpCommandConnection; const ACommand: string;
    AParameters: TclTcpCommandParams) of object;

  TclFtpCommandInfo = class(TclTcpCommandInfo)
  private
    FHandler: TclFtpCommandHandler;
  protected
    procedure Execute(AConnection: TclCommandConnection; AParams: TclTcpCommandParams); override;
  public
    constructor Create(const AName: string; AHandler: TclFtpCommandHandler); overload;
    constructor Create(const AName: string; AHandler: TclFtpCommandHandler; AIsOOB: Boolean); overload;
  end;

  TclFtpGetFileEvent = procedure (Sender: TObject; AConnection: TclFtpCommandConnection;
    const AFileName: string; var ASource: TStream; var Success: Boolean;
    var AErrorMessage: string) of object;

  TclFtpPutFileEvent = procedure (Sender: TObject; AConnection: TclFtpCommandConnection;
    const AFileName: string; AOverwrite: Boolean; var ADestination: TStream;
    var Success: Boolean; var AErrorMessage: string) of object;

  TclFtpAuthenticateEvent = procedure (Sender: TObject; AConnection: TclFtpCommandConnection;
    var Account: TclFtpUserAccountItem; const AUserName, APassword: string; var IsAuthorized, Handled: Boolean) of object;

  TclFtpNameEvent = procedure (Sender: TObject; AConnection: TclFtpCommandConnection;
    const AName: string; var Success: Boolean; var AErrorMessage: string) of object;

  TclFtpConnectionEvent = procedure (Sender: TObject; AConnection: TclFtpCommandConnection) of object;

  TclFtpFileListEvent = procedure (Sender: TObject; AConnection: TclFtpCommandConnection;
    const APathName, AFileMask: string; AIncludeHidden: Boolean; AFileList: TclFtpFileInfoList;
    var Success: Boolean; var AErrorMessage: string) of object;

  TclFtpRenameEvent = procedure (Sender: TObject; AConnection: TclFtpCommandConnection;
    const ACurrentName, ANewName: string; var Success: Boolean; var AErrorMessage: string) of object;

  TclFtpHelpCommandEvent = procedure (Sender: TObject; AConnection: TclFtpCommandConnection;
    const AParameters: string; AHelpText: TStrings) of object;

  TclFtpSiteCommandEvent = procedure (Sender: TObject; AConnection: TclFtpCommandConnection;
    const AParameters: string; AResponse: TStrings; var AStatusCode: Integer) of object;

  TclFtpFileTransferEvent = procedure (Sender: TObject; AConnection: TclFtpCommandConnection;
    const AFileName: string; AFileSize: Int64; var AStatus: TclFtpFileTransferStatus; var AErrorMessage, AResponseMessage: string) of object;

  TclFtpPutFileReadyEvent = procedure (Sender: TObject; AConnection: TclFtpCommandConnection; const AFileName: string; ASource: TStream) of object;

  TclFtpGetFullPathEvent = procedure (Sender: TObject; AConnection: TclFtpCommandConnection;
    const ARootDir, ACurrentDir, APathName: string; var Result: string; var Handled: Boolean) of object;
  
  TclFtpServer = class(TclTcpCommandServer)
  private
    FRootDir: string;
    FUserAccounts: TclFtpUserAccountList;
    FAllowAnonymousAccess: Boolean;
    FDirListingStyle: TclDirListingStyle;
    FTimeOut: Integer;
		FUseFxp: Boolean;
    FPassiveHost: string;
    FServerOS: string;
    FDataPortBegin: Integer;
    FDataPortEnd: Integer;
    FExtensions: TStrings;

    FOnGetFile: TclFtpGetFileEvent;
    FOnPutFile: TclFtpPutFileEvent;
    FOnAuthenticate: TclFtpAuthenticateEvent;
    FOnCreateDir: TclFtpNameEvent;
    FOnInitDataConnection: TclFtpConnectionEvent;
    FOnGetFileList: TclFtpFileListEvent;
    FOnDelete: TclFtpNameEvent;
    FOnRename: TclFtpRenameEvent;
    FOnHelpCommand: TclFtpHelpCommandEvent;
    FOnGetFileDone: TclFtpFileTransferEvent;
    FOnPutFileDone: TclFtpFileTransferEvent;
    FOnGetFullPath: TclFtpGetFullPathEvent;
    FOnSiteCommand: TclFtpSiteCommandEvent;
    FOnPutFileReady: TclFtpPutFileReadyEvent;

    procedure HandleQUIT(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleUSER(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandlePASS(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleMODE(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleSTRU(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleTYPE(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandlePORT(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandlePASV(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleLIST(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleNLST(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleMKD(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandlePWD(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleCWD(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleCDUP(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleRMD(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleSTOR(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleAPPE(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleSTOU(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleRNFR(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleRNTO(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleDELE(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleRETR(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleSITE(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleNOOP(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleHELP(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleREIN(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleSTAT(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleSYST(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleABOR(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandlePBSZ(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandlePROT(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleAUTH(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);

    procedure HandleSIZE(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleREST(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleMDTM(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleFEAT(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleOPTS(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);

    procedure HandleNullCommand(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);

    procedure SetRootDir(const Value: string);
    procedure SetUserAccounts(const Value: TclFtpUserAccountList);
    function GetCaseInsensitive: Boolean;
    procedure SetCaseInsensitive(const Value: Boolean);

    procedure RaiseFtpError(const ACommand, AMessage: string; ACode: Integer);
    procedure RaiseArgumentError(const ACommand: string);
    procedure RaiseFileAccessError(const ACommand, AFileName, AMessage: string);
    procedure RaiseDataConnectionError(const ACommand: string);

    procedure SendMultipleResponse(AConnection: TclFtpCommandConnection; AResponse: TStrings; AStatusCode: Integer);
    procedure CollectDirList(AConnection: TclFtpCommandConnection;
      const ACommand, APathName: string; ADetails: Boolean; AList: TStrings);
    function CollectFileInfo(AConnection: TclFtpCommandConnection; const ACommand, AName: string): TclFtpFileInfo;
    procedure InternalHandleList(AConnection: TclFtpCommandConnection;
      const ACommand: string; AParameters: TclTcpCommandParams; ADetails: Boolean);
    procedure InternalHandleStor(AConnection: TclFtpCommandConnection; const ACommand: string;
      AParameters: TclTcpCommandParams; Append, ACreateUnique: Boolean);
    procedure InternalHandleDelete(AConnection: TclFtpCommandConnection;
      const ACommand, AFileName: string);
    procedure InternalHandleCwd(AConnection: TclFtpCommandConnection; const ACommand, ANewDir: string);
    function Authenticate(AConnection: TclFtpCommandConnection; var Account: TclFtpUserAccountItem;
      const AUserName, APassword: string): Boolean;
    function InternalGetFullPath(AConnection: TclFtpCommandConnection; const APathName: string): string;
    function IsAnonymousUser(const AUserName: string): Boolean;
    function IsFileExist(AConnection: TclFtpCommandConnection; const ACommand, AFileName: string): Boolean;
    function IsDataHostValid(AConnection: TclFtpCommandConnection): Boolean;
    procedure CheckAuthorized(AConnection: TclFtpCommandConnection; const ACommand: string);
    procedure CheckAccessRights(AConnection: TclFtpCommandConnection; const ACommand, AName: string;
      ARequired: TclFtpServerPermission);
    procedure CheckTlsMode(AConnection: TclFtpCommandConnection; const ACommand: string);
    procedure GetCertificate(Sender: TObject; var ACertificate: TclCertificate;
      AExtraCerts: TclCertificateList; var Handled: Boolean);
    function GetDestinationFileName(AConnection: TclFtpCommandConnection; const ACommand: string;
      ACreateUnique: Boolean; const APathName: string): string;
    function NormalizePath(const APath: string): string;
    function DenormalizePath(const APath: string): string;
    function GetRelativePath(AConnection: TclFtpCommandConnection; const APathName: string): string;
    function GetRootDir(AConnection: TclFtpCommandConnection): string;
    function HasRootDir(const ARootPath, AName: string): Boolean;
    procedure InitDataConnection(AConnection: TclFtpCommandConnection; ADataConnection: TclTcpConnection);
    procedure SetExtensions(const Value: TStrings);
  protected
    procedure OpenDataConnection(AConnection: TclFtpCommandConnection; const ACommand, AResponse: string); virtual;
    procedure DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean); override;
    procedure ProcessUnhandledError(AConnection: TclCommandConnection;
      AParameters: TclTcpCommandParams; E: Exception); override;
    function CreateDefaultConnection: TclUserConnection; override;
    function GetNullCommand(AParameters: TclTcpCommandParams): TclTcpCommandInfo; override;
    procedure GetCommands; override;
    procedure DoDestroy; override;

    procedure DoAuthenticate(AConnection: TclFtpCommandConnection; var Account: TclFtpUserAccountItem;
      const AUserName, APassword: string; var IsAuthorized, Handled: Boolean); virtual;
    procedure DoCreateDir(AConnection: TclFtpCommandConnection;
      const AName: string; var Success: Boolean; var AErrorMessage: string); virtual;
    procedure DoDelete(AConnection: TclFtpCommandConnection;
      const AName: string; var Success: Boolean; var AErrorMessage: string); virtual;
    procedure DoRename(AConnection: TclFtpCommandConnection;
      const ACurrentName, ANewName: string; var Success: Boolean; var AErrorMessage: string); virtual;
    procedure DoGetFile(AConnection: TclFtpCommandConnection; const AFileName: string;
      var ASource: TStream; var Success: Boolean; var AErrorMessage: string); virtual;
    procedure DoPutFile(AConnection: TclFtpCommandConnection;
      const AFileName: string; AOverwrite: Boolean; var ADestination: TStream;
      var Success: Boolean; var AErrorMessage: string); virtual;
    procedure DoInitDataConnection(AConnection: TclFtpCommandConnection); virtual;
    procedure DoGetFileList(AConnection: TclFtpCommandConnection;
      const APathName, AFileMask: string; AIncludeHidden: Boolean; AFileList: TclFtpFileInfoList;
      var Success: Boolean; var AErrorMessage: string); virtual;
    procedure DoGetFileDone(AConnection: TclFtpCommandConnection; const AFileName: string;
      AFileSize: Int64; var AStatus: TclFtpFileTransferStatus; var AErrorMessage, AResponseMessage: string); virtual;
    procedure DoPutFileDone(AConnection: TclFtpCommandConnection; const AFileName: string;
      AFileSize: Int64; var AStatus: TclFtpFileTransferStatus; var AErrorMessage, AResponseMessage: string); virtual;
    procedure DoPutFileReady(AConnection: TclFtpCommandConnection; const AFileName: string; ASource: TStream); virtual;

    procedure DoGetFullPath(AConnection: TclFtpCommandConnection; const ARootDir, ACurrentDir, APathName: string;
      var Result: string; var Handled: Boolean);
    procedure DoHelpCommand(AConnection: TclFtpCommandConnection; const AParameters: string; AHelpText: TStrings); virtual;
    procedure DoSiteCommand(AConnection: TclFtpCommandConnection; const AParameters: string;
      AResponse: TStrings; var AStatusCode: Integer); virtual;
    procedure GetExtensions(AList: TStrings); virtual;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property RootDir: string read FRootDir write SetRootDir;
    property AllowAnonymousAccess: Boolean read FAllowAnonymousAccess write FAllowAnonymousAccess default False;
    property TimeOut: Integer read FTimeOut write FTimeOut default 60000;
    property DirListingStyle: TclDirListingStyle read FDirListingStyle write FDirListingStyle default lsMsDos;
    property UserAccounts: TclFtpUserAccountList read FUserAccounts write SetUserAccounts;
    property CaseInsensitive: Boolean read GetCaseInsensitive write SetCaseInsensitive default False;
    property UseFxp: Boolean read FUseFxp write FUseFxp default False;
    property PassiveHost: string read FPassiveHost write FPassiveHost;
    property ServerOS: string read FServerOS write FServerOS;
    property DataPortBegin: Integer read FDataPortBegin write FDataPortBegin default 0;
    property DataPortEnd: Integer read FDataPortEnd write FDataPortEnd default 0;
    property Port default DefaultFtpPort;
    property Extensions: TStrings read FExtensions write SetExtensions;

    property OnGetFile: TclFtpGetFileEvent read FOnGetFile write FOnGetFile;
    property OnPutFile: TclFtpPutFileEvent read FOnPutFile write FOnPutFile;
    property OnAuthenticate: TclFtpAuthenticateEvent read FOnAuthenticate write FOnAuthenticate;
    property OnCreateDir: TclFtpNameEvent read FOnCreateDir write FOnCreateDir;
    property OnInitDataConnection: TclFtpConnectionEvent read FOnInitDataConnection write FOnInitDataConnection;
    property OnGetFileList: TclFtpFileListEvent read FOnGetFileList write FOnGetFileList;
    property OnDelete: TclFtpNameEvent read FOnDelete write FOnDelete;
    property OnRename: TclFtpRenameEvent read FOnRename write FOnRename;
    property OnHelpCommand: TclFtpHelpCommandEvent read FOnHelpCommand write FOnHelpCommand;
    property OnGetFileDone: TclFtpFileTransferEvent read FOnGetFileDone write FOnGetFileDone;
    property OnPutFileDone: TclFtpFileTransferEvent read FOnPutFileDone write FOnPutFileDone;
    property OnPutFileReady: TclFtpPutFileReadyEvent read FOnPutFileReady write FOnPutFileReady;
    property OnGetFullPath: TclFtpGetFullPathEvent read FOnGetFullPath write FOnGetFullPath;
    property OnSiteCommand: TclFtpSiteCommandEvent read FOnSiteCommand write FOnSiteCommand;
  end;

resourcestring
  DefaultServerOS = 'Windows 9x/NT.';

implementation

uses
  clTlsSocket, clIPAddress;

const
  cTransferResult: array[Boolean] of string = ('Transfer complete', 'Transfer aborted');

{ TclFtpServer }

procedure TclFtpServer.RaiseFtpError(const ACommand, AMessage: string; ACode: Integer);
begin
  raise EclFtpServerError.Create(ACommand, Format('%d %s', [ACode, AMessage]), ACode);
end;

function TclFtpServer.DenormalizePath(const APath: string): string;
begin
  Result := StringReplace(APath, '\', '/', [rfReplaceAll]);
  if (Result <> '') and (Result[Length(Result)] = '/') then
  begin
    Delete(Result, Length(Result), 1);
  end;
end;

procedure TclFtpServer.DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean);
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

  inherited DoAcceptConnection(AConnection, Handled);
  if Handled then Exit;
  
  SendResponse(AConnection as TclCommandConnection, '', '220 ' + ServerName);
end;

procedure TclFtpServer.GetCommands;
begin
  Commands.Add(TclFtpCommandInfo.Create('USER', HandleUSER));
  Commands.Add(TclFtpCommandInfo.Create('PASS', HandlePASS));
  Commands.Add(TclFtpCommandInfo.Create('QUIT', HandleQUIT));
  Commands.Add(TclFtpCommandInfo.Create('MODE', HandleMODE));
  Commands.Add(TclFtpCommandInfo.Create('STRU', HandleSTRU));
  Commands.Add(TclFtpCommandInfo.Create('TYPE', HandleTYPE));
  Commands.Add(TclFtpCommandInfo.Create('PORT', HandlePORT));
  Commands.Add(TclFtpCommandInfo.Create('PASV', HandlePASV));
  Commands.Add(TclFtpCommandInfo.Create('P@SW', HandlePASV));
  Commands.Add(TclFtpCommandInfo.Create('LIST', HandleLIST));
  Commands.Add(TclFtpCommandInfo.Create('NLST', HandleNLST));
  Commands.Add(TclFtpCommandInfo.Create('MKD', HandleMKD));
  Commands.Add(TclFtpCommandInfo.Create('PWD', HandlePWD));
  Commands.Add(TclFtpCommandInfo.Create('CWD', HandleCWD));
  Commands.Add(TclFtpCommandInfo.Create('CDUP', HandleCDUP));
  Commands.Add(TclFtpCommandInfo.Create('RMD', HandleRMD));
  Commands.Add(TclFtpCommandInfo.Create('STOR', HandleSTOR));
  Commands.Add(TclFtpCommandInfo.Create('APPE', HandleAPPE));
  Commands.Add(TclFtpCommandInfo.Create('STOU', HandleSTOU));
  Commands.Add(TclFtpCommandInfo.Create('RNFR', HandleRNFR));
  Commands.Add(TclFtpCommandInfo.Create('RNTO', HandleRNTO));
  Commands.Add(TclFtpCommandInfo.Create('DELE', HandleDELE));
  Commands.Add(TclFtpCommandInfo.Create('RETR', HandleRETR));
  Commands.Add(TclFtpCommandInfo.Create('XMKD', HandleMKD));
  Commands.Add(TclFtpCommandInfo.Create('XPWD', HandlePWD));
  Commands.Add(TclFtpCommandInfo.Create('XCWD', HandleCWD));
  Commands.Add(TclFtpCommandInfo.Create('XCUP', HandleCDUP));
  Commands.Add(TclFtpCommandInfo.Create('XRMD', HandleRMD));
  Commands.Add(TclFtpCommandInfo.Create('SITE', HandleSITE));
  Commands.Add(TclFtpCommandInfo.Create('NOOP', HandleNOOP));
  Commands.Add(TclFtpCommandInfo.Create('ALLO', HandleNOOP));
  Commands.Add(TclFtpCommandInfo.Create('HELP', HandleHELP));
  Commands.Add(TclFtpCommandInfo.Create('REIN', HandleREIN));
  Commands.Add(TclFtpCommandInfo.Create('STAT', HandleSTAT));
  Commands.Add(TclFtpCommandInfo.Create('SYST', HandleSYST));
  Commands.Add(TclFtpCommandInfo.Create('ABOR', HandleABOR, True));
  Commands.Add(TclFtpCommandInfo.Create('PBSZ', HandlePBSZ));
  Commands.Add(TclFtpCommandInfo.Create('PROT', HandlePROT));
  Commands.Add(TclFtpCommandInfo.Create('AUTH', HandleAUTH));

  Commands.Add(TclFtpCommandInfo.Create('SIZE', HandleSIZE));
  Commands.Add(TclFtpCommandInfo.Create('REST', HandleREST));
  Commands.Add(TclFtpCommandInfo.Create('MDTM', HandleMDTM));
  Commands.Add(TclFtpCommandInfo.Create('FEAT', HandleFEAT));
  Commands.Add(TclFtpCommandInfo.Create('OPTS', HandleOPTS));
end;

function TclFtpServer.GetDestinationFileName(AConnection: TclFtpCommandConnection; const ACommand: string;
  ACreateUnique: Boolean; const APathName: string): string;
var
  i: Integer;
begin
  Result := APathName;

  if ACreateUnique then
  begin
    i := 0;
    repeat
      Result := Format('FTP%d.TMP', [i]);
      Inc(i);
    until not IsFileExist(AConnection, ACommand, Result);
  end;

  Result := InternalGetFullPath(AConnection, Result);
  if (Result = '') then
  begin
    RaiseArgumentError(ACommand);
  end;
end;

procedure TclFtpServer.GetExtensions(AList: TStrings);
begin
  AList.Add('SIZE');
  AList.Add('REST STREAM');
  AList.Add('MDTM');
end;

constructor TclFtpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FUserAccounts := TclFtpUserAccountList.Create(Self, TclFtpUserAccountItem);
  FExtensions := TStringList.Create();
  GetExtensions(FExtensions);

  Port := DefaultFtpPort;
  CaseInsensitive := False;
  FDirListingStyle := lsMsDos;
  ServerName := 'Clever Internet Suite FTP service';
  FTimeOut := 60000;
  FServerOS := DefaultServerOS;
end;

function TclFtpServer.CreateDefaultConnection: TclUserConnection;
begin
  Result := TclFtpCommandConnection.Create();
end;

procedure TclFtpServer.SetRootDir(const Value: string);
begin
  if (FRootDir <> Value) then
  begin
    FRootDir := Value;
    if (FRootDir <> '') and (FRootDir[Length(FRootDir)] = '\') then
    begin
      Delete(FRootDir, Length(FRootDir), 1);
    end;
  end;
end;

procedure TclFtpServer.CollectDirList(AConnection: TclFtpCommandConnection;
  const ACommand, APathName: string; ADetails: Boolean; AList: TStrings);
var
  i, ind: Integer;
  s, path, fileMask, errorMessage: string;
  includeHidden, success: Boolean;
  fileList: TclFtpFileInfoList;
  info: TclFtpFileInfo; 
begin
  includeHidden := False;
  path := APathName;
  fileMask := '*';

  if SameText(path, '-al') or SameText(path, '-a') then
  begin
    path := ''; //TODO check all possible attributes
    includeHidden := True;
  end;
  if (Pos('*', path) > 0) or (Pos('?', path) > 0) then
  begin
    s := NormalizePath(path);
    ind := RTextPos('\', s);
    if (ind > 0) then
    begin
      fileMask := Copy(path, ind + 1, Length(path));
      Delete(path, ind + 1, Length(path));
    end else
    begin
      fileMask := path;
      path := '';
    end;
  end;

  fileList := TclFtpFileInfoList.Create();
  try
    success := True;
    errorMessage := '';
    DoGetFileList(AConnection, InternalGetFullPath(AConnection, path), fileMask, includeHidden, fileList, success, errorMessage);

    if (not success) then
    begin
      RaiseFileAccessError(ACommand, APathName, errorMessage);
    end;

    for i := 0 to fileList.Count - 1 do
    begin
      info := fileList[i];
      if (ADetails) then
      begin
        AList.Add(info.Build(DirListingStyle));
      end else
      begin
        AList.Add(info.FileName);
      end;
    end;
  finally
    fileList.Free();
  end;
end;

function TclFtpServer.CollectFileInfo(AConnection: TclFtpCommandConnection; const ACommand, AName: string): TclFtpFileInfo;
var
  i: Integer;
  path, fileName, errorMessage: string;
  fileList: TclFtpFileInfoList;
  success: Boolean;
begin
  Result := nil;//TODO in newer versions of Delphi causes compilation hint, add conditional define.
  
  path := InternalGetFullPath(AConnection, AName);
  fileName := '';

  if (path <> '') then
  begin
    fileName := ExtractFileName(path);
    path := ExtractFilePath(path);
  end;

  fileList := TclFtpFileInfoList.Create(False);
  try
    try
      success := True;
      errorMessage := '';
      DoGetFileList(AConnection, path,	fileName, False, fileList, success, errorMessage);

      if (not success) or (fileList.Count <> 1) then
      begin
        if (errorMessage = '') then
        begin
          errorMessage := 'The system cannot find the file specified.';
        end;

        RaiseFileAccessError(ACommand, AName, errorMessage);
      end;

      Result := fileList[0];
    except
      for i := 0 to fileList.Count - 1 do
      begin
        fileList[i].Free();
      end;
      raise;
    end;
  finally
    fileList.Free();
  end;
end;

procedure TclFtpServer.DoGetFileList(AConnection: TclFtpCommandConnection;
  const APathName, AFileMask: string; AIncludeHidden: Boolean; AFileList: TclFtpFileInfoList;
  var Success: Boolean; var AErrorMessage: string);
begin
  if Assigned(OnGetFileList) then
  begin
    OnGetFileList(Self, AConnection, APathName, AFileMask, AIncludeHidden, AFileList, Success, AErrorMessage);
  end;
end;

procedure TclFtpServer.DoGetFullPath(AConnection: TclFtpCommandConnection; const ARootDir, ACurrentDir, APathName: string;
  var Result: string; var Handled: Boolean);
begin
  if Assigned(OnGetFullPath) then
  begin
    OnGetFullPath(Self, AConnection, ARootDir, ACurrentDir, APathName, Result, Handled);
  end;
end;

procedure TclFtpServer.HandleQUIT(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  SendResponseAndClose(AConnection, ACommand, '221 Bye Bye.');
end;

procedure TclFtpServer.HandleUSER(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  CheckTlsMode(AConnection, ACommand);
  AConnection.InitParams();
  AConnection.FUserName := Trim(AParameters.Parameters);
  if (AllowAnonymousAccess and IsAnonymousUser(AConnection.UserName)) then
  begin
    SendResponse(AConnection, ACommand, '331 Anonymous access allowed, send identity (e-mail name) as password.');
  end else
  begin
    SendResponse(AConnection, ACommand, '331 Password required for %s.', [AConnection.UserName]);
  end;
end;

function TclFtpServer.HasRootDir(const ARootPath, AName: string): Boolean;
begin
  Result := (Pos(UpperCase(ARootPath), UpperCase(AName)) > 0);
end;

procedure TclFtpServer.DoAuthenticate(AConnection: TclFtpCommandConnection;
  var Account: TclFtpUserAccountItem; const AUserName, APassword: string; var IsAuthorized, Handled: Boolean);
begin
  if Assigned(OnAuthenticate) then
  begin
    OnAuthenticate(Self, AConnection, Account, AUserName, APassword, IsAuthorized, Handled);
  end;
end;

function TclFtpServer.Authenticate(AConnection: TclFtpCommandConnection;
  var Account: TclFtpUserAccountItem; const AUserName, APassword: string): Boolean;
var
  handled: Boolean;
begin
  handled := False;
  Result := False;
  DoAuthenticate(AConnection, Account, AUserName, APassword, Result, handled);
  if (not handled) and (Account <> nil) then
  begin
    Result := Account.Authenticate(APassword);
  end;
end;

procedure TclFtpServer.HandlePASS(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  account: TclFtpUserAccountItem;
  isAuthorized: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);
  if (AConnection.UserName = '') then
  begin
    RaiseFtpError(ACommand, 'Login with USER first.', 503);
  end;

  AConnection.FIsAuthorized := False;

  if (AllowAnonymousAccess and IsAnonymousUser(AConnection.UserName)) then
  begin
    if (Trim(AParameters.Parameters) = '') then
    begin
      RaiseFtpError(ACommand, Format('User %s cannot log in.', [AConnection.UserName]), 530);
    end;
    AConnection.Permissions := [spChangeDir, spDownload];
    AConnection.FRootDir := RootDir;
    AConnection.FIsAuthorized := True;

    SendResponse(AConnection, ACommand, '230 Anonymous user logged in.');
  end else
  begin
    account := UserAccounts.AccountByUserName(AConnection.UserName);

    isAuthorized := Authenticate(AConnection, account, AConnection.UserName, Trim(AParameters.Parameters));

    if (Guard <> nil) then
    begin
      isAuthorized := Guard.Login(AConnection.UserName, isAuthorized, AConnection.PeerIP, Port);
    end;

    if (not isAuthorized) then
    begin
      AConnection.InitParams();
      RaiseFtpError(ACommand, Format('User %s cannot log in.', [AConnection.UserName]), 530);
    end;

    if (account <> nil) then
    begin
      AConnection.Permissions := account.Permissions;
      AConnection.FRootDir := account.RootDir;
      AConnection.FDataBitsPerSec := account.BitsPerSec;
    end;

    AConnection.FIsAuthorized := True;

    SendResponse(AConnection, ACommand, '230 User %s logged in.', [AConnection.UserName]);
  end;
end;

function TclFtpServer.IsAnonymousUser(const AUserName: string): Boolean;
begin
  if CaseInsensitive then
  begin
    Result := SameText('anonymous', AUserName);
  end else
  begin
    Result := ('Anonymous' = AUserName);
  end;
end;

function TclFtpServer.IsDataHostValid(AConnection: TclFtpCommandConnection): Boolean;
begin
  if (not UseFxp) then
  begin
    Result := (AConnection.PeerIP = AConnection.DataIP);
  end else
  begin
    Result := True;
  end;

  if (Result) then
  begin
    Result := ((AConnection.DataPort >= 1024) or (AConnection.DataPort = 20));
  end;
end;

procedure TclFtpServer.HandleMODE(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  s: string;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  
  s := UpperCase(Trim(AParameters.Parameters));
  if (Length(s) <> 1) then
  begin
    RaiseArgumentError(ACommand);
  end;
  
  case s[1] of
    'B': AConnection.FTransferMode := tmBlock;
    'C': AConnection.FTransferMode := tmCompressed;
    'S': AConnection.FTransferMode := tmStream;
    'Z': AConnection.FTransferMode := tmDeflate
  else
    RaiseArgumentError(ACommand);
  end;
  
  SendResponse(AConnection, ACommand, '200 Mode %s ok.', [s]);
end;

procedure TclFtpServer.HandleSTRU(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  s: string;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  
  s := UpperCase(Trim(AParameters.Parameters));
  if (Length(s) <> 1) then
  begin
    RaiseArgumentError(ACommand);
  end;
  
  case s[1] of
    'F': AConnection.FTransferStructure := tsFile;
    'R': AConnection.FTransferStructure := tsRecord;
    'P': AConnection.FTransferStructure := tsPage
  else
    RaiseArgumentError(ACommand);
  end;
  
  SendResponse(AConnection, ACommand, '200 STRU %s ok.', [s]);
end;

procedure TclFtpServer.HandleTYPE(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  s: string;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  
  s := UpperCase(Trim(AParameters.Parameters));
  if (Length(s) <> 1) then
  begin
    RaiseArgumentError(ACommand);
  end;
  
  case s[1] of
    'A': AConnection.FTransferType := ttAscii;
    'I': AConnection.FTransferType := ttBinary
  else
    RaiseArgumentError(ACommand);
  end;
  
  SendResponse(AConnection, ACommand, '200 Type %s ok.', [s]);
end;

procedure TclFtpServer.HandleREST(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  AConnection.FDataPosition := StrToIntDef(Trim(AParameters.Parameters), 0);
  SendResponse(AConnection, ACommand, '350 Restarting at %d.', [AConnection.FDataPosition]);
end;

procedure TclFtpServer.GetCertificate(Sender: TObject;
  var ACertificate: TclCertificate; AExtraCerts: TclCertificateList;
  var Handled: Boolean);
begin
  DoGetCertificate(ACertificate, AExtraCerts, Handled);
end;

procedure TclFtpServer.InitDataConnection(AConnection: TclFtpCommandConnection; ADataConnection: TclTcpConnection);
var
  stream: TclTlsNetworkStream;
begin
  AConnection.AssignDataConnection(ADataConnection);

  if (UseTls <> stNone) and AConnection.DataProtection then
  begin
    stream := TclTlsNetworkStream.Create();
    ADataConnection.NetworkStream := stream;
    stream.OnGetCertificate := GetCertificate;
    stream.TlsFlags := TlsFlags;
    stream.RequireClientCertificate := False;
  end else
  begin
    ADataConnection.NetworkStream := TclNetworkStream.Create();
  end;

  ADataConnection.TimeOut := TimeOut;
  ADataConnection.BatchSize := BatchSize;
  ADataConnection.IsReadUntilClose := True;

  ADataConnection.BitsPerSec := AConnection.DataBitsPerSec;
  if (ADataConnection.BitsPerSec = 0) then
  begin
    ADataConnection.BitsPerSec := BitsPerSec;
  end;

  if (AConnection.PassiveMode) then
  begin
    ADataConnection.LocalBinding := AConnection.IP;
  end else
  begin
    ADataConnection.LocalBinding := LocalBinding;
  end;

  ADataConnection.OnProgress := AConnection.DoOnProgress;

  DoInitDataConnection(AConnection);
end;

procedure TclFtpServer.DoInitDataConnection(AConnection: TclFtpCommandConnection);
begin
  if Assigned(OnInitDataConnection) then
  begin
    OnInitDataConnection(Self, AConnection);
  end;
end;

procedure TclFtpServer.HandlePORT(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  parameter: string;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);

  AConnection.FPassiveMode := False;

  parameter := Trim(AParameters.Parameters);
  if (parameter = '') or (WordCount(parameter, [',']) <> 6) then
  begin
    RaiseArgumentError(ACommand);
  end;
  ParseFtpHostStr(parameter, AConnection.FDataIP, AConnection.FDataPort);

  if TclIPAddress4.IsPrivateUseIP(AConnection.FDataIP) and
    (not TclIPAddress4.IsPrivateUseIP(AConnection.PeerIP)) then
  begin
    AConnection.FDataIP := AConnection.PeerIP;
  end;

  if (not IsDataHostValid(AConnection)) then
  begin
    RaiseArgumentError(ACommand);
  end;
  
  InitDataConnection(AConnection, TclTcpClientConnection.Create());
  SendResponse(AConnection, ACommand, '200 PORT command successful.');
end;

procedure TclFtpServer.HandlePASV(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  dataConnection: TclTcpServerConnection;
  host: string;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);

  AConnection.FPassiveMode := True;

  dataConnection := TclTcpServerConnection.Create();
  InitDataConnection(AConnection, dataConnection);

  AConnection.FDataIP := '';

  if (DataPortBegin = 0) or (DataPortEnd = 0) then
  begin
    AConnection.FDataPort := dataConnection.Listen(0);
  end else
  begin
    AConnection.FDataPort := dataConnection.Listen(DataPortBegin, DataPortEnd);
  end;

  host := PassiveHost;
  if (host = '') then
  begin
    host := AConnection.IP;
  end;

  host := GetFtpHostStr(host, AConnection.DataPort);
  SendResponse(AConnection, ACommand, '227 Entering Passive Mode (%s).', [host]);
end;

procedure TclFtpServer.InternalHandleList(AConnection: TclFtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams; ADetails: Boolean);
var
  list: TStrings;
  isAborted: Boolean;
  s: string;
begin
  list := nil;
  try
    CheckTlsMode(AConnection, ACommand);
    CheckAuthorized(AConnection, ACommand);

    list := TStringList.Create();
    CollectDirList(AConnection, ACommand, Trim(AParameters.Parameters), ADetails, list);

    OpenDataConnection(AConnection, ACommand, '150 Opening data connection.');

    try
      s := list.Text;
      AConnection.DataConnection.WriteString(s, GetWriteCharSet(AConnection, s));
    except
      on EclSocketError do
      begin
        AConnection.DataConnection.Abort();
      end;
    end;

    isAborted := AConnection.DataConnection.IsAborted;
  finally
    list.Free();
    AConnection.AssignDataConnection(nil);
  end;

  if (isAborted) then
  begin
    SendResponse(AConnection, ACommand, '426 Connection closed, transfer aborted.');
  end;

  SendResponse(AConnection, ACommand, '226 %s.', [cTransferResult[isAborted]]);
end;

procedure TclFtpServer.HandleLIST(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  InternalHandleList(AConnection, ACommand, AParameters, True);
end;

procedure TclFtpServer.HandleMKD(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  s: string;
  success: Boolean;
  error: string;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  s := Trim(AParameters.Parameters);
  if (s = '') then
  begin
    RaiseArgumentError(ACommand);
  end;
  
  CheckAccessRights(AConnection, ACommand, s, spMakeDir);

  success := True;
  error := '';
  DoCreateDir(AConnection, InternalGetFullPath(AConnection, s), success, error);
  if not success then
  begin
    RaiseFileAccessError(ACommand, s, error);
  end;
  
  SendResponse(AConnection, ACommand, '257 %s directory created.', [s]);
end;

procedure TclFtpServer.DoCreateDir(AConnection: TclFtpCommandConnection;
  const AName: string; var Success: Boolean; var AErrorMessage: string);
begin
  if Assigned(OnCreateDir) then
  begin
    OnCreateDir(Self, AConnection, AName, Success, AErrorMessage);
  end;
end;

function TclFtpServer.InternalGetFullPath(AConnection: TclFtpCommandConnection; const APathName: string): string;
var
  handled: Boolean;
  root, curr: string;
begin
  Result := '';
  handled := False;
  root := GetRootDir(AConnection);
  curr := NormalizePath(AConnection.CurrentDir);
  DoGetFullPath(AConnection, root, curr, APathName, Result, handled);

  if (handled) then Exit;

  if (APathName = '') then
  begin
    Result := curr;
  end else
  if (APathName <> '') and (APathName[1] <> '/') then
  begin
    Result := AddTrailingBackSlash(curr) + NormalizePath(APathName);
  end else
  begin
    Result := NormalizePath(APathName);
  end;

  if (Result <> '') and (Result[1] = '\') then
  begin
    Delete(Result, 1, 1);
  end;

  Result := CombinePath(root, Result);

  Assert(Pos('\\', Result) < 1);

  if (not HasRootDir(root, Result)) then
  begin
    Result := ExtractFileName(NormalizePath(APathName));
    if (Result = '..') then
    begin
      Result := root;
    end else
    begin
      Result := CombinePath(root, Result);
    end;
  end;
end;

procedure TclFtpServer.InternalHandleCwd(AConnection: TclFtpCommandConnection; const ACommand, ANewDir: string);
var
  s: string;
  info: TclFtpFileInfo;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  CheckAccessRights(AConnection, ACommand, ANewDir, spChangeDir);

  s := InternalGetFullPath(AConnection, Trim(ANewDir));
  s := GetRelativePath(AConnection, s);

  s := DenormalizePath(s);
  if (s = '') then
  begin
    s := '/';
  end;

  info := CollectFileInfo(AConnection, ACommand, s);
  try
    if (not info.IsDirectory) then
    begin
      RaiseFileAccessError(ACommand, ANewDir, 'No such file or directory.');
    end;

    AConnection.FCurrentDir := s;
    SendResponse(AConnection, ACommand, '250 CWD command successful.');
  finally
    info.Free();
  end;
end;

procedure TclFtpServer.HandleCDUP(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  InternalHandleCwd(AConnection, ACommand, '..');
end;

procedure TclFtpServer.HandleCWD(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  InternalHandleCwd(AConnection, ACommand, AParameters.Parameters);
end;

procedure TclFtpServer.HandlePWD(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  s: string;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  
  s := AConnection.CurrentDir;
  if (s = '') then
  begin
    s := '/';
  end;
  SendResponse(AConnection, ACommand, '257 "%s" is current directory.', [s]);
end;

procedure TclFtpServer.HandleRMD(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  s: string;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);

  s := Trim(AParameters.Parameters);
  CheckAccessRights(AConnection, ACommand, s, spRemoveDir);

  InternalHandleDelete(AConnection, ACommand, s);
end;

procedure TclFtpServer.InternalHandleDelete(AConnection: TclFtpCommandConnection;
  const ACommand, AFileName: string);
var
  success: Boolean;
  error: string;
begin
  if (AFileName = '') then
  begin
    RaiseArgumentError(ACommand);
  end;

  success := True;
  error := '';
  DoDelete(AConnection, InternalGetFullPath(AConnection, AFileName), success, error);
  if (not success) then
  begin
    RaiseFileAccessError(ACommand, AFileName, error);
  end;

  SendResponse(AConnection, ACommand, '250 %s command successful.', [ACommand]);
end;

procedure TclFtpServer.DoDelete(AConnection: TclFtpCommandConnection;
  const AName: string; var Success: Boolean; var AErrorMessage: string);
begin
  if Assigned(OnDelete) then
  begin
    OnDelete(Self, AConnection, AName, Success, AErrorMessage);
  end;
end;

procedure TclFtpServer.HandleSTOR(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  InternalHandleStor(AConnection, ACommand, AParameters, False, False);
end;

procedure TclFtpServer.HandleSIZE(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  s: string;
  info: TclFtpFileInfo;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);

  s := Trim(AParameters.Parameters);
  if (s = '') then
  begin
    RaiseArgumentError(ACommand);
  end;

  info := CollectFileInfo(AConnection, ACommand, s);
  try
    SendResponse(AConnection, ACommand, '213 %d', [info.Size]);
  finally
    info.Free();
  end
end;

procedure TclFtpServer.HandleMDTM(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  s, d: string;
  info: TclFtpFileInfo;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);

  s := Trim(AParameters.Parameters);
  if (s = '') then
  begin
    RaiseArgumentError(ACommand);
  end;

  info := CollectFileInfo(AConnection, ACommand, s);
  try
    d := '';
    DateTimeToString(d, 'yyyymmddhhnnss', LocalTimeToGlobalTime(info.ModifiedDate));
    SendResponse(AConnection, ACommand, '213 %s', [d]);
  finally
    info.Free();
  end
end;


procedure TclFtpServer.HandleRNFR(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  s: string;
  info: TclFtpFileInfo;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  s := Trim(AParameters.Parameters);
  if (s = '') then
  begin
    RaiseArgumentError(ACommand);
  end;
  CheckAccessRights(AConnection, ACommand, s, spRename);
  AConnection.FCurrentName := s;

  info := CollectFileInfo(AConnection, ACommand, AConnection.FCurrentName);
  try
    SendResponse(AConnection, ACommand, '350 File exists, ready for destination name');
  finally
    info.Free();
  end
end;

procedure TclFtpServer.HandleRNTO(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  curName, newName: string;
  success: Boolean;
  error: string;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  if (AConnection.FCurrentName = '') then
  begin
    RaiseFtpError(ACommand, 'Bad sequence of commands.', 503);
  end;

  curName := AConnection.FCurrentName;
  newName := Trim(AParameters.Parameters);
  if (newName = '') then
  begin
    RaiseArgumentError(ACommand);
  end;
  CheckAccessRights(AConnection, ACommand, newName, spRename);

  success := True;
  error := '';
  DoRename(AConnection, InternalGetFullPath(AConnection, curName), InternalGetFullPath(AConnection, newName), success, error);
  if not success then
  begin
    RaiseFileAccessError(ACommand, newName, error);
  end;
  SendResponse(AConnection, ACommand, '250 RNTO command successful.');
end;

procedure TclFtpServer.DoRename(AConnection: TclFtpCommandConnection;
  const ACurrentName, ANewName: string; var Success: Boolean; var AErrorMessage: string);
begin
  if Assigned(OnRename) then
  begin
    OnRename(Self, AConnection, ACurrentName, ANewName, Success, AErrorMessage);
  end;
end;

procedure TclFtpServer.DoSiteCommand(AConnection: TclFtpCommandConnection; const AParameters: string; AResponse: TStrings;
  var AStatusCode: Integer);
begin
  if Assigned(OnSiteCommand) then
  begin
    OnSiteCommand(Self, AConnection, AParameters, AResponse, AStatusCode);
  end;
end;

procedure TclFtpServer.HandleNLST(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  InternalHandleList(AConnection, ACommand, AParameters, False);
end;

procedure TclFtpServer.HandleDELE(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  s: string;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);

  s := Trim(AParameters.Parameters);
  CheckAccessRights(AConnection, ACommand, s, spDelete);

  InternalHandleDelete(AConnection, ACommand, s);
end;

procedure TclFtpServer.HandleFEAT(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  features: TStrings;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);

  features := TStringList.Create();
  try
    features.Add('FEAT');
    features.AddStrings(Extensions);
    features.Add('END');

    SendMultipleResponse(AConnection, features, 211);
  except
    features.Free();
    raise;
  end;
end;

procedure TclFtpServer.HandleRETR(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  stream: TStream;
  fileName, errorMessage, responseMessage: string;
  status: TclFtpFileTransferStatus;
  success: Boolean;
  size: Int64;
begin
  try
    CheckTlsMode(AConnection, ACommand);
    CheckAuthorized(AConnection, ACommand);

    fileName := Trim(AParameters.Parameters);
    CheckAccessRights(AConnection, ACommand, fileName, spDownload);

    fileName := InternalGetFullPath(AConnection, fileName);

    if (fileName = '') then
    begin
      RaiseArgumentError(ACommand);
    end;

    errorMessage := '';
    responseMessage := '';
    status := tsSuccess;
    size := 0;
    try
      try
        stream := nil;
        try
          success := True;
          DoGetFile(AConnection, fileName, stream, success, errorMessage);

          if (not success) or (stream = nil) then
          begin
            RaiseFileAccessError(ACommand, ExtractFileName(fileName), errorMessage);
          end;

          size := stream.Size;

          if ((AConnection.DataPosition > 0) and (AConnection.DataPosition < size)) then
          begin
            stream.Position := AConnection.DataPosition;
          end;

          OpenDataConnection(AConnection, ACommand, Format('150 Opening data connection for %s(%d bytes).', [ExtractFileName(fileName), size]));

          try
            AConnection.DataConnection.WriteData(stream);
          except
            on EclSocketError do
            begin
              AConnection.DataConnection.Abort();
            end;
          end;
        finally
          stream.Free();
        end;

        if (AConnection.DataConnection.IsAborted) then
        begin
          status := tsAbort;
        end;

        DoGetFileDone(AConnection, fileName, size, status, errorMessage, responseMessage);
      except
        on E: Exception do
        begin
          status := tsFail;
          errorMessage := E.Message;
          DoGetFileDone(AConnection, fileName, size, status, errorMessage, responseMessage);
          if (status = tsFail) then raise;
        end;
      end;
    finally
      AConnection.AssignDataConnection(nil);
    end;

    if (status = tsFail) then
    begin
      RaiseFtpError(ACommand, errorMessage, 500);
    end;

    if (status = tsAbort) then
    begin
      SendResponse(AConnection, ACommand, '426 Connection closed, transfer aborted.');
    end;

    if (responseMessage = '') then
    begin
      responseMessage := cTransferResult[status = tsAbort];
    end;

    SendResponse(AConnection, ACommand, '226 %s.', [responseMessage]);
  finally
    AConnection.AssignDataConnection(nil);
  end;
end;

procedure TclFtpServer.DoGetFile(AConnection: TclFtpCommandConnection; const AFileName: string;
  var ASource: TStream; var Success: Boolean; var AErrorMessage: string);
begin
  if Assigned(OnGetFile) then
  begin
    OnGetFile(Self, AConnection, AFileName, ASource, Success, AErrorMessage);
  end;
end;

procedure TclFtpServer.DoGetFileDone(AConnection: TclFtpCommandConnection; const AFileName: string;
  AFileSize: Int64; var AStatus: TclFtpFileTransferStatus; var AErrorMessage, AResponseMessage: string);
begin
  if Assigned(OnGetFileDone) then
  begin
    OnGetFileDone(Self, AConnection, AFileName, AFileSize, AStatus, AErrorMessage, AResponseMessage);
  end;
end;

procedure TclFtpServer.RaiseFileAccessError(const ACommand, AFileName, AMessage: string);
var
  msg: string;
begin
  msg := AMessage;
  if (msg = '') then
  begin
    msg := 'failed';
  end;
  RaiseFtpError(ACommand, AFileName + ': ' + msg, 550);
end;

procedure TclFtpServer.RaiseArgumentError(const ACommand: string);
begin
  RaiseFtpError(ACommand, 'invalid argument', 501);
end;

procedure TclFtpServer.RaiseDataConnectionError(const ACommand: string);
begin
  RaiseFtpError(ACommand, 'Can not open data connection', 425);
end;

procedure TclFtpServer.SetUserAccounts(const Value: TclFtpUserAccountList);
begin
  FUserAccounts.Assign(Value);
end;

function TclFtpServer.GetCaseInsensitive: Boolean;
begin
  Result := FUserAccounts.CaseInsensitive;
end;

procedure TclFtpServer.SendMultipleResponse(AConnection: TclFtpCommandConnection; AResponse: TStrings; AStatusCode: Integer);
var
  i: Integer;
begin
  Assert(AResponse.Count > 0);

  if (AResponse.Count > 1) then
  begin
    AResponse[0] := IntToStr(AStatusCode) + '-' + AResponse[0];
  end;
  AResponse[AResponse.Count - 1] := IntToStr(AStatusCode) + ' ' + AResponse[AResponse.Count - 1];

  for i := 1 to AResponse.Count - 2 do
  begin
    if (Length(AResponse[i]) > 0) and (AResponse[i][1] <> ' ') then
    begin
      AResponse[i] := '    ' + AResponse[i];
    end;
  end;

  SendMultipleLines(AConnection, AResponse, '');
end;

procedure TclFtpServer.SetCaseInsensitive(const Value: Boolean);
begin
  FUserAccounts.CaseInsensitive := Value;
end;

procedure TclFtpServer.SetExtensions(const Value: TStrings);
begin
  FExtensions.Assign(Value);
end;

procedure TclFtpServer.HandleSITE(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  response: TStrings;
  statusCode: Integer;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);

  statusCode := 214;
  response := TStringList.Create();
  try
    DoSiteCommand(AConnection, AParameters.Parameters, response, statusCode);

    if (response.Count = 0) then
    begin
      response.Add('The following SITE commands are recognized.');
      response.Add('HELP command successful.');
      statusCode := 214;
    end;
    SendMultipleResponse(AConnection, response, statusCode);
  except
    response.Free();
    raise;
  end;
end;

procedure TclFtpServer.HandleNOOP(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  SendResponse(AConnection, ACommand, '200 NOOP command successful.');
end;

procedure TclFtpServer.DoHelpCommand(AConnection: TclFtpCommandConnection;
  const AParameters: string; AHelpText: TStrings);
begin
  if Assigned(OnHelpCommand) then
  begin
    OnHelpCommand(Self, AConnection, AParameters, AHelpText);
  end;
end;

procedure TclFtpServer.HandleHELP(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  helpText: TStrings;
begin
  helpText := TStringList.Create();
  try
    DoHelpCommand(AConnection, AParameters.Parameters, helpText);

    if(helpText.Count = 0) then
    begin
      helpText.Add('The following commands are recognized');
      helpText.Add('HELP command successful.');
    end;
    SendMultipleResponse(AConnection, helpText, 214);
  except
    helpText.Free();
    raise;
  end;
end;

procedure TclFtpServer.HandleREIN(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  AConnection.InitParams();
  SendResponse(AConnection, ACommand, '220 Service ready for new user.');
end;

procedure TclFtpServer.HandleSTAT(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
const
  TransferTypes: array[TclFtpTransferType] of string = ('ASCII', 'BINARY');
  TransferForms: array[TclFtpTransferType] of string = ('Print', 'Nonprint');
  TransferStructs: array[TclFtpTransferStructure] of string = ('File', 'Record', 'Page');
  TransferModes: array[TclFtpTransferMode] of string = ('BLOCK', 'COMPRESSED', 'STREAM', 'DEFLATE');

var
  list: TStrings;
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  list := TStringList.Create();
  try
    list.Add('211-FTP Service status:');
    list.Add('     Connected to ' + AConnection.PeerIP);
    list.Add('     Logged in as ' + AConnection.UserName);
    list.Add(Format('     TYPE: %s, FORM: %s; STRUcture: %s; transfer MODE: %s',
      [
        TransferTypes[AConnection.TransferType],
        TransferForms[AConnection.TransferType],
        TransferStructs[AConnection.TransferStructure],
        TransferModes[AConnection.TransferMode]
      ]));
    if (AConnection.DataConnection = nil) then
    begin
      list.Add('     No data connection');
    end;

    SendMultipleLines(AConnection, list, '211 End of status.');
  except
    list.Free();
    raise;
  end;
end;

procedure TclFtpServer.HandleSYST(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  SendResponse(AConnection, ACommand, '215 ' + ServerOS);
end;

procedure TclFtpServer.HandleAPPE(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  InternalHandleStor(AConnection, ACommand, AParameters, True, False);
end;

function TclFtpServer.IsFileExist(AConnection: TclFtpCommandConnection;
  const ACommand, AFileName: string): Boolean;
begin
  Result := False;
  try
    CollectFileInfo(AConnection, ACommand, AFileName).Free();
    Result := True;
  except
    on EclTcpCommandServerError do;
  end;
end;

function TclFtpServer.NormalizePath(const APath: string): string;
begin
  Result := StringReplace(APath, '/', '\', [rfReplaceAll]);
  if (Result <> '') and (Result[Length(Result)] = '\') then
  begin
    Delete(Result, Length(Result), 1);
  end;
end;

procedure TclFtpServer.OpenDataConnection(AConnection: TclFtpCommandConnection; const ACommand, AResponse: string);
begin
  if (AConnection.FDataConnection = nil) then
  begin
    RaiseDataConnectionError(ACommand);
  end;

  if AConnection.PassiveMode then
  begin
    SendResponse(AConnection, ACommand, AResponse);
    TclTcpServerConnection(AConnection.DataConnection).Accept();
  end else
  begin
    TclTcpClientConnection(AConnection.DataConnection).Open(AConnection.DataIP, AConnection.DataPort);
    SendResponse(AConnection, ACommand, AResponse);
  end;
end;

procedure TclFtpServer.InternalHandleStor(AConnection: TclFtpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams; Append, ACreateUnique: Boolean);
var
  stream: TStream;
  fileName, errorMessage, responseMessage: string;
  success, isAppend: Boolean;
  status: TclFtpFileTransferStatus;
  size: Int64;
begin
  try
    CheckTlsMode(AConnection, ACommand);
    CheckAuthorized(AConnection, ACommand);
    fileName := GetDestinationFileName(AConnection, ACommand, ACreateUnique, Trim(AParameters.Parameters));
    CheckAccessRights(AConnection, ACommand, ExtractFileName(fileName), spUpload);

    OpenDataConnection(AConnection, ACommand, Format('150 Opening data connection for %s.',
      [ExtractFileName(fileName)]));

    try
      errorMessage := '';
      responseMessage := '';
      status := tsSuccess;
      size := 0;
      try
        isAppend := (AConnection.DataPosition > 0) or Append;
        stream := nil;
        try
          success := True;
          DoPutFile(AConnection, fileName, not isAppend, stream, success, errorMessage);

          if (not success) or (stream = nil) then
          begin
            RaiseFileAccessError(ACommand, ExtractFileName(fileName), errorMessage);
          end;

          if (isAppend) then
          begin
            if ((AConnection.DataPosition > 0) and (AConnection.DataPosition < stream.Size)) then
            begin
              stream.Position := AConnection.DataPosition;
            end else
            begin
              stream.Position := stream.Size;
            end;
          end;

          try
            AConnection.DataConnection.ReadData(stream);

            DoPutFileReady(AConnection, fileName, stream);
          except
            on EclSocketError do
            begin
              AConnection.DataConnection.Abort();
            end;
          end;
        finally
          size := stream.Size;
          stream.Free();
        end;
        if (AConnection.DataConnection.IsAborted) then
        begin
          status := tsAbort;
        end;

        DoPutFileDone(AConnection, fileName, size, status, errorMessage, responseMessage);
      except
        on E: Exception do
        begin
          status := tsFail;
          errorMessage := E.Message;
          DoPutFileDone(AConnection, fileName, size, status, errorMessage, responseMessage);
          if (status = tsFail) then raise;
        end;
      end;
    finally
      AConnection.AssignDataConnection(nil);
    end;

    if (status = tsFail) then
    begin
      RaiseFtpError(ACommand, errorMessage, 500);
    end;

    if (status = tsAbort) then
    begin
      SendResponse(AConnection, ACommand, '426 Connection closed, transfer aborted.');
    end;

    if (responseMessage = '') then
    begin
      responseMessage := cTransferResult[status = tsAbort];
    end;

    SendResponse(AConnection, ACommand, '226 %s.', [responseMessage]);
  finally
    AConnection.AssignDataConnection(nil);
  end;
end;

procedure TclFtpServer.DoPutFile(AConnection: TclFtpCommandConnection; const AFileName: string;
  AOverwrite: Boolean; var ADestination: TStream; var Success: Boolean; var AErrorMessage: string);
begin
  if Assigned(OnPutFile) then
  begin
    OnPutFile(Self, AConnection, AFileName, AOverwrite, ADestination, Success, AErrorMessage);
  end;
end;

procedure TclFtpServer.DoPutFileDone(AConnection: TclFtpCommandConnection; const AFileName: string;
  AFileSize: Int64; var AStatus: TclFtpFileTransferStatus; var AErrorMessage, AResponseMessage: string);
begin
  if Assigned(OnPutFileDone) then
  begin
    OnPutFileDone(Self, AConnection, AFileName, AFileSize, AStatus, AErrorMessage, AResponseMessage);
  end;
end;

procedure TclFtpServer.DoPutFileReady(AConnection: TclFtpCommandConnection; const AFileName: string; ASource: TStream);
begin
  if Assigned(OnPutFileReady) then
  begin
    OnPutFileReady(Self, AConnection, AFileName, ASource);
  end;
end;

procedure TclFtpServer.HandleSTOU(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  AConnection.FDataPosition := 0;
  InternalHandleStor(AConnection, ACommand, AParameters, False, True);
end;

procedure TclFtpServer.HandleABOR(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  AConnection.FDataConnectionAccess.Enter();
  try
    if (AConnection.FDataConnection <> nil) then
    begin
      AConnection.FDataConnection.Abort();
    end;
  finally
    AConnection.FDataConnectionAccess.Leave();
  end;
end;

procedure TclFtpServer.DoDestroy;
begin
  FExtensions.Free();
  FUserAccounts.Free();
  
  inherited DoDestroy();
end;

function TclFtpServer.GetNullCommand(AParameters: TclTcpCommandParams): TclTcpCommandInfo;
begin
  Result := TclFtpCommandInfo.Create(AParameters.Command, HandleNullCommand);
end;

function TclFtpServer.GetRelativePath(AConnection: TclFtpCommandConnection; const APathName: string): string;
begin
  Result := GetRootDir(AConnection);

  if (HasRootDir(Result, APathName)) then
  begin
    Result := Copy(APathName, Length(Result) + 1, Length(APathName));
  end else
  begin
    Result := '';
  end;
end;

function TclFtpServer.GetRootDir(AConnection: TclFtpCommandConnection): string;
begin
  Result := AConnection.RootDir;
  if (Result = '') then
  begin
    Result := RootDir;
  end;
end;

procedure TclFtpServer.HandleNullCommand(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  RaiseFtpError(ACommand, 'Command not implemented.', 502);
end;

procedure TclFtpServer.HandleOPTS(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  CheckTlsMode(AConnection, ACommand);
  CheckAuthorized(AConnection, ACommand);
  RaiseFtpError(ACommand, 'Option not supported.', 501);
end;

procedure TclFtpServer.ProcessUnhandledError(AConnection: TclCommandConnection;
  AParameters: TclTcpCommandParams; E: Exception);
begin
  SendResponse(AConnection, AParameters.Command, '451 Requested action aborted: ' + Trim(E.Message));
end;

procedure TclFtpServer.CheckAuthorized(AConnection: TclFtpCommandConnection; const ACommand: string);
begin
  if not AConnection.IsAuthorized then
  begin
    RaiseFtpError(ACommand, 'Not logged in.', 530);
  end;
end;

procedure TclFtpServer.CheckAccessRights(AConnection: TclFtpCommandConnection; const ACommand, AName: string;
  ARequired: TclFtpServerPermission);
begin
  if (AConnection.Permissions = [spAll]) then Exit;

  if not (ARequired in AConnection.Permissions) then
  begin
    RaiseFtpError(ACommand, Format('%s: Access is denied.', [AName]), 550);
  end;
end;

procedure TclFtpServer.HandlePBSZ(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
begin
  SendResponse(AConnection, ACommand, '200 Protection buffer size set to 0');
end;

procedure TclFtpServer.HandlePROT(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  s: string;
begin
  s := UpperCase(Trim(AParameters.Parameters));
  case s[1] of
    'C':
      begin
        AConnection.FDataProtection := False;
        SendResponse(AConnection, ACommand, '200 Data channel will be clear text');
      end;
    'P':
      begin
        AConnection.FDataProtection := True;
        SendResponse(AConnection, ACommand, '200 Data channel will be encrypted');
      end;
  else
    RaiseFtpError(ACommand, 'Unsupported option', 536);
  end;
end;

procedure TclFtpServer.HandleAUTH(AConnection: TclFtpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
var
  s: string;
begin
  if (UseTLS = stNone) then
  begin
    RaiseFtpError(ACommand, 'SSL encryption disabled', 500);
  end;
  if (UseTLS = stImplicit) then
  begin
    RaiseFtpError(ACommand, 'Secure mode is already started.', 500);
  end;
  s := UpperCase(Trim(AParameters.Parameters));
  if (s <> 'TLS') and (s <> 'SSL') then
  begin
    RaiseFtpError(ACommand, 'Unknown auth method ' + s, 504);
  end;

  StartTls(AConnection);
  
  SendResponse(AConnection, ACommand, '234 Enabling SSL');
end;

procedure TclFtpServer.CheckTlsMode(AConnection: TclFtpCommandConnection; const ACommand: string);
begin
  if (UseTLS = stExplicitRequire) and (not AConnection.IsTls) then
  begin
    RaiseFtpError(ACommand, 'Sorry SSL encryption is required', 500);
  end;
end;

{ TclFtpCommandConnection }

procedure TclFtpCommandConnection.AssignDataConnection(AConnection: TclTcpConnection);
begin
  FDataConnectionAccess.Enter();
  try
    if (FDataConnection <> nil) then
    begin
      FDataConnection.Close(True);
      FDataConnection.Free();
    end;
    FDataConnection := AConnection;
    FDataPosition := 0;
  finally
    FDataConnectionAccess.Leave();
  end;
end;

constructor TclFtpCommandConnection.Create;
begin
  inherited Create();
  FDataConnectionAccess := TCriticalSection.Create();
  InitParams();
end;

procedure TclFtpCommandConnection.InitParams;
begin
  FTransferMode := tmStream;
  FTransferStructure := tsFile;
  FTransferType := ttAscii;
  FCurrentDir := '/';
  FIsAuthorized := False;
  FPermissions := [spAll];
  FDataPosition := 0;
  FCurrentName := '';
  FUserName := '';
  FRootDir := '';
  FDataPort := 0;
  FDataIP := '';
  FPassiveMode := False;
  FDataProtection := False;
  FDataBitsPerSec := 0;
end;

procedure TclFtpCommandConnection.DoDestroy;
begin
  BeginWork();
  try
    AssignDataConnection(nil);
  finally
    EndWork();
  end;
  FDataConnectionAccess.Free();
  inherited DoDestroy();
end;

procedure TclFtpCommandConnection.DoOnProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
begin
  UpdateTimeTicks();
end;

{ TclFtpUserAccountItem }

procedure TclFtpUserAccountItem.Assign(Source: TPersistent);
var
  account: TclFtpUserAccountItem;
begin
  inherited Assign(Source);
  if (Source is TclFtpUserAccountItem) then
  begin
    account := (Source as TclFtpUserAccountItem);
    FPermissions := account.Permissions;
    FRootDir := account.RootDir;
    FBitsPerSec := account.BitsPerSec;
  end;
end;

constructor TclFtpUserAccountItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FPermissions := [spAll];
end;

procedure TclFtpUserAccountItem.SetRootDir(const Value: string);
begin
  if (FRootDir <> Value) then
  begin
    FRootDir := Value;
    if (FRootDir <> '') and (FRootDir[Length(FRootDir)] = '\') then
    begin
      Delete(FRootDir, Length(FRootDir), 1);
    end;
  end;
end;

{ TclFtpCommandInfo }

constructor TclFtpCommandInfo.Create(const AName: string; AHandler: TclFtpCommandHandler);
begin
  inherited Create(AName);
  FHandler := AHandler;
end;

constructor TclFtpCommandInfo.Create(const AName: string; AHandler: TclFtpCommandHandler; AIsOOB: Boolean);
begin
  inherited Create(AName, AIsOOB);
  FHandler := AHandler;
end;

procedure TclFtpCommandInfo.Execute(AConnection: TclCommandConnection; AParams: TclTcpCommandParams);
begin
  FHandler(AConnection as TclFtpCommandConnection, Name, AParams);
end;

{ TclFtpUserAccountList }

function TclFtpUserAccountList.AccountByUserName(const AUserName: string): TclFtpUserAccountItem;
begin
  Result := inherited AccountByUserName(AUserName) as TclFtpUserAccountItem;
end;

function TclFtpUserAccountList.Add: TclFtpUserAccountItem;
begin
  Result := TclFtpUserAccountItem(inherited Add());
end;

function TclFtpUserAccountList.GetItem(Index: Integer): TclFtpUserAccountItem;
begin
  Result := TclFtpUserAccountItem(inherited GetItem(Index));
end;

procedure TclFtpUserAccountList.SetItem(Index: Integer; const Value: TclFtpUserAccountItem);
begin
  inherited SetItem(Index, Value);
end;

end.
