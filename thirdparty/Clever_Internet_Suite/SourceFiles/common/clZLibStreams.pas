{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clZLibStreams;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows,
{$ELSE}
  System.Classes, Winapi.Windows,
{$ENDIF}
  clInflate, clDeflate, clChecksum, clZLibBase, clUtils, clWUtils;

type
  TclGZipInflateStream = class(TStream)
  private
    FInflater: TclInflater;
    FDestination: TStream;
    FFileCrc: TclCrc32;
    FFileSize: LongWord;
    FRawData: TStream;
    FIsContent: Boolean;
    FIsTrailer: Boolean;
    FTotalWritten: LongWord;
    FRawBytes: TclByteArray;
    FRawBytesSize: Integer;

    procedure InitStream;
    function WriteBuffer(const Buffer; Count: Integer; var Offset: Integer): Boolean;
    function WriteHeader(const Buffer; Count: Integer; var Offset: Integer): Boolean;
    function WriteData(const Buffer; Count: Integer; var Offset: Integer): Boolean;
    function WriteTrailer(const Buffer; Count, Offset: Integer): Boolean;
  public
    constructor Create(ADestination: TStream);
    destructor Destroy; override;

    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; overload; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
    function Write(const Buffer; Count: Longint): Longint; override;
  end;

  TclGZipDeflateStream = class(TStream)
  private
    FDeflater: TclDeflater;
    FFileCrc: TclCrc32;
    FFileSize: LongWord;
    FDestination: TStream;
    FTotalWritten: LongWord;

    procedure InitStream(ADestination: TStream; ALevel: TclCompressionLevel; AStrategy: TclCompressionStrategy; AFlags: Integer);
    procedure WriteHeader(AFlags: Integer);
    procedure WriteTrailer;
  public
    constructor Create(ADestination: TStream; ALevel: TclCompressionLevel;
      AStrategy: TclCompressionStrategy; AFlags: Integer); overload;
    constructor Create(ADestination: TStream); overload;
    destructor Destroy; override;

    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; overload; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
    function Write(const Buffer; Count: Longint): Longint; override;
  end;

implementation

{ TclGZipInflateStream }

constructor TclGZipInflateStream.Create(ADestination: TStream);
begin
  inherited Create();

  Assert(ADestination <> nil);
  FDestination := ADestination;
  FRawData := TMemoryStream.Create();

  FInflater := TclInflater.Create(True);
  FFileCrc := TclCrc32.Create();
  InitStream();
  FTotalWritten := 0;

  SetLength(FRawBytes, 10);
  FRawBytesSize := 0;
end;

destructor TclGZipInflateStream.Destroy;
begin
  FFileCrc.Free();
  FInflater.Free();
  FRawData.Free();

  inherited Destroy();
end;

procedure TclGZipInflateStream.InitStream;
begin
  FFileCrc.Reset();
  FFileSize := 0;
  FRawData.Size := 0;
  FRawData.Position := 0;
  FRawBytesSize := 0;
  FIsContent := False;
  FIsTrailer := False;
end;

function TclGZipInflateStream.Read(var Buffer; Count: Integer): Longint;
begin
  Result := 0;
end;

function TclGZipInflateStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  case Origin of
    soBeginning: Result := Offset;
    soCurrent: Result := Integer(FTotalWritten) + Offset;
    soEnd: Result := Integer(FTotalWritten) + Offset
  else
    Result := 0;
  end;
  if (Result <> Integer(FTotalWritten)) then
  begin
    raise EclZLibError.Create(ZLibInvalidStreamOperation, ZLibInvalidStreamOperationCode);
  end;
end;

function TclGZipInflateStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: Result := Offset;
    soFromCurrent: Result := Integer(FTotalWritten) + Offset;
    soFromEnd: Result := Integer(FTotalWritten) + Offset
  else
    Result := 0;
  end;
  if (Result <> Integer(FTotalWritten)) then
  begin
    raise EclZLibError.Create(ZLibInvalidStreamOperation, ZLibInvalidStreamOperationCode);
  end;
end;

function TclGZipInflateStream.Write(const Buffer; Count: Integer): Longint;
var
  offset: Integer;
begin
  Result := Count;
  FTotalWritten := FTotalWritten + LongWord(Result);

  offset := 0;
  if not FIsContent then
  begin
    if not WriteHeader(Buffer, Count, offset) then Exit;
    FIsContent := True;
  end;

  if (not FIsTrailer) then
  begin
    FIsTrailer := WriteData(Buffer, Count, offset);
  end;

  if FIsTrailer then
  begin
    if WriteTrailer(Buffer, Count, offset) then
    begin
      InitStream();
    end;
  end;
end;

function TclGZipInflateStream.WriteBuffer(const Buffer; Count: Integer; var Offset: Integer): Boolean;
var
  len: Integer;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  Result := False;

  if (Offset >= Count) then Exit;

  FInflater.SetInput(Buffer, Offset, Count - Offset);
  SetLength(buf, $4000);

  while(FInflater.RemainingInput > 0) and (not FInflater.IsNeedingInput) and (not FInflater.IsFinished) do
  begin
    len := FInflater.Inflate(buf, 0, Length(buf));
    if(len > 0) then
    begin
      FDestination.Write(buf[0], len);
      FFileCrc.Update(buf[0], len);
      Inc(FFileSize, len);
    end;
    if(FInflater.IsNeedingDictionary) then
    begin
      raise EclZLibError.Create(ZLibNeedDictionary, ZLibNeedDictionaryCode);
    end;
  end;

  Offset := Count - FInflater.RemainingInput;
  Result := FInflater.IsFinished;
end;

function TclGZipInflateStream.WriteData(const Buffer; Count: Integer; var Offset: Integer): Boolean;
var
  dataLen, ofs: Integer;
begin
  Result := False;

  if (Offset >= Count) then Exit;

  dataLen := (Count - Offset);
  if (dataLen = 1) then
  begin
    if (FRawBytesSize = 0) then
    begin
      FRawBytes[0] := Byte(PclChar(@Buffer)[Offset]);
      Inc(FRawBytesSize);
      Inc(Offset);
    end else
    begin
      FRawBytes[FRawBytesSize] := Byte(PclChar(@Buffer)[Offset]);
      Inc(FRawBytesSize);

      Offset := 0;
      Result := WriteBuffer(FRawBytes[0], FRawBytesSize, Offset);

      FRawBytesSize := 0;
    end;
  end else
  if (dataLen = 2) then
  begin
    if (FRawBytesSize = 0) then
    begin
      Result := WriteBuffer(Buffer, Count, Offset);
    end else
    begin
      FRawBytes[FRawBytesSize] := Byte(PclChar(@Buffer)[Offset]);
      Inc(FRawBytesSize);

      FRawBytes[FRawBytesSize] := Byte(PclChar(@Buffer)[Offset + 1]);
      Inc(FRawBytesSize);

      Offset := 0;
      Result := WriteBuffer(FRawBytes[0], FRawBytesSize, Offset);

      FRawBytesSize := 0;
    end;
  end else
  begin
    if (FRawBytesSize = 0) then
    begin
      Result := WriteBuffer(Buffer, Count, Offset);
    end else
    begin
      FRawBytes[FRawBytesSize] := Byte(PclChar(@Buffer)[Offset]);
      Inc(FRawBytesSize);

      ofs := Offset;
      Offset := 0;
      WriteBuffer(FRawBytes[0], FRawBytesSize, Offset);

      FRawBytesSize := 0;

      Offset := ofs;
      Inc(Offset);

      Result := WriteBuffer(Buffer, Count, Offset);
    end;
  end;
end;

function TclGZipInflateStream.WriteHeader(const Buffer; Count: Integer; var Offset: Integer): Boolean;
var
  flags: Byte;
  extra: Word;
  b: Byte;
begin
  Offset := 0;
  Result := False;
  
  FRawData.Seek(0, soEnd);
  FRawData.Write(Buffer, Count);

  FRawData.Position := 0;

  if FRawData.Size < 10 then
  begin
    Result := False;
    Exit;
  end;

  FRawData.Seek(3, soCurrent);
  FRawData.Read(flags, 1);
  FRawData.Seek(6, soCurrent);

  if flags and $4 = $4 then
  begin // FEXTRA
    if FRawData.Size - FRawData.Position < 2 then Exit;
    FRawData.Read(extra, 2);

    if FRawData.Size - FRawData.Position < extra then Exit;
    FRawData.Seek(extra, soCurrent);
  end;

  if flags and $8 = $8 then
  begin // FNAME
    repeat
      if FRawData.Read(b, 1) = 0 then Exit;
    until (b = 0);
  end;

  if flags and $10 = $10 then
  begin // FCOMMENT
    repeat
      if FRawData.Read(b, 1) = 0 then Exit;
    until (b = 0);
  end;

  if flags and $2 = $2 then
  begin // FHCRC
    if FRawData.Size - FRawData.Position < 2 then Exit;
    FRawData.Seek(2, soCurrent);
  end;

  Offset := FRawData.Position - FRawData.Size + Count;
  FRawData.Size := 0;
  FRawData.Position := 0;
  FRawBytesSize := 0;
  Result := True;
end;

function TclGZipInflateStream.WriteTrailer(const Buffer; Count, Offset: Integer): Boolean;
var
  crc, size: LongWord; 
begin
  Result := False;

  if (Offset >= Count) then Exit;
  
  FRawData.Seek(0, soEnd);
  FRawData.Write(Pointer(TclIntPtr(@Buffer) + Offset)^, Count - Offset);
  FRawData.Position := 0;

  Assert(SizeOf(crc) = 4);

  if (FRawData.Size >= SizeOf(crc) + SizeOf(size)) then
  begin
    FRawData.Read(crc, SizeOf(crc));
    FRawData.Read(size, SizeOf(size));
    if (crc <> FFileCrc.Value) then
    begin
      raise EclZLibError.Create(ZLibInvalidCrc, ZLibInvalidCrcCode);
    end;
    if (size <> FFileSize) then
    begin
      raise EclZLibError.Create(ZLibInvalidDataSize, ZLibInvalidDataSizeCode);
    end;
    Result := True;
  end;
end;

{ TclGZipDeflateStream }

constructor TclGZipDeflateStream.Create(ADestination: TStream;
  ALevel: TclCompressionLevel; AStrategy: TclCompressionStrategy; AFlags: Integer);
begin
  inherited Create();
  InitStream(ADestination, ALevel, AStrategy, AFlags);
end;

constructor TclGZipDeflateStream.Create(ADestination: TStream);
begin
  inherited Create();
  InitStream(ADestination, clDefault, csDefault, 0);
end;

destructor TclGZipDeflateStream.Destroy;
begin
  try
    WriteTrailer();
  finally
    FDeflater.Free();
    FFileCrc.Free();
    inherited Destroy();
  end;
end;

procedure TclGZipDeflateStream.InitStream(ADestination: TStream;
  ALevel: TclCompressionLevel; AStrategy: TclCompressionStrategy; AFlags: Integer);
begin
  Assert(ADestination <> nil);
  FDestination := ADestination;

  FFileCrc := TclCrc32.Create();
  FFileCrc.Reset();
  FFileSize := 0;
  FTotalWritten := 0;

  FDeflater := TclDeflater.Create(CompressionLevelInt[ALevel], True);
  FDeflater.SetStrategy(AStrategy);

  WriteHeader(AFlags);
end;

function TclGZipDeflateStream.Read(var Buffer; Count: Integer): Longint;
begin
  Result := 0;
end;

function TclGZipDeflateStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  case Origin of
    soBeginning: Result := Offset;
    soCurrent: Result := Integer(FTotalWritten) + Offset;
    soEnd: Result := Integer(FTotalWritten) + Offset
  else
    Result := 0;
  end;
  if (Result <> Integer(FTotalWritten)) then
  begin
    raise EclZLibError.Create(ZLibInvalidStreamOperation, ZLibInvalidStreamOperationCode);
  end;
end;

function TclGZipDeflateStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: Result := Offset;
    soFromCurrent: Result := Integer(FTotalWritten) + Offset;
    soFromEnd: Result := Integer(FTotalWritten) + Offset
  else
    Result := 0;
  end;
  if (Result <> Integer(FTotalWritten)) then
  begin
    raise EclZLibError.Create(ZLibInvalidStreamOperation, ZLibInvalidStreamOperationCode);
  end;
end;

function TclGZipDeflateStream.Write(const Buffer; Count: Integer): Longint;
var
  buf: TclByteArray;
  len: Integer;
begin
  Result := Count;
  FTotalWritten := Integer(FTotalWritten) + Count;

  FDeflater.SetInput(Buffer, 0, Count);
  SetLength(buf, $4000);

  while(not FDeflater.IsNeedingInput) do
  begin
    len := FDeflater.Deflate(buf, 0, Length(buf));
    if (len > 0) then
    begin
      FDestination.Write(buf[0], len);
    end else
    begin
      Break;
    end;
  end;

  if (not FDeflater.IsNeedingInput) then
  begin
    raise EclZLibError.Create(ZLibDeflateInputError, ZLibDeflateInputErrorCode);
  end;

  FFileCrc.Update(Buffer, Count);
  Inc(FFileSize, LongWord(Count));
end;

procedure TclGZipDeflateStream.WriteHeader(AFlags: Integer);
var
  gzheader: array[0..9] of Byte;
begin
  ZeroMemory(@gzheader, SizeOf(gzheader));
	gzheader[0] := $1F;
	gzheader[1] := $8B;
	gzheader[2] := DEFLATED;
  gzheader[3] := Byte(AFlags);
  FDestination.Write(gzheader, SizeOf(gzheader));
end;

procedure TclGZipDeflateStream.WriteTrailer;
var
  buf: TclByteArray;
  len: Integer;
  w: LongWord;
begin
  FDeflater.Finish();

  SetLength(buf, $4000);

  while (not FDeflater.IsFinished) do
  begin
    len := FDeflater.Deflate(buf, 0, Length(buf));
    if (len > 0) then
    begin
      FDestination.Write(buf[0], len);
    end else
    begin
      Break;
    end;
  end;

  if (not FDeflater.IsFinished) then
  begin
    raise EclZLibError.Create(ZLibDeflateInputError, ZLibDeflateInputErrorCode);
  end;

  w := FFileCrc.Value;
  FDestination.Write(w, SizeOf(w));

  w := FFileSize;
  FDestination.Write(FFileSize, SizeOf(w));
end;

end.
