// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdASN1Util.pas' rev: 25.00 (Windows)

#ifndef Idasn1utilHPP
#define Idasn1utilHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idasn1util
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
static const System::Int8 ASN1_INT = System::Int8(0x2);
static const System::Int8 ASN1_OCTSTR = System::Int8(0x4);
static const System::Int8 ASN1_NULL = System::Int8(0x5);
static const System::Int8 ASN1_OBJID = System::Int8(0x6);
static const System::Int8 ASN1_SEQ = System::Int8(0x30);
static const System::Int8 ASN1_IPADDR = System::Int8(0x40);
static const System::Int8 ASN1_COUNTER = System::Int8(0x41);
static const System::Int8 ASN1_GAUGE = System::Int8(0x42);
static const System::Int8 ASN1_TIMETICKS = System::Int8(0x43);
static const System::Int8 ASN1_OPAQUE = System::Int8(0x44);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ASNEncOIDItem(int Value);
extern DELPHI_PACKAGE int __fastcall ASNDecOIDItem(int &Start, const System::UnicodeString Buffer);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ASNEncLen(int Len);
extern DELPHI_PACKAGE int __fastcall ASNDecLen(int &Start, const System::UnicodeString Buffer);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ASNEncInt(int Value);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ASNEncUInt(int Value);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ASNObject(const System::UnicodeString Data, int ASNType);
extern DELPHI_PACKAGE System::UnicodeString __fastcall ASNItem(int &Start, const System::UnicodeString Buffer, int &ValueType);
extern DELPHI_PACKAGE System::UnicodeString __fastcall MibToId(System::UnicodeString Mib);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IdToMib(const System::UnicodeString Id);
extern DELPHI_PACKAGE System::UnicodeString __fastcall IntMibToStr(const System::UnicodeString Value);
}	/* namespace Idasn1util */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDASN1UTIL)
using namespace Idasn1util;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Idasn1utilHPP
