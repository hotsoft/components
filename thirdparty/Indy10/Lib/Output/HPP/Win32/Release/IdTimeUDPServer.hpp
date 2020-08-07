// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTimeUDPServer.pas' rev: 25.00 (Windows)

#ifndef IdtimeudpserverHPP
#define IdtimeudpserverHPP

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

namespace Idtimeudpserver
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdCustomTimeUDPServer;
class PASCALIMPLEMENTATION TIdCustomTimeUDPServer : public Idudpserver::TIdUDPServer
{
	typedef Idudpserver::TIdUDPServer inherited;
	
protected:
	System::TDateTime FBaseDate;
	virtual void __fastcall DoUDPRead(Idudpserver::TIdUDPListenerThread* AThread, const Idglobal::TIdBytes AData, Idsockethandle::TIdSocketHandle* ABinding);
	virtual void __fastcall InitComponent(void);
public:
	/* TIdUDPServer.Destroy */ inline __fastcall virtual ~TIdCustomTimeUDPServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdCustomTimeUDPServer(System::Classes::TComponent* AOwner)/* overload */ : Idudpserver::TIdUDPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdCustomTimeUDPServer(void)/* overload */ : Idudpserver::TIdUDPServer() { }
	
};


class DELPHICLASS TIdTimeUDPServer;
class PASCALIMPLEMENTATION TIdTimeUDPServer : public TIdCustomTimeUDPServer
{
	typedef TIdCustomTimeUDPServer inherited;
	
__published:
	__property DefaultPort = {default=37};
	__property System::TDateTime BaseDate = {read=FBaseDate, write=FBaseDate};
public:
	/* TIdUDPServer.Destroy */ inline __fastcall virtual ~TIdTimeUDPServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdTimeUDPServer(System::Classes::TComponent* AOwner)/* overload */ : TIdCustomTimeUDPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdTimeUDPServer(void)/* overload */ : TIdCustomTimeUDPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idtimeudpserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTIMEUDPSERVER)
using namespace Idtimeudpserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtimeudpserverHPP
