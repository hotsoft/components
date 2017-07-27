
{******************************************}
{                                          }
{             FastScript v1.9              }
{        IBX classes and functions         }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iibxrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_itools, fs_idbrtti, db, ibdatabase,
  IBCustomDataSet, IBQuery, IBTable, IBStoredProc;

type
  TfsIBXRTTI = class(TComponent); // fake component


implementation

type
  TFunctions = class (TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass; const MethodName: 
            String; Caller: TfsMethodHelper): Variant;
    function RecordCount(Instance: TObject; ClassType: TClass; const PropName: 
            String): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;
  

{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddClass(TIBDataBase, 'TComponent');
  
    with AddClass(TIBTransaction, 'TComponent') do
     begin
      AddMethod('procedure Commit', CallMethod);
      AddMethod('procedure RollBack', CallMethod);
      AddMethod('procedure StartTransaction', CallMethod);
     end;
  
    AddClass(TIBCustomDataSet, 'TDataSet');
    AddClass(TIBTable, 'TIBCustomDataSet');
    with AddClass(TIBQuery, 'TIBCustomDataSet') do
     begin
      AddMethod('procedure ExecSQL', CallMethod);
      AddMethod('procedure FetchAll', CallMethod);
      AddProperty('RecordCount', 'Integer',RecordCount, nil);
     end;
    with AddClass(TIBStoredProc, 'TIBCustomDataSet') do
      AddMethod('procedure ExecProc', CallMethod);
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass; const 
        MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;
  
  if ClassType = TIBQuery then
  begin
    if MethodName = 'EXECSQL' then
      TIBQuery(Instance).ExecSQL
    else
    if MethodName = 'FETCHALL' then
     TIBQuery(Instance).FETCHALL;
  end
  else
  if ClassType = TIBStoredProc then
  begin
    if MethodName = 'EXECPROC' then
      TIBStoredProc(Instance).ExecProc
  end
  else
    if(ClassType = TIBTransaction) AND (MethodName = 'COMMIT') then
          TIBTransaction(Instance).Commit
  else
    if (ClassType = TIBTransaction) AND (MethodName = 'ROLLBACK') then
          TIBTransaction(Instance).RollBack
  else
    if(ClassType = TIBTransaction) AND (MethodName = 'STARTTRANSACTION') then
          TIBTransaction(Instance).StartTransaction;
  
end;

function TFunctions.RecordCount(Instance: TObject; ClassType: TClass; const 
        PropName: String): Variant;
begin
  Result:=0;
  if (ClassType = TIBQuery) AND (PropName = 'RECORDCOUNT') then
      Result:=TIBQuery(Instance).RecordCount;
  
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
