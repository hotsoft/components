
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Registration unit             }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMXfs_iteereg;

{$i fs.inc}

interface


procedure Register;

implementation

uses
  System.Classes
, FMX.Types
, DesignIntf
, FMX.fs_ichartrtti;

{-----------------------------------------------------------------------}

procedure Register;
begin
  //GroupDescendentsWith(TfsChartRTTI, TFmxObject);
  RegisterComponents('FastScript FMX', 
    [TfsChartRTTI]);
end;

end.
