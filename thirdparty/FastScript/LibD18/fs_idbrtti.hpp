// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fs_idbrtti.pas' rev: 25.00 (Windows)

#ifndef Fs_idbrttiHPP
#define Fs_idbrttiHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <fs_iinterpreter.hpp>	// Pascal unit
#include <fs_itools.hpp>	// Pascal unit
#include <fs_iclassesrtti.hpp>	// Pascal unit
#include <fs_ievents.hpp>	// Pascal unit
#include <Data.DB.hpp>	// Pascal unit
#include <System.Types.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fs_idbrtti
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TfsDBRTTI;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsDBRTTI : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	/* TComponent.Create */ inline __fastcall virtual TfsDBRTTI(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TfsDBRTTI(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TfsDatasetNotifyEvent;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsDatasetNotifyEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(Data::Db::TDataSet* Dataset);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsDatasetNotifyEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsDatasetNotifyEvent(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TfsFilterRecordEvent;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsFilterRecordEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(Data::Db::TDataSet* DataSet, bool &Accept);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsFilterRecordEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsFilterRecordEvent(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TfsFieldGetTextEvent;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsFieldGetTextEvent : public Fs_iinterpreter::TfsCustomEvent
{
	typedef Fs_iinterpreter::TfsCustomEvent inherited;
	
public:
	void __fastcall DoEvent(Data::Db::TField* Sender, System::UnicodeString &Text, bool DisplayText);
	virtual void * __fastcall GetMethod(void);
public:
	/* TfsCustomEvent.Create */ inline __fastcall virtual TfsFieldGetTextEvent(System::TObject* AObject, Fs_iinterpreter::TfsProcVariable* AHandler) : Fs_iinterpreter::TfsCustomEvent(AObject, AHandler) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TfsFieldGetTextEvent(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Fs_idbrtti */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FS_IDBRTTI)
using namespace Fs_idbrtti;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fs_idbrttiHPP
