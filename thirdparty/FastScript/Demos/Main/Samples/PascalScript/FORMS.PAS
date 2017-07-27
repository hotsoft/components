{**************************}
{ FastScript v1.0          }
{ Forms demo               }
{**************************}

var
  f: TForm;
  b: TButton;


procedure ButtonClick(Sender: TButton);
begin
  ShowMessage(Sender.Name);
  f.ModalResult := mrOk;
end;

// there is no necessary to use all parameters in event handlers
// because no type checking is performed
procedure ButtonMouseMove(Sender: TButton);
begin
  b.Caption := 'moved over';
end;


begin
  f := TForm.Create(nil);
  f.Caption := 'Test it!';
  f.BorderStyle := bsDialog;
  f.Position := poScreenCenter;

  b := TButton.Create(f);
  b.Name := 'Button1';
  b.Parent := f;
  b.SetBounds(10, 10, 75, 25);
  b.Caption := 'Test';

  b.OnClick := @ButtonClick; { same as b.OnClick := 'ButtonClick' }
  b.OnMouseMove := @ButtonMouseMove;

  f.ShowModal;
  f.Free;
end.
