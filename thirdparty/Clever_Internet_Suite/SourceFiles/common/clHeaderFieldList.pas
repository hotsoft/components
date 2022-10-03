{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clHeaderFieldList;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clUtils, clWUtils;

type
  TclHeaderFieldList = class
  private
    FFieldList: TStrings;
    FSource: TStrings;
    FHeaderEnd: Integer;
    FHeaderStart: Integer;
    FCharsPerLine: Integer;
    FItemDelimiter: Char;

    procedure SkipWhiteSpace(var Next: PChar);
    procedure GetStartLexem(const ASource, AItemName: string; var AStartLexem: string; var APosition: Integer);
  protected
    class function TrimFirstWhiteSpace(const ALine: string): string;
    class function GetUnfoldedLine(const ALine: string): string;

    function GetQuoteSymbols: TCharSet; virtual;
    function GetItemDelimiters: TCharSet; virtual;
    function GetSpecialSymbols: TCharSet; virtual;
    function GetWhiteSpaces: TCharSet; virtual;

    procedure SetHeaderEnd(AValue: Integer);

    procedure InsertFoldedText(AIndex: Integer; const AText, AFirstFoldingTag, AFoldingTag: string);
    procedure InsertFoldedStrings(AIndex: Integer; AStrings: TStrings; const AFirstFoldingTag, AFoldingTag: string);

    function InternalGetFieldValue(AIndex: Integer): string; virtual;

    procedure InternalGetFieldValueItem(const ASource, AItemName: string;
      var AValue: string; var AStartPos, ACount: Integer); virtual;

    procedure InternalInsertField(AIndex: Integer; const AField: string; AFolded: Boolean); virtual;
    procedure InternalAddFieldItem(AFieldIndex: Integer; const AItemName, AValue: string; ANewLine: Boolean); virtual;
    function InternalRemoveFieldItem(const AFieldSource, AItemName: string): string; virtual;
    function InternalClearFieldItem(const AFieldSource, AItemName: string): string; virtual;
    procedure InternalInsertFieldSource(AIndex: Integer; AFieldSource: TStrings); virtual;
    procedure InternalRemoveField(AIndex: Integer); virtual;
  public
    constructor Create;
    destructor Destroy; override;

    class function GetItemNameValuePair(const AItemName, AValue: string): string;
    class function GetNameValuePair(const AName, AValue: string): string;

    function Parse(AStartFrom: Integer; ASource: TStrings): Integer; virtual;

    function GetFieldStart(const AName: string): Integer; overload;
    function GetFieldStart(AIndex: Integer): Integer; overload;

    function GetFieldEnd(const AName: string): Integer; overload;
    function GetFieldEnd(AIndex: Integer): Integer; overload;

    function GetFieldIndex(const AName: string): Integer;

    function GetFieldName(const AName: string): string; overload;
    function GetFieldName(AIndex: Integer): string; overload;

    function GetFieldValue(const AName: string): string; overload;
    function GetFieldValue(AIndex: Integer): string; overload; virtual;

    function GetFieldValueItem(const ASource, AItemName: string): string; virtual;

    procedure GetFieldSource(const AName: string; AFieldSource: TStrings); overload;
    procedure GetFieldSource(AIndex: Integer; AFieldSource: TStrings); overload;

    procedure InsertNonFoldedField(AIndex: Integer; const AName, AValue: string);
    procedure InsertField(AIndex: Integer; const AName, AValue: string);
    procedure InsertEmptyField(AIndex: Integer; const AName: string);
    procedure InsertFieldIfNotExist(AIndex: Integer; const AName, AValue: string);

    procedure AddNonFoldedField(const AName, AValue: string);
    procedure AddField(const AName, AValue: string);
    procedure AddEmptyField(const AName: string);
    procedure AddFieldIfNotExist(const AName, AValue: string);

    procedure AddArrayField(const AName: string; const AValues: array of string); overload;
    procedure AddArrayField(const AName: string; AValues: TStrings); overload;

    procedure AddQuotedFieldItem(const AFieldName, AItemName, AValue: string); overload;
    procedure AddQuotedFieldItem(AFieldIndex: Integer; const AItemName, AValue: string); overload;
    procedure AddFieldItem(const AFieldName, AItemName, AValue: string); overload;
    procedure AddFieldItem(AFieldIndex: Integer; const AItemName, AValue: string); overload;
    procedure AddEmptyFieldItem(const AFieldName, AItemName: string); overload;
    procedure AddEmptyFieldItem(AFieldIndex: Integer; const AItemName: string); overload;

    procedure AddQuotedFieldItem(const AFieldName, AItemName, AValue: string; ANewLine: Boolean); overload;
    procedure AddQuotedFieldItem(AFieldIndex: Integer; const AItemName, AValue: string; ANewLine: Boolean); overload;
    procedure AddFieldItem(const AFieldName, AItemName, AValue: string; ANewLine: Boolean); overload;
    procedure AddFieldItem(AFieldIndex: Integer; const AItemName, AValue: string; ANewLine: Boolean); overload;
    procedure AddEmptyFieldItem(const AFieldName, AItemName: string; ANewLine: Boolean); overload;
    procedure AddEmptyFieldItem(AFieldIndex: Integer; const AItemName: string; ANewLine: Boolean); overload;

    procedure AddFields(AFields: TStrings);
    procedure AddEndOfHeader;

    procedure RemoveField(const AName: string); overload;
    procedure RemoveField(AIndex: Integer); overload;

    procedure RemoveFieldItem(const AFieldName, AItemName: string); overload;
    procedure RemoveFieldItem(AFieldIndex: Integer; const AItemName: string); overload;

    procedure ClearFieldItem(const AFieldName, AItemName: string); overload;
    procedure ClearFieldItem(AFieldIndex: Integer; const AItemName: string); overload;

    property FieldList: TStrings read FFieldList;
    property Source: TStrings read FSource;

    property HeaderStart: Integer read FHeaderStart;
    property HeaderEnd: Integer read FHeaderEnd;

    property CharsPerLine: Integer read FCharsPerLine write FCharsPerLine;
    property ItemDelimiter: Char read FItemDelimiter write FItemDelimiter;
  end;

implementation

{ TclHeaderFieldList }

procedure TclHeaderFieldList.AddArrayField(const AName: string; AValues: TStrings);
var
  i: Integer;
begin
  if (AValues.Count > 0) and (AValues[0] <> '') then
  begin
    if (AValues.Count > 1) then
    begin
      InternalInsertField(HeaderEnd, GetNameValuePair(AName, AValues[0]) + ',', True);
    end else
    begin
      InternalInsertField(HeaderEnd, GetNameValuePair(AName, AValues[0]), True);
    end;
  end;

  for i := 1 to AValues.Count - 2 do
  begin
    if (AValues[i] <> '') then
    begin
      InternalInsertField(HeaderEnd, #9 + AValues[i] + ',', True);
    end;
  end;

  if (AValues.Count > 1) and (AValues[AValues.Count - 1] <> '') then
  begin
    InternalInsertField(HeaderEnd, #9 + AValues[AValues.Count - 1], True);
  end;
end;

procedure TclHeaderFieldList.AddArrayField(const AName: string; const AValues: array of string);
var
  i: Integer;
  list: TStrings;
begin
  list := TStringList.Create();
  try
    for i := Low(AValues) to High(AValues) do
    begin
      list.Add(AValues[i]);
    end;
    AddArrayField(AName, list);
  finally
    list.Free();
  end;
end;

procedure TclHeaderFieldList.AddEmptyField(const AName: string);
begin
  InternalInsertField(HeaderEnd, GetNameValuePair(AName, ''), True);
end;

procedure TclHeaderFieldList.AddEmptyFieldItem(const AFieldName, AItemName: string);
begin
  AddEmptyFieldItem(AFieldName, AItemName, False);
end;

procedure TclHeaderFieldList.AddEmptyFieldItem(AFieldIndex: Integer; const AItemName: string);
begin
  AddEmptyFieldItem(AFieldIndex, AItemName, False);
end;

procedure TclHeaderFieldList.AddEndOfHeader;
begin
  Assert(Source <> nil);

  if (Source.Count > 0) and (HeaderEnd > -1) then
  begin
    if (HeaderEnd < Source.Count) then
    begin
      if (Source[HeaderEnd] <> '') then
      begin
        FSource.Insert(HeaderEnd, '');
      end;
    end else
    if (Source[Source.Count - 1] <> '') then
    begin
      FSource.Add('');
    end;
  end;
end;

procedure TclHeaderFieldList.AddField(const AName, AValue: string);
begin
  if (AValue <> '') then
  begin
    InternalInsertField(HeaderEnd, GetNameValuePair(AName, AValue), True);
  end;
end;

procedure TclHeaderFieldList.AddFieldIfNotExist(const AName, AValue: string);
begin
  if (AValue <> '') and (GetFieldIndex(AName) < 0) then
  begin
    InternalInsertField(HeaderEnd, GetNameValuePair(AName, AValue), True);
  end;
end;

procedure TclHeaderFieldList.AddFieldItem(const AFieldName, AItemName, AValue: string; ANewLine: Boolean);
begin
  AddFieldItem(GetFieldIndex(AFieldName), AItemName, AValue, ANewLine);
end;

procedure TclHeaderFieldList.AddFieldItem(AFieldIndex: Integer; const AItemName, AValue: string; ANewLine: Boolean);
begin
  if (Trim(AValue) <> '') then
  begin
    InternalAddFieldItem(AFieldIndex, AItemName, AValue, ANewLine);
  end;
end;

procedure TclHeaderFieldList.AddQuotedFieldItem(AFieldIndex: Integer; const AItemName, AValue: string);
begin
  AddQuotedFieldItem(AFieldIndex, AItemName, AValue, False);
end;

procedure TclHeaderFieldList.AddQuotedFieldItem(const AFieldName, AItemName, AValue: string);
begin
  AddQuotedFieldItem(AFieldName, AItemName, AValue, False);
end;

procedure TclHeaderFieldList.AddFields(AFields: TStrings);
var
  i: Integer;
begin
  for i := 0 to AFields.Count - 1 do
  begin
    InternalInsertField(HeaderEnd, AFields[i], True);
  end;
end;

procedure TclHeaderFieldList.AddNonFoldedField(const AName, AValue: string);
begin
  if (AValue <> '') then
  begin
    InternalInsertField(HeaderEnd, GetNameValuePair(AName, AValue), False);
  end;
end;

procedure TclHeaderFieldList.AddQuotedFieldItem(const AFieldName, AItemName, AValue: string; ANewLine: Boolean);
begin
  AddQuotedFieldItem(GetFieldIndex(AFieldName), AItemName, AValue, ANewLine);
end;

procedure TclHeaderFieldList.AddQuotedFieldItem(AFieldIndex: Integer; const AItemName, AValue: string; ANewLine: Boolean);
begin
  AddFieldItem(AFieldIndex, AItemName, GetQuotedString(AValue), ANewLine);
end;

constructor TclHeaderFieldList.Create;
begin
  inherited Create();

  FFieldList := TStringList.Create();
  FSource := nil;
  FHeaderStart := 0;
  FHeaderEnd := 0;
  FCharsPerLine := 0;
  FItemDelimiter := ';';
end;

destructor TclHeaderFieldList.Destroy;
begin
  FFieldList.Free();
  inherited Destroy();
end;

procedure TclHeaderFieldList.ClearFieldItem(const AFieldName, AItemName: string);
begin
  ClearFieldItem(GetFieldIndex(AFieldName), AItemName);
end;

procedure TclHeaderFieldList.ClearFieldItem(AFieldIndex: Integer; const AItemName: string);
var
  fieldSrc: TStrings;
  fieldStart: Integer;
begin
  Assert(Source <> nil);

  if (AFieldIndex < 0) or (AFieldIndex >= FieldList.Count) then Exit;

  fieldSrc := TStringList.Create();
  try
    GetFieldSource(AFieldIndex, fieldSrc);

    fieldStart := GetFieldStart(AFieldIndex);

    fieldSrc.Text := InternalClearFieldItem(fieldSrc.Text, AItemName);

    InternalRemoveField(AFieldIndex);

    InternalInsertFieldSource(fieldStart, fieldSrc);
  finally
    fieldSrc.Free();
  end;

  Parse(HeaderStart, Source);
end;

function TclHeaderFieldList.GetFieldValue(const AName: string): string;
begin
  Result := GetFieldValue(GetFieldIndex(AName));
end;

function TclHeaderFieldList.GetFieldName(const AName: string): string;
begin
  Result := GetFieldName(GetFieldIndex(AName));
end;

procedure TclHeaderFieldList.SkipWhiteSpace(var Next: PChar);
begin
  while (Next^ <> #0) do
  begin
    if not CharInSet(Next^, GetWhiteSpaces()) then Break;
    Inc(Next);
  end;
end;

procedure TclHeaderFieldList.GetStartLexem(const ASource, AItemName: string; var AStartLexem: string; var APosition: Integer);
var
  Start, Next: PChar;
  counter: Integer;
begin
  AStartLexem := '';
  APosition := 0;

  if (ASource = '') or (AItemName = '') then Exit;

  Next := @ASource[1];
  Start := Next;
  counter := 1;
  while (Next^ <> #0) do
  begin
    if (Next^ = AItemName[counter]) then
    begin
      if (counter = 1) then
      begin
        Start := Next;
      end;

      if (counter = Length(AItemName)) then
      begin
        Inc(Next);

        SkipWhiteSpace(Next);

        if (Next^ = '=') then
        begin
          APosition := Start - @ASource[1] + 1;
          AStartLexem := System.Copy(ASource, APosition, Next - Start + 1);

          Break;
        end;

        counter := 1;

        Continue;
      end;

      Inc(counter);
    end else
    begin
      counter := 1;
    end;

    Inc(Next);
  end;
end;

procedure TclHeaderFieldList.InternalGetFieldValueItem(const ASource, AItemName: string;
  var AValue: string; var AStartPos, ACount: Integer);
var
  i, ind: Integer;
  inCommas: Boolean;
  commaChar, startLexem: string;
begin
  if (AItemName = '') and (ASource <> '') then
  begin
    startLexem := '';
    ind := 1;
  end else
  begin
    GetStartLexem(LowerCase(ASource), AItemName, startLexem, ind);
  end;

  if (ind > 0) then
  begin
    AStartPos := ind;
    ACount := Length(ASource) - AStartPos + 1;

    AValue := system.Copy(ASource, AStartPos + Length(startLexem), MaxInt);

    inCommas := False;
    commaChar := '';
    for i := 1 to Length(AValue) do
    begin
      if (commaChar = '') and CharInSet(AValue[i], GetQuoteSymbols()) then
      begin
        commaChar := AValue[i];
        inCommas := not inCommas;
      end else
      if (commaChar <> '') and (AValue[i] = commaChar[1]) then
      begin
        AValue := system.Copy(AValue, 1, i);
        ACount := i + Length(startLexem);
        Break;
      end;
      if (not inCommas) and (CharInSet(AValue[i], GetItemDelimiters())) then
      begin
        AValue := system.Copy(AValue, 1, i - 1);
        ACount := i - 1 + Length(startLexem);
        Break;
      end;
    end;
  end else
  begin
    AValue := '';
    AStartPos := 0;
    ACount := 0;
  end;
end;

function TclHeaderFieldList.GetFieldEnd(AIndex: Integer): Integer;
var
  i: Integer;
begin
  if (AIndex < 0) or (AIndex > FieldList.Count - 1) then
  begin
    Result := -1;
    Exit;
  end;

  for i := GetFieldStart(AIndex) + 1 to Source.Count - 1 do
  begin
    if (Length(Source[i]) = 0) or (not CharInSet(Source[i][1], [#9, #32])) then
    begin
      Result := i - 1;
      Exit;
    end;
  end;

  Result := HeaderEnd - 1;
end;

function TclHeaderFieldList.GetFieldIndex(const AName: string): Integer;
begin
  Result := FieldList.IndexOf(LowerCase(AName));
end;

function TclHeaderFieldList.GetFieldEnd(const AName: string): Integer;
begin
  Result := GetFieldEnd(GetFieldIndex(AName));
end;

function TclHeaderFieldList.GetFieldName(AIndex: Integer): string;
begin
  Assert(Source <> nil);

  if (AIndex > -1) and (AIndex < FieldList.Count) then
  begin
    Result := System.Copy(FSource[GetFieldStart(AIndex)], 1, Length(FieldList[AIndex]));
  end else
  begin
    Result := '';
  end;
end;

function TclHeaderFieldList.GetFieldStart(const AName: string): Integer;
begin
  Result := GetFieldStart(GetFieldIndex(AName));
end;

procedure TclHeaderFieldList.GetFieldSource(const AName: string; AFieldSource: TStrings);
begin
  GetFieldSource(GetFieldIndex(AName), AFieldSource);
end;

procedure TclHeaderFieldList.GetFieldSource(AIndex: Integer; AFieldSource: TStrings);
var
  i: Integer;
begin
  Assert(Source <> nil);

  if (AIndex > -1) and (AIndex < FieldList.Count) then
  begin
    AFieldSource.Clear();

    for i := GetFieldStart(AIndex) to GetFieldEnd(AIndex) do
    begin
      AFieldSource.Add(Source[i]);
    end;
  end;
end;

function TclHeaderFieldList.GetFieldStart(AIndex: Integer): Integer;
begin
  if (AIndex > -1) and (AIndex < FieldList.Count) then
  begin
    Result := Integer(FieldList.Objects[AIndex]);
  end else
  begin
    Result := -1;
  end;
end;

function TclHeaderFieldList.GetFieldValue(AIndex: Integer): string;
begin
  Result := Trim(InternalGetFieldValue(AIndex));
end;

function TclHeaderFieldList.GetFieldValueItem(const ASource, AItemName: string): string;
var
  s: string;
  startPos, endPos: Integer;
begin
  InternalGetFieldValueItem(ASource, AItemName, s, startPos, endPos);
  s := Trim(s);
  if (s <> '') and CharInSet(s[1], GetQuoteSymbols()) and CharInSet(s[Length(s)], GetQuoteSymbols()) then
  begin
    Result := System.Copy(s, 2, Length(s) - 2);
  end else
  begin
    Result := s;
  end;
end;

function TclHeaderFieldList.GetQuoteSymbols: TCharSet;
begin
  Result := ['''', '"'];
end;

function TclHeaderFieldList.GetItemDelimiters: TCharSet;
begin
  Result := [';', ','];
end;

function TclHeaderFieldList.GetSpecialSymbols: TCharSet;
begin
  Result := [',', ';', '''', '"', '(', ')', '<', '>'];
end;

function TclHeaderFieldList.GetWhiteSpaces: TCharSet;
begin
  Result := [#32, #9, #13, #10];
end;

class function TclHeaderFieldList.GetItemNameValuePair(const AItemName, AValue: string): string;
begin
  Result := AItemName;
  if (Result <> '') and (Result[Length(Result)] <> '=') then
  begin
    Result := Result + '=';
  end;
  Result := Result + AValue;
end;

class function TclHeaderFieldList.GetNameValuePair(const AName, AValue: string): string;
begin
  Result := AValue;
  if (Result <> '') then
  begin
    Result := #32 + Result;
  end;
  Result := Format('%s:%s', [AName, Result]);
end;

class function TclHeaderFieldList.GetUnfoldedLine(const ALine: string): string;
begin
  Result := ALine;
  if ((Result <> '') and (Result[1] = #9)) then
  begin
    System.Delete(Result, 1, 1);
  end;
end;

procedure TclHeaderFieldList.InternalInsertField(AIndex: Integer; const AField: string; AFolded: Boolean);
var
  ind: Integer;
begin
  Assert(Source <> nil);
  Assert(System.Pos(#13#10, AField) < 1);

  ind := AIndex;
  if (ind < 0) then
  begin
    ind := 0;
  end;
  if (ind >= HeaderEnd) then
  begin
    ind := HeaderEnd;
  end;

  if (AField = '') then Exit;

  if AFolded and (CharsPerLine > 0) then
  begin
    InsertFoldedText(ind, AField, '', #9);
  end else
  begin
    Source.Insert(ind, AField);
  end;

  Parse(HeaderStart, Source);
end;

procedure TclHeaderFieldList.InternalAddFieldItem(AFieldIndex: Integer;
  const AItemName, AValue: string; ANewLine: Boolean);
var
  newline, line, trimmedLine: string;
  fieldEnd: Integer;
begin
  newline := Trim(AValue);

  Assert(Source <> nil);
  Assert(System.Pos(#13#10, AValue) < 1);

  if ((AFieldIndex < 0) or (AFieldIndex >= FieldList.Count)) then Exit;

  newline := GetItemNameValuePair(AItemName, newline);

  fieldEnd := GetFieldEnd(AFieldIndex);

  line := Source[fieldEnd];
  trimmedLine := Trim(line);

  if (trimmedLine <> '') and (not CharInSet(trimmedLine[Length(trimmedLine)], [ItemDelimiter, ':'])) then
  begin
    line := line + ItemDelimiter;
  end;

  if ANewLine or
    ((CharsPerLine > 0) and ((Length(line) + Length(newline) + Length(ItemDelimiter + #32) > CharsPerLine) or (System.Pos(#9#32, line) = 1))) then
  begin
    Source[fieldEnd] := line;
    if (CharsPerLine > 0) then
    begin
      InsertFoldedText(fieldEnd + 1, newline, #9, #9#32);
    end else
    begin
      Source.Insert(fieldEnd + 1, #9 + newline);
    end;
  end else
  begin
    Source[fieldEnd] := line + #32 + newline;
  end;
end;

function TclHeaderFieldList.InternalClearFieldItem(const AFieldSource, AItemName: string): string;
var
  s: string;
  nameLen, startPos, count: Integer;
begin
  Result := AFieldSource;

  InternalGetFieldValueItem(Result, AItemName, s, startPos, count);
  if ((startPos > 0) and (count > 0)) then
  begin
    nameLen := Length(GetItemNameValuePair(AItemName, ''));
    startPos := startPos + nameLen;
    count := count - nameLen;

    System.Delete(Result, startPos, count);
  end;
end;

procedure TclHeaderFieldList.AddFieldItem(AFieldIndex: Integer; const AItemName, AValue: string);
begin
  AddFieldItem(AFieldIndex, AItemName, AValue, False);
end;

procedure TclHeaderFieldList.InsertEmptyField(AIndex: Integer; const AName: string);
begin
  InternalInsertField(AIndex, GetNameValuePair(AName, ''), True);
end;

procedure TclHeaderFieldList.InsertField(AIndex: Integer; const AName, AValue: string);
begin
  if (AValue <> '') then
  begin
    InternalInsertField(AIndex, GetNameValuePair(AName, AValue), True);
  end;
end;

procedure TclHeaderFieldList.InsertFieldIfNotExist(AIndex: Integer; const AName, AValue: string);
begin
  if (AValue <> '') and (GetFieldIndex(AName) < 0) then
  begin
    InternalInsertField(AIndex, GetNameValuePair(AName, AValue), True);
  end;
end;

procedure TclHeaderFieldList.InsertFoldedStrings(AIndex: Integer;
  AStrings: TStrings; const AFirstFoldingTag, AFoldingTag: string);
var
  i: Integer;
  foldingTag: string;
begin
  for i := 0 to AStrings.Count - 1 do
  begin
    if (i = 0) then
    begin
      foldingTag := AFirstFoldingTag;
    end else
    begin
      foldingTag := AFoldingTag;
    end;

    Source.Insert(AIndex + i, foldingTag + AStrings[i]);

    Inc(FHeaderEnd);
  end;
end;

procedure TclHeaderFieldList.InsertFoldedText(AIndex: Integer; const AText, AFirstFoldingTag, AFoldingTag: string);
var
  ind, len, wordCnt, wordLen, insertAt: Integer;
  s: string;
begin
  insertAt := AIndex;

  len := Length(AText) + Length(ItemDelimiter);
  wordCnt := len div CharsPerLine;
  if (len mod CharsPerLine) > 0 then
  begin
    Inc(wordCnt);
  end;

  wordLen := Trunc(len / wordCnt);

  ind := 1;
  while (ind < len) do
  begin
    s := System.Copy(AText, ind, wordLen);

    if (Length(s) = 1) and CharInSet(s[1], GetSpecialSymbols()) and (insertAt > 1) then
    begin
      FSource[insertAt - 1] := FSource[insertAt - 1] + s;
    end else
    begin
      if (ind = 1) then
      begin
        s := AFirstFoldingTag + s;
      end else
      begin
        s := AFoldingTag + s;
      end;

      FSource.Insert(insertAt, s);
      Inc(insertAt);
      Inc(FHeaderEnd);
    end;
    Inc(ind, wordLen);
  end;
end;

procedure TclHeaderFieldList.InsertNonFoldedField(AIndex: Integer; const AName, AValue: string);
begin
  if (AValue <> '') then
  begin
    InternalInsertField(AIndex, GetNameValuePair(AName, AValue), False);
  end;
end;

procedure TclHeaderFieldList.AddFieldItem(const AFieldName, AItemName, AValue: string);
begin
  AddFieldItem(AFieldName, AItemName, AValue, False);
end;

function TclHeaderFieldList.InternalGetFieldValue(AIndex: Integer): string;
var
  Ind, i: Integer;
begin
  Assert(Source <> nil);

  if (AIndex > -1) and (AIndex < FieldList.Count) then
  begin
    Ind := GetFieldStart(AIndex);
    Result := System.Copy(Source[Ind], Length(FieldList[AIndex] + ':') + 1, MaxInt);
    Result := TrimFirstWhiteSpace(Result);
    for i := Ind + 1 to Source.Count - 1 do
    begin
      if not ((Source[i] <> '') and CharInSet(Source[i][1], [#9, #32])) then
      begin
        Break;
      end;
      Result := Result + GetUnfoldedLine(Source[i]);
    end;
  end else
  begin
    Result := '';
  end;
end;

function TclHeaderFieldList.Parse(AStartFrom: Integer; ASource: TStrings): Integer;
var
  ind: Integer;
begin
  FHeaderStart := AStartFrom;
  FFieldList.Clear();
  FSource := ASource;

  Result := AStartFrom;
  while (Result < FSource.Count) and (FSource[Result] <> '') do
  begin
    if not CharInSet(FSource[Result][1], [#9, #32]) then
    begin
      ind := System.Pos(':', FSource[Result]);
      if (ind > 0) then
      begin
        FFieldList.AddObject(LowerCase(System.Copy(FSource[Result], 1, ind - 1)), TObject(Result));
      end;
    end;
    Inc(Result);
  end;

  FHeaderEnd := Result;
end;

procedure TclHeaderFieldList.RemoveField(const AName: string);
begin
  RemoveField(GetFieldIndex(AName));
end;

procedure TclHeaderFieldList.InternalRemoveField(AIndex: Integer);
var
  i: Integer;
begin
  Assert(Source <> nil);

  if (AIndex > -1) and (AIndex < FieldList.Count) then
  begin
    i := GetFieldStart(AIndex);
    FSource.Delete(i);

    while (i < FSource.Count) do
    begin
      if (Length(FSource[i]) > 0) and CharInSet(FSource[i][1], [#9, #32]) then
      begin
        FSource.Delete(i);
      end else
      begin
        Break;
      end;
    end;
  end;
end;

procedure TclHeaderFieldList.RemoveField(AIndex: Integer);
begin
  if (AIndex > -1) and (AIndex < FieldList.Count) then
  begin
    InternalRemoveField(AIndex);
    Parse(HeaderStart, Source);
  end;
end;

procedure TclHeaderFieldList.RemoveFieldItem(const AFieldName, AItemName: string);
begin
  RemoveFieldItem(GetFieldIndex(AFieldName), AItemName);
end;

function TclHeaderFieldList.InternalRemoveFieldItem(const AFieldSource, AItemName: string): string;
var
  s: string;
  i, startPos, count: Integer;
  isLast: Boolean;
begin
  Result := AFieldSource;

  InternalGetFieldValueItem(Result, AItemName, s, startPos, count);
  if ((startPos > 0) and (count > 0)) then
  begin
    if (Length(Result) > startPos + count) and (Result[startPos + count] = ItemDelimiter) then
    begin
      Inc(count);
    end;

    isLast := True;
    for i := startPos + count to Length(Result) do
    begin
      if not CharInSet(Result[i], GetWhiteSpaces()) then
      begin
        isLast := False;
        Break;
      end;
    end;

    for i := startPos - 1 downto 1 do
    begin
      if (isLast and (Result[i] = ItemDelimiter)) or
        CharInSet(Result[i], GetWhiteSpaces()) then
      begin
        Dec(startPos);
        Inc(count);
      end else
      begin
        Break;
      end;
    end;

    System.Delete(Result, startPos, count);
  end;
end;

procedure TclHeaderFieldList.InternalInsertFieldSource(AIndex: Integer; AFieldSource: TStrings);
var
  i: Integer;
begin
  for i := 0 to AFieldSource.Count - 1 do
  begin
    Source.Insert(i + AIndex, AFieldSource[i]);
  end;
  SetHeaderEnd(HeaderEnd + AFieldSource.Count);
end;

procedure TclHeaderFieldList.RemoveFieldItem(AFieldIndex: Integer; const AItemName: string);
var
  fieldSrc: TStrings;
  fieldStart: Integer;
begin
  Assert(Source <> nil);

  if (AFieldIndex < 0) or (AFieldIndex >= FieldList.Count) then Exit;

  fieldSrc := TStringList.Create();
  try
    GetFieldSource(AFieldIndex, fieldSrc);

    fieldStart := GetFieldStart(AFieldIndex);

    fieldSrc.Text := InternalRemoveFieldItem(fieldSrc.Text, AItemName);

    InternalRemoveField(AFieldIndex);

    InternalInsertFieldSource(fieldStart, fieldSrc);
  finally
    fieldSrc.Free();
  end;

  Parse(HeaderStart, Source);
end;

procedure TclHeaderFieldList.SetHeaderEnd(AValue: Integer);
begin
  FHeaderEnd := AValue;
end;

class function TclHeaderFieldList.TrimFirstWhiteSpace(const ALine: string): string;
begin
  Result := ALine;
  if ((Result <> '') and CharInSet(Result[1], [#9, #32])) then
  begin
    System.Delete(Result, 1, 1);
  end;
end;

procedure TclHeaderFieldList.AddEmptyFieldItem(const AFieldName, AItemName: string; ANewLine: Boolean);
begin
  AddEmptyFieldItem(GetFieldIndex(AFieldName), AItemName, ANewLine);
end;

procedure TclHeaderFieldList.AddEmptyFieldItem(AFieldIndex: Integer; const AItemName: string; ANewLine: Boolean);
begin
  InternalAddFieldItem(AFieldIndex, AItemName, '', ANewLine);
end;

end.


