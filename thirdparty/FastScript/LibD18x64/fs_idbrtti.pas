
{******************************************}
{                                          }
{             FastScript v1.9              }
{       DB.pas classes and functions       }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_idbrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_itools, fs_iclassesrtti, fs_ievents,
  DB;

type
  TfsDBRTTI = class(TComponent); // fake component

  TfsDatasetNotifyEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Dataset: TDataset);
    function GetMethod: Pointer; override;
  end;

  TfsFilterRecordEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(DataSet: TDataSet; var Accept: Boolean);
    function GetMethod: Pointer; override;
  end;

  TfsFieldGetTextEvent = class(TfsCustomEvent)
  public
    procedure DoEvent(Sender: TField; var Text: String; DisplayText: Boolean);
    function GetMethod: Pointer; override;
  end;


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


{ TfsDatasetNotifyEvent }

procedure TfsDatasetNotifyEvent.DoEvent(Dataset: TDataset);
begin
  CallHandler([Dataset]);
end;

function TfsDatasetNotifyEvent.GetMethod: Pointer;
begin
  Result := @TfsDatasetNotifyEvent.DoEvent;
end;


{ TfsFilterRecordEvent }

procedure TfsFilterRecordEvent.DoEvent(DataSet: TDataSet; var Accept: Boolean);
begin
  CallHandler([DataSet, Accept]);
  Accept := Handler.Params[1].Value;
end;

function TfsFilterRecordEvent.GetMethod: Pointer;
begin
  Result := @TfsFilterRecordEvent.DoEvent;
end;


{ TfsFieldGetTextEvent }

procedure TfsFieldGetTextEvent.DoEvent(Sender: TField; var Text: String; DisplayText: Boolean);
begin
  CallHandler([Sender, Text, DisplayText]);
  Text := Handler.Params[1].Value;
end;

function TfsFieldGetTextEvent.GetMethod: Pointer;
begin
  Result := @TfsFieldGetTextEvent.DoEvent;
end;


{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddEnum('TFieldType', 'ftUnknown, ftString, ftSmallint, ftInteger, ftWord,' +
      'ftBoolean, ftFloat, ftCurrency, ftBCD, ftDate, ftTime, ftDateTime,' +
      'ftBytes, ftVarBytes, ftAutoInc, ftBlob, ftMemo, ftGraphic, ftFmtMemo,' +
      'ftParadoxOle, ftDBaseOle, ftTypedBinary, ftCursor, ftFixedChar, ftWideString,' +
      'ftLargeint, ftADT, ftArray, ftReference, ftDataSet, ftOraBlob, ftOraClob,' +
      'ftVariant, ftInterface, ftIDispatch, ftGuid, ftTimeStamp, ftFMTBcd');
    AddEnum('TBlobStreamMode', 'bmRead, bmWrite, bmReadWrite');
    AddEnumSet('TLocateOptions', 'loCaseInsensitive, loPartialKey');
    AddEnumSet('TFilterOptions', 'foCaseInsensitive, foNoPartialCompare');
    AddEnum('TParamType', 'ptUnknown, ptInput, ptOutput, ptInputOutput, ptResult');

    with AddClass(TField, 'TComponent') do
    begin
      AddProperty('AsBoolean', 'Boolean', GetProp, SetProp);
      AddProperty('AsCurrency', 'Currency', GetProp, SetProp);
      AddProperty('AsDateTime', 'TDateTime', GetProp, SetProp);
      AddProperty('AsFloat', 'Double', GetProp, SetProp);
      AddProperty('AsInteger', 'Integer', GetProp, SetProp);
      AddProperty('AsString', 'String', GetProp, SetProp);
      AddProperty('AsVariant', 'Variant', GetProp, SetProp);
      AddProperty('DataType', 'TFieldType', GetProp, nil);
      AddProperty('DisplayName', 'String', GetProp, nil);
      AddProperty('DisplayText', 'String', GetProp, nil);
      AddProperty('IsNull', 'Boolean', GetProp, nil);
      AddProperty('Size', 'Integer', GetProp, SetProp);
      AddProperty('Value', 'Variant', GetProp, SetProp);
      AddProperty('OldValue', 'Variant', GetProp, nil);
      AddEvent('OnGetText', TfsFieldGetTextEvent);
    end;
    with AddClass(TFields, 'TObject') do
      AddDefaultProperty('Fields', 'Integer', 'TField', CallMethod, True);
    AddClass(TStringField, 'TField');
    AddClass(TNumericField, 'TField');
    AddClass(TIntegerField, 'TNumericField');
    AddClass(TSmallIntField, 'TIntegerField');
    AddClass(TWordField, 'TIntegerField');
    AddClass(TAutoIncField, 'TIntegerField');
    AddClass(TFloatField, 'TNumericField');
    AddClass(TCurrencyField, 'TFloatField');
    AddClass(TBooleanField, 'TField');
    AddClass(TDateTimeField, 'TField');
    AddClass(TDateField, 'TDateTimeField');
    AddClass(TTimeField, 'TDateTimeField');
    AddClass(TBinaryField, 'TField');
    AddClass(TBytesField, 'TBinaryField');
    AddClass(TVarBytesField, 'TBinaryField');
    AddClass(TBCDField, 'TNumericField');
    with AddClass(TBlobField, 'TField') do
    begin
      AddMethod('procedure LoadFromFile(const FileName: String)', CallMethod);
      AddMethod('procedure LoadFromStream(Stream: TStream)', CallMethod);
      AddMethod('procedure SaveToFile(const FileName: String)', CallMethod);
      AddMethod('procedure SaveToStream(Stream: TStream)', CallMethod);
    end;
    AddClass(TMemoField, 'TBlobField');
    AddClass(TGraphicField, 'TBlobField');
    AddClass(TFieldDef, 'TPersistent');
    with AddClass(TFieldDefs, 'TObject') do
    begin
      AddMethod('function AddFieldDef: TFieldDef', CallMethod);
      AddMethod('function Find(const Name: string): TFieldDef', CallMethod);
      AddMethod('procedure Add(const Name: string; DataType: TFieldType; Size: Word; Required: Boolean)', CallMethod);
      AddMethod('procedure Clear', CallMethod);
      AddMethod('procedure Update', CallMethod);
      AddDefaultProperty('Items', 'Integer', 'TFieldDef', CallMethod, True);
    end;
    AddClass(TDataSource, 'TComponent');
    AddType('TBookmark', fvtVariant);
    with AddClass(TDataSet, 'TComponent') do
    begin
      AddMethod('procedure Open', CallMethod);
      AddMethod('procedure Close', CallMethod);
      AddMethod('procedure First', CallMethod);
      AddMethod('procedure Last', CallMethod);
      AddMethod('procedure Next', CallMethod);
      AddMethod('procedure Prior', CallMethod);
      AddMethod('procedure Cancel', CallMethod);
      AddMethod('procedure Delete', CallMethod);
      AddMethod('procedure Post', CallMethod);
      AddMethod('procedure Append', CallMethod);
      AddMethod('procedure Insert', CallMethod);
      AddMethod('procedure Edit', CallMethod);

      AddMethod('function FieldByName(const FieldName: string): TField', CallMethod);
      AddMethod('procedure GetFieldNames(List: TStrings)', CallMethod);
      AddMethod('function FindFirst: Boolean', CallMethod);
      AddMethod('function FindLast: Boolean', CallMethod);
      AddMethod('function FindNext: Boolean', CallMethod);
      AddMethod('function FindPrior: Boolean', CallMethod);
      AddMethod('procedure FreeBookmark(Bookmark: TBookmark)', CallMethod);
      AddMethod('function GetBookmark: TBookmark', CallMethod);
      AddMethod('procedure GotoBookmark(Bookmark: TBookmark)', CallMethod);
      AddMethod('function Locate(const KeyFields: string; const KeyValues: Variant;' +
        'Options: TLocateOptions): Boolean', CallMethod);
      AddMethod('function IsEmpty: Boolean', CallMethod);
      AddMethod('procedure EnableControls', CallMethod);
      AddMethod('procedure DisableControls', CallMethod);

      AddProperty('Bof', 'Boolean', GetProp, nil);
      AddProperty('Eof', 'Boolean', GetProp, nil);
      AddProperty('FieldCount', 'Integer', GetProp, nil);
      AddProperty('FieldDefs', 'TFieldDefs', GetProp, nil);
      AddProperty('Fields', 'TFields', GetProp, nil);
      AddProperty('Filter', 'string', GetProp, SetProp);
      AddProperty('Filtered', 'Boolean', GetProp, SetProp);
      AddProperty('FilterOptions', 'TFilterOptions', GetProp, SetProp);
      AddProperty('Active', 'Boolean', GetProp, SetProp);

      AddEvent('BeforeOpen', TfsDatasetNotifyEvent);
      AddEvent('AfterOpen', TfsDatasetNotifyEvent);
      AddEvent('BeforeClose', TfsDatasetNotifyEvent);
      AddEvent('AfterClose', TfsDatasetNotifyEvent);
      AddEvent('BeforeInsert', TfsDatasetNotifyEvent);
      AddEvent('AfterInsert', TfsDatasetNotifyEvent);
      AddEvent('BeforeEdit', TfsDatasetNotifyEvent);
      AddEvent('AfterEdit', TfsDatasetNotifyEvent);
      AddEvent('BeforePost', TfsDatasetNotifyEvent);
      AddEvent('AfterPost', TfsDatasetNotifyEvent);
      AddEvent('BeforeCancel', TfsDatasetNotifyEvent);
      AddEvent('AfterCancel', TfsDatasetNotifyEvent);
      AddEvent('BeforeDelete', TfsDatasetNotifyEvent);
      AddEvent('AfterDelete', TfsDatasetNotifyEvent);
      AddEvent('BeforeScroll', TfsDatasetNotifyEvent);
      AddEvent('AfterScroll', TfsDatasetNotifyEvent);
      AddEvent('OnCalcFields', TfsDatasetNotifyEvent);
      AddEvent('OnFilterRecord', TfsFilterRecordEvent);
      AddEvent('OnNewRecord', TfsDatasetNotifyEvent);
    end;

    with AddClass(TParam, 'TPersistent') do
    begin
      AddMethod('procedure Clear', CallMethod);
      AddProperty('AsBoolean', 'Boolean', GetProp, SetProp);
      AddProperty('AsCurrency', 'Currency', GetProp, SetProp);
      AddProperty('AsDateTime', 'TDateTime', GetProp, SetProp);
      AddProperty('AsFloat', 'Double', GetProp, SetProp);
      AddProperty('AsInteger', 'Integer', GetProp, SetProp);
      AddProperty('AsDate', 'TDate', GetProp, SetProp);
      AddProperty('AsTime', 'TTime', GetProp, SetProp);
      AddProperty('AsString', 'String', GetProp, SetProp);
      AddProperty('Bound', 'Boolean', GetProp, SetProp);
      AddProperty('IsNull', 'Boolean', GetProp, nil);
      AddProperty('Text', 'String', GetProp, SetProp);
    end;
    with AddClass(TParams, 'TPersistent') do
    begin
      AddMethod('function ParamByName(const Value: string): TParam', CallMethod);
      AddMethod('function FindParam(const Value: string): TParam', CallMethod);
      AddDefaultProperty('Items', 'Integer', 'TParam', CallMethod, True);
    end;
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  _TDataSet: TDataSet;

  function IntToLocateOptions(i: Integer): TLocateOptions;
  begin
    Result := [];
    if (i and 1) <> 0 then
      Result := Result + [loCaseInsensitive];
    if (i and 2) <> 0 then
      Result := Result + [loPartialKey];
  end;

begin
  Result := 0;

  if ClassType = TFields then
  begin
    if MethodName = 'FIELDS.GET' then
      Result := Integer(TFields(Instance)[Caller.Params[0]])
  end
  else if ClassType = TFieldDefs then
  begin
    if MethodName = 'ITEMS.GET' then
      Result := Integer(TFieldDefs(Instance)[Caller.Params[0]])
    else if MethodName = 'ADD' then
      TFieldDefs(Instance).Add(Caller.Params[0], TFieldType(Caller.Params[1]), Caller.Params[2], Caller.Params[3])
    else if MethodName = 'ADDFIELDDEF' then
      Result := Integer(TFieldDefs(Instance).AddFieldDef)
    else if MethodName = 'CLEAR' then
      TFieldDefs(Instance).Clear
    else if MethodName = 'FIND' then
      Result := Integer(TFieldDefs(Instance).Find(Caller.Params[0]))
    else if MethodName = 'UPDATE' then
      TFieldDefs(Instance).Update
  end
  else if ClassType = TBlobField then
  begin
    if MethodName = 'LOADFROMFILE' then
      TBlobField(Instance).LoadFromFile(Caller.Params[0])
    else if MethodName = 'LOADFROMSTREAM' then
      TBlobField(Instance).LoadFromStream(TStream(Integer(Caller.Params[0])))
    else if MethodName = 'SAVETOFILE' then
      TBlobField(Instance).SaveToFile(Caller.Params[0])
    else if MethodName = 'SAVETOSTREAM' then
      TBlobField(Instance).SaveToStream(TStream(Integer(Caller.Params[0])))
  end
  else if ClassType = TDataSet then
  begin
    _TDataSet := TDataSet(Instance);
    if MethodName = 'OPEN' then
      _TDataSet.Open
    else if MethodName = 'CLOSE' then
      _TDataSet.Close
    else if MethodName = 'FIRST' then
      _TDataSet.First
    else if MethodName = 'LAST' then
      _TDataSet.Last
    else if MethodName = 'NEXT' then
      _TDataSet.Next
    else if MethodName = 'PRIOR' then
      _TDataSet.Prior
    else if MethodName = 'CANCEL' then
      _TDataSet.Cancel
    else if MethodName = 'DELETE' then
      _TDataSet.Delete
    else if MethodName = 'POST' then
      _TDataSet.Post
    else if MethodName = 'APPEND' then
      _TDataSet.Append
    else if MethodName = 'INSERT' then
      _TDataSet.Insert
    else if MethodName = 'EDIT' then
      _TDataSet.Edit
    else if MethodName = 'FIELDBYNAME' then
      Result := Integer(_TDataSet.FieldByName(Caller.Params[0]))
    else if MethodName = 'GETFIELDNAMES' then
      _TDataSet.GetFieldNames(TStrings(Integer(Caller.Params[0])))
    else if MethodName = 'FINDFIRST' then
      Result := _TDataSet.FindFirst
    else if MethodName = 'FINDLAST' then
      Result := _TDataSet.FindLast
    else if MethodName = 'FINDNEXT' then
      Result := _TDataSet.FindNext
    else if MethodName = 'FINDPRIOR' then
      Result := _TDataSet.FindPrior
    else if MethodName = 'FREEBOOKMARK' then
      _TDataSet.FreeBookmark(TBookMark(Integer(Caller.Params[0])))
    else if MethodName = 'GETBOOKMARK' then
      Result := Integer(_TDataSet.GetBookmark)
    else if MethodName = 'GOTOBOOKMARK' then
      _TDataSet.GotoBookmark(TBookMark(Integer(Caller.Params[0])))
    else if MethodName = 'LOCATE' then
      Result := _TDataSet.Locate(Caller.Params[0], Caller.Params[1], IntToLocateOptions(Caller.Params[2]))
    else if MethodName = 'ISEMPTY' then
      Result := _TDataSet.IsEmpty
    else if MethodName = 'ENABLECONTROLS' then
      _TDataSet.EnableControls
    else if MethodName = 'DISABLECONTROLS' then
      _TDataSet.DisableControls
  end
  else if ClassType = TParam then
  begin
    if MethodName = 'CLEAR' then
      TParam(Instance).Clear
  end
  else if ClassType = TParams then
  begin
    if MethodName = 'PARAMBYNAME' then
      Result := Integer(TParams(Instance).ParamByName(Caller.Params[0]))
    else if MethodName = 'FINDPARAM' then
      Result := Integer(TParams(Instance).FindParam(Caller.Params[0]))
    else if MethodName = 'ITEMS.GET' then
      Result := Integer(TParams(Instance)[Caller.Params[0]])
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
var
  _TField: TField;
  _TParam: TParam;
  _TDataSet: TDataSet;

  function FilterOptionsToInt(f: TFilterOptions): Integer;
  begin
    Result := 0;
    if foCaseInsensitive in f then
      Result := Result or 1;
    if foNoPartialCompare in f then
      Result := Result or 2;
  end;

begin
  Result := 0;

  if ClassType = TField then
  begin
    _TField := TField(Instance);
    if PropName = 'ASBOOLEAN' then
      Result := _TField.AsBoolean
    else if PropName = 'ASCURRENCY' then
      Result := _TField.AsCurrency
    else if PropName = 'ASDATETIME' then
      Result := _TField.AsDateTime
    else if PropName = 'ASFLOAT' then
      Result := _TField.AsFloat
    else if PropName = 'ASINTEGER' then
      Result := _TField.AsInteger
    else if PropName = 'ASSTRING' then
      Result := _TField.AsString
    else if PropName = 'ASVARIANT' then
      Result := _TField.AsVariant
    else if PropName = 'DATATYPE' then
      Result := _TField.DataType
    else if PropName = 'DISPLAYNAME' then
      Result := _TField.DisplayName
    else if PropName = 'DISPLAYTEXT' then
      Result := _TField.DisplayText
    else if PropName = 'ISNULL' then
      Result := _TField.IsNull
    else if PropName = 'SIZE' then
      Result := _TField.Size
    else if PropName = 'VALUE' then
      Result := _TField.Value
    else if PropName = 'OLDVALUE' then
      Result := _TField.OldValue
  end
  else if ClassType = TDataSet then
  begin
    _TDataSet := TDataSet(Instance);
    if PropName = 'BOF' then
      Result := _TDataSet.Bof
    else if PropName = 'EOF' then
      Result := _TDataSet.Eof
    else if PropName = 'FIELDCOUNT' then
      Result := _TDataSet.FieldCount
    else if PropName = 'FIELDDEFS' then
      Result := Integer(_TDataSet.FieldDefs)
    else if PropName = 'FIELDS' then
      Result := Integer(_TDataSet.Fields)
    else if PropName = 'FILTER' then
      Result := _TDataSet.Filter
    else if PropName = 'FILTERED' then
      Result := _TDataSet.Filtered
    else if PropName = 'FILTEROPTIONS' then
      Result := FilterOptionsToInt(_TDataSet.FilterOptions)
    else if PropName = 'ACTIVE' then
      Result := _TDataSet.Active
  end
  else if ClassType = TParam then
  begin
    _TParam := TParam(Instance);
    if PropName = 'BOUND' then
      Result := _TParam.Bound
    else if PropName = 'ISNULL' then
      Result := _TParam.IsNull
    else if PropName = 'TEXT' then
      Result := _TParam.Text
    else if PropName = 'ASBOOLEAN' then
      Result := _TParam.AsBoolean
    else if PropName = 'ASCURRENCY' then
      Result := _TParam.AsCurrency
    else if PropName = 'ASDATETIME' then
      Result := _TParam.AsDateTime
    else if PropName = 'ASFLOAT' then
      Result := _TParam.AsFloat
    else if PropName = 'ASINTEGER' then
      Result := _TParam.AsInteger
    else if PropName = 'ASDATE' then
      Result := _TParam.AsDate
    else if PropName = 'ASTIME' then
      Result := _TParam.AsTime
    else if PropName = 'ASSTRING' then
      Result := _TParam.AsString
  end
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
var
  _TField: TField;
  _TParam: TParam;
  _TDataSet: TDataSet;

  function IntToFilterOptions(i: Integer): TFilterOptions;
  begin
    Result := [];
    if (i and 1) <> 0 then
      Result := Result + [foCaseInsensitive];
    if (i and 2) <> 0 then
      Result := Result + [foNoPartialCompare];
  end;

begin
  if ClassType = TField then
  begin
    _TField := TField(Instance);
    if PropName = 'ASBOOLEAN' then
      _TField.AsBoolean := Value
    else if PropName = 'ASCURRENCY' then
      _TField.AsCurrency := Value
    else if PropName = 'ASDATETIME' then
      _TField.AsDateTime := Value
    else if PropName = 'ASFLOAT' then
      _TField.AsFloat := Value
    else if PropName = 'ASINTEGER' then
      _TField.AsInteger := Value
    else if PropName = 'ASSTRING' then
      _TField.AsString := Value
    else if PropName = 'ASVARIANT' then
      _TField.AsVariant := Value
    else if PropName = 'VALUE' then
      _TField.Value := Value
   else if PropName = 'SIZE' then
     _TField.Size := Value
  end
  else if ClassType = TDataSet then
  begin
    _TDataSet := TDataSet(Instance);
    if PropName = 'FILTER' then
      _TDataSet.Filter := Value
    else if PropName = 'FILTERED' then
      _TDataSet.Filtered := Value
    else if PropName = 'FILTEROPTIONS' then
      _TDataSet.FilterOptions := IntToFilterOptions(Value)
    else if PropName = 'ACTIVE' then
      _TDataSet.Active := Value
  end
  else if ClassType = TParam then
  begin
    _TParam := TParam(Instance);
    if PropName = 'ASBOOLEAN' then
      _TParam.AsBoolean := Value
    else if PropName = 'ASCURRENCY' then
      _TParam.AsCurrency := Value
    else if PropName = 'ASDATETIME' then
      _TParam.AsDateTime := Value
    else if PropName = 'ASFLOAT' then
      _TParam.AsFloat := Value
    else if PropName = 'ASINTEGER' then
      _TParam.AsInteger := Value
    else if PropName = 'ASDATE' then
      _TParam.AsDate := Value
    else if PropName = 'ASTIME' then
      _TParam.AsTime := Value
    else if PropName = 'ASSTRING' then
      _TParam.AsString := Value
    else if PropName = 'BOUND' then
      _TParam.Bound := Value
    else if PropName = 'TEXT' then
      _TParam.Text := Value
  end
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
