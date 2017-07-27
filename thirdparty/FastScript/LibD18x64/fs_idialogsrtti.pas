
{******************************************}
{                                          }
{             FastScript v1.9              }
{    Dialogs.pas classes and functions     }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_idialogsrtti;

interface

{$i fs.inc}

uses
  SysUtils, Classes, fs_iinterpreter, fs_iclassesrtti
{$IFDEF CLX}
, QDialogs
{$ELSE}
, Dialogs
{$ENDIF};

type
  TfsDialogsRTTI = class(TComponent); // fake component


implementation

type
{$IFDEF CLX}
  THackDialog = class(TDialog);
{$ELSE}
  THackDialog = class(TCommonDialog);
{$ENDIF}

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
{$IFNDEF CLX}
    AddEnum('TMsgDlgType', 'mtWarning, mtError, mtInformation, mtConfirmation, mtCustom');
    AddEnumSet('TMsgDlgButtons', 'mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, ' +
      'mbIgnore, mbAll, mbNoToAll, mbYesToAll, mbHelp');
{$ELSE}
    AddEnum('TMsgDlgType', 'mtCustom, mtInformation, mtWarning, mtError, mtConfirmation');
    AddEnumSet('TMsgDlgButtons', 'mbNone, mbOk, mbCancel, mbYes, mbNo, mbAbort, ' +
      'mbRetry, mbIgnore');
{$ENDIF}

{$IFDEF CLX}
    dlg := 'TDialog';
    with AddClass(TDialog, 'TComponent') do
{$ELSE}
    dlg := 'TCommonDialog';
    with AddClass(TCommonDialog, 'TComponent') do
{$ENDIF}
      AddMethod('function Execute: Boolean', CallMethod);
    AddClass(TOpenDialog, dlg);
    AddClass(TSaveDialog, dlg);
    AddClass(TColorDialog, dlg);
    AddClass(TFontDialog, dlg);
{$IFNDEF CLX}
  {$IFNDEF FPC}
    // todo: wait lazarus 1.0 TPrintDialog is targeted in Mantis to 1.0
    AddClass(TPrintDialog, dlg);
    AddClass(TPrinterSetupDialog, dlg);
  {$ENDIF}
{$ENDIF}
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

{$IFDEF CLX}
  if ClassType = TDialog then
{$ELSE}
  if ClassType = TCommonDialog then
{$ENDIF}
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
  {$IFNDEF FPC}
    Word(PWordSet(@b)^) := Caller.Params[2];
  {$ELSE}
    Integer(PWordSet(@b)^) := Caller.Params[2];
  {$ENDIF}
    Result := MessageDlg(Caller.Params[0], Caller.Params[1], b, Caller.Params[3]);
  end
end;


initialization
  fsRTTIModules.Add(TFunctions);

finalization
  if fsRTTIModules <> nil then
    fsRTTIModules.Remove(TFunctions);

end.
