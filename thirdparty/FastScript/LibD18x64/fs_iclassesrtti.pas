
{******************************************}
{                                          }
{             FastScript v1.9              }
{    Classes.pas classes and functions     }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iclassesrtti;

interface

{$i fs.inc}

uses SysUtils, Classes, fs_iinterpreter, fs_xml;

type
  TfsClassesRTTI = class(TComponent); // fake component


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
begin
  Result := 0;

  if ClassType = TObject then
  begin
    if MethodName = 'CREATE' then
      Result := Integer(Instance.Create)
    else if MethodName = 'FREE' then
      Instance.Free
    else if MethodName = 'CLASSNAME' then
      Result := Instance.ClassName
  end
  else if ClassType = TPersistent then
  begin
    if MethodName = 'ASSIGN' then
      TPersistent(Instance).Assign(TPersistent(Integer(Caller.Params[0])));
  end
  else if ClassType = TCollection then
  begin
    if MethodName = 'CLEAR' then
      TCollection(Instance).Clear
    else if MethodName = 'ITEMS.GET' then
      Result := Integer(TCollection(Instance).Items[Caller.Params[0]])
  end
  else if ClassType = TList then
  begin
    _TList := TList(Instance);
    if MethodName = 'ADD' then
      _TList.Add(Pointer(Integer(Caller.Params[0])))
    else if MethodName = 'CLEAR' then
      _TList.Clear
    else if MethodName = 'DELETE' then
      _TList.Delete(Caller.Params[0])
    else if MethodName = 'INDEXOF' then
      Result := _TList.IndexOf(Pointer(Integer(Caller.Params[0])))
    else if MethodName = 'INSERT' then
      _TList.Insert(Caller.Params[0], Pointer(Integer(Caller.Params[1])))
    else if MethodName = 'REMOVE' then
      _TList.Remove(Pointer(Integer(Caller.Params[0])))
    else if MethodName = 'ITEMS.GET' then
      Result := Integer(_TList.Items[Caller.Params[0]])
    else if MethodName = 'ITEMS.SET' then
      _TList.Items[Caller.Params[0]] := Pointer(Integer(Caller.Params[1]))
  end
  else if ClassType = TStrings then
  begin
    _TStrings := TStrings(Instance);
    if MethodName = 'ADD' then
      Result := _TStrings.Add(Caller.Params[0])
    else if MethodName = 'ADDOBJECT' then
      Result := _TStrings.AddObject(Caller.Params[0], TObject(Integer(Caller.Params[1])))
    else if MethodName = 'CLEAR' then
      _TStrings.Clear
    else if MethodName = 'DELETE' then
      _TStrings.Delete(Caller.Params[0])
    else if MethodName = 'INDEXOF' then
      Result := _TStrings.IndexOf(Caller.Params[0])
    else if MethodName = 'INDEXOFNAME' then
      Result := _TStrings.IndexOfName(Caller.Params[0])
    else if MethodName = 'INDEXOFOBJECT' then
      Result := _TStrings.IndexOfObject(TObject(Integer(Caller.Params[0])))
    else if MethodName = 'INSERT' then
      _TStrings.Insert(Caller.Params[0], Caller.Params[1])
    else if MethodName = 'INSERTOBJECT' then
      _TStrings.InsertObject(Caller.Params[0], Caller.Params[1], TObject(Integer(Caller.Params[2])))
    else if MethodName = 'LOADFROMFILE' then
      _TStrings.LoadFromFile(Caller.Params[0])
    else if MethodName = 'LOADFROMSTREAM' then
      _TStrings.LoadFromStream(TStream(Integer(Caller.Params[0])))
    else if MethodName = 'MOVE' then
      _TStrings.Move(Caller.Params[0], Caller.Params[1])
    else if MethodName = 'SAVETOFILE' then
      _TStrings.SaveToFile(Caller.Params[0])
    else if MethodName = 'SAVETOSTREAM' then
      _TStrings.SaveToStream(TStream(Integer(Caller.Params[0])))
    else if MethodName = 'NAMES.GET' then
      Result := _TStrings.Names[Caller.Params[0]]
    else if MethodName = 'OBJECTS.GET' then
      Result := Integer(_TStrings.Objects[Caller.Params[0]])
    else if MethodName = 'OBJECTS.SET' then
      _TStrings.Objects[Caller.Params[0]] := TObject(Integer(Caller.Params[1]))
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
      Result := _TStream.Seek(Caller.Params[0], Caller.Params[1])
    else if MethodName = 'COPYFROM' then
      Result := _TStream.CopyFrom(TStream(Integer(Caller.Params[0])), Caller.Params[1])
  end
  else if ClassType = TFileStream then
  begin
    if MethodName = 'CREATE' then
      Result := Integer(TFileStream(Instance).Create(Caller.Params[0], Caller.Params[1]))
  end
  else if ClassType = TMemoryStream then
  begin
    _TMemoryStream := TMemoryStream(Instance);
    if MethodName = 'CLEAR' then
      _TMemoryStream.Clear
    else if MethodName = 'LOADFROMSTREAM' then
      _TMemoryStream.LoadFromStream(TStream(Integer(Caller.Params[0])))
    else if MethodName = 'LOADFROMFILE' then
      _TMemoryStream.LoadFromFile(Caller.Params[0])
    else if MethodName = 'SAVETOSTREAM' then
      _TMemoryStream.SaveToStream(TStream(Integer(Caller.Params[0])))
    else if MethodName = 'SAVETOFILE' then
      _TMemoryStream.SaveToFile(Caller.Params[0])
  end
  else if ClassType = TComponent then
  begin
    if MethodName = 'CREATE' then
      Result := Integer(TComponent(Instance).Create(TComponent(Integer(Caller.Params[0]))))
  end
  else if ClassType = TfsXMLItem then
  begin
    _TfsXMLItem := TfsXMLItem(Instance);
    if MethodName = 'CREATE' then
      Result := Integer(_TfsXMLItem.Create)
    else if MethodName = 'ADDITEM' then
      _TfsXMLItem.AddItem(TfsXMLItem(Integer(Caller.Params[0])))
    else if MethodName = 'CLEAR' then
      _TfsXMLItem.Clear
    else if MethodName = 'INSERTITEM' then
      _TfsXMLItem.InsertItem(Caller.Params[0], TfsXMLItem(Integer(Caller.Params[1])))
    else if MethodName = 'ADD' then
      Result := Integer(_TfsXMLItem.Add)
    else if MethodName = 'FIND' then
      Result := _TfsXMLItem.Find(Caller.Params[0])
    else if MethodName = 'FINDITEM' then
      Result := Integer(_TfsXMLItem.FindItem(Caller.Params[0]))
    else if MethodName = 'PROP.GET' then
      Result := _TfsXMLItem.Prop[Caller.Params[0]]
    else if MethodName = 'PROP.SET' then
      _TfsXMLItem.Prop[Caller.Params[0]] := Caller.Params[1]
    else if MethodName = 'ROOT' then
      Result := Integer(_TfsXMLItem.Root)
    else if MethodName = 'ROOT' then
      Result := Integer(_TfsXMLItem.Root)
    else if MethodName = 'ITEMS.GET' then
      Result := Integer(_TfsXMLItem[Caller.Params[0]])
  end
  else if ClassType = TfsXMLDocument then
  begin
    _TfsXMLDocument := TfsXMLDocument(Instance);
    if MethodName = 'CREATE' then
      Result := Integer(_TfsXMLDocument.Create)
    else if MethodName = 'SAVETOSTREAM' then
      _TfsXMLDocument.SaveToStream(TStream(Integer(Caller.Params[0])))
    else if MethodName = 'LOADFROMSTREAM' then
      _TfsXMLDocument.LoadFromStream(TStream(Integer(Caller.Params[0])))
    else if MethodName = 'SAVETOFILE' then
      _TfsXMLDocument.SaveToFile(Caller.Params[0])
    else if MethodName = 'LOADFROMFILE' then
      _TfsXMLDocument.LoadFromFile(Caller.Params[0])
  end
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
      Result := Integer(TComponent(Instance).Owner)
  end
  else if ClassType = TfsXMLItem then
  begin
    if PropName = 'DATA' then
      Result := Integer(TfsXMLItem(Instance).Data)
    else if PropName = 'COUNT' then
      Result := TfsXMLItem(Instance).Count
    else if PropName = 'NAME' then
      Result := TfsXMLItem(Instance).Name
    else if PropName = 'PARENT' then
      Result := Integer(TfsXMLItem(Instance).Parent)
    else if PropName = 'TEXT' then
      Result := TfsXMLItem(Instance).Text
  end
  else if ClassType = TfsXMLDocument then
  begin
    if PropName = 'ROOT' then
      Result := Integer(TfsXMLDocument(Instance).Root)
  end
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
      TfsXMLItem(Instance).Data := Pointer(Integer(Value))
    else if PropName = 'NAME' then
      TfsXMLItem(Instance).Name := Value
    else if PropName = 'TEXT' then
      TfsXMLItem(Instance).Text := Value
  end
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
