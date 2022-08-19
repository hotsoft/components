{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clInflate;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Math,
{$ELSE}
  System.Classes, System.SysUtils, System.Math,
{$ENDIF}
  clZLibBase, clChecksum, clUtils, clZLibBuffer, clHuffman;

type
  TclInflaterHuffmanTree = class
  private
    FTree: TclShortArray;

    procedure BuildTree(const ACodeLengths: TclByteArray);
  public
    constructor Create(const ACodeLengths: TclByteArray);

    function GetSymbol(AInput: TclInflateBuffer): Integer;
  end;

  TclInflaterHeader = class
  private
    FBlLens: TclByteArray;
    FLitdistLens: TclByteArray;
    FBlTree: TclInflaterHuffmanTree;
    FMode: Integer;
    FLnum: Integer;
    FDnum: Integer;
    FBlnum: Integer;
    FNum: Integer;
    FRepSymbol: Integer;
    FLastLen: Byte;
    FPtr: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    
    function Decode(AInput: TclInflateBuffer): Boolean;
    function BuildLitLenTree: TclInflaterHuffmanTree;
    function BuildDistTree: TclInflaterHuffmanTree;
  end;

  TclOutputWindow = class
  private
		FWindow: TclByteArray;
		FWindowEnd: Integer;
		FWindowFilled: Integer;

    procedure SlowRepeat(ARepStart, ALen: Integer);
  public
    constructor Create;

    procedure Write(AByte: Integer);
    procedure DoRepeat(ALen, ADist: Integer);
    function CopyStored(AInput: TclInflateBuffer; ALen: Integer): Integer;
    procedure CopyDict(const ADict; AOffset, ALen: Integer);
    function GetFreeSpace_: Integer;
    function GetAvailable: Integer;
    function CopyOutput(const AOutput: TclByteArray; AOffset, ALen: Integer): Integer;
    procedure Reset;
  end;

  TclInflater = class
  private
    FMode: Integer;
    FReadAdler: Integer;
    FNeededBits: Integer;
    FRepLength: Integer;
    FRepDist: Integer;
    FUncomprLen: Integer;
    FIsLastBlock: Boolean;
    FTotalOut: Integer;
    FTotalIn: Integer;
    FNoHeader: Boolean;
    FInput: TclInflateBuffer;
    FOutputWindow: TclOutputWindow;
    FAdler: TclAdler32;

    FDynHeader: TclInflaterHeader;
    FLitlenTree: TclInflaterHuffmanTree;
    FDistTree: TclInflaterHuffmanTree;
    FOwnLitlenTree: TclInflaterHuffmanTree;
    FOwnDistTree: TclInflaterHuffmanTree;

    function DecodeHeader: Boolean;
    function DecodeDict: Boolean;
    function DecodeHuffman: Boolean;
    function DecodeChksum: Boolean;
    function Decode: Boolean;
    function GetIsNeedingInput: Boolean;
    function GetIsNeedingDictionary: Boolean;
    function GetIsFinished: Boolean;
    function GetAdler: Integer;
    function GetTotalIn: Integer;
    function GetRemainingInput: Integer;
  public
    constructor Create; overload;
    constructor Create(ANoHeader: Boolean); overload;
    destructor Destroy; override;

    procedure Reset;
    procedure SetDictionary(const ABuffer; AOffset, ALen: Integer);

    procedure SetInput(const ABuffer; AOffset, ALen: Integer);

    function Inflate(const ABuffer: TclByteArray): Integer; overload;
    function Inflate(const ABuffer: TclByteArray; AOffset, ALen: Integer): Integer; overload;

		property IsNeedingInput: Boolean read GetIsNeedingInput;
    property IsNeedingDictionary: Boolean read GetIsNeedingDictionary;
    property IsFinished: Boolean read GetIsFinished;
    property Adler: Integer read GetAdler;
    property TotalOut: Integer read FTotalOut;
    property TotalIn: Integer read GetTotalIn;
    property RemainingInput: Integer read GetRemainingInput;
  end;

implementation

uses
  clDeflate;

const
  LNUM   = 0;
  DNUM   = 1;
  BLNUM  = 2;
  BLLENS = 3;
  LENS   = 4;
  REPS   = 5;
  RepMin: array[0..2] of Integer  = ( 3, 3, 11 );
  RepBits: array[0..2] of Integer  = ( 2, 3,  7 );
  BL_ORDER: array[0..18] of Integer  = ( 16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15 );
  MAX_BITLEN = 15;
  WINDOW_SIZE = 1 shl 15;
  WINDOW_MASK = WINDOW_SIZE - 1;

  CPLENS: array[0..28] of Integer = (
    3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31,
    35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258
  );
  CPLEXT: array[0..28] of Integer = (
    0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2,
    3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0
  );
  CPDIST: array[0..29] of Integer = (
    1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193,
    257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145,
    8193, 12289, 16385, 24577
  );
  CPDEXT: array[0..29] of Integer = (
    0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6,
    7, 7, 8, 8, 9, 9, 10, 10, 11, 11,
    12, 12, 13, 13
  );
  DECODE_HEADER           = 0;
  DECODE_DICT             = 1;
  DECODE_BLOCKS           = 2;
  DECODE_STORED_LEN1      = 3;
  DECODE_STORED_LEN2      = 4;
  DECODE_STORED           = 5;
  DECODE_DYN_HEADER       = 6;
  DECODE_HUFFMAN          = 7;
  DECODE_HUFFMAN_LENBITS  = 8;
  DECODE_HUFFMAN_DIST     = 9;
  DECODE_HUFFMAN_DISTBITS = 10;
  DECODE_CHKSUM           = 11;
  FINISHED                = 12;

var
  DefLitLenTree: TclInflaterHuffmanTree;
  DefDistTree: TclInflaterHuffmanTree;

{ TclInflaterHeader }

function TclInflaterHeader.BuildDistTree: TclInflaterHuffmanTree;
var
  distLens: TclByteArray;
begin
  SetLength(distLens, FDnum);
  Move(FLitdistLens[FLnum], distLens[0], FDnum);
  Result := TclInflaterHuffmanTree.Create(distLens);
end;

function TclInflaterHeader.BuildLitLenTree: TclInflaterHuffmanTree;
var
  litlenLens: TclByteArray;
begin
  SetLength(litlenLens, FLnum);
  Move(FLitdistLens[0], litlenLens[0], FLnum);
  Result := TclInflaterHuffmanTree.Create(litlenLens);
end;

constructor TclInflaterHeader.Create;
begin
  inherited Create();
  FBlTree := nil;
end;

function TclInflaterHeader.Decode(AInput: TclInflateBuffer): Boolean;
var
  len, symbol, bits, count: Integer;
begin
  Result := False;

  repeat
    if (LNUM = FMode) then
    begin
      FLnum := AInput.PeekBits(5);
      if (FLnum < 0) then
      begin
        Break;
      end;

      Inc(FLnum, 257);
      AInput.DropBits(5);
      FMode := DNUM;
    end;
    
    if (DNUM = FMode) then
    begin
      FDnum := AInput.PeekBits(5);
      if (FDnum < 0) then
      begin
        Break;
      end;
      Inc(FDnum);
      AInput.DropBits(5);
      FNum := FLnum + FDnum;
      SetLength(FLitdistLens, FNum);
      FMode := BLNUM;
    end;

    if (BLNUM = FMode) then
    begin
      FBlnum := AInput.PeekBits(4);
      if (FBlnum < 0) then
      begin
        Break;
      end;
      Inc(FBlnum, 4);
      AInput.DropBits(4);
      SetLength(FBlLens, 19);
      FPtr := 0;
      FMode := BLLENS;
    end;

    if (BLLENS = FMode) then
    begin
      while (FPtr < FBlnum) do
      begin
        len := AInput.PeekBits(3);
        if (len < 0) then
        begin
          Exit;
        end;
        AInput.DropBits(3);
        FBlLens[BL_ORDER[FPtr]] := Byte(len);
        Inc(FPtr);
      end;
      FBlTree.Free();
      FBlTree := TclInflaterHuffmanTree.Create(FBlLens);
      SetLength(FBlLens, 0);
      FPtr := 0;
      FMode := LENS;
    end;

    if (LENS = FMode) then
    begin
      symbol := FBlTree.GetSymbol(AInput);
      while ((symbol and not 15) = 0) do
      begin
        FLastLen := Byte(symbol);
        FLitdistLens[FPtr] := FLastLen;
        Inc(FPtr);

        if (FPtr = FNum) then
        begin
          Result := True;
          Exit;
        end;
        symbol := FBlTree.GetSymbol(AInput);
      end;

      if (symbol < 0) then
      begin
        Break;
      end;

      if (symbol >= 17) then
      begin
        FLastLen := 0;
      end else
      if (FPtr = 0) then
      begin
        raise EclZLibError.Create(ZLibUnknownError, ZLibUnknownErrorCode);
      end;
      FRepSymbol := symbol - 16;
      FMode := REPS;
    end;

    if (REPS = FMode) then
    begin
      bits := RepBits[FRepSymbol];
      count := AInput.PeekBits(bits);
      if (count < 0) then
      begin
        Break;
      end;
      AInput.DropBits(bits);
      count := count + RepMin[FRepSymbol];

      if (FPtr + count > FNum) then
      begin
        raise EclZLibError.Create(ZLibUnknownError, ZLibUnknownErrorCode);
      end;

      while (count > 0) do
      begin
        Dec(count);
        FLitdistLens[FPtr] := FLastLen;
        Inc(FPtr);
      end;

      if (FPtr = FNum) then
      begin
        Result := True;
        Break;
      end;
      FMode := LENS;
    end;

  until False;
end;

destructor TclInflaterHeader.Destroy;
begin
  FBlTree.Free();
  inherited Destroy();
end;

{ TclInflaterHuffmanTree }

procedure TclInflaterHuffmanTree.BuildTree(const ACodeLengths: TclByteArray);
var
  i, bits, code, treeSize, start,
  _end, treePtr, revcode, subTree, treeLen: Integer;
  blCount, nextCode: TclIntArray;
begin
  SetLength(blCount, MAX_BITLEN + 1);
  SetLength(nextCode, MAX_BITLEN + 1);

  for i := 0 to Length(ACodeLengths) - 1 do
  begin
    bits := ACodeLengths[i];
    if (bits > 0) then
    begin
      blCount[bits] := blCount[bits] + 1;
    end;
  end;

  code := 0;
  treeSize := 512;

  for bits := 1 to MAX_BITLEN do
  begin
    nextCode[bits] := code;
    code := code + blCount[bits] shl (16 - bits);
    if (bits >= 10) then
    begin
      start := nextCode[bits] and $1ff80;
      _end := code and $1ff80;
      treeSize := treeSize + (_end - start) shr (16 - bits);
    end;
  end;

  SetLength(FTree, treeSize);
  treePtr := 512;
  for bits := MAX_BITLEN downto 10 do
  begin
    _end := code and $1ff80;
    code := code - blCount[bits] shl (16 - bits);
    start := code and $1ff80;

    i := start;
    while (i < _end) do
    begin
      FTree[TclHuffman.BitReverse(i)] := SmallInt((- treePtr shl 4) or bits);
      treePtr := treePtr + (1 shl (bits - 9));
      i := i + (1 shl 7);
    end;
  end;

  for i := 0 to Length(ACodeLengths) - 1 do
  begin
    bits := ACodeLengths[i];
    if (bits = 0) then
    begin
      Continue;
    end;
    
    code := nextCode[bits];
    revcode := TclHuffman.BitReverse(code);

    if (bits <= 9) then
    begin
      repeat
        FTree[revcode] := SmallInt((i shl 4) or bits);
        revcode := revcode + (1 shl bits);
      until (revcode >= 512);
    end else
    begin
      subTree := FTree[revcode and 511];
      treeLen := 1 shl (subTree and 15);
      subTree := (subTree and MaxLongInt) shr 4 - (subTree and (not MaxLongInt)) shr 4;
      subTree := -subTree;

      repeat
        FTree[subTree or (revcode shr 9)] := SmallInt((i shl 4) or bits);
        revcode := revcode + (1 shl bits);
      until (revcode >= treeLen);
    end;
    nextCode[bits] := code + (1 shl (16 - bits));
  end;
end;

constructor TclInflaterHuffmanTree.Create(const ACodeLengths: TclByteArray);
begin
  inherited Create();
  
  BuildTree(ACodeLengths);
end;

function TclInflaterHuffmanTree.GetSymbol(AInput: TclInflateBuffer): Integer;
var
  lookahead, symbol, subtree, bitlen, bits: Integer;
begin
  lookahead := AInput.PeekBits(9);
  if (lookahead >= 0) then
  begin
    symbol := FTree[lookahead];
    if (symbol >= 0) then
    begin
      AInput.DropBits(symbol and 15);
      Result := symbol shr 4;
      Exit;
    end;

    subtree := (symbol and MaxLongInt) shr 4 - (symbol and (not MaxLongInt)) shr 4;
    subtree := -subtree;
    bitlen := symbol and 15;

    lookahead := AInput.PeekBits(bitlen);
    if (lookahead >= 0) then
    begin
      symbol := FTree[subtree or (lookahead shr 9)];
      AInput.DropBits(symbol and 15);
      Result := symbol shr 4;
    end else
    begin
      bits := AInput.AvailableBits;
      lookahead := AInput.PeekBits(bits);
      symbol := FTree[subtree or (lookahead shr 9)];
      if ((symbol and 15) <= bits) then
      begin
        AInput.DropBits(symbol and 15);
        Result := symbol shr 4;
      end else
      begin
        Result := -1;
      end;
    end;
  end else
  begin
    bits := AInput.AvailableBits;
    lookahead := AInput.PeekBits(bits);
    symbol := FTree[lookahead];
    if (symbol >= 0) and ((symbol and 15) <= bits) then
    begin
      AInput.DropBits(symbol and 15);
      Result := symbol shr 4;
    end else
    begin
      Result := -1;
    end;
  end;
end;

procedure InitStaticMembers;
var
  i: Integer;
  codeLengths: TclByteArray;
begin
  try
    SetLength(codeLengths, 288);
    i := 0;
    while (i < 144) do
    begin
      codeLengths[i] := 8;
      Inc(i);
    end;
    while (i < 256) do
    begin
      codeLengths[i] := 9;
      Inc(i);
    end;
    while (i < 280) do
    begin
      codeLengths[i] := 7;
      Inc(i);
    end;
    while (i < 288) do
    begin
      codeLengths[i] := 8;
      Inc(i);
    end;
    DefLitLenTree := TclInflaterHuffmanTree.Create(codeLengths);

    SetLength(codeLengths, 32);
    i := 0;
    while (i < 32) do
    begin
      codeLengths[i] := 5;
      Inc(i);
    end;
    DefDistTree := TclInflaterHuffmanTree.Create(codeLengths);
  except
    raise EclZLibError.Create(ZLibTreeLengthError, ZLibTreeLengthErrorCode);
  end;
end;

procedure FreeStaticMembers;
begin
  DefDistTree.Free();
  DefLitLenTree.Free();
end;

{ TclOutputWindow }

procedure TclOutputWindow.CopyDict(const ADict; AOffset, ALen: Integer);
begin
  if (FWindowFilled > 0) then
  begin
    raise EclZLibError.Create(ZLibInvalidOperation, ZLibInvalidOperationCode);
  end;

  if (ALen > WINDOW_SIZE) then
  begin
    AOffset := AOffset + ALen - WINDOW_SIZE;
    ALen := WINDOW_SIZE;
  end;
  Move(Pointer(TclIntPtr(@ADict) + AOffset)^, FWindow, ALen);
  FWindowEnd := ALen and WINDOW_MASK;
end;

function TclOutputWindow.CopyOutput(const AOutput: TclByteArray; AOffset, ALen: Integer): Integer;
var
  copy_end, copied, tailLen: Integer;
begin
  copy_end := FWindowEnd;
  if (ALen > FWindowFilled) then
  begin
    ALen := FWindowFilled;
  end else
  begin
    copy_end := (FWindowEnd - FWindowFilled + ALen) and WINDOW_MASK;
  end;

  copied := ALen;
  tailLen := ALen - copy_end;

  if (tailLen > 0) then
  begin
    if (tailLen > 0) then
    begin
      Move(FWindow[WINDOW_SIZE - tailLen], AOutput[AOffset], tailLen);
    end;
    Inc(AOffset, tailLen);
    ALen := copy_end;
  end;
  if (ALen > 0) then
  begin
    Move(FWindow[copy_end - ALen], AOutput[AOffset], ALen);
  end;
  Dec(FWindowFilled, copied);
  if (FWindowFilled < 0) then
  begin
    raise EclZLibError.Create(ZLibInvalidOperation, ZLibInvalidOperationCode);
  end;
  Result := copied;
end;

function TclOutputWindow.CopyStored(AInput: TclInflateBuffer; ALen: Integer): Integer;
var
  copied, tailLen: Integer;
begin
  ALen := Min(Min(ALen, WINDOW_SIZE - FWindowFilled), AInput.AvailableBytes);

  tailLen := WINDOW_SIZE - FWindowEnd;
  if (ALen > tailLen) then
  begin
    copied := AInput.CopyBytes(FWindow, FWindowEnd, tailLen);
    if (copied = tailLen) then
    begin
      copied := copied + AInput.CopyBytes(FWindow, 0, ALen - tailLen);
    end;
  end else
  begin
    copied := AInput.CopyBytes(FWindow, FWindowEnd, ALen);
  end;

  FWindowEnd := (FWindowEnd + copied) and WINDOW_MASK;
  Inc(FWindowFilled, copied);
  Result := copied;
end;

constructor TclOutputWindow.Create;
begin
  inherited Create();
  
  SetLength(FWindow, WINDOW_SIZE);
  FWindowEnd := 0;
  FWindowFilled := 0;
end;

procedure TclOutputWindow.DoRepeat(ALen, ADist: Integer);
var
  rep_start, border: Integer;
begin
  Inc(FWindowFilled, ALen);
  if (FWindowFilled > WINDOW_SIZE) then
  begin
    raise EclZLibError.Create(ZLibWindowFull, ZLibWindowFullCode);
  end;

  rep_start := (FWindowEnd - ADist) and WINDOW_MASK;
  border := WINDOW_SIZE - ALen;
  if (rep_start <= border) and (FWindowEnd < border) then
  begin
    if (ALen <= ADist) then
    begin
      Move(FWindow[rep_start], FWindow[FWindowEnd], ALen);
      Inc(FWindowEnd, ALen);
    end else
    begin
      while (ALen > 0) do
      begin
        Dec(ALen);
        FWindow[FWindowEnd] := FWindow[rep_start];
        Inc(FWindowEnd);
        Inc(rep_start);
      end;
    end;
  end else
  begin
    SlowRepeat(rep_start, ALen);
  end;
end;

function TclOutputWindow.GetAvailable: Integer;
begin
  Result := FWindowFilled;
end;

function TclOutputWindow.GetFreeSpace_: Integer;
begin
  Result := WINDOW_SIZE - FWindowFilled;
end;

procedure TclOutputWindow.Reset;
begin
  FWindowEnd := 0;
  FWindowFilled := 0;
end;

procedure TclOutputWindow.SlowRepeat(ARepStart, ALen: Integer);
begin
  while (ALen > 0) do
  begin
    Dec(ALen);
    FWindow[FWindowEnd] := FWindow[ARepStart];
    Inc(FWindowEnd);
    Inc(ARepStart);
    FWindowEnd := FWindowEnd and WINDOW_MASK;
    ARepStart := ARepStart and WINDOW_MASK;
  end;
end;

procedure TclOutputWindow.Write(AByte: Integer);
begin
  if (FWindowFilled = WINDOW_SIZE) then
  begin
    Inc(FWindowFilled);
    raise EclZLibError.Create(ZLibWindowFull, ZLibWindowFullCode);
  end;
  Inc(FWindowFilled);

  FWindow[FWindowEnd] := Byte(AByte);
  Inc(FWindowEnd);
  FWindowEnd := FWindowEnd and WINDOW_MASK;
end;

{ TclInflater }

constructor TclInflater.Create;
begin
  Create(False);
end;

constructor TclInflater.Create(ANoHeader: Boolean);
begin
  inherited Create();
  
  FNoHeader := ANoHeader;
  FAdler := TclAdler32.Create();
  FInput := TclInflateBuffer.Create();
  FOutputWindow := TclOutputWindow.Create();
  FDynHeader := nil;
  FOwnLitlenTree := nil;
  FOwnDistTree := nil;

  if (ANoHeader) then
  begin
    FMode := DECODE_BLOCKS;
  end else
  begin
    FMode := DECODE_HEADER;
  end;
end;

function TclInflater.Decode: Boolean;
var
  _type, nlen, more: Integer;
begin
  if (DECODE_HEADER = FMode) then
  begin
    Result := DecodeHeader();
    Exit;
  end;

  if (DECODE_DICT = FMode) then
  begin
    Result := DecodeDict();
    Exit;
  end;

  if (DECODE_CHKSUM = FMode) then
  begin
    Result := DecodeChksum();
    Exit;
  end;

  if (DECODE_BLOCKS = FMode) then
  begin
    if (FIsLastBlock) then
    begin
      if (FNoHeader) then
      begin
        FMode := FINISHED;
        Result := False;
        Exit;
      end else
      begin
        FInput.SkipToByteBoundary();
        FNeededBits := 32;
        FMode := DECODE_CHKSUM;
        Result := True;
        Exit;
      end;
    end;

    _type := FInput.PeekBits(3);
    if (_type < 0) then
    begin
      Result := False;
      Exit;
    end;
    FInput.DropBits(3);

    if ((_type and 1) <> 0) then
    begin
      FIsLastBlock := True;
    end;

    case (_type shr 1) of
      STORED_BLOCK:
      begin
        FInput.SkipToByteBoundary();
        FMode := DECODE_STORED_LEN1;
      end;
      STATIC_TREES:
      begin
        FLitlenTree := DefLitLenTree;
        FDistTree := DefDistTree;
        FMode := DECODE_HUFFMAN;
      end;
      DYN_TREES:
      begin
        FreeAndNil(FDynHeader);
        FDynHeader := TclInflaterHeader.Create();
        FMode := DECODE_DYN_HEADER;
      end else
      begin
        raise EclZLibError.Create(ZLibUnknownBlockType, ZLibUnknownBlockTypeCode);
      end;
    end;

    Result := True;
    Exit;
  end;

  if (DECODE_STORED_LEN1 = FMode) then
  begin
    FUncomprLen := FInput.PeekBits(16);
    if (FUncomprLen < 0) then
    begin
      Result := False;
      Exit;
    end;

    FInput.DropBits(16);
    FMode := DECODE_STORED_LEN2;
  end;

  if (DECODE_STORED_LEN2 = FMode) then
  begin
    nlen := FInput.PeekBits(16);
    if (nlen < 0) then
    begin
      Result := False;
      Exit;
    end;

    FInput.DropBits(16);
    if (nlen <> (FUncomprLen xor $ffff)) then
    begin
      raise EclZLibError.Create(ZLibBrockenBlock, ZLibBrockenBlockCode);
    end;
    FMode := DECODE_STORED;
  end;

  if (DECODE_STORED = FMode) then
  begin
    more := FOutputWindow.CopyStored(FInput, FUncomprLen);
    Dec(FUncomprLen, more);
    if (FUncomprLen = 0) then
    begin
      FMode := DECODE_BLOCKS;
      Result := True;
      Exit;
    end;
    Result := not FInput.IsNeedingInput;
    Exit;
  end;

  if (DECODE_DYN_HEADER = FMode) then
  begin
    if (not FDynHeader.Decode(FInput)) then
    begin
      Result := False;
      Exit;
    end;

    FreeAndNil(FOwnDistTree);
    FreeAndNil(FOwnLitlenTree);
    FOwnLitlenTree := FDynHeader.BuildLitLenTree();
    FOwnDistTree := FDynHeader.BuildDistTree();

    FLitlenTree := FOwnLitlenTree;
    FDistTree := FOwnDistTree;

    FMode := DECODE_HUFFMAN;
  end;

  if (FMode in [DECODE_HUFFMAN, DECODE_HUFFMAN_LENBITS,
    DECODE_HUFFMAN_DIST, DECODE_HUFFMAN_DISTBITS]) then
  begin
    Result := DecodeHuffman();
    Exit;
  end;

  if (FINISHED = FMode) then
  begin
    Result := False;
    Exit;
  end;

  raise EclZLibError.Create(ZLibInflaterModeError, ZLibInflaterModeErrorCode);
end;

function TclInflater.DecodeChksum: Boolean;
var
  chkByte: Integer;
begin
  while (FNeededBits > 0) do
  begin
    chkByte := FInput.PeekBits(8);
    if (chkByte < 0) then
    begin
      Result := False;
      Exit;
    end;

    FInput.DropBits(8);
    FReadAdler := (FReadAdler shl 8) or chkByte;
    Dec(FNeededBits, 8);
  end;

  if (Integer(FAdler.Value) <> FReadAdler) then
  begin
    raise EclZLibError.Create(ZLibAdlerChecksumError, ZLibAdlerChecksumErrorCode);
  end;
  FMode := FINISHED;
  Result := False;
end;

function TclInflater.DecodeDict: Boolean;
var
  dictByte: Integer;
begin
  while (FNeededBits > 0) do
  begin
    dictByte := FInput.PeekBits(8);
    if (dictByte < 0) then
    begin
      Result := False;
      Exit;
    end;
    FInput.DropBits(8);

    FReadAdler := (FReadAdler shl 8) or dictByte;
    Dec(FNeededBits, 8);
  end;
  Result := False;
end;

function TclInflater.DecodeHeader: Boolean;
var
  header: Integer;
begin
  header := FInput.PeekBits(16);
  if (header < 0) then
  begin
    Result := False;
    Exit;
  end;
  FInput.DropBits(16);

  header := ((header shl 8) or (header shr 8)) and $ffff;
  if ((header mod 31) <> 0) then
  begin
    raise EclZLibError.Create(ZLibHeaderChecksumError, ZLibHeaderChecksumErrorCode);
  end;

  if ((header and $0f00) <> (DEFLATED shl 8)) then
  begin
    raise EclZLibError.Create(ZLibCompressionMethodError, ZLibCompressionMethodErrorCode);
  end;

  if ((header and $0020) = 0) then
  begin
    FMode := DECODE_BLOCKS;
  end else
  begin
    FMode := DECODE_DICT;
    FNeededBits := 32;
  end;
  Result := True;
end;

function TclInflater.DecodeHuffman: Boolean;
var
  i, free_, symbol: Integer;
begin
  free_ := FOutputWindow.GetFreeSpace_();
  while (free_ >= 258) do
  begin
    if (DECODE_HUFFMAN = FMode) then
    begin
      symbol := FLitlenTree.GetSymbol(FInput);
      while ((symbol and not $ff) = 0) do
      begin
        FOutputWindow.Write(symbol);
        Dec(free_);
        if (free_ < 258) then
        begin
          Result := True;
          Exit;
        end;
        symbol := FLitlenTree.GetSymbol(FInput);
      end;

      if (symbol < 257) then
      begin
        if (symbol < 0) then
        begin
          Result := False;
          Exit;
        end else
        begin
          FDistTree := nil;
          FLitlenTree := nil;
          FMode := DECODE_BLOCKS;
          Result := True;
          Exit;
        end;
      end;

      try
        FRepLength := CPLENS[symbol - 257];
        FNeededBits := CPLEXT[symbol - 257];
      except
        raise EclZLibError.Create(ZLibRepLengthError, ZLibRepLengthErrorCode);
      end;
      
      FMode := DECODE_HUFFMAN_LENBITS;
    end;

    if (DECODE_HUFFMAN_LENBITS = FMode) then
    begin
      if (FNeededBits > 0) then
      begin
        i := FInput.PeekBits(FNeededBits);
        if (i < 0) then
        begin
          Result := False;
          Exit;
        end;
        FInput.DropBits(FNeededBits);
        Inc(FRepLength, i);
      end;
      FMode := DECODE_HUFFMAN_DIST;
    end;

    if (DECODE_HUFFMAN_DIST = FMode) then
    begin
      symbol := FDistTree.GetSymbol(FInput);
      if (symbol < 0) then
      begin
        Result := False;
        Exit;
      end;

      try
        FRepDist := CPDIST[symbol];
        FNeededBits := CPDEXT[symbol];
      except
        raise EclZLibError.Create(ZLibRepDistError, ZLibRepDistErrorCode);
      end;

      FMode := DECODE_HUFFMAN_DISTBITS;
    end;

    if (DECODE_HUFFMAN_DISTBITS = FMode) then
    begin
      if (FNeededBits > 0) then
      begin
        i := FInput.PeekBits(FNeededBits);
        if (i < 0) then
        begin
          Result := False;
          Exit;
        end;
        FInput.DropBits(FNeededBits);
        Inc(FRepDist, i);
      end;

      FOutputWindow.DoRepeat(FRepLength, FRepDist);
      Dec(free_, FRepLength);

      FMode := DECODE_HUFFMAN;
      Continue;
    end;

    raise EclZLibError.Create(ZLibInflaterModeError, ZLibInflaterModeErrorCode);
  end;
  
  Result := True;      
end;

destructor TclInflater.Destroy;
begin
  FOwnDistTree.Free();
  FOwnLitlenTree.Free();
  FDynHeader.Free();
  FOutputWindow.Free();
  FInput.Free();
  FAdler.Free();

  inherited Destroy();
end;

function TclInflater.GetAdler: Integer;
begin
  if (IsNeedingDictionary) then
  begin
    Result := FReadAdler;
  end else
  begin
    Result := Integer(FAdler.Value);
  end;
end;

function TclInflater.GetIsFinished: Boolean;
begin
  Result := (FMode = FINISHED) and (FOutputWindow.GetAvailable() = 0);
end;

function TclInflater.GetIsNeedingDictionary: Boolean;
begin
  Result := (FMode = DECODE_DICT) and (FNeededBits = 0);
end;

function TclInflater.GetIsNeedingInput: Boolean;
begin
  Result := FInput.IsNeedingInput;
end;

function TclInflater.GetRemainingInput: Integer;
begin
  Result := FInput.AvailableBytes;
end;

function TclInflater.GetTotalIn: Integer;
begin
  Result := FTotalIn - RemainingInput;
end;

function TclInflater.Inflate(const ABuffer: TclByteArray): Integer;
begin
  Result := Inflate(ABuffer, 0, Length(ABuffer));
end;

function TclInflater.Inflate(const ABuffer: TclByteArray; AOffset, ALen: Integer): Integer;
var
  count, more: Integer;
begin
  if (ALen < 0) then
  begin
    raise EclZLibError.Create(ZLibOutOfRange, ZLibOutOfRangeCode);
  end;

  if (ALen = 0) then
  begin
    if (not IsFinished) then
    begin
      Decode();
    end;
    Result := 0;
    Exit;
  end;

  count := 0;
  repeat
    if (FMode <> DECODE_CHKSUM) then
    begin
      more := FOutputWindow.CopyOutput(ABuffer, AOffset, ALen);
      FAdler.Update(ABuffer[AOffset], more);
      Inc(AOffset, more);
      Inc(count, more);
      Inc(FTotalOut, more);
      Dec(ALen, more);
      if (ALen = 0) then
      begin
        Result := count;
        Exit;
      end;
    end;
  until not (Decode() or ((FOutputWindow.GetAvailable() > 0) and (FMode <> DECODE_CHKSUM)));

  Result := count;
end;

procedure TclInflater.Reset;
begin
  if (FNoHeader) then
  begin
    FMode := DECODE_BLOCKS;
  end else
  begin
    FMode := DECODE_HEADER;
  end;

  FTotalOut := 0;
  FTotalIn := 0;
  FInput.Reset();
  FOutputWindow.Reset();

  FreeAndNil(FDynHeader);
  FreeAndNil(FOwnLitlenTree);
  FreeAndNil(FOwnDistTree);

  FLitlenTree := nil;
  FDistTree := nil;
  
  FIsLastBlock := False;
  FAdler.Reset();
end;

procedure TclInflater.SetDictionary(const ABuffer; AOffset, ALen: Integer);
begin
  if (not IsNeedingDictionary) then
  begin
    raise EclZLibError.Create(ZLibInvalidOperation, ZLibInvalidOperationCode);
  end;

  FAdler.Update(Pointer(TclIntPtr(@ABuffer) + AOffset)^, ALen);
  if (Integer(FAdler.Value) <> FReadAdler) then
  begin
    raise EclZLibError.Create(ZLibAdlerChecksumError, ZLibAdlerChecksumErrorCode);
  end;

  FAdler.Reset();
  FOutputWindow.CopyDict(ABuffer, AOffset, ALen);
  FMode := DECODE_BLOCKS;
end;

procedure TclInflater.SetInput(const ABuffer; AOffset, ALen: Integer);
begin
  FInput.SetInput(ABuffer, AOffset, ALen);
  Inc(FTotalIn, ALen);
end;

initialization
  InitStaticMembers();

finalization
  FreeStaticMembers();

end.
