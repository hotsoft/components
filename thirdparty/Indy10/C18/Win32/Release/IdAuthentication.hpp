// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdAuthentication.pas' rev: 25.00 (Windows)

#ifndef IdauthenticationHPP
#define IdauthenticationHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdHeaderList.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idauthentication
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdAuthenticationSchemes : unsigned char { asBasic, asDigest, asNTLM, asUnknown };

typedef System::Set<TIdAuthenticationSchemes, TIdAuthenticationSchemes::asBasic, TIdAuthenticationSchemes::asUnknown>  TIdAuthSchemeSet;

enum DECLSPEC_DENUM TIdAuthWhatsNext : unsigned char { wnAskTheProgram, wnDoRequest, wnFail };

class DELPHICLASS TIdAuthentication;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdAuthentication : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	int FCurrentStep;
	Idheaderlist::TIdHeaderList* FParams;
	Idheaderlist::TIdHeaderList* FAuthParams;
	System::UnicodeString FCharset;
	System::UnicodeString __fastcall ReadAuthInfo(System::UnicodeString AuthName);
	virtual TIdAuthWhatsNext __fastcall DoNext(void) = 0 ;
	void __fastcall SetAuthParams(Idheaderlist::TIdHeaderList* AValue);
	System::UnicodeString __fastcall GetPassword(void);
	System::UnicodeString __fastcall GetUserName(void);
	virtual int __fastcall GetSteps(void);
	virtual void __fastcall SetPassword(const System::UnicodeString Value);
	virtual void __fastcall SetUserName(const System::UnicodeString Value);
	
public:
	__fastcall virtual TIdAuthentication(void);
	__fastcall virtual ~TIdAuthentication(void);
	virtual void __fastcall Reset(void);
	virtual void __fastcall SetRequest(const System::UnicodeString AMethod, const System::UnicodeString AUri);
	virtual System::UnicodeString __fastcall Authentication(void) = 0 ;
	virtual bool __fastcall KeepAlive(void);
	TIdAuthWhatsNext __fastcall Next(void);
	__property Idheaderlist::TIdHeaderList* AuthParams = {read=FAuthParams, write=SetAuthParams};
	__property Idheaderlist::TIdHeaderList* Params = {read=FParams};
	__property System::UnicodeString Username = {read=GetUserName, write=SetUserName};
	__property System::UnicodeString Password = {read=GetPassword, write=SetPassword};
	__property int Steps = {read=GetSteps, nodefault};
	__property int CurrentStep = {read=FCurrentStep, nodefault};
};

#pragma pack(pop)

typedef System::TMetaClass* TIdAuthenticationClass;

class DELPHICLASS TIdBasicAuthentication;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdBasicAuthentication : public TIdAuthentication
{
	typedef TIdAuthentication inherited;
	
protected:
	System::UnicodeString FRealm;
	virtual TIdAuthWhatsNext __fastcall DoNext(void);
	virtual int __fastcall GetSteps(void);
	
public:
	virtual System::UnicodeString __fastcall Authentication(void);
	__property System::UnicodeString Realm = {read=FRealm, write=FRealm};
public:
	/* TIdAuthentication.Create */ inline __fastcall virtual TIdBasicAuthentication(void) : TIdAuthentication() { }
	/* TIdAuthentication.Destroy */ inline __fastcall virtual ~TIdBasicAuthentication(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdAlreadyRegisteredAuthenticationMethod;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdAlreadyRegisteredAuthenticationMethod : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdAlreadyRegisteredAuthenticationMethod(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdAlreadyRegisteredAuthenticationMethod(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdAlreadyRegisteredAuthenticationMethod(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdAlreadyRegisteredAuthenticationMethod(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdAlreadyRegisteredAuthenticationMethod(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdAlreadyRegisteredAuthenticationMethod(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdAlreadyRegisteredAuthenticationMethod(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdAlreadyRegisteredAuthenticationMethod(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdAlreadyRegisteredAuthenticationMethod(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdAlreadyRegisteredAuthenticationMethod(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdAlreadyRegisteredAuthenticationMethod(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdAlreadyRegisteredAuthenticationMethod(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdAlreadyRegisteredAuthenticationMethod(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall RegisterAuthenticationMethod(const System::UnicodeString MethodName, const TIdAuthenticationClass AuthClass);
extern DELPHI_PACKAGE void __fastcall UnregisterAuthenticationMethod(const System::UnicodeString MethodName);
extern DELPHI_PACKAGE TIdAuthenticationClass __fastcall FindAuthClass(const System::UnicodeString AuthName);
}	/* namespace Idauthentication */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDAUTHENTICATION)
using namespace Idauthentication;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdauthenticationHPP
