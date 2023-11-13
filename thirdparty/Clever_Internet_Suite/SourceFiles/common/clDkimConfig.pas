{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clDkimConfig;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clConfig;

type
  TclDkimConfig = class(TclConfig)
  public
    constructor Create;
  end;

implementation

uses
  clCryptHash, clCryptSignature, clDkimCanonicalizer;

{ TclDkimConfig }

constructor TclDkimConfig.Create;
begin
  inherited Create();

  SetType('sha1', TclSha1);
  SetType('sha256', TclSha256);
  SetType('rsa-sha1', TclSignatureRsaSha1);
  SetType('rsa-sha256', TclSignatureRsaSha256);
  SetType('simple', TclDkimSimpleCanonicalizer);
  SetType('relaxed', TclDkimRelaxedCanonicalizer);
  SetType('rsa', TclCryptApiRsaKey);
end;

end.
