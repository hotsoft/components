
{******************************************}
{                                          }
{             FastScript v1.9              }
{               DB controls                }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_idbctrlsrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_itools, fs_iformsrtti, fs_idbrtti, DB
{$IFDEF CLX}
, QDBCtrls, QDBGrids
{$ELSE}
, DBCtrls, DBGrids
{$ENDIF};


type
  TfsDBCtrlsRTTI = class(TComponent); // fake component


implementation

type
{$IFNDEF FPC}
  THackDBLookupControl = class(TDBLookupControl);
{$ENDIF}

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
    AddEnumSet('TButtonSet', 'nbFirst, nbPrior, nbNext, nbLast,' +
      'nbInsert, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh');
    AddEnum('TColumnButtonStyle', 'cbsAuto, cbsEllipsis, cbsNone');
    AddEnumSet('TDBGridOptions', 'dgEditing, dgAlwaysShowEditor, dgTitles,' +
      'dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect,' +
      'dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect');

    AddClass(TDBEdit, 'TWinControl');
    AddClass(TDBText, 'TGraphicControl');
    with AddClass(TDBCheckBox, 'TWinControl') do
      AddProperty('Checked', 'Boolean', GetProp, nil);
    with AddClass(TDBComboBox, 'TCustomComboBox') do
      AddProperty('Text', 'String', GetProp, nil);
    AddClass(TDBListBox, 'TCustomListBox');
    with AddClass(TDBRadioGroup, 'TWinControl') do
    begin
      AddProperty('ItemIndex', 'Integer', GetProp, nil);
      AddProperty('Value', 'String', GetProp, nil);
    end;
    AddClass(TDBMemo, 'TWinControl');
    AddClass(TDBImage, 'TCustomControl');
    AddClass(TDBNavigator, 'TWinControl');
{$IFNDEF FPC}
    with AddClass(TDBLookupControl, 'TCustomControl') do
      AddProperty('KeyValue', 'Variant', GetProp, SetProp);
    with AddClass(TDBLookupListBox, 'TDBLookupControl') do
      AddProperty('SelectedItem', 'String', GetProp, nil);
    with AddClass(TDBLookupComboBox, 'TDBLookupControl') do
      AddProperty('Text', 'String', GetProp, nil);
{$ENDIF}
    AddClass(TColumnTitle, 'TPersistent');
    AddClass(TColumn, 'TPersistent');
    with AddClass(TDBGridColumns, 'TCollection') do
    begin
      AddMethod('function Add: TColumn', CallMethod);
      AddMethod('procedure RebuildColumns', CallMethod);
      AddMethod('procedure RestoreDefaults', CallMethod);
      AddDefaultProperty('Items', 'Integer', 'TColumn', CallMethod, True);
    end;
    AddClass(TDBGrid, 'TWinControl');
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;

  if ClassType = TDBGridColumns then
  begin
    if MethodName = 'ADD' then
      Result := Integer(TDBGridColumns(Instance).Add)
    else if MethodName = 'ITEMS.GET' then
      Result := Integer(TDBGridColumns(Instance).Items[Caller.Params[0]])
{$IFNDEF FPC}
    else if MethodName = 'REBUILDCOLUMNS' then
      TDBGridColumns(Instance).RebuildColumns
    else if MethodName = 'RESTOREDEFAULTS' then
      TDBGridColumns(Instance).RestoreDefaults
{$ENDIF}
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TDBCheckBox then
  begin
    if PropName = 'CHECKED' then
      Result := TDBCheckBox(Instance).Checked
  end
  else if ClassType = TDBComboBox then
  begin
    if PropName = 'TEXT' then
      Result := TDBComboBox(Instance).Text
  end
  else if ClassType = TDBRadioGroup then
  begin
    if PropName = 'ITEMINDEX' then
      Result := TDBRadioGroup(Instance).ItemIndex
    else if PropName = 'VALUE' then
      Result := TDBRadioGroup(Instance).Value
  end
{$IFNDEF FPC}
  else if ClassType = TDBLookupControl then
  begin
    if PropName = 'KEYVALUE' then
      Result := THackDBLookupControl(Instance).KeyValue
  end
  else if ClassType = TDBLookupListBox then
  begin
    if PropName = 'SELECTEDITEM' then
      Result := TDBLookupListBox(Instance).SelectedItem
  end
  else if ClassType = TDBLookupComboBox then
  begin
    if PropName = 'TEXT' then
      Result := TDBLookupComboBox(Instance).Text
  end
{$ENDIF}
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
{$IFNDEF FPC}
  if ClassType = TDBLookupControl then
  begin
    if PropName = 'KEYVALUE' then
      THackDBLookupControl(Instance).KeyValue := Value
  end
{$ENDIF}
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
