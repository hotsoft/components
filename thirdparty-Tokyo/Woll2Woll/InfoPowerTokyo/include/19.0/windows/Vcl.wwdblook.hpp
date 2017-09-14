// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwdblook.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwdblookHPP
#define Vcl_WwdblookHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Data.DB.hpp>
#include <Vcl.Controls.hpp>
#include <Winapi.Messages.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.Dialogs.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.wwdbigrd.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <vcl.wwlocate.hpp>
#include <Vcl.DBCtrls.hpp>
#include <vcl.wwtypes.hpp>
#include <vcl.wwframe.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.wwcombobutton.hpp>
#include <vcl.wwintl.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Themes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwdblook
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwDropDownGridOptions;
class DELPHICLASS TwwDBCustomLookupCombo;
class DELPHICLASS TwwDBLookupCombo;
class DELPHICLASS TwwDBLookupList;
class DELPHICLASS TwwPopupGrid;
class DELPHICLASS TwwLookupComboButton;
class DELPHICLASS TwwLookupComboStyleHook;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TNotifyCloseUpEvent)(System::TObject* Sender, Data::Db::TDataSet* LookupTable, Data::Db::TDataSet* FillTable, bool modified);

typedef void __fastcall (__closure *TNotInListEvent)(System::TObject* Sender, Data::Db::TDataSet* LookupTable, System::UnicodeString NewValue, bool &Accept);

typedef void __fastcall (__closure *TwwPerformSearchEvent)(System::TObject* Sender, Data::Db::TDataSet* LookupTable, System::UnicodeString SearchField, System::UnicodeString SearchValue, bool PerformLookup, bool &Found);

enum DECLSPEC_DENUM TwwDBLookupComboStyle : unsigned char { csDropDown, csDropDownList };

enum DECLSPEC_DENUM TwwDBLookupListOption : unsigned char { loColLines, loRowLines, loTitles, loFixedDropDownHeight, loSearchOnBackspace };

typedef System::Set<TwwDBLookupListOption, TwwDBLookupListOption::loColLines, TwwDBLookupListOption::loSearchOnBackspace> TwwDBLookupListOptions;

enum DECLSPEC_DENUM TwwCalcFieldType : unsigned char { cftUnknown, cftCalculated, cftNotCalculated };

enum DECLSPEC_DENUM TwwSeqSearchOption : unsigned char { ssoEnabled, ssoCaseSensitive };

typedef System::Set<TwwSeqSearchOption, TwwSeqSearchOption::ssoEnabled, TwwSeqSearchOption::ssoCaseSensitive> TwwSeqSearchOptions;

enum DECLSPEC_DENUM TwwLookupSearchType : unsigned char { lstDefault, lstCustom };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwDropDownGridOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FTitleLines;
	System::Uitypes::TColor FColor;
	System::Classes::TAlignment FTitleAlignment;
	
public:
	__fastcall TwwDropDownGridOptions(System::Classes::TComponent* AOwner);
	
__published:
	__property int TitleLines = {read=FTitleLines, write=FTitleLines, default=1};
	__property System::Uitypes::TColor Color = {read=FColor, write=FColor, default=-16777211};
	__property System::Classes::TAlignment TitleAlignment = {read=FTitleAlignment, write=FTitleAlignment, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwDropDownGridOptions(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwDBCustomLookupCombo : public Vcl::Stdctrls::TCustomEdit
{
	typedef Vcl::Stdctrls::TCustomEdit inherited;
	
private:
	Vcl::Wwintl::TwwController* FController;
	Vcl::Wwdbedit::TwwDBPicture* FPicture;
	System::Classes::TAlignment FDropDownAlignment;
	Vcl::Controls::TControlCanvas* FCanvas;
	int FDropDownCount;
	int FDropDownWidth;
	Vcl::Controls::TWinControl* FBtnControl;
	TwwDBLookupComboStyle FStyle;
	System::Classes::TNotifyEvent FOnDropDown;
	TNotifyCloseUpEvent FOnCloseUp;
	TNotInListEvent FOnNotInList;
	System::Classes::TNotifyEvent FOnMouseEnter;
	System::Classes::TNotifyEvent FOnMouseLeave;
	bool FShowMatchText;
	TwwPerformSearchEvent FOnPerformCustomSearch;
	System::Classes::TNotifyEvent FOnBeforeDropDown;
	TwwDropDownGridOptions* FDropDownGridOptions;
	bool FNavigator;
	bool ChangingFromLink;
	bool ProcessingNotInList;
	bool InCloseUpEvent;
	int FSearchDelay;
	bool FAutoDropDown;
	System::UnicodeString FSearchField;
	TwwSeqSearchOptions FSeqSearchOptions;
	bool FOrderByDisplay;
	int FItemCount;
	bool FPreciseEditRegion;
	bool FAllowClearKey;
	bool FUseTFields;
	Vcl::Controls::TImageList* FImageList;
	Vcl::Wwframe::TwwComboButtonStyle FButtonStyle;
	int ExtraHeight;
	bool FControlInfoInDataset;
	Vcl::Wwframe::TwwEditFrame* FFrame;
	Vcl::Wwframe::TwwButtonEffects* FButtonEffects;
	int FButtonWidth;
	bool SkipUpdate;
	bool SetModifiedInChangeEvent;
	bool InDropDownEvent;
	bool InCustomSearch;
	bool FDisableThemes;
	bool OldShowHint;
	bool FMouseInControl;
	
private:
	// __classmethod void __fastcall Create@();
	
private:
	System::UnicodeString __fastcall GetDataField(void);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	Data::Db::TDataSet* __fastcall GetLookupTable(void);
	System::UnicodeString __fastcall GetLookupField(void);
	HIDESBASE bool __fastcall GetReadOnly(void);
	System::UnicodeString __fastcall GetValue(void);
	System::UnicodeString __fastcall GetValue2(void);
	System::UnicodeString __fastcall GetValue3(void);
	void __fastcall EnableEdit(void);
	System::UnicodeString __fastcall GetDisplayValue(void);
	int __fastcall GetMinHeight(void);
	TwwDBLookupListOptions __fastcall GetOptions(void);
	bool __fastcall CanEdit(void);
	bool __fastcall Editable(void);
	bool __fastcall MouseEditable(void);
	void __fastcall SetValue(const System::UnicodeString NewValue);
	void __fastcall SetDisplayValue(const System::UnicodeString NewValue);
	void __fastcall DataChange(System::TObject* Sender);
	void __fastcall EditingChange(System::TObject* Sender);
	void __fastcall SetDataField(const System::UnicodeString Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	void __fastcall SetLookupTable(Data::Db::TDataSet* sel);
	void __fastcall SetLookupField(const System::UnicodeString Value);
	HIDESBASE void __fastcall SetReadOnly(bool Value);
	void __fastcall SetOptions(TwwDBLookupListOptions Value);
	void __fastcall SetStyle(TwwDBLookupComboStyle Value);
	void __fastcall SetPreciseEditRegion(bool val);
	void __fastcall FieldLinkActive(System::TObject* Sender);
	void __fastcall NonEditMouseDown(Winapi::Messages::TWMMouse &Message);
	void __fastcall DoSelectAll(void);
	void __fastcall SetEditRect(void);
	HIDESBASE MESSAGE void __fastcall WMSetFont(Winapi::Messages::TWMSetFont &Message);
	MESSAGE void __fastcall WMPaste(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMCut(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Message);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Message);
	MESSAGE void __fastcall CMCancelMode(Vcl::Controls::TCMCancelMode &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Message);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	HIDESBASE MESSAGE void __fastcall CMEnabledChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall CMTextChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMGetDataLink(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMNCPaint(Winapi::Messages::TMessage &Message);
	System::Classes::TStrings* __fastcall getSelectedFields(void);
	void __fastcall setSelectedFields(System::Classes::TStrings* sel);
	bool __fastcall GetShowButton(void);
	void __fastcall SetShowButton(bool sel);
	bool __fastcall IsLookup(void);
	void __fastcall SetUseTFields(bool val);
	System::Classes::TStrings* __fastcall GetControlType(void);
	void __fastcall SetControlType(System::Classes::TStrings* val);
	void __fastcall SetButtonGlyph(Vcl::Graphics::TBitmap* Value);
	Vcl::Graphics::TBitmap* __fastcall GetButtonGlyph(void);
	void __fastcall SetButtonStyle(Vcl::Wwframe::TwwComboButtonStyle val);
	void __fastcall SetButtonWidth(int val);
	int __fastcall GetButtonWidth(void);
	void __fastcall SetNavigator(bool Value);
	void __fastcall SetController(Vcl::Wwintl::TwwController* Value);
	
protected:
	Vcl::Dbctrls::TFieldDataLink* FFieldLink;
	Vcl::Extctrls::TTimer* FTimer;
	TwwPopupGrid* FGrid;
	Vcl::Wwcombobutton::TwwComboButton* FButton;
	System::UnicodeString FLastSearchKey;
	bool InList;
	System::UnicodeString TypedInText;
	System::UnicodeString OldLookupValue;
	System::UnicodeString OldDisplayValue;
	bool InAutoDropDown;
	bool SkipDataChange;
	bool FMouseInButtonControl;
	bool FFocused;
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	DYNAMIC bool __fastcall DoMouseWheelDown(System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos);
	DYNAMIC bool __fastcall DoMouseWheelUp(System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos);
	bool __fastcall HasMasterSource(void);
	bool __fastcall UseSeqSearch(void);
	Data::Db::TDataSet* __fastcall LTable(void);
	bool __fastcall IsWWCalculatedField(void);
	virtual void __fastcall DrawButton(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &R, Vcl::Buttons::TButtonState State, Vcl::Controls::TControlState ControlState, bool &DefaultPaint);
	System::UnicodeString __fastcall SetValue2(void);
	System::UnicodeString __fastcall SetValue3(void);
	void __fastcall WwChangeFromLink(Data::Db::TDataSet* AlookupTable, bool &modified);
	virtual void __fastcall OnEditTimerEvent(System::TObject* Sender);
	DYNAMIC void __fastcall KeyUp(System::Word &Key, System::Classes::TShiftState Shift);
	Data::Db::TDataSource* __fastcall GetLookupSource(void);
	void __fastcall UpdateData(System::TObject* Sender);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	DYNAMIC void __fastcall Change(void);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	void __fastcall GridClick(System::TObject* Sender);
	virtual void __fastcall Loaded(void);
	System::UnicodeString __fastcall GetLookupValue(void);
	void __fastcall RedrawListGrid(void);
	void __fastcall UpdateButtonGlyph(void);
	HIDESBASE MESSAGE void __fastcall CNKeyDown(Winapi::Messages::TWMKey &Message);
	DYNAMIC void __fastcall DoEnter(void);
	DYNAMIC void __fastcall DoExit(void);
	void __fastcall UpdateFromCurrentSelection(void);
	void __fastcall UpdateSearchIndex(bool useDisplayIndex);
	int __fastcall GetSearchIndex(void);
	HIDESBASE void __fastcall SetModified(bool val);
	bool __fastcall IsValidChar(System::Word key);
	virtual bool __fastcall IsLookupDlg(void);
	bool __fastcall IsLookupRequired(void);
	virtual bool __fastcall DoFindRecord(System::UnicodeString ASearchValue, System::UnicodeString ASearchField, Vcl::Wwlocate::TwwLocateMatchType matchType);
	void __fastcall ComputeLookupFields(void);
	void __fastcall UpdateButtonPosition(void);
	virtual bool __fastcall FindRecord(System::UnicodeString KeyValue, System::UnicodeString LookupField, Vcl::Wwlocate::TwwLocateMatchType MatchType, bool CaseSensitive, bool PerformLookup = false);
	virtual void __fastcall DrawFrame(Vcl::Graphics::TCanvas* Canvas);
	virtual bool __fastcall IsCustom(void);
	bool __fastcall Is3DBorder(void);
	System::Classes::TAlignment __fastcall GetEffectiveAlignment(void);
	void __fastcall InvalidateTransparentButton(void);
	virtual void __fastcall PerformCustomSearch(System::UnicodeString SearchField, System::UnicodeString SearchValue, bool PerformLookup, bool &Found);
	virtual void __fastcall DoMouseEnter(void);
	virtual void __fastcall DoMouseLeave(void);
	virtual bool __fastcall IsVistaComboNonEditable(void);
	bool __fastcall UseExprIndex(void);
	Data::Db::TField* __fastcall IndexFields(int index);
	void __fastcall SetToIndexContainingField(System::UnicodeString fieldName);
	void __fastcall SetToIndexContainingFields(System::Classes::TStrings* fields);
	bool __fastcall wwFindRecord(System::UnicodeString KeyValue, System::UnicodeString LookupField, Vcl::Wwlocate::TwwLocateMatchType MatchType, bool caseSensitive);
	bool __fastcall wwFindNearest(System::UnicodeString key, int FieldNo);
	bool __fastcall wwFindKey(const System::TVarRec *KeyValues, const int KeyValues_High);
	__property Vcl::Controls::TControlCanvas* ControlCanvas = {read=FCanvas};
	__property bool MouseInControl = {read=FMouseInControl, nodefault};
	
public:
	TwwCalcFieldType wwDBCalcFieldType;
	System::Variant Patch;
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	bool __fastcall isTransparentEffective(void);
	void __fastcall RefreshDisplay(void);
	void __fastcall RefreshButton(void);
	void __fastcall PerformSearch(void);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	__fastcall virtual TwwDBCustomLookupCombo(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDBCustomLookupCombo(void);
	DYNAMIC void __fastcall DropDown(void);
	DYNAMIC void __fastcall CloseUp(bool modified);
	__property System::UnicodeString Value = {read=GetValue, write=SetValue};
	__property System::UnicodeString Value2 = {read=GetValue2};
	__property System::UnicodeString Value3 = {read=GetValue3};
	__property System::UnicodeString LookupValue = {read=GetLookupValue, write=SetValue};
	__property System::UnicodeString DisplayValue = {read=GetDisplayValue, write=SetDisplayValue};
	__property System::UnicodeString SearchField = {read=FSearchField, write=FSearchField};
	__property System::Classes::TLeftRight DropDownAlignment = {read=FDropDownAlignment, write=FDropDownAlignment, nodefault};
	__property System::Classes::TStrings* Selected = {read=getSelectedFields, write=setSelectedFields};
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property Vcl::Wwframe::TwwComboButtonStyle ButtonStyle = {read=FButtonStyle, write=SetButtonStyle, nodefault};
	__property Vcl::Wwframe::TwwButtonEffects* ButtonEffects = {read=FButtonEffects, write=FButtonEffects};
	__property Vcl::Graphics::TBitmap* ButtonGlyph = {read=GetButtonGlyph, write=SetButtonGlyph, stored=IsCustom};
	__property int ButtonWidth = {read=GetButtonWidth, write=SetButtonWidth, default=0};
	__property Data::Db::TDataSet* LookupTable = {read=GetLookupTable, write=SetLookupTable};
	__property System::UnicodeString LookupField = {read=GetLookupField, write=SetLookupField};
	__property TwwDBLookupListOptions Options = {read=GetOptions, write=SetOptions, default=0};
	__property TwwDBLookupComboStyle Style = {read=FStyle, write=SetStyle, default=0};
	__property int DropDownCount = {read=FDropDownCount, write=FDropDownCount, default=8};
	__property int DropDownWidth = {read=FDropDownWidth, write=FDropDownWidth, default=0};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, default=0};
	__property bool AutoDropDown = {read=FAutoDropDown, write=FAutoDropDown, nodefault};
	__property System::Classes::TNotifyEvent OnDropDown = {read=FOnDropDown, write=FOnDropDown};
	__property System::Classes::TNotifyEvent OnBeforeDropDown = {read=FOnBeforeDropDown, write=FOnBeforeDropDown};
	__property TNotifyCloseUpEvent OnCloseUp = {read=FOnCloseUp, write=FOnCloseUp};
	__property bool ShowButton = {read=GetShowButton, write=SetShowButton, nodefault};
	__property TwwSeqSearchOptions SeqSearchOptions = {read=FSeqSearchOptions, write=FSeqSearchOptions, default=1};
	__property TNotInListEvent OnNotInList = {read=FOnNotInList, write=FOnNotInList};
	__property TwwPopupGrid* Grid = {read=FGrid, write=FGrid};
	__property bool OrderByDisplay = {read=FOrderByDisplay, write=FOrderByDisplay, default=1};
	__property bool PreciseEditRegion = {read=FPreciseEditRegion, write=SetPreciseEditRegion, nodefault};
	__property bool AllowClearKey = {read=FAllowClearKey, write=FAllowClearKey, nodefault};
	__property bool ShowMatchText = {read=FShowMatchText, write=FShowMatchText, default=0};
	__property bool UseTFields = {read=FUseTFields, write=SetUseTFields, default=1};
	__property Vcl::Controls::TImageList* ImageList = {read=FImageList, write=FImageList};
	__property bool ControlInfoInDataset = {read=FControlInfoInDataset, write=FControlInfoInDataset, default=1};
	__property System::Classes::TStrings* ControlType = {read=GetControlType, write=SetControlType};
	__property Vcl::Wwframe::TwwEditFrame* Frame = {read=FFrame, write=FFrame};
	__property Vcl::Wwintl::TwwController* Controller = {read=FController, write=SetController};
	__property int SearchDelay = {read=FSearchDelay, write=FSearchDelay, default=0};
	__property TwwDropDownGridOptions* DropDownGridOptions = {read=FDropDownGridOptions, write=FDropDownGridOptions};
	__property TwwPerformSearchEvent OnPerformCustomSearch = {read=FOnPerformCustomSearch, write=FOnPerformCustomSearch};
	__property System::Classes::TNotifyEvent OnMouseEnter = {read=FOnMouseEnter, write=FOnMouseEnter};
	__property System::Classes::TNotifyEvent OnMouseLeave = {read=FOnMouseLeave, write=FOnMouseLeave};
	__property bool Navigator = {read=FNavigator, write=SetNavigator, default=0};
	__property bool DisableThemes = {read=FDisableThemes, write=FDisableThemes, default=0};
	
__published:
	__property Vcl::Wwdbedit::TwwDBPicture* Picture = {read=FPicture, write=FPicture};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Constraints;
	__property ParentBiDiMode = {default=1};
	__property AutoSize = {default=1};
	__property Ctl3D;
	__property Font;
	__property CharCase = {default=0};
	__property BorderStyle = {default=1};
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBCustomLookupCombo(HWND ParentWindow) : Vcl::Stdctrls::TCustomEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwDBLookupCombo : public TwwDBCustomLookupCombo
{
	typedef TwwDBCustomLookupCombo inherited;
	
private:
	// __classmethod void __fastcall Create@();
	
__published:
	__property Controller;
	__property BevelEdges = {default=15};
	__property BevelInner = {index=0, default=2};
	__property BevelKind = {default=0};
	__property BevelOuter = {index=1, default=1};
	__property DisableThemes = {default=0};
	__property ControlInfoInDataset = {default=1};
	__property ControlType;
	__property DropDownAlignment;
	__property Selected;
	__property DataField = {default=0};
	__property DataSource;
	__property LookupTable;
	__property LookupField = {default=0};
	__property Options = {default=0};
	__property Style = {default=0};
	__property AutoSelect = {default=1};
	__property Color = {default=-16777211};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property DropDownCount = {default=8};
	__property DropDownWidth = {default=0};
	__property Enabled = {default=1};
	__property ButtonStyle = {default=1};
	__property ButtonEffects;
	__property Navigator = {default=0};
	__property Frame;
	__property ButtonWidth = {default=0};
	__property ButtonGlyph;
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property ImageList;
	__property MaxLength = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property AutoDropDown;
	__property ShowButton;
	__property SeqSearchOptions = {default=1};
	__property OrderByDisplay = {default=1};
	__property SearchDelay = {default=0};
	__property UseTFields = {default=1};
	__property PreciseEditRegion;
	__property AllowClearKey;
	__property ShowMatchText = {default=0};
	__property Touch;
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnBeforeDropDown;
	__property OnDropDown;
	__property OnCloseUp;
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
	__property OnNotInList;
	__property OnPerformCustomSearch;
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
	/* TwwDBCustomLookupCombo.Create */ inline __fastcall virtual TwwDBLookupCombo(System::Classes::TComponent* AOwner) : TwwDBCustomLookupCombo(AOwner) { }
	/* TwwDBCustomLookupCombo.Destroy */ inline __fastcall virtual ~TwwDBLookupCombo(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBLookupCombo(HWND ParentWindow) : TwwDBCustomLookupCombo(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwDBLookupList : public Vcl::Wwdbigrd::TwwCustomDBGrid
{
	typedef Vcl::Wwdbigrd::TwwCustomDBGrid inherited;
	
private:
	TwwDBCustomLookupCombo* FCombo;
	Vcl::Dbctrls::TFieldDataLink* FFieldLink;
	Vcl::Dbctrls::TFieldDataLink* FNavigatorLink;
	System::UnicodeString FLookupField;
	Data::Db::TField* FDisplayFld;
	Data::Db::TField* FValueFld;
	Data::Db::TField* FValueFld2;
	Data::Db::TField* FValueFld3;
	System::UnicodeString FValue;
	System::UnicodeString FValue2;
	System::UnicodeString FValue3;
	System::UnicodeString FDisplayValue;
	int FHiliteRow;
	TwwDBLookupListOptions FOptions;
	int FTitleOffset;
	bool FFoundValue;
	bool FInCellSelect;
	System::Classes::TNotifyEvent FOnListClick;
	bool BeAccurate;
	int inDataChanged;
	System::UnicodeString DummyString;
	HIDESBASE System::Classes::TStrings* __fastcall getSelectedFields(void);
	HIDESBASE void __fastcall setSelectedFields(System::Classes::TStrings* sel);
	System::UnicodeString __fastcall GetDataField(void);
	HIDESBASE Data::Db::TDataSource* __fastcall GetDataSource(void);
	Data::Db::TDataSource* __fastcall GetLookupSource(void);
	System::UnicodeString __fastcall GetLookupField(void);
	Data::Db::TDataSet* __fastcall GetLookupTable(void);
	System::UnicodeString __fastcall GetValue(void);
	System::UnicodeString __fastcall GetValue2(void);
	System::UnicodeString __fastcall GetValue3(void);
	System::UnicodeString __fastcall GetDisplayValue(void);
	bool __fastcall GetReadOnly(void);
	void __fastcall FieldLinkActive(System::TObject* Sender);
	void __fastcall DataChange(System::TObject* Sender);
	void __fastcall NavigatorDataChange(System::TObject* Sender);
	void __fastcall EditingChange(System::TObject* Sender);
	void __fastcall SetDataField(const System::UnicodeString Value);
	HIDESBASE void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	void __fastcall SetLookupSource(Data::Db::TDataSource* Value);
	void __fastcall SetLookupTable(Data::Db::TDataSet* value);
	void __fastcall SetLookupField(const System::UnicodeString Value);
	void __fastcall SetValue(const System::UnicodeString Value);
	void __fastcall SetDisplayValue(const System::UnicodeString Value);
	void __fastcall SetReadOnly(bool Value);
	HIDESBASE void __fastcall SetOptions(TwwDBLookupListOptions Value);
	void __fastcall NewLayout(void);
	void __fastcall FastLookup(void);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Message);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	
protected:
	HIDESBASE void __fastcall UpdateData(System::TObject* Sender);
	bool __fastcall isWWCalculatedField(void);
	virtual bool __fastcall HighlightCell(int DataCol, int DataRow, const System::UnicodeString Value, Vcl::Grids::TGridDrawState AState);
	DYNAMIC bool __fastcall CanGridAcceptKey(System::Word Key, System::Classes::TShiftState Shift);
	virtual void __fastcall DefineFieldMap(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual bool __fastcall CanEdit(void);
	void __fastcall InitFields(bool showError);
	virtual void __fastcall CreateWnd(void);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	virtual void __fastcall LinkActive(bool Value);
	virtual void __fastcall Scroll(int Distance);
	DYNAMIC void __fastcall ListClick(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall Paint(void);
	virtual void __fastcall DataChanged(void);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Message);
	virtual void __fastcall DrawCell(int ACol, int ARow, const System::Types::TRect &ARect, Vcl::Grids::TGridDrawState AState);
	
public:
	int lookupFieldCount;
	__fastcall virtual TwwDBLookupList(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDBLookupList(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	__property System::UnicodeString Value = {read=GetValue, write=SetValue};
	__property System::UnicodeString DisplayValue = {read=GetDisplayValue, write=SetDisplayValue};
	__property Data::Db::TField* DisplayFld = {read=FDisplayFld};
	__property VisibleRowCount;
	virtual void __fastcall SetColumnAttributes(void);
	void __fastcall DoLookup(bool SetToDisplayIndex);
	
__published:
	__property Anchors = {default=3};
	__property Constraints;
	__property System::Classes::TStrings* Selected = {read=getSelectedFields, write=setSelectedFields};
	__property Data::Db::TDataSet* LookupTable = {read=GetLookupTable, write=SetLookupTable};
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property System::UnicodeString LookupField = {read=GetLookupField, write=SetLookupField};
	__property TwwDBLookupListOptions Options = {read=FOptions, write=SetOptions, default=0};
	__property System::Classes::TNotifyEvent OnClick = {read=FOnListClick, write=FOnListClick};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, default=0};
	__property Align = {default=0};
	__property BorderStyle = {default=1};
	__property Color = {default=-16777211};
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBLookupList(HWND ParentWindow) : Vcl::Wwdbigrd::TwwCustomDBGrid(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwPopupGrid : public TwwDBLookupList
{
	typedef TwwDBLookupList inherited;
	
private:
	// __classmethod void __fastcall Create@();
	
protected:
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual bool __fastcall CanEdit(void);
	virtual void __fastcall LinkActive(bool Value);
	
public:
	bool firstPaint;
	__property RowCount = {default=5};
	__property ColCount = {default=5};
	__fastcall virtual TwwPopupGrid(System::Classes::TComponent* AOwner);
	
__published:
	__property ControlType;
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TwwDBLookupList.Destroy */ inline __fastcall virtual ~TwwPopupGrid(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwPopupGrid(HWND ParentWindow) : TwwDBLookupList(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwLookupComboButton : public Vcl::Wwcombobutton::TwwComboButton
{
	typedef Vcl::Wwcombobutton::TwwComboButton inherited;
	
protected:
	virtual bool __fastcall IsVistaTransparentButton(void);
	virtual bool __fastcall IsVistaComboNonEditable(void);
	virtual bool __fastcall ParentMouseInControl(void);
	virtual bool __fastcall ParentDroppedDown(void);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Paint(void);
public:
	/* TwwComboButton.Create */ inline __fastcall virtual TwwLookupComboButton(System::Classes::TComponent* AOwner) : Vcl::Wwcombobutton::TwwComboButton(AOwner) { }
	/* TwwComboButton.Destroy */ inline __fastcall virtual ~TwwLookupComboButton(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwLookupComboStyleHook : public Vcl::Stdctrls::TEditStyleHook
{
	typedef Vcl::Stdctrls::TEditStyleHook inherited;
	
private:
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TMessage &Message);
	
private:
	Vcl::Controls::TWinControl* Control;
	
protected:
	virtual void __fastcall PaintNC(Vcl::Graphics::TCanvas* Canvas);
	
public:
	__fastcall virtual TwwLookupComboStyleHook(Vcl::Controls::TWinControl* AControl);
public:
	/* TMouseTrackControlStyleHook.Destroy */ inline __fastcall virtual ~TwwLookupComboStyleHook(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwdblook */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWDBLOOK)
using namespace Vcl::Wwdblook;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwdblookHPP
