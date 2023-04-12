{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clDnsQuery;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes,
{$ELSE}
  System.Classes,
{$ENDIF}
  clDnsMessage, clUdpClient, clSocketUtils, clIpAddress;

type
  TclHostInfo = class
  private
    FIPAddress: string;
    FName: string;
  public
    constructor Create(const AIPAddress, AName: string);

    property Name: string read FName;
    property IPAddress: string read FIPAddress;
  end;

  TclHostList = class
  private
    FList: TList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TclHostInfo;
  protected
    procedure Clear;
    procedure Add(AItem: TclHostInfo);
    procedure Insert(Index: Integer; AItem: TclHostInfo);
  public
    constructor Create;
    destructor Destroy; override;
    function ItemByName(const AName: string): TclHostInfo;
    property Items[Index: Integer]: TclHostInfo read GetItem; default;
    property Count: Integer read GetCount;
  end;

  TclMailServerInfo = class(TclHostInfo)
  private
    FPreference: Integer;
  public
    constructor Create(const AIPAddress, AName: string; APreference: Integer);

    property Preference: Integer read FPreference;
  end;

  TclMailServerList = class(TclHostList)
  private
    function GetItem(Index: Integer): TclMailServerInfo;
    procedure AddSorted(AItem: TclMailServerInfo);
  public
    property Items[Index: Integer]: TclMailServerInfo read GetItem; default;
  end;

  TclDnsQuery = class(TclUdpClient)
  private
    FQuery: TclDnsMessage;
    FResponse: TclDnsMessage;
    FMailServers: TclMailServerList;
    FNameServers: TStrings;
    FHosts: TclHostList;
    FIsRecursiveDesired: Boolean;
    FAliases: TStrings;
    FMaxRecursiveQueries: Integer;
    FUseRecursiveQueries: Boolean;
    FAutodetectServer: Boolean;
    FHostsIPv6: TclHostList;
    FRootNameServers: TStrings;

    procedure FillAInfo(ARecordList: TclDnsRecordList);
    procedure FillMXInfo;
    procedure FillNSInfo(ARecordList: TclDnsRecordList);
    function FillHostInfo: TclHostInfo;
    procedure FillAliasInfo;
    function ExtractTxtInfo: string;
    function GetPreferredMX: TclMailServerInfo;
    function GetEmailDomain(const AEmail: string): string;
    function GetArpaIPAddress(const AIP: string): string;
    function GetArpaIPv6Address(Addr: TclIPAddress6): string;
    procedure InternalResolveIP(const AHost, ADns: string; AQuery, AResponse: TclDnsMessage; IsIPv6: Boolean);
    procedure InternalResolve(AQuery, AResponse: TclDnsMessage);
    procedure ResolveRecursive(AQuery, AResponse: TclDnsMessage; ANestLevel: Integer);
    function ExtractPrimaryName(ARecordList: TclDnsRecordList; const Alias: string): string;
    procedure SetRootNameServers(const Value: TStrings);
  protected
    function GetDefaultPort: Integer; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class procedure GetDnsList(AList: TStrings);

    procedure Clear;
    procedure Resolve; overload;
    procedure Resolve(AQuery, AResponse: TclDnsMessage); overload;
    function ResolveMX(const AEmail: string): TclMailServerInfo;
    function ResolveIP(const AHost: string): TclHostInfo;
    function ResolveIPv6(const AHost: string): TclHostInfo;
    function ResolveHost(const AIPAddress: string): TclHostInfo;
    function ResolveNS(const AHost: string): string;
    function ResolveTXT(const AHost: string): string;
    function ResolveCName(const AHost: string): string;

    property Query: TclDnsMessage read FQuery;
    property Response: TclDnsMessage read FResponse;
    property MailServers: TclMailServerList read FMailServers;
    property Hosts: TclHostList read FHosts;
    property HostsIPv6: TclHostList read FHostsIPv6;
    property NameServers: TStrings read FNameServers;
    property Aliases: TStrings read FAliases;
  published
    property Port default DefaultDnsPort;
    property DatagramSize default 512;
    property IsRecursiveDesired: Boolean read FIsRecursiveDesired write FIsRecursiveDesired default True;
    property UseRecursiveQueries: Boolean read FUseRecursiveQueries write FUseRecursiveQueries default False;
    property MaxRecursiveQueries: Integer read FMaxRecursiveQueries write FMaxRecursiveQueries default 4;
    property AutodetectServer: Boolean read FAutodetectServer write FAutodetectServer default True;
    property RootNameServers: TStrings read FRootNameServers write SetRootNameServers;
  end;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsDnsDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}


implementation

uses
{$IFNDEF DELPHIXE2}
  Windows, SysUtils, Registry{$IFDEF DEMO}, Forms{$ENDIF},
{$ELSE}
  Winapi.Windows, System.SysUtils, System.Win.Registry{$IFDEF DEMO}, Vcl.Forms{$ENDIF},
{$ENDIF}
  clSocket, clUtils{$IFDEF LOGGER}, clLogger{$ENDIF};

{ TclDnsQuery }

procedure TclDnsQuery.Clear;
begin
  Query.Clear();
  Response.Clear();
  Hosts.Clear();
  HostsIPv6.Clear();
  MailServers.Clear();
  NameServers.Clear();
  Aliases.Clear();
end;

constructor TclDnsQuery.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FRootNameServers := TStringList.Create();

  FQuery := TclDnsMessage.Create();
  FResponse := TclDnsMessage.Create();

  FHosts := TclHostList.Create();
  FHostsIPv6 := TclHostList.Create();
  FMailServers := TclMailServerList.Create();
  FNameServers := TStringList.Create();
  FAliases := TStringList.Create();

  IsRecursiveDesired := True;
  MaxRecursiveQueries := 4;
  DatagramSize := 512;
  AutodetectServer := True;
end;

destructor TclDnsQuery.Destroy;
begin
  FAliases.Free();
  FNameServers.Free();
  FMailServers.Free();
  FHostsIPv6.Free();
  FHosts.Free();

  FResponse.Free();
  FQuery.Free();

  FRootNameServers.Free();

  inherited Destroy();
end;

procedure TclDnsQuery.Resolve;
begin
  Resolve(Query, Response);
end;

procedure TclDnsQuery.SetRootNameServers(const Value: TStrings);
begin
  FRootNameServers.Assign(Value);
end;

procedure TclDnsQuery.Resolve(AQuery, AResponse: TclDnsMessage);
var
  i: Integer;
  oldServer: string;
begin
  if AutodetectServer and (Server = '') and (RootNameServers.Count = 0) then
  begin
    GetDnsList(RootNameServers);
  end;

  if (Server = '') and (RootNameServers.Count > 0) then
  begin
    for i := 0 to RootNameServers.Count - 1 do
    begin
      Server := RootNameServers[i];
      try
        ResolveRecursive(AQuery, AResponse, 0);
        Server := RootNameServers[i];
        Break;
      except
        on EclSocketError do
        begin
          Server := '';
        end;
      end;
    end;
  end else
  begin
    oldServer := Server;
    try
      ResolveRecursive(AQuery, AResponse, 0);
    finally
      Server := oldServer;
    end;
  end;
end;

function TclDnsQuery.ExtractPrimaryName(ARecordList: TclDnsRecordList; const Alias: string): string;
var
  i: Integer;
begin
  for i := 0 to ARecordList.Count - 1 do
  begin
    if (ARecordList[i] is TclDnsCNAMERecord) then
    begin
      if (ARecordList[i].Name = Alias) then
      begin
        Result := TclDnsCNAMERecord(ARecordList[i]).PrimaryName;
        Exit;
      end;
    end;
  end;
  Result := '';
end;

function TclDnsQuery.ResolveCName(const AHost: string): string;
var
  rec: TclDnsRecord;
begin
  Clear();

  Query.Header.IsQuery := True;
  Query.Header.IsRecursionDesired := IsRecursiveDesired;

  rec := TclDnsCNAMERecord.Create();
  Query.Queries.Add(rec);
  rec.Name := AHost;
  rec.RecordClass := rcInternet;

  Resolve();

  FillAInfo(Response.AdditionalRecords);
  FillNSInfo(Response.NameServers);
  FillAliasInfo();

  Result := ExtractPrimaryName(Response.Answers, AHost);
  if (Result = '') then
  begin
    Result := ExtractPrimaryName(Response.AdditionalRecords, AHost);
  end;
  if (Result = '') then
  begin
    Result := AHost;
  end;
end;

function TclDnsQuery.ResolveMX(const AEmail: string): TclMailServerInfo;
var
  rec: TclDnsRecord;
begin
  Clear();

  Query.Header.IsQuery := True;
  Query.Header.IsRecursionDesired := IsRecursiveDesired;

  rec := TclDnsMXRecord.Create();
  Query.Queries.Add(rec);
  rec.Name := GetEmailDomain(AEmail);
  rec.RecordClass := rcInternet;

  Resolve();

  FillAInfo(Response.AdditionalRecords);
  FillNSInfo(Response.NameServers);
  FillAliasInfo();
  FillMXInfo();

  Result := GetPreferredMX();
end;

function TclDnsQuery.GetEmailDomain(const AEmail: string): string;
var
  ind: Integer;
begin
  Result := AEmail;
  ind := system.Pos('@', Result);
  if (ind > 0) then
  begin
    system.Delete(Result, 1, ind);
  end;
end;

function TclDnsQuery.GetArpaIPAddress(const AIP: string): string;
begin
  Result := AIP;
  if (system.Pos('in-addr.arpa', LowerCase(Result)) = 0) and (WordCount(Result, ['.']) = 4) then
  begin
    Result := ExtractWord(4, Result, ['.']) + '.' + ExtractWord(3, Result, ['.']) + '.' +
      ExtractWord(2, Result, ['.']) + '.' + ExtractWord(1, Result, ['.']) + '.in-addr.arpa';
  end;
end;

function TclDnsQuery.GetArpaIPv6Address(Addr: TclIPAddress6): string;
var
  i: Integer;
  b: Byte;
begin
  Result := '';
  for i := 0 to 15 do
  begin
    b := Byte(Addr.Address.AddressIn6.sin6_addr.s6_addr_[i]);
    Result := Result + IntToHex(b shr 4, 1) + '.';
    Result := Result + IntToHex(b and $f, 1) + '.';
  end;
  Result := Result + 'ip6.arpa';
end;

function TclDnsQuery.GetDefaultPort: Integer;
begin
  Result := DefaultDnsPort;
end;

class procedure TclDnsQuery.GetDnsList(AList: TStrings);
  procedure ExtractDnsNames(const AValue: string; AList: TStrings);
  var
    i: Integer;
    s: string;
  begin
    for i := 1 to WordCount(AValue, [' ', ',']) do
    begin
      s := ExtractWord(i, AValue, [' ', ',']);
      if AList.IndexOf(s) < 0 then
      begin
        AList.Add(s);
      end;
    end;
  end;

var
  i: Integer;
  reg: TRegistry;
  names: TStrings;
  val: string;
begin
  reg := nil;
  names := nil;
  try
    reg := TRegistry.Create();
    names := TStringList.Create();

    reg.RootKey := HKEY_LOCAL_MACHINE;
    if (reg.OpenKeyReadOnly('SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\')) then
    begin
      reg.GetKeyNames(names);
      for i := 0 to names.Count - 1 do
      begin
        reg.CloseKey();
        if reg.OpenKeyReadOnly('SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\' + names[i]) then
        begin
          val := reg.ReadString('DhcpNameServer');
          if (val <> '') then
          begin
            ExtractDnsNames(val, AList);
          end else
          begin
            val := reg.ReadString('NameServer');
            if (val <> '') then
            begin
              ExtractDnsNames(val, AList);
            end;
          end;
          reg.CloseKey();
        end;
      end;
    end;
  finally
    names.Free();
    reg.Free();
  end;
end;

procedure TclDnsQuery.FillMXInfo;
var
  i: Integer;
  aInfo: TclHostInfo;
  mxInfo: TclMailServerInfo;
  mxRec: TclDnsMXRecord;
  s: string;
begin
  for i := 0 to Response.Answers.Count - 1 do
  begin
    if (Response.Answers[i] is TclDnsMXRecord) then
    begin
      mxRec := Response.Answers[i] as TclDnsMXRecord;
      aInfo := Hosts.ItemByName(mxRec.MailServer);
      s := '';
      if (aInfo <> nil) then
      begin
        s := aInfo.IPAddress;
      end;

      mxInfo := TclMailServerInfo.Create(s, mxRec.MailServer, mxRec.Preference);
      MailServers.AddSorted(mxInfo);
    end;
  end;
end;

function TclDnsQuery.GetPreferredMX: TclMailServerInfo;
begin
  if (MailServers.Count > 0) then
  begin
    Result := MailServers[0];
  end else
  begin
    Result := nil;
  end;
end;

procedure TclDnsQuery.InternalResolve(AQuery, AResponse: TclDnsMessage);
var
  queryStream, replyStream: TStream;
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
    if not IsDnsDemoDisplayed then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsDnsDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'InternalResolve');{$ENDIF}

  queryStream := nil;
  replyStream := nil;
  try
    Open();

    queryStream := TMemoryStream.Create();
    AQuery.Build(queryStream);
    queryStream.Position := 0;
    SendPacket(queryStream);

    replyStream := TMemoryStream.Create();
    ReceivePacket(replyStream);
    replyStream.Position := 0;
    AResponse.Parse(replyStream);
  finally
    replyStream.Free();
    queryStream.Free();
    Close();
  end;

{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'InternalResolve'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'InternalResolve', E); raise; end; end;{$ENDIF}
end;

procedure TclDnsQuery.InternalResolveIP(const AHost, ADns: string; AQuery, AResponse: TclDnsMessage; IsIPv6: Boolean);
const
  aRecClass: array[Boolean] of TclDnsRecordClass_ = (TclDnsARecord, TclDnsAAAARecord); 
var
  rec: TclDnsRecord;
begin
  Server := ADns;

  AQuery.Header.IsQuery := True;
  AQuery.Header.IsRecursionDesired := IsRecursiveDesired;

  rec := aRecClass[IsIPv6].Create();
  AQuery.Queries.Add(rec);
  rec.Name := AHost;
  rec.RecordClass := rcInternet;

  Resolve(AQuery, AResponse);
end;

function TclDnsQuery.ResolveIP(const AHost: string): TclHostInfo;
begin
  Clear();

  InternalResolveIP(AHost, Server, Query, Response, False);

  FillAInfo(Response.Answers);
  FillNSInfo(Response.NameServers);
  FillAliasInfo();

  if (Hosts.Count > 0) then
  begin
    Result := Hosts[0];
  end else
  begin
    Result := nil;
  end;
end;

function TclDnsQuery.ResolveIPv6(const AHost: string): TclHostInfo;
begin
  Clear();

  InternalResolveIP(AHost, Server, Query, Response, True);

  FillAInfo(Response.Answers);
  FillNSInfo(Response.NameServers);
  FillAliasInfo();

  if (HostsIPv6.Count > 0) then
  begin
    Result := HostsIPv6[0];
  end else
  begin
    Result := nil;
  end;
end;

procedure TclDnsQuery.FillNSInfo(ARecordList: TclDnsRecordList);
var
  i: Integer;
begin
  for i := 0 to ARecordList.Count - 1 do
  begin
    if (ARecordList[i] is TclDnsNSRecord) then
    begin
      NameServers.Add((ARecordList[i] as TclDnsNSRecord).NameServer);
    end;
  end;
end;

function TclDnsQuery.ExtractTxtInfo: string;
var
  i, cnt: Integer;
  rec: TclDnsTXTRecord;
begin
  Result := '';
  cnt := 0;
  for i := 0 to Response.Answers.Count - 1 do
  begin
    if (Response.Answers[i] is TclDnsTXTRecord) then
    begin
      rec := TclDnsTXTRecord(Response.Answers[i]);
      if Length(Result) > 0 then
      begin
        Result := Result + ',';
      end;
      Result := Result + GetQuotedString(rec.Text);
      Inc(cnt);
    end;
  end;
  if (cnt = 1) then
  begin
    Result := ExtractQuotedString(Result);
  end;
end;

function TclDnsQuery.ResolveHost(const AIPAddress: string): TclHostInfo;
var
  rec: TclDnsRecord;
  addr: TclIPAddress6;
begin
  Clear();

  Query.Header.IsQuery := True;
  Query.Header.IsRecursionDesired := IsRecursiveDesired;

  rec := TclDnsPTRRecord.Create();
  Query.Queries.Add(rec);
  rec.RecordClass := rcInternet;

  addr := TclIPAddress6.Create();
  try
    if addr.Parse(AIPAddress) and addr.IsIpV6 then
    begin
      rec.Name := GetArpaIPv6Address(addr);
    end else
    begin
      rec.Name := GetArpaIPAddress(AIPAddress);
    end;
  finally
    addr.Free();
  end;

  Resolve();

  Result := FillHostInfo();
  FillAInfo(Response.AdditionalRecords);
  FillNSInfo(Response.NameServers);
  FillAliasInfo();

  if (Result <> nil) then
  begin
    Result.FIPAddress := AIPAddress;
  end;
end;

function TclDnsQuery.FillHostInfo: TclHostInfo;
var
  i: Integer;
  ptrRec: TclDnsPTRRecord;
begin
  Result := nil;
  for i := 0 to Response.Answers.Count - 1 do
  begin
    if (Response.Answers[i] is TclDnsPTRRecord) then
    begin
      ptrRec := (Response.Answers[i] as TclDnsPTRRecord);

      Result := TclHostInfo.Create(ptrRec.Name, ptrRec.DomainName);
      Hosts.Add(Result);
    end;
  end;
end;

procedure TclDnsQuery.FillAInfo(ARecordList: TclDnsRecordList);
var
  i: Integer;
  aRec: TclDnsARecord;
  av6Rec: TclDnsAAAARecord;
begin
  for i := 0 to ARecordList.Count - 1 do
  begin
    if (ARecordList[i] is TclDnsARecord) then
    begin
      aRec := (ARecordList[i] as TclDnsARecord);
      Hosts.Add(TclHostInfo.Create(aRec.IPAddress, aRec.Name));
    end;
    if (ARecordList[i] is TclDnsAAAARecord) then
    begin
      av6Rec := (ARecordList[i] as TclDnsAAAARecord);
      HostsIPv6.Add(TclHostInfo.Create(av6Rec.IPv6Address, av6Rec.Name));
    end;
  end;
end;

function TclDnsQuery.ResolveNS(const AHost: string): string;
var
  rec: TclDnsRecord;
begin
  Clear();

  Query.Header.IsQuery := True;
  Query.Header.IsRecursionDesired := IsRecursiveDesired;

  rec := TclDnsNSRecord.Create();
  Query.Queries.Add(rec);
  rec.Name := AHost;
  rec.RecordClass := rcInternet;

  Resolve();

  FillNSInfo(Response.Answers);
  FillAliasInfo();
  FillAInfo(Response.AdditionalRecords);

  if (NameServers.Count > 0) then
  begin
    Result := NameServers[0];
  end else
  begin
    Result := '';
  end;
end;

procedure TclDnsQuery.ResolveRecursive(AQuery, AResponse: TclDnsMessage; ANestLevel: Integer);
var
  i: Integer;
  nameServer: string;
  rec: TclDnsRecord;
  resolveIPRequest, resolveIPResponse: TclDnsMessage;
begin
  if (ANestLevel > MaxRecursiveQueries) then Exit;

  InternalResolve(AQuery, AResponse);

  if (not UseRecursiveQueries) then Exit;

  if (AResponse.Answers.Count > 0) then Exit;

  for i := 0 to AResponse.NameServers.Count - 1 do
  begin
    try
      if (AResponse.NameServers[i] is TclDnsNSRecord) then
      begin
        nameServer := TclDnsNSRecord(AResponse.NameServers[i]).NameServer;

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'NS: ' + nameServer);{$ENDIF}

        rec := AResponse.AdditionalRecords.FindItem(nameServer, DnsRecordTypes[rtARecord]);
        if ((rec <> nil) and (rec is TclDnsARecord)) then
        begin
          Server := TclDnsARecord(rec).IPAddress;
        end else
        begin
          resolveIPRequest := nil;
          resolveIPResponse := nil;
          try
            resolveIPRequest := TclDnsMessage.Create();
            resolveIPResponse := TclDnsMessage.Create();

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'before InternalResolveIP');{$ENDIF}

            InternalResolveIP(nameServer, '', resolveIPRequest, resolveIPResponse, False);

            if ((resolveIPResponse.Answers.Count > 0) and (resolveIPResponse.Answers[0] is TclDnsARecord)) then
            begin
              Server := TclDnsARecord(resolveIPResponse.Answers[0]).IPAddress;
            end else
            begin
              Continue;
            end;
          finally
            resolveIPResponse.Free();
            resolveIPRequest.Free();
          end;
        end;

        resolveIPResponse := TclDnsMessage.Create();
        try
          ResolveRecursive(AQuery, resolveIPResponse, ANestLevel + 1);
          AResponse.Assign(resolveIPResponse);
        finally
          resolveIPResponse.Free();
        end;

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ResolveRecursive record resolved');{$ENDIF}
        Break;
      end;
    except
      on EclSocketError do
      begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ResolveRecursive resolve error, next name server attempt');{$ENDIF}
      end;
    end;
  end;
end;

function TclDnsQuery.ResolveTXT(const AHost: string): string;
var
  rec: TclDnsRecord;
begin
  Clear();

  Query.Header.IsQuery := True;
  Query.Header.IsRecursionDesired := IsRecursiveDesired;

  rec := TclDnsTXTRecord.Create();
  Query.Queries.Add(rec);
  rec.Name := AHost;
  rec.RecordClass := rcInternet;

  Resolve();

  FillAInfo(Response.AdditionalRecords);
  FillNSInfo(Response.NameServers);
  FillAliasInfo();

  Result := ExtractTxtInfo();
end;

procedure TclDnsQuery.FillAliasInfo;
  procedure ExtractAliases(ARecordList: TclDnsRecordList);
  var
    i: Integer;
  begin
    for i := 0 to ARecordList.Count - 1 do
    begin
      if (ARecordList[i] is TclDnsCNAMERecord) then
      begin
        Aliases.Add(ARecordList[i].Name);
      end;
    end;
  end;
  
begin
  ExtractAliases(Response.Answers);
  ExtractAliases(Response.AdditionalRecords);
end;

{ TclHostList }

procedure TclHostList.Add(AItem: TclHostInfo);
begin
  FList.Add(AItem);
end;

procedure TclHostList.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Items[i].Free();
  end;
  FList.Clear();
end;

constructor TclHostList.Create;
begin
  inherited Create();
  FList := TList.Create();
end;

destructor TclHostList.Destroy;
begin
  Clear();
  FList.Free();
  inherited Destroy();
end;

function TclHostList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclHostList.GetItem(Index: Integer): TclHostInfo;
begin
  Result := TclHostInfo(FList[Index]);
end;

procedure TclHostList.Insert(Index: Integer; AItem: TclHostInfo);
begin
  FList.Insert(Index, AItem);
end;

function TclHostList.ItemByName(const AName: string): TclHostInfo;
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

{ TclMailServerList }

procedure TclMailServerList.AddSorted(AItem: TclMailServerInfo);
var
  ind: Integer;
begin
  ind := 0;
  while (ind < Count) do
  begin
    if (Items[ind].Preference > AItem.Preference) then
    begin
      Break;
    end;
    Inc(ind);
  end;

  Insert(ind, AItem);
end;

function TclMailServerList.GetItem(Index: Integer): TclMailServerInfo;
begin
  Result := (inherited Items[Index] as TclMailServerInfo);
end;

{ TclHostInfo }

constructor TclHostInfo.Create(const AIPAddress, AName: string);
begin
  inherited Create();

  FIPAddress := AIPAddress;
  FName := AName;
end;

{ TclMailServerInfo }

constructor TclMailServerInfo.Create(const AIPAddress, AName: string; APreference: Integer);
begin
  inherited Create(AIPAddress, AName);

  FPreference := APreference;
end;

end.

