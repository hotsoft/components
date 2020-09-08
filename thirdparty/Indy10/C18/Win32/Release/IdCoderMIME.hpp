// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCoderMIME.pas' rev: 25.00 (Windows)

#ifndef IdcodermimeHPP
#define IdcodermimeHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdCoder3to4.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit
#include <IdCoder.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcodermime
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdEncoderMIME;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdEncoderMIME : public Idcoder3to4::TIdEncoder3to4
{
	typedef Idcoder3to4::TIdEncoder3to4 inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdEncoderMIME(System::Classes::TComponent* AOwner)/* overload */;
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdEncoderMIME(void)/* overload */ : Idcoder3to4::TIdEncoder3to4() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdEncoderMIME(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdDecoderMIME;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdDecoderMIME : public Idcoder3to4::TIdDecoder4to3
{
	typedef Idcoder3to4::TIdDecoder4to3 inherited;
	
protected:
	virtual void __fastcall InitComponent(void);
	
public:
	__fastcall TIdDecoderMIME(System::Classes::TComponent* AOwner)/* overload */;
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdDecoderMIME(void)/* overload */ : Idcoder3to4::TIdDecoder4to3() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdDecoderMIME(void) { }
	
};

#pragma pack(pop)

class DELPHICLASS TIdDecoderMIMELineByLine;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdDecoderMIMELineByLine : public TIdDecoderMIME
{
	typedef TIdDecoderMIME inherited;
	
protected:
	Idglobal::TIdBytes FLeftFromLastTime;
	
public:
	virtual void __fastcall DecodeBegin(System::Classes::TStream* ADestStream);
	virtual void __fastcall DecodeEnd(void);
	virtual void __fastcall Decode(System::Classes::TStream* ASrcStream, const int ABytes = 0xffffffff)/* overload */;
public:
	/* TIdDecoderMIME.Create */ inline __fastcall TIdDecoderMIMELineByLine(System::Classes::TComponent* AOwner)/* overload */ : TIdDecoderMIME(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdDecoderMIMELineByLine(void)/* overload */ : TIdDecoderMIME() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdDecoderMIMELineByLine(void) { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Decode(const System::UnicodeString AIn){ Idcoder::TIdDecoder::Decode(AIn); }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString GBase64CodeTable;
extern DELPHI_PACKAGE Idcoder3to4::TIdDecodeTable GBase64DecodeTable;
}	/* namespace Idcodermime */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCODERMIME)
using namespace Idcodermime;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdcodermimeHPP
