
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Expression parser             }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iexpression;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  { List of operators }

  TfsOperatorType = (opNone, opGreat, opLess, opLessEq, opGreatEq, opNonEq, opEq,
    opPlus, opMinus, opOr, opXor, opMul, opDivFloat, opDivInt, opMod, opAnd,
    opShl, opShr, opLeftBracket, opRightBracket, opNot, opUnMinus, opIn, opIs);

{ TfsExpression class holds a list of operands and operators.
  List is represented in the tree form.
  Call to methods AddXXX puts an expression element to the list.
  Call to function Value calculates and returns the expression value }

  TfsExpressionNode = class(TfsCustomVariable)
  private
    FLeft, FRight, FParent: TfsExpressionNode;
    procedure AddNode(Node: TfsExpressionNode);
    procedure RemoveNode(Node: TfsExpressionNode);
  public
    destructor Destroy; override;
    function Priority: Integer; virtual; abstract;
  end;

  TfsOperandNode = class(TfsExpressionNode)
  public
    constructor Create(const AValue: Variant);
    function Priority: Integer; override;
  end;

  TfsOperatorNode = class(TfsExpressionNode)
  private
    FOp: TfsOperatorType;
    FOptimizeInt: Boolean;
    FOptimizeBool: Boolean;
  public
    constructor Create(Op: TfsOperatorType);
    function Priority: Integer; override;
  end;

  TfsDesignatorNode = class(TfsOperandNode)
  private
    FDesignator: TfsDesignator;
    FVar: TfsCustomVariable;
  protected
    function GetValue: Variant; override;
  public
    constructor Create(ADesignator: TfsDesignator);
    destructor Destroy; override;
  end;

  TfsSetNode = class(TfsOperandNode)
  private
    FSetExpression: TfsSetExpression;
  protected
    function GetValue: Variant; override;
  public
    constructor Create(ASet: TfsSetExpression);
    destructor Destroy; override;
  end;

  TfsExpression = class(TfsCustomExpression)
  private
    FCurNode: TfsExpressionNode;
    FNode: TfsExpressionNode;
    FScript: TfsScript;
    FSource: String;
    procedure AddOperand(Node: TfsExpressionNode);
  protected
    function GetValue: Variant; override;
    procedure SetValue(const Value: Variant); override;
  public
    constructor Create(Script: TfsScript);
    destructor Destroy; override;
    procedure AddConst(const AValue: Variant);
    procedure AddDesignator(ADesignator: TfsDesignator);
    procedure AddOperator(const Op: String);
    procedure AddSet(ASet: TfsSetExpression);

    function Finalize: String;
    function Optimize(Designator: TfsDesignator): String;
    function SingleItem: TfsCustomVariable;

    property Source: String read FSource write FSource;
  end;


implementation

uses fs_itools;

type
  TNoneNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TGreatNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TLessNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TLessEqNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TGreatEqNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TNonEqNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TEqNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TPlusNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TStrCatNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TMinusNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TOrNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TXorNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TMulNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TDivFloatNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TDivIntNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TModNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TAndNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TShlNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TShrNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TLeftBracketNode = class(TfsOperatorNode);

  TRightBracketNode = class(TfsOperatorNode);

  TNotNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TUnMinusNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TInNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;

  TIsNode = class(TfsOperatorNode)
  protected
    function GetValue: Variant; override;
  end;


function TNoneNode.GetValue: Variant;
begin
  Result := FLeft.Value;
end;

function TGreatNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  Result := Result > FRight.Value;
end;

function TLessNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  Result := Result < FRight.Value;
end;

function TLessEqNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  Result := Result <= FRight.Value;
end;

function TGreatEqNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  Result := Result >= FRight.Value;
end;

function TNonEqNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  Result := Result <> FRight.Value;
end;

function TEqNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  Result := Result = FRight.Value;
end;

function TPlusNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  Result := Result + FRight.Value;
end;

function TStrCatNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  if (TVarData(Result).VType = varString){$IFDEF Delphi12} or (TVarData(Result).VType = varUString){$ENDIF} then
    Result := VarToStr(Result) + VarToStr(FRight.Value) else
    Result := Result + FRight.Value;
end;

function TMinusNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  if FOptimizeInt then
    Result := Integer(Result) - Integer(FRight.Value)
  else
    Result := Result - FRight.Value;
end;

function TOrNode.GetValue: Variant;
begin
  Result := FLeft.Value;

  if FOptimizeBool then
  begin
    if Boolean(Result) = False then
      Result := FRight.Value;
  end
  else
    Result := Result or FRight.Value;
end;

function TXorNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  Result := Result xor FRight.Value;
end;

function TMulNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  if FOptimizeInt then
    Result := Integer(Result) * Integer(FRight.Value)
  else
    Result := Result * FRight.Value;
end;

function TDivFloatNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  Result := Result / FRight.Value;
end;

function TDivIntNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  if FOptimizeInt then
    Result := Integer(Result) div Integer(FRight.Value)
  else
    Result := Result div FRight.Value;
end;

function TModNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  if FOptimizeInt then
    Result := Integer(Result) mod Integer(FRight.Value)
  else
    Result := Result mod FRight.Value;
end;

function TAndNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  if FOptimizeBool then
  begin
    if Boolean(Result) = True then
      Result := FRight.Value;
  end
  else
    Result := Result and FRight.Value;
end;

function TShlNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  Result := Result shl FRight.Value;
end;

function TShrNode.GetValue: Variant;
begin
  Result := FLeft.Value;
  Result := Result shr FRight.Value;
end;

function TNotNode.GetValue: Variant;
begin
  Result := not FLeft.Value;
end;

function TUnMinusNode.GetValue: Variant;
begin
  Result := -FLeft.Value;
end;

function TInNode.GetValue: Variant;
var
  i: Integer;
  ar, val, selfVal: Variant;
  Count: Integer;
begin
  if FRight is TfsSetNode then
    Result := TfsSetNode(FRight).FSetExpression.Check(FLeft.Value)
  else
  begin
    Result := False;
    ar := FRight.Value;
    Count := VarArrayHighBound(ar, 1);
    selfVal := FLeft.Value;

    i := 0;
    while i <= Count do
    begin
      val := ar[i];
      Result := selfVal = val;
      if (i < Count - 1) and (ar[i + 1] = Null) and not Result then { subrange }
      begin
        Result := (selfVal >= val) and (selfVal <= ar[i + 2]);
        Inc(i, 2);
      end;

      if Result then break;
      Inc(i);
    end;
  end;
end;

function TIsNode.GetValue: Variant;
begin
  Result := TObject(Integer(FLeft.Value)) is
    TfsClassVariable(TfsDesignatorNode(FRight).FDesignator[0].Ref).ClassRef;
end;


{ TfsExpressionNode }

destructor TfsExpressionNode.Destroy;
begin
  FLeft.Free;
  FRight.Free;
  inherited;
end;

procedure TfsExpressionNode.AddNode(Node: TfsExpressionNode);
begin
  if FLeft = nil then
    FLeft := Node
  else if FRight = nil then
    FRight := Node;
  if Node <> nil then
    Node.FParent := Self;
end;

procedure TfsExpressionNode.RemoveNode(Node: TfsExpressionNode);
begin
  if FLeft = Node then
    FLeft := nil
  else if FRight = Node then
    FRight := nil;
end;


{ TfsOperandNode }

constructor TfsOperandNode.Create(const AValue: Variant);
var
  t: TfsVarType;
begin
  inherited Create('', fvtInt, '');
  Value := AValue;

  t := fvtInt;
  if TVarData(AValue).VType = varBoolean then
    t := fvtBool
  else if TVarData(AValue).VType in [varSingle, varDouble, varCurrency] then
    t := fvtFloat
  else if (TVarData(AValue).VType = varOleStr) or
    (TVarData(AValue).VType = varString){$IFDEF Delphi12} or (TVarData(AValue).VType = varUString){$ENDIF} then
    t := fvtString;

  Typ := t;
end;

function TfsOperandNode.Priority: Integer;
begin
  Result := 0;
end;


{ TfsOperatorNode }

constructor TfsOperatorNode.Create(Op: TfsOperatorType);
begin
  inherited Create('', fvtInt, '');
  FOp := Op;
end;

function TfsOperatorNode.Priority: Integer;
begin
  case FOp of
    opNone:
      Result := 7;
    opLeftBracket:
      Result := 6;
    opRightBracket:
      Result := 5;
    opGreat, opLess, opGreatEq, opLessEq, opNonEq, opEq, opIn, opIs:
      Result := 4;
    opPlus, opMinus, opOr, opXor:
      Result := 3;
    opMul, opDivFloat, opDivInt, opMod, opAnd, opShr, opShl:
      Result := 2;
    opNot, opUnMinus:
      Result := 1;
    else
      Result := 0;
  end;
end;


{ TfsDesignatorNode }

constructor TfsDesignatorNode.Create(ADesignator: TfsDesignator);
begin
  inherited Create(0);
  FDesignator := ADesignator;
  Typ := ADesignator.Typ;
  TypeName := ADesignator.TypeName;
  if FDesignator is TfsVariableDesignator then
    FVar := FDesignator.RefItem else
    FVar := FDesignator;
end;

destructor TfsDesignatorNode.Destroy;
begin
  FDesignator.Free;
  inherited;
end;

function TfsDesignatorNode.GetValue: Variant;
begin
  Result := FVar.Value;
end;


{ TfsSetNode }

constructor TfsSetNode.Create(ASet: TfsSetExpression);
begin
  inherited Create(0);
  FSetExpression := ASet;
  Typ := fvtVariant;
end;

destructor TfsSetNode.Destroy;
begin
  FSetExpression.Free;
  inherited;
end;

function TfsSetNode.GetValue: Variant;
begin
  Result := FSetExpression.Value;
end;


{ TfsExpression }

constructor TfsExpression.Create(Script: TfsScript);
begin
  inherited Create('', fvtInt, '');
  FNode := TNoneNode.Create(opNone);
  FCurNode := FNode;
  FScript := Script;
end;

destructor TfsExpression.Destroy;
begin
  FNode.Free;
  inherited;
end;

function TfsExpression.GetValue: Variant;
begin
  Result := FNode.Value;
end;

procedure TfsExpression.AddOperand(Node: TfsExpressionNode);
begin
  FCurNode.AddNode(Node);
  FCurNode := Node;
end;

procedure TfsExpression.AddOperator(const Op: String);
var
  Node: TfsExpressionNode;
  n, n1: TfsExpressionNode;

  function CreateOperatorNode(s: String): TfsOperatorNode;
  begin
    s := AnsiUpperCase(s);
    if s = ' ' then
      Result := TNoneNode.Create(opNone)
    else if s = '>' then
      Result := TGreatNode.Create(opGreat)
    else if s = '<' then
      Result := TLessNode.Create(opLess)
    else if s = '<=' then
      Result := TLessEqNode.Create(opLessEq)
    else if s = '>=' then
      Result := TGreatEqNode.Create(opGreatEq)
    else if s = '<>' then
      Result := TNonEqNode.Create(opNonEq)
    else if s = '=' then
      Result := TEqNode.Create(opEq)
    else if s = '+' then
      Result := TPlusNode.Create(opPlus)
    else if s = 'STRCAT' then
      Result := TStrCatNode.Create(opPlus)
    else if s = '-' then
      Result := TMinusNode.Create(opMinus)
    else if s = 'OR' then
      Result := TOrNode.Create(opOr)
    else if s = 'XOR' then
      Result := TXorNode.Create(opXor)
    else if s = '*' then
      Result := TMulNode.Create(opMul)
    else if s = '/' then
      Result := TDivFloatNode.Create(opDivFloat)
    else if s = 'DIV' then
      Result := TDivIntNode.Create(opDivInt)
    else if s = 'MOD' then
      Result := TModNode.Create(opMod)
    else if s = 'AND' then
      Result := TAndNode.Create(opAnd)
    else if s = 'SHL' then
      Result := TShlNode.Create(opShl)
    else if s = 'SHR' then
      Result := TShrNode.Create(opShr)
    else if s = '(' then
      Result := TLeftBracketNode.Create(opLeftBracket)
    else if s = ')' then
      Result := TRightBracketNode.Create(opRightBracket)
    else if s = 'NOT' then
      Result := TNotNode.Create(opNot)
    else if s = 'UNMINUS' then
      Result := TUnMinusNode.Create(opUnMinus)
    else if s = 'IN' then
      Result := TInNode.Create(opIn)
    else if s = 'IS' then
      Result := TIsNode.Create(opIs)
    else
      Result := nil;
  end;

begin
  Node := CreateOperatorNode(Op);
  Node.SourcePos := SourcePos;

  if (Op = '(') or (Op = 'unminus') or (Op = 'not') then
    AddOperand(Node)
  else if Op = ')' then
  begin
    n := FCurNode;
    while n.Priority <= Node.Priority do
      n := n.FParent;

    n.FParent.RemoveNode(n);
    n.FParent.AddNode(n.FLeft);

    Node.Free;
    Node := n.FLeft;
    n.FLeft := nil;
    n.Free;
  end
  else if FCurNode = FNode then
    FNode.AddNode(Node)
  else
  begin
    n := FCurNode;
    n1 := nil;
    if FCurNode.Priority <> 6 then
    begin
      n := FCurNode.FParent;
      n1 := FCurNode;
    end;

    while n.Priority <= Node.Priority do
    begin
      n1 := n;
      n := n.FParent;
    end;

    n.RemoveNode(n1);
    n.AddNode(Node);
    Node.AddNode(n1);
  end;

  FCurNode := Node;
end;

procedure TfsExpression.AddConst(const AValue: Variant);
var
  Node: TfsOperandNode;
begin
  Node := TfsOperandNode.Create(AValue);
  Node.SourcePos := SourcePos;
  AddOperand(Node);
end;

procedure TfsExpression.AddDesignator(ADesignator: TfsDesignator);
var
  Node: TfsDesignatorNode;
begin
  Node := TfsDesignatorNode.Create(ADesignator);
  Node.SourcePos := SourcePos;
  AddOperand(Node);
end;

procedure TfsExpression.AddSet(ASet: TfsSetExpression);
var
  Node: TfsSetNode;
begin
  Node := TfsSetNode.Create(ASet);
  Node.SourcePos := SourcePos;
  AddOperand(Node);
end;

function TfsExpression.Finalize: String;
var
  ErrorPos: String;
  TypeRec: TfsTypeRec;

  function GetType(Item: TfsExpressionNode): TfsTypeRec;
  var
    Typ1, Typ2: TfsTypeRec;
    op: TfsOperatorType;
    Error: Boolean;
  begin
    if Item = nil then
      Result.Typ := fvtVariant
    else if Item is TfsOperandNode then
    begin
      Result.Typ := Item.Typ;
      Result.TypeName := Item.TypeName;
    end
    else
    begin
      Typ1 := GetType(Item.FLeft);
      Typ2 := GetType(Item.FRight);
//      if (Typ1.Typ = fvtInt) and (Typ2.Typ = fvtInt) then
//        TfsOperatorNode(Item).FOptimizeInt := True;
      if (Typ1.Typ = fvtBool) and (Typ2.Typ = fvtBool) then
        TfsOperatorNode(Item).FOptimizeBool := True;

      op := TfsOperatorNode(Item).FOp;

      if (op = opIs) and (Typ1.Typ = fvtClass) and (Typ2.Typ = fvtClass) then
        Error := False
      else
      begin
        { check types compatibility }
        Error := not TypesCompatible(Typ1, Typ2, FScript);
        { check operators applicability }
        if not Error then
          case Typ1.Typ of
            fvtBool:
              Error := not (op in [opNonEq, opEq, opOr, opXor, opAnd, opNot]);
            fvtChar, fvtString:
              Error := not (op in [opGreat, opLess, opLessEq, opGreatEq, opNonEq, opEq, opPlus, opIn]);
            fvtClass, fvtArray:
              Error := not (op in [opNonEq, opEq]);
          end;
      end;

      if not Error then
      begin
        Result := Typ1;
        { if one type is Float, resulting type is float too }
        if [Typ1.Typ] + [Typ2.Typ] = [fvtInt, fvtFloat] then
          Result.Typ := fvtFloat;
        { case int / int = float }  
        if (Typ1.Typ = fvtInt) and (Typ2.Typ = fvtInt) and (op = opDivFloat) then
          Result.Typ := fvtFloat;
        { result of comparing two types is always boolean }
        if op in [opGreat, opLess, opLessEq, opGreatEq, opNonEq, opEq, opIn, opIs] then
          Result.Typ := fvtBool;
      end
      else if ErrorPos = '' then
        ErrorPos := Item.SourcePos;

      Item.Typ := Result.Typ;
    end;
  end;

begin
  { remove the empty root node }
  FCurNode := FNode.FLeft;
  FNode.RemoveNode(FCurNode);
  FNode.Free;
  FNode := FCurNode;

  { check and get the expression type }
  ErrorPos := '';
  TypeRec := GetType(FNode);
  Typ := TypeRec.Typ;
  TypeName := TypeRec.TypeName;
  Result := ErrorPos;

  { expression is assignable if it has only one node of type "Variable" }
  if not ((FNode is TfsDesignatorNode) and not
    (TfsDesignatorNode(FNode).FDesignator.IsReadOnly)) then
    IsReadOnly := True;
end;

procedure TfsExpression.SetValue(const Value: Variant);
begin
  if not IsReadOnly then
    TfsDesignatorNode(FNode).FDesignator.Value := Value;
end;

function TfsExpression.Optimize(Designator: TfsDesignator): String;
var
  Op: TfsOperatorType;
begin
  Result := ' ';

  if not (Designator is TfsVariableDesignator) or
    not (FNode is TfsOperatorNode) then Exit;

  Op := TfsOperatorNode(FNode).FOp;
  if not (Op in [opPlus, opMinus, opDivFloat, opMul]) then Exit;

  { optimize a := a op b statement }
  if (FNode.FLeft is TfsDesignatorNode) and
    (TfsDesignatorNode(FNode.FLeft).FDesignator is TfsVariableDesignator) and
    (TfsDesignatorNode(FNode.FLeft).FDesignator.RefItem = Designator.RefItem) then
  begin
    FCurNode := FNode.FRight;
    FNode.RemoveNode(FCurNode);
    FNode.Free;
    FNode := FCurNode;

    if Op = opPlus then
      Result := '+'
    else if Op = opMinus then
      Result := '-'
    else if Op = opDivFloat then
      Result := '/'
    else if Op = opMul then
      Result := '*';
  end
  { optimize a := b op a statement }
  else if (FNode.FRight is TfsDesignatorNode) and
    (TfsDesignatorNode(FNode.FRight).FDesignator is TfsVariableDesignator) and
    (TfsDesignatorNode(FNode.FRight).FDesignator.RefItem = Designator.RefItem) and
    (Op in [opPlus, opMul]) and
    not (Designator.RefItem.Typ in [fvtString, fvtVariant]) then
  begin
    FCurNode := FNode.FLeft;
    FNode.RemoveNode(FCurNode);
    FNode.Free;
    FNode := FCurNode;

    if Op = opPlus then
      Result := '+'
    else if Op = opMul then
      Result := '*';
  end;
end;

function TfsExpression.SingleItem: TfsCustomVariable;
begin
  { if expression contains only one item, returns reference to it }
  Result := nil;

  if FNode is TfsDesignatorNode then
  begin
    if TfsDesignatorNode(FNode).FDesignator is TfsVariableDesignator then
      Result := TfsDesignatorNode(FNode).FDesignator.RefItem else
      Result := TfsDesignatorNode(FNode).FDesignator;
  end
  else if FNode is TfsOperandNode then
    Result := FNode;
end;

end.
