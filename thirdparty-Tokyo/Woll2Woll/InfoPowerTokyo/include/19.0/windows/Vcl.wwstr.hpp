// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwstr.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwstrHPP
#define Vcl_WwstrHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Vcl.Dialogs.hpp>
#include <vcl.wwtypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwstr
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE System::UnicodeString __fastcall strWhiteSpace(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwExtractFileNameOnly(const System::UnicodeString FileName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetToken(System::UnicodeString s, System::UnicodeString Delimiter, int Index);
extern DELPHI_PACKAGE System::UnicodeString __fastcall strGetToken(System::UnicodeString s, System::UnicodeString delimeter, int &APos);
extern DELPHI_PACKAGE void __fastcall strBreakApart(System::UnicodeString s, System::UnicodeString delimeter, System::Classes::TStrings* parts);
extern DELPHI_PACKAGE void __fastcall strStripWhiteSpace(System::UnicodeString &s);
extern DELPHI_PACKAGE void __fastcall strStripPreceding(System::UnicodeString &s, System::UnicodeString delimeter);
extern DELPHI_PACKAGE void __fastcall strStripTrailing(System::UnicodeString &s, System::UnicodeString delimeter);
extern DELPHI_PACKAGE System::UnicodeString __fastcall strRemoveChar(System::UnicodeString str, System::WideChar removeChar);
extern DELPHI_PACKAGE System::UnicodeString __fastcall strReplaceChar(System::UnicodeString str, System::WideChar removeChar, System::WideChar replaceChar);
extern DELPHI_PACKAGE System::UnicodeString __fastcall strReplaceCharWithStr(System::UnicodeString str, System::WideChar removeChar, System::UnicodeString replaceStr);
extern DELPHI_PACKAGE bool __fastcall wwEqualStr(System::UnicodeString s1, System::UnicodeString s2);
extern DELPHI_PACKAGE int __fastcall strCount(System::UnicodeString s, System::WideChar delimeter);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetWord(System::UnicodeString s, int &APos, Vcl::Wwtypes::TwwGetWordOptions Options, System::UnicodeString DelimChars);
extern DELPHI_PACKAGE System::UnicodeString __fastcall strTrailing(System::UnicodeString s, System::WideChar delimeter);
extern DELPHI_PACKAGE System::UnicodeString __fastcall strPreceding(System::UnicodeString s, System::WideChar delimeter);
extern DELPHI_PACKAGE System::UnicodeString __fastcall strReplace(System::UnicodeString s, System::UnicodeString Find, System::UnicodeString Replace);
extern DELPHI_PACKAGE bool __fastcall strCharMatch(const System::WideChar ch, System::UnicodeString SetChar);
extern DELPHI_PACKAGE int __fastcall wwFindToken(System::UnicodeString s, System::UnicodeString Delimiter, System::UnicodeString Token);
}	/* namespace Wwstr */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWSTR)
using namespace Vcl::Wwstr;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwstrHPP
