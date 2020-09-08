// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSocks.pas' rev: 25.00 (Windows)

#ifndef IdsocksHPP
#define IdsocksHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdCustomTransparentProxy.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdIOHandler.hpp>	// Pascal unit
#include <IdIOHandlerSocket.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsocks
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdSocksUDPNotSupportedBySOCKSVersion;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocksUDPNotSupportedBySOCKSVersion : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocksUDPNotSupportedBySOCKSVersion(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocksUDPNotSupportedBySOCKSVersion(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksUDPNotSupportedBySOCKSVersion(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocksUDPNotSupportedBySOCKSVersion(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksUDPNotSupportedBySOCKSVersion(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocksUDPNotSupportedBySOCKSVersion(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocksUDPNotSupportedBySOCKSVersion(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocksUDPNotSupportedBySOCKSVersion(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksUDPNotSupportedBySOCKSVersion(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocksUDPNotSupportedBySOCKSVersion(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksUDPNotSupportedBySOCKSVersion(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocksUDPNotSupportedBySOCKSVersion(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocksUDPNotSupportedBySOCKSVersion(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TSocksVersion : unsigned char { svNoSocks, svSocks4, svSocks4A, svSocks5 };

enum DECLSPEC_DENUM TSocksAuthentication : unsigned char { saNoAuthentication, saUsernamePassword };

class DELPHICLASS TIdSocksInfo;
class PASCALIMPLEMENTATION TIdSocksInfo : public Idcustomtransparentproxy::TIdCustomTransparentProxy
{
	typedef Idcustomtransparentproxy::TIdCustomTransparentProxy inherited;
	
protected:
	TSocksAuthentication FAuthentication;
	TSocksVersion FVersion;
	Idiohandlersocket::TIdIOHandlerSocket* FUDPSocksAssociation;
	Idglobal::TIdBytes __fastcall DisasmUDPReplyPacket(const Idglobal::TIdBytes APacket, System::UnicodeString &VHost, System::Word &VPort, Idglobal::TIdIPVersion &VIPVersion);
	Idglobal::TIdBytes __fastcall MakeUDPRequestPacket(const Idglobal::TIdBytes AData, const System::UnicodeString AHost, const System::Word APort);
	virtual bool __fastcall GetEnabled(void);
	virtual void __fastcall InitComponent(void);
	void __fastcall AuthenticateSocks5Connection(Idiohandler::TIdIOHandler* AIOHandler);
	void __fastcall MakeSocks4Request(Idiohandler::TIdIOHandler* AIOHandler, const System::UnicodeString AHost, const System::Word APort, const System::Byte ARequest);
	void __fastcall MakeSocks5Request(Idiohandler::TIdIOHandler* AIOHandler, const System::UnicodeString AHost, const System::Word APort, const System::Byte ARequest, Idglobal::TIdBytes &VBuf, int &VLen);
	void __fastcall MakeSocks4Connection(Idiohandler::TIdIOHandler* AIOHandler, const System::UnicodeString AHost, const System::Word APort);
	void __fastcall MakeSocks4Bind(Idiohandler::TIdIOHandler* AIOHandler, const System::UnicodeString AHost, const System::Word APort);
	void __fastcall MakeSocks5Connection(Idiohandler::TIdIOHandler* AIOHandler, const System::UnicodeString AHost, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	void __fastcall MakeSocks5Bind(Idiohandler::TIdIOHandler* AIOHandler, const System::UnicodeString AHost, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	virtual void __fastcall MakeConnection(Idiohandler::TIdIOHandler* AIOHandler, const System::UnicodeString AHost, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	bool __fastcall MakeSocks4Listen(Idiohandler::TIdIOHandler* AIOHandler, const int ATimeOut);
	bool __fastcall MakeSocks5Listen(Idiohandler::TIdIOHandler* AIOHandler, const int ATimeOut);
	void __fastcall MakeSocks5UDPAssociation(Idsockethandle::TIdSocketHandle* AHandle);
	void __fastcall CloseSocks5UDPAssociation(void);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* ASource);
	__fastcall virtual ~TIdSocksInfo(void);
	virtual void __fastcall Bind(Idiohandler::TIdIOHandler* AIOHandler, const System::UnicodeString AHost, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0))/* overload */;
	virtual bool __fastcall Listen(Idiohandler::TIdIOHandler* AIOHandler, const int ATimeOut);
	virtual void __fastcall OpenUDP(Idsockethandle::TIdSocketHandle* AHandle, const System::UnicodeString AHost = System::UnicodeString(), const System::Word APort = (System::Word)(0x0), const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	virtual int __fastcall RecvFromUDP(Idsockethandle::TIdSocketHandle* AHandle, Idglobal::TIdBytes &ABuffer, System::UnicodeString &VPeerIP, System::Word &VPeerPort, Idglobal::TIdIPVersion &VIPVersion, int AMSec = 0xffffffff);
	virtual void __fastcall SendToUDP(Idsockethandle::TIdSocketHandle* AHandle, const System::UnicodeString AHost, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion, const Idglobal::TIdBytes ABuffer);
	virtual void __fastcall CloseUDP(Idsockethandle::TIdSocketHandle* AHandle);
	
__published:
	__property TSocksAuthentication Authentication = {read=FAuthentication, write=FAuthentication, default=0};
	__property Host = {default=0};
	__property Password = {default=0};
	__property Port = {default=1080};
	__property IPVersion = {default=0};
	__property Username = {default=0};
	__property TSocksVersion Version = {read=FVersion, write=FVersion, default=0};
	__property ChainedProxy;
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSocksInfo(System::Classes::TComponent* AOwner)/* overload */ : Idcustomtransparentproxy::TIdCustomTransparentProxy(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSocksInfo(void)/* overload */ : Idcustomtransparentproxy::TIdCustomTransparentProxy() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Bind(Idiohandler::TIdIOHandler* AIOHandler, const System::Word APort){ Idcustomtransparentproxy::TIdCustomTransparentProxy::Bind(AIOHandler, APort); }
	
};


//-- var, const, procedure ---------------------------------------------------
static const TSocksAuthentication ID_SOCKS_AUTH = (TSocksAuthentication)(0);
static const TSocksVersion ID_SOCKS_VER = (TSocksVersion)(0);
}	/* namespace Idsocks */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSOCKS)
using namespace Idsocks;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsocksHPP
