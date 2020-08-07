// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdChargenUDPServer.pas' rev: 25.00 (Windows)

#ifndef IdchargenudpserverHPP
#define IdchargenudpserverHPP

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

namespace Idchargenudpserver
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdChargenUDPServer;
class PASCALIMPLEMENTATION TIdChargenUDPServer : public Idudpserver::TIdUDPServer
{
	typedef Idudpserver::TIdUDPServer inherited;
	
protected:
	virtual void __fastcall DoUDPRead(Idudpserver::TIdUDPListenerThread* AThread, const Idglobal::TIdBytes AData, Idsockethandle::TIdSocketHandle* ABinding);
	virtual void __fastcall InitComponent(void);
	
__published:
	__property DefaultPort = {default=19};
public:
	/* TIdUDPServer.Destroy */ inline __fastcall virtual ~TIdChargenUDPServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdChargenUDPServer(System::Classes::TComponent* AOwner)/* overload */ : Idudpserver::TIdUDPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdChargenUDPServer(void)/* overload */ : Idudpserver::TIdUDPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idchargenudpserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCHARGENUDPSERVER)
using namespace Idchargenudpserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdchargenudpserverHPP
