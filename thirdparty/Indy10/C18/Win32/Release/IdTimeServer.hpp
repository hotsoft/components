// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTimeServer.pas' rev: 25.00 (Windows)

#ifndef IdtimeserverHPP
#define IdtimeserverHPP

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

namespace Idtimeserver
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdCustomTimeServer;
class PASCALIMPLEMENTATION TIdCustomTimeServer : public Idcustomtcpserver::TIdCustomTCPServer
{
	typedef Idcustomtcpserver::TIdCustomTCPServer inherited;
	
protected:
	System::TDateTime FBaseDate;
	virtual bool __fastcall DoExecute(Idcontext::TIdContext* AContext);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdCustomTimeServer(System::Classes::TComponent* AOwner)/* overload */;
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdCustomTimeServer(void) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdCustomTimeServer(void)/* overload */ : Idcustomtcpserver::TIdCustomTCPServer() { }
	
};


class DELPHICLASS TIdTimeServer;
class PASCALIMPLEMENTATION TIdTimeServer : public TIdCustomTimeServer
{
	typedef TIdCustomTimeServer inherited;
	
__published:
	__property DefaultPort = {default=37};
	__property System::TDateTime BaseDate = {read=FBaseDate, write=FBaseDate};
public:
	/* TIdCustomTimeServer.Create */ inline __fastcall TIdTimeServer(System::Classes::TComponent* AOwner)/* overload */ : TIdCustomTimeServer(AOwner) { }
	
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdTimeServer(void) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdTimeServer(void)/* overload */ : TIdCustomTimeServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idtimeserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTIMESERVER)
using namespace Idtimeserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtimeserverHPP
