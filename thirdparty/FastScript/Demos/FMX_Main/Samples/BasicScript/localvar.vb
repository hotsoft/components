' FastScript v1.0          
' Local variables demo     


dim i

sub OK(i)
  ShowMessage(i)
  i = 11
end sub

  i = 10
  if i = 10 then OK(1)
  OK(i)

    