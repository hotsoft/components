{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSshSocket;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clSocket, clUtils, clSshPacket, clSshKeyExchanger, clConfig, clSshConfig,
  clCryptCipher, clCryptMac, clSshCompression, clSshAuth, clCryptHash, clCryptRandom, clSshUserIdentity;

type
	TclSshState = (sshVersionExchange, sshKeyExchangeInit, sshKeyGuess, sshKeyExchange, sshNewKeys,
    sshAuthenticateInit, sshAuthenticate, sshChannelOpen, sshChannelRequest, sshData, sshDisconnect,
    sshChannelClose);

  TclVerifySshPeerEvent = procedure(Sender: TObject; const AHost, AKeyType, AFingerPrint, AHostKey: string;
		var AVerified: Boolean) of object;

  //TODO max batchsize checking
  TclSshNetworkStream = class(TclNetworkStream)
  private
    FSshAction: TclNetworkStreamAction;
    FIsAdjustLocalWinSize: Boolean;
    FIsAdjustRemoteWinSize: Boolean;
    FReadData: TStream;
    FWriteData: TStream;
    FWriteSize: Integer;
    FWritePacketLength: Integer;
    FReadPacketLength: Integer;
    FReadDataFilled: Boolean;
    FState: TclSshState;
    FPacket: TclPacket;
    FWritePacket: TclPacket;
    FSshAgent: string;
    FKex: TclSshKeyExchanger;
    FSeqi: Integer;
    FSeqo: Integer;
    FConfig: TclConfig;
    FSessionId: TclByteArray;
    FIVc2s: TclByteArray;
    FIVs2c: TclByteArray;
    FEc2s: TclByteArray;
    FEs2c: TclByteArray;
    FMACc2s: TclByteArray;
    FMACs2c: TclByteArray;
    FS2ccipher: TclCipher;
    FC2scipher: TclCipher;
    FS2cmac: TclMac;
    FC2smac: TclMac;
    FMac_buf: TclByteArray;
    FDeflater: TclCompression;
    FInflater: TclCompression;
    FAuth: TclSshUserAuth;
    FAuthMethods: string;
    FTargetName: string;
    FIdentity: TclSshUserIdentity;

    FV_S: TclByteArray;
    FV_C: TclByteArray;

    FI_C: TclByteArray;
    FI_S: TclByteArray;

    FChannelId: Integer;
    FRecipientId: Integer;
    FChannelType: string;
    FSubSystem: string;
    FLocalWindowSizeMax: Integer;
    FLocalWindowSize: Integer;
    FLocalPacketSize: Integer;

    FRemoteWindowSize: Integer;
    FRemotePacketSize: Integer;

    FLastErrorText: string;
    FLastErrorCode: Integer;
    FMoreDataNeeded: Boolean;

    FRandom: TclRandom;

    FCipher_size: Integer;

    FOnVerifyPeer: TclVerifySshPeerEvent;

    procedure RaiseSshError(const AErrorMsg: string; AErrorCode: Integer);
    procedure DoUpdateProgress(ABytesProceed: Int64);
    procedure DoStreamReady;
    procedure ResetSsh;
    procedure Init;
    procedure ClearSshAction;
    procedure SetSshAction(Action: TclNetworkStreamAction);
    function FillBuffer(ASource: TStream): Boolean;
    procedure EncodePacket(APack: TclPacket);
    procedure SendKexInit(ADestination: TStream);
    procedure UpdateKeys(AKex: TclSshKeyExchanger);
    procedure CheckHost(const AHost: string; AKex: TclSshKeyExchanger);

    function ProcessVersionExchange(ASource: TStream): Boolean;
    function ProcessKeyExchangeInit: Boolean;
    function ProcessKeyExchange: Boolean;
    function ProcessNewKeys: Boolean;
    function ProcessAuthenticateInit: Boolean;
    function ProcessAuthenticate: Boolean;
    function ProcessChannelOpenConfirmation: Boolean;
    function ProcessChannelOpenFailure: Boolean;
    function ProcessChannelOpenSuccess: Boolean;
    function ProcessChannelFailure: Boolean;
    function ProcessChannelData(ADestination: TStream): Boolean;
    function ProcessChannelDataEx(ADestination: TStream): Boolean;
    function ProcessChannel(ADestination: TStream): Boolean;
    function ProcessData(ASource, ADestination: TStream): Boolean;

    function FillPacket(ASource: TStream; APack: TclPacket): Integer;
    procedure PreparePacket(ADestination: TStream; APack: TclPacket);
    procedure PrepareVersionExchange(ADestination: TStream);
    procedure PrepareKeyExchangeInit(ADestination: TStream);
    procedure PrepareKeyGuess(ADestination: TStream);
    procedure PrepareKeyExchange(ADestination: TStream);
    procedure PrepareNewKeys(ADestination: TStream);
    procedure PrepareAuthenticateInit(ADestination: TStream);
    procedure PrepareAuthenticate(ADestination: TStream);
    procedure PrepareChannelOpen(ADestination: TStream);
    procedure PrepareChannelRequest(ADestination: TStream);
    procedure PrepareChannelData(ASource, ADestination: TStream);
    procedure PrepareDisconnect(ADestination: TStream);
    procedure PrepareChannelClose(ADestination: TStream);
    procedure PrepareData(ASource, ADestination: TStream);
    function WriteData(ASource: TStream; ALength: Integer): Boolean;
  public
    constructor Create(AConfig: TclConfig);
    destructor Destroy; override;

    procedure Assign(ASource: TclNetworkStream); override;
    procedure Close(ANotifyPeer: Boolean); override;
    procedure StreamReady; override;
    function Read(AData: TStream): Boolean; override;
    function Write(AData: TStream): Boolean; override;

    function GetReadBatchSize: Integer; override;
    function GetWriteBatchSize: Integer; override;

    procedure UpdateProgress(ABytesProceed: Int64); override;
    procedure InitClientSession; override;
    procedure InitServerSession; override;

    property RecipientId: Integer read FRecipientId;
    property SessionId: TclByteArray read FSessionId;

    property SshAgent: string read FSshAgent write FSshAgent;
    property Identity: TclSshUserIdentity read FIdentity write FIdentity;
    property ChannelType: string read FChannelType write FChannelType;
    property SubSystem: string read FSubSystem write FSubSystem;
    property TargetName: string read FTargetName write FTargetName;

    property OnVerifyPeer: TclVerifySshPeerEvent read FOnVerifyPeer write FOnVerifyPeer;
  end;

implementation

uses
  clSocketUtils, clSshUtils, clTranslator{$IFDEF LOGGER}, clLogger, clWUtils{$ENDIF};

{ TclSshNetworkStream }

procedure TclSshNetworkStream.Assign(ASource: TclNetworkStream);
var
  src: TclSshNetworkStream;
begin
  inherited Assign(ASource);
  if (ASource is TclSshNetworkStream) then
  begin
    src := ASource as TclSshNetworkStream;
    FSshAgent := src.SshAgent;
    FIdentity := src.Identity;
    FChannelType := src.ChannelType;
    FSubSystem := src.SubSystem;
  end;
end;

procedure TclSshNetworkStream.CheckHost(const AHost: string; AKex: TclSshKeyExchanger);
var
  verified: Boolean;
begin
  //TODO implement host checking, HostKeyRepository
  verified := True;
  if Assigned(OnVerifyPeer) then
  begin
    OnVerifyPeer(Self, AHost, AKex.GetKeyType(), AKex.GetFingerPrint(), BytesToHex(AKex.GetHostKey()), verified);
  end;

  if (not verified) then
  begin
    RaiseSshError(HostKeyRejected, HostKeyRejectedCode);
  end;
end;

procedure TclSshNetworkStream.ClearSshAction;
begin
  FSshAction := saNone;
end;

procedure TclSshNetworkStream.Close(ANotifyPeer: Boolean);
begin
  inherited Close(ANotifyPeer);

  try
    if (ANotifyPeer) then
    begin
      if (FState > sshChannelRequest) then
      begin
        FState := sshChannelClose;
      end else
      begin
        FState := sshDisconnect;
      end;

      if (not WriteData(nil, 0)) then
      begin
        SetNextAction(saWrite);
      end;
    end;
  except
    on EclSocketError do;
  end;

  ResetSsh();
end;

constructor TclSshNetworkStream.Create(AConfig: TclConfig);
begin
  inherited Create();

  FReadData := TMemoryStream.Create();
  FWriteData := TMemoryStream.Create();

  FPacket := TclPacket.Create();
  FWritePacket := TclPacket.Create();

  FConfig := AConfig;
  FSeqi := 0;
  FSeqo := 0;

  FSshAgent := DefaultSshAgent;
  FIdentity := nil;
  FChannelType := '';
  FSubSystem := '';
  FTargetName := '';

  FRandom := TclRandom(FConfig.CreateInstance('random'));
end;

destructor TclSshNetworkStream.Destroy;
begin
  FRandom.Free();

  FKex.Free();
  FS2ccipher.Free();
  FC2scipher.Free();
  FS2cmac.Free();
  FC2smac.Free();
  FDeflater.Free();
  FInflater.Free();
  FAuth.Free();

  FWritePacket.Free();
  FPacket.Free();

  FWriteData.Free();
  FReadData.Free();

  inherited Destroy();
end;

procedure TclSshNetworkStream.DoStreamReady;
begin
  inherited StreamReady();
end;

procedure TclSshNetworkStream.DoUpdateProgress(ABytesProceed: Int64);
begin
  inherited UpdateProgress(ABytesProceed);
end;

procedure TclSshNetworkStream.EncodePacket(APack: TclPacket);
var
  mac, buf: TclByteArray;
  pad: Integer;
begin
{$IFNDEF DELPHI2005}mac := nil; buf := nil;{$ENDIF}
  if (FDeflater <> nil) then
  begin
    APack.SetIndex(FDeflater.Compress(APack.Buffer, 5, APack.GetIndex()));
  end;

  if (FC2scipher <> nil) then
  begin
    APack.Padding(FRandom, FC2scipher.getIVSize());
    pad := APack.Buffer[4];
    FRandom.Fill(APack.Buffer, APack.GetIndex() - pad, pad);
  end else
  begin
    APack.Padding(FRandom, 8);
  end;

  SetLength(mac, 0);
  if (FC2smac <> nil) then
  begin
    FC2smac.Update(FSeqo);
    FC2smac.Update(APack.Buffer, 0, APack.GetIndex());
    mac := FC2smac.Digest();
  end;

  if (FC2scipher <> nil) then
  begin
    buf := APack.Buffer;
    FC2scipher.Update(buf, 0, APack.GetIndex());
  end;

  if (Length(mac) > 0) then
  begin
    APack.PutByte(mac);
  end;
end;

function TclSshNetworkStream.FillBuffer(ASource: TStream): Boolean;
var
  oldPos: Int64;
  uncompress_len: Integer;
  ind, pad, bufType, reason_code: Integer;
  res, foo, description, language_tag: TclByteArray;
begin
{$IFNDEF DELPHI2005}res := nil; foo := nil; description := nil; language_tag := nil;{$ENDIF}
  oldPos := ASource.Position;

  Result := False;

  repeat
    if ((ASource.Position + FCipher_size) >= ASource.Size) then
    begin
      ASource.Position := oldPos;
      Exit;
    end;

    if (FReadPacketLength < 0) then
    begin
      FPacket.Init();

      ASource.Read(FPacket.Buffer[FPacket.GetIndex()], FCipher_size);
      FPacket.SetIndex(FPacket.GetIndex() + FCipher_size);

      if (FS2ccipher <> nil) then
      begin
        FS2ccipher.Update(FPacket.Buffer, 0, FCipher_size);
      end;

      ind := 0;
      FReadPacketLength := Integer(ByteArrayReadDWord(FPacket.Buffer, ind));
      FReadPacketLength := FReadPacketLength - 4 - FCipher_size + 8;

      if (FReadPacketLength < 0) or ((FPacket.GetIndex() + FReadPacketLength) > Length(FPacket.Buffer)) then
      begin
        RaiseSshError(InvalidPacketSize, InvalidPacketSizeCode);
      end;
    end else
    begin
      ASource.Seek(FCipher_size, soCurrent);
    end;

    if ((ASource.Position + FReadPacketLength - 4) > ASource.Size) then
    begin
      ASource.Position := oldPos;
      Exit;
    end;

    if (FReadPacketLength > 0) then
    begin
      if (not FReadDataFilled) then
      begin
        ASource.Read(FPacket.Buffer[FPacket.GetIndex()], FReadPacketLength);
        FPacket.SetIndex(FPacket.GetIndex() + FReadPacketLength);

        if (FS2ccipher <> nil) then
        begin
          FS2ccipher.Update(FPacket.Buffer, FCipher_size, FReadPacketLength);
        end;
        FReadDataFilled := True;
      end else
      begin
        ASource.Seek(FReadPacketLength, soCurrent);
      end;
    end;

    if (FS2cmac <> nil) then
    begin
      if ((ASource.Position + Length(FMac_buf)) > ASource.Size) then
      begin
        ASource.Position := oldPos;
        Exit;
      end;

      FS2cmac.Update(FSeqi);
      FS2cmac.Update(FPacket.Buffer, 0, FPacket.GetIndex());
      res := FS2cmac.Digest();

      ASource.Read(FMac_buf[0], Length(FMac_buf));
      if (not ByteArrayEquals(res, FMac_buf)) then
      begin
        RaiseSshError(MacError, MacErrorCode);
      end;
    end;
    Inc(FSeqi);

    FReadPacketLength := -1;
    FReadDataFilled := False;

    if (FInflater <> nil) then
    begin
      pad := FPacket.Buffer[4];
      uncompress_len := FPacket.GetIndex() - 5 - pad;
      foo := FInflater.Uncompress(FPacket.Buffer, 5, uncompress_len);

      if (Length(foo) > 0) then
      begin
        FPacket.Buffer := foo;
        FPacket.SetIndex(5 + uncompress_len);
      end else
      begin
        Break;
      end;
    end;

    bufType := FPacket.Buffer[5] and $ff;
    if (bufType = SSH_MSG_DISCONNECT) then
    begin
      FPacket.Rewind();
      FPacket.GetInt();
      FPacket.GetShort();

      reason_code := FPacket.GetInt();
      description := FPacket.GetString();
      language_tag := FPacket.GetString();

      RaiseSshError(DisconnectOccurred, reason_code);
    end else
    if (bufType = SSH_MSG_IGNORE) then
    begin
      if (ASource.Position >= ASource.Size) then Break;
    end else
    if (bufType = SSH_MSG_DEBUG) then
    begin
      FPacket.Rewind();
      FPacket.GetInt();
      FPacket.GetShort();

      if (ASource.Position >= ASource.Size) then Break;
    end else
    if (bufType = SSH_MSG_CHANNEL_WINDOW_ADJUST) then
    begin
      FPacket.Rewind();
      FPacket.GetInt();
      FPacket.GetShort();

      ind := FPacket.GetInt();
      if (ind = FChannelId) then
      begin
        Inc(FRemoteWindowSize, FPacket.GetInt());
      end;

      if (FIsAdjustRemoteWinSize) then
      begin
        if (not WriteData(nil, 0)) then
        begin
          SetSshAction(saWrite);
        end;

        Break;
      end else
      if (ASource.Position >= ASource.Size) then
      begin
        Break;
      end;
    end else
    begin
      Result := True;
      Break;
    end;
  until False;

  FPacket.Rewind();
end;

function TclSshNetworkStream.FillPacket(ASource: TStream; APack: TclPacket): Integer;
begin
  APack.Init();
  ASource.Read(APack.Buffer[0], ASource.Size);

  APack.SetOffSet(5);
  APack.GetByte();
  APack.GetInt();
  Result := APack.GetInt();

  APack.Init();
  APack.SetIndex(ASource.Size);
end;

function TclSshNetworkStream.GetReadBatchSize: Integer;
begin
  Result := inherited GetReadBatchSize();
  if (FS2ccipher <> nil) then
  begin
    Result := Result + FS2ccipher.GetIVSize() * 2;
  end;
  if (FS2cmac <> nil) then
  begin
    Result := Result + FS2cmac.GetBlockSize() * 2;
  end;
end;

function TclSshNetworkStream.GetWriteBatchSize: Integer;
begin
  Result := inherited GetWriteBatchSize();
  if (FC2scipher <> nil) then
  begin
    Result := Result + FC2scipher.GetIVSize() * 2;
  end;
  if (FC2smac <> nil) then
  begin
    Result := Result + FC2smac.GetBlockSize() * 2;
  end;
end;

procedure TclSshNetworkStream.Init;
begin
  FMoreDataNeeded := False;
  FReadData.Size := 0;
  FWriteData.Size := 0;
  FLastErrorText := UnknownError;
  FLastErrorCode := UnknownErrorCode;
  FWritePacketLength := 0;

  ResetSsh();
end;

procedure TclSshNetworkStream.InitClientSession;
begin
  Init();
  SetNextAction(saRead);
end;

procedure TclSshNetworkStream.InitServerSession;
begin
  Assert(False, 'Not implemented');
end;

procedure TclSshNetworkStream.PrepareAuthenticate(ADestination: TStream);
var
  pp: TclPacket;
  authResult: TclSshAuthResult;
  authList, regAuth: TStrings;
  regAuthMethods: string;
  i: Integer;
begin
  pp := nil;
  try
    if (FAuth = nil) then
    begin
      authList := nil;
      regAuth := nil;
      try
        authList := TStringList.Create();
        regAuth := TStringList.Create();

        regAuthMethods := FConfig.GetConfig('auth.method');
        ExtractQuotedWords(regAuthMethods, regAuth, ',', [], [], True);

        ExtractQuotedWords(LowerCase(FAuthMethods), authList, ',', [], [], True);

        for i := 0 to regAuth.Count - 1 do
        begin
          if (authList.IndexOf(regAuth[i]) > -1) then
          begin
            FAuth := TclSshUserAuth(FConfig.CreateInstance(regAuth[i]));
            if (FAuth = nil) then
            begin
              RaiseSshError(AlgorithmNegotiationError, AlgorithmNegotiationErrorCode);
            end;

            if not FAuth.Init(FConfig, FIdentity, FSessionId) then
            begin
              FreeAndNil(FAuth);
            end else
            begin
              Break;
            end;
          end;
        end;
      finally
        regAuth.Free();
        authList.Free();
      end;

      if (FAuth = nil) then
      begin
        RaiseSshError(AuthMethodError, AuthMethodErrorCode);
      end;

      authResult := FAuth.Authenticate(nil, pp);
    end else
    begin
      authResult := FAuth.Authenticate(FPacket, pp);
    end;

    if (pp <> nil) then
    begin
      PreparePacket(ADestination, pp);
      SetSshAction(saRead);
    end;

    case (authResult) of
      sarSuccess:
      begin
        FState := sshChannelOpen;
        SetSshAction(saWrite);
      end;
      sarFail:
      begin
        RaiseSshError(UserAuthError, UserAuthErrorCode);
      end
    else
      begin
        FAuthMethods := FAuth.Methods;
        FState := sshAuthenticate;
        SetSshAction(saRead);
      end;
    end;
  finally
    pp.Free();
  end;
end;

procedure TclSshNetworkStream.PrepareAuthenticateInit(ADestination: TStream);
var
  pp: TclPacket;
  authResult: TclSshAuthResult;
begin
  pp := nil;
  try
    if (FAuth = nil) then
    begin
      FAuth := TclUserAuthNone.Create();
      FAuth.Init(FConfig, FIdentity, FSessionId);
      authResult := FAuth.Authenticate(nil, pp);
    end else
    begin
      authResult := FAuth.Authenticate(FPacket, pp);
    end;

    if (pp <> nil) then
    begin
      PreparePacket(ADestination, pp);
      SetSshAction(saRead);
    end;

    case (authResult) of
      sarSuccess:
      begin
        FState := sshChannelOpen;
        SetSshAction(saWrite);
      end;
      sarFail:
      begin
        FAuthMethods := FAuth.Methods;
        if (Trim(FAuthMethods) = '') and (Pos('password', FConfig.GetConfig('auth.method')) > 0) then
        begin
          FAuthMethods := 'password';
        end;
        FreeAndNil(FAuth);
        FState := sshAuthenticate;
        SetSshAction(saWrite);
      end
    else
      begin
        FState := sshAuthenticateInit;
        SetSshAction(saRead);
      end;
    end;
  finally
    pp.Free();
  end;
end;

procedure TclSshNetworkStream.PrepareChannelClose(ADestination: TStream);
begin
  FPacket.Reset();
  FPacket.PutByte(SSH_MSG_CHANNEL_CLOSE);
  FPacket.PutInt(FRecipientId);

  PreparePacket(ADestination, FPacket);
end;

procedure TclSshNetworkStream.PrepareChannelData(ASource, ADestination: TStream);
var
  len, s, blockSize: Integer;
  command: Byte;
begin
  if (FIsAdjustLocalWinSize) then
  begin
    FIsAdjustLocalWinSize := False;

    FPacket.Reset();
    FPacket.PutByte(SSH_MSG_CHANNEL_WINDOW_ADJUST);
    FPacket.PutInt(FRecipientId);
    FPacket.PutInt(FLocalWindowSizeMax - FLocalWindowSize);
    FLocalWindowSize := FLocalWindowSizeMax;
    PreparePacket(ADestination, FPacket);
  end else
  if ((ASource <> nil) or FIsAdjustRemoteWinSize) then
  begin
    if (not FIsAdjustRemoteWinSize) then
    begin
      ASource.Position := 0;
      FWritePacketLength := FillPacket(ASource, FWritePacket);
    end;

    if (FRemoteWindowSize >= FWritePacketLength) then
    begin
      Dec(FRemoteWindowSize, FWritePacketLength);
      PreparePacket(ADestination, FWritePacket);

      FIsAdjustRemoteWinSize := False;
    end else
    begin
      if (FRemoteWindowSize > 0) then
      begin
        len := FRemoteWindowSize;

        blockSize := 0;
        if (FC2smac <> nil) then
        begin
          blockSize := FC2smac.GetBlockSize();
        end;

        s := FWritePacket.Shift(len, blockSize);
        command := FWritePacket.Buffer[5];
        Dec(FWritePacketLength, len);
        FRemoteWindowSize := 0;
        PreparePacket(ADestination, FWritePacket);
        FWritePacket.Unshift(command, FRecipientId, s, FWritePacketLength);
      end;

      FIsAdjustRemoteWinSize := True;
      SetSshAction(saRead);
    end;
  end;
end;

procedure TclSshNetworkStream.PrepareChannelOpen(ADestination: TStream);
var
  pp: TclPacket;
begin
  pp := TclPacket.Create(100);
  try
    pp.Reset();
    pp.PutByte(SSH_MSG_CHANNEL_OPEN);
    pp.PutString(TclTranslator.GetBytes(FChannelType));
    pp.PutInt(FChannelId);
    pp.PutInt(FLocalWindowSize);
    pp.PutInt(FLocalPacketSize);
    PreparePacket(ADestination, pp);

    SetSshAction(saRead);
    FState := sshChannelRequest;
  finally
    pp.Free();
  end;
end;

procedure TclSshNetworkStream.PrepareChannelRequest(ADestination: TStream);
var
  pp: TclPacket;
begin
  pp := TclPacket.Create(100);
  try
    pp.Reset();
    pp.PutByte(SSH_MSG_CHANNEL_REQUEST);
    pp.PutInt(FRecipientId);
    pp.PutString(TclTranslator.GetBytes('subsystem'));
    pp.PutByte(1);
    pp.PutString(TclTranslator.GetBytes(FSubSystem));
    PreparePacket(ADestination, pp);

    SetSshAction(saRead);
    FState := sshChannelRequest;
  finally
    pp.Free();
  end;
end;

procedure TclSshNetworkStream.PrepareData(ASource, ADestination: TStream);
begin
  if ((ADestination.Size - ADestination.Position) > 0) then Exit;

  ClearSshAction();

  case FState of
    sshVersionExchange: PrepareVersionExchange(ADestination);
    sshKeyExchangeInit: PrepareKeyExchangeInit(ADestination);
    sshKeyGuess: PrepareKeyGuess(ADestination);
    sshKeyExchange: PrepareKeyExchange(ADestination);
    sshNewKeys: PrepareNewKeys(ADestination);
    sshAuthenticateInit: PrepareAuthenticateInit(ADestination);
    sshAuthenticate: PrepareAuthenticate(ADestination);
    sshChannelOpen: PrepareChannelOpen(ADestination);
    sshChannelRequest: PrepareChannelRequest(ADestination);
    sshData: PrepareChannelData(ASource, ADestination);
    sshDisconnect: PrepareDisconnect(ADestination);
    sshChannelClose: PrepareChannelClose(ADestination);
  end;
end;

procedure TclSshNetworkStream.PrepareDisconnect(ADestination: TStream);
begin
  FPacket.Reset();
  FPacket.putByte(SSH_MSG_DISCONNECT);
  FPacket.PutInt(3);
  FPacket.PutString(TclTranslator.GetBytes(FLastErrorText));
  FPacket.PutString(TclTranslator.GetBytes('en'));

  PreparePacket(ADestination, FPacket);
end;

procedure TclSshNetworkStream.PrepareKeyExchange(ADestination: TStream);
var
  pp: TclPacket;
begin
  if (FKex.GetState() = FPacket.Buffer[5]) then
  begin
    pp := nil;
    if (not FKex.Next(FPacket, pp)) then
    begin
      RaiseSshError(KexNextError, KexNextErrorCode);
    end;
    if (pp <> nil) then
    begin
      PreparePacket(ADestination, pp);
      SetSshAction(saRead);
    end;
  end;

  if (FKex.GetState() = STATE_END) then
  begin
    FState := sshNewKeys;
  end;
  SetSshAction(saWrite);
end;

procedure TclSshNetworkStream.PrepareKeyExchangeInit(ADestination: TStream);
var
  j, len: Integer;
begin
  j := FPacket.GetInt();
  if (j <> FPacket.GetLength()) then
  begin
    FPacket.GetByte();
    len := FPacket.GetIndex() - 5;
  end else
  begin
    len := j - 1 - FPacket.GetByte();
  end;
  FI_S := System.Copy(FPacket.Buffer, FPacket.GetOffSet(), len);

  SendKexInit(ADestination);

  SetSshAction(saWrite);
  FState := sshKeyGuess;
end;

procedure TclSshNetworkStream.PrepareKeyGuess(ADestination: TStream);
var
  guess: TStrings;
  pp: TclPacket;
begin
  guess := TclSshKeyExchanger.Guess(FI_S, FI_C);
  try
    if (guess = nil) then
    begin
      RaiseSshError(AlgorithmNegotiationError, AlgorithmNegotiationErrorCode);
    end;

    FreeAndNil(FKex);
    FKex := TclSshKeyExchanger(FConfig.CreateInstance(guess[PROPOSAL_KEX_ALGS]));
    if (FKex = nil) then
    begin
      RaiseSshError(AlgorithmNegotiationError, AlgorithmNegotiationErrorCode);
    end;
    FKex.GuessAlgorithms := guess;

    pp := nil;
    FKex.Init(FConfig, FV_S, FV_C, FI_S, FI_C, pp);
    if (pp <> nil) then
    begin
      PreparePacket(ADestination, pp);
    end;

    SetSshAction(saRead);
    FState := sshKeyExchange;
  finally
    guess.Free();
  end;
end;

procedure TclSshNetworkStream.PrepareNewKeys(ADestination: TStream);
begin
  CheckHost(TargetName, FKex);

  FPacket.Reset();
  FPacket.PutByte(SSH_MSG_NEWKEYS);
  PreparePacket(ADestination, FPacket);

  SetSshAction(saRead);
end;

procedure TclSshNetworkStream.PreparePacket(ADestination: TStream; APack: TclPacket);
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'PreparePacket (before encode), index='
    + IntToStr(APack.GetIndex())
    + ', S=' + IntToStr(APack.GetOffSet()),
    PclChar(APack.Buffer), Length(APack.Buffer));{$ENDIF}
  ADestination.Size := 0;
  EncodePacket(APack);
  ADestination.Write(APack.Buffer[0], APack.GetIndex());

  Inc(FSeqo);
  ADestination.Position := 0;
end;

procedure TclSshNetworkStream.PrepareVersionExchange(ADestination: TStream);
var
  b: Byte;
begin
  FV_C := TclTranslator.GetBytes('SSH-2.0-' + SshAgent);

  ADestination.Size := 0;
  ADestination.Write(FV_C[0], Length(FV_C));
  b := $a;
  ADestination.Write(b, SizeOf(b));
  ADestination.Position := 0;

  SetSshAction(saRead);
  FState := sshKeyExchangeInit;
end;

function TclSshNetworkStream.ProcessAuthenticate: Boolean;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessAuthenticate', nil);{$ENDIF}

  Result := WriteData(nil, 0);
  if (not Result) then
  begin
    SetSshAction(saWrite);
  end;
end;

function TclSshNetworkStream.ProcessAuthenticateInit: Boolean;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessAuthenticateInit', nil);{$ENDIF}

  Result := WriteData(nil, 0);
  if (not Result) then
  begin
    SetSshAction(saWrite);
  end;
end;

function TclSshNetworkStream.ProcessChannelData(ADestination: TStream): Boolean;
var
  i: Integer;
  start, length: TclIntArray;
  foo: TclByteArray;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessChannelData', nil);{$ENDIF}

{$IFNDEF DELPHI2005}foo := nil; start := nil; length := nil;{$ENDIF}
  FPacket.GetInt();
  FPacket.GetByte();
  FPacket.GetByte();
  i := FPacket.GetInt();
  if (i <> FChannelId) then
  begin
    SetSshAction(saRead);
    Result := False;
    Exit;
  end;

  SetLength(start, 1);
  SetLength(length, 1);

  foo := FPacket.GetString(start, length);

  ADestination.Write(foo[start[0]], length[0]);

  Dec(FLocalWindowSize, length[0]);
  if (FLocalWindowSize < FLocalWindowSizeMax div 2) then
  begin
    FIsAdjustLocalWinSize := True;
    SetSshAction(saWrite);
    Result := False;
    Exit;
  end;

  FState := sshData;
  Result := True;
end;

function TclSshNetworkStream.ProcessChannelDataEx(ADestination: TStream): Boolean;
var
  i: Integer;
  start, length: TclIntArray;
  foo: TclByteArray;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessChannelDataEx', nil);{$ENDIF}

{$IFNDEF DELPHI2005}foo := nil; start := nil; length := nil;{$ENDIF}
  FPacket.GetInt();
  FPacket.GetByte();
  FPacket.GetByte();
  i := FPacket.GetInt();
  if (i <> FChannelId) then
  begin
    SetSshAction(saRead);
    Result := False;
    Exit;
  end;

  SetLength(start, 1);
  SetLength(length, 1);

  foo := FPacket.GetString(start, length);

  Dec(FLocalWindowSize, length[0]);
  if (FLocalWindowSize < FLocalWindowSizeMax div 2) then
  begin
    FIsAdjustLocalWinSize := True;
    SetSshAction(saWrite);
    Result := False;
    Exit;
  end;

  FState := sshData;
  Result := True;
end;

function TclSshNetworkStream.ProcessChannelFailure: Boolean;
var
  i: Integer;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessChannelFailure', nil);{$ENDIF}

  Result := False;

  FPacket.GetInt();
  FPacket.GetShort();
  i := FPacket.GetInt();
  if (i <> FChannelId) then
  begin
    SetSshAction(saRead);
    Exit;
  end;

  RaiseSshError(RequestSubsystemError, RequestSubsystemErrorCode);
end;

function TclSshNetworkStream.ProcessChannelOpenConfirmation: Boolean;
var
  i: Integer;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessChannelOpenConfirmation', nil);{$ENDIF}

  FPacket.GetInt();
  FPacket.GetShort();
  i := FPacket.GetInt();
  if (i <> FChannelId) then
  begin
    SetSshAction(saRead);
    Result := False;
    Exit;
  end;

  FRecipientId := FPacket.GetInt();
  FRemoteWindowSize := FPacket.GetInt();
  FRemotePacketSize := FPacket.GetInt();

  FState := sshChannelRequest;

  Result := WriteData(nil, 0);
  if (not Result) then
  begin
    SetSshAction(saWrite);
  end;
end;

function TclSshNetworkStream.ProcessChannelOpenFailure: Boolean;
var
  i, reason_code: Integer;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessChannelOpenFailure', nil);{$ENDIF}

  Result := False;

  FPacket.GetInt();
  FPacket.GetShort();
  i := FPacket.GetInt();
  if (i <> FChannelId) then
  begin
    SetSshAction(saRead);
    Exit;
  end;
  reason_code := FPacket.GetInt();

  RaiseSshError(ChannelOpenError, reason_code);
end;

function TclSshNetworkStream.ProcessChannelOpenSuccess: Boolean;
var
  i: Integer;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessChannelOpenSuccess', nil);{$ENDIF}

  FPacket.GetInt();
  FPacket.GetShort();
  i := FPacket.GetInt();
  if (i <> FChannelId) then
  begin
    SetSshAction(saRead);
    Result := False;
    Exit;
  end;

  FState := sshData;
  DoStreamReady();
  Result := True;
end;

function TclSshNetworkStream.ProcessChannel(ADestination: TStream): Boolean;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessChannel, FPacket.Buffer[5] = ' + IntToStr(FPacket.Buffer[5]), nil);{$ENDIF}

  Result := True;
  case FPacket.Buffer[5] of
    SSH_MSG_CHANNEL_OPEN_CONFIRMATION: Result := ProcessChannelOpenConfirmation();
    SSH_MSG_CHANNEL_OPEN_FAILURE: Result := ProcessChannelOpenFailure();
    SSH_MSG_CHANNEL_SUCCESS: Result := ProcessChannelOpenSuccess();
    SSH_MSG_CHANNEL_FAILURE: Result := ProcessChannelFailure();
    SSH_MSG_CHANNEL_DATA: Result := ProcessChannelData(ADestination);
    SSH_MSG_CHANNEL_EXTENDED_DATA: Result := ProcessChannelDataEx(ADestination);
    //SSH_MSG_CHANNEL_OPEN
    //SSH_MSG_CHANNEL_REQUEST
    //SSH_MSG_CHANNEL_EOF
    //SSH_MSG_CHANNEL_CLOSE
  end;
end;

function TclSshNetworkStream.ProcessData(ASource, ADestination: TStream): Boolean;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessData', nil);{$ENDIF}

  Result := True;
  ClearSshAction();

  if (sshVersionExchange = FState) then
  begin
    if (not ProcessVersionExchange(ASource)) then
    begin
      Result := False;
    end;
  end else
  begin
    if (not FillBuffer(ASource)) then
    begin
      SetSshAction(saRead);
      Result := False;
      Exit;
    end;

    case FState of
      sshKeyExchangeInit: Result := ProcessKeyExchangeInit();
      sshKeyExchange: Result := ProcessKeyExchange();
      sshNewKeys: Result := ProcessNewKeys();
      sshAuthenticateInit: Result := ProcessAuthenticateInit();
      sshAuthenticate: Result := ProcessAuthenticate();
      sshChannelOpen, sshChannelRequest, sshData: Result := ProcessChannel(ADestination);
      //SSH_MSG_KEXINIT
      //SSH_MSG_NEWKEYS

      //SSH_MSG_GLOBAL_REQUEST
      //SSH_MSG_REQUEST_SUCCESS
      //SSH_MSG_REQUEST_FAILURE
    end;
  end;
end;

function TclSshNetworkStream.ProcessKeyExchange: Boolean;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessKeyExchange', nil);{$ENDIF}

  if (FKex.GetState() <> FPacket.Buffer[5]) then
  begin
    RaiseSshError(InvalidKexProtocol, FPacket.Buffer[5]);
  end;

  Result := WriteData(nil, 0);
  if (not Result) then
  begin
    SetSshAction(saWrite);
  end;
end;

function TclSshNetworkStream.ProcessKeyExchangeInit: Boolean;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessKeyExchangeInit', nil);{$ENDIF}

  if (FPacket.Buffer[5] <> SSH_MSG_KEXINIT) then
  begin
    RaiseSshError(InvalidProtocol, FPacket.Buffer[5]);
  end;

  Result := WriteData(nil, 0);
  if (not Result) then
  begin
    SetSshAction(saWrite);
  end;
end;

function TclSshNetworkStream.ProcessNewKeys: Boolean;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessNewKeys', nil);{$ENDIF}

  if (FPacket.Buffer[5] = SSH_MSG_NEWKEYS) then
  begin
    UpdateKeys(FKex);
  end else
  begin
    RaiseSshError(InvalidNewKeysProtocol, FPacket.Buffer[5]);
  end;

  FState := sshAuthenticateInit;

  Result := WriteData(nil, 0);
  if (not Result) then
  begin
    SetSshAction(saWrite);
  end;
end;

function TclSshNetworkStream.ProcessVersionExchange(ASource: TStream): Boolean;
var
  i: Integer;
  b: Byte;
  oldPos: Int64;
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'ProcessVersionExchange', nil);{$ENDIF}

  oldPos := ASource.Position;
  i := 0;
  while (i < Length(FPacket.Buffer)) do
  begin
    if (ASource.Read(b, SizeOf(b)) <> SizeOf(b)) then
    begin
      ASource.Position := oldPos;
      SetSshAction(saRead);
      Result := False;
      Exit;
    end;

    FPacket.Buffer[i] := b;
    Inc(i);
    if (b = 10) then Break;
  end;

  if (FPacket.Buffer[i - 1] = 10) then
  begin
    Dec(i);
    if (FPacket.Buffer[i - 1] = 13) then
    begin
      Dec(i);
    end;
  end;

  if (i = Length(FPacket.Buffer)) or
    (i < 7) or                                      // SSH-1.99 or SSH-2.0
    ((FPacket.Buffer[4] = 31) and (FPacket.Buffer[6] <> 39))  // SSH-1.5
    then
  begin
    RaiseSshError(InvalidVersion, InvalidVersionCode);
  end;
  FV_S := System.Copy(FPacket.Buffer, 0, i);

  Result := WriteData(nil, 0);
  if (not Result) then
  begin
    SetSshAction(saWrite);
  end;
end;

procedure TclSshNetworkStream.RaiseSshError(const AErrorMsg: string; AErrorCode: Integer);
begin
  FLastErrorText := AErrorMsg;
  FLastErrorCode := AErrorCode;

  raise EclSshError.Create(AErrorMsg, AErrorCode);
end;

function TclSshNetworkStream.Read(AData: TStream): Boolean;
var
  oldPos, curPos: Int64;
begin
  Result := True;
  oldPos := -1;
  if (AData <> nil) then
  begin
    oldPos := AData.Position;
  end;

  try
    if (FMoreDataNeeded or (FReadData.Size <= 0)) then
    begin
      curPos := FReadData.Position;
      FReadData.Seek(0, soEnd);
      Result := inherited Read(FReadData);
      FReadData.Position := curPos;
    end;

    FMoreDataNeeded := not ProcessData(FReadData, AData);

    if ((FReadData.Size - FReadData.Position) <= 0) then
    begin
      {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'Read ((FReadData.Size - readData.Position) <= 0): ' + IntToStr(FReadData.Size));{$ENDIF}
      FReadData.Size := 0;
    end;

    HasReadData := (FReadData.Size > 0);
  finally
    if (oldPos > -1) then
    begin
      DoUpdateProgress(AData.Position - oldPos);
    end;
  end;

  SetNextAction(FSshAction);
end;

procedure TclSshNetworkStream.ResetSsh;
begin
  FIsAdjustLocalWinSize := False;
  FIsAdjustRemoteWinSize := False;
  FState := sshVersionExchange;
  FPacket.Init();
  FWritePacket.Init();

  FChannelId := 0;
  FRecipientId := -1;
  FLocalWindowSizeMax := $100000;
  FLocalWindowSize := $100000;
  FLocalPacketSize := $4000;

  FRemoteWindowSize := 0;
  FRemotePacketSize := 0;

  FreeAndNil(FKex);

  SetLength(FSessionId, 0);
  
  FreeAndNil(FAuth);

  FSeqi := 0;
  FSeqo := 0;
  
  SetLength(FIVc2s, 0);
  SetLength(FIVs2c, 0);
  SetLength(FEc2s, 0);
  SetLength(FEs2c, 0);
  SetLength(FMACc2s, 0);
  SetLength(FMACs2c, 0);

  FreeAndNil(FS2ccipher);
  FreeAndNil(FC2scipher);
  FreeAndNil(FS2cmac);
  FreeAndNil(FC2smac);

  SetLength(FMac_buf, 0);

  FreeAndNil(FDeflater);
  FreeAndNil(FInflater);

  FAuthMethods := '';
  FReadPacketLength := -1;
  FReadDataFilled := False;

  SetLength(FV_S, 0);
  SetLength(FV_C, 0);

  SetLength(FI_C, 0);
  SetLength(FI_S, 0);

  FCipher_size := 8;
end;

procedure TclSshNetworkStream.SendKexInit(ADestination: TStream);
begin
  FPacket.Reset();
  FPacket.PutByte(SSH_MSG_KEXINIT);
  FRandom.Fill(FPacket.Buffer, FPacket.GetIndex(), 16);
  FPacket.Skip(16);
  FPacket.PutString(TclTranslator.GetBytes(FConfig.GetConfig('kex')));
  FPacket.PutString(TclTranslator.GetBytes(FConfig.GetConfig('server.hostkey')));
  FPacket.PutString(TclTranslator.GetBytes(FConfig.GetConfig('cipher.c2s')));
  FPacket.PutString(TclTranslator.GetBytes(FConfig.GetConfig('cipher.s2c')));
  FPacket.PutString(TclTranslator.GetBytes(FConfig.GetConfig('mac.c2s')));
  FPacket.PutString(TclTranslator.GetBytes(FConfig.GetConfig('mac.s2c')));
  FPacket.PutString(TclTranslator.GetBytes(FConfig.GetConfig('compression.c2s')));
  FPacket.PutString(TclTranslator.GetBytes(FConfig.GetConfig('compression.s2c')));
  FPacket.PutString(TclTranslator.GetBytes(FConfig.GetConfig('lang.c2s')));
  FPacket.PutString(TclTranslator.GetBytes(FConfig.GetConfig('lang.s2c')));
  FPacket.PutByte(0);//TODO KEX First Packet Follows, probably, set it to 1 (true)
  FPacket.PutInt(0);

  FPacket.SetOffSet(5);
  SetLength(FI_C, FPacket.GetLength());
  FPacket.GetByte(FI_C);

  PreparePacket(ADestination, FPacket);
end;

procedure TclSshNetworkStream.SetSshAction(Action: TclNetworkStreamAction);
begin
  if (saNone = FSshAction) then
  begin
    FSshAction := Action;
  end;
end;

procedure TclSshNetworkStream.StreamReady;
begin
end;

procedure TclSshNetworkStream.UpdateKeys(AKex: TclSshKeyExchanger);
var
  K, H, foo: TclByteArray;
  hash: TclHash;
  guess: TStrings;
  j: Integer;
  s: string;
begin
{$IFNDEF DELPHI2005}K := nil; H := nil; foo := nil;{$ENDIF}
  K := AKex.GetK();
  H := AKex.GetH();
  hash := AKex.GetHash();

  guess := AKex.GuessAlgorithms;
  if (Length(FSessionId) = 0) then
  begin
    FSessionId := H;
  end;

  FPacket.Init();
  FPacket.PutMPInt(K);
  FPacket.PutByte(H);
  FPacket.PutByte($41);
  FPacket.PutByte(FSessionId);
  hash.Update(FPacket.Buffer, 0, FPacket.GetIndex());

  FIVc2s := hash.Digest();

  j := FPacket.GetIndex() - Length(FSessionId) - 1;

  FPacket.Buffer[j] := FPacket.Buffer[j] + 1;
  hash.Update(FPacket.Buffer, 0, FPacket.GetIndex());
  FIVs2c := hash.Digest();

  FPacket.Buffer[j] := FPacket.Buffer[j] + 1;
  hash.Update(FPacket.Buffer, 0, FPacket.GetIndex());
  FEc2s := hash.Digest();

  FPacket.Buffer[j] := FPacket.Buffer[j] + 1;
  hash.Update(FPacket.Buffer, 0, FPacket.GetIndex());
  FEs2c := hash.Digest();

  FPacket.Buffer[j] := FPacket.Buffer[j] + 1;
  hash.Update(FPacket.Buffer, 0, FPacket.GetIndex());
  FMACc2s := hash.Digest();

  FPacket.Buffer[j] := FPacket.Buffer[j] + 1;
  hash.Update(FPacket.Buffer, 0, FPacket.GetIndex());
  FMACs2c := hash.Digest();

  FreeAndNil(FS2ccipher);
  FS2ccipher := TclCipher(FConfig.CreateInstance(guess[PROPOSAL_ENC_ALGS_STOC]));
  if (FS2ccipher = nil) then
  begin
    RaiseSshError(AlgorithmNegotiationError, AlgorithmNegotiationErrorCode);
  end;

  while (FS2ccipher.GetBlockSize() > Length(FEs2c)) do
  begin
    FPacket.Init();
    FPacket.PutMPInt(K);
    FPacket.PutByte(H);
    FPacket.PutByte(FEs2c);
    hash.Update(FPacket.Buffer, 0, FPacket.GetIndex());
    foo := hash.Digest();
    SetLength(FEs2c, Length(FEs2c) + Length(foo));
    System.Move(foo[0], FEs2c[Length(FEs2c) - Length(foo)], Length(foo));
  end;
  FS2ccipher.Init(cmDecrypt, FEs2c, FIVs2c);
  FCipher_size := FS2ccipher.GetIVSize();

  FreeAndNil(FS2cmac);
  FS2cmac := TclMac(FConfig.CreateInstance(guess[PROPOSAL_MAC_ALGS_STOC]));
  if (FS2cmac = nil) then
  begin
    RaiseSshError(AlgorithmNegotiationError, AlgorithmNegotiationErrorCode);
  end;

  FS2cmac.Init(FMACs2c, 0, FS2cmac.GetBlockSize());
  SetLength(FMac_buf, FS2cmac.GetBlockSize());

  FreeAndNil(FC2scipher);
  FC2scipher := TclCipher(FConfig.CreateInstance(guess[PROPOSAL_ENC_ALGS_CTOS]));
  if (FC2scipher = nil) then
  begin
    RaiseSshError(AlgorithmNegotiationError, AlgorithmNegotiationErrorCode);
  end;

  while (FC2scipher.GetBlockSize() > Length(FEc2s)) do
  begin
    FPacket.Init();
    FPacket.PutMPInt(K);
    FPacket.PutByte(H);
    FPacket.PutByte(FEc2s);
    hash.Update(FPacket.Buffer, 0, FPacket.GetIndex());
    foo := hash.Digest();
    SetLength(FEc2s, Length(FEc2s) + Length(foo));
    System.Move(foo[0], FEc2s[Length(FEc2s) - Length(foo)], Length(foo));
  end;
  FC2scipher.Init(cmEncrypt, FEc2s, FIVc2s);

  FreeAndNil(FC2smac);
  FC2smac := TclMac(FConfig.CreateInstance(guess[PROPOSAL_MAC_ALGS_CTOS]));
  if (FC2smac = nil) then
  begin
    RaiseSshError(AlgorithmNegotiationError, AlgorithmNegotiationErrorCode);
  end;

  FC2smac.Init(FMACc2s, 0, FC2smac.GetBlockSize());

  if (guess[PROPOSAL_COMP_ALGS_CTOS] <> 'none') then
  begin
    s := FConfig.GetConfig(guess[PROPOSAL_COMP_ALGS_CTOS]);
    if (s <> '') then
    begin
      FreeAndNil(FDeflater);
      FDeflater := TclCompression(FConfig.CreateInstance(s));
      if (FDeflater = nil) then
      begin
        RaiseSshError(AlgorithmNegotiationError, AlgorithmNegotiationErrorCode);
      end;

      FDeflater.Init(ctDeflater, 6); //TODO add compression level to config
    end;
  end else
  begin
    FreeAndNil(FDeflater);
  end;

  if (guess[PROPOSAL_COMP_ALGS_STOC] <> 'none') then
  begin
    s := FConfig.GetConfig(guess[PROPOSAL_COMP_ALGS_STOC]);
    if (s <> '') then
    begin
      FreeAndNil(FInflater);
      FInflater := TclCompression(FConfig.CreateInstance(s));
      if (FInflater = nil) then
      begin
        RaiseSshError(AlgorithmNegotiationError, AlgorithmNegotiationErrorCode);
      end;

      FInflater.Init(ctInflater, 0);
    end;
  end else
  begin
    FreeAndNil(FInflater);
  end;
end;

procedure TclSshNetworkStream.UpdateProgress(ABytesProceed: Int64);
begin
end;

function TclSshNetworkStream.Write(AData: TStream): Boolean;
begin
  Result := True;

  if (AData <> nil) then
  begin
    while (Result and (AData.Position < AData.Size)) do
    begin
      if (FWriteData.Size = 0) then
      begin
        FWriteSize := GetBatchSize();
        if (FWriteSize > AData.Size - AData.Position) then
        begin
          FWriteSize := Integer(AData.Size - AData.Position);
        end;

        Result := WriteData(AData, FWriteSize);
        if (Result) then
        begin
          DoUpdateProgress(FWriteSize);
        end;
      end else
      begin
        Result := WriteData(nil, 0);
        if (Result) then
        begin
          DoUpdateProgress(FWriteSize);
        end;
      end;
    end;
  end else
  begin
    Result := WriteData(AData, 0);
  end;

  SetNextAction(FSshAction);
end;

function TclSshNetworkStream.WriteData(ASource: TStream; ALength: Integer): Boolean;
begin
  PrepareData(ASource, FWriteData);
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'WriteData, FWriteData.Position=%d, FWriteData.Size=%d', nil,
    [FWriteData.Position, FWriteData.Size]);{$ENDIF}
  Result := inherited Write(FWriteData);

  if (Result) then
  begin
    FWriteData.Size := 0;
  end;
end;

end.
