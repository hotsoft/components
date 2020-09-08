// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdRexecServer.pas' rev: 25.00 (Windows)

#ifndef IdrexecserverHPP
#define IdrexecserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdRemoteCMDServer.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTCPServer.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idrexecserver
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TIdRexecCommandEvent)(Idcontext::TIdContext* AThread, Idtcpclient::TIdTCPClient* AStdError, System::UnicodeString AUserName, System::UnicodeString APassword, System::UnicodeString ACommand);

class DELPHICLASS TIdRexecServer;
class PASCALIMPLEMENTATION TIdRexecServer : public Idremotecmdserver::TIdRemoteCMDServer
{
	typedef Idremotecmdserver::TIdRemoteCMDServer inherited;
	
protected:
	TIdRexecCommandEvent FOnCommand;
	virtual void __fastcall DoCMD(Idcontext::TIdContext* AThread, Idtcpclient::TIdTCPClient* AStdError, System::UnicodeString AParam1, System::UnicodeString AParam2, System::UnicodeString ACommand);
	virtual void __fastcall InitComponent(void);
	
__published:
	__property TIdRexecCommandEvent OnCommand = {read=FOnCommand, write=FOnCommand};
	__property DefaultPort = {default=512};
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdRexecServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdRexecServer(System::Classes::TComponent* AOwner)/* overload */ : Idremotecmdserver::TIdRemoteCMDServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdRexecServer(void)/* overload */ : Idremotecmdserver::TIdRemoteCMDServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idrexecserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDREXECSERVER)
using namespace Idrexecserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdrexecserverHPP
