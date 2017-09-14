// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwpiced2.pas' rev: 32.00 (Windows)

#ifndef Vcl_Wwpiced2HPP
#define Vcl_Wwpiced2HPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Data.DB.hpp>
#include <vcl.Wwdbedit.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.Wwdotdot.hpp>
#include <System.IniFiles.hpp>
#include <System.Win.Registry.hpp>
#include <vcl.wwedtpic.hpp>
#include <vcl.ipdsgn.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwpiced2
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwEditPictureMaskdlg;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwEditPictureMaskdlg : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Buttons::TBitBtn* OKBtn;
	Vcl::Buttons::TBitBtn* CancelBtn;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TCheckBox* AllowInvalidCheckbox;
	Vcl::Stdctrls::TCheckBox* AutoFillCheckbox;
	Vcl::Stdctrls::TMemo* PictureDescription;
	Vcl::Stdctrls::TLabel* PictureMaskLabel;
	Vcl::Stdctrls::TButton* DesignMaskButton;
	Vcl::Stdctrls::TCheckBox* UsePictureMask;
	Vcl::Wwdotdot::TwwDBComboDlg* PictureMaskEdit;
	void __fastcall PictureMaskEditChange(System::TObject* Sender);
	void __fastcall PictureMaskEditCloseUp(System::TObject* Sender, Data::Db::TDataSet* LookupTable, Data::Db::TDataSet* FillTable, bool modified);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall DesignMaskButtonClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall PictureMaskEditCustomDlg(System::TObject* Sender);
	void __fastcall PictureMaskEditExit(System::TObject* Sender);
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormDestroy(System::TObject* Sender);
	
private:
	void __fastcall RefreshDescription(void);
	void __fastcall VerifyKeyValue(System::UnicodeString &Key, System::UnicodeString &Value);
	
public:
	Vcl::Wwdbedit::TwwCustomMaskEdit* MyComponent;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TwwEditPictureMaskdlg(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwEditPictureMaskdlg(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TwwEditPictureMaskdlg(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwEditPictureMaskdlg(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwEditPictureMaskdlg* wwEditPictureMaskdlg;
extern DELPHI_PACKAGE bool __fastcall wwPrpEdit_PictureMask2(Vcl::Wwdbedit::TwwCustomMaskEdit* AComponent);
extern DELPHI_PACKAGE bool __fastcall wwPrpEdit_PictureMask3(Vcl::Wwdbedit::TwwDBPicture* Picture, Vcl::Controls::TWinControl* TempParent);
}	/* namespace Wwpiced2 */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWPICED2)
using namespace Vcl::Wwpiced2;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_Wwpiced2HPP
