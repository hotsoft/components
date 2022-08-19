{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clNntpServer;

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
  Classes, SysUtils, Contnrs, WinSock, Windows,
{$ELSE}
  System.Classes, System.SysUtils, System.Contnrs, Winapi.WinSock, Winapi.Windows,
{$ENDIF}
  clTcpServer, clTcpServerTls, clSocket, clUserMgr, clNntpUtils, clTcpCommandServer;

type
  TclNntpAccessPermission = (apRead, apPost, apIHave);
  TclNntpAccessPermissions = set of TclNntpAccessPermission;

  EclNntpServerError = class(EclTcpCommandServerError)
  end;

  TclNewsGroupItem = class(TCollectionItem)
  private
    FName: string;
    FPermissions: TclNntpAccessPermissions;
    FUsers: TStrings;
    FCreatedOn: TDateTime;
    FOwner: string;
    
    procedure SetUsers(const Value: TStrings);
    function GetTimes: Integer;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
  published
    property Name: string read FName write FName;
    property Permissions: TclNntpAccessPermissions read FPermissions write FPermissions default [];
    property Users: TStrings read FUsers write SetUsers;
    property CreatedOn: TDateTime read FCreatedOn write FCreatedOn;
    property Owner: string read FOwner write FOwner;
    property Times: Integer read GetTimes;
  end;

  TclNewsGroupList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TclNewsGroupItem;
    procedure SetItem(Index: Integer; const Value: TclNewsGroupItem);
    function Matches(AItem: TclNewsGroupItem; ANames: TStrings): Boolean;
  public
    function Add: TclNewsGroupItem;
    function FindGroup(const AName: string): TclNewsGroupItem;
    function SelectGroupsByNameSet(const ANewsGroups: string): TclNewsGroupList;
    function SelectGroupsByWildMat(const AWildMat: string): TclNewsGroupList;

    property Items[Index: Integer]: TclNewsGroupItem read GetItem write SetItem; default;
  end;

  TclNntpArticleItem = class
  private
    FArticleNo: Integer;
    FMessageID: string;
  public
    constructor Create(ArtNo: Integer; const AMessageID: string);

    property ArticleNo: Integer read FArticleNo write FArticleNo;
    property MessageID: string read FMessageID write FMessageID;
  end;

  TclNntpArticleList = class
  private
    FList: TObjectList;
    
    function GetCount: Integer;
    function GetItem(Index: Integer): TclNntpArticleItem;
    procedure DoCreate(AOwnsObjects: Boolean);
    function GetOwnsObjects: Boolean;
  public
    constructor Create(AOwnsObjects: Boolean); overload;
    constructor Create; overload;
    destructor Destroy; override;

    procedure Add(AItem: TclNntpArticleItem);
    procedure Delete(Index: Integer);
    procedure Clear;

    function SelectArticles(const ARange: string): TclNntpArticleList;
    function FindArticle(ArticleNo: Integer): TclNntpArticleItem; overload;
    function FindArticle(const AMessageID: string): TclNntpArticleItem; overload;

    property Items[Index: Integer]: TclNntpArticleItem read GetItem; default;
    property Count: Integer read GetCount;
    property OwnsObjects: Boolean read GetOwnsObjects;
  end;

  TclNntpCommandConnection = class(TclCommandConnection)
  private
    FIsAuthorized: Boolean;
    FUserName: string;
    FModeType: TclNntpModeType;
    FCurrentGroup: string;
    FCurrentArticle: Integer;
    FMessageID: string;
    FIsSlave: Boolean;
  public
    constructor Create;
    procedure InitParams;

    property IsAuthorized: Boolean read FIsAuthorized;
    property UserName: string read FUserName;
    property ModeType: TclNntpModeType read FModeType;
    property CurrentGroup: string read FCurrentGroup;
    property CurrentArticle: Integer read FCurrentArticle;
    property MessageID: string read FMessageID;
    property IsSlave: Boolean read FIsSlave;
  end;

  TclNntpCommandHandler = procedure (AConnection: TclNntpCommandConnection;
    const ACommand: string; AParameters: TclTcpCommandParams) of object;

  TclNntpCommandInfo = class(TclTcpCommandInfo)
  private
    FHandler: TclNntpCommandHandler;
  protected
    procedure Execute(AConnection: TclCommandConnection; AParams: TclTcpCommandParams); override; 
  public
    constructor Create(const AName: string; AHandler: TclNntpCommandHandler);
  end;

  TclNntpAuthenticateEvent = procedure (Sender: TObject; AConnection: TclNntpCommandConnection;
    var Account: TclUserAccountItem; const AUserName, APassword: string; var IsAuthorized, Handled: Boolean) of object;

  TclNntpListCommandEvent = procedure (Sender: TObject; AConnection: TclNntpCommandConnection;
    AParameters: TclTcpCommandParams; var Handled: Boolean) of object;

  TclNntpGetGroupInfoEvent = procedure (Sender: TObject; AConnection: TclNntpCommandConnection;
    AGroup: TclNewsGroupItem; var ArticleCount, ALastArticle, AFirstArticle: Integer) of object;

  TclNntpCanAccessGroupEvent = procedure (Sender: TObject; AConnection: TclNntpCommandConnection;
    AGroup: TclNewsGroupItem; ARequired: TclNntpAccessPermission; var Allow: Boolean) of object;

  TclNntpGetArticlesEvent = procedure (Sender: TObject; AConnection: TclNntpCommandConnection;
    AGroup: TclNewsGroupItem; ADate: TDateTime; AGMT: Boolean; const ADistributions: string; Articles: TclNntpArticleList) of object;

  TclNntpGetArticleSourceEvent = procedure (Sender: TObject; AConnection: TclNntpCommandConnection;
    AGroup: TclNewsGroupItem; var ArticleNo: Integer; var AMessageID: string; ArticleSource: TStrings; var Success: Boolean) of object;

  TclNntpArticleReceivedEvent = procedure (Sender: TObject; AConnection: TclNntpCommandConnection;
    AGroup: TclNewsGroupItem; const AMessageID: string; ArticleSource: TStrings; var Success: Boolean) of object;

  TclNntpCanAcceptArticleEvent = procedure (Sender: TObject; AConnection: TclNntpCommandConnection;
    const AMessageID: string; var Allow: Boolean) of object;

  TclNntpServer = class(TclTcpCommandServer)
  private
    FUserAccounts: TclUserAccountList;
    FGroups: TclNewsGroupList;
    FHelpText: TStrings;
    FHostName: string;
    FTooOldDays: Integer;
    FOverviewFormat: TStrings;
    FSubscriptions: TStrings;
    FCapabilities: TStrings;

    FOnAuthenticate: TclNntpAuthenticateEvent;
    FOnListCommand: TclNntpListCommandEvent;
    FOnGetGroupInfo: TclNntpGetGroupInfoEvent;
    FOnCanAccessGroup: TclNntpCanAccessGroupEvent;
    FOnGetArticles: TclNntpGetArticlesEvent;
    FOnGetArticleSource: TclNntpGetArticleSourceEvent;
    FOnArticleReceived: TclNntpArticleReceivedEvent;
    FOnCanAcceptArticle: TclNntpCanAcceptArticleEvent;

    procedure HandleNullCommand(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleAUTHINFO(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleMODE(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleQUIT(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleLIST(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleNEWGROUPS(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleGROUP(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleNEWNEWS(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleLISTGROUP(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleSTAT(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleLAST(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleNEXT(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleARTICLE(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleBODY(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleHEAD(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandlePOST(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleIHAVE(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleSLAVE(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleHELP(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleDATE(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleCAPABILITIES(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleSTARTTLS(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleXHDR(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleXOVER(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);

    procedure HandlePostArticle(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleIHaveArticle(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleGroupList(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleOverviewFormat(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);
    procedure HandleSubscriptions(AConnection: TclNntpCommandConnection; const ACommand: string; AParameters: TclTcpCommandParams);

    function CollectArticleHeaders(AConnection: TclNntpCommandConnection; const ACommand: string;
      AGroup: TclNewsGroupItem; const AMessageID: string; AFieldNames: TStrings; const ADelimiter: string): string;
    procedure GetCapabilities(AConnection: TclNntpCommandConnection; AList: TStrings);
    function HasArticleBody(Article: TStrings): Boolean;
    function GetMessageID(Article: TStrings): string;
    function ValidateIHaveArticle(AConnection: TclNntpCommandConnection; const ACommand: string; Article: TStrings): TclNewsGroupList;
    function ValidatePostArticle(AConnection: TclNntpCommandConnection; const ACommand: string; Article: TStrings): TclNewsGroupList;
    function GetSelectedGroup(AConnection: TclNntpCommandConnection; const ACommand: string): TclNewsGroupItem;
    procedure InternalGetArticle(AConnection: TclNntpCommandConnection; const ACommand, AParameter: string;
      var ArticleNo: Integer; var AMessageID: string; ArticleSource: TStrings);
    function HasGroupPermissions(AGroup: TclNewsGroupItem; ARequired: TclNntpAccessPermission): Boolean;
    function HasUserGroupAccess(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem): Boolean;
    function IsGroupAvailable(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem; ARequired: TclNntpAccessPermission): Boolean;
    function IsGroupMatches(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem;
      ADate: TDateTime; AGMT: Boolean; const ADistributions: string): Boolean;
    function Authenticate(AConnection: TclNntpCommandConnection; Account: TclUserAccountItem;
      const AUserName, APassword: string): Boolean;
    procedure CheckGroupAvailable(AConnection: TclNntpCommandConnection; const ACommand: string;
      AGroup: TclNewsGroupItem; ARequired: TclNntpAccessPermission);
    procedure CheckAuthorized(AConnection: TclNntpCommandConnection; const ACommand: string; IsAuthorized: boolean);
    procedure CheckTlsMode(AConnection: TclNntpCommandConnection; const ACommand: string);
    procedure RaiseNntpError(const ACommand, AMessage: string; ACode: Integer);
    function GetAllowedPermission(ARequired: TclNntpAccessPermission): Boolean;
    function GetHostName: string;

    procedure FillDefaultHelpText;
    procedure FillDefaultOverviewFormat;
    procedure FillDefaultCapabilities;

    procedure SetHelpText(const Value: TStrings);
    procedure SetOverviewFormat(const Value: TStrings);
    procedure SetSubscriptions(const Value: TStrings);
    procedure SetCapabilities(const Value: TStrings);
    function GetCaseInsensitive: Boolean;
    procedure SetCaseInsensitive(const Value: Boolean);
    procedure SetUserAccounts(const Value: TclUserAccountList);
    procedure SetGroups(const Value: TclNewsGroupList);
  protected
    procedure DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean); override;
    procedure ProcessUnhandledError(AConnection: TclCommandConnection; AParameters: TclTcpCommandParams; E: Exception); override;
    function CreateDefaultConnection: TclUserConnection; override;
    procedure GetCommands; override;
    function GetNullCommand(AParameters: TclTcpCommandParams): TclTcpCommandInfo; override;
    procedure DoDestroy; override;

    function GenMessageID: string; virtual;

    procedure DoAuthenticate(AConnection: TclNntpCommandConnection; var Account: TclUserAccountItem;
      const AUserName, APassword: string; var IsAuthorized, Handled: Boolean);
    procedure DoListCommand(AConnection: TclNntpCommandConnection; AParameters: TclTcpCommandParams; var Handled: Boolean);
    procedure DoGetGroupInfo(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem;
      var ArticleCount, ALastArticle, AFirstArticle: Integer);
    procedure DoCanAccessGroup(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem;
      ARequired: TclNntpAccessPermission; var Allow: Boolean);
    procedure DoGetArticles(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem;
      ADate: TDateTime; AGMT: Boolean; const ADistributions: string; Articles: TclNntpArticleList);
    procedure DoGetArticleSource(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem;
      var ArticleNo: Integer; var AMessageID: string; ArticleSource: TStrings; var Success: Boolean);
    procedure DoArticleReceived(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem; const AMessageID: string;
      ArticleSource: TStrings; var Success: Boolean);
    procedure DoCanAcceptArticle(AConnection: TclNntpCommandConnection; const AMessageID: string; var Allow: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Port default DefaultNntpPort;
    property Groups: TclNewsGroupList read FGroups write SetGroups;
    property UserAccounts: TclUserAccountList read FUserAccounts write SetUserAccounts;
    property CaseInsensitive: Boolean read GetCaseInsensitive write SetCaseInsensitive default True;
    property HelpText: TStrings read FHelpText write SetHelpText;
    property OverviewFormat: TStrings read FOverviewFormat write SetOverviewFormat;
    property Capabilities: TStrings read FCapabilities write SetCapabilities;
    property Subscriptions: TStrings read FSubscriptions write SetSubscriptions;
    property TooOldDays: Integer read FTooOldDays write FTooOldDays default 35;
    property HostName: string read FHostName write FHostName;

    property OnAuthenticate: TclNntpAuthenticateEvent read FOnAuthenticate write FOnAuthenticate;
    property OnListCommand: TclNntpListCommandEvent read FOnListCommand write FOnListCommand;
    property OnGetGroupInfo: TclNntpGetGroupInfoEvent read FOnGetGroupInfo write FOnGetGroupInfo;
    property OnCanAccessGroup: TclNntpCanAccessGroupEvent read FOnCanAccessGroup write FOnCanAccessGroup;
    property OnGetArticles: TclNntpGetArticlesEvent read FOnGetArticles write FOnGetArticles;
    property OnGetArticleSource: TclNntpGetArticleSourceEvent read FOnGetArticleSource write FOnGetArticleSource;
    property OnArticleReceived: TclNntpArticleReceivedEvent read FOnArticleReceived write FOnArticleReceived;
    property OnCanAcceptArticle: TclNntpCanAcceptArticleEvent read FOnCanAcceptArticle write FOnCanAcceptArticle;
  end;

implementation

uses
  clMailMessage, clEncoder, clUtils, clTlsSocket, clMailUtils, clMailHeader;

const
  postingStatus: array[Boolean] of Integer = (201, 200);
  postingStatusMsg: array[Boolean] of string = ('Posting not allowed', 'Posting allowed');
  postingStatusBool: array[Boolean] of string = ('n', 'y');
  
{ TclNntpServer }

procedure TclNntpServer.FillDefaultHelpText;
begin
  HelpText.Add('AUTHINFO user Name|pass Password');
  HelpText.Add('ARTICLE [MessageID|Number]');
  HelpText.Add('BODY [MessageID|Number]');
  HelpText.Add('CAPABILITIES');
  HelpText.Add('DATE');
  HelpText.Add('GROUP newsgroup');
  HelpText.Add('HEAD [MessageID|Number]');
  HelpText.Add('HELP');
  HelpText.Add('IHAVE');
  HelpText.Add('LAST');
  HelpText.Add('LIST [active|active.times|subscriptions]');
  HelpText.Add('LISTGROUP newsgroup');
  HelpText.Add('MODE STREAM');
  HelpText.Add('MODE READER');
  HelpText.Add('NEWGROUPS yymmdd hhmmss [GMT] [<distributions>]');
  HelpText.Add('NEWNEWS newsgroups yymmdd hhmmss [GMT] [<distributions>]');
  HelpText.Add('NEXT');
  HelpText.Add('POST');
  HelpText.Add('SLAVE');
  HelpText.Add('STARTTLS');
  HelpText.Add('STAT [MessageID|Number]');
  HelpText.Add('XHDR header [range|MessageID]');
  HelpText.Add('XOVER [range]');
end;

procedure TclNntpServer.FillDefaultOverviewFormat;
begin
  OverviewFormat.Add('Subject:');
  OverviewFormat.Add('From:');
  OverviewFormat.Add('Date:');
  OverviewFormat.Add('Message-ID:');
  OverviewFormat.Add('References:');
  OverviewFormat.Add('Bytes:');
  OverviewFormat.Add('Lines:');
  OverviewFormat.Add('Xref:full');
end;

procedure TclNntpServer.FillDefaultCapabilities;
begin
  Capabilities.Clear();
  Capabilities.Add('LIST ACTIVE NEWSGROUPS OVERVIEW.FMT');
end;

constructor TclNntpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FUserAccounts := TclUserAccountList.Create(Self, TclUserAccountItem);
  FGroups := TclNewsGroupList.Create(Self, TclNewsGroupItem);

  FHelpText := TStringList.Create();
  FOverviewFormat := TStringList.Create();
  FSubscriptions := TStringList.Create();
  FCapabilities := TStringList.Create();

  Port := DefaultNntpPort;
  ServerName := 'Clever Internet Suite NNTP service';
  FTooOldDays := 35;
  CaseInsensitive := True;

  FillDefaultHelpText();
  FillDefaultOverviewFormat();
  FillDefaultCapabilities();
end;

function TclNntpServer.CreateDefaultConnection: TclUserConnection;
begin
  Result := TclNntpCommandConnection.Create();
end;

procedure TclNntpServer.DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean);
var
  allowPost: Boolean;
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

  allowPost := GetAllowedPermission(apPost);
  SendResponse(AConnection as TclCommandConnection, '', '%d %s %s, %s',
    [postingStatus[allowPost], GetHostName(), ServerName, postingStatusMsg[allowPost]]);
end;

procedure TclNntpServer.DoArticleReceived(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem;
  const AMessageID: string; ArticleSource: TStrings; var Success: Boolean);
begin
  if Assigned(OnArticleReceived) then
  begin
    OnArticleReceived(Self, AConnection, AGroup, AMessageID, ArticleSource, Success);
  end;
end;

procedure TclNntpServer.DoAuthenticate(AConnection: TclNntpCommandConnection; var Account: TclUserAccountItem; const AUserName,
  APassword: string; var IsAuthorized, Handled: Boolean);
begin
  if Assigned(OnAuthenticate) then
  begin
    OnAuthenticate(Self, AConnection, Account, AUserName, APassword, IsAuthorized, Handled);
  end;
end;

procedure TclNntpServer.DoCanAcceptArticle(AConnection: TclNntpCommandConnection; const AMessageID: string; var Allow: Boolean);
begin
  if Assigned(OnCanAcceptArticle) then
  begin
    OnCanAcceptArticle(Self, AConnection, AMessageID, Allow);
  end;
end;

procedure TclNntpServer.DoCanAccessGroup(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem;
  ARequired: TclNntpAccessPermission; var Allow: Boolean);
begin
  if Assigned(OnCanAccessGroup) then
  begin
    OnCanAccessGroup(Self, AConnection, AGroup, ARequired, Allow);
  end;
end;

procedure TclNntpServer.HandleLIST(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  s: string;
  handled: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);

  handled := False;
  DoListCommand(AConnection, AParameters, handled);

  if (handled) then Exit;

  s := UpperCase(AParameters.Parameters);
  if (Trim(s) = '') or (system.Pos('ACTIVE', s) > 0) then
  begin
    HandleGroupList(AConnection, ACommand, AParameters);
  end else
  if (system.Pos('OVERVIEW.FMT', s) > 0) then
  begin
    HandleOverviewFormat(AConnection, ACommand, AParameters);
  end else
  if (system.Pos('SUBSCRIPTIONS', s) > 0) then
  begin
    HandleSubscriptions(AConnection, ACommand, AParameters);
  end else
  begin
    RaiseNntpError(ACommand, 'command syntax error', 501);
  end;
end;

procedure TclNntpServer.HandleGroupList(AConnection: TclNntpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  i: Integer;
  list: TStrings;
  wildMat: string;
  isActiveTimes, allowPost: Boolean;
  targetList: TclNewsGroupList;
  item: TclNewsGroupItem;
  articleCount, lastArticle, firstArticle: Integer;
begin
  list := TStringList.Create();
  try
    wildMat := '';
    if (WordCount(AParameters.Parameters, [' ']) > 1) then
    begin
      wildMat := ExtractWord(2, AParameters.Parameters, [' ']);
    end;

    isActiveTimes := (Pos('ACTIVE.TIMES', UpperCase(AParameters.Parameters)) > 0);

    targetList := Groups.SelectGroupsByWildMat(wildMat);
    try
      for i := 0 to targetList.Count - 1 do
      begin
        item := targetList[i];
        if (IsGroupAvailable(AConnection, item, apRead)) then
        begin
          articleCount := 0;
          lastArticle := 0;
          firstArticle := 0;

          DoGetGroupInfo(AConnection, item, articleCount, lastArticle, firstArticle);

          if (isActiveTimes) then
          begin
            list.Add(Format('%s %d %s', [item.Name, item.Times, item.Owner]));
          end else
          begin
            allowPost := (apPost in item.Permissions);

            list.Add(Format('%s %d %d %s', [item.Name, lastArticle, firstArticle, postingStatusBool[allowPost]]));
          end;
        end;
      end;
    finally
      targetList.Free();
    end;

    SendResponse(AConnection, ACommand, '215 list of newsgroups follows');
    SendMultipleLines(AConnection, list, '.');
  except
    list.Free();
    raise;
  end;
end;

procedure TclNntpServer.HandleOverviewFormat(AConnection: TclNntpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  i: Integer;
  list: TStrings;
  s: string;
begin
  if (OverviewFormat.Count = 0) then
  begin
    RaiseNntpError(ACommand, 'program error, function not performed', 503);
  end;

  list := TStringList.Create();
  try
    for i := 0 to OverviewFormat.Count - 1 do
    begin
      s := OverviewFormat[i];
      
      if (Pos(':', s) < 1) then
      begin
        list.Add(s + ':');
      end else
      begin
        list.Add(s);
      end;
    end;

    SendResponse(AConnection, ACommand, '215 information follows');
    SendMultipleLines(AConnection, list, '.');
  except
    list.Free();
    raise;
  end;
end;

procedure TclNntpServer.HandleSubscriptions(AConnection: TclNntpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  list: TStrings;
begin
  if (Subscriptions.Count = 0) then
  begin
    RaiseNntpError(ACommand, 'list not available', 503);
  end;
  
  list := TStringList.Create();
  try
    list.Assign(Subscriptions);

    SendResponse(AConnection, ACommand, '215 list of default group subscriptions follow');
    SendMultipleLines(AConnection, list, '.');
  except
    list.Free();
    raise;
  end;
end;

procedure TclNntpServer.HandleMODE(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  mode: string;
  allowPost: Boolean;
begin
  mode := UpperCase(Trim(AParameters.Parameters));
  if (mode = 'READER') then
  begin
    AConnection.FModeType := mtReader;

    allowPost := GetAllowedPermission(apPost);
    SendResponse(AConnection, ACommand, '%d %s: %s',
      [postingStatus[allowPost], ServerName, postingStatusMsg[allowPost]]);
  end else
  if (mode = 'STREAM') then
  begin
    AConnection.FModeType := mtStream;
    SendResponse(AConnection, ACommand, '203 StreamOK');
  end else
  begin
    RaiseNntpError(ACommand, 'syntax error or bad command', 500);
  end;
end;

procedure TclNntpServer.HandleQUIT(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
begin
  SendResponseAndClose(AConnection, ACommand, '205 closing connection');
end;

procedure TclNntpServer.GetCommands;
begin
  Commands.Add(TclNntpCommandInfo.Create('AUTHINFO', HandleAUTHINFO));
  Commands.Add(TclNntpCommandInfo.Create('MODE', HandleMODE));
  Commands.Add(TclNntpCommandInfo.Create('QUIT', HandleQUIT));
  Commands.Add(TclNntpCommandInfo.Create('LIST', HandleLIST));
  Commands.Add(TclNntpCommandInfo.Create('NEWGROUPS', HandleNEWGROUPS));
  Commands.Add(TclNntpCommandInfo.Create('GROUP', HandleGROUP));
  Commands.Add(TclNntpCommandInfo.Create('NEWNEWS', HandleNEWNEWS));
  Commands.Add(TclNntpCommandInfo.Create('LISTGROUP', HandleLISTGROUP));
  Commands.Add(TclNntpCommandInfo.Create('STAT', HandleSTAT));
  Commands.Add(TclNntpCommandInfo.Create('LAST', HandleLAST));
  Commands.Add(TclNntpCommandInfo.Create('NEXT', HandleNEXT));
  Commands.Add(TclNntpCommandInfo.Create('ARTICLE', HandleARTICLE));
  Commands.Add(TclNntpCommandInfo.Create('BODY', HandleBODY));
  Commands.Add(TclNntpCommandInfo.Create('HEAD', HandleHEAD));
  Commands.Add(TclNntpCommandInfo.Create('POST', HandlePOST));
  Commands.Add(TclNntpCommandInfo.Create('IHAVE', HandleIHAVE));
  Commands.Add(TclNntpCommandInfo.Create('SLAVE', HandleSLAVE));
  Commands.Add(TclNntpCommandInfo.Create('HELP', HandleHELP));
  Commands.Add(TclNntpCommandInfo.Create('DATE', HandleDATE));
  Commands.Add(TclNntpCommandInfo.Create('CAPABILITIES', HandleCAPABILITIES));
  Commands.Add(TclNntpCommandInfo.Create('STARTTLS', HandleSTARTTLS));
  Commands.Add(TclNntpCommandInfo.Create('XHDR', HandleXHDR));
  Commands.Add(TclNntpCommandInfo.Create('XOVER', HandleXOVER));
end;

function TclNntpServer.GetHostName: string;
begin
  Result := HostName;
  if (Result = '') then
  begin
    Result := TclHostResolver.GetLocalHost();
  end;
end;

procedure TclNntpServer.HandleNEWGROUPS(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  i: Integer;
  item: TclNewsGroupItem;
  dateTime: TDateTime;
  gmt: Boolean;
  distr: string;
  list: TStrings;
  articleCount, lastArticle, firstArticle: Integer;
  allowPost: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);

  ParseNntpQuery(AParameters.Parameters, dateTime, gmt, distr);

  list := TStringList.Create();
  try
    for i := 0 to Groups.Count - 1 do
    begin
      item := Groups[i];

      if (IsGroupAvailable(AConnection, item, apRead) and IsGroupMatches(AConnection, item, dateTime, gmt, distr)) then
      begin
        articleCount := 0;
        lastArticle := 0;
        firstArticle := 0;

        DoGetGroupInfo(AConnection, item, articleCount, lastArticle, firstArticle);

        allowPost := (apPost in item.Permissions);

        list.Add(Format('%s %d %d %s',
          [item.Name, lastArticle, firstArticle, postingStatusBool[allowPost]]));
      end;
    end;

    SendResponse(AConnection, ACommand, '231 list of new newsgroups follows');
    SendMultipleLines(AConnection, list, '.');
  except
    list.Free();
    raise;
  end;
end;

procedure TclNntpServer.HandleGROUP(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  groupName: string;
  group: TclNewsGroupItem;
  articleCount, lastArticle, firstArticle: Integer;
begin
  CheckTlsMode(AConnection, ACommand);

  groupName := Trim(AParameters.Parameters);

  group := Groups.FindGroup(groupName);
  if (group = nil) then
  begin
    RaiseNntpError(ACommand, 'no such news group', 411);
  end;

  CheckGroupAvailable(AConnection, ACommand, group, apRead);

  articleCount := 0;
  lastArticle := 0;
  firstArticle := 0;

  DoGetGroupInfo(AConnection, group, articleCount, lastArticle, firstArticle);

  AConnection.FCurrentGroup := group.Name;
  AConnection.FCurrentArticle := firstArticle;

  SendResponse(AConnection, ACommand, '211 %d %d %d %s selected', [articleCount, firstArticle, lastArticle, group.Name]);
end;

procedure TclNntpServer.HandleNEWNEWS(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  i, j, ind: Integer;
  newsGroups: string;
  dateTime: TDateTime;
  gmt: Boolean;
  distr: string;
  targetList: TclNewsGroupList;
  list: TStrings;
  group: TclNewsGroupItem;
  articles: TclNntpArticleList;
begin
  CheckTlsMode(AConnection, ACommand);

  newsGroups := Trim(AParameters.Parameters);

  dateTime := Now();
  gmt := False;
  distr := '';

  ind := system.Pos(#32, newsGroups);
  if (ind > 0) then
  begin
    ParseNntpQuery(system.Copy(newsGroups, ind + 1, Length(newsGroups)), dateTime, gmt, distr);
    SetLength(newsGroups, ind - 1);
  end;

  targetList := nil;
  articles := nil;
  try
    targetList := Groups.SelectGroupsByNameSet(newsGroups);
    articles := TclNntpArticleList.Create();

    list := TStringList.Create();
    try
      for i := 0 to targetList.Count -1 do
      begin
        group := targetList[i];
        if (IsGroupAvailable(AConnection, group, apRead)) then
        begin
          articles.Clear();
          
          DoGetArticles(AConnection, group, dateTime, gmt, distr, articles);

          for j := 0 to articles.Count - 1 do
          begin
            list.Add(GetNormMessageID(articles[j].MessageID));
          end;
        end;
      end;

      SendResponse(AConnection, ACommand, '230 list of new articles by message-id follows');
      SendMultipleLines(AConnection, list, '.');
    except
      list.Free();
      raise;
    end;
  finally
    articles.Free();
    targetList.Free();
  end;
end;

procedure TclNntpServer.HandleLISTGROUP(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  i: Integer;
  list: TStrings;
  newsGroup: string;
  group: TclNewsGroupItem;
  articles: TclNntpArticleList;
begin
  CheckTlsMode(AConnection, ACommand);

  newsGroup := Trim(AParameters.Parameters);
  if (newsGroup = '') then
  begin
    newsGroup := AConnection.CurrentGroup;
  end;

  group := Groups.FindGroup(newsGroup);
  if (group = nil) then
  begin
    RaiseNntpError(ACommand, 'no such news group', 412);
  end;

  CheckGroupAvailable(AConnection, ACommand, group, apRead);

  list := TStringList.Create();
  try
    articles := TclNntpArticleList.Create();
    try
      DoGetArticles(AConnection, group, 0, False, '', articles);

      for i := 0 to articles.Count - 1 do
      begin
        list.Add(IntToStr(articles[i].ArticleNo));
      end;

      AConnection.FCurrentGroup := newsGroup;
      AConnection.FCurrentArticle := 0;
      if (articles.Count > 0) then
      begin
        AConnection.FCurrentArticle := articles[0].ArticleNo;
      end;

      SendResponse(AConnection, ACommand, '211 list of article numbers follow');
      SendMultipleLines(AConnection, list, '.');
    finally
      articles.Free();
    end;
  except
    list.Free();
    raise;
  end;
end;

procedure TclNntpServer.CheckGroupAvailable(AConnection: TclNntpCommandConnection; const ACommand: string;
  AGroup: TclNewsGroupItem; ARequired: TclNntpAccessPermission);
var
  allow: Boolean;
begin
  if (not HasGroupPermissions(AGroup, ARequired)) then
  begin
    RaiseNntpError(ACommand, 'no permission', 502);
  end;

  if (not HasUserGroupAccess(AConnection, AGroup)) then
  begin
    RaiseNntpError(ACommand, 'no permission', 480);
  end;

  allow := True;
  DoCanAccessGroup(AConnection, AGroup, ARequired, allow);

  if (not allow) then
  begin
    RaiseNntpError(ACommand, 'no permission', 502);
  end;
end;

procedure TclNntpServer.CheckAuthorized(AConnection: TclNntpCommandConnection; const ACommand: string; IsAuthorized: boolean);
begin
  if (Guard <> nil) then
  begin
    IsAuthorized := Guard.Login(AConnection.UserName, IsAuthorized, AConnection.PeerIP, Port);
  end;

  if (not IsAuthorized) then
  begin
    AConnection.InitParams();
    RaiseNntpError(ACommand, 'Authentication error', 502);
  end;
end;

function TclNntpServer.HasGroupPermissions(AGroup: TclNewsGroupItem; ARequired: TclNntpAccessPermission): Boolean;
begin
  Result := (ARequired in AGroup.Permissions);
end;

function TclNntpServer.HasUserGroupAccess(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem): Boolean;
var
  i: Integer;
begin
  Result := False;
  
  if (AConnection.UserName = '') then
  begin
    Result := (AGroup.Users.Count = 0);
  end else
  if (AConnection.IsAuthorized) then
  begin
    Result := False;
    for i := 0 to AGroup.Users.Count - 1 do
    begin
      Result := SameText(AGroup.Users[i], AConnection.UserName);
      if (Result) then Break;
    end;
  end;
end;

function TclNntpServer.IsGroupAvailable(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem;
  ARequired: TclNntpAccessPermission): Boolean;
begin
  Result := HasGroupPermissions(AGroup, ARequired);

  if (Result) then
  begin
    Result := HasUserGroupAccess(AConnection, AGroup);
  end;

  DoCanAccessGroup(AConnection, AGroup, ARequired, Result);
end;

function TclNntpServer.IsGroupMatches(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem; ADate: TDateTime;
  AGMT: Boolean; const ADistributions: string): Boolean;
var
  i: Integer;
  distrs: TStrings;
begin
  if AGMT then
  begin
    Result := AGroup.CreatedOn >= GlobalTimeToLocalTime(ADate);
  end else
  begin
    Result := AGroup.CreatedOn >= ADate;
  end;

  if (Result and (ADistributions <> '')) then
  begin
    Result := False;

    distrs := TStringList.Create();
    try
      ExtractQuotedWords(ADistributions, distrs, ',');

      for i := 0 to distrs.Count - 1 do
      begin
        Result := Pos(UpperCase(distrs[i]), UpperCase(AGroup.Name)) > 0;
        if Result then Break;
      end;
    finally
      distrs.Free();
    end;
  end;
end;

procedure TclNntpServer.HandleSTAT(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  articleNo: Integer;
  messageID: string;
  article: TStrings;
begin
  CheckTlsMode(AConnection, ACommand);

  messageID := '';
  articleNo := 0;

  article := TStringList.Create();
  try
    InternalGetArticle(AConnection, ACommand, Trim(AParameters.Parameters), articleNo, messageID, article);

    SendResponse(AConnection, ACommand, '223 %d %s article retrieved - request text separately', [articleNo, messageID]);
  finally
    article.Free();
  end;
end;

procedure TclNntpServer.HandleLAST(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  articleNo: Integer;
  messageID: string;
  group: TclNewsGroupItem;
  article: TStrings;
  success: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);

  group := GetSelectedGroup(AConnection, ACommand);

  if (AConnection.CurrentArticle < 1) then
  begin
    RaiseNntpError(ACommand, 'no current article has been selected', 420);
  end;

  articleNo := AConnection.CurrentArticle - 1;
  messageID := '';
  success := True;

  article := TStringList.Create();
  try
    DoGetArticleSource(AConnection, group, articleNo, messageID, article, success);

    if (not success) then
    begin
      RaiseNntpError(ACommand, 'no previous article in this group', 422);
    end;

    Assert((articleNo > 0) and (messageID <> ''), 'Must specify both articleNo and messageID');

    AConnection.FCurrentArticle := articleNo;

    SendResponse(AConnection, ACommand, '223 %d %s article retrieved - request text separately', [articleNo, messageID]);
  finally
    article.Free();
  end;
end;

procedure TclNntpServer.HandleNEXT(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  articleNo: Integer;
  messageID: string;
  group: TclNewsGroupItem;
  article: TStrings;
  success: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);

  group := GetSelectedGroup(AConnection, ACommand);

  if (AConnection.CurrentArticle < 1) then
  begin
    RaiseNntpError(ACommand, 'no current article has been selected', 420);
  end;

  articleNo := AConnection.CurrentArticle + 1;
  messageID := '';
  success := True;

  article := TStringList.Create();
  try
    DoGetArticleSource(AConnection, group, articleNo, messageID, article, success);

    if (not success) then
    begin
      RaiseNntpError(ACommand, 'no next article in this group', 421);
    end;

    Assert((articleNo > 0) and (messageID <> ''), 'Must specify both articleNo and messageID');

    AConnection.FCurrentArticle := articleNo;

    SendResponse(AConnection, ACommand, '223 %d %s article retrieved - request text separately', [articleNo, messageID]);
  finally
    article.Free();
  end;
end;

procedure TclNntpServer.HandleARTICLE(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  messageID: string;
  articleNo: Integer;
  article: TStrings;
begin
  CheckTlsMode(AConnection, ACommand);

  messageID := '';
  articleNo := 0;

  article := TStringList.Create();
  try
    InternalGetArticle(AConnection, ACommand, Trim(AParameters.Parameters), articleNo, messageID, article);

    SendResponse(AConnection, ACommand, '220 %d %s article retrieved - head and body follows', [articleNo, messageID]);
    SendMultipleLines(AConnection, article, '.');
  except
    article.Free();
    raise;
  end;
end;

procedure TclNntpServer.InternalGetArticle(AConnection: TclNntpCommandConnection;
  const ACommand, AParameter: string; var ArticleNo: Integer; var AMessageID: string; ArticleSource: TStrings);
var
  artNo: Integer;
  msgID: string;
  group: TclNewsGroupItem;
  success: Boolean;
begin
  group := GetSelectedGroup(AConnection, ACommand);

  AMessageID := AParameter;
  ArticleNo := StrToIntDef(AMessageID, 0);
  if (ArticleNo > 0) then
  begin
    AMessageID := '';
  end;

  if ((ArticleNo < 1) and (AMessageID = '')) then
  begin
    if (AConnection.CurrentArticle < 1) then
    begin
      RaiseNntpError(ACommand, 'no current article has been selected', 420);
    end;

    ArticleNo := AConnection.CurrentArticle;
  end;

  artNo := ArticleNo;
  msgID := AMessageID;
  success := True;
  DoGetArticleSource(AConnection, group, artNo, msgID, ArticleSource, success);

  if (not success) then
  begin
    RaiseNntpError(ACommand, 'no such article number in this group', 423);
  end;

  Assert((artNo > 0) and (msgID <> ''), 'Must specify both articleNo and messageID');

  if (AMessageID = '') then
  begin
    AConnection.FCurrentArticle := ArticleNo;
  end;

  ArticleNo := artNo;
  AMessageID := GetNormMessageID(msgID);
end;

procedure TclNntpServer.HandleBODY(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  messageID: string;
  i, articleNo: Integer;
  article: TStrings;
begin
  CheckTlsMode(AConnection, ACommand);

  messageID := '';
  articleNo := 0;

  article := TStringList.Create();
  try
    InternalGetArticle(AConnection, ACommand, Trim(AParameters.Parameters), articleNo, messageID, article);

    i := 0;
    while (i < article.Count) do
    begin
      if (article[0] = '') then
      begin
        article.Delete(0);
        Break;
      end;
      article.Delete(0);
    end;

    SendResponse(AConnection, ACommand, '222 %d %s article retrieved - body follows', [articleNo, messageID]);
    SendMultipleLines(AConnection, article, '.');
  except
    article.Free();
    raise;
  end;
end;

procedure TclNntpServer.HandleHEAD(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  messageID: string;
  lines, articleNo: Integer;
  article: TStrings;
begin
  CheckTlsMode(AConnection, ACommand);

  messageID := '';
  articleNo := 0;

  article := TStringList.Create();
  try
    InternalGetArticle(AConnection, ACommand, Trim(AParameters.Parameters), articleNo, messageID, article);

    lines := 0;
    while (lines < article.Count) do
    begin
      if (article[lines] = '') then
      begin
        Break;
      end;
      Inc(lines);
    end;

    SendResponse(AConnection, ACommand, '221 %d %s article retrieved - head follows', [articleNo, messageID]);
    SendMultipleLines(AConnection, article, '.', lines);
  except
    article.Free();
    raise;
  end;
end;

procedure TclNntpServer.HandlePOST(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
begin
  CheckTlsMode(AConnection, ACommand);
  if (not GetAllowedPermission(apPost)) then
  begin
    RaiseNntpError(ACommand, 'posting not allowed', 440);
  end;

  AcceptMultipleLines(AConnection, TclNntpCommandInfo.Create(ACommand, HandlePostArticle));
  SendResponse(AConnection, ACommand, '340 send article to be posted. End with <CR-LF>.<CR-LF>');
end;

procedure TclNntpServer.HandlePostArticle(AConnection: TclNntpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  i: Integer;
  msg: TStrings;
  targetList: TclNewsGroupList;
  messageID: string;
  item: TclNewsGroupItem;
  success: Boolean;
begin
  AcceptCommands(AConnection);

  msg := AParameters.RawData;

  targetList := ValidatePostArticle(AConnection, ACommand, msg);
  try
    messageID := GetMessageID(msg);
    if (messageID = '') then
    begin
      messageID := GenMessageID();
      msg.Insert(0, 'Message-ID: ' + messageID);
    end;

    for i := 0 to targetList.Count - 1 do
    begin
      item := targetList[i];

      success := True;
      DoArticleReceived(AConnection, item, messageID, msg, success);

      if (not success) then
      begin
        RaiseNntpError(ACommand, 'posting failed', 441);
      end;
    end;

    SendResponse(AConnection, ACommand, '240 article posted ok');
  finally
    targetList.Free();
  end;
end;

function TclNntpServer.GenMessageID: string;
begin
  Result := GenerateMessageID(GetHostName());
end;

function TclNntpServer.HasArticleBody(Article: TStrings): Boolean;
var
  i: Integer;
begin
  i := 0;
  while i < Article.Count do
  begin
    if Article[i] = '' then Break;
    Inc(i);
  end;

  Result := False;
  while i < Article.Count do
  begin
    if Article[i] <> '' then
    begin
      Result := True;
      Break;
    end;
    Inc(i);
  end;
end;

function TclNntpServer.ValidateIHaveArticle(AConnection: TclNntpCommandConnection;
  const ACommand: string; Article: TStrings): TclNewsGroupList;
var
  i: Integer;
  msg: TclMailMessage;
  group: TclNewsGroupItem;
begin
  if (Article.Count = 0) then
  begin
    RaiseNntpError(ACommand, 'article rejected - do not try again (NULL Item)', 437);
  end;

  Result := TclNewsGroupList.Create(nil, TclNewsGroupItem);
  try
    msg := TclMailMessage.Create(nil);
    try
      msg.HeaderSource := Article;

      if (msg.MessageID = '') or (msg.MessageID <> AConnection.MessageID) then
      begin
        RaiseNntpError(ACommand, 'article rejected - do not try again later (No msgid in headers)', 437);
      end;
      if (msg.NewsGroups.Count = 0) then
      begin
        RaiseNntpError(ACommand, 'article rejected - do not try again later (No newsgroups match)', 437);
      end;
      if (not HasArticleBody(Article)) then
      begin
        RaiseNntpError(ACommand, 'article rejected - do not try again later (Item body is empty)', 437);
      end;
      if (Round(Now()) - Round(msg.Date) >= TooOldDays) then
      begin
        RaiseNntpError(ACommand, 'article rejected - do not try again later (Message is too old)', 437);
      end;

      for i := 0 to msg.NewsGroups.Count - 1 do
      begin
        group := Groups.FindGroup(msg.NewsGroups[i]);
        if (group = nil) then
        begin
          RaiseNntpError(ACommand, 'article rejected - do not try again later (No newsgroups match)', 437);
        end;

        CheckGroupAvailable(AConnection, ACommand, group, apIHave);
        Result.Add().Assign(group);
      end;
    finally
      msg.Free();
    end;
  except
    Result.Free();
    raise;
  end;
end;

function TclNntpServer.ValidatePostArticle(AConnection: TclNntpCommandConnection;
  const ACommand: string; Article: TStrings): TclNewsGroupList;
var
  i: Integer;
  msg: TclMailMessage;
  group: TclNewsGroupItem;
begin
  if (Article.Count = 0) then
  begin
    RaiseNntpError(ACommand, 'Article is empty?', 441);
  end;

  Result := TclNewsGroupList.Create(nil, TclNewsGroupItem);
  try
    msg := TclMailMessage.Create(nil);
    try
      msg.HeaderSource := Article;

      if (msg.From.FullAddress = '') then
      begin
        RaiseNntpError(ACommand, 'Required header missing {From:}', 441);
      end;
      if (msg.NewsGroups.Count = 0) then
      begin
        RaiseNntpError(ACommand, 'Required header missing {Newsgroups:}', 441);
      end;
      if (msg.Subject = '') then
      begin
        RaiseNntpError(ACommand, 'Required header missing {Subject:}', 441);
      end;
      if (not HasArticleBody(Article)) then
      begin
        RaiseNntpError(ACommand, 'no body found', 441);
      end;

      for i := 0 to msg.NewsGroups.Count - 1 do
      begin
        group := Groups.FindGroup(msg.NewsGroups[i]);
        if (group = nil) then
        begin
          RaiseNntpError(ACommand, 'no such news group', 441);
        end;

        CheckGroupAvailable(AConnection, ACommand, group, apPost);
        Result.Add().Assign(group);
      end;
    finally
      msg.Free();
    end;
  except
    Result.Free();
    raise;
  end;
end;

procedure TclNntpServer.HandleIHAVE(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  messageID: string;
  allow: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);

  messageID := Trim(AParameters.Parameters);
  if (messageID = '') or (Pos('<', messageID) < 1) or (Pos('>', messageID) < 1) then
  begin
    RaiseNntpError(ACommand, 'article not wanted - Missing angle brackets', 435);
  end;

  allow := True;
  DoCanAcceptArticle(AConnection, messageID, allow);

  if (not allow) then
  begin
    RaiseNntpError(ACommand, 'article not wanted - do not send it', 435);
  end;

  AConnection.FMessageID := messageID;

  AcceptMultipleLines(AConnection, TclNntpCommandInfo.Create(ACommand, HandleIHaveArticle));
  SendResponse(AConnection, ACommand, '335 send article to be transferred.  End with <CR-LF>.<CR-LF>');
end;

procedure TclNntpServer.HandleIHaveArticle(AConnection: TclNntpCommandConnection;
  const ACommand: string; AParameters: TclTcpCommandParams);
var
  i: Integer;
  msg: TStrings;
  targetList: TclNewsGroupList;
  item: TclNewsGroupItem;
  artNo: Integer;
  msgID: string;
  article: TStrings;
  success: Boolean;
begin
  AcceptCommands(AConnection);

  msg := AParameters.RawData;

  targetList := nil;
  article := nil;
  try
    targetList := ValidateIHaveArticle(AConnection, ACommand, msg);
    article := TStringList.Create();

    for i := 0 to targetList.Count - 1 do
    begin
      item := targetList[i];
      article.Clear();

      artNo := 0;
      msgID := AConnection.MessageID;
      success := True;

      DoGetArticleSource(AConnection, item, artNo, msgID, article, success);
      if (success) then
      begin
        RaiseNntpError(ACommand, 'article rejected - do not try again', 437);
      end;
    end;

    for i := 0 to targetList.Count - 1 do
    begin
      item := targetList[i];

      msgID := AConnection.MessageID;
      success := True;
      
      DoArticleReceived(AConnection, item, msgID, msg, success);

      if (not success) then
      begin
        RaiseNntpError(ACommand, 'article rejected - do not try again', 437);
      end;
    end;

    SendResponse(AConnection, ACommand, '235 article transferred ok');
  finally
    article.Free();
    targetList.Free();
  end;
end;

function TclNntpServer.GetNullCommand(AParameters: TclTcpCommandParams): TclTcpCommandInfo;
begin
  Result := TclNntpCommandInfo.Create(AParameters.Command, HandleNullCommand);
end;

function TclNntpServer.GetSelectedGroup(AConnection: TclNntpCommandConnection; const ACommand: string): TclNewsGroupItem;
begin
  if (AConnection.CurrentGroup = '') then
  begin
    RaiseNntpError(ACommand, 'no newsgroup has been selected', 412);
  end;

  Result := Groups.FindGroup(AConnection.CurrentGroup);
  if (Result = nil) then
  begin
    RaiseNntpError(ACommand, 'no newsgroup has been selected', 412);
  end;

  CheckGroupAvailable(AConnection, ACommand, Result, apRead);
end;

procedure TclNntpServer.HandleNullCommand(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
begin
  RaiseNntpError(ACommand, 'command not recognized', 500);
end;

procedure TclNntpServer.ProcessUnhandledError(AConnection: TclCommandConnection;
  AParameters: TclTcpCommandParams; E: Exception);
begin
  SendResponse(AConnection, AParameters.Command, '503 program fault - command not performed');
end;

procedure TclNntpServer.RaiseNntpError(const ACommand, AMessage: string; ACode: Integer);
begin
  raise EclNntpServerError.Create(ACommand, Format('%d %s', [ACode, AMessage]), ACode);
end;

function TclNntpServer.GetMessageID(Article: TStrings): string;
var
  fieldList: TclMailHeaderFieldList;
begin
  fieldList := TclMailHeaderFieldList.Create(DefaultCharSet, cmNone, DefaultCharsPerLine);
  try
    fieldList.Parse(0, Article);
    Result := fieldList.GetFieldValue('Message-ID');
  finally
    fieldList.Free();
  end;
end;

procedure TclNntpServer.HandleSLAVE(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
begin
  AConnection.FIsSlave := True;
  SendResponse(AConnection, ACommand, '202 slave status noted');
end;

procedure TclNntpServer.HandleHELP(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  i: Integer;
  data: TStrings;
begin
  data := TStringList.Create();
  try
    for i := 0 to HelpText.Count - 1 do
    begin
      data.Add('  ' + HelpText[i]);
    end;

    SendResponse(AConnection, ACommand, '100 Legal commands');
    SendMultipleLines(AConnection, data, '.');
  except
    data.Free();
    raise;
  end;
end;

procedure TclNntpServer.DoDestroy;
begin
  FCapabilities.Free();
  FSubscriptions.Free();
  FOverviewFormat.Free();
  FHelpText.Free();
  FGroups.Free();
  FUserAccounts.Free();
  
  inherited DoDestroy();
end;

procedure TclNntpServer.DoGetArticles(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem; ADate: TDateTime;
  AGMT: Boolean; const ADistributions: string; Articles: TclNntpArticleList);
begin
  if Assigned(OnGetArticles) then
  begin
    OnGetArticles(Self, AConnection, AGroup, ADate, AGMT, ADistributions, Articles);
  end;
end;

procedure TclNntpServer.DoGetArticleSource(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem;
  var ArticleNo: Integer; var AMessageID: string; ArticleSource: TStrings; var Success: Boolean);
begin
  if Assigned(OnGetArticleSource) then
  begin
    OnGetArticleSource(Self, AConnection, AGroup, ArticleNo, AMessageID, ArticleSource, Success);
  end;
end;

procedure TclNntpServer.DoGetGroupInfo(AConnection: TclNntpCommandConnection; AGroup: TclNewsGroupItem; var ArticleCount,
  ALastArticle, AFirstArticle: Integer);
begin
  if Assigned(OnGetGroupInfo) then
  begin
    OnGetGroupInfo(Self, AConnection, AGroup, ArticleCount, ALastArticle, AFirstArticle);
  end;
end;

procedure TclNntpServer.DoListCommand(AConnection: TclNntpCommandConnection; AParameters: TclTcpCommandParams; var Handled: Boolean);
begin
  if Assigned(OnListCommand) then
  begin
    OnListCommand(Self, AConnection, AParameters, Handled);
  end;
end;

procedure TclNntpServer.HandleDATE(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
begin
  SendResponse(AConnection, ACommand,
    '111 ' + FormatDateTime('yyyymmddhhnnss', Now() + TimeZoneBiasToDateTime(TimeZoneBiasString())));
end;

procedure TclNntpServer.SetHelpText(const Value: TStrings);
begin
  FHelpText.Assign(Value);
end;

procedure TclNntpServer.SetOverviewFormat(const Value: TStrings);
begin
  FOverviewFormat.Assign(Value);
end;

procedure TclNntpServer.SetSubscriptions(const Value: TStrings);
begin
  FSubscriptions.Assign(Value);
end;

procedure TclNntpServer.HandleXHDR(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  i: Integer;
  group: TclNewsGroupItem;
  range, fieldName: string;
  s: string;
  data, list: TStrings;
  articles, targetList: TclNntpArticleList;
begin
  CheckTlsMode(AConnection, ACommand);

  group := GetSelectedGroup(AConnection, ACommand);

  s := Trim(AParameters.Parameters);
  range := '';
  fieldName := '';

  if (WordCount(s, [' ']) > 0) then
  begin
    fieldName := ExtractWord(1, s, [' ']);
  end;
  if (WordCount(s, [' ']) > 1) then
  begin
    range := ExtractWord(2, s, [' ']);
  end;

  if (range = '') then
  begin
    if (AConnection.CurrentArticle < 1) then
    begin
      RaiseNntpError(ACommand, 'no current article has been selected', 420);
    end;
    range := IntToStr(AConnection.CurrentArticle);
  end;

  data := TStringList.Create();
  try
    list := nil;
    articles := nil;
    targetList := nil;
    try
      list := TStringList.Create();
      list.Clear();
      list.Add(fieldName);

      if ((range[1] = '<') and (range[Length(range)] = '>')) then
      begin
        s := CollectArticleHeaders(AConnection, ACommand, group, range, list, ' ');
        if (s <> '') then
        begin
          data.Add(s);
        end;
      end else
      begin
        articles := TclNntpArticleList.Create();
        DoGetArticles(AConnection, group, 0, False, '', articles);

        targetList := articles.SelectArticles(range);
        for i := 0 to targetList.Count - 1 do
        begin
          s := CollectArticleHeaders(AConnection, ACommand, group, targetList[i].MessageID, list, ' ');
          if (s <> '') then
          begin
            data.Add(s);
          end;
        end;
      end;
    finally
      targetList.Free();
      articles.Free();
      list.Free();
    end;

    SendResponse(AConnection, ACommand, '221 %s fields follow', [fieldName]);
    SendMultipleLines(AConnection, data, '.');
  except
    data.Free();
    raise;
  end;
end;

procedure TclNntpServer.HandleXOVER(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  i: Integer;
  s, range: string;
  group: TclNewsGroupItem;
  data: TStrings;
  articles, targetList: TclNntpArticleList;
begin
  CheckTlsMode(AConnection, ACommand);

  group := GetSelectedGroup(AConnection, ACommand);

  range := Trim(AParameters.Parameters);

  if (range = '') then
  begin
    if (AConnection.CurrentArticle < 1) then
    begin
      RaiseNntpError(ACommand, 'no current article has been selected', 420);
    end;
    range := IntToStr(AConnection.CurrentArticle);
  end;

  data := TStringList.Create();
  try
    if ((range[1] = '<') and (range[Length(range)] = '>')) then
    begin
      s := CollectArticleHeaders(AConnection, ACommand, group, range, OverviewFormat, #9);
      if (s <> '') then
      begin
        data.Add(s);
      end;
    end else
    begin
      articles := nil;
      targetList := nil;
      try
        articles := TclNntpArticleList.Create();

        DoGetArticles(AConnection, group, 0, False, '', articles);

        targetList := articles.SelectArticles(range);
        for i := 0 to targetList.Count - 1 do
        begin
          s := CollectArticleHeaders(AConnection, ACommand, group, targetList[i].MessageID, OverviewFormat, #9);
          if (s <> '') then
          begin
            data.Add(s);
          end;
        end;
      finally
        targetList.Free();
        articles.Free();
      end;
    end;

    SendResponse(AConnection, ACommand, '224 data follows');
    SendMultipleLines(AConnection, data, '.');
  except
    data.Free();
    raise;
  end;
end;

procedure TclNntpServer.SetGroups(const Value: TclNewsGroupList);
begin
  FGroups.Assign(Value);
end;

function TclNntpServer.GetAllowedPermission(ARequired: TclNntpAccessPermission): Boolean;
var
  i: Integer;
begin
  for i := 0 to Groups.Count - 1 do
  begin
    if (ARequired in Groups[i].Permissions) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure TclNntpServer.GetCapabilities(AConnection: TclNntpCommandConnection; AList: TStrings);
begin
  if ((UseTls <> stNone) and not AConnection.IsTls) then
  begin
    AList.Add('STARTTLS');
  end;

  if (not AConnection.IsTls and GetAllowedPermission(apRead)) then
  begin
    AList.Add('READER');
  end;

  if (GetAllowedPermission(apIHave)) then
  begin
    AList.Add('IHAVE');
  end;

  AList.AddStrings(Capabilities);
end;

function TclNntpServer.GetCaseInsensitive: Boolean;
begin
  Result := FUserAccounts.CaseInsensitive;
end;

procedure TclNntpServer.SetCaseInsensitive(const Value: Boolean);
begin
  FUserAccounts.CaseInsensitive := Value;
end;

procedure TclNntpServer.SetUserAccounts(const Value: TclUserAccountList);
begin
  FUserAccounts.Assign(Value);
end;

procedure TclNntpServer.HandleAUTHINFO(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  cmd: string;
  isAuthorized: Boolean;
begin
  CheckTlsMode(AConnection, ACommand);

  if (WordCount(AParameters.Parameters, [' ']) <> 2) then
  begin
    RaiseNntpError(ACommand, 'bad authinfo param', 481);
  end;

  cmd := UpperCase(ExtractWord(1, AParameters.Parameters, [' ']));

  if ('USER' = cmd) then
  begin
    AConnection.FUserName := ExtractWord(2, AParameters.Parameters, [' ']);
    SendResponse(AConnection, ACommand, '381 PASS required');
  end else
  if ('PASS' = cmd) then
  begin
    if (AConnection.UserName = '') then
    begin
      RaiseNntpError(ACommand, 'USER required', 482);
    end;

    AConnection.FIsAuthorized := False;

    isAuthorized := Authenticate(AConnection, UserAccounts.AccountByUserName(AConnection.UserName),
      AConnection.UserName, ExtractWord(2, AParameters.Parameters, [' ']));
    CheckAuthorized(AConnection, ACommand, isAuthorized);

    AConnection.FIsAuthorized := True;
    SendResponse(AConnection, ACommand, '281 Ok');
  end else
  begin
    RaiseNntpError(ACommand, 'bad authinfo param', 481);
  end;
end;

function TclNntpServer.Authenticate(AConnection: TclNntpCommandConnection;
  Account: TclUserAccountItem; const AUserName, APassword: string): Boolean;
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

procedure TclNntpServer.HandleCAPABILITIES(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
var
  data: TStrings;
begin
  data := TStringList.Create();
  try
    GetCapabilities(AConnection, data);

    SendResponse(AConnection, ACommand, '101 Capability list:');
    SendMultipleLines(AConnection, data, '.');
  except
    data.Free();
    raise;
  end;
end;

procedure TclNntpServer.HandleSTARTTLS(AConnection: TclNntpCommandConnection; const ACommand: string;
  AParameters: TclTcpCommandParams);
begin
  if (UseTLS = stNone) then
  begin
    RaiseNntpError(ACommand, 'Can not initiate TLS negotiation', 580);
  end;
  if (UseTLS = stImplicit) or AConnection.IsTls then
  begin
    RaiseNntpError(ACommand, 'STARTTLS not allowed with active TLS layer', 502);
  end;

  AConnection.InitParams();
  StartTls(AConnection);

  SendResponse(AConnection, ACommand, '382 Continue with TLS negotiation');
end;

procedure TclNntpServer.CheckTlsMode(AConnection: TclNntpCommandConnection; const ACommand: string);
begin
  if (UseTLS = stExplicitRequire) and (not AConnection.IsTls) then
  begin
    RaiseNntpError(ACommand, 'Encryption or stronger authentication required', 483);
  end;
end;

function TclNntpServer.CollectArticleHeaders(AConnection: TclNntpCommandConnection; const ACommand: string;
  AGroup: TclNewsGroupItem; const AMessageID: string; AFieldNames: TStrings; const ADelimiter: string): string;
var
  i, artNo, cnt: Integer;
  s, msgID, name, val: string;
  article: TStrings;
  fieldList: TclMailHeaderFieldList;
  success: Boolean;
begin
  Result := '';

  artNo := 0;
  msgID := AMessageID;
  success := True;

  article := nil;
  fieldList := nil;
  try
    article := TStringList.Create();

    DoGetArticleSource(AConnection, AGroup, artNo, msgID, article, success);

    if (not success) then
    begin
      Exit;
    end;

    Assert((artNo > 0) and (msgID <> ''), 'Must specify both articleNo and messageID');

    fieldList := TclMailHeaderFieldList.Create(DefaultCharSet, cmNone, DefaultCharsPerLine);
    fieldList.Parse(0, article);

    Result := IntToStr(artNo);
    for i := 0 to AFieldNames.Count - 1 do
    begin
      name := '';
      val := '';
      s := AFieldNames[i];
      cnt := WordCount(s, [':']);
      
      if (cnt > 0) then
      begin
        name := ExtractWord(1, s, [':']);
      end;

      if (cnt > 1) and SameText('full', Trim(ExtractWord(2, s, [':']))) then
      begin
        val := val + name + ': ';
      end;

      val := val + fieldList.GetFieldValue(name);
      val := string(StrArrayReplace(WideString(val), [#9, #13, #10], #32));

      Result := Result + ADelimiter + val;
    end;
  finally
    fieldList.Free();
    article.Free();
  end;
end;

procedure TclNntpServer.SetCapabilities(const Value: TStrings);
begin
  FCapabilities.Assign(Value);
end;

{ TclNewsGroupList }

function TclNewsGroupList.Add: TclNewsGroupItem;
begin
  Result := TclNewsGroupItem(inherited Add());
end;

function TclNewsGroupList.GetItem(Index: Integer): TclNewsGroupItem;
begin
  Result := TclNewsGroupItem(inherited GetItem(Index));
end;

function TclNewsGroupList.Matches(AItem: TclNewsGroupItem; ANames: TStrings): Boolean;
var
  i: Integer;
begin
  for i := 0 to ANames.Count - 1 do
  begin
    if SameText(ANames[i], '!' + AItem.Name) then
    begin
      Result := False;
      Exit;
    end;
  end;

  for i := 0 to ANames.Count - 1 do
  begin
    if (ANames[i] = '*') then
    begin
      Result := True;
      Exit;
    end;
    
    if SameText(ANames[i], AItem.Name) then
    begin
      Result := True;
      Exit;
    end;
  end;

  Result := False;
end;

function TclNewsGroupList.FindGroup(const AName: string): TclNewsGroupItem;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if SameText(Result.Name, AName) then Exit;
  end;
  Result := nil;
end;

function TclNewsGroupList.SelectGroupsByNameSet(const ANewsGroups: string): TclNewsGroupList;
var
  i: Integer;
  item: TclNewsGroupItem;
  names: TStrings;
begin
  Result := TclNewsGroupList.Create(nil, TclNewsGroupItem);
  try
    names := TStringList.Create();
    try
      ExtractQuotedWords(ANewsGroups, names, ',');

      for i := 0 to Count - 1 do
      begin
        item := Items[i];
        if Matches(item, names) then
        begin
          Result.Add().Assign(item);
        end;
      end;
    finally
      names.Free();
    end;
  except
    Result.Free();
    raise;
  end;
end;

function TclNewsGroupList.SelectGroupsByWildMat(const AWildMat: string): TclNewsGroupList;
var
  i: Integer;
  item: TclNewsGroupItem;
begin
  Result := TclNewsGroupList.Create(nil, TclNewsGroupItem);
  try
    for i := 0 to Count - 1 do
    begin
      item := Items[i];
      if (AWildMat = '') or SameText(AWildMat, item.Name) then
      begin
        Result.Add().Assign(item);
      end;
    end;
  except
    Result.Free();
    raise;
  end;
end;

procedure TclNewsGroupList.SetItem(Index: Integer; const Value: TclNewsGroupItem);
begin
  inherited SetItem(Index, Value);
end;

{ TclNntpCommandInfo }

constructor TclNntpCommandInfo.Create(const AName: string; AHandler: TclNntpCommandHandler);
begin
  inherited Create(AName);
  FHandler := AHandler;
end;

procedure TclNntpCommandInfo.Execute(AConnection: TclCommandConnection; AParams: TclTcpCommandParams);
begin
  FHandler(AConnection as TclNntpCommandConnection, Name, AParams);
end;

{ TclNntpArticleItem }

constructor TclNntpArticleItem.Create(ArtNo: Integer; const AMessageID: string);
begin
  inherited Create();

  FArticleNo := ArtNo;
  FMessageID := AMessageID;
end;

{ TclNewsGroupItem }

procedure TclNewsGroupItem.Assign(Source: TPersistent);
var
  src: TclNewsGroupItem;
begin
  if (Source is TclNewsGroupItem) then
  begin
    src := (Source as TclNewsGroupItem);

    Name := src.Name;
    Permissions := src.Permissions;
    Users := src.Users;
    CreatedOn := src.CreatedOn;
    Owner := src.Owner;
  end else
  begin
    inherited Assign(Source);
  end;
end;

constructor TclNewsGroupItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  FUsers := TStringList.Create();
  FPermissions := [apRead, apPost, apIHave];
  FCreatedOn := Now();
end;

destructor TclNewsGroupItem.Destroy;
begin
  FUsers.Free();
  
  inherited Destroy();
end;

function TclNewsGroupItem.GetTimes: Integer;
begin
  Result := Round(CreatedOn - EncodeDate(1970, 1, 1));
end;

procedure TclNewsGroupItem.SetUsers(const Value: TStrings);
begin
  FUsers.Assign(Value);
end;

{ TclNntpCommandConnection }

constructor TclNntpCommandConnection.Create;
begin
  inherited Create();
  InitParams();
end;

procedure TclNntpCommandConnection.InitParams;
begin
  FIsAuthorized := False;
  FUserName := '';
  FModeType := mtDefault;
  FCurrentGroup := '';
  FCurrentArticle := 0;
  FMessageID := '';
  FIsSlave := False;
end;

{ TclNntpArticleList }

procedure TclNntpArticleList.Add(AItem: TclNntpArticleItem);
var
  ind: Integer;
begin
  ind := Count;

  while (ind > 0) do
  begin
    if (Items[ind - 1].ArticleNo < AItem.ArticleNo) then
    begin
      Break;
    end;
    Dec(ind);
  end;

  if (ind >= Count) then
  begin
    FList.Add(AItem);
  end else
  begin
    FList.Insert(ind, AItem);
  end;
end;

procedure TclNntpArticleList.Clear;
begin
  FList.Clear();
end;

constructor TclNntpArticleList.Create;
begin
  inherited Create();
  DoCreate(True);
end;

constructor TclNntpArticleList.Create(AOwnsObjects: Boolean);
begin
  inherited Create();
  DoCreate(AOwnsObjects);
end;

procedure TclNntpArticleList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TclNntpArticleList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

procedure TclNntpArticleList.DoCreate(AOwnsObjects: Boolean);
begin
  FList := TObjectList.Create(AOwnsObjects);
end;

function TclNntpArticleList.FindArticle(ArticleNo: Integer): TclNntpArticleItem;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if (Result.ArticleNo = ArticleNo) then Exit;
  end;
  Result := nil;
end;

function TclNntpArticleList.FindArticle(const AMessageID: string): TclNntpArticleItem;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if SameText(Result.MessageID, AMessageID) then Exit;
  end;
  Result := nil;
end;

function TclNntpArticleList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclNntpArticleList.GetItem(Index: Integer): TclNntpArticleItem;
begin
  Result := TclNntpArticleItem(FList[Index]);
end;

function TclNntpArticleList.GetOwnsObjects: Boolean;
begin
  Result := FList.OwnsObjects;
end;

function TclNntpArticleList.SelectArticles(const ARange: string): TclNntpArticleList;
var
  rangeList: TStrings;
  i, first, last: Integer;
  item: TclNntpArticleItem;
begin
  Result := TclNntpArticleList.Create(False);
  try
    if ((Count = 0) or (ARange = '')) then
    begin
      Exit;
    end;

    rangeList := TStringList.Create();
    try
      ExtractQuotedWords(ARange, rangeList, '-');

      first := Items[0].ArticleNo;

      if (rangeList.Count > 0) then
      begin
        first := StrToIntDef(rangeList[0], first);
      end;

      last := first;

      if (Pos('-', ARange) > 0) then
      begin
        last := Items[Count - 1].ArticleNo;
      end;

      if (rangeList.Count > 1) then
      begin
        last := StrToIntDef(rangeList[1], last);
      end;

      for i := 0 to Count - 1 do
      begin
        item := Items[i];

        if ((item.ArticleNo >= first) and (item.ArticleNo <= last)) then
        begin
          Result.Add(item);
        end;
      end;
    finally
      rangeList.Free();
    end;
  except
    Result.Free();
    raise;
  end;
end;

end.
