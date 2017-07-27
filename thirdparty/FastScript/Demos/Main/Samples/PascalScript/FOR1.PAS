{**************************}
{ FastScript v1.0          }
{ 'For' operator demo 1    }
{**************************}

var
  i, j: Integer;

begin
  j := 1;
  for i := 9 downto 0 do
    Inc(j);
  ShowMessage(j);
end.
    