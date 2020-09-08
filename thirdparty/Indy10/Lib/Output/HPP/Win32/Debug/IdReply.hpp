// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdReply.pas' rev: 25.00 (Windows)

#ifndef IdreplyHPP
#define IdreplyHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idreply
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdReply;
class DELPHICLASS TIdReplies;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdReply : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::UnicodeString FCode;
	System::Classes::TStrings* FFormattedReply;
	TIdReplies* FReplyTexts;
	System::Classes::TStrings* FText;
	virtual void __fastcall AssignTo(System::Classes::TPersistent* ADest);
	void __fastcall CommonInit(void);
	virtual System::Classes::TStrings* __fastcall GetFormattedReplyStrings(void);
	virtual bool __fastcall CheckIfCodeIsValid(const System::UnicodeString ACode);
	virtual System::UnicodeString __fastcall GetDisplayName(void);
	virtual System::Classes::TStrings* __fastcall GetFormattedReply(void);
	int __fastcall GetNumericCode(void);
	void __fastcall SetCode(const System::UnicodeString AValue);
	virtual void __fastcall SetFormattedReply(System::Classes::TStrings* const AValue) = 0 ;
	void __fastcall SetText(System::Classes::TStrings* const AValue);
	void __fastcall SetNumericCode(const int AValue);
	
public:
	virtual void __fastcall Clear(void);
	__fastcall virtual TIdReply(System::Classes::TCollection* ACollection);
	__fastcall virtual TIdReply(System::Classes::TCollection* ACollection, TIdReplies* AReplyTexts);
	__fastcall virtual ~TIdReply(void);
	__classmethod virtual bool __fastcall IsEndMarker(const System::UnicodeString ALine);
	virtual void __fastcall RaiseReplyError(void) = 0 ;
	virtual bool __fastcall ReplyExists(void);
	virtual void __fastcall SetReply(const int ACode, const System::UnicodeString AText)/* overload */;
	virtual void __fastcall SetReply(const System::UnicodeString ACode, const System::UnicodeString AText)/* overload */;
	void __fastcall UpdateText(void);
	__property System::Classes::TStrings* FormattedReply = {read=GetFormattedReply, write=SetFormattedReply};
	__property int NumericCode = {read=GetNumericCode, write=SetNumericCode, nodefault};
	
__published:
	__property System::UnicodeString Code = {read=FCode, write=SetCode};
	__property System::Classes::TStrings* Text = {read=FText, write=SetText};
};

#pragma pack(pop)

typedef System::TMetaClass* TIdReplyClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdReplies : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TIdReply* operator[](int Index) { return Items[Index]; }
	
protected:
	HIDESBASE TIdReply* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TIdReply* const Value);
	
public:
	HIDESBASE TIdReply* __fastcall Add(void)/* overload */;
	HIDESBASE TIdReply* __fastcall Add(const int ACode, const System::UnicodeString AText)/* overload */;
	HIDESBASE TIdReply* __fastcall Add(const System::UnicodeString ACode, const System::UnicodeString AText)/* overload */;
	__fastcall virtual TIdReplies(System::Classes::TPersistent* AOwner, const TIdReplyClass AReplyClass);
	virtual TIdReply* __fastcall Find(const System::UnicodeString ACode, TIdReply* AIgnore = (TIdReply*)(0x0));
	virtual void __fastcall UpdateText(TIdReply* AReply);
	__property TIdReply* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdReplies(void) { }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TIdRepliesClass;

class DELPHICLASS EIdReplyError;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdReplyError : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdReplyError(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdReplyError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdReplyError(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdReplyError(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdReplyError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdReplyError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdReplyError(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdReplyError(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdReplyError(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdReplyError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdReplyError(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdReplyError(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdReplyError(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idreply */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDREPLY)
using namespace Idreply;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdreplyHPP
