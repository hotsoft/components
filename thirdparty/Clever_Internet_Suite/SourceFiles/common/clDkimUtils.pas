{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clDkimUtils;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clHeaderFieldList, clWUtils;

type
  EclDkimError = class(Exception)
  private
    FErrorCode: Integer;
  public
    constructor Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean = False);
    property ErrorCode: Integer read FErrorCode;
  end;

  TclDkimQuotedPrintableEncoder = class
  public
    class function Encode(const ASource: string): string;
    class function Decode(const ASource: string): string;
  end;

  TclDkimHeaderFieldList = class(TclHeaderFieldList)
  private
    FLastFieldIndices: TStrings;

    function GetLastFieldIndex(const AName: string): Integer;
    procedure AddLastFieldIndex(const AName: string; AFieldIndex: Integer);
  protected
    function GetItemDelimiters: TCharSet; override;
    function InternalGetFieldValue(AIndex: Integer): string; override;
  public
    constructor Create;
    destructor Destroy; override;

    function NextFieldIndex(const AName: string): Integer;
    procedure ResetFieldIndex;
  end;

resourcestring
  DkimInvalidFormat = 'The format of the DKIM-Signature header field is ivalid';
  DkimInvalidSignatureParameters = 'There are errors in signature parameters';
  DkimInvalidSignatureAlgorihm = 'The SignatureAlgorithm is invalid';
  DkimVerifyBodyHashFailed = 'Body hash values differ';
  DkimInvalidVersion = 'The version of the DKIM-Signature is unknown';
  DkimKeyRequired = 'The key is required to complete the operation';
  DkimSelectorRequired = 'The Selector is required to complete the operation';
  DkimDomainRequired = 'The Domain is required to complete the operation';
  DkimKeyRevoked = 'The key is revoked';
  DkimInvalidKey = 'The publik key is invalid or has wrong parameters';

const
  DkimInvalidFormatCode = -10;
  DkimInvalidSignatureParametersCode = -11;
  DkimInvalidSignatureAlgorihmCode = -12;
  DkimVerifyBodyHashFailedCode = -13;
  DkimInvalidVersionCode = -14;
  DkimKeyRequiredCode = -15;
  DkimSelectorRequiredCode = -16;
  DkimDomainRequiredCode = -17;
  DkimKeyRevokedCode = -18;
  DkimInvalidKeyCode = -19;

implementation

uses
  clTranslator, clUtils;

{ EclDkimError }

constructor EclDkimError.Create(const AErrorMsg: string; AErrorCode: Integer; ADummy: Boolean);
begin
  inherited Create(AErrorMsg);
  FErrorCode := AErrorCode;
end;

{ TclDkimQuotedPrintableEncoder }

class function TclDkimQuotedPrintableEncoder.Decode(const ASource: string): string;
var
  next: PChar;
  hexNumber: Integer;
  isDelimiter, isCodePresent: Boolean;
begin
  Result := '';
  if (Length(ASource) = 0) then Exit;

  isDelimiter := False;
  isCodePresent := False;
  hexNumber := 0;
  next := @ASource[1];
  while (next^ <> #0) do
  begin
    if (isDelimiter) then
    begin
      case (next^) of
      'A'..'F':
        begin
          hexNumber := hexNumber + (Ord(next^) - 55);
        end;
      '0'..'9':
        begin
          hexNumber := hexNumber + (Ord(next^) - 48);
        end;
      else
        begin
          isCodePresent := False;
          isDelimiter := False;
          hexNumber := 0;
          Result := Result + '=' + next^;
        end;
      end;

      if (not isCodePresent) then
      begin
        hexNumber := hexNumber * 16;
        isCodePresent := True;
      end else
      begin
        Result := Result + Chr(hexNumber);
        isCodePresent := False;
        isDelimiter := False;
        hexNumber := 0;
      end;
    end else
    if (next^ = '=') then
    begin
      isDelimiter := True;
    end else
    begin
      Result := Result + next^;
    end;

    Inc(next);
  end;
end;

class function TclDkimQuotedPrintableEncoder.Encode(const ASource: string): string;
var
  i: Integer;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  Result := '';
  if (Length(ASource) = 0) then Exit;

  buf := TclTranslator.GetBytes(ASource, 'us-ascii');

  for i := 0 to Length(buf) - 1 do
  begin
    case (buf[i]) of
      $21..$3A,$3C,$3E..$7E: Result := Result + Chr(buf[i]);
    else
      Result := Result + Format('=%2.2X', [buf[i]]);
    end;
  end;
end;

{ TclDkimHeaderFieldList }

constructor TclDkimHeaderFieldList.Create;
begin
  inherited Create();
  FLastFieldIndices := TStringList.Create();
end;

destructor TclDkimHeaderFieldList.Destroy;
begin
  FLastFieldIndices.Free();
  inherited Destroy();
end;

function TclDkimHeaderFieldList.InternalGetFieldValue(AIndex: Integer): string;
var
  Ind, i: Integer;
begin
  Assert(Source <> nil);

  if (AIndex > -1) and (AIndex < FieldList.Count) then
  begin
    Ind := GetFieldStart(AIndex);
    Result := Trim(System.Copy(Source[Ind], Length(FieldList[AIndex] + ':') + 1, MaxInt));
    for i := Ind + 1 to Source.Count - 1 do
    begin
      if not ((Source[i] <> '') and CharInSet(Source[i][1], [#9, #32])) then
      begin
        Break;
      end;
      Result := Result + Trim(Source[i]);
    end;
  end else
  begin
    Result := '';
  end;
end;

function TclDkimHeaderFieldList.GetItemDelimiters: TCharSet;
begin
  Result := [';'];
end;

function TclDkimHeaderFieldList.GetLastFieldIndex(const AName: string): Integer;
begin
  Result := FLastFieldIndices.IndexOf(AName);
  if (Result > -1) then
  begin
    Result := Integer(FLastFieldIndices.Objects[Result]);
  end;
end;

procedure TclDkimHeaderFieldList.AddLastFieldIndex(const AName: string; AFieldIndex: Integer);
var
  ind: Integer;
begin
  ind := FLastFieldIndices.IndexOf(AName);
  if (ind > -1) then
  begin
    FLastFieldIndices.Objects[ind] := TObject(AFieldIndex);
  end else
  begin
    FLastFieldIndices.AddObject(AName, TObject(AFieldIndex));
  end;
end;

function TclDkimHeaderFieldList.NextFieldIndex(const AName: string): Integer;
var
  i, startFrom: Integer;
  name: string;
begin
  name := Trim(LowerCase(AName));
  startFrom := GetLastFieldIndex(name);

  if (startFrom > -1) then
  begin
    Dec(startFrom);
  end else
  begin
    startFrom := FieldList.Count - 1;
  end;

  Result := -1;

  for i := startFrom downto 0 do
  begin
    if (FieldList[i] = name) then
    begin
      Result := i;
      AddLastFieldIndex(name, Result);
      Exit;
    end;
  end;
end;

procedure TclDkimHeaderFieldList.ResetFieldIndex;
begin
  FLastFieldIndices.Clear();
end;

end.
