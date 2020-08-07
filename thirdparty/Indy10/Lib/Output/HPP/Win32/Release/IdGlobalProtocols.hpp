// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdGlobalProtocols.pas' rev: 25.00 (Windows)

#ifndef IdglobalprotocolsHPP
#define IdglobalprotocolsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <IdCharsets.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idglobalprotocols
{
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::UnicodeString, 7> Idglobalprotocols__1;

typedef System::StaticArray<System::UnicodeString, 12> Idglobalprotocols__2;

typedef System::UnicodeString TIdFileName;

typedef System::WideChar * PIdFileNameChar;

typedef System::UnicodeString __fastcall (__closure *TIdReadLnFunction)(void);

typedef void __fastcall (*TStringEvent)(System::Classes::TComponent* ASender, const System::UnicodeString AString);

class DELPHICLASS TIdMimeTable;
class PASCALIMPLEMENTATION TIdMimeTable : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	bool FLoadTypesFromOS;
	System::Classes::TNotifyEvent FOnBuildCache;
	System::Classes::TStrings* FMIMEList;
	System::Classes::TStrings* FFileExt;
	virtual void __fastcall BuildDefaultCache(void);
	
public:
	__property bool LoadTypesFromOS = {read=FLoadTypesFromOS, write=FLoadTypesFromOS, nodefault};
	virtual void __fastcall BuildCache(void);
	void __fastcall AddMimeType(const System::UnicodeString Ext, const System::UnicodeString MIMEType, const bool ARaiseOnError = true);
	System::UnicodeString __fastcall GetFileMIMEType(const System::UnicodeString AFileName);
	System::UnicodeString __fastcall GetDefaultFileExt(const System::UnicodeString MIMEType);
	void __fastcall LoadFromStrings(System::Classes::TStrings* const AStrings, const System::WideChar MimeSeparator = (System::WideChar)(0x3d));
	void __fastcall SaveToStrings(System::Classes::TStrings* const AStrings, const System::WideChar MimeSeparator = (System::WideChar)(0x3d));
	__fastcall virtual TIdMimeTable(const bool AutoFill);
	__fastcall virtual ~TIdMimeTable(void);
	__property System::Classes::TNotifyEvent OnBuildCache = {read=FOnBuildCache, write=FOnBuildCache};
};


class DELPHICLASS TIdInterfacedObject;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdInterfacedObject : public System::TInterfacedObject
{
	typedef System::TInterfacedObject inherited;
	
public:
	HIDESBASE int __fastcall _AddRef(void);
	HIDESBASE int __fastcall _Release(void);
public:
	/* TObject.Create */ inline __fastcall TIdInterfacedObject(void) : System::TInterfacedObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdInterfacedObject(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TIdHeaderQuotingType : unsigned char { QuotePlain, QuoteRFC822, QuoteMIME, QuoteHTTP };

class DELPHICLASS EIdExtensionAlreadyExists;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdExtensionAlreadyExists : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdExtensionAlreadyExists(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdExtensionAlreadyExists(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdExtensionAlreadyExists(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdExtensionAlreadyExists(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdExtensionAlreadyExists(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdExtensionAlreadyExists(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdExtensionAlreadyExists(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdExtensionAlreadyExists(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdExtensionAlreadyExists(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdExtensionAlreadyExists(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdExtensionAlreadyExists(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdExtensionAlreadyExists(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdExtensionAlreadyExists(void) { }
	
};

#pragma pack(pop)

typedef Idglobal::_di_IIdTextEncoding __fastcall (*TIdEncodingNeededEvent)(const System::UnicodeString ACharset);

typedef System::DynamicArray<System::UnicodeString> Idglobalprotocols__6;

typedef System::DynamicArray<System::UnicodeString> Idglobalprotocols__7;

//-- var, const, procedure ---------------------------------------------------
#define LWS L"\t "
extern DELPHI_PACKAGE Idglobalprotocols__1 wdays;
extern DELPHI_PACKAGE Idglobalprotocols__2 monthnames;
extern DELPHI_PACKAGE TIdEncodingNeededEvent GIdEncodingNeeded;
extern DELPHI_PACKAGE Idglobalprotocols__6 IndyFalseBoolStrs;
extern DELPHI_PACKAGE Idglobalprotocols__7 IndyTrueBoolStrs;
extern DELPHI_PACKAGE System::TDateTime UNIXSTARTDATE;
static const System::Int8 TIME_BASEDATE = System::Int8(0x2);
#define HexNumbers L"01234567890ABCDEF"
#define BinNumbers L"01"
extern DELPHI_PACKAGE System::UnicodeString __fastcall UnquotedStr(const System::UnicodeString AStr);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IndyWrapText(const System::UnicodeString ALine, const System::UnicodeString ABreakStr, const System::UnicodeString ABreakChars, int MaxCol);
extern DELPHI_PACKAGE int __fastcall IndyCurrentYear(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall CharRange(const System::WideChar AMin, const System::WideChar AMax);
extern DELPHI_PACKAGE bool __fastcall StartsWith(const System::UnicodeString ANSIStr, const System::UnicodeString APattern);
extern DELPHI_PACKAGE System::TDateTime __fastcall UnixDateTimeToDelphiDateTime(unsigned UnixDateTime);
extern DELPHI_PACKAGE unsigned __fastcall DateTimeToUnix(System::TDateTime ADateTime);
extern DELPHI_PACKAGE void __fastcall CopyBytesToHostWord _DEPRECATED_ATTRIBUTE1("Use CopyBytesToHostWord") (const Idglobal::TIdBytes ASource, const int ASourceIndex, System::Word &VDest);
extern DELPHI_PACKAGE void __fastcall CopyBytesToHostUInt16(const Idglobal::TIdBytes ASource, const int ASourceIndex, System::Word &VDest);
extern DELPHI_PACKAGE void __fastcall CopyBytesToHostLongWord _DEPRECATED_ATTRIBUTE1("Use CopyBytesToHostUInt32") (const Idglobal::TIdBytes ASource, const int ASourceIndex, unsigned &VDest);
extern DELPHI_PACKAGE void __fastcall CopyBytesToHostUInt32(const Idglobal::TIdBytes ASource, const int ASourceIndex, unsigned &VDest);
extern DELPHI_PACKAGE void __fastcall CopyTIdNetworkWord _DEPRECATED_ATTRIBUTE1("Use CopyTIdNetworkWord") (const System::Word ASource, Idglobal::TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdNetworkUInt16(const System::Word ASource, Idglobal::TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdNetworkLongWord _DEPRECATED_ATTRIBUTE1("Use CopyTIdNetworkLongWord") (const unsigned ASource, Idglobal::TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdNetworkUInt32(const unsigned ASource, Idglobal::TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE System::UnicodeString __fastcall UInt32ToFourChar(unsigned AValue);
extern DELPHI_PACKAGE System::UnicodeString __fastcall LongWordToFourChar _DEPRECATED_ATTRIBUTE1("Use UInt32ToFourChar()") (unsigned AValue);
extern DELPHI_PACKAGE void __fastcall UInt16ToTwoBytes(System::Word AWord, Idglobal::TIdBytes ByteArray, int Index);
extern DELPHI_PACKAGE void __fastcall WordToTwoBytes _DEPRECATED_ATTRIBUTE1("Use UInt16ToTwoBytes()") (System::Word AWord, Idglobal::TIdBytes ByteArray, int Index);
extern DELPHI_PACKAGE System::Word __fastcall StrToWord(const System::UnicodeString Value);
extern DELPHI_PACKAGE System::UnicodeString __fastcall UInt16ToStr(const System::Word Value);
extern DELPHI_PACKAGE System::UnicodeString __fastcall WordToStr _DEPRECATED_ATTRIBUTE1("Use UInt16ToStr()") (const System::Word Value);
extern DELPHI_PACKAGE unsigned __fastcall OrdFourByteToUInt32(System::Byte AByte1, System::Byte AByte2, System::Byte AByte3, System::Byte AByte4);
extern DELPHI_PACKAGE unsigned __fastcall OrdFourByteToLongWord _DEPRECATED_ATTRIBUTE1("Use OrdFourByteToUInt32()") (System::Byte AByte1, System::Byte AByte2, System::Byte AByte3, System::Byte AByte4);
extern DELPHI_PACKAGE void __fastcall UInt32ToOrdFourByte(const unsigned AValue, System::Byte &VByte1, System::Byte &VByte2, System::Byte &VByte3, System::Byte &VByte4);
extern DELPHI_PACKAGE void __fastcall LongWordToOrdFourByte _DEPRECATED_ATTRIBUTE1("Use UInt32ToOrdFourByte()") (const unsigned AValue, System::Byte &VByte1, System::Byte &VByte2, System::Byte &VByte3, System::Byte &VByte4);
extern DELPHI_PACKAGE System::Word __fastcall TwoCharToUInt16(System::WideChar AChar1, System::WideChar AChar2);
extern DELPHI_PACKAGE System::Word __fastcall TwoCharToWord _DEPRECATED_ATTRIBUTE1("Use TwoCharToUInt16()") (System::WideChar AChar1, System::WideChar AChar2);
extern DELPHI_PACKAGE int __fastcall CompareDateTime(const System::TDateTime ADateTime1, const System::TDateTime ADateTime2);
extern DELPHI_PACKAGE System::TDateTime __fastcall StrInternetToDateTime(System::UnicodeString Value);
extern DELPHI_PACKAGE System::TDateTime __fastcall FTPMLSToGMTDateTime(const System::UnicodeString ATimeStamp);
extern DELPHI_PACKAGE System::TDateTime __fastcall FTPMLSToLocalDateTime(const System::UnicodeString ATimeStamp);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FTPGMTDateTimeToMLS(const System::TDateTime ATimeStamp, const bool AIncludeMSecs = true);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FTPLocalDateTimeToMLS(const System::TDateTime ATimeStamp, const bool AIncludeMSecs = true);
extern DELPHI_PACKAGE System::Classes::TStrings* __fastcall BreakApart(System::UnicodeString BaseString, System::UnicodeString BreakString, System::Classes::TStrings* StringList);
extern DELPHI_PACKAGE void __fastcall CommaSeparatedToStringList(System::Classes::TStrings* AList, const System::UnicodeString Value);
extern DELPHI_PACKAGE bool __fastcall CopyFileTo(const System::UnicodeString Source, const System::UnicodeString Destination);
extern DELPHI_PACKAGE System::UnicodeString __fastcall MakeTempFilename(const System::UnicodeString APath = System::UnicodeString());
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetUniqueFileName(const System::UnicodeString APath, const System::UnicodeString APrefix, const System::UnicodeString AExt);
extern DELPHI_PACKAGE int __fastcall RPos(const System::UnicodeString ASub, const System::UnicodeString AIn, int AStart = 0xffffffff);
extern DELPHI_PACKAGE bool __fastcall IsVolume(const System::UnicodeString APathName);
extern DELPHI_PACKAGE __int64 __fastcall FileSizeByName(const System::UnicodeString AFilename);
extern DELPHI_PACKAGE System::TDateTime __fastcall GetGMTDateByName(const System::UnicodeString AFileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall RightStr(const System::UnicodeString AStr, const int Len);
extern DELPHI_PACKAGE System::TDateTime __fastcall TimeZoneBias(void);
extern DELPHI_PACKAGE bool __fastcall IndyStrToBool(const System::UnicodeString AString);
extern DELPHI_PACKAGE bool __fastcall IndySetLocalTime(System::TDateTime Value);
extern DELPHI_PACKAGE System::Byte __fastcall StrToDay(const System::UnicodeString ADay);
extern DELPHI_PACKAGE System::Byte __fastcall StrToMonth(const System::UnicodeString AMonth);
extern DELPHI_PACKAGE System::UnicodeString __fastcall UpCaseFirst(const System::UnicodeString AStr);
extern DELPHI_PACKAGE System::UnicodeString __fastcall UpCaseFirstWord(const System::UnicodeString AStr);
extern DELPHI_PACKAGE bool __fastcall IsHex(const System::WideChar AChar);
extern DELPHI_PACKAGE bool __fastcall IsBinary(const System::WideChar AChar);
extern DELPHI_PACKAGE int __fastcall BinStrToInt(const System::UnicodeString ABinary);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ABNFToText(const System::UnicodeString AText);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetMIMETypeFromFile(const System::UnicodeString AFile);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetMIMEDefaultFileExt(const System::UnicodeString MIMEType);
extern DELPHI_PACKAGE System::TDateTime __fastcall GmtOffsetStrToDateTime(const System::UnicodeString S);
extern DELPHI_PACKAGE System::TDateTime __fastcall GMTToLocalDateTime(System::UnicodeString S);
extern DELPHI_PACKAGE System::TDateTime __fastcall CookieStrToLocalDateTime(System::UnicodeString S);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IntToBin(unsigned Value);
extern DELPHI_PACKAGE bool __fastcall IsValidIP(const System::UnicodeString S);
extern DELPHI_PACKAGE bool __fastcall IsHostname(const System::UnicodeString S);
extern DELPHI_PACKAGE bool __fastcall IsTopDomain(const System::UnicodeString AStr);
extern DELPHI_PACKAGE bool __fastcall IsDomain(const System::UnicodeString S);
extern DELPHI_PACKAGE System::UnicodeString __fastcall DomainName(const System::UnicodeString AHost);
extern DELPHI_PACKAGE bool __fastcall IsFQDN(const System::UnicodeString S);
extern DELPHI_PACKAGE System::UnicodeString __fastcall PadString(const System::UnicodeString AString, const int ALen, const System::WideChar AChar);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ProcessPath(const System::UnicodeString ABasePath, const System::UnicodeString APath, const System::UnicodeString APathDelim = L"/");
extern DELPHI_PACKAGE void __fastcall ParseMetaHTTPEquiv(System::Classes::TStream* AStream, System::Classes::TStrings* AHeaders, System::UnicodeString &VCharSet);
extern DELPHI_PACKAGE System::UnicodeString __fastcall EnsureMsgIDBrackets(const System::UnicodeString AMsgID);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ExtractHeaderItem(const System::UnicodeString AHeaderLine);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ExtractHeaderSubItem(const System::UnicodeString AHeaderLine, const System::UnicodeString ASubItem, TIdHeaderQuotingType AQuoteType);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ReplaceHeaderSubItem(const System::UnicodeString AHeaderLine, const System::UnicodeString ASubItem, const System::UnicodeString AValue, TIdHeaderQuotingType AQuoteType)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall ReplaceHeaderSubItem(const System::UnicodeString AHeaderLine, const System::UnicodeString ASubItem, const System::UnicodeString AValue, System::UnicodeString &VOld, TIdHeaderQuotingType AQuoteType)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsHeaderMediaType(const System::UnicodeString AHeaderLine, const System::UnicodeString AMediaType);
extern DELPHI_PACKAGE bool __fastcall IsHeaderMediaTypes(const System::UnicodeString AHeaderLine, System::UnicodeString const *AMediaTypes, const int AMediaTypes_Size);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ExtractHeaderMediaType(const System::UnicodeString AHeaderLine);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ExtractHeaderMediaSubType(const System::UnicodeString AHeaderLine);
extern DELPHI_PACKAGE bool __fastcall IsHeaderValue(const System::UnicodeString AHeaderLine, const System::UnicodeString AValue)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsHeaderValue(const System::UnicodeString AHeaderLine, System::UnicodeString const *AValues, const int AValues_Size)/* overload */;
extern DELPHI_PACKAGE __int64 __fastcall GetClockValue(void);
extern DELPHI_PACKAGE unsigned __fastcall ROL(const unsigned AVal, System::Byte AShift);
extern DELPHI_PACKAGE unsigned __fastcall ROR(const unsigned AVal, System::Byte AShift);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IndyComputerName(void);
extern DELPHI_PACKAGE Idcharsets::TIdCharSet __fastcall IdGetDefaultCharSet(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall RemoveHeaderEntry(const System::UnicodeString AHeader, const System::UnicodeString AEntry, TIdHeaderQuotingType AQuoteType)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall RemoveHeaderEntry(const System::UnicodeString AHeader, const System::UnicodeString AEntry, System::UnicodeString &VOld, TIdHeaderQuotingType AQuoteType)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall RemoveHeaderEntries(const System::UnicodeString AHeader, System::UnicodeString const *AEntries, const int AEntries_Size, TIdHeaderQuotingType AQuoteType);
extern DELPHI_PACKAGE int __fastcall FindFirstOf(const System::UnicodeString AFind, const System::UnicodeString AText, const int ALength = 0xffffffff, const int AStartPos = 0x1);
extern DELPHI_PACKAGE int __fastcall FindFirstNotOf(const System::UnicodeString AFind, const System::UnicodeString AText, const int ALength = 0xffffffff, const int AStartPos = 0x1);
extern DELPHI_PACKAGE System::UnicodeString __fastcall TrimAllOf(const System::UnicodeString ATrim, const System::UnicodeString AText);
extern DELPHI_PACKAGE Idglobal::_di_IIdTextEncoding __fastcall ContentTypeToEncoding(const System::UnicodeString AContentType, TIdHeaderQuotingType AQuoteType);
extern DELPHI_PACKAGE Idglobal::_di_IIdTextEncoding __fastcall CharsetToEncoding(const System::UnicodeString ACharset);
extern DELPHI_PACKAGE void __fastcall WriteStringAsContentType(System::Classes::TStream* AStream, const System::UnicodeString AStr, const System::UnicodeString AContentType, TIdHeaderQuotingType AQuoteType);
extern DELPHI_PACKAGE void __fastcall WriteStringsAsContentType(System::Classes::TStream* AStream, System::Classes::TStrings* const AStrings, const System::UnicodeString AContentType, TIdHeaderQuotingType AQuoteType);
extern DELPHI_PACKAGE void __fastcall WriteStringAsCharset(System::Classes::TStream* AStream, const System::UnicodeString AStr, const System::UnicodeString ACharset);
extern DELPHI_PACKAGE void __fastcall WriteStringsAsCharset(System::Classes::TStream* AStream, System::Classes::TStrings* const AStrings, const System::UnicodeString ACharset);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ReadStringAsContentType(System::Classes::TStream* AStream, const System::UnicodeString AContentType, TIdHeaderQuotingType AQuoteType);
extern DELPHI_PACKAGE void __fastcall ReadStringsAsContentType(System::Classes::TStream* AStream, System::Classes::TStrings* AStrings, const System::UnicodeString AContentType, TIdHeaderQuotingType AQuoteType);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ReadStringAsCharset(System::Classes::TStream* AStream, const System::UnicodeString ACharset);
extern DELPHI_PACKAGE void __fastcall ReadStringsAsCharset(System::Classes::TStream* AStream, System::Classes::TStrings* AStrings, const System::UnicodeString ACharset);
}	/* namespace Idglobalprotocols */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDGLOBALPROTOCOLS)
using namespace Idglobalprotocols;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdglobalprotocolsHPP
