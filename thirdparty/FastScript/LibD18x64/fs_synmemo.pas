
{******************************************}
{                                          }
{             FastScript v1.9              }
{           Syntax memo control            }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

{ Simple syntax highlighter. Supports Pascal, C++, JS, VB and SQL syntax.

  Assign text to Text property.
  Assign desired value to SyntaxType property.
  Call SetPos to move caret.
  Call ShowMessage to display an error message at the bottom.
}

unit fs_synmemo;

interface

{$I fs.inc}

uses
{$IFNDEF FPC}
  Windows, Messages,
{$ELSE}
  LCLType, LMessages, Buttons, LCLIntf, LResources,
{$ENDIF}
  StdCtrls, Controls, Classes,
  SysUtils, Graphics, Forms, Menus;

type

  TSyntaxType = (stPascal, stCpp, stJs, stVB, stSQL, stText);
  TCharAttr = (caNo, caText, caBlock, caComment, caKeyword, caString);
  TCharAttributes = set of TCharAttr;

  TfsSyntaxMemo = class(TCustomControl)
  private
    FAllowLinesChange: Boolean;
    FCharHeight: Integer;
    FCharWidth: Integer;
    FDoubleClicked: Boolean;
    FDown: Boolean;
    FGutterWidth: Integer;
    FFooterHeight: Integer;
    FIsMonoType: Boolean;
    FKeywords: String;
    FMaxLength: Integer;
    FMessage: String;
    FModified: Boolean;
    FMoved: Boolean;
    FOffset: TPoint;
    FPos: TPoint;
    FReadOnly: Boolean;
    FSelEnd: TPoint;
    FSelStart: TPoint;
    FSynStrings: TStrings;
    FSyntaxType: TSyntaxType;
    FTempPos: TPoint;
    FText: TStringList;
    FKeywordAttr: TFont;
    FStringAttr: TFont;
    FTextAttr: TFont;
    FCommentAttr: TFont;
    FBlockColor: TColor;
    FBlockFontColor: TColor;
    FUndo: TStringList;
    FUpdating: Boolean;
    FUpdatingSyntax: Boolean;
    FVScroll: TScrollBar;
    FWindowSize: TPoint;
    FPopupMenu: TPopupMenu;
    KWheel: Integer;
    LastSearch: String;
    FShowGutter: boolean;
    FShowFooter: boolean;
    Bookmarks: array of Integer;
    FActiveLine: Integer;
    FOnChange: TNotifyEvent;
    function GetText: TStrings;
    procedure SetText(Value: TStrings);
    procedure SetSyntaxType(Value: TSyntaxType);
    procedure SetShowGutter(Value: boolean);
    procedure SetShowFooter(Value: boolean);
    function FMemoFind(Text: String; var Position : TPoint): boolean;
    function GetCharAttr(Pos: TPoint): TCharAttributes;
    function GetLineBegin(Index: Integer): Integer;
    function GetPlainTextPos(Pos: TPoint): Integer;
    function GetPosPlainText(Pos: Integer): TPoint;
    function GetSelText: String;
    function LineAt(Index: Integer): String;
    function LineLength(Index: Integer): Integer;
    function Pad(n: Integer): String;
    procedure AddSel;
    procedure AddUndo;
    procedure ClearSel;
    procedure CreateSynArray;
    procedure DoChange;
    procedure EnterIndent;
    procedure SetSelText(Value: String);
    procedure ShiftSelected(ShiftRight: Boolean);
    procedure ShowCaretPos;
    procedure TabIndent;
    procedure UnIndent;
    procedure UpdateScrollBar;
    procedure UpdateSyntax;
    procedure DoLeft;
    procedure DoRight;
    procedure DoUp;
    procedure DoDown;
    procedure DoHome(Ctrl: Boolean);
    procedure DoEnd(Ctrl: Boolean);
    procedure DoPgUp;
    procedure DoPgDn;
    procedure DoChar(Ch: Char);
    procedure DoReturn;
    procedure DoDel;
    procedure DoBackspace;
    procedure DoCtrlI;
    procedure DoCtrlU;
    procedure DoCtrlR;
    procedure DoCtrlL;
    procedure ScrollClick(Sender: TObject);
    procedure ScrollEnter(Sender: TObject);
    procedure LinesChange(Sender: TObject);
    procedure ShowPos;
    procedure BookmarkDraw(Y :integer; ALine : integer);
    procedure ActiveLineDraw(Y :integer; ALine : integer);
    procedure CorrectBookmark(Line : integer; delta : integer);
    procedure SetKeywordAttr(Value: TFont);
    procedure SetStringAttr(Value: TFont);
    procedure SetTextAttr(Value: TFont);
    procedure SetCommentAttr(Value: TFont);

  protected
    { Windows-specific stuff }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure WMGetDlgCode(var Message: {$IFNDEF FPC}TWMGetDlgCode{$ELSE}TLMNoParams{$ENDIF}); message {$IFNDEF FPC}WM_GETDLGCODE{$ELSE}LM_GETDLGCODE{$ENDIF};
    procedure WMKillFocus(var Msg: {$IFNDEF FPC}TWMKillFocus{$ELSE}TLMKillFocus{$ENDIF}); message {$IFNDEF FPC}WM_KILLFOCUS{$ELSE}LM_KILLFOCUS{$ENDIF};
    procedure WMSetFocus(var Msg: {$IFNDEF FPC}TWMSetFocus{$ELSE}TLMSetFocus{$ENDIF}); message {$IFNDEF FPC}WM_SETFOCUS{$ELSE}LM_SETFOCUS{$ENDIF};
    {$IFNDEF FPC}
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    {$ELSE}
    procedure FontChanged(Sender: TObject); override;
    {$ENDIF}
    { End of stuff }
    procedure SetParent(Value: TWinControl); override;
    function GetClientRect: TRect; override;
    procedure DblClick; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CopyPopup(Sender: TObject);
    procedure PastePopup(Sender: TObject);
    procedure CutPopup(Sender: TObject);
{$IFDEF Delphi4}
    procedure MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
{$ENDIF}
    procedure DOver(Sender, Source: TObject; X, Y: Integer;
         State: TDragState; var Accept: Boolean);
    procedure DDrop(Sender, Source: TObject; X, Y: Integer);

  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Paint; override;
    procedure CopyToClipboard;
    procedure CutToClipboard;
    procedure PasteFromClipboard;
    procedure SetPos(x, y: Integer);
    procedure ShowMessage(s: String);
    procedure Undo;
    procedure UpdateView;
    function GetPos: TPoint;
    function Find(Text: String): boolean;
    property Modified: Boolean read FModified write FModified;
    property SelText: String read GetSelText write SetSelText;
    function  IsBookmark(Line : integer): integer;
    procedure AddBookmark(Line, Number : integer);
    procedure DeleteBookmark(Number : integer);
    procedure GotoBookmark(Number : integer);
    procedure SetActiveLine(Line : Integer);
    function GetActiveLine: Integer;

  published
    property Align;
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentBiDiMode;
{$IFNDEF FPC}
    property ParentCtl3D;
{$ENDIF}
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Width;
    property Height;
    property Visible;
    property BlockColor: TColor read FBlockColor write FBlockColor;
    property BlockFontColor: TColor read FBlockFontColor write FBlockFontColor;
    property CommentAttr: TFont read FCommentAttr write SetCommentAttr;
    property KeywordAttr: TFont read FKeywordAttr write SetKeywordAttr;
    property StringAttr: TFont read FStringAttr write SetStringAttr;
    property TextAttr: TFont read FTextAttr write SetTextAttr;
    property Lines: TStrings read GetText write SetText;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property SyntaxType: TSyntaxType read FSyntaxType write SetSyntaxType;
    property ShowFooter: boolean read FShowFooter write SetShowFooter;
    property ShowGutter: boolean read FShowGutter write SetShowGutter;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
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

  TfsSynMemoSearch = class(TForm)
    Search: TButton;
    Button1: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SynMemoSearch: TfsSynMemoSearch;

implementation

{$IFNDEF FPC}
  {$R *.DFM}
{$ENDIF}

uses Clipbrd, comctrls;

const
  PasKeywords =
     'and,array,begin,case,const,div,do,downto,else,end,except,finally,'+
     'for,function,if,in,is,mod,nil,not,of,or,procedure,program,repeat,shl,'+
     'shr,string,then,to,try,until,uses,var,while,with,xor';

  CppKeywords =
     'bool,break,case,char,continue,define,default,delete,do,double,else,'+
     'except,finally,float,for,if,include,int,is,new,return,string,switch,try,'+
     'variant,void,while';

  SQLKeywords =
    'active,after,all,alter,and,any,as,asc,ascending,at,auto,' +
    'base_name,before,begin,between,by,cache,cast,check,column,commit,' +
    'committed,computed,conditional,constraint,containing,count,create,' +
    'current,cursor,database,debug,declare,default,delete,desc,descending,' +
    'distinct,do,domain,drop,else,end,entry_point,escape,exception,execute,' +
    'exists,exit,external,extract,filter,for,foreign,from,full,function,' +
    'generator,grant,group,having,if,in,inactive,index,inner,insert,into,is,' +
    'isolation,join,key,left,level,like,merge,names,no,not,null,of,on,only,' +
    'or,order,outer,parameter,password,plan,position,primary,privileges,' +
    'procedure,protected,read,retain,returns,revoke,right,rollback,schema,' +
    'select,set,shadow,shared,snapshot,some,suspend,table,then,to,' +
    'transaction,trigger,uncommitted,union,unique,update,user,using,values,' +
    'view,wait,when,where,while,with,work';

  JSKeywords = 
    'break,case,continue,default,delete,do,else,except,finally,for,function,' +
    'import,in,is,if,new,return,switch,try,var,while,with';

  VBKeywords =
    'addressof,and,as,byref,byval,case,catch,delete,dim,do,else,elseif,' +
    'end,endif,exit,finally,for,function,if,imports,is,loop,mod,new,next,' +
    'not,or,rem,return,select,set,step,sub,then,to,try,wend,while,with,xor';


  WordChars = ['a'..'z', 'A'..'Z', '0'..'9', '_'];

{$IFDEF Linux}
  LineBreak: AnsiString = #$A;
{$ELSE}
  LineBreak: String = #$D#$A;
{$ENDIF}

{$IFDEF Delphi12}
function IsUnicodeChar(Chr: Char): Boolean;
begin
  Result := ((Chr >= Char($007F)) and (Chr <= Char($FFFF)));
end;
{$ENDIF}

{type
  THackScrollBar = class(TScrollBar);
}


{ TfsSyntaxMemo }

constructor TfsSyntaxMemo.Create(AOwner: TComponent);
var
  m: TMenuItem;
  i: integer;
begin
  inherited Create(AOwner);

  FVScroll := TScrollBar.Create(Self);

  FCommentAttr := TFont.Create;
  FCommentAttr.Color := clNavy;
  FCommentAttr.Style := [fsItalic];

  FKeywordAttr := TFont.Create;
  FKeywordAttr.Color := clWindowText;
  FKeywordAttr.Style := [fsBold];

  FStringAttr := TFont.Create;
  FStringAttr.Color := clNavy;
  FStringAttr.Style := [];

  FTextAttr := TFont.Create;
  FTextAttr.Color := clWindowText;
  FTextAttr.Style := [];


  if AOwner is TWinControl then
    Parent := AOwner as TWinControl;

  OnDragOver := DOver;
  OnDragDrop := DDrop;

{$IFDEF Delphi4}
  OnMouseWheelUp := MouseWheelUp;
  OnMouseWheelDown := MouseWheelDown;
  KWheel := 1;
{$ENDIF}

  FText := TStringList.Create;
  FUndo := TStringList.Create;
  FSynStrings := TStringList.Create;
  FText.Add('');
  FText.OnChange := LinesChange;
  FMaxLength := 1024;
  SyntaxType := stPascal;
  FMoved := True;
  SetPos(1, 1);
  FOffset := Point(0, 0);

  Cursor := crIBeam;
  FBlockColor := clHighlight;
  FBlockFontColor := clHighlightText;

  Font.Size := 10;
  Font.Name := 'Courier New';

  FPopupMenu := TPopupMenu.Create(Self);
  m := TMenuItem.Create(FPopupMenu);
  m.Caption := 'Cut';
  m.OnClick := CutPopup;
  FPopupMenu.Items.Add(m);
  m := TMenuItem.Create(FPopupMenu);
  m.Caption := 'Copy';
  m.OnClick := CopyPopup;
  FPopupMenu.Items.Add(m);
  m := TMenuItem.Create(FPopupMenu);
  m.Caption := 'Paste';
  m.OnClick := PastePopup;
  FPopupMenu.Items.Add(m);

  LastSearch := '';
  Setlength(Bookmarks, 10);
  for i := 0 to Length(Bookmarks)-1 do
    Bookmarks[i] := -1;

  FActiveLine := -1;

  Height := 200;
  Width := 200;

end;

destructor TfsSyntaxMemo.Destroy;
begin
  FPopupMenu.Free;
  FCommentAttr.Free;
  FKeywordAttr.Free;
  FStringAttr.Free;
  FTextAttr.Free;
  FText.Free;
  FUndo.Free;
  FSynStrings.Free;
  FVScroll.Free;
  inherited;
end;

{ Windows-specific stuff }

procedure TfsSyntaxMemo.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do
    ExStyle := ExStyle or WS_EX_CLIENTEDGE;
end;

procedure TfsSyntaxMemo.WMKillFocus(var Msg: {$IFNDEF FPC}TWMKillFocus{$ELSE}TLMKillFocus{$ENDIF});
begin
  inherited;

  HideCaret(Handle);
  DestroyCaret{$IFDEF FPC}(Handle){$ENDIF};
end;

procedure TfsSyntaxMemo.WMSetFocus(var Msg: {$IFNDEF FPC}TWMSetFocus{$ELSE}TLMSetFocus{$ENDIF});
begin
  inherited;
  CreateCaret(Handle, 0, 2, FCharHeight);
  ShowCaretPos;
end;

procedure TfsSyntaxMemo.ShowCaretPos;
begin
  SetCaretPos(FCharWidth * (FPos.X - 1 - FOffset.X) + FGutterWidth,
    FCharHeight * (FPos.Y - 1 - FOffset.Y));
  ShowCaret(Handle);
  ShowPos;
end;

procedure TfsSyntaxMemo.ShowPos;
begin
  if FFooterHeight > 0 then
    with Canvas do
    begin
      Font.Name := 'Tahoma';
      Font.Color := clBlack;
      Font.Style := [];
      Font.Size := 8;
      Brush.Color := clBtnFace;
    {$IFDEF FPC}
      FillRect(FGutterWidth + 4, Height - TextHeight('|') - 5, Width - 5, Height - 5);
    {$ENDIF}
      TextOut(FGutterWidth + 4, Height - TextHeight('|') - 5, IntToStr(FPos.y) + ' : ' + IntToStr(FPos.x) + '    ');
    end;
end;

procedure TfsSyntaxMemo.WMGetDlgCode(var Message: {$IFNDEF FPC}TWMGetDlgCode{$ELSE}TLMNoParams{$ENDIF});
begin
  Message.Result := DLGC_WANTARROWS or DLGC_WANTTAB or DLGC_WANTALLKEYS or DLGC_WANTCHARS;
end;

{$IFNDEF FPC}
procedure TfsSyntaxMemo.CMFontChanged(var Message: TMessage);
{$ELSE}
procedure TfsSyntaxMemo.FontChanged(Sender: TObject);
{$ENDIF}
var
  b: TBitmap;
begin
  FCommentAttr.Size := Font.Size;
  FCommentAttr.Name := Font.Name;
  FKeywordAttr.Size := Font.Size;
  FKeywordAttr.Name := Font.Name;
  FStringAttr.Size := Font.Size;
  FStringAttr.Name := Font.Name;
  FTextAttr.Size := Font.Size;
  FTextAttr.Name := Font.Name;

  b := TBitmap.Create;
  with b.Canvas do
  begin
    Font.Assign(Self.Font);
    Font.Style := [fsBold];
    FCharHeight := TextHeight('Wg');
    FCharWidth := TextWidth('W');
    FIsMonoType := Pos('COURIER NEW', AnsiUppercase(Self.Font.Name)) <> 0;
  end;
  b.Free;
end;

{ End of stuff }

procedure TfsSyntaxMemo.SetParent(Value: TWinControl);
begin
  inherited SetParent(Value);
  if (Parent = nil) or (csDestroying in ComponentState) then Exit;

  DoubleBuffered := True;
  ShowGutter := True;
  ShowFooter := True;
  FVScroll.Parent := Self;
  FVScroll.Kind := sbVertical;
  FVScroll.OnChange := ScrollClick;
  FVScroll.OnEnter := ScrollEnter;
{$IFNDEF FPC}
  FVScroll.Ctl3D := False;
{$ENDIF}
  Color := clWindow;
  TabStop := True;
end;


function TfsSyntaxMemo.GetClientRect: TRect;
begin
  if FVScroll.Visible then
    Result := Bounds(0, 0, Width - FVScroll.Width - 4, Height) else
    Result := inherited GetClientRect;
end;

procedure TfsSyntaxMemo.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited;
  if FCharWidth = 0 then exit;
  FWindowSize := Point((ClientWidth - FGutterWidth) div FCharWidth,
                       (Height - FFooterHeight) div FCharHeight );
  FVScroll.SetBounds(Width - FVScroll.Width - 4, 0, FVScroll.Width, Height - 4);
  UpdateScrollBar;
end;

procedure TfsSyntaxMemo.UpdateSyntax;
begin
  CreateSynArray;
  Repaint;
end;

procedure TfsSyntaxMemo.UpdateScrollBar;
begin
  with FVScroll do
  begin
// prevent OnScroll event
    FUpdating := True;

    Position := 0;
    PageSize := 0;
    Max := FText.Count;
    SmallChange := 1;
    if FWindowSize.Y < Max then
    begin
      Visible := True;
      PageSize := FWindowSize.Y;
    end
    else
      Visible := False;
    LargeChange := FWindowSize.Y;
    Position := FOffset.Y;

// need to do this due to bug in the VCL
//    THackScrollBar(FVScroll).RecreateWnd;
    FUpdating := False;
  end;
end;

function TfsSyntaxMemo.GetText: TStrings;
var
  i: Integer;
begin
  for i := 0 to FText.Count - 1 do
    FText[i] := LineAt(i);
  Result := FText;
  FAllowLinesChange := True;
end;

procedure TfsSyntaxMemo.SetText(Value: TStrings);
begin
  FAllowLinesChange := True;
  FText.Assign(Value);
end;

procedure TfsSyntaxMemo.SetSyntaxType(Value: TSyntaxType);
begin
  FSyntaxType := Value;
  if Value = stPascal then
    FKeywords := PasKeywords
  else if Value = stCpp then
    FKeywords := CppKeywords
  else if Value = stSQL then
    FKeywords := SQLKeywords
  else if Value = stVB then
    FKeywords := VBKeywords
  else if Value = stJS then
    FKeywords := JSKeywords
  else
    FKeywords := '';
  UpdateSyntax;
end;

function TfsSyntaxMemo.GetPos: TPoint;
begin
  Result := FPos;
end;

procedure TfsSyntaxMemo.DoChange;
begin
  FModified := True;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TfsSyntaxMemo.LinesChange(Sender: TObject);
begin
  if FAllowLinesChange then
  begin
    UpdateSyntax;
    FAllowLinesChange := False;
    if FText.Count = 0 then
      FText.Add('');
    FMoved := True;
    FUndo.Clear;
    //FPos := Point(1, 1);
   // FOffset := Point(0, 0);
    SetPos(FPos.X, FPos.Y);
    ClearSel;
    ShowCaretPos;
    UpdateScrollBar;
  end;
end;

procedure TfsSyntaxMemo.ShowMessage(s: String);
begin
  FMessage := s;
  Repaint;
end;

procedure TfsSyntaxMemo.CopyToClipboard;
begin
  if FSelStart.X <> 0 then
    Clipboard.AsText := SelText;
end;

procedure TfsSyntaxMemo.CutToClipboard;
begin
  if not FReadOnly then
  begin
    if FSelStart.X <> 0 then
    begin
      Clipboard.AsText := SelText;
      SelText := '';
    end;
    CorrectBookmark(FSelStart.Y, FSelStart.Y - FSelEnd.Y);
    Repaint;
  end;
end;

procedure TfsSyntaxMemo.PasteFromClipboard;
begin
  if not FReadOnly then
    SelText := Clipboard.AsText;
end;

function TfsSyntaxMemo.LineAt(Index: Integer): String;
begin
  if Index < FText.Count then
    Result := TrimRight(FText[Index])
  else
    Result := '';
end;

function TfsSyntaxMemo.LineLength(Index: Integer): Integer;
begin
  if Index < 0 then 
    Result := 0 else
    Result := Length(LineAt(Index));
end;

function TfsSyntaxMemo.Pad(n: Integer): String;
begin
  result := '';
  SetLength(result, n);
{$IFDEF Delphi12}
  Result := StringOfChar(Char(' '), n)
{$ELSE}
  FillChar(result[1], n, Char(' '));
{$ENDIF}
end;

procedure TfsSyntaxMemo.AddUndo;
begin
  if not FMoved then exit;
  FUndo.Add(Format('%5d%5d', [FPos.X, FPos.Y]) + FText.Text);
  if FUndo.Count > 32 then
    FUndo.Delete(0);
end;

procedure TfsSyntaxMemo.Undo;
var
  s: String;
begin
  FMoved := True;
  if FUndo.Count = 0 then exit;
  s := FUndo[FUndo.Count - 1];
  FPos.X := StrToInt(Copy(s, 1, 5));
  FPos.Y := StrToInt(Copy(s, 6, 5));
  FText.Text := Copy(s, 11, Length(s) - 10);
  FUndo.Delete(FUndo.Count - 1);
  SetPos(FPos.X, FPos.Y);
  UpdateSyntax;
  DoChange;
end;

function TfsSyntaxMemo.GetPlainTextPos(Pos: TPoint): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Pos.Y - 2 do
    Result := Result + Length(FText[i]) + Length(LineBreak);
  Result := Result + Pos.X;
end;

function TfsSyntaxMemo.GetPosPlainText(Pos: Integer): TPoint;
var
  i: Integer;
  s: String;
begin
  Result := Point(0, 1);
  s := FText.Text;
  i := 1;
  while i <= Pos do
{$IFDEF Delphi12}
    if s[i] = Char(LineBreak[1]) then
{$ELSE}
    if s[i] = LineBreak[1] then
{$ENDIF}
    begin
      Inc(i, Length(LineBreak));
      if i <= Pos then
      begin
        Inc(Result.Y);
        Result.X := 0;
      end
      else
        Inc(Result.X);
    end
    else
    begin
      Inc(i);
      Inc(Result.X);
    end;
end;

function TfsSyntaxMemo.GetLineBegin(Index: Integer): Integer;
var
  s: String;
begin
  s := FText[Index];
  Result := 1;
  if Trim(s) <> '' then
    for Result := 1 to Length(s) do
      if s[Result] <> ' ' then
        break;
end;

procedure TfsSyntaxMemo.TabIndent;
var
  i, n, res: Integer;
  s: String;
begin
  res := FPos.X;
  i := FPos.Y - 2;

  while i >= 0 do
  begin
    res := FPos.X;
    s := FText[i];
    n := LineLength(i);

    if res > n then
      Dec(i)
    else
    begin
      if s[res] = ' ' then
      begin
        while s[res] = ' ' do
          Inc(res);
      end
      else
      begin
        while (res <= n) and (s[res] <> ' ') do
          Inc(res);

        while (res <= n) and (s[res] = ' ') do
          Inc(res);
      end;
      break;
    end;
  end;

  SelText := Pad(res - FPos.X);
end;

procedure TfsSyntaxMemo.EnterIndent;
var
  res: Integer;
begin
  if Trim(FText[FPos.Y - 1]) = '' then
    res := FPos.X else
    res := GetLineBegin(FPos.Y - 1);

  CorrectBookmark(FPos.Y, 1);

  FPos := Point(1, FPos.Y + 1);
  SelText := Pad(res - 1);
end;

procedure TfsSyntaxMemo.UnIndent;
var
  i, res: Integer;
begin
  i := FPos.Y - 2;
  res := FPos.X - 1;
  CorrectBookmark(FPos.Y, -1);
  while i >= 0 do
  begin
    res := GetLineBegin(i);
    if (res < FPos.X) and (Trim(FText[i]) <> '') then
      break else
      Dec(i);
  end;
  FSelStart := FPos;
  FSelEnd := FPos;
  Dec(FSelEnd.X, FPos.X - res);
  SelText := '';
end;

procedure TfsSyntaxMemo.ShiftSelected(ShiftRight: Boolean);
var
  i, ib, ie: Integer;
  s: String;
  Shift: Integer;
begin
  if FReadOnly then exit;
  AddUndo;
  if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then
  begin
    ib := FSelStart.Y - 1;
    ie := FSelEnd.Y - 1;
  end
  else
  begin
    ib := FSelEnd.Y - 1;
    ie := FSelStart.Y - 1;
  end;
  if FSelEnd.X = 1 then
    Dec(ie);

  Shift := 2;
  if not ShiftRight then
    for i := ib to ie do
    begin
      s := FText[i];
      if (Trim(s) <> '') and (GetLineBegin(i) - 1 < Shift) then
        Shift := GetLineBegin(i) - 1;
    end;

  for i := ib to ie do
  begin
    s := FText[i];
    if ShiftRight then
      s := Pad(Shift) + s
    else if Trim(s) <> '' then
      Delete(s, 1, Shift);
    FText[i] := s;
  end;
  UpdateSyntax;
  DoChange;
end;

function TfsSyntaxMemo.GetSelText: String;
var
  p1, p2: TPoint;
  i: Integer;
begin
  if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then
  begin
    p1 := FSelStart;
    p2 := FSelEnd;
    Dec(p2.X);
  end
  else
  begin
    p1 := FSelEnd;
    p2 := FSelStart;
    Dec(p2.X);
  end;

  if LineLength(p1.Y - 1) < p1.X then
  begin
    Inc(p1.Y);
    p1.X := 1;
  end;
  if LineLength(p2.Y - 1) < p2.X then
    p2.X := LineLength(p2.Y - 1);

  i := GetPlainTextPos(p1);
  Result := Copy(FText.Text, i, GetPlainTextPos(p2) - i + 1);
end;

procedure TfsSyntaxMemo.SetSelText(Value: String);
var
  p1, p2, p3: TPoint;
  i: Integer;
  s: String;
begin
  if FReadOnly then exit;
  AddUndo;
  if FSelStart.X = 0 then
  begin
    p1 := FPos;
    p2 := p1;
    Dec(p2.X);
  end
  else if FSelStart.X + FSelStart.Y * FMaxLength < FSelEnd.X + FSelEnd.Y * FMaxLength then
  begin
    p1 := FSelStart;
    p2 := FSelEnd;
    Dec(p2.X);
  end
  else
  begin
    p1 := FSelEnd;
    p2 := FSelStart;
    Dec(p2.X);
  end;

  if LineLength(p1.Y - 1) < p1.X then
    FText[p1.Y - 1] := FText[p1.Y - 1] + Pad(p1.X - LineLength(p1.Y - 1) + 1);
  if LineLength(p2.Y - 1) < p2.X then
    p2.X := LineLength(p2.Y - 1);

  i := GetPlainTextPos(p1);
  s := FText.Text;
  Delete(s, i, GetPlainTextPos(p2) - i + 1);
  Insert(Value, s, i);
  FText.Text := s;
  p3 := GetPosPlainText(i + Length(Value));

  CorrectBookmark(FPos.Y, p3.y-FPos.Y);

  SetPos(p3.X, p3.Y);
  FSelStart.X := 0;
  DoChange;
  UpdateSyntax;
end;

procedure TfsSyntaxMemo.ClearSel;
begin
  if FSelStart.X <> 0 then
  begin
    FSelStart := Point(0, 0);
    Repaint;
  end;
end;

procedure TfsSyntaxMemo.AddSel;
begin
  if FSelStart.X = 0 then
    FSelStart := FTempPos;
  FSelEnd := FPos;
  Repaint;
end;

procedure TfsSyntaxMemo.SetPos(x, y: Integer);
begin
  if FMessage <> '' then
  begin
    FMessage := '';
    Repaint;
  end;

  if x > FMaxLength then x := FMaxLength;
  if x < 1 then x := 1;
  if y > FText.Count then y := FText.Count;
  if y < 1 then y := 1;

  FPos := Point(x, y);
  if (FWindowSize.X = 0) or (FWindowSize.Y = 0) then exit;

  if FOffset.Y >= FText.Count then
    FOffset.Y := FText.Count - 1;

  if FPos.X > FOffset.X + FWindowSize.X then
  begin
    Inc(FOffset.X, FPos.X - (FOffset.X + FWindowSize.X));
    Repaint;
  end
  else if FPos.X <= FOffset.X then
  begin
    Dec(FOffset.X, FOffset.X - FPos.X + 1);
    Repaint;
  end
  else if FPos.Y > FOffset.Y + FWindowSize.Y then
  begin
    Inc(FOffset.Y, FPos.Y - (FOffset.Y + FWindowSize.Y));
    Repaint;
  end
  else if FPos.Y <= FOffset.Y then
  begin
    Dec(FOffset.Y, FOffset.Y - FPos.Y + 1);
    Repaint;
  end;

  ShowCaretPos;
  UpdateScrollBar;

end;

procedure TfsSyntaxMemo.ScrollClick(Sender: TObject);
begin
  if FUpdating then exit;
  FOffset.Y := FVScroll.Position;
  if FOffset.Y > FText.Count then
    FOffset.Y := FText.Count;
  ShowCaretPos;
  Repaint;
end;

procedure TfsSyntaxMemo.ScrollEnter(Sender: TObject);
begin
  SetFocus;
end;

procedure TfsSyntaxMemo.DblClick;
var
  s: String;
begin
  FDoubleClicked := True;
  DoCtrlL;
  FSelStart := FPos;
  s := LineAt(FPos.Y - 1);
  if s <> '' then
{$IFDEF Delphi12}
    while CharInSet(s[FPos.X],WordChars)
      or IsUnicodeChar(s[FPos.X]) do
{$ELSE}
    while s[FPos.X] in WordChars do
{$ENDIF}
      Inc(FPos.X);
  FSelEnd := FPos;
  Repaint;
end;

procedure TfsSyntaxMemo.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if FDoubleClicked then
  begin
    FDoubleClicked := False;
    Exit;
  end;
  if Button = mbRight then
  begin
    if(PopupMenu = nil) then FPopUpMenu.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
  end
  else
  begin
    FMoved := True;
    if not Focused then
      SetFocus;
    FDown := True;
    SetPos((X - FGutterWidth) div FCharWidth + 1 + FOffset.X,
           Y div FCharHeight + 1 + FOffset.Y);
    ClearSel;
  end;
end;

procedure TfsSyntaxMemo.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if FDown then
  begin
    FTempPos := FPos;
    FPos.X := (X - FGutterWidth) div FCharWidth + 1 + FOffset.X;
    FPos.Y := Y div FCharHeight + 1 + FOffset.Y;
    if (FPos.X <> FTempPos.X) or (FPos.Y <> FTempPos.Y) then
    begin
      SetPos(FPos.X, FPos.Y);
      AddSel;
    end;
  end;
end;

procedure TfsSyntaxMemo.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  FDown := False;
end;

procedure TfsSyntaxMemo.KeyDown(var Key: Word; Shift: TShiftState);
var
  MyKey: Boolean;
begin
  inherited;
  FAllowLinesChange := False;

  FTempPos := FPos;
  MyKey := True;
  case Key of
    vk_Left:
      if ssCtrl in Shift then
        DoCtrlL else
        DoLeft;

    vk_Right:
      if ssCtrl in Shift then
        DoCtrlR else
        DoRight;

    vk_Up:
      DoUp;

    vk_Down:
      DoDown;

    vk_Home:
      DoHome(ssCtrl in Shift);

    vk_End:
      DoEnd(ssCtrl in Shift);

    vk_Prior:
      DoPgUp;

    vk_Next:
      DoPgDn;

    vk_Return:
      if Shift = [] then
        DoReturn;

    vk_Delete:
      if ssShift in Shift then
        CutToClipboard else
        DoDel;

    vk_Back:
      DoBackspace;

    vk_Insert:
      if ssCtrl in Shift then
        CopyToClipboard
      else if ssShift in Shift then
        PasteFromClipboard;

    vk_Tab:
      TabIndent;

    vk_F3:
      Find(LastSearch);  // F3 Repeat search

  else
    MyKey := False;
  end;

  if Shift = [ssCtrl] then
    if Key = 65 then // Ctrl+A Select all
    begin
      SetPos(0, 0);
      FSelStart := FPos;
      SetPos(LineLength(FText.Count - 1) + 1, FText.Count);
      FSelEnd := FPos;
      Repaint;
    end
    else
    if Key = 70 then // Ctrl+F Search
    begin
       SynMemoSearch := TfsSynMemoSearch.Create(nil);
       if SynMemoSearch.ShowModal = mrOk then
         Find(SynMemoSearch.Edit1.Text);
       LastSearch := SynMemoSearch.Edit1.Text;
       SynMemoSearch.Free;
    end
    else
    if Key = 89 then // Ctrl+Y Delete line
    begin
      if FText.Count > FPos.Y then
      begin
        FMoved := True;
        AddUndo;
        FText.Delete(FPos.Y - 1);
        CorrectBookmark(FPos.Y, -1);
        UpdateSyntax;
      end
      else
      if FText.Count = FPos.Y then
      begin
        FMoved := True;
        AddUndo;
        FText[FPos.Y - 1] := '';
        FPos.X := 1;
        SetPos(FPos.X, FPos.Y);
        UpdateSyntax;
      end
    end
    else
    if Key in [48..57] then
      GotoBookmark(Key-48);

  if Shift = [ssCtrl, ssShift] then
    if Key in [48..57] then
      if IsBookmark(FPos.Y - 1) < 0 then
         AddBookmark(FPos.Y - 1, Key-48)
      else
      if IsBookmark(FPos.Y - 1) = (Key-48) then
         DeleteBookmark(Key-48);


  if Key in [vk_Left, vk_Right, vk_Up, vk_Down, vk_Home, vk_End, vk_Prior, vk_Next] then
  begin
    FMoved := True;
    if ssShift in Shift then
      AddSel else
      ClearSel;
  end
  else if Key in [vk_Return, vk_Delete, vk_Back, vk_Insert, vk_Tab] then
    FMoved := True;

  if MyKey then
    Key := 0;
end;

procedure TfsSyntaxMemo.KeyPress(var Key: Char);
var
  MyKey: Boolean;
begin
  inherited;

  MyKey := True;
  case Key of
    #3:
      CopyToClipboard;

    #9:
      DoCtrlI;

    #21:
      DoCtrlU;

    #22:
      PasteFromClipboard;

    #24:
      CutToClipboard;

    #26:
      Undo;

    #32..#255:
      begin
        DoChar(Key);
        FMoved := True;
      end;
  else
    MyKey := False;
  end;

  if MyKey then
    Key := #0;
end;

procedure TfsSyntaxMemo.DoLeft;
begin
  Dec(FPos.X);
  if FPos.X < 1 then
    FPos.X := 1;
  SetPos(FPos.X, FPos.Y);
end;

procedure TfsSyntaxMemo.DoRight;
begin
  Inc(FPos.X);
  if FPos.X > FMaxLength then
    FPos.X := FMaxLength;
  SetPos(FPos.X, FPos.Y);
end;

procedure TfsSyntaxMemo.DoUp;
begin
  Dec(FPos.Y);
  if FPos.Y < 1 then
    FPos.Y := 1;
  SetPos(FPos.X, FPos.Y);
end;

procedure TfsSyntaxMemo.DoDown;
begin
  Inc(FPos.Y);
  if FPos.Y > FText.Count then
    FPos.Y := FText.Count;
  SetPos(FPos.X, FPos.Y);
end;

procedure TfsSyntaxMemo.DoHome(Ctrl: Boolean);
begin
  if Ctrl then
    SetPos(1, 1) else
    SetPos(1, FPos.Y);
end;

procedure TfsSyntaxMemo.DoEnd(Ctrl: Boolean);
begin
  if Ctrl then
    SetPos(LineLength(FText.Count - 1) + 1, FText.Count) else
    SetPos(LineLength(FPos.Y - 1) + 1, FPos.Y);
end;

procedure TfsSyntaxMemo.DoPgUp;
begin
  if FOffset.Y > FWindowSize.Y then
  begin
    Dec(FOffset.Y, FWindowSize.Y - 1);
    Dec(FPos.Y, FWindowSize.Y - 1);
  end
  else
  begin
    if FOffset.Y > 0 then
    begin
      Dec(FPos.Y, FOffset.Y);
      FOffset.Y := 0;
    end
    else
      FPos.Y := 1;
  end;
  SetPos(FPos.X, FPos.Y);
  Repaint;
end;

procedure TfsSyntaxMemo.DoPgDn;
begin
  if FOffset.Y + FWindowSize.Y < FText.Count then
  begin
    Inc(FOffset.Y, FWindowSize.Y - 1);
    Inc(FPos.Y, FWindowSize.Y - 1);
  end
  else
  begin
    FOffset.Y := FText.Count;
    FPos.Y := FText.Count;
  end;
  SetPos(FPos.X, FPos.Y);
  Repaint;
end;

procedure TfsSyntaxMemo.DoReturn;
var
  s: String;
begin
  if FReadOnly then exit;
  s := LineAt(FPos.Y - 1);
  FText[FPos.Y - 1] := Copy(s, 1, FPos.X - 1);
  FText.Insert(FPos.Y, Copy(s, FPos.X, FMaxLength));
  EnterIndent;
end;

procedure TfsSyntaxMemo.DoDel;
var
  s: String;
begin
  if FReadOnly then exit;
  FMessage := '';
  if FSelStart.X <> 0 then
    SelText := ''
  else
  begin
    s := FText[FPos.Y - 1];
    AddUndo;
    if FPos.X <= LineLength(FPos.Y - 1) then
    begin
      Delete(s, FPos.X, 1);
      FText[FPos.Y - 1] := s;
    end
    else if FPos.Y < FText.Count then
    begin
      s := s + Pad(FPos.X - Length(s) - 1) + LineAt(FPos.Y);
      FText[FPos.Y - 1] := s;
      FText.Delete(FPos.Y);
      CorrectBookmark(FSelStart.Y, -1);
    end;
    UpdateScrollBar;
    UpdateSyntax;
    DoChange;
  end;
end;

procedure TfsSyntaxMemo.DoBackspace;
var
  s: String;
begin
  if FReadOnly then exit;
  FMessage := '';
  if FSelStart.X <> 0 then
    SelText := ''
  else
  begin
    s := FText[FPos.Y - 1];
    if FPos.X > 1 then
    begin
      if (GetLineBegin(FPos.Y - 1) = FPos.X) or (Trim(s) = '') then
        UnIndent
      else
      begin
        AddUndo;
        if Trim(s) <> '' then
        begin
          Delete(s, FPos.X - 1, 1);
          FText[FPos.Y - 1] := s;
          DoLeft;
        end
        else
          DoHome(False);
        UpdateSyntax;
        DoChange;
      end;
    end
    else if FPos.Y > 1 then
    begin
      AddUndo;
      CorrectBookmark(FPos.Y, -1);
      s := LineAt(FPos.Y - 2);
      FText[FPos.Y - 2] := s + FText[FPos.Y - 1];
      FText.Delete(FPos.Y - 1);
      SetPos(Length(s) + 1, FPos.Y - 1);
      UpdateSyntax;
      DoChange;
    end;
  end;
end;

procedure TfsSyntaxMemo.DoCtrlI;
begin
  if FSelStart.X <> 0 then
    ShiftSelected(True);
end;

procedure TfsSyntaxMemo.DoCtrlU;
begin
  if FSelStart.X <> 0 then
    ShiftSelected(False);
end;

procedure TfsSyntaxMemo.DoCtrlL;
var
  i: Integer;
  s: String;
begin
  s := FText.Text;
  i := Length(LineAt(FPos.Y - 1));
  if FPos.X > i then
    FPos.X := i;

  i := GetPlainTextPos(FPos);

  Dec(i);
{$IFDEF Delphi12}
  while (i > 0) and not (CharInSet(s[i], WordChars) or IsUnicodeChar(s[i])) do
    if s[i] = Char(LineBreak[1]) then
{$ELSE}
  while (i > 0) and not (s[i] in WordChars) do
    if s[i] = LineBreak[1] then
{$ENDIF}
      break else
      Dec(i);
{$IFDEF Delphi12}
  while (i > 0) and (CharInSet(s[i], WordChars) or IsUnicodeChar(s[i])) do
{$ELSE}
  while (i > 0) and (s[i] in WordChars) do
{$ENDIF}
    Dec(i);
  Inc(i);

  FPos := GetPosPlainText(i);
  SetPos(FPos.X, FPos.Y);
end;

procedure TfsSyntaxMemo.DoCtrlR;
var
  i: Integer;
  s: String;
begin
  s := FText.Text;
  i := Length(LineAt(FPos.Y - 1));
  if FPos.X > i then
  begin
    DoDown;
    DoHome(False);
    FPos.X := 0;
  end;

  i := GetPlainTextPos(FPos);
{$IFDEF Delphi12}
  while (i < Length(s)) and ((CharInSet(s[i], WordChars)) or IsUnicodeChar(s[i])) do
    Inc(i);
  while (i < Length(s)) and not ((CharInSet(s[i], WordChars)) or IsUnicodeChar(s[i])) do
    if s[i] = Char(LineBreak[1]) then
      break else
      Inc(i);
{$ELSE}
  while (i < Length(s)) and (s[i] in WordChars) do
    Inc(i);
  while (i < Length(s)) and not (s[i] in WordChars) do
    if s[i] = LineBreak[1] then
      break else
      Inc(i);
{$ENDIF}
  FPos := GetPosPlainText(i);
  SetPos(FPos.X, FPos.Y);
end;

procedure TfsSyntaxMemo.DoChar(Ch: Char);
begin
  SelText := Ch;
end;

function TfsSyntaxMemo.GetCharAttr(Pos: TPoint): TCharAttributes;

  function IsBlock: Boolean;
  var
    p1, p2, p3: Integer;
  begin
    Result := False;
    if FSelStart.X = 0 then exit;

    p1 := FSelStart.X + FSelStart.Y * FMaxLength;
    p2 := FSelEnd.X + FSelEnd.Y * FMaxLength;
    if p1 > p2 then
    begin
      p3 := p1;
      p1 := p2;
      p2 := p3;
    end;
    p3 := Pos.X + Pos.Y * FMaxLength;
    Result := (p3 >= p1) and (p3 < p2);
  end;

  function CharAttr: TCharAttr;
  var
    s: String;
  begin
    if Pos.Y - 1 < FSynStrings.Count then
    begin
      s := FSynStrings[Pos.Y - 1];
      if Pos.X <= Length(s) then
        Result := TCharAttr(Ord(s[Pos.X])) else
        Result := caText;
    end
    else
      Result := caText;
  end;

begin
  Result := [CharAttr];
  if IsBlock then
    Result := Result + [caBlock];
end;

procedure TfsSyntaxMemo.Paint;
var
  i, j, j1: Integer;
  a, a1: TCharAttributes;
  s: String;

  procedure SetAttr(a: TCharAttributes);
  begin
    with Canvas do
    begin
      Brush.Color := Self.Color;

      if caText in a then
        Font.Assign(FTextAttr);

      if caComment in a then
        Font.Assign(FCommentAttr);

      if caKeyword in a then
        Font.Assign(FKeywordAttr);

      if caString in a then
        Font.Assign(FStringAttr);

      if caBlock in a then
      begin
        Brush.Color := FBlockColor;
        Font.Color := FBlockFontColor;
      end;

      Font.Charset := Self.Font.Charset;
    end;
  end;

  procedure MyTextOut(x, y: Integer; const s: String);
  var
    i: Integer;
  begin
    with Canvas do
    begin
      FillRect(Rect(x, y, x + Length(s) * FCharWidth, y + FCharHeight));
      if FIsMonoType then
        TextOut(x, y, s)
      else
      begin
        for i := 1 to Length(s) do
          TextOut(x + (i - 1) * FCharWidth, y, s[i]);
        MoveTo(x + Length(s) * FCharWidth, y);
      end;
    end;
  end;

begin
  with Canvas do
  begin
{$IFDEF FPC}
    // temporary fix for gtk1. Will be removed as LCL be fixed
    Brush.Color := clWindow;
    FillRect(ClientRect);
{$ENDIF}
    Brush.Color := clBtnFace;
    FillRect(Rect(0, 0, FGutterWidth - 2, Height - FFooterHeight));
    FillRect(Rect(0, Height - FFooterHeight, Width, Height));
    Pen.Color := clBtnHighlight;
    MoveTo(FGutterWidth - 4, 0);
    LineTo(FGutterWidth - 4, Height - FFooterHeight + 1);
    if FFooterHeight > 0 then
      LineTo(Width, Height - FFooterHeight + 1);

    if FUpdatingSyntax then Exit;

    for i := FOffset.Y to FOffset.Y + FWindowSize.Y - 1 do
    begin
      if i >= FText.Count then break;

      s := FText[i];
      PenPos := Point(FGutterWidth, (i - FOffset.Y) * FCharHeight);
      j1 := FOffset.X + 1;
      a := GetCharAttr(Point(j1, i + 1));
      a1 := a;

      for j := j1 to FOffset.X + FWindowSize.X do
      begin
        if j > Length(s) then break;

        a1 := GetCharAttr(Point(j, i + 1));
        if a1 <> a then
        begin
          SetAttr(a);
          MyTextOut(PenPos.X, PenPos.Y, Copy(FText[i], j1, j - j1));
          a := a1;
          j1 := j;
        end;
      end;

      SetAttr(a);
      MyTextOut(PenPos.X, PenPos.Y, Copy(s, j1, FMaxLength));
      if caBlock in GetCharAttr(Point(1, i + 1)) then
        MyTextOut(PenPos.X, PenPos.Y, Pad(FWindowSize.X - Length(s) - FOffset.X + 3));

      BookmarkDraw(PenPos.Y, i);
      ActiveLineDraw(PenPos.Y, i);
    end;

    if FMessage <> '' then
    begin
      Font.Name := 'Tahoma';
      Font.Color := clWhite;
      Font.Style := [fsBold];
      Font.Size := 8;
      Brush.Color := clMaroon;
      FillRect(Rect(0, Height - TextHeight('|') - 6, Width, Height));
      TextOut(6, Height - TextHeight('|') - 5, FMessage);
    end
    else
      ShowPos;
  end;
end;

procedure TfsSyntaxMemo.CreateSynArray;
var
  i, n, Pos: Integer;
  ch: Char;
  FSyn: String;

  procedure SkipSpaces;
  begin
{$IFDEF Delphi12}
    while (Pos <= Length(FSyn)) and
          ((CharInSet(FSyn[Pos], [#1..#32])) or
           not (CharInSet(FSyn[Pos],['_', 'A'..'Z', 'a'..'z', '''', '"', '/', '{', '(', '-']))) do
      Inc(Pos);
{$ELSE}
    while (Pos <= Length(FSyn)) and
          ((FSyn[Pos] in [#1..#32]) or
           not (FSyn[Pos] in ['_', 'A'..'Z', 'a'..'z', '''', '"', '/', '{', '(', '-'])) do
      Inc(Pos);
{$ENDIF}
  end;

  function IsKeyWord(const s: String): Boolean;
  begin
    Result := False;
    if FKeywords = '' then exit;

    if FKeywords[1] <> ',' then
      FKeywords := ',' + FKeywords;
    if FKeywords[Length(FKeywords)] <> ',' then
      FKeywords := FKeywords + ',';

    Result := System.Pos(',' + AnsiLowerCase(s) + ',', FKeywords) <> 0;
  end;

  function GetIdent: TCharAttr;
  var
    i: Integer;
    cm1, cm2, cm3, cm4, st1: Char;
  begin
    i := Pos;
    Result := caText;

    if FSyntaxType = stPascal then
    begin
      cm1 := '/';
      cm2 := '{';
      cm3 := '(';
      cm4 := ')';
      st1 := '''';
    end
    else if FSyntaxType in [stCpp,stJs,stVb] then
    begin
      cm1 := '/';
      cm2 := ' ';
      cm3 := '/';
      cm4 := '/';
      st1 := '"';
    end
    else if FSyntaxType = stSQL then
    begin
      cm1 := '-';
      cm2 := ' ';
      cm3 := '/';
      cm4 := '/';
      st1 := '"';
    end
    else
    begin
      cm1 := ' ';
      cm2 := ' ';
      cm3 := ' ';
      cm4 := ' ';
      st1 := ' ';
    end;

{$IFDEF Delphi12}
    if CharInSet(FSyn[Pos], ['_', 'A'..'Z', 'a'..'z']) then
    begin
      while CharInSet(FSyn[Pos], ['_', 'A'..'Z', 'a'..'z', '0'..'9']) do
        Inc(Pos);
      if IsKeyWord(Copy(FSyn, i, Pos - i)) then
        Result := caKeyword;
      Dec(Pos);
    end
    else if (FSyn[Pos] = cm1) and (FSyn[Pos + 1] = cm1) then
    begin
      while (Pos <= Length(FSyn)) and not (CharInSet(FSyn[Pos], [#10, #13])) do
        Inc(Pos);
      Result := caComment;
    end
{$ELSE}
    if FSyn[Pos] in ['_', 'A'..'Z', 'a'..'z'] then
    begin
      while FSyn[Pos] in ['_', 'A'..'Z', 'a'..'z', '0'..'9'] do
        Inc(Pos);
      if IsKeyWord(Copy(FSyn, i, Pos - i)) then
        Result := caKeyword;
      Dec(Pos);
    end
    else if (FSyn[Pos] = cm1) and (FSyn[Pos + 1] = cm1) then
    begin
      while (Pos <= Length(FSyn)) and not (FSyn[Pos] in [#10, #13]) do
        Inc(Pos);
      Result := caComment;
    end
{$ENDIF}
    else if FSyn[Pos] = cm2 then
    begin
      while (Pos <= Length(FSyn)) and (FSyn[Pos] <> '}') do
        Inc(Pos);
      Result := caComment;
    end
    else if (FSyn[Pos] = cm3) and (FSyn[Pos + 1] = '*') then
    begin
      while (Pos < Length(FSyn)) and not ((FSyn[Pos] = '*') and (FSyn[Pos + 1] = cm4)) do
        Inc(Pos);
      Inc(Pos, 2);
      Result := caComment;
    end
    else if FSyn[Pos] = st1 then
    begin
      Inc(Pos);
{$IFDEF Delphi12}
      while (Pos < Length(FSyn)) and (FSyn[Pos] <> st1) and not (CharInSet(FSyn[Pos], [#10, #13])) do
        Inc(Pos);
{$ELSE}
      while (Pos < Length(FSyn)) and (FSyn[Pos] <> st1) and not (FSyn[Pos] in [#10, #13]) do
        Inc(Pos);
{$ENDIF}
      Result := caString;
    end;
    Inc(Pos);
  end;

begin
  FSyn := FText.Text + #0#0#0#0#0#0#0#0#0#0#0;
  FAllowLinesChange := False;
  Pos := 1;

  while Pos < Length(FSyn) do
  begin
    n := Pos;
    SkipSpaces;
    for i := n to Pos - 1 do
      if FSyn[i] > #31 then
        FSyn[i] := Chr(Ord(caText));

    n := Pos;
    ch := Chr(Ord(GetIdent));
    for i := n to Pos - 1 do
      if i <= Length(FSyn) then
        if FSyn[i] > #31 then
          FSyn[i] := ch;
  end;

  FUpdatingSyntax := True;
  FSynStrings.Text := FSyn;
  FSynStrings.Add(' ');
  FUpdatingSyntax := False;
end;

procedure TfsSyntaxMemo.UpdateView;
begin
  UpdateSyntax;
  Invalidate;
end;

procedure TfsSyntaxMemo.CopyPopup(Sender: TObject);
begin
  CopyToClipboard;
end;

procedure TfsSyntaxMemo.PastePopup(Sender: TObject);
begin
  PasteFromClipboard;
end;

procedure TfsSyntaxMemo.CutPopup(Sender: TObject);
begin
  CutToClipboard;
end;

{$IFDEF Delphi4}
procedure TfsSyntaxMemo.MouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  FVScroll.Position := FVScroll.Position - FVScroll.SmallChange * KWheel;
end;

procedure TfsSyntaxMemo.MouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  FVScroll.Position := FVScroll.Position + FVScroll.SmallChange * KWheel;
end;
{$ENDIF}

procedure TfsSyntaxMemo.SetShowGutter(Value: boolean);
begin
  FShowGutter := Value;
  if Value then
    FGutterWidth := 20
  else
    FGutterWidth := 0;
  Repaint;
end;

procedure TfsSyntaxMemo.SetShowFooter(Value: boolean);
begin
  FShowFooter := Value;
  if Value then
    FFooterHeight := 20
  else
    FFooterHeight := 0;
  Repaint;
end;

function TfsSyntaxMemo.FMemoFind(Text: String; var Position : TPoint): boolean;
var
  i, j : integer;
begin
  j := 0;
  result := False;
  if FText.Count > 1 then
  begin
    Text := UpperCase(Text);
    for i := Position.Y to FText.Count - 1 do
    begin
      j := Pos( Text, UpperCase(FText[i]));
      if j > 0 then
      begin
        Result := True;
        break;
      end
    end;
    Position.X := j;
    Position.Y := i + 1;
  end;
end;

function TfsSyntaxMemo.Find(Text: String): boolean;
var
  Position: TPoint;
begin
  Position := FPos;
  if FMemoFind(Text, Position) then
  begin
    SetPos(Position.X, Position.Y);
    result := true;
  end
  else
  begin
    ShowMessage('Text "'+Text+'" not found.');
    result := false;
  end;
end;

procedure TfsSyntaxMemo.ActiveLineDraw(Y : integer; ALine : integer);
begin
  if ShowGutter then
    with Canvas do
      if ALine = FActiveLine then
      begin
        Brush.Color := clRed;
        Pen.Color := clBlack;
        Ellipse(4, Y+4, 11, Y+11);
      end;
end;

procedure TfsSyntaxMemo.BookmarkDraw(Y : integer; ALine : integer);
var
  bm : integer;
begin
  if ShowGutter then
    with Canvas do
    begin
      bm := IsBookmark(ALine);
      if bm >= 0 then
      begin
        Brush.Color := clBlack;
        FillRect(Rect(3, Y + 1, 13, Y + 12));
        Brush.Color := clGreen;
        FillRect(Rect(2, Y + 2, 12, Y + 13));
        Font.Name := 'Tahoma';
        Font.Color := clWhite;
        Font.Style := [fsBold];
        Font.Size := 7;
        TextOut(4, Y + 2, IntToStr(bm));
      end
      else
      begin
        Brush.Color := clBtnFace;
        FillRect(Rect(2, Y + 2, 13, Y + 13));
      end;
    end;
end;

function TfsSyntaxMemo.IsBookmark(Line : integer): integer;
var
  Pos : integer;
begin
  Result := -1;
  for Pos := 0 to Length(Bookmarks) - 1 do
    if Bookmarks[Pos] = Line then
    begin
      Result := Pos;
      break;
    end;
end;

procedure TfsSyntaxMemo.AddBookmark(Line, Number : integer);
begin
  if Number < Length(Bookmarks) then
  begin
    Bookmarks[Number] := Line;
    Repaint;
  end;
end;

procedure TfsSyntaxMemo.DeleteBookmark(Number : integer);
begin
  if Number < Length(Bookmarks) then
  begin
    Bookmarks[Number] := -1;
    Repaint;
  end;
end;

procedure TfsSyntaxMemo.CorrectBookmark(Line : integer; delta : integer);
var
  i : integer;
begin
  for i := 0 to Length(Bookmarks) - 1 do
    if Bookmarks[i] >= Line then
      Inc(Bookmarks[i], Delta);
end;

procedure TfsSyntaxMemo.GotoBookmark(Number : integer);
begin
  if Number < Length(Bookmarks) then
    if Bookmarks[Number] >= 0 then
      SetPos(0, Bookmarks[Number] + 1);
end;

procedure TfsSyntaxMemo.DOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := Source is TTreeView;
end;

procedure TfsSyntaxMemo.DDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if Source is TTreeView then
  begin
     SetPos((X - FGutterWidth) div FCharWidth + 1 + FOffset.X,
          Y div FCharHeight + 1 + FOffset.Y);
     SetSelText(TTreeView(Source).Selected.Text);
  end;
end;

procedure TfsSyntaxMemo.SetKeywordAttr(Value: TFont);
begin
  FKeywordAttr.Assign(Value);
  UpdateSyntax;
end;

procedure TfsSyntaxMemo.SetStringAttr(Value: TFont);
begin
  FStringAttr.Assign(Value);
  UpdateSyntax;
end;

procedure TfsSyntaxMemo.SetTextAttr(Value: TFont);
begin
  FTextAttr.Assign(Value);
  UpdateSyntax;
end;

procedure TfsSyntaxMemo.SetCommentAttr(Value: TFont);
begin
  FCommentAttr.Assign(Value);
  UpdateSyntax;
end;

procedure TfsSyntaxMemo.SetActiveLine(Line : Integer);
begin
  FActiveLine := Line;
  Repaint;
end;

function TfsSyntaxMemo.GetActiveLine: Integer;
begin
  Result := FActiveLine;
end;

//

procedure TfsSynMemoSearch.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
     ModalResult := mrOk;
end;

initialization
{$IFDEF FPC}
  {$I fs_synmemo.lrs}
{$ENDIF}

end.
