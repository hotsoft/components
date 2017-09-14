// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwrtfconverter.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwrtfconverterHPP
#define Vcl_WwrtfconverterHPP

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
#include <System.Win.Registry.hpp>
#include <Vcl.Dialogs.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Buttons.hpp>
#include <Vcl.ComCtrls.hpp>
#include <vcl.wwriched.hpp>
#include <Winapi.ActiveX.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwrtfconverter
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwRTFConverter;
class DELPHICLASS TwwRtfConverterList;
//-- type declarations -------------------------------------------------------
typedef short TwwFileCodeError;

typedef System::AnsiString TwwAnsiString;

typedef int __stdcall (*TwwConvertCallbackOut)(int cchBuff, int nPercent);

typedef int __stdcall (*TwwConvertCallbackIn)(int rgfOptions, int p2);

typedef HRESULT __stdcall (*TwwInitConverter32)(NativeUInt hwnd, System::WideChar * szModule);

typedef void __stdcall (*TwwUninitConverter)(void);

typedef short __stdcall (*TwwIsFormatCorrect32)(NativeUInt ghszFile, NativeUInt ghszClass);

typedef short __stdcall (*TwwForeignToRtf32)(NativeUInt hFile, _di_IStorage pStorage, NativeUInt hBuffer, NativeUInt hClass, NativeUInt hSubset, TwwConvertCallbackOut OutFunction);

typedef short __stdcall (*TwwRtfToForeign32)(NativeUInt hFile, _di_IStorage pStorage, NativeUInt hBuffer, NativeUInt hClass, TwwConvertCallbackIn InFunction);

typedef void * __stdcall (*TwwRegisterApp)(unsigned lFlags, void * lpFuture);

typedef int __stdcall (*TwwCchFetchLpszError)(int fce, System::WideChar * lpszError, int cb);

typedef void __stdcall (*TwwGetReadNames)(NativeUInt haszClass, NativeUInt haszDescrip, NativeUInt haszExt);

typedef void __stdcall (*TwwGetWriteNames)(NativeUInt haszClass, NativeUInt haszDescrip, NativeUInt haszExt);

typedef int __stdcall (*TwwRegisterConverter)(NativeUInt hkeyRoot);

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwRTFConverter : public System::TObject
{
	typedef System::TObject inherited;
	
protected:
	NativeUInt FLibrary;
	TwwInitConverter32 InitConverter32;
	TwwUninitConverter UninitConverter;
	TwwIsFormatCorrect32 IsFormatCorrect32;
	TwwForeignToRtf32 ForeignToRtf32;
	TwwRtfToForeign32 RtfToForeign32;
	TwwRegisterApp RegisterApp;
	TwwCchFetchLpszError CchFetchLpszError;
	TwwGetReadNames GetReadNames;
	TwwGetWriteNames GetWriteNames;
	TwwRegisterConverter RegisterConverter;
	void __fastcall LoadLibrary(HWND hwnd, System::UnicodeString libpath);
	void __fastcall UnloadLibrary(void);
	
public:
	__fastcall TwwRTFConverter(HWND hwnd, System::UnicodeString libpath);
	__fastcall virtual ~TwwRTFConverter(void);
	bool __fastcall IsKnownFormat(System::UnicodeString FilePath);
	short __fastcall ForeignToRTF(Vcl::Wwriched::TwwCustomRichEdit* richedit, System::UnicodeString FilePath, System::UnicodeString formatClass = System::UnicodeString());
	short __fastcall RTFToForeign(Vcl::Wwriched::TwwCustomRichEdit* richedit, System::UnicodeString FilePath, System::UnicodeString formatClass = System::UnicodeString());
	System::UnicodeString __fastcall GetErrorMessage(short ErrorCode);
};

#pragma pack(pop)

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwRtfConverterList : public System::TObject
{
	typedef System::TObject inherited;
	
private:
	System::Classes::TStringList* RawDescription;
	
public:
	System::Classes::TStringList* libpath;
	System::Classes::TStringList* Description;
	System::Classes::TStringList* formatClass;
	System::Classes::TStringList* Filters;
	System::UnicodeString FilterList;
	__fastcall TwwRtfConverterList(bool import);
	__fastcall virtual ~TwwRtfConverterList(void);
	void __fastcall GetConverterList(HKEY regRoot, System::UnicodeString regPath, System::UnicodeString appName, bool import);
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
static const System::Int8 wwfceTrue = System::Int8(0x1);
static const System::Int8 wwfceNoErr = System::Int8(0x0);
static const System::Int8 wwfceOpenInFileErr = System::Int8(-1);
static const System::Int8 wwfceReadErr = System::Int8(-2);
static const System::Int8 wwfceWriteErr = System::Int8(-4);
static const System::Int8 wwfceInvalidFile = System::Int8(-5);
static const System::Int8 wwfceNoMemory = System::Int8(-8);
static const System::Int8 wwfceOpenOutFileErr = System::Int8(-12);
static const System::Int8 wwfceUserCancel = System::Int8(-13);
static const System::Int8 wwfceWrongFileType = System::Int8(-14);
}	/* namespace Wwrtfconverter */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWRTFCONVERTER)
using namespace Vcl::Wwrtfconverter;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwrtfconverterHPP
