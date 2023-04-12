{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clFormChooser;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Forms, Classes, Controls, StdCtrls, Windows, Messages,
{$ELSE}
  Vcl.Forms, System.Classes, Vcl.Controls, Vcl.StdCtrls, Winapi.Windows, Winapi.Messages,
{$ENDIF}
  clHtmlParser;

type
  THttpFormChooser = class(TForm)
    btnOK: TButton;
    lblCaption: TLabel;
    ListBox: TListBox;
    Label1: TLabel;
    procedure ListBoxDblClick(Sender: TObject);
  public
    class function ChooseForm(AParser: TclHtmlParser): Integer; 
  end;

implementation

{$R *.DFM}

{ THttpFormChooser }

class function THttpFormChooser.ChooseForm(AParser: TclHtmlParser): Integer;
var
  i, ScrollWidth: Integer;
  Dlg: THttpFormChooser;
  s: string;
begin
  Dlg := THttpFormChooser.Create(nil);
  try
    ScrollWidth := 0;
    for i := 0 to AParser.Forms.Count - 1 do
    begin
      if (AParser.Forms[i].Controls.Count > 0) then
      begin
        s := AParser.Forms[i].FormName;
        if (s <> '') then
        begin
          s := s + ', ';
        end;
        s := s + AParser.Forms[i].Action;
        if Dlg.ListBox.Canvas.TextWidth(s) > ScrollWidth then
        begin
          ScrollWidth := Dlg.ListBox.Canvas.TextWidth(s);
        end;
        Dlg.ListBox.Items.Add(s);
      end;
    end;
    if (Dlg.ListBox.Items.Count > 1) then
    begin
      Dlg.ListBox.ItemIndex := 0;
      if (Dlg.ListBox.Width < ScrollWidth) then
      begin
        SendMessage(Dlg.ListBox.Handle, LB_SETHORIZONTALEXTENT, ScrollWidth + 10, 0);
      end;
      Dlg.ShowModal();
      Result := Dlg.ListBox.ItemIndex;
    end else
    begin
      Result := 0;
    end;
  finally
    Dlg.Free();
  end;
end;

procedure THttpFormChooser.ListBoxDblClick(Sender: TObject);
begin
  ModalResult := mrOK;
  Close();
end;

end.
