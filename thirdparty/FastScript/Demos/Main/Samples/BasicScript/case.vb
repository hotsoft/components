' FastScript v1.0          
' 'Case' operator demo    


  dim i = 0, j

  select case i
    case 1: j = 1
    case 2..10: j = 2: Inc(j)
    case else: j = 10
  end select
  ShowMessage(j)

    