// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwprprx.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwprprxHPP
#define Vcl_WwprprxHPP

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
#include <vcl.wwdblook.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Data.DB.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.Wwdotdot.hpp>
#include <vcl.wwdbigrd.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <vcl.Wwpicdb.hpp>
#include <Vcl.Grids.hpp>
#include <vcl.wwdbgrid.hpp>
#include <System.IniFiles.hpp>
#include <System.Win.Registry.hpp>
#include <vcl.wwedtpic.hpp>
#include <vcl.ipdsgn.hpp>
#include <vcl.wwintl.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwprprx
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwEditRegexForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwEditRegexForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Buttons::TBitBtn* OKBtn;
	Vcl::Buttons::TBitBtn* CancelBtn;
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TMemo* PictureDescription;
	Vcl::Stdctrls::TButton* Button1;
	Vcl::Stdctrls::TButton* Button2;
	Vcl::Stdctrls::TGroupBox* GroupBox2;
	Vcl::Wwdbedit::TwwDBEdit* wwPictureEdit1;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TButton* Button3;
	Vcl::Extctrls::TPanel* Status;
	Vcl::Stdctrls::TCheckBox* AutoFill;
	Vcl::Stdctrls::TButton* Button4;
	Vcl::Wwdotdot::TwwDBComboDlg* NewPicture;
	Vcl::Wwintl::TwwIntl* wwIntl1;
	void __fastcall NewPictureChange(System::TObject* Sender);
	void __fastcall wwPictureEdit1Change(System::TObject* Sender);
	void __fastcall Button1Click(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall Button2Click(System::TObject* Sender);
	void __fastcall AutoFillClick(System::TObject* Sender);
	void __fastcall Button3Click(System::TObject* Sender);
	void __fastcall Button4Click(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall NewPictureCustomDlg(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	void __fastcall NewPictureExit(System::TObject* Sender);
	
private:
	Vcl::Stdctrls::TCustomEdit* Component;
	System::UnicodeString OrigRegexMask;
	bool OrigCaseSensitive;
	void __fastcall RefreshDescription(void);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TwwEditRegexForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwEditRegexForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TwwEditRegexForm(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwEditRegexForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwEditRegexForm* wwEditRegexForm;
extern DELPHI_PACKAGE bool __fastcall wwPrpEdit_RegexMask(Vcl::Wwdbedit::TwwCustomMaskEdit* AComponent);
}	/* namespace Wwprprx */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWPRPRX)
using namespace Vcl::Wwprprx;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwprprxHPP
