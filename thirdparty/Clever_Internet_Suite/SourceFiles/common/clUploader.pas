{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clUploader;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes,
{$ELSE}
  System.Classes,
{$ENDIF}
  clMultiDC, clSingleDC, clDCUtils, clMultiUploader, clHttpRequest;

type
  TclSingleUploadItem = class(TclUploadItem)
  protected
    function GetForceRemoteDir: Boolean; override;
    function GetControl: TclCustomInternetControl; override;
  end;

  TclUploader = class(TclSingleInternetControl)
  private
    FForceRemoteDir: Boolean;
    function GetUploadItem(): TclSingleUploadItem;
    function GetHttpResponse: TStrings;
    function GetHttpResponseStream: TStream;
    function GetUseSimpleRequest: Boolean;
    procedure SetHttpResponseStream(const Value: TStream);
    procedure SetUseSimpleRequest(const Value: Boolean);
    function GetRequestMethod: string;
    procedure SetRequestMethod(const Value: string);
  protected
    function GetInternetItemClass(): TclInternetItemClass; override;
  public
    property HttpResponse: TStrings read GetHttpResponse;
    property HttpResponseStream: TStream read GetHttpResponseStream write SetHttpResponseStream;
  published
    property ThreadCount default 1;
    property UseSimpleRequest: Boolean read GetUseSimpleRequest write SetUseSimpleRequest default False;
    property RequestMethod: string read GetRequestMethod write SetRequestMethod;
    property ForceRemoteDir: Boolean read FForceRemoteDir write FForceRemoteDir default False;
  end;

implementation

{ TclSingleUploadItem }

type
  TCollectionAccess = class(TCollection);

function TclSingleUploadItem.GetControl: TclCustomInternetControl;
begin
  Result := (TCollectionAccess(Collection).GetOwner() as TclCustomInternetControl);
end;

function TclSingleUploadItem.GetForceRemoteDir: Boolean;
begin
  Result := (Control as TclUploader).ForceRemoteDir;
end;

{ TclUploader }

function TclUploader.GetInternetItemClass: TclInternetItemClass;
begin
  Result := TclSingleUploadItem;
end;

function TclUploader.GetHttpResponse: TStrings;
begin
  Result := GetUploadItem().HttpResponse;
end;

function TclUploader.GetHttpResponseStream: TStream;
begin
  Result := GetUploadItem().HttpResponseStream;
end;

function TclUploader.GetUploadItem(): TclSingleUploadItem;
begin
  Result := (GetInternetItem() as TclSingleUploadItem);
end;

function TclUploader.GetUseSimpleRequest: Boolean;
begin
  Result := GetUploadItem().UseSimpleRequest;
end;

procedure TclUploader.SetHttpResponseStream(const Value: TStream);
begin
  GetUploadItem().HttpResponseStream := Value;
end;

procedure TclUploader.SetUseSimpleRequest(const Value: Boolean);
begin
  GetUploadItem().UseSimpleRequest := Value;
end;

function TclUploader.GetRequestMethod: string;
begin
  Result := GetUploadItem().RequestMethod;
end;

procedure TclUploader.SetRequestMethod(const Value: string);
begin
  GetUploadItem().RequestMethod := Value;
end;

end.
