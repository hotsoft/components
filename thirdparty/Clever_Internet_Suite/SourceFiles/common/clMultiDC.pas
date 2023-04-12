{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clMultiDC;

interface

{$I clVer.inc}

{$IFDEF DELPHIXE2}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows,
{$ELSE}
  System.Classes, Winapi.Windows, System.Types,
{$ENDIF}
  clWinInet, clDC, clDCUtils, clUtils, clInternetConnection, clHttpRequest,
  clCryptApi, clCertificate, clSspiTls, clFtpUtils, clHttpUtils, clUriUtils, clWUtils, clResourceState;

type
  TclInternetItem = class;

  TclOnMultiStatusChanged = procedure (Sender: TObject; Item: TclInternetItem;
    Status: TclProcessStatus) of object;
  TclOnMultiDataItemProceed = procedure (Sender: TObject; Item: TclInternetItem;
    ResourceInfo: TclResourceInfo; AStateItem: TclResourceStateItem; CurrentData: PclChar;
    CurrentDataSize: Integer) of object;
  TclOnMultiError = procedure (Sender: TObject; Item: TclInternetItem; const Error: string;
    ErrorCode: Integer) of object;
  TclOnMultiGetResourceInfo = procedure (Sender: TObject; Item: TclInternetItem;
    ResourceInfo: TclResourceInfo) of object;
  TclOnMultiURLParsing = procedure (Sender: TObject; Item: TclInternetItem;
    var URLComponents: TURLComponents) of object;
  TclOnMultiNotifyEvent = procedure (Sender: TObject; Item: TclInternetItem) of object;
  TclOnMultiGetCertificate = procedure (Sender: TObject; Item: TclInternetItem;
    var ACertificate: TclCertificate; AExtraCerts: TclCertificateList; var Handled: Boolean) of object;

  TclCustomInternetControl = class;

  TclInternetItem = class(TCollectionItem)
  private
    FDataStream: TStream;
    FSelfDataStream: TStream;
    FThreaderList: TList;
    FPassword: string;
    FUserName: string;
    FURL: string;
    FLastStatus: TclProcessStatus;
    FPriority: TclProcessPriority;
    FResourceInfo: TclResourceInfo;
    FErrors: TclErrorList;
    FCertificateFlags: TclCertificateVerifyFlags;
    FThreadCount: Integer;
    FResourceState: TclResourceStateList;
    FKeepConnection: Boolean;
    FSelfConnection: TclInternetConnection;
    FData: Pointer;
    FHttpRequest: TclHttpRequest;
    FUseHttpRequest: Boolean;
    FHttpResponseHeader: TStrings;
    FPort: Integer;
    FIsCommit: Boolean;

    procedure DoOnResourceStateChanged(Sender: TObject);
    procedure DoOnURLParsing(Sender: TObject; var URLComponents: TURLComponents);
    procedure DoOnGetResourceInfo(Sender: TObject; AResourceInfo: TclResourceInfo);
    procedure DoOnDataItemProceed(Sender: TObject; AResourceInfo: TclResourceInfo;
      BytesProceed: Int64; CurrentData: PclChar; CurrentDataSize: Integer);
    procedure DoOnError(Sender: TObject; const Error: string; ErrorCode: Integer);
    procedure DoOnStatusChanged(Sender: TObject; Status: TclProcessStatus);
    procedure DoOnTerminate(Sender: TObject);
    procedure DoOnGetCertificate(Sender: TObject; var ACertificate: TclCertificate;
      AExtraCerts: TclCertificateList; var Handled: Boolean);
    procedure ClearInfo;
    procedure ClearDataStream;
    procedure ClearThreaderList;
    procedure SetDataStream(const Value: TStream);
    function GetInternalDataStream: TStream;
    function GetIsBusy: Boolean;
    procedure Wait;
    procedure RemoveThreader(Index: Integer);
    procedure SetMaxConnectionsOption;
    procedure SetThreadCount(const Value: Integer);
    function GetConnection: TclInternetConnection;
    function FindFirstFailedItem(APrevThreader: TclCustomThreader): TclResourceStateItem;
    procedure ReTryFailedItem(AStateItem: TclResourceStateItem; AURLParser: TclUrlParser);
    procedure SetHttpRequest(const Value: TclHttpRequest);
    function GetResourceConnections(Index: Integer): TclInternetConnection;
    function GetResourceConnectionCount: Integer;
    procedure AssignThreader(AThreader: TclCustomThreader);
  protected
    FLocalFile: string;
    procedure InternalSetHttpRequest(const Value: TclHttpRequest);
    function IsSharedConnection: Boolean;
    function FindStateItem(AThreader: TclCustomThreader): TclResourceStateItem;
    procedure DoError(const Error: string; ErrorCode: Integer);
    function GetBatchSize: Integer;
    function GetDefaultChar: Char;
    procedure ClearResourceState;
    function AddThreader(AStateItem: TclResourceStateItem; AIsGetResourceInfo: Boolean): TclCustomThreader;
    function CanProcess: Boolean; virtual;
    function CheckSizeValid(ASize: Int64): Boolean;
    procedure AssignThreaderEvents(AThreader: TclCustomThreader); virtual;
    procedure AssignThreaderParams(AThreader: TclCustomThreader); virtual;
    function GetControl: TclCustomInternetControl; virtual; abstract;
    function GetDataStream: TStream; virtual; abstract;
    function CreateThreader(ADataStream: TStream; AIsGetResourceInfo: Boolean): TclCustomThreader; virtual; abstract;
    procedure InternalStart(AIsGetResourceInfo: Boolean); virtual;
    procedure SetLocalFile(const Value: string); virtual;
    procedure SetPassword(const Value: string); virtual;
    procedure SetURL(const Value: string); virtual;
    procedure SetUserName(const Value: string); virtual;
    procedure SetPort(const Value: Integer); virtual;
    procedure ThreaderTerminated(AThreader: TclCustomThreader); virtual;
    procedure ProcessCompleted(AThreader: TclCustomThreader); virtual;
    procedure LastStatusChanged(Status: TclProcessStatus); virtual;
    procedure DoGetResourceInfo(AResourceInfo: TclResourceInfo); virtual;
    procedure ControlChanged; virtual;
    procedure SetInternalDataStream(const ADataStream: TStream);
    procedure CommitWork; virtual;
    procedure DoCreate; virtual;
    procedure DoDestroy; virtual;
    procedure SetUseHttpRequest(const Value: Boolean); virtual;
    property IsCommit: Boolean read FIsCommit;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure Start(IsAsynch: Boolean);
    function GetResourceInfo(IsAsynch: Boolean): TclResourceInfo;
    procedure Stop;
    procedure CloseConnection;
    procedure DeleteRemoteFile;
    function GetThreader(Index: Integer): TclCustomThreader;
    property DataStream: TStream read GetInternalDataStream write SetDataStream;
    property IsBusy: Boolean read GetIsBusy;
    property Control: TclCustomInternetControl read GetControl;
    property Errors: TclErrorList read FErrors;
    property ResourceInfo: TclResourceInfo read FResourceInfo;
    property ResourceState: TclResourceStateList read FResourceState;
    property ResourceConnections[Index: Integer]: TclInternetConnection read GetResourceConnections;
    property ResourceConnectionCount: Integer read GetResourceConnectionCount;
    property Data: Pointer read FData write FData;
  published
    property ThreadCount: Integer read FThreadCount write SetThreadCount default DefaultThreadCount;
    property KeepConnection: Boolean read FKeepConnection write FKeepConnection default False;
    property URL: string read FURL write SetURL;
    property LocalFile: string read FLocalFile write SetLocalFile;
    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;
    property Port: Integer read FPort write SetPort default 0;
    property Priority: TclProcessPriority read FPriority write FPriority default ppNormal;
    property CertificateFlags: TclCertificateVerifyFlags read FCertificateFlags write FCertificateFlags default [];
    property HttpRequest: TclHttpRequest read FHttpRequest write SetHttpRequest;
    property HttpResponseHeader: TStrings read FHttpResponseHeader;
    property UseHttpRequest: Boolean read FUseHttpRequest write SetUseHttpRequest default False;
  end;

  TclInternetItemClass = class of TclInternetItem;

  TclControlNotifier = class
  private
    FControl: TclCustomInternetControl;
  protected
    procedure DoResourceStateChanged(Item: TclInternetItem); virtual;
    procedure DoStatusChanged(Item: TclInternetItem; Status: TclProcessStatus); virtual;
    procedure DoDataItemProceed(Item: TclInternetItem; ResourceInfo: TclResourceInfo;
      AStateItem: TclResourceStateItem; CurrentData: PclChar; CurrentDataSize: Integer); virtual;
    procedure DoItemDeleted(Item: TclInternetItem); virtual;
  public
    constructor Create(AControl: TclCustomInternetControl);
    destructor Destroy; override;
  end;

  TclCustomInternetControl = class(TComponent)
  private
    FIsBusyCount: Integer;
    FTryCount: Integer;
    FBatchSize: Integer;
    FTimeOut: Integer;
    FOnIsBusyChanged: TNotifyEvent;
    FMinResourceSize: Int64;
    FMaxResourceSize: Int64;
    FProxyBypass: TStrings;
    FInternetAgent: string;
    FDefaultChar: Char;
    FPassiveFTPMode: Boolean;
    FNotifierList: TList;
    FReconnectAfter: Integer;
    FConnection: TclInternetConnection;
    FDoNotGetResourceInfo: Boolean;
    FFtpProxySettings: TclFtpProxySettings;
    FHttpProxySettings: TclHttpProxySettings;
    FUseInternetErrorDialog: Boolean;
    
    procedure SetBatchSize(const Value: Integer);
    procedure SetTryCount(const Value: Integer);
    procedure SetTimeOut(const Value: Integer);
    procedure SetReconnectAfter(const Value: Integer);
    function GetIsBusy: Boolean;
    procedure SetMaxResourceSize(const Value: Int64);
    procedure SetMinResourceSize(const Value: Int64);
    procedure SetDefaultChar(const Value: Char);
    function GetControlNotifier(Index: Integer): TclControlNotifier;
    procedure RegisterControlNotifier(ANotifier: TclControlNotifier);
    procedure UnregisterControlNotifier(ANotifier: TclControlNotifier);
    procedure SetConnection(const Value: TclInternetConnection);
    procedure SetFtpProxySettings(const Value: TclFtpProxySettings);
    procedure SetHttpProxySettings(const Value: TclHttpProxySettings);
    procedure SetProxyBypass(const Value: TStrings);
  protected
    procedure BeginIsBusy;
    procedure EndIsBusy;
    procedure DoStopItem(Item: TclInternetItem); virtual;
    procedure DoItemCreated(Item: TclInternetItem); virtual;
    procedure DoItemDeleted(Item: TclInternetItem); virtual;
    function CanProcess(Item: TclInternetItem): Boolean; virtual;
    procedure StartNextItem(APrevItem: TclInternetItem); virtual;
    function CanStartItem(Item: TclInternetItem; AIsGetResourceInfo, IsAsynch: Boolean): Boolean; virtual;
    procedure NotifyInternetItems(AComponent: TComponent); virtual; abstract;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Loaded; override;
    procedure IsBusyChanged; dynamic;
    procedure Changed(Item: TclInternetItem); dynamic;
    procedure DoResourceStateChanged(Item: TclInternetItem); dynamic;
    procedure DoGetCertificate(Item: TclInternetItem; var ACertificate: TclCertificate;
      AExtraCerts: TclCertificateList; var Handled: Boolean); dynamic;
    procedure DoURLParsing(Item: TclInternetItem; var URLComponents: TURLComponents); dynamic;
    procedure DoGetResourceInfo(Item: TclInternetItem; AResourceInfo: TclResourceInfo); dynamic;
    procedure DoStatusChanged(Item: TclInternetItem; Status: TclProcessStatus); dynamic;
    procedure DoDataItemProceed(Item: TclInternetItem; ResourceInfo: TclResourceInfo;
      AStateItem: TclResourceStateItem; CurrentData: PclChar; CurrentDataSize: Integer); dynamic;
    procedure DoError(Item: TclInternetItem; const Error: string; ErrorCode: Integer); dynamic;
    procedure DoProcessCompleted(Item: TclInternetItem); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property IsBusy: Boolean read GetIsBusy;
    procedure ReadRegistry(const APath: string); virtual;
    procedure WriteRegistry(const APath: string); virtual;
    procedure GetFtpDirList(const ADir, AUser, APassword: string; AList: TStrings; ADetails: Boolean);

    class procedure SetCookie(const AURL, AName, AValue: string);
    class function GetCookie(const AURL, AName: string): string;
    class procedure GetAllCookies(const AURL: string; AList: TStrings);

    class procedure FlushIESession;

    class procedure EnumIECacheEntries(AList: TStrings);
    class procedure GetIECacheEntryHeader(const AUrl: string; AList: TStrings);
    class procedure GetIECacheFile(const AUrl: string; AStream: TStream);
  published
    property TryCount: Integer read FTryCount write SetTryCount default DefaultTryCount;
    property BatchSize: Integer read FBatchSize write SetBatchSize default DefaultBatchSize;
    property TimeOut: Integer read FTimeOut write SetTimeOut default DefaultTimeOut;
    property ReconnectAfter: Integer read FReconnectAfter write SetReconnectAfter default DefaultTimeOut;
    property MinResourceSize: Int64 read FMinResourceSize write SetMinResourceSize default 0;
    property MaxResourceSize: Int64 read FMaxResourceSize write SetMaxResourceSize default 0;
    property HttpProxySettings: TclHttpProxySettings read FHttpProxySettings write SetHttpProxySettings;
    property FtpProxySettings: TclFtpProxySettings read FFtpProxySettings write SetFtpProxySettings;
    property ProxyBypass: TStrings read FProxyBypass write SetProxyBypass;
    property InternetAgent: string read FInternetAgent write FInternetAgent;
    property DefaultChar: Char read FDefaultChar write SetDefaultChar default DefaultPreviewChar;
    property PassiveFTPMode: Boolean read FPassiveFTPMode write FPassiveFTPMode default False;
    property Connection: TclInternetConnection read FConnection write SetConnection;
    property DoNotGetResourceInfo: Boolean read FDoNotGetResourceInfo write FDoNotGetResourceInfo default False;
    property UseInternetErrorDialog: Boolean read FUseInternetErrorDialog write FUseInternetErrorDialog default False;

    property OnIsBusyChanged: TNotifyEvent read FOnIsBusyChanged write FOnIsBusyChanged;
  end;

  TclMultiInternetControl = class(TclCustomInternetControl)
  private
    FDelayedItems: TList;
    FMaxStartedItems: Integer;
    FStartedItemCount: Integer;
    FOnDataItemProceed: TclOnMultiDataItemProceed;
    FOnError: TclOnMultiError;
    FOnGetResourceInfo: TclOnMultiGetResourceInfo;
    FOnChanged: TclOnMultiNotifyEvent;
    FOnStatusChanged: TclOnMultiStatusChanged;
    FOnUrlParsing: TclOnMultiURLParsing;
    FOnGetCertificate: TclOnMultiGetCertificate;
    FOnProcessCompleted: TclOnMultiNotifyEvent;
    FOnItemDeleted: TclOnMultiNotifyEvent;
    FOnItemCreated: TclOnMultiNotifyEvent;
    procedure SetMaxStartedItems(const Value: Integer);
    procedure DeleteDelayedInfo(Item: TclInternetItem);
  protected
    procedure InternalStop(Item: TclInternetItem); virtual;
    procedure NotifyInternetItems(AComponent: TComponent); override;
    procedure Changed(Item: TclInternetItem); override;
    procedure DoGetCertificate(Item: TclInternetItem; var ACertificate: TclCertificate;
      AExtraCerts: TclCertificateList; var Handled: Boolean); override;
    procedure DoURLParsing(Item: TclInternetItem; var URLComponents: TURLComponents); override;
    procedure DoGetResourceInfo(Item: TclInternetItem; AResourceInfo: TclResourceInfo); override;
    procedure DoStatusChanged(Item: TclInternetItem; Status: TclProcessStatus); override;
    procedure DoDataItemProceed(Item: TclInternetItem; ResourceInfo: TclResourceInfo;
      AStateItem: TclResourceStateItem; CurrentData: PclChar; CurrentDataSize: Integer); override;
    procedure DoError(Item: TclInternetItem; const Error: string; ErrorCode: Integer); override;
    procedure DoProcessCompleted(Item: TclInternetItem); override;
    procedure DoStopItem(Item: TclInternetItem); override;
    procedure DoItemCreated(Item: TclInternetItem); override;
    procedure DoItemDeleted(Item: TclInternetItem); override;
    procedure StartNextItem(APrevItem: TclInternetItem); override;
    function CanStartItem(Item: TclInternetItem; AIsGetResourceInfo, IsAsynch: Boolean): Boolean; override;
    function GetInternetItems(Index: Integer): TclInternetItem; virtual; abstract;
    function GetInternetItemsCount: Integer; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetResourceInfo(Item: TclInternetItem = nil; IsAsynch: Boolean = True): TclResourceInfo;
    procedure Start(Item: TclInternetItem = nil; IsAsynch: Boolean = True);
    procedure Stop(Item: TclInternetItem = nil);
  published
    property MaxStartedItems: Integer read FMaxStartedItems write SetMaxStartedItems default 5;

    property OnStatusChanged: TclOnMultiStatusChanged read FOnStatusChanged write FOnStatusChanged;
    property OnGetResourceInfo: TclOnMultiGetResourceInfo read FOnGetResourceInfo write FOnGetResourceInfo;
    property OnDataItemProceed: TclOnMultiDataItemProceed read FOnDataItemProceed write FOnDataItemProceed;
    property OnError: TclOnMultiError read FOnError write FOnError;
    property OnUrlParsing: TclOnMultiURLParsing read FOnUrlParsing write FOnUrlParsing;
    property OnChanged: TclOnMultiNotifyEvent read FOnChanged write FOnChanged;
    property OnGetCertificate: TclOnMultiGetCertificate read FOnGetCertificate write FOnGetCertificate;
    property OnProcessCompleted: TclOnMultiNotifyEvent read FOnProcessCompleted write FOnProcessCompleted;
    property OnItemCreated: TclOnMultiNotifyEvent read FOnItemCreated write FOnItemCreated;
    property OnItemDeleted: TclOnMultiNotifyEvent read FOnItemDeleted write FOnItemDeleted;
  end;

const
  cProcessPriorities: array[TclProcessPriority] of TThreadPriority = (tpLower, tpNormal, tpHigher);

implementation

uses
{$IFNDEF DELPHIXE2}
  Registry{$IFDEF DEMO}, Forms{$ENDIF}, SysUtils{$IFDEF LOGGER}, clLogger{$ENDIF};
{$ELSE}
  System.Win.Registry{$IFDEF DEMO}, Vcl.Forms{$ENDIF}, System.SysUtils{$IFDEF LOGGER}, clLogger{$ENDIF};
{$ENDIF}

type
  TclThreaderHolder = class
  public
    FThreader: TclCustomThreader;
    FStateItem: TclResourceStateItem;
  end;

  TclInternetItemInfo = class
  public
    FItem: TclInternetItem;
    FIsGetResourceInfo: Boolean;
  end;

{ TclInternetItem }

procedure TclInternetItem.Assign(Source: TPersistent);
var
  Item: TclInternetItem;
begin
  if (Source is TclInternetItem) then
  begin
    Item := (Source as TclInternetItem);
    DataStream := Item.DataStream;
    FThreadCount := Item.ThreadCount;
    FKeepConnection := Item.KeepConnection;
    FURL := Item.URL;
    FUserName := Item.UserName;
    FLocalFile := Item.LocalFile;
    FPassword := Item.Password;
    FPriority := Item.Priority;
    FCertificateFlags := Item.CertificateFlags;
    FUseHttpRequest := Item.UseHttpRequest;
    FData := Item.Data;
    HttpRequest := Item.HttpRequest;
    ControlChanged();
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclInternetItem.AssignThreaderEvents(AThreader: TclCustomThreader);
begin
  AThreader.OnGetResourceInfo := DoOnGetResourceInfo;
  AThreader.OnStatusChanged := DoOnStatusChanged;
  AThreader.OnError := DoOnError;
  AThreader.OnTerminate := DoOnTerminate;
  AThreader.OnUrlParsing := DoOnURLParsing;
  AThreader.OnDataItemProceed := DoOnDataItemProceed;
  AThreader.OnGetCertificate := DoOnGetCertificate;
end;

procedure TclInternetItem.AssignThreaderParams(AThreader: TclCustomThreader);
begin
  if (HttpRequest <> nil) then
  begin
    AThreader.RequestHeader := HttpRequest.HeaderSource;
  end;
  AThreader.Priority := cProcessPriorities[FPriority];
  AThreader.BatchSize := Control.BatchSize;
  AThreader.TryCount := Control.TryCount;
  AThreader.TimeOut := Control.TimeOut;
  AThreader.ReconnectAfter := Control.ReconnectAfter;
  AThreader.FreeOnTerminate := True;
  AThreader.CertificateFlags := FCertificateFlags;
  AThreader.UseInternetErrorDialog := Control.UseInternetErrorDialog;

  AThreader.HttpProxySettings := Control.HttpProxySettings;
  AThreader.FtpProxySettings := Control.FtpProxySettings;
  AThreader.ProxyBypass := StringReplace(Trim(Control.ProxyBypass.Text), #13#10, #32, [rfReplaceAll]);

  AThreader.InternetAgent := Control.InternetAgent;
  AThreader.PassiveFTPMode := Control.PassiveFTPMode;
  AThreader.KeepConnection := KeepConnection;
  AThreader.DoNotGetResourceInfo := Control.DoNotGetResourceInfo;
  if IsSharedConnection() then
  begin
    AThreader.Connection := GetConnection();
  end;
end;

procedure TclInternetItem.AssignThreader(AThreader: TclCustomThreader);
begin
  AssignThreaderEvents(AThreader);
  AssignThreaderParams(AThreader);
end;

function TclInternetItem.IsSharedConnection: Boolean;
begin
  Result := ((Control <> nil) and (Control.Connection <> nil)) or KeepConnection;
end;

function TclInternetItem.GetConnection(): TclInternetConnection;
begin
  if (Control <> nil) and (Control.Connection <> nil) then
  begin
    Result := Control.Connection;
    FreeAndNil(FSelfConnection);
  end else
  begin
    if (FSelfConnection = nil) then
    begin
      FSelfConnection := TclInternetConnection.Create(nil);
    end;
    Result := FSelfConnection;
  end;
end;

procedure TclInternetItem.ClearInfo();
begin
  FreeAndNil(FResourceInfo);
end;

constructor TclInternetItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  DoCreate();
  Control.DoItemCreated(Self);
end;

destructor TclInternetItem.Destroy;
begin
  if IsBusy then
  begin
    Stop();
    Wait();
  end;
  Control.DoItemDeleted(Self);
  DoDestroy();
  inherited Destroy();
end;

procedure TclInternetItem.ClearThreaderList();
begin
  while (FThreaderList.Count > 0) do
  begin
    RemoveThreader(0);
  end;
end;

procedure TclInternetItem.Wait();
begin
  while (FThreaderList.Count > 0) do
  begin
    GetThreader(0).Wait();
  end;
end;

procedure TclInternetItem.DoOnDataItemProceed(Sender: TObject;
  AResourceInfo: TclResourceInfo; BytesProceed: Int64;
  CurrentData: PclChar; CurrentDataSize: Integer);
var
  StateItem: TclResourceStateItem;
begin
  StateItem := FindStateItem(Sender as TclCustomThreader);
  ResourceState.UpdateProceed(StateItem, BytesProceed - StateItem.ResourcePos);
  Control.DoDataItemProceed(Self, AResourceInfo, StateItem, CurrentData, CurrentDataSize);
end;

procedure TclInternetItem.DoError(const Error: string; ErrorCode: Integer);
begin
  FErrors.AddError(Error, ErrorCode);
  Control.DoError(Self, Error, ErrorCode);
end;

procedure TclInternetItem.DoOnError(Sender: TObject; const Error: string; ErrorCode: Integer);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'DoOnError');{$ENDIF}
  DoError(Error, ErrorCode);
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'DoOnError'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'DoOnError', E); raise; end; end;{$ENDIF}
end;

procedure TclInternetItem.DoOnGetResourceInfo(Sender: TObject; AResourceInfo: TclResourceInfo);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'DoOnGetResourceInfo');{$ENDIF}
  DoGetResourceInfo(AResourceInfo);
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'DoOnGetResourceInfo'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'DoOnGetResourceInfo', E); raise; end; end;{$ENDIF}
end;

procedure TclInternetItem.DoOnStatusChanged(Sender: TObject; Status: TclProcessStatus);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'DoOnStatusChanged');{$ENDIF}
  ResourceState.UpdateStatus(FindStateItem(Sender as TclCustomThreader), Status);
  LastStatusChanged(ResourceState.LastStatus);
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'DoOnStatusChanged: %d', nil, [Integer(Status)]); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'DoOnStatusChanged: %d', E, [Integer(Status)]); raise; end; end;{$ENDIF}
end;

procedure TclInternetItem.DoGetResourceInfo(AResourceInfo: TclResourceInfo);
begin
  ClearInfo();
  if (AResourceInfo <> nil) then
  begin
    FResourceInfo := TclResourceInfo.Create();
    FResourceInfo.Assign(AResourceInfo);
  end;
  Control.DoGetResourceInfo(Self, FResourceInfo);
end;

function TclInternetItem.GetThreader(Index: Integer): TclCustomThreader;
begin
  Result := TclThreaderHolder(FThreaderList[Index]).FThreader;
end;

procedure TclInternetItem.RemoveThreader(Index: Integer);
begin
  TclThreaderHolder(FThreaderList[Index]).Free();
  FThreaderList.Delete(Index);
end;

procedure TclInternetItem.ThreaderTerminated(AThreader: TclCustomThreader);
var
  i: Integer;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'ThreaderTerminated');{$ENDIF}
  if (AThreader.Status <> psFailed) and (ResourceState.LastStatus <> psTerminated) then
  begin
    ReTryFailedItem(FindFirstFailedItem(AThreader), AThreader.URLParser);
  end;
  for i := 0 to FThreaderList.Count - 1 do
  begin
    if (GetThreader(i) = AThreader) then
    begin
      RemoveThreader(i);
      Break;
    end;
  end;
  if (FThreaderList.Count = 0) then
  begin
    ProcessCompleted(AThreader);
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'ThreaderTerminated'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'ThreaderTerminated', E); raise; end; end;{$ENDIF}
end;

procedure TclInternetItem.ReTryFailedItem(AStateItem: TclResourceStateItem; AURLParser: TclUrlParser);
var
  Threader: TclCustomThreader;                                                                       
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'ReTryFailedItem');{$ENDIF}
  if (AStateItem = nil) then Exit;
  Threader := AddThreader(AStateItem, False);
  Threader.ResourceInfo := ResourceInfo;
  Threader.URLParser := AURLParser;
  Threader.Perform();
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'ReTryFailedItem'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'ReTryFailedItem', E); raise; end; end;{$ENDIF}
end;

function TclInternetItem.FindFirstFailedItem(APrevThreader: TclCustomThreader): TclResourceStateItem;
var
  i: Integer;
  PrevStateItem: TclResourceStateItem;
begin
  PrevStateItem := FindStateItem(APrevThreader);
  if (PrevStateItem <> nil) then
  begin
    for i := 0 to ResourceState.Count - 1 do
    begin
      Result := ResourceState[i];
      if ((PrevStateItem <> Result) and (Result.Status = psFailed)) then
      begin
        Exit;
      end;
    end;
  end;
  Result := nil;
end;

procedure TclInternetItem.DoOnTerminate(Sender: TObject);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'DoOnTerminate');{$ENDIF}
  ThreaderTerminated(Sender as TclCustomThreader);
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'DoOnTerminate'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'DoOnTerminate', E); raise; end; end;{$ENDIF}
end;

procedure TclInternetItem.DoOnURLParsing(Sender: TObject; var URLComponents: TURLComponents);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'DoOnURLParsing');{$ENDIF}
  if (UserName <> '') then
  begin
    ZeroMemory(URLComponents.lpszUserName + 0, INTERNET_MAX_USER_NAME_LENGTH);
    CopyMemory(URLComponents.lpszUserName + 0, PclChar(GetTclString(FUserName)), Length(FUserName));
    URLComponents.dwUserNameLength := Length(FUserName);
  end;
  if (Password <> '') then
  begin
    ZeroMemory(URLComponents.lpszPassword + 0, INTERNET_MAX_USER_NAME_LENGTH);
    CopyMemory(URLComponents.lpszPassword + 0, PclChar(GetTclString(FPassword)), Length(FPassword));
    URLComponents.dwPasswordLength := Length(FPassword);
  end;
  if (Port <> 0) then
  begin
    URLComponents.nPort := Word(Port);
  end;
  Control.DoURLParsing(Self, URLComponents);
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'DoOnURLParsing'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'DoOnURLParsing', E); raise; end; end;{$ENDIF}
end;

function TclInternetItem.GetIsBusy: Boolean;
begin
  Result := (FThreaderList.Count > 0);
end;

function TclInternetItem.GetResourceInfo(IsAsynch: Boolean): TclResourceInfo;
begin
  Result := nil;
  if (FResourceInfo = nil) and (not IsBusy) then
  begin
    if Control.CanStartItem(Self, True, IsAsynch) then
    begin
      InternalStart(True);
    end;
    if not IsAsynch then
    begin
      Wait();
      Result := FResourceInfo;
    end;
  end else
  begin
    Result := FResourceInfo;
    if not IsBusy then
    begin
      Control.DoGetResourceInfo(Self, FResourceInfo);
    end;
  end;
end;

procedure TclInternetItem.SetLocalFile(const Value: string);
begin
  if (FLocalFile = Value) then Exit;
  FLocalFile := Value;
  ControlChanged();
end;

procedure TclInternetItem.SetPassword(const Value: string);
begin
  if (FPassword = Value) then Exit;
  FPassword := Value;
  ControlChanged();
end;

procedure TclInternetItem.SetURL(const Value: string);
var
  Parser: TclUrlParser;
begin
  if (FURL = Value) then Exit;
  FURL := Value;
  if (csLoading in Control.ComponentState) then Exit;
  Parser := TclUrlParser.Create();
  try
    if (Parser.Parse(FURL) <> '') then
    begin
      UserName := Parser.UserName;
      Password := Parser.Password;
    end;
  finally
    Parser.Free();
  end;
  ControlChanged();
end;

procedure TclInternetItem.SetUserName(const Value: string);
begin
  if (FUserName = Value) then Exit;
  FUserName := Value;
  ControlChanged();
end;

procedure TclInternetItem.SetMaxConnectionsOption();
  procedure SetIntOption(AOption, AValue: DWORD);
  var
    val, valsize: DWORD;
  begin
    val := 0;
    valsize := SizeOf(val);
    InternetQueryOption(nil, AOption, @val, valsize);
    if (val < AValue) then
    begin
      val := AValue;
      valsize := SizeOf(val);
      InternetSetOption(nil, AOption, @val, valsize);
    end;
  end;

begin
  SetIntOption(INTERNET_OPTION_MAX_CONNS_PER_SERVER, MaxThreadCount);
  SetIntOption(INTERNET_OPTION_MAX_CONNS_PER_1_0_SERVER, MaxThreadCount);
end;

procedure TclInternetItem.InternalStart(AIsGetResourceInfo: Boolean);
var
  StateItem: TclResourceStateItem;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'InternalStart: %s', nil, [URL]);{$ENDIF}
  SetMaxConnectionsOption();
  FLastStatus := psUnknown;
  ClearInfo();
  FHttpResponseHeader.Clear();
  FErrors.Clear();
  ResourceState.InitStatistic();
  if AIsGetResourceInfo or CanProcess() then
  begin
    Control.BeginIsBusy();
    if (ResourceState.Count > 0) then
    begin
      StateItem := ResourceState[0];
    end else
    begin
      StateItem := nil;
    end;
    AddThreader(StateItem, AIsGetResourceInfo).Perform();
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'InternalStart'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'InternalStart', E); raise; end; end;{$ENDIF}
end;

function TclInternetItem.AddThreader(AStateItem: TclResourceStateItem;
  AIsGetResourceInfo: Boolean): TclCustomThreader;
var
  Holder: TclThreaderHolder;
  Stream: TStream;
begin
  if not AIsGetResourceInfo then
  begin
    Stream := GetDataStream();
  end else
  begin
    Stream := nil;
  end;
  Result := CreateThreader(Stream, AIsGetResourceInfo);
  Holder := TclThreaderHolder.Create();
  FThreaderList.Add(Holder);
  Holder.FThreader := Result;
  Holder.FStateItem := AStateItem;
  AssignThreader(Result);
  if (AStateItem <> nil) then
  begin
    Result.ResourcePos := AStateItem.ResourcePos + AStateItem.BytesProceed;
    if (AStateItem.BytesToProceed > 0) then
    begin
      Result.BytesToProceed := AStateItem.BytesToProceed - AStateItem.BytesProceed;
    end;
  end;
end;

procedure TclInternetItem.Start(IsAsynch: Boolean);
begin
  if IsBusy then
  begin
    raise EclInternetError.Create(cOperationIsInProgress, -1);
  end;
  if Control.CanStartItem(Self, False, IsAsynch) then
  begin
    InternalStart(False);
  end;
  if not IsAsynch then
  begin
    Wait();
  end;
end;

procedure TclInternetItem.Stop;
var
  i: Integer;
begin
  Control.DoStopItem(Self);
  if IsBusy then
  begin
    for i := 0 to FThreaderList.Count - 1 do
    begin
      GetThreader(i).Stop();
    end;
  end;
end;

procedure TclInternetItem.ProcessCompleted(AThreader: TclCustomThreader);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'ProcessCompleted');{$ENDIF}
  HttpResponseHeader.Assign(AThreader.ResponseHeader);
  FIsCommit := True;
  try
    CommitWork();
  finally
    FIsCommit := False;
  end;
  Control.StartNextItem(Self);
  Control.EndIsBusy();
  Control.DoProcessCompleted(Self);
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'ProcessCompleted'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'ProcessCompleted', E); raise; end; end;{$ENDIF}
end;

procedure TclInternetItem.CommitWork;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'CommitWork');{$ENDIF}
  ClearDataStream();
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'CommitWork'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'CommitWork', E); raise; end; end;{$ENDIF}
end;

procedure TclInternetItem.LastStatusChanged(Status: TclProcessStatus);
begin
  if (FLastStatus <> Status) then
  begin
    FLastStatus := Status;
    Control.DoStatusChanged(Self, FLastStatus);
  end;
end;

procedure TclInternetItem.DoOnGetCertificate(Sender: TObject;
  var ACertificate: TclCertificate; AExtraCerts: TclCertificateList; var Handled: Boolean);
begin
  Control.DoGetCertificate(Self, ACertificate, AExtraCerts, Handled);
end;

procedure TclInternetItem.ClearDataStream();
begin
  FSelfDataStream.Free();
  FSelfDataStream := nil;
end;

function TclInternetItem.CheckSizeValid(ASize: Int64): Boolean;
begin
  Result := True;
  Result := Result and ((Control.MinResourceSize = 0) or (ASize >= Control.MinResourceSize));
  Result := Result and ((Control.MaxResourceSize = 0) or (ASize <= Control.MaxResourceSize));
end;

function TclInternetItem.CanProcess: Boolean;
begin
  Result := Control.CanProcess(Self);
end;

procedure TclInternetItem.ClearResourceState();
var
  i: Integer;
begin
  ResourceState.Clear();
  for i := 0 to FThreaderList.Count - 1 do
  begin
    TclThreaderHolder(FThreaderList[i]).FStateItem := nil;
  end;
end;

procedure TclInternetItem.SetInternalDataStream(const ADataStream: TStream);
begin
  if (DataStream = nil) then
  begin
    ClearDataStream();
    FSelfDataStream := ADataStream;
  end;
end;

procedure TclInternetItem.SetDataStream(const Value: TStream);
begin
  if (DataStream <> Value) then
  begin
    ClearDataStream();
    FDataStream := Value;
  end;
end;

function TclInternetItem.GetInternalDataStream: TStream;
begin
  if (FDataStream <> nil) then
  begin
    Result := FDataStream;
  end else
  begin
    Result := FSelfDataStream;
  end;
end;

function TclInternetItem.FindStateItem(AThreader: TclCustomThreader): TclResourceStateItem;
var
  i: Integer;
begin
  for i := 0 to FThreaderList.Count - 1 do
  begin
    if (GetThreader(i) = AThreader) then
    begin
      Result := TclThreaderHolder(FThreaderList[i]).FStateItem;
      Exit;
    end;
  end;
  Result := nil;
end;

procedure TclInternetItem.ControlChanged();
begin
  if not (csLoading in Control.ComponentState) then
  begin
    if not IsBusy then
    begin
      ClearInfo();
      ClearResourceState();
      CloseConnection();
    end;
    Control.Changed(Self);
  end;
end;

procedure TclInternetItem.CloseConnection;
begin
  if (IsSharedConnection()) then
  begin
    GetConnection().Close();
  end;
end;

function TclInternetItem.GetDefaultChar: Char;
begin
  Result := Control.DefaultChar;
end;

function TclInternetItem.GetBatchSize: Integer;
begin
  Result := Control.BatchSize;
end;

procedure TclInternetItem.DoOnResourceStateChanged(Sender: TObject);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'DoOnResourceStateChanged');{$ENDIF}
  Control.DoResourceStateChanged(Self);
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'DoOnResourceStateChanged'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'DoOnResourceStateChanged', E); raise; end; end;{$ENDIF}
end;

procedure TclInternetItem.SetThreadCount(const Value: Integer);
begin
  if (Value > 0) and (Value <= MaxThreadCount) then
  begin
    FThreadCount := Value;
  end;
end;

procedure TclInternetItem.DoCreate;
begin
  FHttpResponseHeader := TStringList.Create();
  FErrors := TclErrorList.Create();
  FThreaderList := TList.Create();
  FResourceState := TclResourceStateList.Create();
  FResourceState.OnChanged := DoOnResourceStateChanged;
  FResourceInfo := nil;
  FPriority := ppNormal;
  FLastStatus := psUnknown;
  FThreadCount := 1;
end;

procedure TclInternetItem.DoDestroy;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'DoDestroy');{$ENDIF}
  FreeAndNil(FSelfConnection);
  ClearDataStream();
  ClearInfo();
  FResourceState.Free();
  ClearThreaderList();
  FThreaderList.Free();
  FErrors.Free();
  FHttpResponseHeader.Free();
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'DoDestroy'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'DoDestroy', E); raise; end; end;{$ENDIF}
end;

procedure TclInternetItem.SetHttpRequest(const Value: TclHttpRequest);
begin
  if (FHttpRequest = Value) then Exit;
  if (FHttpRequest <> nil) then
  begin
    FHttpRequest.RemoveFreeNotification(Control);
  end;
  FHttpRequest := Value;
  if (FHttpRequest <> nil) then
  begin
    FHttpRequest.FreeNotification(Control);
  end;
  ControlChanged();
end;

procedure TclInternetItem.InternalSetHttpRequest(const Value: TclHttpRequest);
begin
  FHttpRequest := Value;
end;

function TclInternetItem.GetResourceConnections(Index: Integer): TclInternetConnection;
begin
  Result := GetThreader(Index).Connection;
end;

function TclInternetItem.GetResourceConnectionCount: Integer;
begin
  Result := FThreaderList.Count;
end;

procedure TclInternetItem.SetPort(const Value: Integer);
begin
  if (FPort = Value) then Exit;
  FPort := Value;
  ControlChanged();
end;

procedure TclInternetItem.DeleteRemoteFile;
var
  threader: TclDeleteThreader;
begin
  threader := TclDeleteThreader.Create(URL);
  try
    AssignThreaderParams(threader);
    threader.FreeOnTerminate := False;

    threader.OnUrlParsing := DoOnURLParsing;
    threader.OnGetCertificate := DoOnGetCertificate;

    threader.Perform();
    threader.Wait();

    if (threader.Status <> psSuccess) then
    begin
      raise EclInternetError.Create(threader.LastError, threader.LastErrorCode);
    end;
  finally
    threader.Free();
  end;
end;

procedure TclInternetItem.SetUseHttpRequest(const Value: Boolean);
begin
  FUseHttpRequest := Value;
end;

{ TclCustomInternetControl }

procedure TclCustomInternetControl.BeginIsBusy;
begin
  Inc(FIsBusyCount);
  if (FIsBusyCount = 1) then
  begin
    IsBusyChanged();
  end;
end;

constructor TclCustomInternetControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProxyBypass := TStringList.Create();
  FFtpProxySettings := TclFtpProxySettings.Create();
  FHttpProxySettings := TclHttpProxySettings.Create();
  FNotifierList := TList.Create();
  FTryCount := DefaultTryCount;
  FBatchSize := DefaultBatchSize;
  FTimeOut := DefaultTimeOut;
  FReconnectAfter := DefaultTimeOut;
  FMinResourceSize := 0;
  FMaxResourceSize := 0;
  FInternetAgent := DefaultInternetAgent;
  FDefaultChar := DefaultPreviewChar;
  FDoNotGetResourceInfo := False;
  FUseInternetErrorDialog := False;
end;

procedure TclCustomInternetControl.EndIsBusy;
var
  Allow: Boolean;
begin
  Allow := (FIsBusyCount = 1);
  Dec(FIsBusyCount);
  if (FIsBusyCount < 0) then
  begin
    FIsBusyCount := 0;
  end;
  if Allow then
  begin
    IsBusyChanged();
  end;
end;

class procedure TclCustomInternetControl.EnumIECacheEntries(AList: TStrings);
var
  info: ^TInternetCacheEntryInfo;
  size: DWORD;
  hCache: THandle;
begin
  info := nil;
  hCache := 0;
  try
    size := 0;
    GetMem(info, size);
    repeat
      hCache := FindFirstUrlCacheEntry(nil, info^, size);
      if (hCache = 0) then
      begin
        if (GetLastError() <> ERROR_INSUFFICIENT_BUFFER) then
        begin
          raise EclInternetError.CreateByLastError();
        end;
      end else
      begin
        Break;
      end;
      FreeMem(info);
      GetMem(info, size);
    until False;

    if (hCache <> 0) then
    begin
      AList.Add(string(info^.lpszSourceUrlName));
    end;
    repeat
      if not FindNextUrlCacheEntry(hCache, info^, size) then
      begin
        if (GetLastError() = ERROR_INSUFFICIENT_BUFFER) then
        begin
          FreeMem(info);
          GetMem(info, size);
        end else
        if (GetLastError() = ERROR_NO_MORE_ITEMS) then
        begin
          Break;
        end else
        begin
          raise EclInternetError.CreateByLastError();
        end;
      end else
      begin
        AList.Add(string(info^.lpszSourceUrlName));
      end;
    until False;

  finally
    FreeMem(info);
    if (hCache <> 0) then
    begin
      FindCloseUrlCache(hCache);
    end;
  end;
end;

class procedure TclCustomInternetControl.FlushIESession;
begin
  InternetSetOption(nil, INTERNET_OPTION_END_BROWSER_SESSION, nil, 0);
end;

class procedure TclCustomInternetControl.GetIECacheEntryHeader(const AUrl: string; AList: TStrings);
var
  info: ^TInternetCacheEntryInfo;
  size: DWORD;
begin
  size := 0;
  info := nil;
  if not GetUrlCacheEntryInfo(PclChar(GetTclString(AUrl)), info^, size)
    and (GetLastError() <> ERROR_INSUFFICIENT_BUFFER) then
  begin
    raise EclInternetError.CreateByLastError();
  end;
  GetMem(info, size);
  try
    if not GetUrlCacheEntryInfo(PclChar(GetTclString(AUrl)), info^, size) then
    begin
      raise EclInternetError.CreateByLastError();
    end;

    if info.dwHeaderInfoSize > 0 then
    begin
      AList.Text := string(system.Copy(PclChar(info.lpHeaderInfo), 1, info.dwHeaderInfoSize));
    end;

  finally
    FreeMem(info);
  end;
end;

class procedure TclCustomInternetControl.GetIECacheFile(const AUrl: string; AStream: TStream);
const
  batchSize = 8192;
var
  info: ^TInternetCacheEntryInfo;
  bytesRead, size: DWORD;
  hStream: THandle;
  buf: PclChar;
begin
  size := 0;
  info := nil;
  hStream := RetrieveUrlCacheEntryStream(PclChar(GetTclString(AUrl)), info^, size, False, 0);
  if (hStream = 0) and (GetLastError() <> ERROR_INSUFFICIENT_BUFFER) then
  begin
    raise EclInternetError.CreateByLastError();
  end;
  GetMem(buf, batchSize);
  GetMem(info, size);
  try
    hStream := RetrieveUrlCacheEntryStream(PclChar(GetTclString(AUrl)), info^, size, False, 0);
    if (hStream = 0) then
    begin
      raise EclInternetError.CreateByLastError();
    end;

    bytesRead := 0;
    while (bytesRead < info.dwSizeLow) do
    begin
      size := info.dwSizeLow;
      if (size > batchSize) then
      begin
        size := batchSize;
      end;
      if not ReadUrlCacheEntryStream(hStream, bytesRead, buf, size, 0) then
      begin
        raise EclInternetError.CreateByLastError();
      end;

      AStream.Write(buf^, size);
      bytesRead := bytesRead + size;
    end;

  finally
    if (hStream <> 0) then
    begin
      UnlockUrlCacheEntryStream(hStream, 0);
    end;
    FreeMem(info);
    FreeMem(buf);
  end;
end;

function TclCustomInternetControl.GetIsBusy: Boolean;
begin
  Result := (FIsBusyCount > 0);
end;

procedure TclCustomInternetControl.IsBusyChanged;
begin
  if Assigned(FOnIsBusyChanged) then
  begin
    FOnIsBusyChanged(Self);
  end;
end;

procedure TclCustomInternetControl.ReadRegistry(const APath: string);
var
  size: Integer;
  reg: TRegistry;
  stream: TMemoryStream;
begin
  reg := TRegistry.Create();
  try
    if (reg.OpenKey(APath, False)) and reg.ValueExists(cDataValueName) then
    begin
      size := reg.GetDataSize(cDataValueName);
      if (size > 0) then
      begin
        stream := TMemoryStream.Create();
        try
          stream.Size := size;
          reg.ReadBinaryData(cDataValueName, stream.Memory^, size);
          try
            stream.ReadComponent(Self);
          except
          end;
        finally
          stream.Free();
        end;
      end;
      reg.CloseKey();
    end;
  finally
    reg.Free();
  end;
end;

procedure TclCustomInternetControl.WriteRegistry(const APath: string);
var
  reg: TRegistry;
  stream: TMemoryStream;
begin
  reg := TRegistry.Create();
  try
    if (reg.OpenKey(APath, True)) then
    begin
      stream := TMemoryStream.Create();
      try
        stream.WriteComponent(Self);
        reg.WriteBinaryData(cDataValueName, stream.Memory^, stream.Size);
      finally
        stream.Free();
      end;
      reg.CloseKey();
    end;
  finally
    reg.Free();
  end;
end;

procedure TclCustomInternetControl.SetBatchSize(const Value: Integer);
begin
  if (FBatchSize <> Value) and (Value > 0) then
  begin
    FBatchSize := Value;
  end;
end;

procedure TclCustomInternetControl.SetTimeOut(const Value: Integer);
begin
  if (FTimeOut <> Value) and (Value > 0) then
  begin
    FTimeOut := Value;
  end;
end;

procedure TclCustomInternetControl.SetTryCount(const Value: Integer);
begin
  if (FTryCount <> Value) and (Value > 0) then
  begin
    FTryCount := Value;
  end;
end;

procedure TclCustomInternetControl.SetMaxResourceSize(const Value: Int64);
begin
  if (Value > -1) then
  begin
    FMaxResourceSize := Value;
  end;
end;

procedure TclCustomInternetControl.SetMinResourceSize(const Value: Int64);
begin
  if (Value > -1) then
  begin
    FMinResourceSize := Value;
  end;
end;

procedure TclCustomInternetControl.SetDefaultChar(const Value: Char);
begin
  if (FDefaultChar <> Value) and (Value > #31) then
  begin
    FDefaultChar := Value;
  end;
end;

procedure TclCustomInternetControl.Loaded;
begin
  inherited Loaded();
  Changed(nil);
end;

destructor TclCustomInternetControl.Destroy;
begin
  FNotifierList.Free();
  FHttpProxySettings.Free();
  FFtpProxySettings.Free();
  FProxyBypass.Free();
  inherited Destroy();
end;

procedure TclCustomInternetControl.DoDataItemProceed(Item: TclInternetItem;
  ResourceInfo: TclResourceInfo; AStateItem: TclResourceStateItem;
  CurrentData: PclChar; CurrentDataSize: Integer);
var
  i: Integer;
begin
  for i := 0 to FNotifierList.Count - 1 do
  begin
    GetControlNotifier(i).DoDataItemProceed(Item,
      ResourceInfo, AStateItem, CurrentData, CurrentDataSize);
  end;
end;

procedure TclCustomInternetControl.DoError(Item: TclInternetItem; const Error: string; ErrorCode: Integer);
begin
end;

procedure TclCustomInternetControl.DoGetCertificate(Item: TclInternetItem;
  var ACertificate: TclCertificate; AExtraCerts: TclCertificateList; var Handled: Boolean);
begin
end;

procedure TclCustomInternetControl.DoGetResourceInfo(Item: TclInternetItem; AResourceInfo: TclResourceInfo);
begin
end;

procedure TclCustomInternetControl.DoStatusChanged(Item: TclInternetItem; Status: TclProcessStatus);
var
  i: Integer;
begin
  for i := 0 to FNotifierList.Count - 1 do
  begin
    GetControlNotifier(i).DoStatusChanged(Item, Status);
  end;
end;

function TclCustomInternetControl.GetControlNotifier(Index: Integer): TclControlNotifier;
begin
  Result := TclControlNotifier(FNotifierList[Index]);
end;

procedure TclCustomInternetControl.RegisterControlNotifier(ANotifier: TclControlNotifier);
begin
  FNotifierList.Add(ANotifier);
end;

procedure TclCustomInternetControl.UnregisterControlNotifier(ANotifier: TclControlNotifier);
begin
  FNotifierList.Remove(ANotifier);
end;

procedure TclCustomInternetControl.DoItemCreated(Item: TclInternetItem);
begin
end;

procedure TclCustomInternetControl.DoItemDeleted(Item: TclInternetItem);
var
  i: Integer;
begin
  for i := 0 to FNotifierList.Count - 1 do
  begin
    GetControlNotifier(i).DoItemDeleted(Item);
  end;
end;

procedure TclCustomInternetControl.DoProcessCompleted(Item: TclInternetItem);
begin
end;

procedure TclCustomInternetControl.DoResourceStateChanged(Item: TclInternetItem);
var
  i: Integer;
begin
  for i := 0 to FNotifierList.Count - 1 do
  begin
    GetControlNotifier(i).DoResourceStateChanged(Item);
  end;
end;

procedure TclCustomInternetControl.SetReconnectAfter(const Value: Integer);
begin
  if (FReconnectAfter <> Value) and (Value > 0) then
  begin
    FReconnectAfter := Value;
  end;
end;

procedure TclCustomInternetControl.SetConnection(const Value: TclInternetConnection);
begin
  if (FConnection <> Value) then
  begin
    if (FConnection <> nil) then
    begin
      FConnection.RemoveFreeNotification(Self);
    end;
    FConnection := Value;
    if (FConnection <> nil) then
    begin
      FConnection.FreeNotification(Self);
    end;
  end;
end;

procedure TclCustomInternetControl.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) then Exit;
  if (AComponent = FConnection) then
  begin
    FConnection := nil;
  end;
  if not (csDestroying in ComponentState) then
  begin
    NotifyInternetItems(AComponent);
  end;
end;

class function TclCustomInternetControl.GetCookie(const AURL, AName: string): string;
var
  List: TStrings;
begin
  List := TStringList.Create();
  try
    GetAllCookies(AURL, List);
    Result := List.Values[AName];
  finally
    List.Free();
  end;
end;

class procedure TclCustomInternetControl.SetCookie(const AURL, AName, AValue: string);
begin
  if not InternetSetCookie(PclChar(GetTclString(AURL)), PclChar(GetTclString(AName)), PclChar(GetTclString(AValue))) then
  begin
    raise EclInternetError.CreateByLastError();
  end;
end;

class procedure TclCustomInternetControl.GetAllCookies(const AURL: string; AList: TStrings);
  procedure AddTextStr_(AList: TStrings; const Value: TclString);
  var
    P, Start: PclChar;
    S: TclString;
  begin
    AList.BeginUpdate();
    try
      P := PclChar(Value);
      if P <> nil then
        while P^ <> #0 do
        begin
          Start := P;
          while not (P^ in [#0, #32, #59]) do Inc(P);
          SetString(S, Start, P - Start);
          AList.Add(string(S));
          if P^ = #59 then Inc(P);
          if P^ = #32 then Inc(P);
        end;
    finally
      AList.EndUpdate();
    end;
  end;

var
  buf: PclChar;
  size: DWORD;
begin
  size := 0;
  if not InternetGetCookie(PclChar(GetTclString(AURL)), nil, nil, size) then
  begin
    raise EclInternetError.CreateByLastError();
  end;
  GetMem(buf, size);
  try
    if not InternetGetCookie(PclChar(GetTclString(AURL)), nil, buf, size) then
    begin
      raise EclInternetError.CreateByLastError();
    end;
    AddTextStr_(AList, GetTclString(buf));
  finally
    FreeMem(buf);
  end;
end;

function TclCustomInternetControl.CanStartItem(Item: TclInternetItem;
  AIsGetResourceInfo, IsAsynch: Boolean): Boolean;
begin
  Result := True;
end;

procedure TclCustomInternetControl.Changed(Item: TclInternetItem);
begin
end;

procedure TclCustomInternetControl.StartNextItem(APrevItem: TclInternetItem);
begin
end;

procedure TclCustomInternetControl.DoStopItem(Item: TclInternetItem);
begin
end;

procedure TclCustomInternetControl.DoURLParsing(Item: TclInternetItem;
  var URLComponents: TURLComponents);
begin
end;

function TclCustomInternetControl.CanProcess(Item: TclInternetItem): Boolean;
begin
  Result := True;
end;

procedure TclCustomInternetControl.GetFtpDirList(const ADir, AUser,
  APassword: string; AList: TStrings; ADetails: Boolean);

  function GetMsDosFileInfo(AFindFileData: TWin32FindData): string;
  var
    info: TclFtpFileInfo;
  begin
    info := TclFtpFileInfo.Create();
    try
      info.FileName := AFindFileData.cFileName;
      info.Size := AFindFileData.nFileSizeLow;
      info.IsDirectory := ((AFindFileData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) > 0);
      info.ModifiedDate := ConvertFileTimeToDateTime(AFindFileData.ftLastWriteTime);
      Result := info.Build(lsMsDos);
    finally
      info.Free();
    end;
  end;

const
  AccessTypes: array[Boolean] of DWORD = (INTERNET_OPEN_TYPE_PRECONFIG, INTERNET_OPEN_TYPE_PROXY);

var
  URLParser: TclUrlParser;
  OpenAction: TclInternetOpenAction;
  ConnectAction: TclConnectAction;
  FindFirstFileAction: TclFtpFindFirstFileAction;
  WaitEngine: TclInternetConnection;
  FindFileData: TWin32FindData;
  usr, psw, proxy: string;
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
    MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
      'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
{$ENDIF}
  end;
{$ENDIF}
  AList.Clear();

  URLParser := nil;
  WaitEngine := nil;
  OpenAction := nil;
  ConnectAction := nil;
  FindFirstFileAction := nil;
  try
    URLParser := TclUrlParser.Create();
    if (URLParser.Parse(ADir) = '') then Exit;
    WaitEngine := TclInternetConnection.Create(nil);

    proxy := GetProxyItem('ftp', FtpProxySettings.Server, FtpProxySettings.Port);

    OpenAction := TclInternetOpenAction.Create(WaitEngine, InternetAgent,
      AccessTypes[(proxy <> '')], proxy, StringReplace(Trim(ProxyBypass.Text), #13#10, #32, [rfReplaceAll]), INTERNET_FLAG_DONT_CACHE);
    OpenAction.FireAction(-1);

    usr := AUser;
    if (usr = '') then
    begin
      usr := URLParser.UserName;
    end;
    psw := APassword;
    if (psw = '') then
    begin
      psw := URLParser.Password;
    end;

    ConnectAction := TclConnectAction.Create(WaitEngine, OpenAction.hResource,
      URLParser.Host, INTERNET_DEFAULT_FTP_PORT, usr, psw, INTERNET_SERVICE_FTP, 0);
    ConnectAction.FireAction(TimeOut);

    FindFirstFileAction := TclFtpFindFirstFileAction.Create(WaitEngine,
      ConnectAction.Internet, ConnectAction.hResource, URLParser.Urlpath, INTERNET_FLAG_RELOAD);

    FindFirstFileAction.FireAction(TimeOut);
    FindFileData := FindFirstFileAction.lpFindFileData;
    repeat
      if ADetails then
      begin
        AList.Add(GetMsDosFileInfo(FindFileData));
      end else
      begin
        AList.Add(FindFileData.cFileName);
      end;
    until (not InternetFindNextFile(FindFirstFileAction.hResource, @FindFileData));
  finally
    FindFirstFileAction.Free();
    ConnectAction.Free();
    OpenAction.Free();
    WaitEngine.Free();
    URLParser.Free();
  end;
end;

procedure TclCustomInternetControl.SetFtpProxySettings(const Value: TclFtpProxySettings);
begin
  FFtpProxySettings.Assign(Value);
end;

procedure TclCustomInternetControl.SetHttpProxySettings(const Value: TclHttpProxySettings);
begin
  FHttpProxySettings.Assign(Value);
end;

procedure TclCustomInternetControl.SetProxyBypass(const Value: TStrings);
begin
  FProxyBypass.Assign(Value);
end;

{ TclMultiInternetControl }

procedure TclMultiInternetControl.Changed(Item: TclInternetItem);
begin
  if Assigned(FOnChanged) then
  begin
    FOnChanged(Self, Item);
  end;
end;

procedure TclMultiInternetControl.DoDataItemProceed(Item: TclInternetItem;
  ResourceInfo: TclResourceInfo; AStateItem: TclResourceStateItem; CurrentData: PclChar;
  CurrentDataSize: Integer);
begin
  if Assigned(FOnDataItemProceed) then
  begin
    FOnDataItemProceed(Self, Item, ResourceInfo, AStateItem, CurrentData, CurrentDataSize);
  end;
  inherited DoDataItemProceed(Item, ResourceInfo, AStateItem, CurrentData, CurrentDataSize);
end;

procedure TclMultiInternetControl.DoError(Item: TclInternetItem; const Error: string;
  ErrorCode: Integer);
begin
  if Assigned(FOnError) then
  begin
    FOnError(Self, Item, Error, ErrorCode);
  end;
end;

procedure TclMultiInternetControl.DoGetCertificate(Item: TclInternetItem;
  var ACertificate: TclCertificate; AExtraCerts: TclCertificateList; var Handled: Boolean);
begin
  if Assigned(FOnGetCertificate) then
  begin
    FOnGetCertificate(Self, Item, ACertificate, AExtraCerts, Handled);
  end;
end;

procedure TclMultiInternetControl.DoGetResourceInfo(Item: TclInternetItem; AResourceInfo: TclResourceInfo);
begin
  if Assigned(FOnGetResourceInfo) then
  begin
    FOnGetResourceInfo(Self, Item, AResourceInfo);
  end;
end;

procedure TclMultiInternetControl.DoStatusChanged(Item: TclInternetItem; Status: TclProcessStatus);
begin
  if Assigned(FOnStatusChanged) then
  begin
    FOnStatusChanged(Self, Item, Status);
  end;
  inherited DoStatusChanged(Item, Status);
end;

procedure TclMultiInternetControl.DoURLParsing(Item: TclInternetItem; var URLComponents: TURLComponents);
begin
  if Assigned(FOnUrlParsing) then
  begin
    FOnUrlParsing(Self, Item, URLComponents);
  end;
end;

function TclMultiInternetControl.GetResourceInfo(Item: TclInternetItem; IsAsynch: Boolean): TclResourceInfo;
var
  i: Integer;
begin
  if (Item <> nil) then
  begin
    Result := Item.GetResourceInfo(IsAsynch);
  end else
  begin
    Result := nil;
    for i := 0 to GetInternetItemsCount() - 1 do
    begin
      GetInternetItems(i).GetResourceInfo(IsAsynch);
    end;
  end;
end;

procedure TclMultiInternetControl.Start(Item: TclInternetItem; IsAsynch: Boolean);
var
  i: Integer;
begin
  if (Item <> nil) then
  begin
    Item.Start(IsAsynch);
  end else
  begin
    for i := 0 to GetInternetItemsCount() - 1 do
    begin
      GetInternetItems(i).Start(IsAsynch);
    end;
  end;
end;

procedure TclMultiInternetControl.Stop(Item: TclInternetItem);
begin
  InternalStop(Item);
end;

procedure TclMultiInternetControl.DoProcessCompleted(Item: TclInternetItem);
begin
  if Assigned(FOnProcessCompleted) then
  begin
    FOnProcessCompleted(Self, Item);
  end;
end;

procedure TclMultiInternetControl.NotifyInternetItems(AComponent: TComponent);
var
  i: Integer;
begin
  for i := 0 to GetInternetItemsCount() - 1 do
  begin
    if (GetInternetItems(i).HttpRequest = AComponent) then
    begin
      GetInternetItems(i).InternalSetHttpRequest(nil);
    end;
  end;
end;

procedure TclMultiInternetControl.SetMaxStartedItems(const Value: Integer);
begin
  if (Value > -1) then
  begin
    FMaxStartedItems := Value;
  end;
end;

constructor TclMultiInternetControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDelayedItems := TList.Create();
  FMaxStartedItems := 5;
end;

function TclMultiInternetControl.CanStartItem(Item: TclInternetItem;
  AIsGetResourceInfo, IsAsynch: Boolean): Boolean;
var
  info: TclInternetItemInfo;
begin
  Result := (not IsAsynch) or (FMaxStartedItems = 0) or (FStartedItemCount < FMaxStartedItems);
  if Result then
  begin
    Inc(FStartedItemCount);
  end else
  begin
    info := TclInternetItemInfo.Create();
    FDelayedItems.Add(info);
    info.FItem := Item;
    info.FIsGetResourceInfo := AIsGetResourceInfo;
  end;
end;

procedure TclMultiInternetControl.StartNextItem(APrevItem: TclInternetItem);
var
  info: TclInternetItemInfo;
begin
  if (FStartedItemCount > 0) then
  begin
    Dec(FStartedItemCount);
  end;
  if (FDelayedItems.Count > 0) then
  begin
    info := TclInternetItemInfo(FDelayedItems[0]);
    try
      FDelayedItems.Delete(0);
      info.FItem.InternalStart(info.FIsGetResourceInfo);
      Inc(FStartedItemCount);
    finally
      info.Free();
    end;
  end;
end;

destructor TclMultiInternetControl.Destroy;
var
  i: Integer;
begin
  for i := 0 to FDelayedItems.Count - 1 do
  begin
    TObject(FDelayedItems[i]).Free();
  end;
  FDelayedItems.Free();
  inherited Destroy();
end;

procedure TclMultiInternetControl.DeleteDelayedInfo(Item: TclInternetItem);
var
  i: Integer;
  info: TclInternetItemInfo;
begin
  for i := 0 to FDelayedItems.Count - 1 do
  begin
    info := TclInternetItemInfo(FDelayedItems[i]);
    if (info.FItem = Item) then
    begin
      info.Free();
      FDelayedItems.Delete(i);
      Break;
    end;
  end;
end;

procedure TclMultiInternetControl.DoItemCreated(Item: TclInternetItem);
begin
  inherited DoItemCreated(Item);
  
  if Assigned(OnItemCreated) then
  begin
    OnItemCreated(Self, Item);
  end;
end;

procedure TclMultiInternetControl.DoItemDeleted(Item: TclInternetItem);
begin
  inherited DoItemDeleted(Item);
  DeleteDelayedInfo(Item);
  
  if Assigned(OnItemDeleted) then
  begin
    OnItemDeleted(Self, Item);
  end;
end;

procedure TclMultiInternetControl.DoStopItem(Item: TclInternetItem);
begin
  DeleteDelayedInfo(Item);
end;

procedure TclMultiInternetControl.InternalStop(Item: TclInternetItem);
var
  i: Integer;
begin
  if (Item <> nil) then
  begin
    Item.Stop();
  end else
  begin
    for i := 0 to GetInternetItemsCount() - 1 do
    begin
      GetInternetItems(i).Stop();
    end;
  end;
end;

{ TclControlNotifier }

constructor TclControlNotifier.Create(AControl: TclCustomInternetControl);
begin
  inherited Create();
  FControl := AControl;
  Assert(FControl <> nil);
  FControl.RegisterControlNotifier(Self);
end;

destructor TclControlNotifier.Destroy();
begin
  FControl.UnregisterControlNotifier(Self);
  inherited Destroy();
end;

procedure TclControlNotifier.DoDataItemProceed(Item: TclInternetItem;
  ResourceInfo: TclResourceInfo; AStateItem: TclResourceStateItem;
  CurrentData: PclChar; CurrentDataSize: Integer);
begin
end;

procedure TclControlNotifier.DoItemDeleted(Item: TclInternetItem);
begin
end;

procedure TclControlNotifier.DoResourceStateChanged(Item: TclInternetItem);
begin
end;

procedure TclControlNotifier.DoStatusChanged(Item: TclInternetItem; Status: TclProcessStatus);
begin
end;

end.
