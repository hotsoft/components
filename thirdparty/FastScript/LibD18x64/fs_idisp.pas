
{******************************************}
{                                          }
{             FastScript v1.9              }
{           OLE dispatch module            }
{                                          }
{  (c) 2003-2007 by Alexander Tzyganenko,  }
{             Fast Reports Inc             }
{                                          }
{******************************************}

unit fs_idisp;

interface

{$I fs.inc}

uses
  Windows, Classes, SysUtils, ActiveX, ComObj, fs_iinterpreter
{$IFDEF Delphi6}
, Variants
{$ENDIF};


type
  TfsOLEHelper = class(TfsCustomHelper)
  private
    function DispatchInvoke(const ParamArray: Variant; ParamCount: Integer;
      Flags: Word): Variant;
  protected
    procedure SetValue(const Value: Variant); override;
    function GetValue: Variant; override;
  public
    constructor Create(const AName: String);
  end;


implementation


constructor TfsOLEHelper.Create(const AName: String);
begin
  inherited Create(AName, fvtVariant, '');
end;

function TfsOLEHelper.DispatchInvoke(const ParamArray: Variant; ParamCount: Integer;
  Flags: Word): Variant;
const
  DispIDArgs: Longint = DISPID_PROPERTYPUT;
var
  DispId: TDispId;
  Params: TDISPPARAMS;
  pName: WideString;
  ExcepMess: WideString;
  Args: array[0..63] of Variant;
  i: Integer;
  PResult: PVariant;
  Status: Integer;
  ExcepInfo: TExcepInfo;
begin
  ExcepMess := '';
  pName := WideString(Name);
  IDispatch(ParentValue).GetIDsOfNames(GUID_NULL, @pName, 1, GetThreadLocale, @DispId);

  for i := 0 to ParamCount - 1 do
    Args[i] := ParamArray[ParamCount - i - 1];

  Params.rgvarg := @Args;
  Params.rgdispidNamedArgs := nil;
  Params.cArgs := ParamCount;
  Params.cNamedArgs := 0;
  if Flags = DISPATCH_PROPERTYPUT then
  begin
    Params.rgdispidNamedArgs := @DispIDArgs;
    Params.cNamedArgs := 1;
  end;

  if NeedResult and (Flags <> DISPATCH_PROPERTYPUT) then
    PResult := @Result else
    PResult := nil;
  if PResult <> nil then
    VarClear(PResult^);
  if (Flags = DISPATCH_METHOD) {and (ParamCount = 0)} and (PResult <> nil) then
    Flags := DISPATCH_METHOD or DISPATCH_PROPERTYGET;

  Status := IDispatch(ParentValue).Invoke(DispId, GUID_NULL, 0,
    Flags, Params, PResult, @ExcepInfo, nil);
  if Status <> 0 then
  begin
    if ExcepInfo.bstrSource <> '' then
      ExcepMess := #13+#10 + 'Source        ::  '+ ExcepInfo.bstrSource;
    if ExcepInfo.bstrDescription <> '' then
      ExcepMess := ExcepMess + #13#10 + 'Description ::  '+ ExcepInfo.bstrDescription;
    if ExcepInfo.bstrHelpFile <> '' then
      ExcepMess := ExcepMess + #13#10 + 'Help File     ::  '+ ExcepInfo.bstrHelpFile;
{$IFDEF Delphi12}
    raise Exception.Create('OLE error ' + IntToHex(Status, 8) + ': ' +
      String(Name) + ': ' + SysErrorMessage(Status) + ExcepMess);
{$ELSE}
    raise Exception.Create('OLE error ' + IntToHex(Status, 8) + ': ' +
      Name + ': ' + SysErrorMessage(Status) + ExcepMess);
{$ENDIF}
  end;
end;

procedure TfsOLEHelper.SetValue(const Value: Variant);
var
  i: Integer;
  v: Variant;
begin
  v := VarArrayCreate([0, Count], varVariant);
  for i := 0 to Count - 1 do
    v[i] := Params[i].Value;
  v[Count] := Value;

  DispatchInvoke(v, Count + 1, DISPATCH_PROPERTYPUT);
end;

function TfsOLEHelper.GetValue: Variant;
var
  i: Integer;
  v: Variant;
begin
  v := VarArrayCreate([0, Count - 1], varVariant);
  for i := 0 to Count - 1 do
    v[i] := Params[i].Value;

  Result := DispatchInvoke(v, Count, DISPATCH_METHOD);
end;

end.
