
{******************************************}
{                                          }
{             FastScript v1.9              }
{              XML document                }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_xml;

interface

{$i fs.inc}

uses
{$IFNDEF CROSS_COMPILE}
  Windows,
{$ENDIF}
  SysUtils, Classes
{$IFDEF Delphi12}
  , AnsiStrings
{$ENDIF};

type
  TfsXMLItem = class(TObject)
  private
    FData: Pointer;              { optional item data }
    FItems: TList;               { subitems }
    FName: String;               { item name }
    FParent: TfsXMLItem;         { item parent }
    FText: String;               { item attributes }
    function GetCount: Integer;
    function GetItems(Index: Integer): TfsXMLItem;
    function GetProp(Index: String): String;
    procedure SetProp(Index: String; const Value: String);
    procedure SetParent(const Value: TfsXMLItem);
  public
    destructor Destroy; override;
    procedure AddItem(Item: TfsXMLItem);
    procedure Assign(Item: TfsXMLItem);
    procedure Clear;
    procedure InsertItem(Index: Integer; Item: TfsXMLItem);

    function Add: TfsXMLItem;
    function Find(const Name: String): Integer;
    function FindItem(const Name: String): TfsXMLItem;
    function IndexOf(Item: TfsXMLItem): Integer;
    function PropExists(const Index: String): Boolean;
    function Root: TfsXMLItem;

    property Count: Integer read GetCount;
    property Data: Pointer read FData write FData;
    property Items[Index: Integer]: TfsXMLItem read GetItems; default;
    property Name: String read FName write FName;
    property Parent: TfsXMLItem read FParent write SetParent;
    property Prop[Index: String]: String read GetProp write SetProp;
    property Text: String read FText write FText;
  end;

  TfsXMLDocument = class(TObject)
  private
    FAutoIndent: Boolean;        { use indents when writing document to a file }
    FRoot: TfsXMLItem;           { root item }
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(const FileName: String);
    procedure LoadFromFile(const FileName: String);

    property AutoIndent: Boolean read FAutoIndent write FAutoIndent;
    property Root: TfsXMLItem read FRoot;
  end;

{ TfsXMLReader and TfsXMLWriter are doing actual read/write to the XML file.
  Read/write process is buffered. }

  TfsXMLReader = class(TObject)
  private
    FBuffer: PAnsiChar;
    FBufPos: Integer;
    FBufEnd: Integer;
    FPosition: Int64;
    FSize: Int64;
    FStream: TStream;
    procedure SetPosition(const Value: Int64);
    procedure ReadBuffer;
    procedure ReadItem(var {$IFDEF Delphi12}NameS{$ELSE}Name{$ENDIF}: String; var Text: String);
  public
    constructor Create(Stream: TStream);
    destructor Destroy; override;
    procedure RaiseException;
    procedure ReadHeader;
    procedure ReadRootItem(Item: TfsXMLItem);
    property Position: Int64 read FPosition write SetPosition;
    property Size: Int64 read FSize;
  end;

  TfsXMLWriter = class(TObject)
  private
    FAutoIndent: Boolean;
    FBuffer: AnsiString;
    FStream: TStream;
    FTempStream: TStream;
    procedure FlushBuffer;
    procedure WriteLn(const s: AnsiString);
    procedure WriteItem(Item: TfsXMLItem; Level: Integer = 0);
  public
    constructor Create(Stream: TStream);
    procedure WriteHeader;
    procedure WriteRootItem(RootItem: TfsXMLItem);
    property TempStream: TStream read FTempStream write FTempStream;
  end;


{ StrToXML changes '<', '>', '"', cr, lf symbols to its ascii codes }
function StrToXML(const s: String): String;

{ ValueToXML convert a value to the valid XML string }
function ValueToXML(const Value: Variant): String;

{ XMLToStr is opposite to StrToXML function }
function XMLToStr(const s: String): String;


implementation


function StrToXML(const s: String): String;
const
  SpecChars = ['<', '>', '"', #10, #13, '&'];
var
  i: Integer;

  procedure ReplaceChars(var s: String; i: Integer);
  begin
    Insert('#' + IntToStr(Ord(s[i])) + ';', s, i + 1);
    s[i] := '&';
  end;

begin
  Result := s;
  for i := Length(s) downto 1 do
{$IFDEF Delphi12}
    if CharInSet(s[i], SpecChars) then
{$ELSE}
    if s[i] in SpecChars then
{$ENDIF}
      if s[i] <> '&' then
        ReplaceChars(Result, i)
      else
      begin
        if Copy(s, i + 1, 5) = 'quot;' then
        begin
          Delete(Result, i, 6);
          Insert('&#34;', Result, i);
        end;
      end;
end;

function XMLToStr(const s: String): String;
var
  i, j, h, n: Integer;
begin
  Result := s;

  i := 1;
  n := Length(s);
  while i < n do
  begin
    if Result[i] = '&' then
      if (i + 3 <= n) and (Result[i + 1] = '#') then
      begin
        j := i + 3;
        while Result[j] <> ';' do
          Inc(j);
        h := StrToInt(Copy(Result, i + 2, j - i - 2));
        Delete(Result, i, j - i);
        Result[i] := Chr(h);
        Dec(n, j - i);
      end
      else if Copy(Result, i + 1, 5) = 'quot;' then
      begin
        Delete(Result, i, 6);
        Result[i] := '"';
        Dec(n, 6);
      end;
    Inc(i);
  end;
end;

function ValueToXML(const Value: Variant): String;
begin
  case TVarData(Value).VType of
    varSmallint, varInteger, varByte:
      Result := IntToStr(Integer(Value));

    varSingle, varDouble, varCurrency:
      Result := FloatToStr(Double(Value));

    varDate:
      Result := DateToStr(TDateTime(Value));

    varOleStr, varString, varVariant{$IFDEF Delphi12}, varUString{$ENDIF}:
      Result := StrToXML(Value);

    varBoolean:
      if Value = True then Result := '1' else Result := '0';

    else
      Result := '';
  end;
end;


{ TfsXMLItem }

destructor TfsXMLItem.Destroy;
begin
  Clear;
  if FParent <> nil then
    FParent.FItems.Remove(Self);
  inherited;
end;

procedure TfsXMLItem.Clear;
begin
  if FItems <> nil then
  begin
    while FItems.Count > 0 do
      TfsXMLItem(FItems[0]).Free;
    FItems.Free;
    FItems := nil;
  end;
end;

function TfsXMLItem.GetItems(Index: Integer): TfsXMLItem;
begin
  Result := TfsXMLItem(FItems[Index]);
end;

function TfsXMLItem.GetCount: Integer;
begin
  if FItems = nil then
    Result := 0 else
    Result := FItems.Count;
end;

function TfsXMLItem.Add: TfsXMLItem;
begin
  Result := TfsXMLItem.Create;
  AddItem(Result);
end;

procedure TfsXMLItem.AddItem(Item: TfsXMLItem);
begin
  if FItems = nil then
    FItems := TList.Create;

  FItems.Add(Item);
  if Item.FParent <> nil then
    Item.FParent.FItems.Remove(Item);
  Item.FParent := Self;
end;

procedure TfsXMLItem.InsertItem(Index: Integer; Item: TfsXMLItem);
begin
  AddItem(Item);
  FItems.Delete(FItems.Count - 1);
  FItems.Insert(Index, Item);
end;

procedure TfsXMLItem.SetParent(const Value: TfsXMLItem);
begin
  if FParent <> nil then
    FParent.FItems.Remove(Self);
  FParent := Value;
end;

function TfsXMLItem.Find(const Name: String): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Count - 1 do
    if AnsiCompareText(Items[i].Name, Name) = 0 then
    begin
      Result := i;
      break;
    end;
end;

function TfsXMLItem.FindItem(const Name: String): TfsXMLItem;
var
  i: Integer;
begin
  i := Find(Name);
  if i = -1 then
  begin
    Result := Add;
    Result.Name := Name;
  end
  else
    Result := Items[i];
end;

function TfsXMLItem.Root: TfsXMLItem;
begin
  Result := Self;
  while Result.Parent <> nil do
    Result := Result.Parent;
end;

function TfsXMLItem.GetProp(Index: String): String;
var
  i: Integer;
begin
  i := Pos(' ' + AnsiUppercase(Index) + '="', AnsiUppercase(' ' + FText));
  if i <> 0 then
  begin
    Result := Copy(FText, i + Length(Index + '="'), MaxInt);
    Result := XMLToStr(Copy(Result, 1, Pos('"', Result) - 1));
  end
  else
    Result := '';
end;

procedure TfsXMLItem.SetProp(Index: String; const Value: String);
var
  i, j: Integer;
  s: String;
begin
  i := Pos(' ' + AnsiUppercase(Index) + '="', AnsiUppercase(' ' + FText));
  if i <> 0 then
  begin
    j := i + Length(Index + '="');
    while (j <= Length(FText)) and (FText[j] <> '"') do
      Inc(j);
    Delete(FText, i, j - i + 1);
  end
  else
    i := Length(FText) + 1;

  s := Index + '="' + StrToXML(Value) + '"';
  if (i > 1) and (FText[i - 1] <> ' ') then
    s := ' ' + s;
  Insert(s, FText, i);
end;

function TfsXMLItem.PropExists(const Index: String): Boolean;
begin
  Result := Pos(' ' + AnsiUppercase(Index) + '="', ' ' + AnsiUppercase(FText)) > 0;
end;

function TfsXMLItem.IndexOf(Item: TfsXMLItem): Integer;
begin
  Result := FItems.IndexOf(Item);
end;

procedure TfsXMLItem.Assign(Item: TfsXMLItem);

  procedure DoAssign(ItemFrom, ItemTo: TfsXMLItem);
  var
    i: Integer;
  begin
    ItemTo.Name := ItemFrom.Name;
    ItemTo.Text := ItemFrom.Text;
    ItemTo.Data := ItemFrom.Data;
    for i := 0 to ItemFrom.Count - 1 do
      DoAssign(ItemFrom[i], ItemTo.Add);
  end;

begin
  Clear;
  if Item <> nil then
    DoAssign(Item, Self);
end;


{ TfsXMLDocument }

constructor TfsXMLDocument.Create;
begin
  FRoot := TfsXMLItem.Create;
end;

destructor TfsXMLDocument.Destroy;
begin
  FRoot.Free;
  inherited;
end;

procedure TfsXMLDocument.Clear;
begin
  FRoot.Clear;
end;

procedure TfsXMLDocument.LoadFromStream(Stream: TStream);
var
  rd: TfsXMLReader;
begin
  rd := TfsXMLReader.Create(Stream);
  try
    FRoot.Clear;
    rd.ReadHeader;
    rd.ReadRootItem(FRoot);
  finally
    rd.Free;
  end;
end;

procedure TfsXMLDocument.SaveToStream(Stream: TStream);
var
  wr: TfsXMLWriter;
begin
  wr := TfsXMLWriter.Create(Stream);
  wr.FAutoIndent := FAutoIndent;

  try
    wr.WriteHeader;
    wr.WriteRootItem(FRoot);
  finally
    wr.Free;
  end;
end;

procedure TfsXMLDocument.LoadFromFile(const FileName: String);
var
  s: TFileStream;
begin
  s := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(s);
  finally
    s.Free;
  end;
end;

procedure TfsXMLDocument.SaveToFile(const FileName: String);
var
  s: TFileStream;
begin
  s := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(s);
  finally
    s.Free;
  end;
end;


{ TfsXMLReader }

constructor TfsXMLReader.Create(Stream: TStream);
begin
  FStream := Stream;
  FSize := Stream.Size;
  FPosition := Stream.Position;
  GetMem(FBuffer, 4096);
end;

destructor TfsXMLReader.Destroy;
begin
  FreeMem(FBuffer, 4096);
  FStream.Position := FPosition;
  inherited;
end;

procedure TfsXMLReader.ReadBuffer;
begin
  FBufEnd := FStream.Read(FBuffer^, 4096);
  FBufPos := 0;
end;

procedure TfsXMLReader.SetPosition(const Value: Int64);
begin
  FPosition := Value;
  FStream.Position := Value;
  FBufPos := 0;
  FBufEnd := 0;
end;

procedure TfsXMLReader.RaiseException;
begin
  raise Exception.Create('Invalid file format');
end;

procedure TfsXMLReader.ReadHeader;
var
  s1: String;
  s2: String;
begin
  ReadItem(s1, s2);
  if Pos('?xml', s1) <> 1 then
    RaiseException;
end;

procedure TfsXMLReader.ReadItem(var {$IFDEF Delphi12}NameS{$ELSE}Name{$ENDIF}: String; var Text: String);
var
  c: Integer;
  curpos, len: Integer;
  state: (FindLeft, FindRight, FindComment, Done);
  i, comment: Integer;
  ps: PAnsiChar;
{$IFDEF Delphi12}
  Name: AnsiString;
{$ENDIF}
begin
  Text := '';
  comment := 0;
  state := FindLeft;
  curpos := 0;
  len := 4096;
  SetLength(Name, len);
  ps := @Name[1];

  while FPosition < FSize do
  begin
    if FBufPos = FBufEnd then
      ReadBuffer;
    c := Ord(FBuffer[FBufPos]);
    Inc(FBufPos);
    Inc(FPosition);

    if state = FindLeft then
    begin
      if c = Ord('<') then
        state := FindRight
    end
    else if state = FindRight then
    begin
      if c = Ord('>') then
      begin
        state := Done;
        break;
      end
      else if c = Ord('<') then
        RaiseException
      else
      begin
        ps[curpos] := AnsiChar(Chr(c));
        Inc(curpos);
        if (curpos = 3) and (Pos(AnsiString('!--'), Name) = 1) then
        begin
          state := FindComment;
          comment := 0;
          curpos := 0;
        end;
        if curpos >= len - 1 then
        begin
          Inc(len, 4096);
          SetLength(Name, len);
          ps := @Name[1];
        end;
      end;
    end
    else if State = FindComment then
    begin
      if comment = 2 then
      begin
        if c = Ord('>') then
          state := FindLeft
        else
          comment := 0;
      end
      else begin
        if c = Ord('-') then
          Inc(comment)
        else
          comment := 0;
      end;
    end;
  end;

  len := curpos;
  SetLength(Name, len);

  if state = FindRight then
    RaiseException;
  if (Name <> '') and (Name[len] = ' ') then
    SetLength(Name, len - 1);

  i := Pos(AnsiString(' '), Name);
  if i <> 0 then
  begin
{$IFDEF Delphi12}
    Text := UTF8Decode(Copy(Name, i + 1, len - i));
{$ELSE}
    Text := Copy(Name, i + 1, len - i);
{$ENDIF}
    Delete(Name, i, len - i + 1);
  end;
{$IFDEF Delphi12}
    NameS := String(Name);
{$ENDIF}
end;

procedure TfsXMLReader.ReadRootItem(Item: TfsXMLItem);
var
  LastName: String;

  function DoRead(RootItem: TfsXMLItem): Boolean;
  var
    n: Integer;
    ChildItem: TfsXMLItem;
    Done: Boolean;
  begin
    Result := False;
    ReadItem(RootItem.FName, RootItem.FText);
    LastName := RootItem.FName;

    if (RootItem.Name = '') or (RootItem.Name[1] = '/') then
    begin
      Result := True;
      Exit;
    end;

    n := Length(RootItem.Name);
    if RootItem.Name[n] = '/' then
    begin
      SetLength(RootItem.FName, n - 1);
      Exit;
    end;

    n := Length(RootItem.Text);
    if (n > 0) and (RootItem.Text[n] = '/') then
    begin
      SetLength(RootItem.FText, n - 1);
      Exit;
    end;

    repeat
      ChildItem := TfsXMLItem.Create;
      Done := DoRead(ChildItem);
      if not Done then
        RootItem.AddItem(ChildItem) else
        ChildItem.Free;
    until Done;

    if (LastName <> '') and (AnsiCompareText(LastName, '/' + RootItem.Name) <> 0) then
      RaiseException;
  end;

begin
  DoRead(Item);
end;


{ TfsXMLWriter }

constructor TfsXMLWriter.Create(Stream: TStream);
begin
  FStream := Stream;
end;

procedure TfsXMLWriter.FlushBuffer;
begin
  if FBuffer <> '' then
    FStream.Write(FBuffer[1], Length(FBuffer));
  FBuffer := '';
end;

procedure TfsXMLWriter.WriteLn(const s: AnsiString);
begin
  if not FAutoIndent then
    Insert(s, FBuffer, MaxInt) else
    Insert(s + #13#10, FBuffer, MaxInt);
  if Length(FBuffer) > 4096 then
    FlushBuffer;
end;

procedure TfsXMLWriter.WriteHeader;
begin
  WriteLn('<?xml version="1.0"?>');
end;

function Dup(n: Integer): AnsiString;
begin
  SetLength(Result, n);
  FillChar(Result[1], n, ' ');
end;

procedure TfsXMLWriter.WriteItem(Item: TfsXMLItem; Level: Integer = 0);
var
  s: AnsiString;
begin
  if Item.FText <> '' then
  begin
{$IFDEF Delphi12}
    s := UTF8Encode(Item.FText);
{$ELSE}
    s := Item.FText;
{$ENDIF}
    if (s = '') or (s[1] <> ' ') then
      s := ' ' + s;
  end
  else
    s := '';

  if Item.Count = 0 then
    s := s + '/>' else
    s := s + '>';
  if not FAutoIndent then
    s := '<' + AnsiString(Item.Name) + s else
    s := Dup(Level) + '<' + AnsiString(Item.Name) + s;
  WriteLn(s);
end;

procedure TfsXMLWriter.WriteRootItem(RootItem: TfsXMLItem);

  procedure DoWrite(RootItem: TfsXMLItem; Level: Integer = 0);
  var
    i: Integer;
    NeedClear: Boolean;
  begin
    NeedClear := False;
    if not FAutoIndent then
      Level := 0;

    WriteItem(RootItem, Level);
    for i := 0 to RootItem.Count - 1 do
      DoWrite(RootItem[i], Level + 2);
    if RootItem.Count > 0 then
      if not FAutoIndent then
        WriteLn('</' + AnsiString(RootItem.Name) + '>') else
        WriteLn(Dup(Level) + '</' + AnsiString(RootItem.Name) + '>');

    if NeedClear then
      RootItem.Clear;
  end;

begin
  DoWrite(RootItem);
  FlushBuffer;
end;

end.
