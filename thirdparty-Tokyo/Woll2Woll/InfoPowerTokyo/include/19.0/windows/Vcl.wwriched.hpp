// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwriched.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwrichedHPP
#define Vcl_WwrichedHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Data.DB.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Winapi.RichEdit.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.DBCtrls.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.Wwcommon.hpp>
#include <Vcl.Printers.hpp>
#include <vcl.wwintl.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <vcl.Wwtrackicon.hpp>
#include <vcl.wwtypes.hpp>
#include <vcl.wwrichole.hpp>
#include <Vcl.OleCtnrs.hpp>
#include <Winapi.ActiveX.hpp>
#include <Winapi.ShellAPI.hpp>
#include <Winapi.OleDlg.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.OleConst.hpp>
#include <Vcl.Grids.hpp>
#include <vcl.wwframe.hpp>
#include <Winapi.CommCtrl.hpp>
#include <Vcl.FileCtrl.hpp>
#include <Vcl.Themes.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwriched
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwRTFHeaderFooter;
class DELPHICLASS TwwPrintMargins;
struct TwwParaFormat2;
class DELPHICLASS TwwCustomRichEdit;
class DELPHICLASS TwwRulerPanel;
class DELPHICLASS TwwDBRichEdit;
struct TwwCharFormat2;
class DELPHICLASS EwwRTFError;
class DELPHICLASS TwwRichEditStyleHook;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwRichEditWidth : unsigned char { rewWindowSize, rewPrinterSize };

typedef void __fastcall (__closure *TwwOnRichEditDlgEvent)(Vcl::Forms::TForm* Form);

typedef void __fastcall (__closure *TwwURLOpenEvent)(TwwCustomRichEdit* Sender, System::UnicodeString URLLink, bool &UseDefault);

enum DECLSPEC_DENUM TwwMeasurementUnits : unsigned char { muInches, muCentimeters };

enum DECLSPEC_DENUM TwwRichEditParaOption : unsigned char { rpoAlignment, rpoBullet, rpoLeftIndent, rpoRightIndent, rpoFirstLineIndent, rpoTabs, rpoSpaceBefore, rpoSpaceAfter, rpoLineSpacing };

enum DECLSPEC_DENUM TwwRichEditOleOption : unsigned char { reoAdjustPopupMenu, reoDisableOLE };

typedef System::Set<TwwRichEditOleOption, TwwRichEditOleOption::reoAdjustPopupMenu, TwwRichEditOleOption::reoDisableOLE> TwwRichEditOleOptions;

enum DECLSPEC_DENUM TwwRichEditCopyMethod : unsigned char { recmByMemory, recmByTempFile };

enum DECLSPEC_DENUM TwwRichEditNumberingStyle : unsigned short { renRightParens, renEncloseParens = 256, renPeriodAfter = 512, renOnlyNumber = 768, renContinueNumber = 1024, renNewNumber = 32768 };

enum DECLSPEC_DENUM TwwRichEditNumberingLetter : unsigned char { renNone, renBullet, renArabic, renLowercaseLetter, renUppercaseLetter, renLowercaseRoman, renUppercaseRoman, renCharacterSequence };

typedef System::Set<TwwRichEditParaOption, TwwRichEditParaOption::rpoAlignment, TwwRichEditParaOption::rpoLineSpacing> TwwRichEditParaOptions;

enum DECLSPEC_DENUM TwwRichEditPopupOption : unsigned char { rpoPopupEdit, rpoPopupCut, rpoPopupCopy, rpoPopupPaste, rpoPopupBold, rpoPopupItalic, rpoPopupUnderline, rpoPopupFont, rpoPopupBullet, rpoPopupParagraph, rpoPopupTabs, rpoPopupFind, rpoPopupReplace, rpoPopupInsertObject, rpoPopupMSWordSpellCheck };

typedef System::Set<TwwRichEditPopupOption, TwwRichEditPopupOption::rpoPopupEdit, TwwRichEditPopupOption::rpoPopupMSWordSpellCheck> TwwRichEditPopupOptions;

enum DECLSPEC_DENUM TwwRichEditOption : unsigned char { reoShowLoad, reoShowSaveAs, reoShowSaveExit, reoShowPrint, reoShowPrintPreview, reoShowPageSetup, reoShowFormatBar, reoShowToolBar, reoShowStatusBar, reoShowHints, reoShowRuler, reoShowInsertObject, reoCloseOnEscape, reoFlatButtons, reoShowSpellCheck, reoShowMainMenuIcons, reoShowJustifyButton, reoUseBackColor, reoNoConfirmation, reoShowZoomCombo, reoShowHorzScroll };

typedef System::Set<TwwRichEditOption, TwwRichEditOption::reoShowLoad, TwwRichEditOption::reoShowHorzScroll> TwwRichEditOptions;

enum DECLSPEC_DENUM TwwRichSelection : unsigned char { wwstText, wwstObject, wwstMultiChar, wwstMultiObject };

typedef System::Set<TwwRichSelection, TwwRichSelection::wwstText, TwwRichSelection::wwstMultiObject> TwwRichSelectionType;

typedef void __fastcall (__closure *TwwRTFDrawHeaderFooter)(TwwCustomRichEdit* Sender, const System::Types::TRect &DrawRect, int PageNumber, System::UnicodeString &LeftText, System::UnicodeString &CenterText, System::UnicodeString &RightText, bool &DoDefault);

class PASCALIMPLEMENTATION TwwRTFHeaderFooter : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	double FVertMargin;
	System::UnicodeString FLeftText;
	System::UnicodeString FCenterText;
	System::UnicodeString FRightText;
	Vcl::Graphics::TFont* FFont;
	bool FLineSeparator;
	void __fastcall SetFont(Vcl::Graphics::TFont* Value);
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual TwwRTFHeaderFooter(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwRTFHeaderFooter(void);
	
__published:
	__property double VertMargin = {read=FVertMargin, write=FVertMargin};
	__property System::UnicodeString LeftText = {read=FLeftText, write=FLeftText};
	__property System::UnicodeString CenterText = {read=FCenterText, write=FCenterText};
	__property System::UnicodeString RightText = {read=FRightText, write=FRightText};
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=SetFont};
	__property bool LineSeparator = {read=FLineSeparator, write=FLineSeparator, default=0};
};


class PASCALIMPLEMENTATION TwwPrintMargins : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	double FTop;
	double FBottom;
	double FLeft;
	double FRight;
	
public:
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__fastcall virtual TwwPrintMargins(System::Classes::TComponent* AOwner);
	
__published:
	__property double Top = {read=FTop, write=FTop};
	__property double Bottom = {read=FBottom, write=FBottom};
	__property double Left = {read=FLeft, write=FLeft};
	__property double Right = {read=FRight, write=FRight};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwPrintMargins(void) { }
	
};


struct DECLSPEC_DRECORD TwwParaFormat2
{
public:
	unsigned cbSize;
	unsigned dwMask;
	System::Word wNumbering;
	System::Word wReserved;
	int dxStartIndent;
	int dxRightIndent;
	int dxOffset;
	System::Word wAlignment;
	short cTabCount;
	System::StaticArray<int, 32> rgxTabs;
	int dySpaceBefore;
	int dySpaceAfter;
	int dyLineSpacing;
	short sStyle;
	System::Byte bLineSpacingRule;
	System::Byte bCRC;
	System::Word wShadingWeight;
	System::Word wShadingStyle;
	System::Word wNumberingStart;
	System::Word wNumberingStyle;
	System::Word wNumberingTab;
	System::Word wBorderSpace;
	System::Word wBorderWidth;
	System::Word wBorders;
};


typedef void __fastcall (__closure *TwwRTFNotifyEvent)(Vcl::Forms::TForm* Form, TwwCustomRichEdit* RichEdit, bool &DoDefault);

enum DECLSPEC_DENUM TwwRTFSaveFormat : unsigned char { wwrsfRTF, wwrsfPlainText, wwrsfPlainTextUnicode };

class PASCALIMPLEMENTATION TwwCustomRichEdit : public Vcl::Comctrls::TCustomRichEdit
{
	typedef Vcl::Comctrls::TCustomRichEdit inherited;
	
private:
	bool FAutoURLDetect;
	bool FAutoSelect;
	TwwURLOpenEvent FOnURLOpen;
	NativeUInt FLibHandle;
	bool FWordWrap;
	TwwPrintMargins* FPrintMargins;
	TwwRTFHeaderFooter* FHeader;
	TwwRTFHeaderFooter* FFooter;
	TwwRTFDrawHeaderFooter FOnPrintHeader;
	TwwRTFDrawHeaderFooter FOnPrintFooter;
	int FPrintPageSize;
	TwwRichEditWidth FEditWidth;
	int StartingFindPos;
	bool InResetToStart;
	Vcl::Menus::TMenuItem* PopupEdit;
	Vcl::Menus::TMenuItem* PopupCut;
	Vcl::Menus::TMenuItem* PopupCopy;
	Vcl::Menus::TMenuItem* PopupPaste;
	Vcl::Menus::TMenuItem* PopupBold;
	Vcl::Menus::TMenuItem* PopupItalic;
	Vcl::Menus::TMenuItem* PopupUnderline;
	Vcl::Menus::TMenuItem* PopupFont;
	Vcl::Menus::TMenuItem* PopupBullet;
	Vcl::Menus::TMenuItem* PopupParagraph;
	Vcl::Menus::TMenuItem* PopupTabs;
	Vcl::Menus::TMenuItem* PopupFind;
	Vcl::Menus::TMenuItem* PopupReplace;
	Vcl::Menus::TMenuItem* PopupInsertObject;
	Vcl::Menus::TMenuItem* PopupSpellCheck;
	Vcl::Menus::TMenuItem* PopupSep1;
	Vcl::Menus::TMenuItem* PopupSep2;
	Vcl::Menus::TMenuItem* PopupSep3;
	Vcl::Menus::TMenuItem* PopupSep4;
	Vcl::Menus::TMenuItem* PopupSep5;
	TwwRichEditPopupOptions FPopupOptions;
	TwwRichEditOptions FEditorOptions;
	System::UnicodeString FEditorCaption;
	Vcl::Wwtypes::TwwFormPosition* FEditorPosition;
	System::UnicodeString LastSearchText;
	TwwMeasurementUnits FUnits;
	TwwOnRichEditDlgEvent FOnInitDialog;
	TwwOnRichEditDlgEvent FOnCloseDialog;
	TwwOnRichEditDlgEvent FOnCreateDialog;
	TwwRTFNotifyEvent FOnMenuLoadClick;
	TwwRTFNotifyEvent FOnMenuPrintClick;
	TwwRTFNotifyEvent FOnMenuSaveAsClick;
	TwwRTFNotifyEvent FOnMenuSaveAndExitClick;
	System::Classes::TNotifyEvent FOnSpellCheck;
	bool OrigHideSelection;
	TwwRichEditOleOptions FOLEOptions;
	_di_IOleObject FOleSelObject;
	TwwRichEditCopyMethod FRichEditCopyMethod;
	Vcl::Buttons::TSpeedButton* FUserSpeedButton1;
	Vcl::Buttons::TSpeedButton* FUserSpeedButton2;
	System::UnicodeString FPrintJobName;
	System::UnicodeString FPrintPreviewCaption;
	System::Uitypes::TColor FHighlightColor;
	Vcl::Wwframe::TwwEditFrame* FFrame;
	bool FWantNavigationKeys;
	Vcl::Controls::TControlCanvas* FCanvas;
	Vcl::Controls::TWinControl* FPaintControl;
	Vcl::Wwrichole::_di_IRichEditOle FRichEditOle;
	Vcl::Wwrichole::_di_IRichEditOleCallback FRichEditOleCallback;
	System::Classes::TStringList* FObjectVerbs;
	System::Classes::TList* OleMenuItemList;
	bool InParentChanging;
	System::Classes::TStream* ReloadStream;
	bool UseReloadStream;
	bool NewDataFormat;
	bool URLDetectButtonPressed;
	Vcl::Menus::TPopupMenu* FVerbMenu;
	bool InitEditRect;
	int FRichEditVersion;
	System::Classes::TStrings* FLines;
	System::UnicodeString FTitle;
	bool InMouseUp;
	bool SkipChange;
	int FGutterWidth;
	int OldLineCount;
	int OldCharPos;
	int OrigWin32MajorVersion;
	int FMSVersion;
	bool FHideSelection;
	System::Classes::TThread* MSWordThread;
	int FBulletIndent;
	TwwRichEditNumberingStyle FNumberingStyle;
	double FZoomMultiplier;
	int FRightMargin;
	System::Classes::TNotifyEvent FOnHorzScroll;
	TwwRTFSaveFormat FSaveFormat;
	
private:
	// __classmethod void __fastcall Create@();
	
private:
	void __fastcall SetSaveFormat(TwwRTFSaveFormat value);
	HIDESBASE void __fastcall SetHideSelection(bool Value);
	void __fastcall FindDialog1Close(System::TObject* Sender);
	void __fastcall FindDialog1Find(System::TObject* Sender);
	void __fastcall FindReplaceDlg(Vcl::Dialogs::TFindDialog* dialog, bool replace, System::UnicodeString replaceStr);
	void __fastcall ReplaceDialog1Replace(System::TObject* Sender);
	void __fastcall PopupMenuPopup(System::TObject* Sender);
	void __fastcall PopupEditclick(System::TObject* Sender);
	void __fastcall PopupCutClick(System::TObject* Sender);
	void __fastcall PopupCopyClick(System::TObject* Sender);
	void __fastcall PopupPasteClick(System::TObject* Sender);
	void __fastcall PopupFontClick(System::TObject* Sender);
	void __fastcall PopupParagraphClick(System::TObject* Sender);
	void __fastcall PopupTabsClick(System::TObject* Sender);
	void __fastcall PopupBulletClick(System::TObject* Sender);
	void __fastcall PopupBoldClick(System::TObject* Sender);
	void __fastcall PopupItalicClick(System::TObject* Sender);
	void __fastcall PopupUnderlineClick(System::TObject* Sender);
	void __fastcall PopupFindClick(System::TObject* Sender);
	void __fastcall PopupReplaceClick(System::TObject* Sender);
	void __fastcall PopupInsertObjectClick(System::TObject* Sender);
	void __fastcall PopupSpellCheckClick(System::TObject* Sender);
	HIDESBASE void __fastcall SetWordWrap(bool val);
	void __fastcall SetPrintPageSize(int val);
	int __fastcall TwipsToPixels(int twips);
	int __fastcall PixelsToTwips(int pixels);
	HIDESBASE MESSAGE void __fastcall WMNCDestroy(Winapi::Messages::TMessage &Msg);
	void __fastcall SetOleOptions(TwwRichEditOleOptions val);
	void __fastcall ReadData(System::Classes::TStream* Stream);
	void __fastcall WriteData(System::Classes::TStream* Stream);
	void __fastcall ReadVersion(System::Classes::TReader* Reader);
	void __fastcall WriteVersion(System::Classes::TWriter* Writer);
	HIDESBASE MESSAGE void __fastcall WMNotify(Winapi::Messages::TWMNotify &Message);
	void __fastcall URLLinkNotification(void * Link);
	void __fastcall SetAutoURLDetect(bool val);
	void __fastcall SetUserSpeedButton1(Vcl::Buttons::TSpeedButton* val);
	void __fastcall SetUserSpeedButton2(Vcl::Buttons::TSpeedButton* val);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE void __fastcall SetLines(System::Classes::TStrings* val);
	HIDESBASE MESSAGE void __fastcall CNKeyDown(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Message);
	HIDESBASE MESSAGE void __fastcall WMRButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMHScroll(Winapi::Messages::TWMScroll &Msg);
	TwwRichSelectionType __fastcall GetSelectionType(void);
	HIDESBASE MESSAGE void __fastcall CMShowingChanged(Winapi::Messages::TMessage &Message);
	void __fastcall SetTitle(const System::UnicodeString Value);
	HIDESBASE void __fastcall SetScrollBars(System::Uitypes::TScrollStyle Value);
	System::Uitypes::TScrollStyle __fastcall GetScrollBars(void);
	double __fastcall GetZoomFactor(void);
	void __fastcall SetZoomFactor(double value);
	void __fastcall SendZoomFactor(double zoom);
	int __fastcall ZoomPixelsPerInch(void);
	int __fastcall GetSelectionHangingIndent(void);
	void __fastcall SetSelectionHangingIndent(int value);
	int __fastcall GetSelectionIndent(void);
	void __fastcall SetSelectionIndent(int value);
	int __fastcall GetSelectionRightIndent(void);
	void __fastcall SetSelectionRightIndent(int value);
	int __fastcall GetRightMargin(void);
	void __fastcall SetRightMargin(int value);
	
protected:
	bool BoundMode;
	int ScreenPixelsPerInch;
	bool FFocused;
	bool __fastcall StoreScrollBars(void);
	DYNAMIC void __fastcall DblClick(void);
	virtual void __fastcall ClearSelectedBackgroundColor(void);
	virtual void __fastcall WriteState(System::Classes::TWriter* Writer);
	virtual void __fastcall ReadState(System::Classes::TReader* Reader);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	MESSAGE void __fastcall EMFormatRange(Winapi::Messages::TMessage &msg);
	DYNAMIC void __fastcall SelectionChange(void);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &msg);
	HIDESBASE virtual bool __fastcall GetReadOnly(void);
	virtual void __fastcall BeginEditing(void);
	virtual void __fastcall UpdateField(void);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall DestroyWnd(void);
	DYNAMIC Vcl::Menus::TPopupMenu* __fastcall GetPopupMenu(void);
	void __fastcall DestroyVerbs(void);
	void __fastcall UpdateVerbs(void);
	void __fastcall PopupVerbMenuClick(System::TObject* Sender);
	void __fastcall ObjectPropertiesMenuClick(System::TObject* Sender);
	virtual bool __fastcall IsMemoLoaded(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual Data::Db::TField* __fastcall GetField(void);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall DoURLOpen(System::UnicodeString URLLink, bool &UseDefault);
	virtual void __fastcall LoadPacketsFromStream(System::Classes::TStream* Stream, bool AppendMode, int NumPackets = 0x0);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	virtual bool __fastcall isTransparentEffective(void);
	virtual void __fastcall LoadMemo(void);
	virtual void __fastcall CreatePopup(void);
	virtual void __fastcall CreateRuntimeComponents(void);
	virtual System::UnicodeString __fastcall GetSelText(void);
	HIDESBASE virtual void __fastcall SetSelText(System::UnicodeString value);
	void __fastcall SetNumbering(TwwRichEditNumberingLetter val);
	TwwRichEditNumberingLetter __fastcall GetNumbering(void);
	void __fastcall SetBulletIndent(int val);
	int __fastcall GetBulletIndent(void);
	void __fastcall SetNumberingStyle(TwwRichEditNumberingStyle val);
	TwwRichEditNumberingStyle __fastcall GetNumberingStyle(void);
	bool __fastcall StoreZoomFactor(void);
	
public:
	TwwCustomRichEdit* DialogRichEdit;
	Vcl::Forms::TForm* RichEditForm;
	Vcl::Dialogs::TFindDialog* FindDialog1;
	Vcl::Dialogs::TReplaceDialog* ReplaceDialog1;
	Vcl::Dialogs::TFontDialog* FontDialog1;
	System::UnicodeString FirstLineText;
	bool SkipPaint;
	bool SkipErase;
	System::Variant Patch;
	Vcl::Menus::TPopupMenu* DefaultPopupMenu;
	bool BeforePopup;
	System::Uitypes::TColor LastColor;
	int ClickTime;
	int TotalPages;
	HIDESBASE int __fastcall FindText(const System::UnicodeString SearchStr, int StartPos, int Length, Vcl::Comctrls::TSearchTypes Options);
	virtual int __fastcall FindTextAfter(const System::UnicodeString SearchStr, int StartPos, int Length, Vcl::Comctrls::TSearchTypes Options);
	TwwRichEditWidth __fastcall EffectiveEditWidth(void);
	void __fastcall SetTextBackgroundColor(System::Uitypes::TColor BackColor);
	System::Uitypes::TColor __fastcall GetTextBackgroundColor(void);
	virtual int __fastcall FindTextBefore(const System::UnicodeString SearchStr, int StartPos, int Length, Vcl::Comctrls::TSearchTypes Options);
	virtual bool __fastcall InsertObjectDialog(void);
	virtual bool __fastcall ObjectPropertiesDialog(void);
	void __fastcall DoVerb(int Verb);
	__fastcall virtual TwwCustomRichEdit(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwCustomRichEdit(void);
	virtual bool __fastcall Execute(void);
	virtual void __fastcall ExecuteFindDialog(void);
	virtual void __fastcall ExecuteReplaceDialog(void);
	virtual void __fastcall ExecuteFontDialog(void);
	virtual bool __fastcall ExecuteParagraphDialog(void);
	virtual void __fastcall ExecuteTabDialog(void);
	virtual void __fastcall FindNextMatch(void);
	virtual void __fastcall FindReplace(void);
	virtual bool __fastcall FindReplaceText(System::UnicodeString SearchText, System::UnicodeString ReplaceText, Vcl::Comctrls::TSearchTypes SearchTypes);
	void __fastcall SetBullet(bool val);
	void __fastcall SetBold(bool val);
	void __fastcall SetItalic(bool val);
	void __fastcall SetUnderline(bool val);
	HIDESBASE void __fastcall Undo(void);
	void __fastcall Redo(void);
	bool __fastcall CanPaste(void);
	HIDESBASE bool __fastcall CanUndo(void);
	bool __fastcall CanRedo(void);
	bool __fastcall CanCut(void);
	bool __fastcall CanFindNext(void);
	void __fastcall InsertBitmap(Vcl::Graphics::TBitmap* Pict);
	void __fastcall CopyRichEditFromBlob(Data::Db::TField* Field);
	void __fastcall CopyRichEdittoBlob(Data::Db::TField* Field);
	void __fastcall CopyRichEditTo(Vcl::Comctrls::TCustomRichEdit* val);
	void __fastcall AppendRichEditFrom(Vcl::Comctrls::TCustomRichEdit* val);
	void __fastcall SetRichEditFontAttributes(System::UnicodeString FontName, int FontSize, System::Uitypes::TFontStyles FontStyle, System::Uitypes::TColor FontColor);
	void __fastcall SetStyleAttribute(System::Uitypes::TFontStyle Attr, bool AttrOn);
	int __fastcall GetCharSetOfFontName(const System::UnicodeString FaceName);
	void __fastcall GetParaIndent(int &LeftIndent, int &RightIndent, int &FirstIndent);
	void __fastcall SetParaFormat(TwwRichEditParaOptions Options, System::UnicodeString alignment, bool bulletStyle, int leftindent, int rightindent, int firstlineindent, int tabCount, void * tabArray, int SpaceBefore, int SpaceAfter, int LineSpacing, int LineSpacingRule);
	System::UnicodeString __fastcall GetRTFText(void);
	void __fastcall SetRtfText(System::UnicodeString InsertText);
	System::Types::TRect __fastcall GetPrinterRect(void);
	void __fastcall GetParaFormat(TwwParaFormat2 &Format);
	int __fastcall UnitStrToTwips(System::UnicodeString str);
	int __fastcall UnitsToTwips(double val);
	System::UnicodeString __fastcall FormatUnitStr(double val);
	System::UnicodeString __fastcall RoundedFormatUnitStr(double units, int intervals);
	double __fastcall TwipsToUnits(int val);
	virtual void __fastcall DoInitDialog(Vcl::Forms::TForm* Form);
	virtual void __fastcall DoCloseDialog(Vcl::Forms::TForm* Form);
	virtual void __fastcall DoCreateDialog(Vcl::Forms::TForm* Form);
	void __fastcall SetEditRect(void);
	virtual void __fastcall Print(const System::UnicodeString Caption);
	void __fastcall UpdatePrinter(void);
	System::Classes::TStrings* __fastcall ILines(void);
	virtual bool __fastcall MSWordSpellChecker(void);
	virtual bool __fastcall MSWordPrintDocument(System::UnicodeString TemplateFileName);
	void __fastcall GetRTFSelection(System::Classes::TStream* DestStream);
	void __fastcall PutRTFSelection(System::Classes::TStream* SourceStream);
	void __fastcall Import(System::UnicodeString Format, System::UnicodeString FileName);
	void __fastcall Export(System::UnicodeString Format, System::UnicodeString FileName);
	void __fastcall PrintPreview(void);
	virtual void __fastcall DoPrintHeader(const System::Types::TRect &DrawRect, int PageNumber, System::UnicodeString &LeftText, System::UnicodeString &CenterText, System::UnicodeString &RightText, bool &DoDefault);
	virtual void __fastcall DoPrintFooter(const System::Types::TRect &DrawRect, int PageNumber, System::UnicodeString &LeftText, System::UnicodeString &CenterText, System::UnicodeString &RightText, bool &DoDefault);
	void __fastcall StartMSWordMonitoring(System::UnicodeString TempFileName);
	void __fastcall StopMSWordMonitoring(void);
	__property Data::Db::TField* Field = {read=GetField};
	__property _di_IOleObject OleSelObject = {read=FOleSelObject};
	__property Vcl::Wwrichole::_di_IRichEditOle RichEditOle = {read=FRichEditOle};
	__property Vcl::Wwrichole::_di_IRichEditOleCallback RichEditOleCallback = {read=FRichEditOleCallback};
	__property TwwRichEditPopupOptions PopupOptions = {read=FPopupOptions, write=FPopupOptions, default=32655};
	__property TwwRichEditOptions EditorOptions = {read=FEditorOptions, write=FEditorOptions, default=1638396};
	__property int RichEditVersion = {read=FRichEditVersion, write=FRichEditVersion, nodefault};
	__property System::Uitypes::TColor HighlightColor = {read=FHighlightColor, write=FHighlightColor, default=65535};
	__property System::UnicodeString EditorCaption = {read=FEditorCaption, write=FEditorCaption};
	__property TwwMeasurementUnits MeasurementUnits = {read=FUnits, write=FUnits, nodefault};
	__property TwwOnRichEditDlgEvent OnInitDialog = {read=FOnInitDialog, write=FOnInitDialog};
	__property TwwOnRichEditDlgEvent OnCloseDialog = {read=FOnCloseDialog, write=FOnCloseDialog};
	__property TwwOnRichEditDlgEvent OnCreateDialog = {read=FOnCreateDialog, write=FOnCreateDialog};
	__property TwwPrintMargins* PrintMargins = {read=FPrintMargins, write=FPrintMargins};
	__property TwwRTFHeaderFooter* PrintHeader = {read=FHeader, write=FHeader};
	__property TwwRTFHeaderFooter* PrintFooter = {read=FFooter, write=FFooter};
	__property TwwRTFDrawHeaderFooter OnPrintHeader = {read=FOnPrintHeader, write=FOnPrintHeader};
	__property TwwRTFDrawHeaderFooter OnPrintFooter = {read=FOnPrintFooter, write=FOnPrintFooter};
	__property TwwRichEditWidth EditWidth = {read=FEditWidth, write=FEditWidth, default=0};
	__property Vcl::Wwtypes::TwwFormPosition* EditorPosition = {read=FEditorPosition, write=FEditorPosition};
	__property int PrintPageSize = {read=FPrintPageSize, write=SetPrintPageSize, default=1};
	__property TwwRichEditOleOptions OleOptions = {read=FOLEOptions, write=SetOleOptions, default=1};
	__property TwwRichEditCopyMethod RichEditCopyMethod = {read=FRichEditCopyMethod, write=FRichEditCopyMethod, default=0};
	__property bool AutoURLDetect = {read=FAutoURLDetect, write=SetAutoURLDetect, nodefault};
	__property bool AutoSelect = {read=FAutoSelect, write=FAutoSelect, default=0};
	__property TwwURLOpenEvent OnURLOpen = {read=FOnURLOpen, write=FOnURLOpen};
	__property Vcl::Buttons::TSpeedButton* UserSpeedButton1 = {read=FUserSpeedButton1, write=SetUserSpeedButton1};
	__property Vcl::Buttons::TSpeedButton* UserSpeedButton2 = {read=FUserSpeedButton2, write=SetUserSpeedButton2};
	__property bool WordWrap = {read=FWordWrap, write=SetWordWrap, default=1};
	__property PlainText = {default=0};
	__property Vcl::Wwframe::TwwEditFrame* Frame = {read=FFrame, write=FFrame};
	__property System::UnicodeString PrintJobName = {read=FPrintJobName, write=FPrintJobName};
	__property System::UnicodeString PrintPreviewCaption = {read=FPrintPreviewCaption, write=FPrintPreviewCaption};
	__property int GutterWidth = {read=FGutterWidth, write=FGutterWidth, nodefault};
	__property TwwRichSelectionType SelectionType = {read=GetSelectionType, nodefault};
	__property bool WantNavigationKeys = {read=FWantNavigationKeys, write=FWantNavigationKeys, default=0};
	__property System::UnicodeString Title = {read=FTitle, write=SetTitle};
	__property bool HideSelection = {read=FHideSelection, write=SetHideSelection, default=1};
	__property TwwRTFNotifyEvent OnMenuLoadClick = {read=FOnMenuLoadClick, write=FOnMenuLoadClick};
	__property TwwRTFNotifyEvent OnMenuPrintClick = {read=FOnMenuPrintClick, write=FOnMenuPrintClick};
	__property TwwRTFNotifyEvent OnMenuSaveAsClick = {read=FOnMenuSaveAsClick, write=FOnMenuSaveAsClick};
	__property TwwRTFNotifyEvent OnMenuSaveAndExitClick = {read=FOnMenuSaveAndExitClick, write=FOnMenuSaveAndExitClick};
	__property System::Classes::TNotifyEvent OnSpellCheck = {read=FOnSpellCheck, write=FOnSpellCheck};
	__property System::Classes::TNotifyEvent OnHorzScroll = {read=FOnHorzScroll, write=FOnHorzScroll};
	__property System::UnicodeString SelText = {read=GetSelText, write=SetSelText};
	__property TwwRichEditNumberingLetter Numbering = {read=GetNumbering, write=SetNumbering, nodefault};
	__property int BulletIndent = {read=GetBulletIndent, write=SetBulletIndent, default=0};
	__property TwwRichEditNumberingStyle NumberingStyle = {read=GetNumberingStyle, write=SetNumberingStyle, default=512};
	__property double ZoomFactor = {read=GetZoomFactor, write=SetZoomFactor, stored=StoreZoomFactor};
	__property int SelectionHangingIndent = {read=GetSelectionHangingIndent, write=SetSelectionHangingIndent, nodefault};
	__property int SelectionIndent = {read=GetSelectionIndent, write=SetSelectionIndent, nodefault};
	__property int SelectionRightIndent = {read=GetSelectionRightIndent, write=SetSelectionRightIndent, nodefault};
	__property int RightMargin = {read=GetRightMargin, write=SetRightMargin, nodefault};
	
__published:
	__property System::Uitypes::TScrollStyle ScrollBars = {read=GetScrollBars, write=SetScrollBars, stored=StoreScrollBars, nodefault};
	__property int MSVersion = {read=FMSVersion, write=FMSVersion, default=3};
	__property TwwRTFSaveFormat SaveFormat = {read=FSaveFormat, write=SetSaveFormat, default=0};
	__property System::Classes::TStrings* Lines = {read=FLines, write=SetLines, stored=false};
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwCustomRichEdit(HWND ParentWindow) : Vcl::Comctrls::TCustomRichEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwRulerPanel : public Vcl::Extctrls::TPanel
{
	typedef Vcl::Extctrls::TPanel inherited;
	
private:
	int __fastcall PrinterPixelsToTwipsX(int pixels);
	int __fastcall PixelsToTwipsX(int pixels);
	
protected:
	virtual void __fastcall Paint(void);
	virtual void __fastcall AdjustClientRect(System::Types::TRect &Rect);
	
public:
	System::Types::TRect RulerRect;
	Vcl::Wwtrackicon::TwwTrackIcon* LeftDragButton;
	Vcl::Wwtrackicon::TwwTrackIcon* RightDragButton;
	Vcl::Wwtrackicon::TwwTrackIcon* FirstLineDragButton;
	TwwDBRichEdit* RichEdit;
	void __fastcall UpdateDragIcons(void);
	void __fastcall UpdateSize(TwwCustomRichEdit* DialogRichEdit);
	void __fastcall UpdateRulerProp(System::TObject* Sender);
	void __fastcall CreateDragButtons(void);
public:
	/* TCustomPanel.Create */ inline __fastcall virtual TwwRulerPanel(System::Classes::TComponent* AOwner) : Vcl::Extctrls::TPanel(AOwner) { }
	
public:
	/* TCustomControl.Destroy */ inline __fastcall virtual ~TwwRulerPanel(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwRulerPanel(HWND ParentWindow) : Vcl::Extctrls::TPanel(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwDBRichEdit : public TwwCustomRichEdit
{
	typedef TwwCustomRichEdit inherited;
	
private:
	// __classmethod void __fastcall Create@();
	
private:
	Vcl::Wwintl::TwwController* FController;
	Vcl::Dbctrls::TFieldDataLink* FDataLink;
	bool FAutoDisplay;
	bool FMemoLoaded;
	System::UnicodeString FDataSave;
	void __fastcall SetController(Vcl::Wwintl::TwwController* Value);
	bool __fastcall isBlob(void);
	void __fastcall DataChange(System::TObject* Sender);
	void __fastcall EditingChange(System::TObject* Sender);
	System::UnicodeString __fastcall GetDataField(void);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	void __fastcall SetDataField(const System::UnicodeString Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	HIDESBASE void __fastcall SetReadOnly(bool Value);
	void __fastcall SetAutoDisplay(bool Value);
	void __fastcall SetFocused(bool Value);
	void __fastcall UpdateData(System::TObject* Sender);
	MESSAGE void __fastcall WMCut(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMPaste(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Message);
	MESSAGE void __fastcall CMGetDataLink(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	
protected:
	virtual void __fastcall BeginEditing(void);
	DYNAMIC void __fastcall Change(void);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual bool __fastcall GetReadOnly(void);
	virtual void __fastcall UpdateField(void);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	virtual void __fastcall CreateWnd(void);
	virtual bool __fastcall IsMemoLoaded(void);
	virtual Data::Db::TField* __fastcall GetField(void);
	
public:
	__fastcall virtual TwwDBRichEdit(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDBRichEdit(void);
	virtual void __fastcall LoadMemo(void);
	void __fastcall LoadBlobStart(Data::Db::TField* Field, int NumPackets = 0x2);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	
__published:
	__property Vcl::Wwintl::TwwController* Controller = {read=FController, write=SetController};
	__property Anchors = {default=3};
	__property Constraints;
	__property BevelEdges = {default=15};
	__property BevelInner = {index=0, default=2};
	__property BevelKind = {default=0};
	__property BevelOuter = {index=1, default=1};
	__property Align = {default=0};
	__property Alignment = {default=0};
	__property AutoURLDetect;
	__property AutoSelect = {default=0};
	__property bool AutoDisplay = {read=FAutoDisplay, write=SetAutoDisplay, default=1};
	__property BorderStyle = {default=1};
	__property BorderWidth = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property Frame;
	__property GutterWidth;
	__property HideSelection = {default=1};
	__property HideScrollBars = {default=1};
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property MaxLength = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property OleOptions = {default=1};
	__property PrintPageSize = {default=1};
	__property UserSpeedButton1;
	__property UserSpeedButton2;
	__property HighlightColor = {default=65535};
	__property Title = {default=0};
	__property PopupMenu;
	__property PrintJobName = {default=0};
	__property PrintPreviewCaption = {default=0};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Touch;
	__property Visible = {default=1};
	__property WantReturns = {default=1};
	__property WantTabs = {default=0};
	__property WantNavigationKeys = {default=0};
	__property WordWrap = {default=1};
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnResizeRequest;
	__property OnSelectionChange;
	__property OnProtectChange;
	__property OnSaveClipboard;
	__property OnStartDrag;
	__property PopupOptions = {default=32655};
	__property EditorOptions = {default=1638396};
	__property EditorCaption = {default=0};
	__property EditorPosition;
	__property MeasurementUnits;
	__property PrintMargins;
	__property EditWidth = {default=0};
	__property ZoomFactor = {default=0};
	__property OnInitDialog;
	__property OnCloseDialog;
	__property OnCreateDialog;
	__property OnURLOpen;
	__property OnMenuLoadClick;
	__property OnMenuPrintClick;
	__property OnMenuSaveAsClick;
	__property OnMenuSaveAndExitClick;
	__property OnSpellCheck;
	__property PrintHeader;
	__property PrintFooter;
	__property OnPrintHeader;
	__property OnPrintFooter;
	__property OnGesture;
	__property StyleElements = {default=7};
	__property OEMConvert = {default=0};
	__property DoubleBuffered;
	__property ParentDoubleBuffered = {default=1};
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBRichEdit(HWND ParentWindow) : TwwCustomRichEdit(ParentWindow) { }
	
};


struct DECLSPEC_DRECORD TwwCharFormat2
{
public:
	unsigned cbSize;
	int dwMask;
	int dwEffects;
	int yHeight;
	int yOffset;
	unsigned crTextColor;
	System::Byte bCharSet;
	System::Byte bPitchAndFamily;
	System::StaticArray<System::WideChar, 32> szFaceName;
	System::Word wWeight;
	short sSpacing;
	unsigned crBackColor;
	int lcid;
	int dwReserved;
	short style;
	System::Word wKerning;
	System::Byte bUnderlineType;
	System::Byte bAnimation;
	System::Byte bRevAuthor;
	System::Byte bReserved1;
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION EwwRTFError : public System::Sysutils::Exception
{
	typedef System::Sysutils::Exception inherited;
	
private:
	int FErrorCode;
	
public:
	__fastcall EwwRTFError(System::UnicodeString Message, int ErrCode, int Dummy);
	__property int ErrorCode = {read=FErrorCode, nodefault};
public:
	/* Exception.CreateFmt */ inline __fastcall EwwRTFError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High) : System::Sysutils::Exception(Msg, Args, Args_High) { }
	/* Exception.CreateRes */ inline __fastcall EwwRTFError(NativeUInt Ident)/* overload */ : System::Sysutils::Exception(Ident) { }
	/* Exception.CreateRes */ inline __fastcall EwwRTFError(System::PResStringRec ResStringRec)/* overload */ : System::Sysutils::Exception(ResStringRec) { }
	/* Exception.CreateResFmt */ inline __fastcall EwwRTFError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High) { }
	/* Exception.CreateResFmt */ inline __fastcall EwwRTFError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High) { }
	/* Exception.CreateHelp */ inline __fastcall EwwRTFError(const System::UnicodeString Msg, int AHelpContext) : System::Sysutils::Exception(Msg, AHelpContext) { }
	/* Exception.CreateFmtHelp */ inline __fastcall EwwRTFError(const System::UnicodeString Msg, const System::TVarRec *Args, const int Args_High, int AHelpContext) : System::Sysutils::Exception(Msg, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EwwRTFError(NativeUInt Ident, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, AHelpContext) { }
	/* Exception.CreateResHelp */ inline __fastcall EwwRTFError(System::PResStringRec ResStringRec, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EwwRTFError(System::PResStringRec ResStringRec, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(ResStringRec, Args, Args_High, AHelpContext) { }
	/* Exception.CreateResFmtHelp */ inline __fastcall EwwRTFError(NativeUInt Ident, const System::TVarRec *Args, const int Args_High, int AHelpContext)/* overload */ : System::Sysutils::Exception(Ident, Args, Args_High, AHelpContext) { }
	/* Exception.Destroy */ inline __fastcall virtual ~EwwRTFError(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwRichEditStyleHook : public Vcl::Comctrls::TRichEditStyleHook
{
	typedef Vcl::Comctrls::TRichEditStyleHook inherited;
	
private:
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall EMSetBkgndColor(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall EMSetCharFormat(Winapi::Messages::TMessage &Message);
	
private:
	Vcl::Controls::TWinControl* Control;
	
protected:
	virtual void __fastcall PaintNC(Vcl::Graphics::TCanvas* Canvas);
	
public:
	__fastcall virtual TwwRichEditStyleHook(Vcl::Controls::TWinControl* AControl);
public:
	/* TScrollingStyleHook.Destroy */ inline __fastcall virtual ~TwwRichEditStyleHook(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Word wwTwipsPerInch = System::Word(0x5a0);
static const System::Int8 PFA_FULLJUSTIFY = System::Int8(0x4);
extern DELPHI_PACKAGE bool __fastcall wwGetUniqueFileName(System::UnicodeString &Filename);
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwriched */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWRICHED)
using namespace Vcl::Wwriched;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwrichedHPP
