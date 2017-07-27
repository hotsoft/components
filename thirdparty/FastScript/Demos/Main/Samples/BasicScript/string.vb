' FastScript v1.0          
' String demo              


dim i, j
dim s as String


  s = "Hello World!\r\nIt's working!"

  j = 0
  for i = 1 to Length(s)
    if s[i] = " " then Inc(j)
  next

  ShowMessage(s)
  ShowMessage("spaces: " & j)

    