
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Registration unit             }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMX.fs_ireg;

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
  //GroupDescendentsWith(TfsExtCtrlsRTTI, TControl);
  //GroupDescendentsWith(TfsDialogsRTTI, TControl);
  //GroupDescendentsWith(TfsGraphicsRTTI, TControl);
  //GroupDescendentsWith(TfsMenusRTTI, TControl);
  //GroupDescendentsWith(TfsScript, TControl);
  //GroupDescendentsWith(TfsIniRTTI, TControl);
  //GroupDescendentsWith(TfsFormsRTTI, TControl);
  //GroupDescendentsWith(TfsClassesRTTI, TControl);
  //GroupDescendentsWith(TfsPascal, TControl);
  //GroupDescendentsWith(TfsCPP, TControl);
  //GroupDescendentsWith(TfsJScript, TControl);
  //GroupDescendentsWith(TfsBasic, TControl);
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
