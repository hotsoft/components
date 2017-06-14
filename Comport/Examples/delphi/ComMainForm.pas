unit ComMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CPort, CPortCtl;

type
  TForm1 = class(TForm)
    ComPort: TComPort;
    InMemo: TMemo;
    Button_Open: TButton;
    Button_Settings: TButton;
    LimparButton: TButton;
    Panel1: TPanel;
    Bt_Store: TButton;
    Bt_Load: TButton;
    ComLed1: TComLed;
    ComLed2: TComLed;
    ComLed3: TComLed;
    ComLed4: TComLed;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ComLed5: TComLed;
    ComLed6: TComLed;
    Label1: TLabel;
    Label6: TLabel;
    OutMemo: TMemo;
    EnivarButton: TButton;
    EnviarFramesButton: TButton;
    ACKCheckBox: TCheckBox;
    TimeoutLabel: TLabel;
    SemTimeOutCheckBox: TCheckBox;
    ACKButton: TButton;
    ENQButton: TButton;
    EOTButton: TButton;
    procedure Button_OpenClick(Sender: TObject);
    procedure Button_SettingsClick(Sender: TObject);
    procedure LimparButtonClick(Sender: TObject);
    procedure ComPortOpen(Sender: TObject);
    procedure ComPortClose(Sender: TObject);
    procedure ComPortRxChar(Sender: TObject; Count: Integer);
    procedure Bt_LoadClick(Sender: TObject);
    procedure Bt_StoreClick(Sender: TObject);
    procedure EnviarFramesButtonClick(Sender: TObject);
    procedure EnivarButtonClick(Sender: TObject);
    procedure ACKButtonClick(Sender: TObject);
    procedure ENQButtonClick(Sender: TObject);
    procedure EOTButtonClick(Sender: TObject);
  private
    msgRecebida: string;
    function AguardarResposta(s: string): Boolean;
    function CalculaHash(conteudo: string): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses ConstantesUn;

{$R *.DFM}

procedure TForm1.Button_OpenClick(Sender: TObject);
begin
  if ComPort.Connected then
    ComPort.Close
  else
    ComPort.Open;
end;

procedure TForm1.Button_SettingsClick(Sender: TObject);
begin
  ComPort.ShowSetupDialog;
end;

procedure TForm1.LimparButtonClick(Sender: TObject);
var
  Str: String;
begin
  InMemo.Clear;
end;

procedure TForm1.ComPortOpen(Sender: TObject);
begin
  Button_Open.Caption := 'Close';
end;

procedure TForm1.ComPortClose(Sender: TObject);
begin
  if Button_Open <> nil then
    Button_Open.Caption := 'Open';
end;

procedure TForm1.ComPortRxChar(Sender: TObject; Count: Integer);
begin
  ComPort.ReadStr(msgRecebida, Count);
  InMemo.Text := InMemo.Text + msgRecebida;
  if (ACKCheckBox.Checked) and (msgRecebida <> ACK) then
    ComPort.WriteStr(ACK);
end;

procedure TForm1.ACKButtonClick(Sender: TObject);
begin
  ComPort.Write(ACK);
end;

function TForm1.AguardarResposta(s: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := 0;
  while (SemTimeOutCheckBox.Checked) or (i < 41) do
  begin
    Sleep(250);
    if msgRecebida <> '' then
    begin
      Result := Pos(s, msgRecebida) > 0;
      Break;
    end;
    Inc(i);
    Application.ProcessMessages;
  end;
  if i = 41 then
  begin
    raise Exception.Create('timeout');
  end;
end;

procedure TForm1.EnivarButtonClick(Sender: TObject);
begin
  ComPort.WriteStr(OutMemo.Text);
end;

procedure TForm1.ENQButtonClick(Sender: TObject);
begin
  ComPort.Write(ENQ);
end;

procedure TForm1.EnviarFramesButtonClick(Sender: TObject);
var
  i, sequenciaFrame: Integer;
  restante, conteudo, frame, hash: string;
begin
  TimeoutLabel.Visible := False;
  try
    repeat
      msgRecebida := '';
      ComPort.WriteStr(ENQ);
    until AguardarResposta(ACK);
  except

    Exit;
  end;

  sequenciaFrame := 1;
  for i := 0 to OutMemo.Lines.Count-1 do
  begin
    restante := Trim(OutMemo.Lines[i]);
    while restante <> '' do
    begin
      conteudo := Copy(restante, 1, 240);
      restante := Copy(restante, 241, Length(restante));
      if restante <> '' then
      begin
        hash := CalculaHash(IntToStr(sequenciaFrame)+conteudo+ETB);
        frame := STX+IntToStr(sequenciaFrame)+conteudo+ETB+hash+CR+LF;
      end
      else
      begin
        hash := CalculaHash(IntToStr(sequenciaFrame)+conteudo+CR+ETX);
        frame := STX+IntToStr(sequenciaFrame)+conteudo+CR+ETX+hash+CR+LF;
      end;

      ComPort.WriteStr(frame);
      try
        if not AguardarResposta(ACK)then
        begin
          ComPort.WriteStr(EOT);
          Exit;
        end
      except
        TimeoutLabel.Visible := True;
        Exit;
      end;
      sequenciaFrame := sequenciaFrame + 1;
      if sequenciaFrame = 8 then
        sequenciaFrame := 1;
    end;
  end;
  ComPort.WriteStr(EOT);
end;

procedure TForm1.EOTButtonClick(Sender: TObject);
begin
  ComPort.Write(EOT);
end;

function TForm1.CalculaHash(conteudo: string): string;
var
  sum, i : Integer;
  HFrame : string;
begin
  sum := 0;
  for i := 1 to Length(conteudo) do
  begin
    sum := sum + Ord(conteudo[i]);
  end;
  HFrame := IntToHex(sum mod 256,2);

  if (Length(HFrame) < 2) then
  HFrame := '0' + HFrame;

  result := UpperCase(HFrame);
end;

procedure TForm1.Bt_LoadClick(Sender: TObject);
begin
//  ComPort.LoadSettings(stRegistry, 'HKEY_LOCAL_MACHINE\Software\Dejan');
  ComPort.LoadSettings(stIniFile, 'ComExample.ini');
end;

procedure TForm1.Bt_StoreClick(Sender: TObject);
begin
  ComPort.StoreSettings(stIniFile, 'ComExample.ini');
//  ComPort.StoreSettings(stRegistry, 'HKEY_LOCAL_MACHINE\Software\Dejan');
end;

end.
