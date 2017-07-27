
{******************************************}
{                                          }
{             FastScript v1.9              }
{        ADO classes and functions         }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iadortti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_itools, fs_idbrtti,
  DB, ADODB, ADOInt;

type
  TfsADORTTI = class(TComponent); // fake component


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
    AddType('TDataType', fvtInt);
    AddClass(TADOConnection, 'TComponent');
    AddClass(TParameter, 'TCollectionItem');
    with AddClass(TParameters, 'TCollection') do
    begin
      AddMethod('function AddParameter: TParameter', CallMethod);
      AddDefaultProperty('Items', 'Integer', 'TParameter', CallMethod, True);
    end;
    with AddClass(TCustomADODataSet, 'TDataSet') do
    begin
      AddProperty('Sort', 'WideString', GetProp, SetProp);
    end;
    AddClass(TADOTable, 'TCustomADODataSet');
    with AddClass(TADOQuery, 'TCustomADODataSet') do
      AddMethod('procedure ExecSQL', CallMethod);
    with AddClass(TADOStoredProc, 'TCustomADODataSet') do
      AddMethod('procedure ExecProc', CallMethod);
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;

  if ClassType = TParameters then
  begin
    if MethodName = 'ADDPARAMETER' then
      Result := Integer(TParameters(Instance).AddParameter)
    else if MethodName = 'ITEMS.GET' then
      Result := Integer(TParameters(Instance).Items[Caller.Params[0]])
  end
  else if ClassType = TADOQuery then
  begin
    if MethodName = 'EXECSQL' then
      TADOQuery(Instance).ExecSQL
  end
  else if ClassType = TADOStoredProc then
  begin
    if MethodName = 'EXECPROC' then
      TADOStoredProc(Instance).ExecProc
  end
end;


function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TCustomADODataSet then
  begin
    if PropName = 'SORT' then
      Result := TCustomADODataSet(Instance).Sort;
  end
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin

  if ClassType = TCustomADODataSet then
  begin
    if PropName = 'SORT' then
      TCustomADODataSet(Instance).Sort := Value;
  end

end;

initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.

