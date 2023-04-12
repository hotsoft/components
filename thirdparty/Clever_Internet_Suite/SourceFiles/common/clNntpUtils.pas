{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clNntpUtils;

interface

{$I clVer.inc}

const
  DefaultNntpPort = 119;

type
  TclNntpModeType = (mtDefault, mtReader, mtStream);

function GetNormMessageID(const AMessageID: string): string;
function BuildNntpQuery(ADate: TDateTime; AGMT: Boolean; const ADistributions: string): string;
procedure ParseNntpQuery(const AQuery: string; var ADate: TDateTime; var AGMT: Boolean; var ADistributions: string);

implementation

uses
{$IFNDEF DELPHIXE2}
  SysUtils,
{$ELSE}
  System.SysUtils,
{$ENDIF}
  clUtils;

function GetNormMessageID(const AMessageID: string): string;
begin
  Result := AMessageID;
  if (Result <> '') then
  begin
    Result := GetQuotedString(Result, '<', '>');
  end;
end;

function BuildNntpQuery(ADate: TDateTime; AGMT: Boolean; const ADistributions: string): string;
begin
  Result := FormatDateTime('yymmdd hhnnss', ADate);
  if AGMT then
  begin
    Result:= Result + ' GMT';
  end;
  if Length(ADistributions) > 0 then
  begin
    Result := Result + ' <' + ADistributions + '>';
  end;
end;

procedure ParseNntpQuery(const AQuery: string; var ADate: TDateTime; var AGMT: Boolean; var ADistributions: string);
var
  ind, y, m, d, h, n, s: Integer;
begin
  ADate := Now();
  AGMT := False;
  ADistributions := '';

  try
    if Length(AQuery) >= Length('yymmdd hhnnss') then
    begin
      y := StrToInt(system.Copy(AQuery, 1, 2));
      m := StrToInt(system.Copy(AQuery, 3, 2));
      d := StrToInt(system.Copy(AQuery, 5, 2));

      h := StrToInt(system.Copy(AQuery, 8, 2));
      n := StrToInt(system.Copy(AQuery, 10, 2));
      s := StrToInt(system.Copy(AQuery, 12, 2));

      y := GetCorrectY2k(y);
      ADate := EncodeDate(y, m, d) + EncodeTime(h, n, s, 0);
    end;

    AGMT := (system.Pos('GMT', UpperCase(AQuery)) > 0);

    ind := system.Pos('<', AQuery);
    if (ind > 0) then
    begin
      ADistributions := system.Copy(AQuery, ind + 1, Length(AQuery));
      ind := system.Pos('>', ADistributions);
      if (ind > 0) then
      begin
        SetLength(ADistributions, ind - 1);
      end;
    end;
  except
    on EConvertError do ;
  end;
end;

end.
