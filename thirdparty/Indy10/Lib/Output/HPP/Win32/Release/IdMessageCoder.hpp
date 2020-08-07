// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdMessageCoder.pas' rev: 25.00 (Windows)

#ifndef IdmessagecoderHPP
#define IdmessagecoderHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdComponent.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdMessage.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idmessagecoder
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TIdMessageCoderPartType : unsigned char { mcptText, mcptAttachment, mcptIgnore, mcptEOF };

class DELPHICLASS TIdMessageDecoder;
class PASCALIMPLEMENTATION TIdMessageDecoder : public Idcomponent::TIdComponent
{
	typedef Idcomponent::TIdComponent inherited;
	
protected:
	System::UnicodeString FFilename;
	bool FFreeSourceStream;
	System::Classes::TStrings* FHeaders;
	TIdMessageCoderPartType FPartType;
	System::Classes::TStream* FSourceStream;
	virtual void __fastcall InitComponent(void);
	
public:
	virtual TIdMessageDecoder* __fastcall ReadBody(System::Classes::TStream* ADestStream, bool &AMsgEnd) = 0 ;
	virtual void __fastcall ReadHeader(void);
	System::UnicodeString __fastcall ReadLn(const System::UnicodeString ATerminator = L"\n", Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding());
	System::UnicodeString __fastcall ReadLnRFC(bool &VMsgEnd, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	System::UnicodeString __fastcall ReadLnRFC(bool &VMsgEnd, const System::UnicodeString ALineTerminator, const System::UnicodeString ADelim = L".", Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding())/* overload */;
	__fastcall virtual ~TIdMessageDecoder(void);
	__property System::UnicodeString Filename = {read=FFilename};
	__property bool FreeSourceStream = {read=FFreeSourceStream, write=FFreeSourceStream, nodefault};
	__property System::Classes::TStrings* Headers = {read=FHeaders};
	__property TIdMessageCoderPartType PartType = {read=FPartType, nodefault};
	__property System::Classes::TStream* SourceStream = {read=FSourceStream, write=FSourceStream};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMessageDecoder(System::Classes::TComponent* AOwner)/* overload */ : Idcomponent::TIdComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMessageDecoder(void)/* overload */ : Idcomponent::TIdComponent() { }
	
};


class DELPHICLASS TIdMessageDecoderInfo;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageDecoderInfo : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	virtual TIdMessageDecoder* __fastcall CheckForStart(Idmessage::TIdMessage* ASender, const System::UnicodeString ALine) = 0 ;
	__fastcall virtual TIdMessageDecoderInfo(void);
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdMessageDecoderInfo(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdMessageDecoderList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageDecoderList : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::Classes::TStrings* FMessageCoders;
	
public:
	__classmethod TIdMessageDecoderInfo* __fastcall ByName(const System::UnicodeString AName);
	__classmethod TIdMessageDecoder* __fastcall CheckForStart(Idmessage::TIdMessage* ASender, const System::UnicodeString ALine);
	__fastcall TIdMessageDecoderList(void);
	__fastcall virtual ~TIdMessageDecoderList(void);
	__classmethod void __fastcall RegisterDecoder(const System::UnicodeString AMessageCoderName, TIdMessageDecoderInfo* AMessageCoderInfo);
};

#pragma pack(pop)

class DELPHICLASS TIdMessageEncoder;
class PASCALIMPLEMENTATION TIdMessageEncoder : public Idcomponent::TIdComponent
{
	typedef Idcomponent::TIdComponent inherited;
	
protected:
	System::UnicodeString FFilename;
	int FPermissionCode;
	virtual void __fastcall InitComponent(void);
	
public:
	void __fastcall Encode(const System::UnicodeString AFilename, System::Classes::TStream* ADest)/* overload */;
	void __fastcall Encode(System::Classes::TStream* ASrc, System::Classes::TStrings* ADest)/* overload */;
	virtual void __fastcall Encode(System::Classes::TStream* ASrc, System::Classes::TStream* ADest) = 0 /* overload */;
	
__published:
	__property System::UnicodeString Filename = {read=FFilename, write=FFilename};
	__property int PermissionCode = {read=FPermissionCode, write=FPermissionCode, nodefault};
public:
	/* TIdComponent.Destroy */ inline __fastcall virtual ~TIdMessageEncoder(void) { }
	
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdMessageEncoder(System::Classes::TComponent* AOwner)/* overload */ : Idcomponent::TIdComponent(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdMessageEncoder(void)/* overload */ : Idcomponent::TIdComponent() { }
	
};


typedef System::TMetaClass* TIdMessageEncoderClass;

class DELPHICLASS TIdMessageEncoderInfo;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageEncoderInfo : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	TIdMessageEncoderClass FMessageEncoderClass;
	
public:
	__fastcall virtual TIdMessageEncoderInfo(void);
	virtual void __fastcall InitializeHeaders(Idmessage::TIdMessage* AMsg);
	__property TIdMessageEncoderClass MessageEncoderClass = {read=FMessageEncoderClass};
public:
	/* TObject.Destroy */ inline __fastcall virtual ~TIdMessageEncoderInfo(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdMessageEncoderList;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdMessageEncoderList : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	System::Classes::TStrings* FMessageCoders;
	
public:
	__classmethod TIdMessageEncoderInfo* __fastcall ByName(const System::UnicodeString AName);
	__fastcall TIdMessageEncoderList(void);
	__fastcall virtual ~TIdMessageEncoderList(void);
	__classmethod void __fastcall RegisterEncoder(const System::UnicodeString AMessageEncoderName, TIdMessageEncoderInfo* AMessageEncoderInfo);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idmessagecoder */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDMESSAGECODER)
using namespace Idmessagecoder;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdmessagecoderHPP
