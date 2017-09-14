// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwexport.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwexportHPP
#define Vcl_WwexportHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <System.Classes.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.Graphics.hpp>
#include <System.SysUtils.hpp>
#include <Vcl.Controls.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwexport
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwExportOptions;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwGridExportType : unsigned char { wwgetTxt, wwgetHTML, wwgetSYLK, wwgetXML };

enum DECLSPEC_DENUM TwwGridExportEnocodingType : unsigned char { wwetDefault, wwetASCII, wwetBigEndianUnicode, wwetUTF7, wwetUTF8, wwetUnicode };

enum DECLSPEC_DENUM TwwExportSaveOption : unsigned char { esoShowHeader, esoShowFooter, esoDynamicColors, esoShowTitle, esoDblQuoteFields, esoSaveSelectedOnly, esoAddControls, esoBestColFit, esoShowRecordNo, esoEmbedURL, esoShowAlternating, esoTransparentGrid, esoClipboard };

typedef System::Set<TwwExportSaveOption, TwwExportSaveOption::esoShowHeader, TwwExportSaveOption::esoClipboard> TwwExportSaveOptions;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwExportOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::UnicodeString FFileName;
	TwwGridExportType FExportType;
	System::UnicodeString FDelimiter;
	TwwExportSaveOptions FOptions;
	System::UnicodeString FTitleName;
	int FOutputWidthinTwips;
	int FHTMLBorderWidth;
	bool FUseOldClipboardSaving;
	bool FUseA1SYLKReference;
	TwwGridExportEnocodingType FEncoding;
	System::UnicodeString __fastcall GetFileName(void);
	void __fastcall SetFileName(System::UnicodeString val);
	System::UnicodeString __fastcall GetDelimiter(void);
	void __fastcall SetDelimiter(System::UnicodeString val);
	bool __fastcall IsDelimiterStored(void);
	
protected:
	virtual System::UnicodeString __fastcall AddQuotes(System::UnicodeString s);
	int __fastcall XRecNoOffset(void);
	int __fastcall QuotesPad(void);
	
public:
	System::Classes::TComponent* Owner;
	virtual void __fastcall Save(void);
	void __fastcall ExportToStream(System::Classes::TStream* fs);
	__fastcall virtual TwwExportOptions(System::Classes::TComponent* AOwner);
	__property bool UseOldClipboardSaving = {read=FUseOldClipboardSaving, write=FUseOldClipboardSaving, default=0};
	__property bool UseA1SYLKReference = {read=FUseA1SYLKReference, write=FUseA1SYLKReference, default=0};
	
__published:
	__property System::UnicodeString Delimiter = {read=GetDelimiter, write=SetDelimiter, stored=IsDelimiterStored};
	__property TwwGridExportType ExportType = {read=FExportType, write=FExportType, default=0};
	__property System::UnicodeString FileName = {read=GetFileName, write=SetFileName};
	__property int HTMLBorderWidth = {read=FHTMLBorderWidth, write=FHTMLBorderWidth, default=1};
	__property TwwExportSaveOptions Options = {read=FOptions, write=FOptions, default=1049};
	__property int OutputWidthinTwips = {read=FOutputWidthinTwips, write=FOutputWidthinTwips, default=0};
	__property System::UnicodeString TitleName = {read=FTitleName, write=FTitleName};
	__property TwwGridExportEnocodingType Encoding = {read=FEncoding, write=FEncoding, default=5};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwExportOptions(void) { }
	
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwexport */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWEXPORT)
using namespace Vcl::Wwexport;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwexportHPP
