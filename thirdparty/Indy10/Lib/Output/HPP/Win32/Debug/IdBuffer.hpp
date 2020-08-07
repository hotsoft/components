// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdBuffer.pas' rev: 25.00 (Windows)

#ifndef IdbufferHPP
#define IdbufferHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idbuffer
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdNotEnoughDataInBuffer;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdNotEnoughDataInBuffer : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdNotEnoughDataInBuffer(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdNotEnoughDataInBuffer(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdNotEnoughDataInBuffer(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdNotEnoughDataInBuffer(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNotEnoughDataInBuffer(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdNotEnoughDataInBuffer(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdNotEnoughDataInBuffer(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdNotEnoughDataInBuffer(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNotEnoughDataInBuffer(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdNotEnoughDataInBuffer(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNotEnoughDataInBuffer(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdNotEnoughDataInBuffer(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdNotEnoughDataInBuffer(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdTooMuchDataInBuffer;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdTooMuchDataInBuffer : public Idexception::EIdException
{
	typedef Idexception::EIdException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdTooMuchDataInBuffer(const System::UnicodeString AMsg)/* overload */ : Idexception::EIdException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdTooMuchDataInBuffer(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexception::EIdException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdTooMuchDataInBuffer(NativeUInt Ident)/* overload */ : Idexception::EIdException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdTooMuchDataInBuffer(System::PResStringRec ResStringRec)/* overload */ : Idexception::EIdException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTooMuchDataInBuffer(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdTooMuchDataInBuffer(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdTooMuchDataInBuffer(const System::UnicodeString Msg, int AHelpContext) : Idexception::EIdException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdTooMuchDataInBuffer(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexception::EIdException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTooMuchDataInBuffer(NativeUInt Ident, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdTooMuchDataInBuffer(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTooMuchDataInBuffer(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdTooMuchDataInBuffer(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexception::EIdException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdTooMuchDataInBuffer(void) { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TIdBufferBytesRemoved)(System::TObject* ASender, int ABytes);

class DELPHICLASS TIdBuffer;
class PASCALIMPLEMENTATION TIdBuffer : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::UnicodeString __fastcall GetAsString(void);
	
protected:
	Idglobal::TIdBytes FBytes;
	Idglobal::_di_IIdTextEncoding FByteEncoding;
	int FGrowthFactor;
	int FHeadIndex;
	TIdBufferBytesRemoved FOnBytesRemoved;
	int FSize;
	void __fastcall CheckAdd(int AByteCount, const int AIndex);
	void __fastcall CheckByteCount(int &VByteCount, const int AIndex);
	int __fastcall GetCapacity(void);
	void __fastcall SetCapacity(int AValue);
	
public:
	void __fastcall Clear(void);
	__fastcall TIdBuffer(void)/* overload */;
	__fastcall TIdBuffer(TIdBufferBytesRemoved AOnBytesRemoved)/* overload */;
	__fastcall TIdBuffer(int AGrowthFactor)/* overload */;
	__fastcall TIdBuffer(const Idglobal::TIdBytes ABytes, const int ALength)/* overload */;
	void __fastcall CompactHead(bool ACanShrink = true);
	__fastcall virtual ~TIdBuffer(void);
	System::UnicodeString __fastcall Extract _DEPRECATED_ATTRIBUTE1("Use ExtractToString()") (int AByteCount = 0xffffffff, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	System::UnicodeString __fastcall ExtractToString(int AByteCount = 0xffffffff, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	void __fastcall ExtractToStream(System::Classes::TStream* const AStream, int AByteCount = 0xffffffff, const int AIndex = 0xffffffff);
	void __fastcall ExtractToIdBuffer(TIdBuffer* ABuffer, int AByteCount = 0xffffffff, const int AIndex = 0xffffffff);
	void __fastcall ExtractToBytes(Idglobal::TIdBytes &VBytes, int AByteCount = 0xffffffff, bool AAppend = true, int AIndex = 0xffffffff);
	System::Byte __fastcall ExtractToUInt8(const int AIndex);
	System::Byte __fastcall ExtractToByte _DEPRECATED_ATTRIBUTE1("Use ExtractToUInt8()") (const int AIndex);
	System::Word __fastcall ExtractToUInt16(const int AIndex);
	System::Word __fastcall ExtractToWord _DEPRECATED_ATTRIBUTE1("Use ExtractToUInt16()") (const int AIndex);
	unsigned __fastcall ExtractToUInt32(const int AIndex);
	unsigned __fastcall ExtractToLongWord _DEPRECATED_ATTRIBUTE1("Use ExtractToUInt32()") (const int AIndex);
	unsigned __int64 __fastcall ExtractToUInt64(const int AIndex);
	void __fastcall ExtractToIPv6(const int AIndex, Idglobal::TIdIPv6Address &VAddress);
	int __fastcall IndexOf(const System::Byte AByte, int AStartPos = 0x0)/* overload */;
	int __fastcall IndexOf(const Idglobal::TIdBytes ABytes, int AStartPos = 0x0)/* overload */;
	int __fastcall IndexOf(const System::UnicodeString AString, int AStartPos = 0x0, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	System::Byte __fastcall PeekByte(int AIndex);
	void __fastcall Remove(int AByteCount);
	void __fastcall SaveToStream(System::Classes::TStream* const AStream);
	void __fastcall Write(const System::UnicodeString AString, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding(), const int ADestIndex = 0xffffffff)/* overload */;
	void __fastcall Write(const Idglobal::TIdBytes ABytes, const int ADestIndex = 0xffffffff)/* overload */;
	void __fastcall Write(const Idglobal::TIdBytes ABytes, const int ALength, const int AOffset, const int ADestIndex = 0xffffffff)/* overload */;
	void __fastcall Write(System::Classes::TStream* AStream, int AByteCount = 0x0)/* overload */;
	void __fastcall Write(const unsigned __int64 AValue, const int ADestIndex = 0xffffffff)/* overload */;
	void __fastcall Write(const unsigned AValue, const int ADestIndex = 0xffffffff)/* overload */;
	void __fastcall Write(const System::Word AValue, const int ADestIndex = 0xffffffff)/* overload */;
	void __fastcall Write(const System::Byte AValue, const int ADestIndex = 0xffffffff)/* overload */;
	void __fastcall Write(const Idglobal::TIdIPv6Address &AValue, const int ADestIndex = 0xffffffff)/* overload */;
	__property int Capacity = {read=GetCapacity, write=SetCapacity, nodefault};
	__property Idglobal::_di_IIdTextEncoding Encoding = {read=FByteEncoding, write=FByteEncoding};
	__property int GrowthFactor = {read=FGrowthFactor, write=FGrowthFactor, nodefault};
	__property int Size = {read=FSize, nodefault};
	__property System::UnicodeString AsString = {read=GetAsString};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idbuffer */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDBUFFER)
using namespace Idbuffer;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdbufferHPP
