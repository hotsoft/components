// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdUnixTime.pas' rev: 25.00 (Windows)

#ifndef IdunixtimeHPP
#define IdunixtimeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTime.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idunixtime
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdUnixTime;
class PASCALIMPLEMENTATION TIdUnixTime : public Idtime::TIdCustomTime
{
	typedef Idtime::TIdCustomTime inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdUnixTime(System::Classes::TComponent* AOwner)/* overload */;
	
__published:
	__property Port = {default=519};
public:
	/* TIdTCPConnection.Destroy */ inline __fastcall virtual ~TIdUnixTime(void) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdUnixTime(void)/* overload */ : Idtime::TIdCustomTime() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idunixtime */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDUNIXTIME)
using namespace Idunixtime;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdunixtimeHPP
