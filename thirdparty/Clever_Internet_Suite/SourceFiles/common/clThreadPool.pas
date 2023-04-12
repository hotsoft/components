{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clThreadPool;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Windows, Classes, Contnrs, SyncObjs, ActiveX;
{$ELSE}
  Winapi.Windows, System.Classes, System.Contnrs, System.SyncObjs, Winapi.ActiveX;
{$ENDIF}

type
  TclWorkItem = class
  protected
    procedure Execute(AThread: TThread); virtual; abstract;
  end;

  TclThreadPool = class;

  TclWorkerThread = class(TThread)
  private
    FOwner: TclThreadPool;
    FIsBusy: Boolean;
    FItem: TclWorkItem;
    FStartEvent: THandle;
    FStopEvent: THandle;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner: TclThreadPool);
    destructor Destroy; override;
    procedure Perform(AItem: TclWorkItem);
    procedure Stop;
    property IsBusy: Boolean read FIsBusy;
  end;

  TclWorkerThreadCom = class(TclWorkerThread)
  protected
    procedure Execute; override;
  end;

  TclCreateWorkerThreadEvent = procedure(Sender: TObject; var AThread: TclWorkerThread) of object;
  TclWorkItemEvent = procedure(Sender: TObject; AItem: TclWorkItem) of object;
  TclRunWorkItemEvent = procedure(Sender: TObject; AItem: TclWorkItem; AThread: TclWorkerThread) of object;
  TclFinishWorkItemEvent = procedure(Sender: TObject; AItem: TclWorkItem; AThread: TclWorkerThread; ATerminated: Boolean) of object;
  TclWorkItemExecuteProc = procedure(AContext: TObject; AThread: TThread) of object;

  TclThreadPool = class(TComponent)
  private
    FThreads: TObjectList;
    FItems: TQueue;
    FMinThreadCount: Integer;
    FMaxThreadCount: Integer;
    FAccessor: TCriticalSection;
    FInitializeCOM: Boolean;
    FOnCreateWorkerThread: TclCreateWorkerThreadEvent;
    FOnQueueWorkItem: TclWorkItemEvent;
    FOnRunWorkItem: TclRunWorkItemEvent;
    FOnFinishWorkItem: TclFinishWorkItemEvent;

    procedure SetMaxThreadCount(const Value: Integer);
    procedure SetMinThreadCount(const Value: Integer);
    function GetNonBusyThread: TclWorkerThread;
    procedure CreateMinWorkerThreads;
    procedure ProcessQueuedItem;
    procedure FreeUnneededThreads;
  protected
    function CreateWorkerThread: TclWorkerThread; virtual;

    procedure DoCreateWorkerThread(var AThread: TclWorkerThread); virtual;
    procedure DoQueueWorkItem(AItem: TclWorkItem); virtual;
    procedure DoRunWorkItem(AItem: TclWorkItem; AThread: TclWorkerThread); virtual;
    procedure DoFinishWorkItem(AItem: TclWorkItem; AThread: TclWorkerThread; ATerminated: Boolean); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Stop;
    procedure QueueWorkItem(AItem: TclWorkItem); overload;
    procedure QueueWorkItem(AContext: TObject; AExecProc: TclWorkItemExecuteProc); overload;
  published
    property MinThreadCount: Integer read FMinThreadCount write SetMinThreadCount default 1;
    property MaxThreadCount: Integer read FMaxThreadCount write SetMaxThreadCount default 5;
    property InitializeCOM: Boolean read FInitializeCOM write FInitializeCOM default False;

    property OnCreateWorkerThread: TclCreateWorkerThreadEvent read FOnCreateWorkerThread write FOnCreateWorkerThread;
    property OnQueueWorkItem: TclWorkItemEvent read FOnQueueWorkItem write FOnQueueWorkItem;
    property OnRunWorkItem: TclRunWorkItemEvent read FOnRunWorkItem write FOnRunWorkItem;
    property OnFinishWorkItem: TclFinishWorkItemEvent read FOnFinishWorkItem write FOnFinishWorkItem;
  end;

implementation

type
  TclExecProcWorkItem = class(TclWorkItem)
  private
    FContext: TObject;
    FExecProc: TclWorkItemExecuteProc;
  protected
    procedure Execute(AThread: TThread); override;
  public
    constructor Create(AContext: TObject; AExecProc: TclWorkItemExecuteProc);
  end;

{ TclThreadPool }

constructor TclThreadPool.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAccessor := TCriticalSection.Create();
  FThreads := TObjectList.Create();
  FItems := TQueue.Create();
  FMaxThreadCount := 5;
  FMinThreadCount := 1;
  FInitializeCOM := False;
end;

destructor TclThreadPool.Destroy;
begin
  Stop();
  FItems.Free();
  FThreads.Free();
  FAccessor.Free();

  inherited Destroy();
end;

procedure TclThreadPool.DoCreateWorkerThread(var AThread: TclWorkerThread);
begin
  if Assigned(OnCreateWorkerThread) then
  begin
    OnCreateWorkerThread(Self, AThread);
  end;
end;

procedure TclThreadPool.DoFinishWorkItem(AItem: TclWorkItem; AThread: TclWorkerThread; ATerminated: Boolean);
begin
  if Assigned(OnFinishWorkItem) then
  begin
    OnFinishWorkItem(Self, AItem, AThread, ATerminated);
  end;
end;

procedure TclThreadPool.DoQueueWorkItem(AItem: TclWorkItem);
begin
  if Assigned(OnQueueWorkItem) then
  begin
    OnQueueWorkItem(Self, AItem);
  end;
end;

procedure TclThreadPool.DoRunWorkItem(AItem: TclWorkItem; AThread: TclWorkerThread);
begin
  if Assigned(OnRunWorkItem) then
  begin
    OnRunWorkItem(Self, AItem, AThread);
  end;
end;

function TclThreadPool.GetNonBusyThread: TclWorkerThread;
var
  i: Integer;
begin
  for i := 0 to FThreads.Count - 1 do
  begin
    Result := TclWorkerThread(FThreads[i]);
    if (not Result.IsBusy) then Exit;
  end;
  Result := nil;
end;

function TclThreadPool.CreateWorkerThread: TclWorkerThread;
begin
  Result := nil;

  DoCreateWorkerThread(Result);

  if (Result <> nil) then Exit;

  if InitializeCOM then
  begin
    Result := TclWorkerThreadCom.Create(Self);
  end else
  begin
    Result := TclWorkerThread.Create(Self);
  end;
end;

procedure TclThreadPool.CreateMinWorkerThreads;
begin
  while (FThreads.Count < MinThreadCount) do
  begin
    CreateWorkerThread();
  end;
end;

procedure TclThreadPool.QueueWorkItem(AItem: TclWorkItem);
var
  thread: TclWorkerThread;
begin
{$IFDEF DEMO}
{$IFNDEF STANDALONEDEMO}
  if FindWindow('TAppBuilder', nil) = 0 then
  begin
    MessageBox(0, 'This demo version can be run under Delphi/C++Builder IDE only. ' +
      'Please visit www.clevercomponents.com to purchase your ' +
      'copy of the library.', 'Information', MB_ICONEXCLAMATION  or MB_TASKMODAL or MB_TOPMOST);
    ExitProcess(1);
  end;
{$ENDIF}
{$ENDIF}

  DoQueueWorkItem(AItem);

  FAccessor.Enter();
  try
    thread := GetNonBusyThread();
    if (thread = nil) and (FThreads.Count < MaxThreadCount) then
    begin
      thread := CreateWorkerThread();
    end;
    if (thread <> nil) then
    begin
      thread.Perform(AItem);
    end else
    begin
      FItems.Push(AItem);
    end;
    CreateMinWorkerThreads();
    FreeUnneededThreads();
  finally
    FAccessor.Leave();
  end;
end;

procedure TclThreadPool.SetMaxThreadCount(const Value: Integer);
begin
  if (Value > 1) and (Value <= MAXIMUM_WAIT_OBJECTS) then
  begin
    FMaxThreadCount := Value;
  end;
end;

procedure TclThreadPool.SetMinThreadCount(const Value: Integer);
begin
  if (Value > 1) and (Value <= MAXIMUM_WAIT_OBJECTS) then
  begin
    FMinThreadCount := Value;
  end;
end;

procedure TclThreadPool.Stop;
var
  i: Integer;
begin
  FAccessor.Enter();
  try
    while FItems.AtLeast(1) do
    begin
      TObject(FItems.Pop()).Free();
    end;

    for i := 0 to FThreads.Count - 1 do
    begin
      TclWorkerThread(FThreads[i]).Stop();
    end;
  finally
    FAccessor.Leave();
  end;

  while(FThreads.Count > 0) do
  begin
    FThreads.Delete(0);
  end;
end;

procedure TclThreadPool.FreeUnneededThreads;
var
  i: Integer;
begin
  for i := FThreads.Count downto MinThreadCount do
  begin
    if (not TclWorkerThread(FThreads[i - 1]).IsBusy) then
    begin
      FThreads.Delete(i - 1);
    end;
  end;
end;

procedure TclThreadPool.ProcessQueuedItem;
var
  thread: TclWorkerThread;
begin
  FAccessor.Enter();
  try
    if FItems.AtLeast(1) then
    begin
      thread := GetNonBusyThread();
      if (thread = nil) and (FThreads.Count < MaxThreadCount) then
      begin
        thread := CreateWorkerThread();
      end;
      if (thread <> nil) then
      begin
        thread.Perform(FItems.Pop());
      end;
    end;
  finally
    FAccessor.Leave();
  end;
end;

procedure TclThreadPool.QueueWorkItem(AContext: TObject; AExecProc: TclWorkItemExecuteProc);
begin
  QueueWorkItem(TclExecProcWorkItem.Create(AContext, AExecProc));
end;

{ TclWorkerThread }

constructor TclWorkerThread.Create(AOwner: TclThreadPool);
begin
  FStartEvent := CreateEvent(nil, False, False, nil);
  FStopEvent := CreateEvent(nil, False, False, nil);
  FOwner := AOwner;
  inherited Create(False);
  FOwner.FThreads.Add(Self);
end;

destructor TclWorkerThread.Destroy;
begin
  Stop();
  WaitForSingleObject(Handle, INFINITE);
  FItem.Free();
  FItem := nil;
  inherited Destroy();
  CloseHandle(FStopEvent);
  CloseHandle(FStartEvent);
end;

procedure TclWorkerThread.Execute;
var
  dwResult: DWORD;
  arr: array[0..1] of THandle;
begin
  try
    arr[0] := FStopEvent;
    arr[1] := FStartEvent;
    repeat
      dwResult := WaitForMultipleObjects(2, @arr, FALSE, INFINITE);
      if (dwResult = WAIT_OBJECT_0 + 1) then
      begin
        try
          FOwner.DoRunWorkItem(FItem, Self);
          FItem.Execute(Self);
          FOwner.DoFinishWorkItem(FItem, Self, Terminated);
        except
          Assert(False);
        end;
        FItem.Free();
        FItem := nil;
        if not Terminated then
        begin
          FOwner.ProcessQueuedItem();
        end;
        FIsBusy := False;
      end;
    until Terminated or (dwResult = WAIT_OBJECT_0);
  except
    Assert(False);
  end;
end;

procedure TclWorkerThread.Perform(AItem: TclWorkItem);
begin
  Assert(not FIsBusy);
  FItem := AItem;
  FIsBusy := True;
  SetEvent(FStartEvent);
end;

procedure TclWorkerThread.Stop;
begin
  Terminate();
  SetEvent(FStopEvent);
end;

{ TclWorkerThreadCom }

procedure TclWorkerThreadCom.Execute;
begin
  CoInitialize(nil);
  try
    inherited Execute();
  finally
    CoUninitialize();
  end;
end;

{ TclExecProcWorkItem }

constructor TclExecProcWorkItem.Create(AContext: TObject; AExecProc: TclWorkItemExecuteProc);
begin
  inherited Create();

  FContext := AContext;
  FExecProc := AExecProc;
end;

procedure TclExecProcWorkItem.Execute(AThread: TThread);
begin
  Assert(@FExecProc <> nil);
  FExecProc(FContext, AThread);
end;

end.
