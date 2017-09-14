// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwspeedbutton.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwspeedbuttonHPP
#define Vcl_WwspeedbuttonHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Themes.hpp>
#include <vcl.Wwcommon.hpp>
#include <Vcl.ActnList.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwspeedbutton
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwDisabledTextColors;
class DELPHICLASS TwwSpeedButton;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwDisabledTextColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Uitypes::TColor FShadeColor;
	System::Uitypes::TColor FHighlightColor;
	
__published:
	__property System::Uitypes::TColor ShadeColor = {read=FShadeColor, write=FShadeColor, nodefault};
	__property System::Uitypes::TColor HighlightColor = {read=FHighlightColor, write=FHighlightColor, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwDisabledTextColors(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwDisabledTextColors(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwSpeedButton : public Vcl::Controls::TGraphicControl
{
	typedef Vcl::Controls::TGraphicControl inherited;
	
private:
	bool FTransparent;
	bool FFlat;
	int FImageIndex;
	Vcl::Controls::TImageList* FImageList;
	int FMargin;
	int FNumGlyphs;
	bool FShowText;
	int FSpacing;
	TwwDisabledTextColors* FDisabledTextColors;
	bool FMouseInControl;
	void __fastcall SetTransparent(bool Value);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	
protected:
	DYNAMIC void __fastcall ActionChange(System::TObject* Sender, bool CheckDefaults);
	virtual int __fastcall GetImageIndex(void);
	void __fastcall SetFlat(bool Value);
	virtual void __fastcall SetImageIndex(int Value);
	void __fastcall SetImageList(Vcl::Controls::TImageList* Value);
	void __fastcall SetMargin(int Value);
	void __fastcall SetNumGlyphs(int Value);
	void __fastcall SetShowText(bool Value);
	void __fastcall SetSpacing(int Value);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
	HIDESBASE HRESULT __stdcall QueryInterface(const GUID &IID, /* out */ void *Obj);
	HIDESBASE int __stdcall _AddRef(void);
	HIDESBASE int __stdcall _Release(void);
	
public:
	__fastcall virtual TwwSpeedButton(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwSpeedButton(void);
	__property Vcl::Controls::TImageList* ImageList = {read=FImageList, write=SetImageList};
	__property bool Flat = {read=FFlat, write=SetFlat, nodefault};
	
__published:
	__property Action;
	__property int ImageIndex = {read=GetImageIndex, write=SetImageIndex, nodefault};
	__property int Margin = {read=FMargin, write=SetMargin, default=-1};
	__property int NumGlyphs = {read=FNumGlyphs, write=SetNumGlyphs, nodefault};
	__property bool ShowText = {read=FShowText, write=SetShowText, default=0};
	__property int Spacing = {read=FSpacing, write=SetSpacing, nodefault};
	__property bool Transparent = {read=FTransparent, write=SetTransparent, default=1};
	__property Caption = {default=0};
	__property Enabled = {default=1};
	__property TwwDisabledTextColors* DisabledTextColors = {read=FDisabledTextColors, write=FDisabledTextColors};
	__property Font;
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property ShowHint;
	__property OnClick;
	__property OnMouseDown;
	__property OnMouseUp;
	__property OnMouseMove;
private:
	void *__IInterface;	// System::IInterface 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {00000000-0000-0000-C000-000000000046}
	operator System::_di_IInterface()
	{
		System::_di_IInterface intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator System::IInterface*(void) { return (System::IInterface*)&__IInterface; }
	#endif
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwspeedbutton */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWSPEEDBUTTON)
using namespace Vcl::Wwspeedbutton;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwspeedbuttonHPP
