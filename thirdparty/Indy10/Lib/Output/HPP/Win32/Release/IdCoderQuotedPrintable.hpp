// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCoderQuotedPrintable.pas' rev: 25.00 (Windows)

#ifndef IdcoderquotedprintableHPP
#define IdcoderquotedprintableHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdCoder.hpp>	// Pascal unit
#include <IdStream.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcoderquotedprintable
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdDecoderQuotedPrintable;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdDecoderQuotedPrintable : public Idcoder::TIdDecoder
{
	typedef Idcoder::TIdDecoder inherited;
	
public:
	virtual void __fastcall Decode(System::Classes::TStream* ASrcStream, const int ABytes = 0xffffffff)/* overload */;
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdDecoderQuotedPrintable(System::Classes::TComponent* AOwner)/* overload */ : Idcoder::TIdDecoder(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdDecoderQuotedPrintable(void)/* overload */ : Idcoder::TIdDecoder() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdDecoderQuotedPrintable(void) { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Decode(const System::UnicodeString AIn){ Idcoder::TIdDecoder::Decode(AIn); }
	
};

#pragma pack(pop)

class DELPHICLASS TIdEncoderQuotedPrintable;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdEncoderQuotedPrintable : public Idcoder::TIdEncoder
{
	typedef Idcoder::TIdEncoder inherited;
	
public:
	virtual void __fastcall Encode(System::Classes::TStream* ASrcStream, System::Classes::TStream* ADestStream, const int ABytes = 0xffffffff)/* overload */;
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdEncoderQuotedPrintable(System::Classes::TComponent* AOwner)/* overload */ : Idcoder::TIdEncoder(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdEncoderQuotedPrintable(void)/* overload */ : Idcoder::TIdEncoder() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdEncoderQuotedPrintable(void) { }
	
/* Hoisted overloads: */
	
public:
	inline System::UnicodeString __fastcall  Encode(const System::UnicodeString AIn, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding()){ return Idcoder::TIdEncoder::Encode(AIn, AByteEncoding); }
	inline void __fastcall  Encode(const System::UnicodeString AIn, System::Classes::TStrings* ADestStrings, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding()){ Idcoder::TIdEncoder::Encode(AIn, ADestStrings, AByteEncoding); }
	inline void __fastcall  Encode(const System::UnicodeString AIn, System::Classes::TStream* ADestStream, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding()){ Idcoder::TIdEncoder::Encode(AIn, ADestStream, AByteEncoding); }
	inline System::UnicodeString __fastcall  Encode(System::Classes::TStream* ASrcStream, const int ABytes = 0xffffffff){ return Idcoder::TIdEncoder::Encode(ASrcStream, ABytes); }
	inline void __fastcall  Encode(System::Classes::TStream* ASrcStream, System::Classes::TStrings* ADestStrings, const int ABytes = 0xffffffff){ Idcoder::TIdEncoder::Encode(ASrcStream, ADestStrings, ABytes); }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idcoderquotedprintable */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCODERQUOTEDPRINTABLE)
using namespace Idcoderquotedprintable;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcoderquotedprintableHPP
