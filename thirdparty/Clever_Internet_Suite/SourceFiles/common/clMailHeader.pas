{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clMailHeader;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clHeaderFieldList, clEmailAddress, clEncoder;

type
  TclMailHeaderFieldList = class(TclHeaderFieldList)
  private
    FCharSet: string;
    FEncoding: TclEncodeMethod;

    class function DecodeEncodedWord(const AFieldPart, ACharSet: string; AEncoding: TclEncodeMethod; ADecodedStream: TStream): string;
    class function TranslateDecodedWord(ADecodedStream: TStream; const ACharSet: string; AEncoding: TclEncodeMethod): string;
    class function EncodingNameToType(const AEncodingName: string): TclEncodeMethod;
    class procedure GetEncodedWord(const AText, ACharSet: string; var AEncodedWord: string; var AEncoding: TclEncodeMethod);
    class procedure GetStringsToEncode(const AText: string; AEncodedLength, ACharsPerLine: Integer; AStrings: TStrings);

    function GetMailFieldValue(AIndex: Integer): string;
  public
    constructor Create(const ACharSet: string; AEncoding: TclEncodeMethod; ACharsPerLine: Integer);

    function GetFieldValue(AIndex: Integer): string; overload; override;

    function GetDecodedFieldValue(const AName: string): string; overload;
    function GetDecodedFieldValue(AIndex: Integer): string; overload;

    function GetDecodedEmail(const AName: string): string; overload;
    function GetDecodedEmail(AIndex: Integer): string; overload;

    procedure GetDecodedEmailList(const AName: string; AList: TclEmailAddressList); overload;
    procedure GetDecodedEmailList(AIndex: Integer; AList: TclEmailAddressList); overload;

    function GetDecodedFieldValueItem(const ASource, AItemName: string): string;

    procedure AddEncodedField(const AName, AValue: string);
    procedure AddEncodedFieldItem(const AFieldName, AItemName, AValue: string); overload;
    procedure AddEncodedFieldItem(AFieldIndex: Integer; const AItemName, AValue: string); overload;

    procedure AddEncodedEmail(const AName, AValue: string);

    procedure AddEncodedEmailList(const AName: string; AList: TclEmailAddressList);

    class function DecodeEmail(const ACompleteEmail, ACharSet: string): string;
    class function DecodeField(const AFieldValue, ACharSet: string): string;
    class function EncodeEmail(const ACompleteEmail, ACharSet: string; AEncoding: TclEncodeMethod; ACharsPerLine: Integer): string;
    class function EncodeField(const AFieldValue, ACharSet: string; AEncoding: TclEncodeMethod; ACharsPerLine: Integer): string;

    property CharSet: string read FCharSet write FCharSet;
    property Encoding: TclEncodeMethod read FEncoding write FEncoding;
  end;

implementation

uses
  clUtils, clWUtils, clTranslator;

{ TclMailHeaderFieldList }

procedure TclMailHeaderFieldList.AddEncodedEmail(const AName, AValue: string);
var
  src: TStrings;
begin
  Assert(Source <> nil);

  if (Trim(AValue) <> '') then
  begin
    src := TStringList.Create();
    try
      src.Text := GetNameValuePair(AName, EncodeEmail(AValue, CharSet, Encoding,
        CharsPerLine - Length(AName) - Length(': ')));
      InsertFoldedStrings(HeaderEnd, src, '', #9);
    finally
      src.Free();
    end;

    Parse(HeaderStart, Source);
  end;
end;

procedure TclMailHeaderFieldList.AddEncodedEmailList(const AName: string; AList: TclEmailAddressList);
var
  i: Integer;
  src: TStrings;
  email: string;
begin
  Assert(Source <> nil);

  if (AList.Count > 0) then
  begin
    src := TStringList.Create();
    try
      email := EncodeEmail(AList[0].FullAddress, CharSet, Encoding, CharsPerLine - Length(AName) - Length(': '));
      if (AList.Count > 1) then
      begin
        email := email + ',';
      end;

      AddTextStr(src, GetNameValuePair(AName, email));

      for i := 1 to AList.Count - 1 do
      begin
        email := EncodeEmail(AList[i].FullAddress, CharSet, Encoding, CharsPerLine - Length(#9));
        if (i < AList.Count - 1) then
        begin
          email := email + ',';
        end;

        AddTextStr(src, email);
      end;

      InsertFoldedStrings(HeaderEnd, src, '', #9);
    finally
      src.Free();
    end;

    Parse(HeaderStart, Source);
  end;
end;

procedure TclMailHeaderFieldList.AddEncodedField(const AName, AValue: string);
var
  src: TStrings;
begin
  Assert(Source <> nil);

  if (Trim(AValue) <> '') then
  begin
    src := TStringList.Create();
    try
      src.Text := GetNameValuePair(AName, EncodeField(AValue, CharSet, Encoding,
        CharsPerLine - Length(AName) - Length(': ')));
      InsertFoldedStrings(HeaderEnd, src, '', #9);
    finally
      src.Free();
    end;

    Parse(HeaderStart, Source);
  end;
end;

procedure TclMailHeaderFieldList.AddEncodedFieldItem(AFieldIndex: Integer; const AItemName, AValue: string);
var
  src: TStrings;
  line, newline, trimmedLine: string;
  fieldEnd: Integer;
begin
  if ((AFieldIndex < 0) or (AFieldIndex >= FieldList.Count)) then Exit;

  Assert(Source <> nil);

  if (Trim(AValue) <> '') then
  begin
    src := TStringList.Create();
    try
      newline := GetQuotedString(EncodeField(AValue, CharSet, Encoding,
        CharsPerLine - Length(#9) - Length(AItemName) - Length('=""')));

      newline := GetItemNameValuePair(AItemName, newline);

      fieldEnd := GetFieldEnd(AFieldIndex);

      line := Source[fieldEnd];
      trimmedLine := Trim(line);

      if (trimmedLine <> '') and (not CharInSet(trimmedLine[Length(trimmedLine)], [';', ':'])) then
      begin
        line := line + ';';
      end;

      Source[fieldEnd] := line;

      src.Text := newline;
      InsertFoldedStrings(fieldEnd + 1, src, #9, #9);
    finally
      src.Free();
    end;
  end;
end;

procedure TclMailHeaderFieldList.AddEncodedFieldItem(const AFieldName, AItemName, AValue: string);
begin
  AddEncodedFieldItem(GetFieldIndex(AFieldName), AItemName, AValue);
end;

constructor TclMailHeaderFieldList.Create(const ACharSet: string;
  AEncoding: TclEncodeMethod; ACharsPerLine: Integer);
begin
  inherited Create();

  FCharSet := ACharSet;
  FEncoding := AEncoding;
  CharsPerLine := ACharsPerLine;
end;

class function TclMailHeaderFieldList.DecodeEmail(const ACompleteEmail, ACharSet: string): string;
var
  name, email: string;
begin
  Result := ACompleteEmail;
  if GetEmailAddressParts(Result, name, email) and (email <> '') then
  begin
    name := DecodeField(name, ACharSet);
    Result := GetCompleteEmailAddress(name, email);
  end;
end;

class function TclMailHeaderFieldList.DecodeEncodedWord(const AFieldPart,
  ACharSet: string; AEncoding: TclEncodeMethod; ADecodedStream: TStream): string;
var
  encoder: TclEncoder;
  oldPos: Int64;
begin
  encoder := TclEncoder.Create(nil);
  try
    encoder.SuppressCrlf := False;
    encoder.EncodeMethod := AEncoding;

    oldPos := ADecodedStream.Position;
    encoder.Decode(AFieldPart, ADecodedStream);
    ADecodedStream.Position := oldPos;

    Result := TranslateDecodedWord(ADecodedStream, ACharSet, AEncoding);
  finally
    encoder.Free();
  end;
end;

class function TclMailHeaderFieldList.DecodeField(const AFieldValue, ACharSet: string): string;
var
  Formatted: Boolean;
  EncodedBegin, FirstDelim,
  SecondDelim, EncodedEnd, TextBegin: Integer;
  CurLine, s, EncodingName, CharsetName: String;
  decodedStream: TStream;
  isUtf8: Boolean;
begin
  Result := '';

  decodedStream := TMemoryStream.Create();
  try
    Formatted := False;
    TextBegin := 1;
    CurLine := AFieldValue;
    EncodedBegin := Pos('=?', CurLine);
    isUtf8 := True;

    while (EncodedBegin <> 0) do
    begin
      Result := Result + Copy(CurLine, TextBegin, EncodedBegin - TextBegin);
      TextBegin := EncodedBegin;

      FirstDelim := TextPos('?', CurLine, EncodedBegin + 2);
      if (FirstDelim <> 0) then
      begin
        SecondDelim := TextPos('?', CurLine, FirstDelim + 1);
        if ((SecondDelim - FirstDelim) = 2) then
        begin
          EncodedEnd := TextPos('?=', CurLine, SecondDelim + 1);
          if (EncodedEnd <> 0) then
          begin
            try
              CharsetName := Copy(CurLine, EncodedBegin + 2, FirstDelim - 2 - EncodedBegin);
              EncodingName := CurLine[FirstDelim + 1];

              isUtf8 := isUtf8 and SameText(CharsetName, 'utf-8');

              s := Copy(CurLine, SecondDelim + 1, EncodedEnd - SecondDelim - 1);

              Result := Result + DecodeEncodedWord(s, CharsetName, EncodingNameToType(EncodingName), decodedStream);

              TextBegin := EncodedEnd + 2;
              Formatted := True;
            except
              TextBegin := EncodedBegin + 2;
              Result := Result + '=?';
            end;

            CurLine := Copy(CurLine, TextBegin, Length(CurLine));
            s := TrimLeft(CurLine);
            if (Pos('=?', s) <> 1) then
            begin
              s := GetUnfoldedLine(CurLine);
            end;
            CurLine := s;

            EncodedBegin := Pos('=?', CurLine);
            TextBegin := 1;
            Continue;
          end;
        end;
      end;

      EncodedBegin := 0;
    end;

    if (CurLine <> '') then
    begin
      Result := Result + Copy(CurLine, TextBegin, Length(CurLine));
    end;

    if Formatted and isUtf8 then
    begin
      decodedStream.Position := 0;
      Result := TranslateDecodedWord(decodedStream, 'utf-8', cmBase64);
    end else
    if (not Formatted) then
    begin
      Result := DecodeEncodedWord(AFieldValue, ACharSet, cmNone, decodedStream);
    end;
  finally
    decodedStream.Free();
  end;
end;

class function TclMailHeaderFieldList.EncodeEmail(const ACompleteEmail, ACharSet: string;
  AEncoding: TclEncodeMethod; ACharsPerLine: Integer): string;
var
  name, encodedName, email, encodedEmail: string;
  len, ind, chrsPerLine, encodedNameLen: Integer;
begin
  Result := ACompleteEmail;
  if GetEmailAddressParts(Result, name, email) then
  begin
    chrsPerLine := ACharsPerLine - Length(' <');
    encodedName := EncodeField(name, ACharSet, AEncoding, chrsPerLine);

    Result := GetCompleteEmailAddress(encodedName, email);
    encodedNameLen := Length(Result) - Length(email) - Length(' <>');
    len := RTextPos(#13#10, Result);

    if (len > 0) then
    begin
      len := chrsPerLine - (encodedNameLen - (len - 1) - Length(#13#10)) - Length(#9);
    end else
    begin
      len := chrsPerLine - encodedNameLen;
    end;

    if (len + 1 >= Length(email)) then
    begin
      len := Length(email);
    end;

    ind := 1;
    encodedEmail := System.Copy(email, ind, len);
    Inc(ind, len);

    while (ind < Length(email)) do
    begin
      len := ACharsPerLine - Length(#9) - Length('>');
      encodedEmail := encodedEmail + #13#10 + System.Copy(email, ind, len);
      Inc(ind, len);
    end;

    Result := GetCompleteEmailAddress(encodedName, encodedEmail);
  end;
end;

class function TclMailHeaderFieldList.EncodeField(const AFieldValue, ACharSet: string;
  AEncoding: TclEncodeMethod; ACharsPerLine: Integer): string;
var
  i: Integer;
  s: string;
  enc: TclEncodeMethod;
  list: TStrings;
begin
  Assert(ACharsPerLine > 0);

  Result := AFieldValue;
  if (Result = '') or (AEncoding = cmUUEncode) then Exit;

  list := TStringList.Create();
  try
    s := '';
    enc := AEncoding;
    GetEncodedWord(AFieldValue, ACharSet, s, enc);

    GetStringsToEncode(AFieldValue, Length(s), ACharsPerLine, list);

    if (enc = cmNone) and (list.Count > 1) then
    begin
      s := '';
      enc := cmQuotedPrintable;
      GetEncodedWord(AFieldValue, ACharSet, s, enc);

      GetStringsToEncode(AFieldValue, Length(s), ACharsPerLine, list);
    end;

    Result := '';

    for i := 0 to list.Count - 1 do
    begin
      s := '';
      GetEncodedWord(list[i], ACharSet, s, enc);
      Result := Result + s + #13#10;
    end;

    Result := Trim(Result);

    if (Result = '') then
    begin
      Result := AFieldValue;
    end;
  finally
    list.Free();
  end;
end;

class function TclMailHeaderFieldList.EncodingNameToType(const AEncodingName: string): TclEncodeMethod;
begin
  Result := cmNone;
  if (AEncodingName = '') then Exit;
  case UpperCase(AEncodingName)[1] of
    'Q': Result := cmQuotedPrintable;
    'B': Result := cmBase64;
  end;
end;

function TclMailHeaderFieldList.GetDecodedFieldValue(const AName: string): string;
begin
  Result := GetDecodedFieldValue(GetFieldIndex(AName));
end;

function TclMailHeaderFieldList.GetDecodedEmail(const AName: string): string;
begin
  Result := GetDecodedEmail(GetFieldIndex(AName));
end;

function TclMailHeaderFieldList.GetDecodedEmail(AIndex: Integer): string;
begin
  Result := DecodeEmail(GetFieldValue(AIndex), CharSet);
end;

procedure TclMailHeaderFieldList.GetDecodedEmailList(const AName: string; AList: TclEmailAddressList);
begin
  GetDecodedEmailList(GetFieldIndex(AName), AList);
end;

procedure TclMailHeaderFieldList.GetDecodedEmailList(AIndex: Integer; AList: TclEmailAddressList);
var
  i: Integer;
  list: TStrings;
begin
  AList.Clear();

  if ((AIndex < 0) or (AIndex >= FieldList.Count)) then Exit;

  list := TStringList.Create();
  try
    ExtractQuotedWords(GetFieldValue(AIndex), list, ',', ['"', '('], ['"', ')'], True);
    for i := 0 to list.Count - 1 do
    begin
      AList.Add(DecodeEmail(Trim(list[i]), CharSet));
    end;
  finally
    list.Free();
  end;
end;

function TclMailHeaderFieldList.GetDecodedFieldValue(AIndex: Integer): string;
begin
  Result := DecodeField(GetFieldValue(AIndex), CharSet);
end;

function TclMailHeaderFieldList.GetDecodedFieldValueItem(const ASource, AItemName: string): string;
begin
  Result := DecodeField(GetFieldValueItem(ASource, AItemName), CharSet);
end;

class procedure TclMailHeaderFieldList.GetEncodedWord(const AText, ACharSet: string;
  var AEncodedWord: string; var AEncoding: TclEncodeMethod);
const
  EncodingToName: array[TclEncodeMethod] of string = ('', 'Q', 'B', '', '');
var
  cnt: Integer;
  src: TStream;
  buf: TclByteArray;
  encoder: TclEncoder;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  src := nil;
  encoder := nil;
  try
    src := TMemoryStream.Create();

    cnt := TclTranslator.GetByteCount(AText, ACharSet);
    if (cnt > 0) then
    begin
      SetLength(buf, cnt);
      buf := TclTranslator.GetBytes(AText, ACharSet);
      src.Write(buf[0], cnt);
    end;

    encoder := TclEncoder.Create(nil);
    encoder.SuppressCrlf := True;
    encoder.EncodeMethod := AEncoding;

    if (encoder.EncodeMethod = cmNone) then
    begin
      src.Position := 0;
      encoder.EncodeMethod := encoder.GetPreferredEncoding(src);
    end;

    AEncoding := encoder.EncodeMethod;

    src.Position := 0;
    AEncodedWord := encoder.Encode(src);

    if (encoder.EncodeMethod = cmQuotedPrintable) then
    begin
      AEncodedWord := StringReplace(AEncodedWord, #32, '_', [rfReplaceAll]);
      AEncodedWord := StringReplace(AEncodedWord, '='#13#10, #13#10, [rfReplaceAll]);
    end;

    if (EncodingToName[encoder.EncodeMethod] <> '') then
    begin
      AEncodedWord := Format('=?%s?%s?%s?=', [ACharSet, EncodingToName[encoder.EncodeMethod], AEncodedWord]);
    end;
  finally
    encoder.Free();
    src.Free();
  end;
end;

function TclMailHeaderFieldList.GetMailFieldValue(AIndex: Integer): string;
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
      if (Result <> '') and (Result[Length(Result)] = '>') then
      begin
        Result := Result + ',';
      end;
      Result := Result + GetUnfoldedLine(Source[i]);
    end;
  end else
  begin
    Result := '';
  end;
end;

class procedure TclMailHeaderFieldList.GetStringsToEncode(const AText: string; AEncodedLength, ACharsPerLine: Integer; AStrings: TStrings);
var
  ind, len, wordCnt, wordLen: Integer;
begin
  AStrings.Clear();

  wordCnt := AEncodedLength div ACharsPerLine;

  if (AEncodedLength mod ACharsPerLine) > 0 then
  begin
    Inc(wordCnt);
  end;

  len := Length(AText);
  wordLen := Trunc(len / wordCnt);

  ind := 1;
  while (ind <= len) do
  begin
    AStrings.Add(system.Copy(AText, ind, wordLen));
    Inc(ind, wordLen);
  end;
end;

function TclMailHeaderFieldList.GetFieldValue(AIndex: Integer): string;
begin
  Result := '';

  if ((AIndex < 0) or (AIndex >= FieldList.Count)) then Exit;

  if ('subject' = FieldList[AIndex]) then
  begin
    Result := InternalGetFieldValue(AIndex);
  end else
  begin
    Result := Trim(GetMailFieldValue(AIndex));
  end;
end;

class function TclMailHeaderFieldList.TranslateDecodedWord(ADecodedStream: TStream;
  const ACharSet: string; AEncoding: TclEncodeMethod): string;
var
  i: Integer;
  buf: TclByteArray;
  size: Int64;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  Result := '';

  size := ADecodedStream.Size - ADecodedStream.Position;

  if (size > 0) then
  begin
    SetLength(buf, size);
    ADecodedStream.Read(buf[0], size);

    if (AEncoding = cmQuotedPrintable) then
    begin
      for i := 0 to size - 1 do
      begin
        if (buf[i] = 95) then //'_'
          buf[i] := 32; //' '
      end;
    end;

    Result := TclTranslator.GetString(buf, 0, size, ACharSet);
  end;
end;

end.


