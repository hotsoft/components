// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwpaintoptions.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwpaintoptionsHPP
#define Vcl_WwpaintoptionsHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Messages.hpp>
#include <Winapi.Windows.hpp>
#include <System.SysUtils.hpp>
#include <System.Classes.hpp>
#include <Vcl.Graphics.hpp>
#include <Vcl.Menus.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <vcl.Wwbitmap.hpp>
#include <Vcl.Grids.hpp>
#include <System.TypInfo.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwpaintoptions
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwGridPaintOptions;
//-- type declarations -------------------------------------------------------
enum DECLSPEC_DENUM TwwBackgroundOption : unsigned char { coFillDataCells, coBlendFixedRow, coBlendFixedColumn, coBlendActiveRecord, coBlendAlternatingRow };

typedef System::Set<TwwBackgroundOption, TwwBackgroundOption::coFillDataCells, TwwBackgroundOption::coBlendAlternatingRow> TwwBackgroundOptions;

enum DECLSPEC_DENUM TwwBackgroundDrawStyle : unsigned char { bdsTile, bdsStretch, bdsTopLeft, bdsCenter };

enum DECLSPEC_DENUM TwwAlternatingRowRegion : unsigned char { arrFixedColumns, arrDataColumns, arrActiveDataColumn };

typedef System::Set<TwwAlternatingRowRegion, TwwAlternatingRowRegion::arrFixedColumns, TwwAlternatingRowRegion::arrActiveDataColumn> TwwAlternatingRowRegions;

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwGridPaintOptions : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	System::Uitypes::TColor FAlternatingRowColor;
	System::Uitypes::TColor FActiveRecordColor;
	TwwBackgroundOptions FBackgroundOptions;
	Vcl::Graphics::TPicture* FBackgroundBitmap;
	TwwBackgroundDrawStyle FBackgroundDrawStyle;
	TwwAlternatingRowRegions FAlternatingRowRegions;
	bool FFastRecordScrolling;
	void __fastcall PictureChanged(System::TObject* Sender);
	
protected:
	virtual void __fastcall SetAlternatingRowRegions(TwwAlternatingRowRegions val);
	virtual void __fastcall SetAlternatingRowColor(System::Uitypes::TColor Value);
	virtual void __fastcall SetActiveRecordColor(System::Uitypes::TColor Value);
	virtual void __fastcall SetBackgroundOptions(TwwBackgroundOptions Value);
	virtual void __fastcall SetBackgroundDrawStyle(TwwBackgroundDrawStyle Value);
	virtual void __fastcall SetBackgroundBitmap(Vcl::Graphics::TPicture* Value);
	virtual Vcl::Graphics::TCanvas* __fastcall GetCanvas(void);
	
public:
	Vcl::Grids::TCustomGrid* Grid;
	bool InitBlendBitmapsFlag;
	System::Uitypes::TColor Column1Color;
	System::Uitypes::TColor Row1Color;
	Vcl::Graphics::TBitmap* FPaintBitmap;
	Vcl::Graphics::TBitmap* OrigBitmap;
	Vcl::Wwbitmap::TwwBitmap* AlternatingColorBitmap;
	Vcl::Wwbitmap::TwwBitmap* ActiveRecordBitmap;
	Vcl::Wwbitmap::TwwBitmap* Column1Bitmap;
	Vcl::Wwbitmap::TwwBitmap* Row1Bitmap;
	__fastcall TwwGridPaintOptions(System::Classes::TComponent* Owner, Vcl::Graphics::TBitmap* APaintBitmap);
	__fastcall virtual ~TwwGridPaintOptions(void);
	void __fastcall InitBlendBitmaps(bool ForceInit = false);
	__property Vcl::Graphics::TCanvas* Canvas = {read=GetCanvas};
	virtual bool __fastcall HaveBackgroundForDataCells(void);
	
__published:
	__property Vcl::Graphics::TPicture* BackgroundBitmap = {read=FBackgroundBitmap, write=SetBackgroundBitmap};
	__property TwwBackgroundDrawStyle BackgroundDrawStyle = {read=FBackgroundDrawStyle, write=SetBackgroundDrawStyle, default=0};
	__property TwwAlternatingRowRegions AlternatingRowRegions = {read=FAlternatingRowRegions, write=SetAlternatingRowRegions, default=7};
	__property bool FastRecordScrolling = {read=FFastRecordScrolling, write=FFastRecordScrolling, default=1};
	__property System::Uitypes::TColor AlternatingRowColor = {read=FAlternatingRowColor, write=SetAlternatingRowColor, default=536870911};
	__property System::Uitypes::TColor ActiveRecordColor = {read=FActiveRecordColor, write=SetActiveRecordColor, default=536870911};
	__property TwwBackgroundOptions BackgroundOptions = {read=FBackgroundOptions, write=SetBackgroundOptions, default=0};
};

#pragma pack(pop)

//-- var, const, procedure ---------------------------------------------------
}	/* namespace Wwpaintoptions */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWPAINTOPTIONS)
using namespace Vcl::Wwpaintoptions;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwpaintoptionsHPP
