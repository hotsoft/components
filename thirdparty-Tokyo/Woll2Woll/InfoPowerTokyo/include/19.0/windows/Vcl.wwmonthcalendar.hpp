// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwmonthcalendar.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwmonthcalendarHPP
#define Vcl_WwmonthcalendarHPP

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
#include <Vcl.ComCtrls.hpp>
#include <Winapi.CommCtrl.hpp>
#include <Data.DB.hpp>
#include <Vcl.DBCtrls.hpp>
#include <Vcl.Menus.hpp>
#include <vcl.wwintl.hpp>
#include <Vcl.Themes.hpp>
#include <Vcl.StdCtrls.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwmonthcalendar
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwDateTimeColors;
class DELPHICLASS TwwPopupYearOptions;
class DELPHICLASS TwwMonthCalendar;
class DELPHICLASS TwwDBCustomMonthCalendar;
class DELPHICLASS TwwDBMonthCalendar;
class DELPHICLASS TwwMonthCalendarStyleHook;
struct WW_MCHITTESTINFO;
//-- type declarations -------------------------------------------------------
#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwDateTimeColors : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Classes::TComponent* Owner;
	System::Uitypes::TColor FBackColor;
	System::Uitypes::TColor FTextColor;
	System::Uitypes::TColor FTitleBackColor;
	System::Uitypes::TColor FTitleTextColor;
	System::Uitypes::TColor FMonthBackColor;
	System::Uitypes::TColor FTrailingTextColor;
	void __fastcall SetColor(int Index, System::Uitypes::TColor Value);
	void __fastcall SetAllColors(void);
	
public:
	__fastcall TwwDateTimeColors(System::Classes::TComponent* AOwner);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property System::Uitypes::TColor TextColor = {read=FTextColor, write=SetColor, index=1, default=-16777208};
	__property System::Uitypes::TColor TitleBackColor = {read=FTitleBackColor, write=SetColor, index=2, default=-16777214};
	__property System::Uitypes::TColor TitleTextColor = {read=FTitleTextColor, write=SetColor, index=3, default=16777215};
	__property System::Uitypes::TColor MonthBackColor = {read=FMonthBackColor, write=SetColor, index=4, default=16777215};
	__property System::Uitypes::TColor TrailingTextColor = {read=FTrailingTextColor, write=SetColor, index=5, default=-16777197};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwDateTimeColors(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwPopupYearOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FYearsPerColumn;
	int FNumberColumns;
	int FStartYear;
	bool FShowEditYear;
	int __fastcall GetStartYear(void);
	void __fastcall SetStartYear(int Value);
	void __fastcall SetNumberColumns(int Value);
	void __fastcall SetYearsPerColumn(int Value);
	void __fastcall SetShowEdityear(bool Value);
	
public:
	__fastcall TwwPopupYearOptions(System::Classes::TComponent* AOwner);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	
__published:
	__property int YearsPerColumn = {read=FYearsPerColumn, write=SetYearsPerColumn, default=10};
	__property int NumberColumns = {read=FNumberColumns, write=SetNumberColumns, default=2};
	__property int StartYear = {read=GetStartYear, write=SetStartYear, default=2000};
	__property bool ShowEditYear = {read=FShowEditYear, write=SetShowEdityear, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwPopupYearOptions(void) { }
	
};

#pragma pack(pop)

enum DECLSPEC_DENUM TwwMonthOption : unsigned char { mdoDayState, mdoWeekNumbers, mdoNoToday, mdoNoTodayCircle, mdoMultiSelect, mdoNoTrailingDates, mdoShortDaysOfWeek, mdoNoSelChangeOnNav };

typedef System::Set<TwwMonthOption, TwwMonthOption::mdoDayState, TwwMonthOption::mdoNoSelChangeOnNav> TwwMonthOptions;

typedef void __fastcall (__closure *TCalcBoldDayEvent)(System::TObject* Sender, System::TDate ADate, int Month, int Day, int Year, bool &Accept);

typedef void __fastcall (__closure *TmcMouseMoveEvent)(System::TObject* Sender, System::Classes::TShiftState Shift, int X, int Y, int Month, int Day, int Year);

typedef void __fastcall (__closure *TmcMouseUPDownEvent)(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y, int Month, int Day, int Year);

enum DECLSPEC_DENUM TwwCalDayOfWeek : unsigned char { wwdowMonday, wwdowTuesday, wwdowWednesday, wwdowThursday, wwdowFriday, wwdowSaturday, wwdowSunday, wwdowLocaleDefault };

class PASCALIMPLEMENTATION TwwMonthCalendar : public Vcl::Controls::TWinControl
{
	typedef Vcl::Controls::TWinControl inherited;
	
private:
	Vcl::Forms::TFormBorderStyle FBorder;
	TwwDateTimeColors* FCalColors;
	System::TDateTime FDateTime;
	System::TDateTime FStartDate;
	System::TDateTime FEndDate;
	System::TDate FMaxDate;
	System::TDate FMinDate;
	System::Classes::TNotifyEvent FOnChange;
	TCalcBoldDayEvent FOnCalcBoldDay;
	TwwMonthOptions FOptions;
	int FMaxSelectCount;
	bool FSelChanged;
	TmcMouseMoveEvent FOnMouseMove;
	TmcMouseUPDownEvent FOnMouseDown;
	TmcMouseUPDownEvent FOnMouseUp;
	Vcl::Menus::TPopupMenu* FYearPopupMenu;
	bool FYearPopupShowing;
	bool FMonthPopupShowing;
	bool FAfterYearPopup;
	bool FAfterMonthPopup;
	Vcl::Menus::TPopupMenu* FMonthPopupMenu;
	_SYSTEMTIME FPopupSystemTime;
	int FPrevPopupMonth;
	System::Classes::TList* FDummyList;
	TwwPopupYearOptions* FPopupYearOptions;
	TwwCalDayOfWeek FFirstDayOfWeek;
	void __fastcall AdjustHeight(void);
	
private:
	// __classmethod void __fastcall Create@();
	
private:
	System::TDate __fastcall GetDate(void);
	System::TTime __fastcall GetTime(void);
	System::TDate __fastcall GetEndDate(void);
	System::TDate __fastcall GetStartDate(void);
	int __fastcall GetHeight(void);
	int __fastcall GetWidth(void);
	void __fastcall SetCalColors(TwwDateTimeColors* Value);
	void __fastcall SetDate(System::TDate Value);
	void __fastcall SetEndDate(System::TDate Value);
	void __fastcall SetStartDate(System::TDate Value);
	void __fastcall SetDateTime(System::TDateTime Value);
	void __fastcall SetBorder(Vcl::Forms::TBorderStyle Value);
	HIDESBASE void __fastcall SetHeight(int Value);
	HIDESBASE void __fastcall SetWidth(int Value);
	void __fastcall SetMaxDate(System::TDate Value);
	void __fastcall SetMaxSelectCount(int Value);
	void __fastcall SetMinDate(System::TDate Value);
	void __fastcall SetRange(System::TDateTime MinVal, System::TDateTime MaxVal);
	void __fastcall SetTime(System::TTime Value);
	void __fastcall SetPopupYearOptions(TwwPopupYearOptions* Value);
	void __fastcall SetFirstDayOfWeek(TwwCalDayOfWeek Value);
	HIDESBASE MESSAGE void __fastcall CMColorChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CNNotify(Winapi::Messages::TWMNotify &Message);
	HIDESBASE MESSAGE void __fastcall CNKeyDown(Winapi::Messages::TWMKey &Message);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &Message);
	HIDESBASE MESSAGE void __fastcall CMShowingChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	
protected:
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall SetOptions(TwwMonthOptions val);
	DYNAMIC void __fastcall Change(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall GetFocus(void);
	DYNAMIC void __fastcall MouseDown(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseUp(System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	DYNAMIC void __fastcall MouseMove(System::Classes::TShiftState Shift, int X, int Y);
	bool __fastcall SetSelRange(System::TDate AStart, System::TDate AEnd);
	bool __fastcall SetMonthCalDateTime(System::TDateTime Value);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	void __fastcall wwPopupMenuClick(System::TObject* Sender);
	void __fastcall wwMonthPopupMenuClick(System::TObject* Sender);
	
public:
	System::Variant Patch;
	__fastcall virtual TwwMonthCalendar(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwMonthCalendar(void);
	bool __fastcall IsPopupYearMonthShowing(void);
	__property System::TDate EndDate = {read=GetEndDate, write=SetEndDate};
	__property System::TDate StartDate = {read=GetStartDate, write=SetStartDate};
	__property System::TDateTime DateTime = {read=FDateTime, write=SetDateTime};
	
__published:
	__property Vcl::Forms::TBorderStyle BorderStyle = {read=FBorder, write=SetBorder, default=0};
	__property TwwDateTimeColors* CalColors = {read=FCalColors, write=SetCalColors};
	__property System::TDate Date = {read=GetDate, write=SetDate};
	__property System::TTime Time = {read=GetTime, write=SetTime};
	__property Color = {stored=true, default=-16777211};
	__property TwwMonthOptions Options = {read=FOptions, write=SetOptions, default=1};
	__property TwwPopupYearOptions* PopupYearOptions = {read=FPopupYearOptions, write=SetPopupYearOptions};
	__property TwwCalDayOfWeek FirstDayOfWeek = {read=FFirstDayOfWeek, write=SetFirstDayOfWeek, default=7};
	__property int Height = {read=GetHeight, write=SetHeight, nodefault};
	__property int MaxSelectCount = {read=FMaxSelectCount, write=SetMaxSelectCount, default=31};
	__property System::TDate MaxDate = {read=FMaxDate, write=SetMaxDate};
	__property System::TDate MinDate = {read=FMinDate, write=SetMinDate};
	__property ParentColor = {default=0};
	__property TabStop = {default=1};
	__property int Width = {read=GetWidth, write=SetWidth, nodefault};
	__property TCalcBoldDayEvent OnCalcBoldDay = {read=FOnCalcBoldDay, write=FOnCalcBoldDay};
	__property System::Classes::TNotifyEvent OnChange = {read=FOnChange, write=FOnChange};
	__property TmcMouseUPDownEvent OnMouseDown = {read=FOnMouseDown, write=FOnMouseDown};
	__property TmcMouseMoveEvent OnMouseMove = {read=FOnMouseMove, write=FOnMouseMove};
	__property TmcMouseUPDownEvent OnMouseUp = {read=FOnMouseUp, write=FOnMouseUp};
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwMonthCalendar(HWND ParentWindow) : Vcl::Controls::TWinControl(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwDBCustomMonthCalendar : public TwwMonthCalendar
{
	typedef TwwMonthCalendar inherited;
	
private:
	Vcl::Dbctrls::TFieldDataLink* FDataLink;
	TwwMonthCalendar* FPaintControl;
	Data::Db::TField* __fastcall GetField(void);
	System::UnicodeString __fastcall GetDataField(void);
	void __fastcall SetDataField(const System::UnicodeString Value);
	bool __fastcall GetReadOnly(void);
	void __fastcall SetReadOnly(bool Value);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	void __fastcall DataChange(System::TObject* Sender);
	void __fastcall UpdateData(System::TObject* Sender);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	MESSAGE void __fastcall CMGetDataLink(Winapi::Messages::TMessage &Message);
	
protected:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall Change(void);
	
public:
	__fastcall virtual TwwDBCustomMonthCalendar(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDBCustomMonthCalendar(void);
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	__property Data::Db::TField* Field = {read=GetField};
	
__published:
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, default=0};
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBCustomMonthCalendar(HWND ParentWindow) : TwwMonthCalendar(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwDBMonthCalendar : public TwwDBCustomMonthCalendar
{
	typedef TwwDBCustomMonthCalendar inherited;
	
__published:
	__property Anchors = {default=3};
	__property Align = {default=0};
	__property BorderStyle = {default=0};
	__property CalColors;
	__property Constraints;
	__property Date = {default=0};
	__property Time = {default=0};
	__property Color = {default=-16777211};
	__property Options = {default=1};
	__property PopupYearOptions;
	__property DragCursor = {default=-12};
	__property DragMode = {default=0};
	__property Enabled = {default=1};
	__property FirstDayOfWeek = {default=7};
	__property Font;
	__property Height;
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property MaxSelectCount = {default=31};
	__property MaxDate = {default=0};
	__property MinDate = {default=0};
	__property ParentColor = {default=0};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property ShowHint;
	__property TabStop = {default=1};
	__property Visible = {default=1};
	__property Width;
	__property OnCalcBoldDay;
	__property OnClick;
	__property OnChange;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseDown;
	__property OnMouseMove;
	__property OnMouseUp;
	__property OnStartDrag;
	__property DataField = {default=0};
	__property DataSource;
	__property ReadOnly = {default=0};
public:
	/* TwwDBCustomMonthCalendar.Create */ inline __fastcall virtual TwwDBMonthCalendar(System::Classes::TComponent* AOwner) : TwwDBCustomMonthCalendar(AOwner) { }
	/* TwwDBCustomMonthCalendar.Destroy */ inline __fastcall virtual ~TwwDBMonthCalendar(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBMonthCalendar(HWND ParentWindow) : TwwDBCustomMonthCalendar(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwMonthCalendarStyleHook : public Vcl::Themes::TStyleHook
{
	typedef Vcl::Themes::TStyleHook inherited;
	
private:
	MESSAGE void __fastcall WMSize(Winapi::Messages::TMessage &Message);
	void __fastcall UpdateColors(void);
	
protected:
	virtual void __fastcall Paint(Vcl::Graphics::TCanvas* Canvas);
	virtual void __fastcall PaintNC(Vcl::Graphics::TCanvas* Canvas);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	
public:
	__fastcall virtual TwwMonthCalendarStyleHook(Vcl::Controls::TWinControl* AControl);
public:
	/* TStyleHook.Destroy */ inline __fastcall virtual ~TwwMonthCalendarStyleHook(void) { }
	
};

#pragma pack(pop)

#pragma pack(push,1)
struct DECLSPEC_DRECORD WW_MCHITTESTINFO
{
public:
	unsigned cbSize;
	System::Types::TPoint pt;
	unsigned uHit;
	_SYSTEMTIME st;
};
#pragma pack(pop)


typedef WW_MCHITTESTINFO TwwMCHitTestInfo;

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 MaxMonthForDayState = System::Int8(0xe);
extern DELPHI_PACKAGE unsigned __fastcall wwMonthCal_HitTest(HWND hmc, WW_MCHITTESTINFO &info);
}	/* namespace Wwmonthcalendar */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWMONTHCALENDAR)
using namespace Vcl::Wwmonthcalendar;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwmonthcalendarHPP
