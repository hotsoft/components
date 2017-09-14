// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwrichole.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwricholeHPP
#define Vcl_WwricholeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.ActiveX.hpp>
#include <Winapi.RichEdit.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwrichole
{
//-- forward type declarations -----------------------------------------------
struct TREOBJECT;
__interface IRichEditOle;
typedef System::DelphiInterface<IRichEditOle> _di_IRichEditOle;
__interface IRichEditOleCallback;
typedef System::DelphiInterface<IRichEditOleCallback> _di_IRichEditOleCallback;
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD TREOBJECT
{
public:
	unsigned cbStruct;
	int cp;
	GUID clsid;
	_di_IOleObject oleobj;
	_di_IStorage stg;
	_di_IOleClientSite olesite;
	System::Types::TSize sizelL;
	unsigned dvaspect;
	unsigned dwFlags;
	unsigned dwUser;
};
#pragma pack(pop)


__interface  INTERFACE_UUID("{00020D00-0000-0000-C000-000000000046}") IRichEditOle  : public System::IInterface 
{
	virtual HRESULT __stdcall GetClientSite(/* out */ _di_IOleClientSite &lplpolesite) = 0 ;
	virtual int __stdcall GetObjectCount(void) = 0 ;
	virtual int __stdcall GetLinkCount(void) = 0 ;
	virtual HRESULT __stdcall GetObject(int iob, /* out */ TREOBJECT &reobject, unsigned dwFlags) = 0 ;
	virtual HRESULT __stdcall InsertObject(const TREOBJECT &reobject) = 0 ;
	virtual HRESULT __stdcall ConvertObject(int iob, const GUID &clsidNew, System::WideChar * lpStrUserTypeNew) = 0 ;
	virtual HRESULT __stdcall ActivateAs(const GUID &clsid, const GUID &clsidAs) = 0 ;
	virtual HRESULT __stdcall SetHostNames(System::WideChar * lpstrContainerApp, System::WideChar * lpstrContainerObj) = 0 ;
	virtual HRESULT __stdcall SetLinkAvailable(int iob, System::LongBool fAvailable) = 0 ;
	virtual HRESULT __stdcall SetDvaspect(int iob, unsigned dvaspect) = 0 ;
	virtual HRESULT __stdcall HandsOffStorage(int iob) = 0 ;
	virtual HRESULT __stdcall SaveCompleted(int iob, _di_IStorage stg) = 0 ;
	virtual HRESULT __stdcall InPlaceDeactivate(void) = 0 ;
	virtual HRESULT __stdcall ContextSensitiveHelp(System::LongBool fEnterMode) = 0 ;
	virtual HRESULT __stdcall GetClipboardData(const CHARRANGE &chrg, unsigned reco, /* out */ _di_IDataObject &dataobj) = 0 ;
	virtual HRESULT __stdcall ImportDataObject(_di_IDataObject dataobj, System::Word cf, NativeUInt hMetaPict) = 0 ;
};

__interface  INTERFACE_UUID("{00020D03-0000-0000-C000-000000000046}") IRichEditOleCallback  : public System::IInterface 
{
	virtual HRESULT __stdcall GetNewStorage(/* out */ _di_IStorage &stg) = 0 ;
	virtual HRESULT __stdcall GetInPlaceContext(/* out */ _di_IOleInPlaceFrame &Frame, /* out */ _di_IOleInPlaceUIWindow &Doc, tagOIFI &FrameInfo) = 0 ;
	virtual HRESULT __stdcall ShowContainerUI(System::LongBool fShow) = 0 ;
	virtual HRESULT __stdcall QueryInsertObject(const GUID &clsid, _di_IStorage stg, int cp) = 0 ;
	virtual HRESULT __stdcall DeleteObject(_di_IOleObject oleobj) = 0 ;
	virtual HRESULT __stdcall QueryAcceptData(_di_IDataObject dataobj, System::Word &cfFormat, unsigned reco, System::LongBool fReally, NativeUInt hMetaPict) = 0 ;
	virtual HRESULT __stdcall ContextSensitiveHelp(System::LongBool fEnterMode) = 0 ;
	virtual HRESULT __stdcall GetClipboardData(const CHARRANGE &chrg, unsigned reco, /* out */ _di_IDataObject &dataobj) = 0 ;
	virtual HRESULT __stdcall GetDragDropEffect(System::LongBool fDrag, unsigned grfKeyState, unsigned &dwEffect) = 0 ;
	virtual HRESULT __stdcall GetContextMenu(System::Word seltype, _di_IOleObject oleobj, const CHARRANGE &chrg, HMENU &menu) = 0 ;
};

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 REO_GETOBJ_NO_INTERFACES = System::Int8(0x0);
static const System::Int8 REO_GETOBJ_POLEOBJ = System::Int8(0x1);
static const System::Int8 REO_GETOBJ_PSTG = System::Int8(0x2);
static const System::Int8 REO_GETOBJ_POLESITE = System::Int8(0x4);
static const System::Int8 REO_GETOBJ_ALL_INTERFACES = System::Int8(0x7);
static const unsigned REO_CP_SELECTION = unsigned(0xffffffff);
static const unsigned REO_IOB_SELECTION = unsigned(0xffffffff);
static const unsigned REO_IOB_USE_CP = unsigned(0xfffffffe);
static const System::Int8 REO_NULL = System::Int8(0x0);
static const System::Int8 REO_READWRITEMASK = System::Int8(0x3f);
static const System::Int8 REO_DONTNEEDPALETTE = System::Int8(0x20);
static const System::Int8 REO_BLANK = System::Int8(0x10);
static const System::Int8 REO_DYNAMICSIZE = System::Int8(0x8);
static const System::Int8 REO_INVERTEDSELECT = System::Int8(0x4);
static const System::Int8 REO_BELOWBASELINE = System::Int8(0x2);
static const System::Int8 REO_RESIZABLE = System::Int8(0x1);
static const unsigned REO_LINK = unsigned(0x80000000);
static const int REO_STATIC = int(0x40000000);
static const int REO_SELECTED = int(0x8000000);
static const int REO_OPEN = int(0x4000000);
static const int REO_INPLACEACTIVE = int(0x2000000);
static const int REO_HILITED = int(0x1000000);
static const int REO_LINKAVAILABLE = int(0x800000);
static const int REO_GETMETAFILE = int(0x400000);
static const System::Int8 RECO_PASTE = System::Int8(0x0);
static const System::Int8 RECO_DROP = System::Int8(0x1);
static const System::Int8 RECO_COPY = System::Int8(0x2);
static const System::Int8 RECO_CUT = System::Int8(0x3);
static const System::Int8 RECO_DRAG = System::Int8(0x4);
extern DELPHI_PACKAGE System::LongBool __fastcall RichEdit_SetOleCallback(HWND RichEdit, _di_IRichEditOleCallback OleInterface);
extern DELPHI_PACKAGE System::LongBool __fastcall RichEdit_GetOleInterface(HWND RichEdit, /* out */ _di_IRichEditOle &OleInterface);
}	/* namespace Wwrichole */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWRICHOLE)
using namespace Vcl::Wwrichole;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwricholeHPP
