// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdUDPClient.pas' rev: 25.00 (Windows)

#ifndef IdudpclientHPP
#define IdudpclientHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdUDPBase.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdCustomTransparentProxy.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#if defined(_VCL_ALIAS_RECORDS)
#if !defined(UNICODE)
#pragma alias "@Idudpclient@TIdUDPClient@SetPortA$qqrxus"="@Idudpclient@TIdUDPClient@SetPort$qqrxus"
#else
#pragma alias "@Idudpclient@TIdUDPClient@SetPortW$qqrxus"="@Idudpclient@TIdUDPClient@SetPort$qqrxus"
#endif
#endif

namespace Idudpclient
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdMustUseOpenProxy;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdMustUseOpenProxy : public Idudpbase::EIdUDPException
{
	typedef Idudpbase::EIdUDPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdMustUseOpenProxy(const System::UnicodeString AMsg)/* overload */ : Idudpbase::EIdUDPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdMustUseOpenProxy(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idudpbase::EIdUDPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdMustUseOpenProxy(NativeUInt Ident)/* overload */ : Idudpbase::EIdUDPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdMustUseOpenProxy(System::PResStringRec ResStringRec)/* overload */ : Idudpbase::EIdUDPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMustUseOpenProxy(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idudpbase::EIdUDPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMustUseOpenProxy(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idudpbase::EIdUDPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdMustUseOpenProxy(const System::UnicodeString Msg, int AHelpContext) : Idudpbase::EIdUDPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdMustUseOpenProxy(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idudpbase::EIdUDPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMustUseOpenProxy(NativeUInt Ident, int AHelpContext)/* overload */ : Idudpbase::EIdUDPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMustUseOpenProxy(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idudpbase::EIdUDPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMustUseOpenProxy(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idudpbase::EIdUDPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMustUseOpenProxy(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idudpbase::EIdUDPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdMustUseOpenProxy(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdUDPClient;
class PASCALIMPLEMENTATION TIdUDPClient : public Idudpbase::TIdUDPBase
{
	typedef Idudpbase::TIdUDPBase inherited;
	
protected:
	System::UnicodeString FBoundIP;
	System::Word FBoundPort;
	System::Word FBoundPortMin;
	System::Word FBoundPortMax;
	bool FProxyOpened;
	System::Classes::TNotifyEvent FOnConnected;
	System::Classes::TNotifyEvent FOnDisconnected;
	bool FConnected;
	Idcustomtransparentproxy::TIdCustomTransparentProxy* FTransparentProxy;
	bool FImplicitTransparentProxy;
	bool __fastcall UseProxy(void);
	void __fastcall RaiseUseProxyError(void);
	virtual void __fastcall DoOnConnected(void);
	virtual void __fastcall DoOnDisconnected(void);
	virtual void __fastcall InitComponent(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall SetIPVersion(const Idglobal::TIdIPVersion AValue);
	virtual void __fastcall SetHost(const System::UnicodeString AValue);
	virtual void __fastcall SetPort(const System::Word AValue);
	void __fastcall SetTransparentProxy(Idcustomtransparentproxy::TIdCustomTransparentProxy* AProxy);
	virtual Idsockethandle::TIdSocketHandle* __fastcall GetBinding(void);
	Idcustomtransparentproxy::TIdCustomTransparentProxy* __fastcall GetTransparentProxy(void);
	
public:
	__fastcall virtual ~TIdUDPClient(void);
	void __fastcall OpenProxy(void);
	void __fastcall CloseProxy(void);
	virtual void __fastcall Connect(void);
	virtual void __fastcall Disconnect(void);
	bool __fastcall Connected(void);
	virtual int __fastcall ReceiveBuffer(Idglobal::TIdBytes &ABuffer, const int AMSec = 0xffffffff)/* overload */;
	virtual int __fastcall ReceiveBuffer(Idglobal::TIdBytes &ABuffer, System::UnicodeString &VPeerIP, System::Word &VPeerPort, int AMSec = 0xffffffff)/* overload */;
	virtual int __fastcall ReceiveBuffer(Idglobal::TIdBytes &ABuffer, System::UnicodeString &VPeerIP, System::Word &VPeerPort, Idglobal::TIdIPVersion &VIPVersion, const int AMSec = 0xffffffff)/* overload */;
	HIDESBASE void __fastcall Send(const System::UnicodeString AData, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	virtual void __fastcall SendBuffer(const System::UnicodeString AHost, const System::Word APort, const Idglobal::TIdBytes ABuffer)/* overload */;
	HIDESBASE void __fastcall SendBuffer(const Idglobal::TIdBytes ABuffer)/* overload */;
	virtual void __fastcall SendBuffer(const System::UnicodeString AHost, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion, const Idglobal::TIdBytes ABuffer)/* overload */;
	
__published:
	__property System::UnicodeString BoundIP = {read=FBoundIP, write=FBoundIP};
	__property System::Word BoundPort = {read=FBoundPort, write=FBoundPort, default=0};
	__property System::Word BoundPortMin = {read=FBoundPortMin, write=FBoundPortMin, default=0};
	__property System::Word BoundPortMax = {read=FBoundPortMax, write=FBoundPortMax, default=0};
	__property IPVersion = {default=0};
	__property Host = {default=0};
	__property Port;
	__property ReceiveTimeout = {default=-2};
	__property ReuseSocket = {default=0};
	__property Idcustomtransparentproxy::TIdCustomTransparentProxy* TransparentProxy = {read=GetTransparentProxy, write=SetTransparentProxy};
	__property System::Classes::TNotifyEvent OnConnected = {read=FOnConnected, write=FOnConnected};
	__property System::Classes::TNotifyEvent OnDisconnected = {read=FOnDisconnected, write=FOnDisconnected};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdUDPClient(System::Classes::TComponent* AOwner)/* overload */ : Idudpbase::TIdUDPBase(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdUDPClient(void)/* overload */ : Idudpbase::TIdUDPBase() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idudpclient */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDUDPCLIENT)
using namespace Idudpclient;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdudpclientHPP
