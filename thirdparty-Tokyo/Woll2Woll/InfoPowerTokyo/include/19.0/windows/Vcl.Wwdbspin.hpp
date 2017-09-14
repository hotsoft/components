// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwdbspin.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwdbspinHPP
#define Vcl_WwdbspinHPP

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
#include <Data.DB.hpp>
#include <vcl.Wwdbedit.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.wwspin.hpp>
#include <vcl.wwframe.hpp>
#include <vcl.wwtypes.hpp>
#include <Vcl.Themes.hpp>
#include <vcl.wwintl.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwdbspin
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwDBSpinEdit;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwDBSpinEdit : public Vcl::Wwdbedit::TwwDBCustomEdit
{
	typedef Vcl::Wwdbedit::TwwDBCustomEdit inherited;
	
private:
	// __classmethod void __fastcall Create@();
	
private:
	double FMinValue;
	double FMaxValue;
	double FIncrement;
	Vcl::Wwspin::TwwSpinButton* FButton;
	bool FEditorEnabled;
	Vcl::Wwframe::TwwButtonEffects* FButtonEffects;
	bool FLimitEditRect;
	System::Classes::TNotifyEvent FBeforeUpClick;
	System::Classes::TNotifyEvent FBeforeDownClick;
	System::Classes::TNotifyEvent FAfterUpClick;
	System::Classes::TNotifyEvent FAfterDownClick;
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Message);
	HIDESBASE MESSAGE void __fastcall WMPaste(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMCut(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	double __fastcall GetValue(void);
	double __fastcall CheckValue(double NewValue);
	void __fastcall SetValue(double NewValue);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TMessage &Message);
	
protected:
	virtual void __fastcall SetDisplayFormat(System::UnicodeString val);
	virtual bool __fastcall IsValidChar(System::WideChar Key);
	DYNAMIC void __fastcall UpClick(System::TObject* Sender);
	DYNAMIC void __fastcall DownClick(System::TObject* Sender);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	DYNAMIC int __fastcall GetIconIndent(void);
	DYNAMIC int __fastcall GetIconLeft(void);
	virtual bool __fastcall GetShowButton(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall SetEditRect(void);
	
public:
	bool SkipUpdate;
	__fastcall virtual TwwDBSpinEdit(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDBSpinEdit(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	__property bool HasFocus = {read=FFocused, nodefault};
	
__published:
	__property Controller;
	__property DisableThemes = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Constraints;
	__property EditAlignment = {default=0};
	__property bool EditorEnabled = {read=FEditorEnabled, write=FEditorEnabled, default=1};
	__property double Increment = {read=FIncrement, write=FIncrement};
	__property double MaxValue = {read=FMaxValue, write=FMaxValue};
	__property double MinValue = {read=FMinValue, write=FMinValue};
	__property double Value = {read=GetValue, write=SetValue};
	__property AutoFillDate = {default=1};
	__property AutoSelect = {default=1};
	__property AutoSize = {default=1};
	__property BorderStyle = {default=1};
	__property CharCase = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property DataField = {default=0};
	__property DataSource;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Vcl::Wwframe::TwwButtonEffects* ButtonEffects = {read=FButtonEffects, write=FButtonEffects};
	__property Font;
	__property Frame;
	__property bool LimitEditRect = {read=FLimitEditRect, write=FLimitEditRect, default=0};
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property MaxLength = {default=0};
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property Picture;
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property UnboundDataType;
	__property UsePictureMask = {default=1};
	__property Visible = {default=1};
	__property Touch;
	__property Align = {default=0};
	__property StyleElements = {default=7};
	__property OEMConvert = {default=0};
	__property NumbersOnly = {default=0};
	__property DoubleBuffered;
	__property ParentDoubleBuffered = {default=1};
	__property OnChange;
	__property OnCheckValue;
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
	__property OnGesture;
	__property System::Classes::TNotifyEvent AfterUpClick = {read=FAfterUpClick, write=FAfterUpClick};
	__property System::Classes::TNotifyEvent AfterDownClick = {read=FAfterDownClick, write=FAfterDownClick};
	__property System::Classes::TNotifyEvent BeforeUpClick = {read=FBeforeUpClick, write=FBeforeUpClick};
	__property System::Classes::TNotifyEvent BeforeDownClick = {read=FBeforeDownClick, write=FBeforeDownClick};
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBSpinEdit(HWND ParentWindow) : Vcl::Wwdbedit::TwwDBCustomEdit(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwdbspin */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWDBSPIN)
using namespace Vcl::Wwdbspin;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwdbspinHPP
