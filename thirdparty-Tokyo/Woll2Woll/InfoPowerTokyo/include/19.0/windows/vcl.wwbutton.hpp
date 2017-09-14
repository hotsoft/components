// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwbutton.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwbuttonHPP
#define Vcl_WwbuttonHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Winapi.CommCtrl.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Dialogs.hpp>
#include <System.Math.hpp>
#include <Vcl.Consts.hpp>
#include <System.SysUtils.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.Wwbitmap.hpp>
#include <vcl.wwchangelink.hpp>
#include <System.TypInfo.hpp>
#include <Vcl.DBCtrls.hpp>
#include <Data.DB.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Themes.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.ImgList.hpp>
#include <Vcl.ActnList.hpp>
#include <System.Variants.hpp>
#include <vcl.wwframe.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.wwtext.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwbutton
{
//-- forward type declarations -----------------------------------------------
struct TwwRegionData;
class DELPHICLASS TwwOffsets;
class DELPHICLASS TwwShadeColors;
class DELPHICLASS TwwCustomBitBtn;
class DELPHICLASS TwwButton;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwDitherStyle : unsigned char { wwdsDither, wwdsBlendDither, wwdsFill };

enum DECLSPEC_DENUM TwwShadeStyle : unsigned char { wwbsNormal, wwbsRaised, wwbsHighlight, wwbsFlat };

enum DECLSPEC_DENUM TwwButtonShape : unsigned char { wwbsRoundRect, wwbsEllipse, wwbsTriangle, wwbsArrow, wwbsDiamond, wwbsRect, wwbsStar, wwbsTrapezoid, wwbsCustom, wwbsSystemStyle };

enum DECLSPEC_DENUM TwwShapeOrientation : unsigned char { wwsoLeft, wwsoRight, wwsoUp, wwsoDown };

typedef System::StaticArray<System::Types::TPoint, 21> TwwPolyGonPoints;

typedef TwwPolyGonPoints *PwwPolyGonPoints;

enum DECLSPEC_DENUM TwwButtonOption : unsigned char { boFocusable, boOverrideActionGlyph, boToggleOnUp, boFocusRect, boAutoBold };

typedef System::Set<TwwButtonOption, TwwButtonOption::boFocusable, TwwButtonOption::boAutoBold> TwwButtonOptions;

typedef System::TMetaClass* TwwCustomBitBtnClass;

typedef void __fastcall (__closure *TwwButtonGetCaptionEvent)(System::TObject* Sender, System::UnicodeString &ACaption);

struct DECLSPEC_DRECORD TwwRegionData
{
public:
	int dwSize;
	_RGNDATA *rgnData;
};


typedef TwwRegionData *PwwRegionData;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwOffsets : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	Vcl::Controls::TWinControl* FControl;
	int FGlyphX;
	int FGlyphY;
	int FTextX;
	int FTextY;
	int FTextDownX;
	int FTextDownY;
	void __fastcall SetGlyphX(int Value);
	void __fastcall SetGlyphY(int Value);
	void __fastcall SetTextX(int Value);
	void __fastcall SetTextY(int Value);
	
protected:
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	__property Vcl::Controls::TWinControl* Control = {read=FControl};
	
public:
	__fastcall TwwOffsets(TwwCustomBitBtn* Button);
	
__published:
	__property int GlyphX = {read=FGlyphX, write=SetGlyphX, default=0};
	__property int GlyphY = {read=FGlyphY, write=SetGlyphY, default=0};
	__property int TextX = {read=FTextX, write=SetTextX, default=0};
	__property int TextY = {read=FTextY, write=SetTextY, default=0};
	__property int TextDownX = {read=FTextDownX, write=FTextDownX, default=1};
	__property int TextDownY = {read=FTextDownY, write=FTextDownY, default=1};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwOffsets(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwShadeColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TwwCustomBitBtn* FButton;
	System::Uitypes::TColor FBtnHighlight;
	System::Uitypes::TColor FBtn3dLight;
	System::Uitypes::TColor FBtnShadow;
	System::Uitypes::TColor FBtnBlack;
	System::Uitypes::TColor FBtnFocus;
	System::Uitypes::TColor FShadow;
	void __fastcall SetBtn3DLight(System::Uitypes::TColor Value);
	void __fastcall SetBtnBlack(System::Uitypes::TColor Value);
	void __fastcall SetBtnHighlight(System::Uitypes::TColor Value);
	void __fastcall SetBtnShadow(System::Uitypes::TColor Value);
	void __fastcall SetBtnFocus(System::Uitypes::TColor Value);
	void __fastcall SetShadow(System::Uitypes::TColor Value);
	
protected:
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	
public:
	__fastcall TwwShadeColors(TwwCustomBitBtn* Button);
	
__published:
	__property System::Uitypes::TColor Btn3DLight = {read=FBtn3dLight, write=SetBtn3DLight, default=-16777194};
	__property System::Uitypes::TColor BtnHighlight = {read=FBtnHighlight, write=SetBtnHighlight, default=-16777196};
	__property System::Uitypes::TColor BtnShadow = {read=FBtnShadow, write=SetBtnShadow, default=-16777200};
	__property System::Uitypes::TColor BtnBlack = {read=FBtnBlack, write=SetBtnBlack, default=0};
	__property System::Uitypes::TColor BtnFocus = {read=FBtnFocus, write=SetBtnFocus, default=0};
	__property System::Uitypes::TColor Shadow = {read=FShadow, write=SetShadow, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwShadeColors(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwCustomBitBtn : public Vcl::Controls::TWinControl
{
	typedef Vcl::Controls::TWinControl inherited;
	
private:
	System::Classes::TStringList* FPointList;
	bool FActive;
	bool FAllowAllUp;
	bool FCancel;
	bool FDefault;
	bool FDown;
	Vcl::Graphics::TBitmap* FGlyph;
	int FGroupIndex;
	bool FInMouseSendForMouseActivate;
	Vcl::Buttons::TBitBtnKind FKind;
	Vcl::Buttons::TButtonLayout FLayout;
	int FMargin;
	System::Uitypes::TModalResult FModalResult;
	Vcl::Buttons::TNumGlyphs FNumGlyphs;
	HRGN FRegion;
	HRGN FLastRegion;
	TwwShadeColors* FShadeColors;
	TwwShadeStyle FShadeStyle;
	bool FShowFocusRect;
	int FSpacing;
	Vcl::Buttons::TButtonStyle FStyle;
	Vcl::Wwtext::TwwCaptionText* FTextOptions;
	bool FSmoothFont;
	TwwButtonGetCaptionEvent FOnGetCaption;
	System::Types::TRect FGlyphRect;
	System::Types::TRect FTextRect;
	System::Classes::TNotifyEvent FOnMouseEnter;
	System::Classes::TNotifyEvent FOnMouseLeave;
	System::Classes::TNotifyEvent FOnSelChange;
	System::Classes::TNotifyEvent FOnSetName;
	Vcl::Graphics::TCanvas* FCanvas;
	TwwOffsets* FOffsets;
	bool FModifiedGlyph;
	TwwButtonOptions FOptions;
	System::Classes::TList* FChangeLinks;
	Vcl::Wwchangelink::TwwChangeLink* FChangeLink;
	bool FClicked;
	bool FInitialDown;
	System::Classes::TStringList* FEvents;
	bool FUseHalftonePalette;
	bool FShowDownAsUp;
	bool FHot;
	Vcl::Dbctrls::TFieldDataLink* FDataLink;
	bool FDisableThemes;
	bool FStaticCaption;
	TwwButtonShape FShape;
	TwwShapeOrientation FOrientation;
	System::Uitypes::TColor FDitherColor;
	TwwDitherStyle FDitherStyle;
	int FRoundRectBias;
	void __fastcall SetOrientation(TwwShapeOrientation Value);
	void __fastcall SetPointList(System::Classes::TStringList* Value);
	void __fastcall SetRoundRectBias(int Value);
	void __fastcall SetDitherColor(System::Uitypes::TColor Value);
	void __fastcall SetDitherStyle(TwwDitherStyle Value);
	void __fastcall SetShape(TwwButtonShape Value);
	Vcl::Buttons::TBitBtnKind __fastcall GetKind(void);
	void __fastcall SetAllowAllUp(bool Value);
	void __fastcall SetButtonDown(bool Value, bool CheckAllowAllUp, bool DoUpdateExclusive, bool DoInvalidate);
	void __fastcall SetDefault(bool Value);
	void __fastcall SetDown(bool Value);
	void __fastcall SetGlyph(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetGroupIndex(int Value);
	void __fastcall SetKind(Vcl::Buttons::TBitBtnKind Value);
	void __fastcall SetLayout(Vcl::Buttons::TButtonLayout Value);
	void __fastcall SetMargin(int Value);
	void __fastcall SetNumGlyphs(Vcl::Buttons::TNumGlyphs Value);
	void __fastcall SetOptions(TwwButtonOptions Value);
	void __fastcall SetSpacing(int Value);
	void __fastcall SetShadeStyle(TwwShadeStyle Value);
	void __fastcall SetStyle(Vcl::Buttons::TButtonStyle Value);
	HIDESBASE MESSAGE void __fastcall WMCancelMode(Winapi::Messages::TWMNoParams &Message);
	MESSAGE void __fastcall CMGetDataLink(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMDialogKey(Winapi::Messages::TWMKey &Message);
	MESSAGE void __fastcall CMButtonPressed(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMDialogChar(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall CMEnabledChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMFocusChanged(Vcl::Controls::TCMFocusChanged &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CNDrawItem(Winapi::Messages::TWMDrawItem &Message);
	MESSAGE void __fastcall CNMeasureItem(Winapi::Messages::TWMMeasureItem &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseActivate(Winapi::Messages::TWMMouseActivate &Message);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	void __fastcall ProcessMouseUp(int X, int Y, bool AMouseInControl, bool AClicked);
	void __fastcall ProcessMouseDown(void);
	System::UnicodeString __fastcall GetDataField(void);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	void __fastcall SetDataField(const System::UnicodeString Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	virtual void __fastcall DoComputeCanvasAttributes(Vcl::Graphics::TCanvas* ACanvas);
	
protected:
	TwwRegionData FDownRegionData;
	TwwRegionData FRegionData;
	bool FSelected;
	bool DisableButton;
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	void __fastcall SetPointToOrientation(PwwPolyGonPoints Points, int NumPoints, TwwShapeOrientation Orientation, const System::Types::TSize &Size);
	int __fastcall GetCustomPoints(PwwPolyGonPoints &Points, const System::Types::TSize &Size);
	int __fastcall GetStarPoints(PwwPolyGonPoints &Points, const System::Types::TSize &Size);
	System::Uitypes::TColor __fastcall CorrectedColor(void);
	System::Uitypes::TColor __fastcall UnusableColor(void);
	virtual bool __fastcall RoundShape(void);
	Data::Db::TField* __fastcall GetField(void);
	virtual System::UnicodeString __fastcall GetDBCaption(void);
	DYNAMIC HPALETTE __fastcall GetPalette(void);
	DYNAMIC void __fastcall ActionChange(System::TObject* Sender, bool CheckDefaults);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DestroyWnd(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall Loaded(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall SetName(const System::Classes::TComponentName Value);
	void __fastcall GetEvents(const System::UnicodeString s);
	virtual TwwOffsets* __fastcall CreateOffsets(void);
	virtual HRGN __fastcall CreateRegion(bool DoImplementation, bool Down);
	virtual System::Types::TRect __fastcall CalcButtonLayout(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &Client, System::Types::TRect &TextRect, System::Types::TRect &GlyphRect, const System::Types::TSize &TextSize);
	virtual int __fastcall GlyphWidth(void);
	virtual bool __fastcall IsCustom(void);
	virtual bool __fastcall IsCustomCaption(void);
	bool __fastcall MouseInControl(int X, int Y, bool AndClicked);
	virtual bool __fastcall StoreRegionData(void);
	virtual void __fastcall ChangeButtonDown(void);
	virtual void __fastcall CleanUp(void);
	virtual void __fastcall ClearRegion(PwwRegionData ARgnData);
	virtual void __fastcall DrawButtonGlyph(Vcl::Graphics::TCanvas* Canvas, const System::Types::TPoint &GlyphPos);
	virtual void __fastcall DrawButtonText(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &TextBounds);
	virtual void __fastcall DrawItem(const tagDRAWITEMSTRUCT &DrawItemStruct);
	virtual void __fastcall GetDrawBitmap(Vcl::Wwbitmap::TwwBitmap* DrawBitmap, bool ForRegion, TwwShadeStyle ShadeStyle, bool Down, bool InPaint = false)/* overload */;
	virtual void __fastcall GlyphChanged(System::TObject* Sender);
	virtual void __fastcall NotifyChange(void);
	virtual void __fastcall NotifyChanging(void);
	virtual void __fastcall NotifyLoaded(void);
	virtual void __fastcall Paint(void);
	virtual void __fastcall Redraw(void);
	virtual void __fastcall ReadRegionData(System::Classes::TStream* Stream);
	virtual void __fastcall ReadDownRegionData(System::Classes::TStream* Stream);
	virtual void __fastcall SaveRegion(unsigned NewRegion, bool Down);
	virtual void __fastcall SelChange(void);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	virtual void __fastcall WriteRegionData(System::Classes::TStream* Stream);
	virtual void __fastcall WriteDownRegionData(System::Classes::TStream* Stream);
	virtual void __fastcall UpdateExclusive(void);
	virtual bool __fastcall UseRegions(void);
	__property bool Active = {read=FActive, nodefault};
	__property Vcl::Graphics::TCanvas* Canvas = {read=FCanvas};
	__property System::Types::TRect GlyphRect = {read=FGlyphRect};
	__property System::Types::TRect TextRect = {read=FTextRect};
	__property bool InitalDown = {read=FInitialDown, nodefault};
	__property bool Clicked = {read=FClicked, nodefault};
	virtual void __fastcall DataChange(System::TObject* Sender);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Draw3dLines(Vcl::Wwbitmap::TwwBitmap* Bitmap, System::Types::TPoint *PointList, const int PointList_High, int NumPoints, System::Uitypes::TColor TransColor, Vcl::Wwbitmap::TwwBitmap* PaintBitmap = (Vcl::Wwbitmap::TwwBitmap*)(0x0))/* overload */;
	virtual void __fastcall Draw3DLines(Vcl::Wwbitmap::TwwBitmap* SrcBitmap, Vcl::Wwbitmap::TwwBitmap* DstBitmap, System::Uitypes::TColor TransColor, bool Down)/* overload */;
	int __fastcall GetPolygonPoints(PwwPolyGonPoints &Points);
	
public:
	System::Variant BasePatch;
	__property HRGN Region = {read=FRegion, nodefault};
	__fastcall virtual TwwCustomBitBtn(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwCustomBitBtn(void);
	virtual void __fastcall ApplyRegion(void);
	virtual void __fastcall InvalidateNotRegion(const bool Erase);
	virtual System::Types::TRect __fastcall Draw(Vcl::Graphics::TCanvas* Canvas);
	virtual bool __fastcall IsMultipleRegions(void);
	DYNAMIC void __fastcall Click(void);
	virtual void __fastcall SizeToDefault(void);
	virtual void __fastcall UpdateShadeColors(System::Uitypes::TColor Color);
	virtual void __fastcall RegisterChanges(Vcl::Wwchangelink::TwwChangeLink* Value);
	virtual void __fastcall UnRegisterChanges(Vcl::Wwchangelink::TwwChangeLink* Value);
	virtual bool __fastcall GetTextEnabled(void);
	virtual void __fastcall AdjustBounds(void);
	__property System::Classes::TStringList* PointList = {read=FPointList, write=SetPointList};
	__property TwwShapeOrientation Orientation = {read=FOrientation, write=SetOrientation, default=2};
	__property int RoundRectBias = {read=FRoundRectBias, write=SetRoundRectBias, default=0};
	__property TwwButtonShape Shape = {read=FShape, write=SetShape, default=9};
	__property bool ShowDownAsUp = {read=FShowDownAsUp, write=FShowDownAsUp, default=0};
	__property System::Uitypes::TColor DitherColor = {read=FDitherColor, write=SetDitherColor, nodefault};
	__property TwwDitherStyle DitherStyle = {read=FDitherStyle, write=SetDitherStyle, nodefault};
	__property bool StaticCaption = {read=FStaticCaption, write=FStaticCaption, default=0};
	__property bool AllowAllUp = {read=FAllowAllUp, write=SetAllowAllUp, default=0};
	__property bool Cancel = {read=FCancel, write=FCancel, default=0};
	__property Caption = {stored=IsCustomCaption, default=0};
	__property Color = {default=-16777211};
	__property bool Default = {read=FDefault, write=SetDefault, default=0};
	__property bool Down = {read=FDown, write=SetDown, default=0};
	__property Font;
	__property TwwOffsets* Offsets = {read=FOffsets, write=FOffsets};
	__property Vcl::Graphics::TBitmap* Glyph = {read=FGlyph, write=SetGlyph, stored=IsCustom};
	__property int GroupIndex = {read=FGroupIndex, write=SetGroupIndex, default=0};
	__property Vcl::Buttons::TBitBtnKind Kind = {read=GetKind, write=SetKind, default=0};
	__property Vcl::Buttons::TButtonLayout Layout = {read=FLayout, write=SetLayout, default=0};
	__property int Margin = {read=FMargin, write=SetMargin, default=-1};
	__property System::Uitypes::TModalResult ModalResult = {read=FModalResult, write=FModalResult, default=0};
	__property Vcl::Buttons::TNumGlyphs NumGlyphs = {read=FNumGlyphs, write=SetNumGlyphs, stored=IsCustom, default=1};
	__property TwwButtonOptions Options = {read=FOptions, write=SetOptions, default=0};
	__property bool Selected = {read=FSelected, nodefault};
	__property TwwShadeColors* ShadeColors = {read=FShadeColors, write=FShadeColors};
	__property TwwShadeStyle ShadeStyle = {read=FShadeStyle, write=SetShadeStyle, nodefault};
	__property bool SmoothFont = {read=FSmoothFont, write=FSmoothFont, default=0};
	__property Vcl::Buttons::TButtonStyle Style = {read=FStyle, write=SetStyle, default=0};
	__property int Spacing = {read=FSpacing, write=SetSpacing, default=4};
	__property TabStop = {default=0};
	__property Vcl::Wwtext::TwwCaptionText* TextOptions = {read=FTextOptions, write=FTextOptions};
	__property OnClick;
	__property System::Classes::TNotifyEvent OnMouseEnter = {read=FOnMouseEnter, write=FOnMouseEnter};
	__property System::Classes::TNotifyEvent OnMouseLeave = {read=FOnMouseLeave, write=FOnMouseLeave};
	__property System::Classes::TNotifyEvent OnSelChange = {read=FOnSelChange, write=FOnSelChange};
	__property System::Classes::TNotifyEvent OnSetName = {read=FOnSetName, write=FOnSetName};
	__property bool UseHalftonePalette = {read=FUseHalftonePalette, write=FUseHalftonePalette, nodefault};
	__property bool Hot = {read=FHot, write=FHot, nodefault};
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property Vcl::Dbctrls::TFieldDataLink* DataLink = {read=FDataLink};
	__property Data::Db::TField* Field = {read=GetField};
	__property bool DisableThemes = {read=FDisableThemes, write=FDisableThemes, default=0};
	__property TwwButtonGetCaptionEvent OnGetCaption = {read=FOnGetCaption, write=FOnGetCaption};
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwCustomBitBtn(HWND ParentWindow) : Vcl::Controls::TWinControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwButton : public TwwCustomBitBtn
{
	typedef TwwCustomBitBtn inherited;
	
__published:
	__property Action;
	__property Anchors = {default=3};
	__property Constraints;
	__property AllowAllUp = {default=0};
	__property Cancel = {default=0};
	__property Caption = {default=0};
	__property Color = {default=-16777211};
	__property Default = {default=0};
	__property DataSource;
	__property DataField = {default=0};
	__property DragCursor = {default=-12};
	__property DragKind = {default=0};
	__property DragMode = {default=0};
	__property Down = {default=0};
	__property Font;
	__property Enabled = {default=1};
	__property DitherColor;
	__property DitherStyle;
	__property Glyph;
	__property GroupIndex = {default=0};
	__property Kind = {default=0};
	__property Layout = {default=0};
	__property Margin = {default=-1};
	__property ModalResult = {default=0};
	__property NumGlyphs = {default=1};
	__property Offsets;
	__property Options = {default=0};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShadeColors;
	__property ShadeStyle;
	__property ShowHint;
	__property SmoothFont = {default=0};
	__property Style = {default=0};
	__property Spacing = {default=4};
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property TextOptions;
	__property Visible = {default=1};
	__property StaticCaption = {default=0};
	__property OnClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseEnter;
	__property OnMouseLeave;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnSelChange;
	__property OnStartDrag;
	__property DisableThemes = {default=0};
	__property Align = {default=0};
	__property StyleElements = {default=7};
	__property DoubleBuffered;
	__property ParentDoubleBuffered = {default=1};
public:
	/* TwwCustomBitBtn.Create */ inline __fastcall virtual TwwButton(System::Classes::TComponent* AOwner) : TwwCustomBitBtn(AOwner) { }
	/* TwwCustomBitBtn.Destroy */ inline __fastcall virtual ~TwwButton(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwButton(HWND ParentWindow) : TwwCustomBitBtn(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 DESIGN_KEY = System::Int8(0x12);
static const int WWDEFUNUSECOLOR = int(255);
static const int WWDEFUNUSECOLOR2 = int(16711680);
}	/* namespace Wwbutton */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWBUTTON)
using namespace Vcl::Wwbutton;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwbuttonHPP
