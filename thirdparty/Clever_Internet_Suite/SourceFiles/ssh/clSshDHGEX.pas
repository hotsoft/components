{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSshDHGEX;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clUtils, clSshKeyExchanger, clCryptKex, clSshPacket, clConfig;

type
  TclDhgEx = class(TclSshKeyExchanger)
  private
    FType: Integer;
    FState: Integer;
    FDh: TclKeyExchange;

    FV_S: TclByteArray;
    FV_C: TclByteArray;
    FI_S: TclByteArray;
    FI_C: TclByteArray;

    FPacket: TclPacket;

    FP: TclByteArray;
    FG: TclByteArray;
    FE: TclByteArray;
  protected
    function GetHashAlgorithm: string; virtual; abstract;
    function GetSignatureAlgorithm: string; virtual; abstract;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Init(AConfig: TclConfig; const AV_S, AV_C, AI_S, AI_C: TclByteArray; var pp: TclPacket); override;
    function Next(APacket: TclPacket; var pp: TclPacket): Boolean; override;
    function GetKeyType: string; override;
    function GetState: Integer; override;
  end;

  TclDhgExSha1 = class(TclDhgEx)
  protected
    function GetHashAlgorithm: string; override;
    function GetSignatureAlgorithm: string; override;
  end;

  TclDhgExSha256 = class(TclDhgEx)
  protected
    function GetHashAlgorithm: string; override;
    function GetSignatureAlgorithm: string; override;
  end;

implementation

uses
  clCryptHash, clTranslator, clCryptSignature, clSshUtils;

const
  cMin = 1024;
  cPreferred = 1024;
  cMax = 1024;

{ TclDhgEx }

constructor TclDhgEx.Create;
begin
  inherited Create();

  FDh := nil;
  FPacket := nil;
end;

destructor TclDhgEx.Destroy;
begin
  FDh.Free();
  FPacket.Free();

  inherited Destroy();
end;

function TclDhgEx.GetKeyType: string;
begin
  if (FType = SSH_DSS) then
  begin
    Result := 'DSA';
  end else
  begin
    Result := 'RSA';
  end;
end;

function TclDhgEx.GetState: Integer;
begin
  Result := FState;
end;

procedure TclDhgEx.Init(AConfig: TclConfig; const AV_S, AV_C, AI_S, AI_C: TclByteArray; var pp: TclPacket);
begin
  FConfig := AConfig;
  FV_S := AV_S;
  FV_C := AV_C;
  FI_S := AI_S;
  FI_C := AI_C;

  FreeAndNil(FSha);
  FSha := TclHash(FConfig.CreateInstance(GetHashAlgorithm()));
  FSha.Init();

  FreeAndNil(FPacket);
  FPacket := TclPacket.Create();

  FreeAndNil(FDh);
  FDh := TclKeyExchange(FConfig.CreateInstance('dh'));
  FDh.Init();

  FPacket.Reset();
  FPacket.PutByte($22); //TODO make it const
  FPacket.PutInt(CMin);
  FPacket.PutInt(CPreferred);
  FPacket.PutInt(cMax);

  FState := SSH_MSG_KEX_DH_GEX_GROUP;
  pp := FPacket;
end;

function TclDhgEx.Next(APacket: TclPacket; var pp: TclPacket): Boolean;
var
  i, j: Integer;
  f, sig_of_H, foo, tmp, ee, n: TclByteArray;
  alg: string;
  sigRsa: TclSignatureRSA;
  keyRsa: TclRsaKey;
begin
{$IFNDEF DELPHI2005}f := nil; sig_of_H := nil; foo := nil; tmp := nil; ee := nil; n := nil;{$ENDIF}
  pp := nil;
  Result := False;

  case (FState) of
    SSH_MSG_KEX_DH_GEX_GROUP:
      begin
        APacket.GetInt();
        APacket.GetByte();
        j := APacket.GetByte();
        if (j <> SSH_MSG_KEX_DH_GEX_GROUP) then
        begin
          Exit;
        end;

        FP := APacket.GetMPInt();
        FG := APacket.GetMPInt();
        FDh.SetP(FP);
        FDh.SetG(FG);

        FE := FDh.GetE();

        FPacket.Reset();
        FPacket.PutByte(SSH_MSG_KEX_DH_GEX_INIT);
        FPacket.PutMPInt(FE);
        pp := FPacket;

        FState := SSH_MSG_KEX_DH_GEX_REPLY;
        Result := True;
      end;
    SSH_MSG_KEX_DH_GEX_REPLY:
      begin
        APacket.GetInt();
        APacket.GetByte();
        j := APacket.GetByte();
        if (j <> SSH_MSG_KEX_DH_GEX_REPLY) then
        begin
          Exit;
        end;

        FK_S := APacket.GetString();

        f := APacket.GetMPInt();
        sig_of_H := GetSignature(APacket.GetString());

        FDh.SetF(f);
        FK := FDh.GetK();

        FPacket.Init();
        FPacket.PutString(FV_C);
        FPacket.PutString(FV_S);
        FPacket.PutString(FI_C);
        FPacket.PutString(FI_S);
        FPacket.PutString(FK_S);
        FPacket.PutInt(cMin);
        FPacket.PutInt(cPreferred);
        FPacket.PutInt(cMax);
        FPacket.PutMPInt(FP);
        FPacket.PutMPInt(FG);
        FPacket.PutMPInt(FE);
        FPacket.PutMPInt(f);
        FPacket.PutMPInt(FK);

        SetLength(foo, FPacket.GetLength());
        FPacket.GetByte(foo);
        FSha.Update(foo, 0, Length(foo));

        FH := FSha.Digest();

        i := 0;
        j := ByteArrayReadDWord(FK_S, i);
        alg := TclTranslator.GetString(FK_S, i, j);
        Inc(i, j);

					
        if (alg = 'ssh-rsa') then
        begin
          FType := SSH_RSA;

          j := ByteArrayReadDWord(FK_S, i);
          SetLength(tmp, j);
          System.Move(FK_S[i], tmp[0], j);
          Inc(i, j);
          ee := tmp;
          
          j := ByteArrayReadDWord(FK_S, i);
          SetLength(tmp, j);
          System.Move(FK_S[i], tmp[0], j);
          Inc(i, j);
          n := tmp;

          keyRsa := nil;
          sigRsa := nil;
          try
            keyRsa := TclRsaKey(FConfig.CreateInstance('rsa-key'));
            keyRsa.Init();

            keyRsa.SetPublicKeyParams(n, ee);

            sigRsa := TclSignatureRSA(FConfig.CreateInstance(GetSignatureAlgorithm()));
            sigRsa.Init();

            sigRsa.SetPublicKey(keyRsa);

            sigRsa.Update(FH, 0, Length(FH));

            sigRsa.Verify(sig_of_H);

            Result := True;
          finally
            sigRsa.Free();
            keyRsa.Free();
          end;
        end else
        begin
          raise EclSshError.Create(AlgorithmNegotiationError, AlgorithmNegotiationErrorCode);
        end;
        FState := STATE_END;
      end;
  end;
end;

{ TclDhgExSha1 }

function TclDhgExSha1.GetHashAlgorithm: string;
begin
  Result := 'sha1';
end;

function TclDhgExSha1.GetSignatureAlgorithm: string;
begin
  Result := 'ssh-rsa';
end;

{ TclDhgExSha256 }

function TclDhgExSha256.GetHashAlgorithm: string;
begin
  Result := 'sha2-256';
end;

function TclDhgExSha256.GetSignatureAlgorithm: string;
begin
  Result := 'rsa-sha2-256';
end;

end.
