// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwqbe.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwqbeHPP
#define Vcl_WwqbeHPP

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
namespace Wwqbe
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwQBE;
//-- type declarations -------------------------------------------------------
typedef void __fastcall (__closure *TwwQBEFilterEvent)(TwwQBE* Qbe, bool &Accept);

typedef void __fastcall (__closure *TwwQBEErrorEvent)(TwwQBE* Qbe, int ErrorCode);

class PASCALIMPLEMENTATION TwwQBE : public Bde::Dbtables::TDBDataSet
{
	typedef Bde::Dbtables::TDBDataSet inherited;
	
private:
	System::Classes::TStrings* FLookupFields;
	System::Classes::TStrings* FLookupLinks;
	System::Classes::TStrings* FControlType;
	System::Classes::TStrings* FPictureMasks;
	System::Classes::TStrings* FQBE;
	System::UnicodeString FAnswerTable;
	bool FAuxiliaryTables;
	bool FBlankAsZero;
	System::Classes::TStrings* FParamValues;
	TwwQBEErrorEvent FOnError;
	System::Classes::TStringList* FParams;
	bool bSkipCreateHandle;
	bool bUpdateQuery;
	Bde::_hDBIObj *TempHandle;
	Vcl::Wwtypes::TwwInvalidValueEvent FOnInvalidValue;
	Vcl::Wwtypes::TwwOnFilterOptions FOnFilterOptions;
	Data::Db::TDataSetNotifyEvent FOnFilterEscape;
	TwwQBEFilterEvent FOnFilter;
	void *FFilterBuffer;
	char *FFilterFieldBuffer;
	Bde::_hDBIObj *hFilterFunction;
	Data::Db::TParam* FFilterParam;
	int CallCount;
	void __fastcall SetOnFilter(TwwQBEFilterEvent val);
	void __fastcall SetQBE(System::Classes::TStrings* QBE);
	System::Classes::TStrings* __fastcall GetLookupFields(void);
	void __fastcall SetLookupFields(System::Classes::TStrings* sel);
	System::Classes::TStrings* __fastcall GetLookupLinks(void);
	void __fastcall SetLookupLinks(System::Classes::TStrings* sel);
	System::Classes::TStrings* __fastcall getControlType(void);
	void __fastcall SetControlType(System::Classes::TStrings* sel);
	System::Classes::TStrings* __fastcall GetPictureMasks(void);
	void __fastcall SetPictureMasks(System::Classes::TStrings* sel);
	void __fastcall SetOnFilterOptions(Vcl::Wwtypes::TwwOnFilterOptions val);
	
protected:
	virtual void __fastcall DoOnCalcFields(void);
	virtual Bde::hDBICur __fastcall CreateHandle(void);
	virtual void __fastcall OpenCursor(bool InfoQuery);
	virtual void __fastcall DoAfterOpen(void);
	virtual System::Word __fastcall PerformQuery(Bde::hDBICur &AdbiHandle);
	virtual void __fastcall DataEvent(Data::Db::TDataEvent Event, NativeInt Info);
	virtual int __fastcall GetNextRecords(void);
	void __fastcall ResetMouseCursor(void);
	
public:
	System::Classes::TList* LookupTables;
	bool inFilterEvent;
	bool ProcessingOnFilter;
	virtual bool __fastcall IsSequenced(void);
	__fastcall virtual TwwQBE(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwQBE(void);
	bool __fastcall IsValidField(System::UnicodeString fieldName);
	void __fastcall RemoveObsoleteLinks(void);
	void __fastcall FreeLookupTables(void);
	bool __fastcall SaveAnswerTable(System::UnicodeString tableName);
	Data::Db::TParam* __fastcall wwFilterField(System::UnicodeString AFieldName);
	void __fastcall SetParam(System::UnicodeString paramName, System::UnicodeString paramValue);
	void __fastcall ClearParams(void);
	System::UnicodeString __fastcall GetParam(System::UnicodeString paramName);
	
__published:
	__property System::Classes::TStrings* ControlType = {read=getControlType, write=SetControlType};
	__property System::Classes::TStrings* LookupFields = {read=GetLookupFields, write=SetLookupFields};
	__property System::Classes::TStrings* LookupLinks = {read=GetLookupLinks, write=SetLookupLinks};
	__property System::Classes::TStrings* QBE = {read=FQBE, write=SetQBE};
	__property System::UnicodeString AnswerTable = {read=FAnswerTable, write=FAnswerTable};
	__property bool AuxiliaryTables = {read=FAuxiliaryTables, write=FAuxiliaryTables, nodefault};
	__property bool BlankAsZero = {read=FBlankAsZero, write=FBlankAsZero, nodefault};
	__property System::Classes::TStrings* PictureMasks = {read=GetPictureMasks, write=SetPictureMasks};
	__property UpdateObject;
	__property TwwQBEFilterEvent OnFilter = {read=FOnFilter, write=SetOnFilter};
	__property Data::Db::TDataSetNotifyEvent OnFilterEscape = {read=FOnFilterEscape, write=FOnFilterEscape};
	__property Vcl::Wwtypes::TwwOnFilterOptions OnFilterOptions = {read=FOnFilterOptions, write=SetOnFilterOptions, default=3};
	__property Vcl::Wwtypes::TwwInvalidValueEvent OnInvalidValue = {read=FOnInvalidValue, write=FOnInvalidValue};
	__property TwwQBEErrorEvent OnError = {read=FOnError, write=FOnError};
	System::TObject* __fastcall GetVariableObject(System::UnicodeString VariableName, const System::Variant &Param);
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwqbe */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWQBE)
using namespace Vcl::Wwqbe;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwqbeHPP
