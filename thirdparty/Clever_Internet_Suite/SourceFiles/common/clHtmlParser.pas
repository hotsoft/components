{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clHtmlParser;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes;
{$ELSE}
  System.Classes, System.Types;
{$ENDIF}

type
  TclHtmlParseMethod = (pmAll, pmTagsOnly, pmTextOnly);

  TclHtmlTag = class;
  TclHtmlParser = class;

  TclHtmlAttribute = class
  private
    FValue: string;
    FName: string;
    FOwner: TclHtmlTag;
    FInnerTextPos: Integer;
  public
    constructor Create(const AName, AValue: string; AInnerTextPos: Integer);
    property Name: string read FName;
    property Value: string read FValue;
    property Owner: TclHtmlTag read FOwner;
    property InnerTextPos: Integer read FInnerTextPos;
  end;

  TclHtmlTag = class
  private
    FAttributes: TList;
    FName: string;
    FOwner: TclHtmlTag;
    FText: string;
    FIsText: Boolean;
    FParser: TclHtmlParser;
    FTagSource: string;
    FNextTag: TclHtmlTag;
    FIsClosingTag: Boolean;
    FInnerTextPos: Integer;
    function GetAttribute(Index: Integer): TclHtmlAttribute;
    function GetAttributeCount: Integer;
    procedure ClearAttributes;
    procedure AddAttribute(Attribute: TclHtmlAttribute);
    function GetText: string;
  protected
    procedure BeforeParseTag; virtual;
    procedure AfterParseTag; virtual;
    function CanAddTableCellTag: Boolean; virtual;
  public
    constructor Create(const AName, ATagSource: string; AOwner: TclHtmlTag; AParser: TclHtmlParser);
    destructor Destroy; override;
    function AttributeByName(const AName: string): TclHtmlAttribute;
    function AttributeValue(const AName: string): string;
    property Owner: TclHtmlTag read FOwner;
    property Name: string read FName;
    property IsText: Boolean read FIsText;
    property TagSource: string read FTagSource;
    property Text: string read GetText;
    property Attributes[Index: Integer]: TclHtmlAttribute read GetAttribute;
    property AttributeCount: Integer read GetAttributeCount;
    property Parser: TclHtmlParser read FParser;
    property NextTag: TclHtmlTag read FNextTag;
    property IsClosingTag: Boolean read FIsClosingTag;
    property InnerTextPos: Integer read FInnerTextPos;
  end;

  TclHtmlTagList = class
  private
    FList: TList;
    FOwnsObjects: Boolean;
    function GetCount: Integer;
    function GetItem(Index: Integer): TclHtmlTag;
    function GetLast: TclHtmlTag;
    function GetFirst: TclHtmlTag;
    function GetStartFromIndex(StartFrom: TclHtmlTag): Integer;
  protected
    procedure Clear;
    procedure Add(AItem: TclHtmlTag);
  public
    constructor Create(AOwnsObjects: Boolean);
    destructor Destroy; override;
    procedure AssignList(AList: TStrings);
    function TagByName(const AName: string; StartFrom: TclHtmlTag = nil): TclHtmlTag;
    function TagByAttributeName(const AName, AttrName, AttrValue: string;
      StartFrom: TclHtmlTag = nil): TclHtmlTag;
    function IndexOf(ATag: TclHtmlTag): Integer;
    property Items[Index: Integer]: TclHtmlTag read GetItem; default;
    property Count: Integer read GetCount;
    property First: TclHtmlTag read GetFirst;
    property Last: TclHtmlTag read GetLast;
    property OwnsObjects: Boolean read FOwnsObjects;
  end;
  
  TclHtmlForm = class(TclHtmlTag)
  private
    FControls: TclHtmlTagList;
    function GetAction: string;
    function GetEncType: string;
    function GetFormName: string;
    function GetMethod: string;
  protected
    procedure BeforeParseTag; override;
    procedure AfterParseTag; override;
  public
    constructor Create(const AName, AText: string; AOwner: TclHtmlTag; AParser: TclHtmlParser);
    destructor Destroy; override;
    property Controls: TclHtmlTagList read FControls;
    property FormName: string read GetFormName;
    property Action: string read GetAction;
    property EncType: string read GetEncType;
    property Method: string read GetMethod;
  end;

  TclHtmlFormList = class(TclHtmlTagList)
  private
    function GetItem(Index: Integer): TclHtmlForm;
  public
    function FormByName(const AName: string; StartFrom: TclHtmlTag = nil): TclHtmlForm;
    property Items[Index: Integer]: TclHtmlForm read GetItem; default;
  end;

  TclHtmlMetaTag = class(TclHtmlTag)
  private
    function GetContent: string;
    function GetHttpEquiv: string;
    function GetMetaName: string;
  protected
    procedure BeforeParseTag; override;
    procedure AfterParseTag; override;
  public
    property MetaName: string read GetMetaName;
    property Content: string read GetContent;
    property HttpEquiv: string read GetHttpEquiv;
  end;

  TclHtmlMetaTagList = class(TclHtmlTagList)
  private
    function GetItem(Index: Integer): TclHtmlMetaTag;
  public
    property Items[Index: Integer]: TclHtmlMetaTag read GetItem; default;
  end;

  TclHtmlLink = class(TclHtmlTag)
  private
    FTags: TclHtmlTagList;
    function GetHref: string;
    function GetTarget: string;
    function GetLinkText: string;
  protected
    procedure BeforeParseTag; override;
    procedure AfterParseTag; override;
  public
    constructor Create(const AName, AText: string; AOwner: TclHtmlTag; AParser: TclHtmlParser);
    destructor Destroy; override;
    property Href: string read GetHref;
    property Target: string read GetTarget;
    property Tags: TclHtmlTagList read FTags;
    property LinkText: string read GetLinkText;
  end;

  TclHtmlLinkList = class(TclHtmlTagList)
  private
    function GetItem(Index: Integer): TclHtmlLink;
  public
    property Items[Index: Integer]: TclHtmlLink read GetItem; default;
  end;

  TclHtmlFrame = class(TclHtmlTag)
  private
    function GetSrc: string;
  protected
    procedure BeforeParseTag; override;
    procedure AfterParseTag; override;
  public
    property Src: string read GetSrc;
  end;

  TclHtmlFrameList = class(TclHtmlTagList)
  private
    function GetItem(Index: Integer): TclHtmlFrame;
  public
    property Items[Index: Integer]: TclHtmlFrame read GetItem; default;
  end;

  TclHtmlImage = class(TclHtmlTag)
  private
    function GetAlt: string;
    function GetHeight: Integer;
    function GetSrc: string;
    function GetWidth: Integer;
  protected
    procedure BeforeParseTag; override;
    procedure AfterParseTag; override;
  public
    property Src: string read GetSrc;
    property Alt: string read GetAlt;
    property Height: Integer read GetHeight;
    property Width: Integer read GetWidth;
  end;

  TclHtmlImageList = class(TclHtmlTagList)
  private
    function GetItem(Index: Integer): TclHtmlImage;
  public
    property Items[Index: Integer]: TclHtmlImage read GetItem; default;
  end;

  TclHtmlTableCell = class(TclHtmlTag)
  private
    FTags: TclHtmlTagList;
    function GetColSpan: Integer;
    function GetHeight: Integer;
    function GetRowSpan: Integer;
    function GetWidth: Integer;
  protected
    procedure BeforeParseTag; override;
    procedure AfterParseTag; override;
    function CanAddTableCellTag: Boolean; override;
  public
    constructor Create(const AName, AText: string; AOwner: TclHtmlTag; AParser: TclHtmlParser);
    destructor Destroy; override;
    property Tags: TclHtmlTagList read FTags;
    property ColSpan: Integer read GetColSpan;
    property RowSpan: Integer read GetRowSpan;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
  end;

  TclHtmlTableCellList = class(TclHtmlTagList)
  private
    function GetItem(Index: Integer): TclHtmlTableCell;
  public
    property Items[Index: Integer]: TclHtmlTableCell read GetItem; default;
  end;

  TclHtmlTableRow = class(TclHtmlTag)
  private
    FCells: TclHtmlTableCellList;
  protected
    procedure BeforeParseTag; override;
    procedure AfterParseTag; override;
    function CanAddTableCellTag: Boolean; override;
  public
    constructor Create(const AName, AText: string; AOwner: TclHtmlTag; AParser: TclHtmlParser);
    destructor Destroy; override;
    property Cells: TclHtmlTableCellList read FCells;
  end;

  TclHtmlTableRowList = class(TclHtmlTagList)
  private
    function GetItem(Index: Integer): TclHtmlTableRow;
  public
    property Items[Index: Integer]: TclHtmlTableRow read GetItem; default;
  end;

  TclHtmlTable = class(TclHtmlTag)
  private
    FRows: TclHtmlTableRowList;
    function GetBorder: Integer;
    function GetCellPadding: Integer;
    function GetCellSpacing: Integer;
    function GetHeight: Integer;
    function GetWidth: Integer;
  protected
    procedure BeforeParseTag; override;
    procedure AfterParseTag; override;
  public
    constructor Create(const AName, AText: string; AOwner: TclHtmlTag; AParser: TclHtmlParser);
    destructor Destroy; override;
    property Rows: TclHtmlTableRowList read FRows;
    property Border: Integer read GetBorder;
    property CellSpacing: Integer read GetCellSpacing;
    property CellPadding: Integer read GetCellPadding;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
  end;

  TclHtmlTableList = class(TclHtmlTagList)
  private
    function GetItem(Index: Integer): TclHtmlTable;
  public
    property Items[Index: Integer]: TclHtmlTable read GetItem; default;
  end;

  TclOnParseTag = procedure(Sender: TObject; ATag: TclHtmlTag) of object;
  TclOnParseForm = procedure(Sender: TObject; AForm: TclHtmlForm) of object;
  TclOnParseLink = procedure(Sender: TObject; ALink: TclHtmlLink) of object;
  TclOnParseFrame = procedure(Sender: TObject; AFrame: TclHtmlFrame) of object;
  TclOnParseImage = procedure(Sender: TObject; AImage: TclHtmlImage) of object;
  TclOnParseAttribute = procedure(Sender: TObject; ATag: TclHtmlTag; Attribute: TclHtmlAttribute) of object;
  TclOnParseFormControl = procedure(Sender: TObject; AForm: TclHtmlForm; AControl: TclHtmlTag) of object;
  TclOnParseTable = procedure(Sender: TObject; ATable: TclHtmlTable) of object;
  TclOnParseTableRow = procedure(Sender: TObject; ATable: TclHtmlTable; ARow: TclHtmlTableRow) of object;
  TclOnParseTableCell = procedure(Sender: TObject; ATable: TclHtmlTable; ARow: TclHtmlTableRow;
    ACell: TclHtmlTableCell) of object;
  TclOnParseTableCellTag = procedure(Sender: TObject; ATable: TclHtmlTable; ARow: TclHtmlTableRow;
    ACell: TclHtmlTableCell; ATag: TclHtmlTag) of object;
  TclOnParseMetaTag = procedure(Sender: TObject; ATag: TclHtmlMetaTag) of object;

  TclCheckLexemResult = (clNone, clEnterTag, clLeaveTag);

  TclTagLexemChecker = class
  private
    FLexems: TStrings;
    FEndLexems: TStrings;
    FCheckedLexem: Integer;
    procedure CheckLexem(AKey: Char; const ALexem: string; var ALexemCount: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddLexem(const ALexem, AEndLexem: string);
    function CheckLexems(AKey: Char): TclCheckLexemResult;
    property CheckedLexem: Integer read FCheckedLexem;
    property Lexems: TStrings read FLexems;
    property EndLexems: TStrings read FEndLexems;
  end;

  TclHtmlTagStack = class
  private
    FList: TList;
    function GetIsEmpty: Boolean;
    function GetTop: TclHtmlTag;
  public
    constructor Create;
    destructor Destroy; override;
    function Push(AItem: TclHtmlTag): TclHtmlTag;
    function Pop: TclHtmlTag;
    property Top: TclHtmlTag read GetTop;
    property IsEmpty: Boolean read GetIsEmpty;
  end;

  TclSymbolType = (stDontCare, stQuote, stDelimiter, stWhiteSpace);
  TclHtmlTitleStatus = (tsNone, tsEnterHead, tsEnterTitle, tsTitleParsed);

  TclHtmlParser = class(TComponent)
  private
    FTags: TclHtmlTagList;
    FForms: TclHtmlFormList;
    FLinks: TclHtmlLinkList;
    FImages: TclHtmlImageList;
    FFrames: TclHtmlFrameList;
    FTables: TclHtmlTableList;
    FMetaTags: TclHtmlMetaTagList;
    FKeywords: string;
    FDescription: string;
    FAuthor: string;
    FTitle: string;
    FParseMethod: TclHtmlParseMethod;
    FIncludeClosingTags: Boolean;
    FTableStack: TclHtmlTagStack;
    FCurrentLink: TclHtmlLink;
    FNonClosingTags: TStrings;
    FTitleStatus: TclHtmlTitleStatus;

    FOnParseForm: TclOnParseForm;
    FOnParseFormControl: TclOnParseFormControl;
    FOnParseLink: TclOnParseLink;
    FOnParseImage: TclOnParseImage;
    FOnParseAttribute: TclOnParseAttribute;
    FOnParseTag: TclOnParseTag;
    FOnParseTable: TclOnParseTable;
    FOnParseTableCell: TclOnParseTableCell;
    FOnParseTableCellTag: TclOnParseTableCellTag;
    FOnParseTableRow: TclOnParseTableRow;
    FOnParseFrame: TclOnParseFrame;
    FOnParseMetaTag: TclOnParseMetaTag;

    function CreateAttribute(ATag: TclHtmlTag; const AName, AValue: string; AInnerTextPos: Integer): TclHtmlAttribute;
    function NeedParseTags: Boolean;
    function NeedParseText: Boolean;
    function AddTableCellTag(ATag: TclHtmlTag): Boolean;
    function IsNonClosingTag(ATagName: string): Boolean;
    procedure ExtractMetaTags;
    function RemoveBadChars(const S: string): string;
    function GetTypeFromSymbol(AKey: Char): TclSymbolType;
    procedure ProcessTitleStatus(const AName: string);
    procedure InternalParseTag(ATag: TclHtmlTag; const ALexem: string; ALexemPos: Integer);
  protected
    procedure AddToControls(ATag, AOwner: TclHtmlTag);
    procedure DoParseTag(ATag: TclHtmlTag); dynamic;
    procedure DoParseAttribute(ATag: TclHtmlTag; Attribute: TclHtmlAttribute); dynamic;
    procedure DoParseForm(AForm: TclHtmlForm); dynamic;
    procedure DoParseLink(ALink: TclHtmlLink); dynamic;
    procedure DoParseFrame(AFrame: TclHtmlFrame); dynamic;
    procedure DoParseImage(AImage: TclHtmlImage); dynamic;
    procedure DoParseFormControl(AForm: TclHtmlForm; AControl: TclHtmlTag); dynamic;
    procedure DoParseTable(ATable: TclHtmlTable); dynamic;
    procedure DoParseTableRow(ATable: TclHtmlTable; ARow: TclHtmlTableRow); dynamic;
    procedure DoParseTableCell(ATable: TclHtmlTable; ARow: TclHtmlTableRow;
      ACell: TclHtmlTableCell); dynamic;
    procedure DoParseTableCellTag(ATable: TclHtmlTable; ARow: TclHtmlTableRow;
      ACell: TclHtmlTableCell; ATag: TclHtmlTag); dynamic;
    procedure DoParseMetaTag(AMetaTag: TclHtmlMetaTag); dynamic;
    function CreateText(const AText: string; AOwner: TclHtmlTag; AInnerTextPos: Integer): TclHtmlTag; virtual;
    function CreateTag(const ALexem: string; AOwner: TclHtmlTag;
      AInnerTextPos, AttribPos: Integer): TclHtmlTag; virtual;
    function CreateTagByName(const AName, AText: string; AOwner: TclHtmlTag; AInnerTextPos: Integer): TclHtmlTag; virtual;
    procedure ParseTag(ATag: TclHtmlTag; const ALexem: string; ALexemPos: Integer); virtual;
    procedure GetSkipLexems(ASkipLexems: TclTagLexemChecker); virtual;
    procedure GetNonClosingTags(ATags: TStrings); virtual;
    procedure AddTag(ATag: TclHtmlTag);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear; virtual;
    procedure Parse(const AHtml: string); overload;
    procedure Parse(const AHtml: TStrings); overload;

    property Tags: TclHtmlTagList read FTags;
    property Forms: TclHtmlFormList read FForms;
    property Links: TclHtmlLinkList read FLinks;
    property Images: TclHtmlImageList read FImages;
    property Tables: TclHtmlTableList read FTables;
    property Frames: TclHtmlFrameList read FFrames;
    property MetaTags: TclHtmlMetaTagList read FMetaTags;
    property Title: string read FTitle;
    property Author: string read FAuthor;
    property Description: string read FDescription;
    property Keywords: string read FKeywords; 
  published
    property ParseMethod: TclHtmlParseMethod read FParseMethod write FParseMethod default pmTagsOnly;
    property IncludeClosingTags: Boolean read FIncludeClosingTags write FIncludeClosingTags default False;
    property OnParseTag: TclOnParseTag read FOnParseTag write FOnParseTag;
    property OnParseAttribute: TclOnParseAttribute read FOnParseAttribute write FOnParseAttribute;
    property OnParseForm: TclOnParseForm read FOnParseForm write FOnParseForm;
    property OnParseLink: TclOnParseLink read FOnParseLink write FOnParseLink;
    property OnParseFrame: TclOnParseFrame read FOnParseFrame write FOnParseFrame;
    property OnParseImage: TclOnParseImage read FOnParseImage write FOnParseImage;
    property OnParseFormControl: TclOnParseFormControl read FOnParseFormControl write FOnParseFormControl;
    property OnParseTable: TclOnParseTable read FOnParseTable write FOnParseTable;
    property OnParseTableRow: TclOnParseTableRow read FOnParseTableRow write FOnParseTableRow;
    property OnParseTableCell: TclOnParseTableCell read FOnParseTableCell write FOnParseTableCell;
    property OnParseTableCellTag: TclOnParseTableCellTag read FOnParseTableCellTag write FOnParseTableCellTag;
    property OnParseMetaTag: TclOnParseMetaTag read FOnParseMetaTag write FOnParseMetaTag;
  end;

{$IFNDEF MACOS}
{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsHtmlDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}
{$ENDIF}


implementation

uses
{$IFNDEF DELPHIXE2}
  SysUtils{$IFNDEF MACOS}{$IFDEF DEMO}, Forms{$ENDIF}, Windows{$ENDIF};
{$ELSE}
  System.SysUtils{$IFNDEF MACOS}{$IFDEF DEMO}, Vcl.Forms{$ENDIF}, Winapi.Windows{$ENDIF};
{$ENDIF}

{ TclHtmlTag }

procedure TclHtmlTag.AddAttribute(Attribute: TclHtmlAttribute);
begin
  FAttributes.Add(Attribute);
  Attribute.FOwner := Self;
end;

procedure TclHtmlTag.AfterParseTag;
begin
  if (SameText('input', Name) or SameText('select', Name) or SameText('textarea', Name)) then
  begin
    Parser.AddToControls(Self, Owner);
  end;
end;

function TclHtmlTag.AttributeByName(const AName: string): TclHtmlAttribute;
var
  i: Integer;
begin
  for i := 0 to AttributeCount - 1 do
  begin
    if SameText(Attributes[i].Name, AName) then
    begin
      Result := Attributes[i];
      Exit;
    end;
  end;
  Result := nil;
end;

function TclHtmlTag.AttributeValue(const AName: string): string;
var
  Attr: TclHtmlAttribute;
begin
  Attr := AttributeByName(AName);
  if (Attr <> nil) then
  begin
    Result := Attr.Value;
  end else
  begin
    Result := '';
  end;
end;

procedure TclHtmlTag.BeforeParseTag;
begin
end;

function TclHtmlTag.CanAddTableCellTag: Boolean;
begin
  Result := True;
end;

procedure TclHtmlTag.ClearAttributes;
var
  i: Integer;
begin
  for i := 0 to AttributeCount - 1 do
  begin
    Attributes[i].Free();
  end;
  FAttributes.Clear();
end;

constructor TclHtmlTag.Create(const AName, ATagSource: string; AOwner: TclHtmlTag; AParser: TclHtmlParser);
begin
  inherited Create();
  FAttributes := TList.Create();
  FName := AName;
  FTagSource := ATagSource;
  FText := ATagSource;
  FOwner := AOwner;
  FParser := AParser;
end;

destructor TclHtmlTag.Destroy;
begin
  ClearAttributes();
  FAttributes.Free();
  inherited Destroy();
end;

function TclHtmlTag.GetAttribute(Index: Integer): TclHtmlAttribute;
begin
  Result := TclHtmlAttribute(FAttributes[Index]);
end;

function TclHtmlTag.GetAttributeCount: Integer;
begin
  Result := FAttributes.Count;
end;

function TclHtmlTag.GetText: string;
begin
  if IsText then
  begin
    Result := TagSource;
  end else
  if (NextTag <> nil) and NextTag.IsText and (NextTag.Owner <> Owner) then
  begin
    Result := NextTag.Text;
  end else
  begin
    Result := '';
  end;
end;

{ TclHtmlTagList }

constructor TclHtmlTagList.Create(AOwnsObjects: Boolean);
begin
  inherited Create();
  FList := TList.Create();
  FOwnsObjects := AOwnsObjects;
end;

destructor TclHtmlTagList.Destroy;
begin
  Clear();
  FList.Free();
  inherited Destroy();
end;

function TclHtmlTagList.TagByAttributeName(const AName, AttrName, AttrValue: string;
  StartFrom: TclHtmlTag): TclHtmlTag;
var
  i: Integer;
  Attr: TclHtmlAttribute;
begin
  for i := GetStartFromIndex(StartFrom) to Count - 1 do
  begin
    if SameText(Items[i].Name, AName) then
    begin
      Attr := Items[i].AttributeByName(AttrName);
      if ((Attr <> nil) and SameText(Attr.Value, AttrValue)) then
      begin
        Result := Items[i];
        Exit;
      end;
    end;
  end;
  Result := nil; 
end;

function TclHtmlTagList.GetStartFromIndex(StartFrom: TclHtmlTag): Integer;
begin
  if (StartFrom <> nil) then
  begin
    Result := IndexOf(StartFrom);
  end else
  begin
    Result := 0;
  end;
  if Result < 0 then
  begin
    Result := 0;
  end;
end;

function TclHtmlTagList.TagByName(const AName: string; StartFrom: TclHtmlTag): TclHtmlTag;
var
  i: Integer;
begin
  for i := GetStartFromIndex(StartFrom) to Count - 1 do
  begin
    if SameText(Items[i].Name, AName) then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
  Result := nil; 
end;

function TclHtmlTagList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclHtmlTagList.GetItem(Index: Integer): TclHtmlTag;
begin
  Result := TclHtmlTag(FList[Index]);
end;

procedure TclHtmlTagList.Clear;
var
  i: Integer;
begin
  if FOwnsObjects then
  begin
    for i := 0 to Count - 1 do
    begin
      Items[i].Free();
    end;
  end;
  FList.Clear();
end;

procedure TclHtmlTagList.Add(AItem: TclHtmlTag);
begin
  FList.Add(AItem);
end;

procedure TclHtmlTagList.AssignList(AList: TStrings);
var
  i: Integer;
begin
  AList.Clear();
  for i := 0 to Count - 1 do
  begin
    AList.Add(Items[i].TagSource);
  end;
end;

function TclHtmlTagList.GetLast: TclHtmlTag;
begin
  if (Count > 0) then
  begin
    Result := Items[Count - 1];
  end else
  begin
    Result := nil;
  end;
end;

function TclHtmlTagList.GetFirst: TclHtmlTag;
begin
  if (Count > 0) then
  begin
    Result := Items[0];
  end else
  begin
    Result := nil;
  end;
end;

function TclHtmlTagList.IndexOf(ATag: TclHtmlTag): Integer;
begin
  Result := FList.IndexOf(ATag);
end;

{ TclHtmlForm }

procedure TclHtmlForm.AfterParseTag;
begin
  inherited AfterParseTag();
  Parser.DoParseForm(Self);
end;

procedure TclHtmlForm.BeforeParseTag;
begin
  inherited BeforeParseTag();
  Parser.Forms.Add(Self);
end;

constructor TclHtmlForm.Create(const AName, AText: string; AOwner: TclHtmlTag; AParser: TclHtmlParser);
begin
  inherited Create(AName, AText, AOwner, AParser);
  FControls := TclHtmlTagList.Create(False);
end;

destructor TclHtmlForm.Destroy;
begin
  FControls.Free();
  inherited Destroy();
end;

function TclHtmlForm.GetAction: string;
begin
  Result := AttributeValue('action');
end;

function TclHtmlForm.GetEncType: string;
begin
  Result := AttributeValue('enctype');
end;

function TclHtmlForm.GetFormName: string;
begin
  Result := AttributeValue('name');
end;

function TclHtmlForm.GetMethod: string;
begin
  Result := AttributeValue('method');
end;

{ TclTagLexemChecker }

constructor TclTagLexemChecker.Create;
begin
  FLexems := TStringList.Create();
  FEndLexems := TStringList.Create();
  FCheckedLexem := -1;
end;

destructor TclTagLexemChecker.Destroy;
begin
  FEndLexems.Free();
  FLexems.Free();
  inherited Destroy();
end;

procedure TclTagLexemChecker.AddLexem(const ALexem, AEndLexem: string);
begin
  FLexems.AddObject(ALexem, Pointer(1));
  FEndLexems.AddObject(AEndLexem, Pointer(1));
end;

function TclTagLexemChecker.CheckLexems(AKey: Char): TclCheckLexemResult;
var
  i, cnt: Integer;
begin
  FCheckedLexem := -1;
  for i := 0 to FLexems.Count - 1 do
  begin
    cnt := Integer(FLexems.Objects[i]);
    CheckLexem(AKey, FLexems[i], cnt);
    FLexems.Objects[i] := Pointer(cnt);

    cnt := Integer(FEndLexems.Objects[i]);
    CheckLexem(AKey, FEndLexems[i], cnt);
    FEndLexems.Objects[i] := Pointer(cnt);
  end;
  for i := 0 to FEndLexems.Count - 1 do
  begin
    if Integer(FEndLexems.Objects[i]) > Length(FEndLexems[i]) then
    begin
      Result := clLeaveTag;
      FCheckedLexem := i;
      Exit;
    end;
  end;
  for i := 0 to FLexems.Count - 1 do
  begin
    if Integer(FLexems.Objects[i]) > Length(FLexems[i]) then
    begin
      Result := clEnterTag;
      FCheckedLexem := i;
      Exit;
    end;
  end;
  Result := clNone;
end;

procedure TclTagLexemChecker.CheckLexem(AKey: Char; const ALexem: string; var ALexemCount: Integer);
begin
  if (ALexemCount <= Length(ALexem)) and (AKey = ALexem[ALexemCount]) then
  begin
    Inc(ALexemCount);
  end else
  begin
    ALexemCount := 1;
  end;
end;

{ TclHtmlParser }

constructor TclHtmlParser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FTags := TclHtmlTagList.Create(True);
  FForms := TclHtmlFormList.Create(False);
  FLinks := TclHtmlLinkList.Create(False);
  FImages := TclHtmlImageList.Create(False);
  FTables := TclHtmlTableList.Create(False);
  FFrames := TclHtmlFrameList.Create(False);
  FMetaTags := TclHtmlMetaTagList.Create(False);
  FNonClosingTags := TStringList.Create();

  GetNonClosingTags(FNonClosingTags);
  FParseMethod := pmTagsOnly;
end;

destructor TclHtmlParser.Destroy;
begin
  FTableStack.Free();
  FNonClosingTags.Free();
  FMetaTags.Free();
  FFrames.Free();
  FTables.Free();
  FImages.Free();
  FLinks.Free();
  FForms.Free();
  FTags.Free();
  
  inherited Destroy();
end;

function TclHtmlParser.GetTypeFromSymbol(AKey: Char): TclSymbolType;
begin
  case AKey of
    '''', '"':
      Result := stQuote;
    '=':
      Result := stDelimiter;
    Char($20), Char($0A),
    Char($0D), Char($09):
      Result := stWhiteSpace;
    else
      Result := stDontCare;
  end;
end;

procedure TclHtmlParser.ParseTag(ATag: TclHtmlTag; const ALexem: string; ALexemPos: Integer);
  procedure ProcessValue(AKey: Char; var AValue: string; var AIsValue: Boolean);
  begin
    if not AIsValue then
    begin
      AIsValue := True;
      AValue := AKey;
    end else
    begin
      AValue := AValue + AKey;
    end;
  end;
  
var
  len: Integer;
  Next, Start, StartValue: PChar;
  IsName, IsValue, IsValueExpect, InDelimiter, WasName: Boolean;
  Name, Value, LastDelimiter: string;
begin
  if SameText(ATag.Name, '!DOCTYPE') then Exit;
  len := Length(ALexem);
  if (len = 0) then Exit;
  Next := @ALexem[1];
  Start := Next;
  StartValue := Next;
  IsName := False;
  IsValueExpect := False;
  IsValue := False;
  InDelimiter := False;
  LastDelimiter := '';
  WasName := False;
  while (len > 0) do
  begin
    case GetTypeFromSymbol(Next^) of
      stWhiteSpace:
        begin
          if InDelimiter then
          begin
            if not IsValue then
            begin
              StartValue := Next;
            end;
            ProcessValue(Next^, Value, IsValue);
          end else
          if IsValue then
          begin
            CreateAttribute(ATag, Name, Value, ALexemPos + StartValue - Start);
            IsName := False;
            IsValueExpect := False;
            IsValue := False;
            InDelimiter := False;
          end else
          if IsName then
          begin
            WasName := True;
          end;
        end;
      stDontCare:
        begin
          if WasName then
          begin
            CreateAttribute(ATag, Name, '', 0);
            IsName := False;
            IsValueExpect := False;
            IsValue := False;
            InDelimiter := False;
            ProcessValue(Next^, Name, IsName);
          end else
          begin
            if IsValueExpect then
            begin
              if not IsValue then
              begin
                StartValue := Next;
              end;
              ProcessValue(Next^, Value, IsValue);
            end else
            if IsValue then
            begin
              CreateAttribute(ATag, Name, Value, ALexemPos + StartValue - Start);
              IsName := False;
              IsValueExpect := False;
              IsValue := False;
              InDelimiter := False;
              ProcessValue(Next^, Name, IsName);
            end else
            begin
              ProcessValue(Next^, Name, IsName);
            end;
          end;
          WasName := False;
        end;
      stDelimiter:
        begin
          if InDelimiter then
          begin
            if not IsValue then
            begin
              StartValue := Next;
            end;
            ProcessValue(Next^, Value, IsValue);
          end else
          if IsValue then
          begin
            ProcessValue(Next^, Value, IsValue);
          end else
          begin
            IsValueExpect := IsName;
            IsName := False;
            IsValue := False;
          end;
          WasName := False;
        end;
      stQuote:
        begin
          if IsValueExpect then
          begin
            if InDelimiter then
            begin
              if (LastDelimiter <> Next^) then
              begin
                if not IsValue then
                begin
                  StartValue := Next;
                end;
                ProcessValue(Next^, Value, IsValue);
              end else
              begin
                if not IsValue then
                begin
                  CreateAttribute(ATag, Name, '', 0);
                end;
                InDelimiter := False;
                IsValueExpect := False;
              end;
            end else
            begin
              LastDelimiter := Next^;
              InDelimiter := True;
            end;
          end else
          begin
            IsName := False;
            IsValueExpect := False;
            IsValue := False;
            InDelimiter := False;
          end;
          WasName := False;
        end;
    end;
    Inc(Next);
    Dec(len);
  end;
  if IsValue then
  begin
    CreateAttribute(ATag, Name, Value, ALexemPos + StartValue - Start);
  end else
  if IsName then
  begin
    CreateAttribute(ATag, Name, '', 0);
  end;
end;

procedure TclHtmlParser.ProcessTitleStatus(const AName: string);
begin
  if (FTitleStatus = tsNone) and SameText('head', AName) then
  begin
    FTitleStatus := tsEnterHead;
  end else
  if (FTitleStatus = tsEnterHead) and SameText('title', AName) then
  begin
    FTitleStatus := tsEnterTitle;
  end else
  if (FTitleStatus = tsEnterTitle) and SameText('title', AName) then
  begin
    FTitleStatus := tsTitleParsed;
  end;
end;

{$IFDEF MACOS}
function CharPrev(Start, Current: PChar): PChar;
begin
  Result := Current;
  if (Start <> Current) then
  begin
    Dec(Result);
  end;
end;

function CharNext(Current: PChar): PChar;
begin
  Result := Current;
  if (Result^ <> #0) then
  begin
    Inc(Result);
  end;
end;
{$ENDIF}

procedure TclHtmlParser.Parse(const AHtml: string);
var
  InTag, InClosingTag: Boolean;
  InSkipSection: Boolean;
  len: Integer;
  Next, Start, LexemStart: PChar;
  parseText: string;
  curLexem, curText: string;
  Stack: TclHtmlTagStack;
  skipLexems: TclTagLexemChecker;
  ownerTag, tag: TclHtmlTag;
begin
{$IFNDEF MACOS}
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
    if not IsHtmlDemoDisplayed then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsHtmlDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
{$ENDIF}
  Clear();
  parseText := AHtml;
  len := Length(parseText);
  if (len = 0) then Exit;
  Next := @parseText[1];
  Start := Next;
  LexemStart := Next;
  InTag := False;
  InClosingTag := False;
  InSkipSection := False;
  curText := '';

  Stack := nil;
  skipLexems := nil;
  try
    Stack := TclHtmlTagStack.Create();
    skipLexems := TclTagLexemChecker.Create();
    FTableStack.Free();
    FTableStack := TclHtmlTagStack.Create();
    FCurrentLink := nil;
    FTitleStatus := tsNone;

    GetSkipLexems(skipLexems);
    while (len > 0) do
    begin
      case skipLexems.CheckLexems(LowerCase(Next^)[1]) of
        clLeaveTag:
          begin
            InSkipSection := False;

            if IncludeClosingTags then
            begin
              ownerTag := nil;
              if not Stack.IsEmpty then
              begin
                ownerTag := Stack.Top.Owner;
              end;

              tag := CreateTagByName(curLexem, '', ownerTag, Next - Start - Length(skipLexems.EndLexems[skipLexems.CheckedLexem]) + 2);
              tag.FIsClosingTag := True;
              DoParseTag(tag);
            end;
          end;
        clEnterTag:
          begin
            if (not InSkipSection) then
            begin
              curLexem := curLexem + Next^;
              InSkipSection := True;
              CreateTag(curLexem, Stack.Top, Next - Start, LexemStart - Start + 2);

              InTag := False;
              InClosingTag := False;
            end;
          end;
      end;
      if not InSkipSection then
      begin
        case (Next^) of
          '<':
            begin
              if (not InTag) then
              begin
                curLexem := '';
                LexemStart := Next;
                InTag := True;
                if NeedParseText() and (curText <> '') then
                begin
                  CreateText(curText, Stack.Top, Next - Start - Length(curText) + 1);
                  curText := '';
                end;
              end;
            end;
          '>':
            begin
              if (InTag) then
              begin
                if InClosingTag then
                begin
                  ownerTag := nil;
                  if not Stack.IsEmpty then
                  begin
                    ownerTag := Stack.Top.Owner;
                    if SameText(Stack.Top.Name, curLexem) then
                    begin
                      Stack.Pop();
                      if (not FTableStack.IsEmpty) and SameText(curLexem, 'table') then
                      begin
                        FTableStack.Pop();
                      end;
                    end;
                  end;
                  if SameText(curLexem, 'a') then
                  begin
                    FCurrentLink := nil;
                  end;

                  if IncludeClosingTags then
                  begin
                    tag := CreateTagByName(curLexem, '', ownerTag, Next - Start - Length(curLexem) - 1);
                    tag.FIsClosingTag := True;
                    DoParseTag(tag);
                  end;
                end else
                if NeedParseTags() then
                begin
                  if (CharPrev(Start, Next)^ = '/') or IsNonClosingTag(curLexem) then
                  begin
                    tag := CreateTag(curLexem, Stack.Top, Next - Start, LexemStart - Start + 2);
                    if (tag <> nil) and SameText(tag.Name, 'a') then
                    begin
                      FCurrentLink := nil;
                    end;
                  end else
                  begin
                    tag := CreateTag(curLexem, Stack.Top, Next - Start, LexemStart - Start + 2);
                    if (tag <> nil) then
                    begin
                      Stack.Push(tag);
                    end;
                  end;
                end;

                ProcessTitleStatus(curLexem);

                InTag := False;
                InClosingTag := False;
                curLexem := '';
                LexemStart := Next;
              end;
            end;
          '/':
            begin
              if InTag then
              begin
                if (CharPrev(Start, Next)^ = '<') then
                begin
                  InClosingTag := True;
                end else
                if (len - 1 > 0) and (CharNext(Next)^ <> '>') then
                begin
                  curLexem := curLexem + Next^;
                end;
              end else
              begin
                curText := curText + Next^;
              end;
            end;
          else
            begin
              if InTag then
              begin
                curLexem := curLexem + Next^;
              end else
              if NeedParseText() then
              begin
                curText := curText + Next^;
              end;
            end;
        end;
      end;
      Inc(Next);
      Dec(len);
    end;
  finally
    FTableStack.Free();
    FTableStack := nil;
    skipLexems.Free();
    Stack.Free();
  end;

  ExtractMetaTags();
end;

procedure TclHtmlParser.ExtractMetaTags;
var
  metaTag: TclHtmlTag;
begin
  metaTag := Tags.TagByName('title');
  if (metaTag <> nil) and (metaTag.NextTag <> nil) and metaTag.NextTag.IsText then
  begin
    FTitle := metaTag.NextTag.Text;
  end;

  metaTag := MetaTags.TagByAttributeName('meta', 'name', 'author');
  if (metaTag <> nil) then
  begin
    FAuthor := metaTag.AttributeValue('content');
  end;

  metaTag := MetaTags.TagByAttributeName('meta', 'name', 'description');
  if (metaTag <> nil) then
  begin
    FDescription := metaTag.AttributeValue('content');
  end;

  metaTag := MetaTags.TagByAttributeName('meta', 'name', 'keywords');
  if (metaTag <> nil) then
  begin
    FKeywords := metaTag.AttributeValue('content');
  end;
end;

procedure TclHtmlParser.InternalParseTag(ATag: TclHtmlTag; const ALexem: string; ALexemPos: Integer);
var
  isTableCellTag: Boolean;
  TopTable: TclHtmlTable;
begin
  TopTable := TclHtmlTable(FTableStack.Top);

  isTableCellTag := ATag.CanAddTableCellTag()
    and (TopTable <> nil) and (TopTable.Rows.Last <> nil)
    and (TclHtmlTableRow(TopTable.Rows.Last).Cells.Last <> nil);

  if ATag.CanAddTableCellTag() then
  begin
    AddTableCellTag(ATag);
  end;

  ATag.BeforeParseTag();
  ParseTag(ATag, ALexem, ALexemPos);
  DoParseTag(ATag);
  ATag.AfterParseTag();

  if isTableCellTag then
  begin
    DoParseTableCellTag(TopTable, TclHtmlTableRow(TopTable.Rows.Last),
      TclHtmlTableCell(TclHtmlTableRow(TopTable.Rows.Last).Cells.Last),
      ATag);
  end;
end;

function TclHtmlParser.IsNonClosingTag(ATagName: string): Boolean;
var
  len: Integer;
  name: string;
  Next: PChar;
begin
  len := Length(ATagName);
  Result := (len = 0);
  
  if Result then Exit;

  Next := @ATagName[1];
  while (len > 0) and (GetTypeFromSymbol(Next^) = stDontCare) do
  begin
    Inc(Next);
    Dec(len);
  end;

  name := system.Copy(ATagName, 1, Length(ATagName) - len);

  name := LowerCase(Trim(name));

  Result := (FNonClosingTags.IndexOf(name) > -1);
end;

procedure TclHtmlParser.Clear;
begin
  FTags.Clear();
  FForms.Clear();
  FLinks.Clear();
  FImages.Clear();
  FTables.Clear();
  FFrames.Clear();
  FMetaTags.Clear();

  FTitle := '';
  FAuthor := '';
  FDescription := '';
  FKeywords := '';
end;

function TclHtmlParser.CreateTag(const ALexem: string; AOwner: TclHtmlTag;
  AInnerTextPos, AttribPos: Integer): TclHtmlTag;
var
  len: Integer;
  Next: PChar;
  Name, Value: string;
begin
  len := Length(ALexem);
  if (len = 0) then
  begin
    Result := nil;
    Exit;
  end;

  Next := @ALexem[1];
  while (len > 0) and (GetTypeFromSymbol(Next^) = stDontCare) do
  begin
    Inc(Next);
    Dec(len);
    Inc(AttribPos);
  end;

  Name := system.Copy(ALexem, 1, Length(ALexem) - len);
  Value := system.Copy(ALexem, Length(ALexem) - len + 1, len);

  Result := CreateTagByName(Name, RemoveBadChars(ALexem), AOwner, AInnerTextPos + 2);

  if (FCurrentLink <> nil) then
  begin
    FCurrentLink.Tags.Add(Result);
  end;

  InternalParseTag(Result, Value, AttribPos);
end;

procedure TclHtmlParser.AddToControls(ATag, AOwner: TclHtmlTag);
begin
  if (AOwner is TclHtmlForm) then
  begin
    (AOwner as TclHtmlForm).Controls.Add(ATag);
    DoParseFormControl(AOwner as TclHtmlForm, ATag);
  end else
  if (AOwner <> nil) then
  begin
    AddToControls(ATag, AOwner.Owner);
  end;
end;

procedure TclHtmlParser.DoParseAttribute(ATag: TclHtmlTag; Attribute: TclHtmlAttribute);
begin
  if Assigned(OnParseAttribute) then
  begin
    OnParseAttribute(Self, ATag, Attribute);
  end;
end;

procedure TclHtmlParser.DoParseForm(AForm: TclHtmlForm);
begin
  if Assigned(OnParseForm) then
  begin
    OnParseForm(Self, AForm);
  end;
end;

procedure TclHtmlParser.DoParseFormControl(AForm: TclHtmlForm; AControl: TclHtmlTag);
begin
  if Assigned(OnParseFormControl) then
  begin
    OnParseFormControl(Self, AForm, AControl);
  end;
end;

procedure TclHtmlParser.DoParseTag(ATag: TclHtmlTag);
begin
  if Assigned(OnParseTag) then
  begin
    OnParseTag(Self, ATag);
  end;
end;

function TclHtmlParser.CreateAttribute(ATag: TclHtmlTag; const AName, AValue: string;
  AInnerTextPos: Integer): TclHtmlAttribute;
begin
  Result := TclHtmlAttribute.Create(AName, AValue, AInnerTextPos);
  ATag.AddAttribute(Result);
  DoParseAttribute(ATag, Result);
end;

procedure TclHtmlParser.DoParseImage(AImage: TclHtmlImage);
begin
  if Assigned(OnParseImage) then
  begin
    OnParseImage(Self, AImage);
  end;
end;

procedure TclHtmlParser.DoParseLink(ALink: TclHtmlLink);
begin
  if Assigned(OnParseLink) then
  begin
    OnParseLink(Self, ALink);
  end;
end;

function TclHtmlParser.CreateText(const AText: string; AOwner: TclHtmlTag; AInnerTextPos: Integer): TclHtmlTag;
var
  isAddTableCellTag: Boolean;
  TopTable: TclHtmlTable;
begin
  Result := TclHtmlTag.Create('', AText, AOwner, Self);
  AddTag(Result);

  if (FCurrentLink <> nil) then
  begin
    FCurrentLink.Tags.Add(Result);
  end;

  Result.FInnerTextPos := AInnerTextPos;

  isAddTableCellTag := AddTableCellTag(Result);
  Result.FIsText := True;
  DoParseTag(Result);

  if isAddTableCellTag then
  begin
    TopTable := TclHtmlTable(FTableStack.Top);
    DoParseTableCellTag(TopTable, TclHtmlTableRow(TopTable.Rows.Last),
      TclHtmlTableCell(TclHtmlTableRow(TopTable.Rows.Last).Cells.Last),
      Result);
  end;
end;

function TclHtmlParser.NeedParseTags: Boolean;
begin
  Result := (ParseMethod = pmAll) or (ParseMethod = pmTagsOnly);
end;

function TclHtmlParser.NeedParseText: Boolean;
begin
  Result := (FTitleStatus = tsEnterTitle) or (ParseMethod = pmAll) or (ParseMethod = pmTextOnly) or (FCurrentLink <> nil);
end;

procedure TclHtmlParser.GetNonClosingTags(ATags: TStrings);
begin
  ATags.Add('br');
  ATags.Add('input');
  ATags.Add('select');
  ATags.Add('textarea');
  ATags.Add('frame');
  ATags.Add('iframe');
  ATags.Add('img');
  ATags.Add('!doctype');
  ATags.Add('link');
end;

procedure TclHtmlParser.GetSkipLexems(ASkipLexems: TclTagLexemChecker);
begin
  ASkipLexems.AddLexem('<!--', '-->');
end;

function TclHtmlParser.RemoveBadChars(const S: string): string;
var
  i, j: Integer;
begin
  SetLength(Result, Length(S));
  j := 1;
  for i := 1 to Length(S) do
  begin
    if (S[i] <> #13) and (S[i] <> #10) and (S[i] <> #9) then
    begin
      Result[j] := S[i];
      Inc(j);
    end;
  end;
  SetLength(Result, j - 1);
end;

procedure TclHtmlParser.AddTag(ATag: TclHtmlTag);
begin
  if (FTags.Count > 0) then
  begin
    FTags[FTags.Count - 1].FNextTag := ATag;
  end;
  FTags.Add(ATag);
end;

function TclHtmlParser.AddTableCellTag(ATag: TclHtmlTag): Boolean;
begin
  Result := not FTableStack.IsEmpty and (TclHtmlTable(FTableStack.Top).Rows.Last <> nil)
    and (TclHtmlTableRow(TclHtmlTable(FTableStack.Top).Rows.Last).Cells.Last <> nil);
  if Result then
  begin
    TclHtmlTableCell(TclHtmlTableRow(TclHtmlTable(FTableStack.Top).Rows.Last).Cells.Last).Tags.Add(ATag);
  end;
end;

procedure TclHtmlParser.DoParseTable(ATable: TclHtmlTable);
begin
  if Assigned(OnParseTable) then
  begin
    OnParseTable(Self, ATable);
  end;
end;

procedure TclHtmlParser.DoParseTableCell(ATable: TclHtmlTable;
  ARow: TclHtmlTableRow; ACell: TclHtmlTableCell);
begin
  if Assigned(OnParseTableCell) then
  begin
    OnParseTableCell(Self, ATable, ARow, ACell);
  end;
end;

procedure TclHtmlParser.DoParseTableCellTag(ATable: TclHtmlTable;
  ARow: TclHtmlTableRow; ACell: TclHtmlTableCell; ATag: TclHtmlTag);
begin
  if Assigned(OnParseTableCellTag) then
  begin
    OnParseTableCellTag(Self, ATable, ARow, ACell, ATag);
  end;
end;

procedure TclHtmlParser.DoParseTableRow(ATable: TclHtmlTable; ARow: TclHtmlTableRow);
begin
  if Assigned(OnParseTableRow) then
  begin
    OnParseTableRow(Self, ATable, ARow);
  end;
end;

function TclHtmlParser.CreateTagByName(const AName, AText: string; AOwner: TclHtmlTag;
  AInnerTextPos: Integer): TclHtmlTag;
begin
  if SameText('form', AName) then
  begin
    Result := TclHtmlForm.Create(AName, AText, AOwner, Self);
  end else
  if SameText('a', AName) then
  begin
    Result := TclHtmlLink.Create(AName, AText, AOwner, Self);
  end else
  if SameText('frame', AName) or SameText('iframe', AName) then
  begin
    Result := TclHtmlFrame.Create(AName, AText, AOwner, Self);
  end else
  if SameText('img', AName) then
  begin
    Result := TclHtmlImage.Create(AName, AText, AOwner, Self);
  end else
  if SameText('table', AName) then
  begin
    Result := TclHtmlTable.Create(AName, AText, AOwner, Self);
  end else
  if SameText('tr', AName) then
  begin
    Result := TclHtmlTableRow.Create(AName, AText, AOwner, Self);
  end else
  if SameText('td', AName) or SameText('th', AName) then
  begin
    Result := TclHtmlTableCell.Create(AName, AText, AOwner, Self);
  end else
  if SameText('meta', AName) then
  begin
    Result := TclHtmlMetaTag.Create(AName, AText, AOwner, Self);
  end else
  begin
    Result := TclHtmlTag.Create(AName, AText, AOwner, Self);
  end;
  AddTag(Result);
  Result.FInnerTextPos := AInnerTextPos;
end;

procedure TclHtmlParser.DoParseFrame(AFrame: TclHtmlFrame);
begin
  if Assigned(OnParseFrame) then
  begin
    OnParseFrame(Self, AFrame);
  end;
end;

procedure TclHtmlParser.Parse(const AHtml: TStrings);
begin
  Parse(AHtml.Text);
end;

procedure TclHtmlParser.DoParseMetaTag(AMetaTag: TclHtmlMetaTag);
begin
  if Assigned(OnParseMetaTag) then
  begin
    OnParseMetaTag(Self, AMetaTag);
  end;
end;

{ TclHtmlFormList }

function TclHtmlFormList.FormByName(const AName: string; StartFrom: TclHtmlTag): TclHtmlForm;
var
  tag: TclHtmlTag;
begin
  tag := TagByAttributeName('form', 'name', AName, StartFrom);
  if (tag <> nil) then
  begin
    Result := tag as TclHtmlForm;
  end else
  begin
    Result := nil;
  end;
end;

function TclHtmlFormList.GetItem(Index: Integer): TclHtmlForm;
begin
  Result := (inherited Items[Index] as TclHtmlForm);
end;

{ TclHtmlTagStack }

constructor TclHtmlTagStack.Create;
begin
  inherited Create();
  FList := TList.Create();
end;

destructor TclHtmlTagStack.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function TclHtmlTagStack.GetIsEmpty: Boolean;
begin
  Result := (FList.Count = 0);
end;

function TclHtmlTagStack.GetTop: TclHtmlTag;
begin
  if IsEmpty then
  begin
    Result := nil;
  end else
  begin
    Result := TclHtmlTag(FList.Last());
  end;
end;

function TclHtmlTagStack.Pop: TclHtmlTag;
begin
  Result := Top;
  FList.Remove(Result);
end;

function TclHtmlTagStack.Push(AItem: TclHtmlTag): TclHtmlTag;
begin
  FList.Add(AItem);
  Result := AItem;
end;

{ TclHtmlAttribute }

constructor TclHtmlAttribute.Create(const AName, AValue: string; AInnerTextPos: Integer);
begin
  inherited Create();
  FName := AName;
  FValue := AValue;
  FInnerTextPos := AInnerTextPos;
end;

{ TclHtmlLink }

procedure TclHtmlLink.AfterParseTag;
begin
  inherited AfterParseTag();
  Parser.DoParseLink(Self);
end;

procedure TclHtmlLink.BeforeParseTag;
begin
  inherited BeforeParseTag();
  Parser.Links.Add(Self);
  Parser.FCurrentLink := Self;
end;

constructor TclHtmlLink.Create(const AName, AText: string;
  AOwner: TclHtmlTag; AParser: TclHtmlParser);
begin
  inherited Create(AName, AText, AOwner, AParser);
  FTags := TclHtmlTagList.Create(False);
end;

destructor TclHtmlLink.Destroy;
begin
  FTags.Free();
  inherited Destroy();
end;

function TclHtmlLink.GetHref: string;
begin
  Result := AttributeValue('href');
end;

function TclHtmlLink.GetLinkText: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to FTags.Count - 1 do
  begin
    if FTags[i].IsText then
    begin
      Result := Result + FTags[i].Text;
    end;
  end;
  Result := Trim(Result);
end;

function TclHtmlLink.GetTarget: string;
begin
  Result := AttributeValue('target');
end;

{ TclHtmlLinkList }

function TclHtmlLinkList.GetItem(Index: Integer): TclHtmlLink;
begin
  Result := (inherited Items[Index] as TclHtmlLink);
end;

{ TclHtmlImageList }

function TclHtmlImageList.GetItem(Index: Integer): TclHtmlImage;
begin
  Result := (inherited Items[Index] as TclHtmlImage);
end;

{ TclHtmlImage }

procedure TclHtmlImage.AfterParseTag;
begin
  inherited AfterParseTag();
  Parser.DoParseImage(Self);
end;

//+-------------------------------------------------------------------------
//  Brought to you by Especialista - www.board4all.biz
//--------------------------------------------------------------------------

procedure TclHtmlImage.BeforeParseTag;
begin
  inherited BeforeParseTag();
  Parser.Images.Add(Self);
end;

function TclHtmlImage.GetAlt: string;
begin
  Result := AttributeValue('alt');
end;

function TclHtmlImage.GetHeight: Integer;
begin
  Result := StrToIntDef(AttributeValue('height'), 0);
end;

function TclHtmlImage.GetSrc: string;
begin
  Result := AttributeValue('src');
end;

function TclHtmlImage.GetWidth: Integer;
begin
  Result := StrToIntDef(AttributeValue('width'), 0);
end;

{ TclHtmlTableCell }

procedure TclHtmlTableCell.AfterParseTag;
var
  TopTable: TclHtmlTable;
begin
  inherited AfterParseTag();

  TopTable := TclHtmlTable(Parser.FTableStack.Top);

  if (TopTable <> nil) and (TopTable.Rows.Last <> nil) then
  begin
    Parser.DoParseTableCell(TopTable, TclHtmlTableRow(TopTable.Rows.Last), Self);
  end;
end;

procedure TclHtmlTableCell.BeforeParseTag;
var
  TopTable: TclHtmlTable;
begin
  inherited BeforeParseTag();
  
  TopTable := TclHtmlTable(Parser.FTableStack.Top);

  if (TopTable <> nil) and (TopTable.Rows.Last <> nil) then
  begin
    TclHtmlTableRow(TopTable.Rows.Last).Cells.Add(Self);
  end;
end;

function TclHtmlTableCell.CanAddTableCellTag: Boolean;
begin
  Result := False;
end;

constructor TclHtmlTableCell.Create(const AName, AText: string;
  AOwner: TclHtmlTag; AParser: TclHtmlParser);
begin
  inherited Create(AName, AText, AOwner, AParser);
  FTags := TclHtmlTagList.Create(False);
end;

destructor TclHtmlTableCell.Destroy;
begin
  FTags.Free();
  inherited Destroy();
end;

function TclHtmlTableCell.GetColSpan: Integer;
begin
  Result := StrToIntDef(AttributeValue('colspan'), 0);
end;

function TclHtmlTableCell.GetHeight: Integer;
begin
  Result := StrToIntDef(AttributeValue('height'), 0);
end;

function TclHtmlTableCell.GetRowSpan: Integer;
begin
  Result := StrToIntDef(AttributeValue('rowspan'), 0);
end;

function TclHtmlTableCell.GetWidth: Integer;
begin
  Result := StrToIntDef(AttributeValue('width'), 0);
end;

{ TclHtmlTableCellList }

function TclHtmlTableCellList.GetItem(Index: Integer): TclHtmlTableCell;
begin
  Result := (inherited Items[Index] as TclHtmlTableCell);
end;

{ TclHtmlTableRow }

procedure TclHtmlTableRow.AfterParseTag;
var
  TopTable: TclHtmlTable;
begin
  inherited AfterParseTag();

  TopTable := TclHtmlTable(Parser.FTableStack.Top);

  if TopTable <> nil then
  begin
    Parser.DoParseTableRow(TopTable, Self);
  end;
end;

procedure TclHtmlTableRow.BeforeParseTag;
var
  TopTable: TclHtmlTable;
begin
  inherited BeforeParseTag();

  TopTable := TclHtmlTable(Parser.FTableStack.Top);

  if TopTable <> nil then
  begin
    TopTable.Rows.Add(Self);
  end;
end;

function TclHtmlTableRow.CanAddTableCellTag: Boolean;
begin
  Result := False;
end;

constructor TclHtmlTableRow.Create(const AName, AText: string;
  AOwner: TclHtmlTag; AParser: TclHtmlParser);
begin
  inherited Create(AName, AText, AOwner, AParser);
  FCells := TclHtmlTableCellList.Create(False);
end;

destructor TclHtmlTableRow.Destroy;
begin
  FCells.Free();
  inherited Destroy();
end;

{ TclHtmlTableRowList }

function TclHtmlTableRowList.GetItem(Index: Integer): TclHtmlTableRow;
begin
  Result := (inherited Items[Index] as TclHtmlTableRow);
end;

{ TclHtmlTable }

procedure TclHtmlTable.AfterParseTag;
begin
  inherited AfterParseTag();
  Parser.DoParseTable(Self);
end;

procedure TclHtmlTable.BeforeParseTag;
begin
  inherited BeforeParseTag();
  Parser.Tables.Add(Self);
  Parser.FTableStack.Push(Self);
end;

constructor TclHtmlTable.Create(const AName, AText: string;
  AOwner: TclHtmlTag; AParser: TclHtmlParser);
begin
  inherited Create(AName, AText, AOwner, AParser);
  FRows := TclHtmlTableRowList.Create(False);
end;

destructor TclHtmlTable.Destroy;
begin
  FRows.Free();
  inherited Destroy();
end;

function TclHtmlTable.GetBorder: Integer;
begin
  Result := StrToIntDef(AttributeValue('border'), 0);
end;

function TclHtmlTable.GetCellPadding: Integer;
begin
  Result := StrToIntDef(AttributeValue('cellpadding'), 0);
end;

function TclHtmlTable.GetCellSpacing: Integer;
begin
  Result := StrToIntDef(AttributeValue('cellspacing'), 0);
end;

function TclHtmlTable.GetHeight: Integer;
begin
  Result := StrToIntDef(AttributeValue('height'), 0);
end;

function TclHtmlTable.GetWidth: Integer;
begin
  Result := StrToIntDef(AttributeValue('width'), 0);
end;

{ TclHtmlTableList }

function TclHtmlTableList.GetItem(Index: Integer): TclHtmlTable;
begin
  Result := (inherited Items[Index] as TclHtmlTable);
end;

{ TclHtmlFrame }

procedure TclHtmlFrame.AfterParseTag;
begin
  inherited AfterParseTag();
  Parser.DoParseFrame(Self);
end;

procedure TclHtmlFrame.BeforeParseTag;
begin
  inherited BeforeParseTag();
  Parser.Frames.Add(Self);
end;

function TclHtmlFrame.GetSrc: string;
begin
  Result := AttributeValue('src');
end;

{ TclHtmlFrameList }

function TclHtmlFrameList.GetItem(Index: Integer): TclHtmlFrame;
begin
  Result := (inherited Items[Index] as TclHtmlFrame);
end;

{ TclHtmlMetaTagList }

function TclHtmlMetaTagList.GetItem(Index: Integer): TclHtmlMetaTag;
begin
  Result := (inherited Items[Index] as TclHtmlMetaTag);
end;

{ TclHtmlMetaTag }

procedure TclHtmlMetaTag.AfterParseTag;
begin
  inherited AfterParseTag();
  Parser.DoParseMetaTag(Self);
end;

procedure TclHtmlMetaTag.BeforeParseTag;
begin
  inherited BeforeParseTag();
  Parser.MetaTags.Add(Self);
end;

function TclHtmlMetaTag.GetContent: string;
begin
  Result := AttributeValue('content');
end;

function TclHtmlMetaTag.GetHttpEquiv: string;
begin
  Result := AttributeValue('http-equiv');
end;

function TclHtmlMetaTag.GetMetaName: string;
begin
  Result := AttributeValue('name');
end;

end.

