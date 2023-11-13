{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clHttpRio;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Rio, OPConvert, WebNode,{$IFDEF DEMO} Windows, Forms, clEncoder, clEncryptor, clCertificate, clHttpRequest, clHtmlParser,{$ENDIF}
  WSDLItems, WSDLNode, {$IFDEF DELPHI2010}OpConvertOptions, {$ENDIF}XMLIntf,
{$ELSE}
  System.Classes, System.SysUtils, Soap.Rio, Soap.OPConvert, Soap.WebNode,{$IFDEF DEMO} Winapi.Windows, Vcl.Forms, clEncoder, clEncryptor, clCertificate, clHttpRequest, clHtmlParser,{$ENDIF}
  Soap.WSDLItems, Soap.WSDLNode, Soap.OpConvertOptions, Xml.XMLIntf,
{$ENDIF}
  clHttp, clSoapMessage;

type
  TclHttpRioMessageEvent = procedure (Sender: TObject; AMessage: TclSoapMessage; var Handled: Boolean) of object;

  TclHttpRio = class(TRIO)
  private
    FWSDLLocation: string;
    FWSDLItems: TWSDLItems;
    FWSDLItemDoc: IXMLDocument;
    FWSDLView: TWSDLView;
    FURL: string;

    FUDDIOperator: string;
    FUDDIBindingKey: string;
    FSoapAction: string;

    FOwnHttp: TclHttp;
    FHttp: TclHttp;

    FOwnRequest: TclSoapMessage;
    FRequest: TclSoapMessage;

    FOwnResponse: TclSoapMessage;
    FResponse: TclSoapMessage;

    FUserAgent: string;
    FAllowCaching: Boolean;
    FCharSet: string;
    FOptions: TSOAPConvertOptions;
    FOnSendRequest: TclHttpRioMessageEvent;
    FOnReceiveResponse: TclHttpRioMessageEvent;
    FSign: Boolean;
    FEncrypt: Boolean;
    FSignBeforeEncrypt: Boolean;

    function GetPort: string;
    function GetService: string;
    procedure SetPortValue(const Value: string);
    procedure SetService(const Value: string);
    procedure SetWSDLLocation(const Value: string);
    procedure SetURL(const Value: string);

    function IsWSDL: Boolean;
    function GetWebNode: IWebNode;
    function GetConverter: IOPConvert;
    procedure CreateWSDLItems;
    procedure SetHttp(const Value: TclHttp);
    function GetHttp: TclHttp;
    procedure SetRequest(const Value: TclSoapMessage);
    function GetRequest: TclSoapMessage;
    procedure SetResponse(const Value: TclSoapMessage);
    function GetResponse: TclSoapMessage;
    procedure SecureMessage(AMessage: TclSoapMessage);
    procedure UnsecureMessage(AMessage: TclSoapMessage);
 protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure DoAfterExecute(const MethodName: string; Response: TStream); override;
    procedure DoBeforeExecute(const MethodName: string; Request: TStream); override;

    procedure DoSendRequest(AMessage: TclSoapMessage; var Handled: Boolean); virtual;
    procedure DoReceiveResponse(AMessage: TclSoapMessage; var Handled: Boolean); virtual;

    procedure ClearMembers; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function QueryInterface(const IID: TGUID; out Obj): HResult; override; stdcall;

    property WSDLItems: TWSDLItems read FWSDLItems;
  published
    property WSDLLocation: string read FWSDLLocation  write SetWSDLLocation;
    property Service: string read GetService write SetService;
    property Port: string read GetPort write SetPortValue;
    property URL: string read FURL write SetURL;
    property Options: TSOAPConvertOptions read FOptions write FOptions default [soSendMultiRefObj, soTryAllSchema];

    property HttpClient: TclHttp read FHttp write SetHttp;
    property SoapRequest: TclSoapMessage read FRequest write SetRequest;
    property SoapResponse: TclSoapMessage read FResponse write SetResponse;

    property UserAgent: string read FUserAgent write FUserAgent;
    property CharSet: string read FCharSet write FCharSet;
    property AllowCaching: Boolean read FAllowCaching write FAllowCaching default False;

    property Sign: Boolean read FSign write FSign default False;
    property Encrypt: Boolean read FEncrypt write FEncrypt default False;
    property SignBeforeEncrypt: Boolean read FSignBeforeEncrypt write FSignBeforeEncrypt default True;

    property OnSendRequest: TclHttpRioMessageEvent read FOnSendRequest write FOnSendRequest;
    property OnReceiveResponse: TclHttpRioMessageEvent read FOnReceiveResponse write FOnReceiveResponse;
  end;

resourcestring
  DefaultSoapAgent = 'CleverComponents SOAP 1.0';

implementation

uses
{$IFNDEF DELPHIXE2}
  InvokeRegistry, SOAPHTTPTrans, OPToSOAPDomConv,
{$ELSE}
  Soap.InvokeRegistry, Soap.SOAPHTTPTrans, Soap.OPToSOAPDomConv,
{$ENDIF}
  clSoapHttpWebNode, clStreamLoader;

{ TclHttpRio }

procedure TclHttpRio.CreateWSDLItems;
var
  iitems: IWSDLItems;
  items: TWSDLItems;
begin
  FWSDLItemDoc := nil;
  FWSDLItems := nil;

  items := TWSDLItems.Create(nil);
  iitems := items as IWSDLItems;

  FWSDLItems := TWSDLItems.Create(items, TclStreamLoader.Create(GetHttp()));
  FWSDLItemDoc := FWSDLItems;
  FWSDLView.WSDL := FWSDLItems;
end;

constructor TclHttpRio.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FWSDLView := TWSDLView.Create(nil);

  FUserAgent := DefaultSoapAgent;
  FCharSet := 'utf-8';
  FAllowCaching := False;

  FOptions := [soSendMultiRefObj, soTryAllSchema];

  FSign := False;
  FEncrypt := False;
  FSignBeforeEncrypt := True;
end;

destructor TclHttpRio.Destroy;
begin
  ClearMembers();

  FWSDLItemDoc := nil;
  FWSDLView.Free();

  FreeAndNil(FOwnHttp);
  FreeAndNil(FOwnRequest);
  FreeAndNil(FOwnResponse);

  inherited Destroy();
end;

procedure TclHttpRio.SecureMessage(AMessage: TclSoapMessage);
begin
  if SignBeforeEncrypt then
  begin
    if Sign then
    begin
      AMessage.Sign();
    end;

    if Encrypt then
    begin
      AMessage.Encrypt();
    end;
  end else
  begin
    if Encrypt then
    begin
      AMessage.Encrypt();
    end;

    if Sign then
    begin
      AMessage.Sign();
    end;
  end;
end;

procedure TclHttpRio.UnsecureMessage(AMessage: TclSoapMessage);
begin
  if SignBeforeEncrypt then
  begin
    if AMessage.IsEncrypted then
    begin
      AMessage.Decrypt();
    end;

    if AMessage.IsSigned then
    begin
      AMessage.Verify();
    end;
  end else
  begin
    if AMessage.IsSigned then
    begin
      AMessage.Verify();
    end;

    if AMessage.IsEncrypted then
    begin
      AMessage.Decrypt();
    end;
  end;
end;

procedure TclHttpRio.DoAfterExecute(const MethodName: string; Response: TStream);
var
  stream: TStream;
  handled: Boolean;
begin
  GetResponse().RequestStream := Response;

  handled := False;
  DoReceiveResponse(GetResponse(), handled);

  if not handled then
  begin
    UnsecureMessage(GetResponse());
  end;

  stream := GetResponse().RequestStream;
  try
    Response.Size := 0;
    Response.CopyFrom(stream, 0);
    Response.Position := 0;
  finally
    stream.Free();
  end;

  inherited DoAfterExecute(MethodName, Response);
end;

procedure TclHttpRio.DoBeforeExecute(const MethodName: string; Request: TStream);
var
  stream: TStream;
  handled: Boolean;
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
    if (not IsHttpDemoDisplayed) and (not IsHttpRequestDemoDisplayed)
      and (not IsEncoderDemoDisplayed) and (not IsCertDemoDisplayed)
      and (not IsHtmlDemoDisplayed) and (not IsEncryptorDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpDemoDisplayed := True;
    IsHttpRequestDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsEncryptorDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  GetRequest().RequestStream := Request;

  handled := False;
  DoSendRequest(GetRequest(), handled);

  if not handled then
  begin
    SecureMessage(GetRequest());
  end;

  stream := GetRequest().RequestStream;
  try
    Request.Size := 0;
    Request.CopyFrom(stream, 0);
    Request.Position := 0;
  finally
    stream.Free();
  end;

  inherited DoBeforeExecute(MethodName, Request);
end;

procedure TclHttpRio.DoReceiveResponse(AMessage: TclSoapMessage; var Handled: Boolean);
begin
  if Assigned(OnReceiveResponse) then
  begin
    OnReceiveResponse(Self, AMessage, Handled);
  end;
end;

procedure TclHttpRio.DoSendRequest(AMessage: TclSoapMessage; var Handled: Boolean);
begin
  if Assigned(OnSendRequest) then
  begin
    OnSendRequest(Self, AMessage, Handled);
  end;
end;

function TclHttpRio.GetConverter: IOPConvert;
var
  cn: TOPToSoapDomConvert;
begin
  cn := TOPToSoapDomConvert.Create(Self);
  Result := (cn as IOPConvert);

  if IsWSDL() then
  begin
    cn.WSDLView := FWSDLView;
  end;

  cn.Options := Options;
end;

function TclHttpRio.GetHttp: TclHttp;
begin
  Result := FHttp;
  if (Result = nil) then
  begin
    if (FOwnHttp = nil) then
    begin
      FOwnHttp := TclHttp.Create(nil);
      FOwnHttp.UserAgent := UserAgent;
      FOwnHttp.AllowCaching := AllowCaching;
    end;
    Result := FOwnHttp;
  end;
end;

function TclHttpRio.GetWebNode: IWebNode;
var
  wn: TclSoapHttpWebNode;
begin
  wn := TclSoapHttpWebNode.Create(Self);
  Result := (wn as IWebNode);

  wn.HttpClient := GetHttp();
  wn.SoapMessage := GetRequest();

  if IsWSDL() then
  begin
    wn.WSDLView := FWSDLView;
  end;

  wn.URL := URL;
  wn.SoapAction := FSoapAction;
  wn.UDDIOperator := FUDDIOperator;
  wn.UDDIBindingKey := FUDDIBindingKey;
end;

function TclHttpRio.IsWSDL: Boolean;
begin
  Result := (WSDLLocation <> '');
end;

procedure TclHttpRio.ClearMembers;
begin
  Converter := nil;
  WebNode := nil;
end;

procedure TclHttpRio.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if  (AComponent = FHttp) and (Operation = opRemove) then
  begin
    FHttp := nil;
  end else
  if  (AComponent = FRequest) and (Operation = opRemove) then
  begin
    FRequest := nil;
  end else
  if  (AComponent = FResponse) and (Operation = opRemove) then
  begin
    FResponse := nil;
  end;
end;

function TclHttpRio.GetPort: string;
begin
  Result := FWSDLView.Port;
end;

function TclHttpRio.GetRequest: TclSoapMessage;
begin
  Result := FRequest;
  if (Result = nil) then
  begin
    if (FOwnRequest = nil) then
    begin
      FOwnRequest := TclSoapMessage.Create(nil);
      FOwnRequest.Header.CharSet := CharSet;
    end;
    Result := FOwnRequest;
  end;
end;

function TclHttpRio.GetResponse: TclSoapMessage;
begin
  Result := FResponse;
  if (Result = nil) then
  begin
    if (FOwnResponse = nil) then
    begin
      FOwnResponse := TclSoapMessage.Create(nil);
    end;
    Result := FOwnResponse;
  end;
end;

function TclHttpRio.GetService: string;
begin
  Result := FWSDLView.Service;
end;

function TclHttpRio.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  Result := inherited QueryInterface(IID, Obj);

  if Result = S_OK then
  begin
    if IsEqualGUID(IID, FIID) then
    begin
      FSoapAction := InvRegistry.GetActionURIOfIID(IID);
      if not InvRegistry.GetUDDIInfo(IID, FUDDIOperator, FUDDIBindingKey) then
      begin
        FUDDIOperator := '';
        FUDDIBindingKey := '';
      end;

      WebNode := GetWebNode();
      Converter := GetConverter();
    end;
  end;
end;

procedure TclHttpRio.SetHttp(const Value: TclHttp);
begin
  if (FHttp <> Value) then
  begin
    if (FHttp <> nil) then
    begin
      FHttp.RemoveFreeNotification(Self);
    end;
    FHttp := Value;
    if (FHttp <> nil) then
    begin
      FHttp.FreeNotification(Self);
    end;
  end;
  FreeAndNil(FOwnHttp);
end;

procedure TclHttpRio.SetPortValue(const Value: string);
begin
  FWSDLView.Port := Value;
end;

procedure TclHttpRio.SetRequest(const Value: TclSoapMessage);
begin
  if (FRequest <> Value) then
  begin
    if (FRequest <> nil) then
    begin
      FRequest.RemoveFreeNotification(Self);
    end;
    FRequest := Value;
    if (FRequest <> nil) then
    begin
      FRequest.FreeNotification(Self);
    end;
  end;
  FreeAndNil(FOwnRequest);
end;

procedure TclHttpRio.SetResponse(const Value: TclSoapMessage);
begin
  if (FResponse <> Value) then
  begin
    if (FResponse <> nil) then
    begin
      FResponse.RemoveFreeNotification(Self);
    end;
    FResponse := Value;
    if (FResponse <> nil) then
    begin
      FResponse.FreeNotification(Self);
    end;
  end;
  FreeAndNil(FOwnResponse);
end;

procedure TclHttpRio.SetService(const Value: string);
begin
  FWSDLView.Service := Value;
end;

procedure TclHttpRio.SetURL(const Value: string);
begin
  if (FURL <> Value) then
  begin
    FURL := Value;

    ClearMembers();

    if (FURL <> '') then
    begin
      SetWSDLLocation('');
    end;
  end;
end;

procedure TclHttpRio.SetWSDLLocation(const Value: string);
begin
  if (FWSDLLocation <> Value) then
  begin
    ClearMembers();

    CreateWSDLItems();

    FWSDLLocation := Value;
    FWSDLItems.FileName := Value;
    FWSDLView.Port := '';
    FWSDLView.Service := '';

    if (FWSDLLocation <> '') then
    begin
      SetURL('');
    end;
  end;
end;

end.
