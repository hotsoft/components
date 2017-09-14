// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwinputstring2.pas' rev: 32.00 (Windows)

#ifndef Vcl_Wwinputstring2HPP
#define Vcl_Wwinputstring2HPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Variants.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.wwintl.hpp>
#include <vcl.Wwcommon.hpp>
#include <Data.DB.hpp>
#include <vcl.Wwdbdatetimepicker.hpp>
#include <vcl.Wwsystem.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwinputstring2
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwInputTwoStringForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwInputTwoStringForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Wwdbedit::TwwDBEdit* filtervalue;
	Vcl::Stdctrls::TLabel* FilterLabel;
	Vcl::Stdctrls::TLabel* FilterLabel2;
	Vcl::Wwdbdatetimepicker::TwwDBDateTimePicker* FilterDateEdit;
	Vcl::Wwdbedit::TwwDBEdit* filterValue2;
	Vcl::Stdctrls::TLabel* FieldLabel;
	Vcl::Wwdbdatetimepicker::TwwDBDateTimePicker* FilterDateEdit2;
	void __fastcall FormResize(System::TObject* Sender);
	void __fastcall FormCloseQuery(System::TObject* Sender, bool &CanClose);
	void __fastcall FormShow(System::TObject* Sender);
	
private:
	bool OKBtnpressed;
	Data::Db::TField* Field;
	void __fastcall OKBtnClick(System::TObject* Sender);
	
public:
	Vcl::Stdctrls::TButton* OKBtn;
	Vcl::Stdctrls::TButton* CancelBtn;
	__fastcall virtual TwwInputTwoStringForm(System::Classes::TComponent* AOwner);
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwInputTwoStringForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TwwInputTwoStringForm(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwInputTwoStringForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwInputTwoStringForm* wwInputTwoStringForm;
extern DELPHI_PACKAGE bool __fastcall wwInputTwoStringDialog(System::Classes::TComponent* AOwner, Data::Db::TField* AField, System::UnicodeString fieldCaption, System::UnicodeString &value, System::UnicodeString &value2);
}	/* namespace Wwinputstring2 */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWINPUTSTRING2)
using namespace Vcl::Wwinputstring2;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_Wwinputstring2HPP
