
{******************************************}
{                                          }
{             FastScript v1.9              }
{                  Parser                  }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iparser;

interface

{$i fs.inc}

uses
{$IFNDEF CROSS_COMPILE}
  Windows,
{$ENDIF}
  SysUtils, Classes;


type
  TfsIdentifierCharset = set of AnsiChar;

  { TfsParser parser the source text and return such elements as identifiers,
    keywords, punctuation, strings and numbers. }

  TfsParser = class(TObject)
  private
    FCaseSensitive: Boolean;
    FCommentBlock1: String;
    FCommentBlock11: String;
    FCommentBlock12: String;
    FCommentBlock2: String;
    FCommentBlock21: String;
    FCommentBlock22: String;
    FCommentLine1: String;
    FCommentLine2: String;
    FHexSequence: String;
    FIdentifierCharset: TfsIdentifierCharset;
    FKeywords: TStrings;
    FLastPosition: Integer;
    FPosition: Integer;
    FSize: Integer;
    FSkiPChar: String;
    FSkipEOL: Boolean;
    FSkipSpace: Boolean;
    FStringQuotes: String;
    FText: String;
    FUseY: Boolean;
    FYList: TList;
    FSpecStrChar: Boolean;
    function DoDigitSequence: Boolean;
    function DoHexDigitSequence: Boolean;
    function DoScaleFactor: Boolean;
    function DoUnsignedInteger: Boolean;
    function DoUnsignedReal: Boolean;
    procedure SetPosition(const Value: Integer);
    procedure SetText(const Value: String);
    function Ident: String;
    procedure SetCommentBlock1(const Value: String);
    procedure SetCommentBlock2(const Value: String);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure ConstructCharset(const s: String);

    { skip all #0..#31 symbols }
    procedure SkipSpaces;
    { get EOL symbol }
    function GetEOL: Boolean;
    { get any valid ident except keyword }
    function GetIdent: String;
    { get any valid punctuation symbol like ,.;: }
    function GetChar: String;
    { get any valid ident or keyword }
    function GetWord: String;
    { get valid hex/int/float number }
    function GetNumber: String;
    { get valid quoted/control string like 'It''s'#13#10'working' }
    function GetString: String;
    { get FR-specific string - variable or db field like [main data."field 1"] }
    function GetFRString: String;
    { get Y:X position }
    function GetXYPosition: String;
    { get plain position from X:Y }
    function GetPlainPosition(pt: TPoint): Integer;
    { is this keyword? }
    function IsKeyWord(const s: String): Boolean;

    // Language-dependent elements
    // For Pascal:
    // CommentLine1 := '//';
    // CommentBlock1 := '{,}';
    // CommentBlock2 := '(*,*)';
    // HexSequence := '$'
    // IdentifierCharset := ['_', '0'..'9', 'a'..'z', 'A'..'Z'];
    // Keywords: 'begin','end', ...
    // StringQuotes := ''''
    property CaseSensitive: Boolean read FCaseSensitive write FCaseSensitive;
    property CommentBlock1: String read FCommentBlock1 write SetCommentBlock1;
    property CommentBlock2: String read FCommentBlock2 write SetCommentBlock2;
    property CommentLine1: String read FCommentLine1 write FCommentLine1;
    property CommentLine2: String read FCommentLine2 write FCommentLine2;
    property HexSequence: String read FHexSequence write FHexSequence;
    property IdentifierCharset: TfsIdentifierCharset read FIdentifierCharset
      write FIdentifierCharset;
    property Keywords: TStrings read FKeywords;
    property SkiPChar: String read FSkiPChar write FSkiPChar;
    property SkipEOL: Boolean read FSkipEOL write FSkipEOL;
    property SkipSpace: Boolean read FSkipSpace write FSkipSpace;
    property StringQuotes: String read FStringQuotes write FStringQuotes;
    property SpecStrChar: Boolean read FSpecStrChar write FSpecStrChar;
    property UseY: Boolean read FUseY write FUseY;

    { Current position }
    property Position: Integer read FPosition write SetPosition;
    { Text to parse }
    property Text: String read FText write SetText;
  end;


implementation


{ TfsParser }

constructor TfsParser.Create;
begin
  FKeywords := TStringList.Create;
  TStringList(FKeywords).Sorted := True;
  FYList := TList.Create;
  FUseY := True;
  Clear;
end;

destructor TfsParser.Destroy;
begin
  FKeywords.Free;
  FYList.Free;
  inherited;
end;

procedure TfsParser.Clear;
begin
  FKeywords.Clear;
  FSpecStrChar := False;
  FCommentLine1 := '//';
  CommentBlock1 := '{,}';
  CommentBlock2 := '(*,*)';
  FHexSequence := '$';
  FIdentifierCharset := ['_', '0'..'9', 'a'..'z', 'A'..'Z'];
  FSkipChar := '';
  FSkipEOL := True;
  FStringQuotes := '''';
  FSkipSpace := True;
end;

procedure TfsParser.SetCommentBlock1(const Value: String);
var
  sl: TStringList;
begin
  FCommentBlock1 := Value;
  FCommentBlock11 := '';
  FCommentBlock12 := '';

  sl := TStringList.Create;
  sl.CommaText := FCommentBlock1;
  if sl.Count > 0 then
    FCommentBlock11 := sl[0];
  if sl.Count > 1 then
    FCommentBlock12 := sl[1];
  sl.Free;
end;

procedure TfsParser.SetCommentBlock2(const Value: String);
var
  sl: TStringList;
begin
  FCommentBlock2 := Value;
  FCommentBlock21 := '';
  FCommentBlock22 := '';

  sl := TStringList.Create;
  sl.CommaText := FCommentBlock2;
  if sl.Count > 0 then
    FCommentBlock21 := sl[0];
  if sl.Count > 1 then
    FCommentBlock22 := sl[1];
  sl.Free;
end;

procedure TfsParser.SetPosition(const Value: Integer);
begin
  FPosition := Value;
  FLastPosition := Value;
end;

procedure TfsParser.SetText(const Value: String);
var
  i: Integer;
begin
  FText := Value + #0;
  FLastPosition := 1;
  FPosition := 1;
  FSize := Length(Value);

  if FUseY then
  begin
    FYList.Clear;
    FYList.Add(TObject(0));
    for i := 1 to FSize do
      if FText[i] = #10 then
        FYList.Add(TObject(i));
  end;
end;

procedure TfsParser.ConstructCharset(const s: String);
var
  i: Integer;
begin
  FIdentifierCharset := [];
  for i := 1 to Length(s) do
    FIdentifierCharset := FIdentifierCharset + [s[i]];
end;

function TfsParser.GetEOL: Boolean;
begin
  SkipSpaces;
{$IFDEF Delphi12}
  if CharInSet(FText[FPosition], [#10, #13]) then
{$ELSE}
  if FText[FPosition] in [#10, #13] then
{$ENDIF}
  begin
    Result := True;
{$IFDEF Delphi12}
    while CharInSet(FText[FPosition], [#10, #13]) do
{$ELSE}
    while FText[FPosition] in [#10, #13] do
{$ENDIF}
      Inc(FPosition);
  end
  else
    Result := False;
end;

procedure TfsParser.SkipSpaces;
var
  s1, s2: String;
  Flag, CLine: Boolean;
  Spaces: set of AnsiChar;
begin
  Spaces := [#0..#32];
  if not FSkipEOL then
{$IFDEF Windows}
    Spaces := Spaces - [#13];
{$ELSE}
    Spaces := Spaces - [#10];
{$ENDIF}
{$IFDEF Delphi12}
  while (FPosition <= FSize) and (CharInSet(FText[FPosition], Spaces)) do
{$ELSE}
  while (FPosition <= FSize) and (FText[FPosition] in Spaces) do
{$ENDIF}
    Inc(FPosition);
  { skip basic '_' }
  if (FPosition <= FSize) and (FSkipChar <> '') and (FText[FPosition] = FSkipChar[1]) then
  begin
    Inc(FPosition);
    GetEOL;
    SkipSpaces;
  end;

  if FPosition < FSize then
  begin
    if FCommentLine1 <> '' then
      s1 := Copy(FText, FPosition, Length(FCommentLine1)) else
      s1 := ' ';
    if FCommentLine2 <> '' then
      s2 := Copy(FText, FPosition, Length(FCommentLine2)) else
      s2 := ' ';

    if (s1 = FCommentLine1) or (s2 = FCommentLine2) then
    begin
      CLine := (FPosition - 1 > 0) and (FText[FPosition - 1] <> #10) and not FSkipEOL;
      while (FPosition <= FSize) and (FText[FPosition] <> #10) do
      begin
        if (FText[FPosition] = {$IFDEF LINUX}#10{$ELSE}#13{$ENDIF}) and CLine then break;
        Inc(FPosition);
      end;
      SkipSpaces;
    end
    else
    begin
      Flag := False;

      if FCommentBlock1 <> '' then
      begin
        s1 := Copy(FText, FPosition, Length(FCommentBlock11));
        if s1 = FCommentBlock11 then
        begin
          Flag := True;
          s2 := FCommentBlock12;
        end;
      end;

      if not Flag and (FCommentBlock2 <> '') then
      begin
        s1 := Copy(FText, FPosition, Length(FCommentBlock21));
        if s1 = FCommentBlock21 then
        begin
          Flag := True;
          s2 := FCommentBlock22;
        end;
      end;

      if Flag then
      begin
        Inc(FPosition, Length(s2));
        while (FPosition <= FSize) and (Copy(FText, FPosition, Length(s2)) <> s2) do
          Inc(FPosition);
        Inc(FPosition, Length(s2));
        SkipSpaces;
      end;
    end;
  end;

  FLastPosition := FPosition;
end;

function TfsParser.Ident: String;
begin
  if FSkipSpace then
    SkipSpaces;
{$IFDEF Delphi12}
  if (CharInSet(FText[FPosition], FIdentifierCharset - ['0'..'9']))
    or ((FText[FPosition] >= Char($007F)) and (FText[FPosition] <= Char($FFFF))) then
  begin
    while CharInSet(FText[FPosition], FIdentifierCharset)
      or ((FText[FPosition] >= Char($007F)) and (FText[FPosition] <= Char($FFFF)))  do
{$ELSE}
  if (FText[FPosition] in FIdentifierCharset) and not (FText[FPosition] in ['0'..'9']) then
  begin
    while (FText[FPosition] in FIdentifierCharset) do
{$ENDIF}
      Inc(FPosition);
    Result := Copy(FText, FLastPosition, FPosition - FLastPosition);
  end
  else
    Result := '';
end;

function TfsParser.IsKeyWord(const s: String): Boolean;
var
  i: Integer;
begin
  if FCaseSensitive then
  begin
    Result := False;
    for i := 0 to FKeywords.Count - 1 do
    begin
      Result := FKeywords[i] = s;
      if Result then break;
    end;
  end
  else
    Result := FKeywords.IndexOf(s) <> -1;
end;

function TfsParser.GetIdent: String;
begin
  Result := Ident;
  if IsKeyWord(Result) then
    Result := '';
end;

function TfsParser.GetWord: String;
begin
  Result := Ident;
end;

function TfsParser.GetChar: String;
begin
{$IFDEF Delphi12}
  if CharInSet(FText[FPosition], ['!', '@', '#', '$', '%', '^', '&', '|', '\',
    '.', ',', ':', ';', '?', '''', '"', '~', '`', '_', '[', ']', '{', '}',
    '(', ')', '+', '-', '*', '/', '=', '<', '>']) then
{$ELSE}
  if FText[FPosition] in ['!', '@', '#', '$', '%', '^', '&', '|', '\',
    '.', ',', ':', ';', '?', '''', '"', '~', '`', '_', '[', ']', '{', '}',
    '(', ')', '+', '-', '*', '/', '=', '<', '>'] then
{$ENDIF}
  begin
    Result := FText[FPosition];
    Inc(FPosition);
  end
  else
    Result := '';
end;

function TfsParser.GetString: String;
var
  Flag: Boolean;
  Str: String;
  FError: Boolean;
  FCpp: Boolean;

  function DoQuotedString: Boolean;
  var
    i, j: Integer;
  begin
    Result := False;
    i := FPosition;

    if FText[FPosition] = FStringQuotes[1] then
    begin
      repeat
        Inc(FPosition);

        if FCpp and (FText[FPosition] = '\') then
        begin
          {$IFNDEF FPC}
          {$IFDEF Delphi12}
            case Lowercase(Char(FText[FPosition + 1]))[1] of
          {$ELSE}
            case Lowercase(FText[FPosition + 1])[1] of
          {$ENDIF}
          {$ELSE}
          case Lowercase(FText[FPosition + 1]) of
          {$ENDIF}
            'n':
              begin
                Str := Str + #10;
                Inc(FPosition);
              end;
            'r':
              begin
                Str := Str + #13;
                Inc(FPosition);
              end;
            'x':
              begin
                Inc(FPosition, 2);
                j := FPosition;
                Result := DoHexDigitSequence;
                if Result then
                  Str := Str + Chr(StrToInt('$' + Copy(FText, j, FPosition - j))) else
                  FPosition := j;
                Dec(FPosition);
              end
            else
              begin
                Str := Str + FText[FPosition + 1];
                Inc(FPosition);
              end;
          end;
        end
        else if FText[FPosition] = FStringQuotes[1] then
        begin
          if not FCpp and (FText[FPosition + 1] = FStringQuotes[1]) then
          begin
            Str := Str + FStringQuotes[1];
            Inc(FPosition);
          end
          else
            break
        end
        else
          Str := Str + FText[FPosition];
{$IFDEF Delphi12}
      until CharInSet(FText[FPosition], [#0..#31] - [#9]);
{$ELSE}
      until FText[FPosition] in [#0..#31] - [#9];
{$ENDIF}
      if FText[FPosition] = FStringQuotes[1] then
      begin
        Inc(FPosition);
        Result := True;
      end
      else
        FPosition := i;
    end;
  end;

  function DoControlString: Boolean;
  var
    i: Integer;
  begin
    Result := False;
    i := FPosition;

    if FText[FPosition] = '#' then
    begin
      Inc(FPosition);
      Result := DoUnsignedInteger;
      if Result then
        Str := Chr(StrToInt(Copy(FText, i + 1, FPosition - i - 1))) else
        FPosition := i;
    end;
  end;

begin
  Result := '';
  if FSkipSpace then
    SkipSpaces;
  Flag := True;
  FError := False;
  FCpp := {FStringQuotes = '"'} FSpecStrChar;

  repeat
    Str := '';
    if DoQuotedString or DoControlString then
      Result := Result + Str
    else
    begin
      FError := Flag;
      break;
    end;

    Flag := False;
  until False;

  if not FError then
    Result := '''' + Result + '''';
end;

function TfsParser.DoDigitSequence: Boolean;
begin
  Result := False;

{$IFDEF Delphi12}
  if CharInSet(FText[FPosition], ['0'..'9']) then
  begin
    while CharInSet(FText[FPosition], ['0'..'9']) do
{$ELSE}
  if FText[FPosition] in ['0'..'9'] then
  begin
    while FText[FPosition] in ['0'..'9'] do
{$ENDIF}
      Inc(FPosition);
    Result := True;
  end;
end;

function TfsParser.DoHexDigitSequence: Boolean;
begin
  Result := False;

{$IFDEF Delphi12}
  if CharInSet(FText[FPosition], ['0'..'9', 'a'..'f', 'A'..'F']) then
  begin
    while CharInSet(FText[FPosition], ['0'..'9', 'a'..'f', 'A'..'F']) do
{$ELSE}
  if FText[FPosition] in ['0'..'9', 'a'..'f', 'A'..'F'] then
  begin
    while FText[FPosition] in ['0'..'9', 'a'..'f', 'A'..'F'] do
{$ENDIF}
      Inc(FPosition);
    Result := True;
  end;
end;

function TfsParser.DoUnsignedInteger: Boolean;
var
  Pos1: Integer;
  s: String;
begin
  Pos1 := FPosition;

  s := Copy(FText, FPosition, Length(FHexSequence));
  if s = FHexSequence then
  begin
    Inc(FPosition, Length(s));
    Result := DoHexDigitSequence;
  end
  else
    Result := DoDigitSequence;

  if not Result then
    FPosition := Pos1;
end;

function TfsParser.DoUnsignedReal: Boolean;
var
  Pos1, Pos2: Integer;
begin
  Pos1 := FPosition;
  Result := DoUnsignedInteger;

  if Result then
  begin
    if FText[FPosition] = '.' then
    begin
      Inc(FPosition);
      Result := DoDigitSequence;
    end;

    if Result then
    begin
      Pos2 := FPosition;
      if not DoScaleFactor then
        FPosition := Pos2;
    end;
  end;

  if not Result then
    FPosition := Pos1;
end;

function TfsParser.DoScaleFactor: Boolean;
begin
  Result := False;
{$IFDEF Delphi12}
  if CharInSet(FText[FPosition], ['e', 'E']) then
{$ELSE}
  if FText[FPosition] in ['e', 'E'] then
{$ENDIF}
  begin
    Inc(FPosition);
{$IFDEF Delphi12}
    if CharInSet(FText[FPosition], ['+', '-']) then
{$ELSE}
    if FText[FPosition] in ['+', '-'] then
{$ENDIF}
      Inc(FPosition);
    Result := DoDigitSequence;
  end;
end;

function TfsParser.GetNumber: String;
var
  Pos1: Integer;
begin
  Result := '';
  if FSkipSpace then
    SkipSpaces;
  Pos1 := FPosition;

  if DoUnsignedReal or DoUnsignedInteger then
    Result := Copy(FText, FLastPosition, FPosition - FLastPosition) else
    FPosition := Pos1;

  if FHexSequence <> '$' then
    while Pos(FHexSequence, Result) <> 0 do
    begin
      Pos1 := Pos(FHexSequence, Result);
      Delete(Result, Pos1, Length(FHexSequence));
      Insert('$', Result, Pos1);
    end;
end;

function TfsParser.GetFRString: String;
var
  i, c: Integer;
  fl1, fl2: Boolean;
begin
  Result := '';
  i := FPosition;
  fl1 := True;
  fl2 := True;
  c := 1;

  Dec(FPosition);
  repeat
    Inc(FPosition);
{    if FText[FPosition] in [#10, #13] then
    begin
      FPosition := i;
      break;
    end;}
    if fl1 and fl2 then
{$IFDEF Delphi12}
      if CharInSet(FText[FPosition], ['<', '[']) then
{$ELSE}
      if FText[FPosition] in ['<', '['] then
{$ENDIF}
        Inc(c)
{$IFDEF Delphi12}
      else if CharInSet(FText[FPosition], ['>', ']']) then
{$ELSE}
      else if FText[FPosition] in ['>', ']'] then
{$ENDIF}
        Dec(c);
    if fl1 then
      if FText[FPosition] = '"' then
        fl2 := not fl2;
    if fl2 then
      if FText[FPosition] = '''' then
        fl1 := not fl1;
  until (c = 0) or (FPosition >= Length(FText));

  Result := Copy(FText, i, FPosition - i);
end;

function TfsParser.GetXYPosition: String;
var
  i, i0, i1, c, pos, X, Y: Integer;
begin
  i0 := 0;
  i1 := FYList.Count - 1;

  while i0 <= i1 do
  begin
    i := (i0 + i1) div 2;
    pos := Integer(FYList[i]);

    if pos = FPosition then
      c := 0
    else if pos > FPosition then
      c := 1
    else
      c := -1;

    if c < 0 then
      i0 := i + 1
    else
    begin
      i1 := i - 1;
      if c = 0 then
        i0 := i;
    end;
  end;

  X := 1;
  Y := i0;
  i := Integer(FYList[i0 - 1]) + 1;

  while i < FPosition do
  begin
    Inc(i);
    Inc(X);
  end;
  Result := IntToStr(Y) + ':' + IntToStr(X)
end;

function TfsParser.GetPlainPosition(pt: TPoint): Integer;
var
  i: Integer;
begin
  Result := -1;
  i := pt.Y - 1;
  if (i >= 0) and (i < FYList.Count) then
    Result := Integer(FYList[i]) + pt.X;
end;

end.
