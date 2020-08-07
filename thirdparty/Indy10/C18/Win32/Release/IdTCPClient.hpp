// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTCPClient.pas' rev: 25.00 (Windows)

#ifndef IdtcpclientHPP
#define IdtcpclientHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdExceptionCore.hpp>	// Pascal unit
#include <IdIOHandler.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#if defined(_VCL_ALIAS_RECORDS)
#if !defined(UNICODE)
#pragma alias "@Idtcpclient@TIdTCPClientCustom@SetPortA$qqrxus"="@Idtcpclient@TIdTCPClientCustom@SetPort$qqrxus"
#else
#pragma alias "@Idtcpclient@TIdTCPClientCustom@SetPortW$qqrxus"="@Idtcpclient@TIdTCPClientCustom@SetPort$qqrxus"
#endif
#endif

namespace Idtcpclient
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdTCPClientCustom;
class PASCALIMPLEMENTATION TIdTCPClientCustom : public Idtcpconnection::TIdTCPConnection
{
	typedef Idtcpconnection::TIdTCPConnection inherited;
	
protected:
	System::UnicodeString FBoundIP;
	System::Word FBoundPort;
	System::Word FBoundPortMax;
	System::Word FBoundPortMin;
	int FConnectTimeout;
	System::UnicodeString FDestination;
	System::UnicodeString FHost;
	Idglobal::TIdIPVersion FIPVersion;
	System::Classes::TNotifyEvent FOnConnected;
	System::UnicodeString FPassword;
	System::Word FPort;
	int FReadTimeout;
	System::UnicodeString FUsername;
	Idglobal::TIdReuseSocket FReuseSocket;
	bool FUseNagle;
	System::Classes::TNotifyEvent FOnBeforeBind;
	System::Classes::TNotifyEvent FOnAfterBind;
	System::Classes::TNotifyEvent FOnSocketAllocated;
	virtual void __fastcall DoOnConnected(void);
	virtual Idiohandler::TIdIOHandler* __fastcall MakeImplicitClientHandler(void);
	void __fastcall SetConnectTimeout(const int AValue);
	void __fastcall SetReadTimeout(const int AValue);
	void __fastcall SetReuseSocket(const Idglobal::TIdReuseSocket AValue);
	void __fastcall SetUseNagle(const bool AValue);
	void __fastcall SetBoundIP(const System::UnicodeString AValue);
	void __fastcall SetBoundPort(const System::Word AValue);
	void __fastcall SetBoundPortMax(const System::Word AValue);
	void __fastcall SetBoundPortMin(const System::Word AValue);
	virtual void __fastcall SetHost(const System::UnicodeString AValue);
	virtual void __fastcall SetPort(const System::Word AValue);
	virtual void __fastcall SetIPVersion(const Idglobal::TIdIPVersion AValue);
	void __fastcall SetOnBeforeBind(const System::Classes::TNotifyEvent AValue);
	void __fastcall SetOnAfterBind(const System::Classes::TNotifyEvent AValue);
	void __fastcall SetOnSocketAllocated(const System::Classes::TNotifyEvent AValue);
	virtual void __fastcall SetIOHandler(Idiohandler::TIdIOHandler* AValue);
	virtual void __fastcall InitComponent(void);
	int __fastcall GetReadTimeout(void);
	Idglobal::TIdReuseSocket __fastcall GetReuseSocket(void);
	bool __fastcall GetUseNagle(void);
	__property System::UnicodeString Host = {read=FHost, write=SetHost};
	__property Idglobal::TIdIPVersion IPVersion = {read=FIPVersion, write=SetIPVersion, nodefault};
	__property System::UnicodeString Password = {read=FPassword, write=FPassword};
	__property System::Word Port = {read=FPort, write=SetPort, nodefault};
	__property System::UnicodeString Username = {read=FUsername, write=FUsername};
	
public:
	virtual void __fastcall Connect(void)/* overload */;
	void __fastcall Connect(const System::UnicodeString AHost)/* overload */;
	void __fastcall Connect(const System::UnicodeString AHost, const System::Word APort)/* overload */;
	virtual System::UnicodeString __fastcall ConnectAndGetAll(void);
	__property System::UnicodeString BoundIP = {read=FBoundIP, write=SetBoundIP};
	__property System::Word BoundPort = {read=FBoundPort, write=SetBoundPort, default=0};
	__property System::Word BoundPortMax = {read=FBoundPortMax, write=SetBoundPortMax, default=0};
	__property System::Word BoundPortMin = {read=FBoundPortMin, write=SetBoundPortMin, default=0};
	__property int ConnectTimeout = {read=FConnectTimeout, write=SetConnectTimeout, nodefault};
	__property int ReadTimeout = {read=GetReadTimeout, write=SetReadTimeout, nodefault};
	__property Idglobal::TIdReuseSocket ReuseSocket = {read=GetReuseSocket, write=SetReuseSocket, default=0};
	__property bool UseNagle = {read=GetUseNagle, write=SetUseNagle, default=1};
	__property System::Classes::TNotifyEvent OnBeforeBind = {read=FOnBeforeBind, write=SetOnBeforeBind};
	__property System::Classes::TNotifyEvent OnAfterBind = {read=FOnAfterBind, write=SetOnAfterBind};
	__property System::Classes::TNotifyEvent OnSocketAllocated = {read=FOnSocketAllocated, write=SetOnSocketAllocated};
	
__published:
	__property System::Classes::TNotifyEvent OnConnected = {read=FOnConnected, write=FOnConnected};
public:
	/* TIdTCPConnection.Destroy */ inline __fastcall virtual ~TIdTCPClientCustom(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdTCPClientCustom(System::Classes::TComponent* AOwner)/* overload */ : Idtcpconnection::TIdTCPConnection(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdTCPClientCustom(void)/* overload */ : Idtcpconnection::TIdTCPConnection() { }
	
};


class DELPHICLASS TIdTCPClient;
class PASCALIMPLEMENTATION TIdTCPClient : public TIdTCPClientCustom
{
	typedef TIdTCPClientCustom inherited;
	
__published:
	__property BoundIP = {default=0};
	__property BoundPort = {default=0};
	__property ConnectTimeout;
	__property Host = {default=0};
	__property IPVersion = {default=0};
	__property Port;
	__property ReadTimeout;
	__property ReuseSocket = {default=0};
	__property UseNagle = {default=1};
	__property OnBeforeBind;
	__property OnAfterBind;
	__property OnSocketAllocated;
public:
	/* TIdTCPConnection.Destroy */ inline __fastcall virtual ~TIdTCPClient(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdTCPClient(System::Classes::TComponent* AOwner)/* overload */ : TIdTCPClientCustom(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdTCPClient(void)/* overload */ : TIdTCPClientCustom() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idtcpclient */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTCPCLIENT)
using namespace Idtcpclient;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtcpclientHPP
