// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwprpcom.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwprpcomHPP
#define Vcl_WwprpcomHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.Dialogs.hpp>
#include <System.SysUtils.hpp>
#include <vcl.Wwstr.hpp>
#include <Vcl.ExtCtrls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwprpcom
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwPrpEditComboList;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwPrpEditComboList : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Buttons::TBitBtn* OKBtn;
	Vcl::Buttons::TBitBtn* CancelBtn;
	Vcl::Extctrls::TNotebook* Notebook1;
	Vcl::Grids::TStringGrid* StringGrid1;
	Vcl::Stdctrls::TMemo* Memo1;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TCheckBox* SeparateStoredList;
	Vcl::Stdctrls::TButton* Button1;
	Vcl::Stdctrls::TButton* btnRemoveItem;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall StringGrid1KeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall SeparateStoredListClick(System::TObject* Sender);
	void __fastcall Button1Click(System::TObject* Sender);
	void __fastcall FormCloseQuery(System::TObject* Sender, bool &CanClose);
	void __fastcall OKBtnClick(System::TObject* Sender);
	void __fastcall btnRemoveItemClick(System::TObject* Sender);
	
private:
	bool MapList;
	System::Classes::TStrings* Items;
	bool init;
	bool changingMapCheckbox;
	bool okBtnPressed;
	bool changed;
	int startWidth1;
	void __fastcall DeleteCurrentRow(void);
	void __fastcall ComputeGridColumns(void);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TwwPrpEditComboList(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwPrpEditComboList(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TwwPrpEditComboList(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwPrpEditComboList(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwPrpEditComboList* wwPrpEditComboList;
extern DELPHI_PACKAGE bool __fastcall wwEditComboList(System::Classes::TStrings* AItems, bool &AMapList);
}	/* namespace Wwprpcom */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWPRPCOM)
using namespace Vcl::Wwprpcom;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwprpcomHPP
