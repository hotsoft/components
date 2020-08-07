// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSchedulerOfThreadPool.pas' rev: 25.00 (Windows)

#ifndef IdschedulerofthreadpoolHPP
#define IdschedulerofthreadpoolHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdScheduler.hpp>	// Pascal unit
#include <IdSchedulerOfThread.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idschedulerofthreadpool
{
//-- type declarations -------------------------------------------------------
typedef System::Classes::TThreadList TIdPoolThreadList;

typedef System::Classes::TList TIdPoolList;

class DELPHICLASS TIdSchedulerOfThreadPool;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSchedulerOfThreadPool : public Idschedulerofthread::TIdSchedulerOfThread
{
	typedef Idschedulerofthread::TIdSchedulerOfThread inherited;
	
protected:
	int FPoolSize;
	System::Classes::TThreadList* FThreadPool;
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall virtual ~TIdSchedulerOfThreadPool(void);
	virtual Idyarn::TIdYarn* __fastcall AcquireYarn(void);
	virtual void __fastcall Init(void);
	virtual Idthread::TIdThreadWithTask* __fastcall NewThread(void);
	virtual void __fastcall ReleaseYarn(Idyarn::TIdYarn* AYarn);
	virtual void __fastcall TerminateAllYarns(void);
	
__published:
	__property int PoolSize = {read=FPoolSize, write=FPoolSize, default=0};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSchedulerOfThreadPool(System::Classes::TComponent* AOwner)/* overload */ : Idschedulerofthread::TIdSchedulerOfThread(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSchedulerOfThreadPool(void)/* overload */ : Idschedulerofthread::TIdSchedulerOfThread() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idschedulerofthreadpool */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSCHEDULEROFTHREADPOOL)
using namespace Idschedulerofthreadpool;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdschedulerofthreadpoolHPP
