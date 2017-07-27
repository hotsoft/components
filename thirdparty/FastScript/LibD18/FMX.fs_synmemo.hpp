// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'FMX.fs_synmemo.pas' rev: 25.00 (Windows)

#ifndef Fmx_Fs_synmemoHPP
#define Fmx_Fs_synmemoHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <System.Variants.hpp>	// Pascal unit
#include <System.UIConsts.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <System.UITypes.hpp>	// Pascal unit
#include <System.Types.hpp>	// Pascal unit
#include <FMX.Controls.hpp>	// Pascal unit
#include <FMX.Forms.hpp>	// Pascal unit
#include <FMX.Menus.hpp>	// Pascal unit
#include <FMX.Types.hpp>	// Pascal unit
#include <FMX.Edit.hpp>	// Pascal unit
#include <FMX.Platform.hpp>	// Pascal unit
#include <FMX.TreeView.hpp>	// Pascal unit
#include <FMX.Layouts.hpp>	// Pascal unit
#include <FMX.StdCtrls.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fmx
{
namespace Fs_synmemo
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TSyntaxType : unsigned char { stPascal, stCpp, stJs, stVB, stSQL, stText };

enum DECLSPEC_DENUM TCharAttr : unsigned char { caNo, caText, caBlock, caComment, caKeyword, caString };

typedef System::Set<TCharAttr, TCharAttr::caNo, TCharAttr::caString>  TCharAttributes;

class DELPHICLASS TfsBorderSettings;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsBorderSettings : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	Fmx::Types::TBrush* FFill;
	int FWidth;
	void __fastcall SetFill(Fmx::Types::TBrush* const Value);
	void __fastcall SetWidth(const int Value);
	
public:
	__fastcall TfsBorderSettings(void);
	__fastcall virtual ~TfsBorderSettings(void);
	
__published:
	__property Fmx::Types::TBrush* Fill = {read=FFill, write=SetFill};
	__property int Width = {read=FWidth, write=SetWidth, nodefault};
};

#pragma pack(pop)

class DELPHICLASS TfsFontSettings;
#pragma pack(push,4)
class PASCALIMPLEMENTATION TfsFontSettings : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	Fmx::Types::TBrush* FFill;
	Fmx::Types::TFont* FFont;
	void __fastcall SetFill(Fmx::Types::TBrush* const Value);
	void __fastcall SetFont(Fmx::Types::TFont* const Value);
	
public:
	__fastcall TfsFontSettings(void);
	__fastcall virtual ~TfsFontSettings(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property Fmx::Types::TBrush* Fill = {read=FFill, write=SetFill};
	__property Fmx::Types::TFont* Font = {read=FFont, write=SetFont};
};

#pragma pack(pop)

class DELPHICLASS TfsSyntaxMemo;
class PASCALIMPLEMENTATION TfsSyntaxMemo : public Fmx::Controls::TStyledControl
{
	typedef Fmx::Controls::TStyledControl inherited;
	
private:
	typedef System::DynamicArray<int> _TfsSyntaxMemo__1;
	
	
private:
	Fmx::Controls::TCaret* FCaret;
	TfsBorderSettings* FBorder;
	Fmx::Types::TBrush* FFill;
	TfsFontSettings* FFontSettings;
	Fmx::Types::TBrush* FGutterFill;
	bool FAllowLinesChange;
	float FCharHeight;
	float FCharWidth;
	bool FDoubleClicked;
	bool FDown;
	int FGutterWidth;
	int FFooterHeight;
	bool FIsMonoType;
	System::UnicodeString FKeywords;
	int FMaxLength;
	System::UnicodeString FMessage;
	bool FModified;
	bool FMoved;
	System::Types::TPoint FOffset;
	System::Types::TPoint FPos;
	bool FReadOnly;
	System::Types::TPoint FSelEnd;
	System::Types::TPoint FSelStart;
	System::Classes::TStrings* FSynStrings;
	TSyntaxType FSyntaxType;
	System::Types::TPoint FTempPos;
	System::Classes::TStringList* FText;
	TfsFontSettings* FKeywordAttr;
	TfsFontSettings* FStringAttr;
	TfsFontSettings* FTextAttr;
	TfsFontSettings* FCommentAttr;
	System::Uitypes::TAlphaColor FBlockColor;
	System::Uitypes::TAlphaColor FBlockFontColor;
	System::Classes::TStringList* FUndo;
	bool FUpdating;
	bool FUpdatingSyntax;
	Fmx::Stdctrls::TScrollBar* FVScroll;
	System::Types::TPoint FWindowSize;
	Fmx::Menus::TPopupMenu* FPopupMenu;
	int KWheel;
	System::UnicodeString LastSearch;
	bool FShowGutter;
	bool FShowFooter;
	_TfsSyntaxMemo__1 Bookmarks;
	int FActiveLine;
	System::Classes::TNotifyEvent FOnChange;
	Fmx::Types::TBitmap* FTmpCanvas;
	void __fastcall CalcCharSize(void);
	float __fastcall GetCharWidth(System::UnicodeString Str);
	System::Classes::TStrings* __fastcall GetText(void);
	void __fastcall SetText(System::Classes::TStrings* Value);
	void __fastcall SetSyntaxType(TSyntaxType Value);
	void __fastcall SetShowGutter(bool Value);
	void __fastcall SetShowFooter(bool Value);
	bool __fastcall FMemoFind(System::UnicodeString Text, System::Types::TPoint &Position);
	TCharAttributes __fastcall GetCharAttr(const System::Types::TPoint &Pos);
	int __fastcall GetLineBegin(int Index);
	int __fastcall GetPlainTextPos(const System::Types::TPoint &Pos);
	System::Types::TPoint __fastcall GetPosPlainText(int Pos);
	System::UnicodeString __fastcall GetSelText(void);
	System::UnicodeString __fastcall LineAt(int Index);
	int __fastcall LineLength(int Index);
	System::UnicodeString __fastcall Pad(int n);
	void __fastcall AddSel(void);
	void __fastcall AddUndo(void);
	void __fastcall ClearSel(void);
	void __fastcall CreateSynArray(void);
	void __fastcall DoChange(void);
	void __fastcall EnterIndent(void);
	void __fastcall SetSelText(System::UnicodeString Value);
	void __fastcall ShiftSelected(bool ShiftRight);
	void __fastcall ShowCaretPos(void);
	void __fastcall TabIndent(void);
	void __fastcall UnIndent(void);
	void __fastcall UpdateScrollBar(void);
	void __fastcall UpdateSyntax(void);
	void __fastcall DoLeft(void);
	void __fastcall DoRight(void);
	void __fastcall DoUp(void);
	void __fastcall DoDown(void);
	void __fastcall DoHome(bool Ctrl);
	void __fastcall DoEnd(bool Ctrl);
	void __fastcall DoPgUp(void);
	void __fastcall DoPgDn(void);
	void __fastcall DoChar(System::WideChar Ch);
	void __fastcall DoReturn(void);
	void __fastcall DoDel(void);
	void __fastcall DoBackspace(void);
	void __fastcall DoCtrlI(void);
	void __fastcall DoCtrlU(void);
	void __fastcall DoCtrlR(void);
	void __fastcall DoCtrlL(void);
	void __fastcall ScrollClick(System::TObject* Sender);
	void __fastcall ScrollEnter(System::TObject* Sender);
	void __fastcall LinesChange(System::TObject* Sender);
	void __fastcall ShowPos(void);
	void __fastcall BookmarkDraw(float Y, int ALine);
	void __fastcall ActiveLineDraw(float Y, int ALine);
	void __fastcall CorrectBookmark(int Line, int delta);
	void __fastcall SetKeywordAttr(TfsFontSettings* Value);
	void __fastcall SetStringAttr(TfsFontSettings* Value);
	void __fastcall SetTextAttr(TfsFontSettings* Value);
	void __fastcall SetCommentAttr(TfsFontSettings* Value);
	void __fastcall SetBorder(TfsBorderSettings* const Value);
	void __fastcall SetFill(Fmx::Types::TBrush* const Value);
	void __fastcall SetFontSettings(TfsFontSettings* const Value);
	void __fastcall SetGutterFill(Fmx::Types::TBrush* const Value);
	
protected:
	virtual void __fastcall SetParent(Fmx::Types::TFmxObject* const Value);
	System::Types::TRectF __fastcall GetClientRect(void);
	virtual void __fastcall DblClick(void);
	virtual void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, float X, float Y);
	virtual void __fastcall MouseMove(System::Classes::TShiftState Shift, float X, float Y);
	virtual void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, float X, float Y);
	virtual void __fastcall KeyDown(System::Word &Key, System::WideChar &KeyChar, System::Classes::TShiftState Shift);
	void __fastcall CopyPopup(System::TObject* Sender);
	void __fastcall PastePopup(System::TObject* Sender);
	void __fastcall CutPopup(System::TObject* Sender);
	virtual void __fastcall MouseWheel(System::Classes::TShiftState Shift, int WheelDelta, bool &Handled);
	void __fastcall DOver(System::TObject* Sender, const Fmx::Types::TDragObject &Data, const System::Types::TPointF &Point, bool &Accept);
	void __fastcall DDrop(System::TObject* Sender, const Fmx::Types::TDragObject &Data, const System::Types::TPointF &Point);
	virtual void __fastcall DoExit(void);
	virtual void __fastcall Resize(void);
	void __fastcall UpdateWindowSize(void);
	void __fastcall FontChanged(System::TObject* Sender);
	virtual void __fastcall DialogKey(System::Word &Key, System::Classes::TShiftState Shift);
	Fmx::Types::TCustomCaret* __fastcall GetCaret(void);
	void __fastcall SetCaret(Fmx::Controls::TCaret* const Value);
	void __fastcall ShowCaret(void);
	void __fastcall HideCaret(void);
	Fmx::Controls::TCaret* __fastcall CreateCaret(void);
	void __fastcall SetAttr(Fmx::Types::TCanvas* aCanvas, TCharAttributes a);
	
public:
	__fastcall virtual TfsSyntaxMemo(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfsSyntaxMemo(void);
	virtual void __fastcall Paint(void);
	void __fastcall CopyToClipboard(void);
	void __fastcall CutToClipboard(void);
	void __fastcall PasteFromClipboard(void);
	void __fastcall SetPos(int x, int y);
	void __fastcall ShowMessage(System::UnicodeString s);
	void __fastcall Undo(void);
	void __fastcall UpdateView(void);
	System::Types::TPoint __fastcall GetPos(void);
	bool __fastcall Find(System::UnicodeString Text);
	__property bool Modified = {read=FModified, write=FModified, nodefault};
	__property System::UnicodeString SelText = {read=GetSelText, write=SetSelText};
	int __fastcall IsBookmark(int Line);
	void __fastcall AddBookmark(int Line, int Number);
	void __fastcall DeleteBookmark(int Number);
	void __fastcall GotoBookmark(int Number);
	void __fastcall SetActiveLine(int Line);
	int __fastcall GetActiveLine(void);
	__property Fmx::Controls::TCaret* Caret = {read=FCaret, write=SetCaret};
	
__published:
	__property Align = {default=0};
	__property Anchors;
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property PopupMenu;
	__property ShowHint = {default=0};
	__property TabOrder = {default=-1};
	__property Width;
	__property Height;
	__property Visible = {default=1};
	__property Cursor = {default=0};
	__property System::Uitypes::TAlphaColor BlockColor = {read=FBlockColor, write=FBlockColor, nodefault};
	__property System::Uitypes::TAlphaColor BlockFontColor = {read=FBlockFontColor, write=FBlockFontColor, nodefault};
	__property TfsFontSettings* CommentAttr = {read=FCommentAttr, write=SetCommentAttr};
	__property TfsFontSettings* KeywordAttr = {read=FKeywordAttr, write=SetKeywordAttr};
	__property TfsFontSettings* StringAttr = {read=FStringAttr, write=SetStringAttr};
	__property TfsFontSettings* TextAttr = {read=FTextAttr, write=SetTextAttr};
	__property TfsBorderSettings* Border = {read=FBorder, write=SetBorder};
	__property Fmx::Types::TBrush* Fill = {read=FFill, write=SetFill};
	__property TfsFontSettings* FontSettings = {read=FFontSettings, write=SetFontSettings};
	__property Fmx::Types::TBrush* GutterFill = {read=FGutterFill, write=SetGutterFill};
	__property System::Classes::TStrings* Lines = {read=GetText, write=SetText};
	__property bool ReadOnly = {read=FReadOnly, write=FReadOnly, nodefault};
	__property TSyntaxType SyntaxType = {read=FSyntaxType, write=SetSyntaxType, nodefault};
	__property bool ShowFooter = {read=FShowFooter, write=SetShowFooter, nodefault};
	__property bool ShowGutter = {read=FShowGutter, write=SetShowGutter, nodefault};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
private:
	void *__ICaret;	/* Fmx::Types::ICaret */
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {F4EFFFB8-E83C-421D-B123-C370FB7BCCC7}
	operator Fmx::Types::_di_ICaret()
	{
		Fmx::Types::_di_ICaret intf;
		GetInterface(intf);
		return intf;
	}
	#else
	operator Fmx::Types::ICaret*(void) { return (Fmx::Types::ICaret*)&__ICaret; }
	#endif
	
};


class DELPHICLASS TfsSynMemoSearch;
class PASCALIMPLEMENTATION TfsSynMemoSearch : public Fmx::Forms::TForm
{
	typedef Fmx::Forms::TForm inherited;
	
__published:
	Fmx::Stdctrls::TButton* Search;
	Fmx::Stdctrls::TButton* Button1;
	Fmx::Stdctrls::TLabel* Label1;
	Fmx::Edit::TEdit* Edit1;
	void __fastcall FormKeyPress(System::TObject* Sender, System::WideChar &Key);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfsSynMemoSearch(System::Classes::TComponent* AOwner) : Fmx::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfsSynMemoSearch(System::Classes::TComponent* AOwner, int Dummy) : Fmx::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfsSynMemoSearch(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfsSynMemoSearch* SynMemoSearch;
}	/* namespace Fs_synmemo */
}	/* namespace Fmx */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX_FS_SYNMEMO)
using namespace Fmx::Fs_synmemo;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FMX)
using namespace Fmx;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fmx_Fs_synmemoHPP
