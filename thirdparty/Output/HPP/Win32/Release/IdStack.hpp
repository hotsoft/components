// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdStack.pas' rev: 25.00 (Windows)

#ifndef IdstackHPP
#define IdstackHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdStackConsts.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idstack
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdSocketError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdSocketError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
protected:
	int FLastError;
	
public:
	__fastcall virtual EIdSocketError(const int AErr, const System::UnicodeString AMsg);
	__property int LastError = {read=FLastError, nodefault};
public:
	/* EIdException.Create */ inline __fastcall virtual EIdSocketError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdSocketError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocketError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdSocketError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocketError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdSocketError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdSocketError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdSocketError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocketError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdSocketError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocketError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdSocketError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdSocketError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdStackError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdStackError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdStackError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdStackError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdStackError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdStackError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdStackError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdStackError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdStackError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdStackError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdStackError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdStackError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdStackError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdStackError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdStackError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdIPVersionUnsupported;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIPVersionUnsupported : public EIdStackError
{
	typedef EIdStackError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIPVersionUnsupported(const System::UnicodeString AMsg)/* overload */ : EIdStackError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIPVersionUnsupported(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdStackError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIPVersionUnsupported(NativeUInt Ident)/* overload */ : EIdStackError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIPVersionUnsupported(System::PResStringRec ResStringRec)/* overload */ : EIdStackError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIPVersionUnsupported(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdStackError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIPVersionUnsupported(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdStackError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIPVersionUnsupported(const System::UnicodeString Msg, int AHelpContext) : EIdStackError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIPVersionUnsupported(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdStackError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIPVersionUnsupported(NativeUInt Ident, int AHelpContext)/* overload */ : EIdStackError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIPVersionUnsupported(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdStackError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIPVersionUnsupported(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdStackError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIPVersionUnsupported(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdStackError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIPVersionUnsupported(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdMaliciousPtrRecord;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdMaliciousPtrRecord : public EIdSocketError
{
	typedef EIdSocketError inherited;
	
public:
	/* EIdSocketError.CreateError */ inline __fastcall virtual EIdMaliciousPtrRecord(const int AErr, const System::UnicodeString AMsg) : EIdSocketError(AErr, AMsg) { }
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdMaliciousPtrRecord(const System::UnicodeString AMsg)/* overload */ : EIdSocketError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdMaliciousPtrRecord(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocketError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdMaliciousPtrRecord(NativeUInt Ident)/* overload */ : EIdSocketError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdMaliciousPtrRecord(System::PResStringRec ResStringRec)/* overload */ : EIdSocketError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMaliciousPtrRecord(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMaliciousPtrRecord(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdMaliciousPtrRecord(const System::UnicodeString Msg, int AHelpContext) : EIdSocketError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdMaliciousPtrRecord(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocketError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMaliciousPtrRecord(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocketError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMaliciousPtrRecord(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocketError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMaliciousPtrRecord(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMaliciousPtrRecord(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdMaliciousPtrRecord(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdNotASocket;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNotASocket : public EIdSocketError
{
	typedef EIdSocketError inherited;
	
public:
	/* EIdSocketError.CreateError */ inline __fastcall virtual EIdNotASocket(const int AErr, const System::UnicodeString AMsg) : EIdSocketError(AErr, AMsg) { }
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNotASocket(const System::UnicodeString AMsg)/* overload */ : EIdSocketError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNotASocket(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdSocketError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNotASocket(NativeUInt Ident)/* overload */ : EIdSocketError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNotASocket(System::PResStringRec ResStringRec)/* overload */ : EIdSocketError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNotASocket(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNotASocket(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdSocketError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNotASocket(const System::UnicodeString Msg, int AHelpContext) : EIdSocketError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNotASocket(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdSocketError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNotASocket(NativeUInt Ident, int AHelpContext)/* overload */ : EIdSocketError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNotASocket(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdSocketError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNotASocket(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNotASocket(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdSocketError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNotASocket(void) { }
	
};

#pragma pack(pop)

typedef __int64 __fastcall (*TIdServeFile)(NativeUInt ASocket, const System::UnicodeString AFileName);

class DELPHICLASS TIdPacketInfo;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdPacketInfo : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::UnicodeString FSourceIP;
	System::Word FSourcePort;
	unsigned FSourceIF;
	Idglobal::TIdIPVersion FSourceIPVersion;
	System::UnicodeString FDestIP;
	System::Word FDestPort;
	unsigned FDestIF;
	Idglobal::TIdIPVersion FDestIPVersion;
	System::Byte FTTL;
	
public:
	void __fastcall Reset(void);
	__property System::Byte TTL = {read=FTTL, write=FTTL, nodefault};
	__property System::UnicodeString SourceIP = {read=FSourceIP, write=FSourceIP};
	__property System::Word SourcePort = {read=FSourcePort, write=FSourcePort, nodefault};
	__property unsigned SourceIF = {read=FSourceIF, write=FSourceIF, nodefault};
	__property Idglobal::TIdIPVersion SourceIPVersion = {read=FSourceIPVersion, write=FSourceIPVersion, nodefault};
	__property System::UnicodeString DestIP = {read=FDestIP, write=FDestIP};
	__property System::Word DestPort = {read=FDestPort, write=FDestPort, nodefault};
	__property unsigned DestIF = {read=FDestIF, write=FDestIF, nodefault};
	__property Idglobal::TIdIPVersion DestIPVersion = {read=FDestIPVersion, write=FDestIPVersion, nodefault};
public:
	/* TObject.Create */ inline __fastcall TIdPacketInfo(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdPacketInfo(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TIdSocketListClass;

class DELPHICLASS TIdSocketList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSocketList : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	NativeUInt operator[](int AIndex) { return Items[AIndex]; }
	
protected:
	Idglobal::TIdCriticalSection* FLock;
	virtual NativeUInt __fastcall GetItem(int AIndex) = 0 ;
	
public:
	__fastcall virtual TIdSocketList(void);
	__fastcall virtual ~TIdSocketList(void);
	virtual void __fastcall Add(NativeUInt AHandle) = 0 ;
	virtual TIdSocketList* __fastcall Clone(void) = 0 ;
	virtual int __fastcall Count(void) = 0 ;
	__classmethod TIdSocketList* __fastcall CreateSocketList();
	__property NativeUInt Items[int AIndex] = {read=GetItem/*, default*/};
	virtual void __fastcall Remove(NativeUInt AHandle) = 0 ;
	virtual void __fastcall Clear(void) = 0 ;
	virtual bool __fastcall ContainsSocket(NativeUInt AHandle) = 0 ;
	void __fastcall Lock(void);
	__classmethod virtual bool __fastcall Select(TIdSocketList* AReadList, TIdSocketList* AWriteList, TIdSocketList* AExceptList, const int ATimeout = 0xfffffffe);
	virtual bool __fastcall SelectRead(const int ATimeout = 0xfffffffe) = 0 ;
	virtual bool __fastcall SelectReadList(TIdSocketList* &VSocketList, const int ATimeout = 0xfffffffe) = 0 ;
	void __fastcall Unlock(void);
};

#pragma pack(pop)

class DELPHICLASS TIdStackLocalAddress;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdStackLocalAddress : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	Idglobal::TIdIPVersion FIPVersion;
	System::UnicodeString FIPAddress;
	System::UnicodeString FInterfaceName;
	unsigned FInterfaceIndex;
	
public:
	__fastcall TIdStackLocalAddress(System::Classes::TCollection* ACollection, const Idglobal::TIdIPVersion AIPVersion, const System::UnicodeString AIPAddress);
	__property Idglobal::TIdIPVersion IPVersion = {read=FIPVersion, nodefault};
	__property System::UnicodeString IPAddress = {read=FIPAddress};
	__property System::UnicodeString InterfaceName = {read=FInterfaceName};
	__property unsigned InterfaceIndex = {read=FInterfaceIndex, nodefault};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdStackLocalAddress(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdStackLocalAddressIPv4;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdStackLocalAddressIPv4 : public TIdStackLocalAddress
{
	typedef TIdStackLocalAddress inherited;
	
protected:
	System::UnicodeString FSubNetMask;
	
public:
	__fastcall TIdStackLocalAddressIPv4(System::Classes::TCollection* ACollection, const System::UnicodeString AIPAddress, const System::UnicodeString ASubNetMask);
	__property System::UnicodeString SubNetMask = {read=FSubNetMask};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdStackLocalAddressIPv4(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdStackLocalAddressIPv6;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdStackLocalAddressIPv6 : public TIdStackLocalAddress
{
	typedef TIdStackLocalAddress inherited;
	
public:
	__fastcall TIdStackLocalAddressIPv6(System::Classes::TCollection* ACollection, const System::UnicodeString AIPAddress);
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdStackLocalAddressIPv6(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdStackLocalAddressList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdStackLocalAddressList : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TIdStackLocalAddress* operator[](int AIndex) { return Addresses[AIndex]; }
	
protected:
	TIdStackLocalAddress* __fastcall GetAddress(int AIndex);
	
public:
	__fastcall TIdStackLocalAddressList(void);
	int __fastcall IndexOfIP(const System::UnicodeString AIP)/* overload */;
	int __fastcall IndexOfIP(const System::UnicodeString AIP, Idglobal::TIdIPVersion AIPVersion)/* overload */;
	__property TIdStackLocalAddress* Addresses[int AIndex] = {read=GetAddress/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdStackLocalAddressList(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdStack;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdStack : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::Classes::TStrings* FLocalAddresses;
	void __fastcall IPVersionUnsupported(void);
	virtual System::UnicodeString __fastcall HostByName(const System::UnicodeString AHostName, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0)) = 0 ;
	System::UnicodeString __fastcall MakeCanonicalIPv6Address _DEPRECATED_ATTRIBUTE1("Use IdGlobal.MakeCanonicalIPv6Address()") (const System::UnicodeString AAddr);
	virtual System::UnicodeString __fastcall ReadHostName(void) = 0 ;
	System::UnicodeString __fastcall GetLocalAddress(void);
	System::Classes::TStrings* __fastcall GetLocalAddresses(void);
	
public:
	NativeUInt __fastcall Accept(NativeUInt ASocket, System::UnicodeString &VIP, System::Word &VPort)/* overload */;
	virtual NativeUInt __fastcall Accept(NativeUInt ASocket, System::UnicodeString &VIP, System::Word &VPort, Idglobal::TIdIPVersion &VIPVersion) = 0 /* overload */;
	virtual void __fastcall Bind(NativeUInt ASocket, const System::UnicodeString AIP, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0)) = 0 ;
	virtual void __fastcall Connect(const NativeUInt ASocket, const System::UnicodeString AIP, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0)) = 0 ;
	__fastcall virtual TIdStack(void);
	__fastcall virtual ~TIdStack(void);
	virtual void __fastcall Disconnect(NativeUInt ASocket) = 0 ;
	virtual int __fastcall IOControl(const NativeUInt s, const unsigned cmd, unsigned &arg) = 0 ;
	__classmethod void __fastcall IncUsage();
	__classmethod void __fastcall DecUsage();
	void __fastcall GetPeerName(NativeUInt ASocket, System::UnicodeString &VIP, System::Word &VPort)/* overload */;
	virtual void __fastcall GetPeerName(NativeUInt ASocket, System::UnicodeString &VIP, System::Word &VPort, Idglobal::TIdIPVersion &VIPVersion) = 0 /* overload */;
	void __fastcall GetSocketName(NativeUInt ASocket, System::UnicodeString &VIP, System::Word &VPort)/* overload */;
	virtual void __fastcall GetSocketName(NativeUInt ASocket, System::UnicodeString &VIP, System::Word &VPort, Idglobal::TIdIPVersion &VIPVersion) = 0 /* overload */;
	virtual System::UnicodeString __fastcall HostByAddress(const System::UnicodeString AAddress, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0)) = 0 ;
	virtual System::Word __fastcall HostToNetwork(System::Word AValue) = 0 /* overload */;
	virtual unsigned __fastcall HostToNetwork(unsigned AValue) = 0 /* overload */;
	virtual unsigned __int64 __fastcall HostToNetwork(unsigned __int64 AValue) = 0 /* overload */;
	virtual Idglobal::TIdIPv6Address __fastcall HostToNetwork(const Idglobal::TIdIPv6Address &AValue)/* overload */;
	bool __fastcall IsIP(System::UnicodeString AIP);
	virtual void __fastcall Listen(NativeUInt ASocket, int ABackLog) = 0 ;
	virtual int __fastcall WSGetLastError(void) = 0 ;
	virtual void __fastcall WSSetLastError(const int AErr) = 0 ;
	virtual System::UnicodeString __fastcall WSTranslateSocketErrorMsg(const int AErr);
	int __fastcall CheckForSocketError(const int AResult)/* overload */;
	int __fastcall CheckForSocketError(const int AResult, int const *AIgnore, const int AIgnore_Size)/* overload */;
	void __fastcall RaiseLastSocketError(void);
	virtual void __fastcall RaiseSocketError(int AErr);
	virtual NativeUInt __fastcall NewSocketHandle(const int ASocketType, const int AProtocol, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0), const bool ANonBlocking = false) = 0 ;
	virtual System::Word __fastcall NetworkToHost(System::Word AValue) = 0 /* overload */;
	virtual unsigned __fastcall NetworkToHost(unsigned AValue) = 0 /* overload */;
	virtual unsigned __int64 __fastcall NetworkToHost(unsigned __int64 AValue) = 0 /* overload */;
	virtual Idglobal::TIdIPv6Address __fastcall NetworkToHost(const Idglobal::TIdIPv6Address &AValue)/* overload */;
	virtual void __fastcall GetSocketOption(NativeUInt ASocket, int ALevel, int AOptName, /* out */ int &AOptVal) = 0 /* overload */;
	virtual void __fastcall SetSocketOption(NativeUInt ASocket, int ALevel, int AOptName, int AOptVal) = 0 /* overload */;
	System::UnicodeString __fastcall ResolveHost(const System::UnicodeString AHost, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0));
	virtual int __fastcall Receive(NativeUInt ASocket, Idglobal::TIdBytes &VBuffer) = 0 ;
	virtual int __fastcall Send(NativeUInt ASocket, const Idglobal::TIdBytes ABuffer, const int AOffset = 0x0, const int ASize = 0xffffffff) = 0 ;
	virtual int __fastcall ReceiveFrom(NativeUInt ASocket, Idglobal::TIdBytes &VBuffer, System::UnicodeString &VIP, System::Word &VPort, Idglobal::TIdIPVersion &VIPVersion) = 0 ;
	int __fastcall SendTo(NativeUInt ASocket, const Idglobal::TIdBytes ABuffer, const int AOffset, const System::UnicodeString AIP, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0))/* overload */;
	virtual int __fastcall SendTo(NativeUInt ASocket, const Idglobal::TIdBytes ABuffer, const int AOffset, const int ASize, const System::UnicodeString AIP, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0)) = 0 /* overload */;
	virtual unsigned __fastcall ReceiveMsg(NativeUInt ASocket, Idglobal::TIdBytes &VBuffer, TIdPacketInfo* APkt) = 0 ;
	virtual bool __fastcall SupportsIPv4(void) = 0 ;
	virtual bool __fastcall SupportsIPv6(void) = 0 ;
	bool __fastcall IsValidIPv4MulticastGroup(const System::UnicodeString Value);
	bool __fastcall IsValidIPv6MulticastGroup(const System::UnicodeString Value);
	virtual void __fastcall SetKeepAliveValues(NativeUInt ASocket, const bool AEnabled, const int ATimeMS, const int AInterval);
	virtual void __fastcall SetMulticastTTL(NativeUInt AHandle, const System::Byte AValue, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0)) = 0 ;
	virtual void __fastcall SetLoopBack(NativeUInt AHandle, const bool AValue, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0)) = 0 ;
	virtual void __fastcall DropMulticastMembership(NativeUInt AHandle, const System::UnicodeString AGroupIP, const System::UnicodeString ALocalIP, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0)) = 0 ;
	virtual void __fastcall AddMulticastMembership(NativeUInt AHandle, const System::UnicodeString AGroupIP, const System::UnicodeString ALocalIP, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0)) = 0 ;
	virtual System::Word __fastcall CalcCheckSum(const Idglobal::TIdBytes AData);
	virtual void __fastcall WriteChecksum(NativeUInt s, Idglobal::TIdBytes &VBuffer, const int AOffset, const System::UnicodeString AIP, const System::Word APort, const Idglobal::TIdIPVersion AIPVersion = (Idglobal::TIdIPVersion)(0x0)) = 0 ;
	void __fastcall AddLocalAddressesToList _DEPRECATED_ATTRIBUTE1("use GetLocalAddressList()") (System::Classes::TStrings* AAddresses);
	virtual void __fastcall GetLocalAddressList(TIdStackLocalAddressList* AAddresses) = 0 ;
	__property System::UnicodeString HostName = {read=ReadHostName};
	__property System::UnicodeString LocalAddress = {read=GetLocalAddress};
	__property System::Classes::TStrings* LocalAddresses = {read=GetLocalAddresses};
};

#pragma pack(pop)

typedef System::TMetaClass* TIdStackClass;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TIdStack* GStack;
extern DELPHI_PACKAGE TIdServeFile GServeFileProc;
extern DELPHI_PACKAGE TIdSocketListClass GSocketListClass;
extern DELPHI_PACKAGE void __fastcall SetStackClass(TIdStackClass AStackClass);
}	/* namespace Idstack */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSTACK)
using namespace Idstack;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdstackHPP
