// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSchedulerOfThreadDefault.pas' rev: 25.00 (Windows)

#ifndef IdschedulerofthreaddefaultHPP
#define IdschedulerofthreaddefaultHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdSchedulerOfThread.hpp>	// Pascal unit
#include <IdScheduler.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idschedulerofthreaddefault
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdSchedulerOfThreadDefault;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSchedulerOfThreadDefault : public Idschedulerofthread::TIdSchedulerOfThread
{
	typedef Idschedulerofthread::TIdSchedulerOfThread inherited;
	
public:
	virtual Idyarn::TIdYarn* __fastcall AcquireYarn(void);
	virtual void __fastcall ReleaseYarn(Idyarn::TIdYarn* AYarn);
	virtual Idthread::TIdThreadWithTask* __fastcall NewThread(void);
public:
	/* TIdSchedulerOfThread.Destroy */ inline __fastcall virtual ~TIdSchedulerOfThreadDefault(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSchedulerOfThreadDefault(System::Classes::TComponent* AOwner)/* overload */ : Idschedulerofthread::TIdSchedulerOfThread(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSchedulerOfThreadDefault(void)/* overload */ : Idschedulerofthread::TIdSchedulerOfThread() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idschedulerofthreaddefault */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSCHEDULEROFTHREADDEFAULT)
using namespace Idschedulerofthreaddefault;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdschedulerofthreaddefaultHPP
