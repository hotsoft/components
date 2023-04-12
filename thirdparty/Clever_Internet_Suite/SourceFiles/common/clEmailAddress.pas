{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clEmailAddress;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils;
{$ELSE}
  System.Classes, System.SysUtils;
{$ENDIF}

type
  TclEmailAddressItem = class(TCollectionItem)
  private
    FName: string;
    FEmail: string;

    function GetNormName(const AName: string): string;
    function GetDenormName(const AName: string): string;
    function GetFullAddress: string;
    procedure SetFullAddress(const Value: string);
    function IsValidAddressKey(AKey: Char; AIsBasic: Boolean): Boolean;
    function ExtractAddress(const AFullAddress: string): string;
    function ExtractDisplayName(const AFullAddress, AEmail: string): string;
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); overload; override;
    constructor Create; reintroduce; overload;
    constructor Create(const AEmail, AName: string); reintroduce; overload;
    constructor Create(const AFullAddress: string); reintroduce; overload;

    procedure Assign(Source: TPersistent); override;
    procedure Clear; virtual;
  published
    property Name: string read FName write FName;
    property Email: string read FEmail write FEmail;
    property FullAddress: string read GetFullAddress write SetFullAddress stored False;
  end;

  TclEmailAddressList = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TclEmailAddressItem;
    procedure SetItem(Index: Integer; const Value: TclEmailAddressItem);
    function GetEmailAddresses: string;
    procedure SetEmailAddresses(const Value: string);
    function GetDisplayName: string;
  public
    function Add: TclEmailAddressItem; overload;
    function Add(const AEmail, AName: string): TclEmailAddressItem; overload;
    function Add(const AFullAddress: string): TclEmailAddressItem; overload;
    function ItemByName(const AName: string): TclEmailAddressItem;
    function ItemByEmail(const AEmail: string): TclEmailAddressItem;
    procedure GetEmailList(AList: TStrings); overload;
    procedure GetEmailList(AList: TStrings; IsInit: Boolean); overload;

    property Items[Index: Integer]: TclEmailAddressItem read GetItem write SetItem; default;
    property EmailAddresses: string read GetEmailAddresses write SetEmailAddresses;
    property DisplayName: string read GetDisplayName;
  end;

function GetCompleteEmailAddress(const AName, AEmail: string): string;
function GetEmailAddressParts(const ACompleteEmail: string; var AName, AEmail: string): Boolean;

implementation

uses
  clUtils, clIdnTranslator, clWUtils;

const
  cListSeparator: array[Boolean] of string = ('', ', ');
  SpecialSymbols = ['\', '"', '(', ')'];

function GetCompleteEmailAddress(const AName, AEmail: string): string;
var
  addr: TclEmailAddressItem;
begin
  addr := TclEmailAddressItem.Create();
  try
    addr.Name := AName;
    addr.Email := AEmail;
    Result := addr.FullAddress;
  finally
    addr.Free();
  end;
end;

function GetEmailAddressParts(const ACompleteEmail: string; var AName, AEmail: string): Boolean;
var
  addr: TclEmailAddressItem;
begin
  addr := TclEmailAddressItem.Create();
  try
    addr.FullAddress := ACompleteEmail;
    AEmail := addr.Email;
    AName := addr.Name;

    Result := (AName <> '');
    if not Result then
    begin
      AName := AEmail;
    end;
  finally
    addr.Free();
  end;
end;

{ TclEmailAddressItem }

constructor TclEmailAddressItem.Create;
begin
  inherited Create(nil);
end;

constructor TclEmailAddressItem.Create(const AEmail, AName: string);
begin
  inherited Create(nil);
  Name := AName;
  Email := AEmail;
end;

procedure TclEmailAddressItem.Assign(Source: TPersistent);
begin
  if (Source is TclEmailAddressItem) then
  begin
    FName := TclEmailAddressItem(Source).Name;
    FEmail := TclEmailAddressItem(Source).Email;
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclEmailAddressItem.Clear;
begin
  FName := '';
  FEmail := '';
end;

constructor TclEmailAddressItem.Create(const AFullAddress: string);
begin
  inherited Create(nil);
  FullAddress := AFullAddress;
end;

constructor TclEmailAddressItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
end;

function TclEmailAddressItem.ExtractAddress(const AFullAddress: string): string;
var
  i, len, addrStart: Integer;
  isAt, inQuote, inBracket, inComment, isBasic: Boolean;
begin
  Result := '';

  addrStart := -1;
  isAt := False;
  inQuote := False;
  inBracket := False;
  inComment := False;
  len := Length(AFullAddress);
  isBasic := TclIdnTranslator.IsBasic(AFullAddress);

  for i := 1 to len do
  begin
    if (not inQuote) and (not inComment) and (AFullAddress[i] = '@') and (i > 1) and (i < len)
      and IsValidAddressKey(AFullAddress[i - 1], isBasic) and IsValidAddressKey(AFullAddress[i + 1], isBasic) then
    begin
      isAt := True;
    end;

    if (AFullAddress[i] = '"') and ((i = 1) or (AFullAddress[i - 1] <> '\')) then
    begin
      inQuote := not inQuote;
    end;

    if (AFullAddress[i] = '<') and ((i = 1) or (AFullAddress[i - 1] <> '\')) then
    begin
      addrStart := -1;
      inBracket := True;
      Continue;
    end;

    if inBracket and (AFullAddress[i] = '>') and ((i = 1) or (AFullAddress[i - 1] <> '\')) then
    begin
      if (addrStart > -1) then
      begin
        Result := system.Copy(AFullAddress, addrStart, i - addrStart);
      end else
      begin
        Result := AFullAddress;
      end;
      inBracket := False;
      addrStart := -1;
    end;

    if (not inQuote) and (AFullAddress[i] = '(') and ((i = 1) or (AFullAddress[i - 1] <> '\')) then
    begin
      inComment := True;
    end;

    if inComment and (AFullAddress[i] = ')') and ((i = 1) or (AFullAddress[i - 1] <> '\')) then
    begin
      inComment := False;
    end;

    if inQuote or inBracket or IsValidAddressKey(AFullAddress[i], isBasic) then
    begin
      if (addrStart < 0) then
      begin
        addrStart := i;
      end;
    end else
    begin
      if isAt and (addrStart > -1) then
      begin
        Result := system.Copy(AFullAddress, addrStart, i - addrStart);
      end;
      addrStart := -1;
      isAt := False;
    end;
  end;

  if (isAt or inBracket) and (addrStart > -1) and (Result = '') then
  begin
    Result := system.Copy(AFullAddress, addrStart, MaxInt);
  end;
end;

function TclEmailAddressItem.ExtractDisplayName(const AFullAddress, AEmail: string): string;
begin
  if(system.Pos(UpperCase('<' + AEmail + '>'), UpperCase(AFullAddress)) > 0) then
  begin
    Result := StringReplace(AFullAddress, '<' + AEmail + '>', '', [rfIgnoreCase]);
  end else
  begin
    Result := StringReplace(AFullAddress, AEmail, '', [rfIgnoreCase]);
  end;

  Result := Trim(GetDenormName(Result));
  Result := ExtractQuotedString(Result, '''');
  Result := ExtractQuotedString(Result, '(', ')');
end;

function TclEmailAddressItem.GetDenormName(const AName: string): string;
var
  i, j: Integer;
  Len: Integer;
  SpecSymExpect: Boolean;
  Sym: Char;
begin
  SpecSymExpect := False;
  Len := Length(AName);
  SetLength(Result, Len);
  i := 1;
  j := 1;
  while (i <= Length(AName)) do
  begin
    Sym := AName[i];
    case Sym of
      '\':
          begin
            if not SpecSymExpect then
            begin
              SpecSymExpect := True;
              Inc(i);
              Continue;
            end;
          end;
      '"':
          begin
            if not SpecSymExpect then
            begin
             Sym := ' ';
            end;
          end;
    end;
    SpecSymExpect := False;
    Result[j] := Sym;
    Inc(j);
    Inc(i);
  end;
  SetLength(Result, j - 1);
end;

function TclEmailAddressItem.GetDisplayName: string;
begin
  Result := Name;
  if (Result = '') then
  begin
    Result := Email;
  end;
end;

function TclEmailAddressItem.GetFullAddress: string;
begin
  if (Name = '') or (Name = Email) then
  begin
    Result := Email;
  end else
  begin
    Result := Format('%s <%s>', [GetNormName(Name), Email]);
  end;
end;

function TclEmailAddressItem.GetNormName(const AName: string): string;
  function GetSymbolsTotalCount(const AValue: String; ASymbolsSet: TCharSet): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 1 to Length(AValue) do
    begin
      if CharInSet(AValue[i], ASymbolsSet) then Inc(Result);
    end;
  end;

var
  i, j, SpecialCount: Integer;
begin
  SpecialCount := GetSymbolsTotalCount(AName, SpecialSymbols);
  if (SpecialCount > 0) then
  begin
    SetLength(Result, SpecialCount + Length(AName));
    j := 0;
    for i := 1 to Length(AName) do
    begin
      Inc(j);
      if CharInSet(AName[i], SpecialSymbols) then
      begin
        Result[j] := '\';
        Inc(j);
      end;
      Result[j] := AName[i];
    end;
    Result := GetQuotedString(Result);
  end else
  begin
    Result := AName;
  end;
  if (system.Pos(' ', Result) > 0) then
  begin
    Result := GetQuotedString(Result);
  end;
end;

function TclEmailAddressItem.IsValidAddressKey(AKey: Char; AIsBasic: Boolean): Boolean;
const
  validKeys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!#$%&''*+-/=?_`{}|~^.@"';
  specKeys = '<>';
begin
  if AIsBasic then
  begin
    Result := Pos(AKey, validKeys) > 0;
  end else
  begin
    Result := Pos(AKey, specKeys) < 1;
  end;
end;

procedure TclEmailAddressItem.SetFullAddress(const Value: string);
begin
  Email := ExtractAddress(Value);
  Name := ExtractDisplayName(Value, Email);
end;

{ TclEmailAddressList }

function TclEmailAddressList.Add: TclEmailAddressItem;
begin
  Result := TclEmailAddressItem(inherited Add());
end;

function TclEmailAddressList.Add(const AEmail, AName: string): TclEmailAddressItem;
begin
  Result := Add();
  Result.Email := AEmail;
  Result.Name := AName;
end;

function TclEmailAddressList.Add(const AFullAddress: string): TclEmailAddressItem;
begin
  Result := Add();
  Result.FullAddress := AFullAddress;
end;

function TclEmailAddressList.GetDisplayName: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
  begin
    Result := Result + cListSeparator[i > 0] + Items[i].DisplayName;
  end;
end;

function TclEmailAddressList.GetEmailAddresses: string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
  begin
    Result := Result + cListSeparator[i > 0] + Items[i].FullAddress;
  end;
end;

procedure TclEmailAddressList.GetEmailList(AList: TStrings);
begin
  GetEmailList(AList, True);
end;

procedure TclEmailAddressList.GetEmailList(AList: TStrings; IsInit: Boolean);
var
  i: Integer;
begin
  if IsInit then
  begin
    AList.Clear();
  end;
  
  for i := 0 to Count - 1 do
  begin
    AList.Add(Items[i].FullAddress);
  end;
end;

function TclEmailAddressList.GetItem(Index: Integer): TclEmailAddressItem;
begin
  Result := TclEmailAddressItem(inherited GetItem(Index));
end;

function TclEmailAddressList.ItemByEmail(const AEmail: string): TclEmailAddressItem;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if SameText(Result.Email, AEmail) then Exit;
  end;
  Result := nil;
end;

function TclEmailAddressList.ItemByName(const AName: string): TclEmailAddressItem;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if SameText(Result.Name, AName) then Exit;
  end;
  Result := nil;
end;

procedure TclEmailAddressList.SetEmailAddresses(const Value: string);
var
  StartPos, EndPos,
  Quote, i, Len: integer;
  s: string;
  c: Char;
begin
  Clear();
  Quote := 0;
  i := 1;
  Len := Length(Value);
  while (i <= Len) do
  begin
    StartPos := i;
    EndPos := StartPos;
    while (i <= Len) do
    begin
      c := Value[i];
      if (c = '"') or (c = '''') then
      begin
        Inc(Quote);
      end;
      if (c = ',') or (c = ';') or (c = #13) then
      begin
        if (Quote <> 1) then
        begin
          Break;
        end;
      end;
      Inc(EndPos);
      Inc(i);
    end;
    s := Trim(Copy(Value, StartPos, EndPos - StartPos));
    if Length(s) > 0 then
    begin
      Add(s);
    end;
    i := EndPos + 1;
    Quote := 0;
  end;
end;

procedure TclEmailAddressList.SetItem(Index: Integer; const Value: TclEmailAddressItem);
begin
  inherited SetItem(Index, Value);
end;

end.
