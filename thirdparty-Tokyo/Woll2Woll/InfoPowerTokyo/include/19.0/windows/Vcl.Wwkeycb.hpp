// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwkeycb.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwkeycbHPP
#define Vcl_WwkeycbHPP

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
#include <Vcl.StdCtrls.hpp>
#include <Data.DB.hpp>
#include <vcl.Wwstr.hpp>
#include <Vcl.Dialogs.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.Wwsystem.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Menus.hpp>
#include <vcl.wwtypes.hpp>
#include <vcl.wwpict.hpp>
#include <vcl.wwframe.hpp>
#include <vcl.Wwdbcomb.hpp>
#include <vcl.wwintl.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <vcl.Wwdbedit.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.Wwdotdot.hpp>
#include <System.MaskUtils.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwkeycb
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwKeyCombo;
class DELPHICLASS TwwIncrementalSearch;
class DELPHICLASS TwwKeyDataLink;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TwwAfterSearchEvent)(TwwIncrementalSearch* Sender, bool MatchFound);

typedef void __fastcall (__closure *TwwKeyComboCloseUpEvent)(TwwKeyCombo* Sender, bool Select);

class PASCALIMPLEMENTATION TwwKeyCombo : public Vcl::Wwdbcomb::TwwDBCustomComboBox
{
	typedef Vcl::Wwdbcomb::TwwDBCustomComboBox inherited;
	
private:
	TwwKeyDataLink* FDataLink;
	bool FShowAllIndexes;
	System::UnicodeString FPrimaryKeyName;
	bool skipReload;
	bool FShowAllFields;
	TwwKeyComboCloseUpEvent FOnCloseUp;
	
protected:
	virtual void __fastcall CloseUp(bool Accept);
	DYNAMIC void __fastcall Change(void);
	HIDESBASE void __fastcall SetDataSource(Data::Db::TDataSource* value);
	HIDESBASE Data::Db::TDataSource* __fastcall GetDataSource(void);
	System::UnicodeString __fastcall GetPrimaryName(void);
	void __fastcall SetShowAllIndexes(bool value);
	void __fastcall SetShowAllFields(bool value);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	System::Variant Patch;
	__fastcall virtual TwwKeyCombo(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwKeyCombo(void);
	void __fastcall LinkActive(bool active);
	virtual void __fastcall DataChanged(void);
	void __fastcall InitCombo(void);
	void __fastcall InitComboWithGrid(System::Classes::TComponent* grid);
	void __fastcall RefreshDisplay(void);
	virtual void __fastcall DropDown(void);
	virtual bool __fastcall UseAllFields(Data::Db::TDataSet* value);
	__property bool ShowAllFields = {read=FShowAllFields, write=SetShowAllFields, nodefault};
	
__published:
	__property Controller;
	__property DisableThemes = {default=0};
	__property Anchors = {default=3};
	__property Constraints;
	__property Style;
	__property AutoSize = {default=1};
	__property BorderStyle = {default=1};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property DragMode = {default=0};
	__property DragCursor = {default=-12};
	__property DropDownCount;
	__property Enabled = {default=1};
	__property Font;
	__property ItemHeight;
	__property MaxLength = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property Sorted;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Text;
	__property Visible = {default=1};
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDrawItem;
	__property OnDropDown;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMeasureItem;
	__property bool ShowAllIndexes = {read=FShowAllIndexes, write=SetShowAllIndexes, nodefault};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property System::UnicodeString PrimaryKeyName = {read=FPrimaryKeyName, write=FPrimaryKeyName};
	__property ButtonEffects;
	__property Frame;
	__property ButtonWidth = {default=0};
	__property ButtonGlyph;
	__property ButtonStyle = {default=1};
	__property TwwKeyComboCloseUpEvent OnCloseUp = {read=FOnCloseUp, write=FOnCloseUp};
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwKeyCombo(HWND ParentWindow) : Vcl::Wwdbcomb::TwwDBCustomComboBox(ParentWindow) { }
	
};


enum DECLSPEC_DENUM TwwSearchCaseSensitivity : unsigned char { wwcsAutoDetect, wwcsCaseSensitive, wwcsCaseInsensitive };

class PASCALIMPLEMENTATION TwwIncrementalSearch : public Vcl::Stdctrls::TCustomEdit
{
	typedef Vcl::Stdctrls::TCustomEdit inherited;
	
private:
	Data::Db::TDataLink* FDataLink;
	int FTimerInterval;
	Vcl::Extctrls::TTimer* FTimer;
	TwwAfterSearchEvent FOnAfterSearch;
	bool FShowMatchText;
	System::UnicodeString LastValue;
	int FieldNo;
	System::UnicodeString FSearchField;
	System::UnicodeString FPictureMask;
	bool FPictureMaskAutoFill;
	bool FPictureMaskFromField;
	Vcl::Wwframe::TwwEditFrame* FFrame;
	bool FFocused;
	Vcl::Controls::TControlCanvas* FCanvas;
	int FSearchDelay;
	TwwSearchCaseSensitivity FCaseSensitivity;
	Vcl::Wwtypes::TwwPerformSearchEvent FOnPerformCustomSearch;
	Vcl::Wwintl::TwwController* FController;
	bool FDisableThemes;
	bool __fastcall isTransparentEffective(void);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall CNKeyDown(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall WMSetFont(Winapi::Messages::TWMSetFont &Message);
	void __fastcall SetController(Vcl::Wwintl::TwwController* Value);
	
protected:
	void __fastcall SetDataSource(Data::Db::TDataSource* value);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	System::UnicodeString __fastcall FindSearchField(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall SetEditRect(void);
	virtual void __fastcall PerformCustomSearch(System::UnicodeString SearchField, System::UnicodeString SearchValue, bool PerformLookup, bool &Found);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	
public:
	System::Variant Patch;
	__property Vcl::Extctrls::TTimer* DelayTimer = {read=FTimer};
	__fastcall virtual TwwIncrementalSearch(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwIncrementalSearch(void);
	void __fastcall FindValue(void);
	void __fastcall OnEditTimerEvent(System::TObject* Sender);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall KeyUp(System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall SetSearchField(System::UnicodeString ASearchField);
	virtual void __fastcall Clear(void);
	
__published:
	__property Vcl::Wwintl::TwwController* Controller = {read=FController, write=SetController};
	__property bool DisableThemes = {read=FDisableThemes, write=FDisableThemes, default=0};
	__property Anchors = {default=3};
	__property Constraints;
	__property Vcl::Wwframe::TwwEditFrame* Frame = {read=FFrame, write=FFrame};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property System::UnicodeString SearchField = {read=FSearchField, write=FSearchField};
	__property TwwAfterSearchEvent OnAfterSearch = {read=FOnAfterSearch, write=FOnAfterSearch};
	__property bool ShowMatchText = {read=FShowMatchText, write=FShowMatchText, default=0};
	__property System::UnicodeString PictureMask = {read=FPictureMask, write=FPictureMask};
	__property bool PictureMaskAutoFill = {read=FPictureMaskAutoFill, write=FPictureMaskAutoFill, default=1};
	__property bool PictureMaskFromField = {read=FPictureMaskFromField, write=FPictureMaskFromField, default=0};
	__property int SearchDelay = {read=FSearchDelay, write=FSearchDelay, default=0};
	__property TwwSearchCaseSensitivity CaseSensitivity = {read=FCaseSensitivity, write=FCaseSensitivity, default=0};
	__property Vcl::Wwtypes::TwwPerformSearchEvent OnPerformCustomSearch = {read=FOnPerformCustomSearch, write=FOnPerformCustomSearch};
	__property AutoSelect = {default=1};
	__property AutoSize = {default=1};
	__property BorderStyle = {default=1};
	__property CharCase = {default=0};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property HideSelection = {default=1};
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property MaxLength = {default=0};
	__property OEMConvert = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PasswordChar = {default=0};
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
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
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwIncrementalSearch(HWND ParentWindow) : Vcl::Stdctrls::TCustomEdit(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwKeyDataLink : public Data::Db::TDataLink
{
	typedef Data::Db::TDataLink inherited;
	
private:
	TwwKeyCombo* FwwKeyCombo;
	
protected:
	virtual void __fastcall DataSetChanged(void);
	virtual void __fastcall ActiveChanged(void);
	
public:
	__fastcall TwwKeyDataLink(TwwKeyCombo* key);
public:
	/* TDataLink.Destroy */ inline __fastcall virtual ~TwwKeyDataLink(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwkeycb */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWKEYCB)
using namespace Vcl::Wwkeycb;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwkeycbHPP
