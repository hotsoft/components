
{******************************************}
{                                          }
{             FastScript v1.9              }
{    Dialogs.pas classes and functions     }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMX.fs_idialogsrtti;

interface

{$i fs.inc}

uses
  System.SysUtils, System.Classes, FMX.fs_iinterpreter, FMX.fs_iclassesrtti, FMX.Types
, FMX.Dialogs, System.UITypes
{$IFDEF DELPHI19}
, FMX.Printer
{$ENDIF};

type
[ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidOSX32)]
  TfsDialogsRTTI = class(TComponent); // fake component


implementation

type
  THackDialog = class(TCommonDialog);


  TFunctions = class(TfsRTTIModule)
  private
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; Caller: TfsMethodHelper): Variant;
  public
    constructor Create(AScript: TfsScript); override;
  end;

type
  TWordSet = set of 0..15;
  PWordSet = ^TWordSet;


{ TFunctions }

constructor TFunctions.Create(AScript: TfsScript);
var
  dlg: String;
begin
  inherited Create(AScript);
  with AScript do
  begin
    AddEnumSet('TOpenOptions', 'ofReadOnly, ofOverwritePrompt, ofHideReadOnly,' +
      'ofNoChangeDir, ofShowHelp, ofNoValidate, ofAllowMultiSelect,' +
      'ofExtensionDifferent, ofPathMustExist, ofFileMustExist, ofCreatePrompt,' +
      'ofShareAware, ofNoReadOnlyReturn, ofNoTestFileCreate, ofNoNetworkButton,' +
      'ofNoLongNames, ofOldStyleDialog, ofNoDereferenceLinks, ofEnableIncludeNotify,' +
      'ofEnableSizing');
    AddEnum('TFileEditStyle', 'fsEdit, fsComboBox');
    AddEnumSet('TColorDialogOptions', 'cdFullOpen, cdPreventFullOpen, cdShowHelp,' +
      'cdSolidColor, cdAnyColor');
    AddEnumSet('TFontDialogOptions', 'fdAnsiOnly, fdTrueTypeOnly, fdEffects,' +
      'fdFixedPitchOnly, fdForceFontExist, fdNoFaceSel, fdNoOEMFonts,' +
      'fdNoSimulations, fdNoSizeSel, fdNoStyleSel,  fdNoVectorFonts,' +
      'fdShowHelp, fdWysiwyg, fdLimitSize, fdScalableOnly, fdApplyButton');
    AddEnum('TFontDialogDevice', 'fdScreen, fdPrinter, fdBoth');
    AddEnum('TPrintRange', 'prAllPages, prSelection, prPageNums');
    AddEnumSet('TPrintDialogOptions', 'poPrintToFile, poPageNums, poSelection,' +
      'poWarning, poHelp, poDisablePrintToFile');
    AddEnum('TMsgDlgType', 'mtCustom, mtInformation, mtWarning, mtError, mtConfirmation');
    AddEnumSet('TMsgDlgButtons', 'mbNone, mbOk, mbCancel, mbYes, mbNo, mbAbort, ' +
      'mbRetry, mbIgnore');


    with AddClass(TCommonDialog, 'TComponent') do
      AddMethod('function Execute: Boolean', CallMethod);
    AddClass(TOpenDialog, 'TCommonDialog');
    AddClass(TSaveDialog, 'TCommonDialog');
    AddClass(TPrintDialog, dlg);
    AddClass(TPrinterSetupDialog, dlg);

    AddMethod('function MessageDlg(Msg: string; DlgType: TMsgDlgType; Buttons: TMsgDlgButtons; HelpCtx: Longint): Integer', CallMethod, 'ctOther');
    AddMethod('function InputBox(ACaption, APrompt, ADefault: string): string', CallMethod, 'ctOther');
    AddMethod('function InputQuery(ACaption, APrompt: string; var Value: string): Boolean', CallMethod, 'ctOther');
  end;
end;

function TFunctions.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; Caller: TfsMethodHelper): Variant;
var
  s: String;
  b: TMsgDlgButtons;
begin
  Result := 0;

  if ClassType = TCommonDialog then
  begin
    if MethodName = 'EXECUTE' then
      Result := THackDialog(Instance).Execute
  end
  else if MethodName = 'INPUTBOX' then
    Result := InputBox(Caller.Params[0], Caller.Params[1], Caller.Params[2])
  else if MethodName = 'INPUTQUERY' then
  begin
    s := Caller.Params[2];
    Result := InputQuery(Caller.Params[0], Caller.Params[1], s);
    Caller.Params[2] := s;
  end
  else if MethodName = 'MESSAGEDLG' then
  begin
    Word(PWordSet(@b)^) := Caller.Params[2];
    Result := MessageDlg(Caller.Params[0], Caller.Params[1], b, Caller.Params[3]);
  end
end;


initialization
  StartClassGroup(TFmxObject);
  ActivateClassGroup(TFmxObject);
  GroupDescendentsWith(TfsDialogsRTTI, TFmxObject);
  fsRTTIModules.Add(TFunctions);



finalization
  fsRTTIModules.Remove(TFunctions);

end.