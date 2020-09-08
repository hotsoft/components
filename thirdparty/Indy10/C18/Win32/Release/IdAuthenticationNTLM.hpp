// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdAuthenticationNTLM.pas' rev: 25.00 (Windows)

#ifndef IdauthenticationntlmHPP
#define IdauthenticationntlmHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAuthentication.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#pragma link "IdAuthenticationNTLM"

namespace Idauthenticationntlm
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdNTLMAuthentication;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdNTLMAuthentication : public Idauthentication::TIdAuthentication
{
	typedef Idauthentication::TIdAuthentication inherited;
	
protected:
	System::UnicodeString FNTLMInfo;
	System::UnicodeString FHost;
	System::UnicodeString FDomain;
	System::UnicodeString FUser;
	virtual Idauthentication::TIdAuthWhatsNext __fastcall DoNext(void);
	virtual int __fastcall GetSteps(void);
	virtual void __fastcall SetUserName(const System::UnicodeString Value);
	
public:
	__fastcall virtual TIdNTLMAuthentication(void);
	virtual System::UnicodeString __fastcall Authentication(void);
	virtual bool __fastcall KeepAlive(void);
public:
	/* TIdAuthentication.Destroy */ inline __fastcall virtual ~TIdNTLMAuthentication(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idauthenticationntlm */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDAUTHENTICATIONNTLM)
using namespace Idauthenticationntlm;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdauthenticationntlmHPP
