// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwfltfld.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwfltfldHPP
#define Vcl_WwfltfldHPP

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
#include <Data.DB.hpp>
#include <DesignIntf.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.TabNotBk.hpp>
#include <Vcl.Tabs.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <vcl.wwdblook.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.Wwdbcomb.hpp>
#include <vcl.wwdbgrid.hpp>
#include <vcl.wwdbdlg.hpp>
#include <vcl.wwIDlg.hpp>
#include <vcl.wwprpfld.hpp>
#include <vcl.Wwfltdlg.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwfltfld
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TSelFilterFieldsForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TSelFilterFieldsForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Vcl::Stdctrls::TListBox* DstList;
	Vcl::Stdctrls::TButton* AddButton;
	Vcl::Stdctrls::TButton* Button3;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TEdit* FieldDisplay;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Extctrls::TPanel* OKCancelPanel;
	Vcl::Buttons::TBitBtn* OKBtn;
	Vcl::Buttons::TBitBtn* CancelBtn;
	bool __fastcall InDestList(System::UnicodeString Value);
	void __fastcall ExcludeItems(void);
	void __fastcall ExcludeBtnClick(System::TObject* Sender);
	void __fastcall Button3Click(System::TObject* Sender);
	void __fastcall AddButtonClick(System::TObject* Sender);
	void __fastcall DstListDragDrop(System::TObject* Sender, System::TObject* Source, int X, int Y);
	void __fastcall DstListDragOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall DstListMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall DstListClick(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormResize(System::TObject* Sender);
	void __fastcall DstListKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FieldDisplayExit(System::TObject* Sender);
	
private:
	Data::Db::TField* curField;
	int dragFromRow;
	bool initialized;
	System::Classes::TStrings* SrcListItems;
	System::Classes::TStrings* SelectedList;
	Vcl::Wwfltdlg::TwwFilterDialog* Dialog;
	void __fastcall UpdateFieldDisplay(void);
	int __fastcall GetSelectedListIndex(System::UnicodeString value);
	
public:
	__fastcall virtual TSelFilterFieldsForm(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TSelFilterFieldsForm(void);
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TSelFilterFieldsForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TSelFilterFieldsForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool __fastcall wwSelectFilterableFields(Vcl::Wwfltdlg::TwwFilterDialog* ADialog, System::Classes::TStrings* FieldList);
}	/* namespace Wwfltfld */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWFLTFLD)
using namespace Vcl::Wwfltfld;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwfltfldHPP
