// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdConnectThroughHttpProxy.pas' rev: 25.00 (Windows)

#ifndef IdconnectthroughhttpproxyHPP
#define IdconnectthroughhttpproxyHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdCustomTransparentProxy.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdIOHandler.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idconnectthroughhttpproxy
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdConnectThroughHttpProxy;
class PASCALIMPLEMENTATION TIdConnectThroughHttpProxy : public Idcustomtransparentproxy::TIdCustomTransparentProxy
{
	typedef Idcustomtransparentproxy::TIdCustomTransparentProxy inherited;
	
private:
	bool FAuthorizationRequired;
	
protected:
	bool FEnabled;
	virtual bool __fastcall GetEnabled(void);
	virtual void __fastcall SetEnabled(bool AValue);
	virtual void __fastcall MakeConnection(Idiohandler::TIdIOHandler* AIOHandler, const System::UnicodeString AHost, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	virtual void __fastcall DoMakeConnection(Idiohandler::TIdIOHandler* AIOHandler, const System::UnicodeString AHost, const System::Word APort, const bool ALogin, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* ASource);
	
__published:
	__property Enabled;
	__property Host = {default=0};
	__property Port;
	__property ChainedProxy;
	__property Username = {default=0};
	__property Password = {default=0};
public:
	/* TIdComponent.Destroy */ inline __fastcall virtual ~TIdConnectThroughHttpProxy(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdConnectThroughHttpProxy(System::Classes::TComponent* AOwner)/* overload */ : Idcustomtransparentproxy::TIdCustomTransparentProxy(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdConnectThroughHttpProxy(void)/* overload */ : Idcustomtransparentproxy::TIdCustomTransparentProxy() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idconnectthroughhttpproxy */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCONNECTTHROUGHHTTPPROXY)
using namespace Idconnectthroughhttpproxy;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdconnectthroughhttpproxyHPP
