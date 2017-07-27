// Integer speed test
// check whether engine can optimize a := a op b 


var
  i, j, k, m: Integer;
begin
  k := 1;
  m := 1;
  for i := 0 to 100000 do
  begin
    k := k + 1;
    for j := 1 to 50 do
    begin
      k := k + j * 2;
      m := k div 3;
    end;
  end;
end.
