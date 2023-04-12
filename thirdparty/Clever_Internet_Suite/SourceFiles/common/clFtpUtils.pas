{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clFtpUtils;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Contnrs, Windows;
{$ELSE}
  System.Classes, System.SysUtils, System.Contnrs, Winapi.Windows;
{$ENDIF}

const
  DefaultFtpPort = 21;
  DefaultFtpProxyPort = 21;

type
  TclFtpTransferMode = (tmBlock, tmCompressed, tmStream, tmDeflate);
  TclFtpTransferStructure = (tsFile, tsRecord, tsPage);
  TclFtpTransferType = (ttAscii, ttBinary);
  TclDirListingStyle = (lsMsDos, lsUnix);
  TclFtpFilePermission = (fpRead, fpWrite, fpExecute);
  TclFtpFilePermissions = set of TclFtpFilePermission;


  TclFtpProxyType = (ptNone, ptUserSite, ptSite, ptOpen, ptUserPass, ptTransparent, ptCustomProxy, ptAccount);

  TclFtpProxySettings = class(TPersistent)
  protected
    FProxyType: TclFtpProxyType;
    FUserName: string;
    FPassword: string;
    FServer: string;
    FPort: Integer;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
    procedure Clear;
  published
    property  ProxyType: TclFtpProxyType read FProxyType write FProxyType default ptNone;
    property  UserName: string read FUserName write FUserName;
    property  Password: string read FPassword write FPassword;
    property  Server: string read FServer write FServer;
    property  Port: Integer read FPort write FPort default DefaultFtpProxyPort;
  end;

  TclFtpFileInfo = class;

  TclFtpFileInfoParser = class
  protected
    function ParseTime(const ASrc: string): TDateTime;
    function GetDelimiter(const ASrc: string): Char;
  public
    procedure Parse(AFileInfo: TclFtpFileInfo; const ASource: string); virtual; abstract;
    function Build(AFileInfo: TclFtpFileInfo): string; virtual; abstract;
    function Check(const ASource: string): Boolean; virtual; abstract;
  end;

  TclMsDosFileInfoParser = class(TclFtpFileInfoParser)
  private
    function ParseDateTime(const ADate, ATime: string): TDateTime;
  public
    procedure Parse(AFileInfo: TclFtpFileInfo; const ASource: string); override;
    function Build(AFileInfo: TclFtpFileInfo): string; override;
    function Check(const ASource: string): Boolean; override;
  end;

  TclUnixFileInfoParser = class(TclFtpFileInfoParser)
  private
    function GetMonth(const AMonth: string): Integer;
    function CurrentYear: Integer;
    function IsSixMonth(ADate: TDateTime): Boolean;
    function GetMissingYear(ADay, AMonth: Integer): Integer;
    function GetPermissionsStr(APermissions: TclFtpFilePermissions): string;
    function ParsePermissionsStr(const APermissions: string): TclFtpFilePermissions;
  public
    procedure Parse(AFileInfo: TclFtpFileInfo; const ASource: string); override;
    function Build(AFileInfo: TclFtpFileInfo): string; override;
    function Check(const ASource: string): Boolean; override;
  end;

  TclAs400FileInfoParser = class(TclFtpFileInfoParser)
  private
    function ParseDate(const ASrc: string): TDateTime;
  public
    procedure Parse(AFileInfo: TclFtpFileInfo; const ASource: string); override;
    function Build(AFileInfo: TclFtpFileInfo): string; override;
    function Check(const ASource: string): Boolean; override;
  end;

  TclFtpFileInfo = class
  private
    FIsReadOnly: Boolean;
    FIsDirectory: Boolean;
    FSize: Int64;
    FFileName: string;
    FModifiedDate: TDateTime;
    FIsLink: Boolean;
    FOwner: TclFtpFilePermissions;
    FOther: TclFtpFilePermissions;
    FGroup: TclFtpFilePermissions;

    procedure Clear;
    function GetParser(const ASource: string): TclFtpFileInfoParser;
  public
    constructor Create;
    procedure Parse(const ASource: string);
    function Build(AStyle: TclDirListingStyle): string;
    procedure Assign(Source: TclFtpFileInfo); virtual;

    property FileName: string read FFileName write FFileName;
    property IsDirectory: Boolean read FIsDirectory write FIsDirectory;
    property IsLink: Boolean read FIsLink write FIsLink;
    property IsReadOnly: Boolean read FIsReadOnly write FIsReadOnly;
    property Size: Int64 read FSize write FSize;
    property ModifiedDate: TDateTime read FModifiedDate write FModifiedDate;
    property Owner: TclFtpFilePermissions read FOwner write FOwner;
    property Group: TclFtpFilePermissions read FGroup write FGroup;
    property Other: TclFtpFilePermissions read FOther write FOther;
  end;

  TclFtpFileInfoList = class
  private
    FList: TObjectList;
    
    function GetCount: Integer;
    function GetItem(Index: Integer): TclFtpFileInfo;
    function GetOwnsObjects: Boolean;
  public
    constructor Create; overload;
    constructor Create(AOwnsObjects: Boolean); overload;
    destructor Destroy; override;

    procedure Add(Item: TclFtpFileInfo);
    procedure Delete(Index: Integer);
    procedure Clear;
    property Items[Index: Integer]: TclFtpFileInfo read GetItem; default;
    property Count: Integer read GetCount;
    property OwnsObjects: Boolean read GetOwnsObjects;
  end;

function GetFtpFilePermissionsInt(APermissions: TclFtpFilePermissions): Integer;
function GetFtpHostStr(const AHost: string; APort: Integer): string;
procedure ParseFtpHostStr(const ASource: string; var AHost: string; var APort: Integer);
function GetRegisteredFtpFileInfoParsers: TObjectList;
procedure RegisterFtpFileInfoParser(AParser: TclFtpFileInfoParser);

implementation

uses
  clUtils, clWUtils, clSocket;

var
  RegisteredFtpFileInfoParsers: TObjectList = nil;

function GetRegisteredFtpFileInfoParsers: TObjectList;
begin
  if (RegisteredFtpFileInfoParsers = nil) then
  begin
    RegisteredFtpFileInfoParsers := TObjectList.Create();
  end;
  Result := RegisteredFtpFileInfoParsers;
end;

procedure RegisterFtpFileInfoParser(AParser: TclFtpFileInfoParser);
begin
  GetRegisteredFtpFileInfoParsers().Add(AParser);
end;

function GetFtpFilePermissionsInt(APermissions: TclFtpFilePermissions): Integer;
begin
  Result := 0;
  if (fpRead in APermissions) then
    Result := 4;
  if (fpWrite in APermissions) then
    Result := Result or 2;
  if (fpExecute in APermissions) then
    Result := Result or 1;
end;

function GetFtpHostStr(const AHost: string; APort: Integer): string;
begin
  Result := Format('%s,%d,%d',
    [StringReplace(TclHostResolver.GetIPAddress(AHost), '.', ',', [rfReplaceAll]), APort div 256, APort mod 256]);
end;

procedure ParseFtpHostStr(const ASource: string; var AHost: string; var APort: Integer);
var
  i: Integer;
begin
  AHost := '';
  APort := 0;

  for i := 1 to 4 do
  begin
    AHost := AHost + '.' + ExtractWord(i, ASource, [',']);
  end;
  system.Delete(AHost, 1, 1);
  APort := StrToIntDef(ExtractWord(5, ASource, [',']), 0) shl 8;
  APort := APort + StrToIntDef(ExtractWord(6, ASource, [',']), 0);
end;

{ TclFtpFileInfo }

procedure TclFtpFileInfo.Clear;
begin
  FIsReadOnly := False;
  FIsDirectory := False;
  FIsLink := False;
  FSize := 0;
  FFileName := '';
  FModifiedDate := 0;
  FOwner := [];
  FOther := [];
  FGroup := [];
end;

constructor TclFtpFileInfo.Create;
begin
  inherited Create();
  Clear();
end;

function TclFtpFileInfo.GetParser(const ASource: string): TclFtpFileInfoParser;
var
  i: Integer;
  list: TObjectList;
begin
  if (ASource = '') then
  begin
    Result := nil;
    Exit;
  end;

  list := GetRegisteredFtpFileInfoParsers();
  for i := 0 to list.Count - 1 do
  begin
    Result := TclFtpFileInfoParser(list[i]);
    if Result.Check(ASource) then Exit;
  end;

  Result := nil;
end;

procedure TclFtpFileInfo.Parse(const ASource: string);
var
  parser: TclFtpFileInfoParser;
begin
  Clear();

  parser := GetParser(ASource);
  if (parser <> nil) then
  begin
    parser.Parse(Self, ASource);
  end;
end;

procedure TclFtpFileInfo.Assign(Source: TclFtpFileInfo);
begin
  if (Source <> nil) then
  begin
    FIsReadOnly := Source.IsReadOnly;
    FIsDirectory := Source.IsDirectory;
    FIsLink := Source.IsLink;
    FSize := Source.Size;
    FFileName := Source.FileName;
    FModifiedDate := Source.ModifiedDate;
    FOwner := Source.Owner;
    FOther := Source.Other;
    FGroup := Source.Group;
  end else
  begin
    Clear();
  end;
end;

function TclFtpFileInfo.Build(AStyle: TclDirListingStyle): string;
var
  parser: TclFtpFileInfoParser;
begin
  parser := nil;
  try
    case AStyle of
      lsMsDos: parser := TclMsDosFileInfoParser.Create();
      lsUnix: parser := TclUnixFileInfoParser.Create();
    end;
    if (parser <> nil) then
    begin
      Result := parser.Build(Self);
    end else
    begin
      Result := FileName;
    end;
  finally
    parser.Free();
  end;
end;

{ TclFtpProxySettings }

procedure TclFtpProxySettings.Assign(Source: TPersistent);
var
  Src: TclFtpProxySettings;
begin
  if (Source is TclFtpProxySettings) then
  begin
    Src := (Source as TclFtpProxySettings);
    ProxyType  := Src.ProxyType;
    UserName := Src.UserName;
    Password := Src.Password;
    Server := Src.Server;
    Port := Src.Port;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclFtpProxySettings.Clear;
begin
  FProxyType := ptNone;
  FPort := DefaultFtpProxyPort;
  FUserName := '';
  FPassword := '';
  FServer := '';
end;

constructor TclFtpProxySettings.Create;
begin
  inherited Create();
  Clear();
end;

{ TclMsDosFileInfoParser }

function TclMsDosFileInfoParser.Build(AFileInfo: TclFtpFileInfo): string;
var
  resSize: string;
begin
  DateTimeToString(Result, 'mm-dd-yy  hh:nnAM/PM', AFileInfo.ModifiedDate);
  resSize := IntToStr(AFileInfo.Size);
  if AFileInfo.IsDirectory then
  begin
    Result := Result + '       <DIR>         ';
  end else
  begin
    Result := Result + StringOfChar(#32, 21 - Length(resSize)) + resSize;
  end;
  Result := Result + ' ' + AFileInfo.FileName;
end;

function TclMsDosFileInfoParser.Check(const ASource: string): Boolean;
begin
  Result := (WordCount(ASource, [#32]) > 3);
  if Result then
  begin
    Result := ParseDateTime(Trim(ExtractWord(1, ASource, [#32])),
      Trim(ExtractWord(2, ASource, [#32]))) > 0;
  end;
end;

procedure TclMsDosFileInfoParser.Parse(AFileInfo: TclFtpFileInfo; const ASource: string);
var
  s: string;
begin
  if (WordCount(ASource, [#32]) < 4) then Exit;

  AFileInfo.ModifiedDate := ParseDateTime(Trim(ExtractWord(1, ASource, [' '])),
    Trim(ExtractWord(2, ASource, [' '])));

  s := Trim(ExtractWord(3, ASource, [' ']));
  AFileInfo.IsDirectory := SameText(s, '<DIR>');

  if not AFileInfo.IsDirectory then
  begin
    AFileInfo.Size := StrToInt64Def(s, 0);
  end;

  AFileInfo.FileName := Trim(system.Copy(ASource, WordPosition(4, ASource, [#32]), Length(ASource)));
end;

function TclMsDosFileInfoParser.ParseDateTime(const ADate, ATime: string): TDateTime;
var
  m, d, y: Integer;
  delim: Char;
begin
  delim := GetDelimiter(ADate);

  if (WordCount(ADate, [delim]) < 3) then
  begin
    Result := 0;
    Exit;
  end;

  m := StrToIntDef(Trim(ExtractWord(1, ADate, [delim])), 0);
  d := StrToIntDef(Trim(ExtractWord(2, ADate, [delim])), 0);
  y := StrToIntDef(Trim(ExtractWord(3, ADate, [delim])), 0);

  if (m > 0) and (d > 0) then
  begin
    y := GetCorrectY2k(y);
  end;

{$IFDEF DELPHI6}
  if not TryEncodeDate(y, m, d, Result) then
  begin
    Result := 0;
  end;
{$ELSE}
  try
    Result := EncodeDate(y, m, d);
  except
    Result := 0;
  end;
{$ENDIF}

  if (Result > 0) then
  begin
    Result := Result + ParseTime(ATime);
  end;
end;

{ TclUnixFileInfoParser }

function TclUnixFileInfoParser.Build(AFileInfo: TclFtpFileInfo): string;
var
  resTime, resAccessOwn, resAccessGrp, resAccessOth: string;
  temp, resMonth: Word;
  resSize: Int64;
begin
  if AFileInfo.IsDirectory then
  begin
    resSize := 512;
    Result := 'd';
  end else
  begin
    resSize := AFileInfo.Size;
    Result := '-';
  end;

  if (AFileInfo.Owner = []) and (AFileInfo.Group = []) and (AFileInfo.Other = []) then
  begin
    if AFileInfo.IsReadOnly then
    begin
      resAccessOwn := 'r-x';
    end else
    begin
      resAccessOwn := 'rwx';
    end;
    resAccessGrp := resAccessOwn;
    resAccessOth := resAccessOwn;
  end else
  begin
    resAccessOwn := GetPermissionsStr(AFileInfo.Owner);
    resAccessGrp := GetPermissionsStr(AFileInfo.Group);
    resAccessOth := GetPermissionsStr(AFileInfo.Other);
  end;
  
  Result := Result + Format('%3s%3s%3s   1 %8s %8s     %8d',
    [resAccessOwn, resAccessGrp, resAccessOth, 'owner   ', 'group   ', resSize]);

  DecodeDate(AFileInfo.ModifiedDate, temp, resMonth, temp);

  resTime := cMonths[resMonth] + FormatDateTime(' dd', AFileInfo.ModifiedDate);
  if IsSixMonth(AFileInfo.ModifiedDate) then
  begin
    resTime := resTime + FormatDateTime(' hh:nn', AFileInfo.ModifiedDate);
  end else
  begin
    resTime := resTime + FormatDateTime(' yyyy', AFileInfo.ModifiedDate);
  end;
  Result := Result + ' ' + resTime + ' ' + AFileInfo.FileName;
end;

function TclUnixFileInfoParser.Check(const ASource: string): Boolean;
var
  info: TclFtpFileInfo;
begin
  Result := CharInSet(UpperCase(ASource[1])[1], ['D', '-', 'C', 'L']);
  if Result then
  begin
    info := TclFtpFileInfo.Create();
    try
      Parse(info, ASource);
      Result := (info.FileName <> '') and (info.ModifiedDate > 0);
    finally
      info.Free();
    end;
  end;
end;

function TclUnixFileInfoParser.CurrentYear: Integer;
var
  y, m, d: Word;
begin
  DecodeDate(Now(), y, m, d);
  Result := y;
end;

function TclUnixFileInfoParser.GetMonth(const AMonth: string): Integer;
begin
  Result := Succ(IndexOfStrArray(AMonth, cMonths));
  if (Result = 0) then
  begin
    Result := StrToIntDef(AMonth, 0);
  end;
end;

function TclUnixFileInfoParser.GetPermissionsStr(
  APermissions: TclFtpFilePermissions): string;
begin
  Result := '---';
  if (fpRead in APermissions) then
    Result[1] := 'r';
  if (fpWrite in APermissions) then
    Result[2] := 'w';
  if (fpExecute in APermissions) then
    Result[3] := 'x';
end;

function TclUnixFileInfoParser.IsSixMonth(ADate: TDateTime): Boolean;
var
  curMonth, curDay, curYear: Word;
  month,  year: Word;
  dateMonth, dateDay, dateYear: Word;
begin
  DecodeDate(Now(), curYear, curMonth, curDay);
  DecodeDate(ADate, dateYear, dateMonth, dateDay);
  if (curMonth - 6) < 1 then
  begin
    month := 12 + (curMonth - 6);
    year := curYear - 1;
  end else
  begin
    month := curMonth - 6;
    year := curYear;
  end;
  Result := True;
  if (dateYear < year) then
  begin
    Result := False;
  end else
  if (dateYear = year) then
  begin
    Result := (dateMonth >= month);
    if Result and (dateMonth = month) then
    begin
      Result := (dateDay >= curDay);
    end;
  end;
end;

function TclUnixFileInfoParser.GetMissingYear(ADay, AMonth: Integer): Integer;
var
  y, m, d: Word;
begin
  DecodeDate(Now(), y, m, d);

  Result := y;
  if (m < AMonth) or ((m = AMonth) and (d < ADay)) then
  begin
    Dec(Result);
  end;
end;

procedure TclUnixFileInfoParser.Parse(AFileInfo: TclFtpFileInfo; const ASource: string);
var
  cnt, startWord: Integer;
  s: string;
  ind, y, m, d, hh, mm: Integer;
begin
  cnt := WordCount(ASource, [#32]);
  if cnt < 6 then Exit;

  s := UpperCase(Trim(ExtractWord(1, ASource, [#32])));

  AFileInfo.IsDirectory := (s[1] = 'D');
  AFileInfo.IsLink := (s[1] = 'L');

  AFileInfo.IsReadOnly := (system.Pos('W', s) = 0);

  if (Length(s) >= 9) then
  begin
    AFileInfo.Owner := ParsePermissionsStr(system.Copy(s, 2, 3));
    AFileInfo.Group := ParsePermissionsStr(system.Copy(s, 5, 3));
    AFileInfo.Other := ParsePermissionsStr(system.Copy(s, 8, 3));
  end;

  startWord := 5;
  while startWord > 1 do
  begin
    try
      AFileInfo.Size := StrToInt64(Trim(ExtractWord(startWord, ASource, [#32])));

      m := GetMonth(Trim(ExtractWord(startWord + 1, ASource, [#32])));
      d := StrToIntDef(Trim(ExtractWord(startWord + 2, ASource, [#32])), 1);
      s := Trim(ExtractWord(startWord + 3, ASource, [#32]));
      if system.Pos(':', s) > 0 then
      begin
        y := GetMissingYear(d, m);
        hh := StrToIntDef(ExtractWord(1, s, [':']), 0);
        mm := StrToIntDef(ExtractWord(2, s, [':']), 0);
      end else
      begin
        y := StrToIntDef(s, CurrentYear());
        hh := 0;
        mm := 0;
      end;
      AFileInfo.ModifiedDate := EncodeDate(y, m, d) + EncodeTime(hh, mm, 0, 0);

      ind := WordPosition(startWord + 4, ASource, [#32]);
      if (ind > 0) then
      begin
        AFileInfo.FileName := Trim(system.Copy(ASource, ind, Length(ASource)));
        if AFileInfo.IsLink then
        begin
          s := AFileInfo.FileName;
          ind := system.Pos('->', s);
          if (ind > 0) then
          begin
            SetLength(s, ind - 1);
            AFileInfo.FileName := TrimRight(s);
          end;
        end;
      end;

      Break;
    except
      Dec(startWord);
    end;
  end;
end;

function TclUnixFileInfoParser.ParsePermissionsStr(const APermissions: string): TclFtpFilePermissions;
var
  s: string;
begin
  Result := [];
  if (Length(APermissions) < 3) then Exit;

  s := LowerCase(APermissions);
  if (s[1] = 'r') then
    Result := Result + [fpRead];
  if (s[2] = 'w') then
    Result := Result + [fpWrite];
  if (s[3] = 'x') then
    Result := Result + [fpExecute];
end;

{ TclAs400FileInfoParser }

function TclAs400FileInfoParser.Build(AFileInfo: TclFtpFileInfo): string;
begin
  Assert(False, 'Not implemented');
end;

function TclAs400FileInfoParser.Check(const ASource: string): Boolean;
var
  s: string;
begin
  if (WordCount(ASource, [#32]) > 5) then
  begin
    s := Trim(ExtractWord(5, ASource, [#32]));
    Result := (s[1] = '*') or (s = 'DIR');
  end else
  if (WordCount(ASource, [#32]) > 2) then
  begin
    s := Trim(ExtractWord(2, ASource, [#32]));
    Result := (s[1] = '*') or (s = 'DIR');
  end else
  begin
    Result := False;
  end;
end;

procedure TclAs400FileInfoParser.Parse(AFileInfo: TclFtpFileInfo; const ASource: string);
var
  ind: Integer;
  s: string;
begin
  if (WordCount(ASource, [#32]) > 5) then
  begin
    AFileInfo.Size := StrToInt64Def(Trim(ExtractWord(2, ASource, [#32])), 0);

    AFileInfo.ModifiedDate := ParseDate(Trim(ExtractWord(3, ASource, [#32]))) + ParseTime(Trim(ExtractWord(4, ASource, [#32])));

    s := Trim(ExtractWord(5, ASource, [#32]));
    AFileInfo.IsDirectory := (s = '*FILE') or (s = 'DIR');

    ind := WordPosition(6, ASource, [#32]);
    if (ind > 0) then
    begin
      AFileInfo.FileName := system.Copy(ASource, ind, 10000);
    end;
  end else
  if (WordCount(ASource, [#32]) > 2) then
  begin
    s := Trim(ExtractWord(2, ASource, [#32]));
    AFileInfo.IsDirectory := (s = '*FILE') or (s = 'DIR');

    ind := WordPosition(3, ASource, [#32]);
    if (ind > 0) then
    begin
      AFileInfo.FileName := system.Copy(ASource, ind, 10000);
    end;
  end;
end;

function TclAs400FileInfoParser.ParseDate(const ASrc: string): TDateTime;
  procedure Exchange(var arg1, arg2: Integer);
  var
    temp: Integer;
  begin
    temp := arg2;
    arg2 := arg1;
    arg1 := temp;
  end;

var
  m, d, y: Integer;
  delim: Char;
begin
  delim := GetDelimiter(ASrc);
  d := StrToIntDef(Trim(ExtractWord(1, ASrc, [delim])), 0);
  m := StrToIntDef(Trim(ExtractWord(2, ASrc, [delim])), 0);
  y := StrToIntDef(Trim(ExtractWord(3, ASrc, [delim])), 0);
  y := GetCorrectY2k(y);

  if (m > 12) then
  begin
    Exchange(d, m);
  end;
  if (d > 31) then
  begin
    Exchange(y, d);
  end;

{$IFDEF DELPHI6}
  if not TryEncodeDate(y, m, d, Result) then
  begin
    Result := 0;
  end;
{$ELSE}
  try
    Result := EncodeDate(y, m, d);
  except
    Result := 0;
  end;
{$ENDIF}
end;

{ TclFtpFileInfoParser }

function TclFtpFileInfoParser.GetDelimiter(const ASrc: string): Char;
var
  i: Integer;
begin
  for i := 1 to Length(ASrc) do
  begin
    Result := ASrc[i];
    if not CharInSet(Result, ['0'..'9']) then Exit;
  end;
  Result := #0;
end;

function TclFtpFileInfoParser.ParseTime(const ASrc: string): TDateTime;
var
  pm, am: Integer;
  s: string;
  delim: Char;
  h, m, sec: Word;
begin
  s := UpperCase(ASrc);
  pm := system.Pos('PM', s);
  am := system.Pos('AM', s);
  sec := 0;

  if (pm > 0) then
  begin
    s := system.Copy(s, 1, pm - 1);
  end;
  if (am > 0) then
  begin
    s := system.Copy(s, 1, am - 1);
  end;
  s := Trim(s);

  delim := GetDelimiter(s);
  h := StrToIntDef(ExtractWord(1, s, [delim]), 0);
  m := StrToIntDef(ExtractWord(2, s, [delim]), 0);
  if (WordCount(s, [delim]) > 2) then
  begin
    sec := StrToIntDef(ExtractWord(3, s, [delim]), 0);
  end;

  if (pm > 0) then
  begin
    if h < 12 then
    begin
      h := h + 12;
    end;
  end;
  if (am > 0) then
  begin
    if h = 12 then
    begin
      h := 0;
    end;
  end;

{$IFDEF DELPHI6}
  if not TryEncodeTime(h, m, sec, 0, Result) then
  begin
    Result := 0;
  end;
{$ELSE}
  try
    Result := EncodeTime(h, m, sec, 0);
  except
    Result := 0;
  end;
{$ENDIF}
end;

{ TclFtpFileInfoList }

procedure TclFtpFileInfoList.Add(Item: TclFtpFileInfo);
begin
  FList.Add(Item);
end;

procedure TclFtpFileInfoList.Clear;
begin
  FList.Clear();
end;

constructor TclFtpFileInfoList.Create(AOwnsObjects: Boolean);
begin
  inherited Create();
  FList := TObjectList.Create(AOwnsObjects);
end;

constructor TclFtpFileInfoList.Create;
begin
  inherited Create();
  FList := TObjectList.Create(True);
end;

procedure TclFtpFileInfoList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TclFtpFileInfoList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function TclFtpFileInfoList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclFtpFileInfoList.GetItem(Index: Integer): TclFtpFileInfo;
begin
  Result := TclFtpFileInfo(FList[Index]);
end;

function TclFtpFileInfoList.GetOwnsObjects: Boolean;
begin
  Result := FList.OwnsObjects;
end;

initialization
  RegisterFtpFileInfoParser(TclMsDosFileInfoParser.Create());
  RegisterFtpFileInfoParser(TclUnixFileInfoParser.Create());
  RegisterFtpFileInfoParser(TclAs400FileInfoParser.Create());

finalization
  RegisteredFtpFileInfoParsers.Free();

end.

