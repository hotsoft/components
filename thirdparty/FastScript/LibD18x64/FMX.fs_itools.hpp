// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FMX.fs_itools.pas' rev: 25.00 (Windows)

#ifndef Fmx_Fs_itoolsHPP
#define Fmx_Fs_itoolsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <System.TypInfo.hpp>	// Pascal unit
#include <FMX.fs_iinterpreter.hpp>	// Pascal unit
#include <FMX.fs_xml.hpp>	// Pascal unit
#include <System.Variants.hpp>	// Pascal unit
#include <System.Types.hpp>	// Pascal unit
#include <FMX.Types.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fmx
{
namespace Fs_itools
{
//-- type declarations -------------------------------------------------------
typedef System::DynamicArray<System::TVarRec> TVarRecArray;

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall fsRegisterLanguage(const System::UnicodeString Name, const System::UnicodeString Grammar);
extern DELPHI_PACKAGE System::UnicodeString __fastcall fsGetLanguage(const System::UnicodeString Name);
extern DELPHI_PACKAGE void __fastcall fsGetLanguageList(System::Classes::TStrings* List);
extern DELPHI_PACKAGE Fmx::Fs_iinterpreter::TfsVarType __fastcall StrToVarType(const System::UnicodeString TypeName, Fmx::Fs_iinterpreter::TfsScript* Script);
extern DELPHI_PACKAGE bool __fastcall TypesCompatible(const Fmx::Fs_iinterpreter::TfsTypeRec &Typ1, const Fmx::Fs_iinterpreter::TfsTypeRec &Typ2, Fmx::Fs_iinterpreter::TfsScript* Script);
extern DELPHI_PACKAGE bool __fastcall AssignCompatible(Fmx::Fs_iinterpreter::TfsCustomVariable* Var1, Fmx::Fs_iinterpreter::TfsCustomVariable* Var2, Fmx::Fs_iinterpreter::TfsScript* Script);
extern DELPHI_PACKAGE System::Variant __fastcall VarRecToVariant(const System::TVarRec &v);
extern DELPHI_PACKAGE void __fastcall VariantToVarRec(const System::Variant &v, TVarRecArray &ar);
extern DELPHI_PACKAGE void __fastcall ClearVarRec(TVarRecArray &ar);
extern DELPHI_PACKAGE System::Variant __fastcall ParserStringToVariant(System::UnicodeString s);
extern DELPHI_PACKAGE Fmx::Fs_iinterpreter::TfsCustomVariable* __fastcall ParseMethodSyntax(const System::UnicodeString Syntax, Fmx::Fs_iinterpreter::TfsScript* Script);
extern DELPHI_PACKAGE System::Types::TPoint __fastcall fsPosToPoint(const System::UnicodeString ErrorPos);
extern DELPHI_PACKAGE void __fastcall GenerateXMLContents(Fmx::Fs_iinterpreter::TfsScript* Prog, Fmx::Fs_xml::TfsXMLItem* Item, bool FunctionsOnly = false);
extern DELPHI_PACKAGE void __fastcall GenerateMembers(Fmx::Fs_iinterpreter::TfsScript* Prog, System::TClass cl, Fmx::Fs_xml::TfsXMLItem* Item);
}	/* namespace Fs_itools */
}	/* namespace Fmx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX_FS_ITOOLS)
using namespace Fmx::Fs_itools;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX)
using namespace Fmx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fmx_Fs_itoolsHPP
