// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSystatServer.pas' rev: 25.00 (Windows)

#ifndef IdsystatserverHPP
#define IdsystatserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsystatserver
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TIdSystatEvent)(Idcontext::TIdContext* AThread, System::Classes::TStrings* AResults);

class DELPHICLASS TIdSystatServer;
class PASCALIMPLEMENTATION TIdSystatServer : public Idcustomtcpserver::TIdCustomTCPServer
{
	typedef Idcustomtcpserver::TIdCustomTCPServer inherited;
	
protected:
	TIdSystatEvent FOnSystat;
	virtual bool __fastcall DoExecute(Idcontext::TIdContext* AThread);
	virtual void __fastcall InitComponent(void);
	
__published:
	__property TIdSystatEvent OnSystat = {read=FOnSystat, write=FOnSystat};
	__property DefaultPort = {default=11};
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdSystatServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSystatServer(System::Classes::TComponent* AOwner)/* overload */ : Idcustomtcpserver::TIdCustomTCPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSystatServer(void)/* overload */ : Idcustomtcpserver::TIdCustomTCPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idsystatserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSYSTATSERVER)
using namespace Idsystatserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsystatserverHPP
