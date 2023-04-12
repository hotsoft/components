{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clDownLoader;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes,
{$ELSE}
  System.Classes,
{$ENDIF}
  clDCUtils, clUtils, clSingleDC, clMultiDC, clMultiDownLoader;

type
  TclOnSingleDataTextProceed = procedure (Sender: TObject; Text: TStrings) of object;

  TclDownLoader = class;

  TclSingleDownLoadItem = class(TclDownLoadItem)
  private
    function GetDownLoader: TclDownLoader;
  protected
    procedure DoDataTextProceed(Text: TStrings); override;
    function GetCorrectResourceTime: Boolean; override;
    function GetPreviewCharCount: Integer; override;
    function GetLocalFolder: string; override;
    function GetControl: TclCustomInternetControl; override;
  end;

  TclDownLoader = class(TclSingleInternetControl)
  private
    FLocalFolder: string;
    FOnDataTextProceed: TclOnSingleDataTextProceed;
    FCorrectResourceTime: Boolean;
    FPreviewCharCount: Integer;
    procedure SetLocalFolder(const Value: string);
    function GetPreview: TStrings;
    procedure SetPreviewCharCount(const Value: Integer);
    function GetDownloadItem(): TclSingleDownLoadItem;
    function GetAllowCompression: Boolean;
    procedure SetAllowCompression(const Value: Boolean);
  protected
    function GetInternetItemClass(): TclInternetItemClass; override;
    procedure DoDataTextProceed(Text: TStrings); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    property Preview: TStrings read GetPreview;
  published
    property LocalFolder: string read FLocalFolder write SetLocalFolder;
    property PreviewCharCount: Integer read FPreviewCharCount write SetPreviewCharCount default DefaultPreviewCharCount;
    property CorrectResourceTime: Boolean read FCorrectResourceTime write FCorrectResourceTime default True;
    property AllowCompression: Boolean read GetAllowCompression write SetAllowCompression default True;
    property OnDataTextProceed: TclOnSingleDataTextProceed read FOnDataTextProceed write FOnDataTextProceed;
  end;

implementation

{ TclDownLoader }

constructor TclDownLoader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPreviewCharCount := DefaultPreviewCharCount;
  FCorrectResourceTime := True;
end;

procedure TclDownLoader.DoDataTextProceed(Text: TStrings);
begin
  if Assigned(FOnDataTextProceed) then
  begin
    FOnDataTextProceed(Self, Text);
  end;
end;

function TclDownLoader.GetAllowCompression: Boolean;
begin
  Result := GetDownloadItem().AllowCompression;
end;

function TclDownLoader.GetDownloadItem(): TclSingleDownLoadItem;
begin
  Result := (GetInternetItem() as TclSingleDownLoadItem);
end;

function TclDownLoader.GetInternetItemClass(): TclInternetItemClass;
begin
  Result := TclSingleDownLoadItem;
end;

function TclDownLoader.GetPreview(): TStrings;
begin
  Result := GetDownloadItem().Preview;
end;

procedure TclDownLoader.SetAllowCompression(const Value: Boolean);
begin
  GetDownloadItem().AllowCompression := Value;
end;

procedure TclDownLoader.SetLocalFolder(const Value: string);
begin
  if (FLocalFolder = Value) then Exit;
  FLocalFolder := Value;
  if (csLoading in ComponentState) then Exit;
  LocalFile := GetFullFileName(LocalFile, FLocalFolder);
  Changed(GetInternetItem());
end;

procedure TclDownLoader.SetPreviewCharCount(const Value: Integer);
begin
  if (FPreviewCharCount <> Value) and (Value > - 1) then
  begin
    FPreviewCharCount := Value;
  end;
end;

{ TclSingleDownLoadItem }

procedure TclSingleDownLoadItem.DoDataTextProceed(Text: TStrings);
begin
  GetDownLoader().DoDataTextProceed(Text);
end;

type
  TCollectionAccess = class(TCollection);

function TclSingleDownLoadItem.GetControl: TclCustomInternetControl;
begin                                                 
  Result := (TCollectionAccess(Collection).GetOwner() as TclCustomInternetControl);
end;

function TclSingleDownLoadItem.GetCorrectResourceTime: Boolean;
begin
  Result := GetDownLoader().CorrectResourceTime;
end;

function TclSingleDownLoadItem.GetDownLoader: TclDownLoader;
begin
  Result := (Control as TclDownLoader);
end;

function TclSingleDownLoadItem.GetLocalFolder: string;
begin
  Result := GetDownloader().LocalFolder;
end;

function TclSingleDownLoadItem.GetPreviewCharCount: Integer;
begin
  Result := GetDownloader().PreviewCharCount;
end;

end.
