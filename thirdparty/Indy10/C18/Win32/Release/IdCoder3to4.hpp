// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdCoder3to4.pas' rev: 25.00 (Windows)

#ifndef Idcoder3to4HPP
#define Idcoder3to4HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <IdCoder.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <IdBaseComponent.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idcoder3to4
{
//-- type declarations -------------------------------------------------------
typedef System::StaticArray<System::Byte, 127> TIdDecodeTable;

class DELPHICLASS TIdEncoder3to4;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdEncoder3to4 : public Idcoder::TIdEncoder
{
	typedef Idcoder::TIdEncoder inherited;
	
protected:
	Idglobal::TIdBytes FCodingTable;
	System::WideChar FFillChar;
	Idglobal::TIdBytes __fastcall InternalEncode(const Idglobal::TIdBytes ABuffer);
	
public:
	virtual void __fastcall Encode(System::Classes::TStream* ASrcStream, System::Classes::TStream* ADestStream, const int ABytes = 0xffffffff)/* overload */;
	__property Idglobal::TIdBytes CodingTable = {read=FCodingTable};
	
__published:
	__property System::WideChar FillChar = {read=FFillChar, write=FFillChar, nodefault};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdEncoder3to4(System::Classes::TComponent* AOwner)/* overload */ : Idcoder::TIdEncoder(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdEncoder3to4(void)/* overload */ : Idcoder::TIdEncoder() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdEncoder3to4(void) { }
	
/* Hoisted overloads: */
	
public:
	inline System::UnicodeString __fastcall  Encode(const System::UnicodeString AIn, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding()){ return Idcoder::TIdEncoder::Encode(AIn, AByteEncoding); }
	inline void __fastcall  Encode(const System::UnicodeString AIn, System::Classes::TStrings* ADestStrings, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding()){ Idcoder::TIdEncoder::Encode(AIn, ADestStrings, AByteEncoding); }
	inline void __fastcall  Encode(const System::UnicodeString AIn, System::Classes::TStream* ADestStream, Idglobal::_di_IIdTextEncoding AByteEncoding = Idglobal::_di_IIdTextEncoding()){ Idcoder::TIdEncoder::Encode(AIn, ADestStream, AByteEncoding); }
	inline System::UnicodeString __fastcall  Encode(System::Classes::TStream* ASrcStream, const int ABytes = 0xffffffff){ return Idcoder::TIdEncoder::Encode(ASrcStream, ABytes); }
	inline void __fastcall  Encode(System::Classes::TStream* ASrcStream, System::Classes::TStrings* ADestStrings, const int ABytes = 0xffffffff){ Idcoder::TIdEncoder::Encode(ASrcStream, ADestStrings, ABytes); }
	
};

#pragma pack(pop)

typedef System::TMetaClass* TIdEncoder3to4Class;

class DELPHICLASS TIdDecoder4to3;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TIdDecoder4to3 : public Idcoder::TIdDecoder
{
	typedef Idcoder::TIdDecoder inherited;
	
protected:
	Idglobal::TIdBytes FCodingTable;
	TIdDecodeTable FDecodeTable;
	System::WideChar FFillChar;
	Idglobal::TIdBytes __fastcall InternalDecode(const Idglobal::TIdBytes ABuffer, const bool AIgnoreFiller = false);
	
public:
	__classmethod void __fastcall ConstructDecodeTable(const System::UnicodeString ACodingTable, TIdDecodeTable &ADecodeArray);
	virtual void __fastcall Decode(System::Classes::TStream* ASrcStream, const int ABytes = 0xffffffff)/* overload */;
	
__published:
	__property System::WideChar FillChar = {read=FFillChar, write=FFillChar, nodefault};
public:
	/* TIdBaseComponent.Create */ inline __fastcall TIdDecoder4to3(System::Classes::TComponent* AOwner)/* overload */ : Idcoder::TIdDecoder(AOwner) { }
	
public:
	/* TIdInitializerComponent.Create */ inline __fastcall TIdDecoder4to3(void)/* overload */ : Idcoder::TIdDecoder() { }
	
public:
	/* TComponent.Destroy */ inline __fastcall virtual ~TIdDecoder4to3(void) { }
	
/* Hoisted overloads: */
	
public:
	inline void __fastcall  Decode(const System::UnicodeString AIn){ Idcoder::TIdDecoder::Decode(AIn); }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Idcoder3to4 */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDCODER3TO4)
using namespace Idcoder3to4;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idcoder3to4HPP
