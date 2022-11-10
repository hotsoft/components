{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clDnsServer;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Contnrs,{$IFDEF DEMO} Windows,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils, System.Contnrs,{$IFDEF DEMO} Winapi.Windows,{$ENDIF}
{$ENDIF}
  clUdpServer, clDnsMessage, clSocketUtils{$IFDEF LOGGER}, clLogger{$ENDIF};

type
  EclDnsServerError = class(EclUdpServerError)
  public
    constructor Create(AErrorCode: Integer; ADummy: Boolean = False); overload;
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean = False); overload;
  end;

  TclDnsCacheEntry = class
  private
    FName: string;
    FRecordType: Integer;
    FCreatedOn: TDateTime;
    FNameServers: TclDnsRecordList;
    FAnswers: TclDnsRecordList;
    FAdditionalRecords: TclDnsRecordList;

    function CheckExpired(ARecords: TclDnsRecordList; AMaxCacheTTL: Integer): Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    function IsExpired(AMaxCacheTTL: Integer): Boolean;
    procedure Load(ACachedResponse: TclDnsMessage);
    
    property Name: string read FName write FName;
    property RecordType: Integer read FRecordType write FRecordType;
    property NameServers: TclDnsRecordList read FNameServers;
    property Answers: TclDnsRecordList read FAnswers;
    property AdditionalRecords: TclDnsRecordList read FAdditionalRecords;
    property CreatedOn: TDateTime read FCreatedOn write FCreatedOn;
  end;

  TclDnsServer = class;

  TclDnsCommandInfo = class
  private
    FCode: Integer;
    FServer: TclDnsServer;

    function SearchHandedZone(AConnection: TclUdpUserConnection; const AQueryName: string; AResponse: TclDnsMessage): Boolean;
    function SearchCachedZone(AConnection: TclUdpUserConnection; AQuery, AResponse: TclDnsMessage): Boolean;
    function ResolveCachedZone(AConnection: TclUdpUserConnection; AQuery: TclDnsMessage): TclDnsMessage;
    procedure FillCachedResponse(ACacheEntry: TclDnsCacheEntry; AResponse: TclDnsMessage);
    procedure ClearResponseRecords(AResponse: TclDnsMessage);
  protected
    procedure AddARecord(const AName: string; ARecords: TclDnsRecordList; AResponse: TclDnsMessage);
    procedure FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage); virtual; abstract;
  public
    constructor Create(ACode: Integer);

    procedure Execute(AConnection: TclUdpUserConnection; AQuery, AResponse: TclDnsMessage);

    property Code: Integer read FCode write FCode;
    property Server: TclDnsServer read FServer;
  end;

  TclDnsACommandInfo = class(TclDnsCommandInfo)
  protected
    procedure FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage); override;
  public
    constructor Create;
  end;

  TclDnsAAAACommandInfo = class(TclDnsCommandInfo)
  protected
    procedure FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage); override;
  public
    constructor Create;
  end;

  TclDnsNSCommandInfo = class(TclDnsCommandInfo)
  protected
    procedure FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage); override;
  public
    constructor Create;
  end;

  TclDnsCNAMECommandInfo = class(TclDnsCommandInfo)
  protected
    procedure FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage); override;
  public
    constructor Create;
  end;

  TclDnsSOACommandInfo = class(TclDnsCommandInfo)
  protected
    procedure FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage); override;
  public
    constructor Create;
  end;

  TclDnsPTRCommandInfo = class(TclDnsCommandInfo)
  protected
    procedure FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage); override;
  public
    constructor Create;
  end;

  TclDnsMXCommandInfo = class(TclDnsCommandInfo)
  protected
    procedure FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage); override;
  public
    constructor Create;
  end;

  TclDnsTXTCommandInfo = class(TclDnsCommandInfo)
  protected
    procedure FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage); override;
  public
    constructor Create;
  end;

  TclDnsCommandList = class
  private
    FList: TObjectList;
    FServer: TclDnsServer;
    
    function GetItem(Index: Integer): TclDnsCommandInfo;
    function GetCount: Integer;
  public
    constructor Create(AServer: TclDnsServer);
    destructor Destroy; override;

    procedure Add(ACommand: TclDnsCommandInfo);
    function CommandByCode(ACode: Integer): TclDnsCommandInfo;
    procedure Delete(Index: Integer);
    procedure Clear;

    property Items[Index: Integer]: TclDnsCommandInfo read GetItem; default;
    property Count: Integer read GetCount;
    property Server: TclDnsServer read FServer;
  end;

  TclDnsQueryEvent = procedure (Sender: TObject; AConnection: TclUdpUserConnection; AQuery: TclDnsMessage) of object;
  TclDnsResponseEvent = procedure (Sender: TObject; AConnection: TclUdpUserConnection; AQuery, AResponse: TclDnsMessage) of object;
  TclDnsRecordsEvent = procedure (Sender: TObject; AConnection: TclUdpUserConnection; const AName: string;
    ARecords: TclDnsRecordList) of object;
  TclDnsCacheEvent = procedure (Sender: TObject; AConnection: TclUdpUserConnection; const AName: string;
    ARecordType: Integer; var ACacheEntry: TclDnsCacheEntry) of object;
  TclDnsAddCacheEvent = procedure (Sender: TObject; AConnection: TclUdpUserConnection; const AName: string;
    ARecordType: Integer; ACacheEntry: TclDnsCacheEntry) of object;
  TclDnsDeleteCacheEvent = procedure (Sender: TObject; AConnection: TclUdpUserConnection; const AName: string;
    ARecordType: Integer) of object;
  TclDnsResolveRecordsEvent = procedure (Sender: TObject; AConnection: TclUdpUserConnection; const AName: string;
    ARecordType: Integer; AResponse: TclDnsMessage; var Handled: Boolean) of object;

  TclDnsServer = class(TclUdpServer)
  private
    FCommands: TclDnsCommandList;
    FMaxCacheTTL: Integer;
    FMaxRecursiveQueries: Integer;
    FUseRecursiveQueries: Boolean;
    FUseCaching: Boolean;
    FRootNameServers: TStrings;
    
    FOnSendResponse: TclDnsResponseEvent;
    FOnGetCachedRecords: TclDnsCacheEvent;
    FOnGetHandedRecords: TclDnsRecordsEvent;
    FOnDeleteCachedRecords: TclDnsDeleteCacheEvent;
    FOnAddCachedRecords: TclDnsAddCacheEvent;
    FOnResolveCachedRecords: TclDnsResolveRecordsEvent;
    FOnReceiveQuery: TclDnsQueryEvent;
    FTimeOut: Integer;
    
    procedure SetRootNameServers(const Value: TStrings);

    procedure SendResponse(AConnection: TclUdpUserConnection; AQuery, AResponse: TclDnsMessage);
    procedure InitResponse(AConnection: TclUdpUserConnection; AQuery, AResponse: TclDnsMessage);
    procedure CheckQuery(AQuery: TclDnsMessage);
    procedure HandleCommandData(AConnection: TclUdpUserConnection; AData: TStream);
    procedure FillDefaultRootNameServers;
  protected
    procedure DoSendResponse(AConnection: TclUdpUserConnection; AQuery, AResponse: TclDnsMessage); virtual;
    procedure DoGetCachedRecords(AConnection: TclUdpUserConnection; const AName: string; ARecordType: Integer;
      var ACacheEntry: TclDnsCacheEntry); virtual;
    procedure DoGetHandedRecords(AConnection: TclUdpUserConnection; const AName: string; ARecords: TclDnsRecordList); virtual;
    procedure DoDeleteCachedRecords(AConnection: TclUdpUserConnection; const AName: string; ARecordType: Integer); virtual;
    procedure DoAddCachedRecords(AConnection: TclUdpUserConnection; const AName: string; ARecordType: Integer;
      ACacheEntry: TclDnsCacheEntry); virtual;
    procedure DoResolveCachedRecords(AConnection: TclUdpUserConnection; const AName: string; ARecordType: Integer;
      AResponse: TclDnsMessage; var Handled: Boolean); virtual;
    procedure DoReceiveQuery(AConnection: TclUdpUserConnection; AQuery: TclDnsMessage); virtual;

    procedure GetCommands; virtual;

    function CreateDefaultConnection: TclUdpUserConnection; override;
    procedure DoReadPacket(AConnection: TclUdpUserConnection; AData: TStream); override;
    procedure DoDestroy; override;
  public
    constructor Create(AOwner: TComponent); override;

    property Commands: TclDnsCommandList read FCommands;
  published
    property Port default DefaultDnsPort;
    property MaxCacheTTL: Integer read FMaxCacheTTL write FMaxCacheTTL default 800000;
    property MaxRecursiveQueries: Integer read FMaxRecursiveQueries write FMaxRecursiveQueries default 4;
    property UseRecursiveQueries: Boolean read FUseRecursiveQueries write FUseRecursiveQueries default True;
    property UseCaching: Boolean read FUseCaching write FUseCaching default True;
    property RootNameServers: TStrings read FRootNameServers write SetRootNameServers;
    property TimeOut: Integer read FTimeOut write FTimeOut default 1000;

    property OnReceiveQuery: TclDnsQueryEvent read FOnReceiveQuery write FOnReceiveQuery;
    property OnSendResponse: TclDnsResponseEvent read FOnSendResponse write FOnSendResponse;
    property OnGetHandedRecords: TclDnsRecordsEvent read FOnGetHandedRecords write FOnGetHandedRecords;
    property OnGetCachedRecords: TclDnsCacheEvent read FOnGetCachedRecords write FOnGetCachedRecords;
    property OnDeleteCachedRecords: TclDnsDeleteCacheEvent read FOnDeleteCachedRecords write FOnDeleteCachedRecords;
    property OnAddCachedRecords: TclDnsAddCacheEvent read FOnAddCachedRecords write FOnAddCachedRecords;
    property OnResolveCachedRecords: TclDnsResolveRecordsEvent read FOnResolveCachedRecords write FOnResolveCachedRecords;
  end;

implementation

uses
  clDnsQuery, clSocket;

{ TclDnsServer }

procedure TclDnsServer.CheckQuery(AQuery: TclDnsMessage);
begin
  if (AQuery.Queries.Count <> 1) then
  begin
    raise EclDnsServerError.Create(DnsFormatErrorCode);
  end;

  if (AQuery.Queries[0].RecordClass <> rcInternet) then
  begin
    raise EclDnsServerError.Create(DnsFormatErrorCode);
  end;
end;

constructor TclDnsServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  
  FCommands := TclDnsCommandList.Create(Self);
  GetCommands();

  Port := DefaultDnsPort;
  FMaxCacheTTL := 800000;
  FMaxRecursiveQueries := 4;
  FUseRecursiveQueries := True;
  FUseCaching := True;
  FTimeOut := 1000;

  FRootNameServers := TStringList.Create();
  
  FillDefaultRootNameServers();
end;

function TclDnsServer.CreateDefaultConnection: TclUdpUserConnection;
begin
  Result := TclUdpUserConnection.Create();
end;

procedure TclDnsServer.DoAddCachedRecords(AConnection: TclUdpUserConnection; const AName: string; ARecordType: Integer;
  ACacheEntry: TclDnsCacheEntry);
begin
  if Assigned(OnAddCachedRecords) then
  begin
    OnAddCachedRecords(Self, AConnection, AName, ARecordType, ACacheEntry);
  end;
end;

procedure TclDnsServer.DoDeleteCachedRecords(AConnection: TclUdpUserConnection; const AName: string; ARecordType: Integer);
begin
  if Assigned(OnDeleteCachedRecords) then
  begin
    OnDeleteCachedRecords(Self, AConnection, AName, ARecordType);
  end;
end;

procedure TclDnsServer.DoDestroy;
begin
  FRootNameServers.Free();
  FCommands.Free();
  
  inherited DoDestroy();
end;

procedure TclDnsServer.DoGetCachedRecords(AConnection: TclUdpUserConnection; const AName: string; ARecordType: Integer;
  var ACacheEntry: TclDnsCacheEntry);
begin
  if Assigned(OnGetCachedRecords) then
  begin
    OnGetCachedRecords(Self, AConnection, AName, ARecordType, ACacheEntry);
  end;
end;

procedure TclDnsServer.DoGetHandedRecords(AConnection: TclUdpUserConnection; const AName: string; ARecords: TclDnsRecordList);
begin
  if Assigned(OnGetHandedRecords) then
  begin
    OnGetHandedRecords(Self, AConnection, AName, ARecords);
  end;
end;

procedure TclDnsServer.DoReadPacket(AConnection: TclUdpUserConnection; AData: TStream);
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

  inherited DoReadPacket(AConnection, AData);

  HandleCommandData(AConnection, AData);
end;

procedure TclDnsServer.DoReceiveQuery(AConnection: TclUdpUserConnection; AQuery: TclDnsMessage);
begin
  if Assigned(OnReceiveQuery) then
  begin
    OnReceiveQuery(Self, AConnection, AQuery);
  end;
end;

procedure TclDnsServer.DoResolveCachedRecords(AConnection: TclUdpUserConnection; const AName: string; ARecordType: Integer;
  AResponse: TclDnsMessage; var Handled: Boolean);
begin
  if Assigned(OnResolveCachedRecords) then
  begin
    OnResolveCachedRecords(Self, AConnection, AName, ARecordType, AResponse, Handled);
  end;
end;

procedure TclDnsServer.DoSendResponse(AConnection: TclUdpUserConnection; AQuery, AResponse: TclDnsMessage);
begin
  if Assigned(OnSendResponse) then
  begin
    OnSendResponse(Self, AConnection, AQuery, AResponse);
  end;
end;

procedure TclDnsServer.FillDefaultRootNameServers;
begin
  FRootNameServers.Add('A.ROOT-SERVERS.NET');
  FRootNameServers.Add('B.ROOT-SERVERS.NET');
  FRootNameServers.Add('C.ROOT-SERVERS.NET');
  FRootNameServers.Add('D.ROOT-SERVERS.NET');
  FRootNameServers.Add('E.ROOT-SERVERS.NET');
  FRootNameServers.Add('F.ROOT-SERVERS.NET');
  FRootNameServers.Add('G.ROOT-SERVERS.NET');
  FRootNameServers.Add('H.ROOT-SERVERS.NET');
  FRootNameServers.Add('I.ROOT-SERVERS.NET');
  FRootNameServers.Add('J.ROOT-SERVERS.NET');
  FRootNameServers.Add('K.ROOT-SERVERS.NET');
  FRootNameServers.Add('L.ROOT-SERVERS.NET');
  FRootNameServers.Add('M.ROOT-SERVERS.NET');
end;

procedure TclDnsServer.GetCommands;
begin
  Commands.Add(TclDnsACommandInfo.Create());
  Commands.Add(TclDnsAAAACommandInfo.Create());
  Commands.Add(TclDnsNSCommandInfo.Create());
  Commands.Add(TclDnsCNAMECommandInfo.Create());
  Commands.Add(TclDnsSOACommandInfo.Create());
  Commands.Add(TclDnsPTRCommandInfo.Create());
  Commands.Add(TclDnsMXCommandInfo.Create());
  Commands.Add(TclDnsTXTCommandInfo.Create());
end;

procedure TclDnsServer.HandleCommandData(AConnection: TclUdpUserConnection; AData: TStream);
var
  query, response: TclDnsMessage;
  info: TclDnsCommandInfo;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'HandleCommandData');{$ENDIF}
  query := nil;
  response := nil;
  try
    query := TclDnsMessage.Create();
    response := TclDnsMessage.Create();

    try
      AData.Position := 0;
      query.Parse(AData);

      DoReceiveQuery(AConnection, query);

      CheckQuery(query);

      info := Commands.CommandByCode(query.Queries[0].RecordType);

      if (info = nil) then
      begin
        raise EclDnsServerError.Create(DnsNotImplementedCode);
      end;

      InitResponse(AConnection, query, response);

      info.Execute(AConnection, query, response);

      SendResponse(AConnection, query, response);
    except
      on E: EclDnsError do
      begin
        InitResponse(AConnection, query, response);
        response.Header.ResponseCode := E.ErrorCode;
        SendResponse(AConnection, query, response);
      end;
      on E: EclDnsServerError do
      begin
        InitResponse(AConnection, query, response);
        response.Header.ResponseCode := E.ErrorCode;
        SendResponse(AConnection, query, response);
      end;
    end;
  finally
    response.Free();
    query.Free();
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'HandleCommandData'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'HandleCommandData', E); raise; end; end;{$ENDIF}
end;

procedure TclDnsServer.InitResponse(AConnection: TclUdpUserConnection; AQuery, AResponse: TclDnsMessage);
begin
  AResponse.Header.ID := AQuery.Header.ID;
  AResponse.Header.IsQuery := False;
  AResponse.Header.OpCode := AQuery.Header.OpCode;
  AResponse.Header.IsRecursionDesired := AQuery.Header.IsRecursionDesired;
  AResponse.Header.IsRecursionAvailable := UseRecursiveQueries;

  AResponse.Queries.Add(AQuery.Queries[0].Clone());
end;

procedure TclDnsServer.SendResponse(AConnection: TclUdpUserConnection; AQuery, AResponse: TclDnsMessage);
var
  stream: TStream;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'SendResponse');{$ENDIF}
  stream := TMemoryStream.Create();
  try
    AResponse.Build(stream);

    if (stream.Size > DatagramSize) then
    begin
      AResponse.Header.IsTruncated := True;

      stream.Size := 0;
      AResponse.Build(stream);

      stream.Size := DatagramSize;
    end;

    stream.Position := 0;
    AConnection.WriteData(stream);

    DoSendResponse(AConnection, AQuery, AResponse);
  finally
    stream.Free();
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'SendResponse'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'SendResponse', E); raise; end; end;{$ENDIF}
end;

procedure TclDnsServer.SetRootNameServers(const Value: TStrings);
begin
  FRootNameServers.Assign(Value);
end;

{ TclDnsCacheEntry }

function TclDnsCacheEntry.CheckExpired(ARecords: TclDnsRecordList; AMaxCacheTTL: Integer): Boolean;
var
  i: Integer;
begin
  Result := True;

  if ((CreatedOn + AMaxCacheTTL / SecsPerDay) < Now()) then
  begin
    Exit;
  end;

  for i := 0 to ARecords.Count - 1 do
  begin
    if ((CreatedOn + ARecords[i].TTL / SecsPerDay) < Now()) then
    begin
      Exit;
    end;
  end;

  Result := False;
end;

procedure TclDnsCacheEntry.Clear;
begin
  FName := '';
  FRecordType := 0;
  FNameServers.Clear();
  FAnswers.Clear();
  FAdditionalRecords.Clear();
end;

constructor TclDnsCacheEntry.Create;
begin
  inherited Create();

  FNameServers := TclDnsRecordList.Create();
  FAnswers := TclDnsRecordList.Create();
  FAdditionalRecords := TclDnsRecordList.Create();

  FCreatedOn := Now();
end;

destructor TclDnsCacheEntry.Destroy;
begin
  FAdditionalRecords.Free();
  FAnswers.Free();
  FNameServers.Free();

  inherited Destroy();
end;

function TclDnsCacheEntry.IsExpired(AMaxCacheTTL: Integer): Boolean;
begin
  Result := CheckExpired(Answers, AMaxCacheTTL) or CheckExpired(NameServers, AMaxCacheTTL)
    or CheckExpired(AdditionalRecords, AMaxCacheTTL);
end;

procedure TclDnsCacheEntry.Load(ACachedResponse: TclDnsMessage);
begin
  Clear();

  if (ACachedResponse.Queries.Count = 1) then
  begin
    FName := ACachedResponse.Queries[0].Name;
    FRecordType := ACachedResponse.Queries[0].RecordType;
  end;

  FAnswers.Assign(ACachedResponse.Answers);
  FNameServers.Assign(ACachedResponse.NameServers);
  FAdditionalRecords.Assign(ACachedResponse.AdditionalRecords);
end;

{ TclDnsCommandList }

procedure TclDnsCommandList.Add(ACommand: TclDnsCommandInfo);
begin
  FList.Add(ACommand);
  ACommand.FServer := FServer;
end;

procedure TclDnsCommandList.Clear;
begin
  FList.Clear();
end;

function TclDnsCommandList.CommandByCode(ACode: Integer): TclDnsCommandInfo;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if (Result.Code = ACode) then Exit;
  end;
  Result := nil;
end;

constructor TclDnsCommandList.Create(AServer: TclDnsServer);
begin
  inherited Create();
  FServer := AServer;
  FList := TObjectList.Create(True);
end;

procedure TclDnsCommandList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TclDnsCommandList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function TclDnsCommandList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclDnsCommandList.GetItem(Index: Integer): TclDnsCommandInfo;
begin
  Result := TclDnsCommandInfo(FList[Index]);
end;

{ TclDnsCommandInfo }

procedure TclDnsCommandInfo.AddARecord(const AName: string; ARecords: TclDnsRecordList; AResponse: TclDnsMessage);
var
  i: Integer;
  rec: TclDnsRecord;
begin
  for i := 0 to ARecords.Count - 1 do
  begin
    rec := ARecords[i];
    if ((DnsRecordTypes[rtARecord] = rec.RecordType) and SameText(rec.Name, AName)) then
    begin
      AResponse.AdditionalRecords.Add(rec.Clone());
      Exit;
    end;
  end;
end;

procedure TclDnsCommandInfo.ClearResponseRecords(AResponse: TclDnsMessage);
begin
  AResponse.Answers.Clear();
  AResponse.NameServers.Clear();
  AResponse.AdditionalRecords.Clear();
end;

constructor TclDnsCommandInfo.Create(ACode: Integer);
begin
  inherited Create();
  FCode := ACode;
end;

procedure TclDnsCommandInfo.Execute(AConnection: TclUdpUserConnection; AQuery, AResponse: TclDnsMessage);
var
  handled: Boolean;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Execute');{$ENDIF}
  handled := SearchHandedZone(AConnection, AQuery.Queries[0].Name, AResponse);
  if (not handled) then
  begin
    handled := SearchCachedZone(AConnection, AQuery, AResponse);
  end;

  if (not handled) then
  begin
    ClearResponseRecords(AResponse);
    raise EclDnsServerError.Create(DnsNameErrorCode);
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Execute'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Execute', E); raise; end; end;{$ENDIF}
end;

procedure TclDnsCommandInfo.FillCachedResponse(ACacheEntry: TclDnsCacheEntry; AResponse: TclDnsMessage);
begin
  AResponse.Answers.Assign(ACacheEntry.Answers);
  AResponse.NameServers.Assign(ACacheEntry.NameServers);
  AResponse.AdditionalRecords.Assign(ACacheEntry.AdditionalRecords);
end;

function TclDnsCommandInfo.ResolveCachedZone(AConnection: TclUdpUserConnection; AQuery: TclDnsMessage): TclDnsMessage;
var
  handled: Boolean;
  client: TclDnsQuery;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'ResolveCachedZone');{$ENDIF}
  Result := nil;

  if (not Server.UseRecursiveQueries) then
  begin
    Exit;
  end;

  Result := TclDnsMessage.Create();
  try
    handled := False;
    Server.DoResolveCachedRecords(AConnection, AQuery.Queries[0].Name, AQuery.Queries[0].RecordType, Result, handled);
    if (handled) then
    begin
      Exit;
    end;

    client := TclDnsQuery.Create(nil);
    try
      client.RootNameServers := Server.RootNameServers;
      client.UseRecursiveQueries := True;
      client.AutodetectServer := False;
      client.MaxRecursiveQueries := Server.MaxRecursiveQueries;
      client.TimeOut := Server.TimeOut;

      try
        client.Resolve(AQuery, Result);
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ResolveCachedZone - record resolved');{$ENDIF}
      except
        on EclSocketError do
        begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ResolveCachedZone - resolve error, next rootname attempt');{$ENDIF}
        end;
      end;
    finally
      client.Free();
    end;
  except
    Result.Free();
    raise;
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'ResolveCachedZone'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'ResolveCachedZone', E); raise; end; end;{$ENDIF}
end;

function TclDnsCommandInfo.SearchCachedZone(AConnection: TclUdpUserConnection; AQuery, AResponse: TclDnsMessage): Boolean;
var
  queryName: string;
  recordType: Integer;
  cacheEntry: TclDnsCacheEntry;
  cachedResponse: TclDnsMessage;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'SearchCachedZone');{$ENDIF}
  queryName := AQuery.Queries[0].Name;
  recordType := AQuery.Queries[0].RecordType;

  AResponse.Header.IsAuthoritativeAnswer := False;

  if (not Server.UseCaching) then
  begin
    Result := False;
    Exit;
  end;

  ClearResponseRecords(AResponse);

  cacheEntry := nil;
  cachedResponse := nil;
  try
    Server.DoGetCachedRecords(AConnection, queryName, recordType, cacheEntry);

    if (cacheEntry <> nil) then
    begin
      if (cacheEntry.IsExpired(Server.MaxCacheTTL)) then
      begin
        Server.DoDeleteCachedRecords(AConnection, queryName, recordType);
        cacheEntry.Free();
        cacheEntry := nil;
      end;
    end;

    if (cacheEntry = nil) then
    begin
      cachedResponse := ResolveCachedZone(AConnection, AQuery);

      if ((cachedResponse.Answers.Count > 0) or (cachedResponse.NameServers.Count > 0)) then
      begin
        cacheEntry := TclDnsCacheEntry.Create();
        cacheEntry.Load(cachedResponse);
        cacheEntry.Name := queryName;
        cacheEntry.RecordType := recordType;

        Server.DoAddCachedRecords(AConnection, queryName, recordType, cacheEntry);
      end;
    end;

    Result := (cacheEntry <> nil);
    if Result then
    begin
      FillCachedResponse(cacheEntry, AResponse);
    end;
  finally
    cachedResponse.Free();
    cacheEntry.Free();
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'SearchCachedZone'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'SearchCachedZone', E); raise; end; end;{$ENDIF}
end;

function TclDnsCommandInfo.SearchHandedZone(AConnection: TclUdpUserConnection;
  const AQueryName: string; AResponse: TclDnsMessage): Boolean;
var
  i, ind: Integer;
  name: string;
  records: TclDnsRecordList;
  rec, soaRec: TclDnsRecord;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'SearchHandedZone');{$ENDIF}
  ClearResponseRecords(AResponse);

  records := TclDnsRecordList.Create();
  try
    Result := False;
    name := AQueryName;
    repeat
      records.Clear();
      
      Server.DoGetHandedRecords(AConnection, name, records);

      if (records.Count > 0) then
      begin
        soaRec := records.ItemByType(DnsRecordTypes[rtSOARecord]);

        AResponse.Header.IsAuthoritativeAnswer := (soaRec <> nil);

        if (soaRec <> nil) then
        begin
          for i := 0 to records.Count - 1 do
          begin
            rec := records[i];

            if SameText(rec.Name, AQueryName) then
            begin
              if (rec.RecordType = Code) then
              begin
                AResponse.Answers.Add(rec.Clone());
                Result := True;
              end else
              if (rec is TclDnsCNAMERecord) then
              begin
                Result := SearchHandedZone(AConnection, TclDnsCNAMERecord(rec).PrimaryName, AResponse);

                if (AResponse.Answers.Count > 0) then
                begin
                  AResponse.Answers.Insert(0, rec.Clone());
                end;

                Exit;
              end;
            end;
          end;

          if (Result) then
          begin
            FillAdditionalRecords(records, AResponse);
          end else
          begin
            AResponse.NameServers.Add(soaRec.Clone());
          end;
        end else
        begin
          for i := 0 to records.Count - 1 do
          begin
            rec := records[i];
            if (rec is TclDnsNSRecord) then
            begin
              AResponse.NameServers.Add(rec.Clone());
              AddARecord(TclDnsNSRecord(rec).NameServer, records, AResponse);
            end;
          end;
        end;

        Result := (AResponse.Answers.Count > 0) or (AResponse.NameServers.Count > 0);
        Break;
      end;

      ind := Pos('.', name);
      if (ind > 0) then
      begin
        Delete(name, 1, ind);
      end else
      begin
        name := '';
      end;
    until (name = '');
  finally
    records.Free();
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'SearchHandedZone'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'SearchHandedZone', E); raise; end; end;{$ENDIF}
end;

{ EclDnsServerError }

constructor EclDnsServerError.Create(AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(EclDnsError.GetMessageText(AErrorCode), AErrorCode);
end;

constructor EclDnsServerError.Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorMsg, AErrorCode);
end;

{ TclDnsACommandInfo }

constructor TclDnsACommandInfo.Create;
begin
  inherited Create(DnsRecordTypes[rtARecord]);
end;

procedure TclDnsACommandInfo.FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage);
var
  i: Integer;
  rec: TclDnsRecord;
begin
  for i := 0 to ARecords.Count - 1 do
  begin
    rec := ARecords[i];
    if (rec is TclDnsNSRecord) then
    begin
      AResponse.NameServers.Add(rec.Clone());
      AddARecord(TclDnsNSRecord(rec).NameServer, ARecords, AResponse);
    end;
  end;
end;

{ TclDnsNSCommandInfo }

constructor TclDnsNSCommandInfo.Create;
begin
  inherited Create(DnsRecordTypes[rtNSRecord]);
end;

procedure TclDnsNSCommandInfo.FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage);
var
  i: Integer;
  rec: TclDnsRecord;
begin
  for i := 0 to ARecords.Count - 1 do
  begin
    rec := ARecords[i];
    if (rec is TclDnsNSRecord) then
    begin
      AddARecord(TclDnsNSRecord(rec).NameServer, ARecords, AResponse);
    end;
  end;
end;

{ TclDnsCNAMECommandInfo }

constructor TclDnsCNAMECommandInfo.Create;
begin
  inherited Create(DnsRecordTypes[rtCNAMERecord]);
end;

procedure TclDnsCNAMECommandInfo.FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage);
var
  i, j: Integer;
  primaryName: string;
  rec, respRec: TclDnsRecord;
begin
  for i := 0 to AResponse.Answers.Count - 1 do
  begin
    respRec := AResponse.Answers[i];

    if (respRec is TclDnsCNAMERecord) then
    begin
      primaryName := TclDnsCNAMERecord(respRec).PrimaryName;

      if (ARecords.ItemByName(primaryName) <> nil) then
      begin
        for j := 0 to ARecords.Count - 1 do
        begin
          rec := ARecords[j];
          if (rec is TclDnsNSRecord) then
          begin
            AResponse.NameServers.Add(rec.Clone());
            AddARecord(TclDnsNSRecord(rec).NameServer, ARecords, AResponse);
          end;
        end;
      end;
    end;
  end;
end;

{ TclDnsSOACommandInfo }

constructor TclDnsSOACommandInfo.Create;
begin
  inherited Create(DnsRecordTypes[rtSOARecord]);
end;

procedure TclDnsSOACommandInfo.FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage);
var
  soaRec: TclDnsRecord;
begin
  soaRec := AResponse.Answers.ItemByType(DnsRecordTypes[rtSOARecord]);
  if (soaRec <> nil) then
  begin
    AddARecord(TclDnsSOARecord(soaRec).PrimaryNameServer, ARecords, AResponse);
  end;
end;

{ TclDnsPTRCommandInfo }

constructor TclDnsPTRCommandInfo.Create;
begin
  inherited Create(DnsRecordTypes[rtPTRRecord]);
end;

procedure TclDnsPTRCommandInfo.FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage);
var
  i: Integer;
  rec: TclDnsRecord;
begin
  for i := 0 to ARecords.Count - 1 do
  begin
    rec := ARecords[i];

    if (rec is TclDnsNSRecord) then
    begin
      AResponse.NameServers.Add(rec.Clone());
      AddARecord(TclDnsNSRecord(rec).NameServer, ARecords, AResponse);
    end;
  end;
end;

{ TclDnsMXCommandInfo }

constructor TclDnsMXCommandInfo.Create;
begin
  inherited Create(DnsRecordTypes[rtMXRecord]);
end;

procedure TclDnsMXCommandInfo.FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage);
var
  i: Integer;
  rec: TclDnsRecord;
begin
  for i := 0 to AResponse.Answers.Count - 1 do
  begin
    rec := AResponse.Answers[i];
    if (rec is TclDnsMXRecord) then
    begin
      AddARecord(TclDnsMXRecord(rec).MailServer, ARecords, AResponse);
    end;
  end;

  for i := 0 to ARecords.Count - 1 do
  begin
    rec := ARecords[i];

    if (rec is TclDnsNSRecord) then
    begin
      AResponse.NameServers.Add(rec.Clone());
      AddARecord(TclDnsNSRecord(rec).NameServer, ARecords, AResponse);
    end;
  end;
end;

{ TclDnsTXTCommandInfo }

constructor TclDnsTXTCommandInfo.Create;
begin
  inherited Create(DnsRecordTypes[rtTXTRecord]);
end;

procedure TclDnsTXTCommandInfo.FillAdditionalRecords(ARecords: TclDnsRecordList; AResponse: TclDnsMessage);
var
  i: Integer;
  rec: TclDnsRecord;
begin
  for i := 0 to ARecords.Count - 1 do
  begin
    rec := ARecords[i];

    if (rec is TclDnsNSRecord) then
    begin
      AResponse.NameServers.Add(rec.Clone());
      AddARecord(TclDnsNSRecord(rec).NameServer, ARecords, AResponse);
    end;
  end;
end;

{ TclDnsAAAACommandInfo }

constructor TclDnsAAAACommandInfo.Create;
begin
  inherited Create(DnsRecordTypes[rtAAAARecord]);
end;

procedure TclDnsAAAACommandInfo.FillAdditionalRecords(
  ARecords: TclDnsRecordList; AResponse: TclDnsMessage);
var
  i: Integer;
  rec: TclDnsRecord;
begin
  for i := 0 to ARecords.Count - 1 do
  begin
    rec := ARecords[i];
    if (rec is TclDnsNSRecord) then
    begin
      AResponse.NameServers.Add(rec.Clone());
      AddARecord(TclDnsNSRecord(rec).NameServer, ARecords, AResponse);
    end;
  end;
end;

end.
