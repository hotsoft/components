{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clIpAddress;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows, WinSock,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows, Winapi.WinSock,
{$ENDIF}
  clWinSock2, clWUtils;

type
  TclIPAddress = class
  protected
    function GetIsIpV6: Boolean; virtual; abstract;
    function GetAddress: PSockAddrGen; virtual; abstract;
    function GetAddressFamily: Integer; virtual; abstract;
    function GetAddressLength: Integer; virtual; abstract;
    function GetPort: Integer; virtual; abstract;
    procedure Clear; virtual; abstract;
  public
    class function IsHostIP(const AHost: string): Boolean;
    class function CreateIpAddress(const AHost: string): TclIPAddress;
    class function CreateNone(AddrFamily: Integer): TclIPAddress;
    class function CreateAny(AddrFamily: Integer): TclIPAddress;
    class function CreateBindingIpAddress(const AHost: string): TclIPAddress; overload;
    class function CreateBindingIpAddress(const AHost: string; AddrFamily: Integer): TclIPAddress; overload;

    function Parse(const AHost: string): Boolean; virtual; abstract;

    procedure None(AddrFamily: Integer); virtual; abstract;
    procedure Any(AddrFamily: Integer); virtual; abstract;

    procedure SetPort(const Value: Integer); virtual;
{$IFNDEF DELPHI2009}
    function ToString: string; virtual; abstract;
{$ENDIF}

    property Address: PSockAddrGen read GetAddress;
    property AddressLength: Integer read GetAddressLength;
    property AddressFamily: Integer read GetAddressFamily;
    property IsIpV6: Boolean read GetIsIpV6;
    property Port: Integer read GetPort;
  end;

  TclIPAddress4 = class(TclIPAddress)
  private
    FSockAddr: TSockAddrIn;
  protected
    function GetIsIpV6: Boolean; override;
    function GetAddress: PSockAddrGen; override;
    function GetAddressFamily: Integer; override;
    function GetAddressLength: Integer; override;
    function GetPort: Integer; override;
    procedure Clear; override;
  public
    class function AddrToStr(Addr: in_addr): string;
    class function IsPrivateUseIP(const AIP: string): Boolean;

    function Parse(const AHost: string): Boolean; override;
    procedure None(AddrFamily: Integer); override;
    procedure Any(AddrFamily: Integer); override;

    procedure SetPort(const Value: Integer); override;
    function ToString: string; override;
  end;

  TclIPAddress6 = class(TclIPAddress)
  private
    FAddrInfo: Paddrinfo;
  protected
    function GetIsIpV6: Boolean; override;
    function GetAddress: PSockAddrGen; override;
    function GetAddressFamily: Integer; override;
    function GetAddressLength: Integer; override;
    function GetPort: Integer; override;
    procedure Clear; override;
  public
    destructor Destroy; override;

    class function AddrToStr(Addr: IN_ADDR6): string;

    function Parse(const AHost: string): Boolean; override;
    procedure None(AddrFamily: Integer); override;
    procedure Any(AddrFamily: Integer); override;

    procedure SetPort(const Value: Integer); override;
    function ToString: string; override;
  end;

var
  IsIpV6Preferred: Boolean = False;

implementation

uses
  clUtils, clSocketUtils;

const
  cAddressFamilies: array[Boolean] of Integer = (AF_INET, AF_INET6);
  
{ TclIPAddress }

class function TclIPAddress.CreateNone(AddrFamily: Integer): TclIPAddress;
begin
  Result := nil;
  try
    if IsIpV6Available() then
    begin
      Result := TclIPAddress6.Create();
    end else
    begin
      Result := TclIPAddress4.Create();
    end;

    Result.None(AddrFamily);
  except
    Result.Free();
    raise;
  end;
end;

class function TclIPAddress.IsHostIP(const AHost: string): Boolean;
var
  addr: TclIPAddress;
begin
  if (AHost = '') then
  begin
    Result := False;
    Exit;
  end;

  addr := nil;
  try
    addr := TclIPAddress6.Create();
    Result := addr.Parse(AHost);
    if Result then Exit;

    FreeAndNil(addr);
    addr := TclIPAddress4.Create();
    Result := addr.Parse(AHost);
    if Result then Exit;
  finally
    addr.Free();
  end;
end;

class function TclIPAddress.CreateAny(AddrFamily: Integer): TclIPAddress;
begin
  Result := nil;
  try
    if IsIpV6Available() then
    begin
      Result := TclIPAddress6.Create();
    end else
    begin
      Result := TclIPAddress4.Create();
    end;

    Result.Any(AddrFamily);
  except
    Result.Free();
    raise;
  end;
end;

class function TclIPAddress.CreateBindingIpAddress(const AHost: string; AddrFamily: Integer): TclIPAddress;
begin
  if (AHost = '') then
  begin
    Result := CreateAny(AddrFamily);
    Exit;
  end;

	Result := CreateIpAddress(AHost);
end;

class function TclIPAddress.CreateBindingIpAddress(const AHost: string): TclIPAddress;
begin
  Result := CreateBindingIpAddress(AHost, cAddressFamilies[IsIpV6Preferred]);
end;

class function TclIPAddress.CreateIpAddress(const AHost: string): TclIPAddress;
begin
  Result := nil;
  try
    Result := TclIPAddress6.Create();
    if Result.Parse(AHost) then Exit;
    FreeAndNil(Result);

    Result := TclIPAddress4.Create();
    if Result.Parse(AHost) then Exit;
    FreeAndNil(Result);

    RaiseSocketError(InvalidAddress, InvalidAddressCode);
  except
    Result.Free();
    raise;
  end;
end;

procedure TclIPAddress.SetPort(const Value: Integer);
begin
  if (Value < 0) then
  begin
    RaiseSocketError(InvalidPort, InvalidPortCode);
  end;
end;

{ TclIPAddress4 }

procedure TclIPAddress4.Any(AddrFamily: Integer);
begin
  None(AddrFamily);
  FSockAddr.sin_addr.S_addr := INADDR_ANY;
end;

procedure TclIPAddress4.Clear;
begin
  ZeroMemory(@FSockAddr, AddressLength);
end;

procedure TclIPAddress4.None(AddrFamily: Integer);
begin
  if (AF_INET <> AddrFamily) then
  begin
    RaiseSocketError(InvalidAddressFamily, InvalidAddressFamilyCode);
  end;
  
  Clear();
  FSockAddr.sin_family := AddrFamily;
end;

function TclIPAddress4.GetAddress: PSockAddrGen;
begin
  Result := @FSockAddr;
end;

function TclIPAddress4.GetAddressFamily: Integer;
begin
  Result := FSockAddr.sin_family;
end;

function TclIPAddress4.GetAddressLength: Integer;
begin
  Result := SizeOf(TSockAddrIn);
end;

function TclIPAddress4.GetIsIpV6: Boolean;
begin
  Result := False;
end;

function TclIPAddress4.GetPort: Integer;
begin
  Result := ntohs(FSockAddr.sin_port);
end;

class function TclIPAddress4.IsPrivateUseIP(const AIP: string): Boolean;
var
  b: Byte;
begin
  Result := False;
//     10.0.0.0        -   10.255.255.255  (10/8 prefix)
//     172.16.0.0      -   172.31.255.255  (172.16/12 prefix)
//     192.168.0.0     -   192.168.255.255 (192.168/16 prefix)
  if (Pos('192.168.', AIP) = 1) or (Pos('10.', AIP) = 1) then
  begin
    Result := True;
  end else
  if (Pos('172.', AIP) = 1) then
  begin
    b := Byte(StrToIntDef(ExtractWord(2, AIP, ['.']), 0));
    if (b in [16..31]) then
    begin
      Result := True;
    end;
  end;
end;

class function TclIPAddress4.AddrToStr(Addr: in_addr): string;
var
  p: PclChar;
begin
  p := inet_ntoa(Addr);
  if (p <> nil) then
  begin
    SetLength(Result, Length(p));
    Result := string(System.Copy(p, 0, Length(p)));
  end else
  begin
    Result := '';
  end;
end;

function TclIPAddress4.Parse(const AHost: string): Boolean;
var
  addr: Integer;
begin
  Clear();

  addr := inet_addr(PclChar(GetTclString(AHost)));
  Result := (addr <> Integer(INADDR_NONE));
  if Result then
  begin
    FSockAddr.sin_addr.S_addr := addr;
    FSockAddr.sin_family := AF_INET;
  end;
end;

procedure TclIPAddress4.SetPort(const Value: Integer);
begin
  inherited SetPort(Value);
  FSockAddr.sin_port := htons(Value);
end;

function TclIPAddress4.ToString: string;
begin
  Result := AddrToStr(FSockAddr.sin_addr);
end;

{ TclIPAddress6 }

procedure TclIPAddress6.Any(AddrFamily: Integer);
begin
  None(AddrFamily);
  if (AF_INET = AddrFamily) then
  begin
    Address.AddressIn.sin_addr.S_addr := INADDR_ANY;
  end;
end;

procedure TclIPAddress6.Clear;
begin
  if IsIpV6Available() then
  begin
    freeaddrinfo(FAddrInfo);
    FAddrInfo := nil;
  end;
end;

destructor TclIPAddress6.Destroy;
begin
  Clear();
  inherited Destroy();
end;

procedure TclIPAddress6.None(AddrFamily: Integer);
var
  ip: string;
begin
  if not (AddrFamily in [AF_INET, AF_INET6]) then
  begin
    RaiseSocketError(InvalidAddressFamily, InvalidAddressFamilyCode);
  end;

  if (AF_INET6 = AddrFamily) then
  begin
    ip := '::';
  end else
  begin
    ip := '0.0.0.0';
  end;

  if not Parse(ip) then
  begin
    RaiseSocketError(InvalidAddress, InvalidAddressCode);
  end;
end;

function TclIPAddress6.GetAddress: PSockAddrGen;
begin
  if (FAddrInfo <> nil) then
  begin
    Result := FAddrInfo.ai_addr;
  end else
  begin
    Result := nil;
  end;
end;

function TclIPAddress6.GetAddressFamily: Integer;
begin
  if (FAddrInfo <> nil) then
  begin
    Result := FAddrInfo.ai_family;
  end else
  begin
    Result := AF_UNSPEC;
  end;
end;

function TclIPAddress6.GetAddressLength: Integer;
begin
  if (FAddrInfo <> nil) then
  begin
    Result := FAddrInfo.ai_addrlen;
  end else
  begin
    Result := 0;
  end;
end;

function TclIPAddress6.GetIsIpV6: Boolean;
begin
  Result := (AF_INET6 = AddressFamily);
end;

function TclIPAddress6.GetPort: Integer;
begin
  Result := 0;
  if (FAddrInfo <> nil) then
  begin
    if (AddressFamily = AF_INET) then
    begin
      Result := ntohs(FAddrInfo.ai_addr.Address.sin_port);
    end else
    if (AddressFamily = AF_INET6) then
    begin
      Result := ntohs(FAddrInfo.ai_addr.AddressIn6Old.sin6_port);
    end;
  end;
end;

class function TclIPAddress6.AddrToStr(Addr: IN_ADDR6): string;
var
  ind: Integer;
  w: Word;
  duplicated: Integer;
begin
  Result := '';
  ind := 0;
  duplicated := 0;
  while (ind < 15) do
  begin
    w := Byte(Addr.s6_addr_[ind]) shl 8;
    Inc(ind);
    w := w or Byte(Addr.s6_addr_[ind]);
    Inc(ind);

    if (duplicated > -1) and (w = 0) then
    begin
      Inc(duplicated);
    end else
    if (duplicated = 1) then
    begin
      if (Result <> '') then
      begin
        Result := Result + ':';
      end;
      Result := Result + '0:' + IntToHex(w, 1);
      duplicated := -1;
    end else
    if (duplicated > 1) then
    begin
      Result := Result + '::' + IntToHex(w, 1);
      duplicated := -1;
    end else
    begin
      if (Result <> '') then
      begin
        Result := Result + ':';
      end;

      Result := Result + IntToHex(w, 1);
    end;
  end;

  if (duplicated > 0) then
  begin
    if (Result <> '') then
    begin
      Result := Result + ':';
    end;

    Result := Result + '0';
  end;

  if (Result = '0') then
  begin
    Result := '::';
  end;
end;

function TclIPAddress6.Parse(const AHost: string): Boolean;
var
  hints: Taddrinfo;
begin
  Clear();
  Result := IsIpV6Available();
  if not Result then Exit;

  ZeroMemory(@hints, SizeOf(Taddrinfo));
  hints.ai_flags := AI_NUMERICHOST;
  hints.ai_family := AF_UNSPEC;

  Result := (getaddrinfo(PclChar(GetTclString(AHost)), nil, @hints, @FAddrInfo) = 0);
end;

procedure TclIPAddress6.SetPort(const Value: Integer);
begin
  inherited SetPort(Value);

  if (AddressFamily = AF_INET) then
  begin
    FAddrInfo.ai_addr.Address.sin_port := htons(Value);
    FAddrInfo.ai_protocol := Value;
  end else
  if (AddressFamily = AF_INET6) then
  begin
    FAddrInfo.ai_addr.AddressIn6Old.sin6_port := htons(Value);
    FAddrInfo.ai_protocol := Value;
  end else
  begin
    RaiseSocketError(InvalidAddress, InvalidAddressCode);
  end;
end;

function TclIPAddress6.ToString: string;
begin
  Result := '';
  if (FAddrInfo <> nil) then
  begin
    if (AddressFamily = AF_INET) then
    begin
      Result := TclIPAddress4.AddrToStr(FAddrInfo.ai_addr.Address.sin_addr);
    end else
    if (AddressFamily = AF_INET6) then
    begin
      Result := AddrToStr(FAddrInfo.ai_addr.AddressIn6Old.sin6_addr);
    end;
  end;
end;

end.
