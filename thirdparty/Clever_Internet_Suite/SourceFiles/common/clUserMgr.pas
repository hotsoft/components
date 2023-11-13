{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clUserMgr;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils;
{$ELSE}
  System.Classes, System.SysUtils;
{$ENDIF}

type
  TclUserAccountItem = class(TCollectionItem)
  private
    FPassword: string;
    FUserName: string;
    FDisplayName: string;
  public
    function Authenticate(const APassword: string): Boolean;
    procedure Assign(Source: TPersistent); override;
  published
    property UserName: string read FUserName write FUserName;
    property Password: string read FPassword write FPassword;
    property DisplayName: string read FDisplayName write FDisplayName;
  end;

  TclUserAccountList = class(TOwnedCollection)
  private
    FCaseInsensitive: Boolean;
  protected
    function GetItem(Index: Integer): TclUserAccountItem;
    procedure SetItem(Index: Integer; const Value: TclUserAccountItem);
  public
    procedure Assign(Source: TPersistent); override;
    function Add: TclUserAccountItem;
    function AccountByUserName(const AUserName: string): TclUserAccountItem;
    property Items[Index: Integer]: TclUserAccountItem read GetItem write SetItem; default;
    property CaseInsensitive: Boolean read FCaseInsensitive write FCaseInsensitive;
  end;

implementation

{ TclUserAccountList }

function TclUserAccountList.AccountByUserName(const AUserName: string): TclUserAccountItem;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if CaseInsensitive then
    begin
      if SameText(Result.UserName, AUserName) then Exit;
    end else
    begin
      if (Result.UserName = AUserName) then Exit;
    end;
  end;
  Result := nil;
end;

function TclUserAccountList.Add: TclUserAccountItem;
begin
  Result := TclUserAccountItem(inherited Add());
end;

procedure TclUserAccountList.Assign(Source: TPersistent);
begin
  inherited Assign(Source);
  if (Source is TclUserAccountList) then
  begin
    CaseInsensitive := (Source as TclUserAccountList).CaseInsensitive;
  end;
end;

function TclUserAccountList.GetItem(Index: Integer): TclUserAccountItem;
begin
  Result := TclUserAccountItem(inherited GetItem(Index));
end;

procedure TclUserAccountList.SetItem(Index: Integer; const Value: TclUserAccountItem);
begin
  inherited SetItem(Index, Value);
end;

{ TclUserAccountItem }

procedure TclUserAccountItem.Assign(Source: TPersistent);
var
  account: TclUserAccountItem;
begin
  if (Source is TclUserAccountItem) then
  begin
    account := (Source as TclUserAccountItem);
    FPassword := account.Password;
    FUserName := account.UserName;
    FDisplayName := account.DisplayName;
  end else
  begin
    inherited Assign(Source);
  end;
end;

function TclUserAccountItem.Authenticate(const APassword: string): Boolean;
begin
  if (Collection as TclUserAccountList).CaseInsensitive then
  begin
    Result := SameText(Password, APassword);
  end else
  begin
    Result := (Password = APassword);
  end;
end;

end.
