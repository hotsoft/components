{**************************}
{ FastScript v1.0          }
{ 'Case' operator demo     }
{**************************}

var
  i, j: Integer;

begin
  i := 0;
  case i of
    1: j := 1;
    2..10:
      begin
        j := 2;
        Inc(j);
      end;
    else
      j := 10;
  end;
  ShowMessage(j);
end.
    