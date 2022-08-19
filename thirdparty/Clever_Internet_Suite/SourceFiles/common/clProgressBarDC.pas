{
  Clever Internet Suite
  Copyright (C) 2014 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clProgressBarDC;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils,
{$ELSE}
  System.Classes, System.SysUtils,
{$ENDIF}
  clProgressBar, clMultiDC, clResourceState;

type
  TclProgressBarDC = class;

  TclProgressBarDCNotifier = class(TclControlNotifier)
  private
    FProgressBar: TclProgressBarDC;
    FLastItem: TclInternetItem;
    function GetLastState(): TclResourceStateList;
  protected
    procedure DoResourceStateChanged(Item: TclInternetItem); override;
    procedure DoItemDeleted(Item: TclInternetItem); override;
  public
    constructor Create(AControl: TclCustomInternetControl; AProgressBar: TclProgressBarDC);
  end;

  TclProgressBarDC = class(TclProgressBar)
  private
    FInternetControl: TclCustomInternetControl;
    FNotifier: TclProgressBarDCNotifier;

    procedure SetInternetControl(const Value: TclCustomInternetControl);
    procedure ClearNotifier();
  protected
    function GetResourceState: TclResourceStateList; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    destructor Destroy; override;
  published
    property InternetControl: TclCustomInternetControl read FInternetControl write SetInternetControl;
  end;

implementation

{ TclProgressBarDC }

destructor TclProgressBarDC.Destroy();
begin
  ClearNotifier();
  inherited Destroy();
end;

function TclProgressBarDC.GetResourceState: TclResourceStateList;
begin
  if (FNotifier <> nil) then
  begin
    Result := FNotifier.GetLastState();
  end else
  begin
    Result := inherited GetResourceState();
  end;
end;

procedure TclProgressBarDC.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (AComponent = FInternetControl) and (Operation = opRemove) then
  begin
    SetInternetControl(nil);
  end;
  inherited Notification(AComponent, Operation);
end;

procedure TclProgressBarDC.ClearNotifier();
begin
  FreeAndNil(FNotifier);
end;

procedure TclProgressBarDC.SetInternetControl(const Value: TclCustomInternetControl);
begin
  if (FInternetControl <> Value) then
  begin
    FInternetControl := Value;
    ClearNotifier();
    if (FInternetControl <> nil) then
    begin
      FInternetControl.FreeNotification(Self);
      FNotifier := TclProgressBarDCNotifier.Create(FInternetControl, Self);
    end;
  end;
end;

{ TclProgressBarDCNotifier }

constructor TclProgressBarDCNotifier.Create(AControl: TclCustomInternetControl; AProgressBar: TclProgressBarDC);
begin
  inherited Create(AControl);

  FProgressBar := AProgressBar;
  Assert(FProgressBar <> nil);
end;

procedure TclProgressBarDCNotifier.DoItemDeleted(Item: TclInternetItem);
begin
  if (FLastItem = Item) then
  begin
    FLastItem := nil;
  end;
  inherited DoItemDeleted(Item);
end;

procedure TclProgressBarDCNotifier.DoResourceStateChanged(Item: TclInternetItem);
begin
  FLastItem := Item;
  FProgressBar.NotifyChanged();
end;

function TclProgressBarDCNotifier.GetLastState(): TclResourceStateList;
begin
  Result := nil;
  if (FLastItem <> nil) then
  begin
    Result := FLastItem.ResourceState;
  end;
end;

end.
