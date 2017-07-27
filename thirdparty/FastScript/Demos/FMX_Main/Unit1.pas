unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Layouts, FMX.Memo,
  FMX.Edit
{$IFDEF VER250}
  ,FMX.StdCtrls
{$ENDIF};

type
  TForm1 = class(TForm)
    ExpressionE: TEdit;
    ResultM: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    procedure ExpressionEKeyUp(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}
uses Unit2;

procedure TForm1.ExpressionEKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = Word(#13) then
  begin
    ResultM.Lines.Text := VarToStr(Form2.fsScript1.Evaluate(ExpressionE.Text));
    ExpressionE.SelectAll;
  end
  else if Key = Word(#27) then
    Close;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ExpressionE.SelectAll;
  ResultM.Text := '';
end;

end.
