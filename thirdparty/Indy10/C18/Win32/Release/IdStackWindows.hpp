// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdStackWindows.pas' rev: 25.00 (Windows)

#ifndef IdstackwindowsHPP
#define IdstackwindowsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdStackBSDBase.hpp>	// Pascal unit
#include <IdStackConsts.hpp>	// Pascal unit
#include <IdWinsock2.hpp>	// Pascal unit
#include <IdStack.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idstackwindows
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdIPv6Unavailable;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIPv6Unavailable : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIPv6Unavailable(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIPv6Unavailable(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIPv6Unavailable(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIPv6Unavailable(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIPv6Unavailable(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIPv6Unavailable(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIPv6Unavailable(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIPv6Unavailable(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIPv6Unavailable(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIPv6Unavailable(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIPv6Unavailable(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIPv6Unavailable(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIPv6Unavailable(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdSocketListWindows;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSocketListWindows : public Idstack::TIdSocketList
{
	typedef Idstack::TIdSocketList inherited;
	
protected:
	Idwinsock2::TFDSet FFDSet;
	__classmethod bool __fastcall FDSelect(Idwinsock2::PFDSet AReadSet, Idwinsock2::PFDSet AWriteSet, Idwinsock2::PFDSet AExceptSet, const int ATimeout = 0xfffffffe);
	virtual NativeUInt __fastcall GetItem(int AIndex);
	
public:
	virtual void __fastcall Add(NativeUInt AHandle);
	virtual void __fastcall Remove(NativeUInt AHandle);
	virtual int __fastcall Count(void);
	virtual void __fastcall Clear(void);
	virtual Idstack::TIdSocketList* __fastcall Clone(void);
	virtual bool __fastcall ContainsSocket(NativeUInt AHandle);
	void __fastcall GetFDSet(Idwinsock2::TFDSet &VSet);
	void __fastcall SetFDSet(Idwinsock2::TFDSet &VSet);
	__classmethod virtual bool __fastcall Select(Idstack::TIdSocketList* AReadList, Idstack::TIdSocketList* AWriteList, Idstack::TIdSocketList* AExceptList, const int ATimeout = 0xfffffffe);
	virtual bool __fastcall SelectRead(const int ATimeout = 0xfffffffe);
	virtual bool __fastcall SelectReadList(Idstack::TIdSocketList* &VSocketList, const int ATimeout = 0xfffffffe);
public:
	/* TIdSocketList.Create */ inline __fastcall virtual TIdSocketListWindows(void) : Idstack::TIdSocketList() { }
	/* TIdSocketList.Destroy */ inline __fastcall virtual ~TIdSocketListWindows(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdStackWindows;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdStackWindows : public Idstackbsdbase::TIdStackBSDBase
{
	typedef Idstackbsdbase::TIdStackBSDBase inherited;
	
protected:
	void __fastcall WSQuerryIPv6Route(NativeUInt ASocket, const System::UnicodeString AIP, const System::Word APort, void *VSource, void *VDest);
	void __fastcall WriteChecksumIPv6(NativeUInt s, Idglobal::TIdBytes &VBuffer, const int AOffset, const System::UnicodeString AIP, const System::Word APort);
	virtual System::UnicodeString __fastcall HostByName(const System::UnicodeString AHostName, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	virtual System::UnicodeString __fastcall ReadHostName(void);
	virtual int __fastcall WSCloseSocket(NativeUInt ASocket);
	virtual int __fastcall WSRecv(NativeUInt ASocket, void *ABuffer, const int ABufferLength, const int AFlags);
	virtual int __fastcall WSSend(NativeUInt ASocket, const void *ABuffer, const int ABufferLength, const int AFlags);
	virtual int __fastcall WSShutdown(NativeUInt ASocket, int AHow);
	
public:
	virtual NativeUInt __fastcall Accept(NativeUInt ASocket, System::UnicodeString &VIP, System::Word &VPort, Idglobal::TIdIPVersion &VIPVersion)/* overload */;
	virtual System::Word __fastcall HostToNetwork(System::Word AValue)/* overload */;
	virtual unsigned __fastcall HostToNetwork(unsigned AValue)/* overload */;
	virtual unsigned __int64 __fastcall HostToNetwork(unsigned __int64 AValue)/* overload */;
	virtual void __fastcall Listen(NativeUInt ASocket, int ABackLog);
	virtual System::Word __fastcall NetworkToHost(System::Word AValue)/* overload */;
	virtual unsigned __fastcall NetworkToHost(unsigned AValue)/* overload */;
	virtual unsigned __int64 __fastcall NetworkToHost(unsigned __int64 AValue)/* overload */;
	virtual void __fastcall SetBlocking(NativeUInt ASocket, const bool ABlocking);
	virtual bool __fastcall WouldBlock(const int AResult);
	virtual System::UnicodeString __fastcall HostByAddress(const System::UnicodeString AAddress, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	virtual System::Word __fastcall WSGetServByName(const System::UnicodeString AServiceName);
	virtual void __fastcall AddServByPortToList(const System::Word APortNumber, System::Classes::TStrings* AAddresses);
	virtual int __fastcall RecvFrom(const NativeUInt ASocket, void *VBuffer, const int ALength, const int AFlags, System::UnicodeString &VIP, System::Word &VPort, Idglobal::TIdIPVersion &VIPVersion);
	virtual unsigned __fastcall ReceiveMsg(NativeUInt ASocket, Idglobal::TIdBytes &VBuffer, Idstack::TIdPacketInfo* APkt);
	virtual void __fastcall WSSendTo(NativeUInt ASocket, const void *ABuffer, const int ABufferLength, const int AFlags, const System::UnicodeString AIP, const System::Word APort, Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	virtual NativeUInt __fastcall WSSocket(int AFamily, int AStruct, int AProtocol, const bool ANonBlocking = false);
	virtual System::UnicodeString __fastcall WSTranslateSocketErrorMsg(const int AErr);
	virtual int __fastcall WSGetLastError(void);
	virtual void __fastcall WSSetLastError(const int AErr);
	virtual void __fastcall Bind(NativeUInt ASocket, const System::UnicodeString AIP, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	virtual void __fastcall Connect(const NativeUInt ASocket, const System::UnicodeString AIP, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	__fastcall virtual TIdStackWindows(void);
	__fastcall virtual ~TIdStackWindows(void);
	virtual void __fastcall Disconnect(NativeUInt ASocket);
	virtual void __fastcall GetPeerName(NativeUInt ASocket, System::UnicodeString &VIP, System::Word &VPort, Idglobal::TIdIPVersion &VIPVersion)/* overload */;
	virtual void __fastcall GetSocketName(NativeUInt ASocket, System::UnicodeString &VIP, System::Word &VPort, Idglobal::TIdIPVersion &VIPVersion)/* overload */;
	virtual void __fastcall GetSocketOption(NativeUInt ASocket, int ALevel, int AOptName, void *AOptVal, int &AOptLen)/* overload */;
	virtual void __fastcall SetSocketOption(NativeUInt ASocket, int ALevel, int AOptName, const void *AOptVal, const int AOptLen)/* overload */;
	virtual int __fastcall IOControl(const NativeUInt s, const unsigned cmd, unsigned &arg);
	virtual bool __fastcall SupportsIPv4(void);
	virtual bool __fastcall SupportsIPv6(void);
	virtual bool __fastcall CheckIPVersionSupport(const Idglobal::TIdIPVersion AIPVersion);
	virtual void __fastcall WriteChecksum(NativeUInt s, Idglobal::TIdBytes &VBuffer, const int AOffset, const System::UnicodeString AIP, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	virtual void __fastcall GetLocalAddressList(Idstack::TIdStackLocalAddressList* AAddresses);
	virtual void __fastcall SetKeepAliveValues(NativeUInt ASocket, const bool AEnabled, const int ATimeMS, const int AInterval);
/* Hoisted overloads: */
	
public:
	inline NativeUInt __fastcall  Accept(NativeUInt ASocket, System::UnicodeString &VIP, System::Word &VPort){ return Idstack::TIdStack::Accept(ASocket, VIP, VPort); }
	inline Idglobal::TIdIPv6Address __fastcall  HostToNetwork(const Idglobal::TIdIPv6Address &AValue){ return Idstack::TIdStack::HostToNetwork(AValue); }
	inline Idglobal::TIdIPv6Address __fastcall  NetworkToHost(const Idglobal::TIdIPv6Address &AValue){ return Idstack::TIdStack::NetworkToHost(AValue); }
	inline void __fastcall  GetPeerName(NativeUInt ASocket, System::UnicodeString &VIP, System::Word &VPort){ Idstack::TIdStack::GetPeerName(ASocket, VIP, VPort); }
	inline void __fastcall  GetSocketName(NativeUInt ASocket, System::UnicodeString &VIP, System::Word &VPort){ Idstack::TIdStack::GetSocketName(ASocket, VIP, VPort); }
	inline void __fastcall  GetSocketOption(NativeUInt ASocket, int ALevel, int AOptName, /* out */ int &AOptVal){ Idstackbsdbase::TIdStackBSDBase::GetSocketOption(ASocket, ALevel, AOptName, AOptVal); }
	inline void __fastcall  SetSocketOption(NativeUInt ASocket, int ALevel, int AOptName, int AOptVal){ Idstackbsdbase::TIdStackBSDBase::SetSocketOption(ASocket, ALevel, AOptName, AOptVal); }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TIdStackWindows* GWindowsStack;
}	/* namespace Idstackwindows */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSTACKWINDOWS)
using namespace Idstackwindows;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdstackwindowsHPP
