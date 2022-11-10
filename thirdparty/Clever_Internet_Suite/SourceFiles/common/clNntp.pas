{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clNntp;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  SysUtils, Classes, {$IFDEF DEMO} Forms, Windows, clCertificate,{$ENDIF}
{$ELSE}
  System.SysUtils, System.Classes, {$IFDEF DEMO} Vcl.Forms, Winapi.Windows, clCertificate,{$ENDIF}
{$ENDIF}
  clUtils, clMailMessage, clEmailAddress, clTcpClient, clTcpCommandClient, clNntpUtils, clSocketUtils;

type
  TclNewsGroupInfo = class
  private
    FLastArticle: Integer;
    FFirstArticle: Integer;
    FArticleCount: Integer;
    FGroupName: string;
    FAllowPost: Boolean;
    procedure Clear;
  public
    constructor Create;
    
    property GroupName: string read FGroupName write FGroupName;
    property ArticleCount: Integer read FArticleCount write FArticleCount;
    property LastArticle: Integer read FLastArticle write FLastArticle;
    property FirstArticle: Integer read FFirstArticle write FFirstArticle;
    property AllowPost: Boolean read FAllowPost write FAllowPost;
  end;

  TclArticleInfo = class
  private
    FDate: TDateTime;
    FArticleNo: Integer;
    FFrom: TclEmailAddressItem;
    FSubject: string;
    FLines: Integer;
    FReferences: TStrings;
    FAllHeaders: string;
    FSize: Integer;
    FMessageID: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Parse(const ASource: string); virtual;
    procedure Clear; virtual;
    procedure Assign(ASource: TclArticleInfo); virtual;

    property ArticleNo: Integer read FArticleNo;
    property Subject: string read FSubject;
    property From: TclEmailAddressItem read FFrom;
    property Date: TDateTime read FDate;
    property MessageID: string read FMessageID;
    property References: TStrings read FReferences;
    property Size: Integer read FSize;
    property Lines: Integer read FLines;
    property AllHeaders: string read FAllHeaders;
  end;

  TclGroupInfoEvent = procedure(Sender: TObject; AGroupInfo: TclNewsGroupInfo) of object;

  TclGroupOverviewEvent = procedure(Sender: TObject; ArticleInfo: TclArticleInfo) of object;
  
  TclNntp = class(TclTcpCommandClient)
  private
    FModeType: TclNntpModeType;
    FCanPost: Boolean;
    FCanStream: Boolean;
    FOnGetGroupInfo: TclGroupInfoEvent;
    FCurrentGroup: TclNewsGroupInfo;
    FResponseLinesNeeded: Integer;
    FOnGroupOverview: TclGroupOverviewEvent;
    FNewsAgent: string;
    
    procedure SetModeType(const Value: TclNntpModeType);
    procedure SetNewsAgent(const Value: string);
    procedure ParseGroups(AList: TStrings; ADetails: Boolean = False);
    procedure ParseOverview;
    procedure InternalGet(Article: TStrings);
    procedure AddNewsReaderLine(Article: TStrings);
  protected
    procedure DoGetGroupInfo(AGroupInfo: TclNewsGroupInfo); dynamic;
    procedure DoGroupOverview(ArticleInfo: TclArticleInfo); dynamic;
    function GetDefaultPort: Integer; override;
    function GetResponseCode(const AResponse: string): Integer; override;
    procedure OpenSession; override;
    procedure CloseSession; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure StartTls; override;

    procedure Authenticate;
    procedure SendNntpCommand(const ACommand: string; const AOkResponses: array of Integer); overload;
    procedure SendNntpCommand(const ACommand: string; const AOkResponses: array of Integer; const Args: array of const); overload;

    procedure GetGroups(AList: TStrings; ADetails: Boolean = False);
    procedure GetNewGroups(AList: TStrings; ADate: TDateTime; AGMT: Boolean; const ADistributions: string = ''; ADetails: Boolean = False);
    procedure GetNewArticles(AList: TStrings; const ANewsGroups: string; ADate: TDateTime; AGMT: Boolean; const ADistributions: string = '');
    procedure SelectGroup(const AName: string);
    function SelectArticle(ArticleNo: Integer): string;
    function Next: string;
    function Prev: string;

    procedure PostArticle(Article: TclMailMessage; const AReference, ANewsGroup: string); overload;
    procedure PostArticle(Article: TclMailMessage); overload;
    procedure PostArticle(Article: TStrings); overload;

    procedure GetArticle(Article: TStrings); overload;
    procedure GetArticle(ArticleNo: Integer; Article: TStrings); overload;
    procedure GetArticle(const AMessageID: string; Article: TStrings); overload;
    procedure GetArticle(Article: TclMailMessage); overload;
    procedure GetArticle(ArticleNo: Integer; Article: TclMailMessage); overload;
    procedure GetArticle(const AMessageID: string; Article: TclMailMessage); overload;

    procedure GetHeader(AHeader: TStrings); overload;
    procedure GetHeader(ArticleNo: Integer; AHeader: TStrings); overload;
    procedure GetHeader(const AMessageID: string; AHeader: TStrings); overload;
    procedure GetHeader(AHeader: TclMailMessage); overload;
    procedure GetHeader(ArticleNo: Integer; AHeader: TclMailMessage); overload;
    procedure GetHeader(const AMessageID: string; AHeader: TclMailMessage); overload;

    procedure GetBody(ABody: TStrings); overload;
    procedure GetBody(ArticleNo: Integer; ABody: TStrings); overload;
    procedure GetBody(const AMessageID: string; ABody: TStrings); overload;

    procedure IHave(const AMessageID: string; Article: TStrings); overload;
    procedure IHave(const AMessageID: string; Article: TclMailMessage); overload;
    procedure Check(AMessageIDs, AResponses: TStrings);
    procedure TakeThis(const AMessageID: string; Article: TStrings); overload;
    procedure TakeThis(const AMessageID: string; Article: TclMailMessage); overload;
    procedure GetHeaderValue(const AHeaderName, AParameters: string; AValues: TStrings);

    procedure GetOverviewFormat(AFormat: TStrings);
    procedure GroupOverview(const ARange: string); overload;
    procedure GroupOverview(ArticleNo: Integer); overload;
    procedure GroupOverview(AFirstArticle, ALastArticle: Integer); overload;
    procedure GroupOverview; overload;

    property CanPost: Boolean read FCanPost;
    property CanStream: Boolean read FCanStream;
    property CurrentGroup: TclNewsGroupInfo read FCurrentGroup;
  published
    property Port default DefaultNntpPort;
    property ModeType: TclNntpModeType read FModeType write SetModeType default mtDefault;
    property NewsAgent: string read FNewsAgent write SetNewsAgent;

    property OnGetGroupInfo: TclGroupInfoEvent read FOnGetGroupInfo write FOnGetGroupInfo;
    property OnGroupOverview: TclGroupOverviewEvent read FOnGroupOverview write FOnGroupOverview;
  end;

const
  NNTP_RESPONSELINESNEEDED = 10;
  
implementation

uses
  clMailUtils, clSocket, clMailHeader, clEncoder;

{ TclNntp }

function TclNntp.GetResponseCode(const AResponse: string): Integer;
begin
  Result := SOCKET_WAIT_RESPONSE;
  if (FResponseLinesNeeded > 0) then
  begin
    if (FResponseLinesNeeded = Response.Count) then
    begin
      Result := NNTP_RESPONSELINESNEEDED;
    end;
  end else
  if (Length(AResponse) > 2) then
  begin
    Result := StrToIntDef(System.Copy(AResponse, 1, 3), SOCKET_WAIT_RESPONSE);
  end else
  if (AResponse = '.') then
  begin
    Result := SOCKET_DOT_RESPONSE;
  end;
end;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

procedure TclNntp.OpenSession;
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
    if (not IsDemoDisplayed) and (not IsEncoderDemoDisplayed)
      and (not IsCertDemoDisplayed) and (not IsMailMessageDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsMailMessageDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  WaitResponse([200, 201]);

  FCanPost := (LastResponseCode = 200);
  FCanStream := False;

  ExplicitStartTls();

  case ModeType of
    mtReader:
      begin
        SendNntpCommand('MODE READER', [200, 201]);
        FCanPost := (LastResponseCode = 200);
      end;
    mtStream:
      begin
        try
          SendNntpCommand('MODE STREAM', [203]);
          FCanStream := True;
        except
          on EclSocketError do ;
        end;
      end;
  end;
end;

procedure TclNntp.CloseSession;
begin
  SendSilentCommand('QUIT', [205]);
end;

constructor TclNntp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCurrentGroup := TclNewsGroupInfo.Create();
  FNewsAgent := DefaultMailAgent;
  FModeType := mtDefault;
end;

procedure TclNntp.SetModeType(const Value: TclNntpModeType);
begin
  if (FModeType <> Value) then
  begin
    FModeType := Value;
    Changed();
  end;
end;

procedure TclNntp.GetGroups(AList: TStrings; ADetails: Boolean);
begin
  SendNntpCommand('LIST', [215]);
  WaitMultipleLines(0);
  ParseGroups(AList, ADetails);
end;

procedure TclNntp.SendNntpCommand(const ACommand: string;
  const AOkResponses: array of Integer);
begin
  try
    SendCommandSync(ACommand, AOkResponses);
  except
    on E: EclSocketError do
    begin
      if ((LastResponseCode = 480) or (LastResponseCode = 450))
        and ((UserName <> '') or (Password <> '')) then
      begin
        Authenticate();
        SendCommandSync(ACommand, AOkResponses);
      end else
      begin
        raise;
      end;
    end;
  end;
end;

procedure TclNntp.Authenticate;
begin
  SendCommandSync('AUTHINFO USER %s', [281, 381], [UserName]);
  if (LastResponseCode = 381) then
  begin
    SendCommandSync('AUTHINFO PASS %s', [281], [Password]);
  end;
end;

procedure TclNntp.SendNntpCommand(const ACommand: string;
  const AOkResponses: array of Integer; const Args: array of const);
begin
  SendNntpCommand(Format(ACommand, Args), AOkResponses);
end;

procedure TclNntp.DoGetGroupInfo(AGroupInfo: TclNewsGroupInfo);
begin
  if Assigned(OnGetGroupInfo) then
  begin
    OnGetGroupInfo(Self, AGroupInfo);
  end;
end;

procedure TclNntp.GetNewGroups(AList: TStrings; ADate: TDateTime; AGMT: Boolean;
  const ADistributions: string; ADetails: Boolean);
begin
  SendNntpCommand('NEWGROUPS %s', [231], [BuildNntpQuery(ADate, AGMT, ADistributions)]);
  WaitMultipleLines(0);
  ParseGroups(AList, ADetails);
end;

procedure TclNntp.ParseGroups(AList: TStrings; ADetails: Boolean);
var
  i: Integer;
  info: TclNewsGroupInfo;
begin
  AList.Assign(Response);
  info := TclNewsGroupInfo.Create();
  try
    for i := 0 to AList.Count - 1 do
    begin
      info.GroupName := ExtractWord(1, AList[i], [#32, #9]);
      info.LastArticle := StrToIntDef(ExtractWord(2, AList[i], [#32, #9]), 0);
      info.FirstArticle := StrToIntDef(ExtractWord(3, AList[i], [#32, #9]), 0);
      info.AllowPost := UpperCase(Trim(ExtractWord(4, AList[i], [#32, #9]))) = 'Y';

      DoGetGroupInfo(info);
      if not ADetails then
      begin
        AList[i] := info.GroupName;
      end;
    end;
  finally
    info.Free();
  end;
end;

destructor TclNntp.Destroy;
begin
  FCurrentGroup.Free();
  inherited Destroy();;
end;

procedure TclNntp.SelectGroup(const AName: string);
var
  s: string;
begin
  SendNntpCommand('GROUP %s', [211], [AName]);
  s := Response.Text;
  CurrentGroup.ArticleCount := StrToIntDef(ExtractWord(2, s, [#32, #9]), 0);
  CurrentGroup.FirstArticle := StrToIntDef(ExtractWord(3, s, [#32, #9]), 0);
  CurrentGroup.LastArticle := StrToIntDef(ExtractWord(4, s, [#32, #9]), 0);
  CurrentGroup.GroupName := ExtractWord(5, s, [#32, #9]);
  CurrentGroup.AllowPost := CanPost;
end;

procedure TclNntp.PostArticle(Article: TclMailMessage);
begin
  PostArticle(Article.MessageSource);
end;

procedure TclNntp.AddNewsReaderLine(Article: TStrings);
var
  fieldList: TclMailHeaderFieldList;
begin
  fieldList := TclMailHeaderFieldList.Create(DefaultCharSet, cmNone, DefaultCharsPerLine);
  try
    fieldList.Parse(0, Article);
    fieldList.AddFieldIfNotExist('X-Newsreader', NewsAgent);
  finally
    fieldList.Free();
  end;
end;

procedure TclNntp.PostArticle(Article: TStrings);
begin
  AddNewsReaderLine(Article);
  SendNntpCommand('POST', [340]);
  SendMultipleLines(Article, '.');
  WaitResponse([240]);
end;

procedure TclNntp.PostArticle(Article: TclMailMessage; const AReference, ANewsGroup: string);
begin
  if (AReference <> '') and (Article.References.IndexOf(AReference) < 0) then
  begin
    Article.References.Add(AReference);
  end;
  if (ANewsGroup <> '') and (Article.NewsGroups.IndexOf(ANewsGroup) < 0) then
  begin
    Article.NewsGroups.Add(ANewsGroup);
  end;
  PostArticle(Article);
end;

procedure TclNntp.GetNewArticles(AList: TStrings;
  const ANewsGroups: string; ADate: TDateTime; AGMT: Boolean;
  const ADistributions: string);
begin
  SendNntpCommand('NEWNEWS %s %s', [230], [ANewsGroups, BuildNntpQuery(ADate, AGMT, ADistributions)]);
  WaitMultipleLines(0);
  AList.Assign(Response);
end;

function TclNntp.SelectArticle(ArticleNo: Integer): string;
begin
  SendNntpCommand('STAT %d', [223], [ArticleNo]);
  Result := ExtractWord(3, Response.Text, [#32, #9]);
end;

function TclNntp.Next: string;
begin
  SendNntpCommand('NEXT', [223]);
  Result := ExtractWord(3, Response.Text, [#32, #9]);
end;

function TclNntp.Prev: string;
begin
  SendNntpCommand('LAST', [223]);
  Result := ExtractWord(3, Response.Text, [#32, #9]);
end;

procedure TclNntp.GetArticle(Article: TStrings);
begin
  SendNntpCommand('ARTICLE', [220]);
  InternalGet(Article);
end;

procedure TclNntp.GetArticle(ArticleNo: Integer; Article: TStrings);
begin
  SendNntpCommand('ARTICLE %d', [220], [ArticleNo]);
  InternalGet(Article);
end;

procedure TclNntp.GetArticle(const AMessageID: string;
  Article: TStrings);
begin
  SendNntpCommand('ARTICLE %s', [220], [GetNormMessageID(AMessageID)]);
  InternalGet(Article);
end;

procedure TclNntp.GetArticle(Article: TclMailMessage);
var
  src: TStrings; 
begin
  src := TStringList.Create();
  try
    GetArticle(src);
    Article.MessageSource := src;
  finally
    src.Free();
  end;
end;

procedure TclNntp.GetArticle(ArticleNo: Integer;
  Article: TclMailMessage);
var
  src: TStrings; 
begin
  src := TStringList.Create();
  try
    GetArticle(ArticleNo, src);
    Article.MessageSource := src;
  finally
    src.Free();
  end;
end;

procedure TclNntp.GetArticle(const AMessageID: string;
  Article: TclMailMessage);
var
  src: TStrings;
begin
  src := TStringList.Create();
  try
    GetArticle(AMessageID, src);
    Article.MessageSource := src;
  finally
    src.Free();
  end;
end;

procedure TclNntp.GetHeader(const AMessageID: string;
  AHeader: TStrings);
begin
  SendNntpCommand('HEAD %s', [221], [GetNormMessageID(AMessageID)]);
  InternalGet(AHeader);
end;

procedure TclNntp.GetHeader(ArticleNo: Integer; AHeader: TStrings);
begin
  SendNntpCommand('HEAD %d', [221], [ArticleNo]);
  InternalGet(AHeader);
end;

procedure TclNntp.GetHeader(AHeader: TStrings);
begin
  SendNntpCommand('HEAD', [221]);
  InternalGet(AHeader);
end;

procedure TclNntp.GetHeader(const AMessageID: string; AHeader: TclMailMessage);
var
  src: TStrings;
begin
  src := TStringList.Create();
  try
    GetHeader(AMessageID, src);
    AHeader.HeaderSource := src;
  finally
    src.Free();
  end;
end;

procedure TclNntp.GetHeader(ArticleNo: Integer;
  AHeader: TclMailMessage);
var
  src: TStrings;
begin
  src := TStringList.Create();
  try
    GetHeader(ArticleNo, src);
    AHeader.HeaderSource := src;
  finally
    src.Free();
  end;
end;

procedure TclNntp.GetHeader(AHeader: TclMailMessage);
var
  src: TStrings;
begin
  src := TStringList.Create();
  try
    GetHeader(src);
    AHeader.HeaderSource := src;
  finally
    src.Free();
  end;
end;

procedure TclNntp.IHave(const AMessageID: string; Article: TclMailMessage);
begin
  IHave(AMessageID, Article.MessageSource);
end;

procedure TclNntp.InternalGet(Article: TStrings);
begin
  WaitMultipleLines(0);
  Article.Assign(Response);
end;

procedure TclNntp.GetBody(ABody: TStrings);
begin
  SendNntpCommand('BODY', [222]);
  InternalGet(ABody);
end;

procedure TclNntp.GetBody(ArticleNo: Integer; ABody: TStrings);
begin
  SendNntpCommand('BODY %d', [222], [ArticleNo]);
  InternalGet(ABody);
end;

procedure TclNntp.GetBody(const AMessageID: string; ABody: TStrings);
begin
  SendNntpCommand('BODY %s', [222], [GetNormMessageID(AMessageID)]);
  InternalGet(ABody);
end;

procedure TclNntp.IHave(const AMessageID: string; Article: TStrings);
begin
  AddNewsReaderLine(Article);
  SendNntpCommand('IHAVE %s', [335], [GetNormMessageID(AMessageID)]);
  SendMultipleLines(Article, '.');
  WaitResponse([235]);
end;

procedure TclNntp.Check(AMessageIDs, AResponses: TStrings);
var
  i: Integer;
begin
  if (AMessageIDs.Count = 0) then Exit;
  
  Response.Clear();
  for i := 0 to AMessageIDs.Count - 1 do
  begin
    SendCommand('CHECK ' + GetNormMessageID(AMessageIDs[i]));
  end;

  FResponseLinesNeeded := AMessageIDs.Count;
  try
    WaitResponse([NNTP_RESPONSELINESNEEDED]);
  finally
    FResponseLinesNeeded := 0;
  end;
  AResponses.Assign(Response);
end;

procedure TclNntp.TakeThis(const AMessageID: string; Article: TStrings);
begin
  AddNewsReaderLine(Article);
  SendCommand('TAKETHIS ' + GetNormMessageID(AMessageID));
  SendMultipleLines(Article, '.');
  WaitResponse([239]);
end;

procedure TclNntp.GetHeaderValue(const AHeaderName, AParameters: string; AValues: TStrings);
begin
  SendNntpCommand('XHDR %s %s', [221], [AHeaderName, AParameters]);
  WaitMultipleLines(0);
  AValues.Assign(Response);
end;

procedure TclNntp.GetOverviewFormat(AFormat: TStrings);
begin
  SendNntpCommand('LIST OVERVIEW.FMT', [215]);
  WaitMultipleLines(0);
  AFormat.Assign(Response);
end;

procedure TclNntp.GroupOverview(const ARange: string);
var
  cmd: string;
begin
  cmd := 'XOVER';
  if (ARange <> '') then
  begin
    cmd := cmd + ' ' + ARange;
  end;

  SendNntpCommand(cmd, [224]);
  WaitMultipleLines(0);
  ParseOverview();
end;

procedure TclNntp.GroupOverview(ArticleNo: Integer);
begin
  GroupOverview(IntToStr(ArticleNo));
end;

procedure TclNntp.GroupOverview(AFirstArticle, ALastArticle: Integer);
var
  range: string;
begin
  range := '-';
  if (AFirstArticle > 0) then
  begin
    range := IntToStr(AFirstArticle) + range;
  end;
  if (ALastArticle > 0) then
  begin
    range := range + IntToStr(ALastArticle);
  end;
  
  GroupOverview(range);
end;

procedure TclNntp.GroupOverview;
begin
  GroupOverview(0, 0);
end;

procedure TclNntp.ParseOverview;
var
  i: Integer;
  info: TclArticleInfo;
begin
  info := TclArticleInfo.Create();
  try
    for i := 0 to Response.Count - 1 do
    begin
      info.Parse(Response[i]);
      DoGroupOverview(info);
    end;
  finally
    info.Free();
  end;
end;

procedure TclNntp.DoGroupOverview(ArticleInfo: TclArticleInfo);
begin
  if Assigned(OnGroupOverview) then
  begin
    OnGroupOverview(Self, ArticleInfo);
  end;
end;

procedure TclNntp.StartTls;
begin
  SendCommandSync('STARTTLS', [382]);
  inherited StartTls();
end;

procedure TclNntp.TakeThis(const AMessageID: string; Article: TclMailMessage);
begin
  TakeThis(AMessageID, Article.MessageSource);
end;

function TclNntp.GetDefaultPort: Integer;
begin
  Result := DefaultNntpPort;
end;

procedure TclNntp.SetNewsAgent(const Value: string);
begin
  if (FNewsAgent <> Value) then
  begin
    FNewsAgent := Value;
    Changed();
  end;
end;

{ TclNewsGroupInfo }

procedure TclNewsGroupInfo.Clear;
begin
  FLastArticle := 0;
  FFirstArticle := 0;
  FArticleCount := 0;
  FGroupName := '';
  FAllowPost := True;
end;

constructor TclNewsGroupInfo.Create;
begin
  inherited Create();
  Clear();
end;

{ TclArticleInfo }

procedure TclArticleInfo.Assign(ASource: TclArticleInfo);
begin
  if (ASource <> nil) then
  begin
    FArticleNo := ASource.ArticleNo;
    FSubject := ASource.Subject;
    FFrom.Assign(ASource.From);
    FDate := ASource.Date;
    FMessageID := ASource.MessageID;
    FReferences.Assign(ASource.References);
    FSize := ASource.Size;
    FLines := ASource.Lines;
    FAllHeaders := ASource.AllHeaders;
  end else
  begin
    Clear();
  end;
end;

procedure TclArticleInfo.Clear;
begin
  FArticleNo := 0;
  FSubject := '';
  FFrom.Clear();
  FDate := Now();
  FMessageID := '';
  FReferences.Clear();
  FSize := 0;
  FLines := 0;
  FAllHeaders := '';
end;

constructor TclArticleInfo.Create;
begin
  inherited Create();

  FFrom := TclEmailAddressItem.Create();
  FReferences := TStringList.Create();

  Clear();
end;

destructor TclArticleInfo.Destroy;
begin
  FReferences.Free();
  FFrom.Free();

  inherited Destroy();
end;

procedure TclArticleInfo.Parse(const ASource: string);
var
  words: TStrings;
begin
  words := nil;
  try
    words := TStringList.Create();

    SplitText(ASource, words, #9);
    if (words.Count >= 8) then
    begin
      FArticleNo := StrToIntDef(Trim(words[0]), 0);
      FSubject := TclMailHeaderFieldList.DecodeField(Trim(words[1]), DefaultCharSet);
      FFrom.FullAddress := TclMailHeaderFieldList.DecodeEmail(Trim(words[2]), DefaultCharSet);
      FDate := MimeTimeToDateTime(TclMailHeaderFieldList.DecodeField(Trim(words[3]), DefaultCharSet));
      FMessageID := Trim(words[4]);
      FReferences.Text := StringReplace(Trim(words[5]), #32, #13#10, [rfReplaceAll]);
      FSize := StrToIntDef(Trim(words[6]), 0);
      FLines := StrToIntDef(Trim(words[7]), 0);
    end else
    begin
      Clear();
    end;

    FAllHeaders := ASource;
  finally
    words.Free();
  end;
end;

end.

