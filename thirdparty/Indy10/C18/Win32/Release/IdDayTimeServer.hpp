// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdDayTimeServer.pas' rev: 25.00 (Windows)

#ifndef IddaytimeserverHPP
#define IddaytimeserverHPP

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

namespace Iddaytimeserver
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdDayTimeServer;
class PASCALIMPLEMENTATION TIdDayTimeServer : public Idcustomtcpserver::TIdCustomTCPServer
{
	typedef Idcustomtcpserver::TIdCustomTCPServer inherited;
	
protected:
	System::UnicodeString FTimeZone;
	virtual bool __fastcall DoExecute(Idcontext::TIdContext* AContext);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdDayTimeServer(System::Classes::TComponent* AOwner)/* overload */;
	
__published:
	__property System::UnicodeString TimeZone = {read=FTimeZone, write=FTimeZone};
	__property DefaultPort = {default=13};
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdDayTimeServer(void) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdDayTimeServer(void)/* overload */ : Idcustomtcpserver::TIdCustomTCPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Iddaytimeserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDDAYTIMESERVER)
using namespace Iddaytimeserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IddaytimeserverHPP
