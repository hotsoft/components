// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwdbigrd.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwdbigrdHPP
#define Vcl_WwdbigrdHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Vcl.GraphUtil.hpp>
#include <System.SysUtils.hpp>
#include <Winapi.Windows.hpp>
#include <Winapi.Messages.hpp>
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Data.DB.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.DBCtrls.hpp>
#include <vcl.Wwdbdatetimepicker.hpp>
#include <vcl.wwgridfilter.hpp>
#include <Vcl.Themes.hpp>
#include <System.RTLConsts.hpp>
#include <vcl.wwtreeview.hpp>
#include <vcl.wwriched.hpp>
#include <vcl.wwpaintoptions.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.wwtypes.hpp>
#include <Vcl.Buttons.hpp>
#include <vcl.wwlocate.hpp>
#include <vcl.Wwsystem.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Mask.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwdbigrd
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwDittoAttributes;
class DELPHICLASS TwwGridSearchEditor;
class DELPHICLASS TwwSelectColumnsTreeNode;
class DELPHICLASS TwwSelectColumnsTreeView;
class DELPHICLASS TwwTitleMenuAttributes;
class DELPHICLASS TwwGridHintWindow;
struct TwwTitleImageAttributes;
class DELPHICLASS TwwGridDataLink;
class DELPHICLASS TwwCustomDrawGridCellInfo;
class DELPHICLASS TwwIButton;
class DELPHICLASS TwwInplaceEdit;
class DELPHICLASS TwwColumn;
class DELPHICLASS TwwCacheColInfoItem;
class DELPHICLASS TwwGridLineColors;
class DELPHICLASS TwwBookmarkList;
class DELPHICLASS TwwCustomDBGrid;
class DELPHICLASS TwwDBGridStyleHook;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwEditControlOption : unsigned char { ecoCheckboxSingleClick, ecoSearchOwnerForm, ecoDisableCustomControls, ecoDisableDateTimePicker, ecoDisableEditorIfReadOnly };

typedef System::Set<TwwEditControlOption, TwwEditControlOption::ecoCheckboxSingleClick, TwwEditControlOption::ecoDisableEditorIfReadOnly> TwwEditControlOptions;

enum DECLSPEC_DENUM TwwDittoDirection : unsigned char { wwDittoPrior, wwDittoNext, wwDittoPriorOrNext };

enum DECLSPEC_DENUM TwwDittoOption : unsigned char { wwdoSkipBlobFields, wwdoSkipReadOnlyFields, wwdoSkipHiddenFields };

typedef System::Set<TwwDittoOption, TwwDittoOption::wwdoSkipBlobFields, TwwDittoOption::wwdoSkipHiddenFields> TwwDittoOptions;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwDittoAttributes : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TwwDittoDirection FDittoDirection;
	System::Classes::TShortCut FShortCutDittoField;
	System::Classes::TShortCut FShortCutDittoRecord;
	TwwDittoOptions FOptions;
	
__published:
	__property TwwDittoDirection DittoDirection = {read=FDittoDirection, write=FDittoDirection, default=0};
	__property System::Classes::TShortCut ShortCutDittoField = {read=FShortCutDittoField, write=FShortCutDittoField, default=0};
	__property System::Classes::TShortCut ShortCutDittoRecord = {read=FShortCutDittoRecord, write=FShortCutDittoRecord, default=0};
	__property TwwDittoOptions Options = {read=FOptions, write=FOptions, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwDittoAttributes(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwDittoAttributes(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwGridSearchEditor : public Vcl::Wwdbedit::TwwDBEdit
{
	typedef Vcl::Wwdbedit::TwwDBEdit inherited;
	
protected:
	DYNAMIC void __fastcall DoExit(void);
	
public:
	System::UnicodeString FieldName;
	int Column;
public:
	/* TwwDBCustomEdit.Create */ inline __fastcall virtual TwwGridSearchEditor(System::Classes::TComponent* AOwner) : Vcl::Wwdbedit::TwwDBEdit(AOwner) { }
	/* TwwDBCustomEdit.Destroy */ inline __fastcall virtual ~TwwGridSearchEditor(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwGridSearchEditor(HWND ParentWindow) : Vcl::Wwdbedit::TwwDBEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwSelectColumnsTreeNode : public Vcl::Wwtreeview::TwwTreeNode
{
	typedef Vcl::Wwtreeview::TwwTreeNode inherited;
	
private:
	System::UnicodeString FFieldName;
	bool FIsCategory;
	
public:
	__property System::UnicodeString FieldName = {read=FFieldName, write=FFieldName};
	__property bool IsCategory = {read=FIsCategory, write=FIsCategory, nodefault};
public:
	/* TwwTreeNode.Create */ inline __fastcall virtual TwwSelectColumnsTreeNode(Vcl::Wwtreeview::TwwTreeNodes* AOwner) : Vcl::Wwtreeview::TwwTreeNode(AOwner) { }
	/* TwwTreeNode.Destroy */ inline __fastcall virtual ~TwwSelectColumnsTreeNode(void) { }
	
};


class PASCALIMPLEMENTATION TwwSelectColumnsTreeView : public Vcl::Wwtreeview::TwwTreeView
{
	typedef Vcl::Wwtreeview::TwwTreeView inherited;
	
private:
	Vcl::Grids::TCustomGrid* FGrid;
	
protected:
	virtual Vcl::Wwtreeview::TwwTreeNode* __fastcall CreateNode(void);
	
public:
	void __fastcall AddField(System::UnicodeString NodeGroups, System::UnicodeString FieldName);
	__property Vcl::Grids::TCustomGrid* Grid = {read=FGrid, write=FGrid};
public:
	/* TwwCustomTreeView.Create */ inline __fastcall virtual TwwSelectColumnsTreeView(System::Classes::TComponent* AOwner) : Vcl::Wwtreeview::TwwTreeView(AOwner) { }
	/* TwwCustomTreeView.Destroy */ inline __fastcall virtual ~TwwSelectColumnsTreeView(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwSelectColumnsTreeView(HWND ParentWindow) : Vcl::Wwtreeview::TwwTreeView(ParentWindow) { }
	
};


enum DECLSPEC_DENUM TwwSortFilterOption : unsigned char { sfoSortAscending, sfoSortDescending, sfoFilter, sfoGrouping, sfoSelectColumns, sfoCreateIndexes, sfoAutoTitleButtonSort, sfoClientCursor, sfoUseCurrentValueForFilter, sfoAllowNullFilters };

typedef System::Set<TwwSortFilterOption, TwwSortFilterOption::sfoSortAscending, TwwSortFilterOption::sfoAllowNullFilters> TwwSortFilterOptions;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwTitleMenuAttributes : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TwwSortFilterOptions FOptions;
	bool FMenuEnabled;
	Vcl::Grids::TCustomGrid* FGrid;
	void __fastcall SetOptions(TwwSortFilterOptions value);
	void __fastcall SetMenuEnabled(bool value);
	
public:
	__fastcall virtual TwwTitleMenuAttributes(Vcl::Grids::TCustomGrid* AGrid);
	virtual bool __fastcall TitleMenuEnabled(void);
	
__published:
	__property TwwSortFilterOptions Options = {read=FOptions, write=SetOptions, default=101};
	__property bool MenuEnabled = {read=FMenuEnabled, write=SetMenuEnabled, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwTitleMenuAttributes(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwGridHintWindow : public Vcl::Controls::THintWindow
{
	typedef Vcl::Controls::THintWindow inherited;
	
protected:
	virtual void __fastcall Paint(void);
	
public:
	TwwCustomDBGrid* Grid;
	Data::Db::TField* Field;
	bool WordWrap;
	System::Classes::TAlignment Alignment;
public:
	/* THintWindow.Create */ inline __fastcall virtual TwwGridHintWindow(System::Classes::TComponent* AOwner) : Vcl::Controls::THintWindow(AOwner) { }
	
public:
	/* TCustomControl.Destroy */ inline __fastcall virtual ~TwwGridHintWindow(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwGridHintWindow(HWND ParentWindow) : Vcl::Controls::THintWindow(ParentWindow) { }
	
};


struct DECLSPEC_DRECORD TwwTitleImageAttributes
{
public:
	int ImageIndex;
	System::Classes::TAlignment Alignment;
	int Margin;
	bool IsGroupHeader;
};


typedef void __fastcall (__closure *TTitleButtonClickEvent)(System::TObject* Sender, System::UnicodeString AFieldName);

typedef void __fastcall (__closure *TCalcCellColorsEvent)(System::TObject* Sender, Data::Db::TField* Field, Vcl::Grids::TGridDrawState State, bool Highlight, Vcl::Graphics::TFont* AFont, Vcl::Graphics::TBrush* ABrush);

typedef void __fastcall (__closure *TCalcTitleAttributesEvent)(System::TObject* Sender, System::UnicodeString AFieldName, Vcl::Graphics::TFont* AFont, Vcl::Graphics::TBrush* ABrush, System::Classes::TAlignment &ATitleAlignment);

typedef void __fastcall (__closure *TwwDrawTitleCellEvent)(System::TObject* Sender, Vcl::Graphics::TCanvas* Canvas, Data::Db::TField* Field, const System::Types::TRect &Rect, bool &DefaultDrawing);

typedef void __fastcall (__closure *TwwDrawGroupHeaderCellEvent)(System::TObject* Sender, Vcl::Graphics::TCanvas* Canvas, System::UnicodeString GroupHeaderName, const System::Types::TRect &Rect, bool &DefaultDrawing);

typedef void __fastcall (__closure *TwwCalcTitleImageEvent)(System::TObject* Sender, Data::Db::TField* Field, TwwTitleImageAttributes &TitleImageAttributes);

typedef void __fastcall (__closure *TDrawFooterCellEvent)(System::TObject* Sender, Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &FooterCellRect, Data::Db::TField* Field, System::UnicodeString FooterText, bool &DefaultDrawing);

typedef void __fastcall (__closure *TColWidthChangedEvent)(System::TObject* Sender, int Column);

typedef void __fastcall (__closure *TAllowColResizeEvent)(System::TObject* Sender, int Column, bool &Accept);

typedef void __fastcall (__closure *TwwLeftColChangedEvent)(System::TObject* Sender, int NewLeftCol);

typedef void __fastcall (__closure *TwwCreateGridHintWindowEvent)(System::TObject* Sender, TwwGridHintWindow* HintWindow, Data::Db::TField* AField, const System::Types::TRect &R, bool &WordWrap, int &MaxWidth, int &MaxHeight, bool &DoDefault);

typedef void __fastcall (__closure *TwwOnCanShowCustomControlEvent)(System::TObject* Sender, Vcl::Controls::TWinControl* Control, Data::Db::TField* Field, bool &canShow);

typedef void __fastcall (__closure *TwwOnInitSelectColumnsDialogEvent)(Vcl::Forms::TCustomForm* Form, TwwSelectColumnsTreeView* TreeView, bool &DoDefault);

typedef void __fastcall (__closure *TwwBeforeSortEvent)(System::TObject* Sender, System::UnicodeString AFieldName, bool SortDescending, bool &DoDefault);

typedef void __fastcall (__closure *TwwSortEvent)(System::TObject* Sender, System::UnicodeString AFieldName, bool SortDescending);

typedef void __fastcall (__closure *TwwCanSortEvent)(System::TObject* Sender, System::UnicodeString AFieldName, bool SortDescending, bool &CanSort);

typedef void __fastcall (__closure *TwwCanFilterEvent)(System::TObject* Sender, System::UnicodeString AFieldName, bool &CanFilter);

typedef void __fastcall (__closure *TwwCanGroupEvent)(System::TObject* Sender, System::UnicodeString AFieldName, bool &CanGroup);

typedef void __fastcall (__closure *TwwBeforeTitleMenuEvent)(System::TObject* Sender, System::UnicodeString AFieldName, bool &DoDefault);

typedef void __fastcall (__closure *TwwBeforeColumnAddEvent)(System::TObject* Sender, System::UnicodeString AFieldName, bool insertBefore, bool &DoDefault);

typedef void __fastcall (__closure *TwwBeforeGetFilterRangeEvent)(System::TObject* Sender, System::UnicodeString AFieldName, System::UnicodeString &ADisplayLabel, System::UnicodeString &RangeStart, System::UnicodeString &RangeEnd, bool &doDefaultDialog, bool &ApplyFilter);

typedef void __fastcall (__closure *TwwBeforeGetFilterValueEvent)(System::TObject* Sender, System::UnicodeString AFieldName, System::UnicodeString &ADisplayLabel, System::UnicodeString &FilterValue, bool &doDefaultDialog, bool &ApplyFilter);

typedef void __fastcall (__closure *TwwAddSelectColumnEvent)(System::TObject* Sender, Data::Db::TField* AField, System::UnicodeString &NodeGroups, bool &canAdd);

typedef void __fastcall (__closure *TwwCanShowTitleDropDownEvent)(System::TObject* Sender, System::UnicodeString AFieldName, bool &CanShow);

typedef void __fastcall (__closure *TwwQuerySortFieldEvent)(System::TObject* Sender, System::UnicodeString &SortFieldName, bool &IsDescending);

typedef void __fastcall (__closure *TwwPopupTitleDropDownEvent)(System::TObject* Sender, Vcl::Menus::TPopupMenu* PopupMenu);

enum DECLSPEC_DENUM TwwMultiSelectOption : unsigned char { msoAutoUnselect, msoShiftSelect };

typedef System::Set<TwwMultiSelectOption, TwwMultiSelectOption::msoAutoUnselect, TwwMultiSelectOption::msoShiftSelect> TwwMultiSelectOptions;

typedef void __fastcall (__closure *TwwFieldChangedEvent)(System::TObject* Sender, Data::Db::TField* Field);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwGridDataLink : public Data::Db::TDataLink
{
	typedef Data::Db::TDataLink inherited;
	
private:
	TwwCustomDBGrid* FGrid;
	int FFieldCount;
	int FFieldMapSize;
	bool FModified;
	bool FInUpdateData;
	void *FFieldMap;
	bool __fastcall GetDefaultFields(void);
	Data::Db::TField* __fastcall GetFields(int I);
	
protected:
	virtual void __fastcall ActiveChanged(void);
	virtual void __fastcall DataSetChanged(void);
	virtual void __fastcall DataSetScrolled(int Distance);
	virtual void __fastcall FocusControl(Data::Db::TFieldRef Field);
	virtual void __fastcall EditingChanged(void);
	virtual void __fastcall LayoutChanged(void);
	virtual void __fastcall RecordChanged(Data::Db::TField* Field);
	virtual void __fastcall UpdateData(void);
	
public:
	__fastcall TwwGridDataLink(TwwCustomDBGrid* AGrid);
	__fastcall virtual ~TwwGridDataLink(void);
	bool __fastcall AddMapping(const System::UnicodeString FieldName);
	void __fastcall ClearMapping(void);
	void __fastcall Modified(void);
	void __fastcall Reset(void);
	__property bool DefaultFields = {read=GetDefaultFields, nodefault};
	__property int FieldCount = {read=FFieldCount, nodefault};
	__property Data::Db::TField* Fields[int I] = {read=GetFields};
	__property bool isFieldModified = {read=FModified, nodefault};
};

#pragma pack(pop)

enum DECLSPEC_DENUM TwwDBGridOption : unsigned char { dgEditing, dgAlwaysShowEditor, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgWordWrap, dgWordWrapFooter, dgPerfectRowFit, dgMultiSelect, dgShowFooter, dgFooter3DCells, dgNoLimitColSize, dgTrailingEllipsis, dgShowCellHint, dgTabExitsOnLastCol, dgFixedResizable, dgFixedEditable, dgProportionalColResize, dgRowResize, dgRowLinesDisableFixed, dgColLinesDisableFixed, dgFixedProportionalResize, dgHideBottomDataLine, dgDblClickColSizing, dgDisableColumnReorder };

typedef System::Set<TwwDBGridOption, TwwDBGridOption::dgEditing, TwwDBGridOption::dgDisableColumnReorder> TwwDBGridOptions;

enum DECLSPEC_DENUM TwwDBGridKeyOption : unsigned char { dgEnterToTab, dgAllowDelete, dgAllowInsert };

typedef System::Set<TwwDBGridKeyOption, TwwDBGridKeyOption::dgEnterToTab, TwwDBGridKeyOption::dgAllowInsert> TwwDBGridKeyOptions;

typedef void __fastcall (__closure *TwwDrawDataCellEvent)(System::TObject* Sender, const System::Types::TRect &Rect, Data::Db::TField* Field, Vcl::Grids::TGridDrawState State);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwCustomDrawGridCellInfo : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::Types::TRect Rect;
	Data::Db::TField* Field;
	Vcl::Grids::TGridDrawState State;
	int DataCol;
	int DataRow;
	bool DefaultDrawBackground;
	bool DefaultDrawHorzTopLine;
	bool DefaultDrawHorzBottomLine;
	bool DefaultDrawContents;
public:
	/* TObject.Create */ inline __fastcall TwwCustomDrawGridCellInfo(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TwwCustomDrawGridCellInfo(void) { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TwwCustomDrawCellEvent)(TwwCustomDBGrid* Sender, TwwCustomDrawGridCellInfo* DrawCellInfo);

enum DECLSPEC_DENUM TIndicatorColorType : unsigned char { icBlack, icYellow };

enum DECLSPEC_DENUM TwwBitmapSizeType : unsigned char { bsOriginalSize, bsStretchToFit, bsFitHeight, bsFitWidth };

class PASCALIMPLEMENTATION TwwIButton : public Vcl::Buttons::TSpeedButton
{
	typedef Vcl::Buttons::TSpeedButton inherited;
	
public:
	virtual void __fastcall SetBounds(int ALeft, int ATop, int AWidth, int AHeight);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall Paint(void);
public:
	/* TSpeedButton.Create */ inline __fastcall virtual TwwIButton(System::Classes::TComponent* AOwner) : Vcl::Buttons::TSpeedButton(AOwner) { }
	/* TSpeedButton.Destroy */ inline __fastcall virtual ~TwwIButton(void) { }
	
};


class PASCALIMPLEMENTATION TwwInplaceEdit : public Vcl::Grids::TInplaceEdit
{
	typedef Vcl::Grids::TInplaceEdit inherited;
	
private:
	Vcl::Wwdbedit::TwwDBPicture* FwwPicture;
	Vcl::Wwdbedit::TwwRegexMask* FRegexMask;
	bool FWordWrap;
	TwwCustomDBGrid* ParentGrid;
	bool FUsePictureMask;
	System::Uitypes::TColor OrigForeColor;
	System::Uitypes::TColor OrigBackColor;
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPaste(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMCut(Winapi::Messages::TMessage &Message);
	
protected:
	virtual void __fastcall BoundsChanged(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	DYNAMIC void __fastcall KeyUp(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	void __fastcall SetWordWrap(bool val);
	virtual void __fastcall UpdateContents(void);
	
public:
	__fastcall virtual TwwInplaceEdit(System::Classes::TComponent* AOwner, int dummy);
	__fastcall virtual ~TwwInplaceEdit(void);
	bool __fastcall IsValidPictureValue(System::UnicodeString s);
	bool __fastcall HavePictureMask(void);
	virtual void __fastcall ApplyValidationColors(bool valid);
	virtual void __fastcall ResetValidationColors(System::Uitypes::TColor ForeColor = (System::Uitypes::TColor)(0x1fffffff), System::Uitypes::TColor BackColor = (System::Uitypes::TColor)(0x1fffffff));
	virtual void __fastcall DoRefreshValidationDisplay(bool valid)/* overload */;
	virtual void __fastcall DoRefreshValidationDisplay(System::UnicodeString input = System::UnicodeString())/* overload */;
	__property Vcl::Wwdbedit::TwwDBPicture* Picture = {read=FwwPicture, write=FwwPicture};
	__property Vcl::Wwdbedit::TwwRegexMask* RegexMask = {read=FRegexMask, write=FRegexMask};
	__property bool WordWrap = {read=FWordWrap, write=SetWordWrap, nodefault};
	__property Color = {default=-16777211};
	__property Font;
public:
	/* TInplaceEdit.Create */ inline __fastcall virtual TwwInplaceEdit(System::Classes::TComponent* AOwner) : Vcl::Grids::TInplaceEdit(AOwner) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwInplaceEdit(HWND ParentWindow) : Vcl::Grids::TInplaceEdit(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwColumn : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::UnicodeString FFieldName;
	TwwCustomDBGrid* Grid;
	System::UnicodeString FFooterValue;
	System::UnicodeString FGroupName;
	bool FDisableSizing;
	System::UnicodeString FSearchValue;
	bool FVisible;
	int FDisplayWidth;
	System::UnicodeString FDisplayLabel;
	bool __fastcall GetReadOnly(void);
	System::UnicodeString __fastcall GetDisplayLabel(void);
	int __fastcall GetDisplayWidth(void);
	System::UnicodeString __fastcall GetGroupName(void);
	int __fastcall GetIndex(void);
	void __fastcall SetReadOnly(bool val);
	void __fastcall SetDisplayLabel(System::UnicodeString val);
	void __fastcall SetDisplayWidth(int val);
	void __fastcall SetFooterValue(System::UnicodeString val);
	void __fastcall SetGroupName(System::UnicodeString val);
	void __fastcall SetSearchValue(System::UnicodeString val);
	void __fastcall SetIndex(int val);
	bool __fastcall GetVisible(void);
	void __fastcall SetVisible(bool val);
	
public:
	System::Sysutils::TByteArray *ColumnFlags;
	__property System::UnicodeString FieldName = {read=FFieldName};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, nodefault};
	__property System::UnicodeString DisplayLabel = {read=GetDisplayLabel, write=SetDisplayLabel};
	__property int DisplayWidth = {read=GetDisplayWidth, write=SetDisplayWidth, nodefault};
	__property System::UnicodeString FooterValue = {read=FFooterValue, write=SetFooterValue};
	__property System::UnicodeString GroupName = {read=GetGroupName, write=SetGroupName};
	__property bool DisableSizing = {read=FDisableSizing, write=FDisableSizing, nodefault};
	__property System::UnicodeString SearchValue = {read=FSearchValue, write=SetSearchValue};
	__property int Index = {read=GetIndex, write=SetIndex, nodefault};
	__property bool Visible = {read=GetVisible, write=SetVisible, nodefault};
	__fastcall TwwColumn(System::Classes::TComponent* AOwner, System::UnicodeString AFieldName);
	__fastcall virtual ~TwwColumn(void);
	void __fastcall InsertBeforeColumn(System::UnicodeString FieldName);
	void __fastcall InsertAfterColumn(System::UnicodeString FieldName);
	void __fastcall MakeVisible(bool val);
};

#pragma pack(pop)

typedef void __fastcall (__closure *TwwGridURLOpenEvent)(System::TObject* Sender, System::UnicodeString &URLLink, Data::Db::TField* Field, bool &UseDefault);

enum DECLSPEC_DENUM TwwPadColumnStyle : unsigned char { pcsPlain, pcsPadHeader, pcsPadHeaderAndData };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwCacheColInfoItem : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	Vcl::Controls::TWinControl* CustomControl;
	System::UnicodeString ControlType;
	System::UnicodeString ControlData;
	bool AlwaysPaints;
	bool IsWhiteBackground;
public:
	/* TObject.Create */ inline __fastcall TwwCacheColInfoItem(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TwwCacheColInfoItem(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TwwGridLineStyle : unsigned char { glsSingle, gls3D, glsDynamic };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwGridLineColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Uitypes::TColor FDataColor;
	System::Uitypes::TColor FHighlightColor;
	System::Uitypes::TColor FShadowColor;
	System::Uitypes::TColor FFixedColor;
	System::Uitypes::TColor FGroupingColor;
	TwwCustomDBGrid* FGrid;
	void __fastcall SetDataColor(System::Uitypes::TColor val);
	void __fastcall SetHighlightColor(System::Uitypes::TColor val);
	void __fastcall SetShadowColor(System::Uitypes::TColor val);
	void __fastcall SetFixedColor(System::Uitypes::TColor val);
	void __fastcall SetGroupingColor(System::Uitypes::TColor val);
	
__published:
	__property System::Uitypes::TColor DataColor = {read=FDataColor, write=SetDataColor, default=12632256};
	__property System::Uitypes::TColor HighlightColor = {read=FHighlightColor, write=SetHighlightColor, default=-16777196};
	__property System::Uitypes::TColor ShadowColor = {read=FShadowColor, write=SetShadowColor, default=-16777200};
	__property System::Uitypes::TColor FixedColor = {read=FFixedColor, write=SetFixedColor, default=0};
	__property System::Uitypes::TColor GroupingColor = {read=FGroupingColor, write=SetGroupingColor, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwGridLineColors(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwGridLineColors(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

typedef void __fastcall (__closure *TwwDittoEvent)(System::TObject* Sender, Data::Db::TDataSet* DataSet, Data::Db::TField* Field, System::UnicodeString &DittoValue, bool &AllowDitto);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwBookmarkList : public System::TObject
{
	typedef System::TObject inherited;
	
	
private:
	typedef System::DynamicArray<System::DynamicArray<System::Byte> > _TwwBookmarkList__1;
	
	
public:
	System::DynamicArray<System::Byte> operator[](int Index) { return this->Items[Index]; }
	
private:
	_TwwBookmarkList__1 FList;
	TwwCustomDBGrid* FGrid;
	System::DynamicArray<System::Byte> FCache;
	int FCacheIndex;
	bool FCacheFind;
	bool FLinkActive;
	int __fastcall GetCount(void);
	bool __fastcall GetCurrentRowSelected(void);
	System::DynamicArray<System::Byte> __fastcall GetItem(int Index);
	void __fastcall InsertItem(int Index, System::DynamicArray<System::Byte> Item);
	void __fastcall DeleteItem(int Index);
	void __fastcall SetCurrentRowSelected(bool value);
	void __fastcall DataChanged(System::TObject* Sender);
	
protected:
	System::DynamicArray<System::Byte> __fastcall CurrentRow(void);
	
public:
	__fastcall TwwBookmarkList(TwwCustomDBGrid* AGrid);
	int __fastcall Compare(const System::DynamicArray<System::Byte> Item1, const System::DynamicArray<System::Byte> Item2);
	void __fastcall DeleteSelection(int Index);
	__fastcall virtual ~TwwBookmarkList(void);
	void __fastcall Clear(void);
	void __fastcall Delete(void);
	bool __fastcall Find(const System::DynamicArray<System::Byte> Item, int &Index);
	int __fastcall IndexOf(const System::DynamicArray<System::Byte> Item);
	bool __fastcall Refresh(void);
	void __fastcall LinkActive(bool value);
	__property int Count = {read=GetCount, nodefault};
	__property bool CurrentRowSelected = {read=GetCurrentRowSelected, write=SetCurrentRowSelected, nodefault};
	__property System::DynamicArray<System::Byte> Items[int Index] = {read=GetItem/*, default*/};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwCustomDBGrid : public Vcl::Grids::TCustomGrid
{
	typedef Vcl::Grids::TCustomGrid inherited;
	
private:
	System::UnicodeString FGroupFieldName;
	TwwDittoEvent FOnDitto;
	TwwDittoAttributes* FDittoAttributes;
	TwwTitleMenuAttributes* FTitleMenuAttributes;
	TwwOnInitSelectColumnsDialogEvent FOnInitSelectColumnsDialog;
	TwwOnCanShowCustomControlEvent FOnCanShowCustomControl;
	bool FShowHorzScrollBar;
	System::Classes::TNotifyEvent FOnBeforePaint;
	System::Classes::TStrings* FSelected;
	TwwGridLineColors* FLineColors;
	Vcl::Graphics::TFont* FTitleFont;
	System::Uitypes::TColor FTitleColor;
	System::Uitypes::TColor FFooterColor;
	System::Uitypes::TColor FFooterCellColor;
	int FFooterHeight;
	bool FReadOnly;
	bool FUserChange;
	int FUpdatingColWidths;
	TwwDBGridOptions FOptions;
	TwwDBGridKeyOptions FKeyOptions;
	System::Byte FTitleOffset;
	System::Byte FUpdateLock;
	bool FInColExit;
	bool FDefaultDrawing;
	bool FSelfChangingTitleFont;
	int FSelRow;
	TwwGridDataLink* FDataLink;
	System::Classes::TNotifyEvent FOnColEnter;
	System::Classes::TNotifyEvent FOnColExit;
	TwwDrawDataCellEvent FOnDrawDataCell;
	TCalcCellColorsEvent FOnCalcCellColors;
	TCalcTitleAttributesEvent FOnCalcTitleAttributes;
	TwwDrawTitleCellEvent FOnDrawTitleCell;
	TwwDrawGroupHeaderCellEvent FOnDrawGroupHeaderCell;
	TwwCalcTitleImageEvent FOnCalcTitleImage;
	TTitleButtonClickEvent FOnTitleButtonClick;
	Vcl::Wwdbedit::TwwValidateEvent FOnCheckValue;
	System::Classes::TNotifyEvent FOnTopRowChanged;
	System::Classes::TNotifyEvent FOnRowChanged;
	System::Classes::TNotifyEvent FOnCellChanged;
	TwwLeftColChangedEvent FOnLeftColChanged;
	System::UnicodeString FEditText;
	TIndicatorColorType FIndicatorColor;
	System::Uitypes::TColor FIndicatorIconColor;
	System::Classes::TAlignment FTitleAlignment;
	int FRowHeightPercent;
	int FTitleLines;
	bool FShowVertScrollBar;
	Vcl::Grids::TMovedEvent FOnColumnMoved;
	TColWidthChangedEvent FOnColWidthChanged;
	TAllowColResizeEvent FOnAllowColResize;
	bool FTitleButtons;
	bool FEditCalculated;
	bool FUseTFields;
	int FIndicatorWidth;
	TwwIButton* FIndicatorButton;
	Vcl::Controls::TImageList* FImageList;
	Vcl::Controls::TImageList* FTitleImageList;
	TDrawFooterCellEvent FOnDrawFooterCell;
	TwwFieldChangedEvent FOnFieldChanged;
	System::Classes::TNotifyEvent FOnUpdateFooter;
	TwwCreateGridHintWindowEvent FOnCreateHintWindow;
	TwwGridURLOpenEvent FOnURLOpen;
	int FSavePrevGridWidth;
	bool FHideAllLines;
	System::Uitypes::TCursor FSavedCursor;
	int URLLinkActiveRow;
	int URLLinkActiveCol;
	bool InUpdateRowCount;
	int FCalcCellRow;
	int FCalcCellCol;
	bool IsWhiteBackground;
	bool isDrawFocusRect;
	bool SkipLineDrawing;
	int TitleClickColumn;
	int TitleClickRow;
	bool TitleClickGroupTitle;
	bool MouseOverGroupTitle;
	bool MouseOverGroupChild;
	TwwMultiSelectOptions FMultiSelectOptions;
	bool DisableCellChangedEvent;
	System::Classes::TList* ColItems;
	System::Classes::TList* SavedColItems;
	bool UseDragCanvas;
	Vcl::Graphics::TBitmap* CaptureTitleBitmap;
	int FDragVertOffset;
	bool SkipTitleButtonClick;
	System::Classes::TStrings* FControlType;
	bool FControlInfoInDataset;
	System::Classes::TStrings* FPictureMasks;
	System::Classes::TStrings* FRegexMasks;
	bool FPictureMaskFromDataSet;
	bool CallColEnter;
	System::DynamicArray<System::Byte> LastBookmark;
	System::DynamicArray<System::Byte> LastMasterBookmark;
	int TempLastCol;
	bool ShouldUpdateFooter;
	TwwColumn* DummyColumn;
	int lastMouseX;
	int lastMouseY;
	int titleLastMouseX;
	int titleLastMouseY;
	Vcl::Extctrls::TTimer* HintTimer;
	int HintTimerCount;
	int FUpdateCount;
	TwwPadColumnStyle FPadColumnStyle;
	Vcl::Graphics::TCanvas* FPaintCanvas;
	Vcl::Graphics::TBitmap* FPaintBitmap;
	TwwEditControlOptions FEditControlOptions;
	Vcl::Wwpaintoptions::TwwGridPaintOptions* FPaintOptions;
	System::Types::TRect UpdateRect;
	bool ChangedBrushColor;
	bool ChangedFontColor;
	bool AlternatingEven;
	int FSizingIndex;
	int FPriorSizingWidth;
	int FRowOffset;
	TwwGridLineStyle FLineStyle;
	bool ClickedOnGroupName;
	bool ClickedOnGroupChild;
	bool PaintingSearchCell;
	bool FCompareBookmarksAltMethod;
	TwwCustomDrawCellEvent FOnBeforeDrawCell;
	TwwCustomDrawCellEvent FOnAfterDrawCell;
	bool FDisableThemesInTitle;
	bool FShowSearchRow;
	TwwGridSearchEditor* FSearchEditor;
	bool FSearchMode;
	TwwBeforeSortEvent FOnBeforeSort;
	TwwSortEvent FOnAfterSort;
	TwwCanSortEvent FOnCanSort;
	TwwCanFilterEvent FOnCanFilter;
	TwwCanGroupEvent FOnCanGroup;
	TwwCanShowTitleDropDownEvent FOnCanShowTitleDropDown;
	TwwQuerySortFieldEvent FOnQuerySortField;
	TwwPopupTitleDropDownEvent FOnPopupTitleDropDown;
	TwwBeforeTitleMenuEvent FOnBeforeGroup;
	TwwBeforeTitleMenuEvent FOnBeforeClearGroup;
	TwwBeforeTitleMenuEvent FOnBeforeColumnRemove;
	TwwBeforeColumnAddEvent FOnBeforeColumnAdd;
	TwwAddSelectColumnEvent FOnAddSelectColumn;
	TwwBeforeGetFilterRangeEvent FOnBeforeGetFilterRange;
	TwwBeforeGetFilterValueEvent FOnBeforeGetFilterValue;
	bool FTouchPan;
	
private:
	// __classmethod void __fastcall Create@();
	
private:
	bool __fastcall HaveActiveRecordColor(void);
	bool __fastcall HaveAlternatingRowColor(void);
	HIDESBASE Vcl::Grids::TGridCoord __fastcall CalcCoordFromPoint(int X, int Y, const Vcl::Grids::TGridDrawInfo &DrawInfo);
	void __fastcall SetRowOffset(int value);
	void __fastcall SetUseTFields(bool val);
	System::Classes::TComponent* __fastcall GetPictureControl(void);
	void __fastcall HintTimerEvent(System::TObject* Sender);
	void __fastcall MouseLoop_DragColumn(int HitTest, int X, int Y);
	bool __fastcall IsScrollBarVisible(void);
	bool __fastcall AcquireFocus(void);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	int __fastcall GetFieldCount(void);
	Data::Db::TField* __fastcall GetFields(int Index);
	Data::Db::TField* __fastcall GetSelectedField(void);
	int __fastcall GetSelectedIndex(void);
	void __fastcall RecordChanged(Data::Db::TField* Field);
	void __fastcall FieldChanged(Data::Db::TField* Field);
	void __fastcall SetDataSource(Data::Db::TDataSource* value);
	HIDESBASE void __fastcall SetOptions(TwwDBGridOptions value);
	void __fastcall SetSelectedField(Data::Db::TField* value);
	void __fastcall SetSelectedIndex(int value);
	void __fastcall SetTitleFont(Vcl::Graphics::TFont* value);
	void __fastcall SetIndicatorIconColor(System::Uitypes::TColor value);
	void __fastcall SetTitleAlignment(System::Classes::TAlignment sel);
	void __fastcall SetTitleLines(int sel);
	void __fastcall SetRowHeightPercent(int sel);
	void __fastcall SetShowVertScrollBar(bool val);
	void __fastcall SetTitleButtons(bool val);
	bool __fastcall GetShowHorzScrollBar(void);
	void __fastcall SetShowHorzScrollBar(bool val);
	System::Classes::TStrings* __fastcall GetSelectedFields(void);
	void __fastcall SetSelectedFields(System::Classes::TStrings* sel);
	int __fastcall GetColWidthsPixels(int Index);
	void __fastcall SetColWidthsPixels(int Index, int value);
	void __fastcall SetIndicatorWidth(int val);
	void __fastcall TitleFontChanged(System::TObject* Sender);
	void __fastcall UpdateData(void);
	void __fastcall UpdateActive(void);
	HIDESBASE MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMParentFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMDesignHitTest(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Msg);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Message);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Message);
	HIDESBASE MESSAGE void __fastcall WMRButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMHScroll(Winapi::Messages::TWMScroll &Msg);
	HIDESBASE MESSAGE void __fastcall CMShowingChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	TwwColumn* __fastcall GetFastColumn(int Index);
	TwwColumn* __fastcall GetColumn(int Index);
	void __fastcall SetFooterColor(System::Uitypes::TColor sel);
	void __fastcall SetFooterCellColor(System::Uitypes::TColor sel);
	void __fastcall SetFooterHeight(int val);
	Vcl::Graphics::TCanvas* __fastcall GetCanvas(void);
	void __fastcall SetPictureMasks(System::Classes::TStrings* val);
	void __fastcall SetRegexMasks(System::Classes::TStrings* val);
	void __fastcall SetControlType(System::Classes::TStrings* val);
	void __fastcall SetUpdateState(bool Updating);
	System::Uitypes::TColor __fastcall GetFixedLineColor(void);
	void __fastcall InheritedPaint(void);
	void __fastcall SetIndicatorColor(TIndicatorColorType value);
	int __fastcall GetCalcCellRow(void);
	HIDESBASE MESSAGE void __fastcall CMCancelMode(Vcl::Controls::TCMCancelMode &Message);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TWMKillFocus &Message);
	HIDESBASE Vcl::Grids::TGridCoord __fastcall CalcMaxTopLeft(const Vcl::Grids::TGridCoord &Coord, const Vcl::Grids::TGridDrawInfo &DrawInfo);
	void __fastcall SetGroupFieldName(System::UnicodeString value);
	System::UnicodeString __fastcall GetGroupFieldName(void);
	void __fastcall SetShowSearchRow(bool value);
	
protected:
	System::Classes::TList* FCacheColInfo;
	int FTopRecord;
	System::Byte FIndicatorOffset;
	Vcl::Wwriched::TwwDBRichEdit* TempRichEdit;
	bool FUpdateFields;
	bool FAcquireFocus;
	bool SuppressShowEditor;
	bool ShiftSelectMode;
	System::DynamicArray<System::Byte> ShiftSelectBookmark;
	System::UnicodeString dummy1;
	System::UnicodeString dummy2;
	int TitleTextOffset;
	bool FieldMappedText;
	bool URLLinkActive;
	Vcl::Controls::THintWindow* HintWindow;
	System::Sysutils::TWordArray *OrigColWidths;
	int OrigColWidthsCount;
	TwwCustomDrawGridCellInfo* DrawCellInfo;
	bool SkipErase;
	Vcl::Controls::TWinControl* CurrentCustomEdit;
	Vcl::Wwdbdatetimepicker::TwwDBCustomDateTimePicker* FDateTimePicker;
	bool FFocused;
	System::Types::TPoint FPanPoint;
	virtual void __fastcall EditingChanged(void);
	virtual void __fastcall DoGesture(const Vcl::Controls::TGestureEventInfo &EventInfo, bool &Handled);
	virtual bool __fastcall UseAlternateBuffering(void);
	virtual int __fastcall GetGridDataBottom(const Vcl::Grids::TGridDrawInfo &DrawInfo);
	void __fastcall ResetTitleClick(void);
	void __fastcall UpdateLeftCol(int ACol);
	HIDESBASE virtual void __fastcall ShowEditor(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	void __fastcall MoveCol(int ACol);
	virtual void __fastcall DoCreateHintWindow(TwwGridHintWindow* HintWindow, Data::Db::TField* AField, const System::Types::TRect &R, bool &WordWrap, int &MaxWidth, int &MaxHeight, bool &DoDefault);
	virtual bool __fastcall IsProportionalColumns(void);
	virtual void __fastcall DoURLOpen(System::UnicodeString &URLLink, Data::Db::TField* Field, bool &UseDefault);
	bool __fastcall IsDropDownGridFocused(void);
	bool __fastcall IsDropDownGridShowing(void);
	virtual void __fastcall FillWithAlternatingRowBitmap(const System::Types::TRect &TempRect);
	virtual void __fastcall LayoutChanged(void);
	DYNAMIC void __fastcall CalcRowHeight(void);
	bool __fastcall RecordCountIsValid(void);
	DYNAMIC bool __fastcall AllowCancelOnExit(void);
	DYNAMIC bool __fastcall CanEditAcceptKey(System::WideChar Key);
	DYNAMIC bool __fastcall CanEditModify(void);
	DYNAMIC int __fastcall GetEditLimit(void);
	DYNAMIC void __fastcall ColumnMoved(int FromIndex, int ToIndex);
	DYNAMIC void __fastcall ColEnter(void);
	DYNAMIC void __fastcall ColExit(void);
	virtual void __fastcall Scroll(int Distance);
	DYNAMIC void __fastcall ColWidthsChanged(void);
	virtual bool __fastcall HighlightCell(int DataCol, int DataRow, const System::UnicodeString value, Vcl::Grids::TGridDrawState AState);
	virtual void __fastcall DrawCell(int ACol, int ARow, const System::Types::TRect &ARect, Vcl::Grids::TGridDrawState AState);
	DYNAMIC System::UnicodeString __fastcall GetEditMask(int ACol, int ARow);
	DYNAMIC System::UnicodeString __fastcall GetEditText(int ACol, int ARow);
	DYNAMIC void __fastcall SetEditText(int ACol, int ARow, const System::UnicodeString value);
	Data::Db::TField* __fastcall GetColField(int ACol);
	DYNAMIC System::UnicodeString __fastcall GetFieldValue(int ACol);
	virtual void __fastcall DefineFieldMap(void);
	DYNAMIC void __fastcall DrawDataCell(const System::Types::TRect &Rect, Data::Db::TField* Field, Vcl::Grids::TGridDrawState State);
	virtual void __fastcall ProportionalColWidths(void);
	virtual void __fastcall SetColumnAttributes(void);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	virtual void __fastcall LinkActive(bool value);
	virtual void __fastcall Loaded(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual System::Types::TRect __fastcall TitleImageRect(int ACol);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	DYNAMIC void __fastcall TimedScroll(Vcl::Grids::TGridScrollDirection Direction);
	virtual void __fastcall CreateWnd(void);
	virtual bool __fastcall IsWWControl(int ACol, int ARow);
	virtual void __fastcall InvalidateTitle(void);
	__property bool DefaultDrawing = {read=FDefaultDrawing, write=FDefaultDrawing, default=1};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property ParentColor = {default=0};
	__property bool ReadOnly = {read=FReadOnly, write=FReadOnly, default=0};
	__property System::Uitypes::TColor TitleColor = {read=FTitleColor, write=FTitleColor, default=-16777201};
	__property System::Uitypes::TColor FooterColor = {read=FFooterColor, write=SetFooterColor, default=-16777201};
	__property System::Uitypes::TColor FooterCellColor = {read=FFooterCellColor, write=SetFooterCellColor, default=-16777201};
	__property int FooterHeight = {read=FFooterHeight, write=SetFooterHeight, default=0};
	__property Vcl::Graphics::TFont* TitleFont = {read=FTitleFont, write=SetTitleFont};
	__property System::Classes::TNotifyEvent OnColEnter = {read=FOnColEnter, write=FOnColEnter};
	__property System::Classes::TNotifyEvent OnColExit = {read=FOnColExit, write=FOnColExit};
	__property TwwDrawDataCellEvent OnDrawDataCell = {read=FOnDrawDataCell, write=FOnDrawDataCell};
	virtual void __fastcall DoTitleButtonClick(System::UnicodeString AFieldName);
	virtual void __fastcall DoDrawTitleCell(Vcl::Graphics::TCanvas* ACanvas, Data::Db::TField* Field, const System::Types::TRect &ARect, bool &DefaultDrawing);
	virtual void __fastcall DoDrawGroupHeaderCell(Vcl::Graphics::TCanvas* ACanvas, System::UnicodeString GroupHeaderName, const System::Types::TRect &ARect, bool &DefaultDrawing);
	virtual void __fastcall DoCalcTitleImage(System::TObject* Sender, Data::Db::TField* Field, TwwTitleImageAttributes &TitleImageAttributes);
	DYNAMIC bool __fastcall DoMouseWheelDown(System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos);
	DYNAMIC bool __fastcall DoMouseWheelUp(System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos);
	bool __fastcall UseRightToLeftAlignmentForField(Data::Db::TField* const AField, System::Classes::TAlignment Alignment);
	void __fastcall UpdateScrollBar(void);
	bool __fastcall IsValidCell(int ACol, int ARow);
	int __fastcall DbCol(int col);
	int __fastcall DbRow(int row);
	void __fastcall Draw3DLines(const System::Types::TRect &ARect, int ACol, int ARow, Vcl::Grids::TGridDrawState AState);
	virtual System::Uitypes::TColor __fastcall CellColor(int ACol, int ARow);
	virtual void __fastcall DrawCheckBox(const System::Types::TRect &ARect, int ACol, int ARow, bool val);
	void __fastcall DrawCheckBox_Checkmark(const System::Types::TRect &ARect, int ACol, int ARow, bool val);
	virtual void __fastcall RefreshBookmarkList(void);
	virtual Vcl::Grids::TInplaceEdit* __fastcall CreateEditor(void);
	virtual void __fastcall HideControls(void);
	__property TColWidthChangedEvent OnColWidthChanged = {read=FOnColWidthChanged, write=FOnColWidthChanged};
	__property TAllowColResizeEvent OnAllowColResize = {read=FOnAllowColResize, write=FOnAllowColResize};
	__property Vcl::Grids::TMovedEvent OnColumnMoved = {read=FOnColumnMoved, write=FOnColumnMoved};
	virtual void __fastcall UnselectAll(void);
	bool __fastcall IsSelectedCheckbox(int ACol);
	virtual void __fastcall DataChanged(void);
	DYNAMIC bool __fastcall IsSelectedRow(int DataRow);
	virtual void __fastcall DoTopRowChanged(void);
	virtual void __fastcall DoRowChanged(void);
	virtual void __fastcall DoCellChanged(void);
	virtual void __fastcall DoCheckRowChanged(void);
	__property int IndicatorButtonWidth = {read=FIndicatorWidth, write=SetIndicatorWidth, nodefault};
	DYNAMIC void __fastcall TopLeftChanged(void);
	virtual System::Types::TRect __fastcall GetClientRect(void);
	virtual void __fastcall Paint(void);
	System::Classes::TStrings* __fastcall GetControlType(void);
	virtual void __fastcall GetControlInfo(System::UnicodeString AFieldName, System::UnicodeString &AControlType, System::UnicodeString &AParameters);
	virtual void __fastcall DoFieldChanged(Data::Db::TField* Field);
	virtual void __fastcall DoUpdateFooter(void);
	virtual System::Types::TRect __fastcall GetFooterRect(void);
	virtual void __fastcall CheckFooterUpdate(void);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int AX, int AY);
	virtual void __fastcall FreeHintWindow(void);
	virtual Vcl::Controls::THintWindow* __fastcall CreateHintWindow(Data::Db::TField* AField);
	virtual void __fastcall ValidationErrorUsingMask(Data::Db::TField* Field, System::UnicodeString Msg = System::UnicodeString());
	void __fastcall ChangeOrientation(bool RightToLeftOrientation);
	virtual void __fastcall DrawLines(void);
	virtual void __fastcall PaintClickedTitleButton(void);
	bool __fastcall AdjustBoundsRect(Vcl::Controls::TWinControl* ACurrentCustomEdit);
	virtual void __fastcall CalcSizingState(int X, int Y, Vcl::Grids::TGridState &State, int &Index, int &SizingPos, int &SizingOfs, Vcl::Grids::TGridDrawInfo &FixedInfo);
	virtual void __fastcall InitCacheColInfo(void);
	bool __fastcall UseThemesInTitle(void);
	bool __fastcall IsShortCut(Winapi::Messages::TWMKey &Message);
	virtual int __fastcall GetSearchRowHeight(void);
	virtual TwwGridSearchEditor* __fastcall CreateSearchEditor(void);
	virtual void __fastcall UpdateSearchEditor(int ACol);
	virtual void __fastcall GridUpdateData(void);
	virtual void __fastcall WriteTextLines(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect, int DX, int DY, System::WideChar * s, System::Classes::TAlignment Alignment, Vcl::Wwtypes::TwwWriteTextOptions WriteOptions);
	virtual void __fastcall WriteTitleLines(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect, int DX, int DY, System::WideChar * s, System::Classes::TAlignment Alignment, Vcl::Wwtypes::TwwWriteTextOptions WriteOptions);
	virtual void __fastcall DoOnAfterDrawCell(TwwCustomDrawGridCellInfo* &DrawCellInfo);
	virtual void __fastcall DoOnBeforeDrawCell(System::WideString ATextWide, TwwCustomDrawGridCellInfo* &DrawCellInfo);
	DYNAMIC System::WideString __fastcall WideGetFieldValue(int ACol);
	virtual void __fastcall PaintCellBackground(int ACol, int ARow, const System::Types::TRect &ARect, Vcl::Grids::TGridDrawState AState);
	virtual void __fastcall DoOnCanShowCustomControl(Vcl::Controls::TWinControl* control, Data::Db::TField* tempField, bool &canShow);
	
public:
	Vcl::Wwgridfilter::TwwFormGridFilterTypes* FormGridFilterTypes;
	bool AlternatePaintBuffering;
	bool SkipHideControls;
	bool SkipDataChange;
	bool AlwaysShowControls;
	int MinRowHeightPercent;
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	virtual Vcl::Controls::TImageList* __fastcall EffectiveTitleImageList(void);
	bool __fastcall IsAlternatingRow(int DbRow);
	bool __fastcall UseAlternatingRow(int CurRelRow);
	bool __fastcall UseAlternatingRowFixed(int CurRelRow);
	virtual void __fastcall Sort(System::UnicodeString FieldName, bool descending);
	__property System::UnicodeString GroupFieldName = {read=GetGroupFieldName, write=SetGroupFieldName};
	__property int RowOffset = {read=FRowOffset, write=SetRowOffset, nodefault};
	__property System::Byte TitleOffset = {read=FTitleOffset, nodefault};
	__property bool CompareBookmarksAltMethod = {read=FCompareBookmarksAltMethod, write=FCompareBookmarksAltMethod, default=0};
	void __fastcall FormGridFilterTypesNeeded(void);
	virtual void __fastcall FillWithBlendBitmap(const System::Types::TRect &TempRect, int CurRelRow, System::Uitypes::TColor FillColor = (System::Uitypes::TColor)(0x1fffffff));
	virtual void __fastcall FillWithFixedBitmap(const System::Types::TRect &TempRect, int CurRelRow, System::Uitypes::TColor FillColor = (System::Uitypes::TColor)(0x1fffffff));
	void __fastcall UpdateCustomEdit(void);
	void __fastcall ResetProportionalWidths(void);
	bool __fastcall ShouldShowCustomControls(void);
	virtual bool __fastcall CanEditGrid(void);
	void __fastcall ClearURLPaint(void);
	Vcl::Controls::TWinControl* __fastcall ActiveExpandButton(void);
	HIDESBASE virtual void __fastcall CalcDrawInfo(Vcl::Grids::TGridDrawInfo &DrawInfo);
	bool __fastcall HasFocus(void);
	bool __fastcall IsActiveRowAlternatingColor(void);
	void __fastcall CollapseChildGrid(void);
	void __fastcall AddField(System::UnicodeString FieldName, int Position = 0xffffffff, bool Redraw = true);
	void __fastcall RemoveField(System::UnicodeString FieldName, bool Redraw = true);
	bool __fastcall HaveAnyRowLines(void);
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	virtual void __fastcall GetURLLink(System::UnicodeString value, System::UnicodeString &URLDisplayString, System::UnicodeString &URLLinkAddress);
	void __fastcall InvalidateCurrentRow(void);
	void __fastcall InvalidateFooter(void);
	virtual void __fastcall FlushChanges(void);
	void __fastcall UpdateRowCount(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall SizeLastColumn(void);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(bool Repaint = false);
	bool __fastcall IsCustomEditCell(int col, int row, Vcl::Controls::TWinControl* &customEdit);
	virtual System::Types::TRect __fastcall TitleCellRect(int ACol, int ARow, bool EntireTitle = false);
	virtual System::Types::TRect __fastcall SearchCellRect(int ACol, int ARow);
	virtual System::Types::TRect __fastcall GroupNameCellRect(int ACol, int ARow, int &StartCol, int &EndCol, bool VisibleOnly = true);
	virtual System::Types::TRect __fastcall DragTitleCellRect(int ACol, int X, int Y);
	HIDESBASE virtual System::Types::TRect __fastcall CellRect(int ACol, int ARow);
	void __fastcall RestoreRowHeights(void);
	virtual void __fastcall ApplySelected(void);
	virtual void __fastcall DoOnAddSelectColumn(Data::Db::TField* Field, System::UnicodeString &NodeGroups, bool &canAdd);
	void __fastcall PaintActiveRowBackground(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect);
	__fastcall virtual TwwCustomDBGrid(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwCustomDBGrid(void);
	bool __fastcall IsCheckBox(int col, int row, System::UnicodeString &checkboxon, System::UnicodeString &checkboxoff);
	virtual bool __fastcall IsMemoField(int ACol, int ARow);
	DYNAMIC bool __fastcall IsSelected(void);
	bool __fastcall AllowPerfectFit(void);
	bool __fastcall DoPerfectFit(void);
	bool __fastcall DoShrinkToFit(void);
	virtual void __fastcall SelectRecord(void);
	virtual void __fastcall UnselectRecord(void);
	void __fastcall SetPictureMask(System::UnicodeString FieldName, System::UnicodeString Mask);
	void __fastcall SetPictureAutoFill(System::UnicodeString FieldName, bool AutoFill);
	void __fastcall SetRegex(System::UnicodeString FieldName, System::UnicodeString Mask, bool CaseSensitive, System::UnicodeString ErrorMsg);
	void __fastcall ClearLastBookmarks(void);
	System::UnicodeString __fastcall FieldName(int ACol);
	System::Uitypes::TColor __fastcall GetHighlightColor(void);
	virtual bool __fastcall DittoField(Data::Db::TField* SelectedField, TwwDittoDirection Direction = (TwwDittoDirection)(0x0));
	virtual void __fastcall ShowPopupEditor(TwwColumn* Column, int X, int Y);
	void __fastcall DefaultDrawDataCell(const System::Types::TRect &Rect, Data::Db::TField* Field, Vcl::Grids::TGridDrawState State);
	virtual void __fastcall DoCalcTitleAttributes(System::UnicodeString AFieldName, Vcl::Graphics::TFont* AFont, Vcl::Graphics::TBrush* ABrush, System::Classes::TAlignment &FTitleAlignment);
	virtual void __fastcall DoCalcCellColors(Data::Db::TField* Field, Vcl::Grids::TGridDrawState State, bool Highlight, Vcl::Graphics::TFont* AFont, Vcl::Graphics::TBrush* ABrush);
	virtual void __fastcall DoCalcCellColorsDetect(Data::Db::TField* Field, Vcl::Grids::TGridDrawState State, bool Highlight, Vcl::Graphics::TFont* AFont, Vcl::Graphics::TBrush* ABrush);
	int __fastcall XIndicatorOffset(void);
	HIDESBASE Vcl::Controls::TWinControl* __fastcall GetComponent(System::UnicodeString thisName);
	int __fastcall GetEffectiveFooterHeight(void);
	virtual bool __fastcall ExecuteSelectGridColumnsDialog(System::UnicodeString curField, bool insertBefore = true);
	virtual void __fastcall DoInitSelectColumnsDialog(Vcl::Forms::TCustomForm* Form);
	HIDESBASE Vcl::Grids::TGridCoord __fastcall MouseCoord(int X, int Y);
	void __fastcall AutoSizeColumn(int ACol);
	bool __fastcall GetPriorRecordText(System::UnicodeString AFieldName, System::UnicodeString &AText);
	bool __fastcall GetNextRecordText(System::UnicodeString AFieldName, System::UnicodeString &AText);
	__property TwwGridDataLink* DataLink = {read=FDataLink};
	__property RowHeights;
	__property int ColWidthsPixels[int Index] = {read=GetColWidthsPixels, write=SetColWidthsPixels};
	__property EditorMode;
	__property int FieldCount = {read=GetFieldCount, nodefault};
	__property Data::Db::TField* Fields[int Index] = {read=GetFields};
	__property Data::Db::TField* SelectedField = {read=GetSelectedField, write=SetSelectedField};
	__property int SelectedIndex = {read=GetSelectedIndex, write=SetSelectedIndex, nodefault};
	__property TIndicatorColorType IndicatorColor = {read=FIndicatorColor, write=SetIndicatorColor, nodefault};
	__property System::Uitypes::TColor IndicatorIconColor = {read=FIndicatorIconColor, write=SetIndicatorIconColor, default=0};
	__property TwwDBGridOptions Options = {read=FOptions, write=SetOptions, default=7421};
	__property TwwDBGridKeyOptions KeyOptions = {read=FKeyOptions, write=FKeyOptions, default=6};
	__property System::Classes::TAlignment TitleAlignment = {read=FTitleAlignment, write=SetTitleAlignment, nodefault};
	__property int TitleLines = {read=FTitleLines, write=SetTitleLines, nodefault};
	__property TCalcCellColorsEvent OnCalcCellColors = {read=FOnCalcCellColors, write=FOnCalcCellColors};
	__property TCalcTitleAttributesEvent OnCalcTitleAttributes = {read=FOnCalcTitleAttributes, write=FOnCalcTitleAttributes};
	__property TwwDrawTitleCellEvent OnDrawTitleCell = {read=FOnDrawTitleCell, write=FOnDrawTitleCell};
	__property TwwDrawGroupHeaderCellEvent OnDrawGroupHeaderCell = {read=FOnDrawGroupHeaderCell, write=FOnDrawGroupHeaderCell};
	__property TwwCalcTitleImageEvent OnCalcTitleImage = {read=FOnCalcTitleImage, write=FOnCalcTitleImage};
	__property TTitleButtonClickEvent OnTitleButtonClick = {read=FOnTitleButtonClick, write=FOnTitleButtonClick};
	__property int RowHeightPercent = {read=FRowHeightPercent, write=SetRowHeightPercent, default=100};
	__property bool ShowVertScrollBar = {read=FShowVertScrollBar, write=SetShowVertScrollBar, default=1};
	__property bool ShowHorzScrollBar = {read=GetShowHorzScrollBar, write=SetShowHorzScrollBar, nodefault};
	__property Vcl::Wwdbedit::TwwValidateEvent OnCheckValue = {read=FOnCheckValue, write=FOnCheckValue};
	__property System::Classes::TNotifyEvent OnTopRowChanged = {read=FOnTopRowChanged, write=FOnTopRowChanged};
	__property System::Classes::TNotifyEvent OnRowChanged = {read=FOnRowChanged, write=FOnRowChanged};
	__property System::Classes::TNotifyEvent OnCellChanged = {read=FOnCellChanged, write=FOnCellChanged};
	__property TwwLeftColChangedEvent OnLeftColChanged = {read=FOnLeftColChanged, write=FOnLeftColChanged};
	__property TwwFieldChangedEvent OnFieldChanged = {read=FOnFieldChanged, write=FOnFieldChanged};
	__property System::Classes::TNotifyEvent OnUpdateFooter = {read=FOnUpdateFooter, write=FOnUpdateFooter};
	__property int CalcCellRow = {read=GetCalcCellRow, nodefault};
	__property int CalcCellCol = {read=FCalcCellCol, nodefault};
	__property bool TitleButtons = {read=FTitleButtons, write=SetTitleButtons, nodefault};
	__property bool EditCalculated = {read=FEditCalculated, write=FEditCalculated, default=0};
	__property TwwMultiSelectOptions MultiSelectOptions = {read=FMultiSelectOptions, write=FMultiSelectOptions, default=0};
	__property System::Classes::TStrings* Selected = {read=GetSelectedFields, write=SetSelectedFields};
	__property bool UseTFields = {read=FUseTFields, write=SetUseTFields, default=1};
	__property TwwIButton* IndicatorButton = {read=FIndicatorButton, write=FIndicatorButton, stored=false};
	__property Vcl::Controls::TImageList* ImageList = {read=FImageList, write=FImageList};
	__property Vcl::Controls::TImageList* TitleImageList = {read=FTitleImageList, write=FTitleImageList};
	__property TwwGridLineColors* LineColors = {read=FLineColors, write=FLineColors};
	__property TwwColumn* Columns[int Index] = {read=GetColumn};
	__property TwwColumn* FastColumns[int Index] = {read=GetFastColumn};
	TwwColumn* __fastcall ColumnByName(System::UnicodeString Index);
	__property TDrawFooterCellEvent OnDrawFooterCell = {read=FOnDrawFooterCell, write=FOnDrawFooterCell};
	__property TwwCreateGridHintWindowEvent OnCreateHintWindow = {read=FOnCreateHintWindow, write=FOnCreateHintWindow};
	__property System::Classes::TNotifyEvent OnBeforePaint = {read=FOnBeforePaint, write=FOnBeforePaint};
	__property TwwGridURLOpenEvent OnURLOpen = {read=FOnURLOpen, write=FOnURLOpen};
	__property Vcl::Graphics::TCanvas* Canvas = {read=GetCanvas};
	__property int DragVertOffset = {read=FDragVertOffset, write=FDragVertOffset, default=15};
	__property bool ControlInfoInDataset = {read=FControlInfoInDataset, write=FControlInfoInDataset, default=1};
	__property System::Classes::TStrings* ControlType = {read=FControlType, write=SetControlType};
	__property bool PictureMaskFromDataSet = {read=FPictureMaskFromDataSet, write=FPictureMaskFromDataSet, default=1};
	__property System::Classes::TStrings* PictureMasks = {read=FPictureMasks, write=SetPictureMasks};
	__property System::Classes::TStrings* RegexMasks = {read=FRegexMasks, write=SetRegexMasks};
	__property LeftCol;
	__property TwwPadColumnStyle PadColumnStyle = {read=FPadColumnStyle, write=FPadColumnStyle, default=2};
	__property TwwEditControlOptions EditControlOptions = {read=FEditControlOptions, write=FEditControlOptions, default=2};
	__property Vcl::Wwpaintoptions::TwwGridPaintOptions* PaintOptions = {read=FPaintOptions, write=FPaintOptions};
	__property TwwGridLineStyle LineStyle = {read=FLineStyle, write=FLineStyle, default=2};
	__property bool HideAllLines = {read=FHideAllLines, write=FHideAllLines, default=0};
	__property TwwCustomDrawCellEvent OnBeforeDrawCell = {read=FOnBeforeDrawCell, write=FOnBeforeDrawCell};
	__property TwwCustomDrawCellEvent OnAfterDrawCell = {read=FOnAfterDrawCell, write=FOnAfterDrawCell};
	__property TwwDittoEvent OnDitto = {read=FOnDitto, write=FOnDitto};
	__property TwwBeforeSortEvent OnBeforeMenuSort = {read=FOnBeforeSort, write=FOnBeforeSort};
	__property TwwSortEvent OnAfterMenuSort = {read=FOnAfterSort, write=FOnAfterSort};
	__property TwwCanGroupEvent OnCanGroup = {read=FOnCanGroup, write=FOnCanGroup};
	__property TwwCanSortEvent OnCanSort = {read=FOnCanSort, write=FOnCanSort};
	__property TwwCanFilterEvent OnCanFilter = {read=FOnCanFilter, write=FOnCanFilter};
	__property TwwCanShowTitleDropDownEvent OnCanShowTitleDropDown = {read=FOnCanShowTitleDropDown, write=FOnCanShowTitleDropDown};
	__property TwwQuerySortFieldEvent OnQuerySortField = {read=FOnQuerySortField, write=FOnQuerySortField};
	__property TwwPopupTitleDropDownEvent OnPopupTitleDropDown = {read=FOnPopupTitleDropDown, write=FOnPopupTitleDropDown};
	__property TwwBeforeTitleMenuEvent OnBeforeMenuGroup = {read=FOnBeforeGroup, write=FOnBeforeGroup};
	__property TwwBeforeTitleMenuEvent OnBeforeMenuClearGroup = {read=FOnBeforeClearGroup, write=FOnBeforeClearGroup};
	__property TwwBeforeTitleMenuEvent OnBeforeMenuColumnRemove = {read=FOnBeforeColumnRemove, write=FOnBeforeColumnRemove};
	__property TwwBeforeColumnAddEvent OnBeforeMenuColumnAdd = {read=FOnBeforeColumnAdd, write=FOnBeforeColumnAdd};
	__property TwwAddSelectColumnEvent OnAddSelectColumn = {read=FOnAddSelectColumn, write=FOnAddSelectColumn};
	__property TwwOnInitSelectColumnsDialogEvent OnInitSelectColumnsDialog = {read=FOnInitSelectColumnsDialog, write=FOnInitSelectColumnsDialog};
	__property TwwBeforeGetFilterRangeEvent OnBeforeMenuGetFilterRange = {read=FOnBeforeGetFilterRange, write=FOnBeforeGetFilterRange};
	__property TwwBeforeGetFilterValueEvent OnBeforeMenuGetFilterValue = {read=FOnBeforeGetFilterValue, write=FOnBeforeGetFilterValue};
	__property TwwOnCanShowCustomControlEvent OnCanShowCustomControl = {read=FOnCanShowCustomControl, write=FOnCanShowCustomControl};
	__property VisibleRowCount;
	__property TwwDittoAttributes* DittoAttributes = {read=FDittoAttributes, write=FDittoAttributes};
	__property TwwTitleMenuAttributes* TitleMenuAttributes = {read=FTitleMenuAttributes, write=FTitleMenuAttributes};
	__property bool DisableThemesInTitle = {read=FDisableThemesInTitle, write=FDisableThemesInTitle, default=0};
	__property bool ShowSearchRow = {read=FShowSearchRow, write=SetShowSearchRow, default=0};
	__property TwwGridSearchEditor* SearchEditor = {read=FSearchEditor};
	__property bool SearchMode = {read=FSearchMode, write=FSearchMode, default=0};
	__property bool TouchPan = {read=FTouchPan, write=FTouchPan, default=0};
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwCustomDBGrid(HWND ParentWindow) : Vcl::Grids::TCustomGrid(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwDBGridStyleHook : public Vcl::Forms::TScrollingStyleHook
{
	typedef Vcl::Forms::TScrollingStyleHook inherited;
	
private:
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMNCPaint(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMNCHitTest(Winapi::Messages::TWMNCHitTest &Message);
	
protected:
	virtual void __fastcall PaintNC(Vcl::Graphics::TCanvas* Canvas);
	virtual void __fastcall PaintBackground(Vcl::Graphics::TCanvas* Canvas);
	virtual void __fastcall DrawHorzScroll(HDC DC);
	virtual void __fastcall DrawVertScroll(HDC DC);
	
public:
	__fastcall virtual TwwDBGridStyleHook(Vcl::Controls::TWinControl* AControl);
public:
	/* TScrollingStyleHook.Destroy */ inline __fastcall virtual ~TwwDBGridStyleHook(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TwwUpdateSelected : unsigned char { sptUpdateField, sptUpdateWidth, sptUpdateLabel, sptUpdateReadOnly, sptUpdateGroup, sptUpdateIndex, sptUpdateVisible };

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE Vcl::Controls::TImageList* __fastcall wwGetIndicators(void);
extern DELPHI_PACKAGE Vcl::Controls::TImageList* __fastcall wwGetDefaultTitleImages(void);
extern DELPHI_PACKAGE void __fastcall UpdateSelectedProp(System::Classes::TStrings* Selected, System::UnicodeString FieldName, System::UnicodeString val, TwwUpdateSelected SelectedProperty, int Index = 0xffffffff);
extern DELPHI_PACKAGE void __fastcall UpdateSelectedPropWithGrid(TwwCustomDBGrid* Grid, System::Classes::TStrings* Selected, System::UnicodeString FieldName, System::UnicodeString val, TwwUpdateSelected SelectedProperty, int Index = 0xffffffff);
extern DELPHI_PACKAGE System::UnicodeString __fastcall GetSelectedProp(System::Classes::TStrings* Selected, System::UnicodeString FieldName, TwwUpdateSelected SelectedProperty);
extern DELPHI_PACKAGE void __fastcall wwWriteTextLines(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect, int DX, int DY, System::WideChar * s, System::Classes::TAlignment Alignment, Vcl::Wwtypes::TwwWriteTextOptions WriteOptions);
}	/* namespace Wwdbigrd */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWDBIGRD)
using namespace Vcl::Wwdbigrd;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwdbigrdHPP
