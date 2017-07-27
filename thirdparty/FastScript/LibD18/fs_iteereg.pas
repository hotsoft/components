
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Registration unit             }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_iteereg;

{$i fs.inc}

interface


procedure Register;

implementation

uses
  Classes
{$IFNDEF Delphi6}
, DsgnIntf
{$ELSE}
{$IFDEF DELPHI16}
, Controls
{$ENDIF}
, DesignIntf
{$ENDIF}
, fs_ichartrtti;

{-----------------------------------------------------------------------}

procedure Register;
begin
{$IFDEF DELPHI16}
//  GroupDescendentsWith(TfsChartRTTI, TControl);
{$ENDIF}
  RegisterComponents('FastScript', 
    [TfsChartRTTI]);
end;

end.
