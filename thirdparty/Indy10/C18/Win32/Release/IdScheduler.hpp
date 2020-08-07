// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdScheduler.pas' rev: 25.00 (Windows)

#ifndef IdschedulerHPP
#define IdschedulerHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdTask.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit
#include <IdThreadSafe.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idscheduler
{
//-- type declarations -------------------------------------------------------
typedef Idthreadsafe::TIdThreadSafeObjectList TIdYarnThreadList;

typedef System::Classes::TList TIdYarnList;

class DELPHICLASS TIdScheduler;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdScheduler : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
protected:
	Idthreadsafe::TIdThreadSafeObjectList* FActiveYarns;
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall virtual ~TIdScheduler(void);
	virtual Idyarn::TIdYarn* __fastcall AcquireYarn(void) = 0 ;
	virtual void __fastcall Init(void);
	virtual void __fastcall ReleaseYarn(Idyarn::TIdYarn* AYarn);
	virtual void __fastcall StartYarn(Idyarn::TIdYarn* AYarn, Idtask::TIdTask* ATask) = 0 ;
	virtual void __fastcall TerminateYarn(Idyarn::TIdYarn* AYarn) = 0 ;
	virtual void __fastcall TerminateAllYarns(void);
	__property Idthreadsafe::TIdThreadSafeObjectList* ActiveYarns = {read=FActiveYarns};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdScheduler(System::Classes::TComponent* AOwner)/* overload */ : Idbasecomponent::TIdBaseComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdScheduler(void)/* overload */ : Idbasecomponent::TIdBaseComponent() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idscheduler */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSCHEDULER)
using namespace Idscheduler;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdschedulerHPP
