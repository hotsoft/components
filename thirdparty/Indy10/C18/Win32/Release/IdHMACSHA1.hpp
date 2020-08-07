// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdHMACSHA1.pas' rev: 25.00 (Windows)

#ifndef Idhmacsha1HPP
#define Idhmacsha1HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdFIPS.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdHash.hpp>	// Pascal unit
#include <IdHashSHA.hpp>	// Pascal unit
#include <IdHMAC.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idhmacsha1
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdHMACSHA1;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHMACSHA1 : public Idhmac::TIdHMAC
{
	typedef Idhmac::TIdHMAC inherited;
	
protected:
	virtual void __fastcall SetHashVars(void);
	virtual bool __fastcall IsIntFAvail(void);
	virtual void * __fastcall InitIntFInst(const Idglobal::TIdBytes AKey);
	virtual void __fastcall InitHash(void);
public:
	/* TIdHMAC.Create */ inline __fastcall virtual TIdHMACSHA1(void) : Idhmac::TIdHMAC() { }
	/* TIdHMAC.Destroy */ inline __fastcall virtual ~TIdHMACSHA1(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHMACSHA224;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHMACSHA224 : public Idhmac::TIdHMAC
{
	typedef Idhmac::TIdHMAC inherited;
	
protected:
	virtual void __fastcall SetHashVars(void);
	virtual bool __fastcall IsIntFAvail(void);
	virtual void * __fastcall InitIntFInst(const Idglobal::TIdBytes AKey);
	virtual void __fastcall InitHash(void);
public:
	/* TIdHMAC.Create */ inline __fastcall virtual TIdHMACSHA224(void) : Idhmac::TIdHMAC() { }
	/* TIdHMAC.Destroy */ inline __fastcall virtual ~TIdHMACSHA224(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHMACSHA256;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHMACSHA256 : public Idhmac::TIdHMAC
{
	typedef Idhmac::TIdHMAC inherited;
	
protected:
	virtual void __fastcall SetHashVars(void);
	virtual bool __fastcall IsIntFAvail(void);
	virtual void * __fastcall InitIntFInst(const Idglobal::TIdBytes AKey);
	virtual void __fastcall InitHash(void);
public:
	/* TIdHMAC.Create */ inline __fastcall virtual TIdHMACSHA256(void) : Idhmac::TIdHMAC() { }
	/* TIdHMAC.Destroy */ inline __fastcall virtual ~TIdHMACSHA256(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHMACSHA384;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHMACSHA384 : public Idhmac::TIdHMAC
{
	typedef Idhmac::TIdHMAC inherited;
	
protected:
	virtual void __fastcall SetHashVars(void);
	virtual bool __fastcall IsIntFAvail(void);
	virtual void * __fastcall InitIntFInst(const Idglobal::TIdBytes AKey);
	virtual void __fastcall InitHash(void);
public:
	/* TIdHMAC.Create */ inline __fastcall virtual TIdHMACSHA384(void) : Idhmac::TIdHMAC() { }
	/* TIdHMAC.Destroy */ inline __fastcall virtual ~TIdHMACSHA384(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdHMACSHA512;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdHMACSHA512 : public Idhmac::TIdHMAC
{
	typedef Idhmac::TIdHMAC inherited;
	
protected:
	virtual void __fastcall SetHashVars(void);
	virtual bool __fastcall IsIntFAvail(void);
	virtual void * __fastcall InitIntFInst(const Idglobal::TIdBytes AKey);
	virtual void __fastcall InitHash(void);
public:
	/* TIdHMAC.Create */ inline __fastcall virtual TIdHMACSHA512(void) : Idhmac::TIdHMAC() { }
	/* TIdHMAC.Destroy */ inline __fastcall virtual ~TIdHMACSHA512(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdHMACHashNotAvailable;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdHMACHashNotAvailable : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdHMACHashNotAvailable(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdHMACHashNotAvailable(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdHMACHashNotAvailable(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdHMACHashNotAvailable(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHMACHashNotAvailable(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdHMACHashNotAvailable(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdHMACHashNotAvailable(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdHMACHashNotAvailable(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHMACHashNotAvailable(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdHMACHashNotAvailable(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHMACHashNotAvailable(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdHMACHashNotAvailable(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdHMACHashNotAvailable(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idhmacsha1 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDHMACSHA1)
using namespace Idhmacsha1;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idhmacsha1HPP
