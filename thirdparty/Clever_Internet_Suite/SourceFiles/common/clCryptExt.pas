{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clCryptExt;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows, SyncObjs,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows, System.SyncObjs,
{$ENDIF}
  clUtils;

type
  TclRsaDecryptKeyExchange = function(certificateThumbprint: LPWSTR;
      storeName: LPWSTR; storeLocation: Integer;
			encrypted: TclByteArray; encryptedLen: Integer;
      decrypted: TclByteArray; decryptedLen: Integer;
      useOAEP: Boolean): Integer; stdcall;

  TclRsaEncryptKeyExchange = function(certificateThumbprint: LPWSTR;
      storeName: LPWSTR; storeLocation: Integer;
			key: TclByteArray; keyLen: Integer;
      encrypted: TclByteArray; encryptedLen: Integer;
      useOAEP: Boolean): Integer; stdcall;

function RsaDecryptKeyExchange(certificateThumbprint: LPWSTR;
      storeName: LPWSTR; storeLocation: Integer;
			encrypted: TclByteArray; encryptedLen: Integer;
      decrypted: TclByteArray; decryptedLen: Integer;
      useOAEP: Boolean): Integer; stdcall;

function RsaEncryptKeyExchange(certificateThumbprint: LPWSTR;
      storeName: LPWSTR; storeLocation: Integer;
      key: TclByteArray; keyLen: Integer;
			encrypted: TclByteArray; encryptedLen: Integer;
      useOAEP: Boolean): Integer; stdcall;

var
  CRYPTEXT: string = 'clcryptext.dll';

implementation

var
  InitAccessor: TCriticalSection = nil;
  CryptExtModule: HModule = 0;
  clRsaDecryptKeyExchange: TclRsaDecryptKeyExchange;
  clRsaEncryptKeyExchange: TclRsaEncryptKeyExchange;

procedure InitCryptExtLibrary;
var
  Buffer: array[0..255] of Char;
begin
  InitAccessor.Enter();
  try
    if (CryptExtModule = 0) then
    begin
      CryptExtModule := LoadLibrary(PChar(CRYPTEXT));
      if (CryptExtModule <= HINSTANCE_ERROR) then
      begin
        ZeroMemory(@Buffer, SizeOf(Buffer));
        FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, GetLastError(), 0, Buffer, SizeOf(Buffer), nil);
        CryptExtModule := 0;
        raise Exception.CreateFmt('%s (%s)', [Buffer, CRYPTEXT]);
      end;
    end;
  finally
    InitAccessor.Leave();
  end;
end;

procedure FreeCryptExtLibrary;
begin
  if (CryptExtModule > HINSTANCE_ERROR) then
  begin
    FreeLibrary(CryptExtModule);
    CryptExtModule := 0;
  end;
end;

function CryptGetProcAddress(hModule: HMODULE; lpProcName: LPCSTR; Silent: Boolean): FARPROC; stdcall;
var
  Buffer: array[0..255] of Char;
begin
  Result := GetProcAddress(hModule, lpProcName);
  if (not Assigned(Result)) and (not Silent) then
  begin
    ZeroMemory(@Buffer, SizeOf(Buffer));
    FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, GetLastError(), 0, Buffer, SizeOf(Buffer), nil);
    raise Exception.Create(Buffer);
  end;
end;


function RsaDecryptKeyExchange(certificateThumbprint: LPWSTR;
      storeName: LPWSTR; storeLocation: Integer;
      encrypted: TclByteArray; encryptedLen: Integer;
      decrypted: TclByteArray; decryptedLen: Integer;
      useOAEP: Boolean): Integer; stdcall;
begin
  InitCryptExtLibrary();

  if not Assigned(clRsaDecryptKeyExchange) then
    @clRsaDecryptKeyExchange := CryptGetProcAddress(CryptExtModule, 'RsaDecryptKeyExchange', False);

  Result := clRsaDecryptKeyExchange(certificateThumbprint, storeName, storeLocation, encrypted, encryptedLen, decrypted, decryptedLen, useOAEP);
end;

function RsaEncryptKeyExchange(certificateThumbprint: LPWSTR;
      storeName: LPWSTR; storeLocation: Integer;
      key: TclByteArray; keyLen: Integer;
			encrypted: TclByteArray; encryptedLen: Integer;
      useOAEP: Boolean): Integer; stdcall;
begin
  InitCryptExtLibrary();

  if not Assigned(clRsaEncryptKeyExchange) then
    @clRsaEncryptKeyExchange := CryptGetProcAddress(CryptExtModule, 'RsaEncryptKeyExchange', False);

  Result := clRsaEncryptKeyExchange(certificateThumbprint, storeName, storeLocation, key, keyLen, encrypted, encryptedLen, useOAEP);
end;

initialization
  InitAccessor := TCriticalSection.Create();

finalization
  FreeCryptExtLibrary();
  InitAccessor.Free();

end.
