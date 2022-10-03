{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clRss;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  SysUtils, Classes, Variants, msxml, {$IFDEF DEMO} Windows, Forms, clHttpRequest, clEncoder, clCertificate, clHtmlParser,{$ENDIF}
{$ELSE}
  System.SysUtils, System.Classes, System.Variants, Winapi.msxml, {$IFDEF DEMO} Winapi.Windows, Vcl.Forms, clHttpRequest, clEncoder, clCertificate, clHtmlParser,{$ENDIF}
{$ENDIF}
  clXmlUtils, clUtils, clHttp;

type
  TclRssVersion = (rvRss091, rvRss092, rvRss20);

  TclRssTextEncoding = (rtNone, rtUseCData);

  EclRssError = class(Exception);

  EclRssValidateError = class(EclRssError)
  private
    FPropertyName: string;
    FElementName: string;
  public
    constructor Create(const AElementName, APropertyName: string);

    property ElementName: string read FElementName;
    property PropertyName: string read FPropertyName;
  end;

  TclRssValidator = class;
  TclRssXmlPersister = class;

  TclRssSource = class(TPersistent)
  private
    FValue: string;
    FUrl: string;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Value: string read FValue write FValue;
    property Url: string read FUrl write FUrl;
  end;

  TclRssEnclosure = class(TPersistent)
  private
    FValue: string;
    FUrl: string;
    FLength: Int64;
    FEnclosureType: string;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Value: string read FValue write FValue;
    property Url: string read FUrl write FUrl;
    property Length: Int64 read FLength write FLength default 0;
    property EnclosureType: string read FEnclosureType write FEnclosureType;
  end;

  TclRssCategory = class(TPersistent)
  private
    FDomain: string;
    FValue: string;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Value: string read FValue write FValue;
    property Domain: string read FDomain write FDomain;
  end;

  TclRssGuid = class(TPersistent)
  private
    FIsPermaLink: Boolean;
    FValue: string;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property Value: string read FValue write FValue;
    property IsPermaLink: Boolean read FIsPermaLink write FIsPermaLink default True;
  end;

  TclRssItem = class(TCollectionItem)
  private
    FPubDate: TDateTime;
    FAuthor: string;
    FSource: TclRssSource;
    FLink: string;
    FTitle: string;
    FDescription: string;
    FCategory: TclRssCategory;
    FGuid: TclRssGuid;
    FEnclosure: TclRssEnclosure;
    FComments: string;

    procedure SetCategory(const Value: TclRssCategory);
    procedure SetGuid(const Value: TclRssGuid);
    procedure SetSource(const Value: TclRssSource);
    procedure SetEnclosure(const Value: TclRssEnclosure);
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Load(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
    procedure Save(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
    procedure Validate(AValidator: TclRssValidator);
  published
    property Title: string read FTitle write FTitle;
    property Link: string read FLink write FLink;
    property Description: string read FDescription write FDescription;
    property Author: string read FAuthor write FAuthor;
    property Category: TclRssCategory read FCategory write SetCategory;
    property Comments: string read FComments write FComments;
    property Enclosure: TclRssEnclosure read FEnclosure write SetEnclosure;
    property Guid: TclRssGuid read FGuid write SetGuid;
    property PubDate: TDateTime read FPubDate write FPubDate;
    property Source: TclRssSource read FSource write SetSource;
  end;

  TclRssItemList = class(TOwnedCollection)
  protected
    function GetItem(Index: Integer): TclRssItem;
    procedure SetItem(Index: Integer; const Value: TclRssItem);
  public
    function Add: TclRssItem; overload;
    function Add(const ATitle, ALink, ADescription: string): TclRssItem; overload;
    function Insert(Index: Integer): TclRssItem;
    function ItemByTitle(const ATitle: string; AExactMatch: Boolean): TclRssItem;

    procedure Load(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
    procedure Save(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
    procedure Validate(AValidator: TclRssValidator);

    property Items[Index: Integer]: TclRssItem read GetItem write SetItem; default;
  end;

  TclRssCloud = class(TPersistent)
  private
    FPath: string;
    FProtocol: string;
    FDomain: string;
    FRegisterProcedure: string;
    FPort: Integer;
    
    function GetIsEmpty: Boolean;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;

    procedure Load(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
    procedure Save(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
    procedure Validate(AValidator: TclRssValidator);
    procedure Clear;

    property IsEmpty: Boolean read GetIsEmpty;
  published
    property Domain: string read FDomain write FDomain;
    property Port: Integer read FPort write FPort default 0;
    property Path: string read FPath write FPath;
    property RegisterProcedure: string read FRegisterProcedure write FRegisterProcedure;
    property Protocol: string read FProtocol write FProtocol;
  end;

  TclRssImage = class(TPersistent)
  private
    FWidth: Integer;
    FLink: string;
    FTitle: string;
    FDescription: string;
    FUrl: string;
    FHeight: Integer;
    
    function GetIsEmpty: Boolean;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;

    procedure Load(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
    procedure Save(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
    procedure Validate(AValidator: TclRssValidator);
    procedure Clear;

    property IsEmpty: Boolean read GetIsEmpty;
  published
    property Url: string read FUrl write FUrl;
    property Title: string read FTitle write FTitle;
    property Link: string read FLink write FLink;
    property Width: Integer read FWidth write FWidth default 0;
    property Height: Integer read FHeight write FHeight default 0;
    property Description: string read FDescription write FDescription;
  end;

  TclRssTextInput = class(TPersistent)
  private
    FName: string;
    FLink: string;
    FTitle: string;
    FDescription: string;
    
    function GetIsEmpty: Boolean;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;

    procedure Load(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
    procedure Save(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
    procedure Validate(AValidator: TclRssValidator);
    procedure Clear;

    property IsEmpty: Boolean read GetIsEmpty;
  published
    property Title: string read FTitle write FTitle;
    property Description: string read FDescription write FDescription;
    property Name: string read FName write FName;
    property Link: string read FLink write FLink;
  end;

  TclRssChannel = class(TPersistent)
  private
    FPubDate: TDateTime;
    FLanguage: string;
    FGenerator: string;
    FSkipHours: Integer;
    FLink: string;
    FImage: TclRssImage;
    FRating: string;
    FManagingEditor: string;
    FTitle: string;
    FDocs: string;
    FTextInput: TclRssTextInput;
    FDescription: string;
    FSkipDays: Integer;
    FCategory: string;
    FCopyright: string;
    FWebMaster: string;
    FCloud: TclRssCloud;
    FTtl: Integer;
    FLastBuildDate: TDateTime;
    
    procedure SetCloud(const Value: TclRssCloud);
    procedure SetImage(const Value: TclRssImage);
    procedure SetTextInput(const Value: TclRssTextInput);
    function GetIsEmpty: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;

    procedure Load(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
    procedure Save(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
    procedure Validate(AValidator: TclRssValidator);
    procedure Clear;

    property IsEmpty: Boolean read GetIsEmpty;
  published
    property Title: string read FTitle write FTitle;
    property Link: string read FLink write FLink;
    property Description: string read FDescription write FDescription;
    property Language: string read FLanguage write FLanguage;
    property Copyright: string read FCopyright write FCopyright;
    property ManagingEditor: string read FManagingEditor write FManagingEditor;
    property WebMaster: string read FWebMaster write FWebMaster;
    property PubDate: TDateTime read FPubDate write FPubDate;
    property LastBuildDate: TDateTime read FLastBuildDate write FLastBuildDate;
    property Category: string read FCategory write FCategory;
    property Generator: string read FGenerator write FGenerator;
    property Docs: string read FDocs write FDocs;
    property Ttl: Integer read FTtl write FTtl default 0;
    property Rating: string read FRating write FRating;
    property SkipHours: Integer read FSkipHours write FSkipHours default 0;
    property SkipDays: Integer read FSkipDays write FSkipDays default 0;
    
    property Cloud: TclRssCloud read FCloud write SetCloud;
    property Image: TclRssImage read FImage write SetImage;
    property TextInput: TclRssTextInput read FTextInput write SetTextInput;
  end;

  TclRssValidator = class
  public
    function IsUrlValid(const AUrl: string; const AProtocols: array of string): Boolean;
    
    procedure VisitItem(AItem: TclRssItem); virtual; abstract;
    procedure VisitItems(AItemList: TclRssItemList); virtual; abstract;
    procedure VisitCloud(ACloud: TclRssCloud); virtual; abstract;
    procedure VisitImage(AImage: TclRssImage); virtual; abstract;
    procedure VisitTextInput(ATextInput: TclRssTextInput); virtual; abstract;
    procedure VisitChannel(AChannel: TclRssChannel); virtual; abstract;
  end;

  TclRss091Validator = class(TclRssValidator)
  private
    function CheckUrl(const AUrl: string): Boolean;
  public
    procedure VisitItem(AItem: TclRssItem); override;
    procedure VisitItems(AItemList: TclRssItemList); override;
    procedure VisitCloud(ACloud: TclRssCloud); override;
    procedure VisitImage(AImage: TclRssImage); override;
    procedure VisitTextInput(ATextInput: TclRssTextInput); override;
    procedure VisitChannel(AChannel: TclRssChannel); override;
  end;

  TclRss092Validator = class(TclRssValidator)
  protected
    function CheckUrl(const AUrl: string): Boolean; virtual;
  public
    procedure VisitItem(AItem: TclRssItem); override;
    procedure VisitItems(AItemList: TclRssItemList); override;
    procedure VisitCloud(ACloud: TclRssCloud); override;
    procedure VisitImage(AImage: TclRssImage); override;
    procedure VisitTextInput(ATextInput: TclRssTextInput); override;
    procedure VisitChannel(AChannel: TclRssChannel); override;
  end;

  TclRss20Validator = class(TclRss092Validator)
  protected
    function CheckUrl(const AUrl: string): Boolean; override;
  end;

  TclRssXmlPersister = class
  public
    function RssDateToDateTime(const ADateTime: string): TDateTime;
    function DateTimeToRssDate(ADateTime: TDateTime): string;
    function IntToRssValue(AValue: Integer): string;

    procedure VisitItem(AItem: TclRssItem; const ARoot: IXMLDomNode); virtual; abstract;
    procedure VisitItems(AItemList: TclRssItemList; const ARoot: IXMLDomNode); virtual; abstract;
    procedure VisitCloud(ACloud: TclRssCloud; const ARoot: IXMLDomNode); virtual; abstract;
    procedure VisitImage(AImage: TclRssImage; const ARoot: IXMLDomNode); virtual; abstract;
    procedure VisitTextInput(ATextInput: TclRssTextInput; const ARoot: IXMLDomNode); virtual; abstract;
    procedure VisitChannel(AChannel: TclRssChannel; const ARoot: IXMLDomNode); virtual; abstract;
  end;

  TclRssXmlLoader = class(TclRssXmlPersister)
  public
    procedure VisitItem(AItem: TclRssItem; const ARoot: IXMLDomNode); override;
    procedure VisitItems(AItemList: TclRssItemList; const ARoot: IXMLDomNode); override;
    procedure VisitCloud(ACloud: TclRssCloud; const ARoot: IXMLDomNode); override;
    procedure VisitImage(AImage: TclRssImage; const ARoot: IXMLDomNode); override;
    procedure VisitTextInput(ATextInput: TclRssTextInput; const ARoot: IXMLDomNode); override;
    procedure VisitChannel(AChannel: TclRssChannel; const ARoot: IXMLDomNode); override;
  end;

  TclRss091XmlStorer = class(TclRssXmlPersister)
  private
    FEncoding: TclRssTextEncoding;
  public
    constructor Create(AEncoding: TclRssTextEncoding);

    procedure AddTextValue(const ARoot: IXMLDomNode; const AName, AValue: string); virtual;

    procedure VisitItem(AItem: TclRssItem; const ARoot: IXMLDomNode); override;
    procedure VisitItems(AItemList: TclRssItemList; const ARoot: IXMLDomNode); override;
    procedure VisitCloud(ACloud: TclRssCloud; const ARoot: IXMLDomNode); override;
    procedure VisitImage(AImage: TclRssImage; const ARoot: IXMLDomNode); override;
    procedure VisitTextInput(ATextInput: TclRssTextInput; const ARoot: IXMLDomNode); override;
    procedure VisitChannel(AChannel: TclRssChannel; const ARoot: IXMLDomNode); override;

    property Encoding: TclRssTextEncoding read FEncoding;
  end;

  TclRss092XmlStorer = class(TclRss091XmlStorer)
  public
    procedure VisitItem(AItem: TclRssItem; const ARoot: IXMLDomNode); override;
    procedure VisitCloud(ACloud: TclRssCloud; const ARoot: IXMLDomNode); override;
    procedure VisitChannel(AChannel: TclRssChannel; const ARoot: IXMLDomNode); override;
  end;

  TclRss20XmlStorer = class(TclRss092XmlStorer)
  public
    procedure AddTextValue(const ARoot: IXMLDomNode; const AName, AValue: string); override;

    procedure VisitItem(AItem: TclRssItem; const ARoot: IXMLDomNode); override;
    procedure VisitChannel(AChannel: TclRssChannel; const ARoot: IXMLDomNode); override;
  end;
  
  TclRss = class(TComponent)
  private
    FVersion: TclRssVersion;
    FCharSet: string;
    FEncoding: TclRssTextEncoding;
    FItems: TclRssItemList;
    FChannel: TclRssChannel;
    FHttp: TclHttp;
    FOwnHttp: TclHttp;
    
    procedure SetItems(const Value: TclRssItemList);
    procedure SetChannel(const Value: TclRssChannel);
    procedure SetHttp(const Value: TclHttp);

    function GetRssCharSet(const ADom: IXMLDomDocument): string;
    procedure SetRssCharSet(const ADom: IXMLDomDocument; const ACharSet: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    
    function GetRssVersion(const ARss: IXMLDomNode): TclRssVersion; virtual;
    function GetRssVersionStr: string; virtual;
    function CreateValidator: TclRssValidator; virtual;
    function CreateLoader: TclRssXmlPersister; virtual;
    function CreateStorer: TclRssXmlPersister; virtual;

    function GetHttp: TclHttp;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Get(const AXmlUrl: string);
    procedure Put(const AXmlUrl: string);
    procedure Load(AXmlStream: TStream);
    procedure Save(AXmlStream: TStream);
    procedure Validate;
    procedure Clear;
  published
    property Version: TclRssVersion read FVersion write FVersion default rvRss20;
    property CharSet: string read FCharSet write FCharSet;
    property Encoding: TclRssTextEncoding read FEncoding write FEncoding default rtNone;
    property Items: TclRssItemList read FItems write SetItems;
    property Channel: TclRssChannel read FChannel write SetChannel;
    property Http: TclHttp read FHttp write SetHttp;
  end;
 
{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

resourcestring
  cRssFormatError = 'RSS format error';
  cRssValidateErrorMessage = 'RSS data error: <%s> %s';
  
implementation

{ TclRss }

procedure TclRss.Clear;
begin
  Channel.Clear();
  Items.Clear();
end;

constructor TclRss.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FItems := TclRssItemList.Create(Self, TclRssItem);
  FChannel := TclRssChannel.Create();

  FVersion := rvRss20;
end;

function TclRss.CreateLoader: TclRssXmlPersister;
begin
  Result := TclRssXmlLoader.Create();
end;

function TclRss.CreateStorer: TclRssXmlPersister;
begin
  case Version of
    rvRss091: Result := TclRss091XmlStorer.Create(Encoding);
    rvRss092: Result := TclRss092XmlStorer.Create(Encoding);
    rvRss20: Result := TclRss20XmlStorer.Create(Encoding);
  else
    Result := nil;
    Assert(False, 'Non-supported RSS version');
  end;
end;

function TclRss.CreateValidator: TclRssValidator;
begin
  case Version of
    rvRss091: Result := TclRss091Validator.Create();
    rvRss092: Result := TclRss092Validator.Create();
    rvRss20: Result := TclRss20Validator.Create();
  else
    Result := nil;
    Assert(False, 'Non-supported RSS version');
  end;
end;

destructor TclRss.Destroy;
begin
  FOwnHttp.Free();
  FChannel.Free();
  FItems.Free();
  inherited Destroy();
end;

procedure TclRss.Get(const AXmlUrl: string);
var
  http: TclHttp;
  stream: TStream;
begin
  http := GetHttp();

  stream := TMemoryStream.Create();
  try
    http.Get(AXmlUrl, stream);
    stream.Position := 0;
    Load(stream);
  finally
    stream.Free();
  end;
end;

function TclRss.GetHttp: TclHttp;
begin
  Result := Http;
  if (Result = nil) then
  begin
    Result := FOwnHttp;
    if (Result = nil) then
    begin
      FOwnHttp := TclHttp.Create(nil);
      Result := FOwnHttp;
    end;
  end;
end;

function TclRss.GetRssCharSet(const ADom: IXMLDomDocument): string;
begin
  Result := GetXmlCharSet(ADom);
end;

function TclRss.GetRssVersion(const ARss: IXMLDomNode): TclRssVersion;
var
  s: string;
begin
  s := GetAttributeValue(ARss, 'version');

  if ('0.91' = s) then
  begin
    Result := rvRss091;
  end else
  if ('0.92' = s) then
  begin
    Result := rvRss092;
  end else
  begin
    Result := rvRss20;
  end;
end;

function TclRss.GetRssVersionStr: string;
begin
  case Version of
    rvRss091: Result := '0.91';
    rvRss092: Result := '0.92';
    rvRss20: Result := '2.0'
  else
    Result := '';
    Assert(False, 'Non-supported RSS version');
  end;
end;

procedure TclRss.Load(AXmlStream: TStream);
var
  dom: IXMLDomDocument;
  node: IXMLDomNode;
  loader: TclRssXmlPersister;
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
      and (not IsHtmlDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpDemoDisplayed := True;
    IsHttpRequestDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  dom := CoDOMDocument.Create();

  LoadXMLFromStream(AXmlStream, dom);

  node := dom.documentElement;
  if ((node = nil) or (node.nodeName <> 'rss')) then
    raise EclRssError.Create(cRssFormatError);

  Version := GetRssVersion(node);
  CharSet := GetRssCharSet(dom);

  node := GetNodeByName(node, 'channel');
  if (node = nil) then
    raise EclRssError.Create(cRssFormatError);

  loader := CreateLoader();
  try
    Channel.Load(loader, node);
    Items.Load(loader, node);
  finally
    loader.Free();
  end;
end;

procedure TclRss.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) then Exit;
  if (AComponent = FHttp) then
  begin
    FHttp := nil;
  end;
end;

procedure TclRss.Put(const AXmlUrl: string);
var
  http: TclHttp;
  stream: TStream;
begin
  http := GetHttp();

  stream := TMemoryStream.Create();
  try
    Save(stream);
    stream.Position := 0;
    http.Put(AXmlUrl, stream);
  finally
    stream.Free();
  end;
end;

procedure TclRss.Save(AXmlStream: TStream);
var
  dom: IXMLDomDocument;
  rss, node: IXMLDomNode;
  storer: TclRssXmlPersister;
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
      and (not IsHtmlDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpDemoDisplayed := True;
    IsHttpRequestDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  Validate();

  dom := CoDOMDocument.Create();

  rss := dom.createElement('rss');
  dom.appendChild(rss);

  SetAttributeValue(rss, 'version', GetRssVersionStr());
  SetRssCharSet(dom, CharSet);

  node := dom.createElement('channel');
  rss.appendChild(node);

  storer := CreateStorer();
  try
    Channel.Save(storer, node);
    Items.Save(storer, node);
  finally
    storer.Free();
  end;

  if (rtUseCData = Encoding) then
  begin
    SaveXMLToStream(AXmlStream, dom, ['description']);
  end else
  begin
    SaveXMLToStream(AXmlStream, dom);
  end;
end;

procedure TclRss.SetChannel(const Value: TclRssChannel);
begin
  FChannel.Assign(Value);
end;

procedure TclRss.SetHttp(const Value: TclHttp);
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

procedure TclRss.SetItems(const Value: TclRssItemList);
begin
  FItems.Assign(Value);
end;

procedure TclRss.SetRssCharSet(const ADom: IXMLDomDocument; const ACharSet: string);
var
  data: string;
  pi: IXMLDOMProcessingInstruction;
begin
  data := 'version="1.0"';
  if (ACharSet <> '') then
  begin
    data := data + ' encoding="' + ACharSet + '"';
  end;

  pi := ADom.createProcessingInstruction('xml', data);
  if (ADom.documentElement <> nil) then
  begin
    ADom.insertBefore(pi, ADom.documentElement);
  end else
  begin
    ADom.appendChild(pi);
  end;
end;

procedure TclRss.Validate;
var
  validator: TclRssValidator;
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
      and (not IsHtmlDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpDemoDisplayed := True;
    IsHttpRequestDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
    IsCertDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  validator := CreateValidator();
  try
    Channel.Validate(validator);
    Items.Validate(validator);
  finally
    validator.Free();
  end;
end;

{ EclRssValidateError }

constructor EclRssValidateError.Create(const AElementName, APropertyName: string);
begin
  inherited CreateFmt(cRssValidateErrorMessage, [AElementName, APropertyName]);

  FElementName := AElementName;
  FPropertyName := APropertyName;
end;

{ TclRssGuid }

procedure TclRssGuid.Assign(Source: TPersistent);
var
  src: TclRssGuid;
begin
  if (Source is TclRssGuid) then
  begin
    src := (Source as TclRssGuid);
    Value := src.Value;
    IsPermaLink := src.IsPermaLink;
  end else
  begin
    inherited Assign(Source);
  end;
end;

constructor TclRssGuid.Create;
begin
  inherited Create();
  FIsPermaLink := True;
end;

{ TclRssItem }

procedure TclRssItem.Assign(Source: TPersistent);
var
  src: TclRssItem;
begin
  if (Source is TclRssItem) then
  begin
    src := (Source as TclRssItem);

    Title := src.Title;
    Link := src.Link;
    Description := src.Description;
    Author := src.Author;
    Category := src.Category;
    Comments := src.Comments;
    Enclosure := src.Enclosure;
    Guid := src.Guid;
    PubDate := src.PubDate;
    Self.Source := src.Source;
  end else
  begin
    inherited Assign(Source);
  end;
end;

constructor TclRssItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);

  FCategory := TclRssCategory.Create();
  FEnclosure := TclRssEnclosure.Create();
  FGuid := TclRssGuid.Create();
  FSource := TclRssSource.Create();

  FPubDate := 0;
end;

destructor TclRssItem.Destroy;
begin
  FSource.Free();
  FGuid.Free();
  FEnclosure.Free();
  FCategory.Free();

  inherited Destroy();
end;

procedure TclRssItem.Load(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
begin
  APersister.VisitItem(Self, ARoot);
end;

procedure TclRssItem.Save(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
begin
  APersister.VisitItem(Self, ARoot);
end;

procedure TclRssItem.SetCategory(const Value: TclRssCategory);
begin
  FCategory.Assign(Value);
end;

procedure TclRssItem.SetEnclosure(const Value: TclRssEnclosure);
begin
  FEnclosure.Assign(Value);
end;

procedure TclRssItem.SetGuid(const Value: TclRssGuid);
begin
  FGuid.Assign(Value);
end;

procedure TclRssItem.SetSource(const Value: TclRssSource);
begin
  FSource.Assign(Value);
end;

procedure TclRssItem.Validate(AValidator: TclRssValidator);
begin
  AValidator.VisitItem(Self);
end;

{ TclRssCategory }

procedure TclRssCategory.Assign(Source: TPersistent);
var
  src: TclRssCategory;
begin
  if (Source is TclRssCategory) then
  begin
    src := (Source as TclRssCategory);
    Value := src.Value;
    Domain := src.Domain;
  end else
  begin
    inherited Assign(Source);
  end;
end;

{ TclRssEnclosure }

procedure TclRssEnclosure.Assign(Source: TPersistent);
var
  src: TclRssEnclosure;
begin
  if (Source is TclRssEnclosure) then
  begin
    src := (Source as TclRssEnclosure);
    Value := src.Value;
    Url := src.Url;
    Length := src.Length;
    EnclosureType := src.EnclosureType;
  end else
  begin
    inherited Assign(Source);
  end;
end;

{ TclRssSource }

procedure TclRssSource.Assign(Source: TPersistent);
var
  src: TclRssSource;
begin
  if (Source is TclRssSource) then
  begin
    src := (Source as TclRssSource);
    Value := src.Value;
    Url := src.Url;
  end else
  begin
    inherited Assign(Source);
  end;
end;

{ TclRssItemList }

function TclRssItemList.Add(const ATitle, ALink, ADescription: string): TclRssItem;
begin
  Result := Add();
  
  Result.Title := ATitle;
  Result.Link := ALink;
  Result.Description := ADescription;
end;

function TclRssItemList.Add: TclRssItem;
begin
  Result := TclRssItem(inherited Add());
end;

function TclRssItemList.GetItem(Index: Integer): TclRssItem;
begin
  Result := TclRssItem(inherited GetItem(Index));
end;

procedure TclRssItemList.Load(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
begin
  APersister.VisitItems(Self, ARoot);
end;

procedure TclRssItemList.Save(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
begin
  APersister.VisitItems(Self, ARoot);
end;

procedure TclRssItemList.SetItem(Index: Integer; const Value: TclRssItem);
begin
  inherited SetItem(Index, Value);
end;

function TclRssItemList.Insert(Index: Integer): TclRssItem;
begin
  Result := TclRssItem(inherited Insert(Index));
end;

function TclRssItemList.ItemByTitle(const ATitle: string; AExactMatch: Boolean): TclRssItem;
var
  s: string;
  i: Integer;
begin
  s := LowerCase(ATitle);

  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    
    if (AExactMatch) then
    begin
      if (LowerCase(Result.Title) = s) then Exit;
    end else
    begin
      if (Pos(s, LowerCase(Result.Title)) > 0) then Exit;
    end;
  end;

  Result := nil;
end;

procedure TclRssItemList.Validate(AValidator: TclRssValidator);
begin
  AValidator.VisitItems(Self);
end;

{ TclRssCloud }

procedure TclRssCloud.Assign(Source: TPersistent);
var
  src: TclRssCloud;
begin
  if (Source is TclRssCloud) then
  begin
    src := (Source as TclRssCloud);

    Path := src.Path;
    Protocol := src.Protocol;
    Domain := src.Domain;
    RegisterProcedure := src.RegisterProcedure;
    Port := src.Port;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclRssCloud.Clear;
begin
  FDomain := '';
  FPort := 0;
  FPath := '';
  FRegisterProcedure := '';
  FProtocol := '';
end;

constructor TclRssCloud.Create;
begin
  inherited Create();
  Clear();
end;

function TclRssCloud.GetIsEmpty: Boolean;
begin
  Result := (Domain = '') and (Port = 0) and (Path = '') and (RegisterProcedure = '') and (Protocol = '');
end;

procedure TclRssCloud.Load(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
begin
  APersister.VisitCloud(Self, ARoot);
end;

procedure TclRssCloud.Save(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
begin
  APersister.VisitCloud(Self, ARoot);
end;

procedure TclRssCloud.Validate(AValidator: TclRssValidator);
begin
  AValidator.VisitCloud(Self);
end;

{ TclRssValidator }

function TclRssValidator.IsUrlValid(const AUrl: string; const AProtocols: array of string): Boolean;
var
  url: string;
  i: Integer;
begin
  Result := False;
  
  if (AUrl = '') then Exit;

  url := Trim(LowerCase(AUrl));

  for i := Low(AProtocols) to High(AProtocols) do
  begin
    if (Pos(AProtocols[i], url) = 1) then
    begin
      Result := True;
      Exit;
    end;
  end;
end;

{ TclRssXmlPersister }

function TclRssXmlPersister.DateTimeToRssDate(ADateTime: TDateTime): string;
begin
  if (ADateTime = 0) then
  begin
    Result := '';
  end else
  begin
    Result := DateTimeToMimeTime(ADateTime);
  end;
end;

function TclRssXmlPersister.IntToRssValue(AValue: Integer): string;
begin
  if (AValue > 0) then
  begin
    Result := IntToStr(AValue);
  end else
  begin
    Result := '';
  end;
end;

function TclRssXmlPersister.RssDateToDateTime(const ADateTime: string): TDateTime;
begin
  Result := Now();
  if (ADateTime = '') then Exit;
  try
    Result := MimeTimeToDateTime(ADateTime);
  except
  end;
end;

{ TclRssImage }

procedure TclRssImage.Assign(Source: TPersistent);
var
  src: TclRssImage;
begin
  if (Source is TclRssImage) then
  begin
    src := (Source as TclRssImage);

    Width := src.Width;
    Link := src.Link;
    Title := src.Title;
    Description := src.Description;
    Url := src.Url;
    Height := src.Height;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclRssImage.Clear;
begin
  Url := '';
  Title := '';
  Link := '';
  Width := 0;
  Height := 0;
  Description := '';
end;

constructor TclRssImage.Create;
begin
  inherited Create();
  Clear();
end;

function TclRssImage.GetIsEmpty: Boolean;
begin
  Result := (Url = '') and (Title = '') and (Link = '') and (Width = 0) and (Height = 0) and (Description = '');
end;

procedure TclRssImage.Load(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
begin
  APersister.VisitImage(Self, ARoot);
end;

procedure TclRssImage.Save(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
begin
  APersister.VisitImage(Self, ARoot);
end;

procedure TclRssImage.Validate(AValidator: TclRssValidator);
begin
  AValidator.VisitImage(Self);
end;

{ TclRssTextInput }

procedure TclRssTextInput.Assign(Source: TPersistent);
var
  src: TclRssTextInput;
begin
  if (Source is TclRssTextInput) then
  begin
    src := (Source as TclRssTextInput);

    Name := src.Name;
    Link := src.Link;
    Title := src.Title;
    Description := src.Description;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclRssTextInput.Clear;
begin
  Title := '';
  Description := '';
  Name := '';
  Link := '';
end;

constructor TclRssTextInput.Create;
begin
  inherited Create();
  Clear();
end;

function TclRssTextInput.GetIsEmpty: Boolean;
begin
  Result := (Title = '') and (Description = '') and (Name = '') and (Link = '');
end;

procedure TclRssTextInput.Load(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
begin
  APersister.VisitTextInput(Self, ARoot);
end;

procedure TclRssTextInput.Save(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
begin
  APersister.VisitTextInput(Self, ARoot);
end;

procedure TclRssTextInput.Validate(AValidator: TclRssValidator);
begin
  AValidator.VisitTextInput(Self);
end;

{ TclRssChannel }

procedure TclRssChannel.Assign(Source: TPersistent);
var
  src: TclRssChannel;
begin
  if (Source is TclRssChannel) then
  begin
    src := (Source as TclRssChannel);

    PubDate := src.PubDate;
    Language := src.Language;
    Generator := src.Generator;
    SkipHours := src.SkipHours;
    Link := src.Link;
    Image := src.Image;
    Rating := src.Rating;
    ManagingEditor := src.ManagingEditor;
    Title := src.Title;
    Docs := src.Docs;
    TextInput := src.TextInput;
    Description := src.Description;
    SkipDays := src.SkipDays;
    Category := src.Category;
    Copyright := src.Copyright;
    WebMaster := src.WebMaster;
    Cloud := src.Cloud;
    Ttl := src.Ttl;
    LastBuildDate := src.LastBuildDate;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclRssChannel.Clear;
begin
  Title := '';
  Link := '';
  Description := '';
  Language := '';
  Copyright := '';
  ManagingEditor := '';
  WebMaster := '';
  PubDate := 0;
  LastBuildDate := 0;
  Category := '';
  Generator := '';
  Docs := '';
  Ttl := 0;
  Rating := '';
  SkipHours := 0;
  SkipDays := 0;

  Cloud.Clear();
  Image.Clear();
  TextInput.Clear();
end;

constructor TclRssChannel.Create;
begin
  inherited Create();

  FCloud := TclRssCloud.Create();
  FImage := TclRssImage.Create();
  FTextInput := TclRssTextInput.Create();

  Clear();
end;

destructor TclRssChannel.Destroy;
begin
  FTextInput.Free();
  FImage.Free();
  FCloud.Free();

  inherited Destroy();
end;

function TclRssChannel.GetIsEmpty: Boolean;
begin
  Result := (Title = '') and (Link = '') and (Description = '') and (Language = '')
    and (Copyright = '') and (ManagingEditor = '') and (WebMaster = '') and (PubDate = 0)
    and (LastBuildDate = 0) and (Category = '') and (Generator = '') and (Docs = '')
    and (Ttl = 0) and (Rating = '') and (SkipHours = 0) and (SkipDays = 0)
    and Cloud.IsEmpty and Image.IsEmpty and TextInput.IsEmpty;
end;

procedure TclRssChannel.Load(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
begin
  APersister.VisitChannel(Self, ARoot);
end;

procedure TclRssChannel.Save(APersister: TclRssXmlPersister; const ARoot: IXMLDomNode);
begin
  APersister.VisitChannel(Self, ARoot);
end;

procedure TclRssChannel.SetCloud(const Value: TclRssCloud);
begin
  FCloud.Assign(Value);
end;

procedure TclRssChannel.SetImage(const Value: TclRssImage);
begin
  FImage.Assign(Value);
end;

procedure TclRssChannel.SetTextInput(const Value: TclRssTextInput);
begin
  FTextInput.Assign(Value);
end;

procedure TclRssChannel.Validate(AValidator: TclRssValidator);
begin
  AValidator.VisitChannel(Self);
end;

{ TclRss091Validator }

function TclRss091Validator.CheckUrl(const AUrl: string): Boolean;
begin
  Result := IsUrlValid(AUrl, ['http://', 'ftp://']);
end;

procedure TclRss091Validator.VisitChannel(AChannel: TclRssChannel);
begin
  if (AChannel.Title = '') or (Length(AChannel.Title) > 100) then
    raise EclRssValidateError.Create('channel', 'title');

  if (AChannel.Link = '') or (Length(AChannel.Link) > 500) or (not CheckUrl(AChannel.Link)) then
    raise EclRssValidateError.Create('channel', 'link');

  if (AChannel.Description = '') or (Length(AChannel.Description) > 500) then
    raise EclRssValidateError.Create('channel', 'description');

  if (AChannel.Language = '') or (Length(AChannel.Language) > 20) then
    raise EclRssValidateError.Create('channel', 'language');

  if (AChannel.Copyright <> '') then
  begin
    if (Length(AChannel.Copyright) > 100) then
      raise EclRssValidateError.Create('channel', 'copyright');
  end;

  if (AChannel.ManagingEditor <> '') then
  begin
    if (Length(AChannel.ManagingEditor) > 100) then
      raise EclRssValidateError.Create('channel', 'managingEditor');
  end;

  if (AChannel.WebMaster <> '') then
  begin
    if (Length(AChannel.WebMaster) > 100) then
      raise EclRssValidateError.Create('channel', 'webMaster');
  end;

  if (AChannel.Docs <> '') then
  begin
    if (Length(AChannel.Docs) > 500) then
      raise EclRssValidateError.Create('channel', 'docs');
  end;

  if (AChannel.Rating <> '') then
  begin
    if (Length(AChannel.Rating) > 500) then
      raise EclRssValidateError.Create('channel', 'rating');
  end;

  if (AChannel.SkipHours <> 0) then
  begin
    if ((AChannel.SkipHours < 1) or (AChannel.SkipHours > 24)) then
      raise EclRssValidateError.Create('channel', 'skipHours');
  end;

  AChannel.Image.Validate(Self);
  AChannel.TextInput.Validate(Self);
end;

procedure TclRss091Validator.VisitCloud(ACloud: TclRssCloud);
begin
end;

procedure TclRss091Validator.VisitImage(AImage: TclRssImage);
begin
  if (AImage.IsEmpty) then Exit;

  if (AImage.Url = '') or (Length(AImage.Url) > 500) or (not CheckUrl(AImage.Url)) then
    raise EclRssValidateError.Create('image', 'url');

  if (AImage.Title = '') or (Length(AImage.Title) > 100) then
    raise EclRssValidateError.Create('image', 'title');

  if (AImage.Link = '') or (Length(AImage.Link) > 500) or (not CheckUrl(AImage.Link)) then
    raise EclRssValidateError.Create('image', 'url');

  if (AImage.Width <> 0) then
  begin
    if ((AImage.Width < 0) or (AImage.Width > 144)) then
      raise EclRssValidateError.Create('image', 'width');
  end;

  if (AImage.Height <> 0) then
  begin
    if ((AImage.Height < 0) or (AImage.Height > 400)) then
      raise EclRssValidateError.Create('image', 'height');
  end;

  if (AImage.Description <> '') then
  begin
    if (Length(AImage.Description) > 100) then
      raise EclRssValidateError.Create('image', 'description');
  end;
end;

procedure TclRss091Validator.VisitItem(AItem: TclRssItem);
begin
  if (AItem.Title = '') or (Length(AItem.Title) > 100) then
    raise EclRssValidateError.Create('item', 'title');

  if (AItem.Link = '') or (Length(AItem.Link) > 500) or (not CheckUrl(AItem.Link)) then
    raise EclRssValidateError.Create('item', 'link');

  if (AItem.Description <> '') then
  begin
    if (Length(AItem.Description) > 500) then
      raise EclRssValidateError.Create('item', 'description');
  end;
end;

procedure TclRss091Validator.VisitItems(AItemList: TclRssItemList);
var
  i: Integer;
begin
  if (AItemList.Count > 15) then
    raise EclRssValidateError.Create('items', 'count');

  for i := 0 to AItemList.Count - 1 do
  begin
    AItemList[i].Validate(Self);
  end;
end;

procedure TclRss091Validator.VisitTextInput(ATextInput: TclRssTextInput);
begin
  if (ATextInput.IsEmpty) then Exit;

  if (ATextInput.Title = '') or (Length(ATextInput.Title) > 100) then
    raise EclRssValidateError.Create('textInput', 'title');

  if (ATextInput.Description = '') or (Length(ATextInput.Description) > 500) then
    raise EclRssValidateError.Create('textInput', 'description');

  if (ATextInput.Name = '') or (Length(ATextInput.Name) > 20) then
    raise EclRssValidateError.Create('textInput', 'name');

  if (ATextInput.Link = '') or (Length(ATextInput.Link) > 500) or (not CheckUrl(ATextInput.Link)) then
    raise EclRssValidateError.Create('textInput', 'link');
end;

{ TclRss092Validator }

function TclRss092Validator.CheckUrl(const AUrl: string): Boolean;
begin
  Result := IsUrlValid(AUrl, ['http://', 'ftp://']);
end;

procedure TclRss092Validator.VisitChannel(AChannel: TclRssChannel);
begin
  if (AChannel.Title = '') then
    raise EclRssValidateError.Create('channel', 'title');

  if (AChannel.Link = '') or (not CheckUrl(AChannel.Link)) then
    raise EclRssValidateError.Create('channel', 'link');

  if (AChannel.Description = '') then
    raise EclRssValidateError.Create('channel', 'description');

  if (AChannel.SkipHours <> 0) then
  begin
    if ((AChannel.SkipHours < 1) or (AChannel.SkipHours > 24)) then
      raise EclRssValidateError.Create('channel', 'skipHours');
  end;

  AChannel.Cloud.Validate(Self);
  AChannel.Image.Validate(Self);
  AChannel.TextInput.Validate(Self);
end;

procedure TclRss092Validator.VisitCloud(ACloud: TclRssCloud);
begin
  if (ACloud.IsEmpty) then Exit;

  if (ACloud.Domain = '') then
    raise EclRssValidateError.Create('cloud', 'domain');

  if (ACloud.Port = 0) then
    raise EclRssValidateError.Create('cloud', 'port');

  if (ACloud.Path = '') then
    raise EclRssValidateError.Create('cloud', 'path');

  if (ACloud.RegisterProcedure = '') then
    raise EclRssValidateError.Create('cloud', 'registerProcedure');

  if (ACloud.Protocol = '') then
    raise EclRssValidateError.Create('cloud', 'protocol');
end;

procedure TclRss092Validator.VisitImage(AImage: TclRssImage);
begin
  if (AImage.IsEmpty) then Exit;

  if (AImage.Url = '') or (not CheckUrl(AImage.Url)) then
    raise EclRssValidateError.Create('image', 'url');

  if (AImage.Title = '') then
    raise EclRssValidateError.Create('image', 'title');

  if (AImage.Link = '') or (not CheckUrl(AImage.Link)) then
    raise EclRssValidateError.Create('image', 'url');

  if (AImage.Width <> 0) then
  begin
    if ((AImage.Width < 0) or (AImage.Width > 144)) then
      raise EclRssValidateError.Create('image', 'width');
  end;

  if (AImage.Height <> 0) then
  begin
    if ((AImage.Height < 0) or (AImage.Height > 400)) then
      raise EclRssValidateError.Create('image', 'height');
  end;
end;

procedure TclRss092Validator.VisitItem(AItem: TclRssItem);
begin
  if (AItem.Title = '') and (AItem.Description = '') then
    raise EclRssValidateError.Create('item', 'title');
end;

procedure TclRss092Validator.VisitItems(AItemList: TclRssItemList);
var
  i: Integer;
begin
  for i := 0 to AItemList.Count - 1 do
  begin
    AItemList[i].Validate(Self);
  end;
end;

procedure TclRss092Validator.VisitTextInput(ATextInput: TclRssTextInput);
begin
  if (ATextInput.IsEmpty) then Exit;

  if (ATextInput.Title = '') then
    raise EclRssValidateError.Create('textInput', 'title');

  if (ATextInput.Description = '') then
    raise EclRssValidateError.Create('textInput', 'description');

  if (ATextInput.Name = '') then
    raise EclRssValidateError.Create('textInput', 'name');

  if (ATextInput.Link = '') or (not CheckUrl(ATextInput.Link)) then
    raise EclRssValidateError.Create('textInput', 'link');
end;

{ TclRss20Validator }

function TclRss20Validator.CheckUrl(const AUrl: string): Boolean;
begin
  Result := IsUrlValid(AUrl, ['http://', 'ftp://', 'https://', 'news://']);
end;

{ TclRssXmlLoader }

procedure TclRssXmlLoader.VisitChannel(AChannel: TclRssChannel; const ARoot: IXMLDomNode);
var
  node: IXMLDomNode;
begin
  AChannel.Clear();

  AChannel.Title := GetNodeValueByName(ARoot, 'title');
  AChannel.Link := GetNodeValueByName(ARoot, 'link');
  AChannel.Description := GetNodeValueByName(ARoot, 'description');
  AChannel.Language := GetNodeValueByName(ARoot, 'language');
  AChannel.Copyright := GetNodeValueByName(ARoot, 'copyright');
  AChannel.ManagingEditor := GetNodeValueByName(ARoot, 'managingEditor');
  AChannel.WebMaster := GetNodeValueByName(ARoot, 'webMaster');

  AChannel.PubDate := RssDateToDateTime(GetNodeValueByName(ARoot, 'pubDate'));
  AChannel.LastBuildDate := RssDateToDateTime(GetNodeValueByName(ARoot, 'lastBuildDate'));

  AChannel.Category := GetNodeValueByName(ARoot, 'category');
  AChannel.Generator := GetNodeValueByName(ARoot, 'generator');
  AChannel.Docs := GetNodeValueByName(ARoot, 'docs');
  AChannel.Ttl := StrToIntDef(GetNodeValueByName(ARoot, 'ttl'), 0);
  AChannel.Rating := GetNodeValueByName(ARoot, 'rating');
  AChannel.SkipHours := StrToIntDef(GetNodeValueByName(ARoot, 'skipHours'), 0);
  AChannel.SkipDays := StrToIntDef(GetNodeValueByName(ARoot, 'skipDays'), 0);

  node := GetNodeByName(ARoot, 'cloud');
  if (node <> nil) then
  begin
    AChannel.Cloud.Load(Self, node);
  end;

  node := GetNodeByName(ARoot, 'image');
  if (node <> nil) then
  begin
    AChannel.Image.Load(Self, node);
  end;

  node := GetNodeByName(ARoot, 'textInput');
  if (node <> nil) then
  begin
    AChannel.TextInput.Load(Self, node);
  end;
end;

procedure TclRssXmlLoader.VisitCloud(ACloud: TclRssCloud; const ARoot: IXMLDomNode);
begin
  ACloud.Domain := GetAttributeValue(ARoot, 'domain');
  ACloud.Port := StrToIntDef(GetAttributeValue(ARoot, 'port'), 0);
  ACloud.Path := GetAttributeValue(ARoot, 'path');
  ACloud.RegisterProcedure := GetAttributeValue(ARoot, 'registerProcedure');
  ACloud.Protocol := GetAttributeValue(ARoot, 'protocol');
end;

procedure TclRssXmlLoader.VisitImage(AImage: TclRssImage; const ARoot: IXMLDomNode);
begin
  AImage.Url := GetNodeValueByName(ARoot, 'url');
  AImage.Title := GetNodeValueByName(ARoot, 'title');
  AImage.Link := GetNodeValueByName(ARoot, 'link');
  AImage.Width := StrToIntDef(GetNodeValueByName(ARoot, 'width'), 0);
  AImage.Height := StrToIntDef(GetNodeValueByName(ARoot, 'height'), 0);
  AImage.Description := GetNodeValueByName(ARoot, 'description');
end;

procedure TclRssXmlLoader.VisitItem(AItem: TclRssItem; const ARoot: IXMLDomNode);
var
  node: IXMLDomNode;
  isPermaLink: string;
begin
  AItem.Title := GetNodeValueByName(ARoot, 'title');
  AItem.Link := GetNodeValueByName(ARoot, 'link');
  AItem.Description := GetNodeValueByName(ARoot, 'description');
  AItem.Author := GetNodeValueByName(ARoot, 'author');
  AItem.Comments := GetNodeValueByName(ARoot, 'comments');
  AItem.PubDate := RssDateToDateTime(GetNodeValueByName(ARoot, 'pubDate'));

  node := GetNodeByName(ARoot, 'category');
  if (node <> nil) then
  begin
    AItem.Category.Value := GetNodeText(node);
    AItem.Category.Domain := GetAttributeValue(node, 'domain');
  end;

  node := GetNodeByName(ARoot, 'enclosure');
  if (node <> nil) then
  begin
    AItem.Enclosure.Value := GetNodeText(node);
    AItem.Enclosure.Url := GetAttributeValue(node, 'url');
    AItem.Enclosure.Length := StrToInt64Def(GetAttributeValue(node, 'length'), 0);
    AItem.Enclosure.EnclosureType := GetAttributeValue(node, 'type');
  end;

  node := GetNodeByName(ARoot, 'guid');
  if (node <> nil) then
  begin
    AItem.Guid.Value := GetNodeText(node);

    isPermaLink := GetAttributeValue(node, 'isPermaLink');
    if (isPermaLink <> '') then
    begin
      AItem.Guid.IsPermaLink := SameText(isPermaLink, 'true');
    end;
  end;

  node := GetNodeByName(ARoot, 'source');
  if (node <> nil) then
  begin
    AItem.Source.Value := GetNodeText(node);
    AItem.Source.Url := GetAttributeValue(node, 'url');
  end;
end;

procedure TclRssXmlLoader.VisitItems(AItemList: TclRssItemList; const ARoot: IXMLDomNode);
var
  list: IXMLDomNodeList;
  node: IXMLDomNode;
  item: TclRssItem;
begin
  AItemList.Clear();

  list := ARoot.childNodes;
  node := list.nextNode;
  while (node <> nil) do
  begin
    if (node.nodeName = 'item') then
    begin
      item := AItemList.Add();
      item.Load(Self, node);
    end;

    node := list.nextNode;
  end;
end;

procedure TclRssXmlLoader.VisitTextInput(ATextInput: TclRssTextInput; const ARoot: IXMLDomNode);
begin
  ATextInput.Title := GetNodeValueByName(ARoot, 'title');
  ATextInput.Description := GetNodeValueByName(ARoot, 'description');
  ATextInput.Name := GetNodeValueByName(ARoot, 'name');
  ATextInput.Link := GetNodeValueByName(ARoot, 'link');
end;

{ TclRss091XmlStorer }

procedure TclRss091XmlStorer.AddTextValue(const ARoot: IXMLDomNode; const AName, AValue: string);
begin
  AddNodeValue(ARoot, AName, AValue);
end;

constructor TclRss091XmlStorer.Create(AEncoding: TclRssTextEncoding);
begin
  inherited Create();
  FEncoding := AEncoding;
end;

procedure TclRss091XmlStorer.VisitChannel(AChannel: TclRssChannel; const ARoot: IXMLDomNode);
var
  node: IXMLDomNode;
begin
  AddNodeValue(ARoot, 'title', AChannel.Title);
  AddNodeValue(ARoot, 'link', AChannel.Link);
  AddTextValue(ARoot, 'description', AChannel.Description);
  AddNodeValue(ARoot, 'language', AChannel.Language);
  AddNodeValue(ARoot, 'copyright', AChannel.Copyright);
  AddNodeValue(ARoot, 'managingEditor', AChannel.ManagingEditor);
  AddNodeValue(ARoot, 'webMaster', AChannel.WebMaster);

  AddNodeValue(ARoot, 'pubDate', DateTimeToRssDate(AChannel.PubDate));
  AddNodeValue(ARoot, 'lastBuildDate', DateTimeToRssDate(AChannel.LastBuildDate));

  AddNodeValue(ARoot, 'docs', AChannel.Docs);
  AddNodeValue(ARoot, 'rating', AChannel.Rating);
  AddNodeValue(ARoot, 'skipHours', IntToRssValue(AChannel.SkipHours));
  AddNodeValue(ARoot, 'skipDays', IntToRssValue(AChannel.SkipDays));

  if (not AChannel.Image.IsEmpty) then
  begin
    node := ARoot.ownerDocument.createElement('image');
    ARoot.appendChild(node);
    AChannel.Image.Save(Self, node);
  end;

  if (not AChannel.TextInput.IsEmpty) then
  begin
    node := ARoot.ownerDocument.createElement('textInput');
    ARoot.appendChild(node);
    AChannel.TextInput.Save(Self, node);
  end;
end;

procedure TclRss091XmlStorer.VisitCloud(ACloud: TclRssCloud; const ARoot: IXMLDomNode);
begin
end;

procedure TclRss091XmlStorer.VisitImage(AImage: TclRssImage; const ARoot: IXMLDomNode);
begin
  AddNodeValue(ARoot, 'url', AImage.Url);
  AddNodeValue(ARoot, 'title', AImage.Title);
  AddNodeValue(ARoot, 'link', AImage.Link);
  AddNodeValue(ARoot, 'width', IntToRssValue(AImage.Width));
  AddNodeValue(ARoot, 'height', IntToRssValue(AImage.Height));
  AddNodeValue(ARoot, 'description', AImage.Description);
end;

procedure TclRss091XmlStorer.VisitItem(AItem: TclRssItem; const ARoot: IXMLDomNode);
begin
  AddNodeValue(ARoot, 'title', AItem.Title);
  AddNodeValue(ARoot, 'link', AItem.Link);
  AddTextValue(ARoot, 'description', AItem.Description);
end;

procedure TclRss091XmlStorer.VisitItems(AItemList: TclRssItemList; const ARoot: IXMLDomNode);
var
  i: Integer;
  node: IXMLDomNode;
begin
  for i := 0 to AItemList.Count - 1 do
  begin
    node := ARoot.ownerDocument.createElement('item');
    ARoot.appendChild(node);

    AItemList[i].Save(Self, node);
  end;
end;

procedure TclRss091XmlStorer.VisitTextInput(ATextInput: TclRssTextInput; const ARoot: IXMLDomNode);
begin
  AddNodeValue(ARoot, 'title', ATextInput.Title);
  AddNodeValue(ARoot, 'description', ATextInput.Description);
  AddNodeValue(ARoot, 'name', ATextInput.Name);
  AddNodeValue(ARoot, 'link', ATextInput.Link);
end;

{ TclRss092XmlStorer }

procedure TclRss092XmlStorer.VisitChannel(AChannel: TclRssChannel; const ARoot: IXMLDomNode);
var
  node: IXMLDomNode;
begin
  inherited VisitChannel(AChannel, ARoot);

  if (not AChannel.Cloud.IsEmpty) then
  begin
    node := ARoot.ownerDocument.createElement('cloud');
    ARoot.appendChild(node);
    AChannel.Cloud.Save(Self, node);
  end;
end;

procedure TclRss092XmlStorer.VisitCloud(ACloud: TclRssCloud; const ARoot: IXMLDomNode);
begin
  SetAttributeValue(ARoot, 'domain', ACloud.Domain);
  SetAttributeValue(ARoot, 'port', IntToRssValue(ACloud.Port));
  SetAttributeValue(ARoot, 'path', ACloud.Path);
  SetAttributeValue(ARoot, 'registerProcedure', ACloud.RegisterProcedure);
  SetAttributeValue(ARoot, 'protocol', ACloud.Protocol);
end;

procedure TclRss092XmlStorer.VisitItem(AItem: TclRssItem; const ARoot: IXMLDomNode);
var
  node: IXMLDomNode;
begin
  inherited VisitItem(AItem, ARoot);

  if (AItem.Category.Value <> '') or (AItem.Category.Domain <> '') then
  begin
    node := ARoot.ownerDocument.createElement('category');
    ARoot.appendChild(node);

    SetNodeText(node, AItem.Category.Value);
    SetAttributeValue(node, 'domain', AItem.Category.Domain);
  end;

  if (AItem.Enclosure.Value <> '') then
  begin
    node := ARoot.ownerDocument.createElement('enclosure');
    ARoot.appendChild(node);

    SetNodeText(node, AItem.Enclosure.Value);
    SetAttributeValue(node, 'url', AItem.Enclosure.Url);
    SetAttributeValue(node, 'length', IntToStr(AItem.Enclosure.Length));
    SetAttributeValue(node, 'type', AItem.Enclosure.EnclosureType);
  end;

  if (AItem.Source.Value <> '') or (AItem.Source.Url <> '') then
  begin
    node := ARoot.ownerDocument.createElement('source');
    ARoot.appendChild(node);

    SetNodeText(node, AItem.Source.Value);
    SetAttributeValue(node, 'url', AItem.Source.Url);
  end;
end;

{ TclRss20XmlStorer }

procedure TclRss20XmlStorer.AddTextValue(const ARoot: IXMLDomNode; const AName, AValue: string);
var
  node, cdata: IXMLDomNode;
begin
  if (rtUseCData = Encoding) then
  begin
    if (AValue = '') then Exit;

    node := ARoot.ownerDocument.createElement(WideString(AName));
    ARoot.appendChild(node);

    cdata := ARoot.ownerDocument.createCDATASection(WideString(AValue));
    node.appendChild(cdata);
  end else
  begin
    inherited AddTextValue(ARoot, AName, AValue);
  end;
end;

procedure TclRss20XmlStorer.VisitChannel(AChannel: TclRssChannel; const ARoot: IXMLDomNode);
begin
  inherited VisitChannel(AChannel, ARoot);

  AddNodeValue(ARoot, 'category', AChannel.Category);
  AddNodeValue(ARoot, 'generator', AChannel.Generator);
  AddNodeValue(ARoot, 'ttl', IntToRssValue(AChannel.Ttl));
end;

procedure TclRss20XmlStorer.VisitItem(AItem: TclRssItem; const ARoot: IXMLDomNode);
var
  node: IXMLDomNode;
begin
  inherited VisitItem(AItem, ARoot);

  AddNodeValue(ARoot, 'author', AItem.Author);
  AddNodeValue(ARoot, 'comments', AItem.Comments);
  AddNodeValue(ARoot, 'pubDate', DateTimeToRssDate(AItem.PubDate));

  if (AItem.Guid.Value <> '') then
  begin
    node := ARoot.ownerDocument.createElement('guid');
    ARoot.appendChild(node);

    SetNodeText(node, AItem.Guid.Value);
    if (not AItem.Guid.IsPermaLink) then
    begin
      SetAttributeValue(node, 'isPermaLink', 'false');
    end;
  end;
end;

end.

