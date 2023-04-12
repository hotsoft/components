{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSimpleHttpServer;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,{$IFDEF DEMO} Windows, Forms, clEncoder, clEncryptor, clCertificate, clHtmlParser,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils,{$IFDEF DEMO} Winapi.Windows, Vcl.Forms, clEncoder, clEncryptor, clCertificate, clHtmlParser,{$ENDIF}
{$ENDIF}
  clSocket, clSocketUtils, clHttpRequest, clHttpHeader, clHttpUtils, clUtils, clWUtils, clTranslator;

type
  EclSimpleHttpServerError = class(EclSocketError);

  TclSimpleHttpServer = class(TComponent)
  private
    FConnection: TclTcpServerConnection;
    FListenConnection: TclTcpListenConnection;
    FRequestMethod: string;
    FResponseVersion: TclHttpVersion;
    FRequestHeader: TclHttpRequestHeader;
    FResponseHeader: TclHttpResponseHeader;
    FPort: Integer;
    FRequestUri: string;
    FRequestCookies: TStrings;
    FResponseCookies: TStrings;
    FServerName: string;

    FOnProgress: TclProgressEvent;
    FRequestVersion: TclHttpVersion;
    FKeepConnection: Boolean;
    FCharSet: string;

    function GetActive: Boolean;
    procedure SetResponseCookies(const Value: TStrings);
    procedure SetResponseHeader(const Value: TclHttpResponseHeader);
    procedure DoOnProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
    function ParseHeader(ARawData: TMemoryStream): Boolean;
    procedure ParseRequestLine(const ARequestLine: string);
    procedure ParseCookies(ARequestHeader: TStrings);
    function BuildStatusLine(AStatusCode: Integer; const AStatusText: string): string;
    function BuildKeepConnection: string;
    function GetBatchSize: Integer;
    function GetLocalBinding: string;
    procedure SetBatchSize(const Value: Integer);
    procedure SetLocalBinding(const Value: string);
    function GetSessionTimeOut: Integer;
    procedure SetSessionTimeOut(const Value: Integer);
  protected
    procedure AssignNetworkStream(AConnection: TclTcpServerConnection); virtual;
    procedure DoProgress(ABytesProceed, ATotalBytes: Int64); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Listen(APort: Integer): Integer; overload;
    function Listen(APortBegin, APortEnd: Integer): Integer; overload;

    procedure AcceptRequest(ARequest: TclHttpRequest); overload;
    procedure AcceptRequest(ARequestBody: TStream); overload;
    procedure AcceptRequest(ARequestBody: TStrings); overload;
    function AcceptRequest: string; overload;

    procedure SendResponse(AStatusCode: Integer; const AStatusText: string; ABody: TStream); overload;
    procedure SendResponse(AStatusCode: Integer; const AStatusText: string; ABody: TStrings); overload;
    procedure SendResponse(AStatusCode: Integer; const AStatusText: string; const ABody: string); overload;

    procedure Close;

    procedure Clear; virtual;

    property RequestVersion: TclHttpVersion read FRequestVersion;
    property RequestMethod: string read FRequestMethod;
    property RequestUri: string read FRequestUri;
    property RequestHeader: TclHttpRequestHeader read FRequestHeader;
    property RequestCookies: TStrings read FRequestCookies;

    property Active: Boolean read GetActive;
    property Connection: TclTcpServerConnection read FConnection;
    property Port: Integer read FPort;
  published
    property ResponseVersion: TclHttpVersion read FResponseVersion write FResponseVersion default hvHttp1_1;
    property ResponseHeader: TclHttpResponseHeader read FResponseHeader write SetResponseHeader;
    property ResponseCookies: TStrings read FResponseCookies write SetResponseCookies;
    property KeepConnection: Boolean read FKeepConnection write FKeepConnection default True;

    property ServerName: string read FServerName write FServerName;
    property LocalBinding: string read GetLocalBinding write SetLocalBinding;
    property SessionTimeOut: Integer read GetSessionTimeOut write SetSessionTimeOut default 600000;
    property BatchSize: Integer read GetBatchSize write SetBatchSize default 8192;
    property CharSet: string read FCharSet write FCharSet;

    property OnProgress: TclProgressEvent read FOnProgress write FOnProgress;
  end;

resourcestring
  InvalidHTTPRequestFormat = 'Invalid HTTP request format';

const
  InvalidHTTPRequestFormatCode = -100;

implementation

const
  cHttpVersion: array[TclHttpVersion] of string = ('HTTP/1.0', 'HTTP/1.1');

{ TclSimpleHttpServer }

function TclSimpleHttpServer.AcceptRequest: string;
var
  stream: TStream;
  buffer: TclByteArray;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  stream := TMemoryStream.Create();
  try
    AcceptRequest(stream);

    if (stream.Size > 0) then
    begin
      stream.Position := 0;
      SetLength(buffer, stream.Size);
      stream.Read(buffer[0], stream.Size);

      Result := TclTranslator.GetString(buffer, 0, Length(buffer), CharSet);
    end else
    begin
      Result := '';
    end;
  finally
    stream.Free();
  end;
end;

procedure TclSimpleHttpServer.AssignNetworkStream(AConnection: TclTcpServerConnection);
begin
  AConnection.NetworkStream := TclNetworkStream.Create();
end;

procedure TclSimpleHttpServer.AcceptRequest(ARequestBody: TStrings);
var
  stream: TStream;
begin
  stream := TMemoryStream.Create();
  try
    AcceptRequest(stream);
    stream.Position := 0;

    TclStringsUtils.LoadStrings(stream, ARequestBody, CharSet);
  finally
    stream.Free();
  end;
end;

procedure TclSimpleHttpServer.AcceptRequest(ARequest: TclHttpRequest);
var
  stream: TStream;
begin
  stream := TMemoryStream.Create();
  try
    AcceptRequest(stream);
    stream.Position := 0;

    ARequest.Header := RequestHeader;
    ARequest.RequestStream := stream;
  finally
    stream.Free();
  end;
end;

procedure TclSimpleHttpServer.ParseRequestLine(const ARequestLine: string);
var
  s: string;
begin
  if (WordCount(ARequestLine, [' ']) <> 3) then
  begin
    raise EclSimpleHttpServerError.Create(InvalidHTTPRequestFormat, InvalidHTTPRequestFormatCode);
  end;

  FRequestMethod := ExtractWord(1, ARequestLine, [' ']);
  FRequestUri := ExtractWord(2, ARequestLine, [' ']);

  s := ExtractWord(3, ARequestLine, [' ']);
  if (cHttpVersion[hvHttp1_1] = s) then
  begin
    FRequestVersion := hvHttp1_1;
  end else
  begin
    FRequestVersion := hvHttp1_0;
  end;
end;

procedure TclSimpleHttpServer.ParseCookies(ARequestHeader: TStrings);
var
  i: Integer;
begin
  RequestCookies.Clear();

  for i := 0 to ARequestHeader.Count - 1 do
  begin
    if (system.Pos('Cookie', ARequestHeader[i]) = 1) then
    begin
      RequestCookies.Add(ARequestHeader[i]);
    end;
  end;
end;

function TclSimpleHttpServer.ParseHeader(ARawData: TMemoryStream): Boolean;

  procedure LoadTextFromStream(AStream: TStream; ACount: Integer; AList: TStrings);
  var
    buf: TclByteArray;
  begin
    SetLength(buf, ACount);
    AStream.Read(buf[0], Length(buf));
    AList.Text := TclTranslator.GetString(buf, CharSet);
  end;

const
  EndOfHeader = #13#10#13#10;
  EndOfHeader2 = #10#10;

var
  ind, eofLength: Integer;
  head: TStrings;
begin
  ind := GetBinTextPos(EndOfHeader, ARawData.Memory, 0, ARawData.Size);
  eofLength := Length(EndOfHeader);
  if (ind < 0) then
  begin
    ind := GetBinTextPos(EndOfHeader2, ARawData.Memory, 0, ARawData.Size);
    eofLength := Length(EndOfHeader2);
  end;

  Result := (ind > 0);
  if not Result then Exit;

  head := TStringList.Create();
  try
    LoadTextFromStream(ARawData, ind + eofLength, head);

    if (head.Count > 0) then
    begin
      ParseRequestLine(head[0]);
      head.Delete(0);
    end;

    RequestHeader.ParseHeader(head);
    ParseCookies(head);
  finally
    head.Free();
  end;
end;

procedure TclSimpleHttpServer.AcceptRequest(ARequestBody: TStream);
var
  stream: TMemoryStream;
  cnt: Int64;
begin
{$IFDEF DEMO}
{$IFNDEF STANDALONEDEMO}
  if FindWindow('TAppBuilder', nil) = 0 then
  begin
    MessageBox(0, 'This demo version can be run under Delphi/C++Builder IDE only. ' +
      'Please visit www.clevercomponents.com to purchase your ' +
      'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    ExitProcess(1);
  end else
{$ENDIF}
  begin
{$IFNDEF IDEDEMO}
    IsHttpRequestDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  Clear();

  Listen(FPort);

  if (not Active) then
  begin
    FListenConnection.Accept(Connection);
  end;

  stream := TMemoryStream.Create();
  try
    repeat
      stream.Seek(0, soEnd);
      Connection.ReadData(stream);
      stream.Seek(0, soBeginning);
    until ParseHeader(stream);

    cnt := stream.Size - stream.Position;
    if (cnt > 0) then
    begin
      ARequestBody.CopyFrom(stream, cnt);
    end;

    cnt := StrToInt64Def(RequestHeader.ContentLength, 0);

    while (ARequestBody.Size < cnt) do
    begin
      Connection.ReadData(ARequestBody);
    end;
  finally
    stream.Free();
  end;
end;

procedure TclSimpleHttpServer.Clear;
begin
  FRequestVersion := hvHttp1_0;
  FRequestMethod := '';
  FRequestUri := '';
  FRequestHeader.Clear();
  FRequestCookies.Clear();
end;

procedure TclSimpleHttpServer.Close;
begin
  FListenConnection.Abort();
  FListenConnection.Close(False);

  FConnection.Abort();
  FConnection.Close(True);
end;

constructor TclSimpleHttpServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  StartupSocket();

  FListenConnection := TclTcpListenConnection.Create();
  FListenConnection.NetworkStream := TclNetworkStream.Create();
  FListenConnection.TimeOut := -1;

  FConnection := TclTcpServerConnection.Create();
  FConnection.OnProgress := DoOnProgress;
  AssignNetworkStream(FConnection);

  FRequestHeader := TclHttpRequestHeader.Create();
  FRequestCookies := TStringList.Create();
  FResponseHeader := TclHttpResponseHeader.Create();
  FResponseCookies := TStringList.Create();

  FResponseVersion := hvHttp1_1;
  FKeepConnection := True;

  SessionTimeOut := 600000;
  BatchSize := 8192;
  FServerName := 'Clever Internet Suite HTTP service';
  FCharSet := '';
end;

destructor TclSimpleHttpServer.Destroy;
begin
  FResponseCookies.Free();
  FResponseHeader.Free();
  FRequestCookies.Free();
  FRequestHeader.Free();
  FConnection.Free();
  FListenConnection.Free();

  CleanupSocket();

  inherited Destroy();
end;

procedure TclSimpleHttpServer.DoOnProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
begin
  DoProgress(ABytesProceed, ATotalBytes);
end;

procedure TclSimpleHttpServer.DoProgress(ABytesProceed, ATotalBytes: Int64);
begin
  if Assigned(OnProgress) then
  begin
    OnProgress(Self, ABytesProceed, ATotalBytes);
  end;
end;

function TclSimpleHttpServer.GetActive: Boolean;
begin
  Result := Connection.Active;
end;

function TclSimpleHttpServer.GetBatchSize: Integer;
begin
  Result := Connection.BatchSize;
end;

function TclSimpleHttpServer.GetLocalBinding: string;
begin
  Result := Connection.LocalBinding;
end;

function TclSimpleHttpServer.GetSessionTimeOut: Integer;
begin
  Result := Connection.TimeOut;
end;

function TclSimpleHttpServer.Listen(APortBegin, APortEnd: Integer): Integer;
begin
  if (FListenConnection.Active) then
  begin
    Result := FPort;
    Exit;
  end;

  FPort := FListenConnection.Listen(APortBegin, APortEnd);
  Result := FPort;
end;

function TclSimpleHttpServer.Listen(APort: Integer): Integer;
begin
  if (FListenConnection.Active) then
  begin
    Result := FPort;
    Exit;
  end;

  FPort := FListenConnection.Listen(APort);
  Result := FPort;
end;

procedure TclSimpleHttpServer.SendResponse(AStatusCode: Integer; const AStatusText: string; ABody: TStrings);
var
  stream: TStream;
begin
  stream := TMemoryStream.Create();
  try
    TclStringsUtils.SaveStrings(ABody, stream, CharSet);
    stream.Position := 0;
    SendResponse(AStatusCode, AStatusText, stream);
  finally
    stream.Free();
  end;
end;

procedure TclSimpleHttpServer.SendResponse(AStatusCode: Integer; const AStatusText, ABody: string);
var
  stream: TStream;
  buffer: TclByteArray;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  stream := TMemoryStream.Create();
  try
    if (ABody <> '') then
    begin
      buffer := TclTranslator.GetBytes(ABody, CharSet);
      stream.WriteBuffer(buffer[0], Length(buffer));
      stream.Position := 0;
    end;

    SendResponse(AStatusCode, AStatusText, stream);
  finally
    stream.Free();
  end;
end;

function TclSimpleHttpServer.BuildStatusLine(AStatusCode: Integer; const AStatusText: string): string;
begin
  Result := cHttpVersion[ResponseVersion] + ' ' + IntToStr(AStatusCode) + ' ' + AStatusText;
end;

function TclSimpleHttpServer.BuildKeepConnection: string;
begin
  Result := '';

  case ResponseVersion of
    hvHttp1_0:
      begin
        if (KeepConnection) then
        begin
          Result := 'Keep-Alive';
        end;
      end;
    hvHttp1_1:
      begin
        if (not KeepConnection) then
        begin
          Result := 'close';
        end;
      end;
  end;
end;

procedure TclSimpleHttpServer.SendResponse(AStatusCode: Integer; const AStatusText: string; ABody: TStream);
var
  head: TStrings;
begin
{$IFDEF DEMO}
{$IFNDEF STANDALONEDEMO}
  if FindWindow('TAppBuilder', nil) = 0 then
  begin
    MessageBox(0, 'This demo version can be run under Delphi/C++Builder IDE only. ' +
      'Please visit www.clevercomponents.com to purchase your ' +
      'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    ExitProcess(1);
  end else
{$ENDIF}
  begin
{$IFNDEF IDEDEMO}
    IsHttpRequestDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  head := TStringList.Create();
  try
    head.Add(BuildStatusLine(AStatusCode, AStatusText));

    ResponseHeader.ContentLength := IntToStr(ABody.Size);

    ResponseHeader.Connection := BuildKeepConnection();

    ResponseHeader.Server := ServerName;

    ResponseHeader.AssignHeader(head);

    head.AddStrings(ResponseCookies);

    head.Add('');

    Connection.WriteString(head.Text, 'us-ascii');
    Connection.WriteData(ABody);

    if (not KeepConnection) then
    begin
      Connection.Abort();
      Connection.Close(True);
    end;
  finally
    head.Free();
  end;
end;

procedure TclSimpleHttpServer.SetBatchSize(const Value: Integer);
begin
  Connection.BatchSize := Value;
end;

procedure TclSimpleHttpServer.SetLocalBinding(const Value: string);
begin
  Connection.LocalBinding := Value;
end;

procedure TclSimpleHttpServer.SetResponseCookies(const Value: TStrings);
begin
  FResponseCookies.Assign(Value);
end;

procedure TclSimpleHttpServer.SetResponseHeader(const Value: TclHttpResponseHeader);
begin
  FResponseHeader.Assign(Value);
end;

procedure TclSimpleHttpServer.SetSessionTimeOut(const Value: Integer);
begin
  Connection.TimeOut := Value;
end;

end.
