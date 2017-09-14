// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwstorep.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwstorepHPP
#define Vcl_WwstorepHPP

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
#include <Vcl.Forms.hpp>
#include <Data.DB.hpp>
#include <Bde.DBTables.hpp>
#include <Vcl.Dialogs.hpp>
#include <vcl.wwfilter.hpp>
#include <vcl.Wwstr.hpp>
#include <vcl.Wwsystem.hpp>
#include <vcl.wwtable.hpp>
#include <vcl.wwtypes.hpp>
#include <vcl.wwbdecommon.hpp>
#include <BDE.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwstorep
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwStoredProc;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TwwStoredProcFilterEvent)(TwwStoredProc* StoredProc, bool &Accept);

class PASCALIMPLEMENTATION TwwStoredProc : public Bde::Dbtables::TStoredProc
{
	typedef Bde::Dbtables::TStoredProc inherited;
	
private:
	System::Classes::TStrings* FLookupFields;
	System::Classes::TStrings* FLookupLinks;
	System::Classes::TStrings* FControlType;
	System::Classes::TStrings* FPictureMasks;
	bool FUsePictureMask;
	Vcl::Wwtypes::TwwInvalidValueEvent FOnInvalidValue;
	Vcl::Wwtypes::TwwOnFilterOptions FOnFilterOptions;
	Data::Db::TDataSetNotifyEvent FOnFilterEscape;
	TwwStoredProcFilterEvent FOnFilter;
	void *FFilterBuffer;
	char *FFilterFieldBuffer;
	Bde::_hDBIObj *hFilterFunction;
	Data::Db::TParam* FFilterParam;
	void __fastcall SetOnFilter(TwwStoredProcFilterEvent val);
	System::Classes::TStrings* __fastcall GetLookupFields(void);
	void __fastcall SetLookupFields(System::Classes::TStrings* sel);
	System::Classes::TStrings* __fastcall GetLookupLinks(void);
	void __fastcall SetLookupLinks(System::Classes::TStrings* sel);
	System::Classes::TStrings* __fastcall GetControlType(void);
	void __fastcall SetControlType(System::Classes::TStrings* sel);
	System::Classes::TStrings* __fastcall GetPictureMasks(void);
	void __fastcall SetPictureMasks(System::Classes::TStrings* sel);
	void __fastcall SetOnFilterOptions(Vcl::Wwtypes::TwwOnFilterOptions val);
	
protected:
	virtual void __fastcall DoOnCalcFields(void);
	virtual void __fastcall DoAfterOpen(void);
	virtual void __fastcall DoBeforePost(void);
	virtual void __fastcall DataEvent(Data::Db::TDataEvent Event, NativeInt Info);
	virtual int __fastcall GetNextRecords(void);
	void __fastcall ResetMouseCursor(void);
	
public:
	System::Classes::TList* LookupTables;
	bool InFilterEvent;
	bool ProcessingOnFilter;
	virtual bool __fastcall IsSequenced(void);
	__fastcall virtual TwwStoredProc(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwStoredProc(void);
	bool __fastcall IsValidField(System::UnicodeString fieldName);
	void __fastcall RemoveObsoleteLinks(void);
	void __fastcall FreeLookupTables(void);
	Data::Db::TParam* __fastcall wwFilterField(System::UnicodeString AFieldName);
	
__published:
	__property System::Classes::TStrings* ControlType = {read=GetControlType, write=SetControlType};
	__property System::Classes::TStrings* LookupFields = {read=GetLookupFields, write=SetLookupFields};
	__property System::Classes::TStrings* LookupLinks = {read=GetLookupLinks, write=SetLookupLinks};
	__property System::Classes::TStrings* PictureMasks = {read=GetPictureMasks, write=SetPictureMasks};
	__property bool ValidateWithMask = {read=FUsePictureMask, write=FUsePictureMask, nodefault};
	__property TwwStoredProcFilterEvent OnFilter = {read=FOnFilter, write=SetOnFilter};
	__property Data::Db::TDataSetNotifyEvent OnFilterEscape = {read=FOnFilterEscape, write=FOnFilterEscape};
	__property Vcl::Wwtypes::TwwOnFilterOptions OnFilterOptions = {read=FOnFilterOptions, write=SetOnFilterOptions, default=3};
	__property Vcl::Wwtypes::TwwInvalidValueEvent OnInvalidValue = {read=FOnInvalidValue, write=FOnInvalidValue};
	System::TObject* __fastcall GetVariableObject(System::UnicodeString VariableName, const System::Variant &Param);
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwstorep */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWSTOREP)
using namespace Vcl::Wwstorep;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwstorepHPP
