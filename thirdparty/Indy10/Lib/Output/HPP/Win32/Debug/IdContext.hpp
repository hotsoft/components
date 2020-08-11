// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdContext.pas' rev: 25.00 (Windows)

#ifndef IdcontextHPP
#define IdcontextHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdTask.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit
#include <IdThreadSafe.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcontext
{
//-- type declarations -------------------------------------------------------
typedef System::TMetaClass* TIdContextClass;

class DELPHICLASS TIdContext;
typedef bool __fastcall (__closure *TIdContextRun)(TIdContext* AContext);

typedef void __fastcall (__closure *TIdContextEvent)(TIdContext* AContext);

typedef void __fastcall (__closure *TIdContextExceptionEvent)(TIdContext* AContext, System::Sysutils::Exception* AException);

typedef Idthreadsafe::TIdThreadSafeObjectList TIdContextThreadList;

typedef System::Classes::TList TIdContextList;

class PASCALIMPLEMENTATION TIdContext : public Idtask::TIdTask
{
	typedef Idtask::TIdTask inherited;
	
protected:
	Idthreadsafe::TIdThreadSafeObjectList* FContextList;
	Idtcpconnection::TIdTCPConnection* FConnection;
	bool FOwnsConnection;
	TIdContextRun FOnRun;
	TIdContextEvent FOnBeforeRun;
	TIdContextEvent FOnAfterRun;
	TIdContextExceptionEvent FOnException;
	virtual void __fastcall BeforeRun(void);
	virtual bool __fastcall Run(void);
	virtual void __fastcall AfterRun(void);
	virtual void __fastcall HandleException(System::Sysutils::Exception* AException);
	Idsockethandle::TIdSocketHandle* __fastcall GetBinding(void);
	
public:
	__fastcall virtual TIdContext(Idtcpconnection::TIdTCPConnection* AConnection, Idyarn::TIdYarn* AYarn, Idthreadsafe::TIdThreadSafeObjectList* AList);
	__fastcall virtual ~TIdContext(void);
	void __fastcall RemoveFromList(void);
	__property Idsockethandle::TIdSocketHandle* Binding = {read=GetBinding};
	__property Idtcpconnection::TIdTCPConnection* Connection = {read=FConnection};
	__property TIdContextEvent OnAfterRun = {read=FOnAfterRun, write=FOnAfterRun};
	__property TIdContextEvent OnBeforeRun = {read=FOnBeforeRun, write=FOnBeforeRun};
	__property TIdContextRun OnRun = {read=FOnRun, write=FOnRun};
	__property TIdContextExceptionEvent OnException = {read=FOnException, write=FOnException};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idcontext */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCONTEXT)
using namespace Idcontext;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcontextHPP
