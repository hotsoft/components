{**************************}
{ FastScript v1.0          }
{ Arrays demo              }
{**************************}

var
  i, j: Integer;
  ar: array[0..9] of String;
  s: String;

begin
  for i := 0 to 9 do
    ar[i] := IntToStr(i);

  s := '';
  for i := 0 to 9 do
    s := s + ar[i];

  ShowMessage(s);
end.
    