{***********************************************************************}
{ TAdvCurve component                                                   }
{ for Delphi & C++Builder                                               }
{                                                                       }
{ written by                                                            }
{   TMS Software                                                        }
{   Copyright © 2013                                                    }
{   Email : info@tmssoftware.com                                        }
{   Web : http://www.tmssoftware.com                                    }
{***********************************************************************}

unit AdvCurveRegDE;

interface

{$I TMSDEFS.INC}

uses
  Classes, AdvCurve, AdvCurveDE, AdvCurveEditor
  {$IFDEF DELPHI6_LVL}
  , DesignIntf, DesignEditors
  {$ELSE}
  , DsgnIntf
  {$ENDIF}
  ;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('TMS Misc', [TAdvCurveEditorDialog]);
  RegisterPropertyEditor(TypeInfo(TCurvePoints),TAdvCurve,'Points',TCurvePointsProperty);
  RegisterComponentEditor(TAdvCurve, TCurveEditor);
end;

end.

