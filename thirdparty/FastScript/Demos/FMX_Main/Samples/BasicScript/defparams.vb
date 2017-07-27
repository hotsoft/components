' FastScript v1.0          
' Default params demo      


sub p1(i, j = 1)
  ShowMessage(IntToStr(i) + " " + IntToStr(j))
end sub

dim i

  p1(0)
  p1(1, 2)
  p1(0)
  i = 0
  Inc(i)
  Inc(i, 2)
  ShowMessage(i)

