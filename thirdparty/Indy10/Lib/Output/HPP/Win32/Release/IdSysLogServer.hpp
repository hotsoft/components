// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSysLogServer.pas' rev: 25.00 (Windows)

#ifndef IdsyslogserverHPP
#define IdsyslogserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdStackConsts.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdUDPBase.hpp>	// Pascal unit
#include <IdUDPServer.hpp>	// Pascal unit
#include <IdSysLogMessage.hpp>	// Pascal unit
#include <IdSysLog.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsyslogserver
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TOnSyslogEvent)(System::TObject* Sender, Idsyslogmessage::TIdSysLogMessage* ASysLogMessage, Idsockethandle::TIdSocketHandle* ABinding);

class DELPHICLASS TIdSyslogServer;
class PASCALIMPLEMENTATION TIdSyslogServer : public Idudpserver::TIdUDPServer
{
	typedef Idudpserver::TIdUDPServer inherited;
	
protected:
	TOnSyslogEvent FOnSyslog;
	virtual void __fastcall DoSyslogEvent(Idsyslogmessage::TIdSysLogMessage* AMsg, Idsockethandle::TIdSocketHandle* ABinding);
	virtual void __fastcall DoUDPRead(Idudpserver::TIdUDPListenerThread* AThread, const Idglobal::TIdBytes AData, Idsockethandle::TIdSocketHandle* ABinding);
	virtual void __fastcall InitComponent(void);
	
__published:
	__property DefaultPort = {default=514};
	__property TOnSyslogEvent OnSyslog = {read=FOnSyslog, write=FOnSyslog};
public:
	/* TIdUDPServer.Destroy */ inline __fastcall virtual ~TIdSyslogServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSyslogServer(System::Classes::TComponent* AOwner)/* overload */ : Idudpserver::TIdUDPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSyslogServer(void)/* overload */ : Idudpserver::TIdUDPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idsyslogserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSYSLOGSERVER)
using namespace Idsyslogserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsyslogserverHPP
