
{******************************************}
{                                          }
{             FastScript v1.9              }
{   Function/Classes tree visual control   }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_tree;

interface

{$I fs.inc}

uses
{$IFNDEF CLX}
  {$IFNDEF FPC}
    Windows, Messages
  {$ELSE}
    LResources
  {$ENDIF},
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, fs_synmemo
{$ELSE}
  Classes, QGraphics, QControls, QStdCtrls, QExtCtrls, QComCtrls, QImgList
{$ENDIF},
  fs_XML, fs_iinterpreter;

type
  TfsTree = class(TPanel)
  private
    Tree: TTreeView;
    FXML: TfsXMLDocument;
    FImages: TImageList;
    FScript: TfsScript;
    FShowFunctions: boolean;
    FShowClasses: boolean;
    FShowTypes: Boolean;
    FShowVariables: Boolean;
    FExpanded: boolean;
    FExpandLevel : integer;
{$IFNDEF CLX}
    FMemo: TfsSyntaxMemo;
{$ELSE}
    FMemo: TMemo;
{$ENDIF}
    FUpdating: Boolean;
    procedure FillTree;
{$IFNDEF CLX}
    procedure SetMemo(Value: TfsSyntaxMemo);
{$ELSE}
    procedure SetMemo(Value: TMemo);
{$ENDIF}
    procedure SetImageIndex(Node: TTreeNode; Index: Integer);
    procedure SetScript(const Value: TfsScript);
    procedure TreeCollapsed(Sender: TObject; Node: TTreeNode);
    procedure TreeExpanded(Sender: TObject; Node: TTreeNode);
  protected
    procedure TreeChange(Sender: TObject; Node: TTreeNode);
    procedure TreeDblClick(Sender: TObject);
    procedure Notification(AComponent: TComponent;
                           Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetColor(Color: TColor);
    procedure UpdateItems;
    function GetFieldName: String;
  published
    property Align;
    property Anchors;
{$IFNDEF CLX}
  {$IFNDEF FPC}
    property ParentCtl3D;
  {$ENDIF}
    property DragCursor;
    property DragKind;
    property DragMode;
    property BiDiMode;
    property ParentBiDiMode;
{$ENDIF}
    property Color;
    property Constraints;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Script: TfsScript read FScript write SetScript;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
{$IFNDEF CLX}
    property SyntaxMemo: TfsSyntaxMemo read FMemo write SetMemo;
{$ELSE}
    property SyntaxMemo: TMemo read FMemo write SetMemo;
{$ENDIF}
    property ShowClasses: boolean read FShowClasses write FShowClasses;
    property ShowFunctions: boolean read FShowFunctions write FShowFunctions;
    property ShowTypes: boolean read FShowTypes write FShowTypes;
    property ShowVariables: boolean read FShowVariables write FShowVariables;
    property Expanded: boolean read FExpanded write FExpanded;
    property ExpandLevel: integer read FExpandLevel write FExpandLevel;

    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

implementation

{$IFNDEF FPC}
  {$R *.res}
{$ENDIF}

uses fs_iTools;

procedure TfsTree.SetImageIndex(Node: TTreeNode; Index: Integer);
begin
  Node.ImageIndex := Index;
{$IFNDEF CLX}
  Node.StateIndex := Index;
{$ENDIF}
  Node.SelectedIndex := Index;
end;

{$IFDEF FPC}
procedure CorrectFPCBitmap(ABitmap: TBitmap);
var
  Stream: TStream;
begin
  // in order to get fully correct TBitmap we should save it and load
  Stream := TMemoryStream.Create;
  ABitmap.SaveToStream(Stream);
  Stream.Position := 0;
  ABitmap.LoadFromStream(Stream);
  Stream.Free;
end;

procedure LoadImageList(IL: TImageList; const ImageName: string; MaskColor: TColor = clNone);
var
  Images,
  OneImage: TBitmap;
  I: Integer;
  Source,
  Dest: TRect;
begin
  try
    Images := TBitmap.Create;
    Images.LoadFromLazarusResource(ImageName);

    try
      Assert(Images.Height > 0, 'Internal image "' + ImageName + '" is missing or corrupt.');

      if IL.Count = 0 then
      begin
        IL.Height := Images.Height;
        IL.Width := Images.Height;
      end;
      if MaskColor = clNone then
        MaskColor := Images.Canvas.Pixels[0, 0];
      Dest := Rect(0, 0, IL.Width, IL.Height);
      for I := 0 to (Images.Width div Images.Height) - 1 do
      begin
        OneImage := TBitmap.Create;
        OneImage.Width := IL.Width;
        OneImage.Height := IL.Height;
        Source := Rect(I * IL.Width, 0, (I + 1) * IL.Width, IL.Height);
        OneImage.Canvas.CopyRect(Dest, Images.Canvas, Source);

        CorrectFPCBitmap(OneImage);
        OneImage.TransparentColor := MaskColor;
        OneImage.Transparent := True;
        IL.Add(OneImage, nil);
      end;
    finally
      Images.Free;
    end;
  finally
  end;
end;
{$ENDIF}

constructor TfsTree.Create(AOwner: TComponent);
{$IFNDEF FPC}
var
  Images: TBitmap;
{$ENDIF}
begin
  inherited;
  Parent := AOwner as TWinControl;
  BevelOuter :=  bvNone;
  Tree := TTreeView.Create(Self);
  with Tree do
  begin
    Parent := Self;
    Align := alClient;
    DragMode := dmAutomatic;
    ReadOnly := True;
    TabOrder := 0;
  end;
  FImages := TImageList.Create(Self);
{$IFNDEF FPC}
  FImages.Masked := true;
  Images := TBitmap.Create;
  Images.LoadFromResourceName(hInstance, 'FSTREE');
{$IFNDEF CLX}
  FImages.AddMasked(Images, Images.TransparentColor);
{$ELSE}
  Images.Transparent := true;
  FImages.Add(Images, nil);
{$ENDIF}
  Images.Free;
{$ELSE}
  // TODO: some problems with imagelist loading still exists
  LoadImageList(FImages, 'FSTREE'{, clFuchsia});
{$ENDIF}
  Tree.Images := FImages;
  Tree.OnCollapsed := TreeCollapsed;
  Tree.OnExpanded := TreeExpanded;
  Tree.OnDblClick := TreeDblClick;
  FXML := TfsXMLDocument.Create;
  Expanded := True;
  ExpandLevel := 2;
  ShowClasses := True;
  ShowFunctions := True;
  ShowTypes := True;
  ShowVariables := True;
  UpdateItems;
  Height := 250;
  Width := 200;
end;

destructor TfsTree.Destroy;
begin
  FImages.Free;
  Tree.Free;
  FUpdating := True;
  FXML.Free;
  inherited;
end;

procedure TfsTree.FillTree;

  function GetCategoryByName(s: String): String;
  begin
    if s = 'ctConv' then  result := 'Conversion'
    else if s = 'ctFormat' then result := 'Formatting'
    else if s = 'ctDate' then result := 'Date/Time'
    else if s = 'ctString' then result := 'String routines'
    else if s = 'ctMath' then result := 'Mathematical'
    else if s = 'ctOther' then result := 'Other'
    else result := s;
  end;

  procedure AddClasses(xi: TfsXMLItem; Root: TTreeNode);
  var
    i: Integer;
    Node: TTreeNode;
    s: String;
  begin
    s := xi.Prop['text'];
    Node := Tree.Items.AddChild(Root, s);
    if xi.Count = 0 then
      Node.Data := xi;
    if Root = nil then
      Node.Text := xi.Name;
    if xi.Count = 0 then
       SetImageIndex(Node, 1)
    else
       SetImageIndex(Node, 2);
    for i := 0 to xi.Count - 1 do
      AddClasses(xi[i], Node);
  end;

  procedure AddFunctions(xi: TfsXMLItem; Root: TTreeNode);
  var
    i: Integer;
    Node: TTreeNode;
    s: String;
  begin
    s := xi.Prop['text'];
    if xi.Count = 0 then
      s := Copy(s, Pos(' ', s) + 1, 255) else  { function }
      s := GetCategoryByName(s);               { category }
    Node := Tree.Items.AddChild(Root, s);
    if xi.Count = 0 then
      Node.Data := xi;
    if Root = nil then
      Node.Text := xi.Name;
    if xi.Count = 0 then
      SetImageIndex(Node, 0)
    else
      SetImageIndex(Node, 2);
    for i := 0 to xi.Count - 1 do
      AddFunctions(xi[i], Node);
  end;

  procedure AddTypes(xi: TfsXMLItem; Root: TTreeNode);
  var
    i: Integer;
    Node: TTreeNode;
    s: String;
  begin
    s := Copy(xi.Prop['text'], 1, 255);
    Node := Tree.Items.AddChild(Root, s);
    if xi.Count = 0 then
      Node.Data := xi;
    if Root = nil then
      Node.Text := xi.Name;
    if xi.Count = 0 then
      SetImageIndex(Node, 0)
    else
      SetImageIndex(Node, 2);
    for i := 0 to xi.Count - 1 do
      AddTypes(xi[i], Node);
  end;

  procedure AddVariables(xi: TfsXMLItem; Root: TTreeNode);
  var
    i: Integer;
    Node: TTreeNode;
    s: String;
  begin
    s := xi.Prop['text'];
    Node := Tree.Items.AddChild(Root, s);
    if xi.Count = 0 then
      Node.Data := xi;
    if Root = nil then
      Node.Text := xi.Name;
    if xi.Count = 0 then
      SetImageIndex(Node, 0)
    else
      SetImageIndex(Node, 2);
    for i := 0 to xi.Count - 1 do
      AddVariables(xi[i], Node);
  end;

  procedure ExpandNodes(level: integer);
  var
    j : integer;
  begin
    if level > 1 then
      for j := 0 to Tree.Items.Count-1 do
        if Tree.Items[j].Level < Level-1 then
           Tree.Items[j].Expand(false);
  end;

begin
  FUpdating := True;
  FXML.Root.Clear;

  GenerateXMLContents(fsGlobalUnit, FXML.Root);
  if FScript <> nil then
    GenerateXMLContents(FScript, FXML.Root);

  Tree.Items.BeginUpdate;
  Tree.Items.Clear;

  if ShowClasses then
    AddClasses(FXML.Root.FindItem('Classes'), nil);

  if ShowFunctions then
    AddFunctions(FXML.Root.FindItem('Functions'), nil);

  if ShowTypes then
    AddTypes(FXML.Root.FindItem('Types'), nil);

  if ShowVariables then
    AddVariables(FXML.Root.FindItem('Variables'), nil);

  if Expanded then
     ExpandNodes(ExpandLevel);

  Tree.TopItem := Tree.Items[0];
  Tree.Items.EndUpdate;
  FUpdating := False;

end;

procedure TfsTree.UpdateItems;
begin
  FillTree;
end;

procedure TfsTree.TreeChange(Sender: TObject;
  Node: TTreeNode);
begin
  if FUpdating then Exit;
end;

procedure TfsTree.TreeDblClick(Sender: TObject);
begin
  if Assigned(SyntaxMemo) then
    if Tree.Selected.Count = 0 then
      SyntaxMemo.SelText := Tree.Selected.Text;
  if Assigned(OnDblClick) then OnDblClick(Self);
end;

function TfsTree.GetFieldName: String;
var
  i, n: Integer;
  s: String;
begin
  Result := '';
  if (Tree.Selected <> nil) and (Tree.Selected.Count = 0) then
  begin
    s := Tree.Selected.Text;
    if Pos('(', s) <> 0 then
      n := 1 else
      n := 0;
    for i := 1 to Length(s) do
{$IFDEF Delphi12}
      if (s[i] = ',') or (s[i] = ';') then
{$ELSE}
      if s[i] in [',', ';'] then
{$ENDIF}
        Inc(n);

    if n = 0 then
      s := Copy(s, 1, Pos(':', s) - 1)
    else
    begin
      s := Copy(s, 1, Pos('(', s));
      for i := 1 to n - 1 do
        s := s + ',';
      s := s + ')';
    end;
    Result := s;
  end;
end;

procedure TfsTree.SetColor(Color: TColor);
begin
  Tree.Color := Color;
end;

{$IFNDEF CLX}
procedure TfsTree.SetMemo(Value: TfsSyntaxMemo);
{$ELSE}
procedure TfsTree.SetMemo(Value: TMemo);
{$ENDIF}
begin
  FMemo := Value;
end;

procedure TfsTree.SetScript(const Value: TfsScript);
begin
  FScript := Value;
  UpdateItems;
end;

procedure TfsTree.TreeCollapsed(Sender: TObject; Node: TTreeNode);
begin
  SetImageIndex(Node, 2);
end;

procedure TfsTree.TreeExpanded(Sender: TObject; Node: TTreeNode);
begin
  SetImageIndex(Node, 3);
end;

procedure TfsTree.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if Operation = opRemove then
    if AComponent = FScript then
      FScript := nil
    else if AComponent = FMemo then
      FMemo := nil
end;

initialization
{$IFDEF FPC}
  {$I fs_tree.lrs}
{$ENDIF}

end.
