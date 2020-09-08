// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMappedTelnet.pas' rev: 25.00 (Windows)

#ifndef IdmappedtelnetHPP
#define IdmappedtelnetHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdMappedPortTCP.hpp>	// Pascal unit
#include <IdTCPServer.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdTask.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmappedtelnet
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdMappedTelnetContext;
class PASCALIMPLEMENTATION TIdMappedTelnetContext : public Idmappedporttcp::TIdMappedPortContext
{
	typedef Idmappedporttcp::TIdMappedPortContext inherited;
	
protected:
	int FAllowedConnectAttempts;
	System::UnicodeString FErrorMsg;
	virtual void __fastcall OutboundConnect(void);
	
public:
	__property int AllowedConnectAttempts = {read=FAllowedConnectAttempts, nodefault};
	__property System::UnicodeString ErrorMsg = {read=FErrorMsg};
public:
	/* TIdMappedPortContext.Create */ inline __fastcall virtual TIdMappedTelnetContext(Idtcpconnection::TIdTCPConnection* AConnection, Idyarn::TIdYarn* AYarn, Idthreadsafe::TIdThreadSafeObjectList* AList) : Idmappedporttcp::TIdMappedPortContext(AConnection, AYarn, AList) { }
	/* TIdMappedPortContext.Destroy */ inline __fastcall virtual ~TIdMappedTelnetContext(void) { }
	
};


typedef void __fastcall (__closure *TIdMappedTelnetCheckHostPort)(Idmappedporttcp::TIdMappedPortContext* AContext, const System::UnicodeString AHostPort, System::UnicodeString &VHost, System::UnicodeString &VPort);

class DELPHICLASS TIdCustomMappedTelnet;
class PASCALIMPLEMENTATION TIdCustomMappedTelnet : public Idmappedporttcp::TIdMappedPortTCP
{
	typedef Idmappedporttcp::TIdMappedPortTCP inherited;
	
protected:
	int FAllowedConnectAttempts;
	TIdMappedTelnetCheckHostPort FOnCheckHostPort;
	virtual void __fastcall DoCheckHostPort(Idmappedporttcp::TIdMappedPortContext* AContext, const System::UnicodeString AHostPort, System::UnicodeString &VHost, System::UnicodeString &VPort);
	void __fastcall SetAllowedConnectAttempts(const int Value);
	void __fastcall ExtractHostAndPortFromLine(Idmappedporttcp::TIdMappedPortContext* AContext, const System::UnicodeString AHostPort);
	virtual void __fastcall InitComponent(void);
	
public:
	__property int AllowedConnectAttempts = {read=FAllowedConnectAttempts, write=SetAllowedConnectAttempts, default=-1};
	__property TIdMappedTelnetCheckHostPort OnCheckHostPort = {read=FOnCheckHostPort, write=FOnCheckHostPort};
	
__published:
	__property DefaultPort = {default=23};
	__property MappedPort = {default=23};
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdCustomMappedTelnet(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdCustomMappedTelnet(System::Classes::TComponent* AOwner)/* overload */ : Idmappedporttcp::TIdMappedPortTCP(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdCustomMappedTelnet(void)/* overload */ : Idmappedporttcp::TIdMappedPortTCP() { }
	
};


class DELPHICLASS TIdMappedTelnet;
class PASCALIMPLEMENTATION TIdMappedTelnet : public TIdCustomMappedTelnet
{
	typedef TIdCustomMappedTelnet inherited;
	
__published:
	__property int AllowedConnectAttempts = {read=FAllowedConnectAttempts, write=SetAllowedConnectAttempts, default=-1};
	__property TIdMappedTelnetCheckHostPort OnCheckHostPort = {read=FOnCheckHostPort, write=FOnCheckHostPort};
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdMappedTelnet(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMappedTelnet(System::Classes::TComponent* AOwner)/* overload */ : TIdCustomMappedTelnet(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMappedTelnet(void)/* overload */ : TIdCustomMappedTelnet() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idmappedtelnet */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMAPPEDTELNET)
using namespace Idmappedtelnet;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmappedtelnetHPP
