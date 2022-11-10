{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clMailUtils;

interface

{$I clVer.inc}

const
  DefaultPop3Port = 110;
  DefaultSmtpPort = 25;
  DefaultImapPort = 143;
  DefaultMailAgent = 'Clever Internet Suite';

function GenerateMessageID(const AHostName: string): string;
function GenerateCramMD5Key(const AHostName: string): string;
function GetIdnEmail(const AEmail: string): string;

implementation

uses
{$IFNDEF DELPHIXE2}
  Windows, SysUtils,
{$ELSE}
  Winapi.Windows, System.SysUtils,
{$ENDIF}
  clSocket, clIdnTranslator;

var
  MessageCounter: Integer = 0;

function GenerateMessageID(const AHostName: string): string;
var
  y, mm, d, h, m, s, ms: Word;
begin
  DecodeTime(Now(), h, m, s, ms);
  DecodeDate(Date(), y, mm, d);
  Result := IntToHex(mm, 2) + IntToHex(d, 2) + IntToHex(h, 2)
    + IntToHex(m, 2) + IntToHex(s, 2) + IntToHex(ms, 2);
  InterlockedIncrement(MessageCounter);
  Result := '<' + IntToHex(Integer(GetTickCount()), 8)
    + system.Copy(Result, 1, 12)
    + IntToHex(MessageCounter, 3) + IntToHex(MessageCounter * 2, 3) + '@'
    + AHostName + '>';
end;

function GenerateCramMD5Key(const AHostName: string): string;
var
  y, mm, d, h, m, s, ms: Word;
begin
  DecodeTime(Now(), h, m, s, ms);
  DecodeDate(Date(), y, mm, d);
  Result := Format('<INETSUITE-F%d%d%d%d%d.%s@%s>',
    [y, mm, d, h, m, IntToHex(m, 3) + IntToHex(s, 3) + IntToHex(ms, 3) + IntToHex(Random(100), 5),
    AHostName]);
end;

function GetIdnEmail(const AEmail: string): string;
var
  ind: Integer;
begin
  Result := AEmail;

  ind := system.Pos('@', Result);
  if (ind > 0) then
  begin
    Result := TclIdnTranslator.GetAsciiText(System.Copy(Result, 1, ind - 1)) + '@'
      + TclIdnTranslator.GetAscii(System.Copy(Result, ind + 1, Length(Result)));
  end;
end;

end.


