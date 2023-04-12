{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clInternetConnection;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Windows, SysUtils, Classes, SyncObjs,
{$ELSE}
  Winapi.Windows, System.SysUtils, System.Classes, System.SyncObjs, System.Types,
{$ENDIF}
  clDCUtils, clWinInet, clSyncUtils, clWUtils;

type
  TclInternetConnection = class;
  EclTimeoutInternetError = class(EclInternetError);

  TclInternetAction = class
  private
    FOwner: TclInternetConnection;
    FInternet: HINTERNET;
    FAccessor: TCriticalSection;
  protected
    FErrorCode: Integer;
    FErrorText: string;
    procedure NotifyTerminate(AInternet: HINTERNET); virtual;
    procedure Execute; virtual;
    procedure Terminate;
  public
    constructor Create(AOwner: TclInternetConnection; AInternet: HINTERNET);
    destructor Destroy; override;
    function FireAction(ATimeOut: Integer; AIsSilent: Boolean = False): Boolean; virtual;
    property Internet: HINTERNET read FInternet;
  end;

  TclInternetActionClass = class of TclInternetAction;

  TclActionEvent = procedure (Sender: TObject; Action: TclInternetAction) of object;
  TclStatusCallbackEvent = procedure (Sender: TObject; Action: TclInternetAction;
    AInternetStatus: Integer; AStatusInformation: PByte; AStatusInformationLength: Integer) of object;

  TclInternetConnection = class(TComponent)
  private
    FActionList: TList;
    FBeginEvent: THandle;
    FTerminateEvent: THandle;
    FWaitEvent: THandle;
    FEndEvent: THandle;
    FThread: THandle;
    FInternetAction: TclInternetAction;
    FSynchronizer: TclThreadSynchronizer;
    FEventAction: TclInternetAction;
    FEventInternetStatus: Integer;
    FEventStatusInfo: PByte;
    FEventStatusInfoLength: Integer;
    FOnActionAdded: TclActionEvent;
    FOnActionRemoved: TclActionEvent;
    FOnBeforeFireAction: TclActionEvent;
    FOnAfterFireAction: TclActionEvent;
    FOnStatusCallback: TclStatusCallbackEvent;
    
    procedure AssignWaitMembers;
    procedure FireInternetAction(Action: TclInternetAction; ATimeOut: Integer);
    procedure FireNotifyTerminate(AInternet: HINTERNET);
    function GetAction(Index: Integer): TclInternetAction;
    procedure AddAction(Action: TclInternetAction);
    procedure RemoveAction(Action: TclInternetAction);
    procedure SetStatusCallbackIfNeed(Action: TclInternetAction);
    procedure SyncActionAdded;
    procedure SyncActionRemoved;
    procedure SyncAfterFireAction;
    procedure SyncBeforeFireAction;
    procedure SyncStatusCallback;
    procedure InternalSynchronize(Method: TThreadMethod);
  protected
    procedure DoActionAdded(Action: TclInternetAction); dynamic;
    procedure DoActionRemoved(Action: TclInternetAction); dynamic;
    procedure DoBeforeFireAction(Action: TclInternetAction); dynamic;
    procedure DoAfterFireAction(Action: TclInternetAction); dynamic;
    procedure DoStatusCallback(Action: TclInternetAction; AInternetStatus: Integer;
      AStatusInformation: PByte; AStatusInformationLength: Integer); dynamic;
    procedure Stop;
    function GetActionByHandle(hInet: HINTERNET): TclInternetAction;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Close;
    function GetActionByClass(AClass: TclInternetActionClass): TclInternetAction;
  published
    property OnActionAdded: TclActionEvent read FOnActionAdded write FOnActionAdded;
    property OnActionRemoved: TclActionEvent read FOnActionRemoved write FOnActionRemoved;
    property OnAfterFireAction: TclActionEvent read FOnAfterFireAction write FOnAfterFireAction;
    property OnBeforeFireAction: TclActionEvent read FOnBeforeFireAction write FOnBeforeFireAction;
    property OnStatusCallback: TclStatusCallbackEvent
      read FOnStatusCallback write FOnStatusCallback;
  end;

  TclInternetResourceAction = class(TclInternetAction)
  protected
    FhResource: HINTERNET;
    procedure NotifyTerminate(AInternet: HINTERNET); override;
    procedure Execute; override;
  public
    destructor Destroy; override;
    procedure CloseResource;
    property hResource: HINTERNET read FhResource;
  end;

  TclInternetOpenAction = class(TclInternetResourceAction)
  private
    FlpszAgent: string;
    FdwAccessType: DWORD;
    FlpszProxy: string;
    FlpszProxyBypass: string;
    FdwFlags: DWORD;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclInternetConnection; lpszAgent: string; dwAccessType: DWORD;
      lpszProxy, lpszProxyBypass: string; dwFlags: DWORD);
  end;

  TclOpenURLAction = class(TclInternetResourceAction)
  private
    FlpszUrl: string;
    FlpszHeaders: string;
    FdwFlags: DWORD;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclInternetConnection; hInet: HINTERNET; lpszUrl,
      lpszHeaders: string; dwFlags: DWORD);
  end;

  TclConnectAction = class(TclInternetResourceAction)
  private
    FlpszServerName: string;
    FnServerPort: INTERNET_PORT;
    FlpszUsername: string;
    FlpszPassword: string;
    FdwService: DWORD;
    FdwFlags: DWORD;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclInternetConnection; hInet: HINTERNET; lpszServerName: string;
      nServerPort: INTERNET_PORT; lpszUsername, lpszPassword: string; dwService, dwFlags: DWORD);
  end;

  TclFtpFindFirstFileAction = class(TclInternetResourceAction)
  private
    FhConnect: HINTERNET;
    FlpFindFileData: TWin32FindData;
    FlpszSearchFile: string;
    FdwFlags: DWORD;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclInternetConnection; hInet, hConnect: HINTERNET;
      lpszSearchFile: string; dwFlags: DWORD);
    property lpFindFileData: TWin32FindData read FlpFindFileData;
  end;

  TclFtpGetFileSizeAction = class(TclInternetAction)
  private
    FhFile: HINTERNET;
    FFileSize: Int64;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclInternetConnection; hInet, hFile: HINTERNET);
    property FileSize: Int64 read FFileSize;
  end;

  TclFtpOpenFileAction = class(TclInternetResourceAction)
  private
    FhConnect: HINTERNET;
    FlpszFileName: string;
    FdwAccess: DWORD;
    FdwFlags: DWORD;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclInternetConnection; hInet, hConnect: HINTERNET; lpszFileName: string;
      dwAccess: DWORD; dwFlags: DWORD);
  end;

  TclFtpCreateDirectoryAction = class(TclInternetAction)
  private
    FhConnect: HINTERNET;
    FlpszDirectory: string;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclInternetConnection; hInet, hConnect: HINTERNET; lpszDirectory: string);
  end;

  TclHttpOpenRequestAction = class(TclInternetResourceAction)
  private
    FhConnect: HINTERNET;
    FlpszVerb: string;
    FlpszObjectName: string;
    FlpszVersion: string;
    FlpszReferrer: string;
    FlplpszAcceptTypes: PLPSTR;
    FdwFlags: DWORD;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclInternetConnection;
      hInet, hConnect: HINTERNET; lpszVerb, lpszObjectName, lpszVersion, lpszReferrer: string;
      lplpszAcceptTypes: PLPSTR; dwFlags: DWORD);
  end;

  TclHttpSendRequestAction = class(TclInternetAction)
  private
    FhRequest: HINTERNET;
    FlpszHeaders: string;
    FlpOptional: Pointer;
    FdwOptionalLength: DWORD;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclInternetConnection; hInet, hRequest: HINTERNET;
      lpszHeaders: string; lpOptional: Pointer;
      dwOptionalLength: DWORD);
  end;

  TclHttpSendRequestExAction = class(TclInternetAction)
  private
    FhRequest: HINTERNET;
    FlpBuffersIn: PInternetBuffers;
    FlpBuffersOut: PInternetBuffers;
    FdwFlags: DWORD;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclInternetConnection; hInet: HINTERNET; hRequest: HINTERNET;
      lpBuffersIn: PInternetBuffers; lpBuffersOut: PInternetBuffers;
      dwFlags: DWORD);
  end;

  TclHttpEndRequestAction = class(TclInternetAction)
  private
    FhRequest: HINTERNET;
    FlpBuffersOut: PInternetBuffers;
    FdwFlags: DWORD;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclInternetConnection; hInet, hRequest: HINTERNET;
      lpBuffersOut: PInternetBuffers; dwFlags: DWORD);
  end;

  TclInternetReadFileAction = class(TclInternetAction)
  private
    FhFile: HINTERNET;
    FlpBuffer: Pointer;
    FdwNumberOfBytesToRead: DWORD;
    FlpdwNumberOfBytesRead: DWORD;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclInternetConnection; hInet, hFile: HINTERNET; lpBuffer: Pointer);
    property dwNumberOfBytesToRead: DWORD read FdwNumberOfBytesToRead write FdwNumberOfBytesToRead;
    property lpdwNumberOfBytesRead: DWORD read FlpdwNumberOfBytesRead;
  end;

  TclInternetWriteFileAction = class(TclInternetAction)
  private
    FhFile: HINTERNET;
    FlpBuffer: Pointer;
    FdwNumberOfBytesToWrite: DWORD;
    FlpdwNumberOfBytesWritten: DWORD;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclInternetConnection; hInet, hFile: HINTERNET);
    property lpBuffer: Pointer read FlpBuffer write FlpBuffer;
    property dwNumberOfBytesToWrite: DWORD read FdwNumberOfBytesToWrite write FdwNumberOfBytesToWrite;
    property lpdwNumberOfBytesWritten: DWORD read FlpdwNumberOfBytesWritten;
  end;

implementation

uses
  clUtils;
  
{ TclOpenURLAction }

constructor TclOpenURLAction.Create(AOwner: TclInternetConnection; hInet: HINTERNET; lpszUrl,
  lpszHeaders: string; dwFlags: DWORD);
begin
  inherited Create(AOwner, hInet);
  FlpszUrl := lpszUrl;
  FlpszHeaders := lpszHeaders;
  FdwFlags := dwFlags;
end;

procedure TclOpenURLAction.Execute;
var
  Headers: PclChar;
begin
  FhResource := nil;
  Headers := nil;
  if (FlpszHeaders <> '') then
  begin
    Headers := PclChar(GetTclString(FlpszHeaders));
  end;
  FhResource := InternetOpenUrl(Internet, PclChar(GetTclString(FlpszUrl)), Headers, Length(FlpszHeaders), FdwFlags, DWORD(FOwner));
  inherited Execute();
end;

{ TclInternetConnection }

function WaitProc(Instance: TclInternetConnection): Integer;
var
  arr: array[0..1] of THandle;
  waitevent: THandle;
begin
  arr[0] := Instance.FBeginEvent;
  arr[1] := Instance.FEndEvent;
  waitevent := Instance.FWaitEvent;
  repeat
    if (WaitForMultipleObjects(2, @arr, False, INFINITE) = WAIT_OBJECT_0) then
    begin
      if (Instance.FInternetAction <> nil) then
      begin
        try
          Instance.FInternetAction.Execute();
        except
        end;
        SetEvent(waitevent);
      end;
    end else
    begin
      Break;
    end;
  until False;
  Result := 0;
end;

procedure TclInternetConnection.AssignWaitMembers;
var
  id: DWORD;
begin
  if (FBeginEvent = 0) then
  begin
    FBeginEvent := CreateEvent(nil, False, False, nil);
    FTerminateEvent := CreateEvent(nil, False, False, nil);
    FWaitEvent := CreateEvent(nil, False, False, nil);
    FEndEvent := CreateEvent(nil, False, False, nil);
    FThread := BeginThread(nil, 0, @WaitProc, Pointer(Self), 0, id);
  end;
end;

procedure TclInternetConnection.Stop();
begin
  SetEvent(FTerminateEvent);
end;

procedure TclInternetConnection.Close;
  procedure DoneItem(var AItem: THandle);
  begin
    if (AItem <> 0) then
    begin
      CloseHandle(AItem);
      AItem := 0;
    end;
  end;

begin
  Stop();
  while ((FActionList <> nil) and (FActionList.Count > 0)) do
  begin
    GetAction(0).Free();
  end;
  SetEvent(FEndEvent);
  WaitForSingleObject(FThread, INFINITE);
  DoneItem(FThread);
  DoneItem(FTerminateEvent);
  DoneItem(FBeginEvent);
  DoneItem(FWaitEvent);
  DoneItem(FEndEvent);
end;

constructor TclInternetConnection.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FSynchronizer := TclThreadSynchronizer.Create();
  FActionList := TList.Create();
  FInternetAction := nil;
end;

destructor TclInternetConnection.Destroy;
begin
  Close();
  FActionList.Free();
  FActionList := nil;
  FSynchronizer.Free();

  inherited Destroy();
end;

procedure TclInternetConnection.FireInternetAction(Action: TclInternetAction; ATimeOut: Integer);
var
  arr: array[0..1] of THandle;
begin
  if (csDestroying in ComponentState) then Exit;
  FInternetAction := Action;
  try
    DoBeforeFireAction(Action);
    AssignWaitMembers();
    SetEvent(FBeginEvent);
    arr[0] := FWaitEvent;
    arr[1] := FTerminateEvent;                      
    case WaitForMultipleObjects(2, @arr, False, DWORD(ATimeOut)) of
      WAIT_OBJECT_0 + 1:
        begin
          Action.Terminate();
          WaitForSingleObject(FWaitEvent, INFINITE);
        end;
      WAIT_TIMEOUT:
        begin
          Action.Terminate();
          WaitForSingleObject(FWaitEvent, INFINITE);
          raise EclTimeoutInternetError.Create(cRequestTimeOut, WAIT_TIMEOUT);
        end;
      else
        begin
          DoAfterFireAction(Action);
          SetStatusCallbackIfNeed(Action);
        end;
    end;
  finally
    FInternetAction := nil;
  end;
end;

procedure TclInternetConnection.FireNotifyTerminate(AInternet: HINTERNET);
var
  i: Integer;
  Item: TclInternetAction;
begin
  if (csDestroying in ComponentState) then Exit;
  for i := 0 to FActionList.Count - 1 do
  begin
    Item := GetAction(i);
    if (Item <> FInternetAction) then
    begin
      Item.NotifyTerminate(AInternet);
    end;
  end;
end;

function TclInternetConnection.GetAction(Index: Integer): TclInternetAction;
begin
  Result := TclInternetAction(FActionList[Index]);
end;

function TclInternetConnection.GetActionByClass(AClass: TclInternetActionClass): TclInternetAction;
var
  i: Integer;
begin
  if not (csDestroying in ComponentState) then
  begin
    for i := 0 to FActionList.Count - 1 do
    begin
      Result := GetAction(i);
      if Result.InheritsFrom(AClass) then Exit;
    end;
  end;
  Result := nil;
end;

procedure StatusCallbackHandler(hInet: HINTERNET; dwContext: DWORD;
  AInternetStatus: DWORD; AStatusInformation: PByte; AStatusInformationLength: DWORD); stdcall;
var
  inst: TclInternetConnection;
begin
  inst := TclInternetConnection(dwContext);
  inst.DoStatusCallback(inst.GetActionByHandle(hInet),
    AInternetStatus, AStatusInformation, AStatusInformationLength);
end;

procedure TclInternetConnection.SetStatusCallbackIfNeed(Action: TclInternetAction);
begin
  if (csDestroying in ComponentState) then Exit;
  if (Action is TclInternetOpenAction)
    and Assigned(OnStatusCallback) then
  begin
    InternetSetStatusCallback(TclInternetOpenAction(Action).hResource, @StatusCallbackHandler);
  end;
end;

procedure TclInternetConnection.AddAction(Action: TclInternetAction);
begin
  if (FActionList <> nil) then
  begin
    FActionList.Add(Action);
    DoActionAdded(Action);
  end;
end;

procedure TclInternetConnection.RemoveAction(Action: TclInternetAction);
begin
  if (FActionList <> nil) then
  begin
    FActionList.Remove(Action);
    DoActionRemoved(Action);
  end;
end;

procedure TclInternetConnection.DoActionAdded(Action: TclInternetAction);
begin
  if Assigned(OnActionAdded) then
  begin
    FEventAction := Action;
    InternalSynchronize(SyncActionAdded);
  end;
end;

procedure TclInternetConnection.SyncActionAdded;
begin
  OnActionAdded(Self, FEventAction);
end;

procedure TclInternetConnection.DoActionRemoved(Action: TclInternetAction);
begin
  if Assigned(OnActionRemoved) then
  begin
    FEventAction := Action;
    InternalSynchronize(SyncActionRemoved);
  end;
end;

procedure TclInternetConnection.SyncActionRemoved;
begin
  OnActionRemoved(Self, FEventAction);
end;

procedure TclInternetConnection.DoAfterFireAction(Action: TclInternetAction);
begin
  if Assigned(OnAfterFireAction) then
  begin
    FEventAction := Action;
    InternalSynchronize(SyncAfterFireAction);
  end;
end;

procedure TclInternetConnection.SyncAfterFireAction;
begin
  OnAfterFireAction(Self, FEventAction);
end;

procedure TclInternetConnection.DoBeforeFireAction(Action: TclInternetAction);
begin
  if Assigned(OnBeforeFireAction) then
  begin
    FEventAction := Action;
    InternalSynchronize(SyncBeforeFireAction);
  end;
end;

procedure TclInternetConnection.SyncBeforeFireAction;
begin
  OnBeforeFireAction(Self, FEventAction);
end;

procedure TclInternetConnection.DoStatusCallback(
  Action: TclInternetAction; AInternetStatus: Integer;
  AStatusInformation: PByte; AStatusInformationLength: Integer);
begin
  if Assigned(OnStatusCallback) then
  begin
    FEventAction := Action;
    FEventInternetStatus := AInternetStatus;
    FEventStatusInfo := AStatusInformation;
    FEventStatusInfoLength := AStatusInformationLength;
    InternalSynchronize(SyncStatusCallback);
  end;
end;

procedure TclInternetConnection.SyncStatusCallback;
begin
  OnStatusCallback(Self, FEventAction, FEventInternetStatus,
    FEventStatusInfo, FEventStatusInfoLength);
end;

function TclInternetConnection.GetActionByHandle(hInet: HINTERNET): TclInternetAction;
var
  i: Integer;
begin
  if not (csDestroying in ComponentState) then
  begin
    for i := 0 to FActionList.Count - 1 do
    begin
      Result := GetAction(i);
      if (Result is TclInternetResourceAction)
        and ((Result as TclInternetResourceAction).hResource = hInet) then Exit;
    end;
  end;
  Result := nil;
end;

procedure TclInternetConnection.InternalSynchronize(Method: TThreadMethod);
begin
  FSynchronizer.Synchronize(Method);
end;

{ TclInternetAction }

constructor TclInternetAction.Create(AOwner: TclInternetConnection; AInternet: HINTERNET);
begin
  inherited Create();
  FAccessor := TCriticalSection.Create();
  FInternet := AInternet;
  FOwner := AOwner;
  if (FOwner <> nil) then
  begin
    FOwner.AddAction(Self);
  end;
end;

destructor TclInternetAction.Destroy;
begin
  if (FOwner <> nil) then
  begin
    FOwner.RemoveAction(Self);
  end;
  FAccessor.Free();
  inherited Destroy();
end;

procedure TclInternetAction.Execute;
begin
  FErrorCode := clGetLastError();
  FErrorText := EclInternetError.GetLastErrorText(FErrorCode);
end;

function TclInternetAction.FireAction(ATimeOut: Integer; AIsSilent: Boolean): Boolean;
begin
  FErrorCode := 0;
  FErrorText := '';
  Assert(FOwner <> nil);
  FOwner.FireInternetAction(Self, ATimeOut);
  Result := (FErrorText = '');
  if (not Result) and (not AIsSilent) then
  begin
    raise EclInternetError.Create(FErrorText, FErrorCode);
  end;
end;

procedure TclInternetAction.NotifyTerminate(AInternet: HINTERNET);
begin
end;

procedure TclInternetAction.Terminate;
begin
  FAccessor.Enter();
  try
    if (FInternet <> nil) then
    begin
      if (FOwner <> nil) then
      begin
        FOwner.FireNotifyTerminate(FInternet);
      end;
      InternetCloseHandle(FInternet);
      FInternet := nil;
    end;
  finally
    FAccessor.Leave();
  end;
end;

{ TclConnectAction }

constructor TclConnectAction.Create(AOwner: TclInternetConnection; hInet: HINTERNET;
  lpszServerName: string; nServerPort: INTERNET_PORT;
  lpszUsername, lpszPassword: string; dwService, dwFlags: DWORD);
begin
  inherited Create(AOwner, hInet);
  FlpszServerName := lpszServerName;
  FnServerPort := nServerPort;
  FlpszUsername := lpszUsername;
  FlpszPassword := lpszPassword;
  FdwService := dwService;
  FdwFlags := dwFlags;
end;

procedure TclConnectAction.Execute;
var
  Username, Password: PclChar;
begin
  FhResource := nil;
  Username := nil;
  Password := nil;
  if (FlpszUsername <> '') then
  begin
    Username := PclChar(GetTclString(FlpszUsername));
  end;
  if (FlpszPassword <> '') then
  begin
    Password := PclChar(GetTclString(FlpszPassword));
  end;
  FhResource := InternetConnect(Internet, PclChar(GetTclString(FlpszServerName)), FnServerPort, Username,
    Password, FdwService, FdwFlags, DWORD(FOwner));
  inherited Execute();
end;

{ TclFtpFindFirstFileAction }

constructor TclFtpFindFirstFileAction.Create(AOwner: TclInternetConnection; hInet, hConnect: HINTERNET;
  lpszSearchFile: string; dwFlags: DWORD);
begin
  inherited Create(AOwner, hInet);
  FhConnect := hConnect;
  FlpszSearchFile := lpszSearchFile;
  FdwFlags := dwFlags;
end;

procedure TclFtpFindFirstFileAction.Execute;
begin
  FhResource := nil;
  FhResource := FtpFindFirstFile(FhConnect, PChar(FlpszSearchFile), FlpFindFileData, FdwFlags, DWORD(FOwner));
  inherited Execute();
end;

{ TclInternetResourceAction }

procedure TclInternetResourceAction.CloseResource;
begin
  if (FhResource <> nil) then
  begin
    InternetCloseHandle(FhResource);
    FhResource := nil;
  end;
end;

destructor TclInternetResourceAction.Destroy;
begin
  CloseResource();
  inherited Destroy;
end;

procedure TclInternetResourceAction.Execute;
begin
  if FhResource = nil then
  begin
    inherited Execute();
  end;
end;

procedure TclInternetResourceAction.NotifyTerminate(AInternet: HINTERNET);
begin
  if (FhResource = AInternet) then
  begin
    FhResource := nil;
  end;
end;

{ TclInternetOpenAction }

constructor TclInternetOpenAction.Create(AOwner: TclInternetConnection; lpszAgent: string;
  dwAccessType: DWORD; lpszProxy, lpszProxyBypass: string; dwFlags: DWORD);
begin
  inherited Create(AOwner, nil);
  FlpszAgent := lpszAgent;
  FdwAccessType := dwAccessType;
  FlpszProxy := Trim(lpszProxy);
  FlpszProxyBypass := Trim(lpszProxyBypass);
  FdwFlags := dwFlags;
end;

procedure TclInternetOpenAction.Execute;
var
  Proxy, ProxyBypass: PclChar;
begin
  FhResource := nil;
  Proxy := nil;
  ProxyBypass := nil;
  if (FlpszProxy <> '') then
  begin
    Proxy := PclChar(GetTclString(FlpszProxy));
  end;
  if (FlpszProxyBypass <> '') then
  begin
    ProxyBypass := PclChar(GetTclString(FlpszProxyBypass));
  end;
  FhResource := InternetOpen(PclChar(GetTclString(FlpszAgent)), FdwAccessType, Proxy, ProxyBypass, FdwFlags);
  inherited Execute();
end;

{ TclFtpOpenFileAction }

constructor TclFtpOpenFileAction.Create(AOwner: TclInternetConnection;
  hInet, hConnect: HINTERNET; lpszFileName: string; dwAccess, dwFlags: DWORD);
begin
  inherited Create(AOwner, hInet);
  FhConnect := hConnect;
  FlpszFileName := lpszFileName;
  FdwAccess := dwAccess;
  FdwFlags := dwFlags;
end;

procedure TclFtpOpenFileAction.Execute;
begin
  FhResource := nil;
  FhResource := FtpOpenFile(FhConnect, PclChar(GetTclString(FlpszFileName)), FdwAccess, FdwFlags, DWORD(FOwner));
  inherited Execute();
end;

{ TclHttpOpenRequestAction }

constructor TclHttpOpenRequestAction.Create(AOwner: TclInternetConnection;
  hInet, hConnect: HINTERNET; lpszVerb, lpszObjectName, lpszVersion, lpszReferrer: string;
  lplpszAcceptTypes: PLPSTR; dwFlags: DWORD);
begin
  inherited Create(AOwner, hInet);
  FhConnect := hConnect;
  FlpszVerb := lpszVerb;
  FlpszObjectName := lpszObjectName;
  FlpszVersion := lpszVersion;
  FlpszReferrer := lpszReferrer;
  FlplpszAcceptTypes := lplpszAcceptTypes;
  FdwFlags := dwFlags;
end;

procedure TclHttpOpenRequestAction.Execute;
var
  Verb, Version, Referrer: PclChar;
begin
  FhResource := nil;
  Verb := nil;
  Version := nil;
  Referrer := nil;
  if (FlpszVerb <> '') then
  begin
    Verb := PclChar(GetTclString(FlpszVerb));
  end;
  if (FlpszVersion <> '') then
  begin
    Version := PclChar(GetTclString(FlpszVersion));
  end;
  if (FlpszReferrer <> '') then
  begin
    Referrer := PclChar(GetTclString(FlpszReferrer));
  end;
  FhResource := HttpOpenRequest(FhConnect, Verb, PclChar(GetTclString(FlpszObjectName)), Version,
    Referrer, FlplpszAcceptTypes, FdwFlags, DWORD(FOwner));
  inherited Execute();
end;

{ TclHttpSendRequestExAction }

constructor TclHttpSendRequestExAction.Create(AOwner: TclInternetConnection;
  hInet, hRequest: HINTERNET;
  lpBuffersIn, lpBuffersOut: PInternetBuffers; dwFlags: DWORD);
begin
  inherited Create(AOwner, hInet);
  FhRequest := hRequest;
  FlpBuffersIn := lpBuffersIn;
  FlpBuffersOut := lpBuffersOut;
  FdwFlags := dwFlags;
end;

procedure TclHttpSendRequestExAction.Execute;
begin
  if not HttpSendRequestEx(FhRequest, FlpBuffersIn, FlpBuffersOut, FdwFlags, DWORD(FOwner)) then
  begin
    inherited Execute();
  end;
end;

{ TclHttpEndRequestAction }

constructor TclHttpEndRequestAction.Create(AOwner: TclInternetConnection;
  hInet, hRequest: HINTERNET; lpBuffersOut: PInternetBuffers; dwFlags: DWORD);
begin
  inherited Create(AOwner, hInet);
  FhRequest := hRequest;
  FlpBuffersOut := lpBuffersOut;
  FdwFlags := dwFlags;
end;

procedure TclHttpEndRequestAction.Execute;
begin
  if not HttpEndRequest(FhRequest, FlpBuffersOut, FdwFlags, DWORD(FOwner)) then
  begin
    inherited Execute();
  end;
end;

{ TclHttpSendRequestAction }

constructor TclHttpSendRequestAction.Create(AOwner: TclInternetConnection;
  hInet, hRequest: HINTERNET; lpszHeaders: string;
  lpOptional: Pointer; dwOptionalLength: DWORD);
begin
  inherited Create(AOwner, hInet);
  FhRequest := hRequest;
  FlpszHeaders := lpszHeaders;
  FlpOptional := lpOptional;
  FdwOptionalLength := dwOptionalLength;
end;

procedure TclHttpSendRequestAction.Execute;
var
  Headers: PclChar;
begin
  Headers := nil;
  if (FlpszHeaders <> '') then
  begin
    Headers := PclChar(GetTclString(FlpszHeaders));
  end;
  if not HttpSendRequest(FhRequest, Headers, Length(FlpszHeaders), FlpOptional, FdwOptionalLength) then
  begin
    inherited Execute();
  end;
end;

{ TclInternetReadFileAction }

constructor TclInternetReadFileAction.Create(AOwner: TclInternetConnection;
  hInet, hFile: HINTERNET; lpBuffer: Pointer);
begin
  inherited Create(AOwner, hInet);
  FhFile := hFile;
  FlpBuffer := lpBuffer;
end;

procedure TclInternetReadFileAction.Execute;
begin
  if not InternetReadFile(FhFile, FlpBuffer, FdwNumberOfBytesToRead, FlpdwNumberOfBytesRead) then
  begin
    inherited Execute();
  end;
end;

{ TclInternetWriteFileAction }

constructor TclInternetWriteFileAction.Create(AOwner: TclInternetConnection;
  hInet, hFile: HINTERNET);
begin
  inherited Create(AOwner, hInet);
  FhFile := hFile;
end;

procedure TclInternetWriteFileAction.Execute;
begin
  if (not InternetWriteFile(FhFile, FlpBuffer, FdwNumberOfBytesToWrite, FlpdwNumberOfBytesWritten))
    or (FdwNumberOfBytesToWrite <> FlpdwNumberOfBytesWritten) then
  begin
    inherited Execute();
  end;
end;

{ TclFtpCreateDirectoryAction }

constructor TclFtpCreateDirectoryAction.Create(AOwner: TclInternetConnection;
  hInet, hConnect: HINTERNET; lpszDirectory: string);
begin
  inherited Create(AOwner, hInet);
  FhConnect := hConnect;
  FlpszDirectory := lpszDirectory;
end;

procedure TclFtpCreateDirectoryAction.Execute;
begin
  if not (FtpCreateDirectory(FhConnect, PclChar(GetTclString(FlpszDirectory)))) then
  begin
    inherited Execute();
  end;
end;

{ TclFtpGetFileSizeAction }

constructor TclFtpGetFileSizeAction.Create(AOwner: TclInternetConnection;
  hInet, hFile: HINTERNET);
begin
  inherited Create(AOwner, hInet);
  FhFile := hFile;
end;

procedure TclFtpGetFileSizeAction.Execute;
var
  p: DWORD;
  pp: Int64;
begin
  p := 0;
  FFileSize := FtpGetFileSize(FhFile, @p);
  pp := p;
  FFileSize := FFileSize or (pp shl 32);  
end;

end.
