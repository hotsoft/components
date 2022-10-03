{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSshConfig;

interface

{$I ..\common\clVer.inc}

uses
  clConfig;

type
  TclSshConfig = class(TclConfig)
  public
    constructor Create;
  end;

implementation

uses
  clCryptRandom, clCryptMac, clCryptHash, clCryptSignature, clCryptCipher, clSshDHG1, clSshDHGEX, clCryptKex, clSshAuth;

{ TclSshConfig }

constructor TclSshConfig.Create;
begin
  inherited Create();

  SetConfig('kex', 'diffie-hellman-group-exchange-sha256,diffie-hellman-group14-sha1,' +
    'diffie-hellman-group-exchange-sha1,diffie-hellman-group1-sha1');

  SetConfig('server.hostkey', 'rsa-sha2-256,ssh-rsa');


  SetConfig('cipher.s2c', 'aes256-ctr,aes192-ctr,aes128-ctr,aes256-cbc,aes192-cbc,aes128-cbc,3des-cbc');
  SetConfig('cipher.c2s', 'aes256-ctr,aes192-ctr,aes128-ctr,aes256-cbc,aes192-cbc,aes128-cbc,3des-cbc');

  SetConfig('mac.s2c', 'hmac-sha2-256,hmac-sha1,hmac-md5');
  SetConfig('mac.c2s', 'hmac-sha2-256,hmac-sha1,hmac-md5');

  SetConfig('compression.s2c', 'none');
  SetConfig('compression.c2s', 'none');
  SetConfig('lang.s2c', '');
  SetConfig('lang.c2s', '');
  SetConfig('auth.method', 'publickey,password');

  SetType('diffie-hellman-group-exchange-sha1', TclDhgExSha1);
  SetType('diffie-hellman-group-exchange-sha256', TclDhgExSha256);
  SetType('diffie-hellman-group1-sha1', TclDhg1);
  SetType('diffie-hellman-group14-sha1', TclDhg14);

  SetType('dh', TclDh);

  SetType('3des-cbc', TclTripleDesCbc);
  SetType('aes128-cbc', TclAes128Cbc);
  SetType('aes192-cbc', TclAes192Cbc);
  SetType('aes256-cbc', TclAes256Cbc);
  SetType('aes128-ctr', TclAes128Ctr);
  SetType('aes192-ctr', TclAes192Ctr);
  SetType('aes256-ctr', TclAes256Ctr);

  SetType('hmac-md5', TclHmacMd5);
  SetType('hmac-sha1', TclHmacSha1);
  SetType('hmac-sha2-256', TclHmacSha256);

  SetType('md5', TclMd5);
  SetType('sha1', TclSha1);
  SetType('sha2-256', TclSha256);

  SetType('ssh-rsa', TclSignatureRsaSha1);
  SetType('rsa-sha2-256', TclSignatureRsaSha256);

  SetType('rsa-key', TclCryptApiRsaKey);
  SetType('random', TclCryptApiRandom);

  SetType('password', TclUserAuthPassword);
  SetType('publickey', TclUserAuthPublicKeySha1);
end;

end.
