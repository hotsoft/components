{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clUriUtils;

interface

{$I clVer.inc}
{$IFDEF DELPHI6}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

uses
  clWinInet, clWUtils;

type
  TclUrlType = (utUnknown, utFTP, utGOPHER, utHTTP, utHTTPS, utFILE, utNEWS, utMAILTO);

  TclOnUrlParsing = procedure (Sender: TObject; var URLComponents: TURLComponents) of object;

  TclUrlParser = class
  private
    FUrlpath: string;
    FUserName: string;
    FExtra: string;
    FHost: string;
    FPassword: string;
    FUrlType: TclUrlType;
    FPort: Integer;
    FAbsoluteUri: string;
    FOnUrlParsing: TclOnUrlParsing;
    FCharSet: string;

    function InternalParse(const AFullUrl: string): string;
    function GetAbsolutePath: string;
    class function IsUnsafeChar(ACharCode: TclChar): Boolean;
  protected
    procedure DoUrlParsing(var UrlComponents: TURLComponents); virtual;
  public
    class function CombineUrl(const AUrl, ABaseUrl: string): string; overload;
    class function CombineUrl(const AUrl, ABaseUrl, ACharSet: string): string; overload;
    class function EncodeUrl(const AUrl, ACharSet: string): string;

    function Parse(const AFullUrl: string): string; overload;
    function Parse(const AFullUrl, ACharSet: string): string; overload;
    procedure Assign(Source: TclUrlParser); virtual;

    property CharSet: string read FCharSet write FCharSet;

    property Host: string read FHost;
    property UserName: string read FUserName;
    property Password: string read FPassword;
    property Urlpath: string read FUrlpath;
    property Extra: string read FExtra;
    property AbsolutePath: string read GetAbsolutePath;
    property Port: Integer read FPort;
    property UrlType: TclUrlType read FUrlType;
    property AbsoluteUri: string read FAbsoluteUri;

    property OnUrlParsing: TclOnUrlParsing read FOnUrlParsing write FOnUrlParsing;
  end;

  TclUrlCorrector = class(TclUrlParser)
  private
    FIsByLocalFile: Boolean;
    FLocalFile: string;
  protected
    procedure DoUrlParsing(var UrlComponents: TURLComponents); override;
  public
    function GetURLByLocalFile(const AFullUrl, ALocalFile: string): string;
    function GetLocalFileByURL(const AFullUrl, ALocalFolder: string): string;
  end;

implementation

uses
{$IFNDEF DELPHIXE2}
  SysUtils, Windows,
{$ELSE}
  System.SysUtils, Winapi.Windows,
{$ENDIF}
  clUtils, clIdnTranslator, clTranslator{$IFDEF DELPHIXE4}, System.AnsiStrings{$ENDIF};

var
  UnsafeUriChars: PclChar = nil;
  UnsafeUriCharsCount: Integer = 0;

{$IFDEF DELPHIXE4}
function StrLen(A: PclChar): Integer;
begin
  Result := System.AnsiStrings.StrLen(A);
end;
{$ENDIF}

procedure InitStaticVars;
const
  Chars = ' <>"#%{}|\^~[]`';
begin
  UnsafeUriCharsCount := TclTranslator.GetByteCount(Chars, 'us-ascii');
  if (UnsafeUriCharsCount > 0) then
  begin
    GetMem(UnsafeUriChars, UnsafeUriCharsCount + 1);
    try
      TclTranslator.GetBytes(Chars, UnsafeUriChars, UnsafeUriCharsCount + 1, 'us-ascii');
      UnsafeUriChars[UnsafeUriCharsCount] := #0;
    except
      FreeMem(UnsafeUriChars);
      UnsafeUriChars := nil;
      UnsafeUriCharsCount := 0;
    end;
  end;
end;

{ TclUrlParser }

class function TclUrlParser.CombineUrl(const AUrl, ABaseUrl: string): string;
begin
  Result := CombineUrl(AUrl, ABaseUrl, '');
end;

procedure TclUrlParser.DoUrlParsing(var UrlComponents: TURLComponents);
begin
  if Assigned(FOnUrlParsing) then
  begin
    FOnUrlParsing(Self, UrlComponents);
  end;
end;

class function TclUrlParser.EncodeUrl(const AUrl, ACharSet: string): string;
  function IsHexDigit(c: TclChar): Boolean;
  begin
    Result := (c in ['0'..'9']) or (c in ['a'..'f']) or (c in ['A'..'F']);
  end;

var
  i, size: Integer;
  encBytes: PclChar;
begin
  Result := '';

  size := TclTranslator.GetByteCount(AUrl, ACharSet);
  if (size > 0) then
  begin
    GetMem(encBytes, size);
    try
      TclTranslator.GetBytes(AUrl, encBytes, size, ACharSet);

      i := 0;
      while (i < size) do
      begin
        if (encBytes[i] = '%') and (i + 2 < size)
          and IsHexDigit(encBytes[i + 1]) and IsHexDigit(encBytes[i + 2]) then
        begin
          Result := Result + '%' + string(encBytes[i + 1]) + string(encBytes[i + 2]);
          Inc(i, 2);
        end else
        if IsUnsafeChar(encBytes[i]) or (encBytes[i] >= #$7F) or (encBytes[i] < #$20) then
        begin
          Result := Result + '%' + IntToHex(Integer(encBytes[i]), 2);
        end else
        begin
          Result := Result + string(encBytes[i]);
        end;
        Inc(i);
      end;
    finally
      FreeMem(encBytes);
    end;
  end else
  begin
    Result := StringReplace(Trim(AUrl), #32, '%20', [rfReplaceAll]);
  end;
end;

function TclUrlParser.Parse(const AFullUrl, ACharSet: string): string;
begin
  FCharSet := ACharSet;

  Result := InternalParse(AFullUrl);
  if (Result = '') and (AFullUrl <> '')
    and (GetLastError() = ERROR_INTERNET_UNRECOGNIZED_SCHEME) then
  begin
    Result := InternalParse('http://' + AFullUrl);
  end;
  FAbsoluteUri := Result;
end;

function TclUrlParser.InternalParse(const AFullUrl: string): string;
  procedure CleanArray(var Arr: array of TclChar);
  begin
    ZeroMemory(Arr + 0, High(Arr) - Low(Arr) + 1);
  end;

var
  UrlComponents: TURLComponents;
  scheme: array[0..INTERNET_MAX_SCHEME_LENGTH - 1] of TclChar;
  host: array[0..INTERNET_MAX_HOST_NAME_LENGTH - 1] of TclChar;
  user: array[0..INTERNET_MAX_USER_NAME_LENGTH - 1] of TclChar;
  password: array[0..INTERNET_MAX_PASSWORD_LENGTH - 1] of TclChar;
  urlpath: array[0..INTERNET_MAX_PATH_LENGTH - 1] of TclChar;
  fullurl: array[0..INTERNET_MAX_URL_LENGTH - 1] of TclChar;
  extra: array[0..4096 - 1] of TclChar;
  dwLen: DWORD;
  res: BOOL;
begin
  FUrlType := utUnknown;
  FHost := '';
  FUserName := '';
  FPassword := '';
  FUrlpath := '';
  FExtra := '';
  FPort := INTERNET_INVALID_PORT_NUMBER;
  Result := '';

  CleanArray(scheme);
  CleanArray(host);
  CleanArray(user);
  CleanArray(password);
  CleanArray(urlpath);
  CleanArray(fullurl);
  CleanArray(extra);

  ZeroMemory(@UrlComponents, SizeOf(TURLComponents));
  UrlComponents.dwStructSize := SizeOf(TURLComponents);
  UrlComponents.lpszScheme := scheme;
  UrlComponents.dwSchemeLength := High(scheme) + 1;
  UrlComponents.lpszHostName := host;
  UrlComponents.dwHostNameLength := High(host) + 1;
  UrlComponents.lpszUserName := user;
  UrlComponents.dwUserNameLength := High(user) + 1;
  UrlComponents.lpszPassword := password;
  UrlComponents.dwPasswordLength := High(password) + 1;
  UrlComponents.lpszUrlPath := urlpath;
  UrlComponents.dwUrlPathLength := High(urlpath) + 1;
  UrlComponents.lpszExtraInfo := extra;
  UrlComponents.dwExtraInfoLength := High(extra) + 1;

  res := InternetCrackUrl(PclChar(GetTclString(AFullUrl)), Length(AFullUrl), 0, UrlComponents);
  if res then
  begin
    if (UrlComponents.nScheme in [Integer(Low(TclUrlType))..Integer(High(TclUrlType))]) then
    begin
      FUrlType := TclUrlType(UrlComponents.nScheme);
    end;
    DoUrlParsing(UrlComponents);
    if (StrLen(user) = 0) then
    begin
      UrlComponents.lpszUserName := nil;
      UrlComponents.dwUserNameLength :=  0;
    end;
    if (StrLen(password) = 0) then
    begin
      UrlComponents.lpszPassword := nil;
      UrlComponents.dwPasswordLength := 0;
    end;

    FHost := string(host);
    FUserName := string(user);
    FPassword := string(password);
    FUrlpath := string(urlpath);
    FExtra := string(extra);
    FPort := UrlComponents.nPort;

    FHost := TclIdnTranslator.GetAscii(FHost);
    CleanArray(host);
    Move(PclChar(TclString(FHost))^, host, Length(FHost));
    UrlComponents.dwHostNameLength := StrLen(host);

    dwLen := INTERNET_MAX_URL_LENGTH;
    fullurl[0] := #0;
    res := InternetCreateUrl(UrlComponents, 0, fullurl, dwLen);
    if res then
    begin
      Result := system.Copy(string(fullurl), 1, dwLen);
      Result := EncodeUrl(Result, FCharSet);
    end;
  end;
end;

class function TclUrlParser.IsUnsafeChar(ACharCode: TclChar): Boolean;
var
  i: Integer;
begin
  for i := 0 to UnsafeUriCharsCount - 1 do
  begin
    if (UnsafeUriChars[i] = ACharCode) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

function TclUrlParser.Parse(const AFullUrl: string): string;
begin
  Result := Parse(AFullUrl, '');
end;

procedure TclUrlParser.Assign(Source: TclUrlParser);
begin
  FAbsoluteUri := Source.AbsoluteUri;
  FHost := Source.Host;
  FUserName := Source.UserName;
  FPassword := Source.Password;
  FUrlpath := Source.Urlpath;
  FExtra := Source.Extra;
  FPort := Source.Port;
  FUrlType := Source.UrlType;
end;

function TclUrlParser.GetAbsolutePath: string;
begin
  if (Host = '*') then
  begin
    Result := Host;
  end else
  begin
    Result := Urlpath;
    if (Extra <> '') then
    begin
      if (Extra[1] <> '?') and (Result <> '') and (Result[Length(Result)] <> '?') then
      begin
        Result := Result + '?';
      end;
      Result := Result + Extra;
    end;
    if (Result = '') then
    begin
      Result := '/';
    end;
  end;

  Result := EncodeUrl(Result, FCharSet);
end;

class function TclUrlParser.CombineUrl(const AUrl, ABaseUrl, ACharSet: string): string;
var
  buf: array[0..INTERNET_MAX_URL_LENGTH - 1] of TclChar;
  len: DWORD;
  urlParser: TclUrlParser;
begin
  len := SizeOf(buf);
  ZeroMemory(buf + 0, len);
  InternetCombineUrl(PclChar(GetTclString(ABaseUrl)), PclChar(GetTclString(AUrl)), buf, len, ICU_BROWSER_MODE);
  Result := string(buf);
  urlParser := TclUrlParser.Create();
  try
    Result := urlParser.Parse(Result, ACharSet);
  finally
    urlParser.Free();
  end;
end;

{ TclUrlCorrector }

function TclUrlCorrector.GetURLByLocalFile(const AFullUrl, ALocalFile: string): string;
begin
  FIsByLocalFile := True;
  try
    FLocalFile := ALocalFile;
    Result := Parse(AFullUrl, CharSet);
  finally
    FIsByLocalFile := False;
  end;
end;

function TclUrlCorrector.GetLocalFileByURL(const AFullUrl, ALocalFolder: string): string;
var
  ind: Integer;
begin
  Result := ALocalFolder;
  if (Parse(AFullUrl, CharSet) <> '') then
  begin
    Result := AddTrailingBackSlash(Result);
    ind := LastDelimiter('/', Urlpath);
    Result := Result + system.Copy(Urlpath, ind + 1, MaxInt);
  end;
end;

procedure TclUrlCorrector.DoUrlParsing(var UrlComponents: TURLComponents);
var
  ind: Integer;
  s: string;
  ansiStr: TclString;
begin
  if FIsByLocalFile then
  begin
    s := string(URLComponents.lpszUrlPath);
    ind := LastDelimiter('/', s);
    s := system.Copy(s, 1, ind);
    ind := Length(s);
    if (ind > 0) and (s[ind] <> '/') then
    begin
      s := s + '/';
    end;
    ind := LastDelimiter('\', FLocalFile);
    s := s + system.Copy(FLocalFile, ind + 1, MaxInt);
    ansiStr := GetTclString(s);
    ZeroMemory(URLComponents.lpszUrlPath + 0, INTERNET_MAX_PATH_LENGTH);
    CopyMemory(URLComponents.lpszUrlPath + 0, PclChar(ansiStr), Length(ansiStr));
    URLComponents.dwUrlPathLength := Length(ansiStr);
  end;
  inherited DoUrlParsing(UrlComponents);
end;

initialization
  InitStaticVars();

finalization
  FreeMem(UnsafeUriChars);

end.

