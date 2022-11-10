{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clConfig;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes;
{$ELSE}
  System.Classes;
{$ENDIF}

type
  TclConfig = class;

  TclConfigObject = class
  public
    constructor Create; virtual;
  end;

  TclConfigObjectClass = class of TclConfigObject;

  TclConfig = class
  private
    FNames: TStrings;
    FTypes: TStrings;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;
    procedure SetConfig(const AName, AValue: string);
    procedure SetType(const AName: string; AType: TclConfigObjectClass);

    function GetConfig(const AName: string): string; virtual;
    function CreateInstance(const AName: string): TclConfigObject; virtual;
  end;

implementation

{ TclConfigObject }

constructor TclConfigObject.Create;
begin
  inherited Create();
end;

{ TclConfig }

procedure TclConfig.SetConfig(const AName, AValue: string);
begin
  FNames.Values[AName] := AValue;
end;

procedure TclConfig.SetType(const AName: string; AType: TclConfigObjectClass);
var
  ind: Integer;
begin
  ind := FTypes.IndexOf(AName);
  if (AType <> nil) then
  begin
    if (ind < 0) then
    begin
      ind := FTypes.Add(AName);
    end;
    FTypes.Objects[ind] := TObject(AType);
  end else
  begin
    if (ind >= 0) then
    begin
      FTypes.Delete(ind);
    end;
  end;
end;

procedure TclConfig.Clear;
begin
  FNames.Clear();
  FTypes.Clear();
end;

constructor TclConfig.Create;
begin
  inherited Create();

  FNames := TStringList.Create();
{$IFDEF DELPHI7}
  FNames.NameValueSeparator := '=';
{$ENDIF}
  FTypes := TStringList.Create();
end;

function TclConfig.CreateInstance(const AName: string): TclConfigObject;
var
  ind: Integer;
begin
  ind := FTypes.IndexOf(AName);
  if (ind > - 1) then
  begin
    Result := TclConfigObjectClass(FTypes.Objects[ind]).Create();
  end else
  begin
    Result := nil;
  end;
end;

destructor TclConfig.Destroy;
begin
  FTypes.Free();
  FNames.Free();
  
  inherited Destroy();
end;

function TclConfig.GetConfig(const AName: string): string;
begin
  Result := FNames.Values[AName];
end;

end.
