// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIPMCastBase.pas' rev: 25.00 (Windows)

#ifndef IdipmcastbaseHPP
#define IdipmcastbaseHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdStack.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#if defined(_VCL_ALIAS_RECORDS)
#if !defined(UNICODE)
#pragma alias "@Idipmcastbase@TIdIPMCastBase@SetPortA$qqrxi"="@Idipmcastbase@TIdIPMCastBase@SetPort$qqrxi"
#else
#pragma alias "@Idipmcastbase@TIdIPMCastBase@SetPortW$qqrxi"="@Idipmcastbase@TIdIPMCastBase@SetPort$qqrxi"
#endif
#endif

namespace Idipmcastbase
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdIPMv6Scope : unsigned char { IdIPv6MC_InterfaceLocal, IdIPv6MC_LinkLocal, IdIPv6MC_AdminLocal, IdIPv6MC_SiteLocal, IdIPv6MC_OrgLocal, IdIPv6MC_Global };

typedef System::Int8 TIdIPMCValidScopes;

class DELPHICLASS TIdIPMCastBase;
class PASCALIMPLEMENTATION TIdIPMCastBase : public Idcomponent::TIdComponent
{
	typedef Idcomponent::TIdComponent inherited;
	
protected:
	bool FDsgnActive;
	System::UnicodeString FMulticastGroup;
	int FPort;
	Idglobal::TIdIPVersion FIPVersion;
	Idglobal::TIdReuseSocket FReuseSocket;
	virtual void __fastcall CloseBinding(void) = 0 ;
	virtual bool __fastcall GetActive(void);
	virtual Idsockethandle::TIdSocketHandle* __fastcall GetBinding(void) = 0 ;
	virtual void __fastcall Loaded(void);
	virtual void __fastcall SetActive(const bool Value);
	virtual void __fastcall SetMulticastGroup(const System::UnicodeString Value);
	virtual void __fastcall SetPort(const int Value);
	virtual Idglobal::TIdIPVersion __fastcall GetIPVersion(void);
	virtual void __fastcall SetIPVersion(const Idglobal::TIdIPVersion AValue);
	__property bool Active = {read=GetActive, write=SetActive, default=0};
	__property System::UnicodeString MulticastGroup = {read=FMulticastGroup, write=SetMulticastGroup};
	__property int Port = {read=FPort, write=SetPort, nodefault};
	__property Idglobal::TIdIPVersion IPVersion = {read=GetIPVersion, write=SetIPVersion, default=0};
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdIPMCastBase(System::Classes::TComponent* AOwner)/* overload */;
	bool __fastcall IsValidMulticastGroup(const System::UnicodeString Value);
	__classmethod System::UnicodeString __fastcall SetIPv6AddrScope(const System::UnicodeString AVarIPv6Addr, const TIdIPMv6Scope AScope)/* overload */;
	__classmethod System::UnicodeString __fastcall SetIPv6AddrScope(const System::UnicodeString AVarIPv6Addr, const TIdIPMCValidScopes AScope)/* overload */;
	__property Idglobal::TIdReuseSocket ReuseSocket = {read=FReuseSocket, write=FReuseSocket, default=0};
public:
	/* TIdComponent.Destroy */ inline __fastcall virtual ~TIdIPMCastBase(void) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdIPMCastBase(void)/* overload */ : Idcomponent::TIdComponent() { }
	
};


class DELPHICLASS EIdMCastException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdMCastException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdMCastException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdMCastException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdMCastException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdMCastException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMCastException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMCastException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdMCastException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdMCastException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMCastException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMCastException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMCastException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMCastException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdMCastException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdMCastNoBindings;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdMCastNoBindings : public EIdMCastException
{
	typedef EIdMCastException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdMCastNoBindings(const System::UnicodeString AMsg)/* overload */ : EIdMCastException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdMCastNoBindings(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdMCastException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdMCastNoBindings(NativeUInt Ident)/* overload */ : EIdMCastException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdMCastNoBindings(System::PResStringRec ResStringRec)/* overload */ : EIdMCastException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMCastNoBindings(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdMCastException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMCastNoBindings(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdMCastException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdMCastNoBindings(const System::UnicodeString Msg, int AHelpContext) : EIdMCastException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdMCastNoBindings(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdMCastException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMCastNoBindings(NativeUInt Ident, int AHelpContext)/* overload */ : EIdMCastException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMCastNoBindings(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdMCastException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMCastNoBindings(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdMCastException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMCastNoBindings(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdMCastException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdMCastNoBindings(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdMCastNotValidAddress;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdMCastNotValidAddress : public EIdMCastException
{
	typedef EIdMCastException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdMCastNotValidAddress(const System::UnicodeString AMsg)/* overload */ : EIdMCastException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdMCastNotValidAddress(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdMCastException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdMCastNotValidAddress(NativeUInt Ident)/* overload */ : EIdMCastException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdMCastNotValidAddress(System::PResStringRec ResStringRec)/* overload */ : EIdMCastException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMCastNotValidAddress(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdMCastException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMCastNotValidAddress(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdMCastException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdMCastNotValidAddress(const System::UnicodeString Msg, int AHelpContext) : EIdMCastException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdMCastNotValidAddress(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdMCastException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMCastNotValidAddress(NativeUInt Ident, int AHelpContext)/* overload */ : EIdMCastException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMCastNotValidAddress(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdMCastException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMCastNotValidAddress(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdMCastException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMCastNotValidAddress(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdMCastException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdMCastNotValidAddress(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdMCastReceiveErrorZeroBytes;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdMCastReceiveErrorZeroBytes : public EIdMCastException
{
	typedef EIdMCastException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdMCastReceiveErrorZeroBytes(const System::UnicodeString AMsg)/* overload */ : EIdMCastException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdMCastReceiveErrorZeroBytes(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdMCastException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdMCastReceiveErrorZeroBytes(NativeUInt Ident)/* overload */ : EIdMCastException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdMCastReceiveErrorZeroBytes(System::PResStringRec ResStringRec)/* overload */ : EIdMCastException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMCastReceiveErrorZeroBytes(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdMCastException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMCastReceiveErrorZeroBytes(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdMCastException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdMCastReceiveErrorZeroBytes(const System::UnicodeString Msg, int AHelpContext) : EIdMCastException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdMCastReceiveErrorZeroBytes(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdMCastException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMCastReceiveErrorZeroBytes(NativeUInt Ident, int AHelpContext)/* overload */ : EIdMCastException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMCastReceiveErrorZeroBytes(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdMCastException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMCastReceiveErrorZeroBytes(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdMCastException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMCastReceiveErrorZeroBytes(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdMCastException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdMCastReceiveErrorZeroBytes(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Byte IPMCastLo = System::Byte(0xe0);
static const System::Byte IPMCastHi = System::Byte(0xef);
#define DEF_IPv6_MGROUP L"FF01:0:0:0:0:0:0:1"
}	/* namespace Idipmcastbase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDIPMCASTBASE)
using namespace Idipmcastbase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdipmcastbaseHPP
