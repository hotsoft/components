{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clEppUtils;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows;
{$ELSE}
  System.Classes, Winapi.Windows;
{$ENDIF}

const
  DefaultEppPort = 700;

function EppReadInt32(AStream: TStream): DWORD;
procedure EppWriteInt32(AStream: TStream; AValue: DWORD);

implementation

function EppReadInt32(AStream: TStream): DWORD;
var
  buf: array[0..3] of byte;
begin
  AStream.Read(buf, 4);
  Result := ((((buf[3] and $ff) or (buf[2] shl 8)) or (buf[1] shl $10)) or (buf[0] shl $18));
end;

procedure EppWriteInt32(AStream: TStream; AValue: DWORD);
var
  buf: array[0..3] of byte;
begin
  buf[3] := Byte(AValue);
  buf[2] := Byte(AValue shr 8);
  buf[1] := Byte(AValue shr $10);
  buf[0] := Byte(AValue shr $18);
  AStream.Write(buf, 4);
end;

end.

