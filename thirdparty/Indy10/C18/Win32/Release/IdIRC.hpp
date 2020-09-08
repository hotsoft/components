// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIRC.pas' rev: 25.00 (Windows)

#ifndef IdircHPP
#define IdircHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdCmdTCPClient.hpp>	// Pascal unit
#include <IdCommandHandlers.hpp>	// Pascal unit
#include <IdIOHandler.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idirc
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdIRCUserMode : unsigned char { amAway, amInvisible, amWallops, amRestricted, amOperator, amLocalOperator, amReceiveServerNotices };

typedef System::Set<TIdIRCUserMode, TIdIRCUserMode::amAway, TIdIRCUserMode::amReceiveServerNotices>  TIdIRCUserModes;

enum DECLSPEC_DENUM TIdIRCStat : unsigned char { stServerConnectionsList, stCommandUsageCount, stOperatorList, stUpTime };

typedef void __fastcall (__closure *TIdIRCServerMsgEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString AMsg);

typedef void __fastcall (__closure *TIdIRCMyInfoEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString AServer, const System::UnicodeString AVersion, const System::UnicodeString AUserModes, const System::UnicodeString AChanModes, const System::UnicodeString AExtra);

typedef void __fastcall (__closure *TIdIRCBounceEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString AHost, int APort, const System::UnicodeString AInfo);

typedef void __fastcall (__closure *TIdIRCISupportEvent)(Idcontext::TIdContext* ASender, System::Classes::TStrings* AParameters);

typedef void __fastcall (__closure *TIdIRCPingPongEvent)(Idcontext::TIdContext* ASender);

typedef void __fastcall (__closure *TIdIRCPrivMessageEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString ATarget, const System::UnicodeString AMessage);

typedef void __fastcall (__closure *TIdIRCNoticeEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString ATarget, const System::UnicodeString ANotice);

typedef void __fastcall (__closure *TIdIRCRehashEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost);

typedef void __fastcall (__closure *TIdIRCSummonEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost);

typedef void __fastcall (__closure *TIdIRCWallopsEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString AMessage);

typedef void __fastcall (__closure *TIdIRCIsOnIRCEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost);

typedef void __fastcall (__closure *TIdIRCAwayEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString AAwayMessage, bool UserAway);

typedef void __fastcall (__closure *TIdIRCJoinEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString AChannel);

typedef void __fastcall (__closure *TIdIRCPartEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString AChannel, const System::UnicodeString APartMessage);

typedef void __fastcall (__closure *TIdIRCTopicEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString AChannel, const System::UnicodeString ATopic);

typedef void __fastcall (__closure *TIdIRCKickEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString AChannel, const System::UnicodeString ATarget, const System::UnicodeString AReason);

typedef void __fastcall (__closure *TIdIRCMOTDEvent)(Idcontext::TIdContext* ASender, System::Classes::TStrings* AMOTD);

typedef void __fastcall (__closure *TIdIRCServerTraceEvent)(Idcontext::TIdContext* ASender, System::Classes::TStrings* ATraceInfo);

typedef void __fastcall (__closure *TIdIRCOpEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AChannel, const System::UnicodeString AHost);

typedef void __fastcall (__closure *TIdIRCInvitingEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost);

typedef void __fastcall (__closure *TIdIRCInviteEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString ATarget, const System::UnicodeString AChannel);

typedef void __fastcall (__closure *TIdIRCChanBANListEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString AChannel, System::Classes::TStrings* ABanList);

typedef void __fastcall (__closure *TIdIRCChanEXCListEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString AChannel, System::Classes::TStrings* AExceptList);

typedef void __fastcall (__closure *TIdIRCChanINVListEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString AChannel, System::Classes::TStrings* AInviteList);

typedef void __fastcall (__closure *TIdIRCServerListEvent)(Idcontext::TIdContext* ASender, System::Classes::TStrings* AServerList);

typedef void __fastcall (__closure *TIdIRCNickListEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString AChannel, System::Classes::TStrings* ANicknameList);

typedef void __fastcall (__closure *TIdIRCServerUsersEvent)(Idcontext::TIdContext* ASender, System::Classes::TStrings* AUsers);

typedef void __fastcall (__closure *TIdIRCServerStatsEvent)(Idcontext::TIdContext* ASender, System::Classes::TStrings* AStatus);

typedef void __fastcall (__closure *TIdIRCKnownServerNamesEvent)(Idcontext::TIdContext* ASender, System::Classes::TStrings* AKnownServers);

typedef void __fastcall (__closure *TIdIRCAdminInfoRecvEvent)(Idcontext::TIdContext* ASender, System::Classes::TStrings* AAdminInfo);

typedef void __fastcall (__closure *TIdIRCUserInfoRecvEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString AUserInfo);

typedef void __fastcall (__closure *TIdIRCWhoEvent)(Idcontext::TIdContext* ASender, System::Classes::TStrings* AWhoResults);

typedef void __fastcall (__closure *TIdIRCWhoIsEvent)(Idcontext::TIdContext* ASender, System::Classes::TStrings* AWhoIsResults);

typedef void __fastcall (__closure *TIdIRCWhoWasEvent)(Idcontext::TIdContext* ASender, System::Classes::TStrings* AWhoWasResults);

typedef void __fastcall (__closure *TIdIRCChanModeEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString AChannel, const System::UnicodeString AMode, const System::UnicodeString AParams);

typedef void __fastcall (__closure *TIdIRCUserModeEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString AMode);

typedef void __fastcall (__closure *TIdIRCCTCPQueryEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString ATarget, const System::UnicodeString ACommand, const System::UnicodeString AParams);

typedef void __fastcall (__closure *TIdIRCCTCPReplyEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString ATarget, const System::UnicodeString ACommand, const System::UnicodeString AParams);

typedef void __fastcall (__closure *TIdIRCDCCChatEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, int APort);

typedef void __fastcall (__closure *TIdIRCDCCSendEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString AFilename, System::Word APort, __int64 AFileSize);

typedef void __fastcall (__closure *TIdIRCDCCResumeEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString AFilename, System::Word APort, __int64 AFilePos);

typedef void __fastcall (__closure *TIdIRCDCCAcceptEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString AFilename, System::Word APort, __int64 AFilePos);

typedef void __fastcall (__closure *TIdIRCServerErrorEvent)(Idcontext::TIdContext* ASender, int AErrorCode, const System::UnicodeString AErrorMessage);

typedef void __fastcall (__closure *TIdIRCNickErrorEvent)(Idcontext::TIdContext* ASender, int AError);

typedef void __fastcall (__closure *TIdIRCKillErrorEvent)(Idcontext::TIdContext* ASender);

typedef void __fastcall (__closure *TIdIRCNicknameChangedEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString AOldNickname, const System::UnicodeString AHost, const System::UnicodeString ANewNickname);

typedef void __fastcall (__closure *TIdIRCKillEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString ATargetNickname, const System::UnicodeString AReason);

typedef void __fastcall (__closure *TIdIRCQuitEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString AReason);

typedef void __fastcall (__closure *TIdIRCSvrQuitEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString ANickname, const System::UnicodeString AHost, const System::UnicodeString AServer, const System::UnicodeString AReason);

typedef void __fastcall (__closure *TIdIRCSvrTimeEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString AHost, const System::UnicodeString ATime);

typedef void __fastcall (__closure *TIdIRCServiceEvent)(Idcontext::TIdContext* ASender);

typedef void __fastcall (__closure *TIdIRCSvrVersionEvent)(Idcontext::TIdContext* ASender, const System::UnicodeString AVersion, const System::UnicodeString AHost, const System::UnicodeString AComments);

typedef void __fastcall (__closure *TIdIRCRawEvent)(Idcontext::TIdContext* ASender, bool AIn, const System::UnicodeString AMessage);

class DELPHICLASS EIdIRCError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIRCError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIRCError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIRCError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIRCError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIRCError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIRCError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIRCError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIRCError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIRCError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIRCError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIRCError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIRCError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIRCError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIRCError(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdIRCReplies;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdIRCReplies : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
protected:
	System::UnicodeString FFinger;
	System::UnicodeString FVersion;
	System::UnicodeString FUserInfo;
	System::UnicodeString FClientInfo;
	
public:
	__fastcall TIdIRCReplies(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property System::UnicodeString Finger = {read=FFinger, write=FFinger};
	__property System::UnicodeString Version = {read=FVersion, write=FVersion};
	__property System::UnicodeString UserInfo = {read=FUserInfo, write=FUserInfo};
	__property System::UnicodeString ClientInfo = {read=FClientInfo, write=FClientInfo};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TIdIRCReplies(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdIRC;
class PASCALIMPLEMENTATION TIdIRC : public Idcmdtcpclient::TIdCmdTCPClient
{
	typedef Idcmdtcpclient::TIdCmdTCPClient inherited;
	
protected:
	System::UnicodeString FNickname;
	System::UnicodeString FAltNickname;
	bool FAltNickUsed;
	System::UnicodeString FUsername;
	System::UnicodeString FRealName;
	System::UnicodeString FPassword;
	TIdIRCUserModes FUserMode;
	bool FUserAway;
	TIdIRCReplies* FReplies;
	System::UnicodeString FSenderNick;
	System::UnicodeString FSenderHost;
	System::Classes::TStrings* FBans;
	System::Classes::TStrings* FExcepts;
	System::Classes::TStrings* FInvites;
	System::Classes::TStrings* FLinks;
	System::Classes::TStrings* FMotd;
	System::Classes::TStrings* FNames;
	System::Classes::TStrings* FWho;
	System::Classes::TStrings* FWhoIs;
	System::Classes::TStrings* FWhoWas;
	System::Classes::TStrings* FSvrList;
	System::Classes::TStrings* FUsers;
	TIdIRCServerMsgEvent FOnSWelcome;
	TIdIRCServerMsgEvent FOnYourHost;
	TIdIRCServerMsgEvent FOnSCreated;
	TIdIRCMyInfoEvent FOnMyInfo;
	TIdIRCBounceEvent FOnBounce;
	TIdIRCISupportEvent FOnISupport;
	TIdIRCServerMsgEvent FOnSError;
	TIdIRCPingPongEvent FOnPingPong;
	TIdIRCPrivMessageEvent FOnPrivMessage;
	TIdIRCNoticeEvent FOnNotice;
	TIdIRCRehashEvent FOnRehash;
	TIdIRCSummonEvent FOnSummon;
	TIdIRCWallopsEvent FOnWallops;
	TIdIRCIsOnIRCEvent FOnIsOnIRC;
	TIdIRCAwayEvent FOnAway;
	TIdIRCJoinEvent FOnJoin;
	TIdIRCPartEvent FOnPart;
	TIdIRCTopicEvent FOnTopic;
	TIdIRCKickEvent FOnKick;
	TIdIRCMOTDEvent FOnMOTD;
	TIdIRCServerTraceEvent FOnTrace;
	TIdIRCOpEvent FOnOp;
	TIdIRCInvitingEvent FOnInviting;
	TIdIRCInviteEvent FOnInvite;
	TIdIRCChanBANListEvent FOnBANList;
	TIdIRCChanEXCListEvent FOnEXCList;
	TIdIRCChanINVListEvent FOnINVList;
	TIdIRCServerListEvent FOnSvrList;
	TIdIRCNickListEvent FOnNickList;
	TIdIRCServerUsersEvent FOnSvrUsers;
	TIdIRCServerStatsEvent FOnSvrStats;
	TIdIRCKnownServerNamesEvent FOnKnownSvrs;
	TIdIRCAdminInfoRecvEvent FOnAdminInfo;
	TIdIRCUserInfoRecvEvent FOnUserInfo;
	TIdIRCWhoEvent FOnWho;
	TIdIRCWhoIsEvent FOnWhoIs;
	TIdIRCWhoWasEvent FOnWhoWas;
	TIdIRCChanModeEvent FOnChanMode;
	TIdIRCUserModeEvent FOnUserMode;
	TIdIRCCTCPQueryEvent FOnCTCPQry;
	TIdIRCCTCPReplyEvent FOnCTCPRep;
	TIdIRCDCCChatEvent FOnDCCChat;
	TIdIRCDCCSendEvent FOnDCCSend;
	TIdIRCDCCResumeEvent FOnDCCResume;
	TIdIRCDCCAcceptEvent FOnDCCAccept;
	TIdIRCServerErrorEvent FOnServerError;
	TIdIRCNickErrorEvent FOnNickError;
	TIdIRCKillErrorEvent FOnKillError;
	TIdIRCNicknameChangedEvent FOnNickChange;
	TIdIRCKillEvent FOnKill;
	TIdIRCQuitEvent FOnQuit;
	TIdIRCSvrQuitEvent FOnSvrQuit;
	TIdIRCSvrTimeEvent FOnSvrTime;
	TIdIRCServiceEvent FOnService;
	TIdIRCSvrVersionEvent FOnSvrVersion;
	TIdIRCRawEvent FOnRaw;
	System::UnicodeString __fastcall GetUsedNickname(void);
	void __fastcall SetNickname(const System::UnicodeString AValue);
	void __fastcall SetUsername(const System::UnicodeString AValue);
	void __fastcall SetIdIRCUserMode(TIdIRCUserModes AValue);
	void __fastcall SetIdIRCReplies(TIdIRCReplies* AValue);
	System::UnicodeString __fastcall GetUserMode(void);
	void __fastcall ParseDCC(Idcontext::TIdContext* AContext, const System::UnicodeString ADCC);
	void __fastcall DoBeforeCmd(Idcommandhandlers::TIdCommandHandlers* ASender, System::UnicodeString &AData, Idcontext::TIdContext* AContext);
	virtual void __fastcall DoReplyUnknownCommand(Idcontext::TIdContext* AContext, System::UnicodeString ALine);
	void __fastcall DoBounce(Idcommandhandlers::TIdCommand* ASender, bool ALegacy);
	void __fastcall CommandPRIVMSG(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandNOTICE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandJOIN(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandPART(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandKICK(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandMODE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandNICK(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandQUIT(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandSQUIT(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandINVITE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandKILL(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandPING(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandERROR(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandWALLOPS(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandTOPIC(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandWELCOME(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandYOURHOST(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandCREATED(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandMYINFO(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandISUPPORT(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandBOUNCE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandUSERHOST(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandISON(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandWHOIS(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandENDOFWHOIS(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandWHOWAS(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandENDOFWHOWAS(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandLISTSTART(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandLIST(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandLISTEND(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandAWAY(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandINVITING(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandSUMMONING(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandINVITELIST(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandENDOFINVITELIST(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandEXCEPTLIST(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandENDOFEXCEPTLIST(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandWHOREPLY(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandENDOFWHO(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandNAMEREPLY(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandENDOFNAMES(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandLINKS(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandENDOFLINKS(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandBANLIST(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandENDOFBANLIST(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandINFO(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandENDOFINFO(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandMOTD(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandENDOFMOTD(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandREHASHING(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandUSERSSTART(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandUSERS(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandENDOFUSERS(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandENDOFSTATS(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandSERVLIST(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandSERVLISTEND(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandTIME(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandSERVICE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandVERSION(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandCHANMODE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandOPER(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall CommandNICKINUSE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall AssignIRCClientCommands(void);
	virtual Idcommandhandlers::TIdCommandHandlerClass __fastcall GetCmdHandlerClass(void);
	virtual void __fastcall SetIOHandler(Idiohandler::TIdIOHandler* AValue);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall virtual ~TIdIRC(void);
	virtual void __fastcall Connect(void)/* overload */;
	HIDESBASE void __fastcall Disconnect(const System::UnicodeString AReason = System::UnicodeString());
	bool __fastcall IsChannel(const System::UnicodeString AChannel);
	bool __fastcall IsOp(const System::UnicodeString ANickname);
	bool __fastcall IsVoice(const System::UnicodeString ANickname);
	void __fastcall Raw(const System::UnicodeString ALine);
	void __fastcall Say(const System::UnicodeString ATarget, const System::UnicodeString AMsg);
	void __fastcall Notice(const System::UnicodeString ATarget, const System::UnicodeString AMsg);
	void __fastcall Action(const System::UnicodeString ATarget, const System::UnicodeString AMsg);
	void __fastcall CTCPQuery(const System::UnicodeString ATarget, const System::UnicodeString ACommand, const System::UnicodeString AParameters);
	void __fastcall CTCPReply(const System::UnicodeString ATarget, const System::UnicodeString ACTCP, const System::UnicodeString AReply);
	void __fastcall Join(const System::UnicodeString AChannel, const System::UnicodeString AKey = System::UnicodeString());
	void __fastcall Part(const System::UnicodeString AChannel, const System::UnicodeString AReason = System::UnicodeString());
	void __fastcall Kick(const System::UnicodeString AChannel, const System::UnicodeString ANickname, const System::UnicodeString AReason = System::UnicodeString());
	void __fastcall SetChannelMode(const System::UnicodeString AChannel, const System::UnicodeString AMode, const System::UnicodeString AParams = System::UnicodeString());
	void __fastcall SetUserMode(const System::UnicodeString ANickname, const System::UnicodeString AMode);
	void __fastcall GetChannelTopic(const System::UnicodeString AChannel);
	void __fastcall SetChannelTopic(const System::UnicodeString AChannel, const System::UnicodeString ATopic);
	void __fastcall SetAway(const System::UnicodeString AMsg);
	void __fastcall Op(const System::UnicodeString AChannel, const System::UnicodeString ANickname);
	void __fastcall Deop(const System::UnicodeString AChannel, const System::UnicodeString ANickname);
	void __fastcall Voice(const System::UnicodeString AChannel, const System::UnicodeString ANickname);
	void __fastcall Devoice(const System::UnicodeString AChannel, const System::UnicodeString ANickname);
	void __fastcall Ban(const System::UnicodeString AChannel, const System::UnicodeString AHostmask);
	void __fastcall Unban(const System::UnicodeString AChannel, const System::UnicodeString AHostmask);
	void __fastcall RegisterService(const System::UnicodeString ANickname, const System::UnicodeString ADistribution, const System::UnicodeString AInfo, int AType);
	void __fastcall ListChannelNicknames(const System::UnicodeString AChannel, const System::UnicodeString ATarget = System::UnicodeString());
	void __fastcall ListChannel(const System::UnicodeString AChannel, const System::UnicodeString ATarget = System::UnicodeString());
	void __fastcall Invite(const System::UnicodeString ANickname, const System::UnicodeString AChannel);
	void __fastcall GetMessageOfTheDay(const System::UnicodeString ATarget = System::UnicodeString());
	void __fastcall GetNetworkStatus(const System::UnicodeString AHostMask = System::UnicodeString(), const System::UnicodeString ATarget = System::UnicodeString());
	void __fastcall GetServerVersion(const System::UnicodeString ATarget = System::UnicodeString());
	void __fastcall GetServerStatus(TIdIRCStat AQuery, const System::UnicodeString ATarget = System::UnicodeString());
	void __fastcall ListKnownServerNames(const System::UnicodeString ARemoteHost = System::UnicodeString(), const System::UnicodeString AHostMask = System::UnicodeString());
	void __fastcall QueryServerTime(const System::UnicodeString ATarget = System::UnicodeString());
	void __fastcall RequestServerConnect(const System::UnicodeString ATargetHost, int APort, const System::UnicodeString ARemoteHost = System::UnicodeString());
	void __fastcall TraceServer(const System::UnicodeString ATarget = System::UnicodeString());
	void __fastcall GetAdminInfo(const System::UnicodeString ATarget = System::UnicodeString());
	void __fastcall GetServerInfo(const System::UnicodeString ATarget = System::UnicodeString());
	void __fastcall ListNetworkServices(const System::UnicodeString AHostMask = System::UnicodeString(), const System::UnicodeString AType = System::UnicodeString());
	void __fastcall QueryService(const System::UnicodeString AServiceName, const System::UnicodeString AMessage);
	void __fastcall Who(const System::UnicodeString AMask, bool AOnlyAdmins);
	void __fastcall WhoIs(const System::UnicodeString AMask, const System::UnicodeString ATarget = System::UnicodeString());
	void __fastcall WhoWas(const System::UnicodeString ANickname, int ACount = 0xffffffff, const System::UnicodeString ATarget = System::UnicodeString());
	void __fastcall Kill(const System::UnicodeString ANickname, const System::UnicodeString AComment);
	void __fastcall Ping(const System::UnicodeString AServer1, const System::UnicodeString AServer2 = System::UnicodeString());
	void __fastcall Pong(const System::UnicodeString AServer1, const System::UnicodeString AServer2 = System::UnicodeString());
	void __fastcall Error(const System::UnicodeString AMessage);
	void __fastcall ReHash(void);
	void __fastcall Die(void);
	void __fastcall Restart(void);
	void __fastcall Summon(const System::UnicodeString ANickname, const System::UnicodeString ATarget = System::UnicodeString(), const System::UnicodeString AChannel = System::UnicodeString());
	void __fastcall ListServerUsers(const System::UnicodeString ATarget = System::UnicodeString());
	void __fastcall SayWALLOPS(const System::UnicodeString AMessage);
	void __fastcall GetUserInfo(const System::UnicodeString ANickname);
	void __fastcall GetUsersInfo(System::UnicodeString const *ANicknames, const int ANicknames_Size);
	void __fastcall IsOnIRC(const System::UnicodeString ANickname)/* overload */;
	void __fastcall IsOnIRC(System::UnicodeString const *ANicknames, const int ANicknames_Size)/* overload */;
	void __fastcall BecomeOp(const System::UnicodeString ANickname, const System::UnicodeString APassword);
	void __fastcall SQuit(const System::UnicodeString AHost, const System::UnicodeString AComment);
	void __fastcall SetChannelLimit(const System::UnicodeString AChannel, int ALimit);
	void __fastcall SetChannelKey(const System::UnicodeString AChannel, const System::UnicodeString AKey);
	__property bool Away = {read=FUserAway, nodefault};
	__property System::UnicodeString SenderNick = {read=FSenderNick};
	__property System::UnicodeString SenderHost = {read=FSenderHost};
	
__published:
	__property System::UnicodeString Nickname = {read=FNickname, write=SetNickname};
	__property System::UnicodeString AltNickname = {read=FAltNickname, write=FAltNickname};
	__property System::UnicodeString UsedNickname = {read=GetUsedNickname};
	__property System::UnicodeString Username = {read=FUsername, write=SetUsername};
	__property System::UnicodeString RealName = {read=FRealName, write=FRealName};
	__property System::UnicodeString Password = {read=FPassword, write=FPassword};
	__property Port = {default=6667};
	__property TIdIRCReplies* Replies = {read=FReplies, write=SetIdIRCReplies};
	__property TIdIRCUserModes UserMode = {read=FUserMode, write=SetIdIRCUserMode, nodefault};
	__property TIdIRCServerMsgEvent OnServerWelcome = {read=FOnSWelcome, write=FOnSWelcome};
	__property TIdIRCServerMsgEvent OnYourHost = {read=FOnYourHost, write=FOnYourHost};
	__property TIdIRCServerMsgEvent OnServerCreated = {read=FOnSCreated, write=FOnSCreated};
	__property TIdIRCMyInfoEvent OnMyInfo = {read=FOnMyInfo, write=FOnMyInfo};
	__property TIdIRCBounceEvent OnBounce = {read=FOnBounce, write=FOnBounce};
	__property TIdIRCISupportEvent OnISupport = {read=FOnISupport, write=FOnISupport};
	__property TIdIRCPingPongEvent OnPingPong = {read=FOnPingPong, write=FOnPingPong};
	__property TIdIRCPrivMessageEvent OnPrivateMessage = {read=FOnPrivMessage, write=FOnPrivMessage};
	__property TIdIRCNoticeEvent OnNotice = {read=FOnNotice, write=FOnNotice};
	__property TIdIRCRehashEvent OnRehash = {read=FOnRehash, write=FOnRehash};
	__property TIdIRCSummonEvent OnSummon = {read=FOnSummon, write=FOnSummon};
	__property TIdIRCWallopsEvent OnWallops = {read=FOnWallops, write=FOnWallops};
	__property TIdIRCIsOnIRCEvent OnIsOnIRC = {read=FOnIsOnIRC, write=FOnIsOnIRC};
	__property TIdIRCAwayEvent OnAway = {read=FOnAway, write=FOnAway};
	__property TIdIRCJoinEvent OnJoin = {read=FOnJoin, write=FOnJoin};
	__property TIdIRCPartEvent OnPart = {read=FOnPart, write=FOnPart};
	__property TIdIRCTopicEvent OnTopic = {read=FOnTopic, write=FOnTopic};
	__property TIdIRCKickEvent OnKick = {read=FOnKick, write=FOnKick};
	__property TIdIRCMOTDEvent OnMOTD = {read=FOnMOTD, write=FOnMOTD};
	__property TIdIRCServerTraceEvent OnTrace = {read=FOnTrace, write=FOnTrace};
	__property TIdIRCOpEvent OnOp = {read=FOnOp, write=FOnOp};
	__property TIdIRCInvitingEvent OnInviting = {read=FOnInviting, write=FOnInviting};
	__property TIdIRCInviteEvent OnInvite = {read=FOnInvite, write=FOnInvite};
	__property TIdIRCChanBANListEvent OnBanListReceived = {read=FOnBANList, write=FOnBANList};
	__property TIdIRCChanEXCListEvent OnExceptionListReceived = {read=FOnEXCList, write=FOnEXCList};
	__property TIdIRCChanINVListEvent OnInvitationListReceived = {read=FOnINVList, write=FOnINVList};
	__property TIdIRCServerListEvent OnServerListReceived = {read=FOnSvrList, write=FOnSvrList};
	__property TIdIRCNickListEvent OnNicknamesListReceived = {read=FOnNickList, write=FOnNickList};
	__property TIdIRCServerUsersEvent OnServerUsersListReceived = {read=FOnSvrUsers, write=FOnSvrUsers};
	__property TIdIRCServerStatsEvent OnServerStatsReceived = {read=FOnSvrStats, write=FOnSvrStats};
	__property TIdIRCKnownServerNamesEvent OnKnownServersListReceived = {read=FOnKnownSvrs, write=FOnKnownSvrs};
	__property TIdIRCAdminInfoRecvEvent OnAdminInfoReceived = {read=FOnAdminInfo, write=FOnAdminInfo};
	__property TIdIRCUserInfoRecvEvent OnUserInfoReceived = {read=FOnUserInfo, write=FOnUserInfo};
	__property TIdIRCWhoEvent OnWho = {read=FOnWho, write=FOnWho};
	__property TIdIRCWhoIsEvent OnWhoIs = {read=FOnWhoIs, write=FOnWhoIs};
	__property TIdIRCWhoWasEvent OnWhoWas = {read=FOnWhoWas, write=FOnWhoWas};
	__property TIdIRCChanModeEvent OnChannelMode = {read=FOnChanMode, write=FOnChanMode};
	__property TIdIRCUserModeEvent OnUserMode = {read=FOnUserMode, write=FOnUserMode};
	__property TIdIRCCTCPQueryEvent OnCTCPQuery = {read=FOnCTCPQry, write=FOnCTCPQry};
	__property TIdIRCCTCPReplyEvent OnCTCPReply = {read=FOnCTCPRep, write=FOnCTCPRep};
	__property TIdIRCDCCChatEvent OnDCCChat = {read=FOnDCCChat, write=FOnDCCChat};
	__property TIdIRCDCCSendEvent OnDCCSend = {read=FOnDCCSend, write=FOnDCCSend};
	__property TIdIRCDCCResumeEvent OnDCCResume = {read=FOnDCCResume, write=FOnDCCResume};
	__property TIdIRCDCCAcceptEvent OnDCCAccept = {read=FOnDCCAccept, write=FOnDCCAccept};
	__property TIdIRCServerErrorEvent OnServerError = {read=FOnServerError, write=FOnServerError};
	__property TIdIRCNickErrorEvent OnNicknameError = {read=FOnNickError, write=FOnNickError};
	__property TIdIRCKillErrorEvent OnKillError = {read=FOnKillError, write=FOnKillError};
	__property TIdIRCNicknameChangedEvent OnNicknameChange = {read=FOnNickChange, write=FOnNickChange};
	__property TIdIRCKillEvent OnKill = {read=FOnKill, write=FOnKill};
	__property TIdIRCQuitEvent OnQuit = {read=FOnQuit, write=FOnQuit};
	__property TIdIRCSvrQuitEvent OnServerQuit = {read=FOnSvrQuit, write=FOnSvrQuit};
	__property TIdIRCSvrTimeEvent OnServerTime = {read=FOnSvrTime, write=FOnSvrTime};
	__property TIdIRCServiceEvent OnService = {read=FOnService, write=FOnService};
	__property TIdIRCSvrVersionEvent OnServerVersion = {read=FOnSvrVersion, write=FOnSvrVersion};
	__property TIdIRCRawEvent OnRaw = {read=FOnRaw, write=FOnRaw};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdIRC(System::Classes::TComponent* AOwner)/* overload */ : Idcmdtcpclient::TIdCmdTCPClient(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdIRC(void)/* overload */ : Idcmdtcpclient::TIdCmdTCPClient() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Connect(const System::UnicodeString AHost){ Idtcpclient::TIdTCPClientCustom::Connect(AHost); }
	inline void __fastcall  Connect(const System::UnicodeString AHost, const System::Word APort){ Idtcpclient::TIdTCPClientCustom::Connect(AHost, APort); }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idirc */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDIRC)
using namespace Idirc;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdircHPP
