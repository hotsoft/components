{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clTlsSocket;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Windows, Classes, SysUtils, SyncObjs,
{$ELSE}
  Winapi.Windows, System.Classes, System.SysUtils, System.SyncObjs,
{$ENDIF}
  clSocket, clSspi, clSspiTls, clCertificate, clCertificateStore;

type
  TclVerifyPeerEvent = procedure (Sender: TObject; ACertificate: TclCertificate;
    const AStatusText: string; AStatusCode: Integer; var AVerified: Boolean) of object;

  TclTlsNetworkStream = class(TclNetworkStream)
  private
    FReadData: TStream;
    FWriteData: TStream;
    FSSPIBuffer: TStream;
    FSSPI: TclTlsSspi;
    FSSPIResult: TclSspiReturnCode;
    FPacketSize: Integer;
    FNeedAuthenticate: Boolean;
    FWriteSize: Int64;
    FOnGetCertificate: TclGetCertificateEvent;
    FOnVerifyPeer: TclVerifyPeerEvent;
    FCertificateFlags: TclCertificateVerifyFlags;
    FTargetName: string;
    FTLSFlags: TclTlsFlags;
    FPeerVerified: Boolean;
    FRequireClientCertificate: Boolean;
    FSSPIAccess: TCriticalSection;
    FEncryptedBytesProceed: Int64;
    FCSP: string;

    procedure Authenticate(ADestination: TStream);
    procedure AfterRead(ABuffer, ADestination: TStream);
    function WriteBuffer(ABuffer: TStream; ABufferSize: Integer): Boolean;
    procedure DoUpdateProgress(ABytesProceed: Int64);
    procedure DoStreamReady;
    function GetSSPI: TclTlsSspi;
    procedure FreeSSPI;
    procedure VerifyPeer;
    procedure SetCertificateFlags(const Value: TclCertificateVerifyFlags);
    procedure SetTLSFlags(const Value: TclTlsFlags);
    procedure SetRequireClientCertificate(const Value: Boolean);
    procedure SetTargetName(const Value: string);
    function GetPacketSize: Integer;
    procedure SetCSP(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Assign(ASource: TclNetworkStream); override;
    procedure Close(ANotifyPeer: Boolean); override;
    procedure StreamReady; override;
    function Read(AData: TStream): Boolean; override;
    function Write(AData: TStream): Boolean; override;

    function GetReadBatchSize: Integer; override;
    function GetWriteBatchSize: Integer; override;

    function IsProceedLimit: Boolean; override;
    procedure InitProgress; override;
    procedure UpdateProgress(ABytesProceed: Int64); override;
    procedure InitClientSession; override;
    procedure InitServerSession; override;

    property SSPI: TclTlsSspi read GetSSPI;

    property TargetName: string read FTargetName write SetTargetName;
    property CertificateFlags: TclCertificateVerifyFlags read FCertificateFlags write SetCertificateFlags;
    property TLSFlags: TclTlsFlags read FTLSFlags write SetTLSFlags;
    property RequireClientCertificate: Boolean read FRequireClientCertificate write SetRequireClientCertificate;
    property CSP: string read FCSP write SetCSP;
    
    property OnGetCertificate: TclGetCertificateEvent read FOnGetCertificate write FOnGetCertificate;
    property OnVerifyPeer: TclVerifyPeerEvent read FOnVerifyPeer write FOnVerifyPeer;
  end;

resourcestring
  cReAuthNeeded = 'The connection must be re-negotiated';
  
implementation

uses
  clSocketUtils{$IFDEF LOGGER}, clLogger{$ENDIF};

{ TclTlsNetworkStream }

procedure TclTlsNetworkStream.Close(ANotifyPeer: Boolean);
begin
  ClearNextAction();

  FSSPIResult := rcOK;
  FSSPIBuffer.Size := 0;
  try
    FSSPIResult := SSPI.EndSession(FSSPIBuffer);
  except
    on EclSSPIError do;
  end;

  try
    if ANotifyPeer and (FSSPIResult = rcCompleteNeeded) then
    begin
      if not WriteBuffer(nil, 0) then
      begin
        SetNextAction(saWrite);
      end;
    end;
  except
    on EclSocketError do;
  end;
  FNeedAuthenticate := False;
  FSSPIResult := rcOK;
end;

constructor TclTlsNetworkStream.Create;
begin
  inherited Create();

  FSSPIAccess := TCriticalSection.Create();
  FReadData := TMemoryStream.Create();
  FWriteData := TMemoryStream.Create();
  FSSPIBuffer := TMemoryStream.Create();
  TLSFlags :=  [tfUseTLS];
  FTargetName := FloatToStr(Now);
end;

destructor TclTlsNetworkStream.Destroy;
begin
  FWriteData.Free();
  FReadData.Free();
  FSSPIBuffer.Free();
  FreeSSPI();
  FSSPIAccess.Free();

  inherited Destroy();
end;

procedure TclTlsNetworkStream.FreeSSPI;
begin
  FSSPIAccess.Enter();
  try
    FSSPI.Free();
    FSSPI := nil;
    FPeerVerified := False;
  finally
    FSSPIAccess.Leave();
  end;
end;

function TclTlsNetworkStream.GetReadBatchSize: Integer;
begin
  Result := inherited GetReadBatchSize() + GetPacketSize();
end;

function TclTlsNetworkStream.GetWriteBatchSize: Integer;
begin
  Result := inherited GetWriteBatchSize() + GetPacketSize();
end;

function TclTlsNetworkStream.GetPacketSize: Integer;
begin
  if (FPacketSize = 0) and (FSSPIResult = rcOK) then
  begin
    try
      FPacketSize := Integer(SSPI.StreamSizes.cbHeader + SSPI.StreamSizes.cbTrailer);
    except
      on EclSSPIError do ;
    end;
  end;
  Result := FPacketSize;
end;

function TclTlsNetworkStream.Read(AData: TStream): Boolean;
var
  oldPos: Int64;
  stream: TMemoryStream;
begin
  {$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Read');{$ENDIF}
  oldPos := -1;
  if (AData <> nil) then
  begin
    oldPos := AData.Position;
  end;

  try
    ClearNextAction();
    Result := True;

    if (FReadData.Size > 0) and (AData <> nil) then
    begin
      {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'Read: if (FSSPIResult = rcOK)');{$ENDIF}
      AData.CopyFrom(FReadData, 0);
      FReadData.Size := 0;
    end else
    begin
      {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'Read: else of if (FSSPIResult = rcOK)');{$ENDIF}
      if (AData = nil) then
      begin
        {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'Read: else of if (FSSPIResult = rcOK), (AData = nil)');{$ENDIF}
        AData := FReadData;
      end;

      stream := TMemoryStream.Create();
      try
        {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'Read: before inherited Read, %d', nil, [stream.Size]);{$ENDIF}
        inherited Read(stream);
        {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'Read: after inherited Read', stream, 0);{$ENDIF}
        if (stream.Size > 0) then
        begin
          stream.Position := 0;
          AfterRead(stream, AData);
        end;
      finally
        stream.Free();
      end;
    end;

    HasReadData := (FReadData.Size > 0);

    if (FSSPIResult = rcReAuthNeeded) then
    begin
      SetNextAction(saWrite);
    end else
    if not (FSSPIResult in [rcOK, rcError, rcClosingNeeded]) then
    begin
      SetNextAction(saRead);
    end;
  finally
    if (oldPos > -1) then
    begin
      DoUpdateProgress(AData.Size - oldPos);
    end;
  end;

  {$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Read'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Read', E); raise; end; end;{$ENDIF}
end;

function TclTlsNetworkStream.Write(AData: TStream): Boolean;
begin
  {$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Write');{$ENDIF}
  ClearNextAction();
  Result := True;

  if FNeedAuthenticate then
  begin
    FNeedAuthenticate := False;
    Authenticate(nil);

    if (FSSPIResult <> rcOK) then
    begin
      SetNextAction(saRead);
    end;
  end else
  if (AData <> nil) then
  begin
    while Result and (AData.Position < AData.Size) do
    begin
      if (FWriteData.Size = 0) then
      begin
        FWriteSize := AData.Size - AData.Position;
        if (FWriteSize > Connection.BatchSize) then //TODO check Connection.BatchSize vs GetWriteBatchSize
        begin
          FWriteSize := Connection.BatchSize;
        end;

        Result := WriteBuffer(AData, FWriteSize);
        if Result then
        begin
          DoUpdateProgress(FWriteSize);
          AData.Position := AData.Position + FWriteSize;
        end;
      end else
      begin
        Result := WriteBuffer(nil, 0);
        if Result then
        begin
          DoUpdateProgress(FWriteSize);
          AData.Position := AData.Position + FWriteSize;
        end;
      end;
    end;
  end else
  begin
    Result := WriteBuffer(nil, 0);
    if not Result then
    begin
      SetNextAction(saWrite);
    end;
  end;

  {$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Write'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Write', E); raise; end; end;{$ENDIF}
end;

procedure TclTlsNetworkStream.Authenticate(ADestination: TStream);
var
  cert: TclCertificate;
  certList: TclCertificateList;
  handled: Boolean;
begin
  {$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'Authenticate');{$ENDIF}
{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, 'Authenticate, FSSPIBuffer.Position = %d, FSSPIBuffer.Size = %d', nil, [FSSPIBuffer.Position, FSSPIBuffer.Size]);
{$ENDIF}

  certList := TclCertificateList.Create(False);
  try
    FPacketSize := 0;

    FSSPIResult := SSPI.GenContext(FSSPIBuffer, certList, False);
    if (FSSPIResult = rcCredentialNeeded) then
    begin
      cert := nil;
      handled := False;

      if Assigned(OnGetCertificate) then
      begin
{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, 'Authenticate, before OnGetCertificate');
{$ENDIF}
        OnGetCertificate(Self, cert, certList, handled);
{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, 'Authenticate, after OnGetCertificate');
{$ENDIF}
      end;

      if (cert <> nil) then
      begin
        certList.Add(cert);
      end;

      FSSPIResult := SSPI.GenContext(FSSPIBuffer, certList, True);
    end;

    if (FSSPIResult = rcCredentialNeeded) then
    begin
      RaiseSocketError(SSPIErrorQueryLocalCertificate, SSPI_E_QueryLocalCertificate);
    end;

    if (FSSPIResult in [rcOK, rcEncodeNeeded]) then
    begin
      VerifyPeer();
    end;

{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, 'Authenticate, before case FSSPIResult of, FSSPIBuffer.Position = %d, FSSPIBuffer.Size = %d', nil, [FSSPIBuffer.Position, FSSPIBuffer.Size]);
  clPutLogMessage(Self, edInside, 'Authenticate, before case FSSPIResult of, FSSPIResult = %s', nil, [clSspiReturnCodes[FSSPIResult]]);
{$ENDIF}
    
    case FSSPIResult of
      rcAuthContinueNeeded:
        begin
          if not WriteBuffer(nil, 0) then
          begin
            SetNextAction(saWrite);
          end;
          FSSPIResult := rcAuthDataNeeded;
        end;
      rcEncodeNeeded:
        begin
          AfterRead(FSSPIBuffer, ADestination);
          if (FSSPIResult <> rcMoreDataNeeded) and (FSSPIResult <> rcClosingNeeded) then
          begin
            FSSPIResult := rcOk;
          end;
        end;
      rcOK:
        begin
          if (SSPI is TclTlsServerSspi) then
          begin
            FSSPIResult := rcAuthContinueNeeded;
            if not WriteBuffer(nil, 0) then
            begin
              SetNextAction(saWrite);
            end;
            FSSPIResult := rcOk;
          end;
        end;
    end;
  finally
    certList.Free();
{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, 'Authenticate, inside finally, FSSPIBuffer.Position = %d, FSSPIBuffer.Size = %d', nil, [FSSPIBuffer.Position, FSSPIBuffer.Size]);
{$ENDIF}
    if not (FSSPIResult in [rcOK, rcAuthContinueNeeded, rcAuthMoreDataNeeded]) then
    begin
      FSSPIBuffer.Size := 0;
    end;
  end;
  if (FSSPIResult = rcOK) or (FSSPIResult = rcClosingNeeded) then
  begin
    DoStreamReady();
  end;
{$IFDEF LOGGER}
  clPutLogMessage(Self, edInside, 'Authenticate, before end, FSSPIBuffer.Position = %d, FSSPIBuffer.Size = %d', nil, [FSSPIBuffer.Position, FSSPIBuffer.Size]);
{$ENDIF}
  {$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'Authenticate'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'Authenticate', E); raise; end; end;{$ENDIF}
end;

procedure TclTlsNetworkStream.AfterRead(ABuffer, ADestination: TStream);
var
  oldPos: Int64;
begin
  {$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'AfterRead, ABuffer.Position = %d, ABuffer.Size = %d, FSSPIResult = %s', nil, [ABuffer.Position, ABuffer.Size, clSspiReturnCodes[FSSPIResult]]);{$ENDIF}

  case FSSPIResult of
    rcOk,
    rcAuthDataNeeded:
      begin
        FSSPIBuffer.Size := 0;
        FSSPIBuffer.CopyFrom(ABuffer, ABuffer.Size);
        FSSPIBuffer.Position := 0;
        if (FSSPIResult = rcAuthDataNeeded) then
        begin
          Authenticate(ADestination);
          {$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'AfterRead, %d, Authenticate exit', nil, [FSSPIBuffer.Size]);{$ENDIF}
          Exit;
        end;
      end;
    rcAuthMoreDataNeeded,
    rcMoreDataNeeded:
      begin
        oldPos := FSSPIBuffer.Position;
        FSSPIBuffer.Position := FSSPIBuffer.Size;
        FSSPIBuffer.CopyFrom(ABuffer, ABuffer.Size);
        FSSPIBuffer.Position := oldPos;

{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'AfterRead, oldPos = %d', nil, [oldPos]);{$ENDIF}
        
        if (FSSPIResult = rcAuthMoreDataNeeded) then
        begin
          Authenticate(ADestination);
          {$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'AfterRead, %d, Authenticate exit', nil, [FSSPIBuffer.Size]);{$ENDIF}
          Exit;
        end;
      end;
  end;

  Assert(ADestination <> nil);
  FSSPIResult := SSPI.Decrypt(FSSPIBuffer, ADestination, FSSPIBuffer);

  {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'AfterRead, FSSPI.Decrypt %s', nil, [clSspiReturnCodes[FSSPIResult]]);{$ENDIF}

  case FSSPIResult of
    rcOk: FSSPIBuffer.Size := 0;
    rcReAuthNeeded:
      begin
        FSSPIBuffer.Size := 0;
        FNeedAuthenticate := True;
      end;
    rcContinueAndMoreDataNeeded: FSSPIResult := rcMoreDataNeeded;
  end;

  if (FSSPIResult = rcClosingNeeded) then
  begin
    {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'AfterRead: Self.NeedClose := True');{$ENDIF}
    NeedClose := True;
  end;

  {$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'AfterRead, %d', nil, [ADestination.Size]);{$ENDIF}
  {$IFDEF LOGGER}
    clPutLogMessage(Self, edLeave, 'AfterRead, %d', nil, [FSSPIBuffer.Size]);
      except on E: Exception do begin clPutLogMessage(Self, edLeave, 'AfterRead, %d', E, [FSSPIBuffer.Size]); raise; end; end;
  {$ENDIF}
end;

function TclTlsNetworkStream.WriteBuffer(ABuffer: TStream; ABufferSize: Integer): Boolean;
begin
  if (FWriteData.Size = 0) then
  begin
    if not (FSSPIResult in [rcCompleteNeeded, rcAuthContinueNeeded]) then
    begin
      Assert(ABuffer <> nil);

      FSSPIBuffer.Size := 0;
      SSPI.Encrypt(ABuffer, FSSPIBuffer, ABufferSize);

      FWriteData.CopyFrom(FSSPIBuffer, FSSPIBuffer.Size);
      FSSPIBuffer.Position := 0;
    end else
    begin
      Assert(ABuffer = nil);
      FWriteData.CopyFrom(FSSPIBuffer, FSSPIBuffer.Size);
      FSSPIBuffer.Size := 0;
    end;
    FWriteData.Position := 0;
  end;

  Result := inherited Write(FWriteData);

  if Result then
  begin
    FWriteData.Size := 0;
  end;
end;

procedure TclTlsNetworkStream.UpdateProgress(ABytesProceed: Int64);
begin
{$IFDEF LOGGER}clPutLogMessage(Self, edInside, 'UpdateProgress, FEncryptedBytesProceed=%d, ABytesProceed=%d', nil, [FEncryptedBytesProceed, ABytesProceed]);{$ENDIF}
  FEncryptedBytesProceed := FEncryptedBytesProceed + ABytesProceed;
end;

procedure TclTlsNetworkStream.DoUpdateProgress(ABytesProceed: Int64);
begin
  inherited UpdateProgress(ABytesProceed);
end;

function TclTlsNetworkStream.GetSSPI: TclTlsSspi;
begin
  FSSPIAccess.Enter();
  try
    Result := FSSPI;
    Assert(Result <> nil);
  finally
    FSSPIAccess.Leave();
  end;
end;

function TclTlsNetworkStream.IsProceedLimit: Boolean;
begin
  Result := inherited IsProceedLimit()
    or ((Connection.BytesToProceed > -1) and (Connection.BytesToProceed <= FEncryptedBytesProceed));
end;

procedure TclTlsNetworkStream.StreamReady;
begin
end;

procedure TclTlsNetworkStream.DoStreamReady;
begin
  inherited StreamReady();
end;

procedure TclTlsNetworkStream.VerifyPeer;
var
  statusText: string;
begin
  if FPeerVerified then Exit;

  FPeerVerified := SSPI.Certified;
  statusText := GetSSPIErrorMessage(SSPI.StatusCode);
  if Assigned(OnVerifyPeer) then
  begin
    OnVerifyPeer(Self, SSPI.PeerCertificate, statusText, SSPI.StatusCode, FPeerVerified);
  end;

  if not FPeerVerified then
  begin
    RaiseSocketError(statusText, SSPI.StatusCode);
  end;
end;

procedure TclTlsNetworkStream.InitClientSession;
begin
  FSSPIAccess.Enter();
  try
    FreeSSPI();
    FSSPI := TclTlsClientSspi.Create();
    TclTlsClientSspi(FSSPI).TargetName := TargetName;
    FSSPI.CertificateFlags := CertificateFlags;
    FSSPI.TLSFlags := TLSFlags;
    FSSPI.CSP := CSP;

    FSSPIBuffer.Size := 0;
    FNeedAuthenticate := True;
    SetNextAction(saWrite);
  finally
    FSSPIAccess.Leave();
  end;
end;

procedure TclTlsNetworkStream.InitServerSession;
begin
  FSSPIAccess.Enter();
  try
    FreeSSPI();
    FSSPI := TclTlsServerSspi.Create();
    TclTlsServerSspi(FSSPI).RequireClientCertificate := RequireClientCertificate;
    FSSPI.CertificateFlags := CertificateFlags;
    FSSPI.TLSFlags := TLSFlags;
    FSSPI.CSP := CSP;

    FSSPIBuffer.Size := 0;
    FSSPIResult := rcAuthDataNeeded;
    FNeedAuthenticate := False;
    SetNextAction(saRead);
  finally
    FSSPIAccess.Leave();
  end;
end;

procedure TclTlsNetworkStream.InitProgress;
begin
  inherited InitProgress();
  FEncryptedBytesProceed := 0;
end;

procedure TclTlsNetworkStream.SetCertificateFlags(const Value: TclCertificateVerifyFlags);
begin
  FCertificateFlags := Value;
  if (FSSPI <> nil) then
  begin
    FSSPI.CertificateFlags := FCertificateFlags;
  end;
end;

procedure TclTlsNetworkStream.SetCSP(const Value: string);
begin
  FCSP := Value;
  if (FSSPI <> nil) then
  begin
    FSSPI.CSP := FCSP;
  end;
end;

procedure TclTlsNetworkStream.SetRequireClientCertificate(const Value: Boolean);
begin
  FRequireClientCertificate := Value;
  if (FSSPI <> nil) and (FSSPI is TclTlsServerSspi) then
  begin
    TclTlsServerSspi(FSSPI).RequireClientCertificate := FRequireClientCertificate;
  end;
end;

procedure TclTlsNetworkStream.SetTargetName(const Value: string);
begin
  FTargetName := Value;
  if (FSSPI <> nil) and (FSSPI is TclTlsClientSspi) then
  begin
    TclTlsClientSspi(FSSPI).TargetName := FTargetName;
  end;
end;

procedure TclTlsNetworkStream.SetTLSFlags(const Value: TclTlsFlags);
begin
  FTLSFlags := Value;
  if (FSSPI <> nil) then
  begin
    FSSPI.TLSFlags := FTLSFlags;
  end;
end;

procedure TclTlsNetworkStream.Assign(ASource: TclNetworkStream);
var
  src: TclTlsNetworkStream;
begin
  inherited Assign(ASource);

  if (ASource is TclTlsNetworkStream) then
  begin
    src := ASource as TclTlsNetworkStream;
    FTargetName := src.TargetName;
    FCertificateFlags := src.CertificateFlags;
    FTLSFlags := src.TLSFlags;
    FRequireClientCertificate := src.RequireClientCertificate;
    FCSP := src.CSP;
  end;
end;

end.
