// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSASLUserPass.pas' rev: 25.00 (Windows)

#ifndef IdsasluserpassHPP
#define IdsasluserpassHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdSASL.hpp>	// Pascal unit
#include <IdUserPassProvider.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsasluserpass
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdSASLUserPass;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSASLUserPass : public Idsasl::TIdSASL
{
	typedef Idsasl::TIdSASL inherited;
	
protected:
	Iduserpassprovider::TIdUserPassProvider* FUserPassProvider;
	void __fastcall SetUserPassProvider(Iduserpassprovider::TIdUserPassProvider* const Value);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	System::UnicodeString __fastcall GetUsername(void);
	System::UnicodeString __fastcall GetPassword(void);
	
public:
	virtual bool __fastcall IsReadyToStart(void);
	
__published:
	__property Iduserpassprovider::TIdUserPassProvider* UserPassProvider = {read=FUserPassProvider, write=SetUserPassProvider};
public:
	/* TIdSASL.Destroy */ inline __fastcall virtual ~TIdSASLUserPass(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSASLUserPass(System::Classes::TComponent* AOwner)/* overload */ : Idsasl::TIdSASL(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSASLUserPass(void)/* overload */ : Idsasl::TIdSASL() { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdUserPassProviderUnassigned;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdUserPassProviderUnassigned : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdUserPassProviderUnassigned(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdUserPassProviderUnassigned(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdUserPassProviderUnassigned(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdUserPassProviderUnassigned(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUserPassProviderUnassigned(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUserPassProviderUnassigned(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdUserPassProviderUnassigned(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdUserPassProviderUnassigned(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUserPassProviderUnassigned(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUserPassProviderUnassigned(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUserPassProviderUnassigned(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUserPassProviderUnassigned(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdUserPassProviderUnassigned(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idsasluserpass */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSASLUSERPASS)
using namespace Idsasluserpass;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsasluserpassHPP
