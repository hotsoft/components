{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clMultiUploader;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clWinInet, clDC, clMultiDC, clDCUtils, clUtils, clHttpRequest;

type
  TclMultiUploader = class;
  TclUploadItem = class;

  TclOnPrepareItemToPublish = procedure (Sender: TObject; Item: TclUploadItem;
    var CanProceed, Handled: Boolean) of object; 

  TclUploadItem = class(TclInternetItem)
  private
    FHttpResponse: TStrings;
    FUseSimpleRequest: Boolean;
    FHttpResponseStream: TStream;
    FSelfHttpResponseStream: TStream;
    FRequestMethod: string;
    function GetHttpResponseStream: TStream;
    procedure ClearHttpResponseStream();
    procedure SetHttpResponseStream(const Value: TStream);
  protected
    function GetForceRemoteDir: Boolean; virtual;
    procedure InternalStart(AIsGetResourceInfo: Boolean); override;
    function CanProcess: Boolean; override;
    procedure AssignThreaderParams(AThreader: TclCustomThreader); override;
    function CreateThreader(ADataStream: TStream; AIsGetResourceInfo: Boolean): TclCustomThreader; override;
    function GetDataStream: TStream; override;
    procedure SetLocalFile(const Value: string); override;
    function GetControl: TclCustomInternetControl; override;
    procedure ProcessCompleted(AThreader: TclCustomThreader); override;
    procedure CommitWork; override;
    procedure DoCreate; override;
    procedure DoDestroy; override;
    procedure SetUseHttpRequest(const Value: Boolean); override;
  public
    procedure Assign(Source: TPersistent); override;
    property HttpResponse: TStrings read FHttpResponse;
    property HttpResponseStream: TStream read FHttpResponseStream write SetHttpResponseStream;
  published
    property ThreadCount default 1;
    property UseSimpleRequest: Boolean read FUseSimpleRequest write FUseSimpleRequest default False;
    property RequestMethod: string read FRequestMethod write FRequestMethod;
  end;

  TclUploadList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TclUploadItem;
    procedure SetItem(Index: Integer; const Value: TclUploadItem);
    function GetUploader: TclMultiUploader;
  public
    function Add: TclUploadItem;
    property Items[Index: Integer]: TclUploadItem read GetItem write SetItem; default;
    property Uploader: TclMultiUploader read GetUploader;
  end;

  TclMultiUploader = class(TclMultiInternetControl)
  private
    FUploadList: TclUploadList;
    FForceRemoteDir: Boolean;
    FPublishFileAttr: Integer;
    FPublishFileMask: string;
    FIsPublishing: Boolean;
    FOnPrepareItemToPublish: TclOnPrepareItemToPublish;
    procedure SetUploadList(const Value: TclUploadList);
    procedure PrepareUploadListToPublish(const ASourceLocalFolder, ADestinationRemoteFolder: string);
    procedure PrepareItemToPublish(const ASourceLocalFile, ADestinationUrl: string);
  protected
    procedure DoPrepareItemToPublish(Item: TclUploadItem; var CanProceed, Handled: Boolean); dynamic;
    function GetInternetItems(Index: Integer): TclInternetItem; override;
    function GetInternetItemsCount: Integer; override;
    procedure IsBusyChanged; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Publish(const ASourceLocalFolder, ADestinationRemoteFolder: string; IsAsynch: Boolean = True);
    property IsPublishing: Boolean read FIsPublishing;
  published
    property UploadList: TclUploadList read FUploadList write SetUploadList;
    property ForceRemoteDir: Boolean read FForceRemoteDir write FForceRemoteDir default False;
    property PublishFileMask: string read FPublishFileMask write FPublishFileMask;
    property PublishFileAttr: Integer read FPublishFileAttr write FPublishFileAttr default faAnyFile;

    property OnPrepareItemToPublish: TclOnPrepareItemToPublish read FOnPrepareItemToPublish
      write FOnPrepareItemToPublish;
  end;

implementation

uses
{$IFNDEF DELPHIXE2}
  {$IFDEF DEMO}Forms, Windows, clCertificate,{$ENDIF}
{$ELSE}
  {$IFDEF DEMO}Vcl.Forms, Winapi.Windows, clCertificate,{$ENDIF}
{$ENDIF}
  clUriUtils;

{ TclUploadList }

function TclUploadList.Add: TclUploadItem;
begin
  Result := TclUploadItem(inherited Add());
end;

function TclUploadList.GetItem(Index: Integer): TclUploadItem;
begin
  Result := TclUploadItem(inherited GetItem(Index));
end;

function TclUploadList.GetUploader: TclMultiUploader;
begin
  Result := (GetOwner() as TclMultiUploader);
end;

procedure TclUploadList.SetItem(Index: Integer; const Value: TclUploadItem);
begin
  inherited SetItem(Index, Value);
end;

{ TclUploadItem }

procedure TclUploadItem.AssignThreaderParams(AThreader: TclCustomThreader);
var
  UploadThreader: TclUploadThreader;
begin
  inherited AssignThreaderParams(AThreader);
  if (AThreader is TclUploadThreader) then
  begin
    UploadThreader := (AThreader as TclUploadThreader);
    UploadThreader.UseSimpleRequest := UseSimpleRequest;
    UploadThreader.HttpResponse := GetHttpResponseStream();
    UploadThreader.ForceRemoteDir := GetForceRemoteDir();
    UploadThreader.RequestMethod := RequestMethod;
  end;
end;

function TclUploadItem.GetForceRemoteDir: Boolean;
begin
  Result := (Control as TclMultiUploader).ForceRemoteDir;
end;

function TclUploadItem.GetDataStream(): TStream;
begin
  if (DataStream = nil) then
  begin
    if UseHttpRequest and (HttpRequest <> nil) then
    begin
      SetInternalDataStream(HttpRequest.RequestStream);
    end else
    begin
      if FileExists(LocalFile) then
      begin
        SetInternalDataStream(TFileStream.Create(LocalFile, fmOpenRead or fmShareDenyWrite));
      end;
    end;
  end;
  Result := DataStream;
end;

function TclUploadItem.CreateThreader(ADataStream: TStream; AIsGetResourceInfo: Boolean): TclCustomThreader;
begin
  Result := TclUploadThreader.Create(URL, ADataStream, AIsGetResourceInfo);
end;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

procedure TclUploadItem.ProcessCompleted(AThreader: TclCustomThreader);
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
    if (not IsDemoDisplayed) and (not IsCertDemoDisplayed) and (not IsHttpRequestDemoDisplayed) then
    begin
      IsDemoDisplayed := True;
      IsCertDemoDisplayed := True;
      IsHttpRequestDemoDisplayed := True;
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsHttpRequestDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  inherited ProcessCompleted(AThreader);
end;

procedure TclUploadItem.CommitWork;
begin
  if (FHttpResponseStream = nil) then
  begin
    FHttpResponse.Text := GetStreamAsString(GetHttpResponseStream(), 0, GetDefaultChar());
  end;
  inherited CommitWork();
  ClearHttpResponseStream();
end;

function TclUploadItem.GetHttpResponseStream(): TStream;
begin
  Result := FHttpResponseStream;
  if (Result = nil) then
  begin
    if (FSelfHttpResponseStream = nil) then
    begin
      FSelfHttpResponseStream := TMemoryStream.Create();
    end;
    Result := FSelfHttpResponseStream;
  end;
end;

procedure TclUploadItem.ClearHttpResponseStream();
begin
  FSelfHttpResponseStream.Free();
  FSelfHttpResponseStream := nil;
end;

function TclUploadItem.GetControl: TclCustomInternetControl;
begin
  Result := (Collection as TclUploadList).Uploader;
end;

function TclUploadItem.CanProcess(): Boolean;
var
  Stream: TStream;
begin
  Result := True;
  Stream := GetDataStream();
  if (Stream <> nil) then
  begin
    Result := CheckSizeValid(Stream.Size);
  end;
end;

procedure TclUploadItem.SetLocalFile(const Value: string);
var
  Corrector: TclUrlCorrector;
begin
  if (LocalFile = Value) then Exit;
  inherited SetLocalFile(Value);
  if (csLoading in Control.ComponentState) or UseHttpRequest then Exit;
  Corrector := TclUrlCorrector.Create();
  try
    URL := Corrector.GetURLByLocalFile(URL, LocalFile);
  finally
    Corrector.Free();
  end;
end;

procedure TclUploadItem.InternalStart(AIsGetResourceInfo: Boolean);
  function GetStreamSize(): Int64;
  var
    Stream: TStream;
  begin
    Stream := GetDataStream();
    if (Stream <> nil) then
    begin
      Result := Stream.Size;
    end else
    begin
      Result := 0;
    end;
  end;

var
  size: Int64;
begin
  FHttpResponse.Clear();
  if (not AIsGetResourceInfo) and (ResourceState.Count = 0) then
  begin
    size := GetStreamSize();
    ResourceState.Init(1, size);
  end;
  inherited InternalStart(AIsGetResourceInfo);
end;

procedure TclUploadItem.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if (Source is TclUploadItem) then
  begin
    FUseSimpleRequest := (Source as TclUploadItem).UseSimpleRequest;
  end;
end;

procedure TclUploadItem.SetHttpResponseStream(const Value: TStream);
begin
  if (FHttpResponseStream <> Value) then
  begin
    ClearHttpResponseStream();
    FHttpResponseStream := Value;
  end;
end;

procedure TclUploadItem.DoCreate;
begin
  inherited DoCreate();
  FHttpResponse := TStringList.Create();
  RequestMethod := 'PUT';
end;

procedure TclUploadItem.DoDestroy;
begin
  ClearHttpResponseStream();
  FHttpResponse.Free();
  inherited DoDestroy();
end;

procedure TclUploadItem.SetUseHttpRequest(const Value: Boolean);
const
  methods: array[Boolean] of string = ('PUT', 'POST');
begin
  inherited SetUseHttpRequest(Value);
  if (csLoading in Control.ComponentState) then Exit;
  RequestMethod := methods[UseHttpRequest];
end;

{ TclMultiUploader }

constructor TclMultiUploader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUploadList := TclUploadList.Create(Self, TclUploadItem);
  FIsPublishing := False;
  FPublishFileMask := '*.*';
  FPublishFileAttr := faAnyFile;
end;

destructor TclMultiUploader.Destroy;
begin
  FUploadList.Free();
  inherited Destroy();
end;

function TclMultiUploader.GetInternetItems(Index: Integer): TclInternetItem;
begin
  Result := FUploadList[Index];
end;

function TclMultiUploader.GetInternetItemsCount: Integer;
begin
  Result := FUploadList.Count;
end;

procedure TclMultiUploader.IsBusyChanged;
begin
  if not IsBusy then
  begin
    FIsPublishing := False;
  end;
  inherited IsBusyChanged();
end;

procedure TclMultiUploader.DoPrepareItemToPublish(Item: TclUploadItem;
  var CanProceed, Handled: Boolean);
begin
  if Assigned(OnPrepareItemToPublish) then
  begin
    OnPrepareItemToPublish(Self, Item, CanProceed, Handled);
  end;
end;

procedure TclMultiUploader.PrepareItemToPublish(const ASourceLocalFile,
  ADestinationUrl: string);
var
  item: TclUploadItem;
  canProceed, handled: Boolean;
begin
  item := UploadList.Add();
  item.LocalFile := ASourceLocalFile;
  item.URL := ADestinationUrl;
  canProceed := True;
  handled := False;
  DoPrepareItemToPublish(item, canProceed, handled);
  if not canProceed then
  begin
    item.Free();
  end;
end;

procedure TclMultiUploader.PrepareUploadListToPublish(const ASourceLocalFolder,
  ADestinationRemoteFolder: string);
  
  function AddSeparatorIfNeed(const APath: string; ASeparator: Char): string;
  begin
    Result := APath;
    if (Result <> '') and (Result[Length(Result)] <> ASeparator) then
    begin
      Result := Result + ASeparator;
    end;
  end;

var
  sr: TSearchRec;
  root, remoteRoot: string;
begin
  root := AddSeparatorIfNeed(ASourceLocalFolder, '\');
  remoteRoot := AddSeparatorIfNeed(ADestinationRemoteFolder, '/');

  if FindFirst(root + PublishFileMask, PublishFileAttr - faDirectory, sr) = 0 then
  begin
    repeat
      PrepareItemToPublish(root + sr.Name, remoteRoot + sr.Name);
    until FindNext(sr) <> 0;
    {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindClose(sr);
  end;

  if (PublishFileAttr and faDirectory) > 0 then
  begin
    if FindFirst(root + '*.*', faDirectory, sr) = 0 then
    begin
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') and ((sr.Attr and faDirectory) > 0) then
        begin
          PrepareUploadListToPublish(root + sr.Name, remoteRoot + sr.Name);
        end;
      until FindNext(sr) <> 0;
      {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindClose(sr);
    end;
  end;
end;

procedure TclMultiUploader.Publish(const ASourceLocalFolder,
  ADestinationRemoteFolder: string; IsAsynch: Boolean);
begin
  if IsPublishing or IsBusy then
  begin
    raise EclInternetError.Create(cOperationIsInProgress, -1);
  end;
  ForceRemoteDir := True;
  FIsPublishing := True;
  UploadList.Clear();
  PrepareUploadListToPublish(ASourceLocalFolder, ADestinationRemoteFolder);
  if UploadList.Count > 0 then
  begin
    Start(nil, IsAsynch);
  end else
  begin
    FIsPublishing := False;
  end;
end;

procedure TclMultiUploader.SetUploadList(const Value: TclUploadList);
begin
  FUploadList.Assign(Value);
end;

end.
