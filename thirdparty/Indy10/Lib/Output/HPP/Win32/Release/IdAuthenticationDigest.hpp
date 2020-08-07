// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdAuthenticationDigest.pas' rev: 25.00 (Windows)

#ifndef IdauthenticationdigestHPP
#define IdauthenticationdigestHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAuthentication.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdHashMessageDigest.hpp>	// Pascal unit
#include <IdHeaderList.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#pragma link "IdAuthenticationDigest"

namespace Idauthenticationdigest
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdInvalidAlgorithm;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdInvalidAlgorithm : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdInvalidAlgorithm(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdInvalidAlgorithm(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidAlgorithm(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidAlgorithm(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidAlgorithm(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidAlgorithm(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdInvalidAlgorithm(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdInvalidAlgorithm(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidAlgorithm(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidAlgorithm(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidAlgorithm(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidAlgorithm(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdInvalidAlgorithm(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdDigestAuthentication;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdDigestAuthentication : public Idauthentication::TIdAuthentication
{
	typedef Idauthentication::TIdAuthentication inherited;
	
protected:
	System::UnicodeString FRealm;
	bool FStale;
	System::UnicodeString FOpaque;
	System::Classes::TStringList* FDomain;
	System::UnicodeString FNonce;
	int FNonceCount;
	System::UnicodeString FAlgorithm;
	System::UnicodeString FMethod;
	System::UnicodeString FUri;
	System::UnicodeString FEntityBody;
	System::Classes::TStringList* FQopOptions;
	System::Classes::TStringList* FOther;
	virtual Idauthentication::TIdAuthWhatsNext __fastcall DoNext(void);
	virtual int __fastcall GetSteps(void);
	
public:
	__fastcall virtual TIdDigestAuthentication(void);
	__fastcall virtual ~TIdDigestAuthentication(void);
	virtual System::UnicodeString __fastcall Authentication(void);
	virtual void __fastcall SetRequest(const System::UnicodeString AMethod, const System::UnicodeString AUri);
	__property System::UnicodeString Method = {read=FMethod, write=FMethod};
	__property System::UnicodeString Uri = {read=FUri, write=FUri};
	__property System::UnicodeString EntityBody = {read=FEntityBody, write=FEntityBody};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idauthenticationdigest */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDAUTHENTICATIONDIGEST)
using namespace Idauthenticationdigest;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdauthenticationdigestHPP
