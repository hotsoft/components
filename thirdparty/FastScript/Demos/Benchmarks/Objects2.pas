// Objects speed test
// access to properties


var
  i, j: Integer;
  c: TComponent;
begin
  c := TComponent.Create(nil);
  for i := 0 to 500000 do
    if c.Tag = 0 then
    begin
      c.Tag := 0;
      c.Name := 'c';
    end;
end.
