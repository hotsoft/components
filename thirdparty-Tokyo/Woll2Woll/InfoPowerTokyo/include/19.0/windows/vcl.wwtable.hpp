// CodeGear C++Builder
// Copyright (c) 1995, 2016 by Embarcadero Technologies, Inc.
// All rights reserved

// (DO NOT EDIT: machine generated header) 'vcl.wwtable.pas' rev: 32.00 (Windows)

#ifndef Vcl_WwtableHPP
#define Vcl_WwtableHPP

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
#include <vcl.wwlocate.hpp>
#include <vcl.wwtypes.hpp>
#include <vcl.wwbdecommon.hpp>
#include <Data.DBCommonTypes.hpp>
#include <BDE.hpp>

//-- user supplied -----------------------------------------------------------

namespace Vcl
{
namespace Wwtable
{
//-- forward type declarations -----------------------------------------------
class DELPHICLASS TwwTable;
//-- type declarations -------------------------------------------------------
typedef bool *PtrBoolean;

typedef System::Classes::TStrings TwwTableDisplayType;

typedef void __fastcall (__closure *TwwTableFilterEvent)(TwwTable* table, bool &accept);

class PASCALIMPLEMENTATION TwwTable : public Bde::Dbtables::TTable
{
	typedef Bde::Dbtables::TTable inherited;
	
private:
	System::Classes::TStrings* FFilter;
	System::Classes::TStrings* FQuery;
	System::Classes::TStrings* FPictureMasks;
	System::Classes::TStrings* FLookupFields;
	System::Classes::TStrings* FLookupLinks;
	System::Classes::TStrings* FControlType;
	bool FUsePictureMask;
	bool FSyncSQLByRange;
	bool FNarrowSearch;
	Vcl::Wwtypes::TwwInvalidValueEvent FOnInvalidValue;
	Vcl::Wwtypes::TwwOnFilterOptions FOnFilterOptions;
	Data::Db::TDataSetNotifyEvent FOnFilterEscape;
	TwwTableFilterEvent FOnFilter;
	void *FFilterBuffer;
	char *FFilterFieldBuffer;
	Bde::_hDBIObj *hFilter;
	Bde::_hDBIObj *hFilterFunction;
	Data::Db::TParam* FFilterParam;
	bool FIsSequencable;
	System::Word FNarrowSearchUpperChar;
	System::UnicodeString QueryType;
	System::Classes::TNotifyEvent FOnDestroy;
	System::Classes::TList* dependentPtrs;
	Bde::_hDBIObj *rangeFilter;
	bool isOpen;
	System::Classes::TStrings* PdxMasks;
	bool InitPdxMasks;
	int CallCount;
	System::Classes::TStrings* __fastcall getLookupFields(void);
	void __fastcall setLookupFields(System::Classes::TStrings* sel);
	System::Classes::TStrings* __fastcall getPictureMasks(void);
	void __fastcall setPictureMasks(System::Classes::TStrings* sel);
	System::Classes::TStrings* __fastcall getLookupLinks(void);
	void __fastcall setLookupLinks(System::Classes::TStrings* sel);
	System::Classes::TStrings* __fastcall getControlType(void);
	void __fastcall setControlType(System::Classes::TStrings* sel);
	void __fastcall setFilterArray(System::Classes::TStrings* sel);
	System::Classes::TStrings* __fastcall getFilter(void);
	void __fastcall SetOnFilter(TwwTableFilterEvent val);
	int __fastcall GetFilterCount(void);
	void __fastcall SetQuery(System::Classes::TStrings* sel);
	bool __fastcall isSequencableTable(void);
	HIDESBASE void __fastcall SetTableName(const System::Sysutils::TFileName Value);
	System::Sysutils::TFileName __fastcall GetTableName(void);
	void __fastcall DoInitPdxMasks(void);
	bool __fastcall FindFieldsToIndex(System::UnicodeString AIndexFields, bool CaseSensitive, bool exactFieldMatch, System::UnicodeString &newIndexName);
	void __fastcall SetOnFilterOptions(Vcl::Wwtypes::TwwOnFilterOptions val);
	
protected:
	virtual void __fastcall PrepareCursor(void);
	virtual void __fastcall OpenCursor(bool InfoQuery);
	virtual void __fastcall CloseCursor(void);
	virtual Bde::hDBICur __fastcall CreateHandle(void);
	System::Word __fastcall PerformQuery(Bde::hDBICur &AdbiHandle);
	virtual void __fastcall DoBeforePost(void);
	virtual void __fastcall InitFieldDefs(void);
	virtual void __fastcall DoOnCalcFields(void);
	System::UnicodeString __fastcall GetIndexFieldName(void);
	void __fastcall SetIndexFieldName(System::UnicodeString val);
	virtual void __fastcall DataEvent(Data::Db::TDataEvent Event, NativeInt Info);
	virtual int __fastcall GetNextRecords(void);
	void __fastcall ResetMouseCursor(void);
	
public:
	bool UpToDate;
	bool UpToDateRes;
	System::UnicodeString CalcLookupLinks;
	void *wwInternalPtr;
	bool inFilterEvent;
	bool InLookupLink;
	int InFindRecordCount;
	bool IgnoreMasterLink;
	System::Classes::TList* lookupTables;
	bool ProcessingOnFilter;
	virtual bool __fastcall IsSequenced(void);
	__property bool IsSequencable = {read=FIsSequencable, nodefault};
	__property int FilterCount = {read=GetFilterCount, nodefault};
	__fastcall virtual TwwTable(System::Classes::TComponent* AOwner);
	__fastcall virtual ~TwwTable(void);
	void __fastcall RefreshLinks(void);
	bool __fastcall IsValidField(System::UnicodeString fieldName);
	void __fastcall RemoveObsoleteLinks(void);
	void __fastcall SyncSQLTable(Bde::Dbtables::TTable* lookupTable);
	void __fastcall FreeLookupTables(void);
	bool __fastcall wwFindKey(const System::TVarRec *KeyValues, const int KeyValues_High);
	bool __fastcall wwFindNearest(System::UnicodeString key, int FieldNo);
	void __fastcall wwChangeIndex(Data::Db::TIndexDef* a_indexItem);
	void __fastcall wwChangeIndexName(System::UnicodeString a_indexName);
	void __fastcall AddDependentTablePtr(PtrBoolean a_value);
	void __fastcall RemoveDependentTablePtr(PtrBoolean a_value);
	void __fastcall wwSetRangeStart(const System::TVarRec *startValues, const int startValues_High);
	bool __fastcall Pack(System::UnicodeString &statusMsg);
	bool __fastcall setFilter(System::UnicodeString sel);
	System::UnicodeString __fastcall FilterString(void);
	bool __fastcall IsParadoxTable(void);
	bool __fastcall IsDBaseTable(void);
	bool __fastcall FilterActivate(void);
	System::UnicodeString __fastcall IndexToFields(System::UnicodeString aIndexName);
	System::UnicodeString __fastcall FieldsToIndex(System::UnicodeString aIndexFields);
	System::UnicodeString __fastcall FieldstoIndexWithCase(System::UnicodeString aIndexFields, bool caseSensitive);
	System::UnicodeString __fastcall GetDBPicture(System::UnicodeString curFieldName);
	void __fastcall UpdateIndexes(void);
	void __fastcall FastCancelRange(void);
	void __fastcall ClearCurrentRangeBuffers(void);
	bool __fastcall SetLookupField(Data::Db::TField* Field);
	bool __fastcall isCaseInsensitiveIndex(void);
	void __fastcall LoadPdxMasks(void);
	__property System::Classes::TNotifyEvent OnDestroy = {read=FOnDestroy, write=FOnDestroy};
	__property System::UnicodeString IndexFieldName = {read=GetIndexFieldName, write=SetIndexFieldName};
	
__published:
	__property System::Classes::TStrings* LookupFields = {read=getLookupFields, write=setLookupFields, stored=true};
	__property System::Classes::TStrings* LookupLinks = {read=getLookupLinks, write=setLookupLinks, stored=true};
	__property System::Classes::TStrings* ControlType = {read=getControlType, write=setControlType, stored=true};
	__property System::Classes::TStrings* PictureMasks = {read=getPictureMasks, write=setPictureMasks};
	__property System::Classes::TStrings* wwFilter = {read=getFilter, write=setFilterArray};
	__property bool SyncSQLByRange = {read=FSyncSQLByRange, write=FSyncSQLByRange, nodefault};
	__property bool NarrowSearch = {read=FNarrowSearch, write=FNarrowSearch, nodefault};
	__property System::Word NarrowSearchUpperChar = {read=FNarrowSearchUpperChar, write=FNarrowSearchUpperChar, default=255};
	__property System::Classes::TStrings* Query = {read=FQuery, write=SetQuery};
	__property TableName = {read=GetTableName, write=SetTableName, default=0};
	__property bool ValidateWithMask = {read=FUsePictureMask, write=FUsePictureMask, nodefault};
	__property Vcl::Wwtypes::TwwInvalidValueEvent OnInvalidValue = {read=FOnInvalidValue, write=FOnInvalidValue};
	__property TwwTableFilterEvent OnFilter = {read=FOnFilter, write=SetOnFilter};
	__property Data::Db::TDataSetNotifyEvent OnFilterEscape = {read=FOnFilterEscape, write=FOnFilterEscape};
	__property Vcl::Wwtypes::TwwOnFilterOptions OnFilterOptions = {read=FOnFilterOptions, write=SetOnFilterOptions, default=3};
	bool __fastcall SetToIndexContainingFields(System::Classes::TStrings* selected);
	bool __fastcall SetToIndexContainingField(System::UnicodeString selected);
	System::Variant __fastcall GetVariableWithParams(System::UnicodeString VariableName, const System::Variant &Params);
	System::Variant __fastcall GetVariableWithParams2(System::UnicodeString VariableName, const System::TVarRec *StartValues, const int StartValues_High, const System::TVarRec *EndValues, const int EndValues_High);
	System::Variant __fastcall GetVariable(System::UnicodeString VariableName);
	System::TObject* __fastcall GetVariableObject(System::UnicodeString VariableName, const System::Variant &Param);
	void __fastcall SetVariable(System::UnicodeString VariableName, const System::Variant &value);
	void __fastcall SetVariableObject(System::UnicodeString VariableName, System::TObject* Value);
	Data::Db::TParam* __fastcall wwFilterField(System::UnicodeString AFieldName);
	bool __fastcall wwFindRecord(System::UnicodeString KeyValue, System::UnicodeString LookupField, Vcl::Wwlocate::TwwLocateMatchType MatchType, bool CaseSensitive);
};


//-- var, const, procedure ---------------------------------------------------
extern DELPHI_PACKAGE void __fastcall Register(void);
}	/* namespace Wwtable */
}	/* namespace Vcl */
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL_WWTABLE)
using namespace Vcl::Wwtable;
#endif
#if !defined(DELPHIHEADER_NO_IMPLICIT_NAMESPACE_USE) && !defined(NO_USING_NAMESPACE_VCL)
using namespace Vcl;
#endif
#pragma pack(pop)
#pragma option pop

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// Vcl_WwtableHPP
