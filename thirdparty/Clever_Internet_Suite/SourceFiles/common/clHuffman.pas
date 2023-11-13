{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clHuffman;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Math,
{$ELSE}
  System.Classes, System.SysUtils, System.Math,
{$ENDIF}
  clUtils, clZLibBase, clZLibBuffer;

type
  TclHuffmanTree = class;

	TclHuffman = class
  private
    FLiteralTree: TclHuffmanTree;
    FDistTree: TclHuffmanTree;
    FBlTree: TclHuffmanTree;

    FD_buf: TclShortArray;
    FL_buf: TclByteArray;
    FLast_lit: Integer;
    FExtra_bits: Integer;
    FPending: TclDeflateBuffer;

    function Lcode(ALen: Integer): Integer;
    function Dcode(ADistance: Integer): Integer;
  public
    constructor Create(APending: TclDeflateBuffer);
    destructor Destroy; override;

    class function BitReverse(AToReverse: Integer): SmallInt;
    
    procedure Reset;
    procedure SendAllTrees(ABlTreeCodes: Integer);
    procedure CompressBlock;
    procedure FlushStoredBlock(const AStored: TclByteArray; AStoredOffset, AStoredLength: Integer; ALastBlock: Boolean);
    procedure FlushBlock(const AStored: TclByteArray; AStoredOffset, AStoredLength: Integer; ALastBlock: Boolean);

    function IsFull: Boolean;
    function TallyLit(ALit: Integer): Boolean;
    function TallyDist(ADist, ALen: Integer): Boolean;
  end;

  TclHuffmanTree = class
  private
    FFreqs: TclShortArray;
    FLength: TclByteArray;
    FMinNumCodes: Integer;
    FNumCodes: Integer;

    FCodes: TclShortArray;
    FBl_counts: TclIntArray;
    FMaxLength: Integer;
    FDh: TclHuffman;

    procedure BuildLength(const AChilds: TclIntArray);
  public
    constructor Create(ADh: TclHuffman; AElems: Integer; AMinCodes: Integer; AMaxLength: Integer);

    procedure Reset;
    procedure WriteSymbol(ACode: Integer);
    procedure SetStaticCodes(const AStCodes: TclShortArray; const AStLength: TclByteArray);

    procedure BuildCodes;
    procedure BuildTree;

    function GetEncodedLength(): Integer;

    procedure CalcBLFreq(ABlTree: TclHuffmanTree);
    procedure WriteTree(ABlTree: TclHuffmanTree);
  end;

implementation

const
  LITERAL_NUM = 286;
  DIST_NUM = 30;
  BITLEN_NUM = 19;
  BUFSIZE = 1 shl (DEFAULT_MEM_LEVEL + 6);
  REP_3_6    = 16;
  REP_3_10   = 17;
  REP_11_138 = 18;
  EOF_SYMBOL = 256;
  BL_ORDER: array[0..18] of Integer = (16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15);
  bit4Reverse: array[0..15] of Byte = (0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15);

var
  StaticLCodes: TclShortArray;
  StaticLLength: TclByteArray;
  StaticDCodes: TclShortArray;
  StaticDLength: TclByteArray;

{ TclHuffman }

class function TclHuffman.BitReverse(AToReverse: Integer): SmallInt;
begin
  Result := SmallInt(bit4Reverse[AToReverse and $F] shl 12 or
    bit4Reverse[(AToReverse shr 4) and $F] shl 8 or
    bit4Reverse[(AToReverse shr 8) and $F] shl 4 or
    bit4Reverse[AToReverse shr 12]);
end;

procedure TclHuffman.CompressBlock;
var
  i, litlen, dist, lc, bits, dc: Integer;
begin
  for i := 0 to FLast_lit - 1 do
  begin
    litlen := FL_buf[i] and $ff;
    dist := FD_buf[i];
    if (dist <> 0) then
    begin
      Dec(dist);

      lc := Lcode(litlen);
      FLiteralTree.WriteSymbol(lc);

      bits := (lc - 261) div 4;
      if (bits > 0) and (bits <= 5) then
      begin
        FPending.WriteBits(litlen and ((1 shl bits) - 1), bits);
      end;

      dc := Dcode(dist);
      FDistTree.WriteSymbol(dc);

      bits := dc div 2 - 1;
      if (bits > 0) then
      begin
        FPending.WriteBits(dist and ((1 shl bits) - 1), bits);
      end;
    end else
    begin
      FLiteralTree.WriteSymbol(litlen);
    end;
  end;
  
  FLiteralTree.WriteSymbol(EOF_SYMBOL);
end;

constructor TclHuffman.Create(APending: TclDeflateBuffer);
begin
  inherited Create();

  FPending := APending;

  FLiteralTree := TclHuffmanTree.Create(Self, LITERAL_NUM, 257, 15);
  FDistTree := TclHuffmanTree.Create(Self, DIST_NUM, 1, 15);
  FBlTree := TclHuffmanTree.Create(Self, BITLEN_NUM, 4, 7);

  SetLength(FD_buf, BUFSIZE);
  SetLength(FL_buf, BUFSIZE);
end;

function TclHuffman.Dcode(ADistance: Integer): Integer;
begin
	Result := 0;
  while (ADistance >= 4) do
  begin
    Inc(Result, 2);
    ADistance := ADistance shr 1;
  end;

	Result := Result + ADistance;
end;

destructor TclHuffman.Destroy;
begin
  FBlTree.Free();
  FDistTree.Free();
  FLiteralTree.Free();

  inherited Destroy();
end;

procedure TclHuffman.FlushBlock(const AStored: TclByteArray; AStoredOffset,
  AStoredLength: Integer; ALastBlock: Boolean);
var
  i, blTreeCodes, opt_len, static_len, b: Integer;
begin
  FLiteralTree.FFreqs[EOF_SYMBOL] := FLiteralTree.FFreqs[EOF_SYMBOL] + 1;
  FLiteralTree.BuildTree();
  FDistTree.BuildTree();
  FLiteralTree.CalcBLFreq(FBlTree);
  FDistTree.CalcBLFreq(FBlTree);
  FBlTree.BuildTree();

  blTreeCodes := 4;
  i := 18;
  while (i > blTreeCodes) do
  begin
    if (FblTree.FLength[BL_ORDER[i]] > 0) then
    begin
      blTreeCodes := i + 1;
    end;
    Dec(i);
  end;

  opt_len := 14 + blTreeCodes * 3 + FBlTree.GetEncodedLength() +
    FLiteralTree.GetEncodedLength() + FDistTree.GetEncodedLength() +
    FExtra_bits;

  static_len := FExtra_bits;
  for i := 0 to LITERAL_NUM - 1 do
  begin
    static_len := static_len + FLiteralTree.FFreqs[i] * StaticLLength[i];
  end;

  for i := 0 to DIST_NUM - 1 do
  begin
    static_len := static_len + FDistTree.FFreqs[i] * staticDLength[i];
  end;

  if (opt_len >= static_len) then
  begin
    opt_len := static_len;
  end;

  if (AStoredOffset >= 0) and (AStoredLength + 4 < (opt_len shr 3)) then
  begin
    FlushStoredBlock(AStored, AStoredOffset, AStoredLength, ALastBlock);
  end else
  if (opt_len = static_len) then
  begin
    b := 0;
    if ALastBlock then
    begin
      Inc(b);
    end;

    FPending.WriteBits((STATIC_TREES shl 1) + b, 3);
    FLiteralTree.SetStaticCodes(staticLCodes, staticLLength);
    FDistTree.SetStaticCodes(staticDCodes, staticDLength);
    CompressBlock();
    Reset();
  end else
  begin
    b := 0;
    if ALastBlock then
    begin
      Inc(b);
    end;

    FPending.WriteBits((DYN_TREES shl 1) + b, 3);
    SendAllTrees(blTreeCodes);
    CompressBlock();
    Reset();
  end;
end;

procedure TclHuffman.FlushStoredBlock(const AStored: TclByteArray;
  AStoredOffset, AStoredLength: Integer; ALastBlock: Boolean);
var
  b: Integer;
begin
  b := 0;
  if ALastBlock then
  begin
    Inc(b);
  end;
  FPending.WriteBits((STORED_BLOCK shl 1) + b, 3);
  
  FPending.AlignToByte();
  FPending.WriteShort(AStoredLength);
  FPending.WriteShort(not AStoredLength);
  FPending.WriteBlock(AStored, AStoredOffset, AStoredLength);
  Reset();
end;

function TclHuffman.IsFull: Boolean;
begin
  Result := (FLast_lit >= BUFSIZE);
end;

function TclHuffman.Lcode(ALen: Integer): Integer;
var
  code: Integer;
begin
  if (ALen = 255) then
  begin
    Result := 285;
    Exit;
  end;

  code := 257;
  while (ALen >= 8) do
  begin
    Inc(code, 4);
    ALen := ALen shr 1;
  end;

  Result := code + ALen;
end;

procedure TclHuffman.Reset;
begin
  FLast_lit := 0;
  FExtra_bits := 0;
  FLiteralTree.Reset();
  FDistTree.Reset();
  FBlTree.Reset();
end;

procedure TclHuffman.SendAllTrees(ABlTreeCodes: Integer);
var
  rank: Integer;
begin
  FBlTree.BuildCodes();
  FLiteralTree.BuildCodes();
  FDistTree.BuildCodes();
  FPending.WriteBits(FLiteralTree.FNumCodes - 257, 5);
  FPending.WriteBits(FDistTree.FNumCodes - 1, 5);
  FPending.WriteBits(ABlTreeCodes - 4, 4);
  
  for rank := 0 to ABlTreeCodes - 1 do
  begin
    FPending.WriteBits(FBlTree.FLength[BL_ORDER[rank]], 3);
  end;

  FLiteralTree.WriteTree(FBlTree);
  FDistTree.WriteTree(FBlTree);
end;

function TclHuffman.TallyDist(ADist, ALen: Integer): Boolean;
var
  lc, dc: Integer;
begin
  FD_buf[FLast_lit] := SmallInt(ADist);
  FL_buf[FLast_lit] := Byte(ALen - 3);
  Inc(FLast_lit);
			
  lc := Lcode(ALen - 3);
  FLiteralTree.FFreqs[lc] := FLiteralTree.FFreqs[lc] + 1;
  if (lc >= 265) and (lc < 285) then
  begin
    FExtra_bits := FExtra_bits + (lc - 261) div 4;
  end;
			
  dc := Dcode(ADist - 1);
  FDistTree.FFreqs[dc] := FDistTree.FFreqs[dc] + 1;
  if (dc >= 4) then
  begin
    FExtra_bits := FExtra_bits + dc div 2 - 1;
  end;

  Result := IsFull();
end;

function TclHuffman.TallyLit(ALit: Integer): Boolean;
begin
  FD_buf[FLast_lit] := 0;
  FL_buf[FLast_lit] := Byte(ALit);
  Inc(FLast_lit);
  FLiteralTree.FFreqs[ALit] := FLiteralTree.FFreqs[ALit] + 1;
  Result := IsFull();
end;

procedure InitStaticMembers;
var
  i: Integer;
begin
  SetLength(StaticLCodes, LITERAL_NUM);
  SetLength(StaticLLength, LITERAL_NUM);
  SetLength(StaticDCodes, DIST_NUM);
  SetLength(StaticDLength, DIST_NUM);

  i := 0;
  while (i < 144) do
  begin
    StaticLCodes[i] := TclHuffman.BitReverse(($030 + i) shl 8);
    StaticLLength[i] := 8;
    Inc(i);
  end;

  while (i < 256) do
  begin
    StaticLCodes[i] := TclHuffman.BitReverse(($190 - 144 + i) shl 7);
    StaticLLength[i] := 9;
    Inc(i);
  end;

  while (i < 280) do
  begin
    StaticLCodes[i] := TclHuffman.BitReverse(($000 - 256 + i) shl 9);
    StaticLLength[i] := 7;
    Inc(i);
  end;

  while (i < LITERAL_NUM) do
  begin
    StaticLCodes[i] := TclHuffman.BitReverse(($0c0 - 280 + i)  shl 8);
    StaticLLength[i] := 8;
    Inc(i);
  end;

  for i := 0 to DIST_NUM - 1 do
  begin
    StaticDCodes[i] := TclHuffman.BitReverse(i shl 11);
    StaticDLength[i] := 5;
  end;
end;

{ TclHuffmanTree }

procedure TclHuffmanTree.BuildCodes;
var
  i, code, bits: Integer;
  nextCode: TclIntArray;
begin
  SetLength(nextCode, FMaxLength);
  code := 0;
  SetLength(FCodes, Length(FFreqs));

  for bits := 0 to FMaxLength - 1 do
  begin
    nextCode[bits] := code;
    code := code + FBl_counts[bits] shl (15 - bits);
  end;

  for i := 0 to FNumCodes - 1 do
  begin
    bits := FLength[i];
    if (bits > 0) then
    begin
      FCodes[i] := TclHuffman.BitReverse(nextCode[bits - 1]);
      nextCode[bits - 1] := nextCode[bits - 1] + (1 shl (16 - bits));
    end;
  end;
end;

procedure TclHuffmanTree.BuildLength(const AChilds: TclIntArray);
var
  i, n, numNodes, numLeafs, overflow,
  bitLength, incrBitLen, nodePtr, childPtr: Integer;
  lengths: TclIntArray;
begin
  SetLength(FLength, Length(FFreqs));

  numNodes := Length(AChilds) div 2;
  numLeafs := (numNodes + 1) div 2;
  overflow := 0;

  for i := 0 to FMaxLength - 1 do
  begin
    FBl_counts[i] := 0;
  end;

  SetLength(lengths, numNodes);
  lengths[numNodes - 1] := 0;

  for i := numNodes - 1 downto 0 do
  begin
    if (AChilds[2 * i + 1] <> -1) then
    begin
      bitLength := lengths[i] + 1;
      if (bitLength > FMaxLength) then
      begin
        bitLength := FMaxLength;
        Inc(overflow);
      end;
      lengths[AChilds[2 * i]] := bitLength;
      lengths[AChilds[2 * i + 1]] := bitLength;
    end else
    begin
      bitLength := lengths[i];
      FBl_counts[bitLength - 1] := FBl_counts[bitLength - 1] + 1;
      FLength[AChilds[2 * i]] := Byte(lengths[i]);
    end;
  end;

  if (overflow = 0) then Exit;

  incrBitLen := FMaxLength - 1;
  repeat
    Dec(incrBitLen);
    while (FBl_counts[incrBitLen] = 0) do
    begin
      Dec(incrBitLen);
    end;

    repeat
      FBl_counts[incrBitLen] := FBl_counts[incrBitLen] - 1;
      Inc(incrBitLen);
      FBl_counts[incrBitLen] := FBl_counts[incrBitLen] + 1;
      overflow := overflow - (1 shl (FMaxLength - 1 - incrBitLen));
    until (overflow <= 0) or (incrBitLen >= FMaxLength - 1);
  until (overflow <= 0);

  FBl_counts[FMaxLength - 1] := FBl_counts[FMaxLength - 1] + overflow;
  FBl_counts[FMaxLength - 2] := FBl_counts[FMaxLength - 2] - overflow;

  nodePtr := 2 * numLeafs;
  for i := FMaxLength downto 1 do
  begin
    n := FBl_counts[i - 1];
    while (n > 0) do
    begin
      childPtr := 2 * AChilds[nodePtr];
      Inc(nodePtr);
      if (AChilds[childPtr + 1] = -1) then
      begin
        FLength[AChilds[childPtr]] := Byte(i);
        Dec(n);
      end;
    end;
  end;
end;

procedure TclHuffmanTree.BuildTree;
var
  i, numSymbols, heapLen,
  maxCode, freq, pos_, ppos, node: Integer;
  heap: TclIntArray;

  numLeafs, numNodes: Integer;
  childs, values: TclIntArray;

  first, last, path: Integer;

  lastVal, second, mindepth: Integer;
begin
  numSymbols := Length(FFreqs);
  SetLength(heap, numSymbols);
  heapLen := 0;
  maxCode := 0;

  for i := 0 to numSymbols - 1 do
  begin
    freq := FFreqs[i];
    if (freq <> 0) then
    begin
      pos_ := heapLen;
      Inc(heapLen);

      ppos := (pos_ - 1) div 2;
      while (pos_ > 0) and (FFreqs[heap[ppos]] > freq) do
      begin
        heap[pos_] := heap[ppos];
        pos_ := ppos;
        ppos := (pos_ - 1) div 2;
      end;
      heap[pos_] := i;

      maxCode := i;
    end;
  end;

  while (heapLen < 2) do
  begin
    if (maxCode < 2) then
    begin
      Inc(maxCode);
      node := maxCode;
    end else
    begin
      node := 0;
    end;
    heap[heapLen] := node;
    Inc(heapLen);
  end;

  FNumCodes := Max(maxCode + 1, FMinNumCodes);

  numLeafs := heapLen;
  SetLength(childs, 4 * heapLen - 2);
  SetLength(values, 2 * heapLen - 1);
  numNodes := numLeafs;

  for i := 0 to heapLen - 1 do
  begin
    node := heap[i];
    childs[2 * i] := node;
    childs[2 * i + 1] := -1;
    values[i] := FFreqs[node] shl 8;
    heap[i] := i;
  end;

  repeat
    first := heap[0];
    Dec(heapLen);
    last := heap[heapLen];

    ppos := 0;
    path := 1;

    while (path < heapLen) do
    begin
      if (path + 1 < heapLen) and (values[heap[path]] > values[heap[path + 1]]) then
      begin
        Inc(path);
      end;

      heap[ppos] := heap[path];
      ppos := path;
      path := path * 2 + 1;
    end;

    lastVal := values[last];

    path := ppos;
    ppos := (path - 1) div 2;
    while (path > 0) and (values[heap[ppos]] > lastVal) do
    begin
      heap[path] := heap[ppos];
      path := ppos;
      ppos := (path - 1) div 2;
    end;
    heap[path] := last;

    second := heap[0];

    last := numNodes;
    Inc(numNodes);

    childs[2 * last] := first;
    childs[2 * last + 1] := second;
    mindepth := Min(values[first] and $ff, values[second] and $ff);
    lastVal := values[first] + values[second] - mindepth + 1;
    values[last] := lastVal;

    ppos := 0;
    path := 1;

    while (path < heapLen) do
    begin
      if (path + 1 < heapLen) and (values[heap[path]] > values[heap[path + 1]]) then
      begin
        Inc(path);
      end;

      heap[ppos] := heap[path];
      ppos := path;
      path := ppos * 2 + 1;
    end;

    path := ppos;
    ppos := (path - 1) div 2;
    while (path > 0) and (values[heap[ppos]] > lastVal) do
    begin
      heap[path] := heap[ppos];

      path := ppos;
      ppos := (path - 1) div 2;
    end;

    heap[path] := last;
  until (heapLen <= 1);

  if heap[0] <> (Length(childs) div 2 - 1) then
  begin
    raise EclZLibError.Create(ZLibInvariantViolated, ZLibInvariantViolatedCode);
  end;

  BuildLength(childs);
end;

procedure TclHuffmanTree.CalcBLFreq(ABlTree: TclHuffmanTree);
var
  i, max_count, min_count,
  count, curlen: Integer;

  nextlen: Integer;
begin
  curlen := -1;

  i := 0;
  while (i < FNumCodes) do
  begin
    count := 1;
    nextlen := FLength[i];
    if (nextlen = 0) then
    begin
      max_count := 138;
      min_count := 3;
    end else
    begin
      max_count := 6;
      min_count := 3;
      if (curlen <> nextlen) then
      begin
        ABlTree.FFreqs[nextlen] := ABlTree.FFreqs[nextlen] + 1;
        count := 0;
      end;
    end;

    curlen := nextlen;
    Inc(i);

    while (i < FNumCodes) and (curlen = FLength[i]) do
    begin
      Inc(i);
      Inc(count);
      if (count >= max_count) then
      begin
        Break;
      end;
    end;

    if (count < min_count) then
    begin
      ABlTree.FFreqs[curlen] := ABlTree.FFreqs[curlen] + count;
    end else
    if (curlen <> 0) then
    begin
      ABlTree.FFreqs[REP_3_6] := ABlTree.FFreqs[REP_3_6] + 1;
    end else
    if (count <= 10) then
    begin
      ABlTree.FFreqs[REP_3_10] := ABlTree.FFreqs[REP_3_10] + 1;
    end else
    begin
      ABlTree.FFreqs[REP_11_138] := ABlTree.FFreqs[REP_11_138] + 1;
    end;
  end;
end;

constructor TclHuffmanTree.Create(ADh: TclHuffman; AElems, AMinCodes, AMaxLength: Integer);
begin
  inherited Create();

  FDh := ADh;
  FMinNumCodes := AMinCodes;
  FMaxLength := AMaxLength;
  SetLength(FFreqs, AElems);
  SetLength(FBl_counts, AMaxLength);
end;

function TclHuffmanTree.GetEncodedLength: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Length(FFreqs) - 1 do
  begin
    Result := Result + FFreqs[i] * FLength[i];
  end;
end;

procedure TclHuffmanTree.Reset;
var
  i: Integer;
begin
  for i := 0 to Length(FFreqs) - 1 do
  begin
    FFreqs[i] := 0;
  end;

  FCodes := nil;
  FLength := nil;
end;

procedure TclHuffmanTree.SetStaticCodes(const AStCodes: TclShortArray; const AStLength: TclByteArray);
begin
  FCodes := AStCodes;
  FLength := AStLength;
end;

procedure TclHuffmanTree.WriteSymbol(ACode: Integer);
begin
  FDh.FPending.WriteBits(FCodes[ACode] and $ffff, FLength[ACode]);
end;

procedure TclHuffmanTree.WriteTree(ABlTree: TclHuffmanTree);
var
  i, max_count, min_count,
  count, curlen: Integer;

  nextlen: Integer;
begin
  curlen := -1;

  i := 0;
  while (i < FNumCodes) do
  begin
    count := 1;
    nextlen := FLength[i];
    if (nextlen = 0) then
    begin
      max_count := 138;
      min_count := 3;
    end else
    begin
      max_count := 6;
      min_count := 3;
      if (curlen <> nextlen) then
      begin
        ABlTree.WriteSymbol(nextlen);
        count := 0;
      end;
    end;

    curlen := nextlen;
    Inc(i);

    while (i < FNumCodes) and (curlen = FLength[i]) do
    begin
      Inc(i);
      Inc(count);
      if (count >= max_count) then
      begin
        Break;
      end;
    end;

    if (count < min_count) then
    begin
      while (count > 0) do
      begin
        Dec(count);
        ABlTree.WriteSymbol(curlen);
      end;
    end else
    if (curlen <> 0) then
    begin
      ABlTree.WriteSymbol(REP_3_6);
      FDh.FPending.WriteBits(count - 3, 2);
    end else
    if (count <= 10) then
    begin
      ABlTree.WriteSymbol(REP_3_10);
      FDh.FPending.WriteBits(count - 3, 3);
    end else
    begin
      ABlTree.WriteSymbol(REP_11_138);
      FDh.FPending.WriteBits(count - 11, 7);
    end;
  end;
end;

initialization
  InitStaticMembers();

finalization

end.
