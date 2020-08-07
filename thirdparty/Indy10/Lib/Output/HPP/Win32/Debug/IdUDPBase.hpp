// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdUDPBase.pas' rev: 25.00 (Windows)

#ifndef IdudpbaseHPP
#define IdudpbaseHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#if defined(_VCL_ALIAS_RECORDS)
#if !defined(UNICODE)
#pragma alias "@Idudpbase@TIdUDPBase@SetPortA$qqrxus"="@Idudpbase@TIdUDPBase@SetPort$qqrxus"
#else
#pragma alias "@Idudpbase@TIdUDPBase@SetPortW$qqrxus"="@Idudpbase@TIdUDPBase@SetPort$qqrxus"
#endif
#endif

namespace Idudpbase
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdUDPBase;
class PASCALIMPLEMENTATION TIdUDPBase : public Idcomponent::TIdComponent
{
	typedef Idcomponent::TIdComponent inherited;
	
protected:
	Idsockethandle::TIdSocketHandle* FBinding;
	int FBufferSize;
	bool FDsgnActive;
	System::UnicodeString FHost;
	System::Word FPort;
	int FReceiveTimeout;
	Idglobal::TIdReuseSocket FReuseSocket;
	Idglobal::TIdIPVersion FIPVersion;
	bool FBroadcastEnabled;
	DYNAMIC void __fastcall BroadcastEnabledChanged(void);
	virtual void __fastcall CloseBinding(void);
	virtual bool __fastcall GetActive(void);
	virtual void __fastcall InitComponent(void);
	void __fastcall SetActive(const bool Value);
	void __fastcall SetBroadcastEnabled(const bool AValue);
	virtual Idsockethandle::TIdSocketHandle* __fastcall GetBinding(void) = 0 ;
	virtual void __fastcall Loaded(void);
	virtual Idglobal::TIdIPVersion __fastcall GetIPVersion(void);
	virtual void __fastcall SetIPVersion(const Idglobal::TIdIPVersion AValue);
	virtual System::UnicodeString __fastcall GetHost(void);
	virtual void __fastcall SetHost(const System::UnicodeString AValue);
	virtual System::Word __fastcall GetPort(void);
	virtual void __fastcall SetPort(const System::Word AValue);
	__property System::UnicodeString Host = {read=GetHost, write=SetHost};
	__property System::Word Port = {read=GetPort, write=SetPort, nodefault};
	
public:
	__fastcall virtual ~TIdUDPBase(void);
	__property Idsockethandle::TIdSocketHandle* Binding = {read=GetBinding};
	void __fastcall Broadcast(const System::UnicodeString AData, const System::Word APort, const System::UnicodeString AIP = System::UnicodeString(), Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	void __fastcall Broadcast(const Idglobal::TIdBytes AData, const System::Word APort, const System::UnicodeString AIP = System::UnicodeString())/* overload */;
	virtual int __fastcall ReceiveBuffer(Idglobal::TIdBytes &ABuffer, System::UnicodeString &VPeerIP, System::Word &VPeerPort, int AMSec = 0xffffffff)/* overload */;
	virtual int __fastcall ReceiveBuffer(Idglobal::TIdBytes &ABuffer, System::UnicodeString &VPeerIP, System::Word &VPeerPort, Idglobal::TIdIPVersion &VIPVersion, const int AMSec = 0xffffffff)/* overload */;
	virtual int __fastcall ReceiveBuffer(Idglobal::TIdBytes &ABuffer, const int AMSec = 0xffffffff)/* overload */;
	System::UnicodeString __fastcall ReceiveString(const int AMSec = 0xffffffff, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	System::UnicodeString __fastcall ReceiveString(System::UnicodeString &VPeerIP, System::Word &VPeerPort, const int AMSec = 0xffffffff, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	void __fastcall Send(const System::UnicodeString AHost, const System::Word APort, const System::UnicodeString AData, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	virtual void __fastcall SendBuffer(const System::UnicodeString AHost, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion, const Idglobal::TIdBytes ABuffer)/* overload */;
	virtual void __fastcall SendBuffer(const System::UnicodeString AHost, const System::Word APort, const Idglobal::TIdBytes ABuffer)/* overload */;
	__property int ReceiveTimeout = {read=FReceiveTimeout, write=FReceiveTimeout, default=-2};
	__property Idglobal::TIdReuseSocket ReuseSocket = {read=FReuseSocket, write=FReuseSocket, default=0};
	
__published:
	__property bool Active = {read=GetActive, write=SetActive, default=0};
	__property int BufferSize = {read=FBufferSize, write=FBufferSize, default=8192};
	__property bool BroadcastEnabled = {read=FBroadcastEnabled, write=SetBroadcastEnabled, default=0};
	__property Idglobal::TIdIPVersion IPVersion = {read=GetIPVersion, write=SetIPVersion, default=0};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdUDPBase(System::Classes::TComponent* AOwner)/* overload */ : Idcomponent::TIdComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdUDPBase(void)/* overload */ : Idcomponent::TIdComponent() { }
	
};


class DELPHICLASS EIdUDPException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdUDPException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdUDPException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdUDPException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdUDPException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdUDPException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUDPException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUDPException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdUDPException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdUDPException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUDPException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUDPException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUDPException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUDPException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdUDPException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdUDPReceiveErrorZeroBytes;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdUDPReceiveErrorZeroBytes : public EIdUDPException
{
	typedef EIdUDPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdUDPReceiveErrorZeroBytes(const System::UnicodeString AMsg)/* overload */ : EIdUDPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdUDPReceiveErrorZeroBytes(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdUDPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdUDPReceiveErrorZeroBytes(NativeUInt Ident)/* overload */ : EIdUDPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdUDPReceiveErrorZeroBytes(System::PResStringRec ResStringRec)/* overload */ : EIdUDPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUDPReceiveErrorZeroBytes(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdUDPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUDPReceiveErrorZeroBytes(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdUDPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdUDPReceiveErrorZeroBytes(const System::UnicodeString Msg, int AHelpContext) : EIdUDPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdUDPReceiveErrorZeroBytes(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdUDPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUDPReceiveErrorZeroBytes(NativeUInt Ident, int AHelpContext)/* overload */ : EIdUDPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUDPReceiveErrorZeroBytes(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdUDPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUDPReceiveErrorZeroBytes(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdUDPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUDPReceiveErrorZeroBytes(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdUDPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdUDPReceiveErrorZeroBytes(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Word ID_UDP_BUFFERSIZE = System::Word(0x2000);
}	/* namespace Idudpbase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDUDPBASE)
using namespace Idudpbase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdudpbaseHPP
