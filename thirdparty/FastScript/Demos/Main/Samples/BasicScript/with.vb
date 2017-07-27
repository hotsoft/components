' FastScript v1.0          
' With operator demo       


dim f, b


sub ButtonClick(Sender)
  ShowMessage(Sender.Name)
  f.ModalResult = mrOk
end sub

sub ButtonMouseMove(Sender)
  b.Caption = "moved over"
end sub



  f = new TForm(nil)
  with f
    Caption = "Test it!"
    BorderStyle = bsDialog
    Position = poScreenCenter
  end with

  b = new TButton(f)
  with b
    Name = "Button1"
    Parent = f
    SetBounds(10, 10, 75, 25)
    Caption = "Test"

    OnClick = AddressOf ButtonClick
    OnMouseMove = AddressOf ButtonMouseMove
  end with

  f.ShowModal
  delete f

