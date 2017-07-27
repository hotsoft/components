{**************************}
{ FastScript v1.0          }
{ With operator demo       }
{**************************}

var
  f: TForm;
  b: TButton;

procedure ButtonClick(Sender: TButton);
begin
  ShowMessage(Sender.Name);
  f.ModalResult := mrOk;
end;

// there is no necessary to use all parameters 
// in the event handlers
// because no type checking is performed
procedure ButtonMouseMove(Sender: TButton);
begin
  b.Caption := 'moved over';
end;

begin
  f := TForm.Create(nil);
  with f do
  begin
    Caption := 'Test it!';
    BorderStyle := bsDialog;
    Position := poScreenCenter;
  end;

  b := TButton.Create(f);
  with b do
  begin
    Name := 'Button1';
    Parent := f;
    SetBounds(10, 10, 75, 25);
    Caption := 'Test';

    OnClick := @ButtonClick; { same as b.OnClick := 'ButtonClick' }
    OnMouseMove := @ButtonMouseMove;
  end;

  with f do
  begin
    ShowModal;
    Free;
  end;
end.