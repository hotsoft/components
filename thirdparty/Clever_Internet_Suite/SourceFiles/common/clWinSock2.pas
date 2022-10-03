{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clWinSock2;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Windows, WinSock, SysUtils, SyncObjs,
{$ELSE}
  Winapi.Windows, Winapi.WinSock, System.SysUtils, System.SyncObjs,
{$ENDIF}
  clWUtils;

const
  AF_INET6         = 23;
  {$EXTERNALSYM AF_INET6}

{ getaddrinfo constants }
  AI_PASSIVE = 1;
  {$EXTERNALSYM AI_PASSIVE}
  AI_CANONNAME = 2;
  {$EXTERNALSYM AI_CANONNAME}
  AI_NUMERICHOST = 4;
  {$EXTERNALSYM AI_NUMERICHOST}

  EAI_FAIL = WSANO_RECOVERY;
  {$EXTERNALSYM EAI_FAIL}

  WSA_INVALID_EVENT = 0;
  {$EXTERNALSYM WSA_INVALID_EVENT}

  WSA_WAIT_FAILED = WAIT_FAILED;
  {$EXTERNALSYM WSA_WAIT_FAILED}
  WSA_WAIT_EVENT_0 = WAIT_OBJECT_0;
  {$EXTERNALSYM WSA_WAIT_EVENT_0}
  WSA_WAIT_TIMEOUT = WAIT_TIMEOUT;
  {$EXTERNALSYM WSA_WAIT_TIMEOUT}
  WSA_MAXIMUM_WAIT_EVENTS = MAXIMUM_WAIT_OBJECTS;
  {$EXTERNALSYM WSA_MAXIMUM_WAIT_EVENTS}
  WSA_INFINITE = INFINITE;
  {$EXTERNALSYM WSA_INFINITE}

  FD_READ_BIT = 0;
  {$EXTERNALSYM FD_READ_BIT}
  FD_WRITE_BIT = 1;
  {$EXTERNALSYM FD_WRITE_BIT}
  FD_ACCEPT_BIT = 3;
  {$EXTERNALSYM FD_ACCEPT_BIT}
  FD_CONNECT_BIT = 4;
  {$EXTERNALSYM FD_CONNECT_BIT}
  FD_CLOSE_BIT = 5;
  {$EXTERNALSYM FD_CLOSE_BIT}

  FD_MAX_EVENTS = 10;
  {$EXTERNALSYM FD_MAX_EVENTS}

{$IFNDEF DELPHI6}
  SD_RECEIVE     = 0;
  {$EXTERNALSYM SD_RECEIVE}
  SD_SEND        = 1;
  {$EXTERNALSYM SD_SEND}
  SD_BOTH        = 2;
  {$EXTERNALSYM SD_BOTH}
{$ENDIF}

type
  TWSANetworkEvents = packed record
    lNetworkEvents: Integer;
    iErrorCode: Array[0..FD_MAX_EVENTS - 1] of Integer;
  end;
  PWSANetworkEvents = ^TWSANetworkEvents;
  LPWSANetworkEvents = PWSANetworkEvents;

	IN_ADDR6 = packed record
		s6_addr_ : array[0..15] of u_char;
	end;
  TIn6Addr   = IN_ADDR6;
  PIn6Addr   = ^IN_ADDR6;
  IN6_ADDR   = IN_ADDR6;
  PIN6_ADDR  = ^IN_ADDR6;
  LPIN6_ADDR = ^IN_ADDR6;

	SOCKADDR_IN6_OLD = packed record
		sin6_family   : Smallint;
		sin6_port     : u_short;
		sin6_flowinfo : u_long;
		sin6_addr     : IN_ADDR6;
	end;
  
	SOCKADDR_IN6 = packed record
		sin6_family   : Smallint;
		sin6_port     : u_short;
		sin6_flowinfo : u_long;
		sin6_addr     : IN_ADDR6;
		sin6_scope_id : u_long;
	end;
  TSockAddrIn6   = SOCKADDR_IN6;
  PSockAddrIn6   = ^SOCKADDR_IN6;
  PSOCKADDR_IN6  = ^SOCKADDR_IN6;
  LPSOCKADDR_IN6 = ^SOCKADDR_IN6;

  SOCKADDR = TSockAddr;

  PSockAddrGen = ^TSockAddrGen;
	sockaddr_gen = packed record
		case Integer of
		0 : ( Address : SOCKADDR; );
		1 : ( AddressIn : SOCKADDR_IN; );
		2 : ( AddressIn6Old : SOCKADDR_IN6_OLD; );
		3 : ( AddressIn6 : SOCKADDR_IN6; );
	end;
  TSockAddrGen = sockaddr_gen;

  Paddrinfo = ^Taddrinfo;
  PPaddrinfo = ^Paddrinfo;
  Taddrinfo = packed record
    ai_flags: Integer;
    ai_family: Integer;
    ai_socktype: Integer;
    ai_protocol: Integer;
{$IFDEF DELPHIXE2}
    ai_addrlen: size_t;
{$ELSE}
    ai_addrlen: Cardinal;
{$ENDIF}
    ai_canonname: PclChar;
    ai_addr: PSockAddrGen;
    ai_next: Paddrinfo;
  end;

function WSACreateEvent: THandle; stdcall;
function WSAResetEvent(hEvent: THandle): Boolean; stdcall;
function WSACloseEvent(hEvent: THandle): Boolean; stdcall;
function WSAEventSelect(s: TSocket; hEventObject: THandle; lNetworkEvents: DWORD): Integer; stdcall;
function WSAWaitForMultipleEvents(cEvents: DWORD; lphEvents: PWOHandleArray;
  fWaitAll: BOOL; dwTimeout: DWORD; fAlertable: BOOL): DWORD; stdcall;
function WSAEnumNetworkEvents(const s: TSocket; const hEventObject: THandle;
  lpNetworkEvents: LPWSANETWORKEVENTS): Integer; stdcall;

function getaddrinfo(NodeName: PclChar; ServName: PclChar; Hints: Paddrinfo; Res: PPaddrinfo): Integer; stdcall;
procedure freeaddrinfo(ai: Paddrinfo); stdcall;

function connect_gen(s: TSocket; name: PSockAddrGen; namelen: Integer): Integer; stdcall;
function getsockname_gen(s: TSocket; name: PSockAddrGen; var namelen: Integer): Integer; stdcall;
function bind_gen(s: TSocket; addr: PSockAddrGen; namelen: Integer): Integer; stdcall;
function accept_gen(s: TSocket; addr: PSockAddrGen; var addrlen: Integer): TSocket; stdcall;
function recvfrom_gen(s: TSocket; var Buf; len, flags: Integer; from: PSockAddrGen; var fromlen: Integer): Integer; stdcall;
function sendto_gen(s: TSocket; var Buf; len, flags: Integer; addrto: PSockAddrGen; tolen: Integer): Integer; stdcall;

function IsIpV6Available: Boolean;

implementation

type
  TclWSAResetEvent = function (hEvent: THandle): Boolean; stdcall;
  TclWSACreateEvent = function : THandle; stdcall;
  TclWSACloseEvent = function (hEvent: THandle): Boolean; stdcall;
  TclWSAEventSelect = function (s: TSocket; hEventObject: THandle; lNetworkEvents: DWORD): Integer; stdcall;
  TclWSAWaitForMultipleEvents = function (cEvents: DWORD; lphEvents: PWOHandleArray;
    fWaitAll: LongBool; dwTimeout: DWORD; fAlertable: LongBool): DWORD; stdcall;
  TclWSAEnumNetworkEvents = function (const s: TSocket; const hEventObject: THandle;
    lpNetworkEvents: LPWSANETWORKEVENTS): Integer; stdcall;
  Tclgetaddrinfo = function (NodeName: PclChar; ServName: PclChar; Hints: Paddrinfo; Res: PPaddrinfo): Integer; stdcall;
  Tclfreeaddrinfo = procedure (ai: Paddrinfo); stdcall;

  TclConnect_gen = function (s: TSocket; name: PSockAddrGen; namelen: Integer): Integer; stdcall;
  TclGetsockname_gen = function (s: TSocket; name: PSockAddrGen; var namelen: Integer): Integer; stdcall;
  TclBind_gen = function (s: TSocket; addr: PSockAddrGen; namelen: Integer): Integer; stdcall;
  TclAccept_gen = function (s: TSocket; addr: PSockAddrGen; var addrlen: Integer): TSocket; stdcall;
  TclRecvfrom_gen = function (s: TSocket; var Buf; len, flags: Integer; from: PSockAddrGen; var fromlen: Integer): Integer; stdcall;
  TclSendto_gen = function (s: TSocket; var Buf; len, flags: Integer; addrto: PSockAddrGen; tolen: Integer): Integer; stdcall;


function clGetProcAddress(hModule: HMODULE; lpProcName: LPCSTR; Silent: Boolean): FARPROC; stdcall;
var
  Buffer: array[0..255] of Char;
begin
  Result := GetProcAddress(hModule, lpProcName);
  if (not Assigned(Result)) and (not Silent) then
  begin
    ZeroMemory(@Buffer, SizeOf(Buffer));
    FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, GetLastError(), 0, Buffer, SizeOf(Buffer), nil);
    raise Exception.Create(Buffer);
  end;
end;

var
  InitAccessor: TCriticalSection = nil;
  hWinSock2: THandle;
  clWSACreateEvent: TclWSACreateEvent;
  clWSAResetEvent: TclWSAResetEvent;
  clWSACloseEvent: TclWSACloseEvent;
  clWSAEventSelect: TclWSAEventSelect;
  clWSAWaitForMultipleEvents: TclWSAWaitForMultipleEvents;
  clWSAEnumNetworkEvents: TclWSAEnumNetworkEvents;
  clgetaddrinfo: Tclgetaddrinfo;
  clfreeaddrinfo: Tclfreeaddrinfo;

  hWinSock: THandle;
  clConnect_gen: TclConnect_gen;
  clGetsockname_gen: TclGetsockname_gen;
  clBind_gen: TclBind_gen;
  clAccept_gen: TclAccept_gen;
  clRecvfrom_gen: TclRecvfrom_gen;
  clSendto_gen: TclSendto_gen;

procedure InitWinSock2;
const
  DLLName = 'ws2_32.dll';
var
  Buffer: array[0..255] of Char;
begin
  InitAccessor.Enter();
  try
    if (hWinSock2 <= 0) then
    begin
      hWinSock2 := LoadLibrary(PChar(DLLName));
      if (hWinSock2 <= HINSTANCE_ERROR) then
      begin
        ZeroMemory(@Buffer, SizeOf(Buffer));
        FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, GetLastError(), 0, Buffer, SizeOf(Buffer), nil);
        raise Exception.Create(Buffer);
      end;
      @clWSACreateEvent := clGetProcAddress(hWinSock2, 'WSACreateEvent', False);
      @clWSAResetEvent := clGetProcAddress(hWinSock2, 'WSAResetEvent', False);
      @clWSACloseEvent := clGetProcAddress(hWinSock2, 'WSACloseEvent', False);
      @clWSAEventSelect := clGetProcAddress(hWinSock2, 'WSAEventSelect', False);
      @clWSAWaitForMultipleEvents := clGetProcAddress(hWinSock2, 'WSAWaitForMultipleEvents', False);
      @clWSAEnumNetworkEvents := clGetProcAddress(hWinSock2, 'WSAEnumNetworkEvents', False);
      @clgetaddrinfo := clGetProcAddress(hWinSock2, 'getaddrinfo', True);
      @clfreeaddrinfo := clGetProcAddress(hWinSock2, 'freeaddrinfo', True);
    end;
  finally
    InitAccessor.Leave();
  end;
end;

procedure InitWinSock;
const
  DLLName = 'wsock32.dll';
var
  Buffer: array[0..255] of Char;
begin
  InitAccessor.Enter();
  try
    if (hWinSock <= 0) then
    begin
      hWinSock := LoadLibrary(PChar(DLLName));
      if (hWinSock <= HINSTANCE_ERROR) then
      begin
        ZeroMemory(@Buffer, SizeOf(Buffer));
        FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, GetLastError(), 0, Buffer, SizeOf(Buffer), nil);
        raise Exception.Create(Buffer);
      end;
      @clConnect_gen := clGetProcAddress(hWinSock, 'connect', False);
      @clGetsockname_gen := clGetProcAddress(hWinSock, 'getsockname', False);
      @clBind_gen := clGetProcAddress(hWinSock, 'bind', False);
      @clAccept_gen := clGetProcAddress(hWinSock, 'accept', False);
      @clRecvfrom_gen := clGetProcAddress(hWinSock, 'recvfrom', False);
      @clSendto_gen := clGetProcAddress(hWinSock, 'sendto', False);
    end;
  finally
    InitAccessor.Leave();
  end;
end;

procedure FreeWinSock2;
begin
  if hWinSock2 > HINSTANCE_ERROR then
  begin
    FreeLibrary(hWinSock2);
  end;
  hWinSock2 := 0;
end;

procedure FreeWinSock;
begin
  if hWinSock > HINSTANCE_ERROR then
  begin
    FreeLibrary(hWinSock);
  end;
  hWinSock := 0;
end;

function WSACreateEvent: THandle stdcall;
begin
  InitWinSock2();
  Result := clWSACreateEvent();
end;

function WSAResetEvent(hEvent: THandle): Boolean stdcall;
begin
  InitWinSock2();
  Result := clWSAResetEvent(hEvent);
end;

function WSACloseEvent(hEvent: THandle): Boolean stdcall;
begin
  InitWinSock2();
  Result := clWSACloseEvent(hEvent);
end;

function WSAEventSelect(s: TSocket; hEventObject: THandle;
  lNetworkEvents: DWORD): Integer stdcall;
begin
  InitWinSock2();
  Result := clWSAEventSelect(s, hEventObject, lNetworkEvents);
end;

function WSAWaitForMultipleEvents(cEvents: DWORD; lphEvents: PWOHandleArray;
  fWaitAll: LongBool; dwTimeout: DWORD; fAlertable: LongBool): DWORD; stdcall;
begin
  InitWinSock2();
  Result := clWSAWaitForMultipleEvents(cEvents, lphEvents, fWaitAll, dwTimeout, fAlertable);
end;

function WSAEnumNetworkEvents(const s: TSocket; const hEventObject: THandle;
  lpNetworkEvents: LPWSANETWORKEVENTS): Integer; stdcall;
begin
  InitWinSock2();
  Result := clWSAEnumNetworkEvents(s, hEventObject, lpNetworkEvents);
end;

function IsIpV6Available: Boolean;
begin
  InitWinSock2();
  Result := Assigned(clgetaddrinfo) and Assigned(clfreeaddrinfo);
end;

function getaddrinfo(NodeName: PclChar; ServName: PclChar; Hints: Paddrinfo; Res: PPaddrinfo): Integer; stdcall;
begin
  InitWinSock2();
  if Assigned(clgetaddrinfo) then
  begin
    Result := clgetaddrinfo(NodeName, ServName, Hints, Res);
  end else
  begin
    Result := EAI_FAIL;
  end;
end;

procedure freeaddrinfo(ai: Paddrinfo); stdcall;
begin
  InitWinSock2();
  if Assigned(clfreeaddrinfo) and (ai <> nil) then
  begin
    clfreeaddrinfo(ai);
  end;
end;

function connect_gen(s: TSocket; name: PSockAddrGen; namelen: Integer): Integer; stdcall;
begin
  InitWinSock();
  Result := clConnect_gen(s, name, namelen);
end;

function getsockname_gen(s: TSocket; name: PSockAddrGen; var namelen: Integer): Integer; stdcall;
begin
  InitWinSock();
  Result := clGetsockname_gen(s, name, namelen);
end;

function bind_gen(s: TSocket; addr: PSockAddrGen; namelen: Integer): Integer; stdcall;
begin
  InitWinSock();
  Result := clBind_gen(s, addr, namelen);
end;

function accept_gen(s: TSocket; addr: PSockAddrGen; var addrlen: Integer): TSocket; stdcall;
begin
  InitWinSock();
  Result := clAccept_gen(s, addr, addrlen);
end;

function recvfrom_gen(s: TSocket; var Buf; len, flags: Integer; from: PSockAddrGen; var fromlen: Integer): Integer; stdcall;
begin
  InitWinSock();
  Result := clRecvfrom_gen(s, Buf, len, flags, from, fromlen);
end;

function sendto_gen(s: TSocket; var Buf; len, flags: Integer; addrto: PSockAddrGen; tolen: Integer): Integer; stdcall;
begin
  InitWinSock();
  Result := clSendto_gen(s, Buf, len, flags, addrto, tolen);
end;

initialization
  InitAccessor := TCriticalSection.Create();

finalization
  FreeWinSock();
  FreeWinSock2();
  InitAccessor.Free();

end.