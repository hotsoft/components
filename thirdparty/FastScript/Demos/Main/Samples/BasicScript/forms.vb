' FastScript v1.0          
' Forms demo               


dim f, b


sub ButtonClick(Sender)
  ShowMessage(Sender.Name)
  f.ModalResult = mrOk
end sub

sub ButtonMouseMove(Sender)
  b.Caption = "moved over"
end sub



  f = new TForm(nil)
  f.Caption = "Test it!"
  f.BorderStyle = bsDialog
  f.Position = poScreenCenter

  b = new TButton(f)
  b.Name = "Button1"
  b.Parent = f
  b.SetBounds(10, 10, 75, 25)
  b.Caption = "Test"

  b.OnClick = AddressOf ButtonClick
  b.OnMouseMove = AddressOf ButtonMouseMove

  f.ShowModal
  delete f

