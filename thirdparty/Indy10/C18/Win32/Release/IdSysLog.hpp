// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSysLog.pas' rev: 25.00 (Windows)

#ifndef IdsyslogHPP
#define IdsyslogHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdSysLogMessage.hpp>	// Pascal unit
#include <IdUDPBase.hpp>	// Pascal unit
#include <IdUDPClient.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsyslog
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdSysLog;
class PASCALIMPLEMENTATION TIdSysLog : public Idudpclient::TIdUDPClient
{
	typedef Idudpclient::TIdUDPClient inherited;
	
protected:
	virtual Idsockethandle::TIdSocketHandle* __fastcall GetBinding(void);
	virtual void __fastcall InitComponent(void);
	
public:
	void __fastcall SendLogMessage(Idsyslogmessage::TIdSysLogMessage* const AMsg, const bool AAutoTimeStamp = true)/* overload */;
	void __fastcall SendLogMessage(const System::UnicodeString AMsg, const Idsyslogmessage::TIdSyslogFacility AFacility, const Idsyslogmessage::TIdSyslogSeverity ASeverity)/* overload */;
	void __fastcall SendLogMessage(const System::UnicodeString AProcess, const System::UnicodeString AText, const Idsyslogmessage::TIdSyslogFacility AFacility, const Idsyslogmessage::TIdSyslogSeverity ASeverity, const bool AUsePID = false, const int APID = 0xffffffff)/* overload */;
	
__published:
	__property Port = {default=514};
public:
	/* TIdUDPClient.Destroy */ inline __fastcall virtual ~TIdSysLog(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSysLog(System::Classes::TComponent* AOwner)/* overload */ : Idudpclient::TIdUDPClient(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSysLog(void)/* overload */ : Idudpclient::TIdUDPClient() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idsyslog */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSYSLOG)
using namespace Idsyslog;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsyslogHPP
