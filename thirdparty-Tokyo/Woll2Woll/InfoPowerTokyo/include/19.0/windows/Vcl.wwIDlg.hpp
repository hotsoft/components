// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwIDlg.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwidlgHPP
#define Vcl_WwidlgHPP

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
#include <Vcl.Grids.hpp>
#include <Data.DB.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <vcl.Wwkeycb.hpp>
#include <vcl.wwdbgrid.hpp>
#include <vcl.wwdblook.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.wwdbigrd.hpp>
#include <vcl.wwdatsrc.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <vcl.wwDialog.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwidlg
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwLookupDlg;
class DELPHICLASS TwwCustomLookupDialog;
class DELPHICLASS TwwLookupDialog;
class DELPHICLASS TwwSearchDialog;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwDBLookupDlgOption : unsigned char { opShowOKCancel, opShowSearchBy, opGroupControls, opFixFirstColumn, opShowStatusBar, opDisableReorderColumns };

typedef System::Set<TwwDBLookupDlgOption, TwwDBLookupDlgOption::opShowOKCancel, TwwDBLookupDlgOption::opDisableReorderColumns> TwwDBLookupDlgOptions;

typedef void __fastcall (__closure *TwwUserButtonEvent)(System::TObject* Sender, Data::Db::TDataSet* LookupTable);

typedef void __fastcall (__closure *TwwOnInitDialogEvent)(TwwLookupDlg* Dialog);

typedef void __fastcall (__closure *TwwSyncDataSetsEvent)(System::TObject* Sender, Data::Db::TDataSet* MoveDataSet, Data::Db::TDataSet* BaseDataSet);

class PASCALIMPLEMENTATION TwwLookupDlg : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TLabel* SearchCharacterLabel;
	Vcl::Stdctrls::TLabel* SortByLabel;
	Vcl::Wwdbgrid::TwwDBGrid* wwDBGrid1;
	Vcl::Wwkeycb::TwwIncrementalSearch* wwIncrementalSearch1;
	Data::Db::TDataSource* DataSource1;
	Vcl::Extctrls::THeader* StatusHeaderOld;
	Vcl::Extctrls::TPanel* UserButtonPanel;
	Vcl::Stdctrls::TButton* UserButton1;
	Vcl::Stdctrls::TButton* UserButton2;
	Vcl::Comctrls::TStatusBar* StatusHeader;
	void __fastcall wwKeyCombo1Change(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FormCloseQuery(System::TObject* Sender, bool &CanClose);
	void __fastcall FormKeyUp(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall wwKeyCombo1Enter(System::TObject* Sender);
	void __fastcall wwDBGrid1DblClick(System::TObject* Sender);
	void __fastcall DataSource1DataChange(System::TObject* Sender, Data::Db::TField* Field);
	void __fastcall UserButton1Click(System::TObject* Sender);
	void __fastcall UserButton2Click(System::TObject* Sender);
	void __fastcall wwDBGrid1MouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall wwDBGrid1ColumnMoved(System::TObject* Sender, int FromIndex, int ToIndex);
	Vcl::Controls::TControl* __fastcall EffectiveHeader(void);
	
private:
	bool InShow;
	TwwUserButtonEvent FUserButton1Click;
	TwwUserButtonEvent FUserButton2Click;
	TwwOnInitDialogEvent FOnInitDialog;
	TwwOnInitDialogEvent FOnCloseDialog;
	System::Classes::TNotifyEvent FOnSortChange;
	System::UnicodeString FSearchText;
	bool FShowingChanged;
	int OrigLeft;
	System::Classes::TComponent* CallingComponent;
	bool initialized;
	bool PictureMaskFromField;
	void __fastcall AdjustColumnsToIndex(void);
	void __fastcall ResizeControls(bool padOnly);
	void __fastcall ApplyIntl(void);
	HIDESBASE MESSAGE void __fastcall CMShowingChanged(Winapi::Messages::TMessage &Message);
	void __fastcall UpdateSearchField(void);
	
protected:
	void __fastcall WriteStatusInfo(void);
	DYNAMIC void __fastcall DoShow(void);
	DYNAMIC void __fastcall Activate(void);
	
public:
	Vcl::Stdctrls::TButton* OKBtn;
	Vcl::Stdctrls::TButton* CancelBtn;
	int MaxWidth;
	int MaxHeight;
	TwwDBLookupDlgOptions Options;
	bool ClickedMemoField;
	Data::Db::TDataSet* ThisDataSet;
	Vcl::Wwkeycb::TwwKeyCombo* wwKeyCombo1;
	__fastcall virtual TwwLookupDlg(System::Classes::TComponent* AOwner);
	void __fastcall KeyComboChange(void);
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwLookupDlg(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TwwLookupDlg(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwLookupDlg(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwCustomLookupDialog : public Vcl::Wwdialog::TwwCustomDialog
{
	typedef Vcl::Wwdialog::TwwCustomDialog inherited;
	
private:
	TwwUserButtonEvent FUserButton1Click;
	TwwUserButtonEvent FUserButton2Click;
	TwwOnInitDialogEvent FOnInitDialog;
	TwwSyncDataSetsEvent FOnSyncDataSets;
	TwwOnInitDialogEvent FOnCloseDialog;
	System::Classes::TNotifyEvent FOnSortChange;
	System::UnicodeString FUserButton1Caption;
	System::UnicodeString FUserButton2Caption;
	bool FUseTFields;
	bool FPictureMaskFromField;
	System::Classes::TStrings* FControlType;
	bool FControlInfoInDataset;
	System::Classes::TStrings* FPictureMasks;
	bool FPictureMaskFromDataSet;
	Vcl::Wwdblook::TwwPerformSearchEvent FOnPerformCustomSearch;
	void __fastcall SetPictureMasks(System::Classes::TStrings* val);
	void __fastcall SetControlType(System::Classes::TStrings* val);
	
protected:
	int FMaxWidth;
	int FMaxHeight;
	System::Classes::TAlignment FGridTitleAlignment;
	System::Classes::TStrings* FSelected;
	Data::Db::TDataSet* FLookupTable;
	Data::Db::TDataSet* FSyncTable;
	TwwDBLookupDlgOptions FOptions;
	Vcl::Wwdbigrd::TwwDBGridOptions FGridOptions;
	System::Uitypes::TColor FGridColor;
	System::UnicodeString FCaption;
	System::Uitypes::TEditCharCase FCharCase;
	System::Classes::TStrings* __fastcall GetSelectedFields(void);
	void __fastcall SetSelectedFields(System::Classes::TStrings* sel);
	void __fastcall SetLookupTable(Data::Db::TDataSet* sel);
	void __fastcall SetWWLookupTable(Data::Db::TDataSet* sel);
	void __fastcall SetSyncTable(Data::Db::TDataSet* sel);
	Data::Db::TDataSet* __fastcall GetSyncTable(void);
	Data::Db::TDataSet* __fastcall GetLookupTable(void);
	Data::Db::TDataSet* __fastcall GetWWLookupTable(void);
	void __fastcall SetOptions(TwwDBLookupDlgOptions sel);
	void __fastcall SetGridOptions(Vcl::Wwdbigrd::TwwDBGridOptions sel);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	virtual void __fastcall DoSyncDataSets(Data::Db::TDataSet* tempLookupTable, Data::Db::TDataSet* FSyncTable);
	
public:
	__fastcall virtual TwwCustomLookupDialog(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwCustomLookupDialog(void);
	virtual bool __fastcall Execute(void);
	virtual Data::Db::TDataSet* __fastcall GetPrimaryDataSet(void);
	__property Data::Db::TDataSet* SearchTable = {read=GetSyncTable, write=SetSyncTable};
	__property System::Classes::TStrings* Selected = {read=GetSelectedFields, write=SetSelectedFields};
	__property System::Uitypes::TColor GridColor = {read=FGridColor, write=FGridColor, nodefault};
	__property TwwDBLookupDlgOptions Options = {read=FOptions, write=SetOptions, default=3};
	__property Vcl::Wwdbigrd::TwwDBGridOptions GridOptions = {read=FGridOptions, write=SetGridOptions, default=1277};
	__property System::UnicodeString Caption = {read=FCaption, write=FCaption};
	__property int MaxWidth = {read=FMaxWidth, write=FMaxWidth, nodefault};
	__property int MaxHeight = {read=FMaxHeight, write=FMaxHeight, nodefault};
	__property System::Uitypes::TEditCharCase CharCase = {read=FCharCase, write=FCharCase, nodefault};
	__property System::Classes::TAlignment GridTitleAlignment = {read=FGridTitleAlignment, write=FGridTitleAlignment, nodefault};
	__property TwwUserButtonEvent OnUserButton1Click = {read=FUserButton1Click, write=FUserButton1Click};
	__property TwwUserButtonEvent OnUserButton2Click = {read=FUserButton2Click, write=FUserButton2Click};
	__property TwwSyncDataSetsEvent OnSyncDataSets = {read=FOnSyncDataSets, write=FOnSyncDataSets};
	__property Vcl::Wwdblook::TwwPerformSearchEvent OnPerformCustomSearch = {read=FOnPerformCustomSearch, write=FOnPerformCustomSearch};
	__property System::UnicodeString UserButton1Caption = {read=FUserButton1Caption, write=FUserButton1Caption};
	__property System::UnicodeString UserButton2Caption = {read=FUserButton2Caption, write=FUserButton2Caption};
	__property TwwOnInitDialogEvent OnInitDialog = {read=FOnInitDialog, write=FOnInitDialog};
	__property TwwOnInitDialogEvent OnCloseDialog = {read=FOnCloseDialog, write=FOnCloseDialog};
	__property System::Classes::TNotifyEvent OnSortChange = {read=FOnSortChange, write=FOnSortChange};
	__property bool UseTFields = {read=FUseTFields, write=FUseTFields, default=1};
	__property bool PictureMaskFromField = {read=FPictureMaskFromField, write=FPictureMaskFromField, default=0};
	__property System::Classes::TStrings* ControlType = {read=FControlType, write=SetControlType};
	__property bool ControlInfoInDataset = {read=FControlInfoInDataset, write=FControlInfoInDataset, default=1};
	__property bool PictureMaskFromDataset = {read=FPictureMaskFromDataSet, write=FPictureMaskFromDataSet, default=1};
	__property System::Classes::TStrings* PictureMasks = {read=FPictureMasks, write=SetPictureMasks};
};


class PASCALIMPLEMENTATION TwwLookupDialog : public TwwCustomLookupDialog
{
	typedef TwwCustomLookupDialog inherited;
	
public:
	virtual bool __fastcall Execute(void);
	virtual Data::Db::TDataSet* __fastcall GetPrimaryDataSet(void);
	
__published:
	__property Selected;
	__property GridTitleAlignment;
	__property GridColor;
	__property Options = {default=3};
	__property GridOptions = {default=1277};
	__property Data::Db::TDataSet* LookupTable = {read=GetLookupTable, write=SetLookupTable};
	__property Caption = {default=0};
	__property MaxWidth;
	__property MaxHeight;
	__property CharCase;
	__property PictureMaskFromField = {default=0};
	__property UseTFields = {default=1};
	__property UserButton1Caption = {default=0};
	__property UserButton2Caption = {default=0};
	__property OnUserButton1Click;
	__property OnUserButton2Click;
	__property OnInitDialog;
	__property OnCloseDialog;
	__property OnSortChange;
	__property OnPerformCustomSearch;
	__property ControlType;
	__property ControlInfoInDataset = {default=1};
	__property PictureMaskFromDataset = {default=1};
	__property PictureMasks;
public:
	/* TwwCustomLookupDialog.Create */ inline __fastcall virtual TwwLookupDialog(System::Classes::TComponent* AOwner) : TwwCustomLookupDialog(AOwner) { }
	/* TwwCustomLookupDialog.Destroy */ inline __fastcall virtual ~TwwLookupDialog(void) { }
	
};


class PASCALIMPLEMENTATION TwwSearchDialog : public TwwCustomLookupDialog
{
	typedef TwwCustomLookupDialog inherited;
	
public:
	virtual Data::Db::TDataSet* __fastcall GetPrimaryDataSet(void);
	
__published:
	__property Selected;
	__property GridTitleAlignment;
	__property GridColor;
	__property Options = {default=3};
	__property GridOptions = {default=1277};
	__property SearchTable;
	__property Data::Db::TDataSet* ShadowSearchTable = {read=GetWWLookupTable, write=SetWWLookupTable};
	__property PictureMaskFromField = {default=0};
	__property Caption = {default=0};
	__property MaxWidth;
	__property MaxHeight;
	__property CharCase;
	__property UseTFields = {default=1};
	__property UserButton1Caption = {default=0};
	__property UserButton2Caption = {default=0};
	__property OnUserButton1Click;
	__property OnUserButton2Click;
	__property OnSyncDataSets;
	__property OnInitDialog;
	__property OnCloseDialog;
	__property OnSortChange;
	__property OnPerformCustomSearch;
	__property ControlType;
	__property ControlInfoInDataset = {default=1};
	__property PictureMaskFromDataset = {default=1};
	__property PictureMasks;
public:
	/* TwwCustomLookupDialog.Create */ inline __fastcall virtual TwwSearchDialog(System::Classes::TComponent* AOwner) : TwwCustomLookupDialog(AOwner) { }
	/* TwwCustomLookupDialog.Destroy */ inline __fastcall virtual ~TwwSearchDialog(void) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool __fastcall ExecuteWWLookupDlg(Vcl::Forms::TForm* AParentForm, System::Classes::TComponent* AComponent, System::Classes::TStrings* ASelected, Data::Db::TDataSet* ADataSet, TwwDBLookupDlgOptions AOptions, Vcl::Wwdbigrd::TwwDBGridOptions AGridOptions, System::Uitypes::TColor AGridColor, System::Classes::TAlignment AGridTitleAlignment, System::UnicodeString ACaption, int AMaxWidth, int AMaxHeight, System::Uitypes::TEditCharCase ACharCase, System::UnicodeString AUserButton1Caption, System::UnicodeString AUserButton2Caption, TwwUserButtonEvent AUserButton1Click, TwwUserButtonEvent AUserButton2Click, TwwOnInitDialogEvent AOnInitDialog, TwwOnInitDialogEvent AOnCloseDialog, System::Classes::TNotifyEvent AOnSortChange, System::UnicodeString ASearchText, bool AUseTFields, bool APictureMaskFromField);
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwidlg */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWIDLG)
using namespace Vcl::Wwidlg;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwidlgHPP
