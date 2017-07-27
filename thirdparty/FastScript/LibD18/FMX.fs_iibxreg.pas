
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Registration unit             }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMX.fs_iibxreg;

{$i fs.inc}

interface


procedure Register;

implementation

uses
  Classes
, FMX.Types
, DesignIntf
, FMX.fs_iibxrtti;

{-----------------------------------------------------------------------}

procedure Register;
begin
  //GroupDescendentsWith(TfsIBXRTTI, TControl);
  RegisterComponents('FastScript FMX', [TfsIBXRTTI]);
end;

end.
