// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTraceRoute.pas' rev: 25.00 (Windows)

#ifndef IdtracerouteHPP
#define IdtracerouteHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdIcmpClient.hpp>	// Pascal unit
#include <IdRawBase.hpp>	// Pascal unit
#include <IdRawClient.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idtraceroute
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdTraceRoute;
class PASCALIMPLEMENTATION TIdTraceRoute : public Idicmpclient::TIdCustomIcmpClient
{
	typedef Idicmpclient::TIdCustomIcmpClient inherited;
	
protected:
	bool FResolveHostNames;
	virtual void __fastcall DoReply(void);
	
public:
	void __fastcall Trace(void);
	
__published:
	__property PacketSize = {default=32};
	__property ReceiveTimeout = {default=0};
	__property bool ResolveHostNames = {read=FResolveHostNames, write=FResolveHostNames, nodefault};
	__property OnReply;
public:
	/* TIdCustomIcmpClient.Destroy */ inline __fastcall virtual ~TIdTraceRoute(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdTraceRoute(System::Classes::TComponent* AOwner)/* overload */ : Idicmpclient::TIdCustomIcmpClient(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdTraceRoute(void)/* overload */ : Idicmpclient::TIdCustomIcmpClient() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idtraceroute */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTRACEROUTE)
using namespace Idtraceroute;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtracerouteHPP
