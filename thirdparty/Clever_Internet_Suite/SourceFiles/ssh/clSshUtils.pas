{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSshUtils;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clUtils;

type
  EclSshError = class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean = False);
    property ErrorCode: Integer read FErrorCode;
  end;

resourcestring
  UnknownError = 'SSH error occurred';
  InvalidPacketSize = 'Invalid packet size';
  MacError = 'MAC Error';
  DisconnectOccurred = 'Disconnect occurred';
  InvalidVersion = 'Invalid server''s version string';
  InvalidProtocol = 'Invalid protocol';
  InvalidKexProtocol = 'Invalid kex protocol';
  InvalidNewKeysProtocol = 'Invalid newkyes protocol';
  ChannelOpenError = 'Unable to open channel';
  RequestSubsystemError = 'Unable to request channel subsystem';
  AlgorithmNegotiationError = 'Algorithm negotiation fail';
  KexNextError = 'Verify: kex.next is False';
  AuthMethodError = 'Auth method is not supported';
  UserAuthError = 'User authentication failed';
  HostKeyRejected = 'HostKey rejected';

const
  UnknownErrorCode = -1;
  InvalidPacketSizeCode = -2;
  MacErrorCode = -3;
  InvalidVersionCode = -4;
  RequestSubsystemErrorCode = -5;
  AlgorithmNegotiationErrorCode = -6;
  KexNextErrorCode = -7;
  AuthMethodErrorCode = -8;
  UserAuthErrorCode = -9;
  HostKeyRejectedCode = -10;

  DefaultSshAgent = 'Clever_Internet_Suite';

  SSH_MSG_DISCONNECT = 1;
  SSH_MSG_IGNORE = 2;
  SSH_MSG_UNIMPLEMENTED = 3;
  SSH_MSG_DEBUG = 4;
  SSH_MSG_SERVICE_REQUEST = 5;
  SSH_MSG_SERVICE_ACCEPT = 6;
  SSH_MSG_KEXINIT = 20;
  SSH_MSG_NEWKEYS = 21;
  SSH_MSG_KEXDH_INIT = 30;
  SSH_MSG_KEXDH_REPLY = 31;
  SSH_MSG_USERAUTH_REQUEST = 50;
  SSH_MSG_USERAUTH_FAILURE = 51;
  SSH_MSG_USERAUTH_SUCCESS = 52;
  SSH_MSG_USERAUTH_BANNER = 53;
  SSH_MSG_USERAUTH_INFO_REQUEST = 60;
  SSH_MSG_USERAUTH_INFO_RESPONSE = 61;
  SSH_MSG_USERAUTH_PK_OK = 60;
  SSH_MSG_GLOBAL_REQUEST = 80;
  SSH_MSG_REQUEST_SUCCESS = 81;
  SSH_MSG_REQUEST_FAILURE = 82;
  SSH_MSG_CHANNEL_OPEN = 90;
  SSH_MSG_CHANNEL_OPEN_CONFIRMATION = 91;
  SSH_MSG_CHANNEL_OPEN_FAILURE = 92;
  SSH_MSG_CHANNEL_WINDOW_ADJUST = 93;
  SSH_MSG_CHANNEL_DATA = 94;
  SSH_MSG_CHANNEL_EXTENDED_DATA = 95;
  SSH_MSG_CHANNEL_EOF = 96;
  SSH_MSG_CHANNEL_CLOSE = 97;
  SSH_MSG_CHANNEL_REQUEST = 98;
  SSH_MSG_CHANNEL_SUCCESS = 99;
  SSH_MSG_CHANNEL_FAILURE = 100;

  SSH_MSG_KEX_DH_GEX_GROUP = 31;
  SSH_MSG_KEX_DH_GEX_INIT = 32;
  SSH_MSG_KEX_DH_GEX_REPLY = 33;

  SSH_RSA = 0;
  SSH_DSS = 1;

implementation

{ EclSshError }

constructor EclSshError.Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorMsg);
  FErrorCode := AErrorCode;
end;

end.
