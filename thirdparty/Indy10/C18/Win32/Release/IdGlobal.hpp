// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdGlobal.pas' rev: 25.00 (Windows)

#ifndef IdglobalHPP
#define IdglobalHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <System.SyncObjs.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------
#define gsIdVersionMajor 10
#define gsIdVersionMinor 6
#define gsIdVersionRelease 2
#define gsIdVersionBuild 0

// These are helper macros to handle differences between C++Builder versions
#define TIdTextEncoding_ASCII IndyTextEncoding_ASCII()
#define TIdTextEncoding_BigEndianUnicode IndyTextEncoding_UTF16BE()
#define TIdTextEncoding_Default IndyTextEncoding_OSDefault()
#define TIdTextEncoding_Unicode IndyTextEncoding_UTF16LE()
#define TIdTextEncoding_UTF7 IndyTextEncoding_UTF7()
#define TIdTextEncoding_UTF8 IndyTextEncoding_UTF8()

// These are for backwards compatibility with earlier Indy 10 releases
#define enDefault ( ( IIdTextEncoding* )NULL )
#define en8Bit IndyTextEncoding_8Bit()
#define en7Bit IndyTextEncoding_ASCII()
#define enUTF8 IndyTextEncoding_UTF8()

namespace Idglobal
{
    struct TIdIPv6Address
    {
        ::System::Word data[8];
        ::System::Word& operator[](int index) { return data[index]; }
        const ::System::Word& operator[](int index) const { return data[index]; }
        operator const ::System::Word*() const { return data; }
        operator ::System::Word*() { return data; }
    };
}

namespace Idglobal
{
//-- type declarations -------------------------------------------------------
typedef unsigned __int64 TIdUInt64;

typedef unsigned TIdPID;

typedef unsigned TIdThreadId;

typedef NativeUInt TIdThreadHandle;

typedef System::Classes::TThreadPriority TIdThreadPriority;

typedef unsigned __int64 TIdTicks;

typedef System::UnicodeString TIdUnicodeString;

typedef char TIdAnsiChar;

typedef char * PIdAnsiChar;

typedef System::PPAnsiChar PPIdAnsiChar;

typedef System::WideChar TIdWideChar;

typedef System::WideChar * PIdWideChar;

typedef System::UnicodeString TIdPlatformString;

typedef System::WideChar TIdPlatformChar;

typedef System::WideChar * PIdPlatformChar;

typedef System::DynamicArray<System::Byte> TIdBytes;

typedef System::DynamicArray<System::WideChar> TIdWideChars;

typedef NativeInt TIdNativeInt;

typedef NativeUInt TIdNativeUInt;

typedef NativeInt PtrInt;

typedef NativeUInt PtrUInt;

typedef __int64 TIdStreamSize;

typedef NativeUInt TIdLibHandle;

typedef System::UnicodeString TIdLibFuncName;

typedef System::WideChar * PIdLibFuncNameChar;

__interface IIdTextEncoding;
typedef System::DelphiInterface<IIdTextEncoding> _di_IIdTextEncoding;
__interface  INTERFACE_UUID("{FA87FAE5-E3E3-4632-8FCA-2FB786848655}") IIdTextEncoding  : public System::IInterface 
{
	
public:
	virtual int __fastcall GetByteCount(const TIdWideChars AChars) = 0 /* overload */;
	virtual int __fastcall GetByteCount(const TIdWideChars AChars, int ACharIndex, int ACharCount) = 0 /* overload */;
	virtual int __fastcall GetByteCount(const System::WideChar * AChars, int ACharCount) = 0 /* overload */;
	virtual int __fastcall GetByteCount(const System::UnicodeString AStr) = 0 /* overload */;
	virtual int __fastcall GetByteCount(const System::UnicodeString AStr, int ACharIndex, int ACharCount) = 0 /* overload */;
	virtual TIdBytes __fastcall GetBytes(const TIdWideChars AChars) = 0 /* overload */;
	virtual TIdBytes __fastcall GetBytes(const TIdWideChars AChars, int ACharIndex, int ACharCount) = 0 /* overload */;
	virtual int __fastcall GetBytes(const TIdWideChars AChars, int ACharIndex, int ACharCount, TIdBytes &VBytes, int AByteIndex) = 0 /* overload */;
	virtual TIdBytes __fastcall GetBytes(const System::WideChar * AChars, int ACharCount) = 0 /* overload */;
	virtual int __fastcall GetBytes(const System::WideChar * AChars, int ACharCount, TIdBytes &VBytes, int AByteIndex) = 0 /* overload */;
	virtual int __fastcall GetBytes(const System::WideChar * AChars, int ACharCount, System::PByte ABytes, int AByteCount) = 0 /* overload */;
	virtual TIdBytes __fastcall GetBytes(const System::UnicodeString AStr) = 0 /* overload */;
	virtual TIdBytes __fastcall GetBytes(const System::UnicodeString AStr, int ACharIndex, int ACharCount) = 0 /* overload */;
	virtual int __fastcall GetBytes(const System::UnicodeString AStr, int ACharIndex, int ACharCount, TIdBytes &VBytes, int AByteIndex) = 0 /* overload */;
	virtual int __fastcall GetCharCount(const TIdBytes ABytes) = 0 /* overload */;
	virtual int __fastcall GetCharCount(const TIdBytes ABytes, int AByteIndex, int AByteCount) = 0 /* overload */;
	virtual int __fastcall GetCharCount(const System::PByte ABytes, int AByteCount) = 0 /* overload */;
	virtual TIdWideChars __fastcall GetChars(const TIdBytes ABytes) = 0 /* overload */;
	virtual TIdWideChars __fastcall GetChars(const TIdBytes ABytes, int AByteIndex, int AByteCount) = 0 /* overload */;
	virtual int __fastcall GetChars(const TIdBytes ABytes, int AByteIndex, int AByteCount, TIdWideChars &VChars, int ACharIndex) = 0 /* overload */;
	virtual TIdWideChars __fastcall GetChars(const System::PByte ABytes, int AByteCount) = 0 /* overload */;
	virtual int __fastcall GetChars(const System::PByte ABytes, int AByteCount, TIdWideChars &VChars, int ACharIndex) = 0 /* overload */;
	virtual int __fastcall GetChars(const System::PByte ABytes, int AByteCount, System::WideChar * AChars, int ACharCount) = 0 /* overload */;
	virtual bool __fastcall GetIsSingleByte(void) = 0 ;
	virtual int __fastcall GetMaxByteCount(int ACharCount) = 0 ;
	virtual int __fastcall GetMaxCharCount(int AByteCount) = 0 ;
	virtual TIdBytes __fastcall GetPreamble(void) = 0 ;
	virtual System::UnicodeString __fastcall GetString(const TIdBytes ABytes) = 0 /* overload */;
	virtual System::UnicodeString __fastcall GetString(const TIdBytes ABytes, int AByteIndex, int AByteCount) = 0 /* overload */;
	virtual System::UnicodeString __fastcall GetString(const System::PByte ABytes, int AByteCount) = 0 /* overload */;
	__property bool IsSingleByte = {read=GetIsSingleByte};
};

enum DECLSPEC_DENUM IdTextEncodingType : unsigned char { encIndyDefault, encOSDefault, enc8Bit, encASCII, encUTF16BE, encUTF16LE, encUTF7, encUTF8 };

class DELPHICLASS TIdAppendFileStream;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdAppendFileStream : public System::Classes::TFileStream
{
	typedef System::Classes::TFileStream inherited;
	
public:
	__fastcall TIdAppendFileStream(const System::UnicodeString AFile);
public:
	/* TFileStream.Destroy */ inline __fastcall virtual ~TIdAppendFileStream(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdReadFileExclusiveStream;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdReadFileExclusiveStream : public System::Classes::TFileStream
{
	typedef System::Classes::TFileStream inherited;
	
public:
	__fastcall TIdReadFileExclusiveStream(const System::UnicodeString AFile);
public:
	/* TFileStream.Destroy */ inline __fastcall virtual ~TIdReadFileExclusiveStream(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdReadFileNonExclusiveStream;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdReadFileNonExclusiveStream : public System::Classes::TFileStream
{
	typedef System::Classes::TFileStream inherited;
	
public:
	__fastcall TIdReadFileNonExclusiveStream(const System::UnicodeString AFile);
public:
	/* TFileStream.Destroy */ inline __fastcall virtual ~TIdReadFileNonExclusiveStream(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdFileCreateStream;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdFileCreateStream : public System::Classes::TFileStream
{
	typedef System::Classes::TFileStream inherited;
	
public:
	__fastcall TIdFileCreateStream(const System::UnicodeString AFile);
public:
	/* TFileStream.Destroy */ inline __fastcall virtual ~TIdFileCreateStream(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdLocalEvent;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdLocalEvent : public System::Syncobjs::TEvent
{
	typedef System::Syncobjs::TEvent inherited;
	
public:
	__fastcall TIdLocalEvent(const bool AInitialState, const bool AManualReset);
	System::Syncobjs::TWaitResult __fastcall WaitForEver(void)/* overload */;
public:
	/* THandleObject.Destroy */ inline __fastcall virtual ~TIdLocalEvent(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdCriticalSection;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdCriticalSection : public System::Syncobjs::TCriticalSection
{
	typedef System::Syncobjs::TCriticalSection inherited;
	
public:
	/* TCriticalSection.Create */ inline __fastcall TIdCriticalSection(void) : System::Syncobjs::TCriticalSection() { }
	/* TCriticalSection.Destroy */ inline __fastcall virtual ~TIdCriticalSection(void) { }
	
};

#pragma pack(pop)

typedef short *PShort;

class DELPHICLASS EIdCorruptServicesFile;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdCorruptServicesFile : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdCorruptServicesFile(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdCorruptServicesFile(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdCorruptServicesFile(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdCorruptServicesFile(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCorruptServicesFile(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdCorruptServicesFile(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdCorruptServicesFile(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdCorruptServicesFile(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCorruptServicesFile(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdCorruptServicesFile(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCorruptServicesFile(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdCorruptServicesFile(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdCorruptServicesFile(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdEndOfStream;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdEndOfStream : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdEndOfStream(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdEndOfStream(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdEndOfStream(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdEndOfStream(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdEndOfStream(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdEndOfStream(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdEndOfStream(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdEndOfStream(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdEndOfStream(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdEndOfStream(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdEndOfStream(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdEndOfStream(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdEndOfStream(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdInvalidIPv6Address;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdInvalidIPv6Address : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdInvalidIPv6Address(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdInvalidIPv6Address(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidIPv6Address(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdInvalidIPv6Address(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidIPv6Address(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdInvalidIPv6Address(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdInvalidIPv6Address(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdInvalidIPv6Address(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidIPv6Address(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdInvalidIPv6Address(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidIPv6Address(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdInvalidIPv6Address(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdInvalidIPv6Address(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdNoEncodingSpecified;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNoEncodingSpecified : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNoEncodingSpecified(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNoEncodingSpecified(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNoEncodingSpecified(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNoEncodingSpecified(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNoEncodingSpecified(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNoEncodingSpecified(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNoEncodingSpecified(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNoEncodingSpecified(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNoEncodingSpecified(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNoEncodingSpecified(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNoEncodingSpecified(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNoEncodingSpecified(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNoEncodingSpecified(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdFailedToRetreiveTimeZoneInfo;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdFailedToRetreiveTimeZoneInfo : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdFailedToRetreiveTimeZoneInfo(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdFailedToRetreiveTimeZoneInfo(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdFailedToRetreiveTimeZoneInfo(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdFailedToRetreiveTimeZoneInfo(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFailedToRetreiveTimeZoneInfo(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdFailedToRetreiveTimeZoneInfo(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdFailedToRetreiveTimeZoneInfo(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdFailedToRetreiveTimeZoneInfo(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFailedToRetreiveTimeZoneInfo(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdFailedToRetreiveTimeZoneInfo(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFailedToRetreiveTimeZoneInfo(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdFailedToRetreiveTimeZoneInfo(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdFailedToRetreiveTimeZoneInfo(void) { }
	
};

#pragma pack(pop)

typedef System::Word TIdPort;

enum DECLSPEC_DENUM TIdMaxLineAction : unsigned char { maException, maSplit };

enum DECLSPEC_DENUM TIdOSType : unsigned char { otUnknown, otUnix, otWindows, otDotNet };

enum DECLSPEC_DENUM TIdIPVersion : unsigned char { Id_IPv4, Id_IPv6 };

typedef int __fastcall (*TPosProc)(const System::UnicodeString substr, const System::UnicodeString str);

typedef System::WideChar * __fastcall (*TStrScanProc)(System::WideChar * Str, System::WideChar Chr);

enum DECLSPEC_DENUM TIdReuseSocket : unsigned char { rsOSDependent, rsTrue, rsFalse };

class DELPHICLASS TIdBaseStream;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdBaseStream : public System::Classes::TStream
{
	typedef System::Classes::TStream inherited;
	
protected:
	virtual int __fastcall IdRead(TIdBytes &VBuffer, int AOffset, int ACount) = 0 ;
	virtual int __fastcall IdWrite(const TIdBytes ABuffer, int AOffset, int ACount) = 0 ;
	virtual __int64 __fastcall IdSeek(const __int64 AOffset, System::Classes::TSeekOrigin AOrigin) = 0 ;
	virtual void __fastcall IdSetSize(__int64 ASize) = 0 ;
	virtual void __fastcall SetSize(const __int64 NewSize)/* overload */;
	
public:
	virtual int __fastcall Read(void *Buffer, int Count)/* overload */;
	virtual int __fastcall Write(const void *Buffer, int Count)/* overload */;
	virtual __int64 __fastcall Seek(const __int64 Offset, System::Classes::TSeekOrigin Origin)/* overload */;
public:
	/* TObject.Create */ inline __fastcall TIdBaseStream(void) : System::Classes::TStream() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdBaseStream(void) { }
	
/* Hoisted overloads: */
	
protected:
	inline void __fastcall  SetSize(int NewSize){ System::Classes::TStream::SetSize(NewSize); }
	
public:
	inline int __fastcall  Read(System::DynamicArray<System::Byte> Buffer, int Offset, int Count){ return System::Classes::TStream::Read(Buffer, Offset, Count); }
	inline int __fastcall  Read(System::DynamicArray<System::Byte> &Buffer, int Count){ return System::Classes::TStream::Read(Buffer, Count); }
	inline int __fastcall  Write(const System::DynamicArray<System::Byte> Buffer, int Offset, int Count){ return System::Classes::TStream::Write(Buffer, Offset, Count); }
	inline int __fastcall  Write(const System::DynamicArray<System::Byte> Buffer, int Count){ return System::Classes::TStream::Write(Buffer, Count); }
	inline int __fastcall  Seek(int Offset, System::Word Origin){ return System::Classes::TStream::Seek(Offset, Origin); }
	inline __int64 __fastcall  Seek _DEPRECATED_ATTRIBUTE0 (const __int64 Offset, System::Word Origin){ return System::Classes::TStream::Seek(Offset, Origin); }
	
};

#pragma pack(pop)

class DELPHICLASS TIdCalculateSizeStream;
class PASCALIMPLEMENTATION TIdCalculateSizeStream : public TIdBaseStream
{
	typedef TIdBaseStream inherited;
	
protected:
	__int64 FPosition;
	__int64 FSize;
	virtual int __fastcall IdRead(TIdBytes &VBuffer, int AOffset, int ACount);
	virtual int __fastcall IdWrite(const TIdBytes ABuffer, int AOffset, int ACount);
	virtual __int64 __fastcall IdSeek(const __int64 AOffset, System::Classes::TSeekOrigin AOrigin);
	virtual void __fastcall IdSetSize(__int64 ASize);
public:
	/* TObject.Create */ inline __fastcall TIdCalculateSizeStream(void) : TIdBaseStream() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdCalculateSizeStream(void) { }
	
};


typedef void __fastcall (__closure *TIdStreamReadEvent)(TIdBytes &VBuffer, int AOffset, int ACount, int &VResult);

typedef void __fastcall (__closure *TIdStreamWriteEvent)(const TIdBytes ABuffer, int AOffset, int ACount, int &VResult);

typedef void __fastcall (__closure *TIdStreamSeekEvent)(const __int64 AOffset, System::Classes::TSeekOrigin AOrigin, __int64 &VPosition);

typedef void __fastcall (__closure *TIdStreamSetSizeEvent)(const __int64 ANewSize);

class DELPHICLASS TIdEventStream;
class PASCALIMPLEMENTATION TIdEventStream : public TIdBaseStream
{
	typedef TIdBaseStream inherited;
	
protected:
	TIdStreamReadEvent FOnRead;
	TIdStreamWriteEvent FOnWrite;
	TIdStreamSeekEvent FOnSeek;
	TIdStreamSetSizeEvent FOnSetSize;
	virtual int __fastcall IdRead(TIdBytes &VBuffer, int AOffset, int ACount);
	virtual int __fastcall IdWrite(const TIdBytes ABuffer, int AOffset, int ACount);
	virtual __int64 __fastcall IdSeek(const __int64 AOffset, System::Classes::TSeekOrigin AOrigin);
	virtual void __fastcall IdSetSize(__int64 ASize);
	
public:
	__property TIdStreamReadEvent OnRead = {read=FOnRead, write=FOnRead};
	__property TIdStreamWriteEvent OnWrite = {read=FOnWrite, write=FOnWrite};
	__property TIdStreamSeekEvent OnSeek = {read=FOnSeek, write=FOnSeek};
	__property TIdStreamSetSizeEvent OnSetSize = {read=FOnSetSize, write=FOnSetSize};
public:
	/* TObject.Create */ inline __fastcall TIdEventStream(void) : TIdBaseStream() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdEventStream(void) { }
	
};


class DELPHICLASS TIdMemoryBufferStream;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMemoryBufferStream : public System::Classes::TCustomMemoryStream
{
	typedef System::Classes::TCustomMemoryStream inherited;
	
public:
	__fastcall TIdMemoryBufferStream(void * APtr, NativeInt ASize);
	virtual int __fastcall Write(const void *Buffer, int Count)/* overload */;
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdMemoryBufferStream(void) { }
	
/* Hoisted overloads: */
	
public:
	inline int __fastcall  Write(const System::DynamicArray<System::Byte> Buffer, int Offset, int Count){ return System::Classes::TStream::Write(Buffer, Offset, Count); }
	inline int __fastcall  Write(const System::DynamicArray<System::Byte> Buffer, int Count){ return System::Classes::TStream::Write(Buffer, Count); }
	
};

#pragma pack(pop)

class DELPHICLASS TIdReadOnlyMemoryBufferStream;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdReadOnlyMemoryBufferStream : public TIdMemoryBufferStream
{
	typedef TIdMemoryBufferStream inherited;
	
public:
	virtual int __fastcall Write(const void *Buffer, int Count)/* overload */;
public:
	/* TIdMemoryBufferStream.Create */ inline __fastcall TIdReadOnlyMemoryBufferStream(void * APtr, NativeInt ASize) : TIdMemoryBufferStream(APtr, ASize) { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdReadOnlyMemoryBufferStream(void) { }
	
/* Hoisted overloads: */
	
public:
	inline int __fastcall  Write(const System::DynamicArray<System::Byte> Buffer, int Offset, int Count){ return System::Classes::TStream::Write(Buffer, Offset, Count); }
	inline int __fastcall  Write(const System::DynamicArray<System::Byte> Buffer, int Count){ return System::Classes::TStream::Write(Buffer, Count); }
	
};

#pragma pack(pop)

typedef System::Classes::TList TIdPortList;

//-- var, const, procedure ---------------------------------------------------
#define gsIdVersion L"10.6.2.0"
#define gsIdProductName L"Indy"
#define gsIdProductVersion L"10.6.2"
static const NativeUInt IdNilHandle = NativeUInt(0x0);
static const System::WideChar LF = (System::WideChar)(0xa);
static const System::WideChar CR = (System::WideChar)(0xd);
#define EOL L"\r\n"
static const System::WideChar CHAR0 = (System::WideChar)(0x0);
static const System::WideChar BACKSPACE = (System::WideChar)(0x8);
static const System::WideChar TAB = (System::WideChar)(0x9);
static const System::WideChar CHAR32 = (System::WideChar)(0x20);
static const System::Int8 IdTimeoutDefault = System::Int8(-1);
static const System::Int8 IdTimeoutInfinite = System::Int8(-2);
static const System::WideChar IdFetchDelimDefault = (System::WideChar)(0x20);
static const bool IdFetchDeleteDefault = true;
static const bool IdFetchCaseSensitiveDefault = true;
#define IdWhiteSpace (System::Set<System::Byte, 0, 255> () << 0x0 << 0x1 << 0x2 << 0x3 << 0x4 << 0x5 << 0x6 << 0x7 << 0x8 << 0x9 << 0xa << 0xb << 0xc << 0xe << 0xf << 0x10 << 0x11 << 0x12 << 0x13 << 0x14 << 0x15 << 0x16 << 0x17 << 0x18 << 0x19 << 0x1a << 0x1b << 0x1c << 0x1d << 0x1e << 0x1f << 0x20 )
extern DELPHI_PACKAGE System::StaticArray<System::WideChar, 16> IdHexDigits;
extern DELPHI_PACKAGE System::StaticArray<System::WideChar, 8> IdOctalDigits;
#define IdHexPrefix L"0x"
static const System::Int8 DEF_PORT_ANY = System::Int8(0x0);
extern DELPHI_PACKAGE IdTextEncodingType GIdDefaultTextEncoding;
static const TIdOSType GOSType = (TIdOSType)(2);
static const System::WideChar GPathDelim = (System::WideChar)(0x5c);
static const unsigned Infinite = unsigned(0xffffffff);
static const TIdIPVersion ID_DEFAULT_IP_VERSION = (TIdIPVersion)(0);
static const System::Byte POWER_1 = System::Byte(0xff);
static const System::Word POWER_2 = System::Word(0xffff);
static const int POWER_3 = int(0xffffff);
static const unsigned POWER_4 = unsigned(0xffffffff);
extern DELPHI_PACKAGE TPosProc IndyPos;
extern DELPHI_PACKAGE void __fastcall EnsureEncoding(_di_IIdTextEncoding &VEncoding, IdTextEncodingType ADefEncoding = (IdTextEncodingType)(0x0));
extern DELPHI_PACKAGE void __fastcall CheckByteEncoding(TIdBytes &VBytes, _di_IIdTextEncoding ASrcEncoding, _di_IIdTextEncoding ADestEncoding);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyTextEncoding(IdTextEncodingType AType)/* overload */;
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyTextEncoding(System::Word ACodepage)/* overload */;
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyTextEncoding(const System::UnicodeString ACharSet)/* overload */;
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyTextEncoding(System::Sysutils::TEncoding* AEncoding, bool AFreeEncoding = false)/* overload */;
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyTextEncoding_Default(void);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyTextEncoding_OSDefault(void);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyTextEncoding_8Bit(void);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyTextEncoding_ASCII(void);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyTextEncoding_UTF16BE(void);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyTextEncoding_UTF16LE(void);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyTextEncoding_UTF7(void);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyTextEncoding_UTF8(void);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall Indy8BitEncoding _DEPRECATED_ATTRIBUTE1("Use IndyTextEncoding_8Bit()") (const bool AOwnedByIndy = true);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyASCIIEncoding _DEPRECATED_ATTRIBUTE1("Use IndyTextEncoding_ASCII()") (const bool AOwnedByIndy = true);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyUTF16BigEndianEncoding _DEPRECATED_ATTRIBUTE1("Use IndyTextEncoding_UTF16BE()") (const bool AOwnedByIndy = true);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyUTF16LittleEndianEncoding _DEPRECATED_ATTRIBUTE1("Use IndyTextEncoding_UTF16LE()") (const bool AOwnedByIndy = true);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyOSDefaultEncoding _DEPRECATED_ATTRIBUTE1("Use IndyTextEncoding_OSDefault()") (const bool AOwnedByIndy = true);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyUTF7Encoding _DEPRECATED_ATTRIBUTE1("Use IndyTextEncoding_UTF7()") (const bool AOwnedByIndy = true);
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall IndyUTF8Encoding _DEPRECATED_ATTRIBUTE1("Use IndyTextEncoding_UTF8()") (const bool AOwnedByIndy = true);
extern DELPHI_PACKAGE System::Word __fastcall GetEncodingCodePage(_di_IIdTextEncoding AEncoding);
extern DELPHI_PACKAGE void * __fastcall LoadLibFunction(const NativeUInt ALibHandle, const System::UnicodeString AProcName);
extern DELPHI_PACKAGE void __fastcall IndyRaiseLastError(void);
extern DELPHI_PACKAGE void __fastcall IndyRaiseOuterException(System::Sysutils::Exception* AOuterException);
extern DELPHI_PACKAGE NativeUInt __fastcall InterlockedExchangeTHandle(NativeUInt &VTarget, const NativeUInt AValue);
extern DELPHI_PACKAGE NativeUInt __fastcall InterlockedExchangeTLibHandle(NativeUInt &VTarget, const NativeUInt AValue);
extern DELPHI_PACKAGE void * __fastcall InterlockedCompareExchangePtr(void * &VTarget, const void * AValue, const void * Compare);
extern DELPHI_PACKAGE System::TObject* __fastcall InterlockedCompareExchangeObj(System::TObject* &VTarget, System::TObject* const AValue, System::TObject* const Compare);
extern DELPHI_PACKAGE System::_di_IInterface __fastcall InterlockedCompareExchangeIntf(System::_di_IInterface &VTarget, const System::_di_IInterface AValue, const System::_di_IInterface Compare);
extern DELPHI_PACKAGE System::Word __fastcall HostToLittleEndian(const System::Word AValue)/* overload */;
extern DELPHI_PACKAGE unsigned __fastcall HostToLittleEndian(const unsigned AValue)/* overload */;
extern DELPHI_PACKAGE int __fastcall HostToLittleEndian(const int AValue)/* overload */;
extern DELPHI_PACKAGE System::Word __fastcall LittleEndianToHost(const System::Word AValue)/* overload */;
extern DELPHI_PACKAGE unsigned __fastcall LittleEndianToHost(const unsigned AValue)/* overload */;
extern DELPHI_PACKAGE int __fastcall LittleEndianToHost(const int AValue)/* overload */;
extern DELPHI_PACKAGE void __fastcall FillBytes(TIdBytes &VBytes, const int ACount, const System::Byte AValue);
extern DELPHI_PACKAGE bool __fastcall IsASCIILDH(const System::Byte AByte)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsASCIILDH(const TIdBytes ABytes)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsASCII(const System::Byte AByte)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsASCII(const TIdBytes ABytes)/* overload */;
extern DELPHI_PACKAGE bool __fastcall StartsWithACE(const TIdBytes ABytes);
extern DELPHI_PACKAGE int __fastcall PosInSmallIntArray(const short ASearchInt, short const *AArray, const int AArray_Size);
extern DELPHI_PACKAGE int __fastcall PosInStrArray(const System::UnicodeString SearchStr, System::UnicodeString const *Contents, const int Contents_Size, const bool CaseSensitive = true);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ByteToHex(const System::Byte AByte);
extern DELPHI_PACKAGE System::UnicodeString __fastcall UInt32ToHex(const unsigned ALongWord);
extern DELPHI_PACKAGE System::UnicodeString __fastcall LongWordToHex _DEPRECATED_ATTRIBUTE1("Use UInt32ToHex()") (const unsigned ALongWord);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ToHex(const TIdBytes AValue, const int ACount = 0xffffffff, const int AIndex = 0x0)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall ToHex(unsigned const *AValue, const int AValue_Size)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall IPv4ToHex(const System::UnicodeString AIPAddress, const bool ADotted = false);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ByteToOctal(const System::Byte AByte);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IPv4ToOctal(const System::UnicodeString AIPAddress);
extern DELPHI_PACKAGE void __fastcall CopyTIdBytes(const TIdBytes ASource, const int ASourceIndex, TIdBytes &VDest, const int ADestIndex, const int ALength);
extern DELPHI_PACKAGE void __fastcall CopyTIdChar(const System::WideChar ASource, TIdBytes &VDest, const int ADestIndex, _di_IIdTextEncoding ADestEncoding = _di_IIdTextEncoding());
extern DELPHI_PACKAGE void __fastcall CopyTIdInt16(const short ASource, TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdShort _DEPRECATED_ATTRIBUTE1("Use CopyTIdInt16()") (const short ASource, TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdUInt16(const System::Word ASource, TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdWord _DEPRECATED_ATTRIBUTE1("Use CopyTIdUInt16()") (const System::Word ASource, TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdUInt32(const unsigned ASource, TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdLongWord _DEPRECATED_ATTRIBUTE1("Use CopyTIdUInt32()") (const unsigned ASource, TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdInt32(const int ASource, TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdLongInt _DEPRECATED_ATTRIBUTE1("Use CopyTIdInt32()") (const int ASource, TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdInt64(const __int64 ASource, TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdUInt64(const unsigned __int64 ASource, TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdTicks(const unsigned __int64 ASource, TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdIPV6Address(const TIdIPv6Address &ASource, TIdBytes &VDest, const int ADestIndex);
extern DELPHI_PACKAGE void __fastcall CopyTIdByteArray(System::Byte const *ASource, const int ASource_Size, const int ASourceIndex, TIdBytes &VDest, const int ADestIndex, const int ALength);
extern DELPHI_PACKAGE void __fastcall CopyTIdString(const System::UnicodeString ASource, TIdBytes &VDest, const int ADestIndex, const int ALength = 0xffffffff, _di_IIdTextEncoding ADestEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE void __fastcall CopyTIdString(const System::UnicodeString ASource, const int ASourceIndex, TIdBytes &VDest, const int ADestIndex, const int ALength = 0xffffffff, _di_IIdTextEncoding ADestEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE void __fastcall DebugOutput(const System::UnicodeString AText);
extern DELPHI_PACKAGE unsigned __fastcall CurrentThreadId(void);
extern DELPHI_PACKAGE unsigned __fastcall CurrentProcessId(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall Fetch(System::UnicodeString &AInput, const System::UnicodeString ADelim = L" ", const bool ADelete = true, const bool ACaseSensitive = true);
extern DELPHI_PACKAGE System::UnicodeString __fastcall FetchCaseInsensitive(System::UnicodeString &AInput, const System::UnicodeString ADelim = L" ", const bool ADelete = true);
extern DELPHI_PACKAGE NativeUInt __fastcall GetThreadHandle(System::Classes::TThread* AThread);
extern DELPHI_PACKAGE unsigned __fastcall Ticks _DEPRECATED_ATTRIBUTE1("Use Ticks64()") (void);
extern DELPHI_PACKAGE unsigned __int64 __fastcall Ticks64(void);
extern DELPHI_PACKAGE unsigned __fastcall GetTickDiff _DEPRECATED_ATTRIBUTE1("Use GetTickDiff64()") (const unsigned AOldTickCount, const unsigned ANewTickCount);
extern DELPHI_PACKAGE unsigned __int64 __fastcall GetTickDiff64(const unsigned __int64 AOldTickCount, const unsigned __int64 ANewTickCount);
extern DELPHI_PACKAGE unsigned __fastcall GetElapsedTicks(const unsigned __int64 AOldTickCount);
extern DELPHI_PACKAGE unsigned __int64 __fastcall GetElapsedTicks64(const unsigned __int64 AOldTickCount);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ServicesFilePath(void);
extern DELPHI_PACKAGE System::Classes::TList* __fastcall IdPorts(void);
extern DELPHI_PACKAGE int __fastcall iif(bool ATest, const int ATrue, const int AFalse)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall iif(bool ATest, const System::UnicodeString ATrue, const System::UnicodeString AFalse = System::UnicodeString())/* overload */;
extern DELPHI_PACKAGE bool __fastcall iif(bool ATest, const bool ATrue, const bool AFalse)/* overload */;
extern DELPHI_PACKAGE _di_IIdTextEncoding __fastcall iif(const _di_IIdTextEncoding AEncoding, const _di_IIdTextEncoding ADefEncoding, IdTextEncodingType ADefEncodingType = (IdTextEncodingType)(0x3))/* overload */;
extern DELPHI_PACKAGE bool __fastcall InMainThread(void);
extern DELPHI_PACKAGE void __fastcall WriteMemoryStreamToStream(System::Classes::TMemoryStream* Src, System::Classes::TStream* Dest, __int64 Count);
extern DELPHI_PACKAGE bool __fastcall IsCurrentThread(System::Classes::TThread* AThread);
extern DELPHI_PACKAGE System::UnicodeString __fastcall MakeUInt32IntoIPv4Address(const unsigned ADWord);
extern DELPHI_PACKAGE System::UnicodeString __fastcall MakeDWordIntoIPv4Address _DEPRECATED_ATTRIBUTE1("Use MakeUInt32IntoIPv4Address()") (const unsigned ADWord);
extern DELPHI_PACKAGE bool __fastcall IsAlpha(const System::WideChar AChar)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsAlpha(const System::UnicodeString AString, const int ALength = 0xffffffff, const int AIndex = 0x1)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsAlphaNumeric(const System::WideChar AChar)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsAlphaNumeric(const System::UnicodeString AString, const int ALength = 0xffffffff, const int AIndex = 0x1)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsOctal(const System::WideChar AChar)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsOctal(const System::UnicodeString AString, const int ALength = 0xffffffff, const int AIndex = 0x1)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsHexidecimal(const System::WideChar AChar)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsHexidecimal(const System::UnicodeString AString, const int ALength = 0xffffffff, const int AIndex = 0x1)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsNumeric(const System::UnicodeString AString)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsNumeric(const System::UnicodeString AString, const int ALength, const int AIndex = 0x1)/* overload */;
extern DELPHI_PACKAGE bool __fastcall IsNumeric(const System::WideChar AChar)/* overload */;
extern DELPHI_PACKAGE unsigned __fastcall IPv4MakeUInt32InRange(const __int64 AInt, const int A256Power);
extern DELPHI_PACKAGE unsigned __fastcall IPv4MakeLongWordInRange _DEPRECATED_ATTRIBUTE1("Use IPv4MakeUInt32InRange()") (const __int64 AInt, const int A256Power);
extern DELPHI_PACKAGE unsigned __fastcall IPv4ToUInt32(const System::UnicodeString AIPAddress)/* overload */;
extern DELPHI_PACKAGE unsigned __fastcall IPv4ToDWord _DEPRECATED_ATTRIBUTE1("Use IPv4ToUInt32()") (const System::UnicodeString AIPAddress)/* overload */;
extern DELPHI_PACKAGE unsigned __fastcall IPv4ToUInt32(const System::UnicodeString AIPAddress, bool &VErr)/* overload */;
extern DELPHI_PACKAGE unsigned __fastcall IPv4ToDWord _DEPRECATED_ATTRIBUTE1("Use IPv4ToUInt32()") (const System::UnicodeString AIPAddress, bool &VErr)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall IPv6AddressToStr(const TIdIPv6Address &AValue);
extern DELPHI_PACKAGE System::UnicodeString __fastcall MakeCanonicalIPv4Address(const System::UnicodeString AAddr);
extern DELPHI_PACKAGE System::UnicodeString __fastcall MakeCanonicalIPv6Address(const System::UnicodeString AAddr);
extern DELPHI_PACKAGE void __fastcall IPv6ToIdIPv6Address(const System::UnicodeString AIPAddress, TIdIPv6Address &VAddress)/* overload */;
extern DELPHI_PACKAGE void __fastcall IPv6ToIdIPv6Address(const System::UnicodeString AIPAddress, TIdIPv6Address &VAddress, bool &VErr)/* overload */;
extern DELPHI_PACKAGE __int64 __fastcall IndyMax(const __int64 AValueOne, const __int64 AValueTwo)/* overload */;
extern DELPHI_PACKAGE int __fastcall IndyMax(const int AValueOne, const int AValueTwo)/* overload */;
extern DELPHI_PACKAGE System::Word __fastcall IndyMax(const System::Word AValueOne, const System::Word AValueTwo)/* overload */;
extern DELPHI_PACKAGE int __fastcall MemoryPos(const System::UnicodeString ASubStr, System::WideChar * MemBuff, int MemorySize);
extern DELPHI_PACKAGE int __fastcall IndyMin(const int AValueOne, const int AValueTwo)/* overload */;
extern DELPHI_PACKAGE __int64 __fastcall IndyMin(const __int64 AValueOne, const __int64 AValueTwo)/* overload */;
extern DELPHI_PACKAGE System::Word __fastcall IndyMin(const System::Word AValueOne, const System::Word AValueTwo)/* overload */;
extern DELPHI_PACKAGE unsigned __fastcall PosIdx(const System::UnicodeString ASubStr, const System::UnicodeString AStr, unsigned AStartPos = (unsigned)(0x0));
extern DELPHI_PACKAGE void __fastcall IndySetThreadPriority(System::Classes::TThread* AThread, const System::Classes::TThreadPriority APriority, const int APolicy = 0x80000001);
extern DELPHI_PACKAGE void __fastcall IndySleep(unsigned ATime);
extern DELPHI_PACKAGE void __fastcall SplitColumnsNoTrim _DEPRECATED_ATTRIBUTE1("Use SplitDelimitedString()") (const System::UnicodeString AData, System::Classes::TStrings* AStrings, const System::UnicodeString ADelim = L" ");
extern DELPHI_PACKAGE void __fastcall SplitColumns _DEPRECATED_ATTRIBUTE1("Use SplitDelimitedString()") (const System::UnicodeString AData, System::Classes::TStrings* AStrings, const System::UnicodeString ADelim = L" ");
extern DELPHI_PACKAGE void __fastcall SplitDelimitedString(const System::UnicodeString AData, System::Classes::TStrings* AStrings, bool ATrim, const System::UnicodeString ADelim = L" ", bool AIncludePositions = false);
extern DELPHI_PACKAGE void __fastcall SetThreadName(const System::UnicodeString AName, unsigned AThreadID = (unsigned)(0xffffffff));
extern DELPHI_PACKAGE void __fastcall ToDo(const System::UnicodeString AMsg);
extern DELPHI_PACKAGE int __fastcall IndyLength(const System::UnicodeString ABuffer, const int ALength = 0xffffffff, const int AIndex = 0x1)/* overload */;
extern DELPHI_PACKAGE int __fastcall IndyLength(const TIdBytes ABuffer, const int ALength = 0xffffffff, const int AIndex = 0x0)/* overload */;
extern DELPHI_PACKAGE __int64 __fastcall IndyLength(System::Classes::TStream* const ABuffer, const __int64 ALength = -1LL)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall IndyFormat(const System::UnicodeString AFormat, System::TVarRec const *Args, const int Args_Size);
extern DELPHI_PACKAGE System::UnicodeString __fastcall DateTimeGMTToHttpStr(const System::TDateTime GMTValue);
extern DELPHI_PACKAGE System::UnicodeString __fastcall DateTimeGMTToCookieStr(const System::TDateTime GMTValue, const bool AUseNetscapeFmt = true);
extern DELPHI_PACKAGE System::UnicodeString __fastcall DateTimeGMTToImapStr(const System::TDateTime GMTValue);
extern DELPHI_PACKAGE System::UnicodeString __fastcall LocalDateTimeToHttpStr(const System::TDateTime Value);
extern DELPHI_PACKAGE System::UnicodeString __fastcall LocalDateTimeToCookieStr(const System::TDateTime Value, const bool AUseNetscapeFmt = true);
extern DELPHI_PACKAGE System::UnicodeString __fastcall LocalDateTimeToImapStr(const System::TDateTime Value);
extern DELPHI_PACKAGE System::UnicodeString __fastcall DateTimeToInternetStr _DEPRECATED_ATTRIBUTE1("Use LocalDateTimeToGMT()") (const System::TDateTime Value, const bool AUseGMTStr = false);
extern DELPHI_PACKAGE System::UnicodeString __fastcall LocalDateTimeToGMT(const System::TDateTime Value, const bool AUseGMTStr = false);
extern DELPHI_PACKAGE System::UnicodeString __fastcall DateTimeToGmtOffSetStr _DEPRECATED_ATTRIBUTE1("Use UTCOffsetToStr()") (System::TDateTime ADateTime, const bool AUseGMTStr = false);
extern DELPHI_PACKAGE System::TDateTime __fastcall OffsetFromUTC(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall UTCOffsetToStr(const System::TDateTime AOffset, const bool AUseGMTStr = false);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IndyIncludeTrailingPathDelimiter(const System::UnicodeString S);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IndyExcludeTrailingPathDelimiter(const System::UnicodeString S);
extern DELPHI_PACKAGE System::UnicodeString __fastcall StringsReplace(const System::UnicodeString S, System::UnicodeString const *OldPattern, const int OldPattern_Size, System::UnicodeString const *NewPattern, const int NewPattern_Size);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ReplaceAll(const System::UnicodeString S, const System::UnicodeString OldPattern, const System::UnicodeString NewPattern);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ReplaceOnlyFirst(const System::UnicodeString S, const System::UnicodeString OldPattern, const System::UnicodeString NewPattern);
extern DELPHI_PACKAGE int __fastcall IndyStrToInt(const System::UnicodeString S)/* overload */;
extern DELPHI_PACKAGE int __fastcall IndyStrToInt(const System::UnicodeString S, int ADefault)/* overload */;
extern DELPHI_PACKAGE int __fastcall CompareDate(const System::TDateTime D1, const System::TDateTime D2);
extern DELPHI_PACKAGE System::TDateTime __fastcall AddMSecToTime(const System::TDateTime ADateTime, const int AMSec);
extern DELPHI_PACKAGE System::TDateTime __fastcall IndyFileAge(const System::UnicodeString AFileName);
extern DELPHI_PACKAGE bool __fastcall IndyDirectoryExists(const System::UnicodeString ADirectory);
extern DELPHI_PACKAGE __int64 __fastcall IndyStrToInt64(const System::UnicodeString S, const __int64 ADefault)/* overload */;
extern DELPHI_PACKAGE __int64 __fastcall IndyStrToInt64(const System::UnicodeString S)/* overload */;
extern DELPHI_PACKAGE __int64 __fastcall IndyStrToStreamSize(const System::UnicodeString S, const __int64 ADefault)/* overload */;
extern DELPHI_PACKAGE __int64 __fastcall IndyStrToStreamSize(const System::UnicodeString S)/* overload */;
extern DELPHI_PACKAGE TIdBytes __fastcall ToBytes(const System::UnicodeString AValue, _di_IIdTextEncoding ADestEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE TIdBytes __fastcall ToBytes(const System::UnicodeString AValue, const int ALength, const int AIndex = 0x1, _di_IIdTextEncoding ADestEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE TIdBytes __fastcall ToBytes(const System::WideChar AValue, _di_IIdTextEncoding ADestEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE TIdBytes __fastcall ToBytes(const __int64 AValue)/* overload */;
extern DELPHI_PACKAGE TIdBytes __fastcall ToBytes(const unsigned __int64 AValue)/* overload */;
extern DELPHI_PACKAGE TIdBytes __fastcall ToBytes(const int AValue)/* overload */;
extern DELPHI_PACKAGE TIdBytes __fastcall ToBytes(const unsigned AValue)/* overload */;
extern DELPHI_PACKAGE TIdBytes __fastcall ToBytes(const short AValue)/* overload */;
extern DELPHI_PACKAGE TIdBytes __fastcall ToBytes(const System::Word AValue)/* overload */;
extern DELPHI_PACKAGE TIdBytes __fastcall ToBytes(const System::Int8 AValue)/* overload */;
extern DELPHI_PACKAGE TIdBytes __fastcall ToBytes(const System::Byte AValue)/* overload */;
extern DELPHI_PACKAGE TIdBytes __fastcall ToBytes(const TIdBytes AValue, const int ASize, const int AIndex = 0x0)/* overload */;
extern DELPHI_PACKAGE TIdBytes __fastcall RawToBytes(const void *AValue, const int ASize);
extern DELPHI_PACKAGE void __fastcall ToBytesF(TIdBytes &Bytes, const System::WideChar AValue, _di_IIdTextEncoding ADestEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE void __fastcall ToBytesF(TIdBytes &Bytes, const int AValue)/* overload */;
extern DELPHI_PACKAGE void __fastcall ToBytesF(TIdBytes &Bytes, const short AValue)/* overload */;
extern DELPHI_PACKAGE void __fastcall ToBytesF(TIdBytes &Bytes, const System::Word AValue)/* overload */;
extern DELPHI_PACKAGE void __fastcall ToBytesF(TIdBytes &Bytes, const System::Int8 AValue)/* overload */;
extern DELPHI_PACKAGE void __fastcall ToBytesF(TIdBytes &Bytes, const System::Byte AValue)/* overload */;
extern DELPHI_PACKAGE void __fastcall ToBytesF(TIdBytes &Bytes, const unsigned AValue)/* overload */;
extern DELPHI_PACKAGE void __fastcall ToBytesF(TIdBytes &Bytes, const __int64 AValue)/* overload */;
extern DELPHI_PACKAGE void __fastcall ToBytesF(TIdBytes &Bytes, const unsigned __int64 AValue)/* overload */;
extern DELPHI_PACKAGE void __fastcall ToBytesF(TIdBytes &Bytes, const TIdBytes AValue, const int ASize, const int AIndex = 0x0)/* overload */;
extern DELPHI_PACKAGE void __fastcall RawToBytesF(TIdBytes &Bytes, const void *AValue, const int ASize);
extern DELPHI_PACKAGE System::WideChar __fastcall BytesToChar(const TIdBytes AValue, const int AIndex = 0x0, _di_IIdTextEncoding AByteEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE int __fastcall BytesToChar(const TIdBytes AValue, System::WideChar &VChar, const int AIndex = 0x0, _di_IIdTextEncoding AByteEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE int __fastcall BytesToInt32(const TIdBytes AValue, const int AIndex = 0x0);
extern DELPHI_PACKAGE int __fastcall BytesToLongInt _DEPRECATED_ATTRIBUTE1("Use BytesToInt32()") (const TIdBytes AValue, const int AIndex = 0x0);
extern DELPHI_PACKAGE __int64 __fastcall BytesToInt64(const TIdBytes AValue, const int AIndex = 0x0);
extern DELPHI_PACKAGE unsigned __int64 __fastcall BytesToUInt64(const TIdBytes AValue, const int AIndex = 0x0);
extern DELPHI_PACKAGE unsigned __int64 __fastcall BytesToTicks(const TIdBytes AValue, const int AIndex = 0x0);
extern DELPHI_PACKAGE System::Word __fastcall BytesToUInt16(const TIdBytes AValue, const int AIndex = 0x0);
extern DELPHI_PACKAGE System::Word __fastcall BytesToWord _DEPRECATED_ATTRIBUTE1("Use BytesToUInt16()") (const TIdBytes AValue, const int AIndex = 0x0);
extern DELPHI_PACKAGE short __fastcall BytesToInt16(const TIdBytes AValue, const int AIndex = 0x0);
extern DELPHI_PACKAGE short __fastcall BytesToShort _DEPRECATED_ATTRIBUTE1("Use BytesToInt16()") (const TIdBytes AValue, const int AIndex = 0x0);
extern DELPHI_PACKAGE System::UnicodeString __fastcall BytesToIPv4Str(const TIdBytes AValue, const int AIndex = 0x0);
extern DELPHI_PACKAGE void __fastcall BytesToIPv6(const TIdBytes AValue, TIdIPv6Address &VAddress, const int AIndex = 0x0);
extern DELPHI_PACKAGE unsigned __fastcall BytesToUInt32(const TIdBytes AValue, const int AIndex = 0x0);
extern DELPHI_PACKAGE unsigned __fastcall BytesToLongWord _DEPRECATED_ATTRIBUTE1("Use BytesToUInt32()") (const TIdBytes AValue, const int AIndex = 0x0);
extern DELPHI_PACKAGE System::UnicodeString __fastcall BytesToString(const TIdBytes AValue, _di_IIdTextEncoding AByteEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall BytesToString(const TIdBytes AValue, const int AStartIndex, const int ALength = 0xffffffff, _di_IIdTextEncoding AByteEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall BytesToStringRaw(const TIdBytes AValue)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall BytesToStringRaw(const TIdBytes AValue, const int AStartIndex, const int ALength = 0xffffffff)/* overload */;
extern DELPHI_PACKAGE void __fastcall BytesToRaw(const TIdBytes AValue, void *VBuffer, const int ASize);
extern DELPHI_PACKAGE System::Word __fastcall TwoByteToUInt16(System::Byte AByte1, System::Byte AByte2);
extern DELPHI_PACKAGE System::Word __fastcall TwoByteToWord _DEPRECATED_ATTRIBUTE1("Use TwoByteToUInt16()") (System::Byte AByte1, System::Byte AByte2);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ReadStringFromStream(System::Classes::TStream* AStream, int ASize = 0xffffffff, _di_IIdTextEncoding AByteEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE __int64 __fastcall ReadTIdBytesFromStream(System::Classes::TStream* const AStream, TIdBytes &ABytes, const __int64 Count, const int AIndex = 0x0);
extern DELPHI_PACKAGE int __fastcall ReadCharFromStream(System::Classes::TStream* AStream, System::WideChar &VChar, _di_IIdTextEncoding AByteEncoding = _di_IIdTextEncoding());
extern DELPHI_PACKAGE void __fastcall WriteTIdBytesToStream(System::Classes::TStream* const AStream, const TIdBytes ABytes, const int ASize = 0xffffffff, const int AIndex = 0x0);
extern DELPHI_PACKAGE void __fastcall WriteStringToStream(System::Classes::TStream* AStream, const System::UnicodeString AStr, _di_IIdTextEncoding ADestEncoding)/* overload */;
extern DELPHI_PACKAGE void __fastcall WriteStringToStream(System::Classes::TStream* AStream, const System::UnicodeString AStr, const int ALength = 0xffffffff, const int AIndex = 0x1, _di_IIdTextEncoding ADestEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE void __fastcall AppendBytes(TIdBytes &VBytes, const TIdBytes AToAdd, const int AIndex = 0x0, const int ALength = 0xffffffff);
extern DELPHI_PACKAGE void __fastcall AppendByte(TIdBytes &VBytes, const System::Byte AByte);
extern DELPHI_PACKAGE void __fastcall AppendString(TIdBytes &VBytes, const System::UnicodeString AStr, const int ALength = 0xffffffff, _di_IIdTextEncoding ADestEncoding = _di_IIdTextEncoding());
extern DELPHI_PACKAGE void __fastcall ExpandBytes(TIdBytes &VBytes, const int AIndex, const int ACount, const System::Byte AFillByte = (System::Byte)(0x0));
extern DELPHI_PACKAGE void __fastcall InsertBytes(TIdBytes &VBytes, const int ADestIndex, const TIdBytes ASource, const int ASourceIndex = 0x0);
extern DELPHI_PACKAGE void __fastcall InsertByte(TIdBytes &VBytes, const System::Byte AByte, const int AIndex);
extern DELPHI_PACKAGE void __fastcall RemoveBytes(TIdBytes &VBytes, const int ACount, const int AIndex = 0x0);
extern DELPHI_PACKAGE void __fastcall IdDelete(System::UnicodeString &s, int AOffset, int ACount);
extern DELPHI_PACKAGE void __fastcall IdInsert(const System::UnicodeString Source, System::UnicodeString &S, int Index);
extern DELPHI_PACKAGE bool __fastcall TextIsSame(const System::UnicodeString A1, const System::UnicodeString A2);
extern DELPHI_PACKAGE bool __fastcall TextStartsWith(const System::UnicodeString S, const System::UnicodeString SubS);
extern DELPHI_PACKAGE bool __fastcall TextEndsWith(const System::UnicodeString S, const System::UnicodeString SubS);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IndyLowerCase(const System::UnicodeString A1);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IndyUpperCase(const System::UnicodeString A1);
extern DELPHI_PACKAGE int __fastcall IndyCompareStr(const System::UnicodeString A1, const System::UnicodeString A2);
extern DELPHI_PACKAGE int __fastcall CharPosInSet(const System::UnicodeString AString, const int ACharPos, const System::UnicodeString ASet);
extern DELPHI_PACKAGE bool __fastcall CharIsInSet(const System::UnicodeString AString, const int ACharPos, const System::UnicodeString ASet);
extern DELPHI_PACKAGE bool __fastcall CharIsInEOL(const System::UnicodeString AString, const int ACharPos);
extern DELPHI_PACKAGE bool __fastcall CharEquals(const System::UnicodeString AString, const int ACharPos, const System::WideChar AValue);
extern DELPHI_PACKAGE int __fastcall ByteIndex(const System::Byte AByte, const TIdBytes ABytes, const int AStartIndex = 0x0);
extern DELPHI_PACKAGE int __fastcall ByteIdxInSet(const TIdBytes ABytes, const int AIndex, const TIdBytes ASet);
extern DELPHI_PACKAGE bool __fastcall ByteIsInSet(const TIdBytes ABytes, const int AIndex, const TIdBytes ASet);
extern DELPHI_PACKAGE bool __fastcall ByteIsInEOL(const TIdBytes ABytes, const int AIndex);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ReadLnFromStream(System::Classes::TStream* AStream, int AMaxLineLength = 0xffffffff, bool AExceptionIfEOF = false, _di_IIdTextEncoding AByteEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE bool __fastcall ReadLnFromStream(System::Classes::TStream* AStream, System::UnicodeString &VLine, int AMaxLineLength = 0xffffffff, _di_IIdTextEncoding AByteEncoding = _di_IIdTextEncoding())/* overload */;
extern DELPHI_PACKAGE bool __fastcall IndyRegisterExpectedMemoryLeak(void * AAddress);
extern DELPHI_PACKAGE System::Classes::TStrings* __fastcall IndyAddPair(System::Classes::TStrings* AStrings, const System::UnicodeString AName, const System::UnicodeString AValue)/* overload */;
extern DELPHI_PACKAGE System::Classes::TStrings* __fastcall IndyAddPair(System::Classes::TStrings* AStrings, const System::UnicodeString AName, const System::UnicodeString AValue, System::TObject* AObject)/* overload */;
extern DELPHI_PACKAGE int __fastcall IndyIndexOf(System::Classes::TStrings* AStrings, const System::UnicodeString AStr, const bool ACaseSensitive = false)/* overload */;
extern DELPHI_PACKAGE int __fastcall IndyIndexOf(System::Classes::TStringList* AStrings, const System::UnicodeString AStr, const bool ACaseSensitive = false)/* overload */;
extern DELPHI_PACKAGE int __fastcall IndyIndexOfName(System::Classes::TStrings* AStrings, const System::UnicodeString AName, const bool ACaseSensitive = false)/* overload */;
extern DELPHI_PACKAGE int __fastcall IndyIndexOfName(System::Classes::TStringList* AStrings, const System::UnicodeString AName, const bool ACaseSensitive = false)/* overload */;
extern DELPHI_PACKAGE System::UnicodeString __fastcall IndyValueFromIndex(System::Classes::TStrings* AStrings, const int AIndex);
extern DELPHI_PACKAGE int __fastcall IndyWindowsMajorVersion(void);
extern DELPHI_PACKAGE int __fastcall IndyWindowsMinorVersion(void);
extern DELPHI_PACKAGE int __fastcall IndyWindowsBuildNumber(void);
extern DELPHI_PACKAGE int __fastcall IndyWindowsPlatform(void);
extern DELPHI_PACKAGE bool __fastcall IndyCheckWindowsVersion(const int AMajor, const int AMinor = 0x0);
extern DELPHI_PACKAGE void __fastcall IdDisposeAndNil(void *Obj);
}	/* namespace Idglobal */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDGLOBAL)
using namespace Idglobal;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdglobalHPP
