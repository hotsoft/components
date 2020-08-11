// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdInterceptSimLog.pas' rev: 25.00 (Windows)

#ifndef IdinterceptsimlogHPP
#define IdinterceptsimlogHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdIntercept.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idinterceptsimlog
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdInterceptSimLog;
class PASCALIMPLEMENTATION TIdInterceptSimLog : public Idintercept::TIdConnectionIntercept
{
	typedef Idintercept::TIdConnectionIntercept inherited;
	
protected:
	System::UnicodeString FFilename;
	System::Classes::TStream* FStream;
	void __fastcall SetFilename(const System::UnicodeString AValue);
	void __fastcall WriteRecord(const System::UnicodeString ATag, const Idglobal::TIdBytes ABuffer);
	
public:
	virtual void __fastcall Connect(System::Classes::TComponent* AConnection);
	virtual void __fastcall Disconnect(void);
	virtual void __fastcall Receive(Idglobal::TIdBytes &ABuffer);
	virtual void __fastcall Send(Idglobal::TIdBytes &ABuffer);
	
__published:
	__property System::UnicodeString Filename = {read=FFilename, write=SetFilename};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdInterceptSimLog(System::Classes::TComponent* AOwner)/* overload */ : Idintercept::TIdConnectionIntercept(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdInterceptSimLog(void)/* overload */ : Idintercept::TIdConnectionIntercept() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdInterceptSimLog(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idinterceptsimlog */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDINTERCEPTSIMLOG)
using namespace Idinterceptsimlog;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdinterceptsimlogHPP
