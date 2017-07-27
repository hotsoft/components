
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Registration unit             }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMXfs_iibxreg;

{$i fs.inc}

interface


procedure Register;

implementation

uses
  System.Classes
, FMX.Types
, DesignIntf
, FMX.fs_iibxrtti;

{-----------------------------------------------------------------------}

procedure Register;
begin
  //GroupDescendentsWith(TfsIBXRTTI, TFmxObject);
  RegisterComponents('FastScript FMX', [TfsIBXRTTI]);
end;

end.
