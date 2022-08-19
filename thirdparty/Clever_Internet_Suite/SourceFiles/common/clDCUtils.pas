{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clDCUtils;

interface

{$I clVer.inc}
{$IFDEF DELPHI6}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clWinInet, clWUtils;

type
  EclInternetError = class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(const AErrorText: string; AErrorCode: Integer; ADummy: Boolean = False);
    constructor CreateByLastError;
    property ErrorCode: Integer read FErrorCode;

    class function GetLastErrorText(ACode: Integer): string;
  end;

  TclResourceInfo = class
  private
    FSize: Int64;
    FName: string;
    FDate: TDateTime;
    FContentType: string;
    FStatusCode: Integer;
    FAllowsRandomAccess: Boolean;
    FContentDisposition: string;
    FCompressed: Boolean;
    FStatusText: string;
    function GetAllowsRandomAccess: Boolean;
  protected
    procedure SetName(const AValue: string);
    procedure SetDate(AValue: TDateTime);
    procedure SetSize(AValue: Int64);
    procedure SetContentType(const AValue: string);
    procedure SetStatus(ACode: Integer; const AText: string);
    procedure SetAllowsRandomAccess(AValue: Boolean);
    procedure SetContentDisposition(const AValue: string);
    procedure SetCompressed(AValue: Boolean);
  public
    constructor Create;
    procedure Assign(Source: TclResourceInfo); virtual;
    property Name: string read FName;
    property Date: TDateTime read FDate;
    property Size: Int64 read FSize;
    property ContentType: string read FContentType;
    property StatusCode: Integer read FStatusCode;
    property StatusText: string read FStatusText;
    property AllowsRandomAccess: Boolean read GetAllowsRandomAccess;
    property ContentDisposition: string read FContentDisposition;
    property Compressed: Boolean read FCompressed; 
  end;

const
  MaxThreadCount = 10;
  DefaultThreadCount = 5;
  DefaultPreviewChar = #128;
  DefaultPreviewCharCount = 256;
  DefaultTryCount = 5;
  DefaultTimeOut = 5000;

resourcestring
  cOperationIsInProgress = 'Operation is in progress';
  cUnknownError = 'Unknown error, code = %d';
  cResourceAccessError = 'HTTP resource access error occured, code = %d';
  cDataStreamAbsent = 'The data source stream is not assigned';
  cExtendedErrorInfo = 'Additional info';
  cRequestTimeOut = 'Request timeout';
  cDataValueName = 'Data';

  HTTP_QUERY_STATUS_CODE_Msg = 'Status Code';
  HTTP_QUERY_CONTENT_LENGTH_Msg = 'Content Length';
  HTTP_QUERY_LAST_MODIFIED_Msg = 'Last Modified';
  HTTP_QUERY_CONTENT_TYPE_Msg = 'Content Type';

implementation

uses
  clUtils;

{ TclResourceInfo }

procedure TclResourceInfo.Assign(Source: TclResourceInfo);
begin
  if (Source <> nil) then
  begin
    FSize := Source.Size;
    FName := Source.Name;
    FDate := Source.Date;
    FContentType := Source.ContentType;
    FStatusCode := Source.StatusCode;
    FStatusText := Source.StatusText;
    FAllowsRandomAccess := Source.AllowsRandomAccess;
    FContentDisposition := Source.ContentDisposition;
    FCompressed := Source.Compressed;
  end else
  begin
    FSize := 0;
    FName := '';
    FDate := 0;
    FContentType := '';
    FStatusCode := 0;
    FStatusText := '';
    FAllowsRandomAccess := False;
    FContentDisposition := '';
    FCompressed := False;
  end;
end;

constructor TclResourceInfo.Create;
begin
  inherited Create();
  FSize := 0;
  FDate := Now();
end;

function TclResourceInfo.GetAllowsRandomAccess: Boolean;
begin
  Result := (Size > 0) and FAllowsRandomAccess;
end;

procedure TclResourceInfo.SetAllowsRandomAccess(AValue: Boolean);
begin
  FAllowsRandomAccess := AValue;
end;

procedure TclResourceInfo.SetCompressed(AValue: Boolean);
begin
  FCompressed := AValue;
end;

procedure TclResourceInfo.SetContentDisposition(const AValue: string);
begin
  FContentDisposition := AValue;
end;

procedure TclResourceInfo.SetContentType(const AValue: string);
begin
  FContentType := AValue;
end;

procedure TclResourceInfo.SetDate(AValue: TDateTime);
begin
  FDate := AValue;
end;

procedure TclResourceInfo.SetName(const AValue: string);
begin
  FName := AValue;
end;

procedure TclResourceInfo.SetSize(AValue: Int64);
begin
  FSize := AValue;
end;

procedure TclResourceInfo.SetStatus(ACode: Integer; const AText: string);
begin
  FStatusCode := ACode;
  FStatusText := AText;
end;

{ EclInternetError }

constructor EclInternetError.CreateByLastError;
begin
  FErrorCode := clGetLastError();
  inherited Create(GetLastErrorText(FErrorCode));
end;

class function EclInternetError.GetLastErrorText(ACode: Integer): string;
var
  ExtErr, dwLength: DWORD;
  Len: Integer;
  Buffer: array[0..255] of Char;
  buf: PclChar;
begin
  Result := '';
  Len := FormatMessage(FORMAT_MESSAGE_FROM_HMODULE or FORMAT_MESSAGE_FROM_SYSTEM,
    Pointer(GetModuleHandle('wininet.dll')), ACode, 0, Buffer, SizeOf(Buffer), nil);

  while (Len > 0) and CharInSet(Buffer[Len - 1], [#0..#32, '.']) do Dec(Len);

  SetString(Result, Buffer, Len);
  if (ACode = ERROR_INTERNET_EXTENDED_ERROR) then
  begin
    InternetGetLastResponseInfo(ExtErr, nil, dwLength);
    if (dwLength > 0) then
    begin
      GetMem(buf, dwLength);
      try
        if InternetGetLastResponseInfo(ExtErr, buf, dwLength) then
        begin
          if (Result <> '') then
          begin
            Result := Result + '; ' + cExtendedErrorInfo + ': ';
          end;
          Result := Result + GetString_(buf);
        end;
      finally
        FreeMem(buf);
      end;
    end;
  end;
  if (Result = '') then
  begin
    Result := Format(cUnknownError, [ACode]);
  end;
end;

constructor EclInternetError.Create(const AErrorText: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorText);
  FErrorCode := AErrorCode;
end;

end.

