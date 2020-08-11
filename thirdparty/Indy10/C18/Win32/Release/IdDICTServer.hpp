// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdDICTServer.pas' rev: 25.00 (Windows)

#ifndef IddictserverHPP
#define IddictserverHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdGlobalProtocols.hpp>	// Pascal unit
#include <IdResourceStringsProtocols.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdCommandHandlers.hpp>	// Pascal unit
#include <IdCmdTCPServer.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Iddictserver
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TIdDICTGetEvent)(Idcommandhandlers::TIdCommand* AContext);

typedef void __fastcall (__closure *TIdDICTOtherEvent)(Idcommandhandlers::TIdCommand* AContext, System::UnicodeString Command, System::UnicodeString Parm);

typedef void __fastcall (__closure *TIdDICTDefineEvent)(Idcommandhandlers::TIdCommand* AContext, System::UnicodeString Database, System::UnicodeString WordToFind);

typedef void __fastcall (__closure *TIdDICTMatchEvent)(Idcommandhandlers::TIdCommand* AContext, System::UnicodeString Database, System::UnicodeString Strategy, System::UnicodeString WordToFind);

typedef void __fastcall (__closure *TIdDICTShowEvent)(Idcommandhandlers::TIdCommand* AContext, System::UnicodeString Command);

typedef void __fastcall (__closure *TIdDICTAuthEvent)(Idcommandhandlers::TIdCommand* AContext, System::UnicodeString Username, System::UnicodeString authstring);

class DELPHICLASS TIdDICTServer;
class PASCALIMPLEMENTATION TIdDICTServer : public Idcmdtcpserver::TIdCmdTCPServer
{
	typedef Idcmdtcpserver::TIdCmdTCPServer inherited;
	
protected:
	TIdDICTGetEvent fOnCommandHELP;
	TIdDICTDefineEvent fOnCommandDEFINE;
	TIdDICTMatchEvent fOnCommandMATCH;
	TIdDICTGetEvent fOnCommandQUIT;
	TIdDICTShowEvent fOnCommandSHOW;
	TIdDICTAuthEvent fOnCommandAUTH;
	TIdDICTAuthEvent fOnCommandSASLAuth;
	TIdDICTOtherEvent fOnCommandOption;
	TIdDICTGetEvent fOnCommandSTAT;
	TIdDICTShowEvent fOnCommandCLIENT;
	TIdDICTOtherEvent fOnCommandOther;
	void __fastcall DoOnCommandHELP(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoOnCommandDEFINE(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoOnCommandMATCH(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoOnCommandQUIT(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoOnCommandSHOW(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoOnCommandAUTH(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoOnCommandSASLAuth(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoOnCommandOption(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoOnCommandSTAT(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoOnCommandCLIENT(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoOnCommandOther(Idcommandhandlers::TIdCommand* ASender);
	void __fastcall DoOnCommandNotHandled(Idcommandhandlers::TIdCommandHandler* ASender, Idcommandhandlers::TIdCommand* ACommand, const System::UnicodeString AData, const System::UnicodeString AMessage);
	virtual void __fastcall InitializeCommandHandlers(void);
	virtual void __fastcall InitComponent(void);
	
__published:
	__property DefaultPort = {default=2628};
	__property TIdDICTGetEvent OnCommandHelp = {read=fOnCommandHELP, write=fOnCommandHELP};
	__property TIdDICTDefineEvent OnCommandDefine = {read=fOnCommandDEFINE, write=fOnCommandDEFINE};
	__property TIdDICTMatchEvent OnCommandMatch = {read=fOnCommandMATCH, write=fOnCommandMATCH};
	__property TIdDICTGetEvent OnCommandQuit = {read=fOnCommandQUIT, write=fOnCommandQUIT};
	__property TIdDICTShowEvent OnCommandShow = {read=fOnCommandSHOW, write=fOnCommandSHOW};
	__property TIdDICTAuthEvent OnCommandAuth = {read=fOnCommandAUTH, write=fOnCommandAUTH};
	__property TIdDICTAuthEvent OnCommandSASLAuth = {read=fOnCommandSASLAuth, write=fOnCommandSASLAuth};
	__property TIdDICTOtherEvent OnCommandOption = {read=fOnCommandOption, write=fOnCommandOption};
	__property TIdDICTGetEvent OnCommandStatus = {read=fOnCommandSTAT, write=fOnCommandSTAT};
	__property TIdDICTShowEvent OnCommandClient = {read=fOnCommandCLIENT, write=fOnCommandCLIENT};
	__property TIdDICTOtherEvent OnCommandOther = {read=fOnCommandOther, write=fOnCommandOther};
public:
	/* TIdCmdTCPServer.Destroy */ inline __fastcall virtual ~TIdDICTServer(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdDICTServer(System::Classes::TComponent* AOwner)/* overload */ : Idcmdtcpserver::TIdCmdTCPServer(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdDICTServer(void)/* overload */ : Idcmdtcpserver::TIdCmdTCPServer() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Iddictserver */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDDICTSERVER)
using namespace Iddictserver;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IddictserverHPP
