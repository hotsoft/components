// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdEcho.pas' rev: 25.00 (Windows)

#ifndef IdechoHPP
#define IdechoHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idecho
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdEcho;
class PASCALIMPLEMENTATION TIdEcho : public Idtcpclient::TIdTCPClient
{
	typedef Idtcpclient::TIdTCPClient inherited;
	
protected:
	unsigned FEchoTime;
	virtual void __fastcall InitComponent(void);
	
public:
	System::UnicodeString __fastcall Echo(const System::UnicodeString AText);
	__property unsigned EchoTime = {read=FEchoTime, nodefault};
	
__published:
	__property Port = {default=7};
public:
	/* TIdTCPConnection.Destroy */ inline __fastcall virtual ~TIdEcho(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdEcho(System::Classes::TComponent* AOwner)/* overload */ : Idtcpclient::TIdTCPClient(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdEcho(void)/* overload */ : Idtcpclient::TIdTCPClient() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idecho */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDECHO)
using namespace Idecho;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdechoHPP
