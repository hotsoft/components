// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwdbdlg.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwdbdlgHPP
#define Vcl_WwdbdlgHPP

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
#include <Vcl.Buttons.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <vcl.wwdblook.hpp>
#include <vcl.wwIDlg.hpp>
#include <Data.DB.hpp>
#include <vcl.wwdbgrid.hpp>
#include <Vcl.Menus.hpp>
#include <vcl.wwdbigrd.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.Wwcommon.hpp>
#include <vcl.wwframe.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <vcl.wwintl.hpp>
#include <vcl.Wwdbedit.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwdbdlg
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwDBLookupComboDlg;
//-- type declarations -------------------------------------------------------
class PASCALIMPLEMENTATION TwwDBLookupComboDlg : public Vcl::Wwdblook::TwwDBCustomLookupCombo
{
	typedef Vcl::Wwdblook::TwwDBCustomLookupCombo inherited;
	
private:
	Vcl::Wwdbigrd::TwwDBGridOptions FGridOptions;
	System::Uitypes::TColor FGridColor;
	System::Classes::TAlignment FGridTitleAlignment;
	Vcl::Wwidlg::TwwDBLookupDlgOptions FOptions;
	System::UnicodeString FCaption;
	int FMaxWidth;
	int FMaxHeight;
	Vcl::Wwidlg::TwwUserButtonEvent FUserButton1Click;
	Vcl::Wwidlg::TwwUserButtonEvent FUserButton2Click;
	System::UnicodeString FUserButton1Caption;
	System::UnicodeString FUserButton2Caption;
	Vcl::Wwidlg::TwwOnInitDialogEvent FOnInitDialog;
	Vcl::Wwidlg::TwwOnInitDialogEvent FOnCloseDialog;
	System::Classes::TNotifyEvent FOnSortChange;
	bool FPictureMaskFromField;
	System::Classes::TStrings* FControlType;
	bool FControlInfoInDataset;
	System::Classes::TStrings* FPictureMasks;
	bool FPictureMaskFromDataSet;
	void __fastcall SetPictureMasks(System::Classes::TStrings* val);
	HIDESBASE void __fastcall SetControlType(System::Classes::TStrings* val);
	HIDESBASE void __fastcall SetOptions(Vcl::Wwidlg::TwwDBLookupDlgOptions sel);
	void __fastcall SetGridOptions(Vcl::Wwdbigrd::TwwDBGridOptions sel);
	
protected:
	virtual bool __fastcall IsLookupDlg(void);
	
public:
	__fastcall virtual TwwDBLookupComboDlg(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDBLookupComboDlg(void);
	DYNAMIC void __fastcall DropDown(void);
	
__published:
	__property Controller;
	__property DisableThemes = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property Constraints;
	__property ParentBiDiMode = {default=1};
	__property bool PictureMaskFromField = {read=FPictureMaskFromField, write=FPictureMaskFromField, default=0};
	__property System::Classes::TStrings* ControlType = {read=FControlType, write=SetControlType};
	__property bool ControlInfoInDataset = {read=FControlInfoInDataset, write=FControlInfoInDataset, default=1};
	__property bool PictureMaskFromDataset = {read=FPictureMaskFromDataSet, write=FPictureMaskFromDataSet, default=1};
	__property System::Classes::TStrings* PictureMasks = {read=FPictureMasks, write=SetPictureMasks};
	__property Vcl::Wwidlg::TwwDBLookupDlgOptions Options = {read=FOptions, write=SetOptions, default=3};
	__property Vcl::Wwdbigrd::TwwDBGridOptions GridOptions = {read=FGridOptions, write=SetGridOptions, default=17661};
	__property System::Uitypes::TColor GridColor = {read=FGridColor, write=FGridColor, nodefault};
	__property System::Classes::TAlignment GridTitleAlignment = {read=FGridTitleAlignment, write=FGridTitleAlignment, nodefault};
	__property System::UnicodeString Caption = {read=FCaption, write=FCaption};
	__property int MaxWidth = {read=FMaxWidth, write=FMaxWidth, nodefault};
	__property int MaxHeight = {read=FMaxHeight, write=FMaxHeight, nodefault};
	__property System::UnicodeString UserButton1Caption = {read=FUserButton1Caption, write=FUserButton1Caption};
	__property System::UnicodeString UserButton2Caption = {read=FUserButton2Caption, write=FUserButton2Caption};
	__property Vcl::Wwidlg::TwwUserButtonEvent OnUserButton1Click = {read=FUserButton1Click, write=FUserButton1Click};
	__property Vcl::Wwidlg::TwwUserButtonEvent OnUserButton2Click = {read=FUserButton2Click, write=FUserButton2Click};
	__property Vcl::Wwidlg::TwwOnInitDialogEvent OnInitDialog = {read=FOnInitDialog, write=FOnInitDialog};
	__property Vcl::Wwidlg::TwwOnInitDialogEvent OnCloseDialog = {read=FOnCloseDialog, write=FOnCloseDialog};
	__property System::Classes::TNotifyEvent OnSortChange = {read=FOnSortChange, write=FOnSortChange};
	__property Picture;
	__property SearchDelay = {default=0};
	__property Selected;
	__property DataField = {default=0};
	__property DataSource;
	__property LookupTable;
	__property LookupField = {default=0};
	__property SeqSearchOptions = {default=1};
	__property Style = {default=0};
	__property AutoSelect = {default=1};
	__property Color = {default=-16777211};
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property ButtonStyle = {default=0};
	__property ButtonEffects;
	__property ButtonWidth = {default=0};
	__property ButtonGlyph;
	__property Frame;
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property MaxLength = {default=0};
	__property ParentColor = {default=0};
	__property ParentCtl3D = {default=1};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property AutoDropDown;
	__property ShowButton;
	__property OrderByDisplay = {default=1};
	__property AllowClearKey;
	__property UseTFields = {default=1};
	__property ShowMatchText = {default=0};
	__property Touch;
	__property OnChange;
	__property OnClick;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnDropDown;
	__property OnCloseUp;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnPerformCustomSearch;
	__property OnGesture;
	__property Align = {default=0};
	__property StyleElements = {default=7};
	__property OEMConvert = {default=0};
	__property NumbersOnly = {default=0};
	__property DoubleBuffered;
	__property ParentDoubleBuffered = {default=1};
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBLookupComboDlg(HWND ParentWindow) : Vcl::Wwdblook::TwwDBCustomLookupCombo(ParentWindow) { }
	
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwdbdlg */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWDBDLG)
using namespace Vcl::Wwdbdlg;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwdbdlgHPP
