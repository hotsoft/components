{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clMC;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes,
{$ELSE}
  System.Classes,
{$ENDIF}
  clMailMessage, clTcpCommandClient, clEncoder;
 
type
  TclCustomMail = class(TclTcpCommandClient)
  private
    FMailMessage: TclMailMessage;
    FUseSasl: Boolean;
    FSaslOnly: Boolean;

    procedure SetUseSasl(const Value: Boolean);
    procedure SetMailMessage(const Value: TclMailMessage);
    procedure SetSaslOnly(const Value: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function GetOAuthChallenge: string;
    procedure SetAuthorization(const Value: string); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property UseSasl: Boolean read FUseSasl write SetUseSasl default False;
    property SaslOnly: Boolean read FSaslOnly write SetSaslOnly default False;
    property MailMessage: TclMailMessage read FMailMessage write SetMailMessage;
  end;

resourcestring
  AuthMethodInvalid = 'Unable to logon to the server using Secure Password Authentication';

const
  AuthMethodInvalidCode = -400;
  
implementation

{ TclCustomMail }

constructor TclCustomMail.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FUseSasl := False;
  FSaslOnly := False;
end;

function TclCustomMail.GetOAuthChallenge: string;
begin
  Result := 'user=' + UserName + #1 + 'auth=' + Authorization + #1#1;
  Result := TclEncoder.EncodeToString(Result, cmBase64);
end;

procedure TclCustomMail.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if  (AComponent = FMailMessage) and (Operation = opRemove) then
  begin
    FMailMessage := nil;
  end;
end;

procedure TclCustomMail.SetAuthorization(const Value: string);
begin
  if (Authorization <> Value) then
  begin
    if not (csLoading in ComponentState) then
    begin
      if (Value <> '') then
      begin
        UseSasl := True;
      end;
    end;

    inherited SetAuthorization(Value);
  end;
end;

procedure TclCustomMail.SetMailMessage(const Value: TclMailMessage);
begin
  if (FMailMessage <> Value) then
  begin
    if (FMailMessage <> nil) then
    begin
      FMailMessage.RemoveFreeNotification(Self);
    end;
    FMailMessage := Value;
    if (FMailMessage <> nil) then
    begin
      FMailMessage.FreeNotification(Self);
    end;
  end;
end;

procedure TclCustomMail.SetSaslOnly(const Value: Boolean);
begin
  if (FSaslOnly <> Value) then
  begin
    FSaslOnly := Value;
    Changed();
  end;
end;

procedure TclCustomMail.SetUseSasl(const Value: Boolean);
begin
  if (FUseSasl <> Value) then
  begin
    FUseSasl := Value;
    Changed();
  end;
end;

end.


