// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdReplyPOP3.pas' rev: 25.00 (Windows)

#ifndef Idreplypop3HPP
#define Idreplypop3HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idreplypop3
{
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::UnicodeString, 5> Idreplypop3__1;

class DELPHICLASS TIdReplyPOP3;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdReplyPOP3 : public Idreply::TIdReply
{
	typedef Idreply::TIdReply inherited;
	
protected:
	System::UnicodeString FEnhancedCode;
	__classmethod int __fastcall FindCodeTextDelim(const System::UnicodeString AText);
	__classmethod bool __fastcall IsValidEnhancedCode(const System::UnicodeString AText, const bool AStrict = false);
	__classmethod int __fastcall ExtractTextPosArray(const System::UnicodeString AStr);
	virtual System::Classes::TStrings* __fastcall GetFormattedReply(void);
	virtual void __fastcall SetFormattedReply(System::Classes::TStrings* const AValue);
	virtual bool __fastcall CheckIfCodeIsValid(const System::UnicodeString ACode);
	void __fastcall SetEnhancedCode(const System::UnicodeString AValue);
	
public:
	__fastcall virtual TIdReplyPOP3(System::Classes::TCollection* ACollection, Idreply::TIdReplies* AReplyTexts);
	virtual void __fastcall Assign(System::Classes::TPersistent* ASource);
	virtual void __fastcall RaiseReplyError(void);
	__classmethod virtual bool __fastcall IsEndMarker(const System::UnicodeString ALine);
	
__published:
	__property System::UnicodeString EnhancedCode = {read=FEnhancedCode, write=SetEnhancedCode};
public:
	/* TIdReply.Create */ inline __fastcall virtual TIdReplyPOP3(System::Classes::TCollection* ACollection) : Idreply::TIdReply(ACollection) { }
	/* TIdReply.Destroy */ inline __fastcall virtual ~TIdReplyPOP3(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdRepliesPOP3;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdRepliesPOP3 : public Idreply::TIdReplies
{
	typedef Idreply::TIdReplies inherited;
	
public:
	__fastcall TIdRepliesPOP3(System::Classes::TPersistent* AOwner);
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdRepliesPOP3(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdReplyPOP3Error;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdReplyPOP3Error : public Idreply::EIdReplyError
{
	typedef Idreply::EIdReplyError inherited;
	
protected:
	System::UnicodeString FErrorCode;
	System::UnicodeString FEnhancedCode;
	
public:
	__fastcall virtual EIdReplyPOP3Error(const System::UnicodeString AErrorCode, const System::UnicodeString AReplyMessage, const System::UnicodeString AEnhancedCode);
	__property System::UnicodeString ErrorCode = {read=FErrorCode};
	__property System::UnicodeString EnhancedCode = {read=FEnhancedCode};
public:
	/* EIdException.Create */ inline __fastcall virtual EIdReplyPOP3Error(const System::UnicodeString AMsg)/* overload */ : Idreply::EIdReplyError(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdReplyPOP3Error(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idreply::EIdReplyError(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdReplyPOP3Error(NativeUInt Ident)/* overload */ : Idreply::EIdReplyError(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdReplyPOP3Error(System::PResStringRec ResStringRec)/* overload */ : Idreply::EIdReplyError(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdReplyPOP3Error(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idreply::EIdReplyError(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdReplyPOP3Error(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idreply::EIdReplyError(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdReplyPOP3Error(const System::UnicodeString Msg, int AHelpContext) : Idreply::EIdReplyError(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdReplyPOP3Error(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idreply::EIdReplyError(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdReplyPOP3Error(NativeUInt Ident, int AHelpContext)/* overload */ : Idreply::EIdReplyError(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdReplyPOP3Error(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idreply::EIdReplyError(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdReplyPOP3Error(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idreply::EIdReplyError(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdReplyPOP3Error(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idreply::EIdReplyError(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdReplyPOP3Error(void) { }
	
};

#pragma pack(pop)

typedef System::StaticArray<System::UnicodeString, 3> Idreplypop3__5;

class DELPHICLASS EIdPOP3ReplyException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdPOP3ReplyException : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdPOP3ReplyException(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdPOP3ReplyException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdPOP3ReplyException(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdPOP3ReplyException(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPOP3ReplyException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPOP3ReplyException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdPOP3ReplyException(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdPOP3ReplyException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPOP3ReplyException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPOP3ReplyException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPOP3ReplyException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPOP3ReplyException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdPOP3ReplyException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdPOP3ReplyInvalidEnhancedCode;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdPOP3ReplyInvalidEnhancedCode : public EIdPOP3ReplyException
{
	typedef EIdPOP3ReplyException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdPOP3ReplyInvalidEnhancedCode(const System::UnicodeString AMsg)/* overload */ : EIdPOP3ReplyException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdPOP3ReplyInvalidEnhancedCode(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdPOP3ReplyException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdPOP3ReplyInvalidEnhancedCode(NativeUInt Ident)/* overload */ : EIdPOP3ReplyException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdPOP3ReplyInvalidEnhancedCode(System::PResStringRec ResStringRec)/* overload */ : EIdPOP3ReplyException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPOP3ReplyInvalidEnhancedCode(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdPOP3ReplyException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdPOP3ReplyInvalidEnhancedCode(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdPOP3ReplyException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdPOP3ReplyInvalidEnhancedCode(const System::UnicodeString Msg, int AHelpContext) : EIdPOP3ReplyException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdPOP3ReplyInvalidEnhancedCode(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdPOP3ReplyException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPOP3ReplyInvalidEnhancedCode(NativeUInt Ident, int AHelpContext)/* overload */ : EIdPOP3ReplyException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdPOP3ReplyInvalidEnhancedCode(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdPOP3ReplyException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPOP3ReplyInvalidEnhancedCode(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdPOP3ReplyException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdPOP3ReplyInvalidEnhancedCode(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdPOP3ReplyException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdPOP3ReplyInvalidEnhancedCode(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
#define ST_OK L"+OK"
#define ST_ERR L"-ERR"
static const System::WideChar ST_SASLCONTINUE = (System::WideChar)(0x2b);
#define ST_ERR_IN_USE L"IN-USE"
#define ST_ERR_LOGIN_DELAY L"LOGIN-DELAY"
#define ST_ERR_SYS_TEMP L"SYS/PERM"
#define ST_ERR_SYS_PERM L"SYS/TEMP"
#define ST_ERR_AUTH L"AUTH"
extern DELPHI_PACKAGE Idreplypop3__1 VALID_ENH_CODES;
extern DELPHI_PACKAGE Idreplypop3__5 VALID_POP3_STR;
}	/* namespace Idreplypop3 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDREPLYPOP3)
using namespace Idreplypop3;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idreplypop3HPP
