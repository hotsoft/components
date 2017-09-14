// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwdbgrid.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwdbgridHPP
#define Vcl_WwdbgridHPP

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
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Grids.hpp>
#include <Vcl.Dialogs.hpp>
#include <Data.DB.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.Wwmemo.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.wwdbigrd.hpp>
#include <vcl.Wwdbdatetimepicker.hpp>
#include <Vcl.Themes.hpp>
#include <System.UITypes.hpp>
#include <vcl.Wwexport.hpp>
#include <Vcl.ComCtrls.hpp>
#include <vcl.wwriched.hpp>
#include <Vcl.Menus.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.wwtypes.hpp>
#include <Vcl.DBCtrls.hpp>
#include <System.IniFiles.hpp>
#include <System.Win.Registry.hpp>
#include <System.Types.hpp>
#include <vcl.wwpaintoptions.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwdbgrid
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwIniAttributes;
class DELPHICLASS TwwMemoDialog;
class DELPHICLASS TwwDBGrid;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwFieldControlType : unsigned char { fctNone, fctField, fctCheckBox, fctCustom, fctBitmap, fctLookupCombo, fctComboBox, fctRichEdit, fctImageIndex, fctURLLink };

typedef void __fastcall (__closure *TwwOnInitMemoDlgEvent)(Vcl::Wwmemo::TwwMemoDlg* Dialog);

typedef void __fastcall (__closure *TwwMemoUserButtonEvent)(Vcl::Wwmemo::TwwMemoDlg* Dialog, Vcl::Stdctrls::TMemo* Memo);

typedef void __fastcall (__closure *TwwCreateDTPEvent)(System::TObject* Sender, Vcl::Wwdbdatetimepicker::TwwDBCustomDateTimePicker* ADateTimePicker);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwIniAttributes : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FFormName;
	System::UnicodeString FFileName;
	System::UnicodeString FSectionName;
	System::UnicodeString FDelimiter;
	bool FEnabled;
	bool FSaveToRegistry;
	bool FCheckNewFields;
	bool FIgnoreTitles;
	bool FUnicodeIniFile;
	void __fastcall SetFileName(System::UnicodeString val);
	void __fastcall SetSectionName(System::UnicodeString val);
	void __fastcall SetDelimiter(System::UnicodeString val);
	void __fastcall SetEnabled(bool val);
	System::UnicodeString __fastcall GetSectionName(void);
	System::UnicodeString __fastcall GetFileName(void);
	
public:
	System::Classes::TComponent* Owner;
	__property System::UnicodeString FormName = {read=FFormName};
	
__published:
	__property bool Enabled = {read=FEnabled, write=SetEnabled, default=0};
	__property bool SaveToRegistry = {read=FSaveToRegistry, write=FSaveToRegistry, default=0};
	__property System::UnicodeString FileName = {read=GetFileName, write=SetFileName};
	__property System::UnicodeString SectionName = {read=GetSectionName, write=SetSectionName};
	__property System::UnicodeString Delimiter = {read=FDelimiter, write=SetDelimiter};
	__property bool CheckNewFields = {read=FCheckNewFields, write=FCheckNewFields, default=0};
	__property bool IgnoreTitles = {read=FIgnoreTitles, write=FIgnoreTitles, default=0};
	__property bool UnicodeIniFile = {read=FUnicodeIniFile, write=FUnicodeIniFile, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwIniAttributes(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwIniAttributes(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwMemoDialog : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
private:
	Vcl::Graphics::TFont* FFont;
	Vcl::Dbctrls::TFieldDataLink* FDataLink;
	Vcl::Wwmemo::TwwMemoAttributes FMemoAttributes;
	System::UnicodeString FCaption;
	int FLeft;
	int FTop;
	int FWidth;
	int FHeight;
	TwwMemoUserButtonEvent FUserButton1Click;
	TwwMemoUserButtonEvent FUserButton2Click;
	TwwOnInitMemoDlgEvent FOnInitDialog;
	TwwOnInitMemoDlgEvent FOnCloseDialog;
	System::UnicodeString FUserButton1Caption;
	System::UnicodeString FUserButton2Caption;
	System::Classes::TStrings* FLines;
	void __fastcall SetLines(System::Classes::TStrings* val);
	
protected:
	void __fastcall SetDataField(System::UnicodeString value);
	void __fastcall SetDataSource(Data::Db::TDataSource* value);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	System::UnicodeString __fastcall GetDataField(void);
	void __fastcall SetwwMemoAttributes(Vcl::Wwmemo::TwwMemoAttributes sel);
	void __fastcall SetFont(Vcl::Graphics::TFont* value);
	void __fastcall SetCaption(System::UnicodeString value);
	
public:
	Vcl::Wwmemo::TwwMemoDlg* Form;
	System::Variant Patch;
	__fastcall virtual TwwMemoDialog(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwMemoDialog(void);
	virtual void __fastcall DoInitDialog(void);
	virtual void __fastcall DoCloseDialog(void);
	
__published:
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	virtual bool __fastcall Execute(void);
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=SetFont};
	__property Vcl::Wwmemo::TwwMemoAttributes MemoAttributes = {read=FMemoAttributes, write=SetwwMemoAttributes, default=3};
	__property System::UnicodeString Caption = {read=FCaption, write=SetCaption};
	__property System::Classes::TStrings* Lines = {read=FLines, write=SetLines};
	__property int DlgLeft = {read=FLeft, write=FLeft, nodefault};
	__property int DlgTop = {read=FTop, write=FTop, nodefault};
	__property int DlgWidth = {read=FWidth, write=FWidth, nodefault};
	__property int DlgHeight = {read=FHeight, write=FHeight, nodefault};
	__property TwwOnInitMemoDlgEvent OnInitDialog = {read=FOnInitDialog, write=FOnInitDialog};
	__property TwwOnInitMemoDlgEvent OnCloseDialog = {read=FOnCloseDialog, write=FOnCloseDialog};
	__property TwwMemoUserButtonEvent OnUserButton1Click = {read=FUserButton1Click, write=FUserButton1Click};
	__property TwwMemoUserButtonEvent OnUserButton2Click = {read=FUserButton2Click, write=FUserButton2Click};
	__property System::UnicodeString UserButton1Caption = {read=FUserButton1Caption, write=FUserButton1Caption};
	__property System::UnicodeString UserButton2Caption = {read=FUserButton2Caption, write=FUserButton2Caption};
};


typedef void __fastcall (__closure *TwwMemoOpenEvent)(TwwDBGrid* Grid, TwwMemoDialog* MemoDialog);

typedef void __fastcall (__closure *TwwMemoCloseEvent)(TwwDBGrid* Grid, bool Cancel);

typedef void __fastcall (__closure *TwwSelectRecordEvent)(TwwDBGrid* Grid, bool Selecting, bool &Accept);

typedef void __fastcall (__closure *TwwSelectAllRecordEvent)(TwwDBGrid* Grid, bool Selecting, bool &Accept);

typedef void __fastcall (__closure *TwwExportFieldEvent)(TwwDBGrid* Grid, Data::Db::TField* Field, bool &Accept);

typedef void __fastcall (__closure *TwwExportSYLKFormatEvent)(TwwDBGrid* Grid, Data::Db::TField* Field, System::UnicodeString &SYLKFormat);

typedef void __fastcall (__closure *TwwExportFormatEvent)(TwwDBGrid* Grid, Data::Db::TField* Field, System::UnicodeString &Format);

class PASCALIMPLEMENTATION TwwDBGrid : public Vcl::Wwdbigrd::TwwCustomDBGrid
{
	typedef Vcl::Wwdbigrd::TwwCustomDBGrid inherited;
	
private:
	// __classmethod void __fastcall Create@();
	
private:
	int FSizingIndex;
	int FSizingPos;
	int FSizingOfs;
	Vcl::Wwmemo::TwwMemoAttributes FMemoAttributes;
	TwwIniAttributes* FIniAttributes;
	Vcl::Wwexport::TwwExportOptions* FExportOptions;
	bool redrawingGrid;
	bool initialized;
	bool doneInitControls;
	bool drawingCell;
	TwwMemoOpenEvent FOnMemoOpen;
	TwwMemoCloseEvent FOnMemoClose;
	int FFixedCols;
	bool FDirtyIni;
	bool inLinkActive;
	bool inTopLeftChanged;
	bool GridIsLoaded;
	TwwSelectRecordEvent FOnSelectRecord;
	TwwSelectAllRecordEvent FOnSelectAllRecords;
	TwwExportFieldEvent FOnExportField;
	TwwExportSYLKFormatEvent FOnExportSYLKFormat;
	TwwExportFormatEvent FOnExportFormat;
	TwwCreateDTPEvent FOnCreateDateTimePicker;
	bool FLoadAllRTF;
	System::Classes::TStrings* OrigSelected;
	Vcl::Wwdbigrd::TwwBookmarkList* Bookmarks;
	System::Classes::TList* FDependentComponents;
	bool MakeCustomControlVisible;
	bool FDisableThemes;
	System::Uitypes::TColor __fastcall GetTitleColor(void);
	void __fastcall SetTitleColor(System::Uitypes::TColor sel);
	HIDESBASE Data::Db::TDataSource* __fastcall GetDataSource(void);
	HIDESBASE void __fastcall SetDataSource(Data::Db::TDataSource* val);
	void __fastcall SetwwMemoAttributes(Vcl::Wwmemo::TwwMemoAttributes sel);
	HIDESBASE MESSAGE void __fastcall CMDesignHitTest(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Msg);
	HIDESBASE MESSAGE void __fastcall CMCtl3DChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMChar(Winapi::Messages::TWMKey &Msg);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	void __fastcall UpdateSelectedProperty(void);
	Vcl::Wwdbdatetimepicker::TwwDBCustomDateTimePicker* __fastcall GetDateTimePicker(void);
	HIDESBASE void __fastcall DrawSizingLine(const Vcl::Grids::TGridDrawInfo &DrawInfo);
	
protected:
	System::Classes::TStrings* SelectedRecordList;
	DYNAMIC System::WideString __fastcall WideGetFieldValue(int ACol);
	virtual void __fastcall ShowCurrentControl(void);
	virtual void __fastcall AdjustLeftCol(void);
	virtual void __fastcall CalcSizingState(int X, int Y, Vcl::Grids::TGridState &State, int &Index, int &SizingPos, int &SizingOfs, Vcl::Grids::TGridDrawInfo &FixedInfo);
	virtual void __fastcall CreateWnd(void);
	virtual Vcl::Wwdbdatetimepicker::TwwDBCustomDateTimePicker* __fastcall CreateDateTimePicker(void);
	virtual void __fastcall DoCreateDateTimePicker(Vcl::Wwdbdatetimepicker::TwwDBCustomDateTimePicker* ADateTimePicker);
	DYNAMIC void __fastcall CalcRowHeight(void);
	DYNAMIC void __fastcall DoExit(void);
	DYNAMIC void __fastcall ColumnMoved(int FromIndex, int ToIndex);
	DYNAMIC void __fastcall ColWidthsChanged(void);
	virtual void __fastcall LinkActive(bool value);
	void __fastcall SetFieldValue(int ACol, System::UnicodeString val);
	virtual bool __fastcall CanEditShow(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall ColExit(void);
	DYNAMIC void __fastcall TopLeftChanged(void);
	DYNAMIC bool __fastcall AllowCancelOnExit(void);
	void __fastcall ToggleCheckBox(int col, int row);
	void __fastcall InitControls(void);
	HIDESBASE void __fastcall SetFixedCols(int val);
	int __fastcall GetFixedCols(void);
	virtual void __fastcall Paint(void);
	virtual bool __fastcall IsWWControl(int ACol, int ARow);
	void __fastcall CallMemoDialog(void);
	System::DynamicArray<System::Byte> __fastcall findBookmark(void);
	virtual System::Uitypes::TColor __fastcall CellColor(int ACol, int ARow);
	virtual void __fastcall RefreshBookmarkList(void);
	virtual void __fastcall Scroll(int Distance);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall SelectRecordRange(System::DynamicArray<System::Byte> bkmrk1, System::DynamicArray<System::Byte> bkmrk2);
	virtual void __fastcall RemoveSelected(System::DynamicArray<System::Byte> bkmrk1, System::DynamicArray<System::Byte> bkmrk2);
	DYNAMIC bool __fastcall IsSelectedRow(int DataRow);
	virtual void __fastcall RefreshActiveControl(void);
	HIDESBASE bool __fastcall IsActiveControl(void);
	
public:
	System::Variant Patch;
	DYNAMIC bool __fastcall IsSelected(void);
	bool __fastcall IsSelectedRecord(void);
	virtual void __fastcall SelectRecord(void);
	virtual void __fastcall UnselectRecord(void);
	void __fastcall SelectAll(void);
	virtual void __fastcall UnselectAll(void);
	virtual void __fastcall LoadFromIniFile(void);
	virtual void __fastcall SaveToIniFile(void);
	void __fastcall ClearControls(void);
	virtual void __fastcall FlushChanges(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	int __fastcall GetRowCount(void);
	int __fastcall GetColCount(void);
	int __fastcall GetActiveRow(void);
	int __fastcall GetActiveCol(void);
	void __fastcall SetActiveRow(int val);
	void __fastcall ScrollCurrentToTop(int currentRow = 0x0);
	Data::Db::TField* __fastcall GetActiveField(void);
	void __fastcall SetActiveField(System::UnicodeString AFieldName);
	bool __fastcall IsRichEditCell(int col, int row, Vcl::Controls::TWinControl* &customEdit);
	virtual void __fastcall GetControlInfo(System::UnicodeString AFieldName, System::UnicodeString &AControlType, System::UnicodeString &AParameters);
	DYNAMIC System::UnicodeString __fastcall GetFieldValue(int ACol);
	virtual void __fastcall DoExportField(TwwDBGrid* Grid, Data::Db::TField* AField, bool &Accept);
	virtual void __fastcall DoExportSYLKFormat(TwwDBGrid* Grid, Data::Db::TField* AField, System::UnicodeString &SYLKFormat);
	void __fastcall DoExportFormat(TwwDBGrid* Grid, Data::Db::TField* AField, System::UnicodeString &Format);
	HIDESBASE void __fastcall SetScrollBars(System::Uitypes::TScrollStyle scrollVal);
	void __fastcall RedrawGrid(void);
	virtual void __fastcall SetColumnAttributes(void);
	virtual void __fastcall DrawCell(int ACol, int ARow, const System::Types::TRect &ARect, Vcl::Grids::TGridDrawState AState);
	virtual void __fastcall HideControls(void);
	HIDESBASE Vcl::Grids::TGridCoord __fastcall MouseCoord(int X, int Y);
	HIDESBASE void __fastcall SetControlType(System::UnicodeString AFieldName, TwwFieldControlType AComponentType, System::UnicodeString AParameters);
	void __fastcall RefreshDisplay(void);
	void __fastcall SortSelectedList(void);
	void __fastcall RestoreDesignSelected(void);
	__fastcall virtual TwwDBGrid(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDBGrid(void);
	DYNAMIC void __fastcall ColEnter(void);
	__property Vcl::Wwdbdatetimepicker::TwwDBCustomDateTimePicker* DateTimePicker = {read=GetDateTimePicker};
	__property InplaceEditor;
	__property ColWidths;
	__property GridLineWidth = {default=1};
	__property Canvas;
	__property Vcl::Wwdbigrd::TwwBookmarkList* SelectedList = {read=Bookmarks};
	__property TabStops;
	void __fastcall AddDependent(System::Classes::TComponent* value);
	void __fastcall RemoveDependent(System::Classes::TComponent* value);
	virtual void __fastcall ApplySelected(void);
	void __fastcall SetOrder(System::UnicodeString AFieldName, bool AClientCursor);
	void __fastcall InitializeDefaultLookupFields(void);
	
__published:
	__property bool DisableThemes = {read=FDisableThemes, write=FDisableThemes, default=0};
	__property DittoAttributes;
	__property DisableThemesInTitle = {default=0};
	__property LineStyle = {default=2};
	__property ControlInfoInDataset = {default=1};
	__property ControlType;
	__property PictureMaskFromDataSet = {default=1};
	__property PictureMasks;
	__property RegexMasks;
	__property Selected;
	__property Vcl::Wwmemo::TwwMemoAttributes MemoAttributes = {read=FMemoAttributes, write=SetwwMemoAttributes, default=3};
	__property TwwIniAttributes* IniAttributes = {read=FIniAttributes, write=FIniAttributes};
	__property System::Uitypes::TColor TitleColor = {read=GetTitleColor, write=SetTitleColor, nodefault};
	__property TwwMemoOpenEvent OnMemoOpen = {read=FOnMemoOpen, write=FOnMemoOpen};
	__property TwwMemoCloseEvent OnMemoClose = {read=FOnMemoClose, write=FOnMemoClose};
	__property TwwSelectAllRecordEvent OnMultiSelectAllRecords = {read=FOnSelectAllRecords, write=FOnSelectAllRecords};
	__property TwwSelectRecordEvent OnMultiSelectRecord = {read=FOnSelectRecord, write=FOnSelectRecord};
	__property OnLeftColChanged;
	__property OnRowChanged;
	__property OnCellChanged;
	__property int FixedCols = {read=GetFixedCols, write=SetFixedCols, nodefault};
	__property ShowHorzScrollBar;
	__property ShowVertScrollBar = {default=1};
	__property EditControlOptions = {default=2};
	__property IndicatorButton;
	__property Anchors = {default=3};
	__property BiDiMode;
	__property ParentBiDiMode = {default=1};
	__property Align = {default=0};
	__property BorderStyle = {default=1};
	__property Color = {default=-16777211};
	__property Constraints;
	__property Ctl3D;
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property DefaultDrawing = {default=1};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property EditCalculated = {default=0};
	__property Enabled = {default=1};
	__property Font;
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property KeyOptions = {default=6};
	__property MultiSelectOptions = {default=0};
	__property Options = {default=7421};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property RowHeightPercent = {default=100};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property TitleAlignment;
	__property TitleFont;
	__property TitleLines;
	__property TitleButtons;
	__property UseTFields = {default=1};
	__property Visible = {default=1};
	__property bool LoadAllRTF = {read=FLoadAllRTF, write=FLoadAllRTF, default=0};
	__property LineColors;
	__property TitleMenuAttributes;
	__property OnCalcCellColors;
	__property OnCalcTitleAttributes;
	__property OnColWidthChanged;
	__property OnDrawGroupHeaderCell;
	__property OnTitleButtonClick;
	__property OnColEnter;
	__property OnColExit;
	__property OnDrawDataCell;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnStartDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnCreateHintWindow;
	__property OnBeforeMenuSort;
	__property OnAfterMenuSort;
	__property OnBeforeMenuGroup;
	__property OnBeforeMenuClearGroup;
	__property OnBeforeMenuColumnRemove;
	__property OnBeforeMenuColumnAdd;
	__property OnBeforeMenuGetFilterRange;
	__property OnBeforeMenuGetFilterValue;
	__property OnAddSelectColumn;
	__property OnCanSort;
	__property OnCanFilter;
	__property OnCanGroup;
	__property OnQuerySortField;
	__property OnCanShowTitleDropDown;
	__property OnPopupTitleDropDown;
	__property OnInitSelectColumnsDialog;
	__property OnCanShowCustomControl;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnGesture;
	__property IndicatorColor = {stored=false};
	__property IndicatorIconColor = {default=0};
	__property OnCheckValue;
	__property OnColumnMoved;
	__property OnTopRowChanged;
	__property OnCalcTitleImage;
	__property OnDrawFooterCell;
	__property OnDrawTitleCell;
	__property OnFieldChanged;
	__property OnUpdateFooter;
	__property OnBeforePaint;
	__property ImageList;
	__property TitleImageList;
	__property FooterColor = {default=-16777201};
	__property FooterCellColor = {default=-16777201};
	__property FooterHeight = {default=0};
	__property DragVertOffset = {default=15};
	__property PadColumnStyle = {default=2};
	__property OnURLOpen;
	__property HideAllLines = {default=0};
	__property GroupFieldName = {default=0};
	__property TwwCreateDTPEvent OnCreateDateTimePicker = {read=FOnCreateDateTimePicker, write=FOnCreateDateTimePicker};
	__property Vcl::Wwexport::TwwExportOptions* ExportOptions = {read=FExportOptions, write=FExportOptions};
	__property TwwExportFieldEvent OnExportField = {read=FOnExportField, write=FOnExportField};
	__property TwwExportSYLKFormatEvent OnExportSYLKFormat = {read=FOnExportSYLKFormat, write=FOnExportSYLKFormat};
	__property TwwExportFormatEvent OnExportFormat = {read=FOnExportFormat, write=FOnExportFormat};
	__property PaintOptions;
	__property OnBeforeDrawCell;
	__property OnAfterDrawCell;
	__property OnDitto;
	__property Touch;
	__property TouchPan = {default=0};
	__property StyleElements = {default=7};
	__property DoubleBuffered;
	__property ParentDoubleBuffered = {default=1};
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBGrid(HWND ParentWindow) : Vcl::Wwdbigrd::TwwCustomDBGrid(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwdbgrid */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWDBGRID)
using namespace Vcl::Wwdbgrid;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwdbgridHPP
