{**************************}
{ FastScript v1.0          }
{ String demo              }
{**************************}

var
  i, j: Integer;
  s: String;

begin
  s := 'Hello World!'#13#10'It''s working!';

  j := 0;
  for i := 1 to Length(s) do
    if s[i] = ' ' then
      Inc(j);

  ShowMessage(j);
end.
    