// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwtypes.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwtypesHPP
#define Vcl_WwtypesHPP

#pragma delphiheader begin
#pragma option push
#pragma option -w-      // All warnings off
#pragma option -Vx      // Zero-length empty class member 
#pragma pack(push,8)
#include <System.hpp>
#include <SysInit.hpp>
#include <System.Classes.hpp>
#include <Data.DB.hpp>
#include <Vcl.Forms.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Controls.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwtypes
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwFormPosition;
class DELPHICLASS TwwCheatCastNotify;
class DELPHICLASS TwwCheatCastKeyDown;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TwwProcMeth)(void);

typedef bool __fastcall (__closure *TwwBoolFunc)(void);

typedef void __fastcall (__closure *TwwInvalidValueEvent)(Data::Db::TDataSet* DataSet, Data::Db::TField* Field);

typedef Data::Db::TParam* __fastcall (__closure *TwwFilterFieldMethod)(System::UnicodeString AFieldName);

typedef void __fastcall (__closure *TwwDataSetFilterEvent)(Data::Db::TDataSet* table, bool &Accept);

typedef void __fastcall (__closure *TwwPerformSearchEvent)(System::TObject* Sender, Data::Db::TDataSet* LookupTable, System::UnicodeString SearchField, System::UnicodeString SearchValue, bool PerformLookup, bool &Found);

enum DECLSPEC_DENUM TwwGetWordOption : unsigned char { wwgwSkipLeadingBlanks, wwgwQuotesAsWords, wwgwStripQuotes, wwgwSpacesInWords };

enum DECLSPEC_DENUM TwwWriteTextOption : unsigned char { wtoAmpersandToUnderline, wtoEllipsis, wtoWordWrap, wtoMergeCanvas, wtoTransparent, wtoCenterVert, wtoIsTitle, wtoDisableThemes, wtoDisabledText, wtoGridSelected };

typedef System::Set<TwwWriteTextOption, TwwWriteTextOption::wtoAmpersandToUnderline, TwwWriteTextOption::wtoGridSelected> TwwWriteTextOptions;

typedef System::Set<TwwGetWordOption, TwwGetWordOption::wwgwSkipLeadingBlanks, TwwGetWordOption::wwgwSpacesInWords> TwwGetWordOptions;

enum DECLSPEC_DENUM TwwEditAlignment : unsigned char { eaLeftAlignEditing, eaRightAlignEditing };

#pragma pack(push,4)
class PASCALIMPLEMENTATION TwwFormPosition : public System::Classes::TPersistent
{
	typedef System::Classes::TPersistent inherited;
	
private:
	int FLeft;
	int FTop;
	int FWidth;
	int FHeight;
	
__published:
	__property int Left = {read=FLeft, write=FLeft, nodefault};
	__property int Top = {read=FTop, write=FTop, nodefault};
	__property int Width = {read=FWidth, write=FWidth, nodefault};
	__property int Height = {read=FHeight, write=FHeight, nodefault};
public:
	/* TPersistent.Destroy */ inline __fastcall virtual ~TwwFormPosition(void) { }
	
public:
	/* TObject.Create */ inline __fastcall TwwFormPosition(void) : System::Classes::TPersistent() { }
	
};

#pragma pack(pop)

class PASCALIMPLEMENTATION TwwCheatCastNotify : public System::Classes::TComponent
{
	typedef System::Classes::TComponent inherited;
	
public:
	virtual void __fastcall Notification(System::Classes::TComponent* AComponent, System::Classes::TOperation Operation);
public:
	/* TComponent.Create */ inline __fastcall virtual TwwCheatCastNotify(System::Classes::TComponent* AOwner) : System::Classes::TComponent(AOwner) { }
	/* TComponent.Destroy */ inline __fastcall virtual ~TwwCheatCastNotify(void) { }
	
};


class PASCALIMPLEMENTATION TwwCheatCastKeyDown : public Vcl::Stdctrls::TCustomEdit
{
	typedef Vcl::Stdctrls::TCustomEdit inherited;
	
public:
	DYNAMIC void __fastcall KeyDown(System::Word &key, System::Classes::TShiftState shift);
public:
	/* TCustomEdit.Create */ inline __fastcall virtual TwwCheatCastKeyDown(System::Classes::TComponent* AOwner) : Vcl::Stdctrls::TCustomEdit(AOwner) { }
	
public:
	/* TWinControl.CreateParented */ inline __fastcall TwwCheatCastKeyDown(HWND ParentWindow) : Vcl::Stdctrls::TCustomEdit(ParentWindow) { }
	/* TWinControl.Destroy */ inline __fastcall virtual ~TwwCheatCastKeyDown(void) { }
	
};


enum DECLSPEC_DENUM TwwOnFilterOption : unsigned char { ofoEnabled, ofoShowHourGlass, ofoCancelOnEscape };

typedef System::Set<TwwOnFilterOption, TwwOnFilterOption::ofoEnabled, TwwOnFilterOption::ofoCancelOnEscape> TwwOnFilterOptions;

//-- var, const, procedure ---------------------------------------------------
#define wwNewLineString L"<New Line>"
static const System::Int8 CmpLess = System::Int8(-1);
static const System::Int8 CMPEql = System::Int8(0x0);
static const System::Int8 CmpGtr = System::Int8(0x1);
static const System::Int8 CMPKeyEql = System::Int8(0x2);
#define wwSLookupSourceError L"Unable to use duplicate DataSource and LookupSource"
#define wwSLookupTableError L"LookupSource must be connected to a TDataSet component"
extern DELPHI_PACKAGE int __fastcall wwFilterMemoSize(void);
}	/* namespace Wwtypes */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWTYPES)
using namespace Vcl::Wwtypes;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwtypesHPP
