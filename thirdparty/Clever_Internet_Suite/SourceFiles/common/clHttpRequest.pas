{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clHttpRequest;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils, System.Types,
{$ENDIF}
  clUtils, clHeaderFieldList, clHtmlParser, clStreams, clHttpHeader, clTranslator, clWUtils, clJson;

type
  TclHttpRequestItem = class;

  TclGetDataStreamEvent = procedure (Sender: TObject; AItem: TclHttpRequestItem; var AData: TStream) of object;

  TclDataAddedEvent = procedure (Sender: TObject; AItem: TclHttpRequestItem; AData: TStream) of object;

  TclGetHtmlFormEvent = procedure(Sender: TObject; AParser: TclHtmlParser; var AForm: TclHtmlForm) of object;

  TclHttpRequest = class;
  TclHttpRequestItemList = class;
  
  TclHttpRequestItem = class(TPersistent)
  private
    FOwner: TclHttpRequestItemList;
    FTag: Integer;
    FCanonicalized: Boolean;
    FSize: Int64;
    
    procedure SetCanonicalized(const Value: Boolean);
    function IsUnsafeChar(ACharCode: Byte): Boolean;
    function GetRequest: TclHttpRequest;
  protected
    procedure NotifyUpdate; virtual;
    procedure ReadData(Reader: TReader); virtual;
    procedure WriteData(Writer: TWriter); virtual;
    procedure ParseHeader(AFieldList: TclHeaderFieldList); virtual;
    procedure AddData(const AData: TclByteArray; AIndex, ACount: Integer); virtual; abstract;
    procedure AfterAddData; virtual; abstract;
    function GetDataStream: TStream; virtual; abstract;
    procedure Update;
    procedure BeginUpdate;
    procedure EndUpdate;
    function GetCanonicalizedValue(const AValue: string): string; virtual;
    function GetCharSet: string; virtual;
  public
    constructor Create(AOwner: TclHttpRequestItemList); virtual;

    procedure Assign(Source: TPersistent); override;
    function GetData: TStream;
    function GetSize: Int64;

    property Request: TclHttpRequest read GetRequest;
    property Tag: Integer read FTag write FTag;
    property Canonicalized: Boolean read FCanonicalized write SetCanonicalized;
  end;

  TclHttpRequestItemClass = class of TclHttpRequestItem;

  TclBinaryRequestItem = class(TclHttpRequestItem)
  protected
    procedure AddData(const AData: TclByteArray; AIndex, ACount: Integer); override;
    procedure AfterAddData; override;
    function GetDataStream: TStream; override;
  end;

  TclTextRequestItem = class(TclHttpRequestItem)
  private
    FTextData: string;
    
    procedure SetTextData(const Value: string);
  protected
    procedure ReadData(Reader: TReader); override;
    procedure WriteData(Writer: TWriter); override;
    procedure AddData(const AData: TclByteArray; AIndex, ACount: Integer); override;
    procedure AfterAddData; override;
    function GetDataStream: TStream; override;
  public
    procedure Assign(Source: TPersistent); override;

    property TextData: string read FTextData write SetTextData;
  end;

  TclFormFieldRequestItem = class(TclHttpRequestItem)
  private
    FFieldName: string;
    FFieldValue: string;

    function GetRequest: string;
    procedure SetFieldName(const Value: string);
    procedure SetFieldValue(const Value: string);
  protected
    procedure ReadData(Reader: TReader); override;
    procedure WriteData(Writer: TWriter); override;
    procedure AddData(const AData: TclByteArray; AIndex, ACount: Integer); override;
    procedure AfterAddData; override;
    function GetDataStream: TStream; override;
  public
    procedure Assign(Source: TPersistent); override;

    property FieldName: string read FFieldName write SetFieldName;
    property FieldValue: string read FFieldValue write SetFieldValue;
  end;

  TclSubmitFileRequestItem = class(TclHttpRequestItem)
  private
    FFileName: string;
    FFieldName: string;
    FContentType: string;
    
    procedure SetContentType(const Value: string);
    procedure SetFieldName(const Value: string);
    procedure SetFileName(const Value: string);
  protected
    procedure ReadData(Reader: TReader); override;
    procedure WriteData(Writer: TWriter); override;
    procedure ParseHeader(AFieldList: TclHeaderFieldList); override;
    procedure AddData(const AData: TclByteArray; AIndex, ACount: Integer); override;
    procedure AfterAddData; override;
    function GetDataStream: TStream; override;
  public
    constructor Create(AOwner: TclHttpRequestItemList); override;
    procedure Assign(Source: TPersistent); override;

    property FieldName: string read FFieldName write SetFieldName;
    property FileName: string read FFileName write SetFileName;
    property ContentType: string read FContentType write SetContentType;
  end;

  TclHttpRequestItemList = class(TPersistent)
  private
    FList: TList;
    FOwner: TclHttpRequest;

    procedure ReadData(Reader: TReader);
    procedure WriteData(Writer: TWriter);
    function GetCount: Integer;
    function GetItem(Index: Integer): TclHttpRequestItem;
    procedure AddItem(AItem: TclHttpRequestItem);
  protected
    procedure DefineProperties(Filer: TFiler); override;
  public
    constructor Create(AOwner: TclHttpRequest);
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure Delete(Index: Integer);
    procedure Move(CurIndex, NewIndex: Integer);
    procedure Clear;

    function Add(AItemClass: TclHttpRequestItemClass): TclHttpRequestItem;
    function FormFieldByName(const AFieldName: string): TclFormFieldRequestItem;

    property Items[Index: Integer]: TclHttpRequestItem read GetItem; default;
    property Count: Integer read GetCount;

    property Owner: TclHttpRequest read FOwner;
  end;

  TclHttpRequest = class(TComponent)
  private
    FItems: TclHttpRequestItemList;
    FHeader: TclHttpRequestHeader;
    FUpdateCount: Integer;
    FRequestSource: TStrings;
    FHeaderSource: TStrings;
    FIsParse: Boolean;
    FDataStream: TStream;
    FBatchSize: Integer;
    FOnChanged: TNotifyEvent;
    FOnSaveData: TclGetDataStreamEvent;
    FOnLoadData: TclGetDataStreamEvent;
    FOnGetHtmlForm: TclGetHtmlFormEvent;
    FOnDataAdded: TclDataAddedEvent;

    function GetTotalSize: Int64;
    procedure SetHeader(const Value: TclHttpRequestHeader);
    procedure GetTotalRequestData(AStream: TclMultiStream);
    function GenerateBoundary: string;
    function GetRequestSource: TStrings;
    function GetHeaderSource: TStrings;
    procedure SetHeaderSource(const Value: TStrings);
    procedure ParseMultiPartRequest(AStream: TStream);
    procedure ParseFormField(const AFieldInfo: string);
    procedure ParseFormFieldRequest(const ASource: string);
    function GetRequestAsStream: TStream;
    procedure SetRequestAsStream(const Value: TStream);
    procedure SetRequestSource(const Value: TStrings);
    function ReadLine(AStream: TStream; AMaxBytes: Integer): string;
    procedure DoOnHeaderChanged(Sender: TObject);
    procedure InitBoundary;
    procedure ClearDataStream;
    function CreateMultiPartItem(const AHeader: string): TclHttpRequestItem;
    procedure NotifyItemsUpdate;
    procedure SetItems(const Value: TclHttpRequestItemList);
    function GetFormField(const AFieldName: string): TclFormFieldRequestItem;
    function GetIsMultiPartContent: Boolean;
    function GetIsFormFieldRequest: Boolean;
  protected
    procedure UpdateContentType;
    procedure SafeClear; virtual;
    function CreateHeader: TclHttpRequestHeader; virtual;
    function CreateItem(AFieldList: TclHeaderFieldList): TclHttpRequestItem; virtual;
    procedure CreateSingleItem(AStream: TStream); virtual;
    function GetContentType: string; virtual;
    procedure InitHeader; virtual;
    procedure DoSaveData(AItem: TclHttpRequestItem; var AData: TStream); dynamic;
    procedure DoLoadData(AItem: TclHttpRequestItem; var AData: TStream); dynamic;
    procedure DoDataAdded(AItem: TclHttpRequestItem; AData: TStream); dynamic;
    procedure DoGetHtmlForm(AParser: TclHtmlParser; var AForm: TclHtmlForm); dynamic;
    procedure Changed; dynamic;
    property DataStream: TStream read FDataStream write FDataStream;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    
    procedure Clear; virtual;
    procedure Update;
    procedure BeginUpdate;
    procedure EndUpdate;

    function AddBinaryData: TclBinaryRequestItem;
    function AddTextData(const ATextData: string): TclTextRequestItem;
    function AddSubmitFile(const AFieldName, AFileName: string): TclSubmitFileRequestItem;
    function AddFormField(const AFieldName, AFieldValue: string): TclFormFieldRequestItem;
    function AddFormFieldIfNeed(const AFieldName, AFieldValue: string): TclFormFieldRequestItem;
    
    function BuildFormPostRequest(AForm: TclHtmlForm): string; overload;
    function BuildFormPostRequest(AParser: TclHtmlParser; const AFormName: string): string; overload;
    function BuildFormPostRequest(AHtml: TStrings): string; overload;
    function BuildFormPostRequest(AHtml: TStrings; const AFormName: string): string; overload;
    function BuildFormPostRequestByUrl(const AUrl: string): string; overload;

    procedure BuildJSONRequest(AJson: TclJSONBase); overload;
    procedure BuildJSONRequest(const AJson: string); overload;

    procedure LoadRequest(const AFileName: string);
    procedure SaveRequest(const AFileName: string);

    property RequestSource: TStrings read GetRequestSource write SetRequestSource;
    property RequestStream: TStream read GetRequestAsStream write SetRequestAsStream;

    property HeaderSource: TStrings read GetHeaderSource write SetHeaderSource;

    property FormFields[const AFieldName: string]: TclFormFieldRequestItem read GetFormField;
    property TotalSize: Int64 read GetTotalSize;
    property IsMultiPartContent: Boolean read GetIsMultiPartContent;
    property IsFormFieldRequest: Boolean read GetIsFormFieldRequest;
  published
    property Items: TclHttpRequestItemList read FItems write SetItems;
    property Header: TclHttpRequestHeader read FHeader write SetHeader;
    property BatchSize: Integer read FBatchSize write FBatchSize default 8192;

    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnSaveData: TclGetDataStreamEvent read FOnSaveData write FOnSaveData;
    property OnLoadData: TclGetDataStreamEvent read FOnLoadData write FOnLoadData;
    property OnDataAdded: TclDataAddedEvent read FOnDataAdded write FOnDataAdded;
    property OnGetHtmlForm: TclGetHtmlFormEvent read FOnGetHtmlForm write FOnGetHtmlForm;
  end;

procedure RegisterHttpRequestItem(AHeaderClass: TclHttpRequestItemClass);
function GetRegisteredHttpRequestItems: TList;

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsHttpRequestDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

implementation

uses
  clUriUtils, clHttp,
{$IFNDEF DELPHIXE2}
  Windows{$IFDEF DEMO}, Forms{$ENDIF};
{$ELSE}
  Winapi.Windows{$IFDEF DEMO}, Vcl.Forms{$ENDIF};
{$ENDIF}

const
  cFormDataContentType = 'application/x-www-form-urlencoded';
  cMultiPartContentType = 'multipart/form-data';
  cJsonContentType = 'application/json';

var
  RegisteredHttpRequestItems: TList = nil;
  UnsafeChars: TclByteArray = nil;

procedure InitStaticVars;
const
  Chars = '!"#$%&''()+,/:;<=>?@[\]^`{|}~';
begin
  UnsafeChars := TclTranslator.GetBytes(Chars, 'us-ascii');
end;

procedure RegisterHttpRequestItem(AHeaderClass: TclHttpRequestItemClass);
begin
  GetRegisteredHttpRequestItems().Add(AHeaderClass);
  {$IFDEF DELPHIXE2}System.{$ENDIF}Classes.RegisterClass(AHeaderClass);
end;

function GetRegisteredHttpRequestItems(): TList;
begin
  if (RegisteredHttpRequestItems = nil) then
  begin
    RegisteredHttpRequestItems := TList.Create();
  end;
  Result := RegisteredHttpRequestItems;
end;

{ TclHttpRequestItem }

procedure TclHttpRequestItem.Assign(Source: TPersistent);
begin
  if (Source is TclHttpRequestItem) then
  begin
    Canonicalized := TclHttpRequestItem(Source).Canonicalized;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclHttpRequestItem.BeginUpdate;
begin
  Request.BeginUpdate();
end;

procedure TclHttpRequestItem.Update;
begin
  NotifyUpdate();
  BeginUpdate();
  EndUpdate();
end;

constructor TclHttpRequestItem.Create(AOwner: TclHttpRequestItemList);
begin
  inherited Create();

  Assert(AOwner <> nil);
  FOwner := AOwner;
  FOwner.AddItem(Self);
  FCanonicalized := True;
  FSize := 0;
end;

procedure TclHttpRequestItem.EndUpdate;
begin
  Request.EndUpdate();
end;

procedure TclHttpRequestItem.ReadData(Reader: TReader);
begin
  BeginUpdate();
  try
    Canonicalized := Reader.ReadBoolean();
  finally
    EndUpdate();
  end;
end;

procedure TclHttpRequestItem.WriteData(Writer: TWriter);
begin
  Writer.WriteBoolean(Canonicalized);
end;

function TclHttpRequestItem.IsUnsafeChar(ACharCode: Byte): Boolean;
var
  i: Integer;
begin
  for i := 0 to Length(UnsafeChars) - 1 do
  begin
    if (UnsafeChars[i] = ACharCode) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure TclHttpRequestItem.NotifyUpdate;
begin
  FSize := 0;
end;

function TclHttpRequestItem.GetCanonicalizedValue(const AValue: string): string;
var
  i: Integer;
  encBytes: TclByteArray;
begin
{$IFNDEF DELPHI2005}encBytes := nil;{$ENDIF}

  if (not Canonicalized) then
  begin
    Result := AValue;
    Exit;
  end;

  Result := '';
  encBytes := TclTranslator.GetBytes(AValue, GetCharSet());
  for i := 0 to Length(encBytes) - 1 do
  begin
    if IsUnsafeChar(encBytes[i]) or (encBytes[i] >= $7F) or (encBytes[i] < $20) then
    begin
      Result := Result + '%' + IntToHex(encBytes[i], 2);
    end else
    if (encBytes[i] = $20) then
    begin
      Result := Result + '+';
    end else
    begin
      Result := Result + Chr(encBytes[i]);
    end;
  end;
end;

function TclHttpRequestItem.GetCharSet: string;
begin
  Result := Request.Header.CharSet;
end;

function TclHttpRequestItem.GetData: TStream;
begin
  Result := GetDataStream();
  try
    FSize := Result.Size;
  except
    Result.Free();
    raise;
  end;
end;

function TclHttpRequestItem.GetRequest: TclHttpRequest;
begin
  Result := FOwner.Owner;
end;

procedure TclHttpRequestItem.SetCanonicalized(const Value: Boolean);
begin
  if (FCanonicalized <> Value) then
  begin
    FCanonicalized := Value;
    Update();
  end;
end;

function TclHttpRequestItem.GetSize: Int64;
var
  Stream: TStream;
begin
  if (FSize <= 0) then
  begin
    Stream := GetData();
    try
      FSize := Stream.Size;
    finally
      Stream.Free();
    end;
  end;

  Result := FSize;
end;

procedure TclHttpRequestItem.ParseHeader(AFieldList: TclHeaderFieldList);
begin
end;

{ TclHttpRequest }

function TclHttpRequest.GetContentType: string;
const
  RequestTypes: array[Boolean] of string = ('', cFormDataContentType);
var
  i: Integer;
  IsFormData: Boolean;
begin
  IsFormData := (Items.Count > 0);
  for i := 0 to Items.Count - 1 do
  begin
    if (Items[i] is TclSubmitFileRequestItem) then
    begin
      Result := cMultiPartContentType;
      Exit;
    end;
    IsFormData := IsFormData and (Items[i] is TclFormFieldRequestItem);
  end;
  Result := RequestTypes[IsFormData];
end;

function TclHttpRequest.GetFormField(const AFieldName: string): TclFormFieldRequestItem;
begin
  Result := Items.FormFieldByName(AFieldName);
end;

function TclHttpRequest.AddBinaryData: TclBinaryRequestItem;
begin
  BeginUpdate();
  try
    Result := Items.Add(TclBinaryRequestItem) as TclBinaryRequestItem;
  finally
    EndUpdate();
  end;
end;

function TclHttpRequest.AddFormField(const AFieldName, AFieldValue: string): TclFormFieldRequestItem;
begin
  BeginUpdate();
  try
    Result := Items.Add(TclFormFieldRequestItem) as TclFormFieldRequestItem;
    Result.FieldName := AFieldName;
    Result.FieldValue := AFieldValue;
  finally
    EndUpdate();
  end;
end;

function TclHttpRequest.AddFormFieldIfNeed(const AFieldName, AFieldValue: string): TclFormFieldRequestItem;
begin
  if (AFieldValue <> '') then
  begin
    Result := AddFormField(AFieldName, AFieldValue);
  end else
  begin
    Result := nil;
  end;
end;

function TclHttpRequest.AddSubmitFile(const AFieldName, AFileName: string): TclSubmitFileRequestItem;
begin
  BeginUpdate();
  try
    Result := Items.Add(TclSubmitFileRequestItem) as TclSubmitFileRequestItem;
    Result.FileName := AFileName;
    Result.FieldName := AFieldName;
  finally
    EndUpdate();
  end;
end;

function TclHttpRequest.AddTextData(const ATextData: string): TclTextRequestItem;
begin
  BeginUpdate();
  try
    Result := Items.Add(TclTextRequestItem) as TclTextRequestItem;
    Result.TextData := ATextData;
  finally
    EndUpdate();
  end;
end;

procedure TclHttpRequest.Assign(Source: TPersistent);
begin
  if (Source is TclHttpRequest) then
  begin
    BeginUpdate();
    try
      Clear();
      Items := TclHttpRequest(Source).Items;
      Header.Assign(TclHttpRequest(Source).Header);
    finally
      EndUpdate();
    end;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclHttpRequest.Clear;
begin
  BeginUpdate();
  try
    Items.Clear();
    Header.Clear();
  finally
    EndUpdate();
  end;
end;

constructor TclHttpRequest.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FRequestSource := TStringList.Create();
  FHeaderSource := TStringList.Create();
  FItems := TclHttpRequestItemList.Create(Self);
  FHeader := CreateHeader();
  FHeader.OnChanged := DoOnHeaderChanged;
  FBatchSize := 8192;
end;

function TclHttpRequest.CreateHeader: TclHttpRequestHeader;
begin
  Result := TclHttpRequestHeader.Create();
end;

procedure TclHttpRequest.ClearDataStream;
begin
  FDataStream.Free();
  FDataStream := nil;
end;

destructor TclHttpRequest.Destroy;
begin
  ClearDataStream();
  FHeader.Free();
  FItems.Free();
  FHeaderSource.Free();
  FRequestSource.Free();

  inherited Destroy();
end;

procedure TclHttpRequest.SafeClear;
var
  oldCharSet: string;
begin
  BeginUpdate();
  try
    oldCharSet := Header.CharSet;

    Clear();

    Header.CharSet := oldCharSet;
  finally
    EndUpdate();
  end;
end;

procedure TclHttpRequest.SaveRequest(const AFileName: string);
var
  src, dst: TStream;
begin
  dst := nil;
  src := nil;
  try
    dst := TFileStream.Create(AFileName, fmCreate);
    src := RequestStream;
    dst.CopyFrom(src, 0);
  finally
    src.Free();
    dst.Free();
  end;
end;

procedure TclHttpRequest.SetHeader(const Value: TclHttpRequestHeader);
begin
  FHeader.Assign(Value);
end;

function TclHttpRequest.GenerateBoundary(): string;
var
  y, mm, d, h, m, s, ms: Word;
begin
  DecodeTime(Now(), h, m, s, ms);
  DecodeDate(Date(), y, mm, d);
  Result := IntToHex(mm, 2) + IntToHex(d, 2) + IntToHex(h, 2)
    + IntToHex(m, 2) + IntToHex(s, 2) + IntToHex(ms, 2);
  Result := '---------------------------' + system.Copy(Result, 1, 12);
end;          

function TclHttpRequest.GetRequestAsStream: TStream;
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
    if (not IsHttpRequestDemoDisplayed) and (not IsHtmlDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpRequestDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  FIsParse := True;
  try
    InitBoundary();
  finally
    FIsParse := False;
  end;

  Result := TclMultiStream.Create();
  try
    GetTotalRequestData(TclMultiStream(Result));
  except
    Result.Free();
    raise;
  end;
end;

procedure TclHttpRequest.GetTotalRequestData(AStream: TclMultiStream);
var
  i: Integer;
  s: string;
begin
  for i := 0 to Items.Count - 1 do
  begin
    s := '';
    if IsMultiPartContent then
    begin
      s := '--' + Header.Boundary + #13#10;
      if (i > 0) then
      begin
        s := #13#10 + s;
      end;
    end else
    if (i > 0) and IsFormFieldRequest then
    begin
      s := '&';
    end;
    if (s <> '') then
    begin
      AStream.AddStream(TStringStream.Create(s));
    end;
    AStream.AddStream(Items[i].GetData());
  end;
  if IsMultiPartContent then
  begin
    s := #13#10 + '--' + Header.Boundary + '--'#13#10;
    AStream.AddStream(TStringStream.Create(s));
  end;
end;

function TclHttpRequest.GetTotalSize: Int64;
var
  i: Integer;
  bound: string;
begin
  bound := GenerateBoundary();
  Result := 0;
  for i := 0 to Items.Count - 1 do
  begin
    Result := Result + Items[i].GetSize();
  end;
  if IsMultiPartContent then
  begin
    Result := Result + Length(#13#10 + '--' + bound + #13#10) * Items.Count + Length('--' + bound + '--'#13#10);
  end else
  if IsFormFieldRequest then
  begin
    Result := Result + Length('&') * (Items.Count - 1);
  end;
end;

procedure TclHttpRequest.DoSaveData(AItem: TclHttpRequestItem; var AData: TStream);
begin
  if Assigned(OnSaveData) then
  begin
    OnSaveData(Self, AItem, AData);
  end;
end;

procedure TclHttpRequest.DoLoadData(AItem: TclHttpRequestItem; var AData: TStream);
begin
  if Assigned(OnLoadData) then
  begin
    OnLoadData(Self, AItem, AData);
  end;
end;

procedure TclHttpRequest.Changed;
begin
  if Assigned(OnChanged) then
  begin
    OnChanged(Self);
  end;
end;

procedure TclHttpRequest.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

function TclHttpRequest.BuildFormPostRequest(AHtml: TStrings): string;
var
  Parser: TclHtmlParser;
  form: TclHtmlForm;
begin
  SafeClear();
  Result := '';

  Parser := TclHtmlParser.Create(nil);
  try
    Parser.Parse(AHtml);

    if (Parser.Forms.Count > 0) then
    begin
      form := nil;
      DoGetHtmlForm(Parser, form);

      if (form = nil) then
      begin
        form := Parser.Forms[0];
      end;

      Result := BuildFormPostRequest(form);
    end;
  finally
    Parser.Free();
  end;
end;

procedure TclHttpRequest.EndUpdate;
begin
  if (FUpdateCount > 0) then
  begin
    Dec(FUpdateCount);
  end;
  Update();
end;

function TclHttpRequest.BuildFormPostRequest(AParser: TclHtmlParser; const AFormName: string): string;
var
  form: TclHtmlForm;
begin
  SafeClear();
  Result := '';

  if AParser.Forms.Count = 0 then Exit;

  if (AFormName <> '') then
  begin
    form := AParser.Forms.FormByName(AFormName);
  end else
  begin
    form := AParser.Forms[0];
  end;

  if (form <> nil) then
  begin
    Result := BuildFormPostRequest(form);
  end;
end;

function TclHttpRequest.BuildFormPostRequest(AForm: TclHtmlForm): string;
var
  i: Integer;
  TagName, ControlType, ControlName, OldName: string;
  isMultiPartReq: Boolean;
begin
  SafeClear();
  Result := '';

  Result := AForm.Action;
  OldName := '';
  isMultiPartReq := SameText('multipart/form-data', AForm.EncType);
  for i := 0 to AForm.Controls.Count - 1 do
  begin
    TagName := LowerCase(AForm.Controls[i].Name);
    ControlName := AForm.Controls[i].AttributeValue('name');

    if (ControlName = '') then Continue;
    
    if (TagName = 'input') then
    begin
      ControlType := LowerCase(AForm.Controls[i].AttributeValue('type'));
      if (ControlType = 'checkbox')
        or (ControlType = 'hidden')
        or (ControlType = 'password')
        or (ControlType = 'text')
        or (ControlType = 'submit')
        or (ControlType = '') then
      begin
        AddFormField(ControlName, AForm.Controls[i].AttributeValue('value'));
      end else
      if (ControlType = 'radio') then
      begin
        if (OldName <> ControlName) then
        begin
          OldName := ControlName;
          AddFormField(ControlName, '');
        end;
      end else
      if (ControlType = 'file') then
      begin
        if isMultiPartReq then
        begin
          AddSubmitFile(ControlName, AForm.Controls[i].AttributeValue('value'));
        end else
        begin
          AddFormField(ControlName, AForm.Controls[i].AttributeValue('value'));
        end;
      end;
    end else
    if (TagName = 'select') or (TagName = 'textarea') then
    begin
      AddFormField(ControlName, '');
    end;
  end;
end;

function TclHttpRequest.BuildFormPostRequestByUrl(const AUrl: string): string;
var
  http: TclHttp;
  html: TStrings;
  formAction: string;
begin
  http := nil;
  html := nil;
  try
    http := TclHttp.Create(nil);
    html := TStringList.Create();

    http.Get(AUrl, html);
    formAction := BuildFormPostRequest(html);

    Result := TclUrlParser.CombineUrl(formAction, AUrl, '');
  finally
    html.Free();
    http.Free();
  end;
end;

procedure TclHttpRequest.BuildJSONRequest(const AJson: string);
begin
  AddTextData(AJson);
  Header.ContentType := cJsonContentType;
  Header.CharSet := 'utf-8';
end;

procedure TclHttpRequest.BuildJSONRequest(AJson: TclJSONBase);
begin
  BuildJSONRequest(AJson.GetJSONString());
end;

function TclHttpRequest.BuildFormPostRequest(AHtml: TStrings; const AFormName: string): string;
var
  Parser: TclHtmlParser;
begin
  Parser := TclHtmlParser.Create(nil);
  try
    Parser.Parse(AHtml);
    Result := BuildFormPostRequest(Parser, AFormName);
  finally
    Parser.Free();
  end;
end;

procedure TclHttpRequest.DoGetHtmlForm(AParser: TclHtmlParser; var AForm: TclHtmlForm);
begin
  if Assigned(OnGetHtmlForm) then
  begin
    OnGetHtmlForm(Self, AParser, AForm);
  end;
end;

function TclHttpRequest.GetRequestSource: TStrings;
var
  Stream: TStream;
begin
  if (FRequestSource.Count = 0) then
  begin
    Stream := GetRequestAsStream();
    try
      TclStringsUtils.LoadStrings(Stream, FRequestSource, Header.CharSet);
    finally
      Stream.Free();
    end;
  end;
  Result := FRequestSource;
end;

procedure TclHttpRequest.InitBoundary;
begin
  if IsMultiPartContent then
  begin
    if (Header.Boundary = '') then
    begin
      Header.Boundary := GenerateBoundary();
    end;
  end else
  begin
    Header.Boundary := '';
  end;
end;

procedure TclHttpRequest.InitHeader;
begin
  InitBoundary();

  Header.ContentLength := IntToStr(TotalSize);
  if (Header.ContentLength = '0') then
  begin
    Header.ContentLength := '';
  end;
end;

function TclHttpRequest.GetHeaderSource: TStrings;
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
    if (not IsHttpRequestDemoDisplayed) and (not IsHtmlDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpRequestDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

  if (FHeaderSource.Count = 0) then
  begin
    FIsParse := True;
    try
      InitHeader();
    finally
      FIsParse := False;
    end;

    Header.AssignHeader(FHeaderSource);
  end;
  Result := FHeaderSource;
end;

procedure TclHttpRequest.SetHeaderSource(const Value: TStrings);
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
    if (not IsHttpRequestDemoDisplayed) and (not IsHtmlDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpRequestDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  FIsParse := True;
  try
    Header.ParseHeader(Value);
  finally
    FIsParse := False;
  end;
end;

procedure TclHttpRequest.SetItems(const Value: TclHttpRequestItemList);
begin
  FItems.Assign(Value);
end;

procedure TclHttpRequest.ParseFormField(const AFieldInfo: string);
var
  ind: Integer;
  name, val: string;
begin
  ind := Pos('=', AFieldInfo);
  if (ind > 0) then
  begin
    name := Copy(AFieldInfo, 1, ind - 1);
    val := Copy(AFieldInfo, ind + 1, Length(AFieldInfo));
  end else
  begin
    name := AFieldInfo;
    val := '';
  end;
  AddFormField(Trim(Name), Trim(val)).AfterAddData(); //TODO urldecode (decanonicalize)
end;

procedure TclHttpRequest.ParseFormFieldRequest(const ASource: string);
var
  i: Integer;
  s: string;
begin
  s := '';
  for i := 1 to Length(ASource) do
  begin
    if (ASource[i] = '&') then
    begin
      ParseFormField(s);
      s := '';
    end else
    begin
      s := s + ASource[i];
    end;
  end;
  if (s <> '') then
  begin
    ParseFormField(s);
  end;
end;

function TclHttpRequest.ReadLine(AStream: TStream; AMaxBytes: Integer): string;
const
  cDelimiter: array[0..1] of Byte = (13, 10);

var
  delimCount: Integer;
  Symbol: Byte;
begin
  Result := '';
  delimCount := 0;
  Assert(AMaxBytes > 0);

  while (AMaxBytes > 0) and (AStream.Read(Symbol, 1) > 0) do
  begin
    if (Symbol = cDelimiter[delimCount]) then
    begin
      Inc(delimCount);
    end else
    begin
      delimCount := 0;
    end;

    Result := Result + Chr(Symbol);
    Dec(AMaxBytes);

    if (delimCount >= Length(cDelimiter)) then
    begin
      system.Delete(Result, Length(Result) - Length(cDelimiter) + 1, Length(cDelimiter));
      Break;
    end;
  end;
end;

function TclHttpRequest.CreateItem(AFieldList: TclHeaderFieldList): TclHttpRequestItem;
var
  fileName, name, contDisposition: string;
begin
  contDisposition := AFieldList.GetFieldValue('Content-Disposition');
  if (LowerCase(AFieldList.GetFieldValueItem(contDisposition, '')) = 'form-data') then
  begin
    name := AFieldList.GetFieldValueItem(contDisposition, 'name');
    fileName := AFieldList.GetFieldValueItem(contDisposition, 'filename');
    if (fileName <> '') then
    begin
      Result := AddSubmitFile(name, fileName);
    end else
    begin
      Result := AddFormField(name, '');
    end;
  end else
  begin
    Result := AddTextData('');
  end;
end;

procedure TclHttpRequest.ParseMultiPartRequest(AStream: TStream);
var
  buf, bound, eofHead, temp, b: TclByteArray;
  i, len, dataSize, bufSize,
  boundCnt, eofHeadCnt, startPos, tempLen: Integer;
  head: string;
  item: TclHttpRequestItem;
begin
{$IFNDEF DELPHI2005}b := nil;{$ENDIF}

  bufSize := BatchSize;
  if (bufSize < Length(Header.Boundary)) then
  begin
    bufSize := Length(Header.Boundary);
  end;
  if (bufSize > AStream.Size - AStream.Position) then
  begin
    bufSize := AStream.Size - AStream.Position;
  end;

  SetLength(buf, bufSize);

  bound := TclTranslator.GetBytes(#13#10'--' + Header.Boundary, 'us-ascii');
  eofHead := TclTranslator.GetBytes(#13#10#13#10, 'us-ascii');

  head := '';
  temp := nil;
  item := nil;
  boundCnt := 2;
  eofHeadCnt := 0;
  len := bufSize;

  while (len > 0) do
  begin
    len := AStream.Read(buf[0], bufSize);

    startPos := 0;
    for i := 0 to len - 1 do
    begin
      if (buf[i] = bound[boundCnt]) then
      begin
        Inc(boundCnt);
      end else
      begin
        boundCnt := 0;
        if (buf[i] = bound[boundCnt]) then
        begin
          Inc(boundCnt);
        end;

        if (temp <> nil) and (item <> nil) then
        begin
          item.AddData(temp, 0, Length(temp));
        end;
        temp := nil;
      end;

      if (buf[i] = eofHead[eofHeadCnt]) then
      begin
        Inc(eofHeadCnt);
      end else
      begin
        eofHeadCnt := 0;
        if (buf[i] = eofHead[eofHeadCnt]) then
        begin
          Inc(eofHeadCnt);
        end;
      end;

      if (boundCnt >= Length(bound)) then
      begin
        dataSize := i - startPos - boundCnt + 1;
        if (item <> nil) then
        begin
          if (startPos < len) and (dataSize > 0) then
          begin
            item.AddData(buf, startPos, dataSize);
          end;
          item.AfterAddData();
        end;
        item := nil;
        head := '';
        startPos := 0;
        boundCnt := 0;
      end else
      if (item = nil) then
      begin
        head := head + TclTranslator.GetString(buf, i, Length(buf) - i, Header.CharSet);
        if (eofHeadCnt >= Length(eofHead)) then
        begin
          item := CreateMultiPartItem(Trim(head));
          head := '';
          startPos := i + 1;
        end;
      end;

      if (eofHeadCnt >= Length(eofHead)) then
      begin
        eofHeadCnt := 0;
      end;
    end;

    dataSize := len - startPos - boundCnt;
    if (item <> nil) and (startPos < len) and (dataSize > 0) then
    begin
      if (boundCnt > 0) then
      begin
        tempLen := Length(temp);
        SetLength(b, tempLen + boundCnt);
        if (tempLen > 0) then
        begin
          System.Move(temp[0], b[0], Length(temp));
          tempLen := Length(temp);
        end;
        System.Move(buf[len - boundCnt], b[tempLen], boundCnt);
        temp := b;
      end;
      item.AddData(buf, startPos, dataSize);
    end;
  end;
end;

procedure TclHttpRequest.SetRequestAsStream(const Value: TStream);
var
  s: string;
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
    if (not IsHttpRequestDemoDisplayed) and (not IsHtmlDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHttpRequestDemoDisplayed := True;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  FIsParse := True;
  BeginUpdate();
  try
    Items.Clear();
    if (Value = nil) then Exit;

    s := ReadLine(Value, 250);
    Value.Position := 0;
    if (Pos('--', s) = 1) then
    begin
      system.Delete(s, 1, 2);
      Header.Boundary := Trim(s);
      ParseMultiPartRequest(Value);
    end else
    begin
      Header.Boundary := '';
      CreateSingleItem(Value);
    end;
    Header.ContentType := GetContentType();
  finally
    ClearDataStream();
    EndUpdate();
    FIsParse := False;
  end;
end;

procedure TclHttpRequest.CreateSingleItem(AStream: TStream);
var
  buf: TclByteArray;
  s: string;
  len: Integer;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}

  len := AStream.Size - AStream.Position;
  if (len <= 0) then Exit;

  SetLength(buf, len);
  AStream.Read(buf[0], Length(buf));

  s := TclTranslator.GetString(buf, 0, Length(buf), Header.CharSet);
  if IsFormFieldRequest then
  begin
    ParseFormFieldRequest(s);
  end else
  begin
    AddTextData(s).AfterAddData();
  end;
end;

procedure TclHttpRequest.NotifyItemsUpdate;
var
  i: Integer;
begin
  for i := 0 to Items.Count - 1 do
  begin
    Items[i].NotifyUpdate();
  end;
end;

procedure TclHttpRequest.DoOnHeaderChanged(Sender: TObject);
begin
  Update();
end;

function TclHttpRequest.GetIsFormFieldRequest: Boolean;
begin
  Result := SameText(cFormDataContentType, Header.ContentType)
end;

function TclHttpRequest.GetIsMultiPartContent: Boolean;
begin
  Result := (system.Pos('multipart/', LowerCase(Header.ContentType)) > 0);
end;

procedure TclHttpRequest.LoadRequest(const AFileName: string);
var
  src: TStream;
begin
  src := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    RequestStream := src;
  finally
    src.Free();
  end;
end;

procedure TclHttpRequest.DoDataAdded(AItem: TclHttpRequestItem; AData: TStream);
begin
  if Assigned(OnDataAdded) then
  begin
    OnDataAdded(Self, AItem, AData);
  end;
end;

function TclHttpRequest.CreateMultiPartItem(const AHeader: string): TclHttpRequestItem;
var
  hdr: TStrings;
  fieldList: TclHeaderFieldList;
begin
  ClearDataStream();
  hdr := nil;
  FieldList := nil;
  try
    hdr := TStringList.Create();
    fieldList := TclHeaderFieldList.Create();
    hdr.Text := AHeader;

    fieldList.Parse(0, hdr);

    Result := CreateItem(fieldList);
    Result.ParseHeader(fieldList);
  finally
    FieldList.Free();
    hdr.Free();
  end;
end;

procedure TclHttpRequest.SetRequestSource(const Value: TStrings);
var
  stream: TStream;
begin
  stream := TMemoryStream.Create();
  try
    if (Value <> nil) then
    begin
      TclStringsUtils.SaveStrings(Value, stream, Header.CharSet);
      stream.Position := 0;
    end;
    RequestStream := stream;
  finally
    stream.Free();
  end;
end;

procedure TclHttpRequest.Update;
begin
  if (not (csDestroying in ComponentState))
    and (not (csLoading in ComponentState))
    and (not (csDesigning in ComponentState))
    and (FUpdateCount = 0) then
  begin
    if not FIsParse then
    begin
      Header.Boundary := '';
    end;
    FHeaderSource.Clear();
    FRequestSource.Clear();

    NotifyItemsUpdate();

    Changed();
  end;
end;

procedure TclHttpRequest.UpdateContentType;
begin
  if (not (csLoading in ComponentState)) and (not FIsParse) then
  begin
    Header.ContentType := GetContentType();
  end;
end;

{ TclBinaryRequestItem }

function TclBinaryRequestItem.GetDataStream: TStream;
begin
  Result := nil;
  Request.DoLoadData(Self, Result);
  if (Result = nil) then
  begin
    Result := TclNullStream.Create();
  end;
  Result.Position := 0;
end;

procedure TclBinaryRequestItem.AddData(const AData: TclByteArray; AIndex, ACount: Integer);
var
  stream: TStream;
begin
  if (Request.DataStream = nil) then
  begin
    stream := nil;
    Request.DoSaveData(Self, stream);
    Request.DataStream := stream;
  end;
  if (Request.DataStream <> nil) then
  begin
    Request.DataStream.Write(AData[AIndex], ACount);
  end;
end;

procedure TclBinaryRequestItem.AfterAddData;
begin
  if (Request.DataStream <> nil) and Assigned(Request.OnDataAdded) then
  begin
    Request.DataStream.Position := 0;
    Request.DoDataAdded(Self, Request.DataStream);
  end;
end;

{ TclTextRequestItem }

procedure TclTextRequestItem.Assign(Source: TPersistent);
begin
  BeginUpdate();
  try
    if (Source is TclTextRequestItem) then
    begin
      TextData := (Source as TclTextRequestItem).TextData;
    end;
    inherited Assign(Source);
  finally
    EndUpdate();
  end;
end;

function TclTextRequestItem.GetDataStream: TStream;
var
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  Result := TMemoryStream.Create();
  try
    buf := TclTranslator.GetBytes(TextData, GetCharSet());
    if (Length(buf) > 0) then
    begin
      Result.Write(buf[0], Length(buf));
    end;
    Result.Position := 0;
  except
    Result.Free();
    raise;
  end;
end;

procedure TclTextRequestItem.ReadData(Reader: TReader);
begin
  BeginUpdate();
  try
    inherited ReadData(Reader);
    TextData := Reader.ReadString();
  finally
    EndUpdate();
  end;
end;

procedure TclTextRequestItem.WriteData(Writer: TWriter);
begin
  inherited WriteData(Writer);
  Writer.WriteString(TextData);
end;

procedure TclTextRequestItem.SetTextData(const Value: string);
begin
  if (FTextData <> Value) then
  begin
    FTextData := Value;
    Update();
  end;
end;

procedure TclTextRequestItem.AddData(const AData: TclByteArray; AIndex, ACount: Integer);
begin
  TextData := TextData + TclTranslator.GetString(AData, AIndex, ACount, GetCharSet());
end;

procedure TclTextRequestItem.AfterAddData;
var
  stream: TStream;
  buffer: TclByteArray;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}

  if Assigned(Request.OnDataAdded) then
  begin
    stream := TMemoryStream.Create();
    try
      if (TextData <> '') then
      begin
        buffer := TclTranslator.GetBytes(TextData, GetCharSet());
        stream.WriteBuffer(buffer[0], Length(buffer));
        stream.Position := 0;
      end;
      Request.DoDataAdded(Self, stream);
    finally
      stream.Free();
    end;
  end;
end;

{ TclSubmitFileRequestItem }

procedure TclSubmitFileRequestItem.Assign(Source: TPersistent);
var
  Src: TclSubmitFileRequestItem;
begin
  BeginUpdate();
  try
    if (Source is TclSubmitFileRequestItem) then
    begin
      Src := (Source as TclSubmitFileRequestItem);
      FieldName := Src.FieldName;
      FileName := Src.FileName;
      ContentType := Src.ContentType;
    end;
    inherited Assign(Source);
  finally
    EndUpdate();
  end;
end;

constructor TclSubmitFileRequestItem.Create(AOwner: TclHttpRequestItemList);
begin
  inherited Create(AOwner);
  FContentType := 'application/octet-stream';
end;

function TclSubmitFileRequestItem.GetDataStream: TStream;
var
  stream: TStream;
begin
  if (Request.IsMultiPartContent) then
  begin
    Result := TclMultiStream.Create();
    try
      TclMultiStream(Result).AddStream(TStringStream.Create(
        Format('Content-Disposition: form-data; name="%s"; filename="%s"'#13#10
          + 'Content-Type: %s'#13#10#13#10, [FieldName, ExtractFileName(FileName), ContentType])));

      stream := nil;
      Request.DoLoadData(Self, stream);
      if (stream = nil) then
      begin
        TclMultiStream(Result).AddStream(TFileStream.Create(FileName, fmOpenRead or fmShareDenyNone));
      end else
      begin
        TclMultiStream(Result).AddStream(stream);
      end;
    except
      Result.Free();
      raise;
    end;
  end else
  begin
    Result := TclNullStream.Create();
  end;
end;

procedure TclSubmitFileRequestItem.ReadData(Reader: TReader);
begin
  BeginUpdate();
  try
    inherited ReadData(Reader);
    FieldName := Reader.ReadString();
    FileName := Reader.ReadString();
    ContentType := Reader.ReadString();
  finally
    EndUpdate();
  end;
end;

procedure TclSubmitFileRequestItem.WriteData(Writer: TWriter);
begin
  inherited WriteData(Writer);
  Writer.WriteString(FieldName);
  Writer.WriteString(FileName);
  Writer.WriteString(ContentType);
end;

procedure TclSubmitFileRequestItem.SetContentType(const Value: string);
begin
  if (FContentType <> Value) then
  begin
    FContentType := Value;
    Update();
  end;
end;

procedure TclSubmitFileRequestItem.SetFieldName(const Value: string);
begin
  if (FFieldName <> Value) then
  begin
    FFieldName := Value;
    Update();
  end;
end;

procedure TclSubmitFileRequestItem.SetFileName(const Value: string);
begin
  if (FFileName <> Value) then
  begin
    FFileName := Value;
    Update();
  end;
end;

procedure TclSubmitFileRequestItem.AddData(const AData: TclByteArray; AIndex, ACount: Integer);
var
  stream: TStream;
begin
  if (Request.DataStream = nil) then
  begin
    stream := nil;
    Request.DoSaveData(Self, stream);
    Request.DataStream := stream;
  end;
  if (Request.DataStream <> nil) then
  begin
    Request.DataStream.Write(AData[AIndex], ACount);
  end;
end;

procedure TclSubmitFileRequestItem.AfterAddData;
begin
  if (Request.DataStream <> nil) and Assigned(Request.OnDataAdded) then
  begin
    Request.DataStream.Position := 0;
    Request.DoDataAdded(Self, Request.DataStream);
  end;
end;

procedure TclSubmitFileRequestItem.ParseHeader(AFieldList: TclHeaderFieldList);
var
  s: string;
begin
  BeginUpdate();
  try
    inherited ParseHeader(AFieldList);

    ContentType := AFieldList.GetFieldValue('Content-Type');

    s := AFieldList.GetFieldValue('Content-Disposition');
    FieldName := AFieldList.GetFieldValueItem(s, 'name');
  finally
    EndUpdate();
  end;
end;

{ TclFormFieldRequestItem }

function TclFormFieldRequestItem.GetDataStream: TStream;
var
  buf: TclByteArray;
  s: string;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  Result := TMemoryStream.Create();
  try
    s := GetRequest();
    buf := TclTranslator.GetBytes(s, GetCharSet());
    if (Length(buf) > 0) then
    begin
      Result.Write(buf[0], Length(buf));
    end;
    Result.Position := 0;
  except
    Result.Free();
    raise;
  end;
end;

function TclFormFieldRequestItem.GetRequest(): string;
begin
  Result := '';

  if Request.IsMultiPartContent then
  begin
    Result := Format('Content-Disposition: form-data; name="%s"'#13#10#13#10'%s', [FieldName, FieldValue]);
  end else
  if Request.IsFormFieldRequest then
  begin
    //TODO urlencode (canonicalize) http://en.wikipedia.org/wiki/Percent-encoding
    Result := Format('%s=%s', [GetCanonicalizedValue(FieldName), GetCanonicalizedValue(FieldValue)]);
  end;
end;

procedure TclFormFieldRequestItem.ReadData(Reader: TReader);
begin
  BeginUpdate();
  try
    inherited ReadData(Reader);
    FieldName := Reader.ReadString();
    FieldValue := Reader.ReadString();
  finally
    EndUpdate();
  end;
end;

procedure TclFormFieldRequestItem.WriteData(Writer: TWriter);
begin
  inherited WriteData(Writer);
  Writer.WriteString(FieldName);
  Writer.WriteString(FieldValue);
end;

procedure TclFormFieldRequestItem.Assign(Source: TPersistent);
var
  Src: TclFormFieldRequestItem;
begin
  BeginUpdate();
  try
    if (Source is TclFormFieldRequestItem) then
    begin
      Src := (Source as TclFormFieldRequestItem);
      FieldName :=  Src.FieldName;
      FieldValue := Src.FieldValue;
    end;
    inherited Assign(Source);
  finally
    EndUpdate();
  end;
end;

procedure TclFormFieldRequestItem.SetFieldName(const Value: string);
begin
  if (FFieldName <> Value) then
  begin
    FFieldName := Value;
    Update();
  end;
end;

procedure TclFormFieldRequestItem.SetFieldValue(const Value: string);
begin
  if (FFieldValue <> Value) then
  begin
    FFieldValue := Value;
    Update();
  end;
end;

procedure TclFormFieldRequestItem.AddData(const AData: TclByteArray; AIndex, ACount: Integer);
begin
  FieldValue := FieldValue + TclTranslator.GetString(AData, AIndex, ACount, GetCharSet());
end;

procedure TclFormFieldRequestItem.AfterAddData;
var
  stream: TStream;
  buffer: TclByteArray;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  if Assigned(Request.OnDataAdded) then
  begin
    stream := TMemoryStream.Create();
    try
      if (FieldValue <> '') then
      begin
        buffer := TclTranslator.GetBytes(FieldValue, GetCharSet());
        stream.WriteBuffer(buffer[0], Length(buffer));
        stream.Position := 0;
      end;
      Request.DoDataAdded(Self, stream);
    finally
      stream.Free();
    end;
  end;
end;

{ TclHttpRequestItemList }

function TclHttpRequestItemList.Add(AItemClass: TclHttpRequestItemClass): TclHttpRequestItem;
begin
  Owner.BeginUpdate();
  try
    Result := AItemClass.Create(Self);
  finally
    Owner.EndUpdate();
  end;
end;

procedure TclHttpRequestItemList.AddItem(AItem: TclHttpRequestItem);
begin
  Owner.BeginUpdate();
  try
    FList.Add(AItem);
    Owner.UpdateContentType();
  finally
    Owner.EndUpdate();
  end;
end;

procedure TclHttpRequestItemList.Assign(Source: TPersistent);
var
  i: Integer;
  Item: TclHttpRequestItem;
begin
  Owner.BeginUpdate();
  try
    if (Source is TclHttpRequestItemList) then
    begin
      Clear();
      for i := 0 to TclHttpRequestItemList(Source).Count - 1 do
      begin
        Item := TclHttpRequestItemList(Source).Items[i];
        Add(TclHttpRequestItemClass(Item.ClassType)).Assign(Item);
      end;
    end else
    begin
      inherited Assign(Source);
    end;
  finally
    Owner.EndUpdate();
  end;
end;

procedure TclHttpRequestItemList.Clear;
var
  i: Integer;
begin
  Owner.BeginUpdate();
  try
    for i := 0 to Count - 1 do
    begin
      Items[i].Free();
    end;
    FList.Clear();
    Owner.UpdateContentType();
  finally
    Owner.EndUpdate();
  end;
end;

constructor TclHttpRequestItemList.Create(AOwner: TclHttpRequest);
begin
  inherited Create();

  Assert(AOwner <> nil);
  FOwner := AOwner;
  FList := TList.Create();
end;

procedure TclHttpRequestItemList.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineProperty('Items', ReadData, WriteData, (FList.Count > 0));
end;

procedure TclHttpRequestItemList.Delete(Index: Integer);
begin
  Owner.BeginUpdate();
  try
    FList.Delete(Index);
    Owner.UpdateContentType();
  finally
    Owner.EndUpdate();
  end;
end;

destructor TclHttpRequestItemList.Destroy;
begin
  Clear();
  FList.Free();

  inherited Destroy();
end;

function TclHttpRequestItemList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclHttpRequestItemList.FormFieldByName(const AFieldName: string): TclFormFieldRequestItem;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    if (Items[i] is TclFormFieldRequestItem) then
    begin
      Result := (Items[i] as TclFormFieldRequestItem);
      if (CompareText(Result.FieldName, AFieldName) = 0 )then Exit;
    end;
  end;
  Result := nil;
end;

function TclHttpRequestItemList.GetItem(Index: Integer): TclHttpRequestItem;
begin
  Result := TclHttpRequestItem(FList[Index]);
end;

procedure TclHttpRequestItemList.Move(CurIndex, NewIndex: Integer);
begin
  Owner.BeginUpdate();
  try
    FList.Move(CurIndex, NewIndex);
  finally
    Owner.EndUpdate();
  end;
end;

procedure TclHttpRequestItemList.ReadData(Reader: TReader);
var
  ItemClass: TclHttpRequestItemClass;
begin
  Clear();
  Reader.ReadListBegin();
  while not Reader.EndOfList() do
  begin
    ItemClass := TclHttpRequestItemClass(GetClass(Reader.ReadString()));
    if (ItemClass <> nil) then
    begin
      Add(ItemClass).ReadData(Reader);
    end;
  end;
  Reader.ReadListEnd();
end;

procedure TclHttpRequestItemList.WriteData(Writer: TWriter);
var
  i: Integer;
begin
  Writer.WriteListBegin();
  for i := 0 to Count - 1 do
  begin
    Writer.WriteString(Items[i].ClassName);
    Items[i].WriteData(Writer);
  end;
  Writer.WriteListEnd();
end;

initialization
  RegisterHttpRequestItem(TclBinaryRequestItem);
  RegisterHttpRequestItem(TclTextRequestItem);
  RegisterHttpRequestItem(TclSubmitFileRequestItem);
  RegisterHttpRequestItem(TclFormFieldRequestItem);
  InitStaticVars();

finalization
  RegisteredHttpRequestItems.Free();
  UnsafeChars := nil;

end.

