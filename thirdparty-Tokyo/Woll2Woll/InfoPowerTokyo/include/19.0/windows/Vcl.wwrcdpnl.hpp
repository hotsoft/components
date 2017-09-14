// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwrcdpnl.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwrcdpnlHPP
#define Vcl_WwrcdpnlHPP

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
#include <vcl.Wwrcdvw.hpp>
#include <Data.DB.hpp>
#include <vcl.wwdatsrc.hpp>
#include <Vcl.StdCtrls.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.Wwdbedit.hpp>
#include <Vcl.DBCtrls.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.wwframe.hpp>
#include <vcl.wwintl.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwrcdpnl
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwRecordViewPanel;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwRecordViewPanelStyle : unsigned char { rvpsVertical, rvpsHorizontal };

enum DECLSPEC_DENUM TwwRecordViewPanelOption : unsigned char { rvopHideReadOnly, rvopHideCalculated, rvopUseCustomControls, rvopShortenEditBox, rvopConsistentEditWidth, rvopMaximizeMemoWidth, rvopUseDateTimePicker, rvopLabelsBeneathControl };

typedef System::Set<TwwRecordViewPanelOption, TwwRecordViewPanelOption::rvopHideReadOnly, TwwRecordViewPanelOption::rvopLabelsBeneathControl> TwwRecordViewPanelOptions;

typedef void __fastcall (__closure *TwwRecordOnBeforeCreateControl)(System::TObject* Sender, Data::Db::TField* curField, bool &Accept);

typedef void __fastcall (__closure *TwwRecordOnAfterCreateControl)(System::TObject* Sender, Data::Db::TField* curField, Vcl::Controls::TControl* Control);

typedef void __fastcall (__closure *TwwRecordSetControlEffects)(System::TObject* Sender, Data::Db::TField* curField, Vcl::Controls::TControl* Control, Vcl::Wwframe::TwwEditFrame* Frame, Vcl::Wwframe::TwwButtonEffects* ButtonEffects);

class PASCALIMPLEMENTATION TwwRecordViewPanel : public Vcl::Forms::TScrollBox
{
	typedef Vcl::Forms::TScrollBox inherited;
	
private:
	System::Classes::TStrings* FSelected;
	bool FUseTFields;
	Vcl::Wwrcdvw::TwwEditSpacing* FEditSpacing;
	Vcl::Wwrcdvw::TwwMargin* FMargin;
	Data::Db::TDataLink* FDataLink;
	TwwRecordViewPanelOptions FOptions;
	Vcl::Wwrcdvw::TwwRecordViewControlOptions FControlOptions;
	Vcl::Graphics::TFont* FLabelFont;
	TwwRecordOnBeforeCreateControl FOnBeforeCreateControl;
	TwwRecordOnAfterCreateControl FOnAfterCreateControl;
	TwwRecordSetControlEffects FOnSetControlEffects;
	System::Uitypes::TColor FReadOnlyColor;
	TwwRecordViewPanelStyle FStyle;
	int FLinesPerMemoControl;
	Vcl::Controls::TWinControl* FParentObject;
	Vcl::Wwframe::TwwEditFrame* FDefaultEditFrame;
	int EditStartOffset;
	System::Classes::TList* CustomControlList;
	bool InApply;
	bool RecreateNextTime;
	System::Classes::TList* ControlPositions;
	System::Classes::TStrings* FControlType;
	bool FControlInfoInDataset;
	System::Classes::TStrings* FPictureMasks;
	System::Classes::TStrings* FRegexMasks;
	bool FPictureMaskFromDataSet;
	Vcl::Stdctrls::TLabel* CurLabel;
	Vcl::Wwintl::TwwController* FController;
	void __fastcall SetController(Vcl::Wwintl::TwwController* Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* value);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	void __fastcall SetLabelFont(Vcl::Graphics::TFont* val);
	bool __fastcall ShowField(Data::Db::TField* field, bool curFieldReadOnly);
	void __fastcall AddCustomControl(Vcl::Controls::TWinControl* CustomEdit);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	void __fastcall LabelFontChanged(System::TObject* Sender);
	void __fastcall SetOptions(TwwRecordViewPanelOptions val);
	void __fastcall SetControlOptions(Vcl::Wwrcdvw::TwwRecordViewControlOptions val);
	void __fastcall SetStyle(TwwRecordViewPanelStyle val);
	bool __fastcall IsCustomEditCell(Data::Db::TField* curField, Vcl::Controls::TWinControl* &customEdit);
	bool __fastcall UseCustomControls(void);
	void __fastcall AddControlPosition(Vcl::Controls::TControl* Control, int Left, int Top, int Width, int Height);
	void __fastcall SetLinesPerMemoControl(int val);
	void __fastcall SetPictureMasks(System::Classes::TStrings* val);
	void __fastcall SetRegexMasks(System::Classes::TStrings* val);
	void __fastcall SetControlType(System::Classes::TStrings* val);
	
protected:
	virtual bool __fastcall IsSingleLineEditControl(Vcl::Controls::TWinControl* EditControl);
	virtual void __fastcall DoOnBeforeCreateControl(System::TObject* Sender, Data::Db::TField* curField, bool &accept);
	virtual void __fastcall DoOnAfterCreateControl(System::TObject* Sender, Data::Db::TField* curField, Vcl::Controls::TControl* Control);
	void __fastcall DoSetControlEffects(System::TObject* Sender, Data::Db::TField* curfield, Vcl::Controls::TControl* control, Vcl::Wwframe::TwwEditFrame* Frame, Vcl::Wwframe::TwwButtonEffects* ButtonEffects);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall DisplayVertical(bool Recreate);
	void __fastcall DisplayHorizontal(bool Recreate);
	DYNAMIC void __fastcall Resize(void);
	virtual void __fastcall LinkActive(bool Value);
	void __fastcall FreeNonCustomControls(bool DestroyControls);
	virtual bool __fastcall Apply(bool Recreate);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	bool __fastcall HasFrame(Vcl::Controls::TWinControl* Control);
	bool __fastcall HasButtonEffects(Vcl::Controls::TWinControl* Control);
	virtual void __fastcall CreateWnd(void);
	DYNAMIC bool __fastcall DoMouseWheelDown(System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos);
	DYNAMIC bool __fastcall DoMouseWheelUp(System::Classes::TShiftState Shift, const System::Types::TPoint &MousePos);
	
public:
	System::Variant Patch;
	__fastcall virtual TwwRecordViewPanel(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwRecordViewPanel(void);
	void __fastcall RefreshControls(void);
	void __fastcall RecreateControls(void);
	void __fastcall ClearControls(void);
	
__published:
	__property Vcl::Wwintl::TwwController* Controller = {read=FController, write=SetController};
	__property Anchors = {default=3};
	__property Constraints;
	__property bool ControlInfoInDataset = {read=FControlInfoInDataset, write=FControlInfoInDataset, default=1};
	__property System::Classes::TStrings* ControlType = {read=FControlType, write=SetControlType};
	__property bool PictureMaskFromDataSet = {read=FPictureMaskFromDataSet, write=FPictureMaskFromDataSet, default=1};
	__property System::Classes::TStrings* PictureMasks = {read=FPictureMasks, write=SetPictureMasks};
	__property System::Classes::TStrings* RegexMasks = {read=FRegexMasks, write=SetRegexMasks};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property Vcl::Wwframe::TwwEditFrame* EditFrame = {read=FDefaultEditFrame, write=FDefaultEditFrame};
	__property Vcl::Wwrcdvw::TwwEditSpacing* EditSpacing = {read=FEditSpacing, write=FEditSpacing};
	__property Vcl::Wwrcdvw::TwwMargin* Margin = {read=FMargin, write=FMargin};
	__property TwwRecordViewPanelStyle Style = {read=FStyle, write=SetStyle, default=0};
	__property TwwRecordViewPanelOptions Options = {read=FOptions, write=SetOptions, default=108};
	__property Vcl::Wwrcdvw::TwwRecordViewControlOptions ControlOptions = {read=FControlOptions, write=SetControlOptions, nodefault};
	__property Vcl::Graphics::TFont* LabelFont = {read=FLabelFont, write=SetLabelFont};
	__property System::Uitypes::TColor ReadOnlyColor = {read=FReadOnlyColor, write=FReadOnlyColor, default=-16777197};
	__property System::Classes::TStrings* Selected = {read=FSelected, write=FSelected};
	__property int LinesPerMemoControl = {read=FLinesPerMemoControl, write=SetLinesPerMemoControl, default=2};
	__property TwwRecordOnBeforeCreateControl OnBeforeCreateControl = {read=FOnBeforeCreateControl, write=FOnBeforeCreateControl};
	__property TwwRecordOnAfterCreateControl OnAfterCreateControl = {read=FOnAfterCreateControl, write=FOnAfterCreateControl};
	__property TwwRecordSetControlEffects OnSetControlEffects = {read=FOnSetControlEffects, write=FOnSetControlEffects};
	
protected:
	virtual Vcl::Stdctrls::TCustomEdit* __fastcall CreateDefaultEditControl(System::Classes::TComponent* AOwner);
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwRecordViewPanel(HWND ParentWindow) : Vcl::Forms::TScrollBox(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwrcdpnl */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWRCDPNL)
using namespace Vcl::Wwrcdpnl;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwrcdpnlHPP
