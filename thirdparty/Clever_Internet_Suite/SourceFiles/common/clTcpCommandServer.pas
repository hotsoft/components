{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clTcpCommandServer;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, Contnrs, SyncObjs, SysUtils,
{$ELSE}
  System.Classes, System.Contnrs, System.SyncObjs, System.SysUtils, System.Types,
{$ENDIF}
  clTcpServer, clTcpServerTls, clWUtils, clTranslator;

type
  TclServerSaslFlag = (ssUseLogin, ssUseCramMD5, ssUseNTLM);
  TclServerSaslFlags = set of TclServerSaslFlag;

  TclTcpCommandServer = class;
  TclCommandConnection = class;
  TclTcpCommandInfo = class;
  TclTcpCommandParams = class;

  EclTcpCommandServerError = class(EclTcpServerError)
  private
    FCommand: string;
    FNeedClose: Boolean;
  public
    constructor Create(const ACommand, AErrorMsg: string; AErrorCode: Integer); overload;
    constructor Create(const ACommand, AErrorMsg: string; AErrorCode: Integer; ANeedClose: Boolean); overload;

    property Command: string read FCommand;
    property NeedClose: Boolean read FNeedClose;
  end;

  EclMaxDataSizeError = class(EclTcpCommandServerError)
  public
    constructor Create;
  end;

  TclTcpCommandConnectionEvent = procedure (Sender: TObject; AConnection: TclCommandConnection) of object;
  TclTcpCommandEvent = procedure (Sender: TObject; AConnection: TclCommandConnection;
    ACommandParams: TclTcpCommandParams) of object;
  TclTcpResponseEvent = procedure (Sender: TObject; AConnection: TclCommandConnection;
    const ACommand, AResponse: string) of object;
  TclCreateCommandParamsEvent = procedure (Sender: TObject; AConnection: TclCommandConnection;
    var ACommandParams: TclTcpCommandParams) of object;

  TclProcessDataContext = class
  private
    FIsReady: Boolean;
  public
    constructor Create;

    property IsReady: Boolean read FIsReady write FIsReady;
  end;

	TclProcessDataEvent = procedure (AConnection: TclCommandConnection; AContext: TclProcessDataContext) of object;
  TclCreateCommandParameterEvent = function(AConnection: TclCommandConnection): TclTcpCommandParams of object;

  TclProcessDataHandler = class
  private
    FServer: TclTcpCommandServer;
    FConnection: TclCommandConnection;
    FHandler: TclProcessDataEvent;
    FRawData: TMemoryStream;
    FIsMaxDataSize: Boolean;
  protected
    function ExtractData(AData: TStream; var AUnprocessedBytes: Int64; AMaxDataSize: Int64): TclProcessDataContext; virtual; abstract;
    function CheckMaxDataSize(ADataSize, AMaxDataSize: Int64): Boolean;
  public
    constructor Create(AServer: TclTcpCommandServer; AHandler: TclProcessDataEvent);
    destructor Destroy; override;

    function GenContext(AMaxDataSize: Int64): TclProcessDataContext;
    procedure HandleData(AContext: TclProcessDataContext);

    property Server: TclTcpCommandServer read FServer;
    property Connection: TclCommandConnection read FConnection write FConnection;
    property RawData: TMemoryStream read FRawData;
    property IsMaxDataSize: Boolean read FIsMaxDataSize write FIsMaxDataSize;
  end;

  TclProcessSingleCommandContext = class(TclProcessDataContext)
  private
    FCommand: TclTcpCommandInfo;
  public
    constructor Create(ACommand: TclTcpCommandInfo);

    property Command: TclTcpCommandInfo read FCommand;
  end;

  TclProcessSingleCommandHandler = class(TclProcessDataHandler)
  private
    FCommand: TclTcpCommandInfo;
  public
    constructor Create(AServer: TclTcpCommandServer; AHandler: TclProcessDataEvent; ACommand: TclTcpCommandInfo);
    destructor Destroy; override;

    property Command: TclTcpCommandInfo read FCommand;
  end;

  TclProcessLineContext = class(TclProcessSingleCommandContext)
  private
    FLine: string;
  public
    constructor Create(ACommand: TclTcpCommandInfo; const ALine: string; AIsReady: Boolean);

    property Line: string read FLine;
  end;

  TclProcessLineHandler = class(TclProcessSingleCommandHandler)
  private
    function CheckEof(AData: TStream): Boolean;
  protected
    function ExtractData(AData: TStream; var AUnprocessedBytes: Int64; AMaxDataSize: Int64): TclProcessDataContext; override;
  end;

  TclProcessMultiLineContext = class(TclProcessSingleCommandContext)
  private
    FData: TStrings;
  public
    constructor Create(ACommand: TclTcpCommandInfo);
    destructor Destroy; override;

    property Data: TStrings read FData;
  end;

  TclProcessMultiLineHandler = class(TclProcessSingleCommandHandler)
  private
    function CheckEof(AData: TStream): Boolean;
    procedure RemoveDoubleDot(AData: TStrings);
  protected
    function ExtractData(AData: TStream; var AUnprocessedBytes: Int64; AMaxDataSize: Int64): TclProcessDataContext; override;
  end;

  TclProcessFixedBytesHandler = class(TclProcessSingleCommandHandler)
  private
    FSize: Int64;
    FTotalSize: Int64;
  protected
    function ExtractData(AData: TStream; var AUnprocessedBytes: Int64; AMaxDataSize: Int64): TclProcessDataContext; override;
  public
    constructor Create(AServer: TclTcpCommandServer; AHandler: TclProcessDataEvent; ACommand: TclTcpCommandInfo; ASize: Int64);
  end;

  TclProcessCommandContext = class(TclProcessDataContext)
  private
    FParsedCommands: TObjectList;

    function GetCount: Integer;
    function GetCommands(Index: Integer): TclTcpCommandParams;
  public
    constructor Create;
    destructor Destroy; override;

    function AddCommand(ACommand: TclTcpCommandParams): TclTcpCommandParams;

    property Commands[Index: Integer]: TclTcpCommandParams read GetCommands;
    property Count: Integer read GetCount;
  end;

  TclProcessCommandHandler = class(TclProcessDataHandler)
  private
    FParameterCreator: TclCreateCommandParameterEvent;

    procedure ParseCommands(ARawCommands: TStrings; AContext: TclProcessCommandContext);
  protected
    function CreateCommandContext: TclProcessCommandContext; virtual;
    function ExtractData(AData: TStream; var AUnprocessedBytes: Int64; AMaxDataSize: Int64): TclProcessDataContext; override;
  public
    constructor Create(AServer: TclTcpCommandServer; AHandler: TclProcessDataEvent; AParameterCreator: TclCreateCommandParameterEvent);
  end;

  TclTcpCommandList = class;

  TclTcpCommandInfo = class
  private
    FName: string;
    FIsOOB: Boolean;
    FServer: TclTcpCommandServer;
  protected
    procedure Execute(AConnection: TclCommandConnection; AParams: TclTcpCommandParams); virtual; abstract;
  public
    constructor Create(const AName: string; AIsOOB: Boolean); overload;
    constructor Create(const AName: string); overload;

    property Server: TclTcpCommandServer read FServer;
    property Name: string read FName write FName;
    property IsOOB: Boolean read FIsOOB write FIsOOB;
  end;

  TclTcpCustomCommandInfo = class(TclTcpCommandInfo)
  protected
    procedure Execute(AConnection: TclCommandConnection; AParams: TclTcpCommandParams); override;
  end;

  TclTcpCommandList = class
  private
    FList: TObjectList;
    FServer: TclTcpCommandServer;
    
    function GetItem(Index: Integer): TclTcpCommandInfo;
    function GetCount: Integer;
  public
    constructor Create(AServer: TclTcpCommandServer);
    destructor Destroy; override;

    function Add(ACommand: TclTcpCommandInfo): TclTcpCommandInfo;
    function AddCustomCommand(const AName: string): TclTcpCustomCommandInfo;
    function CommandByName(const AName: string): TclTcpCommandInfo;
    procedure Delete(Index: Integer);
    procedure Remove(ACommand: TclTcpCommandInfo);
    procedure Clear;

    property Items[Index: Integer]: TclTcpCommandInfo read GetItem; default;
    property Count: Integer read GetCount;
    property Server: TclTcpCommandServer read FServer;
  end;

  TclTcpCommandParams = class
  private
    FCommand: string;
    FParameters: string;
    FRawCommand: string;
    FRawData: TStrings;
  public
    constructor Create(const ACommand, AParameters: string); overload;
    constructor Create; overload;

    procedure FromRawCommand(const ARawCommand: string); virtual;
    procedure FromRawLine(AContext: TclProcessLineContext); virtual;
    procedure FromRawMultiLine(AContext: TclProcessMultiLineContext); virtual;

    property Command: string read FCommand write FCommand;
    property Parameters: string read FParameters write FParameters;
    property RawCommand: string read FRawCommand write FRawCommand;
    property RawData: TStrings read FRawData write FRawData;
  end;

  TclCommandConnection = class(TclUserConnectionTls)
  private
    FCommandAccessor: TCriticalSection;
    FLines: TStrings;
    FLinesSent: Boolean;
    FCurrentLine: Integer;
    FLinesTrailer: string;
    FLinesCount: Integer;
    FDataHandler: TclProcessDataHandler;

    procedure SetLines(const Value: TStrings);
    procedure SetDataHandler(AHandler: TclProcessDataHandler);
  protected
    procedure DoDestroy; override;
  public
    constructor Create;

    procedure BeginCommand;
    procedure EndCommand;
  end;

  TclTcpCommandServer = class(TclTcpServerTls)
  private
    FCommands: TclTcpCommandList;
    FOnReceiveCommand: TclTcpCommandEvent;
    FOnSendResponse: TclTcpResponseEvent;
    FOnCreateCommandParams: TclCreateCommandParamsEvent;
    FOnCustomCommand: TclTcpCommandEvent;
    FOnSendMultipleLines: TclTcpCommandConnectionEvent;
    FMaxDataSize: Int64;
    FCharSet: string;

    procedure HandleMultiLineData(AConnection: TclCommandConnection; AContext: TclProcessDataContext);
    procedure HandleLineData(AConnection: TclCommandConnection; AContext: TclProcessDataContext);
    procedure HandleCommandData(AConnection: TclCommandConnection; AContext: TclProcessDataContext);
    function CreateCommandParams(AConnection: TclCommandConnection): TclTcpCommandParams;
    function CreateCommandHandler(AConnection: TclCommandConnection): TclProcessCommandHandler;
    function GetLinesTrailer(const ALinesTrailer: string): string;
    procedure WriteLine(AConnection: TclCommandConnection; AStream: TStream; const ALine: string);
    procedure WriteData(AConnection: TclCommandConnection; AStream: TStream);
    procedure NextMultipleLines(AConnection: TclCommandConnection);
  protected
    procedure GetCommands; virtual; abstract;
    function GetNullCommand(AParameters: TclTcpCommandParams): TclTcpCommandInfo; virtual; abstract;
    procedure ProcessUnhandledError(AConnection: TclCommandConnection;
      AParameters: TclTcpCommandParams; E: Exception); virtual; abstract;
    procedure ProcessMaxDataSizeError(AConnection: TclCommandConnection; var Handled: Boolean); virtual;
    function GetWriteCharSet(AConnection: TclCommandConnection; const AText: string): string; virtual;
    function GetReadCharSet(AConnection: TclCommandConnection; AStream: TStream): string; virtual;

    procedure ReadConnection(AConnection: TclUserConnection); override;
    procedure DoWriteConnection(AConnection: TclUserConnection); override;
    procedure DoDestroy; override;
    function CreateNewConnection: TclUserConnection; override;

    procedure DoReceiveCommand(AConnection: TclCommandConnection;
      ACommandParams: TclTcpCommandParams); virtual;
    procedure DoSendResponse(AConnection: TclCommandConnection;
      const ACommand, AResponse: string); virtual;
    procedure DoCreateCommandParams(AConnection: TclCommandConnection;
      var ACommandParams: TclTcpCommandParams); virtual;
    procedure DoCustomCommand(AConnection: TclCommandConnection; ACommandParams: TclTcpCommandParams); virtual;
    procedure DoSendMultipleLines(AConnection: TclCommandConnection); virtual;
  public
    constructor Create(AOwner: TComponent); override;

    procedure SendResponse(AConnection: TclCommandConnection; const ACommand, AResponse: string); overload;
    procedure SendResponse(AConnection: TclCommandConnection; const ACommand, AResponse: string; const Args: array of const); overload;
    procedure SendResponseAndClose(AConnection: TclCommandConnection; const ACommand, AResponse: string);
    procedure SendMultipleLines(AConnection: TclCommandConnection; var ALines: TStrings; const ALinesTrailer: string); overload;
    procedure SendMultipleLines(AConnection: TclCommandConnection; var ALines: TStrings;
      const ALinesTrailer: string; ALinesCount: Integer); overload;

    procedure AcceptData(AConnection: TclCommandConnection; AHandler: TclProcessDataHandler);
    procedure AcceptCommands(AConnection: TclCommandConnection);
    procedure AcceptLines(AConnection: TclCommandConnection; ACommand: TclTcpCommandInfo);
    procedure AcceptMultipleLines(AConnection: TclCommandConnection; ACommand: TclTcpCommandInfo);
    procedure AcceptFixedBytes(AConnection: TclCommandConnection; ACommand: TclTcpCommandInfo; ASize: Int64);

    procedure ProcessCommand(AConnection: TclCommandConnection; ACommand: TclTcpCommandInfo; AParameters: TclTcpCommandParams);

    property Commands: TclTcpCommandList read FCommands;
  published
    property MaxDataSize: Int64 read FMaxDataSize write FMaxDataSize default -1;
    property CharSet: string read FCharSet write FCharSet;
    
    property OnReceiveCommand: TclTcpCommandEvent read FOnReceiveCommand write FOnReceiveCommand;
    property OnSendResponse: TclTcpResponseEvent read FOnSendResponse write FOnSendResponse;
    property OnCreateCommandParams: TclCreateCommandParamsEvent read FOnCreateCommandParams write FOnCreateCommandParams;
    property OnCustomCommand: TclTcpCommandEvent read FOnCustomCommand write FOnCustomCommand;
    property OnSendMultipleLines: TclTcpCommandConnectionEvent read FOnSendMultipleLines write FOnSendMultipleLines;
  end;

resourcestring
  MaxDataSizeError = 'Data size limit is exceeded';

const
  MaxDataSizeErrorCode = -350;

implementation

uses
  clUtils{$IFDEF LOGGER}, clLogger{$ENDIF};

{ TclTcpCommandServer }

constructor TclTcpCommandServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCommands := TclTcpCommandList.Create(Self);
  GetCommands();
  FMaxDataSize := -1;
end;

function TclTcpCommandServer.CreateNewConnection: TclUserConnection;
begin
  Result := inherited CreateNewConnection();
  AcceptCommands(Result as TclCommandConnection);
end;

procedure TclTcpCommandServer.ReadConnection(AConnection: TclUserConnection);
var
  context: TclProcessDataContext;
  connection: TclCommandConnection;
  handled: Boolean;
begin
  connection := (AConnection as TclCommandConnection);
  Assert(connection.FDataHandler <> nil);

  context := nil;
  try
    connection.BeginWork();
    try
      InternalStartTls(connection);
      ReadData(connection, connection.FDataHandler.RawData);
      DoReadConnection(connection, connection.FDataHandler.RawData);

      context := connection.FDataHandler.GenContext(MaxDataSize);
    finally
      connection.EndWork();
    end;

    try
      connection.FDataHandler.HandleData(context);
    except
      on EclMaxDataSizeError do
      begin
        handled := False;
        ProcessMaxDataSizeError(connection, handled);
        if (not handled) then
        begin
          CloseConnection(connection);
          raise;
        end;
      end;
    end;
  finally
    context.Free();
  end;
end;

function TclTcpCommandServer.CreateCommandHandler(AConnection: TclCommandConnection): TclProcessCommandHandler;
begin
  Result := TclProcessCommandHandler.Create(Self, HandleCommandData, CreateCommandParams);
end;

function TclTcpCommandServer.CreateCommandParams(AConnection: TclCommandConnection): TclTcpCommandParams;
begin
  Result := nil;
  DoCreateCommandParams(AConnection, Result);
  if (Result = nil) then
  begin
    Result := TclTcpCommandParams.Create();
  end;
end;

procedure TclTcpCommandServer.HandleCommandData(AConnection: TclCommandConnection;
  AContext: TclProcessDataContext);
var
  i: Integer;
  commandContext: TclProcessCommandContext;
  command: TclTcpCommandParams;
  info: TclTcpCommandInfo; 
begin
  commandContext := (AContext as TclProcessCommandContext);

  for i := 0 to commandContext.Count - 1 do
  begin
    command := commandContext.Commands[i];
    info := Commands.CommandByName(command.Command);
    if (info = nil) then
    begin
      info := GetNullCommand(command);
      try
        ProcessCommand(AConnection, info, command);
      finally
        info.Free();
      end;
    end else
    begin
      ProcessCommand(AConnection, info, command);
    end;
  end;
end;

procedure TclTcpCommandServer.HandleLineData(AConnection: TclCommandConnection;
  AContext: TclProcessDataContext);
var
  lineContext: TclProcessLineContext;
  parameters: TclTcpCommandParams;
begin
  lineContext := (AContext as TclProcessLineContext);

  parameters := CreateCommandParams(AConnection);
  try
    parameters.FromRawLine(lineContext);
    ProcessCommand(AConnection, lineContext.Command, parameters);
  finally
    parameters.Free();
  end;
end;

procedure TclTcpCommandServer.HandleMultiLineData(
  AConnection: TclCommandConnection; AContext: TclProcessDataContext);
var
  lineContext: TclProcessMultiLineContext;
  parameters: TclTcpCommandParams;
begin
  lineContext := (AContext as TclProcessMultiLineContext);

  parameters := CreateCommandParams(AConnection);
  try
    parameters.FromRawMultiLine(lineContext);
    ProcessCommand(AConnection, lineContext.Command, parameters);
  finally
    parameters.Free();
  end;
end;

procedure TclTcpCommandServer.SendResponse(AConnection: TclCommandConnection;
  const ACommand, AResponse: string);
var
  stream: TStream;
  buffer: TclByteArray;
  resp: string;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}

{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, Format('(%d) SendResponse, command: %s, response: %s', [AConnection.Socket.Socket, ACommand, AResponse]));
{$ENDIF}

  DoSendResponse(AConnection, ACommand, AResponse);

  stream := TMemoryStream.Create();
  try
    resp := AResponse + #13#10;
    buffer := TclTranslator.GetBytes(resp, GetWriteCharSet(AConnection, resp));
    stream.WriteBuffer(buffer[0], Length(buffer));
    stream.Position := 0;
    AConnection.WriteData(stream);
  finally
    stream.Free();
  end;
end;

function TclTcpCommandServer.GetLinesTrailer(const ALinesTrailer: string): string;
begin
  Result := ALinesTrailer;
  
  if (Result <> '')
    and (Result[Length(Result)] <> #10) then
  begin
    Result := Result + #13#10;
  end;
end;

function TclTcpCommandServer.GetReadCharSet(AConnection: TclCommandConnection; AStream: TStream): string;
begin
  Result := FCharSet;
end;

function TclTcpCommandServer.GetWriteCharSet(AConnection: TclCommandConnection; const AText: string): string;
begin
  Result := FCharSet;
end;

procedure TclTcpCommandServer.SendMultipleLines( AConnection: TclCommandConnection;
  var ALines: TStrings; const ALinesTrailer: string; ALinesCount: Integer);
begin
  AConnection.BeginWork();
  try
    try
      AConnection.FLinesSent := False;
      AConnection.SetLines(ALines);

      AConnection.FLinesTrailer := GetLinesTrailer(ALinesTrailer);

      if (AConnection.FLinesTrailer <> '')
        and (AConnection.FLinesTrailer[Length(AConnection.FLinesTrailer)] <> #10) then
      begin
        AConnection.FLinesTrailer := AConnection.FLinesTrailer + #13#10;
      end;

      AConnection.FLinesCount := ALinesCount;

      if ((AConnection.FLinesCount = 0) or (AConnection.FLinesCount > AConnection.FLines.Count)) then
      begin
        AConnection.FLinesCount := AConnection.FLines.Count;
      end;

      NextMultipleLines(AConnection);
    except
      on Exception do
      begin
        AConnection.FLines := nil;
        raise;
      end;
    end;
  finally
    AConnection.EndWork();
  end;
end;

procedure TclTcpCommandServer.SendResponse(AConnection: TclCommandConnection;
  const ACommand, AResponse: string; const Args: array of const);
begin
  SendResponse(AConnection, ACommand, Format(AResponse, Args));
end;

procedure TclTcpCommandServer.SendResponseAndClose(
  AConnection: TclCommandConnection; const ACommand, AResponse: string);
var
  stream: TStream;
  buffer: TclByteArray;
  resp: string;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}

  DoSendResponse(AConnection, ACommand, AResponse);

  stream := TMemoryStream.Create();
  try
    resp := AResponse + #13#10;
    buffer := TclTranslator.GetBytes(resp, GetWriteCharSet(AConnection, resp));
    stream.WriteBuffer(buffer[0], Length(buffer));
    stream.Position := 0;
    AConnection.WriteDataAndClose(stream);
  finally
    stream.Free();
  end;
end;

procedure TclTcpCommandServer.AcceptCommands(AConnection: TclCommandConnection);
begin
  AcceptData(AConnection, CreateCommandHandler(AConnection));
end;

procedure TclTcpCommandServer.AcceptData(AConnection: TclCommandConnection;
  AHandler: TclProcessDataHandler);
begin
  AConnection.BeginWork();
  try
    AConnection.SetDataHandler(AHandler);
  finally
    AConnection.EndWork();
  end;
end;

procedure TclTcpCommandServer.AcceptFixedBytes(AConnection: TclCommandConnection; ACommand: TclTcpCommandInfo; ASize: Int64);
begin
  AcceptData(AConnection, TclProcessFixedBytesHandler.Create(Self, HandleMultiLineData, ACommand, ASize));
end;

procedure TclTcpCommandServer.AcceptLines(AConnection: TclCommandConnection;
  ACommand: TclTcpCommandInfo);
begin
  AcceptData(AConnection, TclProcessLineHandler.Create(Self, HandleLineData, ACommand));
end;

procedure TclTcpCommandServer.AcceptMultipleLines(
  AConnection: TclCommandConnection; ACommand: TclTcpCommandInfo);
begin
  AcceptData(AConnection, TclProcessMultiLineHandler.Create(Self, HandleMultiLineData, ACommand));
end;

procedure TclTcpCommandServer.DoReceiveCommand(AConnection: TclCommandConnection;
  ACommandParams: TclTcpCommandParams);
begin
  if Assigned(OnReceiveCommand) then
  begin
    OnReceiveCommand(Self, AConnection, ACommandParams);
  end;
end;

procedure TclTcpCommandServer.DoSendMultipleLines(AConnection: TclCommandConnection);
begin
  if Assigned(OnSendMultipleLines) then
  begin
    OnSendMultipleLines(Self, AConnection);
  end;
end;

procedure TclTcpCommandServer.DoSendResponse(
  AConnection: TclCommandConnection; const ACommand, AResponse: string);
begin
  if Assigned(OnSendResponse) then
  begin
    OnSendResponse(Self, AConnection, ACommand, AResponse);
  end;
end;

procedure TclTcpCommandServer.DoDestroy;
begin
  FCommands.Free();
  inherited DoDestroy();
end;

procedure TclTcpCommandServer.DoCreateCommandParams(AConnection: TclCommandConnection;
  var ACommandParams: TclTcpCommandParams);
begin
  if Assigned(OnCreateCommandParams) then
  begin
    OnCreateCommandParams(Self, AConnection, ACommandParams);
  end;
end;

procedure TclTcpCommandServer.DoCustomCommand(AConnection: TclCommandConnection; ACommandParams: TclTcpCommandParams);
begin
  if Assigned(OnCustomCommand) then
  begin
    OnCustomCommand(Self, AConnection, ACommandParams);
  end;
end;

procedure TclTcpCommandServer.WriteLine(AConnection: TclCommandConnection; AStream: TStream; const ALine: string);
var
  buf: TclByteArray;
begin
  buf := TclTranslator.GetBytes(ALine, GetWriteCharSet(AConnection, ALine));
  if (Length(buf) > 0) then
  begin
    AStream.Write(buf[0], Length(buf));
  end;
end;

procedure TclTcpCommandServer.WriteData(AConnection: TclCommandConnection; AStream: TStream);
begin
  if not AConnection.WriteData(AStream) then
  begin
    raise EAbort.Create('');
  end;
end;

procedure TclTcpCommandServer.NextMultipleLines(AConnection: TclCommandConnection);
var
  line: string;
  stream: TStream;
  longLine: Boolean;
begin
  if AConnection.FLinesSent then
  begin
    AConnection.FLinesSent := False;
    DoSendMultipleLines(AConnection);
  end;

  if (AConnection.FLines = nil) then Exit;

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, Format('(%d) NextMultipleLines, FLines <> nil', [AConnection.Socket.Socket]));{$ENDIF}

  stream := TMemoryStream.Create();
  try
    try
      longLine := False;
      while (AConnection.FCurrentLine < AConnection.FLinesCount) do
      begin
        line := AConnection.FLines[AConnection.FCurrentLine];
        longLine := longLine or (Length(line) > BatchSize + 3);

        if longLine or ((stream.Size + 3 + Length(line)) <= BatchSize) then
        begin
          if (Length(line) > 0) then
          begin
            if (AConnection.FLinesTrailer = '.'#13#10) and (line[1] = '.') then
            begin
              WriteLine(AConnection, stream, '.');
            end;
            WriteLine(AConnection, stream, line);
          end;
          WriteLine(AConnection, stream, #13#10);
        end else
        if (stream.Size > 0) then
        begin
          stream.Position := 0;
          WriteData(AConnection, stream);
          stream.Size := 0;
          stream.Position := 0;
          Continue;
        end;

        Inc(AConnection.FCurrentLine);
      end;

      if (stream.Size > 0) then
      begin
        stream.Position := 0;
        WriteData(AConnection, stream);
        stream.Size := 0;
        stream.Position := 0;
      end;

      if (AConnection.FLinesTrailer <> '') then
      begin
        WriteLine(AConnection, stream, AConnection.FLinesTrailer);
      end;

      AConnection.FLinesSent := True;
      AConnection.SetLines(nil);
      AConnection.FLinesTrailer := '';

      stream.Position := 0;
      WriteData(AConnection, stream);
    except
      on EAbort do;
    end;
  finally
    stream.Free();
  end;
end;

procedure TclTcpCommandServer.DoWriteConnection(AConnection: TclUserConnection);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, Format('(%d) DoWriteConnection', [AConnection.Socket.Socket]));{$ENDIF}

  inherited DoWriteConnection(AConnection);
  NextMultipleLines(AConnection as TclCommandConnection);

  {$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'DoWriteConnection'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'DoWriteConnection', E); raise; end; end;{$ENDIF}
end;

procedure TclTcpCommandServer.SendMultipleLines(AConnection: TclCommandConnection;
  var ALines: TStrings; const ALinesTrailer: string);
begin
  SendMultipleLines(AConnection, ALines, ALinesTrailer, 0);
end;

procedure TclTcpCommandServer.ProcessCommand(AConnection: TclCommandConnection;
  ACommand: TclTcpCommandInfo; AParameters: TclTcpCommandParams);
begin
  try
    if (ACommand.IsOOB) then
    begin
      DoReceiveCommand(AConnection, AParameters);
      ACommand.Execute(AConnection, AParameters);
    end else
    begin
      AConnection.BeginCommand();
      try
        DoReceiveCommand(AConnection, AParameters);
        ACommand.Execute(AConnection, AParameters);
      finally
        AConnection.EndCommand();
      end;
    end;
  except
    on E: EclTcpCommandServerError do
    begin
      if E.NeedClose then
      begin
        SendResponseAndClose(AConnection, E.Command, E.Message);
      end else
      begin
        SendResponse(AConnection, E.Command, E.Message);
      end;
    end;
    on E: Exception do
    begin
      ProcessUnhandledError(AConnection, AParameters, E);
      raise;
    end;
  end;
end;

procedure TclTcpCommandServer.ProcessMaxDataSizeError(AConnection: TclCommandConnection; var Handled: Boolean);
begin
end;

{ TclCommandConnection }

procedure TclCommandConnection.BeginCommand;
begin
  FCommandAccessor.Enter();
end;

constructor TclCommandConnection.Create;
begin
  inherited Create();
  FCommandAccessor := TCriticalSection.Create();
end;

procedure TclCommandConnection.DoDestroy;
begin
  SetDataHandler(nil);
  FLines.Free();
  FLines := nil;
  FCommandAccessor.Free();
  inherited DoDestroy();
end;

procedure TclCommandConnection.EndCommand;
begin
  FCommandAccessor.Leave();
end;

procedure TclCommandConnection.SetDataHandler(AHandler: TclProcessDataHandler);
begin
  FDataHandler.Free();
  FDataHandler := AHandler;
  if (FDataHandler <> nil) then
  begin
    FDataHandler.Connection := Self;
  end;
end;

procedure TclCommandConnection.SetLines(const Value: TStrings);
begin
  FCurrentLine := 0;
  FLines.Free();
  FLines := Value;
end;

{ TclTcpCommandList }

function TclTcpCommandList.Add(ACommand: TclTcpCommandInfo): TclTcpCommandInfo;
begin
  FList.Add(ACommand);
  ACommand.FServer := FServer;
  Result := ACommand;
end;

function TclTcpCommandList.AddCustomCommand(const AName: string): TclTcpCustomCommandInfo;
begin
  Result := TclTcpCustomCommandInfo.Create(AName);
  Add(Result);
end;

procedure TclTcpCommandList.Clear;
begin
  FList.Clear();
end;

function TclTcpCommandList.CommandByName(const AName: string): TclTcpCommandInfo;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if (Result.Name = AName) then Exit;
  end;
  Result := nil;
end;

constructor TclTcpCommandList.Create(AServer: TclTcpCommandServer);
begin
  inherited Create();
  FServer := AServer;
  FList := TObjectList.Create(True);
end;

procedure TclTcpCommandList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TclTcpCommandList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function TclTcpCommandList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclTcpCommandList.GetItem(Index: Integer): TclTcpCommandInfo;
begin
  Result := TclTcpCommandInfo(FList[Index]);
end;

procedure TclTcpCommandList.Remove(ACommand: TclTcpCommandInfo);
begin
  FList.Remove(ACommand);
end;

{ TclTcpCommandParams }

constructor TclTcpCommandParams.Create(const ACommand, AParameters: string);
begin
  inherited Create();
  FCommand := ACommand;
  FParameters := AParameters;
  FRawCommand := '';
  FRawData := nil;
end;

constructor TclTcpCommandParams.Create;
begin
  inherited Create();
  FCommand := '';
  FParameters := '';
  FRawCommand := '';
  FRawData := nil;
end;

procedure TclTcpCommandParams.FromRawCommand(const ARawCommand: string);
var
  ind: Integer;
begin
  FRawCommand := ARawCommand;
  FRawData := nil;

  ind := Pos(#32, ARawCommand);
  if (ind > 0) then
  begin
    FCommand := UpperCase(system.Copy(ARawCommand, 1, ind - 1));
    FParameters := system.Copy(ARawCommand, ind + 1, Length(ARawCommand));
  end else
  begin
    FCommand := UpperCase(ARawCommand);
    FParameters := '';
  end;
end;

procedure TclTcpCommandParams.FromRawLine(AContext: TclProcessLineContext);
begin
  FCommand := AContext.Command.Name;
  FParameters := AContext.Line;
  FRawCommand := '';
  FRawData := nil;
end;

procedure TclTcpCommandParams.FromRawMultiLine(AContext: TclProcessMultiLineContext);
begin
  FCommand := AContext.Command.Name;
  FParameters := '';
  FRawCommand := '';
  FRawData := AContext.Data;
end;

{ TclProcessDataHandler }

function TclProcessDataHandler.CheckMaxDataSize(ADataSize, AMaxDataSize: Int64): Boolean;
begin
  Result := (AMaxDataSize > 0) and (ADataSize > AMaxDataSize);
end;

constructor TclProcessDataHandler.Create(AServer: TclTcpCommandServer; AHandler: TclProcessDataEvent);
begin
  inherited Create();
  FRawData := TMemoryStream.Create();

  FServer := AServer;
  FHandler := AHandler;
  FIsMaxDataSize := False;
end;

destructor TclProcessDataHandler.Destroy;
begin
  FRawData.Free();

  inherited Destroy();
end;

function TclProcessDataHandler.GenContext(AMaxDataSize: Int64): TclProcessDataContext;
var
  unprocessedBytes: Int64;
  data: TclBinaryData;
begin
  unprocessedBytes := 0;

  Result := ExtractData(RawData, unprocessedBytes, AMaxDataSize);
  
  if (unprocessedBytes <= 0) then
  begin
    RawData.Size := 0;
  end else
  if (unprocessedBytes < RawData.Size) then
  begin
    RawData.Seek(-unprocessedBytes, soEnd);

    data := TclBinaryData.Create();
    try
      data.FromStream(RawData);
      RawData.Size := 0;
      data.ToStream(RawData);
    finally
      data.Free();
    end;
  end;

  RawData.Seek(0, soEnd);
end;

procedure TclProcessDataHandler.HandleData(AContext: TclProcessDataContext);
begin
  Assert(AContext <> nil);
  Assert(Assigned(FHandler));

  if AContext.IsReady then
  begin
    if IsMaxDataSize then
    begin
      IsMaxDataSize := False;
      raise EclMaxDataSizeError.Create();
    end;

    FHandler(Connection, AContext);
  end;
end;

{ TclProcessCommandContext }

function TclProcessCommandContext.AddCommand(ACommand: TclTcpCommandParams): TclTcpCommandParams;
begin
  FParsedCommands.Add(ACommand);
  Result := ACommand;
end;

constructor TclProcessCommandContext.Create;
begin
  inherited Create();

  FParsedCommands := TObjectList.Create(True);
  IsReady := True;
end;

destructor TclProcessCommandContext.Destroy;
begin
  FParsedCommands.Free();
  inherited Destroy();
end;

function TclProcessCommandContext.GetCommands(Index: Integer): TclTcpCommandParams;
begin
  Result := TclTcpCommandParams(FParsedCommands[Index]);
end;

function TclProcessCommandContext.GetCount: Integer;
begin
  Result := FParsedCommands.Count;
end;

{ TclProcessCommandHandler }

constructor TclProcessCommandHandler.Create(AServer: TclTcpCommandServer; AHandler: TclProcessDataEvent; AParameterCreator: TclCreateCommandParameterEvent);
begin
  inherited Create(AServer, AHandler);

  FParameterCreator := AParameterCreator;
  Assert(Assigned(FParameterCreator));
end;

function TclProcessCommandHandler.CreateCommandContext: TclProcessCommandContext;
begin
  Result := TclProcessCommandContext.Create();
end;

function TclProcessCommandHandler.ExtractData(AData: TStream; var AUnprocessedBytes: Int64; AMaxDataSize: Int64): TclProcessDataContext;
var
  context: TclProcessCommandContext;
  rawCommands: TStrings;
  utils: TclStringsUtils;
begin
  context := CreateCommandContext();
  try
    if CheckMaxDataSize(AData.Size, AMaxDataSize) then
    begin
      IsMaxDataSize := True;
      AUnprocessedBytes := 0;
    end else
    begin
      AData.Position := 0;

      rawCommands := TStringList.Create();
      try
        utils := TclStringsUtils.Create(rawCommands, Server.GetReadCharSet(Connection, AData));
        try
          AUnprocessedBytes := utils.AddTextStream(AData);
        finally
          utils.Free();
        end;

        if (AUnprocessedBytes > 0) and (rawCommands.Count > 0) then
        begin
          rawCommands.Delete(rawCommands.Count - 1);
        end else
        begin
          AUnprocessedBytes := 0;
        end;

        ParseCommands(rawCommands, context);
      finally
        rawCommands.Free();
      end;
    end;

    Result := context;
  except
    context.Free();
    raise;
  end;
end;

procedure TclProcessCommandHandler.ParseCommands(ARawCommands: TStrings; AContext: TclProcessCommandContext);
var
  i: Integer;
  cmdData: string;
begin
  for i := 0 to ARawCommands.Count - 1 do
  begin
    cmdData := Trim(ARawCommands[i]);
    if (cmdData <> '') then
    begin
      AContext.AddCommand(FParameterCreator(Connection)).FromRawCommand(cmdData);
    end;
  end;
end;

{ TclProcessSingleCommandContext }

constructor TclProcessSingleCommandContext.Create(ACommand: TclTcpCommandInfo);
begin
  inherited Create();
  FCommand := ACommand;
end;

{ TclProcessSingleCommandHandler }

constructor TclProcessSingleCommandHandler.Create(AServer: TclTcpCommandServer; AHandler: TclProcessDataEvent;
  ACommand: TclTcpCommandInfo);
begin
  inherited Create(AServer, AHandler);
  FCommand := ACommand;
end;

destructor TclProcessSingleCommandHandler.Destroy;
begin
  FCommand.Free();
  inherited Destroy();
end;

{ TclProcessLineContext }

constructor TclProcessLineContext.Create(ACommand: TclTcpCommandInfo;
  const ALine: string; AIsReady: Boolean);
begin
  inherited Create(ACommand);
  FLine := ALine;
  IsReady := AIsReady;
end;

{ TclProcessLineHandler }

function TclProcessLineHandler.CheckEof(AData: TStream): Boolean;
var
  buf: array[0..1] of Byte;
begin
  if (AData.Size > 1) then
  begin
    AData.Seek(-2, soEnd);

    AData.Read(buf, 2);

    if (buf[0] = 13) and (buf[1] = 10) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

function TclProcessLineHandler.ExtractData(AData: TStream; var AUnprocessedBytes: Int64; AMaxDataSize: Int64): TclProcessDataContext;
var
  buf: TclByteArray;
  line: string;
  isReady: Boolean;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  Result := nil;
  try
    AUnprocessedBytes := AData.Size;
    if IsMaxDataSize then
    begin
      if (AData.Size > 2) then
      begin
        AUnprocessedBytes := 2;
      end;
    end else
    begin
      if CheckMaxDataSize(AData.Size, AMaxDataSize) then
      begin
        IsMaxDataSize := True;
      end;
    end;

    line := '';
    isReady := False;

    if (CheckEof(AData)) then
    begin
      if not IsMaxDataSize then
      begin
        AData.Seek(0, soBeginning);
        SetLength(buf, AData.Size - 2);
        if (Length(buf) > 0) then
        begin
          AData.Read(buf[0], Length(buf));
        end;
        line := TclTranslator.GetString(buf, 0, Length(buf), Server.GetReadCharSet(Connection, AData));
      end;

      AUnprocessedBytes := 0;
      isReady := True;
    end;

    Result := TclProcessLineContext.Create(Command, line, isReady);
  except
    Result.Free();
    raise;
  end;
end;

{ TclProcessMultiLineContext }

constructor TclProcessMultiLineContext.Create(ACommand: TclTcpCommandInfo);
begin
  inherited Create(ACommand);
  FData := TStringList.Create();
end;

destructor TclProcessMultiLineContext.Destroy;
begin
  FData.Free();
  inherited Destroy();
end;

{ TclProcessMultiLineHandler }

function TclProcessMultiLineHandler.CheckEof(AData: TStream): Boolean;
var
  len: Int64;
  buf: array[0..4] of Byte;
begin
  Result := False;
  len := AData.Size;

  if (len > 5) then
  begin
    len := 5;
  end;

  if ((len <> 3) and (len <> 5)) then Exit;

  AData.Seek(-len, soEnd);

  AData.Read(buf, len);

  if (len = 5) then
  begin
    Result := (buf[0] = 13) and (buf[1] = 10) and (buf[2] = 46) and (buf[3] = 13) and (buf[4] = 10);
  end else
  if (len = 3) then
  begin
    Result := (buf[0] = 46) and (buf[1] = 13) and (buf[2] = 10);
  end;
end;

function TclProcessMultiLineHandler.ExtractData(AData: TStream; var AUnprocessedBytes: Int64; AMaxDataSize: Int64): TclProcessDataContext;
var
  context: TclProcessMultiLineContext;
  utils: TclStringsUtils;
begin
  context := TclProcessMultiLineContext.Create(Command);
  try
    AUnprocessedBytes := AData.Size;
    if IsMaxDataSize then
    begin
      if (AData.Size > 5) then
      begin
        AUnprocessedBytes := 5;
      end;
    end else
    begin
      if CheckMaxDataSize(AData.Size, AMaxDataSize) then
      begin
        IsMaxDataSize := True;
      end;
    end;

    if (CheckEof(AData)) then
    begin
      if not IsMaxDataSize then
      begin
        AData.Seek(0, soBeginning);

        utils := TclStringsUtils.Create(context.Data, Server.GetReadCharSet(Connection, AData));
        try
          utils.AddTextStream(AData);
        finally
          utils.Free();
        end;

        context.Data.Delete(context.Data.Count - 1);
        RemoveDoubleDot(context.Data);
      end;

      AUnprocessedBytes := 0;
      context.IsReady := True;
    end;

    Result := context;
  except
    context.Free();
    raise;
  end;
end;

procedure TclProcessMultiLineHandler.RemoveDoubleDot(AData: TStrings);
var
  i: Integer;
  s: string;
begin
  for i := 0 to AData.Count - 1 do
  begin
    s := AData[i];
    if ((Length(s) > 0) and (s[1] = '.')) then
    begin
      AData[i] := system.Copy(s, 2, Length(s) - 1);
    end;
  end;
end;

{ TclTcpCommandInfo }

constructor TclTcpCommandInfo.Create(const AName: string; AIsOOB: Boolean);
begin
  inherited Create();
  FName := AName;
  FIsOOB := AIsOOB;
end;

constructor TclTcpCommandInfo.Create(const AName: string);
begin
  inherited Create();
  FName := AName;
  FIsOOB := False;
end;

{ TclProcessFixedBytesHandler }

constructor TclProcessFixedBytesHandler.Create(AServer: TclTcpCommandServer; AHandler: TclProcessDataEvent;
  ACommand: TclTcpCommandInfo; ASize: Int64);
begin
  inherited Create(AServer, AHandler, ACommand);
  FSize := ASize;
end;

function TclProcessFixedBytesHandler.ExtractData(AData: TStream; var AUnprocessedBytes: Int64;
  AMaxDataSize: Int64): TclProcessDataContext;
var
  context: TclProcessMultiLineContext;
  utils: TclStringsUtils;
begin
  context := TclProcessMultiLineContext.Create(Command);
  try
    if IsMaxDataSize then
    begin
      FTotalSize := FTotalSize + AData.Size;
    end else
    begin
      FTotalSize := AData.Size;
    end;
    AUnprocessedBytes := FTotalSize;

    if CheckMaxDataSize(FTotalSize, AMaxDataSize) then
    begin
      IsMaxDataSize := True;
      AUnprocessedBytes := 0;
    end;

    if (FTotalSize >= FSize) then
    begin
      if not IsMaxDataSize then
      begin
        AData.Seek(0, soBeginning);

        utils := TclStringsUtils.Create(context.Data, Server.GetReadCharSet(Connection, AData));
        try
          utils.AddTextStream(AData, False, FSize);
        finally
          utils.Free();
        end;
      end;

      AUnprocessedBytes := 0;
      context.IsReady := True;
      FTotalSize := 0;
    end;

    Result := context;
  except
    context.Free();
    raise;
  end;
end;

{ EclTcpCommandServerError }

constructor EclTcpCommandServerError.Create(const ACommand, AErrorMsg: string; AErrorCode: Integer);
begin
  inherited Create(AErrorMsg, AErrorCode);
  FCommand := ACommand;
  FNeedClose := False;
end;

constructor EclTcpCommandServerError.Create(const ACommand, AErrorMsg: string; AErrorCode: Integer; ANeedClose: Boolean);
begin
  inherited Create(AErrorMsg, AErrorCode);
  FCommand := ACommand;
  FNeedClose := ANeedClose;
end;

{ TclTcpCustomCommandInfo }

procedure TclTcpCustomCommandInfo.Execute(AConnection: TclCommandConnection; AParams: TclTcpCommandParams);
begin
  Server.DoCustomCommand(AConnection, AParams);
end;

{ TclProcessDataContext }

constructor TclProcessDataContext.Create;
begin
  inherited Create();

  FIsReady := False;
end;

{ EclMaxDataSizeError }

constructor EclMaxDataSizeError.Create;
begin
  inherited Create('', MaxDataSizeError, MaxDataSizeErrorCode);
end;

end.
