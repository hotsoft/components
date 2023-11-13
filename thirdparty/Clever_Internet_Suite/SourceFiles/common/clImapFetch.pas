{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clImapFetch;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Contnrs,
{$ELSE}
  System.Classes, System.SysUtils, System.Contnrs,
{$ENDIF}
  clMailMessage, clMailHeader;

type
  TclImap4FetchEnvelope = class
  private
    class function Normalize(const ASource: string): string;
    class function GetField(AFieldList: TclMailHeaderFieldList; const AName: string): string;
    class function GetSubjectField(AFieldList: TclMailHeaderFieldList): string;
    class function GetMBName(const AEmail: string): string;
    class function GetDName(const AEmail: string): string;
    class function GetMails(AFieldList: TclMailHeaderFieldList; const AName: string): string;
    class function NormalizeName(const ASource: string): string;
  public
    class procedure Build(AMessage: TStrings; AResponse: TStream);
  end;

  TclImap4FetchBodyStructure = class
  private
    class procedure GetUueBodySize(AMessage: TStrings; var ASize, ALines: Integer);
    class function GetMimeBodySize(ABody: TclMessageBody): string;
    class function GetMimeBodyStructure(ABodies: TclMessageBodies): string;
    class procedure ExtractContentTypeParts(const AContentType: string; var AType, ASubType: string);
  public
    class procedure Build(AMessage: TStrings; AResponse: TStream);
  end;

  TclImap4FetchBody = class
  private
    class procedure BuildBodyPartTitle(const ACommand: string; ADataSize: Integer; AResponse: TStream);
    class procedure BuildBodyContent(AMessage: TStrings; ABody: TclMessageBody;
			const ACommand: string; AResponse: TStream; AReturnHeader: Boolean);
    class function BuildTextBody(AMessage: TStrings; ABodies: TclMessageBodies;
			const ACommand: string; AResponse: TStream): Boolean;
    class procedure BuildBodyFields(AMessage: TStrings; ABody: TclMessageBody;
			const ACommand, AFetchFields: string; AResponse: TStream; isNot: Boolean);
    class procedure BuildBodyPart(AMessage: TStrings; ABodies: TclMessageBodies; AParent: TclMessageBody;
      const ACommand: string; ABodyPart: TStrings; AResponse: TStream);
  public
    class procedure Build(AMessage: TStrings; const ACommand, ABodyPart: string; AResponse: TStream);
  end;

  TclImap4FetchItem = class
  private
    FName: string;
    FPartial: string;
    FSection: string;
  public
    constructor Create(const AName: string);

    property Name: string read FName write FName;
    property Section: string read FSection write FSection;
    property Partial: string read FPartial write FPartial;
  end;

  TclImap4FetchList = class
  private
    FList: TObjectList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TclImap4FetchItem;
    procedure ParseDataItems(const ASource: string);
    procedure ParseBodyStructure;
    procedure ParseMacros;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Parse(const ASource: string); virtual;
    procedure Add(AItem: TclImap4FetchItem);
    procedure Delete(Index: Integer);
    procedure Clear;
    property Items[Index: Integer]: TclImap4FetchItem read GetItem; default;
    property Count: Integer read GetCount;
  end;

implementation

uses
  clUtils, clEmailAddress, clEncoder, clWUtils, clTranslator;

const
  EncodingMap: array[TclEncodeMethod] of string = ('"7bit"', '"quoted-printable"', '"base64"', 'NIL', '"8bit"');

{ TclImap4FetchEnvelope }

class procedure TclImap4FetchEnvelope.Build(AMessage: TStrings; AResponse: TStream);
var
  fieldList: TclMailHeaderFieldList;
  from, sender, result: string;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  fieldList := TclMailHeaderFieldList.Create(DefaultCharSet, cmNone, DefaultCharsPerLine);
  try
    fieldList.Parse(0, AMessage);

    result := GetField(fieldList, 'Date') + #32;
    result := result + GetSubjectField(fieldList) + #32;

    from := GetMails(fieldList, 'From');
    result := result + from + #32;

    sender := GetMails(fieldList, 'Sender');
    if (sender = 'NIL') then
    begin
      sender := from;
    end;
    result := result + sender + #32;

    result := result + GetMails(fieldList, 'Reply-To') + #32;
    result := result + GetMails(fieldList, 'To') + #32;
    result := result + GetMails(fieldList, 'Cc') + #32;
    result := result + GetMails(fieldList, 'Bcc') + #32;
    result := result + 'NIL'#32;
    result := result + GetField(fieldList, 'Message-ID');

    result := 'ENVELOPE (' + result + ')';

    buf := TclTranslator.GetBytes(result);
    AResponse.Write(buf[0], Length(buf));
  finally
    fieldList.Free();
  end;
end;

class function TclImap4FetchEnvelope.GetDName(const AEmail: string): string;
var
  ind: Integer;
begin
  Result := AEmail;
  ind := system.Pos('@', AEmail);
  if (ind > 0) then
  begin
    Result := system.Copy(AEmail, ind + 1, Length(AEmail));
  end;
end;

class function TclImap4FetchEnvelope.GetField(AFieldList: TclMailHeaderFieldList; const AName: string): string;
begin
  Result := Normalize(AFieldList.GetFieldValue(AName));
end;

class function TclImap4FetchEnvelope.GetSubjectField(AFieldList: TclMailHeaderFieldList): string;
begin
  Result := GetQuotedString(AFieldList.GetFieldValue('Subject'));
end;

class function TclImap4FetchEnvelope.GetMails(AFieldList: TclMailHeaderFieldList; const AName: string): string;
var
  i: Integer;
  list: TStrings;
  addr: TclEmailAddressItem;
begin
  Result := '';

  list := nil;
  addr := nil;
  try
    list := TStringList.Create();
    addr := TclEmailAddressItem.Create();

    list.Text := StringReplace(AFieldList.GetFieldValue(AName), ',', #13#10, [rfReplaceAll]);

    for i := 0 to list.Count - 1 do
    begin
      addr.FullAddress := list[i];

      Result := Result + '(' + NormalizeName(addr.Name) + #32'NIL'#32 + Normalize(GetMBName(addr.Email)) + #32
         + Normalize(GetDName(addr.Email)) + ')';
    end;
  finally
    addr.Free();
    list.Free();
  end;

  if (Result = '') then
  begin
    Result := 'NIL';
  end else
  begin
    Result := '(' + Result + ')';
  end;
end;

class function TclImap4FetchEnvelope.GetMBName(const AEmail: string): string;
var
  ind: Integer;
begin
  Result := '';
  ind := system.Pos('@', AEmail);
  if (ind > 0) then
  begin
    Result := system.Copy(AEmail, 1, ind - 1);
  end;
end;

class function TclImap4FetchEnvelope.Normalize(const ASource: string): string;
begin
  if (ASource = '') then
  begin
    Result := 'NIL';
  end else
  begin
    Result := '"' + ASource + '"';
  end;
end;

class function TclImap4FetchEnvelope.NormalizeName(const ASource: string): string;
begin
  if (ASource = '') then
  begin
    Result := 'NIL';
  end else
  begin
    Result := '{' + IntToStr(Length(ASource)) + '}'#13#10 + ASource;
  end;
end;

{ TclImap4FetchBodyStructure }

class procedure TclImap4FetchBodyStructure.Build(AMessage: TStrings; AResponse: TStream);
var
  msg: TclMailMessage;
  cntType, subType, result: string;
  size, lines: Integer;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  msg := TclMailMessage.Create(nil);
  try
    msg.MessageSource := AMessage;

    if (msg.MessageFormat = mfUUencode) then
    begin
      GetUueBodySize(AMessage, size, lines);
      result := Format('"TEXT" "PLAIN" NIL NIL NIL "7BIT" %d %d NIL NIL NIL', [size, lines]);
    end else
    begin
      result := GetMimeBodyStructure(msg.Bodies);

      if (msg.Bodies.Count > 1) and (msg.Boundary <> '') then
      begin
        ExtractContentTypeParts(msg.ContentType, cntType, subType);

        cntType := '';
        if (msg.ContentSubType <> '') then
        begin
          cntType := Format('"type" "%s" ', [msg.ContentSubType]);
        end;

        result := Trim(Result) + Format(' %s (%s"boundary" "%s") NIL NIL',
          [subType, cntType, msg.Boundary]);
      end;
    end;

    result := 'BODYSTRUCTURE (' + result + ')';

    buf := TclTranslator.GetBytes(result);
    AResponse.Write(buf[0], Length(buf));
  finally
    msg.Free();
  end;
end;

class procedure TclImap4FetchBodyStructure.ExtractContentTypeParts(
  const AContentType: string; var AType, ASubType: string);
var
  words: TStrings;
begin
  AType := 'NIL';
  ASubType := 'NIL';

  words := TStringList.Create();
  try
    ExtractQuotedWords(AContentType, words, '/');

    if (words.Count > 0) then
    begin
      AType := '"' + words[0] + '"';
    end;

    if (words.Count > 1) then
    begin
      ASubType := '"' + words[1] + '"';
    end;
  finally
    words.Free();
  end;
end;

class function TclImap4FetchBodyStructure.GetMimeBodySize(ABody: TclMessageBody): string;
var
  cntType, subType: string;
begin
  ExtractContentTypeParts(ABody.ContentType, cntType, subType);
  if SameText(cntType, '"text"') then
  begin
    Result := Format('%d %d ', [ABody.EncodedSize, ABody.EncodedLines]);
  end else
  begin
    Result := Format('%d ', [ABody.EncodedSize]);
  end;
end;

class function TclImap4FetchBodyStructure.GetMimeBodyStructure(ABodies: TclMessageBodies): string;
var
  i: Integer;
  body: TclMessageBody;
  s, cntType, subType: string;
begin
  Result := '';

  for i := 0 to ABodies.Count - 1 do
  begin
    body := ABodies[i];

    if (ABodies.Count > 1) then
    begin
      Result := Result + '(';
    end;

    if (body is TclTextBody) then
    begin
      ExtractContentTypeParts(body.ContentType, cntType, subType);
      Result := Result + Format('%s %s ', [cntType, subType]);

      if (TclTextBody(body).CharSet <> '') then
      begin
        Result := Result + Format('("charset" "%s") ', [TclTextBody(body).CharSet]);
      end;
      
      Result := Result + 'NIL NIL ' + EncodingMap[body.Encoding] + ' ';
      Result := Result + GetMimeBodySize(body);
      Result := Result + 'NIL NIL NIL';
    end else
    if (body is TclAttachmentBody) then
    begin
      ExtractContentTypeParts(body.ContentType, cntType, subType);
      Result := Result + Format('%s %s ', [cntType, subType]);

      Result := Result + Format('("name" "%s") ', [TclAttachmentBody(body).FileName]);
      s := TclAttachmentBody(body).ContentID;
      if (s <> '') then
      begin
        if (s[1] <> '<') then
        begin
          s := '<' + s + '>';
        end;
        Result := Result + '"' + s + '" NIL ';
        Result := Result + EncodingMap[body.Encoding] + ' ';
        Result := Result + GetMimeBodySize(body);
        Result := Result + 'NIL NIL NIL'; 
      end else
      begin
        Result := Result + 'NIL NIL '+ EncodingMap[body.Encoding] + ' ';
        Result := Result + GetMimeBodySize(body);
        Result := Result + Format('NIL ("attachment" ("filename" "%s")) NIL', [TclAttachmentBody(body).FileName]);
      end;
    end else
    if (body is TclMultipartBody) then
    begin
      Result := Result + GetMimeBodyStructure(TclMultipartBody(body).Bodies);

      ExtractContentTypeParts(body.ContentType, cntType, subType);

      cntType := '';
      if (TclMultipartBody(body).ContentSubType <> '') then
      begin
        cntType := Format('"type" "%s" ', [TclMultipartBody(body).ContentSubType]);
      end;

      Result := Trim(Result) + Format(' %s (%s"boundary" "%s") NIL NIL',
        [subType, cntType, TclMultipartBody(body).Boundary]);
    end;
    
    if (ABodies.Count > 1) then
    begin
      Result := Result + ')';
    end;
  end;
end;

class procedure TclImap4FetchBodyStructure.GetUueBodySize(AMessage: TStrings;
  var ASize, ALines: Integer);
var
  i: Integer;
  isBody: Boolean;
begin
  ASize := 0;
  ALines := 0;
  isBody := False;
  for i := 0 to AMessage.Count - 1 do
  begin
    if isBody then
    begin
      ASize := ASize + Length(AMessage[i]) + Length(#13#10);
    end else
    if (AMessage[i] = '') then
    begin
      isBody := True;
      ALines := i;
    end;
  end;
  if (ALines > 0) then
  begin
    ALines := AMessage.Count - ALines - 1;
  end;
end;

{ TclImap4FetchBody }

class procedure TclImap4FetchBody.Build(AMessage: TStrings; const ACommand,
  ABodyPart: string; AResponse: TStream);
var
  msg: TclMailMessage;
  bodyPart: TStrings;
begin
  if (ABodyPart = '') then
  begin
    BuildBodyPartTitle(ACommand, GetStringsSize(AMessage), AResponse);
    TclStringsUtils.SaveStrings(AMessage, AResponse, '');
  end else
  begin
    msg := nil;
    bodyPart := nil;
    try
      msg := TclMailMessage.Create(nil);
      bodyPart := TStringList.Create();
      
      msg.MessageSource := AMessage;
      ExtractQuotedWords(UpperCase(ABodyPart), bodyPart, '.');
      BuildBodyPart(AMessage, msg.Bodies, nil, ACommand, bodyPart, AResponse);
    finally
      bodyPart.Free();
      msg.Free();
    end;
  end;
end;

class procedure TclImap4FetchBody.BuildBodyContent(AMessage: TStrings;
  ABody: TclMessageBody; const ACommand: string; AResponse: TStream;
  AReturnHeader: Boolean);
var
  i, ind, len,
  start, lines, size: Integer;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  if (ABody <> nil) then
  begin
    if AReturnHeader then
    begin
      start := ABody.RawStart;
    end else
    begin
      start := ABody.EncodedStart;
    end;
    lines := ABody.EncodedLines;
    size := ABody.EncodedSize;
  end else
  begin
    start := 0;
    lines := AMessage.Count;
    size := GetStringsSize(AMessage);
  end;

  if AReturnHeader then
  begin
    size := 0;
    for i := 0 to lines - 1 do
    begin
      ind := i + start;
      if (ind >= AMessage.Count) then
      begin
        lines := i + 1;
        Break;
      end;

      len := Length(AMessage[ind]);
      size := size + len + 2;

      if (len = 0) then
      begin
        lines := i + 1;
        Break;
      end;
    end;
  end;

  BuildBodyPartTitle(ACommand, size, AResponse);

  for i := 0 to lines - 1 do
  begin
    ind := i + start;
    if (ind >= AMessage.Count) then
    begin
      Break;
    end;

    buf := TclTranslator.GetBytes(AMessage[ind]);
    if (Length(buf) > 0) then
    begin
      AResponse.Write(buf[0], Length(buf));
    end;

    buf := TclTranslator.GetBytes(#13#10);
    AResponse.Write(buf[0], Length(buf));
  end;
end;

class procedure TclImap4FetchBody.BuildBodyFields(AMessage: TStrings;
  ABody: TclMessageBody; const ACommand, AFetchFields: string;
  AResponse: TStream; isNot: Boolean);
var
  i, ind: Integer;
  fetchParams, reqFields,
  src: TStrings;
  fieldList: TclMailHeaderFieldList;
  result: string;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  result := '';

  fetchParams := nil;
  reqFields := nil;
  fieldList := nil;
  try
    fetchParams := TStringList.Create();
    reqFields := TStringList.Create();

    ExtractQuotedWords(AFetchFields, fetchParams, ' ', ['('], [')'], False);

    if ((fetchParams.Count = 2) and (Length(fetchParams[0]) <> 0) and (Length(fetchParams[1]) <> 0)) then
    begin
      ExtractQuotedWords(fetchParams[1], reqFields, ' ', ['"'], ['"'], False);

      fieldList := TclMailHeaderFieldList.Create(DefaultCharSet, cmNone, DefaultCharsPerLine);

      src := AMessage;
      if (ABody <> nil) then
      begin
        src := ABody.RawHeader;
      end;

      fieldList.Parse(0, src);

      if (isNot) then
      begin
        for i := 0 to fieldList.FieldList.Count - 1 do
        begin
          if (FindInStrings(reqFields, fieldList.FieldList[i]) < 0) then
          begin
            result := result + fieldList.GetFieldName(i) + ': '+ fieldList.GetFieldValue(i) + #13#10;
          end;
        end;
      end else
      begin
        for i := 0 to reqFields.Count - 1 do
        begin
          ind := FindInStrings(fieldList.FieldList, reqFields[i]);
          if (ind > -1) then
          begin
            result := result + fieldList.GetFieldName(ind) + ': '+ fieldList.GetFieldValue(ind) + #13#10;
          end;
        end;
      end;

      if (result <> '') then
      begin
        result := result + #13#10;
      end;
    end;
  finally
    fieldList.Free();
    reqFields.Free();
    fetchParams.Free();
  end;

  if (result = '') then
  begin
    result := ACommand + ' NIL';
    buf := TclTranslator.GetBytes(result);
    AResponse.Write(buf[0], Length(buf));
  end else
  begin
    buf := TclTranslator.GetBytes(result);
    BuildBodyPartTitle(ACommand, Length(buf), AResponse);
    AResponse.Write(buf[0], Length(buf));
  end;
end;

class procedure TclImap4FetchBody.BuildBodyPart(AMessage: TStrings;
  ABodies: TclMessageBodies; AParent: TclMessageBody; const ACommand: string;
  ABodyPart: TStrings; AResponse: TStream);
var
  part: Integer;
  body: TclMessageBody;
begin
  if (ABodyPart.Count = 0) then Exit;

  part := StrToIntDef(ABodyPart[0], -1);
  if (part > 0) then
  begin
    part := part - 1;
    if ((ABodies <> nil) and (part > -1) and (part < ABodies.Count)) then
    begin
      body := ABodies[part];

      if (ABodyPart.Count > 1) then
      begin
        ABodyPart.Delete(0);

        if (body is TclMultipartBody) then
        begin
          BuildBodyPart(AMessage, TclMultipartBody(body).Bodies, body, ACommand, ABodyPart, AResponse);
        end else
        begin
          BuildBodyPart(AMessage, nil, body, ACommand, ABodyPart, AResponse);
        end;
      end else
      begin
        BuildBodyContent(AMessage, body, ACommand, AResponse, False);
      end;
    end else
    begin
      BuildBodyContent(AMessage, AParent, ACommand, AResponse, False);
    end;
  end else
  begin
    if (ABodyPart[0] = 'HEADER') then
    begin
      if ((ABodyPart.Count > 1) and (Pos('FIELDS', ABodyPart[1]) > 0)) then
      begin
        if ((ABodyPart.Count > 2) and (Pos('NOT', ABodyPart[2]) > 0)) then
        begin
          BuildBodyFields(AMessage, AParent, ACommand, ABodyPart[2], AResponse, True);
        end else
        begin
          BuildBodyFields(AMessage, AParent, ACommand, ABodyPart[1], AResponse, False);
        end;
      end else
      begin
        BuildBodyContent(AMessage, AParent, ACommand, AResponse, True);
      end;
    end else
    if (ABodyPart[0] = 'MIME') then
    begin
      BuildBodyContent(AMessage, AParent, ACommand, AResponse, True);
    end else
    if (ABodyPart[0] = 'TEXT') then
    begin
      if (ABodies <> nil) then
      begin
        if (not BuildTextBody(AMessage, ABodies, ACommand, AResponse)) then
        begin
          BuildBodyContent(AMessage, AParent, ACommand, AResponse, False);
        end;
      end else
      begin
        BuildBodyContent(AMessage, AParent, ACommand, AResponse, False);
      end;
    end;
  end;
end;

class procedure TclImap4FetchBody.BuildBodyPartTitle(const ACommand: string;
  ADataSize: Integer; AResponse: TStream);
var
  buf: TclByteArray;
begin
  buf := TclTranslator.GetBytes(ACommand + ' {' + IntToStr(ADataSize) + '}'#13#10);
  AResponse.Write(buf[0], Length(buf));
end;

class function TclImap4FetchBody.BuildTextBody(AMessage: TStrings;
  ABodies: TclMessageBodies; const ACommand: string;
  AResponse: TStream): Boolean;
var
  i: Integer;
begin
  for i := 0 to ABodies.Count - 1 do
  begin
    if (ABodies[i] is TclMultipartBody) then
    begin
      if BuildTextBody(AMessage, TclMultipartBody(ABodies[i]).Bodies, ACommand, AResponse) then
      begin
        Result := True;
        Exit;
      end;
    end else
    if (ABodies[i] is TclTextBody) then
    begin
      BuildBodyContent(AMessage, ABodies[i], ACommand, AResponse, False);
      Result := True;
      Exit;
    end;
  end;

  Result := False;
end;

{ TclImap4FetchItem }

constructor TclImap4FetchItem.Create(const AName: string);
begin
  inherited Create();
  FName := AName;
  FPartial := '';
  FSection := '';
end;

{ TclImap4FetchList }

procedure TclImap4FetchList.Add(AItem: TclImap4FetchItem);
begin
  FList.Add(AItem);
end;

procedure TclImap4FetchList.Clear;
begin
  FList.Clear();
end;

constructor TclImap4FetchList.Create;
begin
  inherited Create();
  FList := TObjectList.Create(True);
end;

procedure TclImap4FetchList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TclImap4FetchList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function TclImap4FetchList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclImap4FetchList.GetItem(Index: Integer): TclImap4FetchItem;
begin
  Result := TclImap4FetchItem(FList[Index]);
end;

procedure TclImap4FetchList.Parse(const ASource: string);
begin
  Clear();
  ParseDataItems(ASource);
  ParseBodyStructure();
  ParseMacros();
end;

procedure TclImap4FetchList.ParseBodyStructure;
var
  i: Integer;
  item: TclImap4FetchItem;
begin
  for i := 0 to Count - 1 do
  begin
    item := Items[i];
    if (item.Name = 'BODY') then
    begin
      if (item.Section = '') then
      begin
        item.Name := 'BODYSTRUCTURE';
      end else
      begin
        item.Section := ExtractQuotedString(item.Section, '[', ']');
      end;
    end else
    if (item.Name = 'BODY.PEEK') then
    begin
      item.Section := ExtractQuotedString(item.Section, '[', ']');
    end;
  end;
end;

procedure TclImap4FetchList.ParseDataItems(const ASource: string);
var
  len, next: Integer;
  inParams, inPartial: Boolean;
  item: TclImap4FetchItem;
  curText: string;
begin
  if (ASource = '') then Exit;

  len := Length(ASource);
  if (len = 0) then Exit;

  next := 1;
  inParams := False;
  inPartial := False;
  item := nil;
  curText := '';

  while (len > 0) do
  begin
    case ASource[next] of
      '<':
        begin
          if (inParams) then
          begin
            curText := curText + ASource[next];
          end;
          inParams := True;
          inPartial := True;
        end;
      '>':
        begin
          if (inPartial) then
          begin
            if (item <> nil) then
            begin
              item.Partial := curText;
            end;
            curText := '';
            inParams := False;
          end else
          if (inParams) then
          begin
            curText := curText + ASource[next];
          end;
          inPartial := False;
        end;
      ' ':
        begin
          if (inParams) then
          begin
            curText := curText + ASource[next];
          end else
          begin
            item := nil;
            if (curText <> '') then
            begin
              item := TclImap4FetchItem.Create(UpperCase(curText));
              Add(item);
            end;
            curText := '';
          end;
        end;
      '[':
        begin
          inParams := True;
          item := nil;
          if (curText <> '') then
          begin
            item := TclImap4FetchItem.Create(UpperCase(curText));
            Add(item);
          end;
          curText := ASource[next];
        end;
      ']':
        begin
          curText := curText + ASource[next];
          if (inParams and (item <> nil) and (curText <> '')) then
          begin
            item.Section := curText;
          end;
          curText := '';
          inParams := False;
        end
      else
        begin
          curText := curText + ASource[next];
        end;
    end;

    Inc(next);
    Dec(len);
  end;

  if (not inParams and (curText <> '')) then
  begin
    item := TclImap4FetchItem.Create(UpperCase(curText));
    Add(item);
  end;
end;

procedure TclImap4FetchList.ParseMacros;
var
  i: Integer;
  item: TclImap4FetchItem;
begin
  for i := Count - 1 downto 0 do
  begin
    item := Items[i];
    if (item.Name = 'ALL') then
    begin
      Delete(i);
      Add(TclImap4FetchItem.Create('FLAGS'));
      Add(TclImap4FetchItem.Create('INTERNALDATE'));
      Add(TclImap4FetchItem.Create('RFC822.SIZE'));
      Add(TclImap4FetchItem.Create('ENVELOPE'));
    end else
    if (item.Name = 'FAST') then
    begin
      Delete(i);
      Add(TclImap4FetchItem.Create('FLAGS'));
      Add(TclImap4FetchItem.Create('INTERNALDATE'));
      Add(TclImap4FetchItem.Create('RFC822.SIZE'));
    end else
    if (item.Name = 'FULL') then
    begin
      Delete(i);
      Add(TclImap4FetchItem.Create('FLAGS'));
      Add(TclImap4FetchItem.Create('INTERNALDATE'));
      Add(TclImap4FetchItem.Create('RFC822.SIZE'));
      Add(TclImap4FetchItem.Create('ENVELOPE'));
      Add(TclImap4FetchItem.Create('BODY'));
    end;
  end;
end;

end.
