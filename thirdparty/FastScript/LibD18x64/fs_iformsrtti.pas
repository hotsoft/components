
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Forms and StdCtrls            }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iformsrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_ievents, fs_iclassesrtti,
  fs_igraphicsrtti
{$IFDEF CLX}
  , QControls, QForms, QStdCtrls
{$ELSE}
  {$IFNDEF FPC}
    , Windows
  {$ELSE}
    , LCLType, Buttons
  {$ENDIF}
    , Controls, Forms, StdCtrls
{$ENDIF};

type
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
    AddConst('bsNone', 'Integer', bsNone);
    AddConst('bsSingle', 'Integer', bsSingle);
    AddConst('bsSizeable', 'Integer', bsSizeable);
    AddConst('bsDialog', 'Integer', bsDialog);
    AddConst('bsToolWindow', 'Integer', bsToolWindow);
    AddConst('bsSizeToolWin', 'Integer', bsSizeToolWin);
{$ENDIF}

{$IFNDEF CLX}
    AddConst('VK_RBUTTON', 'Integer', VK_RBUTTON);
    AddConst('VK_CANCEL', 'Integer', VK_CANCEL);
    AddConst('VK_MBUTTON', 'Integer', VK_MBUTTON);
    AddConst('VK_BACK', 'Integer', VK_BACK);//Backspace key
    AddConst('VK_TAB', 'Integer', VK_TAB);//Tab key
    AddConst('VK_RETURN', 'Integer', VK_RETURN);//Enter key
    AddConst('VK_SHIFT', 'Integer', VK_SHIFT);//Shift key
    AddConst('VK_CONTROL', 'Integer', VK_CONTROL);//Ctrl key
    AddConst('VK_MENU', 'Integer', VK_MENU);//Alt key
    AddConst('VK_PAUSE', 'Integer', VK_PAUSE);//Pause key
    AddConst('VK_CAPITAL', 'Integer', VK_CAPITAL);//Caps Lock key
    AddConst('VK_ESCAPE', 'Integer', VK_ESCAPE);//Esc key
    AddConst('VK_SPACE', 'Integer', VK_SPACE);//Space bar
    AddConst('VK_PRIOR', 'Integer', VK_PRIOR);//Page Up key
    AddConst('VK_NEXT', 'Integer', VK_NEXT);// Page Down key
    AddConst('VK_END', 'Integer', VK_END);// End key
    AddConst('VK_HOME', 'Integer', VK_HOME);// Home key
    AddConst('VK_LEFT', 'Integer', VK_LEFT);// Left Arrow key
    AddConst('VK_UP', 'Integer', VK_UP);// Up Arrow key
    AddConst('VK_RIGHT', 'Integer', VK_RIGHT);// Right Arrow key
    AddConst('VK_DOWN', 'Integer', VK_DOWN);// Down Arrow key
    AddConst('VK_INSERT', 'Integer', VK_INSERT);// Insert key
    AddConst('VK_DELETE', 'Integer', VK_DELETE);// Delete key
    AddConst('VK_HELP', 'Integer', VK_HELP);// Help key
    AddConst('VK_LWIN', 'Integer', VK_LWIN);// Left Windows key (Microsoft keyboard)
    AddConst('VK_RWIN', 'Integer', VK_RWIN);// Right Windows key (Microsoft keyboard)
    AddConst('VK_APPS', 'Integer', VK_APPS);// Applications key (Microsoft keyboard)
    AddConst('VK_NUMPAD0', 'Integer', VK_NUMPAD0);// 0 key (numeric keypad)
    AddConst('VK_NUMPAD1', 'Integer', VK_NUMPAD1);// 1 key (numeric keypad)
    AddConst('VK_NUMPAD2', 'Integer', VK_NUMPAD2);// 2 key (numeric keypad)
    AddConst('VK_NUMPAD3', 'Integer', VK_NUMPAD3);// 3 key (numeric keypad)
    AddConst('VK_NUMPAD4', 'Integer', VK_NUMPAD4);// 4 key (numeric keypad)
    AddConst('VK_NUMPAD5', 'Integer', VK_NUMPAD5);// 5 key (numeric keypad)
    AddConst('VK_NUMPAD6', 'Integer', VK_NUMPAD6);// 6 key (numeric keypad)
    AddConst('VK_NUMPAD7', 'Integer', VK_NUMPAD7);// 7 key (numeric keypad)
    AddConst('VK_NUMPAD8', 'Integer', VK_NUMPAD8);// 8 key (numeric keypad)
    AddConst('VK_NUMPAD9', 'Integer', VK_NUMPAD9);// 9 key (numeric keypad)
    AddConst('VK_MULTIPLY', 'Integer', VK_MULTIPLY);// Multiply key (numeric keypad)
    AddConst('VK_ADD', 'Integer', VK_ADD);// Add key (numeric keypad)
    AddConst('VK_SEPARATOR', 'Integer', VK_SEPARATOR);// Separator key (numeric keypad)
    AddConst('VK_SUBTRACT', 'Integer', VK_SUBTRACT);// Subtract key (numeric keypad)
    AddConst('VK_DECIMAL', 'Integer', VK_DECIMAL);// Decimal key (numeric keypad)
    AddConst('VK_DIVIDE', 'Integer', VK_DIVIDE);// Divide key (numeric keypad)
    AddConst('VK_F1', 'Integer', VK_F1);// F1 key
    AddConst('VK_F2', 'Integer', VK_F2);// F2 key
    AddConst('VK_F3', 'Integer', VK_F3);// F3 key
    AddConst('VK_F4', 'Integer', VK_F4);// F4 key
    AddConst('VK_F5', 'Integer', VK_F5);// F5 key
    AddConst('VK_F6', 'Integer', VK_F6);// F6 key
    AddConst('VK_F7', 'Integer', VK_F7);// F7 key
    AddConst('VK_F8', 'Integer', VK_F8);// F8 key
    AddConst('VK_F9', 'Integer', VK_F9);// F9 key
    AddConst('VK_F10', 'Integer', VK_F10);// F10 key
    AddConst('VK_F11', 'Integer', VK_F11);// F11 key
    AddConst('VK_F12', 'Integer', VK_F12);// F12 key
    AddConst('VK_NUMLOCK', 'Integer', VK_NUMLOCK);// Num Lock key
    AddConst('VK_SCROLL', 'Integer', VK_SCROLL);// Scroll Lock key
{$ENDIF}

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
    AddType('TAlignment', fvtInt);
    AddType('TLeftRight', fvtInt);
    AddConst('taLeftJustify', 'Integer', taLeftJustify);
    AddConst('taRightJustify', 'Integer', taRightJustify);
    AddConst('taCenter', 'Integer', taCenter);

    AddEnumSet('TShiftState', 'ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMiddle, ssDouble');
//    AddEnum('TAlignment', 'taLeftJustify, taRightJustify, taCenter');
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
    AddEnum('TPosition', 'poDesigned, poDefault, poDefaultPosOnly, poDefaultSizeOnly, poScreenCenter, poDesktopCenter');
    AddEnum('TCloseAction', 'caNone, caHide, caFree, caMinimize');

    with AddClass(TControl, 'TComponent') do
    begin
      AddProperty('Parent', 'TWinControl', GetProp, SetProp);
      AddMethod('procedure Hide', CallMethod);
      AddMethod('procedure Show', CallMethod);
      AddMethod('procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer)', CallMethod);
      AddEvent('OnCanResize', TfsCanResizeEvent);
      AddEvent('OnClick', TfsNotifyEvent);
      AddEvent('OnDblClick', TfsNotifyEvent);
      AddEvent('OnMouseDown', TfsMouseEvent);
      AddEvent('OnMouseMove', TfsMouseMoveEvent);
      AddEvent('OnMouseUp', TfsMouseEvent);
      AddEvent('OnResize', TfsNotifyEvent);
    end;
    with AddClass(TWinControl, 'TControl') do
    begin
      AddMethod('procedure SetFocus', CallMethod);
      AddEvent('OnEnter', TfsNotifyEvent);
      AddEvent('OnExit', TfsNotifyEvent);
      AddEvent('OnKeyDown', TfsKeyEvent);
      AddEvent('OnKeyPress', TfsKeyPressEvent);
      AddEvent('OnKeyUp', TfsKeyEvent);
    end;
    AddClass(TCustomControl, 'TWinControl');
    AddClass(TGraphicControl, 'TControl');
    AddClass(TGroupBox, 'TWinControl');
    AddClass(TLabel, 'TControl');
    AddClass(TEdit, 'TWinControl');
    AddClass(TMemo, 'TWinControl');
    with AddClass(TCustomComboBox, 'TWinControl') do
    begin
      AddProperty('DroppedDown', 'Boolean', GetProp, SetProp);
      AddProperty('ItemIndex', 'Integer', GetProp, SetProp);
      AddEvent('OnChange', TfsNotifyEvent);
      AddEvent('OnDropDown', TfsNotifyEvent);
      AddEvent('OnCloseUp', TfsNotifyEvent);
    end;
    AddClass(TComboBox, 'TCustomComboBox');
    AddClass(TButton, 'TWinControl');
    AddClass(TCheckBox, 'TWinControl');
    AddClass(TRadioButton, 'TWinControl');
    with AddClass(TCustomListBox, 'TWinControl') do
    begin
      AddProperty('ItemIndex', 'Integer', GetProp, SetProp);
      AddProperty('SelCount', 'Integer', GetProp, nil);
      AddIndexProperty('Selected', 'Integer', 'Boolean', CallMethod);
    end;
    AddClass(TListBox, 'TCustomListBox');
    AddClass(TControlScrollBar, 'TPersistent');
    AddClass(TScrollingWinControl, 'TWinControl');
    AddClass(TScrollBox, 'TScrollingWinControl');
    with AddClass(TCustomForm, 'TScrollingWinControl') do
    begin
      AddMethod('procedure Close', CallMethod);
      AddMethod('procedure Hide', CallMethod);
      AddMethod('procedure Show', CallMethod);
      AddMethod('function ShowModal: Integer', CallMethod);
      AddEvent('OnActivate', TfsNotifyEvent);
      AddEvent('OnClose', TfsCloseEvent);
      AddEvent('OnCloseQuery', TfsCloseQueryEvent);
      AddEvent('OnCreate', TfsNotifyEvent);
      AddEvent('OnDestroy', TfsNotifyEvent);
      AddEvent('OnDeactivate', TfsNotifyEvent);
      AddEvent('OnHide', TfsNotifyEvent);
      AddEvent('OnPaint', TfsNotifyEvent);
      AddEvent('OnShow', TfsNotifyEvent);
      AddProperty('Canvas', 'TCanvas', GetProp, nil);
      AddProperty('ModalResult', 'Integer', GetProp, SetProp);
    end;
    AddClass(TForm, 'TCustomForm');
    AddClass(TDataModule, 'TComponent');
    with AddClass(TApplication, 'TComponent') do
    begin
      AddMethod('procedure Minimize', CallMethod);
      AddMethod('procedure ProcessMessages', CallMethod);
      AddMethod('procedure Restore', CallMethod);
      AddProperty('ExeName', 'String', GetProp, nil);
    end;
    AddObject('Application', Application);
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  Form: TCustomForm;
begin
  Result := 0;

  if ClassType = TControl then
  begin
    if MethodName = 'HIDE' then
      TControl(Instance).Hide
    else if MethodName = 'SHOW' then
      TControl(Instance).Show
    else if MethodName = 'SETBOUNDS' then
      TControl(Instance).SetBounds(Caller.Params[0], Caller.Params[1], Caller.Params[2], Caller.Params[3])
  end
  else if ClassType = TWinControl then
  begin
    if MethodName = 'SETFOCUS' then
      TWinControl(Instance).SetFocus
  end
  else if ClassType = TCustomListBox then
  begin
    if MethodName = 'SELECTED.GET' then
      Result := TCustomListBox(Instance).Selected[Caller.Params[0]]
    else if MethodName = 'SELECTED.SET' then
      TCustomListBox(Instance).Selected[Caller.Params[0]] := Caller.Params[1]
  end
  else if ClassType = TCustomForm then
  begin
    Form := TCustomForm(Instance);
    if MethodName = 'CLOSE' then
      Form.Close
    else if MethodName = 'HIDE' then
      Form.Hide
    else if MethodName = 'SHOW' then
      Form.Show
    else if MethodName = 'SHOWMODAL' then
      Result := Form.ShowModal;
  end
  else if ClassType = TApplication then
  begin
    if MethodName = 'MINIMIZE' then
      TApplication(Instance).Minimize
    else if MethodName = 'PROCESSMESSAGES' then
      TApplication(Instance).ProcessMessages
    else if MethodName = 'RESTORE' then
      TApplication(Instance).Restore
  end
end;

function TFunctions.GetProp(Instance: TObject; ClassType: TClass;
  const PropName: String): Variant;
begin
  Result := 0;

  if ClassType = TControl then
  begin
    if PropName = 'PARENT' then
      Result := Integer(TControl(Instance).Parent)
  end
  else if ClassType = TCustomComboBox then
  begin
    if PropName = 'DROPPEDDOWN' then
      Result := TCustomComboBox(Instance).DroppedDown
    else if PropName = 'ITEMINDEX' then
      Result := TCustomComboBox(Instance).ItemIndex
  end
  else if ClassType = TCustomListBox then
  begin
    if PropName = 'SELCOUNT' then
      Result := TCustomListBox(Instance).SelCount
    else if PropName = 'ITEMINDEX' then
      Result := TCustomListBox(Instance).ItemIndex
  end
  else if ClassType = TCustomForm then
  begin
    if PropName = 'MODALRESULT' then
      Result := TCustomForm(Instance).ModalResult
    else if PropName = 'CANVAS' then
      Result := Integer(TCustomForm(Instance).Canvas)
  end
  else if ClassType = TApplication then
  begin
    if PropName = 'EXENAME' then
      Result := TApplication(Instance).ExeName
  end
end;

procedure TFunctions.SetProp(Instance: TObject; ClassType: TClass;
  const PropName: String; Value: Variant);
begin
  if ClassType = TControl then
  begin
    if PropName = 'PARENT' then
      TControl(Instance).Parent := TWinControl(Integer(Value))
  end
  else if ClassType = TCustomComboBox then
  begin
    if PropName = 'DROPPEDDOWN' then
      TCustomComboBox(Instance).DroppedDown := Value
    else if PropName = 'ITEMINDEX' then
      TCustomComboBox(Instance).ItemIndex := Value
  end
  else if ClassType = TCustomListBox then
  begin
    if PropName = 'ITEMINDEX' then
      TCustomListBox(Instance).ItemIndex := Value
  end
  else if ClassType = TCustomForm then
  begin
    if PropName = 'MODALRESULT' then
      TCustomForm(Instance).ModalResult := Value
  end
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
