{**************************}
{ FastScript v1.0          }
{ Set demo                 }
{**************************}

var
  i, j: Integer;
  s: String;

begin
  s := 'Hello World!'#13#10'It''s working!';

  j := 0;
  for i := 1 to Length(s) do
    if s[i] in [' ', '!', #0..#31, ''''] then
      Inc(j);

  ShowMessage(j);
end.
    