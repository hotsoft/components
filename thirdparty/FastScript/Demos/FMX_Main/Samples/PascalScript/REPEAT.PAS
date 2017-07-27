{**************************}
{ FastScript v1.0          }
{ 'Repeat' operator demo   }
{**************************}

var
  i, j: Integer;

begin
  j := 1;
  i := 0;
  repeat
    j := j + 1;
    Inc(i);
  until i = 10;

  ShowMessage(j);
end.
    