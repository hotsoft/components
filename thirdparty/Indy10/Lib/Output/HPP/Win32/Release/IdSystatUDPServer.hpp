// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSystatUDPServer.pas' rev: 25.00 (Windows)

#ifndef IdsystatudpserverHPP
#define IdsystatudpserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdUDPBase.hpp>	// Pascal unit
#include <IdUDPServer.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsystatudpserver
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TIdUDPSystatEvent)(Idsockethandle::TIdSocketHandle* ABinding, System::Classes::TStrings* AResults);

class DELPHICLASS TIdSystatUDPServer;
class PASCALIMPLEMENTATION TIdSystatUDPServer : public Idudpserver::TIdUDPServer
{
	typedef Idudpserver::TIdUDPServer inherited;
	
protected:
	TIdUDPSystatEvent FOnSystat;
	virtual void __fastcall DoUDPRead(Idudpserver::TIdUDPListenerThread* AThread, const Idglobal::TIdBytes AData, Idsockethandle::TIdSocketHandle* ABinding);
	virtual void __fastcall InitComponent(void);
	
__published:
	__property TIdUDPSystatEvent OnSystat = {read=FOnSystat, write=FOnSystat};
	__property DefaultPort = {default=11};
public:
	/* TIdUDPServer.Destroy */ inline __fastcall virtual ~TIdSystatUDPServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSystatUDPServer(System::Classes::TComponent* AOwner)/* overload */ : Idudpserver::TIdUDPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSystatUDPServer(void)/* overload */ : Idudpserver::TIdUDPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idsystatudpserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSYSTATUDPSERVER)
using namespace Idsystatudpserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsystatudpserverHPP
