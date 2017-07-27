{**********************************************}
{                                              }
{              FastScript v1.9                 }
{                  Menus                       }
{                                              }
{         Copyright (c) 1998-2011              }
{           by Fast Reports Inc.               }
{                                              }
{**********************************************}

unit FMX.fs_imenusrtti;

interface

{$I fs.inc}

uses
  System.SysUtils, System.Classes, FMX.Menus, FMX.fs_iinterpreter, FMX.fs_ievents, System.Types, System.Variants, FMX.Types;

type
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]

  TfsMenusRTTI = class(TComponent); // fake component

implementation

type
  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass; const MethodName:
      string; Caller: TfsMethodHelper): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;

constructor TFunctions.Create(AScript: TfsScript);
begin
  inherited Create(AScript);

  with AScript do
  begin

    AddType('TPopupAlignment', fvtInt);


    with AddClass(TMenuItem, 'TTextControl') do
    begin
      AddMethod('procedure Popup', CallMethod);
      AddMethod('procedure NeedPopup', CallMethod);
      AddMethod('function HavePopup: Boolean', CallMethod);
    end; { with }

    with AddClass(TMainMenu, 'TFmxObject') do
    with AddClass(TMenuBar, 'TStyledControl') do
      AddMethod('procedure StartMenuLoop', CallMethod);

    with AddClass(TPopupMenu, 'TFmxObject') do
      AddMethod('procedure Popup(X, Y: Single)', CallMethod);

  end; { with }

end; { Create }

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass; const
  MethodName: string; Caller: TfsMethodHelper): Variant;
var
  oMenuItem: TMenuItem;
begin
  Result := 0;

  if ClassType = TMenuItem then
  begin

    oMenuItem := TMenuItem(Instance);

    if MethodName = 'POPUP' then
      oMenuItem.Popup
    else if MethodName = 'NEEDPOPUP' then
      oMenuItem.NeedPopup
    else if MethodName = 'HAVEPOPUP' then
      Result := oMenuItem.HavePopup;

  end
  else if ClassType = TPopupMenu then
  begin

    if MethodName = 'POPUP' then
      TPopupMenu(Instance).Popup(Caller.Params[0], Caller.Params[1]);

  end;
end; { CallMethod }

initialization
  StartClassGroup(TFmxObject);
  ActivateClassGroup(TFmxObject);
  GroupDescendentsWith(TfsMenusRTTI, TFmxObject);
  fsRTTIModules.Add(TFunctions);


finalization
  fsRTTIModules.Remove(TFunctions);

end.

