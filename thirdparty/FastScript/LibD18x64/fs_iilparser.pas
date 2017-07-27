
{******************************************}
{                                          }
{             FastScript v1.9              }
{       Intermediate Language parser       }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iilparser;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_iparser, fs_iexpression, fs_xml
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfsEmitOp = (emNone, emCreate, emFree);

{ TfsILParser performs the syntax analyze of source code. Source code
  can be on ANY language. Grammars are stored in the XML file and
  can be easily changed to support any structured language. Currently
  supported languages are Pascal, C++, Basic and Java subsets.

  The result of the analyze (function MakeScript) is the output XML script
  (called Intermediate Language). This output processed by the ParseILScript
  method. This method creates the program structure (defined in the
  fs_Interpreter unit) and fills it by the data }

  TfsILParser = class(TObject)
  private
    FErrorPos: String;
    FGrammar: TfsXMLDocument;
    FILScript: TfsXMLDocument;
    FLangName: String;
    FNeedDeclareVars: Boolean;
    FParser: TfsParser;
    FProgram: TfsScript;
    FProgRoot: TfsXMLItem;
    FRoot: TfsXMLItem;
    FUnitName: String;
    FUsesList: TStrings;
    FWithList: TStringList;
    function PropPos(xi: TfsXMLItem): String;
    procedure ErrorPos(xi: TfsXMLItem);
    procedure CheckIdent(Prog: TfsScript; const Name: String);
    function FindClass(const TypeName: String): TfsClassVariable;
    procedure CheckTypeCompatibility(Var1, Var2: TfsCustomVariable);
    function FindVar(Prog: TfsScript; const Name: String): TfsCustomVariable;
    function FindType(s: String): TfsVarType;
    function CreateVar(xi: TfsXMLItem; Prog: TfsScript; const Name: String;
      Statement: TfsStatement = nil; CreateParam: Boolean = False;
      IsVarParam: Boolean = False): TfsCustomVariable;
    function DoSet(xi: TfsXMLItem; Prog: TfsScript): TfsSetExpression;
    function DoExpression(xi: TfsXMLItem; Prog: TfsScript): TfsExpression;
    procedure DoUses(xi: TfsXMLItem; Prog: TfsScript);
    procedure DoVar(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoConst(xi: TfsXMLItem; Prog: TfsScript);
    procedure DoParameters(xi: TfsXMLItem; v: TfsProcVariable);
    procedure DoProc1(xi: TfsXMLItem; Prog: TfsScript);
    procedure DoProc2(xi: TfsXMLItem; Prog: TfsScript);
    procedure DoFunc1(xi: TfsXMLItem; Prog: TfsScript);
    procedure DoFunc2(xi: TfsXMLItem; Prog: TfsScript);
    procedure DoAssign(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoCall(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoIf(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoFor(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoVbFor(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoCppFor(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoWhile(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoRepeat(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoCase(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoTry(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoBreak(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoContinue(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoExit(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoReturn(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoWith(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoDelete(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoCompoundStmt(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoStmt(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
    procedure DoProgram(xi: TfsXMLItem; Prog: TfsScript);
  public
    constructor Create(AProgram: TfsScript);
    destructor Destroy; override;

    procedure SelectLanguage(const LangName: String);
    { convert the input script to the Intermediate Language }
    function MakeILScript(const Text: String): Boolean;
    { parse IL }
    procedure ParseILScript;
    { this method is needed here to implement late-binding }
    function DoDesignator(xi: TfsXMLItem; Prog: TfsScript;
      EmitOp: TfsEmitOp = emNone): TfsDesignator;
    property ILScript: TfsXMLDocument read FILScript;
  end;


implementation

uses fs_itools, fs_iconst
{$IFDEF CROSS_COMPILE}
, Types
{$ELSE}
, Windows
{$ENDIF}
{$IFDEF OLE}
, fs_idisp
{$ENDIF};


{ TfsILParser }

constructor TfsILParser.Create(AProgram: TfsScript);
begin
  FNeedDeclareVars := True;
  FProgram := AProgram;
  FGrammar := TfsXMLDocument.Create;
  FILScript := TfsXMLDocument.Create;
  FParser := TfsParser.Create;
  FUsesList := TStringList.Create;
  FWithList := TStringList.Create;
end;

destructor TfsILParser.Destroy;
begin
  FGrammar.Free;
  FILScript.Free;
  FParser.Free;
  FUsesList.Free;
  FWithList.Free;
  inherited;
end;

procedure TfsILParser.SelectLanguage(const LangName: String);
var
  i: Integer;
  Name, PropText: String;
  xi: TfsXMLItem;
  ParserRoot: TfsXMLItem;
  ss: TStringStream;
begin
  FParser.Clear;
  FLangName := LangName;
  ss := TStringStream.Create(fsGetLanguage(LangName));
  try
    FGrammar.LoadFromStream(ss);
  finally
    ss.Free;
  end;

  FRoot := FGrammar.Root;
  ParserRoot := FRoot.FindItem('parser');

  xi := ParserRoot.FindItem('keywords');
  for i := 0 to xi.Count - 1 do
    FParser.Keywords.Add(xi[i].Name);
  for i := 0 to ParserRoot.Count - 1 do
  begin
    Name := LowerCase(ParserRoot[i].Name);
    PropText := ParserRoot[i].Prop['text'];
    if Name = 'identchars' then
      FParser.ConstructCharset(PropText)
    else if Name = 'commentline1' then
      FParser.CommentLine1 := PropText
    else if Name = 'commentline2' then
      FParser.CommentLine2 := PropText
    else if Name = 'commentblock1' then
      FParser.CommentBlock1 := PropText
    else if Name = 'commentblock2' then
      FParser.CommentBlock2 := PropText
    else if Name = 'stringquotes' then
      FParser.StringQuotes := PropText
    else if Name = 'hexsequence' then
      FParser.HexSequence := PropText
    else if Name = 'specstrchar' then
    begin
      if PropText = '1' then
        FParser.SpecStrChar := true;
    end
    else if Name = 'declarevars' then
    begin
      if PropText = '0' then
        FNeedDeclareVars := False;
    end
    else if Name = 'skipeol' then
    begin
      if PropText = '0' then
        FParser.SkipEOL := False;
    end
    else if Name = 'skipchar' then
      FParser.SkipChar := PropText
    else if Name = 'casesensitive' then
    begin
      if PropText = '1' then
        FParser.CaseSensitive := True;
    end
  end;

  if FProgram.ExtendedCharset then
    for i := 128 to 255 do
      FParser.IdentifierCharset := FParser.IdentifierCharset + [Chr(i)];
end;

function TfsILParser.MakeILScript(const Text: String): Boolean;
var
  FList: TStrings;
  FStream: TStream;
  FErrorMsg: String;
  FErrorPos: String;
  FTermError: Boolean;
  i: Integer;

  function Run(xi: TfsXMLItem): Boolean;
  var
    i, j, ParsPos, ParsPos1, LoopPos, ListPos: Integer;
    s, NodeName, Token, PropText, PropAdd, PropAddText, PropNode: String;
    Completed, TopLevelNode, Flag: Boolean;
    const
      PathD  = {$IFDEF MSWINDOWS} '\'; {$ELSE} '/'; {$ENDIF}
    procedure DoInclude(const Name: String);
    var
      sl: TStringList;
      p: TfsILParser;
      ss: TStringStream;
      s, UnitPath: String;
      idx: Integer;
    begin
      if FUsesList.IndexOf(Name) <> -1 then
        Exit;
      FUsesList.Add(Name);
      sl := TStringList.Create;
      try
        if Assigned(FProgram.OnGetUnit) then
        begin
          s := '';
          FProgram.OnGetUnit(FProgram, Name, s);
          sl.Text := s;
        end
        else
        begin
          UnitPath := '';
          for idx := 0 to FProgram.IncludePath.Count - 1 do
          begin
            UnitPath := FProgram.IncludePath[idx];
            if (UnitPath <> '') and (PathD <> UnitPath[Length(UnitPath)]) then
              UnitPath := UnitPath + PathD;
            if FileExists(UnitPath + Name) then
              break;
          end;
          sl.LoadFromFile(UnitPath + Name);
        end;

        p := TfsILParser.Create(FProgram);
        p.FUnitName := Name;
        ss := TStringStream.Create(''{$IFDEF Delphi12},TEncoding.UTF8{$ENDIF});
        try
          s := '';
          if sl.Count > 0 then
          begin
            p.SelectLanguage(FLangName);
            p.FUsesList.Assign(FUsesList);
            if p.MakeILScript(sl.Text) then
            begin
              FUsesList.Assign(p.FUsesList);
              p.ILScript.SaveToStream(ss);
              s := ss.DataString;
              Delete(s, 1, Pos('?>', s) + 1);
            end
            else
            begin
              FErrorMsg := FProgram.ErrorMsg;
              FErrorPos := FProgram.ErrorPos;
              if FProgram.ErrorUnit = '' then
                FProgram.ErrorUnit := Name;
            end;
          end;

          FList.Insert(ListPos, '</uses>');
          FList.Insert(ListPos, s);
          FList.Insert(ListPos, '<uses' + ' unit="' + Name + '">');
          Inc(ListPos, 3);
        finally
          p.Free;
          ss.Free;
        end;
      finally
        sl.Free;
      end;
    end;

    procedure CheckPropNode(Flag: Boolean);
    var
      i, ParsPos1: Integer;
      s: String;
    begin
      if CompareText(PropNode, 'uses') = 0 then
      begin
        while FList.Count > ListPos do
        begin
          s := FList[FList.Count - 1];
          i := Pos('text="', s);
          Delete(s, 1, i + 5);
          i := Pos('" ', s);
          Delete(s, i, 255);
          DoInclude(Copy(s, 2, Length(s) - 2));
          FList.Delete(FList.Count - 1);
        end;
      end
      else if PropNode <> '' then
        if Flag then
        begin
          ParsPos1 := FParser.Position;
          FParser.Position := ParsPos;
          FParser.SkipSpaces;

          s := '<' + PropNode + ' pos="' + FParser.GetXYPosition + '"';
          FParser.Position := ParsPos1;

          if PropNode = 'expr' then
            s := s + ' pos1="' + FParser.GetXYPosition + '"';
          s := s + '>';

          FList.Insert(ListPos, s);
          FList.Add('</' + PropNode + '>');
        end
        else
        begin
          while FList.Count > ListPos do
            FList.Delete(FList.Count - 1);
        end;
    end;

    procedure AddError(xi: TfsXMLItem);
    var
      PropErr: String;
      xi1: TfsXMLItem;
    begin
      PropErr := xi.Prop['err'];
      if (PropErr <> '') and (FErrorMsg = '') then
      begin
        xi1 := FRoot.FindItem('parser');
        xi1 := xi1.FindItem('errors');
        FErrorMsg := xi1.FindItem(PropErr).Prop['text'];
        FParser.Position := ParsPos;
        FParser.SkipSpaces;
        FErrorPos := FParser.GetXYPosition;
        FTermError := xi.Prop['term'] = '1';
      end;
    end;

  begin
    Result := True;
    ParsPos := FParser.Position;
    ListPos := FList.Count;
    NodeName := AnsiLowerCase(xi.Name);
    PropText := AnsiLowerCase(xi.Prop['text']);
    PropNode := LowerCase(xi.Prop['node']);
    TopLevelNode := xi.Parent = FRoot;

    Completed := False;
    Flag := False;
    Token := '';

    if TopLevelNode then
      Completed := True
    else if NodeName = 'char' then
    begin
      if xi.Prop['skip'] <> '0' then
        FParser.SkipSpaces;
      Token := FParser.GetChar;
      Flag := True;
    end
    else if NodeName = 'keyword' then
    begin
      Token := FParser.GetWord;
      Flag := True;
    end
    else if NodeName = 'ident' then
    begin
      Token := FParser.GetIdent;
      Flag := True;
    end
    else if NodeName = 'number' then
    begin
      Token := FParser.GetNumber;
      Flag := True;
    end
    else if NodeName = 'string' then
    begin
      Token := FParser.GetString;
      Flag := True;
    end
    else if NodeName = 'frstring' then
    begin
      Token := FParser.GetFRString;
      s := FParser.GetXYPosition;
      FList.Add('<dsgn pos="' + s + '">');
      FList.Add('<node text="Get" pos="' + s + '"/>');
      FList.Add('<expr pos="' + s + '">');
      FList.Add('<string text="''' + StrToXML(Token) + '''" pos="' + s + '"/>');
      FList.Add('</expr>');
      FList.Add('</dsgn>');
      Flag := True;
    end
    else if NodeName = 'eol' then
      Completed := FParser.GetEOL
    else if NodeName = 'sequence' then
      Completed := True
    else if (NodeName = 'switch') or (NodeName = 'optionalswitch') then
    begin
      Completed := True;

      for i := 0 to xi.Count - 1 do
      begin
        Completed := Run(xi[i]);
        if Completed then
          break;
      end;

      if not Completed then
        if NodeName <> 'optionalswitch' then
        begin
          Result := False;
          AddError(xi);
        end;
      Exit;
    end
    else if (NodeName = 'loop') or (NodeName = 'optionalloop') then
    begin
      j := 0;
      repeat
        Inc(j);
        Flag := False;
        LoopPos := FParser.Position;

        for i := 0 to xi.Count - 1 do
        begin
          Result := Run(xi[i]);
          if not Result then
          begin
            Flag := True;
            break;
          end;
        end;

        { try loop delimiter }
        ParsPos1 := FParser.Position;
        if Result and (PropText <> '') then
        begin
          FParser.SkipSpaces;
          if FParser.GetChar <> PropText then
          begin
            FParser.Position := ParsPos1;
            Flag := True;
          end;
        end;

        { avoid infinity loop }
        if FParser.Position = LoopPos then
          Flag := True;
      until Flag;

      { at least one loop was succesful }
      if j > 1 then
      begin
        { special case - now implemented only in "case" statement }
        if (xi.Prop['skip'] = '1') or FTermError then
          FErrorMsg := '';
        FParser.Position := ParsPos1;
        Result := True;
      end;

      if NodeName = 'optionalloop' then
      begin
        if not Result then
          FParser.Position := ParsPos;
        Result := True;
      end;
      Exit;
    end
    else if NodeName = 'optional' then
    begin
      for i := 0 to xi.Count - 1 do
        if not Run(xi[i]) then
        begin
          FParser.Position := ParsPos;
          break;
        end;
      Exit;
    end
    else
    begin
      j := FRoot.Find(NodeName);
      if j = -1 then
        raise Exception.Create(SInvalidLanguage);

      Completed := Run(FRoot[j]);
    end;

    if Flag then
    begin
      if FParser.CaseSensitive then
        Completed := (Token <> '') and
          ((PropText = '') or (Token = PropText))
      else
        Completed := (Token <> '') and
          ((PropText = '') or (AnsiCompareText(Token, PropText) = 0));
    end;

    if not Completed then
    begin
      Result := False;
      AddError(xi);
    end
    else
    begin
      if not TopLevelNode then
        CheckPropNode(True);

      PropAdd := xi.Prop['add'];
      PropAddText := xi.Prop['addtext'];
      if PropAdd <> '' then
      begin
        if PropAddText = '' then
          s := Token else
          s := PropAddText;
        FList.Add('<' + PropAdd + ' text="' + StrToXML(s) + '" pos="' +
          FParser.GetXYPosition + '"/>');
      end;

      for i := 0 to xi.Count - 1 do
      begin
        Result := Run(xi[i]);
        if not Result then
          break;
      end;
    end;

    if not Result then
      FParser.Position := ParsPos;
    if TopLevelNode then
      CheckPropNode(Result);
  end;

begin
  FList := TStringList.Create;
  FErrorMsg := '';
  FErrorPos := '';
  Result := False;

  try
    FParser.Text := Text;

    i := 1;
    if FParser.GetChar = '#' then
    begin
      if CompareText(FParser.GetIdent, 'language') = 0 then
      begin
        i := FParser.Position;
{$IFDEF Windows}
        while (i <= Length(Text)) and (Text[i] <> #13) do
{$ELSE}
        while (i <= Length(Text)) and (Text[i] <> #10) do
{$ENDIF}
          Inc(i);
        SelectLanguage(Trim(Copy(Text, FParser.Position, i - FParser.Position)));
        Inc(i, 2);
      end;
    end;
    FParser.Position := i;

    if Run(FRoot.FindItem('program')) and (FErrorMsg = '') then
    begin
      FErrorMsg := '';
      FErrorPos := '';
      FStream := TMemoryStream.Create;
      try
        FList.Insert(0, '<?xml version="1.0"?>');
        FList.Insert(1, '<program>');
        FList.Add('</program>');
        FList.SaveToStream(FStream{$IFDEF Delphi12}, TEncoding.UTF8{$ENDIF});
{$IFDEF Delphi12}
        FStream.Position := 3;
{$ELSE}
        FStream.Position := 0;
{$ENDIF}
        FILScript.LoadFromStream(FStream);
        FILScript.Root.Add.Assign(FRoot.FindItem('types'));
// uncomment the following lines to see what is IL script
//        FILScript.AutoIndent := True;
//        FILScript.SaveToFile(ExtractFilePath(ParamStr(0)) + 'out.xml');
        Result := True;
      finally
        FStream.Free;
      end;
    end;

    FProgram.ErrorPos := FErrorPos;
    FProgram.ErrorMsg := FErrorMsg;
  finally
    FList.Free;
  end;
end;

procedure TfsILParser.ParseILScript;
begin
  FWithList.Clear;
  FProgram.ErrorUnit := '';
  FUnitName := '';

  try
    DoProgram(FILScript.Root, FProgram);
    FProgram.ErrorPos := '';
  except
    on e: Exception do
    begin
      FProgram.ErrorMsg := e.Message;
      FProgram.ErrorPos := FErrorPos;
      FProgram.ErrorUnit := FUnitName;
    end;
  end;
end;

function TfsILParser.PropPos(xi: TfsXMLItem): String;
begin
  Result := xi.Prop['pos'];
end;

procedure TfsILParser.ErrorPos(xi: TfsXMLItem);
begin
  FErrorPos := PropPos(xi);
end;

procedure TfsILParser.CheckIdent(Prog: TfsScript; const Name: String);
begin
  if Prog.FindLocal(Name) <> nil then
    raise Exception.Create(SIdRedeclared + '''' + Name + '''');
end;

function TfsILParser.FindClass(const TypeName: String): TfsClassVariable;
begin
  Result := FProgram.FindClass(TypeName);
  if Result = nil then
    raise Exception.Create(SUnknownType + '''' + TypeName + '''');
end;

procedure TfsILParser.CheckTypeCompatibility(Var1, Var2: TfsCustomVariable);
begin
  if not AssignCompatible(Var1, Var2, FProgram) then
    raise Exception.Create(SIncompatibleTypes + ': ''' + Var1.GetFullTypeName +
      ''', ''' + Var2.GetFullTypeName + '''');
end;

function TfsILParser.FindVar(Prog: TfsScript; const Name: String): TfsCustomVariable;
begin
  Result := Prog.Find(Name);
  if Result = nil then
    if not FNeedDeclareVars then
    begin
      Result := TfsVariable.Create(Name, fvtVariant, '');
      FProgram.Add(Name, Result);
    end
    else
      raise Exception.Create(SIdUndeclared + '''' + Name + '''');
end;

function TfsILParser.FindType(s: String): TfsVarType;
var
  xi: TfsXMLItem;
begin
  xi := FProgRoot.FindItem('types');
  if xi.Find(s) <> -1 then
    s := xi[xi.Find(s)].Prop['type']
  else
  begin
    xi := FGrammar.Root.FindItem('types');
    if xi.Find(s) <> -1 then
      s := xi[xi.Find(s)].Prop['type']
  end;
  Result := StrToVarType(s, FProgram);
  if Result = fvtClass then
    FindClass(s);
end;

function TfsILParser.CreateVar(xi: TfsXMLItem; Prog: TfsScript; const Name: String;
  Statement: TfsStatement = nil; CreateParam: Boolean = False;
  IsVarParam: Boolean = False): TfsCustomVariable;
var
  i, j: Integer;
  Typ: TfsVarType;
  TypeName: String;
  RefItem: TfsCustomVariable;
  InitValue: Variant;
  InitItem: TfsXMLItem;
  AssignStmt: TfsAssignmentStmt;
  IsPascal: Boolean;
  SourcePos: String;

  procedure DoArray(xi: TfsXMLItem);
  var
    i, n: Integer;
    v: array of Integer;
    Expr: TfsExpression;
  begin
    n := xi.Count;
    SetLength(v, n * 2);

    for i := 0 to n - 1 do
    begin
      Expr := DoExpression(xi[i][0], Prog);
      v[i * 2] := Expr.Value;
      Expr.Free;

      if xi[i].Count = 2 then
      begin
        Expr := DoExpression(xi[i][1], Prog);
        v[i * 2 + 1] := Expr.Value;
        Expr.Free;
      end
      else
      begin
        v[i * 2 + 1] := v[i * 2] - 1;
        v[i * 2] := 0;
      end;
    end;

    if n = 0 then
    begin
      SetLength(v, 2);
      v[0] := 0;
      v[1] := 0;
      n := 1;
    end;

    InitValue := VarArrayCreate(v, varVariant);
    RefItem := TfsArrayHelper.Create('', n, Typ, TypeName);
    Prog.Add('', RefItem);
    v := nil;
    Typ := fvtArray;
  end;

  procedure DoInit(xi: TfsXMLItem);
  var
    Expr: TfsExpression;
    Temp: TfsVariable;
  begin
    Temp := TfsVariable.Create('', Typ, TypeName);
    try
      Expr := DoExpression(xi[0], Prog);
      InitValue := Expr.Value;
      try
        CheckTypeCompatibility(Temp, Expr);
      finally
        Expr.Free;
      end;
    finally
      Temp.Free;
    end;
  end;

begin
  RefItem := nil;
  InitItem := nil;
  TypeName := 'Variant';
  IsPascal := False;
  SourcePos := FErrorPos;

(*
  <var>
    <ident text="ar"/>
    <array>
      <dim>
        <expr/>
        <expr/>
      </dim>
      ...
    </array>
    <type text="String"/>
    <init>
      <expr/>
    </init>
  </var>

  - type may be first (in C-like languages) or last (in Pascal-like ones)
  - type may be skipped (treated as variant)
  - array and init may be either skipped, or after each <ident>
  - array and init may be after each <ident>
  - do not handle <ident> tags - they are handled in calling part
*)


  { find the type }
  for i := 0 to xi.Count - 1 do
    if CompareText(xi[i].name, 'type') = 0 then
    begin
      IsPascal := i <> 0;
      TypeName := xi[i].Prop['text'];
      ErrorPos(xi[i]);
      break;
    end;

  Typ := FindType(TypeName);
  case Typ of
    fvtInt, fvtFloat, fvtClass:
      InitValue := 0;
    fvtBool:
      InitValue := False;
    fvtChar, fvtString:
      InitValue := '';
    else
      InitValue := Null;
  end;

  { fing the <ident> tag corresponding to our variable }
  for i := 0 to xi.Count - 1 do
    if CompareText(xi[i].Prop['text'], Name) = 0 then
    begin
      { process <array> and <init> tags if any }
      j := i + 1;
      while (j < xi.Count) and (IsPascal or (CompareText(xi[j].Name, 'ident') <> 0)) do
      begin
        if CompareText(xi[j].Name, 'array') = 0 then
          DoArray(xi[j])
        else if CompareText(xi[j].Name, 'init') = 0 then
        begin
          if Statement = nil then
            DoInit(xi[j]);
          InitItem := xi[j];
        end;
        Inc(j);
      end;
      break;
    end;

  if CreateParam then
    Result := TfsParamItem.Create(Name, Typ, TypeName, InitItem <> nil, IsVarParam)
  else if Typ in [fvtChar, fvtString] then
    Result := TfsStringVariable.Create(Name, Typ, TypeName) else
    Result := TfsVariable.Create(Name, Typ, TypeName);

  try
    Result.Value := InitValue;
    Result.RefItem := RefItem;
    Result.SourcePos := SourcePos;
    Result.SourceUnit := FUnitName;
    Result.OnGetVarValue := FProgram.OnGetVarValue;

    { create init statement }
    if (InitItem <> nil) and (Statement <> nil) then
    begin
      AssignStmt := TfsAssignmentStmt.Create(Prog, FUnitName, PropPos(xi));
      Statement.Add(AssignStmt);
      AssignStmt.Designator := TfsVariableDesignator.Create(Prog);
      AssignStmt.Designator.RefItem := Result;
      AssignStmt.Expression := DoExpression(InitItem[0], Prog);
      CheckTypeCompatibility(Result, AssignStmt.Expression);
      AssignStmt.Optimize;
    end;

  except
    on e: Exception do
    begin
      Result.Free;
      raise;
    end;
  end;
end;

function TfsILParser.DoDesignator(xi: TfsXMLItem; Prog: TfsScript;
  EmitOp: TfsEmitOp = emNone): TfsDesignator;
var
  i, j: Integer;
  NodeName, NodeText, TypeName: String;
  Expr: TfsExpression;
  Item, PriorItem: TfsDesignatorItem;
  ClassVar: TfsClassVariable;
  StringVar: TfsStringVariable;
  Typ: TfsVarType;
  LateBinding, PriorIsIndex: Boolean;
  NewDesignator: TfsDesignator;
  PriorValue: Variant;
  Component: TComponent;

  function FindInWithList(const Name: String; ResultDS: TfsDesignator;
    Item: TfsDesignatorItem): Boolean;
  var
    i: Integer;
    WithStmt: TfsWithStmt;
    WithItem: TfsDesignatorItem;
    ClassVar: TfsClassVariable;
    xi1: TfsXMLItem;
  begin
    Result := False;
    LateBinding := False;
    for i := FWithList.Count - 1 downto 0 do
    begin
      { prevent checking non-local 'with' }
      if Prog.FindLocal(FWithList[i]) = nil then
        continue;
      WithStmt := TfsWithStmt(FWithList.Objects[i]);

      if WithStmt.Variable.Typ = fvtVariant then
      begin
        { first check all known variables }
        if Prog.Find(Name) <> nil then
          Exit;
        { if nothing found, create late binding information }
        Item.Ref := WithStmt.Variable;
        ResultDS.Finalize;
        ResultDS.LateBindingXMLSource := TfsXMLItem.Create;
        ResultDS.LateBindingXMLSource.Assign(xi);
        xi1 := TfsXMLItem.Create;
        xi1.Name := 'node';
        xi1.Text := 'text="' + FWithList[i] + '"';
        ResultDS.LateBindingXMLSource.InsertItem(0, xi1);
        LateBinding := True;
        Result := True;
        break;
      end
      else
      begin
        ClassVar := FindClass(WithStmt.Variable.TypeName);
        Item.Ref := ClassVar.Find(NodeText);
      end;

      if Item.Ref <> nil then
      begin
        WithItem := TfsDesignatorItem.Create;
        WithItem.Ref := WithStmt.Variable;
        WithItem.SourcePos := Item.SourcePos;

        ResultDS.Remove(Item);
        ResultDS.Add(WithItem);
        ResultDS.Add(Item);
        Result := True;
        break;
      end;
    end;
  end;

{$IFDEF OLE}
  procedure CreateOLEHelpers(Index: Integer);
  var
    i: Integer;
    OLEHelper: TfsOLEHelper;
  begin
    for i := Index to xi.Count - 1 do
    begin
      ErrorPos(xi[i]);
      NodeName := LowerCase(xi[i].Name);
      NodeText := xi[i].Prop['text'];

      if (NodeName = 'node') and (NodeText <> '[') then
      begin
        Item := TfsDesignatorItem.Create;
        Result.Add(Item);
        Item.SourcePos := FErrorPos;
        OLEHelper := TfsOLEHelper.Create(NodeText);
        Prog.Add('', OLEHelper);
        Item.Ref := OLEHelper;
      end
      else if NodeName = 'expr' then
      begin
        Expr := DoExpression(xi[i], Prog);
        PriorItem := Result.Items[Result.Count - 1];
        PriorItem.Add(Expr);
        PriorItem.Ref.Add(TfsParamItem.Create('', fvtVariant, '', False, False));
      end
    end;
  end;
{$ENDIF}

begin
  Result := TfsDesignator.Create(Prog);
  try

    for i := 0 to xi.Count - 1 do
    begin
      ErrorPos(xi[i]);
      NodeName := LowerCase(xi[i].Name);
      NodeText := xi[i].Prop['text'];

      if NodeName = 'node' then
      begin
        Item := TfsDesignatorItem.Create;
        Result.Add(Item);
        Item.SourcePos := FErrorPos;

        if Result.Count = 1 then
        begin
          if not FindInWithList(NodeText, Result, Item) then
            Item.Ref := FindVar(Prog, NodeText);

          { LateBinding flag turned on in the FindInWithList }
          if LateBinding then
            Exit;
          { add .Create for cpp NEW statement, i.e convert o = new TObject
            to o = TObject.Create }
          if EmitOp = emCreate then
          begin
            if not (Item.Ref is TfsClassVariable) then
              raise Exception.Create(SClassRequired);
            ClassVar := TfsClassVariable(Item.Ref);
            Item := TfsDesignatorItem.Create;
            Result.Add(Item);
            Item.Ref := ClassVar.Find('Create');
          end;
        end
        else
        begin
          PriorItem := Result.Items[Result.Count - 2];
          PriorIsIndex := (PriorItem.Ref is TfsMethodHelper) and
            TfsMethodHelper(PriorItem.Ref).IndexMethod and not PriorItem.Flag;
          Typ := PriorItem.Ref.Typ;
          { late binding }
          if (Typ = fvtVariant) and not PriorIsIndex then
          begin
            PriorValue := PriorItem.Ref.Value;
            if VarIsNull(PriorValue) then
            begin
              Result.Remove(Item);
              Item.Free;
              Result.Finalize;
              Result.LateBindingXMLSource := TfsXMLItem.Create;
              Result.LateBindingXMLSource.Assign(xi);
              Exit;
            end
            else
            begin
              if (TVarData(PriorValue).VType = varString) {$IFDEF Delphi12}or (TVarData(PriorValue).VType = varUString){$ENDIF} then
                { accessing string elements }
                Typ := fvtString
  {$IFDEF OLE}
              else if TVarData(PriorValue).VType = varDispatch then
              begin
                { calling ole }
                Result.Remove(Item);
                Item.Free;
                CreateOLEHelpers(i);
                Result.Finalize;
                Exit;
              end
  {$ENDIF}
              else if (TVarData(PriorValue).VType and varArray) = varArray then
              begin
                { accessing array elements }
                if NodeText = '[' then { set ref to arrayhelper }
                  Item.Ref := FindVar(Prog, '__ArrayHelper')
                else
                  raise Exception.Create(SIndexRequired);
                continue;
              end
              else
              begin
                { accessing class items }
                Typ := fvtClass;
                PriorItem.Ref.TypeName := TObject(Integer(PriorItem.Ref.Value)).ClassName;
              end;
            end;
          end;

          if PriorIsIndex then
          begin
            PriorItem.Flag := True;
            Result.Remove(Item); { previous item is set up already }
            Item.Free;
            FErrorPos := PriorItem.SourcePos;
            if NodeText <> '[' then
              raise Exception.Create(SIndexRequired);
          end
          else if Typ = fvtString then
          begin
            if NodeText = '[' then { set ref to stringhelper }
              Item.Ref := FindVar(Prog, '__StringHelper')
            else
              raise Exception.Create(SStringError);
          end
          else if Typ = fvtClass then
          begin
            TypeName := PriorItem.Ref.TypeName;
            ClassVar := FindClass(TypeName);

            if NodeText = '[' then  { default property }
            begin
              Item.Flag := True;
              Item.Ref := ClassVar.DefProperty;
              if Item.Ref = nil then
                raise Exception.CreateFmt(SClassError, [TypeName]);
            end
            else  { property or method }
            begin
              Item.Ref := ClassVar.Find(NodeText);
              { property not found. Probably it's a form element such as button? }
              if Item.Ref = nil then
              begin
                PriorValue := PriorItem.Ref.Value;
                if ((VarIsNull(PriorValue) or (PriorValue = 0)) and not Prog.IsRunning) and Prog.UseClassLateBinding then
                begin
                  { at compile time, we don't know anything about form elements.
                    So clear the designator items and use the late binding. }
                  Result.Remove(Item);
                  Item.Free;
                  while Result.Count > 1 do
                  begin
                    Item := Result.Items[Result.Count - 1];
                    Result.Remove(Item);
                    Item.Free;
                  end;
                  Item := Result.Items[0];
                  Result.Finalize;
                  Result.Typ := fvtVariant;
                  Result.LateBindingXMLSource := TfsXMLItem.Create;
                  Result.LateBindingXMLSource.Assign(xi);
                  Exit;
                end
                else
                begin
                  { we at run time now. Try to search in the form's elements. }
                  if TObject(Integer(PriorValue)) is TComponent then
                  begin
                    Component := TComponent(Integer(PriorValue)).FindComponent(NodeText);
                    if Component <> nil then
                    begin
                      Item.Ref := TfsCustomVariable.Create('', fvtClass, Component.ClassName);
                      Item.Ref.Value := Integer(Component);
                    end;
                  end;
                  if Item.Ref = nil then
                    raise Exception.Create(SIdUndeclared + '''' + NodeText + '''');
                end
              end;
            end;
          end
          else if Typ = fvtArray then { set ref to array helper }
            Item.Ref := PriorItem.Ref.RefItem
          else
            raise Exception.Create(SArrayRequired);
        end;
      end
      else if NodeName = 'expr' then
      begin
        Expr := DoExpression(xi[i], Prog);
        Result.Items[Result.Count - 1].Add(Expr);
      end
      else if NodeName = 'addr' then  { @ operator }
      begin
        if xi.Count <> 2 then
          raise Exception.Create(SVarRequired);

        Item := TfsDesignatorItem.Create;
        Result.Add(Item);
        ErrorPos(xi[1]);
        Item.SourcePos := FErrorPos;

        { we just return the string containing a referenced item name. For
          example, var s: String; procedure B1; begin end; s := @B1
          will assign 'B1' to the s }
        StringVar := TfsStringVariable.Create('', fvtString, '');
        StringVar.Value := xi[1].Prop['text'];
        Prog.Add('', StringVar);
        Item.Ref := StringVar;

        break;
      end;
    end;

    if EmitOp = emFree then
    begin
      PriorItem := Result.Items[Result.Count - 1];
      if (PriorItem.Ref.Typ <> fvtClass) and (PriorItem.Ref.Typ <> fvtVariant) then
        raise Exception.Create(SClassRequired);
      Item := TfsDesignatorItem.Create;
      Result.Add(Item);
      ClassVar := FindClass('TObject');
      Item.Ref := ClassVar.Find('Free');
    end;

    Result.Finalize;
    if Result.Kind <> dkOther then
    begin
      NewDesignator := nil;
      if Result.Kind = dkVariable then
        NewDesignator := TfsVariableDesignator.Create(Prog)
      else if Result.Kind = dkStringArray then
        NewDesignator := TfsStringDesignator.Create(Prog)
      else if Result.Kind = dkArray then
        NewDesignator := TfsArrayDesignator.Create(Prog);

      NewDesignator.Borrow(Result);
      Result.Free;
      Result := NewDesignator;
    end;

    for i := 0 to Result.Count - 1 do
    begin
      Item := Result[i];
      FErrorPos := Item.SourcePos;
      if Item.Ref is TfsDesignator then continue;

      if Item.Count < Item.Ref.GetNumberOfRequiredParams then
        raise Exception.Create(SNotEnoughParams)
      else if Item.Count > Item.Ref.Count then
        raise Exception.Create(STooManyParams)
      else if Item.Count <> Item.Ref.Count then  { construct the default params }
        for j := Item.Count to Item.Ref.Count - 1 do
        begin
          Expr := TfsExpression.Create(FProgram);
          Item.Add(Expr);
          Expr.AddConst(Item.Ref[j].DefValue);
          Expr.Finalize;
        end;

      for j := 0 to Item.Count - 1 do
      begin
        FErrorPos := Item[j].SourcePos;
        CheckTypeCompatibility(Item.Ref[j], Item[j]);
      end;
    end;

  except
    on e: Exception do
    begin
      Result.Free;
      raise;
    end;
  end;
end;

function TfsILParser.DoSet(xi: TfsXMLItem; Prog: TfsScript): TfsSetExpression;
var
  i: Integer;
  Name: String;
begin
  Result := TfsSetExpression.Create('', fvtVariant, '');
  try
    for i := 0 to xi.Count - 1 do
    begin
      Name := LowerCase(xi[i].Name);
      if Name = 'expr' then
        Result.Add(DoExpression(xi[i], Prog))
      else if Name = 'range' then
        Result.Add(nil);
    end;

  except
    on e: Exception do
    begin
      Result.Free;
      raise;
    end;
  end;
end;

function TfsILParser.DoExpression(xi: TfsXMLItem; Prog: TfsScript): TfsExpression;
var
  ErPos: String;
  SourcePos1, SourcePos2: TPoint;

  procedure DoExpressionItems(xi: TfsXMLItem; Expression: TfsExpression);
  var
    i: Integer;
    NodeName: String;
    OpName: String;
  begin
    i := 0;
    while i < xi.Count do
    begin
      ErrorPos(xi[i]);
      Expression.SourcePos := FErrorPos;
      NodeName := Lowercase(xi[i].Name);
      OpName := xi[i].Prop['text'];

      if (NodeName = 'op') then
      begin
        OpName := LowerCase(OpName);
        if (OpName = ')') or (i < xi.Count - 1) then
          Expression.AddOperator(OpName);
      end
      else if (NodeName = 'number') or (NodeName = 'string') then
        Expression.AddConst(ParserStringToVariant(OpName))
      else if NodeName = 'dsgn' then
        Expression.AddDesignator(DoDesignator(xi[i], Prog))
      else if NodeName = 'set' then
        Expression.AddSet(DoSet(xi[i], Prog))
      else if NodeName = 'new' then
        Expression.AddDesignator(DoDesignator(xi[i][0], Prog, emCreate))
      else if NodeName = 'expr' then
        DoExpressionItems(xi[i], Expression);

      Inc(i);
    end;
  end;

  function GetSource(pt1, pt2: TPoint): String;
  var
    i1, i2: Integer;
  begin
    i1 := FParser.GetPlainPosition(pt1);
    i2 := FParser.GetPlainPosition(pt2);
    if (i1 = -1) or (i2 = -1) then
      Result := ''
    else
      Result := Copy(FParser.Text, i1, i2 - i1);
  end;

begin
  Result := TfsExpression.Create(FProgram);
  try
    DoExpressionItems(xi, Result);
    SourcePos1 := fsPosToPoint(PropPos(xi));
    SourcePos2 := fsPosToPoint(xi.Prop['pos1']);
    Result.Source := GetSource(SourcePos1, SourcePos2);

    ErPos := Result.Finalize;
    if ErPos <> '' then
    begin
      FErrorPos := ErPos;
      raise Exception.Create(SIncompatibleTypes);
    end;

  except
    on e: Exception do
    begin
      Result.Free;
      raise;
    end;
  end;
end;

procedure TfsILParser.DoUses(xi: TfsXMLItem; Prog: TfsScript);
var
  i: Integer;
  SaveUnitName: String;
  s: String;
  sl: TStringList;
  ms: TMemoryStream;
  xd: TfsXMLDocument;
begin
  SaveUnitName := FUnitName;
  FUnitName := xi.Prop['unit'];
  xd := nil;

  if Assigned(FProgram.OnGetILUnit) then
  begin
    s := '';
    FProgram.OnGetILUnit(FProgram, FUnitName, s);
    if s <> '' then
    begin
      sl := TStringList.Create;
      sl.Text := s;

      ms := TMemoryStream.Create;
      sl.SaveToStream(ms);
      sl.Free;
      ms.Position := 0;

      xd := TfsXMLDocument.Create;
      xd.LoadFromStream(ms);
      ms.Free;
    end;
  end;

  if xd <> nil then
  begin
    try
      DoProgram(xd.Root, Prog);
    finally
      xd.Free;
    end;
  end
  else
  begin
    for i := 0 to xi.Count - 1 do
      DoProgram(xi[i], Prog);
  end;

  FUnitName := SaveUnitName;
end;

procedure TfsILParser.DoVar(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  i: Integer;
  Name: String;
begin
  for i := 0 to xi.Count - 1 do
  begin
    ErrorPos(xi[i]);
    if CompareText(xi[i].Name, 'ident') = 0 then
    begin
      Name := xi[i].Prop['text'];
      CheckIdent(Prog, Name);
      Prog.Add(Name, CreateVar(xi, Prog, Name, Statement));
    end;
  end;
end;

procedure TfsILParser.DoConst(xi: TfsXMLItem; Prog: TfsScript);
var
  Name: String;
  Expr: TfsExpression;
  v: TfsVariable;
begin
  Name := xi[0].Prop['text'];
  ErrorPos(xi[0]);
  CheckIdent(Prog, Name);

  Expr := DoExpression(xi[1], Prog);
  v := TfsVariable.Create(Name, Expr.Typ, Expr.TypeName);
  v.Value := Expr.Value;
  v.IsReadOnly := True;
  Expr.Free;

  Prog.Add(Name, v);
end;

procedure TfsILParser.DoParameters(xi: TfsXMLItem; v: TfsProcVariable);
var
  i: Integer;
  s: String;
  varParams: Boolean;

  procedure DoParam(xi: TfsXMLItem);
  var
    i: Integer;
    Name: String;
    Param: TfsParamItem;
    varParam: Boolean;
  begin
    varParam := False;

    for i := 0 to xi.Count - 1 do
    begin
      ErrorPos(xi[i]);
      if CompareText(xi[i].Name, 'varparam') = 0 then
        varParam := True
      else if CompareText(xi[i].Name, 'ident') = 0 then
      begin
        Name := xi[i].Prop['text'];
        CheckIdent(v.Prog, Name);
        Param := TfsParamItem(CreateVar(xi, v.Prog, Name, nil, True,
          varParams or VarParam));
        Param.DefValue := Param.Value;
        v.Add(Param);
        v.Prog.Add(Name, Param);
        varParam := False;
      end;
    end;
  end;

begin
  if CompareText(xi.Name, 'parameters') <> 0 then Exit;
  varParams := False;
  for i := 0 to xi.Count - 1 do
  begin
    s := LowerCase(xi[i].Name);
    if s = 'varparams' then
      varParams := True
    else if s = 'var' then
    begin
      DoParam(xi[i]);
      varParams := False;
    end;
  end;
end;

procedure TfsILParser.DoProc1(xi: TfsXMLItem; Prog: TfsScript);
var
  i: Integer;
  s, Name: String;
  Proc: TfsProcVariable;
begin
  ErrorPos(xi[0]);
  Name := xi[0].Prop['text'];
  CheckIdent(Prog, Name);

  Proc := TfsProcVariable.Create(Name, fvtInt, '', Prog, False);
  Proc.SourcePos := PropPos(xi);
  Proc.SourceUnit := FUnitName;
  Prog.Add(Name, Proc);

  for i := 0 to xi.Count - 1 do
  begin
    s := LowerCase(xi[i].Name);
    if s = 'parameters' then
      DoParameters(xi[i], Proc);
  end;
end;

procedure TfsILParser.DoProc2(xi: TfsXMLItem; Prog: TfsScript);
var
  Name: String;
  Proc: TfsProcVariable;
begin
  Name := xi[0].Prop['text'];
  Proc := TfsProcVariable(FindVar(Prog, Name));
  DoProgram(xi, Proc.Prog);
end;

procedure TfsILParser.DoFunc1(xi: TfsXMLItem; Prog: TfsScript);
var
  i: Integer;
  s, Name, TypeName: String;
  Typ: TfsVarType;
  Func: TfsProcVariable;
begin
  Name := '';
  TypeName := '';
  Typ := fvtVariant;

  for i := 0 to xi.Count - 1 do
  begin
    ErrorPos(xi[i]);
    s := LowerCase(xi[i].Name);
    if s = 'type' then
    begin
      TypeName := xi[i].Prop['text'];
      Typ := FindType(TypeName);
    end
    else if s = 'name' then
    begin
      Name := xi[i].Prop['text'];
      CheckIdent(Prog, Name);
    end
  end;


  Func := TfsProcVariable.Create(Name, Typ, TypeName, Prog,
    CompareText(TypeName, 'void') <> 0);
  Func.SourcePos := PropPos(xi);
  Func.SourceUnit := FUnitName;
  Prog.Add(Name, Func);

  for i := 0 to xi.Count - 1 do
  begin
    s := LowerCase(xi[i].Name);
    if s = 'parameters' then
      DoParameters(xi[i], Func);
  end;
end;

procedure TfsILParser.DoFunc2(xi: TfsXMLItem; Prog: TfsScript);
var
  i: Integer;
  s, Name: String;
  Func: TfsProcVariable;
begin
  Name := '';

  for i := 0 to xi.Count - 1 do
  begin
    s := LowerCase(xi[i].Name);
    if s = 'name' then
      Name := xi[i].Prop['text'];
  end;

  Func := TfsProcVariable(FindVar(Prog, Name));
  DoProgram(xi, Func.Prog);
end;

procedure TfsILParser.DoAssign(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  i: Integer;
  Stmt: TfsAssignmentStmt;
  Designator: TfsDesignator;
  Expression: TfsExpression;
  Modificator: String;
begin
  Designator := nil;
  Expression := nil;

  try
    Modificator := ' ';
    Designator := DoDesignator(xi[0], Prog);

    i := 1;
    if CompareText(xi[1].Name, 'modificator') = 0 then
    begin
      Modificator := xi[1].Prop['text'];
      Inc(i);
    end;
    Expression := DoExpression(xi[i], Prog);

    if Designator.IsReadOnly then
      raise Exception.Create(SLeftCantAssigned);

    CheckTypeCompatibility(Designator, Expression);
    if Modificator = ' ' then
      Modificator := Expression.Optimize(Designator);
  except
    on e: Exception do
    begin
      if Designator <> nil then
        Designator.Free;
      if Expression <> nil then
        Expression.Free;
      raise;
    end;
  end;

  case Modificator[1] of
    '+':
      Stmt := TfsAssignPlusStmt.Create(Prog, FUnitName, PropPos(xi));
    '-':
      Stmt := TfsAssignMinusStmt.Create(Prog, FUnitName, PropPos(xi));
    '*':
      Stmt := TfsAssignMulStmt.Create(Prog, FUnitName, PropPos(xi));
    '/':
      Stmt := TfsAssignDivStmt.Create(Prog, FUnitName, PropPos(xi));
    else
      Stmt := TfsAssignmentStmt.Create(Prog, FUnitName, PropPos(xi));
  end;

  Statement.Add(Stmt);
  Stmt.Designator := Designator;
  Stmt.Expression := Expression;
  Stmt.Optimize;
  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoCall(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  Stmt: TfsCallStmt;
begin
  Stmt := TfsCallStmt.Create(Prog, FUnitName, PropPos(xi));
  Statement.Add(Stmt);
  Stmt.Designator := DoDesignator(xi[0], Prog);
  if xi.Count > 1 then
  begin
    Stmt.Modificator := xi[1].Prop['text'];
    if Stmt.Designator.IsReadOnly then
      raise Exception.Create(SLeftCantAssigned);
  end;

  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoIf(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  i: Integer;
  s: String;
  Stmt: TfsIfStmt;
begin
  Stmt := TfsIfStmt.Create(Prog, FUnitName, PropPos(xi));
  Statement.Add(Stmt);
  Stmt.Condition := DoExpression(xi[0], Prog);

  for i := 1 to xi.Count - 1 do
  begin
    s := Lowercase(xi[i].Name);
    if s = 'thenstmt' then
      DoCompoundStmt(xi[1], Prog, Stmt)
    else if s = 'elsestmt' then
      DoCompoundStmt(xi[2], Prog, Stmt.ElseStmt);
  end;

  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoFor(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  i: Integer;
  Stmt: TfsForStmt;
begin
  Stmt := TfsForStmt.Create(Prog, FUnitName, PropPos(xi));
  Statement.Add(Stmt);
  ErrorPos(xi[0]);
  Stmt.Variable := FindVar(Prog, xi[0].Prop['text']);
  if not ((Stmt.Variable is TfsVariable) and
    (Stmt.Variable.Typ in [fvtInt, fvtVariant, fvtFloat])) then
    raise Exception.Create(SForError);

  Stmt.BeginValue := DoExpression(xi[1], Prog);
  CheckTypeCompatibility(Stmt.Variable, Stmt.BeginValue);

  i := 2;
  if CompareText(xi[2].Name, 'downto') = 0 then
  begin
    Stmt.Down := True;
    Inc(i);
  end;

  Stmt.EndValue := DoExpression(xi[i], Prog);
  CheckTypeCompatibility(Stmt.Variable, Stmt.EndValue);
  if i + 1 < xi.Count then
    DoStmt(xi[i + 1], Prog, Stmt);

  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoVbFor(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  i: Integer;
  Stmt: TfsVbForStmt;
begin
  Stmt := TfsVbForStmt.Create(Prog, FUnitName, PropPos(xi));
  Statement.Add(Stmt);
  ErrorPos(xi[0]);
  Stmt.Variable := FindVar(Prog, xi[0].Prop['text']);
  if not ((Stmt.Variable is TfsVariable) and
    (Stmt.Variable.Typ in [fvtInt, fvtVariant, fvtFloat])) then
    raise Exception.Create(SForError);

  Stmt.BeginValue := DoExpression(xi[1], Prog);
  CheckTypeCompatibility(Stmt.Variable, Stmt.BeginValue);

  Stmt.EndValue := DoExpression(xi[2], Prog);
  CheckTypeCompatibility(Stmt.Variable, Stmt.EndValue);

  i := 3;
  if i < xi.Count then
    if CompareText(xi[i].Name, 'expr') = 0 then
    begin
      Stmt.Step := DoExpression(xi[i], Prog);
      CheckTypeCompatibility(Stmt.Variable, Stmt.Step);
      Inc(i);
    end;

  if i < xi.Count then
    DoStmt(xi[i], Prog, Stmt);

  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoCppFor(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  Stmt: TfsCppForStmt;
begin
  Stmt := TfsCppForStmt.Create(Prog, FUnitName, PropPos(xi));
  Statement.Add(Stmt);
  DoStmt(xi[0], Prog, Stmt.FirstStmt);
  Stmt.Expression := DoExpression(xi[1], Prog);
  DoStmt(xi[2], Prog, Stmt.SecondStmt);
  DoStmt(xi[3], Prog, Stmt);

  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoWhile(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  Stmt: TfsWhileStmt;
begin
  Stmt := TfsWhileStmt.Create(Prog, FUnitName, PropPos(xi));
  Statement.Add(Stmt);
  Stmt.Condition := DoExpression(xi[0], Prog);
  if xi.Count > 1 then
    DoStmt(xi[1], Prog, Stmt);

  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoRepeat(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  i, j: Integer;
  Stmt: TfsRepeatStmt;
begin
  Stmt := TfsRepeatStmt.Create(Prog, FUnitName, PropPos(xi));
  Statement.Add(Stmt);

  j := xi.Count - 1;
  if CompareText(xi[j].Name, 'inverse') = 0 then
  begin
    Stmt.InverseCondition := True;
    Dec(j);
  end;
  Stmt.Condition := DoExpression(xi[j], Prog);
  Dec(j);

  for i := 0 to j do
    DoStmt(xi[i], Prog, Stmt);

  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoCase(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  i: Integer;
  Stmt: TfsCaseStmt;

  procedure DoCaseSelector(xi: TfsXMLItem);
  var
    Selector: TfsCaseSelector;
  begin
    if (CompareText(xi.Name, 'caseselector') <> 0) or (xi.Count <> 2) then Exit;
    Selector := TfsCaseSelector.Create(Prog, FUnitName, PropPos(xi));
    Stmt.Add(Selector);

    Selector.SetExpression := DoSet(xi[0], Prog);
    DoStmt(xi[1], Prog, Selector);
  end;

begin
  Stmt := TfsCaseStmt.Create(Prog, FUnitName, PropPos(xi));
  Statement.Add(Stmt);
  Stmt.Condition := DoExpression(xi[0], Prog);

  for i := 1 to xi.Count - 1 do
    DoCaseSelector(xi[i]);
  if CompareText(xi[xi.Count - 1].Name, 'caseselector') <> 0 then
    DoStmt(xi[xi.Count - 1], Prog, Stmt.ElseStmt);

  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoTry(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  i: Integer;
  Stmt: TfsTryStmt;
begin
  Stmt := TfsTryStmt.Create(Prog, FUnitName, PropPos(xi));
  Statement.Add(Stmt);

  for i := 0 to xi.Count - 1 do
    if CompareText(xi[i].Name, 'exceptstmt') = 0 then
    begin
      Stmt.IsExcept := True;
      DoCompoundStmt(xi[i], Prog, Stmt.ExceptStmt);
    end
    else if CompareText(xi[i].Name, 'finallystmt') = 0 then
      DoCompoundStmt(xi[i], Prog, Stmt.ExceptStmt)
    else
      DoStmt(xi[i], Prog, Stmt);

  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoBreak(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  Stmt: TfsBreakStmt;
begin
  Stmt := TfsBreakStmt.Create(Prog, FUnitName, PropPos(xi));
  Statement.Add(Stmt);
  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoContinue(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  Stmt: TfsContinueStmt;
begin
  Stmt := TfsContinueStmt.Create(Prog, FUnitName, PropPos(xi));
  Statement.Add(Stmt);
  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoExit(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  Stmt: TfsExitStmt;
begin
  Stmt := TfsExitStmt.Create(Prog, FUnitName, PropPos(xi));
  Statement.Add(Stmt);
  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoReturn(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  xi1: TfsXMLItem;
begin
  if xi.Count = 1 then { "return expr" }
  begin
    xi1 := TfsXMLItem.Create;
    xi1.Name := 'dsgn';
    xi.InsertItem(0, xi1);
    with xi1.Add do
    begin
      Name := 'node';
      Text := 'text="Result" pos="' + xi[1].Prop['pos'] + '"';
    end;

    DoAssign(xi, Prog, Statement);
  end;

  DoExit(xi, Prog, Statement);
end;

procedure TfsILParser.DoWith(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  d: TfsDesignator;
  i, n: Integer;
  s: String;
  v: TfsVariable;
  Stmt: TfsWithStmt;

  function CreateUniqueVariable: String;
  var
    i: Integer;
  begin
    i := 0;
    while (Prog.FindLocal(IntToStr(i)) <> nil) or
      (FWithList.IndexOf(IntToStr(i)) <> -1) do
      Inc(i);
    Result := '_WithList_' + IntToStr(i);
  end;

begin
  n := xi.Count - 1;

  for i := 0 to n - 1 do
  begin
    d := DoDesignator(xi[i], Prog);
    if not ((d.Typ = fvtClass) or (d.Typ = fvtVariant)) then
    begin
      d.Free;
      raise Exception.Create(SClassRequired);
    end;

    { create local variable with unique name }
    s := CreateUniqueVariable;
    v := TfsVariable.Create(s, d.Typ, d.TypeName);
    Prog.Add(s, v);

    Stmt := TfsWithStmt.Create(Prog, FUnitName, PropPos(xi));
    Stmt.Variable := v;
    Stmt.Designator := d;
    Statement.Add(Stmt);
    FWithList.AddObject(s, Stmt);
  end;

  DoStmt(xi[xi.Count - 1], Prog, Statement);

  for i := 0 to n - 1 do
    FWithList.Delete(FWithList.Count - 1);
  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoDelete(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  Stmt: TfsCallStmt;
begin
  Stmt := TfsCallStmt.Create(Prog, FUnitName, PropPos(xi));
  Statement.Add(Stmt);
  Stmt.Designator := DoDesignator(xi[0], Prog, emFree);
  FProgram.AddCodeLine(FUnitName, PropPos(xi));
end;

procedure TfsILParser.DoCompoundStmt(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  i: Integer;
begin
  for i := 0 to xi.Count - 1 do
    DoStmt(xi[i], Prog, Statement);
end;

procedure TfsILParser.DoStmt(xi: TfsXMLItem; Prog: TfsScript; Statement: TfsStatement);
var
  s: String;
begin
  s := LowerCase(xi.Name);
  if s = 'assignstmt' then
    DoAssign(xi, Prog, Statement)
  else if s = 'callstmt' then
    DoCall(xi, Prog, Statement)
  else if s = 'ifstmt' then
    DoIf(xi, Prog, Statement)
  else if s = 'casestmt' then
    DoCase(xi, Prog, Statement)
  else if s = 'forstmt' then
    DoFor(xi, Prog, Statement)
  else if s = 'vbforstmt' then
    DoVbFor(xi, Prog, Statement)
  else if s = 'cppforstmt' then
    DoCppFor(xi, Prog, Statement)
  else if s = 'whilestmt' then
    DoWhile(xi, Prog, Statement)
  else if s = 'repeatstmt' then
    DoRepeat(xi, Prog, Statement)
  else if s = 'trystmt' then
    DoTry(xi, Prog, Statement)
  else if s = 'break' then
    DoBreak(xi, Prog, Statement)
  else if s = 'continue' then
    DoContinue(xi, Prog, Statement)
  else if s = 'exit' then
    DoExit(xi, Prog, Statement)
  else if s = 'return' then
    DoReturn(xi, Prog, Statement)
  else if s = 'with' then
    DoWith(xi, Prog, Statement)
  else if s = 'delete' then
    DoDelete(xi, Prog, Statement)
  else if s = 'compoundstmt' then
    DoCompoundStmt(xi, Prog, Statement)
  else if s = 'uses' then
    DoUses(xi, Prog)
  else if s = 'var' then
    DoVar(xi, Prog, Statement)
  else if s = 'const' then
    DoConst(xi, Prog)
  else if s = 'procedure' then
    DoProc2(xi, Prog)
  else if s = 'function' then
    DoFunc2(xi, Prog)
end;

procedure TfsILParser.DoProgram(xi: TfsXMLItem; Prog: TfsScript);
var
  TempRoot: TfsXMLItem;

  procedure DoFirstPass(xi: TfsXMLItem);
  var
    i: Integer;
    s: String;
  begin
    for i := 0 to xi.Count - 1 do
    begin
      s := LowerCase(xi[i].Name);
      if s = 'compoundstmt' then
        DoFirstPass(xi[i])
      else if s = 'procedure' then
        DoProc1(xi[i], Prog)
      else if s = 'function' then
        DoFunc1(xi[i], Prog)
    end;
  end;

begin
  TempRoot := FProgRoot;
  FProgRoot := xi;
  DoFirstPass(xi);
  DoCompoundStmt(xi, Prog, Prog.Statement);
  FProgRoot := TempRoot;
end;


end.
