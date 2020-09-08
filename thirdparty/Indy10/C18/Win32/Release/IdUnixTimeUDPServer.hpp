// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdUnixTimeUDPServer.pas' rev: 25.00 (Windows)

#ifndef IdunixtimeudpserverHPP
#define IdunixtimeudpserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdUDPServer.hpp>	// Pascal unit
#include <IdTimeUDPServer.hpp>	// Pascal unit
#include <IdUDPBase.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idunixtimeudpserver
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdUnixTimeUDPServer;
class PASCALIMPLEMENTATION TIdUnixTimeUDPServer : public Idtimeudpserver::TIdCustomTimeUDPServer
{
	typedef Idtimeudpserver::TIdCustomTimeUDPServer inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdUnixTimeUDPServer(System::Classes::TComponent* AOwner)/* overload */;
	
__published:
	__property DefaultPort = {default=519};
public:
	/* TIdUDPServer.Destroy */ inline __fastcall virtual ~TIdUnixTimeUDPServer(void) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdUnixTimeUDPServer(void)/* overload */ : Idtimeudpserver::TIdCustomTimeUDPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idunixtimeudpserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDUNIXTIMEUDPSERVER)
using namespace Idunixtimeudpserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdunixtimeudpserverHPP
