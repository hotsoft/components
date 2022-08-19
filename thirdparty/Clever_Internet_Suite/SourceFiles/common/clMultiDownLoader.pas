{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clMultiDownLoader;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SyncObjs,
{$ELSE}
  System.Classes, System.SyncObjs,
{$ENDIF}
  clWinInet, clDC, clResourceState, clDCUtils, clMultiDC, clUriUtils;

type
  TclMultiDownLoader = class;
  TclDownLoadItem = class;
  TclUrlList = class;

  TclGrabOption = (gaGrabAll, gaGrabImages, gaGrabData, gaGrabAudioVideo,
    gaMakeBrowsable, gaGrabFrames, gaReplaceExisting);
  TclGrabOptions = set of TclGrabOption;

  TclFileExistsAction = (faReplace, faRename, faSkip, faStop);

  TclOnMultiDataTextProceed = procedure (Sender: TObject; Item: TclDownLoadItem; Text: TStrings) of object;
  TclOnCanProcessUrl = procedure (Sender: TObject; Item: TclDownLoadItem;
    var CanProcess, Handled: Boolean) of object;
  TclOnExtractUrls = procedure (Sender: TObject; Item: TclDownLoadItem; AHtml: TStrings; AUrlList: TclUrlList;
    var Handled: Boolean) of object;
  TclOnFileExists = procedure (Sender: TObject; const AFileName: string; var ANewName: string;
    var Action: TclFileExistsAction) of object;

  TclDownLoadItem = class(TclInternetItem)
  private
    FPreview: TStrings;
    FIsDownloadMode: Boolean;
    FIsDownloadProceed: Boolean;
    FDataAccessor: TCriticalSection;
    FAllowCompression: Boolean;
    FCompressedFile: string;
    FNestLevel: Integer;
    
    function GetDownLoader: TclMultiDownLoader;
    function CanSetFilePos(): Boolean;
    procedure StartDownload(AURLParser: TclUrlParser);
    function GetNormThreadCount(): Integer;
    function GetResourceInfoSize(): Int64;
    function CanDownload: Boolean;
    function ExtractFileName(const AContentDisposition: string): string;
    function NeedUncompress: Boolean;
  protected
    procedure DoDataTextProceed(Text: TStrings); virtual;
    function GetCorrectResourceTime: Boolean; virtual;
    function GetPreviewCharCount: Integer; virtual;
    function GetLocalFolder: string; virtual;
    function CanProcess: Boolean; override;
    procedure SetURL(const Value: string); override;
    function GetControl: TclCustomInternetControl; override;
    procedure InternalStart(AIsGetResourceInfo: Boolean); override;
    procedure AssignThreaderParams(AThreader: TclCustomThreader); override;
    function CreateThreader(ADataStream: TStream; AIsGetResourceInfo: Boolean): TclCustomThreader; override;
    function GetDataStream: TStream; override;
    procedure ProcessCompleted(AThreader: TclCustomThreader); override;
    procedure LastStatusChanged(Status: TclProcessStatus); override;
    procedure DataTextProceed; virtual;
    procedure CommitWork; override;
    procedure DoGetResourceInfo(AResourceInfo: TclResourceInfo); override;
    procedure DoCreate; override;
    procedure DoDestroy; override;
  public
    procedure Assign(Source: TPersistent); override;
    property Preview: TStrings read FPreview;
    property NestLevel: Integer read FNestLevel;
  published
    property AllowCompression: Boolean read FAllowCompression write FAllowCompression default True;
  end;

  TclDownLoadList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TclDownLoadItem;
    procedure SetItem(Index: Integer; const Value: TclDownLoadItem);
    function GetDownLoader: TclMultiDownLoader;
  public
    function Add: TclDownLoadItem;
    property Items[Index: Integer]: TclDownLoadItem read GetItem write SetItem; default;
    property DownLoader: TclMultiDownLoader read GetDownLoader;
  end;

  TclUrlItem = class(TCollectionItem)
  private
    FInnerTextPos: Integer;
    FURL: string;
  public
    procedure Assign(Source: TPersistent); override;
    property URL: string read FURL write FURL;
    property InnerTextPos: Integer read FInnerTextPos write FInnerTextPos;
  end;

  TclUrlList = class(TCollection)
  private
    function GetItem(Index: Integer): TclUrlItem;
    procedure SetItem(Index: Integer; const Value: TclUrlItem);
  public
    function Add(const AUrl: string; AInnerTextPos: Integer): TclUrlItem;
    property Items[Index: Integer]: TclUrlItem read GetItem write SetItem; default;
  end;

  TclMultiDownLoader = class(TclMultiInternetControl)
  private
    FDownLoadList: TclDownLoadList;
    FCorrectResourceTime: Boolean;
    FPreviewCharCount: Integer;
    FLocalFolder: string;
    FIsGrabbing: Boolean;
    FRootUrl: string;
    FMaxNestLevel: Integer;
    FGrabOptions: TclGrabOptions;
    FAllowedUrls: TStrings;
    FOnDataTextProceed: TclOnMultiDataTextProceed;
    FOnCanProcessGrabbedUrl: TclOnCanProcessUrl;
    FOnExtractUrls: TclOnExtractUrls;
    FOnProcessNextUrl: TclOnCanProcessUrl;
    FOnFileExists: TclOnFileExists;
    procedure SetLocalFolder(const Value: string);
    procedure SetPreviewCharCount(const Value: Integer);
    procedure SetDownLoadList(const Value: TclDownLoadList);
    procedure AssignSaveToFiles;
    function CanProcessGrabbedUrl(Item: TclDownLoadItem): Boolean;
    procedure ExtractUrls(Item: TclDownLoadItem; AHtml: TStrings; AUrlList: TclUrlList);
    function ProcessNextUrl(const AUrl: string; APrevItem: TclDownLoadItem): string;
    function GetFullFileNameByUrl(const AUrl, ALocalFolder: string): string;
    procedure ReplaceHtmlUrl(AHtml: TStrings; const AUrlItem: TclUrlItem; const AHtmlFile, AUrlFile: string);
  protected
    procedure DoProcessNextUrl(Item: TclDownLoadItem; var CanProcess, Handled: Boolean); dynamic;
    procedure DoExtractUrls(Item: TclDownLoadItem; AHtml: TStrings; AUrlList: TclUrlList; var Handled: Boolean); dynamic;
    procedure DoCanProcessGrabbedUrl(Item: TclDownLoadItem; var CanGrab, Handled: Boolean); dynamic;
    procedure DoDataTextProceed(Item: TclDownLoadItem; Text: TStrings); dynamic;
    procedure DoFileExists(const AFileName: string; var ANewName: string; var Action: TclFileExistsAction);
    function CanProcess(Item: TclInternetItem): Boolean; override;
    procedure InternalStop(Item: TclInternetItem); override;
    procedure IsBusyChanged; override;
    procedure StartNextItem(APrevItem: TclInternetItem); override;
    function GetInternetItems(Index: Integer): TclInternetItem; override;
    function GetInternetItemsCount: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GrabWebsite(const ARootUrl: string; AMaxNestLevel: Integer = 3);
    property IsGrabbing: Boolean read FIsGrabbing;
  published
    property DownLoadList: TclDownLoadList read FDownLoadList write SetDownLoadList;
    property LocalFolder: string read FLocalFolder write SetLocalFolder;
    property PreviewCharCount: Integer read FPreviewCharCount write SetPreviewCharCount default DefaultPreviewCharCount;
    property CorrectResourceTime: Boolean read FCorrectResourceTime write FCorrectResourceTime default True;
    property GrabOptions: TclGrabOptions read FGrabOptions write FGrabOptions default [gaGrabImages];

    property OnDataTextProceed: TclOnMultiDataTextProceed read FOnDataTextProceed write FOnDataTextProceed;
    property OnCanProcessGrabbedUrl: TclOnCanProcessUrl read FOnCanProcessGrabbedUrl write FOnCanProcessGrabbedUrl;
    property OnExtractUrls: TclOnExtractUrls read FOnExtractUrls write FOnExtractUrls;
    property OnProcessNextUrl: TclOnCanProcessUrl read FOnProcessNextUrl write FOnProcessNextUrl;
    property OnFileExists: TclOnFileExists read FOnFileExists write FOnFileExists;
  end;

implementation

uses
{$IFNDEF DELPHIXE2}
  Windows, SysUtils{$IFDEF DEMO}, Forms, clCertificate{$ENDIF},
{$ELSE}
  Winapi.Windows, System.SysUtils{$IFDEF DEMO}, Vcl.Forms, clCertificate{$ENDIF},
{$ENDIF}
  clZLibBase, clZLibStreams, clHttpRequest, clUtils, clHeaderFieldList, clHtmlParser, clStreams, clHttpHeader;

type TclControlAccess = class(TclCustomInternetControl);

{ TclDownLoadItem }

{$IFDEF DELPHI6}
  {$WARNINGS OFF}
{$ENDIF}

function TclDownLoadItem.CanSetFilePos(): Boolean;
var
  hFile: THandle;
  p: DWORD;
  size, pp: Int64;
begin
  Result := (ResourceState.Count > 0);
  if not Result then Exit;
  hFile := CreateFile(PChar(LocalFile), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING,
    FILE_ATTRIBUTE_NORMAL, 0);
  Result := (hFile <> INVALID_HANDLE_VALUE);
  if not Result then Exit;
  if (GetResourceInfoSize() > 0) then
  begin
    p := 0;
    size := GetFileSize(hFile, @p);
    pp := p;
    size := size or (pp shl 32);
    Result := (size = GetResourceInfoSize());
  end;
  CloseHandle(hFile);
end;

procedure TclDownLoadItem.CommitWork;
var
  src, dst: TStream;
  compressor: TclGZipInflateStream;
begin
  inherited CommitWork();
  try
    if CanDownload() then
    begin
      if NeedUncompress() and FileExists(FCompressedFile) then
      begin
        src := nil;
        dst := nil;
        compressor := nil;
        try
          src := TFileStream.Create(FCompressedFile, fmOpenRead);
          dst := TFileStream.Create(LocalFile, fmCreate);
          compressor := TclGZipInflateStream.Create(dst);
          try
            compressor.CopyFrom(src, 0);
          except
            on EclZLibError do;
          end;
        finally
          compressor.Free();
          dst.Free();
          src.Free();
        end;
        DeleteFile(PChar(FCompressedFile));
      end;
      if GetCorrectResourceTime() and (ResourceInfo <> nil) and FileExists(LocalFile) then
      begin
        SetLocalFileTime(LocalFile, ResourceInfo.Date);
      end;
    end;
  except
    on E: Exception do
      DoError(E.Message, 0);
  end;
end;

{$IFDEF DELPHI6}
  {$WARNINGS ON}
{$ENDIF}

function TclDownLoadItem.NeedUncompress: Boolean;
begin
  Result := not TclControlAccess(Control).DoNotGetResourceInfo
    and AllowCompression and (ResourceInfo <> nil) and ResourceInfo.Compressed;
end;

function TclDownLoadItem.GetDataStream(): TStream;
var
  FileMode: Word;
begin
  if (DataStream = nil) and (LocalFile <> '') then
  begin
    if CanSetFilePos() then
    begin
      FileMode := fmOpenReadWrite;
    end else
    begin
      ClearResourceState();
      FileMode := fmCreate;
    end;
    ForceFileDirectories(LocalFile);
    FCompressedFile := LocalFile;
    if NeedUncompress() then
    begin
      FCompressedFile := FCompressedFile + '~';
    end;
    if (not IsNetworkPath(FCompressedFile)) and (ResourceInfo <> nil) and (ResourceInfo.AllowsRandomAccess) and (ResourceInfo.Size > 0) then
    begin
      SetInternalDataStream(TclFileMappingStream.Create(FCompressedFile, FileMode, ResourceInfo.Size));
    end else
    begin
      SetInternalDataStream(TFileStream.Create(FCompressedFile, FileMode));
    end;
  end;
  if (DataStream = nil) then
  begin
    SetInternalDataStream(TMemoryStream.Create());
  end;
  Result := DataStream;
end;

function TclDownLoadItem.CreateThreader(ADataStream: TStream; AIsGetResourceInfo: Boolean): TclCustomThreader;
var
  s: string;
begin
  s := URL;
  if UseHttpRequest and (HttpRequest <> nil) then
  begin
    s := s + '?' + Trim(HttpRequest.RequestSource.Text);
  end;

  Result := TclDownLoadThreader.Create(s, ADataStream, AIsGetResourceInfo);
end;

function TclDownLoadItem.GetControl: TclCustomInternetControl;
begin
  Result := (Collection as TclDownLoadList).DownLoader;
end;

function TclDownLoadItem.GetDownLoader: TclMultiDownLoader;
begin
  Result := (Control as TclMultiDownLoader);
end;

function TclDownLoadItem.GetLocalFolder(): string;
begin
  Result := GetDownloader().LocalFolder;
end;

function TclDownLoadItem.GetPreviewCharCount(): Integer;
begin
  Result := GetDownloader().PreviewCharCount;
end;

function TclDownLoadItem.GetCorrectResourceTime(): Boolean;
begin
  Result := GetDownLoader().CorrectResourceTime;
end;

procedure TclDownLoadItem.DoCreate;
begin
  FDataAccessor := TCriticalSection.Create();
  inherited DoCreate();

  FPreview := TStringList.Create();
  ThreadCount := DefaultThreadCount;
  FAllowCompression := True;
  FNestLevel := 0;
end;

procedure TclDownLoadItem.DoDataTextProceed(Text: TStrings);
begin
  GetDownLoader().DoDataTextProceed(Self, Text);
end;

procedure TclDownLoadItem.SetURL(const Value: string);
var
  Corrector: TclUrlCorrector;
  Name: string; 
begin
  if (URL = Value) then Exit;
  inherited SetURL(Value);
  if (csLoading in Control.ComponentState) or (GetLocalFolder() = '') then Exit;
  Corrector := TclUrlCorrector.Create();
  try
    Name := Corrector.GetLocalFileByURL(URL, GetLocalFolder());
    if (Corrector.Extra = '') then
    begin
      LocalFile := Name;
    end else
    begin
      LocalFile := '';
    end;
  finally
    Corrector.Free();
  end;
end;

function TclDownLoadItem.CanDownload(): Boolean;
begin
  Result := not (ResourceState.LastStatus in [psFailed, psTerminated]) and CanProcess();
end;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

procedure TclDownLoadItem.ProcessCompleted(AThreader: TclCustomThreader);
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
    if (not IsDemoDisplayed) and (not IsCertDemoDisplayed)
      and (not IsHttpRequestDemoDisplayed) and (not IsHtmlDemoDisplayed) then
    begin
      IsDemoDisplayed := True;
      IsCertDemoDisplayed := True;
      IsHttpRequestDemoDisplayed := True;
      IsHtmlDemoDisplayed := True;
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsHttpRequestDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  if FIsDownloadMode and CanDownload() then
  begin
    FIsDownloadMode := False;
    FIsDownloadProceed := True;
    try
      StartDownload(AThreader.URLParser);
    except
      on E: Exception do
      begin
        DoError(E.Message, 0);
        ResourceState.UpdateStatus(FindStateItem(AThreader), psFailed);
        LastStatusChanged(ResourceState.LastStatus);
        inherited ProcessCompleted(AThreader);
      end;
    end;
  end else
  begin
    if FIsDownloadProceed then
    begin
      FIsDownloadProceed := False;
      DataTextProceed();
    end;
    inherited ProcessCompleted(AThreader);
  end;
end;

procedure TclDownLoadItem.DataTextProceed();
begin
  FPreview.Clear();
  if (GetDataStream() <> nil) then
  begin
    FPreview.Text := GetStreamAsString(GetDataStream(), GetPreviewCharCount(), GetDefaultChar());
  end;
  DoDataTextProceed(FPreview);
end;

function TclDownLoadItem.GetNormThreadCount(): Integer;
begin
  if (GetResourceInfoSize() > 0)
    and ResourceInfo.AllowsRandomAccess
    and (not IsSharedConnection()) then
  begin
    Result := (GetResourceInfoSize() div GetBatchSize());
    if (ThreadCount < Result) then
    begin
      Result := ThreadCount;
    end;
    if (Result < 1) then
    begin
      Result := 1;
    end;
  end else
  begin
    Result := 1;
  end;
end;

procedure TclDownLoadItem.StartDownload(AURLParser: TclUrlParser);
var
  i: Integer;
  Threader: TclCustomThreader;
  Stream: TStream;
  Status: TclProcessStatus;
begin
  Stream := GetDataStream();
  if (Stream <> nil) then
  begin
    Stream.Size := GetResourceInfoSize();
  end;
  Status := ResourceState.LastStatus;
  ResourceState.Init(GetNormThreadCount(), GetResourceInfoSize());
  ResourceState.UpdateStatus(nil, Status);
  for i := 0 to ResourceState.Count - 1 do
  begin
    Threader := AddThreader(ResourceState[i], False);
    Threader.ResourceInfo := ResourceInfo;
    Threader.URLParser := AURLParser;
    Threader.Perform();
  end;
end;

procedure TclDownLoadItem.InternalStart(AIsGetResourceInfo: Boolean);
begin
  FIsDownloadMode := not AIsGetResourceInfo;
  FIsDownloadProceed := False;
  inherited InternalStart(True);
end;

function TclDownLoadItem.CanProcess: Boolean;
begin
  Result := inherited CanProcess();
  if Result and (GetResourceInfoSize() > 0) then
  begin
    Result := CheckSizeValid(GetResourceInfoSize());
  end;
end;

function TclDownLoadItem.GetResourceInfoSize(): Int64;
begin
  if (ResourceInfo <> nil) then
  begin
    Result := ResourceInfo.Size;
  end else
  begin
    Result := 0;
  end;
end;

procedure TclDownLoadItem.LastStatusChanged(Status: TclProcessStatus);
begin
  if FIsDownloadMode and not (Status in [psUnknown, psProcess, {psFailed, }psTerminated]) then
  begin
    Status := psProcess;
  end;
  inherited LastStatusChanged(Status);
end;

function TclDownLoadItem.ExtractFileName(const AContentDisposition: string): string;
var
  fieldList: TclHeaderFieldList;
begin
  fieldList := TclHeaderFieldList.Create();
  try
    Result := fieldList.GetFieldValueItem(AContentDisposition, 'filename');
  finally
    fieldList.Free();
  end;
end;

procedure TclDownLoadItem.DoGetResourceInfo(AResourceInfo: TclResourceInfo);
var
  Name: string;
begin
  inherited DoGetResourceInfo(AResourceInfo);
  if (AResourceInfo = nil) or TclControlAccess(Control).DoNotGetResourceInfo then Exit;
  if (AResourceInfo.Size = 0) or (not AResourceInfo.AllowsRandomAccess) then
  begin
    ResourceState.Clear();
  end;
  Name := ExtractFileName(AResourceInfo.ContentDisposition);
  if (LocalFile = '') and (Name <> '') and (GetLocalFolder() <> '') then
  begin
    LocalFile := AddTrailingBackSlash(GetLocalFolder()) + Name;
  end;
end;

procedure TclDownLoadItem.DoDestroy;
begin
  FPreview.Free();
  inherited DoDestroy();
  FDataAccessor.Free();
end;

procedure TclDownLoadItem.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if (Source is TclDownLoadItem) then
  begin
    AllowCompression := (Source as TclDownLoadItem).AllowCompression;
  end;
end;

procedure TclDownLoadItem.AssignThreaderParams(AThreader: TclCustomThreader);
begin
  inherited AssignThreaderParams(AThreader);
  AThreader.DataAccessor := FDataAccessor;
  AThreader.AllowCompression := AllowCompression;
end;

{ TclDownLoadList }

function TclDownLoadList.Add: TclDownLoadItem;
begin
  Result := TclDownLoadItem(inherited Add());
  Result.LocalFile := GetFullFileName(Result.LocalFile, DownLoader.LocalFolder);
end;

function TclDownLoadList.GetDownLoader: TclMultiDownLoader;
begin
  Result := (GetOwner() as TclMultiDownLoader);
end;

function TclDownLoadList.GetItem(Index: Integer): TclDownLoadItem;
begin
  Result := TclDownLoadItem(inherited GetItem(Index));
end;

procedure TclDownLoadList.SetItem(Index: Integer; const Value: TclDownLoadItem);
begin
  inherited SetItem(Index, Value);
end;

{ TclMultiDownLoader }

procedure TclMultiDownLoader.AssignSaveToFiles;
var
  i: Integer;
  Item: TclDownLoadItem;
begin
  for i := 0 to DownLoadList.Count - 1 do
  begin
    Item := DownLoadList[i];
    Item.LocalFile := GetFullFileName(Item.LocalFile, FLocalFolder);
  end;
end;

constructor TclMultiDownLoader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDownLoadList := TclDownLoadList.Create(Self, TclDownLoadItem);
  FAllowedUrls := TStringList.Create();
  FPreviewCharCount := DefaultPreviewCharCount;
  FCorrectResourceTime := True;
  FIsGrabbing := False;
  GrabOptions := [gaGrabImages];
end;

destructor TclMultiDownLoader.Destroy;
begin
  FAllowedUrls.Free();
  FDownLoadList.Free();
  inherited Destroy();
end;

procedure TclMultiDownLoader.DoDataTextProceed(Item: TclDownLoadItem; Text: TStrings);
begin
  if Assigned(FOnDataTextProceed) then
  begin
    FOnDataTextProceed(Self, Item, Text);
  end;
end;

procedure TclMultiDownLoader.DoCanProcessGrabbedUrl(Item: TclDownLoadItem;
  var CanGrab, Handled: Boolean);
begin
  if Assigned(OnCanProcessGrabbedUrl) then
  begin
    OnCanProcessGrabbedUrl(Self, Item, CanGrab, Handled);
  end;
end;

procedure TclMultiDownLoader.DoExtractUrls(Item: TclDownLoadItem;
  AHtml: TStrings; AUrlList: TclUrlList; var Handled: Boolean);
begin
  if Assigned(OnExtractUrls) then
  begin
    OnExtractUrls(Self, Item, AHtml, AUrlList, Handled);
  end;
end;

procedure TclMultiDownLoader.DoProcessNextUrl(Item: TclDownLoadItem;
  var CanProcess, Handled: Boolean);
begin
  if Assigned(OnProcessNextUrl) then
  begin
    OnProcessNextUrl(Self, Item, CanProcess, Handled);
  end;
end;

function TclMultiDownLoader.CanProcessGrabbedUrl(Item: TclDownLoadItem): Boolean;
var
  handled: Boolean;
begin
  Result := (Item.ResourceState.LastStatus in [psSuccess, psErrors]);
  if not Result then Exit;

  handled := False;
  Result := False;
  DoCanProcessGrabbedUrl(Item, Result, handled);
  if not handled then
  begin
    Result := (Item.ResourceInfo <> nil)
      and (Item.ResourceInfo.StatusCode < HTTP_STATUS_BAD_REQUEST)
      and (system.Pos('html', LowerCase(Item.ResourceInfo.ContentType)) > 0);
  end;
end;

procedure TclMultiDownLoader.ExtractUrls(Item: TclDownLoadItem; AHtml: TStrings; AUrlList: TclUrlList);
var
  i: Integer;
  handled: Boolean;
  parser: TclHtmlParser;
  urlParser: TclUrlParser;
  attr: TclHtmlAttribute;
begin
  handled := False;
  DoExtractUrls(Item, AHtml, AUrlList, handled);
  if not handled then
  begin
    urlParser := nil;
    parser := nil;
    try
      urlParser := TclUrlParser.Create();
      parser := TclHtmlParser.Create(nil);
      parser.ParseMethod := pmTagsOnly;

      parser.Parse(AHtml);

      AUrlList.Clear();
      for i := 0 to parser.Frames.Count - 1 do
      begin
        attr := parser.Frames[i].AttributeByName('src');
        if (attr <> nil) and (attr.Value <> '') then
        begin
          AUrlList.Add(attr.Value, attr.InnerTextPos);
          if (gaGrabFrames in GrabOptions) then
          begin
            urlParser.Parse(AUrlList[AUrlList.Count - 1].URL);
            if (urlParser.Host <> '') then
            begin
              FAllowedUrls.Add(LowerCase(urlParser.Host));
            end;
          end;
        end;
      end;
      for i := 0 to parser.Links.Count - 1 do
      begin
        attr := parser.Links[i].AttributeByName('href');
        if (attr <> nil) and (attr.Value <> '') then
        begin
          AUrlList.Add(attr.Value, attr.InnerTextPos);
        end;
      end;
      for i := 0 to parser.Images.Count - 1 do
      begin
        attr := parser.Images[i].AttributeByName('src');
        if (attr <> nil) and (attr.Value <> '') then
        begin
          AUrlList.Add(attr.Value, attr.InnerTextPos);
        end;
      end;
    finally
      parser.Free();
      urlParser.Free();
    end;
  end;
end;

function TclMultiDownLoader.GetFullFileNameByUrl(const AUrl, ALocalFolder: string): string;
var
  s: string;
  URLParser: TclUrlParser;
begin
  URLParser := TclUrlParser.Create();
  try
    URLParser.Parse(AUrl);
    Result := AddTrailingBackSlash(ALocalFolder);
    s := StringReplace(URLParser.Urlpath, '/', '\', [rfReplaceAll]);
    if (s <> '') and (s[1] = '\') then
    begin
      system.Delete(s, 1, 1);
    end;
    if (s = '') or (s[Length(s)] = '\') then
    begin
      s := s + 'index.htm';
    end;
    Result := Result + s;
    if not (gaReplaceExisting in GrabOptions) then
    begin
      Result := GetUniqueFileName(Result);
    end;
  finally
    URLParser.Free();
  end;
end;

function TclMultiDownLoader.ProcessNextUrl(const AUrl: string;
  APrevItem: TclDownLoadItem): string;
var
  i: Integer;
  item: TclDownLoadItem;
  canProcess, handled: Boolean;
  prevUrl, fullUrl: string;
  BaseURLParser: TclUrlParser;
begin
  if (APrevItem <> nil) then
  begin
    prevUrl := APrevItem.URL;
    canProcess := (FMaxNestLevel = 0) or (APrevItem.NestLevel < FMaxNestLevel - 1);
  end else
  begin
    canProcess := True;
    prevUrl := AUrl;
  end;

  fullUrl := TclUrlParser.CombineUrl(AUrl, prevUrl);

  if canProcess then
  begin
    BaseURLParser := TclUrlParser.Create();
    try
      BaseURLParser.Parse(FRootUrl);
      canProcess := (system.Pos(LowerCase(BaseURLParser.Host), LowerCase(fullUrl)) > 0);

      if not canProcess then
      begin
        BaseURLParser.Parse(fullUrl);
        canProcess := FAllowedUrls.IndexOf(LowerCase(BaseURLParser.Host)) > -1;
      end;
    finally
      BaseURLParser.Free();
    end;
  end;
  if canProcess then
  begin
    canProcess := (system.Pos('#', AUrl) < 1);
  end;
  if canProcess then
  begin
    for i := 0 to DownLoadList.Count - 1 do
    begin
      canProcess := (DownLoadList[i].URL <> fullUrl);
      if (not canProcess) then Break;
    end;
  end;

  item := DownLoadList.Add();
  if (APrevItem <> nil) then
  begin
    item.FNestLevel := APrevItem.NestLevel + 1;
  end;
  item.URL := fullUrl;
  item.LocalFile := GetFullFileNameByUrl(fullUrl, LocalFolder);

  handled := False;
  DoProcessNextUrl(item, canProcess, handled);

  Result := item.LocalFile;
  
  if canProcess then
  begin
    item.Start(True);
  end else
  begin
    item.Free();
    if not FileExists(Result) then
    begin
      Result := '';
    end;
  end;
end;

function TclMultiDownLoader.GetInternetItems(Index: Integer): TclInternetItem;
begin
  Result := FDownLoadList[Index];
end;

function TclMultiDownLoader.GetInternetItemsCount: Integer;
begin
  Result := FDownLoadList.Count;
end;

procedure TclMultiDownLoader.GrabWebsite(const ARootUrl: string;
  AMaxNestLevel: Integer);
begin
  if IsGrabbing or IsBusy then
  begin
    raise EclInternetError.Create(cOperationIsInProgress, -1);
  end;
  FAllowedUrls.Clear();
  FIsGrabbing := True;
  DownLoadList.Clear();
  FMaxNestLevel := AMaxNestLevel;
  if (FMaxNestLevel < 0) then
  begin
    FMaxNestLevel := 0;
  end;
  FRootUrl := ARootUrl;
  ProcessNextUrl(FRootUrl, nil);
end;

procedure TclMultiDownLoader.IsBusyChanged;
begin
  if not IsBusy then
  begin
    FIsGrabbing := False;
  end;
  inherited IsBusyChanged();
end;

procedure TclMultiDownLoader.SetDownLoadList(const Value: TclDownLoadList);
begin
  FDownLoadList.Assign(Value);
  if (csLoading in ComponentState) then Exit;
  AssignSaveToFiles();
end;

procedure TclMultiDownLoader.SetLocalFolder(const Value: string);
begin
  if (FLocalFolder = Value) then Exit;
  FLocalFolder := Value;
  if (csLoading in ComponentState) then Exit;
  AssignSaveToFiles();
end;

procedure TclMultiDownLoader.SetPreviewCharCount(const Value: Integer);
begin
  if (FPreviewCharCount <> Value) and (Value > - 1) then
  begin
    FPreviewCharCount := Value;
  end;
end;

procedure TclMultiDownLoader.InternalStop(Item: TclInternetItem);
begin
  FIsGrabbing := False;
  inherited InternalStop(Item);
end;

procedure TclMultiDownLoader.StartNextItem(APrevItem: TclInternetItem);
var
  i: Integer;
  html: TStrings;
  list: TclUrlList;
  urlFile: string;
begin
  inherited StartNextItem(APrevItem);
  if IsGrabbing and CanProcessGrabbedUrl(APrevItem as TclDownLoadItem) then
  begin
    list := nil;
    html := nil;
    try
      list := TclUrlList.Create(TclUrlItem);
      html := TStringList.Create();

      html.LoadFromFile(APrevItem.LocalFile);

      ExtractUrls(APrevItem as TclDownLoadItem, html, list);
      for i := 0 to list.Count - 1 do
      begin
        urlFile := ProcessNextUrl(list[i].URL, APrevItem as TclDownLoadItem);
        if (gaMakeBrowsable in GrabOptions) then
        begin
          ReplaceHtmlUrl(html, list[i], APrevItem.LocalFile, urlFile);
        end;
      end;
      
      if (gaMakeBrowsable in GrabOptions) then
      begin
//TODO        html.SaveToFile(ChangeFileExt(APrevItem.LocalFile, '.htm'));
//        DeleteFile(PChar(APrevItem.LocalFile));
        html.SaveToFile(APrevItem.LocalFile);
      end;
    finally
      html.Free();
      list.Free();
    end;
  end;
end;

procedure TclMultiDownLoader.ReplaceHtmlUrl(AHtml: TStrings; const AUrlItem: TclUrlItem;
  const AHtmlFile, AUrlFile: string);
var
  newUrl, src, dst: string;
begin
  if (AUrlFile = '') or (AHtmlFile = '') or (AUrlItem.URL = '') or (AUrlItem.InnerTextPos = 0) then Exit;

  newUrl := MakeRelativePath(AHtmlFile, AUrlFile);
  if (newUrl <> '') then
  begin
    src := AHtml.Text;
    dst := system.Copy(src, 1, AUrlItem.InnerTextPos - 1);
    dst := dst + newUrl + system.Copy(src, AUrlItem.InnerTextPos + Length(AUrlItem.URL), Length(src));
    AHtml.Text := dst;
  end;
end;

procedure TclMultiDownLoader.DoFileExists(const AFileName: string;
  var ANewName: string; var Action: TclFileExistsAction);
begin
  if Assigned(OnFileExists) then
  begin
    OnFileExists(Self, AFileName, ANewName, Action);
  end;
end;

type TclInternetItemAccess = class(TclInternetItem);

function TclMultiDownLoader.CanProcess(Item: TclInternetItem): Boolean;
var
  s, newName: string;
  action: TclFileExistsAction;
begin
  Result := inherited CanProcess(Item);

  if Result and IsGrabbing and (Item.ResourceInfo <> nil) then
  begin
    s := LowerCase(Item.ResourceInfo.ContentType);
    Result := (Item.ResourceInfo.StatusCode < HTTP_STATUS_BAD_REQUEST) and (
        (gaGrabAll in GrabOptions)
        or (system.Pos('html', s) > 0)
        or ((system.Pos('image', s) > 0) and (gaGrabImages in GrabOptions))
        or ((system.Pos('audio', s) > 0) and (gaGrabAudioVideo in GrabOptions))
        or ((system.Pos('video', s) > 0) and (gaGrabAudioVideo in GrabOptions))
        or ((system.Pos('application', s) > 0) and (gaGrabData in GrabOptions))
    );
  end;

  if not TclInternetItemAccess(Item).IsCommit and Result and (Item.LocalFile <> '') and FileExists(Item.LocalFile) then
  begin
    newName := '';
    action := faReplace;
    DoFileExists(Item.LocalFile, newName, action);

    case action of
      faRename: TclInternetItemAccess(Item).FLocalFile := newName;
      faSkip: Result := False;
      faStop:
        begin
          Result := False;
          Stop();
        end;
    end;
  end;
end;

{ TclUrlList }

function TclUrlList.Add(const AUrl: string; AInnerTextPos: Integer): TclUrlItem;
begin
  Result := TclUrlItem(inherited Add());
  Result.URL := AUrl;
  Result.InnerTextPos := AInnerTextPos;
end;

function TclUrlList.GetItem(Index: Integer): TclUrlItem;
begin
  Result := TclUrlItem(inherited GetItem(Index));
end;

procedure TclUrlList.SetItem(Index: Integer; const Value: TclUrlItem);
begin
  inherited SetItem(Index, Value);
end;

{ TclUrlItem }

procedure TclUrlItem.Assign(Source: TPersistent);
begin
  if (Source is TclUrlItem) then
  begin
    FInnerTextPos := TclUrlItem(Source).InnerTextPos;
    FURL := TclUrlItem(Source).URL;
  end else
  begin
    inherited Assign(Source);
  end;
end;

end.
