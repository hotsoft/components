unit Unit2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.fs_tree, FMX.fs_synmemo,
  FMX.Layouts, FMX.Memo, FMX.ListBox, FMX.fs_idbrtti, FMX.fs_ichartrtti,
  FMX.fs_iinirtti, FMX.fs_imenusrtti, FMX.fs_idialogsrtti, FMX.fs_iextctrlsrtti,
  FMX.fs_iformsrtti, FMX.fs_igraphicsrtti, FMX.fs_iclassesrtti, FMX.fs_ibasic,
  FMX.fs_ijs, FMX.fs_icpp, FMX.fs_ipascal, FMX.fs_iinterpreter, FMX.fs_itools
 {$IFDEF VER250}
  ,FMX.StdCtrls
{$ENDIF};

type
  TForm2 = class(TForm)
    Memo: TfsSyntaxMemo;
    fsTree1: TfsTree;
    ToolBar1: TToolBar;
    Splitter1: TSplitter;
    Status: TMemo;
    LangCB: TComboBox;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    ImageControl1: TImageControl;
    StyleBook2: TStyleBook;
    RunBtn: TSpeedButton;
    ImageControl2: TImageControl;
    StepBtn: TSpeedButton;
    ImageControl3: TImageControl;
    SpeedButton4: TSpeedButton;
    ImageControl4: TImageControl;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    fsScript1: TfsScript;
    fsPascal1: TfsPascal;
    fsCPP1: TfsCPP;
    fsJScript1: TfsJScript;
    fsBasic1: TfsBasic;
    fsClassesRTTI1: TfsClassesRTTI;
    fsGraphicsRTTI1: TfsGraphicsRTTI;
    fsFormsRTTI1: TfsFormsRTTI;
    fsExtCtrlsRTTI1: TfsExtCtrlsRTTI;
    fsDialogsRTTI1: TfsDialogsRTTI;
    fsMenusRTTI1: TfsMenusRTTI;
    fsIniRTTI1: TfsIniRTTI;
    fsChartRTTI1: TfsChartRTTI;
    fsDBRTTI1: TfsDBRTTI;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    OpenDialog1: TOpenDialog;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure LangCBClick(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
    procedure fsScript1RunLine(Sender: TfsScript; const UnitName,
      SourcePos: string);
    procedure SpeedButton4Click(Sender: TObject);
  private
    { Private declarations }
    FRunning: Boolean;
    FStopped: Boolean;
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}
uses Unit1;

function MSecsBetween(AStopTime, AStartTime: TDateTime): Int64;
var
  StartMs, StopMs: Comp;
begin
  StopMs := TimeStampToMSecs(DateTimeToTimeStamp(AStopTime));
  StartMs := TimeStampToMSecs(DateTimeToTimeStamp(AStartTime));
  Result := Trunc(StopMs - StartMs);
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  fsGlobalUnit.AddForm(Form2);
  LangCB.BeginUpdate;
  fsGetLanguageList(LangCB.Items);
  LangCB.EndUpdate;
  LangCB.ItemIndex := LangCB.Items.IndexOf('PascalScript');
end;

procedure TForm2.fsScript1RunLine(Sender: TfsScript; const UnitName,
  SourcePos: string);
var
  p: TPoint;
begin
  { enable main window to allow debugging of modal forms }
  //EnableWindow(Handle, True);
 // SetFocus;

  p := fsPosToPoint(SourcePos);
  Memo.SetPos(p.X, p.Y);
  FStopped := True;
  while FStopped do
    Application.ProcessMessages;
end;

procedure TForm2.LangCBClick(Sender: TObject);
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

procedure TForm2.RunBtnClick(Sender: TObject);
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


procedure TForm2.SpeedButton1Click(Sender: TObject);
var
  s: String;
begin

  OpenDialog1.InitialDir := ExtractFilePath(GetCurrentDir) + 'Samples';
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

procedure TForm2.SpeedButton4Click(Sender: TObject);
begin
  Form1.ShowModal;
end;

end.
