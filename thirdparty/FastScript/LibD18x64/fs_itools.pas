
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Common functions              }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_itools;

interface

{$i fs.inc}

uses
  SysUtils, Classes, TypInfo, fs_iinterpreter, fs_xml
{$IFDEF Delphi6}
, Variants
{$ENDIF}
{$IFDEF CROSS_COMPILE}
, Types
{$ELSE}
, Windows
{$ENDIF};

type
  TVarRecArray = array of TVarRec;


procedure fsRegisterLanguage(const Name, Grammar: String);
function fsGetLanguage(const Name: String): String;
procedure fsGetLanguageList(List: TStrings);

procedure GenerateXMLContents(Prog: TfsScript; Item: TfsXMLItem;
  FunctionsOnly: Boolean = False);
procedure GenerateMembers(Prog: TfsScript; cl: TClass; Item: TfsXMLItem);
function StrToVarType(const TypeName: String; Script: TfsScript): TfsVarType;
function TypesCompatible(Typ1, Typ2: TfsTypeRec; Script: TfsScript): Boolean;
function AssignCompatible(Var1, Var2: TfsCustomVariable; Script: TfsScript): Boolean;
function VarRecToVariant(v: TVarRec): Variant;
procedure VariantToVarRec(v: Variant; var ar: TVarRecArray);
procedure ClearVarRec(var ar: TVarRecArray);
function ParserStringToVariant(s: String): Variant;
function ParseMethodSyntax(const Syntax: String; Script: TfsScript): TfsCustomVariable;
function fsPosToPoint(const ErrorPos: String): TPoint;
{$IFNDEF Delphi4}
function fsSetToString(PropInfo: PPropInfo; const Value: Variant): string;
{$ENDIF}

implementation
uses
  fs_iparser,
  fs_iconst;

var
  Languages: TStringList;

procedure fsRegisterLanguage(const Name, Grammar: String);
var
  i: Integer;
begin
  i := Languages.IndexOfName(Name);
  if i = -1 then
    Languages.Add(Name + '=' + Grammar)
  else
    Languages[i] := Name + '=' + Grammar;
end;

function fsGetLanguage(const Name: String): String;
begin
  if Languages.IndexOfName(Name) = -1 then
    raise Exception.CreateFmt(SLangNotFound, [Name]) else
    Result := Languages.Values[Name];
end;

procedure fsGetLanguageList(List: TStrings);
var
  i: Integer;
begin
  List.Clear;
  for i := 0 to Languages.Count - 1 do
    if Languages.Names[i][1] <> '@' then
      List.Add(Languages.Names[i]);
end;


function StrToVarType(const TypeName: String; Script: TfsScript): TfsVarType;
var
  v: TfsCustomVariable;
begin
  v := Script.Find(TypeName);
  if v = nil then
    Result := fvtClass else
    Result := v.Typ;
end;

function ClassesCompatible(const Class1, Class2: String; Script: TfsScript): Boolean;
var
  cl1, cl2: TfsClassVariable;
begin
  Result := False;
  cl1 := Script.FindClass(Class1);
  cl2 := Script.FindClass(Class2);
  if (cl1 <> nil) and (cl2 <> nil) then
    Result := cl2.ClassRef.InheritsFrom(cl1.ClassRef);
end;

function TypesCompatible(Typ1, Typ2: TfsTypeRec; Script: TfsScript): Boolean;
begin
  Result := False;
  case Typ1.Typ of
    fvtInt:
      Result := Typ2.Typ in [fvtInt, fvtFloat, fvtVariant, fvtEnum];
    fvtFloat:
      Result := Typ2.Typ in [fvtInt, fvtFloat, fvtVariant];
    fvtBool:
      Result := Typ2.Typ in [fvtBool, fvtVariant];
    fvtChar, fvtString:
      Result := Typ2.Typ in [fvtChar, fvtString, fvtVariant];
    fvtClass:
      Result := (Typ2.Typ = fvtVariant) or ((Typ2.Typ = fvtClass) and
         ClassesCompatible(Typ1.TypeName, Typ2.TypeName, Script));
    fvtArray:
      Result := Typ2.Typ in [fvtArray, fvtVariant];
    fvtVariant:
      Result := True;
    fvtEnum:
      begin
        Result := Typ2.Typ in [fvtInt, fvtVariant, fvtEnum];
        if Typ2.Typ = fvtEnum then
  Result := AnsiCompareText(Typ1.TypeName, Typ2.TypeName) = 0;
      end;
  end;
end;

function AssignCompatible(Var1, Var2: TfsCustomVariable; Script: TfsScript): Boolean;
var
  t1, t2: TfsTypeRec;
begin
  t1.Typ := Var1.Typ;
  t1.TypeName := Var1.TypeName;
  t2.Typ := Var2.Typ;
  t2.TypeName := Var2.TypeName;

  Result := TypesCompatible(t1, t2, Script);
  if Result and (Var1.Typ = fvtInt) and (Var2.Typ = fvtFloat) then
    Result := False;
end;

function VarRecToVariant(v: TVarRec): Variant;
begin
  with v do
    case VType of
      vtInteger, vtObject:
        Result := VInteger;
      vtBoolean:
        Result := VBoolean;
      vtExtended, vtCurrency:
        Result := VExtended^;
      vtChar:
        Result := VChar;
      vtString:
        Result := VString^;
      vtAnsiString:
        Result := AnsiString(VAnsiString);
{$IFDEF Delphi12}
      vtUnicodeString:
        Result := String(VUnicodeString^);
      vtWideString:
        Result := WideString(VWideString^);
      vtWideChar:
        Result := VWideChar;
{$ENDIF}
      vtVariant:
        Result := VVariant^;
      else
        Result := Null;
    end;
end;

procedure VariantToVarRec(v: Variant; var ar: TVarRecArray);
var
  i: Integer;
begin
  SetLength(ar, VarArrayHighBound(v, 1) + 1);

  for i := 0 to VarArrayHighBound(v, 1) do
    case TVarData(v[i]).VType of
      varSmallint, varInteger, varByte{$IFDEF Delphi6}, varShortInt, varWord, varLongWord{$ENDIF}:
        begin
          ar[i].VType := vtInteger;
          ar[i].VInteger := v[i];
        end;
{$IFDEF Delphi6}
      varInt64:
        begin
          ar[i].VType := vtInt64;
          New(ar[i].VInt64);
          ar[i].VInt64^ := v[i];
        end;
{$ENDIF}
      varSingle, varDouble, varCurrency, varDate:
        begin
          ar[i].VType := vtExtended;
          New(ar[i].VExtended);
          ar[i].VExtended^ := v[i];
        end;
      varBoolean:
        begin
          ar[i].VType := vtBoolean;
          ar[i].VBoolean := v[i];
        end;
      varOleStr, varString:
        begin
          ar[i].VType := vtString;
          New(ar[i].VString);
{$IFDEF Delphi12}
          ar[i].VString^ := AnsiString(v[i]);
{$ELSE}
          ar[i].VString^ := v[i];
{$ENDIF}
        end;
{$IFDEF Delphi12}
      varUString:
        begin
          ar[i].VType := vtUnicodeString;
          New(ar[i].VUnicodeString);
          PUnicodeString(ar[i].VUnicodeString)^ := v[i];
        end;
{$ENDIF}
      varVariant:
        begin
          ar[i].VType := vtVariant;
          New(ar[i].VVariant);
          ar[i].VVariant^ := v[i];
        end;
    end;
end;

procedure ClearVarRec(var ar: TVarRecArray);
var
  i: Integer;
begin
  for i := 0 to Length(ar) - 1 do
    if ar[i].VType in [vtExtended, vtString, vtVariant {$IFDEF Delphi6}, vtInt64 {$ENDIF}] then
      Dispose(ar[i].VExtended);
  Finalize(ar);
end;

function ParserStringToVariant(s: String): Variant;
var
  i: Int64;
  k: Integer;
  iPos: Integer;
begin
  Result := Null;
  if s <> '' then
    if s[1] = '''' then
      Result := Copy(s, 2, Length(s) - 2)
    else
    begin
      Val(s, i, k);
      if k = 0 then
{$IFDEF Delphi6}
        if i > MaxInt then
          Result := i
        else
          Result := Integer(i)
{$ELSE}
        Result := Integer(i)
{$ENDIF}
      else
      begin
        {if DecimalSeparator <> '.' then
        begin
          iPos := Pos('.', s);
          if iPos > 0 then
            s[iPos] := DecimalSeparator;
        end;}
        Result := StrToFloat(s);
      end;
    end;
end;

function ParseMethodSyntax(const Syntax: String; Script: TfsScript): TfsCustomVariable;
var
  Parser: TfsParser;
  i, j: Integer;
  Name, Params, TypeName, s: String;
  isFunc, isMacro, varParam: Boolean;
  InitValue: Variant;
  v: TfsCustomVariable;

  procedure AddParams;
  var
    i: Integer;
    p: TfsParamItem;
    sl: TStringList;
  begin
    sl := TStringList.Create;
    try
      Delete(Params, Length(Params), 1);
      sl.CommaText := Params;
      for i := 0 to sl.Count - 2 do
      begin
        p := TfsParamItem.Create(sl[i], StrToVarType(TypeName, Script), TypeName,
          False, varParam);
        Result.Add(p);
      end;
      p := TfsParamItem.Create(sl[sl.Count - 1], StrToVarType(TypeName, Script), TypeName,
        InitValue <> Null, varParam);
      p.DefValue := InitValue;
      Result.Add(p);

    finally
      sl.Free;
    end;
  end;

begin
  Parser := TfsParser.Create;
  if Script.ExtendedCharset then
    for i := 128 to 255 do
      Parser.IdentifierCharset := Parser.IdentifierCharset + [Chr(i)];
  Parser.Text := Syntax;

  s := Parser.GetIdent;
  isMacro := Pos('macro', AnsiLowercase(s)) = 1;
  if isMacro then
    s := Copy(s, 6, 255);
  isFunc := CompareText(s, 'function') = 0;
  Name := Parser.GetIdent;

  if isFunc then
  begin
    j := Length(Syntax);
    while Syntax[j] <> ':' do
      Dec(j);

    i := Parser.Position;
    Parser.Position := j + 1;
    TypeName := Parser.GetIdent;
    Parser.Position := i;
  end
  else
    TypeName := '';

  Result := TfsCustomVariable.Create(Name, StrToVarType(TypeName, Script), TypeName);
  Result.IsMacro := IsMacro;

  Parser.SkipSpaces;
  s := Parser.GetChar;
  if s = '(' then
  begin
    repeat
      varParam := False;
      Params := '';

      repeat
        s := Parser.GetIdent;
        if CompareText(s, 'var') = 0 then
          varParam := True
        else if CompareText(s, 'const') = 0 then // do nothing
        else
          Params := Params + s + ',';
        Parser.SkipSpaces;
        s := Parser.GetChar;
        if s = ':' then
        begin
          TypeName := Parser.GetIdent;
          Parser.SkipSpaces;
          i := Parser.Position;
          if Parser.GetChar = '=' then
          begin
            s := Parser.GetNumber;
            if s = '' then
              s := Parser.GetString;
            if s = '' then
            begin
              i := Parser.Position;
              s := Parser.GetChar;
              if s = '-' then
                s := '-' + Parser.GetNumber else
                Parser.Position := i;
            end;

            if s <> '' then
              InitValue := ParserStringToVariant(s)
            else
            begin
              s := Parser.GetIdent;  { it's constant }
              v := Script.Find(s);
              if v <> nil then
                InitValue := v.Value else
                InitValue := Null;
            end
          end
          else
          begin
            InitValue := Null;
            Parser.Position := i;
          end;
          AddParams;
          s := ';';
        end
        else if s = ')' then
        begin
          Parser.Position := Parser.Position - 1;
          break;
        end;
      until s = ';';

      Parser.SkipSpaces;
    until Parser.GetChar = ')';
  end;

  Parser.Free;
end;

function fsPosToPoint(const ErrorPos: String): TPoint;
begin
  Result.X := 0;
  Result.Y := 0;
  if ErrorPos <> '' then
  begin
    Result.Y := StrToInt(Copy(ErrorPos, 1, Pos(':', ErrorPos) - 1));
    Result.X := StrToInt(Copy(ErrorPos, Pos(':', ErrorPos) + 1, 255));
  end;
end;

procedure GenerateXMLContents(Prog: TfsScript; Item: TfsXMLItem;
  FunctionsOnly: Boolean = False);
var
  i, j: Integer;
  v: TfsCustomVariable;
  c: TfsClassVariable;
  xi: TfsXMLItem;
  clItem: TfsCustomHelper;
  s: String;
begin
  Item.FindItem('Functions');
  Item.FindItem('Classes');
  Item.FindItem('Types');
  Item.FindItem('Variables');
  Item.FindItem('Constants');

  for i := 0 to Prog.Count - 1 do
  begin
    v := Prog.Items[i];
    if not (v is TfsMethodHelper) and FunctionsOnly then
      continue;
    if v is TfsMethodHelper then
    begin
      xi := Item.FindItem('Functions');
      xi := xi.FindItem(TfsMethodHelper(v).Category);
      xi.Text := 'text="' + xi.Name + '"';
      with xi.Add do
      begin
        Name := 'item';
        s := TfsMethodHelper(v).Syntax;
        Text := 'text="' + s + '" description="' +
          TfsMethodHelper(v).Description + '"';
      end;
    end
    else if v is TfsClassVariable then
    begin
      c := TfsClassVariable(v);
      xi := Item.FindItem('Classes');
      xi := xi.Add;
      with xi do
      begin
        Name := 'item';
        Text := 'text="' + c.Name + ' = class(' + c.Ancestor + ')"';
      end;

      for j := 0 to c.MembersCount - 1 do
      begin
        clItem := c.Members[j];
        with xi.Add do
        begin
          Name := 'item';
          Text := 'text="';
          if clItem is TfsPropertyHelper then
            Text := Text + 'property ' + clItem.Name + ': ' + clItem.GetFullTypeName + '"'
          else if clItem is TfsMethodHelper then
          begin
            s := TfsMethodHelper(clItem).Syntax;
            if TfsMethodHelper(clItem).IndexMethod then
      s := 'index property' + Copy(s, Pos(' ', s), 255);
            Text := Text + s + '"';
          end
          else
            Text := Text + 'event ' + clItem.Name + '"';
        end;
      end;
    end
    else if v is TfsVariable then
    begin
      if v.Typ = fvtEnum then
      begin
        xi := Item.FindItem('Types');
        with xi.FindItem(v.TypeName) do
        begin
          if v.Name <> v.TypeName then
            if Text = '' then
              Text := v.Name else
              Text := Text + ',' + v.Name;
        end;
      end
      else
      begin
        if v.IsReadOnly then
          xi := Item.FindItem('Constants') else
          xi := Item.FindItem('Variables');
        with xi.Add do
        begin
          Name := 'item';
          Text := 'text="' + v.Name + ': ' + v.GetFullTypeName;
          if v.IsReadOnly then
            Text := Text + ' = ' + VarToStr(v.Value);
          Text := Text + '"';
        end;
      end;
    end;
  end;

  xi := Item.FindItem('types');
  for i := 0 to xi.Count - 1 do
    if xi[i].Name <> 'item' then
    begin
      xi[i].Text := 'text="' + xi[i].Name + ': (' + xi[i].Text + ')"';
      xi[i].Name := 'item';
    end;
end;

procedure GenerateMembers(Prog: TfsScript; cl: TClass; Item: TfsXMLItem);
var
  i, j: Integer;
  v: TfsCustomVariable;
  c: TfsClassVariable;
  xi: TfsXMLItem;
  clItem: TfsCustomHelper;
  s: String;
begin
  for i := 0 to Prog.Count - 1 do
  begin
    v := Prog.Items[i];
    if v is TfsClassVariable then
    begin
      c := TfsClassVariable(v);
      if cl.InheritsFrom(c.ClassRef) then
      begin
        xi := Item;
        for j := 0 to c.MembersCount - 1 do
        begin
          clItem := c.Members[j];
          with xi.Add do
          begin
            Name := 'item';
            Text := 'text="';
            if clItem is TfsPropertyHelper then
              Text := Text + 'property ' + clItem.Name + ': ' + clItem.GetFullTypeName + '"'
            else if clItem is TfsMethodHelper then
            begin
              s := TfsMethodHelper(clItem).Syntax;
              if TfsMethodHelper(clItem).IndexMethod then
                s := 'index property' + Copy(s, Pos(' ', s), 255);
              Text := Text + s + '"';
            end
            else
              Text := Text + 'event ' + clItem.Name + '"';
          end;
        end;
      end;
    end;
  end;
end;

{$IFNDEF Delphi4}
function fsSetToString(PropInfo: PPropInfo; const Value: Variant): string;
var
  S: TIntegerSet;
  TypeInfo: PTypeInfo;
  I: Integer;
begin
  Result := '';
{$IFNDEF FPC}
  TypeInfo := GetTypeData(PropInfo^.PropType^)^.CompType^;
{$ELSE}
  TypeInfo := GetTypeData(PropInfo^.PropType)^.CompType;
{$ENDIF}

  Integer(S) := 0;
  if VarIsArray(Value) then
    for I := 0 to VarArrayHighBound(Value, 1) do
      begin
        Integer(S) := Integer(S) or Value[I];
      end;

  for I := 0 to SizeOf(Integer) * 8 - 1 do
    if I in S then
    begin
      if Result <> '' then
        Result := Result + ',';
      Result := Result + GetEnumName(TypeInfo, I);
    end;
  Result := '[' + Result + ']';
end;
{$ENDIF}

initialization
  Languages := TStringList.Create;

finalization
  Languages.Free;

end.
