var
  ar: array of TEdit;
begin
  SetLength(ar, 2);
  ar[0] := TEdit.Create(nil);
  ar[0].Text := '1';
  ar[1] := TEdit.Create(nil);
  ar[1].Text := '2';
  ShowMessage(ar[0].Text);
  ShowMessage(ar[1].Text);
end.