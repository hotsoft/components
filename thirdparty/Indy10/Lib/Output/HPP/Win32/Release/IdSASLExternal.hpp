// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSASLExternal.pas' rev: 25.00 (Windows)

#ifndef IdsaslexternalHPP
#define IdsaslexternalHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdSASL.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsaslexternal
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdSASLExternal;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSASLExternal : public Idsasl::TIdSASL
{
	typedef Idsasl::TIdSASL inherited;
	
protected:
	System::UnicodeString FAuthIdentity;
	virtual void __fastcall InitComponent(void);
	
public:
	virtual bool __fastcall IsReadyToStart(void);
	__classmethod virtual System::UnicodeString __fastcall ServiceName();
	virtual bool __fastcall TryStartAuthenticate(const System::UnicodeString AHost, const System::UnicodeString AProtocolName, System::UnicodeString &VInitialResponse);
	virtual System::UnicodeString __fastcall StartAuthenticate(const System::UnicodeString AChallenge, const System::UnicodeString AHost, const System::UnicodeString AProtocolName);
	
__published:
	__property System::UnicodeString AuthorizationIdentity = {read=FAuthIdentity, write=FAuthIdentity};
public:
	/* TIdSASL.Destroy */ inline __fastcall virtual ~TIdSASLExternal(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSASLExternal(System::Classes::TComponent* AOwner)/* overload */ : Idsasl::TIdSASL(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSASLExternal(void)/* overload */ : Idsasl::TIdSASL() { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idsaslexternal */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSASLEXTERNAL)
using namespace Idsaslexternal;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsaslexternalHPP
