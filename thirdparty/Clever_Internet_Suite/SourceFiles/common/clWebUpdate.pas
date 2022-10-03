{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clWebUpdate;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows, msxml, SysUtils, Math, Forms,
{$ELSE}
  System.Classes, Winapi.Windows, Winapi.msxml, System.SysUtils, System.Math, Vcl.Forms,
{$ENDIF}
  clDownloader, clDC, clDCUtils, clUtils, clMultiDC, clXmlUtils,
  clSspiTls, clFtpUtils, clHttpUtils, clWUtils, clResourceState;

type
  TclVersionFormat = (vfStandard, vfNumber, vfTimeStamp);
  TclUpdateStatus = (usDownload, usReady, usSuccess, usFailed);
  TclUpdateState = (utGetUpdateInfo, utDownload, utGetTimeStamp);
  TclRunUpdateResult = (urSuccess, urError, urCancel);

  TclUpdateInfoItem = class(TCollectionItem)
  private
    FURL: string;
    FVersion: string;
    FSize: string;
    FLocalFile: string;
    FUpdateDate: string;
    FStatus: TclUpdateStatus;
    FUpdateScript: TStrings;
    FNeedTerminate: Boolean;
    FResourceState: TclResourceStateList;
    FDescription: string;
    FContentType: string;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure UpdateStatus(ANewStatus: TclUpdateStatus);
    
    property UpdateScript: TStrings read FUpdateScript;
    property URL: string read FURL write FURL;
    property LocalFile: string read FLocalFile write FLocalFile;
    property Size: string read FSize write FSize;
    property Version: string read FVersion write FVersion;
    property UpdateDate: string read FUpdateDate write FUpdateDate;
    property Status: TclUpdateStatus read FStatus write FStatus;
    property NeedTerminate: Boolean read FNeedTerminate write FNeedTerminate;
    property ResourceState: TclResourceStateList read FResourceState;
    property Description: string read FDescription write FDescription;
    property ContentType: string read FContentType write FContentType;
  end;

  TclUpdateInfoList = class(TCollection)
  private
    function GetItem(Index: Integer): TclUpdateInfoItem;
    procedure SetItem(Index: Integer; const Value: TclUpdateInfoItem);
    function GetHasDownloads: Boolean;
    function GetHasUpdates: Boolean;
    function GetLastVersion: string;
    procedure LoadResourceState(ANode: IXMLDomNode; AResourceState: TclResourceStateList);
    procedure SaveResourceState(ANode: IXMLDomNode; AResourceState: TclResourceStateList);
{$IFDEF DELPHI6}
    function GetBigInt(AValue: Int64): Int64;
{$ELSE}
    function GetBigInt(AValue: Integer): Integer;
{$ENDIF}
  public
    constructor Create;
    function GetFirst(AStatus: TclUpdateStatus): Integer;
    procedure LoadFromXml(const AFileName: string);
    procedure SaveToXml(const AFileName: string);
    function ItemByUrl(const AUrl: string): TclUpdateInfoItem;
    function LastItemByUrl(const AUrl: string): TclUpdateInfoItem;
    function LastItemByStatus(AStatus: TclUpdateStatus): TclUpdateInfoItem;
    function Add: TclUpdateInfoItem;

    property Items[Index: Integer]: TclUpdateInfoItem read GetItem write SetItem; default;
    property HasDownloads: Boolean read GetHasDownloads;
    property HasUpdates: Boolean read GetHasUpdates;
    property LastVersion: string read GetLastVersion;
  end;

  TclWebUpdate = class;

  TclHasUpdateEvent = procedure (Sender: TObject; const AUpdateItem: TclUpdateInfoItem;
    ActualInfo: TclUpdateInfoList; var CanUpdate, Handled: Boolean) of object;
  TclDownloadEvent = procedure (Sender: TObject; const DownloadURL, DownloadFile: string) of object;
  TclRunUpdateEvent = procedure (Sender: TObject; AUpdateScript: TStrings; ANeedTerminate: Boolean;
    var CanRun: Boolean; var Result: TclRunUpdateResult; var AErrors: string) of object;
  TclTerminatingEvent = procedure (Sender: TObject; var CanTerminate: Boolean) of object;
  TclDownloadProgressEvent = procedure (Sender: TObject; UpdateNo: Integer; Downloaded, Total: Int64) of object;
  TclShowInfoEvent = procedure (Sender: TObject; AUpdater: TclWebUpdate; var CanUpdate: Boolean) of object;
  TclGetUpdateInfoEvent = procedure (Sender: TObject; ActualInfo: TclUpdateInfoList;
    UpdateInfo: TclUpdateInfoList) of object;
  TclWebUpdateErrorEvent = procedure (Sender: TObject; UpdateNo: Integer;
    const Error: string; ErrorCode: Integer) of object;

  TclWebUpdate = class(TComponent)
  private
    FIsBusy: Boolean;
    FDownloader: TclDownloader;
    FUpdateState: TclUpdateState;
    FUpdateURL: string;
    FActualUpdateInfoFile: string;
    FVersionFormat: TclVersionFormat;
    FNeedShowInfo: Boolean;
    FActualInfo: TclUpdateInfoList;
    FUpdateInfo: TclUpdateInfoList;
    FUpdateNo: Integer;
    FNeedTerminate: Boolean;
    FProductName: string;
    FProductURL: string;
    FAuthor: string;
    FEmail: string;
    FUpdateDir: string;
    FErrorWords: TStrings;

    FOnDownloadProgress: TclDownloadProgressEvent;
    FOnError: TclWebUpdateErrorEvent;
    FOnHasUpdate: TclHasUpdateEvent;
    FOnTerminating: TclTerminatingEvent;
    FOnRunUpdate: TclRunUpdateEvent;
    FOnAfterDownload: TclDownloadEvent;
    FOnBeforeDownload: TclDownloadEvent;
    FOnShowInfo: TclShowInfoEvent;
    FOnNoUpdatesFound: TNotifyEvent;
    FOnGetUpdateInfo: TclGetUpdateInfoEvent;
    FOnProcessCompleted: TNotifyEvent;
    
    procedure DoOnProcessCompleted(Sender: TObject);
    procedure DoOnError(Sender: TObject; const Error: string; ErrorCode: Integer);
    procedure DoOnDataItemProceed(Sender: TObject; ResourceInfo: TclResourceInfo;
      AStateItem: TclResourceStateItem; CurrentData: PclChar; CurrentDataSize: Integer);
    function GetIsBusy: Boolean;

    function CheckUpdateVersion(AUpdateItem: TclUpdateInfoItem): Boolean;
    function HasUpdate(AUpdateItem: TclUpdateInfoItem): Boolean;
    procedure CheckUpdateInfo;
    function ShowInfo(): Boolean;
    procedure GetUpdateInfo;
    procedure StoreActualInfo;

    procedure StartDownloading;
    procedure StartUpdating;
    function RunUpdate(AUpdateItem: TclUpdateInfoItem): Boolean;
    procedure Terminating;
    procedure SetUpdateDir(const Value: string);
    function PerformCmdFile(const AFileName: string): Integer;
    function GetLogError(ALogStrings: TStrings): string;
    procedure SetErrorWords(const Value: TStrings);
    procedure ReplaceScriptKeywords(AScript: TStrings);
    function GetBatchSize: Integer;
    function GetPort_: Integer;
    procedure SetBatchSize(const Value: Integer);
    procedure SetPort_(const Value: Integer);
    function GetPassiveFtpMode: Boolean;
    procedure SetPassiveFtpMode(const Value: Boolean);
    function GetCertificateFlags: TclCertificateVerifyFlags;
    function GetFtpProxySettings: TclFtpProxySettings;
    function GetHttpProxySettings: TclHttpProxySettings;
    function GetTryCount: Integer;
    function GetInternetAgent: string;
    function GetProxyBypass: TStrings;
    function GetReconnectAfter: Integer;
    function GetThreadCount: Integer;
    function GetTimeOut: Integer;
    procedure SetCertificateFlags(const Value: TclCertificateVerifyFlags);
    procedure SetFtpProxySettings(const Value: TclFtpProxySettings);
    procedure SetHttpProxySettings(const Value: TclHttpProxySettings);
    procedure SetTryCount(const Value: Integer);
    procedure SetInternetAgent(const Value: string);
    procedure SetProxyBypass(const Value: TStrings);
    procedure SetReconnectAfter(const Value: Integer);
    procedure SetThreadCount(const Value: Integer);
    procedure SetTimeOut(const Value: Integer);
    function MakeCompleteNumber(S: string): Integer;
    function CheckUpdateTimeStamp(AUpdateItem: TclUpdateInfoItem): Boolean;
    function GetTimeStamp(const AURL: string): string;
    function GetPassword: string;
    function GetUserName_: string;
    procedure SetPassword(const Value: string);
    procedure SetUserName(const Value: string);
  protected
    procedure DoGetUpdateInfo; dynamic;
    procedure DoHasUpdate(const AUpdateItem: TclUpdateInfoItem; ActualInfo: TclUpdateInfoList;
      var CanUpdate, Handled: Boolean); dynamic;
    procedure DoBeforeDownload(const DownloadURL, DownloadFile: string); dynamic;
    procedure DoAfterDownload(const DownloadURL, DownloadFile: string); dynamic;
    procedure DoShowInfo(var CanUpdate: Boolean); dynamic;
    procedure DoRunUpdate(AUpdateScript: TStrings; ANeedTerminate: Boolean;
      var CanRun: Boolean; var Result: TclRunUpdateResult; var AErrors: string); dynamic;
    procedure DoTerminating(var CanTerminate: Boolean); dynamic;
    procedure DoDownloadProgress(UpdateNo: Integer; Downloaded, Total: Int64); dynamic;
    procedure DoError(UpdateNo: Integer; const Error: string; ErrorCode: Integer); dynamic;
    procedure DoNoUpdatesFound;
    procedure DoProcessCompleted;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Start(IsAsynch: Boolean = True);
    procedure Stop;
    property IsBusy: Boolean read GetIsBusy;
    property NeedTerminate: Boolean read FNeedTerminate;
    property ActualInfo: TclUpdateInfoList read FActualInfo;
    property UpdateInfo: TclUpdateInfoList read FUpdateInfo;
  published
    property ProductName: string read FProductName write FProductName;
    property Author: string read FAuthor write FAuthor;
    property ProductURL: string read FProductURL write FProductURL;
    property Email: string read FEmail write FEmail;
    property UpdateURL: string read FUpdateURL write FUpdateURL;
    property UpdateDir: string read FUpdateDir write SetUpdateDir;
    property ActualUpdateInfoFile: string read FActualUpdateInfoFile write FActualUpdateInfoFile;
    property VersionFormat: TclVersionFormat read FVersionFormat write FVersionFormat default vfStandard;
    property NeedShowInfo: Boolean read FNeedShowInfo write FNeedShowInfo default True;
    property ErrorWords: TStrings read FErrorWords write SetErrorWords;

    property UserName: string read GetUserName_ write SetUserName;
    property Password: string read GetPassword write SetPassword;
    property Port: Integer read GetPort_ write SetPort_ default 0;
    property PassiveFtpMode: Boolean read GetPassiveFtpMode write SetPassiveFtpMode default False;
    property HttpProxySettings: TclHttpProxySettings read GetHttpProxySettings write SetHttpProxySettings;
    property FtpProxySettings: TclFtpProxySettings read GetFtpProxySettings write SetFtpProxySettings;
    property ProxyBypass: TStrings read GetProxyBypass write SetProxyBypass;
    property InternetAgent: string read GetInternetAgent write SetInternetAgent;
    property TryCount: Integer read GetTryCount write SetTryCount default DefaultTryCount;
    property TimeOut: Integer read GetTimeOut write SetTimeOut default DefaultTimeOut;
    property ReconnectAfter: Integer read GetReconnectAfter write SetReconnectAfter default DefaultTimeOut;
    property CertificateFlags: TclCertificateVerifyFlags read GetCertificateFlags write SetCertificateFlags default [];
    property ThreadCount: Integer read GetThreadCount write SetThreadCount default DefaultThreadCount;
    property BatchSize: Integer read GetBatchSize write SetBatchSize default DefaultBatchSize;

    property OnGetUpdateInfo: TclGetUpdateInfoEvent read FOnGetUpdateInfo write FOnGetUpdateInfo;
    property OnShowInfo: TclShowInfoEvent read FOnShowInfo write FOnShowInfo;
    property OnHasUpdate: TclHasUpdateEvent read FOnHasUpdate write FOnHasUpdate;
    property OnBeforeDownload: TclDownloadEvent read FOnBeforeDownload write FOnBeforeDownload;
    property OnAfterDownload: TclDownloadEvent read FOnAfterDownload write FOnAfterDownload;
    property OnRunUpdate: TclRunUpdateEvent read FOnRunUpdate write FOnRunUpdate;
    property OnTerminating: TclTerminatingEvent read FOnTerminating write FOnTerminating;
    property OnDownloadProgress: TclDownloadProgressEvent read FOnDownloadProgress write FOnDownloadProgress;
    property OnError: TclWebUpdateErrorEvent read FOnError write FOnError;
    property OnNoUpdatesFound: TNotifyEvent read FOnNoUpdatesFound write FOnNoUpdatesFound;
    property OnProcessCompleted: TNotifyEvent read FOnProcessCompleted write FOnProcessCompleted;
  end;

const
  cAppDir = '$(app)';
  cUpdateDir = '$(update)';
  
implementation

uses
  clUpdateInfoForm, clSingleDC, clWinInet, clUriUtils;

const
  cUpdateStatusNames: array[TclUpdateStatus] of string = ('download', 'ready', 'success', 'failed');
  cBooleanNames: array[Boolean] of string = ('no', 'yes');

{ TclWebUpdate }

constructor TclWebUpdate.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FErrorWords := TStringList.Create();
  FErrorWords.Add('fatal');
  FErrorWords.Add('failed');
  FErrorWords.Add('error');
  FActualInfo := TclUpdateInfoList.Create();
  FUpdateInfo := TclUpdateInfoList.Create();
  FDownloader := TclDownloader.Create(nil);
  FDownloader.OnProcessCompleted := DoOnProcessCompleted;
  FDownloader.OnError := DoOnError;
  FDownloader.OnDataItemProceed := DoOnDataItemProceed;
  FActualUpdateInfoFile := 'lastupdate.xml';
  FVersionFormat := vfStandard;
  FNeedShowInfo := True;
  FUpdateDir := '.\';
end;

destructor TclWebUpdate.Destroy;
begin
  Stop();
  while IsBusy do
  begin
    Application.ProcessMessages();
  end;
  FDownloader.Free();
  FUpdateInfo.Free();
  FActualInfo.Free();
  FErrorWords.Free();
  inherited Destroy();
end;

procedure TclWebUpdate.StartUpdating;
var
  i: Integer;
begin
  for i := 0 to ActualInfo.Count - 1 do
  begin
    if FIsBusy and (ActualInfo[i].Status = usReady) then
    begin
      if not RunUpdate(ActualInfo[i]) then
      begin
        Break;
      end;
    end;
  end;
  FIsBusy := False;
  DoProcessCompleted();
  if NeedTerminate then
  begin
    Terminating();
  end;
end;

procedure TclWebUpdate.Terminating;
var
  CanTerminate: Boolean;
begin
  CanTerminate := True;
  DoTerminating(CanTerminate);
  if CanTerminate then
  begin
    Application.Terminate();
  end;
end;

procedure TclWebUpdate.DoOnProcessCompleted(Sender: TObject);
var
  Success: Boolean;
begin
  if (FUpdateState = utGetTimeStamp) then
  begin
    Exit;
  end;

  Success := (FDownloader.ResourceState.LastStatus = psSuccess);

  if (FUpdateState = utDownload) then
  begin
    if Success then
    begin
      ActualInfo[FUpdateNo].UpdateStatus(usReady);
    end else
    begin
      ActualInfo[FUpdateNo].ResourceState.Assign(FDownloader.ResourceState);
    end;
    StoreActualInfo();
    if Success then
    begin
      DoAfterDownload(FDownloader.URL, FDownloader.LocalFile);

      repeat
        Inc(FUpdateNo);
      until ((FUpdateNo >= ActualInfo.Count) or (ActualInfo[FUpdateNo].Status = usDownload));
      
      if (FUpdateNo < ActualInfo.Count) then
      begin
        StartDownloading();
      end else
      begin
        FUpdateState := utGetUpdateInfo;
        StartUpdating();
      end;
    end else
    begin
      FIsBusy := False;
      DoProcessCompleted();
    end;
  end else
  if Success then
  begin
    CheckUpdateInfo();
  end else
  begin
    FIsBusy := False;
    DoProcessCompleted();
  end;
end;

procedure TclWebUpdate.CheckUpdateInfo;
var
  i: integer;
begin
  GetUpdateInfo();

  for i := 0 to UpdateInfo.Count - 1 do
  begin
    if HasUpdate(UpdateInfo[i]) then
    begin
      ActualInfo.Add().Assign(UpdateInfo[i]);
    end;
  end;

  if not FIsBusy then Exit;
  if ActualInfo.HasDownloads then
  begin
    if ShowInfo() then
    begin
      FUpdateNo := ActualInfo.GetFirst(usDownload);
      FUpdateState := utDownload;
      StoreActualInfo();
      StartDownloading();
    end else
    begin
      FIsBusy := False;
      DoProcessCompleted();
    end;
  end else
  if ActualInfo.HasUpdates then
  begin
    StartUpdating();
  end else
  begin
    DoNoUpdatesFound();
    FIsBusy := False;
    DoProcessCompleted();
  end;
end;

procedure TclWebUpdate.Start(IsAsynch: Boolean);
begin
  if FIsBusy then Exit;
  FUpdateNo := -1;
  FIsBusy := True;
  FUpdateState := utGetUpdateInfo;
  FNeedTerminate := False;
  FDownloader.LocalFolder := UpdateDir;
  FDownloader.URL := UpdateURL;
  FDownloader.UserName := UserName;
  FDownloader.Password := Password;
  FDownloader.Start();
end;

function TclWebUpdate.MakeCompleteNumber(S: string): Integer;
var
  i, Cnt, Len, OldPos: Integer;
begin
  S := Trim(S);
  Result := 0;
  Len := Length(S);
  Cnt := 0;
  OldPos := Len + 1;
  for i := Len downto 1 do
  begin
    if (S[i] = '.') then
    begin
      Result := Result + StrToIntDef('0' + system.Copy(S, i + 1, OldPos - i - 1), 0) * Round(Power(1000, Cnt));
      Inc(Cnt);
      OldPos := i;
    end else
    if (i = 1) then
    begin
      Result := Result + StrToIntDef('0' + system.Copy(S, i, OldPos - i), 0) * Round(Power(1000, Cnt));
    end;
  end;
end;

function TclWebUpdate.GetTimeStamp(const AURL: string): string;
begin
  Result := '';

  FUpdateState := utGetTimeStamp;
  FDownloader.URL := AURL;
  FDownloader.CloseConnection();
  FDownloader.GetResourceInfo(False);

  if (FDownloader.Errors.Count > 0) or (FDownloader.ResourceInfo = nil) then Exit;

  Result := FloatToStr(FDownloader.ResourceInfo.Date);
end;

function TclWebUpdate.CheckUpdateTimeStamp(AUpdateItem: TclUpdateInfoItem): Boolean;
var
  ActualItem: TclUpdateInfoItem;
begin
  ActualItem := ActualInfo.LastItemByUrl(AUpdateItem.URL);

  AUpdateItem.Version := GetTimeStamp(AUpdateItem.URL);

  Result := (ActualItem = nil) or (StrToFloatDef(ActualItem.Version, 0) < StrToFloatDef(AUpdateItem.Version, 0));
end;

function TclWebUpdate.CheckUpdateVersion(AUpdateItem: TclUpdateInfoItem): Boolean;
begin
  Result := True;

  if (ActualInfo.LastVersion = '') then Exit;
  
  if (VersionFormat = vfStandard) then
  begin
    Result := (MakeCompleteNumber(AUpdateItem.Version) > MakeCompleteNumber(ActualInfo.LastVersion));
  end else
  if (VersionFormat = vfTimeStamp) then
  begin
    Result := CheckUpdateTimeStamp(AUpdateItem);
  end else
  if (VersionFormat = vfNumber) then
  begin
    Result := StrToIntDef(AUpdateItem.Version, 0) > StrToIntDef(ActualInfo.LastVersion, 0);
  end else
  begin
    Assert(False, 'Not implemented');
  end;
end;

function TclWebUpdate.HasUpdate(AUpdateItem: TclUpdateInfoItem): Boolean;
var
  handled: Boolean;
begin
  handled := False;
  Result := True;

  DoHasUpdate(AUpdateItem, ActualInfo, Result, handled);
  if not handled then
  begin
    Result := CheckUpdateVersion(AUpdateItem);
  end;
end;

procedure TclWebUpdate.GetUpdateInfo;
var
  i: Integer;
begin
  UpdateInfo.LoadFromXml(FDownloader.LocalFile);

  for i := 0 to UpdateInfo.Count - 1 do
  begin
    UpdateInfo[i].URL := TclUrlParser.CombineUrl(UpdateInfo[i].URL, UpdateURL);
  end;
  
  ActualInfo.LoadFromXml(ActualUpdateInfoFile);
  DoGetUpdateInfo();
end;

function TclWebUpdate.GetUserName_: string;
begin
  Result := FDownloader.UserName;
end;

function TclWebUpdate.ShowInfo(): Boolean;
begin
  Result := True;
  DoShowInfo(Result);
  if NeedShowInfo then
  begin
    Result := TfrmUpdateInfo.ShowInfo(Self);
  end;
end;

procedure TclWebUpdate.StartDownloading;
begin
  FDownloader.URL := ActualInfo[FUpdateNo].URL;
  if (FDownloader.UserName = '') then
  begin
    FDownloader.UserName := UserName;
  end;
  if (FDownloader.Password = '') then
  begin
    FDownloader.Password := Password;
  end;
  ActualInfo[FUpdateNo].FLocalFile := FDownloader.LocalFile;
  DoBeforeDownload(FDownloader.URL, FDownloader.LocalFile);
  FDownloader.ResourceState.Assign(ActualInfo[FUpdateNo].ResourceState);
  FDownloader.Start();
end;

function TclWebUpdate.PerformCmdFile(const AFileName: string): Integer;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  Res: DWORD;
  s: string;
begin
  ZeroMemory(@StartupInfo, SizeOf(TStartupInfo));
  StartupInfo.cb := SizeOf(TStartupInfo);
  StartupInfo.dwFlags := StartupInfo.dwFlags or STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_HIDE;

  ZeroMemory(@ProcessInfo, SizeOf(TProcessInformation));

  s := Trim(AFileName + ' ');
  if not CreateProcess(nil, PChar(s), nil, nil, False,
    CREATE_NEW_CONSOLE or CREATE_NO_WINDOW, nil, nil, StartupInfo, ProcessInfo) then
  begin
    raise Exception.CreateFmt('Can not run cmd file, error %d', [GetLastError()]);
  end;

  CloseHandle(ProcessInfo.hThread);
  WaitForSingleObject(ProcessInfo.hProcess, INFINITE);
  GetExitCodeProcess(ProcessInfo.hProcess, Res);
  Result := Res;
  CloseHandle(ProcessInfo.hProcess);
end;

function TclWebUpdate.GetLogError(ALogStrings: TStrings): string;
  function CheckWordExists(const Buffer, NeededString: String): Boolean;
  var
    ind: Integer;
  begin
    ind := system.Pos(LowerCase(NeededString), LowerCase(Buffer));
    Result := (ind > 0);
    if not Result then Exit;

    if (ind > 1) and not CharInSet(Buffer[ind - 1], [#32, #9, #10]) then
    begin
      Result := False;
    end;
    if not Result then Exit;

    ind := ind + Length(NeededString) - 1;
    if (ind < Length(Buffer)) and not CharInSet(Buffer[ind + 1], [#32, #9, #13, ',', '.']) then
    begin
      Result := False;
    end;
  end;

var
  i, j: Integer;
begin
  for i := 0 to ALogStrings.Count - 1 do
  begin
    Result := ALogStrings[i];
    for j := 0 to ErrorWords.Count - 1 do
    begin
      if CheckWordExists(LowerCase(Result), LowerCase(ErrorWords[j])) then Exit;
    end;
  end;
  Result := '';
end;

procedure TclWebUpdate.ReplaceScriptKeywords(AScript: TStrings);
var
  path: string;
begin
  path := ExtractFilePath(ParamStr(0));
  if (path <> '') and (path[Length(path)] = '\') then
  begin
    Delete(path, Length(path), 1);
  end;
  AScript.Text := StringReplace(AScript.Text, cAppDir, path, [rfReplaceAll, rfIgnoreCase]);
  AScript.Text := StringReplace(AScript.Text, cUpdateDir, UpdateDir, [rfReplaceAll, rfIgnoreCase]);
end;

function TclWebUpdate.RunUpdate(AUpdateItem: TclUpdateInfoItem): Boolean;
const
  cRunName = 'B1BD76091FF7';

var
  tempCmdName, tempLogName, error: string;
  canRun: Boolean;
  logStrings, script: TStrings;
  runResult: TclRunUpdateResult; 
begin
  if (AUpdateItem.NeedTerminate) then
  begin
    FNeedTerminate := True;
  end;
  canRun := True;
  error := '';
  script := TStringList.Create();
  try
    script.Assign(AUpdateItem.UpdateScript);
    ReplaceScriptKeywords(script);
    
    runResult := urSuccess;
    DoRunUpdate(script, AUpdateItem.NeedTerminate, canRun, runResult, error);

    if canRun and (runResult = urSuccess) and (script.Count > 0) then
    begin
      tempCmdName := GetFullFileName(cRunName + '.cmd', ExtractFilePath(ParamStr(0)));
      tempLogName := GetFullFileName(cRunName + '.log', ExtractFilePath(ParamStr(0)));
      logStrings := TStringList.Create();
      try
        script.SaveToFile(tempCmdName);
        PerformCmdFile('"' + tempCmdName + '" > "' + tempLogName + '"');
        logStrings.LoadFromFile(tempLogName);
        error := GetLogError(logStrings);

        if (error <> '') then
        begin
          runResult := urError;
        end;
      finally
        logStrings.Free();
        DeleteFile(PChar(tempLogName));
        DeleteFile(PChar(tempCmdName));
      end;
    end;
  finally
    script.Free();
  end;

  case runResult of
    urSuccess:
      begin
        AUpdateItem.UpdateStatus(usSuccess);
      end;
    urError:
      begin
        AUpdateItem.UpdateStatus(usFailed);
        DoError(AUpdateItem.Index, Format('The updating of %s file was returned with errors (%s). ',
          [ExtractFileName(AUpdateItem.LocalFile), error]), -1);
      end;
  end;
  Result := (runResult <> urError);

  StoreActualInfo();
end;

procedure TclWebUpdate.StoreActualInfo;
begin
  ActualInfo.SaveToXml(ActualUpdateInfoFile);
end;

procedure TclWebUpdate.Stop;
begin
  FIsBusy := False;
  FDownloader.Stop();
end;

procedure TclWebUpdate.DoOnDataItemProceed(Sender: TObject; ResourceInfo: TclResourceInfo;
  AStateItem: TclResourceStateItem; CurrentData: PclChar; CurrentDataSize: Integer);
begin
  if (FUpdateState = utDownload) then
  begin
    DoDownloadProgress(FUpdateNo, AStateItem.ResourceState.BytesProceed, ResourceInfo.Size);
  end;
end;

procedure TclWebUpdate.DoOnError(Sender: TObject; const Error: string; ErrorCode: Integer);
begin
  DoError(FUpdateNo, Error, ErrorCode);
end;

procedure TclWebUpdate.DoAfterDownload(const DownloadURL, DownloadFile: string);
begin
  if Assigned(OnAfterDownload) then
  begin
    OnAfterDownload(Self, DownloadURL, DownloadFile);
  end;
end;

procedure TclWebUpdate.DoBeforeDownload(const DownloadURL, DownloadFile: string);
begin
  if Assigned(OnBeforeDownload) then
  begin
    OnBeforeDownload(Self, DownloadURL, DownloadFile);
  end;
end;

procedure TclWebUpdate.DoDownloadProgress(UpdateNo: Integer; Downloaded, Total: Int64);
begin
  if Assigned(OnDownloadProgress) then
  begin
    OnDownloadProgress(Self, UpdateNo, Downloaded, Total);
  end;
end;

procedure TclWebUpdate.DoError(UpdateNo: Integer; const Error: string; ErrorCode: Integer);
begin
  if Assigned(OnError) then
  begin
    OnError(Self, UpdateNo, Error, ErrorCode);
  end;
end;

procedure TclWebUpdate.DoHasUpdate(const AUpdateItem: TclUpdateInfoItem; ActualInfo: TclUpdateInfoList;
  var CanUpdate, Handled: Boolean);
begin
  if Assigned(OnHasUpdate) then
  begin
    OnHasUpdate(Self, AUpdateItem, ActualInfo, CanUpdate, Handled);
  end;
end;

procedure TclWebUpdate.DoRunUpdate(AUpdateScript: TStrings; ANeedTerminate: Boolean;
  var CanRun: Boolean; var Result: TclRunUpdateResult; var AErrors: string);
begin
  if Assigned(OnRunUpdate) then
  begin
    OnRunUpdate(Self, AUpdateScript, ANeedTerminate, CanRun, Result, AErrors);
  end;
end;

procedure TclWebUpdate.DoShowInfo(var CanUpdate: Boolean);
begin
  if Assigned(OnShowInfo) then
  begin
    OnShowInfo(Self, Self, CanUpdate);
  end;
end;

procedure TclWebUpdate.DoTerminating(var CanTerminate: Boolean);
begin
  if Assigned(OnTerminating) then
  begin
    OnTerminating(Self, CanTerminate);
  end;
end;

procedure TclWebUpdate.DoNoUpdatesFound;
begin
  if Assigned(OnNoUpdatesFound) then
  begin
    OnNoUpdatesFound(Self);
  end;
end;

procedure TclWebUpdate.DoGetUpdateInfo;
begin
  if Assigned(OnGetUpdateInfo) then
  begin
    OnGetUpdateInfo(Self, ActualInfo, UpdateInfo);
  end;
end;

function TclWebUpdate.GetTryCount: Integer;
begin
  Result := FDownloader.TryCount;
end;

function TclWebUpdate.GetInternetAgent: string;
begin
  Result := FDownloader.InternetAgent;
end;

function TclWebUpdate.GetIsBusy: Boolean;
begin
  Result := FDownloader.IsBusy or FIsBusy;
end;

procedure TclWebUpdate.SetUpdateDir(const Value: string);
begin
  FUpdateDir := Value;
  if not (csLoading in ComponentState) then
  begin
    ActualUpdateInfoFile := GetFullFileName(ActualUpdateInfoFile, FUpdateDir);
  end;
end;

procedure TclWebUpdate.SetUserName(const Value: string);
begin
  FDownloader.UserName := Value;
end;

procedure TclWebUpdate.SetErrorWords(const Value: TStrings);
begin
  FErrorWords.Assign(Value);
end;

procedure TclWebUpdate.SetFtpProxySettings(const Value: TclFtpProxySettings);
begin
  FDownloader.FtpProxySettings := Value;
end;

procedure TclWebUpdate.SetHttpProxySettings(const Value: TclHttpProxySettings);
begin
  FDownloader.HttpProxySettings := Value;
end;

procedure TclWebUpdate.SetTryCount(const Value: Integer);
begin
  FDownloader.TryCount := Value;
end;

procedure TclWebUpdate.SetInternetAgent(const Value: string);
begin
  FDownloader.InternetAgent := Value;
end;

function TclWebUpdate.GetBatchSize: Integer;
begin
  Result := FDownloader.BatchSize;
end;

function TclWebUpdate.GetCertificateFlags: TclCertificateVerifyFlags;
begin
  Result := FDownloader.CertificateFlags;
end;

function TclWebUpdate.GetFtpProxySettings: TclFtpProxySettings;
begin
  Result := FDownloader.FtpProxySettings;
end;

function TclWebUpdate.GetHttpProxySettings: TclHttpProxySettings;
begin
  Result := FDownloader.HttpProxySettings;
end;

procedure TclWebUpdate.SetBatchSize(const Value: Integer);
begin
  FDownloader.BatchSize := Value;
end;

procedure TclWebUpdate.SetCertificateFlags(const Value: TclCertificateVerifyFlags);
begin
  FDownloader.CertificateFlags := Value;
end;

function TclWebUpdate.GetPort_: Integer;
begin
  Result := FDownloader.Port;
end;

function TclWebUpdate.GetProxyBypass: TStrings;
begin
  Result := FDownloader.ProxyBypass;
end;

function TclWebUpdate.GetReconnectAfter: Integer;
begin
  Result := FDownloader.ReconnectAfter;
end;

function TclWebUpdate.GetThreadCount: Integer;
begin
  Result := FDownloader.ThreadCount;
end;

function TclWebUpdate.GetTimeOut: Integer;
begin
  Result := FDownloader.TimeOut;
end;

procedure TclWebUpdate.SetPort_(const Value: Integer);
begin
  FDownloader.Port := Value;
end;

procedure TclWebUpdate.SetProxyBypass(const Value: TStrings);
begin
  FDownloader.ProxyBypass := Value;
end;

procedure TclWebUpdate.SetReconnectAfter(const Value: Integer);
begin
  FDownloader.ReconnectAfter := Value;
end;

procedure TclWebUpdate.SetThreadCount(const Value: Integer);
begin
  FDownloader.ThreadCount := Value;
end;

procedure TclWebUpdate.SetTimeOut(const Value: Integer);
begin
  FDownloader.TimeOut := Value;
end;

procedure TclWebUpdate.DoProcessCompleted;
begin
  if Assigned(OnProcessCompleted) then
  begin
    OnProcessCompleted(Self);
  end;
end;

function TclWebUpdate.GetPassiveFtpMode: Boolean;
begin
  Result := FDownloader.PassiveFTPMode;
end;

function TclWebUpdate.GetPassword: string;
begin
  Result := FDownloader.Password;
end;

procedure TclWebUpdate.SetPassiveFtpMode(const Value: Boolean);
begin
  FDownloader.PassiveFTPMode := Value;
end;

procedure TclWebUpdate.SetPassword(const Value: string);
begin
  FDownloader.Password := Value;
end;

{ TclUpdateInfoList }

function TclUpdateInfoList.Add: TclUpdateInfoItem;
begin
  Result := TclUpdateInfoItem(inherited Add());
end;

constructor TclUpdateInfoList.Create;
begin
  inherited Create(TclUpdateInfoItem);
end;

function TclUpdateInfoList.GetLastVersion: string;
begin
  if (Count > 0) then
  begin
    Result := Items[Count - 1].Version;
  end else
  begin
    Result := '';
  end;
end;

function TclUpdateInfoList.ItemByUrl(const AUrl: string): TclUpdateInfoItem;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    if SameText(AUrl, Items[i].URL) then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
  Result := nil;
end;

function TclUpdateInfoList.GetFirst(AStatus: TclUpdateStatus): Integer;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    if (Items[i].Status = AStatus) then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

function TclUpdateInfoList.GetHasDownloads: Boolean;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
  begin
    Result := (Items[i].Status = usDownload);
    if Result then Exit;
  end;
  Result := False;
end;

function TclUpdateInfoList.GetHasUpdates: Boolean;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
  begin
    Result := (Items[i].Status = usReady);
    if Result then Exit;
  end;
  Result := False;
end;

function TclUpdateInfoList.GetItem(Index: Integer): TclUpdateInfoItem;
begin
  Result := TclUpdateInfoItem(inherited GetItem(Index));
end;

function TclUpdateInfoList.LastItemByStatus(AStatus: TclUpdateStatus): TclUpdateInfoItem;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
  begin
    if (Items[i].Status = AStatus) then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
  Result := nil;
end;

function TclUpdateInfoList.LastItemByUrl(const AUrl: string): TclUpdateInfoItem;
var
  i: Integer;
begin
  for i := Count - 1 downto 0 do
  begin
    if SameText(AUrl, Items[i].URL) then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
  Result := nil;
end;

procedure TclUpdateInfoList.LoadFromXml(const AFileName: string);
var
  i, ind: Integer;
  Item: TclUpdateInfoItem;
  Dom: IXMLDomDocument;
  NodeList: IXMLDOMNodeList;
  node: IXMLDomNode;
begin
  Dom := CoDOMDocument.Create();
  Dom.load(AFileName);

  Clear();
  NodeList := Dom.selectNodes('updateinfo/update');
  for i := 0 to NodeList.length - 1 do
  begin
    Item := Add();
    Item.FURL := GetAttributeValue(NodeList.item[i], 'url');
    Item.FLocalFile := GetAttributeValue(NodeList.item[i], 'localfile');
    Item.FSize := GetAttributeValue(NodeList.item[i], 'size');
    Item.FVersion := GetAttributeValue(NodeList.item[i], 'version');
    Item.FUpdateDate := GetAttributeValue(NodeList.item[i], 'updatedate');
    Item.FDescription := GetNodeValueByName(NodeList.item[i], 'description');
    Item.FContentType := GetAttributeValue(NodeList.item[i], 'contenttype');
    XMLToStrings(Item.UpdateScript, NodeList.item[i].selectSingleNode('script'));

    ind := IndexOfStrArray(GetAttributeValue(NodeList.item[i], 'status'), cUpdateStatusNames);
    if (ind > -1) then
    begin
      Item.FStatus := TclUpdateStatus(ind);
    end;

    ind := IndexOfStrArray(GetAttributeValue(NodeList.item[i], 'terminate'), cBooleanNames);
    if (ind > -1) then
    begin
      Item.FNeedTerminate := Boolean(ind);
    end;

    node := NodeList.item[i].selectSingleNode('resourcestate');
    if (node <> nil) then
    begin
      LoadResourceState(node, Item.ResourceState);
    end;
  end;
end;

procedure TclUpdateInfoList.LoadResourceState(ANode: IXMLDomNode;
  AResourceState: TclResourceStateList);
var
  i: Integer;
  NodeList: IXMLDOMNodeList;
  Item: TclResourceStateItem;
begin
  AResourceState.ResourceSize := StrToIntDef(GetAttributeValue(ANode, 'resourcesize'), 0);
  NodeList := ANode.selectNodes('item');
  for i := 0 to NodeList.length - 1 do
  begin
    Item := AResourceState.Add();
    Item.ResourcePos := StrToIntDef(GetAttributeValue(NodeList.item[i], 'resourcepos'), 0);
    Item.BytesToProceed := StrToIntDef(GetAttributeValue(NodeList.item[i], 'bytestoproceed'), 0);
    Item.BytesProceed := StrToIntDef(GetAttributeValue(NodeList.item[i], 'bytesproceed'), 0);
  end;
end;

{$IFDEF DELPHI6}
function TclUpdateInfoList.GetBigInt(AValue: Int64): Int64;
begin
  Result := AValue;
end;
{$ELSE}
function TclUpdateInfoList.GetBigInt(AValue: Integer): Integer;
begin
  Result := AValue;
end;
{$ENDIF}

procedure TclUpdateInfoList.SaveResourceState(ANode: IXMLDomNode;
  AResourceState: TclResourceStateList);
var
  i: Integer;
  node: IXMLDomNode;
begin
  (ANode as IXMLDOMElement).setAttribute('resourcesize', GetBigInt(AResourceState.ResourceSize));
  for i := 0 to AResourceState.Count - 1 do
  begin
    node := ANode.ownerDocument.createElement('item');
    ANode.appendChild(node);

    (node as IXMLDOMElement).setAttribute('resourcepos', GetBigInt(AResourceState[i].ResourcePos));
    (node as IXMLDOMElement).setAttribute('bytestoproceed', GetBigInt(AResourceState[i].BytesToProceed));
    (node as IXMLDOMElement).setAttribute('bytesproceed', GetBigInt(AResourceState[i].BytesProceed));
  end;
end;

procedure TclUpdateInfoList.SaveToXml(const AFileName: string);
var
  i: Integer;
  Dom: IXMLDomDocument;
  UpdateInfoNode, Node, tempNode: IXMLDOMElement;
begin
  Dom := CoDOMDocument.Create();

  UpdateInfoNode := Dom.createElement('updateinfo');
  Dom.appendChild(UpdateInfoNode);

  for i := 0 to Count - 1 do
  begin
    Node := Dom.createElement('update');
    UpdateInfoNode.appendChild(Node);

    SetAttributeValue(Node, 'url', Items[i].URL);
    SetAttributeValue(Node, 'localfile', Items[i].LocalFile);
    SetAttributeValue(Node, 'size', Items[i].Size);
    SetAttributeValue(Node, 'version', Items[i].Version);
    SetAttributeValue(Node, 'updatedate', Items[i].UpdateDate);

    tempNode := Dom.createElement('script');
    Node.appendChild(tempNode);
    StringsToXML(Items[i].UpdateScript, tempNode);

    Node.setAttribute('status', cUpdateStatusNames[Items[i].Status]);
    Node.setAttribute('terminate', cBooleanNames[Items[i].NeedTerminate]);

    if (Items[i].ResourceState.Count > 0) then
    begin
      tempNode := Dom.createElement('resourcestate');
      Node.appendChild(tempNode);
      SaveResourceState(tempNode, Items[i].ResourceState);
    end;
  end;

  SaveXMLToFile(AFileName, Dom, ['script']);
end;

procedure TclUpdateInfoList.SetItem(Index: Integer; const Value: TclUpdateInfoItem);
begin
  inherited SetItem(Index, Value);
end;

{ TclUpdateInfoItem }

procedure TclUpdateInfoItem.Assign(Source: TPersistent);
var
  src: TclUpdateInfoItem;
begin
  if (Source is TclUpdateInfoItem) then
  begin
    src := TclUpdateInfoItem(Source);
    FURL := src.URL;
    FVersion := src.Version;
    FSize := src.Size;
    FLocalFile := src.LocalFile;
    FUpdateDate := src.UpdateDate;
    FStatus := src.Status;
    FUpdateScript.Assign(src.UpdateScript);
    FNeedTerminate := src.NeedTerminate;
    FResourceState.Assign(src.ResourceState);
    FDescription := src.Description;
    FContentType := src.ContentType;
  end else
  begin
    inherited Assign(Source);
  end;
end;

constructor TclUpdateInfoItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FUpdateScript := TStringList.Create();
  FResourceState := TclResourceStateList.Create();
end;

destructor TclUpdateInfoItem.Destroy;
begin
  FResourceState.Free();
  FUpdateScript.Free();
  inherited Destroy();
end;

procedure TclUpdateInfoItem.UpdateStatus(ANewStatus: TclUpdateStatus);
begin
  FStatus := ANewStatus;
  FUpdateDate := DateTimeToStr(Date());
end;

end.
