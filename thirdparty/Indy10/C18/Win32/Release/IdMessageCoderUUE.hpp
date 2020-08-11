// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMessageCoderUUE.pas' rev: 25.00 (Windows)

#ifndef IdmessagecoderuueHPP
#define IdmessagecoderuueHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdCoder3to4.hpp>	// Pascal unit
#include <IdMessageCoder.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmessagecoderuue
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdMessageDecoderUUE;
class PASCALIMPLEMENTATION TIdMessageDecoderUUE : public Idmessagecoder::TIdMessageDecoder
{
	typedef Idmessagecoder::TIdMessageDecoder inherited;
	
protected:
	System::UnicodeString FCodingType;
	
public:
	virtual Idmessagecoder::TIdMessageDecoder* __fastcall ReadBody(System::Classes::TStream* ADestStream, bool &AMsgEnd);
	__property System::UnicodeString CodingType = {read=FCodingType};
public:
	/* TIdMessageDecoder.Destroy */ inline __fastcall virtual ~TIdMessageDecoderUUE(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMessageDecoderUUE(System::Classes::TComponent* AOwner)/* overload */ : Idmessagecoder::TIdMessageDecoder(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMessageDecoderUUE(void)/* overload */ : Idmessagecoder::TIdMessageDecoder() { }
	
};


class DELPHICLASS TIdMessageDecoderInfoUUE;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageDecoderInfoUUE : public Idmessagecoder::TIdMessageDecoderInfo
{
	typedef Idmessagecoder::TIdMessageDecoderInfo inherited;
	
public:
	virtual Idmessagecoder::TIdMessageDecoder* __fastcall CheckForStart(Idmessage::TIdMessage* ASender, const System::UnicodeString ALine);
public:
	/* TIdMessageDecoderInfo.Create */ inline __fastcall virtual TIdMessageDecoderInfoUUE(void) : Idmessagecoder::TIdMessageDecoderInfo() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdMessageDecoderInfoUUE(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdMessageEncoderUUEBase;
class PASCALIMPLEMENTATION TIdMessageEncoderUUEBase : public Idmessagecoder::TIdMessageEncoder
{
	typedef Idmessagecoder::TIdMessageEncoder inherited;
	
protected:
	Idcoder3to4::TIdEncoder3to4Class FEncoderClass;
	
public:
	virtual void __fastcall Encode(System::Classes::TStream* ASrc, System::Classes::TStream* ADest)/* overload */;
public:
	/* TIdComponent.Destroy */ inline __fastcall virtual ~TIdMessageEncoderUUEBase(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMessageEncoderUUEBase(System::Classes::TComponent* AOwner)/* overload */ : Idmessagecoder::TIdMessageEncoder(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMessageEncoderUUEBase(void)/* overload */ : Idmessagecoder::TIdMessageEncoder() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Encode(const System::UnicodeString AFilename, System::Classes::TStream* ADest){ Idmessagecoder::TIdMessageEncoder::Encode(AFilename, ADest); }
	inline void __fastcall  Encode(System::Classes::TStream* ASrc, System::Classes::TStrings* ADest){ Idmessagecoder::TIdMessageEncoder::Encode(ASrc, ADest); }
	
};


class DELPHICLASS TIdMessageEncoderUUE;
class PASCALIMPLEMENTATION TIdMessageEncoderUUE : public TIdMessageEncoderUUEBase
{
	typedef TIdMessageEncoderUUEBase inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
public:
	/* TIdComponent.Destroy */ inline __fastcall virtual ~TIdMessageEncoderUUE(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMessageEncoderUUE(System::Classes::TComponent* AOwner)/* overload */ : TIdMessageEncoderUUEBase(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMessageEncoderUUE(void)/* overload */ : TIdMessageEncoderUUEBase() { }
	
};


class DELPHICLASS TIdMessageEncoderInfoUUE;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageEncoderInfoUUE : public Idmessagecoder::TIdMessageEncoderInfo
{
	typedef Idmessagecoder::TIdMessageEncoderInfo inherited;
	
public:
	__fastcall virtual TIdMessageEncoderInfoUUE(void);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdMessageEncoderInfoUUE(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idmessagecoderuue */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMESSAGECODERUUE)
using namespace Idmessagecoderuue;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmessagecoderuueHPP
