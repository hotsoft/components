{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clBodyEdit;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Messages, Forms, Menus, Classes, Controls, StdCtrls, ExtCtrls, ComCtrls,
  SysUtils, TypInfo, Graphics, Dialogs, Windows, Types, Grids,
{$ELSE}
  Winapi.Messages, Vcl.Forms, Vcl.Menus, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  System.SysUtils, System.TypInfo, Vcl.Graphics, Vcl.Dialogs, Winapi.Windows, System.Types, Vcl.Grids,
{$ENDIF}
  clBodyChooser, clMailMessage;

type
  TclItemEditor = class
  private
    FItem: TclMessageBody;
    FParent: TWinControl;
    FContentTypeLabel: TLabel;
    FEncodingLabel: TLabel;
    FContentType: TEdit;
    FEncoding: TComboBox;
  protected
    procedure FillControls; virtual;
    procedure FillData; virtual;
    procedure CreateControls; virtual;
    procedure DestroyControls; virtual;
    function GetMaxLabelWidth: Integer; virtual;
    function GetControlsVertivalPos: Integer;
  public
    constructor Create(AItem: TclMessageBody; AParent: TWinControl); virtual;
    destructor Destroy; override;
    procedure AlignControls; virtual;
    property Item: TclMessageBody read FItem;
    property Parent: TWinControl read FParent;
  end;

  TclItemEditorClass = class of TclItemEditor;

  TclTextItemEditor = class(TclItemEditor)
  private
    FRichEdit: TRichEdit;
  protected
    procedure FillControls; override;
    procedure FillData; override;
    procedure CreateControls; override;
    procedure DestroyControls; override;
  public
    procedure AlignControls; override;
  end;

  TclMultipartItemEditor = class(TclItemEditor)
  private
    FButton: TButton;
    procedure ButtonClick(Sender: TObject);
  protected
    procedure CreateControls; override;
    procedure DestroyControls; override;
  public
    procedure AlignControls; override;
  end;

  TclFileItemEditor = class(TclItemEditor)
  private
    FFileNameLabel: TLabel;
    FFileName: TEdit;
    FBrowseButton: TButton;
    procedure DoOnBrowseClick(Sender: TObject);
  protected
    procedure FillControls; override;
    procedure FillData; override;
    procedure CreateControls; override;
    procedure DestroyControls; override;
    function GetMaxLabelWidth: Integer; override;
  public
    procedure AlignControls; override;
  end;

  TclMessageBodyEditorDlg = class(TForm)
    Panel4: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel1: TPanel;
    PageControl: TPageControl;
    tsBodies: TTabSheet;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    pnButtons: TPanel;
    btnAdd: TButton;
    btnDelete: TButton;
    btnUp: TButton;
    btnDown: TButton;
    BodyList: TListBox;
    pmHeaders: TPopupMenu;
    miAdd: TMenuItem;
    miDelete: TMenuItem;
    miUp: TMenuItem;
    miDown: TMenuItem;
    tsContent: TTabSheet;
    Panel7: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    pDetails: TPanel;
    procedure FormResize(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BodyListDblClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    FBodyEditor: TclItemEditor;
    FMailMessage: TclMailMessage;
    procedure SetMessageBodies(const Value: TclMessageBodies);
    procedure LoadBodyList(ASelectedIndex: Integer);
    procedure AddBodyToList(AMessageBody: TclMessageBody);
    function CurrentBody: TclMessageBody;
    procedure StoreBodies;
    function GetMessageBodies: TclMessageBodies;
  protected
    function CreateBodyEditor(AMessageBody: TclMessageBody;
      AParent: TWinControl): TclItemEditor; virtual;
  public
    property MessageBodies: TclMessageBodies read GetMessageBodies write SetMessageBodies;
  end;

function ModifyMessageBodies(AMessageBodies: TclMessageBodies): Boolean;

implementation

uses
  clEncoder;

{$R *.DFM}

function ModifyMessageBodies(AMessageBodies: TclMessageBodies): Boolean;
var
  Dlg: TclMessageBodyEditorDlg;
begin
  Dlg := TclMessageBodyEditorDlg.Create(nil);
  try
    Dlg.MessageBodies := AMessageBodies;
    Result := Dlg.ShowModal() = mrOK;
    if (Result) then
    begin
      AMessageBodies.Assign(Dlg.MessageBodies);
    end;
  finally
    Dlg.Free();
  end;
end;

procedure SetFocusControl(AControl: TWinControl);
begin
  if AControl.CanFocus() then
  begin
    AControl.SetFocus();
  end;
end;

{ TclMessageBodyEditorDlg }

function TclMessageBodyEditorDlg.CreateBodyEditor(AMessageBody: TclMessageBody;
  AParent: TWinControl): TclItemEditor;
const
  BodyCount = 3;
  Bodies: array[0..BodyCount - 1] of TclMessageBodyClass = (
    TclTextBody, TclAttachmentBody, TclMultipartBody);
  Editors: array[0..BodyCount - 1] of TclItemEditorClass = (
    TclTextItemEditor, TclFileItemEditor, TclMultipartItemEditor);
var
  i: Integer;
begin
  Result := nil;
  if (AMessageBody = nil) then Exit;
  for i := Low(Bodies) to High(Bodies) do
  begin
    if (Bodies[i] = AMessageBody.ClassType) then
    begin
      Result := Editors[i].Create(AMessageBody, AParent);
      Break;
    end;
  end;
end;

procedure TclMessageBodyEditorDlg.FormResize(Sender: TObject);
begin
  if (FBodyEditor <> nil) then
  begin
    FBodyEditor.AlignControls();
  end;
end;

procedure TclMessageBodyEditorDlg.btnDeleteClick(Sender: TObject);
var
  Ind: Integer;
begin
  Ind := BodyList.ItemIndex;
  if (Ind > - 1) then
  begin
    MessageBodies.Delete(Ind);
    if (Ind = MessageBodies.Count) then
    begin
      Dec(Ind);
    end;
    LoadBodyList(Ind);
  end;
end;

procedure TclMessageBodyEditorDlg.btnUpClick(Sender: TObject);
var
  Ind: Integer;
begin
  Ind := BodyList.ItemIndex;
  if (Ind > 0) and (Ind < MessageBodies.Count) then
  begin
    MessageBodies.Move(Ind, Ind - 1);
    LoadBodyList(Ind - 1);
  end;
end;

procedure TclMessageBodyEditorDlg.btnDownClick(Sender: TObject);
var
  Ind: Integer;
begin
  Ind := BodyList.ItemIndex;
  if (Ind > -1) and (Ind < MessageBodies.Count - 1) then
  begin
    MessageBodies.Move(Ind, Ind + 1);
    LoadBodyList(Ind + 1);
  end;
end;

procedure TclMessageBodyEditorDlg.SetMessageBodies(const Value: TclMessageBodies);
begin
  MessageBodies.Assign(Value);
  LoadBodyList(0);
end;

procedure TclMessageBodyEditorDlg.FormCreate(Sender: TObject);
begin
  FMailMessage := TclMailMessage.Create(nil);
  PageControl.ActivePage := tsBodies;
end;

procedure TclMessageBodyEditorDlg.FormDestroy(Sender: TObject);
begin
  StoreBodies();
  FMailMessage.Free();
end;

procedure TclMessageBodyEditorDlg.AddBodyToList(AMessageBody: TclMessageBody);
begin
  BodyList.Items.AddObject(AMessageBody.ClassName, AMessageBody);
end;

procedure TclMessageBodyEditorDlg.LoadBodyList(ASelectedIndex: Integer);
var
  i: Integer;
begin
  BodyList.Clear();
  for i := 0 to MessageBodies.Count - 1 do
  begin
    AddBodyToList(MessageBodies[i]);
  end;
  if (BodyList.Items.Count > ASelectedIndex) then
  begin
    BodyList.ItemIndex := ASelectedIndex;
  end;
end;

procedure TclMessageBodyEditorDlg.BodyListDblClick(Sender: TObject);
begin
  PageControl.ActivePage := tsContent;
  PageControlChange(PageControl);
end;

function TclMessageBodyEditorDlg.CurrentBody: TclMessageBody;
begin
  if (BodyList.ItemIndex > -1) then
  begin
    Result := TclMessageBody(BodyList.Items.Objects[BodyList.ItemIndex]);
  end else
  begin
    Result := nil;
  end;
end;

procedure TclMessageBodyEditorDlg.PageControlChange(Sender: TObject);
begin
  FBodyEditor.Free();
  FBodyEditor := nil;
  if (PageControl.ActivePage = tsBodies) then
  begin
    SetFocusControl(BodyList);
  end else
  if (PageControl.ActivePage = tsContent) then
  begin
    FBodyEditor := CreateBodyEditor(CurrentBody(), pDetails);
  end;
end;

procedure TclMessageBodyEditorDlg.FormHide(Sender: TObject);
begin
  StoreBodies();
end;

procedure TclMessageBodyEditorDlg.StoreBodies();
begin
  FBodyEditor.Free();
  FBodyEditor := nil;
end;

procedure TclMessageBodyEditorDlg.btnAddClick(Sender: TObject);
begin
  if TclMessageBodyChooser.AddSingleBody(MessageBodies) then
  begin
    LoadBodyList(MessageBodies.Count - 1);
  end;
end;


function TclMessageBodyEditorDlg.GetMessageBodies: TclMessageBodies;
begin
  Result := FMailMessage.Bodies;
end;

{ TclItemEditor }

procedure TclItemEditor.AlignControls;
var
  w: Integer;
begin
  FContentTypeLabel.Top := 3;
  FEncodingLabel.Top := FContentTypeLabel.Top + FContentType.Height + 3;

  FContentType.Top := 0;
  FEncoding.Top := FContentType.Top + FContentType.Height + 3;

  w := GetMaxLabelWidth();
  FContentType.Left := w;
  FEncoding.Left := w;

  FContentType.Width := Parent.ClientWidth - FContentType.Left;
  FEncoding.Width := Parent.ClientWidth - FEncoding.Left;
end;

constructor TclItemEditor.Create(AItem: TclMessageBody; AParent: TWinControl);
begin
  inherited Create();
  FItem := AItem;
  FParent := AParent;
  CreateControls();
  AlignControls();
  FillControls();
  SetFocusControl(FContentType);
end;

type
  TDummyEncodeMethod = class(TPersistent)
  private
    FEncodeMethod: TclEncodeMethod;
  published
    property EncodeMethod: TclEncodeMethod read FEncodeMethod;
  end;

procedure TclItemEditor.CreateControls;
var
  TypeInfo : PPropInfo;
  i : TclEncodeMethod;
begin
  FContentTypeLabel := TLabel.Create(nil);
  FEncodingLabel := TLabel.Create(nil);
  FContentType := TEdit.Create(nil);
  FEncoding := TComboBox.Create(nil);
  
  FContentTypeLabel.Parent := Parent;
  FEncodingLabel.Parent := Parent;
  FContentType.Parent := Parent;
  FEncoding.Parent := Parent;

  FContentTypeLabel.Caption := 'Content Type';
  FEncodingLabel.Caption := 'Encoding';

  TypeInfo := GetPropInfo(TDummyEncodeMethod.ClassInfo, 'EncodeMethod');
  for i := Low(TclEncodeMethod) to High(TclEncodeMethod) do
  begin
    FEncoding.Items.AddObject(GetEnumName(TypeInfo^.PropType^, Integer(i)), Pointer(i));
  end;
end;

destructor TclItemEditor.Destroy;
begin
  FillData();
  DestroyControls();
  inherited Destroy();
end;

procedure TclItemEditor.DestroyControls;
begin
  FEncoding.Free();
  FContentType.Free();
  FEncodingLabel.Free();
  FContentTypeLabel.Free();
end;

procedure TclItemEditor.FillControls;
begin
  FContentType.Text := Item.ContentType;
  FEncoding.ItemIndex := Integer(Item.Encoding);
end;

procedure TclItemEditor.FillData;
begin
  Item.ContentType := FContentType.Text;
  Item.Encoding := TclEncodeMethod(FEncoding.ItemIndex);
end;

function TclItemEditor.GetControlsVertivalPos: Integer;
begin
  Result := FEncoding.Top + FEncoding.Height + 5;
end;

function TclItemEditor.GetMaxLabelWidth: Integer;
begin
  Result := FContentTypeLabel.Width;
  if (Result < FEncodingLabel.Width) then
  begin
    Result := FEncodingLabel.Width;
  end;
  Result := Result + 4;
end;

{ TclTextItemEditor }

procedure TclTextItemEditor.AlignControls;
begin
  inherited AlignControls();
  FRichEdit.Top := GetControlsVertivalPos();
  FRichEdit.Left := 0;
  FRichEdit.Width := Parent.ClientWidth;
  FRichEdit.Height := Parent.ClientHeight - FRichEdit.Top;
  FRichEdit.Anchors := [akTop, akLeft, akRight, akBottom];
end;

procedure TclTextItemEditor.CreateControls;
begin
  inherited CreateControls();
  FRichEdit := TRichEdit.Create(nil);
  FRichEdit.Parent := Parent;
  FRichEdit.WordWrap := False;
end;

procedure TclTextItemEditor.DestroyControls;
begin
  FRichEdit.Free();
  inherited DestroyControls();
end;

procedure TclTextItemEditor.FillControls;
begin
  inherited FillControls();
  FRichEdit.Lines.Assign((Item as TclTextBody).Strings);
end;

procedure TclTextItemEditor.FillData;
begin
  inherited FillData();
  (Item as TclTextBody).Strings.Assign(FRichEdit.Lines);
end;

{ TclFileItemEditor }

procedure TclFileItemEditor.AlignControls;
begin
  inherited AlignControls();
  FFileNameLabel.Top :=  GetControlsVertivalPos() + 3;

  FFileName.Top := GetControlsVertivalPos();
  FBrowseButton.Top := FFileName.Top;

  FFileName.Left := GetMaxLabelWidth();

  FBrowseButton.Height := FFileName.Height;
  FBrowseButton.Width := FBrowseButton.Height;
  FBrowseButton.Left := Parent.ClientWidth - FBrowseButton.Width;

  FFileName.Width := Parent.ClientWidth - FFileName.Left - FBrowseButton.Width;
end;

procedure TclFileItemEditor.CreateControls;
begin
  inherited CreateControls();
  FFileNameLabel := TLabel.Create(nil);
  FFileName := TEdit.Create(nil);
  FBrowseButton := TButton.Create(nil);

  FFileNameLabel.Parent := Parent;
  FFileName.Parent := Parent;
  FBrowseButton.Parent := Parent;

  FFileNameLabel.Caption := 'File Name';
  FBrowseButton.Caption := '...';
  FBrowseButton.OnClick := DoOnBrowseClick;
end;

procedure TclFileItemEditor.DoOnBrowseClick(Sender: TObject);
var
  dlg: TOpenDialog;
begin
  dlg := TOpenDialog.Create(nil);
  try
    dlg.Filename := FFileName.Text;
    dlg.InitialDir := ExtractFilePath(dlg.Filename);
    dlg.Filter := '*.*';
    dlg.Options := dlg.Options + [ofEnableSizing];
    if dlg.Execute then FFileName.Text := dlg.Filename;
  finally
    dlg.Free();
  end;
end;

procedure TclFileItemEditor.FillControls;
begin
  inherited FillControls();
  FFileName.Text := (Item as TclAttachmentBody).FileName;
end;

procedure TclFileItemEditor.FillData;
begin
  inherited FillData();
  (Item as TclAttachmentBody).FileName := FFileName.Text;
end;

procedure TclFileItemEditor.DestroyControls;
begin
  FBrowseButton.Free();
  FFileName.Free();
  FFileNameLabel.Free();
  inherited DestroyControls();
end;

function TclFileItemEditor.GetMaxLabelWidth: Integer;
begin
  Result := inherited GetMaxLabelWidth();
  if (Result < FFileNameLabel.Width) then
  begin
    Result := FFileNameLabel.Width;
  end;
  Result := Result + 4;
end;

{ TclMultipartItemEditor }

procedure TclMultipartItemEditor.AlignControls;
begin
  inherited AlignControls();
  FButton.Top := GetControlsVertivalPos();
  FButton.Left := 0;
  FButton.Width := Parent.ClientWidth;
end;

procedure TclMultipartItemEditor.CreateControls;
begin
  inherited CreateControls();
  FButton := TButton.Create(nil);
  FButton.Parent := Parent;
  FButton.Caption := 'Edit Multipart Body Content...';
  FButton.OnClick := ButtonClick;
end;

procedure TclMultipartItemEditor.DestroyControls;
begin
  FButton.Free();
  inherited DestroyControls();
end;

procedure TclMultipartItemEditor.ButtonClick(Sender: TObject);
begin
  ModifyMessageBodies((Item as TclMultipartBody).Bodies);
end;

end.
