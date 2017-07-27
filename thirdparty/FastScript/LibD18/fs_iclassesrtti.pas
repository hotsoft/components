
{******************************************}
{                                          }
{             FastScript v1.9              }
{    Classes.pas classes and functions     }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

//VCL uses section
{$IFNDEF FMX}
unit fs_iclassesrtti;

interface

{$i fs.inc}

uses SysUtils, Classes, fs_iinterpreter, fs_xml{$IFDEF DELPHI16}, Controls{$ENDIF}
{$IFDEF Delphi16}
  , System.Types
{$ENDIF};
//FMX USES
{$ELSE}
interface

{$i fs.inc}

uses System.SysUtils, System.Classes, FMX.fs_iinterpreter, FMX.fs_xml, System.Types, FMX.Types, System.UITypes
{$IFDEF DELPHI20}
	,System.Math.Vectors
{$ENDIF};
{$ENDIF}

type
{$IFDEF DELPHI16}
{$IFDEF FMX}
[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ELSE}
[ComponentPlatformsAttribute(pidWin32 or pidWin64)]
{$ENDIF}
{$ENDIF}
  TfsClassesRTTI = class(TComponent); // fake component
{$IFDEF FMX}
{ wrappers for most using structures }
  TfsRectF = class(TPersistent)
  private
    FRectF: TRectF;
    function GetBottom: Single;
    function GetLeft: Single;
    function GetRight: Single;
    function GetTop: Single;
    procedure SetBottom(const Value: Single);
    procedure SetLeft(const Value: Single);
    procedure SetRight(const Value: Single);
    procedure SetTop(const Value: Single);
  public
    function GetRect: TRectF;
    function GetRectP: PRectF;
    constructor Create(aRectF: TRectF);
  published
    property Left: Single read GetLeft write SetLeft;
    property Top: Single read GetTop write SetTop;
    property Right: Single read GetRight write SetRight;
    property Bottom: Single read GetBottom write SetBottom;
  end;

  TfsMatrix = class(TPersistent)
  private
    FMatrix: TMatrix;
    function Getm11: Single;
    function Getm12: Single;
    function Getm13: Single;
    function Getm21: Single;
    function Getm22: Single;
    function Getm23: Single;
    function Getm31: Single;
    function Getm32: Single;
    function Getm33: Single;
    procedure Setm11(const Value: Single);
    procedure Setm12(const Value: Single);
    procedure Setm13(const Value: Single);
    procedure Setm21(const Value: Single);
    procedure Setm22(const Value: Single);
    procedure Setm23(const Value: Single);
    procedure Setm31(const Value: Single);
    procedure Setm32(const Value: Single);
    procedure Setm33(const Value: Single);
  public
    procedure AssignToRect(var Rect: TMatrix);
    procedure AssignFromRect(Rect: TMatrix);
    function GetRect: TMatrix;
    constructor Create(aMatrix: TMatrix);
  published
    property m11: Single read Getm11 write Setm11;
    property m12: Single read Getm12 write Setm12;
    property m13: Single read Getm13 write Setm13;
    property m21: Single read Getm21 write Setm21;
    property m22: Single read Getm22 write Setm22;
    property m23: Single read Getm23 write Setm23;
    property m31: Single read Getm31 write Setm31;
    property m32: Single read Getm32 write Setm32;
    property m33: Single read Getm33 write Setm33;
  end;

  TfsPointF = class(TPersistent)
  private
    FPointF: TPointF;
    function GetX: Single;
    function GetY: Single;
    procedure SetX(const Value: Single);
    procedure SetY(const Value: Single);
  public
    function GetRect: TPointF;
    function GetRectP: PPointF;
    constructor Create(aPointF: TPointF);
  published
    property pX: Single read GetX write SetX;
    property pY: Single read GetY write SetY;
  end;

  PVector = ^TVector;
  TfsVector = class(TPersistent)
  private
    FVector: TVector;
    function GetW: Single;
    function GetX: Single;
    function GetY: Single;
    procedure SetW(const Value: Single);
    procedure SetX(const Value: Single);
    procedure SetY(const Value: Single);
  public
    function GetRect: TVector;
    function GetRectP: PVector;
    constructor Create(aVector: TVector);
  published
    property pX: Single read GetX write SetX;
    property pY: Single read GetY write SetY;
    property pW: Single read GetW write SetW;
  end;
{$ENDIF}


implementation

type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function GetProp(Instance: TObject; ClassType: TClass;
      const PropName: String): Variant;
    procedure SetProp(Instance: TObject; ClassType: TClass;
      const PropName: String; Value: Variant);
  public
    constructor Create(AScript: TfsScript); override;
  end;

{$IFDEF FMX}
{ TFrxRectF }

constructor TfsRectF.Create(aRectF: TRectF);
begin
  FRectF.Left := aRectF.Left;
  FRectF.Top := aRectF.Top;
  FRectF.Right := aRectF.Right;
  FRectF.Bottom := aRectF.Bottom;
end;

function TfsRectF.GetBottom: Single;
begin
  Result := FRectF.Bottom;
end;

function TfsRectF.GetLeft: Single;
begin
    Result := FRectF.Left;
end;

function TfsRectF.GetRect: TRectF;
begin
  Result := FRectF;
end;

function TfsRectF.GetRectP: PRectF;
begin
  Result := @FRectF;
end;

function TfsRectF.GetRight: Single;
begin
  Result := FRectF.Right;
end;

function TfsRectF.GetTop: Single;
begin
  Result := FRectF.Top;
end;

procedure TfsRectF.SetBottom(const Value: Single);
begin
  FRectF.Bottom := Value;
end;

procedure TfsRectF.SetLeft(const Value: Single);
begin
  FRectF.Left := Value;
end;

procedure TfsRectF.SetRight(const Value: Single);
begin
  FRectF.Right := Value;
end;

procedure TfsRectF.SetTop(const Value: Single);
begin
  FRectF.Top := Value;
end;

{ TfsMatrix }

procedure TfsMatrix.AssignFromRect(Rect: TMatrix);
begin

end;

procedure TfsMatrix.AssignToRect(var Rect: TMatrix);
begin

end;

constructor TfsMatrix.Create(aMatrix: TMatrix);
begin
  FMatrix.m11 := aMatrix.m11;
  FMatrix.m12 := aMatrix.m12;
  FMatrix.m13 := aMatrix.m13;
  FMatrix.m21 := aMatrix.m21;
  FMatrix.m22 := aMatrix.m22;
  FMatrix.m23 := aMatrix.m23;
  FMatrix.m31 := aMatrix.m31;
  FMatrix.m32 := aMatrix.m32;
  FMatrix.m33 := aMatrix.m33;
end;

function TfsMatrix.Getm11: Single;
begin
  Result := FMatrix.m11;
end;

function TfsMatrix.Getm12: Single;
begin
  Result := FMatrix.m12;
end;

function TfsMatrix.Getm13: Single;
begin
  Result := FMatrix.m13;
end;

function TfsMatrix.Getm21: Single;
begin
  Result := FMatrix.m21;
end;

function TfsMatrix.Getm22: Single;
begin
  Result := FMatrix.m22;
end;

function TfsMatrix.Getm23: Single;
begin
  Result := FMatrix.m23;
end;

function TfsMatrix.Getm31: Single;
begin
  Result := FMatrix.m31;
end;

function TfsMatrix.Getm32: Single;
begin
  Result := FMatrix.m32;
end;

function TfsMatrix.Getm33: Single;
begin
  Result := FMatrix.m33;
end;

function TfsMatrix.GetRect: TMatrix;
begin
  Result := FMatrix;
end;

procedure TfsMatrix.Setm11(const Value: Single);
begin
  FMatrix.m11 := Value;
end;

procedure TfsMatrix.Setm12(const Value: Single);
begin
  FMatrix.m12 := Value;
end;

procedure TfsMatrix.Setm13(const Value: Single);
begin
  FMatrix.m13 := Value;
end;

procedure TfsMatrix.Setm21(const Value: Single);
begin
  FMatrix.m21 := Value;
end;

procedure TfsMatrix.Setm22(const Value: Single);
begin
  FMatrix.m22 := Value;
end;

procedure TfsMatrix.Setm23(const Value: Single);
begin
  FMatrix.m23 := Value;
end;

procedure TfsMatrix.Setm31(const Value: Single);
begin
  FMatrix.m31 := Value;
end;

procedure TfsMatrix.Setm32(const Value: Single);
begin
  FMatrix.m32 := Value;
end;

procedure TfsMatrix.Setm33(const Value: Single);
begin
  FMatrix.m33 := Value;
end;

{ TfsPointF }

constructor TfsPointF.Create(aPointF: TPointF);
begin
  FPointF.X := aPointF.X;
  FPointF.Y := aPointF.Y;
end;

function TfsPointF.GetRect: TPointF;
begin
  Result := FPointF;
end;

function TfsPointF.GetRectP: PPointF;
begin
  Result := @FPointF;
end;

function TfsPointF.GetX: Single;
begin
  Result := FPointF.X;
end;

function TfsPointF.GetY: Single;
begin
  Result := FPointF.Y;
end;

procedure TfsPointF.SetX(const Value: Single);
begin
  FPointF.X := Value;
end;

procedure TfsPointF.SetY(const Value: Single);
begin
  FPointF.Y := Value;
end;

{ TfsVector }

constructor TfsVector.Create(aVector: TVector);
begin
  FVector.X := aVector.X;
  FVector.Y := aVector.Y;
  FVector.W := aVector.W;
end;

function TfsVector.GetRect: TVector;
begin
  Result := FVector;
end;

function TfsVector.GetRectP: PVector;
begin
  Result := @FVector;
end;

function TfsVector.GetW: Single;
begin
  Result := FVector.W;
end;

function TfsVector.GetX: Single;
begin
  Result := FVector.X;
end;

function TfsVector.GetY: Single;
begin
  Result := FVector.Y;
end;

procedure TfsVector.SetW(const Value: Single);
begin
  FVector.W := Value;
end;

procedure TfsVector.SetX(const Value: Single);
begin
  FVector.X := Value;
end;

procedure TfsVector.SetY(const Value: Single);
begin
  FVector.Y := Value;
end;

{$ENDIF}


{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddConst('fmCreate', 'Integer', fmCreate);
    AddConst('fmOpenRead', 'Integer', fmOpenRead);
    AddConst('fmOpenWrite', 'Integer', fmOpenWrite);
    AddConst('fmOpenReadWrite', 'Integer', fmOpenReadWrite);
    AddConst('fmShareExclusive', 'Integer', fmShareExclusive);
    AddConst('fmShareDenyWrite', 'Integer', fmShareDenyWrite);
    AddConst('fmShareDenyNone', 'Integer', fmShareDenyNone);
    AddConst('soFromBeginning', 'Integer', soFromBeginning);
    AddConst('soFromCurrent', 'Integer', soFromCurrent);
    AddConst('soFromEnd', 'Integer', soFromEnd);
    AddEnum('TDuplicates', 'dupIgnore, dupAccept, dupError');
    AddEnum('TPrinterOrientation', 'poPortrait, poLandscape');

    with AddClass(TObject, '') do
    begin
      AddConstructor('constructor Create', CallMethod);
      AddMethod('procedure Free', CallMethod);
      AddMethod('function ClassName: String', CallMethod);
    end;
    with AddClass(TPersistent, 'TObject') do
      AddMethod('procedure Assign(Source: TPersistent)', CallMethod);
    AddClass(TCollectionItem, 'TPersistent');
    with AddClass(TCollection, 'TPersistent') do
    begin
      AddMethod('procedure Clear', CallMethod);
      AddProperty('Count', 'Integer', GetProp, nil);
      AddDefaultProperty('Items', 'Integer', 'TCollectionItem', CallMethod, True);
    end;
    with AddClass(TList, 'TObject') do
    begin
      AddMethod('function Add(Item: TObject): Integer', CallMethod);
      AddMethod('procedure Clear', CallMethod);
      AddMethod('procedure Delete(Index: Integer)', CallMethod);
      AddMethod('function IndexOf(Item: TObject): Integer', CallMethod);
      AddMethod('procedure Insert(Index: Integer; Item: TObject)', CallMethod);
      AddMethod('function Remove(Item: TObject): Integer', CallMethod);
      AddProperty('Count', 'Integer', GetProp, nil);
      AddDefaultProperty('Items', 'Integer', 'TObject', CallMethod);
    end;
    with AddClass(TStrings, 'TPersistent') do
    begin
      AddConstructor('constructor Create', CallMethod);
      AddMethod('function Add(const S: string): Integer', CallMethod);
      AddMethod('function AddObject(const S: string; AObject: TObject): Integer', CallMethod);
      AddMethod('procedure Clear', CallMethod);
      AddMethod('procedure Delete(Index: Integer)', CallMethod);
      AddMethod('function IndexOf(const S: string): Integer', CallMethod);
      AddMethod('function IndexOfName(const Name: string): Integer', CallMethod);
      AddMethod('function IndexOfObject(AObject: TObject): Integer', CallMethod);
      AddMethod('procedure Insert(Index: Integer; const S: string)', CallMethod);
      AddMethod('procedure InsertObject(Index: Integer; const S: string; AObject: TObject)', CallMethod);
      AddMethod('procedure LoadFromFile(const FileName: string)', CallMethod);
      AddMethod('procedure LoadFromStream(Stream: TStream)', CallMethod);
      AddMethod('procedure SaveToFile(const FileName: string)', CallMethod);
      AddMethod('procedure Move(CurIndex, NewIndex: Integer)', CallMethod);
      AddMethod('procedure SaveToStream(Stream: TStream)', CallMethod);

      AddProperty('CommaText', 'string', GetProp, SetProp);
      AddProperty('Count', 'Integer', GetProp, nil);
      AddIndexProperty('Names', 'Integer', 'string', CallMethod, True);
      AddIndexProperty('Objects', 'Integer', 'TObject', CallMethod);
      AddIndexProperty('Values', 'String', 'string', CallMethod);
      AddDefaultProperty('Strings', 'Integer', 'string', CallMethod);
      AddProperty('Text', 'string', GetProp, SetProp);
    end;
    with AddClass(TStringList, 'TStrings') do
    begin
      AddMethod('function Find(s: String; var Index: Integer): Boolean', CallMethod);
      AddMethod('procedure Sort', CallMethod);
      AddProperty('Duplicates', 'TDuplicates', GetProp, SetProp);
      AddProperty('Sorted', 'Boolean', GetProp, SetProp);
    end;
    with AddClass(TStream, 'TObject') do
    begin
      AddMethod('function Read(var Buffer: string; Count: Longint): Longint', CallMethod);
      AddMethod('function Write(Buffer: string; Count: Longint): Longint', CallMethod);
      AddMethod('function Seek(Offset: Longint; Origin: Word): Longint', CallMethod);
      AddMethod('function CopyFrom(Source: TStream; Count: Longint): Longint', CallMethod);
      AddProperty('Position', 'Longint', GetProp, SetProp);
      AddProperty('Size', 'Longint', GetProp, nil);
    end;
    with AddClass(TFileStream, 'TStream') do
      AddConstructor('constructor Create(Filename: String; Mode: Word)', CallMethod);
    with AddClass(TMemoryStream, 'TStream') do
    begin
      AddMethod('procedure Clear', CallMethod);
      AddMethod('procedure LoadFromStream(Stream: TStream)', CallMethod);
      AddMethod('procedure LoadFromFile(Filename: String)', CallMethod);
      AddMethod('procedure SaveToStream(Stream: TStream)', CallMethod);
      AddMethod('procedure SaveToFile(Filename: String)', CallMethod);
    end;
    with AddClass(TComponent, 'TPersistent') do
    begin
      AddConstructor('constructor Create(AOwner: TComponent)', CallMethod);
      AddProperty('Owner', 'TComponent', GetProp, nil);
    end;
{$IFDEF FMX}
    AddClass(TfsRectF, 'TPersistent');
    AddClass(TfsMatrix, 'TPersistent');
    AddClass(TfsPointF, 'TPersistent');
    AddClass(TfsVector, 'TPersistent');
	  with AddClass(TFmxObject, 'TComponent') do
    begin
      AddMethod('function Clone(AOwner: TComponent): TFmxObject', CallMethod);
      AddMethod('procedure CloneChildFromStream(AStream: TStream)', CallMethod);
      AddMethod('procedure AddObject(AObject: TFmxObject)', CallMethod);
      AddMethod('procedure InsertObject(Index: Integer; AObject: TFmxObject)', CallMethod);
      AddMethod('procedure RemoveObject(AObject: TFmxObject)', CallMethod);
      AddMethod('procedure RemoveObject(Index: Integer)', CallMethod);
      AddMethod('procedure Exchange(AObject1: TFmxObject; AObject2: TFmxObject)', CallMethod);
      AddMethod('procedure DeleteChildren()', CallMethod);
      AddMethod('procedure BringToFront()', CallMethod);
      AddMethod('procedure SendToBack()', CallMethod);
      AddMethod('procedure AddObjectsToList(AList: TList)', CallMethod);
{$IFNDEF DELPHI18}
      AddMethod('procedure AddControlsToList(AList: TList)', CallMethod);
{$ENDIF}
{$IFNDEF DELPHI20}
      AddMethod('procedure GetTabOrderList(List: TList; AChildren: Boolean)', CallMethod);
{$ENDIF}
      AddMethod('procedure LoadFromStream(AStream: TStream)', CallMethod);
      AddMethod('procedure SaveToStream(Stream: TStream)', CallMethod);
      AddMethod('procedure LoadFromBinStream(AStream: TStream)', CallMethod);
      AddMethod('procedure SaveToBinStream(AStream: TStream)', CallMethod);
      AddMethod('function FindStyleResource(AStyleLookup: string): TFmxObject', CallMethod);
{$IFNDEF DELPHI18}
      AddMethod('procedure UpdateStyle()', CallMethod);
{$ENDIF}
{$IFNDEF DELPHI21}
      AddMethod('procedure StartAnimation(AName: string)', CallMethod);
      AddMethod('procedure StopAnimation(AName: string)', CallMethod);
      AddMethod('procedure StartTriggerAnimation(AInstance: TFmxObject; ATrigger: string)', CallMethod);
      AddMethod('procedure StartTriggerAnimationWait(AInstance: TFmxObject; ATrigger: string)', CallMethod);
{$IFDEF DELPHI17}
      AddMethod('procedure StopTriggerAnimation(AInstance: TFmxObject; ATrigger: string)', CallMethod);
{$ELSE}
      AddMethod('procedure StopTriggerAnimation(AInstance: TFmxObject)', CallMethod);
{$ENDIF}

      AddMethod('procedure ApplyTriggerEffect(AInstance: TFmxObject; ATrigger: string)', CallMethod);
{$ENDIF}
      AddMethod('procedure AnimateFloat(APropertyName: string; NewValue: Single; Duration: Single; AType: TAnimationType; AInterpolation: TInterpolationType)', CallMethod);
      AddMethod('procedure AnimateColor(APropertyName: string; NewValue: TAlphaColor; Duration: Single; AType: TAnimationType; AInterpolation: TInterpolationType)', CallMethod);
      AddMethod('procedure AnimateFloatDelay(APropertyName: string; NewValue: Single; Duration: Single; Delay: Single; AType: TAnimationType; AInterpolation: TInterpolationType)', CallMethod);
      AddMethod('procedure AnimateFloatWait(APropertyName: string; NewValue: Single; Duration: Single; AType: TAnimationType; AInterpolation: TInterpolationType)', CallMethod);
      AddMethod('procedure StopPropertyAnimation(APropertyName: string)', CallMethod);
      AddProperty('Parent', 'TFmxObject', GetProp, SetProp);
      AddProperty('Index', 'Integer', GetProp, SetProp);
    end;
{$ENDIF}
    with AddClass(TfsXMLItem, 'TObject') do
    begin
      AddConstructor('constructor Create', CallMethod);
      AddMethod('procedure AddItem(Item: TfsXMLItem)', CallMethod);
      AddMethod('procedure Clear', CallMethod);
      AddMethod('procedure InsertItem(Index: Integer; Item: TfsXMLItem)', CallMethod);
      AddMethod('function Add: TfsXMLItem', CallMethod);
      AddMethod('function Find(const Name: String): Integer', CallMethod);
      AddMethod('function FindItem(const Name: String): TfsXMLItem', CallMethod);
      AddMethod('function Root: TfsXMLItem', CallMethod);
      AddProperty('Data', 'Integer', GetProp, SetProp);
      AddProperty('Count', 'Integer', GetProp, nil);
      AddDefaultProperty('Items', 'Integer', 'TfsXMLItem', CallMethod, True);
      AddIndexProperty('Prop', 'String', 'String', CallMethod);
      AddProperty('Name', 'String', GetProp, SetProp);
      AddProperty('Parent', 'TfsXMLItem', GetProp, nil);
      AddProperty('Text', 'String', GetProp, SetProp);
    end;
    with AddClass(TfsXMLDocument, 'TObject') do
    begin
      AddConstructor('constructor Create', CallMethod);
      AddMethod('procedure SaveToStream(Stream: TStream)', CallMethod);
      AddMethod('procedure LoadFromStream(Stream: TStream)', CallMethod);
      AddMethod('procedure SaveToFile(const FileName: String)', CallMethod);
      AddMethod('procedure LoadFromFile(const FileName: String)', CallMethod);
      AddProperty('Root', 'TfsXMLItem', GetProp, nil);
    end;
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  i: Integer;
  s: String;
  _TList: TList;
  _TStrings: TStrings;
  _TStream: TStream;
  _TMemoryStream: TMemoryStream;
  _TfsXMLItem: TfsXMLItem;
  _TfsXMLDocument: TfsXMLDocument;
{$IFDEF FMX}
  _fmxObj: TFmxObject;
{$ENDIF}
begin
  Result := 0;

  if ClassType = TObject then
  begin
    if MethodName = 'CREATE' then
      Result := frxInteger(Instance.Create)
    else if MethodName = 'FREE' then
      Instance.Free
    else if MethodName = 'CLASSNAME' then
      Result := Instance.ClassName
  end
  else if ClassType = TPersistent then
  begin
    if MethodName = 'ASSIGN' then
      TPersistent(Instance).Assign(TPersistent(frxInteger(Caller.Params[0])));
  end
  else if ClassType = TCollection then
  begin
    if MethodName = 'CLEAR' then
      TCollection(Instance).Clear
    else if MethodName = 'ITEMS.GET' then
      Result := frxInteger(TCollection(Instance).Items[Caller.Params[0]])
  end
  else if ClassType = TList then
  begin
    _TList := TList(Instance);
    if MethodName = 'ADD' then
      _TList.Add(Pointer(frxInteger(Caller.Params[0])))
    else if MethodName = 'CLEAR' then
      _TList.Clear
    else if MethodName = 'DELETE' then
      _TList.Delete(Caller.Params[0])
    else if MethodName = 'INDEXOF' then
      Result := _TList.IndexOf(Pointer(frxInteger(Caller.Params[0])))
    else if MethodName = 'INSERT' then
      _TList.Insert(Caller.Params[0], Pointer(frxInteger(Caller.Params[1])))
    else if MethodName = 'REMOVE' then
      _TList.Remove(Pointer(frxInteger(Caller.Params[0])))
    else if MethodName = 'ITEMS.GET' then
      Result := frxInteger(_TList.Items[Caller.Params[0]])
    else if MethodName = 'ITEMS.SET' then
      _TList.Items[Caller.Params[0]] := Pointer(frxInteger(Caller.Params[1]))
  end
  else if ClassType = TStrings then
  begin
    _TStrings := TStrings(Instance);
    if MethodName = 'CREATE' then
      Result := frxInteger(_TStrings.Create)
    else if MethodName = 'ADD' then
      Result := _TStrings.Add(Caller.Params[0])
    else if MethodName = 'ADDOBJECT' then
      Result := _TStrings.AddObject(Caller.Params[0], TObject(frxInteger(Caller.Params[1])))
    else if MethodName = 'CLEAR' then
      _TStrings.Clear
    else if MethodName = 'DELETE' then
      _TStrings.Delete(Caller.Params[0])
    else if MethodName = 'INDEXOF' then
      Result := _TStrings.IndexOf(Caller.Params[0])
    else if MethodName = 'INDEXOFNAME' then
      Result := _TStrings.IndexOfName(Caller.Params[0])
    else if MethodName = 'INDEXOFOBJECT' then
      Result := _TStrings.IndexOfObject(TObject(frxInteger(Caller.Params[0])))
    else if MethodName = 'INSERT' then
      _TStrings.Insert(Caller.Params[0], Caller.Params[1])
    else if MethodName = 'INSERTOBJECT' then
      _TStrings.InsertObject(Caller.Params[0], Caller.Params[1], TObject(frxInteger(Caller.Params[2])))
    else if MethodName = 'LOADFROMFILE' then
      _TStrings.LoadFromFile(Caller.Params[0])
    else if MethodName = 'LOADFROMSTREAM' then
      _TStrings.LoadFromStream(TStream(frxInteger(Caller.Params[0])))
    else if MethodName = 'MOVE' then
      _TStrings.Move(Caller.Params[0], Caller.Params[1])
    else if MethodName = 'SAVETOFILE' then
      _TStrings.SaveToFile(Caller.Params[0])
    else if MethodName = 'SAVETOSTREAM' then
      _TStrings.SaveToStream(TStream(frxInteger(Caller.Params[0])))
    else if MethodName = 'NAMES.GET' then
      Result := _TStrings.Names[Caller.Params[0]]
    else if MethodName = 'OBJECTS.GET' then
      Result := frxInteger(_TStrings.Objects[Caller.Params[0]])
    else if MethodName = 'OBJECTS.SET' then
      _TStrings.Objects[Caller.Params[0]] := TObject(frxInteger(Caller.Params[1]))
    else if MethodName = 'VALUES.GET' then
      Result := _TStrings.Values[Caller.Params[0]]
    else if MethodName = 'VALUES.SET' then
      _TStrings.Values[Caller.Params[0]] := Caller.Params[1]
    else if MethodName = 'STRINGS.GET' then
      Result := _TStrings.Strings[Caller.Params[0]]
    else if MethodName = 'STRINGS.SET' then
      _TStrings.Strings[Caller.Params[0]] := Caller.Params[1]
  end
  else if ClassType = TStringList then
  begin
    if MethodName = 'FIND' then
    begin
      Result := TStringList(Instance).Find(Caller.Params[0], i);
      Caller.Params[1] := i;
    end
    else if MethodName = 'SORT' then
      TStringList(Instance).Sort
  end
  else if ClassType = TStream then
  begin
    _TStream := TStream(Instance);
    if MethodName = 'READ' then
    begin
      SetLength(s, Integer(Caller.Params[1]));
      Result := _TStream.Read(s[1], Caller.Params[1]);
      SetLength(s, Integer(Result));
      Caller.Params[0] := s;
    end
    else if MethodName = 'WRITE' then
    begin
      s := Caller.Params[0];
      Result := _TStream.Write(s[1], Caller.Params[1]);
    end
    else if MethodName = 'SEEK' then
{$IFDEF DELPHI18}
      Result := _TStream.Seek(Int64(Caller.Params[0]), Word(Caller.Params[1]))
{$ELSE}
      Result := _TStream.Seek(Caller.Params[0], Caller.Params[1])
{$ENDIF}
    else if MethodName = 'COPYFROM' then
      Result := _TStream.CopyFrom(TStream(frxInteger(Caller.Params[0])), Caller.Params[1])
  end
  else if ClassType = TFileStream then
  begin
    if MethodName = 'CREATE' then
      Result := frxInteger(TFileStream(Instance).Create(Caller.Params[0], Caller.Params[1]))
  end
  else if ClassType = TMemoryStream then
  begin
    _TMemoryStream := TMemoryStream(Instance);
    if MethodName = 'CLEAR' then
      _TMemoryStream.Clear
    else if MethodName = 'LOADFROMSTREAM' then
      _TMemoryStream.LoadFromStream(TStream(frxInteger(Caller.Params[0])))
    else if MethodName = 'LOADFROMFILE' then
      _TMemoryStream.LoadFromFile(Caller.Params[0])
    else if MethodName = 'SAVETOSTREAM' then
      _TMemoryStream.SaveToStream(TStream(frxInteger(Caller.Params[0])))
    else if MethodName = 'SAVETOFILE' then
      _TMemoryStream.SaveToFile(Caller.Params[0])
  end
  else if ClassType = TComponent then
  begin
    if MethodName = 'CREATE' then
      Result := frxInteger(TComponent(Instance).Create(TComponent(frxInteger(Caller.Params[0]))))
  end
  else if ClassType = TfsXMLItem then
  begin
    _TfsXMLItem := TfsXMLItem(Instance);
    if MethodName = 'CREATE' then
      Result := frxInteger(_TfsXMLItem.Create)
    else if MethodName = 'ADDITEM' then
      _TfsXMLItem.AddItem(TfsXMLItem(frxInteger(Caller.Params[0])))
    else if MethodName = 'CLEAR' then
      _TfsXMLItem.Clear
    else if MethodName = 'INSERTITEM' then
      _TfsXMLItem.InsertItem(Caller.Params[0], TfsXMLItem(frxInteger(Caller.Params[1])))
    else if MethodName = 'ADD' then
      Result := frxInteger(_TfsXMLItem.Add)
    else if MethodName = 'FIND' then
      Result := _TfsXMLItem.Find(Caller.Params[0])
    else if MethodName = 'FINDITEM' then
      Result := frxInteger(_TfsXMLItem.FindItem(Caller.Params[0]))
    else if MethodName = 'PROP.GET' then
      Result := _TfsXMLItem.Prop[Caller.Params[0]]
    else if MethodName = 'PROP.SET' then
      _TfsXMLItem.Prop[Caller.Params[0]] := Caller.Params[1]
    else if MethodName = 'ROOT' then
      Result := frxInteger(_TfsXMLItem.Root)
    else if MethodName = 'ROOT' then
      Result := frxInteger(_TfsXMLItem.Root)
    else if MethodName = 'ITEMS.GET' then
      Result := frxInteger(_TfsXMLItem[Caller.Params[0]])
  end
  else if ClassType = TfsXMLDocument then
  begin
    _TfsXMLDocument := TfsXMLDocument(Instance);
    if MethodName = 'CREATE' then
      Result := frxInteger(_TfsXMLDocument.Create)
    else if MethodName = 'SAVETOSTREAM' then
      _TfsXMLDocument.SaveToStream(TStream(frxInteger(Caller.Params[0])))
    else if MethodName = 'LOADFROMSTREAM' then
      _TfsXMLDocument.LoadFromStream(TStream(frxInteger(Caller.Params[0])))
    else if MethodName = 'SAVETOFILE' then
      _TfsXMLDocument.SaveToFile(Caller.Params[0])
    else if MethodName = 'LOADFROMFILE' then
      _TfsXMLDocument.LoadFromFile(Caller.Params[0])
  end
{$IFDEF FMX}
  else if ClassType =  TFmxObject then
  begin
    _fmxObj := TFmxObject(Instance);
    if MethodName = 'CLONE' then
      Result := frxInteger(_fmxObj.Clone(TComponent(frxInteger(Caller.Params[0]))))
//    else if MethodName = 'CLONECHILDFROMSTREAM' then
//      _fmxObj.CloneChildFromStream(TStream(frxInteger(Caller.Params[0])))
    else if MethodName = 'ADDOBJECT' then
      _fmxObj.AddObject(TFmxObject(frxInteger(Caller.Params[0])))
    else if MethodName = 'INSERTOBJECT' then
      _fmxObj.InsertObject(Integer(Caller.Params[0]), TFmxObject(frxInteger(Caller.Params[1])))
    else if MethodName = 'REMOVEOBJECT' then
      _fmxObj.RemoveObject(TFmxObject(frxInteger(Caller.Params[0])))
    else if MethodName = 'REMOVEOBJECT' then
      _fmxObj.RemoveObject(Integer(Caller.Params[0]))
    else if MethodName = 'EXCHANGE' then
      _fmxObj.Exchange(TFmxObject(frxInteger(Caller.Params[0])), TFmxObject(frxInteger(Caller.Params[1])))
    else if MethodName = 'DELETECHILDREN' then
      _fmxObj.DeleteChildren()
    else if MethodName = 'BRINGTOFRONT' then
      _fmxObj.BringToFront()
    else if MethodName = 'SENDTOBACK' then
      _fmxObj.SendToBack()
{$IFDEF DELPHI17}
    else if MethodName = 'ADDOBJECTSTOLIST' then
      _fmxObj.AddObjectsToList(TFmxObjectList(frxInteger(Caller.Params[0])))
{$IFNDEF DELPHI18}
    else if MethodName = 'ADDCONTROLSTOLIST' then
      _fmxObj.AddControlsToList(TFmxObjectList(frxInteger(Caller.Params[0])))
{$ENDIF}
{$IFNDEF DELPHI20}
    else if MethodName = 'GETTABORDERLIST' then
      _fmxObj.GetTabOrderList(TInterfaceList(frxInteger(Caller.Params[0])), Boolean(Caller.Params[1]))
{$ENDIF}
{$ELSE}
    else if MethodName = 'ADDOBJECTSTOLIST' then
      _fmxObj.AddObjectsToList(TList(frxInteger(Caller.Params[0])))
    else if MethodName = 'ADDCONTROLSTOLIST' then
      _fmxObj.AddControlsToList(TList(frxInteger(Caller.Params[0])))
    else if MethodName = 'GETTABORDERLIST' then
      _fmxObj.GetTabOrderList(TList(frxInteger(Caller.Params[0])), Boolean(Caller.Params[1]))
    else if MethodName = 'LOADFROMSTREAM' then
      _fmxObj.LoadFromStream(TStream(frxInteger(Caller.Params[0])))
    else if MethodName = 'SAVETOSTREAM' then
      _fmxObj.SaveToStream(TStream(frxInteger(Caller.Params[0])))
    else if MethodName = 'LOADFROMBINSTREAM' then
      _fmxObj.LoadFromBinStream(TStream(frxInteger(Caller.Params[0])))
    else if MethodName = 'SAVETOBINSTREAM' then
      _fmxObj.SaveToBinStream(TStream(frxInteger(Caller.Params[0])))
{$ENDIF}
    else if MethodName = 'FINDSTYLERESOURCE' then
      Result := frxInteger(_fmxObj.FindStyleResource(string(Caller.Params[0])))
{$IFNDEF DELPHI18}
    else if MethodName = 'UPDATESTYLE' then
      _fmxObj.UpdateStyle()
{$ENDIF}
{$IFNDEF DELPHI21}
    else if MethodName = 'STARTANIMATION' then
      _fmxObj.StartAnimation(string(Caller.Params[0]))
    else if MethodName = 'STOPANIMATION' then
      _fmxObj.StopAnimation(string(Caller.Params[0]))
    else if MethodName = 'STARTTRIGGERANIMATION' then
      _fmxObj.StartTriggerAnimation(TFmxObject(frxInteger(Caller.Params[0])), string(Caller.Params[1]))
    else if MethodName = 'STARTTRIGGERANIMATIONWAIT' then
      _fmxObj.StartTriggerAnimationWait(TFmxObject(frxInteger(Caller.Params[0])), string(Caller.Params[1]))
    else if MethodName = 'STOPTRIGGERANIMATION' then
{$IFDEF DELPHI17}
      _fmxObj.StopTriggerAnimation(TFmxObject(frxInteger(Caller.Params[0])), string(Caller.Params[1]))
{$ELSE}
      _fmxObj.StopTriggerAnimation(TFmxObject(frxInteger(Caller.Params[0])))
{$ENDIF}
    else if MethodName = 'APPLYTRIGGEREFFECT' then
      _fmxObj.ApplyTriggerEffect(TFmxObject(frxInteger(Caller.Params[0])), string(Caller.Params[1]))
{$ENDIF}
    else if MethodName = 'ANIMATEFLOAT' then
      _fmxObj.AnimateFloat(string(Caller.Params[0]), Single(Caller.Params[1]), Single(Caller.Params[2]), TAnimationType(Caller.Params[3]), TInterpolationType(Caller.Params[4]))
    else if MethodName = 'ANIMATECOLOR' then
      _fmxObj.AnimateColor(string(Caller.Params[0]), TAlphaColor(Caller.Params[1]), Single(Caller.Params[2]), TAnimationType(Caller.Params[3]), TInterpolationType(Caller.Params[4]))
    else if MethodName = 'ANIMATEFLOATDELAY' then
      _fmxObj.AnimateFloatDelay(string(Caller.Params[0]), Single(Caller.Params[1]), Single(Caller.Params[2]), Single(Caller.Params[3]), TAnimationType(Caller.Params[4]), TInterpolationType(Caller.Params[5]))
    else if MethodName = 'ANIMATEFLOATWAIT' then
      _fmxObj.AnimateFloatWait(string(Caller.Params[0]), Single(Caller.Params[1]), Single(Caller.Params[2]), TAnimationType(Caller.Params[3]), TInterpolationType(Caller.Params[4]))
    else if MethodName = 'STOPPROPERTYANIMATION' then
      _fmxObj.StopPropertyAnimation(string(Caller.Params[0]))
end;
{$ENDIF}
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TCollection then
  begin
    if PropName = 'COUNT' then
      Result := TCollection(Instance).Count
  end
  else if ClassType = TList then
  begin
    if PropName = 'COUNT' then
      Result := TList(Instance).Count
  end
  else if ClassType = TStrings then
  begin
    if PropName = 'COMMATEXT' then
      Result := TStrings(Instance).CommaText
    else if PropName = 'COUNT' then
      Result := TStrings(Instance).Count
    else if PropName = 'TEXT' then
      Result := TStrings(Instance).Text
  end
  else if ClassType = TStringList then
  begin
    if PropName = 'DUPLICATES' then
      Result := TStringList(Instance).Duplicates
    else if PropName = 'SORTED' then
      Result := TStringList(Instance).Sorted
  end
  else if ClassType = TStream then
  begin
    if PropName = 'POSITION' then
      Result := TStream(Instance).Position
    else if PropName = 'SIZE' then
      Result := TStream(Instance).Size
  end
  else if ClassType = TComponent then
  begin
    if PropName = 'OWNER' then
      Result := frxInteger(TComponent(Instance).Owner)
  end
  else if ClassType = TfsXMLItem then
  begin
    if PropName = 'DATA' then
      Result := frxInteger(TfsXMLItem(Instance).Data)
    else if PropName = 'COUNT' then
      Result := TfsXMLItem(Instance).Count
    else if PropName = 'NAME' then
      Result := TfsXMLItem(Instance).Name
    else if PropName = 'PARENT' then
      Result := frxInteger(TfsXMLItem(Instance).Parent)
    else if PropName = 'TEXT' then
      Result := TfsXMLItem(Instance).Text
  end
  else if ClassType = TfsXMLDocument then
  begin
    if PropName = 'ROOT' then
      Result := frxInteger(TfsXMLDocument(Instance).Root)
  end
  {$IFDEF FMX}
  else if ClassType = TFmxObject then
  begin
    if PropName = 'PARENT' then
      Result := frxInteger(TFmxObject(Instance).Parent)
      else if PropName = 'INDEX' then
      Result := TFmxObject(Instance).Index
  end
  {$ENDIF}
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TStrings then
  begin
    if PropName = 'COMMATEXT' then
      TStrings(Instance).CommaText := Value
    else if PropName = 'TEXT' then
      TStrings(Instance).Text := Value
  end
  else if ClassType = TStringList then
  begin
    if PropName = 'DUPLICATES' then
      TStringList(Instance).Duplicates := Value
    else if PropName = 'SORTED' then
      TStringList(Instance).Sorted := Value
  end
  else if ClassType = TStream then
  begin
    if PropName = 'POSITION' then
      TStream(Instance).Position := Value
  end
  else if ClassType = TfsXMLItem then
  begin
    if PropName = 'DATA' then
      TfsXMLItem(Instance).Data := Pointer(frxInteger(Value))
    else if PropName = 'NAME' then
      TfsXMLItem(Instance).Name := Value
    else if PropName = 'TEXT' then
      TfsXMLItem(Instance).Text := Value
  end
  {$IFDEF FMX}
  else if ClassType = TFmxObject then
  begin
    if PropName = 'PARENT' then
      TFmxObject(Instance).Parent := TFmxObject(frxInteger(Value))
      else if PropName = 'INDEX' then
        TFmxObject(Instance).Index := Value
  end
  {$ENDIF}
end;


initialization
{$IFDEF DELPHI16}
{$IFDEF FMX}
  StartClassGroup(TFmxObject);
  ActivateClassGroup(TFmxObject);
  GroupDescendentsWith(TfsClassesRTTI, TFmxObject);
{$ELSE}
  StartClassGroup(TControl);
  ActivateClassGroup(TControl);
  GroupDescendentsWith(TfsClassesRTTI, TControl);
{$ENDIF}
{$ENDIF}
  fsRTTIModules.Add(TFunctions);

finalization
  fsRTTIModules.Remove(TFunctions);

end.