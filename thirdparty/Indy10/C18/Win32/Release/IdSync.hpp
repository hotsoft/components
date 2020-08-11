// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSync.pas' rev: 25.00 (Windows)

#ifndef IdsyncHPP
#define IdsyncHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsync
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdSync;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSync _DEPRECATED_ATTRIBUTE1("Use static TThread.Synchronize()")  : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	virtual void __fastcall DoSynchronize _DEPRECATED_ATTRIBUTE0 (void) = 0 ;
	
public:
	__fastcall virtual TIdSync _DEPRECATED_ATTRIBUTE0 (void);
	void __fastcall Synchronize _DEPRECATED_ATTRIBUTE0 (void);
	__classmethod void __fastcall SynchronizeMethod _DEPRECATED_ATTRIBUTE0 (System::Classes::TThreadMethod AMethod);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdSync(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdNotify;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdNotify : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	bool FMainThreadUsesNotify;
	virtual void __fastcall DoNotify(void) = 0 ;
	void __fastcall InternalDoNotify(void);
	
public:
	__fastcall virtual TIdNotify(void);
	void __fastcall Notify(void);
	__classmethod void __fastcall NotifyMethod(System::Classes::TThreadMethod AMethod, bool AForceQueue = false);
	__property bool MainThreadUsesNotify = {read=FMainThreadUsesNotify, write=FMainThreadUsesNotify, nodefault};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdNotify(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdNotifyMethod;
class PASCALIMPLEMENTATION TIdNotifyMethod _DEPRECATED_ATTRIBUTE1("Use static TThread.Queue()")  : public TIdNotify
{
	typedef TIdNotify inherited;
	
protected:
	System::Classes::TThreadMethod FMethod _DEPRECATED_ATTRIBUTE0 ;
	virtual void __fastcall DoNotify _DEPRECATED_ATTRIBUTE0 (void);
	
public:
	__fastcall virtual TIdNotifyMethod _DEPRECATED_ATTRIBUTE0 (System::Classes::TThreadMethod AMethod);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdNotifyMethod(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idsync */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSYNC)
using namespace Idsync;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsyncHPP
