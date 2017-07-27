' FastScript v1.0          
' Forms demo 1             


' Form1 is predefined object 
' - the main form of this application

  Form1.Caption = "It works!"
  Form1.Font.Style = fsBold + fsItalic
  ShowMessage("Font changed")
  Form1.Font.Style = 0
