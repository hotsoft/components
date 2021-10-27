// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdStackBSDBase.pas' rev: 25.00 (Windows)

#ifndef IdstackbsdbaseHPP
#define IdstackbsdbaseHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdStack.hpp>	// Pascal unit
#include <IdStackConsts.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#ifdef s6_addr
  #undef s6_addr
#endif
#ifdef s6_addr16
  #undef s6_addr16
#endif

namespace Idstackbsdbase
{
//-- type declarations -------------------------------------------------------
#pragma pack(push,1)
struct DECLSPEC_DRECORD TIdInt64Parts
{
	union
	{
		struct 
		{
			__int64 QuadPart;
		};
		struct 
		{
			unsigned LowPart;
			unsigned HighPart;
		};
		
	};
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TIdUInt64Parts
{
	union
	{
		struct 
		{
			unsigned __int64 QuadPart;
		};
		struct 
		{
			unsigned LowPart;
			unsigned HighPart;
		};
		
	};
};
#pragma pack(pop)


typedef System::StaticArray<System::Word, 8> TIdIPv6AddressRec;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TIdIPAddressRec
{
public:
	Idglobal::TIdIPVersion IPVer;
	union
	{
		struct 
		{
			TIdIPv6AddressRec IPv6;
		};
		struct 
		{
			unsigned IPv4;
			unsigned Junk1;
			unsigned Junk2;
			unsigned Junk3;
		};
		
	};
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TIdSunB
{
public:
	System::Byte s_b1;
	System::Byte s_b2;
	System::Byte s_b3;
	System::Byte s_b4;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TIdSunW
{
public:
	System::Word s_w1;
	System::Word s_w2;
};
#pragma pack(pop)


struct TIdIn4Addr;
typedef TIdIn4Addr *PIdIn4Addr;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TIdIn4Addr
{
	union
	{
		struct 
		{
			unsigned S_addr;
		};
		struct 
		{
			TIdSunW S_un_w;
		};
		struct 
		{
			TIdSunB S_un_b;
		};
		
	};
};
#pragma pack(pop)


struct TIdIn6Addr;
typedef TIdIn6Addr *PIdIn6Addr;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TIdIn6Addr
{
	union
	{
		struct 
		{
			System::StaticArray<System::Word, 8> s6_addr16;
		};
		struct 
		{
			System::StaticArray<System::Byte, 16> s6_addr;
		};
		
	};
};
#pragma pack(pop)


typedef TIdIn4Addr *PIdInAddr;

typedef TIdIn4Addr TIdInAddr;

#pragma pack(push,1)
struct DECLSPEC_DRECORD TIdIPMreq
{
public:
	TIdIn4Addr IMRMultiAddr;
	TIdIn4Addr IMRInterface;
};
#pragma pack(pop)


#pragma pack(push,1)
struct DECLSPEC_DRECORD TIdIPv6Mreq
{
public:
	TIdIn6Addr ipv6mr_multiaddr;
	unsigned ipv6mr_interface;
};
#pragma pack(pop)


class DELPHICLASS TIdStackBSDBase;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdStackBSDBase : public Idstack::TIdStack
{
	typedef Idstack::TIdStack inherited;
	
protected:
	virtual int __fastcall WSCloseSocket(NativeUInt ASocket) = 0 ;
	virtual int __fastcall WSRecv(NativeUInt ASocket, void *ABuffer, const int ABufferLength, const int AFlags) = 0 ;
	virtual int __fastcall WSSend(NativeUInt ASocket, const void *ABuffer, const int ABufferLength, const int AFlags) = 0 ;
	virtual int __fastcall WSShutdown(NativeUInt ASocket, int AHow) = 0 ;
	void __fastcall MembershipSockOpt(NativeUInt AHandle, const System::UnicodeString AGroupIP, const System::UnicodeString ALocalIP, const int ASockOpt, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	
public:
	__fastcall virtual TIdStackBSDBase(void);
	virtual bool __fastcall CheckIPVersionSupport(const Idglobal::TIdIPVersion AIPVersion) = 0 ;
	virtual int __fastcall Receive(NativeUInt ASocket, Idglobal::TIdBytes &VBuffer);
	virtual int __fastcall Send(NativeUInt ASocket, const Idglobal::TIdBytes ABuffer, const int AOffset = 0x0, const int ASize = 0xffffffff);
	virtual int __fastcall ReceiveFrom(NativeUInt ASocket, Idglobal::TIdBytes &VBuffer, System::UnicodeString &VIP, System::Word &VPort, Idglobal::TIdIPVersion &VIPVersion);
	virtual int __fastcall SendTo(NativeUInt ASocket, const Idglobal::TIdBytes ABuffer, const int AOffset, const int ASize, const System::UnicodeString AIP, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0))/* overload */;
	virtual void __fastcall GetSocketOption(NativeUInt ASocket, int ALevel, int AOptName, /* out */ int &AOptVal)/* overload */;
	HIDESBASE virtual void __fastcall GetSocketOption(NativeUInt ASocket, int ALevel, int AOptName, void *AOptVal, int &AOptLen) = 0 /* overload */;
	virtual void __fastcall SetSocketOption(NativeUInt ASocket, int ALevel, int AOptName, int AOptVal)/* overload */;
	HIDESBASE virtual void __fastcall SetSocketOption(NativeUInt ASocket, int ALevel, int AOptName, const void *AOptVal, const int AOptLen) = 0 /* overload */;
	System::UnicodeString __fastcall TranslateTInAddrToString(void *AInAddr, const Idglobal::TIdIPVersion AIPVersion);
	void __fastcall TranslateStringToTInAddr(const System::UnicodeString AIP, void *AInAddr, const Idglobal::TIdIPVersion AIPVersion);
	virtual System::Word __fastcall WSGetServByName(const System::UnicodeString AServiceName) = 0 ;
	virtual System::Classes::TStrings* __fastcall WSGetServByPort _DEPRECATED_ATTRIBUTE1("Use AddServByPortToList()") (const System::Word APortNumber);
	virtual void __fastcall AddServByPortToList(const System::Word APortNumber, System::Classes::TStrings* AAddresses) = 0 ;
	virtual int __fastcall RecvFrom(const NativeUInt ASocket, void *ABuffer, const int ALength, const int AFlags, System::UnicodeString &VIP, System::Word &VPort, Idglobal::TIdIPVersion &VIPVersion) = 0 ;
	virtual void __fastcall WSSendTo(NativeUInt ASocket, const void *ABuffer, const int ABufferLength, const int AFlags, const System::UnicodeString AIP, const System::Word APort, Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0)) = 0 ;
	virtual NativeUInt __fastcall WSSocket(int AFamily, int AStruct, int AProtocol, const bool ANonBlocking = false) = 0 ;
	virtual void __fastcall SetBlocking(NativeUInt ASocket, const bool ABlocking) = 0 ;
	virtual bool __fastcall WouldBlock(const int AResult) = 0 ;
	virtual NativeUInt __fastcall NewSocketHandle(const int ASocketType, const int AProtocol, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0), const bool ANonBlocking = false);
	virtual void __fastcall SetMulticastTTL(NativeUInt AHandle, const System::Byte AValue, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	virtual void __fastcall SetLoopBack(NativeUInt AHandle, const bool AValue, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	virtual void __fastcall DropMulticastMembership(NativeUInt AHandle, const System::UnicodeString AGroupIP, const System::UnicodeString ALocalIP, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	virtual void __fastcall AddMulticastMembership(NativeUInt AHandle, const System::UnicodeString AGroupIP, const System::UnicodeString ALocalIP, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
public:
	/* TIdStack.Destroy */ inline __fastcall virtual ~TIdStackBSDBase(void) { }
	
/* Hoisted overloads: */
	
public:
	inline int __fastcall  SendTo(NativeUInt ASocket, const Idglobal::TIdBytes ABuffer, const int AOffset, const System::UnicodeString AIP, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0)){ return Idstack::TIdStack::SendTo(ASocket, ABuffer, AOffset, AIP, APort, AIPVersion); }
	
};

#pragma pack(pop)

class DELPHICLASS EIdInvalidServiceName;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdInvalidServiceName : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdInvalidServiceName(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdInvalidServiceName(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidServiceName(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidServiceName(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidServiceName(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidServiceName(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdInvalidServiceName(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdInvalidServiceName(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidServiceName(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidServiceName(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidServiceName(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidServiceName(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdInvalidServiceName(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdStackInitializationFailed;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdStackInitializationFailed : public Idstack::EIdStackError
{
	typedef Idstack::EIdStackError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdStackInitializationFailed(const System::UnicodeString AMsg)/* overload */ : Idstack::EIdStackError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdStackInitializationFailed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idstack::EIdStackError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdStackInitializationFailed(NativeUInt Ident)/* overload */ : Idstack::EIdStackError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdStackInitializationFailed(System::PResStringRec ResStringRec)/* overload */ : Idstack::EIdStackError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdStackInitializationFailed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idstack::EIdStackError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdStackInitializationFailed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idstack::EIdStackError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdStackInitializationFailed(const System::UnicodeString Msg, int AHelpContext) : Idstack::EIdStackError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdStackInitializationFailed(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idstack::EIdStackError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdStackInitializationFailed(NativeUInt Ident, int AHelpContext)/* overload */ : Idstack::EIdStackError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdStackInitializationFailed(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idstack::EIdStackError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdStackInitializationFailed(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idstack::EIdStackError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdStackInitializationFailed(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idstack::EIdStackError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdStackInitializationFailed(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdStackSetSizeExceeded;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdStackSetSizeExceeded : public Idstack::EIdStackError
{
	typedef Idstack::EIdStackError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdStackSetSizeExceeded(const System::UnicodeString AMsg)/* overload */ : Idstack::EIdStackError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdStackSetSizeExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idstack::EIdStackError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdStackSetSizeExceeded(NativeUInt Ident)/* overload */ : Idstack::EIdStackError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdStackSetSizeExceeded(System::PResStringRec ResStringRec)/* overload */ : Idstack::EIdStackError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdStackSetSizeExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idstack::EIdStackError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdStackSetSizeExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idstack::EIdStackError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdStackSetSizeExceeded(const System::UnicodeString Msg, int AHelpContext) : Idstack::EIdStackError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdStackSetSizeExceeded(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idstack::EIdStackError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdStackSetSizeExceeded(NativeUInt Ident, int AHelpContext)/* overload */ : Idstack::EIdStackError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdStackSetSizeExceeded(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idstack::EIdStackError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdStackSetSizeExceeded(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idstack::EIdStackError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdStackSetSizeExceeded(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idstack::EIdStackError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdStackSetSizeExceeded(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TIdStackBSDBase* GBSDStack;
extern DELPHI_PACKAGE System::StaticArray<int, 2> IdIPFamily;
}	/* namespace Idstackbsdbase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSTACKBSDBASE)
using namespace Idstackbsdbase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdstackbsdbaseHPP
