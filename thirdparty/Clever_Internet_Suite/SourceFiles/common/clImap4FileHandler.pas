{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clImap4FileHandler;

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
  Classes, SysUtils, SyncObjs, Windows,
{$ELSE}
  System.Classes, System.SysUtils, System.SyncObjs, Winapi.Windows,
{$ENDIF}
  clImap4Server, clImapUtils, clUtils;

type
  TclImap4MailBoxStore = class
  private
    FMailBox: TclImap4MailBoxItem;
  public
    constructor Create(AMailBox: TclImap4MailBoxItem);
    function Version: Integer; virtual;
    procedure Load(AStream: TStream); virtual;
    procedure Save(AStream: TStream); virtual;

    property MailBox: TclImap4MailBoxItem read FMailBox;
  end;

  TclImap4MessageStore = class
  private
    FMessages: TclImap4MessageList;
  public
    constructor Create(AMessages: TclImap4MessageList);
    function Version: Integer; virtual;
    procedure Load(AStream: TStream); virtual;
    procedure Save(AStream: TStream); virtual;

    property Messages: TclImap4MessageList read FMessages;
  end;

  TclImap4FileHandler = class(TComponent)
  private
    FServer: TclImap4Server;
    FMailBoxDir: string;
    FAccessor: TCriticalSection;
    FMailBoxInfoFile: string;
    FMessagesInfoFile: string;
    FSharedFolders: string;
    
    procedure SetMailBoxDir(const Value: string);
    procedure SetServer(const Value: TclImap4Server);
    procedure SetMailBoxInfoFile(const Value: string);
    procedure SetMessagesInfoFile(const Value: string);
    procedure SetSharedFolders(const Value: string);

    function GetMailBoxRoot(const AUserName: string): string;
    function MailBoxToPath(const AMailBox: string): string;
    function GetMailBoxPath(const AUserName, AMailBox: string): string;
    function HasSharedFolders: Boolean;
    function IsSharedFolder(const AMailboxPath: string): Boolean;
    procedure CollectMailBoxes(AMailBoxes: TclImap4MailBoxList; const APath, ARootMailBox: string);
    function GenUidValidity(const AMailboxPath: string): string;
    procedure SetCounter(AItem: TclImap4MailBoxItem; ACounter: Integer);
    function GetCounter(AItem: TclImap4MailBoxItem): Integer;
    procedure CollectMailBoxInfo(AItem: TclImap4MailBoxItem; const AMailboxPath: string; IsSubscribed: Boolean);
    procedure UpdateMailBoxInfo(const AMailBoxPath: string; AMailBox: TclImap4MailBoxItem);
    procedure UpdateMessageInfo(const AMsgInfoFile, AMessageFile: string; AFlags: TclMailMessageFlags; ADate: TDateTime);
    function GetMessageFilePaths(const AMailBoxPath, AFileMask: string): TStrings;

    procedure DoGetMailBoxes(Sender: TObject; AConnection: TclImap4CommandConnection;
      const ASelectedMailBox: string; AMailBoxes: TclImap4MailBoxList);
    procedure DoUpdateMailBox(Sender: TObject; AConnection: TclImap4CommandConnection;
      AMailBox: TclImap4MailBoxItem; var Success: Boolean);
    procedure DoCreateMailBox(Sender: TObject; AConnection: TclImap4CommandConnection;
      const AMailBox: string; var Success: Boolean);
    procedure DoDeleteMailBox(Sender: TObject; AConnection: TclImap4CommandConnection;
      const AMailBox: string; var Success: Boolean);
    procedure DoRenameMailBox(Sender: TObject; AConnection: TclImap4CommandConnection;
      const ACurrentName, ANewName: string; var Success: Boolean);
    procedure DoGetMessages(Sender: TObject; AConnection: TclImap4CommandConnection;
      AMessages: TclImap4MessageList; const AMailBox: string; var Success: Boolean);
    procedure DoUpdateMessages(Sender: TObject; AConnection: TclImap4CommandConnection;
      AMessages: TclImap4MessageList; const AMailBox: string; var Success: Boolean);
    procedure DoDeleteMessage(Sender: TObject; AConnection: TclImap4CommandConnection;
      AMessage: TclImap4MessageItem; const AMailBox: string; var Success: Boolean);
    procedure DoGetMessageSource(Sender: TObject; AConnection: TclImap4CommandConnection;
      AMessageSource: TStrings; const AMessageName, AMailBox: string; var Success: Boolean);
    procedure DoAppendMessage(Sender: TObject; AConnection: TclImap4CommandConnection; AFlags: TclMailMessageFlags;
      ADate: TDateTime; AMessageSource: TStrings; const AMailBox: string; var Success: Boolean);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure CleanEventHandlers; virtual;
    procedure InitEventHandlers; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Server: TclImap4Server read FServer write SetServer;
    property MailBoxDir: string read FMailBoxDir write SetMailBoxDir;
    property MailBoxInfoFile: string read FMailBoxInfoFile write SetMailBoxInfoFile;
    property MessagesInfoFile: string read FMessagesInfoFile write SetMessagesInfoFile;
    property SharedFolders: string read FSharedFolders write SetSharedFolders;
  end;

resourcestring
  cMailBoxLoadError = 'Cannot load mailbox settings';
  cMessageLoadError = 'Cannot load messages';

const
  cImapMailBoxInfoFile = 'imap.dat';
  cImapMessagesInfoFile = 'messages.dat';

var
  cMaxTryCount: Integer = 1000;

implementation

{ TclImap4MailBoxStore }

constructor TclImap4MailBoxStore.Create(AMailBox: TclImap4MailBoxItem);
begin
  inherited Create();
  FMailBox := AMailBox;
end;

procedure TclImap4MailBoxStore.Load(AStream: TStream);
var
  reader: TReader;
  counter: Integer;
begin
  reader := TReader.Create(AStream, 1024);
  try
    if (reader.ReadInteger() <> Version) then
    begin
      raise EStreamError.Create(cMailBoxLoadError);
    end;

    MailBox.IsSubscribed := reader.ReadBoolean();
    MailBox.UIDNext := reader.ReadInteger();
    MailBox.UIDValidity := reader.ReadString();
    
    counter := reader.ReadInteger();
    if (counter > 0) then
    begin
      MailBox.Data := Pointer(counter);
    end else
    begin
      MailBox.Data := nil;
    end;
  finally
    reader.Free();
  end;
end;

procedure TclImap4MailBoxStore.Save(AStream: TStream);
var
  writer: TWriter;
begin
  writer := TWriter.Create(AStream, 1024);
  try
    writer.WriteInteger(Version());
    writer.WriteBoolean(MailBox.IsSubscribed);
    writer.WriteInteger(MailBox.UIDNext);
    writer.WriteString(MailBox.UIDValidity);
    if (MailBox.Data <> nil) then
    begin
      writer.WriteInteger(Integer(MailBox.Data));
    end else
    begin
      writer.WriteInteger(0);
    end;
  finally
    writer.Free();
  end;
end;

function TclImap4MailBoxStore.Version: Integer;
begin
  Result := 1;
end;

{ TclImap4MessageStore }

constructor TclImap4MessageStore.Create(AMessages: TclImap4MessageList);
begin
  inherited Create();
  FMessages := AMessages;
end;

procedure TclImap4MessageStore.Load(AStream: TStream);
var
  reader: TReader;
  i, cnt: Integer;
  item: TclImap4MessageItem;
begin
  reader := TReader.Create(AStream, 1024);
  try
    if (reader.ReadInteger() <> Version()) then
    begin
      raise EStreamError(cMessageLoadError);
    end;

    Messages.Clear();
    cnt := reader.ReadInteger();
    for i := 0 to cnt - 1 do
    begin
      item := TclImap4MessageItem.Create();
      Messages.Add(item);
      item.Name := reader.ReadString();
      item.UID := reader.ReadInteger();
      item.Flags := GetImapMessageFlagsByStr(UpperCase(reader.ReadString()));
      item.Date := reader.ReadFloat();
    end;
  finally
    reader.Free();
  end;
end;

procedure TclImap4MessageStore.Save(AStream: TStream);
var
  writer: TWriter;
  i: Integer;
  item: TclImap4MessageItem;
begin
  writer := TWriter.Create(AStream, 1024);
  try
    writer.WriteInteger(Version());

    writer.WriteInteger(Messages.Count);
    for i := 0 to Messages.Count - 1 do
    begin
      item := Messages[i];

      writer.WriteString(item.Name);
      writer.WriteInteger(item.UID);
      writer.WriteString(GetStrByImapMessageFlags(item.Flags));
      writer.WriteFloat(item.Date);
    end;
  finally
    writer.Free();
  end;
end;

function TclImap4MessageStore.Version: Integer;
begin
  Result := 2;
end;

{ TclImap4FileHandler }

procedure TclImap4FileHandler.CleanEventHandlers;
begin
  Server.OnGetMailBoxes := nil;
  Server.OnUpdateMailBox := nil;
  Server.OnCreateMailBox := nil;
  Server.OnDeleteMailBox := nil;
  Server.OnRenameMailBox := nil;
  Server.OnGetMessages := nil;
  Server.OnUpdateMessages := nil;
  Server.OnDeleteMessage := nil;
  Server.OnGetMessageSource := nil;
  Server.OnAppendMessage := nil;
end;

procedure TclImap4FileHandler.CollectMailBoxes(AMailBoxes: TclImap4MailBoxList; const APath, ARootMailBox: string);
var
  sr: TSearchRec;
  item: TclImap4MailBoxItem;
begin
  if {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindFirst(APath + '*.*', faDirectory, sr) = 0 then
  begin
    repeat
      if ((sr.Attr and faDirectory) <> 0) and (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        item := AMailBoxes.Add();
        item.Name := ARootMailBox + sr.Name;
        CollectMailBoxInfo(item, APath + sr.Name, False);
        CollectMailBoxes(AMailBoxes, APath + sr.Name + '\', sr.Name + Server.MailBoxSeparator);
      end;
    until ({$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindNext(sr) <> 0);
    {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindClose(sr);
  end;
end;

procedure TclImap4FileHandler.CollectMailBoxInfo(AItem: TclImap4MailBoxItem; const AMailboxPath: string; IsSubscribed: Boolean);
var
  store: TclImap4MailBoxStore;
  s: string;
  stream: TStream;
begin
  store := nil;
  stream := nil;
  try
    store := TclImap4MailBoxStore.Create(AItem);
    s := AddTrailingBackSlash(AMailboxPath) + MailBoxInfoFile;

    if (not FileExists(s)) then
    begin
      AItem.IsSubscribed := IsSubscribed;
      AItem.UIDNext := 1;
      AItem.UIDValidity := GenUidValidity(AMailboxPath);
      SetCounter(AItem, 0);

      stream := TFileStream.Create(s, fmCreate);
      store.Save(stream);
    end else
    begin
      stream := TFileStream.Create(s, fmOpenRead or fmShareDenyWrite);
      store.Load(stream);
    end;
  finally
    stream.Free();
    store.Free();
  end;
end;

constructor TclImap4FileHandler.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAccessor := TCriticalSection.Create();
  FMailBoxInfoFile := cImapMailBoxInfoFile;
  FMessagesInfoFile := cImapMessagesInfoFile;
end;

destructor TclImap4FileHandler.Destroy;
begin
  FAccessor.Free();
  inherited Destroy();
end;

procedure TclImap4FileHandler.DoAppendMessage(Sender: TObject; AConnection: TclImap4CommandConnection; AFlags: TclMailMessageFlags;
  ADate: TDateTime; AMessageSource: TStrings; const AMailBox: string; var Success: Boolean);
var
  mailBoxPath, msgFileName: string;
  mailBoxItem: TclImap4MailBoxItem;
  i, counter: Integer;
begin
  FAccessor.Enter();
  try
    Success := False;

    mailBoxPath := GetMailBoxPath(AConnection.UserName, AMailBox);
    mailBoxItem := TclImap4MailBoxItem.Create(nil);
    try
      mailBoxItem.Name := AMailBox;
      CollectMailBoxInfo(mailBoxItem, mailBoxPath, False);
      counter := GetCounter(mailBoxItem);
      msgFileName := '';


      i := 0;
      while (True) do
      begin
        Inc(counter);
        msgFileName := mailBoxPath + Format('MAIL%.8d.MSG', [counter]);

        try
          if (not FileExists(msgFileName)) then
          begin
            TclStringsUtils.SaveStrings(AMessageSource, msgFileName, '');
            Break;
          end;
        except
          on EStreamError do;
        end;

        Inc(i);
        if (i > cMaxTryCount) then
        begin
          raise Exception.Create('Cannot save new message');
        end;
      end;

      SetCounter(mailBoxItem, counter);
      UpdateMailBoxInfo(mailBoxPath + MailBoxInfoFile, mailBoxItem);
      UpdateMessageInfo(mailBoxPath + MessagesInfoFile, msgFileName, AFlags, ADate);

      Success := True;
    finally
      mailBoxItem.Free();
    end;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclImap4FileHandler.DoCreateMailBox(Sender: TObject; AConnection: TclImap4CommandConnection;
  const AMailBox: string; var Success: Boolean);
var
  path: string;
begin
  FAccessor.Enter();
  try
    Success := False;

    if (SameText('INBOX', AMailBox)) then Exit;

    path := GetMailBoxPath(AConnection.UserName, AMailBox);
    if (DirectoryExists(path) or IsSharedFolder(path)) then Exit;

    Success := ForceFileDirectories(path);
  finally
    FAccessor.Leave();
  end;
end;

procedure TclImap4FileHandler.DoDeleteMailBox(Sender: TObject; AConnection: TclImap4CommandConnection;
  const AMailBox: string; var Success: Boolean);

  function HasSubDirs(const ADir: string): Boolean;
  var
    sr: TSearchRec;
  begin
    Result := False;
    if {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindFirst(ADir + '*.*', faDirectory, sr) = 0 then
    begin
      repeat
        if ((sr.Attr and faDirectory) <> 0) and (sr.Name <> '.') and (sr.Name <> '..') then
        begin
          Result := True;
          Break;
        end;
      until ({$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindNext(sr) <> 0);
      {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindClose(sr);
    end;
  end;

var
  path: string;
begin
  FAccessor.Enter();
  try
    Success := False;

    if (SameText('INBOX', AMailBox)) then Exit;

    path := GetMailBoxPath(AConnection.UserName, AMailBox);
    if ((not DirectoryExists(path)) or IsSharedFolder(path)) then Exit;

    if HasSubDirs(AddTrailingBackSlash(path)) then Exit;

    Success := DeleteRecursiveDir(path);
  finally
    FAccessor.Leave();
  end;
end;

procedure TclImap4FileHandler.DoDeleteMessage(Sender: TObject; AConnection: TclImap4CommandConnection;
  AMessage: TclImap4MessageItem; const AMailBox: string; var Success: Boolean);
begin
  FAccessor.Enter();
  try
    Success := False;
    if (FileExists(AMessage.Name)) then
    begin
      Success := DeleteFile(PChar(AMessage.Name));
    end;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclImap4FileHandler.DoGetMailBoxes(Sender: TObject; AConnection: TclImap4CommandConnection;
  const ASelectedMailBox: string; AMailBoxes: TclImap4MailBoxList);
var
  path: string;
  item: TclImap4MailBoxItem;
begin
  FAccessor.Enter();
  try
    path := GetMailBoxRoot(AConnection.UserName);

    if (ASelectedMailBox = '') then
    begin
      if (DirectoryExists(path)) then
      begin
        item := AMailBoxes.Add();
        item.Name := 'INBOX';
        CollectMailBoxInfo(item, path, True);

        CollectMailBoxes(AMailBoxes, path, '');
      end;

      if (HasSharedFolders()) then
      begin
        CollectMailBoxes(AMailBoxes, AddTrailingBackSlash(SharedFolders), '');
      end;
    end else
    begin
      path := GetMailBoxPath(AConnection.UserName, ASelectedMailBox);
      if (DirectoryExists(path)) then
      begin
        item := AMailBoxes.Add();
        item.Name := ASelectedMailBox;
        CollectMailBoxInfo(item, path, False);
      end;
    end;
  finally
    FAccessor.Leave();
  end;
end;

function TclImap4FileHandler.GetMessageFilePaths(const AMailBoxPath, AFileMask: string): TStrings;
var
  sr: TSearchRec;
begin
  Result := TStringList.Create();
  try
    if {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindFirst(AMailBoxPath + AFileMask, faAnyFile, sr) = 0 then
    begin
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then
        begin
          Result.Add(AMailBoxPath + sr.Name);
        end;
      until ({$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindNext(sr) <> 0);
      {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindClose(sr);
    end;
  except
    Result.Free();
    raise;
  end;
end;

procedure TclImap4FileHandler.DoGetMessages(Sender: TObject; AConnection: TclImap4CommandConnection;
  AMessages: TclImap4MessageList; const AMailBox: string; var Success: Boolean);
var
  mailBoxPath, msgInfoFile: string;
  storedMessages: TclImap4MessageList;
  store: TclImap4MessageStore;
  stream: TStream;
  list: TStrings;
  i: Integer;
  s: string;
  storedItem, item: TclImap4MessageItem;
begin
  FAccessor.Enter();
  try
    Success := False;
    mailBoxPath := GetMailBoxPath(AConnection.UserName, AMailBox);

    if (not DirectoryExists(mailBoxPath)) then Exit;

    msgInfoFile := mailBoxPath + MessagesInfoFile;

    storedMessages := nil;
    store := nil;
    stream := nil;
    list := nil;
    try
      storedMessages := TclImap4MessageList.Create();
      if (FileExists(msgInfoFile)) then
      begin
        store := TclImap4MessageStore.Create(storedMessages);
        stream := TFileStream.Create(msgInfoFile, fmOpenRead or fmShareDenyWrite);
        store.Load(stream);
      end;

      list := GetMessageFilePaths(mailBoxPath, '*.MSG');
      for i := storedMessages.Count - 1 downto 0 do
      begin
        if (list.IndexOf(storedMessages[i].Name) < 0) then
        begin
          storedMessages.Delete(i);
        end;
      end;

      for i := 0 to list.Count - 1 do
      begin
        s := list[i];
        storedItem := storedMessages.FindByName(s);
        item := TclImap4MessageItem.Create(s);

        if (storedItem <> nil) then
        begin
          item.UID := storedItem.UID;
          item.Flags := storedItem.Flags;
        end;

        item.Date := GetLocalFileTime(s);
        AMessages.Add(item);
      end;

      Success := True;
    finally
      list.Free();
      stream.Free();
      store.Free();
      storedMessages.Free();
    end;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclImap4FileHandler.DoGetMessageSource(Sender: TObject; AConnection: TclImap4CommandConnection;
  AMessageSource: TStrings; const AMessageName, AMailBox: string; var Success: Boolean);
begin
  FAccessor.Enter();
  try
    Success := False;
    try
      if (FileExists(AMessageName)) then
      begin
        TclStringsUtils.LoadStrings(AMessageName, AMessageSource, '');
        Success := True;
      end;
    except
      on EStreamError do;
    end;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclImap4FileHandler.DoRenameMailBox(Sender: TObject; AConnection: TclImap4CommandConnection;
  const ACurrentName, ANewName: string; var Success: Boolean);
var
  currentPath, newPath: string;
begin
  FAccessor.Enter();
  try
    Success := False;

    if ((SameText('INBOX', ACurrentName)) or (SameText('INBOX', ANewName))) then Exit;

    currentPath := GetMailBoxPath(AConnection.UserName, ACurrentName);
    newPath := GetMailBoxPath(AConnection.UserName, ANewName);

    if ((not DirectoryExists(currentPath)) or IsSharedFolder(currentPath)
      or (DirectoryExists(newPath)) or IsSharedFolder(newPath)) then Exit;

    Success := RenameFile(currentPath, newPath);
  finally
    FAccessor.Leave();
  end;
end;

procedure TclImap4FileHandler.DoUpdateMailBox(Sender: TObject; AConnection: TclImap4CommandConnection;
  AMailBox: TclImap4MailBoxItem; var Success: Boolean);
var
  s: string;
begin
  FAccessor.Enter();
  try
    s := GetMailBoxPath(AConnection.UserName, AMailBox.Name) + MailBoxInfoFile;
    if (FileExists(s)) then
    begin
      UpdateMailBoxInfo(s, AMailBox);
    end;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclImap4FileHandler.DoUpdateMessages(Sender: TObject; AConnection: TclImap4CommandConnection;
  AMessages: TclImap4MessageList; const AMailBox: string; var Success: Boolean);
var
  mailBoxPath, msgInfoFile: string;
  storedMessages: TclImap4MessageList;
  stream: TStream;
  store: TclImap4MessageStore;
  msg, storedItem: TclImap4MessageItem;
  i: Integer;
begin
  FAccessor.Enter();
  try
    Success := False;

    mailBoxPath := GetMailBoxPath(AConnection.UserName, AMailBox);
    msgInfoFile := mailBoxPath + MessagesInfoFile;

    storedMessages := nil;
    stream := nil;
    store := nil;
    try
      storedMessages := TclImap4MessageList.Create();

      if (FileExists(msgInfoFile)) then
      begin
        stream := TFileStream.Create(msgInfoFile, fmOpenRead or fmShareDenyWrite);
        store := TclImap4MessageStore.Create(storedMessages);
        store.Load(stream);
      end;

      for i := 0 to AMessages.Count - 1 do
      begin
        msg := AMessages[i];

        if (not FileExists(msg.Name)) then Continue;

        storedItem := storedMessages.FindByName(msg.Name);
        if (storedItem = nil) then
        begin
          storedItem := TclImap4MessageItem.Create(msg.Name);
          storedMessages.Add(storedItem);

          storedItem.UID := msg.UID;
        end else
        if (storedItem.UID < 0) then
        begin
          storedItem.UID := msg.UID;
        end;

        storedItem.Flags := msg.Flags;
        SetLocalFileTime(msg.Name, msg.Date);
      end;

      stream.Free();
      stream := nil;

      store.Free();
      store := nil;

      stream := TFileStream.Create(msgInfoFile, fmCreate);
      store := TclImap4MessageStore.Create(storedMessages);
      store.Save(stream);

      Success := True;
    finally
      store.Free();
      stream.Free();
      storedMessages.Free();
    end;
  finally
    FAccessor.Leave();
  end;
end;

function TclImap4FileHandler.GenUidValidity(const AMailboxPath: string): string;
var
  sr: TSearchRec;
  s: string;
begin
  Result := '0';
  s := AMailboxPath;
  if (s <> '') and (s[Length(s)] = '\') then
  begin
    system.Delete(s, Length(s), 1);
  end;
  
  if {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindFirst(s, faDirectory, sr) = 0 then
  begin
    Result := IntToStr(sr.FindData.ftLastWriteTime.dwLowDateTime) + IntToStr(sr.FindData.ftLastWriteTime.dwHighDateTime);
    {$IFDEF DELPHIXE2}System.{$ENDIF}SysUtils.FindClose(sr);
  end;
end;

function TclImap4FileHandler.GetCounter(AItem: TclImap4MailBoxItem): Integer;
begin
  Result := Integer(AItem.Data);
end;

function TclImap4FileHandler.GetMailBoxPath(const AUserName, AMailBox: string): string;
begin
  Result := GetMailBoxRoot(AUserName) + AddTrailingBackSlash(MailBoxToPath(AMailBox));
  if (HasSharedFolders() and (not DirectoryExists(Result))) then
  begin
    Result := AddTrailingBackSlash(SharedFolders) + AddTrailingBackSlash(MailBoxToPath(AMailBox));
  end;
end;

function TclImap4FileHandler.GetMailBoxRoot(const AUserName: string): string;
begin
  Result := AddTrailingBackSlash(MailBoxDir) + AddTrailingBackSlash(AUserName);
end;

function TclImap4FileHandler.HasSharedFolders: Boolean;
begin
  Result := (SharedFolders <> '') and DirectoryExists(SharedFolders);
end;

procedure TclImap4FileHandler.InitEventHandlers;
begin
  Server.OnGetMailBoxes := DoGetMailBoxes;
  Server.OnUpdateMailBox := DoUpdateMailBox;
  Server.OnCreateMailBox := DoCreateMailBox;
  Server.OnDeleteMailBox := DoDeleteMailBox;
  Server.OnRenameMailBox := DoRenameMailBox;
  Server.OnGetMessages := DoGetMessages;
  Server.OnUpdateMessages := DoUpdateMessages;
  Server.OnDeleteMessage := DoDeleteMessage;
  Server.OnGetMessageSource := DoGetMessageSource;
  Server.OnAppendMessage := DoAppendMessage;
end;

function TclImap4FileHandler.IsSharedFolder(const AMailboxPath: string): Boolean;
begin
  Result := False;
  if (AMailboxPath = '') or (not HasSharedFolders()) then Exit;

  Result := system.Pos(UpperCase(SharedFolders), UpperCase(AMailboxPath)) = 1;
end;

function TclImap4FileHandler.MailBoxToPath(const AMailBox: string): string;
begin
  if (AMailBox = '') or (SameText('INBOX', AMailBox)) then
  begin
    Result := '';
  end else
  begin
    Result := StringReplace(AMailBox, Server.MailBoxSeparator, '\', [rfReplaceAll]);
  end;
end;

procedure TclImap4FileHandler.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation <> opRemove) then Exit;
  if (AComponent = FServer) then
  begin
    CleanEventHandlers();
    FServer := nil;
  end;
end;

procedure TclImap4FileHandler.SetCounter(AItem: TclImap4MailBoxItem; ACounter: Integer);
begin
  AItem.Data := Pointer(ACounter);
end;

procedure TclImap4FileHandler.SetMailBoxDir(const Value: string);
begin
  FAccessor.Enter();
  try
    FMailBoxDir := Value;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclImap4FileHandler.SetMailBoxInfoFile(const Value: string);
begin
  FAccessor.Enter();
  try
    FMailBoxInfoFile := Value;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclImap4FileHandler.SetMessagesInfoFile(const Value: string);
begin
  FAccessor.Enter();
  try
    FMessagesInfoFile := Value;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclImap4FileHandler.SetServer(const Value: TclImap4Server);
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

procedure TclImap4FileHandler.SetSharedFolders(const Value: string);
begin
  FAccessor.Enter();
  try
    FSharedFolders := Value;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclImap4FileHandler.UpdateMailBoxInfo(const AMailBoxPath: string; AMailBox: TclImap4MailBoxItem);
var
  store: TclImap4MailBoxStore;
  stream: TStream;
begin
  store := nil;
  stream := nil;
  try
    store := TclImap4MailBoxStore.Create(AMailBox);
    stream := TFileStream.Create(AMailBoxPath, fmCreate);

    store.Save(stream);
  finally
    stream.Free();
    store.Free();
  end;
end;

procedure TclImap4FileHandler.UpdateMessageInfo(const AMsgInfoFile, AMessageFile: string;
  AFlags: TclMailMessageFlags; ADate: TDateTime);
var
  storedMessages: TclImap4MessageList;
  store: TclImap4MessageStore;
  stream: TStream;
  storedItem: TclImap4MessageItem;
begin
  storedMessages := nil;
  store := nil;
  stream := nil;
  try
    storedMessages := TclImap4MessageList.Create();
    if (FileExists(AMsgInfoFile)) then
    begin
      store := TclImap4MessageStore.Create(storedMessages);
      stream := TFileStream.Create(AMsgInfoFile, fmOpenRead or fmShareDenyWrite);
      store.Load(stream);
    end;

    storedItem := storedMessages.FindByName(AMessageFile);
    if (storedItem = nil) then
    begin
      storedItem := TclImap4MessageItem.Create(AMessageFile);
      storedMessages.Add(storedItem);
    end;

    storedItem.Flags := AFlags;
    SetLocalFileTime(AMessageFile, ADate);

    stream.Free();
    stream := nil;
    
    store.Free();
    store := nil;

    stream := TFileStream.Create(AMsgInfoFile, fmCreate);
    store := TclImap4MessageStore.Create(storedMessages);
    store.Save(stream);
  finally
    stream.Free();
    store.Free();
    storedMessages.Free();
  end;
end;

end.
