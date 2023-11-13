{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clImap4Server;

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
  Classes, SysUtils, Contnrs, SyncObjs, Windows, WinSock,
{$ELSE}
  System.Classes, System.SysUtils, System.Contnrs, System.SyncObjs, Winapi.Windows, Winapi.WinSock,
{$ENDIF}
  clTcpServer, clTcpServerTls, clTcpCommandServer, clSocket, clUserMgr, clImapUtils, clSspi,
  clSspiAuth, clMailUtils, clMailUserMgr, clMailMessage, clImapFetch, clWUtils, clSocketUtils;

type
  EclImap4ServerError = class(EclTcpCommandServerError)
  private
    FTag: string;
  public
    constructor Create(const ATag, ACommand, AErrorMsg: string; AErrorCode: Integer); overload;
    constructor Create(const ATag, ACommand, AErrorMsg: string;
      AErrorCode: Integer; ANeedClose: Boolean); overload;
    property Tag: string read FTag;
  end;

  TclImap4AuthMode = (imUseIMAPLogin, imUseSASL, imUseBoth);

  TclImap4MailBoxAttribute = (maNoinferiors, maNoselect, maMarked, maUnmarked);
  TclImap4MailBoxAttributes = set of TclImap4MailBoxAttribute;

  TclImap4MailBoxItem = class(TCollectionItem)
  private
    FName: string;
    FIsSubscribed: Boolean;
    FFlags: TclMailMessageFlags;
    FChangeableFlags: TclMailMessageFlags;
    FUIDNext: Integer;
    FUIDValidity: string;
    FAttributes: TclImap4MailBoxAttributes;
    FData: Pointer;
  public
    constructor Create(Collection: TCollection); override;

    property Name: string read FName write FName;
    property IsSubscribed: Boolean read FIsSubscribed write FIsSubscribed;
    property Flags: TclMailMessageFlags read FFlags write FFlags;
    property ChangeableFlags: TclMailMessageFlags read FChangeableFlags write FChangeableFlags;
    property UIDNext: Integer read FUIDNext write FUIDNext;
    property UIDValidity: string read FUIDValidity write FUIDValidity;
    property Attributes: TclImap4MailBoxAttributes read FAttributes write FAttributes;
    property Data: Pointer read FData write FData;
  end;

  TclImap4MailBoxList = class(TCollection)
  private
    function GetItem(Index: Integer): TclImap4MailBoxItem;
    procedure SetItem(Index: Integer; const Value: TclImap4MailBoxItem);
  public
    function Add: TclImap4MailBoxItem;
    property Items[Index: Integer]: TclImap4MailBoxItem read GetItem write SetItem; default;
  end;

  TclImap4MessageItem = class
  private
    FName: string;
    FDate: TDateTime;
    FUID: Integer;
    FID: Integer;
    FFlags: TclMailMessageFlags;
  public
    constructor Create; overload;
    constructor Create(const AName: string); overload;
    constructor Create(const AName: string; AUid: Integer; AFlags: TclMailMessageFlags); overload;
    constructor Create(const AName: string; AUid: Integer; AFlags: TclMailMessageFlags; ADate: TDateTime); overload;

    property Name: string read FName write FName;
    property UID: Integer read FUID write FUID;
    property ID: Integer read FID write FID;
    property Flags: TclMailMessageFlags read FFlags write FFlags;
    property Date: TDateTime read FDate write FDate;
  end;

  TclImap4MessageList = class
  private
    FList: TObjectList;
    FUids: TStrings;
    
    function GetCount: Integer;
    function GetItem(Index: Integer): TclImap4MessageItem;
    procedure InitMessageIDs;
    function GetSeqNum(const ASource: string; AUids: TStrings; AUseUid: Boolean): Integer;
    function GetUidList: TStrings;
    procedure DoCreate(AOwnsObjects: Boolean);
    function GetOwnsObjects: Boolean;
  public
    constructor Create(AOwnsObjects: Boolean); overload;
    constructor Create; overload;
    destructor Destroy; override;

    procedure Add(AItem: TclImap4MessageItem);
    procedure Delete(Index: Integer);
    procedure Clear;
    function SelectMessages(const AMessageSet: string; AUseUid: Boolean): TclImap4MessageList;
    function SelectByFlag(AFlag: TclMailMessageFlag): TclImap4MessageList;
    function FindByName(const AName: string): TclImap4MessageItem;

    property Items[Index: Integer]: TclImap4MessageItem read GetItem; default;
    property Count: Integer read GetCount;
    property OwnsObjects: Boolean read GetOwnsObjects;
  end;

  TclAppendMessageInfo = class
  private
    FDate: TDateTime;
    FMailBox: string;
    FFlags: TclMailMessageFlags;
  public
    constructor Create;

    property MailBox: string read FMailBox write FMailBox;
    property Flags: TclMailMessageFlags read FFlags write FFlags;
    property Date: TDateTime read FDate write FDate;
  end;

  TclImap4CommandConnection = class(TclCommandConnection)
  private
    FConnectionState: TclImap4ConnectionState;
    FUserName: string;
    FCramMD5Key: string;
    FNTLMAuth: TclNtAuthServerSspi;
    FCurrentMailBox: string;
    FReadOnlyAccess: Boolean;
    FAppendInfo: TclAppendMessageInfo;

    procedure AssignNtlm(Auth: TclNtAuthServerSspi);
    procedure InitParams;
  protected
    procedure DoDestroy; override;
  public
    constructor Create;

    property ConnectionState: TclImap4ConnectionState read FConnectionState;
    property UserName: string read FUserName;
    property CurrentMailBox: string read FCurrentMailBox;
    property ReadOnlyAccess: Boolean read FReadOnlyAccess;
  end;

  TclImap4CommandParams = class(TclTcpCommandParams)
  private
    FTag: string;
  public
    constructor Create(const ATag, ACommand, AParameters: string); overload;
    constructor Create; overload;

    procedure FromRawCommand(const ARawCommand: string); override;
    procedure FromRawLine(AContext: TclProcessLineContext); override;
    procedure FromRawMultiLine(AContext: TclProcessMultiLineContext); override;
    
    property Tag: string read FTag write FTag;
  end;

  TclImap4CommandHandler = procedure (AConnection: TclImap4CommandConnection;
    AParameters: TclImap4CommandParams) of object;
  
  TclImap4CommandInfo = class(TclTcpCommandInfo)
  private
    FHandler: TclImap4CommandHandler;
    FTag: string;
  protected
    procedure Execute(AConnection: TclCommandConnection; AParams: TclTcpCommandParams); override;
  public
    constructor Create(const AName: string; AHandler: TclImap4CommandHandler); overload;
    constructor Create(const ATag, AName: string; AHandler: TclImap4CommandHandler); overload;

    property Tag: string read FTag write FTag;
  end;

  TclImap4ConnectionEvent = procedure (Sender: TObject; AConnection: TclImap4CommandConnection) of object;
  TclImap4AuthenticateEvent = procedure (Sender: TObject; AConnection: TclImap4CommandConnection;
    var Account: TclMailUserAccountItem; const AUserName: string; var IsAuthorized, Handled: Boolean) of object;
  TclImap4GetMailBoxesEvent = procedure (Sender: TObject; AConnection: TclImap4CommandConnection;
    const ASelectedMailBox: string; AMailBoxes: TclImap4MailBoxList) of object;
  TclImap4UpdateMailBoxEvent = procedure (Sender: TObject; AConnection: TclImap4CommandConnection;
    AMailBox: TclImap4MailBoxItem; var Success: Boolean) of object;
  TclImap4MailBoxEvent = procedure (Sender: TObject; AConnection: TclImap4CommandConnection;
    const AMailBox: string; var Success: Boolean) of object;
  TclImap4RenameMailBoxEvent = procedure (Sender: TObject; AConnection: TclImap4CommandConnection;
    const ACurrentName, ANewName: string; var Success: Boolean) of object;
  TclImap4MessageEvent = procedure (Sender: TObject; AConnection: TclImap4CommandConnection;
    AMessage: TclImap4MessageItem; const AMailBox: string; var Success: Boolean) of object;
  TclImap4MessagesEvent = procedure (Sender: TObject; AConnection: TclImap4CommandConnection;
    AMessages: TclImap4MessageList; const AMailBox: string; var Success: Boolean) of object;
  TclImap4GetMessageSourceEvent = procedure (Sender: TObject; AConnection: TclImap4CommandConnection;
    AMessageSource: TStrings; const AMessageName, AMailBox: string; var Success: Boolean) of object;
  TclImap4SearchMessageEvent = procedure (Sender: TObject; AConnection: TclImap4CommandConnection;
    AMessage: TclImap4MessageItem; AMessageSource: TStrings; var Matches, Handled: Boolean) of object;
  TclImap4AppendMessageEvent = procedure (Sender: TObject; AConnection: TclImap4CommandConnection;
    AFlags: TclMailMessageFlags; ADate: TDateTime; AMessageSource: TStrings;
    const AMailBox: string; var Success: Boolean) of object;

  TclImap4Server = class(TclTcpCommandServer)
  private
    FUserAccounts: TclMailUserAccountList;
    FUseAuth: TclImap4AuthMode;
    FSaslFlags: TclServerSaslFlags;
    FMailBoxSeparator: Char;
    FCapabilities: TStrings;
    FHostName: string;

    FOnUpdateMessages: TclImap4MessagesEvent;
    FOnRenameMailBox: TclImap4RenameMailBoxEvent;
    FOnDeleteMessage: TclImap4MessageEvent;
    FOnAppendMessage: TclImap4AppendMessageEvent;
    FOnGetMessageSource: TclImap4GetMessageSourceEvent;
    FOnStateChanged: TclImap4ConnectionEvent;
    FOnDeleteMailBox: TclImap4MailBoxEvent;
    FOnUpdateMailBox: TclImap4UpdateMailBoxEvent;
    FOnGetMailBoxes: TclImap4GetMailBoxesEvent;
    FOnAuthenticate: TclImap4AuthenticateEvent;
    FOnCreateMailBox: TclImap4MailBoxEvent;
    FOnGetMessages: TclImap4MessagesEvent;
    FOnSearchMessage: TclImap4SearchMessageEvent;

    procedure SetCapabilities(const Value: TStrings);
    procedure SetUserAccounts(const Value: TclMailUserAccountList);
    function GetCaseInsensitive: Boolean;
    procedure SetCaseInsensitive(const Value: Boolean);

    procedure HandleNullCommand(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleLOGIN(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleAUTHENTICATE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleLOGOUT(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleCAPABILITY(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleLIST(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleLSUB(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleCREATE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleDELETE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleRENAME(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleSUBSCRIBE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleUNSUBSCRIBE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleSELECT(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleEXAMINE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleSTATUS(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleNOOP(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleCHECK(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleSTARTTLS(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleSEARCH(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleUIDSEARCH(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleCOPY(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleUIDCOPY(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleSTORE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleUIDSTORE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleAPPEND(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleCLOSE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleEXPUNGE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleFETCH(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleUIDFETCH(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);

    procedure HandleAppendDone(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleCramMD5(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure HandleNTLM(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);

    function GetTaggedResponse(AParameters: TclImap4CommandParams; const AResponse: string): string;
    function GetHostName: string;
    procedure FillDefaultCapabilities;
    procedure CheckTlsMode(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
    procedure CheckConnectionState(AConnection: TclImap4CommandConnection;
      AParameters: TclImap4CommandParams; ACheckStates: array of TclImap4ConnectionState);
    procedure CheckAuthorized(AConnection: TclImap4CommandConnection;
      AParameters: TclImap4CommandParams; IsAuthorized: Boolean);
    procedure ChangeState(AConnection: TclImap4CommandConnection; ANewState: TclImap4ConnectionState);
    function LoginAuthenticate(AConnection: TclImap4CommandConnection; Account: TclMailUserAccountItem;
      const AUserName, APassword: string): Boolean;
    function CramMD5Authenticate(AConnection: TclImap4CommandConnection; Account: TclMailUserAccountItem;
			const AUserName, AKey, AHash: string): Boolean;
    function NtlmAuthenticate(AConnection: TclImap4CommandConnection; Account: TclMailUserAccountItem;
      const AUserName: string): Boolean;
    procedure GetCapabilities(AConnection: TclImap4CommandConnection; AList: TStrings);
    function GetAuthData(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams): string;
    function GetActualMailBoxInfo(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams;
      AMailBox: TclImap4MailBoxItem; AMessages: TclImap4MessageList): TclImap4MailBoxInfo;
    function GetMailBoxResponse(AParameters: TclImap4CommandParams; Attrs: TclImap4MailBoxAttributes;
      const AMailBox: string): string;
    function GetMailBoxAttrsStr(Attrs: TclImap4MailBoxAttributes): string;
    procedure CollectMailBoxesResponse(AConnection: TclImap4CommandConnection;
      AParameters: TclImap4CommandParams; AMailBoxes: TclImap4MailBoxList;
      const AReferenceName, ACriteria: string; IncludeAll: Boolean; AList: TStrings);
    procedure AssignMailBoxInfo(AMailBox: TclImap4MailBoxItem; AInfo: TclImap4MailBoxInfo);
    procedure AssignMailBoxByInfo(AInfo: TclImap4MailBoxInfo; AMailBox: TclImap4MailBoxItem);
    procedure UpdateMessages(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams;
			const AMailBox: string; AMessages: TclImap4MessageList; AInfo: TclImap4MailBoxInfo);
    procedure CollectMailBoxInfoResponse(AInfo: TclImap4MailBoxInfo; AList: TStrings);
    function CollectStatusResponse(AMailBoxInfo: TclImap4MailBoxInfo; AStatusNames: TStrings): string;
    function CheckSearchCriteria(const ACriteria: string; AMessageSource: TStrings): Boolean;
    procedure FetchMessage(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams;
      AFetchList: TclImap4FetchList; AMessageItem: TclImap4MessageItem; AMessageSource: TStrings; AUseUID: Boolean);
    procedure WriteFetchResponse(AResponse: TStream; var AIsFirst: Boolean; const AData: string);

    procedure InternalHandleList(AConnection: TclImap4CommandConnection;
      AParameters: TclImap4CommandParams; IncludeAll: Boolean);
    procedure InternalSubscribe(AConnection: TclImap4CommandConnection;
      AParameters: TclImap4CommandParams; IsSubscribe: Boolean);
    procedure InternalSelectMailBox(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams; AReadOnly: Boolean);
    procedure InternalHandleSearch(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams; AUseUid: Boolean);
    procedure InternalHandleCopy(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams; AUseUID: Boolean);
    procedure InternalHandleStore(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams; AUseUID: Boolean);
    procedure InternalExpunge(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams; AIsClose: Boolean);
    procedure InternalHandleFetch(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams; AUseUID: Boolean);

    procedure RaiseImapError(AParameters: TclImap4CommandParams; const AMessage: string);
    procedure RaiseImapNoResponse(AParameters: TclImap4CommandParams; const AMessage: string);
    procedure RaiseBadStateError(AParameters: TclImap4CommandParams);
    procedure RaiseAuthAbort(AParameters: TclImap4CommandParams);
    procedure RaiseParseError(AParameters: TclImap4CommandParams);
  protected
    procedure DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean); override;
    procedure DoCreateCommandParams(AConnection: TclCommandConnection;
      var ACommandParams: TclTcpCommandParams); override;
    procedure ProcessUnhandledError(AConnection: TclCommandConnection;
      AParameters: TclTcpCommandParams; E: Exception); override;
    function CreateDefaultConnection: TclUserConnection; override;
    procedure GetCommands; override;
    function GetNullCommand(AParameters: TclTcpCommandParams): TclTcpCommandInfo; override;
    procedure DoDestroy; override;

    function GenCramMD5Key: string; virtual;

    procedure DoAuthenticate(AConnection: TclImap4CommandConnection;
      var Account: TclMailUserAccountItem; const AUserName: string;
      var IsAuthorized, Handled: Boolean); virtual;
    procedure DoStateChanged(AConnection: TclImap4CommandConnection); virtual;
    procedure DoGetMailBoxes(AConnection: TclImap4CommandConnection;
      const ASelectedMailBox: string; AMailBoxes: TclImap4MailBoxList); virtual;
    procedure DoUpdateMailBox(AConnection: TclImap4CommandConnection;
      AMailBox: TclImap4MailBoxItem; var Success: Boolean); virtual;
    procedure DoCreateMailBox(AConnection: TclImap4CommandConnection;
      const AMailBox: string; var Success: Boolean); virtual;
    procedure DoDeleteMailBox(AConnection: TclImap4CommandConnection;
      const AMailBox: string; var Success: Boolean); virtual;
    procedure DoRenameMailBox(AConnection: TclImap4CommandConnection;
      const ACurrentName, ANewName: string; var Success: Boolean); virtual;
    procedure DoGetMessages(AConnection: TclImap4CommandConnection;
      AMessages: TclImap4MessageList; const AMailBox: string; var Success: Boolean); virtual;
    procedure DoUpdateMessages(AConnection: TclImap4CommandConnection;
      AMessages: TclImap4MessageList; const AMailBox: string; var Success: Boolean); virtual;
    procedure DoDeleteMessage(AConnection: TclImap4CommandConnection;
      AMessage: TclImap4MessageItem; const AMailBox: string; var Success: Boolean); virtual;
    procedure DoGetMessageSource(AConnection: TclImap4CommandConnection;
      AMessageSource: TStrings; const AMessageName, AMailBox: string; var Success: Boolean); virtual;
    procedure DoSearchMessage(AConnection: TclImap4CommandConnection;
      AMessage: TclImap4MessageItem; AMessageSource: TStrings; var Matches, Handled: Boolean); virtual;
    procedure DoAppendMessage(AConnection: TclImap4CommandConnection;
      AFlags: TclMailMessageFlags; ADate: TDateTime; AMessageSource: TStrings;
      const AMailBox: string; var Success: Boolean); virtual;
  public
    constructor Create(AOwner: TComponent); override;

    procedure SendTaggedResponse(AConnection: TclCommandConnection;
      const ATag, ACommand, AResponse: string); overload;
    procedure SendTaggedResponse(AConnection: TclCommandConnection;
      AParameters: TclImap4CommandParams; const AResponse: string); overload;
    procedure SendTaggedResponse(AConnection: TclCommandConnection;
      AParameters: TclImap4CommandParams; const AResponse: string; const Args: array of const); overload;
    procedure SendTaggedResponseAndClose(AConnection: TclCommandConnection;
      AParameters: TclImap4CommandParams; const AResponse: string);
  published
    property Port default DefaultImapPort;
    property UseAuth: TclImap4AuthMode read FUseAuth write FUseAuth default imUseBoth;
    property SaslFlags: TclServerSaslFlags read FSaslFlags write FSaslFlags default [ssUseCramMD5, ssUseNTLM];
    property UserAccounts: TclMailUserAccountList read FUserAccounts write SetUserAccounts;
    property CaseInsensitive: Boolean read GetCaseInsensitive write SetCaseInsensitive default True;
    property Capabilities: TStrings read FCapabilities write SetCapabilities;
    property MailBoxSeparator: Char read FMailBoxSeparator write FMailBoxSeparator default '/';
    property HostName: string read FHostName write FHostName;

    property OnAuthenticate: TclImap4AuthenticateEvent read FOnAuthenticate write FOnAuthenticate;
    property OnStateChanged: TclImap4ConnectionEvent read FOnStateChanged write FOnStateChanged;
    property OnGetMailBoxes: TclImap4GetMailBoxesEvent read FOnGetMailBoxes write FOnGetMailBoxes;
    property OnUpdateMailBox: TclImap4UpdateMailBoxEvent read FOnUpdateMailBox write FOnUpdateMailBox;
    property OnCreateMailBox: TclImap4MailBoxEvent read FOnCreateMailBox write FOnCreateMailBox;
    property OnDeleteMailBox: TclImap4MailBoxEvent read FOnDeleteMailBox write FOnDeleteMailBox;
    property OnRenameMailBox: TclImap4RenameMailBoxEvent read FOnRenameMailBox write FOnRenameMailBox;
    property OnGetMessages: TclImap4MessagesEvent read FOnGetMessages write FOnGetMessages;
    property OnUpdateMessages: TclImap4MessagesEvent read FOnUpdateMessages write FOnUpdateMessages;
    property OnDeleteMessage: TclImap4MessageEvent read FOnDeleteMessage write FOnDeleteMessage;
    property OnGetMessageSource: TclImap4GetMessageSourceEvent read FOnGetMessageSource write FOnGetMessageSource;
    property OnSearchMessage: TclImap4SearchMessageEvent read FOnSearchMessage write FOnSearchMessage;
    property OnAppendMessage: TclImap4AppendMessageEvent read FOnAppendMessage write FOnAppendMessage;
  end;

implementation

uses
  clTlsSocket, clUtils, clCryptMac, clEncoder, clRegex, clMailHeader, clTranslator;

const
  OkResponse = 'OK';
  NoResponse = 'NO';
  BadResponse = 'BAD';

{ TclImap4Server }

constructor TclImap4Server.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FUserAccounts := TclMailUserAccountList.Create(Self, TclMailUserAccountItem);
  CaseInsensitive := True;

  Port := DefaultImapPort;
  ServerName := 'Clever Internet Suite IMAP4 service';
  FUseAuth := imUseBoth;
  FSaslFlags := [ssUseCramMD5, ssUseNTLM];
  FMailBoxSeparator := '/';
  FHostName := '';

  FCapabilities := TStringList.Create();
  FillDefaultCapabilities();
end;

procedure TclImap4Server.FillDefaultCapabilities;
begin
  Capabilities.Clear();
end;

function TclImap4Server.CreateDefaultConnection: TclUserConnection;
begin
  Result := TclImap4CommandConnection.Create();
end;

procedure TclImap4Server.DoAcceptConnection(AConnection: TclUserConnection; var Handled: Boolean);
var
  banner: string;
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

  inherited DoAcceptConnection(AConnection, Handled);
  if Handled then Exit;

  banner := OkResponse + ' IMAP4rev1 ' + ServerName + ' Ready';
  SendTaggedResponse(AConnection as TclCommandConnection, '*', '', banner);
end;

procedure TclImap4Server.GetCommands;
begin
  Commands.Add(TclImap4CommandInfo.Create('LOGIN', HandleLOGIN));
  Commands.Add(TclImap4CommandInfo.Create('AUTHENTICATE', HandleAUTHENTICATE));
  Commands.Add(TclImap4CommandInfo.Create('LOGOUT', HandleLOGOUT));
  Commands.Add(TclImap4CommandInfo.Create('CAPABILITY', HandleCAPABILITY));

  Commands.Add(TclImap4CommandInfo.Create('LIST', HandleLIST));
  Commands.Add(TclImap4CommandInfo.Create('CREATE', HandleCREATE));
  Commands.Add(TclImap4CommandInfo.Create('DELETE', HandleDELETE));
  Commands.Add(TclImap4CommandInfo.Create('RENAME', HandleRENAME));
  Commands.Add(TclImap4CommandInfo.Create('LSUB', HandleLSUB));
  Commands.Add(TclImap4CommandInfo.Create('SUBSCRIBE', HandleSUBSCRIBE));
  Commands.Add(TclImap4CommandInfo.Create('UNSUBSCRIBE', HandleUNSUBSCRIBE));
  Commands.Add(TclImap4CommandInfo.Create('SELECT', HandleSELECT));
  Commands.Add(TclImap4CommandInfo.Create('EXAMINE', HandleEXAMINE));
  Commands.Add(TclImap4CommandInfo.Create('STATUS', HandleSTATUS));
  Commands.Add(TclImap4CommandInfo.Create('NOOP', HandleNOOP));
  Commands.Add(TclImap4CommandInfo.Create('CHECK', HandleCHECK));
  Commands.Add(TclImap4CommandInfo.Create('STARTTLS', HandleSTARTTLS));

  Commands.Add(TclImap4CommandInfo.Create('SEARCH', HandleSEARCH));
  Commands.Add(TclImap4CommandInfo.Create('COPY', HandleCOPY));
  Commands.Add(TclImap4CommandInfo.Create('STORE', HandleSTORE));
  Commands.Add(TclImap4CommandInfo.Create('APPEND', HandleAPPEND));
  Commands.Add(TclImap4CommandInfo.Create('CLOSE', HandleCLOSE));
  Commands.Add(TclImap4CommandInfo.Create('EXPUNGE', HandleEXPUNGE));
  Commands.Add(TclImap4CommandInfo.Create('FETCH', HandleFETCH));

  Commands.Add(TclImap4CommandInfo.Create('UID SEARCH', HandleUIDSEARCH));
  Commands.Add(TclImap4CommandInfo.Create('UID COPY', HandleUIDCOPY));
  Commands.Add(TclImap4CommandInfo.Create('UID STORE', HandleUIDSTORE));
  Commands.Add(TclImap4CommandInfo.Create('UID FETCH', HandleUIDFETCH));
end;

function TclImap4Server.GetHostName: string;
begin
  Result := HostName;
  if (Result = '') then
  begin
    Result := TclHostResolver.GetLocalHost();
  end;
end;

procedure TclImap4Server.SetUserAccounts(const Value: TclMailUserAccountList);
begin
  FUserAccounts.Assign(Value);
end;

procedure TclImap4Server.UpdateMessages(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams;
  const AMailBox: string; AMessages: TclImap4MessageList; AInfo: TclImap4MailBoxInfo);
var
  cnt: Integer;
  msg: TclImap4MessageItem;
  success: Boolean;
begin
  AInfo.ExistsMessages := AMessages.Count;
  AInfo.RecentMessages := 0;
  AInfo.UnseenMessages := 0;
  AInfo.FirstUnseen := 0;

  for cnt := 0 to AMessages.Count - 1 do
  begin
    msg := AMessages[cnt];
    if (msg.UID < 0) then
    begin
      msg.UID := AInfo.UIDNext;
      AInfo.UIDNext := AInfo.UIDNext + 1;
      msg.Flags := msg.Flags + [mfRecent];
    end else
    begin
      msg.Flags := msg.Flags - [mfRecent];
    end;

    if not (mfSeen in msg.Flags) then
    begin
      AInfo.UnseenMessages := AInfo.UnseenMessages + 1;
      if (AInfo.FirstUnseen = 0) then
      begin
        AInfo.FirstUnseen := cnt + 1;
      end;
    end;

    if (mfRecent in msg.Flags) then
    begin
      AInfo.RecentMessages := AInfo.RecentMessages + 1;
    end;
  end;

  success := True;
  DoUpdateMessages(AConnection, AMessages, AMailBox, success);
end;

function TclImap4Server.GetActualMailBoxInfo(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams; AMailBox: TclImap4MailBoxItem; AMessages: TclImap4MessageList): TclImap4MailBoxInfo;
var
  success: Boolean;
begin
  Result := TclImap4MailBoxInfo.Create();
  try
    AssignMailBoxInfo(AMailBox, Result);
    UpdateMessages(AConnection, AParameters, AMailBox.Name, AMessages, Result);
    AssignMailBoxByInfo(Result, AMailBox);

    success := True;
    DoUpdateMailBox(AConnection, AMailBox, success);

    if (not success) then
    begin
      RaiseImapNoResponse(AParameters, 'Access denied');
    end;
  except
    Result.Free();
    raise;
  end;
end;

function TclImap4Server.GetAuthData(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams): string;
begin
  if (Trim(AParameters.Parameters) = '*') then
  begin
    RaiseAuthAbort(AParameters);
  end;

  try
    Result := TclEncoder.Decode(AParameters.Parameters, cmBase64);
  except
    on EclEncoderError do
    begin
		  RaiseAuthAbort(AParameters);
    end;
  end;
end;

procedure TclImap4Server.GetCapabilities(AConnection: TclImap4CommandConnection; AList: TStrings);
begin
  AList.Add('IMAP4REV1');

  if ((UseAuth = imUseSASL) or (UseAuth = imUseBoth)) then
  begin
    if (ssUseCramMD5 in SaslFlags) then
    begin
      AList.Add('AUTH=CRAM-MD5');
    end;
    if (ssUseNTLM in SaslFlags) then
    begin
      AList.Add('AUTH=NTLM');
    end;
  end;

  if ((UseTls <> stNone) and not AConnection.IsTls) then
  begin
    AList.Add('STARTTLS');
  end;

  AList.AddStrings(Capabilities);
end;

function TclImap4Server.GetCaseInsensitive: Boolean;
begin
  Result := FUserAccounts.CaseInsensitive;
end;

procedure TclImap4Server.SetCaseInsensitive(const Value: Boolean);
begin
  FUserAccounts.CaseInsensitive := Value;
end;

procedure TclImap4Server.DoDestroy;
begin
  FCapabilities.Free();
  FUserAccounts.Free();
  inherited DoDestroy();
end;

procedure TclImap4Server.SendTaggedResponse(AConnection: TclCommandConnection;
  const ATag, ACommand, AResponse: string);
begin
  SendResponse(AConnection, ACommand, ATag + ' ' + AResponse);
end;

procedure TclImap4Server.HandleLOGIN(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
var
  loginParams: TStrings;
  isAuthorized: Boolean;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csNonAuthenticated]);

  if not (UseAuth in [imUseIMAPLogin, imUseBoth]) then
  begin
    RaiseImapError(AParameters, 'Unrecognized authentication type');
  end;

  loginParams := TStringList.Create();
  try
    ExtractQuotedWords(AParameters.Parameters, loginParams);

    if (loginParams.Count <> 2) then
    begin
      RaiseParseError(AParameters);
    end;

    AConnection.FUserName := loginParams[0];

    isAuthorized := LoginAuthenticate(AConnection,
      UserAccounts.AccountByUserName(AConnection.userName), AConnection.UserName, loginParams[1]);
    CheckAuthorized(AConnection, AParameters, isAuthorized);

    ChangeState(AConnection, csAuthenticated);
    SendTaggedResponse(AConnection, AParameters, OkResponse + ' LOGIN completed');
  finally
    loginParams.Free();
  end;
end;

function TclImap4Server.LoginAuthenticate(AConnection: TclImap4CommandConnection;
  Account: TclMailUserAccountItem; const AUserName, APassword: string): Boolean;
var
  handled: Boolean;
begin
  handled := False;
  Result := False;
  DoAuthenticate(AConnection, Account, AUserName, Result, handled);
  if (not handled) and (Account <> nil) then
  begin
    Result := Account.Authenticate(APassword);
  end;
end;

function TclImap4Server.NtlmAuthenticate(AConnection: TclImap4CommandConnection;
  Account: TclMailUserAccountItem; const AUserName: string): Boolean;
var
  handled: Boolean;
begin
  handled := False;
  Result := True;
  DoAuthenticate(AConnection, Account, AUserName, Result, handled);
end;

function TclImap4Server.CramMD5Authenticate(
  AConnection: TclImap4CommandConnection; Account: TclMailUserAccountItem;
  const AUserName, AKey, AHash: string): Boolean;
var
  handled: Boolean;
  calculated: string;
begin
  handled := False;
  Result := False;
  DoAuthenticate(AConnection, Account, AUserName, Result, handled);
  if (not handled) and (Account <> nil) then
  begin
    calculated := HMAC_MD5(AKey, Account.Password);
    Result := (calculated = AHash);
  end;
end;

procedure TclImap4Server.HandleAUTHENTICATE(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
var
  s, method: string;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csNonAuthenticated]);

  if not (UseAuth in [imUseSASL, imUseBoth]) then
  begin
    RaiseImapError(AParameters, 'Unrecognized authentication type');
  end;

  method := UpperCase(Trim(AParameters.Parameters));

  if ((method = 'CRAM-MD5') and (ssUseCramMD5 in SaslFlags)) then
  begin
    AConnection.FCramMD5Key := GenCramMD5Key();
    s := TclEncoder.EncodeToString(AConnection.FCramMD5Key, cmBase64);

    AcceptLines(AConnection, TclImap4CommandInfo.Create(AParameters.Tag, AParameters.Command, HandleCramMD5));
    SendResponse(AConnection, AParameters.Command, '+ ' + s);
  end else
  if ((method = 'NTLM') and (ssUseNTLM in SaslFlags)) then
  begin
    AConnection.AssignNtlm(TclNtAuthServerSspi.Create());

    AcceptLines(AConnection, TclImap4CommandInfo.Create(AParameters.Tag, AParameters.Command, HandleNtlm));
    SendResponse(AConnection, AParameters.Command, '+');
  end else
  begin
    RaiseImapError(AParameters, 'Unrecognized authentication type');
  end;
end;

procedure TclImap4Server.HandleLOGOUT(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
begin
  try
    SendTaggedResponse(AConnection, '*', AParameters.Command, 'BYE IMAP engine signing off');
    SendTaggedResponseAndClose(AConnection, AParameters, OkResponse + ' LOGOUT completed');
  except
    on EclSocketError do ;
  end;
end;

procedure TclImap4Server.RaiseAuthAbort(AParameters: TclImap4CommandParams);
begin
  RaiseImapError(AParameters, 'Authentication aborted');
end;

procedure TclImap4Server.RaiseBadStateError(AParameters: TclImap4CommandParams);
begin
  RaiseImapError(AParameters, 'Bad state for ' + AParameters.Command);
end;

procedure TclImap4Server.RaiseImapError(AParameters: TclImap4CommandParams; const AMessage: string);
begin
  raise EclImap4ServerError.Create(AParameters.Tag, AParameters.Command,
    AParameters.Tag + ' ' + BadResponse + ' ' + AMessage, -1);
end;

procedure TclImap4Server.RaiseImapNoResponse(AParameters: TclImap4CommandParams; const AMessage: string);
begin
  raise EclImap4ServerError.Create(AParameters.Tag, AParameters.Command,
    AParameters.Tag + ' ' + NoResponse + ' ' + AMessage, -1);
end;

procedure TclImap4Server.RaiseParseError(AParameters: TclImap4CommandParams);
begin
  RaiseImapError(AParameters, AParameters.Command + ' parse error');
end;

procedure TclImap4Server.DoAuthenticate(AConnection: TclImap4CommandConnection;
  var Account: TclMailUserAccountItem; const AUserName: string;
  var IsAuthorized, Handled: Boolean);
begin
  if Assigned(OnAuthenticate) then
  begin
    OnAuthenticate(Self, AConnection, Account, AUserName, IsAuthorized, Handled);
  end;
end;

procedure TclImap4Server.DoSearchMessage(AConnection: TclImap4CommandConnection;
  AMessage: TclImap4MessageItem; AMessageSource: TStrings; var Matches, Handled: Boolean);
begin
  if Assigned(OnSearchMessage) then
  begin
    OnSearchMessage(Self, AConnection, AMessage, AMessageSource, Matches, Handled);
  end;
end;

procedure TclImap4Server.DoAppendMessage(AConnection: TclImap4CommandConnection;
  AFlags: TclMailMessageFlags; ADate: TDateTime; AMessageSource: TStrings;
  const AMailBox: string; var Success: Boolean);
begin
  if Assigned(OnAppendMessage) then
  begin
    OnAppendMessage(Self, AConnection, AFlags, ADate, AMessageSource, AMailBox, Success);
  end;
end;

procedure TclImap4Server.DoStateChanged(AConnection: TclImap4CommandConnection);
begin
  if Assigned(OnStateChanged) then
  begin
    OnStateChanged(Self, AConnection);
  end;
end;

procedure TclImap4Server.DoGetMailBoxes(AConnection: TclImap4CommandConnection;
  const ASelectedMailBox: string; AMailBoxes: TclImap4MailBoxList);
begin
  if Assigned(OnGetMailBoxes) then
  begin
    OnGetMailBoxes(Self, AConnection, ASelectedMailBox, AMailBoxes);
  end;
end;

procedure TclImap4Server.DoGetMessages(AConnection: TclImap4CommandConnection;
  AMessages: TclImap4MessageList; const AMailBox: string; var Success: Boolean);
begin
  if Assigned(OnGetMessages) then
  begin
    OnGetMessages(Self, AConnection, AMessages, AMailBox, Success);
  end;
end;

procedure TclImap4Server.DoGetMessageSource(
  AConnection: TclImap4CommandConnection; AMessageSource: TStrings;
  const AMessageName, AMailBox: string; var Success: Boolean);
begin
  if Assigned(OnGetMessageSource) then
  begin
    OnGetMessageSource(Self, AConnection, AMessageSource, AMessageName, AMailBox, Success);
  end;
end;

procedure TclImap4Server.DoRenameMailBox(AConnection: TclImap4CommandConnection;
  const ACurrentName, ANewName: string; var Success: Boolean);
begin
  if Assigned(OnRenameMailBox) then
  begin
    OnRenameMailBox(Self, AConnection, ACurrentName, ANewName, Success);
  end;
end;

procedure TclImap4Server.DoUpdateMailBox(AConnection: TclImap4CommandConnection;
  AMailBox: TclImap4MailBoxItem; var Success: Boolean);
begin
  if Assigned(OnUpdateMailBox) then
  begin
    OnUpdateMailBox(Self, AConnection, AMailBox, Success);
  end;
end;

procedure TclImap4Server.DoUpdateMessages(
  AConnection: TclImap4CommandConnection; AMessages: TclImap4MessageList;
  const AMailBox: string; var Success: Boolean);
begin
  if Assigned(OnUpdateMessages) then
  begin
    OnUpdateMessages(Self, AConnection, AMessages, AMailBox, Success);
  end;
end;

procedure TclImap4Server.DoCreateCommandParams(
  AConnection: TclCommandConnection; var ACommandParams: TclTcpCommandParams);
begin
  inherited DoCreateCommandParams(AConnection, ACommandParams);

  if (ACommandParams = nil) then
  begin
    ACommandParams := TclImap4CommandParams.Create();
  end;
end;

procedure TclImap4Server.DoCreateMailBox(AConnection: TclImap4CommandConnection;
  const AMailBox: string; var Success: Boolean);
begin
  if Assigned(OnCreateMailBox) then
  begin
    OnCreateMailBox(Self, AConnection, AMailBox, Success);
  end;
end;

procedure TclImap4Server.DoDeleteMailBox(AConnection: TclImap4CommandConnection;
  const AMailBox: string; var Success: Boolean);
begin
  if Assigned(OnDeleteMailBox) then
  begin
    OnDeleteMailBox(Self, AConnection, AMailBox, Success);
  end;
end;

procedure TclImap4Server.DoDeleteMessage(AConnection: TclImap4CommandConnection;
  AMessage: TclImap4MessageItem; const AMailBox: string; var Success: Boolean);
begin
  if Assigned(OnDeleteMessage) then
  begin
    OnDeleteMessage(Self, AConnection, AMessage, AMailBox, Success);
  end;
end;

function TclImap4Server.GenCramMD5Key: string;
begin
  Result := GenerateCramMD5Key(GetHostName());
end;

procedure TclImap4Server.CheckAuthorized(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams; IsAuthorized: Boolean);
begin
  if (Guard <> nil) then
  begin
    IsAuthorized := Guard.Login(AConnection.UserName, IsAuthorized, AConnection.PeerIP, Port);
  end;

  if not IsAuthorized then
  begin
    AConnection.InitParams();
    RaiseImapError(AParameters, AParameters.Command + ' failed');
  end;
end;

procedure TclImap4Server.AssignMailBoxByInfo(AInfo: TclImap4MailBoxInfo; AMailBox: TclImap4MailBoxItem);
begin
  AMailBox.Name := AInfo.Name;
  AMailBox.Flags := AInfo.Flags;
  AMailBox.ChangeableFlags := AInfo.ChangeableFlags;
  AMailBox.UIDNext := AInfo.UIDNext;
  AMailBox.UIDValidity := AInfo.UIDValidity;
end;

procedure TclImap4Server.AssignMailBoxInfo(AMailBox: TclImap4MailBoxItem; AInfo: TclImap4MailBoxInfo);
begin
  AInfo.Name := AMailBox.Name;
  AInfo.Flags := AMailBox.Flags;
  AInfo.ChangeableFlags := AMailBox.ChangeableFlags;
  AInfo.UIDNext := AMailBox.UIDNext;
  AInfo.UIDValidity := AMailBox.UIDValidity;
end;

procedure TclImap4Server.ChangeState(AConnection: TclImap4CommandConnection;
  ANewState: TclImap4ConnectionState);
begin
  if (AConnection.ConnectionState <> ANewState) then
  begin
    AConnection.FConnectionState := ANewState;
    AConnection.FCurrentMailBox := '';
    DoStateChanged(AConnection);
  end;
end;

procedure TclImap4Server.HandleLIST(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
begin
  InternalHandleList(AConnection, AParameters, True);
end;

function TclImap4Server.GetMailBoxResponse(AParameters: TclImap4CommandParams;
  Attrs: TclImap4MailBoxAttributes; const AMailBox: string): string;
begin
  Result := '* ' + AParameters.Command + ' (' + GetMailBoxAttrsStr(Attrs)
    + ') "' + MailBoxSeparator + '" "' + AMailBox + '"';
end;

procedure TclImap4Server.CollectMailBoxesResponse(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams; AMailBoxes: TclImap4MailBoxList;
  const AReferenceName, ACriteria: string; IncludeAll: Boolean; AList: TStrings);
var
  i: Integer;
  crit, pattern: string;
  c: Char;
  mailBox: TclImap4MailBoxItem;
begin
  AList.Clear();
  crit := AReferenceName + ACriteria;

  pattern := '^';
  for i := 1 to Length(crit) do
  begin
    c := crit[i];
    case c of
      '*': pattern := pattern + '.*';
      '%': pattern := pattern + '[^' + MailBoxSeparator + ']*';
      '+', '-', '.', '$', '(', ')': pattern := pattern + '\' + c
      else pattern := pattern + c;
    end;
  end;
  pattern := pattern + '$';

  for i := 0 to AMailBoxes.Count - 1 do
  begin
    mailBox := AMailBoxes[i];
    if (IncludeAll or mailBox.IsSubscribed) then
    begin
      if TclRegEx.IsMatch(mailBox.Name, pattern, [rxoIgnoreCase]) then
      begin
        AList.Add(GetMailBoxResponse(AParameters, mailBox.Attributes, mailBox.Name));
      end;
    end;
  end;
end;

procedure TclImap4Server.CollectMailBoxInfoResponse(AInfo: TclImap4MailBoxInfo; AList: TStrings);
begin
  AList.Add(Format('* %d EXISTS', [AInfo.ExistsMessages]));
  AList.Add(Format('* %d RECENT', [AInfo.RecentMessages]));
  if (AInfo.FirstUnseen > 0) then
  begin
    AList.Add(Format('* OK [UNSEEN %d] first unseen', [AInfo.FirstUnseen]));
  end;
  AList.Add(Format('* OK [UIDVALIDITY %s] UIDs valid', [AInfo.UIDValidity]));
  AList.Add(Format('* FLAGS (%s)', [GetStrByImapMessageFlags(AInfo.Flags)]));
  AList.Add(Format('* OK [PERMANENTFLAGS (%s)] .', [GetStrByImapMessageFlags(AInfo.ChangeableFlags)]));
end;

function TclImap4Server.CollectStatusResponse(AMailBoxInfo: TclImap4MailBoxInfo; AStatusNames: TStrings): string;
var
  i: Integer;
  name: string;
begin
  Result := '';
  for i := 0 to AStatusNames.Count - 1 do
  begin
    name := UpperCase(AStatusNames[i]);
    if ('MESSAGES' = name) then
    begin
      Result := Result + Format('MESSAGES %d ', [AMailBoxInfo.ExistsMessages]);
    end else
    if ('RECENT' = name) then
    begin
      Result := Result + Format('RECENT %d ', [AMailBoxInfo.RecentMessages]);
    end else
    if ('UIDNEXT' = name) then
    begin
      Result := Result + Format('UIDNEXT %d ', [AMailBoxInfo.UIDNext]);
    end else
    if ('UIDVALIDITY' = name) then
    begin
      Result := Result + Format('UIDVALIDITY %s ', [AMailBoxInfo.UIDValidity]);
    end else
    if ('UNSEEN' = name) then
    begin
      Result := Result + Format('UNSEEN %d ', [AMailBoxInfo.UnseenMessages]);
    end;
  end;

  Result := Trim(Result);
  Result := Format('STATUS "%s" (%s)', [AMailBoxInfo.Name, Result]);
end;

function TclImap4Server.GetMailBoxAttrsStr(Attrs: TclImap4MailBoxAttributes): string;
const
  attrLexems: array[TclImap4MailBoxAttribute] of string =
    ('\Noinferiors', '\Noselect', '\Marked', '\Unmarked');
var
  attr: TclImap4MailBoxAttribute;
begin
  Result := '';
  for attr := Low(TclImap4MailBoxAttribute) to High(TclImap4MailBoxAttribute) do
  begin
    if (attr in Attrs) then
    begin
      Result := Result + ' ' + attrLexems[attr];
    end;
  end;
  Result := Trim(Result);
end;

procedure TclImap4Server.HandleCREATE(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
var
  mailbox: TStrings;
  mailBoxes: TclImap4MailBoxList;
  success: Boolean;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csAuthenticated, csSelected]);

  mailbox := nil;
  mailBoxes := nil;
  try
    mailbox := TStringList.Create();

    ExtractQuotedWords(AParameters.Parameters, mailbox);
    if ((mailbox.Count <> 1) or (mailbox[0] = '')) then
    begin
      RaiseParseError(AParameters);
    end;

    mailBoxes := TclImap4MailBoxList.Create(TclImap4MailBoxItem);
    DoGetMailBoxes(AConnection, mailbox[0], mailBoxes);

    if (mailBoxes.Count <> 0) then
    begin
      RaiseImapNoResponse(AParameters, 'Mailbox already exists');
    end;

    success := True;
    DoCreateMailBox(AConnection, mailbox[0], success);

    if (not success) then
    begin
      RaiseImapNoResponse(AParameters, 'Access denied');
    end;

    SendTaggedResponse(AConnection, AParameters, OkResponse + ' CREATE completed');
  finally
    mailBoxes.Free();
    mailbox.Free();
  end;
end;

procedure TclImap4Server.HandleDELETE(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
var
  mailbox: TStrings;
  mailBoxes: TclImap4MailBoxList;
  success: Boolean;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csAuthenticated, csSelected]);

  mailbox := nil;
  mailBoxes := nil;
  try
    mailbox := TStringList.Create();

    ExtractQuotedWords(AParameters.Parameters, mailbox);
    if ((mailbox.Count <> 1) or (mailbox[0] = '')) then
    begin
      RaiseParseError(AParameters);
    end;

    mailBoxes := TclImap4MailBoxList.Create(TclImap4MailBoxItem);
    DoGetMailBoxes(AConnection, mailbox[0], mailBoxes);

    if (mailBoxes.Count <> 1) then
    begin
      RaiseImapNoResponse(AParameters, 'Access denied');
    end;

    success := True;
    DoDeleteMailBox(AConnection, mailbox[0], success);

    if (not success) then
    begin
      RaiseImapNoResponse(AParameters, 'Access denied');
    end;

    SendTaggedResponse(AConnection, AParameters, OkResponse + ' DELETE completed');
  finally
    mailBoxes.Free();
    mailbox.Free();
  end;
end;

procedure TclImap4Server.HandleRENAME(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
var
  mailbox: TStrings;
  mailBoxes: TclImap4MailBoxList;
  success: Boolean;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csAuthenticated, csSelected]);

  mailbox := nil;
  mailBoxes := nil;
  try
    mailbox := TStringList.Create();

    ExtractQuotedWords(AParameters.Parameters, mailbox);
    if ((mailbox.Count <> 2) or (mailbox[0] = '') or (mailbox[1] = '') or (mailbox[0] = mailbox[1])) then
    begin
      RaiseParseError(AParameters);
    end;

    mailBoxes := TclImap4MailBoxList.Create(TclImap4MailBoxItem);
    DoGetMailBoxes(AConnection, mailbox[0], mailBoxes);

    if (mailBoxes.Count <> 1) then
    begin
      RaiseImapNoResponse(AParameters, 'Mailbox does not exist');
    end;

    mailBoxes.Clear();
    DoGetMailBoxes(AConnection, mailbox[1], mailBoxes);
    
    if (mailBoxes.Count <> 0) then
    begin
      RaiseImapNoResponse(AParameters, 'Mailbox already exists');
    end;

    success := True;
    DoRenameMailBox(AConnection, mailbox[0], mailbox[1], success);

    if (not success) then
    begin
      RaiseImapNoResponse(AParameters, 'Access denied');
    end;

    SendTaggedResponse(AConnection, AParameters, OkResponse + ' RENAME completed');
  finally
    mailBoxes.Free();
    mailbox.Free();
  end;
end;

procedure TclImap4Server.HandleLSUB(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
begin
  InternalHandleList(AConnection, AParameters, False);
end;

procedure TclImap4Server.HandleSUBSCRIBE(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
begin
  InternalSubscribe(AConnection, AParameters, True);
end;

procedure TclImap4Server.HandleUNSUBSCRIBE(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
begin
  InternalSubscribe(AConnection, AParameters, False);
end;

procedure TclImap4Server.HandleSELECT(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  InternalSelectMailBox(AConnection, AParameters, False);
end;

procedure TclImap4Server.HandleEXAMINE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  InternalSelectMailBox(AConnection, AParameters, True);
end;

procedure TclImap4Server.InternalSelectMailBox(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams; AReadOnly: Boolean);
const
  cPermissions: array[Boolean] of string = ('READ-WRITE', 'READ-ONLY');
var
  mailBoxName: TStrings;
  mailBoxes: TclImap4MailBoxList;
  messages: TclImap4MessageList;
  success: Boolean;
  info: TclImap4MailBoxInfo;
  list: TStrings;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csAuthenticated, csSelected]);

  mailBoxName := nil;
  mailBoxes := nil;
  messages := nil;
  info := nil;
  try
    mailBoxName := TStringList.Create();

    ExtractQuotedWords(AParameters.Parameters, mailBoxName);
    if ((mailBoxName.Count <> 1) or (mailBoxName[0] = '')) then
    begin
      RaiseParseError(AParameters);
    end;

    mailBoxes := TclImap4MailBoxList.Create(TclImap4MailBoxItem);
    DoGetMailBoxes(AConnection, mailBoxName[0], mailBoxes);

    if (mailBoxes.Count <> 1) then
    begin
      RaiseImapNoResponse(AParameters, 'Mailbox does not exist');
    end;

    messages := TclImap4MessageList.Create(True);
    success := True;
    DoGetMessages(AConnection, messages, mailBoxName[0], success);

    if (not success) then
    begin
      RaiseImapNoResponse(AParameters, 'Access denied');
    end;

    info := GetActualMailBoxInfo(AConnection, AParameters, mailBoxes[0], messages);

    list := TStringList.Create();
    try
      CollectMailBoxInfoResponse(info, list);

      ChangeState(AConnection, csSelected);
      AConnection.FReadOnlyAccess := AReadOnly;
      AConnection.FCurrentMailBox := mailBoxName[0];

      SendMultipleLines(AConnection, list, Format('%s %s [%s] %s completed', [AParameters.Tag, OkResponse,
        cPermissions[AReadOnly], AParameters.Command]));
    except
      list.Free();
      raise;
    end;
  finally
    info.Free();
    messages.Free();
    mailBoxes.Free();
    mailBoxName.Free();
  end;
end;

procedure TclImap4Server.HandleSTATUS(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
var
  mailBox: string;
  statusParams: TStrings;
  mailBoxes: TclImap4MailBoxList;
  success: Boolean;
  messages: TclImap4MessageList;
  info: TclImap4MailBoxInfo;
  statusResponse: string;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csAuthenticated, csSelected]);

  statusParams := nil;
  mailBoxes := nil;
  messages := nil;
  info := nil;
  try
    statusParams := TStringList.Create();

    ExtractQuotedWords(AParameters.Parameters, statusParams, ' ', ['"', '('], ['"', ')'], False);
    if ((statusParams.Count <> 2) or (statusParams[0] = '')) then
    begin
      RaiseParseError(AParameters);
    end;

    mailBox := statusParams[0];
    ExtractQuotedWords(statusParams[1], statusParams, ' ');

    mailBoxes := TclImap4MailBoxList.Create(TclImap4MailBoxItem);

    DoGetMailBoxes(AConnection, mailBox, mailBoxes);

    if (mailBoxes.Count <> 1) then
    begin
      RaiseImapNoResponse(AParameters, 'Mailbox does not exist');
    end;

    messages := TclImap4MessageList.Create(True);

    success := True;
    DoGetMessages(AConnection, messages, mailBox, success);

    if (not success) then
    begin
      RaiseImapNoResponse(AParameters, 'Access denied');
    end;

    info := GetActualMailBoxInfo(AConnection, AParameters, mailBoxes[0], messages);

    statusResponse := CollectStatusResponse(info, statusParams);

    SendTaggedResponse(AConnection, '*', AParameters.Command, statusResponse);
    SendTaggedResponse(AConnection, AParameters, OkResponse + ' STATUS completed');
  finally
    info.Free();
    messages.Free();
    mailBoxes.Free();
    statusParams.Free();
  end;
end;

procedure TclImap4Server.SendTaggedResponse(AConnection: TclCommandConnection;
  AParameters: TclImap4CommandParams; const AResponse: string);
begin
  SendResponse(AConnection, AParameters.Command, GetTaggedResponse(AParameters, AResponse));
end;

procedure TclImap4Server.SendTaggedResponse(AConnection: TclCommandConnection;
  AParameters: TclImap4CommandParams; const AResponse: string;
  const Args: array of const);
begin
  SendResponse(AConnection, AParameters.Command, GetTaggedResponse(AParameters, AResponse), Args);
end;

procedure TclImap4Server.HandleNOOP(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  SendTaggedResponse(AConnection, AParameters, OkResponse + ' NOOP completed');
end;

procedure TclImap4Server.HandleNTLM(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
var
  buf: TStream;
  challenge: string;
  isAuthorized: Boolean;
begin
  if (Trim(AParameters.Parameters) = '*') then
  begin
    RaiseAuthAbort(AParameters);
  end;

  try
    try
      buf := TMemoryStream.Create();
      try
        TclEncoder.Decode(AParameters.Parameters, buf, cmBase64);

        buf.Position := 0;
        if AConnection.FNTLMAuth.GenChallenge('NTLM', buf, nil) then
        begin
          AConnection.FNTLMAuth.ImpersonateUser();
          try
            AConnection.FUserName := GetCurrentThreadUser();

            isAuthorized := NtlmAuthenticate(AConnection,
              UserAccounts.AccountByUserName(AConnection.UserName), AConnection.UserName);
            CheckAuthorized(AConnection, AParameters, isAuthorized);
          finally
            AConnection.FNTLMAuth.RevertUser();
          end;

          ChangeState(AConnection, csAuthenticated);
          AcceptCommands(AConnection);
          SendTaggedResponse(AConnection, AParameters, OkResponse + ' AUTHENTICATE completed');
        end else
        begin
          challenge := TclEncoder.EncodeToString(buf, cmBase64);
          SendResponse(AConnection, AParameters.Command, '+ ' + challenge);
        end;
      finally
        buf.Free();
      end;
    except
      on EclEncoderError do
      begin
        RaiseAuthAbort(AParameters);
      end;
      on EclSSPIError do
      begin
        RaiseAuthAbort(AParameters);
      end;
    end;
  except
    AcceptCommands(AConnection);
    raise;
  end;
end;

procedure TclImap4Server.HandleCAPABILITY(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
var
  i: Integer;
  list: TStrings;
  cap: string;
begin
  list := TStringList.Create();
  try
    GetCapabilities(AConnection, list);

    cap := '';
    for i := 0 to list.Count - 1 do
    begin
      cap := cap + ' ' + list[i];
    end;
      
    cap := 'CAPABILITY' + cap;

    SendTaggedResponse(AConnection, '*', AParameters.Command, cap);
    SendTaggedResponse(AConnection, AParameters, OkResponse + ' CAPABILITY completed');
  finally
    list.Free();
  end;
end;

procedure TclImap4Server.HandleCHECK(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  SendTaggedResponse(AConnection, AParameters, OkResponse + ' CHECK completed');
end;

procedure TclImap4Server.HandleSEARCH(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  InternalHandleSearch(AConnection, AParameters, False);
end;

procedure TclImap4Server.HandleUIDCOPY(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  InternalHandleCopy(AConnection, AParameters, True);
end;

procedure TclImap4Server.HandleUIDFETCH(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  InternalHandleFetch(AConnection, AParameters, True);
end;

procedure TclImap4Server.HandleUIDSEARCH(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  InternalHandleSearch(AConnection, AParameters, True);
end;

procedure TclImap4Server.HandleUIDSTORE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  InternalHandleStore(AConnection, AParameters, True);
end;

procedure TclImap4Server.InternalExpunge(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams; AIsClose: Boolean);
var
  mailBoxes: TclImap4MailBoxList;
  messages, targetList: TclImap4MessageList;
  success: Boolean;
  i: Integer;
  msg: TclImap4MessageItem;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csSelected]);

  if (AConnection.ReadOnlyAccess) then
  begin
    RaiseImapNoResponse(AParameters, 'Mailbox is read-only');
  end;

  mailBoxes := nil;
  messages := nil;
  targetList := nil;
  try
    mailBoxes := TclImap4MailBoxList.Create(TclImap4MailBoxItem);

    DoGetMailBoxes(AConnection, AConnection.CurrentMailBox, mailBoxes);

    if (mailBoxes.Count <> 1) then
    begin
      SendTaggedResponse(AConnection, AParameters, '%s %s completed', [OkResponse, AParameters.Command]);
      Exit;
    end;

    messages := TclImap4MessageList.Create(True);
    success := True;
    DoGetMessages(AConnection, messages, AConnection.CurrentMailBox, success);

    if (not success) then
    begin
      RaiseImapNoResponse(AParameters, 'Access denied');
    end;

    targetList := messages.SelectByFlag(mfDeleted);

    for i := 0 to targetList.Count - 1 do
    begin
      msg := targetList[i];

      success := True;
      DoDeleteMessage(AConnection, msg, AConnection.CurrentMailBox, success);

      if (not AIsClose and success) then
      begin
        SendResponse(AConnection, AParameters.Command, '* %d EXPUNGE', [msg.ID]);
      end;
    end;

    if (AIsClose) then
    begin
      ChangeState(AConnection, csAuthenticated);
    end;

    SendTaggedResponse(AConnection, AParameters, '%s %s completed', [OkResponse, AParameters.Command]);
  finally
    targetList.Free();
    messages.Free();
    mailBoxes.Free();
  end;
end;

procedure TclImap4Server.InternalHandleCopy(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams; AUseUID: Boolean);
var
  copyParams: TStrings;
  mailBoxes: TclImap4MailBoxList;
  success: Boolean;
  messages, targetList: TclImap4MessageList;
  msg: TclImap4MessageItem;
  i: Integer;
  messageSource: TStrings;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csSelected]);

  copyParams := nil;
  mailBoxes := nil;
  messages := nil;
  targetList := nil;
  messageSource := nil;
  try
    copyParams := TStringList.Create();

    ExtractQuotedWords(AParameters.Parameters, copyParams);
    if ((copyParams.Count <> 2) or (copyParams[0] = '') or (copyParams[1] = '')) then
    begin
      RaiseImapError(AParameters, 'COPY parse error');
    end;

    mailBoxes := TclImap4MailBoxList.Create(TclImap4MailBoxItem);
    DoGetMailBoxes(AConnection, AConnection.CurrentMailBox, mailBoxes);

    if (mailBoxes.Count <> 1) then
    begin
      RaiseImapNoResponse(AParameters, 'Mailbox does not exist');
    end;

    mailBoxes.Clear();
    DoGetMailBoxes(AConnection, copyParams[1], mailBoxes);

    if (mailBoxes.Count <> 1) then
    begin
      RaiseImapNoResponse(AParameters, '[TRYCREATE] Mailbox does not exist');
    end;

    success := True;
    messages := TclImap4MessageList.Create(True);
    DoGetMessages(AConnection, messages, AConnection.CurrentMailBox, success);

    if (not success) then
    begin
      RaiseImapNoResponse(AParameters, 'COPY error');
    end;

    targetList := messages.SelectMessages(copyParams[0], AUseUid);
    messageSource := TStringList.Create();

    for i := 0 to targetList.Count - 1 do
    begin
      msg := targetList[i];

      success := True;
      messageSource.Clear();
      DoGetMessageSource(AConnection, messageSource, msg.Name, AConnection.CurrentMailBox, success);

      if (success) then
      begin
        DoAppendMessage(AConnection, msg.Flags, msg.Date, messageSource, copyParams[1], success);

        if (not success) then
        begin
          RaiseImapNoResponse(AParameters, 'COPY error');
        end;
      end;
    end;

    SendTaggedResponse(AConnection, AParameters, OkResponse + ' COPY completed');
  finally
    messageSource.Free();
    targetList.Free();
    messages.Free();
    mailBoxes.Free();
    copyParams.Free();
  end;
end;

procedure TclImap4Server.InternalHandleFetch(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams; AUseUID: Boolean);
var
  fetchParams, messageSource: TStrings;
  mailBoxes: TclImap4MailBoxList;
  messages, targetList: TclImap4MessageList;
  success: Boolean;
  fetchList: TclImap4FetchList;
  msg: TclImap4MessageItem;
  i: Integer;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csSelected]);

  fetchParams := nil;
  mailBoxes := nil;
  messages := nil;
  targetList := nil;
  fetchList := nil;
  messageSource := nil;
  try
    fetchParams := TStringList.Create();

    ExtractQuotedWords(AParameters.Parameters, fetchParams, ' ', ['"', '('], ['"', ')'], False);
    if ((fetchParams.Count <> 2) or (fetchParams[0] = '') or (fetchParams[1] = '')) then
    begin
      RaiseImapError(AParameters, 'FETCH parse error');
    end;

    mailBoxes := TclImap4MailBoxList.Create(TclImap4MailBoxItem);
    DoGetMailBoxes(AConnection, AConnection.CurrentMailBox, mailBoxes);

    if (mailBoxes.Count <> 1) then
    begin
      RaiseImapNoResponse(AParameters, 'FETCH error');
    end;

    messages := TclImap4MessageList.Create(True);
    success := True;
    DoGetMessages(AConnection, messages, AConnection.CurrentMailBox, success);

    if (not success) then
    begin
      RaiseImapNoResponse(AParameters, 'FETCH error');
    end;

    targetList := messages.SelectMessages(fetchParams[0], AUseUid);
    fetchList := TclImap4FetchList.Create();
    fetchList.Parse(fetchParams[1]);

    messageSource := TStringList.Create();
    for i := 0 to targetList.Count - 1 do
    begin
      msg := targetList[i];
      success := True;
      messageSource.Clear();
      DoGetMessageSource(AConnection, messageSource, msg.Name, AConnection.CurrentMailBox, success);

      if (success) then
      begin
        FetchMessage(AConnection, AParameters, fetchList, msg, messageSource, AUseUID);
      end;
    end;
    
    SendTaggedResponse(AConnection, AParameters, OkResponse + ' FETCH completed');
  finally
    messageSource.Free();
    fetchList.Free();
    targetList.Free();
    messages.Free();
    mailBoxes.Free();
    fetchParams.Free();
  end;
end;

procedure TclImap4Server.WriteFetchResponse(AResponse: TStream; var AIsFirst: Boolean; const AData: string);
var
  b: Byte;
  buf: TclByteArray;
begin
{$IFNDEF DELPHI2005}buf := nil;{$ENDIF}
  if (not AIsFirst) then
  begin
    b := 32;
    AResponse.Write(b, 1);
  end;
  AIsFirst := False;

  if (AData <> '') then
  begin
    buf := TclTranslator.GetBytes(AData);
    AResponse.Write(buf[0], Length(buf));
  end;
end;

procedure TclImap4Server.FetchMessage(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams;
  AFetchList: TclImap4FetchList; AMessageItem: TclImap4MessageItem; AMessageSource: TStrings; AUseUID: Boolean);
var
  response: TStream;
  isFirst, statusChanged, flagsPassed, uidPassed: Boolean;
  fetchItem: TclImap4FetchItem;
  i: Integer;
  msgList: TclImap4MessageList;
  success: Boolean;
begin
  response := nil;
  msgList := nil;
  try
    response := TMemoryStream.Create();

    isFirst := True;
    WriteFetchResponse(response, isFirst, Format('* %d FETCH (', [AMessageItem.ID]));

    statusChanged := False;
    for i := 0 to AFetchList.Count - 1 do
    begin
      fetchItem := AFetchList[i];

      if ('BODY' = fetchItem.Name) or ('RFC822' = fetchItem.Name) or ('RFC822.TEXT' = fetchItem.Name) then
      begin
        statusChanged := True;
        Break;
      end;
    end;

    if statusChanged then
    begin
      statusChanged := not (mfSeen in AMessageItem.Flags);

      if statusChanged then
      begin
        AMessageItem.Flags := AMessageItem.Flags + [mfSeen];

        msgList := TclImap4MessageList.Create(False);
        msgList.Add(AMessageItem);

        success := True;
        DoUpdateMessages(AConnection, msgList, AConnection.CurrentMailBox, success);
      end;
    end;

    isFirst := True;
    uidPassed := False;
    flagsPassed := False;

    for i := 0 to AFetchList.Count - 1 do
    begin
      fetchItem := AFetchList[i];

      if ('BODY' = fetchItem.Name) then
      begin
        WriteFetchResponse(response, isFirst, '');
        TclImap4FetchBody.Build(AMessageSource, fetchItem.Name + '[' + fetchItem.Section + ']', fetchItem.Section, response);
      end else
      if ('BODY.PEEK' = fetchItem.Name) then
      begin
        WriteFetchResponse(response, isFirst, '');
        TclImap4FetchBody.Build(AMessageSource, 'BODY' + '[' + fetchItem.Section + ']', fetchItem.Section, response);
      end	else
      if ('RFC822' = fetchItem.Name) then
      begin
        WriteFetchResponse(response, isFirst, '');
        TclImap4FetchBody.Build(AMessageSource, fetchItem.Name, '', response);
      end else
      if ('RFC822.HEADER' = fetchItem.Name) then
      begin
        WriteFetchResponse(response, isFirst, '');
        TclImap4FetchBody.Build(AMessageSource, fetchItem.Name, 'HEADER', response);
      end else
      if ('RFC822.SIZE' = fetchItem.Name) then
      begin
        WriteFetchResponse(response, isFirst, 'RFC822.SIZE ' + IntToStr(GetStringsSize(AMessageSource)));
      end else
      if ('RFC822.TEXT' = fetchItem.Name) then
      begin
        WriteFetchResponse(response, isFirst, '');
        TclImap4FetchBody.Build(AMessageSource, fetchItem.Name, 'TEXT', response);
      end else
      if ('UID' = fetchItem.Name) then
      begin
        WriteFetchResponse(response, isFirst, 'UID ' + IntToStr(AMessageItem.UID));
        uidPassed := True;
      end else
      if ('FLAGS' = fetchItem.Name) then
      begin
        WriteFetchResponse(response, isFirst, 'FLAGS (' + GetStrByImapMessageFlags(AMessageItem.Flags) + ')');
        flagsPassed := True;
      end else
      if ('ENVELOPE' = fetchItem.Name) then
      begin
        WriteFetchResponse(response, isFirst, '');
        TclImap4FetchEnvelope.Build(AMessageSource, response);
      end else
      if ('BODYSTRUCTURE' = fetchItem.Name) then
      begin
        WriteFetchResponse(response, isFirst, '');
        TclImap4FetchBodyStructure.Build(AMessageSource, response);
      end else
      if ('INTERNALDATE' = fetchItem.Name) then
      begin
        WriteFetchResponse(response, isFirst, 'INTERNALDATE "' + DateTimeToImapTime(AMessageItem.Date) + '"');
      end;
    end;

    if ((not flagsPassed) and statusChanged) then
    begin
      WriteFetchResponse(response, isFirst, 'FLAGS (' + GetStrByImapMessageFlags(AMessageItem.Flags) + ')');
    end;

    if ((not uidPassed) and AUseUID) then
    begin
      WriteFetchResponse(response, isFirst, 'UID ' + IntToStr(AMessageItem.UID));
    end;

    isFirst := True;
    WriteFetchResponse(response, isFirst, ')'#13#10);
    response.Seek(0, soBeginning);
    AConnection.WriteData(response);
  finally
    msgList.Free();
    response.Free();
  end;
end;

procedure TclImap4Server.InternalHandleSearch(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams; AUseUid: Boolean);
var
  mailBoxes: TclImap4MailBoxList;
  messages: TclImap4MessageList;
  msg: TclImap4MessageItem;
  success, matches, handled: Boolean;
  response: string;
  i: Integer;
  messageSource: TStrings;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csSelected]);

  mailBoxes := nil;
  messages := nil;
  messageSource := nil;
  try
    mailBoxes := TclImap4MailBoxList.Create(TclImap4MailBoxItem);

    DoGetMailBoxes(AConnection, AConnection.CurrentMailBox, mailBoxes);

    if (mailBoxes.Count <> 1) then
    begin
      RaiseImapNoResponse(AParameters, 'SEARCH error');
    end;

    messages := TclImap4MessageList.Create(True);

    success := True;
    DoGetMessages(AConnection, messages, AConnection.CurrentMailBox, success);

    if (not success) then
    begin
      RaiseImapNoResponse(AParameters, 'SEARCH error');
    end;

    messageSource := TStringList.Create();
    response := '';
    for i := 0 to messages.Count - 1 do
    begin
      msg := messages[i];
      if (msg.UID > -1) then
      begin
        success := True;
        messageSource.Clear();
        DoGetMessageSource(AConnection, messageSource, msg.Name, AConnection.CurrentMailBox, success);

        if (success) then
        begin
          matches := False;
          handled := False;
          DoSearchMessage(AConnection, msg, messageSource, matches, handled);

          if (not handled) then
          begin
            matches := CheckSearchCriteria(AParameters.Parameters, messageSource);
          end;

          if (matches) then
          begin
            if (AUseUid) then
            begin
              response := response + ' ' + IntToStr(msg.UID);
            end else
            begin
              response := response + ' ' + IntToStr(i + 1);
            end;
          end;
        end;
      end;
    end;

    SendTaggedResponse(AConnection, '*', AParameters.Command, 'SEARCH ' + Trim(response));
    SendTaggedResponse(AConnection, AParameters, OkResponse + ' SEARCH completed');
  finally
    messageSource.Free();
    messages.Free();
    mailBoxes.Free();
  end;
end;

procedure TclImap4Server.HandleCOPY(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  InternalHandleCopy(AConnection, AParameters, False);
end;

procedure TclImap4Server.HandleCramMD5(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
var
  data: string;
  isAuthorized: Boolean;
begin
  try
    data := GetAuthData(AConnection, AParameters);

    if (data = '') then
    begin
      RaiseAuthAbort(AParameters);
    end;

    if (WordCount(data, [' ']) <> 2) then
    begin
      RaiseAuthAbort(AParameters);
    end;

    AConnection.FUserName := ExtractWord(1, data, [' ']);
    data := ExtractWord(2, data, [' ']);

    isAuthorized := CramMD5Authenticate(AConnection, UserAccounts.AccountByUserName(AConnection.userName),
      AConnection.UserName, AConnection.FCramMD5Key, data);
    CheckAuthorized(AConnection, AParameters, isAuthorized);

    ChangeState(AConnection, csAuthenticated);
    AcceptCommands(AConnection);
    SendTaggedResponse(AConnection, AParameters, OkResponse + ' AUTHENTICATE completed');
  except
    AcceptCommands(AConnection);
    raise;
  end;
end;

procedure TclImap4Server.HandleFETCH(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  InternalHandleFetch(AConnection, AParameters, False);
end;

procedure TclImap4Server.InternalHandleList(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams; IncludeAll: Boolean);
var
  listParams, list: TStrings;
  mailBoxes: TclImap4MailBoxList;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csAuthenticated, csSelected]);

  listParams := nil;
  mailBoxes := nil;
  try
    listParams := TStringList.Create();
    
    ExtractQuotedWords(AParameters.Parameters, listParams);

    if (listParams.Count <> 2) then
    begin
      RaiseParseError(AParameters);
    end;

    list := TStringList.Create();
    try
      if (listParams[1] = '') then
      begin
        list.Add(GetMailBoxResponse(AParameters, [maNoselect], ''));
      end else
      begin
        mailBoxes := TclImap4MailBoxList.Create(TclImap4MailBoxItem);
        DoGetMailBoxes(AConnection, '', mailBoxes);
        CollectMailBoxesResponse(AConnection, AParameters, mailBoxes, listParams[0], listParams[1], IncludeAll, list);
      end;

      SendMultipleLines(AConnection, list, Format('%s %s %s completed', [AParameters.Tag, OkResponse, AParameters.Command]));
    except
      list.Free();
      raise;
    end;
  finally
    mailBoxes.Free();
    listParams.Free();
  end;
end;

procedure TclImap4Server.HandleSTORE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  InternalHandleStore(AConnection, AParameters, False);
end;

procedure TclImap4Server.InternalHandleStore(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams; AUseUID: Boolean);
var
  storeParams: TStrings;
  flagsMethod: TclSetFlagsMethod;
  isSilent, success: Boolean;
  flags: TclMailMessageFlags;
  mailBoxes: TclImap4MailBoxList;
  messages, targetList, msgList: TclImap4MessageList;
  msg: TclImap4MessageItem;
  i: Integer;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csSelected]);

  if (AConnection.ReadOnlyAccess) then
  begin
    RaiseImapNoResponse(AParameters, 'Mailbox is read-only');
  end;

  storeParams := nil;
  mailBoxes := nil;
  messages := nil;
  targetList := nil;
  msgList := nil;
  try
    storeParams := TStringList.Create();

    ExtractQuotedWords(AParameters.Parameters, storeParams, ' ', ['"', '('], ['"', ')'], False);

    if ((storeParams.Count <> 3) or (storeParams[0] = '')
      or (storeParams[1] = '') or (storeParams[2] = '')) then
    begin
      RaiseImapError(AParameters, 'STORE parse error');
    end;

    flagsMethod := fmReplace;
    case storeParams[1][1] of
      '+': flagsMethod := fmAdd;
      '-': flagsMethod := fmRemove;
    end;

    isSilent := (Pos('.SILENT', UpperCase(storeParams[1])) > 0);
    flags := GetImapMessageFlagsByStr(UpperCase(storeParams[2]));

    mailBoxes := TclImap4MailBoxList.Create(TclImap4MailBoxItem);

    DoGetMailBoxes(AConnection, AConnection.CurrentMailBox, mailBoxes);

    if (mailBoxes.Count <> 1) then
    begin
      RaiseImapNoResponse(AParameters, 'STORE error');
    end;

    success := True;
    messages := TclImap4MessageList.Create(True);
    DoGetMessages(AConnection, messages, AConnection.CurrentMailBox, success);
    
    if (not success) then
    begin
      RaiseImapNoResponse(AParameters, 'STORE error');
    end;

    targetList := messages.SelectMessages(storeParams[0], AUseUid);
    msgList := TclImap4MessageList.Create(False);

    for i := 0 to targetList.Count - 1 do
    begin
      msg := targetList[i];

      case (flagsMethod) of
        fmAdd: msg.Flags := msg.Flags + flags;
        fmRemove: msg.Flags := msg.Flags - flags
      else
        msg.Flags := flags;
      end;

      msgList.Clear();
      msgList.Add(msg);

      success := True;
      DoUpdateMessages(AConnection, msgList, AConnection.CurrentMailBox, success);

      if (not isSilent and success) then
      begin
        SendResponse(AConnection, AParameters.Command, '* %d FETCH FLAGS (%s)', [msg.ID, GetStrByImapMessageFlags(msg.Flags)]);
      end;
    end;

    SendTaggedResponse(AConnection, AParameters, OkResponse + ' STORE completed');
  finally
    msgList.Free();
    targetList.Free();
    messages.Free();
    mailBoxes.Free();
    storeParams.Free();
  end;
end;

procedure TclImap4Server.InternalSubscribe(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams; IsSubscribe: Boolean);
var
  mailbox: TStrings;
  mailBoxes: TclImap4MailBoxList;
  success: Boolean;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csAuthenticated, csSelected]);

  mailbox := nil;
  mailBoxes := nil;
  try
    mailbox := TStringList.Create();

    ExtractQuotedWords(AParameters.Parameters, mailbox);
    if ((mailbox.Count <> 1) or (mailbox[0] = '')) then
    begin
      RaiseParseError(AParameters);
    end;

    mailBoxes := TclImap4MailBoxList.Create(TclImap4MailBoxItem);
    DoGetMailBoxes(AConnection, mailbox[0], mailBoxes);

    if (mailBoxes.Count <> 1) then
    begin
      RaiseImapNoResponse(AParameters, 'Access denied');
    end;

    mailBoxes[0].IsSubscribed := IsSubscribe;

    success := True;
    DoUpdateMailBox(AConnection, mailBoxes[0], success);

    if (not success) then
    begin
      RaiseImapNoResponse(AParameters, 'Access denied');
    end;

    SendTaggedResponse(AConnection, AParameters, '%s %s completed', [OkResponse, AParameters.Command]);
  finally
    mailBoxes.Free();
    mailbox.Free();
  end;
end;

procedure TclImap4Server.HandleCLOSE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  InternalExpunge(AConnection, AParameters, True);
end;

procedure TclImap4Server.HandleEXPUNGE(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  InternalExpunge(AConnection, AParameters, False);
end;

procedure TclImap4Server.HandleAPPEND(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
var
  appendParams: TStrings;
  i, messageSize: Integer;
  s: string;
  mailBoxes: TclImap4MailBoxList;
begin
  CheckTlsMode(AConnection, AParameters);
  CheckConnectionState(AConnection, AParameters, [csAuthenticated, csSelected]);

  appendParams := nil;
  mailBoxes := nil;
  try
    appendParams := TStringList.Create();

    ExtractQuotedWords(AParameters.Parameters, appendParams, ' ', ['"', '(', '{'], ['"', ')', '}'], True);

    if ((appendParams.Count < 2) or (appendParams[0] = '')
      or (appendParams[appendParams.Count - 1] = '')) then
    begin
      RaiseParseError(AParameters);
    end;

    AConnection.FAppendInfo.MailBox := ExtractQuotedString(appendParams[0], '"');
    messageSize := 0;

    for i := 1 to appendParams.Count - 1 do
    begin
      s := appendParams[i];

      if (s = '') then Continue;

      if (s[1] = '(') then
      begin
        s := ExtractQuotedString(s, '(', ')');
        AConnection.FAppendInfo.Flags := GetImapMessageFlagsByStr(UpperCase(s));
      end else
      if (s[1] = '"') then
      begin
        s := ExtractQuotedString(s, '"', '"');
        try
          AConnection.FAppendInfo.Date := MimeTimeToDateTime(s);
        except
        end;
      end else
      if (s[1] = '{') then
      begin
        s := ExtractQuotedString(s, '{', '}');
        messageSize := StrToIntDef(s, 0);
      end;
    end;

    if (messageSize = 0) then
    begin
      RaiseParseError(AParameters);
    end;

    mailBoxes := TclImap4MailBoxList.Create(TclImap4MailBoxItem);
    DoGetMailBoxes(AConnection, AConnection.FAppendInfo.MailBox, mailBoxes);

    if (mailBoxes.Count <> 1) then
    begin
      RaiseImapNoResponse(AParameters, '[TRYCREATE] Mailbox does not exist');
    end;

    AcceptFixedBytes(AConnection, TclImap4CommandInfo.Create(AParameters.Tag, AParameters.Command, HandleAppendDone), messageSize + 2);
    SendResponse(AConnection, AParameters.Command, '+ Ready for append literal');
  finally
    mailBoxes.Free();
    appendParams.Free();
  end;
end;

procedure TclImap4Server.HandleAppendDone(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
var
  success: Boolean;
begin
  try
    if ((AParameters.RawData.Count > 0)
      and (Length(AParameters.RawData[AParameters.RawData.Count - 1]) = 0)) then
    begin
      AParameters.RawData.Delete(AParameters.RawData.Count - 1);
    end;

    success := True;
    DoAppendMessage(AConnection, AConnection.FAppendInfo.Flags, AConnection.FAppendInfo.Date,
      AParameters.RawData, AConnection.FAppendInfo.MailBox, success);

    if (not success) then
    begin
      RaiseImapNoResponse(AParameters, 'Access denied');
    end;

    AcceptCommands(AConnection);
    SendTaggedResponse(AConnection, AParameters, OkResponse + ' APPEND completed');
  except
    AcceptCommands(AConnection);
    raise;
  end;
end;

procedure TclImap4Server.HandleNullCommand(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
begin
  RaiseImapError(AParameters, 'Invalid command: ' + AParameters.Command);
end;

function TclImap4Server.GetNullCommand(AParameters: TclTcpCommandParams): TclTcpCommandInfo;
begin
  Result := TclImap4CommandInfo.Create(AParameters.Command, HandleNullCommand);
end;

function TclImap4Server.GetTaggedResponse(AParameters: TclImap4CommandParams;
  const AResponse: string): string;
begin
  Result := AParameters.Tag;
  if (Result = '') then
  begin
    Result := '*';
  end;
  Result := Result + ' ' + AResponse;
end;

procedure TclImap4Server.ProcessUnhandledError(AConnection: TclCommandConnection;
  AParameters: TclTcpCommandParams; E: Exception);
begin
  SendTaggedResponse(AConnection, (AParameters as TclImap4CommandParams), BadResponse + ' ' + Trim(E.Message));    
end;

procedure TclImap4Server.HandleSTARTTLS(AConnection: TclImap4CommandConnection; AParameters: TclImap4CommandParams);
begin
  if (UseTLS = stNone) or (UseTLS = stImplicit) or AConnection.IsTls then
  begin
    RaiseImapNoResponse(AParameters, 'you have already logged in');
  end;

  AConnection.InitParams();
  StartTls(AConnection);
  
  SendTaggedResponse(AConnection, AParameters, OkResponse + ' begin TLS negotiation');
end;

procedure TclImap4Server.CheckTlsMode(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams);
begin
  if (UseTLS = stExplicitRequire) and (not AConnection.IsTls) then
  begin
    RaiseImapError(AParameters, 'Must issue a STARTTLS command first');
  end;
end;

procedure TclImap4Server.CheckConnectionState(AConnection: TclImap4CommandConnection;
  AParameters: TclImap4CommandParams; ACheckStates: array of TclImap4ConnectionState);
begin
  if not IsInState(AConnection.ConnectionState, ACheckStates) then
  begin
    RaiseBadStateError(AParameters);
  end;
end;

function TclImap4Server.CheckSearchCriteria(const ACriteria: string; AMessageSource: TStrings): Boolean;
var
  criteria: TStrings;
  fieldList: TclMailHeaderFieldList;
  crt, val: string;
begin
  Result := False;

  criteria := nil;
  fieldList := nil;
  try
    criteria := TStringList.Create();

    ExtractQuotedWords(ACriteria, criteria);
    if (criteria.Count = 0) then Exit;

    crt := UpperCase(criteria[0]);

    if (crt = 'ALL') then
    begin
      Result := True;
    end else
    if ((crt = 'FROM') or (crt = 'TO') or (crt = 'SUBJECT')) and (criteria.Count > 1) then
    begin
      fieldList := TclMailHeaderFieldList.Create(DefaultCharSet, cmNone, DefaultCharsPerLine);

      fieldList.Parse(0, AMessageSource);

      val := UpperCase(fieldList.GetFieldValue(crt));

      Result := (Pos(UpperCase(criteria[1]), val) > 0);
    end;
  finally
    fieldList.Free();
    criteria.Free();
  end;
end;

procedure TclImap4Server.SetCapabilities(const Value: TStrings);
begin
  FCapabilities.Assign(Value);
end;

procedure TclImap4Server.SendTaggedResponseAndClose(
  AConnection: TclCommandConnection; AParameters: TclImap4CommandParams;
  const AResponse: string);
begin
  SendResponseAndClose(AConnection, AParameters.Command, GetTaggedResponse(AParameters, AResponse));
end;

{ TclImap4MailBoxList }

function TclImap4MailBoxList.Add: TclImap4MailBoxItem;
begin
  Result := TclImap4MailBoxItem(inherited Add());
end;

function TclImap4MailBoxList.GetItem(Index: Integer): TclImap4MailBoxItem;
begin
  Result := TclImap4MailBoxItem(inherited GetItem(Index));
end;

procedure TclImap4MailBoxList.SetItem(Index: Integer; const Value: TclImap4MailBoxItem);
begin
  inherited SetItem(Index, Value);
end;

{ TclImap4CommandInfo }

constructor TclImap4CommandInfo.Create(const AName: string; AHandler: TclImap4CommandHandler);
begin
  inherited Create(AName);
  Tag := '';
  FHandler := AHandler;
end;

constructor TclImap4CommandInfo.Create(const ATag, AName: string; AHandler: TclImap4CommandHandler);
begin
  inherited Create(AName);
  Tag := ATag;
  FHandler := AHandler;
end;

procedure TclImap4CommandInfo.Execute(AConnection: TclCommandConnection; AParams: TclTcpCommandParams);
begin
  FHandler(AConnection as TclImap4CommandConnection, AParams as TclImap4CommandParams);
end;

{ TclImap4CommandConnection }

procedure TclImap4CommandConnection.AssignNtlm(Auth: TclNtAuthServerSspi);
begin
  FNTLMAuth.Free();
  FNTLMAuth := Auth;
end;

constructor TclImap4CommandConnection.Create;
begin
  inherited Create();

  FAppendInfo := TclAppendMessageInfo.Create();
  InitParams();
end;

procedure TclImap4CommandConnection.DoDestroy;
begin
  FNTLMAuth.Free();
  FAppendInfo.Free();
  inherited DoDestroy();
end;

procedure TclImap4CommandConnection.InitParams;
begin
  FUserName := '';
  FCramMD5Key := '';
  FConnectionState := csNonAuthenticated;
  FCurrentMailBox := '';
  FReadOnlyAccess := False;
end;

{ EclImap4ServerError }

constructor EclImap4ServerError.Create(const ATag, ACommand, AErrorMsg: string;
  AErrorCode: Integer);
begin
  inherited Create(ACommand, AErrorMsg, AErrorCode);
  FTag := ATag;
end;

constructor EclImap4ServerError.Create(const ATag, ACommand, AErrorMsg: string;
  AErrorCode: Integer; ANeedClose: Boolean);
begin
  inherited Create(ACommand, AErrorMsg, AErrorCode, ANeedClose);
  FTag := ATag;
end;

{ TclImap4MailBoxItem }

constructor TclImap4MailBoxItem.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FName := '';
  FIsSubscribed := False;
  FFlags := [mfAnswered, mfFlagged, mfDeleted, mfSeen, mfDraft, mfRecent];
  FChangeableFlags := [mfAnswered, mfFlagged, mfDeleted, mfSeen, mfDraft];
  FUIDNext := 0;
  FUIDValidity := '';
  FAttributes := [];
end;

{ TclImap4MessageItem }

constructor TclImap4MessageItem.Create(const AName: string);
begin
  inherited Create();
  FName := AName;
  FUid := -1;
  FFlags := [];
  FDate := Now();
end;

constructor TclImap4MessageItem.Create;
begin
  inherited Create();
  FName := '';
  FUid := -1;
  FFlags := [];
  FDate := Now();
end;

constructor TclImap4MessageItem.Create(const AName: string; AUid: Integer;
  AFlags: TclMailMessageFlags; ADate: TDateTime);
begin
  inherited Create();
  FName := AName;
  FUid := AUid;
  FFlags := AFlags;
  FDate := ADate;
end;

constructor TclImap4MessageItem.Create(const AName: string; AUid: Integer;
  AFlags: TclMailMessageFlags);
begin
  inherited Create();
  FName := AName;
  FUid := AUid;
  FFlags := AFlags;
  FDate := Now();
end;

{ TclImap4MessageList }

procedure TclImap4MessageList.Add(AItem: TclImap4MessageItem);
var
  ind: Integer;
begin
  ind := Count;

  if (AItem.UID > -1) then
  begin
    while (ind > 0) do
    begin
      if ((Items[ind - 1].UID > -1) and (Items[ind - 1].UID < AItem.UID)) then
      begin
        Break;
      end;
      Dec(ind);
    end;
  end;

  if (ind >= Count) then
  begin
    FList.Add(AItem);
  end else
  begin
    FList.Insert(ind, AItem);
  end;
end;

procedure TclImap4MessageList.Clear;
begin
  FList.Clear();
end;

constructor TclImap4MessageList.Create;
begin
  inherited Create();
  DoCreate(True);
end;

constructor TclImap4MessageList.Create(AOwnsObjects: Boolean);
begin
  inherited Create();
  DoCreate(AOwnsObjects);
end;

procedure TclImap4MessageList.DoCreate(AOwnsObjects: Boolean);
begin
  FList := TObjectList.Create(AOwnsObjects);
  FUids := nil;
end;

procedure TclImap4MessageList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TclImap4MessageList.Destroy;
begin
  FUids.Free();
  FList.Free();
  inherited Destroy();
end;

function TclImap4MessageList.FindByName(const AName: string): TclImap4MessageItem;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Result := Items[i];
    if (Result.Name = AName) then Exit;
  end;
  Result := nil;
end;

function TclImap4MessageList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclImap4MessageList.GetItem(Index: Integer): TclImap4MessageItem;
begin
  Result := TclImap4MessageItem(FList[Index]);
end;

function TclImap4MessageList.GetOwnsObjects: Boolean;
begin
  Result := FList.OwnsObjects;
end;

function TclImap4MessageList.GetSeqNum(const ASource: string; AUids: TStrings; AUseUid: Boolean): Integer;
var
  seq, seqInd: Integer;
begin
  if ((ASource = '*') and (AUids.Count > 0)) then
  begin
    Result := AUids.Count - 1;
    Exit;
  end;

  Result := -1;
  seq := StrToIntDef(ASource, 0);

  if (AUseUid) then
  begin
    seqInd := AUids.IndexOf(IntToStr(seq));

    if(seqInd > -1) then
    begin
      Result := Integer(AUids.Objects[seqInd]);
    end;
  end else
  begin
    seq := seq - 1;

    if ((seq > -1) and (seq < AUids.Count)) then
    begin
      Result := seq;
    end;
  end;
end;

function TclImap4MessageList.GetUidList: TStrings;
var
  i: Integer;
begin
  if (FUids = nil) then
  begin
    FUids := TStringList.Create();
  end else
  begin
    FUids.Clear();
  end;

  Result := FUids;

  for i := 0 to Count - 1 do
  begin
    if (Items[i].UID < 0) then Break;
    FUids.AddObject(IntToStr(Items[i].UID), TObject(i));
  end;
end;

procedure TclImap4MessageList.InitMessageIDs;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    Items[i].ID := i + 1;
  end;
end;

function TclImap4MessageList.SelectByFlag(AFlag: TclMailMessageFlag): TclImap4MessageList;
var
  i: Integer;
begin
  InitMessageIDs();

  Result := TclImap4MessageList.Create(False);
  try
    for i := 0 to Count - 1 do
    begin
      if (AFlag in Items[i].Flags) then
      begin
        Result.Add(Items[i]);
      end;
    end;
  except
    Result.Free();
    raise;
  end;
end;

function TclImap4MessageList.SelectMessages(const AMessageSet: string; AUseUid: Boolean): TclImap4MessageList;
var
  i, first, last, temp, j: Integer;
  seqList, seqRange, uids: TStrings;
begin
  InitMessageIDs();

  Result := TclImap4MessageList.Create(False);
  try
    seqList := nil;
    seqRange := nil;
    try
      seqList := TStringList.Create();
      seqRange := TStringList.Create();

      ExtractQuotedWords(AMessageSet, seqList, ',');

      uids := GetUidList();

      for i := 0 to seqList.Count - 1 do
      begin
        ExtractQuotedWords(seqList[i], seqRange, ':');
        if (seqRange.Count = 1) then
        begin
          first := GetSeqNum(seqRange[0], uids, AUseUid);
          if (first > -1) then
          begin
            Result.Add(Items[first]);
          end;
        end else
        if (seqRange.Count > 1) then
        begin
          first := GetSeqNum(seqRange[0], uids, AUseUid);
          last := GetSeqNum(seqRange[1], uids, AUseUid);
          if (first > last) then
          begin
            temp := first;
            first := last;
            last := temp;
          end;

          for j := first to last do
          begin
            if (j > -1) then
            begin
              Result.Add(Items[j]);
            end;
          end;
        end;
      end;
    finally
      seqRange.Free();
      seqList.Free();
    end;
  except
    Result.Free();
    raise;
  end;
end;

{ TclAppendMessageInfo }

constructor TclAppendMessageInfo.Create;
begin
  inherited Create();

  FMailBox := '';
  FFlags := [];
  FDate := Now();
end;

{ TclImap4CommandParams }

constructor TclImap4CommandParams.Create(const ATag, ACommand, AParameters: string);
begin
  inherited Create(ACommand, AParameters);
  FTag := ATag;
end;

constructor TclImap4CommandParams.Create;
begin
  inherited Create();
  FTag := '';
end;

procedure TclImap4CommandParams.FromRawCommand(const ARawCommand: string);
var
  list: TStrings;
  s: string;
  isParam: Boolean;
  i: Integer;
  c: Char;
begin
  Tag := '';
  Command := '';
  Parameters := '';
  RawCommand := ARawCommand;

  if (ARawCommand = '') then Exit;

  list := TStringList.Create();
  try
    s := '';
    isParam := False;

    for i := 1 to Length(ARawCommand) do
    begin
      c := ARawCommand[i];

      if (c = ' ') then
      begin
        if (isParam) then
        begin
          if (s <> '') then
          begin
            s := s + c;
          end;
        end else
        if (s <> '') then
        begin
          list.Add(s);
          s := '';
          if ((list.Count = 2) and ('UID' <> UpperCase(list[1]))) then
          begin
            isParam := True;
          end else
          if ((list.Count = 3) and ('UID' = UpperCase(list[1]))) then
          begin
            isParam := True;
          end;
        end;
      end else
      begin
        s := s + c;
      end;
    end;

    if (s <> '') then
    begin
      list.Add(s);
    end;

    if (list.Count = 1) then
    begin
      Command := UpperCase(list[0]);
    end else
    if (list.Count = 2) then
    begin
      Tag := list[0];
      Command := UpperCase(list[1]);
    end else
    if (list.Count = 3) then
    begin
      Tag := list[0];
      Command := UpperCase(list[1]);
      Parameters := list[2];
    end else
    if (list.Count = 4) then
    begin
      Tag := list[0];
      Command := UpperCase(list[1]) + ' ' + UpperCase(list[2]);
      Parameters := list[3];
    end;
  finally
    list.Free();
  end;
end;

procedure TclImap4CommandParams.FromRawLine(AContext: TclProcessLineContext);
begin
  if (AContext.Command is TclImap4CommandInfo) then
  begin
    FTag := TclImap4CommandInfo(AContext.Command).Tag;
  end else
  begin
    FTag := '';
  end;

  inherited FromRawLine(AContext);
end;

procedure TclImap4CommandParams.FromRawMultiLine(AContext: TclProcessMultiLineContext);
begin
  if (AContext.Command is TclImap4CommandInfo) then
  begin
    FTag := TclImap4CommandInfo(AContext.Command).Tag;
  end else
  begin
    FTag := '';
  end;

  inherited FromRawMultiLine(AContext);
end;

end.

