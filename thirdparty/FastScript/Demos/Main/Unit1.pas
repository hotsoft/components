unit Unit1;

interface

{$I fs.inc}

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLIntf,
{$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ImgList, ExtCtrls, ToolWin, fs_iinterpreter,
  fs_iformsrtti, fs_igraphicsrtti, fs_iclassesrtti, fs_synmemo, fs_tree,
  fs_ipascal, fs_icpp, fs_ijs, fs_ibasic;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    ToolBar1: TToolBar;
    LoadBtn: TToolButton;
    RunBtn: TToolButton;
    ImageList1: TImageList;
    Panel1: TPanel;
    Label2: TLabel;
    LangCB: TComboBox;
    ToolButton1: TToolButton;
    fsScript1: TfsScript;
    frClassesRTTI1: TfsClassesRTTI;
    frGraphicsRTTI1: TfsGraphicsRTTI;
    frFormsRTTI1: TfsFormsRTTI;
    Status: TMemo;
    Splitter1: TSplitter;
    Panel2: TPanel;
    EvaluateB: TToolButton;
    Memo: TfsSyntaxMemo;
    fsTree1: TfsTree;
    Splitter2: TSplitter;
    fsPascal1: TfsPascal;
    fsCPP1: TfsCPP;
    fsJScript1: TfsJScript;
    fsBasic1: TfsBasic;
    procedure FormCreate(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
    procedure LangCBClick(Sender: TObject);
    procedure EvaluateBClick(Sender: TObject);
    procedure fsScript1RunLine(Sender: TfsScript; const UnitName, SourcePos: String);
  private
    { Private declarations }
    FRunning: Boolean;
    FStopped: Boolean;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$IFNDEF FPC}
  {$R *.dfm}
{$ELSE}
  {$R *.lfm}
{$ENDIF}

uses
  fs_iTools, Unit2
{$IFDEF Delphi6}
, Variants
{$ENDIF};

function MSecsBetween(AStopTime, AStartTime: TDateTime): Int64;
var
  StartMs, StopMs: Comp;
begin
  StopMs := TimeStampToMSecs(DateTimeToTimeStamp(AStopTime));
  StartMs := TimeStampToMSecs(DateTimeToTimeStamp(AStartTime));
  Result := Trunc(StopMs - StartMs);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  fsGlobalUnit.AddForm(Form1);
  fsGetLanguageList(LangCB.Items);
  LangCB.ItemIndex := LangCB.Items.IndexOf('PascalScript');
end;

procedure TForm1.LoadBtnClick(Sender: TObject);
var
  s: String;
begin
  OpenDialog1.InitialDir := ExtractFilePath(Application.ExeName) + 'Samples';
  s := LangCB.Items[LangCB.ItemIndex];
  if s = 'PascalScript' then
    OpenDialog1.FilterIndex := 1
  else if s = 'C++Script' then
    OpenDialog1.FilterIndex := 2
  else if s = 'JScript' then
    OpenDialog1.FilterIndex := 3
  else if s = 'BasicScript' then
    OpenDialog1.FilterIndex := 4;
  if OpenDialog1.Execute then
    Memo.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.LangCBClick(Sender: TObject);
var
  s: String;
begin
  s := LangCB.Items[LangCB.ItemIndex];
  if s = 'PascalScript' then
    Memo.SyntaxType := stPascal
  else if s = 'C++Script' then
    Memo.SyntaxType := stCPP
  else if s = 'JScript' then
    Memo.SyntaxType := stJS
  else if s = 'BasicScript' then
    Memo.SyntaxType := stVB
  else
    Memo.SyntaxType := stText;
  Memo.SetFocus;
end;

procedure TForm1.RunBtnClick(Sender: TObject);
var
  StartTime: TDateTime;
  p: TPoint;
begin
  if FRunning then
  begin
    if Sender = RunBtn then
      fsScript1.OnRunLine := nil;
    FStopped := False;
    Exit;
  end;

  fsScript1.Clear;
  fsScript1.Lines := Memo.Lines;
  fsScript1.SyntaxType := LangCB.Items[LangCB.ItemIndex];
  fsScript1.Parent := fsGlobalUnit;

  if not fsScript1.Compile then
  begin
    Memo.SetFocus;
    p := fsPosToPoint(fsScript1.ErrorPos);
    Memo.SetPos(p.X, p.Y);
    if fsScript1.ErrorUnit = '' then
      Status.Text := fsScript1.ErrorMsg else
      Status.Text := fsScript1.ErrorUnit + ': ' + fsScript1.ErrorMsg;
    Exit;
  end
  else
    Status.Text := 'Compiled OK, Running...';

  StartTime := Now;
  Application.ProcessMessages;

  if Sender = RunBtn then
    fsScript1.OnRunLine := nil else
    fsScript1.OnRunLine := fsScript1RunLine;

  FRunning := True;
  try
    fsScript1.Execute;
  finally
    FRunning := False;
    Status.Text := 'Exception in the program';
  end;

  Status.Text := 'Executed in ' + IntToStr(MSecsBetween(Now, StartTime)) + ' ms';
end;

procedure TForm1.EvaluateBClick(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure TForm1.fsScript1RunLine(Sender: TfsScript; const UnitName,
  SourcePos: String);
var
  p: TPoint;
begin
  { enable main window to allow debugging of modal forms }
  EnableWindow(Handle, True);
  SetFocus;

  p := fsPosToPoint(SourcePos);
  Memo.SetPos(p.X, p.Y);

  FStopped := True;
  while FStopped do
    Application.ProcessMessages;
end;

end.

