// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCoder00E.pas' rev: 25.00 (Windows)

#ifndef Idcoder00eHPP
#define Idcoder00eHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdCoder3to4.hpp>	// Pascal unit
#include <IdCoder.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcoder00e
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TIdDecoder00E;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdDecoder00E : public Idcoder3to4::TIdDecoder4to3
{
	typedef Idcoder3to4::TIdDecoder4to3 inherited;
	
public:
	virtual void __fastcall Decode(System::Classes::TStream* ASrcStream, const int ABytes = 0xffffffff)/* overload */;
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdDecoder00E(System::Classes::TComponent* AOwner)/* overload */ : Idcoder3to4::TIdDecoder4to3(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdDecoder00E(void)/* overload */ : Idcoder3to4::TIdDecoder4to3() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdDecoder00E(void) { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Decode(const System::UnicodeString AIn){ Idcoder::TIdDecoder::Decode(AIn); }
	
};

#pragma pack(pop)

class DELPHICLASS TIdEncoder00E;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdEncoder00E : public Idcoder3to4::TIdEncoder3to4
{
	typedef Idcoder3to4::TIdEncoder3to4 inherited;
	
public:
	virtual void __fastcall Encode(System::Classes::TStream* ASrcStream, System::Classes::TStream* ADestStream, const int ABytes = 0xffffffff)/* overload */;
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdEncoder00E(System::Classes::TComponent* AOwner)/* overload */ : Idcoder3to4::TIdEncoder3to4(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdEncoder00E(void)/* overload */ : Idcoder3to4::TIdEncoder3to4() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdEncoder00E(void) { }
	
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
}	/* namespace Idcoder00e */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCODER00E)
using namespace Idcoder00e;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idcoder00eHPP
