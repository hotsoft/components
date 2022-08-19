{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clResourceState;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows;
{$ELSE}
  System.Classes, Winapi.Windows;
{$ENDIF}

type
  TclProcessStatus = (psUnknown, psSuccess, psFailed, psErrors, psProcess, psTerminated);

  TclResourceStateList = class;

  TclResourceStateItem = class(TCollectionItem)
  private
    FResourcePos: Int64;
    FBytesToProceed: Int64;
    FStatus: TclProcessStatus;
    FBytesProceed: Int64;
    procedure SetResourcePos(const Value: Int64);
    function GetResourceState: TclResourceStateList;
    procedure SetBytesProceed(const Value: Int64);
    procedure SetBytesToProceed(const Value: Int64);
  public
    procedure Assign(Source: TPersistent); override;
    property ResourceState: TclResourceStateList read GetResourceState;
    property ResourcePos: Int64 read FResourcePos write SetResourcePos;
    property BytesToProceed: Int64 read FBytesToProceed write SetBytesToProceed;
    property BytesProceed: Int64 read FBytesProceed write SetBytesProceed;
    property Status: TclProcessStatus read FStatus write FStatus;
  end;

  TclResourceStateList = class(TCollection)
  private
    FResourceSize: Int64;
    FLastStatus: TclProcessStatus;
    FSpeedCount: TLargeInteger;
    FStartCount: TLargeInteger;
    FSpeed: Double;
    FElapsedTime: Double;
    FBytesProceedSinceStart: Int64;
    FOnChanged: TNotifyEvent;
    function GetItem(Index: Integer): TclResourceStateItem;
    procedure SetItem(Index: Integer; const Value: TclResourceStateItem);
    function GetBytesProceed: Int64;
    function GetLastStatus: TclProcessStatus;
    procedure UpdateStatistic();
    function GetRemainingTime: Double;
    class function GetFrequency: TLargeInteger;
  protected
    procedure DoChanged(); virtual;
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create;

    procedure InitStatistic;
    procedure Assign(Source: TPersistent); override;
    procedure UpdateProceed(AItem: TclResourceStateItem; ABytesProceed: Int64);
    procedure UpdateStatus(AItem: TclResourceStateItem; AStatus: TclProcessStatus);
    procedure Init(AThreadCount, AResourceSize: Int64);
    function Add: TclResourceStateItem;
    property Items[Index: Integer]: TclResourceStateItem read GetItem write SetItem; default;
    property BytesProceed: Int64 read GetBytesProceed;
    property ResourceSize: Int64 read FResourceSize write FResourceSize;
    property LastStatus: TclProcessStatus read GetLastStatus;
    property Speed: Double read FSpeed;
    property ElapsedTime: Double read FElapsedTime;
    property RemainingTime: Double read GetRemainingTime;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
  end;

implementation

{ TclResourceStateList }

function TclResourceStateList.Add(): TclResourceStateItem;
begin
  Result := TclResourceStateItem(inherited Add());
end;

procedure TclResourceStateList.Assign(Source: TPersistent);
begin
  InitStatistic();
  FResourceSize := 0;
  if (Source is TclResourceStateList) then
  begin
    FResourceSize := (Source as TclResourceStateList).ResourceSize;
  end;
  inherited Assign(Source);
end;

constructor TclResourceStateList.Create;
begin
  inherited Create(TclResourceStateItem);
end;

procedure TclResourceStateList.InitStatistic();
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Items[i].FStatus := psUnknown;
  end;
  FLastStatus := psUnknown;
  FSpeedCount := 0;
  FStartCount := 0;
  FSpeed := 0;
  FElapsedTime := 0;
  FBytesProceedSinceStart := GetBytesProceed();
  QueryPerformanceCounter(FStartCount);
end;

function TclResourceStateList.GetBytesProceed: Int64;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to Count - 1 do
  begin
    Result := Result + Items[i].BytesProceed;
  end;
end;

function TclResourceStateList.GetItem(Index: Integer): TclResourceStateItem;
begin
  Result := TclResourceStateItem(inherited GetItem(Index));
end;

function TclResourceStateList.GetLastStatus: TclProcessStatus;
  function CheckStatus(ACheckStatus: TclProcessStatus; var AResStatus: TclProcessStatus): Boolean;
  var
    i: Integer;
  begin
    for i := 0 to Count - 1 do
    begin
      AResStatus := Items[i].Status;
      Result := (AResStatus = ACheckStatus);
      if Result then Exit;
    end;
    AResStatus := psUnknown;
    Result := False;
  end;

  function CreckItemsStatus(): TclProcessStatus;
  begin
    if CheckStatus(psProcess, Result) then Exit;
    if CheckStatus(psTerminated, Result) then Exit;
    if CheckStatus(psFailed, Result) then Exit;
    if CheckStatus(psErrors, Result) then Exit;
    if CheckStatus(psSuccess, Result) then Exit;
  end;

begin
  Result := CreckItemsStatus();
  if (Result in [psUnknown, psSuccess]) and (FLastStatus <> psUnknown) then
  begin
    Result := FLastStatus;
  end;
end;

procedure TclResourceStateList.Init(AThreadCount, AResourceSize: Int64);
var
  i: Integer;
  ResPos, Proceed: Int64;
  StateItem: TclResourceStateItem;
begin
  InitStatistic();
  if (Count > 0) then Exit;
  FResourceSize := AResourceSize;
  ResPos := 0;
  Proceed := 0;
  for i := 0 to AThreadCount - 1 do
  begin
    StateItem := Add();
    if (FResourceSize > 0) then
    begin
      ResPos := i * (FResourceSize div AThreadCount);
      if (i < (AThreadCount - 1)) then
      begin
        Proceed := (FResourceSize div AThreadCount);
      end else
      begin
        Proceed := FResourceSize - ResPos;
      end;
    end;
    StateItem.ResourcePos := ResPos;
    StateItem.BytesToProceed := Proceed;
  end;
end;

procedure TclResourceStateList.SetItem(Index: Integer; const Value: TclResourceStateItem);
begin
  inherited SetItem(Index, Value);
end;

procedure TclResourceStateList.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
  if (Count = 0) then
  begin
    InitStatistic();
  end;
  DoChanged();
end;

procedure TclResourceStateList.UpdateProceed(AItem: TclResourceStateItem; ABytesProceed: Int64);
begin
  if (AItem <> nil) then
  begin
    AItem.FBytesProceed := ABytesProceed;
  end;
  UpdateStatistic();
  DoChanged();
end;

procedure TclResourceStateList.UpdateStatus(AItem: TclResourceStateItem; AStatus: TclProcessStatus);
begin
  if (AItem <> nil) then
  begin
    AItem.FStatus := AStatus;
  end else
  begin
    FLastStatus := AStatus;
  end;
  DoChanged();
end;

var
  FrequencyValue: TLargeInteger = 0;

class function TclResourceStateList.GetFrequency(): TLargeInteger;
begin
  if (FrequencyValue = 0) then
  begin
    QueryPerformanceFrequency(FrequencyValue);
  end;
  Result := FrequencyValue;
end;

procedure TclResourceStateList.UpdateStatistic();
var
  NewCount: TLargeInteger;
begin
  FSpeed := 0;
  FElapsedTime := 0;
  if QueryPerformanceCounter(NewCount) and (GetFrequency() > 0) then
  begin
    FSpeed := (BytesProceed - FBytesProceedSinceStart) / ((NewCount - FStartCount) / GetFrequency());
    FSpeedCount := NewCount;
    FElapsedTime := (FSpeedCount - FStartCount) / GetFrequency();
  end;
end;

function TclResourceStateList.GetRemainingTime: Double;
begin
  if (ResourceSize > 0) and (Speed > 0) then
  begin
    Result := (ResourceSize - BytesProceed) / Speed;
  end else
  begin
    Result := 0;
  end;
end;

procedure TclResourceStateList.DoChanged;
begin
  if Assigned(FOnChanged) then
  begin
    FOnChanged(Self);
  end;
end;

{ TclResourceStateItem }

procedure TclResourceStateItem.Assign(Source: TPersistent);
var
  Src: TclResourceStateItem;
begin
  if (Source is TclResourceStateItem) then
  begin
    Src := (Source as TclResourceStateItem);
    FResourcePos := Src.ResourcePos;
    FBytesToProceed := Src.BytesToProceed;
    FStatus := Src.Status;
    FBytesProceed := Src.BytesProceed;
  end else
  begin
    inherited Assign(Source);
  end;
end;

function TclResourceStateItem.GetResourceState: TclResourceStateList;
begin
  Result := (Collection as TclResourceStateList);
end;

procedure TclResourceStateItem.SetBytesProceed(const Value: Int64);
begin
  if (Value > -1) then
  begin
    FBytesProceed := Value;
  end;
end;

procedure TclResourceStateItem.SetBytesToProceed(const Value: Int64);
begin
  if (Value > -1) then
  begin
    FBytesToProceed := Value;
  end;
end;

procedure TclResourceStateItem.SetResourcePos(const Value: Int64);
begin
  if (Value > -1) then
  begin
    FResourcePos := Value;
  end;
end;

end.
