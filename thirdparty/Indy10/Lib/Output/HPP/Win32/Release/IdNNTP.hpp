// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdNNTP.pas' rev: 25.00 (Windows)

#ifndef IdnntpHPP
#define IdnntpHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdExplicitTLSClientServerBase.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit
#include <IdMessageClient.hpp>	// Pascal unit
#include <IdReplyRFC.hpp>	// Pascal unit
#include <IdTCPServer.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idnntp
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdModeType : unsigned char { mtStream, mtIHAVE, mtReader };

enum DECLSPEC_DENUM TIdNNTPPermission : unsigned char { crCanPost, crNoPost, crAuthRequired, crTempUnavailable };

enum DECLSPEC_DENUM TIdModeSetResult : unsigned char { mrCanStream, mrNoStream, mrCanIHAVE, mrNoIHAVE, mrCanPost, mrNoPost };

typedef void __fastcall (__closure *TIdEventStreaming)(System::UnicodeString AMesgID, bool &AAccepted);

typedef void __fastcall (__closure *TIdNewsTransporTIdEvent)(System::Classes::TStrings* AMsg);

typedef void __fastcall (__closure *TIdEvenTIdNewsgroupList)(System::UnicodeString ANewsgroup, __int64 ALow, __int64 AHigh, System::UnicodeString AType, bool &ACanContinue);

typedef void __fastcall (__closure *TIdEventXOVER)(__int64 AArticleIndex, System::UnicodeString ASubject, System::UnicodeString AFrom, System::TDateTime ADate, System::UnicodeString AMsgId, System::UnicodeString AReferences, int AByteCount, int ALineCount, System::UnicodeString AExtraData, bool &VCanContinue);

typedef void __fastcall (__closure *TIdEventNewNewsList)(System::UnicodeString AMsgID, bool &ACanContinue);

typedef void __fastcall (__closure *TIdEventXHDREntry)(System::UnicodeString AHeader, System::UnicodeString AMsg, System::UnicodeString AHeaderData, bool &ACanContinue);

class DELPHICLASS TIdNNTP;
class PASCALIMPLEMENTATION TIdNNTP : public Idmessageclient::TIdMessageClient
{
	typedef Idmessageclient::TIdMessageClient inherited;
	
protected:
	int FGreetingCode;
	__int64 FMsgHigh;
	__int64 FMsgLow;
	__int64 FMsgCount;
	System::UnicodeString FNewsAgent;
	TIdEvenTIdNewsgroupList FOnNewsgroupList;
	TIdEvenTIdNewsgroupList FOnNewGroupsList;
	TIdEventNewNewsList FOnNewNewsList;
	TIdEventXHDREntry FOnXHDREntry;
	TIdEventXOVER FOnXOVER;
	TIdModeType FModeType;
	TIdModeSetResult FModeResult;
	TIdNNTPPermission FPermission;
	bool FForceAuth;
	bool FHDRSupported;
	bool FOVERSupported;
	void __fastcall AfterConnect(void);
	void __fastcall GetCapability(void);
	System::UnicodeString __fastcall ConvertDateTimeDist(System::TDateTime ADate, bool AGMT, System::UnicodeString ADistributions);
	virtual bool __fastcall GetSupportsTLS(void);
	virtual void __fastcall InitComponent(void);
	void __fastcall ProcessGroupList(System::UnicodeString ACmd, int AResponse, TIdEvenTIdNewsgroupList ALisTIdEvent);
	void __fastcall XHDRCommon(System::UnicodeString AHeader, System::UnicodeString AParam);
	void __fastcall XOVERCommon(System::UnicodeString AParam);
	void __fastcall StartTLS(void);
	
public:
	void __fastcall Check(System::Classes::TStrings* AMsgIDs, System::Classes::TStrings* AResponses);
	virtual void __fastcall Connect(void)/* overload */;
	__fastcall virtual ~TIdNNTP(void);
	virtual void __fastcall DisconnectNotifyPeer(void);
	bool __fastcall GetArticle(Idmessage::TIdMessage* AMsg)/* overload */;
	bool __fastcall GetArticle(__int64 AMsgNo, Idmessage::TIdMessage* AMsg)/* overload */;
	bool __fastcall GetArticle(System::UnicodeString AMsgID, Idmessage::TIdMessage* AMsg)/* overload */;
	bool __fastcall GetArticle(System::Classes::TStrings* AMsg)/* overload */;
	bool __fastcall GetArticle(__int64 AMsgNo, System::Classes::TStrings* AMsg)/* overload */;
	bool __fastcall GetArticle(System::UnicodeString AMsgID, System::Classes::TStrings* AMsg)/* overload */;
	bool __fastcall GetArticle(System::Classes::TStream* AMsg)/* overload */;
	bool __fastcall GetArticle(__int64 AMsgNo, System::Classes::TStream* AMsg)/* overload */;
	bool __fastcall GetArticle(System::UnicodeString AMsgID, System::Classes::TStream* AMsg)/* overload */;
	bool __fastcall GetBody(Idmessage::TIdMessage* AMsg)/* overload */;
	bool __fastcall GetBody(__int64 AMsgNo, Idmessage::TIdMessage* AMsg)/* overload */;
	bool __fastcall GetBody(System::UnicodeString AMsgID, Idmessage::TIdMessage* AMsg)/* overload */;
	bool __fastcall GetBody(System::Classes::TStrings* AMsg)/* overload */;
	bool __fastcall GetBody(__int64 AMsgNo, System::Classes::TStrings* AMsg)/* overload */;
	bool __fastcall GetBody(System::UnicodeString AMsgID, System::Classes::TStrings* AMsg)/* overload */;
	bool __fastcall GetBody(System::Classes::TStream* AMsg)/* overload */;
	bool __fastcall GetBody(__int64 AMsgNo, System::Classes::TStream* AMsg)/* overload */;
	bool __fastcall GetBody(System::UnicodeString AMsgID, System::Classes::TStream* AMsg)/* overload */;
	bool __fastcall GetHeader(Idmessage::TIdMessage* AMsg)/* overload */;
	bool __fastcall GetHeader(__int64 AMsgNo, Idmessage::TIdMessage* AMsg)/* overload */;
	bool __fastcall GetHeader(System::UnicodeString AMsgID, Idmessage::TIdMessage* AMsg)/* overload */;
	bool __fastcall GetHeader(System::Classes::TStrings* AMsg)/* overload */;
	bool __fastcall GetHeader(__int64 AMsgNo, System::Classes::TStrings* AMsg)/* overload */;
	bool __fastcall GetHeader(System::UnicodeString AMsgID, System::Classes::TStrings* AMsg)/* overload */;
	bool __fastcall GetHeader(System::Classes::TStream* AMsg)/* overload */;
	bool __fastcall GetHeader(__int64 AMsgNo, System::Classes::TStream* AMsg)/* overload */;
	bool __fastcall GetHeader(System::UnicodeString AMsgID, System::Classes::TStream* AMsg)/* overload */;
	void __fastcall GetNewsgroupList(void)/* overload */;
	void __fastcall GetNewsgroupList(System::Classes::TStrings* AList)/* overload */;
	void __fastcall GetNewsgroupList(System::Classes::TStream* AStream)/* overload */;
	void __fastcall GetNewGroupsList(System::TDateTime ADate, bool AGMT, System::UnicodeString ADistributions)/* overload */;
	void __fastcall GetNewGroupsList(System::TDateTime ADate, bool AGMT, System::UnicodeString ADistributions, System::Classes::TStrings* AList)/* overload */;
	void __fastcall GetNewNewsList(System::UnicodeString ANewsgroups, System::TDateTime ADate, bool AGMT, System::UnicodeString ADistributions)/* overload */;
	void __fastcall GetNewNewsList(System::UnicodeString ANewsgroups, System::TDateTime ADate, bool AGMT, System::UnicodeString ADistributions, System::Classes::TStrings* AList)/* overload */;
	void __fastcall GetOverviewFMT(System::Classes::TStrings* AResponse);
	bool __fastcall IsExtCmdSupported(System::UnicodeString AExtension);
	void __fastcall IHAVE(System::Classes::TStrings* AMsg);
	bool __fastcall Next(void);
	bool __fastcall Previous(void);
	void __fastcall ParseXOVER(System::UnicodeString Aline, __int64 &AArticleIndex, System::UnicodeString &ASubject, System::UnicodeString &AFrom, System::TDateTime &ADate, System::UnicodeString &AMsgId, System::UnicodeString &AReferences, int &AByteCount, int &ALineCount, System::UnicodeString &AExtraData);
	void __fastcall ParseNewsGroup(System::UnicodeString ALine, /* out */ System::UnicodeString &ANewsGroup, /* out */ __int64 &AHi, /* out */ __int64 &ALo, /* out */ System::UnicodeString &AStatus);
	void __fastcall ParseXHDRLine(System::UnicodeString ALine, /* out */ System::UnicodeString &AMsg, /* out */ System::UnicodeString &AHeaderData);
	void __fastcall Post(Idmessage::TIdMessage* AMsg)/* overload */;
	void __fastcall Post(System::Classes::TStream* AStream)/* overload */;
	virtual short __fastcall SendCmd(System::UnicodeString AOut, short const *AResponse, const int AResponse_Size, Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	bool __fastcall SelectArticle(__int64 AMsgNo);
	void __fastcall SelectGroup(System::UnicodeString AGroup);
	System::UnicodeString __fastcall TakeThis(System::UnicodeString AMsgID, System::Classes::TStream* AMsg);
	void __fastcall XHDR(System::UnicodeString AHeader, System::UnicodeString AParam, System::Classes::TStrings* AResponse)/* overload */;
	void __fastcall XHDR(System::UnicodeString AHeader, System::UnicodeString AParam)/* overload */;
	void __fastcall XOVER(System::UnicodeString AParam, System::Classes::TStrings* AResponse)/* overload */;
	void __fastcall XOVER(System::UnicodeString AParam, System::Classes::TStream* AResponse)/* overload */;
	void __fastcall XOVER(System::UnicodeString AParam)/* overload */;
	void __fastcall SendAuth(void);
	__property TIdModeSetResult ModeResult = {read=FModeResult, write=FModeResult, nodefault};
	__property __int64 MsgCount = {read=FMsgCount};
	__property __int64 MsgHigh = {read=FMsgHigh};
	__property __int64 MsgLow = {read=FMsgLow};
	__property TIdNNTPPermission Permission = {read=FPermission, nodefault};
	
__published:
	__property System::UnicodeString NewsAgent = {read=FNewsAgent, write=FNewsAgent};
	__property TIdModeType Mode = {read=FModeType, write=FModeType, default=2};
	__property Password = {default=0};
	__property Username = {default=0};
	__property TIdEvenTIdNewsgroupList OnNewsgroupList = {read=FOnNewsgroupList, write=FOnNewsgroupList};
	__property TIdEvenTIdNewsgroupList OnNewGroupsList = {read=FOnNewGroupsList, write=FOnNewGroupsList};
	__property TIdEventNewNewsList OnNewNewsList = {read=FOnNewNewsList, write=FOnNewNewsList};
	__property TIdEventXHDREntry OnXHDREntry = {read=FOnXHDREntry, write=FOnXHDREntry};
	__property TIdEventXOVER OnXOVER = {read=FOnXOVER, write=FOnXOVER};
	__property OnTLSNotAvailable;
	__property Port = {default=119};
	__property Host = {default=0};
	__property UseTLS = {default=0};
	__property bool ForceAuth = {read=FForceAuth, write=FForceAuth, default=0};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdNNTP(System::Classes::TComponent* AOwner)/* overload */ : Idmessageclient::TIdMessageClient(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdNNTP(void)/* overload */ : Idmessageclient::TIdMessageClient() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Connect(const System::UnicodeString AHost){ Idtcpclient::TIdTCPClientCustom::Connect(AHost); }
	inline void __fastcall  Connect(const System::UnicodeString AHost, const System::Word APort){ Idtcpclient::TIdTCPClientCustom::Connect(AHost, APort); }
	inline short __fastcall  SendCmd(System::UnicodeString AOut, const short AResponse = (short)(0xffffffff), Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding()){ return Idtcpconnection::TIdTCPConnection::SendCmd(AOut, AResponse, AEncoding); }
	inline System::UnicodeString __fastcall  SendCmd(System::UnicodeString AOut, const System::UnicodeString AResponse, Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding()){ return Idtcpconnection::TIdTCPConnection::SendCmd(AOut, AResponse, AEncoding); }
	
};


class DELPHICLASS EIdNNTPException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNNTPException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNNTPException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNNTPException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNNTPException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNNTPException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNNTPException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdNNTPNoOnNewGroupsList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNNTPNoOnNewGroupsList : public EIdNNTPException
{
	typedef EIdNNTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNNTPNoOnNewGroupsList(const System::UnicodeString AMsg)/* overload */ : EIdNNTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNNTPNoOnNewGroupsList(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdNNTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPNoOnNewGroupsList(NativeUInt Ident)/* overload */ : EIdNNTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPNoOnNewGroupsList(System::PResStringRec ResStringRec)/* overload */ : EIdNNTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPNoOnNewGroupsList(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdNNTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPNoOnNewGroupsList(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdNNTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNNTPNoOnNewGroupsList(const System::UnicodeString Msg, int AHelpContext) : EIdNNTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNNTPNoOnNewGroupsList(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdNNTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPNoOnNewGroupsList(NativeUInt Ident, int AHelpContext)/* overload */ : EIdNNTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPNoOnNewGroupsList(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdNNTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPNoOnNewGroupsList(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdNNTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPNoOnNewGroupsList(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdNNTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNNTPNoOnNewGroupsList(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdNNTPNoOnNewNewsList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNNTPNoOnNewNewsList : public EIdNNTPException
{
	typedef EIdNNTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNNTPNoOnNewNewsList(const System::UnicodeString AMsg)/* overload */ : EIdNNTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNNTPNoOnNewNewsList(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdNNTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPNoOnNewNewsList(NativeUInt Ident)/* overload */ : EIdNNTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPNoOnNewNewsList(System::PResStringRec ResStringRec)/* overload */ : EIdNNTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPNoOnNewNewsList(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdNNTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPNoOnNewNewsList(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdNNTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNNTPNoOnNewNewsList(const System::UnicodeString Msg, int AHelpContext) : EIdNNTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNNTPNoOnNewNewsList(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdNNTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPNoOnNewNewsList(NativeUInt Ident, int AHelpContext)/* overload */ : EIdNNTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPNoOnNewNewsList(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdNNTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPNoOnNewNewsList(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdNNTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPNoOnNewNewsList(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdNNTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNNTPNoOnNewNewsList(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdNNTPNoOnNewsgroupList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNNTPNoOnNewsgroupList : public EIdNNTPException
{
	typedef EIdNNTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNNTPNoOnNewsgroupList(const System::UnicodeString AMsg)/* overload */ : EIdNNTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNNTPNoOnNewsgroupList(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdNNTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPNoOnNewsgroupList(NativeUInt Ident)/* overload */ : EIdNNTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPNoOnNewsgroupList(System::PResStringRec ResStringRec)/* overload */ : EIdNNTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPNoOnNewsgroupList(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdNNTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPNoOnNewsgroupList(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdNNTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNNTPNoOnNewsgroupList(const System::UnicodeString Msg, int AHelpContext) : EIdNNTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNNTPNoOnNewsgroupList(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdNNTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPNoOnNewsgroupList(NativeUInt Ident, int AHelpContext)/* overload */ : EIdNNTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPNoOnNewsgroupList(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdNNTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPNoOnNewsgroupList(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdNNTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPNoOnNewsgroupList(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdNNTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNNTPNoOnNewsgroupList(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdNNTPNoOnXHDREntry;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNNTPNoOnXHDREntry : public EIdNNTPException
{
	typedef EIdNNTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNNTPNoOnXHDREntry(const System::UnicodeString AMsg)/* overload */ : EIdNNTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNNTPNoOnXHDREntry(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdNNTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPNoOnXHDREntry(NativeUInt Ident)/* overload */ : EIdNNTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPNoOnXHDREntry(System::PResStringRec ResStringRec)/* overload */ : EIdNNTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPNoOnXHDREntry(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdNNTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPNoOnXHDREntry(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdNNTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNNTPNoOnXHDREntry(const System::UnicodeString Msg, int AHelpContext) : EIdNNTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNNTPNoOnXHDREntry(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdNNTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPNoOnXHDREntry(NativeUInt Ident, int AHelpContext)/* overload */ : EIdNNTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPNoOnXHDREntry(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdNNTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPNoOnXHDREntry(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdNNTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPNoOnXHDREntry(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdNNTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNNTPNoOnXHDREntry(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdNNTPNoOnXOVER;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNNTPNoOnXOVER : public EIdNNTPException
{
	typedef EIdNNTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNNTPNoOnXOVER(const System::UnicodeString AMsg)/* overload */ : EIdNNTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNNTPNoOnXOVER(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdNNTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPNoOnXOVER(NativeUInt Ident)/* overload */ : EIdNNTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPNoOnXOVER(System::PResStringRec ResStringRec)/* overload */ : EIdNNTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPNoOnXOVER(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdNNTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPNoOnXOVER(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdNNTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNNTPNoOnXOVER(const System::UnicodeString Msg, int AHelpContext) : EIdNNTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNNTPNoOnXOVER(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdNNTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPNoOnXOVER(NativeUInt Ident, int AHelpContext)/* overload */ : EIdNNTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPNoOnXOVER(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdNNTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPNoOnXOVER(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdNNTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPNoOnXOVER(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdNNTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNNTPNoOnXOVER(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdNNTPStringListNotInitialized;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNNTPStringListNotInitialized : public EIdNNTPException
{
	typedef EIdNNTPException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNNTPStringListNotInitialized(const System::UnicodeString AMsg)/* overload */ : EIdNNTPException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNNTPStringListNotInitialized(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdNNTPException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPStringListNotInitialized(NativeUInt Ident)/* overload */ : EIdNNTPException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPStringListNotInitialized(System::PResStringRec ResStringRec)/* overload */ : EIdNNTPException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPStringListNotInitialized(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdNNTPException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPStringListNotInitialized(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdNNTPException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNNTPStringListNotInitialized(const System::UnicodeString Msg, int AHelpContext) : EIdNNTPException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNNTPStringListNotInitialized(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdNNTPException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPStringListNotInitialized(NativeUInt Ident, int AHelpContext)/* overload */ : EIdNNTPException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPStringListNotInitialized(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdNNTPException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPStringListNotInitialized(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdNNTPException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPStringListNotInitialized(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdNNTPException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNNTPStringListNotInitialized(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdNNTPConnectionRefused;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNNTPConnectionRefused : public Idreplyrfc::EIdReplyRFCError
{
	typedef Idreplyrfc::EIdReplyRFCError inherited;
	
public:
	/* EIdReplyRFCError.CreateError */ inline __fastcall virtual EIdNNTPConnectionRefused(const int AErrorCode, const System::UnicodeString AReplyMessage) : Idreplyrfc::EIdReplyRFCError(AErrorCode, AReplyMessage) { }
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNNTPConnectionRefused(const System::UnicodeString AMsg)/* overload */ : Idreplyrfc::EIdReplyRFCError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNNTPConnectionRefused(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idreplyrfc::EIdReplyRFCError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPConnectionRefused(NativeUInt Ident)/* overload */ : Idreplyrfc::EIdReplyRFCError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNNTPConnectionRefused(System::PResStringRec ResStringRec)/* overload */ : Idreplyrfc::EIdReplyRFCError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPConnectionRefused(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idreplyrfc::EIdReplyRFCError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNNTPConnectionRefused(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idreplyrfc::EIdReplyRFCError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNNTPConnectionRefused(const System::UnicodeString Msg, int AHelpContext) : Idreplyrfc::EIdReplyRFCError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNNTPConnectionRefused(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idreplyrfc::EIdReplyRFCError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPConnectionRefused(NativeUInt Ident, int AHelpContext)/* overload */ : Idreplyrfc::EIdReplyRFCError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNNTPConnectionRefused(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idreplyrfc::EIdReplyRFCError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPConnectionRefused(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idreplyrfc::EIdReplyRFCError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNNTPConnectionRefused(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idreplyrfc::EIdReplyRFCError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNNTPConnectionRefused(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idnntp */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDNNTP)
using namespace Idnntp;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdnntpHPP
