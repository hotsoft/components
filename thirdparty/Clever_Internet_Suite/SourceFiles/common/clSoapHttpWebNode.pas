{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSoapHttpWebNode;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, WebNode, WSDLNode, IntfInfo, SOAPAttachIntf, WSDLIntf,
{$ELSE}
  System.Classes, Soap.WebNode, Soap.WSDLNode, Soap.IntfInfo, Soap.SOAPAttachIntf, Soap.WSDLIntf,
{$ENDIF}
  clWUtils, clHttp, clSoapMessage;

type
  EclSoapHttpError = class(EclHttpError);

  TclSoapHttpWebNode = class(TComponent, IInterface, IWebNode)
  private
    FRefCount: Integer;
    FOwnerIsComponent: Boolean;
    FUDDIBindingKey: WideString;
    FWSDLView: TWSDLView;
    FUDDIOperator: String;
    FSoapAction: string;
    FURL: string;
    FUserSetURL: Boolean;
    FMimeBoundary: TclString;
{$IFDEF DELPHI2010}
    FWebNodeOptions: WebNodeOptions;
{$ENDIF}
    FBindingType: TWebServiceBindingType;
    FHttp: TclHttp;
    FSoapMessage: TclSoapMessage;

    function GetSOAPAction: string;
    procedure SetSOAPAction(const Value: string);
    procedure SetWSDLView(const Value: TWSDLView);
    procedure SetURL(const Value: string);
    function GetSOAPActionHeader: string;
    procedure CheckContentType;
    procedure SetHttp(const Value: TclHttp);
    function GetHttp: TclHttp;
    procedure SetSoapMessage(const Value: TclSoapMessage);
    function GetSoapMessage: TclSoapMessage;
  protected
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;

{$IFDEF DELPHIXE2}
  {$IFDEF DELPHIX101}
    function  GetMimeBoundary: string;
    procedure SetMimeBoundary(const Value: string);
  {$ELSE}
    function  GetMimeBoundary: TclString;
    procedure SetMimeBoundary(const Value: TclString);
  {$ENDIF}
{$ELSE}
    function  GetMimeBoundary: string;
    procedure SetMimeBoundary(Value: string);
{$ENDIF}
{$IFDEF DELPHI2010}
    function  GetWebNodeOptions: WebNodeOptions;
    procedure SetWebNodeOptions(Value: WebNodeOptions);
{$ENDIF}

    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    class function NewInstance: TObject; override;
    procedure AfterConstruction; override;

    procedure BeforeExecute(const IntfMD: TIntfMetaData; const MethMD: TIntfMethEntry;
      MethodIndex: Integer; AttachHandler: IMimeAttachmentHandler);
    procedure Execute(const DataMsg: String; Response: TStream); overload;
    procedure Execute(const Request: TStream; Response: TStream); overload;
    function  Execute(const Request: TStream): TStream; overload;

    property  URL: string read FURL write SetURL;
    property  SoapAction: string read GetSOAPAction write SetSOAPAction;
  published
    property  WSDLView: TWSDLView read FWSDLView write SetWSDLView;

    property  UDDIBindingKey: WideString read FUDDIBindingKey write FUDDIBindingKey;
    property  UDDIOperator: String read FUDDIOperator write FUDDIOperator;

    property HttpClient: TclHttp read FHttp write SetHttp;
    property SoapMessage: TclSoapMessage read FSoapMessage write SetSoapMessage;
  end;

resourcestring
  SoapHttpError = 'Error occurred during the SOAP request';

const
  CantGetURLCode = -500;
  NoWSDLURLCode = -501;
  InvalidContentTypeCode = -502;

implementation

uses
{$IFNDEF DELPHIXE2}
  SysUtils, SyncObjs, Windows, InvokeRegistry, WSDLItems, SOAPConst, UDDIHelper,
{$ELSE}
  System.SysUtils, System.SyncObjs, Soap.InvokeRegistry, Soap.WSDLItems, Soap.SOAPConst, Soap.UDDIHelper,
{$ENDIF}
  clUtils, clTranslator;

{ TclSoapHttpWebNode }

procedure TclSoapHttpWebNode.AfterConstruction;
begin
  inherited AfterConstruction();

  FOwnerIsComponent := Assigned(Owner) and (Owner is TComponent);
{$IFDEF DELPHIXE}
  TInterlocked.Decrement(FRefCount);
{$ELSE}
  InterlockedDecrement(FRefCount);
{$ENDIF}
end;

procedure TclSoapHttpWebNode.BeforeExecute(const IntfMD: TIntfMetaData;
  const MethMD: TIntfMethEntry; MethodIndex: Integer; AttachHandler: IMimeAttachmentHandler);
var
  MethName: InvString;
  Binding: InvString;
  QBinding: IQualifiedName;
{$IFDEF DELPHI2010}
  SOAPVersion: TSOAPVersion;
{$ENDIF}
begin
  if FUserSetURL then
  begin
    MethName := InvRegistry.GetMethExternalName(IntfMD.Info, MethMD.Name);
    FSoapAction := InvRegistry.GetActionURIOfInfo(IntfMD.Info, MethName, MethodIndex);
  end else
  begin
    if (WSDLView <> nil) then
    begin
{$IFDEF DELPHI2010}
      if (ioSOAP12 in InvRegistry.GetIntfInvokeOptions(IntfMD.Info)) then
      begin
        SOAPVersion := svSOAP12
      end else
      begin
        SOAPVersion := svSOAP11;
      end;
{$ENDIF}

      WSDLView.Activate();

      QBinding := WSDLView.WSDL.GetBindingForServicePort(WSDLView.Service, WSDLView.Port);
      if (QBinding <> nil) then
      begin
        Binding := QBinding.Name;
        MethName := InvRegistry.GetMethExternalName(WSDLView.IntfInfo, WSDLView.Operation);

        FSoapAction := WSDLView.WSDL.GetSoapAction(Binding, MethName, 0{$IFDEF DELPHI2010}, SOAPVersion{$ENDIF});
      end;

      if (FSoapAction = '') then
      begin
        InvRegistry.GetActionURIOfInfo(IntfMD.Info, MethName, MethodIndex);
      end;

      FURL := WSDLView.WSDL.GetSoapAddressForServicePort(WSDLView.Service, WSDLView.Port{$IFDEF DELPHI2010}, SOAPVersion{$ENDIF});
      if (FURL = '') then
      begin
        raise EclSoapHttpError.Create(Format(sCantGetURL, [WSDLView.Service, WSDLView.Port, WSDLView.WSDL.FileName]), CantGetURLCode, '');
      end;
    end else
    begin
      raise EclSoapHttpError.Create(sNoWSDLURL, NoWSDLURLCode, '');
    end;
  end;

  if (AttachHandler <> nil) then
  begin
    FBindingType := btMIME;

    FMimeBoundary := TclString(AttachHandler.MIMEBoundary);

    if (SameText(GetSoapMessage().Header.CharSet, 'utf-8')) then
    begin
      AttachHandler.AddSoapHeader(Format(ContentTypeTemplate, [ContentTypeUTF8]));
    end else
    begin
      AttachHandler.AddSoapHeader(Format(ContentTypeTemplate, [ContentTypeNoUTF8]));
    end;
    AttachHandler.AddSoapHeader(GetSOAPActionHeader);
  end else
  begin
    FBindingType := btSOAP;
  end;
end;

procedure TclSoapHttpWebNode.CheckContentType;
begin
  if SameText(GetHttp().ResponseHeader.ContentType, ContentTypeTextPlain) or
     SameText(GetHttp().ResponseHeader.ContentType, STextHtml) then
  begin
    raise EclSoapHttpError.Create(Format(SInvalidContentType, [GetHttp().ResponseHeader.ContentType]), InvalidContentTypeCode, '');
  end;
end;

function TclSoapHttpWebNode.Execute(const Request: TStream): TStream;
begin
  Result := TMemoryStream.Create();
  try
    Execute(Request, Result);
  except
    Result.Free();
    raise;
  end;
end;

procedure TclSoapHttpWebNode.Execute(const Request: TStream; Response: TStream);
var
  canRetry: Boolean;
  lookUpUDDI: Boolean;
  accessPoint: string;
  prevError: Integer;
  respHdr: TStrings;
  oldSilentMode: Boolean;
begin
  lookUpUDDI := False;
  canRetry := (Length(FUDDIBindingKey) > 0) and (Length(FUDDIOperator) > 0);

  prevError := 0;
  oldSilentMode := GetHttp().SilentHTTP;
  respHdr := TStringList.Create();
  try
    GetHttp().SilentHTTP := True;

    while (True) do
    begin
      if (lookUpUDDI and canRetry) then
      begin
        canRetry := False;
        accessPoint := GetBindingkeyAccessPoint(FUDDIOperator, FUDDIBindingKey);

        if (accessPoint = '') or SameText(accessPoint, FURL) then
        begin
          raise EclSoapHttpError.Create(SoapHttpError, prevError, '');
        end;
        SetURL(accessPoint);
      end;

      if (FBindingType = btMIME) then
      begin
        GetSoapMessage().Header.Boundary := GetString_(FMimeBoundary);
      end else
      begin
        GetSoapMessage().Header.SoapAction := SOAPAction;
      end;

      GetHttp().SendRequest('POST', FURL, GetSoapMessage().HeaderSource, Request, respHdr, Response);

      FMimeBoundary := GetTclString(GetHttp().ResponseHeader.Boundary);

      if canRetry and (GetHttp().StatusCode >= 400) then
      begin
        lookUpUDDI := True;
        PrevError := GetHttp().StatusCode;
      end else
      begin
        CheckContentType();
        Break;
      end;
    end;
  finally
    GetHttp().SilentHTTP := oldSilentMode;
    respHdr.Free();
  end;
end;

procedure TclSoapHttpWebNode.Execute(const DataMsg: String; Response: TStream);
var
  stream: TStream;
  buf: TclByteArray;
begin
  Stream := TMemoryStream.Create;
  try
    buf := TclTranslator.GetUtf8Bytes(WideString(DataMsg));//TODO use GetSoapMessage().Header.CharSet
    if (Length(buf) > 0) then
    begin
      stream.Write(buf[0], Length(buf));
    end;

    Execute(stream, Response);
  finally
    stream.Free();
  end;
end;

function TclSoapHttpWebNode.GetHttp: TclHttp;
begin
  Assert(FHttp <> nil);
  Result := FHttp;
end;

function TclSoapHttpWebNode.GetSOAPAction: string;
begin
  if (FSoapAction = '') then
  begin
    Result := '""';
  end else
  begin
    Result := FSoapAction;
  end;
end;

function TclSoapHttpWebNode.GetSOAPActionHeader: string;
begin
  if (SoapAction = '') then
  begin
    Result := SHTTPSoapAction + ':'
  end else
  if (SoapAction = '""') then
  begin
    Result := SHTTPSoapAction + ': ""'
  end else
  begin
    Result := SHTTPSoapAction + ': ' + '"' + SoapAction + '"';
  end;
end;

function TclSoapHttpWebNode.GetSoapMessage: TclSoapMessage;
begin
  Assert(FSoapMessage <> nil);
  Result := FSoapMessage;
end;

{$IFDEF DELPHI2010}
function TclSoapHttpWebNode.GetWebNodeOptions: WebNodeOptions;
begin
  Result := FWebNodeOptions;
end;

procedure TclSoapHttpWebNode.SetWebNodeOptions(Value: WebNodeOptions);
begin
  FWebNodeOptions := Value;
end;
{$ENDIF}

class function TclSoapHttpWebNode.NewInstance: TObject;
begin
  Result := inherited NewInstance();
  TclSoapHttpWebNode(Result).FRefCount := 1;
end;

procedure TclSoapHttpWebNode.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if  (AComponent = FHttp) and (Operation = opRemove) then
  begin
    FHttp := nil;
  end else
  if  (AComponent = FSoapMessage) and (Operation = opRemove) then
  begin
    FSoapMessage := nil;
  end;
end;

procedure TclSoapHttpWebNode.SetHttp(const Value: TclHttp);
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
end;

{$IFDEF DELPHIXE2}
{$IFDEF DELPHIX101}
function TclSoapHttpWebNode.GetMimeBoundary: string;
begin
  Result := string(FMimeBoundary);
end;

procedure TclSoapHttpWebNode.SetMimeBoundary(const Value: string);
begin
  FMimeBoundary := TclString(Value);
end;
{$ELSE}
function TclSoapHttpWebNode.GetMimeBoundary: TclString;
begin
  Result := FMimeBoundary;
end;

procedure TclSoapHttpWebNode.SetMimeBoundary(const Value: TclString);
begin
  FMimeBoundary := Value;
end;
{$ENDIF}
{$ELSE}
function TclSoapHttpWebNode.GetMimeBoundary: string;
begin
  Result := string(FMimeBoundary);
end;

procedure TclSoapHttpWebNode.SetMimeBoundary(Value: string);
begin
  FMimeBoundary := TclString(Value);
end;
{$ENDIF}

procedure TclSoapHttpWebNode.SetSOAPAction(const Value: string);
begin
  FSoapAction := Value;
end;

procedure TclSoapHttpWebNode.SetSoapMessage(const Value: TclSoapMessage);
begin
  if (FSoapMessage <> Value) then
  begin
    if (FSoapMessage <> nil) then
    begin
      FSoapMessage.RemoveFreeNotification(Self);
    end;
    FSoapMessage := Value;
    if (FSoapMessage <> nil) then
    begin
      FSoapMessage.FreeNotification(Self);
    end;
  end;
end;

procedure TclSoapHttpWebNode.SetURL(const Value: string);
begin
  FURL := Value;
  FUserSetURL := (FURL <> '');
  GetHttp().Close();
end;

procedure TclSoapHttpWebNode.SetWSDLView(const Value: TWSDLView);
begin
  FWSDLView := Value;
end;

function TclSoapHttpWebNode._AddRef: Integer;
begin
{$IFDEF DELPHIXE}
  Result := TInterlocked.Increment(FRefCount)
{$ELSE}
  Result := InterlockedIncrement(FRefCount);
{$ENDIF}
end;

function TclSoapHttpWebNode._Release: Integer;
begin
{$IFDEF DELPHIXE}
  Result := TInterlocked.Decrement(FRefCount);
{$ELSE}
  Result := InterlockedDecrement(FRefCount);
{$ENDIF}
  if (Result = 0) and not FOwnerIsComponent then
  begin
    Destroy();
  end;
end;

end.
