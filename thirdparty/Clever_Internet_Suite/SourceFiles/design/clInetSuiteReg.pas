{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clInetSuiteReg;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, TypInfo,
{$ELSE}
  System.Classes, System.SysUtils, System.TypInfo,
{$ENDIF}
  DesignEditors, DesignIntf,
  clDEditors, clAsyncClient, clBounceChecker, clCertificateStore, clCookieManager, clCryptEncoder, clDkim, clDnsFileHandler, clDnsQuery,
  clDnsServer, clDownLoader, clEmailValidator, clEncoder, clEncryptor, clEpp, clEppServer, clFtp, clFtpFileHandler,
  clFtpServer, clGZip, clHtmlParser, clHttp, clHttpRequest, {$IFDEF DELPHI2005}clHttpRio, {$ENDIF}clImap4, clImap4FileHandler, clImap4Server,
  clInternetConnection, clMailMessage, clMultiDownLoader, clMultiUploader, clNewsChecker, clNntp, clNntpFileHandler,
  clNntpServer, clOAuth, clPop3, clPop3FileHandler, clPop3Server, clProgressBar, clProgressBarDC, clRss, clServerGuard,
  clSimpleHttpServer, clSMimeMessage, clSmtp, clSmtpFileHandler, clSmtpRelay, clSmtpServer, clSoapMessage, clThreadPool,
  clUploader, clWebDav, clWebUpdate, clSFtp;

type
  TclMessageBodyProperty = class(TPropertyEditor)
  public
    function GetValue: string; override;
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TclMessageBodyEditor = class(TclBaseEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TclRequestItemProperty = class(TPropertyEditor)
  public
    function GetValue: string; override;
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TclHttpRequestEditor = class(TclBaseEditor)
  public
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

procedure Register;

implementation

uses
  clRequestEdit, clBodyEdit, clDCUtils;

const
  cHttpRequestEditor = 'Edit HTTP Request...';
  cMessageBodyEditor = 'Edit Mail Message...';

procedure Register;
begin
  RegisterComponents('Clever Internet Suite', [
    TclAsyncClient, TclBounceChecker, TclCertificateStore, TclCookieManager, TclCryptEncoder, TclDkim, TclDnsFileHandler, TclDnsQuery, TclDnsServer,
    TclDownLoader, TclEmailValidator, TclEncoder, TclEncryptor, TclEpp, TclEppServer, TclFtp, TclFtpFileHandler,
    TclFtpServer, TclGZip, TclHtmlParser, TclHttp, TclHttpRequest, {$IFDEF DELPHI2005}TclHttpRio, {$ENDIF}TclImap4, TclImap4FileHandler, TclImap4Server,
    TclInternetConnection, TclMailMessage, TclMultiDownLoader, TclMultiUploader, TclNewsChecker, TclNntp, TclNntpFileHandler,
    TclNntpServer, TclOAuth, TclPop3, TclPop3FileHandler, TclPop3Server, TclProgressBar, TclProgressBarDC, TclRss,
    TclServerGuard, TclSFtp, TclSimpleHttpServer, TclSMimeMessage, TclSmtp, TclSmtpFileHandler, TclSmtpRelay, TclSmtpServer,
    TclSoapMessage, TclThreadPool, TclUploader, TclWebDav, TclWebUpdate
  ]);

  RegisterComponentEditor(TclAsyncClient, TclBaseEditor);
  RegisterComponentEditor(TclBounceChecker, TclBaseEditor);
  RegisterComponentEditor(TclCertificateStore, TclBaseEditor);
  RegisterComponentEditor(TclCookieManager, TclBaseEditor);
  RegisterComponentEditor(TclCryptEncoder, TclBaseEditor);
  RegisterComponentEditor(TclDkim, TclBaseEditor);
  RegisterComponentEditor(TclDnsFileHandler, TclBaseEditor);
  RegisterComponentEditor(TclDnsQuery, TclBaseEditor);
  RegisterComponentEditor(TclDnsServer, TclBaseEditor);
  RegisterComponentEditor(TclDownLoader, TclBaseEditor);
  RegisterComponentEditor(TclEmailValidator, TclBaseEditor);
  RegisterComponentEditor(TclEncoder, TclBaseEditor);
  RegisterComponentEditor(TclEncryptor, TclBaseEditor);
  RegisterComponentEditor(TclEpp, TclBaseEditor);
  RegisterComponentEditor(TclEppServer, TclBaseEditor);
  RegisterComponentEditor(TclFtp, TclBaseEditor);
  RegisterComponentEditor(TclFtpFileHandler, TclBaseEditor);
  RegisterComponentEditor(TclFtpServer, TclBaseEditor);
  RegisterComponentEditor(TclGZip, TclBaseEditor);
  RegisterComponentEditor(TclHtmlParser, TclBaseEditor);
  RegisterComponentEditor(TclHttp, TclBaseEditor);
  RegisterComponentEditor(TclHttpRequest, TclHttpRequestEditor);
{$IFDEF DELPHI2005}
  RegisterComponentEditor(TclHttpRio, TclBaseEditor);
{$ENDIF}  
  RegisterComponentEditor(TclImap4, TclBaseEditor);
  RegisterComponentEditor(TclImap4FileHandler, TclBaseEditor);
  RegisterComponentEditor(TclImap4Server, TclBaseEditor);
  RegisterComponentEditor(TclInternetConnection, TclBaseEditor);
  RegisterComponentEditor(TclMailMessage, TclMessageBodyEditor);
  RegisterComponentEditor(TclMultiDownLoader, TclBaseEditor);
  RegisterComponentEditor(TclMultiUploader, TclBaseEditor);
  RegisterComponentEditor(TclNewsChecker, TclBaseEditor);
  RegisterComponentEditor(TclNntp, TclBaseEditor);
  RegisterComponentEditor(TclNntpFileHandler, TclBaseEditor);
  RegisterComponentEditor(TclNntpServer, TclBaseEditor);
  RegisterComponentEditor(TclOAuth, TclBaseEditor);
  RegisterComponentEditor(TclPop3, TclBaseEditor);
  RegisterComponentEditor(TclPop3FileHandler, TclBaseEditor);
  RegisterComponentEditor(TclPop3Server, TclBaseEditor);
  RegisterComponentEditor(TclProgressBar, TclBaseEditor);
  RegisterComponentEditor(TclProgressBarDC, TclBaseEditor);
  RegisterComponentEditor(TclRss, TclBaseEditor);
  RegisterComponentEditor(TclServerGuard, TclBaseEditor);
  RegisterComponentEditor(TclSFtp, TclBaseEditor);
  RegisterComponentEditor(TclSimpleHttpServer, TclBaseEditor);
  RegisterComponentEditor(TclSMimeMessage, TclMessageBodyEditor);
  RegisterComponentEditor(TclSmtp, TclBaseEditor);
  RegisterComponentEditor(TclSmtpFileHandler, TclBaseEditor);
  RegisterComponentEditor(TclSmtpRelay, TclBaseEditor);
  RegisterComponentEditor(TclSmtpServer, TclBaseEditor);
  RegisterComponentEditor(TclSoapMessage, TclHttpRequestEditor);
  RegisterComponentEditor(TclThreadPool, TclBaseEditor);
  RegisterComponentEditor(TclUploader, TclBaseEditor);
  RegisterComponentEditor(TclWebDav, TclBaseEditor);
  RegisterComponentEditor(TclWebUpdate, TclBaseEditor);

  RegisterPropertyEditor(TypeInfo(string), TclDownLoader, 'LocalFile', TclSaveFileProperty);
  RegisterPropertyEditor(TypeInfo(string), TclDownLoadItem, 'LocalFile', TclSaveFileProperty);
  RegisterPropertyEditor(TypeInfo(string), TclUploader, 'LocalFile', TclOpenFileProperty);
  RegisterPropertyEditor(TypeInfo(string), TclUploadItem, 'LocalFile', TclOpenFileProperty);
  RegisterPropertyEditor(TypeInfo(TclMessageBodies), TclMailMessage, 'Bodies', TclMessageBodyProperty);
  RegisterPropertyEditor(TypeInfo(TclHttpRequestItemList), TclHttpRequest, 'Items', TclRequestItemProperty);
end;

{ TclMessageBodyEditor }

procedure TclMessageBodyEditor.ExecuteVerb(Index: Integer);
begin
  inherited ExecuteVerb(Index);
  if ModifyMessageBodies(TclMailMessage(Component).Bodies) then
  begin
    Designer.Modified;
  end;
end;

function TclMessageBodyEditor.GetVerb(Index: Integer): string;
begin
  Result := inherited GetVerb(Index);
  if Index = GetVerbCount() - 1 then
  begin
    Result := cMessageBodyEditor;
  end;
end;

function TclMessageBodyEditor.GetVerbCount: Integer;
begin
  Result := inherited GetVerbCount() + 1;
end;

{ TclMessageBodyProperty }

procedure TclMessageBodyProperty.Edit;
begin
  if ModifyMessageBodies(TclMailMessage(GetComponent(0)).Bodies) then Modified;
end;

function TclMessageBodyProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TclMessageBodyProperty.GetValue: string;
begin
  Result := Format('(%s)', [TclMessageBodies.ClassName]);
end;

{ TclHttpRequestEditor }

procedure TclHttpRequestEditor.ExecuteVerb(Index: Integer);
begin
  inherited ExecuteVerb(Index);
  if ModifyHttpRequest(TclHttpRequest(Component)) then
  begin
    Designer.Modified;
  end;
end;

function TclHttpRequestEditor.GetVerb(Index: Integer): string;
begin
  Result := inherited GetVerb(Index);
  if Index = GetVerbCount() - 1 then
  begin
    Result := cHttpRequestEditor;
  end;
end;

function TclHttpRequestEditor.GetVerbCount: Integer;
begin
  Result := inherited GetVerbCount() + 1;
end;

{ TclRequestItemProperty }

procedure TclRequestItemProperty.Edit;
begin
  if ModifyHttpRequest(TclHttpRequest(GetComponent(0))) then Modified;
end;

function TclRequestItemProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

function TclRequestItemProperty.GetValue: string;
begin
  Result := Format('(%s)', [TclHttpRequestItemList.ClassName]);
end;

end.
