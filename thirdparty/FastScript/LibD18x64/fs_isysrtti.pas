
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Standard functions            }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_isysrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_itools
{$IFDEF CLX}
  , QDialogs, MaskUtils, Variants
{$ELSE}
  {$IFNDEF NOFORMS}
    , Dialogs
  {$ENDIF}
  {$IFDEF FPC}
    {, Mask}, Variants
  {$ELSE}
    {$IFDEF Delphi6}
      , MaskUtils, Variants, Windows
    {$ELSE}
      , Mask
    {$ENDIF}
  {$ENDIF}
{$ENDIF}
{$IFDEF OLE}
  , ComObj
{$ENDIF};

type
  TfsSysFunctions = class(TfsRTTIModule)
  private
    FCatConv: String;
    FCatDate: String;
    FCatFormat: String;
    FCatMath: String;
    FCatOther: String;
    FCatStr: String;
    function CallMethod1(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function CallMethod2(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function CallMethod3(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function CallMethod4(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function CallMethod5(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function CallMethod6(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function CallMethod7(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;


implementation


function FormatV(const Fmt: String; Args: Variant): String;
var
  ar: TVarRecArray;
begin
  VariantToVarRec(Args, ar);
  Result := Format(Fmt, ar);
  ClearVarRec(ar);
end;

function VArrayCreate(Args: Variant; Typ: Integer): Variant;
var
  i, n: Integer;
  ar: array of Integer;
begin
  n := VarArrayHighBound(Args, 1) + 1;
  SetLength(ar, n);
  for i := 0 to n - 1 do
    ar[i] := Args[i];

  Result := VarArrayCreate(ar, Typ);
  ar := nil;
end;

function NameCase(const s: String): String;
var
  i: Integer;
begin
  Result := AnsiLowercase(s);
  for i := 1 to Length(s) do
    if i = 1 then
      Result[i] := AnsiUpperCase(s[i])[1]
    else if i < Length(s) then
      if s[i] = ' ' then
        Result[i + 1] := AnsiUpperCase(s[i + 1])[1];
end;

function ValidInt(cInt: String): Boolean;
begin
  Result := True;
  try
    StrToInt(cInt);
  except
    Result := False;
  end;
end;

function ValidFloat(cFlt: String): Boolean;
begin
  Result := True;
  try
    StrToFloat(cFlt);
  except
    Result := False;
  end;
end;

function ValidDate(cDate: String) :Boolean;
begin
  Result := True;
  try
    StrToDate(cDate);
  except
    Result := False;
  end;
end;

function DaysInMonth(nYear, nMonth: Integer): Integer;
const
  Days: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
begin
  Result := Days[nMonth];
  if (nMonth = 2) and IsLeapYear(nYear) then Inc(Result);
end;


{ TfsSysFunctions }

constructor TfsSysFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  FCatStr := 'ctString';
  FCatDate := 'ctDate';
  FCatConv := 'ctConv';
  FCatFormat := 'ctFormat';
  FCatMath := 'ctMath';
  FCatOther := 'ctOther';

  with AScript do
  begin
    AddType('Byte', fvtInt);
    AddType('Word', fvtInt);
    AddType('Integer', fvtInt);
    AddType('Longint', fvtInt);
    AddType('Cardinal', fvtInt);
    AddType('TColor', fvtInt);
    AddType('Boolean', fvtBool);
    AddType('Real', fvtFloat);
    AddType('Single', fvtFloat);
    AddType('Double', fvtFloat);
    AddType('Extended', fvtFloat);
    AddType('Currency', fvtFloat);
    AddType('TDate', fvtFloat);
    AddType('TTime', fvtFloat);
    AddType('TDateTime', fvtFloat);
    AddType('Char', fvtChar);
    AddType('String', fvtString);
    AddType('Variant', fvtVariant);
    AddType('Pointer', fvtVariant);
    AddType('Array', fvtArray);
    AddType('Constructor', fvtConstructor);

    AddConst('True', 'Boolean', True);
    AddConst('False', 'Boolean', False);
    AddConst('nil', 'Variant', 0);
    AddConst('Null', 'Variant', Null);

    Add('__StringHelper', TfsStringHelper.Create);
    Add('__ArrayHelper', TfsArrayHelper.Create('__ArrayHelper', -1, fvtVariant, ''));
    AddVariable('ExceptionClassName', 'String', '');
    AddVariable('ExceptionMessage', 'String', '');

    AddMethod('function IntToStr(i: Integer): String', CallMethod1, FCatConv);
    AddMethod('function FloatToStr(e: Extended): String', CallMethod1, FCatConv);
    AddMethod('function DateToStr(e: Extended): String', CallMethod1, FCatConv);
    AddMethod('function TimeToStr(e: Extended): String', CallMethod1, FCatConv);
    AddMethod('function DateTimeToStr(e: Extended): String', CallMethod1, FCatConv);
{$IFDEF Delphi6}
    AddMethod('function BoolToStr(B: Boolean): string;', CallMethod1, FCatConv);
{$ENDIF}
    AddMethod('function VarToStr(v: Variant): String', CallMethod7, FCatConv);

    AddMethod('function StrToInt(s: String): Integer', CallMethod2, FCatConv);
{$IFDEF Delphi6}
    AddMethod('function StrToInt64(s: String): Integer', CallMethod2, FCatConv);
{$ENDIF}
    AddMethod('function StrToFloat(s: String): Extended', CallMethod2, FCatConv);
    AddMethod('function StrToDate(s: String): Extended', CallMethod2, FCatConv);
    AddMethod('function StrToTime(s: String): Extended', CallMethod2, FCatConv);
    AddMethod('function StrToDateTime(s: String): Extended', CallMethod2, FCatConv);
{$IFDEF Delphi6}
    AddMethod('function StrToBool(const S: string): Boolean;', CallMethod2, FCatConv);
{$ENDIF}

    AddMethod('function Format(Fmt: String; Args: array): String', CallMethod3, FCatFormat);
    AddMethod('function FormatFloat(Fmt: String; Value: Extended): String', CallMethod3, FCatFormat);
    AddMethod('function FormatDateTime(Fmt: String; DateTime: TDateTime): String', CallMethod3, FCatFormat);
    AddMethod('function FormatMaskText(EditMask: string; Value: string): string', CallMethod3, FCatFormat);

    AddMethod('function EncodeDate(Year, Month, Day: Word): TDateTime', CallMethod4, FCatDate);
    AddMethod('procedure DecodeDate(Date: TDateTime; var Year, Month, Day: Word)', CallMethod4, FCatDate);
    AddMethod('function EncodeTime(Hour, Min, Sec, MSec: Word): TDateTime', CallMethod4, FCatDate);
    AddMethod('procedure DecodeTime(Time: TDateTime; var Hour, Min, Sec, MSec: Word)', CallMethod4, FCatDate);
    AddMethod('function Date: TDateTime', CallMethod4, FCatDate);
    AddMethod('function Time: TDateTime', CallMethod4, FCatDate);
    AddMethod('function Now: TDateTime', CallMethod4, FCatDate);
    AddMethod('function DayOfWeek(aDate: TDateTime): Integer', CallMethod4, FCatDate);
    AddMethod('function IsLeapYear(Year: Word): Boolean', CallMethod4, FCatDate);
    AddMethod('function DaysInMonth(nYear, nMonth: Integer): Integer', CallMethod4, FCatDate);

    AddMethod('function Length(s: Variant): Integer', CallMethod5, FCatStr);
    AddMethod('function Copy(s: String; from, count: Integer): String', CallMethod5, FCatStr);
    AddMethod('function Pos(substr, s: String): Integer', CallMethod5, FCatStr);
    AddMethod('procedure Delete(var s: String; from, count: Integer)', CallMethod5, FCatStr);
    AddMethod('procedure DeleteStr(var s: String; from, count: Integer)', CallMethod5, FCatStr);
    AddMethod('procedure Insert(s: String; var s2: String; pos: Integer)', CallMethod5, FCatStr);
    AddMethod('function Uppercase(s: String): String', CallMethod5, FCatStr);
    AddMethod('function Lowercase(s: String): String', CallMethod5, FCatStr);
    AddMethod('function Trim(s: String): String', CallMethod5, FCatStr);
    AddMethod('function NameCase(s: String): String', CallMethod5, FCatStr);
    AddMethod('function CompareText(s, s1: String): Integer', CallMethod5, FCatStr);
    AddMethod('function Chr(i: Integer): Char', CallMethod5, FCatStr);
    AddMethod('function Ord(ch: Char): Integer', CallMethod5, FCatStr);
    AddMethod('procedure SetLength(var S: Variant; L: Integer)', CallMethod5, FCatStr);

    AddMethod('function Round(e: Extended): Integer', CallMethod6, FCatMath);
    AddMethod('function Trunc(e: Extended): Integer', CallMethod6, FCatMath);
    AddMethod('function Int(e: Extended): Integer', CallMethod6, FCatMath);
    AddMethod('function Frac(X: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Sqrt(e: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Abs(e: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Sin(e: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Cos(e: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function ArcTan(X: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Tan(X: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Exp(X: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Ln(X: Extended): Extended', CallMethod6, FCatMath);
    AddMethod('function Pi: Extended', CallMethod6, FCatMath);

    AddMethod('procedure Inc(var i: Integer; incr: Integer = 1)', CallMethod7, FCatOther);
    AddMethod('procedure Dec(var i: Integer; decr: Integer = 1)', CallMethod7, FCatOther);
    AddMethod('procedure RaiseException(Param: String)', CallMethod7, FCatOther);
    AddMethod('procedure ShowMessage(Msg: Variant)', CallMethod7, FCatOther);
    AddMethod('procedure Randomize', CallMethod7, FCatOther);
    AddMethod('function Random: Extended', CallMethod7, FCatOther);
    AddMethod('function ValidInt(cInt: String): Boolean', CallMethod7, FCatOther);
    AddMethod('function ValidFloat(cFlt: String): Boolean', CallMethod7, FCatOther);
    AddMethod('function ValidDate(cDate: String): Boolean', CallMethod7, FCatOther);
    AddMethod('function ExtractFilePath(const FileName: string): string;', CallMethod7, FCatOther);
{$IFDEF OLE}
    AddMethod('function CreateOleObject(ClassName: String): Variant', CallMethod7, FCatOther);
{$ENDIF};
    AddMethod('function VarArrayCreate(Bounds: Array; Typ: Integer): Variant', CallMethod7, FCatOther);
    AddMethod('function VarType(V: Variant): Integer', CallMethod7, FCatOther);

    AddConst('varEmpty', 'Integer', 0);
    AddConst('varNull', 'Integer', 1);
    AddConst('varSmallint', 'Integer', 2);
    AddConst('varInteger', 'Integer', 3);
    AddConst('varSingle', 'Integer', 4);
    AddConst('varDouble', 'Integer', 5);
    AddConst('varCurrency', 'Integer', 6);
    AddConst('varDate', 'Integer', 7);
    AddConst('varOleStr', 'Integer', 8);
    AddConst('varDispatch', 'Integer', 9);
    AddConst('varError', 'Integer', $000A);
    AddConst('varBoolean', 'Integer', $000B);
    AddConst('varVariant', 'Integer', $000C);
    AddConst('varUnknown', 'Integer', $000D);
    AddConst('varShortInt', 'Integer', $0010);
    AddConst('varByte', 'Integer', $0011);
    AddConst('varWord', 'Integer', $0012);
    AddConst('varLongWord', 'Integer', $0013);
    AddConst('varInt64', 'Integer', $0014);
    AddConst('varStrArg', 'Integer', $0048);
    AddConst('varString', 'Integer', $0100);
    AddConst('varAny', 'Integer', $0101);
    AddConst('varTypeMask', 'Integer', $0FFF);
    AddConst('varArray', 'Integer', $2000);
    AddConst('varByRef', 'Integer', $4000);
  end;
end;

function TfsSysFunctions.CallMethod1(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
var
{$IFDEF Delphi6}
  i: Int64;
{$ELSE}
  i: Integer;
{$ENDIF}
begin
  if MethodName = 'INTTOSTR' then
  begin
    i := Caller.Params[0];
    Result := IntToStr(i)
  end
  else if MethodName = 'FLOATTOSTR' then
    Result := FloatToStr(Caller.Params[0])
  else if MethodName = 'DATETOSTR' then
    Result := DateToStr(Caller.Params[0])
  else if MethodName = 'TIMETOSTR' then
    Result := TimeToStr(Caller.Params[0])
  else if MethodName = 'DATETIMETOSTR' then
    Result := DateTimeToStr(Caller.Params[0])
{$IFDEF Delphi6}
  else if MethodName = 'BOOLTOSTR' then
    Result := BoolToStr(Caller.Params[0])
{$ENDIF}
end;

function TfsSysFunctions.CallMethod2(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if MethodName = 'STRTOINT' then
    Result := StrToInt(Caller.Params[0])
{$IFDEF Delphi6}
  else if MethodName = 'STRTOINT64' then
    Result := StrToInt64(Caller.Params[0])
{$ENDIF}
  else if MethodName = 'STRTOFLOAT' then
    Result := StrToFloat(Caller.Params[0])
  else if MethodName = 'STRTODATE' then
    Result := StrToDate(Caller.Params[0])
  else if MethodName = 'STRTOTIME' then
    Result := StrToTime(Caller.Params[0])
  else if MethodName = 'STRTODATETIME' then
    Result := StrToDateTime(Caller.Params[0])
{$IFDEF Delphi6}
  else if MethodName = 'STRTOBOOL' then
    Result := BoolToStr(Caller.Params[0])
{$ENDIF}
end;

function TfsSysFunctions.CallMethod3(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if MethodName = 'FORMAT' then
    Result := FormatV(Caller.Params[0], Caller.Params[1])
  else if MethodName = 'FORMATFLOAT' then
    Result := FormatFloat(Caller.Params[0], Caller.Params[1])
  else if MethodName = 'FORMATDATETIME' then
    Result := FormatDateTime(Caller.Params[0], Caller.Params[1])
{$IFNDEF FPC}
// fpc still have no maskedit
  else if MethodName = 'FORMATMASKTEXT' then
    Result := FormatMaskText(Caller.Params[0], Caller.Params[1])
{$ENDIF}
end;

function TfsSysFunctions.CallMethod4(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  w1, w2, w3, w4: Word;
begin
  if MethodName = 'ENCODEDATE' then
    Result := EncodeDate(Caller.Params[0], Caller.Params[1], Caller.Params[2])
  else if MethodName = 'ENCODETIME' then
    Result := EncodeTime(Caller.Params[0], Caller.Params[1], Caller.Params[2], Caller.Params[3])
  else if MethodName = 'DECODEDATE' then
  begin
    DecodeDate(Caller.Params[0], w1, w2, w3);
    Caller.Params[1] := w1;
    Caller.Params[2] := w2;
    Caller.Params[3] := w3;
  end
  else if MethodName = 'DECODETIME' then
  begin
    DecodeTime(Caller.Params[0], w1, w2, w3, w4);
    Caller.Params[1] := w1;
    Caller.Params[2] := w2;
    Caller.Params[3] := w3;
    Caller.Params[4] := w4;
  end
  else if MethodName = 'DATE' then
    Result := Date
  else if MethodName = 'TIME' then
    Result := Time
  else if MethodName = 'NOW' then
    Result := Now
  else if MethodName = 'DAYOFWEEK' then
    Result := DayOfWeek(Caller.Params[0])
  else if MethodName = 'ISLEAPYEAR' then
    Result := IsLeapYear(Caller.Params[0])
  else if MethodName = 'DAYSINMONTH' then
    Result := DaysInMonth(Caller.Params[0], Caller.Params[1])
end;

function TfsSysFunctions.CallMethod5(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  s: String;
  v: Variant;
begin
  if MethodName = 'LENGTH' then
  begin
    v := Caller.Params[0];
    if VarIsArray(v) then
      Result := VarArrayHighBound(v, 1) - VarArrayLowBound(v, 1) + 1
    else
      Result := Length(v)
  end
  else if MethodName = 'COPY' then
    Result := Copy(Caller.Params[0], Integer(Caller.Params[1]), Integer(Caller.Params[2]))
  else if MethodName = 'POS' then
  {$IFNDEF FPC}
    Result := Pos(Caller.Params[0], Caller.Params[1])
  {$ELSE}
    Result := Pos(AnsiString(Caller.Params[0]), AnsiString(Caller.Params[1]))
  {$ENDIF}
  else if (MethodName = 'DELETE') or (MethodName = 'DELETESTR') then
  begin
    s := Caller.Params[0];
    Delete(s, Integer(Caller.Params[1]), Integer(Caller.Params[2]));
    Caller.Params[0] := s;
  end
  else if MethodName = 'INSERT' then
  begin
    s := Caller.Params[1];
    Insert(Caller.Params[0], s, Integer(Caller.Params[2]));
    Caller.Params[1] := s;
  end
  else if MethodName = 'UPPERCASE' then
    Result := AnsiUppercase(Caller.Params[0])
  else if MethodName = 'LOWERCASE' then
    Result := AnsiLowercase(Caller.Params[0])
  else if MethodName = 'TRIM' then
    Result := Trim(Caller.Params[0])
  else if MethodName = 'NAMECASE' then
    Result := NameCase(Caller.Params[0])
  else if MethodName = 'COMPARETEXT' then
    Result := AnsiCompareText(Caller.Params[0], Caller.Params[1])
  else if MethodName = 'CHR' then
    Result := Chr(Integer(Caller.Params[0]))
  else if MethodName = 'ORD' then
    Result := Ord(String(Caller.Params[0])[1])
  else if MethodName = 'SETLENGTH' then
  begin
    if (TVarData(Caller.Params[0]).VType = varString) or
{$IFDEF Delphi12}
      (TVarData(Caller.Params[0]).VType = varUString) or
{$ENDIF}
      (TVarData(Caller.Params[0]).VType = varOleStr) then
    begin
      s := Caller.Params[0];
      SetLength(s, Integer(Caller.Params[1]));
      Caller.Params[0] := s;
    end
    else
    begin
      v := Caller.Params[0];
      VarArrayRedim(v, Integer(Caller.Params[1]) - 1);
      Caller.Params[0] := v;
    end;
  end
end;

function TfsSysFunctions.CallMethod6(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if MethodName = 'ROUND' then
    Result := Integer(Round(Caller.Params[0]))
  else if MethodName = 'TRUNC' then
    Result := Integer(Trunc(Caller.Params[0]))
  else if MethodName = 'INT' then
    Result := Int(Caller.Params[0])
  else if MethodName = 'FRAC' then
    Result := Frac(Caller.Params[0])
  else if MethodName = 'SQRT' then
    Result := Sqrt(Caller.Params[0])
  else if MethodName = 'ABS' then
    Result := Abs(Caller.Params[0])
  else if MethodName = 'SIN' then
    Result := Sin(Caller.Params[0])
  else if MethodName = 'COS' then
    Result := Cos(Caller.Params[0])
  else if MethodName = 'ARCTAN' then
    Result := ArcTan(Caller.Params[0])
  else if MethodName = 'TAN' then
    Result := Sin(Caller.Params[0]) / Cos(Caller.Params[0])
  else if MethodName = 'EXP' then
    Result := Exp(Caller.Params[0])
  else if MethodName = 'LN' then
    Result := Ln(Caller.Params[0])
  else if MethodName = 'PI' then
    Result := Pi
end;

function TfsSysFunctions.CallMethod7(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  if MethodName = 'INC' then
  begin
    Caller.Params[0] := Caller.Params[0] + Caller.Params[1];
  end
  else if MethodName = 'DEC' then
  begin
    Caller.Params[0] := Caller.Params[0] - Caller.Params[1];
  end
  else if MethodName = 'RAISEEXCEPTION' then
    raise Exception.Create(Caller.Params[0])
{$IFNDEF NOFORMS}
  else if MethodName = 'SHOWMESSAGE' then
    ShowMessage(Caller.Params[0])
{$ENDIF}
  else if MethodName = 'RANDOMIZE' then
    Randomize
  else if MethodName = 'RANDOM' then
    Result := Random
  else if MethodName = 'VALIDINT' then
    Result := ValidInt(Caller.Params[0])
  else if MethodName = 'VALIDFLOAT' then
    Result := ValidFloat(Caller.Params[0])
  else if MethodName = 'VALIDDATE' then
  begin
    if VarType(Caller.Params[0]) = varDate then
      Result := ValidDate(DateToStr(Caller.Params[0]))
    else Result := ValidDate(Caller.Params[0]);
  end
{$IFDEF OLE}
  else if MethodName = 'CREATEOLEOBJECT' then
    Result := CreateOleObject(Caller.Params[0])
{$ENDIF}
  else if MethodName = 'VARARRAYCREATE' then
    Result := VArrayCreate(Caller.Params[0], Caller.Params[1])
  else if MethodName = 'VARTOSTR' then
    Result := VarToStr(Caller.Params[0])
  else if MethodName = 'VARTYPE' then
    Result := VarType(Caller.Params[0])
  else if MethodName = 'EXTRACTFILEPATH' then
    Result := ExtractFilePath(Caller.Params[0])
end;


end.
