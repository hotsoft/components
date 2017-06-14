unit ComMainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, CPort, CPortCtl;

type
  TSerialInfo = record
    velocidade: Integer;
    portacom: string;
    databits: string;
    stopbits: string;
    paridade: string;
    controlefluxo: string;
  end;

  TConexaoThread = class(TThread)
    importando: Boolean;
    sendingWorklist: Boolean;
  protected
    procedure Execute; override;
    procedure Loop; virtual;
  public
    serialInfo: TSerialInfo;
    error: string;
    responderAck: Boolean;
    tMemo: TMemo;
    msgRecebida: string;
    constructor Create(CreateSuspended: Boolean); virtual;

    function ConvertDatabits(valor: string): TDataBits;
    function ConvertStopbits(valor: string): TStopBits;
    function ConvertParity(valor: string): TParityBits;
    function ConvertFlowControl(valor: string): TFlowControl;
    function ReceberMensagemSincrona: string; virtual; abstract;

    procedure EnviarMensagem(msg: string); virtual; abstract;
    function ReceberMensagem: string;  virtual; abstract;
  end;

  TForm1 = class(TForm)
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
    Timer1: TTimer;
    procedure LimparButtonClick(Sender: TObject);
    procedure ComPortOpen(Sender: TObject);
    procedure ComPortClose(Sender: TObject);
    procedure Bt_LoadClick(Sender: TObject);
    procedure Bt_StoreClick(Sender: TObject);
    procedure EnviarFramesButtonClick(Sender: TObject);
    procedure ACKButtonClick(Sender: TObject);
    procedure ENQButtonClick(Sender: TObject);
    procedure EOTButtonClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    thread: TConexaoThread;

    function AguardarResposta(s: string): Boolean;
    function CalculaHash(conteudo: string): string;
    { Private declarations }
  public
    { Public declarations }
  end;

  TSerialThread = class(TConexaoThread)
  private
    comPort: TComPort;
  protected
    procedure RxChar(Sender: TObject; Count: Integer);
    procedure Execute; override;
    procedure TerminateThread(sender: TObject);
    procedure Loop; override;
  public
    function AbrirConexao: Boolean;
    function PararConexao: Boolean;
    procedure EnviarMensagem(msg: string); override;
    procedure TesteAmostra(numAmostra: Integer);
    function ReceberMensagemSincrona: string; override;
  end;

var
  Form1: TForm1;

implementation

uses ConstantesUn;

{$R *.DFM}

procedure TForm1.LimparButtonClick(Sender: TObject);
var
  Str: String;
begin
  InMemo.Clear;
end;

constructor TConexaoThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
end;

procedure TConexaoThread.Loop;
begin
  while True do
  begin
    Sleep(500);
    if Terminated then
      Break;
  end;
end;

function TConexaoThread.ConvertDatabits(valor: string): TDataBits;
begin
  if valor = '5' then
    Result := dbFive
  else if valor = '6' then
    Result := dbSix
  else if valor = '7' then
    Result := dbSeven
  else if valor = '8' then
    Result := dbEight;
end;

function TConexaoThread.ConvertFlowControl(valor: string): TFlowControl;
begin
  if valor = cscfSoftware then
    Result := fcSoftware
  else if valor = cscfHardware then
    Result := fcHardware
  else if valor = cscfNone then
    Result := fcNone
  else if valor = cscfCustom then
    Result := fcCustom;
end;

function TConexaoThread.ConvertParity(valor: string): TParityBits;
begin
  if Trim(valor) = cspNone then
    Result := prNone
  else if Trim(valor) = cspOdd then
    Result := prOdd
  else if Trim(valor) = cspEven then
    Result := prEven
  else if Trim(valor) = cspMark then
    Result := prMark
  else if Trim(valor) = cspSpace then
    Result := prSpace
end;

function TConexaoThread.ConvertStopbits(valor: string): TStopBits;
begin
  if Trim(valor) = '1' then
    Result := sbOneStopBit
  else if Trim(valor) = '1.5' then
    Result := sbOne5StopBits
  else if Trim(valor) = '2' then
    Result := sbTwoStopBits
end;

procedure TSerialThread.TerminateThread(sender: TObject);
begin
  inherited;
  FreeAndNil(comPort);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if thread.msgRecebida = EOT then
   EnviarFramesButton.Click;
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

procedure TForm1.ACKButtonClick(Sender: TObject);
begin
 thread.EnviarMensagem(ACK);
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
    if True then

    if thread.msgRecebida <> '' then
    begin
      Result := Pos(s, thread.msgRecebida) > 0;
      Break;
    end
    else
      thread.ReceberMensagemSincrona;
    Inc(i);
    Application.ProcessMessages;
  end;
  if i = 41 then
  begin
    raise Exception.Create('timeout');
  end;
end;

procedure TForm1.ENQButtonClick(Sender: TObject);
begin
  thread.EnviarMensagem(ENQ);
end;

procedure TForm1.EnviarFramesButtonClick(Sender: TObject);
var
  i, sequenciaFrame: Integer;
  restante, conteudo, frame, hash: string;
begin
  TimeoutLabel.Visible := False;
  try
    repeat
      thread.msgRecebida := '';
      thread.EnviarMensagem(ENQ);
    until AguardarResposta(ACK);
  except
    TimeoutLabel.Visible := True;
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

      try
        repeat
          thread.msgRecebida := '';
          thread.EnviarMensagem(frame);
        until AguardarResposta(ACK);
      except
        TimeoutLabel.Visible := True;
        Exit;
      end;
      sequenciaFrame := sequenciaFrame + 1;
      if sequenciaFrame = 8 then
        sequenciaFrame := 1;
    end;
  end;
  thread.EnviarMensagem(EOT);
end;

procedure TForm1.EOTButtonClick(Sender: TObject);
begin
  thread.EnviarMensagem(EOT);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  thread := TSerialThread.Create(True);
  thread.responderAck := ACKCheckBox.Checked;
  thread.tMemo := InMemo;
  thread.Resume;
end;

procedure TConexaoThread.Execute;
begin
  inherited;
  FreeOnTerminate := True;
end;

function TSerialThread.AbrirConexao: Boolean;
begin
  Result := False;
  comPort := TComPort.Create(nil);
  comPort.Port := 'COM4';
  comPort.BaudRate := StrToBaudRate('9600');
  comPort.DataBits := ConvertDatabits('8');
  comPort.StopBits := ConvertStopbits('1');
  comPort.Parity.Bits := ConvertParity('N');
  comPort.FlowControl.FlowControl := ConvertFlowControl('N');
  comPort.FlowControl.ControlDTR := dtrEnable;
  comPort.Events := [];
  comPort.SyncMethod := smNone;


  try
    comPort.Open;
    Result := True;
  except
    on E:Exception do
    begin
      error := E.Message;
    end;
  end;
end;

procedure TSerialThread.EnviarMensagem(msg: string);
begin
  inherited;
  comPort.WriteStr(msg);
end;

procedure TSerialThread.Execute;
begin
  inherited;
  OnTerminate := TerminateThread;

  if Terminated then
    Exit;

  if AbrirConexao then
  Loop;

end;

procedure TSerialThread.Loop;
var
  events: TComEvents;
  i: Integer;
begin
  i := 0;
  while True do
  begin
    if Terminated then
      Break;

    events := [evRxChar];
    comPort.WaitForEvent(events, 0, 1000);
    if  evRxChar in events  then
    begin
      RxChar(comPort, comPort.InputCount);
      i := 0;
    end
    else
      i := i + 1;
  end;
end;

procedure TSerialThread.TesteAmostra(numAmostra: Integer);
begin

end;

function TSerialThread.ReceberMensagemSincrona: string;
begin
  comPort.ReadStr(msgRecebida, comPort.InputCount);
end;

function TSerialThread.PararConexao: Boolean;
begin
  Result := False;
  try
    comPort.Close;
    Result := True;
  except
    on E:Exception do
    begin
      error := E.Message;
    end;
  end;
end;

procedure TSerialThread.RxChar(Sender: TObject; Count: Integer);
begin
  comPort.ReadStr(msgRecebida, Count);
  tMemo.Text := tMemo.Text + msgRecebida;
  if (msgRecebida <> '') and (responderAck) and (msgRecebida <> ACK) then
    EnviarMensagem(ACK);
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
//  ComPort.LoadSettings(stIniFile, 'ComExample.ini');
end;

procedure TForm1.Bt_StoreClick(Sender: TObject);
begin
//  ComPort.StoreSettings(stIniFile, 'ComExample.ini');
//  ComPort.StoreSettings(stRegistry, 'HKEY_LOCAL_MACHINE\Software\Dejan');
end;

end.
