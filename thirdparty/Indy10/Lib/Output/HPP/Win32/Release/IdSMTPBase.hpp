// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdSMTPBase.pas' rev: 25.00 (Windows)

#ifndef IdsmtpbaseHPP
#define IdsmtpbaseHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdEMailAddress.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit
#include <IdMessageClient.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdExplicitTLSClientServerBase.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idsmtpbase
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TIdSMTPFailedRecipient)(System::TObject* Sender, const System::UnicodeString AAddress, const System::UnicodeString ACode, const System::UnicodeString AText, bool &VContinue);

class DELPHICLASS TIdSMTPBase;
class PASCALIMPLEMENTATION TIdSMTPBase : public Idmessageclient::TIdMessageClient
{
	typedef Idmessageclient::TIdMessageClient inherited;
	
protected:
	System::UnicodeString FMailAgent;
	System::UnicodeString FHeloName;
	bool FPipeline;
	bool FUseEhlo;
	bool FUseVerp;
	System::UnicodeString FVerpDelims;
	TIdSMTPFailedRecipient FOnFailedRecipient;
	virtual bool __fastcall GetSupportsTLS(void);
	virtual Idreply::TIdReplyClass __fastcall GetReplyClass(void);
	virtual void __fastcall InitComponent(void);
	void __fastcall SendGreeting(void);
	virtual void __fastcall SetUseEhlo(const bool AValue);
	void __fastcall SetPipeline(const bool AValue);
	void __fastcall StartTLS(void);
	bool __fastcall FailedRecipientCanContinue(const System::UnicodeString AAddress);
	bool __fastcall WriteRecipientNoPipelining(Idemailaddress::TIdEMailAddressItem* const AEmailAddress);
	void __fastcall WriteRecipientsNoPipelining(Idemailaddress::TIdEMailAddressList* AList);
	void __fastcall SendNoPipelining(Idmessage::TIdMessage* AMsg, const System::UnicodeString AFrom, Idemailaddress::TIdEMailAddressList* ARecipients);
	void __fastcall WriteRecipientPipeLine(Idemailaddress::TIdEMailAddressItem* const AEmailAddress);
	void __fastcall WriteRecipientsPipeLine(Idemailaddress::TIdEMailAddressList* AList);
	void __fastcall SendPipelining(Idmessage::TIdMessage* AMsg, const System::UnicodeString AFrom, Idemailaddress::TIdEMailAddressList* ARecipients);
	virtual void __fastcall InternalSend(Idmessage::TIdMessage* AMsg, const System::UnicodeString AFrom, Idemailaddress::TIdEMailAddressList* ARecipients);
	
public:
	virtual void __fastcall Send(Idmessage::TIdMessage* AMsg)/* overload */;
	virtual void __fastcall Send(Idmessage::TIdMessage* AMsg, Idemailaddress::TIdEMailAddressList* ARecipients)/* overload */;
	virtual void __fastcall Send(Idmessage::TIdMessage* AMsg, const System::UnicodeString AFrom)/* overload */;
	virtual void __fastcall Send(Idmessage::TIdMessage* AMsg, Idemailaddress::TIdEMailAddressList* ARecipients, const System::UnicodeString AFrom)/* overload */;
	
__published:
	__property System::UnicodeString MailAgent = {read=FMailAgent, write=FMailAgent};
	__property System::UnicodeString HeloName = {read=FHeloName, write=FHeloName};
	__property bool UseEhlo = {read=FUseEhlo, write=SetUseEhlo, default=1};
	__property bool PipeLine = {read=FPipeline, write=SetPipeline, default=0};
	__property bool UseVerp = {read=FUseVerp, write=FUseVerp, default=0};
	__property System::UnicodeString VerpDelims = {read=FVerpDelims, write=FVerpDelims};
	__property TIdSMTPFailedRecipient OnFailedRecipient = {read=FOnFailedRecipient, write=FOnFailedRecipient};
public:
	/* TIdMessageClient.Destroy */ inline __fastcall virtual ~TIdSMTPBase(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdSMTPBase(System::Classes::TComponent* AOwner)/* overload */ : Idmessageclient::TIdMessageClient(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdSMTPBase(void)/* overload */ : Idmessageclient::TIdMessageClient() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const bool DEF_SMTP_PIPELINE = false;
static const bool IdDEF_UseEhlo = true;
static const bool IdDEF_UseVerp = false;
#define CAPAPIPELINE L"PIPELINING"
#define CAPAVERP L"VERP"
#define XMAILER_HEADER L"X-Mailer"
extern DELPHI_PACKAGE System::StaticArray<short, 2> RCPTTO_ACCEPT;
extern DELPHI_PACKAGE short MAILFROM_ACCEPT;
extern DELPHI_PACKAGE short DATA_ACCEPT;
extern DELPHI_PACKAGE short DATA_PERIOD_ACCEPT;
extern DELPHI_PACKAGE short RSET_ACCEPT;
#define RSET_CMD L"RSET"
#define MAILFROM_CMD L"MAIL FROM:"
#define RCPTTO_CMD L"RCPT TO:"
#define DATA_CMD L"DATA"
}	/* namespace Idsmtpbase */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSMTPBASE)
using namespace Idsmtpbase;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdsmtpbaseHPP
