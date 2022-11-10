{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clDnsFileHandler;

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
  Classes, SysUtils, SyncObjs, Windows,
{$ELSE}
  System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows,
{$ENDIF}
  clUdpServer, clDnsServer, clDnsMessage;

type
  TclDnsRecordPersister = class
  protected
    function CreateRecord: TclDnsRecord; virtual; abstract;
  public
    function LoadRecord(AParameters: TStrings): TclDnsRecord; virtual;
    procedure SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings); virtual;
  end;

  TclDnsARecordPersister = class(TclDnsRecordPersister)
  protected
    function CreateRecord: TclDnsRecord; override;
  public
    function LoadRecord(AParameters: TStrings): TclDnsRecord; override;
    procedure SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings); override;
  end;

  TclDnsAAAARecordPersister = class(TclDnsRecordPersister)
  protected
    function CreateRecord: TclDnsRecord; override;
  public
    function LoadRecord(AParameters: TStrings): TclDnsRecord; override;
    procedure SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings); override;
  end;

  TclDnsNSRecordPersister = class(TclDnsRecordPersister)
  protected
    function CreateRecord: TclDnsRecord; override;
  public
    function LoadRecord(AParameters: TStrings): TclDnsRecord; override;
    procedure SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings); override;
  end;

  TclDnsCNAMERecordPersister = class(TclDnsRecordPersister)
  protected
    function CreateRecord: TclDnsRecord; override;
  public
    function LoadRecord(AParameters: TStrings): TclDnsRecord; override;
    procedure SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings); override;
  end;

  TclDnsSOARecordPersister = class(TclDnsRecordPersister)
  protected
    function CreateRecord: TclDnsRecord; override;
  public
    function LoadRecord(AParameters: TStrings): TclDnsRecord; override;
    procedure SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings); override;
  end;

  TclDnsPTRRecordPersister = class(TclDnsRecordPersister)
  protected
    function CreateRecord: TclDnsRecord; override;
  public
    function LoadRecord(AParameters: TStrings): TclDnsRecord; override;
    procedure SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings); override;
  end;

  TclDnsMXRecordPersister = class(TclDnsRecordPersister)
  protected
    function CreateRecord: TclDnsRecord; override;
  public
    function LoadRecord(AParameters: TStrings): TclDnsRecord; override;
    procedure SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings); override;
  end;

  TclDnsTXTRecordPersister = class(TclDnsRecordPersister)
  protected
    function CreateRecord: TclDnsRecord; override;
  public
    function LoadRecord(AParameters: TStrings): TclDnsRecord; override;
    procedure SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings); override;
  end;

  TclDnsRecordPersisterFactory = class
  protected
    function CreatePersister(ARecType: Integer): TclDnsRecordPersister; overload; virtual;
    function CreatePersister(ARecord: TclDnsRecord): TclDnsRecordPersister; overload; virtual;
  public
    function LoadRecord(const ASource: string): TclDnsRecord;
    function SaveRecord(ARecord: TclDnsRecord): string;
  end;

  TclDnsCachePersister = class
  private
    procedure LoadRecords(ARecords: TclDnsRecordList; ASource: TStrings; var AIndex: Integer);
    procedure SaveRecords(ARecords: TclDnsRecordList; ADestination: TStrings);
  public
    function Load(ASource: TStrings): TclDnsCacheEntry; virtual;
    procedure Save(ACache: TclDnsCacheEntry; ADestination: TStrings); virtual;
  end;

  TclDnsFileHandler = class;

  TclDnsZoneManager = class
  private
    FZonePath: string;
    FRecords: TclDnsRecordList;
    FOwnRecords: TclDnsRecordList;

    function GetRecords: TclDnsRecordList;
  public
    constructor Create; overload;
    constructor Create(ARecords: TclDnsRecordList); overload;
    destructor Destroy; override;

    class function GetZoneFileName(const AZoneName: string): string;
    class function GetZoneName(const AFileName: string): string;

    procedure Load(const AZoneName: string);
    procedure LoadFromFile(const AFileName: string);
    procedure Save(const AZoneName: string);
    procedure SaveToFile(const AFileName: string);
    procedure ListZones(AZoneNames: TStrings);

    property ZonePath: string read FZonePath write FZonePath;
    property Records: TclDnsRecordList read GetRecords;
  end;

  TclDnsFileHandler = class(TComponent)
  private
    FServer: TclDnsServer;
    FAccessor: TCriticalSection;
    FHandedZonesPath: string;
    FCachedZonesPath: string;
    FZoneManager: TclDnsZoneManager;

    procedure SetServer(const Value: TclDnsServer);
    procedure SetHandedZonesPath(const Value: string);
    procedure SetCachedZonesPath(const Value: string);

    procedure DoGetHandedRecords(Sender: TObject; AConnection: TclUdpUserConnection; const AName: string;
      ARecords: TclDnsRecordList);
    procedure DoGetCachedRecords(Sender: TObject; AConnection: TclUdpUserConnection; const AName: string;
      ARecordType: Integer; var ACacheEntry: TclDnsCacheEntry);
    procedure DoAddCachedRecords(Sender: TObject; AConnection: TclUdpUserConnection; const AName: string;
      ARecordType: Integer; ACacheEntry: TclDnsCacheEntry);
    procedure DoDeleteCachedRecords(Sender: TObject; AConnection: TclUdpUserConnection; const AName: string;
      ARecordType: Integer);

    function EncodeCacheFileName(const AName: string; ARecordType: Integer): string;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CleanEventHandlers; virtual;
    procedure InitEventHandlers; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property ZoneManager: TclDnsZoneManager read FZoneManager;
  published
    property Server: TclDnsServer read FServer write SetServer;
    property HandedZonesPath: string read FHandedZonesPath write SetHandedZonesPath;
    property CachedZonesPath: string read FCachedZonesPath write SetCachedZonesPath;
  end;

const
  cDnzZoneFileExt = '.txt';
  
implementation

uses
  clUtils;

{ TclDnsFileHandler }

procedure TclDnsFileHandler.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) then Exit;
  if (AComponent = FServer) then
  begin
    CleanEventHandlers();
    FServer := nil;
  end;
end;

procedure TclDnsFileHandler.SetCachedZonesPath(const Value: string);
begin
  FAccessor.Enter();
  try
    FCachedZonesPath := Value;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclDnsFileHandler.SetHandedZonesPath(const Value: string);
begin
  FAccessor.Enter();
  try
    FHandedZonesPath := Value;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclDnsFileHandler.SetServer(const Value: TclDnsServer);
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

procedure TclDnsFileHandler.CleanEventHandlers;
begin
  Server.OnGetHandedRecords := nil;
  Server.OnGetCachedRecords := nil;
  Server.OnAddCachedRecords := nil;
  Server.OnDeleteCachedRecords := nil;
end;

constructor TclDnsFileHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FZoneManager := TclDnsZoneManager.Create();

  FAccessor := TCriticalSection.Create();
  FHandedZonesPath := 'Handed';
  FCachedZonesPath := 'Cached';
end;

destructor TclDnsFileHandler.Destroy;
begin
  FAccessor.Free();
  FZoneManager.Free();
  
  inherited Destroy();
end;

procedure TclDnsFileHandler.DoAddCachedRecords(Sender: TObject; AConnection: TclUdpUserConnection; const AName: string;
  ARecordType: Integer; ACacheEntry: TclDnsCacheEntry);
var
  fileName: string;
  data: TStrings;
  persister: TclDnsCachePersister;
begin
  FAccessor.Enter();
  try
    fileName := AddTrailingBackSlash(CachedZonesPath) + EncodeCacheFileName(AName, ARecordType);

    if not ForceFileDirectories(AddTrailingBackSlash(CachedZonesPath)) then
    begin
      raise EclDnsServerError.Create(DnsServerFailureCode);
    end;

    data := nil;
    persister := nil;
    try
      data := TStringList.Create();

      persister := TclDnsCachePersister.Create();
      persister.Save(ACacheEntry, data);

      TclStringsUtils.SaveStrings(data, fileName, '');
    finally
      persister.Free();
      data.Free();
    end;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclDnsFileHandler.DoDeleteCachedRecords(Sender: TObject; AConnection: TclUdpUserConnection; const AName: string;
  ARecordType: Integer);
var
  fileName: string;
begin
  FAccessor.Enter();
  try
    fileName := AddTrailingBackSlash(CachedZonesPath) + EncodeCacheFileName(AName, ARecordType);
    if (FileExists(fileName)) then
    begin
      DeleteFile(PChar(fileName));
    end;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclDnsFileHandler.DoGetCachedRecords(Sender: TObject; AConnection: TclUdpUserConnection; const AName: string;
  ARecordType: Integer; var ACacheEntry: TclDnsCacheEntry);
var
  fileName: string;
  data: TStrings;
  persister: TclDnsCachePersister;
begin
  FAccessor.Enter();
  try
    fileName := AddTrailingBackSlash(CachedZonesPath) + EncodeCacheFileName(AName, ARecordType);

    if (FileExists(fileName)) then
    begin
      data := nil;
      persister := nil;
      try
        data := TStringList.Create();

        TclStringsUtils.LoadStrings(fileName, data, '');

        persister := TclDnsCachePersister.Create();
        ACacheEntry := persister.Load(data);
      finally
        persister.Free();
        data.Free();
      end;

      if (ACacheEntry <> nil) then
      begin
        ACacheEntry.CreatedOn := GetLocalFileTime(fileName);
      end;
    end;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclDnsFileHandler.DoGetHandedRecords(Sender: TObject; AConnection: TclUdpUserConnection; const AName: string;
  ARecords: TclDnsRecordList);
var
  zoneManager: TclDnsZoneManager;
begin
  zoneManager := TclDnsZoneManager.Create(ARecords);
  try
    zoneManager.ZonePath := HandedZonesPath;

    FAccessor.Enter();
    try
      zoneManager.Load(AName);
    finally
      FAccessor.Leave();
    end;
  finally
    zoneManager.Free();
  end;
end;

function TclDnsFileHandler.EncodeCacheFileName(const AName: string; ARecordType: Integer): string;
begin
  Result := GetRecordTypeStr(ARecordType) + '_' + TclDnsZoneManager.GetZoneFileName(AName);
end;

procedure TclDnsFileHandler.InitEventHandlers;
begin
  Server.OnGetHandedRecords := DoGetHandedRecords;
  Server.OnGetCachedRecords := DoGetCachedRecords;
  Server.OnAddCachedRecords := DoAddCachedRecords;
  Server.OnDeleteCachedRecords := DoDeleteCachedRecords;
end;

{ TclDnsRecordPersister }

function TclDnsRecordPersister.LoadRecord(AParameters: TStrings): TclDnsRecord;
begin
  Result := CreateRecord();
  try
    Result.Name := AParameters[0];
    Result.TTL := DWORD(StrToInt64Def(AParameters[2], 0));
  except
    Result.Free();
    raise;
  end;
end;

procedure TclDnsRecordPersister.SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings);
begin
  ADestination.Add(ARecord.Name);
  ADestination.Add(GetRecordTypeStr(ARecord.RecordType));
  ADestination.Add(IntToStr(ARecord.TTL));
end;

{ TclDnsARecordPersister }

function TclDnsARecordPersister.CreateRecord: TclDnsRecord;
begin
  Result := TclDnsARecord.Create();
end;

function TclDnsARecordPersister.LoadRecord(AParameters: TStrings): TclDnsRecord;
begin
  if (AParameters.Count < 4) then
  begin
    raise EclDnsServerError.Create(DnsServerFailureCode);
  end;

  Result := inherited LoadRecord(AParameters);
  TclDnsARecord(Result).IPAddress := AParameters[3];
end;

procedure TclDnsARecordPersister.SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings);
begin
  inherited SaveRecord(ARecord, ADestination);

  ADestination.Add(TclDnsARecord(ARecord).IPAddress);
end;

{ TclDnsNSRecordPersister }

function TclDnsNSRecordPersister.CreateRecord: TclDnsRecord;
begin
  Result := TclDnsNSRecord.Create();
end;

function TclDnsNSRecordPersister.LoadRecord(AParameters: TStrings): TclDnsRecord;
begin
  if (AParameters.Count < 4) then
  begin
    raise EclDnsServerError.Create(DnsServerFailureCode);
  end;

  Result := inherited LoadRecord(AParameters);
  TclDnsNSRecord(Result).NameServer := AParameters[3];
end;

procedure TclDnsNSRecordPersister.SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings);
begin
  inherited SaveRecord(ARecord, ADestination);

  ADestination.Add(TclDnsNSRecord(ARecord).NameServer);
end;

{ TclDnsCNAMERecordPersister }

function TclDnsCNAMERecordPersister.CreateRecord: TclDnsRecord;
begin
  Result := TclDnsCNAMERecord.Create();
end;

function TclDnsCNAMERecordPersister.LoadRecord(AParameters: TStrings): TclDnsRecord;
begin
  if (AParameters.Count < 4) then
  begin
    raise EclDnsServerError.Create(DnsServerFailureCode);
  end;

  Result := inherited LoadRecord(AParameters);
  TclDnsCNAMERecord(Result).PrimaryName := AParameters[3];
end;

procedure TclDnsCNAMERecordPersister.SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings);
begin
  inherited SaveRecord(ARecord, ADestination);

  ADestination.Add(TclDnsCNAMERecord(ARecord).PrimaryName);
end;

{ TclDnsSOARecordPersister }

function TclDnsSOARecordPersister.CreateRecord: TclDnsRecord;
begin
  Result := TclDnsSOARecord.Create();
end;

function TclDnsSOARecordPersister.LoadRecord(AParameters: TStrings): TclDnsRecord;
var
  res: TclDnsSOARecord;
begin
  if (AParameters.Count < 10) then
  begin
    raise EclDnsServerError.Create(DnsServerFailureCode);
  end;

  Result := inherited LoadRecord(AParameters);
  res := TclDnsSOARecord(Result);
  res.PrimaryNameServer := AParameters[3];
  res.ResponsibleMailbox := AParameters[4];
  res.SerialNumber := StrToInt64Def(AParameters[5], 0);
  res.RefreshInterval := StrToInt64Def(AParameters[6], 0);
  res.RetryInterval := StrToInt64Def(AParameters[7], 0);
  res.ExpirationLimit := StrToInt64Def(AParameters[8], 0);
  res.MinimumTTL := StrToInt64Def(AParameters[9], 0);
end;

procedure TclDnsSOARecordPersister.SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings);
var
  soaRec: TclDnsSOARecord;
begin
  inherited SaveRecord(ARecord, ADestination);

  soaRec := TclDnsSOARecord(ARecord);

  ADestination.Add(soaRec.PrimaryNameServer);
  ADestination.Add(soaRec.ResponsibleMailbox);
  ADestination.Add(IntToStr(soaRec.SerialNumber));
  ADestination.Add(IntToStr(soaRec.RefreshInterval));
  ADestination.Add(IntToStr(soaRec.RetryInterval));
  ADestination.Add(IntToStr(soaRec.ExpirationLimit));
  ADestination.Add(IntToStr(soaRec.MinimumTTL));
end;

{ TclDnsPTRRecordPersister }

function TclDnsPTRRecordPersister.CreateRecord: TclDnsRecord;
begin
  Result := TclDnsPTRRecord.Create();
end;

function TclDnsPTRRecordPersister.LoadRecord(AParameters: TStrings): TclDnsRecord;
begin
  if (AParameters.Count < 4) then
  begin
    raise EclDnsServerError.Create(DnsServerFailureCode);
  end;

  Result := inherited LoadRecord(AParameters);
  TclDnsPTRRecord(Result).DomainName := AParameters[3];
end;

procedure TclDnsPTRRecordPersister.SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings);
begin
  inherited SaveRecord(ARecord, ADestination);

  ADestination.Add(TclDnsPTRRecord(ARecord).DomainName);
end;

{ TclDnsMXRecordPersister }

function TclDnsMXRecordPersister.CreateRecord: TclDnsRecord;
begin
  Result := TclDnsMXRecord.Create();
end;

function TclDnsMXRecordPersister.LoadRecord(AParameters: TStrings): TclDnsRecord;
var
  res: TclDnsMXRecord;
begin
  if (AParameters.Count < 5) then
  begin
    raise EclDnsServerError.Create(DnsServerFailureCode);
  end;

  Result := inherited LoadRecord(AParameters);
  res := TclDnsMXRecord(Result);
  res.Preference := StrToIntDef(AParameters[3], 1);
  res.MailServer := AParameters[4];
end;

procedure TclDnsMXRecordPersister.SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings);
var
  mxRec: TclDnsMXRecord;
begin
  inherited SaveRecord(ARecord, ADestination);

  mxRec := TclDnsMXRecord(ARecord);
  ADestination.Add(IntToStr(mxRec.Preference));
  ADestination.Add(mxRec.MailServer);
end;

{ TclDnsTXTRecordPersister }

function TclDnsTXTRecordPersister.CreateRecord: TclDnsRecord;
begin
  Result := TclDnsTXTRecord.Create();
end;

function TclDnsTXTRecordPersister.LoadRecord(AParameters: TStrings): TclDnsRecord;
begin
  if (AParameters.Count < 4) then
  begin
    raise EclDnsServerError.Create(DnsServerFailureCode);
  end;

  Result := inherited LoadRecord(AParameters);
  TclDnsTXTRecord(Result).Text := AParameters[3];
end;

procedure TclDnsTXTRecordPersister.SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings);
begin
  inherited SaveRecord(ARecord, ADestination);

  ADestination.Add(TclDnsTXTRecord(ARecord).Text);
end;

{ TclDnsRecordPersisterFactory }

function TclDnsRecordPersisterFactory.CreatePersister(ARecType: Integer): TclDnsRecordPersister;
begin
  if (DnsRecordTypes[rtARecord] = ARecType) then
  begin
    Result := TclDnsARecordPersister.Create();
  end else
  if (DnsRecordTypes[rtNSRecord] = ARecType) then
  begin
    Result := TclDnsNSRecordPersister.Create();
  end else
  if (DnsRecordTypes[rtCNAMERecord] = ARecType) then
  begin
    Result := TclDnsCNAMERecordPersister.Create();
  end else
  if (DnsRecordTypes[rtSOARecord] = ARecType) then
  begin
    Result := TclDnsSOARecordPersister.Create();
  end else
  if (DnsRecordTypes[rtPTRRecord] = ARecType) then
  begin
    Result := TclDnsPTRRecordPersister.Create();
  end else
  if (DnsRecordTypes[rtMXRecord] = ARecType) then
  begin
    Result := TclDnsMXRecordPersister.Create();
  end else
  if (DnsRecordTypes[rtTXTRecord] = ARecType) then
  begin
    Result := TclDnsTXTRecordPersister.Create();
  end else
  if (DnsRecordTypes[rtAAAARecord] = ARecType) then
  begin
    Result := TclDnsAAAARecordPersister.Create();
  end else
  begin
    raise EclDnsServerError.Create(DnsServerFailureCode);
  end;
end;

function TclDnsRecordPersisterFactory.CreatePersister(ARecord: TclDnsRecord): TclDnsRecordPersister;
begin
  if (ARecord is TclDnsARecord) then
  begin
    Result := TclDnsARecordPersister.Create();
  end else
  if (ARecord is TclDnsNSRecord) then
  begin
    Result := TclDnsNSRecordPersister.Create();
  end else
  if (ARecord is TclDnsCNAMERecord) then
  begin
    Result := TclDnsCNAMERecordPersister.Create();
  end else
  if (ARecord is TclDnsSOARecord) then
  begin
    Result := TclDnsSOARecordPersister.Create();
  end else
  if (ARecord is TclDnsPTRRecord) then
  begin
    Result := TclDnsPTRRecordPersister.Create();
  end else
  if (ARecord is TclDnsMXRecord) then
  begin
    Result := TclDnsMXRecordPersister.Create();
  end else
  if (ARecord is TclDnsTXTRecord) then
  begin
    Result := TclDnsTXTRecordPersister.Create();
  end else
  if (ARecord is TclDnsAAAARecord) then
  begin
    Result := TclDnsAAAARecordPersister.Create();
  end else
  begin
    raise EclDnsServerError.Create(DnsServerFailureCode);
  end;
end;

function TclDnsRecordPersisterFactory.LoadRecord(const ASource: string): TclDnsRecord;
var
  parameters: TStrings;
  persister: TclDnsRecordPersister;
begin
  Result := nil;//TODO in newer versions of Delphi causes compilation hint, add conditional define.
  parameters := nil;
  persister := nil;
  try
    parameters := TStringList.Create();
    ExtractQuotedWords(ASource, parameters);
    
    if (parameters.Count < 3) then
    begin
      raise EclDnsServerError.Create(DnsServerFailureCode);
    end;

    persister := CreatePersister(GetRecordTypeInt(UpperCase(parameters[1])));
    Result := persister.LoadRecord(parameters);
  finally
    persister.Free();
    parameters.Free();
  end;
end;

function TclDnsRecordPersisterFactory.SaveRecord(ARecord: TclDnsRecord): string;
var
  list: TStrings;
  persister: TclDnsRecordPersister;
begin
  persister := nil;
  list := nil;
  try
    persister := CreatePersister(ARecord);
    list := TStringList.Create();
    
    persister.SaveRecord(ARecord, list);

    Result := GetQuotedWordsString(list);
  finally
    list.Free();
    persister.Free();
  end;
end;

{ TclDnsCachePersister }

function TclDnsCachePersister.Load(ASource: TStrings): TclDnsCacheEntry;
var
  index: Integer;
begin
  if (ASource.Count < 2) then
  begin
    raise EclDnsServerError.Create(DnsServerFailureCode);
  end;

  Result := TclDnsCacheEntry.Create();
  try
    index := 0;
    Result.RecordType := GetRecordTypeInt(ASource[index]);
    Inc(index);

    Result.Name := ASource[index];
    Inc(index);

    LoadRecords(Result.Answers, ASource, index);
    LoadRecords(Result.NameServers, ASource, index);
    LoadRecords(Result.AdditionalRecords, ASource, index);
  except
    Result.Free();
    raise;
  end;
end;

procedure TclDnsCachePersister.LoadRecords(ARecords: TclDnsRecordList; ASource: TStrings; var AIndex: Integer);
var
  count: Integer;
  factory: TclDnsRecordPersisterFactory;
  rec: TclDnsRecord;
begin
  if (AIndex >= ASource.Count) then
  begin
    raise EclDnsServerError.Create(DnsServerFailureCode);
  end;

  count := StrToIntDef(ASource[AIndex], 0);
  Inc(AIndex);

  if ((AIndex + count) > ASource.Count) then
  begin
    raise EclDnsServerError.Create(DnsServerFailureCode);
  end;

  factory := TclDnsRecordPersisterFactory.Create();
  try
    while (count > 0) do
    begin
      rec := factory.LoadRecord(ASource[AIndex]);
      ARecords.Add(rec);
      Inc(AIndex);
      Dec(count);
    end;
  finally
    factory.Free();
  end;
end;

procedure TclDnsCachePersister.Save(ACache: TclDnsCacheEntry; ADestination: TStrings);
begin
  ADestination.Clear();
  ADestination.Add(GetRecordTypeStr(ACache.RecordType));
  ADestination.Add(ACache.Name);

  SaveRecords(ACache.Answers, ADestination);
  SaveRecords(ACache.NameServers, ADestination);
  SaveRecords(ACache.AdditionalRecords, ADestination);
end;

procedure TclDnsCachePersister.SaveRecords(ARecords: TclDnsRecordList; ADestination: TStrings);
var
  factory: TclDnsRecordPersisterFactory;
  i: Integer;
  s: string;
begin
  ADestination.Add(IntToStr(ARecords.Count));

  factory := TclDnsRecordPersisterFactory.Create();
  try
    for i := 0 to ARecords.Count - 1 do
    begin
      s := factory.SaveRecord(ARecords[i]);
      ADestination.Add(s);
    end;
  finally
    factory.Free();
  end;
end;

{ TclDnsZoneManager }

constructor TclDnsZoneManager.Create;
begin
  inherited Create();
  FRecords := nil;
  FOwnRecords := nil;
end;

constructor TclDnsZoneManager.Create(ARecords: TclDnsRecordList);
begin
  inherited Create();
  FRecords := ARecords;
  FOwnRecords := nil;
end;

destructor TclDnsZoneManager.Destroy;
begin
  FOwnRecords.Free();
  inherited Destroy();
end;

function TclDnsZoneManager.GetRecords: TclDnsRecordList;
begin
  Result := FRecords;

  if (Result = nil) then
  begin
    Result := FOwnRecords;

    if (Result = nil) then
    begin
      FOwnRecords := TclDnsRecordList.Create();
    end;
    Result := FOwnRecords;
  end;
end;

class function TclDnsZoneManager.GetZoneFileName(const AZoneName: string): string;
var
  i: Integer;
  c: Char;
begin
  if (AZoneName = '') then
  begin
    raise EclDnsServerError.Create(DnsNameErrorCode);
  end;

  Result := '';
  for i := 1 to Length(AZoneName) do
  begin
    c := AZoneName[i];
    case (c) of
      '.': Result := Result + '_';
      '_': Result := Result + '__'
    else
      Result := Result + c;
    end;
  end;

  Result := Result + cDnzZoneFileExt;
end;

class function TclDnsZoneManager.GetZoneName(const AFileName: string): string;
var
  i, cnt: Integer;
  c: Char;
begin
  if (AFileName = '') then
  begin
    raise EclDnsServerError.Create(DnsNameErrorCode);
  end;

  Result := '';
  cnt := 0;
  for i := 1 to Length(AFileName) do
  begin
    c := AFileName[i];

    if (c = '.') then
    begin
      Break;
    end;
    
    if (c = '_') then
    begin
      Inc(cnt);
      if (cnt = 2) then
      begin
        cnt := 0;
        Result := Result + '_';
      end;
    end else
    if (cnt = 1) then
    begin
      cnt := 0;
      Result := Result + '.' + c;
    end else
    begin
      cnt := 0;
      Result := Result + c;
    end;
  end;
end;

procedure TclDnsZoneManager.ListZones(AZoneNames: TStrings);
var
  searchRec: TSearchRec;
begin
  AZoneNames.Clear();

  if {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindFirst(AddTrailingBackSlash(ZonePath) + '*' + cDnzZoneFileExt, 0, searchRec) = 0 then
  begin
    repeat
      AZoneNames.Add(GetZoneName(searchRec.Name));
    until ({$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindNext(searchRec) <> 0);
    {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindClose(searchRec);
  end;
end;

procedure TclDnsZoneManager.Load(const AZoneName: string);
var
  fileName: string;
begin
  fileName := AddTrailingBackSlash(ZonePath) + GetZoneFileName(AZoneName);
  if FileExists(fileName) then
  begin
    LoadFromFile(fileName);
  end;
end;

procedure TclDnsZoneManager.LoadFromFile(const AFileName: string);
var
  data: TStrings;
  factory: TclDnsRecordPersisterFactory;
  rec: TclDnsRecord;
  i: Integer;
begin
  Records.Clear();

  data := nil;
  factory := nil;
  try
    data := TStringList.Create();
    factory := TclDnsRecordPersisterFactory.Create();

    TclStringsUtils.LoadStrings(AFileName, data, '');

    for i := 0 to data.Count - 1 do
    begin
      rec := factory.LoadRecord(data[i]);
      Records.Add(rec);
    end;
  finally
    factory.Free();
    data.Free();
  end;
end;

procedure TclDnsZoneManager.Save(const AZoneName: string);
var
  fileName: string;
begin
  if (Records.Count = 0) then Exit;

  ForceFileDirectories(AddTrailingBackSlash(ZonePath));

  fileName := AddTrailingBackSlash(ZonePath) + GetZoneFileName(AZoneName);
  SaveToFile(fileName);
end;

procedure TclDnsZoneManager.SaveToFile(const AFileName: string);
var
  data: TStrings;
  factory: TclDnsRecordPersisterFactory;
  i: Integer;
begin
  if (Records.Count = 0) then Exit;

  data := nil;
  factory := nil;
  try
    data := TStringList.Create();
    factory := TclDnsRecordPersisterFactory.Create();

    for i := 0 to Records.Count - 1 do
    begin
      data.Add(factory.SaveRecord(Records[i]));
    end;

    TclStringsUtils.SaveStrings(data, AFileName, '');
  finally
    factory.Free();
    data.Free();
  end;
end;

{ TclDnsAAAARecordPersister }

function TclDnsAAAARecordPersister.CreateRecord: TclDnsRecord;
begin
  Result := TclDnsAAAARecord.Create();
end;

function TclDnsAAAARecordPersister.LoadRecord(AParameters: TStrings): TclDnsRecord;
begin
  if (AParameters.Count < 4) then
  begin
    raise EclDnsServerError.Create(DnsServerFailureCode);
  end;

  Result := inherited LoadRecord(AParameters);
  TclDnsAAAARecord(Result).IPv6Address := AParameters[3];
end;

procedure TclDnsAAAARecordPersister.SaveRecord(ARecord: TclDnsRecord; ADestination: TStrings);
begin
  inherited SaveRecord(ARecord, ADestination);

  ADestination.Add(TclDnsAAAARecord(ARecord).IPv6Address);
end;

end.
