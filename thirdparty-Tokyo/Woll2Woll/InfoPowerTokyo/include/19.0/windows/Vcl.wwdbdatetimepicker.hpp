// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwdbdatetimepicker.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwdbdatetimepickerHPP
#define Vcl_WwdbdatetimepickerHPP

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
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Mask.hpp>
#include <vcl.wwmonthcalendar.hpp>
#include <Winapi.CommCtrl.hpp>
#include <Vcl.ComCtrls.hpp>
#include <Data.DB.hpp>
#include <Vcl.DBCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <vcl.wwintl.hpp>
#include <vcl.Wwsystem.hpp>
#include <vcl.Wwcommon.hpp>
#include <Vcl.Grids.hpp>
#include <vcl.wwtypes.hpp>
#include <vcl.wwframe.hpp>
#include <vcl.wwcombobutton.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Themes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwdbdatetimepicker
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwDTInterval;
class DELPHICLASS TwwPopupCalendar;
class DELPHICLASS TwwCalendarOptions;
class DELPHICLASS TwwDBCustomDateTimePicker;
class DELPHICLASS TwwDBDateTimePicker;
class DELPHICLASS TwwDateComboButton;
class DELPHICLASS TwwDateTimeEditStyleHook;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwDTCalAlignment : unsigned char { wwdtaLeft, wwdtaRight, wwdtaCenter };

enum DECLSPEC_DENUM TwwDTEditDataType : unsigned char { wwDTEdtDateTime, wwDTEdtDate, wwDTEdtTime };

enum DECLSPEC_DENUM TwwDTOption : unsigned char { wwDTOAutoAdvance };

typedef System::Set<TwwDTOption, TwwDTOption::wwDTOAutoAdvance, TwwDTOption::wwDTOAutoAdvance> TwwDTOptions;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwDTInterval : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FMinutesInterval;
	bool FRoundMinutes;
	
public:
	__fastcall TwwDTInterval(void);
	
__published:
	__property int MinutesInterval = {read=FMinutesInterval, write=FMinutesInterval, default=1};
	__property bool RoundMinutes = {read=FRoundMinutes, write=FRoundMinutes, default=0};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwDTInterval(void) { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwPopupCalendar : public Vcl::Wwmonthcalendar::TwwMonthCalendar
{
	typedef Vcl::Wwmonthcalendar::TwwMonthCalendar inherited;
	
private:
	TwwDBDateTimePicker* FCombo;
	
protected:
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	DYNAMIC void __fastcall Change(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall GetFocus(void);
	
public:
	__fastcall virtual TwwPopupCalendar(System::Classes::TComponent* AOwner);
public:
	/* TwwMonthCalendar.Destroy */ inline __fastcall virtual ~TwwPopupCalendar(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwPopupCalendar(HWND ParentWindow) : Vcl::Wwmonthcalendar::TwwMonthCalendar(ParentWindow) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwCalendarOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	TwwDTCalAlignment FAlignment;
	Vcl::Wwmonthcalendar::TwwDateTimeColors* FColors;
	Vcl::Graphics::TFont* FFont;
	int FWidth;
	int FHeight;
	Vcl::Wwmonthcalendar::TwwMonthOptions FOptions;
	Vcl::Wwmonthcalendar::TwwPopupYearOptions* FPopupYearOptions;
	Vcl::Wwmonthcalendar::TwwCalDayOfWeek FFirstDayOfWeek;
	void __fastcall SetPopupYearOptions(Vcl::Wwmonthcalendar::TwwPopupYearOptions* Value);
	int __fastcall GetHeight(void);
	void __fastcall SetHeight(int Value);
	int __fastcall GetWidth(void);
	void __fastcall SetWidth(int Value);
	Vcl::Graphics::TFont* __fastcall GetFont(void);
	void __fastcall SetFont(Vcl::Graphics::TFont* Value);
	void __fastcall SetAlignment(TwwDTCalAlignment Value);
	void __fastcall SetColors(Vcl::Wwmonthcalendar::TwwDateTimeColors* Value);
	void __fastcall SetFirstDayOfWeek(Vcl::Wwmonthcalendar::TwwCalDayOfWeek Value);
	
protected:
	void __fastcall SetOptions(Vcl::Wwmonthcalendar::TwwMonthOptions Value);
	
public:
	__fastcall TwwCalendarOptions(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwCalendarOptions(void);
	__property int Width = {read=GetWidth, write=SetWidth, nodefault};
	__property int Height = {read=GetHeight, write=SetHeight, nodefault};
	
__published:
	__property TwwDTCalAlignment Alignment = {read=FAlignment, write=SetAlignment, default=0};
	__property Vcl::Wwmonthcalendar::TwwDateTimeColors* Colors = {read=FColors, write=SetColors};
	__property Vcl::Graphics::TFont* Font = {read=GetFont, write=SetFont};
	__property Vcl::Wwmonthcalendar::TwwMonthOptions Options = {read=FOptions, write=SetOptions, default=1};
	__property Vcl::Wwmonthcalendar::TwwPopupYearOptions* PopupYearOptions = {read=FPopupYearOptions, write=SetPopupYearOptions};
	__property Vcl::Wwmonthcalendar::TwwCalDayOfWeek FirstDayOfWeek = {read=FFirstDayOfWeek, write=SetFirstDayOfWeek, default=7};
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwDBCustomDateTimePicker : public Vcl::Stdctrls::TCustomEdit
{
	typedef Vcl::Stdctrls::TCustomEdit inherited;
	
private:
	System::Classes::TAlignment FAlignment;
	TwwPopupCalendar* FCalendar;
	TwwCalendarOptions* FCalendarOptions;
	Vcl::Wwmonthcalendar::TCalcBoldDayEvent FOnCalcBoldDay;
	Vcl::Comctrls::TDTDateFormat FDateFormat;
	System::TDate FMaxDate;
	System::TDate FMinDate;
	bool FInCloseUp;
	System::Classes::TNotifyEvent FOnCloseUp;
	System::Classes::TNotifyEvent FOnDropDown;
	System::Classes::TNotifyEvent FOnMouseEnter;
	System::Classes::TNotifyEvent FOnMouseLeave;
	System::TDateTime FOldDateTime;
	System::TDateTime FDateTime;
	Vcl::Dbctrls::TFieldDataLink* FDataLink;
	Vcl::Wwcombobutton::TwwComboButton* FButton;
	Vcl::Controls::TWinControl* FBtnControl;
	Vcl::Controls::TControlCanvas* FCanvas;
	bool FFocused;
	int FPos;
	TwwDTEditDataType FUnboundDataType;
	System::UnicodeString FDisplayFormat;
	bool FInDigitEdit;
	bool FIsCleared;
	int FTextMargin;
	bool FInfoPower;
	int FEpoch;
	TwwDTOptions FOptions;
	bool FMouseInControl;
	bool SkipDrawSetFocus;
	System::TDateTime DateTimeBeforeDropDown;
	bool SkipEscapeReset;
	bool FShowButton;
	Vcl::Wwframe::TwwEditFrame* FFrame;
	Vcl::Wwframe::TwwButtonEffects* FButtonEffects;
	TwwDTInterval* FInterval;
	Vcl::Wwframe::TwwComboButtonStyle FButtonStyle;
	int FButtonWidth;
	bool FAutoFillDateAndTime;
	bool skipUpdate;
	bool FMouseInButtonControl;
	bool OldShowHint;
	bool SetModifiedInChangeEvent;
	System::TDateTime CurrentDigitEditDateTime;
	Vcl::Wwintl::TwwController* FController;
	bool FDisableThemes;
	
private:
	// __classmethod void __fastcall Create@();
	
private:
	void __fastcall SetController(Vcl::Wwintl::TwwController* Value);
	System::TDate __fastcall GetDate(void);
	System::TTime __fastcall GetTime(void);
	void __fastcall SetDate(System::TDate Value);
	void __fastcall SetTime(System::TTime Value);
	void __fastcall SetDateTime(System::TDateTime Value);
	Data::Db::TField* __fastcall GetField(void);
	System::UnicodeString __fastcall GetDataField(void);
	void __fastcall SetDataField(const System::UnicodeString Value);
	Data::Db::TDataSource* __fastcall GetDataSource(void);
	void __fastcall SetDataSource(Data::Db::TDataSource* Value);
	void __fastcall SetUnboundDataType(const TwwDTEditDataType Value);
	void __fastcall SetMaxDate(System::TDate Value);
	void __fastcall SetMinDate(System::TDate Value);
	void __fastcall SetDateFormat(Vcl::Comctrls::TDTDateFormat Value);
	void __fastcall SetEpoch(int Value);
	void __fastcall UpdateButtonPosition(void);
	MESSAGE void __fastcall CMCancelMode(Vcl::Controls::TCMCancelMode &Message);
	HIDESBASE MESSAGE void __fastcall CMEnter(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMExit(Winapi::Messages::TWMNoParams &Message);
	HIDESBASE MESSAGE void __fastcall CMFontChanged(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall CMGetDataLink(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CNKeyDown(Winapi::Messages::TWMKey &Message);
	MESSAGE void __fastcall WMCut(Winapi::Messages::TMessage &Message);
	MESSAGE void __fastcall WMPaste(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMKillFocus(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDblClk(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonDown(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMLButtonUp(Winapi::Messages::TWMMouse &Message);
	HIDESBASE MESSAGE void __fastcall WMPaint(Winapi::Messages::TWMPaint &Message);
	HIDESBASE MESSAGE void __fastcall CMEnabledChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TWMEraseBkgnd &Message);
	HIDESBASE MESSAGE void __fastcall CMTextChanged(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseEnter(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall CMMouseLeave(Winapi::Messages::TMessage &Message);
	HIDESBASE MESSAGE void __fastcall WMSetFont(Winapi::Messages::TWMSetFont &Message);
	void __fastcall SetFocused(bool Value);
	System::UnicodeString __fastcall GetDatetimeToken(System::TDateTime datetime1, int index, int &pos, int &len, System::UnicodeString &s);
	void __fastcall GetCompleteToken(System::WideChar val, System::UnicodeString formatstr, System::UnicodeString &s, int &pos);
	System::UnicodeString __fastcall GetFormatStr(void);
	bool __fastcall isDateField(void);
	bool __fastcall IsDateOnlyField(void);
	bool __fastcall isTimeOnlyField(void);
	bool __fastcall isDateTimeField(void);
	bool __fastcall isAMPM(System::UnicodeString str);
	void __fastcall InDigitEditUpdateRecord(void);
	bool __fastcall IscFormat(void);
	bool __fastcall TimeShowing(void);
	int __fastcall GetMaxVisibleToken(void);
	bool __fastcall isvalid2year(int newnum);
	void __fastcall ReEncodeDateTime(System::Word y, System::Word m, System::Word d, System::Word h, System::Word n, System::Word sec, System::Word msec);
	System::TDate __fastcall GetValidMaxDate(void);
	System::TDate __fastcall GetValidMinDate(void);
	HIDESBASE bool __fastcall GetReadOnly(void);
	HIDESBASE void __fastcall SetReadOnly(bool Value);
	void __fastcall SetDisplayFormat(System::UnicodeString value);
	void __fastcall SetButtonGlyph(Vcl::Graphics::TBitmap* Value);
	Vcl::Graphics::TBitmap* __fastcall GetButtonGlyph(void);
	void __fastcall SetButtonStyle(Vcl::Wwframe::TwwComboButtonStyle val);
	void __fastcall SetButtonWidth(int val);
	int __fastcall GetButtonWidth(void);
	int __fastcall GetNewHour(int oldhour, int digit);
	virtual bool __fastcall IsVistaComboNonEditable(void);
	
protected:
	__property Vcl::Controls::TControlCanvas* ControlCanvas = {read=FCanvas};
	virtual void __fastcall SetParent(Vcl::Controls::TWinControl* AParent);
	virtual void __fastcall DataChange(System::TObject* Sender);
	virtual void __fastcall UpdateData(System::TObject* Sender);
	virtual bool __fastcall IsCustom(void);
	virtual void __fastcall DrawButton(Vcl::Graphics::TCanvas* Canvas, const System::Types::TRect &R, Vcl::Buttons::TButtonState State, Vcl::Controls::TControlState ControlState, bool &DefaultPaint);
	virtual void __fastcall Loaded(void);
	virtual void __fastcall CloseUp(bool Accept);
	virtual bool __fastcall IsDroppedDown(void);
	DYNAMIC void __fastcall KeyDown(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyUp(System::Word &Key, System::Classes::TShiftState Shift);
	DYNAMIC void __fastcall KeyPress(System::WideChar &Key);
	DYNAMIC void __fastcall Change(void);
	DYNAMIC void __fastcall EnableEdit(void);
	void __fastcall HandleDropDownKeys(System::Word &Key, System::Classes::TShiftState Shift);
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
	void __fastcall BtnClick(System::TObject* sender);
	void __fastcall BtnMouseDown(System::TObject* Sender, System::Uitypes::TMouseButton Button, System::Classes::TShiftState Shift, int X, int Y);
	virtual bool __fastcall EditCanModify(void);
	HIDESBASE void __fastcall SetModified(bool val);
	virtual void __fastcall SetShowButton(bool sel);
	virtual System::Types::TRect __fastcall GetClientEditRect(void);
	virtual void __fastcall SetEditRect(void);
	HIDESBASE MESSAGE void __fastcall WMSize(Winapi::Messages::TWMSize &msg);
	HIDESBASE MESSAGE void __fastcall WMSetFocus(Winapi::Messages::TWMSetFocus &Message);
	virtual bool __fastcall Editable(void);
	void __fastcall ShowText(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect, int indentLeft, int indentTop, System::UnicodeString AText);
	DYNAMIC int __fastcall GetIconIndent(void);
	DYNAMIC int __fastcall GetIconLeft(void);
	void __fastcall HighlightToken(System::TDateTime mDateTime);
	virtual void __fastcall CreateParams(Vcl::Controls::TCreateParams &Params);
	DYNAMIC void __fastcall DoExit(void);
	void __fastcall Reset(void);
	bool __fastcall CanEdit(void);
	System::UnicodeString __fastcall GetEffectiveDisplayFormat(bool ExpandNativeFormat);
	void __fastcall GetFirstLastDayOfWeek(int &first, int &last);
	int __fastcall GetMaxTokens(System::UnicodeString formatstr);
	System::UnicodeString __fastcall GetDateTimeStoredText(System::TDateTime ADateTime);
	System::UnicodeString __fastcall GetDateTimeDisplayText(System::TDateTime ADateTime);
	bool __fastcall DateTokenInString(System::UnicodeString formatStr);
	bool __fastcall TimeTokenInString(System::UnicodeString formatStr);
	void __fastcall UpdateButtonGlyph(void);
	virtual void __fastcall DrawFrame(Vcl::Graphics::TCanvas* Canvas);
	bool __fastcall Is3DBorder(void);
	virtual void __fastcall CreateWnd(void);
	virtual void __fastcall WndProc(Winapi::Messages::TMessage &Message);
	void __fastcall InvalidateTransparentButton(void);
	virtual void __fastcall DoMouseEnter(void);
	virtual void __fastcall DoMouseLeave(void);
	__property bool MouseInControl = {read=FMouseInControl, nodefault};
	
public:
	System::Variant Patch;
	__fastcall virtual TwwDBCustomDateTimePicker(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwDBCustomDateTimePicker(void);
	DYNAMIC bool __fastcall ExecuteAction(System::Classes::TBasicAction* Action);
	virtual bool __fastcall UpdateAction(System::Classes::TBasicAction* Action);
	virtual void __fastcall Invalidate(void);
	virtual void __fastcall DropDown(void);
	void __fastcall UpdateRecord(void);
	void __fastcall RefreshText(void);
	void __fastcall ClearDateTime(void);
	bool __fastcall isTransparentEffective(void);
	__property Vcl::Wwintl::TwwController* Controller = {read=FController, write=SetController};
	__property TwwPopupCalendar* Calendar = {read=FCalendar};
	__property bool DroppedDown = {read=IsDroppedDown, nodefault};
	__property Data::Db::TField* Field = {read=GetField};
	__property Vcl::Wwframe::TwwEditFrame* Frame = {read=FFrame, write=FFrame};
	__property bool ShowButton = {read=FShowButton, write=SetShowButton, nodefault};
	__property Vcl::Wwcombobutton::TwwComboButton* Button = {read=FButton};
	__property System::TDateTime DateTime = {read=FDateTime, write=SetDateTime};
	__property TwwDTOptions Options = {read=FOptions, write=FOptions, default=1};
	__property TwwDTInterval* Interval = {read=FInterval, write=FInterval};
	__property bool AutoFillDateAndTime = {read=FAutoFillDateAndTime, write=FAutoFillDateAndTime, default=0};
	__property TwwCalendarOptions* CalendarAttributes = {read=FCalendarOptions, write=FCalendarOptions};
	__property System::UnicodeString DataField = {read=GetDataField, write=SetDataField};
	__property Vcl::Comctrls::TDTDateFormat DateFormat = {read=FDateFormat, write=SetDateFormat, default=0};
	__property Data::Db::TDataSource* DataSource = {read=GetDataSource, write=SetDataSource};
	__property System::TDate Date = {read=GetDate, write=SetDate};
	__property int Epoch = {read=FEpoch, write=SetEpoch, nodefault};
	__property System::TTime Time = {read=GetTime, write=SetTime};
	__property System::TDate MaxDate = {read=FMaxDate, write=SetMaxDate};
	__property System::TDate MinDate = {read=FMinDate, write=SetMinDate};
	__property TwwDTEditDataType UnboundDataType = {read=FUnboundDataType, write=SetUnboundDataType, default=0};
	__property System::UnicodeString DisplayFormat = {read=FDisplayFormat, write=SetDisplayFormat};
	__property Vcl::Wwmonthcalendar::TCalcBoldDayEvent OnCalcBoldDay = {read=FOnCalcBoldDay, write=FOnCalcBoldDay};
	__property System::Classes::TNotifyEvent OnCloseUp = {read=FOnCloseUp, write=FOnCloseUp};
	__property System::Classes::TNotifyEvent OnDropDown = {read=FOnDropDown, write=FOnDropDown};
	__property System::Classes::TNotifyEvent OnMouseEnter = {read=FOnMouseEnter, write=FOnMouseEnter};
	__property System::Classes::TNotifyEvent OnMouseLeave = {read=FOnMouseLeave, write=FOnMouseLeave};
	__property bool ReadOnly = {read=GetReadOnly, write=SetReadOnly, default=0};
	__property bool InfoPower = {read=FInfoPower, nodefault};
	__property Vcl::Wwframe::TwwComboButtonStyle ButtonStyle = {read=FButtonStyle, write=SetButtonStyle, nodefault};
	__property Vcl::Wwframe::TwwButtonEffects* ButtonEffects = {read=FButtonEffects, write=FButtonEffects};
	__property Vcl::Graphics::TBitmap* ButtonGlyph = {read=GetButtonGlyph, write=SetButtonGlyph, stored=IsCustom};
	__property int ButtonWidth = {read=GetButtonWidth, write=SetButtonWidth, default=0};
	__property AutoSize = {default=1};
	__property BorderStyle = {default=1};
	__property Color = {default=-16777211};
	__property Enabled = {default=1};
	__property Font;
	__property ParentColor = {default=0};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ShowHint;
	__property TabOrder = {default=-1};
	__property Visible = {default=1};
	__property int TokenPos = {read=FPos, write=FPos, nodefault};
	__property bool DisableThemes = {read=FDisableThemes, write=FDisableThemes, default=0};
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBCustomDateTimePicker(HWND ParentWindow) : Vcl::Stdctrls::TCustomEdit(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwDBDateTimePicker : public TwwDBCustomDateTimePicker
{
	typedef TwwDBCustomDateTimePicker inherited;
	
private:
	// __classmethod void __fastcall Create@();
	
__published:
	__property Controller;
	__property DisableThemes = {default=0};
	__property Anchors = {default=3};
	__property BiDiMode;
	__property BevelEdges = {default=15};
	__property BevelInner = {index=0, default=2};
	__property BevelKind = {default=0};
	__property BevelOuter = {index=1, default=1};
	__property AutoFillDateAndTime = {default=0};
	__property AutoSize = {default=1};
	__property BorderStyle = {default=1};
	__property CalendarAttributes;
	__property Color = {default=-16777211};
	__property Constraints;
	__property ButtonStyle = {default=1};
	__property DataField = {default=0};
	__property DateFormat = {default=0};
	__property DataSource;
	__property Date = {default=0};
	__property Epoch;
	__property ButtonEffects;
	__property Frame;
	__property ButtonWidth = {default=0};
	__property ButtonGlyph;
	__property Time = {default=0};
	__property DragMode = {default=0};
	__property DragCursor = {default=-12};
	__property Enabled = {default=1};
	__property Font;
	__property ImeMode = {default=3};
	__property ImeName = {default=0};
	__property MaxDate = {default=0};
	__property MinDate = {default=0};
	__property Interval;
	__property ParentBiDiMode = {default=1};
	__property ParentColor = {default=0};
	__property ParentFont = {default=1};
	__property ParentShowHint = {default=1};
	__property PopupMenu;
	__property ReadOnly = {default=0};
	__property ShowHint;
	__property ShowButton;
	__property TabOrder = {default=-1};
	__property Touch;
	__property UnboundDataType = {default=0};
	__property DisplayFormat = {default=0};
	__property Visible = {default=1};
	__property OnCalcBoldDay;
	__property OnClick;
	__property OnCloseUp;
	__property OnChange;
	__property OnDropDown;
	__property OnDblClick;
	__property OnDragDrop;
	__property OnDragOver;
	__property OnEndDrag;
	__property OnEnter;
	__property OnExit;
	__property OnKeyDown;
	__property OnKeyPress;
	__property OnKeyUp;
	__property OnMouseEnter;
	__property OnMouseLeave;
	__property OnStartDrag;
	__property OnGesture;
	__property InfoPower;
	__property Align = {default=0};
	__property StyleElements = {default=7};
	__property OEMConvert = {default=0};
	__property NumbersOnly = {default=0};
	__property DoubleBuffered;
	__property ParentDoubleBuffered = {default=1};
	
private:
	// __classmethod void __fastcall Destroy@();
public:
	/* TwwDBCustomDateTimePicker.Create */ inline __fastcall virtual TwwDBDateTimePicker(System::Classes::TComponent* AOwner) : TwwDBCustomDateTimePicker(AOwner) { }
	/* TwwDBCustomDateTimePicker.Destroy */ inline __fastcall virtual ~TwwDBDateTimePicker(void) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwDBDateTimePicker(HWND ParentWindow) : TwwDBCustomDateTimePicker(ParentWindow) { }
	
};


class PASCALIMPLEMENTATION TwwDateComboButton : public Vcl::Wwcombobutton::TwwComboButton
{
	typedef Vcl::Wwcombobutton::TwwComboButton inherited;
	
protected:
	virtual bool __fastcall IsVistaTransparentButton(void);
	virtual bool __fastcall IsVistaComboNonEditable(void);
	virtual bool __fastcall ParentMouseInControl(void);
	virtual bool __fastcall ParentDroppedDown(void);
	virtual void __fastcall Paint(void);
public:
	/* TwwComboButton.Create */ inline __fastcall virtual TwwDateComboButton(System::Classes::TComponent* AOwner) : Vcl::Wwcombobutton::TwwComboButton(AOwner) { }
	/* TwwComboButton.Destroy */ inline __fastcall virtual ~TwwDateComboButton(void) { }
	
};


#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwDateTimeEditStyleHook : public Vcl::Stdctrls::TEditStyleHook
{
	typedef Vcl::Stdctrls::TEditStyleHook inherited;
	
private:
	HIDESBASE MESSAGE void __fastcall WMEraseBkgnd(Winapi::Messages::TMessage &Message);
	
private:
	Vcl::Controls::TWinControl* Control;
	
protected:
	virtual void __fastcall PaintNC(Vcl::Graphics::TCanvas* Canvas);
	
public:
	__fastcall virtual TwwDateTimeEditStyleHook(Vcl::Controls::TWinControl* AControl);
public:
	/* TMouseTrackControlStyleHook.Destroy */ inline __fastcall virtual ~TwwDateTimeEditStyleHook(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwdbdatetimepicker */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWDBDATETIMEPICKER)
using namespace Vcl::Wwdbdatetimepicker;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwdbdatetimepickerHPP
