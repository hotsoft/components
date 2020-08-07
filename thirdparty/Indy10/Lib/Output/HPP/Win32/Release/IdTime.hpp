// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTime.pas' rev: 25.00 (Windows)

#ifndef IdtimeHPP
#define IdtimeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdGlobalProtocols.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idtime
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdCustomTime;
class PASCALIMPLEMENTATION TIdCustomTime : public Idtcpclient::TIdTCPClientCustom
{
	typedef Idtcpclient::TIdTCPClientCustom inherited;
	
protected:
	System::TDateTime FBaseDate;
	unsigned FRoundTripDelay;
	int FTimeout;
	unsigned __fastcall GetDateTimeCard(void);
	System::TDateTime __fastcall GetDateTime(void);
	virtual void __fastcall InitComponent(void);
	
public:
	bool __fastcall SyncTime(void);
	__property unsigned DateTimeCard = {read=GetDateTimeCard, nodefault};
	__property System::TDateTime DateTime = {read=GetDateTime};
	__property unsigned RoundTripDelay = {read=FRoundTripDelay, nodefault};
	
__published:
	__property int Timeout = {read=FTimeout, write=FTimeout, default=2500};
	__property Host = {default=0};
public:
	/* TIdTCPConnection.Destroy */ inline __fastcall virtual ~TIdCustomTime(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdCustomTime(System::Classes::TComponent* AOwner)/* overload */ : Idtcpclient::TIdTCPClientCustom(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdCustomTime(void)/* overload */ : Idtcpclient::TIdTCPClientCustom() { }
	
};


class DELPHICLASS TIdTime;
class PASCALIMPLEMENTATION TIdTime : public TIdCustomTime
{
	typedef TIdCustomTime inherited;
	
__published:
	__property System::TDateTime BaseDate = {read=FBaseDate, write=FBaseDate};
	__property int Timeout = {read=FTimeout, write=FTimeout, default=2500};
	__property Port = {default=37};
public:
	/* TIdTCPConnection.Destroy */ inline __fastcall virtual ~TIdTime(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdTime(System::Classes::TComponent* AOwner)/* overload */ : TIdCustomTime(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdTime(void)/* overload */ : TIdCustomTime() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Word TIME_TIMEOUT = System::Word(0x9c4);
}	/* namespace Idtime */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTIME)
using namespace Idtime;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtimeHPP
