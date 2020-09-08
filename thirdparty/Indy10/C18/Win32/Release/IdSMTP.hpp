// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSMTP.pas' rev: 25.00 (Windows)

#ifndef IdsmtpHPP
#define IdsmtpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdEMailAddress.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdExplicitTLSClientServerBase.hpp>	// Pascal unit
#include <IdHeaderList.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit
#include <IdMessageClient.hpp>	// Pascal unit
#include <IdSASL.hpp>	// Pascal unit
#include <IdSASLCollection.hpp>	// Pascal unit
#include <IdSMTPBase.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsmtp
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdSMTPAuthenticationType : unsigned char { satNone, satDefault, satSASL };

class DELPHICLASS TIdSMTP;
class PASCALIMPLEMENTATION TIdSMTP : public Idsmtpbase::TIdSMTPBase
{
	typedef Idsmtpbase::TIdSMTPBase inherited;
	
protected:
	TIdSMTPAuthenticationType FAuthType;
	bool FDidAuthenticate;
	bool FValidateAuthLoginCapability;
	Idsaslcollection::TIdSASLEntries* FSASLMechanisms;
	void __fastcall SetAuthType(const TIdSMTPAuthenticationType AValue);
	virtual void __fastcall SetUseEhlo(const bool AValue);
	virtual void __fastcall SetUseTLS(Idexplicittlsclientserverbase::TIdUseTLS AValue);
	void __fastcall SetSASLMechanisms(Idsaslcollection::TIdSASLEntries* AValue);
	virtual void __fastcall InitComponent(void);
	virtual void __fastcall InternalSend(Idmessage::TIdMessage* AMsg, const System::UnicodeString AFrom, Idemailaddress::TIdEMailAddressList* ARecipients);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	__property OnConnected;
	
public:
	__fastcall virtual ~TIdSMTP(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual bool __fastcall Authenticate(void);
	virtual void __fastcall Connect(void)/* overload */;
	virtual void __fastcall Disconnect(bool ANotifyPeer)/* overload */;
	virtual void __fastcall DisconnectNotifyPeer(void);
	__classmethod void __fastcall QuickSend _DEPRECATED_ATTRIBUTE1("Use ContentType overload of QuickSend()") (const System::UnicodeString AHost, const System::UnicodeString ASubject, const System::UnicodeString ATo, const System::UnicodeString AFrom, const System::UnicodeString AText)/* overload */;
	__classmethod void __fastcall QuickSend(const System::UnicodeString AHost, const System::UnicodeString ASubject, const System::UnicodeString ATo, const System::UnicodeString AFrom, const System::UnicodeString AText, const System::UnicodeString AContentType, const System::UnicodeString ACharset, const System::UnicodeString AContentTransferEncoding)/* overload */;
	virtual void __fastcall Expand(System::UnicodeString AUserName, System::Classes::TStrings* AResults);
	virtual System::UnicodeString __fastcall Verify(System::UnicodeString AUserName);
	__property bool DidAuthenticate = {read=FDidAuthenticate, nodefault};
	
__published:
	__property TIdSMTPAuthenticationType AuthType = {read=FAuthType, write=FAuthType, default=1};
	__property Host = {default=0};
	__property Password = {default=0};
	__property Port = {default=25};
	__property Idsaslcollection::TIdSASLEntries* SASLMechanisms = {read=FSASLMechanisms, write=SetSASLMechanisms};
	__property UseTLS = {default=0};
	__property Username = {default=0};
	__property bool ValidateAuthLoginCapability = {read=FValidateAuthLoginCapability, write=FValidateAuthLoginCapability, default=1};
	__property OnTLSNotAvailable;
public:
	/* TIdMessageClient.Create */ inline __fastcall TIdSMTP(System::Classes::TComponent* AOwner)/* overload */ : Idsmtpbase::TIdSMTPBase(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSMTP(void)/* overload */ : Idsmtpbase::TIdSMTPBase() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Connect(const System::UnicodeString AHost){ Idtcpclient::TIdTCPClientCustom::Connect(AHost); }
	inline void __fastcall  Connect(const System::UnicodeString AHost, const System::Word APort){ Idtcpclient::TIdTCPClientCustom::Connect(AHost, APort); }
	inline void __fastcall  Disconnect(void){ Idtcpconnection::TIdTCPConnection::Disconnect(); }
	
};


//-- var, const, procedure ---------------------------------------------------
static const TIdSMTPAuthenticationType DEF_SMTP_AUTH = (TIdSMTPAuthenticationType)(1);
}	/* namespace Idsmtp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSMTP)
using namespace Idsmtp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsmtpHPP
