// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwfltdlg.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwfltdlgHPP
#define Vcl_WwfltdlgHPP

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
#include <vcl.wwdatsrc.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <vcl.Wwfltdum.hpp>
#include <Vcl.Tabs.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.Wwsystem.hpp>
#include <vcl.wwDialog.hpp>
#include <vcl.Wwdbdatetimepicker.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.Wwdotdot.hpp>
#include <vcl.Wwdbcomb.hpp>
#include <vcl.wwclearbuttongroup.hpp>
#include <vcl.wwradiogroup.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <System.WideStrings.hpp>
#include <System.TypInfo.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwfltdlg
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwFieldInfo;
class DELPHICLASS TwwFilterDlg;
class DELPHICLASS TwwDBFieldInfo;
class DELPHICLASS TwwFilterPropertyOptions;
class DELPHICLASS TwwFieldOperators;
class DELPHICLASS TwwSQLTablesCollectionItem;
class DELPHICLASS TwwSQLTablesCollection;
class DELPHICLASS TwwFilterDialogRounding;
class DELPHICLASS TwwFilterDialog;
class DELPHICLASS TwwFilterDataLink;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwFilterDialogOption : unsigned char { fdCaseSensitive, fdShowCaseSensitive, fdShowOKCancel, fdShowViewSummary, fdShowFieldOrder, fdShowValueRangeTab, fdShowNonMatching, fdHidePartialAnywhere, fdDisableDateTimePicker, fdSizeable, fdTabsAtTop };

enum DECLSPEC_DENUM TwwFilterFieldsFetchType : unsigned char { fmUseTTable, fmUseSQL, fmUseTFields };

typedef System::Set<TwwFilterDialogOption, TwwFilterDialogOption::fdCaseSensitive, TwwFilterDialogOption::fdTabsAtTop> TwwFilterDialogOptions;

enum DECLSPEC_DENUM TwwFilterDialogSort : unsigned char { fdSortByFieldNo, fdSortByFieldName };

enum DECLSPEC_DENUM TwwFilterMatchType : unsigned char { fdMatchStart, fdMatchAny, fdMatchExact, fdMatchEnd, fdMatchRange, fdMatchKeyword, fdMatchNone };

enum DECLSPEC_DENUM TwwFilterMethodAll : unsigned char { fdByFilter, fdByQueryModify, fdByQueryParams };

typedef TwwFilterMethodAll TwwFilterMethod;

typedef TwwFilterMatchType TwwDefaultMatchType;

enum DECLSPEC_DENUM TwwDefaultFilterBy : unsigned char { fdSmartFilter, fdFilterByRange, fdFilterByValue };

typedef void __fastcall (__closure *TwwFilterDialogSummaryEvent)(System::TObject* Sender, System::Classes::TList* AFieldInfo, bool &DoDefault);

typedef void __fastcall (__closure *TwwOnInitTempDataSetEvent)(System::TObject* Sender, Data::Db::TDataSet* OrigDataSet, Data::Db::TDataSet* TempDataSet);

typedef void __fastcall (__closure *TwwOnInitFilterDlgEvent)(TwwFilterDlg* Dialog);

typedef void __fastcall (__closure *TwwOnExecuteSQLEvent)(TwwFilterDlg* Dialog, Data::Db::TDataSet* Query);

typedef void __fastcall (__closure *TwwOnEncodeValueEvent)(Data::Db::TFieldType AFieldType, System::UnicodeString AFieldName, System::UnicodeString &AUserValue);

typedef void __fastcall (__closure *TwwOnEncodeDateTimeEvent)(System::TDateTime ADateTime, Data::Db::TFieldType AFieldType, System::UnicodeString AFieldName, System::UnicodeString &FormattedDateStr);

enum DECLSPEC_DENUM TwwFilterOptimization : unsigned char { fdNone, fdUseAllIndexes, fdUseActiveIndex };

enum DECLSPEC_DENUM TwwQueryFormatDateMode : unsigned char { qfdMonthDayYear, qfdDayMonthYear, qfdYearMonthDay };

typedef void __fastcall (__closure *TwwOnSelectFilterField)(System::TObject* Sender, System::UnicodeString FieldName, System::UnicodeString &PictureMask, System::Classes::TStrings* ComboList);

typedef void __fastcall (__closure *TwwOnAcceptFilterRecord)(System::TObject* Sender, Data::Db::TDataSet* DataSet, bool &Accept, bool &DefaultFiltering);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwFieldInfo : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::UnicodeString FieldName;
	System::UnicodeString DisplayLabel;
	TwwFilterMatchType MatchType;
	System::UnicodeString FilterValue;
	System::UnicodeString MinValue;
	System::UnicodeString MaxValue;
	bool CaseSensitive;
	bool NonMatching;
	int Tag;
	System::UnicodeString TagString;
public:
	/* TObject.Create */ inline __fastcall TwwFieldInfo(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TwwFieldInfo(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwFilterDlg : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Extctrls::TPanel* FieldCriteriaPanel;
	Vcl::Comctrls::TPageControl* SelectNotebook;
	Vcl::Comctrls::TTabSheet* TabSheet1;
	Vcl::Stdctrls::TLabel* FieldValueLbl;
	Vcl::Extctrls::TRadioGroup* MatchTypeGroup;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TCheckBox* CaseSensitive;
	Vcl::Stdctrls::TCheckBox* Nonmatching;
	Vcl::Buttons::TBitBtn* FilterValueClearButton;
	Vcl::Wwdbcomb::TwwDBComboBox* FilterValueCombo;
	Vcl::Wwdbedit::TwwDBEdit* FilterValueEdit;
	Vcl::Comctrls::TTabSheet* TabSheet2;
	Vcl::Stdctrls::TLabel* StartingRangeLbl;
	Vcl::Stdctrls::TLabel* EndingRangeLbl;
	Vcl::Stdctrls::TEdit* MinValueEdit;
	Vcl::Stdctrls::TEdit* MaxValueEdit;
	Vcl::Buttons::TBitBtn* MinValueClearButton;
	Vcl::Buttons::TBitBtn* MaxValueClearButton;
	Vcl::Wwdbdatetimepicker::TwwDBDateTimePicker* MinDateEdit;
	Vcl::Wwdbdatetimepicker::TwwDBDateTimePicker* MaxDateEdit;
	Vcl::Extctrls::TPanel* FieldListPanel;
	Vcl::Comctrls::TTabControl* FieldTabSet;
	Vcl::Stdctrls::TListBox* FieldsListBox;
	Vcl::Extctrls::TPanel* ButtonPanel;
	Vcl::Stdctrls::TButton* ViewButton;
	Vcl::Stdctrls::TButton* ClearSearchButton;
	Vcl::Extctrls::TPanel* OKCancelPanel;
	Vcl::Extctrls::TPanel* CriteriaLabelPanel;
	Vcl::Stdctrls::TLabel* FieldCriteria;
	Vcl::Extctrls::TPanel* FieldsLabelPanel;
	Vcl::Stdctrls::TLabel* FieldsLbl;
	Vcl::Extctrls::TPanel* FieldOrderPanel;
	Vcl::Extctrls::TRadioGroup* FieldOrder;
	void __fastcall FieldOrderClick(System::TObject* Sender);
	void __fastcall FieldsListBoxClick(System::TObject* Sender);
	void __fastcall ViewButtonClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall ValueRangeTabSetChange(System::TObject* Sender, int NewTab, bool &AllowChange);
	void __fastcall ClearSearchButtonClick(System::TObject* Sender);
	void __fastcall FilterValueComboChange(System::TObject* Sender);
	void __fastcall MinValueEditChange(System::TObject* Sender);
	void __fastcall MaxValueEditChange(System::TObject* Sender);
	void __fastcall FormCloseQuery(System::TObject* Sender, bool &CanClose);
	void __fastcall FormActivate(System::TObject* Sender);
	void __fastcall MinValueClearButtonClick(System::TObject* Sender);
	void __fastcall MaxValueClearButtonClick(System::TObject* Sender);
	void __fastcall FilterValueClearButtonClick(System::TObject* Sender);
	void __fastcall MatchTypeGroupClick(System::TObject* Sender);
	void __fastcall FieldTabSetChanging(System::TObject* Sender, bool &AllowChange);
	void __fastcall FieldCriteriaPanelResize(System::TObject* Sender);
	void __fastcall FieldTabSetChange(System::TObject* Sender);
	
private:
	int LastItemIndex;
	bool FormActivated;
	bool __fastcall IsValueField(System::UnicodeString ADisplayLabel);
	bool __fastcall IsValueType(Data::Db::TFieldType AFieldType);
	void __fastcall RefreshClearbutton(void);
	bool __fastcall ValidEditValue(System::UnicodeString val);
	bool __fastcall ValidEditValues(System::UnicodeString val);
	void __fastcall ApplyIntl(void);
	Data::Db::TFieldType __fastcall GetFieldType(System::UnicodeString ADisplayLabel);
	void __fastcall UpdateFilterEditControl(void);
	System::UnicodeString __fastcall GetSQLPropertyname(void);
	void __fastcall ShowValueRangeTabs(void);
	
protected:
	System::Classes::TComponent* DlgComponent;
	Data::Db::TDataSet* DlgDataSet;
	System::Classes::TList* FieldInfo;
	Vcl::Stdctrls::TCustomEdit* MinValueEditControl;
	Vcl::Stdctrls::TCustomEdit* MaxValueEditControl;
	Vcl::Stdctrls::TCustomEdit* FilterValueEditControl;
	
public:
	Vcl::Stdctrls::TButton* OKBtn;
	Vcl::Stdctrls::TButton* CancelBtn;
	bool FilterChanged;
	void __fastcall RefreshFieldList(bool ShowAll);
	void __fastcall AdjustFieldTabSet(int NewTab);
	__fastcall TwwFilterDlg(System::Classes::TComponent* AOwner, System::Classes::TComponent* ADlgComponent);
	__fastcall virtual ~TwwFilterDlg(void);
	bool __fastcall SelectField(bool FieldChanged);
	void __fastcall SelectPage(void);
	void __fastcall SelectFocus(void);
	void __fastcall SetFilterfield(System::UnicodeString ADisplayLabel, TwwFilterMatchType AMatchType, System::UnicodeString AFilterValue, System::UnicodeString AMinValue, System::UnicodeString AMaxValue, bool ACaseSensitive, bool ANonMatching);
	bool __fastcall GetFilterField(System::UnicodeString ADisplayLabel, TwwFieldInfo* &FldInfo);
	void __fastcall CopyList(System::Classes::TList* fromlist, System::Classes::TList* tolist);
public:
	/* TCustomForm.Create */ inline __fastcall virtual TwwFilterDlg(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwFilterDlg(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwFilterDlg(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwDBFieldInfo : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	System::UnicodeString LogicalFieldName;
	System::UnicodeString PhysicalFieldName;
	System::UnicodeString TableName;
	Data::Db::TFieldType FieldType;
	System::UnicodeString DisplayLabel;
	int Size;
public:
	/* TObject.Create */ inline __fastcall TwwDBFieldInfo(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TwwDBFieldInfo(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TwwDatasetFilterType : unsigned char { fdUseOnFilter, fdUseFilterProp, fdUseBothFilterTypes };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwFilterPropertyOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TwwDatasetFilterType FDatasetFilterType;
	System::UnicodeString FLikeWildcardChar;
	bool FUseBracketsAroundFields;
	bool FUseLikeOperator;
	bool FLikeSupportsUpperKeyword;
	
__published:
	__property TwwDatasetFilterType DatasetFilterType = {read=FDatasetFilterType, write=FDatasetFilterType, default=0};
	__property bool UseLikeOperator = {read=FUseLikeOperator, write=FUseLikeOperator, default=0};
	__property System::UnicodeString LikeWildcardChar = {read=FLikeWildcardChar, write=FLikeWildcardChar};
	__property bool LikeSupportsUpperKeyword = {read=FLikeSupportsUpperKeyword, write=FLikeSupportsUpperKeyword, default=0};
	__property bool UseBracketsAroundFields = {read=FUseBracketsAroundFields, write=FUseBracketsAroundFields, default=1};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwFilterPropertyOptions(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwFilterPropertyOptions(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwFieldOperators : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FOrChar;
	System::UnicodeString FAndChar;
	System::UnicodeString FNullChar;
	void __fastcall SetOrChar(System::UnicodeString val);
	void __fastcall SetAndChar(System::UnicodeString val);
	void __fastcall SetNullChar(System::UnicodeString val);
	void __fastcall SetOpChar(System::UnicodeString &opchar, System::UnicodeString val);
	
public:
	__fastcall TwwFieldOperators(System::Classes::TComponent* Owner);
	
__published:
	__property System::UnicodeString OrChar = {read=FOrChar, write=SetOrChar};
	__property System::UnicodeString AndChar = {read=FAndChar, write=SetAndChar};
	__property System::UnicodeString NullChar = {read=FNullChar, write=SetNullChar};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwFieldOperators(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwSQLTablesCollectionItem : public System::Classes::TCollectionItem
{
	typedef System::Classes::TCollectionItem inherited;
	
private:
	System::UnicodeString FTableName;
	System::UnicodeString FTableAliasName;
	
protected:
	virtual System::UnicodeString __fastcall GetDisplayName(void);
	
__published:
	__property System::UnicodeString TableName = {read=FTableName, write=FTableName};
	__property System::UnicodeString TableAliasName = {read=FTableAliasName, write=FTableAliasName};
public:
	/* TCollectionItem.Create */ inline __fastcall virtual TwwSQLTablesCollectionItem(System::Classes::TCollection* Collection) : System::Classes::TCollectionItem(Collection) { }
	/* TCollectionItem.Destroy */ inline __fastcall virtual ~TwwSQLTablesCollectionItem(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwSQLTablesCollection : public System::Classes::TCollection
{
	typedef System::Classes::TCollection inherited;
	
protected:
	System::Classes::TComponent* Control;
	DYNAMIC System::Classes::TPersistent* __fastcall GetOwner(void);
	
public:
	__fastcall TwwSQLTablesCollection(System::Classes::TComponent* Control);
	HIDESBASE TwwSQLTablesCollectionItem* __fastcall Add(void);
public:
	/* TCollection.Destroy */ inline __fastcall virtual ~TwwSQLTablesCollection(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TwwOnFilterPropertyOption : unsigned char { fdClearWhenNoCriteria, fdClearWhenCloseDataSet };

typedef System::Set<TwwOnFilterPropertyOption, TwwOnFilterPropertyOption::fdClearWhenNoCriteria, TwwOnFilterPropertyOption::fdClearWhenCloseDataSet> TwwOnFilterPropertyOptions;

enum DECLSPEC_DENUM TwwFilterDialogRoundingMethod : unsigned char { fdrmFixed, fdrmRelative };

class PASCALIMPLEMENTATION TwwFilterDialogRounding : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	double FEpsilon;
	TwwFilterDialogRoundingMethod FRoundingMethod;
	
public:
	__fastcall TwwFilterDialogRounding(System::Classes::TComponent* Owner);
	
__published:
	__property double Epsilon = {read=FEpsilon, write=FEpsilon};
	__property TwwFilterDialogRoundingMethod RoundingMethod = {read=FRoundingMethod, write=FRoundingMethod, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwFilterDialogRounding(void) { }
	
};


class PASCALIMPLEMENTATION TwwFilterDialog : public Vcl::Wwdialog::TwwCustomDialog
{
	typedef Vcl::Wwdialog::TwwCustomDialog inherited;
	
private:
	Data::Db::TDataLink* FDataLink;
	TwwFilterDialogOptions FOptions;
	TwwFilterDialogSort FSortBy;
	Vcl::Wwfltdum::TwwDummyForm* FDummyForm;
	System::UnicodeString FTitle;
	TwwFilterMethodAll FFilterMethod;
	TwwFilterMatchType FDefaultMatchType;
	TwwDefaultFilterBy FDefaultFilterBy;
	System::UnicodeString FDefaultField;
	System::Classes::TStrings* FSelectedFields;
	TwwOnInitFilterDlgEvent FOnInitDialog;
	TwwOnExecuteSQLEvent FOnExecuteSQL;
	TwwFieldOperators* FwwOperators;
	TwwFilterDialogRounding* FRounding;
	bool FRangeApplied;
	TwwFilterOptimization FFilterOptimization;
	System::Word FUpperRangePadChar;
	int FDlgHeight;
	TwwOnEncodeValueEvent FOnEncodeValue;
	TwwOnEncodeDateTimeEvent FOnEncodeDateTime;
	TwwOnSelectFilterField FOnSelectField;
	TwwOnInitTempDataSetEvent FOnInitTempDataSet;
	TwwOnAcceptFilterRecord FOnAcceptFilterRecord;
	TwwFilterFieldsFetchType FFieldsFetchMethod;
	TwwFilterDialogSummaryEvent FOnDialogSummary;
	System::Classes::TStrings* FOrigSQL;
	System::Classes::TList* FFldList;
	bool FShowDialog;
	System::Classes::TList* FDependentComponents;
	TwwQueryFormatDateMode FQueryFormatDateMode;
	TwwFilterPropertyOptions* FFilterPropertyOptions;
	TwwOnFilterPropertyOptions FOnFilterPropertyOptions;
	TwwSQLTablesCollection* FSQLTables;
	System::UnicodeString FSQLUpperString;
	bool SkipClearFieldInfo;
	System::UnicodeString FSQLPropertyName;
	void __fastcall SetDataSource(Data::Db::TDataSource* value);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	void __fastcall SetFilterMethod(TwwFilterMethod val);
	void __fastcall ReplaceRemoteSQL(System::Classes::TStrings* querySQL);
	System::UnicodeString __fastcall PadUpperRange(int size, System::UnicodeString val);
	void __fastcall SetDlgHeight(int val);
	System::UnicodeString __fastcall GetEffectiveSQLUpperString(void);
	System::UnicodeString __fastcall FieldstoIndexWithCase(System::UnicodeString aIndexFields, bool caseSensitive);
	
protected:
	virtual void __fastcall FilterDialogView(System::Classes::TList* AFieldInfo);
	virtual System::UnicodeString __fastcall GetSQLPropertyname(void);
	virtual void __fastcall DoInitDialog(void);
	TwwDBFieldInfo* __fastcall AddDBFieldInfo(void);
	virtual void __fastcall LinkActive(bool active);
	virtual void __fastcall DoSelectField(System::UnicodeString FieldName, System::UnicodeString &PictureMask, System::Classes::TStrings* ComboList);
	virtual void __fastcall DoInitTempDataSet(Data::Db::TDataSet* OrigDataSet, Data::Db::TDataSet* TempDataset);
	virtual void __fastcall DoAcceptFilterRecord(Data::Db::TDataSet* DataSet, bool &Accept, bool &DefaultFiltering);
	virtual void __fastcall InitQueryFields(void);
	virtual void __fastcall InitTableFields(void);
	virtual void __fastcall ReplaceWhereClause(System::Classes::TStrings* whereClause);
	virtual Data::Db::TDataSet* __fastcall GetCommandTextDataSet(Data::Db::TDataSet* ADataSet = (Data::Db::TDataSet*)(0x0));
	bool __fastcall IsWideSql(Data::Db::TDataSet* dataSet, System::Typinfo::PPropInfo propInfo);
	
public:
	System::WideChar *MemoBuffer;
	TwwFilterDlg* Form;
	System::Classes::TList* FieldInfo;
	bool FieldsInDblQuotes;
	System::Variant Patch;
	System::Classes::TStringList* SQLWhereClause;
	__fastcall virtual TwwFilterDialog(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwFilterDialog(void);
	bool __fastcall ExecuteDialog(bool ExecuteQuery = true, System::Classes::TStrings* ReturnWhereClause = (System::Classes::TStrings*)(0x0));
	virtual bool __fastcall Execute(void);
	virtual Data::Db::TDataSet* __fastcall GetPrimaryDataSet(void);
	void __fastcall ApplyFilter(void);
	void __fastcall ClearFilter(void);
	virtual void __fastcall InitFields(void);
	__property System::Classes::TList* AllFields = {read=FFldList};
	__property bool ShowDialog = {read=FShowDialog, write=FShowDialog, nodefault};
	TwwDBFieldInfo* __fastcall GetDBInfoForField(System::UnicodeString AFilterFieldName);
	void __fastcall AddDependent(System::Classes::TComponent* value);
	void __fastcall RemoveDependent(System::Classes::TComponent* value);
	TwwFieldInfo* __fastcall AddFieldInfo(void);
	
__published:
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property TwwFilterDialogSummaryEvent OnDialogSummary = {read=FOnDialogSummary, write=FOnDialogSummary};
	__property TwwFilterDialogOptions Options = {read=FOptions, write=FOptions, default=62};
	__property TwwFilterDialogSort SortBy = {read=FSortBy, write=FSortBy, nodefault};
	__property System::UnicodeString Caption = {read=FTitle, write=FTitle};
	__property TwwFilterMethod FilterMethod = {read=FFilterMethod, write=SetFilterMethod, nodefault};
	__property TwwDefaultMatchType DefaultMatchType = {read=FDefaultMatchType, write=FDefaultMatchType, nodefault};
	__property TwwDefaultFilterBy DefaultFilterBy = {read=FDefaultFilterBy, write=FDefaultFilterBy, nodefault};
	__property System::UnicodeString DefaultField = {read=FDefaultField, write=FDefaultField};
	__property TwwFilterFieldsFetchType FieldsFetchMethod = {read=FFieldsFetchMethod, write=FFieldsFetchMethod, default=0};
	__property TwwFieldOperators* FieldOperators = {read=FwwOperators, write=FwwOperators};
	__property TwwFilterDialogRounding* Rounding = {read=FRounding, write=FRounding};
	__property TwwFilterPropertyOptions* FilterPropertyOptions = {read=FFilterPropertyOptions, write=FFilterPropertyOptions};
	__property TwwOnFilterPropertyOptions OnFilterPropertyOptions = {read=FOnFilterPropertyOptions, write=FOnFilterPropertyOptions, default=3};
	__property System::Classes::TStrings* SelectedFields = {read=FSelectedFields, write=FSelectedFields};
	__property TwwFilterOptimization FilterOptimization = {read=FFilterOptimization, write=FFilterOptimization, nodefault};
	__property System::Word UpperRangePadChar = {read=FUpperRangePadChar, write=FUpperRangePadChar, default=122};
	__property int DlgHeight = {read=FDlgHeight, write=SetDlgHeight, default=267};
	__property TwwQueryFormatDateMode QueryFormatDateMode = {read=FQueryFormatDateMode, write=FQueryFormatDateMode, nodefault};
	__property TwwSQLTablesCollection* SQLTables = {read=FSQLTables, write=FSQLTables};
	__property System::UnicodeString SQLUpperString = {read=FSQLUpperString, write=FSQLUpperString};
	__property System::UnicodeString SQLPropertyName = {read=FSQLPropertyName, write=FSQLPropertyName};
	__property TwwOnInitFilterDlgEvent OnInitDialog = {read=FOnInitDialog, write=FOnInitDialog};
	__property TwwOnExecuteSQLEvent OnExecuteSQL = {read=FOnExecuteSQL, write=FOnExecuteSQL};
	__property TwwOnEncodeValueEvent OnEncodeValue = {read=FOnEncodeValue, write=FOnEncodeValue};
	__property TwwOnEncodeDateTimeEvent OnEncodeDateTime = {read=FOnEncodeDateTime, write=FOnEncodeDateTime};
	__property TwwOnSelectFilterField OnSelectField = {read=FOnSelectField, write=FOnSelectField};
	__property TwwOnInitTempDataSetEvent OnInitTempDataSet = {read=FOnInitTempDataSet, write=FOnInitTempDataSet};
	__property TwwOnAcceptFilterRecord OnAcceptFilterRecord = {read=FOnAcceptFilterRecord, write=FOnAcceptFilterRecord};
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwFilterDataLink : public Data::Db::TDataLink
{
	typedef Data::Db::TDataLink inherited;
	
private:
	TwwFilterDialog* FilterDialog;
	
protected:
	virtual void __fastcall ActiveChanged(void);
	
public:
	__fastcall TwwFilterDataLink(TwwFilterDialog* AFilterDialog);
public:
	/* TDataLink.Destroy */ inline __fastcall virtual ~TwwFilterDataLink(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwFilterDlg* wwFilterDlg;
extern DELPHI_PACKAGE void __fastcall Register(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetFilterToken(System::UnicodeString FilterValue, System::UnicodeString SearchDelimiter, int &CurPos);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwGetFilterOperator(System::UnicodeString FilterValue, TwwFieldOperators* FilterOperator, bool &OrFlg, bool &AndFlg);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwPadUpperRange(int size, System::UnicodeString s, System::Word UpperRangePadChar);
}	/* namespace Wwfltdlg */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWFLTDLG)
using namespace Vcl::Wwfltdlg;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwfltdlgHPP
