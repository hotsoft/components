// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSMTPRelay.pas' rev: 25.00 (Windows)

#ifndef IdsmtprelayHPP
#define IdsmtprelayHPP

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
#include <IdExceptionCore.hpp>	// Pascal unit
#include <IdEMailAddress.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdHeaderList.hpp>	// Pascal unit
#include <IdDNSResolver.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit
#include <IdMessageClient.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdSMTPBase.hpp>	// Pascal unit
#include <IdReplySMTP.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdExplicitTLSClientServerBase.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsmtprelay
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdSMTPRelayStatusAction : unsigned char { dmResolveMS, dmConnecting, dmConnected, dmSending, dmWorkBegin, dmWorkEndOK, dmWorkEndWithException };

typedef void __fastcall (__closure *TIdSMTPRelayStatus)(System::TObject* Sender, Idemailaddress::TIdEMailAddressItem* AEMailAddress, TIdSMTPRelayStatusAction Action);

class DELPHICLASS EIdDirectSMTPCannotAssignHost;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdDirectSMTPCannotAssignHost : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdDirectSMTPCannotAssignHost(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdDirectSMTPCannotAssignHost(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdDirectSMTPCannotAssignHost(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdDirectSMTPCannotAssignHost(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDirectSMTPCannotAssignHost(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDirectSMTPCannotAssignHost(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdDirectSMTPCannotAssignHost(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdDirectSMTPCannotAssignHost(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDirectSMTPCannotAssignHost(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDirectSMTPCannotAssignHost(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDirectSMTPCannotAssignHost(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDirectSMTPCannotAssignHost(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdDirectSMTPCannotAssignHost(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdDirectSMTPCannotResolveMX;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdDirectSMTPCannotResolveMX : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdDirectSMTPCannotResolveMX(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdDirectSMTPCannotResolveMX(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdDirectSMTPCannotResolveMX(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdDirectSMTPCannotResolveMX(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDirectSMTPCannotResolveMX(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDirectSMTPCannotResolveMX(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdDirectSMTPCannotResolveMX(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdDirectSMTPCannotResolveMX(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDirectSMTPCannotResolveMX(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDirectSMTPCannotResolveMX(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDirectSMTPCannotResolveMX(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDirectSMTPCannotResolveMX(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdDirectSMTPCannotResolveMX(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TIdSSLSupport : unsigned char { NoSSL, SupportSSL, RequireSSL };

class DELPHICLASS TIdSMTPRelayStatusItem;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSMTPRelayStatusItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	bool FSent;
	System::UnicodeString FExceptionMessage;
	System::UnicodeString FEmailAddress;
	int FReplyCode;
	Idreplysmtp::TIdSMTPEnhancedCode* FEnhancedCode;
	void __fastcall SetEnhancedCode(Idreplysmtp::TIdSMTPEnhancedCode* const Value);
	
public:
	__fastcall virtual TIdSMTPRelayStatusItem(System::Classes::TCollection* Collection);
	__fastcall virtual ~TIdSMTPRelayStatusItem(void);
	
__published:
	__property System::UnicodeString EmailAddress = {read=FEmailAddress, write=FEmailAddress};
	__property System::UnicodeString ExceptionMessage = {read=FExceptionMessage, write=FExceptionMessage};
	__property bool Sent = {read=FSent, write=FSent, default=0};
	__property int ReplyCode = {read=FReplyCode, write=FReplyCode, default=0};
	__property Idreplysmtp::TIdSMTPEnhancedCode* EnhancedCode = {read=FEnhancedCode, write=SetEnhancedCode};
};

#pragma pack(pop)

class DELPHICLASS TIdSMTPRelayStatusList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSMTPRelayStatusList : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TIdSMTPRelayStatusItem* operator[](int Index) { return Items[Index]; }
	
protected:
	TIdSMTPRelayStatusItem* __fastcall GetItems(int Index);
	void __fastcall SetItems(int Index, TIdSMTPRelayStatusItem* const Value);
	
public:
	HIDESBASE TIdSMTPRelayStatusItem* __fastcall Add(void);
	__property TIdSMTPRelayStatusItem* Items[int Index] = {read=GetItems, write=SetItems/*, default*/};
public:
	/* TOwnedCollection.Create */ inline __fastcall TIdSMTPRelayStatusList(System::Classes::TPersistent* AOwner, System::Classes::TCollectionItemClass ItemClass) : System::Classes::TOwnedCollection(AOwner, ItemClass) { }
	
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdSMTPRelayStatusList(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdSSLSupportOptions;
class DELPHICLASS TIdSMTPRelay;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdSSLSupportOptions : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
protected:
	TIdSSLSupport FSSLSupport;
	bool FTryImplicitTLS;
	TIdSMTPRelay* FOwner;
	void __fastcall SetSSLSupport(const TIdSSLSupport Value);
	void __fastcall SetTryImplicitTLS(const bool Value);
	
public:
	__fastcall TIdSSLSupportOptions(TIdSMTPRelay* AOwner);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property TIdSSLSupport SSLSupport = {read=FSSLSupport, write=SetSSLSupport, default=0};
	__property bool TryImplicitTLS = {read=FTryImplicitTLS, write=SetTryImplicitTLS, default=0};
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdSSLSupportOptions(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TIdSMTPRelay : public Idsmtpbase::TIdSMTPBase
{
	typedef Idsmtpbase::TIdSMTPBase inherited;
	
protected:
	System::Classes::TStrings* FMXServerList;
	TIdSMTPRelayStatusList* FStatusList;
	System::UnicodeString FDNSServer;
	TIdSMTPRelayStatus FOnDirectSMTPStatus;
	TIdSSLSupportOptions* FSSLOptions;
	System::UnicodeString FRelaySender;
	HIDESBASE void __fastcall Connect(Idemailaddress::TIdEMailAddressItem* AEMailAddress);
	void __fastcall ResolveMXServers(System::UnicodeString AAddress);
	void __fastcall SetDNSServer(const System::UnicodeString Value);
	void __fastcall SetOnStatus(const TIdSMTPRelayStatus Value);
	virtual void __fastcall SetUseEhlo(const bool AValue);
	virtual void __fastcall SetHost(const System::UnicodeString Value);
	virtual bool __fastcall GetSupportsTLS(void);
	void __fastcall ProcessException(System::Sysutils::Exception* AException, Idemailaddress::TIdEMailAddressItem* AEMailAddress);
	void __fastcall SetSSLOptions(TIdSSLSupportOptions* const Value);
	void __fastcall SetRelaySender(const System::UnicodeString Value);
	virtual void __fastcall InitComponent(void);
	__property Port;
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual ~TIdSMTPRelay(void);
	virtual void __fastcall DisconnectNotifyPeer(void);
	virtual void __fastcall Send(Idmessage::TIdMessage* AMsg, Idemailaddress::TIdEMailAddressList* ARecipients)/* overload */;
	
__published:
	__property System::UnicodeString DNSServer = {read=FDNSServer, write=SetDNSServer};
	__property System::UnicodeString RelaySender = {read=FRelaySender, write=SetRelaySender};
	__property TIdSMTPRelayStatusList* StatusList = {read=FStatusList};
	__property TIdSSLSupportOptions* SSLOptions = {read=FSSLOptions, write=SetSSLOptions};
	__property TIdSMTPRelayStatus OnDirectSMTPStatus = {read=FOnDirectSMTPStatus, write=SetOnStatus};
	__property OnTLSHandShakeFailed;
	__property OnTLSNotAvailable;
	__property OnTLSNegCmdFailed;
public:
	/* TIdMessageClient.Create */ inline __fastcall TIdSMTPRelay(System::Classes::TComponent* AOwner)/* overload */ : Idsmtpbase::TIdSMTPBase(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSMTPRelay(void)/* overload */ : Idsmtpbase::TIdSMTPBase() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Send(Idmessage::TIdMessage* AMsg){ Idsmtpbase::TIdSMTPBase::Send(AMsg); }
	inline void __fastcall  Send(Idmessage::TIdMessage* AMsg, const System::UnicodeString AFrom){ Idsmtpbase::TIdSMTPBase::Send(AMsg, AFrom); }
	inline void __fastcall  Send(Idmessage::TIdMessage* AMsg, Idemailaddress::TIdEMailAddressList* ARecipients, const System::UnicodeString AFrom){ Idsmtpbase::TIdSMTPBase::Send(AMsg, ARecipients, AFrom); }
	
};


//-- var, const, procedure ---------------------------------------------------
static const bool DEF_OneConnectionPerDomain = true;
static const TIdSSLSupport DEF_SSL_SUPPORT = (TIdSSLSupport)(0);
static const bool DEF_TRY_IMPLICITTLS = false;
static const System::Int8 DEF_REPLY_CODE = System::Int8(0x0);
static const bool DEF_SENT = false;
}	/* namespace Idsmtprelay */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSMTPRELAY)
using namespace Idsmtprelay;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsmtprelayHPP
