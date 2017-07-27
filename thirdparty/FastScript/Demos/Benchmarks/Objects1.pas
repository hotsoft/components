// Objects speed test
// access to methods


var
  i, j: Integer;
  l: TList;
begin
  l := TList.Create;
  for i := 0 to 200000 do
  begin
    l.Add(nil);
    l.Delete(0);
  end;
end.
