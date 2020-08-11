// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdGopherServer.pas' rev: 25.00 (Windows)

#ifndef IdgopherserverHPP
#define IdgopherserverHPP

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
#include <IdGlobal.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idgopherserver
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TRequestEvent)(Idcontext::TIdContext* AContext, System::UnicodeString ARequest);

typedef void __fastcall (__closure *TPlusRequestEvent)(Idcontext::TIdContext* AContext, System::UnicodeString ARequest, System::UnicodeString APlusData);

class DELPHICLASS TIdGopherServer;
class PASCALIMPLEMENTATION TIdGopherServer : public Idcustomtcpserver::TIdCustomTCPServer
{
	typedef Idcustomtcpserver::TIdCustomTCPServer inherited;
	
private:
	System::UnicodeString fAdminEmail;
	TRequestEvent fOnRequest;
	TPlusRequestEvent fOnPlusRequest;
	bool fTruncateUserFriendly;
	int fTruncateLength;
	
protected:
	virtual bool __fastcall DoExecute(Idcontext::TIdContext* AContext);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdGopherServer(System::Classes::TComponent* AOwner)/* overload */;
	System::UnicodeString __fastcall ReturnGopherItem(System::WideChar ItemType, System::UnicodeString UserFriendlyName, System::UnicodeString RealResourceName, System::UnicodeString HostServer, System::Word HostPort);
	void __fastcall SendDirectoryEntry(Idcontext::TIdContext* AContext, System::WideChar ItemType, System::UnicodeString UserFriendlyName, System::UnicodeString RealResourceName, System::UnicodeString HostServer, System::Word HostPort);
	
__published:
	__property System::UnicodeString AdminEmail = {read=fAdminEmail, write=fAdminEmail};
	__property TRequestEvent OnRequest = {read=fOnRequest, write=fOnRequest};
	__property TPlusRequestEvent OnPlusRequest = {read=fOnPlusRequest, write=fOnPlusRequest};
	__property bool TruncateUserFriendlyName = {read=fTruncateUserFriendly, write=fTruncateUserFriendly, default=1};
	__property int TruncateLength = {read=fTruncateLength, write=fTruncateLength, default=70};
	__property DefaultPort = {default=70};
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdGopherServer(void) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdGopherServer(void)/* overload */ : Idcustomtcpserver::TIdCustomTCPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idgopherserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDGOPHERSERVER)
using namespace Idgopherserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdgopherserverHPP
