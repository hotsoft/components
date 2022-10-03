{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clTcpServerTls;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clTcpServer, clCertificate, clSspiTls, clCertificateStore;

type
  TclUserConnectionTls = class;

  TclVerifyClientEvent = procedure (Sender: TObject; AConnection: TclUserConnectionTls;
    ACertificate: TclCertificate; const AStatusText: string; AStatusCode: Integer;
    var AVerified: Boolean) of object;

  TclServerTlsMode = (stNone, stImplicit, stExplicitAllow, stExplicitRequire);

  TclUserConnectionTls = class(TclUserConnection)
  private
    FNeedStartTls: Boolean;

    function GetIsTls: Boolean;
  public
    constructor Create;

    property IsTls: Boolean read GetIsTls;
  end;

  TclTcpServerTls = class(TclTcpServer)
  private
    FUseTLS: TclServerTlsMode;
    FTLSFlags: TclTlsFlags;
    FRequireClientCertificate: Boolean;

    FOnGetCertificate: TclGetCertificateEvent;
    FOnVerifyClient: TclVerifyClientEvent;
    FCSP: string;

    procedure GetCertificate(Sender: TObject; var ACertificate: TclCertificate;
      AExtraCerts: TclCertificateList; var Handled: Boolean);
    procedure VerifyClient(Sender: TObject; ACertificate: TclCertificate;
      const AStatusText: string; AStatusCode: Integer; var AVerified: Boolean);
  protected
    procedure ReadConnection(AConnection: TclUserConnection); override;
    procedure AssignNetworkStream(AConnection: TclUserConnection); override;

    procedure InternalStartTls(AConnection: TclUserConnectionTls);
    procedure DoGetCertificate(var ACertificate: TclCertificate;
      AExtraCerts: TclCertificateList; var Handled: Boolean); virtual;
    procedure DoVerifyClient(AConnection: TclUserConnectionTls; ACertificate: TclCertificate;
      const AStatusText: string; AStatusCode: Integer; var AVerified: Boolean); virtual;
  public
    constructor Create(AOwner: TComponent); override;

    procedure AssignTlsStream(AConnection: TclUserConnectionTls);
    procedure StartTls(AConnection: TclUserConnectionTls);
  published
    property UseTLS: TclServerTlsMode read FUseTLS write FUseTLS default stNone;
    property TLSFlags: TclTlsFlags read FTLSFlags write FTLSFlags default [tfUseTLS];
    property CSP: string read FCSP write FCSP;
    property RequireClientCertificate: Boolean read FRequireClientCertificate write FRequireClientCertificate default False;

    property OnGetCertificate: TclGetCertificateEvent read FOnGetCertificate write FOnGetCertificate;
    property OnVerifyClient: TclVerifyClientEvent read FOnVerifyClient write FOnVerifyClient;
  end;

implementation

uses
  clSocket, clTlsSocket, clUtils{$IFDEF LOGGER}, clLogger{$ENDIF};

{ TclTcpServerTls }

procedure TclTcpServerTls.AssignNetworkStream(AConnection: TclUserConnection);
begin
  if (UseTLS = stImplicit) then
  begin
    AssignTlsStream(TclUserConnectionTls(AConnection));
  end else
  begin
    inherited AssignNetworkStream(AConnection);
  end;
end;

procedure TclTcpServerTls.AssignTlsStream(AConnection: TclUserConnectionTls);
var
  stream: TclTlsNetworkStream;
begin
  stream := TclTlsNetworkStream.Create();
  AConnection.NetworkStream := stream;
  stream.OnGetCertificate := GetCertificate;
  stream.OnVerifyPeer := VerifyClient;
  stream.TLSFlags := TLSFlags;
  stream.CSP := CSP;
  stream.RequireClientCertificate := RequireClientCertificate;
end;

constructor TclTcpServerTls.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FUseTLS := stNone;
  FTLSFlags := [tfUseTLS];
  FRequireClientCertificate := False;
end;

procedure TclTcpServerTls.DoVerifyClient(AConnection: TclUserConnectionTls;
  ACertificate: TclCertificate; const AStatusText: string; AStatusCode: Integer;
  var AVerified: Boolean);
begin
  if Assigned(OnVerifyClient) then
  begin
    OnVerifyClient(Self, AConnection, ACertificate, AStatusText, AStatusCode, AVerified);
  end;
end;

procedure TclTcpServerTls.DoGetCertificate(var ACertificate: TclCertificate;
  AExtraCerts: TclCertificateList; var Handled: Boolean);
begin
  if Assigned(OnGetCertificate) then
  begin
    OnGetCertificate(Self, ACertificate, AExtraCerts, Handled);
  end;
end;

procedure TclTcpServerTls.GetCertificate(Sender: TObject;
  var ACertificate: TclCertificate; AExtraCerts: TclCertificateList; var Handled: Boolean);
begin
  DoGetCertificate(ACertificate, AExtraCerts, Handled);
end;

procedure TclTcpServerTls.StartTls(AConnection: TclUserConnectionTls);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, 'StartTls');{$ENDIF}
  Assert(not AConnection.FNeedStartTls);
  AConnection.FNeedStartTls := True;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'StartTls'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'StartTls', E); raise; end; end;{$ENDIF}
end;

procedure TclTcpServerTls.InternalStartTls(AConnection: TclUserConnectionTls);
begin
{$IFDEF LOGGER}try clPutLogMessage(Self, edEnter, Format('(%d) InternalStartTls', [AConnection.Socket.Socket]));{$ENDIF}
  if AConnection.FNeedStartTls then
  begin
    AConnection.FNeedStartTls := False;
    {$IFDEF LOGGER}clPutLogMessage(Self, edInside, Format('(%d) InternalStartTls', [AConnection.Socket.Socket]));{$ENDIF}
    AssignTlsStream(AConnection);
    AConnection.OpenSession();
  end;
{$IFDEF LOGGER}clPutLogMessage(Self, edLeave, 'InternalStartTls'); except on E: Exception do begin clPutLogMessage(Self, edLeave, 'InternalStartTls', E); raise; end; end;{$ENDIF}
end;

procedure TclTcpServerTls.ReadConnection(AConnection: TclUserConnection);
begin
  InternalStartTls(TclUserConnectionTls(AConnection));
  inherited ReadConnection(AConnection);
end;

procedure TclTcpServerTls.VerifyClient(Sender: TObject; ACertificate: TclCertificate;
  const AStatusText: string; AStatusCode: Integer; var AVerified: Boolean);
var
  ns: TclNetworkStream;
begin
  ns := TclNetworkStream(Sender);
  DoVerifyClient(TclUserConnectionTls(ns.Connection), ACertificate, AStatusText, AStatusCode, AVerified);
end;

{ TclUserConnectionTls }

constructor TclUserConnectionTls.Create;
begin
  inherited Create();
  FNeedStartTls := False;
end;

function TclUserConnectionTls.GetIsTls: Boolean;
begin
  Result := (NetworkStream is TclTlsNetworkStream);
end;

end.
