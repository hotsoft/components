{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSyncUtils;

interface

{$I clVer.inc}
{$IFDEF DELPHI6}
  {$WARN SYMBOL_PLATFORM OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, SyncObjs;
{$ELSE}
  System.Classes, System.SyncObjs, System.Types;
{$ENDIF}

type
  TclThreadSynchronizer = class
  private
    FMethod: TThreadMethod;
    FSynchronizeException: TObject;
    FSyncBaseThreadID: LongWord;
    FAccessor: TCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Synchronize(Method: TThreadMethod);
    procedure BeginWork;
    procedure EndWork;
    property SyncBaseThreadID: LongWord read FSyncBaseThreadID;
  end;

resourcestring
  cSyncInfoNotFound = 'Cannot find SyncInfo for the specified thread synchronizer';

implementation

uses
{$IFNDEF DELPHIXE2}
  Windows{$IFDEF LOGGER}, SysUtils, clLogger{$ENDIF};
{$ELSE}
  Winapi.Windows{$IFDEF LOGGER}, System.SysUtils, clLogger{$ENDIF};
{$ENDIF}

const
  CM_EXECPROC = $8FFD;
  CM_DESTROYWINDOW = $8FFC;

{$IFNDEF DELPHI6}
type
  PRaiseFrame = ^TRaiseFrame;
  TRaiseFrame = record
    NextRaise: PRaiseFrame;
    ExceptAddr: Pointer;
    ExceptObject: TObject;
    ExceptionRecord: PExceptionRecord;
  end;
{$ENDIF}

type
  TclSyncInfo = class
  public
    FSyncBaseThreadID: LongWord;
    FThreadWindow: HWND;
    FThreadCount: Integer;
  end;

  TclSynchronizerManager = class
  private
    FThreadLock: TRTLCriticalSection;
    FList: TList;
    procedure FreeSyncInfo(AInfo: TclSyncInfo);
    procedure DoDestroyWindow(AInfo: TclSyncInfo);
    function InfoBySync(ASyncBaseThreadID: LongWord): TclSyncInfo;
    function FindSyncInfo(ASyncBaseThreadID: LongWord): TclSyncInfo;
  public
    class function Instance: TclSynchronizerManager;
    constructor Create();
    destructor Destroy; override;
    procedure AddThread(ASynchronizer: TclThreadSynchronizer);
    procedure RemoveThread(ASynchronizer: TclThreadSynchronizer);
    procedure Synchronize(ASynchronizer: TclThreadSynchronizer);
  end;

var
  SynchronizerManager: TclSynchronizerManager = nil;

function ThreadWndProc(Window: HWND; Message, wParam, lParam: Longint): Longint; stdcall;
begin
  case Message of
    CM_EXECPROC:
      with TclThreadSynchronizer(lParam) do
      begin
        Result := 0;
        try
          FSynchronizeException := nil;
          FMethod();
        except
          {$IFDEF DELPHI6}
          FSynchronizeException := AcquireExceptionObject();
          {$ELSE}
          if RaiseList <> nil then
          begin
            FSynchronizeException := PRaiseFrame(RaiseList)^.ExceptObject;
            PRaiseFrame(RaiseList)^.ExceptObject := nil;
          end;
          {$ENDIF}
        end;
      end;
    CM_DESTROYWINDOW:
      begin
        TclSynchronizerManager.Instance().DoDestroyWindow(TclSyncInfo(lParam));
        Result := 0;
      end;
  else
    Result := DefWindowProc(Window, Message, wParam, lParam);
  end;
end;

var
  ThreadWindowClass: TWndClass = (
    style: 0;
    lpfnWndProc: @ThreadWndProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: nil;
    lpszClassName: 'TclThreadSynchronizerWindow');

{ TclSynchronizerManager }

constructor TclSynchronizerManager.Create;
begin
  inherited Create();
  InitializeCriticalSection(FThreadLock);
  FList := TList.Create();
end;

destructor TclSynchronizerManager.Destroy;
var
  i: Integer;
begin
  for i := FList.Count - 1 downto 0 do
  begin
    FreeSyncInfo(TclSyncInfo(FList[i]));
  end;
  FList.Free();
  DeleteCriticalSection(FThreadLock);
  inherited Destroy();
end;

class function TclSynchronizerManager.Instance: TclSynchronizerManager;
begin
  if (SynchronizerManager = nil) then
  begin
    SynchronizerManager := TclSynchronizerManager.Create();
  end;
  Result := SynchronizerManager;
end;
    
procedure TclSynchronizerManager.AddThread(ASynchronizer: TclThreadSynchronizer);

  function AllocateWindow: HWND;
  var
    TempClass: TWndClass;
    ClassRegistered: Boolean;
  begin
    ThreadWindowClass.hInstance := HInstance;
    ClassRegistered := GetClassInfo(HInstance, ThreadWindowClass.lpszClassName,
      TempClass);
    if not ClassRegistered or (TempClass.lpfnWndProc <> @ThreadWndProc) then
    begin
      if ClassRegistered then
        {$IFDEF DELPHIXE2}Winapi.{$ENDIF}Windows.UnregisterClass(ThreadWindowClass.lpszClassName, HInstance);
      {$IFDEF DELPHIXE2}Winapi.{$ENDIF}Windows.RegisterClass(ThreadWindowClass);
    end;

    Result := CreateWindow(ThreadWindowClass.lpszClassName, '', 0,
      0, 0, 0, 0, 0, 0, HInstance, nil);
{$IFDEF LOGGER}
    if (Result = 0) then
    begin
      clPutLogMessage(Self, edInside, 'AllocateWindow failed: %d', nil, [GetLastError()]);
    end;
{$ENDIF}
  end;

var
  info: TclSyncInfo;
begin
  EnterCriticalSection(FThreadLock);
  try
    info := FindSyncInfo(ASynchronizer.SyncBaseThreadID);
    if (info = nil) then
    begin
      info := TclSyncInfo.Create();
      info.FSyncBaseThreadID := ASynchronizer.SyncBaseThreadID;
      FList.Add(info);
    end;
    if (info.FThreadCount = 0) then
    begin
      info.FThreadWindow := AllocateWindow();
    end;
    Inc(info.FThreadCount);
  finally
    LeaveCriticalSection(FThreadLock);
  end;
end;

procedure TclSynchronizerManager.RemoveThread(ASynchronizer: TclThreadSynchronizer);
var
  info: TclSyncInfo;
begin
  EnterCriticalSection(FThreadLock);
  try
    info := InfoBySync(ASynchronizer.SyncBaseThreadID);
    PostMessage(info.FThreadWindow, CM_DESTROYWINDOW, 0, Longint(info));
  finally
    LeaveCriticalSection(FThreadLock);
  end;
end;

procedure TclSynchronizerManager.DoDestroyWindow(AInfo: TclSyncInfo);
begin
  EnterCriticalSection(FThreadLock);
  try
    Dec(AInfo.FThreadCount);
    if AInfo.FThreadCount = 0 then
    begin
      FreeSyncInfo(AInfo);
    end;
  finally
    LeaveCriticalSection(FThreadLock);
  end;
end;

procedure TclSynchronizerManager.FreeSyncInfo(AInfo: TclSyncInfo);
begin
  if AInfo.FThreadWindow <> 0 then
  begin
    DestroyWindow(AInfo.FThreadWindow);
    AInfo.Free();
    FList.Remove(AInfo);
  end;
end;

procedure TclSynchronizerManager.Synchronize(ASynchronizer: TclThreadSynchronizer);
begin
  SendMessage(InfoBySync(ASynchronizer.SyncBaseThreadID).FThreadWindow, CM_EXECPROC, 0, Longint(ASynchronizer));
end;

function TclSynchronizerManager.FindSyncInfo(
  ASyncBaseThreadID: LongWord): TclSyncInfo;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
  begin
    Result := TclSyncInfo(FList[i]);
    if (Result.FSyncBaseThreadID = ASyncBaseThreadID) then Exit;
  end;
  Result := nil;
end;

function TclSynchronizerManager.InfoBySync(
  ASyncBaseThreadID: LongWord): TclSyncInfo;
begin
  Result := FindSyncInfo(ASyncBaseThreadID);
{$IFDEF LOGGER}
  if (Result = nil) then
  begin
    try
      clPutLogMessage(Self, edInside, 'InfoBySync: Result = nil, ASyncBaseThreadID = %d, list.count = %d', nil, [ASyncBaseThreadID, FList.Count]);
    except
      on E: Exception do clPutLogMessage(Self, edInside, 'InfoBySync', E);
    end;
  end;
{$ENDIF}

  Assert(Result <> nil, cSyncInfoNotFound);
end;

{ TclThreadSynchronizer }

procedure TclThreadSynchronizer.BeginWork;
begin
  FAccessor.Enter();
end;

constructor TclThreadSynchronizer.Create;
begin
  inherited Create();
  FAccessor := TCriticalSection.Create();
  FSyncBaseThreadID := GetCurrentThreadId();
  TclSynchronizerManager.Instance().AddThread(Self);
end;

destructor TclThreadSynchronizer.Destroy;
begin
  TclSynchronizerManager.Instance().RemoveThread(Self);
  FAccessor.Free();
  inherited Destroy();
end;

procedure TclThreadSynchronizer.EndWork;
begin
  FAccessor.Leave();
end;

procedure TclThreadSynchronizer.Synchronize(Method: TThreadMethod);
begin
  FSynchronizeException := nil;
  FMethod := Method;
  TclSynchronizerManager.Instance().Synchronize(Self);
  if Assigned(FSynchronizeException) then raise FSynchronizeException;
end;

initialization

finalization
  SynchronizerManager.Free();
  SynchronizerManager := nil;

end.

