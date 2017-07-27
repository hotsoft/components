
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Registration unit             }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMXfs_iadoreg;

{$i fs.inc}

interface


procedure Register;

implementation

uses
  System.Classes
, DesignIntf
, FMX.Types
, FMX.fs_iadortti;

{-----------------------------------------------------------------------}

procedure Register;
begin
  //GroupDescendentsWith(TfsADORTTI, TFmxObject);
  RegisterComponents('FastScript FMX', [TfsADORTTI]);
end;

end.
