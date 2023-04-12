{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clMenuButton;

interface

{$I ..\common\clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Menus, Graphics;
{$ELSE}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Menus, Vcl.Graphics;
{$ENDIF}

type
  TclMenuButtonState = (stateNormal, statePushed, stateMenuDrop);

  TclMenuButton = class(TButton)
  private
    FArrowRect: TRect;
    FButtonRect: TRect;
    FMenu: TPopupMenu;
    FButtonState: TclMenuButtonState;
    FPrevButtonState: TclMenuButtonState;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure WMCancelMode(var Message: TWMCancelMode); message WM_CANCELMODE;
    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    procedure WMKeyDown(var Message: TWMKeyDown); message WM_KEYDOWN;
    procedure WMKeyUp(var Message: TWMKeyUp); message WM_KEYUP;
    procedure WMKillFocus(var Message: TWMSetFocus); message WM_KILLFOCUS;
    procedure WMSetFocus(var Message: TWMSetFocus); message WM_SETFOCUS;
    procedure CMChildKey(var Message: TCMChildKey); message CM_CHILDKEY;
    procedure SetButtonState(const Value: TclMenuButtonState);
    function ProcessMouseDown(Message: TWMMouse): Boolean;
    procedure DrawFocus(DC: HDC; rt: TRect);
    procedure DrawButtonText(DC: HDC; rt: TRect);
    procedure ShowMenu();
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetButtonStyle(ADefault: Boolean); override;
    property ButtonState: TclMenuButtonState read FButtonState write SetButtonState;
  public
    constructor Create(AOwner: TComponent); override;
    function AddMenuItem(const ACaption: string; AClickEvent: TNotifyEvent): TMenuItem;
  published
    property PopupMenu: TPopupMenu read FMenu;
  end;

implementation

{ TclMenuButton }

constructor TclMenuButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FMenu := TPopupMenu.Create(Self);
  FButtonState := stateNormal;
end;

procedure TclMenuButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.style := (Params.style or BS_OWNERDRAW) and not BS_PUSHBUTTON;
end;

procedure TclMenuButton.SetButtonState(const Value: TclMenuButtonState);
begin
  if(FButtonState <> Value) then
  begin
    FButtonState := Value;
    Invalidate();
  end;
end;

procedure TclMenuButton.SetButtonStyle(ADefault: Boolean);
begin
end;

procedure TclMenuButton.WMCancelMode(var Message: TWMCancelMode);
begin
  if(GetCapture() = Self.Handle) then
    if csLButtonDown in ControlState then Perform(WM_LBUTTONUP, 0,
      Integer($FFFFFFFF));
  inherited;
end;

procedure TclMenuButton.ShowMenu();
var
  p: TPoint;
  msg: TMsg;
begin
  ButtonState := stateMenuDrop;
  p.X := Self.Left;
  p.Y := Self.Top + Self.Height;
  p := Parent.ClientToScreen(p);
  FMenu.Popup(p.X, p.Y);
  while(PeekMessage(msg, Self.Handle, WM_LBUTTONDOWN, WM_LBUTTONDBLCLK, PM_REMOVE)) do
  begin
    {Nothing}
  end;
  ButtonState := stateNormal;
end;

function TclMenuButton.ProcessMouseDown(Message: TWMMouse): Boolean;
begin
  if(PtInRect(FArrowRect, Point(Message.XPos, Message.YPos))) then
  begin
    ShowMenu();
    Result := True;
  end else
  begin
    SetCapture(Self.Handle);
    ButtonState := statePushed;
    FPrevButtonState := ButtonState;
    Result := False;
  end;
end;

procedure TclMenuButton.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
  if(not ProcessMouseDown(Message)) then
  begin
    inherited;
  end;
end;

procedure TclMenuButton.WMLButtonDown(var Message: TWMLButtonDown);
begin
  if(not ProcessMouseDown(Message)) then
  begin
    inherited;
  end;
end;

procedure TclMenuButton.WMLButtonUp(var Message: TWMLButtonUp);
begin
  inherited;
  ButtonState := stateNormal;
  ReleaseCapture();
end;

procedure TclMenuButton.WMMouseMove(var Message: TWMMouseMove);
begin
  if(csLButtonDown in ControlState) and (GetCapture() = Self.Handle) then
  begin
    if(not PtInRect(ClientRect, Point(Message.XPos, Message.YPos))) then
    begin
      ButtonState := stateNormal;
    end else
    begin
      ButtonState := FPrevButtonState;
    end;
  end else inherited;
end;

procedure TclMenuButton.DrawFocus(DC: HDC; rt: TRect);
var
  PrevBkColor, PrevTextColor: TColorRef;
begin
  InflateRect(rt, -4, -4);
  PrevBkColor := SetBkColor(DC, clBlack);
  PrevTextColor := SetTextColor(DC, clWhite);
  DrawFocusRect(DC, rt);
  SetBkColor(DC, PrevBkColor);
  SetTextColor(DC, PrevTextColor);
end;

procedure TclMenuButton.DrawButtonText(DC: HDC; rt: TRect);
var
  oldFont: HGDIOBJ;
begin
  oldFont := SelectObject(DC, Font.Handle);
  SetBkMode(DC, TRANSPARENT);
//  SetTextColor(DC, Font.Color);
  OffsetRect(rt, 0, -1);
  if(ButtonState = statePushed) then
  begin
    OffsetRect(rt, 1, 1);
  end;
  DrawText(DC, PChar(Caption), -1, rt, DT_VCENTER or DT_CENTER or DT_SINGLELINE);
  SelectObject(DC, oldFont);
end;

procedure TclMenuButton.WMPaint(var Message: TWMPaint);
const
  drawFlags: array[0..1, TclMenuButtonState] of Integer =
    ((DFCS_BUTTONPUSH, DFCS_BUTTONPUSH or DFCS_PUSHED, DFCS_BUTTONPUSH),
     (DFCS_SCROLLDOWN, DFCS_SCROLLDOWN or DFCS_PUSHED, DFCS_SCROLLDOWN or DFCS_PUSHED));
var
  rt: TRect;
  ps: PAINTSTRUCT;
  DC: HDC;
begin
  DC := Message.DC;
  if (Message.DC = 0) then DC := BeginPaint(Handle, ps);
  try
    rt := FButtonRect;
    DrawFrameControl(DC, rt, DFC_BUTTON, drawFlags[0, FButtonState]);
    DrawButtonText(DC, rt);
    if(Focused and (ButtonState <> stateMenuDrop)) then
    begin
      DrawFocus(DC, rt);
    end;
    rt := FArrowRect;
    if(ButtonState = stateNormal) then
    begin
      rt.Top := rt.Top - 1;
    end;
    DrawFrameControl(DC, rt, DFC_SCROLL, drawFlags[1, FButtonState]);
  finally
    if (Message.DC = 0) then EndPaint(Handle, ps);
  end;
end;

procedure TclMenuButton.WMSize(var Message: TWMSize);
begin
  inherited;
  FArrowRect.Left := Self.ClientWidth - GetSystemMetrics(SM_CXVSCROLL);
  FArrowRect.Top := 0;
  FArrowRect.Right := Self.ClientWidth;
  FArrowRect.Bottom := Self.ClientHeight;
  SubtractRect(FButtonRect, ClientRect, FArrowRect);
end;

procedure TclMenuButton.WMKeyDown(var Message: TWMKeyDown);
begin
  case Message.CharCode of
    VK_SPACE: ButtonState := statePushed;
  end;
  inherited;
end;

procedure TclMenuButton.WMKeyUp(var Message: TWMKeyUp);
begin
  ButtonState := stateNormal;
  inherited;
end;

procedure TclMenuButton.WMKillFocus(var Message: TWMSetFocus);
begin
  if(ButtonState <> stateNormal) then
  begin
    ButtonState := stateNormal;
  end else
  begin
    Invalidate();
  end;
end;

procedure TclMenuButton.WMSetFocus(var Message: TWMSetFocus);
begin
  Invalidate();
end;

procedure TclMenuButton.CMChildKey(var Message: TCMChildKey);
begin
  if(Message.CharCode = VK_DOWN) and ((GetKeyState(VK_CONTROL) and $80000000) <> 0) then
  begin
    Message.Result := 1;
    ShowMenu();
  end;
end;

function TclMenuButton.AddMenuItem(const ACaption: string; AClickEvent: TNotifyEvent): TMenuItem;
begin
  Result := TMenuItem.Create(Self);
  PopupMenu.Items.Add(Result);
  Result.Caption := ACaption;
  Result.OnClick := AClickEvent;
end;

end.
