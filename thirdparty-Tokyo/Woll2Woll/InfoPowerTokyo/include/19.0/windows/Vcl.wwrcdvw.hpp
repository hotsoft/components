// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwrcdvw.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwrcdvwHPP
#define Vcl_WwrcdvwHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Winapi.Messages.hpp>
#include <Data.DB.hpp>
#include <Vcl.Forms.hpp>
#include <vcl.Wwdbedit.hpp>
#include <vcl.wwdatsrc.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.ExtCtrls.hpp>
#include <Vcl.Controls.hpp>
#include <vcl.Wwcommon.hpp>
#include <Vcl.DBCtrls.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.wwtypes.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.Menus.hpp>
#include <System.SysUtils.hpp>
#include <vcl.wwintl.hpp>
#include <Vcl.Buttons.hpp>
#include <System.TypInfo.hpp>
#include <vcl.Wwmemo.hpp>
#include <vcl.wwdbnavigator.hpp>
#include <vcl.wwriched.hpp>
#include <vcl.wwdblook.hpp>
#include <vcl.Wwdbdatetimepicker.hpp>
#include <vcl.wwDialog.hpp>
#include <vcl.wwframe.hpp>
#include <vcl.wwradiogroup.hpp>
#include <vcl.wwcheckbox.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Mask.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwrcdvw
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwRecordViewForm;
class DELPHICLASS TwwMargin;
class DELPHICLASS TwwVertEditSpacing;
class DELPHICLASS TwwHorzEditSpacing;
class DELPHICLASS TwwEditSpacing;
class DELPHICLASS TwwRecordViewDialog;
class DELPHICLASS TwwDBCheckBox;
class DELPHICLASS TwwLabel;
class DELPHICLASS TwwDBMemo;
class DELPHICLASS TwwDBEditMemo;
class DELPHICLASS TwwCustomControlItem;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwRecordViewForm : public Vcl::Forms::TForm
{
	typedef Vcl::Forms::TForm inherited;
	
__published:
	void __fastcall FormDeactivate(System::TObject* Sender);
	void __fastcall FormActivate(System::TObject* Sender);
	
private:
	bool Deactivated;
	
protected:
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	
public:
	System::Classes::TComponent* DlgComponent;
	Vcl::Extctrls::TPanel* RecordPanel;
	Vcl::Extctrls::TPanel* NavigatorPanel;
	Vcl::Extctrls::TPanel* ButtonPanel;
	Vcl::Wwdbnavigator::TwwDBNavigator* Navigator;
	Vcl::Forms::TScrollBox* ScrollBox;
public:
	/* TCustomForm.Create */ inline __fastcall virtual TwwRecordViewForm(System::Classes::TComponent* AOwner) : Vcl::Forms::TForm(AOwner) { }
	/* TCustomForm.CreateNew */ inline __fastcall virtual TwwRecordViewForm(System::Classes::TComponent* AOwner, int Dummy) : Vcl::Forms::TForm(AOwner, Dummy) { }
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TwwRecordViewForm(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwRecordViewForm(HWND ParentWindow) : Vcl::Forms::TForm(ParentWindow) { }
	
};


enum DECLSPEC_DENUM TwwRecordViewStyle : unsigned char { rvsVertical, rvsHorizontal };

enum DECLSPEC_DENUM TwwRecordViewOption : unsigned char { rvoHideReadOnly, rvoHideCalculated, rvoHideNavigator, rvoUseCustomControls, rvoShortenEditBox, rvoModalForm, rvoStayOnTopForm, rvoConsistentEditWidth, rvoEnterToTab, rvoConfirmCancel, rvoCloseIsCancel, rvoMaximizeMemoWidth, rvoSetControlMinWidth, rvoUseDateTimePicker, rvoLabelsBeneathControl };

typedef System::Set<TwwRecordViewOption, TwwRecordViewOption::rvoHideReadOnly, TwwRecordViewOption::rvoLabelsBeneathControl> TwwRecordViewOptions;

enum DECLSPEC_DENUM TwwRecordViewControlOption : unsigned char { rvcTransparentLabels, rvcTransparentButtons, rvcFlatButtons };

typedef System::Set<TwwRecordViewControlOption, TwwRecordViewControlOption::rvcTransparentLabels, TwwRecordViewControlOption::rvcFlatButtons> TwwRecordViewControlOptions;

enum DECLSPEC_DENUM TwwRecordViewOKCancelOption : unsigned char { rvokShowOKCancel, rvokAutoPostRec, rvokAutoCancelRec };

typedef System::Set<TwwRecordViewOKCancelOption, TwwRecordViewOKCancelOption::rvokShowOKCancel, TwwRecordViewOKCancelOption::rvokAutoCancelRec> TwwRecordViewOKCancelOptions;

enum DECLSPEC_DENUM TwwCloseAction : unsigned char { rvcOK, rvcCancel, rvcControlMenuClose };

typedef System::Set<TwwCloseAction, TwwCloseAction::rvcOK, TwwCloseAction::rvcControlMenuClose> TwwCloseActions;

typedef void __fastcall (__closure *TwwCancelEvent)(Vcl::Forms::TForm* Form, bool &CanClose);

typedef void __fastcall (__closure *TwwOnBeforeCreateControlEvent)(TwwRecordViewForm* Form, Data::Db::TField* curField, bool &Accept);

typedef void __fastcall (__closure *TwwOnAfterCreateControlEvent)(TwwRecordViewForm* Form, Data::Db::TField* curField, Vcl::Controls::TControl* Control);

typedef void __fastcall (__closure *TwwOnSetControlEffectsEvent)(TwwRecordViewForm* Form, Data::Db::TField* curField, Vcl::Controls::TControl* Control, Vcl::Wwframe::TwwEditFrame* Frame, Vcl::Wwframe::TwwButtonEffects* ButtonEffects);

typedef void __fastcall (__closure *TwwOnInitFormEvent)(TwwRecordViewForm* Form);

typedef void __fastcall (__closure *TwwRecordCustomPaintEvent)(Vcl::Forms::TScrollBox* Sender, Vcl::Graphics::TCanvas* Canvas);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwMargin : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FBottomOffset;
	int FTopOffset;
	int FLeftOffset;
	int FRightOffset;
	void __fastcall SetLeftOffset(int val);
	void __fastcall SetRightOffset(int val);
	void __fastcall SetTopOffset(int val);
	void __fastcall SetBottomOffset(int val);
	
public:
	System::Classes::TComponent* Owner;
	
__published:
	__property int BottomOffset = {read=FBottomOffset, write=SetBottomOffset, default=5};
	__property int TopOffset = {read=FTopOffset, write=SetTopOffset, default=5};
	__property int LeftOffset = {read=FLeftOffset, write=SetLeftOffset, default=5};
	__property int RightOffset = {read=FRightOffset, write=SetRightOffset, default=5};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwMargin(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwMargin(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwVertEditSpacing : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FBetweenLabelEdit;
	int FBetweenRow;
	void __fastcall SetBetweenLabelEdit(int val);
	void __fastcall SetBetweenRow(int val);
	
public:
	System::Classes::TComponent* Owner;
	
__published:
	__property int BetweenLabelEdit = {read=FBetweenLabelEdit, write=SetBetweenLabelEdit, default=5};
	__property int BetweenRow = {read=FBetweenRow, write=SetBetweenRow, default=2};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwVertEditSpacing(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwVertEditSpacing(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwHorzEditSpacing : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FBetweenLabelEdit;
	int FBetweenEditsInRow;
	int FBetweenRow;
	int FLabelIndent;
	void __fastcall SetBetweenEditsInRow(int val);
	void __fastcall SetBetweenLabelEdit(int val);
	void __fastcall SetBetweenRow(int val);
	void __fastcall SetLabelIndent(int val);
	
public:
	System::Classes::TComponent* Owner;
	
__published:
	__property int BetweenEditsInRow = {read=FBetweenEditsInRow, write=SetBetweenEditsInRow, default=5};
	__property int BetweenLabelEdit = {read=FBetweenLabelEdit, write=SetBetweenLabelEdit, default=1};
	__property int BetweenRow = {read=FBetweenRow, write=SetBetweenRow, default=2};
	__property int LabelIndent = {read=FLabelIndent, write=SetLabelIndent, default=1};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwHorzEditSpacing(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwHorzEditSpacing(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwEditSpacing : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TwwHorzEditSpacing* FHorizontalView;
	TwwVertEditSpacing* FVerticalView;
	
public:
	__fastcall virtual ~TwwEditSpacing(void);
	
__published:
	__property TwwHorzEditSpacing* HorizontalView = {read=FHorizontalView, write=FHorizontalView};
	__property TwwVertEditSpacing* VerticalView = {read=FVerticalView, write=FVerticalView};
public:
	/* TObject.Create */ inline __fastcall TwwEditSpacing(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwRecordViewDialog : public Vcl::Wwdialog::TwwCustomDialog
{
	typedef Vcl::Wwdialog::TwwCustomDialog inherited;
	
private:
	Vcl::Wwintl::TwwController* FController;
	Vcl::Controls::TWinControl* FOldNavParent;
	System::Classes::TStrings* FSelected;
	bool FUseTFields;
	System::Classes::TList* FControlList;
	System::Classes::TList* FLabelList;
	TwwEditSpacing* FEditSpacing;
	TwwMargin* FMargin;
	Vcl::Wwtypes::TwwFormPosition* FFormPosition;
	Vcl::Forms::TFormBorderStyle FBorderStyle;
	Data::Db::TDataLink* FDataLink;
	TwwRecordViewOptions FOptions;
	TwwRecordViewControlOptions FControlOptions;
	TwwRecordViewOKCancelOptions FOKCancelOptions;
	Vcl::Graphics::TFont* FFont;
	Vcl::Graphics::TFont* FLabelFont;
	TwwOnBeforeCreateControlEvent FOnBeforeCreateControl;
	TwwOnAfterCreateControlEvent FOnAfterCreateControl;
	TwwOnSetControlEffectsEvent FOnSetControlEffects;
	TwwOnInitFormEvent FOnInitDialog;
	TwwOnInitFormEvent FOnCloseDialog;
	TwwOnInitFormEvent FOnResizeDialog;
	System::UnicodeString FCaption;
	System::Uitypes::TColor FReadOnlyColor;
	TwwRecordViewStyle FStyle;
	Vcl::Menus::TMainMenu* FMenu;
	Vcl::Wwdbnavigator::TwwNavButtonNavStylesEx FNavigatorButtons;
	bool FNavigatorFlat;
	Vcl::Wwdbnavigator::TwwDBNavigator* FNavigator;
	TwwCancelEvent FOnCancelWarning;
	int FLinesPerMemoControl;
	int EditStartOffset;
	int FormWidth;
	int FormHeight;
	TwwCloseAction CloseAction;
	System::Classes::TList* CustomControlList;
	System::Classes::TStrings* FControlType;
	bool FControlInfoInDataset;
	System::Classes::TStrings* FPictureMasks;
	System::Classes::TStrings* FRegexMasks;
	bool FPictureMaskFromDataSet;
	Vcl::Wwframe::TwwEditFrame* FDefaultEditFrame;
	int FixedEditWidthConst;
	Vcl::Stdctrls::TLabel* CurLabel;
	void __fastcall SetController(Vcl::Wwintl::TwwController* Value);
	void __fastcall SetNavParent(Vcl::Controls::TWinControl* NewParent, bool SaveOld);
	void __fastcall SetDataSource(Data::Db::TDataSource* value);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	void __fastcall SetLabelFont(Vcl::Graphics::TFont* val);
	void __fastcall SetFont(Vcl::Graphics::TFont* val);
	void __fastcall SetNavigator(Vcl::Wwdbnavigator::TwwDBNavigator* Value);
	bool __fastcall ShowField(Data::Db::TField* field, bool curFieldReadOnly);
	void __fastcall FormShow(System::TObject* Sender);
	void __fastcall FormResize(System::TObject* Sender);
	void __fastcall CreateMainMenu(TwwRecordViewForm* Form, Vcl::Menus::TMainMenu* mm);
	void __fastcall FormCloseQuery(System::TObject* Sender, bool &CanClose);
	void __fastcall FormClose(System::TObject* Sender, System::Uitypes::TCloseAction &Action);
	void __fastcall AddCustomControl(Vcl::Controls::TWinControl* CustomEdit);
	bool __fastcall IsModified(void);
	bool __fastcall IsCheckBox(Data::Db::TField* curField, System::UnicodeString &checkboxOn, System::UnicodeString &checkboxOff);
	void __fastcall SetPictureMasks(System::Classes::TStrings* val);
	void __fastcall SetRegexMasks(System::Classes::TStrings* val);
	void __fastcall SetControlType(System::Classes::TStrings* val);
	void __fastcall InitPictureMask(Vcl::Controls::TWinControl* EditControl, Data::Db::TField* curField);
	
protected:
	virtual bool __fastcall IsSingleLineEditControl(Vcl::Controls::TWinControl* EditControl);
	virtual void __fastcall DoOnBeforeCreateControl(TwwRecordViewForm* form, Data::Db::TField* curField, bool &accept);
	virtual void __fastcall DoOnAfterCreateControl(TwwRecordViewForm* form, Data::Db::TField* curField, Vcl::Controls::TControl* Control);
	virtual void __fastcall DoSetControlEffects(TwwRecordViewForm* form, Data::Db::TField* curfield, Vcl::Controls::TControl* control, Vcl::Wwframe::TwwEditFrame* Frame, Vcl::Wwframe::TwwButtonEffects* ButtonEffects);
	virtual void __fastcall DoInitDialog(TwwRecordViewForm* Form);
	virtual void __fastcall DoCloseDialog(TwwRecordViewForm* Form);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall DisplayVertical(void);
	void __fastcall DisplayHorizontal(void);
	virtual void __fastcall DoCancelWarning(bool &CanClose);
	void __fastcall SetNavigatorVisibleButtons(Vcl::Dbctrls::TNavButtonSet Value);
	bool __fastcall HasFrame(Vcl::Controls::TWinControl* Control);
	bool __fastcall HasButtonEffects(Vcl::Controls::TWinControl* Control);
	bool __fastcall IsControlModified(Vcl::Controls::TWinControl* Control);
	
public:
	Vcl::Stdctrls::TButton* OKBtn;
	Vcl::Stdctrls::TButton* CancelBtn;
	TwwRecordViewForm* RecordViewForm;
	System::Variant Patch;
	__fastcall virtual TwwRecordViewDialog(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwRecordViewDialog(void);
	virtual Data::Db::TDataSet* __fastcall GetPrimaryDataSet(void);
	virtual bool __fastcall Execute(void);
	virtual void __fastcall OKBtnClick(System::TObject* Sender);
	virtual void __fastcall CancelBtnClick(System::TObject* Sender);
	
__published:
	__property Vcl::Wwintl::TwwController* Controller = {read=FController, write=SetController};
	__property System::Classes::TStrings* ControlType = {read=FControlType, write=SetControlType};
	__property bool ControlInfoInDataset = {read=FControlInfoInDataset, write=FControlInfoInDataset, default=1};
	__property bool PictureMaskFromDataSet = {read=FPictureMaskFromDataSet, write=FPictureMaskFromDataSet, default=1};
	__property System::Classes::TStrings* PictureMasks = {read=FPictureMasks, write=SetPictureMasks};
	__property System::Classes::TStrings* RegexMasks = {read=FRegexMasks, write=SetRegexMasks};
	__property Vcl::Wwframe::TwwEditFrame* EditFrame = {read=FDefaultEditFrame, write=FDefaultEditFrame};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property TwwEditSpacing* EditSpacing = {read=FEditSpacing, write=FEditSpacing};
	__property TwwMargin* Margin = {read=FMargin, write=FMargin};
	__property Vcl::Forms::TFormBorderStyle BorderStyle = {read=FBorderStyle, write=FBorderStyle, default=2};
	__property Vcl::Wwtypes::TwwFormPosition* FormPosition = {read=FFormPosition, write=FFormPosition};
	__property Vcl::Wwdbnavigator::TwwNavButtonNavStylesEx NavigatorButtons = {read=FNavigatorButtons, write=FNavigatorButtons, nodefault};
	__property Vcl::Dbctrls::TNavButtonSet NavigatorVisibleButtons = {write=SetNavigatorVisibleButtons, stored=false, nodefault};
	__property TwwRecordViewStyle Style = {read=FStyle, write=FStyle, default=0};
	__property TwwRecordViewOptions Options = {read=FOptions, write=FOptions, default=11832};
	__property TwwRecordViewControlOptions ControlOptions = {read=FControlOptions, write=FControlOptions, nodefault};
	__property TwwRecordViewOKCancelOptions OKCancelOptions = {read=FOKCancelOptions, write=FOKCancelOptions, default=7};
	__property Vcl::Graphics::TFont* LabelFont = {read=FLabelFont, write=SetLabelFont};
	__property Vcl::Graphics::TFont* Font = {read=FFont, write=SetFont};
	__property TwwOnBeforeCreateControlEvent OnBeforeCreateControl = {read=FOnBeforeCreateControl, write=FOnBeforeCreateControl};
	__property TwwOnAfterCreateControlEvent OnAfterCreateControl = {read=FOnAfterCreateControl, write=FOnAfterCreateControl};
	__property TwwOnSetControlEffectsEvent OnSetControlEffects = {read=FOnSetControlEffects, write=FOnSetControlEffects};
	__property TwwOnInitFormEvent OnInitDialog = {read=FOnInitDialog, write=FOnInitDialog};
	__property TwwOnInitFormEvent OnCloseDialog = {read=FOnCloseDialog, write=FOnCloseDialog};
	__property TwwOnInitFormEvent OnResizeDialog = {read=FOnResizeDialog, write=FOnResizeDialog};
	__property System::UnicodeString Caption = {read=FCaption, write=FCaption};
	__property System::Uitypes::TColor ReadOnlyColor = {read=FReadOnlyColor, write=FReadOnlyColor, default=-16777197};
	__property Vcl::Menus::TMainMenu* Menu = {read=FMenu, write=FMenu};
	__property System::Classes::TStrings* Selected = {read=FSelected, write=FSelected};
	__property bool NavigatorFlat = {read=FNavigatorFlat, write=FNavigatorFlat, default=0};
	__property Vcl::Wwdbnavigator::TwwDBNavigator* Navigator = {read=FNavigator, write=SetNavigator};
	__property TwwCancelEvent OnCancelWarning = {read=FOnCancelWarning, write=FOnCancelWarning};
	__property int LinesPerMemoControl = {read=FLinesPerMemoControl, write=FLinesPerMemoControl, default=2};
	
protected:
	virtual Vcl::Stdctrls::TCustomEdit* __fastcall CreateDefaultEditControl(System::Classes::TComponent* AOwner);
};


class PASCALIMPLEMENTATION TwwDBCheckBox : public Vcl::Wwcheckbox::TwwCheckBox
{
	typedef Vcl::Wwcheckbox::TwwCheckBox inherited;
	
protected:
	DYNAMIC void __fastcall DoEnter(void);
	DYNAMIC void __fastcall DoExit(void);
	
public:
	Vcl::Stdctrls::TLabel* LabelControl;
public:
	/* TwwDBCustomCheckBox.Create */ inline __fastcall virtual TwwDBCheckBox(System::Classes::TComponent* AOwner) : Vcl::Wwcheckbox::TwwCheckBox(AOwner) { }
	/* TwwDBCustomCheckBox.Destroy */ inline __fastcall virtual ~TwwDBCheckBox(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBCheckBox(HWND ParentWindow) : Vcl::Wwcheckbox::TwwCheckBox(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwLabel : public Vcl::Stdctrls::TLabel
{
	typedef Vcl::Stdctrls::TLabel inherited;
	
protected:
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
public:
	/* TCustomLabel.Create */ inline __fastcall virtual TwwLabel(System::Classes::TComponent* AOwner) : Vcl::Stdctrls::TLabel(AOwner) { }
	
public:
	/* TGraphicControl.Destroy */ inline __fastcall virtual ~TwwLabel(void) { }
	
};


class PASCALIMPLEMENTATION TwwDBMemo : public Vcl::Dbctrls::TDBMemo
{
	typedef Vcl::Dbctrls::TDBMemo inherited;
	
protected:
	DYNAMIC void __fastcall KeyDown(System::Word &key, System::Classes::TShiftState shift);
public:
	/* TDBMemo.Create */ inline __fastcall virtual TwwDBMemo(System::Classes::TComponent* AOwner) : Vcl::Dbctrls::TDBMemo(AOwner) { }
	/* TDBMemo.Destroy */ inline __fastcall virtual ~TwwDBMemo(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBMemo(HWND ParentWindow) : Vcl::Dbctrls::TDBMemo(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwDBEditMemo : public Vcl::Wwdbedit::TwwDBCustomEdit
{
	typedef Vcl::Wwdbedit::TwwDBCustomEdit inherited;
	
public:
	__fastcall virtual TwwDBEditMemo(System::Classes::TComponent* AOwner);
	DYNAMIC void __fastcall KeyDown(System::Word &key, System::Classes::TShiftState shift);
	
__published:
	__property AutoSize = {default=1};
	__property BorderStyle = {default=1};
	__property DataField = {default=0};
	__property DataSource;
	__property Frame;
public:
	/* TwwDBCustomEdit.Destroy */ inline __fastcall virtual ~TwwDBEditMemo(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBEditMemo(HWND ParentWindow) : Vcl::Wwdbedit::TwwDBCustomEdit(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwCustomControlItem : public System::TObject
{
	typedef System::TObject inherited;
	
public:
	Vcl::Controls::TWinControl* control;
	int Left;
	int Top;
	int Width;
	int Height;
	Vcl::Controls::TWinControl* OldParent;
	bool OldVisible;
	bool ButtonFlat;
	bool ButtonTransparent;
public:
	/* TObject.Create */ inline __fastcall TwwCustomControlItem(void) : System::TObject() { }
	/* TObject.Destroy */ inline __fastcall virtual ~TwwCustomControlItem(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwRecordViewForm* wwRecordViewForm;
extern DELPHI_PACKAGE bool __fastcall wwIsCheckBox(System::Classes::TComponent* Component, Data::Db::TField* curField, System::UnicodeString &checkboxOn, System::UnicodeString &checkboxOff);
}	/* namespace Wwrcdvw */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWRCDVW)
using namespace Vcl::Wwrcdvw;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwrcdvwHPP
