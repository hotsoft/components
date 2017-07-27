// Float speed test
// check whether engine can optimize a := a op b 


var
  i, j: Integer;
  k, m: Extended;
begin
  k := 0.12345;
  m := -1;
  for i := 0 to 100000 do
  begin
    k := k + 0.00001;
    for j := 1 to 20 do
    begin
      k := k + 0.001 * (i + j);
      m := k / 0.5;
    end;
  end;
end.

