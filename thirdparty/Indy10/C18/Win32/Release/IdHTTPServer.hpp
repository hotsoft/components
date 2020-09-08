// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdHTTPServer.pas' rev: 25.00 (Windows)

#ifndef IdhttpserverHPP
#define IdhttpserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdCustomHTTPServer.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idhttpserver
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdHTTPServer;
class PASCALIMPLEMENTATION TIdHTTPServer : public Idcustomhttpserver::TIdCustomHTTPServer
{
	typedef Idcustomhttpserver::TIdCustomHTTPServer inherited;
	
__published:
	__property OnCreatePostStream;
	__property OnDoneWithPostStream;
	__property OnCommandGet;
public:
	/* TIdCustomHTTPServer.Create */ inline __fastcall TIdHTTPServer(System::Classes::TComponent* AOwner)/* overload */ : Idcustomhttpserver::TIdCustomHTTPServer(AOwner) { }
	/* TIdCustomHTTPServer.Destroy */ inline __fastcall virtual ~TIdHTTPServer(void) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdHTTPServer(void)/* overload */ : Idcustomhttpserver::TIdCustomHTTPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idhttpserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDHTTPSERVER)
using namespace Idhttpserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdhttpserverHPP
