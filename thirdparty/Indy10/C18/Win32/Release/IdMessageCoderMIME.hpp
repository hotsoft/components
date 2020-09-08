// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMessageCoderMIME.pas' rev: 25.00 (Windows)

#ifndef IdmessagecodermimeHPP
#define IdmessagecodermimeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdMessageCoder.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmessagecodermime
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdMessageDecoderMIME;
class PASCALIMPLEMENTATION TIdMessageDecoderMIME : public Idmessagecoder::TIdMessageDecoder
{
	typedef Idmessagecoder::TIdMessageDecoder inherited;
	
protected:
	System::UnicodeString FFirstLine;
	bool FProcessFirstLine;
	bool FBodyEncoded;
	System::UnicodeString FMIMEBoundary;
	System::UnicodeString __fastcall GetProperHeaderItem(const System::UnicodeString Line);
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdMessageDecoderMIME(System::Classes::TComponent* AOwner, const System::UnicodeString ALine)/* overload */;
	virtual Idmessagecoder::TIdMessageDecoder* __fastcall ReadBody(System::Classes::TStream* ADestStream, bool &VMsgEnd);
	void __fastcall CheckAndSetType(const System::UnicodeString AContentType, const System::UnicodeString AContentDisposition);
	virtual void __fastcall ReadHeader(void);
	System::UnicodeString __fastcall GetAttachmentFilename(const System::UnicodeString AContentType, const System::UnicodeString AContentDisposition);
	System::UnicodeString __fastcall RemoveInvalidCharsFromFilename(const System::UnicodeString AFilename);
	__property System::UnicodeString MIMEBoundary = {read=FMIMEBoundary, write=FMIMEBoundary};
	__property bool BodyEncoded = {read=FBodyEncoded, write=FBodyEncoded, nodefault};
public:
	/* TIdMessageDecoder.Destroy */ inline __fastcall virtual ~TIdMessageDecoderMIME(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMessageDecoderMIME(System::Classes::TComponent* AOwner)/* overload */ : Idmessagecoder::TIdMessageDecoder(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMessageDecoderMIME(void)/* overload */ : Idmessagecoder::TIdMessageDecoder() { }
	
};


class DELPHICLASS TIdMessageDecoderInfoMIME;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageDecoderInfoMIME : public Idmessagecoder::TIdMessageDecoderInfo
{
	typedef Idmessagecoder::TIdMessageDecoderInfo inherited;
	
public:
	virtual Idmessagecoder::TIdMessageDecoder* __fastcall CheckForStart(Idmessage::TIdMessage* ASender, const System::UnicodeString ALine);
public:
	/* TIdMessageDecoderInfo.Create */ inline __fastcall virtual TIdMessageDecoderInfoMIME(void) : Idmessagecoder::TIdMessageDecoderInfo() { }
	
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdMessageDecoderInfoMIME(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdMessageEncoderMIME;
class PASCALIMPLEMENTATION TIdMessageEncoderMIME : public Idmessagecoder::TIdMessageEncoder
{
	typedef Idmessagecoder::TIdMessageEncoder inherited;
	
public:
	virtual void __fastcall Encode(System::Classes::TStream* ASrc, System::Classes::TStream* ADest)/* overload */;
public:
	/* TIdComponent.Destroy */ inline __fastcall virtual ~TIdMessageEncoderMIME(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMessageEncoderMIME(System::Classes::TComponent* AOwner)/* overload */ : Idmessagecoder::TIdMessageEncoder(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMessageEncoderMIME(void)/* overload */ : Idmessagecoder::TIdMessageEncoder() { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Encode(const System::UnicodeString AFilename, System::Classes::TStream* ADest){ Idmessagecoder::TIdMessageEncoder::Encode(AFilename, ADest); }
	inline void __fastcall  Encode(System::Classes::TStream* ASrc, System::Classes::TStrings* ADest){ Idmessagecoder::TIdMessageEncoder::Encode(ASrc, ADest); }
	
};


class DELPHICLASS TIdMessageEncoderInfoMIME;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageEncoderInfoMIME : public Idmessagecoder::TIdMessageEncoderInfo
{
	typedef Idmessagecoder::TIdMessageEncoderInfo inherited;
	
public:
	__fastcall virtual TIdMessageEncoderInfoMIME(void);
	virtual void __fastcall InitializeHeaders(Idmessage::TIdMessage* AMsg);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdMessageEncoderInfoMIME(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdMIMEBoundaryStrings;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMIMEBoundaryStrings : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	__classmethod System::WideChar __fastcall GenerateRandomChar();
	__classmethod System::UnicodeString __fastcall GenerateBoundary();
public:
	/* TObject.Create */ inline __fastcall TIdMIMEBoundaryStrings(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TIdMIMEBoundaryStrings(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idmessagecodermime */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMESSAGECODERMIME)
using namespace Idmessagecodermime;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmessagecodermimeHPP
