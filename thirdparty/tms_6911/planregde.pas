{$I TMSDEFS.INC}

{***********************************************************************}
{ TPlanner component                                                    }
{ for Delphi & C++Builder                                               }
{ version 2.5                                                           }
{                                                                       }
{ written by TMS Software                                               }
{            copyright © 1999-2012                                      }
{            Email : info@tmssoftware.com                               }
{            Web : http://www.tmssoftware.com                           }
{***********************************************************************}

unit planregde;

interface

uses
  Classes, Planner, PlannerWaitList, PlanDE
  {$IFDEF DELPHI6_LVL}
  , DesignIntf
  {$ELSE}
  , DsgnIntf
  {$ENDIF}
  ;

procedure Register;

implementation

procedure Register;
begin
  {$IFDEF DELPHI9_LVL}
  ForceDemandLoadState(dlDisable);
  EnableDemandLoadReport(false);
  {$ENDIF}
  RegisterComponentEditor(TPlanner, TPlannerEditor);
  RegisterComponentEditor(TPlannerWaitList, TPlannerWaitListEditor);  
  RegisterPropertyEditor(TypeInfo(TPlannerSkin),TCustomPlanner,'Skin',TSkinProperty);
end;



end.

