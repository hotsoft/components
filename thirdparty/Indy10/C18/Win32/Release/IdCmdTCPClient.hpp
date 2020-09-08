// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCmdTCPClient.pas' rev: 25.00 (Windows)

#ifndef IdcmdtcpclientHPP
#define IdcmdtcpclientHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <IdResourceStringsCore.hpp>	// Pascal unit
#include <IdThread.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdCommandHandlers.hpp>	// Pascal unit
#include <IdTask.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcmdtcpclient
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdCmdTCPClient;
typedef void __fastcall (__closure *TIdCmdTCPClientAfterCommandHandlerEvent)(TIdCmdTCPClient* ASender, Idcontext::TIdContext* AContext);

typedef void __fastcall (__closure *TIdCmdTCPClientBeforeCommandHandlerEvent)(TIdCmdTCPClient* ASender, System::UnicodeString &AData, Idcontext::TIdContext* AContext);

class DELPHICLASS TIdCmdClientContext;
class PASCALIMPLEMENTATION TIdCmdClientContext : public Idcontext::TIdContext
{
	typedef Idcontext::TIdContext inherited;
	
protected:
	TIdCmdTCPClient* FClient;
	
public:
	__property TIdCmdTCPClient* Client = {read=FClient};
public:
	/* TIdContext.Create */ inline __fastcall virtual TIdCmdClientContext(Idtcpconnection::TIdTCPConnection* AConnection, Idyarn::TIdYarn* AYarn, Idthreadsafe::TIdThreadSafeObjectList* AList) : Idcontext::TIdContext(AConnection, AYarn, AList) { }
	/* TIdContext.Destroy */ inline __fastcall virtual ~TIdCmdClientContext(void) { }
	
};


class DELPHICLASS TIdCmdTCPClientListeningThread;
class PASCALIMPLEMENTATION TIdCmdTCPClientListeningThread : public Idthread::TIdThread
{
	typedef Idthread::TIdThread inherited;
	
protected:
	TIdCmdClientContext* FContext;
	TIdCmdTCPClient* FClient;
	System::UnicodeString FRecvData;
	virtual void __fastcall Run(void);
	
public:
	__fastcall TIdCmdTCPClientListeningThread(TIdCmdTCPClient* AClient);
	__fastcall virtual ~TIdCmdTCPClientListeningThread(void);
	__property TIdCmdTCPClient* Client = {read=FClient};
	__property System::UnicodeString RecvData = {read=FRecvData, write=FRecvData};
};


class PASCALIMPLEMENTATION TIdCmdTCPClient : public Idtcpclient::TIdTCPClient
{
	typedef Idtcpclient::TIdTCPClient inherited;
	
protected:
	Idreply::TIdReply* FExceptionReply;
	TIdCmdTCPClientListeningThread* FListeningThread;
	Idcommandhandlers::TIdCommandHandlers* FCommandHandlers;
	TIdCmdTCPClientAfterCommandHandlerEvent FOnAfterCommandHandler;
	TIdCmdTCPClientBeforeCommandHandlerEvent FOnBeforeCommandHandler;
	void __fastcall DoAfterCommandHandler(Idcommandhandlers::TIdCommandHandlers* ASender, Idcontext::TIdContext* AContext);
	void __fastcall DoBeforeCommandHandler(Idcommandhandlers::TIdCommandHandlers* ASender, System::UnicodeString &AData, Idcontext::TIdContext* AContext);
	virtual void __fastcall DoReplyUnknownCommand(Idcontext::TIdContext* AContext, System::UnicodeString ALine);
	virtual Idcommandhandlers::TIdCommandHandlerClass __fastcall GetCmdHandlerClass(void);
	virtual void __fastcall InitComponent(void);
	void __fastcall SetCommandHandlers(Idcommandhandlers::TIdCommandHandlers* AValue);
	void __fastcall SetExceptionReply(Idreply::TIdReply* AValue);
	
public:
	virtual void __fastcall Connect(void)/* overload */;
	__fastcall virtual ~TIdCmdTCPClient(void);
	virtual void __fastcall Disconnect(bool ANotifyPeer)/* overload */;
	
__published:
	__property Idcommandhandlers::TIdCommandHandlers* CommandHandlers = {read=FCommandHandlers, write=SetCommandHandlers};
	__property Idreply::TIdReply* ExceptionReply = {read=FExceptionReply, write=SetExceptionReply};
	__property TIdCmdTCPClientAfterCommandHandlerEvent OnAfterCommandHandler = {read=FOnAfterCommandHandler, write=FOnAfterCommandHandler};
	__property TIdCmdTCPClientBeforeCommandHandlerEvent OnBeforeCommandHandler = {read=FOnBeforeCommandHandler, write=FOnBeforeCommandHandler};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdCmdTCPClient(System::Classes::TComponent* AOwner)/* overload */ : Idtcpclient::TIdTCPClient(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdCmdTCPClient(void)/* overload */ : Idtcpclient::TIdTCPClient() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Connect(const System::UnicodeString AHost){ Idtcpclient::TIdTCPClientCustom::Connect(AHost); }
	inline void __fastcall  Connect(const System::UnicodeString AHost, const System::Word APort){ Idtcpclient::TIdTCPClientCustom::Connect(AHost, APort); }
	inline void __fastcall  Disconnect(void){ Idtcpconnection::TIdTCPConnection::Disconnect(); }
	
};


class DELPHICLASS EIdCmdTCPClientError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdCmdTCPClientError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdCmdTCPClientError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdCmdTCPClientError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdCmdTCPClientError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdCmdTCPClientError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCmdTCPClientError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCmdTCPClientError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdCmdTCPClientError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdCmdTCPClientError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCmdTCPClientError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCmdTCPClientError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCmdTCPClientError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCmdTCPClientError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdCmdTCPClientError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdCmdTCPClientConnectError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdCmdTCPClientConnectError : public EIdCmdTCPClientError
{
	typedef EIdCmdTCPClientError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdCmdTCPClientConnectError(const System::UnicodeString AMsg)/* overload */ : EIdCmdTCPClientError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdCmdTCPClientConnectError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdCmdTCPClientError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdCmdTCPClientConnectError(NativeUInt Ident)/* overload */ : EIdCmdTCPClientError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdCmdTCPClientConnectError(System::PResStringRec ResStringRec)/* overload */ : EIdCmdTCPClientError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCmdTCPClientConnectError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdCmdTCPClientError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCmdTCPClientConnectError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdCmdTCPClientError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdCmdTCPClientConnectError(const System::UnicodeString Msg, int AHelpContext) : EIdCmdTCPClientError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdCmdTCPClientConnectError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdCmdTCPClientError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCmdTCPClientConnectError(NativeUInt Ident, int AHelpContext)/* overload */ : EIdCmdTCPClientError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCmdTCPClientConnectError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdCmdTCPClientError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCmdTCPClientConnectError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdCmdTCPClientError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCmdTCPClientConnectError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdCmdTCPClientError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdCmdTCPClientConnectError(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idcmdtcpclient */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCMDTCPCLIENT)
using namespace Idcmdtcpclient;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcmdtcpclientHPP
