{**************************}
{ FastScript v1.0          }
{ 'is' operator demo       }
{**************************}

var
  o: TObject;
  p: TPersistent;
begin
  o := TObject.Create;
  p := TPersistent.Create;
  if o is TObject then
    ShowMessage('o is TObject');
  if p is TObject then
    ShowMessage('p is TObject');
  if not (o is TPersistent) then
    ShowMessage('o is not TPersistent');
end.