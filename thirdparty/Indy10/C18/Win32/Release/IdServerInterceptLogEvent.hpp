// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdServerInterceptLogEvent.pas' rev: 25.00 (Windows)

#ifndef IdserverinterceptlogeventHPP
#define IdserverinterceptlogeventHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdServerInterceptLogBase.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idserverinterceptlogevent
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdServerInterceptLogEvent;
typedef void __fastcall (__closure *TIdOnLogString)(TIdServerInterceptLogEvent* ASender, const System::UnicodeString AText);

class PASCALIMPLEMENTATION TIdServerInterceptLogEvent : public Idserverinterceptlogbase::TIdServerInterceptLogBase
{
	typedef Idserverinterceptlogbase::TIdServerInterceptLogBase inherited;
	
protected:
	TIdOnLogString FOnLogString;
	
public:
	virtual void __fastcall DoLogWriteString(const System::UnicodeString AText);
	
__published:
	__property TIdOnLogString OnLogString = {read=FOnLogString, write=FOnLogString};
public:
	/* TIdServerInterceptLogBase.Destroy */ inline __fastcall virtual ~TIdServerInterceptLogEvent(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdServerInterceptLogEvent(System::Classes::TComponent* AOwner)/* overload */ : Idserverinterceptlogbase::TIdServerInterceptLogBase(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdServerInterceptLogEvent(void)/* overload */ : Idserverinterceptlogbase::TIdServerInterceptLogBase() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idserverinterceptlogevent */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSERVERINTERCEPTLOGEVENT)
using namespace Idserverinterceptlogevent;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdserverinterceptlogeventHPP
