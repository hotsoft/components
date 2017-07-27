
{******************************************}
{                                          }
{             FastScript v1.9              }
{        BDE classes and functions         }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_ibdertti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_itools, fs_idbrtti,
  DB, DBTables;

type
  TfsBDERTTI = class(TComponent); // fake component


implementation

type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
    function GetProp(Instance: TObject; ClassType: TClass;
      const PropName: String): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;


{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddEnum('TTableType', 'ttDefault, ttParadox, ttDBase, ttFoxPro, ttASCII');
    AddEnum('TParamBindMode', 'pbByName, pbByNumber');

    AddClass(TSession, 'TComponent');
    AddClass(TDatabase, 'TComponent');
    AddClass(TBDEDataSet, 'TDataSet');
    AddClass(TDBDataSet, 'TBDEDataSet');
    with AddClass(TTable, 'TDBDataSet') do
    begin
      AddMethod('procedure CreateTable', CallMethod);
      AddMethod('procedure DeleteTable', CallMethod);
      AddMethod('procedure EmptyTable', CallMethod);
      AddMethod('function FindKey(const KeyValues: array): Boolean', CallMethod);
      AddMethod('procedure FindNearest(const KeyValues: array)', CallMethod);
      AddMethod('procedure RenameTable(const NewTableName: string)', CallMethod);
    end;
    with AddClass(TQuery, 'TDBDataSet') do
    begin
      AddMethod('procedure ExecSQL', CallMethod);
      AddMethod('function ParamByName(const Value: string): TParam', CallMethod);
      AddMethod('procedure Prepare', CallMethod);
      AddProperty('ParamCount', 'Word', GetProp, nil);
    end;
    with AddClass(TStoredProc, 'TDBDataSet') do
    begin
      AddMethod('procedure ExecProc', CallMethod);
      AddMethod('function ParamByName(const Value: string): TParam', CallMethod);
      AddMethod('procedure Prepare', CallMethod);
      AddProperty('ParamCount', 'Word', GetProp, nil);
    end;
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;

  function DoFindKey: Boolean;
  var
    ar: TVarRecArray;
  begin
    VariantToVarRec(Caller.Params[0], ar);
    Result := TTable(Instance).FindKey(ar);
    ClearVarRec(ar);
  end;

  procedure DoFindNearest;
  var
    ar: TVarRecArray;
  begin
    VariantToVarRec(Caller.Params[0], ar);
    TTable(Instance).FindNearest(ar);
    ClearVarRec(ar);
  end;

begin
  Result := 0;

  if ClassType = TTable then
  begin
    if MethodName = 'CREATETABLE' then
      TTable(Instance).CreateTable
    else if MethodName = 'DELETETABLE' then
      TTable(Instance).DeleteTable
    else if MethodName = 'EMPTYTABLE' then
      TTable(Instance).EmptyTable
    else if MethodName = 'FINDKEY' then
      Result := DoFindKey
    else if MethodName = 'FINDNEAREST' then
      DoFindNearest
    else if MethodName = 'RENAMETABLE' then
      TTable(Instance).RenameTable(Caller.Params[0])
  end
  else if ClassType = TQuery then
  begin
    if MethodName = 'EXECSQL' then
      TQuery(Instance).ExecSQL
    else if MethodName = 'PARAMBYNAME' then
      Result := Integer(TQuery(Instance).ParamByName(Caller.Params[0]))
    else if MethodName = 'PREPARE' then
      TQuery(Instance).Prepare
  end
  else if ClassType = TStoredProc then
  begin
    if MethodName = 'EXECPROC' then
      TStoredProc(Instance).ExecProc
    else if MethodName = 'PARAMBYNAME' then
      Result := Integer(TStoredProc(Instance).ParamByName(Caller.Params[0]))
    else if MethodName = 'PREPARE' then
      TStoredProc(Instance).Prepare
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TQuery then
  begin
    if PropName = 'PARAMCOUNT' then
      Result := TQuery(Instance).ParamCount
  end
  else if ClassType = TStoredProc then
  begin
    if PropName = 'PARAMCOUNT' then
      Result := TStoredProc(Instance).ParamCount
  end
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
