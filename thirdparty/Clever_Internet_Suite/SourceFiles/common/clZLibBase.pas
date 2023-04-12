{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clZLibBase;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Math,
{$ELSE}
  System.Classes, System.SysUtils, System.Math,
{$ENDIF}
  clUtils, clWUtils;

type
  TclCompressionLevel = (clDefault, clNoCompression, clBestSpeed, clBestCompression);

  TclCompressionStrategy = (csDefault, csFiltered, csHuffman, csRLE, csFixed);

  EclZLibError = class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean = False);
    property ErrorCode: Integer read FErrorCode;
  end;

const
  STORED_BLOCK = 0;
  STATIC_TREES = 1;
  DYN_TREES    = 2;
  PRESET_DICT  = $20;
  DEFAULT_MEM_LEVEL = 8;
  MAX_MATCH = 258;
  MIN_MATCH = 3;
  MAX_WBITS = 15;
  WSIZE = 1 shl MAX_WBITS;
  WMASK = WSIZE - 1;
  HASH_BITS = DEFAULT_MEM_LEVEL + 7;
  HASH_SIZE = 1 shl HASH_BITS;
  HASH_MASK = HASH_SIZE - 1;
  HASH_SHIFT = (HASH_BITS + MIN_MATCH - 1) div MIN_MATCH;
  MIN_LOOKAHEAD = MAX_MATCH + MIN_MATCH + 1;
  MAX_DIST = WSIZE - MIN_LOOKAHEAD;
  PENDING_BUF_SIZE = 1 shl (DEFAULT_MEM_LEVEL + 8);
  DEFLATE_STORED = 0;
  DEFLATE_FAST   = 1;
  DEFLATE_SLOW   = 2;
  GOOD_LENGTH: array[0..9] of Integer = (0, 4,  4,  4,  4,  8,   8,   8,   32,   32);
  MAX_LAZY: array[0..9] of Integer = (0, 4,  5,  6,  4, 16,  16,  32,  128,  258);
  NICE_LENGTH: array[0..9] of Integer = (0, 8, 16, 32, 16, 32, 128, 128,  258,  258);
  MAX_CHAIN: array[0..9] of Integer = (0, 4,  8, 32, 16, 32, 128, 256, 1024, 4096);
  COMPR_FUNC: array[0..9] of Integer = (0, 1,  1,  1,  1,  2,   2,   2,    2,    2);

  CompressionLevelInt: array[TclCompressionLevel] of Integer = (-1, 0, 1, 9);

resourcestring
  ZLibInputNotProcessed = 'Old input was not completely processed';
  ZLibInvalidStreamOperation = 'Invalid Stream operation';
  ZLibInvalidCrc = 'Uncompressing error - invalid crc';
  ZLibInvalidDataSize = 'Uncompressing error - invalid data size';
  ZLibInvalidBitBuffer = 'Bit buffer is not byte aligned';
  ZLibOutOfRange = 'Argument out of range';
  ZLibInvariantViolated = 'Heap invariant violated';
  ZLibInvalidCompressFunc = 'Invalid compress function';
  ZLibInvalidState = 'Invalid state for this operation';
  ZLibUnknownError = 'Unknown error';
  ZLibTreeLengthError = 'Static tree length illegal';
  ZLibWindowFull = 'Window is full';
  ZLibInvalidOperation = 'Invalid operation';
  ZLibHeaderChecksumError = 'Header checksum illegal';
  ZLibCompressionMethodError = 'Compression Method unknown';
  ZLibRepLengthError = 'Illegal rep length code';
  ZLibRepDistError = 'Illegal rep dist code';
  ZLibInflaterModeError = 'Inflater unknown mode';
  ZLibAdlerChecksumError = 'Adler chksum doesn''t match';
  ZLibUnknownBlockType = 'Unknown block type ';
  ZLibBrockenBlock = 'Broken uncompressed block';
  ZLibNeedDictionary = 'Need a dictionary';
  ZLibDeflateInputError = 'Can not deflate all input';

const
  ZLibInputNotProcessedCode = -101;
  ZLibInvalidStreamOperationCode = -102;
  ZLibInvalidCrcCode = -103;
  ZLibInvalidDataSizeCode = -104;
  ZLibInvalidBitBufferCode = -105;
  ZLibOutOfRangeCode = -106;
  ZLibInvariantViolatedCode = -107;
  ZLibInvalidCompressFuncCode = -108;
  ZLibInvalidStateCode = -109;
  ZLibUnknownErrorCode = -110;
  ZLibTreeLengthErrorCode = -111;
  ZLibWindowFullCode = -112;
  ZLibInvalidOperationCode = -113;
  ZLibHeaderChecksumErrorCode = -114;
  ZLibCompressionMethodErrorCode = -115;
  ZLibRepLengthErrorCode = -116;
  ZLibRepDistErrorCode = -117;
  ZLibInflaterModeErrorCode = -118;
  ZLibAdlerChecksumErrorCode = -119;
  ZLibUnknownBlockTypeCode = -120;
  ZLibBrockenBlockCode = -121;
  ZLibNeedDictionaryCode = -122;
  ZLibDeflateInputErrorCode = -123;

var
  MAX_BLOCK_SIZE: Integer;

implementation

{ EclZLibError }

constructor EclZLibError.Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorMsg);
  FErrorCode := AErrorCode;
end;

initialization
  MAX_BLOCK_SIZE := Min(65535, PENDING_BUF_SIZE - 5);

finalization

end.
