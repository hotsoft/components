// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwgridselectcolumns.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwgridselectcolumnsHPP
#define Vcl_WwgridselectcolumnsHPP

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
#include <vcl.Wwsystem.hpp>
#include <Vcl.CheckLst.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.ComCtrls.hpp>
#include <vcl.wwgridfilter.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.wwtreeview.hpp>
#include <vcl.wwdbigrd.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwgridselectcolumns
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwGridSelectColumnsForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwGridSelectColumnsForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Checklst::TCheckListBox* CheckListBox1;
	Vcl::Wwdbigrd::TwwSelectColumnsTreeView* TreeView1;
	void __fastcall FormResize(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	
private:
	bool OKBtnpressed;
	Vcl::Grids::TCustomGrid* FGrid;
	void __fastcall OKBtnClick(System::TObject* Sender);
	
public:
	Vcl::Stdctrls::TButton* OKBtn;
	Vcl::Stdctrls::TButton* CancelBtn;
	__fastcall virtual TwwGridSelectColumnsForm(System::Classes::TComponent* AOwner);
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwGridSelectColumnsForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TwwGridSelectColumnsForm(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwGridSelectColumnsForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwGridSelectColumnsForm* wwGridSelectColumnsForm;
}	/* namespace Wwgridselectcolumns */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWGRIDSELECTCOLUMNS)
using namespace Vcl::Wwgridselectcolumns;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwgridselectcolumnsHPP
