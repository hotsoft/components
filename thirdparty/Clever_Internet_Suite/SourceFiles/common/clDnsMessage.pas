{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clDnsMessage;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clUtils, clSocket, clWUtils, clSocketUtils;

type
  TclDnsOpCode = (ocQuery, ocIQuery, ocStatus);
  TclDnsRecordClass = (rcInternet, rcChaos, rcHesiod);
  TclDnsRecordType = (rtARecord, rtNSRecord, rtCNAMERecord, rtSOARecord, rtPTRRecord, rtMXRecord, rtTXTRecord, rtAAAARecord);

  EclDnsError = class(EclSocketError)
  public
    constructor Create(AErrorCode: Integer; ADummy: Boolean = False); overload;
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean = False); overload;
    
    class function GetMessageText(AErrorCode: Integer): string;
  end;

  TclDnsMessageHeader = class(TPersistent)
  private
    FIsRecursionAvailable: Boolean;
    FIsAuthoritativeAnswer: Boolean;
    FIsQuery: Boolean;
    FIsRecursionDesired: Boolean;
    FIsTruncated: Boolean;
    FResponseCode: Integer;
    FOpCode: TclDnsOpCode;
    FID: Integer;
    FAnswerCount: Integer;
    FQueryCount: Integer;
    FNameServerCount: Integer;
    FAdditionalCount: Integer;
  public
    constructor Create;
    procedure Clear;
    procedure Assign(Source: TPersistent); override;
    procedure Build(var ADestination: TclByteArray; var AIndex: Integer);
    procedure Parse(const ASource: TclByteArray; var AIndex: Integer);

    property ID: Integer read FID write FID;
    property IsQuery: Boolean read FIsQuery write FIsQuery;
    property OpCode: TclDnsOpCode read FOpCode write FOpCode;
    property IsAuthoritativeAnswer: Boolean read FIsAuthoritativeAnswer write FIsAuthoritativeAnswer;
    property IsTruncated: Boolean read FIsTruncated write FIsTruncated;
    property IsRecursionDesired: Boolean read FIsRecursionDesired write FIsRecursionDesired;
    property IsRecursionAvailable: Boolean read FIsRecursionAvailable write FIsRecursionAvailable;
    property ResponseCode: Integer read FResponseCode write FResponseCode;
    property QueryCount: Integer read FQueryCount write FQueryCount;
    property AnswerCount: Integer read FAnswerCount write FAnswerCount;
    property NameServerCount: Integer read FNameServerCount write FNameServerCount;
    property AdditionalCount: Integer read FAdditionalCount write FAdditionalCount;
  end;

  TclDnsRecord = class(TPersistent)
  private
    FRecordClass: TclDnsRecordClass;
    FRecordType: Integer;
    FName: string;
    FTTL: DWORD;
    FDataLength: Integer;
  protected
    procedure WriteDomainName(const AName: string; var ADestination: TclByteArray; var AIndex: Integer);
    function ReadDomainName(const ASource: TclByteArray; var AIndex: Integer): string;
    procedure WriteCharacterString(const AValue: string; var ADestination: TclByteArray; var AIndex: Integer);
    function ReadCharacterString(const ASource: TclByteArray; var AIndex: Integer): string;
    procedure InternalBuild(var ADestination: TclByteArray; var AIndex: Integer); virtual;
    procedure InternalParse(const ASource: TclByteArray; var AIndex: Integer); virtual;
  public
    constructor Create; virtual;
    procedure Assign(Source: TPersistent); override;
    function Clone: TclDnsRecord;
    procedure Build(var ADestination: TclByteArray; var AIndex: Integer);
    procedure BuildQuery(var ADestination: TclByteArray; var AIndex: Integer);
    procedure Parse(const ASource: TclByteArray; var AIndex: Integer);
    procedure ParseQuery(const ASource: TclByteArray; var AIndex: Integer);

    property Name: string read FName write FName;
    property RecordType: Integer read FRecordType write FRecordType;
    property RecordClass: TclDnsRecordClass read FRecordClass write FRecordClass;
    property TTL: DWORD read FTTL write FTTL;
    property DataLength: Integer read FDataLength write FDataLength;
  end;

  TclDnsRecordClass_ = class of TclDnsRecord;

  TclDnsMXRecord = class(TclDnsRecord)
  private
    FPreference: Integer;
    FMailServer: string;
  protected
    procedure InternalBuild(var ADestination: TclByteArray; var AIndex: Integer); override;
    procedure InternalParse(const ASource: TclByteArray; var AIndex: Integer); override;
  public
    constructor Create; override;
    procedure Assign(Source: TPersistent); override;
    property Preference: Integer read FPreference write FPreference;
    property MailServer: string read FMailServer write FMailServer;
  end;

  TclDnsNSRecord = class(TclDnsRecord)
  private
    FNameServer: string;
  protected
    procedure InternalBuild(var ADestination: TclByteArray; var AIndex: Integer); override;
    procedure InternalParse(const ASource: TclByteArray; var AIndex: Integer); override;
  public
    constructor Create; override;
    procedure Assign(Source: TPersistent); override;
    property NameServer: string read FNameServer write FNameServer;
  end;

  TclDnsARecord = class(TclDnsRecord)
  private
    FIPAddress: string;
  protected
    procedure InternalBuild(var ADestination: TclByteArray; var AIndex: Integer); override;
    procedure InternalParse(const ASource: TclByteArray; var AIndex: Integer); override;
  public
    constructor Create; override;
    procedure Assign(Source: TPersistent); override;
    property IPAddress: string read FIPAddress write FIPAddress;
  end;

  TclDnsAAAARecord = class(TclDnsRecord)
  private
    FIPv6Address: string;
  protected
    procedure InternalBuild(var ADestination: TclByteArray; var AIndex: Integer); override;
    procedure InternalParse(const ASource: TclByteArray; var AIndex: Integer); override;
  public
    constructor Create; override;
    procedure Assign(Source: TPersistent); override;
    property IPv6Address: string read FIPv6Address write FIPv6Address;
  end;

  TclDnsPTRRecord = class(TclDnsRecord)
  private
    FDomainName: string;
  protected
    procedure InternalBuild(var ADestination: TclByteArray; var AIndex: Integer); override;
    procedure InternalParse(const ASource: TclByteArray; var AIndex: Integer); override;
  public
    constructor Create; override;
    procedure Assign(Source: TPersistent); override;
    property DomainName: string read FDomainName write FDomainName;
  end;

  TclDnsSOARecord = class(TclDnsRecord)
  private
    FExpirationLimit: DWORD;
    FMinimumTTL: DWORD;
    FRetryInterval: DWORD;
    FSerialNumber: DWORD;
    FRefreshInterval: DWORD;
    FResponsibleMailbox: string;
    FPrimaryNameServer: string;
  protected
    procedure InternalBuild(var ADestination: TclByteArray; var AIndex: Integer); override;
    procedure InternalParse(const ASource: TclByteArray; var AIndex: Integer); override;
  public
    constructor Create; override;
    procedure Assign(Source: TPersistent); override;

    property PrimaryNameServer: string read FPrimaryNameServer write FPrimaryNameServer;
    property ResponsibleMailbox: string read FResponsibleMailbox write FResponsibleMailbox;
    property SerialNumber: DWORD read FSerialNumber write FSerialNumber;
    property RefreshInterval: DWORD read FRefreshInterval write FRefreshInterval;
    property RetryInterval: DWORD read FRetryInterval write FRetryInterval;
    property ExpirationLimit: DWORD read FExpirationLimit write FExpirationLimit;
    property MinimumTTL: DWORD read FMinimumTTL write FMinimumTTL;
  end;

  TclDnsCNAMERecord = class(TclDnsRecord)
  private
    FPrimaryName: string;
  protected
    procedure InternalBuild(var ADestination: TclByteArray; var AIndex: Integer); override;
    procedure InternalParse(const ASource: TclByteArray; var AIndex: Integer); override;
  public
    constructor Create; override;
    procedure Assign(Source: TPersistent); override;
    property PrimaryName: string read FPrimaryName write FPrimaryName;
  end;

  TclDnsTXTRecord = class(TclDnsRecord)
  private
    FText: string;
  protected
    procedure InternalBuild(var ADestination: TclByteArray; var AIndex: Integer); override;
    procedure InternalParse(const ASource: TclByteArray; var AIndex: Integer); override;
  public
    constructor Create; override;
    procedure Assign(Source: TPersistent); override;
    property Text: string read FText write FText;
  end;
  
  TclDnsRecordList = class(TPersistent)
  private
    FList: TList;
    function GetCount: Integer;
    function GetItems(Index: Integer): TclDnsRecord;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    function Add(AItem: TclDnsRecord): Integer;
    procedure Insert(AIndex: Integer; AItem: TclDnsRecord);
    function ItemByName(const AName: string): TclDnsRecord;
    function ItemByType(ARecordType: Integer): TclDnsRecord;
    function FindItem(const AName: string; ARecordType: Integer): TclDnsRecord;
    procedure Clear;
    procedure Delete(Index: Integer);
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TclDnsRecord read GetItems; default;
  end;

  TclDnsMessage = class(TPersistent)
  private
    FHeader: TclDnsMessageHeader;
    FNameServers: TclDnsRecordList;
    FAnswers: TclDnsRecordList;
    FQueries: TclDnsRecordList;
    FAdditionalRecords: TclDnsRecordList;

    procedure CheckDnsError(AResponseCode: Integer);
  protected
    function CreateRecord(const ASource: TclByteArray; const AIndex: Integer): TclDnsRecord;
    function CreateRecordByType(ARecordType: Integer): TclDnsRecord; virtual;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure Clear;
    procedure Build(ADestination: TStream);
    procedure Parse(ASource: TStream);
    property Header: TclDnsMessageHeader read FHeader;
    property Queries: TclDnsRecordList read FQueries;
    property Answers: TclDnsRecordList read FAnswers;
    property NameServers: TclDnsRecordList read FNameServers;
    property AdditionalRecords: TclDnsRecordList read FAdditionalRecords;
  end;

resourcestring
  DnsDatagramInvalid = 'The size of the datagram is invalid';
  DnsFormatError = 'Format error';
  DnsServerFailure = 'Server failure';
  DnsNameError = 'No such name';
  DnsNotImplemented = 'Not implemented';
  DnsRefused = 'Refused';
  DnsUnspecifiedError = 'Unspecified error';

const
  DnsFormatErrorCode = 1;
  DnsServerFailureCode = 2;
  DnsNameErrorCode = 3;
  DnsNotImplementedCode = 4;
  DnsRefusedCode = 5;
  DnsDatagramInvalidCode = -1;

  DatagramSize = 512;
  DefaultDnsPort = 53;
  DnsRecordTypes: array[TclDnsRecordType] of Integer = (1, 2, 5, 6, 12, 15, 16, 28);

function GetRecordTypeStr(ARecordType: Integer): string;
function GetRecordTypeInt(const ARecordType: string): Integer;

implementation

uses
  clIpAddress, clTranslator;
  
function GetRecordTypeStr(ARecordType: Integer): string;
begin
  if (DnsRecordTypes[rtARecord] = ARecordType) then
  begin
    Result := 'A';
  end else
  if (DnsRecordTypes[rtNSRecord] = ARecordType) then
  begin
    Result := 'NS';
  end else
  if (DnsRecordTypes[rtCNAMERecord] = ARecordType) then
  begin
    Result := 'CNAME';
  end else
  if (DnsRecordTypes[rtSOARecord] = ARecordType) then
  begin
    Result := 'SOA';
  end else
  if (DnsRecordTypes[rtPTRRecord] = ARecordType) then
  begin
    Result := 'PTR';
  end else
  if (DnsRecordTypes[rtMXRecord] = ARecordType) then
  begin
    Result := 'MX';
  end else
  if (DnsRecordTypes[rtTXTRecord] = ARecordType) then
  begin
    Result := 'TXT';
  end else
  if (DnsRecordTypes[rtAAAARecord] = ARecordType) then
  begin
    Result := 'AAAA';
  end else
  begin
    Result := IntToStr(ARecordType);
  end;
end;

function GetRecordTypeInt(const ARecordType: string): Integer;
begin
  if ('A' = ARecordType) then
  begin
    Result := DnsRecordTypes[rtARecord];
  end else
  if ('NS' = ARecordType) then
  begin
    Result := DnsRecordTypes[rtNSRecord];
  end else
  if ('CNAME' = ARecordType) then
  begin
    Result := DnsRecordTypes[rtCNAMERecord];
  end else
  if ('SOA' = ARecordType) then
  begin
    Result := DnsRecordTypes[rtSOARecord];
  end else
  if ('PTR' = ARecordType) then
  begin
    Result := DnsRecordTypes[rtPTRRecord];
  end else
  if ('MX' = ARecordType) then
  begin
    Result := DnsRecordTypes[rtMXRecord];
  end else
  if ('TXT' = ARecordType) then
  begin
    Result := DnsRecordTypes[rtTXTRecord];
  end else
  if ('AAAA' = ARecordType) then
  begin
    Result := DnsRecordTypes[rtAAAARecord];
  end else
  begin
    Result := StrToIntDef(ARecordType, 0);
  end;
end;

{ TclDnsMessageHeader }

procedure TclDnsMessageHeader.Assign(Source: TPersistent);
var
  src: TclDnsMessageHeader;
begin
  if (Source is TclDnsMessageHeader) then
  begin
    src := TclDnsMessageHeader(Source);

    ID := src.ID;
    IsQuery := src.IsQuery;
    OpCode := src.OpCode;
    IsAuthoritativeAnswer := src.IsAuthoritativeAnswer;
    IsTruncated := src.IsTruncated;
    IsRecursionDesired := src.IsRecursionDesired;
    IsRecursionAvailable := src.IsRecursionAvailable;
    ResponseCode := src.ResponseCode;
    QueryCount := src.QueryCount;
    AnswerCount := src.AnswerCount;
    NameServerCount := src.NameServerCount;
    AdditionalCount := src.AdditionalCount;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclDnsMessageHeader.Build(var ADestination: TclByteArray; var AIndex: Integer);
var
  w: Word;
begin
  w := Loword(ID);
  ByteArrayWriteWord(w, ADestination, AIndex);

  w := 0;
  if not IsQuery then
  begin
    w := w or $8000;
  end;
  case OpCode of
    ocIQuery: w := w or $0800;
    ocStatus: w := w or $1000;
  end;
  if IsAuthoritativeAnswer then
  begin
    w := w or $0400;
  end;
  if IsTruncated then
  begin
    w := w or $0200;
  end;
  if IsRecursionDesired then
  begin
    w := w or $0100;
  end;
  if IsRecursionAvailable then
  begin
    w := w or $0080;
  end;
  w := w or (ResponseCode and $000F);
  ByteArrayWriteWord(w, ADestination, AIndex);

  ByteArrayWriteWord(Loword(QueryCount), ADestination, AIndex);
  ByteArrayWriteWord(Loword(AnswerCount), ADestination, AIndex);
  ByteArrayWriteWord(Loword(NameServerCount), ADestination, AIndex);
  ByteArrayWriteWord(Loword(AdditionalCount), ADestination, AIndex);
end;

procedure TclDnsMessageHeader.Clear;
begin
  ID := Loword(GetTickCount());
  IsQuery := False;
  OpCode := ocQuery;
  IsAuthoritativeAnswer := False;
  IsTruncated := False;
  IsRecursionDesired := False;
  IsRecursionAvailable := False;
  ResponseCode := 0;
  QueryCount := 0;
  AnswerCount := 0;
  NameServerCount := 0;
  AdditionalCount := 0;
end;

procedure TclDnsMessageHeader.Parse(const ASource: TclByteArray; var AIndex: Integer);
var
  w: Word;
begin
  Clear();
  ID := ByteArrayReadWord(ASource, AIndex);

  w := ByteArrayReadWord(ASource, AIndex);
  IsQuery := (w and $8000) = 0;
  case (w and $1800) of
    $0800: OpCode := ocIQuery;
    $1000: OpCode := ocStatus;
  else
    OpCode := ocQuery;
  end;
  IsAuthoritativeAnswer := (w and $0400) > 0;
  IsTruncated := (w and $0200) > 0;
  IsRecursionDesired := (w and $0100) > 0;
  IsRecursionAvailable := (w and $0080) > 0;
  ResponseCode := (w and $000F);

  QueryCount := ByteArrayReadWord(ASource, AIndex);
  AnswerCount := ByteArrayReadWord(ASource, AIndex);
  NameServerCount := ByteArrayReadWord(ASource, AIndex);
  AdditionalCount := ByteArrayReadWord(ASource, AIndex);
end;

constructor TclDnsMessageHeader.Create;
begin
  inherited Create();
  Clear();
end;

{ TclDnsMessage }

procedure TclDnsMessage.Assign(Source: TPersistent);
var
  src: TclDnsMessage;
begin
  if (Source is TclDnsMessage) then
  begin
    Clear();
    src := TclDnsMessage(Source);

    Header.Assign(src.Header);
    Queries.Assign(src.Queries);
    Answers.Assign(src.Answers);
    NameServers.Assign(src.NameServers);
    AdditionalRecords.Assign(src.AdditionalRecords);
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclDnsMessage.Build(ADestination: TStream);
var
  i, ind: Integer;
  buf: TclByteArray;
begin
  Header.QueryCount := Queries.Count;
  Header.AnswerCount := Answers.Count;
  Header.NameServerCount := NameServers.Count;
  Header.AdditionalCount := AdditionalRecords.Count;

  SetLength(buf, DatagramSize); //TODO replace it for AXFR
  ind := 0;
  Header.Build(buf, ind);

  for i := 0 to Queries.Count - 1 do
  begin
    Queries[i].BuildQuery(buf, ind);
  end;
  
  for i := 0 to Answers.Count - 1 do
  begin
    Answers[i].Build(buf, ind);
  end;

  for i := 0 to NameServers.Count - 1 do
  begin
    NameServers[i].Build(buf, ind);
  end;

  for i := 0 to AdditionalRecords.Count - 1 do
  begin
    AdditionalRecords[i].Build(buf, ind);
  end;

  ADestination.Write(buf[0], ind);
end;

procedure TclDnsMessage.CheckDnsError(AResponseCode: Integer);
begin
  if AResponseCode = 0 then Exit;
  raise EclDnsError.Create(AResponseCode);
end;

procedure TclDnsMessage.Clear;
begin
  FHeader.Clear();
  FNameServers.Clear();
  FAnswers.Clear();
  FQueries.Clear();
  FAdditionalRecords.Clear();
end;

constructor TclDnsMessage.Create;
begin
  inherited Create();
  FHeader := TclDnsMessageHeader.Create();
  FNameServers := TclDnsRecordList.Create();
  FAnswers := TclDnsRecordList.Create();
  FQueries := TclDnsRecordList.Create();
  FAdditionalRecords := TclDnsRecordList.Create();
end;

function TclDnsMessage.CreateRecord(const ASource: TclByteArray; const AIndex: Integer): TclDnsRecord;
var
  rec: TclDnsRecord;
  ind: Integer;
begin
  rec := TclDnsRecord.Create();
  try
    ind := AIndex;
    rec.ParseQuery(ASource, ind);
    Result := CreateRecordByType(rec.RecordType);
  finally
    rec.Free();
  end;
end;

function TclDnsMessage.CreateRecordByType(ARecordType: Integer): TclDnsRecord;
begin
  if (DnsRecordTypes[rtMXRecord] = ARecordType) then
  begin
    Result := TclDnsMXRecord.Create();
  end else
  if (DnsRecordTypes[rtNSRecord] = ARecordType) then
  begin
    Result := TclDnsNSRecord.Create();
  end else
  if (DnsRecordTypes[rtARecord] = ARecordType) then
  begin
    Result := TclDnsARecord.Create();
  end else
  if (DnsRecordTypes[rtPTRRecord] = ARecordType) then
  begin
    Result := TclDnsPTRRecord.Create();
  end else
  if (DnsRecordTypes[rtSOARecord] = ARecordType) then
  begin
    Result := TclDnsSOARecord.Create();
  end else
  if (DnsRecordTypes[rtCNAMERecord] = ARecordType) then
  begin
    Result := TclDnsCNAMERecord.Create();
  end else
  if (DnsRecordTypes[rtTXTRecord] = ARecordType) then
  begin
    Result := TclDnsTXTRecord.Create();
  end else
  if (DnsRecordTypes[rtAAAARecord] = ARecordType) then
  begin
    Result := TclDnsAAAARecord.Create();
  end else
  begin
    Result := TclDnsRecord.Create();
  end;
end;

destructor TclDnsMessage.Destroy;
begin
  FAdditionalRecords.Free();
  FQueries.Free();
  FAnswers.Free();
  FNameServers.Free();
  FHeader.Free();
  inherited Destroy();
end;

procedure TclDnsMessage.Parse(ASource: TStream);
var
  i, ind: Integer;
  buf: TclByteArray;
  rec: TclDnsRecord;
begin
  Clear();

  ind := (ASource.Size - ASource.Position);
  if (ind <= 0) then Exit;

  SetLength(buf, ind);
  ASource.Read(buf[0], ind);
  ind := 0;
  Header.Parse(buf, ind);

  for i := 0 to Header.QueryCount - 1 do
  begin
    rec := CreateRecord(buf, ind);
    Queries.Add(rec);
    rec.ParseQuery(buf, ind);
  end;

  for i := 0 to Header.AnswerCount - 1 do
  begin
    rec := CreateRecord(buf, ind);
    Answers.Add(rec);
    rec.Parse(buf, ind);
  end;

  for i := 0 to Header.NameServerCount - 1 do
  begin
    rec := CreateRecord(buf, ind);
    NameServers.Add(rec);
    rec.Parse(buf, ind);
  end;
  
  for i := 0 to Header.AdditionalCount - 1 do
  begin
    rec := CreateRecord(buf, ind);
    AdditionalRecords.Add(rec);
    rec.Parse(buf, ind);
  end;

  CheckDnsError(Header.ResponseCode);
end;

{ TclDnsRecordList }

function TclDnsRecordList.Add(AItem: TclDnsRecord): Integer;
begin
  Result := FList.Add(AItem);
end;

procedure TclDnsRecordList.Assign(Source: TPersistent);
var
  i: Integer;
begin
  if (Source is TclDnsRecordList) then
  begin
    Clear();
    for i := 0 to TclDnsRecordList(Source).Count - 1 do
    begin
      Add(TclDnsRecordList(Source).Items[i].Clone());
    end;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclDnsRecordList.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Items[i].Free();
  end;
  FList.Clear();
end;

constructor TclDnsRecordList.Create;
begin
  inherited Create();
  FList := TList.Create();
end;

procedure TclDnsRecordList.Delete(Index: Integer);
begin
  Items[Index].Free();
  FList.Delete(Index);
end;

destructor TclDnsRecordList.Destroy;
begin
  Clear();
  FList.Free();
  inherited Destroy();
end;

function TclDnsRecordList.FindItem(const AName: string; ARecordType: Integer): TclDnsRecord;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    if (Items[i].RecordType = ARecordType) and SameText(Items[i].Name, AName) then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
  Result := nil;
end;

function TclDnsRecordList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclDnsRecordList.GetItems(Index: Integer): TclDnsRecord;
begin
  Result := TclDnsRecord(FList[Index]);
end;

procedure TclDnsRecordList.Insert(AIndex: Integer; AItem: TclDnsRecord);
begin
  FList.Insert(AIndex, AItem);
end;

function TclDnsRecordList.ItemByName(const AName: string): TclDnsRecord;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    if SameText(Items[i].Name, AName) then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
  Result := nil;
end;

function TclDnsRecordList.ItemByType(ARecordType: Integer): TclDnsRecord;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    if (Items[i].RecordType = ARecordType) then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
  Result := nil;
end;

{ TclDnsMXRecord }

procedure TclDnsMXRecord.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if (Source is TclDnsMXRecord) then
  begin
    Preference := TclDnsMXRecord(Source).Preference;
    MailServer := TclDnsMXRecord(Source).MailServer;
  end;
end;

constructor TclDnsMXRecord.Create;
begin
  inherited Create();
  RecordType := DnsRecordTypes[rtMXRecord];
end;

procedure TclDnsMXRecord.InternalBuild(var ADestination: TclByteArray; var AIndex: Integer);
begin
  inherited InternalBuild(ADestination, AIndex);

  ByteArrayWriteWord(Preference, ADestination, AIndex);
  if (MailServer = '') then
  begin
    raise EclDnsError.Create(DnsServerFailureCode);
  end;

  WriteDomainName(MailServer, ADestination, AIndex);
end;

procedure TclDnsMXRecord.InternalParse(const ASource: TclByteArray; var AIndex: Integer);
begin
  inherited InternalParse(ASource, AIndex);
  Preference := ByteArrayReadWord(ASource, AIndex);
  MailServer := ReadDomainName(ASource, AIndex);
end;

{ TclDnsRecord }

procedure TclDnsRecord.Assign(Source: TPersistent);
var
  src: TclDnsRecord;
begin
  if (Source is TclDnsRecord) then
  begin
    src := TclDnsRecord(Source);
    Name := src.Name;
    RecordType := src.RecordType;
    RecordClass := src.RecordClass;
    TTL := src.TTL;
    DataLength := src.DataLength;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclDnsRecord.Build(var ADestination: TclByteArray; var AIndex: Integer);
var
  dataLengthInd, dataInd: Integer;
begin
  BuildQuery(ADestination, AIndex);

  ByteArrayWriteDWord(TTL, ADestination, AIndex);

  dataLengthInd := AIndex;
  ByteArrayWriteWord(0, ADestination, AIndex);
  dataInd := AIndex;

  InternalBuild(ADestination, AIndex);

  DataLength := AIndex - dataInd;
  ByteArrayWriteWord(DataLength, ADestination, dataLengthInd);
end;

procedure TclDnsRecord.BuildQuery(var ADestination: TclByteArray; var AIndex: Integer);
const
  RecClass: array[TclDnsRecordClass] of Word = (1, 3, 4);
begin
  WriteDomainName(Name, ADestination, AIndex);
  ByteArrayWriteWord(Word(RecordType), ADestination, AIndex);
  ByteArrayWriteWord(RecClass[RecordClass], ADestination, AIndex);
end;

function TclDnsRecord.Clone: TclDnsRecord;
begin
  Result := TclDnsRecordClass_(Self.ClassType).Create();
  try
    Result.Assign(Self);
  except
    Result.Free();
    raise;
  end;
end;

constructor TclDnsRecord.Create;
begin
  inherited Create();
end;

procedure TclDnsRecord.InternalBuild(var ADestination: TclByteArray; var AIndex: Integer);
begin
end;

procedure TclDnsRecord.InternalParse(const ASource: TclByteArray; var AIndex: Integer);
begin
end;

procedure TclDnsRecord.Parse(const ASource: TclByteArray; var AIndex: Integer);
var
  ind: Integer;
begin
  ParseQuery(ASource, AIndex);

  TTL := ByteArrayReadDWord(ASource, AIndex);
  DataLength := ByteArrayReadWord(ASource, AIndex);

  ind := AIndex;
  AIndex := AIndex + DataLength;

  if (AIndex > Length(ASource)) then
  begin
    raise EclDnsError.Create(DnsDatagramInvalid, DnsDatagramInvalidCode);
  end;

  InternalParse(ASource, ind);

  if (ind > AIndex) then
  begin
    raise EclDnsError.Create(DnsDatagramInvalid, DnsDatagramInvalidCode);
  end;
end;

procedure TclDnsRecord.ParseQuery(const ASource: TclByteArray;
  var AIndex: Integer);
begin
  Name := ReadDomainName(ASource, AIndex);
  RecordType := ByteArrayReadWord(ASource, AIndex);
  case ByteArrayReadWord(ASource, AIndex) of
    3: RecordClass := rcChaos;
    4: RecordClass := rcHesiod
  else
    RecordClass := rcInternet;
  end;
end;

function TclDnsRecord.ReadCharacterString(const ASource: TclByteArray; var AIndex: Integer): string;
var
  len: Integer;
begin
  len := ASource[AIndex];
  Inc(AIndex);
  if (len > 0) then
  begin
    if ((len + 1) > DataLength) then
    begin
      raise EclDnsError.Create(DnsDatagramInvalid, DnsDatagramInvalidCode);
    end;

    Result := TclTranslator.GetString(ASource, AIndex, len, 'us-ascii');
    AIndex := AIndex + len;
  end else
  begin
    Result := '';
  end;
end;

function TclDnsRecord.ReadDomainName(const ASource: TclByteArray;
  var AIndex: Integer): string;
var
  s: string;
  ind, len: Integer;
begin
  Result := '';
  ind := -1;
  repeat
    len := ASource[AIndex];
    while (len and $C0) = $C0 do
    begin
      if ind < 0 then
      begin
        ind := Succ(AIndex);
      end;
      AIndex := MakeWord(len and $3F, ASource[AIndex + 1]);
      if (AIndex >= Length(ASource)) then
      begin
        raise EclDnsError.Create(DnsDatagramInvalid, DnsDatagramInvalidCode);
      end;
      len := ASource[AIndex];
    end;
    SetLength(s, len);
    if len > 0 then
    begin
      s := TclTranslator.GetString(ASource, AIndex + 1, len, 'us-ascii');
      Inc(AIndex, Length(s) + 1);
    end;
    Result := Result + s + '.';
  until (ASource[AIndex] = 0) or (AIndex >= Length(ASource));
  if Result[Length(Result)] = '.' then
  begin
    SetLength(Result, Length(Result) - 1);
  end;
  if ind >= 0 then
  begin
    AIndex := ind;
  end;
  Inc(AIndex);
end;

procedure TclDnsRecord.WriteCharacterString(const AValue: string; var ADestination: TclByteArray; var AIndex: Integer);
var
  len: Integer;
  buf: TclByteArray;
begin
  buf := TclTranslator.GetBytes(AValue, 'us-ascii');
  len := 0;
  if (Length(buf) > 0) and (Length(buf) < 256) then
  begin
    len := Length(buf);
  end;

  ADestination[AIndex] := len;
  Inc(AIndex);

  if (len > 0) then
  begin
    system.Move(buf[0], ADestination[AIndex], len);
    Inc(AIndex, len);
  end;
end;

procedure TclDnsRecord.WriteDomainName(const AName: string;
  var ADestination: TclByteArray; var AIndex: Integer);
var
  name, s: string;
  ind: Integer;
  size: Byte;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  name := AName;
  while Length(name) > 0 do
  begin
    ind := system.Pos('.', name);
    if ind = 0 then
    begin
      ind := Length(name) + 1;
    end;
    s := system.Copy(name, 1, ind - 1);
    system.Delete(name, 1, ind);

    size := Byte(Length(s) and $00FF);
    ADestination[AIndex] := size;
    Inc(AIndex);

    buf := TclTranslator.GetBytes(s, 'us-ascii');
    system.Move(buf[0], ADestination[AIndex], size);
    Inc(AIndex, size);
  end;

  ADestination[AIndex] := 0;
  Inc(AIndex);
end;

{ TclDnsNSRecord }

procedure TclDnsNSRecord.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if (Source is TclDnsNSRecord) then
  begin
    NameServer := TclDnsNSRecord(Source).NameServer;
  end;
end;

constructor TclDnsNSRecord.Create;
begin
  inherited Create();
  RecordType := DnsRecordTypes[rtNSRecord];
end;

procedure TclDnsNSRecord.InternalBuild(var ADestination: TclByteArray; var AIndex: Integer);
begin
  inherited InternalBuild(ADestination, AIndex);

  if (NameServer = '') then
  begin
    raise EclDnsError.Create(DnsServerFailureCode);
  end;

  WriteDomainName(NameServer, ADestination, AIndex);
end;

procedure TclDnsNSRecord.InternalParse(const ASource: TclByteArray; var AIndex: Integer);
begin
  inherited InternalParse(ASource, AIndex);
  NameServer := ReadDomainName(ASource, AIndex);
end;

{ TclDnsARecord }

procedure TclDnsARecord.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if (Source is TclDnsARecord) then
  begin
    IPAddress := TclDnsARecord(Source).IPAddress;
  end;
end;

constructor TclDnsARecord.Create;
begin
  inherited Create();
  RecordType := DnsRecordTypes[rtARecord];
end;

procedure TclDnsARecord.InternalBuild(var ADestination: TclByteArray; var AIndex: Integer);
begin
  inherited InternalBuild(ADestination, AIndex);

  if (IPAddress = '') then
  begin
    raise EclDnsError.Create(DnsServerFailureCode);
  end;

  if WordCount(IPAddress, ['.']) <> 4 then
  begin
    raise EclDnsError.Create(DnsServerFailureCode);
  end;

  try
    ADestination[AIndex] := Byte(StrToInt(ExtractWord(1, IPAddress, ['.'])));
    ADestination[AIndex + 1] := Byte(StrToInt(ExtractWord(2, IPAddress, ['.'])));
    ADestination[AIndex + 2] := Byte(StrToInt(ExtractWord(3, IPAddress, ['.'])));
    ADestination[AIndex + 3] := Byte(StrToInt(ExtractWord(4, IPAddress, ['.'])));
    Inc(AIndex, 4);
  except
    raise EclDnsError.Create(DnsServerFailureCode);
  end;
end;

procedure TclDnsARecord.InternalParse(const ASource: TclByteArray; var AIndex: Integer);
begin
  inherited InternalParse(ASource, AIndex);
  IPAddress := Format('%d.%d.%d.%d',[ASource[AIndex], ASource[AIndex + 1], ASource[AIndex + 2], ASource[AIndex + 3]]);
  Inc(AIndex, 4);
end;

{ TclDnsPTRRecord }

procedure TclDnsPTRRecord.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if (Source is TclDnsPTRRecord) then
  begin
    DomainName := TclDnsPTRRecord(Source).DomainName;
  end;
end;

constructor TclDnsPTRRecord.Create;
begin
  inherited Create();
  RecordType := DnsRecordTypes[rtPTRRecord];
end;

procedure TclDnsPTRRecord.InternalBuild(var ADestination: TclByteArray; var AIndex: Integer);
begin
  inherited InternalBuild(ADestination, AIndex);

  if (DomainName = '') then
  begin
    raise EclDnsError.Create(DnsServerFailureCode);
  end;

  WriteDomainName(DomainName, ADestination, AIndex);
end;

procedure TclDnsPTRRecord.InternalParse(const ASource: TclByteArray; var AIndex: Integer);
begin
  inherited InternalParse(ASource, AIndex);
  DomainName := ReadDomainName(ASource, AIndex);
end;

{ TclDnsSOARecord }

procedure TclDnsSOARecord.Assign(Source: TPersistent);
var
  src: TclDnsSOARecord;
begin
  inherited Assign(Source);

  if (Source is TclDnsSOARecord) then
  begin
    src := TclDnsSOARecord(Source);

    PrimaryNameServer := src.PrimaryNameServer;
    ResponsibleMailbox := src.ResponsibleMailbox;
    SerialNumber := src.SerialNumber;
    RefreshInterval := src.RefreshInterval;
    RetryInterval := src.RetryInterval;
    ExpirationLimit := src.ExpirationLimit;
    MinimumTTL := src.MinimumTTL;
  end;
end;

constructor TclDnsSOARecord.Create;
begin
  inherited Create();
  RecordType := DnsRecordTypes[rtSOARecord];
end;

procedure TclDnsSOARecord.InternalBuild(var ADestination: TclByteArray; var AIndex: Integer);
begin
  inherited InternalBuild(ADestination, AIndex);

  WriteDomainName(PrimaryNameServer, ADestination, AIndex);
  WriteDomainName(ResponsibleMailbox, ADestination, AIndex);
  ByteArrayWriteDWord(SerialNumber, ADestination, AIndex);
  ByteArrayWriteDWord(RefreshInterval, ADestination, AIndex);
  ByteArrayWriteDWord(RetryInterval, ADestination, AIndex);
  ByteArrayWriteDWord(ExpirationLimit, ADestination, AIndex);
  ByteArrayWriteDWord(MinimumTTL, ADestination, AIndex);
end;

procedure TclDnsSOARecord.InternalParse(const ASource: TclByteArray; var AIndex: Integer);
begin
  inherited InternalParse(ASource, AIndex);

  PrimaryNameServer := ReadDomainName(ASource, AIndex);
  ResponsibleMailbox := ReadDomainName(ASource, AIndex);
  SerialNumber := ByteArrayReadDWord(ASource, AIndex);
  RefreshInterval := ByteArrayReadDWord(ASource, AIndex);
  RetryInterval := ByteArrayReadDWord(ASource, AIndex);
  ExpirationLimit := ByteArrayReadDWord(ASource, AIndex);
  MinimumTTL := ByteArrayReadDWord(ASource, AIndex);
end;

{ TclDnsCNAMERecord }

procedure TclDnsCNAMERecord.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if (Source is TclDnsCNAMERecord) then
  begin
    PrimaryName := TclDnsCNAMERecord(Source).PrimaryName;
  end;
end;

constructor TclDnsCNAMERecord.Create;
begin
  inherited Create();
  RecordType := DnsRecordTypes[rtCNAMERecord];
end;

procedure TclDnsCNAMERecord.InternalBuild(var ADestination: TclByteArray; var AIndex: Integer);
begin
  inherited InternalBuild(ADestination, AIndex);

  if (PrimaryName = '') then
  begin
    raise EclDnsError.Create(DnsServerFailureCode);
  end;

  WriteDomainName(PrimaryName, ADestination, AIndex);
end;

procedure TclDnsCNAMERecord.InternalParse(const ASource: TclByteArray; var AIndex: Integer);
begin
  inherited InternalParse(ASource, AIndex);
  PrimaryName := ReadDomainName(ASource, AIndex);
end;

{ TclDnsTXTRecord }

procedure TclDnsTXTRecord.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if (Source is TclDnsTXTRecord) then
  begin
    Text := TclDnsTXTRecord(Source).Text;
  end;
end;

constructor TclDnsTXTRecord.Create;
begin
  inherited Create();
  RecordType := DnsRecordTypes[rtTXTRecord];
end;

procedure TclDnsTXTRecord.InternalBuild(var ADestination: TclByteArray; var AIndex: Integer);
begin
  inherited InternalBuild(ADestination, AIndex);

  if (Text = '') then
  begin
    raise EclDnsError.Create(DnsServerFailureCode);
  end;

  WriteCharacterString(Text, ADestination, AIndex);
end;

procedure TclDnsTXTRecord.InternalParse(const ASource: TclByteArray; var AIndex: Integer);
begin
  inherited InternalParse(ASource, AIndex);
  Text := ReadCharacterString(ASource, AIndex);
end;

{ EclDnsError }

constructor EclDnsError.Create(AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(GetMessageText(AErrorCode), AErrorCode);
end;

constructor EclDnsError.Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorMsg, AErrorCode);
end;

class function EclDnsError.GetMessageText(AErrorCode: Integer): string;
begin
  case AErrorCode of
    DnsFormatErrorCode: Result := DnsFormatError;
    DnsServerFailureCode: Result := DnsServerFailure;
    DnsNameErrorCode: Result := DnsNameError;
    DnsNotImplementedCode: Result := DnsNotImplemented;
    DnsRefusedCode: Result := DnsRefused
  else
    Result := DnsUnspecifiedError;
  end;
end;

{ TclDnsAAAARecord }

procedure TclDnsAAAARecord.Assign(Source: TPersistent);
begin
  inherited Assign(Source);

  if (Source is TclDnsAAAARecord) then
  begin
    IPv6Address := TclDnsAAAARecord(Source).IPv6Address;
  end;
end;

constructor TclDnsAAAARecord.Create;
begin
  inherited Create();
  RecordType := DnsRecordTypes[rtAAAARecord];
end;

procedure TclDnsAAAARecord.InternalBuild(var ADestination: TclByteArray; var AIndex: Integer);
var
  i: Integer;
  addr: TclIPAddress6;
begin
  inherited InternalBuild(ADestination, AIndex);

  addr := TclIPAddress6.Create();
  try
    if not addr.Parse(IPv6Address) then
    begin
      raise EclDnsError.Create(DnsServerFailureCode);
    end;
    if not addr.IsIpV6 then
    begin
      raise EclDnsError.Create(DnsServerFailureCode);
    end;

    try
      for i := 0 to 15 do
      begin
        ADestination[AIndex] := Byte(addr.Address.AddressIn6.sin6_addr.s6_addr_[i]);
        Inc(AIndex);
      end;
    except
      raise EclDnsError.Create(DnsServerFailureCode);
    end;
  finally
    addr.Free();
  end;
end;

procedure TclDnsAAAARecord.InternalParse(const ASource: TclByteArray; var AIndex: Integer);
var
  i: Integer;
  addr: TclIPAddress6;
begin
  inherited InternalParse(ASource, AIndex);

  IPv6Address := '';
  for i := 0 to 7 do
  begin
    IPv6Address := IPv6Address + IntToHex(ASource[AIndex] * 256 + ASource[AIndex + 1], 1) + ':';
    Inc(AIndex, 2);
  end;
  system.Delete(FIPv6Address, Length(FIPv6Address), 1);

  addr := TclIPAddress6.Create();
  try
    if addr.Parse(IPv6Address) then
    begin
      IPv6Address := addr.ToString();
    end;
  finally
    addr.Free();
  end;
end;

end.

