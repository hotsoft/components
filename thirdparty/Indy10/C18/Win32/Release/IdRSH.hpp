// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdRSH.pas' rev: 25.00 (Windows)

#ifndef IdrshHPP
#define IdrshHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdRemoteCMDClient.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idrsh
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdRSH;
class PASCALIMPLEMENTATION TIdRSH : public Idremotecmdclient::TIdRemoteCMDClient
{
	typedef Idremotecmdclient::TIdRemoteCMDClient inherited;
	
protected:
	System::UnicodeString FClientUserName;
	System::UnicodeString FHostUserName;
	virtual void __fastcall InitComponent(void);
	
public:
	virtual System::UnicodeString __fastcall Execute(System::UnicodeString ACommand);
	
__published:
	__property System::UnicodeString ClientUserName = {read=FClientUserName, write=FClientUserName};
	__property Host = {default=0};
	__property System::UnicodeString HostUserName = {read=FHostUserName, write=FHostUserName};
	__property Port = {default=514};
	__property bool UseReservedPorts = {read=FUseReservedPorts, write=FUseReservedPorts, default=1};
public:
	/* TIdRemoteCMDClient.Destroy */ inline __fastcall virtual ~TIdRSH(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdRSH(System::Classes::TComponent* AOwner)/* overload */ : Idremotecmdclient::TIdRemoteCMDClient(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdRSH(void)/* overload */ : Idremotecmdclient::TIdRemoteCMDClient() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idrsh */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDRSH)
using namespace Idrsh;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdrshHPP
