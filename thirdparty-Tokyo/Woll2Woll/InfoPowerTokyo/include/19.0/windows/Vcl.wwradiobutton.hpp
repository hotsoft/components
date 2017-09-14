// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwradiobutton.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwradiobuttonHPP
#define Vcl_WwradiobuttonHPP

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
#include <Vcl.Grids.hpp>
#include <vcl.Wwcommon.hpp>
#include <Vcl.ImgList.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwradiobutton
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwWinButtonIndents;
class DELPHICLASS TwwCustomRadioButton;
class DELPHICLASS TwwRadioButton;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwWinButtonIndents : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	Vcl::Controls::TWinControl* FWinControl;
	int FIndentBX;
	int FIndentBY;
	int FIndentTX;
	int FIndentTY;
	void __fastcall SetIndentBX(int Value);
	void __fastcall SetIndentBY(int Value);
	void __fastcall SetIndentTX(int Value);
	void __fastcall SetIndentTY(int Value);
	
protected:
	virtual void __fastcall Repaint(Vcl::Controls::TWinControl* FWinControl);
	
public:
	__fastcall TwwWinButtonIndents(System::Classes::TComponent* AOwner);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property int ButtonX = {read=FIndentBX, write=SetIndentBX, default=0};
	__property int ButtonY = {read=FIndentBY, write=SetIndentBY, default=0};
	__property int TextX = {read=FIndentTX, write=SetIndentTX, default=0};
	__property int TextY = {read=FIndentTY, write=SetIndentTY, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwWinButtonIndents(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TwwTransparentRegion : unsigned char { wwtrBorder, wwtrText, wwtrIcon };

typedef System::Set<TwwTransparentRegion, TwwTransparentRegion::wwtrBorder, TwwTransparentRegion::wwtrIcon> TwwTransparentRegions;

class PASCALIMPLEMENTATION TwwCustomRadioButton : public Vcl::Stdctrls::TRadioButton
{
	typedef Vcl::Stdctrls::TRadioButton inherited;
	
private:
	Vcl::Controls::TControlCanvas* FCanvas;
	Vcl::Wwframe::TwwEditFrame* FFrame;
	TwwWinButtonIndents* FIndents;
	bool FAlwaysTransparent;
	System::UnicodeString FValueChecked;
	System::UnicodeString FValueUnchecked;
	bool FShowFocusRect;
	bool SpaceKeyPressed;
	Vcl::Imglist::TCustomImageList* FImages;
	Vcl::Imglist::TCustomImageList* FGlyphImages;
	bool FWordWrap;
	System::Classes::TNotifyEvent FOnMouseEnter;
	System::Classes::TNotifyEvent FOnMouseLeave;
	bool __fastcall isTransparentEffective(void);
	HIDESBASE MESSAGE void __fastcall CNKeyDown(Winapi::Messages::TWMKey &Message);
	MESSAGE void __fastcall CNDrawItem(Winapi::Messages::TWMDrawItem &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	virtual void __fastcall DrawItem(const tagDRAWITEMSTRUCT &DrawItemStruct);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Message);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Message);
	MESSAGE void __fastcall BMSetCheck(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMMouseMove(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall CMTextChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	HIDESBASE MESSAGE void __fastcall CNCommand(Winapi::Messages::TWMCommand &Message);
	HIDESBASE MESSAGE void __fastcall CMDialogChar(Winapi::Messages::TWMKey &Message);
	bool __fastcall IsMouseInControl(void);
	
protected:
	virtual bool __fastcall GetShowText(void);
	void __fastcall TransparentInvalidate(TwwTransparentRegions Regions);
	virtual System::Uitypes::TColor __fastcall GetPaintCopyTextColor(void);
	virtual System::Uitypes::TColor __fastcall GetLastBrushColor(void);
	virtual int __fastcall GetButtonIndex(void);
	virtual bool __fastcall GetEffectiveChecked(void);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall Paint(void);
	void __fastcall PaintBorder(void);
	DYNAMIC void __fastcall KeyUp(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall ComputeImageRect(System::Types::TRect &DrawRect);
	virtual void __fastcall ComputeTextRect(System::Types::TRect &DrawRect);
	virtual void __fastcall ComputeGlyphRect(System::Types::TRect &DrawRect);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual Vcl::Graphics::TCanvas* __fastcall GetCanvas(void);
	virtual void __fastcall DoMouseEnter(void);
	virtual void __fastcall DoMouseLeave(void);
	virtual void __fastcall SetChecked(bool Value);
	
public:
	__fastcall virtual ~TwwCustomRadioButton(void);
	__fastcall virtual TwwCustomRadioButton(System::Classes::TComponent* AOwner);
	__property Vcl::Graphics::TCanvas* Canvas = {read=GetCanvas};
	__property Vcl::Wwframe::TwwEditFrame* Frame = {read=FFrame, write=FFrame};
	
__published:
	__property bool AlwaysTransparent = {read=FAlwaysTransparent, write=FAlwaysTransparent, nodefault};
	__property TwwWinButtonIndents* Indents = {read=FIndents, write=FIndents};
	__property System::UnicodeString ValueChecked = {read=FValueChecked, write=FValueChecked};
	__property System::UnicodeString ValueUnchecked = {read=FValueUnchecked, write=FValueUnchecked};
	__property bool ShowFocusRect = {read=FShowFocusRect, write=FShowFocusRect, default=1};
	__property Vcl::Imglist::TCustomImageList* Images = {read=FImages, write=FImages};
	__property Vcl::Imglist::TCustomImageList* GlyphImages = {read=FGlyphImages, write=FGlyphImages};
	__property Action;
	__property Alignment = {default=1};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Caption = {default=0};
	__property Checked = {default=0};
	__property Color = {default=-16777211};
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
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property Visible = {default=1};
	__property bool WordWrap = {read=FWordWrap, write=FWordWrap, default=0};
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
	__property System::Classes::TNotifyEvent OnMouseEnter = {read=FOnMouseEnter, write=FOnMouseEnter};
	__property System::Classes::TNotifyEvent OnMouseLeave = {read=FOnMouseLeave, write=FOnMouseLeave};
	__property OnStartDock;
	__property OnStartDrag;
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwCustomRadioButton(HWND ParentWindow) : Vcl::Stdctrls::TRadioButton(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwRadioButton : public TwwCustomRadioButton
{
	typedef TwwCustomRadioButton inherited;
	
__published:
	__property Action;
	__property Alignment = {default=1};
	__property AlwaysTransparent;
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Caption = {default=0};
	__property Checked = {default=0};
	__property Color = {default=-16777211};
	__property Constraints;
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragKind = {default=0};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property Frame;
	__property Images;
	__property Indents;
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=1};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property ShowFocusRect = {default=1};
	__property TabOrder = {default=-1};
	__property TabStop = {default=0};
	__property ValueChecked = {default=0};
	__property ValueUnchecked = {default=0};
	__property Visible = {default=1};
	__property WordWrap = {default=0};
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
public:
	/* TwwCustomRadioButton.Destroy */ inline __fastcall virtual ~TwwRadioButton(void) { }
	/* TwwCustomRadioButton.Create */ inline __fastcall virtual TwwRadioButton(System::Classes::TComponent* AOwner) : TwwCustomRadioButton(AOwner) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwRadioButton(HWND ParentWindow) : TwwCustomRadioButton(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwradiobutton */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWRADIOBUTTON)
using namespace Vcl::Wwradiobutton;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwradiobuttonHPP
