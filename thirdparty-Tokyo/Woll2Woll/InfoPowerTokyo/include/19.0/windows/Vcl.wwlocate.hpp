// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwlocate.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwlocateHPP
#define Vcl_WwlocateHPP

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
#include <Vcl.Buttons.hpp>
#include <Data.DB.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <vcl.wwDialog.hpp>
#include <Vcl.DBCtrls.hpp>
#include <vcl.Wwstr.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwlocate
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwLocateDlg;
class DELPHICLASS TwwLocateDialog;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwLocateMatchType : unsigned char { mtExactMatch, mtPartialMatchStart, mtPartialMatchAny };

enum DECLSPEC_DENUM TwwFieldSortType : unsigned char { fsSortByFieldNo, fsSortByFieldName };

enum DECLSPEC_DENUM TwwDefaultButtonType : unsigned char { dbFindFirst, dbFindNext };

enum DECLSPEC_DENUM TwwFieldSelection : unsigned char { fsAllFields, fsVisibleFields };

enum DECLSPEC_DENUM TwwLocateDlgOption : unsigned char { ldoCaseSensitiveBelow, ldoCloseOnMatch, ldoPreserveSearchText };

typedef System::Set<TwwLocateDlgOption, TwwLocateDlgOption::ldoCaseSensitiveBelow, TwwLocateDlgOption::ldoPreserveSearchText> TwwLocateDlgOptions;

typedef void __fastcall (__closure *TwwOnInitLocateDlgEvent)(TwwLocateDlg* Dialog);

typedef void __fastcall (__closure *TwwLocateSelectFieldEvent)(TwwLocateDlg* Dialog, System::UnicodeString SearchField);

class PASCALIMPLEMENTATION TwwLocateDlg : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Stdctrls::TGroupBox* SearchTypeGroup;
	Vcl::Stdctrls::TGroupBox* FieldsGroup;
	Vcl::Stdctrls::TCheckBox* CaseSensitiveCheckBox;
	Vcl::Stdctrls::TRadioButton* ExactMatchBtn;
	Vcl::Stdctrls::TRadioButton* PartialMatchStartBtn;
	Vcl::Stdctrls::TRadioButton* PartialMatchAnyBtn;
	Vcl::Extctrls::TPanel* Panel1;
	Vcl::Stdctrls::TGroupBox* FieldValueGroup;
	Vcl::Stdctrls::TEdit* SearchValue;
	Vcl::Stdctrls::TButton* FirstButton;
	Vcl::Stdctrls::TButton* NextButton;
	Vcl::Stdctrls::TComboBox* FieldNameComboBox;
	void __fastcall FindFirst(System::TObject* Sender);
	void __fastcall FindNextBtnClick(System::TObject* Sender);
	void __fastcall BitBtn1KeyUp(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FieldNameComboBoxChange(System::TObject* Sender);
	void __fastcall FieldNameComboBoxEnter(System::TObject* Sender);
	void __fastcall FieldNameComboBoxExit(System::TObject* Sender);
	void __fastcall FieldNameComboBoxKeyDown(System::TObject* Sender, System::Word &Key, System::Classes::TShiftState Shift);
	void __fastcall FormShow(System::TObject* Sender);
	
private:
	System::UnicodeString __fastcall GetFieldNameFromTitle(System::UnicodeString fieldTitle);
	void __fastcall ApplyIntl(void);
	
public:
	Data::Db::TDataSet* DataSet;
	Vcl::Stdctrls::TCustomButton* CancelBtn;
	System::Classes::TComponent* DlgComponent;
	bool __fastcall FindMatch(bool FromBeginning);
	__fastcall virtual TwwLocateDlg(System::Classes::TComponent* AOwner);
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwLocateDlg(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TwwLocateDlg(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwLocateDlg(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwLocateDialog : public Vcl::Wwdialog::TwwCustomDialog
{
	typedef Vcl::Wwdialog::TwwCustomDialog inherited;
	
private:
	System::UnicodeString FCaption;
	System::UnicodeString FDataField;
	Data::Db::TDataLink* FDataLink;
	System::UnicodeString FFieldValue;
	TwwLocateMatchType FMatchType;
	bool FCaseSensitive;
	TwwFieldSortType FSortFields;
	TwwDefaultButtonType FDefaultButton;
	TwwFieldSelection FFieldSelection;
	bool FShowMessages;
	TwwLocateDlgOptions FOptions;
	TwwOnInitLocateDlgEvent FOnInitDialog;
	TwwLocateSelectFieldEvent FOnSelectField;
	bool FUseLocateMethod;
	void __fastcall SetDataSource(Data::Db::TDataSource* value);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	
protected:
	virtual void __fastcall DoInitDialog(void);
	
public:
	TwwLocateDlg* Form;
	System::Variant Patch;
	virtual Data::Db::TDataSet* __fastcall GetPrimaryDataSet(void);
	__fastcall virtual TwwLocateDialog(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwLocateDialog(void);
	virtual bool __fastcall Execute(void);
	bool __fastcall FindPrior(void);
	bool __fastcall FindNext(void);
	bool __fastcall FindFirst(void);
	__property System::UnicodeString FieldValue = {read=FFieldValue, write=FFieldValue};
	
__published:
	__property System::UnicodeString Caption = {read=FCaption, write=FCaption};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property System::UnicodeString SearchField = {read=FDataField, write=FDataField};
	__property TwwLocateMatchType MatchType = {read=FMatchType, write=FMatchType, nodefault};
	__property bool CaseSensitive = {read=FCaseSensitive, write=FCaseSensitive, nodefault};
	__property TwwFieldSortType SortFields = {read=FSortFields, write=FSortFields, nodefault};
	__property TwwDefaultButtonType DefaultButton = {read=FDefaultButton, write=FDefaultButton, nodefault};
	__property TwwFieldSelection FieldSelection = {read=FFieldSelection, write=FFieldSelection, nodefault};
	__property bool ShowMessages = {read=FShowMessages, write=FShowMessages, nodefault};
	__property bool UseLocateMethod = {read=FUseLocateMethod, write=FUseLocateMethod, default=0};
	__property TwwLocateDlgOptions Options = {read=FOptions, write=FOptions, default=2};
	__property TwwOnInitLocateDlgEvent OnInitDialog = {read=FOnInitDialog, write=FOnInitDialog};
	__property TwwLocateSelectFieldEvent OnSelectField = {read=FOnSelectField, write=FOnSelectField};
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwLocateDlg* wwLocateDlg;
extern DELPHI_PACKAGE bool __fastcall wwFindMatch(bool FromBeginning, Data::Db::TDataSet* DataSet, System::UnicodeString searchField, System::UnicodeString searchValue, TwwLocateMatchType matchType, bool caseSens, bool UseLocateMethod = false);
}	/* namespace Wwlocate */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWLOCATE)
using namespace Vcl::Wwlocate;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwlocateHPP
