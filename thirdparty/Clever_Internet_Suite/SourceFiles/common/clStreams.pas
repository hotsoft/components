{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clStreams;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clWUtils;

type
  EclStreamError = class(Exception);

  TclMultiStream = class(TStream)
  private
    FPosition: Integer;
    FList: TList;
    function GetStream(Index: Integer): TStream;
    function GetTotalSize: Int64;
  protected
    procedure SetSize(NewSize: Longint); overload; override;
    procedure SetSize(const NewSize: Int64); overload; override;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddStream(AStream: TStream);
    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; overload; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
    function Write(const Buffer; Count: Longint): Longint; override;
  end;

  TclNullStream = class(TStream)
  protected
    procedure SetSize(NewSize: Longint); overload; override;
    procedure SetSize(const NewSize: Int64); overload; override;
  public
    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; overload; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
    function Write(const Buffer; Count: Longint): Longint; override;
  end;

  TclChunkedStream = class(TStream)
  private
    FChunkSizeStr: string;
    FIsReadChunk: Boolean;
    FChunkSize: Integer;
    FChunkWritten: Integer;
    FIsCompleted: Boolean;
    FDestination: TStream;
    FTotalWritten: Int64;
    
    function ReadChunkData(const Buffer; var Offset: Integer; Count: Integer): Boolean;
    function ReadChunkSize(const Buffer; var Offset: Integer; Count: Integer): Boolean;
    function GetChunkSizeStr(const Buffer: PclChar; Count: Integer): string;
  protected
    procedure SetSize(NewSize: Longint); overload; override;
    procedure SetSize(const NewSize: Int64); overload; override;
  public
    constructor Create(ADestination: TStream);
    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; overload; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    property IsCompleted: Boolean read FIsCompleted;
  end;

  TclFileMappingStream = class(TStream)
  private
    FFileName: string;
    FFileHandle: Integer;
    FMapHandle: Integer;
    FMode: Word;
    FSize: Int64;
    FPosition: Int64;
    FAllocGranularity: Integer;

    procedure MapMemory(Offset: Int64; ASize: Integer; var AChunkOffset: Integer; var AMemory: Pointer);
    procedure UnmapMemory(AMemory: Pointer);
    procedure CreateFileHandle(const AFileName: string);
    procedure CreateFileMap(AFileHandle: THandle);
    procedure CloseHandles;
  protected
    procedure SetSize(NewSize: Longint); overload; override;
    procedure SetSize(const NewSize: Int64); overload; override;
  public
    constructor Create(const AFileName: string; AMode: Word); overload;
    constructor Create(const AFileName: string; AMode: Word; ASize: Int64); overload;
    destructor Destroy; override;

    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; overload; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; override;
    function Write(const Buffer; Count: Longint): Longint; override;

    property FileName: string read FFileName;
    property FileHandle: Integer read FFileHandle;
    property MapHandle: Integer read FMapHandle;
    property Mode: Word read FMode;
  end;

resourcestring
  cStreamOperationError = 'Invalid Stream operation';

implementation

uses
  clUtils{$IFDEF LOGGER}, clLogger{$ENDIF};

var
  AllocGranularity: Integer = 0;

function GetAllocGranularity(): Integer;
var
  si: TSystemInfo;
begin
  if (AllocGranularity = 0) then
  begin
    GetSystemInfo(si);
    AllocGranularity := si.dwAllocationGranularity;
  end;
  Result := AllocGranularity;
end;

{ TclMultiStream }

procedure TclMultiStream.AddStream(AStream: TStream);
begin
  FList.Add(AStream);
end;

constructor TclMultiStream.Create;
begin
  inherited Create();
  FList := TList.Create();
  FPosition := 0;
end;

destructor TclMultiStream.Destroy;
var
  i: Integer;
begin
  for i := FList.Count - 1 downto 0 do
  begin
    GetStream(i).Free();
  end;
  FList.Free();
  inherited Destroy();
end;

function TclMultiStream.GetStream(Index: Integer): TStream;
begin
  Result := TStream(FList[Index]);
end;

function TclMultiStream.Read(var Buffer; Count: Integer): Longint;
var
  i: Integer;
  buf_pos: PclChar;
  len, bytesRead: Longint;
begin
  len := 0;
  Result := 0;
  buf_pos := PclChar(@Buffer);
  for i := 0 to FList.Count - 1 do
  begin
    if (FPosition < (len + GetStream(i).Size)) then
    begin
      GetStream(i).Position := FPosition - len;
      bytesRead := GetStream(i).Read(buf_pos^, Count);
      Inc(Result, bytesRead);
      buf_pos := buf_pos + bytesRead;
      Inc(FPosition, bytesRead);
      if (bytesRead < Count) then
      begin
        Dec(Count, bytesRead);
      end else
      begin
        break;
      end;
    end;
    Inc(len, GetStream(i).Size);
  end;
end;

function TclMultiStream.GetTotalSize: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FList.Count - 1 do
  begin
    Result := Result + GetStream(i).Size;
  end;
end;

function TclMultiStream.Seek(Offset: Integer; Origin: Word): Longint;
var
  len: Integer;
begin
  len := GetTotalSize();
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: FPosition := FPosition + Offset;
    soFromEnd: FPosition := len + Offset;
  end;
  if (FPosition > len) then
  begin
    FPosition := len;
  end else
  if (FPosition < 0) then
  begin
    FPosition := 0;
  end;
  Result := FPosition;
end;

function TclMultiStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
var
  len: Int64;
begin
  len := GetTotalSize();
  case Origin of
    soBeginning: FPosition := Offset;
    soCurrent: FPosition := FPosition + Offset;
    soEnd: FPosition := len + Offset;
  end;
  if (FPosition > len) then
  begin
    FPosition := len;
  end else
  if (FPosition < 0) then
  begin
    FPosition := 0;
  end;
  Result := FPosition;
end;

procedure TclMultiStream.SetSize(const NewSize: Int64);
begin
end;

procedure TclMultiStream.SetSize(NewSize: Integer);
begin
end;

function TclMultiStream.Write(const Buffer; Count: Integer): Longint;
begin
  Result := 0;
end;

{ TclNullStream }

function TclNullStream.Read(var Buffer; Count: Integer): Longint;
begin
  Result := 0;
end;

function TclNullStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  Result := 0;
end;

function TclNullStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  Result := 0;
end;

procedure TclNullStream.SetSize(const NewSize: Int64);
begin
end;

function TclNullStream.Write(const Buffer; Count: Integer): Longint;
begin
  Result := Count;
end;

procedure TclNullStream.SetSize(NewSize: Integer);
begin
end;

{ TclChunkedStream }

constructor TclChunkedStream.Create(ADestination: TStream);
begin
  inherited Create();
  Assert(ADestination <> nil);
  FDestination := ADestination;
  FTotalWritten := 0;
end;

function TclChunkedStream.Read(var Buffer; Count: Integer): Longint;
begin
  Result := 0;
end;

function TclChunkedStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: Result := Offset;
    soFromCurrent: Result := FTotalWritten + Offset;
    soFromEnd: Result := FTotalWritten + Offset
  else
    Result := 0;
  end;
  if (Result <> FTotalWritten) then
  begin
    raise EclStreamError.Create(cStreamOperationError);
  end;
end;

function TclChunkedStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  case Origin of
    soBeginning: Result := Offset;
    soCurrent: Result := FTotalWritten + Offset;
    soEnd: Result := FTotalWritten + Offset
  else
    Result := 0;
  end;
  if (Result <> FTotalWritten) then
  begin
    raise EclStreamError.Create(cStreamOperationError);
  end;
end;

procedure TclChunkedStream.SetSize(const NewSize: Int64);
begin
end;

procedure TclChunkedStream.SetSize(NewSize: Integer);
begin
end;

function TclChunkedStream.Write(const Buffer; Count: Integer): Longint;
var
  offset: Integer;
begin
  Result := Count;
  FTotalWritten := FTotalWritten + Result;
  offset := 0;
  repeat
    if not FIsReadChunk then
    begin
      FIsReadChunk := ReadChunkSize(Buffer, offset, Count);
    end;

    if FIsReadChunk then
    begin
      FIsReadChunk := not ReadChunkData(Buffer, offset, Count);
    end;
  until (offset >= Count) or IsCompleted;
end;

function TclChunkedStream.GetChunkSizeStr(const Buffer: PclChar; Count: Integer): string;
var
  i: Integer;
  c: TclChar;
begin
  Result := '';
  for i := 0 to Count - 1 do
  begin
    c := Buffer[i];
    if (c in ['0'..'9']) or (c in ['a'..'f']) or (c in ['A'..'F']) then
    begin
      Result := Result + Char(c);
    end else
    begin
      Break;
    end;
  end;
end;

function TclChunkedStream.ReadChunkSize(const Buffer; var Offset: Integer; Count: Integer): Boolean;
var
  start: Integer;
  cur_pos: PclChar;
begin
  start := Offset;
  Result := False;

  while (Offset < Count) do
  begin
    cur_pos := PclChar(@Buffer) + Offset;
    Inc(Offset);
    if (cur_pos[0] = #10) then
    begin
      FChunkSizeStr := FChunkSizeStr + GetChunkSizeStr(PclChar(@Buffer) + start, Offset - start - 1);
      if (FChunkSizeStr <> '') then
      begin
        FChunkSizeStr := '$' + FChunkSizeStr;
      end;
      FChunkSize := StrToIntDef(FChunkSizeStr, 0);
      FChunkSizeStr := '';
      FChunkWritten := 0;

      Result := True;
      Exit;
    end;
  end;
  FChunkSizeStr := FChunkSizeStr + GetChunkSizeStr(PclChar(@Buffer) + start, Offset - start);
end;

function TclChunkedStream.ReadChunkData(const Buffer; var Offset: Integer; Count: Integer): Boolean;
var
  cnt: Integer;
  cur_pos: PclChar;
begin
  Result := False;

  if (FChunkSize > 0) then
  begin
    cnt := Count - Offset;
    if (cnt > FChunkSize - FChunkWritten) then
    begin
      cnt := FChunkSize - FChunkWritten;
    end;

    FDestination.Write((PclChar(@Buffer) + Offset)^, cnt);
    Offset := Offset + cnt;
    FChunkWritten := FChunkWritten + cnt;
  end;
  if (FChunkWritten = FChunkSize) then
  begin
    while (Offset < Count) do
    begin
      cur_pos := PclChar(@Buffer) + Offset;
      Inc(Offset);
      if (cur_pos[0] = #10) then
      begin
        Result := True;
        if (FChunkSize = 0) then
        begin
          FIsCompleted := True;
        end;
        Break;
      end;
    end;
  end;
end;

{ TclFileMappingStream }

procedure TclFileMappingStream.CloseHandles;
begin
  if (FMapHandle >= 0) then
  begin
    CloseHandle(FMapHandle);
    FMapHandle := 0;
  end;
  if (FFileHandle >= 0) then
  begin
    FileClose(FFileHandle);
    FFileHandle := 0;
  end;
end;

procedure TclFileMappingStream.CreateFileHandle(const AFileName: string);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'CreateFileHandle');{$ENDIF}
  if Mode = fmCreate then
  begin
    FFileHandle := FileCreate(AFileName);
    if (FFileHandle < 0) then
    begin
      raise EclStreamError.Create('FileCreate error: ' + IntToStr(clGetLastError())); //TODO
    end;
  end else
  begin
    FFileHandle := FileOpen(AFileName, Mode);
    if (FFileHandle < 0) then
    begin
      raise EclStreamError.Create('FileOpen error: ' + IntToStr(clGetLastError())); //TODO
    end;
  end;
  FFileName := AFileName;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'CreateFileHandle'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'CreateFileHandle', E); raise; end; end;{$ENDIF}
end;

procedure TclFileMappingStream.CreateFileMap(AFileHandle: THandle);
const
  protectMode: array[Boolean] of DWORD = (PAGE_READWRITE, PAGE_READONLY);
var
  p, h, l: DWORD;
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'CreateFileMap');{$ENDIF}
  p := protectMode[((Mode and fmOpenRead) > 0)];
  h := FSize shr 32;
  l := DWORD(FSize);
  FMapHandle := CreateFileMapping(AFileHandle, nil, p, h, l, nil);
  if (FMapHandle = 0) then
  begin
    raise EclStreamError.Create('CreateFileMapping error: ' + IntToStr(clGetLastError())); //TODO
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'CreateFileMap'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'CreateFileMap', E); raise; end; end;{$ENDIF}
end;

constructor TclFileMappingStream.Create(const AFileName: string; AMode: Word);
begin
  {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'Create with assert');{$ENDIF}
  Assert(False, 'Not Implemented');
  Create(AFilename, AMode, 0);
end;

constructor TclFileMappingStream.Create(const AFileName: string; AMode: Word; ASize: Int64);
begin
  inherited Create();
  try
    FAllocGranularity := GetAllocGranularity();

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'Create; AFileName=%s, AMode=%d, ASize=%d, AllocGranularity=%d', nil, [AFileName, AMode, ASize, FAllocGranularity]);{$ENDIF}

    FMode := AMode;
    FSize := ASize;
    
    CreateFileHandle(AFileName);
    CreateFileMap(FileHandle);
  except
    CloseHandles();
    raise;
  end;
end;

destructor TclFileMappingStream.Destroy;
begin
  CloseHandles();
  inherited Destroy();
end;

procedure TclFileMappingStream.MapMemory(Offset: Int64; ASize: Integer; var AChunkOffset: Integer; var AMemory: Pointer);
const
  accessMode: array[Boolean] of DWORD = (FILE_MAP_ALL_ACCESS, FILE_MAP_READ);
var
  a, h, l: DWORD;
  chunkStart: Int64;
begin
  AChunkOffset := Integer(Offset mod FAllocGranularity);
  chunkStart := Offset - AChunkOffset;

  a := accessMode[((Mode and fmOpenRead) > 0)];
  h := chunkStart shr 32;
  l := DWORD(chunkStart);
  AMemory := MapViewOfFile(FMapHandle, a, h, l, DWORD(ASize + AChunkOffset));
  if (AMemory = nil) then
  begin
    raise EclStreamError.Create('MapViewOfFile error: ' + IntToStr(clGetLastError())); //TODO
  end;
end;

function TclFileMappingStream.Read(var Buffer; Count: Longint): Longint;
var
  p: Pointer;
  chunkOffset: Integer;
  res: Int64;
begin
  if (FPosition >= 0) and (Count >= 0) then
  begin
    res := FSize - FPosition;
    if (res > 0) then
    begin
      if (res > Count) then
      begin
        Result := Count;
      end else
      begin
        Result := Longint(res);
      end;

      chunkOffset := 0;
      p := nil;
      try
        MapMemory(FPosition, Result, chunkOffset, p);
        System.Move(Pointer(TclIntPtr(p) + chunkOffset)^, Buffer, Result);
        Inc(FPosition, Result);
      finally
        UnmapMemory(p);
      end;
      Exit;
    end;
  end;
  Result := 0;
end;

function TclFileMappingStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  case Origin of
    soBeginning: FPosition := Offset;
    soCurrent: Inc(FPosition, Offset);
    soEnd: FPosition := FSize + Offset;
  end;
  Result := FPosition;
end;

procedure TclFileMappingStream.SetSize(NewSize: Longint);
begin
  SetSize(Int64(NewSize));
end;

function TclFileMappingStream.Seek(Offset: Integer; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: Inc(FPosition, Offset);
    soFromEnd: FPosition := FSize + Offset;
  end;
  Result := FPosition;
end;

procedure TclFileMappingStream.SetSize(const NewSize: Int64);
var
  OldPosition: Int64;
begin
  if (FSize = NewSize) then Exit;
  
  Assert(False, 'Not Implemented');
  OldPosition := FPosition;
  //TODO SetCapacity(NewSize);
  FSize := NewSize;
  if OldPosition > NewSize then Seek(0, soFromEnd);
end;

procedure TclFileMappingStream.UnmapMemory(AMemory: Pointer);
begin
  if (AMemory <> nil) then
  begin
    UnmapViewOfFile(AMemory);
  end;
end;

function TclFileMappingStream.Write(const Buffer; Count: Longint): Longint;
var
  p: Pointer;
  chunkOffset: Integer;
  Pos: Int64;
begin
  if (FPosition >= 0) and (Count >= 0) then
  begin
    Pos := FPosition + Count;
    if (Pos > 0) then
    begin
      {TODO if Pos > FSize then
      begin
        if Pos > FCapacity then
          SetCapacity(Pos);
        FSize := Pos;
      end;}
      chunkOffset := 0;
      p := nil;
      try
        MapMemory(FPosition, Count, chunkOffset, p);

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'Write, Count=%d, FPosition=%d, chunkOffset=%d', nil, [Count, FPosition, chunkOffset]);{$ENDIF}
        System.Move(Buffer, Pointer(TclIntPtr(p) + chunkOffset)^, Count);
        FPosition := Pos;
        Result := Count;
      finally
        UnmapMemory(p);
      end;
      Exit;
    end;
  end;
  Result := 0;
end;

end.

