{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clJson;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Contnrs;
{$ELSE}
  System.Classes, System.SysUtils, System.Contnrs;
{$ENDIF}

type
  EclJSONError = class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean = False);
    property ErrorCode: Integer read FErrorCode;
  end;

  TclJSONString = class;
  TclJSONPair = class;
  TclJSONObject = class;
  TclJSONArray = class;

  TclJSONBase = class
  private
    class function DecodeString(const ASource: string): WideString;
    class function EncodeString(const ASource: WideString): string;

    class procedure SkipWhiteSpace(var Next: PChar);
    class function ParseValue(var Next: PChar): TclJSONBase;
    class function ParseName(var Next: PChar): string;
    class function ParsePair(var Next: PChar): TclJSONPair;
    class function ParseObj(var Next: PChar): TclJSONObject;
    class function ParseArray(var Next: PChar): TclJSONArray;
    class function ParseRoot(var Next: PChar): TclJSONBase;

    function GetValueString: string;
    procedure SetValueString(const AValue: string);
  protected
    function GetValueWideString: WideString; virtual; abstract;
    procedure SetValueWideString(const Value: WideString); virtual; abstract;
{$IFDEF DELPHI2009}
    procedure BuildJSONString(ABuffer: TStringBuilder); virtual; abstract;
{$ELSE}
    function BuildJSONString: string; virtual; abstract;
{$ENDIF}
  public
    class function Parse(const AJSONString: string): TclJSONBase;
    class function ParseObject(const AJSONString: string): TclJSONObject;

    function GetJSONString: string;

    property ValueString: string read GetValueString write SetValueString;
    property ValueWideString: WideString read GetValueWideString write SetValueWideString;
  end;

  TclJSONPair = class(TclJSONBase)
  private
    FName: WideString;
    FValue: TclJSONBase;

    procedure SetValue(const AValue: TclJSONBase);
    function GetName: string;
    procedure SetName(const AValue: string);
  protected
    function GetValueWideString: WideString; override;
    procedure SetValueWideString(const AValue: WideString); override;
{$IFDEF DELPHI2009}
    procedure BuildJSONString(ABuffer: TStringBuilder); override;
{$ELSE}
    function BuildJSONString: string; override;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;

    property Name: string read GetName write SetName;
    property NameWideString: WideString read FName write FName;
    property Value: TclJSONBase read FValue write SetValue;
  end;

  TclJSONValue = class(TclJSONBase)
  private
    FValue: WideString;
  protected
    function GetValueWideString: WideString; override;
    procedure SetValueWideString(const AValue: WideString); override;
{$IFDEF DELPHI2009}
    procedure BuildJSONString(ABuffer: TStringBuilder); override;
{$ELSE}
    function BuildJSONString: string; override;
{$ENDIF}
  public
    constructor Create; overload;
    constructor Create(const AValue: string); overload;
    constructor Create(const AValue: WideString); overload;
  end;

  TclJSONString = class(TclJSONValue)
  protected
{$IFDEF DELPHI2009}
    procedure BuildJSONString(ABuffer: TStringBuilder); override;
{$ELSE}
    function BuildJSONString: string; override;
{$ENDIF}
  end;

  TclJSONBoolean = class(TclJSONValue)
  private
    function GetValue: Boolean;
    procedure SetValue(const Value: Boolean);
  protected
    procedure SetValueWideString(const AValue: WideString); override;
  public
    constructor Create; overload;
    constructor Create(AValue: Boolean); overload;

    property Value: Boolean read GetValue write SetValue;
  end;

  TclJSONArray = class(TclJSONBase)
  private
    FItems: TObjectList;

    function GetCount: Integer;
    function GetItem(Index: Integer): TclJSONBase;
    function GetObject(Index: Integer): TclJSONObject;
  protected
    function GetValueWideString: WideString; override;
    procedure SetValueWideString(const AValue: WideString); override;
{$IFDEF DELPHI2009}
    procedure BuildJSONString(ABuffer: TStringBuilder); override;
{$ELSE}
    function BuildJSONString: string; override;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;

    function Add(AItem: TclJSONBase): TclJSONBase;

    property Count: Integer read GetCount;
    property Items[Index: Integer]: TclJSONBase read GetItem;
    property Objects[Index: Integer]: TclJSONObject read GetObject;
  end;

  TclJSONObject = class(TclJSONBase)
  private
    FMembers: TObjectList;

    function GetCount: Integer;
    function GetMember(Index: Integer): TclJSONPair;
  protected
    function GetValueWideString: WideString; override;
    procedure SetValueWideString(const AValue: WideString); override;
{$IFDEF DELPHI2009}
    procedure BuildJSONString(ABuffer: TStringBuilder); override;
{$ELSE}
    function BuildJSONString: string; override;
{$ENDIF}
  public
    constructor Create;
    destructor Destroy; override;

    function MemberByName(const AName: string): TclJSONPair; overload;
    function MemberByName(const AName: WideString): TclJSONPair; overload;

    function ValueByName(const AName: string): string; overload;
    function ValueByName(const AName: WideString): WideString; overload;

    function ObjectByName(const AName: string): TclJSONObject; overload;
    function ObjectByName(const AName: WideString): TclJSONObject; overload;

    function ArrayByName(const AName: string): TclJSONArray; overload;
    function ArrayByName(const AName: WideString): TclJSONArray; overload;

    function BooleanByName(const AName: string): Boolean; overload;
    function BooleanByName(const AName: WideString): Boolean; overload;

    function AddMember(APair: TclJSONPair): TclJSONPair; overload;
    function AddMember(const AName: WideString; AValue: TclJSONBase): TclJSONPair; overload;
    function AddMember(const AName: string; AValue: TclJSONBase): TclJSONPair; overload;

    function AddString(const AName, AValue: string): TclJSONString; overload;
    function AddString(const AName, AValue: WideString): TclJSONString; overload;

    function AddValue(const AName, AValue: string): TclJSONValue; overload;
    function AddValue(const AName, AValue: WideString): TclJSONValue; overload;

    function AddBoolean(const AName: string; AValue: Boolean): TclJSONBoolean; overload;
    function AddBoolean(const AName: WideString; AValue: Boolean): TclJSONBoolean; overload;

    property Count: Integer read GetCount;
    property Members[Index: Integer]: TclJSONPair read GetMember;
  end;

resourcestring
  UnexpectedDataEnd = 'Unexpected end of JSON data';
  UnexpectedDataSymbol = 'Unexpected symbol in JSON data';
  InvalidControlSymbol = 'Invalid control symbol in JSON data';
  InvalidUnicodeEscSequence = 'Invalid unicode escape sequence in JSON data';
  UnrecognizedEscSequence = 'Unrecognized escape sequence in JSON data';
  UnexpectedDataType = 'Unexpected data type';

const
  UnexpectedDataEndCode = -100;
  UnexpectedDataSymbolCode = -101;
  InvalidControlSymbolCode = -102;
  InvalidUnicodeEscSequenceCode = -103;
  UnrecognizedEscSequenceCode = -104;
  UnexpectedDataTypeCode = -106;

var
   EscapeJsonStrings: Boolean = False;

implementation

uses
  clWUtils;
  
const
  JsonBoolean: array[Boolean] of string = ('false', 'true');

{ TclJSONBase }

procedure TclJSONBase.SetValueString(const AValue: string);
begin
  ValueWideString := WideString(AValue);
end;

class procedure TclJSONBase.SkipWhiteSpace(var Next: PChar);
begin
  while (Next^ <> #0) do
  begin
    case (Next^) of
      #32, #9, #13, #10:
    else
      Break;
    end;
    Inc(Next);
  end;
end;

class function TclJSONBase.ParseArray(var Next: PChar): TclJSONArray;
begin
  Result := TclJSONArray.Create();
  try
    while (Next^ <> #0) do
    begin
      SkipWhiteSpace(Next);
      if (Next^ = #0) then
      begin
        raise EclJSONError.Create(UnexpectedDataEnd, UnexpectedDataEndCode);
      end;

      case (Next^) of
        ']':
          begin
            Inc(Next);
            Break;
          end;
        ',':
          begin
            Inc(Next);
            Result.Add(ParseRoot(Next));
            Continue;
          end
        else
          begin
            Result.Add(ParseRoot(Next));
            Continue;
          end;
      end;

      Inc(Next);
    end;
  except
    Result.Free();
    raise;
  end;
end;

class function TclJSONBase.ParseName(var Next: PChar): string;
var
  inQuote: Boolean;
  lastTwo: array[0..1] of Char;
begin
  Result := '';
  inQuote := False;
  lastTwo[0] := #0;
  lastTwo[1] := #0;
  while (Next^ <> #0) do
  begin
    SkipWhiteSpace(Next);

    case (Next^) of
      #0: Break;
      '"':
        begin
          if (lastTwo[0] <> '\') and (lastTwo[1] = '\') then
          begin
            Result := Result + Next^;
          end else
          begin
            if inQuote then
            begin
              Inc(Next);
              Break;
            end;
            inQuote := not inQuote;
          end;
        end
      else
        Result := Result + Next^;
    end;

    lastTwo[0] := lastTwo[1];
    lastTwo[1] := Next^;
    Inc(Next);
  end;
end;

class function TclJSONBase.ParseObject(const AJSONString: string): TclJSONObject;
var
  root: TclJSONBase;
begin
  root := TclJSONBase.Parse(AJSONString);
  try
    if (root is TclJSONObject) then
    begin
      Result := TclJSONObject(root);
    end else
    begin
      raise EclJSONError.Create(UnexpectedDataType, UnexpectedDataTypeCode);
    end;
  except
    root.Free();
    raise;
  end;
end;

class function TclJSONBase.ParsePair(var Next: PChar): TclJSONPair;
begin
  Result := TclJSONPair.Create();
  try
    while (Next^ <> #0) do
    begin
      SkipWhiteSpace(Next);
      if (Next^ = #0) then
      begin
        raise EclJSONError.Create(UnexpectedDataEnd, UnexpectedDataEndCode);
      end;

      if (Next^ = ':') and (Result.NameWideString = '') then
      begin
        raise EclJSONError.Create(UnexpectedDataSymbol, UnexpectedDataSymbolCode);
      end;

      if (Result.NameWideString = '') then
      begin
        Result.NameWideString := DecodeString(ParseName(Next));
        Continue;
      end else
      if (Next^ = ':') then
      begin
        Inc(Next);
        Result.Value := ParseRoot(Next);
        Break;
      end else
      begin
        raise EclJSONError.Create(UnexpectedDataSymbol, UnexpectedDataSymbolCode);
      end;

      Inc(Next);
    end;
  except
    Result.Free();
    raise;
  end;
end;

class function TclJSONBase.ParseObj(var Next: PChar): TclJSONObject;
begin
  Result := TclJSONObject.Create();
  try
    while (Next^ <> #0) do
    begin
      SkipWhiteSpace(Next);
      if (Next^ = #0) then
      begin
        raise EclJSONError.Create(UnexpectedDataEnd, UnexpectedDataEndCode);
      end;

      case (Next^) of
        '}':
          begin
            Inc(Next);
            Break;
          end;
        ',':
          begin
            Inc(Next);
            Result.AddMember(ParsePair(Next));
            Continue;
          end
        else
          begin
            Result.AddMember(ParsePair(Next));
            Continue;
          end;
      end;

      Inc(Next);
    end;
  except
    Result.Free();
    raise;
  end;
end;

class function TclJSONBase.ParseValue(var Next: PChar): TclJSONBase;
var
  inQuote, isString: Boolean;
  value: string;
  lastTwo: array[0..1] of Char;
begin
  value := '';
  inQuote := False;
  isString := False;
  lastTwo[0] := #0;
  lastTwo[1] := #0;
  while (Next^ <> #0) do
  begin
    if (not inQuote) then
    begin
      SkipWhiteSpace(Next);
    end;

    case (Next^) of
      #0: Break;
      '}', ']', ',':
        begin
          if inQuote then
          begin
            value := value + Next^;
          end else
          begin
            Break;
          end;
        end;
      '"':
        begin
          if inQuote and (lastTwo[0] <> '\') and (lastTwo[1] = '\') then
          begin
            value := value + Next^;
          end else
          begin
            if inQuote then
            begin
              Inc(Next);
              Break;
            end;
            inQuote := not inQuote;
            isString := True;
          end;
        end
      else
        value := value + Next^;
    end;

    lastTwo[0] := lastTwo[1];
    lastTwo[1] := Next^;
    Inc(Next);
  end;

  Result := nil;
  try
    if isString then
    begin
      Result := TclJSONString.Create();
      Result.ValueWideString := DecodeString(value);
    end else
    begin
      if (JsonBoolean[True] = value) then
      begin
        Result := TclJSONBoolean.Create(True);
      end else
      if (JsonBoolean[False] = value) then
      begin
        Result := TclJSONBoolean.Create(False);
      end else
      begin
        Result := TclJSONValue.Create();
        Result.ValueWideString := value;
      end;
    end;
  except
    Result.Free();
    raise;
  end;
end;

class function TclJSONBase.ParseRoot(var Next: PChar): TclJSONBase;
begin
  Result := nil;

  while (Next^ <> #0) do
  begin
    SkipWhiteSpace(Next);
    if (Next^ = #0) then Break;

    case (Next^) of
      '{':
        begin
          Inc(Next);
          Result := ParseObj(Next);
          Break;
        end;
      '[':
        begin
          Inc(Next);
          Result := ParseArray(Next);
          Break;
        end
      else
        begin
          Result := ParseValue(Next);
          Break;
        end;
    end;

    Inc(Next);
  end;
end;

class function TclJSONBase.EncodeString(const ASource: WideString): string;
var
  i: Integer;
begin
  Result := '"';

  for i := 1 to Length(ASource) do
  begin
    case ASource[i] of
      '/', '\', '"':
        begin
          Result := Result + '\' + Char(ASource[i]);
        end;
      #8:
        begin
          Result := Result + '\b';
        end;
      #9:
        begin
          Result := Result + '\t';
        end;
      #10:
        begin
          Result := Result + '\n';
        end;
      #12:
        begin
          Result := Result + '\f';
        end;
      #13:
        begin
          Result := Result + '\r';
        end
      else
        begin
          if (not EscapeJsonStrings) or (ASource[i] >= WideChar(' ')) and (ASource[i] <= WideChar('~')) then
          begin
            Result := Result + Char(ASource[i]);
          end else
          begin
            Result := Result + '\u' + IntToHex(Ord(ASource[i]), 4);
          end;
        end;
    end;
  end;

  Result := Result + '"';
end;

class function TclJSONBase.DecodeString(const ASource: string): WideString;
var
  i, j, k, len: Integer;
  code: string;
begin
  code := '$    ';
  len := Length(ASource);
  SetLength(Result, len);
  i := 1;
  j := 0;
  while (i <= len) do
  begin
    if (ASource[i] < ' ') then
    begin
      raise EclJSONError.Create(InvalidControlSymbol, InvalidControlSymbolCode);
    end;

    if (ASource[i] = '\') then
    Begin
      Inc(i);
      case ASource[i] of
        '"', '\', '/':
          begin
            Inc(j);
            Result[j] := WideChar(ASource[i]);
            Inc(i);
          end;
        'b':
          begin
            Inc(j);
            Result[j] := #8;
            Inc(i);
          end;
        't':
          begin
            Inc(j);
            Result[j] := #9;
            Inc(i);
          end;
        'n':
          begin
            Inc(j);
            Result[j] := #10;
            Inc(i);
          end;
        'f':
          begin
            Inc(j);
            Result[j] := #12;
            Inc(i);
          end;
        'r':
          begin
            Inc(j);
            Result[j] := #13;
            Inc(i);
          end;
        'u':
          begin
            if (i + 4 > len) then
            begin
              raise EclJSONError.Create(InvalidUnicodeEscSequence, InvalidUnicodeEscSequenceCode);
            end;

            for k := 1 to 4 do
            begin
              if not CharInSet(ASource[i + k], ['0'..'9', 'a'..'f', 'A'..'F']) then
              begin
                raise EclJSONError.Create(InvalidUnicodeEscSequence, InvalidUnicodeEscSequenceCode);
              end else
              begin
                code[k + 1] := ASource[i + k];
              end;
            end;

            Inc(j);
            Inc(i, 5);
            Result[j] := WideChar(StrToInt(code));
          end
        else
          raise EclJSONError.Create(UnrecognizedEscSequence, UnrecognizedEscSequenceCode);
      end;
    end else
    begin
      Inc(j);
      Result[j] := WideChar(ASource[i]);
      Inc(i);
    end;
  end;
  SetLength(Result, j);
end;

{$IFDEF DELPHI2009}
function TclJSONBase.GetJSONString: string;
var
  buffer: TStringBuilder;
begin
  buffer := TStringBuilder.Create();
  try
    BuildJSONString(buffer);
    Result := buffer.ToString();
  finally
    buffer.Free();
  end;
end;
{$ELSE}
function TclJSONBase.GetJSONString: string;
begin
  Result := BuildJSONString();
end;
{$ENDIF}

function TclJSONBase.GetValueString: string;
begin
  Result := string(ValueWideString);
end;

class function TclJSONBase.Parse(const AJSONString: string): TclJSONBase;
var
  Next: PChar;
begin
  Result := nil;
  Next := @AJSONString[1];
  if (Next^ = #0) then Exit;

  Result := ParseRoot(Next);
  try
    SkipWhiteSpace(Next);

    if (Next^ <> #0) then
    begin
      raise EclJSONError.Create(UnexpectedDataSymbol, UnexpectedDataSymbolCode);
    end;
  except
    Result.Free();
    raise;
  end;
end;

{ TclJSONObject }

function TclJSONObject.AddMember(APair: TclJSONPair): TclJSONPair;
begin
  FMembers.Add(APair);
  Result := APair;
end;

function TclJSONObject.AddMember(const AName: WideString; AValue: TclJSONBase): TclJSONPair;
begin
  if (AValue <> nil) then
  begin
    Result := AddMember(TclJSONPair.Create());

    Result.NameWideString := AName;
    Result.Value := AValue;
  end else
  begin
    Result := nil;
  end;
end;

function TclJSONObject.AddBoolean(const AName: string; AValue: Boolean): TclJSONBoolean;
begin
  if (AValue) then
  begin
    Result := TclJSONBoolean(AddMember(AName, TclJSONBoolean.Create(AValue)));
  end else
  begin
    Result := nil;
  end;
end;

function TclJSONObject.AddBoolean(const AName: WideString; AValue: Boolean): TclJSONBoolean;
begin
  if (AValue) then
  begin
    Result := TclJSONBoolean(AddMember(AName, TclJSONBoolean.Create(AValue)));
  end else
  begin
    Result := nil;
  end;
end;

function TclJSONObject.AddMember(const AName: string; AValue: TclJSONBase): TclJSONPair;
begin
  if (AValue <> nil) then
  begin
    Result := AddMember(TclJSONPair.Create());

    Result.Name := AName;
    Result.Value := AValue;
  end else
  begin
    Result := nil;
  end;
end;

function TclJSONObject.AddString(const AName, AValue: WideString): TclJSONString;
begin
  if (AValue <> '') then
  begin
    Result := TclJSONString(AddMember(AName, TclJSONString.Create(AValue)).Value);
  end else
  begin
    Result := nil;
  end;
end;

function TclJSONObject.AddValue(const AName, AValue: WideString): TclJSONValue;
begin
  if (AValue <> '') then
  begin
    Result := TclJSONValue(AddMember(AName, TclJSONValue.Create(AValue)).Value);
  end else
  begin
    Result := nil;
  end;
end;

function TclJSONObject.AddString(const AName, AValue: string): TclJSONString;
begin
  if (AValue <> '') then
  begin
    Result := TclJSONString(AddMember(AName, TclJSONString.Create(AValue)).Value);
  end else
  begin
    Result := nil;
  end;
end;

function TclJSONObject.AddValue(const AName, AValue: string): TclJSONValue;
begin
  if (AValue <> '') then
  begin
    Result := TclJSONValue(AddMember(AName, TclJSONValue.Create(AValue)).Value);
  end else
  begin
    Result := nil;
  end;
end;

function TclJSONObject.ArrayByName(const AName: WideString): TclJSONArray;
var
  pair: TclJSONPair;
begin
  pair := MemberByName(AName);
  if (pair <> nil) then
  begin
    if not (pair.Value is TclJSONArray) then
    begin
      raise EclJSONError.Create(UnexpectedDataType, UnexpectedDataTypeCode);
    end;

    Result := TclJSONArray(pair.Value);
  end else
  begin
    Result := nil;
  end;
end;

function TclJSONObject.ArrayByName(const AName: string): TclJSONArray;
begin
  Result := ArrayByName(WideString(AName));
end;

constructor TclJSONObject.Create;
begin
  inherited Create();
  FMembers := TObjectList.Create(True);
end;

destructor TclJSONObject.Destroy;
begin
  FMembers.Free();
  inherited Destroy();
end;

function TclJSONObject.GetCount: Integer;
begin
  Result := FMembers.Count;
end;

function TclJSONObject.BooleanByName(const AName: string): Boolean;
begin
  Result := BooleanByName(WideString(AName));
end;

function TclJSONObject.BooleanByName(const AName: WideString): Boolean;
var
  pair: TclJSONPair;
begin
  pair := MemberByName(AName);
  if (pair <> nil) then
  begin
    if not (pair.Value is TclJSONValue) then
    begin
      raise EclJSONError.Create(UnexpectedDataType, UnexpectedDataTypeCode);
    end;

    Result := (pair.ValueString = 'true');
  end else
  begin
    Result := False;
  end;
end;

{$IFDEF DELPHI2009}
procedure TclJSONObject.BuildJSONString(ABuffer: TStringBuilder);
const
  delimiter: array[Boolean] of string = ('', ', ');
var
  i: Integer;
begin
  ABuffer.Append('{');

  for i := 0 to Count - 1 do
  begin
    ABuffer.Append(delimiter[i > 0]);
    ABuffer.Append(Members[i].GetJSONString());
  end;

  ABuffer.Append('}');
end;
{$ELSE}
function TclJSONObject.BuildJSONString: string;
const
  delimiter: array[Boolean] of string = ('', ', ');
var
  i: Integer;
begin
  Result := '{';

  for i := 0 to Count - 1 do
  begin
    Result := Result + delimiter[i > 0] + Members[i].GetJSONString();
  end;

  Result := Result + '}';
end;
{$ENDIF}

function TclJSONObject.GetMember(Index: Integer): TclJSONPair;
begin
  Result := TclJSONPair(FMembers[Index]);
end;

function TclJSONObject.GetValueWideString: WideString;
begin
  Result := '';
end;

function TclJSONObject.MemberByName(const AName: WideString): TclJSONPair;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Members[i];
    if (Result.NameWideString = AName) then Exit;
  end;
  Result := nil;
end;

function TclJSONObject.ObjectByName(const AName: WideString): TclJSONObject;
var
  pair: TclJSONPair;
begin
  pair := MemberByName(AName);
  if (pair <> nil) then
  begin
    if not (pair.Value is TclJSONObject) then
    begin
      raise EclJSONError.Create(UnexpectedDataType, UnexpectedDataTypeCode);
    end;

    Result := TclJSONObject(pair.Value);
  end else
  begin
    Result := nil;
  end;
end;

function TclJSONObject.ObjectByName(const AName: string): TclJSONObject;
begin
  Result := ObjectByName(WideString(AName));
end;

function TclJSONObject.MemberByName(const AName: string): TclJSONPair;
begin
  Result := MemberByName(WideString(AName));
end;

procedure TclJSONObject.SetValueWideString(const AValue: WideString);
begin
end;

function TclJSONObject.ValueByName(const AName: string): string;
begin
  Result := string(ValueByName(WideString(AName)));
end;

function TclJSONObject.ValueByName(const AName: WideString): WideString;
var
  pair: TclJSONPair;
begin
  pair := MemberByName(AName);
  if (pair <> nil) then
  begin
    Result := pair.ValueWideString;
  end else
  begin
    Result := '';
  end;
end;

{ TclJSONPair }

constructor TclJSONPair.Create;
begin
  inherited Create();
  FValue := nil;
end;

destructor TclJSONPair.Destroy;
begin
  SetValue(nil);
  inherited Destroy();
end;

{$IFDEF DELPHI2009}
procedure TclJSONPair.BuildJSONString(ABuffer: TStringBuilder);
begin
  ABuffer.Append(EncodeString(NameWideString));
  ABuffer.Append(': ');
  ABuffer.Append(Value.GetJSONString());
end;
{$ELSE}
function TclJSONPair.BuildJSONString: string;
begin
  Result := EncodeString(NameWideString) + ': ' + Value.GetJSONString();
end;
{$ENDIF}

function TclJSONPair.GetName: string;
begin
  Result := string(FName);
end;

function TclJSONPair.GetValueWideString: WideString;
begin
  if (Value <> nil) then
  begin
    Result := Value.ValueWideString;
  end else
  begin
    Result := '';
  end;
end;

procedure TclJSONPair.SetName(const AValue: string);
begin
  FName := WideString(AValue);
end;

procedure TclJSONPair.SetValue(const AValue: TclJSONBase);
begin
  FValue.Free();
  FValue := AValue;
end;

procedure TclJSONPair.SetValueWideString(const AValue: WideString);
begin
  if (Value <> nil) then
  begin
    Value.ValueWideString := AValue;
  end;
end;

{ TclJSONArray }

function TclJSONArray.Add(AItem: TclJSONBase): TclJSONBase;
begin
  if (AItem <> nil) then
  begin
    FItems.Add(AItem);
  end;
  Result := AItem;
end;

constructor TclJSONArray.Create;
begin
  inherited Create();
  FItems := TObjectList.Create(True);
end;

destructor TclJSONArray.Destroy;
begin
  FItems.Free();
  inherited Destroy();
end;

function TclJSONArray.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TclJSONArray.GetItem(Index: Integer): TclJSONBase;
begin
  Result := TclJSONBase(FItems[Index]);
end;

function TclJSONArray.GetObject(Index: Integer): TclJSONObject;
var
  item: TclJSONBase;
begin
  item := Items[Index];
  if not (item is TclJSONObject) then
  begin
    raise EclJSONError.Create(UnexpectedDataType, UnexpectedDataTypeCode);
  end;
  Result := TclJSONObject(item);
end;

{$IFDEF DELPHI2009}
procedure TclJSONArray.BuildJSONString(ABuffer: TStringBuilder);
const
  delimiter: array[Boolean] of string = ('', ', ');
var
  i: Integer;
begin
  ABuffer.Append('[');

  for i := 0 to Count - 1 do
  begin
    ABuffer.Append(delimiter[i > 0]);
    ABuffer.Append(Items[i].GetJSONString());
  end;

  ABuffer.Append(']');
end;
{$ELSE}
function TclJSONArray.BuildJSONString: string;
const
  delimiter: array[Boolean] of string = ('', ', ');
var
  i: Integer;
begin
  Result := '[';

  for i := 0 to Count - 1 do
  begin
    Result := Result + delimiter[i > 0] + Items[i].GetJSONString();
  end;

  Result := Result + ']';
end;
{$ENDIF}

function TclJSONArray.GetValueWideString: WideString;
begin
  Result := '';
end;

procedure TclJSONArray.SetValueWideString(const AValue: WideString);
begin
end;

{ TclJSONValue }

constructor TclJSONValue.Create(const AValue: string);
begin
  inherited Create();
  ValueString := AValue;
end;

constructor TclJSONValue.Create(const AValue: WideString);
begin
  inherited Create();
  ValueWideString := AValue;
end;

constructor TclJSONValue.Create;
begin
  inherited Create();
  FValue := '';
end;

{$IFDEF DELPHI2009}
procedure TclJSONValue.BuildJSONString(ABuffer: TStringBuilder);
begin
  ABuffer.Append(ValueString);
end;
{$ELSE}
function TclJSONValue.BuildJSONString: string;
begin
  Result := ValueString;
end;
{$ENDIF}

function TclJSONValue.GetValueWideString: WideString;
begin
  Result := FValue;
end;

procedure TclJSONValue.SetValueWideString(const AValue: WideString);
begin
  FValue := AValue;
end;

{ TclJSONString }
{$IFDEF DELPHI2009}
procedure TclJSONString.BuildJSONString(ABuffer: TStringBuilder);
begin
  ABuffer.Append(EncodeString(ValueWideString));
end;
{$ELSE}
function TclJSONString.BuildJSONString: string;
begin
  Result := EncodeString(ValueWideString);
end;
{$ENDIF}

{ EclJSONError }

constructor EclJSONError.Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorMsg);
  FErrorCode := AErrorCode;
end;

{ TclJSONBoolean }

constructor TclJSONBoolean.Create;
begin
  inherited Create();
  Value := False;
end;

constructor TclJSONBoolean.Create(AValue: Boolean);
begin
  inherited Create();
  Value := AValue;
end;

function TclJSONBoolean.GetValue: Boolean;
begin
  Result := (JsonBoolean[True] = ValueWideString);
end;

procedure TclJSONBoolean.SetValue(const Value: Boolean);
begin
  ValueWideString := JsonBoolean[Value];
end;

procedure TclJSONBoolean.SetValueWideString(const AValue: WideString);
begin
  if (JsonBoolean[True] = AValue) then
  begin
    inherited SetValueWideString(JsonBoolean[True]);
  end else
  begin
    inherited SetValueWideString(JsonBoolean[False]);
  end;
end;

end.
