// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMessageCoderYenc.pas' rev: 25.00 (Windows)

#ifndef IdmessagecoderyencHPP
#define IdmessagecoderyencHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdMessageCoder.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit
#include <IdExceptionCore.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdException.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmessagecoderyenc
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS EIdMessageYencException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdMessageYencException : public Idexceptioncore::EIdMessageException
{
	typedef Idexceptioncore::EIdMessageException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdMessageYencException(const System::UnicodeString AMsg)/* overload */ : Idexceptioncore::EIdMessageException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdMessageYencException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : Idexceptioncore::EIdMessageException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdMessageYencException(NativeUInt Ident)/* overload */ : Idexceptioncore::EIdMessageException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdMessageYencException(System::PResStringRec ResStringRec)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMessageYencException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexceptioncore::EIdMessageException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMessageYencException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdMessageYencException(const System::UnicodeString Msg, int AHelpContext) : Idexceptioncore::EIdMessageException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdMessageYencException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : Idexceptioncore::EIdMessageException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMessageYencException(NativeUInt Ident, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMessageYencException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMessageYencException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMessageYencException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : Idexceptioncore::EIdMessageException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdMessageYencException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdMessageYencInvalidSizeException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdMessageYencInvalidSizeException : public EIdMessageYencException
{
	typedef EIdMessageYencException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdMessageYencInvalidSizeException(const System::UnicodeString AMsg)/* overload */ : EIdMessageYencException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdMessageYencInvalidSizeException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdMessageYencException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdMessageYencInvalidSizeException(NativeUInt Ident)/* overload */ : EIdMessageYencException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdMessageYencInvalidSizeException(System::PResStringRec ResStringRec)/* overload */ : EIdMessageYencException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMessageYencInvalidSizeException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdMessageYencException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMessageYencInvalidSizeException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdMessageYencException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdMessageYencInvalidSizeException(const System::UnicodeString Msg, int AHelpContext) : EIdMessageYencException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdMessageYencInvalidSizeException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdMessageYencException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMessageYencInvalidSizeException(NativeUInt Ident, int AHelpContext)/* overload */ : EIdMessageYencException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMessageYencInvalidSizeException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdMessageYencException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMessageYencInvalidSizeException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdMessageYencException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMessageYencInvalidSizeException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdMessageYencException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdMessageYencInvalidSizeException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdMessageYencInvalidCRCException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdMessageYencInvalidCRCException : public EIdMessageYencException
{
	typedef EIdMessageYencException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdMessageYencInvalidCRCException(const System::UnicodeString AMsg)/* overload */ : EIdMessageYencException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdMessageYencInvalidCRCException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdMessageYencException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdMessageYencInvalidCRCException(NativeUInt Ident)/* overload */ : EIdMessageYencException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdMessageYencInvalidCRCException(System::PResStringRec ResStringRec)/* overload */ : EIdMessageYencException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMessageYencInvalidCRCException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdMessageYencException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMessageYencInvalidCRCException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdMessageYencException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdMessageYencInvalidCRCException(const System::UnicodeString Msg, int AHelpContext) : EIdMessageYencException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdMessageYencInvalidCRCException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdMessageYencException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMessageYencInvalidCRCException(NativeUInt Ident, int AHelpContext)/* overload */ : EIdMessageYencException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMessageYencInvalidCRCException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdMessageYencException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMessageYencInvalidCRCException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdMessageYencException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMessageYencInvalidCRCException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdMessageYencException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdMessageYencInvalidCRCException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS EIdMessageYencCorruptionException;
#pragma pack(push,4)
class PASCALIMPLEMENTATION EIdMessageYencCorruptionException : public EIdMessageYencException
{
	typedef EIdMessageYencException inherited;
	
public:
	/* EIdException.Create */ inline __fastcall virtual EIdMessageYencCorruptionException(const System::UnicodeString AMsg)/* overload */ : EIdMessageYencException(AMsg) { }
	
public:
	/* Exception.CreateFmt */ inline __fastcall EIdMessageYencCorruptionException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size) : EIdMessageYencException(Msg, Args, Args_Size) { }
	/* Exception.CreateRes */ inline __fastcall EIdMessageYencCorruptionException(NativeUInt Ident)/* overload */ : EIdMessageYencException(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EIdMessageYencCorruptionException(System::PResStringRec ResStringRec)/* overload */ : EIdMessageYencException(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMessageYencCorruptionException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdMessageYencException(Ident, Args, Args_Size) { }
	/* Exception.CreateResFmt */ inline __fastcall EIdMessageYencCorruptionException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size)/* overload */ : EIdMessageYencException(ResStringRec, Args, Args_Size) { }
	/* Exception.CreateHelp */ inline __fastcall EIdMessageYencCorruptionException(const System::UnicodeString Msg, int AHelpContext) : EIdMessageYencException(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EIdMessageYencCorruptionException(const System::UnicodeString Msg, System::TVarRec const *Args, const int Args_Size, int AHelpContext) : EIdMessageYencException(Msg, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMessageYencCorruptionException(NativeUInt Ident, int AHelpContext)/* overload */ : EIdMessageYencException(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EIdMessageYencCorruptionException(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : EIdMessageYencException(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMessageYencCorruptionException(System::PResStringRec ResStringRec, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdMessageYencException(ResStringRec, Args, Args_Size, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EIdMessageYencCorruptionException(NativeUInt Ident, System::TVarRec const *Args, const int Args_Size, int AHelpContext)/* overload */ : EIdMessageYencException(Ident, Args, Args_Size, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EIdMessageYencCorruptionException(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdMessageDecoderYenc;
class PASCALIMPLEMENTATION TIdMessageDecoderYenc : public Idmessagecoder::TIdMessageDecoder
{
	typedef Idmessagecoder::TIdMessageDecoder inherited;
	
protected:
	int FPart;
	int FLine;
	int FSize;
	
public:
	virtual Idmessagecoder::TIdMessageDecoder* __fastcall ReadBody(System::Classes::TStream* ADestStream, bool &AMsgEnd);
public:
	/* TIdMessageDecoder.Destroy */ inline __fastcall virtual ~TIdMessageDecoderYenc(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMessageDecoderYenc(System::Classes::TComponent* AOwner)/* overload */ : Idmessagecoder::TIdMessageDecoder(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMessageDecoderYenc(void)/* overload */ : Idmessagecoder::TIdMessageDecoder() { }
	
};


class DELPHICLASS TIdMessageDecoderInfoYenc;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageDecoderInfoYenc : public Idmessagecoder::TIdMessageDecoderInfo
{
	typedef Idmessagecoder::TIdMessageDecoderInfo inherited;
	
public:
	virtual Idmessagecoder::TIdMessageDecoder* __fastcall CheckForStart(Idmessage::TIdMessage* ASender, const System::UnicodeString ALine);
public:
	/* TIdMessageDecoderInfo.Create */ inline __fastcall virtual TIdMessageDecoderInfoYenc(void) : Idmessagecoder::TIdMessageDecoderInfo() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdMessageDecoderInfoYenc(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdMessageEncoderYenc;
class PASCALIMPLEMENTATION TIdMessageEncoderYenc : public Idmessagecoder::TIdMessageEncoder
{
	typedef Idmessagecoder::TIdMessageEncoder inherited;
	
public:
	virtual void __fastcall Encode(System::Classes::TStream* ASrc, System::Classes::TStream* ADest)/* overload */;
public:
	/* TIdComponent.Destroy */ inline __fastcall virtual ~TIdMessageEncoderYenc(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMessageEncoderYenc(System::Classes::TComponent* AOwner)/* overload */ : Idmessagecoder::TIdMessageEncoder(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMessageEncoderYenc(void)/* overload */ : Idmessagecoder::TIdMessageEncoder() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Encode(const System::UnicodeString AFilename, System::Classes::TStream* ADest){ Idmessagecoder::TIdMessageEncoder::Encode(AFilename, ADest); }
	inline void __fastcall  Encode(System::Classes::TStream* ASrc, System::Classes::TStrings* ADest){ Idmessagecoder::TIdMessageEncoder::Encode(ASrc, ADest); }
	
};


class DELPHICLASS TIdMessageEncoderInfoYenc;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageEncoderInfoYenc : public Idmessagecoder::TIdMessageEncoderInfo
{
	typedef Idmessagecoder::TIdMessageEncoderInfo inherited;
	
public:
	__fastcall virtual TIdMessageEncoderInfoYenc(void);
	virtual void __fastcall InitializeHeaders(Idmessage::TIdMessage* AMsg);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdMessageEncoderInfoYenc(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Word BUFLEN = System::Word(0x1000);
static const System::Int8 B_PERIOD = System::Int8(0x2e);
static const System::Int8 B_EQUALS = System::Int8(0x3d);
static const System::Int8 B_TAB = System::Int8(0x9);
static const System::Int8 B_LF = System::Int8(0xa);
static const System::Int8 B_CR = System::Int8(0xd);
static const System::Int8 B_NUL = System::Int8(0x0);
}	/* namespace Idmessagecoderyenc */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMESSAGECODERYENC)
using namespace Idmessagecoderyenc;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmessagecoderyencHPP
