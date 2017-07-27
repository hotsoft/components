
{******************************************}
{                                          }
{             FastScript v1.9              }
{            Registration unit             }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit FMX.fs_idbreg;

{$i fs.inc}

interface


procedure Register;

implementation

uses
  Classes
, DesignIntf
, FMX.Types
, FMX.fs_idbrtti;

{-----------------------------------------------------------------------}

procedure Register;
begin
  //GroupDescendentsWith(TfsDBRTTI, TControl);
  RegisterComponents('FastScript FMX', [TfsDBRTTI]);
end;

end.
