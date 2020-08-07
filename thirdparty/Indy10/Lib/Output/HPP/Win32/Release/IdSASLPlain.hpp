// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSASLPlain.pas' rev: 25.00 (Windows)

#ifndef IdsaslplainHPP
#define IdsaslplainHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdSASL.hpp>	// Pascal unit
#include <IdSASLUserPass.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsaslplain
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdSASLPlain;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSASLPlain : public Idsasluserpass::TIdSASLUserPass
{
	typedef Idsasluserpass::TIdSASLUserPass inherited;
	
protected:
	System::UnicodeString FLoginAs;
	
public:
	virtual bool __fastcall IsReadyToStart(void);
	__classmethod virtual System::UnicodeString __fastcall ServiceName();
	virtual bool __fastcall TryStartAuthenticate(const System::UnicodeString AHost, const System::UnicodeString AProtocolName, System::UnicodeString &VInitialResponse);
	virtual System::UnicodeString __fastcall StartAuthenticate(const System::UnicodeString AChallenge, const System::UnicodeString AHost, const System::UnicodeString AProtocolName);
	
__published:
	__property System::UnicodeString LoginAs = {read=FLoginAs, write=FLoginAs};
public:
	/* TIdSASL.Destroy */ inline __fastcall virtual ~TIdSASLPlain(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSASLPlain(System::Classes::TComponent* AOwner)/* overload */ : Idsasluserpass::TIdSASLUserPass(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSASLPlain(void)/* overload */ : Idsasluserpass::TIdSASLUserPass() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idsaslplain */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSASLPLAIN)
using namespace Idsaslplain;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsaslplainHPP
