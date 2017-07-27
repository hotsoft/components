
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Registration unit             }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMXfs_idbreg;

{$i fs.inc}

interface


procedure Register;

implementation

uses
  System.Classes
, DesignIntf
, FMX.Types
, FMX.fs_idbrtti;

{-----------------------------------------------------------------------}

procedure Register;
begin
 // GroupDescendentsWith(TfsDBRTTI, TFmxObject);
  RegisterComponents('FastScript FMX', [TfsDBRTTI]);
end;

end.
