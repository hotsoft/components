// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwdotdot.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwdotdotHPP
#define Vcl_WwdotdotHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Vcl.Forms.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.DBCtrls.hpp>
#include <Vcl.Mask.hpp>
#include <Data.DB.hpp>
#include <Vcl.StdCtrls.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.wwdblook.hpp>
#include <vcl.wwframe.hpp>
#include <vcl.wwcombobutton.hpp>
#include <vcl.wwintl.hpp>
#include <System.UITypes.hpp>
#include <vcl.wwtypes.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwdotdot
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwDBCustomCombo;
class DELPHICLASS TwwDBComboDlg;
class DELPHICLASS TwwComboDlgButton;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TwwHandleDropDownKeys)(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);

class PASCALIMPLEMENTATION TwwDBCustomCombo : public Vcl::Wwdbedit::TwwDBCustomEdit
{
	typedef Vcl::Wwdbedit::TwwDBCustomEdit inherited;
	
private:
	Vcl::Controls::TWinControl* FBtnControl;
	Vcl::Wwcombobutton::TwwComboButton* FButton;
	System::Classes::TNotifyEvent FOnCustomDlg;
	Vcl::Wwdblook::TwwDBLookupComboStyle FStyle;
	Vcl::Wwframe::TwwComboButtonStyle FButtonStyle;
	bool FDroppedDown;
	bool FMouseInButtonControl;
	bool FLimitEditRect;
	Vcl::Wwframe::TwwButtonEffects* FButtonEffects;
	int FButtonWidth;
	bool SkipUpdate;
	bool FAutoEnableEdit;
	TwwHandleDropDownKeys FOnHandleDropDownKeys;
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall CMEnabledChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Message);
	void __fastcall SetButtonGlyph(Vcl::Graphics::TBitmap* Value);
	Vcl::Graphics::TBitmap* __fastcall GetButtonGlyph(void);
	void __fastcall NonEditMouseDown(Winapi::Messages::TWMMouse &Message);
	void __fastcall SetButtonStyle(Vcl::Wwframe::TwwComboButtonStyle val);
	void __fastcall UpdateButtonPosition(void);
	void __fastcall SetButtonWidth(int val);
	int __fastcall GetButtonWidth(void);
	
protected:
	virtual bool __fastcall IsVistaComboNonEditable(void);
	virtual bool __fastcall IsCustom(void);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	void __fastcall UpdateButtonGlyph(void);
	virtual void __fastcall DrawButton(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &R, Vcl::Buttons::TButtonState State, Vcl::Controls::TControlState ControlState, bool &DefaultPaint);
	virtual void __fastcall SetEditRect(void);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &msg);
	void __fastcall BtnClick(System::TObject* sender);
	void __fastcall BtnMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual bool __fastcall GetShowButton(void);
	virtual void __fastcall SetShowButton(bool sel);
	DYNAMIC int __fastcall GetIconIndent(void);
	DYNAMIC int __fastcall GetIconLeft(void);
	virtual bool __fastcall Editable(void);
	virtual bool __fastcall IsDroppedDown(void);
	virtual void __fastcall CloseUp(bool Accept);
	void __fastcall HandleDropDownKeys(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall Loaded(void);
	void __fastcall InvalidateTransparentButton(void);
	virtual bool __fastcall MouseEditable(void);
	__property Vcl::Controls::TWinControl* BtnControl = {read=FBtnControl};
	
public:
	__fastcall virtual TwwDBCustomCombo(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDBCustomCombo(void);
	virtual void __fastcall DropDown(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	__property bool AutoEnableEdit = {read=FAutoEnableEdit, write=FAutoEnableEdit, default=1};
	__property Vcl::Wwcombobutton::TwwComboButton* Button = {read=FButton};
	__property System::Classes::TNotifyEvent OnCustomDlg = {read=FOnCustomDlg, write=FOnCustomDlg};
	__property Vcl::Wwdblook::TwwDBLookupComboStyle Style = {read=FStyle, write=FStyle, nodefault};
	__property Vcl::Wwframe::TwwComboButtonStyle ButtonStyle = {read=FButtonStyle, write=SetButtonStyle, nodefault};
	__property Vcl::Wwframe::TwwButtonEffects* ButtonEffects = {read=FButtonEffects, write=FButtonEffects};
	__property bool LimitEditRect = {read=FLimitEditRect, write=FLimitEditRect, default=0};
	__property Vcl::Graphics::TBitmap* ButtonGlyph = {read=GetButtonGlyph, write=SetButtonGlyph, stored=IsCustom};
	__property int ButtonWidth = {read=GetButtonWidth, write=SetButtonWidth, default=0};
	__property TwwHandleDropDownKeys OnHandleDropDownKeys = {read=FOnHandleDropDownKeys, write=FOnHandleDropDownKeys};
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBCustomCombo(HWND ParentWindow) : Vcl::Wwdbedit::TwwDBCustomEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwDBComboDlg : public TwwDBCustomCombo
{
	typedef TwwDBCustomCombo inherited;
	
private:
	// __classmethod void __fastcall Create@();
	
__published:
	__property BevelEdges = {default=15};
	__property BevelInner = {index=0, default=2};
	__property BevelKind = {default=0};
	__property BevelOuter = {index=1, default=1};
	__property Controller;
	__property DisableThemes = {default=0};
	__property OnCustomDlg;
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Constraints;
	__property ParentBiDiMode = {default=1};
	__property AutoEnableEdit = {default=1};
	__property ShowButton;
	__property Style;
	__property ButtonStyle = {default=0};
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
	__property ButtonEffects;
	__property Frame;
	__property ButtonWidth = {default=0};
	__property ButtonGlyph;
	__property Font;
	__property EditAlignment = {default=0};
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property LimitEditRect = {default=0};
	__property MaxLength = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PasswordChar = {default=0};
	__property Picture;
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property WordWrap;
	__property UnboundDataType;
	__property UsePictureMask = {default=1};
	__property Visible = {default=1};
	__property UnboundAlignment = {default=0};
	__property Touch;
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
	__property Align = {default=0};
	__property StyleElements = {default=7};
	__property OEMConvert = {default=0};
	__property NumbersOnly = {default=0};
	__property DoubleBuffered;
	__property ParentDoubleBuffered = {default=1};
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TwwDBCustomCombo.Create */ inline __fastcall virtual TwwDBComboDlg(System::Classes::TComponent* AOwner) : TwwDBCustomCombo(AOwner) { }
	/* TwwDBCustomCombo.Destroy */ inline __fastcall virtual ~TwwDBComboDlg(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBComboDlg(HWND ParentWindow) : TwwDBCustomCombo(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwComboDlgButton : public Vcl::Wwcombobutton::TwwComboButton
{
	typedef Vcl::Wwcombobutton::TwwComboButton inherited;
	
protected:
	virtual void __fastcall Paint(void);
	virtual bool __fastcall IsVistaTransparentButton(void);
	virtual bool __fastcall IsVistaComboNonEditable(void);
	virtual bool __fastcall ParentMouseInControl(void);
	virtual bool __fastcall ParentDroppedDown(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
public:
	/* TwwComboButton.Create */ inline __fastcall virtual TwwComboDlgButton(System::Classes::TComponent* AOwner) : Vcl::Wwcombobutton::TwwComboButton(AOwner) { }
	/* TwwComboButton.Destroy */ inline __fastcall virtual ~TwwComboDlgButton(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwdotdot */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWDOTDOT)
using namespace Vcl::Wwdotdot;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwdotdotHPP
