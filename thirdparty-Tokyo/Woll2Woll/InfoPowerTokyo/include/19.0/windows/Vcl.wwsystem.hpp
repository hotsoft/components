// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwsystem.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwsystemHPP
#define Vcl_WwsystemHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.StdCtrls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwsystem
{
//-- forward type declarations -----------------------------------------------
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwDateOrder : unsigned char { doMDY, doDMY, doYMD };

enum DECLSPEC_DENUM TwwDateTimeSelection : unsigned char { wwdsDay, wwdsMonth, wwdsYear, wwdsHour, wwdsMinute, wwdsSecond, wwdsAMPM };

//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwDateOrder __fastcall wwGetDateOrder(const System::UnicodeString DateFormat);
extern DELPHI_PACKAGE int __fastcall wwNextDay(System::Word Year, System::Word Month, System::Word Day);
extern DELPHI_PACKAGE int __fastcall wwPriorDay(System::Word Year, System::Word Month, System::Word Day);
extern DELPHI_PACKAGE bool __fastcall wwDoEncodeDate(System::Word Year, System::Word Month, System::Word Day, System::TDateTime &Date);
extern DELPHI_PACKAGE bool __fastcall wwScanDate(const System::UnicodeString S, System::TDateTime &Date);
extern DELPHI_PACKAGE bool __fastcall wwScanDateEpoch(const System::UnicodeString S, System::TDateTime &Date, int Epoch);
extern DELPHI_PACKAGE bool __fastcall wwDoEncodeTime(System::Word Hour, System::Word Min, System::Word Sec, System::Word MSec, System::TDateTime &Time);
extern DELPHI_PACKAGE bool __fastcall wwStrToDate(const System::UnicodeString S);
extern DELPHI_PACKAGE bool __fastcall wwStrToTime(const System::UnicodeString S);
extern DELPHI_PACKAGE bool __fastcall wwStrToDateTime(const System::UnicodeString S);
extern DELPHI_PACKAGE System::TDateTime __fastcall wwStrToDateTimeVal(const System::UnicodeString S);
extern DELPHI_PACKAGE System::TDateTime __fastcall wwStrToDateVal(const System::UnicodeString S);
extern DELPHI_PACKAGE System::TDateTime __fastcall wwStrToTimeVal(const System::UnicodeString S);
extern DELPHI_PACKAGE bool __fastcall wwStrToInt(const System::UnicodeString S);
extern DELPHI_PACKAGE bool __fastcall wwStrToFloat(const System::UnicodeString S);
extern DELPHI_PACKAGE TwwDateTimeSelection __fastcall wwGetDateTimeCursorPosition(int SelStart, System::UnicodeString Text, bool TimeOnly);
extern DELPHI_PACKAGE TwwDateTimeSelection __fastcall wwGetTimeCursorPosition(int SelStart, System::UnicodeString Text);
extern DELPHI_PACKAGE void __fastcall wwSetDateTimeCursorSelection(TwwDateTimeSelection dateCursor, Vcl::Stdctrls::TCustomEdit* edit, bool TimeOnly);
extern DELPHI_PACKAGE bool __fastcall wwStrToFloat2(const System::UnicodeString S, System::Extended &FloatValue, System::UnicodeString DisplayFormat);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwLongMonthNames(int month);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwShortMonthNames(int month);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwLongDayNames(int day);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwShortDayNames(int day);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwShortDateFormat(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwLongDateFormat(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwLongTimeFormat(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwShortTimeFormat(void);
extern DELPHI_PACKAGE System::WideChar __fastcall wwDateSeparator(void);
extern DELPHI_PACKAGE System::WideChar __fastcall wwTimeSeparator(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwTimeAMString(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwTimePMString(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwCurrencyString(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwDecimalSeparator(void);
extern DELPHI_PACKAGE System::UnicodeString __fastcall wwThousandSeparator(void);
}	/* namespace Wwsystem */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWSYSTEM)
using namespace Vcl::Wwsystem;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwsystemHPP
