// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwcombobutton.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwcombobuttonHPP
#define Vcl_WwcombobuttonHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Winapi.CommCtrl.hpp>
#include <Vcl.Buttons.hpp>
#include <System.ImageList.hpp>
#include <System.Actions.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.ImgList.hpp>
#include <System.Types.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwcombobutton
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwComboButtonActionLink;
class DELPHICLASS TwwComboButton;
class DELPHICLASS TwwSpinControlButton;
class DELPHICLASS TGlyphList;
class DELPHICLASS TwwComboButtonGlyph;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwComboButtonActionLink : public Vcl::Controls::TControlActionLink
{
	typedef Vcl::Controls::TControlActionLink inherited;
	
protected:
	Vcl::Buttons::TSpeedButton* FClient;
	virtual void __fastcall AssignClient(System::TObject* AClient);
	virtual bool __fastcall IsCheckedLinked(void);
	virtual bool __fastcall IsGroupIndexLinked(void);
	virtual void __fastcall SetGroupIndex(int Value);
	virtual void __fastcall SetChecked(bool Value);
public:
	/* TBasicActionLink.Create */ inline __fastcall virtual TwwComboButtonActionLink(System::TObject* AClient) : Vcl::Controls::TControlActionLink(AClient) { }
	/* TBasicActionLink.Destroy */ inline __fastcall virtual ~TwwComboButtonActionLink(void) { }
	
};


class PASCALIMPLEMENTATION TwwComboButton : public Vcl::Controls::TGraphicControl
{
	typedef Vcl::Controls::TGraphicControl inherited;
	
private:
	int FGroupIndex;
	bool FDown;
	bool FDragging;
	bool FAllowAllUp;
	Vcl::Buttons::TButtonLayout FLayout;
	int FSpacing;
	bool FTransparent;
	int FMargin;
	bool FFlat;
	bool FMouseInControl;
	bool FEllipsis;
	bool FVisibleInGridRows;
	void __fastcall GlyphChanged(System::TObject* Sender);
	void __fastcall UpdateExclusive(void);
	Vcl::Graphics::TBitmap* __fastcall GetGlyph(void);
	void __fastcall SetGlyph(Vcl::Graphics::TBitmap* Value);
	Vcl::Buttons::TNumGlyphs __fastcall GetNumGlyphs(void);
	void __fastcall SetNumGlyphs(Vcl::Buttons::TNumGlyphs Value);
	void __fastcall SetDown(bool Value);
	void __fastcall SetFlat(bool Value);
	void __fastcall SetAllowAllUp(bool Value);
	void __fastcall SetGroupIndex(int Value);
	void __fastcall SetLayout(Vcl::Buttons::TButtonLayout Value);
	void __fastcall SetSpacing(int Value);
	void __fastcall SetTransparent(bool Value);
	void __fastcall SetMargin(int Value);
	void __fastcall UpdateTracking(void);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall CMEnabledChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMButtonPressed(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMDialogChar(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMTextChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMSysColorChange(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	
protected:
	void *FGlyph;
	Vcl::Buttons::TButtonState FState;
	DYNAMIC void __fastcall ActionChange(System::TObject* Sender, bool CheckDefaults);
	DYNAMIC Vcl::Controls::TControlActionLinkClass __fastcall GetActionLinkClass(void);
	DYNAMIC HPALETTE __fastcall GetPalette(void);
	virtual void __fastcall Loaded(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
	virtual bool __fastcall IsVistaComboNonEditable(void);
	virtual bool __fastcall IsVistaTransparentButton(void);
	virtual bool __fastcall ParentMouseInControl(void);
	virtual bool __fastcall ParentDroppedDown(void);
	__property bool MouseInControl = {read=FMouseInControl, nodefault};
	__property bool Ellipsis = {read=FEllipsis, write=FEllipsis, nodefault};
	
public:
	__fastcall virtual TwwComboButton(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwComboButton(void);
	DYNAMIC void __fastcall Click(void);
	
__published:
	__property Action;
	__property bool AllowAllUp = {read=FAllowAllUp, write=SetAllowAllUp, default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Constraints;
	__property int GroupIndex = {read=FGroupIndex, write=SetGroupIndex, default=0};
	__property bool Down = {read=FDown, write=SetDown, default=0};
	__property Caption = {default=0};
	__property Enabled = {default=1};
	__property bool Flat = {read=FFlat, write=SetFlat, default=0};
	__property Font;
	__property Vcl::Graphics::TBitmap* Glyph = {read=GetGlyph, write=SetGlyph};
	__property Vcl::Buttons::TButtonLayout Layout = {read=FLayout, write=SetLayout, default=0};
	__property int Margin = {read=FMargin, write=SetMargin, default=-1};
	__property Vcl::Buttons::TNumGlyphs NumGlyphs = {read=GetNumGlyphs, write=SetNumGlyphs, default=1};
	__property bool VisibleInGridRows = {read=FVisibleInGridRows, write=FVisibleInGridRows, default=0};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property ParentBiDiMode = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property int Spacing = {read=FSpacing, write=SetSpacing, default=4};
	__property bool Transparent = {read=FTransparent, write=SetTransparent, default=1};
	__property Visible = {default=1};
	__property OnClick;
	__property OnDblClick;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
};


enum DECLSPEC_DENUM TwwSpinButtonDirection : unsigned char { wwsdUp, wwsdDown };

class PASCALIMPLEMENTATION TwwSpinControlButton : public TwwComboButton
{
	typedef TwwComboButton inherited;
	
private:
	TwwSpinButtonDirection FScrollDirection;
	
protected:
	virtual void __fastcall Paint(void);
	__property TwwSpinButtonDirection ScrollDirection = {read=FScrollDirection, write=FScrollDirection, nodefault};
public:
	/* TwwComboButton.Create */ inline __fastcall virtual TwwSpinControlButton(System::Classes::TComponent* AOwner) : TwwComboButton(AOwner) { }
	/* TwwComboButton.Destroy */ inline __fastcall virtual ~TwwSpinControlButton(void) { }
	
};


class PASCALIMPLEMENTATION TGlyphList : public Vcl::Controls::TImageList
{
	typedef Vcl::Controls::TImageList inherited;
	
private:
	System::Classes::TBits* Used;
	int FCount;
	int __fastcall AllocateIndex(void);
	
public:
	__fastcall TGlyphList(int AWidth, int AHeight);
	__fastcall virtual ~TGlyphList(void);
	HIDESBASE int __fastcall AddMasked(Vcl::Graphics::TBitmap* Image, System::Uitypes::TColor MaskColor);
	HIDESBASE void __fastcall Delete(int Index);
	__property int Count = {read=FCount, nodefault};
public:
	/* TCustomImageList.Create */ inline __fastcall virtual TGlyphList(System::Classes::TComponent* AOwner) : Vcl::Controls::TImageList(AOwner) { }
	
};


class PASCALIMPLEMENTATION TwwComboButtonGlyph : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	Vcl::Graphics::TBitmap* FOriginal;
	TGlyphList* FGlyphList;
	System::StaticArray<int, 4> FIndexs;
	System::Uitypes::TColor FTransparentColor;
	Vcl::Buttons::TNumGlyphs FNumGlyphs;
	System::Classes::TNotifyEvent FOnChange;
	Vcl::Controls::TControl* FComboButton;
	void __fastcall GlyphChanged(System::TObject* Sender);
	void __fastcall SetGlyph(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetNumGlyphs(Vcl::Buttons::TNumGlyphs Value);
	void __fastcall Invalidate(void);
	int __fastcall CreateButtonGlyph(Vcl::Buttons::TButtonState State);
	void __fastcall DrawButtonGlyph(Vcl::Graphics::TCanvas* Canvas, const System::Types::TPoint &GlyphPos, Vcl::Buttons::TButtonState State, bool Transparent);
	void __fastcall DrawButtonText(Vcl::Graphics::TCanvas* Canvas, const System::UnicodeString Caption, const System::Types::TRect &TextBounds, Vcl::Buttons::TButtonState State, int BiDiFlags);
	void __fastcall CalcButtonLayout(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &Client, const System::Types::TPoint &Offset, const System::UnicodeString Caption, Vcl::Buttons::TButtonLayout Layout, int Margin, int Spacing, System::Types::TPoint &GlyphPos, System::Types::TRect &TextBounds, int BiDiFlags);
	
public:
	__property Vcl::Controls::TControl* ComboButton = {read=FComboButton};
	__fastcall TwwComboButtonGlyph(Vcl::Controls::TControl* AComboButton);
	__fastcall virtual ~TwwComboButtonGlyph(void);
	System::Types::TRect __fastcall Draw(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &Client, const System::Types::TPoint &Offset, const System::UnicodeString Caption, Vcl::Buttons::TButtonLayout Layout, int Margin, int Spacing, Vcl::Buttons::TButtonState State, bool Transparent, int BiDiFlags);
	__property Vcl::Graphics::TBitmap* Glyph = {read=FOriginal, write=SetGlyph};
	__property Vcl::Buttons::TNumGlyphs NumGlyphs = {read=FNumGlyphs, write=SetNumGlyphs, nodefault};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwcombobutton */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWCOMBOBUTTON)
using namespace Vcl::Wwcombobutton;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwcombobuttonHPP
