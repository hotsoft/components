// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdQotdServer.pas' rev: 25.00 (Windows)

#ifndef IdqotdserverHPP
#define IdqotdserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idqotdserver
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TIdQOTDGetEvent)(Idcontext::TIdContext* AContext, System::UnicodeString &AQuote);

class DELPHICLASS TIdQOTDServer;
class PASCALIMPLEMENTATION TIdQOTDServer : public Idcustomtcpserver::TIdCustomTCPServer
{
	typedef Idcustomtcpserver::TIdCustomTCPServer inherited;
	
protected:
	TIdQOTDGetEvent FOnCommandQOTD;
	virtual bool __fastcall DoExecute(Idcontext::TIdContext* AContext);
	virtual void __fastcall InitComponent(void);
	
__published:
	__property TIdQOTDGetEvent OnCommandQOTD = {read=FOnCommandQOTD, write=FOnCommandQOTD};
	__property DefaultPort = {default=17};
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdQOTDServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdQOTDServer(System::Classes::TComponent* AOwner)/* overload */ : Idcustomtcpserver::TIdCustomTCPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdQOTDServer(void)/* overload */ : Idcustomtcpserver::TIdCustomTCPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idqotdserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDQOTDSERVER)
using namespace Idqotdserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdqotdserverHPP
