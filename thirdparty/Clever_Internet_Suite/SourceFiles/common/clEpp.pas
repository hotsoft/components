{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clEpp;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, msxml, Windows,{$IFDEF DEMO} Forms, clCertificate,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils, Winapi.msxml, Winapi.Windows,{$IFDEF DEMO} Vcl.Forms, clCertificate,{$ENDIF}
{$ENDIF}
  clTcpClient, clTcpClientTls, clSocketUtils, clEppUtils;

type
  EclEppError = class(EclTcpClientError);

  TclEppServerInfo = class
  private
    FId: string;
    FDate: string;
    FVersion: string;
    FLanguages: TStrings;
    FObjects: TStrings;
    FExtensions: TStrings;
    FAccess: string;
    FPurpose: string;
    FRecipient: string;
    FRetention: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Parse(const AGreeting: IXMLDomNode);
    procedure Clear;
    
    property Id: string read FId;
    property Date: string read FDate;
    property Version: string read FVersion;
    property Languages: TStrings read FLanguages;
    property Objects: TStrings read FObjects;
    property Extensions: TStrings read FExtensions;
    property Access: string read FAccess;
    property Purpose: string read FPurpose;
    property Recipient: string read FRecipient;
    property Retention: string read FRetention;
  end;

  TclEpp = class(TclTcpClientTls)
  private
    FAuthorized: Boolean;
    FLastTransactionId: Integer;
    FStatusText: string;
    FStatusCode: Integer;
    FPassword: string;
    FUserName: string;

    FServerInfo: TclEppServerInfo;
    FResponse: TStrings;
    FRequest: TStrings;
    FRequestLanguages: TStrings;
    FRequestExtensions: TStrings;
    FRequestObjects: TStrings;

    procedure SetRequestLanguages(const Value: TStrings);
    procedure SetRequestExtensions(const Value: TStrings);
    procedure SetRequestObjects(const Value: TStrings);
    procedure SetPassword(const Value: string);
    procedure SetUserName(const Value: string);
    function GetLastTransactionId: string;

    procedure ReadResponse;
    procedure ParseResponse;
    procedure ParseGreeting;
    function GetRequestTitle: string;
    function GetRequestLanguages: string;
    function GetNextTransactionId: string;
    function GetRequestServices: string;
    procedure SendRequestData;
  protected
    procedure DoDestroy; override;
    procedure InternalOpen; override;
    procedure InternalClose(ANotifyPeer: Boolean); override;
    function GetDefaultPort: Integer; override;
    procedure SendKeepAlive; override;
  public
    constructor Create(AOwner: TComponent); override;

    procedure SendRequest;
    procedure Hello;
    procedure Login;
    procedure Logout;
    procedure SendCommand(const ACommand: string); overload;
    procedure SendCommand(const ACommand: IXMLDomNode); overload;

    property Request: TStrings read FRequest;
    property Response: TStrings read FResponse;
    property StatusCode: Integer read FStatusCode;
    property StatusText: string read FStatusText;
    property LastTransactionId: string read GetLastTransactionId;
    property ServerInfo: TclEppServerInfo read FServerInfo;
    property Authorized: Boolean read FAuthorized;
  published
    property Port default DefaultEppPort;

    property UserName: string read FUserName write SetUserName;
    property Password: string read FPassword write SetPassword;
    property RequestObjects: TStrings read FRequestObjects write SetRequestObjects;
    property RequestExtensions: TStrings read FRequestExtensions write SetRequestExtensions;
    property RequestLanguages: TStrings read FRequestLanguages write SetRequestLanguages;
  end;

resourcestring
  NoRequestObjects = 'No request object is specified';
  ResponseInvalid = 'The response is invalid';
  ObjectInaccessible = 'The object is inaccessible: %s';

const
  NoRequestObjectsCode = -200;
  ResponseInvalidCode = -201;
  ObjectInaccessibleCode = -202;

  ClientTransactionPrefix = 'cltr';

implementation

uses
  clUtils, clSocket, clSspi, clXmlUtils{$IFDEF LOGGER}, clLogger{$ENDIF};

{ TclEpp }

constructor TclEpp.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FServerInfo := TclEppServerInfo.Create();

  FResponse := TStringList.Create();
  FRequest := TStringList.Create();

  FRequestLanguages := TStringList.Create();
  FRequestExtensions := TStringList.Create();
  FRequestObjects := TStringList.Create();

  FRequestLanguages.Add('en');
end;

procedure TclEpp.DoDestroy;
begin
  FRequestObjects.Free();
  FRequestExtensions.Free();
  FRequestLanguages.Free();
  FRequest.Free();
  FResponse.Free();
  FServerInfo.Free();

  inherited DoDestroy();
end;

function TclEpp.GetDefaultPort: Integer;
begin
  Result := DefaultEppPort;
end;

function TclEpp.GetLastTransactionId: string;
begin
  Result := ClientTransactionPrefix + IntToStr(FLastTransactionId);
end;

function TclEpp.GetNextTransactionId: string;
begin
  Inc(FLastTransactionId);
  Result := '<clTRID>' + ClientTransactionPrefix + IntToStr(FLastTransactionId) + '</clTRID>';
end;

function TclEpp.GetRequestLanguages: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to RequestLanguages.Count - 1 do
  begin
    Result := Result + '<lang>' + RequestLanguages[i] + '</lang>';
  end;
end;

function TclEpp.GetRequestServices: string;
var
  i: Integer;
begin
  if (RequestObjects.Count < 1) then
  begin
    raise EclEppError.Create(NoRequestObjects, NoRequestObjectsCode);
  end;

  for i := 0 to RequestObjects.Count - 1 do
  begin
    if (ServerInfo.Objects.IndexOf(RequestObjects[i]) < 0) then
    begin
      raise EclEppError.Create(Format(ObjectInaccessible, [RequestObjects[i]]), ObjectInaccessibleCode);
    end;
  end;

  for i := 0 to RequestExtensions.Count - 1 do
  begin
    if (ServerInfo.Extensions.IndexOf(RequestExtensions[i]) < 0) then
    begin
      raise EclEppError.Create(Format(ObjectInaccessible, [RequestExtensions[i]]), ObjectInaccessibleCode);
    end;
  end;

  Result := '<svcs>';

  for i := 0 to RequestObjects.Count - 1 do
  begin
    Result := Result + '<objURI>' + RequestObjects[i] + '</objURI>';
  end;

  if (RequestExtensions.Count > 0) then
  begin
    Result := Result + '<svcExtension>';
    for i := 0 to RequestExtensions.Count - 1 do
    begin
      Result := Result + '<extURI>' + RequestExtensions[i] + '</extURI>';
    end;

    Result := Result + '</svcExtension>';
  end;

  Result := Result + '</svcs>';
end;

function TclEpp.GetRequestTitle: string;
begin
  Result := '<?xml version="1.0" encoding="UTF-8" standalone="no"?>';
  Result := Result + '<epp xmlns="urn:ietf:params:xml:ns:epp-1.0" ';
  Result := Result + 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ';
  Result := Result + 'xsi:schemaLocation="urn:ietf:params:xml:ns:epp-1.0 epp-1.0.xsd">';
end;

procedure TclEpp.Hello;
begin
  Request.Clear();
  Request.Add(GetRequestTitle());
  Request.Add('<hello/>');
  Request.Add('</epp>');

  SendRequestData();
  ReadResponse();
  ParseGreeting();
end;

procedure TclEpp.InternalClose(ANotifyPeer: Boolean);
begin
  try
    if Active and (not InProgress) then
    begin
      try
        Logout();
      except
        on EclSocketError do ;
        on EclSSPIError do ;
      end;
    end;
  finally
    inherited InternalClose(ANotifyPeer);
  end;
end;

procedure TclEpp.InternalOpen;
begin
  inherited InternalOpen();

  FLastTransactionId := 0;

  ReadResponse();
  ParseGreeting();
end;

procedure TclEpp.Login;
begin
  FAuthorized := False;

  Request.Clear();
  Request.Add(GetRequestTitle());
  Request.Add('<command>');
  Request.Add('<login>');
  Request.Add('<clID>' + UserName + '</clID>');
  Request.Add('<pw>' + Password + '</pw>');
  Request.Add('<options><version>1.0</version>' + GetRequestLanguages() + '</options>');
  Request.Add(GetRequestServices());
  Request.Add('</login>');
  Request.Add(GetNextTransactionId());
  Request.Add('</command>');
  Request.Add('</epp>');

  SendRequest();
  FAuthorized := True;
end;

procedure TclEpp.Logout;
begin
  if (not Authorized) then Exit;

  Request.Clear();
  Request.Add(GetRequestTitle());
  Request.Add('<command>');
  Request.Add('<logout/>');
  Request.Add(GetNextTransactionId());
  Request.Add('</command>');
  Request.Add('</epp>');

  SendRequest();
  FAuthorized := False;
end;

procedure TclEpp.ParseGreeting;
var
  doc: IXMLDomDocument;
  greeting: IXMLDomNode;
begin
  doc := CoDOMDocument.Create();
  doc.loadXML(WideString(Response.Text));
  if (not doc.parsed) then
  begin
    raise EclEppError.Create(doc.parseError.reason, doc.parseError.errorCode);
  end;

  greeting := GetNodeByName(doc.documentElement, 'greeting');
  if (greeting = nil) then
  begin
    raise EclEppError.Create(ResponseInvalid, ResponseInvalidCode);
  end;

  FServerInfo.Parse(greeting);
end;

procedure TclEpp.ParseResponse;
var
  doc: IXMLDomDocument;
  resp, result: IXMLDomNode;
begin
  doc := CoDOMDocument.Create();
  doc.loadXML(WideString(Response.Text));
  if (not doc.parsed) then
  begin
    raise EclEppError.Create(doc.parseError.reason, doc.parseError.errorCode);
  end;

  resp := GetNodeByName(doc.documentElement, 'response');
  if (resp = nil) then
  begin
    raise EclEppError.Create(ResponseInvalid, ResponseInvalidCode);
  end;

  result := GetNodeByName(resp, 'result');
  FStatusCode := StrToIntDef(GetAttributeValue(result, 'code'), 0);
  FStatusText := GetNodeValueByName(result, 'msg');

  if (FStatusCode >= 2000) then
  begin
    raise EclEppError.Create(FStatusText, FStatusCode);
  end;
end;

procedure TclEpp.ReadResponse;
var
  ms: TMemoryStream;
  dataPos: Int64;
  len: DWORD;
  utils: TclStringsUtils;
  encoding: string;
begin
  Response.Clear();

  ms := nil;
  utils := nil;
  try
    ms := TMemoryStream.Create();

    Connection.ReadData(ms);

    ms.Position := 0;
    len := EppReadInt32(ms);
    dataPos := ms.Position;

    while (ms.Size < len) do
    begin
      Connection.ReadData(ms);
    end;

    utils := TclStringsUtils.Create(Response, 'UTF-8');
    utils.BatchSize := BatchSize;

    ms.Position := dataPos;
    utils.LoadStrings(ms);

    encoding := GetXmlCharSet(Response.Text, 'UTF-8');
    if (UpperCase(encoding) <> 'UTF-8') then
    begin
      utils.CharSet := encoding;
      ms.Position := dataPos;
      utils.LoadStrings(ms);
    end;
  finally
    utils.Free();
    ms.Free();
  end;
end;

procedure TclEpp.SendCommand(const ACommand: IXMLDomNode);
begin
  SendCommand(string(ACommand.xml));
end;

procedure TclEpp.SendCommand(const ACommand: string);
begin
  Request.Clear();
  Request.Add(GetRequestTitle());
  Request.Add('<command>');
  Request.Add(ACommand);
  Request.Add(GetNextTransactionId());
  Request.Add('</command>');
  Request.Add('</epp>');

  SendRequest();
end;

procedure TclEpp.SendKeepAlive;
begin
  Hello();
end;

procedure TclEpp.SendRequest;
begin
  SendRequestData();
  ReadResponse();
  ParseResponse();
end;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

procedure TclEpp.SendRequestData;
var
  ms: TMemoryStream;
  utils: TclStringsUtils;
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
    if (not IsDemoDisplayed) and (not IsCertDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsDemoDisplayed := True;
    IsCertDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  ms := nil;
  utils := nil;
  try
    ms := TMemoryStream.Create();
    utils := TclStringsUtils.Create(Request, GetXmlCharSet(Request.Text, 'UTF-8'));

    EppWriteInt32(ms, DWORD(utils.GetStringsSize() + 4));

    utils.SaveStrings(ms);

    ms.Position := 0;
    Connection.WriteData(ms);
  finally
    utils.Free();
    ms.Free();
  end;
end;

procedure TclEpp.SetPassword(const Value: string);
begin
  if (FPassword <> Value) then
  begin
    FPassword := Value;
    Changed();
  end;
end;

procedure TclEpp.SetRequestExtensions(const Value: TStrings);
begin
  FRequestExtensions.Assign(Value);
  Changed();
end;

procedure TclEpp.SetRequestLanguages(const Value: TStrings);
begin
  FRequestLanguages.Assign(Value);
  Changed();
end;

procedure TclEpp.SetRequestObjects(const Value: TStrings);
begin
  FRequestObjects.Assign(Value);
  Changed();
end;

procedure TclEpp.SetUserName(const Value: string);
begin
  if (FUserName <> Value) then
  begin
    FUserName := Value;
    Changed();
  end;
end;

{ TclEppServerInfo }

procedure TclEppServerInfo.Clear;
begin
  FId := '';
  FDate := '';
  FVersion := '';
  FLanguages.Clear();
  FObjects.Clear();
  FExtensions.Clear();
  FAccess := '';
  FPurpose := '';
  FRecipient := '';
  FRetention := '';
end;

constructor TclEppServerInfo.Create;
begin
  inherited Create();
  
  FLanguages := TStringList.Create();
  FObjects := TStringList.Create();
  FExtensions := TStringList.Create();

  Clear();
end;

destructor TclEppServerInfo.Destroy;
begin
  FExtensions.Free();
  FObjects.Free();
  FLanguages.Free();

  inherited Destroy();
end;

procedure TclEppServerInfo.Parse(const AGreeting: IXMLDomNode);
var
  node, statement: IXMLDomNode;
begin
  Clear();

  FId := GetNodeValueByName(AGreeting, 'svID');
  FDate := GetNodeValueByName(AGreeting, 'svDate');

  node := GetNodeByName(AGreeting, 'svcMenu');
  if (node = nil) then
    raise EclEppError.Create(ResponseInvalid, ResponseInvalidCode);

  FVersion := GetNodeValueByName(node, 'version');

  GetNodeValueListByName(node, 'lang', FLanguages);
  GetNodeValueListByName(node, 'objURI', FObjects);

  node := GetNodeByName(node, 'svcExtension');
  if (node <> nil) then
  begin
    GetNodeValueListByName(node, 'extURI', FExtensions);
  end;

  node := GetNodeByName(AGreeting, 'dcp');
  if (node = nil) then
    raise EclEppError.Create(ResponseInvalid, ResponseInvalidCode);

  FAccess := GetNodeXmlByName(node, 'access');
  statement := GetNodeByName(node, 'statement');
  if (statement = nil) then
    raise EclEppError.Create(ResponseInvalid, ResponseInvalidCode);

  FPurpose := GetNodeXmlByName(statement, 'purpose');
  FRecipient := GetNodeXmlByName(statement, 'recipient');
  FRetention := GetNodeXmlByName(statement, 'retention');
end;

end.

