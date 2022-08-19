{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clIdnTranslator;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clUtils;

type
  EclIdnError = class(Exception);

  TclIdnTranslator = class
  private
    class function Adapt(ADelta, ANumPoints: Integer; IsFirst: Boolean): Integer;
    class function IsBasicChar(C: Char): Boolean;
    class function Digit2CodePoint(ADigit: Integer): Integer;
  public
    class function IsBasic(const AInput: string): Boolean;
    class function GetAsciiText(const AInput: string): string;
    class function GetAscii(const AInput: string): string;
  end;

resourcestring
  cIdnBadInput = 'Bad input value for the IDN translator';
  cIdnOverflow = 'Input value needs wider integers to translate';

implementation

const
  TMIN: Integer = 1;
  TMAX: Integer = 26;
  BASE: Integer = 36;
  INITIAL_N: Integer = 128;
  INITIAL_BIAS: Integer = 72;
  DAMP: Integer = 700;
  SKEW: Integer = 38;
  DELIMITER: Char = '-';
  ACE_PREFIX: string = 'xn--';

{ TclIdnTranslator }

class function TclIdnTranslator.Adapt(ADelta, ANumPoints: Integer; IsFirst: Boolean): Integer;
var
  i: Integer;
begin
  if (IsFirst) then
  begin
    ADelta := ADelta div DAMP;
  end else
  begin
    ADelta := ADelta div 2;
  end;

  ADelta := ADelta + (ADelta div ANumPoints);

  i := 0;
  while (ADelta > ((BASE - TMIN) * TMAX) div 2) do
  begin
    ADelta := ADelta div (BASE - TMIN);
    i := i + BASE;
  end;

  Result := i + ((BASE - TMIN + 1) * ADelta) div (ADelta + SKEW);
end;

class function TclIdnTranslator.Digit2CodePoint(ADigit: Integer): Integer;
begin
  if (ADigit < 26) then
  begin
    Result := ADigit + Ord('a');
  end else
  if (ADigit < 36) then
  begin
    Result := ADigit - 26 + Ord('0');
  end else
  begin
    raise EclIdnError.Create(cIdnBadInput);
  end;
end;

class function TclIdnTranslator.GetAsciiText(const AInput: string): string;
var
  n, b, delta, bias, m,
  i, h, j, q, k, t: Integer;
  c: Char;
begin
  n := INITIAL_N;
  delta := 0;
  bias := INITIAL_BIAS;
  Result := '';

  b := 0;
  for i := 1 to Length(AInput) do
  begin
    c := AInput[i];
    if IsBasicChar(c) then
    begin
      Result := Result + c;
      Inc(b);
    end;
  end;

  if (b < Length(AInput)) then
  begin
    Result := ACE_PREFIX + Result;
  end else
  begin
    Exit;
  end;

  if (b > 0) then
  begin
    Result := Result + DELIMITER;
  end;

  h := b;
  while (h < Length(AInput)) do
  begin
    m := MaxInt;
    for i := 1 to Length(AInput) do
    begin
      c := AInput[i];
      if (Ord(c) >= n) and (Ord(c) < m) then
      begin
        m := Ord(c);
      end;
    end;

    if (m - n) > ((MaxInt - delta) div (h + 1)) then
    begin
      raise EclIdnError.Create(cIdnOverflow);
    end;

    delta := delta + (m - n) * (h + 1);
    n := m;

    for j := 1 to Length(AInput) do
    begin
      c := AInput[j];
      if (Ord(c) < n) then
      begin
        Inc(delta);
        if (delta = 0) then
        begin
          raise EclIdnError.Create(cIdnOverflow);
        end;
      end;

      if (Ord(c) = n) then
      begin
        q := delta;
        k := BASE;

        while True do
        begin
          if (k <= bias) then
          begin
            t := TMIN;
          end else
          if (k >= bias + TMAX) then
          begin
            t := TMAX;
          end else
          begin
            t := k - bias;
          end;

          if (q < t) then
          begin
            Break;
          end;

          Result := Result + Chr(Digit2Codepoint(t + (q - t) mod (BASE - t)));

          q := (q - t) div (BASE - t);
          Inc(k, BASE);
        end;

        Result := Result + Chr(Digit2Codepoint(q));
        bias := Adapt(delta, h + 1, h = b);
        delta := 0;
        Inc(h);
      end;
    end;
    Inc(delta);
    Inc(n);
  end;
end;

class function TclIdnTranslator.GetAscii(const AInput: string): string;
const
  cSeparator: array[Boolean] of string = ('', '.');
var
  list: TStrings;
  i: Integer;
begin
  list := TStringList.Create();
  try
    SplitText(AInput, list, '.');

    Result := '';
    for i := 0 to list.Count - 1 do
    begin
      Result := Result + cSeparator[i > 0] + GetAsciiText(list[i]);
    end;
  finally
    list.Free();
  end;
end;

class function TclIdnTranslator.IsBasic(const AInput: string): Boolean;
var
  i: Integer;
begin
  Result := True;
  for i := 1 to Length(AInput) do
  begin
    if not IsBasicChar(AInput[i]) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

class function TclIdnTranslator.IsBasicChar(C: Char): Boolean;
begin
  Result := Ord(C) < $80;
end;

end.