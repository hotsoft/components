{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSshPacket;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows,
{$ELSE}
  System.Classes, Winapi.Windows,
{$ENDIF}
  clUtils, clCryptRandom;

type
  TclPacket = class
  private
    FIndex: Integer;
    FS: Integer;

    procedure GetByte(var AFoo: TclByteArray; AStart, ALen: Integer); overload;
    function GetByte(ALen: Integer): Integer; overload;
  public
    Buffer: TclByteArray;

    constructor Create; overload;
    constructor Create(ASize: Integer); overload;
    constructor Create(const ABuffer: TclByteArray); overload;

    procedure PutByte(const AFoo: Byte); overload;
    procedure PutByte(const AFoo: TclByteArray); overload;
    procedure PutByte(const AFoo: TclByteArray; ABegin, ALength: Integer); overload;
    procedure PutString(const AFoo: TclByteArray); overload;
    procedure PutString(const AFoo: TclByteArray; ABegin, ALength: Integer); overload;
    procedure PutInt(V: Integer);
    procedure PutLong(V: Int64);
    procedure PutMPInt(const AFoo: TclByteArray);
    procedure Skip(N: Integer);

    function GetLong: Int64;
    function GetInt: Integer;
    function GetShort: Integer;
    function GetByte: Integer; overload;
    procedure GetByte(var AFoo: TclByteArray); overload;
    function GetMPInt: TclByteArray;
    function GetMPIntBits: TclByteArray;
    function GetString: TclByteArray; overload;
    function GetString(var AStart, ALen: TclIntArray): TclByteArray; overload;

    function GetLength: Integer;
    function GetOffSet: Integer;
    procedure SetOffSet(Value: Integer);
    function GetIndex: Integer;
    procedure SetIndex(Value: Integer);

    procedure Init;
    procedure Rewind;
    procedure Reset;

    procedure Padding(ARandom: TclRandom; BSize: Integer);
    function Shift(ALen, AMac: Integer): Integer;
    procedure Unshift(ACommand: Byte; ARecipient, S, ALen: Integer);
  end;

const
  cMaxBufferSize = 1024 * 10 * 2;

implementation

{ TclPacket }

constructor TclPacket.Create;
begin
  Create(cMaxBufferSize);
end;

constructor TclPacket.Create(ASize: Integer);
begin
  inherited Create();
  
  SetLength(Buffer, ASize);
  FIndex := 0;
  FS := 0;
end;

constructor TclPacket.Create(const ABuffer: TclByteArray);
begin
  inherited Create();

  Buffer := ABuffer;
  FIndex := 0;
  FS := 0;
end;

function TclPacket.GetByte(ALen: Integer): Integer;
begin
  Result := FS;
  Inc(FS, ALen);
end;

procedure TclPacket.GetByte(var AFoo: TclByteArray);
begin
  GetByte(AFoo, 0, Length(AFoo));
end;

function TclPacket.GetByte: Integer;
begin
  Result := Integer(Buffer[FS]);
  Inc(FS);
end;

procedure TclPacket.GetByte(var AFoo: TclByteArray; AStart, ALen: Integer);
begin
  if (ALen > 0) then
  begin
    System.Move(Buffer[FS], AFoo[AStart], ALen);
    Inc(FS, ALen);
  end;
end;

function TclPacket.GetIndex: Integer;
begin
  Result := FIndex;
end;

function TclPacket.GetInt: Integer;
begin
  Result := Integer(ByteArrayReadDWord(Buffer, FS));
end;

function TclPacket.GetLength: Integer;
begin
  Result := FIndex - FS;
end;

function TclPacket.GetLong: Int64;
begin
  Result := ByteArrayReadInt64(Buffer, FS);
end;

function TclPacket.GetMPInt: TclByteArray;
var
  i: Integer;
begin
  i := GetInt();
  SetLength(Result, i);
  GetByte(Result, 0, i);
end;

function TclPacket.GetMPIntBits: TclByteArray;
var
  bits, bytes: Integer;
  bar: TclByteArray;
begin
{$IFNDEF DELPHI2005}bar := nil;{$ENDIF}
  bits := GetInt();
  bytes := (bits + 7) div 8;

  SetLength(Result, bytes);
  GetByte(Result, 0, bytes);
  if((Result[0] and $80) <> 0) then
  begin
    SetLength(bar, Length(Result) + 1);
    bar[0] := 0; // ??
    System.Move(Result[0], bar[1], Length(Result));

    Result := bar;
  end;
end;

function TclPacket.GetOffSet: Integer;
begin
  Result := FS;
end;

function TclPacket.GetShort: Integer;
begin
  Result := Integer(ByteArrayReadWord(Buffer, FS));
end;

function TclPacket.GetString(var AStart, ALen: TclIntArray): TclByteArray;
var
  i: Integer;
begin
  i := GetInt();
  AStart[0] := GetByte(i);
  ALen[0] := i;
  Result := Buffer;
end;

procedure TclPacket.PutByte(const AFoo: Byte);
begin
  Buffer[FIndex] := AFoo;
  Inc(FIndex);
end;

procedure TclPacket.PutByte(const AFoo: TclByteArray);
begin
  PutByte(AFoo, 0, Length(AFoo));
end;

procedure TclPacket.Padding(ARandom: TclRandom; BSize: Integer);
var
  len, ind, pad: Integer;
begin
  len := FIndex;
  pad := (-len) and (BSize - 1);
  if (pad < BSize) then
  begin
    Inc(pad, BSize);
  end;

  len := DWORD(len + pad - 4);

  ind := 0;
  ByteArrayWriteDWord(len, Buffer, ind);

  Buffer[4] := Byte(pad);

  ARandom.Fill(Buffer, FIndex, pad);

  Skip(pad);
end;

procedure TclPacket.PutByte(const AFoo: TclByteArray; ABegin, ALength: Integer);
begin
  if (ALength > 0) then
  begin
    System.Move(AFoo[ABegin], Buffer[FIndex], ALength);
    Inc(FIndex, ALength);
  end;
end;

procedure TclPacket.PutInt(V: Integer);
begin
  ByteArrayWriteDWord(DWORD(V), Buffer, FIndex);
end;

procedure TclPacket.PutLong(V: Int64);
begin
  ByteArrayWriteInt64(V, Buffer, FIndex);
end;

procedure TclPacket.PutMPInt(const AFoo: TclByteArray);
var
  i: Integer;
begin
  i := Length(AFoo);
  if((AFoo[0] and $80) <> 0) then
  begin
    Inc(i);
    PutInt(i);
    PutByte(0);
  end else
  begin
    PutInt(i);
  end;
  PutByte(AFoo);
end;

procedure TclPacket.PutString(const AFoo: TclByteArray);
begin
  PutString(AFoo, 0, Length(AFoo));
end;

procedure TclPacket.PutString(const AFoo: TclByteArray; ABegin, ALength: Integer);
begin
  PutInt(ALength);
  PutByte(AFoo, ABegin, ALength);
end;

function TclPacket.GetString: TclByteArray;
var
  i: Integer;
begin
  i := GetInt();
  SetLength(Result, i);
  GetByte(Result, 0, i);
end;

procedure TclPacket.Reset;
begin
  FIndex := 5;
end;

procedure TclPacket.Init;
begin
  FIndex := 0;
  FS := 0;
end;

procedure TclPacket.Rewind;
begin
  FS := 0;
end;

procedure TclPacket.SetIndex(Value: Integer);
begin
  FIndex := Value;
end;

procedure TclPacket.SetOffSet(Value: Integer);
begin
  FS := Value;
end;

procedure TclPacket.Skip(N: Integer);
begin
  Inc(FIndex, N);
end;

function TclPacket.Shift(ALen, AMac: Integer): Integer;
var
  s, pad: Integer;
begin
  s := ALen + 5 + 9;
  pad := (-s) and 7;
  if (pad < 8) then
  begin
    Inc(pad, 8);
  end;
  Inc(s, pad);
  Inc(s, AMac);

  System.Move(Buffer[ALen + 5 + 9], Buffer[s], FIndex - 5 - 9 - ALen);

  FIndex := 10;
  PutInt(ALen);
  FIndex := ALen + 5 + 9;
  Result := s;
end;

procedure TclPacket.Unshift(ACommand: Byte; ARecipient, S, ALen: Integer);
begin
  System.Move(Buffer[S], Buffer[5 + 9], ALen);

  Buffer[5] := ACommand;
  FIndex := 6;
  PutInt(ARecipient);
  PutInt(ALen);
  FIndex := ALen + 5 + 9;
end;

end.
