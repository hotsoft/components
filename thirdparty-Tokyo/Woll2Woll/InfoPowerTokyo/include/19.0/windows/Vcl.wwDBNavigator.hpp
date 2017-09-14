// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwdbnavigator.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwdbnavigatorHPP
#define Vcl_WwdbnavigatorHPP

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
#include <vcl.wwDialog.hpp>
#include <Data.DB.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <vcl.Wwcommon.hpp>
#include <System.TypInfo.hpp>
#include <Vcl.DBCtrls.hpp>
#include <Data.DBConsts.hpp>
#include <vcl.wwintl.hpp>
#include <vcl.wwspeedbutton.hpp>
#include <vcl.wwcollection.hpp>
#include <vcl.wwclearpanel.hpp>
#include <vcl.wwframe.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwdbnavigator
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwNavDataLink;
class DELPHICLASS TwwNavButton;
class DELPHICLASS TwwNavButtons;
class DELPHICLASS TwwNavRepeatInterval;
class DELPHICLASS TwwDBNavigator;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwNavDataLink : public Data::Db::TDataLink
{
	typedef Data::Db::TDataLink inherited;
	
private:
	TwwDBNavigator* FNavigator;
	
protected:
	virtual void __fastcall EditingChanged(void);
	virtual void __fastcall DataSetChanged(void);
	virtual void __fastcall ActiveChanged(void);
	
public:
	__fastcall TwwNavDataLink(TwwDBNavigator* ANav);
	__fastcall virtual ~TwwNavDataLink(void);
};

#pragma pack(pop)

enum DECLSPEC_DENUM TwwNavButtonStyle : unsigned char { nbsFirst, nbsPrior, nbsNext, nbsLast, nbsInsert, nbsDelete, nbsEdit, nbsPost, nbsCancel, nbsRefresh, nbsPriorPage, nbsNextPage, nbsSaveBookmark, nbsRestoreBookmark, nbsFilterDialog, nbsRecordViewDialog, nbsLocateDialog, nbsSearchDialog, nbsCustom };

typedef System::Set<TwwNavButtonStyle, TwwNavButtonStyle::nbsFirst, TwwNavButtonStyle::nbsCustom> TwwNavButtonStyles;

typedef TwwNavButtonStyle TwwNavButtonNavStyleEx;

typedef TwwNavButtonStyle TwwNavButtonNavStyle;

typedef TwwNavButtonStyle TwwNavButtonDlgStyle;

typedef System::Set<TwwNavButtonStyle, TwwNavButtonStyle::nbsFirst, TwwNavButtonStyle::nbsCustom> TwwNavButtonNavStylesEx;

enum DECLSPEC_DENUM TwwUpdateCause : unsigned char { usDataChanged, usEditingChanged, usActiveChanged, usOther };

typedef void __fastcall (__closure *TwwUpdateStateEvent)(TwwDBNavigator* Navigator, TwwNavButton* Button, TwwUpdateCause Cause);

typedef void __fastcall (__closure *TwwCustomDialogEvent)(Vcl::Wwdialog::TwwCustomDialog* Dialog);

class PASCALIMPLEMENTATION TwwNavButton : public Vcl::Wwspeedbutton::TwwSpeedButton
{
	typedef Vcl::Wwspeedbutton::TwwSpeedButton inherited;
	
private:
	Vcl::Wwcollection::TwwUpdateNameEvent FOnUpdateName;
	Vcl::Wwcollection::TwwSelectionMethod FSelectionMethod;
	TwwNavButtons* FNavButtons;
	Vcl::Extctrls::TTimer* FTimer;
	bool FLineBreak;
	Vcl::Wwdialog::TwwCustomDialog* FDialog;
	TwwNavButtonStyle FStyle;
	System::Classes::TNotifyEvent FOnRowChanged;
	TwwUpdateStateEvent FOnUpdateState;
	TwwCustomDialogEvent FOnAfterCreateDialog;
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMEnabledChanged(Winapi::Messages::TMessage &Message);
	
protected:
	virtual void __fastcall Loaded(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	virtual int __fastcall GetImageIndex(void);
	virtual int __fastcall GetIndex(void);
	virtual TwwNavButtons* __fastcall GetNavButtons(void);
	virtual TwwDBNavigator* __fastcall GetNavigator(void);
	virtual void __fastcall SetDialog(Vcl::Wwdialog::TwwCustomDialog* Value);
	virtual void __fastcall SetImageIndex(int Value);
	virtual void __fastcall SetIndex(int Value);
	virtual void __fastcall SetLineBreak(bool Value);
	virtual void __fastcall SetName(const System::Classes::TComponentName NewName);
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* Value);
	virtual void __fastcall SetStyle(TwwNavButtonStyle Value);
	virtual System::UnicodeString __fastcall GetDefaultHint(void);
	Vcl::Wwdialog::TwwCustomDialog* __fastcall GetDialog(Data::Db::TDataSet* DataSet);
	virtual void __fastcall CancelTimer(void);
	virtual void __fastcall CreateTimer(void);
	virtual void __fastcall TimerEvent(System::TObject* Sender);
	virtual void __fastcall UpdateName(void);
	virtual void __fastcall UpdateGlyph(void);
	virtual void __fastcall UpdateState(TwwUpdateCause Cause);
	__property TwwNavButtons* NavButtons = {read=GetNavButtons};
	
public:
	__fastcall virtual TwwNavButton(System::Classes::TComponent* AOwner);
	DYNAMIC void __fastcall Click(void);
	virtual bool __fastcall IsVisible(void);
	__property TwwDBNavigator* Navigator = {read=GetNavigator};
	Vcl::Wwcollection::_di_IwwCollection __fastcall GetCollection(void);
	System::UnicodeString __fastcall GetDisplayName(void);
	System::Classes::TPersistent* __fastcall GetInstance(void);
	void __fastcall SetOnUpdateName(Vcl::Wwcollection::TwwUpdateNameEvent Value);
	void __fastcall SetSelectionMethod(Vcl::Wwcollection::TwwSelectionMethod Value);
	virtual void __fastcall PaintTransparentBackground(void);
	
__published:
	__property Vcl::Wwdialog::TwwCustomDialog* Dialog = {read=FDialog, write=SetDialog};
	__property int Index = {read=GetIndex, write=SetIndex, nodefault};
	__property bool LineBreak = {read=FLineBreak, write=SetLineBreak, default=0};
	__property TwwNavButtonStyle Style = {read=FStyle, write=SetStyle, nodefault};
	__property Visible = {default=1};
	__property TwwCustomDialogEvent OnAfterCreateDialog = {read=FOnAfterCreateDialog, write=FOnAfterCreateDialog};
	__property System::Classes::TNotifyEvent OnRowChanged = {read=FOnRowChanged, write=FOnRowChanged};
	__property TwwUpdateStateEvent OnUpdateState = {read=FOnUpdateState, write=FOnUpdateState};
public:
	/* TwwSpeedButton.Destroy */ inline __fastcall virtual ~TwwNavButton(void) { }
	
private:
	void *__IwwCollectionItem;	// Vcl::Wwcollection::IwwCollectionItem 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {D4CC0381-0B8D-11D2-A5AC-00104B216B5B}
	operator Vcl::Wwcollection::_di_IwwCollectionItem()
	{
		Vcl::Wwcollection::_di_IwwCollectionItem intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Vcl::Wwcollection::IwwCollectionItem*(void) { return (Vcl::Wwcollection::IwwCollectionItem*)&__IwwCollectionItem; }
	#endif
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwNavButtons : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
public:
	TwwNavButton* operator[](int Index) { return this->Items[Index]; }
	
private:
	Vcl::Controls::TControl* FDesigner;
	TwwDBNavigator* FNavigator;
	int FUpdateLock;
	
protected:
	virtual void __fastcall AddButton(TwwNavButton* const Button);
	virtual void __fastcall RemoveButton(TwwNavButton* const Button);
	virtual void __fastcall BeginUpdate(void);
	virtual void __fastcall EndUpdate(void);
	virtual TwwNavButton* __fastcall BottommostButton(void);
	virtual TwwNavButton* __fastcall FindButtonAtPos(TwwNavButton* IgnoreButton, int x, int y);
	virtual bool __fastcall IgnoreButton(TwwNavButton* Button);
	virtual TwwNavButton* __fastcall RightmostButton(void);
	void __fastcall MakeButtonsVisible(void);
	virtual void __fastcall MakeVisible(TwwNavButtonStyle AStyle, bool CanCreate);
	virtual void __fastcall MakeInvisible(TwwNavButtonStyle AStyle);
	virtual int __fastcall GetCount(void);
	virtual TwwNavButton* __fastcall GetItems(int Index);
	virtual TwwDBNavigator* __fastcall GetNavigator(void);
	virtual TwwNavButton* __fastcall GetVisibleButton(int Index);
	virtual int __fastcall GetVisibleCount(void);
	
public:
	__fastcall TwwNavButtons(TwwDBNavigator* ANav);
	__fastcall virtual ~TwwNavButtons(void);
	HRESULT __stdcall QueryInterface(const GUID &IID, /* out */ void *Obj);
	int __stdcall _AddRef(void);
	int __stdcall _Release(void);
	Vcl::Wwcollection::_di_IwwCollectionItem __fastcall IwwCollection_Add(void);
	Vcl::Wwcollection::_di_IwwCollectionItem __fastcall GetItem(int Index);
	void __fastcall SetDesigner(Vcl::Controls::TControl* Value);
	virtual TwwNavButton* __fastcall Add(TwwNavButtonStyle AStyle = (TwwNavButtonStyle)(0x12), System::Classes::TComponent* AComponent = (System::Classes::TComponent*)(0x0));
	virtual void __fastcall AddInfoPowerDialogs(void);
	virtual void __fastcall Clear(void);
	virtual void __fastcall CreateDefaultButtons(void);
	virtual void __fastcall UpdateButtonsRect(void);
	virtual void __fastcall UpdateButtonsPos(void);
	virtual void __fastcall UpdateButtonsState(TwwUpdateCause Cause);
	__property int Count = {read=GetCount, nodefault};
	__property TwwDBNavigator* Navigator = {read=GetNavigator};
	__property TwwNavButton* Items[int Index] = {read=GetItems/*, default*/};
	__property int UpdateLock = {read=FUpdateLock, nodefault};
	__property TwwNavButton* VisibleButtons[int Index] = {read=GetVisibleButton};
	__property int VisibleCount = {read=GetVisibleCount, nodefault};
private:
	void *__IwwNavButtons;	// Vcl::Wwcollection::IwwNavButtons 
	void *__IwwCollection;	// Vcl::Wwcollection::IwwCollection 
	
public:
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {BCDB6D20-2D56-11D2-A5AC-00104B216B5B}
	operator Vcl::Wwcollection::_di_IwwNavButtons()
	{
		Vcl::Wwcollection::_di_IwwNavButtons intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Vcl::Wwcollection::IwwNavButtons*(void) { return (Vcl::Wwcollection::IwwNavButtons*)&__IwwNavButtons; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {D4CC0380-0B8D-11D2-A5AC-00104B216B5B}
	operator Vcl::Wwcollection::_di_IwwCollection()
	{
		Vcl::Wwcollection::_di_IwwCollection intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator Vcl::Wwcollection::IwwCollection*(void) { return (Vcl::Wwcollection::IwwCollection*)&__IwwCollection; }
	#endif
	#if defined(MANAGED_INTERFACE_OPERATORS)
	// {00000000-0000-0000-C000-000000000046}
	operator System::_di_IInterface()
	{
		System::_di_IInterface intf;
		this->GetInterface(intf);
		return intf;
	}
	#else
	operator System::IInterface*(void) { return (System::IInterface*)&__IwwNavButtons; }
	#endif
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TwwNavOption : unsigned char { noConfirmDelete, noUseInternationalText };

typedef System::Set<TwwNavOption, TwwNavOption::noConfirmDelete, TwwNavOption::noUseInternationalText> TwwNavOptions;

enum DECLSPEC_DENUM TwwNavAutoSizeStyle : unsigned char { asSizeNavigator, asSizeNavButtons, asNone };

enum DECLSPEC_DENUM TwwNavLayout : unsigned char { nlHorizontal, nlVertical };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwNavRepeatInterval : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FInitialDelay;
	int FRepeatInterval;
	
public:
	__fastcall TwwNavRepeatInterval(void);
	
__published:
	__property int InitialDelay = {read=FInitialDelay, write=FInitialDelay, nodefault};
	__property int Interval = {read=FRepeatInterval, write=FRepeatInterval, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwNavRepeatInterval(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwDBNavigator : public Vcl::Wwclearpanel::TwwCustomTransparentPanel
{
	typedef Vcl::Wwclearpanel::TwwCustomTransparentPanel inherited;
	
private:
	TwwNavButtons* FButtons;
	Data::Db::TDataLink* FDataLink;
	System::Classes::TList* FBookmarks;
	TwwNavAutoSizeStyle FAutosizeStyle;
	Data::Db::TDataSource* FDataSource;
	bool FFlat;
	Vcl::Controls::TImageList* FImageList;
	TwwNavLayout FLayout;
	int FMoveBy;
	TwwNavOptions FOptions;
	TwwNavRepeatInterval* FRepeatInterval;
	bool InPaint;
	bool FTransparentClearsBackground;
	bool FDisableThemes;
	MESSAGE void __fastcall CMControlChange(Vcl::Controls::TCMControlChange &Message);
	HIDESBASE MESSAGE void __fastcall CMControlListChange(Vcl::Controls::TCMControlListChange &Message);
	HIDESBASE MESSAGE void __fastcall CMDialogChar(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall CMEnabledChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	
protected:
	virtual void __fastcall ControlListChange(Vcl::Controls::TControl* const Control, const bool Inserting);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	virtual void __fastcall AlignControls(Vcl::Controls::TControl* Control, System::Types::TRect &Rect);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall ReadState(System::Classes::TReader* Reader);
	virtual void __fastcall DataChanged(void);
	virtual void __fastcall EditingChanged(void);
	virtual void __fastcall ActiveChanged(void);
	virtual bool __fastcall GetShowHint(void);
	virtual TwwNavButtonNavStylesEx __fastcall GetVisibleButtons(void);
	HIDESBASE virtual void __fastcall SetAlignment(TwwNavLayout Value);
	virtual void __fastcall SetAutosizeStyle(TwwNavAutoSizeStyle Value);
	virtual void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	virtual void __fastcall SetFlat(bool Value);
	virtual void __fastcall SetImageList(Vcl::Controls::TImageList* Value);
	virtual void __fastcall SetMoveBy(int Value);
	virtual void __fastcall SetName(const System::Classes::TComponentName NewName);
	virtual void __fastcall SetOptions(TwwNavOptions Value);
	HIDESBASE virtual void __fastcall SetShowHint(bool Value);
	virtual void __fastcall SetVisibleButtons(TwwNavButtonNavStylesEx Value);
	virtual int __fastcall CalcBorderWidth(void);
	virtual int __fastcall CalcWidth(void);
	virtual Data::Db::TDataSet* __fastcall GetDataSet(bool RaiseException);
	System::DynamicArray<System::Byte> __fastcall GetBookmark(Data::Db::TDataSet* DataSet, bool GetNew);
	void __fastcall AdjustButtonsSize(Vcl::Controls::TControl* Control);
	void __fastcall FreeBookmark(Data::Db::TDataSet* DataSet);
	virtual void __fastcall UpdateAutosize(void);
	
public:
	System::Variant Patch;
	__fastcall virtual TwwDBNavigator(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDBNavigator(void);
	virtual void __fastcall SetDataSourceFromComponent(System::Classes::TComponent* Component, bool AllowNil);
	__property TwwNavButtonNavStylesEx VisibleButtons = {read=GetVisibleButtons, write=SetVisibleButtons, nodefault};
	
__published:
	__property bool DisableThemes = {read=FDisableThemes, write=FDisableThemes, default=0};
	__property TwwNavAutoSizeStyle AutosizeStyle = {read=FAutosizeStyle, write=SetAutosizeStyle, default=0};
	__property TwwNavButtons* Buttons = {read=FButtons, stored=false};
	__property Data::Db::TDataSource* DataSource = {read=FDataSource, write=SetDataSource};
	__property bool Flat = {read=FFlat, write=SetFlat, default=1};
	__property Vcl::Controls::TImageList* ImageList = {read=FImageList, write=SetImageList};
	__property TwwNavLayout Layout = {read=FLayout, write=SetAlignment, default=0};
	__property int MoveBy = {read=FMoveBy, write=SetMoveBy, default=10};
	__property TwwNavOptions Options = {read=FOptions, write=SetOptions, default=1};
	__property bool ShowHint = {read=GetShowHint, write=SetShowHint, default=0};
	__property TwwNavRepeatInterval* RepeatInterval = {read=FRepeatInterval, write=FRepeatInterval};
	__property bool TransparentClearsBackground = {read=FTransparentClearsBackground, write=FTransparentClearsBackground, default=0};
	__property Anchors = {default=3};
	__property Constraints;
	__property Align = {default=0};
	__property BevelInner = {default=0};
	__property BevelOuter = {default=0};
	__property Color = {default=-16777201};
	__property Enabled = {default=1};
	__property Font;
	__property ParentShowHint = {default=1};
	__property Visible = {default=1};
	__property Transparent = {default=0};
	__property OnResize;
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBNavigator(HWND ParentWindow) : Vcl::Wwclearpanel::TwwCustomTransparentPanel(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
static const System::Int8 WW_NAV_DEFAULT_MOVEBY = System::Int8(0xa);
#define swwControlNotAllowed L"TwwDBNavigator only accepts controls derived from TwwNavBu"\
	L"tton"
#define swwNoDataSource L"Error, DataSource not assigned"
#define swwParentNotNav L"Parent of TwwNavButton must be TwwDBNavigator"
#define swwParentNotDefined L"Parent propety of TwwNavButton not defined"
#define swwButtonNotInList L"Button parameter of RetrieveIndex not in Buttons list"
#define swwIndexOutOfRange L"Index of Buttons[] out of range"
#define swwOwnerRequired L"Owner cannot be nil"
#define swwBookmarkInvalid L"Cannot read or set property Bookmark because the Bookmark "\
	L"is invalid."
#define swwConfirmButtonAdd L"Add a button to %s for %s"
#define swwVisibleIndexOutRange L"Index of VisibleButtons[] out of range"
extern DELPHI_PACKAGE Vcl::Controls::TImageList* wwNavButtonGlyphs;
}	/* namespace Wwdbnavigator */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWDBNAVIGATOR)
using namespace Vcl::Wwdbnavigator;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwdbnavigatorHPP
