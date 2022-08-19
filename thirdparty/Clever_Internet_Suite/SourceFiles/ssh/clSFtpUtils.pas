{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSFtpUtils;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, DateUtils,
{$ELSE}
  System.Classes, System.SysUtils, System.DateUtils,
{$ENDIF}
  clSocketUtils, clUtils, clSshPacket, clTranslator;

type
  EclSFtpClientError = class(EclSocketError)
  public
    class function GetSFtpStatusText(AStatusCode: Integer): string;
  end;

  TclSFtpFilePermission = (
    fpUserIDExec, fpGroupIDExec, fpStickyBit,
    fpOwnerRead, fpOwnerWrite, fpOwnerExec,
    fpGroupRead, fpGroupWrite, fpGroupExec,
    fpOtherRead, fpOtherWrite, fpOtherExec
  );
  TclSFtpFilePermissions = set of TclSFtpFilePermission;

  TclSFtpFileAttrs = class
  private
    FFlags: Integer;
    FSize: Int64;
    FUid: Integer;
    FGid: Integer;
    FPermissions: TclSFtpFilePermissions;
    FAccessTime: TDateTime;
    FModifyTime: TDateTime;
    FExtended: TStrings;
    function GetIsDir: Boolean;
  public
    constructor Create; overload;
    constructor Create(APacket: TclPacket); overload;
    destructor Destroy; override;

    class function IntToFilePermissions(APermissions: Integer): TclSFtpFilePermissions;
    class function FilePermissionsToInt(APermissions: TclSFtpFilePermissions): Integer;
    class function IntToDateTime(ADate: Integer): TDateTime;
    class function DateTimeToInt(ADate: TDateTime): Integer;

    procedure Clear; virtual;
    procedure Load(APacket: TclPacket); virtual;
    procedure Save(APacket: TclPacket); virtual;
    function SavedLength: Integer; virtual;

    procedure SetSize(ASize: Int64);
    procedure SetUidGid(AUid, AGid: Integer);
    procedure SetDate(AAccessTime, AModifyTime: Integer); overload;
    procedure SetDate(AAccessTime, AModifyTime: TDateTime); overload;
    procedure SetPermissions(APermissions: TclSFtpFilePermissions);
    procedure SetExtended(AExtended: TStrings);

    property Flags: Integer read FFlags;
    property Size: Int64 read FSize;
    property Uid: Integer read FUid;
    property Gid: Integer read FGid;
    property Permissions: TclSFtpFilePermissions read FPermissions;
    property AccessTime: TDateTime read FAccessTime;
    property ModifyTime: TDateTime read FModifyTime;
    property Extended: TStrings read FExtended;
    property IsDir: Boolean read GetIsDir;
  end;

resourcestring
  SFtpVersionError = 'Cannot receive SFTP protocol version';
  SFtpUnknownStatus = 'Unknown status code';
  SFtpPathError = 'Path operation failed';
  SFtpError = 'Operation failed';
  SFtpExtendedAttrError = 'Invalid extended attribute format';
  SFtpOldVersionError = 'The server is too old to support rename operation';

const
	SFtpStatusText: array[0..8] of string = (
			'OK', 'EOF', 'No such file', 'Permission Denied', 'Failure', 'Bad message', 'No connection', 'Connection lost', 'Unsupported operation'
		);

  SFtpVersionErrorCode = -101;
  SFtpPathErrorCode = -102;
  SFtpExtendedAttrErrorCode = -103;
  SFtpOldVersionErrorCode = -104;

  SFtpFilePermissions: array[TclSFtpFilePermission] of Integer = (
    $00000800, $00000400, $00000200,
    $00000100, $00000080, $00000040,
    $00000020, $00000010, $00000008,
    $00000004, $00000002, $00000001
  );

  S_IFDIR = $4000;

  SSH_FX_OK = 0;
  SSH_FX_EOF = 1;
  SSH_FX_NO_SUCH_FILE = 2;
  SSH_FX_PERMISSION_DENIED = 3;
  SSH_FX_FAILURE = 4;
  SSH_FX_BAD_MESSAGE = 5;
  SSH_FX_NO_CONNECTION = 6;
  SSH_FX_CONNECTION_LOST = 7;
  SSH_FX_OP_UNSUPPORTED = 8;

  SSH_FXP_INIT = 1;
  SSH_FXP_VERSION = 2;
  SSH_FXP_OPEN = 3;
  SSH_FXP_CLOSE = 4;
  SSH_FXP_READ = 5;
  SSH_FXP_WRITE = 6;
  SSH_FXP_LSTAT = 7;
  SSH_FXP_FSTAT = 8;
  SSH_FXP_SETSTAT = 9;
  SSH_FXP_FSETSTAT = 10;
  SSH_FXP_OPENDIR = 11;
  SSH_FXP_READDIR = 12;
  SSH_FXP_REMOVE = 13;
  SSH_FXP_MKDIR = 14;
  SSH_FXP_RMDIR = 15;
  SSH_FXP_REALPATH = 16;
  SSH_FXP_STAT = 17;
  SSH_FXP_RENAME = 18;
  SSH_FXP_READLINK = 19;
  SSH_FXP_SYMLINK = 20;
  SSH_FXP_STATUS = 101;
  SSH_FXP_HANDLE = 102;
  SSH_FXP_DATA = 103;
  SSH_FXP_NAME = 104;
  SSH_FXP_ATTRS = 105;
  SSH_FXP_EXTENDED = 200;
  SSH_FXP_EXTENDED_REPLY = 201;

  SSH_FXF_READ = $00000001;
  SSH_FXF_WRITE = $00000002;
  SSH_FXF_APPEND = $00000004;
  SSH_FXF_CREAT = $00000008;
  SSH_FXF_TRUNC = $00000010;
  SSH_FXF_EXCL = $00000020;

  SSH_FILEXFER_ATTR_SIZE = $00000001;
  SSH_FILEXFER_ATTR_UIDGID = $00000002;
  SSH_FILEXFER_ATTR_PERMISSIONS = $00000004;
  SSH_FILEXFER_ATTR_ACMODTIME = $00000008;
  SSH_FILEXFER_ATTR_EXTENDED = Integer($80000000 - $100000000);

  SFtpClientVersion = 3;
  DefaultSFtpPort = 22;

implementation

{ EclSFtpClientError }

class function EclSFtpClientError.GetSFtpStatusText(AStatusCode: Integer): string;
begin
  if ((AStatusCode < 0) or (AStatusCode > Length(SFtpStatusText) - 1)) then
  begin
    Result := SFtpUnknownStatus;
  end else
  begin
    Result := SFtpStatusText[AStatusCode];
  end;
end;

{ TclSFtpFileAttrs }

constructor TclSFtpFileAttrs.Create;
begin
  inherited Create();

  FExtended := TStringList.Create();
  Clear();
end;

procedure TclSFtpFileAttrs.Clear;
begin
  FFlags := 0;
  FSize := 0;
  FUid := 0;
  FGid := 0;
  FPermissions := [];
  FAccessTime := 0;
  FModifyTime := 0;
  FExtended.Clear();
end;

constructor TclSFtpFileAttrs.Create(APacket: TclPacket);
begin
  inherited Create();

  FExtended := TStringList.Create();
  Clear();
  Load(APacket);
end;

class function TclSFtpFileAttrs.DateTimeToInt(ADate: TDateTime): Integer;
var
  dd: TDateTime;
  hh, mm, ss, ms: Word;
begin
  if (ADate <= EncodeDate(1970, 1, 1)) then
  begin
    Result := 0;
    Exit;
  end;

  dd := ADate - EncodeDate(1970, 1, 1);
  DecodeTime(dd, hh, mm, ss, ms);
  Result :=  Trunc(dd) * 86400 + hh * 3600 + mm * 60 + ss;
end;

destructor TclSFtpFileAttrs.Destroy;
begin
  FExtended.Free();

  inherited Destroy();
end;

class function TclSFtpFileAttrs.FilePermissionsToInt(APermissions: TclSFtpFilePermissions): Integer;
var
  i: TclSFtpFilePermission;
begin
  Result := 0;
  for i := Low(TclSFtpFilePermission) to High(TclSFtpFilePermission) do
  begin
    if (i in APermissions) then
    begin
      Result := Result or SFtpFilePermissions[i];
    end;
  end;
end;

function TclSFtpFileAttrs.GetIsDir: Boolean;
begin
  Result := ((FFlags and SSH_FILEXFER_ATTR_PERMISSIONS) <> 0) and
    ((FilePermissionsToInt(FPermissions) and S_IFDIR) <> 0);
end;

class function TclSFtpFileAttrs.IntToDateTime(ADate: Integer): TDateTime;
begin
  if (ADate <= 0) then
  begin
    Result := 0;
    Exit;
  end;

  Result := EncodeDate(1970, 1, 1);
  Result := IncSecond(Result, ADate);
end;

class function TclSFtpFileAttrs.IntToFilePermissions(APermissions: Integer): TclSFtpFilePermissions;
var
  i: TclSFtpFilePermission;
begin
  Result := [];
  for i := Low(TclSFtpFilePermission) to High(TclSFtpFilePermission) do
  begin
    if ((SFtpFilePermissions[i] and APermissions) <> 0) then
    begin
      Result := Result + [i];
    end;
  end;
end;

procedure TclSFtpFileAttrs.Load(APacket: TclPacket);
var
  i, count: Integer;
  s: string;
begin
  Clear();

  FFlags := APacket.GetInt();

  if ((FFlags and SSH_FILEXFER_ATTR_SIZE) <> 0) then
  begin
    FSize := APacket.GetLong();
  end;
  if ((FFlags and SSH_FILEXFER_ATTR_UIDGID) <> 0) then
  begin
    FUid := APacket.GetInt();
    FGid := APacket.GetInt();
  end;
  if ((FFlags and SSH_FILEXFER_ATTR_PERMISSIONS) <> 0) then
  begin
    FPermissions := IntToFilePermissions(APacket.GetInt());
  end;
  if ((FFlags and SSH_FILEXFER_ATTR_ACMODTIME) <> 0) then
  begin
    FAccessTime := IntToDateTime(APacket.GetInt());
    FModifyTime := IntToDateTime(APacket.GetInt());
  end;
  if ((FFlags and SSH_FILEXFER_ATTR_EXTENDED) <> 0) then
  begin
    count := APacket.GetInt();
    if (count > 0) then
    begin
      for i := 0 to count - 1 do
      begin
        s := TclTranslator.GetString(APacket.GetString()) + '@' + TclTranslator.GetString(APacket.GetString());
        FExtended.Add(s);
      end;
    end;
  end;
end;

procedure TclSFtpFileAttrs.Save(APacket: TclPacket);
var
  i: Integer;
  list: TStrings;
begin
  APacket.PutInt(FFlags);
  if ((FFlags and SSH_FILEXFER_ATTR_SIZE) <> 0) then
  begin
    APacket.PutLong(FSize);
  end;
  if ((FFlags and SSH_FILEXFER_ATTR_UIDGID) <> 0) then
  begin
    APacket.PutInt(FUid);
    APacket.PutInt(FGid);
  end;
  if ((FFlags and SSH_FILEXFER_ATTR_PERMISSIONS) <> 0) then
  begin
    APacket.PutInt(FilePermissionsToInt(FPermissions));
  end;
  if ((FFlags and SSH_FILEXFER_ATTR_ACMODTIME) <> 0) then
  begin
    APacket.PutInt(DateTimeToInt(FAccessTime));
    APacket.PutInt(DateTimeToInt(FModifyTime));
  end;
  if ((FFlags and SSH_FILEXFER_ATTR_EXTENDED) <> 0) then
  begin
    APacket.PutInt(FExtended.Count);
    if (FExtended.Count > 0) then
    begin
      list := TStringList.Create();
      try
        for i := 0 to FExtended.Count - 1 do
        begin
          SplitText(FExtended[i], list, '@');
          if (list.Count <> 2) then
          begin
            raise EclSFtpClientError.Create(SFtpExtendedAttrError, SFtpExtendedAttrErrorCode);
          end;

          APacket.PutString(TclTranslator.GetBytes(list[0]));
          APacket.PutString(TclTranslator.GetBytes(list[1]));
        end;
      finally
        list.Free();
      end;
    end;
  end;
end;

function TclSFtpFileAttrs.SavedLength: Integer;
var
  i: Integer;
begin
  Result := 4;

  if ((FFlags and SSH_FILEXFER_ATTR_SIZE) <> 0) then
  begin
    Inc(Result, 8);
  end;
  if ((FFlags and SSH_FILEXFER_ATTR_UIDGID) <> 0) then
  begin
    Inc(Result, 8);
  end;
  if ((FFlags and SSH_FILEXFER_ATTR_PERMISSIONS) <> 0) then
  begin
    Inc(Result, 4);
  end;
  if ((FFlags and SSH_FILEXFER_ATTR_ACMODTIME) <> 0) then
  begin
    Inc(Result, 8);
  end;
  if ((FFlags and SSH_FILEXFER_ATTR_EXTENDED) <> 0) then
  begin
    Inc(Result, 4);
    if (FExtended.Count > 0) then
    begin
      for i := 0 to FExtended.Count - 1 do
      begin
        Inc(Result, 4 + 4);
        Inc(Result, Length(FExtended[i]) - 1);
      end;
    end;
  end;
end;

procedure TclSFtpFileAttrs.SetDate(AAccessTime, AModifyTime: Integer);
begin
  SetDate(IntToDateTime(AAccessTime), IntToDateTime(AModifyTime));
end;

procedure TclSFtpFileAttrs.SetDate(AAccessTime, AModifyTime: TDateTime);
begin
  FFlags := FFlags or SSH_FILEXFER_ATTR_ACMODTIME;
  FAccessTime := AAccessTime;
  FModifyTime := AModifyTime;
end;

procedure TclSFtpFileAttrs.SetExtended(AExtended: TStrings);
begin
  FFlags := FFlags or SSH_FILEXFER_ATTR_EXTENDED;
  FExtended.Assign(AExtended);
end;

procedure TclSFtpFileAttrs.SetPermissions(APermissions: TclSFtpFilePermissions);
begin
  FFlags := FFlags or SSH_FILEXFER_ATTR_PERMISSIONS;
  FPermissions := APermissions;
end;

procedure TclSFtpFileAttrs.SetSize(ASize: Int64);
begin
  FFlags := FFlags or SSH_FILEXFER_ATTR_SIZE;
  FSize := ASize;
end;

procedure TclSFtpFileAttrs.SetUidGid(AUid, AGid: Integer);
begin
  FFlags := FFlags or SSH_FILEXFER_ATTR_UIDGID;
  FUid := AUid;
  FGid := AGid;
end;

end.
