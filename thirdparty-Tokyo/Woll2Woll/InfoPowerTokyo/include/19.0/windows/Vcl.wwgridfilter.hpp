// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwgridfilter.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwgridfilterHPP
#define Vcl_WwgridfilterHPP

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
#include <System.Variants.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Grids.hpp>
#include <Data.DB.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.Wwstr.hpp>
#include <Vcl.ImgList.hpp>
#include <vcl.wwmenuitem.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Winapi.CommCtrl.hpp>
#include <Vcl.Themes.hpp>
#include <vcl.wwtreeview.hpp>
#include <vcl.wwintl.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwgridfilter
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwFormGridFilterTypes;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwFormGridFilterTypes : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	Vcl::Controls::TImageList* ImageList1;
	Vcl::Menus::TPopupMenu* PopupFilterMenu;
	Vcl::Wwmenuitem::TwwMenuItem* SortSmallesttoLargest1;
	Vcl::Wwmenuitem::TwwMenuItem* SortLargesttoSmallest1;
	Vcl::Wwmenuitem::TwwMenuItem* N1;
	Vcl::Wwmenuitem::TwwMenuItem* ClearFilter1;
	Vcl::Wwmenuitem::TwwMenuItem* NumberFilters1;
	Vcl::Wwmenuitem::TwwMenuItem* Equals1;
	Vcl::Wwmenuitem::TwwMenuItem* Doesnotequal1;
	Vcl::Wwmenuitem::TwwMenuItem* LessThan1;
	Vcl::Wwmenuitem::TwwMenuItem* GreaterThan1;
	Vcl::Wwmenuitem::TwwMenuItem* Between1;
	Vcl::Wwmenuitem::TwwMenuItem* TextFilters1;
	Vcl::Wwmenuitem::TwwMenuItem* Equals2;
	Vcl::Wwmenuitem::TwwMenuItem* Doesnotequal2;
	Vcl::Wwmenuitem::TwwMenuItem* Startswith1;
	Vcl::Wwmenuitem::TwwMenuItem* Doesnotstartwith1;
	Vcl::Wwmenuitem::TwwMenuItem* Contains1;
	Vcl::Wwmenuitem::TwwMenuItem* Doesnotcontain1;
	Vcl::Wwmenuitem::TwwMenuItem* Endswith1;
	Vcl::Wwmenuitem::TwwMenuItem* Doesnotendwith1;
	Vcl::Wwmenuitem::TwwMenuItem* N2;
	Vcl::Wwmenuitem::TwwMenuItem* GroupBy1;
	Vcl::Menus::TMenuItem* DateFilters1;
	Vcl::Menus::TMenuItem* Equals3;
	Vcl::Menus::TMenuItem* N3;
	Vcl::Menus::TMenuItem* Before1;
	Vcl::Menus::TMenuItem* After1;
	Vcl::Menus::TMenuItem* Between2;
	Vcl::Menus::TMenuItem* N4;
	Vcl::Menus::TMenuItem* Tomorrow1;
	Vcl::Menus::TMenuItem* Today1;
	Vcl::Menus::TMenuItem* Yesterday1;
	Vcl::Menus::TMenuItem* N5;
	Vcl::Menus::TMenuItem* NextWeek1;
	Vcl::Menus::TMenuItem* ThisWeek1;
	Vcl::Menus::TMenuItem* LastWeek1;
	Vcl::Menus::TMenuItem* N6;
	Vcl::Menus::TMenuItem* NextMonth1;
	Vcl::Menus::TMenuItem* ThisMonth1;
	Vcl::Menus::TMenuItem* LastMonth1;
	Vcl::Menus::TMenuItem* N7;
	Vcl::Menus::TMenuItem* NextQuarter1;
	Vcl::Menus::TMenuItem* ThisQuarter1;
	Vcl::Menus::TMenuItem* LastQuarter1;
	Vcl::Menus::TMenuItem* N8;
	Vcl::Menus::TMenuItem* NextYear1;
	Vcl::Menus::TMenuItem* ThisYear1;
	Vcl::Menus::TMenuItem* LastYear1;
	Vcl::Menus::TMenuItem* AddRemoveColumns1;
	Vcl::Menus::TMenuItem* N9;
	Vcl::Menus::TMenuItem* RemoveColumn1;
	Vcl::Menus::TMenuItem* AddColumnsAfter1;
	Vcl::Menus::TMenuItem* AddColumnsBefore1;
	Vcl::Menus::TMenuItem* ClearGroupBy1;
	Vcl::Menus::TMenuItem* IsNull1;
	Vcl::Menus::TMenuItem* IsNotNull1;
	Vcl::Menus::TMenuItem* IsNull2;
	Vcl::Menus::TMenuItem* IsNotNull2;
	Vcl::Menus::TMenuItem* IsNull3;
	Vcl::Menus::TMenuItem* IsNotNull3;
	Vcl::Menus::TMenuItem* NullSeparatorDate;
	Vcl::Menus::TMenuItem* NullSeparatorText;
	Vcl::Menus::TMenuItem* NullSeparatorNumber;
	void __fastcall SortSmallesttoLargest1Click(System::TObject* Sender);
	void __fastcall SortLargesttoSmallest1Click(System::TObject* Sender);
	void __fastcall PopupFilterMenuPopup(System::TObject* Sender);
	void __fastcall FilterMenuItemClick(System::TObject* Sender);
	void __fastcall ClearFilter1Click(System::TObject* Sender);
	void __fastcall GroupBy1Click(System::TObject* Sender);
	void __fastcall AddColumnsBefore1Click(System::TObject* Sender);
	void __fastcall RemoveColumn1Click(System::TObject* Sender);
	void __fastcall AddColumnsAfter1Click(System::TObject* Sender);
	void __fastcall AddRemoveColumns1Click(System::TObject* Sender);
	void __fastcall ClearGroupBy1Click(System::TObject* Sender);
	
private:
	bool __fastcall HaveAscendingIndexDefs(void);
	bool __fastcall HaveDescendingIndexDefs(void);
	Data::Db::TDataSet* __fastcall GetDataSet(void);
	void __fastcall RemoveItem(System::UnicodeString fieldName);
	System::UnicodeString __fastcall GetFieldName(void);
	Data::Db::TField* __fastcall GetField(void);
	void __fastcall ApplyIntl(void);
	
public:
	Vcl::Grids::TCustomGrid* Grid;
	System::TObject* Column;
	System::Classes::TComponent* FilterDialog;
	__fastcall virtual TwwFormGridFilterTypes(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwFormGridFilterTypes(void);
	System::TObject* __fastcall FindItem(System::UnicodeString fieldName);
	bool __fastcall IsClientCursor(void);
	void __fastcall SortAscending(System::UnicodeString fieldName = System::UnicodeString());
	void __fastcall SortDescending(System::UnicodeString fieldName = System::UnicodeString());
public:
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwFormGridFilterTypes(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwFormGridFilterTypes(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


enum DECLSPEC_DENUM TwwfcItemState : unsigned char { wwfcisSelected, wwfcisGrayed, wwfcisDisabled, wwfcisChecked, wwfcisFocused, wwfcisDefault, wwfcisHot, wwfcisMarked, wwfcisIndeterminate };

typedef System::Set<TwwfcItemState, TwwfcItemState::wwfcisSelected, TwwfcItemState::wwfcisIndeterminate> TwwfcItemStates;

enum DECLSPEC_DENUM TwwTreeViewCheckboxType : unsigned char { wwtvctNone, wwtvctCheckbox, wwtvctRadioGroup };

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwFormGridFilterTypes* wwFormGridFilterTypes;
}	/* namespace Wwgridfilter */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWGRIDFILTER)
using namespace Vcl::Wwgridfilter;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwgridfilterHPP
