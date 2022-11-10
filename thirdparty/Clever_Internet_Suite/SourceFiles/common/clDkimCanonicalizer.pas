{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clDkimCanonicalizer;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clHeaderFieldList, clConfig, clDkimUtils;

type
  TclDkimCanonicalizer = class(TclConfigObject)
  protected
    procedure TrimTrailingLineBreaks(var ABody: string);
    function GetBodyLine(const ALine: string): string; virtual; abstract;
    function GetHeaderValue(AFieldList: TclHeaderFieldList; AIndex: Integer): string; virtual; abstract;
    function GetHeaderName(const AName: string): string; virtual; abstract;
  public
    function CanonicalizeBody(AMessage: TStrings): string; virtual;
    function CanonicalizeHeader(AMessage: TStrings; const AHeaderField: string): string; overload;
    function CanonicalizeHeader(AMessage, AHeaderFields: TStrings): string; overload; virtual;
  end;

  TclDkimRelaxedCanonicalizer = class(TclDkimCanonicalizer)
  private
    function SkipWhiteSpace(var Next: PChar): Boolean;
    function ReduceWhiteSpace(const AText: string): string;
  protected
    function GetBodyLine(const ALine: string): string; override;
    function GetHeaderValue(AFieldList: TclHeaderFieldList; AIndex: Integer): string; override;
    function GetHeaderName(const AName: string): string; override;
  end;

  TclDkimSimpleCanonicalizer = class(TclDkimCanonicalizer)
  protected
    function GetBodyLine(const ALine: string): string; override;
    function GetHeaderValue(AFieldList: TclHeaderFieldList; AIndex: Integer): string; override;
    function GetHeaderName(const AName: string): string; override;
  end;

implementation

uses
  clUtils, clWUtils;

const
  CRLF = #13#10;

{ TclDkimSimpleCanonicalizer }

function TclDkimSimpleCanonicalizer.GetBodyLine(const ALine: string): string;
begin
  Result := ALine;
end;

function TclDkimSimpleCanonicalizer.GetHeaderName(const AName: string): string;
begin
  Result := AName;
end;

function TclDkimSimpleCanonicalizer.GetHeaderValue(AFieldList: TclHeaderFieldList; AIndex: Integer): string;
var
  Ind, i: Integer;
begin
  if (AIndex > -1) and (AIndex < AFieldList.FieldList.Count) then
  begin
    Ind := AFieldList.GetFieldStart(AIndex);
    Result := system.Copy(AFieldList.Source[Ind], Length(AFieldList.FieldList[AIndex] + ':') + 1, MaxInt) + CRLF;
    for i := Ind + 1 to AFieldList.Source.Count - 1 do
    begin
      if not ((AFieldList.Source[i] <> '') and CharInSet(AFieldList.Source[i][1], [#9, #32])) then
      begin
        Break;
      end;
      Result := Result + AFieldList.Source[i] + CRLF;
    end;
  end else
  begin
    Result := '';
  end;
end;

{ TclDkimRelaxedCanonicalizer }

function TclDkimRelaxedCanonicalizer.GetBodyLine(const ALine: string): string;
begin
  Result := ReduceWhiteSpace(ALine);
end;

function TclDkimRelaxedCanonicalizer.GetHeaderName(const AName: string): string;
begin
  Result := LowerCase(Trim(AName));
end;

function TclDkimRelaxedCanonicalizer.GetHeaderValue(AFieldList: TclHeaderFieldList; AIndex: Integer): string;
var
  Ind, i: Integer;
  folded: Boolean;
begin
  if (AIndex > -1) and (AIndex < AFieldList.FieldList.Count) then
  begin
    folded := False;
    Ind := AFieldList.GetFieldStart(AIndex);
    Result := system.Copy(AFieldList.Source[Ind], Length(AFieldList.FieldList[AIndex] + ':') + 1, MaxInt);
    for i := Ind + 1 to AFieldList.Source.Count - 1 do
    begin
      if not ((AFieldList.Source[i] <> '') and CharInSet(AFieldList.Source[i][1], [#9, #32])) then
      begin
        Break;
      end;
      Result := Result + AFieldList.Source[i];
      folded := True;
    end;

    if folded then
    begin
      Result := ReduceWhiteSpace(StringReplace(Trim(Result), CRLF, '', [rfReplaceAll])) + CRLF;
    end else
    begin
      Result := ReduceWhiteSpace(Trim(Result)) + CRLF;
    end;
  end else
  begin
    Result := '';
  end;
end;

function TclDkimRelaxedCanonicalizer.ReduceWhiteSpace(const AText: string): string;
var
  Next: PChar;
begin
  Result := '';
  if (AText = '') then Exit;

  Next := @AText[1];

  while (Next^ <> #0) do
  begin
    if SkipWhiteSpace(Next) and (Next^ <> #0) then
    begin
      Result := Result + #32;
    end;

    if (Next^ = #0) then Break;

    Result := Result + Next^;

    Inc(Next);
  end;
end;

function TclDkimRelaxedCanonicalizer.SkipWhiteSpace(var Next: PChar): Boolean;
begin
  Result := False;
  while (Next^ <> #0) do
  begin
    case (Next^) of
      #32, #9, #13, #10: Result := True;
    else
      Break;
    end;
    Inc(Next);
  end;
end;

{ TclDkimCanonicalizer }

function TclDkimCanonicalizer.CanonicalizeBody(AMessage: TStrings): string;
var
  i, len, size, count, start: Integer;
  p: PChar;
  s: string;
  fieldList: TclHeaderFieldList;
begin
  fieldList := TclDkimHeaderFieldList.Create();
  try
    fieldList.Parse(0, AMessage);

    start := fieldList.HeaderEnd;
    if (start > 0) then
    begin
      Inc(start);
    end;

    count := AMessage.Count - start;

    size := 0;
    for i := 0 to count - 1 do
    begin
      Inc(size, Length(AMessage[i + start]) + Length(CRLF));
    end;

    SetString(Result, nil, size);

    size := 0;
    p := Pointer(Result);
    for i := 0 to count - 1 do
    begin
      s := GetBodyLine(AMessage[i + start]);
      len := Length(s);
      if (len <> 0) then
      begin
        System.Move(Pointer(s)^, p^, GetCharByteCount(len));
        Inc(p, len);
      end;
      Inc(size, len);

      len := Length(CRLF);
      System.Move(CRLF, p^, GetCharByteCount(len));
      Inc(p, len);
      Inc(size, len);
    end;

    SetLength(Result, size);

    TrimTrailingLineBreaks(Result);

    if (Result = '') then
    begin
      Result := CRLF;
    end;
  finally
    fieldList.Free();
  end;
end;

function TclDkimCanonicalizer.CanonicalizeHeader(AMessage, AHeaderFields: TStrings): string;
var
  i, fieldIndex: Integer;
  fieldList: TclDkimHeaderFieldList;
begin
  fieldList := TclDkimHeaderFieldList.Create();
  try
    fieldList.Parse(0, AMessage);
    Result := '';

    fieldList.ResetFieldIndex();

    for i := 0 to AHeaderFields.Count - 1 do
    begin
      fieldIndex := fieldList.NextFieldIndex(AHeaderFields[i]);
      if (fieldIndex > -1) then
      begin
        Result := Result + GetHeaderName(fieldList.GetFieldName(fieldIndex)) + ':' + GetHeaderValue(fieldList, fieldIndex);
      end;
    end;
  finally
    fieldList.Free();
  end;
end;

function TclDkimCanonicalizer.CanonicalizeHeader(AMessage: TStrings; const AHeaderField: string): string;
var
  list: TStrings;
begin
  list := TStringList.Create();
  try
    list.Add(AHeaderField);
    Result := CanonicalizeHeader(AMessage, list);
  finally
    list.Free();
  end;
end;

procedure TclDkimCanonicalizer.TrimTrailingLineBreaks(var ABody: string);
var
  cnt, startSize, size: Integer;
begin
  cnt := Length(CRLF);
  size := Length(ABody);
  startSize := size;
  while (size > 0) do
  begin
    if (CRLF[cnt] = ABody[size]) then
    begin
      Dec(cnt);
    end else
    begin
      Break;
    end;

    if (cnt = 0) then
    begin
      cnt := Length(CRLF);
    end;

    Dec(size);
  end;

  if (startSize >= size + Length(CRLF)) then
  begin
    size := size + Length(CRLF);
  end;

  SetLength(ABody, size);
end;

end.
