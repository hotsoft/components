
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Registration unit             }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMXfs_ireg;

{$i fs.inc}

interface


procedure Register;

implementation
uses
  System.Classes
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
  , FMX.Controls, FMX.Types
{$ENDIF}
, FMX.fs_iinterpreter, FMX.fs_iclassesrtti, FMX.fs_igraphicsrtti, FMX.fs_iformsrtti,
  FMX.fs_iextctrlsrtti, FMX.fs_idialogsrtti, FMX.fs_iinirtti, FMX.fs_imenusrtti,
  FMX.fs_ipascal, FMX.fs_icpp, FMX.fs_ijs, FMX.fs_ibasic, FMX.fs_tree
{$IFNDEF CLX}
, FMX.fs_synmemo
{$ENDIF}
;

{-----------------------------------------------------------------------}

{$ifdef FPC}
procedure RegisterUnitfs_ireg;
{$else}
procedure Register;
{$endif}
begin
  {GroupDescendentsWith(TfsExtCtrlsRTTI, TFmxObject);
  GroupDescendentsWith(TfsDialogsRTTI, TFmxObject);
  GroupDescendentsWith(TfsGraphicsRTTI, TFmxObject);
  GroupDescendentsWith(TfsMenusRTTI, TFmxObject);
  GroupDescendentsWith(TfsScript, TFmxObject);
  GroupDescendentsWith(TfsIniRTTI, TFmxObject);
  GroupDescendentsWith(TfsFormsRTTI, TFmxObject);
  GroupDescendentsWith(TfsClassesRTTI, TFmxObject);
  GroupDescendentsWith(TfsPascal, TFmxObject);
  GroupDescendentsWith(TfsCPP, TFmxObject);
  GroupDescendentsWith(TfsJScript, TFmxObject);
  GroupDescendentsWith(TfsBasic, TFmxObject);}
  RegisterComponents('FastScript FMX', 
    [TfsScript, TfsPascal, TfsCPP, TfsJScript, TfsBasic,
    TfsClassesRTTI, TfsGraphicsRTTI, TfsFormsRTTI, TfsExtCtrlsRTTI, 
    TfsDialogsRTTI, TfsMenusRTTI, TfsIniRTTI,
    TfsTree, TfsSyntaxMemo]);

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
