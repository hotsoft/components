{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clNewsChecker;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows, SysUtils,
{$ELSE}
  System.Classes, Winapi.Windows, System.SysUtils,
{$ENDIF}
  clDC, clMultiDC, clDownLoader, clDCUtils, clUtils, clResourceState;

type
  TclOnIsNewsEvent = procedure (Sender: TObject; var IsNews, Handled: Boolean) of object;

  TclNewsChecker = class;

  TclNewsCheckerItem = class(TclSingleDownLoadItem)
  private
    FIsNewsExist: Boolean;
    FIsNewsMode: Boolean;
    function HasNews: Boolean;
    function GetNewsChecker(): TclNewsChecker;
  protected
    procedure InternalStart(AIsGetResourceInfo: Boolean); override;
    procedure ProcessCompleted(AThreader: TclCustomThreader); override;
    procedure DoGetResourceInfo(AResourceInfo: TclResourceInfo); override;
    procedure ControlChanged(); override;
    procedure NewsExist(); virtual;
    procedure IsNews(var IsNews, Handled: Boolean); virtual;
  end;

  TclNewsChecker = class(TclDownLoader)
  private
    FOnIsNews: TclOnIsNewsEvent;
    FOnNewsExist: TNotifyEvent;
    
    function GetIsNewsExist: Boolean;
  protected
    procedure DoIsNews(var IsNews, Handled: Boolean); dynamic;
    procedure DoNewsExist; dynamic;
    function GetInternetItemClass(): TclInternetItemClass; override;
  public
    constructor Create(AOwner: TComponent); override;
    property IsNewsExist: Boolean read GetIsNewsExist;
  published
    property OnIsNews: TclOnIsNewsEvent read FOnIsNews write FOnIsNews;
    property OnNewsExist: TNotifyEvent read FOnNewsExist write FOnNewsExist;
  end;

implementation

{ TclNewsCheckerItem }

procedure TclNewsCheckerItem.ControlChanged();
begin
  inherited ControlChanged();
  if not IsBusy then
  begin
    FIsNewsExist := False;
  end;
end;

procedure TclNewsCheckerItem.DoGetResourceInfo(AResourceInfo: TclResourceInfo);
begin
  inherited DoGetResourceInfo(AResourceInfo);
  FIsNewsExist := False;
  if FIsNewsMode then
  begin
    FIsNewsExist := HasNews();
    if not FIsNewsExist then
    begin
      Stop();
    end;
  end;
end;

procedure TclNewsCheckerItem.IsNews(var IsNews, Handled: Boolean);
begin
  GetNewsChecker().DoIsNews(IsNews, Handled);
end;

function TclNewsCheckerItem.GetNewsChecker: TclNewsChecker;
begin
  Result := (Control as TclNewsChecker);
end;

procedure TclNewsCheckerItem.InternalStart(AIsGetResourceInfo: Boolean);
begin
  FIsNewsMode := not AIsGetResourceInfo;
  inherited InternalStart(AIsGetResourceInfo);
end;

{$IFDEF DELPHI6}
  {$WARNINGS OFF}
{$ENDIF}

function TclNewsCheckerItem.HasNews: Boolean;
var
  h: THandle;
  Handled: Boolean;
  pTime: TFileTime;
  p: DWORD;
  hSize, pp: Int64;
begin
  Result := False;
  Handled := False;
  IsNews(Result, Handled);
  if (ResourceInfo = nil) or (Errors.Count > 0) or Handled then Exit;
  h := CreateFile(PChar(LocalFile), GENERIC_READ, FILE_SHARE_READ, nil,
    OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  Result := (h <> INVALID_HANDLE_VALUE);
  if Result then
  begin
    hSize := GetFileSize(h, @p);
    pp := p;
    hSize := hSize or (pp shl 32);  

    Result := GetFileTime(h, nil, nil, @pTime) and (hSize > - 1);
    if Result then
    begin
      Result := (Int(ConvertFileTimeToDateTime(pTime)) = Int(ResourceInfo.Date)) and (hSize = ResourceInfo.Size);
    end;
  end;
  if (h <> INVALID_HANDLE_VALUE) then
  begin
    CloseHandle(h);
  end;
  Result := not Result;
end;

{$IFDEF DELPHI6}
  {$WARNINGS ON}
{$ENDIF}

procedure TclNewsCheckerItem.NewsExist();
begin
  GetNewsChecker().DoNewsExist();
end;

procedure TclNewsCheckerItem.ProcessCompleted(AThreader: TclCustomThreader);
begin
  inherited ProcessCompleted(AThreader);
  if not IsBusy and FIsNewsMode then
  begin
    FIsNewsMode := False;
    if (ResourceState.LastStatus = psSuccess) and FIsNewsExist then
    begin
      NewsExist();
    end;
  end;
end;

{ TclNewsChecker }

function TclNewsChecker.GetInternetItemClass: TclInternetItemClass;
begin
  Result := TclNewsCheckerItem;
end;

procedure TclNewsChecker.DoNewsExist;
begin
  if Assigned(FOnNewsExist) then
  begin
    FOnNewsExist(Self);
  end;
end;

procedure TclNewsChecker.DoIsNews(var IsNews, Handled: Boolean);
begin
  if Assigned(FOnIsNews) then
  begin
    FOnIsNews(Self, IsNews, Handled);
  end;
end;

function TclNewsChecker.GetIsNewsExist: Boolean;
begin
  Result := (GetInternetItem() as TclNewsCheckerItem).FIsNewsExist;
end;

constructor TclNewsChecker.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  CorrectResourceTime := True;
end;

end.

