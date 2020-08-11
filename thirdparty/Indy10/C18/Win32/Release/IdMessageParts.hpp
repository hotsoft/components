// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMessageParts.pas' rev: 25.00 (Windows)

#ifndef IdmessagepartsHPP
#define IdmessagepartsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdHeaderList.hpp>	// Pascal unit
#include <IdExceptionCore.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmessageparts
{
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TOnGetMessagePartStream)(System::Classes::TStream* AStream);

enum DECLSPEC_DENUM TIdMessagePartType : unsigned char { mptText, mptAttachment };

class DELPHICLASS TIdMessagePart;
class DELPHICLASS TIdMessageParts;
class PASCALIMPLEMENTATION TIdMessagePart : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::UnicodeString FContentMD5;
	System::UnicodeString FCharSet;
	System::UnicodeString FEndBoundary;
	Idheaderlist::TIdHeaderList* FExtraHeaders;
	System::UnicodeString FFileName;
	System::UnicodeString FName;
	Idheaderlist::TIdHeaderList* FHeaders;
	bool FIsEncoded;
	TOnGetMessagePartStream FOnGetMessagePartStream;
	int FParentPart;
	virtual System::UnicodeString __fastcall GetContentDisposition(void);
	virtual System::UnicodeString __fastcall GetContentType(void);
	virtual System::UnicodeString __fastcall GetContentTransfer(void);
	virtual System::UnicodeString __fastcall GetContentID(void);
	virtual System::UnicodeString __fastcall GetContentLocation(void);
	virtual System::UnicodeString __fastcall GetContentDescription(void);
	TIdMessageParts* __fastcall GetMessageParts(void);
	System::Classes::TPersistent* __fastcall GetOwnerMessage(void);
	virtual void __fastcall SetContentDisposition(const System::UnicodeString Value);
	virtual void __fastcall SetContentType(const System::UnicodeString Value);
	virtual void __fastcall SetContentTransfer(const System::UnicodeString Value);
	void __fastcall SetExtraHeaders(Idheaderlist::TIdHeaderList* const Value);
	virtual void __fastcall SetContentID(const System::UnicodeString Value);
	virtual void __fastcall SetContentDescription(const System::UnicodeString Value);
	virtual void __fastcall SetContentLocation(const System::UnicodeString Value);
	
public:
	__fastcall virtual TIdMessagePart(System::Classes::TCollection* Collection);
	__fastcall virtual ~TIdMessagePart(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	System::UnicodeString __fastcall GetCharSet(System::UnicodeString AHeader);
	System::UnicodeString __fastcall ResolveContentType(System::UnicodeString AContentType);
	__classmethod virtual TIdMessagePartType __fastcall PartType();
	__property bool IsEncoded = {read=FIsEncoded, nodefault};
	__property TIdMessageParts* MessageParts = {read=GetMessageParts};
	__property System::Classes::TPersistent* OwnerMessage = {read=GetOwnerMessage};
	__property TOnGetMessagePartStream OnGetMessagePartStream = {read=FOnGetMessagePartStream, write=FOnGetMessagePartStream};
	__property Idheaderlist::TIdHeaderList* Headers = {read=FHeaders};
	
__published:
	__property System::UnicodeString CharSet = {read=FCharSet, write=FCharSet};
	__property System::UnicodeString ContentDescription = {read=GetContentDescription, write=SetContentDescription};
	__property System::UnicodeString ContentDisposition = {read=GetContentDisposition, write=SetContentDisposition};
	__property System::UnicodeString ContentID = {read=GetContentID, write=SetContentID};
	__property System::UnicodeString ContentLocation = {read=GetContentLocation, write=SetContentLocation};
	__property System::UnicodeString ContentTransfer = {read=GetContentTransfer, write=SetContentTransfer};
	__property System::UnicodeString ContentType = {read=GetContentType, write=SetContentType};
	__property Idheaderlist::TIdHeaderList* ExtraHeaders = {read=FExtraHeaders, write=SetExtraHeaders};
	__property System::UnicodeString FileName = {read=FFileName, write=FFileName};
	__property System::UnicodeString Name = {read=FName, write=FName};
	__property int ParentPart = {read=FParentPart, write=FParentPart, nodefault};
};


typedef System::TMetaClass* TIdMessagePartClass;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageParts : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TIdMessagePart* operator[](int Index) { return Items[Index]; }
	
protected:
	System::UnicodeString FAttachmentEncoding;
	int FAttachmentCount;
	System::TObject* FMessageEncoderInfo;
	int FRelatedPartCount;
	int FTextPartCount;
	HIDESBASE TIdMessagePart* __fastcall GetItem(int Index);
	System::Classes::TPersistent* __fastcall GetOwnerMessage(void);
	void __fastcall SetAttachmentEncoding(const System::UnicodeString AValue);
	HIDESBASE void __fastcall SetItem(int Index, TIdMessagePart* const Value);
	
public:
	HIDESBASE TIdMessagePart* __fastcall Add(void);
	void __fastcall CountParts(void);
	__fastcall TIdMessageParts(System::Classes::TPersistent* AOwner);
	__property int AttachmentCount = {read=FAttachmentCount, nodefault};
	__property System::UnicodeString AttachmentEncoding = {read=FAttachmentEncoding, write=SetAttachmentEncoding};
	__property TIdMessagePart* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
	__property System::TObject* MessageEncoderInfo = {read=FMessageEncoderInfo};
	__property System::Classes::TPersistent* OwnerMessage = {read=GetOwnerMessage};
	__property int RelatedPartCount = {read=FRelatedPartCount, nodefault};
	__property int TextPartCount = {read=FTextPartCount, nodefault};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdMessageParts(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdCanNotCreateMessagePart;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdCanNotCreateMessagePart : public Idexceptioncore::EIdMessageException
{
	typedef Idexceptioncore::EIdMessageException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdCanNotCreateMessagePart(const System::UnicodeString AMsg)/* overload */ : Idexceptioncore::EIdMessageException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdCanNotCreateMessagePart(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexceptioncore::EIdMessageException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdCanNotCreateMessagePart(NativeUInt Ident)/* overload */ : Idexceptioncore::EIdMessageException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdCanNotCreateMessagePart(System::PResStringRec ResStringRec)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCanNotCreateMessagePart(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexceptioncore::EIdMessageException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCanNotCreateMessagePart(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdCanNotCreateMessagePart(const System::UnicodeString Msg, int AHelpContext) : Idexceptioncore::EIdMessageException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdCanNotCreateMessagePart(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexceptioncore::EIdMessageException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCanNotCreateMessagePart(NativeUInt Ident, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCanNotCreateMessagePart(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCanNotCreateMessagePart(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCanNotCreateMessagePart(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdCanNotCreateMessagePart(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idmessageparts */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMESSAGEPARTS)
using namespace Idmessageparts;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmessagepartsHPP
