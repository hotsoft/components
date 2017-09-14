// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwtext.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwtextHPP
#define Vcl_WwtextHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <System.Math.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <vcl.Wwcommon.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <vcl.wwtypes.hpp>
#include <Vcl.Themes.hpp>
#include <vcl.Wwstr.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwtext
{
//-- forward type declarations -----------------------------------------------
struct TwwTextCallbacks;
class DELPHICLASS TwwShadowEffects;
class DELPHICLASS TwwExtrudeEffects;
class DELPHICLASS TwwDisabledColors;
class DELPHICLASS TwwText;
class DELPHICLASS TwwCaptionText;
class DELPHICLASS TwwLabelText;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwVAlignment : unsigned char { vaTop, vaVCenter, vaBottom };

enum DECLSPEC_DENUM TwwTextStyle : unsigned char { fclsDefault, fclsLowered, fclsRaised, fclsOutline };

enum DECLSPEC_DENUM TwwOrientation : unsigned char { fcTopLeft, fcTopRight, fcBottomLeft, fcBottomRight, fcTop, fcRight, fcLeft, fcBottom };

enum DECLSPEC_DENUM TwwTextOption : unsigned char { toShowAccel, toShowEllipsis, toFullJustify };

typedef System::Set<TwwTextOption, TwwTextOption::toShowAccel, TwwTextOption::toFullJustify> TwwTextOptions;

struct DECLSPEC_DRECORD TwwTextCallbacks
{
public:
	Vcl::Wwtypes::TwwProcMeth Invalidate;
	Vcl::Wwtypes::TwwProcMeth AdjustBounds;
	Vcl::Wwtypes::TwwBoolFunc GetTextEnabled;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwShadowEffects : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TwwText* FText;
	System::Uitypes::TColor FColor;
	bool FEnabled;
	int FXOffset;
	int FYOffset;
	void __fastcall SetColor(System::Uitypes::TColor Value);
	void __fastcall SetEnabled(bool Value);
	void __fastcall SetXOffset(int Value);
	void __fastcall SetYOffset(int Value);
	
protected:
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	
public:
	__fastcall TwwShadowEffects(TwwText* Text);
	System::Types::TPoint __fastcall EffectiveOffset(void);
	
__published:
	__property System::Uitypes::TColor Color = {read=FColor, write=SetColor, default=-16777200};
	__property bool Enabled = {read=FEnabled, write=SetEnabled, default=0};
	__property int XOffset = {read=FXOffset, write=SetXOffset, default=10};
	__property int YOffset = {read=FYOffset, write=SetYOffset, default=10};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwShadowEffects(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwExtrudeEffects : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TwwText* FText;
	int FDepth;
	bool FEnabled;
	System::Uitypes::TColor FFarColor;
	System::Uitypes::TColor FNearColor;
	TwwOrientation FOrientation;
	bool FStriated;
	void __fastcall SetDepth(int Value);
	void __fastcall SetEnabled(bool Value);
	void __fastcall SetFarColor(System::Uitypes::TColor Value);
	void __fastcall SetNearColor(System::Uitypes::TColor Value);
	void __fastcall SetOrientation(TwwOrientation Value);
	void __fastcall SetStriated(bool Value);
	
protected:
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	
public:
	__fastcall TwwExtrudeEffects(TwwText* Text);
	System::Types::TSize __fastcall EffectiveDepth(bool CheckOrient);
	
__published:
	__property int Depth = {read=FDepth, write=SetDepth, default=10};
	__property bool Enabled = {read=FEnabled, write=SetEnabled, default=0};
	__property System::Uitypes::TColor FarColor = {read=FFarColor, write=SetFarColor, default=0};
	__property System::Uitypes::TColor NearColor = {read=FNearColor, write=SetNearColor, default=0};
	__property TwwOrientation Orientation = {read=FOrientation, write=SetOrientation, default=3};
	__property bool Striated = {read=FStriated, write=SetStriated, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwExtrudeEffects(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwDisabledColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TwwText* FText;
	System::Uitypes::TColor FHighlightColor;
	System::Uitypes::TColor FShadeColor;
	void __fastcall SetHighlightColor(System::Uitypes::TColor Value);
	void __fastcall SetShadeColor(System::Uitypes::TColor Value);
	
protected:
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	
public:
	__fastcall TwwDisabledColors(TwwText* Text);
	
__published:
	__property System::Uitypes::TColor HighlightColor = {read=FHighlightColor, write=SetHighlightColor, default=-16777196};
	__property System::Uitypes::TColor ShadeColor = {read=FShadeColor, write=SetShadeColor, default=-16777200};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwDisabledColors(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwText : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Types::TRect FRect;
	System::Classes::TAlignment FAlignment;
	Vcl::Graphics::TCanvas* FCanvas;
	Vcl::Graphics::TCanvas* FPaintCanvas;
	TwwDisabledColors* FDisabledColors;
	TwwExtrudeEffects* FExtrudeEffects;
	System::Uitypes::TColor FHighlightColor;
	unsigned FFlags;
	Vcl::Graphics::TFont* FFont;
	int FLineSpacing;
	TwwTextOptions FOptions;
	System::Uitypes::TColor FOutlineColor;
	int FRotation;
	bool FScaledFont;
	System::Uitypes::TColor FShadeColor;
	TwwShadowEffects* FShadow;
	TwwTextStyle FStyle;
	System::UnicodeString FText;
	TwwTextCallbacks FCallbacks;
	System::Types::TRect FTextRect;
	TwwVAlignment FVAlignment;
	bool FWordWrap;
	bool FDoubleBuffered;
	bool InDraw;
	System::Extended __fastcall GetAngle(void);
	void __fastcall SetAlignment(System::Classes::TAlignment Value);
	void __fastcall SetHighlightColor(System::Uitypes::TColor Value);
	void __fastcall SetLineSpacing(int Value);
	void __fastcall SetOptions(TwwTextOptions Value);
	void __fastcall SetOutlineColor(System::Uitypes::TColor Value);
	void __fastcall SetRotation(int Value);
	void __fastcall SetScaledFont(bool Value);
	void __fastcall SetShadeColor(System::Uitypes::TColor Value);
	void __fastcall SetStyle(TwwTextStyle Value);
	void __fastcall SetText(System::UnicodeString Value);
	void __fastcall SetTextRect(const System::Types::TRect &Value);
	void __fastcall SetVAlignment(TwwVAlignment Value);
	void __fastcall SetWordWrap(bool Value);
	
protected:
	Vcl::Graphics::TBitmap* FPaintBitmap;
	virtual Vcl::Graphics::TCanvas* __fastcall GetCanvas(void);
	virtual tagLOGFONTW __fastcall GetLogFont(void);
	virtual System::Types::TSize __fastcall GetTextSize(void);
	virtual System::Types::TSize __fastcall CalcTextSize(bool IgnoreRect);
	virtual System::Types::TRect __fastcall CalcRect(bool IgnoreRect);
	virtual void __fastcall DrawHighlight(void);
	virtual void __fastcall DrawOutline(void);
	virtual void __fastcall DrawShadow(const System::Types::TRect &r);
	void __fastcall DrawEmbossed(bool Raised);
	virtual void __fastcall DrawText(const System::Types::TRect &r);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	virtual System::Uitypes::TColor __fastcall GetTextColor(void);
	__property System::Extended Angle = {read=GetAngle};
	__property Vcl::Graphics::TFont* Font = {read=FFont};
	
public:
	System::Variant Patch;
	__fastcall TwwText(const TwwTextCallbacks &ACallbacks, Vcl::Graphics::TCanvas* ACanvas, Vcl::Graphics::TFont* AFont);
	__fastcall virtual ~TwwText(void);
	virtual System::Types::TRect __fastcall CalcDrawRect(bool IgnoreRect);
	virtual void __fastcall CallInvalidate(void);
	virtual void __fastcall Draw(void);
	virtual void __fastcall DrawStandardText(void);
	virtual void __fastcall DrawOutlineText(void);
	virtual void __fastcall DrawEmbossedText(bool Raised);
	void __fastcall DrawExtrusion(void);
	virtual void __fastcall PrepareCanvas(void);
	virtual void __fastcall UpdateFont(Vcl::Graphics::TFont* Value);
	__property System::Classes::TAlignment Alignment = {read=FAlignment, write=SetAlignment, nodefault};
	__property Vcl::Graphics::TCanvas* Canvas = {read=GetCanvas, write=FCanvas};
	__property TwwTextCallbacks Callbacks = {read=FCallbacks, write=FCallbacks};
	__property TwwDisabledColors* DisabledColors = {read=FDisabledColors, write=FDisabledColors};
	__property TwwExtrudeEffects* ExtrudeEffects = {read=FExtrudeEffects, write=FExtrudeEffects};
	__property unsigned Flags = {read=FFlags, write=FFlags, nodefault};
	__property System::Uitypes::TColor HighlightColor = {read=FHighlightColor, write=SetHighlightColor, default=-16777196};
	__property int LineSpacing = {read=FLineSpacing, write=SetLineSpacing, default=5};
	__property TwwTextOptions Options = {read=FOptions, write=SetOptions, default=1};
	__property System::Uitypes::TColor OutlineColor = {read=FOutlineColor, write=SetOutlineColor, default=0};
	__property int Rotation = {read=FRotation, write=SetRotation, default=0};
	__property bool ScaledFont = {read=FScaledFont, write=SetScaledFont, nodefault};
	__property System::Uitypes::TColor ShadeColor = {read=FShadeColor, write=SetShadeColor, default=-16777200};
	__property TwwShadowEffects* Shadow = {read=FShadow, write=FShadow};
	__property TwwTextStyle Style = {read=FStyle, write=SetStyle, default=0};
	__property System::UnicodeString Text = {read=FText, write=SetText};
	__property System::Types::TRect TextRect = {read=FTextRect, write=SetTextRect};
	__property TwwVAlignment VAlignment = {read=FVAlignment, write=SetVAlignment, nodefault};
	__property bool WordWrap = {read=FWordWrap, write=SetWordWrap, default=0};
	__property bool DoubleBuffered = {read=FDoubleBuffered, write=FDoubleBuffered, default=0};
};


class PASCALIMPLEMENTATION TwwCaptionText : public TwwText
{
	typedef TwwText inherited;
	
protected:
	virtual System::Uitypes::TColor __fastcall GetTextColor(void);
	
__published:
	__property Alignment;
	__property DisabledColors;
	__property ExtrudeEffects;
	__property HighlightColor = {default=-16777196};
	__property LineSpacing = {default=5};
	__property Options = {default=1};
	__property OutlineColor = {default=0};
	__property Rotation = {default=0};
	__property ShadeColor = {default=-16777200};
	__property Shadow;
	__property Style = {default=0};
	__property VAlignment;
	__property WordWrap = {default=0};
	__property DoubleBuffered = {default=0};
public:
	/* TwwText.Create */ inline __fastcall TwwCaptionText(const TwwTextCallbacks &ACallbacks, Vcl::Graphics::TCanvas* ACanvas, Vcl::Graphics::TFont* AFont) : TwwText(ACallbacks, ACanvas, AFont) { }
	/* TwwText.Destroy */ inline __fastcall virtual ~TwwCaptionText(void) { }
	
};


class PASCALIMPLEMENTATION TwwLabelText : public TwwCaptionText
{
	typedef TwwCaptionText inherited;
	
protected:
	virtual System::Uitypes::TColor __fastcall GetTextColor(void);
	
public:
	Vcl::Controls::TControl* Control;
public:
	/* TwwText.Create */ inline __fastcall TwwLabelText(const TwwTextCallbacks &ACallbacks, Vcl::Graphics::TCanvas* ACanvas, Vcl::Graphics::TFont* AFont) : TwwCaptionText(ACallbacks, ACanvas, AFont) { }
	/* TwwText.Destroy */ inline __fastcall virtual ~TwwLabelText(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwTextCallbacks __fastcall MakeCallbacks(Vcl::Wwtypes::TwwProcMeth InvalidateProc, Vcl::Wwtypes::TwwProcMeth AdjustBoundsProc, Vcl::Wwtypes::TwwBoolFunc GetTextEnabledProc);
}	/* namespace Wwtext */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWTEXT)
using namespace Vcl::Wwtext;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwtextHPP
