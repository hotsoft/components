var
  ar: Variant;
begin
  ar := VarArrayCreate([0, 1], varInteger);
  ar[0] := 1;
  ar[1] := 2;
  ShowMessage(ar[0]);
  ShowMessage(ar[1]);
end.