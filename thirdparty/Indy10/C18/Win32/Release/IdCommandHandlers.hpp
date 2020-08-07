// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCommandHandlers.pas' rev: 25.00 (Windows)

#ifndef IdcommandhandlersHPP
#define IdcommandhandlersHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdContext.hpp>	// Pascal unit
#include <IdReplyRFC.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcommandhandlers
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdCommand;
typedef void __fastcall (__closure *TIdCommandEvent)(TIdCommand* ASender);

class DELPHICLASS TIdCommandHandlers;
typedef void __fastcall (__closure *TIdAfterCommandHandlerEvent)(TIdCommandHandlers* ASender, Idcontext::TIdContext* AContext);

typedef void __fastcall (__closure *TIdBeforeCommandHandlerEvent)(TIdCommandHandlers* ASender, System::UnicodeString &AData, Idcontext::TIdContext* AContext);

typedef void __fastcall (__closure *TIdCommandHandlersExceptionEvent)(System::UnicodeString ACommand, Idcontext::TIdContext* AContext);

class DELPHICLASS TIdCommandHandler;
class PASCALIMPLEMENTATION TIdCommandHandler : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::WideChar FCmdDelimiter;
	System::UnicodeString FCommand;
	System::TObject* FData;
	System::Classes::TStrings* FDescription;
	bool FDisconnect;
	bool FEnabled;
	Idreply::TIdReply* FExceptionReply;
	System::UnicodeString FHelpSuperScript;
	bool FHelpVisible;
	System::UnicodeString FName;
	Idreply::TIdReply* FNormalReply;
	TIdCommandEvent FOnCommand;
	System::WideChar FParamDelimiter;
	bool FParseParams;
	Idreply::TIdReplyClass FReplyClass;
	System::Classes::TStrings* FResponse;
	int FTag;
	virtual System::UnicodeString __fastcall GetDisplayName(void);
	void __fastcall SetDescription(System::Classes::TStrings* AValue);
	void __fastcall SetExceptionReply(Idreply::TIdReply* AValue);
	void __fastcall SetNormalReply(Idreply::TIdReply* AValue);
	void __fastcall SetResponse(System::Classes::TStrings* AValue);
	
public:
	virtual bool __fastcall Check(const System::UnicodeString AData, Idcontext::TIdContext* AContext);
	virtual void __fastcall DoCommand(const System::UnicodeString AData, Idcontext::TIdContext* AContext, System::UnicodeString AUnparsedParams);
	virtual void __fastcall DoParseParams(System::UnicodeString AUnparsedParams, System::Classes::TStrings* AParams);
	__fastcall virtual TIdCommandHandler(System::Classes::TCollection* ACollection);
	__fastcall virtual ~TIdCommandHandler(void);
	bool __fastcall NameIs(const System::UnicodeString ACommand);
	__property System::TObject* Data = {read=FData, write=FData};
	
__published:
	__property System::WideChar CmdDelimiter = {read=FCmdDelimiter, write=FCmdDelimiter, nodefault};
	__property System::UnicodeString Command = {read=FCommand, write=FCommand};
	__property System::Classes::TStrings* Description = {read=FDescription, write=SetDescription};
	__property bool Disconnect = {read=FDisconnect, write=FDisconnect, nodefault};
	__property bool Enabled = {read=FEnabled, write=FEnabled, default=1};
	__property Idreply::TIdReply* ExceptionReply = {read=FExceptionReply, write=SetExceptionReply};
	__property System::UnicodeString Name = {read=FName, write=FName};
	__property Idreply::TIdReply* NormalReply = {read=FNormalReply, write=SetNormalReply};
	__property System::WideChar ParamDelimiter = {read=FParamDelimiter, write=FParamDelimiter, nodefault};
	__property bool ParseParams = {read=FParseParams, write=FParseParams, nodefault};
	__property System::Classes::TStrings* Response = {read=FResponse, write=SetResponse};
	__property int Tag = {read=FTag, write=FTag, nodefault};
	__property System::UnicodeString HelpSuperScript = {read=FHelpSuperScript, write=FHelpSuperScript};
	__property bool HelpVisible = {read=FHelpVisible, write=FHelpVisible, default=1};
	__property TIdCommandEvent OnCommand = {read=FOnCommand, write=FOnCommand};
};


typedef System::TMetaClass* TIdCommandHandlerClass;

class PASCALIMPLEMENTATION TIdCommandHandlers : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
protected:
	Idcomponent::TIdComponent* FBase;
	Idreply::TIdReply* FExceptionReply;
	TIdAfterCommandHandlerEvent FOnAfterCommandHandler;
	TIdBeforeCommandHandlerEvent FOnBeforeCommandHandler;
	TIdCommandHandlersExceptionEvent FOnCommandHandlersException;
	bool FParseParamsDef;
	bool FPerformReplies;
	Idreply::TIdReplyClass FReplyClass;
	Idreply::TIdReplies* FReplyTexts;
	void __fastcall DoAfterCommandHandler(Idcontext::TIdContext* AContext);
	void __fastcall DoBeforeCommandHandler(Idcontext::TIdContext* AContext, System::UnicodeString &VLine);
	void __fastcall DoOnCommandHandlersException(const System::UnicodeString ACommand, Idcontext::TIdContext* AContext);
	HIDESBASE TIdCommandHandler* __fastcall GetItem(int AIndex);
	HIDESBASE void __fastcall SetItem(int AIndex, TIdCommandHandler* const AValue);
	
public:
	HIDESBASE TIdCommandHandler* __fastcall Add(void);
	__fastcall TIdCommandHandlers(Idcomponent::TIdComponent* ABase, Idreply::TIdReplyClass AReplyClass, Idreply::TIdReplies* AReplyTexts, Idreply::TIdReply* AExceptionReply, TIdCommandHandlerClass ACommandHandlerClass);
	virtual bool __fastcall HandleCommand(Idcontext::TIdContext* AContext, System::UnicodeString &VCommand);
	__property Idcomponent::TIdComponent* Base = {read=FBase};
	__property TIdCommandHandler* Items[int AIndex] = {read=GetItem, write=SetItem};
	__property bool ParseParamsDefault = {read=FParseParamsDef, write=FParseParamsDef, nodefault};
	__property bool PerformReplies = {read=FPerformReplies, write=FPerformReplies, nodefault};
	__property Idreply::TIdReplyClass ReplyClass = {read=FReplyClass};
	__property Idreply::TIdReplies* ReplyTexts = {read=FReplyTexts};
	__property TIdAfterCommandHandlerEvent OnAfterCommandHandler = {read=FOnAfterCommandHandler, write=FOnAfterCommandHandler};
	__property TIdBeforeCommandHandlerEvent OnBeforeCommandHandler = {read=FOnBeforeCommandHandler, write=FOnBeforeCommandHandler};
	__property TIdCommandHandlersExceptionEvent OnCommandHandlersException = {read=FOnCommandHandlersException, write=FOnCommandHandlersException};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdCommandHandlers(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdCommand : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TIdCommandHandler* FCommandHandler;
	bool FDisconnect;
	System::Classes::TStrings* FParams;
	bool FPerformReply;
	System::UnicodeString FRawLine;
	Idreply::TIdReply* FReply;
	System::Classes::TStrings* FResponse;
	Idcontext::TIdContext* FContext;
	System::UnicodeString FUnparsedParams;
	bool FSendEmptyResponse;
	virtual void __fastcall DoCommand(void);
	void __fastcall SetReply(Idreply::TIdReply* AValue);
	void __fastcall SetResponse(System::Classes::TStrings* AValue);
	
public:
	__fastcall virtual TIdCommand(TIdCommandHandler* AOwner);
	__fastcall virtual ~TIdCommand(void);
	void __fastcall SendReply(void);
	__property TIdCommandHandler* CommandHandler = {read=FCommandHandler};
	__property bool Disconnect = {read=FDisconnect, write=FDisconnect, nodefault};
	__property bool PerformReply = {read=FPerformReply, write=FPerformReply, nodefault};
	__property System::Classes::TStrings* Params = {read=FParams};
	__property System::UnicodeString RawLine = {read=FRawLine};
	__property Idreply::TIdReply* Reply = {read=FReply, write=SetReply};
	__property System::Classes::TStrings* Response = {read=FResponse, write=SetResponse};
	__property Idcontext::TIdContext* Context = {read=FContext};
	__property System::UnicodeString UnparsedParams = {read=FUnparsedParams};
	__property bool SendEmptyResponse = {read=FSendEmptyResponse, write=FSendEmptyResponse, nodefault};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const bool IdEnabledDefault = true;
static const bool IdParseParamsDefault = true;
static const bool IdHelpVisibleDef = true;
}	/* namespace Idcommandhandlers */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCOMMANDHANDLERS)
using namespace Idcommandhandlers;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcommandhandlersHPP
