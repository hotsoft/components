{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clTcpCommandClient;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows, Messages, SysUtils, WinSock,{$IFDEF DEMO} Forms,{$ENDIF}
{$ELSE}
  System.Classes, Winapi.Windows, Winapi.Messages, System.SysUtils, Winapi.WinSock,{$IFDEF DEMO} Vcl.Forms,{$ENDIF}
{$ENDIF}
  clTcpClient, clTcpClientTls, clSspi, clWUtils, clSocketUtils, clUtils;

type
  TclTcpTextEvent = procedure(Sender: TObject; const AText: string) of object;
  TclTcpListEvent = procedure(Sender: TObject; AList: TStrings) of object;

  TclTcpCommandClient = class(TclTcpClientTls)
  private
    FUserName: string;
    FPassword: string;
    FResponse: TStrings;
    FLastResponseCode: Integer;
    FOnReceiveResponse: TclTcpListEvent;
    FOnSendCommand: TclTcpTextEvent;
    FOnProgress: TclProgressEvent;
    FAuthorization: string;
    FCharSet: string;

    procedure SetPassword(const Value: string);
    procedure SetUserName(const Value: string);
    procedure SetCharSet(const Value: string);
    function ReceiveResponse(AddToLastString: Boolean): Boolean;
    function IsOkResponse(AResponseCode: Integer; const AOkResponses: array of Integer): Boolean;
    procedure DoDataProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
    function GetLinesTrailer(const ALinesTrailer: string): string;
    procedure WriteLine(AStream: TStream; const ALine: string);
  protected
    procedure InternalOpen; override;
    procedure InternalClose(ANotifyPeer: Boolean); override;
    procedure DoDestroy; override;

    procedure OpenSession; virtual; abstract;
    procedure CloseSession; virtual; abstract;
    function GetResponseCode(const AResponse: string): Integer; virtual; abstract;

    function ParseResponse(AStartFrom: Integer; const AOkResponses: array of Integer): Integer;
    function InternalWaitResponse(AStartFrom: Integer; const AOkResponses: array of Integer): Integer;
    procedure InternalSendCommandSync(const ACommand: string; const AOkResponses: array of Integer); virtual;
    procedure SetAuthorization(const Value: string); virtual;
    function GetWriteCharSet(const AText: string): string; virtual;
    function GetReadCharSet(AStream: TStream): string; virtual;

    procedure DoSendCommand(const AText: string); dynamic;
    procedure DoReceiveResponse(AList: TStrings); dynamic;
    procedure DoProgress(ABytesProceed, ATotalBytes: Int64); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    procedure SendCommand(const ACommand: string);
    procedure SendCommandSync(const ACommand: string; const AOkResponses: array of Integer); overload;
    procedure SendCommandSync(const ACommand: string; const AOkResponses: array of Integer;
      const Args: array of const); overload;
    procedure SendSilentCommand(const ACommand: string; const AOkResponses: array of Integer); overload;
    procedure SendSilentCommand(const ACommand: string; const AOkResponses: array of Integer;
      const Args: array of const); overload;
    procedure SendMultipleLines(ALines: TStrings; const ALinesTrailer: string);
    procedure WaitMultipleLines(ATotalBytes: Int64); virtual;
    procedure WaitResponse(const AOkResponses: array of Integer); virtual;

    property Response: TStrings read FResponse;
    property LastResponseCode: Integer read FLastResponseCode;
  published
    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;
    property Authorization: string read FAuthorization write SetAuthorization;
    property CharSet: string read FCharSet write SetCharSet;

    property OnSendCommand: TclTcpTextEvent read FOnSendCommand write FOnSendCommand;
    property OnReceiveResponse: TclTcpListEvent read FOnReceiveResponse write FOnReceiveResponse;
    property OnProgress: TclProgressEvent read FOnProgress write FOnProgress;
  end;

const
  SOCKET_WAIT_RESPONSE = 0;
  SOCKET_DOT_RESPONSE = 1;

implementation

uses
  clTranslator{$IFDEF LOGGER}, clLogger{$ENDIF};

{ TclTcpCommandClient }

procedure TclTcpCommandClient.SendCommand(const ACommand: string);
var
  cmd: string;
begin
  CheckConnected();
  cmd := ACommand + #13#10;
  Connection.InitProgress(0, 0);
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'SendCommand: ' + cmd);{$ENDIF}
  Connection.WriteString(cmd, GetWriteCharSet(cmd));
  DoSendCommand(cmd);
end;

function TclTcpCommandClient.ReceiveResponse(AddToLastString: Boolean): Boolean;
var
  stream: TStream;
  strUtils: TclStringsUtils;
begin
  stream := nil;
  strUtils := nil;
  try
    stream := TMemoryStream.Create();
    Connection.ReadData(stream);
    stream.Position := 0;

    strUtils := TclStringsUtils.Create(Response, GetReadCharSet(stream));
    Result := strUtils.AddTextStream(stream, AddToLastString) > 0;
  finally
    strUtils.Free();
    stream.Free();
  end;
end;

function TclTcpCommandClient.IsOkResponse(AResponseCode: Integer; const AOkResponses: array of Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  i := Low(AOkResponses);
  while (i <= High(AOkResponses)) and (AOkResponses[i] <> 0) do
  begin
    if (AOkResponses[i] = AResponseCode) then
    begin
      Result := True;
      Break;
    end;
    Inc(i);
  end;
end;

procedure TclTcpCommandClient.WaitResponse(const AOkResponses: array of Integer);
begin
  Response.Clear();
  InternalWaitResponse(0, AOkResponses);
  DoReceiveResponse(Response);
end;

procedure TclTcpCommandClient.InternalSendCommandSync(const ACommand: string;
  const AOkResponses: array of Integer);
begin
  SendCommand(ACommand);
  WaitResponse(AOkResponses);
end;

procedure TclTcpCommandClient.SendCommandSync(const ACommand: string;
  const AOkResponses: array of Integer);
begin
  InProgress := True;
  try
    InternalSendCommandSync(ACommand, AOkResponses);
  finally
    InProgress := False;
  end;
end;

procedure TclTcpCommandClient.SendCommandSync(const ACommand: string;
  const AOkResponses: array of Integer; const Args: array of const);
begin
  SendCommandSync(Format(ACommand, Args), AOkResponses);
end;

procedure TclTcpCommandClient.SetAuthorization(const Value: string);
begin
  if (FAuthorization <> Value) then
  begin
    FAuthorization := Value;
    Changed();
  end;
end;

procedure TclTcpCommandClient.SetCharSet(const Value: string);
begin
  if (FCharSet <> Value) then
  begin
    FCharSet := Value;
    Changed();
  end;
end;

procedure TclTcpCommandClient.SetPassword(const Value: string);
begin
  if (FPassword <> Value) then
  begin
    FPassword := Value;
    Changed();
  end;
end;

procedure TclTcpCommandClient.SetUserName(const Value: string);
begin
  if (FUserName <> Value) then
  begin
    FUserName := Value;
    Changed();
  end;
end;

constructor TclTcpCommandClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FResponse := TStringList.Create();
  FCharSet := '';
end;

procedure TclTcpCommandClient.InternalClose(ANotifyPeer: Boolean);
begin
  try
    if Active and not InProgress then
    begin
      CloseSession();
    end;
  finally
    inherited InternalClose(ANotifyPeer);
  end;
end;

procedure TclTcpCommandClient.InternalOpen;
begin
{$IFDEF DEMO}
{$IFNDEF STANDALONEDEMO}
  if FindWindow('TAppBuilder', nil) = 0 then
  begin
    MessageBox(0, 'This demo version can be run under Delphi/C++Builder IDE only. ' +
      'Please visit www.clevercomponents.com to purchase your ' +
      'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    ExitProcess(1);
  end;
{$ENDIF}
{$ENDIF}

  inherited InternalOpen();
  OpenSession();
end;

function TclTcpCommandClient.GetLinesTrailer(const ALinesTrailer: string): string;
begin
  Result := ALinesTrailer;

  if (Result <> '')
    and (Result[Length(Result)] <> #10) then
  begin
    Result := Result + #13#10;
  end;
end;

function TclTcpCommandClient.GetReadCharSet(AStream: TStream): string;
begin
  Result := FCharSet;
end;

function TclTcpCommandClient.GetWriteCharSet(const AText: string): string;
begin
  Result := FCharSet;
end;

procedure TclTcpCommandClient.WriteLine(AStream: TStream; const ALine: string);
var
  buf: TclByteArray;
begin
  buf := TclTranslator.GetBytes(ALine, GetWriteCharSet(ALine));
  if (Length(buf) > 0) then
  begin
    AStream.Write(buf[0], Length(buf));
  end;
end;

procedure TclTcpCommandClient.SendMultipleLines(ALines: TStrings; const ALinesTrailer: string);
var
  i: Integer;
  stream: TStream;
  line, trailer: string;
begin
  if (BatchSize < 1) then
  begin
    RaiseSocketError(InvalidBatchSize, InvalidBatchSizeCode);
  end;

  trailer := GetLinesTrailer(ALinesTrailer);

  stream := TMemoryStream.Create();
  Connection.OnProgress := DoDataProgress;
  InProgress := True;
  try
    i := 0;
    line := '';

    Connection.InitProgress(0, GetStringsSize(ALines) + Length(trailer));

    while (i < ALines.Count) do
    begin
      line := ALines[i];
      if (Length(ALines[i]) + Length(#13#10) + 1 > BatchSize) then
      begin
        if (stream.Size > 0) then
        begin
          stream.Position := 0;
          Connection.WriteData(stream);
          stream.Size := 0;
        end;

        Connection.WriteString(line + #13#10, GetWriteCharSet(line));
      end else
      if ((stream.Size + 3 + Length(line)) <= BatchSize) then
      begin
        if (Length(line) > 0) then
        begin
          if (trailer = '.'#13#10) and (line[1] = '.') then
          begin
            WriteLine(stream, '.');
          end;
          WriteLine(stream, line);
        end;
        WriteLine(stream, #13#10);
      end else
      begin
        stream.Position := 0;
        Connection.WriteData(stream);
        stream.Position := 0;
        stream.Size := 0;

        Continue;
      end;
      Inc(i);
    end;

    if (stream.Size > 0) then
    begin
      stream.Position := 0;
      Connection.WriteData(stream);
    end;

    if (trailer <> '') then
    begin
      stream.Position := 0;
      stream.Size := 0;
      WriteLine(stream, trailer);

      stream.Position := 0;
      Connection.WriteData(stream);
    end;
  finally
    InProgress := False;
    Connection.OnProgress := nil;
    stream.Free();
  end;
end;

procedure TclTcpCommandClient.DoReceiveResponse(AList: TStrings);
begin
  if Assigned(OnReceiveResponse) then
  begin
    OnReceiveResponse(Self, AList);
  end;
end;

procedure TclTcpCommandClient.DoSendCommand(const AText: string);
begin
  if Assigned(OnSendCommand) then
  begin
    OnSendCommand(Self, AText);
  end;
end;

procedure TclTcpCommandClient.DoProgress(ABytesProceed, ATotalBytes: Int64);
begin
  if Assigned(OnProgress) then
  begin
    OnProgress(Self, ABytesProceed, ATotalBytes);
  end;
end;

procedure TclTcpCommandClient.DoDestroy;
begin
  FResponse.Free();
  inherited DoDestroy();
end;

procedure TclTcpCommandClient.WaitMultipleLines(ATotalBytes: Int64);

  function CheckForDotTerminator: Boolean;
  begin
    Result := (Response.Count > 0) and (Response[Response.Count - 1] = '.');
  end;

  procedure RemoveResponseLine;
  begin
    if (Response.Count > 0) then
    begin
      Response.Delete(0);
    end;
  end;

  procedure RemoveDotTerminatorLine;
  begin
    Assert(Response.Count > 0);
    Response.Delete(Response.Count - 1);
  end;

  procedure ReplaceLeadingDotTerminator;
  var
    i: Integer;
  begin
    for i := 0 to Response.Count - 1 do
    begin
      if (system.Pos('..', Response[i]) = 1) then
      begin
        Response[i] := system.Copy(Response[i], 2, Length(Response[i]));
      end;
    end;
  end;

begin
  Connection.OnProgress := DoDataProgress;
  InProgress := True;
  try
    if (ATotalBytes > 0) then
    begin
      Connection.InitProgress(GetStringsSize(Response), ATotalBytes);
    end else
    begin
      Connection.InitProgress(0, 0);
    end;

    RemoveResponseLine();
    if not CheckForDotTerminator then
    begin
      InternalWaitResponse(0, [SOCKET_DOT_RESPONSE]);
    end;
    ReplaceLeadingDotTerminator();
    RemoveDotTerminatorLine();
  finally
    InProgress := False;
    Connection.OnProgress := nil;
  end;
  if (ATotalBytes > 0) then
  begin
    DoProgress(ATotalBytes, ATotalBytes);
  end;
end;

procedure TclTcpCommandClient.DoDataProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
begin
  if (ABytesProceed <= ATotalBytes) then
  begin
    DoProgress(ABytesProceed, ATotalBytes);
  end;
end;

function TclTcpCommandClient.ParseResponse(AStartFrom: Integer; const AOkResponses: array of Integer): Integer;
var
  i, tempCode: Integer;
begin
  Result := -1;
  for i := AStartFrom to Response.Count - 1 do
  begin
    tempCode := GetResponseCode(Response[i]);
    if (tempCode <> SOCKET_WAIT_RESPONSE) then
    begin
      FLastResponseCode := tempCode;
      if IsOkResponse(LastResponseCode, AOkResponses) then
      begin
        Result := i;
        Exit;
      end;
    end;
  end;
end;

function TclTcpCommandClient.InternalWaitResponse(AStartFrom: Integer;
  const AOkResponses: array of Integer): Integer;
var
  keepLastString: Boolean;
begin
  Result := -1;
  keepLastString := False;
  repeat
    keepLastString := ReceiveResponse(keepLastString);

    if keepLastString then
    begin
      Continue;
    end;

    FLastResponseCode := SOCKET_WAIT_RESPONSE;

    if (Response.Count = AStartFrom) and (Length(AOkResponses) = 0) then
    begin
      Break;
    end;

    Result := ParseResponse(AStartFrom, AOkResponses);
    if Result > -1 then
    begin
      Break;
    end;

    if not ((Length(AOkResponses) = 1) and (AOkResponses[Low(AOkResponses)] = SOCKET_DOT_RESPONSE))
      and (LastResponseCode <> SOCKET_WAIT_RESPONSE) then
    begin
      RaiseTcpClientError(Trim(Response.Text), LastResponseCode);
    end;
  until False;
end;

procedure TclTcpCommandClient.SendSilentCommand(const ACommand: string;
  const AOkResponses: array of Integer; const Args: array of const);
begin
  CheckConnected();
  try
    SendCommandSync(ACommand, AOkResponses, Args);
  except
    on EclSocketError do ;
    on EclSSPIError do ;
  end;
end;

procedure TclTcpCommandClient.SendSilentCommand(const ACommand: string;
  const AOkResponses: array of Integer);
begin
  CheckConnected();
  try
    SendCommandSync(ACommand, AOkResponses);
  except
    on EclSocketError do ;
    on EclSSPIError do ;
  end;
end;

end.
