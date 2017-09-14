// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwframe.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwframeHPP
#define Vcl_WwframeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <Winapi.Messages.hpp>
#include <System.TypInfo.hpp>
#include <Vcl.Themes.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwframe
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwButtonEffects;
class DELPHICLASS TwwEditFrame;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwComboButtonStyle : unsigned char { cbsEllipsis, cbsDownArrow, cbsCustom };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwButtonEffects : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FTransparent;
	bool FFlat;
	void __fastcall SetTransparent(bool val);
	void __fastcall SetFlat(bool val);
	bool __fastcall GetFlat(void);
	bool __fastcall GetTransparent(void);
	
protected:
	virtual void __fastcall Refresh(void);
	void __fastcall AssignAll(System::Classes::TPersistent* Source, bool SkipOptimize = true);
	
public:
	Vcl::Controls::TControl* Control;
	Vcl::Controls::TControl* Button;
	__fastcall TwwButtonEffects(System::Classes::TComponent* Owner, Vcl::Controls::TControl* AButton);
	__classmethod TwwButtonEffects* __fastcall Get(System::Classes::TComponent* Control);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property bool Transparent = {read=GetTransparent, write=SetTransparent, default=0};
	__property bool Flat = {read=GetFlat, write=SetFlat, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwButtonEffects(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TwwEditFocusStyle : unsigned char { efsFrameBox, efsFrameSunken, efsFrameRaised, efsFrameEtched, efsFrameBump, efsFrameSingle };

enum DECLSPEC_DENUM TwwEditFrameEnabledType : unsigned char { efLeftBorder, efTopBorder, efRightBorder, efBottomBorder };

typedef System::Set<TwwEditFrameEnabledType, TwwEditFrameEnabledType::efLeftBorder, TwwEditFrameEnabledType::efBottomBorder> TwwEditFrameEnabledSet;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwEditFrame : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	Vcl::Controls::TWinControl* Control;
	bool FEnabled;
	TwwEditFrameEnabledSet FNonFocusBorders;
	TwwEditFrameEnabledSet FFocusBorders;
	TwwEditFocusStyle FFocusStyle;
	TwwEditFocusStyle FNonFocusStyle;
	int FNonFocusTextOffsetX;
	int FNonFocusTextOffsetY;
	bool FTransparent;
	bool FTransparentClearsBackground;
	bool FMouseEnterSameAsFocus;
	int FAutoSizeHeightAdjust;
	System::Uitypes::TColor FNonFocusTransparentFontColor;
	System::Uitypes::TColor FNonFocusColor;
	System::Uitypes::TColor FNonFocusFontColor;
	void __fastcall SetFocusBorders(TwwEditFrameEnabledSet val);
	void __fastcall SetNonFocusBorders(TwwEditFrameEnabledSet val);
	void __fastcall SetNonFocusStyle(TwwEditFocusStyle val);
	void __fastcall SetEnabled(bool val);
	void __fastcall SetTransparent(bool val);
	void __fastcall CheckParentClipping(void);
	
public:
	bool CreateTransparent;
	int __fastcall NCPaint(bool FFocused, bool AlwaysTransparent = false, HDC adc = (HDC)(0x0));
	bool __fastcall IsSingleBorderStyle(TwwEditFocusStyle Style);
	__fastcall TwwEditFrame(System::Classes::TComponent* Owner);
	void __fastcall GetEditRectForFrame(System::Types::TRect &Loc);
	void __fastcall RefreshTransparentText(bool InvalidateBorders = false, bool UseEditRect = true, bool Exiting = false);
	void __fastcall RefreshControl(void);
	void __fastcall AdjustHeight(void);
	bool __fastcall IsFrameEffective(void);
	virtual void __fastcall GetFrameTextPosition(int &Left, int &Indent, bool Focused = false);
	__classmethod TwwEditFrame* __fastcall Get(System::Classes::TComponent* Control);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	void __fastcall AssignAll(System::Classes::TPersistent* Source, bool SkipOptimize = true);
	__property bool TransparentClearsBackground = {read=FTransparentClearsBackground, write=FTransparentClearsBackground, default=0};
	
__published:
	__property bool Enabled = {read=FEnabled, write=SetEnabled, default=0};
	__property bool Transparent = {read=FTransparent, write=SetTransparent, default=0};
	__property int AutoSizeHeightAdjust = {read=FAutoSizeHeightAdjust, write=FAutoSizeHeightAdjust, default=0};
	__property TwwEditFrameEnabledSet FocusBorders = {read=FFocusBorders, write=SetFocusBorders, default=15};
	__property TwwEditFrameEnabledSet NonFocusBorders = {read=FNonFocusBorders, write=SetNonFocusBorders, default=8};
	__property TwwEditFocusStyle FocusStyle = {read=FFocusStyle, write=FFocusStyle, default=0};
	__property TwwEditFocusStyle NonFocusStyle = {read=FNonFocusStyle, write=SetNonFocusStyle, default=0};
	__property int NonFocusTextOffsetX = {read=FNonFocusTextOffsetX, write=FNonFocusTextOffsetX, default=0};
	__property int NonFocusTextOffsetY = {read=FNonFocusTextOffsetY, write=FNonFocusTextOffsetY, default=0};
	__property System::Uitypes::TColor NonFocusTransparentFontColor = {read=FNonFocusTransparentFontColor, write=FNonFocusTransparentFontColor, default=536870911};
	__property System::Uitypes::TColor NonFocusColor = {read=FNonFocusColor, write=FNonFocusColor, default=536870911};
	__property System::Uitypes::TColor NonFocusFontColor = {read=FNonFocusFontColor, write=FNonFocusFontColor, default=536870911};
	__property bool MouseEnterSameAsFocus = {read=FMouseEnterSameAsFocus, write=FMouseEnterSameAsFocus, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwEditFrame(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool __fastcall wwIsTransparentParent(Vcl::Controls::TControl* control);
extern DELPHI_PACKAGE void __fastcall wwDrawEdge(Vcl::Controls::TWinControl* Control, TwwEditFrame* Frame, Vcl::Graphics::TCanvas* Canvas, bool Focused)/* overload */;
extern DELPHI_PACKAGE void __fastcall wwDrawEdge(Vcl::Controls::TWinControl* Control, TwwEditFrame* Frame, HDC DC, bool Focused)/* overload */;
extern DELPHI_PACKAGE void __fastcall wwInvalidateTransparentArea2(Vcl::Controls::TControl* control, bool Exiting, bool TransparentClearsBackground);
extern DELPHI_PACKAGE void __fastcall wwInvalidateTransparentArea(Vcl::Controls::TControl* control, bool Exiting);
}	/* namespace Wwframe */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWFRAME)
using namespace Vcl::Wwframe;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwframeHPP
