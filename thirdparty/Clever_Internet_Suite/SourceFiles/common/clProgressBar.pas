{
  Clever Internet Suite
  Copyright (C) 2013 Clever Components
  All Rights Reserved
  www.CleverComponents.com
}

unit clProgressBar;

interface

{$I clVer.inc}

uses
{$IFNDEF DELPHIXE2}
  Classes, SysUtils, Types, Windows, Graphics, Controls,
  {$IFDEF DELPHI7}Themes, UxTheme, {$ENDIF}{$IFDEF DEMO}Forms,{$ENDIF}
{$ELSE}
  System.Classes, System.SysUtils, System.Types, Winapi.Windows, Vcl.Graphics, Vcl.Controls,
  Vcl.Themes, Winapi.UxTheme, {$IFDEF DEMO}Vcl.Forms,{$ENDIF}
{$ENDIF}
  clResourceState;

{$IFNDEF DELPHI2007}
const
  {$EXTERNALSYM PP_FILL}
  PP_FILL     = 5;
  {$EXTERNALSYM PP_FILLVERT}
  PP_FILLVERT     = 6;

  {$EXTERNALSYM PBFS_NORMAL}
  PBFS_NORMAL     = 1;
  {$EXTERNALSYM PBFS_ERROR}
  PBFS_ERROR     = 2;
  {$EXTERNALSYM PBFS_PAUSED}
  PBFS_PAUSED     = 3;
  {$EXTERNALSYM PBFS_PARTIAL}
  PBFS_PARTIAL     = 4;

  {$EXTERNALSYM PBFVS_NORMAL}
  PBFVS_NORMAL     = 1;
  {$EXTERNALSYM PBFVS_ERROR}
  PBFVS_ERROR     = 2;
  {$EXTERNALSYM PBFVS_PAUSED}
  PBFVS_PAUSED     = 3;
  {$EXTERNALSYM PBFVS_PARTIAL}
  PBFVS_PARTIAL     = 4;

  {$EXTERNALSYM PP_TRANSPARENTBAR}
  PP_TRANSPARENTBAR     = 11;
  {$EXTERNALSYM PP_TRANSPARENTBARVERT}
  PP_TRANSPARENTBARVERT     = 12;

  {$EXTERNALSYM PBBS_PARTIAL}
  PBBS_PARTIAL     = 2;

  {$EXTERNALSYM PBBVS_PARTIAL}
  PBBVS_PARTIAL     = 2;

  {$EXTERNALSYM PP_PULSEOVERLAY}
  PP_PULSEOVERLAY     = 7;
  
  {$EXTERNALSYM PP_PULSEOVERLAYVERT}
  PP_PULSEOVERLAYVERT     = 9;
{$ENDIF}

type
  TclDrawPaintOption = (dpDrawTotal, dpDrawItems);
  TclDrawPaintOptions = set of TclDrawPaintOption;

  TclDrawOrientation = (doHorisontal, doVertical);

  TclDrawStyle = (ds3D, dsFlat);

  TclBorderStyle = (bsNone, bsFrame);

  TclStatusColor = array[TclProcessStatus] of TColor;

  TclThemedStatusState = array[TclProcessStatus] of Integer;

  TclDrawScheme = (dsCustom,
    dsWindowsXP_1, dsWindowsXP_2, dsWindowsXP_3,
    dsWindowsTheme_1, dsWindowsThemeVert_1, dsWindowsTheme_2, dsWindowsThemeVert_2,
    dsWindowsThemeXP, dsWindowsThemeXPVert);

  TclProgressBarItemType = (gitFrame, gitBackGround, gitProcessTotal, gitProcessItem);

  TclProgressBarCustomDraw = procedure (Sender: TObject; AItemType: TclProgressBarItemType;
    ACanvas: TCanvas; ARect: TRect; AColor: TColor; var Handled: Boolean) of object;
  TclProgressBarPaint = procedure (Sender: TObject; var AState: TclResourceStateList) of object;

  TclProgressBar = class;
  TclDrawColors = class;

  TclStatusColors = class(TPersistent)
  private
    FOwner: TclDrawColors;
    FStatusColor: TclStatusColor;

    function GetStatusColor(const Index: Integer): TColor;
    procedure SetStatusColor(const Index: Integer; const Value: TColor);
  public
    constructor Create(AOwner: TclDrawColors);

    procedure Assign(Source: TPersistent); override;
    procedure Init(AStatusColor: TclStatusColor); virtual;
    function StatusColor(AStatus: TclProcessStatus): TColor;
  published
    property StatusUnknown: TColor index psUnknown read GetStatusColor write SetStatusColor;
    property StatusSuccess: TColor index psSuccess read GetStatusColor write SetStatusColor;
    property StatusFailed: TColor index psFailed read GetStatusColor write SetStatusColor;
    property StatusErrors: TColor index psErrors read GetStatusColor write SetStatusColor;
    property StatusProcess: TColor index psProcess read GetStatusColor write SetStatusColor;
    property StatusTerminated: TColor index psTerminated read GetStatusColor write SetStatusColor;
  end;

  TclThemedDrawStyles = class;

  TclThemedStatusStates = class(TPersistent)
  private
    FOwner: TclThemedDrawStyles;
    FStatusState: TclThemedStatusState;

    function GetStatusState(const Index: Integer): Integer;
    procedure SetStatusState(const Index, Value: Integer);
  public
    constructor Create(AOwner: TclThemedDrawStyles);

    procedure Assign(Source: TPersistent); override;
    procedure Init(AStatusState: TclThemedStatusState); virtual;
    function StatusState(AStatus: TclProcessStatus): Integer;
  published
    property StatusUnknown: Integer index psUnknown read GetStatusState write SetStatusState;
    property StatusSuccess: Integer index psSuccess read GetStatusState write SetStatusState;
    property StatusFailed: Integer index psFailed read GetStatusState write SetStatusState;
    property StatusErrors: Integer index psErrors read GetStatusState write SetStatusState;
    property StatusProcess: Integer index psProcess read GetStatusState write SetStatusState;
    property StatusTerminated: Integer index psTerminated read GetStatusState write SetStatusState;
  end;

  TclDrawColors = class(TPersistent)
  private
    FOwner: TclProgressBar;

    FBackGround: TColor;
    FFrame: TColor;
    FItemColors: TclStatusColors;
    FTotalColors: TclStatusColors;

    procedure SetBackGround(const Value: TColor);
    procedure SetFrame(const Value: TColor);
    procedure SetItemColors(const Value: TclStatusColors);
    procedure SetTotalColors(const Value: TclStatusColors);

    function ColorsStored(AColor1, AColor2: TclStatusColor): Boolean;
    function ItemColorsStored: Boolean;
    function TotalColorsStored: Boolean;
    function BackGroundStored: Boolean;
    function FrameStored: Boolean;
  protected
    procedure Changed(); virtual;
  public
    constructor Create(AOwner: TclProgressBar);
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure Init(ADrawScheme: TclDrawScheme); virtual;
  published
    property BackGround: TColor read FBackGround write SetBackGround stored BackGroundStored;
    property Frame: TColor read FFrame write SetFrame stored FrameStored;
    property ItemColors: TclStatusColors read FItemColors write SetItemColors stored ItemColorsStored;
    property TotalColors: TclStatusColors read FTotalColors write SetTotalColors stored TotalColorsStored;
  end;

  TclThemedDrawStyles = class(TPersistent)
  private
    FOwner: TclProgressBar;

    FBar: Integer;
    FTotalStates: TclThemedStatusStates;
    FItemStates: TclThemedStatusStates;
    FBarState: Integer;
    FPulseOverlay: Integer;
    FMoveOverlay: Integer;
    FTotal: Integer;
    FItem: Integer;

    procedure SetBar(const Value: Integer);
    procedure SetBarState(const Value: Integer);
    procedure SetItemStates(const Value: TclThemedStatusStates);
    procedure SetTotalStates(const Value: TclThemedStatusStates);
    procedure SetMoveOverlay(const Value: Integer);
    procedure SetPulseOverlay(const Value: Integer);
    procedure SetItem(const Value: Integer);
    procedure SetTotal(const Value: Integer);

{$IFDEF DELPHI7}    
    function StatesStored(AState1, AState2: TclThemedStatusState): Boolean;
{$ENDIF}
    function ItemStatesStored: Boolean;
    function TotalStatesStored: Boolean;
    function BarStored: Boolean;
    function BarStateStored: Boolean;
    function MoveOverlayStored: Boolean;
    function PulseOverlayStored: Boolean;
    function ItemStored: Boolean;
    function TotalStored: Boolean;
  protected
    procedure Changed(); virtual;
  public
    constructor Create(AOwner: TclProgressBar);
    destructor Destroy; override;

    procedure Assign(Source: TPersistent); override;
    procedure Init(ADrawScheme: TclDrawScheme); virtual;
  published
    property Bar: Integer read FBar write SetBar stored BarStored;
    property BarState: Integer read FBarState write SetBarState stored BarStateStored;

    property Item: Integer read FItem write SetItem stored ItemStored;
    property ItemStates: TclThemedStatusStates read FItemStates write SetItemStates stored ItemStatesStored;

    property Total: Integer read FTotal write SetTotal stored TotalStored;
    property TotalStates: TclThemedStatusStates read FTotalStates write SetTotalStates stored TotalStatesStored;

    property MoveOverlay: Integer read FMoveOverlay write SetMoveOverlay stored MoveOverlayStored;
    property PulseOverlay: Integer read FPulseOverlay write SetPulseOverlay stored PulseOverlayStored;
  end;

  TclProgressBar = class(TGraphicControl)
  private
    FDrawScheme: TclDrawScheme;
    FOptions: TclDrawPaintOptions;
    FOrientation: TclDrawOrientation;

    FColors: TclDrawColors;
    FThemedStyles: TclThemedDrawStyles;

    FProgressSplit: Integer;
    FStyle: TclDrawStyle;
    FBorderStyle: TclBorderStyle;
    FSelfResourceState: TclResourceStateList;

    FOnChanged: TNotifyEvent;
    FOnCustomDraw: TclProgressBarCustomDraw;
    FOnPaint: TclProgressBarPaint;
    FUseWindowsThemes: Boolean;

    procedure DrawBackGround(ACanvas: TCanvas; ARect: TRect);
    procedure DrawFrame(ACanvas: TCanvas; ARect: TRect);
    procedure DrawProgressItems(AState: TclResourceStateList; ACanvas: TCanvas; ARect: TRect);
    procedure DrawTotalProgress(AState: TclResourceStateList; ACanvas: TCanvas; ARect: TRect);
    procedure DrawProgressItem(AState: TclResourceStateList; AItem: TclResourceStateItem;
      ACanvas: TCanvas; ARect: TRect);
    procedure PaintRect(ACanvas: TCanvas; ARect: TRect; AColor: TColor);
{$IFDEF DELPHI7}
    procedure PaintThemedRect(ACanvas: TCanvas; ARect: TRect;
      APart, AState, AMoveOverlay, APulseOverlay: Integer);
{$ENDIF}
    function GetShadowColor(ABaseColor: TColor; AOffset: Integer): TColor;
    function GetProgressPixels(AProgress, ATotal: Int64; APixelRange: Integer): Integer;
    procedure PaintHorisontalRect(ACanvas: TCanvas; ARect: TRect; AColor: TColor);
    procedure PaintVerticalRect(ACanvas: TCanvas; ARect: TRect; AColor: TColor);

    procedure DoOnResourceStateChanged(Sender: TObject);

    procedure SetProgressSplit(const Value: Integer);
    procedure SetOptions(const Value: TclDrawPaintOptions);
    procedure SetOrientation(const Value: TclDrawOrientation);
    procedure SetStyle(const Value: TclDrawStyle);
    procedure SetColors(const Value: TclDrawColors);
    procedure SetThemedStyles(const Value: TclThemedDrawStyles);
    procedure SetBorderStyle(const Value: TclBorderStyle);
    procedure SetDrawScheme(const Value: TclDrawScheme);
    procedure SetUseWindowsThemes(const Value: Boolean);

    procedure InitByDrawScheme;
    procedure SetCustomDrawScheme;
    function StyleStored: Boolean;
    function BorderStyleStored: Boolean;
    function ProgressSplitStored: Boolean;
  protected
    function GetResourceState: TclResourceStateList; virtual;
    function CreateResourceState: TclResourceStateList; virtual;
    procedure NotifyChanged; virtual;
    procedure Changed; virtual;
    procedure DoPaint(var AState: TclResourceStateList); virtual;
    procedure CustomDraw(AItemType: TclProgressBarItemType;
      ACanvas: TCanvas; ARect: TRect; AColor: TColor; var Handled: Boolean); virtual;
    procedure UpdateDrawSchemeOrientation(const AOrientation: TclDrawOrientation); virtual;
    function GetDefaultDrawScheme: TclDrawScheme; virtual;

    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy(); override;

    procedure Draw(AState: TclResourceStateList; ACanvas: TCanvas; ARect: TRect);

    property ResourceState: TclResourceStateList read GetResourceState;
  published
    property Options: TclDrawPaintOptions read FOptions write SetOptions default [dpDrawTotal, dpDrawItems];
    property Orientation: TclDrawOrientation read FOrientation write SetOrientation default doHorisontal;

    property UseWindowsThemes: Boolean read FUseWindowsThemes write SetUseWindowsThemes default True;
    property DrawScheme: TclDrawScheme read FDrawScheme write SetDrawScheme default dsWindowsTheme_1;
    property Style: TclDrawStyle read FStyle write SetStyle stored StyleStored;
    property BorderStyle: TclBorderStyle read FBorderStyle write SetBorderStyle stored BorderStyleStored;
    property ProgressSplit: Integer read FProgressSplit write SetProgressSplit stored ProgressSplitStored;
    property Colors: TclDrawColors read FColors write SetColors;
    property ThemedStyles: TclThemedDrawStyles read FThemedStyles write SetThemedStyles;

    property Align;
    property Visible;

    property OnChanged: TNotifyEvent read FOnChanged write FOnChanged;
    property OnCustomDraw: TclProgressBarCustomDraw read FOnCustomDraw write FOnCustomDraw;
    property OnPaint: TclProgressBarPaint read FOnPaint write FOnPaint;
  end;

implementation

const
  BackGroundColorSchemes: array[TclDrawScheme] of TColor = (
    0,
    clWhite,
    clCream,
    TColor($E55500),
    clWindow,
    clWindow,
    clWindow,
    clWindow,
    clWindow,
    clWindow
  );
  FrameColorSchemes: array[TclDrawScheme] of TColor = (
    0,
    clBlue,
    clSkyBlue,
    TColor($298514),
    0,
    0,
    0,
    0,
    0,
    0
  );
  ItemColorSchemes: array[TclDrawScheme] of TclStatusColor = (
    (0, 0, 0, 0, 0, 0),
    (clBlue, clBlue, clRed, clYellow, clBlue, clBlue),
    (clSkyBlue, clSkyBlue, clLtGray, clLtGray, clSkyBlue, clSkyBlue),
    (TColor($298514), TColor($298514), TColor($170DD6), TColor($0BC5F4), TColor($298514), TColor($298514)),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0)
  );
  TotalColorSchemes: array[TclDrawScheme] of TclStatusColor = (
    (0, 0, 0, 0, 0, 0),
    (clGreen, clGreen, clRed, clYellow, clGreen, clGreen),
    (clSkyBlue, clSkyBlue, clLtGray, clLtGray, clSkyBlue, clSkyBlue),
    (TColor($296514), TColor($296514), TColor($170DD6), TColor($0BC5F4), TColor($296514), TColor($296514)),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0)
  );

  DrawStyleSchemes: array[TclDrawScheme] of TclDrawStyle = (
    ds3D,
    ds3D,
    ds3D,
    ds3D,
    ds3D,
    ds3D,
    ds3D,
    ds3D,
    ds3D,
    ds3D
  );

  BorderStyleSchemes: array[TclDrawScheme] of TclBorderStyle = (
    bsFrame,
    bsFrame,
    bsFrame,
    bsFrame,
    bsFrame,
    bsFrame,
    bsFrame,
    bsFrame,
    bsNone,
    bsNone
  );

  ProgressSplitSchemes: array[TclDrawScheme] of Integer = (
    25,
    25,
    25,
    25,
    80,
    80,
    80,
    80,
    80,
    80
  );

  UseWindowsThemesSchemes: array[TclDrawScheme] of Boolean = (
    False,
    False,
    False,
    False,
    True,
    True,
    True,
    True,
    True,
    True
  );

{$IFDEF DELPHI7}
  ItemThemedPartSchemes: array[TclDrawScheme] of Integer = (
    0,
    0,
    0,
    0,
    PP_FILL,
    PP_FILLVERT,
    PP_CHUNK,
    PP_CHUNKVERT,
    PP_CHUNK,
    PP_CHUNKVERT
  );
  ItemThemedStateSchemes: array[TclDrawScheme] of TclThemedStatusState = (
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (PBFS_PARTIAL, PBFS_NORMAL, PBFS_ERROR, PBFS_PAUSED, PBFS_PARTIAL, PBFS_PARTIAL),
    (PBFVS_PARTIAL, PBFVS_NORMAL, PBFVS_ERROR, PBFVS_PAUSED, PBFVS_PARTIAL, PBFVS_PARTIAL),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0)
  );

  TotalThemedPartSchemes: array[TclDrawScheme] of Integer = (
    0,
    0,
    0,
    0,
    PP_FILL,
    PP_FILLVERT,
    PP_CHUNK,
    PP_CHUNKVERT,
    PP_CHUNK,
    PP_CHUNKVERT
  );
  TotalThemedStateSchemes: array[TclDrawScheme] of TclThemedStatusState = (
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (PBFS_NORMAL, PBFS_NORMAL, PBFS_ERROR, PBFS_PAUSED, PBFS_NORMAL, PBFS_NORMAL),
    (PBFVS_NORMAL, PBFVS_NORMAL, PBFVS_ERROR, PBFVS_PAUSED, PBFVS_NORMAL, PBFVS_NORMAL),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0)
  );

  BarThemedPartSchemes: array[TclDrawScheme] of Integer = (
    0,
    0,
    0,
    0,
    PP_TRANSPARENTBAR,
    PP_TRANSPARENTBARVERT,
    PP_TRANSPARENTBAR,
    PP_TRANSPARENTBARVERT,
    0,
    0
  );
  BarThemedStateSchemes: array[TclDrawScheme] of Integer = (
    0,
    0,
    0,
    0,
    PBBS_PARTIAL,
    PBBVS_PARTIAL,
    PBBS_PARTIAL,
    PBBVS_PARTIAL,
    0,
    0
  );

  MoveOverlayThemedSchemes: array[TclDrawScheme] of Integer = (
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  );

  PulseOverlayThemedSchemes: array[TclDrawScheme] of Integer = (
    0,
    0,
    0,
    0,
    PP_PULSEOVERLAY,
    PP_PULSEOVERLAYVERT,
    PP_PULSEOVERLAY,
    PP_PULSEOVERLAYVERT,
    0,
    0
  );
{$ENDIF}

{ TclProgressBar }

procedure TclProgressBar.DrawBackGround(ACanvas: TCanvas; ARect: TRect);
var
  Handled: Boolean;
  R: TRect;
begin
  R := ARect;
  Handled := False;
  CustomDraw(gitBackGround, ACanvas, R, Colors.BackGround, Handled);
  if not Handled then
  begin
{$IFDEF DELPHI7}
    if (UseWindowsThemes) then
    begin
      if (BorderStyle = bsNone) then
      begin
        ACanvas.Brush.Color := Colors.BackGround;
        ACanvas.FillRect(R);
      end;
    end else
{$ENDIF}
    begin
      ACanvas.Brush.Color := Colors.BackGround;
      ACanvas.FillRect(R);
    end;
  end;
end;

procedure TclProgressBar.DrawFrame(ACanvas: TCanvas; ARect: TRect);
var
  Handled: Boolean;
  R: TRect;
begin
  R := ARect;
  Handled := False;
  CustomDraw(gitFrame, ACanvas, R, Colors.Frame, Handled);
  if not Handled then
  begin
{$IFDEF DELPHI7}
    if (UseWindowsThemes) then
    begin
      if (Parent <> nil) and (IsThemeBackgroundPartiallyTransparent({$IFDEF DELPHIXE2}StyleServices(){$ELSE}ThemeServices(){$ENDIF}.Theme[teProgress],
        ThemedStyles.Bar, ThemedStyles.BarState)) then
      begin
        DrawThemeParentBackground(Parent.Handle, ACanvas.Handle, nil);
      end;

      DrawThemeBackground({$IFDEF DELPHIXE2}StyleServices(){$ELSE}ThemeServices(){$ENDIF}.Theme[teProgress], ACanvas.Handle, ThemedStyles.Bar, ThemedStyles.BarState, R, nil);
    end else
    begin
{$ENDIF}
      ACanvas.Brush.Color := Colors.Frame;
      ACanvas.FrameRect(R);
{$IFDEF DELPHI7}
    end;
{$ENDIF}
  end;
end;

function TclProgressBar.GetShadowColor(ABaseColor: TColor; AOffset: Integer): TColor;
  function GetCorrectValue(AValue, AOffset: Integer): Integer;
  begin
    Result := AValue;
    if ((Result + AOffset) > -1) and ((Result + AOffset) < 256) then
    begin
      Result := AValue + AOffset;
    end;
  end;

begin
  if (ABaseColor and (not $FFFFFF)) > 0 then
  begin
    Result := ABaseColor;
  end else
  begin
    Result := RGB(
      GetCorrectValue(GetRValue(ABaseColor), AOffset),
      GetCorrectValue(GetGValue(ABaseColor), AOffset),
      GetCorrectValue(GetBValue(ABaseColor), AOffset));
  end;
end;

procedure TclProgressBar.PaintRect(ACanvas: TCanvas; ARect: TRect; AColor: TColor);
begin
  if Orientation = doHorisontal then
  begin
    PaintHorisontalRect(ACanvas, ARect, AColor);
  end else
  begin
    PaintVerticalRect(ACanvas, ARect, AColor);
  end;
end;

{$IFDEF DELPHI7}
procedure TclProgressBar.PaintThemedRect(ACanvas: TCanvas; ARect: TRect;
  APart, AState, AMoveOverlay, APulseOverlay: Integer);
var
  R: TRect;
begin
  R := ARect;
  if (Orientation = doHorisontal) and ({$IFDEF DELPHIXE2}R.Width{$ELSE}R.Right - R.Left{$ENDIF} > 0) and (APart <> 0) then
  begin
    InflateRect(R, 1, 0);
  end else
  if (Orientation = doVertical) and ({$IFDEF DELPHIXE2}R.Height{$ELSE}R.Bottom - R.Top{$ENDIF} > 0) and (APart <> 0) then
  begin
    InflateRect(R, 0, 1);
  end;

  DrawThemeBackground({$IFDEF DELPHIXE2}StyleServices(){$ELSE}ThemeServices(){$ENDIF}.Theme[teProgress], ACanvas.Handle, APart, AState, R, nil);

  if (AMoveOverlay > 0) then
  begin
    DrawThemeBackground({$IFDEF DELPHIXE2}StyleServices(){$ELSE}ThemeServices(){$ENDIF}.Theme[teProgress], ACanvas.Handle, AMoveOverlay, 0, R, nil);
  end;

  if (APulseOverlay > 0) then
  begin
    DrawThemeBackground({$IFDEF DELPHIXE2}StyleServices(){$ELSE}ThemeServices(){$ENDIF}.Theme[teProgress], ACanvas.Handle, APulseOverlay, 0, R, nil);
  end;
end;
{$ENDIF}

procedure TclProgressBar.PaintHorisontalRect(ACanvas: TCanvas; ARect: TRect; AColor: TColor);
var
  R: TRect;
begin
  if (Style = ds3D) and ((ARect.Bottom - ARect.Top) > 2) then
  begin
    R := ARect;
    R.Bottom := R.Top + 2;
    ACanvas.Brush.Color := GetShadowColor(AColor, 30);
    ACanvas.FillRect(R);
    OffsetRect(R, 0, 2);
    ACanvas.Brush.Color := GetShadowColor(AColor, 10);
    ACanvas.FillRect(R);
    R := ARect;
    R.Top := R.Bottom - 2;
    ACanvas.Brush.Color := GetShadowColor(AColor, -30);
    ACanvas.FillRect(R);
    OffsetRect(R, 0, - 2);
    ACanvas.Brush.Color := GetShadowColor(AColor, -10);
    ACanvas.FillRect(R);
    R := ARect;
    InflateRect(R, 0, - 4);
  end else
  begin
    R := ARect;
  end;
  ACanvas.Brush.Color := AColor;
  ACanvas.FillRect(R);
end;

procedure TclProgressBar.PaintVerticalRect(ACanvas: TCanvas; ARect: TRect; AColor: TColor);
var
  R: TRect;
begin
  if (Style = ds3D) and ((ARect.Right - ARect.Left) > 2) then
  begin
    R := ARect;
    R.Right := R.Left + 2;
    ACanvas.Brush.Color := GetShadowColor(AColor, 30);
    ACanvas.FillRect(R);
    OffsetRect(R, 2, 0);
    ACanvas.Brush.Color := GetShadowColor(AColor, 10);
    ACanvas.FillRect(R);
    R := ARect;
    R.Left := R.Right - 2;
    ACanvas.Brush.Color := GetShadowColor(AColor, -30);
    ACanvas.FillRect(R);
    OffsetRect(R, - 2, 0);
    ACanvas.Brush.Color := GetShadowColor(AColor, -10);
    ACanvas.FillRect(R);
    R := ARect;
    InflateRect(R, - 4, 0);
  end else
  begin
    R := ARect;
  end;
  ACanvas.Brush.Color := AColor;
  ACanvas.FillRect(R);
end;

function TclProgressBar.ProgressSplitStored: Boolean;
begin
  Result := (FProgressSplit <> ProgressSplitSchemes[DrawScheme]);
end;

function TclProgressBar.GetDefaultDrawScheme: TclDrawScheme;
begin
  Result := dsWindowsTheme_1;
end;

function TclProgressBar.GetProgressPixels(AProgress, ATotal: Int64; APixelRange: Integer): Integer;
begin
  Result := Round((AProgress / ATotal) * APixelRange);
end;

function TclProgressBar.GetResourceState: TclResourceStateList;
begin
  if (FSelfResourceState = nil) then
  begin
    FSelfResourceState := CreateResourceState();
  end;
  Result := FSelfResourceState;
end;

procedure TclProgressBar.DrawTotalProgress(AState: TclResourceStateList; ACanvas: TCanvas; ARect: TRect);
var
  old: Integer;
  R: TRect;
  Handled: Boolean;
begin
  R := ARect;
  if (Orientation = doHorisontal) then
  begin
    old := R.Right;
    R.Right := R.Left + GetProgressPixels(AState.BytesProceed, AState.ResourceSize, ARect.Right - ARect.Left);
    if (R.Right <> R.Left) and (R.Right <> old) then
    begin
      R.Right := R.Right + 1;
    end;
  end else
  begin
    old := R.Top;
    R.Top := R.Bottom - GetProgressPixels(AState.BytesProceed, AState.ResourceSize, ARect.Bottom - ARect.Top);
    if (R.Top <> R.Bottom) and (R.Top <> old) then
    begin
      R.Top := R.Top - 1;
    end;
  end;

  Handled := False;
  CustomDraw(gitProcessTotal, ACanvas, R, Colors.TotalColors.StatusColor(AState.LastStatus), Handled);

  if not Handled then
  begin
{$IFDEF DELPHI7}
    if (UseWindowsThemes) then
    begin
      PaintThemedRect(ACanvas, R, ThemedStyles.Total, ThemedStyles.TotalStates.StatusState(AState.LastStatus),
        ThemedStyles.MoveOverlay, ThemedStyles.PulseOverlay);
    end else
    begin
{$ENDIF}
      PaintRect(ACanvas, R, Colors.TotalColors.StatusColor(AState.LastStatus));
{$IFDEF DELPHI7}
    end;
{$ENDIF}
  end;
end;

procedure TclProgressBar.DrawProgressItem(AState: TclResourceStateList; AItem: TclResourceStateItem;
  ACanvas: TCanvas; ARect: TRect);
var
  old: Integer;
  R: TRect;
  Handled: Boolean;
begin
  R := ARect;
  if (Orientation = doHorisontal) then
  begin
    R.Left := R.Left + GetProgressPixels(AItem.ResourcePos, AState.ResourceSize, ARect.Right - ARect.Left);
    old := R.Right;
    R.Right := R.Left + GetProgressPixels(AItem.BytesProceed, AState.ResourceSize, ARect.Right - ARect.Left);
    if (R.Right <> R.Left) and (R.Right <> old) then
    begin
      R.Right := R.Right + 1;
    end;
  end else
  begin
    R.Bottom := R.Bottom - GetProgressPixels(AItem.ResourcePos, AState.ResourceSize, ARect.Bottom - ARect.Top);
    old := R.Top;
    R.Top := R.Bottom - GetProgressPixels(AItem.BytesProceed, AState.ResourceSize, ARect.Bottom - ARect.Top);
    if (R.Top <> R.Bottom) and (R.Top <> old) then
    begin
      R.Top := R.Top - 1;
    end;
  end;

  Handled := False;
  CustomDraw(gitProcessTotal, ACanvas, R, Colors.ItemColors.StatusColor(AItem.Status), Handled);

  if not Handled then
  begin
{$IFDEF DELPHI7}
    if (UseWindowsThemes) then
    begin
      PaintThemedRect(ACanvas, R, ThemedStyles.Item, ThemedStyles.ItemStates.StatusState(AItem.Status),
        ThemedStyles.MoveOverlay, ThemedStyles.PulseOverlay);
    end else
    begin
{$ENDIF}
      PaintRect(ACanvas, R, Colors.ItemColors.StatusColor(AItem.Status));
{$IFDEF DELPHI7}
    end;
{$ENDIF}
  end;
end;

procedure TclProgressBar.DrawProgressItems(AState: TclResourceStateList; ACanvas: TCanvas; ARect: TRect);
var
  i: Integer;
begin
  for i := 0 to AState.Count - 1 do
  begin
    DrawProgressItem(AState, AState[i], ACanvas, ARect);
  end;
end;

procedure TclProgressBar.Draw(AState: TclResourceStateList; ACanvas: TCanvas; ARect: TRect);
var
  R, RatedRect: TRect;
  BackBmp: TBitmap;
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
  BackBmp := TBitmap.Create();
  try
    RatedRect := ARect;
    OffsetRect(RatedRect, -RatedRect.Left, -RatedRect.Top);
    BackBmp.Handle := CreateCompatibleBitmap(ACanvas.Handle, RatedRect.Right, RatedRect.Bottom);
    if (BorderStyle = bsFrame) then
    begin
      DrawFrame(BackBmp.Canvas, RatedRect);
      InflateRect(RatedRect, -1, -1);
    end;
    DrawBackGround(BackBmp.Canvas, RatedRect);
    if (AState <> nil) and (AState.ResourceSize > 0) then
    begin
      R := RatedRect;
      if (dpDrawItems in Options) then
      begin
        if (Orientation = doHorisontal) then
        begin
          R.Bottom := R.Bottom - GetProgressPixels(100 - FProgressSplit, 100, RatedRect.Bottom);
        end else
        begin
          R.Right := R.Right - GetProgressPixels(100 - FProgressSplit, 100, RatedRect.Right);
        end;
      end;
      if (dpDrawTotal in Options) then
      begin
        DrawTotalProgress(AState, BackBmp.Canvas, R);
      end;
      if (dpDrawTotal in Options) then
      begin
        if (Orientation = doHorisontal) then
        begin
          R.Top := R.Bottom;
          R.Bottom := RatedRect.Bottom;
        end else
        begin
          R.Left := R.Right;
          R.Right := RatedRect.Right;
        end;
      end else
      begin
        R := RatedRect;
      end;
      if (dpDrawItems in Options) then
      begin
        DrawProgressItems(AState, BackBmp.Canvas, R);
      end;
    end;
    ACanvas.Draw(ARect.Left, ARect.Top, BackBmp);
  finally
    BackBmp.Free();
  end;
end;

constructor TclProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FColors := TclDrawColors.Create(Self);
  FThemedStyles := TclThemedDrawStyles.Create(Self);

  FOptions := [dpDrawTotal, dpDrawItems];
  FOrientation := doHorisontal;
  FSelfResourceState := nil;
  Width := 150;
  Height := GetSystemMetrics(SM_CYVSCROLL);

  FUseWindowsThemes := True;
  FDrawScheme := GetDefaultDrawScheme();
  InitByDrawScheme();
end;

function TclProgressBar.CreateResourceState: TclResourceStateList;
begin
  Result :=  TclResourceStateList.Create();
  Result.OnChanged := DoOnResourceStateChanged;
end;

procedure TclProgressBar.SetColors(const Value: TclDrawColors);
begin
  FColors.Assign(Value);
end;

procedure TclProgressBar.SetDrawScheme(const Value: TclDrawScheme);
begin
  if (FDrawScheme <> Value) and (Value <> dsCustom) then
  begin
    FDrawScheme := Value;
    InitByDrawScheme();
    Changed();
  end;
end;

procedure TclProgressBar.InitByDrawScheme;
begin
  FStyle := DrawStyleSchemes[DrawScheme];
  FBorderStyle := BorderStyleSchemes[DrawScheme];
  FProgressSplit := ProgressSplitSchemes[DrawScheme];

  if (DrawScheme <> dsCustom) then
  begin
    FUseWindowsThemes := UseWindowsThemesSchemes[DrawScheme];
  end;

  Colors.Init(DrawScheme);
  ThemedStyles.Init(DrawScheme);

  NotifyChanged();
end;

procedure TclProgressBar.SetCustomDrawScheme;
begin
  FDrawScheme := dsCustom;
end;

destructor TclProgressBar.Destroy();
begin
  FreeAndNil(FSelfResourceState);
  FThemedStyles.Free();
  FColors.Free();

  inherited Destroy();
end;

procedure TclProgressBar.SetProgressSplit(const Value: Integer);
begin
  if (FProgressSplit <> Value)
    and (Value >= 0) and (Value <= 100) then
  begin
    FProgressSplit := Value;
    SetCustomDrawScheme();
    NotifyChanged();
  end;
end;

function TclProgressBar.BorderStyleStored: Boolean;
begin
  Result := (FBorderStyle <> BorderStyleSchemes[DrawScheme]);
end;

procedure TclProgressBar.Changed;
begin
  if Assigned(FOnChanged) then
  begin
    FOnChanged(Self);
  end;
end;

procedure TclProgressBar.SetOptions(const Value: TclDrawPaintOptions);
begin
  if (FOptions <> Value) then
  begin
    FOptions := Value;
    NotifyChanged();
  end;
end;

procedure TclProgressBar.UpdateDrawSchemeOrientation(const AOrientation: TclDrawOrientation);
begin
  if (DrawScheme = dsWindowsTheme_1) and (AOrientation = doVertical) then
  begin
    DrawScheme := dsWindowsThemeVert_1;
  end else
  if (DrawScheme = dsWindowsTheme_2) and (AOrientation = doVertical) then
  begin
    DrawScheme := dsWindowsThemeVert_2;
  end else
  if (DrawScheme = dsWindowsThemeXP) and (AOrientation = doVertical) then
  begin
    DrawScheme := dsWindowsThemeXPVert;
  end else
  if (DrawScheme = dsWindowsThemeVert_1) and (AOrientation = doHorisontal) then
  begin
    DrawScheme := dsWindowsTheme_1;
  end else
  if (DrawScheme = dsWindowsThemeVert_2) and (AOrientation = doHorisontal) then
  begin
    DrawScheme := dsWindowsTheme_2;
  end else
  if (DrawScheme = dsWindowsThemeXPVert) and (AOrientation = doHorisontal) then
  begin
    DrawScheme := dsWindowsThemeXP;
  end;
end;

procedure TclProgressBar.SetOrientation(const Value: TclDrawOrientation);
begin
  if (FOrientation <> Value) then
  begin
    FOrientation := Value;
    UpdateDrawSchemeOrientation(FOrientation);
    NotifyChanged();
  end;
end;

procedure TclProgressBar.CustomDraw(AItemType: TclProgressBarItemType;
  ACanvas: TCanvas; ARect: TRect; AColor: TColor; var Handled: Boolean);
begin
  if Assigned(FOnCustomDraw) then
  begin
    FOnCustomDraw(Self, AItemType, ACanvas, ARect, AColor, Handled);
  end;
end;

procedure TclProgressBar.Paint();
var
  state: TclResourceStateList;
begin
  if not (csLoading in ComponentState)
    and (Visible or (csDesigning in ComponentState))
    and (Parent <> nil) and Parent.HandleAllocated then
  begin
    state := nil;
    DoPaint(state);
    if (state = nil) then
    begin
      state := ResourceState;
    end;
    Draw(state, Canvas, GetClientRect());
  end;
end;

procedure TclProgressBar.NotifyChanged;
begin
  Paint();
  Changed();
end;

procedure TclProgressBar.SetStyle(const Value: TclDrawStyle);
begin
  if (FStyle <> Value) then
  begin
    FStyle := Value;
    SetCustomDrawScheme();
    NotifyChanged();
  end;
end;

procedure TclProgressBar.SetThemedStyles(const Value: TclThemedDrawStyles);
begin
  FThemedStyles.Assign(Value);
end;

procedure TclProgressBar.SetUseWindowsThemes(const Value: Boolean);
begin
{$IFDEF DELPHI7}
  if (FUseWindowsThemes <> Value) then
  begin
    FUseWindowsThemes := Value;

    if (FUseWindowsThemes) then
    begin
      if ({$IFDEF DELPHIXE2}StyleServices().Available{$ELSE}ThemeServices().ThemesAvailable{$ENDIF}) then
      begin
        DrawScheme := GetDefaultDrawScheme();
      end else
      begin
        FUseWindowsThemes := False;
      end;
    end else
    begin
      DrawScheme := dsWindowsXP_1;
    end;

    NotifyChanged();
  end;
{$ELSE}
  FUseWindowsThemes := False;
{$ENDIF}
end;

function TclProgressBar.StyleStored: Boolean;
begin
  Result := (FStyle <> DrawStyleSchemes[DrawScheme]);
end;

procedure TclProgressBar.SetBorderStyle(const Value: TclBorderStyle);
begin
  if (FBorderStyle <> Value) then
  begin
    FBorderStyle := Value;
    SetCustomDrawScheme();
    NotifyChanged();
  end;
end;

procedure TclProgressBar.DoOnResourceStateChanged(Sender: TObject);
begin
  NotifyChanged();
end;

procedure TclProgressBar.DoPaint(var AState: TclResourceStateList);
begin
  if Assigned(OnPaint) then
  begin
    OnPaint(Self, AState);
  end;
end;

{ TclDrawColors }

procedure TclDrawColors.Assign(Source: TPersistent);
var
  Src: TclDrawColors;
begin
  if (Source is TclDrawColors) then
  begin
    Src := (Source as TclDrawColors);
    FFrame := Src.Frame;
    FBackGround := Src.BackGround;
    FTotalColors.Assign(Src.TotalColors);
    FItemColors.Assign(Src.ItemColors);
    Changed();
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclDrawColors.Changed;
begin
  FOwner.SetCustomDrawScheme();
  FOwner.NotifyChanged();
end;

constructor TclDrawColors.Create(AOwner: TclProgressBar);
begin
  inherited Create();

  FTotalColors := TclStatusColors.Create(Self);
  FItemColors := TclStatusColors.Create(Self);
  FOwner := AOwner;
  Assert(FOwner <> nil);
end;

procedure TclDrawColors.SetBackGround(const Value: TColor);
begin
  if (FBackGround <> Value) then
  begin
    FBackGround := Value;
    Changed();
  end;
end;

procedure TclDrawColors.SetFrame(const Value: TColor);
begin
  if (FFrame <> Value) then
  begin
    FFrame := Value;
    Changed();
  end;
end;

procedure TclDrawColors.SetItemColors(const Value: TclStatusColors);
begin
  FItemColors.Assign(Value);
end;

procedure TclDrawColors.SetTotalColors(const Value: TclStatusColors);
begin
  FTotalColors.Assign(Value);
end;

destructor TclDrawColors.Destroy;
begin
  FItemColors.Free();
  FTotalColors.Free();

  inherited Destroy();
end;

function TclDrawColors.ColorsStored(AColor1, AColor2: TclStatusColor): Boolean;
var
  i: TclProcessStatus;
begin
  for i := Low(TclStatusColor) to High(TclStatusColor) do
  begin
    Result := (AColor1[i] <> AColor2[i]);
    if Result then Exit;
  end;
  Result := False;
end;

procedure TclDrawColors.Init(ADrawScheme: TclDrawScheme);
begin
  FFrame := FrameColorSchemes[ADrawScheme];
  FBackGround := BackGroundColorSchemes[ADrawScheme];
  FItemColors.Init(ItemColorSchemes[ADrawScheme]);
  FTotalColors.Init(TotalColorSchemes[ADrawScheme]);
end;

function TclDrawColors.ItemColorsStored: Boolean;
begin
  Result := ColorsStored(ItemColors.FStatusColor, ItemColorSchemes[FOwner.DrawScheme]);
end;

function TclDrawColors.TotalColorsStored: Boolean;
begin
  Result := ColorsStored(TotalColors.FStatusColor, TotalColorSchemes[FOwner.DrawScheme]);
end;

function TclDrawColors.BackGroundStored: Boolean;
begin
  Result := (FBackGround <> BackGroundColorSchemes[FOwner.DrawScheme]);
end;

function TclDrawColors.FrameStored: Boolean;
begin
  Result := (FFrame <> FrameColorSchemes[FOwner.DrawScheme]);
end;

{ TclStatusColors }

function TclStatusColors.StatusColor(AStatus: TclProcessStatus): TColor;
begin
  Result := FStatusColor[AStatus];
end;

procedure TclStatusColors.Assign(Source: TPersistent);
begin
  if (Source is TclStatusColors) then
  begin
    FStatusColor := (Source as TclStatusColors).FStatusColor;
    FOwner.Changed();
  end else
  begin
    inherited Assign(Source);
  end;
end;

constructor TclStatusColors.Create(AOwner: TclDrawColors);
begin
  inherited Create();

  FOwner := AOwner;
  Assert(FOwner <> nil);
end;

function TclStatusColors.GetStatusColor(const Index: Integer): TColor;
begin
  Result := FStatusColor[TclProcessStatus(Index)];
end;

procedure TclStatusColors.Init(AStatusColor: TclStatusColor);
begin
  FStatusColor := AStatusColor;
end;

procedure TclStatusColors.SetStatusColor(const Index: Integer; const Value: TColor);
begin
  if (FStatusColor[TclProcessStatus(Index)] <> Value) then
  begin
    FStatusColor[TclProcessStatus(Index)] := Value;
    FOwner.Changed();
  end;
end;

{ TclThemedStatusStates }

function TclThemedStatusStates.StatusState(AStatus: TclProcessStatus): Integer;
begin
  Result := FStatusState[AStatus];
end;

procedure TclThemedStatusStates.Assign(Source: TPersistent);
begin
  if (Source is TclThemedStatusStates) then
  begin
    FStatusState := (Source as TclThemedStatusStates).FStatusState;
    FOwner.Changed();
  end else
  begin
    inherited Assign(Source);
  end;
end;

constructor TclThemedStatusStates.Create(AOwner: TclThemedDrawStyles);
begin
  inherited Create();

  FOwner := AOwner;
  Assert(FOwner <> nil);
end;

function TclThemedStatusStates.GetStatusState(const Index: Integer): Integer;
begin
  Result := FStatusState[TclProcessStatus(Index)];
end;

procedure TclThemedStatusStates.Init(AStatusState: TclThemedStatusState);
begin
  FStatusState := AStatusState;
end;

procedure TclThemedStatusStates.SetStatusState(const Index, Value: Integer);
begin
  if (FStatusState[TclProcessStatus(Index)] <> Value) then
  begin
    FStatusState[TclProcessStatus(Index)] := Value;
    FOwner.Changed();
  end;
end;

{ TclThemedDrawStyles }

procedure TclThemedDrawStyles.Assign(Source: TPersistent);
var
  Src: TclThemedDrawStyles;
begin
  if (Source is TclThemedDrawStyles) then
  begin
    Src := (Source as TclThemedDrawStyles);

    FBar := Src.Bar;
    FBarState := Src.BarState;

    FItem := Src.Item;
    FItemStates.Assign(Src.ItemStates);

    FTotal := Src.Total;
    FTotalStates.Assign(Src.TotalStates);

    FMoveOverlay := Src.MoveOverlay;
    FPulseOverlay := Src.PulseOverlay;

    Changed();
  end else
  begin
    inherited Assign(Source);
  end;
end;

procedure TclThemedDrawStyles.Changed;
begin
  FOwner.SetCustomDrawScheme();
  FOwner.NotifyChanged();
end;

constructor TclThemedDrawStyles.Create(AOwner: TclProgressBar);
begin
  inherited Create();

  FTotalStates := TclThemedStatusStates.Create(Self);
  FItemStates := TclThemedStatusStates.Create(Self);
  FOwner := AOwner;
  Assert(FOwner <> nil);
end;

destructor TclThemedDrawStyles.Destroy;
begin
  FItemStates.Free();
  FTotalStates.Free();

  inherited Destroy();
end;

function TclThemedDrawStyles.BarStateStored: Boolean;
begin
{$IFDEF DELPHI7}
  Result := (FBarState <> BarThemedStateSchemes[FOwner.DrawScheme]);
{$ELSE}
  Result := False;
{$ENDIF}
end;

function TclThemedDrawStyles.BarStored: Boolean;
begin
{$IFDEF DELPHI7}
  Result := (FBar <> BarThemedPartSchemes[FOwner.DrawScheme]);
{$ELSE}
  Result := False;
{$ENDIF}
end;

procedure TclThemedDrawStyles.Init(ADrawScheme: TclDrawScheme);
begin
{$IFDEF DELPHI7}
  FBar := BarThemedPartSchemes[ADrawScheme];
  FBarState := BarThemedStateSchemes[ADrawScheme];

  FItem := ItemThemedPartSchemes[ADrawScheme];
  FItemStates.Init(ItemThemedStateSchemes[ADrawScheme]);

  FTotal := TotalThemedPartSchemes[ADrawScheme];
  FTotalStates.Init(TotalThemedStateSchemes[ADrawScheme]);

  FMoveOverlay := MoveOverlayThemedSchemes[ADrawScheme];
  FPulseOverlay := PulseOverlayThemedSchemes[ADrawScheme];
{$ENDIF}
end;

function TclThemedDrawStyles.MoveOverlayStored: Boolean;
begin
{$IFDEF DELPHI7}
  Result := (FMoveOverlay <> MoveOverlayThemedSchemes[FOwner.DrawScheme]);
{$ELSE}
  Result := False;
{$ENDIF}
end;

function TclThemedDrawStyles.PulseOverlayStored: Boolean;
begin
{$IFDEF DELPHI7}
  Result := (FPulseOverlay <> PulseOverlayThemedSchemes[FOwner.DrawScheme]);
{$ELSE}
  Result := False;
{$ENDIF}
end;

function TclThemedDrawStyles.ItemStatesStored: Boolean;
begin
{$IFDEF DELPHI7}
  Result := StatesStored(ItemStates.FStatusState, ItemThemedStateSchemes[FOwner.DrawScheme]);
{$ELSE}
  Result := False;
{$ENDIF}
end;

function TclThemedDrawStyles.ItemStored: Boolean;
begin
{$IFDEF DELPHI7}
  Result := (FItem <> ItemThemedPartSchemes[FOwner.DrawScheme]);
{$ELSE}
  Result := False;
{$ENDIF}
end;

procedure TclThemedDrawStyles.SetBar(const Value: Integer);
begin
  if (FBar <> Value) then
  begin
    FBar := Value;
    Changed();
  end;
end;

procedure TclThemedDrawStyles.SetBarState(const Value: Integer);
begin
  if (FBarState <> Value) then
  begin
    FBarState := Value;
    Changed();
  end;
end;

procedure TclThemedDrawStyles.SetMoveOverlay(const Value: Integer);
begin
  if (FMoveOverlay <> Value) then
  begin
    FMoveOverlay := Value;
    Changed();
  end;
end;

procedure TclThemedDrawStyles.SetPulseOverlay(const Value: Integer);
begin
  if (FPulseOverlay <> Value) then
  begin
    FPulseOverlay := Value;
    Changed();
  end;
end;

procedure TclThemedDrawStyles.SetItem(const Value: Integer);
begin
  if (FItem <> Value) then
  begin
    FItem := Value;
    Changed();
  end;
end;

procedure TclThemedDrawStyles.SetItemStates(const Value: TclThemedStatusStates);
begin
  FItemStates.Assign(Value);
end;

procedure TclThemedDrawStyles.SetTotal(const Value: Integer);
begin
  if (FTotal <> Value) then
  begin
    FTotal := Value;
    Changed();
  end;
end;

procedure TclThemedDrawStyles.SetTotalStates(const Value: TclThemedStatusStates);
begin
  FTotalStates.Assign(Value);
end;

{$IFDEF DELPHI7}    
function TclThemedDrawStyles.StatesStored(AState1, AState2: TclThemedStatusState): Boolean;
var
  i: TclProcessStatus;
begin
  for i := Low(TclThemedStatusState) to High(TclThemedStatusState) do
  begin
    Result := (AState1[i] <> AState2[i]);
    if Result then Exit;
  end;
  Result := False;
end;
{$ENDIF}

function TclThemedDrawStyles.TotalStatesStored: Boolean;
begin
{$IFDEF DELPHI7}
  Result := StatesStored(TotalStates.FStatusState, TotalThemedStateSchemes[FOwner.DrawScheme]);
{$ELSE}
  Result := False;
{$ENDIF}
end;

function TclThemedDrawStyles.TotalStored: Boolean;
begin
{$IFDEF DELPHI7}
  Result := (FTotal <> TotalThemedPartSchemes[FOwner.DrawScheme]);
{$ELSE}
  Result := False;
{$ENDIF}
end;

end.
