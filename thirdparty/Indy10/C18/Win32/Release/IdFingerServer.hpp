// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFingerServer.pas' rev: 25.00 (Windows)

#ifndef IdfingerserverHPP
#define IdfingerserverHPP

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

namespace Idfingerserver
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TIdFingerGetEvent)(Idcontext::TIdContext* AContext, const System::UnicodeString AUserName, System::UnicodeString &VResponse);

class DELPHICLASS TIdFingerServer;
class PASCALIMPLEMENTATION TIdFingerServer : public Idcustomtcpserver::TIdCustomTCPServer
{
	typedef Idcustomtcpserver::TIdCustomTCPServer inherited;
	
protected:
	TIdFingerGetEvent FOnCommandFinger;
	TIdFingerGetEvent FOnCommandVerboseFinger;
	virtual bool __fastcall DoExecute(Idcontext::TIdContext* AContext);
	virtual void __fastcall InitComponent(void);
	
__published:
	__property TIdFingerGetEvent OnCommandFinger = {read=FOnCommandFinger, write=FOnCommandFinger};
	__property TIdFingerGetEvent OnCommandVerboseFinger = {read=FOnCommandVerboseFinger, write=FOnCommandVerboseFinger};
	__property DefaultPort = {default=79};
public:
	/* TIdCustomTCPServer.Destroy */ inline __fastcall virtual ~TIdFingerServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdFingerServer(System::Classes::TComponent* AOwner)/* overload */ : Idcustomtcpserver::TIdCustomTCPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdFingerServer(void)/* overload */ : Idcustomtcpserver::TIdCustomTCPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idfingerserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFINGERSERVER)
using namespace Idfingerserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdfingerserverHPP
