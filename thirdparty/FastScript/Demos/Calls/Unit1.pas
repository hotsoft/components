unit Unit1;

interface

{$I fs.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  fs_iInterpreter, StdCtrls, fs_ipascal;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    fsScript1: TfsScript;
    Label1: TLabel;
    Button2: TButton;
    fsPascal1: TfsPascal;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    procedure DelphiFunc(s: String; i: Integer);
    function CallMethod(Instance: TObject; ClassType: TClass;
      const MethodName: String; var Params: Variant): Variant;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{$IFDEF Delphi6}
uses Variants;
{$ENDIF}

procedure TForm1.DelphiFunc(s: String; i: Integer);
begin
  ShowMessage(s + ', ' + IntToStr(i));
end;

function TForm1.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
begin
  { dispatch the method call }
  if MethodName = 'DELPHIFUNC' then
    DelphiFunc(Params[0], Params[1]);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  { clear all items }
  fsScript1.Clear;
  { script text }
  fsScript1.Lines := Memo1.Lines;
  { frGlobalUnit contains standard types and functions }
  fsScript1.Parent := fsGlobalUnit;
  { make DelphiFunc procedure visible to a script }
  fsScript1.AddMethod('procedure DelphiFunc(s: String; i: Integer)', CallMethod);

  { compile the script }
  if fsScript1.Compile then
    fsScript1.Execute else   { execute if compilation was succesfull }
    ShowMessage(fsScript1.ErrorMsg); { show an error message }
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  { clear all items }
  fsScript1.Clear;
  { script text }
  fsScript1.Lines := Memo1.Lines;
  { frGlobalUnit contains standard types and functions }
  fsScript1.Parent := fsGlobalUnit;
  { make DelphiFunc procedure visible to a script }
  fsScript1.AddMethod('procedure DelphiFunc(s: String; i: Integer)', CallMethod);

  { compile the script }
  if fsScript1.Compile then
    { Call script function with one string parameter and one integer param }
    fsScript1.CallFunction('ScriptFunc', VarArrayOf(['Call ScriptFunc', 1])) else
    ShowMessage(fsScript1.ErrorMsg); { show an error message }
end;

end.
