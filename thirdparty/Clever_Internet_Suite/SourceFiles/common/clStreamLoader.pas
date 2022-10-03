{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clStreamLoader;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, HTTPUtil,
{$ELSE}
  System.Classes, System.SysUtils, Soap.HTTPUtil,
{$ENDIF}
  clHttp;

type
  TclStreamLoader = class(TInterfacedObject, IStreamLoader)
  private
    FOwnHttp: TclHttp;
    FHttp: TclHttp;

    function GetHttp: TclHttp;
    function IsHTTP(const Name: string): Boolean;
    procedure LoadFromURL(const URL: string; Stream: TStream);
  public
    constructor Create; overload;
    constructor Create(AHttp: TclHttp); overload;
    destructor Destroy; override;

{$IFDEF DELPHIXE3}
    procedure Load(const WSDLFileName: string; Stream: TMemoryStream);
{$ELSE}
    procedure Load(const WSDLFileName: WideString; Stream: TMemoryStream);
{$ENDIF}

    function  GetProxy: string;
    procedure SetProxy(const AProxy: string);
    function  GetUserName: string;
    procedure SetUserName(const AUserName: string);
    function  GetPassword: string;
    procedure SetPassword(const APassword: string);
    function  GetTimeout: Integer;
    procedure SetTimeout(ATimeOut: Integer);
  end;

implementation

{ TclStreamLoader }

constructor TclStreamLoader.Create;
begin
  inherited Create();
end;

constructor TclStreamLoader.Create(AHttp: TclHttp);
begin
  inherited Create();

  FHttp := AHttp;
end;

destructor TclStreamLoader.Destroy;
begin
  FOwnHttp.Free();

  inherited Destroy();
end;

function TclStreamLoader.GetHttp: TclHttp;
begin
  Result := FHttp;
  if (Result = nil) then
  begin
    if (FOwnHttp = nil) then
    begin
      FOwnHttp := TclHttp.Create(nil);
    end;
    Result := FOwnHttp;
  end;
end;

function TclStreamLoader.GetPassword: string;
begin
  Result := GetHttp().Password;
end;

function TclStreamLoader.GetProxy: string;
begin
  Result := GetHttp().ProxySettings.Server;
end;

function TclStreamLoader.GetTimeout: Integer;
begin
  Result := GetHttp().TimeOut;
end;

function TclStreamLoader.GetUserName: string;
begin
  Result := GetHttp().UserName;
end;

function TclStreamLoader.IsHTTP(const Name: string): Boolean;
const
  cHTTPPrefix = 'http://';
  cHTTPsPrefix= 'https://';
var
  s: string;
begin
  s := LowerCase(Trim(Name));
  Result := (System.Pos(cHTTPPrefix, s) = 1) or (System.Pos(cHTTPsPrefix, s) = 1);
end;

{$IFDEF DELPHIXE3}
procedure TclStreamLoader.Load(const WSDLFileName: string; Stream: TMemoryStream);
{$ELSE}
procedure TclStreamLoader.Load(const WSDLFileName: WideString; Stream: TMemoryStream);
{$ENDIF}
var
  s: string;
begin
  s := Trim(string(WSDLFileName));

  if IsHTTP(s) then
  begin
    LoadFromURL(s, Stream)
  end else
  begin
    Stream.LoadFromFile(s);
  end;
end;

procedure TclStreamLoader.LoadFromURL(const URL: string; Stream: TStream);
begin
  GetHttp().Get(URL, Stream);
end;

procedure TclStreamLoader.SetPassword(const APassword: string);
begin
  GetHttp().Password := APassword;
end;

procedure TclStreamLoader.SetProxy(const AProxy: string);
begin
  GetHttp().ProxySettings.Server := AProxy;
end;

procedure TclStreamLoader.SetTimeout(ATimeOut: Integer);
begin
  GetHttp().TimeOut := ATimeOut;
end;

procedure TclStreamLoader.SetUserName(const AUserName: string);
begin
  GetHttp().UserName := AUserName;
end;

end.
