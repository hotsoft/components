// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdIMAP4.pas' rev: 25.00 (Windows)

#ifndef Idimap4HPP
#define Idimap4HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit
#include <IdAssignedNumbers.hpp>	// Pascal unit
#include <IdMailBox.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdMessageParts.hpp>	// Pascal unit
#include <IdMessageClient.hpp>	// Pascal unit
#include <IdReply.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdMessageCoder.hpp>	// Pascal unit
#include <IdHeaderList.hpp>	// Pascal unit
#include <IdCoderHeader.hpp>	// Pascal unit
#include <IdCoderMIME.hpp>	// Pascal unit
#include <IdCoderQuotedPrintable.hpp>	// Pascal unit
#include <IdCoderBinHex4.hpp>	// Pascal unit
#include <IdSASLCollection.hpp>	// Pascal unit
#include <IdMessageCollection.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdExplicitTLSClientServerBase.hpp>	// Pascal unit
#include <IdTCPClient.hpp>	// Pascal unit
#include <IdTCPConnection.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idimap4
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EmUTF7Error;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EmUTF7Error : public Idexception::EIdSilentException
{
	typedef Idexception::EIdSilentException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EmUTF7Error(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdSilentException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EmUTF7Error(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdSilentException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EmUTF7Error(NativeUInt Ident)/* overload */ : Idexception::EIdSilentException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EmUTF7Error(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdSilentException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EmUTF7Error(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdSilentException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EmUTF7Error(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdSilentException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EmUTF7Error(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdSilentException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EmUTF7Error(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdSilentException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EmUTF7Error(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdSilentException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EmUTF7Error(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdSilentException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EmUTF7Error(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdSilentException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EmUTF7Error(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdSilentException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EmUTF7Error(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EmUTF7Encode;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EmUTF7Encode : public EmUTF7Error
{
	typedef EmUTF7Error inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EmUTF7Encode(const System::UnicodeString AMsg)/* overload */ : EmUTF7Error(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EmUTF7Encode(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EmUTF7Error(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EmUTF7Encode(NativeUInt Ident)/* overload */ : EmUTF7Error(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EmUTF7Encode(System::PResStringRec ResStringRec)/* overload */ : EmUTF7Error(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EmUTF7Encode(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EmUTF7Error(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EmUTF7Encode(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EmUTF7Error(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EmUTF7Encode(const System::UnicodeString Msg, int AHelpContext) : EmUTF7Error(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EmUTF7Encode(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EmUTF7Error(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EmUTF7Encode(NativeUInt Ident, int AHelpContext)/* overload */ : EmUTF7Error(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EmUTF7Encode(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EmUTF7Error(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EmUTF7Encode(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EmUTF7Error(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EmUTF7Encode(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EmUTF7Error(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EmUTF7Encode(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EmUTF7Decode;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EmUTF7Decode : public EmUTF7Error
{
	typedef EmUTF7Error inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EmUTF7Decode(const System::UnicodeString AMsg)/* overload */ : EmUTF7Error(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EmUTF7Decode(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EmUTF7Error(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EmUTF7Decode(NativeUInt Ident)/* overload */ : EmUTF7Error(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EmUTF7Decode(System::PResStringRec ResStringRec)/* overload */ : EmUTF7Error(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EmUTF7Decode(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EmUTF7Error(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EmUTF7Decode(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EmUTF7Error(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EmUTF7Decode(const System::UnicodeString Msg, int AHelpContext) : EmUTF7Error(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EmUTF7Decode(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EmUTF7Error(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EmUTF7Decode(NativeUInt Ident, int AHelpContext)/* overload */ : EmUTF7Error(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EmUTF7Decode(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EmUTF7Error(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EmUTF7Decode(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EmUTF7Error(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EmUTF7Decode(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EmUTF7Error(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EmUTF7Decode(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdMUTF7;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMUTF7 : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::UnicodeString __fastcall Encode(const System::UnicodeString aString);
	System::UnicodeString __fastcall Decode(const System::UnicodeString aString);
	bool __fastcall Valid(const System::UnicodeString aMUTF7String);
	System::UnicodeString __fastcall Append(const System::UnicodeString aMUTF7String, const System::UnicodeString aStr);
public:
	/* TObject.Create */ inline __fastcall TIdMUTF7(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdMUTF7(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TIdIMAP4FolderTreatment : unsigned char { ftAllowsTopLevelCreation, ftFoldersMustBeUnderInbox, ftDoesNotAllowFolderCreation, ftCannotTestBecauseHasNoInbox, ftCannotRetrieveAnyFolders };

enum DECLSPEC_DENUM TIdIMAP4AuthenticationType : unsigned char { iatUserPass, iatSASL };

class DELPHICLASS TIdImapMessagePart;
class PASCALIMPLEMENTATION TIdImapMessagePart : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
protected:
	System::UnicodeString FBodyType;
	System::UnicodeString FBodySubType;
	System::UnicodeString FFileName;
	System::UnicodeString FDescription;
	Idmessage::TIdMessageEncoding FEncoding;
	System::UnicodeString FCharSet;
	System::UnicodeString FContentTransferEncoding;
	__int64 FSize;
	System::UnicodeString FUnparsedEntry;
	System::UnicodeString FBoundary;
	int FParentPart;
	System::UnicodeString FImapPartNumber;
	
public:
	__fastcall virtual TIdImapMessagePart(System::Classes::TCollection* Collection);
	__property System::UnicodeString BodyType = {read=FBodyType, write=FBodyType};
	__property System::UnicodeString BodySubType = {read=FBodySubType, write=FBodySubType};
	__property System::UnicodeString FileName = {read=FFileName, write=FFileName};
	__property System::UnicodeString Description = {read=FDescription, write=FDescription};
	__property Idmessage::TIdMessageEncoding Encoding = {read=FEncoding, write=FEncoding, nodefault};
	__property System::UnicodeString CharSet = {read=FCharSet, write=FCharSet};
	__property System::UnicodeString ContentTransferEncoding = {read=FContentTransferEncoding, write=FContentTransferEncoding};
	__property __int64 Size = {read=FSize, write=FSize};
	__property System::UnicodeString UnparsedEntry = {read=FUnparsedEntry, write=FUnparsedEntry};
	__property System::UnicodeString Boundary = {read=FBoundary, write=FBoundary};
	__property int ParentPart = {read=FParentPart, write=FParentPart, nodefault};
	__property System::UnicodeString ImapPartNumber = {read=FImapPartNumber, write=FImapPartNumber};
public:
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TIdImapMessagePart(void) { }
	
};


class DELPHICLASS EIdNumberInvalid;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNumberInvalid : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNumberInvalid(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNumberInvalid(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNumberInvalid(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNumberInvalid(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNumberInvalid(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNumberInvalid(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNumberInvalid(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNumberInvalid(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNumberInvalid(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNumberInvalid(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNumberInvalid(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNumberInvalid(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNumberInvalid(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdDisconnectedProbablyIdledOut;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdDisconnectedProbablyIdledOut : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdDisconnectedProbablyIdledOut(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdDisconnectedProbablyIdledOut(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdDisconnectedProbablyIdledOut(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdDisconnectedProbablyIdledOut(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDisconnectedProbablyIdledOut(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdDisconnectedProbablyIdledOut(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdDisconnectedProbablyIdledOut(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdDisconnectedProbablyIdledOut(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDisconnectedProbablyIdledOut(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdDisconnectedProbablyIdledOut(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDisconnectedProbablyIdledOut(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdDisconnectedProbablyIdledOut(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdDisconnectedProbablyIdledOut(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdImapMessageParts;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdImapMessageParts : public System::Classes::TOwnedCollection
{
	typedef System::Classes::TOwnedCollection inherited;
	
public:
	TIdImapMessagePart* operator[](int Index) { return Items[Index]; }
	
protected:
	HIDESBASE TIdImapMessagePart* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TIdImapMessagePart* const Value);
	
public:
	__fastcall TIdImapMessageParts(System::Classes::TPersistent* AOwner);
	HIDESBASE TIdImapMessagePart* __fastcall Add(void);
	__property TIdImapMessagePart* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TIdImapMessageParts(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdIMAPLineStruct;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdIMAPLineStruct : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	bool HasStar;
	System::UnicodeString MessageNumber;
	System::UnicodeString Command;
	System::UnicodeString UID;
	Idmessage::TIdMessageFlagsSet Flags;
	System::UnicodeString FlagsStr;
	bool Complete;
	int ByteCount;
	System::UnicodeString IMAPFunction;
	System::UnicodeString IMAPValue;
	System::UnicodeString GmailMsgID;
	System::UnicodeString GmailThreadID;
	System::UnicodeString GmailLabels;
public:
	/* TObject.Create */ inline __fastcall TIdIMAPLineStruct(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdIMAPLineStruct(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TIdIMAP4Commands : unsigned char { cmdCAPABILITY, cmdNOOP, cmdLOGOUT, cmdAUTHENTICATE, cmdLOGIN, cmdSELECT, cmdEXAMINE, cmdCREATE, cmdDELETE, cmdRENAME, cmdSUBSCRIBE, cmdUNSUBSCRIBE, cmdLIST, cmdLSUB, cmdSTATUS, cmdAPPEND, cmdCHECK, cmdCLOSE, cmdEXPUNGE, cmdSEARCH, cmdFETCH, cmdSTORE, cmdCOPY, cmdUID, cmdXCmd };

enum DECLSPEC_DENUM TIdIMAP4ConnectionState : unsigned char { csAny, csNonAuthenticated, csAuthenticated, csSelected, csUnexpectedlyDisconnected };

enum DECLSPEC_DENUM TIdIMAP4SearchKey : unsigned char { skAll, skAnswered, skBcc, skBefore, skBody, skCc, skDeleted, skDraft, skFlagged, skFrom, skHeader, skKeyword, skLarger, skNew, skNot, skOld, skOn, skOr, skRecent, skSeen, skSentBefore, skSentOn, skSentSince, skSince, skSmaller, skSubject, skText, skTo, skUID, skUnanswered, skUndeleted, skUndraft, skUnflagged, skUnKeyWord, skUnseen, skGmailRaw, skGmailMsgID, skGmailThreadID, skGmailLabels };

typedef System::DynamicArray<TIdIMAP4SearchKey> TIdIMAP4SearchKeyArray;

struct DECLSPEC_DRECORD TIdIMAP4SearchRec
{
public:
	System::TDateTime Date;
	__int64 Size;
	System::UnicodeString Text;
	TIdIMAP4SearchKey SearchKey;
	System::UnicodeString FieldName;
};


typedef System::DynamicArray<TIdIMAP4SearchRec> TIdIMAP4SearchRecArray;

enum DECLSPEC_DENUM TIdIMAP4StatusDataItem : unsigned char { mdMessages, mdRecent, mdUIDNext, mdUIDValidity, mdUnseen };

enum DECLSPEC_DENUM TIdIMAP4StoreDataItem : unsigned char { sdReplace, sdReplaceSilent, sdAdd, sdAddSilent, sdRemove, sdRemoveSilent };

enum DECLSPEC_DENUM TIdRetrieveOnSelect : unsigned char { rsDisabled, rsHeaders, rsMessages };

typedef void __fastcall (__closure *TIdAlertEvent)(System::TObject* ASender, const System::UnicodeString AAlertMsg);

class DELPHICLASS TIdIMAP4;
class PASCALIMPLEMENTATION TIdIMAP4 : public Idmessageclient::TIdMessageClient
{
	typedef Idmessageclient::TIdMessageClient inherited;
	
protected:
	int FCmdCounter;
	TIdIMAP4ConnectionState FConnectionState;
	Idmailbox::TIdMailBox* FMailBox;
	System::WideChar FMailBoxSeparator;
	TIdAlertEvent FOnAlert;
	TIdRetrieveOnSelect FRetrieveOnSelect;
	int FMilliSecsToWaitToClearBuffer;
	TIdMUTF7* FMUTF7;
	Idcomponent::TWorkEvent FOnWorkForPart;
	Idcomponent::TWorkBeginEvent FOnWorkBeginForPart;
	Idcomponent::TWorkEndEvent FOnWorkEndForPart;
	System::UnicodeString FGreetingBanner;
	bool FHasCapa;
	Idsaslcollection::TIdSASLEntries* FSASLMechanisms;
	TIdIMAP4AuthenticationType FAuthType;
	System::Classes::TStrings* FCapabilities;
	TIdIMAPLineStruct* FLineStruct;
	virtual Idreply::TIdReplyClass __fastcall GetReplyClass(void);
	virtual bool __fastcall GetSupportsTLS(void);
	TIdIMAP4ConnectionState __fastcall CheckConnectionState(TIdIMAP4ConnectionState AAllowedState)/* overload */;
	TIdIMAP4ConnectionState __fastcall CheckConnectionState(TIdIMAP4ConnectionState const *AAllowedStates, const int AAllowedStates_Size)/* overload */;
	bool __fastcall CheckReplyForCapabilities(void);
	void __fastcall BeginWorkForPart(System::TObject* ASender, Idcomponent::TWorkMode AWorkMode, __int64 AWorkCountMax);
	void __fastcall DoWorkForPart(System::TObject* ASender, Idcomponent::TWorkMode AWorkMode, __int64 AWorkCount);
	void __fastcall EndWorkForPart(System::TObject* ASender, Idcomponent::TWorkMode AWorkMode);
	System::UnicodeString __fastcall DoMUTFEncode(const System::UnicodeString aString);
	System::UnicodeString __fastcall DoMUTFDecode(const System::UnicodeString aString);
	System::UnicodeString __fastcall GetCmdCounter(void);
	System::UnicodeString __fastcall GetConnectionStateName(void);
	System::UnicodeString __fastcall GetNewCmdCounter(void);
	__property System::UnicodeString LastCmdCounter = {read=GetCmdCounter};
	__property System::UnicodeString NewCmdCounter = {read=GetNewCmdCounter};
	System::UnicodeString __fastcall ArrayToNumberStr(unsigned const *AMsgNumList, const int AMsgNumList_Size);
	System::UnicodeString __fastcall MessageFlagSetToStr(const Idmessage::TIdMessageFlagsSet AFlags);
	virtual void __fastcall StripCRLFs(System::UnicodeString &AText)/* overload */;
	void __fastcall StripCRLFs(System::Classes::TStream* ASourceStream, System::Classes::TStream* ADestStream)/* overload */;
	void __fastcall ParseImapPart(System::UnicodeString ABodyStructure, TIdImapMessageParts* AImapParts, TIdImapMessagePart* AThisImapPart, TIdImapMessagePart* AParentImapPart, int APartNumber);
	void __fastcall ParseMessagePart(System::UnicodeString ABodyStructure, Idmessageparts::TIdMessageParts* AMessageParts, Idmessageparts::TIdMessagePart* AThisMessagePart, Idmessageparts::TIdMessagePart* AParentMessagePart, int APartNumber);
	void __fastcall ParseBodyStructureResult(System::UnicodeString ABodyStructure, Idmessageparts::TIdMessageParts* ATheParts, TIdImapMessageParts* AImapParts);
	void __fastcall ParseBodyStructurePart(System::UnicodeString APartString, Idmessageparts::TIdMessagePart* AThePart, TIdImapMessagePart* AImapPart);
	void __fastcall ParseTheLine(System::UnicodeString ALine, System::Classes::TStrings* APartsList);
	void __fastcall ParseIntoParts(System::UnicodeString APartString, System::Classes::TStrings* AParams);
	void __fastcall ParseIntoBrackettedQuotedAndUnquotedParts(System::UnicodeString APartString, System::Classes::TStrings* AParams, bool AKeepBrackets);
	void __fastcall BreakApartParamsInQuotes(const System::UnicodeString AParam, System::Classes::TStrings* AParsedList);
	System::UnicodeString __fastcall GetNextWord(System::UnicodeString AParam);
	System::UnicodeString __fastcall GetNextQuotedParam(System::UnicodeString AParam, bool ARemoveQuotes);
	void __fastcall ParseExpungeResult(Idmailbox::TIdMailBox* AMB, System::Classes::TStrings* ACmdResultDetails);
	void __fastcall ParseListResult(System::Classes::TStrings* AMBList, System::Classes::TStrings* ACmdResultDetails);
	void __fastcall ParseLSubResult(System::Classes::TStrings* AMBList, System::Classes::TStrings* ACmdResultDetails);
	void __fastcall InternalParseListResult(System::UnicodeString ACmd, System::Classes::TStrings* AMBList, System::Classes::TStrings* ACmdResultDetails);
	void __fastcall ParseMailBoxAttributeString(System::UnicodeString AAttributesList, Idmailbox::TIdMailBoxAttributesSet &AAttributes);
	void __fastcall ParseMessageFlagString(System::UnicodeString AFlagsList, Idmessage::TIdMessageFlagsSet &AFlags);
	void __fastcall ParseSelectResult(Idmailbox::TIdMailBox* AMB, System::Classes::TStrings* ACmdResultDetails);
	void __fastcall ParseStatusResult(Idmailbox::TIdMailBox* AMB, System::Classes::TStrings* ACmdResultDetails);
	void __fastcall ParseSearchResult(Idmailbox::TIdMailBox* AMB, System::Classes::TStrings* ACmdResultDetails);
	void __fastcall ParseEnvelopeResult(Idmessage::TIdMessage* AMsg, System::UnicodeString ACmdResultStr);
	bool __fastcall ParseLastCmdResult(System::UnicodeString ALine, System::UnicodeString AExpectedCommand, System::UnicodeString *AExpectedIMAPFunction, const int AExpectedIMAPFunction_Size);
	void __fastcall ParseLastCmdResultButAppendInfo(System::UnicodeString ALine);
	bool __fastcall InternalRetrieve(const unsigned AMsgNum, bool AUseUID, bool AUsePeek, Idmessage::TIdMessage* AMsg);
	bool __fastcall InternalRetrievePart(const unsigned AMsgNum, const System::UnicodeString APartNum, bool AUseUID, bool AUsePeek, System::Classes::TStream* ADestStream, System::PByte &ABuffer, int &ABufferLength, System::UnicodeString ADestFileNameAndPath = System::UnicodeString(), System::UnicodeString AContentTransferEncoding = L"text");
	bool __fastcall InternalRetrieveHeaders(Idmessagecollection::TIdMessageCollection* AMsgList, int ACount);
	bool __fastcall InternalRetrieveMsgs(Idmessagecollection::TIdMessageCollection* AMsgList, int ACount);
	bool __fastcall InternalSearchMailBox(TIdIMAP4SearchRec const *ASearchInfo, const int ASearchInfo_Size, bool AUseUID, const System::UnicodeString ACharSet);
	System::UnicodeString __fastcall ParseBodyStructureSectionAsEquates(System::UnicodeString AParam);
	System::UnicodeString __fastcall ParseBodyStructureSectionAsEquates2(System::UnicodeString AParam);
	bool __fastcall InternalRetrieveText(const unsigned AMsgNum, System::UnicodeString &AText, bool AUseUID, bool AUsePeek, bool AUseFirstPartInsteadOfText);
	bool __fastcall IsCapabilityListed(System::UnicodeString ACapability);
	bool __fastcall InternalRetrieveEnvelope(const unsigned AMsgNum, Idmessage::TIdMessage* AMsg, System::Classes::TStrings* ADestList);
	bool __fastcall UIDInternalRetrieveEnvelope(const System::UnicodeString AMsgUID, Idmessage::TIdMessage* AMsg, System::Classes::TStrings* ADestList);
	bool __fastcall InternalRetrievePartHeader(const unsigned AMsgNum, const System::UnicodeString APartNum, const bool AUseUID, Idheaderlist::TIdHeaderList* AHeaders);
	virtual System::UnicodeString __fastcall ReceiveHeader(Idmessage::TIdMessage* AMsg, const System::UnicodeString AAltTerm = System::UnicodeString());
	bool __fastcall IsNumberValid(const unsigned ANumber);
	bool __fastcall IsUIDValid(const System::UnicodeString AUID);
	bool __fastcall IsImapPartNumberValid(const int APartNum)/* overload */;
	bool __fastcall IsImapPartNumberValid(const System::UnicodeString APartNum)/* overload */;
	bool __fastcall IsItDigitsAndOptionallyPeriod(const System::UnicodeString AStr, bool AAllowPeriod);
	virtual void __fastcall ReceiveBody(Idmessage::TIdMessage* AMsg, const System::UnicodeString ADelim = L".");
	virtual void __fastcall InitComponent(void);
	void __fastcall SetMailBox(Idmailbox::TIdMailBox* const Value);
	void __fastcall SetSASLMechanisms(Idsaslcollection::TIdSASLEntries* AValue);
	
public:
	__fastcall TIdIMAP4(System::Classes::TComponent* AOwner)/* overload */;
	__fastcall virtual ~TIdIMAP4(void);
	bool __fastcall Capability(void)/* overload */;
	bool __fastcall Capability(System::Classes::TStrings* ASlCapability)/* overload */;
	TIdIMAP4FolderTreatment __fastcall FindHowServerCreatesFolders(void);
	void __fastcall DoAlert(const System::UnicodeString AMsg);
	__property TIdIMAP4ConnectionState ConnectionState = {read=FConnectionState, nodefault};
	__property Idmailbox::TIdMailBox* MailBox = {read=FMailBox, write=SetMailBox};
	bool __fastcall AppendMsg(const System::UnicodeString AMBName, Idmessage::TIdMessage* AMsg, const Idmessage::TIdMessageFlagsSet AFlags = Idmessage::TIdMessageFlagsSet() , const System::TDateTime AInternalDateTimeGMT = 0.000000E+00)/* overload */;
	bool __fastcall AppendMsg(const System::UnicodeString AMBName, Idmessage::TIdMessage* AMsg, Idheaderlist::TIdHeaderList* AAlternativeHeaders, const Idmessage::TIdMessageFlagsSet AFlags = Idmessage::TIdMessageFlagsSet() , const System::TDateTime AInternalDateTimeGMT = 0.000000E+00)/* overload */;
	bool __fastcall AppendMsgNoEncodeFromFile(const System::UnicodeString AMBName, System::UnicodeString ASourceFile, const Idmessage::TIdMessageFlagsSet AFlags = Idmessage::TIdMessageFlagsSet() , const System::TDateTime AInternalDateTimeGMT = 0.000000E+00);
	bool __fastcall AppendMsgNoEncodeFromStream(const System::UnicodeString AMBName, System::Classes::TStream* AStream, const Idmessage::TIdMessageFlagsSet AFlags = Idmessage::TIdMessageFlagsSet() , const System::TDateTime AInternalDateTimeGMT = 0.000000E+00);
	bool __fastcall CheckMailBox(void);
	bool __fastcall CheckMsgSeen(const unsigned AMsgNum);
	virtual void __fastcall Login(void);
	HIDESBASE virtual bool __fastcall Connect(const bool AAutoLogin = true);
	bool __fastcall CloseMailBox(void);
	bool __fastcall CreateMailBox(const System::UnicodeString AMBName);
	bool __fastcall DeleteMailBox(const System::UnicodeString AMBName);
	bool __fastcall DeleteMsgs(unsigned const *AMsgNumList, const int AMsgNumList_Size);
	virtual void __fastcall Disconnect(bool ANotifyPeer)/* overload */;
	virtual void __fastcall DisconnectNotifyPeer(void);
	bool __fastcall ExamineMailBox(const System::UnicodeString AMBName, Idmailbox::TIdMailBox* AMB);
	bool __fastcall ExpungeMailBox(void);
	void __fastcall KeepAlive(void);
	bool __fastcall ListInferiorMailBoxes(System::Classes::TStrings* AMailBoxList, System::Classes::TStrings* AInferiorMailBoxList);
	bool __fastcall ListMailBoxes(System::Classes::TStrings* AMailBoxList);
	bool __fastcall ListSubscribedMailBoxes(System::Classes::TStrings* AMailBoxList);
	bool __fastcall RenameMailBox(const System::UnicodeString AOldMBName, const System::UnicodeString ANewMBName);
	bool __fastcall SearchMailBox(TIdIMAP4SearchRec const *ASearchInfo, const int ASearchInfo_Size, const System::UnicodeString ACharSet = System::UnicodeString());
	bool __fastcall SelectMailBox(const System::UnicodeString AMBName);
	bool __fastcall StatusMailBox(const System::UnicodeString AMBName, Idmailbox::TIdMailBox* AMB)/* overload */;
	bool __fastcall StatusMailBox(const System::UnicodeString AMBName, Idmailbox::TIdMailBox* AMB, TIdIMAP4StatusDataItem const *AStatusDataItems, const int AStatusDataItems_Size)/* overload */;
	bool __fastcall StoreFlags(unsigned const *AMsgNumList, const int AMsgNumList_Size, const TIdIMAP4StoreDataItem AStoreMethod, const Idmessage::TIdMessageFlagsSet AFlags);
	bool __fastcall StoreValue(unsigned const *AMsgNumList, const int AMsgNumList_Size, const TIdIMAP4StoreDataItem AStoreMethod, const System::UnicodeString AField, const System::UnicodeString AValue);
	bool __fastcall SubscribeMailBox(const System::UnicodeString AMBName);
	bool __fastcall CopyMsg(const unsigned AMsgNum, const System::UnicodeString AMBName);
	bool __fastcall CopyMsgs(unsigned const *AMsgNumList, const int AMsgNumList_Size, const System::UnicodeString AMBName);
	bool __fastcall Retrieve(const unsigned AMsgNum, Idmessage::TIdMessage* AMsg);
	bool __fastcall RetrieveNoDecodeToFile(const unsigned AMsgNum, System::UnicodeString ADestFile);
	bool __fastcall RetrieveNoDecodeToFilePeek(const unsigned AMsgNum, System::UnicodeString ADestFile);
	bool __fastcall RetrieveNoDecodeToStream(const unsigned AMsgNum, System::Classes::TStream* AStream);
	bool __fastcall RetrieveNoDecodeToStreamPeek(const unsigned AMsgNum, System::Classes::TStream* AStream);
	bool __fastcall RetrieveAllEnvelopes(Idmessagecollection::TIdMessageCollection* AMsgList);
	bool __fastcall RetrieveAllHeaders(Idmessagecollection::TIdMessageCollection* AMsgList);
	bool __fastcall RetrieveFirstHeaders(Idmessagecollection::TIdMessageCollection* AMsgList, int ACount);
	bool __fastcall RetrieveAllMsgs(Idmessagecollection::TIdMessageCollection* AMsgList);
	bool __fastcall RetrieveFirstMsgs(Idmessagecollection::TIdMessageCollection* AMsgList, int ACount);
	bool __fastcall RetrieveEnvelope(const unsigned AMsgNum, Idmessage::TIdMessage* AMsg);
	bool __fastcall RetrieveEnvelopeRaw(const unsigned AMsgNum, System::Classes::TStrings* ADestList);
	bool __fastcall RetrieveFlags(const unsigned AMsgNum, Idmessage::TIdMessageFlagsSet &AFlags);
	bool __fastcall RetrieveValue(const unsigned AMsgNum, const System::UnicodeString AField, System::UnicodeString &AValue);
	bool __fastcall InternalRetrieveStructure(const unsigned AMsgNum, Idmessage::TIdMessage* AMsg, TIdImapMessageParts* AParts);
	bool __fastcall RetrieveStructure(const unsigned AMsgNum, Idmessage::TIdMessage* AMsg)/* overload */;
	bool __fastcall RetrieveStructure(const unsigned AMsgNum, TIdImapMessageParts* AParts)/* overload */;
	bool __fastcall RetrievePart(const unsigned AMsgNum, const System::UnicodeString APartNum, System::Classes::TStream* ADestStream, System::UnicodeString AContentTransferEncoding = L"text")/* overload */;
	bool __fastcall RetrievePart(const unsigned AMsgNum, const System::UnicodeString APartNum, System::PByte &ABuffer, int &ABufferLength, System::UnicodeString AContentTransferEncoding = L"text")/* overload */;
	bool __fastcall RetrievePart(const unsigned AMsgNum, const int APartNum, System::PByte &ABuffer, int &ABufferLength, System::UnicodeString AContentTransferEncoding = L"text")/* overload */;
	bool __fastcall RetrievePartPeek(const unsigned AMsgNum, const System::UnicodeString APartNum, System::Classes::TStream* ADestStream, System::UnicodeString AContentTransferEncoding = L"text")/* overload */;
	bool __fastcall RetrievePartPeek(const unsigned AMsgNum, const System::UnicodeString APartNum, System::PByte &ABuffer, int &ABufferLength, System::UnicodeString AContentTransferEncoding = L"text")/* overload */;
	bool __fastcall RetrievePartPeek(const unsigned AMsgNum, const int APartNum, System::PByte &ABuffer, int &ABufferLength, System::UnicodeString AContentTransferEncoding = L"text")/* overload */;
	bool __fastcall RetrievePartToFile(const unsigned AMsgNum, const int APartNum, int ALength, System::UnicodeString ADestFileNameAndPath, System::UnicodeString AContentTransferEncoding)/* overload */;
	bool __fastcall RetrievePartToFile(const unsigned AMsgNum, const System::UnicodeString APartNum, int ALength, System::UnicodeString ADestFileNameAndPath, System::UnicodeString AContentTransferEncoding)/* overload */;
	bool __fastcall RetrievePartToFilePeek(const unsigned AMsgNum, const int APartNum, int ALength, System::UnicodeString ADestFileNameAndPath, System::UnicodeString AContentTransferEncoding)/* overload */;
	bool __fastcall RetrievePartToFilePeek(const unsigned AMsgNum, const System::UnicodeString APartNum, int ALength, System::UnicodeString ADestFileNameAndPath, System::UnicodeString AContentTransferEncoding)/* overload */;
	bool __fastcall RetrieveText(const unsigned AMsgNum, System::UnicodeString &AText);
	bool __fastcall RetrieveText2(const unsigned AMsgNum, System::UnicodeString &AText);
	bool __fastcall RetrieveTextPeek(const unsigned AMsgNum, System::UnicodeString &AText);
	bool __fastcall RetrieveTextPeek2(const unsigned AMsgNum, System::UnicodeString &AText);
	bool __fastcall RetrieveHeader(const unsigned AMsgNum, Idmessage::TIdMessage* AMsg);
	bool __fastcall RetrievePartHeader(const unsigned AMsgNum, const System::UnicodeString APartNum, Idheaderlist::TIdHeaderList* AHeaders);
	__int64 __fastcall RetrieveMailBoxSize(void);
	__int64 __fastcall RetrieveMsgSize(const unsigned AMsgNum);
	bool __fastcall RetrievePeek(const unsigned AMsgNum, Idmessage::TIdMessage* AMsg);
	bool __fastcall GetUID(const unsigned AMsgNum, System::UnicodeString &AUID);
	bool __fastcall UIDCopyMsg(const System::UnicodeString AMsgUID, const System::UnicodeString AMBName);
	bool __fastcall UIDCopyMsgs(System::Classes::TStrings* const AMsgUIDList, const System::UnicodeString AMBName);
	bool __fastcall UIDCheckMsgSeen(const System::UnicodeString AMsgUID);
	bool __fastcall UIDDeleteMsg(const System::UnicodeString AMsgUID);
	bool __fastcall UIDDeleteMsgs(System::UnicodeString const *AMsgUIDList, const int AMsgUIDList_Size);
	bool __fastcall UIDRetrieveAllEnvelopes(Idmessagecollection::TIdMessageCollection* AMsgList);
	bool __fastcall UIDRetrieve(const System::UnicodeString AMsgUID, Idmessage::TIdMessage* AMsg);
	bool __fastcall UIDRetrieveNoDecodeToFile(const System::UnicodeString AMsgUID, System::UnicodeString ADestFile);
	bool __fastcall UIDRetrieveNoDecodeToFilePeek(const System::UnicodeString AMsgUID, System::UnicodeString ADestFile);
	bool __fastcall UIDRetrieveNoDecodeToStream(const System::UnicodeString AMsgUID, System::Classes::TStream* AStream);
	bool __fastcall UIDRetrieveNoDecodeToStreamPeek(const System::UnicodeString AMsgUID, System::Classes::TStream* AStream);
	bool __fastcall UIDRetrieveEnvelope(const System::UnicodeString AMsgUID, Idmessage::TIdMessage* AMsg);
	bool __fastcall UIDRetrieveEnvelopeRaw(const System::UnicodeString AMsgUID, System::Classes::TStrings* ADestList);
	bool __fastcall UIDRetrieveFlags(const System::UnicodeString AMsgUID, Idmessage::TIdMessageFlagsSet &AFlags);
	bool __fastcall UIDRetrieveValue(const System::UnicodeString AMsgUID, const System::UnicodeString AField, System::UnicodeString &AValue);
	bool __fastcall UIDInternalRetrieveStructure(const System::UnicodeString AMsgUID, Idmessage::TIdMessage* AMsg, TIdImapMessageParts* AParts);
	bool __fastcall UIDRetrieveStructure(const System::UnicodeString AMsgUID, Idmessage::TIdMessage* AMsg)/* overload */;
	bool __fastcall UIDRetrieveStructure(const System::UnicodeString AMsgUID, TIdImapMessageParts* AParts)/* overload */;
	bool __fastcall UIDRetrievePart(const System::UnicodeString AMsgUID, const System::UnicodeString APartNum, System::Classes::TStream* &ADestStream, System::UnicodeString AContentTransferEncoding = L"text")/* overload */;
	bool __fastcall UIDRetrievePart(const System::UnicodeString AMsgUID, const System::UnicodeString APartNum, System::PByte &ABuffer, int &ABufferLength, System::UnicodeString AContentTransferEncoding = L"text")/* overload */;
	bool __fastcall UIDRetrievePart(const System::UnicodeString AMsgUID, const int APartNum, System::PByte &ABuffer, int &ABufferLength, System::UnicodeString AContentTransferEncoding = L"text")/* overload */;
	bool __fastcall UIDRetrievePartPeek(const System::UnicodeString AMsgUID, const System::UnicodeString APartNum, System::Classes::TStream* &ADestStream, System::UnicodeString AContentTransferEncoding = L"text")/* overload */;
	bool __fastcall UIDRetrievePartPeek(const System::UnicodeString AMsgUID, const System::UnicodeString APartNum, System::PByte &ABuffer, int &ABufferLength, System::UnicodeString AContentTransferEncoding = L"text")/* overload */;
	bool __fastcall UIDRetrievePartPeek(const System::UnicodeString AMsgUID, const int APartNum, System::PByte &ABuffer, int &ABufferLength, System::UnicodeString AContentTransferEncoding = L"text")/* overload */;
	bool __fastcall UIDRetrievePartToFile(const System::UnicodeString AMsgUID, const int APartNum, int ALength, System::UnicodeString ADestFileNameAndPath, System::UnicodeString AContentTransferEncoding)/* overload */;
	bool __fastcall UIDRetrievePartToFile(const System::UnicodeString AMsgUID, const System::UnicodeString APartNum, int ALength, System::UnicodeString ADestFileNameAndPath, System::UnicodeString AContentTransferEncoding)/* overload */;
	bool __fastcall UIDRetrievePartToFilePeek(const System::UnicodeString AMsgUID, const int APartNum, int ALength, System::UnicodeString ADestFileNameAndPath, System::UnicodeString AContentTransferEncoding)/* overload */;
	bool __fastcall UIDRetrievePartToFilePeek(const System::UnicodeString AMsgUID, const System::UnicodeString APartNum, int ALength, System::UnicodeString ADestFileNameAndPath, System::UnicodeString AContentTransferEncoding)/* overload */;
	bool __fastcall UIDRetrieveText(const System::UnicodeString AMsgUID, System::UnicodeString &AText);
	bool __fastcall UIDRetrieveText2(const System::UnicodeString AMsgUID, System::UnicodeString &AText);
	bool __fastcall UIDRetrieveTextPeek(const System::UnicodeString AMsgUID, System::UnicodeString &AText);
	bool __fastcall UIDRetrieveTextPeek2(const System::UnicodeString AMsgUID, System::UnicodeString &AText);
	bool __fastcall UIDRetrieveHeader(const System::UnicodeString AMsgUID, Idmessage::TIdMessage* AMsg);
	bool __fastcall UIDRetrievePartHeader(const System::UnicodeString AMsgUID, const System::UnicodeString APartNum, Idheaderlist::TIdHeaderList* AHeaders);
	__int64 __fastcall UIDRetrieveMailBoxSize(void);
	__int64 __fastcall UIDRetrieveMsgSize(const System::UnicodeString AMsgUID);
	bool __fastcall UIDRetrievePeek(const System::UnicodeString AMsgUID, Idmessage::TIdMessage* AMsg);
	bool __fastcall UIDSearchMailBox(TIdIMAP4SearchRec const *ASearchInfo, const int ASearchInfo_Size, const System::UnicodeString ACharSet = System::UnicodeString());
	bool __fastcall UIDStoreFlags(const System::UnicodeString AMsgUID, const TIdIMAP4StoreDataItem AStoreMethod, const Idmessage::TIdMessageFlagsSet AFlags)/* overload */;
	bool __fastcall UIDStoreFlags(System::UnicodeString const *AMsgUIDList, const int AMsgUIDList_Size, const TIdIMAP4StoreDataItem AStoreMethod, const Idmessage::TIdMessageFlagsSet AFlags)/* overload */;
	bool __fastcall UIDStoreValue(const System::UnicodeString AMsgUID, const TIdIMAP4StoreDataItem AStoreMethod, const System::UnicodeString AField, const System::UnicodeString AValue)/* overload */;
	bool __fastcall UIDStoreValue(System::UnicodeString const *AMsgUIDList, const int AMsgUIDList_Size, const TIdIMAP4StoreDataItem AStoreMethod, const System::UnicodeString AField, const System::UnicodeString AValue)/* overload */;
	bool __fastcall UnsubscribeMailBox(const System::UnicodeString AMBName);
	HIDESBASE System::UnicodeString __fastcall GetInternalResponse(const System::UnicodeString ATag, System::UnicodeString *AExpectedResponses, const int AExpectedResponses_Size, bool ASingleLineMode, bool ASingleLineMayBeSplit = true)/* overload */;
	HIDESBASE System::UnicodeString __fastcall GetResponse(void)/* overload */;
	HIDESBASE System::UnicodeString __fastcall SendCmd(const System::UnicodeString AOut, System::UnicodeString *AExpectedResponses, const int AExpectedResponses_Size, bool ASingleLineMode = false, bool ASingleLineMayBeSplit = true)/* overload */;
	HIDESBASE System::UnicodeString __fastcall SendCmd(const System::UnicodeString ATag, const System::UnicodeString AOut, System::UnicodeString *AExpectedResponses, const int AExpectedResponses_Size, bool ASingleLineMode = false, bool ASingleLineMayBeSplit = true)/* overload */;
	System::UnicodeString __fastcall ReadLnWait _DEPRECATED_ATTRIBUTE1("Use IOHandler.ReadLnWait()") (void);
	void __fastcall WriteLn _DEPRECATED_ATTRIBUTE1("Use IOHandler.WriteLn()") (const System::UnicodeString AOut = System::UnicodeString());
	
__published:
	__property TIdAlertEvent OnAlert = {read=FOnAlert, write=FOnAlert};
	__property Password = {default=0};
	__property TIdRetrieveOnSelect RetrieveOnSelect = {read=FRetrieveOnSelect, write=FRetrieveOnSelect, default=0};
	__property Port = {default=143};
	__property Username = {default=0};
	__property System::WideChar MailBoxSeparator = {read=FMailBoxSeparator, write=FMailBoxSeparator, default=47};
	__property System::UnicodeString GreetingBanner = {read=FGreetingBanner};
	__property Host = {default=0};
	__property UseTLS = {default=0};
	__property Idsaslcollection::TIdSASLEntries* SASLMechanisms = {read=FSASLMechanisms, write=SetSASLMechanisms};
	__property TIdIMAP4AuthenticationType AuthType = {read=FAuthType, write=FAuthType, default=0};
	__property int MilliSecsToWaitToClearBuffer = {read=FMilliSecsToWaitToClearBuffer, write=FMilliSecsToWaitToClearBuffer, nodefault};
	__property Idcomponent::TWorkEvent OnWorkForPart = {read=FOnWorkForPart, write=FOnWorkForPart};
	__property Idcomponent::TWorkBeginEvent OnWorkBeginForPart = {read=FOnWorkBeginForPart, write=FOnWorkBeginForPart};
	__property Idcomponent::TWorkEndEvent OnWorkEndForPart = {read=FOnWorkEndForPart, write=FOnWorkEndForPart};
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdIMAP4(void)/* overload */ : Idmessageclient::TIdMessageClient() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Disconnect(void){ Idtcpconnection::TIdTCPConnection::Disconnect(); }
	inline short __fastcall  GetResponse(const short AAllowedResponse = (short)(0xffffffff), Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding()){ return Idtcpconnection::TIdTCPConnection::GetResponse(AAllowedResponse, AEncoding); }
	inline short __fastcall  GetResponse(short const *AAllowedResponses, const int AAllowedResponses_Size, Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding()){ return Idtcpconnection::TIdTCPConnection::GetResponse(AAllowedResponses, AAllowedResponses_Size, AEncoding); }
	inline System::UnicodeString __fastcall  GetResponse(const System::UnicodeString AAllowedResponse, Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding()){ return Idtcpconnection::TIdTCPConnection::GetResponse(AAllowedResponse, AEncoding); }
	inline short __fastcall  SendCmd(System::UnicodeString AOut, const short AResponse = (short)(0xffffffff), Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding()){ return Idtcpconnection::TIdTCPConnection::SendCmd(AOut, AResponse, AEncoding); }
	inline short __fastcall  SendCmd(System::UnicodeString AOut, short const *AResponse, const int AResponse_Size, Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding()){ return Idtcpconnection::TIdTCPConnection::SendCmd(AOut, AResponse, AResponse_Size, AEncoding); }
	inline System::UnicodeString __fastcall  SendCmd(System::UnicodeString AOut, const System::UnicodeString AResponse, Idglobal::_di_IIdTextEncoding AEncoding = Idglobal::_di_IIdTextEncoding()){ return Idtcpconnection::TIdTCPConnection::SendCmd(AOut, AResponse, AEncoding); }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 wsOk = System::Int8(0x1);
static const System::Int8 wsNo = System::Int8(0x2);
static const System::Int8 wsBad = System::Int8(0x3);
static const System::Int8 wsPreAuth = System::Int8(0x4);
static const System::Int8 wsBye = System::Int8(0x5);
static const System::Int8 wsContinue = System::Int8(0x6);
static const TIdIMAP4AuthenticationType DEF_IMAP4_AUTH = (TIdIMAP4AuthenticationType)(0);
static const System::Int8 IDF_DEFAULT_MS_TO_WAIT_TO_CLEAR_BUFFER = System::Int8(0xa);
}	/* namespace Idimap4 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDIMAP4)
using namespace Idimap4;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idimap4HPP
