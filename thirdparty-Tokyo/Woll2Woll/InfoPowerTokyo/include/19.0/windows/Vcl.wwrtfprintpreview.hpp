// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwrtfprintpreview.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwrtfprintpreviewHPP
#define Vcl_WwrtfprintpreviewHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Vcl.ToolWin.hpp>
#include <Winapi.RichEdit.hpp>
#include <vcl.wwriched.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.ImgList.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.Wwdotdot.hpp>
#include <vcl.Wwdbcomb.hpp>
#include <vcl.Wwdbspin.hpp>
#include <vcl.Wwcommon.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwrtfprintpreview
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwRtfPreviewForm;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwRtfPreviewForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
	
private:
	typedef System::DynamicArray<CHARRANGE> _TwwRtfPreviewForm__1;
	
	
__published:
	Vcl::Comctrls::TToolBar* ToolBar1;
	Vcl::Forms::TScrollBox* ScrollBox1;
	Vcl::Extctrls::TPaintBox* PaintBox1;
	Vcl::Dialogs::TPrintDialog* PrintDialog;
	Vcl::Controls::TImageList* RichEditButtonIcons;
	Vcl::Menus::TPopupMenu* PopupMenu1;
	Vcl::Menus::TMenuItem* N5001;
	Vcl::Menus::TMenuItem* N2001;
	Vcl::Menus::TMenuItem* N1501;
	Vcl::Menus::TMenuItem* N10001;
	Vcl::Menus::TMenuItem* N751;
	Vcl::Menus::TMenuItem* N501;
	Vcl::Menus::TMenuItem* N251;
	Vcl::Menus::TMenuItem* Auto1;
	Vcl::Wwdbcomb::TwwDBComboBox* zoomCombo;
	Vcl::Comctrls::TToolButton* ToolButton2;
	Vcl::Comctrls::TToolButton* ToolButton5;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Wwdbspin::TwwDBSpinEdit* wwDBSpinEdit1;
	void __fastcall PaintBox1Paint(System::TObject* Sender);
	void __fastcall ToolButton1Click(System::TObject* Sender);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall ScrollBox1Resize(System::TObject* Sender);
	void __fastcall wwDBSpinEdit1Change(System::TObject* Sender);
	void __fastcall ToolButton5Click(System::TObject* Sender);
	void __fastcall ToolButton2Click(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall zoomComboChange(System::TObject* Sender);
	
private:
	Vcl::Graphics::TMetafile* FMetafile;
	Vcl::Wwriched::TwwCustomRichEdit* FRichedit;
	_TwwRtfPreviewForm__1 FPages;
	System::Types::TRect FPagerect;
	System::Types::TRect FPrintRect;
	double FZoomFactor;
	int NumPages;
	void __fastcall PreparePreview(Vcl::Wwriched::TwwCustomRichEdit* aRichedit);
	void __fastcall Paginate(void);
	void __fastcall DrawPage(int pagenum);
	int __fastcall RenderPage(int pagenum, System::LongBool render = true);
	void __fastcall VerifyPagenum(int pagenum);
	void __fastcall PrintHeader(Vcl::Graphics::TCanvas* cv);
	void __fastcall UpdateZoom(void);
	void __fastcall DrawScaled(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &outrect, Vcl::Graphics::TGraphic* image, int iwidth, int iheight);
	
public:
	__fastcall virtual ~TwwRtfPreviewForm(void);
	__fastcall virtual TwwRtfPreviewForm(System::Classes::TComponent* AOwner);
	__classmethod void __fastcall Preview(Vcl::Wwriched::TwwCustomRichEdit* arichedit);
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwRtfPreviewForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwRtfPreviewForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwRtfPreviewForm* wwRtfPreviewForm;
}	/* namespace Wwrtfprintpreview */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWRTFPRINTPREVIEW)
using namespace Vcl::Wwrtfprintpreview;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwrtfprintpreviewHPP
