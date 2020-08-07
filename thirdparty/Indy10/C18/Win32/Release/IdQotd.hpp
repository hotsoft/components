// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdQotd.pas' rev: 25.00 (Windows)

#ifndef IdqotdHPP
#define IdqotdHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idqotd
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdQOTD;
class PASCALIMPLEMENTATION TIdQOTD : public Idtcpclient::TIdTCPClientCustom
{
	typedef Idtcpclient::TIdTCPClientCustom inherited;
	
protected:
	System::UnicodeString __fastcall GetQuote(void);
	virtual void __fastcall InitComponent(void);
	
public:
	__property System::UnicodeString Quote = {read=GetQuote};
	
__published:
	__property Port = {default=17};
	__property Host = {default=0};
public:
	/* TIdTCPConnection.Destroy */ inline __fastcall virtual ~TIdQOTD(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdQOTD(System::Classes::TComponent* AOwner)/* overload */ : Idtcpclient::TIdTCPClientCustom(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdQOTD(void)/* overload */ : Idtcpclient::TIdTCPClientCustom() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idqotd */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDQOTD)
using namespace Idqotd;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdqotdHPP
