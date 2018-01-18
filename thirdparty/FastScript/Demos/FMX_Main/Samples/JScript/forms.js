//**************************}
//{ FastScript v1.0          }
//{ Forms demo               }
//{**************************/

var f, b;


function ButtonClick(Sender)
{
  ShowMessage(Sender.Name);
  f.ModalResult = mrOk;
}

function ButtonMouseMove(Sender)
{
  b.Text = "moved over";
}



  f = TForm.CreateNew(nil);
  f.Caption = "Test it!";
  f.BorderStyle = bsToolWindow;
  f.Position = poScreenCenter;

  b = new TButton(f);
  b.Name = "Button1";
  b.Parent = f;
  b.SetBounds(10, 10, 75, 25);
  b.Text = "Test";

  b.OnClick = &ButtonClick; // same as b.OnClick = "ButtonClick"
  b.OnMouseMove = &ButtonMouseMove;

  f.ShowModal;
  f.Free;