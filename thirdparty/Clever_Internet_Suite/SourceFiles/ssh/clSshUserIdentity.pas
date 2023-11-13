{
  Clever Internet Suite
  Copyright (C) 2017 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clSshUserIdentity;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes,
{$ELSE}
  System.Classes,
{$ENDIF}
  clSshUserKey, clUtils;

type
  TclSshUserIdentity = class
  public
    function GetUserName: string; virtual; abstract;
    function GetPassword: string; virtual; abstract;
    function GetUserKey: TclSshUserKey; virtual; abstract;

    procedure ShowBanner(const AMessage, ALanguage: string); virtual; abstract;
  end;

implementation

end.
