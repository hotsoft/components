{**************************}
{ FastScript v1.0          }
{ 'For' operator demo      }
{**************************}

var
  i: Integer;

procedure OK(n: Integer);
begin
  ShowMessage(n);
end;

begin
  for i := 0 to 9 do
    if i = 1 then OK(1)
    else if i = 2 then OK(2)
    else if i = 3 then OK(3)
    else if i = 4 then OK(4)
    else if i = 5 then OK(5);
end.
    