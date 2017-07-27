{**************************}
{ FastScript v1.0          }
{ While operator demo      }
{**************************}

var
  i, j: Integer;

begin
  j := 1;
  i := 0;
  while i < 10 do
  begin
    j := j + 1;
    Inc(i);
  end;

  ShowMessage(j);
end.
    