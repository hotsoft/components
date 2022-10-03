{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clMailUserMgr;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clUserMgr;

type
  TclMailUserAccountItem = class(TclUserAccountItem)
  private
    FEmail: string;
  public
    procedure Assign(Source: TPersistent); override;
  published
    property Email: string read FEmail write FEmail;
  end;

  TclMailUserAccountList = class(TclUserAccountList)
  private
    function GetItem(Index: Integer): TclMailUserAccountItem;
    procedure SetItem(Index: Integer; const Value: TclMailUserAccountItem);
  public
    function Add: TclMailUserAccountItem;
    function AccountByEmail(const AEmail: string): TclMailUserAccountItem;
    function AccountByUserName(const AUserName: string): TclMailUserAccountItem;
    property Items[Index: Integer]: TclMailUserAccountItem read GetItem write SetItem; default;
  end;

implementation

{ TclMailUserAccountItem }

procedure TclMailUserAccountItem.Assign(Source: TPersistent);
begin
  if (Source is TclMailUserAccountItem) then
  begin
    FEmail := (Source as TclMailUserAccountItem).Email;
  end;
  inherited Assign(Source);
end;

{ TclMailUserAccountList }

function TclMailUserAccountList.AccountByEmail(const AEmail: string): TclMailUserAccountItem;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if CaseInsensitive then
    begin
      if SameText(Result.Email, AEmail) then Exit;
    end else
    begin
      if (Result.Email = AEmail) then Exit;
    end;
  end;
  Result := nil;
end;

function TclMailUserAccountList.AccountByUserName(const AUserName: string): TclMailUserAccountItem;
begin
  Result := inherited AccountByUserName(AUserName) as TclMailUserAccountItem;
end;

function TclMailUserAccountList.Add: TclMailUserAccountItem;
begin
  Result := TclMailUserAccountItem(inherited Add());
end;

function TclMailUserAccountList.GetItem(Index: Integer): TclMailUserAccountItem;
begin
  Result := TclMailUserAccountItem(inherited GetItem(Index));
end;

procedure TclMailUserAccountList.SetItem(Index: Integer; const Value: TclMailUserAccountItem);
begin
  inherited SetItem(Index, Value);
end;

end.
