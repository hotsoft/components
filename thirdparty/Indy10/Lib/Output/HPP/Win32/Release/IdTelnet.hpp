// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdTelnet.pas' rev: 25.00 (Windows)

#ifndef IdtelnetHPP
#define IdtelnetHPP

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
#include <IdStack.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idtelnet
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdTelnetCommand : unsigned char { tncNoLocalEcho, tncLocalEcho, tncEcho };

class DELPHICLASS TIdTelnet;
typedef void __fastcall (__closure *TIdTelnetDataAvailEvent)(TIdTelnet* Sender, const Idglobal::TIdBytes Buffer);

typedef void __fastcall (__closure *TIdTelnetCommandEvent)(TIdTelnet* Sender, TIdTelnetCommand Status);

class DELPHICLASS TIdTelnetReadThread;
class PASCALIMPLEMENTATION TIdTelnetReadThread : public Idthread::TIdThread
{
	typedef Idthread::TIdThread inherited;
	
protected:
	TIdTelnet* FClient;
	virtual void __fastcall Run(void);
	
public:
	__fastcall TIdTelnetReadThread(TIdTelnet* AClient);
	__property TIdTelnet* Client = {read=FClient};
public:
	/* TIdThread.Destroy */ inline __fastcall virtual ~TIdTelnetReadThread(void) { }
	
};


class PASCALIMPLEMENTATION TIdTelnet : public Idtcpclient::TIdTCPClientCustom
{
	typedef Idtcpclient::TIdTCPClientCustom inherited;
	
protected:
	System::UnicodeString fTerminal;
	bool fThreadedEvent;
	TIdTelnetDataAvailEvent FOnDataAvailable;
	bool fIamTelnet;
	TIdTelnetCommandEvent FOnTelnetCommand;
	TIdTelnetReadThread* FTelnetThread;
	void __fastcall DoOnDataAvailable(const Idglobal::TIdBytes Buf);
	__property bool IamTelnet = {read=fIamTelnet, write=fIamTelnet, nodefault};
	void __fastcall Negotiate(void);
	void __fastcall Handle_SB(const System::Byte SbType, const Idglobal::TIdBytes SbData);
	void __fastcall SendNegotiationResp(const System::Byte Response, const System::Byte ResponseData);
	void __fastcall SendSubNegotiationResp(const System::Byte SbType, const Idglobal::TIdBytes ResponseData);
	void __fastcall DoTelnetCommand(TIdTelnetCommand Status);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall virtual ~TIdTelnet(void);
	virtual void __fastcall Connect(void)/* overload */;
	virtual void __fastcall Disconnect(bool ANotifyPeer)/* overload */;
	void __fastcall SendCh(System::WideChar Ch);
	void __fastcall SendString(const System::UnicodeString S);
	__property TIdTelnetReadThread* TelnetThread = {read=FTelnetThread};
	
__published:
	__property Host = {default=0};
	__property Port = {default=23};
	__property TIdTelnetCommandEvent OnTelnetCommand = {read=FOnTelnetCommand, write=FOnTelnetCommand};
	__property TIdTelnetDataAvailEvent OnDataAvailable = {read=FOnDataAvailable, write=FOnDataAvailable};
	__property System::UnicodeString Terminal = {read=fTerminal, write=fTerminal};
	__property bool ThreadedEvent = {read=fThreadedEvent, write=fThreadedEvent, default=0};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdTelnet(System::Classes::TComponent* AOwner)/* overload */ : Idtcpclient::TIdTCPClientCustom(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdTelnet(void)/* overload */ : Idtcpclient::TIdTCPClientCustom() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Connect(const System::UnicodeString AHost){ Idtcpclient::TIdTCPClientCustom::Connect(AHost); }
	inline void __fastcall  Connect(const System::UnicodeString AHost, const System::Word APort){ Idtcpclient::TIdTCPClientCustom::Connect(AHost, APort); }
	inline void __fastcall  Disconnect(void){ Idtcpconnection::TIdTCPConnection::Disconnect(); }
	
};


class DELPHICLASS EIdTelnetError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTelnetError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTelnetError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTelnetError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTelnetError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTelnetError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTelnetError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTelnetError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTelnetError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTelnetError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTelnetError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTelnetError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTelnetError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTelnetError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTelnetError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTelnetClientConnectError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTelnetClientConnectError : public EIdTelnetError
{
	typedef EIdTelnetError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTelnetClientConnectError(const System::UnicodeString AMsg)/* overload */ : EIdTelnetError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTelnetClientConnectError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTelnetError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTelnetClientConnectError(NativeUInt Ident)/* overload */ : EIdTelnetError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTelnetClientConnectError(System::PResStringRec ResStringRec)/* overload */ : EIdTelnetError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTelnetClientConnectError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTelnetError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTelnetClientConnectError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTelnetError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTelnetClientConnectError(const System::UnicodeString Msg, int AHelpContext) : EIdTelnetError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTelnetClientConnectError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTelnetError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTelnetClientConnectError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTelnetError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTelnetClientConnectError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTelnetError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTelnetClientConnectError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTelnetError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTelnetClientConnectError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTelnetError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTelnetClientConnectError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTelnetServerOnDataAvailableIsNil;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTelnetServerOnDataAvailableIsNil : public EIdTelnetError
{
	typedef EIdTelnetError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTelnetServerOnDataAvailableIsNil(const System::UnicodeString AMsg)/* overload */ : EIdTelnetError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTelnetServerOnDataAvailableIsNil(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdTelnetError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTelnetServerOnDataAvailableIsNil(NativeUInt Ident)/* overload */ : EIdTelnetError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTelnetServerOnDataAvailableIsNil(System::PResStringRec ResStringRec)/* overload */ : EIdTelnetError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTelnetServerOnDataAvailableIsNil(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTelnetError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTelnetServerOnDataAvailableIsNil(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdTelnetError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTelnetServerOnDataAvailableIsNil(const System::UnicodeString Msg, int AHelpContext) : EIdTelnetError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTelnetServerOnDataAvailableIsNil(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdTelnetError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTelnetServerOnDataAvailableIsNil(NativeUInt Ident, int AHelpContext)/* overload */ : EIdTelnetError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTelnetServerOnDataAvailableIsNil(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdTelnetError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTelnetServerOnDataAvailableIsNil(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTelnetError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTelnetServerOnDataAvailableIsNil(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdTelnetError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTelnetServerOnDataAvailableIsNil(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Byte TNC_EOR = System::Byte(0xef);
static const System::Byte TNC_SE = System::Byte(0xf0);
static const System::Byte TNC_NOP = System::Byte(0xf1);
static const System::Byte TNC_DATA_MARK = System::Byte(0xf2);
static const System::Byte TNC_BREAK = System::Byte(0xf3);
static const System::Byte TNC_IP = System::Byte(0xf4);
static const System::Byte TNC_AO = System::Byte(0xf5);
static const System::Byte TNC_AYT = System::Byte(0xf6);
static const System::Byte TNC_EC = System::Byte(0xf7);
static const System::Byte TNC_EL = System::Byte(0xf8);
static const System::Byte TNC_GA = System::Byte(0xf9);
static const System::Byte TNC_SB = System::Byte(0xfa);
static const System::Byte TNC_WILL = System::Byte(0xfb);
static const System::Byte TNC_WONT = System::Byte(0xfc);
static const System::Byte TNC_DO = System::Byte(0xfd);
static const System::Byte TNC_DONT = System::Byte(0xfe);
static const System::Byte TNC_IAC = System::Byte(0xff);
static const System::Int8 TNO_BINARY = System::Int8(0x0);
static const System::Int8 TNO_ECHO = System::Int8(0x1);
static const System::Int8 TNO_RECONNECT = System::Int8(0x2);
static const System::Int8 TNO_SGA = System::Int8(0x3);
static const System::Int8 TNO_AMSN = System::Int8(0x4);
static const System::Int8 TNO_STATUS = System::Int8(0x5);
static const System::Int8 TNO_TIMING_MARK = System::Int8(0x6);
static const System::Int8 TNO_RCTE = System::Int8(0x7);
static const System::Int8 TNO_OLW = System::Int8(0x8);
static const System::Int8 TNO_OPS = System::Int8(0x9);
static const System::Int8 TNO_OCRD = System::Int8(0xa);
static const System::Int8 TNO_OHTS = System::Int8(0xb);
static const System::Int8 TNO_OHTD = System::Int8(0xc);
static const System::Int8 TNO_OFD = System::Int8(0xd);
static const System::Int8 TNO_OVT = System::Int8(0xe);
static const System::Int8 TNO_OVTD = System::Int8(0xf);
static const System::Int8 TNO_OLD = System::Int8(0x10);
static const System::Int8 TNO_EA = System::Int8(0x11);
static const System::Int8 TNO_LOGOUT = System::Int8(0x12);
static const System::Int8 TNO_BYTE_MACRO = System::Int8(0x13);
static const System::Int8 TNO_DET = System::Int8(0x14);
static const System::Int8 TNO_SUPDUP = System::Int8(0x15);
static const System::Int8 TNO_SUPDUP_OUTPUT = System::Int8(0x16);
static const System::Int8 TNO_SL = System::Int8(0x17);
static const System::Int8 TNO_TERMTYPE = System::Int8(0x18);
static const System::Int8 TNO_EOR = System::Int8(0x19);
static const System::Int8 TNO_TACACS_ID = System::Int8(0x1a);
static const System::Int8 TNO_OM = System::Int8(0x1b);
static const System::Int8 TNO_TLN = System::Int8(0x1c);
static const System::Int8 TNO_3270REGIME = System::Int8(0x1d);
static const System::Int8 TNO_X3PAD = System::Int8(0x1e);
static const System::Int8 TNO_NAWS = System::Int8(0x1f);
static const System::Int8 TNO_TERM_SPEED = System::Int8(0x20);
static const System::Int8 TNO_RFLOW = System::Int8(0x21);
static const System::Int8 TNO_LINEMODE = System::Int8(0x22);
static const System::Int8 TNO_XDISPLOC = System::Int8(0x23);
static const System::Int8 TNO_ENV = System::Int8(0x24);
static const System::Int8 TNO_AUTH = System::Int8(0x25);
static const System::Int8 TNO_ENCRYPT = System::Int8(0x26);
static const System::Int8 TNO_NEWENV = System::Int8(0x27);
static const System::Int8 TNO_TN3270E = System::Int8(0x28);
static const System::Int8 TNO_XAUTH = System::Int8(0x29);
static const System::Int8 TNO_CHARSET = System::Int8(0x2a);
static const System::Int8 TNO_RSP = System::Int8(0x2b);
static const System::Int8 TNO_COMPORT = System::Int8(0x2c);
static const System::Int8 TNO_SUPLOCALECHO = System::Int8(0x2d);
static const System::Int8 TNO_STARTTLS = System::Int8(0x2e);
static const System::Int8 TNO_KERMIT = System::Int8(0x2f);
static const System::Int8 TNO_SEND_URL = System::Int8(0x30);
static const System::Int8 TNO_FORWARD_X = System::Int8(0x31);
static const System::Byte TNO_PRAGMA_LOGON = System::Byte(0x8a);
static const System::Byte TNO_SSPI_LOGON = System::Byte(0x8b);
static const System::Byte TNO_PRAGMA_HEARTBEAT = System::Byte(0x8c);
static const System::Byte TNO_EOL = System::Byte(0xff);
static const System::Int8 TNOS_TERM_IS = System::Int8(0x0);
static const System::Int8 TNOS_TERMTYPE_SEND = System::Int8(0x1);
static const System::Int8 TNOS_REPLY = System::Int8(0x2);
static const System::Int8 TNOS_NAME = System::Int8(0x3);
static const System::Int8 TNOAUTH_IS = System::Int8(0x0);
static const System::Int8 TNOAUTH_SEND = System::Int8(0x1);
static const System::Int8 TNOAUTH_REPLY = System::Int8(0x2);
static const System::Int8 TNOAUTH_NAME = System::Int8(0x3);
static const System::Int8 TNOAUTH_NULL = System::Int8(0x0);
static const System::Int8 TNOAUTH_KERBEROS_V4 = System::Int8(0x1);
static const System::Int8 TNOAUTH_KERBEROS_V5 = System::Int8(0x2);
static const System::Int8 TNOAUTH_SPX = System::Int8(0x3);
static const System::Int8 TNOAUTH_MINK = System::Int8(0x4);
static const System::Int8 TNOAUTH_SRP = System::Int8(0x5);
static const System::Int8 TNOAUTH_RSA = System::Int8(0x6);
static const System::Int8 TNOAUTH_SSL = System::Int8(0x7);
static const System::Int8 TNOAUTH_LOKI = System::Int8(0xa);
static const System::Int8 TNOAUTH_SSA = System::Int8(0xb);
static const System::Int8 TNOAUTH_KEA_SJ = System::Int8(0xc);
static const System::Int8 TNOAUTH_KEA_SJ_INTEG = System::Int8(0xd);
static const System::Int8 TNOAUTH_DSS = System::Int8(0xe);
static const System::Int8 TNOAUTH_NTLM = System::Int8(0xf);
static const System::Int8 TNOAUTH_KRB4_AUTH = System::Int8(0x0);
static const System::Int8 TNOAUTH_KRB4_REJECT = System::Int8(0x1);
static const System::Int8 TNOAUTH_KRB4_ACCEPT = System::Int8(0x2);
static const System::Int8 TNOAUTH_KRB4_CHALLENGE = System::Int8(0x3);
static const System::Int8 TNOAUTH_KRB4_RESPONSE = System::Int8(0x4);
static const System::Int8 TNOAUTH_KRB4_FORWARD = System::Int8(0x5);
static const System::Int8 TNOAUTH_KRB4_FORWARD_ACCEPT = System::Int8(0x6);
static const System::Int8 TNOAUTH_KRB4_FORWARD_REJECT = System::Int8(0x7);
static const System::Int8 TNOAUTH_KRB4_EXP = System::Int8(0x8);
static const System::Int8 TNOAUTH_KRB4_PARAMS = System::Int8(0x9);
static const System::Int8 TNOAUTH_KRB5_AUTH = System::Int8(0x0);
static const System::Int8 TNOAUTH_KRB5_REJECT = System::Int8(0x1);
static const System::Int8 TNOAUTH_KRB5_ACCEPT = System::Int8(0x2);
static const System::Int8 TNOAUTH_KRB5_RESPONSE = System::Int8(0x3);
static const System::Int8 TNOAUTH_KRB5_FORWARD = System::Int8(0x4);
static const System::Int8 TNOAUTH_KRB5_FORWARD_ACCEPT = System::Int8(0x5);
static const System::Int8 TNOAUTH_KRB5_FORWARD_REJECT = System::Int8(0x6);
static const System::Int8 TNOAUTH_DSS_INITIALIZE = System::Int8(0x1);
static const System::Int8 TNOAUTH_DSS_TOKENBA = System::Int8(0x2);
static const System::Int8 TNOAUTH_DSS_CERTA_TOKENAB = System::Int8(0x3);
static const System::Int8 TNOAUTH_DSS_CERTB_TOKENBA2 = System::Int8(0x4);
static const System::Int8 TNOAUTH_SRP_AUTH = System::Int8(0x0);
static const System::Int8 TNOAUTH_SRP_REJECT = System::Int8(0x1);
static const System::Int8 TNOAUTH_SRP_ACCEPT = System::Int8(0x2);
static const System::Int8 TNOAUTH_SRP_CHALLENGE = System::Int8(0x3);
static const System::Int8 TNOAUTH_SRP_RESPONSE = System::Int8(0x4);
static const System::Int8 TNOAUTH_SRP_EXP = System::Int8(0x8);
static const System::Int8 TNOAUTH_SRP_PARAMS = System::Int8(0x9);
static const System::Int8 TNOAUTH_KEA_CERTA_RA = System::Int8(0x1);
static const System::Int8 TNOAUTH_KEA_CERTB_RB_IVB_NONCEB = System::Int8(0x2);
static const System::Int8 TNOAUTH_KEA_IVA_RESPONSEB_NONCEA = System::Int8(0x3);
static const System::Int8 TNOAUTH_KEA_RESPONSEA = System::Int8(0x4);
static const System::Int8 TNOENC_IS = System::Int8(0x0);
static const System::Int8 TNOENC_SUPPORT = System::Int8(0x1);
static const System::Int8 TNOENC_REPLY = System::Int8(0x2);
static const System::Int8 TNOENC_START = System::Int8(0x3);
static const System::Int8 TNOENC_END = System::Int8(0x4);
static const System::Int8 TNOENC_REQUEST_START = System::Int8(0x5);
static const System::Int8 TNOENC_REQUEST_END = System::Int8(0x6);
static const System::Int8 TNOENC_ENC_KEYID = System::Int8(0x7);
static const System::Int8 TNOENC_DEC_KEYID = System::Int8(0x8);
static const System::Int8 TNOENC_NULL = System::Int8(0x0);
static const System::Int8 TNOENC_DES_CFB64 = System::Int8(0x1);
static const System::Int8 TNOENC_DES_OFB64 = System::Int8(0x2);
static const System::Int8 TNOENC_DES3_CFB64 = System::Int8(0x3);
static const System::Int8 TNOENC_DES3_OFB64 = System::Int8(0x4);
static const System::Int8 TNOENC_CAST5_40_CFB64 = System::Int8(0x8);
static const System::Int8 TNOENC_CAST5_40_OFB64 = System::Int8(0x9);
static const System::Int8 TNOENC_CAST128_CFB64 = System::Int8(0xa);
static const System::Int8 TNOENC_CAST128_OFB64 = System::Int8(0xb);
static const System::Int8 TNOENC_AES_CCM = System::Int8(0xc);
static const System::Int8 TNOENC_CFB64_IV = System::Int8(0x1);
static const System::Int8 TNOENC_CFB64_IV_OK = System::Int8(0x2);
static const System::Int8 TNOENC_CFB64_IV_BAD = System::Int8(0x3);
static const System::Int8 TNOENC_OFB64_IV = System::Int8(0x1);
static const System::Int8 TNOENC_OFB64_IV_OK = System::Int8(0x2);
static const System::Int8 TNOENC_OFB64_IV_BAD = System::Int8(0x3);
}	/* namespace Idtelnet */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDTELNET)
using namespace Idtelnet;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdtelnetHPP
