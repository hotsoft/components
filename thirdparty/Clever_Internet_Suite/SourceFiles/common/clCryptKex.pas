{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCryptKex;

interface

{$I clVer.inc}

uses
  clUtils, clConfig;

type
  TclKeyExchange = class(TclConfigObject)
  public
    procedure Init; virtual; abstract;
    procedure SetP(const P: TclByteArray); virtual; abstract;
    procedure SetG(const G: TclByteArray); virtual; abstract;
    procedure SetF(const F: TclByteArray); virtual; abstract;
    function GetE: TclByteArray; virtual; abstract;
    function GetK: TclByteArray; virtual; abstract;
  end;

  TclDh = class(TclKeyExchange)
  private
    F_P: TclByteArray;
    F_G: TclByteArray;
    F_E: TclByteArray;
    F_F: TclByteArray;
    F_K: TclByteArray;
    F_X: TclByteArray;

    function CreateKeyExchange(const P, G: TclByteArray): TclByteArray;
    function DecryptKeyExchange(const F, P: TclByteArray): TclByteArray;
  public
    procedure Init; override;
    procedure SetP(const P: TclByteArray); override;
    procedure SetG(const G: TclByteArray); override;
    procedure SetF(const F: TclByteArray); override;
    function GetE: TclByteArray; override;
    function GetK: TclByteArray; override;
  end;

implementation

uses
   clBigInt, clCryptRandom, clCryptUtils;

{ TclDh }

function TclDh.CreateKeyExchange(const P, G: TclByteArray): TclByteArray;
var
  y, m_P, m_G, m_X: Variant;
  secretLen: Integer;
begin
  if (P = nil) or (G = nil) then
  begin
    RaiseCryptError(CryptInvalidArgument, CryptInvalidArgumentCode);
  end;

  if (F_X = nil) then
  begin
    secretLen := Length(P);
    F_X := GenerateRandomData(secretLen);
  end;
  m_X := BigInteger(F_X);

  m_P := BigInteger(P);
  m_G := BigInteger(G);

  y := PowMod(m_G, m_X, m_P);
  Result := BigIntToBytes(y);
end;

function TclDh.DecryptKeyExchange(const F, P: TclByteArray): TclByteArray;
var
  pvr, m_X, m_P, z: Variant;
begin
  pvr := BigInteger(F);
  m_X := BigInteger(F_X);
  m_P := BigInteger(P);

  z := PowMod(pvr, m_X, m_P);
  Result := BigIntToBytes(z);
end;

function TclDh.GetE: TclByteArray;
begin
  if (F_E = nil) then
  begin
    F_E := CreateKeyExchange(F_P, F_G);
  end;
  Result := F_E;
end;

function TclDh.GetK: TclByteArray;
begin
  if (F_K = nil) then
  begin
    F_K := DecryptKeyExchange(F_F, F_P);
  end;
  Result := F_K;
end;

procedure TclDh.Init;
begin
  F_P := nil;
  F_G := nil;
  F_E := nil;
  F_F := nil;
  F_K := nil;
  F_X := nil;
end;

procedure TclDh.SetF(const F: TclByteArray);
begin
  F_F := F;
end;

procedure TclDh.SetG(const G: TclByteArray);
begin
  F_G := G;
end;

procedure TclDh.SetP(const P: TclByteArray);
begin
  F_P := P;
end;

end.
