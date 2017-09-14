// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwricheditbar.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwricheditbarHPP
#define Vcl_WwricheditbarHPP

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
#include <Vcl.Menus.hpp>
#include <Vcl.ImgList.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <vcl.wwriched.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.Wwdotdot.hpp>
#include <vcl.Wwdbcomb.hpp>
#include <Vcl.ToolWin.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <vcl.Wwtrackicon.hpp>
#include <Vcl.Printers.hpp>
#include <Winapi.RichEdit.hpp>
#include <vcl.wwintl.hpp>
#include <Vcl.ActnPopup.hpp>
#include <vcl.Wwcommon.hpp>
#include <Vcl.PlatformDefaultStyleActnCtrls.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <System.ImageList.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwricheditbar
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwRichBarFrame;
class DELPHICLASS TwwRichEditBar;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwRichEditBarOption : unsigned char { rebShowLoad, rebShowSaveAs, rebShowPrint, rebShowPrintPreview, rebShowPageSetup, rebShowFormatBar, rebShowToolBar, rebShowHints, rebShowRuler, rebFlatButtons, rebShowSpellCheck, rebShowJustifyButton, rebShowZoomCombo, rebGradientToolbars, rebInvertColorsInToolbar };

typedef System::Set<TwwRichEditBarOption, TwwRichEditBarOption::rebShowLoad, TwwRichEditBarOption::rebInvertColorsInToolbar> TwwRichEditBarOptions;

class PASCALIMPLEMENTATION TwwRichBarFrame : public Vcl::Forms::TFrame
{
	typedef Vcl::Forms::TFrame inherited;
	
__published:
	Vcl::Extctrls::TPanel* RichEditBar;
	Vcl::Extctrls::TBevel* FormatBarBevel;
	Vcl::Extctrls::TBevel* RulerBevel;
	Vcl::Comctrls::TToolBar* FormatBar;
	Vcl::Wwdbcomb::TwwDBComboBox* FontNameCombo;
	Vcl::Wwdbcomb::TwwDBComboBox* FontSizeCombo;
	Vcl::Comctrls::TToolButton* BoldButton;
	Vcl::Comctrls::TToolButton* ItalicButton;
	Vcl::Comctrls::TToolButton* UnderlineButton;
	Vcl::Comctrls::TToolButton* ColorButton;
	Vcl::Comctrls::TToolButton* ToolButton3;
	Vcl::Comctrls::TToolButton* LeftButton;
	Vcl::Comctrls::TToolButton* CenterButton;
	Vcl::Comctrls::TToolButton* RightButton;
	Vcl::Comctrls::TToolButton* JustifyButton;
	Vcl::Comctrls::TToolButton* ToolButton1;
	Vcl::Comctrls::TToolButton* BulletButton;
	Vcl::Comctrls::TToolButton* HighlightButton;
	Vcl::Comctrls::TToolBar* Toolbar;
	Vcl::Comctrls::TToolButton* NewButton;
	Vcl::Comctrls::TToolButton* LoadButton;
	Vcl::Comctrls::TToolButton* SaveAsButton;
	Vcl::Comctrls::TToolButton* PrintButton;
	Vcl::Comctrls::TToolButton* Sep2;
	Vcl::Comctrls::TToolButton* FindButton;
	Vcl::Comctrls::TToolButton* SpellButton;
	Vcl::Comctrls::TToolButton* Sep3;
	Vcl::Comctrls::TToolButton* CutButton;
	Vcl::Comctrls::TToolButton* CopyButton;
	Vcl::Comctrls::TToolButton* PasteButton;
	Vcl::Comctrls::TToolButton* Sep4;
	Vcl::Comctrls::TToolButton* UndoButton;
	Vcl::Comctrls::TToolButton* RedoButton;
	Vcl::Comctrls::TToolButton* Sep5;
	Vcl::Controls::TImageList* RichEditButtonIcons;
	Vcl::Dialogs::TPrintDialog* PrintDialog1;
	Vcl::Dialogs::TSaveDialog* SaveDialog1;
	Vcl::Menus::TPopupMenu* PopupMenu1;
	Vcl::Menus::TMenuItem* Black1;
	Vcl::Menus::TMenuItem* Green1;
	Vcl::Menus::TMenuItem* Red1;
	Vcl::Menus::TMenuItem* Blue1;
	Vcl::Menus::TMenuItem* Yellow1;
	Vcl::Menus::TMenuItem* Purple1;
	Vcl::Menus::TMenuItem* Teal1;
	Vcl::Menus::TMenuItem* Gray1;
	Vcl::Menus::TMenuItem* Silver1;
	Vcl::Menus::TMenuItem* Red2;
	Vcl::Menus::TMenuItem* Lime1;
	Vcl::Menus::TMenuItem* Yellow2;
	Vcl::Menus::TMenuItem* Blue2;
	Vcl::Menus::TMenuItem* Fuchsia1;
	Vcl::Menus::TMenuItem* Aqua1;
	Vcl::Menus::TMenuItem* White1;
	Vcl::Menus::TMenuItem* Automatic1;
	Vcl::Dialogs::TOpenDialog* OpenDialog1;
	Vcl::Comctrls::TToolButton* PrintPreviewButton;
	Vcl::Comctrls::TToolButton* Sep1;
	Vcl::Menus::TPopupMenu* FormatMenu;
	Vcl::Menus::TMenuItem* Font1;
	Vcl::Menus::TMenuItem* Paragraph1;
	Vcl::Menus::TMenuItem* abs1;
	Vcl::Comctrls::TToolButton* FormatOptionsButton;
	Vcl::Actnpopup::TPopupActionBar* PopupActionBar1;
	Vcl::Menus::TMenuItem* Font2;
	Vcl::Menus::TMenuItem* Paragraph2;
	Vcl::Menus::TMenuItem* abs2;
	Vcl::Comctrls::TToolButton* InsertObjectButton;
	Vcl::Comctrls::TToolButton* NumberingButton;
	Vcl::Wwdbcomb::TwwDBComboBox* ZoomCombo;
	Vcl::Extctrls::TBevel* RichEditBevel;
	Vcl::Comctrls::TToolButton* UserButtonSep;
	Vcl::Comctrls::TToolButton* Sep6;
	void __fastcall FontNameComboCloseUp(Vcl::Wwdbcomb::TwwDBComboBox* Sender, bool Select);
	void __fastcall FontSizeComboCloseUp(Vcl::Wwdbcomb::TwwDBComboBox* Sender, bool Select);
	void __fastcall FindButtonClick(System::TObject* Sender);
	void __fastcall CutButtonClick(System::TObject* Sender);
	void __fastcall CopyButtonClick(System::TObject* Sender);
	void __fastcall ColorButtonClick(System::TObject* Sender);
	void __fastcall CenterButtonClick(System::TObject* Sender);
	void __fastcall BulletButtonClick(System::TObject* Sender);
	void __fastcall BoldButtonMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall BoldButtonClick(System::TObject* Sender);
	void __fastcall LeftButtonClick(System::TObject* Sender);
	void __fastcall RightButtonClick(System::TObject* Sender);
	void __fastcall JustifyButtonClick(System::TObject* Sender);
	void __fastcall ItalicButtonClick(System::TObject* Sender);
	void __fastcall UnderlineButtonClick(System::TObject* Sender);
	void __fastcall RedoButtonClick(System::TObject* Sender);
	void __fastcall UndoButtonClick(System::TObject* Sender);
	void __fastcall PasteButtonClick(System::TObject* Sender);
	void __fastcall SpellButtonClick(System::TObject* Sender);
	void __fastcall PrintButtonClick(System::TObject* Sender);
	void __fastcall SaveAsButtonClick(System::TObject* Sender);
	void __fastcall LoadButtonClick(System::TObject* Sender);
	void __fastcall NewButtonClick(System::TObject* Sender);
	void __fastcall HighlightButtonClick(System::TObject* Sender);
	void __fastcall PrintPreviewButtonClick(System::TObject* Sender);
	void __fastcall RichEditBarEnter(System::TObject* Sender);
	void __fastcall Font1Click(System::TObject* Sender);
	void __fastcall Paragraph1Click(System::TObject* Sender);
	void __fastcall abs1Click(System::TObject* Sender);
	void __fastcall InsertObjectButtonClick(System::TObject* Sender);
	void __fastcall NumberingButtonMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall NumberingButtonClick(System::TObject* Sender);
	void __fastcall ZoomComboCloseUp(Vcl::Wwdbcomb::TwwDBComboBox* Sender, bool Select);
	
private:
	Vcl::Graphics::TCanvas* FCanvas;
	bool tempDown;
	Vcl::Wwriched::TwwDBRichEdit* RichEdit1;
	void __fastcall InitColorMenu(void);
	void __fastcall ColorClick(System::TObject* Sender);
	void __fastcall SetRichEditFontName(System::UnicodeString Value);
	
public:
	Vcl::Wwriched::TwwRulerPanel* wwRulerPanel;
	virtual void __fastcall ResizeBar(void);
	__fastcall virtual ~TwwRichBarFrame(void);
	void __fastcall RefreshControls(void);
	void __fastcall Initialize(void);
public:
	/* TCustomFrame.Create */ inline __fastcall virtual TwwRichBarFrame(System::Classes::TComponent* AOwner) : Vcl::Forms::TFrame(AOwner) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwRichBarFrame(HWND ParentWindow) : Vcl::Forms::TFrame(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwRichEditBar : public Vcl::Extctrls::TPanel
{
	typedef Vcl::Extctrls::TPanel inherited;
	
private:
	Vcl::Graphics::TCanvas* FCanvas;
	Vcl::Wwriched::TwwDBRichEdit* RichEdit1;
	TwwRichEditBarOptions FOptions;
	HIDESBASE MESSAGE void __fastcall WMMeasureItem(Winapi::Messages::TWMMeasureItem &Message);
	HIDESBASE MESSAGE void __fastcall WMDrawItem(Winapi::Messages::TWMDrawItem &Message);
	HIDESBASE MESSAGE void __fastcall WMCommand(Winapi::Messages::TWMCommand &Message);
	Vcl::Wwriched::TwwDBRichEdit* __fastcall GetRichEdit(void);
	void __fastcall SetOptions(TwwRichEditBarOptions val);
	void __fastcall CreateComponent(System::Classes::TReader* Reader, System::Classes::TComponentClass ComponentClass, System::Classes::TComponent* &Component);
	void __fastcall RichEditSelectionChange(System::TObject* Sender);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall ReadState(System::Classes::TReader* Reader);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	virtual void __fastcall Loaded(void);
	void __fastcall RichEditBarFrameNeeded(void);
	virtual void __fastcall ApplyIntl(void);
	
public:
	TwwRichBarFrame* RichEditBarFrame;
	__fastcall virtual TwwRichEditBar(System::Classes::TComponent* AOwner);
	virtual void __fastcall CreateWnd(void);
	__fastcall virtual ~TwwRichEditBar(void);
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	DYNAMIC void __fastcall Resize(void);
	void __fastcall UpdateControlPositions(void);
	void __fastcall InvertIcons(void);
	
__published:
	__property Vcl::Wwriched::TwwDBRichEdit* RichEdit = {read=GetRichEdit};
	__property TwwRichEditBarOptions Options = {read=FOptions, write=SetOptions, default=7167};
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwRichEditBar(HWND ParentWindow) : Vcl::Extctrls::TPanel(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwricheditbar */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWRICHEDITBAR)
using namespace Vcl::Wwricheditbar;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwricheditbarHPP
