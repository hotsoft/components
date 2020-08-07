// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdPOP3.pas' rev: 25.00 (Windows)

#ifndef Idpop3HPP
#define Idpop3HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdExplicitTLSClientServerBase.hpp>	// Pascal unit
#include <IdGlobalProtocols.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit
#include <IdMessageClient.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <IdSASL.hpp>	// Pascal unit
#include <IdSASLCollection.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdUserPassProvider.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idpop3
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdPOP3AuthenticationType : unsigned char { patUserPass, patAPOP, patSASL };

class DELPHICLASS TIdPOP3;
class PASCALIMPLEMENTATION TIdPOP3 : public Idmessageclient::TIdMessageClient
{
	typedef Idmessageclient::TIdMessageClient inherited;
	
protected:
	TIdPOP3AuthenticationType FAuthType;
	bool FAutoLogin;
	System::UnicodeString FAPOPToken;
	bool FHasAPOP;
	bool FHasCAPA;
	Idsaslcollection::TIdSASLEntries* FSASLMechanisms;
	virtual Idreply::TIdReplyClass __fastcall GetReplyClass(void);
	virtual bool __fastcall GetSupportsTLS(void);
	void __fastcall SetSASLMechanisms(Idsaslcollection::TIdSASLEntries* AValue);
	virtual void __fastcall InitComponent(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	int __fastcall CheckMessages(void);
	virtual void __fastcall Connect(void)/* overload */;
	virtual void __fastcall Login(void);
	__fastcall virtual ~TIdPOP3(void);
	bool __fastcall Delete(const int MsgNum);
	virtual void __fastcall DisconnectNotifyPeer(void);
	void __fastcall KeepAlive(void);
	bool __fastcall List(System::Classes::TStrings* const ADest, const int AMsgNum = 0xffffffff);
	void __fastcall ParseLIST(System::UnicodeString ALine, int &VMsgNum, __int64 &VMsgSize);
	void __fastcall ParseUIDL(System::UnicodeString ALine, int &VMsgNum, System::UnicodeString &VUidl);
	bool __fastcall Reset(void);
	bool __fastcall Retrieve(const int MsgNum, Idmessage::TIdMessage* AMsg);
	bool __fastcall RetrieveHeader(const int MsgNum, Idmessage::TIdMessage* AMsg);
	__int64 __fastcall RetrieveMsgSize(const int MsgNum);
	__int64 __fastcall RetrieveMailBoxSize(void);
	bool __fastcall RetrieveRaw(const int aMsgNo, System::Classes::TStrings* const aDest)/* overload */;
	bool __fastcall RetrieveRaw(const int aMsgNo, System::Classes::TStream* const aDest)/* overload */;
	bool __fastcall RetrieveStats(int &VMsgCount, __int64 &VMailBoxSize);
	bool __fastcall UIDL(System::Classes::TStrings* const ADest, const int AMsgNum = 0xffffffff);
	bool __fastcall Top(const int AMsgNum, System::Classes::TStrings* const ADest, const int AMaxLines = 0x0);
	bool __fastcall CAPA(void);
	__property bool HasAPOP = {read=FHasAPOP, nodefault};
	__property bool HasCAPA = {read=FHasCAPA, nodefault};
	
__published:
	__property TIdPOP3AuthenticationType AuthType = {read=FAuthType, write=FAuthType, default=0};
	__property bool AutoLogin = {read=FAutoLogin, write=FAutoLogin, default=1};
	__property Host = {default=0};
	__property Username = {default=0};
	__property UseTLS = {default=0};
	__property Password = {default=0};
	__property Port = {default=110};
	__property Idsaslcollection::TIdSASLEntries* SASLMechanisms = {read=FSASLMechanisms, write=SetSASLMechanisms};
public:
	/* TIdMessageClient.Create */ inline __fastcall TIdPOP3(System::Classes::TComponent* AOwner)/* overload */ : Idmessageclient::TIdMessageClient(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdPOP3(void)/* overload */ : Idmessageclient::TIdMessageClient() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Connect(const System::UnicodeString AHost){ Idtcpclient::TIdTCPClientCustom::Connect(AHost); }
	inline void __fastcall  Connect(const System::UnicodeString AHost, const System::Word APort){ Idtcpclient::TIdTCPClientCustom::Connect(AHost, APort); }
	
};


class DELPHICLASS EIdPOP3Exception;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdPOP3Exception : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdPOP3Exception(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdPOP3Exception(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdPOP3Exception(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdPOP3Exception(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPOP3Exception(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPOP3Exception(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdPOP3Exception(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdPOP3Exception(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPOP3Exception(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPOP3Exception(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPOP3Exception(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPOP3Exception(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdPOP3Exception(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdDoesNotSupportAPOP;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdDoesNotSupportAPOP : public EIdPOP3Exception
{
	typedef EIdPOP3Exception inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdDoesNotSupportAPOP(const System::UnicodeString AMsg)/* overload */ : EIdPOP3Exception(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdDoesNotSupportAPOP(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdPOP3Exception(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdDoesNotSupportAPOP(NativeUInt Ident)/* overload */ : EIdPOP3Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdDoesNotSupportAPOP(System::PResStringRec ResStringRec)/* overload */ : EIdPOP3Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDoesNotSupportAPOP(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdPOP3Exception(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDoesNotSupportAPOP(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdPOP3Exception(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdDoesNotSupportAPOP(const System::UnicodeString Msg, int AHelpContext) : EIdPOP3Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdDoesNotSupportAPOP(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdPOP3Exception(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDoesNotSupportAPOP(NativeUInt Ident, int AHelpContext)/* overload */ : EIdPOP3Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDoesNotSupportAPOP(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdPOP3Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDoesNotSupportAPOP(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdPOP3Exception(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDoesNotSupportAPOP(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdPOP3Exception(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdDoesNotSupportAPOP(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdUnrecognizedReply;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdUnrecognizedReply : public EIdPOP3Exception
{
	typedef EIdPOP3Exception inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdUnrecognizedReply(const System::UnicodeString AMsg)/* overload */ : EIdPOP3Exception(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdUnrecognizedReply(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdPOP3Exception(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdUnrecognizedReply(NativeUInt Ident)/* overload */ : EIdPOP3Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdUnrecognizedReply(System::PResStringRec ResStringRec)/* overload */ : EIdPOP3Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUnrecognizedReply(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdPOP3Exception(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdUnrecognizedReply(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdPOP3Exception(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdUnrecognizedReply(const System::UnicodeString Msg, int AHelpContext) : EIdPOP3Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdUnrecognizedReply(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdPOP3Exception(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUnrecognizedReply(NativeUInt Ident, int AHelpContext)/* overload */ : EIdPOP3Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdUnrecognizedReply(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdPOP3Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUnrecognizedReply(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdPOP3Exception(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdUnrecognizedReply(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdPOP3Exception(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdUnrecognizedReply(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const bool DEF_POP3USE_IMPLICIT_TLS = false;
static const TIdPOP3AuthenticationType DEF_ATYPE = (TIdPOP3AuthenticationType)(0);
}	/* namespace Idpop3 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDPOP3)
using namespace Idpop3;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idpop3HPP
