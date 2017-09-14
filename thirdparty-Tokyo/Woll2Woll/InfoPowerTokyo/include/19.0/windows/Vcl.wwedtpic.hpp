// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwedtpic.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwedtpicHPP
#define Vcl_WwedtpicHPP

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
#include <Vcl.Grids.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <vcl.Wwpicdb.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwedtpic
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwPictureDialog;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwPictureDialog : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Grids::TStringGrid* StringGrid1;
	Vcl::Buttons::TBitBtn* BitBtn1;
	Vcl::Buttons::TBitBtn* BitBtn2;
	Vcl::Buttons::TBitBtn* OKBtn;
	Vcl::Buttons::TBitBtn* CancelBtn;
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall BitBtn1Click(System::TObject* Sender);
	void __fastcall BitBtn2Click(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall StringGrid1DblClick(System::TObject* Sender);
	
private:
	void __fastcall DeleteCurrentRow(void);
	
public:
	bool MaskChanged;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TwwPictureDialog(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwPictureDialog(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TwwPictureDialog(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwPictureDialog(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwPictureDialog* wwPictureDialog;
}	/* namespace Wwedtpic */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWEDTPIC)
using namespace Vcl::Wwedtpic;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwedtpicHPP
