dim f, b


sub ButtonClick(Sender)
  ShowMessage(Sender.Name)
  f.ModalResult = mrOk
end sub

sub ButtonMouseMove(Sender)
  b.Text = "moved over"
end sub



  f = TForm.CreateNew(nil,0)
  with f
    Caption = "Test it!"
    BorderStyle = bsToolWindow
    Position = poScreenCenter
  end with

  b = new TButton(f)
  with b
    Name = "Button1"
    Parent = f
    SetBounds(10, 10, 75, 25)
    Text = "Test"

    OnClick = AddressOf ButtonClick
    OnMouseMove = AddressOf ButtonMouseMove
  end with

  f.ShowModal
  delete f
