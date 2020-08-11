// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTelnetServer.pas' rev: 25.00 (Windows)

#ifndef IdtelnetserverHPP
#define IdtelnetserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit
#include <IdTask.hpp>	// Pascal unit
#include <IdThreadSafe.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idtelnetserver
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TTelnetData;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TTelnetData : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::UnicodeString Username;
	System::UnicodeString Password;
	unsigned HUserToken;
public:
	/* TObject.Create */ inline __fastcall TTelnetData(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TTelnetData(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdTelnetServerContext;
class PASCALIMPLEMENTATION TIdTelnetServerContext : public Idcustomtcpserver::TIdServerContext
{
	typedef Idcustomtcpserver::TIdServerContext inherited;
	
private:
	TTelnetData* FTelnetData;
	
public:
	__fastcall virtual TIdTelnetServerContext(Idtcpconnection::TIdTCPConnection* AConnection, Idyarn::TIdYarn* AYarn, Idthreadsafe::TIdThreadSafeObjectList* AList);
	__fastcall virtual ~TIdTelnetServerContext(void);
	__property TTelnetData* TelnetData = {read=FTelnetData};
};


typedef void __fastcall (__closure *TIdTelnetNegotiateEvent)(Idcontext::TIdContext* AContext);

typedef void __fastcall (__closure *TAuthenticationEvent)(Idcontext::TIdContext* AContext, const System::UnicodeString AUsername, const System::UnicodeString APassword, bool &AAuthenticated);

class DELPHICLASS TIdTelnetServer;
class PASCALIMPLEMENTATION TIdTelnetServer : public Idcustomtcpserver::TIdCustomTCPServer
{
	typedef Idcustomtcpserver::TIdCustomTCPServer inherited;
	
protected:
	int FLoginAttempts;
	TAuthenticationEvent FOnAuthentication;
	System::UnicodeString FLoginMessage;
	TIdTelnetNegotiateEvent FOnNegotiate;
	virtual void __fastcall DoConnect(Idcontext::TIdContext* AContext);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdTelnetServer(System::Classes::TComponent* AOwner)/* overload */;
	virtual bool __fastcall DoAuthenticate(Idcontext::TIdContext* AContext, const System::UnicodeString AUsername, const System::UnicodeString APassword);
	virtual void __fastcall DoNegotiate(Idcontext::TIdContext* AContext);
	
__published:
	__property DefaultPort = {default=23};
	__property int LoginAttempts = {read=FLoginAttempts, write=FLoginAttempts, default=3};
	__property System::UnicodeString LoginMessage = {read=FLoginMessage, write=FLoginMessage};
	__property TAuthenticationEvent OnAuthentication = {read=FOnAuthentication, write=FOnAuthentication};
	__property TIdTelnetNegotiateEvent OnNegotiate = {read=FOnNegotiate, write=FOnNegotiate};
	__property OnExecute;
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdTelnetServer(void) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdTelnetServer(void)/* overload */ : Idcustomtcpserver::TIdCustomTCPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 GLoginAttempts = System::Int8(0x3);
}	/* namespace Idtelnetserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTELNETSERVER)
using namespace Idtelnetserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtelnetserverHPP
