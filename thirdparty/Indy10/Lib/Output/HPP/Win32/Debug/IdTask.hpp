// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTask.pas' rev: 25.00 (Windows)

#ifndef IdtaskHPP
#define IdtaskHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idtask
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdTask;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdTask : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	bool FBeforeRunDone;
	System::TObject* FData;
	Idyarn::TIdYarn* FYarn;
	virtual void __fastcall AfterRun(void);
	virtual void __fastcall BeforeRun(void);
	virtual bool __fastcall Run(void) = 0 ;
	virtual void __fastcall HandleException(System::Sysutils::Exception* AException);
	
public:
	__fastcall virtual TIdTask(Idyarn::TIdYarn* AYarn);
	__fastcall virtual ~TIdTask(void);
	void __fastcall DoAfterRun(void);
	void __fastcall DoBeforeRun(void);
	bool __fastcall DoRun(void);
	void __fastcall DoException(System::Sysutils::Exception* AException);
	__property bool BeforeRunDone = {read=FBeforeRunDone, nodefault};
	__property System::TObject* Data = {read=FData, write=FData};
	__property Idyarn::TIdYarn* Yarn = {read=FYarn};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idtask */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTASK)
using namespace Idtask;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtaskHPP
