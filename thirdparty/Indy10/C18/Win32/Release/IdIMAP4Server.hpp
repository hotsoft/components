// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIMAP4Server.pas' rev: 25.00 (Windows)

#ifndef Idimap4serverHPP
#define Idimap4serverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdCmdTCPServer.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdCommandHandlers.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdExplicitTLSClientServerBase.hpp>	// Pascal unit
#include <IdIMAP4.hpp>	// Pascal unit
#include <IdMailBox.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <IdReplyIMAP4.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit
#include <IdYarn.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdTask.hpp>	// Pascal unit
#include <IdThreadSafe.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idimap4server
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TIMAP4CommandEvent)(Idcontext::TIdContext* AContext, const System::UnicodeString ATag, const System::UnicodeString ACmd);

typedef void __fastcall (__closure *TIdIMAP4CommandBeforeEvent)(Idcommandhandlers::TIdCommandHandlers* ASender, System::UnicodeString &AData, Idcontext::TIdContext* AContext);

typedef void __fastcall (__closure *TIdIMAP4CommandBeforeSendEvent)(Idcontext::TIdContext* AContext, System::UnicodeString AData);

typedef bool __fastcall (__closure *TIdIMAP4DefMech1)(System::UnicodeString ALoginName, System::UnicodeString AMailbox);

typedef bool __fastcall (__closure *TIdIMAP4DefMech2)(System::UnicodeString ALoginName, System::UnicodeString AMailBoxName, Idmailbox::TIdMailBox* AMailBox);

typedef System::UnicodeString __fastcall (__closure *TIdIMAP4DefMech3)(System::UnicodeString ALoginName, System::UnicodeString AMailbox);

typedef bool __fastcall (__closure *TIdIMAP4DefMech4)(System::UnicodeString ALoginName, System::UnicodeString AOldMailboxName, System::UnicodeString ANewMailboxName);

typedef bool __fastcall (__closure *TIdIMAP4DefMech5)(System::UnicodeString ALoginName, System::UnicodeString AMailBoxName, System::Classes::TStrings* AMailBoxNames, System::Classes::TStrings* AMailBoxFlags);

typedef bool __fastcall (__closure *TIdIMAP4DefMech6)(System::UnicodeString ALoginName, System::UnicodeString AMailbox, Idmessage::TIdMessage* AMessage);

typedef bool __fastcall (__closure *TIdIMAP4DefMech7)(System::UnicodeString ALoginName, System::UnicodeString ASourceMailBox, System::UnicodeString AMessageUID, System::UnicodeString ADestinationMailbox);

typedef __int64 __fastcall (__closure *TIdIMAP4DefMech8)(System::UnicodeString ALoginName, System::UnicodeString AMailbox, Idmessage::TIdMessage* AMessage);

typedef bool __fastcall (__closure *TIdIMAP4DefMech9)(System::UnicodeString ALoginName, System::UnicodeString AMailbox, Idmessage::TIdMessage* AMessage, Idmessage::TIdMessage* ATargetMessage);

typedef bool __fastcall (__closure *TIdIMAP4DefMech10)(System::UnicodeString ALoginName, System::UnicodeString AMailbox, Idmessage::TIdMessage* AMessage, System::Classes::TStrings* ALines);

typedef bool __fastcall (__closure *TIdIMAP4DefMech11)(Idcommandhandlers::TIdCommand* ASender, bool AReadOnly);

typedef bool __fastcall (__closure *TIdIMAP4DefMech12)(System::Classes::TStrings* AParams, int AMailBoxParam);

typedef bool __fastcall (__closure *TIdIMAP4DefMech13)(System::UnicodeString ALoginName, System::UnicodeString AMailBoxName, System::UnicodeString ANewUIDNext);

typedef System::UnicodeString __fastcall (__closure *TIdIMAP4DefMech14)(System::UnicodeString ALoginName, System::UnicodeString AMailBoxName, System::UnicodeString AUID);

class DELPHICLASS EIdIMAP4ServerException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIMAP4ServerException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIMAP4ServerException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIMAP4ServerException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIMAP4ServerException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIMAP4ServerException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIMAP4ServerException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIMAP4ServerException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIMAP4ServerException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIMAP4ServerException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIMAP4ServerException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIMAP4ServerException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIMAP4ServerException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIMAP4ServerException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIMAP4ServerException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdIMAP4ImplicitTLSRequiresSSL;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdIMAP4ImplicitTLSRequiresSSL : public EIdIMAP4ServerException
{
	typedef EIdIMAP4ServerException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdIMAP4ImplicitTLSRequiresSSL(const System::UnicodeString AMsg)/* overload */ : EIdIMAP4ServerException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdIMAP4ImplicitTLSRequiresSSL(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdIMAP4ServerException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdIMAP4ImplicitTLSRequiresSSL(NativeUInt Ident)/* overload */ : EIdIMAP4ServerException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdIMAP4ImplicitTLSRequiresSSL(System::PResStringRec ResStringRec)/* overload */ : EIdIMAP4ServerException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIMAP4ImplicitTLSRequiresSSL(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIMAP4ServerException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdIMAP4ImplicitTLSRequiresSSL(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdIMAP4ServerException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdIMAP4ImplicitTLSRequiresSSL(const System::UnicodeString Msg, int AHelpContext) : EIdIMAP4ServerException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdIMAP4ImplicitTLSRequiresSSL(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdIMAP4ServerException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIMAP4ImplicitTLSRequiresSSL(NativeUInt Ident, int AHelpContext)/* overload */ : EIdIMAP4ServerException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdIMAP4ImplicitTLSRequiresSSL(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdIMAP4ServerException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIMAP4ImplicitTLSRequiresSSL(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIMAP4ServerException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdIMAP4ImplicitTLSRequiresSSL(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdIMAP4ServerException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdIMAP4ImplicitTLSRequiresSSL(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdIMAP4PeerContext;
class PASCALIMPLEMENTATION TIdIMAP4PeerContext : public Idcustomtcpserver::TIdServerContext
{
	typedef Idcustomtcpserver::TIdServerContext inherited;
	
protected:
	Idimap4::TIdIMAP4ConnectionState FConnectionState;
	System::UnicodeString FLoginName;
	Idmailbox::TIdMailBox* FMailBox;
	System::UnicodeString FIMAP4Tag;
	Idreplyimap4::TIdReplyIMAP4* FLastCommand;
	bool __fastcall GetUsingTLS(void);
	
public:
	__fastcall virtual TIdIMAP4PeerContext(Idtcpconnection::TIdTCPConnection* AConnection, Idyarn::TIdYarn* AYarn, Idthreadsafe::TIdThreadSafeObjectList* AList);
	__fastcall virtual ~TIdIMAP4PeerContext(void);
	__property Idimap4::TIdIMAP4ConnectionState ConnectionState = {read=FConnectionState, nodefault};
	__property bool UsingTLS = {read=GetUsingTLS, nodefault};
	__property System::UnicodeString IMAP4Tag = {read=FIMAP4Tag};
	__property Idmailbox::TIdMailBox* MailBox = {read=FMailBox};
	__property System::UnicodeString LoginName = {read=FLoginName, write=FLoginName};
};


class DELPHICLASS TIdIMAP4Server;
class PASCALIMPLEMENTATION TIdIMAP4Server : public Idexplicittlsclientserverbase::TIdExplicitTLSServer
{
	typedef Idexplicittlsclientserverbase::TIdExplicitTLSServer inherited;
	
protected:
	bool FSaferMode;
	bool FUseDefaultMechanismsForUnassignedCommands;
	System::UnicodeString FRootPath;
	System::UnicodeString FDefaultPassword;
	System::WideChar FMailBoxSeparator;
	TIdIMAP4DefMech1 fOnDefMechDoesImapMailBoxExist;
	TIdIMAP4DefMech1 fOnDefMechCreateMailBox;
	TIdIMAP4DefMech1 fOnDefMechDeleteMailBox;
	TIdIMAP4DefMech1 fOnDefMechIsMailBoxOpen;
	TIdIMAP4DefMech2 fOnDefMechSetupMailbox;
	TIdIMAP4DefMech3 fOnDefMechNameAndMailBoxToPath;
	TIdIMAP4DefMech3 fOnDefMechGetNextFreeUID;
	TIdIMAP4DefMech4 fOnDefMechRenameMailBox;
	TIdIMAP4DefMech5 fOnDefMechListMailBox;
	TIdIMAP4DefMech6 fOnDefMechDeleteMessage;
	TIdIMAP4DefMech7 fOnDefMechCopyMessage;
	TIdIMAP4DefMech8 fOnDefMechGetMessageSize;
	TIdIMAP4DefMech9 fOnDefMechGetMessageHeader;
	TIdIMAP4DefMech10 fOnDefMechGetMessageRaw;
	TIdIMAP4DefMech11 fOnDefMechOpenMailBox;
	TIdIMAP4DefMech12 fOnDefMechReinterpretParamAsMailBox;
	TIdIMAP4DefMech13 fOnDefMechUpdateNextFreeUID;
	TIdIMAP4DefMech14 fOnDefMechGetFileNameToWriteAppendMessage;
	TIdIMAP4CommandBeforeEvent fOnBeforeCmd;
	TIdIMAP4CommandBeforeSendEvent fOnBeforeSend;
	TIMAP4CommandEvent fOnCommandCAPABILITY;
	TIMAP4CommandEvent fONCommandNOOP;
	TIMAP4CommandEvent fONCommandLOGOUT;
	TIMAP4CommandEvent fONCommandAUTHENTICATE;
	TIMAP4CommandEvent fONCommandLOGIN;
	TIMAP4CommandEvent fONCommandSELECT;
	TIMAP4CommandEvent fONCommandEXAMINE;
	TIMAP4CommandEvent fONCommandCREATE;
	TIMAP4CommandEvent fONCommandDELETE;
	TIMAP4CommandEvent fONCommandRENAME;
	TIMAP4CommandEvent fONCommandSUBSCRIBE;
	TIMAP4CommandEvent fONCommandUNSUBSCRIBE;
	TIMAP4CommandEvent fONCommandLIST;
	TIMAP4CommandEvent fONCommandLSUB;
	TIMAP4CommandEvent fONCommandSTATUS;
	TIMAP4CommandEvent fONCommandAPPEND;
	TIMAP4CommandEvent fONCommandCHECK;
	TIMAP4CommandEvent fONCommandCLOSE;
	TIMAP4CommandEvent fONCommandEXPUNGE;
	TIMAP4CommandEvent fONCommandSEARCH;
	TIMAP4CommandEvent fONCommandFETCH;
	TIMAP4CommandEvent fONCommandSTORE;
	TIMAP4CommandEvent fONCommandCOPY;
	TIMAP4CommandEvent fONCommandUID;
	TIMAP4CommandEvent fONCommandX;
	TIMAP4CommandEvent fOnCommandError;
	virtual Idreply::TIdReply* __fastcall CreateExceptionReply(void);
	virtual Idreply::TIdReply* __fastcall CreateGreeting(void);
	virtual Idreply::TIdReply* __fastcall CreateHelpReply(void);
	virtual Idreply::TIdReply* __fastcall CreateMaxConnectionReply(void);
	virtual Idreply::TIdReply* __fastcall CreateReplyUnknownCommand(void);
	virtual void __fastcall InitializeCommandHandlers(void);
	virtual Idreply::TIdReplyClass __fastcall GetReplyClass(void);
	virtual Idreply::TIdRepliesClass __fastcall GetRepliesClass(void);
	virtual void __fastcall SendGreeting(Idcontext::TIdContext* AContext, Idreply::TIdReply* AGreeting);
	void __fastcall SendWrongConnectionState(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall SendUnsupportedCommand(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall SendIncorrectNumberOfParameters(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall SendUnassignedDefaultMechanism(Idcommandhandlers::TIdCommand* ASender);
	virtual void __fastcall DoReplyUnknownCommand(Idcontext::TIdContext* AContext, System::UnicodeString AText);
	void __fastcall SendErrorOpenedReadOnly(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall SendOkReply(Idcommandhandlers::TIdCommand* ASender, const System::UnicodeString AText);
	void __fastcall SendBadReply(Idcommandhandlers::TIdCommand* ASender, const System::UnicodeString AText)/* overload */;
	void __fastcall SendBadReply(Idcommandhandlers::TIdCommand* ASender, const System::UnicodeString AFormat, System::TVarRec const *Args, const int Args_Size)/* overload */;
	void __fastcall SendNoReply(Idcommandhandlers::TIdCommand* ASender, const System::UnicodeString AText = System::UnicodeString())/* overload */;
	void __fastcall SendNoReply(Idcommandhandlers::TIdCommand* ASender, const System::UnicodeString AFormat, System::TVarRec const *Args, const int Args_Size)/* overload */;
	bool __fastcall ExpungeRecords(Idcommandhandlers::TIdCommand* ASender);
	bool __fastcall MessageSetToMessageNumbers(bool AUseUID, Idcommandhandlers::TIdCommand* ASender, System::Classes::TStrings* AMessageNumbers, System::UnicodeString AMessageSet);
	__int64 __fastcall GetRecordForUID(const System::UnicodeString AUID, Idmailbox::TIdMailBox* AMailBox);
	void __fastcall ProcessFetch(bool AUseUID, Idcommandhandlers::TIdCommand* ASender, System::Classes::TStrings* AParams);
	void __fastcall ProcessCopy(bool AUseUID, Idcommandhandlers::TIdCommand* ASender, System::Classes::TStrings* AParams);
	bool __fastcall ProcessStore(bool AUseUID, Idcommandhandlers::TIdCommand* ASender, System::Classes::TStrings* AParams);
	void __fastcall ProcessSearch(bool AUseUID, Idcommandhandlers::TIdCommand* ASender, System::Classes::TStrings* AParams);
	bool __fastcall FlagStringToFlagList(System::Classes::TStrings* AFlagList, System::UnicodeString AFlagString);
	System::UnicodeString __fastcall StripQuotesIfNecessary(System::UnicodeString AName);
	bool __fastcall ReassembleParams(System::WideChar ASeparator, System::Classes::TStrings* AParams, int AParamToReassemble);
	bool __fastcall ReinterpretParamAsMailBox(System::Classes::TStrings* AParams, int AMailBoxParam);
	bool __fastcall ReinterpretParamAsFlags(System::Classes::TStrings* AParams, int AFlagsParam);
	bool __fastcall ReinterpretParamAsQuotedStr(System::Classes::TStrings* AParams, int AFlagsParam);
	bool __fastcall ReinterpretParamAsDataItems(System::Classes::TStrings* AParams, int AFlagsParam);
	System::UnicodeString __fastcall MessageFlagSetToStr(const Idmessage::TIdMessageFlagsSet AFlags);
	void __fastcall DoBeforeCmd(Idcommandhandlers::TIdCommandHandlers* ASender, System::UnicodeString &AData, Idcontext::TIdContext* AContext);
	void __fastcall DoSendReply(Idcontext::TIdContext* AContext, const System::UnicodeString AData)/* overload */;
	void __fastcall DoSendReply(Idcontext::TIdContext* AContext, const System::UnicodeString AFormat, System::TVarRec const *Args, const int Args_Size)/* overload */;
	void __fastcall DoCmdHandlersException(System::UnicodeString ACommand, Idcontext::TIdContext* AContext);
	void __fastcall DoCommandCAPABILITY(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandNOOP(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandLOGOUT(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandAUTHENTICATE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandLOGIN(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandSELECT(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandEXAMINE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandCREATE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandDELETE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandRENAME(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandSUBSCRIBE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandUNSUBSCRIBE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandLIST(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandLSUB(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandSTATUS(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandAPPEND(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandCHECK(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandCLOSE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandEXPUNGE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandSEARCH(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandFETCH(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandSTORE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandCOPY(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandUID(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandX(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoCommandSTARTTLS(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall MustUseTLS(Idcommandhandlers::TIdCommand* ASender);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdIMAP4Server(System::Classes::TComponent* AOwner)/* overload */;
	__fastcall virtual ~TIdIMAP4Server(void);
	
__published:
	__property DefaultPort = {default=143};
	__property bool SaferMode = {read=FSaferMode, write=FSaferMode, default=0};
	__property bool UseDefaultMechanismsForUnassignedCommands = {read=FUseDefaultMechanismsForUnassignedCommands, write=FUseDefaultMechanismsForUnassignedCommands, default=1};
	__property System::UnicodeString RootPath = {read=FRootPath, write=FRootPath};
	__property System::UnicodeString DefaultPassword = {read=FDefaultPassword, write=FDefaultPassword};
	__property System::WideChar MailBoxSeparator = {read=FMailBoxSeparator, nodefault};
	__property TIdIMAP4DefMech1 OnDefMechDoesImapMailBoxExist = {read=fOnDefMechDoesImapMailBoxExist, write=fOnDefMechDoesImapMailBoxExist};
	__property TIdIMAP4DefMech1 OnDefMechCreateMailBox = {read=fOnDefMechCreateMailBox, write=fOnDefMechCreateMailBox};
	__property TIdIMAP4DefMech1 OnDefMechDeleteMailBox = {read=fOnDefMechDeleteMailBox, write=fOnDefMechDeleteMailBox};
	__property TIdIMAP4DefMech1 OnDefMechIsMailBoxOpen = {read=fOnDefMechIsMailBoxOpen, write=fOnDefMechIsMailBoxOpen};
	__property TIdIMAP4DefMech2 OnDefMechSetupMailbox = {read=fOnDefMechSetupMailbox, write=fOnDefMechSetupMailbox};
	__property TIdIMAP4DefMech3 OnDefMechNameAndMailBoxToPath = {read=fOnDefMechNameAndMailBoxToPath, write=fOnDefMechNameAndMailBoxToPath};
	__property TIdIMAP4DefMech3 OnDefMechGetNextFreeUID = {read=fOnDefMechGetNextFreeUID, write=fOnDefMechGetNextFreeUID};
	__property TIdIMAP4DefMech4 OnDefMechRenameMailBox = {read=fOnDefMechRenameMailBox, write=fOnDefMechRenameMailBox};
	__property TIdIMAP4DefMech5 OnDefMechListMailBox = {read=fOnDefMechListMailBox, write=fOnDefMechListMailBox};
	__property TIdIMAP4DefMech6 OnDefMechDeleteMessage = {read=fOnDefMechDeleteMessage, write=fOnDefMechDeleteMessage};
	__property TIdIMAP4DefMech7 OnDefMechCopyMessage = {read=fOnDefMechCopyMessage, write=fOnDefMechCopyMessage};
	__property TIdIMAP4DefMech8 OnDefMechGetMessageSize = {read=fOnDefMechGetMessageSize, write=fOnDefMechGetMessageSize};
	__property TIdIMAP4DefMech9 OnDefMechGetMessageHeader = {read=fOnDefMechGetMessageHeader, write=fOnDefMechGetMessageHeader};
	__property TIdIMAP4DefMech10 OnDefMechGetMessageRaw = {read=fOnDefMechGetMessageRaw, write=fOnDefMechGetMessageRaw};
	__property TIdIMAP4DefMech11 OnDefMechOpenMailBox = {read=fOnDefMechOpenMailBox, write=fOnDefMechOpenMailBox};
	__property TIdIMAP4DefMech12 OnDefMechReinterpretParamAsMailBox = {read=fOnDefMechReinterpretParamAsMailBox, write=fOnDefMechReinterpretParamAsMailBox};
	__property TIdIMAP4DefMech13 OnDefMechUpdateNextFreeUID = {read=fOnDefMechUpdateNextFreeUID, write=fOnDefMechUpdateNextFreeUID};
	__property TIdIMAP4DefMech14 OnDefMechGetFileNameToWriteAppendMessage = {read=fOnDefMechGetFileNameToWriteAppendMessage, write=fOnDefMechGetFileNameToWriteAppendMessage};
	__property TIdIMAP4CommandBeforeEvent OnBeforeCmd = {read=fOnBeforeCmd, write=fOnBeforeCmd};
	__property TIdIMAP4CommandBeforeSendEvent OnBeforeSend = {read=fOnBeforeSend, write=fOnBeforeSend};
	__property TIMAP4CommandEvent OnCommandCAPABILITY = {read=fOnCommandCAPABILITY, write=fOnCommandCAPABILITY};
	__property TIMAP4CommandEvent OnCommandNOOP = {read=fONCommandNOOP, write=fONCommandNOOP};
	__property TIMAP4CommandEvent OnCommandLOGOUT = {read=fONCommandLOGOUT, write=fONCommandLOGOUT};
	__property TIMAP4CommandEvent OnCommandAUTHENTICATE = {read=fONCommandAUTHENTICATE, write=fONCommandAUTHENTICATE};
	__property TIMAP4CommandEvent OnCommandLOGIN = {read=fONCommandLOGIN, write=fONCommandLOGIN};
	__property TIMAP4CommandEvent OnCommandSELECT = {read=fONCommandSELECT, write=fONCommandSELECT};
	__property TIMAP4CommandEvent OnCommandEXAMINE = {read=fONCommandEXAMINE, write=fONCommandEXAMINE};
	__property TIMAP4CommandEvent OnCommandCREATE = {read=fONCommandCREATE, write=fONCommandCREATE};
	__property TIMAP4CommandEvent OnCommandDELETE = {read=fONCommandDELETE, write=fONCommandDELETE};
	__property TIMAP4CommandEvent OnCommandRENAME = {read=fONCommandRENAME, write=fONCommandRENAME};
	__property TIMAP4CommandEvent OnCommandSUBSCRIBE = {read=fONCommandSUBSCRIBE, write=fONCommandSUBSCRIBE};
	__property TIMAP4CommandEvent OnCommandUNSUBSCRIBE = {read=fONCommandUNSUBSCRIBE, write=fONCommandUNSUBSCRIBE};
	__property TIMAP4CommandEvent OnCommandLIST = {read=fONCommandLIST, write=fONCommandLIST};
	__property TIMAP4CommandEvent OnCommandLSUB = {read=fONCommandLSUB, write=fONCommandLSUB};
	__property TIMAP4CommandEvent OnCommandSTATUS = {read=fONCommandSTATUS, write=fONCommandSTATUS};
	__property TIMAP4CommandEvent OnCommandAPPEND = {read=fONCommandAPPEND, write=fONCommandAPPEND};
	__property TIMAP4CommandEvent OnCommandCHECK = {read=fONCommandCHECK, write=fONCommandCHECK};
	__property TIMAP4CommandEvent OnCommandCLOSE = {read=fONCommandCLOSE, write=fONCommandCLOSE};
	__property TIMAP4CommandEvent OnCommandEXPUNGE = {read=fONCommandEXPUNGE, write=fONCommandEXPUNGE};
	__property TIMAP4CommandEvent OnCommandSEARCH = {read=fONCommandSEARCH, write=fONCommandSEARCH};
	__property TIMAP4CommandEvent OnCommandFETCH = {read=fONCommandFETCH, write=fONCommandFETCH};
	__property TIMAP4CommandEvent OnCommandSTORE = {read=fONCommandSTORE, write=fONCommandSTORE};
	__property TIMAP4CommandEvent OnCommandCOPY = {read=fONCommandCOPY, write=fONCommandCOPY};
	__property TIMAP4CommandEvent OnCommandUID = {read=fONCommandUID, write=fONCommandUID};
	__property TIMAP4CommandEvent OnCommandX = {read=fONCommandX, write=fONCommandX};
	__property TIMAP4CommandEvent OnCommandError = {read=fOnCommandError, write=fOnCommandError};
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdIMAP4Server(void)/* overload */ : Idexplicittlsclientserverbase::TIdExplicitTLSServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const bool DEF_IMAP4_IMPLICIT_TLS = false;
}	/* namespace Idimap4server */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDIMAP4SERVER)
using namespace Idimap4server;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idimap4serverHPP
