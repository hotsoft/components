{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clZLibBuffer;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clUtils, clZLibBase, clWUtils;

type
  TclDeflateBuffer = class
  private
    FStart: Integer;
    FEnd: Integer;
    FBits: LongWord;
    FBitCount: Integer;
    FBuf: TclByteArray;

    procedure WriteBuf(b: Byte);
    function GetIsFlushed: Boolean;
  public
    constructor Create; overload;
    constructor Create(ABufSize: Integer); overload;

    procedure Reset();
		procedure WriteByte(AValue: Integer);
		procedure WriteShort(AValue: Integer);
		procedure WriteInt(AValue: Integer);
		procedure WriteBlock(const ABlock: TclByteArray; AOffset, ALen: Integer);
		procedure WriteBits(AValue, ACount: Integer);
		procedure WriteShortMSB(AValue: Integer);

		procedure AlignToByte;

		function Flush(var AOutput: TclByteArray; AOffset, ALen: Integer): Integer;

    property BitCount: Integer read FBitCount;
    property IsFlushed: Boolean read GetIsFlushed;
  end;

  TclInflateBuffer = class
  private
    FWindow: PclChar;
    FWindow_start: Integer;
    FWindow_end: Integer;
    FBuffer: LongWord;
    FBits_in_buffer: Integer;

    function GetAvailableBytes: Integer;
    function GetIsNeedingInput: Boolean;
  public
    constructor Create;

    function PeekBits(n: Integer): Integer;
    procedure DropBits(n: Integer);
    procedure SkipToByteBoundary;
    function CopyBytes(var AOutput: TclByteArray; AOffset, ALen: Integer): Integer;
    procedure SetInput(const ABuffer; AOffset, ALen: Integer);
    procedure Reset;

    property AvailableBits: Integer read FBits_in_buffer;
    property AvailableBytes: Integer read GetAvailableBytes;
    property IsNeedingInput: Boolean read GetIsNeedingInput;
  end;

implementation

{ TclDeflateBuffer }

constructor TclDeflateBuffer.Create;
begin
  Create(4096);
end;

procedure TclDeflateBuffer.AlignToByte;
begin
  if (FBitCount > 0) then
  begin
    WriteBuf(Byte(FBits));
    if (FBitCount > 8) then
    begin
      WriteBuf(Byte(FBits shr 8));
    end;
  end;
  FBits := 0;
  FBitCount := 0;
end;

constructor TclDeflateBuffer.Create(ABufSize: Integer);
begin
  inherited Create();
  SetLength(FBuf, ABufSize);
end;

function TclDeflateBuffer.Flush(var AOutput: TclByteArray; AOffset, ALen: Integer): Integer;
begin
  if (FBitCount >= 8) then
  begin
    WriteBuf(Byte(FBits));
    FBits := FBits shr 8;
    Dec(FBitCount, 8);
  end;
  if (ALen > FEnd - FStart) then
  begin
    ALen := FEnd - FStart;
    Move(FBuf[FStart], AOutput[AOffset], ALen);
    FStart := 0;
    FEnd := 0;
  end else
  begin
    Move(FBuf[FStart], AOutput[AOffset], ALen);
    Inc(FStart, ALen);
  end;
  Result := ALen;
end;

function TclDeflateBuffer.GetIsFlushed: Boolean;
begin
  Result := (FEnd = 0);
end;

procedure TclDeflateBuffer.Reset;
begin
  FStart := 0;
  FEnd := 0;
  FBitCount := 0;
end;

procedure TclDeflateBuffer.WriteBits(AValue, ACount: Integer);
begin
  FBits := FBits or LongWord(AValue shl FBitCount);
  Inc(FBitCount, ACount);
  if (FBitCount >= 16) then
  begin
    WriteBuf(Byte(FBits));
    WriteBuf(Byte(FBits shr 8));
    FBits := FBits shr 16;
    Dec(FBitCount, 16);
  end;
end;

procedure TclDeflateBuffer.WriteBlock(const ABlock: TclByteArray; AOffset, ALen: Integer);
begin
  Move(ABlock[AOffset], FBuf[FEnd], ALen);
  Inc(FEnd, ALen);
end;

procedure TclDeflateBuffer.WriteByte(AValue: Integer);
begin
  WriteBuf(Byte(AValue));
end;

procedure TclDeflateBuffer.WriteBuf(b: Byte);
begin
  FBuf[FEnd] := b;
  Inc(FEnd);
end;

procedure TclDeflateBuffer.WriteInt(AValue: Integer);
begin
  WriteBuf(Byte(AValue));
  WriteBuf(Byte(AValue shr 8));
  WriteBuf(Byte(AValue shr 16));
  WriteBuf(Byte(AValue shr 24));
end;

procedure TclDeflateBuffer.WriteShort(AValue: Integer);
begin
  WriteBuf(Byte(AValue));
  WriteBuf(Byte(AValue shr 8));
end;

procedure TclDeflateBuffer.WriteShortMSB(AValue: Integer);
begin
  WriteBuf(Byte(AValue shr 8));
  WriteBuf(Byte(AValue));
end;

{ TclInflateBuffer }

function TclInflateBuffer.CopyBytes(var AOutput: TclByteArray; AOffset, ALen: Integer): Integer;
var
  count, avail: Integer;
begin
  if (ALen < 0) then
  begin
    raise EclZLibError.Create(ZLibOutOfRange, ZLibOutOfRangeCode);
  end;
  if ((FBits_in_buffer and 7) <> 0) then
  begin
    raise EclZLibError.Create(ZLibInvalidBitBuffer, ZLibInvalidBitBufferCode);
  end;

  count := 0;
  while (FBits_in_buffer > 0) and (ALen > 0) do
  begin
    AOutput[AOffset] := Byte(FBuffer);
    Inc(AOffset);
    FBuffer := FBuffer shr 8;
    Dec(FBits_in_buffer, 8);
    Dec(ALen);
    Inc(count);
  end;

  if (ALen = 0) then
  begin
    Result := count;
    Exit;
  end;

  avail := FWindow_end - FWindow_start;
  if (ALen > avail) then
  begin
    ALen := avail;
  end;

  Move(FWindow[FWindow_start], AOutput[AOffset], ALen);
  Inc(FWindow_start, ALen);

  if (((FWindow_start - FWindow_end) and 1) <> 0) then
  begin
    FBuffer := LongWord(Byte(FWindow[FWindow_start]) and $ff);
    Inc(FWindow_start);
    FBits_in_buffer := 8;
  end;
  Result := count + ALen;
end;

constructor TclInflateBuffer.Create;
begin
  inherited Create();
  Reset();
end;

procedure TclInflateBuffer.DropBits(n: Integer);
begin
  FBuffer := FBuffer shr n;
  Dec(FBits_in_buffer, n);
end;

function TclInflateBuffer.GetAvailableBytes: Integer;
begin
  Result := FWindow_end - FWindow_start + (FBits_in_buffer shr 3);
end;

function TclInflateBuffer.GetIsNeedingInput: Boolean;
begin
  Result := (FWindow_start = FWindow_end);
end;

function TclInflateBuffer.PeekBits(n: Integer): Integer;
begin
  if (FBits_in_buffer < n) then
  begin
    if (FWindow_start = FWindow_end) then
    begin
      Result := -1;
      Exit;
    end;

    FBuffer := FBuffer or LongWord((Byte(FWindow[FWindow_start]) and $ff or (Byte(FWindow[FWindow_start + 1]) and $ff) shl 8) shl FBits_in_buffer);
    Inc(FWindow_start, 2);
    Inc(FBits_in_buffer, 16);
  end;
  
  Result := Integer(FBuffer and ((1 shl n) - 1));
end;

procedure TclInflateBuffer.Reset;
begin
  FWindow_start := 0;
  FWindow_end := 0;
  FBuffer := 0;
  FBits_in_buffer := 0;
end;

procedure TclInflateBuffer.SetInput(const ABuffer; AOffset, ALen: Integer);
var
  _end: Integer;
begin
  if (FWindow_start < FWindow_end) then
  begin
    raise EclZLibError.Create(ZLibInputNotProcessed, ZLibInputNotProcessedCode);
  end;

  _end := AOffset + ALen;

  if (0 > AOffset) or (AOffset > _end) then
  begin
    raise EclZLibError.Create(ZLibOutOfRange, ZLibOutOfRangeCode);
  end;

  FWindow := @ABuffer;
  
  if ((ALen and 1) <> 0) then
  begin
    FBuffer := FBuffer or LongWord((Byte(FWindow[AOffset]) and $ff) shl FBits_in_buffer);
    Inc(AOffset);
    Inc(FBits_in_buffer, 8);
  end;

  FWindow_start := AOffset;
  FWindow_end := _end;
end;

procedure TclInflateBuffer.SkipToByteBoundary;
begin
  FBuffer := FBuffer shr (FBits_in_buffer and 7);
  FBits_in_buffer := FBits_in_buffer and (not 7);
end;

end.
