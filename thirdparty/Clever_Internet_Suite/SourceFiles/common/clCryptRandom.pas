{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCryptRandom;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes,
{$ELSE}
  System.Classes,
{$ENDIF}
  clUtils, clCryptUtils, clConfig, clCryptAPI, clWUtils;

type
  TclRandom = class(TclConfigObject)
  public
    procedure Fill(var ABuffer: TclByteArray; AStart, ALen: Integer); virtual; abstract;
  end;

  TclCryptApiRandom = class(TclRandom)
  private
    FContext: HCRYPTPROV;

    function GenContext: HCRYPTPROV;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Fill(var ABuffer: TclByteArray; AStart, ALen: Integer); override;
  end;

function GenerateRandomData(ASize: Integer): TclByteArray; overload;
function GenerateRandomData(ASize: Integer; const ACSP: string; AProviderType: Integer): TclByteArray; overload;
procedure GenerateRandomData(AData: TclCryptData; ASize: Integer); overload;
procedure GenerateRandomData(AData: TclCryptData; ASize: Integer; const ACSP: string; AProviderType: Integer); overload;

implementation

function GenerateRandomData(ASize: Integer): TclByteArray;
begin
  Result := GenerateRandomData(ASize, '', 0);
end;

function GenerateRandomData(ASize: Integer; const ACSP: string; AProviderType: Integer): TclByteArray;
var
  data: TclCryptData;
begin
  data := TclCryptData.Create(ASize);
  try
    GenerateRandomData(data, ASize, ACSP, AProviderType);
    Result := data.ToBytes();
  finally
    data.Free();
  end;
end;

procedure GenerateRandomData(AData: TclCryptData; ASize: Integer);
begin
  GenerateRandomData(AData, ASize, '', 0);
end;

procedure GenerateRandomData(AData: TclCryptData; ASize: Integer; const ACSP: string; AProviderType: Integer);
var
  context: HCRYPTPROV;
  pCSP: PclChar;
  provType: Integer;
begin
  if (AData.DataSize <> ASize) then
  begin
    AData.Allocate(ASize);
  end;

  if (ACSP <> '') then
  begin
    pCSP := PclChar(GetTclString(ACSP));
    provType := AProviderType;
  end else
  begin
    pCSP := DefaultProvider;
    provType := DefaultProviderType;
  end;

  if not CryptAcquireContext(@context, nil, pCSP, provType, CRYPT_VERIFYCONTEXT) then
  begin
    RaiseCryptError('CryptAcquireContext');
  end;
  try
    if not CryptGenRandom(context, AData.DataSize, AData.Data) then
    begin
      RaiseCryptError('CryptGenRandom');
    end;
  finally
    if (context <> nil) then
    begin
      CryptReleaseContext(context, 0);
    end;
  end;
end;

{ TclCryptApiRandom }

constructor TclCryptApiRandom.Create;
begin
  inherited Create();
  FContext := nil;
end;

destructor TclCryptApiRandom.Destroy;
begin
  if (FContext <> nil) then
  begin
    CryptReleaseContext(FContext, 0);
  end;

  inherited Destroy();
end;

procedure TclCryptApiRandom.Fill(var ABuffer: TclByteArray; AStart, ALen: Integer);
var
  p: Pointer;
begin
  p := Pointer(TclIntPtr(ABuffer) + SizeOf(Byte) * AStart);
  if not CryptGenRandom(GenContext(), ALen, p) then
  begin
    RaiseCryptError('CryptGenRandom');
  end;
end;

function TclCryptApiRandom.GenContext: HCRYPTPROV;
begin
  if (FContext = nil) then
  begin
    if not CryptAcquireContext(@FContext, nil, nil, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT) then //TODO replace all CryptAcquireContext and use the same CSP
    begin
      RaiseCryptError('CryptAcquireContext');
    end;
  end;

  Result := FContext;
end;

end.
