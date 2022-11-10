{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSshUserKey;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clUtils;

type
  TclSshUserKey = class(TPersistent)
  private
    FPrivateKey: TclByteArray;
    FPrivateKeyFile: string;
    FOnChanged: TNotifyEvent;
    FPassPhrase: string;

    procedure SetPrivateKeyFile(const Value: string);
    procedure SetPassPhrase(const Value: string);
    procedure InternalLoad;
    function DecodePrivateKey(const AValue: TclByteArray): TclByteArray;
  protected
    procedure Init; virtual;
    procedure Changed; virtual;
  public
    constructor Create;

    procedure Assign(Source: TPersistent); override;
    procedure Clear; virtual;

    function GetPrivateKey: TclByteArray; virtual;

    procedure Load(APrivateKey: TStrings); overload;
    procedure Load(APrivateKey: TStream); overload;
    procedure Load(const APrivateKey: TclByteArray); overload; virtual;

    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  published
    property PrivateKeyFile: string read FPrivateKeyFile write SetPrivateKeyFile;
    property PassPhrase: string read FPassPhrase write SetPassPhrase;
  end;

implementation

uses
  clCryptEncoder, clCryptUtils, clStreams;

{ TclSshUserKey }

procedure TclSshUserKey.Assign(Source: TPersistent);
var
  src: TclSshUserKey;
begin
  if (Source is TclSshUserKey) then
  begin
    src := TclSshUserKey(Source);

    FPrivateKeyFile := src.PrivateKeyFile;
    FPassPhrase := src.PassPhrase;

    Changed();
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclSshUserKey.Changed;
begin
  Init();

  if Assigned(OnChanged) then
  begin
    OnChanged(Self);
  end;
end;

procedure TclSshUserKey.InternalLoad;
var
  priv: TStream;
begin
  if (FPrivateKey = nil) and (PrivateKeyFile <> '') then
  begin
    priv := TFileStream.Create(PrivateKeyFile, fmOpenRead or fmShareDenyWrite);
    try
      Load(priv);
    finally
      priv.Free();
    end;
  end;
end;

procedure TclSshUserKey.Clear;
begin
  FPrivateKeyFile := '';
  FPassPhrase := '';

  Changed();
end;

constructor TclSshUserKey.Create;
begin
  inherited Create();

  Init();
end;

function TclSshUserKey.GetPrivateKey: TclByteArray;
begin
  InternalLoad();
  Result := FPrivateKey;
end;

procedure TclSshUserKey.Init;
begin
  FPrivateKey := nil;
end;

procedure TclSshUserKey.Load(APrivateKey: TStrings);
var
  priv: TStream;
begin
  priv := nil;
  try
    priv := TMemoryStream.Create();
    APrivateKey.SaveToStream(priv);
    priv.Position := 0;

    Load(priv);
  finally
    priv.Free();
  end;
end;

procedure TclSshUserKey.Load(const APrivateKey: TclByteArray);
begin
  Init();
  FPrivateKey := APrivateKey;
end;

procedure TclSshUserKey.SetPassPhrase(const Value: string);
begin
  if (FPassPhrase <> Value) then
  begin
    FPassPhrase := Value;
    Changed();
  end;
end;

procedure TclSshUserKey.SetPrivateKeyFile(const Value: string);
begin
  if (FPrivateKeyFile <> Value) then
  begin
    FPrivateKeyFile := Value;
    Changed();
  end;
end;

function TclSshUserKey.DecodePrivateKey(const AValue: TclByteArray): TclByteArray;
var
  encoder: TclCryptEncoder;
begin
  encoder := TclCryptEncoder.Create(nil);
  try
    encoder.PassPhrase := PassPhrase;

    Result := encoder.Decode(AValue);

    if not (encoder.DataType in [dtRsaPrivateKey]) then
    begin
      RaiseCryptError(UnknownKeyFormat, UnknownKeyFormatCode);
    end;
  finally
    encoder.Free();
  end;
end;

procedure TclSshUserKey.Load(APrivateKey: TStream);
var
  priv: TclByteArray;
  len: Integer;
begin
  len := Integer(APrivateKey.Size - APrivateKey.Position);
  if (len > 0) then
  begin
    SetLength(priv, len);
    APrivateKey.Read(priv[0], Length(priv));
    priv := DecodePrivateKey(priv);
  end else
  begin
    priv := nil;
  end;

  Load(priv);
end;

end.
