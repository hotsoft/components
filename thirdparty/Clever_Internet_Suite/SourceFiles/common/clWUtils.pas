{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clWUtils;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Windows;
{$ELSE}
  Winapi.Windows;
{$ENDIF}

type
{$IFDEF DELPHI2009}
  PclChar = PAnsiChar;
  TclChar = AnsiChar;
  TclString = AnsiString;

function clChr(X: DWORD): AnsiChar;
{$ELSE}
  PclChar = PChar;
  TclChar = Char;
  TclString = string;

function clChr(X: DWORD): Char;
{$ENDIF}

type
  TCharSet = Set of TclChar;

function GetTclString(const AValue: string): TclString; overload;
function GetTclString(const AValue: PclChar): TclString; overload;
function GetString_(const AValue: PclChar): string; overload;
function GetString_(const AValue: TclString): string; overload;

function IsSurrogatePair(const Str: WideString; Index: Integer): Boolean; overload;
function IsSurrogatePair(HighSurrogate, LowSurrogate: WideChar): Boolean; overload;

{$IFNDEF DELPHI2009}
function CharInSet(ch: Char; cset: TCharSet): Boolean;
{$ENDIF}

implementation

{$IFDEF DELPHI2009}
function clChr(X: DWORD): AnsiChar;
begin
  Result := AnsiChar(Chr(Byte(X)));
end;
{$ELSE}
function clChr(X: DWORD): Char;
begin
  Result := Chr(Byte(X));
end;
{$ENDIF}

function GetTclString(const AValue: string): TclString;
begin
{$IFDEF DELPHI2009}
  Result := TclString(AValue);
{$ELSE}
  Result := AValue;
{$ENDIF}
end;

function GetTclString(const AValue: PclChar): TclString;
begin
  Result := TclString(AValue);
end;

function GetString_(const AValue: PclChar): string;
begin
{$IFDEF DELPHI2009}
  Result := string(TclString(AValue));
{$ELSE}
  Result := string(AValue);
{$ENDIF}
end;

function GetString_(const AValue: TclString): string;
begin
{$IFDEF DELPHI2009}
  Result := string(AValue);
{$ELSE}
  Result := AValue;
{$ENDIF}
end;

function IsSurrogatePair(const Str: WideString; Index: Integer): Boolean;
begin
  if (Str = '') then
  begin
    Result := False;
    Exit;
  end;

  if (Index < 1) then
  begin
    Index := 1;
  end;

  Result := (Index < Length(Str)) and IsSurrogatePair(Str[Index], Str[Index + 1]);
end;

function IsSurrogatePair(HighSurrogate, LowSurrogate: WideChar): Boolean;
var
  h, l: DWORD;
begin
  h := DWORD(HighSurrogate);
  l := DWORD(LowSurrogate);
  
  if ((h < $d800) or (h > $dbff)) then
  begin
    Result := False;
  end else
  begin
    Result := ((l >= $dc00) and (l <= $dfff));
  end;
end;

{$IFNDEF DELPHI2009}
function CharInSet(ch: Char; cset: TCharSet): Boolean;
begin
  Result := ch in cset;
end;
{$ENDIF}

end.

