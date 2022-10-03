{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clRequestEdit;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Messages, Forms, Menus, Classes, Controls, StdCtrls, ExtCtrls, ComCtrls,
  Grids, Buttons, SysUtils, TypInfo, Graphics, Dialogs, Windows, Types,
{$ELSE}
  Winapi.Messages, Vcl.Forms, Vcl.Menus, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Grids, Vcl.Buttons, System.SysUtils, System.TypInfo, Vcl.Graphics, Vcl.Dialogs, Winapi.Windows, System.Types,
{$ENDIF}
  clHttpRequest, clMenuButton;

type
  TclItemEditor = class
  private
    FItem: TclHttpRequestItem;
    FParent: TWinControl;
  protected
    procedure FillControls; virtual; abstract;
    procedure FillData; virtual; abstract;
    procedure CreateControls; virtual; abstract;
    procedure DestroyControls; virtual; abstract;
  public
    constructor Create(AItem: TclHttpRequestItem; AParent: TWinControl); virtual;
    destructor Destroy; override;
    procedure AlignControls; virtual; abstract;
    property Item: TclHttpRequestItem read FItem;
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
    constructor Create(AItem: TclHttpRequestItem; AParent: TWinControl); override;
    procedure AlignControls; override;
  end;

  TclFileItemEditor = class(TclItemEditor)
  private
    FFieldNameLabel: TLabel;
    FFileNameLabel: TLabel;
    FContentTypeLabel: TLabel;
    FFieldName: TEdit;
    FFileName: TEdit;
    FBrowseButton: TButton;
    FContentType: TEdit;
    FCanonicalized: TCheckBox;
    procedure DoOnBrowseClick(Sender: TObject);
    function GetItem: TclSubmitFileRequestItem;
  protected
    procedure FillControls; override;
    procedure FillData; override;
    procedure CreateControls; override;
    procedure DestroyControls; override;
  public
    constructor Create(AItem: TclHttpRequestItem; AParent: TWinControl); override;
    procedure AlignControls; override;
  end;

  TclFormItemEditor = class(TclItemEditor)
  private
    FLoading: Boolean;
    FCanonicalized: TCheckBox;
    FFieldName: TEdit;
    FFieldValue: TEdit;
    FFieldNameLabel: TLabel;
    FFieldValueLabel: TLabel;
    function GetItem: TclFormFieldRequestItem;
  protected
    procedure FillControls; override;
    procedure FillData; override;
    procedure CreateControls; override;
    procedure DestroyControls; override;
  public
    constructor Create(AItem: TclHttpRequestItem; AParent: TWinControl); override;
    procedure AlignControls; override;
  end;

  TclHttpRequestEditorDlg = class(TForm)
    Panel4: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel1: TPanel;
    PageControl: TPageControl;
    tsItems: TTabSheet;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    pnButtons: TPanel;
    btnAdd: TButton;
    btnDelete: TButton;
    btnUp: TButton;
    btnDown: TButton;
    ItemList: TListBox;
    pmItems: TPopupMenu;
    miAdd: TMenuItem;
    miDelete: TMenuItem;
    miUp: TMenuItem;
    miDown: TMenuItem;
    tsContent: TTabSheet;
    Panel7: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    pDetails: TPanel;
    N1: TMenuItem;
    miBuildUrl: TMenuItem;
    miBuildFile: TMenuItem;
    miBuildText: TMenuItem;
    procedure FormResize(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnUpClick(Sender: TObject);
    procedure btnDownClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ItemListDblClick(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure miBuildUrlClick(Sender: TObject);
    procedure miBuildFileClick(Sender: TObject);
    procedure miBuildTextClick(Sender: TObject);
  private
    FItemEditor: TclItemEditor;
    FHttpRequest: TclHttpRequest;
    btnBuild: TclMenuButton;
    procedure SetHttpRequest(const Value: TclHttpRequest);
    procedure LoadItemList(ASelectedIndex: Integer);
    procedure AddItemToList(AItem: TclHttpRequestItem);
    function CurrentItem: TclHttpRequestItem;
    procedure StoreItems;
    procedure CreateBuildButton;
  protected        
    function CreateItemEditor(AItem: TclHttpRequestItem;
      AParent: TWinControl): TclItemEditor; virtual;
  public
    property HttpRequest: TclHttpRequest read FHttpRequest write SetHttpRequest;
  end;

function ModifyHttpRequest(AHttpRequest: TclHttpRequest): Boolean;

implementation

uses
  clRequestChooser;

{$R *.DFM}

function ModifyHttpRequest(AHttpRequest: TclHttpRequest): Boolean;
var
  Dlg: TclHttpRequestEditorDlg;
begin
  Dlg := TclHttpRequestEditorDlg.Create(nil);
  try
    Dlg.HttpRequest := AHttpRequest;
    Result := Dlg.ShowModal() = mrOK;
    if (Result) then
    begin
      AHttpRequest.Assign(Dlg.HttpRequest);
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

{ TclHttpRequestEditorDlg }

function TclHttpRequestEditorDlg.CreateItemEditor(AItem: TclHttpRequestItem;
  AParent: TWinControl): TclItemEditor;
const
  ItemCount = 3;
  Items: array[0..ItemCount - 1] of TclHttpRequestItemClass = (
    TclTextRequestItem, TclSubmitFileRequestItem, TclFormFieldRequestItem);
  Editors: array[0..ItemCount - 1] of TclItemEditorClass = (
    TclTextItemEditor, TclFileItemEditor, TclFormItemEditor);
var
  i: Integer;
begin
  Result := nil;
  if (AItem = nil) then Exit;
  for i := Low(Items) to High(Items) do
  begin
    if (Items[i] = AItem.ClassType) then
    begin
      Result := Editors[i].Create(AItem, AParent);
      Break;
    end;
  end;
end;

procedure TclHttpRequestEditorDlg.FormResize(Sender: TObject);
begin
  if (FItemEditor <> nil) then
  begin
    FItemEditor.AlignControls();
  end;
end;

procedure TclHttpRequestEditorDlg.btnDeleteClick(Sender: TObject);
var
  Ind: Integer;
begin
  Ind := ItemList.ItemIndex;
  if (Ind > - 1) then
  begin
    FHttpRequest.Items.Delete(Ind);
    if (Ind = FHttpRequest.Items.Count) then
    begin
      Dec(Ind);
    end;
    LoadItemList(Ind);
  end;
end;

procedure TclHttpRequestEditorDlg.btnUpClick(Sender: TObject);
var
  Ind: Integer;
begin
  Ind := ItemList.ItemIndex;
  if (Ind > 0) and (Ind < FHttpRequest.Items.Count) then
  begin
    FHttpRequest.Items.Move(Ind, Ind - 1);
    LoadItemList(Ind - 1);
  end;
end;

procedure TclHttpRequestEditorDlg.btnDownClick(Sender: TObject);
var
  Ind: Integer;
begin
  Ind := ItemList.ItemIndex;
  if (Ind > -1) and (Ind < FHttpRequest.Items.Count - 1) then
  begin
    FHttpRequest.Items.Move(Ind, Ind + 1);
    LoadItemList(Ind + 1);
  end;
end;

procedure TclHttpRequestEditorDlg.SetHttpRequest(const Value: TclHttpRequest);
begin
  FHttpRequest.Assign(Value);
  LoadItemList(0);
end;

procedure TclHttpRequestEditorDlg.CreateBuildButton;
begin
  btnBuild := TclMenuButton.Create(nil);
  btnBuild.Parent := pnButtons;
  btnBuild.Left := 8;
  btnBuild.Top := 146;
  btnBuild.Height := btnAdd.Height;
  btnBuild.Width := btnAdd.Width;
  btnBuild.Caption := 'Build...';
  btnBuild.AddMenuItem(miBuildUrl.Caption, miBuildUrl.OnClick);
  btnBuild.AddMenuItem(miBuildFile.Caption, miBuildFile.OnClick);
  btnBuild.AddMenuItem(miBuildText.Caption, miBuildText.OnClick);
  btnBuild.OnClick := miBuildTextClick;
end;

procedure TclHttpRequestEditorDlg.FormCreate(Sender: TObject);
begin
  CreateBuildButton();
  FHttpRequest := TclHttpRequest.Create(nil);
  PageControl.ActivePage := tsItems;
end;

procedure TclHttpRequestEditorDlg.FormDestroy(Sender: TObject);
begin
  StoreItems();
  FHttpRequest.Free();
  btnBuild.Free();
end;
                                                        
procedure TclHttpRequestEditorDlg.AddItemToList(AItem: TclHttpRequestItem);
begin
  ItemList.Items.AddObject(AItem.ClassName, AItem);
end;

procedure TclHttpRequestEditorDlg.LoadItemList(ASelectedIndex: Integer);
var
  i: Integer;
begin
  ItemList.Clear();
  for i := 0 to FHttpRequest.Items.Count - 1 do
  begin
    AddItemToList(FHttpRequest.Items[i]);
  end;
  if (ItemList.Items.Count > ASelectedIndex) then
  begin
    ItemList.ItemIndex := ASelectedIndex;
  end;
end;

procedure TclHttpRequestEditorDlg.ItemListDblClick(Sender: TObject);
begin
  PageControl.ActivePage := tsContent;
  PageControlChange(PageControl);
end;

function TclHttpRequestEditorDlg.CurrentItem: TclHttpRequestItem;
begin
  if (ItemList.ItemIndex > -1) then
  begin
    Result := TclHttpRequestItem(ItemList.Items.Objects[ItemList.ItemIndex]);
  end else
  begin
    Result := nil;
  end;
end;

procedure TclHttpRequestEditorDlg.PageControlChange(Sender: TObject);
begin
  FItemEditor.Free();
  FItemEditor := nil;
  if (PageControl.ActivePage = tsItems) then
  begin
    SetFocusControl(ItemList);
  end else
  if (PageControl.ActivePage = tsContent) then
  begin
    FItemEditor := CreateItemEditor(CurrentItem(), pDetails);
  end;
end;

{ TclItemEditor }

constructor TclItemEditor.Create(AItem: TclHttpRequestItem; AParent: TWinControl);
begin
  inherited Create();
  FItem := AItem;
  FParent := AParent;
  CreateControls();
  AlignControls();
  FillControls();
end;

destructor TclItemEditor.Destroy;
begin
  FillData();
  DestroyControls();
  inherited Destroy();
end;

{ TclTextItemEditor }

constructor TclTextItemEditor.Create(AItem: TclHttpRequestItem; AParent: TWinControl);
begin
  inherited Create(AItem, AParent);
  SetFocusControl(FRichEdit);
end;

procedure TclTextItemEditor.AlignControls();
begin
  FRichEdit.Align := alClient;
end;

procedure TclTextItemEditor.CreateControls;
begin
  FRichEdit := TRichEdit.Create(nil);
  FRichEdit.Parent := Parent;
  FRichEdit.WordWrap := False;
end;

procedure TclTextItemEditor.DestroyControls;
begin
  FRichEdit.Free();
end;

procedure TclTextItemEditor.FillControls;
begin
  FRichEdit.Lines.Text := (Item as TclTextRequestItem).TextData;
end;

procedure TclTextItemEditor.FillData;
begin
  (Item as TclTextRequestItem).TextData := FRichEdit.Lines.Text;
end;

{ TclFileItemEditor }

procedure TclFileItemEditor.AlignControls;
  function GetMaxLabelWidth: Integer;
  begin
    Result := FFieldNameLabel.Width;
    if (Result < FFileNameLabel.Width) then
    begin
      Result := FFileNameLabel.Width;
    end;
    if (Result < FContentTypeLabel.Width) then
    begin
      Result := FContentTypeLabel.Width;
    end;
    Result := Result + 4;
  end;

var
  w: Integer;
begin
  FFieldNameLabel.Top := 3;
  FFileNameLabel.Top := FFieldNameLabel.Top + FFieldName.Height + 3;
  FContentTypeLabel.Top := FFileNameLabel.Top + FFileName.Height + 5;

  FFieldName.Top := 0;
  FFileName.Top := FFieldName.Top + FFieldName.Height + 3;
  FBrowseButton.Top := FFileName.Top;
  FContentType.Top := FFileName.Top + FFileName.Height + 5;
  FCanonicalized.Top := FContentType.Top + FContentType.Height + 5;
  
  w := GetMaxLabelWidth();
  FFieldName.Left := w;
  FFileName.Left := w;
  FContentType.Left := w;

  FBrowseButton.Height := FFileName.Height;
  FBrowseButton.Width := FBrowseButton.Height;
  FBrowseButton.Left := Parent.ClientWidth - FBrowseButton.Width;

  FFieldName.Width := Parent.ClientWidth - FFieldName.Left;
  FContentType.Width := Parent.ClientWidth - FContentType.Left;
  FFileName.Width := Parent.ClientWidth - FFileName.Left - FBrowseButton.Width;
  FCanonicalized.Width := Parent.ClientWidth;
end;

procedure TclFileItemEditor.CreateControls;
begin
  FFieldNameLabel := TLabel.Create(nil);
  FFileNameLabel := TLabel.Create(nil);
  FContentTypeLabel := TLabel.Create(nil);
  FFieldName := TEdit.Create(nil);
  FFileName := TEdit.Create(nil);
  FBrowseButton := TButton.Create(nil);
  FContentType := TEdit.Create(nil);
  FCanonicalized := TCheckBox.Create(nil);

  FFieldNameLabel.Parent := Parent;
  FFileNameLabel.Parent := Parent;
  FContentTypeLabel.Parent := Parent;
  FFieldName.Parent := Parent;
  FFileName.Parent := Parent;
  FBrowseButton.Parent := Parent;
  FContentType.Parent := Parent;
  FCanonicalized.Parent := Parent;

  FFieldNameLabel.Caption := 'Field Name';
  FFileNameLabel.Caption := 'File Name';
  FContentTypeLabel.Caption := 'Content Type';
  FBrowseButton.Caption := '...';
  FBrowseButton.OnClick := DoOnBrowseClick;

  FCanonicalized.Caption := 'Canonicalize Fields';
end;

constructor TclFileItemEditor.Create(AItem: TclHttpRequestItem; AParent: TWinControl);
begin
  inherited Create(AItem, AParent);
  SetFocusControl(FFieldName);
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
  FFieldName.Text := GetItem().FieldName;
  FFileName.Text := GetItem().FileName;
  FContentType.Text := GetItem().ContentType;
  FCanonicalized.Checked := GetItem().Canonicalized;
end;

procedure TclFileItemEditor.FillData;
begin
  GetItem().FieldName := FFieldName.Text;
  GetItem().FileName := FFileName.Text;
  GetItem().ContentType := FContentType.Text;
  GetItem().Canonicalized := FCanonicalized.Checked;
end;

function TclFileItemEditor.GetItem: TclSubmitFileRequestItem;
begin
  Result := (Item as TclSubmitFileRequestItem);
end;

procedure TclFileItemEditor.DestroyControls;
begin
  FCanonicalized.Free();
  FContentType.Free();
  FBrowseButton.Free();
  FFileName.Free();
  FFieldName.Free();
  FContentTypeLabel.Free();
  FFileNameLabel.Free();
  FFieldNameLabel.Free();
end;

{ TclFormItemEditor }

procedure TclFormItemEditor.AlignControls;
var
  w: Integer;
begin
  FFieldNameLabel.Top := 3;
  FFieldValueLabel.Top := FFieldNameLabel.Top + FFieldName.Height + 3;
  FFieldName.Top := 0;     
  FFieldValue.Top := FFieldName.Top + FFieldName.Height + 3;
  FCanonicalized.Top := FFieldValue.Top + FFieldValue.Height + 5;

  w := FFieldNameLabel.Width;
  if (w < FFieldValueLabel.Width) then
  begin
    w := FFieldValueLabel.Width;
  end;
  w := w + 4;
  FFieldName.Left := w;
  FFieldValue.Left := w;

  FFieldName.Width := Parent.ClientWidth - FFieldName.Left;
  FFieldValue.Width := Parent.ClientWidth - FFieldValue.Left;
  FCanonicalized.Width := Parent.ClientWidth;
end;

procedure TclFormItemEditor.CreateControls();
begin
  FFieldNameLabel := TLabel.Create(nil);
  FFieldValueLabel := TLabel.Create(nil);
  FFieldName := TEdit.Create(nil);
  FFieldValue := TEdit.Create(nil);
  FCanonicalized := TCheckBox.Create(nil);

  FFieldNameLabel.Parent := Parent;
  FFieldValueLabel.Parent := Parent;
  FFieldName.Parent := Parent;
  FFieldValue.Parent := Parent;
  FCanonicalized.Parent := Parent;

  FFieldNameLabel.Caption := 'Field Name';
  FFieldValueLabel.Caption := 'Field Value';

  FCanonicalized.Caption := 'Canonicalize Fields';
end;

procedure TclFormItemEditor.FillControls();
begin
  FLoading := True;
  try
    FFieldName.Text := GetItem().FieldName;
    FFieldValue.Text := GetItem().FieldValue;
    FCanonicalized.Checked := GetItem().Canonicalized;
  finally
    FLoading := False;
  end;
end;

procedure TclFormItemEditor.FillData();
begin
  GetItem().FieldName := FFieldName.Text;
  GetItem().FieldValue := FFieldValue.Text;
  GetItem().Canonicalized := FCanonicalized.Checked;
end;

constructor TclFormItemEditor.Create(AItem: TclHttpRequestItem; AParent: TWinControl);
begin
  inherited Create(AItem, AParent);
  SetFocusControl(FFieldName);
end;

function TclFormItemEditor.GetItem: TclFormFieldRequestItem;
begin
  Result := (Item as TclFormFieldRequestItem);
end;

procedure TclHttpRequestEditorDlg.FormHide(Sender: TObject);
begin
  StoreItems();
end;

procedure TclHttpRequestEditorDlg.StoreItems();
begin
  FItemEditor.Free();
  FItemEditor := nil;
end;

procedure TclHttpRequestEditorDlg.btnAddClick(Sender: TObject);
begin
  if THttpRequestChooser.AddSingleHttpItem(FHttpRequest) then
  begin
    LoadItemList(FHttpRequest.Items.Count - 1);
  end;
end;

procedure TclFormItemEditor.DestroyControls;
begin
  FCanonicalized.Free();
  FFieldValue.Free();
  FFieldName.Free();
  FFieldValueLabel.Free();
  FFieldNameLabel.Free();
end;

procedure TclHttpRequestEditorDlg.miBuildUrlClick(Sender: TObject);
begin
  if THttpRequestChooser.BuildRequestItemsByUrl(FHttpRequest) then
  begin
    LoadItemList(FHttpRequest.Items.Count - 1);
  end;
end;

procedure TclHttpRequestEditorDlg.miBuildFileClick(Sender: TObject);
begin
  if THttpRequestChooser.BuildRequestItemsByFile(FHttpRequest) then
  begin
    LoadItemList(FHttpRequest.Items.Count - 1);
  end;
end;

procedure TclHttpRequestEditorDlg.miBuildTextClick(Sender: TObject);
begin
  if THttpRequestChooser.BuildRequestItemsByText(FHttpRequest) then
  begin
    LoadItemList(FHttpRequest.Items.Count - 1);
  end;
end;

end.
