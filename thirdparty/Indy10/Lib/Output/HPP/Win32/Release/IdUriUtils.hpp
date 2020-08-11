// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'IdUriUtils.pas' rev: 25.00 (Windows)

#ifndef IduriutilsHPP
#define IduriutilsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <IdGlobal.hpp>	// Pascal unit
#include <System.Character.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Iduriutils
{
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE int __fastcall CalcUTF16CharLength(const System::UnicodeString AStr, const int AIndex);
extern DELPHI_PACKAGE bool __fastcall WideCharIsInSet(const System::UnicodeString ASet, const System::WideChar AChar);
extern DELPHI_PACKAGE int __fastcall GetUTF16Codepoint(const System::UnicodeString AStr, const int AIndex);
}	/* namespace Iduriutils */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_IDURIUTILS)
using namespace Iduriutils;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// IduriutilsHPP
