// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMessage.pas' rev: 25.00 (Windows)

#ifndef IdmessageHPP
#define IdmessageHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdAttachment.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdCoderHeader.hpp>	// Pascal unit
#include <IdEMailAddress.hpp>	// Pascal unit
#include <IdExceptionCore.hpp>	// Pascal unit
#include <IdHeaderList.hpp>	// Pascal unit
#include <IdMessageParts.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmessage
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdMessagePriority : unsigned char { mpHighest, mpHigh, mpNormal, mpLow, mpLowest };

class DELPHICLASS TIdMIMEBoundary;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMIMEBoundary : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::Classes::TStrings* FBoundaryList;
	System::Classes::TStrings* FParentPartList;
	System::UnicodeString __fastcall GetBoundary(void);
	int __fastcall GetParentPart(void);
	
public:
	__fastcall TIdMIMEBoundary(void);
	__fastcall virtual ~TIdMIMEBoundary(void);
	void __fastcall Push(System::UnicodeString ABoundary, int AParentPart);
	void __fastcall Pop(void);
	void __fastcall Clear(void);
	int __fastcall Count(void);
	__property System::UnicodeString Boundary = {read=GetBoundary};
	__property int ParentPart = {read=GetParentPart, nodefault};
};

#pragma pack(pop)

enum DECLSPEC_DENUM TIdMessageFlags : unsigned char { mfAnswered, mfFlagged, mfDeleted, mfDraft, mfSeen, mfRecent };

typedef System::Set<TIdMessageFlags, TIdMessageFlags::mfAnswered, TIdMessageFlags::mfRecent>  TIdMessageFlagsSet;

enum DECLSPEC_DENUM TIdMessageEncoding : unsigned char { meDefault, meMIME, mePlainText };

typedef void __fastcall (__closure *TIdInitializeIsoEvent)(System::WideChar &VHeaderEncoding, System::UnicodeString &VCharSet);

class DELPHICLASS TIdMessage;
typedef void __fastcall (__closure *TIdCreateAttachmentEvent)(TIdMessage* const AMsg, System::Classes::TStrings* const AHeaders, Idattachment::TIdAttachment* &AAttachment);

class PASCALIMPLEMENTATION TIdMessage : public Idbasecomponent::TIdBaseComponent
{
	typedef Idbasecomponent::TIdBaseComponent inherited;
	
protected:
	System::UnicodeString FAttachmentTempDirectory;
	Idemailaddress::TIdEMailAddressList* FBccList;
	System::Classes::TStrings* FBody;
	System::UnicodeString FCharSet;
	Idemailaddress::TIdEMailAddressList* FCcList;
	System::UnicodeString FContentType;
	System::UnicodeString FContentTransferEncoding;
	System::UnicodeString FContentDisposition;
	System::TDateTime FDate;
	bool FIsEncoded;
	Idheaderlist::TIdHeaderList* FExtraHeaders;
	TIdMessageEncoding FEncoding;
	TIdMessageFlagsSet FFlags;
	Idemailaddress::TIdEMailAddressList* FFromList;
	Idheaderlist::TIdHeaderList* FHeaders;
	Idmessageparts::TIdMessageParts* FMessageParts;
	TIdMIMEBoundary* FMIMEBoundary;
	System::UnicodeString FMsgId;
	System::Classes::TStrings* FNewsGroups;
	bool FNoEncode;
	bool FNoDecode;
	TIdInitializeIsoEvent FOnInitializeISO;
	System::UnicodeString FOrganization;
	TIdMessagePriority FPriority;
	System::UnicodeString FSubject;
	Idemailaddress::TIdEMailAddressItem* FReceiptRecipient;
	Idemailaddress::TIdEMailAddressList* FRecipients;
	System::UnicodeString FReferences;
	System::UnicodeString FInReplyTo;
	Idemailaddress::TIdEMailAddressList* FReplyTo;
	Idemailaddress::TIdEMailAddressItem* FSender;
	System::UnicodeString FUID;
	System::UnicodeString FXProgram;
	TIdCreateAttachmentEvent FOnCreateAttachment;
	Idheaderlist::TIdHeaderList* FLastGeneratedHeaders;
	bool FConvertPreamble;
	bool FSavingToFile;
	bool FIsMsgSinglePartMime;
	bool FExceptionOnBlockedAttachments;
	virtual void __fastcall DoInitializeISO(System::WideChar &VHeaderEncoding, System::UnicodeString &VCharSet);
	System::UnicodeString __fastcall GetAttachmentEncoding(void);
	System::UnicodeString __fastcall GetInReplyTo(void);
	bool __fastcall GetUseNowForDate(void);
	Idemailaddress::TIdEMailAddressItem* __fastcall GetFrom(void);
	void __fastcall SetAttachmentEncoding(const System::UnicodeString AValue);
	void __fastcall SetAttachmentTempDirectory(const System::UnicodeString Value);
	void __fastcall SetBccList(Idemailaddress::TIdEMailAddressList* const AValue);
	void __fastcall SetBody(System::Classes::TStrings* const AValue);
	void __fastcall SetCCList(Idemailaddress::TIdEMailAddressList* const AValue);
	void __fastcall SetContentType(const System::UnicodeString AValue);
	void __fastcall SetEncoding(const TIdMessageEncoding AValue);
	void __fastcall SetExtraHeaders(Idheaderlist::TIdHeaderList* const AValue);
	void __fastcall SetFrom(Idemailaddress::TIdEMailAddressItem* const AValue);
	void __fastcall SetFromList(Idemailaddress::TIdEMailAddressList* const AValue);
	void __fastcall SetHeaders(Idheaderlist::TIdHeaderList* const AValue);
	void __fastcall SetInReplyTo(const System::UnicodeString AValue);
	void __fastcall SetMsgID(const System::UnicodeString AValue);
	void __fastcall SetNewsGroups(System::Classes::TStrings* const AValue);
	void __fastcall SetReceiptRecipient(Idemailaddress::TIdEMailAddressItem* const AValue);
	void __fastcall SetRecipients(Idemailaddress::TIdEMailAddressList* const AValue);
	void __fastcall SetReplyTo(Idemailaddress::TIdEMailAddressList* const AValue);
	void __fastcall SetSender(Idemailaddress::TIdEMailAddressItem* const AValue);
	void __fastcall SetUseNowForDate(const bool AValue);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall virtual ~TIdMessage(void);
	void __fastcall AddHeader(const System::UnicodeString AValue);
	virtual void __fastcall Clear(void);
	void __fastcall ClearBody(void);
	void __fastcall ClearHeader(void);
	virtual void __fastcall GenerateHeader(void);
	void __fastcall InitializeISO(System::WideChar &VHeaderEncoding, System::UnicodeString &VCharSet);
	bool __fastcall IsBodyEncodingRequired(void);
	bool __fastcall IsBodyEmpty(void);
	void __fastcall LoadFromFile(const System::UnicodeString AFileName, const bool AHeadersOnly = false);
	void __fastcall LoadFromStream(System::Classes::TStream* AStream, const bool AHeadersOnly = false);
	virtual void __fastcall ProcessHeaders(void);
	void __fastcall SaveToFile(const System::UnicodeString AFileName, const bool AHeadersOnly = false);
	void __fastcall SaveToStream(System::Classes::TStream* AStream, const bool AHeadersOnly = false);
	virtual void __fastcall DoCreateAttachment(System::Classes::TStrings* const AHeaders, Idattachment::TIdAttachment* &VAttachment);
	__property TIdMessageFlagsSet Flags = {read=FFlags, write=FFlags, nodefault};
	__property bool IsEncoded = {read=FIsEncoded, write=FIsEncoded, nodefault};
	__property System::UnicodeString MsgId = {read=FMsgId, write=SetMsgID};
	__property Idheaderlist::TIdHeaderList* Headers = {read=FHeaders, write=SetHeaders};
	__property Idmessageparts::TIdMessageParts* MessageParts = {read=FMessageParts};
	__property TIdMIMEBoundary* MIMEBoundary = {read=FMIMEBoundary};
	__property System::UnicodeString UID = {read=FUID, write=FUID};
	__property bool IsMsgSinglePartMime = {read=FIsMsgSinglePartMime, write=FIsMsgSinglePartMime, nodefault};
	
__published:
	__property System::UnicodeString AttachmentEncoding = {read=GetAttachmentEncoding, write=SetAttachmentEncoding};
	__property System::Classes::TStrings* Body = {read=FBody, write=SetBody};
	__property Idemailaddress::TIdEMailAddressList* BccList = {read=FBccList, write=SetBccList};
	__property System::UnicodeString CharSet = {read=FCharSet, write=FCharSet};
	__property Idemailaddress::TIdEMailAddressList* CCList = {read=FCcList, write=SetCCList};
	__property System::UnicodeString ContentType = {read=FContentType, write=SetContentType};
	__property System::UnicodeString ContentTransferEncoding = {read=FContentTransferEncoding, write=FContentTransferEncoding};
	__property System::UnicodeString ContentDisposition = {read=FContentDisposition, write=FContentDisposition};
	__property System::TDateTime Date = {read=FDate, write=FDate};
	__property TIdMessageEncoding Encoding = {read=FEncoding, write=SetEncoding, nodefault};
	__property Idheaderlist::TIdHeaderList* ExtraHeaders = {read=FExtraHeaders, write=SetExtraHeaders};
	__property Idemailaddress::TIdEMailAddressList* FromList = {read=FFromList, write=SetFromList};
	__property Idemailaddress::TIdEMailAddressItem* From = {read=GetFrom, write=SetFrom};
	__property System::Classes::TStrings* NewsGroups = {read=FNewsGroups, write=SetNewsGroups};
	__property bool NoEncode = {read=FNoEncode, write=FNoEncode, default=0};
	__property bool NoDecode = {read=FNoDecode, write=FNoDecode, default=0};
	__property System::UnicodeString Organization = {read=FOrganization, write=FOrganization};
	__property TIdMessagePriority Priority = {read=FPriority, write=FPriority, default=2};
	__property Idemailaddress::TIdEMailAddressItem* ReceiptRecipient = {read=FReceiptRecipient, write=SetReceiptRecipient};
	__property Idemailaddress::TIdEMailAddressList* Recipients = {read=FRecipients, write=SetRecipients};
	__property System::UnicodeString References = {read=FReferences, write=FReferences};
	__property System::UnicodeString InReplyTo = {read=GetInReplyTo, write=SetInReplyTo};
	__property Idemailaddress::TIdEMailAddressList* ReplyTo = {read=FReplyTo, write=SetReplyTo};
	__property System::UnicodeString Subject = {read=FSubject, write=FSubject};
	__property Idemailaddress::TIdEMailAddressItem* Sender = {read=FSender, write=SetSender};
	__property bool UseNowForDate = {read=GetUseNowForDate, write=SetUseNowForDate, default=1};
	__property Idheaderlist::TIdHeaderList* LastGeneratedHeaders = {read=FLastGeneratedHeaders};
	__property bool ConvertPreamble = {read=FConvertPreamble, write=FConvertPreamble, nodefault};
	__property bool ExceptionOnBlockedAttachments = {read=FExceptionOnBlockedAttachments, write=FExceptionOnBlockedAttachments, default=0};
	__property System::UnicodeString AttachmentTempDirectory = {read=FAttachmentTempDirectory, write=SetAttachmentTempDirectory};
	__property TIdInitializeIsoEvent OnInitializeISO = {read=FOnInitializeISO, write=FOnInitializeISO};
	__property TIdCreateAttachmentEvent OnCreateAttachment = {read=FOnCreateAttachment, write=FOnCreateAttachment};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMessage(System::Classes::TComponent* AOwner)/* overload */ : Idbasecomponent::TIdBaseComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMessage(void)/* overload */ : Idbasecomponent::TIdBaseComponent() { }
	
};


typedef void __fastcall (__closure *TIdMessageEvent)(System::Classes::TComponent* ASender, TIdMessage* &AMsg);

class DELPHICLASS EIdTextInvalidCount;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTextInvalidCount : public Idexceptioncore::EIdMessageException
{
	typedef Idexceptioncore::EIdMessageException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTextInvalidCount(const System::UnicodeString AMsg)/* overload */ : Idexceptioncore::EIdMessageException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTextInvalidCount(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexceptioncore::EIdMessageException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTextInvalidCount(NativeUInt Ident)/* overload */ : Idexceptioncore::EIdMessageException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTextInvalidCount(System::PResStringRec ResStringRec)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTextInvalidCount(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexceptioncore::EIdMessageException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTextInvalidCount(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTextInvalidCount(const System::UnicodeString Msg, int AHelpContext) : Idexceptioncore::EIdMessageException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTextInvalidCount(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexceptioncore::EIdMessageException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTextInvalidCount(NativeUInt Ident, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTextInvalidCount(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTextInvalidCount(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTextInvalidCount(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTextInvalidCount(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdMessageCannotLoad;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdMessageCannotLoad : public Idexceptioncore::EIdMessageException
{
	typedef Idexceptioncore::EIdMessageException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdMessageCannotLoad(const System::UnicodeString AMsg)/* overload */ : Idexceptioncore::EIdMessageException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdMessageCannotLoad(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexceptioncore::EIdMessageException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdMessageCannotLoad(NativeUInt Ident)/* overload */ : Idexceptioncore::EIdMessageException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdMessageCannotLoad(System::PResStringRec ResStringRec)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMessageCannotLoad(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexceptioncore::EIdMessageException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMessageCannotLoad(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdMessageCannotLoad(const System::UnicodeString Msg, int AHelpContext) : Idexceptioncore::EIdMessageException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdMessageCannotLoad(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexceptioncore::EIdMessageException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMessageCannotLoad(NativeUInt Ident, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMessageCannotLoad(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMessageCannotLoad(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMessageCannotLoad(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdMessageCannotLoad(void) { }
	
};

#pragma pack(pop)

typedef System::StaticArray<System::UnicodeString, 6> Idmessage__5;

//-- var, const, procedure ---------------------------------------------------
static const bool ID_MSG_NODECODE = false;
static const bool ID_MSG_USESNOWFORDATE = true;
static const TIdMessagePriority ID_MSG_PRIORITY = (TIdMessagePriority)(2);
extern DELPHI_PACKAGE Idmessage__5 MessageFlags;
#define INREPLYTO L"In-Reply-To"
}	/* namespace Idmessage */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMESSAGE)
using namespace Idmessage;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmessageHPP
