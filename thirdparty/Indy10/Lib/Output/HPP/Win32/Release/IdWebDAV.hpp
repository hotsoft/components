// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdWebDAV.pas' rev: 25.00 (Windows)

#ifndef IdwebdavHPP
#define IdwebdavHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdHTTP.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idwebdav
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdWebDAV;
class PASCALIMPLEMENTATION TIdWebDAV : public Idhttp::TIdHTTP
{
	typedef Idhttp::TIdHTTP inherited;
	
public:
	void __fastcall DAVCheckIn(const System::UnicodeString AURL, const System::UnicodeString AComment);
	void __fastcall DAVCheckOut(const System::UnicodeString AURL, System::Classes::TStream* const AXMLQuery, const System::UnicodeString AComment);
	void __fastcall DAVCopy(const System::UnicodeString AURL, const System::UnicodeString DURL, System::Classes::TStream* const AResponseContent, const bool AOverWrite = true, const System::UnicodeString ADepth = L"infinity");
	void __fastcall DAVDelete(const System::UnicodeString AURL, const System::UnicodeString ALockToken);
	void __fastcall DAVLabel(const System::UnicodeString AURL, System::Classes::TStream* const AXMLQuery);
	void __fastcall DAVLock(const System::UnicodeString AURL, System::Classes::TStream* const AXMLQuery, System::Classes::TStream* const AResponseContent, const System::UnicodeString ALockToken, const System::UnicodeString ATags, const System::UnicodeString ATimeOut = L"Infinite", const bool AMustExist = false, const System::UnicodeString ADepth = L"0");
	void __fastcall DAVMove(const System::UnicodeString AURL, const System::UnicodeString DURL, System::Classes::TStream* const AResponseContent, const bool AOverWrite = true, const System::UnicodeString ADepth = L"infinity");
	void __fastcall DAVOrderPatch(const System::UnicodeString AURL, System::Classes::TStream* const AXMLQuery);
	void __fastcall DAVPropFind(const System::UnicodeString AURL, System::Classes::TStream* const AXMLQuery, System::Classes::TStream* const AResponseContent, const System::UnicodeString ADepth = L"0", const int ARangeFrom = 0xffffffff, const int ARangeTo = 0xffffffff);
	void __fastcall DAVPropPatch(const System::UnicodeString AURL, System::Classes::TStream* const AXMLQuery, System::Classes::TStream* const AResponseContent, const System::UnicodeString ADepth = L"0");
	void __fastcall DAVPut(const System::UnicodeString AURL, System::Classes::TStream* const ASource, const System::UnicodeString ALockToken);
	void __fastcall DAVReport(const System::UnicodeString AURL, System::Classes::TStream* const AXMLQuery, System::Classes::TStream* const AResponseContent);
	void __fastcall DAVSearch(const System::UnicodeString AURL, const int ARangeFrom, const int ARangeTo, System::Classes::TStream* const AXMLQuery, System::Classes::TStream* const AResponseContent, const System::UnicodeString ADepth = L"0");
	void __fastcall DAVUnCheckOut(const System::UnicodeString AURL);
	void __fastcall DAVUnLock(const System::UnicodeString AURL, const System::UnicodeString ALockToken);
	void __fastcall DAVVersionControl(const System::UnicodeString AURL);
	void __fastcall DAVMakeCollection(const System::UnicodeString AURL);
public:
	/* TIdCustomHTTP.Destroy */ inline __fastcall virtual ~TIdWebDAV(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdWebDAV(System::Classes::TComponent* AOwner)/* overload */ : Idhttp::TIdHTTP(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdWebDAV(void)/* overload */ : Idhttp::TIdHTTP() { }
	
};


//-- var, const, procedure ---------------------------------------------------
#define Id_HTTPMethodPropFind L"PROPFIND"
#define Id_HTTPMethodPropPatch L"PROPPATCH"
#define Id_HTTPMethodOrderPatch L"ORDERPATCH"
#define Id_HTTPMethodSearch L"SEARCH"
#define Id_HTTPMethodMKCol L"MKCOL"
#define Id_HTTPMethodMove L"MOVE"
#define Id_HTTPMethodCopy L"COPY"
#define Id_HTTPMethodCheckIn L"CHECKIN"
#define Id_HTTPMethodCheckOut L"CHECKOUT"
#define Id_HTTPMethodUnCheckOut L"UNCHECKOUT"
#define Id_HTTPMethodLock L"LOCK"
#define Id_HTTPMethodUnLock L"UNLOCK"
#define Id_HTTPMethodReport L"REPORT"
#define Id_HTTPMethodVersion L"VERSION-CONTROL"
#define Id_HTTPMethodLabel L"LABEL"
#define Id_HTTPMethodMakeCol L"MKCOL"
#define cTimeoutInfinite L"Infinite"
#define cDepthInfinity L"infinity"
}	/* namespace Idwebdav */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDWEBDAV)
using namespace Idwebdav;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdwebdavHPP
