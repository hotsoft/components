
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Registration unit             }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_ireg;

{$i fs.inc}

interface


procedure Register;

implementation
uses
  Classes
{$IFNDEF FPC}
  {$IFNDEF Delphi6}
  , DsgnIntf
  {$ELSE}
  , DesignIntf
  {$ENDIF}
{$ELSE}
  ,PropEdits
  ,LazarusPackageIntf
  ,LResources
{$ENDIF}
{$IFDEF DELPHI16}
  , Controls
{$ENDIF}
, fs_iinterpreter, fs_iclassesrtti, fs_igraphicsrtti, fs_iformsrtti,
  fs_iextctrlsrtti, fs_idialogsrtti, fs_iinirtti, fs_imenusrtti,
  fs_ipascal, fs_icpp, fs_ijs, fs_ibasic, fs_tree
{$IFNDEF CLX}
, fs_synmemo
{$ENDIF}
;

{-----------------------------------------------------------------------}

{$ifdef FPC}
procedure RegisterUnitfs_ireg;
{$else}
procedure Register;
{$endif}
begin
{$IFDEF DELPHI16}
  {GroupDescendentsWith(TfsExtCtrlsRTTI, TControl);
  GroupDescendentsWith(TfsDialogsRTTI, TControl);
  GroupDescendentsWith(TfsGraphicsRTTI, TControl);
  GroupDescendentsWith(TfsMenusRTTI, TControl);
  GroupDescendentsWith(TfsScript, TControl);
  GroupDescendentsWith(TfsIniRTTI, TControl);
  GroupDescendentsWith(TfsFormsRTTI, TControl);
  GroupDescendentsWith(TfsClassesRTTI, TControl);
  GroupDescendentsWith(TfsPascal, TControl);
  GroupDescendentsWith(TfsCPP, TControl);
  GroupDescendentsWith(TfsJScript, TControl);
  GroupDescendentsWith(TfsBasic, TControl);}
{$ENDIF}
  RegisterComponents('FastScript', 
    [TfsScript, TfsPascal, TfsCPP, TfsJScript, TfsBasic,
    TfsClassesRTTI, TfsGraphicsRTTI, TfsFormsRTTI, TfsExtCtrlsRTTI, 
    TfsDialogsRTTI, TfsMenusRTTI, TfsIniRTTI,
    TfsTree
{$IFNDEF CLX}
  , TfsSyntaxMemo
{$ENDIF}
    ]);
end;

{$ifdef FPC}
procedure Register;
begin
  RegisterUnit('fs_ireg', @RegisterUnitfs_ireg);
end;
{$endif}

initialization
{$IFDEF FPC}
  {$INCLUDE fs_ireg.lrs}
{$ENDIF}
end.
