' FastScript v1.0          
' Forms demo               


dim f, b


sub ButtonClick(Sender)
  ShowMessage(Sender.Name)
  f.ModalResult = mrOk
end sub

sub ButtonMouseMove(Sender)
  b.Text = "moved over"
end sub



  f = TForm.CreateNew(nil)
  f.Caption = "Test it!"
  f.BorderStyle = bsToolWindow
  f.Position = poScreenCenter

  b = new TButton(f)
  b.Name = "Button1"
  b.Parent = f
  b.SetBounds(10, 10, 75, 25)
  b.Text = "Test"

  b.OnClick = AddressOf ButtonClick
  b.OnMouseMove = AddressOf ButtonMouseMove

  f.ShowModal
  delete f
