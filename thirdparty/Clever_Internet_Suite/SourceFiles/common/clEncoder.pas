{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clEncoder;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,{$IFDEF DEMO} Windows, Forms,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils,{$IFDEF DEMO} Winapi.Windows, Vcl.Forms,{$ENDIF}
{$ENDIF}
  clStreams, clUtils, clTranslator, clWUtils{$IFDEF LOGGER}, clLogger{$ENDIF};

const
  DefaultCharsPerLine = 76;
  
type
  EclEncoderError = class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean = False);
    property ErrorCode: Integer read FErrorCode;
  end;

  TclEncodeMethod = (cmNone, cmQuotedPrintable, cmBase64, cmUUEncode, cm8Bit);

  TclEncoder = class(TComponent)
  private
    FEncodeMethod: TclEncodeMethod;
    FCharsPerLine: Integer;
    FSuppressCrlf: Boolean;
    FBatchSize: Integer;
    FOnProgress: TclProgressEvent;
    FAllowESC: Boolean;

    function GetCorrectCharsPerLine: Integer;
    function ReadOneLine(AStream: TStream; var Eof: Boolean; var crlfSkipped: Integer): string;
    procedure EncodeUUE(ASource, ADestination: TStream);
    procedure DecodeUUE(ASource, ADestination: TStream);
    procedure EncodeBASE64(ASource, ADestination: TStream);
    procedure DecodeBASE64(ASource, ADestination: TStream);
    procedure EncodeQP(ASource, ADestination: TStream);
    procedure DecodeQP(ASource, ADestination: TStream);
    function DecodeBASE64Bytes(var Buffer; ACount: Integer; var ABase64Pos, ABase64Val: Byte): Integer;
    procedure CopyStreams(ASource, ADestination: TStream);
  protected
    procedure DoProgress(ABytesProceed, ATotalBytes: Int64); virtual;
  public
    constructor Create(AOwner: TComponent); override;

    function GetPreferredEncoding(ASource: TStream): TclEncodeMethod; overload;
    function GetPreferredEncoding(const ASource: string): TclEncodeMethod; overload;
    function GetPreferredEncoding(const ASource, ACharSet: string): TclEncodeMethod; overload;

    class procedure Encode(ASource, ADestination: TStream; AMethod: TclEncodeMethod); overload;
    class function Encode(ASource: TStream; AMethod: TclEncodeMethod): string; overload;
    class function Encode(const ASource: string; AMethod: TclEncodeMethod): string; overload;
    class function EncodeBytes(const ASource: TclByteArray; AMethod: TclEncodeMethod): string; overload;

    class function EncodeToString(const ASource: string; AMethod: TclEncodeMethod): string; overload;
    class function EncodeToString(ASource: TStream; AMethod: TclEncodeMethod): string; overload;
    class function EncodeBytesToString(const ASource: TclByteArray; AMethod: TclEncodeMethod): string; overload;

    class procedure Decode(ASource, ADestination: TStream; AMethod: TclEncodeMethod); overload;
    class procedure Decode(const ASource: string; ADestination: TStream; AMethod: TclEncodeMethod); overload;
    class function Decode(const ASource: string; AMethod: TclEncodeMethod): string; overload;
    class function DecodeBytes(const ASource: string; AMethod: TclEncodeMethod): TclByteArray; overload;

    procedure Encode(ASource, ADestination: TStream); overload;
    function Encode(ASource: TStream): string; overload;
    function Encode(ASource: TStream; const ACharSet: string): string; overload;
    function Encode(const ASource: string): string; overload;
    function Encode(const ASource, ACharSet: string): string; overload;
    function EncodeBytes(const ASource: TclByteArray): string; overload;
    function EncodeBytes(const ASource: TclByteArray; const ACharSet: string): string; overload;

    procedure Decode(ASource, ADestination: TStream); overload;
    procedure Decode(const ASource: string; ADestination: TStream); overload;
    procedure Decode(const ASource, ACharSet: string; ADestination: TStream); overload;
    function Decode(const ASource: string): string; overload;
    function Decode(const ASource, ACharSet: string): string; overload;
    function DecodeBytes(const ASource: string): TclByteArray; overload;
    function DecodeBytes(const ASource, ACharSet: string): TclByteArray; overload;
  published
    property CharsPerLine: Integer read FCharsPerLine write FCharsPerLine default DefaultCharsPerLine;
    property EncodeMethod: TclEncodeMethod read FEncodeMethod write FEncodeMethod default cmBase64;
    property SuppressCrlf: Boolean read FSuppressCrlf write FSuppressCrlf default False;
    property BatchSize: Integer read FBatchSize write FBatchSize default 8192;
    property AllowESC: Boolean read FAllowESC write FAllowESC default False;

    property OnProgress: TclProgressEvent read FOnProgress write FOnProgress;
  end;
 
{$IFDEF DEMO}
{$IFNDEF IDEDEMO}
var
  IsEncoderDemoDisplayed: Boolean = False;
{$ENDIF}
{$ENDIF}

procedure RaiseEncoderError(const AErrorMessage: string; AErrorCode: Integer);

resourcestring
  ErrorUnsupported = 'Unsupported format.';
  ErrorWrongSymbols = 'Wrong symbols in source stream.';

const
  ErrorUnsupportedCode = -1;
  ErrorWrongSymbolsCode = -2;

implementation

const
  CR  = #13;
  LF  = #10;
  CRLF = CR + LF;
  MaxUUECharsPerLine = 132;
  MaxQPCharsPerLine = 132;
  MinBASE64CharsPerLine = 64;
  Base64CodeTable: TclString = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  Base64CodeTableEx: array[0..255] of Byte =
        ($00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$3f,$00,$00,$00,$40
        ,$35,$36,$37,$38,$39,$3a,$3b,$3c,$3d,$3e,$00,$00,$00,$00,$00,$00,$00,$01,$02,$03,$04,$05,$06,$07
        ,$08,$09,$0a,$0b,$0c,$0d,$0e,$0f,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$1a,$00,$00,$00,$00,$00
        ,$00,$1b,$1c,$1d,$1e,$1f,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2a,$2b,$2c,$2d,$2e,$2f,$30,$31
        ,$32,$33,$34,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
        ,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00);
        
procedure RaiseEncoderError(const AErrorMessage: string; AErrorCode: Integer);
begin
  raise EclEncoderError.Create(AErrorMessage, AErrorCode);
end;

{ TclEncoder }

procedure TclEncoder.CopyStreams(ASource, ADestination: TStream);
var
  sourceSize: Integer;
begin
  sourceSize := ASource.Size - ASource.Position;
  DoProgress(0, sourceSize);

  ADestination.CopyFrom(ASource, sourceSize);

  DoProgress(sourceSize, sourceSize);
end;

constructor TclEncoder.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCharsPerLine := DefaultCharsPerLine;
  FSuppressCrlf := False;
  FEncodeMethod := cmBase64;
  FBatchSize := 8192;
  FAllowESC := False;
end;

function TclEncoder.Encode(ASource: TStream): string;
begin
  Result := Encode(ASource, '');
end;

procedure TclEncoder.Encode(ASource, ADestination: TStream);
begin
{$IFDEF DEMO}
{$IFNDEF STANDALONEDEMO}
  if FindWindow('TAppBuilder', nil) = 0 then
  begin
    MessageBox(0, 'This demo version can be run under Delphi/C++Builder IDE only. ' +
      'Please visit www.clevercomponents.com to purchase your ' +
      'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    ExitProcess(1);
  end else
{$ENDIF}
  begin
{$IFNDEF IDEDEMO}
    if not IsEncoderDemoDisplayed then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsEncoderDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  if ((ASource.Size - ASource.Position) <= 0) then Exit;

  case EncodeMethod of
    cmQuotedPrintable: EncodeQP(ASource, ADestination);
    cmBase64:          EncodeBASE64(ASource, ADestination);
    cmUUEncode:        EncodeUUE(ASource, ADestination);
    cmNone, cm8Bit:    CopyStreams(ASource, ADestination);
    else RaiseEncoderError(ErrorUnsupported, ErrorUnsupportedCode);
  end;
end;

class function TclEncoder.Encode(const ASource: string; AMethod: TclEncodeMethod): string;
var
  encoder: TclEncoder;
begin
  encoder := TclEncoder.Create(nil);
  try
    encoder.EncodeMethod := AMethod;
    Result := encoder.Encode(ASource);
  finally
    encoder.Free();
  end;
end;

class procedure TclEncoder.Encode(ASource, ADestination: TStream; AMethod: TclEncodeMethod);
var
  encoder: TclEncoder;
begin
  encoder := TclEncoder.Create(nil);
  try
    encoder.EncodeMethod := AMethod;
    encoder.Encode(ASource, ADestination);
  finally
    encoder.Free();
  end;
end;

class function TclEncoder.Encode(ASource: TStream; AMethod: TclEncodeMethod): string;
var
  encoder: TclEncoder;
begin
  encoder := TclEncoder.Create(nil);
  try
    encoder.EncodeMethod := AMethod;
    Result := encoder.Encode(ASource, '');
  finally
    encoder.Free();
  end;
end;

function TclEncoder.Encode(const ASource: string): string;
begin
  Result := Encode(ASource, '');
end;

procedure TclEncoder.EncodeBASE64(ASource, ADestination: TStream);

  procedure ConvertToBase64(ASymbolsArray: PclChar; ACount, AProgressSize: Integer);
  const
    ProgressBlockCount = 1000;
  var
    Symb,
    i, j, cnt, progressStart, progressCur: Integer;
  begin
    cnt := (ACount div ProgressBlockCount);
    j := 0;
    progressStart := AProgressSize div 2;
    for i := 0 to ACount - 1 do
    begin
      if (cnt > 0) and (i > j * cnt) then
      begin
        progressCur := progressStart + j * progressStart div ProgressBlockCount + 1;
        if (progressCur < AProgressSize) then
        begin
          DoProgress(progressCur, AProgressSize);
        end;
        Inc(j);
      end;
      
      Symb := Integer(ASymbolsArray[i]);
      case Symb of
        64: ASymbolsArray[i] := TclChar(13);
        65: ASymbolsArray[i] := TclChar(10);
        0..63: ASymbolsArray[i] := Base64CodeTable[Symb + 1];
      else
        ASymbolsArray[i] := '=';
      end;
    end;
  end;

var
  Buffer: PclChar;
  OutBuffer: PclChar;
  i,
  Completed,
  Length,
  LineLength,
  RestLength,
  InIndex, OutIndex, sourceSize: Integer;
  FirstPass: Boolean;
begin
  sourceSize := ASource.Size - ASource.Position;
  DoProgress(0, sourceSize);

  Completed := sourceSize;
  if (Completed = 0) then Exit;
  
  FirstPass := True;
  if FSuppressCrlf then
  begin
    LineLength := sourceSize;
  end else
  begin
    LineLength := Trunc(GetCorrectCharsPerLine() * 3/4);
  end;

  Length := (((Completed div 3)*4) div LineLength) * (LineLength + 2);
  if (Length = 0) then Length := LineLength + 2;
  Length := (Length + ($2000 - 1)) and not ($2000 - 1);
  GetMem(Buffer, Completed + 1);
  GetMem(OutBuffer, Length);
  try
    ASource.Read(Buffer^, Completed);
    Buffer[Completed] := #0;
    OutIndex := 0;
    InIndex := 0;
    repeat
      if not (FSuppressCrlf or FirstPass) then
      begin
        OutBuffer[OutIndex] := TclChar(64);
        OutBuffer[OutIndex + 1] := TclChar(65);
        Inc(OutIndex, 2);
      end;
      FirstPass := False;
      RestLength := Completed - InIndex;
      if (RestLength > LineLength) then RestLength := LineLength;
      for i := 0 to (RestLength div 3) - 1 do
      begin
{$IFDEF LOGGER}
        if (InIndex + 2 >= Completed) then
        begin
          clPutLogMessage(Self, edInside, 'EncodeBASE64, (InIndex + 2 >= Completed) inside a loop: %d %d', nil, [InIndex, Completed]);
        end;
{$ENDIF}
        OutBuffer[OutIndex] := TclChar(Word(Buffer[InIndex]) shr 2);
        OutBuffer[OutIndex + 1] := TclChar(((Word(Buffer[InIndex]) shl 4) and 48) or ((Word(Buffer[InIndex + 1]) shr 4) and 15));
        OutBuffer[OutIndex + 2] := TclChar(((Word(Buffer[InIndex + 1]) shl 2) and 60) or ((Word(Buffer[InIndex + 2]) shr 6) and 3));
        OutBuffer[OutIndex + 3] := TclChar(Word(Buffer[InIndex + 2]) and 63);
        Inc(InIndex, 3);
        Inc(OutIndex, 4);
      end;
      if (RestLength mod 3) > 0 then
      begin
{$IFDEF LOGGER}
        if (InIndex + 2 >= Completed) then
        begin
          clPutLogMessage(Self, edInside, 'EncodeBASE64, (InIndex + 2 >= Completed): %d %d', nil, [InIndex, Completed]);
        end;
{$ENDIF}
        OutBuffer[OutIndex] := TclChar(Word(Buffer[InIndex]) shr 2);
        OutBuffer[OutIndex + 1] := TclChar(((Word(Buffer[InIndex]) shl 4) and 48) or ((Word(Buffer[InIndex + 1]) shr 4) and 15));
        if((RestLength mod 3) = 1) then
        begin
          OutBuffer[OutIndex + 2] := TclChar(-1);//'=';
          OutBuffer[OutIndex + 3] := TclChar(-1);//'=';
        end else
        begin
          OutBuffer[OutIndex + 2] := TclChar(((Word(Buffer[InIndex + 1]) shl 2) and 60) or ((Word(Buffer[InIndex + 2]) shr 6) and 3));
          OutBuffer[OutIndex + 3] := TclChar(-1);//'=';
        end;
        Inc(InIndex, 3);
        Inc(OutIndex, 4);
      end;

      //TODO DoProgress(InIndex div 2, sourceSize);
    until not(InIndex < Completed);
    ConvertToBase64(OutBuffer, OutIndex, sourceSize);
    ADestination.Write(OutBuffer^, OutIndex);
    DoProgress(sourceSize, sourceSize);
  finally
    FreeMem(OutBuffer);
{$IFDEF LOGGER}
    try
{$ENDIF}
      FreeMem(Buffer);
{$IFDEF LOGGER}
    except
      on E: Exception do
      begin
        clPutLogMessage(Self, edInside, 'EncodeBASE64, FreeMem(Buffer);', E);
        raise;
      end;
    end;
{$ENDIF}
  end;
end;

function TclEncoder.EncodeBytes(const ASource: TclByteArray; const ACharSet: string): string;
var
  sourceStream: TStream;
begin
  sourceStream := TMemoryStream.Create();
  try
    if (ASource <> nil) and (Length(ASource) > 0) then
    begin
      sourceStream.WriteBuffer(ASource[0], Length(ASource));
      sourceStream.Position := 0;
    end;

    Result := Encode(sourceStream, ACharSet);
  finally
    sourceStream.Free();
  end;
end;

function TclEncoder.EncodeBytes(const ASource: TclByteArray): string;
begin
  Result := EncodeBytes(ASource, '');
end;

class function TclEncoder.EncodeBytesToString(const ASource: TclByteArray; AMethod: TclEncodeMethod): string;
var
  encoder: TclEncoder;
begin
  encoder := TclEncoder.Create(nil);
  try
    encoder.EncodeMethod := AMethod;
    encoder.SuppressCrlf := True;
    Result := encoder.EncodeBytes(ASource, '');
  finally
    encoder.Free();
  end;
end;

class function TclEncoder.EncodeBytes(const ASource: TclByteArray; AMethod: TclEncodeMethod): string;
var
  encoder: TclEncoder;
begin
  encoder := TclEncoder.Create(nil);
  try
    encoder.EncodeMethod := AMethod;
    Result := encoder.EncodeBytes(ASource, '');
  finally
    encoder.Free();
  end;
end;

class function TclEncoder.Decode(const ASource: string; AMethod: TclEncodeMethod): string;
var
  encoder: TclEncoder;
begin
  encoder := TclEncoder.Create(nil);
  try
    encoder.EncodeMethod := AMethod;
    Result := encoder.Decode(ASource);
  finally
    encoder.Free();
  end;
end;

class procedure TclEncoder.Decode(const ASource: string; ADestination: TStream; AMethod: TclEncodeMethod);
var
  encoder: TclEncoder;
begin
  encoder := TclEncoder.Create(nil);
  try
    encoder.EncodeMethod := AMethod;
    encoder.Decode(ASource, ADestination);
  finally
    encoder.Free();
  end;
end;

class procedure TclEncoder.Decode(ASource, ADestination: TStream; AMethod: TclEncodeMethod);
var
  encoder: TclEncoder;
begin
  encoder := TclEncoder.Create(nil);
  try
    encoder.EncodeMethod := AMethod;
    encoder.Decode(ASource, ADestination);
  finally
    encoder.Free();
  end;
end;

function TclEncoder.Decode(const ASource: string): string;
begin
  Result := Decode(ASource, '');
end;

procedure TclEncoder.Decode(const ASource, ACharSet: string; ADestination: TStream);
var
  sourceStream: TStream;
  buffer: TclByteArray;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  sourceStream := TMemoryStream.Create();
  try
    if (ASource <> '') then
    begin
      buffer := TclTranslator.GetBytes(ASource, ACharSet);
      sourceStream.WriteBuffer(buffer[0], Length(buffer));
      sourceStream.Position := 0;
    end;

    Decode(sourceStream, ADestination);
  finally
    sourceStream.Free();
  end;
end;

procedure TclEncoder.Decode(const ASource: string; ADestination: TStream);
begin
  Decode(ASource, '', ADestination);
end;

procedure TclEncoder.Decode(ASource, ADestination: TStream);
begin
{$IFDEF DEMO}
{$IFNDEF STANDALONEDEMO}
  if FindWindow('TAppBuilder', nil) = 0 then
  begin
    MessageBox(0, 'This demo version can be run under Delphi/C++Builder IDE only. ' +
      'Please visit www.clevercomponents.com to purchase your ' +
      'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    ExitProcess(1);
  end else
{$ENDIF}
  begin
{$IFNDEF IDEDEMO}
    if not IsEncoderDemoDisplayed then
    begin
      MessageBox(0, 'Please visit www.clevercomponents.com to purchase your ' +
        'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    end;
    IsEncoderDemoDisplayed := True;
{$ENDIF}
  end;
{$ENDIF}
  if ((ASource.Size - ASource.Position) <= 0) then Exit;

  case EncodeMethod of
    cmQuotedPrintable: DecodeQP(ASource, ADestination);
    cmBase64:          DecodeBASE64(ASource, ADestination);
    cmUUEncode:        DecodeUUE(ASource, ADestination);
    cmNone, cm8Bit:    CopyStreams(ASource, ADestination);
    else RaiseEncoderError(ErrorUnsupported, ErrorUnsupportedCode);
  end;
end;

function TclEncoder.DecodeBASE64Bytes(var Buffer; ACount: Integer; var ABase64Pos, ABase64Val: Byte): Integer;
var
  index, outIndex, charCode: Integer;
  buf: PclChar;
begin
  index := 0;
  outIndex := 0;
  buf := PclChar(@Buffer);
  
  while (index < ACount) do
  begin
    if (buf[index] in ['=', CR, LF, ' ']) then
    begin
      Inc(index);
      Continue;
    end;

    charCode := Base64CodeTableEx[Byte(buf[index])] - 1;
    if (charCode < 0) then
    begin
      RaiseEncoderError(ErrorWrongSymbols, ErrorWrongSymbolsCode);
    end;

    case ABase64Pos of
      0:
        begin
          ABase64Val := Byte(charCode shl 2);
          Inc(ABase64Pos);
        end;
      1:
        begin
          buf[outIndex] := clChr(ABase64Val + (charCode shr 4));
          ABase64Val := Byte(charCode shl 4);
          Inc(outIndex);
          Inc(ABase64Pos);
        end;
      2:
        begin
          buf[outIndex] := clChr(ABase64Val + (charCode shr 2));
          ABase64Val := Byte(charCode shl 6);
          Inc(outIndex);
          Inc(ABase64Pos);
        end;
      3:
        begin
          buf[outIndex] := clChr(ABase64Val + charCode);
          Inc(outIndex);
          ABase64Pos := 0;
        end;
    end;
    Inc(index);
  end;
  
  Result := outIndex;
end;

function TclEncoder.DecodeBytes(const ASource, ACharSet: string): TclByteArray;
var
  destinationStream: TStream;
  size: Integer;
begin
  destinationStream := TMemoryStream.Create();
  try
    Decode(ASource, ACharSet, destinationStream);

    destinationStream.Position := 0;
    size := destinationStream.Size - destinationStream.Position;
    if (size > 0) then
    begin
      SetLength(Result, size);
      destinationStream.Read(Result[0], size);
    end else
    begin
      Result := nil;
    end;
  finally
    destinationStream.Free();
  end;
end;

function TclEncoder.DecodeBytes(const ASource: string): TclByteArray;
begin
  Result := DecodeBytes(ASource, '');
end;

class function TclEncoder.DecodeBytes(const ASource: string; AMethod: TclEncodeMethod): TclByteArray;
var
  encoder: TclEncoder;
begin
  encoder := TclEncoder.Create(nil);
  try
    encoder.EncodeMethod := AMethod;
    Result := encoder.DecodeBytes(ASource);
  finally
    encoder.Free();
  end;
end;

procedure TclEncoder.DecodeBASE64(ASource, ADestination: TStream);
var
  sourceSize, sourceStart: Int64;
  bufSuze, cnt: Integer;
  Buffer: PclChar;
  base64Pos, base64Val: Byte;
begin
  sourceSize := ASource.Size - ASource.Position;
  sourceStart := ASource.Position;
  DoProgress(0, sourceSize);

  bufSuze := Integer(sourceSize);
  if (bufSuze > BatchSize) then
  begin
    bufSuze := BatchSize;
  end;

  base64Pos := 0;
  base64Val := 0;
  
  GetMem(Buffer, bufSuze);
  try
    cnt := ASource.Read(Buffer^, bufSuze);
    while (cnt > 0) do
    begin
      cnt := DecodeBASE64Bytes(Buffer^, cnt, base64Pos, base64Val);

      if (cnt > 0) then
      begin
        ADestination.Write(Buffer^, cnt);
      end;

      cnt := ASource.Read(Buffer^, bufSuze);
      DoProgress(ASource.Position - sourceStart, sourceSize);
    end;
  finally
    FreeMem(Buffer);
  end;
end;

procedure TclEncoder.EncodeQP(ASource, ADestination: TStream);
  procedure WriteStream(AStream: TStream; const AText: string);
{$IFDEF DELPHI2009}
  var
    s: TclString;
{$ENDIF}
  begin
{$IFDEF DELPHI2009}
    s := TclString(AText);
    AStream.Write(PclChar(s)^, Length(s));
{$ELSE}
    AStream.Write(Pointer(AText)^, Length(AText));
{$ENDIF}
  end;

var
  Symbol, Symbol1: TclChar;
  i, sourceSize, sourceStart: Integer;
  Code: Integer;
  SoftBreak, moreData: Boolean;
begin
  sourceSize := ASource.Size - ASource.Position;
  sourceStart := ASource.Position;
  DoProgress(0, sourceSize);

  repeat
    moreData := True;
    SoftBreak := True;
    i := 0;
    while(FSuppressCrlf or(i <= GetCorrectCharsPerLine() - 6)) do
    begin
      if (ASource.Read(Symbol, 1) = 1) then
      begin
        Code := Ord(Symbol);
        case Code of
        32..60,62..126:
          ADestination.Write(Symbol, 1);
        61:
          begin
            WriteStream(ADestination, Format('=%2.2X', [Code]));
            i := i + 2;
          end;
        13:
          begin
            if (ASource.Read(Symbol, 1) = 1) then
            begin
              if (Symbol = LF) then
              begin
                Symbol1 := CR;
                ADestination.Write(Symbol1, 1);
                Symbol1 := LF;
                ADestination.Write(Symbol1, 1);
                SoftBreak := False;
                Break;
              end else
              begin
                WriteStream(ADestination, Format('=%2.2X', [Code]));
                i := i + 2;
                ASource.Seek(-1, soCurrent);
              end;
            end;
          end;
        else
          begin
            WriteStream(ADestination, Format('=%2.2X', [Code]));
            i := i + 2;
          end;
        end;
      end else
      begin
        SoftBreak := False;
        moreData := False;
        break;
      end;
      Inc(i);
    end;
    if SoftBreak then
    begin
      Symbol := '=';
      ADestination.Write(Symbol, 1);
      Symbol1 := CR;
      ADestination.Write(Symbol1, 1);
      Symbol1 := LF;
      ADestination.Write(Symbol1, 1);
    end;
    
    DoProgress(ASource.Position - sourceStart, sourceSize);
  until not moreData;
end;

class function TclEncoder.EncodeToString(ASource: TStream; AMethod: TclEncodeMethod): string;
var
  encoder: TclEncoder;
begin
  encoder := TclEncoder.Create(nil);
  try
    encoder.EncodeMethod := AMethod;
    encoder.SuppressCrlf := True;
    Result := encoder.Encode(ASource);
  finally
    encoder.Free();
  end;
end;

class function TclEncoder.EncodeToString(const ASource: string; AMethod: TclEncodeMethod): string;
var
  encoder: TclEncoder;
begin
  encoder := TclEncoder.Create(nil);
  try
    encoder.EncodeMethod := AMethod;
    encoder.SuppressCrlf := True;
    Result := encoder.Encode(ASource);
  finally
    encoder.Free();
  end;
end;

procedure TclEncoder.DecodeQP(ASource, ADestination: TStream);
var
  Symbol: TclChar;
  Buffer: string;
  Eof: Boolean;
  i, sourceSize, sourceStart: Integer;
  HexNumber: Integer;
  CRLFSkipped: Integer;
  CodePresent: Boolean;
  DelimPresent: Boolean;
begin
  sourceSize := ASource.Size - ASource.Position;
  sourceStart := ASource.Position;
  DoProgress(0, sourceSize);

  HexNumber := 0;
  CRLFSkipped := 0;
  CodePresent := False;
  DelimPresent := False;

  repeat
    Buffer := ReadOneLine(ASource, Eof, CRLFSkipped);
    if DelimPresent then
    begin
      Dec(CRLFSkipped);
    end;
    DelimPresent := False;

    for i := 0 to CRLFSkipped - 1 do
    begin
      Symbol := #13;
      ADestination.Write(Symbol, 1);
      Symbol := #10;
      ADestination.Write(Symbol, 1);
    end;
    CRLFSkipped := 0;

    for i := 1 to Length(Buffer) do
    begin
      if (DelimPresent) then
      begin
        case Buffer[i] of
        'A'..'F':
          begin
            HexNumber := HexNumber + (Ord(Buffer[i]) - 55);
          end;
        'a'..'f':
          begin
            HexNumber := HexNumber + (Ord(Buffer[i]) - 87);
          end;
        '0'..'9':
          begin
            HexNumber := HexNumber + (Ord(Buffer[i]) - 48);
          end;
        else
          begin
            CodePresent := False;
            DelimPresent := False;
            HexNumber := 0;
            Symbol := '=';
            ADestination.Write(Symbol, 1);
            ADestination.Write(Buffer[i], 1);
          end;
        end;
        if not CodePresent then
        begin
          HexNumber := HexNumber*16;
          CodePresent := True;
          continue;
        end else
        begin
          Symbol := clChr(HexNumber);
          ADestination.Write(Symbol, 1);
          CodePresent := False;
          DelimPresent := False;
          HexNumber := 0;
        end;
      end else
      begin
        if Buffer[i] = '=' then
        begin
          DelimPresent := True;
        end else
        begin
          ADestination.Write(Buffer[i], 1);
        end;
      end;
    end;
    DoProgress(ASource.Position - sourceStart, sourceSize);
  until Eof;
end;

procedure TclEncoder.EncodeUUE(ASource, ADestination: TStream);

  procedure ConvertToUUE(ASymbolsArray: PclChar; ACount, ALineLength: Integer);
  var
    SymbCount, Symb,
    i: Integer;
  begin
    SymbCount := 0;
    for i := 0 to ACount - 1 do
    begin
      Inc(SymbCount);
      if (SymbCount > ALineLength) then
      begin
        if (SymbCount <= (ALineLength + 2)) then Continue;
        SymbCount := 1;
      end;
      Symb := Integer(ASymbolsArray[i]);
      if Symb = 0 then
      begin
        ASymbolsArray[i] := '`';
      end else
      begin
        ASymbolsArray[i] := clChr((Symb and 63) + Ord(' '));
      end;
    end;
  end;

var
  Buffer: PclChar;
  OutBuffer: PclChar;
  LineLength, Length, OutLineLength, OutLen,
  i, k,
  Completed,
  Index, OutIndex, sourceSize: Integer;
begin
  sourceSize := ASource.Size - ASource.Position;
  DoProgress(0, sourceSize);

  Completed := sourceSize;
  if (Completed = 0) then Exit;
  
  if FSuppressCrlf then
  begin
    Length:= Completed;
  end else
  begin
    Length:= Trunc(GetCorrectCharsPerLine() * 3/4);
  end;

  GetMem(Buffer, Completed);
  OutLen := ((Completed div Length) + 1) * (GetCorrectCharsPerLine() + 5);
  OutLen := (OutLen + ($2000 - 1)) and not ($2000 - 1);
  GetMem(OutBuffer, OutLen);
  try
    ASource.Read(Buffer^, Completed);
    Index := 0;
    OutIndex := 0;
    LineLength := 0;
    OutLineLength := 0;
    for i := 0 to (Completed div Length) do
    begin
      LineLength := Completed - Index;
      if (LineLength > Length) then LineLength := Length;
      OutBuffer[OutIndex] := TclChar(LineLength);
      Inc(OutIndex);
      for k := 0 to (LineLength div 3) - 1 do
      begin
        OutBuffer[OutIndex] := TclChar(Word(Buffer[Index]) shr 2);
        OutBuffer[OutIndex + 1] := TclChar(((Word(Buffer[Index]) shl 4) and 48) or ((Word(Buffer[Index + 1]) shr 4) and 15));
        OutBuffer[OutIndex + 2] := TclChar(((Word(Buffer[Index + 1]) shl 2) and 60) or ((Word(Buffer[Index + 2]) shr 6) and 3));
        OutBuffer[OutIndex + 3] := TclChar(Word(Buffer[Index + 2]) and 63);
        Inc(Index, 3);
        Inc(OutIndex, 4);
      end;
      if ((LineLength mod 3) > 0) then
      begin
        OutBuffer[OutIndex] := TclChar(Word(Buffer[Index]) shr 2);
        if ((LineLength mod 3) = 2) then
        begin
          OutBuffer[OutIndex + 1] := TclChar(((Word(Buffer[Index]) shl 4) and 48) or ((Word(Buffer[Index + 1]) shr 4) and 15));
          OutBuffer[OutIndex + 2] := TclChar(((Word(Buffer[Index + 1]) shl 2) and 60));
        end else
        begin
          OutBuffer[OutIndex + 1] := TclChar(((Word(Buffer[Index]) shl 4) and 48));
          OutBuffer[OutIndex + 2] := #0;
        end;
        Inc(Index, LineLength mod 3);
        Inc(OutIndex, LineLength mod 3 + 1);
      end;
      if (OutLineLength = 0) then OutLineLength := OutIndex;
      if (not FSuppressCrlf) and (LineLength >= Length) then
      begin
        OutBuffer[OutIndex] := CR;
        OutBuffer[OutIndex + 1] := LF;
        Inc(OutIndex, 2);
      end;
      DoProgress(Index, sourceSize);
    end;
    ConvertToUUE(OutBuffer, OutIndex, OutLineLength);
    if not FSuppressCrlf then
    begin
      if (LineLength < Length) then
      begin
        OutBuffer[OutIndex] := CR;
        OutBuffer[OutIndex + 1] := LF;
        Inc(OutIndex, 2);
      end;
      OutBuffer[OutIndex] := '`';
      Inc(OutIndex, 1);
      OutBuffer[OutIndex] := CR;
      OutBuffer[OutIndex + 1] := LF;
      Inc(OutIndex, 2);
    end;
    ADestination.Write(OutBuffer^, OutIndex);
  finally
    FreeMem(OutBuffer);
    FreeMem(Buffer);
  end;
end;

procedure TclEncoder.DecodeUUE(ASource, ADestination: TStream);
var
  Buffer,
  DestBuffer: PclChar;
  curStrLength, Completed,
  i, Index, OutIndex, LineStartIndex,
  StrLength, sourceSize: Integer;
  SckipToLineEnd, HeaderSkipped, CRLFSkipped: Boolean;
  TmpStr: TclString;
begin
  sourceSize := ASource.Size - ASource.Position;
  DoProgress(0, sourceSize);

  Completed := sourceSize;
  if (Completed = 0) then Exit;

  GetMem(Buffer, Completed);
  GetMem(DestBuffer, Completed);
  try
    ASource.Read(Buffer^, Completed);
    StrLength := 0;
    OutIndex := 0;
    curStrLength := 0;
    LineStartIndex := 0;
    CRLFSkipped := True;
    HeaderSkipped := False;
    SckipToLineEnd := False;
    for Index := 0 to Completed - 1 do
    begin
      if ((Buffer[Index] in [CR, LF]) or (Index = (Completed - 1))) then
      begin
        if (Index = (Completed - 1)) and (not SckipToLineEnd) and not (Buffer[Index] in [CR, LF]) then
        begin
          DestBuffer[OutIndex] := TclChar((Integer(Buffer[Index]) - $20) and 63);
        end;
        SckipToLineEnd := False;
        OutIndex := LineStartIndex;
        for i := 0 to (StrLength div 4) - 1 do
        begin
          DestBuffer[OutIndex] := clChr((Word(DestBuffer[LineStartIndex]) shl 2) or (Word(DestBuffer[LineStartIndex + 1]) shr 4));
          DestBuffer[OutIndex + 1] := clChr((Word(DestBuffer[LineStartIndex + 1]) shl 4) or (Word(DestBuffer[LineStartIndex + 2]) shr 2));
          DestBuffer[OutIndex + 2] := clChr((Word(DestBuffer[LineStartIndex + 2]) shl 6) or (Word(DestBuffer[LineStartIndex + 3])));
          Inc(OutIndex, 3);
          Inc(LineStartIndex, 4);
        end;
        if ((StrLength mod 4) > 0) then
        begin
          DestBuffer[OutIndex] := clChr((Word(DestBuffer[LineStartIndex]) shl 2) or (Word(DestBuffer[LineStartIndex + 1]) shr 4));
          DestBuffer[OutIndex + 1] := clChr((Word(DestBuffer[LineStartIndex + 1]) shl 4) or (Word(DestBuffer[LineStartIndex + 2]) shr 2));
          Inc(OutIndex, StrLength mod 4);
        end;
        curStrLength := 0;
        StrLength := 0;
        CRLFSkipped := True;
        LineStartIndex := OutIndex;
      end else
      begin
        if SckipToLineEnd then
        begin
          DestBuffer[OutIndex] := #0;
          Inc(OutIndex);
          Continue;
        end;
        if CRLFSkipped then
        begin
          curStrLength := 0;
          if not HeaderSkipped then
          begin
            HeaderSkipped := True;
            TmpStr := 'begin';
            if CompareMem(PclChar(Buffer + Index), PclChar(TmpStr), 5) then
            begin
              SckipToLineEnd := True;
              Continue;
            end;
          end;
          StrLength := (((Integer(Buffer[Index]) - $20) and 63)*4) div 3;
          CRLFSkipped := False;
          if StrLength = 0 then
            Break
          else
            Continue;
        end;
        DestBuffer[OutIndex] := TclChar((Integer(Buffer[Index]) - $20) and 63);
        Inc(OutIndex);
        Inc(curStrLength);
        if (curStrLength > StrLength) then
        begin
          SckipToLineEnd := True;
        end;
      end;

      DoProgress(Index, sourceSize);
    end;
    ADestination.Write(DestBuffer^, OutIndex);
  finally
    FreeMem(DestBuffer);
    FreeMem(Buffer);
  end;
end;

procedure TclEncoder.DoProgress(ABytesProceed, ATotalBytes: Int64);
begin
  if Assigned(FOnProgress) then
  begin
    FOnProgress(Self, ABytesProceed, ATotalBytes);
  end;
end;

function TclEncoder.ReadOneLine(AStream: TStream; var Eof: Boolean;
  var crlfSkipped: Integer): string;
var
  Symbol: Byte;
  PrevSymbol: Byte;
  Completed: Integer;
  StrLength: Integer;
  RollBackCnt: Integer;
{$IFDEF DELPHI2009}
  s: TclString;
{$ENDIF}
begin
  Result := '';
  Eof := False;
  crlfSkipped := 0;
  StrLength := 0;
  PrevSymbol := 0;
{$IFNDEF WIN64}
{$IFNDEF DELPHIX101}
  RollBackCnt := 0;
{$ENDIF}
{$ENDIF}

  while (True) do
  begin
    Completed := AStream.Read(Symbol, 1);
    if (Completed = 0) then
    begin
      Eof := True;
      RollBackCnt := StrLength;
      Break;
    end;
    if (Symbol in [13, 10]) then
    begin
      if (StrLength <> 0) then
      begin
        RollBackCnt := StrLength + 1;
        Break;
      end;
      if not ((PrevSymbol = 13) and (Symbol = 10)) then
      begin
        Inc(crlfSkipped);
      end;
    end else
    begin
      Inc(StrLength);
    end;
    PrevSymbol := Symbol;
  end;
  if (StrLength <> 0) then
  begin
    AStream.Seek(-RollBackCnt, soCurrent);
{$IFDEF DELPHI2009}
    SetLength(s, StrLength);
    AStream.Read(PclChar(s)^, StrLength);
    Result := string(s);
{$ELSE}
    SetLength(Result, StrLength);
    AStream.Read(Pointer(Result)^, StrLength);
{$ENDIF}
  end;
end;

function TclEncoder.GetCorrectCharsPerLine: Integer;
begin
  Result := CharsPerLine;
  if (Result < 1) then
  begin
    Result := DefaultCharsPerLine;
  end;
  
  case EncodeMethod of
  cmUUEncode:
    begin
      if (CharsPerLine < 3) then
      begin
        Result := 3;
      end else
      if (CharsPerLine > MaxUUECharsPerLine) then
      begin
        Result := MaxUUECharsPerLine;
      end;
    end;
  cmQuotedPrintable:
    begin
      if (CharsPerLine < 4) then
      begin
        Result := 4;
      end else
      if (CharsPerLine > MaxQPCharsPerLine) then
      begin
        Result := MaxQPCharsPerLine;
      end;
    end;
  cmBase64:
    begin
      if(MinBASE64CharsPerLine <= CharsPerLine) then
      begin
        Result := Round(CharsPerLine/4 + 0.25) * 4;
      end else
      begin
        Result := MinBASE64CharsPerLine;
      end;
    end;
  end;
end;

function TclEncoder.GetPreferredEncoding(const ASource: string): TclEncodeMethod;
begin
  Result := GetPreferredEncoding(ASource, '');
end;

function TclEncoder.GetPreferredEncoding(ASource: TStream): TclEncodeMethod;
var
  NonTransportable,
  MaxNonTransportable: Integer;
  Symbol: TclChar;
  chPerLine: Integer;
  oldPos: Int64;
begin
  Result := cmNone;

  oldPos := ASource.Position;
  try
    NonTransportable := 0;
    chPerLine := 0;
    MaxNonTransportable := (ASource.Size - ASource.Position) div 2;
    while(ASource.Read(Symbol, 1) = 1) do
    begin
      case Ord(Symbol) of
        13,10:
          begin
            if(chPerLine > CharsPerLine) then
              Result := cmQuotedPrintable;
            chPerLine := 0;
          end;
        27:
          begin
            if AllowESC then
            begin
              Inc(chPerLine);
            end else
            begin
              Result := cmBase64;
              chPerLine := 0;
              Break;
            end;
          end;
        0..9,11..12,14..26,28..31:
          begin
            Result := cmBase64;
            chPerLine := 0;
            Break;
          end;
        32..126:
          begin
            Inc(chPerLine);
          end;
        127..255:
          begin
            Result := cmQuotedPrintable;
            Inc(NonTransportable);
            if (MaxNonTransportable < NonTransportable) then
            begin
              Result := cmBase64;
              Break;
            end;
          end;
      end;
    end;
    if(chPerLine > CharsPerLine) and (Result = cmNone) then
    begin
      Result := cmQuotedPrintable;
    end;
  finally
    ASource.Position := oldPos;
  end;
end;

function TclEncoder.GetPreferredEncoding(const ASource, ACharSet: string): TclEncodeMethod;
var
  buffer: TclByteArray;
  stream: TStream;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  stream := TMemoryStream.Create();
  try
    if (ASource <> '') then
    begin
      buffer := TclTranslator.GetBytes(ASource, ACharSet);
      stream.WriteBuffer(buffer[0], Length(buffer));
      stream.Position := 0;
    end;
    Result := GetPreferredEncoding(stream);
  finally
    stream.Free();
  end;
end;

function TclEncoder.Encode(const ASource, ACharSet: string): string;
var
  sourceStream: TStream;
  buffer: TclByteArray;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  sourceStream := TMemoryStream.Create();
  try
    if (ASource <> '') then
    begin
      buffer := TclTranslator.GetBytes(ASource, ACharSet);
      sourceStream.WriteBuffer(buffer[0], Length(buffer));
      sourceStream.Position := 0;
    end;

    Result := Encode(sourceStream, ACharSet);
  finally
    sourceStream.Free();
  end;
end;

function TclEncoder.Encode(ASource: TStream; const ACharSet: string): string;
var
  destinationStream: TStream;
  buffer: TclByteArray;
  size: Integer;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  destinationStream := TMemoryStream.Create();
  try
    Encode(ASource, destinationStream);

    destinationStream.Position := 0;
    size := destinationStream.Size - destinationStream.Position;
    if (size > 0) then
    begin
      SetLength(buffer, size);
      destinationStream.Read(buffer[0], size);
      Result := TclTranslator.GetString(buffer, 0, size, ACharSet);
    end else
    begin
      Result := '';
    end;
  finally
    destinationStream.Free();
  end;
end;

function TclEncoder.Decode(const ASource, ACharSet: string): string;
var
  destinationStream: TStream;
  buffer: TclByteArray;
  size: Integer;
begin
{$IFNDEF DELPHI2005}buffer := nil;{$ENDIF}
  destinationStream := TMemoryStream.Create();
  try
    Decode(ASource, ACharSet, destinationStream);

    destinationStream.Position := 0;
    size := destinationStream.Size - destinationStream.Position;
    if (size > 0) then
    begin
      SetLength(buffer, size);
      destinationStream.Read(buffer[0], size);
      Result := TclTranslator.GetString(buffer, 0, size, ACharSet);
    end else
    begin
      Result := '';
    end;
  finally
    destinationStream.Free();
  end;
end;

{ EclEncoderError }

constructor EclEncoderError.Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorMsg);
  FErrorCode := AErrorCode;
end;

end.

