// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwchangelink.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwchangelinkHPP
#define Vcl_WwchangelinkHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwchangelink
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwChangeLink;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwChangeLink : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TNotifyEvent FOnChange;
	System::Classes::TNotifyEvent FOnChanging;
	System::Classes::TNotifyEvent FOnLoaded;
	System::TObject* FSender;
	
public:
	virtual void __fastcall Change(void);
	virtual void __fastcall Changing(void);
	virtual void __fastcall Loaded(void);
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property System::Classes::TNotifyEvent OnChanging = {read=FOnChanging, write=FOnChanging};
	__property System::Classes::TNotifyEvent OnLoaded = {read=FOnLoaded, write=FOnLoaded};
	__property System::TObject* Sender = {read=FSender, write=FSender};
public:
	/* TObject.Create */ inline __fastcall TwwChangeLink(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TwwChangeLink(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwchangelink */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWCHANGELINK)
using namespace Vcl::Wwchangelink;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwchangelinkHPP
