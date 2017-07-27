' FastScript v1.0          
' 'is' operator demo       


dim o, p

  o = new TObject
  p = new TPersistent
  if o is TObject then
    ShowMessage("o is TObject")
  end if
  if p is TObject then
    ShowMessage("p is TObject")
  end if
  if not (o is TPersistent) then
    ShowMessage("o is not TPersistent")
  end if
