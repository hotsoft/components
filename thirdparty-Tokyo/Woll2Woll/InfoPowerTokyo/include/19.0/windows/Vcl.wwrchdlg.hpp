// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwrchdlg.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwrchdlgHPP
#define Vcl_WwrchdlgHPP

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
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <vcl.wwintl.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.Wwdotdot.hpp>
#include <vcl.Wwdbcomb.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <vcl.Wwsystem.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.wwriched.hpp>
#include <vcl.Wwcommon.hpp>
#include <Vcl.ExtCtrls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwrchdlg
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwRichParagraphDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwRichParagraphDialog : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* OKBtn;
	Vcl::Stdctrls::TButton* CancelBtn;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Wwdbcomb::TwwDBComboBox* AlignmentCombo;
	Vcl::Extctrls::TBevel* Bevel1;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TEdit* LeftEdit;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TEdit* RightEdit;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TEdit* FirstLineEdit;
	Vcl::Stdctrls::TLabel* GroupBox1;
	Vcl::Stdctrls::TLabel* SpacingGroup;
	Vcl::Extctrls::TBevel* Bevel2;
	Vcl::Stdctrls::TLabel* BeforeParagraphLabel;
	Vcl::Stdctrls::TEdit* BeforeParagraphEdit;
	Vcl::Stdctrls::TLabel* AfterParagraphLabel;
	Vcl::Stdctrls::TEdit* AfterParagraphEdit;
	Vcl::Stdctrls::TLabel* WithinParagraphLabel;
	Vcl::Stdctrls::TEdit* WithinParagraphEdit;
	Vcl::Stdctrls::TComboBox* LineSpacingComboBox;
	Vcl::Stdctrls::TLabel* WithinParagraphAt;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall OKClick(System::TObject* Sender);
	void __fastcall LineSpacingComboBoxClick(System::TObject* Sender);
	void __fastcall LineSpacingComboBoxChange(System::TObject* Sender);
	void __fastcall WithinParagraphEditKeyPress(System::TObject* Sender, System::WideChar &Key);
	
private:
	void __fastcall ApplyIntl(void);
	
public:
	Vcl::Wwriched::TwwCustomRichEdit* RichEdit;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TwwRichParagraphDialog(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwRichParagraphDialog(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TwwRichParagraphDialog(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwRichParagraphDialog(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwRichParagraphDialog* wwRichParagraphDialog;
extern DELPHI_PACKAGE bool __fastcall wwRichEditParagraphDlg(Vcl::Wwriched::TwwCustomRichEdit* richedit1);
}	/* namespace Wwrchdlg */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWRCHDLG)
using namespace Vcl::Wwrchdlg;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwrchdlgHPP
