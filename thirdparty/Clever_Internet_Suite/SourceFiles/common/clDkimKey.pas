{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clDkimKey;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Contnrs,
{$ELSE}
  System.Classes, System.SysUtils, System.Contnrs,
{$ENDIF}
  clConfig;

type
  TclDkimKeyFlag = (ddfTestingDomain, ddfCheckUserIdentityDomain);
  TclDkimKeyFlags = set of TclDkimKeyFlag;

  TclDkimKeyServiceType = (ddsAll, ddsEmail);
  TclDkimKeyServiceTypes = set of TclDkimKeyServiceType;

  TclDkimKey = class
  private
    FVersion: string;
    FAcceptableHashAlgorithms: TStrings;
    FKeyType: string;
    FNotes: string;
    FPublicKey: string;
    FServiceType: TclDkimKeyServiceTypes;
    FFlags: TclDkimKeyFlags;

    procedure ParseAcceptableHashAlgorithms(const ASource: string);
    function ParseNotes(const ASource: string): string;
    function ParseServiceType(const ASource: string): TclDkimKeyServiceTypes;
    function ParseFlags(const ASource: string): TclDkimKeyFlags;
    function GetAcceptableHashAlgorithms: string;
    function GetNotes: string;
    function GetServiceType: string;
    function GetFlags: string;
    procedure SetAcceptableHashAlgorithms(const Value: TStrings);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Parse(const ATxt: string); virtual;
    function Build: string; virtual;
    procedure Clear; virtual;

    property Version: string read FVersion write FVersion;
    property AcceptableHashAlgorithms: TStrings read FAcceptableHashAlgorithms write SetAcceptableHashAlgorithms;
    property KeyType: string read FKeyType write FKeyType;
    property Notes: string read FNotes write FNotes;
    property PublicKey: string read FPublicKey write FPublicKey;
    property ServiceType: TclDkimKeyServiceTypes read FServiceType write FServiceType;
    property Flags: TclDkimKeyFlags read FFlags write FFlags;
  end;

  TclDkimKeyList = class
  private
    FList: TObjectList;

    function GetCount: Integer;
    function GetItem(Index: Integer): TclDkimKey;
  public
    constructor Create;
    destructor Destroy; override;

    function Add(AItem: TclDkimKey): TclDkimKey;
    procedure Delete(Index: Integer);
    procedure Clear;

    property Items[Index: Integer]: TclDkimKey read GetItem; default;
    property Count: Integer read GetCount;
  end;


implementation

uses
  clUtils, clDkimUtils, clEncoder;

const
  cDkimKeyServiceTypes: array[TclDkimKeyServiceType] of string = ('*', 'email');
  cDkimKeyFlags: array[TclDkimKeyFlag] of string = ('y', 's');

{ TclDkimDnsRecord }

function TclDkimKey.GetAcceptableHashAlgorithms: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to AcceptableHashAlgorithms.Count - 1 do
  begin
    Result := Result + AcceptableHashAlgorithms[i] + ':';
  end;
  if (Length(Result) > 0) then
  begin
    System.Delete(Result, Length(Result), 1);
  end;
end;

function TclDkimKey.GetNotes: string;
begin
  Result := TclDkimQuotedPrintableEncoder.Encode(Notes);
end;

function TclDkimKey.GetServiceType: string;
var
  k: TclDkimKeyServiceType;
begin
  Result := '';
  for k := Low(TclDkimKeyServiceType) to High(TclDkimKeyServiceType) do
  begin
    if (k in ServiceType) then
    begin
      Result := Result + cDkimKeyServiceTypes[k] + ':';
    end;
  end;
  if (Length(Result) > 0) then
  begin
    System.Delete(Result, Length(Result), 1);
  end;
end;

function TclDkimKey.GetFlags: string;
var
  k: TclDkimKeyFlag;
begin
  Result := '';
  for k := Low(TclDkimKeyFlag) to High(TclDkimKeyFlag) do
  begin
    if (k in Flags) then
    begin
      Result := Result + cDkimKeyFlags[k] + ':';
    end;
  end;
  if (Length(Result) > 0) then
  begin
    System.Delete(Result, Length(Result), 1);
  end;
end;

function TclDkimKey.Build: string;
const
  dkimKey = 'key';
var
  fieldList: TclDkimHeaderFieldList;
  src: TStrings;
begin
  fieldList := nil;
  src := nil;
  try
    fieldList := TclDkimHeaderFieldList.Create();
    src := TStringList.Create();

    fieldList.Parse(0, src);
    fieldList.AddEmptyField(dkimKey);

    fieldList.AddFieldItem(dkimKey, 'v', Version);
    fieldList.AddFieldItem(dkimKey, 'h', GetAcceptableHashAlgorithms());
    fieldList.AddFieldItem(dkimKey, 'k', KeyType);
    fieldList.AddFieldItem(dkimKey, 'n', GetNotes());
    fieldList.AddFieldItem(dkimKey, 's', GetServiceType());
    fieldList.AddFieldItem(dkimKey, 't', GetFlags());

    if (PublicKey = '') then
    begin
      fieldList.AddEmptyFieldItem(dkimKey, 'p');
    end else
    begin
      fieldList.AddFieldItem(dkimKey, 'p', PublicKey);
    end;

    Result := fieldList.GetFieldValue(dkimKey);
  finally
    src.Free();
    fieldList.Free();
  end;
end;

procedure TclDkimKey.Clear;
begin
  FVersion := '';
  FAcceptableHashAlgorithms.Clear();
  FKeyType := '';
  FNotes := '';
  FPublicKey := '';
  FServiceType := [];
  FFlags := [];
end;

constructor TclDkimKey.Create;
begin
  inherited Create();

  FAcceptableHashAlgorithms := TStringList.Create();
  Clear();
end;

destructor TclDkimKey.Destroy;
begin
  FAcceptableHashAlgorithms.Free();
  inherited Destroy();
end;

procedure TclDkimKey.ParseAcceptableHashAlgorithms(const ASource: string);
begin
  SplitText(Trim(ASource), AcceptableHashAlgorithms, ':');
end;

function TclDkimKey.ParseNotes(const ASource: string): string;
begin
  Result := TclDkimQuotedPrintableEncoder.Decode(ASource);
end;

function TclDkimKey.ParseServiceType(const ASource: string): TclDkimKeyServiceTypes;
var
  i: Integer;
  k: TclDkimKeyServiceType;
  list: TStrings;
begin
  Result := [];

  list := TStringList.Create();
  try
    SplitText(Trim(ASource), list, ':');

    for i := 0 to list.Count - 1 do
    begin
      for k := Low(TclDkimKeyServiceType) to High(TclDkimKeyServiceType) do
      begin
        if (Trim(list[i]) = cDkimKeyServiceTypes[k]) then
        begin
          Result := Result + [k];
          Break;
        end;
      end;
    end;
  finally
    list.Free();
  end;
end;

procedure TclDkimKey.SetAcceptableHashAlgorithms(const Value: TStrings);
begin
  FAcceptableHashAlgorithms.Assign(Value);
end;

function TclDkimKey.ParseFlags(const ASource: string): TclDkimKeyFlags;
var
  i: Integer;
  k: TclDkimKeyFlag;
  list: TStrings;
begin
  Result := [];

  list := TStringList.Create();
  try
    SplitText(Trim(ASource), list, ':');

    for i := 0 to list.Count - 1 do
    begin
      for k := Low(TclDkimKeyFlag) to High(TclDkimKeyFlag) do
      begin
        if (Trim(list[i]) = cDkimKeyFlags[k]) then
        begin
          Result := Result + [k];
          Break;
        end;
      end;
    end;
  finally
    list.Free();
  end;
end;

procedure TclDkimKey.Parse(const ATxt: string);
var
  fieldList: TclDkimHeaderFieldList;
begin
  fieldList := TclDkimHeaderFieldList.Create();
  try
    FVersion := Trim(fieldList.GetFieldValueItem(ATxt, 'v'));
    ParseAcceptableHashAlgorithms(fieldList.GetFieldValueItem(ATxt, 'h'));
    FKeyType := Trim(fieldList.GetFieldValueItem(ATxt, 'k'));
    FNotes := ParseNotes(fieldList.GetFieldValueItem(ATxt, 'n'));
    FPublicKey := Trim(fieldList.GetFieldValueItem(ATxt, 'p'));
    FServiceType := ParseServiceType(fieldList.GetFieldValueItem(ATxt, 's'));
    FFlags := ParseFlags(fieldList.GetFieldValueItem(ATxt, 't'));
  finally
    fieldList.Free();
  end;
end;

{ TclDkimKeyList }

function TclDkimKeyList.Add(AItem: TclDkimKey): TclDkimKey;
begin
  FList.Add(AItem);
  Result := AItem;
end;

procedure TclDkimKeyList.Clear;
begin
  FList.Clear();
end;

constructor TclDkimKeyList.Create;
begin
  inherited Create();
  FList := TObjectList.Create(True);
end;

procedure TclDkimKeyList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TclDkimKeyList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function TclDkimKeyList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclDkimKeyList.GetItem(Index: Integer): TclDkimKey;
begin
  Result := TclDkimKey(FList[Index]);
end;

end.
