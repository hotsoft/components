{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clBodyChooser;

interface

{$I ..\common\clVer.inc}
                              
uses
{$IFNDEF DELPHIXE2}
  Forms, Classes, Controls, StdCtrls,
{$ELSE}
  Vcl.Forms, System.Classes, Vcl.Controls, Vcl.StdCtrls,
{$ENDIF}
  clMailMessage;

type
  TclMessageBodyChooser = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    ComboBox: TComboBox;
    lkpType: TLabel;
  public
    class function AddSingleBody(AMessageBodies: TclMessageBodies): Boolean;
  end;

implementation

{$R *.DFM}

{ TclMessageBodyChooser }

class function TclMessageBodyChooser.AddSingleBody(AMessageBodies: TclMessageBodies): Boolean;
var
  i: Integer;
  Dlg: TclMessageBodyChooser;
begin
  Dlg := TclMessageBodyChooser.Create(nil);
  try
    Dlg.Caption := 'Select Body Type';
    for i := 0 to GetRegisteredBodyItems().Count - 1 do
    begin
      Dlg.ComboBox.Items.Add(TclMessageBodyClass(GetRegisteredBodyItems()[i]).ClassName);
    end;
    Dlg.ComboBox.ItemIndex := 0;
    Result := (Dlg.ShowModal() = mrOK);
    if Result then
    begin
      AMessageBodies.Add(TclMessageBodyClass(GetRegisteredBodyItems()[Dlg.ComboBox.ItemIndex]));
    end;
  finally
    Dlg.Free();
  end;
end;

end.
