{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clUtils;

interface

{$I clVer.inc}
uses
{$IFNDEF DELPHIXE2}
  Windows, Classes, SysUtils, SyncObjs, RTLConsts{$IFDEF DELPHI2009}, WideStrings{$ENDIF},
{$ELSE}
  Winapi.Windows, System.Classes, System.SysUtils, System.SyncObjs, System.RTLConsts, System.WideStrings,
{$ENDIF}
  clWUtils;

type
  TclProgressEvent = procedure(Sender: TObject; ABytesProceed, ATotalBytes: Int64) of object;

{$IFDEF DELPHI2007}
  TclByteArray = TBytes;
{$ELSE}
  TclByteArray = array of Byte;
{$ENDIF}

{$IFDEF DELPHIXE}
  TclIntArray = TArray<Integer>;
{$ELSE}
  TclIntArray = array of Integer;
{$ENDIF}

{$IFDEF DELPHIXE}
  TclShortArray = TArray<SmallInt>;
{$ELSE}
  TclShortArray = array of SmallInt;
{$ENDIF}

  TclIntPtr = {$IFDEF DELPHIXE2}NativeInt{$ELSE}Integer{$ENDIF};

  TclBinaryData = class
  private
    FData: PByte;
    FDataSize: Integer;
    FCharSet: string;

    procedure Deallocate;
    function GetDataBytes(Index: Integer): Byte;
    procedure SetDataBytes(Index: Integer; const Value: Byte);
  protected
    procedure DeallocateMem(var P: PByte); virtual;
    procedure AllocateMem(var P: PByte; ASize: Integer); virtual;
  public
    constructor Create; overload;
    constructor Create(const ACharSet: string); overload;
    constructor Create(ASize: Integer); overload;
    constructor Create(const ACharSet: string; ASize: Integer); overload;
    destructor Destroy; override;

    procedure FromWideString(const ASource: WideString);
    procedure FromString(const ASource: string);
    procedure FromStrings(ASource: TStrings); overload;
    procedure FromStrings(ASource: TStrings; ExcludeTrailingCrlf: Boolean); overload;
    procedure FromStream(ASource: TStream); overload;
    procedure FromStream(ASource: TStream; Count: Integer); overload;
    procedure FromBytes(ASource: TclByteArray); overload;
    procedure FromBytes(ASource: TclByteArray; Index, Count: Integer); overload;

    function ToWideString: WideString;
{$IFDEF DELPHI2009}
    function ToString: string; override;
{$ELSE}
    function ToString: string;
{$ENDIF}
    procedure ToStrings(ADestination: TStrings);
    procedure ToStream(ADestination: TStream);
    function ToBytes: TclByteArray;

    procedure Allocate(ASize: Integer);
    procedure Reduce(ANewSize: Integer);

    property Data: PByte read FData;
    property DataSize: Integer read FDataSize;
    property DataBytes[Index: Integer]: Byte read GetDataBytes write SetDataBytes;

    property CharSet: string read FCharSet write FCharSet;
  end;

{$IFNDEF DELPHI2009}
  PWideStringItem = ^TWideStringItem;
  TWideStringItem = record
    FString: WideString;
    FObject: TObject;
  end;

  PWideStringItemList = ^TWideStringItemList;
  TWideStringItemList = array[0..MaxListSize] of TWideStringItem;
  
  TWideStringList = class(TPersistent)
  private
    FList: PWideStringItemList;
    FCount: Integer;
    FCapacity: Integer;
    FSorted: Boolean;
    FDuplicates: TDuplicates;
    FNameValueSeparator: WideChar;
    
    procedure SetSorted(const Value: Boolean);
    procedure QuickSort(L, R: Integer);
    procedure ExchangeItems(Index1, Index2: Integer);
    procedure Grow;
    function GetName(Index: Integer): WideString;
    function GetValue(const Name: WideString): WideString;
    function GetValueFromIndex(Index: Integer): WideString;
    procedure SetValue(const Name, Value: WideString);
    procedure SetValueFromIndex(Index: Integer; const Value: WideString);
  protected
    function ExtractName(const S: WideString): WideString;
    procedure Error(const Msg: string; Data: Integer);
    function Get(Index: Integer): WideString; virtual;
    function GetObject(Index: Integer): TObject; virtual;
    procedure Put(Index: Integer; const S: WideString); virtual;
    procedure PutObject(Index: Integer; AObject: TObject); virtual;
    function CompareStrings(const S1, S2: WideString): Integer; virtual;
    procedure InsertItem(Index: Integer; const S: WideString; AObject: TObject); virtual;
    procedure SetCapacity(NewCapacity: Integer); virtual;
  public
    constructor Create;
    destructor Destroy; override;

    procedure BeginUpdate;
    procedure EndUpdate;
    procedure Assign(Source: TPersistent); override;
    function Add(const S: WideString): Integer; virtual;
    function AddObject(const S: WideString; AObject: TObject): Integer; virtual;
    procedure AddStrings(AStrings: TStrings); overload; virtual;
    procedure AddStrings(AStrings: TWideStringList); overload; virtual;
    procedure Clear; virtual;
    procedure Delete(Index: Integer); virtual;
    function Find(const S: WideString; var Index: Integer): Boolean; virtual;
    function IndexOf(const S: WideString): Integer; virtual;
    function IndexOfName(const Name: WideString): Integer; virtual;
    function IndexOfObject(AObject: TObject): Integer; virtual;
    procedure Insert(Index: Integer; const S: WideString); virtual;
    procedure InsertObject(Index: Integer; const S: WideString; AObject: TObject); virtual;
    procedure Move(CurIndex, NewIndex: Integer); virtual;
    procedure Sort; virtual;
    property Count: Integer read FCount;
    property Objects[Index: Integer]: TObject read GetObject write PutObject;
    property Strings[Index: Integer]: WideString read Get write Put; default;
    property Names[Index: Integer]: WideString read GetName;
    property Values[const Name: WideString]: WideString read GetValue write SetValue;
    property ValueFromIndex[Index: Integer]: WideString read GetValueFromIndex write SetValueFromIndex;
    property Duplicates: TDuplicates read FDuplicates write FDuplicates;
    property Sorted: Boolean read FSorted write SetSorted;
    property NameValueSeparator: WideChar read FNameValueSeparator write FNameValueSeparator;
  end;
{$ENDIF}

  TclStringsUtils = class
  private
    FStrings: TStrings;
    FBatchSize: Integer;
    FCharSet: string;
    FOnProgress: TclProgressEvent;
  protected
    procedure DoProgress(ABytesProceed, ATotalBytes: Int64); virtual;
  public
    constructor Create(AStrings: TStrings); overload;
    constructor Create(AStrings: TStrings; const ACharSet: string); overload;

    class function LoadStrings(ASource: TStream; const ACharSet: string): TStrings; overload;
    class procedure LoadStrings(ASource: TStream; ADestination: TStrings; const ACharSet: string); overload;
    class procedure SaveStrings(ASource: TStrings; ADestination: TStream; const ACharSet: string); overload;

    class procedure LoadStrings(const ASourceFile: string; ADestination: TStrings; const ACharSet: string); overload;
    class procedure SaveStrings(ASource: TStrings; const ADestinationFile: string; const ACharSet: string); overload;

    procedure LoadStrings(ASource: TStream); overload;
    procedure SaveStrings(ADestination: TStream); overload;

    function AddTextStr(const Value: string; AddToLastString: Boolean = False): Integer;
    function InsertTextStr(const Value: string; AIndex: Integer; AddToLastString: Boolean = False): Integer;
    function AddTextStream(ASource: TStream): Integer; overload;
    function AddTextStream(ASource: TStream; AddToLastString: Boolean): Integer; overload;
    function AddTextStream(ASource: TStream; AddToLastString: Boolean; ACount: Integer): Integer; overload;
    function GetTextStr(AStartFrom, ACount: Integer): string;
    function GetStringsSize: Integer;
    function FindInStrings(const Value: string): Integer;

    property Strings: TStrings read FStrings;
    property CharSet: string read FCharSet write FCharSet;
    property BatchSize: Integer read FBatchSize write FBatchSize;
    property OnProgress: TclProgressEvent read FOnProgress write FOnProgress;
  end;

  TclErrorList = class
  private
    FList: TStrings;
    function GetCount: Integer;
    function GetErrorCodes(Index: Integer): Integer;
    function GetErrors(Index: Integer): string;
    function GetText: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddError(const AError: string; AErrorCode: Integer);
    procedure Clear;
    property Errors[Index: Integer]: string read GetErrors; default;
    property ErrorCodes[Index: Integer]: Integer read GetErrorCodes;
    property Count: Integer read GetCount;
    property Text: string read GetText;
  end;

  TclInterfaceListCompare = function (Item1, Item2: IInterface): Integer of object;

  TclInterfaceListHelper = class
  private
    class procedure QuickSort(AList: IInterfaceList; L, R: Integer; Compare: TclInterfaceListCompare);
    class procedure ExchangeItems(AList: IInterfaceList; Index1, Index2: Integer);
  public
    class procedure Sort(AList: IInterfaceList; Compare: TclInterfaceListCompare);
  end;

function AddTextStr(AList: TStrings; const Value: string; AddToLastString: Boolean = False): Integer;
function AddTextStream(AList: TStrings; ASource: TStream): Integer; overload;
function AddTextStream(AList: TStrings; ASource: TStream; AddToLastString: Boolean): Integer; overload;
function GetTextStr(AList: TStrings; AStartFrom, ACount: Integer): string;
function GetStringsSize(AList: TStrings): Integer;
function FindInStrings(AList: TStrings; const Value: string): Integer;

procedure GetTopLines(ASource: TStream; ATopLines: Integer; AMessage: TStrings);
function GetStreamAsString(AStream: TStream; ASize: Integer; DefaultChar: Char): string;
function GetBinTextPos(const ASubStr: TclString; AData: PclChar; ADataPos, ADataSize: Integer): Integer;
function BytesPos(const ASubBytes, ABytes: TclByteArray; AStartFrom, ALength: Integer): Integer;
procedure ByteArrayWriteWord(AData: Word; var ADestination: TclByteArray; var AIndex: Integer);
procedure ByteArrayWriteDWord(AData: DWORD; var ADestination: TclByteArray; var AIndex: Integer);
procedure ByteArrayWriteInt64(AData: Int64; var ADestination: TclByteArray; var AIndex: Integer);//TODO ByteArrayWriteULong, unsigned 64 is not supported in Delphi 7
function ByteArrayReadWord(const ASource: TclByteArray; var AIndex: Integer): Word;
function ByteArrayReadDWord(const ASource: TclByteArray; var AIndex: Integer): DWORD;
function ByteArrayReadInt64(const ASource: TclByteArray; var AIndex: Integer): Int64;//TODO ByteArrayReadULong, unsigned 64 is not supported in Delphi 7
function MakeWord(AByte1, AByte2: Byte): Word;
function GetCharByteCount(ACount: Integer): Integer;
function ByteArrayEquals(const Arr1, Arr2: TclByteArray): Boolean;
function ReversedBytes(const ABytes: TclByteArray): TclByteArray;
function GetFirstNonZeroIndex(const AValue: TclByteArray): Integer;
function FoldBytesWithZero(const Value: TclByteArray): TclByteArray;
function UnfoldBytesWithZero(const Value: TclByteArray): TclByteArray;
function ByteArrayReplace(const ASource: TclByteArray; const AOld: TclByteArray; const ANew: TclByteArray): TclByteArray;
function BytesToHex(const Value: TclByteArray; const ADelimiter: string): string; overload;
function BytesToHex(const Value: TclByteArray): string; overload;
function BytesToHex(Value: PByte; Count: Integer): string; overload;
function BytesToHex(Value: PclChar; Count: Integer): string; overload;
function HexToBytes(const Value: string): TclByteArray;

procedure SetLocalFileTime(const AFileName: string; ADate: TDateTime);
function GetLocalFileTime(const AFileName: string): TDateTime;
function GetFullFileName(const AFileName, AFolder: string): string;
function ForceFileDirectories(const AFilePath: string): Boolean;
function DeleteRecursiveDir(const ARoot: string): Boolean;
function MakeRelativePath(const ABasePath, ARelativePath: string): string;
function CombinePath(const ABasePath, ARelativePath: string): string;
function GetUniqueFileName(const AFileName: string): string;
function AddTrailingBackSlash(const APath: string; ASlash: Char = '\'): string;
function RemoveTrailingBackSlash(const APath: string; ASlash: Char = '\'): string;
function IsNetworkPath(const APath: string): Boolean;

function GetQuotedWordsString(AList: TStrings): string; overload;
function GetQuotedWordsString(AList: TStrings; const ADelimiter: Char): string; overload;
function GetQuotedWordsString(AList: TStrings; const ADelimiter, AQuoteBegin, AQuoteEnd: Char): string; overload;
procedure ExtractQuotedWords(const ASource: string; AList: TStrings); overload;
procedure ExtractQuotedWords(const ASource: string; AList: TStrings; const ADelimiter: Char); overload;
procedure ExtractQuotedWords(const ASource: string; AList: TStrings; const ADelimiter: Char;
  const AQuoteBegin: array of Char; const AQuoteEnd: array of Char; AIncludeQuotes: Boolean); overload;

function GetQuotedString(const S: string): string; overload;
function GetQuotedString(const S: string; const AQuote: Char): string; overload;
function GetQuotedString(const S: string; const AQuoteBegin: Char; const AQuoteEnd: Char): string; overload;
function ExtractQuotedString(const S: string): string; overload;
function ExtractQuotedString(const S: string; const AQuote: Char): string; overload;
function ExtractQuotedString(const S: string; const AQuoteBegin: Char; const AQuoteEnd: Char): string; overload;

procedure SplitText(const ASource: WideString; AList: TWideStringList; const ADelimiters: TCharSet); overload;
procedure SplitText(const ASource: string; AList: TStrings; const ADelimiters: TCharSet); overload;
procedure SplitText(const ASource: string; AList: TStrings; const ADelimiter: Char); overload;
function WordCount(const S: string; const WordDelims: TCharSet): Integer;
function WordPosition(const N: Integer; const S: string; const WordDelims: TCharSet): Integer;
function ExtractWord(N: Integer; const S: string; const WordDelims: TCharSet): string;
function ExtractNumeric(const ASource: string; AStartPos: Integer): string;

function TextPos(const SubStr, Str: string): Integer; overload;
function TextPos(const SubStr, Str: string; StartPos: Integer): Integer; overload;
function TextPos(const SubStr, Str: WideString; StartPos: Integer): Integer; overload;

function RTextPos(const SubStr, Str: String; StartPos: Integer = -1): Integer;

function TextPosOfAny(Values : array of Char; const Str: string; StartPos: Integer): Integer; overload;
function TextPosOfAny(Values : array of WideChar; const Str: WideString; StartPos: Integer): Integer; overload;

function ReversedString(const AStr: string): string;
function IndexOfStrArray(const S: string; AStrArray: array of string): Integer;
function StrArrayReplace(const ASource: WideString; const AOld: array of WideString; const ANew: WideString): WideString;
function WideStringReplace(const S, OldPattern, NewPattern: WideString): WideString;

function GetCorrectY2k(const AYear : Integer): Integer;
function TimeZoneBiasString: string;
function TimeZoneBiasToDateTime(const ABias: string): TDateTime;
function GlobalTimeToLocalTime(ATime: TDateTime): TDateTime;
function LocalTimeToGlobalTime(ATime: TDateTime): TDateTime;
function ConvertFileTimeToDateTime(AFileTime: TFileTime): TDateTime;

function DateTimeToMimeTime(ADateTime: TDateTime): string;
function MimeTimeToDateTime(const ADateTimeStr: string): TDateTime;
procedure ParseMimeTime(const ADateTimeStr: string; var ADateTime, ATimeZoneBias: TDateTime);

function GetCurrentThreadUser: string;

function AllocateWindow(Method: TWndMethod): HWND;
procedure DeallocateWindow(Wnd: HWND);

function clGetLastError(): Integer;

const
  DefaultBatchSize = 8192;
  cDays: array[1..7] of string = ('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat');
  cMonths: array[1..12] of string = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec');

implementation

uses
  clTranslator;

{$WARNINGS OFF}

function clGetLastError(): Integer;
begin
  Result := Integer(GetLastError());
end;

function TimeZoneBiasString: string;
var
  TimeZoneInfo: TTimeZoneInformation;
  TimeZoneID: DWORD;
  Bias: Integer;
  Sign: Char;
begin
  Bias := 0;
  TimeZoneID := GetTimeZoneInformation(TimeZoneInfo);
  if (TimeZoneID <> TIME_ZONE_ID_INVALID) then
  begin
    if (TimeZoneID = TIME_ZONE_ID_DAYLIGHT) then
    begin
      Bias := TimeZoneInfo.Bias + TimeZoneInfo.DaylightBias
    end else
    begin
      Bias := TimeZoneInfo.Bias;
    end;
  end;
  if (Bias > 0) then Sign := '-' else Sign := '+';
  Result := Format('%s%.2d%.2d', [Sign, Abs(Bias) div 60, Abs(Bias) mod 60]);
end;

function TimeZoneBiasToDateTime(const ABias: string): TDateTime;
var
  Sign: Char;
  Hour, Min: Word;
begin
  if (Length(ABias) > 4) and CharInSet(ABias[1], ['-', '+']) then
  begin
    Sign := ABias[1];
    Hour := StrToIntDef(Copy(ABias, 2, 2), 0);
    Min := StrToIntDef(Copy(ABias, 4, 2), 0);

    if not TryEncodeTime(Hour, Min, 0, 0, Result) then
    begin
      Result := 0;
    end;

    if (Sign = '-') and (Result <> 0) then Result := - Result;
  end else
  begin
    Result := 0;
  end;
end;

function GlobalTimeToLocalTime(ATime: TDateTime): TDateTime;
var
  ST: TSystemTime;
  FT: TFileTime;
begin
  DateTimeToSystemTime(ATime, ST);
  SystemTimeToFileTime(ST, FT);
  FileTimeToLocalFileTime(FT, FT);
  FileTimeToSystemTime(FT, ST);
  Result := SystemTimeToDateTime(ST);
end;

function LocalTimeToGlobalTime(ATime: TDateTime): TDateTime;
var
  ST: TSystemTime;
  FT: TFileTime;
begin
  DateTimeToSystemTime(ATime, ST);
  SystemTimeToFileTime(ST, FT);
  LocalFileTimeToFileTime(FT, FT);
  FileTimeToSystemTime(FT, ST);
  Result := SystemTimeToDateTime(ST);
end;
          
function ConvertFileTimeToDateTime(AFileTime: TFileTime): TDateTime;
var
  lpSystemTime: TSystemTime;
  LocalFileTime: TFileTime;
begin
  if FileTimeToLocalFileTime(AFileTime, LocalFileTime) then
  begin
    FileTimeToSystemTime(LocalFileTime, lpSystemTime);
    Result := SystemTimeToDateTime(lpSystemTime);
  end else
  begin
    Result := 0;
  end;
end;

function GetCorrectY2k(const AYear : Integer): Integer;
var
  twoDigitYear: Word;
begin
  Result := AYear;
  if (Result >= 100) then Exit;

{$IFDEF DELPHIXE}
  twoDigitYear := FormatSettings.TwoDigitYearCenturyWindow;
{$ELSE}
  twoDigitYear := TwoDigitYearCenturyWindow;
{$ENDIF}

  if (twoDigitYear > 0) then
  begin
    if (Result > twoDigitYear) then
    begin
      Result := Result + (((CurrentYear() div 100) - 1) * 100);
    end else
    begin
      Result := Result + ((CurrentYear() div 100) * 100);
    end;
  end else
  begin
    Result := Result + ((CurrentYear() div 100) * 100);
  end;
end;

function DateTimeToMimeTime(ADateTime: TDateTime): string;
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  DayName, MonthName: String;
begin
  DecodeDate(ADateTime, Year, Month, Day);
  DecodeTime(ADateTime, Hour, Min, Sec, MSec);
  DayName := cDays[DayOfWeek(ADateTime)];
  MonthName := cMonths[Month];
  Result := Format('%s, %d %s %d %.2d:%.2d:%.2d %s',
    [DayName, Day, MonthName, Year, Hour, Min, Sec, TimeZoneBiasString]);
end;

function MimeTimeToDateTime(const ADateTimeStr: string): TDateTime;
var
  timeZoneBias: TDateTime;
begin
  ParseMimeTime(ADateTimeStr, Result, timeZoneBias);
end;

procedure ParseMimeTime(const ADateTimeStr: string; var ADateTime, ATimeZoneBias: TDateTime);
  function ParseTime(const ASrc: string): TDateTime;
  var
    pm, am: Integer;
    src: string;
    h, m, s: Word;
  begin
    src := UpperCase(ASrc);
    pm := system.Pos('PM', src);
    am := system.Pos('AM', src);

    if (pm > 0) then
    begin
      src := system.Copy(src, 1, pm - 1);
    end;
    if (am > 0) then
    begin
      src := system.Copy(src, 1, am - 1);
    end;
    src := Trim(src);

    h := StrToIntDef(ExtractWord(1, src, [':']), 0);
    m := StrToIntDef(ExtractWord(2, src, [':']), 0);
    s := StrToIntDef(ExtractWord(3, src, [':']), 0);

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
    Result := EncodeTime(h, m, s, 0);
  end;

  function GetCurrentMonth: Word;
  var
    yy, dd: Word;
  begin
    DecodeDate(Date(), yy, Result, dd);
  end;

var
  Year, Month, Day: Word;
  DayName, MonthName, YearName, TimeName, ZoneName: String;
  Time: TDateTime;
  DateTimeStr: String;
  P: Integer;
  s: string;
begin
  ADateTime := 0.0;
  ATimeZoneBias := 0.0;
  Time := 0.0;
  Year := 0;
  Month := 0;
  Day := 0;
  DateTimeStr := Trim(ADateTimeStr);
  P := Pos(',', DateTimeStr);
  if (P > 0) then
  begin
    system.Delete(DateTimeStr, 1, Succ(P));
  end;
  s := Trim(DateTimeStr);
  DateTimeStr := s;
  P := Pos(' ', DateTimeStr);
  if (P > 0) then
  begin
    DayName := Copy(DateTimeStr, 1, Pred(P));
    Day := StrToInt(DayName);
    system.Delete(DateTimeStr, 1, P);
  end;
  s := Trim(DateTimeStr);
  DateTimeStr := s;
  P := Pos(' ', DateTimeStr);
  if (P > 0) then
  begin
    MonthName := Copy(DateTimeStr, 1, Pred(P));
    Month := Succ(IndexOfStrArray(MonthName, cMonths));
    if (Month = 0) then
    begin
      Month := GetCurrentMonth();
    end else
    begin
      system.Delete(DateTimeStr, 1, P);
    end;
  end;
  s := Trim(DateTimeStr);
  DateTimeStr := s;
  P := Pos(' ', DateTimeStr);
  if (P > 0) then
  begin
    YearName := Copy(DateTimeStr, 1, Pred(P));
    Year := StrToInt(YearName);
    if (Year < 100) then
    begin
      if (Year > 10) then
        Year := Year + 1900
      else if (Year <= 10) then
        Year := Year + 2000;
    end;
    system.Delete(DateTimeStr, 1, P);
  end;
  s := Trim(DateTimeStr);
  DateTimeStr := s;
  P := Pos(' ', DateTimeStr);
  if (P > 0) then
  begin
    TimeName := Copy(DateTimeStr, 1, Pred(P));
    Time := ParseTime(TimeName);
    system.Delete(DateTimeStr, 1, P);
  end;
  if (Year > 0) and (Month > 0) and (Day > 0) then
  begin
    P := Pos(' ', DateTimeStr);
    if (P > 0) then
    begin
      ZoneName := Copy(DateTimeStr, 1, Pred(P))
    end else
    begin
      ZoneName := DateTimeStr;
    end;
    ATimeZoneBias := TimeZoneBiasToDateTime(ZoneName);
    ADateTime := EncodeDate(Year, Month, Day);
    ADateTime := ADateTime + Time;
    ADateTime := ADateTime - ATimeZoneBias;
    ADateTime := GlobalTimeToLocalTime(ADateTime);
  end;
end;

{ TclBinaryData }

procedure TclBinaryData.Allocate(ASize: Integer);
begin
  Deallocate();
  FDataSize := ASize;
  if (FDataSize > 0) then
  begin
    AllocateMem(FData, FDataSize);
  end;
end;

constructor TclBinaryData.Create(ASize: Integer);
begin
  inherited Create();
  Allocate(ASize);
  CharSet := '';
end;

constructor TclBinaryData.Create(const ACharSet: string);
begin
  inherited Create();
  CharSet := ACharSet;
end;

constructor TclBinaryData.Create;
begin
  inherited Create();
  CharSet := '';
end;

procedure TclBinaryData.AllocateMem(var P: PByte; ASize: Integer);
begin
  GetMem(P, ASize);
end;

procedure TclBinaryData.DeallocateMem(var P: PByte);
begin
  FreeMem(P);
end;

constructor TclBinaryData.Create(const ACharSet: string; ASize: Integer);
begin
  inherited Create();
  Allocate(ASize);
  CharSet := ACharSet;
end;

procedure TclBinaryData.Deallocate;
begin
  DeallocateMem(FData);
  FData := nil;
  FDataSize := 0;
end;

destructor TclBinaryData.Destroy;
begin
  Deallocate();
  inherited Destroy();
end;

procedure TclBinaryData.FromBytes(ASource: TclByteArray);
begin
  FromBytes(ASource, 0, Length(ASource));
end;

procedure TclBinaryData.FromStream(ASource: TStream);
begin
  FromStream(ASource, ASource.Size);
end;

procedure TclBinaryData.FromBytes(ASource: TclByteArray; Index, Count: Integer);
var
  len: Integer;
begin
  len := Count;
  if (len > (Length(ASource) - Index)) then
  begin
    len := Length(ASource) - Index;
  end;

  if (len > 0) then
  begin
    Allocate(len);
    System.Move(ASource[Index], Data^, len);
  end else
  begin
    Allocate(0);
  end;
end;

procedure TclBinaryData.FromStream(ASource: TStream; Count: Integer);
var
  len: Integer;
begin
  len := Count;
  if (len > (ASource.Size - ASource.Position)) then
  begin
    len := ASource.Size - ASource.Position;
  end;
  Allocate(len);
  ASource.Read(Data^, len);
end;

procedure TclBinaryData.FromString(const ASource: string);
var
  b: TclByteArray;
begin
{$IFNDEF DELPHI2005}b := nil;{$ENDIF}
  if (Length(ASource) > 0) then
  begin
    b := TclTranslator.GetBytes(ASource, CharSet);
    Allocate(Length(b));
    System.Move(b[0], Data^, Length(b));
  end else
  begin
    Allocate(0);
  end;
end;

procedure TclBinaryData.FromStrings(ASource: TStrings; ExcludeTrailingCrlf: Boolean);
var
  I, L, Size: Integer;
  P: PclChar;
  S, LB: TclString;
begin
  Size := 0;
  LB := #13#10;
  for I := 0 to ASource.Count - 1 do
  begin
    Inc(Size, Length(ASource[I]) + Length(LB));
  end;
  if ExcludeTrailingCrlf and (Size > 0) then
  begin
    Size := Size - Length(LB);
  end;
  Allocate(Size);
  P := Pointer(Data);
  for I := 0 to ASource.Count - 1 do
  begin
    S := GetTclString(ASource[I]);
    L := Length(S);
    if L <> 0 then
    begin
      System.Move(Pointer(S)^, P^, L);
      Inc(P, L);
    end;
    L := Length(LB);
    if (L <> 0) and (I <> ASource.Count - 1) then
    begin
      System.Move(Pointer(LB)^, P^, L);
      Inc(P, L);
    end;
  end;
end;

procedure TclBinaryData.FromStrings(ASource: TStrings);
begin
  FromStrings(ASource, True);
end;

procedure TclBinaryData.FromWideString(const ASource: WideString);
var
  len: Integer;
begin
  len := Length(ASource) * 2;
  Allocate(len);
  System.Move(Pointer(ASource)^, Data^, len);
end;

function TclBinaryData.GetDataBytes(Index: Integer): Byte;
var
  p: Pointer;
begin
  p := Pointer(TclIntPtr(Data) + Index);
  Result := Byte(p^);
end;

procedure TclBinaryData.Reduce(ANewSize: Integer);
begin
  if (FDataSize > ANewSize) then
  begin
    FDataSize := ANewSize;
  end;
end;

procedure TclBinaryData.SetDataBytes(Index: Integer; const Value: Byte);
var
  p: Pointer;
begin
  p := Pointer(TclIntPtr(Data) + Index);
  Byte(p^) := Value;
end;

function TclBinaryData.ToBytes: TclByteArray;
begin
  if (DataSize > 0) then
  begin
    SetLength(Result, DataSize);
    system.Move(Data^, Result[0], DataSize);
  end else
  begin
    Result := nil;
  end;
end;

procedure TclBinaryData.ToStream(ADestination: TStream);
begin
  if (DataSize > 0) then
  begin
    ADestination.Write(Data^, DataSize);
  end;
end;

function TclBinaryData.ToString: string;
var
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  if (DataSize > 0) then
  begin
    SetLength(buf, DataSize);
    system.Move(Data^, buf[0], DataSize);
    Result := TclTranslator.GetString(buf, 0, DataSize, CharSet);
  end else
  begin
    Result := '';
  end;
end;

procedure TclBinaryData.ToStrings(ADestination: TStrings);
begin
  ADestination.Clear();
  AddTextStr(ADestination, ToString());
end;

function TclBinaryData.ToWideString: WideString;
var
  len: Integer;
begin
  if (DataSize = 0) then
  begin
    Result := '';
    Exit;
  end;

  SetLength(Result, DataSize div 2);
  System.Move(Data^, Pointer(Result)^, DataSize);
  len := Length(Result);
  if (Result[len] = #0) then
  begin
    Dec(len);
    SetLength(Result, len);
  end;
end;

function AddTextStr(AList: TStrings; const Value: string; AddToLastString: Boolean): Integer;
var
  utils: TclStringsUtils;
begin
  utils := TclStringsUtils.Create(AList);
  try
    Result := utils.AddTextStr(Value, AddToLastString);
  finally
    utils.Free();
  end;
end;

function AddTextStrCount(AList: TStrings; const Value: string;
  var AddToLastString: Boolean; var AHeadCount: Integer; ALinesCount: Integer): Boolean;
var
  P, Start: PChar;
  S: string;
  b: Boolean;
begin
  b := AddToLastString;
  P := Pointer(Value);

  AddToLastString := False;
  Result := False;

  if (P <> nil) then
  begin
    while (not Result) and (P^ <> #0) do
    begin
      Start := P;
      while not CharInSet(P^, [#0, #10, #13]) do Inc(P);
      SetString(S, Start, P - Start);
      if b and (AList.Count > 0) then
      begin
        AList[AList.Count - 1] := AList[AList.Count - 1] + S;
        b := False;
      end else
      begin
        AList.Add(S);
      end;
      if (Length(AList[AList.Count - 1]) = 0) and (AHeadCount = 0) then
      begin
        AHeadCount := AList.Count;
      end;
      Result := (AHeadCount > 0) and (AList.Count >= AHeadCount + ALinesCount);
      if P^ = #13 then Inc(P);
      if P^ = #10 then Inc(P);
    end;
    AddToLastString := (Length(Value) > 1) and ((P - 2)^ <> #13) and ((P - 1)^ <> #10);
  end;
end;

procedure GetTopLines(ASource: TStream; ATopLines: Integer; AMessage: TStrings);
var
  buf: string;
  bufSize, bytesRead, headCount: Integer;
  addToLastSring: Boolean;
begin
  AMessage.BeginUpdate();
  try
    AMessage.Clear();

    bufSize := ASource.Size - ASource.Position;
    if (bufSize > 76) then
    begin
      bufSize := 76;
    end;

    headCount := 0;
    addToLastSring := False;
    repeat
      SetString(buf, nil, bufSize);
      bytesRead := ASource.Read(Pointer(buf)^, bufSize);
      if bytesRead = 0 then Break;
      SetLength(buf, bytesRead);
    until AddTextStrCount(AMessage, buf, addToLastSring, headCount, ATopLines);
  finally
    AMessage.EndUpdate();
  end;
end;

function AddTextStream(AList: TStrings; ASource: TStream): Integer;
var
  utils: TclStringsUtils;
begin
  utils := TclStringsUtils.Create(AList);
  try
    Result := utils.AddTextStream(ASource);
  finally
    utils.Free();
  end;
end;

function AddTextStream(AList: TStrings; ASource: TStream; AddToLastString: Boolean): Integer;
var
  utils: TclStringsUtils;
begin
  utils := TclStringsUtils.Create(AList);
  try
    Result := utils.AddTextStream(ASource, AddToLastString);
  finally
    utils.Free();
  end;
end;

function GetTextStr(AList: TStrings; AStartFrom, ACount: Integer): string;
var
  utils: TclStringsUtils;
begin
  utils := TclStringsUtils.Create(AList);
  try
    Result := utils.GetTextStr(AStartFrom, ACount);
  finally
    utils.Free();
  end;
end;

function TextPos(const SubStr, Str: string): Integer;
begin
  Result := TextPos(SubStr, Str, 1);
end;

function TextPos(const SubStr, Str: string; StartPos: Integer): Integer;
{$IFDEF DELPHIXE3}
begin
  Result := System.Pos(SubStr, Str, StartPos);
{$ELSE}
var
  I, LIterCnt, L, J: Integer;
  PSubStr, PS: PChar;
begin
  L := Length(SubStr);
  LIterCnt := Length(Str) - StartPos - L + 1;

  if (StartPos > 0) and (LIterCnt >= 0) and (L > 0) then
  begin
    PSubStr := PChar(SubStr);
    PS := PChar(Str);
    Inc(PS, StartPos - 1);

    for I := 0 to LIterCnt do
    begin
      J := 0;
      while (J >= 0) and (J < L) do
      begin
        if PS[I + J] = PSubStr[J] then
          Inc(J)
        else
          J := -1;
      end;
      if J >= L then
      begin
        Result := I + StartPos;
        Exit;
      end;
    end;
  end;

  Result := 0;
{$ENDIF}
end;

function TextPos(const SubStr, Str: WideString; StartPos: Integer): Integer;
{$IFDEF DELPHIXE3}
begin
  Result := System.Pos(SubStr, Str, StartPos);
{$ELSE}
var
  I, LIterCnt, L, J: Integer;
  PSubStr, PS: PWideChar;
begin
  L := Length(SubStr);
  LIterCnt := Length(Str) - StartPos - L + 1;

  if (StartPos > 0) and (LIterCnt >= 0) and (L > 0) then
  begin
    PSubStr := PWideChar(SubStr);
    PS := PWideChar(Str);
    Inc(PS, StartPos - 1);

    for I := 0 to LIterCnt do
    begin
      J := 0;
      while (J >= 0) and (J < L) do
      begin
        if PS[I + J] = PSubStr[J] then
          Inc(J)
        else
          J := -1;
      end;
      if J >= L then
      begin
        Result := I + StartPos;
        Exit;
      end;
    end;
  end;

  Result := 0;
{$ENDIF}
end;

function RTextPos(const SubStr, Str: String; StartPos: Integer = -1): Integer;
var
  i, len: Integer;
begin
  Result := 0;
  len := Length(SubStr);
  if StartPos = -1 then
  begin
    StartPos := Length(Str);
  end;
  if StartPos >= (Length(Str) - len + 1) then
  begin
    StartPos := (Length(Str) - len + 1);
  end;
  for i := StartPos downto 1 do
  begin
    if SameText(Copy(Str, i, len), SubStr) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function TextPosOfAny(Values : array of Char; const Str: string; StartPos: Integer): Integer;
  function CharInArray(Value: Char; Values : array of Char): Boolean;
  var
    i: Integer;
  begin
    for i := Low(Values) to High(Values) do
    begin
      Result := (Values[i] = Value);
      if (Result) then Exit;
    end;
    Result := False;
  end;

var
  i: Integer;
begin
  for i := StartPos to Length(Str) do
  begin
    if CharInArray(Str[i], Values) then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := 0;
end;

function TextPosOfAny(Values : array of WideChar; const Str: WideString; StartPos: Integer): Integer;
  function CharInArray(Value: WideChar; Values : array of WideChar): Boolean;
  var
    i: Integer;
  begin
    for i := Low(Values) to High(Values) do
    begin
      Result := (Values[i] = Value);
      if (Result) then Exit;
    end;
    Result := False;
  end;
  
var
  i: Integer;
begin
  for i := StartPos to Length(Str) do
  begin
    if CharInArray(Str[i], Values) then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := 0;
end;

function GetQuotedWordsString(AList: TStrings): string;
begin
  Result := GetQuotedWordsString(AList, ' ', '"', '"');
end;

function GetQuotedWordsString(AList: TStrings; const ADelimiter: Char): string;
begin
  Result := GetQuotedWordsString(AList, ADelimiter, '"', '"');
end;

function GetQuotedWordsString(AList: TStrings; const ADelimiter, AQuoteBegin, AQuoteEnd: Char): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to AList.Count - 1 do
  begin
    if (Pos(ADelimiter, AList[i]) > 0) or (Pos(AQuoteBegin, AList[i]) > 0) or (Pos(AQuoteEnd, AList[i]) > 0) then
    begin
      Result := Result + AQuoteBegin + AList[i] + AQuoteEnd + ADelimiter;
    end else
    begin
      Result := Result + AList[i] + ADelimiter;
    end;
  end;

  Result := Trim(Result);
end;

procedure ExtractQuotedWords(const ASource: string; AList: TStrings);
begin
  ExtractQuotedWords(ASource, AList, ' ', ['"'], ['"'], False);
end;

procedure ExtractQuotedWords(const ASource: string; AList: TStrings; const ADelimiter: Char);
begin
  ExtractQuotedWords(ASource, AList, ADelimiter, ['"'], ['"'], False);
end;

procedure ExtractQuotedWords(const ASource: string; AList: TStrings; const ADelimiter: Char;
  const AQuoteBegin: array of Char; const AQuoteEnd: array of Char; AIncludeQuotes: Boolean);

  function GetQuoteInd(ASymbol: Char; AQuote: array of Char; var AIndex: Integer): Boolean;
  var
    i: Integer;
  begin
    for i := Low(AQuote) to High(AQuote) do
    begin
      if (ASymbol = AQuote[i]) then
      begin
        AIndex := i;
        Result := True;
        Exit;
      end;
    end;
    
    AIndex := -1;
    Result := False;
  end;

var
  i, quoteInd, quoteCount: Integer;
  value: string;
  inQuote, isQuoted: Boolean;
  c: Char;
begin
  Assert(Length(AQuoteBegin) = Length(AQuoteEnd));

  AList.BeginUpdate();
  try
    AList.Clear();
    value := '';
    inQuote := False;
    quoteInd := -1;
    quoteCount := 0;
    isQuoted := False;

    for i := 1 to Length(ASource) do
    begin
      c := ASource[i];

      if ((not inQuote) and GetQuoteInd(c, AQuoteBegin, quoteInd)) then
      begin
        Inc(quoteCount);

        if (isQuoted and (value <> '')) then
        begin
          AList.Add(value);
          value := '';
        end;

        if AIncludeQuotes then
        begin
          value := value + c;
        end;
        inQuote := True;
        isQuoted := True;
      end else
      if (inQuote) then
      begin
        if ((AQuoteBegin[quoteInd] <> AQuoteEnd[quoteInd]) and (c = AQuoteBegin[quoteInd])) then
        begin
          Inc(quoteCount);
        end else
        if (c = AQuoteEnd[quoteInd]) then
        begin
          Dec(quoteCount);
        end;

        if (quoteCount = 0) then
        begin
          if (AIncludeQuotes) then
          begin
            value := value + c;
          end;
          inQuote := False;
        end else
        begin
          value := value + c;
        end;
      end else
      if ((not inQuote) and (c = ADelimiter)) then
      begin
        if isQuoted or (value <> '') then
        begin
          AList.Add(value);
          value := '';
          isQuoted := False;
        end;
      end else
      begin
        value := value + c;
      end;
    end;

    if isQuoted or (value <> '') then
    begin
      AList.Add(value);
    end;
  finally
    AList.EndUpdate();
  end;
end;

procedure SplitText(const ASource: WideString; AList: TWideStringList; const ADelimiters: TCharSet);
var
  P, P1: PWideChar;
  S: WideString;
  c: TclChar;
begin
  AList.BeginUpdate();
  try
    AList.Clear();
    P := PWideChar(ASource);
    c := TclChar(P^);
    while c in [#1..#8,#10..#31] do
    begin
      P := CharNextW(P);
      c := TclChar(P^);
    end;

    while P^ <> #0 do
    begin
      P1 := P;
      c := TclChar(P^);
      while (P^ <> #0) and (not (c in [#1..#8,#10..#31])) and (not (c in ADelimiters)) do
      begin
        P := CharNextW(P);
        c := TclChar(P^);
      end;
      SetString(S, P1, P - P1);

      AList.Add(S);
      c := TclChar(P^);
      while c in [#1..#8,#10..#31] do
      begin
        P := CharNextW(P);
        c := TclChar(P^);
      end;

      c := TclChar(P^);
      if (c in ADelimiters) then
      begin
        P1 := P;
        if CharNextW(P1)^ = #0 then
        begin
          AList.Add('');
        end;

        repeat
          P := CharNextW(P);
          c := TclChar(P^);
        until not (c in [#1..#8,#10..#31]);
      end;
    end;
  finally
    AList.EndUpdate();
  end;
end;

procedure SplitText(const ASource: string; AList: TStrings; const ADelimiter: Char);
begin
  SplitText(ASource, AList, [ADelimiter]);
end;

procedure SplitText(const ASource: string; AList: TStrings; const ADelimiters: TCharSet);
var
  P, P1: PChar;
  S: string;
begin
  AList.BeginUpdate();
  try
    AList.Clear();
    P := PChar(ASource);
    while CharInSet(P^, [#1..#8,#10..#31]) do
    begin
      P := CharNext(P);
    end;

    while P^ <> #0 do
    begin
      P1 := P;
      while (P^ <> #0) and (not CharInSet(P^, [#1..#8,#10..#31])) and (not CharInSet(P^, ADelimiters)) do
      begin
        P := CharNext(P);
      end;
      SetString(S, P1, P - P1);

      AList.Add(S);
      while CharInSet(P^, [#1..#8,#10..#31]) do
      begin
        P := CharNext(P);
      end;

      if (P^ in ADelimiters) then
      begin
        P1 := P;
        if CharNext(P1)^ = #0 then
        begin
          AList.Add('');
        end;

        repeat
          P := CharNext(P);
        until not CharInSet(P^, [#1..#8,#10..#31]);
      end;
    end;
  finally
    AList.EndUpdate();
  end;
end;

function WordCount(const S: string; const WordDelims: TCharSet): Integer;
var
  SLen, I: Cardinal;
begin
  Result := 0;
  I := 1;
  SLen := Length(S);
  while I <= SLen do
  begin
    while (I <= SLen) and (S[I] in WordDelims) do Inc(I);
    if I <= SLen then Inc(Result);
    while (I <= SLen) and not(S[I] in WordDelims) do Inc(I);
  end;
end;

function WordPosition(const N: Integer; const S: string;
  const WordDelims: TCharSet): Integer;
var
  Count, I: Integer;
begin
  Count := 0;
  I := 1;
  Result := 0;
  while (I <= Length(S)) and (Count <> N) do
  begin
    while (I <= Length(S)) and (S[I] in WordDelims) do Inc(I);
    if I <= Length(S) then Inc(Count);
    if Count <> N then
      while (I <= Length(S)) and not (S[I] in WordDelims) do Inc(I)
    else Result := I;
  end;
end;

function ExtractWord(N: Integer; const S: string;
  const WordDelims: TCharSet): string;
var
  I: Word;
  Len: Integer;
begin
  Len := 0;
  I := WordPosition(N, S, WordDelims);
  if I <> 0 then
  begin
    while (I <= Length(S)) and not(S[I] in WordDelims) do
    begin
      Inc(Len);
      SetLength(Result, Len);
      Result[Len] := S[I];
      Inc(I);
    end;
  end;
  SetLength(Result, Len);
end;

function ExtractQuotedString(const S: string): string;
begin
  Result := ExtractQuotedString(S, '"', '"');
end;

function ExtractQuotedString(const S: string; const AQuote: Char): string;
begin
  Result := ExtractQuotedString(S, AQuote, AQuote);
end;

function ExtractQuotedString(const S: string; const AQuoteBegin: Char; const AQuoteEnd: Char): string;
begin
  Result := S;
  if Length(Result) < 2 then Exit;
  if ((Result[1] = AQuoteBegin) and (Result[Length(Result)] = AQuoteEnd)) then
  begin
    Result := System.Copy(Result, 2, Length(Result) - 2);
  end;
end;

function GetQuotedString(const S: string): string;
begin
  Result := GetQuotedString(S, '"', '"');
end;

function GetQuotedString(const S: string; const AQuote: Char): string;
begin
  Result := GetQuotedString(S, AQuote, AQuote);
end;

function GetQuotedString(const S: string; const AQuoteBegin: Char; const AQuoteEnd: Char): string;
begin
  if (S = '') or ((S <> '') and (S[1] <> AQuoteBegin) and (S[Length(S)] <> AQuoteEnd)) then
  begin
    Result := AQuoteBegin + S + AQuoteEnd;
  end else
  begin
    Result := S;
  end;
end;

function ExtractNumeric(const ASource: string; AStartPos: Integer): string;
var
  ind: Integer;
begin
  ind := AStartPos;
  while ((ind <= Length(ASource)) and CharInSet(ASource[ind], ['0'..'9'])) do
  begin
    Inc(ind);
  end;
  Result := system.Copy(ASource, AStartPos, ind - AStartPos);
end;

function GetDataAsText(Data: PclChar; Size: Integer; DefaultChar: Char): string;
var
  i: Integer;
  s: string;
begin
  s := TclTranslator.GetString(Data, Size, '');

  Result := '';
  for i := 1 to Length(s) do
  begin
    if (s[i] < #32) and not CharInSet(s[i], [#9, #10, #13]) then
    begin
      Result := Result + DefaultChar;
    end else
    begin
      Result := Result + s[i];
    end;
  end;
end;

function GetStreamAsString(AStream: TStream; ASize: Integer; DefaultChar: Char): string;
var
  p: PclChar;
  StreamPos: Integer;
begin
  StreamPos := AStream.Position;
  if (ASize = 0) or (ASize > AStream.Size) then
  begin
    ASize := AStream.Size;
  end;
  GetMem(p, ASize + 1);
  try
    AStream.Position := 0;
    ZeroMemory(p, ASize + 1);
    AStream.Read(p^, ASize);
    Result := GetDataAsText(p, ASize, DefaultChar);
  finally
    FreeMem(p);
    AStream.Position := StreamPos;
  end;
end;

procedure SetLocalFileTime(const AFileName: string; ADate: TDateTime);
var
  hFile: THandle;
  filedate: TFileTime;
  sysdate: TSystemTime;
begin
  hFile := CreateFile(PChar(AFileName), GENERIC_WRITE, FILE_SHARE_READ, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
  if (hFile <> INVALID_HANDLE_VALUE) then
  begin
    DateTimeToSystemTime(ADate, sysdate);
    SystemTimeToFileTime(sysdate, filedate);
    LocalFileTimeToFileTime(filedate, filedate);
    SetFileTime(hFile, @filedate, @filedate, @filedate);
    CloseHandle(hFile);
  end;
end;

function GetLocalFileTime(const AFileName: string): TDateTime;
var
  hFile: THANDLE;
  CreationTime, LastAccessTime, LastWriteTime: TFileTime;
begin
  hFile := CreateFile(PChar(AFileName), 0, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  if (hFile <> INVALID_HANDLE_VALUE) then
  begin
    GetFileTime(hFile, @CreationTime, @LastAccessTime, @LastWriteTime);
    CloseHandle(hFile);
    Result := ConvertFileTimeToDateTime(LastWriteTime);
  end else
  begin
    Result := Now();
  end;
end;

function GetFullFileName(const AFileName, AFolder: string): string;
begin
  Result := AddTrailingBackSlash(AFolder) + ExtractFileName(AFileName);
end;

function ForceFileDirectories(const AFilePath: string): Boolean;
  function ForceDirs(Dir: String): Boolean;
  begin
    Result := True;
    if Length(Dir) = 0 then Exit;
    Dir := ExcludeTrailingBackslash(Dir);
    if (Length(Dir) < 3) or DirectoryExists(Dir)
      or (ExtractFilePath(Dir) = Dir) then Exit; // avoid 'xyz:\' problem.
    Result := ForceDirs(ExtractFilePath(Dir)) and CreateDir(Dir);
  end;

begin
  Result := ForceDirs(ExtractFilePath(AFilePath));
end;

function DeleteRecursiveDir(const ARoot: string): Boolean;
var
  root: string;
  sr: TSearchRec;
begin
  root := ExcludeTrailingBackslash(ARoot);
  if FindFirst(root + '\*.*', faAnyFile, sr) = 0 then
  begin
    repeat
      if (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        if (sr.Attr and faDirectory) > 0 then
        begin
          DeleteRecursiveDir(root + '\' + sr.Name);
        end else
        begin
          DeleteFile(root + '\' + sr.Name);
        end;
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
  Result := RemoveDir(ARoot);
end;

function IndexOfStrArray(const S: string; AStrArray: array of string): Integer;
begin
  for Result := Low(AStrArray) to High(AStrArray) do
  begin
    if (CompareText(AStrArray[Result], S) = 0) then Exit;
  end;
  Result := -1;
end;

function StrArrayReplace(const ASource: WideString; const AOld: array of WideString; const ANew: WideString): WideString;
  procedure InitLexemLengths(var ALexemLengths: array of Integer);
  var
    i: Integer;
  begin
    for i := Low(ALexemLengths) to High(ALexemLengths) do
    begin
      ALexemLengths[i] := 1;
    end;
  end;
  
  function IsInLexem(AW: WideChar; const ACheckLexems: array of WideString; var ALexemLengths: array of Integer): Boolean;
  var
    i: Integer;
    w: WideChar;
  begin
    Result := False;

    w := AW;
    CharLowerBuffW(@w, 1);
    for i := Low(ACheckLexems) to High(ACheckLexems) do
    begin
      if (ACheckLexems[i][ALexemLengths[i]] = w) then
      begin
        Inc(ALexemLengths[i]);
        Result := True;
      end;
    end;
  end;

  function IsLexemCompleted(const ACheckLexems: array of WideString; const ALexemLengths: array of Integer): Boolean;
  var
    i: Integer;
  begin
    for i := Low(ACheckLexems) to High(ACheckLexems) do
    begin
      if (Length(ACheckLexems[i]) = (ALexemLengths[i] - 1)) then
      begin
        Result := True;
        Exit;
      end;
    end;
    Result := False;
  end;

var
  next: PWideChar;
  len: Integer;
  lexemLengths: array of Integer;
  s: WideString;
begin
  Result := '';

  len := Length(ASource);
  if (len = 0) then Exit;

  s := '';
  SetLength(lexemLengths, Length(AOld));
  InitLexemLengths(lexemLengths);

  next := @ASource[1];

  while (len > 0) do
  begin
    if IsInLexem(next^, AOld, lexemLengths) then
    begin
      s := s + next^;
    end else
    begin
      Result := Result + s + next^;
      s := '';
      InitLexemLengths(lexemLengths);
    end;

    if IsLexemCompleted(AOld, lexemLengths) then
    begin
      Result := Result + ANew;
      s := '';
      InitLexemLengths(lexemLengths);
    end;

    Inc(next);
    Dec(len);
  end;

  Result := Result + s;
end;

function WideStringReplace(const S, OldPattern, NewPattern: WideString): WideString;
var
  SearchStr, Patt, NewStr: WideString;
  Offset: Integer;
begin
  SearchStr := S;
  Patt := OldPattern;

  NewStr := S;
  Result := '';
  while (SearchStr <> '') do
  begin
    Offset := system.Pos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + system.Copy(NewStr, 1, Offset - 1) + NewPattern;
    NewStr := system.Copy(NewStr, Offset + Length(OldPattern), MaxInt);
    SearchStr := system.Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

function ReversedString(const AStr: string): string;
var
  I: Integer;
  P: PChar;
begin
  SetLength(Result, Length(AStr));
  P := PChar(Result);
  for I := Length(AStr) downto 1 do
  begin
    P^ := AStr[I];
    Inc(P);
  end;
end;

function ReversedBytes(const ABytes: TclByteArray): TclByteArray;
var
  I: Integer;
  P: PByte;
begin
  SetLength(Result, Length(ABytes));
  P := PByte(Result);
  for I := Length(ABytes) - 1 downto 0 do
  begin
    P^ := ABytes[I];
    Inc(P);
  end;
end;

function GetFirstNonZeroIndex(const AValue: TclByteArray): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Length(AValue) - 1 do
  begin
    if (AValue[i] <> 0) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function FoldBytesWithZero(const Value: TclByteArray): TclByteArray;
begin
  SetLength(Result, Length(Value) + 1);
  Result[0] := 0;
  System.Move(Value[0], Result[1], Length(Value));
end;

function UnfoldBytesWithZero(const Value: TclByteArray): TclByteArray;
var
  ind: Integer;
begin
  ind := GetFirstNonZeroIndex(Value);
  if (ind < 0) then
  begin
    ind := 0;
  end;

  SetLength(Result, Length(Value) - ind);
  System.Move(Value[ind], Result[0], Length(Result));
end;

function ByteArrayReplace(const ASource: TclByteArray; const AOld: TclByteArray; const ANew: TclByteArray): TclByteArray;
  procedure ResizeByteArray(var Arr: TclByteArray; Index, Increment: Integer);
  begin
    if (Index >= Length(Arr)) then
    begin
      SetLength(Arr, Index + Increment * 4);
    end;
  end;
  
var
  ind, resultInd: Integer;
  len, newLen: Integer;
  lexemLength: Integer;
  s: TclByteArray;
begin
  len := Length(ASource);
  newLen := Length(ANew);
  SetLength(Result, len);
  SetLength(s, Length(AOld));

  ind := 0;
  resultInd := 0;
  lexemLength := 0;

  while (len > 0) do
  begin
    if (ASource[ind] = AOld[lexemLength]) then
    begin
      s[lexemLength] := ASource[ind];
      Inc(lexemLength);
    end else
    begin
      if (lexemLength > 0) then
      begin
        ResizeByteArray(Result, resultInd + lexemLength + 1, newLen);
        System.Move(s[0], Result[resultInd], lexemLength);
        Inc(resultInd, lexemLength);
      end;
      Result[resultInd] := ASource[ind];
      Inc(resultInd);
      lexemLength := 0;
    end;

    if (Length(AOld) = lexemLength) then
    begin
      ResizeByteArray(Result, resultInd + newLen, newLen);
      System.Move(ANew[0], Result[resultInd], newLen);
      Inc(resultInd, newLen);
      lexemLength := 0;
    end;

    Inc(ind);
    Dec(len);
  end;

  if (lexemLength > 0) then
  begin
    ResizeByteArray(Result, resultInd + lexemLength, newLen);
    System.Move(s[0], Result[resultInd], lexemLength);
    Inc(resultInd, lexemLength);
  end;

  SetLength(Result, resultInd);
end;

function BytesToHex(const Value: TclByteArray): string;
begin
  Result := BytesToHex(Value, '');
end;

function BytesToHex(const Value: TclByteArray; const ADelimiter: string): string; overload;
var
  i: Integer;
begin
  Result := '';
  if (Value = nil) then Exit;

  for i := 0 to Length(Value) - 1 do
  begin
    Result := Result + IntToHex(Value[i], 2);

    if (i + 1 < Length(Value)) then
    begin
      Result := Result + ADelimiter;
    end;
  end;
end;

function HexToBytes(const Value: string): TclByteArray;
var
  i, k, len: Integer;
  s: string;
begin
  len := Length(Value);

  SetLength(Result, len div 2);

  i := 1;
  k := 0;
  while (i < len) do
  begin
    s := '$' + Value[i] + Value[i + 1];
    Result[k] := StrToInt(s);
    Inc(k);
    Inc(i, 2);
  end;
end;

function BytesToHex(Value: PByte; Count: Integer): string;
begin
  Result := BytesToHex(PclChar(Value), Count);
end;

function BytesToHex(Value: PclChar; Count: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
  begin
    Result := Result + IntToHex(Byte(Value[i]), 2);
  end;
end;

function MakeRelativePath(const ABasePath, ARelativePath: string): string;
  procedure GetPathList(const APath: string; AList: TStrings);
  var
    i: Integer;
    s: string;
  begin
    s := '';
    AList.Clear();
    for i := Length(APath) downto 1 do
    begin
      if (APath[i] = '\') then
      begin
        if (s <> '') then
        begin
          AList.Add(s);
        end;
        s := '';
      end else
      begin
        s := APath[i] + s;
      end;
    end;
    if (s <> '') then
    begin
      AList.Add(s);
    end;
  end;

  function MatchPathLists(ABaseList, ARelList: TStrings): string;
  var
    i, j: Integer;
  begin
    Result := '';
    
    i := ABaseList.Count - 1;
    j := ARelList.Count - 1;
    while (i >= 0) and (j >= 0) and (ABaseList[i] = ARelList[j]) do
    begin
      Dec(i);
      Dec(j);
    end;

    while (i >= 0) do
    begin
      Result := Result + '..\';
      Dec(i);
    end;

    while (j >= 1) do
    begin
      Result := Result + ARelList[j] + '\';
      Dec(j);
    end;

    Result := Result + ARelList[j];
  end;

var
  baseList, relList: TStrings;
begin
  Result := '';
  baseList := nil;
  relList := nil;
  try
    baseList := TStringList.Create();
    relList := TStringList.Create();
    
    GetPathList(ExtractFilePath(ABasePath), baseList);
    GetPathList(ARelativePath, relList);

    Result := MatchPathLists(baseList, relList);
  finally
    relList.Free();
    baseList.Free();
  end;
end;

function CombinePath(const ABasePath, ARelativePath: string): string;
var
  basePath: string;
begin
  basePath := ABasePath;
  if (basePath = '') then
  begin
    basePath := '.\';
  end;
  if (basePath[Length(basePath)] = DriveDelim) then
  begin
    basePath := basePath + '\';
  end;
  
  if (ARelativePath = '') then
  begin
    Result := RemoveTrailingBackSlash(basePath);
  end else
  begin
    basePath := ExpandFileName(basePath);
    Result := RemoveTrailingBackSlash(ExpandFileName(AddTrailingBackSlash(basePath) + ARelativePath));
  end;
end;

function GetUniqueFileName(const AFileName: string): string;
var
  s: string;
  i, ind: Integer;
begin
  i := 1;
  Result := AFileName;
  s := Result;
  ind := RTextPos('.', s);
  if (ind < 1) then
  begin
    s := s + '.';
    ind := Length(s);
  end;
  while FileExists(Result) do
  begin
    Result := system.Copy(s, 1, ind - 1) + Format('%d', [i]) + system.Copy(s, ind, Length(s));
    Inc(i);
  end;
  if (Length(Result) > 0) and (Result[Length(Result)] = '.') then
  begin
    system.Delete(Result, Length(Result), 1);
  end;
end;

function AddTrailingBackSlash(const APath: string; ASlash: Char): string;
begin
  Result := APath; 
  if (Result <> '') and (Result[Length(Result)] <> ASlash) then
  begin
    Result := Result + ASlash;
  end;
end;

function RemoveTrailingBackSlash(const APath: string; ASlash: Char): string;
begin
  Result := APath; 
  if (Result <> '') and (Result[Length(Result)] = ASlash) then
  begin
    Delete(Result, Length(Result), 1);
  end;
end;

function IsNetworkPath(const APath: string): Boolean;
const
  uncPrefix = '\\';
begin
  Result := (Length(APath) > Length(uncPrefix)) and (Pos(uncPrefix, APath) = 1);
end;

procedure ByteArrayWriteWord(AData: Word; var ADestination: TclByteArray; var AIndex: Integer);
begin
  ADestination[AIndex] := AData div 256;
  Inc(AIndex);
  ADestination[AIndex] := AData mod 256;
  Inc(AIndex);
end;

procedure ByteArrayWriteDWord(AData: DWORD; var ADestination: TclByteArray; var AIndex: Integer);
begin
  ByteArrayWriteWord(Hiword(AData), ADestination, AIndex);
  ByteArrayWriteWord(Loword(AData), ADestination, AIndex);
end;

procedure ByteArrayWriteInt64(AData: Int64; var ADestination: TclByteArray; var AIndex: Integer);
var
  w: DWORD;
begin
  w := AData shr 32;
  ByteArrayWriteDWord(w, ADestination, AIndex);
  w := DWORD(AData);
  ByteArrayWriteDWord(w, ADestination, AIndex);
end;

function ByteArrayReadWord(const ASource: TclByteArray; var AIndex: Integer): Word;
begin
  Result := ASource[AIndex] shl 8;
  Inc(AIndex);
  Result := Result or ASource[AIndex];
  Inc(AIndex);
end;

function ByteArrayReadDWord(const ASource: TclByteArray; var AIndex: Integer): DWORD;
begin
  Result := ByteArrayReadWord(ASource, AIndex) shl 16;
  Result := Result or ByteArrayReadWord(ASource, AIndex);
end;

function ByteArrayReadInt64(const ASource: TclByteArray; var AIndex: Integer): Int64;
begin
  Result := ByteArrayReadDWord(ASource, AIndex);
  Result := Result shl 32;
  Result := Result or ByteArrayReadDWord(ASource, AIndex);
end;

function ByteArrayEquals(const Arr1, Arr2: TclByteArray): Boolean;
var
  i: Integer;
begin
  Result := (Length(Arr1) = Length(Arr2)) and (Low(Arr1) = Low(Arr2));
  if not Result then Exit;

  for i := Low(Arr1) to High(Arr1) do
  begin
    if (Arr1[i] <> Arr2[i]) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

function MakeWord(AByte1, AByte2: Byte): Word;
var
  arr: array[0..1] of Byte;
begin
  arr[1] := AByte1;
  arr[0] := AByte2;
  Result := PWORD(@arr[0])^;
end;

function GetBinTextPos(const ASubStr: TclString; AData: PclChar; ADataPos, ADataSize: Integer): Integer;
var
  i, curPos, endPos: Integer;
begin
  curPos := 1;
  endPos := Length(ASubStr) + 1;

  for i := ADataPos to ADataSize - 1 do
  begin
    if (PclChar(TclIntPtr(AData) + i)^ = ASubStr[curPos]) then
    begin
      Inc(curPos);
    end else
    begin
      curPos := 1;
      Continue;
    end;
    if (Curpos = endPos) then
    begin
      Result := i - endPos + 2;
      Exit;
    end;
  end;
  Result := -1;
end;

function BytesPos(const ASubBytes, ABytes: TclByteArray; AStartFrom, ALength: Integer): Integer;
var
  i, curPos, endPos: Integer;
begin
  curPos := 0;
  endPos := Length(ASubBytes);

  for i := AStartFrom to ALength - 1 do
  begin
    if (ABytes[i] = ASubBytes[curPos]) then
    begin
      Inc(curPos);
    end else
    begin
      curPos := 0;
      Continue;
    end;
    if (curpos = endPos) then
    begin
      Result := i - endPos + 1;
      Exit;
    end;
  end;
  Result := -1;
end;

function GetStringsSize(AList: TStrings): Integer;
var
  utils: TclStringsUtils;
begin
  utils := TclStringsUtils.Create(AList);
  try
    Result := utils.GetStringsSize();
  finally
    utils.Free();
  end;
end;

function FindInStrings(AList: TStrings; const Value: string): Integer;
var
  utils: TclStringsUtils;
begin
  utils := TclStringsUtils.Create(AList);
  try
    Result := utils.FindInStrings(Value);
  finally
    utils.Free();
  end;
end;

function GetCharByteCount(ACount: Integer): Integer;
begin
  Result := ACount;
{$IFDEF DELPHI2009}
  Result := Result * 2;
{$ENDIF}
end;

function GetCurrentThreadUser: string;
var
  p: PChar;
  size: DWORD;
begin
  Result := '';
  size := 0;
  GetUserName(nil, size);

  if (size < 1) then Exit;

  GetMem(p, (size + 1) * SizeOf(Char));
  try
    if GetUserName(p, size) then
    begin
      Result := string(p);
    end;
  finally
    FreeMem(p);
  end;
end;

{$IFNDEF DELPHI2009}

{ TWideStringList }

function TWideStringList.Add(const S: WideString): Integer;
begin
  Result := AddObject(S, nil);
end;

function TWideStringList.AddObject(const S: WideString; AObject: TObject): Integer;
begin
  if not Sorted then
  begin
    Result := FCount
  end else
  if Find(S, Result) then
  begin
    case Duplicates of
      dupIgnore: Exit;
      dupError: Error(SDuplicateString, 0);
    end;
  end;
  InsertItem(Result, S, AObject);
end;

procedure TWideStringList.AddStrings(AStrings: TStrings);
var
  I: Integer;
begin
  for I := 0 to AStrings.Count - 1 do
  begin
    AddObject(WideString(AStrings[I]), AStrings.Objects[I]);
  end;
end;

procedure TWideStringList.AddStrings(AStrings: TWideStringList);
var
  I: Integer;
begin
  for I := 0 to AStrings.Count - 1 do
  begin
    AddObject(AStrings[I], AStrings.Objects[I]);
  end;
end;

procedure TWideStringList.Assign(Source: TPersistent);
begin
  if (Source is TWideStringList) then
  begin
    Clear();
    FNameValueSeparator := TWideStringList(Source).FNameValueSeparator;
    AddStrings(TWideStringList(Source));
  end else
  if (Source is TStrings) then
  begin
    Clear();
{$IFDEF DELPHI7}
    FNameValueSeparator := WideChar(TStrings(Source).NameValueSeparator);
{$ENDIF}
    AddStrings(TStrings(Source));
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TWideStringList.BeginUpdate;
begin
//TODO
end;

procedure TWideStringList.Clear;
begin
  if FCount <> 0 then
  begin
    Finalize(FList^[0], FCount);
    FCount := 0;
    SetCapacity(0);
  end;
end;

function TWideStringList.CompareStrings(const S1, S2: WideString): Integer;
begin
  if (S1 > S2) then
  begin
    Result := 1;
  end else
  if (S1 < S2) then
  begin
    Result := -1;
  end else
  begin
    Result := 0;
  end;
end;

constructor TWideStringList.Create;
begin
  inherited Create();
  FNameValueSeparator := '=';
end;

procedure TWideStringList.Delete(Index: Integer);
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Finalize(FList^[Index]);
  Dec(FCount);
  if Index < FCount then
  begin
    System.Move(FList^[Index + 1], FList^[Index],
      (FCount - Index) * SizeOf(TWideStringItem));
  end;
end;

destructor TWideStringList.Destroy;
begin
  inherited Destroy();
  if FCount <> 0 then Finalize(FList^[0], FCount);
  FCount := 0;
  SetCapacity(0);
end;

procedure TWideStringList.EndUpdate;
begin
//TODO
end;

procedure TWideStringList.Error(const Msg: string; Data: Integer);
  function ReturnAddr: Pointer;
  asm
          MOV     EAX,[EBP+4]
  end;
begin
  raise EStringListError.CreateFmt(Msg, [Data]) at ReturnAddr;
end;

procedure TWideStringList.ExchangeItems(Index1, Index2: Integer);
var
  Temp: TclIntPtr;
  Item1, Item2: PWideStringItem;
begin
  Item1 := @FList^[Index1];
  Item2 := @FList^[Index2];
  Temp := TclIntPtr(Item1^.FString);
  TclIntPtr(Item1^.FString) := TclIntPtr(Item2^.FString);
  TclIntPtr(Item2^.FString) := Temp;
  Temp := TclIntPtr(Item1^.FObject);
  TclIntPtr(Item1^.FObject) := TclIntPtr(Item2^.FObject);
  TclIntPtr(Item2^.FObject) := Temp;
end;

function TWideStringList.ExtractName(const S: WideString): WideString;
var
  P: Integer;
begin
  Result := S;
  P := Pos(NameValueSeparator, Result);
  if (P <> 0) then
  begin
    SetLength(Result, P - 1);
  end else
  begin
    SetLength(Result, 0);
  end;
end;

function TWideStringList.Find(const S: WideString; var Index: Integer): Boolean;
var
  L, H, I, C: Integer;
begin
  Result := False;
  L := 0;
  H := FCount - 1;
  while L <= H do
  begin
    I := (L + H) shr 1;
    C := CompareStrings(FList^[I].FString, S);
    if C < 0 then L := I + 1 else
    begin
      H := I - 1;
      if C = 0 then
      begin
        Result := True;
        if Duplicates <> dupAccept then L := I;
      end;
    end;
  end;
  Index := L;
end;

function TWideStringList.Get(Index: Integer): WideString;
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Result := FList^[Index].FString;
end;

function TWideStringList.GetName(Index: Integer): WideString;
begin
  Result := ExtractName(Get(Index));
end;

function TWideStringList.GetObject(Index: Integer): TObject;
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  Result := FList^[Index].FObject;
end;

function TWideStringList.GetValue(const Name: WideString): WideString;
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if I >= 0 then
  begin
    Result := Copy(Get(I), Length(Name) + 2, MaxInt)
  end else
  begin
    Result := '';
  end;
end;

function TWideStringList.GetValueFromIndex(Index: Integer): WideString;
begin
  if Index >= 0 then
  begin
    Result := Copy(Get(Index), Length(Names[Index]) + 2, MaxInt)
  end else
  begin
    Result := '';
  end;
end;

procedure TWideStringList.Grow;
var
  Delta: Integer;
begin
  if FCapacity > 256 then
  begin
    Delta := FCapacity div 4;
  end else
  begin
    Delta := 64;
  end;
  SetCapacity(FCapacity + Delta);
end;

function TWideStringList.IndexOf(const S: WideString): Integer;
begin
  if not Sorted then
  begin
    for Result := 0 to Count - 1 do
    begin
      if CompareStrings(Get(Result), S) = 0 then Exit;
    end;
    Result := -1;
  end else
  if not Find(S, Result) then
  begin
    Result := -1;
  end;
end;

function TWideStringList.IndexOfName(const Name: WideString): Integer;
var
  P: Integer;
  S: WideString;
begin
  for Result := 0 to Count - 1 do
  begin
    S := Get(Result);
    P := Pos(NameValueSeparator, S);
    if (P <> 0) and (CompareStrings(Copy(S, 1, P - 1), Name) = 0) then Exit;
  end;
  Result := -1;
end;

function TWideStringList.IndexOfObject(AObject: TObject): Integer;
begin
  for Result := 0 to Count - 1 do
  begin
    if GetObject(Result) = AObject then Exit;
  end;
  Result := -1;
end;

procedure TWideStringList.Insert(Index: Integer; const S: WideString);
begin
  InsertObject(Index, S, nil);
end;

procedure TWideStringList.InsertItem(Index: Integer; const S: WideString; AObject: TObject);
begin
  if FCount = FCapacity then Grow();
  
  if Index < FCount then
  begin
    System.Move(FList^[Index], FList^[Index + 1],
      (FCount - Index) * SizeOf(TWideStringItem));
  end;
  with FList^[Index] do
  begin
    Pointer(FString) := nil;
    FObject := AObject;
    FString := S;
  end;
  Inc(FCount);
end;

procedure TWideStringList.InsertObject(Index: Integer;
  const S: WideString; AObject: TObject);
begin
  if Sorted then
  begin
    Error(SSortedListError, 0);
  end;
  if (Index < 0) or (Index > FCount) then
  begin
    Error(SListIndexError, Index);
  end;
  InsertItem(Index, S, AObject);
end;

procedure TWideStringList.Move(CurIndex, NewIndex: Integer);
var
  TempObject: TObject;
  TempString: WideString;
begin
  if CurIndex <> NewIndex then
  begin
    TempString := Get(CurIndex);
    TempObject := GetObject(CurIndex);
    Delete(CurIndex);
    InsertObject(NewIndex, TempString, TempObject);
  end;
end;

procedure TWideStringList.Put(Index: Integer; const S: WideString);
begin
  if Sorted then Error(SSortedListError, 0);
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  FList^[Index].FString := S;
end;

procedure TWideStringList.PutObject(Index: Integer; AObject: TObject);
begin
  if (Index < 0) or (Index >= FCount) then Error(SListIndexError, Index);
  FList^[Index].FObject := AObject;
end;

function WideCompare(List: TWideStringList; Index1, Index2: Integer): Integer;
begin
  Result := List.CompareStrings(List.FList^[Index1].FString,
                                List.FList^[Index2].FString);
end;

procedure TWideStringList.QuickSort(L, R: Integer);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while WideCompare(Self, I, P) < 0 do Inc(I);
      while WideCompare(Self, J, P) > 0 do Dec(J);
      if I <= J then
      begin
        ExchangeItems(I, J);
        if P = I then
          P := J
        else if P = J then
          P := I;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(L, J);
    L := I;
  until I >= R;
end;

procedure TWideStringList.SetCapacity(NewCapacity: Integer);
begin
  ReallocMem(FList, NewCapacity * SizeOf(TWideStringItem));
  FCapacity := NewCapacity;
end;

procedure TWideStringList.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then
  begin
    if Value then Sort();
    FSorted := Value;
  end;
end;

procedure TWideStringList.SetValue(const Name, Value: WideString);
var
  I: Integer;
begin
  I := IndexOfName(Name);
  if Value <> '' then
  begin
    if I < 0 then I := Add('');
    Put(I, Name + NameValueSeparator + Value);
  end else
  begin
    if I >= 0 then Delete(I);
  end;
end;

procedure TWideStringList.SetValueFromIndex(Index: Integer; const Value: WideString);
begin
  if (Value <> '') then
  begin
    if (Index < 0) then
    begin
      Index := Add('');
    end;
    Put(Index, Names[Index] + NameValueSeparator + Value);
  end else
  begin
    if Index >= 0 then Delete(Index);
  end;
end;

procedure TWideStringList.Sort;
begin
  if not Sorted and (FCount > 1) then
  begin
    QuickSort(0, FCount - 1);
  end;
end;
{$ENDIF}

var
  HWNDAccessor: TCriticalSection;

function AllocateWindow(Method: TWndMethod): HWND;
begin
  HWNDAccessor.Enter();
  try
    Result := AllocateHWnd(Method);
  finally
    HWNDAccessor.Leave();
  end;
end;

procedure DeallocateWindow(Wnd: HWND);
begin
  HWNDAccessor.Enter();
  try
    DeallocateHWnd(Wnd);
  finally
    HWNDAccessor.Leave();
  end;
end;

{ TclStringsUtils }

function TclStringsUtils.AddTextStr(const Value: string; AddToLastString: Boolean): Integer;
var
  P, Start: PChar;
  S: string;
  b: Boolean;
begin
  Result := 0;
  b := AddToLastString;
  FStrings.BeginUpdate;
  try
    P := Pointer(Value);
    if P <> nil then
    begin
      while P^ <> #0 do
      begin
        Start := P;
        while not CharInSet(P^, [#0, #10, #13]) do Inc(P);
        SetString(S, Start, P - Start);
        if b and (FStrings.Count > 0) then
        begin
          FStrings[FStrings.Count - 1] := FStrings[FStrings.Count - 1] + S;
          b := False;
        end else
        begin
          FStrings.Add(S);
        end;
        if P^ = #13 then Inc(P);
        if P^ = #10 then Inc(P);
      end;
      if ((Length(Value) = 1) and (Value[1] <> #10))
        or ((Length(Value) > 1) and ((P - 2)^ <> #13) and ((P - 1)^ <> #10)) then
      begin
        Result := Length(Value);
      end;
    end;
  finally
    FStrings.EndUpdate;
  end;
end;

function TclStringsUtils.AddTextStream(ASource: TStream): Integer;
begin
  Result := AddTextStream(ASource, False, 0);
end;

function TclStringsUtils.AddTextStream(ASource: TStream; AddToLastString: Boolean): Integer;
begin
  Result := AddTextStream(ASource, AddToLastString, 0);
end;

function TclStringsUtils.AddTextStream(ASource: TStream; AddToLastString: Boolean; ACount: Integer): Integer;
var
  size: Integer;
  s: string;
  buf: TclByteArray;
  i, cnt, total, totalCount: Integer;
  b: Boolean;
begin
  totalCount := ASource.Size - ASource.Position;
  size := totalCount;
  if (size > BatchSize) and (BatchSize > 0) then
  begin
    size := BatchSize;
  end;

  total := 0;
  SetLength(buf, size + 1);
  b := AddToLastString;
  Result := 0;

  cnt := ASource.Read(buf[0], size);
  while (cnt > 0) do
  begin
    DoProgress(total, totalCount);

    s := TclTranslator.GetString(buf, 0, cnt, FCharSet);

    for i := 1 to Length(s) do
    begin
      if s[i] = #0 then
      begin
        s[i] := #32;
      end;
    end;

    Result := AddTextStr(s, b);
    b := Result > 0;

    total := total + cnt;
    if (ACount > 0) then
    begin
      if (total >= ACount) then Break;

      if ((ACount - total) < size) then
      begin
        size := ACount - total;
      end;
    end;

    cnt := ASource.Read(buf[0], size);
  end;
end;

constructor TclStringsUtils.Create(AStrings: TStrings; const ACharSet: string);
begin
  inherited Create();

  FStrings := AStrings;
  FBatchSize := 0;
  FCharSet := ACharSet;
end;

constructor TclStringsUtils.Create(AStrings: TStrings);
begin
  Create(AStrings, '');
end;

procedure TclStringsUtils.DoProgress(ABytesProceed, ATotalBytes: Int64);
begin
  if Assigned(OnProgress) then
  begin
    OnProgress(Self, ABytesProceed, ATotalBytes);
  end;
end;

function TclStringsUtils.FindInStrings(const Value: string): Integer;
var
  i: Integer;
begin
  for i := 0 to FStrings.Count - 1 do
  begin
    if SameText(Value, FStrings[i]) then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

class function TclStringsUtils.LoadStrings(ASource: TStream; const ACharSet: string): TStrings;
begin
  Result := TStringList.Create();
  try
    LoadStrings(ASource, Result, ACharSet);
  except
    Result.Free();
    raise;
  end;
end;

class procedure TclStringsUtils.SaveStrings(ASource: TStrings; ADestination: TStream; const ACharSet: string);
var
  utils: TclStringsUtils;
begin
  utils := TclStringsUtils.Create(ASource, ACharSet);
  try
    utils.SaveStrings(ADestination);
  finally
    utils.Free();
  end;
end;

function TclStringsUtils.GetStringsSize: Integer;
const
  cCRLF = #13#10;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FStrings.Count - 1 do
  begin
    Result := Result + Length(FStrings[i]) + Length(cCRLF);
  end;
end;

function TclStringsUtils.GetTextStr(AStartFrom, ACount: Integer): string;
const
  LB = #13#10;
var
  I, L, Size, Count: Integer;
  P: PChar;
  S: string;
begin
  Count := ACount;
  if (Count > FStrings.Count - AStartFrom) then
  begin
    Count := FStrings.Count - AStartFrom;
  end;

  Size := 0;
  for I := 0 to Count - 1 do Inc(Size, Length(FStrings[I + AStartFrom]) + Length(LB));
  SetString(Result, nil, Size);
  P := Pointer(Result);
  for I := 0 to Count - 1 do
  begin
    S := FStrings[I + AStartFrom];
    L := Length(S);
    if L <> 0 then
    begin
      System.Move(Pointer(S)^, P^, GetCharByteCount(L));
      Inc(P, L);
    end;            
    L := Length(LB);
    if L <> 0 then
    begin
      System.Move(LB, P^, GetCharByteCount(L));
      Inc(P, L);
    end;
  end;
end;

function TclStringsUtils.InsertTextStr(const Value: string; AIndex: Integer; AddToLastString: Boolean): Integer;
var
  P, Start: PChar;
  S: string;
  b: Boolean;
  ind: Integer;
begin
  Result := 0;
  ind := AIndex;
  if (ind < 0) or (ind >= FStrings.Count)  then
  begin
    ind := FStrings.Count;
  end;

  b := AddToLastString;
  FStrings.BeginUpdate;
  try
    P := Pointer(Value);
    if P <> nil then
    begin
      while P^ <> #0 do
      begin
        Start := P;
        while not CharInSet(P^, [#0, #10, #13]) do Inc(P);
        SetString(S, Start, P - Start);
        if b and (ind > 0) then
        begin
          FStrings[ind - 1] := FStrings[ind - 1] + S;
          b := False;
        end else
        begin
          FStrings.Insert(ind, S);
          Inc(ind);
        end;
        if P^ = #13 then Inc(P);
        if P^ = #10 then Inc(P);
      end;
      if ((Length(Value) = 1) and (Value[1] <> #10))
        or ((Length(Value) > 1) and ((P - 2)^ <> #13) and ((P - 1)^ <> #10)) then
      begin
        Result := Length(Value);
      end;
    end;
  finally
    FStrings.EndUpdate;
  end;
end;

class procedure TclStringsUtils.LoadStrings(const ASourceFile: string;
  ADestination: TStrings; const ACharSet: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(ASourceFile, fmOpenRead or fmShareDenyWrite);
  try
    LoadStrings(stream, ADestination, ACharSet);
  finally
    stream.Free();
  end;
end;

class procedure TclStringsUtils.LoadStrings(ASource: TStream; ADestination: TStrings; const ACharSet: string);
var
  utils: TclStringsUtils;
begin
  utils := TclStringsUtils.Create(ADestination, ACharSet);
  try
    utils.LoadStrings(ASource);
  finally
    utils.Free();
  end;
end;

procedure TclStringsUtils.LoadStrings(ASource: TStream);
var
  size: Integer;
  buffer: TclByteArray;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  FStrings.BeginUpdate();
  try
    size := ASource.Size - ASource.Position;

    if (size > 0) then
    begin
      SetLength(buffer, size);
      ASource.Read(buffer[0], size);
//TODO BOM  see TStrings source
      FStrings.Text := TclTranslator.GetString(buffer, 0, size, FCharSet);
    end;
  finally
    FStrings.EndUpdate();
  end;
end;

class procedure TclStringsUtils.SaveStrings(ASource: TStrings;
  const ADestinationFile, ACharSet: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(ADestinationFile, fmCreate);
  try
    SaveStrings(ASource, stream, ACharSet);
  finally
    stream.Free();
  end;
end;

procedure TclStringsUtils.SaveStrings(ADestination: TStream);
var
  buffer: TclByteArray;
  s: string;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  s := FStrings.Text;
  if (s = '') then Exit;

  buffer := TclTranslator.GetBytes(s, FCharSet);
//TODO BOM  see TStrings source
  ADestination.WriteBuffer(buffer[0], Length(buffer));
end;

{$WARNINGS ON}

{ TclErrorList }

procedure TclErrorList.AddError(const AError: string; AErrorCode: Integer);
begin
  FList.AddObject(AError, TObject(AErrorCode));
end;

procedure TclErrorList.Clear;
begin
  FList.Clear();
end;

constructor TclErrorList.Create;
begin
  inherited Create();
  FList := TStringList.Create();
end;

destructor TclErrorList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function TclErrorList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclErrorList.GetErrorCodes(Index: Integer): Integer;
begin
  Result := Integer(FList.Objects[Index]);
end;

function TclErrorList.GetErrors(Index: Integer): string;
begin
  Result := FList[Index];
end;

function TclErrorList.GetText: string;
begin
  Result := FList.Text;
end;

{ TclInterfaceListHelper }

class procedure TclInterfaceListHelper.ExchangeItems(AList: IInterfaceList; Index1, Index2: Integer);
var
  int1: IInterface;
begin
  int1 := AList[Index1];
  AList[Index1] := AList[Index2];
  AList[Index2] := int1; 
end;

class procedure TclInterfaceListHelper.QuickSort(AList: IInterfaceList; L, R: Integer; Compare: TclInterfaceListCompare);
var
  I, J, P: Integer;
begin
  repeat
    I := L;
    J := R;
    P := (L + R) shr 1;
    repeat
      while Compare(AList[I], AList[P]) < 0 do Inc(I);
      while Compare(AList[J], AList[P]) > 0 do Dec(J);
      if I <= J then
      begin
        ExchangeItems(AList, I, J);
        if P = I then
        begin
          P := J;
        end else
        if P = J then
        begin
          P := I;
        end;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then
    begin
      QuickSort(AList, L, J, Compare);
    end;
    L := I;
  until I >= R;
end;

class procedure TclInterfaceListHelper.Sort(AList: IInterfaceList; Compare: TclInterfaceListCompare);
begin
  if (AList.Count > 0) then
  begin
    QuickSort(AList, 0, AList.Count - 1, Compare);
  end;
end;

initialization
  HWNDAccessor := TCriticalSection.Create();

finalization
  HWNDAccessor.Free();

end.
