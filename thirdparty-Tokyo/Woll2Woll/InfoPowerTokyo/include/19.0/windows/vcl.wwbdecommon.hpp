// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwbdecommon.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwbdecommonHPP
#define Vcl_WwbdecommonHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <BDE.hpp>
#include <Data.DB.hpp>
#include <Bde.DBTables.hpp>
#include <Data.DBCommon.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Dialogs.hpp>
#include <vcl.wwtypes.hpp>
#include <System.Classes.hpp>
#include <vcl.Wwstr.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Controls.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Buttons.hpp>
#include <vcl.Wwcommon.hpp>
#include <Vcl.StdCtrls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwbdecommon
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool __fastcall wwSaveAnswerTable(Bde::Dbtables::TDBDataSet* ADataSet, Bde::hDBICur AHandle, System::UnicodeString tableName);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetAlias(System::UnicodeString aliasName);
extern DELPHI_PACKAGE int __fastcall wwCallbackMemoRead(Bde::Dbtables::TBDEDataSet* DataSet, void * FFilterBuffer, void *Buffer, Data::Db::TField* curField, int Count);
extern DELPHI_PACKAGE bool __fastcall wwSetLookupField(Data::Db::TDataSet* dataSet, Data::Db::TField* linkedField);
extern DELPHI_PACKAGE char * __fastcall wwGetQueryText(System::Classes::TStrings* tempQBE, bool Sql);
}	/* namespace Wwbdecommon */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWBDECOMMON)
using namespace Vcl::Wwbdecommon;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwbdecommonHPP
