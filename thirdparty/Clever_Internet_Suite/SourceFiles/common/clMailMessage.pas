{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clMailMessage;

interface
                                                        
{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,{$IFDEF DEMO} Forms,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,{$IFDEF DEMO} Vcl.Forms,{$ENDIF}
{$ENDIF}
  clMailHeader, clEncoder, clEmailAddress, clWUtils, clDkim;

type
  TclMessagePriority = (mpLow, mpNormal, mpHigh);
  TclMessageFormat = (mfNone, mfMIME, mfUUencode);

  TclMailMessage = class;
  TclMessageBodies = class;
  TclMessageBody = class;
  TclAttachmentBody = class;

  TclGetBodyStreamEvent = procedure (Sender: TObject; ABody: TclAttachmentBody;
    var AFileName: string; var AData: TStream; var Handled: Boolean) of object;

  TclAttachmentSavedEvent = procedure (Sender: TObject; ABody: TclAttachmentBody; const AFileName: string; AData: TStream) of object;

  TclBodyDataAddedEvent = procedure (Sender: TObject; ABody: TclMessageBody; AData: TStream) of object;

  TclBodyEncodingProgress = procedure (Sender: TObject; ABody: TclMessageBody; ABytesProceed, ATotalBytes: Int64) of object;

  TclMessageBody = class(TPersistent)
  private
    FOwner: TclMessageBodies;
    FContentType: string;
    FEncoding: TclEncodeMethod;
    FEncoder: TclEncoder;
    FContentDisposition: string;
    FExtraFields: TStrings;
    FKnownFields: TStrings;
    FRawHeader: TStrings;
    FEncodedSize: Integer;
    FEncodedLines: Integer;
    FEncodedStart: Integer;
    FRawStart: Integer;

    procedure SetContentDisposition(const Value: string);
    procedure SetEncoding(const Value: TclEncodeMethod);
    procedure DoOnListChanged(Sender: TObject);
    procedure DoOnEncoderProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
    function GetIndex: Integer;
    procedure SetExtraFields(const Value: TStrings);
  protected
    procedure SetContentType(const Value: string); virtual;
    procedure SetListChangedEvent(AList: TStringList);
    function GetMailMessage: TclMailMessage;
    procedure ReadData(Reader: TReader); virtual;
    procedure WriteData(Writer: TWriter); virtual;
    function HasEncodedData: Boolean; virtual;
    procedure AddData(AData: TStream; AEncodedLines: Integer);
    function GetData: TStream;
    function GetEncoding: TclEncodeMethod; virtual;
    procedure AssignBodyHeader(AFieldList: TclMailHeaderFieldList); virtual;
    procedure ParseBodyHeader(AFieldList: TclMailHeaderFieldList); virtual;
    function GetSourceStream: TStream; virtual; abstract;
    function GetDestinationStream: TStream; virtual; abstract;
    procedure BeforeDataAdded(AData: TStream); virtual;
    procedure DataAdded(AData: TStream); virtual;
    procedure DecodeData(ASource, ADestination: TStream); virtual;
    procedure EncodeData(ASource, ADestination: TStream); virtual;
    procedure DoCreate; virtual;
    procedure AssignEncodingIfNeed; virtual;

    procedure RegisterField(const AField: string);
    procedure RegisterFields; virtual;
    property KnownFields: TStrings read FKnownFields;
  public
    constructor Create(AOwner: TclMessageBodies); virtual;
    destructor Destroy(); override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear(); virtual;

    property RawHeader: TStrings read FRawHeader;
    property MailMessage: TclMailMessage read GetMailMessage;
    property ContentType: string read FContentType write SetContentType;
    property ContentDisposition: string read FContentDisposition write SetContentDisposition;
    property Encoding: TclEncodeMethod read GetEncoding write SetEncoding;
    property Index: Integer read GetIndex;
    property ExtraFields: TStrings read FExtraFields write SetExtraFields;
    property EncodedSize: Integer read FEncodedSize;
    property EncodedLines: Integer read FEncodedLines;
    property EncodedStart: Integer read FEncodedStart;
    property RawStart: Integer read FRawStart;
  end;

  TclMessageBodyClass = class of TclMessageBody;

  TclTextBody = class(TclMessageBody)
  private
    FCharSet: string;
    FStrings: TStrings;

    procedure SetStrings(const Value: TStrings);
    procedure SetCharSet(const Value: string);
    procedure DoOnStringsChanged(Sender: TObject);
    function GetCharSet: string;
  protected
    procedure ReadData(Reader: TReader); override;
    procedure WriteData(Writer: TWriter); override;
    procedure AssignBodyHeader(AFieldList: TclMailHeaderFieldList); override;
    procedure ParseBodyHeader(AFieldList: TclMailHeaderFieldList); override;
    function GetSourceStream: TStream; override;
    function GetDestinationStream: TStream; override;
    procedure DataAdded(AData: TStream); override;
    procedure DoCreate; override;
  public
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear; override;
    property Strings: TStrings read FStrings write SetStrings;
    property CharSet: string read GetCharSet write SetCharSet;
  end;

  TclMultipartBody = class(TclMessageBody)
  private
    FSelfMailMessage: TclMailMessage;
    FContentSubType: string;

    procedure SetBodies(const Value: TclMessageBodies);
    procedure SetBoundary(const Value: string);
    procedure SetContentSubType(const Value: string);
    function GetBoundary: string;
    procedure DoOnSaveAttachment(Sender: TObject; ABody: TclAttachmentBody;
      var AFileName: string; var AStream: TStream; var Handled: Boolean);
    procedure DoOnLoadAttachment(Sender: TObject; ABody: TclAttachmentBody;
      var AFileName: string; var AStream: TStream; var Handled: Boolean);
    procedure DoOnAttachmentSaved(Sender: TObject; ABody: TclAttachmentBody; const AFileName: string; AData: TStream);
    procedure DoOnDataAdded(Sender: TObject; ABody: TclMessageBody; AData: TStream);
    procedure FixRawBodyStart(ABodies: TclMessageBodies);
    function GetBodies: TclMessageBodies;
  protected
    procedure SetContentType(const Value: string); override;
    procedure ReadData(Reader: TReader); override;
    procedure WriteData(Writer: TWriter); override;
    function HasEncodedData: Boolean; override;
    procedure AssignBodyHeader(AFieldList: TclMailHeaderFieldList); override;
    procedure ParseBodyHeader(AFieldList: TclMailHeaderFieldList); override;
    function GetSourceStream: TStream; override;
    function GetDestinationStream: TStream; override;
    procedure DataAdded(AData: TStream); override;
    procedure DoCreate; override;
  public
    destructor Destroy(); override;
    procedure Assign(Source: TPersistent); override;
    procedure Clear(); override;
    property Boundary: string read GetBoundary;
    property Bodies: TclMessageBodies read GetBodies write SetBodies;
    property ContentSubType: string read FContentSubType write SetContentSubType;
  end;

  TclAttachmentBody = class(TclMessageBody)
  private
    FContentID: string;
    FFileName: string;
    FCheckFileExists: Boolean;

    procedure SetContentID(const Value: string);
    function GetContentID(AFieldList: TclMailHeaderFieldList): string;
    function GetMessageRfc822FileName(ABodyPos: Integer; ASource: TStrings): string;
  protected
    procedure SetFileName(const Value: string); virtual;
    procedure DataAdded(AData: TStream); override;
    procedure ReadData(Reader: TReader); override;
    procedure WriteData(Writer: TWriter); override;
    function GetEncoding: TclEncodeMethod; override;
    procedure AssignBodyHeader(AFieldList: TclMailHeaderFieldList); override;
    procedure ParseBodyHeader(AFieldList: TclMailHeaderFieldList); override;
    function GetSourceStream: TStream; override;
    function GetDestinationStream: TStream; override;
    procedure RegisterFields; override;
    procedure AssignEncodingIfNeed; override;
  public
    procedure Assign(Source: TPersistent); override;
    procedure Clear(); override;
    property FileName: string read FFileName write SetFileName;
    property ContentID: string read FContentID write SetContentID;
  end;

  TclAttachmentBodyClass = class of TclAttachmentBody;

  TclImageBody = class(TclAttachmentBody)
  private
    function GetUniqueContentID(const AFileName: string): string;
    function GetFileType(const AFileName: string): string;
  protected
    procedure SetFileName(const Value: string); override;
    procedure AssignBodyHeader(AFieldList: TclMailHeaderFieldList); override;
    procedure ParseBodyHeader(AFieldList: TclMailHeaderFieldList); override;
  public
    procedure Clear(); override;
  end;

  TclMessageBodies = class(TPersistent)
  private
    FOwner: TclMailMessage;
    FList: TList;

    function GetItem(Index: Integer): TclMessageBody;
    function GetCount: Integer;
    procedure AddItem(AItem: TclMessageBody);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadData(Reader: TReader); virtual;
    procedure WriteData(Writer: TWriter); virtual;
  public
    constructor Create(AOwner: TclMailMessage);
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    function Add(AItemClass: TclMessageBodyClass): TclMessageBody;

    function AddText(const AText: string): TclTextBody;
    function AddHtml(const AText: string): TclTextBody;
    function AddMultipart: TclMultipartBody;
    function AddAttachment(const AFileName: string): TclAttachmentBody;
    function AddImage(const AFileName: string): TclImageBody;

    procedure Delete(Index: Integer);
    procedure Move(CurIndex, NewIndex: Integer);
    procedure Clear;
    property Items[Index: Integer]: TclMessageBody read GetItem; default;
    property Count: Integer read GetCount;
    property Owner: TclMailMessage read FOwner;
  end;

  TclAttachmentList = class
  private
    FList: TList;
    function GetCount: Integer;
  protected
    procedure Clear;
    procedure Add(AItem: TclAttachmentBody);
    function GetItem(Index: Integer): TclAttachmentBody;
  public
    constructor Create;
    destructor Destroy; override;

    property Items[Index: Integer]: TclAttachmentBody read GetItem; default;
    property Count: Integer read GetCount;
  end;

  TclImageList = class(TclAttachmentList)
  private
    function GetItem(Index: Integer): TclImageBody;
  public
    property Items[Index: Integer]: TclImageBody read GetItem; default;
  end;

  TclMailMessage = class(TComponent)
  private
    FCharSet: string;
    FSubject: string;
    FPriority: TclMessagePriority;
    FDate: TDateTime;
    FBodies: TclMessageBodies;
    FBCCList: TclEmailAddressList;
    FCCList: TclEmailAddressList;
    FToList: TclEmailAddressList;
    FFrom: TclEmailAddressItem;
    FMessageFormat: TclMessageFormat;
    FBoundary: string;
    FEncoding: TclEncodeMethod;
    FHeaderEncoding: TclEncodeMethod;
    FUpdateCount: Integer;
    FDataStream: TMemoryStream;
    FIsParse: Integer;
    FContentType: string;
    FContentSubType: string;
    FHeaderSource: TStrings;
    FBodiesSource: TStrings;
    FMessageSource: TStrings;
    FIncludeRFC822Header: Boolean;
    FReplyTo: string;
    FMessageID: string;
    FExtraFields: TStrings;
    FNewsGroups: TStrings;
    FReferences: TStrings;
    FLinesFieldPos: Integer;
    FReadReceiptTo: string;
    FContentDisposition: string;
    FKnownFields: TStrings;
    FMimeOLE: string;
    FRawHeader: TStrings;
    FCharsPerLine: Integer;
    FEncodedStart: Integer;
    FAttachmentList: TclAttachmentList;
    FImageList: TclImageList;
    FEmptyList: TStrings;

    FOnChanged: TNotifyEvent;
    FOnSaveAttachment: TclGetBodyStreamEvent;
    FOnLoadAttachment: TclGetBodyStreamEvent;
    FOnDataAdded: TclBodyDataAddedEvent;
    FOnAttachmentSaved: TclAttachmentSavedEvent;
    FOnEncodingProgress: TclBodyEncodingProgress;
    FAllowESC: Boolean;
    FDateZoneBias: TDateTime;
    FDkim: TclDkim;
    FListUnsubscribe: string;

    procedure InternalParseHeader(ASource: TStrings);
    function ParseBodyHeader(AStartFrom: Integer; ASource: TStrings): TclMessageBody;
    procedure AssignBodyHeader(AStartFrom: Integer; ASource: TStrings; ABody: TclMessageBody);
    procedure AfterAddData(ABody: TclMessageBody; AEncodedLines: Integer);
    procedure GetBodyFromSource(const ASource: string);
    procedure AddBodyToSource(ASource: TStrings; ABody: TclMessageBody);
    procedure SetBCCList(const Value: TclEmailAddressList);
    procedure SetBodies(const Value: TclMessageBodies);
    procedure SetCCList(const Value: TclEmailAddressList);
    procedure SetToList(const Value: TclEmailAddressList);
    procedure SetCharSet(const Value: string);
    procedure SetDate(const Value: TDateTime);
    procedure SetEncoding(const Value: TclEncodeMethod);
    procedure SetHeaderEncoding(const Value: TclEncodeMethod);
    procedure SetFrom(Value: TclEmailAddressItem);
    procedure SetMessageFormat(const Value: TclMessageFormat);
    procedure SetPriority(const Value: TclMessagePriority);
    procedure SetSubject(const Value: string);
    procedure SetContentSubType(const Value: string);
    procedure DoOnListChanged(Sender: TObject);
    function BuildImages(ABodies: TclMessageBodies; const AText, AHtml: string; AImages: TStrings): string;
    function BuildAlternative(ABodies: TclMessageBodies; const AText, AHtml: string): string;
    procedure BuildAttachments(ABodies: TclMessageBodies; Attachments: TStrings);
    function GetHeaderSource: TStrings;
    function GetBodiesSource: TStrings;
    function GetMessageSource: TStrings;
    procedure SetHeaderSource(const Value: TStrings);
    procedure SetMessageSource(const Value: TStrings);
    procedure SetIncludeRFC822Header(const Value: Boolean);
    procedure SetCharsPerLine(const Value: Integer);
    procedure ParseDate(AFieldList: TclMailHeaderFieldList; var ADate, ADateZoneBias: TDateTime);
    procedure SetExtraFields(const Value: TStrings);
    procedure SetNewsGroups(const Value: TStrings);
    procedure SetReferences(const Value: TStrings);
    procedure SetReplyTo(const Value: string);
    function BuildDelimitedField(AValues: TStrings; const ADelimiter: string): string;
		procedure GetBodyList(ABodies: TclMessageBodies; ABodyType: TclAttachmentBodyClass; AList: TclAttachmentList);
    procedure SetReadReceiptTo(const Value: string);
    procedure SetMessageID(const Value: string);
    procedure SetContentDisposition(const Value: string);
    procedure SetListUnsubscribe(const Value: string);
    function IsUUEBodyStart(const ALine: string; var AFileName: string): Boolean;
    function IsUUEBodyEnd(const ALine: string): Boolean;
    procedure SetMimeOLE(const Value: string);
    procedure SetAllowESC(const Value: Boolean);
    procedure SetISO2022JP;

    function GetAttachments: TclAttachmentList;
    function GetHtml: TclTextBody;
    function GetImages: TclImageList;
    function GetMessageText: TStrings;
    function GetText: TclTextBody;
    function GetCalendar: TclTextBody;
    function GetIsParse: Boolean;
    function GetDateUTC: TDateTime;
    procedure SetDkim(const Value: TclDkim);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure BeginParse;
    procedure EndParse;
    procedure SafeClear; virtual;
    function GetHeaderEncoding: TclEncodeMethod;
    procedure SetContentType(const Value: string);
    procedure SetBoundary(const Value: string);
    procedure ParseBodies(ASource: TStrings);
    function ParseAllHeaders(AStartFrom: Integer; ASource, AHeaders: TStrings): Integer;
    procedure ParseExtraFields(AHeader, AKnownFields, AExtraFields: TStrings);
    procedure InternalAssignBodies(ASource: TStrings);
    procedure InternalAssignHeader(ASource: TStrings);
    procedure GenerateBoundary;
    function CreateBody(ABodies: TclMessageBodies;
      const AContentType, ADisposition: string): TclMessageBody; virtual;
    function CreateSingleBody(ASource: TStrings; ABodies: TclMessageBodies): TclMessageBody; virtual;
    function CreateUUEAttachmentBody(ABodies: TclMessageBodies;
      const AFileName: string): TclAttachmentBody; virtual;

    procedure Changed; virtual;
    procedure DoSaveAttachment(ABody: TclAttachmentBody;
      var AFileName: string; var AData: TStream; var Handled: Boolean); virtual;
    procedure DoLoadAttachment(ABody: TclAttachmentBody;
      var AFileName: string; var AData: TStream; var Handled: Boolean); virtual;
    procedure DoAttachmentSaved(ABody: TclAttachmentBody; const AFileName: string; AData: TStream); virtual;
    procedure DoDataAdded(ABody: TclMessageBody; AData: TStream); virtual;
    procedure DoEncodingProgress(ABody: TclMessageBody; ABytesProceed, ATotalBytes: Int64); virtual;

    procedure Loaded; override;
    procedure ParseContentType(AFieldList: TclMailHeaderFieldList); virtual;
    procedure ParseMimeHeader(AFieldList: TclMailHeaderFieldList);
    procedure AssignContentType(AFieldList: TclMailHeaderFieldList); virtual;
    function GetIsMultiPartContent: Boolean; virtual;
    procedure RegisterField(const AField: string);
    procedure RegisterFields; virtual;
    property KnownFields: TStrings read FKnownFields;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Clear; virtual;
    procedure Update;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure BuildMessage(const AText, AHtml: string; AImages, Attachments: TStrings); overload;
    procedure BuildMessage(const AText, AHtml: string; const AImages, Attachments: array of string); overload;
    procedure BuildMessage(const AText: string; Attachments: TStrings); overload;
    procedure BuildMessage(const AText: string; const Attachments: array of string); overload;
    procedure BuildMessage(const AText, AHtml: string); overload;

    procedure LoadMessage(const AFileName: string); overload;
    procedure LoadMessage(const AFileName, ACharSet: string); overload;
    procedure LoadMessage(AStream: TStream); overload;
    procedure LoadMessage(AStream: TStream; const ACharSet: string); overload;

    procedure LoadHeader(const AFileName: string); overload;
    procedure LoadHeader(const AFileName, ACharSet: string); overload;
    procedure LoadHeader(AStream: TStream); overload;
    procedure LoadHeader(AStream: TStream; const ACharSet: string); overload;

    procedure SaveMessage(const AFileName: string); overload;
    procedure SaveMessage(const AFileName, ACharSet: string); overload;
    procedure SaveMessage(AStream: TStream); overload;
    procedure SaveMessage(AStream: TStream; const ACharSet: string); overload;

    procedure SaveHeader(const AFileName: string); overload;
    procedure SaveHeader(const AFileName, ACharSet: string); overload;
    procedure SaveHeader(AStream: TStream); overload;
    procedure SaveHeader(AStream: TStream; const ACharSet: string); overload;

    procedure SaveBodies(const AFileName: string); overload;
    procedure SaveBodies(const AFileName, ACharSet: string); overload;
    procedure SaveBodies(AStream: TStream); overload;
    procedure SaveBodies(AStream: TStream; const ACharSet: string); overload;

    function GetTextBody(ABodies: TclMessageBodies; const AContentType: string): TclTextBody;

    property RawHeader: TStrings read FRawHeader;
    property EncodedStart: Integer read FEncodedStart;
    property IsMultiPartContent: Boolean read GetIsMultiPartContent;
    property IsParse: Boolean read GetIsParse;
    property Boundary: string read FBoundary;
    property HeaderSource: TStrings read GetHeaderSource write SetHeaderSource;
    property BodiesSource: TStrings read GetBodiesSource;
    property MessageSource: TStrings read GetMessageSource write SetMessageSource;
    property IncludeRFC822Header: Boolean read FIncludeRFC822Header write SetIncludeRFC822Header;

    property Text: TclTextBody read GetText;
    property Html: TclTextBody read GetHtml;
    property Calendar: TclTextBody read GetCalendar;
    property Attachments: TclAttachmentList read GetAttachments;
    property Images: TclImageList read GetImages;
    property MessageText: TStrings read GetMessageText;
    property DateZoneBias: TDateTime read FDateZoneBias;
    property DateUTC: TDateTime read GetDateUTC;
  published
    property Bodies: TclMessageBodies read FBodies write SetBodies;
    property Subject: string read FSubject write SetSubject;
    property From: TclEmailAddressItem read FFrom write SetFrom;
    property ToList: TclEmailAddressList read FToList write SetToList;
    property CCList: TclEmailAddressList read FCCList write SetCCList;
    property BCCList: TclEmailAddressList read FBCCList write SetBCCList;
    property Priority: TclMessagePriority read FPriority write SetPriority default mpNormal;
    property Date: TDateTime read FDate write SetDate;
    property CharSet: string read FCharSet write SetCharSet;
    property ContentType: string read FContentType write SetContentType;
    property ContentSubType: string read FContentSubType write SetContentSubType;
    property ContentDisposition: string read FContentDisposition write SetContentDisposition;
    property MessageFormat: TclMessageFormat read FMessageFormat write SetMessageFormat default mfNone;
    property Encoding: TclEncodeMethod read FEncoding write SetEncoding default cmNone;
    property HeaderEncoding: TclEncodeMethod read FHeaderEncoding write SetHeaderEncoding default cmNone;
    property MimeOLE: string read FMimeOLE write SetMimeOLE;
    property ReplyTo: string read FReplyTo write SetReplyTo;
    property References: TStrings read FReferences write SetReferences;
    property NewsGroups: TStrings read FNewsGroups write SetNewsGroups;
    property ExtraFields: TStrings read FExtraFields write SetExtraFields;
    property ReadReceiptTo: string read FReadReceiptTo write SetReadReceiptTo;
    property MessageID: string read FMessageID write SetMessageID;
    property ListUnsubscribe: string read FListUnsubscribe write SetListUnsubscribe;
    property CharsPerLine: Integer read FCharsPerLine write SetCharsPerLine default DefaultCharsPerLine;
    property AllowESC: Boolean read FAllowESC write SetAllowESC default False;

    property Dkim: TclDkim read FDkim write SetDkim;

    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnSaveAttachment: TclGetBodyStreamEvent read FOnSaveAttachment write FOnSaveAttachment;
    property OnLoadAttachment: TclGetBodyStreamEvent read FOnLoadAttachment write FOnLoadAttachment;
    property OnAttachmentSaved: TclAttachmentSavedEvent read FOnAttachmentSaved write FOnAttachmentSaved;
    property OnDataAdded: TclBodyDataAddedEvent read FOnDataAdded write FOnDataAdded;
    property OnEncodingProgress: TclBodyEncodingProgress read FOnEncodingProgress write FOnEncodingProgress;
  end;

procedure RegisterBody(AMessageBodyClass: TclMessageBodyClass);
function GetRegisteredBodyItems: TList;
function NormalizeFilePath(const APath: string; const AReplaceWith: string = '_'): string;

const
  DefaultContentType = 'text/plain';
  DefaultCharSet = 'iso-8859-1';
  ISO2022JP = 'iso-2022-jp';

{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsMailMessageDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

implementation

uses
  clUtils, clTranslator{$IFDEF LOGGER}, clLogger{$ENDIF};

const
  ImportanceMap: array[TclMessagePriority] of string = ('Low', '', 'High');
  PiorityMap: array[TclMessagePriority] of string = ('5', '', '1');
  EncodingMap: array[TclEncodeMethod] of string = ('7bit', 'quoted-printable', 'base64', '', '8bit');
  MessageFormatMap: array[Boolean] of TclMessageFormat = (mfUUencode, mfMIME);

var
  RegisteredBodyItems: TList = nil;

procedure RegisterBody(AMessageBodyClass: TclMessageBodyClass);
begin
  GetRegisteredBodyItems().Add(AMessageBodyClass);
  {$IFDEF DELPHIXE2}System.{$ENDIF}Classes.RegisterClass(AMessageBodyClass);
end;

function GetRegisteredBodyItems: TList;
begin
  if (RegisteredBodyItems = nil) then
  begin
    RegisteredBodyItems := TList.Create();
  end;
  Result := RegisteredBodyItems;
end;

function NormalizeFilePath(const APath, AReplaceWith: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(APath) do
  begin
    if CharInSet(APath[i], ['"', '*', '/', ':', '<', '>', '?', '\', '|', #0]) then
    begin
      Result := Result + AReplaceWith;
    end else
    begin
      Result := Result + APath[i];
    end;
  end;

  if (Length(Result) > 0) and CharInSet(Result[Length(Result)], [' ', '.']) then
  begin
    Delete(Result, Length(Result), 1);
    if (Result = '') then
    begin
      Result := AReplaceWith;
    end;
  end;
end;

{ TclMessageBodies }

function TclMessageBodies.AddAttachment(const AFileName: string): TclAttachmentBody;
begin
  Result := TclAttachmentBody.Create(Self);
  Result.FileName := AFileName;
end;

function TclMessageBodies.AddHtml(const AText: string): TclTextBody;
begin
  Result := AddText(AText);
  Result.ContentType := 'text/html';
end;

function TclMessageBodies.AddImage(const AFileName: string): TclImageBody;
begin
  Result := TclImageBody.Create(Self);
  Result.FileName := AFileName;
end;

procedure TclMessageBodies.AddItem(AItem: TclMessageBody);
begin
  FList.Add(AItem);
  Owner.Update();
end;

function TclMessageBodies.Add(AItemClass: TclMessageBodyClass): TclMessageBody;
begin
  Result := AItemClass.Create(Self);
end;

function TclMessageBodies.AddMultipart: TclMultipartBody;
begin
  Result := TclMultipartBody.Create(Self);
end;

function TclMessageBodies.AddText(const AText: string): TclTextBody;
begin
  Result := TclTextBody.Create(Self);
  Result.Strings.Text := AText;
end;

procedure TclMessageBodies.Assign(Source: TPersistent);
var
  i: Integer;
  Item: TclMessageBody;
begin
  Owner.BeginUpdate();
  try
    if (Source is TclMessageBodies) then
    begin
      Clear();
      for i := 0 to TclMessageBodies(Source).Count - 1 do
      begin
        Item := TclMessageBodies(Source).Items[i];
        Add(TclMessageBodyClass(Item.ClassType)).Assign(Item);
      end;
    end else
    begin
      inherited Assign(Source);
    end;
  finally
    Owner.EndUpdate();
  end;
end;

procedure TclMessageBodies.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Items[i].Free();
  end;
  FList.Clear();
  Owner.Update();
end;

constructor TclMessageBodies.Create(AOwner: TclMailMessage);
begin
  inherited Create();
  Assert(AOwner <> nil);
  FOwner := AOwner;
  FList := TList.Create();
end;

procedure TclMessageBodies.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty('Items', ReadData, WriteData, (FList.Count > 0));
end;

procedure TclMessageBodies.Delete(Index: Integer);
begin
  Items[Index].Free();
  FList.Delete(Index);
  Owner.Update();
end;

destructor TclMessageBodies.Destroy;
begin
  Clear();
  FList.Free();
  inherited Destroy();
end;

function TclMessageBodies.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclMessageBodies.GetItem(Index: Integer): TclMessageBody;
begin
  Result := TclMessageBody(FList[Index]);
end;

procedure TclMessageBodies.Move(CurIndex, NewIndex: Integer);
begin
  FList.Move(CurIndex, NewIndex);
  Owner.Update();
end;

procedure TclMessageBodies.ReadData(Reader: TReader);
var
  ItemClass: TclMessageBodyClass;
begin
  Clear();
  Reader.ReadListBegin();
  while not Reader.EndOfList() do
  begin
    ItemClass := TclMessageBodyClass(GetClass(Reader.ReadString()));
    if (ItemClass <> nil) then
    begin
      Add(ItemClass).ReadData(Reader);
    end;
  end;
  Reader.ReadListEnd();
end;

procedure TclMessageBodies.WriteData(Writer: TWriter);
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

{ TclMailMessage }

procedure TclMailMessage.GenerateBoundary;
begin
  SetBoundary('Mark=_' + IntToStr(Integer(GetTickCount())) + IntToStr(Integer(GetTickCount()) div 2) + IntToStr(Random(1000)));
end;

procedure TclMailMessage.AssignContentType(AFieldList: TclMailHeaderFieldList);
var
  s: string;
begin
  if (MessageFormat = mfUUencode) then Exit;

  s := Trim(ContentType);
  if IsMultiPartContent then
  begin
    if (s = '') then
    begin
      s := 'multipart/mixed';
    end;

    AFieldList.AddField('Content-Type', s);

    if (ContentSubType <> '') then
    begin
      AFieldList.AddQuotedFieldItem('Content-Type', 'type', ContentSubType);
    end;

    AFieldList.AddQuotedFieldItem('Content-Type', 'boundary', Boundary);
  end else
  begin
    if (s = '') then
    begin
      s := 'text/plain';
    end;

    AFieldList.AddField('Content-Type', s);

    if (CharSet <> '') then
    begin
      AFieldList.AddQuotedFieldItem('Content-Type', 'charset', CharSet);
    end;
  end;
end;

function TclMailMessage.BuildDelimitedField(AValues: TStrings; const ADelimiter: string): string;
var
  i: Integer;
  Comma: array[Boolean] of string;
begin
  Result := '';
  Comma[False] := '';
  Comma[True] := ADelimiter;

  for i := 0 to AValues.Count - 1 do
  begin
    Result := Result + Comma[i > 0] + AValues[i];
  end;
end;

procedure TclMailMessage.InternalAssignHeader(ASource: TStrings);
var
  fieldList: TclMailHeaderFieldList;
  enc: TclEncodeMethod;
begin
  fieldList := TclMailHeaderFieldList.Create(CharSet, GetHeaderEncoding(), CharsPerLine);
  try
    fieldList.Parse(0, ASource);

    GenerateBoundary();
    if IncludeRFC822Header then
    begin
      fieldList.AddField('Message-ID', MessageID);
      fieldList.AddEncodedEmail('From', From.FullAddress);
      fieldList.AddEncodedEmail('Reply-To', ReplyTo);
      fieldList.AddField('Newsgroups', BuildDelimitedField(NewsGroups, ','));
      fieldList.AddField('References', BuildDelimitedField(References, #32));
      fieldList.AddEncodedEmailList('To', ToList);
      fieldList.AddEncodedEmailList('Cc', CCList);
      fieldList.AddEncodedEmailList('Bcc', BCCList);
      fieldList.AddEncodedField('Subject', Subject);
      fieldList.AddField('Date', DateTimeToMimeTime(Self.Date));
      FLinesFieldPos := ASource.Count;
      if (MessageFormat <> mfUUencode) then
      begin
        fieldList.AddField('MIME-Version', '1.0');
      end;
    end;

    AssignContentType(fieldList);

    fieldList.AddField('Content-Disposition', ContentDisposition);

    if not IsMultiPartContent then
    begin
      enc := Encoding;
      if (enc = cmNone) and (Bodies.Count = 1) then
      begin
        enc := Bodies[0].Encoding;
      end;
      fieldList.AddField('Content-Transfer-Encoding', EncodingMap[enc]);
    end;
    if IncludeRFC822Header then
    begin
      fieldList.AddField('Importance', ImportanceMap[Priority]);
      fieldList.AddField('X-Priority', PiorityMap[Priority]);
      fieldList.AddField('X-MimeOLE', MimeOLE);
      fieldList.AddEncodedEmail('Disposition-Notification-To', ReadReceiptTo);
      fieldList.AddNonFoldedField('List-Unsubscribe', ListUnsubscribe);
      fieldList.AddFields(ExtraFields);
    end;
    fieldList.AddEndOfHeader();
  finally
    fieldList.Free();
  end;
end;

function TclMailMessage.ParseAllHeaders(AStartFrom: Integer; ASource, AHeaders: TStrings): Integer;
var
  i: Integer;
begin
  Result := AStartFrom;
  AHeaders.Clear();
  for i := AStartFrom to ASource.Count - 1 do
  begin
    Result := i;
    if (ASource[i] = '') then Break;
    AHeaders.Add(ASource[i]);
  end;
end;

procedure TclMailMessage.ParseContentType(AFieldList: TclMailHeaderFieldList);
var
  s, chrset: string;
begin
  s := AFieldList.GetFieldValue('Content-Type');
  MessageFormat := MessageFormatMap[(s <> '') or (AFieldList.GetFieldValue('MIME-Version') <> '')];
  ContentType := AFieldList.GetFieldValueItem(s, '');
  ContentSubType := AFieldList.GetFieldValueItem(s, 'type');
  SetBoundary(AFieldList.GetFieldValueItem(s, 'boundary'));
  chrset := AFieldList.GetFieldValueItem(s, 'charset');
  if (chrset <> '') then
  begin
    CharSet := chrset;
    AFieldList.CharSet := CharSet;
  end;
end;

procedure TclMailMessage.ParseMimeHeader(AFieldList: TclMailHeaderFieldList);
var
  s: string;
begin
  BeginParse();
  try
    ParseContentType(AFieldList);

    s := AFieldList.GetFieldValue('Content-Disposition');
    ContentDisposition := AFieldList.GetFieldValueItem(s, '');

    s := LowerCase(AFieldList.GetFieldValue('Content-Transfer-Encoding'));
    Encoding := cmNone;
    if (s = 'quoted-printable') then
    begin
      Encoding := cmQuotedPrintable;
    end else
    if (s = 'base64') then
    begin
      Encoding := cmBase64;
    end;
    AFieldList.Encoding := GetHeaderEncoding();
  finally
    EndParse();
  end;
end;

function TclMailMessage.GetIsParse: Boolean;
begin
  Result := (FIsParse > 0);
end;

procedure TclMailMessage.InternalParseHeader(ASource: TStrings);
  procedure AssignPriority(const ASource, ALowLexem, AHighLexem: string);
  begin
    if (Priority <> mpNormal) or (ASource = '') then Exit;
    if (LowerCase(ASource) = LowerCase(ALowLexem)) then
    begin
      Priority := mpLow;
    end else
    if (LowerCase(ASource) = LowerCase(AHighLexem)) then
    begin
      Priority := mpHigh;
    end;
  end;

var
  FieldList: TclMailHeaderFieldList;
begin
  BeginParse();
  FieldList := nil;
  try
    FieldList := TclMailHeaderFieldList.Create(CharSet, GetHeaderEncoding(), CharsPerLine);

    FieldList.Parse(0, ASource);
    ParseMimeHeader(FieldList);

    From.FullAddress := FieldList.GetDecodedEmail('From');
    FieldList.GetDecodedEmailList('To', ToList);
    FieldList.GetDecodedEmailList('Cc', CCList);
    FieldList.GetDecodedEmailList('Bcc', BCCList);

    Subject := FieldList.GetDecodedFieldValue('Subject');

    try
      ParseDate(FieldList, FDate, FDateZoneBias);
    except
    end;

    AssignPriority(FieldList.GetFieldValue('Importance'), 'Low', 'High');
    AssignPriority(FieldList.GetFieldValue('X-Priority'), '5', '1');
    AssignPriority(FieldList.GetFieldValue('X-MSMail-Priority'), 'Low', 'High');

    ReplyTo := FieldList.GetDecodedEmail('Reply-To');
    ReadReceiptTo := FieldList.GetDecodedEmail('Disposition-Notification-To');
    ListUnsubscribe := FieldList.GetDecodedEmail('List-Unsubscribe');
    MessageID := FieldList.GetFieldValue('Message-ID');
    SplitText(FieldList.GetFieldValue('Newsgroups'), NewsGroups, ',');
    SplitText(FieldList.GetFieldValue('References'), References, #32);
    MimeOLE := FieldList.GetFieldValue('X-MimeOLE');

    FEncodedStart := ParseAllHeaders(0, ASource, RawHeader) + 1;
    ParseExtraFields(RawHeader, FKnownFields, ExtraFields);
  finally
    FieldList.Free();
    EndParse();
  end;
end;

procedure TclMailMessage.RegisterField(const AField: string);
begin
  if (FindInStrings(FKnownFields, AField) < 0) then
  begin
    FKnownFields.Add(AField);
  end;
end;

procedure TclMailMessage.RegisterFields;
begin
  RegisterField('Content-Type');
  RegisterField('Content-Disposition');
  RegisterField('Content-Transfer-Encoding');
  RegisterField('From');
  RegisterField('To');
  RegisterField('Cc');
  RegisterField('Bcc');
  RegisterField('Subject');
  RegisterField('Date');
  RegisterField('Importance');
  RegisterField('X-Priority');
  RegisterField('X-MSMail-Priority');
  RegisterField('X-MimeOLE');
  RegisterField('Reply-To');
  RegisterField('Disposition-Notification-To');
  RegisterField('Message-ID');
  RegisterField('MIME-Version');
  RegisterField('Newsgroups');
  RegisterField('References');
end;

procedure TclMailMessage.ParseExtraFields(AHeader, AKnownFields, AExtraFields: TStrings);
var
  i: Integer;
  FieldList: TclMailHeaderFieldList;
begin
  FieldList := TclMailHeaderFieldList.Create(CharSet, GetHeaderEncoding(), CharsPerLine);
  try
    AExtraFields.Clear();

    FieldList.Parse(0, AHeader);

    for i := 0 to FieldList.FieldList.Count - 1 do
    begin
      if (FindInStrings(AKnownFields, FieldList.FieldList[i]) < 0) then
      begin
        AExtraFields.Add(FieldList.GetFieldName(i) + ': ' + FieldList.GetFieldValue(i));
      end;
    end;
  finally
    FieldList.Free();
  end;
end;
    
procedure TclMailMessage.ParseDate(AFieldList: TclMailHeaderFieldList; var ADate, ADateZoneBias: TDateTime);
var
  ind: Integer;
  s: string;
begin
  ADate := Now();
  ADateZoneBias := TimeZoneBiasToDateTime(TimeZoneBiasString());
  s := AFieldList.GetDecodedFieldValue('Date');//TODO change to FieldValue and test
  if (s <> '') then
  begin
    ParseMimeTime(s, ADate, ADateZoneBias);
  end else
  begin
    s := AFieldList.GetDecodedFieldValue('Received');//TODO change to FieldValue and test
    ind := RTextPos(';', s);
    if (ind > 0) then
    begin
      ParseMimeTime(Trim(System.Copy(s, ind + 1, 1000)), ADate, ADateZoneBias);
    end;
  end;
end;

procedure TclMailMessage.InternalAssignBodies(ASource: TStrings);
var
  i: Integer;
begin
  if (FBoundary = '') then
  begin
    GenerateBoundary();
  end;
  for i := 0 to FBodies.Count - 1 do
  begin
    if (MessageFormat <> mfUUencode) and IsMultiPartContent then
    begin
      ASource.Add('--' + Boundary);
      AssignBodyHeader(ASource.Count, ASource, Bodies[i]);
      ASource.Add('');
    end;

    AddBodyToSource(ASource, Bodies[i]);

    if IsMultiPartContent then
    begin
      ASource.Add('');
    end;
  end;
  if (MessageFormat <> mfUUencode) and IsMultiPartContent then
  begin
    ASource.Add('--' + Boundary + '--');
  end;
end;

procedure TclMailMessage.AssignBodyHeader(AStartFrom: Integer; ASource: TStrings; ABody: TclMessageBody);
var
  fieldList: TclMailHeaderFieldList;
begin
  fieldList := TclMailHeaderFieldList.Create(CharSet, GetHeaderEncoding(), CharsPerLine);
  try
    fieldList.Parse(AStartFrom, ASource);
    ABody.AssignBodyHeader(fieldList);
  finally
    fieldList.Free();
  end;
end;

function TclMailMessage.CreateBody(ABodies: TclMessageBodies;
  const AContentType, ADisposition: string): TclMessageBody;
begin
  if (system.Pos('multipart/', LowerCase(AContentType)) = 1) then
  begin
    Result := TclMultipartBody.Create(ABodies);
  end else
  if (system.Pos('image/', LowerCase(AContentType)) = 1) and (LowerCase(ADisposition) <> 'attachment') then
  begin
    Result := TclImageBody.Create(ABodies);
  end else
  if (LowerCase(ADisposition) = 'attachment')
    or (system.Pos('application/', LowerCase(AContentType)) = 1)
    or (system.Pos('message/', LowerCase(AContentType)) = 1)
    or (system.Pos('audio/', LowerCase(AContentType)) = 1)
    or (system.Pos('video/', LowerCase(AContentType)) = 1)
    or (system.Pos('image/', LowerCase(AContentType)) = 1) then
  begin
    Result := TclAttachmentBody.Create(ABodies);
  end else
  if (system.Pos('text/', LowerCase(AContentType)) = 1) then
  begin
    Result := TclTextBody.Create(ABodies);
  end else
  begin
    Result := TclAttachmentBody.Create(ABodies);
  end;
end;

function TclMailMessage.ParseBodyHeader(AStartFrom: Integer; ASource: TStrings): TclMessageBody;
var
  ContType, Disposition: string;
  FieldList: TclMailHeaderFieldList;
begin
  FieldList := TclMailHeaderFieldList.Create(CharSet, GetHeaderEncoding(), CharsPerLine);
  try
    FieldList.Parse(AStartFrom, ASource);
    ContType := FieldList.GetFieldValue('Content-Type');
    Disposition := FieldList.GetFieldValue('Content-Disposition');
    Result := CreateBody(Bodies, FieldList.GetFieldValueItem(ContType, ''), FieldList.GetFieldValueItem(Disposition, ''));
    Result.ParseBodyHeader(FieldList);
  finally
    FieldList.Free();
  end;
end;

procedure TclMailMessage.AddBodyToSource(ASource: TStrings; ABody: TclMessageBody);
var
  Src: TStream;
  stringsUtils: TclStringsUtils;
begin
  if (MessageFormat = mfUUencode) and (ABody is TclAttachmentBody) then
  begin
    ASource.Add('begin 644 ' + ExtractFileName(TclAttachmentBody(ABody).FileName));
  end;
  Src := nil;
  stringsUtils := nil;
  try
    Src := ABody.GetData();

    stringsUtils := TclStringsUtils.Create(ASource);
    stringsUtils.OnProgress := ABody.DoOnEncoderProgress;
    
    stringsUtils.AddTextStream(Src);
  finally
    stringsUtils.Free();
    Src.Free();
  end;
  if (MessageFormat = mfUUencode) and (ABody is TclAttachmentBody) then
  begin
    ASource.Add('end');
  end;
end;

procedure TclMailMessage.AfterAddData(ABody: TclMessageBody; AEncodedLines: Integer);
begin
  if (ABody <> nil) and (FDataStream.Size > 0) then
  begin
    try
      FDataStream.Position := 0;
      ABody.AddData(FDataStream, AEncodedLines);
    finally
      FDataStream.Clear();
    end;
  end;
end;


procedure TclMailMessage.GetBodyFromSource(const ASource: string);
var
  buf: TclByteArray;
begin
  buf := TclTranslator.GetBytes(ASource);
  if (Length(buf) > 0) then
  begin
    FDataStream.Write(buf[0], Length(buf));
  end;
end;

procedure TclMailMessage.GetBodyList(ABodies: TclMessageBodies;
  ABodyType: TclAttachmentBodyClass; AList: TclAttachmentList);
var
  i: Integer;
begin
  for i := 0 to ABodies.Count - 1 do
  begin
    if (ABodies[i] is TclMultipartBody) then
    begin
      GetBodyList(TclMultipartBody(ABodies[i]).Bodies, ABodyType, AList);
    end else
    if (ABodies[i].ClassType = ABodyType) then
    begin
      AList.Add(TclAttachmentBody(ABodies[i]));
    end;
  end;
end;

function TclMailMessage.GetCalendar: TclTextBody;
begin
  Result := GetTextBody(Bodies, 'text/calendar');
end;

function TclMailMessage.GetDateUTC: TDateTime;
begin
  Result := Date;
  Result := Result - DateZoneBias;
end;

function TclMailMessage.IsUUEBodyStart(const ALine: string; var AFileName: string): Boolean;
var
  ind: Integer;
  s: string;
begin
  AFileName := '';
  Result := (system.Pos('begin', LowerCase(ALine)) = 1);
  if Result then
  begin
    Result := False;
    ind := system.Pos(#32, ALine);
    if (ind > 0) then
    begin
      s := TrimLeft(system.Copy(ALine, ind + 1, 1000));
      ind := system.Pos(#32, s);
      Result := (ind > 0) and (StrToIntDef(Trim(system.Copy(s, 1, ind)), -1) > -1);
      if Result then
      begin
        AFileName := Trim(system.Copy(s, ind + 1, 1000));
      end;
    end;
  end;
end;

function TclMailMessage.IsUUEBodyEnd(const ALine: string): Boolean;
begin
  Result := (Trim(LowerCase(ALine)) = 'end');
end;

function TclMailMessage.CreateUUEAttachmentBody(ABodies: TclMessageBodies;
  const AFileName: string): TclAttachmentBody;
begin
  Result := Bodies.AddAttachment(AFileName);
  Result.Encoding := cmUUEncode;
end;

procedure TclMailMessage.ParseBodies(ASource: TStrings);
  procedure ParseMultiPartBodies(ASource: TStrings);
  var
    i, StartBody: Integer;
    s: string;
    BodyItem: TclMessageBody;
  begin
    BodyItem := nil;
    StartBody := 0;
    s := '';
    for i := 0 to ASource.Count - 1 do
    begin
      if (('--' + Boundary) = ASource[i]) or (('--' + Boundary + '--') = ASource[i]) then
      begin
        if (BodyItem <> nil) and (i > StartBody) then
        begin
          GetBodyFromSource(s + #13#10);
        end;
        AfterAddData(BodyItem, i - StartBody);
        BodyItem := nil;
        if (('--' + Boundary + '--') <> ASource[i]) then
        begin
          BodyItem := ParseBodyHeader(i, ASource);
          StartBody := ParseAllHeaders(i + 1, ASource, BodyItem.RawHeader);
          BodyItem.FRawStart := i + 1;
          BodyItem.FEncodedStart := StartBody + 1;
          ParseExtraFields(BodyItem.RawHeader, BodyItem.FKnownFields, BodyItem.ExtraFields);
          if (StartBody < ASource.Count - 1) then
          begin
            Inc(StartBody);
          end;
          s := ASource[StartBody];
        end;
      end else
      begin
        if (BodyItem <> nil) and (i > StartBody) then
        begin
          GetBodyFromSource(s + #13#10);
          s := ASource[i];
        end;
      end;
    end;
    
    if (BodyItem <> nil) then
    begin
      GetBodyFromSource(s + #13#10);
    end;
    AfterAddData(BodyItem, ASource.Count - 1 - StartBody);
  end;

  procedure ParseSingleBody(ASource: TStrings);
  var
    i, bodyStart: Integer;
    singleBodyItem, BodyItem: TclMessageBody;
    fileName: string;
  begin
    bodyStart := 0;
    BodyItem := nil;
    singleBodyItem := nil;
    for i := 0 to ASource.Count - 1 do
    begin
      if (ASource[i] = '') and (singleBodyItem = nil) then
      begin
        singleBodyItem := CreateSingleBody(ASource, Bodies);
        bodyStart := i;
        singleBodyItem.FRawStart := 0;
        singleBodyItem.FEncodedStart := bodyStart + 1;
      end else
      if (singleBodyItem <> nil) then
      begin
        if IsUUEBodyStart(ASource[i], fileName) then
        begin
          MessageFormat := mfUUencode;

          if (BodyItem <> nil) then
          begin
            AfterAddData(BodyItem, 0);
          end else
          begin
            AfterAddData(singleBodyItem, 0);
          end;
          BodyItem := CreateUUEAttachmentBody(Bodies, fileName);
        end else
        if (MessageFormat = mfUUencode) and IsUUEBodyEnd(ASource[i]) then
        begin
          AfterAddData(BodyItem, 0);
          BodyItem := nil;
        end else
        begin
          GetBodyFromSource(ASource[i] + #13#10);
        end;
      end;
    end;

    AfterAddData(singleBodyItem, ASource.Count - 1 - bodyStart);
  end;

  procedure RemoveEmptySingleBody;
  var
    i: Integer;
  begin
    for i := Bodies.Count - 1 downto 0 do
    begin
      if (Bodies[i] is TclTextBody) and (Trim(TclTextBody(Bodies[i]).Strings.Text) = '') then
      begin
        Bodies.Delete(i);
      end;
    end;
  end;

begin
  BeginParse();
  try
    if IsMultiPartContent then
    begin
      ParseMultiPartBodies(ASource);
      if (Bodies.Count = 0) then
      begin
        ParseSingleBody(ASource);
        RemoveEmptySingleBody();
      end;
    end else
    begin
      ParseSingleBody(ASource);
      RemoveEmptySingleBody();
    end;
  finally
    EndParse();
  end;
end;

procedure TclMailMessage.DoOnListChanged(Sender: TObject);
begin
  Update();
end;

constructor TclMailMessage.Create(AOwner: TComponent);
  procedure SetListChangedEvent(AList: TStringList);
  begin
    AList.OnChange := DoOnListChanged;
  end;
  
begin
  inherited Create(AOwner);

  FAttachmentList := TclAttachmentList.Create();
  FImageList := TclImageList.Create();

  FHeaderSource := TStringList.Create();

  FBodiesSource := TStringList.Create();

  FMessageSource := TStringList.Create();

  FDataStream := TMemoryStream.Create();
  FUpdateCount := 0;

  FBodies := TclMessageBodies.Create(Self);

  FFrom := TclEmailAddressItem.Create();

  FBCCList := TclEmailAddressList.Create(Self, TclEmailAddressItem);

  FCCList := TclEmailAddressList.Create(Self, TclEmailAddressItem);

  FToList := TclEmailAddressList.Create(Self, TclEmailAddressItem);

  FIncludeRFC822Header := True;

  FReferences := TStringList.Create();
  SetListChangedEvent(FReferences as TStringList);

  FNewsGroups := TStringList.Create();
  SetListChangedEvent(FNewsGroups as TStringList);

  FExtraFields := TStringList.Create();
  SetListChangedEvent(FExtraFields as TStringList);

  FKnownFields := TStringList.Create();
  RegisterFields();

  FRawHeader := TStringList.Create();

  FCharsPerLine := DefaultCharsPerLine;

  FEmptyList := nil;

  Clear();
end;

destructor TclMailMessage.Destroy;
begin
  FEmptyList.Free();
  FRawHeader.Free();
  FKnownFields.Free();
  FExtraFields.Free();
  FNewsGroups.Free();
  FReferences.Free();
  FToList.Free();
  FCCList.Free();
  FBCCList.Free();
  FFrom.Free();
  FBodies.Free();
  FDataStream.Free();
  FMessageSource.Free();
  FBodiesSource.Free();
  FHeaderSource.Free();
  FImageList.Free();
  FAttachmentList.Free();

  inherited Destroy();
end;

procedure TclMailMessage.SetAllowESC(const Value: Boolean);
begin
  if (FAllowESC <> Value) then
  begin
    FAllowESC := Value;
    Update();
  end;
end;

procedure TclMailMessage.SetBCCList(const Value: TclEmailAddressList);
begin
  FBCCList.Assign(Value);
  Update();
end;

procedure TclMailMessage.SetBodies(const Value: TclMessageBodies);
begin
  FBodies.Assign(Value);
end;

procedure TclMailMessage.SetCCList(const Value: TclEmailAddressList);
begin
  FCCList.Assign(Value);
  Update();
end;

procedure TclMailMessage.SetToList(const Value: TclEmailAddressList);
begin
  FToList.Assign(Value);
  Update();
end;

function TclMailMessage.GetImages: TclImageList;
begin
  if (FImageList.Count = 0) then
  begin
    GetBodyList(Bodies, TclImageBody, FImageList);
  end;
  Result := FImageList;
end;

function TclMailMessage.GetIsMultiPartContent: Boolean;
begin
  Result := (Bodies.Count > 1) or (system.Pos('multipart/', LowerCase(FContentType)) = 1);
end;

procedure TclMailMessage.Clear;
begin
  BeginUpdate();
  try
    SetBoundary('');
    Subject := '';
    From.Clear();
    ToList.Clear();
    CCList.Clear();
    BCCList.Clear();
    Priority := mpNormal;
    Date := Now();
    Bodies.Clear();
    MessageFormat := mfNone;
    ContentType := DefaultContentType;
    ContentSubType := '';
    MimeOLE := '';
    FMessageID := '';
    ReplyTo := '';
    References.Clear();
    NewsGroups.Clear();
    ExtraFields.Clear();
    ReadReceiptTo := '';
    ListUnsubscribe := '';
    ContentDisposition := '';
    RawHeader.Clear();
    FEncodedStart := 0;

    CharSet := DefaultCharSet;
    Encoding := cmNone;
    HeaderEncoding := cmNone;
  finally
    EndUpdate();
  end;
end;

procedure TclMailMessage.Changed;
begin
  if Assigned(OnChanged) then
  begin
    OnChanged(Self);
  end;
end;

procedure TclMailMessage.SetCharSet(const Value: string);
begin
  if (FCharSet <> Value) then
  begin
    if (LowerCase(Value) = ISO2022JP) then
    begin
      SetISO2022JP();
    end else
    begin
      FCharSet := Value;
    end;

    Update();
  end;
end;

procedure TclMailMessage.SetDate(const Value: TDateTime);
begin
  if (FDate <> Value) then
  begin
    FDate := Value;
    FDateZoneBias := TimeZoneBiasToDateTime(TimeZoneBiasString());
    Update();
  end;
end;

procedure TclMailMessage.SetDkim(const Value: TclDkim);
begin
  if (FDkim <> Value) then
  begin
    if (FDkim <> nil) then
    begin
      FDkim.RemoveFreeNotification(Self);
    end;
    FDkim := Value;
    if (FDkim <> nil) then
    begin
      FDkim.FreeNotification(Self);
    end;
  end;
end;

procedure TclMailMessage.SetEncoding(const Value: TclEncodeMethod);
begin
  if (FEncoding <> Value) then
  begin
    FEncoding := Value;
    Update();
  end;
end;

procedure TclMailMessage.SetFrom(Value: TclEmailAddressItem);
begin
  FFrom.Assign(Value);
  Update();
end;

procedure TclMailMessage.SetMessageFormat(const Value: TclMessageFormat);
begin
  if (FMessageFormat <> Value) then
  begin
    FMessageFormat := Value;
    Update();
  end;
end;

procedure TclMailMessage.SetPriority(const Value: TclMessagePriority);
begin
  if (FPriority <> Value) then
  begin
    FPriority := Value;
    Update();
  end;
end;

procedure TclMailMessage.SetSubject(const Value: string);
begin
  if (FSubject <> Value) then
  begin
    FSubject := Value;
    Update();
  end;
end;

procedure TclMailMessage.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TclMailMessage.EndUpdate;
begin
  if (FUpdateCount > 0) then
  begin
    Dec(FUpdateCount);
  end;
  Update();
end;

procedure TclMailMessage.Update;
begin
  if (not (csDestroying in ComponentState))
    and (not (csLoading in ComponentState))
    and (not (csDesigning in ComponentState))
    and (FUpdateCount = 0) then
  begin
    FAttachmentList.Clear();
    FImageList.Clear();
    FHeaderSource.Clear();
    FBodiesSource.Clear();
    FMessageSource.Clear();

    Changed();
  end;
end;

procedure TclMailMessage.DoSaveAttachment(ABody: TclAttachmentBody;
  var AFileName: string; var AData: TStream; var Handled: Boolean);
begin
  if Assigned(OnSaveAttachment) then
  begin
    OnSaveAttachment(Self, ABody, AFileName, AData, Handled);
  end;
end;

procedure TclMailMessage.DoAttachmentSaved(ABody: TclAttachmentBody; const AFileName: string; AData: TStream);
begin
  if Assigned(OnAttachmentSaved) then
  begin
    OnAttachmentSaved(Self, ABody, AFileName, AData);
  end;
end;

procedure TclMailMessage.DoDataAdded(ABody: TclMessageBody; AData: TStream);
begin
  if Assigned(OnDataAdded) then
  begin
    OnDataAdded(Self, ABody, AData);
  end;
end;

procedure TclMailMessage.DoEncodingProgress(ABody: TclMessageBody; ABytesProceed, ATotalBytes: Int64);
begin
  if Assigned(OnEncodingProgress) then
  begin
    OnEncodingProgress(Self, ABody, ABytesProceed, ATotalBytes);
  end;
end;

procedure TclMailMessage.Loaded;
begin
  inherited Loaded();
  Update();
end;

procedure TclMailMessage.LoadHeader(AStream: TStream; const ACharSet: string);
var
  src: TStrings;
begin
  src := TclStringsUtils.LoadStrings(AStream, ACharSet);
  try
    HeaderSource := src;
  finally
    src.Free();
  end;
end;

procedure TclMailMessage.LoadHeader(const AFileName, ACharSet: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadHeader(stream, ACharSet);
  finally
    stream.Free();
  end;
end;

procedure TclMailMessage.SetContentType(const Value: string);
begin
  if (FContentType <> Value) then
  begin
    FContentType := Value;
    Update();
  end;
end;

function TclMailMessage.GetHeaderEncoding: TclEncodeMethod;
begin
  Result := HeaderEncoding;
  if (Result = cmNone) then
  begin
    Result := Encoding;
  end;
end;

function TclMailMessage.GetHeaderSource: TStrings;
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
    if (not IsMailMessageDemoDisplayed) and (not IsEncoderDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsMailMessageDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  if (FHeaderSource.Count = 0) then
  begin
    InternalAssignHeader(FHeaderSource);
  end;
  Result := FHeaderSource;
end;

function TclMailMessage.GetHtml: TclTextBody;
begin
  Result := GetTextBody(Bodies, 'text/html');
end;

procedure TclMailMessage.SetBoundary(const Value: string);
begin
  if (FBoundary <> Value) then
  begin
    FBoundary := Value;
    Update();
  end;
end;

function TclMailMessage.BuildImages(ABodies: TclMessageBodies; const AText, AHtml: string;
  AImages: TStrings): string;
var
  i: Integer;
  Multipart: TclMultipartBody;
  HtmlWithImages: string;
  ImageBody: TclImageBody;
begin
  HtmlWithImages := AHtml;
  for i := 0 to AImages.Count - 1 do
  begin
    ImageBody := ABodies.AddImage(AImages[i]);
    HtmlWithImages := StringReplace(HtmlWithImages, ImageBody.FileName,
      'cid:' + ImageBody.ContentID, [rfReplaceAll, rfIgnoreCase]);
  end;

  if (AText <> '') and (AHtml <> '') then
  begin
    Multipart := ABodies.AddMultipart();
    Multipart.ContentType := BuildAlternative(Multipart.Bodies, AText, HtmlWithImages);
    Result := Multipart.ContentType;
  end else
  begin
    Result := BuildAlternative(ABodies, AText, HtmlWithImages);
  end;
  ABodies.Move(ABodies.Count - 1, 0);
end;

procedure TclMailMessage.BuildAttachments(ABodies: TclMessageBodies; Attachments: TStrings);
var
  i: Integer;
begin
  for i := 0 to Attachments.Count - 1 do
  begin
    ABodies.AddAttachment(Attachments[i]);
  end;
end;

function TclMailMessage.BuildAlternative(ABodies: TclMessageBodies; const AText, AHtml: string): string;
var
  cnt: Integer;
begin
  cnt := 0;
  Result := '';
  if (AText <> '') then
  begin
    Inc(cnt);
    ABodies.AddText(AText);
    Result := 'text/plain';
  end;
  if (AHtml <> '') then
  begin
    Inc(cnt);
    ABodies.AddHtml(AHtml);
    Result := 'text/html';
  end;
  if (cnt > 1) then
  begin
    Result := 'multipart/alternative';
  end;
end;

procedure TclMailMessage.BuildMessage(const AText, AHtml: string;
  AImages, Attachments: TStrings);
var
  Multipart: TclMultipartBody;
  dummyImg, dummyAttach: TStrings;
begin
  dummyImg := nil;
  dummyAttach := nil;
  try
    if (AImages = nil) then
    begin
      dummyImg := TStringList.Create();
      AImages := dummyImg;
    end;
    if (Attachments = nil) then
    begin
      dummyAttach := TStringList.Create();
      Attachments := dummyAttach;
    end;

    Assert((AText <> '') or (AHtml <> '') or (Attachments.Count > 0));
    Assert((AImages.Count = 0) or (AHtml <> ''));

    BeginUpdate();
    try
      SafeClear();
      if (AImages.Count = 0) and (Attachments.Count = 0) then
      begin
        ContentType := BuildAlternative(Bodies, AText, AHtml);
      end else
      if (AImages.Count = 0) and (Attachments.Count > 0) then
      begin
        if (AText <> '') and (AHtml <> '') then
        begin
          Multipart := Bodies.AddMultipart();
          Multipart.ContentType := BuildAlternative(Multipart.Bodies, AText, AHtml);
        end else
        begin
          BuildAlternative(Bodies, AText, AHtml);
          if (Bodies.Count = 0) then
          begin
            Bodies.AddText('');
          end;
        end;
        BuildAttachments(Bodies, Attachments);
        ContentType := 'multipart/mixed';
      end else
      if (AImages.Count > 0) and (Attachments.Count = 0) then
      begin
        ContentSubType := BuildImages(Bodies, AText, AHtml, AImages);
        ContentType := 'multipart/related';
      end else
      if (AImages.Count > 0) and (Attachments.Count > 0) then
      begin
        Multipart := Bodies.AddMultipart();
        Multipart.ContentSubType := BuildImages(Multipart.Bodies, AText, AHtml, AImages);
        Multipart.ContentType := 'multipart/related';
        BuildAttachments(Bodies, Attachments);
        ContentType := 'multipart/mixed';
      end else
      begin
        Assert(False);
      end;
    finally
      EndUpdate();
    end;
  finally
    dummyAttach.Free();
    dummyImg.Free();
  end;
end;

procedure TclMailMessage.SetContentSubType(const Value: string);
begin
  if (FContentSubType <> Value) then
  begin
    FContentSubType := Value;
    Update();
  end;
end;

procedure TclMailMessage.BuildMessage(const AText, AHtml: string);
begin
  BuildMessage(AText, AHtml, nil, nil);
end;

procedure TclMailMessage.BuildMessage(const AText: string;
  Attachments: TStrings);
begin
  BuildMessage(AText, '', nil, Attachments);
end;

procedure TclMailMessage.LoadMessage(const AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadMessage(stream, '');
  finally
    stream.Free();
  end;
end;

procedure TclMailMessage.LoadMessage(AStream: TStream);
begin
  LoadMessage(AStream, '');
end;

procedure TclMailMessage.LoadHeader(const AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadHeader(stream, '');
  finally
    stream.Free();
  end;
end;

procedure TclMailMessage.LoadHeader(AStream: TStream);
begin
  LoadHeader(AStream, '');
end;

procedure TclMailMessage.LoadMessage(AStream: TStream; const ACharSet: string);
var
  src: TStrings;
begin
  src := TclStringsUtils.LoadStrings(AStream, ACharSet);
  try
    MessageSource := src;
  finally
    src.Free();
  end;
end;

procedure TclMailMessage.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if  (AComponent = FDkim) and (Operation = opRemove) then
  begin
    FDkim := nil;
  end;
end;

procedure TclMailMessage.LoadMessage(const AFileName, ACharSet: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadMessage(stream, ACharSet);
  finally
    stream.Free();
  end;
end;

procedure TclMailMessage.SaveMessage(const AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveMessage(stream, '');
  finally
    stream.Free();
  end;
end;

procedure TclMailMessage.SaveMessage(AStream: TStream);
begin
  SaveMessage(AStream, '');
end;

procedure TclMailMessage.SaveMessage(const AFileName, ACharSet: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveMessage(stream, ACharSet);
  finally
    stream.Free();
  end;
end;

procedure TclMailMessage.SaveHeader(const AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveHeader(stream, '');
  finally
    stream.Free();
  end;
end;

procedure TclMailMessage.SaveHeader(AStream: TStream);
begin
  SaveHeader(AStream, '');
end;

procedure TclMailMessage.SaveBodies(const AFileName: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveBodies(stream, '');
  finally
    stream.Free();
  end;
end;

procedure TclMailMessage.SaveBodies(AStream: TStream);
begin
  SaveBodies(AStream, '');
end;

procedure TclMailMessage.SaveBodies(const AFileName, ACharSet: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveBodies(stream, ACharSet);
  finally
    stream.Free();
  end;
end;

procedure TclMailMessage.SaveHeader(const AFileName, ACharSet: string);
var
  stream: TStream;
begin
  stream := TFileStream.Create(AFileName, fmCreate);
  try
    SaveHeader(stream, ACharSet);
  finally
    stream.Free();
  end;
end;

function TclMailMessage.GetAttachments: TclAttachmentList;
begin
  if (FAttachmentList.Count = 0) then
  begin
    GetBodyList(Bodies, TclAttachmentBody, FAttachmentList);
  end;
  Result := FAttachmentList;
end;

function TclMailMessage.GetBodiesSource: TStrings;
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
    if (not IsMailMessageDemoDisplayed) and (not IsEncoderDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsMailMessageDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  if (FBodiesSource.Count = 0) then
  begin
    InternalAssignBodies(FBodiesSource);
  end;
  Result := FBodiesSource;
end;

function TclMailMessage.GetMessageSource: TStrings;
var
  lines: Integer;
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
    if (not IsMailMessageDemoDisplayed) and (not IsEncoderDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsMailMessageDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}

{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'GetMessageSource');{$ENDIF}
  if (FMessageSource.Count = 0) then
  begin
    FLinesFieldPos := 0;
    InternalAssignHeader(FMessageSource);
    if IsMultiPartContent and (MessageFormat <> mfUUencode) then
    begin
      FMessageSource.Add('This is a multi-part message in MIME format.');
      FMessageSource.Add('');
    end;
    lines := FMessageSource.Count;
    InternalAssignBodies(FMessageSource);
    lines := FMessageSource.Count - lines;
    if (NewsGroups.Count > 0) and (FLinesFieldPos > 0) then
    begin
      FMessageSource.Insert(FLinesFieldPos, 'Lines: ' + IntToStr(lines));
    end;
    if (Dkim <> nil) then
    begin
      Dkim.Sign(FMessageSource);
    end;
    {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'GetMessageSource message re-composed');{$ENDIF}
  end;
  Result := FMessageSource;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'GetMessageSource'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'GetMessageSource', E); raise; end; end;{$ENDIF}
end;

function TclMailMessage.GetMessageText: TStrings;
var
  body: TclTextBody;
begin
  body := Html;
  if (body = nil) then
  begin
    body := Text;
  end;
  if (body = nil) then
  begin
    body := GetTextBody(Bodies, '');
  end;
  if (body = nil) then
  begin
    if (FEmptyList = nil) then
    begin
      FEmptyList := TStringList.Create();
    end;
    Result := FEmptyList;
  end else
  begin
    Result := body.Strings;
  end;
end;

function TclMailMessage.GetText: TclTextBody;
begin
  Result := GetTextBody(Bodies, 'text/plain');
end;

procedure TclMailMessage.SetHeaderEncoding(const Value: TclEncodeMethod);
begin
  if (FHeaderEncoding <> Value) then
  begin
    FHeaderEncoding := Value;
    Update();
  end;
end;

procedure TclMailMessage.SetHeaderSource(const Value: TStrings);
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
    if (not IsMailMessageDemoDisplayed) and (not IsEncoderDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsMailMessageDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  BeginUpdate();
  try
    SafeClear();
    InternalParseHeader(Value);
  finally
    EndUpdate();
  end;
end;

procedure TclMailMessage.SetMessageSource(const Value: TStrings);
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
    if (not IsMailMessageDemoDisplayed) and (not IsEncoderDemoDisplayed) then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsMailMessageDemoDisplayed := True;
    IsEncoderDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  BeginUpdate();
  try
    SafeClear();
    InternalParseHeader(Value);
    ParseBodies(Value);
    if (Dkim <> nil) then
    begin
      Dkim.Verify(Value);
    end;
  finally
    EndUpdate();
  end;
end;

function TclMailMessage.CreateSingleBody(ASource: TStrings; ABodies: TclMessageBodies): TclMessageBody;
var
  FieldList: TclMailHeaderFieldList;
begin
  FieldList := TclMailHeaderFieldList.Create(CharSet, GetHeaderEncoding(), CharsPerLine);
  try
    FieldList.Parse(0, ASource);

    if (LowerCase(ContentDisposition) = 'attachment')
      or (system.Pos('application/', LowerCase(ContentType)) = 1)
      or (system.Pos('message/', LowerCase(ContentType)) = 1)
      or (system.Pos('audio/', LowerCase(ContentType)) = 1)
      or (system.Pos('video/', LowerCase(ContentType)) = 1) then
    begin
      Result := TclAttachmentBody.Create(ABodies);
    end else
    begin
      Result := TclTextBody.Create(ABodies);
    end;
    Result.ParseBodyHeader(FieldList);
    ParseAllHeaders(0, ASource, Result.RawHeader);
    ParseExtraFields(Result.RawHeader, Result.KnownFields, Result.ExtraFields);
  finally
    FieldList.Free();
  end;
end;

procedure TclMailMessage.SetIncludeRFC822Header(const Value: Boolean);
begin
  if (FIncludeRFC822Header <> Value) then
  begin
    FIncludeRFC822Header := Value;
    Update();
  end;
end;

procedure TclMailMessage.SetISO2022JP;
begin
  FCharSet := ISO2022JP;
  FEncoding := cm8Bit;
  FAllowESC := True;
end;

procedure TclMailMessage.SetListUnsubscribe(const Value: string);
begin
  if (FListUnsubscribe <> Value) then
  begin
    FListUnsubscribe := Value;
    Update();
  end;
end;

procedure TclMailMessage.SetExtraFields(const Value: TStrings);
begin
  FExtraFields.Assign(Value);
end;

procedure TclMailMessage.SetNewsGroups(const Value: TStrings);
begin
  FNewsGroups.Assign(Value);
end;

procedure TclMailMessage.SetReferences(const Value: TStrings);
begin
  FReferences.Assign(Value);
end;

procedure TclMailMessage.SetReplyTo(const Value: string);
begin
  if (FReplyTo <> Value) then
  begin
    FReplyTo := Value;
    Update();
  end;
end;

function TclMailMessage.GetTextBody(ABodies: TclMessageBodies; const AContentType: string): TclTextBody;
var
  i: Integer;
begin
  for i := 0 to ABodies.Count - 1 do
  begin
    if (ABodies[i] is TclMultipartBody) then
    begin
      Result := GetTextBody((ABodies[i] as TclMultipartBody).Bodies, AContentType);
      if (Result <> nil) then Exit;
    end else
    if (ABodies[i] is TclTextBody) and
      ((AContentType = '') or SameText(ABodies[i].ContentType, AContentType)) then
    begin
      Result := TclTextBody(ABodies[i]);
      Exit;
    end;
  end;
  Result := nil;
end;

procedure TclMailMessage.SetReadReceiptTo(const Value: string);
begin
  if (FReadReceiptTo <> Value) then
  begin
    FReadReceiptTo := Value;
    Update();
  end;
end;

procedure TclMailMessage.SetMessageID(const Value: string);
begin
  if (FMessageID <> Value) then
  begin
    FMessageID := Value;
    Update();
  end;
end;

procedure TclMailMessage.DoLoadAttachment(ABody: TclAttachmentBody;
  var AFileName: string; var AData: TStream; var Handled: Boolean);
begin
  if Assigned(OnLoadAttachment) then
  begin
    OnLoadAttachment(Self, ABody, AFileName, AData, Handled);
{$IFDEF LOGGER}
    if (AData <> nil) then
    begin
      clPutLogMessage(Self, edInside, 'DoLoadAttachment: FileName="%s" (AData <> nil) Handled=%d', nil, [AFileName, Integer(Handled)]);
    end else
    begin
      clPutLogMessage(Self, edInside, 'DoLoadAttachment: FileName="%s" (AData = nil) Handled=%d', nil, [AFileName, Integer(Handled)]);
    end;
{$ENDIF}
  end;
end;

procedure TclMailMessage.BuildMessage(const AText: string;
  const Attachments: array of string);
var
  i: Integer;
  list: TStrings;
begin
  list := TStringList.Create();
  try
    for i := Low(Attachments) to High(Attachments) do
    begin
      list.Add(Attachments[i]);
    end;
    BuildMessage(AText, list);
  finally
    list.Free();
  end;
end;

procedure TclMailMessage.BuildMessage(const AText, AHtml: string;
  const AImages, Attachments: array of string);
var
  i: Integer;
  imgs, attachs: TStrings;
begin
  imgs := TStringList.Create();
  attachs := TStringList.Create();
  try
    for i := Low(AImages) to High(AImages) do
    begin
      imgs.Add(AImages[i]);
    end;
    for i := Low(Attachments) to High(Attachments) do
    begin
      attachs.Add(Attachments[i]);
    end;
    BuildMessage(AText, AHtml, imgs, attachs);
  finally
    attachs.Free();
    imgs.Free();
  end;
end;

procedure TclMailMessage.SetContentDisposition(const Value: string);
begin
  if (FContentDisposition <> Value) then
  begin
    FContentDisposition := Value;
    Update();
  end;
end;

procedure TclMailMessage.SetMimeOLE(const Value: string);
begin
  if (FMimeOLE <> Value) then
  begin
    FMimeOLE := Value;
    Update();
  end;
end;

procedure TclMailMessage.SetCharsPerLine(const Value: Integer);
begin
  if (FCharsPerLine <> Value) then
  begin
    FCharsPerLine := Value;
    Update();
  end;
end;

procedure TclMailMessage.BeginParse;
begin
  Inc(FIsParse);
end;

procedure TclMailMessage.EndParse;
begin
  Dec(FIsParse);
  if (FIsParse < 0) then
  begin
    FIsParse := 0;
  end;
end;

procedure TclMailMessage.SafeClear;
var
  oldCharSet: string;
  oldEncoding: TclEncodeMethod;
  oldHeaderEncoding: TclEncodeMethod;
begin
  BeginUpdate();
  try
    oldCharSet := CharSet;
    oldEncoding := Encoding;
    oldHeaderEncoding := HeaderEncoding;

    Clear();

    CharSet := oldCharSet;
    Encoding := oldEncoding;
    HeaderEncoding := oldHeaderEncoding;
  finally
    EndUpdate();
  end;
end;

procedure TclMailMessage.SaveMessage(AStream: TStream; const ACharSet: string);
begin
  TclStringsUtils.SaveStrings(MessageSource, AStream, ACharSet);
end;

procedure TclMailMessage.SaveHeader(AStream: TStream; const ACharSet: string);
begin
  TclStringsUtils.SaveStrings(HeaderSource, AStream, ACharSet);
end;

procedure TclMailMessage.SaveBodies(AStream: TStream; const ACharSet: string);
begin
  TclStringsUtils.SaveStrings(BodiesSource, AStream, ACharSet);
end;

{ TclMessageBody }

procedure TclMessageBody.Assign(Source: TPersistent);
var
  Src: TclMessageBody;
begin
  MailMessage.BeginUpdate();
  try
    if (Source is TclMessageBody) then
    begin
      Src := (Source as TclMessageBody);
      ExtraFields.Assign(Src.ExtraFields);
      ContentType := Src.ContentType;
      Encoding := Src.Encoding;
      ContentDisposition := Src.ContentDisposition;
      RawHeader.Assign(Src.RawHeader);
      FEncodedSize := Src.EncodedSize;
      FEncodedLines := Src.EncodedLines;
      FEncodedStart := Src.EncodedStart;
      FRawStart := Src.RawStart;
    end else
    begin
      inherited Assign(Source);
    end;
  finally
    MailMessage.EndUpdate();
  end;
end;

procedure TclMessageBody.Clear;
begin
  FExtraFields.Clear();
  ContentType := '';
  Encoding := MailMessage.Encoding;
  ContentDisposition := '';
  RawHeader.Clear();
  FEncodedSize := 0;
  FEncodedLines := 0;
  FEncodedStart := 0;
  FRawStart := 0;
end;

procedure TclMessageBody.SetListChangedEvent(AList: TStringList);
begin
  AList.OnChange := DoOnListChanged;
end;

constructor TclMessageBody.Create(AOwner: TclMessageBodies);
begin
  inherited Create();
  Assert(AOwner <> nil);
  FOwner := AOwner;
  FOwner.AddItem(Self);
  DoCreate();
  Clear();
end;

destructor TclMessageBody.Destroy();
begin
  FRawHeader.Free();
  FKnownFields.Free();
  FExtraFields.Free();
  FEncoder.Free();
  inherited Destroy();
end;

procedure TclMessageBody.DoOnListChanged(Sender: TObject);
begin
  MailMessage.Update();
end;

function TclMessageBody.GetMailMessage: TclMailMessage;
begin
  Result := FOwner.Owner;
end;

procedure TclMessageBody.ReadData(Reader: TReader);
begin
  ExtraFields.Text := Reader.ReadString();
  ContentType := Reader.ReadString();
  Encoding := TclEncodeMethod(Reader.ReadInteger());
  ContentDisposition := Reader.ReadString();
end;

procedure TclMessageBody.WriteData(Writer: TWriter);
begin
  Writer.WriteString(ExtraFields.Text);
  Writer.WriteString(ContentType);
  Writer.WriteInteger(Integer(Encoding));
  Writer.WriteString(ContentDisposition);
end;

procedure TclMessageBody.SetContentType(const Value: string);
begin
  if (FContentType <> Value) then
  begin
    FContentType := Value;
    MailMessage.Update();
  end;
end;

procedure TclMessageBody.SetEncoding(const Value: TclEncodeMethod);
begin
  if (FEncoding <> Value) then
  begin
    FEncoding := Value;
    MailMessage.Update();
  end;
end;

procedure TclMessageBody.AssignBodyHeader(AFieldList: TclMailHeaderFieldList);
begin
end;

procedure TclMessageBody.AssignEncodingIfNeed;
var
  Stream: TStream;
begin
  if (Encoding = cmNone) and (not MailMessage.IsParse) then
  begin
    Stream := GetSourceStream();
    try
      if (Stream <> nil) then
      begin
        FEncoder.AllowESC := MailMessage.AllowESC;
        FEncoder.CharsPerLine := MailMessage.CharsPerLine;
        
        Encoding := FEncoder.GetPreferredEncoding(Stream);
      end;
    finally
      Stream.Free();
    end;
  end;
end;

procedure TclMessageBody.ParseBodyHeader(AFieldList: TclMailHeaderFieldList);
var
  s: string;
begin
  s := AFieldList.GetFieldValue('Content-Type');
  ContentType := AFieldList.GetFieldValueItem(s, '');
  s := LowerCase(AFieldList.GetFieldValue('Content-Transfer-Encoding'));
  Encoding := MailMessage.Encoding;
  if (s = 'quoted-printable') then
  begin
    Encoding := cmQuotedPrintable;
  end else
  if (s = 'base64') then
  begin
    Encoding := cmBase64;
  end;
  AFieldList.Encoding := Encoding;
  s := AFieldList.GetFieldValue('Content-Disposition');
  ContentDisposition := AFieldList.GetFieldValueItem(s, '');
end;

procedure TclMessageBody.EncodeData(ASource, ADestination: TStream);
begin
  FEncoder.AllowESC := MailMessage.AllowESC;
  FEncoder.CharsPerLine := MailMessage.CharsPerLine;
  FEncoder.EncodeMethod := Encoding;
  FEncoder.Encode(ASource, ADestination);
end;

procedure TclMessageBody.DecodeData(ASource, ADestination: TStream);
begin
  try
    FEncoder.EncodeMethod := Encoding;
    FEncoder.Decode(ASource, ADestination);
  except
    ADestination.Size := 0;
    ASource.Position := 0;
    FEncoder.EncodeMethod := cmNone;
    FEncoder.Decode(ASource, ADestination);
  end;
end;

function TclMessageBody.HasEncodedData: Boolean;
begin
  Result := True;
end;

procedure TclMessageBody.AddData(AData: TStream; AEncodedLines: Integer);
var
  Dst: TStream;
begin
  Dst := GetDestinationStream();
  try
    if HasEncodedData() and (AData.Size > 0) and (AEncodedLines > 0) then
    begin
      FEncodedSize := AData.Size;
      FEncodedLines := AEncodedLines;
    end;

    BeforeDataAdded(AData);
    AData.Position := 0;
    if (Dst <> nil) then
    begin
      DecodeData(AData, Dst);
      DataAdded(Dst);
    end;
  finally
    Dst.Free();
  end;
end;

function TclMessageBody.GetData: TStream;
var
  Src: TStream;
begin
  Src := GetSourceStream();
  try
    Result := TMemoryStream.Create();
    try
      if (Src <> nil) then
      begin
        EncodeData(Src, Result);
      end;
      Result.Position := 0;
    except
      Result.Free();
      raise;
    end;
  finally
    Src.Free();
  end;
end;

procedure TclMessageBody.BeforeDataAdded(AData: TStream);
var
  buf: array[0..1] of TclChar;
begin
  if (AData.Size > 1) then
  begin
    AData.Position := AData.Size - 2;
    AData.Read(buf, 2);
    if (buf = #13#10) then
    begin
      AData.Size := AData.Size - 2;
    end;
  end;
end;

procedure TclMessageBody.DataAdded(AData: TStream);
begin
  AData.Position := 0;
  MailMessage.DoDataAdded(Self, AData);
end;

function TclMessageBody.GetEncoding: TclEncodeMethod;
begin
  if not MailMessage.IsMultiPartContent then
  begin
    Result := MailMessage.Encoding;
    if (Result = cmNone) then
    begin
      Result := FEncoding;
    end;
  end else
  begin
    Result := FEncoding;
  end;
end;

procedure TclMessageBody.DoOnEncoderProgress(Sender: TObject; ABytesProceed, ATotalBytes: Int64);
begin
  MailMessage.DoEncodingProgress(Self, ABytesProceed, ATotalBytes);
end;

function TclMessageBody.GetIndex: Integer;
begin
  Result := FOwner.FList.IndexOf(Self);
end;

procedure TclMessageBody.DoCreate;
begin
  FEncoder := TclEncoder.Create(nil);
  FEncoder.SuppressCrlf := False;
  FEncoder.OnProgress := DoOnEncoderProgress;
  FExtraFields := TStringList.Create();
  SetListChangedEvent(FExtraFields as TStringList);
  FKnownFields := TStringList.Create();
  RegisterFields();
  FRawHeader := TStringList.Create();
end;

procedure TclMessageBody.SetContentDisposition(const Value: string);
begin
  if (FContentDisposition <> Value) then
  begin
    FContentDisposition := Value;
    MailMessage.Update();
  end;
end;

procedure TclMessageBody.SetExtraFields(const Value: TStrings);
begin
  FExtraFields.Assign(Value);
end;

procedure TclMessageBody.RegisterField(const AField: string);
begin
  if (FindInStrings(FKnownFields, AField) < 0) then
  begin
    FKnownFields.Add(AField);
  end;
end;

procedure TclMessageBody.RegisterFields;
begin
  RegisterField('Content-Type');
  RegisterField('Content-Transfer-Encoding');
  RegisterField('Content-Disposition');
end;

{ TclTextBody }

procedure TclTextBody.ReadData(Reader: TReader);
begin
  Strings.Text := Reader.ReadString();
  CharSet := Reader.ReadString();
  inherited ReadData(Reader);
end;

procedure TclTextBody.WriteData(Writer: TWriter);
begin
  Writer.WriteString(Strings.Text);
  Writer.WriteString(CharSet);
  inherited WriteData(Writer);
end;

procedure TclTextBody.SetStrings(const Value: TStrings);
begin
  FStrings.Assign(Value);
end;

destructor TclTextBody.Destroy;
begin
  FStrings.Free();
  inherited Destroy();
end;

procedure TclTextBody.Assign(Source: TPersistent);
begin
  MailMessage.BeginUpdate();
  try
    if (Source is TclTextBody) then
    begin
      Strings.Assign((Source as TclTextBody).Strings);
      CharSet := (Source as TclTextBody).CharSet;
    end;
    inherited Assign(Source);
  finally
    MailMessage.EndUpdate();
  end;
end;

procedure TclTextBody.Clear;
begin
  inherited Clear();
  Strings.Clear();
  ContentType := DefaultContentType;
  CharSet := MailMessage.CharSet;
end;

procedure TclTextBody.SetCharSet(const Value: string);
begin
  if (FCharSet <> Value) then
  begin
    FCharSet := Value;
    MailMessage.Update();
  end;
end;

procedure TclTextBody.AssignBodyHeader(AFieldList: TclMailHeaderFieldList);
begin
  AFieldList.AddField('Content-Type', ContentType);

  if (ContentType <> '') and (CharSet <> '') then
  begin
    AFieldList.AddQuotedFieldItem('Content-Type', 'charset', CharSet);
  end;

  AFieldList.AddField('Content-Transfer-Encoding', EncodingMap[Encoding]);
  AFieldList.AddFields(ExtraFields);
end;

procedure TclTextBody.ParseBodyHeader(AFieldList: TclMailHeaderFieldList);
var
  s: string;
begin
  inherited ParseBodyHeader(AFieldList);
  s := AFieldList.GetFieldValue('Content-Type');
  CharSet := AFieldList.GetFieldValueItem(s, 'charset');
  AFieldList.CharSet := CharSet;
end;

function TclTextBody.GetSourceStream: TStream;
var
  size: Integer;
  s, chrSet: string;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}

  Result := TMemoryStream.Create();
  try
    s := FStrings.Text;
    size := Length(s);
    if (size - Length(#13#10) > 0) then
    begin
      s := system.Copy(s, 1, size - Length(#13#10))
    end;
    chrSet := CharSet;
    if (chrSet = '') then
    begin
      chrSet := MailMessage.CharSet;
    end;

    buf := TclTranslator.GetBytes(s, chrSet);
    if (Length(buf) > 0) then
    begin
      Result.WriteBuffer(buf[0], Length(buf));
      Result.Position := 0;
    end;
  except
    Result.Free();
    raise;
  end;
end;

function TclTextBody.GetCharSet: string;
begin
  if not MailMessage.IsMultiPartContent then
  begin
    Result := MailMessage.CharSet;
  end else
  begin
    Result := FCharSet;
  end;
end;

function TclTextBody.GetDestinationStream: TStream;
begin
  Result := TMemoryStream.Create();
end;

procedure TclTextBody.DataAdded(AData: TStream);
var
  res: string;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  if (AData.Size > 0) then
  begin
    SetLength(buf, AData.Size);

    AData.Position := 0;
    AData.Read(buf[0], AData.Size);

    res := TclTranslator.GetString(buf, 0, AData.Size, CharSet);
    AddTextStr(FStrings, res);

    inherited DataAdded(AData);
  end;
end;

procedure TclTextBody.DoCreate;
begin
  inherited DoCreate();
  FStrings := TStringList.Create();
  TStringList(FStrings).OnChange := DoOnStringsChanged;
end;

procedure TclTextBody.DoOnStringsChanged(Sender: TObject);
begin
  AssignEncodingIfNeed();
  MailMessage.Update();
end;

{ TclAttachmentBody }

procedure TclAttachmentBody.Assign(Source: TPersistent);
begin
  MailMessage.BeginUpdate();
  try
    if (Source is TclAttachmentBody) then
    begin
      FileName := (Source as TclAttachmentBody).FileName;
      ContentID := (Source as TclAttachmentBody).ContentID;
    end;
    inherited Assign(Source);
  finally
    MailMessage.EndUpdate();
  end;
end;

procedure TclAttachmentBody.AssignBodyHeader(AFieldList: TclMailHeaderFieldList);
var
  disposition: string;
begin
  AFieldList.AddField('Content-Type', ContentType);

  if (ContentType <> '') and (FileName <> '') then
  begin
    AFieldList.AddEncodedFieldItem('Content-Type', 'name', ExtractFileName(FileName));
  end;

  AFieldList.AddField('Content-Transfer-Encoding', EncodingMap[Encoding]);

  disposition := ContentDisposition;
  if (disposition = '') then
  begin
    disposition := 'attachment';
  end;

  AFieldList.AddField('Content-Disposition', disposition);

  if (disposition <> '') and (FileName <> '') then
  begin
    AFieldList.AddEncodedFieldItem('Content-Disposition', 'filename', ExtractFileName(FileName));
  end;

  if (ContentID <> '') then
  begin
    AFieldList.AddField('Content-ID', '<' + ContentID + '>');
  end;
  AFieldList.AddFields(ExtraFields);
end;

procedure TclAttachmentBody.Clear;
begin
  inherited Clear();
  FileName := '';
  ContentType := 'application/octet-stream';
  ContentID := '';
end;

procedure TclAttachmentBody.DataAdded(AData: TStream);
begin
  inherited DataAdded(AData);
  AData.Position := 0;
  MailMessage.DoAttachmentSaved(Self, FileName, AData);
end;

function TclAttachmentBody.GetMessageRfc822FileName(ABodyPos: Integer; ASource: TStrings): string;
var
  filedList: TclMailHeaderFieldList;
begin
  filedList := TclMailHeaderFieldList.Create(MailMessage.CharSet,
    MailMessage.GetHeaderEncoding(), MailMessage.CharsPerLine);
  try
    filedList.Parse(ABodyPos, ASource);
    Result := NormalizeFilePath(filedList.GetFieldValue('Subject') + '.eml');
  finally
    filedList.Free();
  end;
end;

procedure TclAttachmentBody.ParseBodyHeader(AFieldList: TclMailHeaderFieldList);
var
  s: string;
begin
  inherited ParseBodyHeader(AFieldList);

  s := AFieldList.GetFieldValue('Content-Disposition');
  FileName := AFieldList.GetDecodedFieldValueItem(s, 'filename');
  if (FileName = '') then
  begin
    s := AFieldList.GetFieldValue('Content-Type');
    FileName := AFieldList.GetDecodedFieldValueItem(s, 'filename');
  end;
  if (FileName = '') then
  begin
    FileName := AFieldList.GetDecodedFieldValue('Content-Description');
    if (Length(FileName) > 3) and (FileName[Length(FileName) - 3] <> '.') then
    begin
      FileName := NormalizeFilePath(FileName + '.dat');
    end;
  end;
  if (FileName = '') then
  begin
    s := AFieldList.GetFieldValue('Content-Type');
    FileName := NormalizeFilePath(AFieldList.GetDecodedFieldValueItem(s, 'name'));
  end;

  if (FileName = '') and SameText('message/rfc822', ContentType) then
  begin
    FileName := GetMessageRfc822FileName(AFieldList.HeaderEnd + 1, AFieldList.Source);
  end;

  ContentID := GetContentID(AFieldList);
end;

function TclAttachmentBody.GetContentID(AFieldList: TclMailHeaderFieldList): string;
begin
  Result := ExtractQuotedString(AFieldList.GetFieldValue('Content-ID'), '<', '>');
end;

procedure TclAttachmentBody.ReadData(Reader: TReader);
begin
  FileName := Reader.ReadString();
  inherited ReadData(Reader);
end;

procedure TclAttachmentBody.SetFileName(const Value: string);
begin
  if (FFileName <> Value) then
  begin
    FFileName := Value;
    AssignEncodingIfNeed();
    MailMessage.Update();
  end;
end;

procedure TclAttachmentBody.AssignEncodingIfNeed;
begin
  FCheckFileExists := True;
  try
    inherited AssignEncodingIfNeed();
  finally
    FCheckFileExists := False;
  end;
end;

procedure TclAttachmentBody.WriteData(Writer: TWriter);
begin
  Writer.WriteString(FileName);
  inherited WriteData(Writer);
end;

function TclAttachmentBody.GetDestinationStream: TStream;
var
  Handled: Boolean;
  s: string;
begin
  Result := nil;
  Handled := False;
  s := FileName;
  MailMessage.DoSaveAttachment(Self, s, Result, Handled);
  FileName := s;
end;

function TclAttachmentBody.GetSourceStream: TStream;
var
  Handled: Boolean;
  s: string;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'GetSourceStream');{$ENDIF}
  Result := nil;
  Handled := False;
  s := FileName;
  MailMessage.DoLoadAttachment(Self, s, Result, Handled);
  FileName := s;
  if not Handled then
  begin
    Result.Free();
    if (not FCheckFileExists or FileExists(FileName)) then
    begin
      {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'GetSourceStream need to open the attachment file: "%s"', nil, [FileName]);{$ENDIF}
      Result := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    end;
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'GetSourceStream'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'GetSourceStream', E); raise; end; end;{$ENDIF}
end;

function TclAttachmentBody.GetEncoding: TclEncodeMethod;
begin
  if (MailMessage.MessageFormat = mfUUencode) then
  begin
    Result := cmUUEncode;
  end else
  begin
    Result := inherited GetEncoding();
  end;
end;

procedure TclAttachmentBody.SetContentID(const Value: string);
begin
  if (FContentID <> Value) then
  begin
    FContentID := Value;
    MailMessage.Update();
  end;
end;

procedure TclAttachmentBody.RegisterFields;
begin
  inherited RegisterFields();
  RegisterField('Content-Description');
  RegisterField('Content-ID');
end;

{ TclImageBody }

function TclImageBody.GetUniqueContentID(const AFileName: string): string;
begin
  Result := AFileName + '@' + FloatToStr(Now()) + '.' + IntToStr(Random(1000));
end;

procedure TclImageBody.AssignBodyHeader(AFieldList: TclMailHeaderFieldList);
begin
  AFieldList.AddField('Content-Type', ContentType);

  if (ContentType <> '') and (FileName <> '') then
  begin
    AFieldList.AddEncodedFieldItem('Content-Type', 'name', ExtractFileName(FileName));
  end;

  AFieldList.AddField('Content-Transfer-Encoding', EncodingMap[Encoding]);

  AFieldList.AddField('Content-Disposition', ContentDisposition);

  if (ContentDisposition <> '') and (FileName <> '') then
  begin
    AFieldList.AddEncodedFieldItem('Content-Disposition', 'filename', ExtractFileName(FileName));
  end;

  if (ContentID <> '') then
  begin
    AFieldList.AddField('Content-ID', '<' + ContentID + '>');
  end;
  AFieldList.AddFields(ExtraFields);
end;

procedure TclImageBody.Clear;
begin
  inherited Clear();
  ContentType := '';
  Encoding := cmBase64;
end;

procedure TclImageBody.ParseBodyHeader(AFieldList: TclMailHeaderFieldList);
var
  s: string;
begin
  inherited ParseBodyHeader(AFieldList);

  s := AFieldList.GetFieldValue('Content-Type');
  FileName := AFieldList.GetDecodedFieldValueItem(s, 'name');
  ContentType := AFieldList.GetFieldValueItem(s, '');
  ContentID := GetContentID(AFieldList);
end;

{$IFNDEF DELPHI6}
const
  PathDelim  = '\';
  DriveDelim = ':';
{$ENDIF}

function TclImageBody.GetFileType(const AFileName: string): string;
var
  i: Integer;
begin
  i := LastDelimiter('.' + PathDelim + DriveDelim, FileName);
  if (i > 0) and (FileName[i] = '.') then
    Result := Copy(FileName, i + 1, 1000)
  else
    Result := '';
end;

procedure TclImageBody.SetFileName(const Value: string);
begin
  inherited SetFileName(Value);
  if (FileName <> '') and (ContentID = '') then
  begin
    ContentID := GetUniqueContentID(ExtractFileName(FileName));
  end;
  if (FileName <> '') and (ContentType = '') then
  begin
    ContentType := 'image/' + GetFileType(FileName);
  end;
end;

{ TclMultipartBody }

procedure TclMultipartBody.Assign(Source: TPersistent);
var
  Multipart: TclMultipartBody;
begin
  MailMessage.BeginUpdate();
  try
    if (Source is TclMultipartBody) then
    begin
      Multipart := (Source as TclMultipartBody);
      Bodies := Multipart.Bodies;
      SetBoundary(Multipart.Boundary);
      ContentSubType := Multipart.ContentSubType;
    end;
    inherited Assign(Source);
  finally
    MailMessage.EndUpdate();
  end;
end;

procedure TclMultipartBody.AssignBodyHeader(AFieldList: TclMailHeaderFieldList);
begin
  FSelfMailMessage.GenerateBoundary();

  AFieldList.AddField('Content-Type', ContentType);

  if (ContentType <> '') and (ContentSubType <> '') then
  begin
    AFieldList.AddQuotedFieldItem('Content-Type', 'type', ContentSubType);
  end;

  AFieldList.AddQuotedFieldItem('Content-Type', 'boundary', Boundary);

  AFieldList.AddFields(ExtraFields);
  AFieldList.AddEndOfHeader();
end;

procedure TclMultipartBody.Clear;
begin
  inherited Clear();

  Bodies.Clear();
  ContentType := 'multipart/mixed';
  ContentSubType := '';
  Encoding := cmNone;
  SetBoundary('');
end;


procedure TclMultipartBody.FixRawBodyStart(ABodies: TclMessageBodies);
var
  i: Integer;
  body: TclMessageBody;
begin
  for i := 0 to ABodies.Count - 1 do
  begin
    body := ABodies[i];
    body.FEncodedStart := body.EncodedStart + EncodedStart;
    body.FRawStart := body.RawStart + EncodedStart;
    if(body is TclMultipartBody) then
    begin
      FixRawBodyStart(TclMultipartBody(body).Bodies);
    end;
  end;
end;

procedure TclMultipartBody.DataAdded(AData: TStream);
var
  list: TStrings;
begin
  list := TStringList.Create();
  try
    AData.Position := 0;

    AddTextStream(list, AData);

    FSelfMailMessage.ParseBodies(list);

    FixRawBodyStart(Bodies);
    FEncodedLines := list.Count;
  finally
    list.Free();
  end;
end;

destructor TclMultipartBody.Destroy;
begin
  FSelfMailMessage.Free();
  inherited Destroy();
end;

procedure TclMultipartBody.DoCreate;
begin
  inherited DoCreate();

  FSelfMailMessage := TclMailMessage.Create(nil);
  FSelfMailMessage.OnSaveAttachment := DoOnSaveAttachment;
  FSelfMailMessage.OnAttachmentSaved := DoOnAttachmentSaved;
  FSelfMailMessage.OnLoadAttachment := DoOnLoadAttachment;
  FSelfMailMessage.OnDataAdded := DoOnDataAdded;
  FSelfMailMessage.Bodies.FOwner := MailMessage;
end;

procedure TclMultipartBody.DoOnAttachmentSaved(Sender: TObject;
  ABody: TclAttachmentBody; const AFileName: string; AData: TStream);
begin
  MailMessage.DoAttachmentSaved(ABody, AFileName, AData);
end;

procedure TclMultipartBody.DoOnDataAdded(Sender: TObject;
  ABody: TclMessageBody; AData: TStream);
begin
  AData.Position := 0;
  MailMessage.DoDataAdded(ABody, AData);
end;

procedure TclMultipartBody.DoOnLoadAttachment(Sender: TObject;
  ABody: TclAttachmentBody; var AFileName: string; var AStream: TStream;
  var Handled: Boolean);
begin
  MailMessage.DoLoadAttachment(ABody, AFileName, AStream, Handled);
end;

procedure TclMultipartBody.DoOnSaveAttachment(Sender: TObject;
  ABody: TclAttachmentBody; var AFileName: string; var AStream: TStream;
  var Handled: Boolean);
begin
  MailMessage.DoSaveAttachment(ABody, AFileName, AStream, Handled);
end;

function TclMultipartBody.GetBodies: TclMessageBodies;
begin
  Result := FSelfMailMessage.Bodies;
end;

function TclMultipartBody.GetBoundary: string;
begin
  Result := FSelfMailMessage.Boundary;
end;

function TclMultipartBody.GetDestinationStream: TStream;
begin
  Result := TMemoryStream.Create();
end;

function TclMultipartBody.GetSourceStream: TStream;
var
  list: TStrings;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}

  Result := TMemoryStream.Create();
  list := TStringList.Create();
  try
    FSelfMailMessage.InternalAssignBodies(list);

    buf := TclTranslator.GetBytes(list.Text);
    if (Length(buf) > 0) then
    begin
      Result.WriteBuffer(buf[0], Length(buf));
    end;

    Result.Position := 0;
  finally
    list.Free();
  end;
end;

function TclMultipartBody.HasEncodedData: Boolean;
begin
  Result := False;
end;

procedure TclMultipartBody.ParseBodyHeader(AFieldList: TclMailHeaderFieldList);
var
  s: string;
begin
  inherited ParseBodyHeader(AFieldList);

  s := AFieldList.GetFieldValue('Content-Type');
  SetBoundary(AFieldList.GetFieldValueItem(s, 'boundary'));
  ContentSubType := AFieldList.GetFieldValueItem(s, 'type');
  Encoding := cmNone;
end;

procedure TclMultipartBody.ReadData(Reader: TReader);
begin
  ContentSubType := Reader.ReadString();
  Bodies.ReadData(Reader);
  inherited ReadData(Reader);
end;

procedure TclMultipartBody.SetBodies(const Value: TclMessageBodies);
begin
  FSelfMailMessage.Bodies.Assign(Value);
end;

procedure TclMultipartBody.SetBoundary(const Value: string);
begin
  if (Boundary <> Value) then
  begin
    FSelfMailMessage.SetBoundary(Value);
    MailMessage.Update();
  end;
end;

procedure TclMultipartBody.SetContentSubType(const Value: string);
begin
  if (FContentSubType <> Value) then
  begin
    FContentSubType := Value;
    MailMessage.Update();
  end;
end;

procedure TclMultipartBody.SetContentType(const Value: string);
begin
  inherited SetContentType(Value);
  FSelfMailMessage.SetContentType(Value);
end;

procedure TclMultipartBody.WriteData(Writer: TWriter);
begin
  Writer.WriteString(ContentSubType);
  Bodies.WriteData(Writer);
  inherited WriteData(Writer);
end;

{ TclAttachmentList }

procedure TclAttachmentList.Add(AItem: TclAttachmentBody);
begin
  FList.Add(AItem);
end;

procedure TclAttachmentList.Clear;
begin
  FList.Clear();
end;

constructor TclAttachmentList.Create;
begin
  inherited Create();
  FList := TList.Create();
end;

destructor TclAttachmentList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function TclAttachmentList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclAttachmentList.GetItem(Index: Integer): TclAttachmentBody;
begin
  Result := TclAttachmentBody(FList[Index]);
end;

{ TclImageList }

function TclImageList.GetItem(Index: Integer): TclImageBody;
begin
  Result := TclImageBody(inherited GetItem(Index));
end;

initialization
  RegisterBody(TclTextBody);
  RegisterBody(TclAttachmentBody);
  RegisterBody(TclMultipartBody);
  RegisterBody(TclImageBody);

finalization
  RegisteredBodyItems.Free();

end.
