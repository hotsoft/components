// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdInterceptThrottler.pas' rev: 25.00 (Windows)

#ifndef IdinterceptthrottlerHPP
#define IdinterceptthrottlerHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdIntercept.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idinterceptthrottler
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdInterceptThrottler;
class PASCALIMPLEMENTATION TIdInterceptThrottler : public Idintercept::TIdConnectionIntercept
{
	typedef Idintercept::TIdConnectionIntercept inherited;
	
protected:
	int FBitsPerSec;
	int FRecvBitsPerSec;
	int FSendBitsPerSec;
	void __fastcall SetBitsPerSec(int AValue);
	
public:
	virtual void __fastcall Receive(Idglobal::TIdBytes &ABuffer);
	virtual void __fastcall Send(Idglobal::TIdBytes &ABuffer);
	
__published:
	__property int BitsPerSec = {read=FBitsPerSec, write=SetBitsPerSec, nodefault};
	__property int RecvBitsPerSec = {read=FRecvBitsPerSec, write=FRecvBitsPerSec, nodefault};
	__property int SendBitsPerSec = {read=FSendBitsPerSec, write=FSendBitsPerSec, nodefault};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdInterceptThrottler(System::Classes::TComponent* AOwner)/* overload */ : Idintercept::TIdConnectionIntercept(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdInterceptThrottler(void)/* overload */ : Idintercept::TIdConnectionIntercept() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdInterceptThrottler(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idinterceptthrottler */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDINTERCEPTTHROTTLER)
using namespace Idinterceptthrottler;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdinterceptthrottlerHPP
