// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMappedPortUDP.pas' rev: 25.00 (Windows)

#ifndef IdmappedportudpHPP
#define IdmappedportudpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdUDPServer.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdGlobalProtocols.hpp>	// Pascal unit
#include <IdUDPBase.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmappedportudp
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdMappedPortUDP;
class PASCALIMPLEMENTATION TIdMappedPortUDP : public Idudpserver::TIdUDPServer
{
	typedef Idudpserver::TIdUDPServer inherited;
	
protected:
	System::Word FMappedPort;
	System::UnicodeString FMappedHost;
	System::Classes::TNotifyEvent FOnRequest;
	virtual void __fastcall DoRequestNotify(void);
	virtual void __fastcall InitComponent(void);
	virtual void __fastcall DoUDPRead(Idudpserver::TIdUDPListenerThread* AThread, const Idglobal::TIdBytes AData, Idsockethandle::TIdSocketHandle* ABinding);
	
__published:
	__property System::UnicodeString MappedHost = {read=FMappedHost, write=FMappedHost};
	__property System::Word MappedPort = {read=FMappedPort, write=FMappedPort, nodefault};
	__property System::Classes::TNotifyEvent OnRequest = {read=FOnRequest, write=FOnRequest};
public:
	/* TIdUDPServer.Destroy */ inline __fastcall virtual ~TIdMappedPortUDP(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMappedPortUDP(System::Classes::TComponent* AOwner)/* overload */ : Idudpserver::TIdUDPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMappedPortUDP(void)/* overload */ : Idudpserver::TIdUDPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idmappedportudp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMAPPEDPORTUDP)
using namespace Idmappedportudp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmappedportudpHPP
