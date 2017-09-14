// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwfilter.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwfilterHPP
#define Vcl_WwfilterHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Bde.DBTables.hpp>
#include <Data.DB.hpp>
#include <vcl.Wwstacks.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.Wwsystem.hpp>
#include <BDE.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwfilter
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool __fastcall wwSetFilter(System::UnicodeString a_line, Bde::Dbtables::TTable* table, Bde::hDBIFilter &fh, bool InOpen);
extern DELPHI_PACKAGE void __fastcall wwRemoveFilter(Bde::Dbtables::TDBDataSet* table, Bde::hDBIFilter &fh);
extern DELPHI_PACKAGE bool __fastcall wwAddFilter(System::UnicodeString a_line, Bde::Dbtables::TTable* table, Bde::hDBIFilter &fh);
extern DELPHI_PACKAGE bool __fastcall wwSetFilterFunction(void * func, Bde::Dbtables::TDBDataSet* table, Bde::hDBIFilter &fh);
}	/* namespace Wwfilter */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWFILTER)
using namespace Vcl::Wwfilter;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwfilterHPP
