// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSASLDigest.pas' rev: 25.00 (Windows)

#ifndef IdsasldigestHPP
#define IdsasldigestHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdSASL.hpp>	// Pascal unit
#include <IdSASLUserPass.hpp>	// Pascal unit
#include <IdUserPassProvider.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsasldigest
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdSASLDigest;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSASLDigest : public Idsasluserpass::TIdSASLUserPass
{
	typedef Idsasluserpass::TIdSASLUserPass inherited;
	
protected:
	System::UnicodeString Fauthzid;
	
public:
	virtual System::UnicodeString __fastcall StartAuthenticate(const System::UnicodeString AChallenge, const System::UnicodeString AHost, const System::UnicodeString AProtocolName);
	virtual System::UnicodeString __fastcall ContinueAuthenticate(const System::UnicodeString ALastResponse, const System::UnicodeString AHost, const System::UnicodeString AProtocolName);
	__classmethod virtual System::UnicodeString __fastcall ServiceName();
	virtual bool __fastcall IsReadyToStart(void);
	
__published:
	__property System::UnicodeString authzid = {read=Fauthzid, write=Fauthzid};
public:
	/* TIdSASL.Destroy */ inline __fastcall virtual ~TIdSASLDigest(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSASLDigest(System::Classes::TComponent* AOwner)/* overload */ : Idsasluserpass::TIdSASLUserPass(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSASLDigest(void)/* overload */ : Idsasluserpass::TIdSASLUserPass() { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSASLDigestException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSASLDigestException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSASLDigestException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSASLDigestException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLDigestException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLDigestException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLDigestException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLDigestException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSASLDigestException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSASLDigestException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLDigestException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLDigestException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLDigestException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLDigestException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSASLDigestException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSASLDigestChallException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSASLDigestChallException : public EIdSASLDigestException
{
	typedef EIdSASLDigestException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSASLDigestChallException(const System::UnicodeString AMsg)/* overload */ : EIdSASLDigestException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSASLDigestChallException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSASLDigestException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLDigestChallException(NativeUInt Ident)/* overload */ : EIdSASLDigestException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLDigestChallException(System::PResStringRec ResStringRec)/* overload */ : EIdSASLDigestException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLDigestChallException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLDigestException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLDigestChallException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLDigestException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSASLDigestChallException(const System::UnicodeString Msg, int AHelpContext) : EIdSASLDigestException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSASLDigestChallException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSASLDigestException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLDigestChallException(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSASLDigestException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLDigestChallException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSASLDigestException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLDigestChallException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLDigestException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLDigestChallException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLDigestException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSASLDigestChallException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSASLDigestChallNoAlgorithm;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSASLDigestChallNoAlgorithm : public EIdSASLDigestChallException
{
	typedef EIdSASLDigestChallException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSASLDigestChallNoAlgorithm(const System::UnicodeString AMsg)/* overload */ : EIdSASLDigestChallException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSASLDigestChallNoAlgorithm(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSASLDigestChallException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLDigestChallNoAlgorithm(NativeUInt Ident)/* overload */ : EIdSASLDigestChallException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLDigestChallNoAlgorithm(System::PResStringRec ResStringRec)/* overload */ : EIdSASLDigestChallException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLDigestChallNoAlgorithm(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLDigestChallException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLDigestChallNoAlgorithm(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLDigestChallException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSASLDigestChallNoAlgorithm(const System::UnicodeString Msg, int AHelpContext) : EIdSASLDigestChallException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSASLDigestChallNoAlgorithm(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSASLDigestChallException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLDigestChallNoAlgorithm(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSASLDigestChallException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLDigestChallNoAlgorithm(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSASLDigestChallException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLDigestChallNoAlgorithm(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLDigestChallException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLDigestChallNoAlgorithm(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLDigestChallException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSASLDigestChallNoAlgorithm(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSASLDigestChallInvalidAlg;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSASLDigestChallInvalidAlg : public EIdSASLDigestChallException
{
	typedef EIdSASLDigestChallException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSASLDigestChallInvalidAlg(const System::UnicodeString AMsg)/* overload */ : EIdSASLDigestChallException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSASLDigestChallInvalidAlg(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSASLDigestChallException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLDigestChallInvalidAlg(NativeUInt Ident)/* overload */ : EIdSASLDigestChallException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLDigestChallInvalidAlg(System::PResStringRec ResStringRec)/* overload */ : EIdSASLDigestChallException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLDigestChallInvalidAlg(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLDigestChallException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLDigestChallInvalidAlg(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLDigestChallException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSASLDigestChallInvalidAlg(const System::UnicodeString Msg, int AHelpContext) : EIdSASLDigestChallException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSASLDigestChallInvalidAlg(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSASLDigestChallException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLDigestChallInvalidAlg(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSASLDigestChallException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLDigestChallInvalidAlg(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSASLDigestChallException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLDigestChallInvalidAlg(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLDigestChallException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLDigestChallInvalidAlg(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLDigestChallException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSASLDigestChallInvalidAlg(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdSASLDigestAuthConfNotSupported;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSASLDigestAuthConfNotSupported : public EIdSASLDigestException
{
	typedef EIdSASLDigestException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSASLDigestAuthConfNotSupported(const System::UnicodeString AMsg)/* overload */ : EIdSASLDigestException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSASLDigestAuthConfNotSupported(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSASLDigestException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLDigestAuthConfNotSupported(NativeUInt Ident)/* overload */ : EIdSASLDigestException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSASLDigestAuthConfNotSupported(System::PResStringRec ResStringRec)/* overload */ : EIdSASLDigestException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLDigestAuthConfNotSupported(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLDigestException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSASLDigestAuthConfNotSupported(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSASLDigestException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSASLDigestAuthConfNotSupported(const System::UnicodeString Msg, int AHelpContext) : EIdSASLDigestException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSASLDigestAuthConfNotSupported(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSASLDigestException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLDigestAuthConfNotSupported(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSASLDigestException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSASLDigestAuthConfNotSupported(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSASLDigestException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLDigestAuthConfNotSupported(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLDigestException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSASLDigestAuthConfNotSupported(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSASLDigestException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSASLDigestAuthConfNotSupported(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString __fastcall CalcDigestResponse(const System::UnicodeString AUserName, const System::UnicodeString APassword, const System::UnicodeString ARealm, const System::UnicodeString ANonce, const System::UnicodeString ACNonce, const int ANC, const System::UnicodeString AQop, const System::UnicodeString ADigestURI, const System::UnicodeString AAuthzid = System::UnicodeString());
}	/* namespace Idsasldigest */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSASLDIGEST)
using namespace Idsasldigest;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsasldigestHPP
