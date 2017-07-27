// String speed test
// string indexes


var
  i, j: Integer;
  s: String;
begin
  s := '01234567890';
  for i := 0 to 100000 do
  begin
    s[i mod 10 + 1] := ' ';
    for j := 1 to 10 do
    begin
      s[j] := s[j + 1];
      s[j + 1] := s[j];
    end;
  end;
end.

