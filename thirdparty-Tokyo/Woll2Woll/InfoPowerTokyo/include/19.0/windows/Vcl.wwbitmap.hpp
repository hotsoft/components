// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.Wwbitmap.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwbitmapHPP
#define Vcl_WwbitmapHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <Winapi.Windows.hpp>
#include <Vcl.Graphics.hpp>
#include <System.Classes.hpp>
#include <vcl.wwchangelink.hpp>
#include <System.SysUtils.hpp>
#include <System.Types.hpp>
#include <System.UITypes.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwbitmap
{
//-- forward type declarations -----------------------------------------------
struct TwwColor;
class DELPHICLASS TwwBitmap;
//-- type declarations -------------------------------------------------------
struct DECLSPEC_DRECORD TwwColor
{
public:
	System::Byte b;
	System::Byte g;
	System::Byte r;
};


typedef TwwColor *PwwColor;

typedef System::StaticArray<TwwColor, 1> TwwLine;

typedef TwwLine *PwwLine;

typedef System::StaticArray<PwwLine, 1> TwwPLines;

typedef TwwPLines *PwwPLines;

class PASCALIMPLEMENTATION TwwBitmap : public Vcl::Graphics::TGraphic
{
	typedef Vcl::Graphics::TGraphic inherited;
	
private:
	bool FSmoothStretching;
	System::Uitypes::TColor FTransparentColor;
	int FWidth;
	int FHeight;
	int FGap;
	Vcl::Graphics::TBitmap* FMaskBitmap;
	int FRowInc;
	int FSize;
	void *FBits;
	int FHandle;
	HDC FDC;
	Vcl::Graphics::TCanvas* FCanvas;
	void *FMemoryImage;
	int FMemorySize;
	System::Types::TSize FMemoryDim;
	Vcl::Graphics::TPixelFormat FPixelFormat;
	HPALETTE FPalette;
	bool FRespectPalette;
	bool FUseHalftonePalette;
	bool FIgnoreChange;
	System::Classes::TList* FChangeLinks;
	tagBITMAPINFO bmInfo;
	tagBITMAPINFOHEADER bmHeader;
	bool __fastcall GetSleeping(void);
	void __fastcall InitHeader(void);
	
protected:
	bool Assigning;
	bool SkipPalette;
	virtual void __fastcall RestoreBitmapPalette(Vcl::Graphics::TCanvas* ACanvas, HPALETTE OldPalette);
	virtual void __fastcall SelectBitmapPalette(Vcl::Graphics::TCanvas* ACanvas, HPALETTE &OldPalette);
	virtual bool __fastcall GetEmpty(void);
	virtual int __fastcall GetHeight(void);
	virtual int __fastcall GetWidth(void);
	virtual void __fastcall AssignTo(System::Classes::TPersistent* Dest);
	virtual void __fastcall Changed(System::TObject* Sender);
	virtual void __fastcall Draw(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &Rect);
	virtual void __fastcall SetHeight(int Value);
	virtual void __fastcall SetWidth(int Value);
	virtual void __fastcall CleanUp(void);
	virtual void __fastcall Initialize(void);
	virtual void __fastcall NotifyChanges(void);
	virtual void __fastcall PaletteNeeded(void);
	__property int Gap = {read=FGap, nodefault};
	__property int RowInc = {read=FRowInc, nodefault};
	__property HDC DC = {read=FDC, nodefault};
	
public:
	System::Variant Patch;
	TwwPLines *Pixels;
	System::StaticArray<tagRGBQUAD, 256> Colors;
	__fastcall virtual TwwBitmap(void);
	__fastcall virtual ~TwwBitmap(void);
	virtual void __fastcall Assign(System::Classes::TPersistent* Source);
	virtual void __fastcall RegisterChanges(Vcl::Wwchangelink::TwwChangeLink* ChangeLink);
	virtual void __fastcall UnRegisterChanges(Vcl::Wwchangelink::TwwChangeLink* ChangeLink);
	virtual void __fastcall Clear(void);
	virtual void __fastcall FreeMemoryImage(void);
	virtual void __fastcall LoadBlank(int AWidth, int AHeight);
	virtual void __fastcall LoadFromBitmap(Vcl::Graphics::TBitmap* Bitmap);
	virtual void __fastcall LoadFromJPEG(Vcl::Graphics::TGraphic* JPEG);
	virtual void __fastcall LoadFromClipboardFormat(System::Word AFormat, NativeUInt AData, HPALETTE APalette);
	virtual void __fastcall LoadFromGraphic(Vcl::Graphics::TGraphic* Graphic);
	virtual void __fastcall LoadFromMemory(void * ABits, int ASize, const System::Types::TSize &Dimensions);
	virtual void __fastcall LoadFromStream(System::Classes::TStream* Stream);
	virtual void __fastcall SaveToBitmap(Vcl::Graphics::TBitmap* Bitmap);
	virtual void __fastcall SaveToClipboardFormat(System::Word &AFormat, NativeUInt &AData, HPALETTE &APalette);
	virtual void __fastcall SaveToStream(System::Classes::TStream* Stream);
	virtual void __fastcall SetSizeInternal(const int AWidth, const int AHeight);
	Vcl::Graphics::TBitmap* __fastcall GetMaskBitmap(void);
	PwwPLines __fastcall CopyPixels(void);
	void __fastcall Fill(System::Uitypes::TColor Color);
	virtual void __fastcall Resize(int AWidth, int AHeight);
	virtual void __fastcall Sleep(void);
	virtual void __fastcall SmoothStretchDraw(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &Rect);
	virtual void __fastcall StretchDraw(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &Rect);
	virtual void __fastcall TileDraw(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &ARect);
	virtual void __fastcall TransparentDraw(Vcl::Graphics::TCanvas* ACanvas, const System::Types::TRect &Rect);
	virtual void __fastcall Wake(void);
	void __fastcall AlphaBlend(TwwBitmap* Bitmap, int Alpha, bool Stretch);
	virtual void __fastcall Blur(int Amount);
	virtual void __fastcall Contrast(int Amount);
	virtual void __fastcall Emboss(void);
	virtual void __fastcall Flip(bool Horizontal);
	virtual void __fastcall GaussianBlur(int Amount);
	virtual void __fastcall Grayscale(void);
	virtual void __fastcall Invert(void);
	virtual void __fastcall Brightness(int Amount);
	virtual void __fastcall Mask(TwwColor MaskColor);
	virtual void __fastcall ChangeColor(TwwColor OldColor, TwwColor NewColor);
	virtual void __fastcall ColorTint(int ra, int ga, int ba);
	virtual void __fastcall Colorize(int ra, int ga, int ba);
	virtual void __fastcall Rotate(const System::Types::TPoint &Center, System::Extended Angle);
	virtual void __fastcall Saturation(int Amount);
	virtual void __fastcall Sharpen(int Amount);
	virtual void __fastcall Sponge(int Amount);
	virtual void __fastcall Wave(System::Extended XDiv, System::Extended YDiv, System::Extended RatioVal, bool Wrap);
	__property void * Bits = {read=FBits};
	__property Vcl::Graphics::TCanvas* Canvas = {read=FCanvas};
	__property int Handle = {read=FHandle, nodefault};
	__property bool IgnoreChange = {read=FIgnoreChange, write=FIgnoreChange, nodefault};
	__property Vcl::Graphics::TBitmap* MaskBitmap = {read=GetMaskBitmap};
	__property bool RespectPalette = {read=FRespectPalette, write=FRespectPalette, nodefault};
	__property bool UseHalftonePalette = {read=FUseHalftonePalette, write=FUseHalftonePalette, nodefault};
	__property bool SmoothStretching = {read=FSmoothStretching, write=FSmoothStretching, nodefault};
	__property bool Sleeping = {read=GetSleeping, nodefault};
	__property int Size = {read=FSize, nodefault};
	__property System::Uitypes::TColor TransparentColor = {read=FTransparentColor, write=FTransparentColor, nodefault};
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE TwwColor __fastcall wwGetColor(System::Uitypes::TColor Color);
extern DELPHI_PACKAGE System::Uitypes::TColor __fastcall wwGetStdColor(TwwColor Color);
extern DELPHI_PACKAGE TwwColor __fastcall wwRGB(System::Byte r, System::Byte g, System::Byte b);
extern DELPHI_PACKAGE System::Byte __fastcall wwIntToByte(int Value);
extern DELPHI_PACKAGE int __fastcall wwTrimInt(int i, int Min, int Max);
}	/* namespace Wwbitmap */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWBITMAP)
using namespace Vcl::Wwbitmap;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwbitmapHPP
