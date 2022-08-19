{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSingleDC;

interface

{$I clVer.inc}
{$IFDEF DELPHI7}
  {$WARN UNSAFE_CODE OFF}
  {$WARN UNSAFE_TYPE OFF}
{$ENDIF}

uses
{$IFNDEF DELPHIXE2}
  Classes, Windows,
{$ELSE}
  System.Classes, Winapi.Windows,
{$ENDIF}
  clDC, clUtils, clDCUtils, clWinInet, clMultiDC, clResourceState, clHttpRequest, clCryptApi,
  clInternetConnection, clCertificate, clCertificateStore, clSspiTls, clUriUtils, clWUtils;

type
  TclOnSingleDataItemProceed = procedure (Sender: TObject; ResourceInfo: TclResourceInfo;
    AStateItem: TclResourceStateItem; CurrentData: PclChar; CurrentDataSize: Integer) of object;

  TclSingleInternetControl = class(TclCustomInternetControl)
  private
    FList: TOwnedCollection;
    FOnDataItemProceed: TclOnSingleDataItemProceed;
    FOnError: TclOnError;
    FOnGetResourceInfo: TclOnGetResourceInfo;
    FOnStatusChanged: TclOnStatusChanged;
    FOnUrlParsing: TclOnUrlParsing;
    FOnChanged: TNotifyEvent;
    FOnGetCertificate: TclGetCertificateEvent;
    FOnProcessCompleted: TNotifyEvent;
    
    function GetCertificateFlags: TclCertificateVerifyFlags;
    function GetDataStream: TStream;
    function GetErrors: TclErrorList;
    function GetLocalFile: string;
    function GetPassword: string;
    function GetPriority: TclProcessPriority;
    function GetURL: string;
    function GetUserName_: string;
    procedure SetCertificateFlags(const Value: TclCertificateVerifyFlags);
    procedure SetDataStream(const Value: TStream);
    procedure SetLocalFile(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetPriority(const Value: TclProcessPriority);
    procedure SetURL(const Value: string);
    procedure SetUserName(const Value: string);
    function GetPort_: Integer;
    procedure SetPort_(const Value: Integer);
    function GetResourceState: TclResourceStateList;
    procedure SetKeepConnection(const Value: Boolean);
    function GetThreadCount: Integer;
    function GetKeepConnection: Boolean;
    procedure SetThreadCount(const Value: Integer);
    function GetInternalResourceInfo: TclResourceInfo;
    function GetHttpRequest: TclHttpRequest;
    procedure SetHttpRequest(const Value: TclHttpRequest);
    function GetResourceConnectionCount: Integer;
    function GetResourceConnections(Index: Integer): TclInternetConnection;
    function GetUseHttpRequest: Boolean;
    procedure SetUseHttpRequest(const Value: Boolean);
    function GetHttpResponseHeader: TStrings;
  protected
    procedure NotifyInternetItems(AComponent: TComponent); override;
    function GetInternetItem(): TclInternetItem;
    function GetInternetItemClass(): TclInternetItemClass; virtual; abstract;
    procedure Changed(Item: TclInternetItem); override;
    procedure DoGetCertificate(Item: TclInternetItem; var ACertificate: TclCertificate;
      AExtraCerts: TclCertificateList; var Handled: Boolean); override;
    procedure DoURLParsing(Item: TclInternetItem; var URLComponents: TURLComponents); override;
    procedure DoGetResourceInfo(Item: TclInternetItem; AResourceInfo: TclResourceInfo); override;
    procedure DoStatusChanged(Item: TclInternetItem; Status: TclProcessStatus); override;
    procedure DoDataItemProceed(Item: TclInternetItem; ResourceInfo: TclResourceInfo;
      AStateItem: TclResourceStateItem; CurrentData: PclChar; CurrentDataSize: Integer); override;
    procedure DoError(Item: TclInternetItem; const Error: string; ErrorCode: Integer); override;
    procedure DoProcessCompleted(Item: TclInternetItem); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;
    procedure CloseConnection();
    procedure Stop;
    function GetResourceInfo(IsAsynch: Boolean = True): TclResourceInfo;
    procedure Start(IsAsynch: Boolean = True);
    procedure DeleteRemoteFile;
    function GetThreader(Index: Integer): TclCustomThreader;
    property Errors: TclErrorList read GetErrors;
    property ResourceInfo: TclResourceInfo read GetInternalResourceInfo;
    property ResourceState: TclResourceStateList read GetResourceState;
    property ResourceConnections[Index: Integer]: TclInternetConnection read GetResourceConnections;
    property ResourceConnectionCount: Integer read GetResourceConnectionCount;
    property DataStream: TStream read GetDataStream write SetDataStream;
    property HttpResponseHeader: TStrings read GetHttpResponseHeader;
  published
    property ThreadCount: Integer read GetThreadCount write SetThreadCount default DefaultThreadCount;
    property KeepConnection: Boolean read GetKeepConnection write SetKeepConnection default False;
    property URL: string read GetURL write SetURL;
    property LocalFile: string read GetLocalFile write SetLocalFile;
    property UserName: string read GetUserName_ write SetUserName;
    property Password: string read GetPassword write SetPassword;
    property Port: Integer read GetPort_ write SetPort_ default 0;
    property Priority: TclProcessPriority read GetPriority write SetPriority default ppNormal;
    property CertificateFlags: TclCertificateVerifyFlags read GetCertificateFlags write SetCertificateFlags default [];
    property UseHttpRequest: Boolean read GetUseHttpRequest write SetUseHttpRequest default False;
    property HttpRequest: TclHttpRequest read GetHttpRequest write SetHttpRequest;

    property OnStatusChanged: TclOnStatusChanged read FOnStatusChanged write FOnStatusChanged;
    property OnGetResourceInfo: TclOnGetResourceInfo read FOnGetResourceInfo write FOnGetResourceInfo;
    property OnDataItemProceed: TclOnSingleDataItemProceed read FOnDataItemProceed write FOnDataItemProceed;
    property OnError: TclOnError read FOnError write FOnError;
    property OnUrlParsing: TclOnUrlParsing read FOnUrlParsing write FOnUrlParsing;
    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnGetCertificate: TclGetCertificateEvent read FOnGetCertificate write FOnGetCertificate;
    property OnProcessCompleted: TNotifyEvent read FOnProcessCompleted write FOnProcessCompleted;
  end;

implementation

{ TclSingleInternetControl }

procedure TclSingleInternetControl.Changed(Item: TclInternetItem);
begin
  if Assigned(FOnChanged) then
  begin
    FOnChanged(Self);
  end;
end;

procedure TclSingleInternetControl.DoDataItemProceed(Item: TclInternetItem;
  ResourceInfo: TclResourceInfo; AStateItem: TclResourceStateItem;
  CurrentData: PclChar; CurrentDataSize: Integer);
begin
  if Assigned(FOnDataItemProceed) then
  begin
    FOnDataItemProceed(Self, ResourceInfo, AStateItem, CurrentData, CurrentDataSize);
  end;
  inherited DoDataItemProceed(Item, ResourceInfo, AStateItem, CurrentData, CurrentDataSize);
end;

procedure TclSingleInternetControl.DoError(Item: TclInternetItem; const Error: string; ErrorCode: Integer);
begin
  if Assigned(FOnError) then
  begin
    FOnError(Self, Error, ErrorCode);
  end;
end;

procedure TclSingleInternetControl.DoGetResourceInfo(Item: TclInternetItem; AResourceInfo: TclResourceInfo);
begin
  if Assigned(FOnGetResourceInfo) then
  begin
    FOnGetResourceInfo(Self, AResourceInfo);
  end;
end;

procedure TclSingleInternetControl.DoStatusChanged(Item: TclInternetItem; Status: TclProcessStatus);
begin
  if Assigned(FOnStatusChanged) then
  begin
    FOnStatusChanged(Self, Status);
  end;
  inherited DoStatusChanged(Item, Status);
end;

procedure TclSingleInternetControl.DoURLParsing(Item: TclInternetItem; var URLComponents: TURLComponents);
begin
  if Assigned(FOnUrlParsing) then
  begin
    FOnUrlParsing(Self, URLComponents);
  end;
end;

function TclSingleInternetControl.GetResourceInfo(IsAsynch: Boolean): TclResourceInfo;
begin
  Result := GetInternetItem().GetResourceInfo(IsAsynch);
end;

procedure TclSingleInternetControl.Start(IsAsynch: Boolean);
begin
  GetInternetItem().Start(IsAsynch);
end;

procedure TclSingleInternetControl.Stop;
begin
  GetInternetItem().Stop();
end;

procedure TclSingleInternetControl.DoProcessCompleted(Item: TclInternetItem);
begin
  if Assigned(FOnProcessCompleted) then
  begin
    FOnProcessCompleted(Self);
  end;
end;

procedure TclSingleInternetControl.DoGetCertificate(Item: TclInternetItem;
  var ACertificate: TclCertificate; AExtraCerts: TclCertificateList; var Handled: Boolean);
begin
  if Assigned(FOnGetCertificate) then
  begin
    FOnGetCertificate(Self, ACertificate, AExtraCerts, Handled);
  end;
end;

function TclSingleInternetControl.GetCertificateFlags: TclCertificateVerifyFlags;
begin
  Result := GetInternetItem().CertificateFlags;
end;

function TclSingleInternetControl.GetDataStream: TStream;
begin
  Result := GetInternetItem().DataStream;
end;

function TclSingleInternetControl.GetErrors: TclErrorList;
begin
  Result := GetInternetItem().Errors;
end;

function TclSingleInternetControl.GetLocalFile: string;
begin
  Result := GetInternetItem().LocalFile;
end;

function TclSingleInternetControl.GetPassword: string;
begin
  Result := GetInternetItem().Password;
end;

function TclSingleInternetControl.GetPriority: TclProcessPriority;
begin
  Result := GetInternetItem().Priority;
end;

function TclSingleInternetControl.GetURL: string;
begin
  Result := GetInternetItem().URL;
end;

function TclSingleInternetControl.GetUserName_: string;
begin
  Result := GetInternetItem().UserName;
end;

procedure TclSingleInternetControl.SetCertificateFlags(const Value: TclCertificateVerifyFlags);
begin
  GetInternetItem().CertificateFlags := Value;
end;

procedure TclSingleInternetControl.SetDataStream(const Value: TStream);
begin
  GetInternetItem().DataStream := Value;
end;

procedure TclSingleInternetControl.SetLocalFile(const Value: string);
begin
  GetInternetItem().LocalFile := Value;
end;

procedure TclSingleInternetControl.SetPassword(const Value: string);
begin
  GetInternetItem().Password := Value;
end;

procedure TclSingleInternetControl.SetPriority(const Value: TclProcessPriority);
begin
  GetInternetItem().Priority := Value;
end;

procedure TclSingleInternetControl.SetURL(const Value: string);
begin
  GetInternetItem().URL := Value;
end;

procedure TclSingleInternetControl.SetUserName(const Value: string);
begin
  GetInternetItem().UserName := Value;
end;

function TclSingleInternetControl.GetResourceState: TclResourceStateList;
begin
  Result := GetInternetItem().ResourceState;
end;

procedure TclSingleInternetControl.SetKeepConnection(const Value: Boolean);
begin
  GetInternetItem().KeepConnection := Value;
end;

function TclSingleInternetControl.GetThreadCount: Integer;
begin
  Result := GetInternetItem().ThreadCount;
end;

function TclSingleInternetControl.GetKeepConnection: Boolean;
begin
  Result := GetInternetItem().KeepConnection;
end;

procedure TclSingleInternetControl.SetThreadCount(const Value: Integer);
begin
  GetInternetItem().ThreadCount := Value;
end;

procedure TclSingleInternetControl.CloseConnection;
begin
  GetInternetItem().CloseConnection();
end;

constructor TclSingleInternetControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FList := TOwnedCollection.Create(Self, GetInternetItemClass());
  FList.Add();
end;

destructor TclSingleInternetControl.Destroy();
begin
  FList.Free();
  inherited Destroy();
end;

function TclSingleInternetControl.GetInternetItem(): TclInternetItem;
begin
  Result := (FList.Items[0] as TclInternetItem);
end;

function TclSingleInternetControl.GetInternalResourceInfo: TclResourceInfo;
begin
  Result := GetInternetItem().ResourceInfo;
end;

type
  TclInternetItemAccess = class(TclInternetItem);

procedure TclSingleInternetControl.NotifyInternetItems(AComponent: TComponent);
begin
  if (GetInternetItem().HttpRequest = AComponent) then
  begin
    TclInternetItemAccess(GetInternetItem()).InternalSetHttpRequest(nil);
  end;
end;

function TclSingleInternetControl.GetHttpRequest: TclHttpRequest;
begin
  Result := GetInternetItem().HttpRequest;
end;

procedure TclSingleInternetControl.SetHttpRequest(const Value: TclHttpRequest);
begin
  GetInternetItem().HttpRequest := Value;
end;

function TclSingleInternetControl.GetResourceConnectionCount: Integer;
begin
  Result := GetInternetItem().ResourceConnectionCount;
end;

function TclSingleInternetControl.GetResourceConnections(
  Index: Integer): TclInternetConnection;
begin
  Result := GetInternetItem().ResourceConnections[Index];
end;

function TclSingleInternetControl.GetUseHttpRequest: Boolean;
begin
  Result := GetInternetItem().UseHttpRequest;
end;

procedure TclSingleInternetControl.SetUseHttpRequest(const Value: Boolean);
begin
  GetInternetItem().UseHttpRequest := Value;
end;

function TclSingleInternetControl.GetHttpResponseHeader: TStrings;
begin
  Result := GetInternetItem().HttpResponseHeader;
end;

procedure TclSingleInternetControl.DeleteRemoteFile;
begin
  GetInternetItem().DeleteRemoteFile();
end;

function TclSingleInternetControl.GetPort_: Integer;
begin
  Result := GetInternetItem().Port;
end;

procedure TclSingleInternetControl.SetPort_(const Value: Integer);
begin
  GetInternetItem().Port := Value;
end;

function TclSingleInternetControl.GetThreader(Index: Integer): TclCustomThreader;
begin
  Result := GetInternetItem().GetThreader(Index);
end;

end.
