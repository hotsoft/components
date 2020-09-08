// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdRawBase.pas' rev: 25.00 (Windows)

#ifndef IdrawbaseHPP
#define IdrawbaseHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdSocketHandle.hpp>	// Pascal unit
#include <IdStack.hpp>	// Pascal unit
#include <IdWship6.hpp>	// Pascal unit
#include <IdStackConsts.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idrawbase
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdRawBase;
class PASCALIMPLEMENTATION TIdRawBase : public Idcomponent::TIdComponent
{
	typedef Idcomponent::TIdComponent inherited;
	
protected:
	Idsockethandle::TIdSocketHandle* FBinding;
	System::UnicodeString FHost;
	System::Word FPort;
	int FReceiveTimeout;
	int FProtocol;
	int FProtocolIPv6;
	int FTTL;
	Idstack::TIdPacketInfo* FPkt;
	bool FConnected;
	Idsockethandle::TIdSocketHandle* __fastcall GetBinding(void);
	Idglobal::TIdIPVersion __fastcall GetIPVersion(void);
	virtual void __fastcall InitComponent(void);
	void __fastcall SetIPVersion(const Idglobal::TIdIPVersion AValue);
	void __fastcall SetTTL(const int Value);
	virtual void __fastcall SetHost(const System::UnicodeString AValue);
	__property Idglobal::TIdIPVersion IPVersion = {read=GetIPVersion, write=SetIPVersion, nodefault};
	__property System::Word Port = {read=FPort, write=FPort, default=0};
	__property int Protocol = {read=FProtocol, write=FProtocol, default=255};
	__property int ProtocolIPv6 = {read=FProtocolIPv6, write=FProtocolIPv6, nodefault};
	__property int TTL = {read=FTTL, write=SetTTL, default=128};
	
public:
	__fastcall virtual ~TIdRawBase(void);
	int __fastcall ReceiveBuffer(Idglobal::TIdBytes &VBuffer, int ATimeOut = 0xffffffff);
	virtual void __fastcall Send(const System::UnicodeString AData, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	virtual void __fastcall Send(const Idglobal::TIdBytes AData)/* overload */;
	virtual void __fastcall Send(const System::UnicodeString AHost, const System::Word APort, const System::UnicodeString AData, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	virtual void __fastcall Send(const System::UnicodeString AHost, const System::Word APort, const Idglobal::TIdBytes ABuffer)/* overload */;
	__property Idsockethandle::TIdSocketHandle* Binding = {read=GetBinding};
	__property int ReceiveTimeout = {read=FReceiveTimeout, write=FReceiveTimeout, default=0};
	
__published:
	__property System::UnicodeString Host = {read=FHost, write=SetHost};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdRawBase(System::Classes::TComponent* AOwner)/* overload */ : Idcomponent::TIdComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdRawBase(void)/* overload */ : Idcomponent::TIdComponent() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 Id_TIdRawBase_Port = System::Int8(0x0);
static const System::Word Id_TIdRawBase_BufferSize = System::Word(0x2000);
static const System::Int8 GReceiveTimeout = System::Int8(0x0);
static const System::Byte GFTTL = System::Byte(0x80);
}	/* namespace Idrawbase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDRAWBASE)
using namespace Idrawbase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdrawbaseHPP
