// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdPOP3Server.pas' rev: 25.00 (Windows)

#ifndef Idpop3serverHPP
#define Idpop3serverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdCommandHandlers.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdCmdTCPServer.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdExplicitTLSClientServerBase.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <IdTCPServer.hpp>	// Pascal unit
#include <IdServerIOHandler.hpp>	// Pascal unit
#include <IdMailBox.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit
#include <IdTask.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idpop3server
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdPOP3ServerContext;
class PASCALIMPLEMENTATION TIdPOP3ServerContext : public Idcustomtcpserver::TIdServerContext
{
	typedef Idcustomtcpserver::TIdServerContext inherited;
	
protected:
	System::UnicodeString fUsername;
	System::UnicodeString fPassword;
	bool fAuthenticated;
	System::UnicodeString fAPOP3Challenge;
	bool __fastcall GetUsingTLS(void);
	bool __fastcall GetCanUseExplicitTLS(void);
	bool __fastcall GetTLSIsRequired(void);
	
public:
	__property System::UnicodeString APOP3Challenge = {read=fAPOP3Challenge, write=fAPOP3Challenge};
	__property bool Authenticated = {read=fAuthenticated, nodefault};
	__property System::UnicodeString Username = {read=fUsername};
	__property System::UnicodeString Password = {read=fPassword};
	__property bool UsingTLS = {read=GetUsingTLS, nodefault};
	__property bool CanUseExplicitTLS = {read=GetCanUseExplicitTLS, nodefault};
	__property bool TLSIsRequired = {read=GetTLSIsRequired, nodefault};
public:
	/* TIdContext.Create */ inline __fastcall virtual TIdPOP3ServerContext(Idtcpconnection::TIdTCPConnection* AConnection, Idyarn::TIdYarn* AYarn, Idthreadsafe::TIdThreadSafeObjectList* AList) : Idcustomtcpserver::TIdServerContext(AConnection, AYarn, AList) { }
	/* TIdContext.Destroy */ inline __fastcall virtual ~TIdPOP3ServerContext(void) { }
	
};


typedef void __fastcall (__closure *TIdPOP3ServerNoParamEvent)(Idcommandhandlers::TIdCommand* aCmd);

typedef void __fastcall (__closure *TIdPOP3ServerStatEvent)(Idcommandhandlers::TIdCommand* aCmd, /* out */ int &oCount, /* out */ __int64 &oSize);

typedef void __fastcall (__closure *TIdPOP3ServerMessageNumberEvent)(Idcommandhandlers::TIdCommand* aCmd, int AMsgNo);

typedef void __fastcall (__closure *TIdPOP3ServerLogin)(Idcontext::TIdContext* aContext, TIdPOP3ServerContext* aServerContext);

typedef void __fastcall (__closure *TIdPOP3ServerCAPACommandEvent)(Idcontext::TIdContext* aContext, System::Classes::TStrings* aCapabilities);

typedef void __fastcall (__closure *TIdPOP3ServerAPOPCommandEvent)(Idcommandhandlers::TIdCommand* aCmd, System::UnicodeString aMailboxID, System::UnicodeString &vUsersPassword);

typedef void __fastcall (__closure *TIdPOP3ServerTOPCommandEvent)(Idcommandhandlers::TIdCommand* aCmd, int aMsgNo, int aLines);

class DELPHICLASS EIdPOP3ServerException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdPOP3ServerException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdPOP3ServerException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdPOP3ServerException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdPOP3ServerException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdPOP3ServerException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPOP3ServerException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPOP3ServerException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdPOP3ServerException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdPOP3ServerException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPOP3ServerException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPOP3ServerException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPOP3ServerException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPOP3ServerException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdPOP3ServerException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdPOP3ImplicitTLSRequiresSSL;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdPOP3ImplicitTLSRequiresSSL : public EIdPOP3ServerException
{
	typedef EIdPOP3ServerException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdPOP3ImplicitTLSRequiresSSL(const System::UnicodeString AMsg)/* overload */ : EIdPOP3ServerException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdPOP3ImplicitTLSRequiresSSL(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdPOP3ServerException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdPOP3ImplicitTLSRequiresSSL(NativeUInt Ident)/* overload */ : EIdPOP3ServerException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdPOP3ImplicitTLSRequiresSSL(System::PResStringRec ResStringRec)/* overload */ : EIdPOP3ServerException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPOP3ImplicitTLSRequiresSSL(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdPOP3ServerException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPOP3ImplicitTLSRequiresSSL(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdPOP3ServerException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdPOP3ImplicitTLSRequiresSSL(const System::UnicodeString Msg, int AHelpContext) : EIdPOP3ServerException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdPOP3ImplicitTLSRequiresSSL(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdPOP3ServerException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPOP3ImplicitTLSRequiresSSL(NativeUInt Ident, int AHelpContext)/* overload */ : EIdPOP3ServerException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPOP3ImplicitTLSRequiresSSL(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdPOP3ServerException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPOP3ImplicitTLSRequiresSSL(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdPOP3ServerException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPOP3ImplicitTLSRequiresSSL(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdPOP3ServerException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdPOP3ImplicitTLSRequiresSSL(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdPOP3Server;
class PASCALIMPLEMENTATION TIdPOP3Server : public Idexplicittlsclientserverbase::TIdExplicitTLSServer
{
	typedef Idexplicittlsclientserverbase::TIdExplicitTLSServer inherited;
	
protected:
	TIdPOP3ServerLogin fCommandLogin;
	TIdPOP3ServerMessageNumberEvent fCommandList;
	TIdPOP3ServerMessageNumberEvent fCommandRetr;
	TIdPOP3ServerMessageNumberEvent fCommandDele;
	TIdPOP3ServerMessageNumberEvent fCommandUIDL;
	TIdPOP3ServerTOPCommandEvent fCommandTop;
	TIdPOP3ServerNoParamEvent fCommandQuit;
	TIdPOP3ServerStatEvent fCommandStat;
	TIdPOP3ServerNoParamEvent fCommandRset;
	TIdPOP3ServerAPOPCommandEvent fCommandAPOP;
	TIdPOP3ServerCAPACommandEvent fCommandCapa;
	bool __fastcall IsAuthed(Idcommandhandlers::TIdCommand* aCmd, bool aAssigned);
	void __fastcall MustUseTLS(Idcommandhandlers::TIdCommand* aCmd);
	void __fastcall CommandUser(Idcommandhandlers::TIdCommand* aCmd);
	void __fastcall CommandPass(Idcommandhandlers::TIdCommand* aCmd);
	void __fastcall CommandList(Idcommandhandlers::TIdCommand* aCmd);
	void __fastcall CommandRetr(Idcommandhandlers::TIdCommand* aCmd);
	void __fastcall CommandDele(Idcommandhandlers::TIdCommand* aCmd);
	void __fastcall CommandQuit(Idcommandhandlers::TIdCommand* aCmd);
	void __fastcall CommandAPOP(Idcommandhandlers::TIdCommand* aCmd);
	void __fastcall CommandStat(Idcommandhandlers::TIdCommand* aCmd);
	void __fastcall CommandRset(Idcommandhandlers::TIdCommand* aCmd);
	void __fastcall CommandTop(Idcommandhandlers::TIdCommand* aCmd);
	void __fastcall CommandUIDL(Idcommandhandlers::TIdCommand* aCmd);
	void __fastcall CommandSTLS(Idcommandhandlers::TIdCommand* aCmd);
	void __fastcall CommandCAPA(Idcommandhandlers::TIdCommand* aCmd);
	virtual Idreply::TIdReply* __fastcall CreateExceptionReply(void);
	virtual Idreply::TIdReply* __fastcall CreateGreeting(void);
	virtual Idreply::TIdReply* __fastcall CreateHelpReply(void);
	virtual Idreply::TIdReply* __fastcall CreateMaxConnectionReply(void);
	virtual Idreply::TIdReply* __fastcall CreateReplyUnknownCommand(void);
	virtual void __fastcall InitializeCommandHandlers(void);
	virtual void __fastcall DoReplyUnknownCommand(Idcontext::TIdContext* AContext, System::UnicodeString ALine);
	virtual Idreply::TIdReplyClass __fastcall GetReplyClass(void);
	virtual Idreply::TIdRepliesClass __fastcall GetRepliesClass(void);
	virtual void __fastcall SendGreeting(Idcontext::TIdContext* AContext, Idreply::TIdReply* AGreeting);
	virtual void __fastcall InitComponent(void);
	
__published:
	__property DefaultPort = {default=110};
	__property TIdPOP3ServerLogin OnCheckUser = {read=fCommandLogin, write=fCommandLogin};
	__property TIdPOP3ServerMessageNumberEvent OnList = {read=fCommandList, write=fCommandList};
	__property TIdPOP3ServerMessageNumberEvent OnRetrieve = {read=fCommandRetr, write=fCommandRetr};
	__property TIdPOP3ServerMessageNumberEvent OnDelete = {read=fCommandDele, write=fCommandDele};
	__property TIdPOP3ServerMessageNumberEvent OnUIDL = {read=fCommandUIDL, write=fCommandUIDL};
	__property TIdPOP3ServerStatEvent OnStat = {read=fCommandStat, write=fCommandStat};
	__property TIdPOP3ServerTOPCommandEvent OnTop = {read=fCommandTop, write=fCommandTop};
	__property TIdPOP3ServerNoParamEvent OnReset = {read=fCommandRset, write=fCommandRset};
	__property TIdPOP3ServerNoParamEvent OnQuit = {read=fCommandQuit, write=fCommandQuit};
	__property TIdPOP3ServerAPOPCommandEvent OnAPOP = {read=fCommandAPOP, write=fCommandAPOP};
	__property TIdPOP3ServerCAPACommandEvent OnCAPA = {read=fCommandCapa, write=fCommandCapa};
	__property UseTLS = {default=0};
public:
	/* TIdCmdTCPServer.Destroy */ inline __fastcall virtual ~TIdPOP3Server(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdPOP3Server(System::Classes::TComponent* AOwner)/* overload */ : Idexplicittlsclientserverbase::TIdExplicitTLSServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdPOP3Server(void)/* overload */ : Idexplicittlsclientserverbase::TIdExplicitTLSServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const bool DEF_POP3_IMPLICIT_TLS = false;
}	/* namespace Idpop3server */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDPOP3SERVER)
using namespace Idpop3server;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idpop3serverHPP
