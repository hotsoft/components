// Expressions speed test
// check whether engine can optimize boolean expressions


var
  i, j: Integer;
  k: Extended;
begin
  for i := 0 to 100000 do
    for j := 1 to 10 do
      if (j > 1) or (j * 10 + 1 < i div 2 + 1) then
        k := 1;
end.

