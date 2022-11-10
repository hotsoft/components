{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clWebDav;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Variants, msxml,{$IFDEF DEMO} Windows, Forms, clEncoder, clEncryptor, clCertificate, clHtmlParser,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils, System.Variants, Winapi.msxml,{$IFDEF DEMO} Winapi.Windows, Vcl.Forms, clEncoder, clEncryptor, clCertificate, clHtmlParser,{$ENDIF}
{$ENDIF}
  clHttp, clHttpRequest, clHttpUtils, clSspiTls, clTranslator;

type
  TclWebDavDepth = (wdDefault, wdResourceOnly, wdResourceAndChildren, wdInfinity);
  TclWebDavLockScope = (wsExclusive, wsShared);

  EclWebDavError = class(EclHttpError);

  TclWebDavNameSpace = class(TCollectionItem)
  private
    FPrefix: string;
    FNameSpace: string;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Prefix: string read FPrefix write FPrefix;
    property NameSpace: string read FNameSpace write FNameSpace;
  end;

  TclWebDavNameSpaceList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TclWebDavNameSpace;
    procedure SetItem(Index: Integer; const Value: TclWebDavNameSpace);
  public
    function Add: TclWebDavNameSpace;
    function ItemByNameSpace(const ANameSpace: string): TclWebDavNameSpace;
    function GetDavPrefix: string;

    property Items[Index: Integer]: TclWebDavNameSpace read GetItem write SetItem; default;
  end;

  TclWebDavProperty = class(TCollectionItem)
  private
    FName: string;
    FValue: string;
    FStatusCode: Integer;
    FDescription: string;
    FUri: string;
    FTag: string;
  public
    property Uri: string read FUri;
    property Name: string read FName;
    property Value: string read FValue;
    property StatusCode: Integer read FStatusCode;
    property Description: string read FDescription;
    property Tag: string read FTag write FTag;
  end;

  TclWebDavPropertyList = class(TCollection)
  private
    FNameSpaces: TclWebDavNameSpaceList;
    function GetItem(Index: Integer): TclWebDavProperty;
    function GetFullName(const AName, ANameSpace: string): string;
  public
    constructor Create(ItemClass: TCollectionItemClass; ANameSpaces: TclWebDavNameSpaceList);
    function Add: TclWebDavProperty;
    function FindItem(const AUri, AName: string; const ANameSpace: string = ''): TclWebDavProperty;

    property Items[Index: Integer]: TclWebDavProperty read GetItem; default;
  end;

  TclWebDavCapabilities = class
  private
    FWebDavClass: string;
    FPublicMethods: TStrings;
    FAllowedMethods: TStrings;
    procedure ParseMethods(AMethods: TStrings; const ASource: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure ParseHeader(AHeader: TStrings);
    procedure Clear;
    
    property WebDavClass: string read FWebDavClass;
    property PublicMethods: TStrings read FPublicMethods;
    property AllowedMethods: TStrings read FAllowedMethods;
  end;

  TclWebDavLock = class(TCollectionItem)
  private
    FStatusCode: Integer;
    FDescription: string;
    FUri: string;
    FTimeOut: string;
    FLockToken: string;
    FLockType: string;
    FOwner: string;
    FLockScope: TclWebDavLockScope;
  public
    property Uri: string read FUri;
    property Owner: string read FOwner;
    property TimeOut: string read FTimeOut;
    property LockScope: TclWebDavLockScope read FLockScope;
    property LockType: string read FLockType;
    property LockToken: string read FLockToken;
    property StatusCode: Integer read FStatusCode;
    property Description: string read FDescription;
  end;

  TclWebDavLockList = class(TCollection)
  private
    function GetItem(Index: Integer): TclWebDavLock;
  public
    function Add: TclWebDavLock;
    function ItemByUri(const AUri: string): TclWebDavLock;

    property Items[Index: Integer]: TclWebDavLock read GetItem; default;
  end;

  TclWebDavPropertyEvent = procedure (Sender: TObject; AProperty: TclWebDavProperty; const AXml: string) of object;

  TclWebDav = class(TclHttp)
  private
    FAvailableProperties: TclWebDavPropertyList;
    FResourceProperties: TclWebDavPropertyList;
    FNameSpaces: TclWebDavNameSpaceList;
    FResourceNameSpaces: TclWebDavNameSpaceList;
    FDepth: TclWebDavDepth;
    FResponse: TStrings;
    FCapabilities: TclWebDavCapabilities;
    FOnGetPropertyValues: TclWebDavPropertyEvent;
    FLockTimeOut: string;
    FLockOwner: string;
    FLockScope: TclWebDavLockScope;
    FActiveLocks: TclWebDavLockList;
    FLockTokens: TStrings;
    FResponseHeader: TStrings;
    FNormalizeXml: Boolean;

    procedure SetDepth(const Value: TclWebDavDepth);
    procedure SetNameSpaces(const Value: TclWebDavNameSpaceList);
    procedure SetLockOwner(const Value: string);
    procedure SetLockTimeOut(const Value: string);
    procedure SetLockScope(const Value: TclWebDavLockScope);
    procedure SetNormalizeXml(const Value: Boolean);

    procedure ParseNameSpaces(ANameSpaces: TclWebDavNameSpaceList; const ARoot: IXMLDomNode);
    procedure ParseProperties(ANameSpaces: TclWebDavNameSpaceList;
      AProperties: TclWebDavPropertyList; const ARoot: IXMLDomNode);
    procedure ParseResources(ANameSpaces: TclWebDavNameSpaceList;
      AProperties: TclWebDavPropertyList; const ARoot: IXMLDomNode);
    procedure ParsePropertyValues(AProperties: TclWebDavPropertyList;
      const ARoot: IXMLDomNode; const AUri: string; AStatusCode: Integer;
      const ADescription: string);
    procedure ParseActiveLocks(ANameSpaces: TclWebDavNameSpaceList; ALocks: TclWebDavLockList; const ARoot: IXMLDomNode);
    function ParseActiveLockValues(ALock: TclWebDavLock; const ARoot: IXMLDomNode): Boolean;
    function ExtractStatusCode(const AStatusLine: string): Integer;
    function ExtractStatusDescription(const ADescription, AStatusLine: string): string;
    function GetResponseXml(ADom: IXMLDomDocument): IXMLDOMNode;
    function GetPropertyNamesQuery(APropertyNames: TStrings): string;
    function GetPropertyValuesQuery(APropertyNames, APropertyValies: TStrings): string;
    function GetXmlHeader: string;
    function GetFullPropertyName(const AName, ADefaultNameSpace: string): string;
    function GetLockTokenHeader(const AUrl: string = ''): string;
    function GetDepthHeader: string;
    function GetNameSpaceString: string;
    procedure CheckMultiResponseError(AProperties: TclWebDavPropertyList); overload;
    procedure CheckMultiResponseError(ALocks: TclWebDavLockList); overload;
    procedure FillDefaultNameSpaces;
    procedure FillDefaultLockTimeOut;
    procedure InternalGetAllProperties(const AUrl: string; AProperties: TclWebDavPropertyList);
    procedure InternalGetProperties(const AUrl, AXml: string);
    procedure InternalMove(const AMethod, ASourceUrl, ADestinationUrl, ALockTokenHeader: string; IsOverwrite: Boolean);
    procedure AssignLockTokenHeader(AExtraFields: TStrings; const AValues: string);
    function CheckXmlResponse: Boolean;
  protected
    procedure InternalPut(const AUrl, AContentType: string; ASource: TStream; AResponseHeader: TStrings; AResponseBody: TStream); override;
    procedure InternalDelete(const AUrl: string; AResponseHeader: TStrings; AResponseBody: TStream); override;
    function GetRedirectMethod(AStatusCode: Integer; const AMethod: string): string; override;
    procedure DoDestroy; override;
    procedure DoGetPropertyValues(AProperty: TclWebDavProperty; const AXml: string); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    
    procedure SendWebDavRequest(const AMethod, AUrl, AXml, AExtraHeader: string); overload;
    procedure SendWebDavRequest(const AMethod, AUrl, AXml: string); overload;
    procedure GetCapabilities(const AUrl: string);
    procedure GetAvailableProperties(const AUrl: string);
    procedure GetAllProperties(const AUrl: string);
    procedure GetProperties(const AUrl: string; const APropertyNames: array of string); overload;
    procedure GetProperties(const AUrl: string; APropertyNames: TStrings); overload;
    function GetProperty(const AUrl: string; const APropertyName: string): string;
    procedure SetProperties(const AUrl: string; const APropertyNames, APropertyValues: array of string); overload;
    procedure SetProperties(const AUrl: string; APropertyNames, APropertyValues: TStrings); overload;
    procedure SetProperty(const AUrl: string; const APropertyName, APropertyValue: string);
    procedure RemoveProperties(const AUrl: string; const APropertyNames: array of string); overload;
    procedure RemoveProperties(const AUrl: string; APropertyNames: TStrings); overload;
    procedure RemoveProperty(const AUrl, APropertyName: string);

    procedure ListDir(const AUrl: string);
    procedure MakeDir(const AUrl: string);
    procedure Copy(const ASourceUrl, ADestinationUrl: string; IsOverwrite: Boolean = True);
    procedure Move(const ASourceUrl, ADestinationUrl: string; IsOverwrite: Boolean = True);

    procedure GetActiveLocks(const AUrl: string);
    function Lock(const AUrl: string): string;
    procedure RefreshLock(const AUrl: string; const ALockToken: string);
    procedure Unlock(const AUrl: string; const ALockToken: string);

    procedure Reset;

    property AvailableProperties: TclWebDavPropertyList read FAvailableProperties;
    property ResourceProperties: TclWebDavPropertyList read FResourceProperties;
    property ResourceNameSpaces: TclWebDavNameSpaceList read FResourceNameSpaces;
    property ActiveLocks: TclWebDavLockList read FActiveLocks;
    property Response: TStrings read FResponse;
    property Capabilities: TclWebDavCapabilities read FCapabilities;
    property LockTokens: TStrings read FLockTokens;
  published
    property LockTimeOut: string read FLockTimeOut write SetLockTimeOut;
    property LockOwner: string read FLockOwner write SetLockOwner;
    property LockScope: TclWebDavLockScope read FLockScope write SetLockScope default wsExclusive;
    property Depth: TclWebDavDepth read FDepth write SetDepth default wdDefault;
    property NameSpaces: TclWebDavNameSpaceList read FNameSpaces write SetNameSpaces;
    property NormalizeXml: Boolean read FNormalizeXml write SetNormalizeXml default False;

    property OnGetPropertyValues: TclWebDavPropertyEvent read FOnGetPropertyValues write FOnGetPropertyValues;
  end;

resourcestring
  NoNameSpaceError = 'Can not find %s namespace';
  PropertySetError = 'The property set is invalid';
  ResponseError = 'Bad server response';
  MultiResponseError = '%s - error occured while processing %s %s';

const
  NoNameSpaceErrorCode = -200;
  ResponseErrorCode = -201;
  PropertySetErrorCode = -202;

implementation

uses
  clStreams, clUtils, clHeaderFieldList, clUriUtils, clXmlUtils, clHttpHeader;

{ TclWebDav }

constructor TclWebDav.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FCapabilities := TclWebDavCapabilities.Create();

  FResponse := TStringList.Create();

  FResourceNameSpaces := TclWebDavNameSpaceList.Create(Self, TclWebDavNameSpace);
  FNameSpaces := TclWebDavNameSpaceList.Create(Self, TclWebDavNameSpace);

  FAvailableProperties := TclWebDavPropertyList.Create(TclWebDavProperty, FResourceNameSpaces);
  FResourceProperties := TclWebDavPropertyList.Create(TclWebDavProperty, FResourceNameSpaces);

  FActiveLocks := TclWebDavLockList.Create(TclWebDavLock);

  FLockTokens := TStringList.Create();
  FResponseHeader := TStringList.Create();

  FDepth := wdDefault;
  FillDefaultNameSpaces();
  FillDefaultLockTimeOut();

  FNormalizeXml := False;

  Reset();
end;

procedure TclWebDav.DoDestroy;
begin
  FResponseHeader.Free();
  FLockTokens.Free();
  FActiveLocks.Free();
  FResourceProperties.Free();
  FAvailableProperties.Free();
  FNameSpaces.Free();
  FResourceNameSpaces.Free();
  FResponse.Free();
  FCapabilities.Free();

  inherited DoDestroy();
end;

procedure TclWebDav.GetAllProperties(const AUrl: string);
begin
  InternalGetAllProperties(AUrl, ResourceProperties);
end;

function TclWebDav.GetResponseXml(ADom: IXMLDomDocument): IXMLDOMNode;
begin
  ADom.validateOnParse := False;
  ADom.loadXML(WideString(Response.Text));
  if(not ADom.parsed) or (ADom.firstChild = nil) or (ADom.firstChild.nextSibling = nil) then
  begin
    raise EclWebDavError.Create(ResponseError, ResponseErrorCode, ADom.parseError.reason);
  end;
  if NormalizeXml then
  begin
    SaveXMLToStrings(Response, ADom);
  end;
  Result := ADom.firstChild.nextSibling;
end;

procedure TclWebDav.GetProperties(const AUrl: string; const APropertyNames: array of string);
var
  i: Integer;
  propList: TStrings;
begin
  propList := TStringList.Create();
  try
    for i := Low(APropertyNames) to High(APropertyNames) do
    begin
      propList.Add(APropertyNames[i]);
    end;

    GetProperties(AUrl, propList);
  finally
    propList.Free();
  end;
end;

function TclWebDav.GetProperty(const AUrl, APropertyName: string): string;
begin
  GetProperties(AUrl, [APropertyName]);
  if (ResourceProperties.Count = 1) then
  begin
    Result := ResourceProperties[0].Value;
  end else
  begin
    Result := '';
  end;
end;

function TclWebDav.GetPropertyNamesQuery(APropertyNames: TStrings): string;
var
  i: Integer;
  ns: string;
begin
  ns := NameSpaces.GetDavPrefix();

  Result := '';
  for i := 0 to APropertyNames.Count - 1 do
  begin
    Result := Result + '<' + GetFullPropertyName(APropertyNames[i], ns) + '/>';
  end;
end;

function TclWebDav.GetPropertyValuesQuery(APropertyNames, APropertyValies: TStrings): string;
var
  i: Integer;
  ns, name: string;
begin
  if (APropertyNames.Count <> APropertyValies.Count) then
  begin
    raise EclWebDavError.Create(PropertySetError, PropertySetErrorCode, '');
  end;
  
  ns := NameSpaces.GetDavPrefix();

  Result := '';
  for i := 0 to APropertyNames.Count - 1 do
  begin
    name := GetFullPropertyName(APropertyNames[i], ns);
    Result := Result + '<' + name + '>' + APropertyValies[i] + '</' + name + '>';
  end;
end;

function TclWebDav.GetFullPropertyName(const AName, ADefaultNameSpace: string): string;
begin
  Result := AName;
  if (system.Pos(':', Result) < 1) then
  begin
    Result := ADefaultNameSpace + ':' + Result;
  end;
end;

procedure TclWebDav.GetProperties(const AUrl: string; APropertyNames: TStrings);
var
  Dom: IXMLDomDocument;
  xml, ns: string;
begin
  xml := GetXmlHeader();
  ns := NameSpaces.GetDavPrefix();

  xml := xml + '<' + ns + ':propfind' + GetNameSpaceString() + '>' +
    '<' + ns + ':prop>' + GetPropertyNamesQuery(APropertyNames) +
    '</' + ns + ':prop>' +
    '</' + ns + ':propfind>';

  InternalGetProperties(AUrl, xml);

  if CheckXmlResponse() then
  begin
    Dom := CoDOMDocument.Create();
    ParseProperties(ResourceNameSpaces, ResourceProperties, GetResponseXml(Dom));
    Dom := nil;
  end;
end;

function TclWebDav.CheckXmlResponse: Boolean;
begin
  Result := (system.Pos('xml', ResponseHeader.ContentType) > 0);
end;

function TclWebDav.GetNameSpaceString: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to NameSpaces.Count - 1 do
  begin
    Result := Result + ' xmlns:' + NameSpaces[i].Prefix + '="' + NameSpaces[i].NameSpace + '"';
  end;
end;

function TclWebDav.GetXmlHeader: string;
begin
  Result := '<?xml version="1.0"' + GetAttributeText(' encoding', CharSet) + '?>';
end;

procedure TclWebDav.GetAvailableProperties(const AUrl: string);
var
  Dom: IXMLDomDocument;
  xml, ns: string;
begin
  xml := GetXmlHeader();
  ns := NameSpaces.GetDavPrefix();

  xml := xml + '<' + ns + ':propfind' + GetNameSpaceString() + '>' +
    '<' + ns + ':propname/>'+
    '</' + ns + ':propfind>';

  InternalGetProperties(AUrl, xml);

  if CheckXmlResponse() then
  begin
    Dom := CoDOMDocument.Create();
    ParseProperties(ResourceNameSpaces, AvailableProperties, GetResponseXml(Dom));
    Dom := nil;
  end;
end;

procedure TclWebDav.SendWebDavRequest(const AMethod, AUrl, AXml, AExtraHeader: string);
var
  req: TclHttpRequest;
  respBody: TStream;
  size: Integer;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}

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

  req := GetRequest();
  if (AXml <> '') then
  begin
    req.Items.Clear();
    req.AddTextData(AXml);
    req.Header.ContentType := 'text/xml';
  end;

  AssignLockTokenHeader(req.Header.ExtraFields, AExtraHeader);

  respBody := nil;
  try
    FResponseHeader.Clear();
    respBody := TMemoryStream.Create();
    SendRequest(AMethod, AUrl, req, FResponseHeader, respBody);

    respBody.Position := 0;
    size := Integer(respBody.Size);
    if (size > 0) then
    begin
      SetLength(buf, size);
      respBody.Read(buf[0], size);
      Response.Text := TclTranslator.GetString(buf, GetResponseCharSet());
    end else
    begin
      Response.Clear();
    end;
  finally
    respBody.Free();

    if (AXml <> '') then
    begin
      req.Items.Clear();
    end;
  end;
end;

procedure TclWebDav.ParseNameSpaces(ANameSpaces: TclWebDavNameSpaceList; const ARoot: IXMLDomNode);
const
  NsAttribute = 'xmlns:';
var
  i: Integer;
  ns: TclWebDavNameSpace;
begin
  if (ARoot.attributes = nil) then Exit;
  for i := 0 to ARoot.attributes.length - 1 do
  begin
    if (system.Pos(NsAttribute, LowerCase(ARoot.attributes.item[i].nodeName)) = 1) then
    begin
      ns := ANameSpaces.Add();
      ns.FPrefix := system.Copy(string(ARoot.attributes.item[i].nodeName), Length(NsAttribute) + 1, 10000);
      ns.FNameSpace := VarToStr(ARoot.attributes.item[i].nodeValue);
    end;
  end;
end;

function TclWebDav.ExtractStatusCode(const AStatusLine: string): Integer;
var
  ind: Integer;
  s: string;
begin
  Result := 0;
  s := Trim(AStatusLine);
  ind := system.Pos(#32, s);
  if(ind > 0) then
  begin
    system.Delete(s, 1, ind);
    s := Trim(s);

    ind := system.Pos(#32, s);
    if(ind > 0) then
    begin
      Result := StrToIntDef(system.Copy(s, 1, ind - 1), 0);
    end;
  end;
end;

function TclWebDav.ExtractStatusDescription(const ADescription, AStatusLine: string): string;
var
  ind: Integer;
  s: string;
begin
  Result := Trim(ADescription);
  if(Result <> '') then Exit;
  
  s := Trim(AStatusLine);
  ind := system.Pos(#32, s);
  if(ind > 0) then
  begin
    system.Delete(s, 1, ind);
    s := Trim(s);

    ind := system.Pos(#32, s);
    if(ind > 0) then
    begin
      Result := Trim(system.Copy(s, ind + 1, 10000));
    end;
  end;
end;

procedure TclWebDav.ParsePropertyValues(AProperties: TclWebDavPropertyList;
  const ARoot: IXMLDomNode; const AUri: string; AStatusCode: Integer;
  const ADescription: string);
var
  prop: TclWebDavProperty;
  list: IXMLDomNodeList;
  node: IXMLDomNode;
begin
  list := ARoot.childNodes;
  if (list <> nil) then
  begin
    node := list.nextNode();
    while (node <> nil) do
    begin
      prop := AProperties.Add();
      prop.FUri := AUri;
      prop.FStatusCode := AStatusCode;
      prop.FDescription := ADescription;

      prop.FName := string(node.nodeName);
      prop.FValue := string(node.text);

      DoGetPropertyValues(prop, string(node.xml));
      node := list.nextNode();
    end;
  end;
end;

procedure TclWebDav.DoGetPropertyValues(AProperty: TclWebDavProperty; const AXml: string);
begin
  if Assigned(OnGetPropertyValues) then
  begin
    OnGetPropertyValues(Self, AProperty, AXml);
  end;
end;

procedure TclWebDav.ParseProperties(ANameSpaces: TclWebDavNameSpaceList;
  AProperties: TclWebDavPropertyList; const ARoot: IXMLDomNode);

  function ParsePropResponse(ANameSpaces: TclWebDavNameSpaceList; AProperties: TclWebDavPropertyList;
    const ARoot: IXMLDomNode): Boolean;
  var
    list: IXMLDomNodeList;
    node: IXMLDomNode;
    uri, descr: string;
    status: Integer;
    res: Boolean;
  begin
    Result := False;
    list := ARoot.childNodes;
    node := list.nextNode;
    while (node <> nil) do
    begin
      ParseNameSpaces(ANameSpaces, node);

      if (node.baseName = 'prop') and (node.namespaceURI = 'DAV:') then
      begin
        if(node.parentNode = nil) or (node.parentNode.parentNode = nil) then
        begin
          raise EclWebDavError.Create(ResponseError, ResponseErrorCode, Response.Text);
        end;

        uri := GetNodeValueByName(node.parentNode.parentNode, 'href', 'DAV:');
        status := ExtractStatusCode(GetNodeValueByName(node.parentNode, 'status', 'DAV:'));
        descr := ExtractStatusDescription(
          GetNodeValueByName(node.parentNode, 'responsedescription', 'DAV:'),
          GetNodeValueByName(node.parentNode, 'status', 'DAV:'));

        ParsePropertyValues(AProperties, node, uri, status, descr);
        Result := True;
      end else
      begin
        res := ParsePropResponse(ANameSpaces, AProperties, node);
        Result := Result or res;
      end;

      node := list.nextNode;
    end;
  end;


  procedure InternalParseProperties(ANameSpaces: TclWebDavNameSpaceList;
    AProperties: TclWebDavPropertyList; const ARoot: IXMLDomNode);
  var
    list: IXMLDomNodeList;
    node: IXMLDomNode;
    uri: string;
    prop: TclWebDavProperty;
  begin
    list := ARoot.childNodes;
    node := list.nextNode;
    while (node <> nil) do
    begin
      ParseNameSpaces(ANameSpaces, node);

      if (not ParsePropResponse(ANameSpaces, AProperties, node)) then
      begin
        if (node.baseName = 'response') then
        begin
          uri := GetNodeValueByName(node, 'href', 'DAV:');
          prop := AProperties.Add();
          prop.FUri := uri;
          prop.FStatusCode := 200;

          DoGetPropertyValues(prop, string(node.xml));
        end;
      end;

      node := list.nextNode;
    end;
  end;

begin
  AProperties.Clear();
  ANameSpaces.Clear();

  ParseNameSpaces(ANameSpaces, ARoot);
  InternalParseProperties(ANameSpaces, AProperties, ARoot);
  CheckMultiResponseError(AProperties);
end;

procedure TclWebDav.ParseActiveLocks(ANameSpaces: TclWebDavNameSpaceList;
  ALocks: TclWebDavLockList; const ARoot: IXMLDomNode);

  procedure InternalParseActiveLocks(ANameSpaces: TclWebDavNameSpaceList;
    ALocks: TclWebDavLockList; const ARoot: IXMLDomNode);
  var
    list: IXMLDomNodeList;
    node: IXMLDomNode;
    lock: TclWebDavLock;
  begin
    list := ARoot.childNodes;
    if (list = nil) then
    begin
      Exit;
    end;

    node := list.nextNode;
    while (node <> nil) do
    begin
      ParseNameSpaces(ANameSpaces, node);

      if (node.baseName = 'prop') and (node.namespaceURI = 'DAV:') then
      begin
        if(node.parentNode = nil) or (node.parentNode.parentNode = nil) then
        begin
          raise EclWebDavError.Create(ResponseError, ResponseErrorCode, Response.Text);
        end;

        lock := ALocks.Add();
        lock.FUri := GetNodeValueByName(node.parentNode.parentNode, 'href', 'DAV:');
        lock.FStatusCode := ExtractStatusCode(GetNodeValueByName(node.parentNode, 'status', 'DAV:'));
        lock.FDescription := ExtractStatusDescription(GetNodeValueByName(node.parentNode, 'responsedescription', 'DAV:'),
          GetNodeValueByName(node.parentNode, 'status', 'DAV:'));

        if not ParseActiveLockValues(lock, node) then
        begin
          lock.Free();
        end;
      end else
      begin
        InternalParseActiveLocks(ANameSpaces, ALocks, node);
      end;

      node := list.nextNode;
    end;
  end;

begin
  ALocks.Clear();
  ANameSpaces.Clear();

  ParseNameSpaces(ANameSpaces, ARoot);
  InternalParseActiveLocks(ANameSpaces, ALocks, ARoot);
  CheckMultiResponseError(ALocks);
end;

function TclWebDav.ParseActiveLockValues(ALock: TclWebDavLock; const ARoot: IXMLDomNode): Boolean;
var
  list: IXMLDomNodeList;
  node, valNode: IXMLDomNode;
begin
  Result := False;
  list := ARoot.childNodes;
  node := list.nextNode;
  while (node <> nil) do
  begin
    if (node.baseName = 'activelock') and (node.namespaceURI = 'DAV:') then
    begin
      Result := True;
      
      ALock.FTimeOut := GetNodeValueByName(node, 'timeout', 'DAV:');

      valNode := GetNodeByName(node, 'locktoken', 'DAV:');
      if (valNode = nil) then
      begin
        raise EclWebDavError.Create(ResponseError, ResponseErrorCode, Response.Text);
      end;
      ALock.FLockToken := GetNodeValueByName(valNode, 'href', 'DAV:');

      valNode := GetNodeByName(node, 'locktype', 'DAV:');
      if (valNode <> nil) and (valNode.firstChild <> nil) then
      begin
        ALock.FLockType := valNode.firstChild.baseName;
      end;

      valNode := GetNodeByName(node, 'owner', 'DAV:');
      if (valNode <> nil) then
      begin
        ALock.FOwner := GetNodeValueByName(valNode, 'href', 'DAV:');
      end;

      valNode := GetNodeByName(node, 'lockscope', 'DAV:');
      if (valNode <> nil) and (valNode.firstChild <> nil) then
      begin
        if (valNode.firstChild.baseName = 'exclusive') then
        begin
          ALock.FLockScope := wsExclusive;
        end else
        if (valNode.firstChild.baseName = 'shared') then
        begin
          ALock.FLockScope := wsShared;
        end;
      end;
    end else
    begin
      Result := ParseActiveLockValues(ALock, node);
    end;
    
    node := list.nextNode;
  end;
end;

procedure TclWebDav.CheckMultiResponseError(AProperties: TclWebDavPropertyList);
var
  i: Integer;
begin
  for i := 0 to AProperties.Count - 1 do
  begin
    if (AProperties[i].StatusCode >= 400) then
    begin
      raise EclWebDavError.Create(
        Format(MultiResponseError, [AProperties[i].Description, AProperties[i].Uri, AProperties[i].Name]),
        AProperties[i].StatusCode, Response.Text);
    end;
  end;
end;

procedure TclWebDav.AssignLockTokenHeader(AExtraFields: TStrings; const AValues: string);
var
  i: Integer;
  fieldList: TclHeaderFieldList;
begin
  fieldList := TclHeaderFieldList.Create();
  try
    fieldList.Parse(0, AExtraFields);

    for i := fieldList.FieldList.Count - 1 downto 0 do
    begin
      if (fieldList.FieldList[i] = 'if') then
      begin
        fieldList.RemoveField(i);
      end;
    end;

    AddTextStr(AExtraFields, Trim(AValues));
  finally
    fieldList.Free();
  end;
end;

procedure TclWebDav.CheckMultiResponseError(ALocks: TclWebDavLockList);
var
  i: Integer;
begin
  for i := 0 to ALocks.Count - 1 do
  begin
    if (ALocks[i].StatusCode >= 400) then
    begin
      raise EclWebDavError.Create(
        Format(MultiResponseError, [ALocks[i].Description, ALocks[i].Uri, ALocks[i].LockToken]),
        ALocks[i].StatusCode, Response.Text);
    end;
  end;
end;

function TclWebDav.GetRedirectMethod(AStatusCode: Integer; const AMethod: string): string;
begin
  if (AStatusCode = 303) then
  begin
    Result := 'GET';
  end else
  begin
    Result := AMethod;
  end;
end;

procedure TclWebDav.Reset;
begin
  FCapabilities.Clear();
  FAvailableProperties.Clear();
  FResourceProperties.Clear();
  FResourceNameSpaces.Clear();
  FActiveLocks.Clear();
  FLockTokens.Clear();
end;

procedure TclWebDav.FillDefaultNameSpaces;
var
  ns: TclWebDavNameSpace;
begin
  ns := NameSpaces.Add();
  ns.Prefix := 'D';
  ns.NameSpace := 'DAV:';
end;

procedure TclWebDav.FillDefaultLockTimeOut;
begin
  FLockTimeOut := 'Infinite, Second-86400';
end;

procedure TclWebDav.SetDepth(const Value: TclWebDavDepth);
begin
  if (FDepth <> Value) then
  begin
    FDepth := Value;
    Changed();
  end;
end;

procedure TclWebDav.SetNameSpaces(const Value: TclWebDavNameSpaceList);
begin
  FNameSpaces.Assign(Value);
end;

procedure TclWebDav.SetNormalizeXml(const Value: Boolean);
begin
  if (FNormalizeXml <> Value) then
  begin
    FNormalizeXml := Value;
    Changed();
  end;
end;

procedure TclWebDav.SendWebDavRequest(const AMethod, AUrl, AXml: string);
begin
  SendWebDavRequest(AMethod, AUrl, AXml, '');
end;

procedure TclWebDav.SetProperties(const AUrl: string; const APropertyNames,
  APropertyValues: array of string);
var
  i: Integer;
  propList, valList: TStrings;
begin
  propList := nil;
  valList := nil;
  try
    propList := TStringList.Create();
    valList := TStringList.Create();

    for i := Low(APropertyNames) to High(APropertyNames) do
    begin
      propList.Add(APropertyNames[i]);
    end;

    for i := Low(APropertyValues) to High(APropertyValues) do
    begin
      valList.Add(APropertyValues[i]);
    end;
    
    SetProperties(AUrl, propList, valList);
  finally
    valList.Free();
    propList.Free();
  end;
end;

procedure TclWebDav.SetProperties(const AUrl: string; APropertyNames,
  APropertyValues: TStrings);
var
  Dom: IXMLDomDocument;
  xml, ns: string;
begin
  xml := GetXmlHeader();
  ns := NameSpaces.GetDavPrefix();

  xml := xml + '<' + ns + ':propertyupdate' + GetNameSpaceString() + '>' +
    '<' + ns + ':set>' +
    '<' + ns + ':prop>' + GetPropertyValuesQuery(APropertyNames, APropertyValues) +
    '</' + ns + ':prop>' +
    '</' + ns + ':set>' +
    '</' + ns + ':propertyupdate>';

  SendWebDavRequest('PROPPATCH', AUrl, xml, GetLockTokenHeader());

  if CheckXmlResponse() then
  begin
    Dom := CoDOMDocument.Create();
    ParseProperties(ResourceNameSpaces, ResourceProperties, GetResponseXml(Dom));
    Dom := nil;
  end;
end;

procedure TclWebDav.SetProperty(const AUrl, APropertyName, APropertyValue: string);
begin
  SetProperties(AUrl, [APropertyName], [APropertyValue]);
end;

function TclWebDav.GetLockTokenHeader(const AUrl: string): string;
var
  i: Integer;
  s: string;
begin
  Result := '';
  s := AUrl;
  if (s <> '') then
  begin
    s := '<' + s + '>';
  end;
  for i := 0 to LockTokens.Count - 1 do
  begin
    Result := Result + 'If: ' + s + '(<' + LockTokens[i] + '>)'#13#10;
  end;
end;

procedure TclWebDav.RemoveProperties(const AUrl: string; const APropertyNames: array of string);
var
  i: Integer;
  propList: TStrings;
begin
  propList := TStringList.Create();
  try
    for i := Low(APropertyNames) to High(APropertyNames) do
    begin
      propList.Add(APropertyNames[i]);
    end;

    RemoveProperties(AUrl, propList);
  finally
    propList.Free();
  end;
end;

procedure TclWebDav.RemoveProperties(const AUrl: string; APropertyNames: TStrings);
var
  Dom: IXMLDomDocument;
  xml, ns: string;
begin
  xml := GetXmlHeader();
  ns := NameSpaces.GetDavPrefix();

  xml := xml + '<' + ns + ':propertyupdate' + GetNameSpaceString() + '>' +
    '<' + ns + ':remove>' +
    '<' + ns + ':prop>' + GetPropertyNamesQuery(APropertyNames) +
    '</' + ns + ':prop>' +
    '</' + ns + ':remove>' +
    '</' + ns + ':propertyupdate>';

  SendWebDavRequest('PROPPATCH', AUrl, xml, GetLockTokenHeader());

  if CheckXmlResponse() then
  begin
    Dom := CoDOMDocument.Create();
    ParseProperties(ResourceNameSpaces, ResourceProperties, GetResponseXml(Dom));
    Dom := nil;
  end;
end;

procedure TclWebDav.RemoveProperty(const AUrl, APropertyName: string);
begin
  RemoveProperties(AUrl, [APropertyName]);
end;

procedure TclWebDav.GetCapabilities(const AUrl: string);
var
  respHdr: TStrings;
begin
  respHdr := TStringList.Create();
  try
    SendRequest('OPTIONS', AUrl, GetRequest(), respHdr, nil);
    FCapabilities.ParseHeader(respHdr);
  finally
    respHdr.Free();
  end;
end;

function TclWebDav.GetDepthHeader: string;
const
  DepthValues: array[TclWebDavDepth] of string = ('', '0', '1', 'infinity');
begin
  if (Depth <> wdDefault) then
  begin
    Result := 'Depth: ' + DepthValues[Depth] + #13#10;
  end else
  begin
    Result := ''; 
  end;
end;

procedure TclWebDav.MakeDir(const AUrl: string);
begin
  SendWebDavRequest('MKCOL', AUrl, '', '');

  ResourceNameSpaces.Clear();
  ResourceProperties.Clear();
end;

procedure TclWebDav.ListDir(const AUrl: string);
var
  i: Integer;
  prop: TclWebDavProperty;
  propList: TclWebDavPropertyList;
  lastUri: string;
begin
  propList := TclWebDavPropertyList.Create(TclWebDavProperty, ResourceNameSpaces);
  try
    InternalGetAllProperties(AUrl, propList);

    ResourceProperties.Clear();
    lastUri := '';
    for i := 0 to propList.Count - 1 do
    begin
      if not SameText(lastUri, propList[i].Uri) then
      begin
        prop := ResourceProperties.Add();

        if (Pos('http', LowerCase(propList[i].Uri)) <> 1) then
        begin
          prop.FUri := TclUrlParser.CombineUrl(propList[i].Uri, AUrl, CharSet);
        end else
        begin
          prop.FUri := propList[i].Uri;
        end;

        prop.FStatusCode := propList[i].StatusCode;
        prop.FDescription := propList[i].Description;
        prop.FName := propList[i].Name;
        prop.FValue := propList[i].Value;

        lastUri := propList[i].Uri;
      end;
    end;
  finally
    propList.Free();
  end;
end;

procedure TclWebDav.ParseResources(ANameSpaces: TclWebDavNameSpaceList;
  AProperties: TclWebDavPropertyList; const ARoot: IXMLDomNode);
var
  list: IXMLDomNodeList;
  node: IXMLDomNode;
  prop: TclWebDavProperty;
begin
  AProperties.Clear();
  ANameSpaces.Clear();

  ParseNameSpaces(ANameSpaces, ARoot);

  list := ARoot.childNodes;
  if (list <> nil) then
  begin
    node := list.nextNode();
    while (node <> nil) do
    begin
      ParseNameSpaces(ANameSpaces, node);

      prop := AProperties.Add();
      prop.FUri := GetNodeValueByName(node, 'href', 'DAV:');
      prop.FStatusCode := ExtractStatusCode(GetNodeValueByName(node, 'status', 'DAV:'));
      prop.FDescription := ExtractStatusDescription(GetNodeValueByName(node, 'responsedescription', 'DAV:'),
        GetNodeValueByName(node, 'status', 'DAV:'));
      node := list.nextNode();
    end;
  end;

  CheckMultiResponseError(AProperties);
end;

procedure TclWebDav.Copy(const ASourceUrl, ADestinationUrl: string; IsOverwrite: Boolean);
begin
  InternalMove('COPY', ASourceUrl, ADestinationUrl, GetLockTokenHeader(ADestinationUrl), IsOverwrite);
end;

procedure TclWebDav.Move(const ASourceUrl, ADestinationUrl: string; IsOverwrite: Boolean);
begin
  InternalMove('MOVE', ASourceUrl, ADestinationUrl, GetLockTokenHeader(), IsOverwrite);
end;

procedure TclWebDav.InternalMove(const AMethod, ASourceUrl, ADestinationUrl, ALockTokenHeader: string; IsOverwrite: Boolean);
var
  Dom: IXMLDomDocument;
  header: string;
begin
  header := 'Destination: ' + ADestinationUrl + #13#10;
  if (not IsOverwrite) then
  begin
    header := header + 'Overwrite: F'#13#10;
  end;

  header := header + Trim(ALockTokenHeader) + #13#10;

  header := header + GetDepthHeader();
  
  SendWebDavRequest(AMethod, ASourceUrl, '', header);

  if (StatusCode = 207) and CheckXmlResponse() then
  begin
    Dom := CoDOMDocument.Create();
    ParseResources(ResourceNameSpaces, ResourceProperties, GetResponseXml(Dom));
    Dom := nil;
  end else
  begin
    ResourceNameSpaces.Clear();
    ResourceProperties.Clear();
  end;
end;

procedure TclWebDav.InternalPut(const AUrl, AContentType: string; ASource: TStream; AResponseHeader: TStrings; AResponseBody: TStream);
var
  req: TclHttpRequest;
begin
  req := GetRequest();
  req.Header.Accept := '';

  if (AContentType <> '') then
  begin
    req.Header.ContentType := AContentType;
  end;

  AssignLockTokenHeader(req.Header.ExtraFields, GetLockTokenHeader());

  SendRequest('PUT', AUrl, req.HeaderSource, ASource, AResponseHeader, AResponseBody);
end;

procedure TclWebDav.SetLockOwner(const Value: string);
begin
  if (FLockOwner <> Value) then
  begin
    FLockOwner := Value;
    Changed();
  end;
end;

procedure TclWebDav.SetLockTimeOut(const Value: string);
begin
  if (FLockTimeOut <> Value) then
  begin
    FLockTimeOut := Value;
    Changed();
  end;
end;

procedure TclWebDav.SetLockScope(const Value: TclWebDavLockScope);
begin
  if (FLockScope <> Value) then
  begin
    FLockScope := Value;
    Changed();
  end;
end;

function TclWebDav.Lock(const AUrl: string): string;
const
  LockScopeStr: array[TclWebDavLockScope] of string = ('exclusive', 'shared');
  
var
  Dom: IXMLDomDocument;
  xml, ns, header: string;
  theLock: TclWebDavLock;
begin
  Result := '';

  xml := GetXmlHeader();
  ns := NameSpaces.GetDavPrefix();

  xml := xml + '<' + ns + ':lockinfo' + GetNameSpaceString() + '>' +
    '<' + ns + ':lockscope>' +
    '<' + ns + ':' + LockScopeStr[LockScope] + '/>' +
    '</' + ns + ':lockscope>' +

    '<' + ns + ':locktype>' +
    '<' + ns + ':write/>' +
    '</' + ns + ':locktype>';

  if (LockOwner <> '') then
  begin
    xml := xml + '<' + ns + ':owner>' +
    '<' + ns + ':href>' + LockOwner +
    '</' + ns + ':href>' +
    '</' + ns + ':owner>';
  end;

  xml := xml + '</' + ns + ':lockinfo>';

  header := '';
  if (LockTimeOut <> '') then
  begin
    header := 'Timeout: ' + LockTimeOut + #13#10;
  end;

  header := header + GetDepthHeader();

  SendWebDavRequest('LOCK', AUrl, xml, header);

  if CheckXmlResponse() then
  begin
    Dom := CoDOMDocument.Create();
    theLock := TclWebDavLock.Create(nil);
    try
      ParseActiveLockValues(theLock, GetResponseXml(Dom));
      Result := theLock.LockToken;
      LockTokens.Add(Result);
    finally
      theLock.Free();
      Dom := nil;
    end;
  end;
end;

procedure TclWebDav.RefreshLock(const AUrl: string; const ALockToken: string);
var
  header: string;
  ind: Integer;
begin
  header := '';
  if (LockTimeOut <> '') then
  begin
    header := 'Timeout: ' + LockTimeOut + #13#10;
  end;

  if (ALockToken <> '') then
  begin
    header := header + 'If: (<' + ALockToken + '>)'#13#10;
  end;

  SendWebDavRequest('LOCK', AUrl, '', header);

  if (ALockToken <> '') then
  begin
    ind := LockTokens.IndexOf(ALockToken);
    if (ind < 0) then
    begin
      LockTokens.Add(ALockToken);
    end;
  end;
end;

procedure TclWebDav.Unlock(const AUrl: string; const ALockToken: string);
var
  ind: Integer;
  header: string;
begin
  header := '';

  if (ALockToken <> '') then
  begin
    header := 'Lock-Token: <' + ALockToken + '>'#13#10;
  end;

  SendWebDavRequest('UNLOCK', AUrl, '', header);

  if (ALockToken <> '') then
  begin
    ind := LockTokens.IndexOf(ALockToken);
    if (ind > -1) then
    begin
      LockTokens.Delete(ind);
    end;
  end;
end;

procedure TclWebDav.GetActiveLocks(const AUrl: string);
var
  Dom: IXMLDomDocument;
  xml, ns: string;
begin
  xml := GetXmlHeader();
  ns := NameSpaces.GetDavPrefix();

  xml := xml + '<' + ns + ':propfind' + GetNameSpaceString() + '>' +
    '<' + ns + ':prop>'+
    '<' + ns + ':lockdiscovery/>'+
    '</' + ns + ':prop>'+
    '</' + ns + ':propfind>';

  InternalGetProperties(AUrl, xml);

  if CheckXmlResponse() then
  begin
    Dom := CoDOMDocument.Create();
    ParseActiveLocks(ResourceNameSpaces, ActiveLocks, GetResponseXml(Dom));
    Dom := nil;
  end;
end;

procedure TclWebDav.InternalDelete(const AUrl: string; AResponseHeader: TStrings; AResponseBody: TStream);
var
  Dom: IXMLDomDocument;
begin
  SendWebDavRequest('DELETE', AUrl, '', GetLockTokenHeader());
  
  if (AResponseHeader <> nil) then
  begin
    AResponseHeader.Assign(FResponseHeader);
  end;

  if (StatusCode = 207) then
  begin
    Dom := CoDOMDocument.Create();
    ParseResources(ResourceNameSpaces, ResourceProperties, GetResponseXml(Dom));
    Dom := nil;
  end else
  begin
    ResourceNameSpaces.Clear();
    ResourceProperties.Clear();
  end;
end;

procedure TclWebDav.InternalGetAllProperties(const AUrl: string;
  AProperties: TclWebDavPropertyList);
var
  Dom: IXMLDomDocument;
  xml, ns: string;
begin
  xml := GetXmlHeader();
  ns := NameSpaces.GetDavPrefix();

  xml := xml + '<' + ns + ':propfind' + GetNameSpaceString() + '>' +
    '<' + ns + ':allprop/>'+
    '</' + ns + ':propfind>';

  InternalGetProperties(AUrl, xml);

  if CheckXmlResponse() then
  begin
    Dom := CoDOMDocument.Create();
    ParseProperties(ResourceNameSpaces, AProperties, GetResponseXml(Dom));
    Dom := nil;
  end;
end;

procedure TclWebDav.InternalGetProperties(const AUrl, AXml: string);
begin
  SendWebDavRequest('PROPFIND', AUrl, AXml, GetDepthHeader());
end;

{ TclWebDavPropertyList }

function TclWebDavPropertyList.GetFullName(const AName, ANameSpace: string): string;
var
  ns: TclWebDavNameSpace;
begin
  Result := AName;
  if (system.Pos(':', Result) < 1) then
  begin
    if (ANameSpace <> '') then
    begin
      ns := FNameSpaces.ItemByNameSpace(ANameSpace);
      if (ns = nil) then
      begin
        raise EclWebDavError.Create(Format(NoNameSpaceError, [ANameSpace]), NoNameSpaceErrorCode, '');
      end;
      Result := ns.Prefix + ':' + Result;
    end else
    begin
      Result := FNameSpaces.GetDavPrefix() + ':' + Result;
    end;
  end;
end;

function TclWebDavPropertyList.Add: TclWebDavProperty;
begin
  Result := TclWebDavProperty(inherited Add());
end;

function TclWebDavPropertyList.GetItem(Index: Integer): TclWebDavProperty;
begin
  Result := TclWebDavProperty(inherited GetItem(Index));
end;

function TclWebDavPropertyList.FindItem(const AUri, AName, ANameSpace: string): TclWebDavProperty;
var
  i: Integer;
  fullName: string;
begin
  fullName := GetFullName(AName, ANameSpace);

  for i := 0 to Count - 1 do
  begin
    if SameText(Items[i].Uri, AUri) and (Items[i].Name = fullName) then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
  Result := nil;
end;

constructor TclWebDavPropertyList.Create(ItemClass: TCollectionItemClass;
  ANameSpaces: TclWebDavNameSpaceList);
begin
  inherited Create(ItemClass);
  FNameSpaces := ANameSpaces;
  Assert(FNameSpaces <> nil);
end;

{ TclWebDavNameSpaceList }

function TclWebDavNameSpaceList.Add: TclWebDavNameSpace;
begin
  Result := TclWebDavNameSpace(inherited Add());
end;

function TclWebDavNameSpaceList.GetDavPrefix: string;
var
  davNS: TclWebDavNameSpace;
begin
  davNS := ItemByNameSpace('DAV:');
  if(davNS = nil) then
  begin
    raise EclWebDavError.Create(Format(NoNameSpaceError, ['DAV:']), NoNameSpaceErrorCode, '');
  end;
  Result := davNS.Prefix;
end;

function TclWebDavNameSpaceList.GetItem(Index: Integer): TclWebDavNameSpace;
begin
  Result := TclWebDavNameSpace(inherited GetItem(Index));
end;

function TclWebDavNameSpaceList.ItemByNameSpace(const ANameSpace: string): TclWebDavNameSpace;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if (Result.NameSpace = ANameSpace) then Exit;
  end;
  Result := nil;
end;

procedure TclWebDavNameSpaceList.SetItem(Index: Integer; const Value: TclWebDavNameSpace);
begin
  inherited SetItem(Index, Value);
end;

{ TclWebDavNameSpace }

procedure TclWebDavNameSpace.Assign(Source: TPersistent);
begin
  if (Source is TclWebDavNameSpace) then
  begin
    Prefix := TclWebDavNameSpace(Source).Prefix;
    NameSpace := TclWebDavNameSpace(Source).NameSpace;
  end else
  begin
    inherited Assign(Source);
  end;
end;

{ TclWebDavCapabilities }

procedure TclWebDavCapabilities.Clear;
begin
  FWebDavClass := '';
  FPublicMethods.Clear();
  FAllowedMethods.Clear();
end;

constructor TclWebDavCapabilities.Create;
begin
  inherited Create();
  FPublicMethods := TStringList.Create();
  FAllowedMethods := TStringList.Create();
end;

destructor TclWebDavCapabilities.Destroy;
begin
  FAllowedMethods.Free();
  FPublicMethods.Free();
  inherited Destroy();
end;

procedure TclWebDavCapabilities.ParseMethods(AMethods: TStrings; const ASource: string);
var
  i: Integer;
begin
  for i := 1 to WordCount(ASource, [',']) do
  begin
    AMethods.Add(Trim(ExtractWord(i, ASource, [','])));
  end;
end;

procedure TclWebDavCapabilities.ParseHeader(AHeader: TStrings);
var
  fieldList: TclHeaderFieldList;
begin
  fieldList := TclHeaderFieldList.Create();
  try
    Clear();

    fieldList.Parse(0, AHeader);
    FWebDavClass := fieldList.GetFieldValue('DAV');

    ParseMethods(FPublicMethods, fieldList.GetFieldValue('Public'));
    ParseMethods(FAllowedMethods, fieldList.GetFieldValue('Allow'));
  finally
    fieldList.Free();
  end;
end;

{ TclWebDavLockList }

function TclWebDavLockList.Add: TclWebDavLock;
begin
  Result := TclWebDavLock(inherited Add());
end;

function TclWebDavLockList.GetItem(Index: Integer): TclWebDavLock;
begin
  Result := TclWebDavLock(inherited GetItem(Index));
end;

function TclWebDavLockList.ItemByUri(const AUri: string): TclWebDavLock;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if SameText(Result.Uri, AUri) then Exit;
  end;
  Result := nil;
end;

end.
