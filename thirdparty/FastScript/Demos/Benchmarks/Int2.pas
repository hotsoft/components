// Integer speed test


var
  i, j, k: Integer;
begin
  k := 1;
  for i := 0 to 100000 do
  begin
    k := k + 1;
    for j := 1 to 10 do
      if (j < i + 1) or (k * 2 < j) then
        k := 2 * (i + j);
  end;
end.

