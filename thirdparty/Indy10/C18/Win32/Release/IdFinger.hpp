// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdFinger.pas' rev: 25.00 (Windows)

#ifndef IdfingerHPP
#define IdfingerHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idfinger
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdFinger;
class PASCALIMPLEMENTATION TIdFinger : public Idtcpclient::TIdTCPClientCustom
{
	typedef Idtcpclient::TIdTCPClientCustom inherited;
	
protected:
	System::UnicodeString FQuery;
	bool FVerboseOutput;
	void __fastcall SetCompleteQuery(System::UnicodeString AQuery);
	System::UnicodeString __fastcall GetCompleteQuery(void);
	virtual void __fastcall InitComponent(void);
	
public:
	System::UnicodeString __fastcall Finger(void);
	
__published:
	__property Port = {default=79};
	__property Host = {default=0};
	__property System::UnicodeString Query = {read=FQuery, write=FQuery};
	__property System::UnicodeString CompleteQuery = {read=GetCompleteQuery, write=SetCompleteQuery};
	__property bool VerboseOutput = {read=FVerboseOutput, write=FVerboseOutput, default=0};
public:
	/* TIdTCPConnection.Destroy */ inline __fastcall virtual ~TIdFinger(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdFinger(System::Classes::TComponent* AOwner)/* overload */ : Idtcpclient::TIdTCPClientCustom(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdFinger(void)/* overload */ : Idtcpclient::TIdTCPClientCustom() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idfinger */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDFINGER)
using namespace Idfinger;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdfingerHPP
