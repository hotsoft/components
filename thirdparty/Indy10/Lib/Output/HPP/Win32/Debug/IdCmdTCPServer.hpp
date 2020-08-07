// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCmdTCPServer.pas' rev: 25.00 (Windows)

#ifndef IdcmdtcpserverHPP
#define IdcmdtcpserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdCommandHandlers.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdIOHandler.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <IdTCPServer.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcmdtcpserver
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdCmdTCPServer;
typedef void __fastcall (__closure *TIdCmdTCPServerAfterCommandHandlerEvent)(TIdCmdTCPServer* ASender, Idcontext::TIdContext* AContext);

typedef void __fastcall (__closure *TIdCmdTCPServerBeforeCommandHandlerEvent)(TIdCmdTCPServer* ASender, System::UnicodeString &AData, Idcontext::TIdContext* AContext);

class PASCALIMPLEMENTATION TIdCmdTCPServer : public Idtcpserver::TIdTCPServer
{
	typedef Idtcpserver::TIdTCPServer inherited;
	
protected:
	Idcommandhandlers::TIdCommandHandlers* FCommandHandlers;
	bool FCommandHandlersInitialized;
	Idreply::TIdReply* FExceptionReply;
	Idreply::TIdReply* FHelpReply;
	Idreply::TIdReply* FGreeting;
	Idreply::TIdReply* FMaxConnectionReply;
	TIdCmdTCPServerAfterCommandHandlerEvent FOnAfterCommandHandler;
	TIdCmdTCPServerBeforeCommandHandlerEvent FOnBeforeCommandHandler;
	Idreply::TIdReplyClass FReplyClass;
	Idreply::TIdReplies* FReplyTexts;
	Idreply::TIdReply* FReplyUnknownCommand;
	virtual void __fastcall CheckOkToBeActive(void);
	virtual Idreply::TIdReply* __fastcall CreateExceptionReply(void);
	virtual Idreply::TIdReply* __fastcall CreateGreeting(void);
	virtual Idreply::TIdReply* __fastcall CreateHelpReply(void);
	virtual Idreply::TIdReply* __fastcall CreateMaxConnectionReply(void);
	virtual Idreply::TIdReply* __fastcall CreateReplyUnknownCommand(void);
	void __fastcall DoAfterCommandHandler(Idcommandhandlers::TIdCommandHandlers* ASender, Idcontext::TIdContext* AContext);
	void __fastcall DoBeforeCommandHandler(Idcommandhandlers::TIdCommandHandlers* ASender, System::UnicodeString &AData, Idcontext::TIdContext* AContext);
	virtual void __fastcall DoConnect(Idcontext::TIdContext* AContext);
	virtual bool __fastcall DoExecute(Idcontext::TIdContext* AContext);
	virtual void __fastcall DoMaxConnectionsExceeded(Idiohandler::TIdIOHandler* AIOHandler);
	virtual void __fastcall DoReplyUnknownCommand(Idcontext::TIdContext* AContext, System::UnicodeString ALine);
	Idreply::TIdReply* __fastcall GetExceptionReply(void);
	Idreply::TIdReply* __fastcall GetGreeting(void);
	Idreply::TIdReply* __fastcall GetHelpReply(void);
	Idreply::TIdReply* __fastcall GetMaxConnectionReply(void);
	virtual Idreply::TIdRepliesClass __fastcall GetRepliesClass(void);
	virtual Idreply::TIdReplyClass __fastcall GetReplyClass(void);
	Idreply::TIdReply* __fastcall GetReplyUnknownCommand(void);
	virtual void __fastcall InitializeCommandHandlers(void);
	virtual void __fastcall InitComponent(void);
	virtual System::UnicodeString __fastcall ReadCommandLine(Idcontext::TIdContext* AContext);
	virtual void __fastcall Startup(void);
	void __fastcall SetCommandHandlers(Idcommandhandlers::TIdCommandHandlers* AValue);
	void __fastcall SetExceptionReply(Idreply::TIdReply* AValue);
	void __fastcall SetGreeting(Idreply::TIdReply* AValue);
	void __fastcall SetHelpReply(Idreply::TIdReply* AValue);
	void __fastcall SetMaxConnectionReply(Idreply::TIdReply* AValue);
	void __fastcall SetReplyUnknownCommand(Idreply::TIdReply* AValue);
	void __fastcall SetReplyTexts(Idreply::TIdReplies* AValue);
	
public:
	__fastcall virtual ~TIdCmdTCPServer(void);
	
__published:
	__property Idcommandhandlers::TIdCommandHandlers* CommandHandlers = {read=FCommandHandlers, write=SetCommandHandlers};
	__property Idreply::TIdReply* ExceptionReply = {read=GetExceptionReply, write=SetExceptionReply};
	__property Idreply::TIdReply* Greeting = {read=GetGreeting, write=SetGreeting};
	__property Idreply::TIdReply* HelpReply = {read=GetHelpReply, write=SetHelpReply};
	__property Idreply::TIdReply* MaxConnectionReply = {read=GetMaxConnectionReply, write=SetMaxConnectionReply};
	__property Idreply::TIdReplies* ReplyTexts = {read=FReplyTexts, write=SetReplyTexts};
	__property Idreply::TIdReply* ReplyUnknownCommand = {read=GetReplyUnknownCommand, write=SetReplyUnknownCommand};
	__property TIdCmdTCPServerAfterCommandHandlerEvent OnAfterCommandHandler = {read=FOnAfterCommandHandler, write=FOnAfterCommandHandler};
	__property TIdCmdTCPServerBeforeCommandHandlerEvent OnBeforeCommandHandler = {read=FOnBeforeCommandHandler, write=FOnBeforeCommandHandler};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdCmdTCPServer(System::Classes::TComponent* AOwner)/* overload */ : Idtcpserver::TIdTCPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdCmdTCPServer(void)/* overload */ : Idtcpserver::TIdTCPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idcmdtcpserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCMDTCPSERVER)
using namespace Idcmdtcpserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcmdtcpserverHPP
