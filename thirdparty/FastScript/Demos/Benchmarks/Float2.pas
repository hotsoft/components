// Float speed test


var
  i, j: Integer;
  k: Extended;
begin
  k := 0.12345;
  for i := 0 to 100000 do
  begin
    k := k + 0.00001;
    for j := 1 to 10 do
      if (j < i + 1) or (k * 2 < j) then
        k := k + 0.001 * (i + j);
  end;
end.

