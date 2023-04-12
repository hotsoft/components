{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clRequestChooser;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Forms, Classes, Controls, StdCtrls, TypInfo, SysUtils, Dialogs, ComCtrls,
{$ELSE}
  Vcl.Forms, System.Classes, Vcl.Controls, Vcl.StdCtrls, System.TypInfo, System.SysUtils, Vcl.Dialogs, Vcl.ComCtrls,
{$ENDIF}
  clHttpRequest, clHtmlParser;

type
  THttpRequestChooser = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lblCaption: TLabel;
    procedure FormShow(Sender: TObject);
  private
    FEditControl: TControl;
    procedure DoOnGetHtmlForm(Sender: TObject; AParser: TclHtmlParser; var AForm: TclHtmlForm);
    function GetRightMargin: Integer;
    procedure DoFileButtonClick(Sender: TObject);
    function GetLeftMargin: Integer;
    procedure SetControlsTabOrder(AStartFrom: Integer);
    procedure SetFocusControl;
  public
    class function AddSingleHttpItem(AHTTPRequest: TclHttpRequest): Boolean;
    class function BuildRequestItemsByUrl(AHTTPRequest: TclHttpRequest): Boolean;
    class function BuildRequestItemsByFile(AHTTPRequest: TclHttpRequest): Boolean;
    class function BuildRequestItemsByText(AHTTPRequest: TclHttpRequest): Boolean;
  end;

implementation

uses
  clFormChooser, clActionInfo;

const
  hcOpenFileDialog = 0;

type
  TControlAccess = class(TControl);
  
{$R *.DFM}

class function THttpRequestChooser.AddSingleHttpItem(AHttpRequest: TclHttpRequest): Boolean;
var
  i: Integer;
  Dlg: THttpRequestChooser;
  ComboBox: TComboBox;
begin
  Dlg := THttpRequestChooser.Create(nil);
  try
    Dlg.Caption := 'Specify Request Item';
    Dlg.lblCaption.Caption := 'Type';
    ComboBox := TComboBox.Create(Dlg);
    ComboBox.Parent := Dlg;
    ComboBox.Left := 46;
    ComboBox.Top := 8;
    ComboBox.Width := 204;
    ComboBox.Style := csDropDownList;
    for i := 0 to GetRegisteredHttpRequestItems().Count - 1 do
    begin
      ComboBox.Items.Add(TclHttpRequestItemClass(GetRegisteredHttpRequestItems()[i]).ClassName);
    end;
    ComboBox.ItemIndex := 0;
    ComboBox.TabOrder := 0;
    Dlg.SetControlsTabOrder(1);
    Result := (Dlg.ShowModal() = mrOK);
    if Result then
    begin
      AHttpRequest.Items.Add(TclHttpRequestItemClass(GetRegisteredHttpRequestItems()[ComboBox.ItemIndex]));
    end;
  finally
    Dlg.Free();
  end;
end;

procedure THttpRequestChooser.DoFileButtonClick(Sender: TObject);
var
  dlg: TOpenDialog;
begin
  dlg := TOpenDialog.Create(nil);
  try
    dlg.Filename := TControlAccess(FEditControl).Text;
    dlg.InitialDir := ExtractFilePath(dlg.Filename);
    dlg.Filter := '*.*';
    dlg.HelpContext := hcOpenFileDialog;
    dlg.Options := dlg.Options + [ofShowHelp, ofEnableSizing];
    if dlg.Execute then
      TControlAccess(FEditControl).Text := dlg.Filename;
  finally
    dlg.Free();
  end;
end;

class function THttpRequestChooser.BuildRequestItemsByFile(AHTTPRequest: TclHttpRequest): Boolean;
var
  Dlg: THttpRequestChooser;
  Edit: TEdit;
  Button: TButton;
  List: TStrings;
  OldOnGetHtmlForm: TclGetHtmlFormEvent;
begin
  Dlg := THttpRequestChooser.Create(nil);
  try
    Dlg.Caption := 'Build Request Items by local file';
    Dlg.lblCaption.Caption := 'File Name';
    Dlg.Width := 500;
    Edit := TEdit.Create(Dlg);
    Dlg.FEditControl := Edit;
    Edit.Parent := Dlg;

    Button := TButton.Create(Dlg);
    Button.Caption := '...';
    Button.OnClick := Dlg.DoFileButtonClick;
    Button.Parent := Dlg;
    Button.Top := 8;
    Button.Width := 22;
    Button.Height := 22;
    Button.Left := Dlg.ClientWidth - Dlg.GetRightMargin() - Button.Width;

    Edit.Left := 66;
    Edit.Top := 8;
    Edit.Width := Dlg.ClientWidth - Edit.Left - Button.Width - Dlg.GetRightMargin() - 1;

    Edit.TabOrder := 0;
    Button.TabOrder := 1;
    Dlg.SetControlsTabOrder(2);
    Result := (Dlg.ShowModal() = mrOK);
    if Result and FileExists(Edit.Text) then
    begin
      List := TStringList.Create();
      OldOnGetHtmlForm := AHttpRequest.OnGetHtmlForm;
      try
        AHttpRequest.OnGetHtmlForm := Dlg.DoOnGetHtmlForm;
        List.LoadFromFile(Edit.Text);
        THttpActionInfo.ShowAction(AHttpRequest.BuildFormPostRequest(List));
      finally
        AHttpRequest.OnGetHtmlForm := OldOnGetHtmlForm;
        List.Free();
      end;
    end;
  finally
    Dlg.Free();
  end;
end;

class function THttpRequestChooser.BuildRequestItemsByUrl(AHTTPRequest: TclHttpRequest): Boolean;
var
  Dlg: THttpRequestChooser;
  Edit: TEdit;
  OldOnGetHtmlForm: TclGetHtmlFormEvent;
begin
  Dlg := THttpRequestChooser.Create(nil);
  try
    Dlg.Caption := 'Build Request Items by Url';
    Dlg.lblCaption.Caption := 'URL';
    Dlg.Width := 500;
    Edit := TEdit.Create(Dlg);
    Dlg.FEditControl := Edit;
    Edit.Parent := Dlg;
    Edit.Left := 46;
    Edit.Top := 8;
    Edit.Width := Dlg.ClientWidth - Edit.Left - Dlg.GetRightMargin();
    Edit.TabOrder := 0;
    Dlg.SetControlsTabOrder(1);
    Result := (Dlg.ShowModal() = mrOK);
    if Result and (system.Pos('http://', LowerCase(Edit.Text)) = 1) then
    begin
      OldOnGetHtmlForm := AHttpRequest.OnGetHtmlForm;
      try
        AHttpRequest.OnGetHtmlForm := Dlg.DoOnGetHtmlForm;
        THttpActionInfo.ShowAction(AHttpRequest.BuildFormPostRequestByUrl(Edit.Text));
      finally
        AHttpRequest.OnGetHtmlForm := OldOnGetHtmlForm;
      end;
    end;
  finally
    Dlg.Free();
  end;
end;

procedure THttpRequestChooser.DoOnGetHtmlForm(Sender: TObject; AParser: TclHtmlParser; var AForm: TclHtmlForm);
var
  num: Integer;
begin
  num := THttpFormChooser.ChooseForm(AParser);
  if (num > -1) and (num < AParser.Forms.Count) then
  begin
    AForm := AParser.Forms[num];
  end;
end;

function THttpRequestChooser.GetRightMargin: Integer;
begin
  Result := ClientWidth - btnCancel.Left - btnCancel.Width;
end;

function THttpRequestChooser.GetLeftMargin: Integer;
begin
  Result := lblCaption.Left;
end;

class function THttpRequestChooser.BuildRequestItemsByText(AHTTPRequest: TclHttpRequest): Boolean;
var
  Dlg: THttpRequestChooser;
  Edit: TRichEdit;
  OldOnGetHtmlForm: TclGetHtmlFormEvent;
begin
  Dlg := THttpRequestChooser.Create(nil);
  try
    Dlg.Caption := 'Build Request Items by Text';
    Dlg.lblCaption.Caption := 'Enter the Html tags to parse';
    Dlg.BorderStyle := bsSizeable;
    Edit := TRichEdit.Create(Dlg);
    Dlg.FEditControl := Edit;
    Edit.Parent := Dlg;
    Edit.Left := Dlg.GetLeftMargin();
    Edit.Top := 29;
    Edit.Height := 4;
    Edit.Width := Dlg.ClientWidth - Edit.Left - Dlg.GetRightMargin();
    Edit.Anchors := [akLeft, akTop, akRight, akBottom];
    Edit.PlainText := True;
    Edit.WordWrap := False;
    Edit.ScrollBars := ssBoth;

    Dlg.Width := 500;
    Dlg.Height := 300;

    Dlg.Constraints.MinWidth := 300;
    Dlg.Constraints.MinHeight := 200;

    Edit.TabOrder := 0;
    Dlg.SetControlsTabOrder(1);
    Result := (Dlg.ShowModal() = mrOK);
    if Result and (Edit.Lines.Count > 0) then
    begin
      OldOnGetHtmlForm := AHttpRequest.OnGetHtmlForm;
      try
        AHttpRequest.OnGetHtmlForm := Dlg.DoOnGetHtmlForm;
        THttpActionInfo.ShowAction(AHttpRequest.BuildFormPostRequest(Edit.Lines));
      finally
        AHttpRequest.OnGetHtmlForm := OldOnGetHtmlForm;
      end;
    end;
  finally
    Dlg.Free();
  end;
end;

procedure THttpRequestChooser.SetControlsTabOrder(AStartFrom: Integer);
begin
  btnOK.TabOrder := AStartFrom;
  btnCancel.TabOrder := AStartFrom + 1;
end;

procedure THttpRequestChooser.SetFocusControl;
var
  i: Integer;
begin
  for i := 0 to ControlCount - 1 do
  begin
    if (Controls[i] is TWinControl)
      and (TWinControl(Controls[i]).TabOrder = 0)
      and (TWinControl(Controls[i]).CanFocus()) then
    begin
      TWinControl(Controls[i]).SetFocus();
      Break;
    end;
  end;
end;

procedure THttpRequestChooser.FormShow(Sender: TObject);
begin
  SetFocusControl();
end;

end.
