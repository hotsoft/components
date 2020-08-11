// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdReplyIMAP4.pas' rev: 25.00 (Windows)

#ifndef Idreplyimap4HPP
#define Idreplyimap4HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <IdReplyRFC.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idreplyimap4
{
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::UnicodeString, 6> Idreplyimap4__1;

class DELPHICLASS TIdReplyIMAP4;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdReplyIMAP4 : public Idreply::TIdReply
{
	typedef Idreply::TIdReply inherited;
	
protected:
	System::UnicodeString FSequenceNumber;
	System::Classes::TStrings* FExtra;
	System::Classes::TStrings* __fastcall GetExtra(void);
	virtual System::Classes::TStrings* __fastcall GetFormattedReply(void);
	virtual void __fastcall SetFormattedReply(System::Classes::TStrings* const AValue);
	virtual bool __fastcall CheckIfCodeIsValid(const System::UnicodeString ACode);
	
public:
	__fastcall virtual TIdReplyIMAP4(System::Classes::TCollection* ACollection, Idreply::TIdReplies* AReplyTexts);
	__fastcall virtual ~TIdReplyIMAP4(void);
	virtual void __fastcall Clear(void);
	virtual void __fastcall RaiseReplyError(void);
	void __fastcall DoReplyError(System::UnicodeString ADescription, System::UnicodeString AnOffendingLine = System::UnicodeString());
	void __fastcall RemoveUnsolicitedResponses(System::UnicodeString *AExpectedResponses, const int AExpectedResponses_Size);
	bool __fastcall DoesLineHaveExpectedResponse(System::UnicodeString ALine, System::UnicodeString *AExpectedResponses, const int AExpectedResponses_Size);
	bool __fastcall IsItAValidSequenceNumber(const System::UnicodeString AValue);
	bool __fastcall ParseRequest(System::UnicodeString ARequest);
	__property int NumericCode = {read=GetNumericCode, write=SetNumericCode, nodefault};
	__property System::Classes::TStrings* Extra = {read=GetExtra};
	__property System::UnicodeString SequenceNumber = {read=FSequenceNumber};
public:
	/* TIdReply.Create */ inline __fastcall virtual TIdReplyIMAP4(System::Classes::TCollection* ACollection) : Idreply::TIdReply(ACollection) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdRepliesIMAP4;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdRepliesIMAP4 : public Idreply::TIdReplies
{
	typedef Idreply::TIdReplies inherited;
	
public:
	__fastcall TIdRepliesIMAP4(System::Classes::TPersistent* AOwner);
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdRepliesIMAP4(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdReplyIMAP4Error;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdReplyIMAP4Error : public Idreply::EIdReplyError
{
	typedef Idreply::EIdReplyError inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdReplyIMAP4Error(const System::UnicodeString AMsg)/* overload */ : Idreply::EIdReplyError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdReplyIMAP4Error(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idreply::EIdReplyError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdReplyIMAP4Error(NativeUInt Ident)/* overload */ : Idreply::EIdReplyError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdReplyIMAP4Error(System::PResStringRec ResStringRec)/* overload */ : Idreply::EIdReplyError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdReplyIMAP4Error(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idreply::EIdReplyError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdReplyIMAP4Error(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idreply::EIdReplyError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdReplyIMAP4Error(const System::UnicodeString Msg, int AHelpContext) : Idreply::EIdReplyError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdReplyIMAP4Error(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idreply::EIdReplyError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdReplyIMAP4Error(NativeUInt Ident, int AHelpContext)/* overload */ : Idreply::EIdReplyError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdReplyIMAP4Error(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idreply::EIdReplyError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdReplyIMAP4Error(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idreply::EIdReplyError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdReplyIMAP4Error(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idreply::EIdReplyError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdReplyIMAP4Error(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define IMAP_OK L"OK"
#define IMAP_NO L"NO"
#define IMAP_BAD L"BAD"
#define IMAP_PREAUTH L"PREAUTH"
#define IMAP_BYE L"BYE"
static const System::WideChar IMAP_CONT = (System::WideChar)(0x2b);
extern DELPHI_PACKAGE Idreplyimap4__1 VALID_TAGGEDREPLIES;
}	/* namespace Idreplyimap4 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDREPLYIMAP4)
using namespace Idreplyimap4;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idreplyimap4HPP
