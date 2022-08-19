{
  Clever Internet Suite
  Copyright (C) 2017 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCryptPemEncryptor;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes,
{$ELSE}
  System.Classes,
{$ENDIF}
  clUtils, clConfig, clCryptDataHeader;

type
  TclRsaKeyPemEncryptor = class
  private
    FConfig: TclConfig;
    function GetDecryptKey(AKeySize: Integer; const AIV: TclByteArray; const APassPhrase: string): TclByteArray;
  public
    constructor Create(AConfig: TclConfig);
    function Decrypt(APemHeader: TclCryptDataHeader; const AKey: TclByteArray; const APassPhrase: string): TclByteArray;
  end;

implementation

uses
  clTranslator, clCryptUtils, clCryptHash, clCryptCipher;

{ TclRsaKeyPemEncryptor }

constructor TclRsaKeyPemEncryptor.Create(AConfig: TclConfig);
begin
  inherited Create();
  FConfig := AConfig;
end;

function TclRsaKeyPemEncryptor.GetDecryptKey(AKeySize: Integer; const AIV: TclByteArray; const APassPhrase: string): TclByteArray;
var
  hash: TclHash;
  passBytes, hn, tmp: TclByteArray;
  ind, hSize, hnSize: Integer;
begin
  hash := TclHash(FConfig.CreateInstance('md5'));
  try
    hash.Init();

    SetLength(Result, AKeySize);

    passBytes := TclTranslator.GetBytes(APassPhrase);

    hSize := hash.GetBlockSize();

    hnSize := Length(Result) div hSize * hSize;
    if (Length(Result) mod hSize) <> 0 then
    begin
      hnSize := hnSize + hSize;
    end;

    SetLength(hn, hnSize);

    tmp := nil;
    ind := 0;

    while (ind + hSize <= hnSize) do
    begin
      if (tmp <> nil) then
      begin
        hash.Update(tmp, 0, Length(tmp));
      end;

      hash.Update(passBytes, 0, Length(passBytes));
      hash.Update(AIV, 0, Length(AIV));
      tmp := hash.Digest();

      System.Move(tmp[0], hn[ind], Length(tmp));
      ind := ind + Length(tmp);
    end;

    System.Move(hn[0], Result[0], Length(Result));
  finally
    hash.Free();
  end;
end;

function TclRsaKeyPemEncryptor.Decrypt(APemHeader: TclCryptDataHeader;
  const AKey: TclByteArray; const APassPhrase: string): TclByteArray;
var
  params: TStrings;
  cipher: TclCipher;
  iv, key: TclByteArray;
begin
{$IFNDEF DELPHI2005}iv := nil; key := nil; Result := nil;{$ENDIF}

  if (APemHeader.ProcType <> '4,ENCRYPTED') then
  begin
    Result := AKey;
    Exit;
  end;

  if (System.Pos('DES-CBC', APemHeader.DekInfo) = 0) and (System.Pos('DES-EDE3-CBC', APemHeader.DekInfo) = 0) then
  begin
    RaiseCryptError(UnknownKeyFormat, UnknownKeyFormatCode);
  end;

  params := nil;
  cipher := nil;
  try
    params := TStringList.Create();

    SplitText(APemHeader.DekInfo, params, ',');

    if (params.Count <> 2) then
    begin
      RaiseCryptError(CryptInvalidArgument, CryptInvalidArgumentCode);
    end;

    cipher := TclCipher(FConfig.CreateInstance('3des-cbc'));

    iv := HexToBytes(params[1]);
    if (Length(iv) <> cipher.GetIVSize()) then
    begin
      RaiseCryptError(UnknownKeyFormat, UnknownKeyFormatCode);
    end;

    key := GetDecryptKey(cipher.GetBlockSize(), iv, APassPhrase);

    cipher.Init(cmDecrypt, key, iv);

    Result := System.Copy(AKey, 0, Length(AKey));
    cipher.Update(Result, 0, Length(Result));

    if (Length(Result) = 0) or (Result[0] <> $30) then
    begin
      RaiseCryptError(UnknownKeyFormat, UnknownKeyFormatCode);
    end;
  finally
    cipher.Free();
    params.Free();
  end;
end;

end.
