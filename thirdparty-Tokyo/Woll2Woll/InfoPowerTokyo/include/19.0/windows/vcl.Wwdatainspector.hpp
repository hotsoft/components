// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwdatainspector.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwdatainspectorHPP
#define Vcl_WwdatainspectorHPP

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
#include <Vcl.Grids.hpp>
#include <Data.DB.hpp>
#include <Vcl.DBCtrls.hpp>
#include <vcl.Wwstr.hpp>
#include <Vcl.StdCtrls.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.wwpict.hpp>
#include <vcl.Wwsystem.hpp>
#include <vcl.Wwdbdatetimepicker.hpp>
#include <vcl.Wwdbcomb.hpp>
#include <vcl.wwdblook.hpp>
#include <vcl.Wwdotdot.hpp>
#include <vcl.wwframe.hpp>
#include <vcl.wwriched.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <vcl.Wwbitmap.hpp>
#include <vcl.wwpaintoptions.hpp>
#include <Winapi.Imm.hpp>
#include <vcl.wwtypes.hpp>
#include <System.UITypes.hpp>
#include <System.Types.hpp>
#include <Vcl.Themes.hpp>
#include <Vcl.Mask.hpp>
#include <Vcl.Menus.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwdatainspector
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwInspectorHintWindow;
class DELPHICLASS TwwInspectorStyleHook;
class DELPHICLASS TwwDataInspectorDataLink;
class DELPHICLASS TwwInspectorPickList;
class DELPHICLASS TwwInspectorItem;
class DELPHICLASS TwwInspectorCollection;
class DELPHICLASS TwwDataInspectorEdit;
class DELPHICLASS TwwInspectorButtonOptions;
class DELPHICLASS TwwInspectorIndicatorRow;
class DELPHICLASS TwwDataInspector;
class DELPHICLASS TwwInspectorComboBox;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwInspectorHintWindow : public Vcl::Controls::THintWindow
{
	typedef Vcl::Controls::THintWindow inherited;
	
protected:
	virtual void __fastcall Paint(void);
	
public:
	Data::Db::TField* Field;
	bool WordWrap;
	System::Classes::TAlignment Alignment;
	bool CenterVertically;
public:
	/* THintWindow.Create */ inline __fastcall virtual TwwInspectorHintWindow(System::Classes::TComponent* AOwner) : Vcl::Controls::THintWindow(AOwner) { }
	
public:
	/* TCustomControl.Destroy */ inline __fastcall virtual ~TwwInspectorHintWindow(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwInspectorHintWindow(HWND ParentWindow) : Vcl::Controls::THintWindow(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwInspectorStyleHook : public Vcl::Forms::TScrollingStyleHook
{
	typedef Vcl::Forms::TScrollingStyleHook inherited;
	
private:
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMNCPaint(Winapi::Messages::TMessage &Message);
	
protected:
	virtual void __fastcall PaintNC(Vcl::Graphics::TCanvas* Canvas);
	virtual void __fastcall PaintBackground(Vcl::Graphics::TCanvas* Canvas);
	virtual void __fastcall DrawHorzScroll(HDC DC);
	virtual void __fastcall DrawVertScroll(HDC DC);
	
public:
	__fastcall virtual TwwInspectorStyleHook(Vcl::Controls::TWinControl* AControl);
public:
	/* TScrollingStyleHook.Destroy */ inline __fastcall virtual ~TwwInspectorStyleHook(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwDataInspectorDataLink : public Data::Db::TDataLink
{
	typedef Data::Db::TDataLink inherited;
	
private:
	TwwDataInspector* FObjectView;
	bool FInUpdateData;
	bool FModified;
	
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
	__fastcall TwwDataInspectorDataLink(TwwDataInspector* AObjectView);
	void __fastcall Modified(void);
	void __fastcall Reset(void);
	__property bool isFieldModified = {read=FModified, nodefault};
public:
	/* TDataLink.Destroy */ inline __fastcall virtual ~TwwDataInspectorDataLink(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwInspectorPickList : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Classes::TStrings* FItems;
	bool FMapped;
	bool FDisplayAsCheckbox;
	Vcl::Stdctrls::TComboBoxStyle FStyle;
	bool FShowMatchText;
	bool FAllowClearKey;
	Vcl::Wwframe::TwwComboButtonStyle FButtonStyle;
	Vcl::Graphics::TBitmap* FButtonGlyph;
	int FButtonWidth;
	void __fastcall SetItems(System::Classes::TStrings* val);
	void __fastcall SetButtonGlyph(Vcl::Graphics::TBitmap* Value);
	
protected:
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	
public:
	__fastcall TwwInspectorPickList(void);
	__fastcall virtual ~TwwInspectorPickList(void);
	
__published:
	__property System::Classes::TStrings* Items = {read=FItems, write=SetItems};
	__property bool MapList = {read=FMapped, write=FMapped, default=0};
	__property Vcl::Stdctrls::TComboBoxStyle Style = {read=FStyle, write=FStyle, default=0};
	__property bool ShowMatchText = {read=FShowMatchText, write=FShowMatchText, default=1};
	__property bool AllowClearKey = {read=FAllowClearKey, write=FAllowClearKey, default=0};
	__property Vcl::Wwframe::TwwComboButtonStyle ButtonStyle = {read=FButtonStyle, write=FButtonStyle, default=1};
	__property bool DisplayAsCheckbox = {read=FDisplayAsCheckbox, write=FDisplayAsCheckbox, default=0};
	__property Vcl::Graphics::TBitmap* ButtonGlyph = {read=FButtonGlyph, write=SetButtonGlyph};
	__property int ButtonWidth = {read=FButtonWidth, write=FButtonWidth, default=0};
};

#pragma pack(pop)

enum DECLSPEC_DENUM TwwInspectorItemOption : unsigned char { iioAutoDateTimePicker, iioAutoLookupCombo };

typedef System::Set<TwwInspectorItemOption, TwwInspectorItemOption::iioAutoDateTimePicker, TwwInspectorItemOption::iioAutoLookupCombo> TwwInspectorItemOptions;

typedef void __fastcall (__closure *TwwInspectorItemChanged)(TwwDataInspector* Sender, TwwInspectorItem* Item, System::UnicodeString NewValue);

typedef void __fastcall (__closure *TwwInspectorItemNotifyEvent)(TwwDataInspector* Sender, TwwInspectorItem* Item);

typedef void __fastcall (__closure *TwwInspectorNotifyEvent)(TwwDataInspector* Sender);

typedef void __fastcall (__closure *TwwInspectorOnCanShowEvent)(TwwDataInspector* Sender, TwwInspectorItem* Item, bool &canShow);

class PASCALIMPLEMENTATION TwwInspectorItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	System::UnicodeString FEditText;
	TwwInspectorCollection* FItems;
	bool FReadOnly;
	Vcl::Controls::TWinControl* FCustomControlName;
	bool FCustomControlAlwaysPaints;
	System::UnicodeString FCaption;
	int FCellHeight;
	System::UnicodeString FDataField;
	Vcl::Dbctrls::TFieldDataLink* FDataLink;
	bool FExpanded;
	TwwInspectorPickList* FPickList;
	Vcl::Wwdbedit::TwwDBPicture* FPicture;
	Vcl::Wwdbedit::TwwRegexMask* FRegexMask;
	TwwInspectorItem* FParentItem;
	bool FResizeable;
	bool FVisible;
	int FTag;
	System::UnicodeString FTagString;
	TwwInspectorItemOptions FOptions;
	bool FTabStop;
	TwwInspectorItemChanged FItemChanged;
	bool FWordWrap;
	bool FDisableDefaultEditor;
	bool FActiveRecord;
	TwwInspectorItemNotifyEvent FOnEditButtonClick;
	System::Classes::TAlignment FAlignment;
	bool FCustomControlHighlight;
	bool FEnabled;
	TwwInspectorOnCanShowEvent FOnCanShowCustomControl;
	void __fastcall SetItems(TwwInspectorCollection* Value);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	System::UnicodeString __fastcall GetDataField(void);
	void __fastcall SetDataField(const System::UnicodeString Value);
	void __fastcall SetCaption(const System::UnicodeString Value);
	System::Classes::TComponent* __fastcall GetControl(void);
	Data::Db::TField* __fastcall GetField(void);
	void __fastcall SetCellHeight(const int Value);
	int __fastcall GetLevel(void);
	void __fastcall SetCustomControl(Vcl::Controls::TWinControl* val);
	void __fastcall SetVisible(bool val);
	void __fastcall SetExpanded(bool val);
	bool __fastcall GetChecked(void);
	void __fastcall SetChecked(bool val);
	Data::Db::TDataLink* __fastcall GetDataLink(void);
	System::UnicodeString __fastcall GetDisplayText(void);
	void __fastcall SetDisplayText(System::UnicodeString val);
	void __fastcall SetEditText(System::UnicodeString val);
	
protected:
	System::Types::TPoint ButtonPoint;
	__property Data::Db::TDataLink* DataLink = {read=GetDataLink};
	virtual bool __fastcall HaveItems(void);
	Vcl::Controls::TControl* __fastcall GetDesigner(void);
	virtual void __fastcall DefineProperties(System::Classes::TFiler* Filer);
	virtual void __fastcall DoItemTextChanged(void);
	bool __fastcall UseDefaultComboBox(void);
	virtual System::UnicodeString __fastcall GetMappedPaintText(System::UnicodeString StoredValue);
	
public:
	__fastcall virtual TwwInspectorItem(System::Classes::TCollection* Collection);
	__fastcall virtual ~TwwInspectorItem(void);
	bool __fastcall HaveVisibleItem(void);
	virtual System::UnicodeString __fastcall GetDisplayName(void);
	DYNAMIC System::UnicodeString __fastcall GetNamePath(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	__property bool ActiveRecord = {read=FActiveRecord, write=FActiveRecord, nodefault};
	__property Data::Db::TField* Field = {read=GetField};
	__property System::Classes::TComponent* Control = {read=GetControl};
	__property int Level = {read=GetLevel, nodefault};
	__property TwwInspectorItem* ParentItem = {read=FParentItem, write=FParentItem};
	TwwInspectorItem* __fastcall GetFirstChild(bool VisibleItemsOnly = true, bool ExpandedOnly = false);
	TwwInspectorItem* __fastcall GetLastChild(bool VisibleItemsOnly = true, bool ExpandedOnly = false);
	TwwInspectorItem* __fastcall GetPrior(bool VisibleItemsOnly = true, bool ExpandedOnly = false);
	TwwInspectorItem* __fastcall GetNext(bool VisibleItemsOnly = true, bool ExpandedOnly = false);
	TwwInspectorItem* __fastcall GetNextSibling(bool VisibleItemsOnly = true);
	TwwInspectorItem* __fastcall GetPriorSibling(bool VisibleItemsOnly = true);
	__property bool Checked = {read=GetChecked, write=SetChecked, nodefault};
	__property System::UnicodeString DisplayText = {read=GetDisplayText, write=SetDisplayText};
	
__published:
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property int CellHeight = {read=FCellHeight, write=SetCellHeight, default=0};
	__property System::UnicodeString EditText = {read=FEditText, write=SetEditText};
	__property System::Classes::TAlignment Alignment = {read=FAlignment, write=FAlignment, default=0};
	__property bool ReadOnly = {read=FReadOnly, write=FReadOnly, default=0};
	__property Vcl::Controls::TWinControl* CustomControl = {read=FCustomControlName, write=SetCustomControl};
	__property bool CustomControlAlwaysPaints = {read=FCustomControlAlwaysPaints, write=FCustomControlAlwaysPaints, default=1};
	__property bool CustomControlHighlight = {read=FCustomControlHighlight, write=FCustomControlHighlight, default=0};
	__property bool Expanded = {read=FExpanded, write=SetExpanded, default=0};
	__property TwwInspectorPickList* PickList = {read=FPickList, write=FPickList};
	__property Vcl::Wwdbedit::TwwDBPicture* Picture = {read=FPicture, write=FPicture};
	__property Vcl::Wwdbedit::TwwRegexMask* RegexMask = {read=FRegexMask, write=FRegexMask};
	__property bool Resizeable = {read=FResizeable, write=FResizeable, default=0};
	__property TwwInspectorCollection* Items = {read=FItems, write=SetItems, stored=HaveItems};
	__property bool Visible = {read=FVisible, write=SetVisible, default=1};
	__property int Tag = {read=FTag, write=FTag, default=0};
	__property System::UnicodeString TagString = {read=FTagString, write=FTagString};
	__property bool TabStop = {read=FTabStop, write=FTabStop, default=1};
	__property TwwInspectorItemOptions Options = {read=FOptions, write=FOptions, default=1};
	__property bool WordWrap = {read=FWordWrap, write=FWordWrap, nodefault};
	__property bool DisableDefaultEditor = {read=FDisableDefaultEditor, write=FDisableDefaultEditor, default=0};
	__property bool Enabled = {read=FEnabled, write=FEnabled, default=1};
	__property TwwInspectorItemChanged OnItemChanged = {read=FItemChanged, write=FItemChanged};
	__property TwwInspectorItemNotifyEvent OnEditButtonClick = {read=FOnEditButtonClick, write=FOnEditButtonClick};
	__property TwwInspectorOnCanShowEvent OnCanShowCustomControl = {read=FOnCanShowCustomControl, write=FOnCanShowCustomControl};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwInspectorCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
public:
	TwwInspectorItem* operator[](int Index) { return this->Items[Index]; }
	
private:
	TwwInspectorItem* FParentItem;
	HIDESBASE TwwInspectorItem* __fastcall GetItem(int Index);
	HIDESBASE void __fastcall SetItem(int Index, TwwInspectorItem* Value);
	
protected:
	DYNAMIC System::Classes::TPersistent* __fastcall GetOwner(void);
	virtual void __fastcall Update(System::Classes::TCollectionItem* Item);
	
public:
	System::Classes::TComponent* Control;
	__property TwwInspectorItem* ParentItem = {read=FParentItem};
	__fastcall TwwInspectorCollection(System::Classes::TComponent* Control);
	__fastcall virtual ~TwwInspectorCollection(void);
	HIDESBASE TwwInspectorItem* __fastcall Add(void);
	HIDESBASE TwwInspectorItem* __fastcall Insert(int Index);
	void __fastcall SaveToStream(System::Classes::TStream* s);
	void __fastcall LoadFromStream(System::Classes::TStream* s);
	void __fastcall SaveToFile(const System::UnicodeString FileName);
	void __fastcall LoadFromFile(const System::UnicodeString FileName);
	__property TwwInspectorItem* Items[int Index] = {read=GetItem, write=SetItem/*, default*/};
};

#pragma pack(pop)

typedef void __fastcall (__closure *TwwInspectorItemCallback)(TwwInspectorItem* obj, void * UserData, bool &AContinue);

enum DECLSPEC_DENUM TwwDataInspectorOption : unsigned char { ovColumnResize, ovRowResize, ovTabExits, ovEnterToTab, ovHighlightActiveRow, ovHideVertDataLines, ovCenterCaptionVert, ovTabToVisibleOnly, ovShowTreeLines, ovShowCaptionHints, ovShowCellHints, ovFillNonCellArea, ovActiveRecord3DLines, ovAllowInsert, ovHideCaptionColumn, ovHideVertFixedLines, ovUseOwnBackgroundColors };

typedef System::Set<TwwDataInspectorOption, TwwDataInspectorOption::ovColumnResize, TwwDataInspectorOption::ovUseOwnBackgroundColors> TwwDataInspectorOptions;

enum DECLSPEC_DENUM TwwDataInspectorLineStyle : unsigned char { ovNoLines, ovDottedLine, ovLight3DLine, ovDark3DLine, ovButtonLine };

typedef void __fastcall (__closure *TwwInspectorCalcCustomEditEvent)(TwwDataInspector* Sender, TwwInspectorItem* Item, Vcl::Controls::TWinControl* CustomEdit, bool &AllowCustomEdit);

typedef void __fastcall (__closure *TwwInspectorDrawDataCellEvent)(TwwDataInspector* Sender, TwwInspectorItem* ObjItem, bool ASelected, const System::Types::TRect &ACellRect, bool &DefaultDrawing);

typedef void __fastcall (__closure *TwwInspectorDrawICellEvent)(TwwDataInspector* Sender, int ACol, const System::Types::TRect &ACellRect, bool &DefaultDrawing);

typedef void __fastcall (__closure *TwwInspectorDrawCaptionEvent)(TwwDataInspector* Sender, TwwInspectorItem* ObjItem, bool ASelected, const System::Types::TRect &ACellRect, System::Types::TRect &ACaptionRect, bool &DefaultTextDrawing);

class PASCALIMPLEMENTATION TwwDataInspectorEdit : public Vcl::Grids::TInplaceEdit
{
	typedef Vcl::Grids::TInplaceEdit inherited;
	
private:
	Vcl::Wwdbedit::TwwDBPicture* FwwPicture;
	Vcl::Wwdbedit::TwwRegexMask* FRegexMask;
	bool FWordWrap;
	TwwDataInspector* ParentGrid;
	bool FUsePictureMask;
	System::Uitypes::TColor OrigForeColor;
	System::Uitypes::TColor OrigBackColor;
	Vcl::Controls::TControlCanvas* FCanvas;
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPaste(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	
protected:
	virtual void __fastcall BoundsChanged(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	DYNAMIC void __fastcall KeyUp(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	void __fastcall SetWordWrap(bool val);
	virtual void __fastcall UpdateContents(void);
	
public:
	__fastcall virtual TwwDataInspectorEdit(System::Classes::TComponent* AOwner, int dummy);
	__fastcall virtual ~TwwDataInspectorEdit(void);
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
	/* TInplaceEdit.Create */ inline __fastcall virtual TwwDataInspectorEdit(System::Classes::TComponent* AOwner) : Vcl::Grids::TInplaceEdit(AOwner) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDataInspectorEdit(HWND ParentWindow) : Vcl::Grids::TInplaceEdit(ParentWindow) { }
	
};


typedef void __fastcall (__closure *TwwInspectorFieldChangedEvent)(TwwDataInspector* Sender, Data::Db::TField* Field);

typedef void __fastcall (__closure *TwwInspectorCreateDTPEvent)(TwwDataInspector* Sender, Vcl::Wwdbdatetimepicker::TwwDBCustomDateTimePicker* ADateTimePicker);

typedef void __fastcall (__closure *TwwInspectorCreateComboEvent)(TwwDataInspector* Sender, Vcl::Wwdbcomb::TwwDBComboBox* Combo);

typedef void __fastcall (__closure *TwwInspectorBeforeSelectCellEvent)(TwwDataInspector* Sender, TwwInspectorItem* ObjItem, bool &CanSelect);

typedef void __fastcall (__closure *TwwInspectorAfterSelectCellEvent)(TwwDataInspector* Sender, TwwInspectorItem* ObjItem);

typedef void __fastcall (__closure *TwwInspectorCanExpandEvent)(TwwDataInspector* Sender, TwwInspectorItem* ObjItem, bool &CanExpand);

typedef void __fastcall (__closure *TwwInspectorCanCollapseEvent)(TwwDataInspector* Sender, TwwInspectorItem* ObjItem, bool &CanCollapse);

typedef void __fastcall (__closure *TwwInspectorExpandedEvent)(TwwDataInspector* Sender, TwwInspectorItem* ObjItem);

typedef void __fastcall (__closure *TwwInspectorCollapsedEvent)(TwwDataInspector* Sender, TwwInspectorItem* ObjItem);

enum DECLSPEC_DENUM TwwInspectorTabSetFocusStyle : unsigned char { itsPreserveActiveItem, itsResetActiveItem };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwInspectorButtonOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	Vcl::Graphics::TBitmap* FExpandGlyph;
	Vcl::Graphics::TBitmap* FCollapseGlyph;
	Vcl::Controls::TWinControl* Control;
	bool FTransparentGlyphs;
	void __fastcall SetExpandGlyph(Vcl::Graphics::TBitmap* Value);
	void __fastcall SetCollapseGlyph(Vcl::Graphics::TBitmap* Value);
	
public:
	__fastcall TwwInspectorButtonOptions(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwInspectorButtonOptions(void);
	
__published:
	__property Vcl::Graphics::TBitmap* ExpandGlyph = {read=FExpandGlyph, write=SetExpandGlyph};
	__property Vcl::Graphics::TBitmap* CollapseGlyph = {read=FCollapseGlyph, write=SetCollapseGlyph};
	__property bool TransparentGlyphs = {read=FTransparentGlyphs, write=FTransparentGlyphs, default=0};
};

#pragma pack(pop)

typedef void __fastcall (__closure *TwwInspectorPaintTextEvent)(TwwDataInspector* Sender, TwwInspectorItem* Item, System::UnicodeString &PaintText);

typedef void __fastcall (__closure *TwwInspectorValidationError)(TwwDataInspector* Sender, TwwInspectorItem* Item, System::UnicodeString &Msg, bool &DoDefault);

typedef void __fastcall (__closure *TwwCreateInspectorHintWindowEvent)(System::TObject* Sender, TwwInspectorHintWindow* HintWindow, Data::Db::TField* AField, const System::Types::TRect &R, bool &WordWrap, int &MaxWidth, int &MaxHeight, bool &DoDefault);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwInspectorIndicatorRow : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	bool FEnabled;
	System::UnicodeString FCaption;
	int FHeight;
	System::Uitypes::TColor FColor;
	System::Classes::TAlignment FTextAlignment;
	void __fastcall SetColor(System::Uitypes::TColor Value);
	void __fastcall SetEnabled(bool Value);
	void __fastcall SetHeight(int Value);
	void __fastcall SetCaption(System::UnicodeString Value);
	void __fastcall SetTextAlignment(System::Classes::TAlignment Value);
	
public:
	TwwDataInspector* Inspector;
	__fastcall TwwInspectorIndicatorRow(System::Classes::TComponent* Owner);
	void __fastcall Invalidate(void);
	
__published:
	__property System::Classes::TAlignment TextAlignment = {read=FTextAlignment, write=SetTextAlignment, default=0};
	__property System::Uitypes::TColor Color = {read=FColor, write=SetColor, default=-16777201};
	__property bool Enabled = {read=FEnabled, write=SetEnabled, default=0};
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property int Height = {read=FHeight, write=SetHeight, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwInspectorIndicatorRow(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwDataInspector : public Vcl::Grids::TCustomGrid
{
	typedef Vcl::Grids::TCustomGrid inherited;
	
private:
	bool SkipUpdateCustomControlInFocus;
	int NewMouseRow;
	Vcl::Controls::TImageList* FIndicators;
	TwwInspectorDrawDataCellEvent FOnDrawDataCell;
	TwwInspectorDrawICellEvent FOnDrawIndicatorCell;
	System::Classes::TNotifyEvent FOnTopLeftChanged;
	TwwInspectorCalcCustomEditEvent FOnCalcCustomEdit;
	TwwDataInspectorOptions FOptions;
	Vcl::Wwpaintoptions::TwwGridPaintOptions* FPaintOptions;
	Vcl::Controls::TControl* FDesigner;
	TwwInspectorCollection* FItems;
	TwwDataInspectorDataLink* FDataLink;
	int FCaptionWidth;
	System::Uitypes::TColor FInactiveFocusColor;
	System::UnicodeString FEditText;
	int FSizingIndex;
	int FSizingPos;
	int FSizingOfs;
	Vcl::Wwdbedit::TwwValidateEvent FOnCheckValue;
	TwwInspectorFieldChangedEvent FOnFieldChanged;
	TwwInspectorItemChanged FOnItemChanged;
	bool FReadOnly;
	int FCaptionIndent;
	Vcl::Wwdbdatetimepicker::TwwDBCustomDateTimePicker* FDateTimePicker;
	Vcl::Wwdbcomb::TwwDBComboBox* FCombo;
	TwwInspectorCreateDTPEvent FOnCreateDateTimePicker;
	TwwInspectorCreateComboEvent FOnCreateDefaultCombo;
	bool FPictureMaskFromDataSet;
	int FDefaultRowHeight;
	Vcl::Graphics::TFont* FCaptionFont;
	TwwDataInspectorLineStyle FLineStyleData;
	TwwDataInspectorLineStyle FLineStyleCaption;
	System::Uitypes::TColor FDottedLineColor;
	int FUpdateCount;
	bool InvalidateInEndUpdate;
	TwwInspectorButtonOptions* FButtonOptions;
	TwwInspectorTabSetFocusStyle FSetFocusTabStyle;
	TwwInspectorDrawCaptionEvent FOnDrawCaptionCell;
	TwwInspectorNotifyEvent FOnBeforePaint;
	Vcl::Grids::TGetEditEvent FOnGetEditMask;
	TwwInspectorBeforeSelectCellEvent FOnBeforeSelectCell;
	TwwInspectorAfterSelectCellEvent FOnAfterSelectCell;
	TwwInspectorCanExpandEvent FOnCanExpand;
	TwwInspectorCanCollapseEvent FOnCanCollapse;
	TwwInspectorExpandedEvent FOnExpanded;
	TwwInspectorCollapsedEvent FOnCollapsed;
	TwwInspectorPaintTextEvent FOnCalcDataPaintText;
	TwwInspectorValidationError FOnValidationErrorUsingMask;
	TwwCreateInspectorHintWindowEvent FOnCreateHintWindow;
	bool TextIsSame;
	int LastDefaultRowHeight;
	bool SkipErase;
	bool CheckRowCount;
	Vcl::Graphics::TCanvas* FPaintCanvas;
	Vcl::Graphics::TBitmap* FPaintBitmap;
	bool UseTempCanvas;
	bool OldDesigning;
	TwwInspectorItem* LastActiveItem;
	TwwInspectorItem* FActiveItem;
	TwwInspectorItem* FTopItem;
	int FMinRowHeight;
	int OldTopRow;
	bool DoBeginUpdateInSelectCell;
	System::Types::TRect SelectCellUpdateRect;
	bool ChildDataChanged;
	int FDataColumns;
	System::Uitypes::TColor FTreeLineColor;
	int FFixedDataRows;
	int lastMouseX;
	int lastMouseY;
	Vcl::Controls::THintWindow* HintWindow;
	Vcl::Extctrls::TTimer* HintTimer;
	int HintTimerCount;
	bool FCustomControlKeyMode;
	System::Types::TRect UpdateRect;
	System::Types::TRect OldBoundsRect;
	System::Uitypes::TScrollStyle FScrollBars;
	TwwInspectorIndicatorRow* FIndicatorRow;
	System::Uitypes::TColor PaintCopyTextColor;
	bool SkipSetFocus;
	bool SkipUpdateEditText;
	Vcl::Grids::TGridCoord lastMouseCoord;
	int HotCol;
	int HotRow;
	bool FDisableThemes;
	
private:
	// __classmethod void __fastcall Create@();
	
private:
	void __fastcall HintTimerEvent(System::TObject* Sender);
	void __fastcall EditingChanged(void);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	void __fastcall SetCaptionWidth(int Value);
	void __fastcall FieldChanged(Data::Db::TField* Field);
	void __fastcall RecordChanged(Data::Db::TField* Field);
	void __fastcall UpdateData(void);
	int __fastcall GetPageHeight(void);
	bool __fastcall InValidColSizingArea(int x);
	Vcl::Wwdbdatetimepicker::TwwDBCustomDateTimePicker* __fastcall GetDateTimePicker(void);
	int __fastcall DataRow(int ARow);
	HIDESBASE MESSAGE void __fastcall WMVScroll(Winapi::Messages::TWMScroll &Message);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Message);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Msg);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSetCursor(Winapi::Messages::TWMSetCursor &Msg);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMHScroll(Winapi::Messages::TWMScroll &Message);
	MESSAGE void __fastcall CMGetDataLink(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	bool __fastcall IsHighlightRowVisible(void);
	void __fastcall GetActiveItemCallback(TwwInspectorItem* Item, void * UserData, bool &AContinue);
	void __fastcall GetActiveRowsCallback(TwwInspectorItem* Item, void * UserData, bool &AContinue);
	void __fastcall ApplySettingsCallback(TwwInspectorItem* Item, void * UserData, bool &AContinue);
	void __fastcall LinkActiveCallback(TwwInspectorItem* Item, void * UserData, bool &AContinue);
	int __fastcall GetActiveRows(void);
	void __fastcall SetCaptionIndent(int val);
	void __fastcall SetItems(TwwInspectorCollection* Value);
	HIDESBASE void __fastcall SetOptions(TwwDataInspectorOptions Value);
	HIDESBASE void __fastcall SetDefaultRowHeight(int Value);
	void __fastcall SetCaptionFont(Vcl::Graphics::TFont* Value);
	void __fastcall CaptionFontChanged(System::TObject* Sender);
	void __fastcall ToggleCheckbox(TwwInspectorItem* obj);
	void __fastcall SetLineStyleCaption(TwwDataInspectorLineStyle val);
	void __fastcall SetLineStyleData(TwwDataInspectorLineStyle val);
	void __fastcall SetUpdateState(bool Updating);
	bool __fastcall isFocused(void);
	void __fastcall SetActiveItem(TwwInspectorItem* obj);
	TwwInspectorItem* __fastcall GetActiveItem(void);
	System::Uitypes::TColor __fastcall GetCaptionColor(void);
	System::Uitypes::TColor __fastcall GetTreeLineColor(void);
	void __fastcall SetCaptionColor(System::Uitypes::TColor val);
	void __fastcall SetTreeLineColor(System::Uitypes::TColor val);
	TwwInspectorItem* __fastcall GetTopItem(void);
	void __fastcall UpdateRowCount(void);
	void __fastcall EditDataLinkDataChange(System::TObject* Sender);
	void __fastcall EditDataLinkUpdateData(System::TObject* Sender);
	Vcl::Controls::TWinControl* __fastcall GetActiveEdit(void);
	void __fastcall SetDottedLineColor(System::Uitypes::TColor val);
	void __fastcall SetDataColumns(int val);
	HIDESBASE void __fastcall SetScrollBars(System::Uitypes::TScrollStyle Value);
	void __fastcall SetFixedDataRows(int Value);
	
protected:
	Vcl::Controls::TWinControl* CurrentCustomEdit;
	int CurrentCustomEditRow;
	int CurrentCustomEditCol;
	bool InTracking;
	bool FFocused;
	bool FastDesign;
	Vcl::Wwriched::TwwDBRichEdit* TempRichEdit;
	DYNAMIC int __fastcall GetEditLimit(void);
	DYNAMIC bool __fastcall CanEditAcceptKey(System::WideChar Key);
	virtual void __fastcall CurrentCustomEditSetfocus(void);
	virtual void __fastcall DoCalcCustomEdit(TwwInspectorItem* Item, Vcl::Controls::TWinControl* CustomEdit, bool &AllowCustomEdit);
	virtual bool __fastcall RecordCountIsValid(void);
	virtual System::Types::TRect __fastcall GetClientRect(void);
	virtual void __fastcall UpdateScrollBar(void);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall Scroll(int Distance);
	virtual Vcl::Controls::THintWindow* __fastcall CreateHintWindow(void);
	virtual void __fastcall HintMouseMove(System::Classes::TShiftState Shift, int x, int Y);
	virtual void __fastcall DisplayIndicatorCell(int ACol, const System::Types::TRect &ARect);
	bool __fastcall EffectiveFocused(void);
	virtual void __fastcall DoCreateHintWindow(TwwInspectorHintWindow* HintWindow, Data::Db::TField* AField, const System::Types::TRect &R, bool &WordWrap, int &MaxWidth, int &MaxHeight, bool &DoDefault);
	void __fastcall UpdateCurrentEditPosition(void);
	System::Types::TRect __fastcall ControlRect(int ACol, int ARow);
	void __fastcall UpdateCustomEdit(void);
	virtual void __fastcall FreeHintWindow(void);
	HIDESBASE bool __fastcall IsActiveControl(void);
	void __fastcall ChangeOrientation(bool RightToLeftOrientation);
	void __fastcall InheritedPaint(void);
	virtual void __fastcall FirstTimePaint(void);
	virtual void __fastcall SetDesigner(Vcl::Controls::TControl* Value);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual Vcl::Wwdbdatetimepicker::TwwDBCustomDateTimePicker* __fastcall CreateDateTimePicker(void);
	virtual Vcl::Wwdbcomb::TwwDBComboBox* __fastcall CreateDefaultCombo(void);
	virtual void __fastcall DoCreateDateTimePicker(Vcl::Wwdbdatetimepicker::TwwDBCustomDateTimePicker* ADateTimePicker);
	virtual void __fastcall DoCreateDefaultCombo(Vcl::Wwdbcomb::TwwDBComboBox* ACombo);
	virtual void __fastcall LinkActive(bool Value);
	DYNAMIC bool __fastcall CanEditModify(void);
	virtual void __fastcall DoFieldChanged(Data::Db::TField* Field);
	virtual void __fastcall DoItemChanged(TwwInspectorItem* Item, System::UnicodeString NewValue);
	virtual Vcl::Grids::TInplaceEdit* __fastcall CreateEditor(void);
	DYNAMIC void __fastcall DoExit(void);
	DYNAMIC void __fastcall TopLeftChanged(void);
	virtual bool __fastcall CanEditShow(void);
	virtual void __fastcall DrawCell(int ACol, int ARow, const System::Types::TRect &ARect, Vcl::Grids::TGridDrawState AState);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int x, int Y);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int x, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int x, int Y);
	virtual void __fastcall CalcSizingState(int x, int Y, Vcl::Grids::TGridState &State, int &Index, int &SizingPos, int &SizingOfs, Vcl::Grids::TGridDrawInfo &FixedInfo);
	virtual void __fastcall UpdateDataColumnWidth(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	DYNAMIC System::UnicodeString __fastcall GetEditText(int ACol, int ARow);
	DYNAMIC System::UnicodeString __fastcall GetEditMask(int ACol, int ARow);
	DYNAMIC void __fastcall SetEditText(int ACol, int ARow, const System::UnicodeString Value);
	virtual void __fastcall Loaded(void);
	virtual bool __fastcall AcquireFocus(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall Paint(void);
	virtual void __fastcall SetFocusCell(int ACol, int ARow);
	virtual bool __fastcall SelectCell(int ACol, int ARow);
	virtual void __fastcall DataChanged(void);
	virtual void __fastcall UpdateActive(void);
	Data::Db::TField* __fastcall GetField(int ARow);
	virtual bool __fastcall UseDefaultEditor(void);
	virtual bool __fastcall UseCheckbox(int ARow);
	virtual System::Types::TPoint __fastcall ButtonPt(const System::Types::TRect &ARect, TwwInspectorItem* obj);
	virtual System::Types::TRect __fastcall CheckboxRect(const System::Types::TRect &ARect, TwwInspectorItem* obj);
	HIDESBASE void __fastcall DrawSizingLine(const Vcl::Grids::TGridDrawInfo &DrawInfo);
	DYNAMIC void __fastcall RowHeightsChanged(void);
	virtual void __fastcall DoDrawDataCell(TwwInspectorItem* ObjItem, bool ASelected, const System::Types::TRect &ACellRect, bool &DefaultDrawing);
	virtual void __fastcall InitCustomEdit(Vcl::Controls::TWinControl* CustomEdit, TwwInspectorItem* obj);
	virtual void __fastcall DoDrawCaptionCell(TwwInspectorItem* ObjItem, bool ASelected, const System::Types::TRect &ACellRect, System::Types::TRect &ACaptionRect, bool &DefaultTextDrawing);
	virtual Vcl::Graphics::TCanvas* __fastcall GetCanvas(void);
	bool __fastcall IsDefaultDateTimePicker(TwwInspectorItem* obj);
	bool __fastcall IsDefaultLookupCombo(TwwInspectorItem* obj);
	virtual void __fastcall DoCollapse(TwwInspectorItem* ObjItem);
	virtual void __fastcall DoExpand(TwwInspectorItem* ObjItem);
	DYNAMIC void __fastcall Click(void);
	virtual void __fastcall PaintLines(TwwInspectorItem* Item);
	DYNAMIC bool __fastcall DoMouseWheelDown(System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos);
	DYNAMIC bool __fastcall DoMouseWheelUp(System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos);
	virtual void __fastcall DoCalcDataPaintText(TwwInspectorItem* Item, System::UnicodeString &PaintText);
	virtual void __fastcall ValidationErrorUsingMask(TwwInspectorItem* Item);
	virtual void __fastcall FillWithFixedBitmap(const System::Types::TRect &TempRect, int CurRelRow);
	virtual void __fastcall FillWithAlternatingRowBitmap(const System::Types::TRect &TempRect);
	virtual void __fastcall WriteTextLines(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect, int DX, int DY, System::WideChar * s, System::Classes::TAlignment Alignment, Vcl::Wwtypes::TwwWriteTextOptions WriteOptions);
	virtual void __fastcall WriteTitleLines(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect, int DX, int DY, System::WideChar * s, System::Classes::TAlignment Alignment, Vcl::Wwtypes::TwwWriteTextOptions WriteOptions);
	virtual void __fastcall DoOnCanShowCustomControl(TwwInspectorItem* Item, bool &canShow);
	__property System::Uitypes::TColor InactiveFocusColor = {read=FInactiveFocusColor, write=FInactiveFocusColor, default=536870911};
	__property TwwInspectorItem* TopItem = {read=GetTopItem};
	
public:
	__property Col;
	__property ColWidths;
	__property EditorMode;
	__property GridHeight;
	__property GridWidth;
	__property LeftCol;
	__property Selection;
	__property Row;
	__property RowHeights;
	__property TabStops;
	__property TopRow;
	__property RowCount = {default=5};
	__property Vcl::Controls::TWinControl* ActiveEdit = {read=GetActiveEdit};
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	__property TwwDataInspectorDataLink* DataLink = {read=FDataLink};
	__property Vcl::Wwdbdatetimepicker::TwwDBCustomDateTimePicker* DefaultDateTimePicker = {read=GetDateTimePicker};
	__property Vcl::Wwdbcomb::TwwDBComboBox* DefaultCombo = {read=FCombo};
	__property Vcl::Graphics::TCanvas* Canvas = {read=GetCanvas};
	__property bool CustomControlKeyMode = {read=FCustomControlKeyMode, write=FCustomControlKeyMode, nodefault};
	DYNAMIC void __fastcall GetChildren(System::Classes::TGetChildProc Proc, System::Classes::TComponent* Root);
	System::Types::TRect __fastcall LevelRect(TwwInspectorItem* Item);
	void __fastcall MouseToCell(int x, int Y, int &ACol, int &ARow);
	TwwInspectorItem* __fastcall MouseToItem(int x, int Y);
	TwwInspectorItem* __fastcall RefreshActiveItem(void);
	void __fastcall BeginUpdate(void);
	void __fastcall EndUpdate(bool Repaint = false);
	__fastcall virtual TwwDataInspector(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDataInspector(void);
	void __fastcall ApplySettings(void);
	virtual void __fastcall RefreshItem(TwwInspectorItem* Item);
	virtual int __fastcall GetRowByItem(TwwInspectorItem* AItem);
	void __fastcall IterateItems(TwwInspectorItemCallback CallBack, bool ExpandedOnly, void * UserData);
	HIDESBASE void __fastcall InvalidateRow(int ARow);
	void __fastcall InvalidateRowCol(int ARow, int ACol = 0xffffffff);
	TwwInspectorItem* __fastcall GetItemByFieldName(System::UnicodeString AFieldName);
	virtual TwwInspectorItem* __fastcall GetItemByRow(int ARow, bool Optimize = true);
	TwwInspectorItem* __fastcall GetItemByCaption(System::UnicodeString ACaption);
	TwwInspectorItem* __fastcall GetItemByTagString(System::UnicodeString ATagString);
	bool __fastcall HaveVisibleItem(void);
	TwwInspectorItem* __fastcall GetFirstChild(bool VisibleItemsOnly = true);
	void __fastcall FlushContents(void);
	__property Vcl::Controls::TControl* Designer = {read=FDesigner, write=SetDesigner};
	__property int ActiveRows = {read=GetActiveRows, nodefault};
	__property InplaceEditor;
	__property TwwInspectorItem* ActiveItem = {read=GetActiveItem, write=SetActiveItem};
	__property TwwInspectorFieldChangedEvent OnFieldChanged = {read=FOnFieldChanged, write=FOnFieldChanged};
	__property int FixedDataRows = {read=FFixedDataRows, write=SetFixedDataRows, default=0};
	
__published:
	__property bool DisableThemes = {read=FDisableThemes, write=FDisableThemes, nodefault};
	__property Align = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property BorderStyle = {default=1};
	__property Color = {default=-16777201};
	__property Constraints;
	__property Ctl3D;
	__property DragCursor = {default=-12};
	__property DragKind = {default=0};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property System::Uitypes::TColor CaptionColor = {read=GetCaptionColor, write=SetCaptionColor, default=-16777201};
	__property System::Uitypes::TColor TreeLineColor = {read=GetTreeLineColor, write=SetTreeLineColor, default=16777215};
	__property Font;
	__property int DataColumns = {read=FDataColumns, write=SetDataColumns, default=1};
	__property TwwInspectorIndicatorRow* IndicatorRow = {read=FIndicatorRow, write=FIndicatorRow};
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property System::Uitypes::TScrollStyle ScrollBars = {read=FScrollBars, write=SetScrollBars, default=2};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property bool PictureMaskFromDataSet = {read=FPictureMaskFromDataSet, write=FPictureMaskFromDataSet, default=0};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property TwwInspectorCollection* Items = {read=FItems, write=SetItems};
	__property int DefaultRowHeight = {read=FDefaultRowHeight, write=SetDefaultRowHeight, default=0};
	__property int CaptionWidth = {read=FCaptionWidth, write=SetCaptionWidth, nodefault};
	__property TwwDataInspectorOptions Options = {read=FOptions, write=SetOptions, nodefault};
	__property Vcl::Wwpaintoptions::TwwGridPaintOptions* PaintOptions = {read=FPaintOptions, write=FPaintOptions};
	__property Vcl::Graphics::TFont* CaptionFont = {read=FCaptionFont, write=SetCaptionFont};
	__property TwwDataInspectorLineStyle LineStyleCaption = {read=FLineStyleCaption, write=SetLineStyleCaption, default=3};
	__property TwwDataInspectorLineStyle LineStyleData = {read=FLineStyleData, write=SetLineStyleData, default=3};
	__property System::Uitypes::TColor DottedLineColor = {read=FDottedLineColor, write=SetDottedLineColor, default=-16777200};
	__property TwwInspectorButtonOptions* ButtonOptions = {read=FButtonOptions, write=FButtonOptions};
	__property bool ReadOnly = {read=FReadOnly, write=FReadOnly, default=0};
	__property int CaptionIndent = {read=FCaptionIndent, write=SetCaptionIndent, default=12};
	__property TwwInspectorTabSetFocusStyle SetFocusTabStyle = {read=FSetFocusTabStyle, write=FSetFocusTabStyle, default=0};
	__property Visible = {default=1};
	__property Touch;
	__property TwwInspectorCalcCustomEditEvent OnCalcCustomEdit = {read=FOnCalcCustomEdit, write=FOnCalcCustomEdit};
	__property OnClick;
	__property TwwCreateInspectorHintWindowEvent OnCreateHintWindow = {read=FOnCreateHintWindow, write=FOnCreateHintWindow};
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property TwwInspectorDrawDataCellEvent OnDrawDataCell = {read=FOnDrawDataCell, write=FOnDrawDataCell};
	__property TwwInspectorDrawICellEvent OnDrawIndicatorCell = {read=FOnDrawIndicatorCell, write=FOnDrawIndicatorCell};
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
	__property OnMouseWheelDown;
	__property OnMouseWheelUp;
	__property TwwInspectorBeforeSelectCellEvent OnBeforeSelectCell = {read=FOnBeforeSelectCell, write=FOnBeforeSelectCell};
	__property TwwInspectorAfterSelectCellEvent OnAfterSelectCell = {read=FOnAfterSelectCell, write=FOnAfterSelectCell};
	__property OnStartDock;
	__property OnStartDrag;
	__property System::Classes::TNotifyEvent OnTopLeftChanged = {read=FOnTopLeftChanged, write=FOnTopLeftChanged};
	__property OnContextPopup;
	__property OnGesture;
	__property TwwInspectorCreateDTPEvent OnCreateDateTimePicker = {read=FOnCreateDateTimePicker, write=FOnCreateDateTimePicker};
	__property TwwInspectorCreateComboEvent OnCreateDefaultCombo = {read=FOnCreateDefaultCombo, write=FOnCreateDefaultCombo};
	__property TwwInspectorDrawCaptionEvent OnDrawCaptionCell = {read=FOnDrawCaptionCell, write=FOnDrawCaptionCell};
	__property TwwInspectorNotifyEvent OnBeforePaint = {read=FOnBeforePaint, write=FOnBeforePaint};
	__property TwwInspectorCanExpandEvent OnCanExpand = {read=FOnCanExpand, write=FOnCanExpand};
	__property TwwInspectorCanCollapseEvent OnCanCollapse = {read=FOnCanCollapse, write=FOnCanCollapse};
	__property TwwInspectorExpandedEvent OnExpanded = {read=FOnExpanded, write=FOnExpanded};
	__property TwwInspectorCollapsedEvent OnCollapsed = {read=FOnCollapsed, write=FOnCollapsed};
	__property TwwInspectorItemChanged OnItemChanged = {read=FOnItemChanged, write=FOnItemChanged};
	__property TwwInspectorPaintTextEvent OnCalcDataPaintText = {read=FOnCalcDataPaintText, write=FOnCalcDataPaintText};
	__property TwwInspectorValidationError OnValidationErrorUsingMask = {read=FOnValidationErrorUsingMask, write=FOnValidationErrorUsingMask};
	__property StyleElements = {default=7};
	__property DoubleBuffered;
	__property ParentDoubleBuffered = {default=1};
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDataInspector(HWND ParentWindow) : Vcl::Grids::TCustomGrid(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwInspectorComboBox : public Vcl::Wwdbcomb::TwwDBComboBox
{
	typedef Vcl::Wwdbcomb::TwwDBComboBox inherited;
	
private:
	TwwDataInspector* Inspector;
	
protected:
	int FClickTime;
	virtual void __fastcall CloseUp(bool Accept);
	DYNAMIC void __fastcall DblClick(void);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	
public:
	virtual void __fastcall DropDown(void);
	__fastcall virtual TwwInspectorComboBox(System::Classes::TComponent* AOwner);
public:
	/* TwwDBCustomComboBox.Destroy */ inline __fastcall virtual ~TwwInspectorComboBox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwInspectorComboBox(HWND ParentWindow) : Vcl::Wwdbcomb::TwwDBComboBox(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwdatainspector */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWDATAINSPECTOR)
using namespace Vcl::Wwdatainspector;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwdatainspectorHPP
