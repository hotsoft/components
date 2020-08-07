// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCookie.pas' rev: 25.00 (Windows)

#ifndef IdcookieHPP
#define IdcookieHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobalProtocols.hpp>	// Pascal unit
#include <IdURI.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcookie
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdCookie;
class PASCALIMPLEMENTATION TIdCookie : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::UnicodeString FDomain;
	System::TDateTime FExpires;
	bool FHttpOnly;
	System::UnicodeString FName;
	System::UnicodeString FPath;
	bool FSecure;
	System::UnicodeString FValue;
	System::TDateTime FCreatedAt;
	bool FHostOnly;
	System::TDateTime FLastAccessed;
	bool FPersistent;
	bool __fastcall GetIsExpired(void);
	virtual System::UnicodeString __fastcall GetServerCookie(void);
	virtual System::UnicodeString __fastcall GetClientCookie(void);
	__int64 __fastcall GetMaxAge(void);
	
public:
	__fastcall virtual TIdCookie(System::Classes::TCollection* ACollection);
	__fastcall virtual ~TIdCookie(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual bool __fastcall IsAllowed(Iduri::TIdURI* AURI, bool SecureOnly);
	virtual bool __fastcall ParseClientCookie(const System::UnicodeString ACookieText);
	virtual bool __fastcall ParseServerCookie(const System::UnicodeString ACookieText, Iduri::TIdURI* AURI);
	__property System::UnicodeString ClientCookie = {read=GetClientCookie};
	__property System::UnicodeString CookieName = {read=FName, write=FName};
	__property System::UnicodeString CookieText = {read=GetServerCookie};
	__property System::UnicodeString Domain = {read=FDomain, write=FDomain};
	__property System::TDateTime Expires = {read=FExpires, write=FExpires};
	__property bool HttpOnly = {read=FHttpOnly, write=FHttpOnly, nodefault};
	__property System::UnicodeString Path = {read=FPath, write=FPath};
	__property bool Secure = {read=FSecure, write=FSecure, nodefault};
	__property System::UnicodeString ServerCookie = {read=GetServerCookie};
	__property System::UnicodeString Value = {read=FValue, write=FValue};
	__property __int64 MaxAge = {read=GetMaxAge};
	__property System::TDateTime CreatedAt = {read=FCreatedAt, write=FCreatedAt};
	__property bool IsExpired = {read=GetIsExpired, nodefault};
	__property bool HostOnly = {read=FHostOnly, write=FHostOnly, nodefault};
	__property System::TDateTime LastAccessed = {read=FLastAccessed, write=FLastAccessed};
	__property bool Persistent = {read=FPersistent, write=FPersistent, nodefault};
};


typedef System::TMetaClass* TIdCookieClass;

class DELPHICLASS TIdCookieList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdCookieList : public System::Classes::TList
{
	typedef System::Classes::TList inherited;
	
public:
	TIdCookie* operator[](int Index) { return Cookies[Index]; }
	
protected:
	TIdCookie* __fastcall GetCookie(int Index);
	void __fastcall SetCookie(int Index, TIdCookie* AValue);
	
public:
	int __fastcall IndexOfCookie(TIdCookie* ACookie);
	__property TIdCookie* Cookies[int Index] = {read=GetCookie, write=SetCookie/*, default*/};
public:
	/* TList.Destroy */ inline __fastcall virtual ~TIdCookieList(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TIdCookieList(void) : System::Classes::TList() { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TIdCookieAccess : unsigned char { caRead, caReadWrite };

class DELPHICLASS TIdCookies;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdCookies : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TIdCookie* operator[](int Index) { return Cookies[Index]; }
	
protected:
	TIdCookieList* FCookieList;
	System::Sysutils::TMultiReadExclusiveWriteSynchronizer* FRWLock;
	TIdCookie* __fastcall GetCookieByNameAndDomain(const System::UnicodeString AName, const System::UnicodeString ADomain);
	TIdCookie* __fastcall GetCookie(int Index);
	void __fastcall SetCookie(int Index, TIdCookie* const Value);
	
public:
	__fastcall TIdCookies(System::Classes::TPersistent* AOwner);
	__fastcall virtual ~TIdCookies(void);
	HIDESBASE TIdCookie* __fastcall Add(void);
	bool __fastcall AddCookie(TIdCookie* ACookie, Iduri::TIdURI* AURI, bool AReplaceOld = true);
	TIdCookie* __fastcall AddClientCookie(const System::UnicodeString ACookie);
	void __fastcall AddClientCookies(const System::UnicodeString ACookie)/* overload */;
	void __fastcall AddClientCookies(System::Classes::TStrings* const ACookies)/* overload */;
	TIdCookie* __fastcall AddServerCookie(const System::UnicodeString ACookie, Iduri::TIdURI* AURI);
	void __fastcall AddServerCookies(System::Classes::TStrings* const ACookies, Iduri::TIdURI* AURI);
	void __fastcall AddCookies(TIdCookies* ASource);
	virtual void __fastcall Assign(System::Classes::TPersistent* ASource);
	HIDESBASE void __fastcall Clear(void);
	int __fastcall GetCookieIndex(const System::UnicodeString AName, int FirstIndex = 0x0)/* overload */;
	int __fastcall GetCookieIndex(const System::UnicodeString AName, const System::UnicodeString ADomain, int FirstIndex = 0x0)/* overload */;
	TIdCookieList* __fastcall LockCookieList(TIdCookieAccess AAccessType);
	void __fastcall UnlockCookieList(TIdCookieAccess AAccessType);
	__property TIdCookie* Cookie[const System::UnicodeString AName][const System::UnicodeString ADomain] = {read=GetCookieByNameAndDomain};
	__property TIdCookie* Cookies[int Index] = {read=GetCookie, write=SetCookie/*, default*/};
};

#pragma pack(pop)

class DELPHICLASS EIdCookieError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdCookieError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdCookieError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdCookieError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdCookieError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdCookieError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCookieError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCookieError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdCookieError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdCookieError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCookieError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCookieError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCookieError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCookieError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdCookieError(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString __fastcall CanonicalizeHostName(const System::UnicodeString AHost);
extern DELPHI_PACKAGE bool __fastcall IsDomainMatch(const System::UnicodeString AUriHost, const System::UnicodeString ACookieDomain);
extern DELPHI_PACKAGE bool __fastcall IsPathMatch(const System::UnicodeString AUriPath, const System::UnicodeString ACookiePath);
}	/* namespace Idcookie */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCOOKIE)
using namespace Idcookie;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcookieHPP
