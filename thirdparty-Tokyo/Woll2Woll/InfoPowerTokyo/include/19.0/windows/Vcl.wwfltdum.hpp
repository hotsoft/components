// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwfltdum.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwfltdumHPP
#define Vcl_WwfltdumHPP

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
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Data.DB.hpp>
#include <vcl.wwtypes.hpp>
#include <Vcl.ComCtrls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwfltdum
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwDummyForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwDummyForm : public Vcl::Forms::TCustomForm
{
	typedef Vcl::Forms::TCustomForm inherited;
	
private:
	Data::Db::TParam* FFilterParam;
	char *FFilterFieldBuffer;
	
public:
	System::Classes::TComponent* DlgComponent;
	bool MatchAny;
	Data::Db::TDataSet* DataSet;
	System::Classes::TStringStream* MemoryStream;
	Vcl::Comctrls::TCustomRichEdit* TempRichEdit;
	void __fastcall OnFilterEvent(Data::Db::TDataSet* table, bool &Accept);
	Data::Db::TParam* __fastcall GetFilterField(System::UnicodeString AFieldName);
	bool __fastcall IsNullValue(System::UnicodeString Token, System::UnicodeString Value, System::UnicodeString NullStr);
	bool __fastcall CheckFilterField(int Index);
	__fastcall virtual TwwDummyForm(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDummyForm(void);
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwDummyForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TCustomForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDummyForm(HWND ParentWindow) : Vcl::Forms::TCustomForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwDummyForm* wwDummyForm;
}	/* namespace Wwfltdum */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWFLTDUM)
using namespace Vcl::Wwfltdum;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwfltdumHPP
