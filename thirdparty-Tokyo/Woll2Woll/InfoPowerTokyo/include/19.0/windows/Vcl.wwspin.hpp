// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwspin.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwspinHPP
#define Vcl_WwspinHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Controls.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Buttons.hpp>
#include <vcl.wwcombobutton.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwspin
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwSpinButton;
class DELPHICLASS TwwTimerSpeedButton;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwSpinButton : public Vcl::Controls::TWinControl
{
	typedef Vcl::Controls::TWinControl inherited;
	
private:
	TwwTimerSpeedButton* FUpButton;
	TwwTimerSpeedButton* FDownButton;
	System::Classes::TNotifyEvent FOnUpClick;
	System::Classes::TNotifyEvent FOnDownClick;
	TwwTimerSpeedButton* __fastcall CreateButton(void);
	Vcl::Graphics::TBitmap* __fastcall GetUpGlyph(void);
	Vcl::Graphics::TBitmap* __fastcall GetDownGlyph(void);
	void __fastcall SetUpGlyph(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetDownGlyph(Vcl::Graphics::TBitmap* Value);
	void __fastcall BtnClick(System::TObject* Sender);
	void __fastcall AdjustSizes(int &W, int &H);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Message);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	void __fastcall SetFlat(bool val);
	bool __fastcall GetFlat(void);
	void __fastcall PaintTransparentBackground(void);
	
protected:
	virtual void __fastcall Loaded(void);
	
public:
	__fastcall virtual TwwSpinButton(System::Classes::TComponent* AOwner);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	__property Vcl::Graphics::TBitmap* DownGlyph = {read=GetDownGlyph, write=SetDownGlyph};
	__property Vcl::Graphics::TBitmap* UpGlyph = {read=GetUpGlyph, write=SetUpGlyph};
	__property System::Classes::TNotifyEvent OnDownClick = {read=FOnDownClick, write=FOnDownClick};
	__property System::Classes::TNotifyEvent OnUpClick = {read=FOnUpClick, write=FOnUpClick};
	
__published:
	__property bool Flat = {read=GetFlat, write=SetFlat, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwSpinButton(HWND ParentWindow) : Vcl::Controls::TWinControl(ParentWindow) { }
	/* TWinControl.Destroy */ inline __fastcall virtual ~TwwSpinButton(void) { }
	
};


enum DECLSPEC_DENUM Vcl_Wwspin__2 : unsigned char { tbFocusRect, tbAllowTimer };

typedef System::Set<Vcl_Wwspin__2, Vcl_Wwspin__2::tbFocusRect, Vcl_Wwspin__2::tbAllowTimer> TTimeBtnState;

class PASCALIMPLEMENTATION TwwTimerSpeedButton : public Vcl::Wwcombobutton::TwwSpinControlButton
{
	typedef Vcl::Wwcombobutton::TwwSpinControlButton inherited;
	
private:
	Vcl::Extctrls::TTimer* FRepeatTimer;
	TTimeBtnState FTimeBtnState;
	void __fastcall TimerExpired(System::TObject* Sender);
	
protected:
	virtual void __fastcall Paint(void);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	
public:
	bool MouseInControl;
	__fastcall virtual ~TwwTimerSpeedButton(void);
	__property TTimeBtnState TimeBtnState = {read=FTimeBtnState, write=FTimeBtnState, nodefault};
public:
	/* TwwComboButton.Create */ inline __fastcall virtual TwwTimerSpeedButton(System::Classes::TComponent* AOwner) : Vcl::Wwcombobutton::TwwSpinControlButton(AOwner) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwspin */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWSPIN)
using namespace Vcl::Wwspin;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwspinHPP
