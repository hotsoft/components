// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCookieManager.pas' rev: 25.00 (Windows)

#ifndef IdcookiemanagerHPP
#define IdcookiemanagerHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdCookie.hpp>	// Pascal unit
#include <IdHeaderList.hpp>	// Pascal unit
#include <IdURI.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcookiemanager
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TOnNewCookieEvent)(System::TObject* ASender, Idcookie::TIdCookie* ACookie, bool &VAccept);

typedef void __fastcall (__closure *TOnCookieManagerEvent)(System::TObject* ASender, Idcookie::TIdCookies* ACookieCollection);

typedef TOnCookieManagerEvent TOnCookieCreateEvent;

typedef TOnCookieManagerEvent TOnCookieDestroyEvent;

class DELPHICLASS TIdCookieManager;
class PASCALIMPLEMENTATION TIdCookieManager : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
protected:
	TOnCookieManagerEvent FOnCreate;
	TOnCookieManagerEvent FOnDestroy;
	TOnNewCookieEvent FOnNewCookie;
	Idcookie::TIdCookies* FCookieCollection;
	void __fastcall CleanupCookieList(void);
	virtual void __fastcall DoOnCreate(void);
	virtual void __fastcall DoOnDestroy(void);
	virtual bool __fastcall DoOnNewCookie(Idcookie::TIdCookie* ACookie);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall virtual ~TIdCookieManager(void);
	void __fastcall AddServerCookie(const System::UnicodeString ACookie, Iduri::TIdURI* AURL);
	void __fastcall AddServerCookies(System::Classes::TStrings* const ACookies, Iduri::TIdURI* AURL);
	void __fastcall AddCookies(TIdCookieManager* ASource);
	void __fastcall CopyCookie(Idcookie::TIdCookie* ACookie);
	void __fastcall GenerateClientCookies(Iduri::TIdURI* AURL, bool SecureOnly, Idheaderlist::TIdHeaderList* Headers);
	__property Idcookie::TIdCookies* CookieCollection = {read=FCookieCollection};
	
__published:
	__property TOnCookieManagerEvent OnCreate = {read=FOnCreate, write=FOnCreate};
	__property TOnCookieManagerEvent OnDestroy = {read=FOnDestroy, write=FOnDestroy};
	__property TOnNewCookieEvent OnNewCookie = {read=FOnNewCookie, write=FOnNewCookie};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdCookieManager(System::Classes::TComponent* AOwner)/* overload */ : Idbasecomponent::TIdBaseComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdCookieManager(void)/* overload */ : Idbasecomponent::TIdBaseComponent() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idcookiemanager */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCOOKIEMANAGER)
using namespace Idcookiemanager;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcookiemanagerHPP
