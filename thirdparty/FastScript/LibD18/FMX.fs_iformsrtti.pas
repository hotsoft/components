
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Forms and StdCtrls            }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMX.fs_iformsrtti;

interface

{$i fs.inc}

uses
  System.SysUtils, System.Classes, FMX.fs_iinterpreter, FMX.fs_ievents, FMX.fs_iclassesrtti,
  FMX.fs_igraphicsrtti, FMX.Types, FMX.Controls, FMX.Forms, System.UITypes,
  FMX.Edit, FMX.Memo, FMX.ListBox, FMX.Layouts
{$IFDEF DELPHI18}
  , FMX.StdCtrls
{$ENDIF}
{$IFDEF DELPHI19}
  , FMX.Graphics
{$ENDIF}
  ;

type
{$IFDEF DELPHI16}
[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
{$ENDIF}
  TfsFormsRTTI = class(TComponent); // fake component


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
    AddConst('mrNone', 'Integer', mrNone);
    AddConst('mrOk', 'Integer', mrOk);
    AddConst('mrCancel', 'Integer', mrCancel);
    AddConst('mrAbort', 'Integer', mrAbort);
    AddConst('mrRetry', 'Integer', mrRetry);
    AddConst('mrIgnore', 'Integer', mrIgnore);
    AddConst('mrYes', 'Integer', mrYes);
    AddConst('mrNo', 'Integer', mrNo);
    AddConst('mrAll', 'Integer', mrAll);
    AddConst('mrNoToAll', 'Integer', mrNoToAll);
    AddConst('mrYesToAll', 'Integer', mrYesToAll);

    AddConst('crDefault', 'Integer', crDefault);
    AddConst('crNone', 'Integer', crNone);
    AddConst('crArrow', 'Integer', crArrow);
    AddConst('crCross', 'Integer', crCross);
    AddConst('crIBeam', 'Integer', crIBeam);
    AddConst('crSize', 'Integer', crSize);
    AddConst('crSizeNESW', 'Integer', crSizeNESW);
    AddConst('crSizeNS', 'Integer', crSizeNS);
    AddConst('crSizeNWSE', 'Integer', crSizeNWSE);
    AddConst('crSizeWE', 'Integer', crSizeWE);
    AddConst('crUpArrow', 'Integer', crUpArrow);
    AddConst('crHourGlass', 'Integer', crHourGlass);
    AddConst('crDrag', 'Integer', crDrag);
    AddConst('crNoDrop', 'Integer', crNoDrop);
    AddConst('crHSplit', 'Integer', crHSplit);
    AddConst('crVSplit', 'Integer', crVSplit);
    AddConst('crMultiDrag', 'Integer', crMultiDrag);
    AddConst('crSQLWait', 'Integer', crSQLWait);
    AddConst('crNo', 'Integer', crNo);
    AddConst('crAppStart', 'Integer', crAppStart);
    AddConst('crHelp', 'Integer', crHelp);
    AddConst('crHandPoint', 'Integer', crHandPoint);
    AddConst('crSizeAll', 'Integer', crSizeAll);

{$IFDEF CLX}
    AddConst('bsNone', 'Integer', fbsNone);
    AddConst('bsSingle', 'Integer', fbsSingle);
    AddConst('bsSizeable', 'Integer', fbsSizeable);
    AddConst('bsDialog', 'Integer', fbsDialog);
    AddConst('bsToolWindow', 'Integer', fbsToolWindow);
    AddConst('bsSizeToolWin', 'Integer', fbsSizeToolWin);
{$ELSE}
    AddConst('bsNone', 'Integer', TFmxFormBorderStyle.bsNone);
    AddConst('bsSingle', 'Integer', TFmxFormBorderStyle.bsSingle);
    AddConst('bsSizeable', 'Integer', TFmxFormBorderStyle.bsSizeable);
    AddConst('bsToolWindow', 'Integer', TFmxFormBorderStyle.bsToolWindow);
    AddConst('bsSizeToolWin', 'Integer', TFmxFormBorderStyle.bsSizeToolWin);
{$ENDIF}

    AddConst('VK_RBUTTON', 'Integer', VKRBUTTON);
    AddConst('VKCANCEL', 'Integer', VKCANCEL);
    AddConst('VKMBUTTON', 'Integer', VKMBUTTON);
    AddConst('VKBACK', 'Integer', VKBACK);//Backspace key
    AddConst('VKTAB', 'Integer', VKTAB);//Tab key
    AddConst('VKRETURN', 'Integer', VKRETURN);//Enter key
    AddConst('VKSHIFT', 'Integer', VKSHIFT);//Shift key
    AddConst('VKCONTROL', 'Integer', VKCONTROL);//Ctrl key
    AddConst('VKMENU', 'Integer', VKMENU);//Alt key
    AddConst('VKPAUSE', 'Integer', VKPAUSE);//Pause key
    AddConst('VKCAPITAL', 'Integer', VKCAPITAL);//Caps Lock key
    AddConst('VKESCAPE', 'Integer', VKESCAPE);//Esc key
    AddConst('VKSPACE', 'Integer', VKSPACE);//Space bar
    AddConst('VKPRIOR', 'Integer', VKPRIOR);//Page Up key
    AddConst('VKNEXT', 'Integer', VKNEXT);// Page Down key
    AddConst('VKEND', 'Integer', VKEND);// End key
    AddConst('VKHOME', 'Integer', VKHOME);// Home key
    AddConst('VKLEFT', 'Integer', VKLEFT);// Left Arrow key
    AddConst('VKUP', 'Integer', VKUP);// Up Arrow key
    AddConst('VKRIGHT', 'Integer', VKRIGHT);// Right Arrow key
    AddConst('VKDOWN', 'Integer', VKDOWN);// Down Arrow key
    AddConst('VKINSERT', 'Integer', VKINSERT);// Insert key
    AddConst('VKDELETE', 'Integer', VKDELETE);// Delete key
    AddConst('VKHELP', 'Integer', VKHELP);// Help key
    AddConst('VKLWIN', 'Integer', VKLWIN);// Left Windows key (Microsoft keyboard)
    AddConst('VKRWIN', 'Integer', VKRWIN);// Right Windows key (Microsoft keyboard)
    AddConst('VKAPPS', 'Integer', VKAPPS);// Applications key (Microsoft keyboard)
    AddConst('VKNUMPAD0', 'Integer', VKNUMPAD0);// 0 key (numeric keypad)
    AddConst('VKNUMPAD1', 'Integer', VKNUMPAD1);// 1 key (numeric keypad)
    AddConst('VKNUMPAD2', 'Integer', VKNUMPAD2);// 2 key (numeric keypad)
    AddConst('VKNUMPAD3', 'Integer', VKNUMPAD3);// 3 key (numeric keypad)
    AddConst('VKNUMPAD4', 'Integer', VKNUMPAD4);// 4 key (numeric keypad)
    AddConst('VKNUMPAD5', 'Integer', VKNUMPAD5);// 5 key (numeric keypad)
    AddConst('VKNUMPAD6', 'Integer', VKNUMPAD6);// 6 key (numeric keypad)
    AddConst('VKNUMPAD7', 'Integer', VKNUMPAD7);// 7 key (numeric keypad)
    AddConst('VKNUMPAD8', 'Integer', VKNUMPAD8);// 8 key (numeric keypad)
    AddConst('VKNUMPAD9', 'Integer', VKNUMPAD9);// 9 key (numeric keypad)
    AddConst('VKMULTIPLY', 'Integer', VKMULTIPLY);// Multiply key (numeric keypad)
    AddConst('VKADD', 'Integer', VKADD);// Add key (numeric keypad)
    AddConst('VKSEPARATOR', 'Integer', VKSEPARATOR);// Separator key (numeric keypad)
    AddConst('VKSUBTRACT', 'Integer', VKSUBTRACT);// Subtract key (numeric keypad)
    AddConst('VKDECIMAL', 'Integer', VKDECIMAL);// Decimal key (numeric keypad)
    AddConst('VKDIVIDE', 'Integer', VKDIVIDE);// Divide key (numeric keypad)
    AddConst('VKF1', 'Integer', VKF1);// F1 key
    AddConst('VKF2', 'Integer', VKF2);// F2 key
    AddConst('VKF3', 'Integer', VKF3);// F3 key
    AddConst('VKF4', 'Integer', VKF4);// F4 key
    AddConst('VKF5', 'Integer', VKF5);// F5 key
    AddConst('VKF6', 'Integer', VKF6);// F6 key
    AddConst('VKF7', 'Integer', VKF7);// F7 key
    AddConst('VKF8', 'Integer', VKF8);// F8 key
    AddConst('VKF9', 'Integer', VKF9);// F9 key
    AddConst('VKF10', 'Integer', VKF10);// F10 key
    AddConst('VKF11', 'Integer', VKF11);// F11 key
    AddConst('VKF12', 'Integer', VKF12);// F12 key
    AddConst('VKNUMLOCK', 'Integer', VKNUMLOCK);// Num Lock key
    AddConst('VKSCROLL', 'Integer', VKSCROLL);// Scroll Lock key

    AddConst('crDefault', 'Integer', crDefault);
    AddConst('crNone', 'Integer', crNone);
    AddConst('crArrow', 'Integer', crArrow);
    AddConst('crCross', 'Integer', crCross);
    AddConst('crIBeam', 'Integer', crIBeam);
    AddConst('crSize', 'Integer', crSize);
    AddConst('crSizeNESW', 'Integer', crSizeNESW);
    AddConst('crSizeNS', 'Integer', crSizeNS);
    AddConst('crSizeNWSE', 'Integer', crSizeNWSE);
    AddConst('crSizeWE', 'Integer', crSizeWE);
    AddConst('crUpArrow', 'Integer', crUpArrow);
    AddConst('crHourGlass', 'Integer', crHourGlass);
    AddConst('crDrag', 'Integer', crDrag);
    AddConst('crNoDrop', 'Integer', crNoDrop);
    AddConst('crHSplit', 'Integer', crHSplit);
    AddConst('crVSplit', 'Integer', crVSplit);
    AddConst('crMultiDrag', 'Integer', crMultiDrag);
    AddConst('crSQLWait', 'Integer', crSQLWait);
    AddConst('crNo', 'Integer', crNo);
    AddConst('crAppStart', 'Integer', crAppStart);
    AddConst('crHelp', 'Integer', crHelp);
    AddConst('crHandPoint', 'Integer', crHandPoint);
    AddConst('crSizeAll', 'Integer', crSizeAll);

    AddType('TFormBorderStyle', fvtInt);
    AddType('TBorderStyle', fvtInt);

    AddEnumSet('TShiftState', 'ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMiddle, ssDouble, ssTouch, ssPen, ssCommand');
    AddEnum('TAniIndicatorStyle', 'aiLinear, aiCircular');
    AddEnum('TAlign', 'alNone, alTop, alBottom, alLeft, alRight, alClient');
    AddEnum('TMouseButton', 'mbLeft, mbRight, mbMiddle');
    AddEnumSet('TAnchors', 'akLeft, akTop, akRight, akBottom');
    AddEnum('TBevelCut', 'bvNone, bvLowered, bvRaised, bvSpace');
    AddEnum('TTextLayout', 'tlTop, tlCenter, tlBottom');
    AddEnum('TEditCharCase', 'ecNormal, ecUpperCase, ecLowerCase');
    AddEnum('TScrollStyle', 'ssNone, ssHorizontal, ssVertical, ssBoth');
    AddEnum('TComboBoxStyle', 'csDropDown, csSimple, csDropDownList, csOwnerDrawFixed, csOwnerDrawVariable');
    AddEnum('TCheckBoxState', 'cbUnchecked, cbChecked, cbGrayed');
    AddEnum('TListBoxStyle', 'lbStandard, lbOwnerDrawFixed, lbOwnerDrawVariable');
    AddEnum('TWindowState', 'wsNormal, wsMinimized, wsMaximized');
    AddEnum('TFormStyle', 'fsNormal, fsMDIChild, fsMDIForm, fsStayOnTop');
    AddEnumSet('TBorderIcons', 'biSystemMenu, biMinimize, biMaximize, biHelp');
    AddEnum('TFormPosition', 'poDesigned, poDefault, poDefaultPosOnly, poDefaultSizeOnly, poScreenCenter, poDesktopCenter');
    AddEnum('TCloseAction', 'caNone, caHide, caFree, caMinimize');

    with AddClass(TControl, 'TFmxObject') do
    begin
      AddMethod('procedure AddObject(AObject: TFmxObject)', CallMethod);
      AddMethod('procedure RemoveObject(AObject: TFmxObject)', CallMethod);
      AddMethod('procedure SetBounds(X: Single; Y: Single; AWidth: Single; AHeight: Single)', CallMethod);
      AddMethod('function AbsoluteToLocal(P: TfsPointF): TfsPointF', CallMethod);
      AddMethod('function LocalToAbsolute(P: TfsPointF): TfsPointF', CallMethod);
      AddMethod('function AbsoluteToLocalVector(P: TfsVector): TfsVector', CallMethod);
      AddMethod('function LocalToAbsoluteVector(P: TfsVector): TfsVector', CallMethod);
      AddMethod('function PointInObject(X: Single; Y: Single): Boolean', CallMethod);
      AddMethod('procedure BeginUpdate()', CallMethod);
      AddMethod('procedure EndUpdate()', CallMethod);
{$IFNDEF DELPHI18}
      AddMethod('procedure ApplyEffect()', CallMethod);
{$ENDIF}
      AddMethod('procedure UpdateEffects()', CallMethod);
      AddMethod('procedure SetFocus()', CallMethod);
      AddMethod('procedure PaintTo(ACanvas: TCanvas; ARect: TFsRectF; AParent: TFmxObject)', CallMethod);
      AddMethod('procedure Repaint()', CallMethod);
      AddMethod('procedure InvalidateRect(ARect: TfsRectF)', CallMethod);
      AddMethod('procedure Lock()', CallMethod);
      AddProperty('AbsoluteMatrix', 'TfsMatrix', GetProp, nil);
      AddProperty('AbsoluteOpacity', 'Single', GetProp, nil);
      AddProperty('AbsoluteWidth', 'Single', GetProp, nil);
      AddProperty('AbsoluteHeight', 'Single', GetProp, nil);
      AddProperty('AbsoluteScale', 'TfsPointF', GetProp, nil);
      AddProperty('AbsoluteEnabled', 'Boolean', GetProp, nil);
      AddProperty('HasEffect', 'Boolean', GetProp, nil);
      AddProperty('HasDisablePaintEffect', 'Boolean', GetProp, nil);
      AddProperty('HasAfterPaintEffect', 'Boolean', GetProp, nil);
      AddProperty('ChildrenRect', 'TfsRectF', GetProp, nil);
      AddProperty('InvertAbsoluteMatrix', 'TfsMatrix', GetProp, nil);
      AddProperty('InPaintTo', 'Boolean', GetProp, nil);
      AddProperty('LocalRect', 'TfsRectF', GetProp, nil);
      AddProperty('AbsoluteRect', 'TfsRectF', GetProp, nil);
      AddProperty('UpdateRect', 'TfsRectF', GetProp, nil);
      AddProperty('ParentedRect', 'TfsRectF', GetProp, nil);
      AddProperty('ParentedVisible', 'Boolean', GetProp, nil);
      AddProperty('ClipRect', 'TfsRectF', GetProp, nil);
      AddProperty('Canvas', 'TCanvas', GetProp, nil);
      AddProperty('AutoCapture', 'Boolean', GetProp, SetProp);
      AddProperty('CanFocus', 'Boolean', GetProp, SetProp);
      AddProperty('DisableFocusEffect', 'Boolean', GetProp, SetProp);
      AddProperty('TabOrder', 'Integer', GetProp, SetProp);
      AddProperty('BoundsRect', 'TfsRectF', GetProp, SetProp);
      AddEvent('OnDragEnter', TfsDragDropEvent);
      AddEvent('OnDragLeave', TfsNotifyEvent);
      AddEvent('OnDragOver', TfsDragOverEvent);
      AddEvent('OnDragDrop', TfsDragDropEvent);
      AddEvent('OnDragEnd', TfsNotifyEvent);
      AddEvent('OnKeyDown', TfsKeyEvent);
      AddEvent('OnKeyUp', TfsKeyEvent);
      AddEvent('OnClick', TfsNotifyEvent);
      AddEvent('OnDblClick', TfsNotifyEvent);
      AddEvent('OnCanFocus', TfsCanFocusEvent);
      AddEvent('OnEnter', TfsNotifyEvent);
      AddEvent('OnExit', TfsNotifyEvent);
      AddEvent('OnMouseDown', TfsMouseEvent);
      AddEvent('OnMouseMove', TfsMouseMoveEvent);
      AddEvent('OnMouseUp', TfsMouseEvent);
      AddEvent('OnMouseWheel', TfsMouseWheelEvent);
      AddEvent('OnMouseEnter', TfsNotifyEvent);
      AddEvent('OnMouseLeave', TfsNotifyEvent);
      AddEvent('OnPainting', TfsOnPaintEvent);
      AddEvent('OnPaint', TfsOnPaintEvent);
      AddEvent('OnResize', TfsNotifyEvent);
      AddEvent('OnApplyStyleLookup', TfsNotifyEvent);
    end;

    { standard controls }
    with AddClass(TStyledControl, 'TControl') do
    begin
      AddMethod('function FindStyleResource(AStyleLookup: string): TFmxObject', CallMethod);
      AddMethod('procedure ApplyStyleLookup()', CallMethod);
{$IFNDEF DELPHI20}
      AddMethod('procedure UpdateStyle()', CallMethod);
{$ENDIF}
      AddProperty('StyleLookup', 'String', GetProp, SetProp);
    end;

    AddClass(TStyledControl, 'TControl');
    AddClass(TTextControl, 'TStyledControl');
    AddClass(TPanel, 'TStyledControl');
    AddClass(TCalloutPanel, 'TPanel');
    AddClass(TLabel, 'TTextControl');
    AddClass(TCustomButton, 'TTextControl');
    AddClass(TButton, 'TCustomButton');
    AddClass(TSpeedButton, 'TCustomButton');
    with AddClass(TCheckBox, 'TTextControl') do
      AddEvent('OnChange', TfsNotifyEvent);

    with AddClass(TRadioButton, 'TTextControl') do
      AddEvent('OnChange', TfsNotifyEvent);
    AddClass(TGroupBox, 'TTextControl');
    AddClass(TStatusBar, 'TStyledControl');
    AddClass(TToolBar, 'TStyledControl');
    AddClass(TSizeGrip, 'TStyledControl');
    AddClass(TSplitter, 'TStyledControl');
    AddClass(TProgressBar, 'TStyledControl');
    AddClass(TThumb, 'TStyledControl');
    with AddClass(TCustomTrack, 'TStyledControl') do
    begin
      AddEvent('OnChange', TfsNotifyEvent);
      AddEvent('OnTracking', TfsNotifyEvent);
    end;
    AddClass(TTrack, 'TCustomTrack');
    AddClass(TTrackBar, 'TCustomTrack');
    AddClass(TBitmapTrackBar, 'TTrackBar');
    with AddClass(TSwitch, 'TCustomTrack') do
      AddEvent('OnSwitch', TfsNotifyEvent);
    with AddClass(TScrollBar, 'TStyledControl') do
      AddEvent('OnChange', TfsNotifyEvent);

    AddClass(TSmallScrollBar, 'TScrollBar');
    AddClass(TAniIndicator, 'TStyledControl');
    with AddClass(TArcDial, 'TStyledControl') do
      AddEvent('OnChange', TfsNotifyEvent);
    AddClass(TExpanderButton, 'TCustomButton');
    with AddClass(TExpander, 'TTextControl') do
      AddEvent('OnCheckChange', TfsNotifyEvent);
    with AddClass(TImageControl, 'TStyledControl') do
      AddEvent('OnChange', TfsNotifyEvent);
    AddClass(TPathLabel, 'TStyledControl');


    with AddClass(TCustomEdit, 'TStyledControl') do
    begin
{$IFNDEF Delphi21}
      AddMethod('procedure ClearSelection()', CallMethod);
{$ENDIF}
      AddMethod('procedure CopyToClipboard()', CallMethod);
      AddMethod('procedure CutToClipboard()', CallMethod);
      AddMethod('procedure PasteFromClipboard()', CallMethod);
      AddMethod('procedure SelectAll()', CallMethod);
{$IFNDEF Delphi21}
      AddMethod('function GetCharX(a: Integer): Single', CallMethod);
      AddMethod('function ContentRect(): TfsRectF', CallMethod);
{$ENDIF}
      AddProperty('CaretPosition', 'Integer', GetProp, SetProp);
      AddProperty('SelStart', 'Integer', GetProp, SetProp);
      AddProperty('SelLength', 'Integer', GetProp, SetProp);
      AddProperty('SelText', 'string', GetProp, nil);
      AddProperty('MaxLength', 'Integer', GetProp, SetProp);
      AddProperty('SelectionFill', 'TBrush', GetProp, nil);
      AddProperty('FilterChar', 'string', GetProp, SetProp);
      AddProperty('Typing', 'Boolean', GetProp, SetProp);
      AddEvent('OnChange', TfsNotifyEvent);
      AddEvent('OnChangeTracking', TfsNotifyEvent);
      AddEvent('OnTyping', TfsNotifyEvent);
    end;
    AddClass(TEdit, 'TCustomEdit');
    with AddClass(TMemo, 'TScrollBox') do
    begin
      AddMethod('procedure CopyToClipboard()', CallMethod);
      AddMethod('procedure PasteFromClipboard()', CallMethod);
      AddMethod('procedure CutToClipboard()', CallMethod);
      AddMethod('procedure ClearSelection()', CallMethod);
      AddMethod('procedure SelectAll()', CallMethod);
      AddMethod('procedure GoToTextEnd()', CallMethod);
      AddMethod('procedure GoToTextBegin()', CallMethod);
      AddMethod('procedure GotoLineEnd()', CallMethod);
      AddMethod('procedure GoToLineBegin()', CallMethod);
      AddMethod('procedure UnDo()', CallMethod);
      AddProperty('SelStart', 'Integer', GetProp, SetProp);
      AddProperty('SelLength', 'Integer', GetProp, SetProp);
      AddProperty('SelText', 'string', GetProp, nil);
      AddEvent('OnChange', TfsNotifyEvent);
      AddEvent('OnChangeTracking', TfsNotifyEvent);
    end;

    AddClass(TRadioButton, 'TTextControl');
    with AddClass(TListBoxItem, 'TTextControl') do
    begin
      AddProperty('Data', 'TObject', GetProp, SetProp);
      AddProperty('Index', 'Integer', GetProp, SetProp);
    end;

    with AddClass(TCustomListBox, 'TScrollBox') do
    begin
      AddMethod('procedure Clear()', CallMethod);
      AddMethod('function DragChange(SourceItem: TListBoxItem; DestItem: TListBoxItem): Boolean', CallMethod);
      AddMethod('procedure SelectAll()', CallMethod);
      AddMethod('procedure ClearSelection()', CallMethod);
      AddMethod('procedure SelectRange(Item1: TListBoxItem; Item2: TListBoxItem)', CallMethod);
      AddMethod('function ItemByPoint(X: Single; Y: Single): TListBoxItem', CallMethod);
      AddMethod('function ItemByIndex(Idx: Integer): TListBoxItem', CallMethod);
      AddMethod('procedure Exchange(Item1: TListBoxItem; Item2: TListBoxItem)', CallMethod);
      AddMethod('procedure AddObject(AObject: TFmxObject)', CallMethod);
      AddMethod('procedure InsertObject(Index: Integer; AObject: TFmxObject)', CallMethod);
      AddMethod('procedure RemoveObject(AObject: TFmxObject)', CallMethod);
      AddIndexProperty( 'ListItems', 'Integer', 'TListBoxItem', CallMethod);
      AddProperty('Count', 'Integer', GetProp, nil);
      AddProperty('Selected', 'TListBoxItem', GetProp, nil);
      AddProperty('Items', 'TStrings', GetProp, SetProp);
      AddProperty('ItemIndex', 'Integer', GetProp, SetProp);
    end;

    AddClass(TListBox, 'TCustomListBox');
    with AddClass(TCustomComboBox, 'TStyledControl') do
    begin
      AddMethod('procedure Clear', CallMethod);
      AddMethod('procedure DropDown', CallMethod);
      AddIndexProperty( 'ListItems', 'Integer', 'TListBoxItem', CallMethod);
      AddProperty('Count', 'Integer', GetProp, nil);
      AddProperty('Selected', 'TListBoxItem', GetProp, nil);
      AddProperty('Items', 'TStrings', GetProp, SetProp);
      AddProperty('ItemIndex', 'Integer', GetProp, SetProp);
      AddEvent('OnDropDown', TfsNotifyEvent);
      AddEvent('OnCloseUp', TfsNotifyEvent);
    end;

    with AddClass(TComboBox, 'TCustomComboBox') do
      AddEvent('OnChange', TfsNotifyEvent);

    with AddClass(TCommonCustomForm, 'TFmxObject') do
    begin
      AddConstructor('constructor CreateNew(AOwner: TComponent; Dummy: Integer = 0)', CallMethod);
      AddMethod('procedure SetBounds(ALeft: Integer; ATop: Integer; AWidth: Integer; AHeight: Integer)', CallMethod);
      AddMethod('function ClientToScreen(Point: TfsPointF): TfsPointF', CallMethod);
      AddMethod('function ScreenToClient(Point: TfsPointF): TfsPointF', CallMethod);
      AddMethod('function CloseQuery(): Boolean', CallMethod);
      AddMethod('function ClientRect(): TfsRectF', CallMethod);
      AddMethod('procedure Release()', CallMethod);
      AddMethod('procedure Close()', CallMethod);
      AddMethod('procedure Show()', CallMethod);
      AddMethod('procedure Hide()', CallMethod);
      AddMethod('function ShowModal(): Integer', CallMethod);
      AddMethod('procedure CloseModal()', CallMethod);
      AddMethod('procedure Invalidate()', CallMethod);
      AddMethod('procedure BeginUpdate()', CallMethod);
      AddMethod('procedure EndUpdate()', CallMethod);
    end;

    with AddClass(TCustomForm, 'TCommonCustomForm') do
    begin
      AddEvent('OnActivate', TfsNotifyEvent);
      AddEvent('OnClose', TfsCloseEvent);
      AddEvent('OnCloseQuery', TfsCloseQueryEvent);
      AddEvent('OnCreate', TfsNotifyEvent);
      AddEvent('OnDestroy', TfsNotifyEvent);
      AddEvent('OnDeactivate', TfsNotifyEvent);
      AddEvent('OnHide', TfsNotifyEvent);
      AddEvent('OnPaint', TfsNotifyEvent);
      AddEvent('OnShow', TfsNotifyEvent);
      AddEvent('OnResize', TfsNotifyEvent);
      AddProperty('Canvas', 'TCanvas', GetProp, nil);
      AddProperty('ModalResult', 'Integer', GetProp, SetProp);
    end;
    AddClass(TForm, 'TCustomForm');

    AddClass(TDataModule, 'TComponent');
    with AddClass(TApplication, 'TComponent') do
    begin
      AddMethod('procedure ProcessMessages', CallMethod);
    end;
    AddObject('Application', Application);
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  Form: TCommonCustomForm;
begin
  Result := 0;

  if ClassType = TControl then
  begin
    if MethodName = 'ADDOBJECT' then
      TControl(Instance).AddObject(TFmxObject(frxInteger(Caller.Params[0])))
    else if MethodName = 'REMOVEOBJECT' then
      TControl(Instance).RemoveObject(TFmxObject(frxInteger(Caller.Params[0])))
    else if MethodName = 'SETBOUNDS' then
      TControl(Instance).SetBounds(Single(Caller.Params[0]), Single(Caller.Params[1]), Single(Caller.Params[2]), Single(Caller.Params[3]))
    else if MethodName = 'ABSOLUTETOLOCAL' then
      Result := frxInteger(TfsPointF.Create(TControl(Instance).AbsoluteToLocal(TfsPointF(frxInteger(Caller.Params[0])).GetRect)))
    else if MethodName = 'LOCALTOABSOLUTE' then
      Result := frxInteger(TfsPointF.Create(TControl(Instance).LocalToAbsolute(TfsPointF(frxInteger(Caller.Params[0])).GetRect)))
    else if MethodName = 'ABSOLUTETOLOCALVECTOR' then
      Result := frxInteger(TfsVector.Create(TControl(Instance).AbsoluteToLocalVector(TfsVector(frxInteger(Caller.Params[0])).GetRect)))
    else if MethodName = 'LOCALTOABSOLUTEVECTOR' then
      Result := frxInteger(TfsVector.Create(TControl(Instance).LocalToAbsoluteVector(TfsVector(frxInteger(Caller.Params[0])).GetRect)))
    else if MethodName = 'POINTINOBJECT' then
      Result := Boolean(TControl(Instance).PointInObject(Single(Caller.Params[0]), Single(Caller.Params[1])))
    else if MethodName = 'BEGINUPDATE' then
      TControl(Instance).BeginUpdate()
    else if MethodName = 'ENDUPDATE' then
      TControl(Instance).EndUpdate()
{$IFNDEF DELPHI18}
    else if MethodName = 'APPLYEFFECT' then
      TControl(Instance).ApplyEffect()
{$ENDIF}
    else if MethodName = 'UPDATEEFFECTS' then
      TControl(Instance).UpdateEffects()
    else if MethodName = 'SETFOCUS' then
      TControl(Instance).SetFocus()
    else if MethodName = 'PAINTTO' then
      TControl(Instance).PaintTo(TCanvas(frxInteger(Caller.Params[0])), TfsRectF(frxInteger(Caller.Params[1])).GetRect, TFmxObject(frxInteger(Caller.Params[2])))
    else if MethodName = 'REPAINT' then
      TControl(Instance).Repaint()
    else if MethodName = 'INVALIDATERECT' then
      TControl(Instance).InvalidateRect(TfsRectF(frxInteger(Caller.Params[0])).GetRect)
    else if MethodName = 'LOCK' then
      TControl(Instance).Lock()
  end
  else if ClassType = TStyledControl then
  begin
    if MethodName = 'FINDSTYLERESOURCE' then
      Result := frxInteger(TStyledControl(Instance).FindStyleResource(String(Caller.Params[0])))
    else if MethodName = 'APPLYSTYLELOOKUP' then
      TStyledControl(Instance).ApplyStyleLookup()
{$IFNDEF DELPHI20}
    else if MethodName = 'UPDATESTYLE' then
      TStyledControl(Instance).UpdateStyle()
{$ENDIF}
  end
  else if ClassType = TCustomEdit then
  begin
 {$IFNDEF Delphi21}
    if MethodName = 'CLEARSELECTION' then
      TCustomEdit(Instance).ClearSelection()
	else 
{$ENDIF}
    if MethodName = 'COPYTOCLIPBOARD' then
      TCustomEdit(Instance).CopyToClipboard()
    else if MethodName = 'CUTTOCLIPBOARD' then
      TCustomEdit(Instance).CutToClipboard()
    else if MethodName = 'PASTEFROMCLIPBOARD' then
      TCustomEdit(Instance).PasteFromClipboard()
    else if MethodName = 'SELECTALL' then
      TCustomEdit(Instance).SelectAll()
{$IFNDEF Delphi21}
    else if MethodName = 'GETCHARX' then
      Result := Single(TCustomEdit(Instance).GetCharX(Integer(Caller.Params[0])))
    else if MethodName = 'CONTENTRECT' then
      Result := frxInteger(TfsRectF.Create(TCustomEdit(Instance).ContentRect()))
{$ENDIF}
  end
  else if ClassType = TMemo then
  begin
    if MethodName = 'COPYTOCLIPBOARD' then
      TMemo(Instance).CopyToClipboard()
    else if MethodName = 'PASTEFROMCLIPBOARD' then
      TMemo(Instance).PasteFromClipboard()
    else if MethodName = 'CUTTOCLIPBOARD' then
      TMemo(Instance).CutToClipboard()
    else if MethodName = 'CLEARSELECTION' then
      TMemo(Instance).ClearSelection()
    else if MethodName = 'SELECTALL' then
      TMemo(Instance).SelectAll()
    else if MethodName = 'GOTOTEXTEND' then
      TMemo(Instance).GoToTextEnd()
    else if MethodName = 'GOTOTEXTBEGIN' then
      TMemo(Instance).GoToTextBegin()
    else if MethodName = 'GOTOLINEEND' then
      TMemo(Instance).GotoLineEnd()
    else if MethodName = 'GOTOLINEBEGIN' then
      TMemo(Instance).GoToLineBegin()
    else if MethodName = 'UNDO' then
      TMemo(Instance).UnDo()
  end
  else if ClassType = TCustomListBox then
  begin
    if MethodName = 'ASSIGN' then
      TCustomListBox(Instance).Assign(TPersistent(frxInteger(Caller.Params[0])))
    else if MethodName = 'CLEAR' then
      TCustomListBox(Instance).Clear()
    else if MethodName = 'DRAGCHANGE' then
      Result := TCustomListBox(Instance).DragChange(TListBoxItem(frxInteger(Caller.Params[0])), TListBoxItem(frxInteger(Caller.Params[1])))
    else if MethodName = 'SELECTALL' then
      TCustomListBox(Instance).SelectAll()
    else if MethodName = 'CLEARSELECTION' then
      TCustomListBox(Instance).ClearSelection()
    else if MethodName = 'SELECTRANGE' then
      TCustomListBox(Instance).SelectRange(TListBoxItem(frxInteger(Caller.Params[0])), TListBoxItem(frxInteger(Caller.Params[1])))
    else if MethodName = 'ITEMBYPOINT' then
      Result := frxInteger(TListBoxItem(TCustomListBox(Instance).ItemByPoint(Single(Caller.Params[0]), Single(Caller.Params[1]))))
    else if MethodName = 'ITEMBYINDEX' then
      Result := frxInteger(TListBoxItem(TCustomListBox(Instance).ItemByIndex(Integer(Caller.Params[0]))))
    else if MethodName = 'EXCHANGE' then
      TCustomListBox(Instance).Exchange(TListBoxItem(frxInteger(Caller.Params[0])), TListBoxItem(frxInteger(Caller.Params[1])))
    else if MethodName = 'ADDOBJECT' then
      TCustomListBox(Instance).AddObject(TFmxObject(frxInteger(Caller.Params[0])))
    else if MethodName = 'INSERTOBJECT' then
      TCustomListBox(Instance).InsertObject(Integer(Caller.Params[0]), TFmxObject(frxInteger(Caller.Params[1])))
    else if MethodName = 'REMOVEOBJECT' then
      TCustomListBox(Instance).RemoveObject(TFmxObject(frxInteger(Caller.Params[0])))
    else if MethodName = 'LISTITEMS.GET' then
      Result := frxInteger(TCustomListBox(Instance).ListItems[Caller.Params[0]])
  end
  else if ClassType = TCustomComboBox then
  begin
    if MethodName = 'CLEAR' then
      TCustomComboBox(Instance).Clear()
    else if MethodName = 'DROPDOWN' then
      TCustomComboBox(Instance).DropDown()
    else if MethodName = 'LISTITEMS.GET' then
      Result := frxInteger(TCustomComboBox(Instance).ListItems[Caller.Params[0]])
  end
  else if ClassType = TCommonCustomForm then
  begin
    Form := TCommonCustomForm(Instance);
    if MethodName = 'CREATENEW' then
      Result := frxInteger(Form.CreateNew(TComponent(frxInteger(Caller.Params[0])), Integer(Caller.Params[1])))
    else if MethodName = 'SETBOUNDS' then
      Form.SetBounds(Integer(Caller.Params[0]), Integer(Caller.Params[1]), Integer(Caller.Params[2]), Integer(Caller.Params[3]))
    else if MethodName = 'CLIENTTOSCREEN' then
      Result := frxInteger(TfsPointF.Create(Form.ClientToScreen(TfsPointF(frxInteger(Caller.Params[0])).GetRect)))
    else if MethodName = 'SCREENTOCLIENT' then
      Result := frxInteger(TfsPointF.Create(Form.ScreenToClient(TfsPointF(frxInteger(Caller.Params[0])).GetRect)))
    else if MethodName = 'CLOSEQUERY' then
      Result := Form.CloseQuery
    else if MethodName = 'CLIENTRECT' then
      Result := frxInteger(TfsRectF.Create(Form.ClientRect))
    else if MethodName = 'RELEASE' then
      Form.Release()
    else if MethodName = 'CLOSE' then
      Form.Close()
    else if MethodName = 'SHOW' then
      Form.Show()
    else if MethodName = 'HIDE' then
      Form.Hide()
    else if MethodName = 'SHOWMODAL' then
      Result := Integer(Form.ShowModal)
    else if MethodName = 'CLOSEMODAL' then
      Form.CloseModal()
    else if MethodName = 'INVALIDATE' then
      Form.Invalidate()
    else if MethodName = 'BEGINUPDATE' then
      Form.BeginUpdate()
    else if MethodName = 'ENDUPDATE' then
      Form.EndUpdate()
  end
  else if ClassType = TApplication then
  begin
    if MethodName = 'PROCESSMESSAGES' then
      TApplication(Instance).ProcessMessages
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TControl then
  begin
    if PropName = 'ABSOLUTEMATRIX' then
      Result := frxInteger(TfsMatrix.Create(TControl(Instance).AbsoluteMatrix))
    else if PropName = 'ABSOLUTEOPACITY' then
      Result := TControl(Instance).AbsoluteOpacity
    else if PropName = 'ABSOLUTEWIDTH' then
      Result := TControl(Instance).AbsoluteWidth
    else if PropName = 'ABSOLUTEHEIGHT' then
      Result := TControl(Instance).AbsoluteHeight
    else if PropName = 'ABSOLUTESCALE' then
      Result := frxInteger(TfsPointF.Create(TControl(Instance).AbsoluteScale))
    else if PropName = 'ABSOLUTEENABLED' then
      Result := TControl(Instance).AbsoluteEnabled
    else if PropName = 'HASEFFECT' then
      Result := TControl(Instance).HasEffect
    else if PropName = 'HASDISABLEPAINTEFFECT' then
      Result := TControl(Instance).HasDisablePaintEffect
    else if PropName = 'HASAFTERPAINTEFFECT' then
      Result := TControl(Instance).HasAfterPaintEffect
    else if PropName = 'CHILDRENRECT' then
      Result := frxInteger(TfsRectF.Create(TControl(Instance).ChildrenRect))
    else if PropName = 'INVERTABSOLUTEMATRIX' then
      Result := frxInteger(TfsMatrix.Create(TControl(Instance).InvertAbsoluteMatrix))
    else if PropName = 'INPAINTTO' then
      Result := TControl(Instance).InPaintTo
    else if PropName = 'LOCALRECT' then
      Result := frxInteger(TfsRectF.Create(TControl(Instance).LocalRect))
    else if PropName = 'ABSOLUTERECT' then
      Result := frxInteger(TfsRectF.Create(TControl(Instance).AbsoluteRect))
    else if PropName = 'UPDATERECT' then
      Result := frxInteger(TfsRectF.Create(TControl(Instance).UpdateRect))
    else if PropName = 'PARENTEDRECT' then
      Result := frxInteger(TfsRectF.Create(TControl(Instance).ParentedRect))
    else if PropName = 'PARENTEDVISIBLE' then
      Result := TControl(Instance).ParentedVisible
    else if PropName = 'CLIPRECT' then
      Result := frxInteger(TfsRectF.Create(TControl(Instance).ClipRect))
    else if PropName = 'CANVAS' then
      Result := frxInteger(TControl(Instance).Canvas)
    else if PropName = 'AUTOCAPTURE' then
      Result := TControl(Instance).AutoCapture
    else if PropName = 'CANFOCUS' then
      Result := TControl(Instance).CanFocus
    else if PropName = 'DISABLEFOCUSEFFECT' then
      Result := TControl(Instance).DisableFocusEffect
    else if PropName = 'TABORDER' then
      Result := Integer(TControl(Instance).TabOrder)
    else if PropName = 'BOUNDSRECT' then
      Result := frxInteger(TfsRectF.Create(TControl(Instance).BoundsRect))
  end
  else if ClassType = TStyledControl then
  begin
    if PropName = 'STYLELOOKUP' then
      Result := TStyledControl(Instance).StyleLookup
  end
  else if ClassType = TCustomEdit then
  begin
    if PropName = 'CARETPOSITION' then
      Result := TCustomEdit(Instance).CaretPosition
    else if PropName = 'SELSTART' then
      Result := TCustomEdit(Instance).SelStart
    else if PropName = 'SELLENGTH' then
      Result := TCustomEdit(Instance).SelLength
    else if PropName = 'SELTEXT' then
      Result := String(TCustomEdit(Instance).SelText)
    else if PropName = 'MAXLENGTH' then
      Result := TCustomEdit(Instance).MaxLength
    else if PropName = 'SELECTIONFILL' then
      Result := frxInteger(TCustomEdit(Instance).SelectionFill)
    else if PropName = 'FILTERCHAR' then
      Result := TCustomEdit(Instance).FilterChar
    else if PropName = 'TYPING' then
      Result := TCustomEdit(Instance).Typing
  end
  else if ClassType = TMemo then
  begin
    if PropName = 'SELSTART' then
      Result := TMemo(Instance).SelStart
    else if PropName = 'SELLENGTH' then
      Result := TMemo(Instance).SelLength
    else if PropName = 'SELTEXT' then
      Result := String(TMemo(Instance).SelText)
  end
  else if ClassType = TListBoxItem then
  begin
    if PropName = 'DATA' then
      Result := frxInteger(TListBoxItem(Instance).Data)
    else if PropName = 'INDEX' then
      Result := TListBoxItem(Instance).Index
  end
  else if ClassType = TCustomListBox then
  begin
    if PropName = 'COUNT' then
      Result := TCustomListBox(Instance).Count
    else if PropName = 'SELECTED' then
      Result := frxInteger(TCustomListBox(Instance).Selected)
    else if PropName = 'ITEMS' then
      Result := frxInteger(TCustomListBox(Instance).Items)
    else if PropName = 'ITEMINDEX' then
      Result := TCustomListBox(Instance).ItemIndex
  end
  else if ClassType = TCustomComboBox then
  begin
    if PropName = 'COUNT' then
      Result := TCustomComboBox(Instance).Count
    else if PropName = 'SELECTED' then
      Result := frxInteger(TCustomComboBox(Instance).Selected)
    else if PropName = 'ITEMS' then
      Result := frxInteger(TCustomComboBox(Instance).Items)
    else if PropName = 'ITEMINDEX' then
      Result := TCustomComboBox(Instance).ItemIndex
  end
  else if ClassType = TCustomForm then
  begin
    if PropName = 'MODALRESULT' then
      Result := TCustomForm(Instance).ModalResult
    else if PropName = 'CANVAS' then
      Result := frxInteger(TCustomForm(Instance).Canvas)
  end
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TControl then
  begin
    if PropName = 'AUTOCAPTURE' then
      TControl(Instance).AutoCapture := Boolean(Value)
    else if PropName = 'CANFOCUS' then
      TControl(Instance).CanFocus := Boolean(Value)
    else if PropName = 'DISABLEFOCUSEFFECT' then
      TControl(Instance).DisableFocusEffect := Boolean(Value)
    else if PropName = 'TABORDER' then
      TControl(Instance).TabOrder := TTabOrder(Integer(Value))
    else if PropName = 'BOUNDSRECT' then
      TControl(Instance).BoundsRect := TfsRectF(frxInteger(Value)).GetRect
  end
  else if ClassType = TStyledControl then
  begin
    if PropName = 'STYLELOOKUP' then
      TStyledControl(Instance).StyleLookup := Value;
  end
  else if ClassType = TCustomEdit then
  begin
    if PropName = 'CARETPOSITION' then
      TCustomEdit(Instance).CaretPosition := Integer(Value)
    else if PropName = 'SELSTART' then
      TCustomEdit(Instance).SelStart := Integer(Value)
    else if PropName = 'SELLENGTH' then
      TCustomEdit(Instance).SelLength := Integer(Value)
    else if PropName = 'MAXLENGTH' then
      TCustomEdit(Instance).MaxLength := Integer(Value)
    else if PropName = 'FILTERCHAR' then
      TCustomEdit(Instance).FilterChar := String(Value)
    else if PropName = 'TYPING' then
      TCustomEdit(Instance).Typing := Boolean(Value)
  end
  else if ClassType = TMemo then
  begin
    if PropName = 'SELSTART' then
      TMemo(Instance).SelStart := Integer(Value)
    else if PropName = 'SELLENGTH' then
      TMemo(Instance).SelLength := Integer(Value)
  end
  else if ClassType = TListBoxItem then
  begin
    if PropName = 'DATA' then
      TListBoxItem(Instance).Data := TObject(frxInteger(Value))
    else if PropName = 'INDEX' then
      TListBoxItem(Instance).Index := Value
  end
  else if ClassType = TCustomListBox then
  begin
    if PropName = 'ITEMS' then
      TCustomListBox(Instance).Items := TStrings(frxInteger(Value))
    else if PropName = 'ITEMINDEX' then
      TCustomListBox(Instance).ItemIndex := Value
  end
  else if ClassType = TCustomComboBox then
  begin
    if PropName = 'ITEMS' then
      TCustomComboBox(Instance).Items := TStrings(frxInteger(Value))
    else if PropName = 'ITEMINDEX' then
      TCustomComboBox(Instance).ItemIndex := Value
  end
  else if ClassType = TCustomForm then
  begin
    if PropName = 'MODALRESULT' then
      TCustomForm(Instance).ModalResult := Value
  end
end;


initialization
  StartClassGroup(TFmxObject);
  ActivateClassGroup(TFmxObject);
  GroupDescendentsWith(TfsFormsRTTI, TFmxObject);
  fsRTTIModules.Add(TFunctions);

finalization
  fsRTTIModules.Remove(TFunctions);

end.
