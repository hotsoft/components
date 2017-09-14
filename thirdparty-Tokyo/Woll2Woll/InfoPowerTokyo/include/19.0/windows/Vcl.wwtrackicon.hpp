// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwtrackicon.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwtrackiconHPP
#define Vcl_WwtrackiconHPP

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

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwtrackicon
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwTrackIcon;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwTrackIcon : public Vcl::Controls::TGraphicControl
{
	typedef Vcl::Controls::TGraphicControl inherited;
	
private:
	Vcl::Graphics::TBitmap* TrackBmp;
	System::Classes::TNotifyEvent FOnEndDrag;
	System::UnicodeString FBitmapName;
	int FMinValue;
	int FMaxValue;
	void __fastcall MouseLoop_Drag(int X, int Y);
	void __fastcall SetBitmapName(System::UnicodeString val);
	int __fastcall GetPosition(void);
	void __fastcall SetPosition(int value);
	System::Extended __fastcall GetZoomFactor(void);
	
protected:
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
	
public:
	__fastcall virtual TwwTrackIcon(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwTrackIcon(void);
	
__published:
	__property System::Classes::TNotifyEvent OnEndDrag = {read=FOnEndDrag, write=FOnEndDrag};
	__property System::UnicodeString BitmapName = {read=FBitmapName, write=SetBitmapName};
	__property int MinValue = {read=FMinValue, write=FMinValue, nodefault};
	__property int MaxValue = {read=FMaxValue, write=FMaxValue, nodefault};
	__property int Position = {read=GetPosition, write=SetPosition, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwtrackicon */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWTRACKICON)
using namespace Vcl::Wwtrackicon;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwtrackiconHPP
