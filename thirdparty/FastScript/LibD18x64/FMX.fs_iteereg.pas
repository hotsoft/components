
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Registration unit             }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMX.fs_iteereg;

{$i fs.inc}

interface


procedure Register;

implementation

uses
  Classes
, FMX.Types
, DesignIntf
, FMX.fs_ichartrtti;

{-----------------------------------------------------------------------}

procedure Register;
begin
  //GroupDescendentsWith(TfsChartRTTI, TControl);
  RegisterComponents('FastScript FMX', 
    [TfsChartRTTI]);
end;

end.
