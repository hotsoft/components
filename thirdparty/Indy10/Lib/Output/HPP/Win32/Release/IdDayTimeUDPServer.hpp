// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdDayTimeUDPServer.pas' rev: 25.00 (Windows)

#ifndef IddaytimeudpserverHPP
#define IddaytimeudpserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdUDPBase.hpp>	// Pascal unit
#include <IdUDPServer.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Iddaytimeudpserver
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdDayTimeUDPServer;
class PASCALIMPLEMENTATION TIdDayTimeUDPServer : public Idudpserver::TIdUDPServer
{
	typedef Idudpserver::TIdUDPServer inherited;
	
protected:
	System::UnicodeString FTimeZone;
	virtual void __fastcall DoUDPRead(Idudpserver::TIdUDPListenerThread* AThread, const Idglobal::TIdBytes AData, Idsockethandle::TIdSocketHandle* ABinding);
	virtual void __fastcall InitComponent(void);
	
__published:
	__property System::UnicodeString TimeZone = {read=FTimeZone, write=FTimeZone};
	__property DefaultPort = {default=13};
public:
	/* TIdUDPServer.Destroy */ inline __fastcall virtual ~TIdDayTimeUDPServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdDayTimeUDPServer(System::Classes::TComponent* AOwner)/* overload */ : Idudpserver::TIdUDPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdDayTimeUDPServer(void)/* overload */ : Idudpserver::TIdUDPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Iddaytimeudpserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDDAYTIMEUDPSERVER)
using namespace Iddaytimeudpserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IddaytimeudpserverHPP
