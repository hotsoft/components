{
  Clever Internet Suite
  Copyright (C) 2017 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCryptDataHeader;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clUtils;

type
  TclCryptEncodingFormat = (efNone, efPem, efSsh2);

  TclCryptDataHeader = class(TPersistent)
  private
    FExtraFields: TStrings;
    FContentDomain: string;
    FComment: string;
    FSubject: string;
    FDekInfo: string;
    FProcType: string;

    procedure SetExtraFields(const Value: TStrings);
    function ExtractSsh2Fields(ASource, AFields: TStrings): Integer;
    procedure AddSsh2Field(const AField: string; ASource: TStrings; ACharsPerLine: Integer);
  protected
    function ParsePem(const ASource: string): string; virtual;
    function ParseSsh2(const ASource: string): string; virtual;
    function BuildPem(ACharsPerLine: Integer): string; virtual;
    function BuildSsh2(ACharsPerLine: Integer): string; virtual;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure Clear; virtual;

    function Parse(const ASource: string; AEncodingFormat: TclCryptEncodingFormat): string;
    function Build(AEncodingFormat: TclCryptEncodingFormat; ACharsPerLine: Integer): string;
  published
    property ProcType: string read FProcType write FProcType;
    property ContentDomain: string read FContentDomain write FContentDomain;
    property DekInfo: string read FDekInfo write FDekInfo;

    property Subject: string read FSubject write FSubject;
    property Comment: string read FComment write FComment;

    property ExtraFields: TStrings read FExtraFields write SetExtraFields;
  end;

implementation

uses
  clHeaderFieldList;

const
  CRLF = #13#10;
  LF = #10;

{ TclCryptDataHeader }

procedure TclCryptDataHeader.Assign(Source: TPersistent);
var
  src: TclCryptDataHeader;
begin
  if (Source is TclCryptDataHeader) then
  begin
    src := TclCryptDataHeader(Source);

    FExtraFields.Assign(src.ExtraFields);

    FContentDomain := src.ContentDomain;
    FDekInfo := src.DekInfo;
    FProcType := src.ProcType;

    FComment := src.Comment;
    FSubject := src.Subject;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclCryptDataHeader.Clear;
begin
  FExtraFields.Clear();

  FContentDomain := '';
  FDekInfo := '';
  FProcType := '';

  FComment := '';
  FSubject := '';
end;

constructor TclCryptDataHeader.Create;
begin
  inherited Create();
  FExtraFields := TStringList.Create();
  Clear();
end;

destructor TclCryptDataHeader.Destroy;
begin
  FExtraFields.Free();
  inherited Destroy();
end;

procedure TclCryptDataHeader.SetExtraFields(const Value: TStrings);
begin
  FExtraFields.Assign(Value);
end;

function TclCryptDataHeader.Parse(const ASource: string; AEncodingFormat: TclCryptEncodingFormat): string;
begin
  Clear();

  if (AEncodingFormat = efPem) then
  begin
    Result := ParsePem(ASource);
  end else
  if (AEncodingFormat = efSsh2) then
  begin
    Result := ParseSsh2(ASource);
  end else
  begin
    Assert(False, 'Not supported encoding format');
  end;
end;

function TclCryptDataHeader.ParsePem(const ASource: string): string;
var
  fieldList: TclHeaderFieldList;
  src, knownFields: TStrings;
  i: Integer;
begin
  if (System.Pos(CRLF + CRLF, ASource) = 0) and (System.Pos(LF + LF, ASource) = 0) then
  begin
    Result := ASource;
    Exit;
  end;

  fieldList := nil;
  src := nil;
  knownFields := nil;
  try
    fieldList := TclHeaderFieldList.Create();

    src := TStringList.Create();

    src.Text := Trim(ASource);

    fieldList.Parse(0, src);

    ProcType := fieldList.GetFieldValue('Proc-Type');
    ContentDomain := fieldList.GetFieldValue('Content-Domain');
    DekInfo := fieldList.GetFieldValue('DEK-Info');

    knownFields := TStringList.Create();
    knownFields.Add('Proc-Type');
    knownFields.Add('Content-Domain');
    knownFields.Add('DEK-Info');

    for i := 0 to fieldList.FieldList.Count - 1 do
    begin
      if (FindInStrings(knownFields, fieldList.FieldList[i]) < 0) then
      begin
        ExtraFields.Add(fieldList.GetFieldName(i) + ': ' + fieldList.GetFieldValue(i));
      end;
    end;

    for i := fieldList.HeaderEnd downto 0 do
    begin
      src.Delete(i);
    end;

    Result := src.Text;
  finally
    knownFields.Free();
    src.Free();
    fieldList.Free();
  end;
end;

function TclCryptDataHeader.ExtractSsh2Fields(ASource, AFields: TStrings): Integer;
var
  src, field: string;
begin
  AFields.Clear();

  field := '';
  Result := 0;
  while (Result < ASource.Count) do
  begin
    src := ASource[Result];

    if (TextPos('Subject', src) = 1) or
      (TextPos('Comment', src) = 1) or
      (TextPos('x-', src) = 1) then
    begin
      if (field <> '') then
      begin
        AFields.Add(field);
      end;

      field := src;

      Inc(Result);
    end else
    if (field <> '') and (field[Length(field)] = '\') then
    begin
      System.Delete(field, Length(field), 1);

      field := field + src;

      Inc(Result);
    end else
    begin
      Break;
    end;
  end;

  if (field <> '') then
  begin
    AFields.Add(field);
  end;
end;

function TclCryptDataHeader.ParseSsh2(const ASource: string): string;
var
  src, fields: TStrings;
  i, ind, headerEnd: Integer;
  field, name, value: string;
begin
  src := nil;
  fields := nil;
  try
    src := TStringList.Create();

    SplitText(Trim(ASource), src, []);

    fields := TStringList.Create();

    headerEnd := ExtractSsh2Fields(src, fields);

    i := 0;
    while (i < fields.Count) do
    begin
      field := fields[i];
      ind := TextPos(':', field, 1);
      if (ind > 0) then
      begin
        name := System.Copy(field, 1, ind - 1);
        value := Trim(System.Copy(field, ind + 1, Length(field)));
        if (name = 'Subject') then
        begin
          Subject := value;
        end else
        if (name  = 'Comment') then
        begin
          Comment := ExtractQuotedString(value);
        end else
        begin
          ExtraFields.Add(field);
        end;
      end else
      begin
        ExtraFields.Add(field);
      end;

      Inc(i);
    end;

    Result := '';
    i := headerEnd;
    while (i < src.Count) do
    begin
      Result := Result + src[i] + CRLF;
      Inc(i);
    end;
  finally
    fields.Free();
    src.Free();
  end;
end;

function TclCryptDataHeader.Build(AEncodingFormat: TclCryptEncodingFormat; ACharsPerLine: Integer): string;
begin
  if (AEncodingFormat = efPem) then
  begin
    Result := BuildPem(ACharsPerLine);
  end else
  if (AEncodingFormat = efSsh2) then
  begin
    Result := BuildSsh2(ACharsPerLine);
  end else
  begin
    Assert(False, 'Not supported encoding format');
  end;
end;

function TclCryptDataHeader.BuildPem(ACharsPerLine: Integer): string;
var
  fieldList: TclHeaderFieldList;
  src: TStrings;
  hasData: Boolean;
begin
  hasData := (ProcType <> '') or (ContentDomain <> '') or (DekInfo <> '') or (ExtraFields.Count > 0);
  if (not hasData) then
  begin
    Result := '';
    Exit;
  end;

  fieldList := nil;
  src := nil;
  try
    fieldList := TclHeaderFieldList.Create();
    fieldList.CharsPerLine := ACharsPerLine;

    src := TStringList.Create();

    fieldList.Parse(0, src);

    fieldList.AddField('Proc-Type', ProcType);
    fieldList.AddField('Content-Domain', ContentDomain);
    fieldList.AddField('DEK-Info', DekInfo);

    fieldList.AddFields(ExtraFields);

    fieldList.AddEndOfHeader();

    Result := src.Text;
  finally
    src.Free();
    fieldList.Free();
  end;
end;

procedure TclCryptDataHeader.AddSsh2Field(const AField: string; ASource: TStrings; ACharsPerLine: Integer);
var
  ind, len, wordCnt, wordLen: Integer;
  s: string;
begin
  len := Length(AField) + Length('\');
  wordCnt := len div ACharsPerLine;
  if (len mod ACharsPerLine) > 0 then
  begin
    Inc(wordCnt);
  end;

  wordLen := Trunc(len / wordCnt);

  ind := 1;
  while (ind < len) do
  begin
    s := System.Copy(AField, ind, wordLen);

    if (ind + wordLen < len) then
    begin
      s := s + '\';
    end;

    ASource.Add(s);

    Inc(ind, wordLen);
  end;
end;

function TclCryptDataHeader.BuildSsh2(ACharsPerLine: Integer): string;
var
  hasData: Boolean;
  src: TStrings;
  i: Integer;
begin
  hasData := (Subject <> '') or (Comment <> '') or (ExtraFields.Count > 0);
  if (not hasData) then
  begin
    Result := '';
    Exit;
  end;

  src := TStringList.Create();
  try
    if (Subject <> '') then
    begin
      AddSsh2Field('Subject: ' + Subject, src, ACharsPerLine);
    end;

    if (Comment <> '') then
    begin
      AddSsh2Field('Comment: ' + GetQuotedString(Comment), src, ACharsPerLine);
    end;

    for i := 0 to ExtraFields.Count - 1 do
    begin
      AddSsh2Field(ExtraFields[i], src, ACharsPerLine);
    end;

    Result := src.Text;
  finally
    src.Free();
  end;
end;

end.
