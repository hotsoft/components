// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdServerIOHandlerStack.pas' rev: 25.00 (Windows)

#ifndef IdserveriohandlerstackHPP
#define IdserveriohandlerstackHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdServerIOHandler.hpp>	// Pascal unit
#include <IdStackConsts.hpp>	// Pascal unit
#include <IdIOHandler.hpp>	// Pascal unit
#include <IdScheduler.hpp>	// Pascal unit
#include <IdIOHandlerStack.hpp>	// Pascal unit
#include <IdServerIOHandlerSocket.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idserveriohandlerstack
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdServerIOHandlerStack;
class PASCALIMPLEMENTATION TIdServerIOHandlerStack : public Idserveriohandlersocket::TIdServerIOHandlerSocket
{
	typedef Idserveriohandlersocket::TIdServerIOHandlerSocket inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
	
public:
	virtual Idiohandler::TIdIOHandler* __fastcall MakeClientIOHandler(Idyarn::TIdYarn* ATheThread);
public:
	/* TIdComponent.Destroy */ inline __fastcall virtual ~TIdServerIOHandlerStack(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdServerIOHandlerStack(System::Classes::TComponent* AOwner)/* overload */ : Idserveriohandlersocket::TIdServerIOHandlerSocket(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdServerIOHandlerStack(void)/* overload */ : Idserveriohandlersocket::TIdServerIOHandlerSocket() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idserveriohandlerstack */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSERVERIOHANDLERSTACK)
using namespace Idserveriohandlerstack;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdserveriohandlerstackHPP
