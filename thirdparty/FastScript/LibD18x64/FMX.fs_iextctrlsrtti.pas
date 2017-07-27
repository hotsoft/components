
{******************************************}
{                                          }
{             FastScript v1.9              }
{                 ExtCtrls                 }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMX.fs_iextctrlsrtti;

interface

{$i fs.inc}

uses System.SysUtils, System.Classes, FMX.fs_iinterpreter, FMX.fs_ievents, FMX.fs_iformsrtti
, FMX.ExtCtrls, FMX.ListBox, FMX.Objects, System.UITypes, FMX.Types, FMX.Controls, FMX.Layouts,
  FMX.TabControl, FMX.TreeView
{$IFDEF DELPHI18}
  , FMX.StdCtrls
{$ENDIF};

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TfsExtCtrlsRTTI = class(TComponent); // fake component


implementation

type
  TfsTreeViewDragChange = class(TfsCustomEvent)
  public
    procedure DoEvent(SourceItem, DestItem: TTreeViewItem; var Allow: Boolean);
    function GetMethod: Pointer; override;
  end;

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


    with AddClass(TPaintBox, 'TControl') do
      AddEvent('OnPaint', TfsNotifyEvent);
    AddClass(TImage, 'TControl');
    with AddClass(TTimer, 'TComponent') do
      AddEvent('OnTimer', TfsNotifyEvent);

    AddClass(TTabItem, 'TTextControl');
    with AddClass(TTabControl, 'TStyledControl') do
    begin
      AddIndexProperty( 'Tabs', 'Integer', 'TTabItem', CallMethod);
      AddEvent('OnChange', TfsNotifyEvent);
      AddProperty('TabCount', 'Integer', GetProp, nil);
      AddProperty('ActiveTab', 'TTabItem', GetProp, SetProp);
    end;

    with AddClass(TTreeViewItem, 'TTextControl') do
    begin
      AddMethod('function ItemByPoint(const X, Y: Single): TTreeViewItem', CallMethod);
      AddMethod('function ItemByIndex(const Idx: Integer): TTreeViewItem', CallMethod);
      AddMethod('function TreeView: TCustomTreeView', CallMethod);
      AddMethod('function Level: Integer', CallMethod);
      AddMethod('function ParentItem: TTreeViewItem', CallMethod);
      AddIndexProperty( 'Items', 'Integer', 'TTreeViewItem', CallMethod);
      AddProperty('GlobalIndex', 'Integer', GetProp, SetProp);
      AddProperty('Count', 'Integer', GetProp, nil);
    end;
    with AddClass(TTreeView, 'TScrollBox') do
    begin
      AddMethod('procedure Clear', CallMethod);
      AddMethod('procedure CollapseAll', CallMethod);
      AddMethod('procedure ExpandAll', CallMethod);
      AddMethod('function ItemByText(const AText: string): TTreeViewItem', CallMethod);
      AddMethod('function ItemByPoint(const X, Y: Single): TTreeViewItem', CallMethod);
      AddMethod('function ItemByIndex(const Idx: Integer): TTreeViewItem', CallMethod);
      AddMethod('function ItemByGlobalIndex(const Idx: Integer): TTreeViewItem', CallMethod);
      AddIndexProperty('Items', 'Integer', 'TTreeViewItem', CallMethod);
      AddProperty('Selected', 'TTreeViewItem', GetProp, SetProp);
      AddProperty('Count', 'Integer', GetProp, nil);
      AddProperty('GlobalCount', 'Integer', GetProp, nil);
      AddProperty('CountExpanded', 'Integer', GetProp, nil);
      AddEvent('OnChange', TfsNotifyEvent);
      AddEvent('OnChangeCheck', TfsNotifyEvent);
      AddEvent('OnDragChange', TfsTreeViewDragChange);
    end;

    { TODO ADD necessary methods for these calasses }
    //AddClass(TCalendar, 'TStyledControl');
    //AddClass(TCalendarBox, 'TTextControl');
   // AddClass(TCalendarEdit, 'TCustomEdit');
    AddClass(TImageViewer, 'TScrollBox');
    AddClass(TPlotGrid, 'TControl');
    AddClass(TDropTarget, 'TTextControl');
    AddClass(TCornerButton, 'TCustomButton');
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
begin
  Result := 0;
  if ClassType = TTabControl then
  begin
    if MethodName = 'TABS.GET' then
      Result := frxInteger(TTabControl(Instance).Tabs[Caller.Params[0]])
  end
  else if ClassType = TTreeViewItem then
  begin
    if MethodName = 'ITEMS.GET' then
      Result := frxInteger(TTreeViewItem(Instance).Items[Caller.Params[0]])
    else if MethodName = 'ITEMBYPOINT' then
      Result := frxInteger(TTreeViewItem(Instance).ItemByPoint(Single(Caller.Params[0]), Single(Caller.Params[1])))
    else if MethodName = 'ITEMBYINDEX' then
      Result := frxInteger(TTreeViewItem(Instance).ItemByIndex(Caller.Params[0]))
    else if MethodName = 'TREEVIEW' then
      Result := frxInteger(TTreeViewItem(Instance).TreeView)
    else if MethodName = 'LEVEL' then
      Result := Integer(TTreeViewItem(Instance).Level)
    else if MethodName = 'PARENTITEM' then
      Result := frxInteger(TTreeViewItem(Instance).ParentItem)
  end
  else if ClassType = TTreeView then
  begin
  if MethodName = 'ITEMS.GET' then
      Result := frxInteger(TTreeView(Instance).Items[Caller.Params[0]])
    else if MethodName = 'ITEMBYPOINT' then
      Result := frxInteger(TTreeView(Instance).ItemByPoint(Single(Caller.Params[0]), Single(Caller.Params[1])))
    else if MethodName = 'ITEMBYINDEX' then
      Result := frxInteger(TTreeView(Instance).ItemByIndex(Caller.Params[0]))
    else if MethodName = 'ITEMBYTEXT' then
      Result := frxInteger(TTreeView(Instance).ItemByText(String(Caller.Params[0])))
    else if MethodName = 'ITEMBYGLOBALINDEX' then
      Result := frxInteger(TTreeView(Instance).ItemByGlobalIndex(Caller.Params[0]))
    else if MethodName = 'CLEAR' then
      TTreeView(Instance).Clear
    else if MethodName = 'COLLAPSEALL' then
      TTreeView(Instance).CollapseAll
    else if MethodName = 'EXPANDALL' then
      TTreeView(Instance).ExpandAll
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;
  if ClassType = TTabControl then
  begin
    if PropName = 'TABCOUNT' then
      Result := TTabControl(Instance).TabCount
    else if PropName = 'ACTIVETAB' then
      Result := frxInteger(TTabControl(Instance).ActiveTab)
  end
  else if ClassType = TTreeViewItem then
  begin
    if PropName = 'GLOBALINDEX' then
      Result := TTreeViewItem(Instance).GlobalIndex
    else if PropName = 'COUNT' then
      Result := TTreeViewItem(Instance).Count
  end
  else if ClassType = TTreeView then
  begin
    if PropName = 'SELECTED' then
      Result := frxInteger(TTreeView(Instance).Selected)
    else if PropName = 'COUNT' then
      Result := TTreeView(Instance).Count
    else if PropName = 'GLOBALCOUNT' then
      Result := TTreeView(Instance).GlobalCount
    else if PropName = 'COUNTEXPANDED' then
      Result := TTreeView(Instance).CountExpanded
  end
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TTabControl then
  begin
    if PropName = 'ACTIVETAB' then
      TTabControl(Instance).ActiveTab := TTabItem(frxInteger(Value))
  end
  else if ClassType = TTreeViewItem then
  begin
//    if PropName = 'GLOBALINDEX' then
//      TTreeViewItem(Instance).GlobalIndex := Value
  end
  else if ClassType = TTreeView then
  begin
    if PropName = 'SELECTED' then
      TTreeView(Instance).Selected := TTreeViewItem(frxInteger(Value))
  end
end;

{ TfsTreeViewDragChange }

procedure TfsTreeViewDragChange.DoEvent(SourceItem, DestItem: TTreeViewItem;
  var Allow: Boolean);
begin
  CallHandler([SourceItem, DestItem, Allow]);
  Allow := Handler.Params[2].Value;
end;

function TfsTreeViewDragChange.GetMethod: Pointer;
begin
  Result := @TfsTreeViewDragChange.DoEvent;
end;

initialization
  StartClassGroup(TFmxObject);
  ActivateClassGroup(TFmxObject);
  GroupDescendentsWith(TfsExtCtrlsRTTI, TFmxObject);
  fsRTTIModules.Add(TFunctions);

finalization
  fsRTTIModules.Remove(TFunctions);

end.
