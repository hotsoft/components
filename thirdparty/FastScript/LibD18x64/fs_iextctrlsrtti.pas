
{******************************************}
{                                          }
{             FastScript v1.9              }
{                 ExtCtrls                 }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iextctrlsrtti;

interface

{$i fs.inc}

uses SysUtils, Classes, fs_iinterpreter, fs_ievents, fs_iformsrtti
{$IFDEF CLX}
, QExtCtrls, QButtons, QCheckLst, QComCtrls
{$ELSE}
, ExtCtrls, Buttons, CheckLst, ComCtrls
{$ENDIF};

type
  TfsExtCtrlsRTTI = class(TComponent); // fake component


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
    AddEnum('TShapeType', 'stRectangle, stSquare, stRoundRect, stRoundSquare,' +
      'stEllipse, stCircle');
    AddEnum('TBevelStyle', 'bsLowered, bsRaised');
    AddEnum('TBevelShape', 'bsBox, bsFrame, bsTopLine, bsBottomLine, bsLeftLine,' +
      'bsRightLine, bsSpacer');
    AddEnum('TResizeStyle', 'rsNone, rsLine, rsUpdate, rsPattern');
    AddEnum('TButtonLayout', 'blGlyphLeft, blGlyphRight, blGlyphTop, blGlyphBottom');
    AddEnum('TButtonState', 'bsUp, bsDisabled, bsDown, bsExclusive');
    AddEnum('TButtonStyle', 'bsAutoDetect, bsWin31, bsNew');
    AddEnum('TBitBtnKind', 'bkCustom, bkOK, bkCancel, bkHelp, bkYes, bkNo,' +
      'bkClose, bkAbort, bkRetry, bkIgnore, bkAll');
    AddType('TNumGlyphs', fvtInt);
    AddEnum('TTabPosition', 'tpTop, tpBottom, tpLeft, tpRight');
    AddEnum('TTabStyle', 'tsTabs, tsButtons, tsFlatButtons');
    AddEnum('TStatusPanelStyle', 'psText, psOwnerDraw');
    AddEnum('TStatusPanelBevel', 'pbNone, pbLowered, pbRaised');
    AddEnum('TSortType', 'stNone, stData, stText, stBoth');
    AddEnum('TTrackBarOrientation', 'trHorizontal, trVertical');
    AddEnum('TTickMark', 'tmBottomRight, tmTopLeft, tmBoth');
    AddEnum('TTickStyle', 'tsNone, tsAuto, tsManual');
    AddEnum('TProgressBarOrientation', 'pbHorizontal, pbVertical');
    AddEnum('TIconArrangement', 'iaTop, iaLeft');
    AddEnum('TListArrangement', 'arAlignBottom, arAlignLeft, arAlignRight,' +
      'arAlignTop, arDefault, arSnapToGrid');
    AddEnum('TViewStyle', 'vsIcon, vsSmallIcon, vsList, vsReport');
    AddEnum('TToolButtonStyle', 'tbsButton, tbsCheck, tbsDropDown, tbsSeparator, tbsDivider');
    AddEnum('TDateTimeKind', 'dtkDate, dtkTime');
    AddEnum('TDTDateMode', 'dmComboBox, dmUpDown');
    AddEnum('TDTDateFormat', 'dfShort, dfLong');
    AddEnum('TDTCalAlignment', 'dtaLeft, dtaRight');
    AddEnum('TCalDayOfWeek', 'dowMonday, dowTuesday, dowWednesday, dowThursday,' +
      'dowFriday, dowSaturday, dowSunday, dowLocaleDefault');

    AddClass(TShape, 'TGraphicControl');
    with AddClass(TPaintBox, 'TGraphicControl') do
      AddEvent('OnPaint', TfsNotifyEvent);
    AddClass(TImage, 'TGraphicControl');
    AddClass(TBevel, 'TGraphicControl');
    with AddClass(TTimer, 'TComponent') do
      AddEvent('OnTimer', TfsNotifyEvent);
    AddClass(TPanel, 'TCustomControl');
    AddClass(TSplitter, 'TGraphicControl');
    AddClass(TBitBtn, 'TButton');
    AddClass(TSpeedButton, 'TGraphicControl');
    with AddClass(TCheckListBox, 'TCustomListBox') do
      AddIndexProperty('Checked', 'Integer', 'Boolean', CallMethod);
    AddClass(TTabControl, 'TWinControl');
    with AddClass(TTabSheet, 'TWinControl') do
      AddProperty('PageControl', 'TPageControl', GetProp, SetProp);
    with AddClass(TPageControl, 'TWinControl') do
    begin
      AddMethod('procedure SelectNextPage(GoForward: Boolean)', CallMethod);
      AddProperty('PageCount', 'Integer', GetProp, nil);
      AddIndexProperty('Pages', 'Integer', 'TTabSheet', CallMethod, True);
    end;
    AddClass(TStatusPanel, 'TPersistent');
    with AddClass(TStatusPanels, 'TPersistent') do
    begin
      AddMethod('function Add: TStatusPanel', CallMethod);
      AddIndexProperty('Items', 'Integer', 'TStatusPanel', CallMethod, True);
    end;
    AddClass(TStatusBar, 'TWinControl');
    with AddClass(TTreeNode, 'TPersistent') do
    begin
      AddMethod('procedure Delete', CallMethod);
      AddMethod('function EditText: Boolean', CallMethod);
      AddProperty('Count', 'Integer', GetProp, nil);
      AddProperty('Data', 'Pointer', GetProp, SetProp);
      AddProperty('ImageIndex', 'Integer', GetProp, SetProp);
      AddProperty('SelectedIndex', 'Integer', GetProp, SetProp);
      AddProperty('StateIndex', 'Integer', GetProp, SetProp);
      AddProperty('Text', 'String', GetProp, SetProp);
    end;
    with AddClass(TTreeNodes, 'TPersistent') do
    begin
      AddMethod('function Add(Node: TTreeNode; const S: string): TTreeNode', CallMethod);
      AddMethod('function AddChild(Node: TTreeNode; const S: string): TTreeNode', CallMethod);
      AddMethod('procedure BeginUpdate', CallMethod);
      AddMethod('procedure Clear', CallMethod);
      AddMethod('procedure Delete(Node: TTreeNode)', CallMethod);
      AddMethod('procedure EndUpdate', CallMethod);
      AddProperty('Count', 'Integer', GetProp, nil);
      AddDefaultProperty('Item', 'Integer', 'TTreeNode', CallMethod, True);
    end;
    with AddClass(TTreeView, 'TWinControl') do
    begin
      AddMethod('procedure FullCollapse', CallMethod);
      AddMethod('procedure FullExpand', CallMethod);
      AddProperty('Items', 'TTreeNodes', GetProp, nil);
      AddProperty('Selected', 'TTreeNode', GetProp, SetProp);
      AddProperty('TopItem', 'TTreeNode', GetProp, SetProp);
    end;
    AddClass(TTrackBar, 'TWinControl');
    AddClass(TProgressBar, 'TWinControl');
    AddClass(TListColumn, 'TPersistent');
    with AddClass(TListColumns, 'TPersistent') do
    begin
      AddMethod('function Add: TListColumn', CallMethod);
      AddDefaultProperty('Items', 'Integer', 'TListColumn', CallMethod, True);
    end;
    with AddClass(TListItem, 'TPersistent') do
    begin
      AddMethod('procedure Delete', CallMethod);
      AddMethod('function EditCaption: Boolean', CallMethod);
      AddProperty('Caption', 'String', GetProp, SetProp);
      AddProperty('Checked', 'Boolean', GetProp, SetProp);
      AddProperty('Data', 'Pointer', GetProp, SetProp);
      AddProperty('ImageIndex', 'Integer', GetProp, SetProp);
      AddProperty('Selected', 'Boolean', GetProp, SetProp);
      AddProperty('StateIndex', 'Integer', GetProp, SetProp);
      AddProperty('SubItems', 'TStrings', GetProp, SetProp);
    end;
    with AddClass(TListItems, 'TPersistent') do
    begin
      AddMethod('function Add: TListItem', CallMethod);
      AddMethod('procedure BeginUpdate', CallMethod);
      AddMethod('procedure Clear', CallMethod);
      AddMethod('procedure Delete(Index: Integer)', CallMethod);
      AddMethod('procedure EndUpdate', CallMethod);
      AddProperty('Count', 'Integer', GetProp, nil);
      AddDefaultProperty('Item', 'Integer', 'TListItem', CallMethod, True);
    end;
{$IFNDEF FPC}
    AddClass(TIconOptions, 'TPersistent');
{$ENDIF}
    AddClass(TListView, 'TWinControl');
    AddClass(TToolButton, 'TGraphicControl');
    AddClass(TToolBar, 'TWinControl');
{$IFNDEF CLX}
  {$IFNDEF FPC}
    AddClass(TMonthCalColors, 'TPersistent');
    AddClass(TDateTimePicker, 'TWinControl');
    AddClass(TMonthCalendar, 'TWinControl');
    AddClass(TCustomRichEdit, 'TWinControl');
    AddClass(TRichEdit, 'TCustomRichEdit');
  {$ENDIF}
{$ENDIF}
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;

  if ClassType = TCheckListBox then
  begin
    if MethodName = 'CHECKED.GET' then
      Result := TCheckListBox(Instance).Checked[Caller.Params[0]]
    else if MethodName = 'CHECKED.SET' then
      TCheckListBox(Instance).Checked[Caller.Params[0]] := Caller.Params[1]
  end
  else if ClassType = TPageControl then
  begin
    if MethodName = 'SELECTNEXTPAGE' then
      TPageControl(Instance).SelectNextPage(Caller.Params[0])
    else if MethodName = 'PAGES.GET' then
      Result := Integer(TPageControl(Instance).Pages[Caller.Params[0]])
  end
  else if ClassType = TStatusPanels then
  begin
    if MethodName = 'ADD' then
      Result := Integer(TStatusPanels(Instance).Add)
    else if MethodName = 'ITEMS.GET' then
      Result := Integer(TStatusPanels(Instance).Items[Caller.Params[0]])
  end
  else if ClassType = TTreeNode then
  begin
    if MethodName = 'DELETE' then
      TTreeNode(Instance).Delete
    else if MethodName = 'EDITTEXT' then
      Result := TTreeNode(Instance).EditText
  end
  else if ClassType = TTreeNodes then
  begin
    if MethodName = 'ADD' then
      Result := Integer(TTreeNodes(Instance).Add(TTreeNode(Integer(Caller.Params[0])),
        Caller.Params[1]))
    else if MethodName = 'ADDCHILD' then
      Result := Integer(TTreeNodes(Instance).AddChild(TTreeNode(Integer(Caller.Params[0])),
        Caller.Params[1]))
    else if MethodName = 'BEGINUPDATE' then
      TTreeNodes(Instance).BeginUpdate
    else if MethodName = 'CLEAR' then
      TTreeNodes(Instance).Clear
    else if MethodName = 'DELETE' then
      TTreeNodes(Instance).Delete(TTreeNode(Integer(Caller.Params[0])))
    else if MethodName = 'ENDUPDATE' then
      TTreeNodes(Instance).EndUpdate
    else if MethodName = 'ITEM.GET' then
      Result := Integer(TTreeNodes(Instance).Item[Caller.Params[0]])
  end
  else if ClassType = TTreeView then
  begin
    if MethodName = 'FULLCOLLAPSE' then
      TTreeView(Instance).FullCollapse
    else if MethodName = 'FULLEXPAND' then
      TTreeView(Instance).FullExpand
  end
  else if ClassType = TListColumns then
  begin
    if MethodName = 'ADD' then
      Result := Integer(TListColumns(Instance).Add)
    else if MethodName = 'ITEMS.GET' then
      Result := Integer(TListColumns(Instance).Items[Caller.Params[0]])
  end
  else if ClassType = TListItem then
  begin
    if MethodName = 'DELETE' then
      TListItem(Instance).Delete
{$IFNDEF CLX}
  {$IFNDEF FPC}
    else if MethodName = 'EDITCAPTION' then
      Result := TListItem(Instance).EditCaption
  {$ENDIF}
{$ENDIF}
  end
  else if ClassType = TListItems then
  begin
    if MethodName = 'ADD' then
      Result := Integer(TListItems(Instance).Add)
{$IFNDEF FPC}
    else if MethodName = 'BEGINUPDATE' then
      TListItems(Instance).BeginUpdate
{$ENDIF}
    else if MethodName = 'CLEAR' then
      TListItems(Instance).Clear
    else if MethodName = 'DELETE' then
      TListItems(Instance).Delete(Caller.Params[0])
{$IFNDEF FPC}
    else if MethodName = 'ENDUPDATE' then
      TListItems(Instance).EndUpdate
{$ENDIF}
    else if MethodName = 'ITEM.GET' then
      Result := Integer(TListItems(Instance).Item[Caller.Params[0]])
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TPageControl then
  begin
    if PropName = 'PAGECOUNT' then
      Result := TPageControl(Instance).PageCount
  end
  else if ClassType = TTabSheet then
  begin
    if PropName = 'PAGECONTROL' then
      Result := Integer(TTabSheet(Instance).PageControl)
  end
  else if ClassType = TTreeNode then
  begin
    if PropName = 'COUNT' then
      Result := TTreeNode(Instance).Count
    else if PropName = 'DATA' then
      Result := Integer(TTreeNode(Instance).Data)
    else if PropName = 'IMAGEINDEX' then
      Result := TTreeNode(Instance).ImageIndex
    else if PropName = 'SELECTEDINDEX' then
      Result := TTreeNode(Instance).SelectedIndex
{$IFNDEF CLX}
    else if PropName = 'STATEINDEX' then
      Result := TTreeNode(Instance).StateIndex
{$ENDIF}
    else if PropName = 'TEXT' then
      Result := TTreeNode(Instance).Text
  end
  else if ClassType = TTreeNodes then
  begin
    if PropName = 'COUNT' then
      Result := TTreeNodes(Instance).Count
  end
  else if ClassType = TTreeView then
  begin
    if PropName = 'ITEMS' then
      Result := Integer(TTreeView(Instance).Items)
    else if PropName = 'SELECTED' then
      Result := Integer(TTreeView(Instance).Selected)
    else if PropName = 'TOPITEM' then
      Result := Integer(TTreeView(Instance).TopItem)
  end
  else if ClassType = TListItem then
  begin
    if PropName = 'CAPTION' then
      Result := TListItem(Instance).Caption
    else if PropName = 'CHECKED' then
      Result := TListItem(Instance).Checked
    else if PropName = 'DATA' then
      Result := Integer(TListItem(Instance).Data)
    else if PropName = 'IMAGEINDEX' then
      Result := TListItem(Instance).ImageIndex
    else if PropName = 'SELECTED' then
      Result := TListItem(Instance).Selected
{$IFNDEF CLX}
  {$IFNDEF FPC}
    else if PropName = 'STATEINDEX' then
      Result := TListItem(Instance).StateIndex
  {$ENDIF}
{$ENDIF}
    else if PropName = 'SUBITEMS' then
      Result := Integer(TListItem(Instance).SubItems)
  end
  else if ClassType = TListItems then
  begin
    if PropName = 'COUNT' then
      Result := TListItems(Instance).Count
  end
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TTabSheet then
  begin
    if PropName = 'PAGECONTROL' then
      TTabSheet(Instance).PageControl := TPageControl(Integer(Value))
  end
  else if ClassType = TTreeNode then
  begin
    if PropName = 'DATA' then
      TTreeNode(Instance).Data := Pointer(Integer(Value))
    else if PropName = 'IMAGEINDEX' then
      TTreeNode(Instance).ImageIndex := Integer(Value)
    else if PropName = 'SELECTEDINDEX' then
      TTreeNode(Instance).SelectedIndex := Value
{$IFNDEF CLX}
    else if PropName = 'STATEINDEX' then
      TTreeNode(Instance).StateIndex := Value
{$ENDIF}
    else if PropName = 'TEXT' then
      TTreeNode(Instance).Text := Value
  end
  else if ClassType = TTreeView then
  begin
    if PropName = 'SELECTED' then
      TTreeView(Instance).Selected := TTreeNode(Integer(Value))
    else if PropName = 'TOPITEM' then
      TTreeView(Instance).TopItem := TTreeNode(Integer(Value))
  end
  else if ClassType = TListItem then
  begin
    if PropName = 'CAPTION' then
      TListItem(Instance).Caption := Value
    else if PropName = 'CHECKED' then
      TListItem(Instance).Checked := Value
    else if PropName = 'DATA' then
      TListItem(Instance).Data := Pointer(Integer(Value))
    else if PropName = 'IMAGEINDEX' then
      TListItem(Instance).ImageIndex := Integer(Value)
    else if PropName = 'SELECTED' then
      TListItem(Instance).Selected := Value
{$IFNDEF CLX}
  {$IFNDEF FPC}
    else if PropName = 'STATEINDEX' then
      TListItem(Instance).StateIndex := Value
  {$ENDIF}
{$ENDIF}
    else if PropName = 'SUBITEMS' then
      TListItem(Instance).SubItems := TStrings(Integer(Value))
  end
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
