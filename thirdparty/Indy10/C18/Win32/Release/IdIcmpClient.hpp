// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIcmpClient.pas' rev: 25.00 (Windows)

#ifndef IdicmpclientHPP
#define IdicmpclientHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdRawBase.hpp>	// Pascal unit
#include <IdRawClient.hpp>	// Pascal unit
#include <IdStackConsts.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idicmpclient
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TReplyStatusTypes : unsigned char { rsEcho, rsError, rsTimeOut, rsErrorUnreachable, rsErrorTTLExceeded, rsErrorPacketTooBig, rsErrorParameter, rsErrorDatagramConversion, rsErrorSecurityFailure, rsSourceQuench, rsRedirect, rsTimeStamp, rsInfoRequest, rsAddressMaskRequest, rsTraceRoute, rsMobileHostReg, rsMobileHostRedir, rsIPv6WhereAreYou, rsIPv6IAmHere, rsSKIP };

class DELPHICLASS TReplyStatus;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TReplyStatus : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	int FBytesReceived;
	System::UnicodeString FFromIpAddress;
	System::UnicodeString FToIpAddress;
	System::Byte FMsgType;
	System::Byte FMsgCode;
	System::Word FSequenceId;
	unsigned FMsRoundTripTime;
	System::Byte FTimeToLive;
	TReplyStatusTypes FReplyStatusType;
	int FPacketNumber;
	System::UnicodeString FHostName;
	System::UnicodeString FMsg;
	System::UnicodeString FRedirectTo;
	
public:
	__property System::UnicodeString RedirectTo = {read=FRedirectTo, write=FRedirectTo};
	__property System::UnicodeString Msg = {read=FMsg, write=FMsg};
	__property int BytesReceived = {read=FBytesReceived, write=FBytesReceived, nodefault};
	__property System::UnicodeString FromIpAddress = {read=FFromIpAddress, write=FFromIpAddress};
	__property System::UnicodeString ToIpAddress = {read=FToIpAddress, write=FToIpAddress};
	__property System::Byte MsgType = {read=FMsgType, write=FMsgType, nodefault};
	__property System::Byte MsgCode = {read=FMsgCode, write=FMsgCode, nodefault};
	__property System::Word SequenceId = {read=FSequenceId, write=FSequenceId, nodefault};
	__property unsigned MsRoundTripTime = {read=FMsRoundTripTime, write=FMsRoundTripTime, nodefault};
	__property System::Byte TimeToLive = {read=FTimeToLive, write=FTimeToLive, nodefault};
	__property TReplyStatusTypes ReplyStatusType = {read=FReplyStatusType, write=FReplyStatusType, nodefault};
	__property System::UnicodeString HostName = {read=FHostName, write=FHostName};
	__property int PacketNumber = {read=FPacketNumber, write=FPacketNumber, nodefault};
public:
	/* TObject.Create */ inline __fastcall TReplyStatus(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TReplyStatus(void) { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TOnReplyEvent)(System::Classes::TComponent* ASender, TReplyStatus* const AReplyStatus);

class DELPHICLASS TIdCustomIcmpClient;
class PASCALIMPLEMENTATION TIdCustomIcmpClient : public Idrawclient::TIdRawClient
{
	typedef Idrawclient::TIdRawClient inherited;
	
protected:
	unsigned __int64 FStartTime;
	int FPacketSize;
	Idglobal::TIdBytes FBufReceive;
	Idglobal::TIdBytes FBufIcmp;
	System::Word wSeqNo;
	int iDataSize;
	TReplyStatus* FReplyStatus;
	TOnReplyEvent FOnReply;
	System::UnicodeString FReplydata;
	bool __fastcall DecodeIPv6Packet(unsigned BytesRead);
	bool __fastcall DecodeIPv4Packet(unsigned BytesRead);
	bool __fastcall DecodeResponse(unsigned BytesRead);
	virtual void __fastcall DoReply(void);
	void __fastcall GetEchoReply(void);
	virtual void __fastcall InitComponent(void);
	void __fastcall PrepareEchoRequestIPv6(const System::UnicodeString ABuffer);
	void __fastcall PrepareEchoRequestIPv4(const System::UnicodeString ABuffer);
	void __fastcall PrepareEchoRequest(const System::UnicodeString ABuffer);
	void __fastcall SendEchoRequest(void)/* overload */;
	void __fastcall SendEchoRequest(const System::UnicodeString AIP)/* overload */;
	int __fastcall GetPacketSize(void);
	void __fastcall SetPacketSize(const int AValue);
	void __fastcall InternalPing(const System::UnicodeString AIP, const System::UnicodeString ABuffer = System::UnicodeString(), System::Word SequenceID = (System::Word)(0x0))/* overload */;
	__property int PacketSize = {read=GetPacketSize, write=SetPacketSize, default=32};
	__property System::UnicodeString ReplyData = {read=FReplydata};
	__property TReplyStatus* ReplyStatus = {read=FReplyStatus};
	__property TOnReplyEvent OnReply = {read=FOnReply, write=FOnReply};
	
public:
	__fastcall virtual ~TIdCustomIcmpClient(void);
	virtual void __fastcall Send(const System::UnicodeString AHost, const System::Word APort, const Idglobal::TIdBytes ABuffer)/* overload */;
	virtual void __fastcall Send(const Idglobal::TIdBytes ABuffer)/* overload */;
	TReplyStatus* __fastcall Receive(int ATimeOut);
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdCustomIcmpClient(System::Classes::TComponent* AOwner)/* overload */ : Idrawclient::TIdRawClient(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdCustomIcmpClient(void)/* overload */ : Idrawclient::TIdRawClient() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Send(const System::UnicodeString AData, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding()){ Idrawbase::TIdRawBase::Send(AData, AByteEncoding); }
	inline void __fastcall  Send(const System::UnicodeString AHost, const System::Word APort, const System::UnicodeString AData, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding()){ Idrawbase::TIdRawBase::Send(AHost, APort, AData, AByteEncoding); }
	
};


class DELPHICLASS TIdIcmpClient;
class PASCALIMPLEMENTATION TIdIcmpClient : public TIdCustomIcmpClient
{
	typedef TIdCustomIcmpClient inherited;
	
public:
	void __fastcall Ping(const System::UnicodeString ABuffer = System::UnicodeString(), System::Word SequenceID = (System::Word)(0x0));
	__property ReplyData = {default=0};
	__property ReplyStatus;
	
__published:
	__property Host = {default=0};
	__property IPVersion = {default=0};
	__property PacketSize = {default=32};
	__property ReceiveTimeout = {default=5000};
	__property OnReply;
public:
	/* TIdCustomIcmpClient.Destroy */ inline __fastcall virtual ~TIdIcmpClient(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdIcmpClient(System::Classes::TComponent* AOwner)/* overload */ : TIdCustomIcmpClient(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdIcmpClient(void)/* overload */ : TIdCustomIcmpClient() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 DEF_PACKET_SIZE = System::Int8(0x20);
static const System::Word MAX_PACKET_SIZE = System::Word(0x400);
static const System::Word Id_TIDICMP_ReceiveTimeout = System::Word(0x1388);
}	/* namespace Idicmpclient */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDICMPCLIENT)
using namespace Idicmpclient;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdicmpclientHPP
