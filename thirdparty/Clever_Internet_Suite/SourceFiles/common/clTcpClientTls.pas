{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clTcpClientTls;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clTcpClient, clTlsSocket, clSocket, clCertificate, clCertificateStore, clSspi, clSspiTls, clSocketUtils;

type
  TclClientTlsMode = (ctNone, ctAutomatic, ctImplicit, ctExplicit);

  TclTcpClientTls = class(TclTcpClient)
  private
    FUseTLS: TclClientTlsMode;
    FCertificateFlags: TclCertificateVerifyFlags;
    FTLSFlags: TclTlsFlags;

    FOnGetCertificate: TclGetCertificateEvent;
    FOnVerifyServer: TclVerifyPeerEvent;
    FCSP: string;
    
    procedure SetCertificateFlags(const Value: TclCertificateVerifyFlags);
    procedure SetTLSFlags(const Value: TclTlsFlags);
    function GetIsTls: Boolean;
    procedure SetCSP(const Value: string);
  protected
    function GetNetworkStream: TclNetworkStream; override;

    procedure GetCertificate(Sender: TObject; var ACertificate: TclCertificate;
      AExtraCerts: TclCertificateList; var Handled: Boolean);
    procedure VerifyServer(Sender: TObject; ACertificate: TclCertificate;
      const AStatusText: string; AStatusCode: Integer; var AVerified: Boolean);
    function GetTlsStream: TclTlsNetworkStream;

    procedure SetUseTLS(const Value: TclClientTlsMode); virtual;

    procedure DoGetCertificate(var ACertificate: TclCertificate;
      AExtraCerts: TclCertificateList; var Handled: Boolean); dynamic;
    procedure DoVerifyServer(ACertificate: TclCertificate;
      const AStatusText: string; AStatusCode: Integer; var AVerified: Boolean); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    procedure StartTls; virtual;
    function ExplicitStartTls: Boolean;

    property IsTls: Boolean read GetIsTls;
  published    
    property UseTLS: TclClientTlsMode read FUseTLS write SetUseTLS default ctNone;
    property CertificateFlags: TclCertificateVerifyFlags read FCertificateFlags
      write SetCertificateFlags default [];
    property TLSFlags: TclTlsFlags read FTLSFlags write SetTLSFlags default [tfUseTLS];
    property CSP: string read FCSP write SetCSP;

    property OnGetCertificate: TclGetCertificateEvent read FOnGetCertificate write FOnGetCertificate;
    property OnVerifyServer: TclVerifyPeerEvent read FOnVerifyServer write FOnVerifyServer;
  end;

implementation

{$IFDEF LOGGER}
uses
  clLogger;
{$ENDIF}

{ TclTcpClientTls }

constructor TclTcpClientTls.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FUseTLS := ctNone;
  FTLSFlags := [tfUseTLS];
end;

procedure TclTcpClientTls.SetUseTLS(const Value: TclClientTlsMode);
begin
  if (FUseTLS <> Value) then
  begin
    FUseTLS := Value;
    Changed();
  end;
end;

function TclTcpClientTls.GetTlsStream: TclTlsNetworkStream;
begin
  Result := TclTlsNetworkStream.Create();
  Result.CertificateFlags := CertificateFlags;
  Result.TLSFlags := TLSFlags;
  Result.TargetName := Server;
  Result.CSP := CSP;
  Result.OnGetCertificate := GetCertificate;
  Result.OnVerifyPeer := VerifyServer;
end;

procedure TclTcpClientTls.DoGetCertificate(var ACertificate: TclCertificate;
  AExtraCerts: TclCertificateList; var Handled: Boolean);
begin
  if Assigned(OnGetCertificate) then
  begin
    OnGetCertificate(Self, ACertificate, AExtraCerts, Handled);
  end;
end;

procedure TclTcpClientTls.GetCertificate(Sender: TObject;
  var ACertificate: TclCertificate; AExtraCerts: TclCertificateList; var Handled: Boolean);
begin
  DoGetCertificate(ACertificate, AExtraCerts, Handled);
end;

function TclTcpClientTls.GetIsTls: Boolean;
begin
  Result := (Connection.NetworkStream is TclTlsNetworkStream);
end;

function TclTcpClientTls.GetNetworkStream: TclNetworkStream;
begin
  if ((UseTLS = ctAutomatic) and (Port <> GetDefaultPort())) or (UseTLS = ctImplicit) then
  begin
    Result := GetTlsStream();
  end else
  begin
    Result := inherited GetNetworkStream();
  end;
end;

function TclTcpClientTls.ExplicitStartTls: Boolean;
begin
  Result := ((UseTLS = ctAutomatic) and (Port = GetDefaultPort()))
    or (UseTLS = ctExplicit);

  if Result then
  begin
    StartTls();
  end;
end;

procedure TclTcpClientTls.StartTls;
begin
  if (UseTLS = ctNone) then
  begin
    UseTLS := ctExplicit;
  end;
  try
    Connection.NetworkStream := GetTlsStream();
    Connection.OpenSession();
  except
    InProgress := True;
    try
      Close();
    except
      on EclSocketError do ;
    end;
    InProgress := False;

    raise;
  end;
end;

procedure TclTcpClientTls.DoVerifyServer(ACertificate: TclCertificate;
  const AStatusText: string; AStatusCode: Integer; var AVerified: Boolean);
begin
  if Assigned(OnVerifyServer) then
  begin
    OnVerifyServer(Self, ACertificate, AStatusText, AStatusCode, AVerified);
  end;
end;

procedure TclTcpClientTls.VerifyServer(Sender: TObject; ACertificate: TclCertificate;
  const AStatusText: string; AStatusCode: Integer; var AVerified: Boolean);
begin
  DoVerifyServer(ACertificate, AStatusText, AStatusCode, AVerified);
end;

procedure TclTcpClientTls.SetCertificateFlags(const Value: TclCertificateVerifyFlags);
begin
  if (FCertificateFlags <> Value) then
  begin
    FCertificateFlags := Value;
    Changed();
  end;
end;

procedure TclTcpClientTls.SetCSP(const Value: string);
begin
  if (FCSP <> Value) then
  begin
    FCSP := Value;
    Changed();
  end;
end;

procedure TclTcpClientTls.SetTLSFlags(const Value: TclTlsFlags);
begin
  if (FTLSFlags <> Value) then
  begin
    FTLSFlags := Value;
    Changed();
  end;
end;

end.
