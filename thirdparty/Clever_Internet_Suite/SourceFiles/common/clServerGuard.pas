{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clServerGuard;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, Contnrs, SyncObjs, Windows,
{$ELSE}
  System.Classes, System.Contnrs, System.SyncObjs, Winapi.Windows,
{$ENDIF}
  clUtils;

type
  TclGuardConnectionLimit = class(TPersistent)
  private
    FMax: Integer;
    FPeriod: Integer;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property Max: Integer read FMax write FMax default 6;
    property Period: Integer read FPeriod write FPeriod default 60000;
  end;

  TclGuardLoginDelay = class(TPersistent)
  private
    FMax: Integer;
    FIncrement: Integer;
    FMin: Integer;
    FIsIncremental: Boolean;
    FIsRandom: Boolean;
  public
    constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property Min: Integer read FMin write FMin default 10;
    property Max: Integer read FMax write FMax default 5000;
    property Increment: Integer read FIncrement write FIncrement default 1000;
    property IsIncremental: Boolean read FIsIncremental write FIsIncremental default True;
    property IsRandom: Boolean read FIsRandom write FIsRandom default True;  
  end;

  TclGuardConnectionInfo = class
  private
    FIP: string;
    FPort: Integer;
    FTime: Integer;
    FAttempts: Integer;
  public
    constructor Create(const AIP: string; APort, ATime: Integer);
    function NewAttempt: Integer;
    
    property IP: string read FIP;
    property Port: Integer read FPort;
    property Time: Integer read FTime;
    property Attempts: Integer read FAttempts;
  end;

  TclGuardUserInfo = class(TclGuardConnectionInfo)
  private
    FUserName: string;
    FDelay: Integer;
  public
    constructor Create(const AUserName, AIP: string; APort, ATime: Integer);

    property UserName: string read FUserName;
    property Delay: Integer read FDelay write FDelay;
  end;

  TclGuardConnectionInfoList = class
  private
    FList: TObjectList;
    
    function GetCount: Integer;
  protected
    function GetItem(Index: Integer): TclGuardConnectionInfo;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(AItem: TclGuardConnectionInfo);
    procedure Delete(Index: Integer);
    procedure Clear;

    property Items[Index: Integer]: TclGuardConnectionInfo read GetItem; default;
    property Count: Integer read GetCount;
  end;

  TclGuardUserInfoList = class(TclGuardConnectionInfoList)
  private
    function GetItem(Index: Integer): TclGuardUserInfo;
  public
    property Items[Index: Integer]: TclGuardUserInfo read GetItem; default;
  end;

  TclGuardConnectionEvent = procedure(Sender: TObject; const AIP: string; APort: Integer; ATime: Integer) of object;
  TclGuardCanConnectEvent = procedure(Sender: TObject; const AIP: string; APort: Integer; ATime: Integer;
    var Allowed, Handled: Boolean) of object;
  TclGuardUserEvent = procedure(Sender: TObject; const AUserName, AIP: string; APort: Integer; ATime: Integer) of object;
  TclGuardGetDelayEvent = procedure(Sender: TObject; AUser: TclGuardUserInfo; var ADelay: Integer; var Handled: Boolean) of object;
  TclGuardCanLoginEvent = procedure(Sender: TObject; const AUserName, AIP: string; APort: Integer; ATime: Integer;
    var Allowed, Handled: Boolean) of object;
  
  TclServerGuard = class(TComponent)
  private
    FOnCanConnect: TclGuardCanConnectEvent;
    FOnAddUser: TclGuardUserEvent;
    FOnAllowConnection: TclGuardConnectionEvent;
    FOnRemoveConnection: TclGuardConnectionEvent;
    FOnBlockConnection: TclGuardConnectionEvent;
    FOnLockUser: TclGuardUserEvent;
    FOnCanLogin: TclGuardCanLoginEvent;
    FOnAddConnection: TclGuardConnectionEvent;
    FOnGetDelay: TclGuardGetDelayEvent;
    FOnRemoveUser: TclGuardUserEvent;
    
    FUsers: TclGuardUserInfoList;
    FConnections: TclGuardConnectionInfoList;
    FEnableLoginCheck: Boolean;
    FEnableConnectCheck: Boolean;
    FAllowWhiteListOnly: Boolean;
    FLockedUsers: TStrings;
    FBlackIPList: TStrings;
    FWhiteIPList: TStrings;
    FLoginDelay: TclGuardLoginDelay;
    FConnectionLimit: TclGuardConnectionLimit;
    FAccessor: TCriticalSection;
    
    procedure SetLockedUsers(const Value: TStrings);
    procedure SetBlackIPList(const Value: TStrings);
    procedure SetWhiteIPList(const Value: TStrings);
    procedure SetLoginDelay(const Value: TclGuardLoginDelay);
    procedure SetConnectionLimit(const Value: TclGuardConnectionLimit);

    function GetWildcardIP(const AIP: string): string;
    function GetLoginDelay(AUser: TclGuardUserInfo): Integer;
  protected
    procedure DoAllowConnection(const AIP: string; APort: Integer; ATime: Integer);
    procedure DoBlockConnection(const AIP: string; APort: Integer; ATime: Integer);
    procedure DoAddConnection(const AIP: string; APort: Integer; ATime: Integer);
    procedure DoRemoveConnection(const AIP: string; APort: Integer; ATime: Integer);
    procedure DoCanConnect(const AIP: string; APort: Integer; ATime: Integer; var Allowed, Handled: Boolean);
    procedure DoLockUser(const AUserName, AIP: string; APort: Integer; ATime: Integer);
    procedure DoAddUser(const AUserName, AIP: string; APort: Integer; ATime: Integer);
    procedure DoRemoveUser(const AUserName, AIP: string; APort: Integer; ATime: Integer);
    procedure DoGetDelay(AUser: TclGuardUserInfo; var ADelay: Integer; var Handled: Boolean);
    procedure DoCanLogin(const AUserName, AIP: string; APort: Integer; ATime: Integer; var Allowed, Handled: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Connect(const AIP: string; APort: Integer): Boolean; virtual;
    function Login(const AUserName: string; AIsAuthorized: Boolean; const AIP: string; APort: Integer): Boolean; virtual;
    procedure Reset; virtual;

    function IsBlackListed(const AIP: string; APort, ATime: Integer): Boolean;
    function IsWhiteListed(const AIP: string; APort, ATime: Integer): Boolean;
    function IsLockedUser(const AUserName, AIP: string; APort, ATime: Integer): Boolean;

    property Users: TclGuardUserInfoList read FUsers;
    property Connections: TclGuardConnectionInfoList read FConnections;
  published
    property ConnectionLimit: TclGuardConnectionLimit read FConnectionLimit write SetConnectionLimit;
    property LoginDelay: TclGuardLoginDelay read FLoginDelay write SetLoginDelay;

    property WhiteIPList: TStrings read FWhiteIPList write SetWhiteIPList;
    property BlackIPList: TStrings read FBlackIPList write SetBlackIPList;
    property LockedUsers: TStrings read FLockedUsers write SetLockedUsers;
    property AllowWhiteListOnly: Boolean read FAllowWhiteListOnly write FAllowWhiteListOnly default False;
    property EnableConnectCheck: Boolean read FEnableConnectCheck write FEnableConnectCheck default True;
    property EnableLoginCheck: Boolean read FEnableLoginCheck write FEnableLoginCheck default True;

    property OnAllowConnection: TclGuardConnectionEvent read FOnAllowConnection write FOnAllowConnection;
    property OnBlockConnection: TclGuardConnectionEvent read FOnBlockConnection write FOnBlockConnection;
    property OnAddConnection: TclGuardConnectionEvent read FOnAddConnection write FOnAddConnection;
    property OnRemoveConnection: TclGuardConnectionEvent read FOnRemoveConnection write FOnRemoveConnection;
    property OnCanConnect: TclGuardCanConnectEvent read FOnCanConnect write FOnCanConnect;
    property OnLockUser: TclGuardUserEvent read FOnLockUser write FOnLockUser;
    property OnAddUser: TclGuardUserEvent read FOnAddUser write FOnAddUser;
    property OnRemoveUser: TclGuardUserEvent read FOnRemoveUser write FOnRemoveUser;
    property OnGetDelay: TclGuardGetDelayEvent read FOnGetDelay write FOnGetDelay;
    property OnCanLogin: TclGuardCanLoginEvent read FOnCanLogin write FOnCanLogin;
  end;

implementation

{ TclServerGuard }

function TclServerGuard.Connect(const AIP: string; APort: Integer): Boolean;
var
  i: Integer;
  currentTime: Integer;
  handled: Boolean;
  conn, info: TclGuardConnectionInfo;
begin
  if (not EnableConnectCheck) then
  begin
    Result := True;
    Exit;
  end;

  FAccessor.Enter();
  try
    currentTime := Integer(GetTickCount());

    Result := False;
    handled := False;
    DoCanConnect(AIP, APort, currentTime, Result, handled);

    if handled then
    begin
      Exit;
    end;

    if (AIP = '') then
    begin
      DoBlockConnection(AIP, APort, currentTime);
      Result := False;
      Exit;
    end;

    if IsBlackListed(AIP, APort, currentTime) then
    begin
      Result := False;
      Exit;
    end;

    if IsWhiteListed(AIP, APort, currentTime) then
    begin
      Result := True;
      Exit;
    end else
    if AllowWhiteListOnly then
    begin
      Result := False;
      Exit;
    end;

    conn := nil;
    for i := Connections.Count - 1 downto 0 do
    begin
      info := Connections[i];
      if ((currentTime - info.Time) < ConnectionLimit.Period) then
      begin
        if (info.IP = AIP) then
        begin
          conn := info;
        end;
      end else
      begin
        Connections.Delete(i);
        DoRemoveConnection(AIP, APort, currentTime);
      end;
    end;

    if (conn = nil) then
    begin
      conn := TclGuardConnectionInfo.Create(AIP, APort, currentTime);
      Connections.Add(conn);
      DoAddConnection(AIP, APort, currentTime);
    end;

    Result := conn.NewAttempt() <= ConnectionLimit.Max;
    if Result then
    begin
      DoAllowConnection(AIP, APort, currentTime);
    end else
    begin
      DoBlockConnection(AIP, APort, currentTime);
    end;
  finally
    FAccessor.Leave();
  end;
end;

constructor TclServerGuard.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FAccessor := TCriticalSection.Create();

  FConnectionLimit := TclGuardConnectionLimit.Create();
  FLoginDelay := TclGuardLoginDelay.Create();

  FConnections := TclGuardConnectionInfoList.Create();
  FUsers := TclGuardUserInfoList.Create();

  FWhiteIPList := TStringList.Create();
  FBlackIPList := TStringList.Create();
  FLockedUsers := TStringList.Create();

  FEnableConnectCheck := True;
  FEnableLoginCheck := True;

  Randomize();
end;

destructor TclServerGuard.Destroy;
begin
  FLockedUsers.Free();
  FBlackIPList.Free();
  FWhiteIPList.Free();

  FUsers.Free();
  FConnections.Free();

  FLoginDelay.Free();
  FConnectionLimit.Free();

  FAccessor.Free();

  inherited Destroy();
end;

procedure TclServerGuard.DoAddConnection(const AIP: string; APort, ATime: Integer);
begin
  if Assigned(OnAddConnection) then
  begin
    OnAddConnection(Self, AIP, APort, ATime);
  end;
end;

procedure TclServerGuard.DoAddUser(const AUserName, AIP: string; APort, ATime: Integer);
begin
  if Assigned(OnAddUser) then
  begin
    OnAddUser(Self, AUserName, AIP, APort, ATime);
  end;
end;

procedure TclServerGuard.DoAllowConnection(const AIP: string; APort, ATime: Integer);
begin
  if Assigned(OnAllowConnection) then
  begin
    OnAllowConnection(Self, AIP, APort, ATime);
  end;
end;

procedure TclServerGuard.DoBlockConnection(const AIP: string; APort, ATime: Integer);
begin
  if Assigned(OnBlockConnection) then
  begin
    OnBlockConnection(Self, AIP, APort, ATime);
  end;
end;

procedure TclServerGuard.DoCanConnect(const AIP: string; APort, ATime: Integer; var Allowed, Handled: Boolean);
begin
  if Assigned(OnCanConnect) then
  begin
    OnCanConnect(Self, AIP, APort, ATime, Allowed, Handled);
  end;
end;

procedure TclServerGuard.DoCanLogin(const AUserName, AIP: string; APort, ATime: Integer; var Allowed, Handled: Boolean);
begin
  if Assigned(OnCanLogin) then
  begin
    OnCanLogin(Self, AUserName, AIP, APort, ATime, Allowed, Handled);
  end;
end;

procedure TclServerGuard.DoGetDelay(AUser: TclGuardUserInfo; var ADelay: Integer; var Handled: Boolean);
begin
  if Assigned(OnGetDelay) then
  begin
    OnGetDelay(Self, AUser, ADelay, Handled);
  end;
end;

procedure TclServerGuard.DoLockUser(const AUserName, AIP: string; APort, ATime: Integer);
begin
  if Assigned(OnLockUser) then
  begin
    OnLockUser(Self, AUserName, AIP, APort, ATime);
  end;
end;

procedure TclServerGuard.DoRemoveConnection(const AIP: string; APort, ATime: Integer);
begin
  if Assigned(OnRemoveConnection) then
  begin
    OnRemoveConnection(Self, AIP, APort, ATime);
  end;
end;

procedure TclServerGuard.DoRemoveUser(const AUserName, AIP: string; APort, ATime: Integer);
begin
  if Assigned(OnRemoveUser) then
  begin
    OnRemoveUser(Self, AUserName, AIP, APort, ATime);
  end;
end;

function TclServerGuard.GetLoginDelay(AUser: TclGuardUserInfo): Integer;
var
  range: Integer;
  handled: Boolean;
begin
  Result := 0;
  handled := False;

  DoGetDelay(AUser, Result, handled);

  if handled then
  begin
    AUser.Delay := Result;
    Exit;
  end;

  Result := 0;
  if LoginDelay.IsRandom and (LoginDelay.Min < LoginDelay.Max) then
  begin
    range := LoginDelay.Max - LoginDelay.Min;
    Result := Random(range) + LoginDelay.Min;
  end;

  if LoginDelay.IsIncremental then
  begin
    Result := Result + AUser.Delay + LoginDelay.Increment;
  end;

  AUser.Delay := Result;
end;

function TclServerGuard.GetWildcardIP(const AIP: string): string;
var
  ind: Integer;
begin
  Result := AIP;
  if (Result = '') then Exit;

  ind := RTextPos('.', AIP);
  if (ind > 0) then
  begin
    Result := Copy(Result, 1, ind - 1) + '.*';
  end;
end;

function TclServerGuard.IsBlackListed(const AIP: string; APort, ATime: Integer): Boolean;
begin
  Result := (BlackIPList.IndexOf(AIP) > -1) or (BlackIPList.IndexOf(GetWildcardIP(AIP)) > -1);
  if Result then
  begin
    DoBlockConnection(AIP, APort, ATime);
  end;
end;

function TclServerGuard.IsLockedUser(const AUserName, AIP: string; APort, ATime: Integer): Boolean;
begin
  Result := LockedUsers.IndexOf(AUserName) > -1;
  if Result then
  begin
    DoLockUser(AUserName, AIP, APort, ATime);
  end;
end;

function TclServerGuard.IsWhiteListed(const AIP: string; APort, ATime: Integer): Boolean;
begin
  Result := (WhiteIPList.IndexOf(AIP) > -1) or (WhiteIPList.IndexOf(GetWildcardIP(AIP)) > -1);
  if Result then
  begin
    DoAllowConnection(AIP, APort, ATime);
  end;
end;

function TclServerGuard.Login(const AUserName: string; AIsAuthorized: Boolean; const AIP: string; APort: Integer): Boolean;
var
  i: Integer;
  currentTime, delay: Integer;
  handled: Boolean;
  user, info: TclGuardUserInfo;
begin
  if (not EnableLoginCheck) then
  begin
    Result := AIsAuthorized;
    Exit;
  end;

  currentTime := Loword(GetTickCount());

  FAccessor.Enter();
  try
    Result := False;
    handled := False;
    DoCanLogin(AUserName, AIP, APort, currentTime, Result, handled);

    if handled then
    begin
      Exit;
    end;

    if IsBlackListed(AIP, APort, currentTime) then
    begin
      Result := False;
      Exit;
    end;

    if IsLockedUser(AUserName, AIP, APort, currentTime) then
    begin
      Result := False;
      Exit;
    end;

    user := nil;
    for i := Users.Count - 1 downto 0 do
    begin
      info := Users[i];

      if (info.UserName = AUserName) and (info.IP = AIP) then
      begin
        if AIsAuthorized then
        begin
          Users.Delete(i);
          DoRemoveUser(AUserName, AIP, APort, currentTime);
        end else
        begin
          user := info;
        end;
      end;
    end;

    if AIsAuthorized then
    begin
      Result := True;
      Exit;
    end;

    if (user = nil) then
    begin
      user := TclGuardUserInfo.Create(AUserName, AIP, APort, currentTime);
      Users.Add(user);
      DoAddUser(AUserName, AIP, APort, currentTime);
    end;
    
    delay := GetLoginDelay(user);
  finally
    FAccessor.Leave();
  end;


  if (delay > 0) then
  begin
    Sleep(delay);
  end;

  Result := AIsAuthorized;
end;

procedure TclServerGuard.Reset;
begin
  Connections.Clear();
  Users.Clear();
end;

procedure TclServerGuard.SetBlackIPList(const Value: TStrings);
begin
  FBlackIPList.Assign(Value);
end;

procedure TclServerGuard.SetConnectionLimit(const Value: TclGuardConnectionLimit);
begin
  FConnectionLimit.Assign(Value);
end;

procedure TclServerGuard.SetLockedUsers(const Value: TStrings);
begin
  FLockedUsers.Assign(Value);
end;

procedure TclServerGuard.SetLoginDelay(const Value: TclGuardLoginDelay);
begin
  FLoginDelay.Assign(Value);
end;

procedure TclServerGuard.SetWhiteIPList(const Value: TStrings);
begin
  FWhiteIPList.Assign(Value);
end;

{ TclGuardConnectionLimit }

procedure TclGuardConnectionLimit.Assign(Source: TPersistent);
var
  Src: TclGuardConnectionLimit;
begin
  if (Source is TclGuardConnectionLimit) then
  begin
    Src := (Source as TclGuardConnectionLimit);
    Max := Src.Max;
    Period := Src.Period;
  end else
  begin
    inherited Assign(Source);
  end;
end;

constructor TclGuardConnectionLimit.Create;
begin
  inherited Create();
  FMax := 6;
  FPeriod := 60000;
end;

{ TclGuardLoginDelay }

procedure TclGuardLoginDelay.Assign(Source: TPersistent);
var
  Src: TclGuardLoginDelay;
begin
  if (Source is TclGuardLoginDelay) then
  begin
    Src := (Source as TclGuardLoginDelay);

    FMin := Src.Min;
    FMax := Src.Max;
    FIncrement := Src.Increment;
    FIsIncremental := Src.IsIncremental;
    FIsRandom := Src.IsRandom;
  end else
  begin
    inherited Assign(Source);
  end;
end;

constructor TclGuardLoginDelay.Create;
begin
  inherited Create();
  FMin := 10;
  FMax := 5000;
  FIncrement := 1000;
  FIsIncremental := True;
  FIsRandom := True;
end;

{ TclGuardConnectionInfo }

constructor TclGuardConnectionInfo.Create(const AIP: string; APort, ATime: Integer);
begin
  inherited Create();

  FIP := AIP;
  FPort := APort;
  FTime := ATime;
  FAttempts := 0;
end;

function TclGuardConnectionInfo.NewAttempt: Integer;
begin
  Inc(FAttempts);
  Result := FAttempts;
end;

{ TclGuardUserInfo }

constructor TclGuardUserInfo.Create(const AUserName, AIP: string; APort, ATime: Integer);
begin
  inherited Create(AIP, APort, ATime);
  
  FUserName := AUserName;
  FDelay := 0;
end;

{ TclGuardConnectionInfoList }

procedure TclGuardConnectionInfoList.Add(AItem: TclGuardConnectionInfo);
begin
  FList.Add(AItem);
end;

procedure TclGuardConnectionInfoList.Clear;
begin
  FList.Clear();
end;

constructor TclGuardConnectionInfoList.Create;
begin
  inherited Create();
  FList := TObjectList.Create(True);
end;

procedure TclGuardConnectionInfoList.Delete(Index: Integer);
begin
  FList.Delete(Index);
end;

destructor TclGuardConnectionInfoList.Destroy;
begin
  FList.Free();
  inherited Destroy();
end;

function TclGuardConnectionInfoList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TclGuardConnectionInfoList.GetItem(Index: Integer): TclGuardConnectionInfo;
begin
  Result := TclGuardConnectionInfo(FList[Index]);
end;

{ TclGuardUserInfoList }

function TclGuardUserInfoList.GetItem(Index: Integer): TclGuardUserInfo;
begin
  Result := TclGuardUserInfo(inherited GetItem(Index));
end;

end.
