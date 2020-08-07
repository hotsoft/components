// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSchedulerOfThread.pas' rev: 25.00 (Windows)

#ifndef IdschedulerofthreadHPP
#define IdschedulerofthreadHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdScheduler.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdTask.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idschedulerofthread
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdYarnOfThread;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdYarnOfThread : public Idyarn::TIdYarn
{
	typedef Idyarn::TIdYarn inherited;
	
protected:
	Idscheduler::TIdScheduler* FScheduler;
	Idthread::TIdThreadWithTask* FThread;
	
public:
	__fastcall TIdYarnOfThread(Idscheduler::TIdScheduler* AScheduler, Idthread::TIdThreadWithTask* AThread);
	__fastcall virtual ~TIdYarnOfThread(void);
	__property Idthread::TIdThreadWithTask* Thread = {read=FThread};
};

#pragma pack(pop)

class DELPHICLASS TIdSchedulerOfThread;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSchedulerOfThread : public Idscheduler::TIdScheduler
{
	typedef Idscheduler::TIdScheduler inherited;
	
protected:
	int FMaxThreads;
	System::Classes::TThreadPriority FThreadPriority;
	Idthread::TIdThreadWithTaskClass FThreadClass;
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall virtual ~TIdSchedulerOfThread(void);
	virtual Idthread::TIdThreadWithTask* __fastcall NewThread(void);
	TIdYarnOfThread* __fastcall NewYarn(Idthread::TIdThreadWithTask* AThread = (Idthread::TIdThreadWithTask*)(0x0));
	virtual void __fastcall StartYarn(Idyarn::TIdYarn* AYarn, Idtask::TIdTask* ATask);
	virtual void __fastcall TerminateYarn(Idyarn::TIdYarn* AYarn);
	__property Idthread::TIdThreadWithTaskClass ThreadClass = {read=FThreadClass, write=FThreadClass};
	
__published:
	__property int MaxThreads = {read=FMaxThreads, write=FMaxThreads, nodefault};
	__property System::Classes::TThreadPriority ThreadPriority = {read=FThreadPriority, write=FThreadPriority, default=3};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSchedulerOfThread(System::Classes::TComponent* AOwner)/* overload */ : Idscheduler::TIdScheduler(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSchedulerOfThread(void)/* overload */ : Idscheduler::TIdScheduler() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idschedulerofthread */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSCHEDULEROFTHREAD)
using namespace Idschedulerofthread;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdschedulerofthreadHPP
