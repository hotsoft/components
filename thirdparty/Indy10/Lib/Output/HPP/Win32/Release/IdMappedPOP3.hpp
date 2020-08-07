// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMappedPOP3.pas' rev: 25.00 (Windows)

#ifndef Idmappedpop3HPP
#define Idmappedpop3HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdMappedPortTCP.hpp>	// Pascal unit
#include <IdMappedTelnet.hpp>	// Pascal unit
#include <IdReplyPOP3.hpp>	// Pascal unit
#include <IdTCPServer.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdTask.hpp>	// Pascal unit
#include <IdCustomTCPServer.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmappedpop3
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdMappedPOP3Context;
class PASCALIMPLEMENTATION TIdMappedPOP3Context : public Idmappedtelnet::TIdMappedTelnetContext
{
	typedef Idmappedtelnet::TIdMappedTelnetContext inherited;
	
protected:
	System::UnicodeString FErrorMsg;
	System::UnicodeString FGreeting;
	System::UnicodeString FUserName;
	virtual void __fastcall OutboundConnect(void);
	
public:
	__property System::UnicodeString ErrorMsg = {read=FErrorMsg};
	__property System::UnicodeString Greeting = {read=FGreeting};
	__property System::UnicodeString UserName = {read=FUserName, write=FUserName};
public:
	/* TIdMappedPortContext.Create */ inline __fastcall virtual TIdMappedPOP3Context(Idtcpconnection::TIdTCPConnection* AConnection, Idyarn::TIdYarn* AYarn, Idthreadsafe::TIdThreadSafeObjectList* AList) : Idmappedtelnet::TIdMappedTelnetContext(AConnection, AYarn, AList) { }
	/* TIdMappedPortContext.Destroy */ inline __fastcall virtual ~TIdMappedPOP3Context(void) { }
	
};


class DELPHICLASS TIdMappedPOP3;
class PASCALIMPLEMENTATION TIdMappedPOP3 : public Idmappedtelnet::TIdMappedTelnet
{
	typedef Idmappedtelnet::TIdMappedTelnet inherited;
	
protected:
	Idreplypop3::TIdReplyPOP3* FReplyUnknownCommand;
	Idreplypop3::TIdReplyPOP3* FGreeting;
	System::UnicodeString FUserHostDelimiter;
	virtual void __fastcall InitComponent(void);
	void __fastcall SetGreeting(Idreplypop3::TIdReplyPOP3* AValue);
	void __fastcall SetReplyUnknownCommand(Idreplypop3::TIdReplyPOP3* const AValue);
	
public:
	__fastcall virtual ~TIdMappedPOP3(void);
	
__published:
	__property Idreplypop3::TIdReplyPOP3* Greeting = {read=FGreeting, write=SetGreeting};
	__property Idreplypop3::TIdReplyPOP3* ReplyUnknownCommand = {read=FReplyUnknownCommand, write=SetReplyUnknownCommand};
	__property DefaultPort = {default=110};
	__property MappedPort = {default=110};
	__property System::UnicodeString UserHostDelimiter = {read=FUserHostDelimiter, write=FUserHostDelimiter};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMappedPOP3(System::Classes::TComponent* AOwner)/* overload */ : Idmappedtelnet::TIdMappedTelnet(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMappedPOP3(void)/* overload */ : Idmappedtelnet::TIdMappedTelnet() { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idmappedpop3 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMAPPEDPOP3)
using namespace Idmappedpop3;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idmappedpop3HPP
