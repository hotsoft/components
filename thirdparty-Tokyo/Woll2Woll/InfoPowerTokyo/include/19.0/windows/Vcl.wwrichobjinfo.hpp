// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwrichobjinfo.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwrichobjinfoHPP
#define Vcl_WwrichobjinfoHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <System.Win.ComObj.hpp>
#include <Vcl.Forms.hpp>
#include <Winapi.RichEdit.hpp>
#include <vcl.wwrichole.hpp>
#include <Vcl.OleCtnrs.hpp>
#include <Winapi.ActiveX.hpp>
#include <Winapi.OleDlg.hpp>
#include <Vcl.OleConst.hpp>
#include <vcl.wwriched.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwrichobjinfo
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwOleUIObjInfo;
class DELPHICLASS TwwOleUILinkInfo;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwOleUIObjInfo : public System::TInterfacedObject
{
	typedef System::TInterfacedObject inherited;
	
private:
	Vcl::Wwriched::TwwCustomRichEdit* FRichEdit;
	Vcl::Wwrichole::TREOBJECT FReObject;
	
public:
	__fastcall TwwOleUIObjInfo(Vcl::Wwriched::TwwCustomRichEdit* RichEdit, const Vcl::Wwrichole::TREOBJECT &ReObject);
	HRESULT __stdcall GetObjectInfo(int dwObject, int &dwObjSize, System::WideChar * &lpszLabel, System::WideChar * &lpszType, System::WideChar * &lpszShortType, System::WideChar * &lpszLocation);
	HRESULT __stdcall GetConvertInfo(int dwObject, GUID &ClassID, System::Word &wFormat, GUID &ConvertDefaultClassID, System::PGUID &lpClsidExclude, int &cClsidExclude);
	HRESULT __stdcall ConvertObject(int dwObject, const GUID &clsidNew);
	HRESULT __stdcall GetViewInfo(int dwObject, NativeUInt &hMetaPict, int &dvAspect, int &nCurrentScale);
	HRESULT __stdcall SetViewInfo(int dwObject, NativeUInt hMetaPict, int dvAspect, int nCurrentScale, System::LongBool bRelativeToOrig);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TwwOleUIObjInfo(void) { }
	
private:
	void *__IOleUIObjInfo;	// IOleUIObjInfo 
	
public:
	operator IOleUIObjInfo*(void) { return (IOleUIObjInfo*)&__IOleUIObjInfo; }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwOleUILinkInfo : public System::TInterfacedObject
{
	typedef System::TInterfacedObject inherited;
	
private:
	Vcl::Wwrichole::TREOBJECT FReObject;
	Vcl::Wwriched::TwwCustomRichEdit* FRichEdit;
	_di_IOleLink FOleLink;
	
public:
	__fastcall TwwOleUILinkInfo(Vcl::Wwriched::TwwCustomRichEdit* RichEdit, const Vcl::Wwrichole::TREOBJECT &ReObject);
	int __stdcall GetNextLink(int dwLink);
	HRESULT __stdcall SetLinkUpdateOptions(int dwLink, int dwUpdateOpt);
	HRESULT __stdcall GetLinkUpdateOptions(int dwLink, int &dwUpdateOpt);
	HRESULT __stdcall SetLinkSource(int dwLink, System::WideChar * pszDisplayName, int lenFileName, int &chEaten, System::LongBool fValidateSource);
	HRESULT __stdcall GetLinkSource(int dwLink, System::WideChar * &pszDisplayName, int &lenFileName, System::WideChar * &pszFullLinkType, System::WideChar * &pszShortLinkType, System::LongBool &fSourceAvailable, System::LongBool &fIsSelected);
	HRESULT __stdcall OpenLinkSource(int dwLink);
	HRESULT __stdcall UpdateLink(int dwLink, System::LongBool fErrorMessage, System::LongBool fErrorAction);
	HRESULT __stdcall CancelLink(int dwLink);
	HRESULT __stdcall GetLastUpdate(int dwLink, _FILETIME &LastUpdate);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TwwOleUILinkInfo(void) { }
	
private:
	void *__IOleUILinkInfo;	// IOleUILinkInfo 
	
public:
	operator IOleUILinkInfo*(void) { return (IOleUILinkInfo*)&__IOleUILinkInfo; }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwrichobjinfo */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWRICHOBJINFO)
using namespace Vcl::Wwrichobjinfo;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwrichobjinfoHPP
