{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSshDHG1;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clUtils, clSshKeyExchanger, clSshPacket, clCryptKex, clConfig;

type
  TclDhg1 = class(TclSshKeyExchanger)
  public
    FType: Integer;
    FState: Integer;

    FDh: TclKeyExchange;

    FV_S: TclByteArray;
    FV_C: TclByteArray;
    FI_S: TclByteArray;
    FI_C: TclByteArray;
    FE: TclByteArray;

    FPacket: TclPacket;
  protected
    function GetP: TclByteArray; virtual;
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure Init(AConfig: TclConfig; const AV_S, AV_C, AI_S, AI_C: TclByteArray; var pp: TclPacket); override;
    function Next(APacket: TclPacket; var pp: TclPacket): Boolean; override;
    function GetKeyType: string; override;
    function GetState: Integer; override;
  end;

  TclDhg14 = class(TclDhg1)
  protected
    function GetP: TclByteArray; override;
  end;

implementation

uses
  clTranslator, clCryptHash, clCryptSignature, clSshUtils;

const
  cP128: array[0..128] of Byte = (
    $00,
    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
    $C9,$0F,$DA,$A2,$21,$68,$C2,$34,
    $C4,$C6,$62,$8B,$80,$DC,$1C,$D1,
    $29,$02,$4E,$08,$8A,$67,$CC,$74,
    $02,$0B,$BE,$A6,$3B,$13,$9B,$22,
    $51,$4A,$08,$79,$8E,$34,$04,$DD,
    $EF,$95,$19,$B3,$CD,$3A,$43,$1B,
    $30,$2B,$0A,$6D,$F2,$5F,$14,$37,
    $4F,$E1,$35,$6D,$6D,$51,$C2,$45,
    $E4,$85,$B5,$76,$62,$5E,$7E,$C6,
    $F4,$4C,$42,$E9,$A6,$37,$ED,$6B,
    $0B,$FF,$5C,$B6,$F4,$06,$B7,$ED,
    $EE,$38,$6B,$FB,$5A,$89,$9F,$A5,
    $AE,$9F,$24,$11,$7C,$4B,$1F,$E6,
    $49,$28,$66,$51,$EC,$E6,$53,$81,
    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  );

  cP256: array[0..256] of Byte = (
    $00,
    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
    $C9,$0F,$DA,$A2,$21,$68,$C2,$34,
    $C4,$C6,$62,$8B,$80,$DC,$1C,$D1,
    $29,$02,$4E,$08,$8A,$67,$CC,$74,
    $02,$0B,$BE,$A6,$3B,$13,$9B,$22,
    $51,$4A,$08,$79,$8E,$34,$04,$DD,
    $EF,$95,$19,$B3,$CD,$3A,$43,$1B,
    $30,$2B,$0A,$6D,$F2,$5F,$14,$37,
    $4F,$E1,$35,$6D,$6D,$51,$C2,$45,
    $E4,$85,$B5,$76,$62,$5E,$7E,$C6,
    $F4,$4C,$42,$E9,$A6,$37,$ED,$6B,
    $0B,$FF,$5C,$B6,$F4,$06,$B7,$ED,
    $EE,$38,$6B,$FB,$5A,$89,$9F,$A5,
    $AE,$9F,$24,$11,$7C,$4B,$1F,$E6,
    $49,$28,$66,$51,$EC,$E4,$5B,$3D,
    $C2,$00,$7C,$B8,$A1,$63,$BF,$05,
    $98,$DA,$48,$36,$1C,$55,$D3,$9A,
    $69,$16,$3F,$A8,$FD,$24,$CF,$5F,
    $83,$65,$5D,$23,$DC,$A3,$AD,$96,
    $1C,$62,$F3,$56,$20,$85,$52,$BB,
    $9E,$D5,$29,$07,$70,$96,$96,$6D,
    $67,$0C,$35,$4E,$4A,$BC,$98,$04,
    $F1,$74,$6C,$08,$CA,$18,$21,$7C,
    $32,$90,$5E,$46,$2E,$36,$CE,$3B,
    $E3,$9E,$77,$2C,$18,$0E,$86,$03,
    $9B,$27,$83,$A2,$EC,$07,$A2,$8F,
    $B5,$C5,$5D,$F0,$6F,$4C,$52,$C9,
    $DE,$2B,$CB,$F6,$95,$58,$17,$18,
    $39,$95,$49,$7C,$EA,$95,$6A,$E5,
    $15,$D2,$26,$18,$98,$FA,$05,$10,
    $15,$72,$8E,$5A,$8A,$AC,$AA,$68,
    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
  );

var
  StaticG: TclByteArray;
  StaticP128: TclByteArray;
  StaticP256: TclByteArray;

procedure InitStaticMembers;
begin
  SetLength(StaticG, 1);
  StaticG[0] := 2;

  SetLength(StaticP128, Length(cP128));
  System.Move(cP128[0], StaticP128[0], Length(StaticP128));

  SetLength(StaticP256, Length(cP256));
  System.Move(cP256[0], StaticP256[0], Length(StaticP256));
end;

{ TclDhg1 }

constructor TclDhg1.Create;
begin
  inherited Create();

  FDh := nil;
  FPacket := nil;
end;

destructor TclDhg1.Destroy;
begin
  FDh.Free();
  FPacket.Free();

  inherited Destroy();
end;

function TclDhg1.GetKeyType: string;
begin
  if (FType = SSH_DSS) then
  begin
    Result := 'DSA';
  end else
  begin
    Result := 'RSA';
  end;
end;

function TclDhg1.GetP: TclByteArray;
begin
  Result := StaticP128;
end;

function TclDhg1.GetState: Integer;
begin
  Result := FState;
end;

procedure TclDhg1.Init(AConfig: TclConfig; const AV_S, AV_C, AI_S, AI_C: TclByteArray; var pp: TclPacket);
begin
  FConfig := AConfig;
  FV_S := AV_S;
  FV_C := AV_C;
  FI_S := AI_S;
  FI_C := AI_C;

  FreeAndNil(FSha);
  FSha := TclHash(FConfig.CreateInstance('sha1'));
  FSha.Init();

  FreeAndNil(FPacket);
  FPacket := TclPacket.Create();

  FreeAndNil(FDh);
  FDh := TclKeyExchange(FConfig.CreateInstance('dh'));
  FDh.Init();

  FDh.SetP(GetP());
  FDh.SetG(StaticG);

  FE := FDh.GetE();

  FPacket.Reset();
  FPacket.PutByte(SSH_MSG_KEXDH_INIT);
  FPacket.PutMPInt(FE);

  FState := SSH_MSG_KEXDH_REPLY;
  pp := FPacket;
end;

function TclDhg1.Next(APacket: TclPacket; var pp: TclPacket): Boolean;
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
    SSH_MSG_KEXDH_REPLY:
      begin
        APacket.GetInt();
        APacket.GetByte();
        j := APacket.GetByte();
        if (j <> SSH_MSG_KEXDH_REPLY) then
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

            sigRsa := TclSignatureRSA(FConfig.CreateInstance('ssh-rsa'));//SHA1
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

{ TclDhg14 }

function TclDhg14.GetP: TclByteArray;
begin
  Result := StaticP256;
end;

initialization
  InitStaticMembers();

finalization

end.
