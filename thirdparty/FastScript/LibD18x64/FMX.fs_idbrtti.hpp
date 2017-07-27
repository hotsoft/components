// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FMX.fs_idbrtti.pas' rev: 25.00 (Windows)

#ifndef Fmx_Fs_idbrttiHPP
#define Fmx_Fs_idbrttiHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <FMX.fs_iinterpreter.hpp>	// Pascal unit
#include <FMX.fs_itools.hpp>	// Pascal unit
#include <FMX.fs_iclassesrtti.hpp>	// Pascal unit
#include <FMX.fs_ievents.hpp>	// Pascal unit
#include <Data.DB.hpp>	// Pascal unit
#include <FMX.Types.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fmx
{
namespace Fs_idbrtti
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfsDBRTTI;
class PASCALIMPLEMENTATION TfsDBRTTI : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfsDBRTTI(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfsDBRTTI(void) { }
	
};


class DELPHICLASS TfsDatasetNotifyEvent;
class PASCALIMPLEMENTATION TfsDatasetNotifyEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(Data::Db::TDataSet* Dataset);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsDatasetNotifyEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsDatasetNotifyEvent(void) { }
	
};


class DELPHICLASS TfsFilterRecordEvent;
class PASCALIMPLEMENTATION TfsFilterRecordEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(Data::Db::TDataSet* DataSet, bool &Accept);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsFilterRecordEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsFilterRecordEvent(void) { }
	
};


class DELPHICLASS TfsFieldGetTextEvent;
class PASCALIMPLEMENTATION TfsFieldGetTextEvent : public Fmx::Fs_iinterpreter::TfsCustomEvent
{
	typedef Fmx::Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(Data::Db::TField* Sender, System::UnicodeString &Text, bool DisplayText);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsFieldGetTextEvent(System::TObject* AObject, Fmx::Fs_iinterpreter::TfsProcVariable* AHandler) : Fmx::Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsFieldGetTextEvent(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fs_idbrtti */
}	/* namespace Fmx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX_FS_IDBRTTI)
using namespace Fmx::Fs_idbrtti;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX)
using namespace Fmx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fmx_Fs_idbrttiHPP
