{**************************}
{ FastScript v1.0          }
{ 'If' operator demo       }
{**************************}

var
  i: Integer;

procedure OK(n: Integer);
begin
  ShowMessage(n);
end;

begin
  i := 10;
  if i = 10 then
  begin
    i := 1;
  end;
  if i = 1 then OK(1)
  else if i = 2 then OK(2)
  else if i = 3 then OK(3)
  else if i = 4 then OK(4)
  else if i = 5 then OK(5);
end.
    