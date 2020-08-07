// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdServerIOHandler.pas' rev: 25.00 (Windows)

#ifndef IdserveriohandlerHPP
#define IdserveriohandlerHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdIOHandlerStack.hpp>	// Pascal unit
#include <IdStackConsts.hpp>	// Pascal unit
#include <IdIOHandler.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdScheduler.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idserveriohandler
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdServerIOHandler;
class PASCALIMPLEMENTATION TIdServerIOHandler : public Idcomponent::TIdComponent
{
	typedef Idcomponent::TIdComponent inherited;
	
protected:
	Idscheduler::TIdScheduler* FScheduler;
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	virtual Idiohandler::TIdIOHandler* __fastcall Accept(Idsockethandle::TIdSocketHandle* ASocket, Idthread::TIdThread* AListenerThread, Idyarn::TIdYarn* AYarn);
	virtual Idiohandler::TIdIOHandler* __fastcall MakeClientIOHandler(Idyarn::TIdYarn* AYarn);
	virtual void __fastcall Init(void);
	virtual void __fastcall Shutdown(void);
	virtual void __fastcall SetScheduler(Idscheduler::TIdScheduler* AScheduler);
public:
	/* TIdComponent.Destroy */ inline __fastcall virtual ~TIdServerIOHandler(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdServerIOHandler(System::Classes::TComponent* AOwner)/* overload */ : Idcomponent::TIdComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdServerIOHandler(void)/* overload */ : Idcomponent::TIdComponent() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idserveriohandler */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSERVERIOHANDLER)
using namespace Idserveriohandler;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdserveriohandlerHPP
