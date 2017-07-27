{**************************}
{ FastScript v1.0          }
{ Default params demo      }
{**************************}

procedure p1(i: Integer; j: Integer = 1);
begin
  ShowMessage(IntToStr(i) + ' ' + IntToStr(j));
end;

var
  i: Integer;

begin
  p1(0);
  p1(1, 2);
  p1(0);
  i := 0;
  Inc(i);
  Inc(i, 2);
  ShowMessage(i);
end.
