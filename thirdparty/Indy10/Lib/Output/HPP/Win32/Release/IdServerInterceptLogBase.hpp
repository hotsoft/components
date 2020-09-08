// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdServerInterceptLogBase.pas' rev: 25.00 (Windows)

#ifndef IdserverinterceptlogbaseHPP
#define IdserverinterceptlogbaseHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdIntercept.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdLogBase.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idserverinterceptlogbase
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdServerInterceptLogBase;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdServerInterceptLogBase : public Idintercept::TIdServerIntercept
{
	typedef Idintercept::TIdServerIntercept inherited;
	
protected:
	Idglobal::TIdCriticalSection* FLock;
	bool FLogTime;
	bool FReplaceCRLF;
	bool FHasInit;
	virtual void __fastcall InitComponent(void);
	
public:
	virtual void __fastcall Init(void);
	virtual Idintercept::TIdConnectionIntercept* __fastcall Accept(System::Classes::TComponent* AConnection);
	__fastcall virtual ~TIdServerInterceptLogBase(void);
	virtual void __fastcall DoLogWriteString(const System::UnicodeString AText) = 0 ;
	virtual void __fastcall LogWriteString(const System::UnicodeString AText);
	
__published:
	__property bool LogTime = {read=FLogTime, write=FLogTime, default=1};
	__property bool ReplaceCRLF = {read=FReplaceCRLF, write=FReplaceCRLF, default=1};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdServerInterceptLogBase(System::Classes::TComponent* AOwner)/* overload */ : Idintercept::TIdServerIntercept(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdServerInterceptLogBase(void)/* overload */ : Idintercept::TIdServerIntercept() { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdServerInterceptLogFileConnection;
class PASCALIMPLEMENTATION TIdServerInterceptLogFileConnection : public Idlogbase::TIdLogBase
{
	typedef Idlogbase::TIdLogBase inherited;
	
protected:
	TIdServerInterceptLogBase* FServerInterceptLog;
	virtual void __fastcall LogReceivedData(const System::UnicodeString AText, const System::UnicodeString AData);
	virtual void __fastcall LogSentData(const System::UnicodeString AText, const System::UnicodeString AData);
	virtual void __fastcall LogStatus(const System::UnicodeString AText);
	virtual System::UnicodeString __fastcall GetConnectionID(void);
public:
	/* TIdLogBase.Destroy */ inline __fastcall virtual ~TIdServerInterceptLogFileConnection(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdServerInterceptLogFileConnection(System::Classes::TComponent* AOwner)/* overload */ : Idlogbase::TIdLogBase(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdServerInterceptLogFileConnection(void)/* overload */ : Idlogbase::TIdLogBase() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idserverinterceptlogbase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSERVERINTERCEPTLOGBASE)
using namespace Idserverinterceptlogbase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdserverinterceptlogbaseHPP
