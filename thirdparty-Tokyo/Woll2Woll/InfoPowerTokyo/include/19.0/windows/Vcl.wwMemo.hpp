// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwmemo.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwmemoHPP
#define Vcl_WwmemoHPP

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
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.DBCtrls.hpp>
#include <Data.DB.hpp>
#include <Vcl.Dialogs.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Menus.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwmemo
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwMemoDlg;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwMemoAttribute : unsigned char { mSizeable, mWordWrap, mGridShow, mViewOnly, mDisableDialog };

typedef System::Set<TwwMemoAttribute, TwwMemoAttribute::mSizeable, TwwMemoAttribute::mDisableDialog> TwwMemoAttributes;

class PASCALIMPLEMENTATION TwwMemoDlg : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TMemo* Memo;
	Vcl::Extctrls::TPanel* UserButtonPanel;
	Vcl::Stdctrls::TButton* UserButton1;
	Vcl::Stdctrls::TButton* UserButton2;
	Vcl::Menus::TPopupMenu* PopupMenu1;
	void __fastcall ResizeControls(System::TObject* Sender);
	void __fastcall OKBtnClick(System::TObject* Sender);
	void __fastcall FormCloseQuery(System::TObject* Sender, bool &CanClose);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall MemoKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall UserButton1Click(System::TObject* Sender);
	void __fastcall UserButton2Click(System::TObject* Sender);
	void __fastcall MemoChange(System::TObject* Sender);
	
private:
	bool OKBtnpressed;
	System::Types::TRect posRect;
	void __fastcall ApplyIntl(void);
	
protected:
	bool changed;
	bool init;
	bool allowClose;
	DYNAMIC void __fastcall KeyPress(System::WideChar &key);
	
public:
	Vcl::Graphics::TFont* TempFont;
	System::UnicodeString TempTitle;
	System::Classes::TComponent* CallingComponent;
	Vcl::Stdctrls::TButton* OKBtn;
	Vcl::Stdctrls::TButton* CancelBtn;
	__fastcall virtual TwwMemoDlg(System::Classes::TComponent* AOwner);
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwMemoDlg(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TwwMemoDlg(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwMemoDlg(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool __fastcall wwEditMemoField(Vcl::Forms::TForm* AParentForm, System::Classes::TComponent* ADialog, bool Editable);
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwmemo */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWMEMO)
using namespace Vcl::Wwmemo;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwmemoHPP
