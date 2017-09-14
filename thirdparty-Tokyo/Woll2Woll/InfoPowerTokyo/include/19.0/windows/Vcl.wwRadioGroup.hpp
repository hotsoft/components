// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwradiogroup.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwradiogroupHPP
#define Vcl_WwradiogroupHPP

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
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <vcl.wwframe.hpp>
#include <Vcl.DBCtrls.hpp>
#include <Data.DB.hpp>
#include <vcl.wwradiobutton.hpp>
#include <vcl.wwclearbuttongroup.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.ImgList.hpp>
#include <vcl.wwdbgrid.hpp>
#include <vcl.wwintl.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwradiogroup
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwRGEditFrame;
class DELPHICLASS TwwRGWinButtonIndents;
class DELPHICLASS TwwCustomRadioGroup;
class DELPHICLASS TwRadioGroup;
class DELPHICLASS TwwRadioGroup;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TwwCreateRadioButton)(TwwCustomRadioGroup* Sender, Vcl::Wwradiobutton::TwwRadioButton* RadioButton);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwRGEditFrame : public Vcl::Wwframe::TwwEditFrame
{
	typedef Vcl::Wwframe::TwwEditFrame inherited;
	
__published:
	__property FocusBorders = {default=0};
	__property NonFocusBorders = {default=0};
public:
	/* TwwEditFrame.Create */ inline __fastcall TwwRGEditFrame(System::Classes::TComponent* Owner) : Vcl::Wwframe::TwwEditFrame(Owner) { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwRGEditFrame(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwRGWinButtonIndents : public Vcl::Wwradiobutton::TwwWinButtonIndents
{
	typedef Vcl::Wwradiobutton::TwwWinButtonIndents inherited;
	
protected:
	virtual void __fastcall Repaint(Vcl::Controls::TWinControl* FWinControl);
public:
	/* TwwWinButtonIndents.Create */ inline __fastcall TwwRGWinButtonIndents(System::Classes::TComponent* AOwner) : Vcl::Wwradiobutton::TwwWinButtonIndents(AOwner) { }
	
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwRGWinButtonIndents(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwCustomRadioGroup : public Vcl::Wwclearbuttongroup::TwwCustomTransparentGroupBox
{
	typedef Vcl::Wwclearbuttongroup::TwwCustomTransparentGroupBox inherited;
	
private:
	TwwCreateRadioButton FOnCreateRadioButton;
	Vcl::Wwradiobutton::TwwWinButtonIndents* FIndents;
	Vcl::Wwframe::TwwEditFrame* FFrame;
	TwwRGEditFrame* FButtonFrame;
	System::Classes::TStrings* FItems;
	int FItemIndex;
	int FColumns;
	bool FReading;
	bool FUpdating;
	bool FShowBorder;
	bool FShowGroupCaption;
	bool FShowFocusRect;
	bool FTransparentActiveItem;
	Vcl::Imglist::TCustomImageList* FImages;
	Vcl::Imglist::TCustomImageList* FGlyphImages;
	System::Classes::TList* FButtons;
	System::Uitypes::TColor PaintCopyTextColor;
	bool FShowText;
	bool FFocused;
	bool SkipSetChildFocus;
	bool FWordWrap;
	System::Classes::TAlignment FAlignment;
	bool FNoSpacing;
	bool FAnyClickToggles;
	bool FDisableThemes;
	Vcl::Wwintl::TwwController* FController;
	bool FArrowsModifySelection;
	void __fastcall SetController(Vcl::Wwintl::TwwController* Value);
	void __fastcall ArrangeButtons(void);
	void __fastcall ButtonClick(System::TObject* Sender);
	void __fastcall ItemsChange(System::TObject* Sender);
	void __fastcall SetButtonCount(int Value);
	void __fastcall SetColumns(int Value);
	void __fastcall SetItemIndex(int Value);
	void __fastcall SetItems(System::Classes::TStrings* Value);
	HIDESBASE MESSAGE void __fastcall CMEnabledChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Message);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	
protected:
	virtual bool __fastcall StoreItemIndex(void);
	virtual bool __fastcall IsTransparent(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall DoCreateRadioButton(Vcl::Wwradiobutton::TwwRadioButton* RadioButton);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	virtual void __fastcall Paint(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall ReadState(System::Classes::TReader* Reader);
	virtual bool __fastcall CanModify(void);
	virtual bool __fastcall HaveBorder(void);
	__property int Columns = {read=FColumns, write=SetColumns, default=1};
	__property int ItemIndex = {read=FItemIndex, write=SetItemIndex, stored=StoreItemIndex, default=-1};
	__property System::Classes::TStrings* Items = {read=FItems, write=SetItems};
	
public:
	System::Uitypes::TColor LastBrushColor;
	bool InCNKeyDown;
	__fastcall virtual TwwCustomRadioGroup(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwCustomRadioGroup(void);
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	DYNAMIC void __fastcall FlipChildren(bool AllLevels);
	void __fastcall UpdateButtons(void);
	__property Vcl::Wwintl::TwwController* Controller = {read=FController, write=SetController};
	__property TwwRGEditFrame* ButtonFrame = {read=FButtonFrame, write=FButtonFrame};
	__property Vcl::Wwframe::TwwEditFrame* Frame = {read=FFrame, write=FFrame};
	__property bool ShowBorder = {read=FShowBorder, write=FShowBorder, default=1};
	__property bool ShowGroupCaption = {read=FShowGroupCaption, write=FShowGroupCaption, default=1};
	__property bool ShowFocusRect = {read=FShowFocusRect, write=FShowFocusRect, default=1};
	__property bool TransparentActiveItem = {read=FTransparentActiveItem, write=FTransparentActiveItem, default=0};
	__property Vcl::Imglist::TCustomImageList* Images = {read=FImages, write=FImages};
	__property Vcl::Imglist::TCustomImageList* GlyphImages = {read=FGlyphImages, write=FGlyphImages};
	__property Vcl::Wwradiobutton::TwwWinButtonIndents* Indents = {read=FIndents, write=FIndents};
	__property TwwCreateRadioButton OnCreateRadioButton = {read=FOnCreateRadioButton, write=FOnCreateRadioButton};
	__property bool ShowText = {read=FShowText, write=FShowText, default=1};
	__property bool WordWrap = {read=FWordWrap, write=FWordWrap, default=0};
	__property System::Classes::TLeftRight Alignment = {read=FAlignment, write=FAlignment, default=1};
	__property bool NoSpacing = {read=FNoSpacing, write=FNoSpacing, default=0};
	__property bool AnyClickToggles = {read=FAnyClickToggles, write=FAnyClickToggles, nodefault};
	__property bool ArrowsModifySelection = {read=FArrowsModifySelection, write=FArrowsModifySelection, default=0};
	__property bool DisableThemes = {read=FDisableThemes, write=FDisableThemes, nodefault};
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwCustomRadioGroup(HWND ParentWindow) : Vcl::Wwclearbuttongroup::TwwCustomTransparentGroupBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwRadioGroup : public TwwCustomRadioGroup
{
	typedef TwwCustomRadioGroup inherited;
	
__published:
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Caption = {default=0};
	__property Color = {default=-16777211};
	__property Columns = {default=1};
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragKind = {default=0};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ButtonFrame;
	__property ItemIndex = {default=-1};
	__property Items;
	__property Constraints;
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property ShowBorder = {default=1};
	__property ShowGroupCaption = {default=1};
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Transparent = {default=0};
	__property Visible = {default=1};
	__property OnClick;
	__property OnContextPopup;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDock;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnStartDock;
	__property OnStartDrag;
public:
	/* TwwCustomRadioGroup.Create */ inline __fastcall virtual TwRadioGroup(System::Classes::TComponent* AOwner) : TwwCustomRadioGroup(AOwner) { }
	/* TwwCustomRadioGroup.Destroy */ inline __fastcall virtual ~TwRadioGroup(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwRadioGroup(HWND ParentWindow) : TwwCustomRadioGroup(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwRadioGroup : public TwwCustomRadioGroup
{
	typedef TwwCustomRadioGroup inherited;
	
private:
	Vcl::Dbctrls::TFieldDataLink* FDataLink;
	System::UnicodeString FValue;
	System::Classes::TStrings* FValues;
	bool FInSetValue;
	System::Classes::TNotifyEvent FOnChange;
	void __fastcall DataChange(System::TObject* Sender);
	void __fastcall UpdateData(System::TObject* Sender);
	System::UnicodeString __fastcall GetDataField(void);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	Data::Db::TField* __fastcall GetField(void);
	bool __fastcall GetReadOnly(void);
	void __fastcall SetDataField(const System::UnicodeString Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	void __fastcall SetReadOnly(bool Value);
	void __fastcall SetValue(const System::UnicodeString Value);
	HIDESBASE void __fastcall SetItems(System::Classes::TStrings* Value);
	void __fastcall SetValues(System::Classes::TStrings* Value);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE void __fastcall SetColor(System::Uitypes::TColor Value);
	System::Uitypes::TColor __fastcall GetColor(void);
	HIDESBASE bool __fastcall IsColorStored(void);
	
protected:
	virtual bool __fastcall StoreItemIndex(void);
	virtual void __fastcall Paint(void);
	DYNAMIC void __fastcall Change(void);
	DYNAMIC void __fastcall Click(void);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	virtual bool __fastcall CanModify(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	__property Vcl::Dbctrls::TFieldDataLink* DataLink = {read=FDataLink};
	
public:
	__fastcall virtual TwwRadioGroup(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwRadioGroup(void);
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	DYNAMIC bool __fastcall UseRightToLeftAlignment(void);
	__property Data::Db::TField* Field = {read=GetField};
	__property System::UnicodeString Value = {read=FValue, write=SetValue};
	System::UnicodeString __fastcall GetButtonValue(int Index);
	System::UnicodeString __fastcall GetDisplayValue(const System::UnicodeString Value);
	
__published:
	__property Controller;
	__property DisableThemes;
	__property ItemIndex = {default=-1};
	__property TransparentActiveItem = {default=0};
	__property Frame;
	__property ButtonFrame;
	__property Indents;
	__property Images;
	__property GlyphImages;
	__property ShowBorder = {default=1};
	__property ShowGroupCaption = {default=1};
	__property ShowFocusRect = {default=1};
	__property Transparent = {default=0};
	__property ShowText = {default=1};
	__property NoSpacing = {default=0};
	__property ArrowsModifySelection = {default=0};
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Caption = {default=0};
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, stored=IsColorStored, nodefault};
	__property Columns = {default=1};
	__property Constraints;
	__property Ctl3D;
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property DragCursor = {default=-12};
	__property DragKind = {default=0};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property Items = {write=SetItems};
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property WordWrap = {default=0};
	__property Alignment = {default=1};
	__property System::Classes::TStrings* Values = {read=FValues, write=SetValues};
	__property Visible = {default=1};
	__property Touch;
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property OnClick;
	__property OnContextPopup;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDock;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnStartDock;
	__property OnStartDrag;
	__property OnCreateRadioButton;
	__property OnGesture;
	__property StyleElements = {default=7};
	__property DoubleBuffered;
	__property ParentDoubleBuffered = {default=1};
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwRadioGroup(HWND ParentWindow) : TwwCustomRadioGroup(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwradiogroup */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWRADIOGROUP)
using namespace Vcl::Wwradiogroup;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwradiogroupHPP
