{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clFtpFileHandler;

interface

{$I clVer.inc}
{$IFDEF DELPHI6}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
  {$WARN UNSAFE_CAST OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Windows,
{$ELSE}
  System.Classes, System.SysUtils, Winapi.Windows,
{$ENDIF}
  clFtpServer, clFtpUtils;

type
  TclFtpFileHandler = class(TComponent)
  private
    FServer: TclFtpServer;
    procedure SetServer(const Value: TclFtpServer);
    function GetErrorText(AErrorCode: Integer): string;
    
    procedure DoCreateDir(Sender: TObject; AConnection: TclFtpCommandConnection;
      const AName: string; var Success: Boolean; var AErrorMessage: string);
    procedure DoDelete(Sender: TObject; AConnection: TclFtpCommandConnection;
      const AName: string; var Success: Boolean; var AErrorMessage: string);
    procedure DoGetFile(Sender: TObject; AConnection: TclFtpCommandConnection;
      const AFileName: string; var ASource: TStream; var Success: Boolean; var AErrorMessage: string);
    procedure DoGetFileList(Sender: TObject; AConnection: TclFtpCommandConnection;
      const APathName, AFileMask: string; AIncludeHidden: Boolean; AFileList: TclFtpFileInfoList;
      var Success: Boolean; var AErrorMessage: string);
    procedure DoPutFile(Sender: TObject; AConnection: TclFtpCommandConnection; const AFileName: string;
      AOverwrite: Boolean; var ADestination: TStream; var Success: Boolean; var AErrorMessage: string);
    procedure DoRename(Sender: TObject; AConnection: TclFtpCommandConnection;
      const ACurrentName, ANewName: string; var Success: Boolean; var AErrorMessage: string);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CleanEventHandlers; virtual;
    procedure InitEventHandlers; virtual;
  published
    property Server: TclFtpServer read FServer write SetServer;
  end;

implementation

uses
  clUtils;

{ TclFtpFileHandler }

procedure TclFtpFileHandler.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) then Exit;
  if (AComponent = FServer) then
  begin
    CleanEventHandlers();
    FServer := nil;
  end;
end;

procedure TclFtpFileHandler.SetServer(const Value: TclFtpServer);
begin
  if (FServer <> Value) then
  begin
    if (FServer <> nil) then
    begin
      FServer.RemoveFreeNotification(Self);
      CleanEventHandlers();
    end;
    FServer := Value;
    if (FServer <> nil) then
    begin
      FServer.FreeNotification(Self);
      InitEventHandlers();
    end;
  end;
end;

procedure TclFtpFileHandler.CleanEventHandlers;
begin
  Server.OnCreateDir := nil;
  Server.OnDelete := nil;
  Server.OnRename := nil;
  Server.OnPutFile := nil;
  Server.OnGetFile := nil;
  Server.OnGetFileList := nil;
end;

procedure TclFtpFileHandler.InitEventHandlers;
begin
  Server.OnCreateDir := DoCreateDir;
  Server.OnDelete := DoDelete;
  Server.OnRename := DoRename;
  Server.OnPutFile := DoPutFile;
  Server.OnGetFile := DoGetFile;
  Server.OnGetFileList := DoGetFileList;
end;

procedure TclFtpFileHandler.DoCreateDir(Sender: TObject; AConnection: TclFtpCommandConnection;
  const AName: string; var Success: Boolean; var AErrorMessage: string);
begin
  Success := CreateDir(AName);
  if not Success then
  begin
    AErrorMessage := GetErrorText(clGetLastError());
  end;
end;

procedure TclFtpFileHandler.DoDelete(Sender: TObject; AConnection: TclFtpCommandConnection;
  const AName: string; var Success: Boolean; var AErrorMessage: string);
var
  attr: Integer;
  sr: TSearchRec;
begin
  try
    attr := faDirectory;
    if (FindFirst(AName, attr, sr) = 0) and ((sr.Attr and faDirectory) > 0) then
    begin
      Success := RemoveDir(AName);
    end else
    begin
      Success := DeleteFile(PChar(AName));
    end;
    if not Success then
    begin
      AErrorMessage := GetErrorText(clGetLastError());
    end;
  finally
    {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindClose(sr);
  end;
end;

procedure TclFtpFileHandler.DoRename(Sender: TObject; AConnection: TclFtpCommandConnection;
  const ACurrentName, ANewName: string; var Success: Boolean; var AErrorMessage: string);
begin
  Success := RenameFile(ACurrentName, ANewName);
  if not Success then
  begin
    AErrorMessage := GetErrorText(clGetLastError());
  end;
end;

procedure TclFtpFileHandler.DoPutFile(Sender: TObject; AConnection: TclFtpCommandConnection;
  const AFileName: string; AOverwrite: Boolean; var ADestination: TStream;
  var Success: Boolean; var AErrorMessage: string);
const
  modes: array[Boolean] of Word = (fmOpenWrite, fmCreate);
begin
  try
    ADestination := TFileStream.Create(AFileName, modes[AOverwrite]);
    Success := True;
  except
    on E: Exception do
    begin
      Success := False;
      AErrorMessage := E.Message;
    end;
  end;
end;

procedure TclFtpFileHandler.DoGetFile(Sender: TObject; AConnection: TclFtpCommandConnection;
  const AFileName: string; var ASource: TStream; var Success: Boolean; var AErrorMessage: string);
begin
  try
    ASource := TFileStream.Create(AFileName, fmOpenRead or fmShareDenyWrite);
    Success := True;
  except
    on E: Exception do
    begin
      Success := False;
      AErrorMessage := E.Message;
    end;
  end;
end;

procedure TclFtpFileHandler.DoGetFileList(Sender: TObject; AConnection: TclFtpCommandConnection;
  const APathName, AFileMask: string; AIncludeHidden: Boolean; AFileList: TclFtpFileInfoList;
  var Success: Boolean; var AErrorMessage: string);
var
  searchRec: TSearchRec;
  path: string;
  item: TclFtpFileInfo;
  attr: Integer;
  isDevice: Boolean;
begin
  path := APathName;
  isDevice := (AFileMask = '') and (APathName <> '') and (APathName[Length(APathName)] = DriveDelim);

  if (not isDevice) and (not FileExists(path)) then
  begin
    path := AddTrailingBackSlash(path) + AFileMask;
  end;

  attr := faReadOnly or faDirectory or faArchive;
  if AIncludeHidden then
  begin
    attr := attr or faHidden;
  end;

  if {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindFirst(path, attr, searchRec) = 0 then
  begin
    repeat
      if (searchRec.Name <> '.') and (searchRec.Name <> '..') then
      begin
        item := TclFtpFileInfo.Create();
        AFileList.Add(item);

        if (isDevice) then
        begin
          item.FileName := path;
        end else
        begin
          item.FileName := searchRec.Name;
        end;

        item.IsDirectory := (searchRec.Attr and FILE_ATTRIBUTE_DIRECTORY) > 0;
        item.IsReadOnly := (searchRec.Attr and FILE_ATTRIBUTE_READONLY) > 0;
        item.Size := searchRec.Size;
        item.ModifiedDate := ConvertFileTimeToDateTime(searchRec.FindData.ftLastWriteTime);
      end;
    until ({$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindNext(searchRec) <> 0);
    {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindClose(searchRec);
  end;
end;

function TclFtpFileHandler.GetErrorText(AErrorCode: Integer): string;
var
  Buffer: array[0..255] of Char;
begin
  FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, nil, AErrorCode, 0, Buffer, SizeOf(Buffer), nil);
  Result := Trim(Buffer);
end;

end.
