// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdWhois.pas' rev: 25.00 (Windows)

#ifndef IdwhoisHPP
#define IdwhoisHPP

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

namespace Idwhois
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdWhois;
class PASCALIMPLEMENTATION TIdWhois : public Idtcpclient::TIdTCPClientCustom
{
	typedef Idtcpclient::TIdTCPClientCustom inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
	
public:
	System::UnicodeString __fastcall WhoIs(const System::UnicodeString ADomain);
	
__published:
	__property Port = {default=43};
	__property Host = {default=0};
public:
	/* TIdTCPConnection.Destroy */ inline __fastcall virtual ~TIdWhois(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdWhois(System::Classes::TComponent* AOwner)/* overload */ : Idtcpclient::TIdTCPClientCustom(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdWhois(void)/* overload */ : Idtcpclient::TIdTCPClientCustom() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idwhois */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDWHOIS)
using namespace Idwhois;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdwhoisHPP
