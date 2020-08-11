// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdUnixTimeUDP.pas' rev: 25.00 (Windows)

#ifndef IdunixtimeudpHPP
#define IdunixtimeudpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdTimeUDP.hpp>	// Pascal unit
#include <IdUDPClient.hpp>	// Pascal unit
#include <IdUDPBase.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idunixtimeudp
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdUnixTimeUDP;
class PASCALIMPLEMENTATION TIdUnixTimeUDP : public Idtimeudp::TIdCustomTimeUDP
{
	typedef Idtimeudp::TIdCustomTimeUDP inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
	
__published:
	__property Port = {default=519};
public:
	/* TIdUDPClient.Destroy */ inline __fastcall virtual ~TIdUnixTimeUDP(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdUnixTimeUDP(System::Classes::TComponent* AOwner)/* overload */ : Idtimeudp::TIdCustomTimeUDP(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdUnixTimeUDP(void)/* overload */ : Idtimeudp::TIdCustomTimeUDP() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idunixtimeudp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDUNIXTIMEUDP)
using namespace Idunixtimeudp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdunixtimeudpHPP
