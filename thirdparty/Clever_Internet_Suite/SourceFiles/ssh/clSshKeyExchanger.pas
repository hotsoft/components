{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSshKeyExchanger;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clConfig, clUtils, clCryptHash, clSshPacket;

type
  TclSshKeyExchanger = class(TclConfigObject)
  private
    FGuessAlgorithms: TStrings;

    procedure SetGuessAlgorithms(const Value: TStrings);
  protected
    FConfig: TclConfig;
    FSha: TclHash;
    FK: TclByteArray;
    FH: TclByteArray;
    FK_S: TclByteArray;
  public
    constructor Create; override;
    destructor Destroy; override;

    class function Guess(const AI_S, AI_C: TclByteArray): TStrings;

    procedure Init(AConfig: TclConfig; const AV_S, AV_C, AI_S, AI_C: TclByteArray; var pp: TclPacket); virtual; abstract;
    function Next(ABuf: TclPacket; var pp: TclPacket): Boolean; virtual; abstract;
    function GetKeyType: string; virtual; abstract;
    function GetState: Integer; virtual; abstract;

    function GetFingerPrint(AHash: TclHash; const AData: TclByteArray): string; overload;
    function GetFingerPrint: string; overload;

    function GetK: TclByteArray;
    function GetH: TclByteArray;
    function GetHash: TclHash;
    function GetHostKey: TclByteArray;
    function GetSignature(const ASignature: TclByteArray): TclByteArray;

    property GuessAlgorithms: TStrings read FGuessAlgorithms write SetGuessAlgorithms;
  end;

const
  PROPOSAL_KEX_ALGS = 0;
  PROPOSAL_SERVER_HOST_KEY_ALGS = 1;
  PROPOSAL_ENC_ALGS_CTOS = 2;
  PROPOSAL_ENC_ALGS_STOC = 3;
  PROPOSAL_MAC_ALGS_CTOS = 4;
  PROPOSAL_MAC_ALGS_STOC = 5;
  PROPOSAL_COMP_ALGS_CTOS = 6;
  PROPOSAL_COMP_ALGS_STOC = 7;
  PROPOSAL_LANG_CTOS = 8;
  PROPOSAL_LANG_STOC = 9;
  PROPOSAL_MAX = 10;

  STATE_END = 0;

implementation

uses
  clTranslator, clSshUtils, clCryptUtils;

{ TclSshKeyExchanger }

constructor TclSshKeyExchanger.Create;
begin
  inherited Create();

  FGuessAlgorithms := TStringList.Create();

  FConfig := nil;
  FSha := nil;
  
  SetLength(FK, 0);
  SetLength(FH, 0);
  SetLength(FK_S, 0);
end;

destructor TclSshKeyExchanger.Destroy;
begin
  FSha.Free();
  FGuessAlgorithms.Free();
  inherited Destroy();
end;

function TclSshKeyExchanger.GetFingerPrint: string;
var
  hash: TclHash;
begin
  hash := TclHash(FConfig.CreateInstance('md5'));
  try
    Result := GetFingerPrint(hash, GetHostKey());
  finally
    hash.Free();
  end;
end;

function TclSshKeyExchanger.GetFingerPrint(AHash: TclHash; const AData: TclByteArray): string;
var
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  AHash.Init();
  AHash.Update(AData, 0, Length(AData));
  buf := AHash.Digest();
  Result := BytesToHex(buf, ':');
end;

function TclSshKeyExchanger.GetH: TclByteArray;
begin
  Result := FH;
end;

function TclSshKeyExchanger.GetHash: TclHash;
begin
  Result := FSha;
end;

function TclSshKeyExchanger.GetHostKey: TclByteArray;
begin
  Result := FK_S;
end;

function TclSshKeyExchanger.GetK: TclByteArray;
begin
  Result := FK;
end;

function TclSshKeyExchanger.GetSignature(const ASignature: TclByteArray): TclByteArray;
var
  i, j: Integer;
begin
{$IFNDEF DELPHI2005}Result := nil;{$ENDIF}
  if (Length(ASignature) < 8) then
  begin
    RaiseCryptError(CryptInvalidArgument, CryptInvalidArgumentCode);
  end;

  if (ASignature[0] = 0) and (ASignature[1] = 0) and (ASignature[2] = 0) then
  begin
    i := 0;
    j := ByteArrayReadDWord(ASignature, i);
    Inc(i, j);
    j := ByteArrayReadDWord(ASignature, i);
    SetLength(Result, j);

    if (Length(ASignature) < i + j) then
    begin
      RaiseCryptError(CryptInvalidArgument, CryptInvalidArgumentCode);
    end;

    System.Move(ASignature[i], Result[0], j);
  end else
  begin
    Result := ASignature;
  end;
end;

class function TclSshKeyExchanger.Guess(const AI_S, AI_C: TclByteArray): TStrings;
label
  _BREAK;
var
  sb, cb: TclPacket;
  sp, cp: TclByteArray;
  i, j, k, l, m: Integer;
  algorithm: string;
begin
{$IFNDEF DELPHI2005}sp := nil; cp := nil;{$ENDIF}
  Result := TStringList.Create();
  try
    sb := nil;
    cb := nil;
    try
      sb := TclPacket.Create(AI_S);
      sb.SetOffSet(17);

      cb := TclPacket.Create(AI_C);
      cb.SetOffSet(17);

      for i := 0 to PROPOSAL_MAX - 1 do
      begin
        Result.Add('');
        
        sp := sb.GetString();  // server proposal
        cp := cb.GetString();  // client proposal

        j := 0;
        k := 0;

        while (j < Length(cp)) do
        begin
          while (j < Length(cp)) and (cp[j] <> $2c) do Inc(j); // ','

          if (k = j) then
          begin
            Result.Clear();
            Exit;
          end;

          algorithm := TclTranslator.GetString(cp, k, j - k);
          l := 0;
          m := 0;
          while (l < Length(sp)) do
          begin
            while (l < Length(sp)) and (sp[l] <> $2c) do Inc(l); // ','

            if (m = l) then
            begin
              Result.Clear();
              Exit;
            end;

            if SameText(algorithm, TclTranslator.GetString(sp, m, l - m)) then
            begin
              guess[i] := algorithm;
              goto _BREAK;
            end;
            Inc(l);
            m := l;
          end;
          Inc(j);
          k := j;
        end;

_BREAK:
        if (j = 0) then
        begin
          guess[i] := '';
        end;
      end;
    finally
      cb.Free();
      sb.Free();
    end;
  except
    Result.Free();
    raise;
  end;
end;

procedure TclSshKeyExchanger.SetGuessAlgorithms(const Value: TStrings);
begin
  FGuessAlgorithms.Assign(Value);
end;

end.
