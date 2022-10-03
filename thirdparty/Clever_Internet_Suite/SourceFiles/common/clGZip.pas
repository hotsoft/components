{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clGZip;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  SysUtils, Windows, Classes,
{$ELSE}
  System.SysUtils, Winapi.Windows, System.Classes,
{$ENDIF}
  clZLibStreams, clZLibBase, clWUtils, clUtils;

type
  TclGZip = class(TComponent)
  private
    FBatchSize: Integer;
    FOnProgress: TclProgressEvent;
    FFlags: Integer;
    FCompressionLevel: TclCompressionLevel;
    FStrategy: TclCompressionStrategy;

    procedure CopyFrom(ASource, ADestination: TStream);
  protected
    procedure DoProgress(ABytesProceed, ATotalBytes: Int64); dynamic;
  public
    constructor Create(AOwner: TComponent); override;

    procedure Compress(const AFileSource, AFileDestination: string); overload;
    procedure Uncompress(const AFileSource, AFileDestination: string); overload;
    procedure Compress(ASource, ADestination: TStream); overload;
    procedure Uncompress(ASource, ADestination: TStream); overload;
  published
    property BatchSize: Integer read FBatchSize write FBatchSize default 8192;
    property CompressionLevel: TclCompressionLevel read FCompressionLevel
      write FCompressionLevel default clDefault;
    property Strategy: TclCompressionStrategy read FStrategy write FStrategy default csDefault;
    property Flags: Integer read FFlags write FFlags default 0;
    property OnProgress: TclProgressEvent read FOnProgress write FOnProgress;
  end;

implementation

procedure TclGZip.Uncompress(ASource, ADestination: TStream);
var
  compressor: TStream;
begin
  compressor := TclGZipInflateStream.Create(ADestination);
  try
    CopyFrom(ASource, compressor);
  finally
    compressor.Free();
  end;
end;

procedure TclGZip.Uncompress(const AFileSource, AFileDestination: string);
var
  inFile, outFile: TStream;
begin
  inFile := nil;
  outFile := nil;
  try
    inFile := TFileStream.Create(AFileSource, fmOpenRead or fmShareDenyWrite);
    outFile := TFileStream.Create(AFileDestination, fmCreate);
    Uncompress(inFile, outFile);
  finally
    outFile.Free();
    inFile.Free();
  end;
end;

constructor TclGZip.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FBatchSize := 8192;
  FCompressionLevel := clDefault;
  FStrategy := csDefault;
  FFlags := 0;
end;

procedure TclGZip.Compress(const AFileSource, AFileDestination: string);
var
  inFile, outFile: TStream;
begin
  inFile := nil;
  outFile := nil;
  try
    inFile := TFileStream.Create(AFileSource, fmOpenRead or fmShareDenyWrite);
    outFile := TFileStream.Create(AFileDestination, fmCreate);
    Compress(inFile, outFile);
  finally
    outFile.Free();
    inFile.Free();
  end;
end;

procedure TclGZip.CopyFrom(ASource, ADestination: TStream);
var
  bufLen, bytesRead, proceed, total: Int64;
  buf: PclChar;
begin
  bufLen := BatchSize;
  total := (ASource.Size - ASource.Position);
  if total < bufLen then
  begin
    bufLen := total;
  end;
  proceed := 0;

  GetMem(buf, bufLen);
  try
    repeat
      bytesRead := ASource.Read(buf^, bufLen);
      if (bytesRead > 0) then
      begin
        ADestination.Write(buf^, bytesRead);
        proceed := proceed + bytesRead;

        DoProgress(proceed, total);
      end;
    until (bytesRead = 0);
  finally
    FreeMem(buf);
  end;
end;

procedure TclGZip.Compress(ASource, ADestination: TStream);
var
  compressor: TStream;
begin
  compressor := TclGZipDeflateStream.Create(ADestination, CompressionLevel, Strategy, Flags);
  try
    CopyFrom(ASource, compressor);
  finally
    compressor.Free();
  end;
end;

procedure TclGZip.DoProgress(ABytesProceed, ATotalBytes: Int64);
begin
  if Assigned(OnProgress) then
  begin
    OnProgress(Self, ABytesProceed, ATotalBytes);
  end;
end;

end.
