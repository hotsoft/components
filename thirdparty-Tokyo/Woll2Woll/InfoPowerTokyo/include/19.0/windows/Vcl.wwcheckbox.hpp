// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwcheckbox.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwcheckboxHPP
#define Vcl_WwcheckboxHPP

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
#include <vcl.Wwcommon.hpp>
#include <Vcl.ImgList.hpp>
#include <vcl.wwradiobutton.hpp>
#include <Vcl.Grids.hpp>
#include <vcl.wwdbgrid.hpp>
#include <vcl.wwintl.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwcheckbox
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwCustomCheckBox;
class DELPHICLASS TwwDBCustomCheckBox;
class DELPHICLASS TwwCheckBox;
class DELPHICLASS TwwExpandGridIndents;
class DELPHICLASS TwwExpandButton;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwCustomCheckBox : public Vcl::Stdctrls::TCustomCheckBox
{
	typedef Vcl::Stdctrls::TCustomCheckBox inherited;
	
private:
	Vcl::Controls::TControlCanvas* FCanvas;
	Vcl::Wwframe::TwwEditFrame* FFrame;
	Vcl::Wwradiobutton::TwwWinButtonIndents* FIndents;
	bool FAlwaysTransparent;
	System::UnicodeString FValueChecked;
	System::UnicodeString FValueUnchecked;
	System::UnicodeString FDisplayValueChecked;
	System::UnicodeString FDisplayValueUnchecked;
	bool FShowFocusRect;
	bool FShowBoxAroundGlyph;
	bool FDynamicCaption;
	Vcl::Imglist::TCustomImageList* FImages;
	bool FWordWrap;
	Vcl::Graphics::TBitmap* FPaintBitmap;
	Vcl::Graphics::TCanvas* FPaintCanvas;
	bool SpaceKeyPressed;
	bool FModified;
	System::Classes::TNotifyEvent FOnMouseEnter;
	System::Classes::TNotifyEvent FOnMouseLeave;
	bool FShowAsButton;
	Vcl::Stdctrls::TCheckBoxState FNullAndBlankState;
	bool FShowText;
	bool FCenterTextVertically;
	bool FDisableThemes;
	Vcl::Wwintl::TwwController* FController;
	System::Classes::TAlignment FTextAlignment;
	void __fastcall SetController(Vcl::Wwintl::TwwController* Value);
	bool __fastcall isTransparentEffective(void);
	MESSAGE void __fastcall CNDrawItem(Winapi::Messages::TWMDrawItem &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	virtual void __fastcall DrawItem(const tagDRAWITEMSTRUCT &DrawItemStruct);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Message);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Message);
	MESSAGE void __fastcall BMSetCheck(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMNCPaint(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall CMTextChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CNKeyDown(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall CNCommand(Winapi::Messages::TWMCommand &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall EMGetModify(Winapi::Messages::TMessage &Message);
	void __fastcall SetValueChecked(const System::UnicodeString Value);
	void __fastcall SetValueUnchecked(const System::UnicodeString Value);
	System::UnicodeString __fastcall GetDisplayValueChecked(void);
	System::UnicodeString __fastcall GetDisplayValueUnchecked(void);
	void __fastcall SetDisplayValueChecked(const System::UnicodeString Value);
	void __fastcall SetDisplayValueUnchecked(const System::UnicodeString Value);
	void __fastcall ComputeTextRect(System::Types::TRect &DrawRect);
	bool __fastcall GetModified(void);
	void __fastcall SetModified(bool Value);
	HIDESBASE void __fastcall SetColor(System::Uitypes::TColor Value);
	System::Uitypes::TColor __fastcall GetColor(void);
	HIDESBASE bool __fastcall IsColorStored(void);
	
protected:
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	virtual System::UnicodeString __fastcall GetDisplayText(void);
	virtual int __fastcall GetExtraIndentX(void);
	virtual bool __fastcall IsMouseInControl(bool CheckAreaOnly = false);
	virtual bool __fastcall FillBackground(void);
	virtual Vcl::Stdctrls::TCheckBoxState __fastcall GetFieldState(void);
	DYNAMIC void __fastcall KeyUp(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall Paint(void);
	void __fastcall PaintBorder(void);
	virtual void __fastcall DataChange(System::TObject* Sender);
	virtual Vcl::Graphics::TCanvas* __fastcall GetCanvas(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall DoMouseEnter(void);
	virtual void __fastcall DoMouseLeave(void);
	virtual Vcl::Controls::TImageList* __fastcall GetImageList(void);
	virtual bool __fastcall HideExpand(void);
	virtual Data::Db::TField* __fastcall GetField(void);
	virtual System::Classes::TAlignment __fastcall GetAlignment(void);
	virtual int __fastcall GetDrawFlags(void);
	bool __fastcall DrawHighlightForRowSelect(bool CheckBoth = true);
	bool __fastcall DrawHighlight(void);
	void __fastcall PaintFocusRect(void);
	
public:
	__fastcall virtual ~TwwCustomCheckBox(void);
	__fastcall virtual TwwCustomCheckBox(System::Classes::TComponent* AOwner);
	virtual void __fastcall ComputeGlyphRect(System::Types::TRect &DrawRect);
	__property Vcl::Graphics::TCanvas* Canvas = {read=GetCanvas};
	__property Vcl::Imglist::TCustomImageList* Images = {read=FImages, write=FImages};
	__property System::Classes::TNotifyEvent OnMouseEnter = {read=FOnMouseEnter, write=FOnMouseEnter};
	__property System::Classes::TNotifyEvent OnMouseLeave = {read=FOnMouseLeave, write=FOnMouseLeave};
	__property bool Modified = {read=GetModified, write=SetModified, nodefault};
	__property Vcl::Wwintl::TwwController* Controller = {read=FController, write=SetController};
	__property bool DisableThemes = {read=FDisableThemes, write=FDisableThemes, nodefault};
	__property System::Classes::TLeftRight TextAlignment = {read=FTextAlignment, write=FTextAlignment, default=0};
	__property bool AlwaysTransparent = {read=FAlwaysTransparent, write=FAlwaysTransparent, nodefault};
	__property Vcl::Wwframe::TwwEditFrame* Frame = {read=FFrame, write=FFrame};
	__property Vcl::Wwradiobutton::TwwWinButtonIndents* Indents = {read=FIndents, write=FIndents};
	__property bool DynamicCaption = {read=FDynamicCaption, write=FDynamicCaption, default=0};
	__property System::UnicodeString ValueChecked = {read=FValueChecked, write=SetValueChecked};
	__property System::UnicodeString ValueUnchecked = {read=FValueUnchecked, write=SetValueUnchecked};
	__property System::UnicodeString DisplayValueChecked = {read=GetDisplayValueChecked, write=SetDisplayValueChecked};
	__property System::UnicodeString DisplayValueUnchecked = {read=GetDisplayValueUnchecked, write=SetDisplayValueUnchecked};
	__property bool ShowFocusRect = {read=FShowFocusRect, write=FShowFocusRect, default=1};
	__property bool WordWrap = {read=FWordWrap, write=FWordWrap, default=0};
	__property Vcl::Stdctrls::TCheckBoxState NullAndBlankState = {read=FNullAndBlankState, write=FNullAndBlankState, nodefault};
	__property bool ShowText = {read=FShowText, write=FShowText, default=1};
	__property bool ShowAsButton = {read=FShowAsButton, write=FShowAsButton, default=0};
	__property bool ShowBoxAroundGlyph = {read=FShowBoxAroundGlyph, write=FShowBoxAroundGlyph, default=0};
	__property bool CenterTextVertically = {read=FCenterTextVertically, write=FCenterTextVertically, default=1};
	__property Action;
	__property Alignment = {default=1};
	__property AllowGrayed = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Caption = {default=0};
	__property Checked = {default=0};
	__property System::Uitypes::TColor Color = {read=GetColor, write=SetColor, stored=IsColorStored, nodefault};
	__property Constraints;
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragKind = {default=0};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property State = {default=0};
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property OnClick;
	__property OnContextPopup;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDock;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDock;
	__property OnStartDrag;
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwCustomCheckBox(HWND ParentWindow) : Vcl::Stdctrls::TCustomCheckBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwDBCustomCheckBox : public TwwCustomCheckBox
{
	typedef TwwCustomCheckBox inherited;
	
private:
	Vcl::Dbctrls::TFieldDataLink* FDataLink;
	System::UnicodeString __fastcall GetDataField(void);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	bool __fastcall GetReadOnly(void);
	void __fastcall SetDataField(const System::UnicodeString Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	void __fastcall SetReadOnly(bool Value);
	void __fastcall UpdateData(System::TObject* Sender);
	bool __fastcall ValueMatch(const System::UnicodeString ValueList, const System::UnicodeString Value);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	MESSAGE void __fastcall CMGetDataLink(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Message);
	
protected:
	bool __fastcall IsDataBound(void);
	virtual void __fastcall DataChange(System::TObject* Sender);
	virtual void __fastcall Toggle(void);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	virtual Data::Db::TField* __fastcall GetField(void);
	virtual Vcl::Stdctrls::TCheckBoxState __fastcall GetFieldState(void);
	
public:
	__fastcall virtual TwwDBCustomCheckBox(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDBCustomCheckBox(void);
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	DYNAMIC bool __fastcall UseRightToLeftAlignment(void);
	__property Data::Db::TField* Field = {read=GetField};
	__property Action;
	__property Alignment = {default=1};
	__property AllowGrayed = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Caption = {default=0};
	__property Checked = {default=0};
	__property Constraints;
	__property Ctl3D;
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property DragCursor = {default=-12};
	__property DragKind = {default=0};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property Images;
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property State = {default=0};
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property OnClick;
	__property OnContextPopup;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDock;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMouseEnter;
	__property OnMouseLeave;
	__property OnStartDock;
	__property OnStartDrag;
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, default=0};
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBCustomCheckBox(HWND ParentWindow) : TwwCustomCheckBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwCheckBox : public TwwDBCustomCheckBox
{
	typedef TwwDBCustomCheckBox inherited;
	
__published:
	__property Controller;
	__property DisableThemes;
	__property AlwaysTransparent;
	__property Frame;
	__property DynamicCaption = {default=0};
	__property ValueChecked = {default=0};
	__property ValueUnchecked = {default=0};
	__property DisplayValueChecked = {default=0};
	__property DisplayValueUnchecked = {default=0};
	__property ShowFocusRect = {default=1};
	__property NullAndBlankState;
	__property Indents;
	__property Action;
	__property Alignment = {default=1};
	__property AllowGrayed = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Caption = {default=0};
	__property Checked = {default=0};
	__property Color;
	__property Constraints;
	__property CenterTextVertically = {default=1};
	__property Ctl3D;
	__property DataField = {default=0};
	__property DataSource;
	__property DragCursor = {default=-12};
	__property DragKind = {default=0};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property Images;
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property ShowText = {default=1};
	__property State = {default=0};
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property OnClick;
	__property OnContextPopup;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDock;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMouseEnter;
	__property OnMouseLeave;
	__property OnStartDock;
	__property OnStartDrag;
	__property Align = {default=0};
	__property StyleElements = {default=7};
	__property DoubleBuffered;
	__property ParentDoubleBuffered = {default=1};
	__property ReadOnly = {default=0};
public:
	/* TwwDBCustomCheckBox.Create */ inline __fastcall virtual TwwCheckBox(System::Classes::TComponent* AOwner) : TwwDBCustomCheckBox(AOwner) { }
	/* TwwDBCustomCheckBox.Destroy */ inline __fastcall virtual ~TwwCheckBox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwCheckBox(HWND ParentWindow) : TwwDBCustomCheckBox(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwExpandGridIndents : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	Vcl::Controls::TWinControl* FWinControl;
	int FIndentX;
	int FIndentY;
	
public:
	__fastcall TwwExpandGridIndents(System::Classes::TComponent* AOwner);
	
__published:
	__property int X = {read=FIndentX, write=FIndentX, default=0};
	__property int Y = {read=FIndentY, write=FIndentY, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwExpandGridIndents(void) { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TwwCheckVisibleButton)(TwwExpandButton* Sender, Data::Db::TDataSet* DataSet, bool &AShowExpand);

class PASCALIMPLEMENTATION TwwExpandButton : public TwwDBCustomCheckBox
{
	typedef TwwDBCustomCheckBox inherited;
	
private:
	System::Classes::TAlignment FButtonAlignment;
	Vcl::Controls::TWinControl* FGrid;
	Vcl::Controls::TImageList* FExpandImages;
	bool FAutoShrink;
	System::Classes::TNotifyEvent FOnBeforeExpand;
	System::Classes::TNotifyEvent FOnBeforeCollapse;
	System::Classes::TNotifyEvent FOnAfterExpand;
	System::Classes::TNotifyEvent FOnAfterCollapse;
	bool FAutoHideExpand;
	bool InClickEvent;
	TwwExpandGridIndents* FGridIndents;
	TwwCheckVisibleButton FOnCheckVisibleButton;
	int BeforeExpandHeightOfParentGrid;
	int BeforeExpandRowHeight;
	HIDESBASE MESSAGE void __fastcall BMSetCheck(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMShowingChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	void __fastcall SetGrid(Vcl::Controls::TWinControl* Value);
	void __fastcall SetExpanded(bool val);
	bool __fastcall GetExpanded(void);
	
protected:
	int OriginalHeight;
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	virtual System::Classes::TAlignment __fastcall GetAlignment(void);
	virtual System::UnicodeString __fastcall GetDisplayText(void);
	virtual int __fastcall GetExtraIndentX(void);
	virtual Vcl::Controls::TImageList* __fastcall GetImageList(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Toggle(void);
	virtual void __fastcall DataChange(System::TObject* Sender);
	virtual Vcl::Stdctrls::TCheckBoxState __fastcall GetFieldState(void);
	virtual bool __fastcall FillBackground(void);
	virtual void __fastcall DoBeforeExpand(void);
	virtual void __fastcall DoBeforeCollapse(void);
	virtual void __fastcall DoAfterExpand(void);
	virtual void __fastcall DoAfterCollapse(void);
	virtual bool __fastcall HideExpand(void);
	virtual int __fastcall GetDrawFlags(void);
	
public:
	bool PaintAsExpanded;
	int DesiredRow;
	int ExpandedGridRow;
	bool InRefreshCalcField;
	bool InToggle;
	__fastcall virtual TwwExpandButton(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwExpandButton(void);
	void __fastcall ResetHeight(void);
	DYNAMIC void __fastcall Click(void);
	__property bool Expanded = {read=GetExpanded, write=SetExpanded, nodefault};
	void __fastcall RefreshCalcField(void);
	void __fastcall ExpandAfterDelay(void);
	
__published:
	__property DisableThemes;
	__property Vcl::Controls::TWinControl* Grid = {read=FGrid, write=SetGrid};
	__property bool AutoShrink = {read=FAutoShrink, write=FAutoShrink, default=1};
	__property TextAlignment = {default=0};
	__property bool AutoHideExpand = {read=FAutoHideExpand, write=FAutoHideExpand, default=0};
	__property ShowFocusRect = {default=1};
	__property System::Classes::TNotifyEvent OnBeforeExpand = {read=FOnBeforeExpand, write=FOnBeforeExpand};
	__property System::Classes::TNotifyEvent OnBeforeCollapse = {read=FOnBeforeCollapse, write=FOnBeforeCollapse};
	__property System::Classes::TNotifyEvent OnAfterExpand = {read=FOnAfterExpand, write=FOnAfterExpand};
	__property System::Classes::TNotifyEvent OnAfterCollapse = {read=FOnAfterCollapse, write=FOnAfterCollapse};
	__property TwwCheckVisibleButton OnCheckVisibleButton = {read=FOnCheckVisibleButton, write=FOnCheckVisibleButton};
	__property TwwExpandGridIndents* GridIndents = {read=FGridIndents, write=FGridIndents};
	__property BiDiMode;
	__property Caption = {default=0};
	__property Color;
	__property Constraints;
	__property DataField = {default=0};
	__property DataSource;
	__property Enabled = {default=1};
	__property Font;
	__property Images;
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=1};
	__property Indents;
	__property ShowAsButton = {default=0};
	__property ShowText = {default=0};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property System::Classes::TAlignment ButtonAlignment = {read=FButtonAlignment, write=FButtonAlignment, default=0};
	__property OnContextPopup;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnMouseEnter;
	__property OnMouseLeave;
	__property Align = {default=0};
	__property StyleElements = {default=7};
	__property DoubleBuffered;
	__property ParentDoubleBuffered = {default=1};
	__property ReadOnly = {default=0};
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwExpandButton(HWND ParentWindow) : TwwDBCustomCheckBox(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwcheckbox */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWCHECKBOX)
using namespace Vcl::Wwcheckbox;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwcheckboxHPP
