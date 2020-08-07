// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTimeUDP.pas' rev: 25.00 (Windows)

#ifndef IdtimeudpHPP
#define IdtimeudpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdUDPBase.hpp>	// Pascal unit
#include <IdGlobalProtocols.hpp>	// Pascal unit
#include <IdUDPClient.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idtimeudp
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdCustomTimeUDP;
class PASCALIMPLEMENTATION TIdCustomTimeUDP : public Idudpclient::TIdUDPClient
{
	typedef Idudpclient::TIdUDPClient inherited;
	
protected:
	System::TDateTime FBaseDate;
	unsigned FRoundTripDelay;
	unsigned __fastcall GetDateTimeCard(void);
	System::TDateTime __fastcall GetDateTime(void);
	virtual void __fastcall InitComponent(void);
	
public:
	bool __fastcall SyncTime(void);
	__property unsigned DateTimeCard = {read=GetDateTimeCard, nodefault};
	__property System::TDateTime DateTime = {read=GetDateTime};
	__property unsigned RoundTripDelay = {read=FRoundTripDelay, nodefault};
public:
	/* TIdUDPClient.Destroy */ inline __fastcall virtual ~TIdCustomTimeUDP(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdCustomTimeUDP(System::Classes::TComponent* AOwner)/* overload */ : Idudpclient::TIdUDPClient(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdCustomTimeUDP(void)/* overload */ : Idudpclient::TIdUDPClient() { }
	
};


class DELPHICLASS TIdTimeUDP;
class PASCALIMPLEMENTATION TIdTimeUDP : public TIdCustomTimeUDP
{
	typedef TIdCustomTimeUDP inherited;
	
__published:
	__property System::TDateTime BaseDate = {read=FBaseDate, write=FBaseDate};
	__property Port = {default=37};
public:
	/* TIdUDPClient.Destroy */ inline __fastcall virtual ~TIdTimeUDP(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdTimeUDP(System::Classes::TComponent* AOwner)/* overload */ : TIdCustomTimeUDP(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdTimeUDP(void)/* overload */ : TIdCustomTimeUDP() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idtimeudp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTIMEUDP)
using namespace Idtimeudp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtimeudpHPP
