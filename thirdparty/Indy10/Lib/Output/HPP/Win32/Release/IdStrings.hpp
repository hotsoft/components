// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdStrings.pas' rev: 25.00 (Windows)

#ifndef IdstringsHPP
#define IdstringsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Idstrings
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString __fastcall StrHtmlEncode(const System::UnicodeString AStr);
extern DELPHI_PACKAGE System::UnicodeString __fastcall StrHtmlDecode(const System::UnicodeString AStr);
extern DELPHI_PACKAGE System::UnicodeString __fastcall StrXHtmlEncode(const System::UnicodeString ASource);
extern DELPHI_PACKAGE System::UnicodeString __fastcall StrXHtmlDecode(const System::UnicodeString ASource);
extern DELPHI_PACKAGE System::UnicodeString __fastcall BinToHexStr(System::Byte AData);
extern DELPHI_PACKAGE bool __fastcall IsWhiteString(const System::UnicodeString AStr);
extern DELPHI_PACKAGE void __fastcall SplitString(const System::UnicodeString AStr, const System::UnicodeString AToken, System::UnicodeString &VLeft, System::UnicodeString &VRight);
extern DELPHI_PACKAGE System::UnicodeString __fastcall CommaAdd(const System::UnicodeString AStr1, const System::UnicodeString AStr2);
}	/* namespace Idstrings */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDSTRINGS)
using namespace Idstrings;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IdstringsHPP
