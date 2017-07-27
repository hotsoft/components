// Functions speed test
// accessing external functions


var
  i, j, k: Integer;
begin
  k := 1;
  for i := 0 to 200000 do
    k := StrToInt(IntToStr(i));
end.
