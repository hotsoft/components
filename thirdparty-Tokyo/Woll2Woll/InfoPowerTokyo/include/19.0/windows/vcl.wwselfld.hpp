// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwselfld.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwselfldHPP
#define Vcl_WwselfldHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Data.DB.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.TabNotBk.hpp>
#include <Vcl.Tabs.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <vcl.wwdblook.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.wwdbdlg.hpp>
#include <vcl.wwIDlg.hpp>
#include <vcl.Wwdatainspector.hpp>
#include <vcl.wwriched.hpp>
#include <vcl.Wwdbcomb.hpp>
#include <vcl.wwdbgrid.hpp>
#include <vcl.wwprpfld.hpp>
#include <vcl.wwprprx.hpp>
#include <System.Win.Registry.hpp>
#include <DesignIntf.hpp>
#include <vcl.wwtypes.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.Wwdotdot.hpp>
#include <vcl.wwdbigrd.hpp>
#include <vcl.ipdsgn.hpp>
#include <vcl.wwedtpic.hpp>
#include <Vcl.ComCtrls.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwselfld
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TSelFieldsForm;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwSelectedPropertyType : unsigned char { sptNone, sptDataSetType, sptRecordViewType, sptObjectViewType };

class PASCALIMPLEMENTATION TSelFieldsForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Buttons::TBitBtn* OKBtn;
	Vcl::Buttons::TBitBtn* CancelBtn;
	Vcl::Buttons::TBitBtn* HelpBtn;
	Vcl::Stdctrls::TGroupBox* GroupBox1;
	Vcl::Stdctrls::TListBox* DstList;
	Vcl::Stdctrls::TButton* AddFieldsButton;
	Vcl::Stdctrls::TButton* RemoveFieldsButton;
	Vcl::Stdctrls::TGroupBox* SelectedFieldCaption;
	Vcl::Comctrls::TPageControl* FieldNotebook;
	Vcl::Stdctrls::TLabel* DisplayWidthLabel;
	Vcl::Stdctrls::TLabel* Label2;
	Vcl::Stdctrls::TEdit* DisplayWidth;
	Vcl::Stdctrls::TEdit* DisplayTitle;
	Vcl::Stdctrls::TLabel* Label3;
	Vcl::Stdctrls::TComboBox* ControlTypeEdit;
	Vcl::Extctrls::TNotebook* ControlTypeNotebook;
	Vcl::Stdctrls::TLabel* Label10;
	Vcl::Stdctrls::TLabel* Label11;
	Vcl::Stdctrls::TComboBox* BitmapScalingCombo;
	Vcl::Stdctrls::TComboBox* RasterCombo;
	Vcl::Stdctrls::TLabel* Label9;
	Vcl::Extctrls::TBevel* Bevel1;
	Vcl::Stdctrls::TLabel* Label4;
	Vcl::Stdctrls::TLabel* Label5;
	Vcl::Stdctrls::TLabel* LookupFieldCaption;
	Vcl::Stdctrls::TLabel* LookupTableCaption;
	Vcl::Stdctrls::TButton* Button4;
	Vcl::Stdctrls::TButton* EditLookupButton;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TCheckBox* UseTFieldCheckbox;
	Vcl::Wwdbcomb::TwwDBComboBox* DBRichEditComboList;
	Vcl::Stdctrls::TLabel* Label1;
	Vcl::Buttons::TBitBtn* InsertNewLineButton;
	Vcl::Stdctrls::TCheckBox* ReadOnlyCB;
	Vcl::Stdctrls::TCheckBox* ShrinkToFit;
	Vcl::Wwdbcomb::TwwDBComboBox* DBLookupComboList;
	Vcl::Stdctrls::TCheckBox* ControlAlwaysPaints;
	Vcl::Stdctrls::TCheckBox* RTFControlAlwaysPaints;
	Vcl::Stdctrls::TEdit* GroupName;
	Vcl::Stdctrls::TLabel* GroupNameLabel;
	Vcl::Stdctrls::TButton* DesignMaskButton;
	Vcl::Wwdotdot::TwwDBComboDlg* PictureMaskEdit;
	Vcl::Stdctrls::TCheckBox* AutoFillCheckbox;
	Vcl::Stdctrls::TCheckBox* UsePictureMask;
	Vcl::Comctrls::TPageControl* MaskTabControl;
	Vcl::Stdctrls::TMemo* PictureDescription;
	Vcl::Comctrls::TTabSheet* RegexPage;
	Vcl::Comctrls::TTabSheet* PictureMaskPage;
	Vcl::Wwdotdot::TwwDBComboDlg* RegexEdit;
	Vcl::Stdctrls::TMemo* RegexDescription;
	Vcl::Stdctrls::TCheckBox* CaseSensitiveRegexCheckBox;
	Vcl::Stdctrls::TButton* Button1;
	Vcl::Stdctrls::TMemo* RegexErrorMsgEdit;
	Vcl::Stdctrls::TEdit* CheckOnValue;
	Vcl::Stdctrls::TEdit* CheckOffValue;
	Vcl::Comctrls::TTabSheet* TabSheetDisplay;
	Vcl::Comctrls::TTabSheet* TabSheet3;
	Vcl::Comctrls::TTabSheet* TabSheetLinks;
	bool __fastcall InDestList(System::UnicodeString Value);
	void __fastcall ExcludeItems(void);
	void __fastcall DstListClick(System::TObject* Sender);
	void __fastcall EditLookupButtonClick(System::TObject* Sender);
	void __fastcall ClearLinkButtonClick(System::TObject* Sender);
	void __fastcall SelectDest(int index);
	void __fastcall FormActivate(System::TObject* Sender);
	void __fastcall DisplayWidthChange(System::TObject* Sender);
	void __fastcall DisplayTitleChange(System::TObject* Sender);
	void __fastcall FieldTabSetClick(System::TObject* Sender);
	void __fastcall OKBtnClick(System::TObject* Sender);
	void __fastcall ControlTypeEditChange(System::TObject* Sender);
	void __fastcall ExcludeBtnClick(System::TObject* Sender);
	void __fastcall FormKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall SortAvailCheckboxClick(System::TObject* Sender);
	void __fastcall HelpBtnClick(System::TObject* Sender);
	void __fastcall DesignMaskButtonClick(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall PictureMaskEditChange(System::TObject* Sender);
	void __fastcall PictureMaskEditCloseUp(System::TObject* Sender, Data::Db::TDataSet* LookupTable, Data::Db::TDataSet* FillTable, bool modified);
	void __fastcall RemoveFieldsButtonClick(System::TObject* Sender);
	void __fastcall AddFieldsButtonClick(System::TObject* Sender);
	void __fastcall DstListDragDrop(System::TObject* Sender, System::TObject* Source, int X, int Y);
	void __fastcall DstListDragOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall DstListMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall ScrollTimerOnTimer(System::TObject* Sender);
	void __fastcall FormDragOver(System::TObject* Sender, System::TObject* Source, int X, int Y, System::Uitypes::TDragState State, bool &Accept);
	void __fastcall UseTFieldCheckboxClick(System::TObject* Sender);
	void __fastcall InsertNewLineButtonClick(System::TObject* Sender);
	void __fastcall ReadOnlyCBClick(System::TObject* Sender);
	void __fastcall PictureMaskEditCustomDlg(System::TObject* Sender);
	void __fastcall DBLookupComboListDropDown(System::TObject* Sender);
	void __fastcall DBLookupComboListCloseUp(Vcl::Wwdbcomb::TwwDBComboBox* Sender, bool Select);
	void __fastcall GroupNameChange(System::TObject* Sender);
	void __fastcall Button1Click(System::TObject* Sender);
	void __fastcall RegexEditCustomDlg(System::TObject* Sender);
	void __fastcall RegexEditChange(System::TObject* Sender);
	void __fastcall GroupNameEnter(System::TObject* Sender);
	
private:
	Data::Db::TDataSet* gridTable;
	Data::Db::TField* curField;
	int dragFromRow;
	bool initialized;
	System::Classes::TStrings* SrcListItems;
	Vcl::Extctrls::TTimer* ScrollTimer;
	bool GoForwards;
	bool GoBackwards;
	bool useTFields;
	System::Classes::TStrings* GSelected;
	bool InSelectDest;
	System::Classes::TComponent* Component;
	System::Classes::TStrings* controlType;
	TwwSelectedPropertyType propertyType;
	System::Uitypes::TColor OrigColor;
	void __fastcall refreshSourceList(void);
	void __fastcall getLookupFields(Data::Db::TField* curField, System::UnicodeString &databasename, System::UnicodeString &tableName, System::UnicodeString &fieldName, System::UnicodeString &index, System::UnicodeString &indexFields, System::UnicodeString &joins, System::WideChar &useExtension, int &foundIndex);
	void __fastcall getControlInfo(Data::Db::TField* curField, System::UnicodeString &controlName, System::Classes::TStrings* controlData);
	void __fastcall setControlInfo(Data::Db::TField* curField, System::UnicodeString controlName, System::Classes::TStrings* controlData);
	void __fastcall saveControlInfo(void);
	void __fastcall SavePictureMasks(void);
	void __fastcall SaveRegexMasks(void);
	
public:
	__fastcall virtual TSelFieldsForm(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TSelFieldsForm(void);
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TSelFieldsForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TSelFieldsForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE bool __fastcall wwSelectTableFields(System::Classes::TComponent* AComponent, Data::Db::TDataSet* dataSet, System::Classes::TStrings* &fields, bool &AuseTFields, Designintf::_di_IDesigner ADesigner, TwwSelectedPropertyType APropertyType);
}	/* namespace Wwselfld */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWSELFLD)
using namespace Vcl::Wwselfld;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwselfldHPP
