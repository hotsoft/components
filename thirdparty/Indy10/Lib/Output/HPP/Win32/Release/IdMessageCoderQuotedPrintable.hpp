// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMessageCoderQuotedPrintable.pas' rev: 25.00 (Windows)

#ifndef IdmessagecoderquotedprintableHPP
#define IdmessagecoderquotedprintableHPP

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
#include <IdGlobal.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmessagecoderquotedprintable
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdMessageEncoderQuotedPrintable;
class PASCALIMPLEMENTATION TIdMessageEncoderQuotedPrintable : public Idmessagecoder::TIdMessageEncoder
{
	typedef Idmessagecoder::TIdMessageEncoder inherited;
	
public:
	virtual void __fastcall Encode(System::Classes::TStream* ASrc, System::Classes::TStream* ADest)/* overload */;
public:
	/* TIdComponent.Destroy */ inline __fastcall virtual ~TIdMessageEncoderQuotedPrintable(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMessageEncoderQuotedPrintable(System::Classes::TComponent* AOwner)/* overload */ : Idmessagecoder::TIdMessageEncoder(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMessageEncoderQuotedPrintable(void)/* overload */ : Idmessagecoder::TIdMessageEncoder() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Encode(const System::UnicodeString AFilename, System::Classes::TStream* ADest){ Idmessagecoder::TIdMessageEncoder::Encode(AFilename, ADest); }
	inline void __fastcall  Encode(System::Classes::TStream* ASrc, System::Classes::TStrings* ADest){ Idmessagecoder::TIdMessageEncoder::Encode(ASrc, ADest); }
	
};


class DELPHICLASS TIdMessageEncoderInfoQuotedPrintable;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageEncoderInfoQuotedPrintable : public Idmessagecoder::TIdMessageEncoderInfo
{
	typedef Idmessagecoder::TIdMessageEncoderInfo inherited;
	
public:
	__fastcall virtual TIdMessageEncoderInfoQuotedPrintable(void);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdMessageEncoderInfoQuotedPrintable(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idmessagecoderquotedprintable */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMESSAGECODERQUOTEDPRINTABLE)
using namespace Idmessagecoderquotedprintable;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmessagecoderquotedprintableHPP
