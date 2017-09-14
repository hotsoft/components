// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwcollection.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwcollectionHPP
#define Vcl_WwcollectionHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.ActiveX.hpp>
#include <System.SysUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwcollection
{
//-- forward type declarations -----------------------------------------------
__interface IwwNavButtons;
typedef System::DelphiInterface<IwwNavButtons> _di_IwwNavButtons;
__interface IwwCollectionItem;
typedef System::DelphiInterface<IwwCollectionItem> _di_IwwCollectionItem;
__interface IwwCollection;
typedef System::DelphiInterface<IwwCollection> _di_IwwCollection;
class DELPHICLASS TwwCollectionItem;
class DELPHICLASS TwwCollection;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TwwUpdateNameEvent)(_di_IwwCollectionItem Item);

typedef void __fastcall (__closure *TwwSelectionMethod)(_di_IwwCollectionItem Item);

__interface  INTERFACE_UUID("{BCDB6D20-2D56-11D2-A5AC-00104B216B5B}") IwwNavButtons  : public System::IInterface 
{
	virtual void __fastcall AddInfoPowerDialogs(void) = 0 ;
};

__interface  INTERFACE_UUID("{D4CC0381-0B8D-11D2-A5AC-00104B216B5B}") IwwCollectionItem  : public System::IInterface 
{
	virtual _di_IwwCollection __fastcall GetCollection(void) = 0 ;
	virtual System::UnicodeString __fastcall GetDisplayName(void) = 0 ;
	virtual int __fastcall GetIndex(void) = 0 ;
	virtual System::Classes::TPersistent* __fastcall GetInstance(void) = 0 ;
	virtual void __fastcall SetIndex(int Value) = 0 ;
	__property int Index = {read=GetIndex, write=SetIndex};
	virtual void __fastcall SetOnUpdateName(TwwUpdateNameEvent Value) = 0 ;
	virtual void __fastcall SetSelectionMethod(TwwSelectionMethod Value) = 0 ;
	__property TwwUpdateNameEvent OnUpdateName = {write=SetOnUpdateName};
	__property TwwSelectionMethod SelectionMethod = {write=SetSelectionMethod};
};

__interface  INTERFACE_UUID("{D4CC0380-0B8D-11D2-A5AC-00104B216B5B}") IwwCollection  : public System::IInterface 
{
	virtual int __fastcall GetCount(void) = 0 ;
	virtual _di_IwwCollectionItem __fastcall GetItem(int Index) = 0 ;
	virtual _di_IwwCollectionItem __fastcall Add(void) = 0 ;
	virtual void __fastcall BeginUpdate(void) = 0 ;
	virtual void __fastcall Clear(void) = 0 ;
	virtual void __fastcall EndUpdate(void) = 0 ;
	virtual void __fastcall SetDesigner(Vcl::Controls::TControl* Value) = 0 ;
	__property int Count = {read=GetCount};
	__property Vcl::Controls::TControl* Designer = {write=SetDesigner};
	__property _di_IwwCollectionItem Items[int Index] = {read=GetItem};
};

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwCollectionItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
public:
	int __stdcall QueryInterface(const GUID &IID, /* out */ void *Obj);
	int __stdcall _AddRef(void);
	int __stdcall _Release(void);
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TwwCollectionItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TwwCollectionItem(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	int __stdcall QueryInterface(const GUID &IID, /* out */ void *Obj);
	int __stdcall _AddRef(void);
	int __stdcall _Release(void);
public:
	/* TCollection.Create */ inline __fastcall TwwCollection(System::Classes::TCollectionItemClass ItemClass) : System::Classes::TCollection(ItemClass) { }
	/* TCollection.Destroy */ inline __fastcall virtual ~TwwCollection(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwcollection */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWCOLLECTION)
using namespace Vcl::Wwcollection;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwcollectionHPP
