// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwdbcomb.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwdbcombHPP
#define Vcl_WwdbcombHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.Wwdotdot.hpp>
#include <Data.DB.hpp>
#include <Vcl.Menus.hpp>
#include <vcl.wwtypes.hpp>
#include <Vcl.Grids.hpp>
#include <vcl.wwframe.hpp>
#include <vcl.wwhistorylist.hpp>
#include <Vcl.Themes.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <vcl.wwintl.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwdbcomb
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwPopupListbox;
class DELPHICLASS TwwPopupListBoxStyleHook;
class DELPHICLASS TwwDBCustomComboBox;
class DELPHICLASS TwwDBComboBox;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TwwComboCloseUpEvent)(TwwDBComboBox* Sender, bool Select);

typedef void __fastcall (__closure *TwwAddHistoryItemEvent)(TwwDBCustomComboBox* Sender, System::UnicodeString Value, bool &Accept);

class PASCALIMPLEMENTATION TwwPopupListbox : public Vcl::Stdctrls::TCustomListBox
{
	typedef Vcl::Stdctrls::TCustomListBox inherited;
	
private:
	// __classmethod void __fastcall Create@();
	
private:
	System::UnicodeString FSearchText;
	int FSearchTickCount;
	
protected:
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	HIDESBASE MESSAGE void __fastcall WMKeyDown(Winapi::Messages::TWMKey &Message);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	virtual void __fastcall DrawItem(int Index, const System::Types::TRect &Rect, Winapi::Windows::TOwnerDrawState State);
	HIDESBASE MESSAGE void __fastcall CNCommand(Winapi::Messages::TWMCommand &Message);
	
public:
	__fastcall virtual TwwPopupListbox(System::Classes::TComponent* AOwner);
	__property Sorted = {default=0};
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TCustomListBox.Destroy */ inline __fastcall virtual ~TwwPopupListbox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwPopupListbox(HWND ParentWindow) : Vcl::Stdctrls::TCustomListBox(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwPopupListBoxStyleHook : public Vcl::Stdctrls::TListBoxStyleHook
{
	typedef Vcl::Stdctrls::TListBoxStyleHook inherited;
	
private:
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TMessage &Message);
	
protected:
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* Canvas);
	virtual void __fastcall PaintNC(Vcl::Graphics::TCanvas* Canvas);
	virtual void __fastcall PaintBackground(Vcl::Graphics::TCanvas* Canvas);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	
public:
	__fastcall virtual TwwPopupListBoxStyleHook(Vcl::Controls::TWinControl* AControl);
public:
	/* TScrollingStyleHook.Destroy */ inline __fastcall virtual ~TwwPopupListBoxStyleHook(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwDBCustomComboBox : public Vcl::Wwdotdot::TwwDBCustomCombo
{
	typedef Vcl::Wwdotdot::TwwDBCustomCombo inherited;
	
private:
	bool FMapList;
	System::Classes::TStrings* FItems;
	int FDropDownCount;
	int FItemHeight;
	TwwPopupListbox* FListbox;
	bool FListVisible;
	bool FNoKeysEnteredYet;
	bool FAllowClearKey;
	int FItemIndex;
	Vcl::Stdctrls::TComboBoxStyle FStyle;
	Vcl::Graphics::TCanvas* FCanvas;
	int FDropDownWidth;
	bool FAutoDropDown;
	bool FShowMatchText;
	Vcl::Wwhistorylist::TwwHistoryList* FHistoryList;
	System::Classes::TNotifyEvent FOnDropDown;
	TwwComboCloseUpEvent FOnCloseUp;
	Vcl::Stdctrls::TDrawItemEvent FOnDrawItem;
	Vcl::Stdctrls::TMeasureItemEvent FOnMeasureItem;
	TwwAddHistoryItemEvent FOnAddHistoryItem;
	bool InAutoDropDown;
	bool LastShowHint;
	System::UnicodeString PreDropDownText;
	bool DoSelChange;
	bool DirtyListBox;
	bool FDisableDropDownList;
	int FColumn1Width;
	bool FTwoColumnDisplay;
	System::UnicodeString __fastcall GetComboText(void);
	void __fastcall SetComboText(const System::UnicodeString Value);
	void __fastcall SetItemList(System::Classes::TStrings* Value);
	bool __fastcall GetSorted(void);
	void __fastcall SetSorted(bool val);
	int __fastcall GetItemIndex(void);
	void __fastcall ListMouseUp(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	HIDESBASE MESSAGE void __fastcall WMPaste(Winapi::Messages::TMessage &Message);
	Vcl::Graphics::TCanvas* __fastcall GetCanvas(void);
	void __fastcall SetStyle(Vcl::Stdctrls::TComboBoxStyle val);
	System::UnicodeString __fastcall GetValue(void);
	void __fastcall SetDroppedDown(bool val);
	
protected:
	virtual void __fastcall SetValue(System::UnicodeString Value);
	virtual int __fastcall IndexOf(System::UnicodeString Value, int StartIndex = 0x0);
	virtual void __fastcall Loaded(void);
	virtual bool __fastcall OwnerDraw(void);
	virtual System::UnicodeString __fastcall GetStoredText(void);
	virtual void __fastcall CloseUp(bool Accept);
	virtual bool __fastcall IsDroppedDown(void);
	virtual bool __fastcall Editable(void);
	virtual bool __fastcall MouseEditable(void);
	DYNAMIC void __fastcall KeyUp(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	virtual TwwPopupListbox* __fastcall CreateListBox(void);
	void __fastcall ListBoxNeeded(void);
	void __fastcall DoSelectAll(void);
	virtual void __fastcall ShowText(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect, int indentLeft, int indentTop, System::UnicodeString AText, bool transparent = false);
	void __fastcall SetListBoxItemIndex(int val);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	void __fastcall ProcessSearchKey(System::WideChar Key, int NewItemIndex, int OldItemIndex, System::UnicodeString FSearchText, System::UnicodeString MatchTextFromList);
	virtual void __fastcall DataChange(System::TObject* Sender);
	virtual void __fastcall SetItemIndex(int val);
	virtual int __fastcall CalcItemHeight(void);
	
public:
	HIDESBASE MESSAGE void __fastcall WMCut(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMClear(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMCancelMode(Vcl::Controls::TCMCancelMode &Message);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Message);
	HIDESBASE MESSAGE void __fastcall CNKeyDown(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	__property TwwPopupListbox* Listbox = {read=FListbox};
	__fastcall virtual TwwDBCustomComboBox(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDBCustomComboBox(void);
	void __fastcall ListBoxItemsNeeded(void);
	virtual void __fastcall DeleteItem(System::UnicodeString Value, bool DeleteFromHistory = false);
	virtual void __fastcall AddItem(System::UnicodeString Value, bool AddToHistory = false);
	virtual void __fastcall ClearHistory(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual bool __fastcall GetFieldMapText(System::UnicodeString StoreValue, System::UnicodeString &res);
	virtual System::UnicodeString __fastcall GetComboValue(System::UnicodeString DisplayText);
	virtual System::UnicodeString __fastcall GetComboDisplay(System::UnicodeString Value);
	virtual void __fastcall ApplyList(void);
	virtual void __fastcall DropDown(void);
	__property Vcl::Graphics::TCanvas* Canvas = {read=GetCanvas};
	__property bool DroppedDown = {read=IsDroppedDown, write=SetDroppedDown, nodefault};
	__property System::UnicodeString Value = {read=GetValue, write=SetValue};
	__property ShowButton;
	__property Vcl::Stdctrls::TComboBoxStyle Style = {read=FStyle, write=SetStyle, nodefault};
	__property bool MapList = {read=FMapList, write=FMapList, nodefault};
	__property bool AllowClearKey = {read=FAllowClearKey, write=FAllowClearKey, nodefault};
	__property bool AutoDropDown = {read=FAutoDropDown, write=FAutoDropDown, default=0};
	__property EditAlignment = {default=0};
	__property bool ShowMatchText = {read=FShowMatchText, write=FShowMatchText, default=0};
	__property ButtonStyle = {default=1};
	__property int DropDownCount = {read=FDropDownCount, write=FDropDownCount, nodefault};
	__property int DropDownWidth = {read=FDropDownWidth, write=FDropDownWidth, default=0};
	__property bool DisableDropDownList = {read=FDisableDropDownList, write=FDisableDropDownList, default=0};
	__property bool TwoColumnDisplay = {read=FTwoColumnDisplay, write=FTwoColumnDisplay, default=0};
	__property int Column1Width = {read=FColumn1Width, write=FColumn1Width, default=0};
	__property Vcl::Wwhistorylist::TwwHistoryList* HistoryList = {read=FHistoryList, write=FHistoryList};
	__property int ItemHeight = {read=FItemHeight, write=FItemHeight, nodefault};
	__property System::Classes::TStrings* Items = {read=FItems, write=SetItemList};
	__property int ItemIndex = {read=GetItemIndex, write=SetItemIndex, default=-1};
	__property bool Sorted = {read=GetSorted, write=SetSorted, nodefault};
	__property System::Classes::TNotifyEvent OnDropDown = {read=FOnDropDown, write=FOnDropDown};
	__property TwwComboCloseUpEvent OnCloseUp = {read=FOnCloseUp, write=FOnCloseUp};
	__property Vcl::Stdctrls::TDrawItemEvent OnDrawItem = {read=FOnDrawItem, write=FOnDrawItem};
	__property Vcl::Stdctrls::TMeasureItemEvent OnMeasureItem = {read=FOnMeasureItem, write=FOnMeasureItem};
	__property TwwAddHistoryItemEvent OnAddHistoryItem = {read=FOnAddHistoryItem, write=FOnAddHistoryItem};
	
protected:
	virtual void __fastcall Reset(void);
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBCustomComboBox(HWND ParentWindow) : Vcl::Wwdotdot::TwwDBCustomCombo(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwDBComboBox : public TwwDBCustomComboBox
{
	typedef TwwDBCustomComboBox inherited;
	
private:
	// __classmethod void __fastcall Create@();
	
__published:
	__property Controller;
	__property BevelEdges = {default=15};
	__property BevelInner = {index=0, default=2};
	__property BevelKind = {default=0};
	__property BevelOuter = {index=1, default=1};
	__property DisableThemes = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Constraints;
	__property ParentBiDiMode = {default=1};
	__property ShowButton;
	__property Style;
	__property MapList;
	__property AllowClearKey;
	__property AutoDropDown = {default=0};
	__property ShowMatchText = {default=0};
	__property AutoFillDate = {default=1};
	__property AutoSelect = {default=1};
	__property AutoSize = {default=1};
	__property BorderStyle = {default=1};
	__property ButtonStyle = {default=1};
	__property CharCase = {default=0};
	__property Color = {default=-16777211};
	__property Column1Width = {default=0};
	__property Ctl3D;
	__property DataField = {default=0};
	__property DataSource;
	__property DisableDropDownList = {default=0};
	__property DragMode = {default=0};
	__property DragCursor = {default=-12};
	__property DropDownCount;
	__property DropDownWidth = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ButtonEffects;
	__property Frame;
	__property ButtonWidth = {default=0};
	__property ButtonGlyph;
	__property HistoryList;
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property ItemHeight;
	__property Items;
	__property ItemIndex = {default=-1};
	__property LimitEditRect = {default=0};
	__property MaxLength = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property Picture;
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property ShowHint;
	__property Sorted;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property UnboundDataType;
	__property UsePictureMask = {default=1};
	__property Visible = {default=1};
	__property UnboundAlignment = {default=0};
	__property TwoColumnDisplay = {default=0};
	__property Touch;
	__property OnAddHistoryItem;
	__property OnChange;
	__property OnCheckValue;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDropDown;
	__property OnCloseUp;
	__property OnDrawItem;
	__property OnMeasureItem;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnGesture;
	__property Align = {default=0};
	__property StyleElements = {default=7};
	__property OEMConvert = {default=0};
	__property NumbersOnly = {default=0};
	__property DoubleBuffered;
	__property ParentDoubleBuffered = {default=1};
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TwwDBCustomComboBox.Create */ inline __fastcall virtual TwwDBComboBox(System::Classes::TComponent* AOwner) : TwwDBCustomComboBox(AOwner) { }
	/* TwwDBCustomComboBox.Destroy */ inline __fastcall virtual ~TwwDBComboBox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBComboBox(HWND ParentWindow) : TwwDBCustomComboBox(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwdbcomb */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWDBCOMB)
using namespace Vcl::Wwdbcomb;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwdbcombHPP
