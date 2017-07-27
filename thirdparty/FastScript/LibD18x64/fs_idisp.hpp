// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fs_idisp.pas' rev: 25.00 (Windows)

#ifndef Fs_idispHPP
#define Fs_idispHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <Winapi.ActiveX.hpp>	// Pascal unit
#include <System.Win.ComObj.hpp>	// Pascal unit
#include <fs_iinterpreter.hpp>	// Pascal unit
#include <System.Variants.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fs_idisp
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfsOLEHelper;
class PASCALIMPLEMENTATION TfsOLEHelper : public Fs_iinterpreter::TfsCustomHelper
{
	typedef Fs_iinterpreter::TfsCustomHelper inherited;
	
private:
	System::Variant __fastcall DispatchInvoke(const System::Variant &ParamArray, int ParamCount, System::Word Flags);
	
protected:
	virtual void __fastcall SetValue(const System::Variant &Value);
	virtual System::Variant __fastcall GetValue(void);
	
public:
	__fastcall TfsOLEHelper(const System::UnicodeString AName);
public:
	/* TfsItemList.Destroy */ inline __fastcall virtual ~TfsOLEHelper(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fs_idisp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FS_IDISP)
using namespace Fs_idisp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fs_idispHPP
