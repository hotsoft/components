{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clNntpFileHandler;

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
  Classes, Windows, SysUtils, SyncObjs,
{$ELSE}
  System.Classes, Winapi.Windows, System.SysUtils, System.SyncObjs,
{$ENDIF}
  clNntpServer;

type
  TclNntpFileHandler = class(TComponent)
  private
    FServer: TclNntpServer;
    FRootDir: string;
    FAccessor: TCriticalSection;
    FCounter: Integer;
    
    procedure SetServer(const Value: TclNntpServer);
    procedure SetRootDir(const Value: string);
    procedure SetCounter(const Value: Integer);

    function GetGroupPath(const AGroupName: string): string;
    function CreateArticleItem(const AFileName: string): TclNntpArticleItem;
    procedure CollectArticles(Articles: TclNntpArticleList; const APath: string; ADate: TDateTime; AGMT: Boolean);
    function GenerateArticleName(ArticleNo: Integer; const AMessageID: string): string;

    procedure DoGetGroupInfo(Sender: TObject; AConnection: TclNntpCommandConnection;
      AGroup: TclNewsGroupItem; var ArticleCount, ALastArticle, AFirstArticle: Integer);
    procedure DoGetArticles(Sender: TObject; AConnection: TclNntpCommandConnection;
      AGroup: TclNewsGroupItem; ADate: TDateTime; AGMT: Boolean; const ADistributions: string; Articles: TclNntpArticleList);
    procedure DoGetArticleSource(Sender: TObject; AConnection: TclNntpCommandConnection;
      AGroup: TclNewsGroupItem; var ArticleNo: Integer; var AMessageID: string; ArticleSource: TStrings; var Success: Boolean);
    procedure DoArticleReceived(Sender: TObject; AConnection: TclNntpCommandConnection;
      AGroup: TclNewsGroupItem; const AMessageID: string; ArticleSource: TStrings; var Success: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CleanEventHandlers; virtual;
    procedure InitEventHandlers; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Server: TclNntpServer read FServer write SetServer;
    property RootDir: string read FRootDir write SetRootDir;
    property Counter: Integer read FCounter write SetCounter default 0;
  end;

var
  cMaxTryCount: Integer = 1000;
  
implementation

uses
  clUtils, clEncoder;

{ TclNntpFileHandler }

procedure TclNntpFileHandler.CleanEventHandlers;
begin
  Server.OnGetGroupInfo := nil;
  Server.OnGetArticles := nil;
  Server.OnGetArticleSource := nil;
  Server.OnArticleReceived := nil;
end;

procedure TclNntpFileHandler.CollectArticles(Articles: TclNntpArticleList; const APath: string; ADate: TDateTime; AGMT: Boolean);
var
  searchRec: TSearchRec;
  fileDate: TDateTime;
  item: TclNntpArticleItem;
begin
  if {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindFirst(AddTrailingBackSlash(APath) + '*.MSG', 0, searchRec) = 0 then
  begin
    repeat
      fileDate := ConvertFileTimeToDateTime(searchRec.FindData.ftLastWriteTime);
      if AGMT then
      begin
        fileDate := LocalTimeToGlobalTime(fileDate);
      end;
      
      if (fileDate >= ADate) then
      begin
        item := CreateArticleItem(searchRec.Name);
        if (item <> nil) then
        begin
          articles.Add(item);
        end;
      end;
    until ({$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindNext(searchRec) <> 0);
    {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindClose(searchRec);
  end;
end;

constructor TclNntpFileHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAccessor := TCriticalSection.Create();
end;

function TclNntpFileHandler.CreateArticleItem(const AFileName: string): TclNntpArticleItem;
var
  articleNo: Integer;
  messageID: string;
begin
  Result := nil;

  if (WordCount(AFileName, ['_', '.']) <> 3) then Exit;

  articleNo := StrToIntDef(ExtractWord(1, AFileName, ['_', '.']), 0);
  messageID := TclEncoder.Decode(ExtractWord(2, AFileName, ['_', '.']), cmBase64);

  if ((articleNo < 1) or (messageID = '')) then Exit;

  Result := TclNntpArticleItem.Create(articleNo, messageID);
end;

destructor TclNntpFileHandler.Destroy;
begin
  FAccessor.Free();
  inherited Destroy();
end;

procedure TclNntpFileHandler.DoArticleReceived(Sender: TObject; AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem;
  const AMessageID: string; ArticleSource: TStrings; var Success: Boolean);
var
  i: Integer;
  path, msgFileName: string;
begin
  Success := False;
  path := AddTrailingBackSlash(GetGroupPath(AGroup.Name));

  FAccessor.Enter();
  try
    i := 0;
    while (True) do
    begin
      Inc(FCounter);
      msgFileName := path + GenerateArticleName(FCounter, AMessageID);

      try
        if (not FileExists(msgFileName)) then
        begin
          TclStringsUtils.SaveStrings(ArticleSource, msgFileName, '');
          Success := True;
          Break;
        end;
      except
        on EStreamError do;
      end;

      Inc(i);
      if (i > cMaxTryCount) then
      begin
        raise Exception.Create('Cannot save new message');
      end;
    end;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclNntpFileHandler.DoGetArticles(Sender: TObject; AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem;
  ADate: TDateTime; AGMT: Boolean; const ADistributions: string; Articles: TclNntpArticleList);
var
  path: string;
begin
  path := GetGroupPath(AGroup.Name);
  CollectArticles(Articles, path, ADate, AGMT);
end;

procedure TclNntpFileHandler.DoGetArticleSource(Sender: TObject; AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem;
  var ArticleNo: Integer; var AMessageID: string; ArticleSource: TStrings; var Success: Boolean);
var
  path, fileName: string;
  articles: TclNntpArticleList;
  article: TclNntpArticleItem;
begin
  path := GetGroupPath(AGroup.Name);

  articles := nil;
  try
    articles := TclNntpArticleList.Create();
    CollectArticles(articles, path, 0, False);

    article := nil;
    if (ArticleNo > 0) then
    begin
      article := articles.FindArticle(ArticleNo);
    end else
    if (AMessageID <> '') then
    begin
      article := articles.FindArticle(AMessageID);
    end;

    if (article = nil) then
    begin
      Success := False;
      Exit;
    end;

    ArticleNo := article.ArticleNo;
    AMessageID := article.MessageID;
    fileName := AddTrailingBackSlash(path) + GenerateArticleName(ArticleNo, AMessageID);

    TclStringsUtils.LoadStrings(fileName, ArticleSource, '');
    Success := True;
  finally
    articles.Free();
  end;
end;

procedure TclNntpFileHandler.DoGetGroupInfo(Sender: TObject; AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem;
  var ArticleCount, ALastArticle, AFirstArticle: Integer);
var
  path: string;
  articles: TclNntpArticleList;
begin
  path := GetGroupPath(AGroup.Name);

  articles := TclNntpArticleList.Create();
  try
    CollectArticles(articles, path, 0, False);

    ArticleCount := articles.Count;
    AFirstArticle := 0;
    ALastArticle := 0;

    if (articles.Count > 0) then
    begin
      AFirstArticle := articles[0].ArticleNo;
      ALastArticle := articles[articles.Count - 1].ArticleNo;
    end;
  finally
    articles.Free();
  end;
end;

function TclNntpFileHandler.GenerateArticleName(ArticleNo: Integer; const AMessageID: string): string;
begin
  Result := Format('%.7d', [ArticleNo]) + '_' + TclEncoder.EncodeToString(AMessageID, cmBase64) + '.MSG';
end;

function TclNntpFileHandler.GetGroupPath(const AGroupName: string): string;
begin
  Result := AddTrailingBackSlash(RootDir);
  Result := Result + StringReplace(AGroupName, '.', '_', [rfReplaceAll]);
  Result := AddTrailingBackSlash(Result);

  FAccessor.Enter();
  try
    if (not DirectoryExists(Result)) then
    begin
      ForceFileDirectories(Result);
    end;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclNntpFileHandler.InitEventHandlers;
begin
  Server.OnGetGroupInfo := DoGetGroupInfo;
  Server.OnGetArticles := DoGetArticles;
  Server.OnGetArticleSource := DoGetArticleSource;
  Server.OnArticleReceived := DoArticleReceived;
end;

procedure TclNntpFileHandler.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) then Exit;
  if (AComponent = FServer) then
  begin
    CleanEventHandlers();
    FServer := nil;
  end;
end;

procedure TclNntpFileHandler.SetCounter(const Value: Integer);
begin
  FAccessor.Enter();
  try
    FCounter := Value;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclNntpFileHandler.SetRootDir(const Value: string);
begin
  FAccessor.Enter();
  try
    FRootDir := Value;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclNntpFileHandler.SetServer(const Value: TclNntpServer);
begin
  if (FServer <> Value) then
  begin
    if (FServer <> nil) then
    begin
      FServer.RemoveFreeNotification(Self);
      CleanEventHandlers();
    end;
    FServer := Value;
    if (FServer <> nil) then
    begin
      FServer.FreeNotification(Self);
      InitEventHandlers();
    end;
  end;
end;

end.
