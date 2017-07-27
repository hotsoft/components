// Functions speed test
// recursion


procedure Hanoi(n: Integer; X, Y, Z: String);
begin
  if n > 0 then
  begin
    Hanoi(n - 1, X, Z, Y);
    Hanoi(n - 1, Z, Y, X);
  end;
end;

begin
  Hanoi(20, 'A', 'B', 'C');
end.
