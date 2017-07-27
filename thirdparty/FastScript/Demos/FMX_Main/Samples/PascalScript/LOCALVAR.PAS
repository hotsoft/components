{**************************}
{ FastScript v1.0          }
{ Local variables demo     }
{**************************}

var
  i: Integer;

procedure OK(i: Integer);
begin
  ShowMessage(i);
  i := 11;
end;

begin
  i := 10;

  if i = 10 then
    OK(1);

  OK(i);
end.
    