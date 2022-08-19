{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clDeflate;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Math,
{$ELSE}
  System.Classes, System.Math,
{$ENDIF}
  clZLibBase, clChecksum, clUtils, clZLibBuffer, clHuffman, clWUtils;

type
  TclDeflaterEngine = class
  private
    FIns_h: Integer;
    FHead: TclShortArray;
    FPrev: TclShortArray;
    FMatchStart: Integer;
    FMatchLen: Integer;
    FPrevAvailable: Boolean;
    FBlockStart: Integer;
    FStrstart: Integer;
    FLookahead: Integer;
    FWindow: TclByteArray;
    FStrategy: TclCompressionStrategy;
    FMax_chain: Integer;
    FMax_lazy: Integer;
    FNiceLength: Integer;
    FGoodLength: Integer;
    FComprFunc: Integer;
    FInputBuf: PclChar;
    FTotalIn: Integer;
    FInputOff: Integer;
    FInputEnd: Integer;
    FPending: TclDeflateBuffer;
    FHuffman: TclHuffman;
    FAdler: TclAdler32;

    procedure UpdateHash;
    function InsertString: Integer;
    procedure SlideWindow;
    function FindLongestMatch(ACurMatch: Integer): Boolean;
    function DeflateStored(AFlush, AFinish: Boolean): Boolean;
    function DeflateFast(AFlush, AFinish: Boolean): Boolean;
    function DeflateSlow(AFlush, AFinish: Boolean): Boolean;
    function GetAdler: Integer;
    function GetTotalIn: Integer;
  public
    constructor Create(APending: TclDeflateBuffer);
    destructor Destroy; override;

    procedure Reset;
    procedure ResetAdler;
    procedure SetLevel(ALevel: Integer);
    procedure FillWindow;
    procedure SetDictionary(const ABuffer; AOffset, ALength: Integer);
    function Deflate(AFlush, AFinish: Boolean): Boolean;
    procedure SetInput(const ABuffer; AOffset, ALength: Integer);
    function NeedsInput: Boolean;

    property Adler: Integer read GetAdler;
    property TotalIn: Integer read GetTotalIn;
    property Strategy: TclCompressionStrategy read FStrategy write FStrategy;
  end;

  TclDeflater = class
  private
    FLevel: Integer;
    FNoZlibHeaderOrFooter: Boolean;
    FState: Integer;
    FTotalOut: LongWord;
    FPending: TclDeflateBuffer;
    FEngine: TclDeflaterEngine;
    
    function GetAdler: Integer;
    function GetTotalIn: Integer;
    function GetIsFinished: Boolean;
    function GetIsNeedingInput: Boolean;
  public
    constructor Create; overload;
    constructor Create(ALevel: Integer); overload;
    constructor Create(ALevel: Integer; ANoZlibHeaderOrFooter: Boolean); overload;
    destructor Destroy; override;

    procedure Reset;
    procedure Flush;
    procedure Finish;
    procedure SetInput(const AInput; AOffset, ALength: Integer);
    procedure SetLevel(ALevel: Integer);
    function GetLevel: Integer;
    procedure SetStrategy(AStrategy: TclCompressionStrategy);
    procedure SetDictionary(const ADict; AOffset, ALength: Integer);

    function Deflate(var AOutput: TclByteArray): Integer; overload;
    function Deflate(var AOutput: TclByteArray; AOffset, ALength: Integer): Integer; overload;

    property Adler: Integer read GetAdler;
    property TotalIn: Integer read GetTotalIn;
    property TotalOut: LongWord read FTotalOut;
    property IsFinished: Boolean read GetIsFinished;
    property IsNeedingInput: Boolean read GetIsNeedingInput;
  end;

const
  BEST_COMPRESSION = 9;
  BEST_SPEED = 1;
  DEFAULT_COMPRESSION = -1;
  NO_COMPRESSION = 0;
  DEFLATED = 8;

implementation

const
  TOO_FAR = 4096;
  IS_SETDICT              = $01;
  IS_FLUSHING             = $04;
  IS_FINISHING            = $08;
  INIT_STATE              = $00;
  SETDICT_STATE           = $01;
  BUSY_STATE              = $10;
  FLUSHING_STATE          = $14;
  FINISHING_STATE         = $1c;
  FINISHED_STATE          = $1e;
  CLOSED_STATE            = $7f;


{ TclDeflaterEngine }

constructor TclDeflaterEngine.Create(APending: TclDeflateBuffer);
begin
  inherited Create();
  
  FPending := APending;
  FHuffman := TclHuffman.Create(APending);
  FAdler := TclAdler32.Create();
  SetLength(FWindow, 2 * WSIZE);
  SetLength(FHead, HASH_SIZE);
  SetLength(FPrev, WSIZE);
  FStrstart := 1;
  FBlockStart := 1;
end;

function TclDeflaterEngine.Deflate(AFlush, AFinish: Boolean): Boolean;
var
  canFlush: Boolean;
begin
  repeat
    FillWindow();
    canFlush := AFlush and (FInputOff = FInputEnd);

    case (FComprFunc) of
      DEFLATE_STORED: Result := DeflateStored(canFlush, AFinish);
      DEFLATE_FAST: Result := DeflateFast(canFlush, AFinish);
      DEFLATE_SLOW: Result := DeflateSlow(canFlush, AFinish);
    else
      raise EclZLibError.Create(ZLibInvalidCompressFunc, ZLibInvalidCompressFuncCode);
    end;
  until not (FPending.IsFlushed and Result);
end;

function TclDeflaterEngine.DeflateFast(AFlush, AFinish: Boolean): Boolean;
var
  hashHead: Integer;
  lastBlock: Boolean;
begin
  if (FLookahead < MIN_LOOKAHEAD) and (not AFlush) then
  begin
    Result := False;
    Exit;
  end;

  while (FLookahead >= MIN_LOOKAHEAD) or AFlush do
  begin
    if (FLookahead = 0) then
    begin
      FHuffman.FlushBlock(FWindow, FBlockStart, FStrstart - FBlockStart, AFinish);
      FBlockStart := FStrstart;
      Result := False;
      Exit;
    end;

    if (FStrstart > 2 * WSIZE - MIN_LOOKAHEAD) then
    begin
      SlideWindow();
    end;

    hashHead := InsertString();
    if (FLookahead >= MIN_MATCH) and
      (hashHead <> 0) and
      (FStrategy <> csHuffman) and
      (FStrstart - hashHead <= MAX_DIST) and
      FindLongestMatch(hashHead) then
    begin
      if (FHuffman.TallyDist(FStrstart - FMatchStart, FMatchLen)) then
      begin
        lastBlock := AFinish and (FLookahead = 0);
        FHuffman.FlushBlock(FWindow, FBlockStart, FStrstart - FBlockStart, lastBlock);
        FBlockStart := FStrstart;
      end;

      Dec(FLookahead, FMatchLen);
      if (FMatchLen <= FMax_lazy) and (FLookahead >= MIN_MATCH) then
      begin
        Dec(FMatchLen);
        while (FMatchLen > 0) do
        begin
          Inc(FStrstart);
          InsertString();
          Dec(FMatchLen);
        end;
        Inc(FStrstart);
      end else
      begin
        Inc(FStrstart, FMatchLen);
        if (FLookahead >= MIN_MATCH - 1) then
        begin
          UpdateHash();
        end;
      end;
      FMatchLen := MIN_MATCH - 1;
      Continue;
    end else
    begin
      FHuffman.TallyLit(FWindow[FStrstart] and $ff);
      Inc(FStrstart);
      Dec(FLookahead);
    end;

    if (FHuffman.IsFull()) then
    begin
      lastBlock := AFinish and (FLookahead = 0);
      FHuffman.FlushBlock(FWindow, FBlockStart, FStrstart - FBlockStart, lastBlock);
      FBlockStart := FStrstart;
      Result := not lastBlock;
      Exit;
    end;
  end;

  Result := True;
end;

function TclDeflaterEngine.DeflateSlow(AFlush, AFinish: Boolean): Boolean;
var
  prevMatch, prevLen, hashHead, len: Integer;
  lastBlock: Boolean;
begin
  if (FLookahead < MIN_LOOKAHEAD) and (not AFlush) then
  begin
    Result := False;
    Exit;
  end;

  while (FLookahead >= MIN_LOOKAHEAD) or AFlush do
  begin
    if (FLookahead = 0) then
    begin
      if (FPrevAvailable) then
      begin
        FHuffman.TallyLit(FWindow[FStrstart - 1] and $ff);
      end;
      FPrevAvailable := False;

      FHuffman.FlushBlock(FWindow, FBlockStart, FStrstart - FBlockStart, AFinish);
      FBlockStart := FStrstart;
      Result := False;
      Exit;
    end;

    if (FStrstart >= 2 * WSIZE - MIN_LOOKAHEAD) then
    begin
      SlideWindow();
    end;

    prevMatch := FMatchStart;
    prevLen := FMatchLen;
    if (FLookahead >= MIN_MATCH) then
    begin
      hashHead := InsertString();
      if (FStrategy <> csHuffman) and (hashHead <> 0) and (FStrstart - hashHead <= MAX_DIST) and FindLongestMatch(hashHead) then
      begin
        if (FMatchLen <= 5) and ((FStrategy = csFiltered) or ((FMatchLen = MIN_MATCH) and (FStrstart - FMatchStart > TOO_FAR))) then
        begin
          FMatchLen := MIN_MATCH - 1;
        end;
      end;
    end;

    if (prevLen >= MIN_MATCH) and (FMatchLen <= prevLen) then
    begin
      FHuffman.TallyDist(FStrstart - 1 - prevMatch, prevLen);
      Dec(prevLen, 2);
      repeat
        Inc(FStrstart);
        Dec(FLookahead);
        if (FLookahead >= MIN_MATCH) then
        begin
          InsertString();
        end;

        Dec(prevLen);
      until (prevLen <= 0);

      Inc(FStrstart);
      Dec(FLookahead);
      FPrevAvailable := False;
      FMatchLen := MIN_MATCH - 1;
    end else
    begin
      if (FPrevAvailable) then
      begin
        FHuffman.TallyLit(FWindow[FStrstart - 1] and $ff);
      end;
      FPrevAvailable := True;
      Inc(FStrstart);
      Dec(FLookahead);
    end;

    if (FHuffman.IsFull()) then
    begin
      len := FStrstart - FBlockStart;
      if (FPrevAvailable) then
      begin
        Dec(len);
      end;

      lastBlock := AFinish and (FLookahead = 0) and (not FPrevAvailable);
      FHuffman.FlushBlock(FWindow, FBlockStart, len, lastBlock);
      Inc(FBlockStart, len);
      Result := not lastBlock;
      Exit;
    end;
  end;

  Result := True;
end;

function TclDeflaterEngine.DeflateStored(AFlush, AFinish: Boolean): Boolean;
var
  storedLen: Integer;
  lastBlock: Boolean;
begin
  if (not AFlush) and (FLookahead = 0) then
  begin
    Result := False;
    Exit;
  end;

  Inc(FStrstart, FLookahead);
  FLookahead := 0;

  storedLen := FStrstart - FBlockStart;
			
  if (storedLen >= MAX_BLOCK_SIZE) or
    ((FBlockStart < WSIZE) and (storedLen >= MAX_DIST)) or
    AFlush then
  begin
    lastBlock := AFinish;
    if (storedLen > MAX_BLOCK_SIZE) then
    begin
      storedLen := MAX_BLOCK_SIZE;
      lastBlock := False;
    end;

    FHuffman.FlushStoredBlock(FWindow, FBlockStart, storedLen, lastBlock);
    Inc(FBlockStart, storedLen);
    Result := not lastBlock;
  end else
  begin
    Result := True;
  end;
end;

destructor TclDeflaterEngine.Destroy;
begin
  FAdler.Free();
  FHuffman.Free();

  inherited Destroy();
end;

procedure TclDeflaterEngine.FillWindow;
var
  more: Integer;
begin
  if (FStrstart >= WSIZE + MAX_DIST) then
  begin
    SlideWindow();
  end;

  while (FLookahead < MIN_LOOKAHEAD) and (FInputOff < FInputEnd) do
  begin
    more := 2 * WSIZE - FLookahead - FStrstart;

    if (more > FInputEnd - FInputOff) then
    begin
      more := FInputEnd - FInputOff;
    end;

    Move(FInputBuf[FInputOff], FWindow[FStrstart + FLookahead], more);
    FAdler.Update(FInputBuf[FInputOff], more);

    Inc(FInputOff, more);
    Inc(FTotalIn, more);
    Inc(FLookahead, more);
  end;

  if (FLookahead >= MIN_MATCH) then
  begin
    UpdateHash();
  end;
end;

function TclDeflaterEngine.FindLongestMatch(ACurMatch: Integer): Boolean;
var
  chainLength, niceLength,
  scan, match, best_end, best_len,
  limit, strend: Integer;
  prev: TclShortArray;
  scan_end1, scan_end: Byte;
begin
  chainLength := FMax_chain;
  niceLength := FNiceLength;
  prev := FPrev;
  scan := FStrstart;
  best_end := FStrstart + FMatchLen;
  best_len := Max(FMatchLen, MIN_MATCH - 1);

  limit := Max(FStrstart - MAX_DIST, 0);

  strend := FStrstart + MAX_MATCH - 1;
  scan_end1 := FWindow[best_end - 1];
  scan_end := FWindow[best_end];

  if (best_len >= FGoodLength) then
  begin
    chainLength := chainLength shr 2;
  end;

  if (niceLength > FLookahead) then
  begin
    niceLength := FLookahead;
  end;

  repeat
    if (FWindow[ACurMatch + best_len] <> scan_end) or
      (FWindow[ACurMatch + best_len - 1] <> scan_end1) or
      (FWindow[ACurMatch] <> FWindow[scan]) or
      (FWindow[ACurMatch + 1] <> FWindow[scan + 1]) then
    begin
      ACurMatch := (prev[ACurMatch and WMASK] and $ffff);
      Dec(chainLength);
      Continue;
    end;

    match := ACurMatch + 2;
    Inc(scan, 2);

    repeat
      Inc(scan); Inc(match);
      if (FWindow[scan] <> FWindow[match]) then Break;
      Inc(scan); Inc(match);
      if (FWindow[scan] <> FWindow[match]) then Break;
      Inc(scan); Inc(match);
      if (FWindow[scan] <> FWindow[match]) then Break;
      Inc(scan); Inc(match);
      if (FWindow[scan] <> FWindow[match]) then Break;
      Inc(scan); Inc(match);
      if (FWindow[scan] <> FWindow[match]) then Break;
      Inc(scan); Inc(match);
      if (FWindow[scan] <> FWindow[match]) then Break;
      Inc(scan); Inc(match);
      if (FWindow[scan] <> FWindow[match]) then Break;
      Inc(scan); Inc(match);
      if (FWindow[scan] <> FWindow[match]) then Break;
    until (scan >= strend);

    if (scan > best_end) then
    begin
      FMatchStart := ACurMatch;
      best_end := scan;
      best_len := scan - FStrstart;

      if (best_len >= niceLength) then
      begin
        Break;
      end;

      scan_end1 := FWindow[best_end - 1];
      scan_end := FWindow[best_end];
    end;

    scan := FStrstart;

    ACurMatch := (prev[ACurMatch and WMASK] and $ffff);
    Dec(chainLength);
  until (ACurMatch <= limit) or (chainLength = 0);

  FMatchLen := Min(best_len, FLookahead);
  Result := (FMatchLen >= MIN_MATCH);
end;

function TclDeflaterEngine.GetAdler: Integer;
begin
  Result := Integer(FAdler.Value);
end;

function TclDeflaterEngine.GetTotalIn: Integer;
begin
  Result := FTotalIn;
end;

function TclDeflaterEngine.InsertString: Integer;
var
  match: SmallInt;
  hash: Integer;
begin
  hash := ((FIns_h shl HASH_SHIFT) xor FWindow[FStrstart + (MIN_MATCH -1)]) and HASH_MASK;
  match := FHead[hash];
  FPrev[FStrstart and WMASK] := match;
  FHead[hash] := SmallInt(FStrstart);
  FIns_h := hash;
  Result := match and $ffff;
end;

function TclDeflaterEngine.NeedsInput: Boolean;
begin
  Result := (FInputEnd = FInputOff);
end;

procedure TclDeflaterEngine.Reset;
var
  i: Integer;
begin
  FHuffman.Reset();
  FAdler.Reset();
  FStrstart := 1;
  FBlockStart := 1;
  FLookahead := 0;
  FTotalIn := 0;
  FPrevAvailable := False;
  FMatchLen := MIN_MATCH - 1;

  for i := 0 to HASH_SIZE - 1 do
  begin
    FHead[i] := 0;
  end;

  for i := 0 to WSIZE - 1 do
  begin
    FPrev[i] := 0;
  end;
end;

procedure TclDeflaterEngine.ResetAdler;
begin
  FAdler.Reset();
end;

procedure TclDeflaterEngine.SetDictionary(const ABuffer; AOffset, ALength: Integer);
begin
  FAdler.Update(Pointer(TclIntPtr(@ABuffer) + AOffset)^, ALength);
  if (ALength < MIN_MATCH) then
  begin
    Exit;
  end;
  if (ALength > MAX_DIST) then
  begin
    Inc(AOffset, ALength - MAX_DIST);
    ALength := MAX_DIST;
  end;

  Move(Pointer(TclIntPtr(@ABuffer) + AOffset)^, FWindow[FStrstart], ALength);

  UpdateHash();
  Dec(ALength);

  repeat
    Dec(ALength);
    InsertString();
    Inc(FStrstart);
  until (ALength = 0);

  Inc(FStrstart, 2);
  FBlockStart := FStrstart;
end;

procedure TclDeflaterEngine.SetInput(const ABuffer; AOffset, ALength: Integer);
var
  _end: Integer;
begin
  if (FInputOff < FInputEnd) then
  begin
    raise EclZLibError.Create(ZLibInputNotProcessed, ZLibInputNotProcessedCode);
  end;

  _end := AOffset + ALength;

  if (0 > AOffset) or (AOffset > _end) then
  begin
    raise EclZLibError.Create(ZLibOutOfRange, ZLibOutOfRangeCode);
  end;

  FInputBuf := @ABuffer;
  FInputOff := AOffset;
  FInputEnd := _end;
end;

procedure TclDeflaterEngine.SetLevel(ALevel: Integer);
begin
  FGoodLength := GOOD_LENGTH[ALevel];
  FMax_lazy := MAX_LAZY[ALevel];
  FNiceLength := NICE_LENGTH[ALevel];
  FMax_chain := MAX_CHAIN[ALevel];

  if (COMPR_FUNC[ALevel] <> FComprFunc) then
  begin
    case (FComprFunc) of
      DEFLATE_STORED:
      begin
        if (FStrstart > FBlockStart) then
        begin
          FHuffman.FlushStoredBlock(FWindow, FBlockStart, FStrstart - FBlockStart, False);
          FBlockStart := FStrstart;
        end;
        UpdateHash();
      end;
      DEFLATE_FAST:
      begin
        if (FStrstart > FBlockStart) then
        begin
          FHuffman.FlushBlock(FWindow, FBlockStart, FStrstart - FBlockStart, False);
          FBlockStart := FStrstart;
        end;
      end;
      DEFLATE_SLOW:
      begin
        if (FPrevAvailable) then
        begin
          FHuffman.TallyLit(FWindow[FStrstart - 1] and $ff);
        end;
        if (FStrstart > FBlockStart) then
        begin
          FHuffman.FlushBlock(FWindow, FBlockStart, FStrstart - FBlockStart, False);
          FBlockStart := FStrstart;
        end;
        FPrevAvailable := False;
        FMatchLen := MIN_MATCH - 1;
      end;
    end;

    FComprFunc := COMPR_FUNC[ALevel];
  end;
end;

procedure TclDeflaterEngine.SlideWindow;
var
  i, m: Integer;
  s: SmallInt;
begin
  Move(FWindow[WSIZE], FWindow[0], WSIZE);

  Dec(FMatchStart, WSIZE);
  Dec(FStrstart, WSIZE);
  Dec(FBlockStart, WSIZE);

  for i := 0 to HASH_SIZE - 1 do
  begin
    m := FHead[i] and $ffff;

    s := 0;
    if (m >= WSIZE) then
    begin
      s := SmallInt(m - WSIZE);
    end;
    FHead[i] := s;
  end;

  for i := 0 to WSIZE - 1 do
  begin
    m := FPrev[i] and $ffff;

    s := 0;
    if (m >= WSIZE) then
    begin
      s := SmallInt(m - WSIZE);
    end;
    FPrev[i] := s;
  end;
end;

procedure TclDeflaterEngine.UpdateHash;
begin
  FIns_h := (FWindow[FStrstart] shl HASH_SHIFT) xor FWindow[FStrstart + 1];
end;

{ TclDeflater }

constructor TclDeflater.Create;
begin
  Create(DEFAULT_COMPRESSION, False);
end;

constructor TclDeflater.Create(ALevel: Integer);
begin
  Create(ALevel, False);
end;

constructor TclDeflater.Create(ALevel: Integer; ANoZlibHeaderOrFooter: Boolean);
begin
  inherited Create();
  
  FPending := TclDeflateBuffer.Create(PENDING_BUF_SIZE);
  FEngine := TclDeflaterEngine.Create(FPending);
  
  FNoZlibHeaderOrFooter := ANoZlibHeaderOrFooter;
  SetStrategy(csDefault);
  SetLevel(ALevel);
  Reset();
end;

function TclDeflater.Deflate(var AOutput: TclByteArray): Integer;
begin
  Result := Deflate(AOutput, 0, Length(AOutput));
end;

function TclDeflater.Deflate(var AOutput: TclByteArray; AOffset, ALength: Integer): Integer;
var
  origLength, header, level_flags,
  chksum, count, neededbits, adler: Integer;
begin
  origLength := ALength;

  if (FState = CLOSED_STATE) then
  begin
    raise EclZLibError.Create(ZLibInvalidState, ZLibInvalidStateCode);
  end;

  if (FState < BUSY_STATE) then
  begin
    header := (DEFLATED + ((MAX_WBITS - 8) shl 4)) shl 8;
    level_flags := (FLevel - 1) shr 1;
    if (level_flags < 0) or (level_flags > 3) then
    begin
      level_flags := 3;
    end;
    header := header or (level_flags shl 6);
    if ((FState and IS_SETDICT) <> 0) then
    begin
      header := header or PRESET_DICT;
    end;
    header := header + 31 - (header mod 31);

    FPending.WriteShortMSB(header);
    if ((FState and IS_SETDICT) <> 0) then
    begin
      chksum := FEngine.Adler;
      FEngine.ResetAdler();
      FPending.WriteShortMSB(chksum shr 16);
      FPending.WriteShortMSB(chksum and $ffff);
    end;

    FState := BUSY_STATE or (FState and (IS_FLUSHING or IS_FINISHING));
  end;

  repeat
    count := FPending.Flush(AOutput, AOffset, ALength);
    Inc(AOffset, count);
    Inc(FTotalOut, count);
    Dec(ALength, count);

    if (ALength = 0) or (FState = FINISHED_STATE) then
    begin
      Break;
    end;

    if (not FEngine.Deflate((FState and IS_FLUSHING) <> 0, (FState and IS_FINISHING) <> 0)) then
    begin
      if (FState = BUSY_STATE) then
      begin
        Break;
      end else
      if (FState = FLUSHING_STATE) then
      begin
        if (FLevel <> NO_COMPRESSION) then
        begin
          neededbits := 8 + ((-FPending.BitCount) and 7);
          while (neededbits > 0) do
          begin
            FPending.WriteBits(2, 10);
            Dec(neededbits, 10);
          end;
        end;
        FState := BUSY_STATE;
      end else
      if (FState = FINISHING_STATE) then
      begin
        FPending.AlignToByte();
        if (not FNoZlibHeaderOrFooter) then
        begin
          adler := FEngine.Adler;
          FPending.WriteShortMSB(adler shr 16);
          FPending.WriteShortMSB(adler and $ffff);
        end;
        FState := FINISHED_STATE;
      end;
    end;
  until False;

  Result := origLength - ALength;
end;

destructor TclDeflater.Destroy;
begin
  FEngine.Free();
  FPending.Free();

  inherited Destroy();
end;

procedure TclDeflater.Finish;
begin
  FState := FState or IS_FLUSHING or IS_FINISHING;
end;

procedure TclDeflater.Flush;
begin
  FState := FState or IS_FLUSHING;
end;

function TclDeflater.GetAdler: Integer;
begin
  Result := FEngine.Adler;
end;

function TclDeflater.GetIsFinished: Boolean;
begin
  Result := (FState = FINISHED_STATE) and FPending.IsFlushed;
end;

function TclDeflater.GetIsNeedingInput: Boolean;
begin
  Result := FEngine.NeedsInput();
end;

function TclDeflater.GetLevel: Integer;
begin
  Result := FLevel;
end;

function TclDeflater.GetTotalIn: Integer;
begin
  Result := FEngine.TotalIn;
end;

procedure TclDeflater.Reset;
begin
  FState := INIT_STATE;
  if FNoZlibHeaderOrFooter then
  begin
    FState := BUSY_STATE;
  end;
  
  FTotalOut := 0;
  FPending.Reset();
  FEngine.Reset();
end;

procedure TclDeflater.SetDictionary(const ADict; AOffset, ALength: Integer);
begin
  if (FState <> INIT_STATE) then
  begin
    raise EclZLibError.Create(ZLibInvalidState, ZLibInvalidStateCode);
  end;

  FState := SETDICT_STATE;
  FEngine.SetDictionary(ADict, AOffset, ALength);
end;

procedure TclDeflater.SetInput(const AInput; AOffset, ALength: Integer);
begin
  if ((FState and IS_FINISHING) <> 0) then
  begin
    raise EclZLibError.Create(ZLibInvalidState, ZLibInvalidStateCode);
  end;
  FEngine.SetInput(AInput, AOffset, ALength);
end;

procedure TclDeflater.SetLevel(ALevel: Integer);
begin
  if (ALevel = DEFAULT_COMPRESSION) then
  begin
    ALevel := 6;
  end else
  if (ALevel < NO_COMPRESSION) or (ALevel > BEST_COMPRESSION) then
  begin
    raise EclZLibError.Create(ZLibOutOfRange, ZLibOutOfRangeCode);
  end;
			
  if (FLevel <> ALevel) then
  begin
    FLevel := ALevel;
    FEngine.SetLevel(ALevel);
  end;
end;

procedure TclDeflater.SetStrategy(AStrategy: TclCompressionStrategy);
begin
  FEngine.Strategy := AStrategy;
end;

end.
