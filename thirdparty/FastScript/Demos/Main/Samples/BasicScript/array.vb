'**************************
' FastScript v1.0          
' Arrays demo              
'**************************

dim i, j
dim ar[10]
dim s

for i = 0 to 9
  ar[i] = IntToStr(i)
next

s = ""
for i = 0 to 9 
  s = s + ar[i]
next

ShowMessage(s)


    