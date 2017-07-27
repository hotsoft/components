// CodeGear C++Builder
// Copyright (c) 1995, 2013 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'fs_synmemo.pas' rev: 25.00 (Windows)

#ifndef Fs_synmemoHPP
#define Fs_synmemoHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <Winapi.Windows.hpp>	// Pascal unit
#include <Winapi.Messages.hpp>	// Pascal unit
#include <Vcl.StdCtrls.hpp>	// Pascal unit
#include <Vcl.Controls.hpp>	// Pascal unit
#include <System.Classes.hpp>	// Pascal unit
#include <System.SysUtils.hpp>	// Pascal unit
#include <Vcl.Graphics.hpp>	// Pascal unit
#include <Vcl.Forms.hpp>	// Pascal unit
#include <Vcl.Menus.hpp>	// Pascal unit
#include <System.Types.hpp>	// Pascal unit
#include <System.UITypes.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Fs_synmemo
{
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TSyntaxType : unsigned char { stPascal, stCpp, stJs, stVB, stSQL, stText };

enum DECLSPEC_DENUM TCharAttr : unsigned char { caNo, caText, caBlock, caComment, caKeyword, caString };

typedef System::Set<TCharAttr, TCharAttr::caNo, TCharAttr::caString>  TCharAttributes;

class DELPHICLASS TfsSyntaxMemo;
class PASCALIMPLEMENTATION TfsSyntaxMemo : public Vcl::Controls::TCustomControl
{
	typedef Vcl::Controls::TCustomControl inherited;
	
private:
	typedef System::DynamicArray<int> _TfsSyntaxMemo__1;
	
	
private:
	bool FAllowLinesChange;
	int FCharHeight;
	int FCharWidth;
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
	Vcl::Graphics::TFont* FKeywordAttr;
	Vcl::Graphics::TFont* FStringAttr;
	Vcl::Graphics::TFont* FTextAttr;
	Vcl::Graphics::TFont* FCommentAttr;
	System::Uitypes::TColor FBlockColor;
	System::Uitypes::TColor FBlockFontColor;
	System::Classes::TStringList* FUndo;
	bool FUpdating;
	bool FUpdatingSyntax;
	Vcl::Stdctrls::TScrollBar* FVScroll;
	System::Types::TPoint FWindowSize;
	Vcl::Menus::TPopupMenu* FPopupMenu;
	int KWheel;
	System::UnicodeString LastSearch;
	bool FShowGutter;
	bool FShowFooter;
	_TfsSyntaxMemo__1 Bookmarks;
	int FActiveLine;
	System::Classes::TNotifyEvent FOnChange;
	HIDESBASE System::Classes::TStrings* __fastcall GetText(void);
	HIDESBASE void __fastcall SetText(System::Classes::TStrings* Value);
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
	void __fastcall BookmarkDraw(int Y, int ALine);
	void __fastcall ActiveLineDraw(int Y, int ALine);
	void __fastcall CorrectBookmark(int Line, int delta);
	void __fastcall SetKeywordAttr(Vcl::Graphics::TFont* Value);
	void __fastcall SetStringAttr(Vcl::Graphics::TFont* Value);
	void __fastcall SetTextAttr(Vcl::Graphics::TFont* Value);
	void __fastcall SetCommentAttr(Vcl::Graphics::TFont* Value);
	
protected:
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	MESSAGE void __fastcall WMGetDlgCode(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* Value);
	virtual System::Types::TRect __fastcall GetClientRect(void);
	DYNAMIC void __fastcall DblClick(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	void __fastcall CopyPopup(System::TObject* Sender);
	void __fastcall PastePopup(System::TObject* Sender);
	void __fastcall CutPopup(System::TObject* Sender);
	void __fastcall MouseWheelUp(System::TObject* Sender, System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos, bool &Handled);
	void __fastcall MouseWheelDown(System::TObject* Sender, System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos, bool &Handled);
	void __fastcall DOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall DDrop(System::TObject* Sender, System::TObject* Source, int X, int Y);
	
public:
	__fastcall virtual TfsSyntaxMemo(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TfsSyntaxMemo(void);
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
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
	
__published:
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Color = {default=-16777211};
	__property Constraints;
	__property DragCursor = {default=-12};
	__property DragKind = {default=0};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ParentColor = {default=1};
	__property ParentBiDiMode = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Width;
	__property Height;
	__property Visible = {default=1};
	__property System::Uitypes::TColor BlockColor = {read=FBlockColor, write=FBlockColor, nodefault};
	__property System::Uitypes::TColor BlockFontColor = {read=FBlockFontColor, write=FBlockFontColor, nodefault};
	__property Vcl::Graphics::TFont* CommentAttr = {read=FCommentAttr, write=SetCommentAttr};
	__property Vcl::Graphics::TFont* KeywordAttr = {read=FKeywordAttr, write=SetKeywordAttr};
	__property Vcl::Graphics::TFont* StringAttr = {read=FStringAttr, write=SetStringAttr};
	__property Vcl::Graphics::TFont* TextAttr = {read=FTextAttr, write=SetTextAttr};
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
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
public:
	/* TWinControl.CreateParented */ inline __fastcall TfsSyntaxMemo(HWND ParentWindow) : Vcl::Controls::TCustomControl(ParentWindow) { }
	
};


class DELPHICLASS TfsSynMemoSearch;
class PASCALIMPLEMENTATION TfsSynMemoSearch : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TButton* Search;
	Vcl::Stdctrls::TButton* Button1;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Stdctrls::TEdit* Edit1;
	void __fastcall FormKeyPress(System::TObject* Sender, System::WideChar &Key);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TfsSynMemoSearch(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TfsSynMemoSearch(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TfsSynMemoSearch(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TfsSynMemoSearch(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TfsSynMemoSearch* SynMemoSearch;
}	/* namespace Fs_synmemo */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_FS_SYNMEMO)
using namespace Fs_synmemo;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Fs_synmemoHPP
