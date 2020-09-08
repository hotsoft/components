// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdUnixTimeServer.pas' rev: 25.00 (Windows)

#ifndef IdunixtimeserverHPP
#define IdunixtimeserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdGlobalProtocols.hpp>	// Pascal unit
#include <IdTimeServer.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idunixtimeserver
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdUnixTimeServer;
class PASCALIMPLEMENTATION TIdUnixTimeServer : public Idtimeserver::TIdCustomTimeServer
{
	typedef Idtimeserver::TIdCustomTimeServer inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
	
__published:
	__property DefaultPort = {default=519};
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdUnixTimeServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdUnixTimeServer(System::Classes::TComponent* AOwner)/* overload */ : Idtimeserver::TIdCustomTimeServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdUnixTimeServer(void)/* overload */ : Idtimeserver::TIdCustomTimeServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idunixtimeserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDUNIXTIMESERVER)
using namespace Idunixtimeserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdunixtimeserverHPP
