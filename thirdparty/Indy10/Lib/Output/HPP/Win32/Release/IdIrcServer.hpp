// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIrcServer.pas' rev: 25.00 (Windows)

#ifndef IdircserverHPP
#define IdircserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdCommandHandlers.hpp>	// Pascal unit
#include <IdCmdTCPServer.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdServerIOHandler.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idircserver
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TIdIRCGetEvent)(Idcommandhandlers::TIdCommand* AContext);

typedef void __fastcall (__closure *TIdIRCOtherEvent)(Idcommandhandlers::TIdCommand* AContext, System::UnicodeString Command, System::UnicodeString AParm);

typedef void __fastcall (__closure *TIdIRCOneParmEvent)(Idcommandhandlers::TIdCommand* AContext, System::UnicodeString AParm);

typedef void __fastcall (__closure *TIdIRCTwoParmEvent)(Idcommandhandlers::TIdCommand* AContext, System::UnicodeString AParm1, System::UnicodeString AParm2);

typedef void __fastcall (__closure *TIdIRCThreeParmEvent)(Idcommandhandlers::TIdCommand* AContext, System::UnicodeString AParm1, System::UnicodeString AParm2, System::UnicodeString AParm3);

typedef void __fastcall (__closure *TIdIRCFiveParmEvent)(Idcommandhandlers::TIdCommand* AContext, System::UnicodeString AParm1, System::UnicodeString AParm2, System::UnicodeString AParm3, System::UnicodeString AParm4, System::UnicodeString AParm5);

typedef void __fastcall (__closure *TIdIRCUserEvent)(Idcommandhandlers::TIdCommand* AContext, System::UnicodeString UserName, System::UnicodeString HostName, System::UnicodeString ServerName, System::UnicodeString RealName);

typedef void __fastcall (__closure *TIdIRCServerEvent)(Idcommandhandlers::TIdCommand* AContext, System::UnicodeString ServerName, System::UnicodeString Hopcount, System::UnicodeString Info);

class DELPHICLASS TIdIRCServer;
class PASCALIMPLEMENTATION TIdIRCServer : public Idcmdtcpserver::TIdCmdTCPServer
{
	typedef Idcmdtcpserver::TIdCmdTCPServer inherited;
	
protected:
	TIdIRCOtherEvent fOnCommandOther;
	TIdIRCOneParmEvent fOnCommandPass;
	TIdIRCTwoParmEvent fOnCommandNick;
	TIdIRCUserEvent fOnCommandUser;
	TIdIRCServerEvent fOnCommandServer;
	TIdIRCTwoParmEvent fOnCommandOper;
	TIdIRCOneParmEvent fOnCommandQuit;
	TIdIRCTwoParmEvent fOnCommandSQuit;
	TIdIRCTwoParmEvent fOnCommandJoin;
	TIdIRCOneParmEvent fOnCommandPart;
	TIdIRCFiveParmEvent fOnCommandMode;
	TIdIRCTwoParmEvent fOnCommandTopic;
	TIdIRCOneParmEvent fOnCommandNames;
	TIdIRCTwoParmEvent fOnCommandList;
	TIdIRCTwoParmEvent fOnCommandInvite;
	TIdIRCThreeParmEvent fOnCommandKick;
	TIdIRCOneParmEvent fOnCommandVersion;
	TIdIRCTwoParmEvent fOnCommandStats;
	TIdIRCTwoParmEvent fOnCommandLinks;
	TIdIRCOneParmEvent fOnCommandTime;
	TIdIRCThreeParmEvent fOnCommandConnect;
	TIdIRCOneParmEvent fOnCommandTrace;
	TIdIRCOneParmEvent fOnCommandAdmin;
	TIdIRCOneParmEvent fOnCommandInfo;
	TIdIRCTwoParmEvent fOnCommandPrivMsg;
	TIdIRCTwoParmEvent fOnCommandNotice;
	TIdIRCTwoParmEvent fOnCommandWho;
	TIdIRCTwoParmEvent fOnCommandWhoIs;
	TIdIRCThreeParmEvent fOnCommandWhoWas;
	TIdIRCTwoParmEvent fOnCommandKill;
	TIdIRCTwoParmEvent fOnCommandPing;
	TIdIRCTwoParmEvent fOnCommandPong;
	TIdIRCOneParmEvent fOnCommandError;
	TIdIRCOneParmEvent fOnCommandAway;
	TIdIRCGetEvent fOnCommandRehash;
	TIdIRCGetEvent fOnCommandRestart;
	TIdIRCTwoParmEvent fOnCommandSummon;
	TIdIRCOneParmEvent fOnCommandUsers;
	TIdIRCOneParmEvent fOnCommandWallops;
	TIdIRCOneParmEvent fOnCommandUserHost;
	TIdIRCOneParmEvent fOnCommandIsOn;
	virtual void __fastcall InitializeCommandHandlers(void);
	void __fastcall DoCommandOther(Idcommandhandlers::TIdCommandHandler* ASender, Idcommandhandlers::TIdCommand* ACommand, const System::UnicodeString AData, const System::UnicodeString AMessage);
	void __fastcall DoCommandPass(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandNick(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandUser(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandServer(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandOper(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandQuit(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandSQuit(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandJoin(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandPart(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandMode(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandTopic(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandNames(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandList(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandInvite(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandKick(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandVersion(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandStats(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandLinks(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandTime(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandConnect(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandTrace(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandAdmin(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandInfo(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandPrivMsg(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandNotice(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandWho(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandWhoIs(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandWhoWas(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandKill(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandPing(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandPong(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandError(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandAway(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandRehash(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandRestart(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandSummon(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandUsers(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandWallops(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandUserHost(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandIsOn(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandNotHandled(Idcommandhandlers::TIdCommandHandler* ASender, Idcommandhandlers::TIdCommand* ACommand, const System::UnicodeString AData, const System::UnicodeString AMessage);
	virtual void __fastcall DoConnect(Idcontext::TIdContext* AContext);
	virtual void __fastcall SetIOHandler(Idserveriohandler::TIdServerIOHandler* const AValue);
	virtual void __fastcall InitComponent(void);
	
__published:
	__property DefaultPort = {default=6667};
	__property TIdIRCOneParmEvent OnCommandPass = {read=fOnCommandPass, write=fOnCommandPass};
	__property TIdIRCTwoParmEvent OnCommandNick = {read=fOnCommandNick, write=fOnCommandNick};
	__property TIdIRCUserEvent OnCommandUser = {read=fOnCommandUser, write=fOnCommandUser};
	__property TIdIRCServerEvent OnCommandServer = {read=fOnCommandServer, write=fOnCommandServer};
	__property TIdIRCTwoParmEvent OnCommandOper = {read=fOnCommandOper, write=fOnCommandOper};
	__property TIdIRCOneParmEvent OnCommandQuit = {read=fOnCommandQuit, write=fOnCommandQuit};
	__property TIdIRCTwoParmEvent OnCommandSQuit = {read=fOnCommandSQuit, write=fOnCommandSQuit};
	__property TIdIRCTwoParmEvent OnCommandJoin = {read=fOnCommandJoin, write=fOnCommandJoin};
	__property TIdIRCOneParmEvent OnCommandPart = {read=fOnCommandPart, write=fOnCommandPart};
	__property TIdIRCFiveParmEvent OnCommandMode = {read=fOnCommandMode, write=fOnCommandMode};
	__property TIdIRCTwoParmEvent OnCommandTopic = {read=fOnCommandTopic, write=fOnCommandTopic};
	__property TIdIRCOneParmEvent OnCommandNames = {read=fOnCommandNames, write=fOnCommandNames};
	__property TIdIRCTwoParmEvent OnCommandList = {read=fOnCommandList, write=fOnCommandList};
	__property TIdIRCTwoParmEvent OnCommandInvite = {read=fOnCommandInvite, write=fOnCommandInvite};
	__property TIdIRCThreeParmEvent OnCommandKick = {read=fOnCommandKick, write=fOnCommandKick};
	__property TIdIRCOneParmEvent OnCommandVersion = {read=fOnCommandVersion, write=fOnCommandVersion};
	__property TIdIRCTwoParmEvent OnCommandStats = {read=fOnCommandStats, write=fOnCommandStats};
	__property TIdIRCTwoParmEvent OnCommandLinks = {read=fOnCommandLinks, write=fOnCommandLinks};
	__property TIdIRCOneParmEvent OnCommandTime = {read=fOnCommandTime, write=fOnCommandTime};
	__property TIdIRCThreeParmEvent OnCommandConnect = {read=fOnCommandConnect, write=fOnCommandConnect};
	__property TIdIRCOneParmEvent OnCommandTrace = {read=fOnCommandTrace, write=fOnCommandTrace};
	__property TIdIRCOneParmEvent OnCommandAdmin = {read=fOnCommandAdmin, write=fOnCommandAdmin};
	__property TIdIRCOneParmEvent OnCommandInfo = {read=fOnCommandInfo, write=fOnCommandInfo};
	__property TIdIRCTwoParmEvent OnCommandPrivMsg = {read=fOnCommandPrivMsg, write=fOnCommandPrivMsg};
	__property TIdIRCTwoParmEvent OnCommandNotice = {read=fOnCommandNotice, write=fOnCommandNotice};
	__property TIdIRCTwoParmEvent OnCommandWho = {read=fOnCommandWho, write=fOnCommandWho};
	__property TIdIRCTwoParmEvent OnCommandWhoIs = {read=fOnCommandWhoIs, write=fOnCommandWhoIs};
	__property TIdIRCThreeParmEvent OnCommandWhoWas = {read=fOnCommandWhoWas, write=fOnCommandWhoWas};
	__property TIdIRCTwoParmEvent OnCommandKill = {read=fOnCommandKill, write=fOnCommandKill};
	__property TIdIRCTwoParmEvent OnCommandPing = {read=fOnCommandPing, write=fOnCommandPing};
	__property TIdIRCTwoParmEvent OnCommandPong = {read=fOnCommandPong, write=fOnCommandPong};
	__property TIdIRCOneParmEvent OnCommandError = {read=fOnCommandError, write=fOnCommandError};
	__property TIdIRCOneParmEvent OnCommandAway = {read=fOnCommandAway, write=fOnCommandAway};
	__property TIdIRCGetEvent OnCommandRehash = {read=fOnCommandRehash, write=fOnCommandRehash};
	__property TIdIRCGetEvent OnCommandRestart = {read=fOnCommandRestart, write=fOnCommandRestart};
	__property TIdIRCTwoParmEvent OnCommandSummon = {read=fOnCommandSummon, write=fOnCommandSummon};
	__property TIdIRCOneParmEvent OnCommandUsers = {read=fOnCommandUsers, write=fOnCommandUsers};
	__property TIdIRCOneParmEvent OnCommandWallops = {read=fOnCommandWallops, write=fOnCommandWallops};
	__property TIdIRCOneParmEvent OnCommandUserHost = {read=fOnCommandUserHost, write=fOnCommandUserHost};
	__property TIdIRCOneParmEvent OnCommandIsOn = {read=fOnCommandIsOn, write=fOnCommandIsOn};
	__property TIdIRCOtherEvent OnCommandOther = {read=fOnCommandOther, write=fOnCommandOther};
public:
	/* TIdCmdTCPServer.Destroy */ inline __fastcall virtual ~TIdIRCServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdIRCServer(System::Classes::TComponent* AOwner)/* overload */ : Idcmdtcpserver::TIdCmdTCPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdIRCServer(void)/* overload */ : Idcmdtcpserver::TIdCmdTCPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idircserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDIRCSERVER)
using namespace Idircserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdircserverHPP
