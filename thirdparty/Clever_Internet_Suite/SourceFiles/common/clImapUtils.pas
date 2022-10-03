{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clImapUtils;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils;
{$ELSE}
  System.Classes, System.SysUtils;
{$ENDIF}

type
  TclImap4ConnectionState = (csNonAuthenticated, csAuthenticated, csSelected);

  TclMailMessageFlag = (mfAnswered, mfFlagged, mfDeleted, mfSeen, mfDraft, mfRecent);
  TclMailMessageFlags = set of TclMailMessageFlag;

  TclSetFlagsMethod = (fmReplace, fmAdd, fmRemove);

  TclImap4MailBoxInfo = class
  private
    FName: string;
    FRecentMessages: Integer;
    FFirstUnseen: Integer;
    FExistsMessages: Integer;
    FReadOnly: Boolean;
    FFlags: TclMailMessageFlags;
    FChangeableFlags: TclMailMessageFlags;
    FUIDValidity: string;
    FUIDNext: Integer;
    FUnseenMessages: Integer;
  public
    constructor Create;
    procedure Clear; virtual;
    procedure Assign(ASource: TclImap4MailBoxInfo); virtual;
    property Name: string read FName write FName;
    property ExistsMessages: Integer read FExistsMessages write FExistsMessages;
    property RecentMessages: Integer read FRecentMessages write FRecentMessages;
    property UnseenMessages: Integer read FUnseenMessages write FUnseenMessages;
    property FirstUnseen: Integer read FFirstUnseen write FFirstUnseen;
    property ReadOnly: Boolean read FReadOnly write FReadOnly;
    property Flags: TclMailMessageFlags read FFlags write FFlags;
    property ChangeableFlags: TclMailMessageFlags read FChangeableFlags write FChangeableFlags;
    property UIDValidity: string read FUIDValidity write FUIDValidity;
    property UIDNext: Integer read FUIDNext write FUIDNext;
  end;

function GetStrByImapMessageFlags(AFlags: TclMailMessageFlags): string;
function GetImapMessageFlagsByStr(const AText: string): TclMailMessageFlags;
function ExtractMessageSize(const ASource: string): Int64;
procedure ParseMailboxInfo(const AMailBoxInfo: string; var ASeparator: Char; var AName: string);
function DateTimeToImapTime(ADate: TDateTime): string;
function IsInState(ACurrentState: TclImap4ConnectionState;
  ACheckStates: array of TclImap4ConnectionState): Boolean;

implementation

uses
  clUtils;
  
function GetStrByImapMessageFlags(AFlags: TclMailMessageFlags): string;
const
  flagLexems: array[TclMailMessageFlag] of string =
    ('\Answered', '\Flagged', '\Deleted', '\Seen', '\Draft', '\Recent');
var
  flag: TclMailMessageFlag;
begin
  Result := '';
  for flag := Low(TclMailMessageFlag) to High(TclMailMessageFlag) do
  begin
    if (flag in AFlags) then
    begin
      Result := Result + ' ' + flagLexems[flag];
    end;
  end;
  Result := Trim(Result);
end;

function GetImapMessageFlagsByStr(const AText: string): TclMailMessageFlags;
begin
  Result := [];
  if (System.Pos('\ANSWERED', AText) > 0) then
    Result := Result + [mfAnswered];
  if (System.Pos('\FLAGGED', AText) > 0) then
    Result := Result + [mfFlagged];
  if (System.Pos('\DELETED', AText) > 0) then
    Result := Result + [mfDeleted];
  if (System.Pos('\SEEN', AText) > 0) then
    Result := Result + [mfSeen];
  if (System.Pos('\DRAFT', AText) > 0) then
    Result := Result + [mfDraft];
  if (System.Pos('\RECENT', AText) > 0) then
    Result := Result + [mfRecent];
end;

function ExtractMessageSize(const ASource: string): Int64;
var
  indEnd, indStart: Integer;
begin
  Result := 0;

  indEnd := RTextPos('}', ASource);
  if (indEnd = 0) then Exit;

  indStart := RTextPos('{', ASource, indEnd);
  if (indStart = 0) then Exit;

  Result := StrToInt64Def(system.Copy(ASource, indStart + 1, indEnd - indStart - 1), 0);
end;

procedure ParseMailboxInfo(const AMailBoxInfo: string; var ASeparator: Char; var AName: string);
var
  ind: Integer;
begin
  ASeparator := #0;
  AName := '';

  ind := System.Pos(')', AMailBoxInfo);
  if (ind > 0) then
  begin
    AName := Trim(System.Copy(AMailBoxInfo, ind + 1, MaxInt));
    if (AName <> '') and (AName[1] = '"') then
    begin
      if ((AName[2] = '\') and (Length(AName) > 2) and (AName[3] <> '"')) then
      begin
        ASeparator := AName[3];
      end else
      begin
        ASeparator := AName[2];
      end;
    end;

    ind := System.Pos(' ', AName);
    if (ind > 0) then
    begin
      AName := Trim(System.Copy(AName, ind + 1, MaxInt));
    end;

    AName := ExtractQuotedString(AName, '"');
  end;
end;

function DateTimeToImapTime(ADate: TDateTime): string;
var
  Year, Month, Day, Hour, Min, Sec, MSec: Word;
  MonthName: String;
begin
  DecodeDate(ADate, Year, Month, Day);
  DecodeTime(ADate, Hour, Min, Sec, MSec);
  MonthName := cMonths[Month];
  Result := Format('%d-%s-%d %d:%.2d:%.2d %s', [Day, MonthName, Year, Hour, Min, Sec, TimeZoneBiasString]);
end;

function IsInState(ACurrentState: TclImap4ConnectionState;
  ACheckStates: array of TclImap4ConnectionState): Boolean;
var
  i: Integer;
begin
  for i := Low(ACheckStates) to High(ACheckStates) do
  begin
    Result := (ACurrentState = ACheckStates[i]);
    if Result then Exit;
  end;
  Result := False;
end;

{ TclImap4MailBoxInfo }

procedure TclImap4MailBoxInfo.Assign(ASource: TclImap4MailBoxInfo);
begin
  Assert(ASource <> nil);
  
  FName := ASource.Name;
  FRecentMessages := ASource.RecentMessages;
  FFirstUnseen := ASource.FirstUnseen;
  FExistsMessages := ASource.ExistsMessages;
  FReadOnly := ASource.ReadOnly;
  FFlags := ASource.Flags;
  FChangeableFlags := ASource.ChangeableFlags;
  FUIDValidity := ASource.UIDValidity;
  FUIDNext := ASource.UIDNext;
  FUnseenMessages := ASource.UnseenMessages;
end;

procedure TclImap4MailBoxInfo.Clear;
begin
  FName := '';
  FRecentMessages := 0;
  FUnseenMessages := 0;
  FFirstUnseen := 0;
  FExistsMessages := 0;
  FReadOnly := False;
  FFlags := [];
  FChangeableFlags := [];
  FUIDValidity := '';
  FUIDNext := 0;
end;

constructor TclImap4MailBoxInfo.Create;
begin
  inherited Create();
  Clear();
end;

end.
