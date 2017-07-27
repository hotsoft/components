// Functions speed test
// accessing internal functions


function Func(a, b: Integer): Integer;
begin
  Result := a + b;
end;

var
  i, j, k: Integer;
begin
  j := 1;
  for i := 0 to 1000000 do
    k := Func(i, j);
end.
