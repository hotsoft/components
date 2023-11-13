{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clRegex;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, {$IFDEF DELPHIXE} RegularExpressions {$ELSE} clPCRE, clWUtils{$ENDIF};
{$ELSE}
  System.Classes, {$IFDEF DELPHIXE} System.RegularExpressions {$ELSE} clPCRE{$ENDIF};
{$ENDIF}

type
  TclRegExOption = (rxoNone, rxoIgnoreCase, rxoMultiLine);
  TclRegExOptions = set of TclRegExOption;

  TclRegEx = class
  private
{$IFDEF DELPHIXE}
    class function GetOptions(AOpts: TclRegExOptions): TRegExOptions;
{$ELSE}
    class function GetOptions(AOpts: TclRegExOptions): Integer;
{$ENDIF}
  public
    class function IsMatch(const AText, ARegEx: string; AOpts: TclRegExOptions): Boolean;
    class function ExactMatch(const AText, ARegEx: string; AOpts: TclRegExOptions): Boolean;
    class function Escape(const Str: string): string;
  end;

implementation

{ TclRegEx }

{$IFDEF DELPHIXE}
class function TclRegEx.GetOptions(AOpts: TclRegExOptions): TRegExOptions;
begin
  Result := [];
  if (rxoIgnoreCase in AOpts) then
  begin
    Result := Result + [roIgnoreCase];
  end;
  if (rxoMultiLine in AOpts) then
  begin
    Result := Result + [roMultiLine];
  end;
end;
{$ELSE}
class function TclRegEx.GetOptions(AOpts: TclRegExOptions): Integer;
begin
  Result := 0;
  if (rxoIgnoreCase in AOpts) then
  begin
    Result := Result + PCRE_CASELESS;
  end;
  if (rxoMultiLine in AOpts) then
  begin
    Result := Result + PCRE_MULTILINE;
  end;
end;
{$ENDIF}

class function TclRegEx.ExactMatch(const AText, ARegEx: string; AOpts: TclRegExOptions): Boolean;
{$IFDEF DELPHIXE}
var
  match: TMatch;
begin
  match := TRegEx.Match(AText, ARegEx, GetOptions(AOpts));
  Result := match.Success and (match.Index = 1) and (match.Length = Length(AText));
end;
{$ELSE}
var
  RE: TPCRE;
begin
  RE := TPCRE.Create(False, GetOptions(AOpts));
  try
    Result := RE.Match(PclChar(GetTclString(ARegEx)), PclChar(GetTclString(AText)));
    Result := Result and (RE.MatchCount > 0) and (RE.MatchOffset[0] = 0) and (RE.MatchLength[0] = Length(AText))
  finally
    RE.Free();
  end;
end;
{$ENDIF}

class function TclRegEx.IsMatch(const AText, ARegEx: string; AOpts: TclRegExOptions): Boolean;
begin
{$IFDEF DELPHIXE}
  Result := TRegEx.IsMatch(AText, ARegEx, GetOptions(AOpts));
{$ELSE}
  Result := RE_Match(AText, ARegEx, GetOptions(AOpts));
{$ENDIF}
end;

class function TclRegEx.Escape(const Str: string): string;
begin
{$IFDEF DELPHIXE}
  Result := TRegEx.Escape(Str);
{$ELSE}
  Result := EscRegex(Str);
{$ENDIF}
end;

end.
